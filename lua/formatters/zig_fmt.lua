-- Zig Formatter Configuration
-- Uses Zig's built-in formatter

local M = {}

-- Languages this formatter supports
M.languages = { "zig" }

-- Mason package (none needed, zig fmt is built-in)
M.mason_package = nil

-- Formatter setup for conform.nvim
function M.setup()
  return {
    command = "zig",
    args = { "fmt", "--stdin" },
    stdin = true,
    -- Zig formatter is very fast and reliable
    timeout_ms = 3000,
    -- No temp file needed with stdin
    tmpfile_format = nil,
  }
end

return M

