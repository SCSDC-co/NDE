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

function M.setup_catppuccin_mocha()
  local highlights = require("GUI.highlights-catppuccin-mocha")
  require("catppuccin").setup({
    flavour = "mocha",
    background = {
      light = "latte",
      dark = "mocha",
    },
    transparent_background = false,
    show_end_of_buffer = false,
    term_colors = false,
    dim_inactive = {
      enabled = false,
      shade = "dark",
      percentage = 0.15,
    },
    no_italic = false,
    no_bold = false,
    no_underline = false,
    styles = {
      comments = { "italic" },
      conditionals = {},
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    color_overrides = {},
    custom_highlights = function(colors)
      return highlights
    end,
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = false,
      mini = {
        enabled = true,
        indentscope_color = "",
      },
      alpha = true,
      dashboard = true,
      telescope = {
        enabled = true,
      },
      lsp_trouble = true,
      which_key = true,
      harpoon = true,
      mason = true,
      noice = true,
      leap = true,
      illuminate = {
        enabled = true,
        lsp = false,
      },
      rainbow_delimiters = true,
    },
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

function M.setup_catppuccin_latte()
  local highlights = require("GUI.highlights-catppuccin-latte")
  require("catppuccin").setup({
    flavour = "latte",
    background = {
      light = "latte",
      dark = "mocha",
    },
    transparent_background = false,
    show_end_of_buffer = false,
    term_colors = false,
    dim_inactive = {
      enabled = false,
      shade = "dark",
      percentage = 0.15,
    },
    no_italic = false,
    no_bold = false,
    no_underline = false,
    styles = {
      comments = { "italic" },
      conditionals = {},
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    color_overrides = {},
    custom_highlights = function(colors)
      return highlights
    end,
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = false,
      mini = {
        enabled = true,
        indentscope_color = "",
      },
      alpha = true,
      dashboard = true,
      telescope = {
        enabled = true,
      },
      lsp_trouble = true,
      which_key = true,
      harpoon = true,
      mason = true,
      noice = true,
      leap = true,
      illuminate = {
        enabled = true,
        lsp = false,
      },
      rainbow_delimiters = true,
    },
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
