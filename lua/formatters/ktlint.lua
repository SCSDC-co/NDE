local M = {}

M.name = "ktlint"
M.languages = { "kotlin" }
M.mason_package = "ktlint"
M.description = "An anti-bikeshedding Kotlin formatter with built-in style checking"

M.config = {
  command = "ktlint",
  args = {
    "--stdin",
    "--format",
    "--log-level=none",
    "--stdin-path",
    "$FILENAME"
  },
  stdin = true,
  require_cwd = true  -- ktlint needs project context
}

M.setup = function()
  -- ktlint will automatically look for .editorconfig in project
  return M.config
end

return M
