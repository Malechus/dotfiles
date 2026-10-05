-- Adds VS Code `preLaunchTask` / `postDebugTask` support to nvim-dap.
--
-- nvim-dap reads ./.vscode/launch.json on its own but ignores these two keys, so a
-- config like "attach to JDWP on 5005 after the test runner starts" would try to attach
-- with nothing listening. This module resolves the named task from ./.vscode/tasks.json
-- (including ${workspaceFolder}, ${env:X} and ${input:X} prompts), runs it in a terminal
-- split and, for background tasks, waits for the problemMatcher's `endsPattern` before
-- handing the config back to nvim-dap.
local dap = require("dap")
local vscode = require("dap.ext.vscode")

local M = {}

-- Label -> { job = id, buf = bufnr } for the most recent run of each task
local running = {}

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "DAP tasks" })
end

local function read_tasks_json(workspace)
	local path = workspace .. "/.vscode/tasks.json"
	local fp = io.open(path, "r")
	if not fp then
		return nil, "No .vscode/tasks.json found in " .. workspace
	end
	local contents = fp:read("*a")
	fp:close()
	local ok, data = pcall(vscode.json_decode, contents, { skip_comments = true })
	if not ok then
		return nil, "Failed to parse " .. path .. ": " .. tostring(data)
	end
	return data
end

local function find_task(tasks_json, label)
	for _, task in ipairs(tasks_json.tasks or {}) do
		if task.label == label then
			return task
		end
	end
end

-- vim.ui.input / vim.ui.select may call back synchronously; scheduling the resume
-- guarantees the coroutine has actually yielded before it is resumed.
local function await(fn)
	local co = coroutine.running()
	fn(function(...)
		local args = { ... }
		vim.schedule(function()
			coroutine.resume(co, unpack(args))
		end)
	end)
	return coroutine.yield()
end

local function prompt_input(def)
	local label = def.description or def.id
	if def.type == "pickString" then
		local options = {}
		for _, opt in ipairs(def.options or {}) do
			table.insert(options, type(opt) == "table" and opt.value or opt)
		end
		return await(function(cb)
			vim.ui.select(options, { prompt = label }, cb)
		end)
	end
	return await(function(cb)
		vim.ui.input({ prompt = label .. ": ", default = def.default or "" }, cb)
	end)
end

-- Collects every ${input:id} used by the task and prompts for each once, in order.
-- Prompting happens up front because Lua can't yield from inside a string.gsub callback.
local function collect_inputs(task, tasks_json)
	local defs = {}
	for _, def in ipairs(tasks_json.inputs or {}) do
		defs[def.id] = def
	end

	local ids, seen = {}, {}
	local function scan(value)
		if type(value) == "string" then
			for id in value:gmatch("%${input:([^}]+)}") do
				if not seen[id] then
					seen[id] = true
					table.insert(ids, id)
				end
			end
		elseif type(value) == "table" then
			for _, v in pairs(value) do
				scan(v)
			end
		end
	end
	scan({ task.command, task.args, task.options })

	local values = {}
	for _, id in ipairs(ids) do
		local def = defs[id]
		if not def then
			return nil, "tasks.json has no input with id '" .. id .. "'"
		end
		local value = prompt_input(def)
		if value == nil then
			return nil, "Cancelled"
		end
		values[id] = value
	end
	return values
end

local function make_resolver(workspace, inputs)
	return function(value)
		if type(value) ~= "string" then
			return value
		end
		return (value:gsub("%${([^}]+)}", function(var)
			if var == "workspaceFolder" then
				return workspace
			elseif var == "workspaceFolderBasename" then
				return vim.fn.fnamemodify(workspace, ":t")
			end
			local env = var:match("^env:(.+)$")
			if env then
				return os.getenv(env) or ""
			end
			local input = var:match("^input:(.+)$")
			if input then
				return inputs[input]
			end
		end))
	end
end

-- "process" tasks run the command directly with an argv list; "shell" tasks get a
-- single string so jobstart runs it through the user's shell.
local function build_cmd(task, resolve)
	local command = resolve(task.command)
	local args = vim.tbl_map(resolve, task.args or {})
	if task.type == "shell" then
		local parts = { command }
		for _, arg in ipairs(args) do
			table.insert(parts, vim.fn.shellescape(arg))
		end
		return table.concat(parts, " ")
	end
	return vim.list_extend({ command }, args)
end

-- PIDs listening on a local TCP port. Uses lsof rather than a test connection because
-- JDWP accepts a single debugger connection and a probe could consume it.
local function port_listeners(port, callback)
	vim.system({ "lsof", "-nP", "-t", "-iTCP:" .. port, "-sTCP:LISTEN" }, { text = true }, function(result)
		callback(vim.trim(result.stdout or ""))
	end)
end

local function is_local_host(host)
	return host == nil or host == "localhost" or host == "127.0.0.1" or host == "::1"
end

local function ends_pattern(task)
	local matchers = task.problemMatcher
	if type(matchers) ~= "table" then
		return nil
	end
	if not vim.islist(matchers) then
		matchers = { matchers }
	end
	for _, matcher in ipairs(matchers) do
		if type(matcher) == "table" and matcher.background and matcher.background.endsPattern then
			return matcher.background.endsPattern
		end
	end
end

-- Opens a terminal split running `cmd`. `on_line` receives each complete output line
-- with ANSI colour codes stripped; the original window keeps focus.
local function run_in_terminal(label, cmd, cwd, on_line, on_exit)
	local prev = running[label]
	if prev and prev.buf and vim.api.nvim_buf_is_valid(prev.buf) then
		pcall(vim.fn.jobstop, prev.job)
		pcall(vim.api.nvim_buf_delete, prev.buf, { force = true })
	end

	local origin = vim.api.nvim_get_current_win()
	vim.cmd("botright 15new")
	local buf = vim.api.nvim_get_current_buf()

	local partial = ""
	local job = vim.fn.jobstart(cmd, {
		term = true,
		cwd = cwd,
		on_stdout = function(_, data)
			-- Terminal buffers only follow output when the cursor is on the last line, which
			-- never happens for an unfocused window, so push those windows to the end ourselves.
			vim.schedule(function()
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end
				local last = vim.api.nvim_buf_line_count(buf)
				for _, win in ipairs(vim.fn.win_findbuf(buf)) do
					if win ~= vim.api.nvim_get_current_win() then
						pcall(vim.api.nvim_win_set_cursor, win, { last, 0 })
					end
				end
			end)
			if not on_line then
				return
			end
			data[1] = partial .. data[1]
			partial = table.remove(data)
			for _, line in ipairs(data) do
				on_line((line:gsub("\27%[[%d;?]*%a", ""):gsub("\r", "")))
			end
		end,
		on_exit = function(_, code)
			if on_exit then
				on_exit(code)
			end
		end,
	})
	pcall(vim.api.nvim_buf_set_name, buf, "task://" .. label)
	vim.api.nvim_set_current_win(origin)

	running[label] = { job = job, buf = buf }
	return job
end

-- Runs a task and, if called from a coroutine, waits until it is "ready":
--   * background tasks: first output line matching problemMatcher.background.endsPattern,
--     or (when opts.ready_port is set) something listening on that local TCP port
--   * other tasks: process exit (non-zero exit code is a failure)
-- Returns true on success, or false plus an error message.
function M.run_task(label, opts)
	opts = opts or {}
	local workspace = vim.fn.getcwd()
	local tasks_json, err = read_tasks_json(workspace)
	if not tasks_json then
		return false, err
	end
	local task = find_task(tasks_json, label)
	if not task then
		return false, "No task labelled '" .. label .. "' in .vscode/tasks.json"
	end

	local inputs, input_err = collect_inputs(task, tasks_json)
	if not inputs then
		return false, input_err
	end
	local resolve = make_resolver(workspace, inputs)
	local cmd = build_cmd(task, resolve)
	local cwd = resolve(task.options and task.options.cwd) or workspace
	local reveal = task.presentation and task.presentation.reveal

	-- Fire-and-forget: silent tasks (e.g. cleanup) run without a terminal window
	if opts.detached then
		if reveal == "silent" or reveal == "never" then
			vim.fn.jobstart(cmd, {
				cwd = cwd,
				on_exit = function(_, code)
					if code ~= 0 then
						notify("Task '" .. label .. "' exited with code " .. code, vim.log.levels.WARN)
					end
				end,
			})
		else
			run_in_terminal(label, cmd, cwd)
		end
		return true
	end

	local co = coroutine.running()
	local done = false
	local function finish(ok, msg)
		if done then
			return
		end
		done = true
		vim.schedule(function()
			coroutine.resume(co, ok, msg)
		end)
	end

	local pattern = task.isBackground and ends_pattern(task)
	local regex = pattern and vim.regex("\\v" .. pattern)
	local ready_port = task.isBackground and opts.ready_port

	notify("Starting task '" .. label .. "'")
	run_in_terminal(label, cmd, cwd, regex and function(line)
		if regex:match_str(line) then
			finish(true)
		end
	end, function(code)
		if task.isBackground and (regex or ready_port) then
			finish(false, "Task '" .. label .. "' exited (code " .. code .. ") before it was ready")
		elseif code == 0 then
			finish(true)
		else
			finish(false, "Task '" .. label .. "' failed with exit code " .. code)
		end
	end)

	-- JDWP's "Listening for transport..." banner is written with C stdio, which is fully
	-- buffered when stdout is a pipe (as it is inside a surefire fork), so it may not show
	-- up until the JVM exits. Watching the debug port itself is the reliable signal.
	if ready_port then
		local timer = vim.uv.new_timer()
		timer:start(500, 500, vim.schedule_wrap(function()
			if done then
				timer:stop()
				timer:close()
				return
			end
			port_listeners(ready_port, function(pids)
				if pids ~= "" then
					finish(true)
				end
			end)
		end))
	end

	-- Background task with nothing to wait for
	if task.isBackground and not regex and not ready_port then
		return true
	end
	return coroutine.yield()
end

-- Starts a task without waiting for it. Wrapped in a coroutine because ${input:X}
-- prompts yield while waiting for the user.
function M.run_task_async(label)
	coroutine.wrap(function()
		local ok, err = M.run_task(label, { detached = true })
		if not ok then
			notify(err, vim.log.levels.ERROR)
		end
	end)()
end

function M.setup()
	-- on_config listeners run inside a coroutine (see prepare_config in dap.lua),
	-- so it is safe to yield here while prompting and waiting for the task.
	dap.listeners.on_config["vscode_pre_launch_task"] = function(config)
		if not config.preLaunchTask then
			return config
		end

		local ready_port
		if config.request == "attach" and tonumber(config.port) and is_local_host(config.hostName or config.host) then
			ready_port = tonumber(config.port)
			-- A leftover debuggee on the port would make the new JVM fail to bind, and we
			-- would silently attach to the stale one instead.
			local busy = await(function(cb) port_listeners(ready_port, cb) end)
			if busy ~= "" then
				notify(string.format(
					"Port %d is already in use (PID %s). Stop it first, e.g. :DapRunTask %s",
					ready_port, busy:gsub("\n", ", "), config.postDebugTask or "<cleanup task>"
				), vim.log.levels.ERROR)
				return vim.tbl_extend("force", config, { preLaunchTask = dap.ABORT })
			end
		end

		local ok, err = M.run_task(config.preLaunchTask, { ready_port = ready_port })
		if not ok then
			notify(err, vim.log.levels.ERROR)
			return vim.tbl_extend("force", config, { preLaunchTask = dap.ABORT })
		end
		return config
	end

	-- A session can end through several events; run postDebugTask once per session.
	local finished = {}
	local function on_end(session)
		if finished[session.id] then
			return
		end
		finished[session.id] = true
		local label = session.config and session.config.postDebugTask
		if label then
			M.run_task_async(label)
		end
	end
	for _, event in ipairs({ "event_terminated", "event_exited", "disconnect" }) do
		dap.listeners.after[event]["vscode_post_debug_task"] = on_end
	end

	-- Stops every task started from tasks.json (useful if an attach fails and the
	-- JVM is left suspended waiting for a debugger).
	vim.api.nvim_create_user_command("DapStopTasks", function()
		for label, entry in pairs(running) do
			pcall(vim.fn.jobstop, entry.job)
			running[label] = nil
		end
		notify("Stopped all tasks")
	end, {})

	-- Run any tasks.json task by label, e.g. :DapRunTask cleanup
	vim.api.nvim_create_user_command("DapRunTask", function(cmd)
		M.run_task_async(cmd.args)
	end, {
		nargs = 1,
		complete = function()
			local data = read_tasks_json(vim.fn.getcwd()) or {}
			return vim.tbl_map(function(t) return t.label end, data.tasks or {})
		end,
	})
end

return M
