-- General settings for nvim
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw 		= 1
vim.g.loaded_netrwPlugin 	= 1

-- Keep sign column always visible to prevent layout shift when LSP adds diagnostics
vim.opt.signcolumn = "yes"

-- Faster CursorHold event for snappier LSP diagnostics and hover
vim.opt.updatetime = 300
