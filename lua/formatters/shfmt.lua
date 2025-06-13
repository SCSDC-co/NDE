local M = {}

M.name = "shfmt"
M.languages = { "sh", "bash", "zsh" }
M.mason_package = "shfmt"
M.description = "Shell script formatter"

M.config = {
  prepend_args = {
    "-i", "0", -- Use tabs (0 means tabs)
    "-ci", -- Switch cases will be indented
    "-bn", -- Binary operators at beginning of line
    "-s", -- Simplify the code
    "-sr", -- Redirect operators will be followed by a space
  },
}

M.setup = function()
  return M.config
end

return M

