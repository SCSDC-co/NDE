local M = {}

M.name = "scalafmt"
M.languages = { "scala", "sbt" }
M.mason_package = "scalafmt"
M.description = "Code formatter for Scala"

M.config = {
  prepend_args = {
    "--stdin",
  },
}

M.setup = function()
  -- scalafmt will automatically look for .scalafmt.conf in project
  return M.config
end

return M
