-- isort formatter configuration
-- Python import sorter

local M = {}

M.name = "isort"
M.languages = { "python" }
M.mason_package = "isort"
M.description = "Python import sorter"

M.config = {
  prepend_args = {
    "--profile", "black", -- Compatible with black formatter
  },
}

M.setup = function()
  return M.config
end

return M

