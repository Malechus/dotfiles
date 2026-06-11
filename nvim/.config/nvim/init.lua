local vim = vim
local Plug = vim.fn['plug#']

-- Install Plugins
vim.call('plug#begin')

Plug('windwp/nvim-autopairs')

Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })

Plug('nvim-tree/nvim-web-devicons')

Plug('nvim-tree/nvim-tree.lua')

Plug('shrynx/line-numbers.nvim')

vim.call('plug#end')

-- Move config and plugin files to separate locations, for ease of navigation
require("config.colors")
require("config.mapping")
require("config.options")

require("plugins.nvim-tree")
require("plugins.autopair")
require("plugins.line-numbers")
