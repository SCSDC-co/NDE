-- SQL language support configuration
local M = {}

-- SQL Language Server configuration
M.lsp = {
  name = "sqlls",
  cmd = { "sql-language-server", "up", "--method", "stdio" },
  filetypes = { "sql", "mysql", "plsql" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern(".git")(fname)
  end,
  settings = {
    sqlLanguageServer = {
      connections = {},
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- SQL-specific keymaps
    vim.keymap.set('n', '<leader>qr', function()
      vim.cmd('terminal mysql -u root -p')
      vim.cmd('startinsert')
    end, { desc = 'Connect to MySQL', buffer = bufnr })
  end,
}

-- SQL formatter configuration
M.formatters = { 'sql-formatter' }

-- SQL-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'sql', 'mysql', 'plsql' },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "-- %s"
    end,
  })
  
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.sql', '*.mysql', '*.plsql' },
    callback = function()
      vim.bo.filetype = 'sql'
    end,
  })
end

-- Mason tools for SQL
M.mason_tools = {
  lsp = { 'sqlls' },
  formatters = { 'sql-formatter' },
  debuggers = {},
}

return M
