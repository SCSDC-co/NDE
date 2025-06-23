-- Rego language support configuration
local M = {}

-- Rego Language Server configuration
M.lsp = {
  name = "rego_ls",
  cmd = { "rego-language-server" },
  filetypes = { "rego" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern(".git")(fname)
  end,
  settings = {},
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Rego-specific keymaps
    vim.keymap.set('n', '<leader>re', function()
      vim.cmd('terminal opa eval -d . "data"')
      vim.cmd('startinsert')
    end, { desc = 'OPA eval', buffer = bufnr })
  end,
}

-- Rego formatter configuration
M.formatters = {}

-- Rego-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'rego' },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "# %s"
    end,
  })
  
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.rego' },
    callback = function()
      vim.bo.filetype = 'rego'
    end,
  })
end

-- Mason tools for Rego
M.mason_tools = {
  lsp = { 'regols' },
  formatters = {},
  debuggers = {},
}

return M
