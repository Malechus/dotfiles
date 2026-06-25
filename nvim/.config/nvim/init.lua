local vim = vim
local Plug = vim.fn['plug#']

-- Install Plugins
vim.call('plug#begin')

-- UI / Theme
Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('shrynx/line-numbers.nvim')

-- Editing
Plug('windwp/nvim-autopairs')

-- LSP
Plug('neovim/nvim-lspconfig')
Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')
Plug('Hoffs/omnisharp-extended-lsp.nvim')

-- Completion
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('L3MON4D3/LuaSnip')
Plug('saadparwaiz1/cmp_luasnip')

-- Navigation
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')

-- Syntax
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

-- Debugging
Plug('mfussenegger/nvim-dap')
Plug('rcarriga/nvim-dap-ui')
Plug('nvim-neotest/nvim-nio')
Plug('jay-babu/mason-nvim-dap.nvim')

vim.call('plug#end')

-- Core config (order matters: options sets leader before mappings read it)
require("config.options")
require("config.colors")
require("config.mapping")

-- Plugins
require("plugins.nvim-tree")
require("plugins.autopair")
require("plugins.line-numbers")
--require("plugins.lsp")
require("plugins.after.lsp.cs")
require("plugins.cmp")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.dap")


vim.lsp.enable('csharp-ls')
