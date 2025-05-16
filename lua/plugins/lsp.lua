return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- Python
      lspconfig.pyright.setup({})

      -- JS/TS/HTML/CSS
      lspconfig.ts_ls.setup({})

      -- C / C++
      lspconfig.clangd.setup({})

      -- C#
      lspconfig.omnisharp.setup({})
    end,
  },
}
