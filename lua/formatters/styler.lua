local M = {}

M.name = "styler"
M.languages = { "r", "rmd" }
M.mason_package = "styler"
M.description = "A non-invasive pretty printer for R code"

M.config = {
  prepend_args = {
    "--style_file",
  },
}

M.setup = function()
  -- styler uses R's styler package
  return M.config
end

return M
