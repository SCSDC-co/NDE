local M = {}

M.name = "black"
M.languages = { "python" }
M.mason_package = "black"
M.description = "The uncompromising Python code formatter"

M.config = {
  prepend_args = {
    "--fast",
    "--line-length", "88", -- Black's default (pythonic)
    "--skip-string-normalization", -- Don't normalize quotes
    "--target-version", "py39", -- Python 3.9+ target
  },
}

M.setup = function()
  return M.config
end

return M

