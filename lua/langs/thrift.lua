-- Thrift language support configuration
local M = {}

-- Thrift has no dedicated LSP server
M.lsp = nil

-- Thrift formatter configuration
M.formatters = {}

-- Thrift-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'thrift' },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "// %s"
    end,
  })
  
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.thrift' },
    callback = function()
      vim.bo.filetype = 'thrift'
    end,
  })
end

-- Mason tools for Thrift
M.mason_tools = {
  lsp = {},
  formatters = {},
  debuggers = {},
}

return M
