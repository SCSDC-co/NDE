-- Formatter: zprint
-- https://github.com/kkinnear/zprint
-- A code formatter specifically designed for Clojure and related languages

local util = require("formatter.util")

return function()
  return {
    exe = "zprint",
    args = {
      "{:width 100}",
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
    try_node_modules = false,
  }
end
