return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  config = function()
    require("hardtime").setup({
      -- Maximum count of repeated key presses allowed within the max_time period
      max_count = 6,
      
      -- Maximum time (in milliseconds) to consider key presses as repeated
      max_time = 1000,
      
      -- Enable hardtime by default (but check saved state)
      enabled = vim.g.nde_hardmode_enabled ~= false,
      
      -- Disable mouse support
      disable_mouse = true,
      
      -- Enable hint messages for better commands
      hint = true,
      
      -- Enable notification messages for restricted and disabled keys
      notification = true,
      
      -- Time to show notification in milliseconds
      timeout = 3000,
      
      -- Allow different keys to reset the count
      allow_different_key = true,
      
      -- The behavior when restricted_keys trigger count mechanism
      restriction_mode = "block",
      
      -- Disable hardtime for specific filetypes
      disabled_filetypes = {
        "qf",
        "netrw",
        "NvimTree",
        "lazy",
        "mason",
        "oil",
        "neo-tree",
        "aerial",
        "TelescopePrompt",
        "dashboard",
        "alpha",
        "trouble",
        "lspinfo",
        "toggleterm",
        "Avante",
      },
    })
    
    -- Restore previous state if it was saved
    vim.defer_fn(function()
      if vim.g.nde_hardmode_enabled == false then
        require("hardtime").disable()
      elseif vim.g.nde_hardmode_enabled == true then
        require("hardtime").enable()
      end
    end, 100)
  end,
}
