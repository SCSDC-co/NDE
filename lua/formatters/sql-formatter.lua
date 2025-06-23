local M = {}

M.name = "sql-formatter"
M.languages = { "sql", "mysql", "plsql" }
M.mason_package = "sql-formatter"
M.description = "A whitespace formatter for different query languages"

M.config = {
  prepend_args = {
    "--language", "sql",
  },
}

M.setup = function()
  return M.config
end

return M
