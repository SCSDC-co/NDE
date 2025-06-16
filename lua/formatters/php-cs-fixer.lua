-- PHP CS Fixer Formatter Configuration
-- Popular PHP code style fixer

local M = {}

-- Languages this formatter supports
M.languages = { "php" }

-- Mason package
M.mason_package = "php-cs-fixer"

-- Formatter setup for conform.nvim
function M.setup()
  return {
    command = "php-cs-fixer",
    args = {
      "fix",
      "--rules=@PSR12",
      "--using-cache=no",
      "$FILENAME",
    },
    stdin = false,
    timeout_ms = 10000,
    -- PHP CS Fixer works on files, not stdin
    tmpfile_format = ".php",
  }
end

return M

