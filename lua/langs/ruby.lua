-- Ruby language support configuration
local M = {}

-- Ruby Language Server configuration
M.lsp = {
  name = "solargraph",
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("Gemfile", ".git")(fname)
  end,
  settings = {
    solargraph = {
      diagnostics = true,
      completion = true,
      hover = true,
      symbols = true,
      definitions = true,
      rename = true,
      references = true,
      folding = true,
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Ruby-specific keymaps
    vim.keymap.set('n', '<leader>rb', function()
      vim.cmd('terminal bundle exec ruby ' .. vim.fn.expand('%'))
      vim.cmd('startinsert')
    end, { desc = 'Run Ruby file', buffer = bufnr })
  end,
}

-- Ruby formatter configuration
M.formatters = { 'rubocop' }

-- Ruby-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'ruby' },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "# %s"
    end,
  })
  
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.rb', 'Gemfile', 'Rakefile' },
    callback = function()
      vim.bo.filetype = 'ruby'
    end,
  })
end

-- Mason tools for Ruby
M.mason_tools = {
  lsp = { 'solargraph' },
  formatters = { 'rubocop' },
  debuggers = {},
}

return M
