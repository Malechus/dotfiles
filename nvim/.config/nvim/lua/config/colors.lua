-- Set up colors and theme
--
--
require("catppuccin").setup({
	flavour = "macchiato",
	transparent_background = true,
        styles = {
           sidebars = "transparent",
           floats = "transparent",
        },
	integrations = {
		nvimtree = true
	},
	-- This is to make line numbers visible on lighter backgrounds with transparency
	highlight_overrides = {
		macchiato = function(macchiato)
			return {
				LineNr = { fg = macchiato.overlay1 }
			}
		end
	}
})

vim.cmd.colorscheme "catppuccin"
