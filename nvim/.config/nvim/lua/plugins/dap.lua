local dap = require("dap")
local dapui = require("dapui")
local mason_nvim_dap = require("mason-nvim-dap")

mason_nvim_dap.setup({
	ensure_installed = { "netcoredbg" },
	automatic_installation = true,
	handlers = {},
})

-- java-debug-adapter/java-test aren't LSP servers, so mason-lspconfig's ensure_installed
-- can't manage them; install them directly so ftplugin/java.lua's jdtls bundles resolve.
local mason_registry = require("mason-registry")
for _, pkg_name in ipairs({ "java-debug-adapter", "java-test" }) do
	local pkg = mason_registry.get_package(pkg_name)
	if not pkg:is_installed() then
		pkg:install()
	end
end

dapui.setup({
	icons = { expanded = "v", collapsed = ">", current_frame = "*" },
	layouts = {
		{
			elements = {
				{ id = "scopes",      size = 0.40 },
				{ id = "breakpoints", size = 0.20 },
				{ id = "stacks",      size = 0.20 },
				{ id = "watches",     size = 0.20 },
			},
			position = "left",
			size = 45,
		},
		{
			elements = {
				{ id = "repl",    size = 0.5 },
				{ id = "console", size = 0.5 },
			},
			position = "bottom",
			size = 12,
		},
	},
})

-- Honour preLaunchTask/postDebugTask from ./.vscode/launch.json + tasks.json, so projects
-- with VS Code debug setups (e.g. start a test runner, then JDWP attach) work unchanged.
require("plugins.dap-vscode-tasks").setup()

-- Auto-open and auto-close the DAP UI with the debug session
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

-- dap-ui only autoscrolls the console while it is the focused window, and the buffer becomes a
-- terminal (filetype cleared), so match it by name and scroll its windows on every change.
local function is_console(buf)
	return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf):match("DAP Console$") ~= nil
end

local attached_consoles = {}
local function follow_console(buf)
	if attached_consoles[buf] then
		return
	end
	attached_consoles[buf] = true
	vim.api.nvim_buf_attach(buf, false, {
		on_lines = function()
			vim.schedule(function()
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end
				local last = vim.api.nvim_buf_line_count(buf)
				for _, win in ipairs(vim.fn.win_findbuf(buf)) do
					-- Leave the focused window alone so scrolling back through output still works
					if win ~= vim.api.nvim_get_current_win() then
						pcall(vim.api.nvim_win_set_cursor, win, { last, 0 })
					end
				end
			end)
		end,
		on_detach = function()
			attached_consoles[buf] = nil
		end,
	})
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "TermOpen" }, {
	callback = function(args)
		if is_console(args.buf) then
			follow_console(args.buf)
		end
	end,
})

-- Treat .feature (cucumber) buffers like java: F5 resolves configurations by filetype, and
-- jdtls replaces dap.configurations.java at runtime, so alias lazily instead of copying.
setmetatable(dap.configurations, {
	__index = function(_, ft)
		if ft == "cucumber" then
			return rawget(dap.configurations, "java")
		end
	end,
})

-- Same for launch.json entries of type "java", which nvim-dap maps to filetypes.
local vscode_ext = require("dap.ext.vscode")
vscode_ext.type_to_filetypes = vim.tbl_extend("force", vscode_ext.type_to_filetypes or {}, {
	java = { "java", "cucumber" },
})

-- netcoredbg adapter (installed by mason into its data dir)
local mason_data = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg"
dap.adapters.coreclr = {
	type = "executable",
	command = mason_data .. "/netcoredbg",
	args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "Launch (netcoredbg)",
		request = "launch",
		-- Prompt for the DLL path at debug time so this config works across projects
		program = function()
			return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
		end,
	},
	{
		type = "coreclr",
		name = "Attach (netcoredbg)",
		request = "attach",
		processId = require("dap.utils").pick_process,
	},
}
