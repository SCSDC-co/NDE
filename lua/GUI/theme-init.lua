-- theme-init.lua
-- Helper functions for proper theme initialization

local M = {}

function M.setup_dragon()
  local highlights = require("GUI.highlights-kanagawa-dragon")
  require("kanagawa").setup({
    theme = "dragon",
    transparent = false,
    terminalColors = false,
    dimInactive = false,
    overrides = function(colors)
      return highlights
    end,
  })
  -- Force apply highlights after colorscheme loads
  vim.schedule(function()
    for name, opts in pairs(highlights) do
      vim.api.nvim_set_hl(0, name, opts)
    end
    -- Force reload lualine with new theme
    pcall(function()
      require('lualine').setup({
        options = {
          theme = 'auto',
        }
      })
    end)
  end)
  end

function M.setup_lotus()
  local highlights = require("GUI.highlights-kanagawa-lotus")
  require("kanagawa").setup({
    theme = "lotus",
    transparent = false,
    terminalColors = false,
    dimInactive = false,
    overrides = function(colors)
      return highlights
    end,
  })
  -- Force apply highlights after colorscheme loads
  vim.schedule(function()
    for name, opts in pairs(highlights) do
      vim.api.nvim_set_hl(0, name, opts)
    end
    -- Force reload lualine with new theme
    pcall(function()
      require('lualine').setup({
        options = {
          theme = 'auto',
        }
      })
    end)
  end)
  end

return M
