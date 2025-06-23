local M = {}

M.name = "fourmolu"
M.languages = { "haskell" }
M.mason_package = "fourmolu"
M.description = "A formatter for Haskell source code"

M.config = {
  command = "fourmolu",
  args = {
    "--stdin-input-file",
    "$FILENAME",
    "--indentation", "2",
    "--column-limit", "100",
    "--sort-imports",
    "--respect-cabal-directives",
  },
  stdin = true,
}

M.setup = function()
  -- fourmolu will automatically look for fourmolu.yaml in project
  return M.config
end

return M
