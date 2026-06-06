-- Set up custom keybindings
local function map(m, k, v)
	vim.keymap.set(m, k, v, { noremap = true, silent = true })
end

-- nvim-tree
map("n", "<C-o>", ":NvimTreeToggle<CR>") -- open file explorer
