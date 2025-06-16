-- phpcbf formatter configuration
-- PHP Code Beautifier and Fixer

local M = {}

M.name = "phpcbf"
M.languages = { "php" }
M.mason_package = "phpcbf"
M.description = "PHP Code Beautifier and Fixer - part of PHP_CodeSniffer"

M.config = {
  prepend_args = {
    "--standard=PSR12", -- Use PSR-12 coding standard
  },
}

M.setup = function()
  return M.config
end

return M

