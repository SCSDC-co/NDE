-- 💡 vim-illuminate: Automatically highlight other uses of word under cursor
-- Shows you where variables, functions, and symbols are used throughout your code
-- Perfect for code navigation and understanding scope

return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("illuminate").configure({
      -- Providers for getting references (LSP is best, fallback to others)
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      
      -- Delay before highlighting (milliseconds)
      delay = 500,  -- Increased from 100ms to reduce parsing frequency
      
      -- Filetypes to exclude from illumination
      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "neo-tree",
        "TelescopePrompt",
        "alpha",
        "dashboard",
        "DressingSelect",
        "mason",
        "lazy",
        "help",
        "toggleterm",
        "lspinfo",
        "spectre_panel",
        "startuptime",
        "Trouble",
        "trouble",
      },
      
      -- Filetypes to force illumination (even if normally excluded)
      filetypes_allowlist = {},
      
      -- Modes to illuminate in
      modes_denylist = {},
      
      -- Providers to exclude for certain filetypes
      providers_regex_syntax_denylist = {},
      
      -- Providers to exclude for certain modes
      providers_regex_syntax_allowlist = {},
      
      -- Don't illuminate if text under cursor contains these patterns
      under_cursor = true,
      
      -- Large file performance: disable illuminate for files larger than this
      large_file_cutoff = nil,
      
      -- Overrides for specific filetypes
      large_file_overrides = nil,
      
      -- Minimum number of matches required to illuminate
      min_count_to_highlight = 1,
      
      -- Should illuminate word under cursor
      should_enable = function(bufnr)
        return true
      end,
      
      -- Case sensitivity
      case_insensitive_regex = false,
    })
    
    -- Navigation keymaps for jumping between illuminated references
    vim.keymap.set("n", "]]", function()
      require("illuminate").goto_next_reference(false)
    end, { desc = "🔍 Next Reference" })
    
    vim.keymap.set("n", "[[", function()
      require("illuminate").goto_prev_reference(false)
    end, { desc = "🔍 Previous Reference" })
    
    -- Alternative keymaps for reference navigation
    vim.keymap.set("n", "<leader>]", function()
      require("illuminate").goto_next_reference(false)
    end, { desc = "🔍 Next Reference" })
    
    vim.keymap.set("n", "<leader>[", function()
      require("illuminate").goto_prev_reference(false)
    end, { desc = "🔍 Previous Reference" })
  end,
}
