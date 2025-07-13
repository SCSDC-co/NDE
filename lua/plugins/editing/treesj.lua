return {
  "Wansmer/treesj",
  keys = {
    { "<leader>M", "<cmd>TSJToggle<cr>", desc = "Toggle Treesitter Join" },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
      check_syntax_error = true,
      max_join_length = 120,
      cursor_behavior = "hold",
      notify = true,
    })
  end,
}
