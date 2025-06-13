local M = {}

-- JavaScript/TypeScript Language Server configuration
M.lsp = {
  name = "ts_ls",
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- JavaScript/TypeScript-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>jo', ':TSLspOrganizeImports<CR>', { desc = 'Organize Imports', buffer = bufnr })
    vim.keymap.set('n', '<leader>jr', ':TSLspRenameFile<CR>', { desc = 'Rename File', buffer = bufnr })
    vim.keymap.set('n', '<leader>jf', ':TSLspFixAll<CR>', { desc = 'Fix All', buffer = bufnr })
  end,
}

-- JavaScript/TypeScript debugging configuration
M.dap = {
  adapter = {
    type = 'server',
    host = '127.0.0.1',
    port = '${port}',
    executable = {
      command = 'js-debug-adapter',
      args = { '${port}' },
    },
  },
  configurations = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch Program',
      program = '${file}',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      resolveSourceMapLocations = {
        '${workspaceFolder}/**',
        '!**/node_modules/**',
      },
    },
    {
      type = 'pwa-node',
      request = 'attach',
      name = 'Attach to Node Process',
      processId = function()
        return require('dap.utils').pick_process()
      end,
      cwd = '${workspaceFolder}',
      sourceMaps = true,
    },
    {
      type = 'pwa-chrome',
      request = 'launch',
      name = 'Launch Chrome',
      url = 'http://localhost:3000',
      webRoot = '${workspaceFolder}',
      sourceMaps = true,
    },
  },
}

-- JavaScript/TypeScript formatter configuration
M.formatters = { 'prettierd', 'prettier' }
M.formatter_opts = {
  prettierd = {
    prepend_args = { '--single-quote', '--jsx-single-quote' },
  },
  prettier = {
    prepend_args = { '--single-quote', '--jsx-single-quote' },
  },
}

-- JavaScript/TypeScript-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.textwidth = 100
      
      -- Set up some useful abbreviations
      vim.cmd('iabbrev <buffer> cl console.log')
      vim.cmd('iabbrev <buffer> ce console.error')
    end,
  })
  
  -- Set up JSX/TSX file detection
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.jsx' },
    callback = function()
      vim.bo.filetype = 'javascriptreact'
    end,
  })
  
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.tsx' },
    callback = function()
      vim.bo.filetype = 'typescriptreact'
    end,
  })
end

-- Mason tools for JavaScript/TypeScript
M.mason_tools = {
  lsp = { 'ts_ls' },
  formatters = { 'prettierd', 'prettier' },
  debuggers = { 'js-debug-adapter' }, -- Modern replacement for node-debug2-adapter
}

return M

