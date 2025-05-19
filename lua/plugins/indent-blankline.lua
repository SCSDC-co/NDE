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
      -- PRIMA definisci i colori, così le highlight group esistono
      vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#f3f3f3", bg = "NONE" })
      vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "#f3f3f3", bg = "NONE" })

      -- POI setup del plugin
      require("ibl").setup(opts)
    end,
  },
}
