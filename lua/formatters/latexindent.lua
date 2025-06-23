local M = {}

M.name = "latexindent"
M.languages = { "tex", "latex" }
M.mason_package = "latexindent"
M.description = "Perl script to add indentation to LaTeX files"

M.config = {
  prepend_args = {
    "-g", "/dev/stderr",
  },
}

M.setup = function()
  return M.config
end

return M
