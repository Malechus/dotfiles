local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('windwp/nvim-autopairs')

Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })

vim.call('plug#end')

require("nvim-autopairs").setup {}

require("catppuccin").setup({
	flavour = "macchiato",
	transparent_background = true,
        styles = {
           sidebars = "transparent",
           floats = "transparent",
        },
})

vim.cmd.colorscheme "catppuccin"
