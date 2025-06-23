local M = {}

M.name = "alejandra"
M.languages = { "nix" }
M.mason_package = "alejandra"
M.description = "The uncompromising Nix code formatter"

M.config = {
  command = "alejandra",
  args = {
    "--quiet",  -- Reduce noise in output
    "-" -- Read from stdin
  },
  stdin = true,
}

M.setup = function()
  -- alejandra has minimal configuration; it enforces a standard style
  return M.config
end

return M
