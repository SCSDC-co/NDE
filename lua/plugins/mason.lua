return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "omnisharp",
          "pyright",
          "asm_lsp",
          "cssls",
          "html",
          "lua_ls",
        },
        automatic_installation = true,
      })
    end,
  },
}
