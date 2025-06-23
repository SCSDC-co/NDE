-- Formatter: elm-format
-- https://github.com/avh4/elm-format
-- A formatter for Elm code that enforces the Elm Style Guide

local util = require("formatter.util")

return function()
  return {
    exe = "elm-format",
    args = {
      "--stdin",
      "--yes", -- Assume yes for any prompts
    },
    stdin = true,
    try_node_modules = true,
  }
end
