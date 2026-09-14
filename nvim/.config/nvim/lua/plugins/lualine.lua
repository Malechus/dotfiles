require("lualine").setup({
  options = {
    theme = "catppuccin-macchiato",
  },
  sections = {
    lualine_b = { "branch", "diff", "diagnostics" },
  },
})
