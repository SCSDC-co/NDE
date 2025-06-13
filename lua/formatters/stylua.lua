local M = {}

M.name = "stylua"
M.languages = { "lua" }
M.mason_package = "stylua"
M.description = "An opinionated Lua code formatter"

M.config = {
  prepend_args = {
    "--indent-type", "Tabs", -- Use tabs
    "--indent-width", "4", -- 4 spaces per tab
    "--column-width", "120", -- Line width
    "--quote-style", "AutoPreferSingle", -- Prefer single quotes
    "--call-parentheses", "Always", -- Always use parentheses in calls
  },
}

M.setup = function()
  -- stylua will look for stylua.toml or .stylua.toml in project
  return M.config
end

return M

