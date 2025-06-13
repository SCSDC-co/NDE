return {
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = true, -- ⚡ PERFORMANCE: Only load when viewing code
    event = { "BufReadPost", "BufNewFile" }, -- Load after buffer is fully loaded
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
        highlight = "IndentBlanklineChar",
      },
      scope = {
        enabled = true,
        highlight = "IndentBlanklineContextChar",
      },
      exclude = {
        filetypes = {
          "help", "terminal", "dashboard", "alpha", "packer", "lspinfo",
          "TelescopePrompt", "TelescopeResults", "mason", "neo-tree",
        },
      },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
    end,
  },
}
