local M = {}

M.name = "csharpier"
M.languages = { "cs", "csharp" }
M.mason_package = "csharpier"
M.description = "An opinionated code formatter for C#"

M.config = {
  prepend_args = {
    "--write-stdout",
  },
}

M.setup = function()
  -- csharpier will automatically look for .csharpierrc in project
  return M.config
end

return M
