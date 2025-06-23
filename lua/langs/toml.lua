-- TOML language support configuration
local M = {}

-- TOML Language Server configuration
M.lsp = {
  name = "taplo",
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("Cargo.toml", "pyproject.toml", ".git")(fname)
  end,
  settings = {
    evenBetterToml = {
      schema = {
        enabled = true,
        catalogs = {
          "https://www.schemastore.org/api/json/catalog.json",
        },
      },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by taplo)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}

-- TOML formatter configuration
M.formatters = { 'taplo' }

-- TOML-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'toml' },
    callback = function()
      -- TOML indentation settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "# %s"
      vim.opt_local.smartindent = true
      
      -- Set folding for TOML files
      vim.opt_local.foldmethod = "indent"
      vim.opt_local.foldenable = false -- Start with folds open
      
      -- Completion settings
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })
  
  -- Detect TOML files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.toml' },
    callback = function()
      vim.bo.filetype = 'toml'
    end,
  })
end

-- Mason tools for TOML
M.mason_tools = {
  lsp = { 'taplo' },
  formatters = { 'taplo' },
  debuggers = {},
}

return M
