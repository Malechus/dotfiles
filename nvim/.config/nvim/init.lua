local vim = vim
local Plug = vim.fn['plug#']

-- Disable netrw, in favor of nvim-tree
vim.g.loaded_netrw 		= 1
vim.g.loaded_netrwPlugin 	= 1

-- Install Plugins
vim.call('plug#begin')

Plug('windwp/nvim-autopairs')

Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })

Plug('nvim-tree/nvim-web-devicons')

Plug('nvim-tree/nvim-tree.lua')

vim.call('plug#end')

-- Setup Plugins
require("nvim-autopairs").setup {}

require("catppuccin").setup({
	flavour = "macchiato",
	transparent_background = true,
        styles = {
           sidebars = "transparent",
           floats = "transparent",
        },
})

require("nvim-tree").setup () 

-- Keybindings
local function map(m, k, v)
	vim.keymap.set(m, k, v, { noremap = true, silent = true})
end
-- nvim-tree
map("n", "<C-o>", ":NvimTreeToggle<CR>") --open file explorer

-- Set theme
vim.cmd.colorscheme "catppuccin"
