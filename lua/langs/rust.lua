local M = {}

-- Rust Language Server configuration (using rustaceanvim)
M.lsp = {
  name = "rust_analyzer",
  -- This will be handled by rustaceanvim plugin
  managed_by_plugin = true,
  plugin = "mrcjkb/rustaceanvim",
}

-- Rust debugging configuration
M.dap = {
  adapter = {
    type = "executable",
    command = "lldb-vscode",
    name = "rt_lldb",
  },
  configurations = {
    {
      name = "Launch",
      type = "rt_lldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    },
  },
}

-- Rust formatter configuration
M.formatters = { 'rustfmt' }
M.formatter_opts = {
  rustfmt = {
    prepend_args = { '--edition', '2021' },
  },
}

-- Rust-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'rust',
    callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = true
      vim.opt_local.textwidth = 100
    end,
  })
end

-- Mason tools for Rust
M.mason_tools = {
  lsp = { 'rust_analyzer' },
  formatters = { 'rustfmt' },
  debuggers = { 'codelldb' },
}

-- Rustaceanvim configuration
M.rustaceanvim_config = {
  tools = {
    autoSetHints = true,
    runnables = { use_telescope = true },
    debuggables = { use_telescope = true },
    reload_workspace_from_cargo_toml = true,
    inlay_hints = {
      auto = true,
      only_current_line = false,
      show_parameter_hints = true,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = "=> ",
      max_len_align = false,
      max_len_align_padding = 1,
      right_align = false,
      right_align_padding = 7,
      highlight = "Comment",
    },
    hover_actions = {
      border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      },
      max_width = nil,
      max_height = nil,
      auto_focus = false,
    },
  },
  server = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
        },
        checkOnSave = {
          allFeatures = true,
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
        procMacro = {
          enable = true,
          ignored = {
            ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },
        },
        experimental = {
          procAttrMacros = true,
        },
        inlayHints = {
          bindingModeHints = { enable = false },
          chainingHints = { enable = true },
          closingBraceHints = {
            enable = true,
            minLines = 25,
          },
          closureReturnTypeHints = { enable = "never" },
          lifetimeElisionHints = {
            enable = "never",
            useParameterNames = false,
          },
          maxLength = 25,
          parameterHints = { enable = true },
          reborrowHints = { enable = "never" },
          renderColons = true,
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
        },
      },
    },
  },
}

return M

