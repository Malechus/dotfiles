local dap = require("dap")
local dapui = require("dapui")
local mason_nvim_dap = require("mason-nvim-dap")

mason_nvim_dap.setup({
	ensure_installed = { "netcoredbg" },
	automatic_installation = true,
	handlers = {},
})

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

-- Auto-open and auto-close the DAP UI with the debug session
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

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
