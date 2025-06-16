local M = {}

-- Python Language Server configuration
M.lsp = {
  name = "pyright",
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "basic",
      },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Python-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>po', ':PyrightOrganizeImports<CR>', { desc = 'Organize Imports', buffer = bufnr })
  end,
}

-- Python debugging configuration
M.dap = {
  adapter = {
    type = 'executable',
    command = 'python',
    args = { '-m', 'debugpy.adapter' },
  },
  configurations = {
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      pythonPath = function()
        -- Try to find virtual environment python
        local venv = os.getenv('VIRTUAL_ENV')
        if venv then
          return venv .. '/bin/python'
        end
        return '/usr/bin/python'
      end,
    },
    {
      type = 'python',
      request = 'launch',
      name = 'Launch module',
      module = '',
      pythonPath = function()
        local venv = os.getenv('VIRTUAL_ENV')
        if venv then
          return venv .. '/bin/python'
        end
        return '/usr/bin/python'
      end,
    },
  },
}

-- Python formatter configuration
M.formatters = { 'black', 'isort' }

-- Python-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = true
      vim.opt_local.textwidth = 88
    end,
  })
end

-- Mason tools for Python
M.mason_tools = {
  lsp = { 'pyright' },
  formatters = { 'black', 'isort' },
  debuggers = { 'debugpy' },
}

return M

