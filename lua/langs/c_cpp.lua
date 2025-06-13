local M = {}

-- C/C++ Language Server configuration
M.lsp = {
  name = "clangd",
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  settings = {},
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- C/C++-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>ch', ':ClangdSwitchSourceHeader<CR>', { desc = 'Switch Header/Source', buffer = bufnr })
  end,
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}

-- C/C++ debugging configuration
M.dap = {
  adapter = {
    type = 'executable',
    command = 'lldb-vscode',
    name = 'lldb',
  },
  configurations = {
    {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    },
    {
      name = 'Attach',
      type = 'lldb',
      request = 'attach',
      pid = function()
        return require('dap.utils').pick_process()
      end,
      args = {},
    },
  },
}

-- C/C++ formatter configuration
M.formatters = { 'clang-format' }
M.formatter_opts = {
  ['clang-format'] = {
    prepend_args = {
      '--style={IndentWidth: 4, UseTab: Always, TabWidth: 4, ColumnLimit: 0, BreakBeforeBraces: Allman}'
    },
  },
}

-- C/C++-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'h', 'hpp' },
    callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = false -- Use tabs for C/C++
      vim.opt_local.textwidth = 120
      
      -- Set up some useful abbreviations
      vim.cmd('iabbrev <buffer> #i #include')
      vim.cmd('iabbrev <buffer> #d #define')
    end,
  })
  
  -- Set up file type detection for headers
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.h' },
    callback = function()
      -- Try to detect if it's C or C++ header
      local content = vim.fn.getline(1, 10)
      for _, line in ipairs(content) do
        if line:match('class%s+') or line:match('#include%s*<iostream>') or line:match('namespace%s+') then
          vim.bo.filetype = 'cpp'
          return
        end
      end
      vim.bo.filetype = 'c'
    end,
  })
end

-- Mason tools for C/C++
M.mason_tools = {
  lsp = { 'clangd' },
  formatters = { 'clang-format' },
  debuggers = { 'codelldb' },
}

return M

