local M = {}

-- Lua Language Server configuration
M.lsp = {
  name = "lua_ls",
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim', 'use', 'describe', 'it', 'assert', 'before_each', 'after_each' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true,
      },
      format = {
        enable = false, -- Use stylua instead
      },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Lua-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>lr', ':luafile %<CR>', { desc = 'Run Lua file', buffer = bufnr })
  end,
}

-- Lua debugging configuration
M.dap = {
  adapter = {
    type = 'executable',
    command = 'lua-debug-adapter',
    name = 'lua',
  },
  configurations = {
    {
      type = 'lua',
      request = 'launch',
      name = 'Launch',
      program = '${file}',
      cwd = '${workspaceFolder}',
      source = {
        filetype = 'lua',
        workspace = '${workspaceFolder}',
      },
    },
  },
}

-- Lua formatter configuration
M.formatters = { 'stylua' }
M.formatter_opts = {
  stylua = {
    prepend_args = {
      '--indent-type', 'Tabs',
      '--indent-width', '4',
      '--column-width', '999999',
      '--quote-style', 'AutoPreferSingle',
    },
  },
}

-- Lua-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = false -- Use tabs for Lua
      vim.opt_local.textwidth = 120
      
      -- Set up some useful abbreviations for Neovim Lua development
      vim.cmd('iabbrev <buffer> fn function')
      vim.cmd('iabbrev <buffer> loc local')
      vim.cmd('iabbrev <buffer> req require')
    end,
  })
end

-- Mason tools for Lua
M.mason_tools = {
  lsp = { 'lua_ls' },
  formatters = { 'stylua' },
  debuggers = { 'local-lua-debugger-vscode' },
}

return M

