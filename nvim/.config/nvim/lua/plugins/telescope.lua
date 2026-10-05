local telescope = require("telescope")

telescope.setup({
	defaults = {
		layout_strategy = "horizontal",
		layout_config = { preview_width = 0.55 },
		path_display = { "truncate" },
		-- live_grep: include hidden files, but skip .git
		vimgrep_arguments = {
			"rg", "--color=never", "--no-heading", "--with-filename",
			"--line-number", "--column", "--smart-case",
			"--hidden", "--glob", "!**/.git/*",
		},
	},
	pickers = {
		find_files = {
			-- include hidden files/dirs, but skip .git
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
	},
})
