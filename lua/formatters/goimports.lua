-- goimports formatter configuration
-- Go imports organizer and formatter

local M = {}

M.name = "goimports"
M.languages = { "go" }
M.mason_package = "goimports"
M.description = "Go imports organizer and formatter"

M.config = {
  prepend_args = {},
}

M.setup = function()
  return M.config
end

return M

