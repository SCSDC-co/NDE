local M = {}

M.name = "taplo"
M.languages = { "toml" }
M.mason_package = "taplo"
M.description = "A TOML toolkit written in Rust"

M.config = {
  prepend_args = {
    "format",
    "-",
  },
}

M.setup = function()
  -- taplo will automatically look for .taplo.toml in project
  return M.config
end

return M
