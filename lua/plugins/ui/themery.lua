return {
  "zaldih/themery.nvim",
  lazy = false,
  priority = 1000,
  keys = {
    { "<leader>th", "<cmd>Themery<cr>", desc = "Open Themery" },
  },
  config = function()
    require("themery").setup({
      themes = {
        {
          name = "Kanagawa Dragon",
          colorscheme = "kanagawa-dragon",
          before = [[
            require("GUI.theme-init").setup_dragon()
          ]],
        },
        {
          name = "Kanagawa Lotus",
          colorscheme = "kanagawa-lotus",
          before = [[
            require("GUI.theme-init").setup_lotus()
          ]],
        },
        {
          name = "Catppuccin Mocha",
          colorscheme = "catppuccin-mocha",
          before = [[
            require("GUI.theme-init").setup_catppuccin_mocha()
          ]],
        },
        {
          name = "Catppuccin Latte",
          colorscheme = "catppuccin-latte",
          before = [[
            require("GUI.theme-init").setup_catppuccin_latte()
          ]],
        },
      },
      -- Live preview while navigating themes
      livePreview = true,
      -- Auto-save theme preference
      -- themeConfigFile = vim.fn.stdpath("config") .. "/lua/settings/theme.lua",
    })
    
    -- Initialize default theme on first load only
    if vim.g.colors_name == nil then
      require("GUI.theme-init").setup_dragon()
      vim.cmd("colorscheme kanagawa-dragon")
    end
  end,
}
