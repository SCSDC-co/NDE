return {
  "m-demare/hlargs.nvim",
  event = "VeryLazy",
  opts = {
    color = "#FF9E3B",
    highlight = {},
    excluded_filetypes = {},
    disable = function(_, bufnr)
      if vim.b[bufnr].semantic_tokens then
        return true
      end
      local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
      for _, c in pairs(clients) do
        local caps = c.server_capabilities
        if c.name ~= "null-ls" and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
          vim.b[bufnr].semantic_tokens = true
          return vim.b[bufnr].semantic_tokens
        end
      end
    end,
  },
}
