-- Set up custom keybindings
local function map(m, k, v)
	vim.keymap.set(m, k, v, { noremap = true, silent = true })
end

-- nvim-tree
map("n", "<C-o>", ":NvimTreeToggle<CR>") -- open file explorer

-- Telescope (lazy-required so startup doesn't fail before PlugInstall)
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end)   -- find files by name
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end)    -- grep across project
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end)      -- list open buffers
map("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end)     -- recently opened files

-- LSP bindings (only active when a language server is attached to the buffer)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
	callback = function(event)
		local opts = { noremap = true, silent = true, buffer = event.buf }

		-- Navigation
		vim.keymap.set("n", "gd", function() require("omnisharp_extended").lsp_definitions() end, opts) -- go to definition (handles decompiled sources)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)                                         -- go to declaration
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)                                      -- go to implementation
		vim.keymap.set("n", "gr", function() require("telescope.builtin").lsp_references() end, opts)    -- find all references (in telescope)
		vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)                                               -- hover documentation

		-- Refactoring
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)       -- rename symbol
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)  -- code actions
		vim.keymap.set("n", "<leader>f",  vim.lsp.buf.format, opts)       -- format buffer

		-- Diagnostics
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)  -- previous diagnostic
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)  -- next diagnostic
	end,
})

-- DAP (debugger) — F-key layout matches VS Code defaults
map("n", "<F5>",       function() require("dap").continue() end)           -- start / continue
map("n", "<F10>",      function() require("dap").step_over() end)          -- step over
map("n", "<F11>",      function() require("dap").step_into() end)          -- step into
map("n", "<F12>",      function() require("dap").step_out() end)           -- step out
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end)  -- toggle breakpoint
map("n", "<leader>du", function() require("dapui").toggle() end)           -- toggle DAP UI
