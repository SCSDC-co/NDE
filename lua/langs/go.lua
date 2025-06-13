local M = {}

-- Go Language Server configuration
M.lsp = {
  name = "gopls",
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
      usePlaceholders = true,
      completeUnimported = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Go-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>gi', ':GoImports<CR>', { desc = 'Go Imports', buffer = bufnr })
    vim.keymap.set('n', '<leader>gt', ':GoTest<CR>', { desc = 'Go Test', buffer = bufnr })
    vim.keymap.set('n', '<leader>gr', ':GoRun<CR>', { desc = 'Go Run', buffer = bufnr })
  end,
}

-- Go debugging configuration
M.dap = {
  adapter = {
    type = 'server',
    port = '${port}',
    executable = {
      command = 'dlv',
      args = { 'dap', '-l', '127.0.0.1:${port}' },
    },
  },
  configurations = {
    {
      type = 'go',
      name = 'Debug',
      request = 'launch',
      program = '${file}',
    },
    {
      type = 'go',
      name = 'Debug Package',
      request = 'launch',
      program = '${workspaceFolder}',
    },
    {
      type = 'go',
      name = 'Attach',
      mode = 'local',
      request = 'attach',
      processId = function()
        return require('dap.utils').pick_process()
      end,
    },
  },
}

-- Go formatter configuration
M.formatters = { 'gofmt', 'goimports' }
M.formatter_opts = {
  gofmt = {},
  goimports = {},
}

-- Go-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = false -- Go uses tabs
      vim.opt_local.textwidth = 120
      
      -- Set up some useful abbreviations
      vim.cmd('iabbrev <buffer> iferr if err != nil {')
      vim.cmd('iabbrev <buffer> fmtp fmt.Println')
    end,
  })
end

-- Mason tools for Go
M.mason_tools = {
  lsp = { 'gopls' },
  formatters = { 'goimports' }, -- gofmt comes with Go installation, no need for mason
  debuggers = { 'go-debug-adapter' }, -- delve is now go-debug-adapter in mason
}

return M

