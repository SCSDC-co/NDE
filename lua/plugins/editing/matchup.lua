return {
  "andymass/vim-matchup",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    -- Enable matchup for Treesitter
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_hi_surround_always = 1
    
    -- Disable matchit (we use matchup instead)
    vim.g.loaded_matchit = 1
  end,
  config = function()
    -- Configure treesitter integration (only when treesitter is loaded)
    require("nvim-treesitter.configs").setup({
      matchup = {
        enable = true,
        disable_virtual_text = true, -- Disable annoying virtual text annotations
        include_match_words = true,
      },
    })
  end,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}
