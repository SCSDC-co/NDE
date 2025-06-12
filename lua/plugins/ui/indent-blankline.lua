return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
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
