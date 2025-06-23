-- Formatter: erlfmt
-- https://github.com/WhatsApp/erlfmt
-- A formatter for Erlang code with sensible defaults

local util = require("formatter.util")

return function()
  local file_path = util.escape_path(util.get_current_buffer_file_path())
  
  -- Check if we're in a rebar3 project
  local rebar_config = vim.fn.findfile("rebar.config", ".;")
  
  if rebar_config ~= "" then
    -- If in a rebar3 project, use rebar3 to run erlfmt
    return {
      exe = "rebar3",
      args = {
        "fmt",
        "--",
        file_path,
      },
      stdin = false,
      transform = function(text)
        -- rebar3 fmt modifies the file in place
        return text
      end,
    }
  else
    -- Otherwise use erlfmt directly
    return {
      exe = "erlfmt",
      args = {
        "--write",
        file_path,
      },
      stdin = false,
      transform = function(text)
        -- erlfmt modifies the file in place
        return text
      end,
    }
  end
end
