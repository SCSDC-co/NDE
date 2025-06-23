-- Formatter: cmake-format
-- https://github.com/cheshirekow/cmake_format
-- A tool for formatting CMake files

local util = require("formatter.util")

return function()
  return {
    exe = "cmake-format",
    args = {
      "--line-width=100",
      "--tab-size=2",
      "--enable-markup=true",
      "-",
    },
    stdin = true,
    try_node_modules = false,
  }
end
