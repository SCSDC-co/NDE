local M = {}

M.name = "prisma-fmt"
M.languages = { "prisma" }
M.mason_package = "prisma-language-server"
M.description = "Prisma schema formatter"

M.config = {
  prepend_args = {
    "format",
  },
}

M.setup = function()
  return M.config
end

return M
