-- 🏆 legendary.nvim: A command palette for discovering and executing commands
-- Perfect for finding keymaps, commands, and functions you forgot about
-- Makes your nvim setup more discoverable and accessible

return {
  "mrjones2014/legendary.nvim",
  version = "v2.13.9",
  lazy = true,
  dependencies = {
    "kkharji/sqlite.lua",
    "stevearc/dressing.nvim",
  },
  keys = {
    { "<leader>L", function() require("legendary").find() end, desc = "🏆 Legendary Command Palette" },
    { "<C-p>", function() require("legendary").find() end, desc = "🏆 Legendary Palette" },
    { "<leader>Lk", function() require("legendary").find({ filters = { require("legendary.filters").keymaps() } }) end, desc = "🗝️ Find Keymaps" },
    { "<leader>Lc", function() require("legendary").find({ filters = { require("legendary.filters").commands() } }) end, desc = "⚡ Find Commands" },
    { "<leader>Lf", function() require("legendary").find({ filters = { require("legendary.filters").funcs() } }) end, desc = "🔧 Find Functions" },
    { "<leader>La", function() require("legendary").find({ filters = { require("legendary.filters").autocmds() } }) end, desc = "🤖 Find Autocmds" },
  },
  config = function()
    require("legendary").setup({
      
      -- Automatically add keymaps from which-key.nvim
      auto_register = true,
      
      -- Show hidden keymaps and commands
      include_builtin = true,
      include_legendary_cmds = true,
      
      -- UI configuration
      col_separator_char = "│",
      default_opts = {
        keymaps = { silent = true },
        commands = {},
        autocmds = {},
      },
      
      -- Sorting configuration
      sort = {
        most_recent_first = true,
        user_items_first = true,
        frecency = {
          db_root = string.format("%s/legendary/", vim.fn.stdpath("data")),
          max_timestamps = 10,
        },
      },
      
      -- Cache configuration for performance
      cache_path = string.format("%s/legendary/", vim.fn.stdpath("cache")),
      log_level = "warn",
      
      -- UI theming
      select_prompt = " Legendary ",
      select_opts = {},
      
      -- Formatter for items in the UI
      formatter = nil,
      
      -- Custom items (add your own commands, keymaps, etc.)
      keymaps = {
        -- Legendary-specific keymaps
        {
          "<leader>Lk",
          function() require("legendary").find({ filters = { require("legendary.filters").keymaps() } }) end,
          description = "🗝️ Find Keymaps",
        },
        {
          "<leader>Lc",
          function() require("legendary").find({ filters = { require("legendary.filters").commands() } }) end,
          description = "⚡ Find Commands",
        },
        {
          "<leader>Lf",
          function() require("legendary").find({ filters = { require("legendary.filters").funcs() } }) end,
          description = "🔧 Find Functions",
        },
        {
          "<leader>La",
          function() require("legendary").find({ filters = { require("legendary.filters").autocmds() } }) end,
          description = "🤖 Find Autocmds",
        },
        {
          "<C-p>",
          function() require("legendary").find() end,
          description = "🏆 Legendary Command Palette",
        },
      },
      
      commands = {
        -- Custom commands for better workflow
        {
          ":LegendaryRepeat",
          function() require("legendary").repeat_previous() end,
          description = "🔄 Repeat Last Legendary Action",
        },
      },
      
      -- Functions that can be executed from legendary
      funcs = {
        {
          function() vim.cmd("Lazy") end,
          description = "📦 Open Lazy Plugin Manager",
        },
        {
          function() vim.cmd("Mason") end,
          description = "🔨 Open Mason Tool Manager",
        },
        {
          function() vim.cmd("checkhealth") end,
          description = "🏥 Check Neovim Health",
        },
        {
          function() 
            local config_path = vim.fn.stdpath("config")
            vim.cmd("edit " .. config_path .. "/init.lua")
          end,
          description = "⚙️ Edit Neovim Config",
        },
      },
      
      -- Scratchpad for temporary items
      scratchpad = {
        view = "float",
        results_view = "float",
        keep_contents = true,
      },
      
      -- Extensions configuration (updated from deprecated config)
      extensions = {
        nvim_tree = false,
        smart_splits = {
          directions = { 'h', 'j', 'k', 'l' },
          mods = {
            move = '<C>',
            resize = '<M>',
          },
        },
        op_nvim = false,
        diffview = false,
        -- Lazy.nvim integration (moved from lazy_nvim)
        lazy_nvim = true,
        -- Which-key integration (moved from which_key)
        which_key = {
          auto_register = true,
          do_binding = false,
          use_groups = true,
        },
      },
    })
    
    -- Main legendary keymap
    vim.keymap.set("n", "<leader>L", function() 
      require("legendary").find() 
    end, { desc = "🏆 Legendary Command Palette" })
    
    -- Quick filters for specific item types
    vim.keymap.set("n", "<leader>Ll", function() 
      require("legendary").find() 
    end, { desc = "🏆 Legendary - All Items" })
  end,
}
