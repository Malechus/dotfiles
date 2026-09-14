-- General settings for nvim
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw 		= 1
vim.g.loaded_netrwPlugin 	= 1

-- Keep sign column always visible to prevent layout shift when LSP adds diagnostics
vim.opt.signcolumn = "yes"

-- Faster CursorHold event for snappier LSP diagnostics and hover
vim.opt.updatetime = 300

-- Complete shell commands and paths with Tab after :!. The first Tab expands the
-- longest common match and shows candidates; subsequent presses cycle through them.
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest:full", "full" }
