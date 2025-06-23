local M = {}

M.name = "rubocop"
M.languages = { "ruby" }
M.mason_package = "rubocop"
M.description = "A Ruby static code analyzer and formatter"

M.config = {
  prepend_args = {
    "--auto-correct",
    "--stderr",
    "--format", "quiet",
    "--stdin", "$FILENAME",
  },
}

M.setup = function()
  -- rubocop will automatically look for .rubocop.yml in project
  return M.config
end

return M
