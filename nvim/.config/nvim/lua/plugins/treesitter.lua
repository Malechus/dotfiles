require("nvim-treesitter").setup({
	ensure_installed = { "c_sharp", "lua", "vim", "vimdoc" },
	sync_install = false,
	auto_install = false,
	highlight = {
		enable = true,
		-- Disable treesitter highlight on very large files to keep performance
		disable = function(_, buf)
			local max_filesize = 500 * 1024 -- 500 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},
	indent = { enable = true },
})
