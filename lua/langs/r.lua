-- R language support configuration
local M = {}

-- R Language Server configuration
M.lsp = {
  name = "r_language_server",
  cmd = { "R", "--slave", "-e", "languageserver::run()" },
  filetypes = { "r", "rmd" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern(".git")(fname)
  end,
  settings = {
    r = {
      lsp = {
        rich_documentation = false,
      },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- R-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Send line to R console
    vim.keymap.set('n', '<leader>rr', function()
      vim.cmd('terminal R')
      vim.cmd('startinsert')
    end, { desc = 'Start R console', buffer = bufnr })
  end,
}

-- R formatter configuration
M.formatters = { 'styler' }

-- R-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'r', 'rmd' },
    callback = function()
      -- R indentation settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "# %s"
      vim.opt_local.smartindent = true
    end,
  })
  
  -- Detect R files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.r', '*.R', '*.rmd', '*.Rmd' },
    callback = function()
      local ext = vim.fn.expand('%:e'):lower()
      if ext == 'rmd' then
        vim.bo.filetype = 'rmd'
      else
        vim.bo.filetype = 'r'
      end
    end,
  })
end

-- Mason tools for R
M.mason_tools = {
  lsp = { 'r_language_server' },
  formatters = { 'styler' },
  debuggers = {},
}

return M
