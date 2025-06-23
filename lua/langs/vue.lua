-- Vue language support configuration
local M = {}

-- Vue Language Server configuration
M.lsp = {
  name = "volar",
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("package.json", ".git")(fname)
  end,
  settings = {
    vue = {
      complete = {
        casing = {
          tags = "kebab",
          props = "camel"
        }
      }
    }
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by prettierd)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}

-- Vue formatter configuration (uses prettierd)
M.formatters = { 'prettierd' }

-- Vue-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'vue' },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "<!-- %s -->"
    end,
  })
  
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.vue' },
    callback = function()
      vim.bo.filetype = 'vue'
    end,
  })
end

-- Mason tools for Vue
M.mason_tools = {
  lsp = { 'vue_ls' },
  formatters = { 'prettierd' },
  debuggers = {},
}

return M
