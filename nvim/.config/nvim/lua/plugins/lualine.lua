-- Cache repo-root -> repo-name lookups so we don't shell out on every redraw.
local repo_name_cache = {}

local function repo_name()
  local cwd = vim.fn.getcwd()
  local cached = repo_name_cache[cwd]
  if cached ~= nil then
    return cached ~= false and cached or nil
  end

  local root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(cwd) .. " rev-parse --show-toplevel")[1]
  local name = (vim.v.shell_error == 0 and root and root ~= "") and vim.fn.fnamemodify(root, ":t") or false
  repo_name_cache[cwd] = name

  return name ~= false and name or nil
end

require("lualine").setup({
  options = {
    theme = "catppuccin-macchiato",
  },
  sections = {
    lualine_b = {
      {
        "branch",
        fmt = function(branch)
          local name = repo_name()
          if name and branch ~= "" then
            return name .. "/" .. branch
          end
          return branch
        end,
      },
      "diff",
      "diagnostics",
    },
  },
})
