local telescope = require("telescope")

telescope.setup({
	defaults = {
		layout_strategy = "horizontal",
		layout_config = { preview_width = 0.55 },
		path_display = { "truncate" },
	},
})
