-- Zig Language Configuration
-- Fast systems programming language with dynamic loading support

local M = {}

-- LSP Configuration
M.lsp = {
  name = "zls",
  config = {
    settings = {
      zls = {
        enable_snippets = true,
        enable_unused_variable_warnings = true,
        enable_semantic_tokens = true,
        enable_inlay_hints = true,
        inlay_hints_show_builtin = true,
        inlay_hints_exclude_single_argument = true,
        warn_style = true,
        highlight_global_var_declarations = false,
        prefer_ast_check_as_child_process = true,
        completion_label_details = true
      }
    },
    filetypes = { "zig", "zir" },
    root_dir = function(fname)
      return require('lspconfig.util').root_pattern("build.zig", ".git")(fname)
    end,
  }
}

-- Debug Configuration (using LLDB)
M.dap = {
  adapters = {
    lldb = {
      type = "executable",
      command = "/usr/bin/lldb-vscode",
      name = "lldb"
    }
  },
  configurations = {
    {
      name = "Launch Zig",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/zig-out/bin/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
    },
  }
}

-- Mason tools needed
M.mason_tools = {
  lsp = { "zls" },
  debuggers = { "codelldb" },
  formatters = {} -- Zig has built-in formatter
}

-- File extensions this language handles
M.extensions = { "zig", "zir" }

-- Formatter configuration (Zig built-in)
M.formatters = { "zig_fmt" }

-- Linter configuration
M.linters = {
  {
    name = "zig_check",
    command = "zig",
    args = { "ast-check", "%filepath" },
    stream = "stderr",
    ignore_exitcode = true
  }
}

-- Zig specific keymaps and settings
local function setup_zig_keymaps()
  local map = vim.keymap.set
  
  -- Zig specific commands
  map('n', '<leader>zr', '<cmd>!zig run %<cr>', { desc = 'Run current Zig file', buffer = true })
  map('n', '<leader>zt', '<cmd>!zig test %<cr>', { desc = 'Test current Zig file', buffer = true })
  map('n', '<leader>zf', '<cmd>!zig fmt %<cr>', { desc = 'Format current Zig file', buffer = true })
  map('n', '<leader>zb', '<cmd>!zig build<cr>', { desc = 'Build Zig project', buffer = true })
  map('n', '<leader>zbr', '<cmd>!zig build run<cr>', { desc = 'Build and run Zig project', buffer = true })
  map('n', '<leader>zbt', '<cmd>!zig build test<cr>', { desc = 'Build and test Zig project', buffer = true })
end

-- Zig specific autocmds
local function setup_zig_autocmds()
  local group = vim.api.nvim_create_augroup('ZigConfig', { clear = true })
  
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'zig',
    group = group,
    callback = function()
      -- Zig specific settings
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
      
      -- Set up keymaps
      setup_zig_keymaps()
    end,
  })
end

-- Setup function
function M.setup()
  setup_zig_autocmds()
  
  -- Add Zig snippets if available
  if pcall(require, 'luasnip') then
    local ls = require('luasnip')
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    
    ls.add_snippets('zig', {
      s('main', {
        t('pub fn main() !void {'),
        t({'', '    '}), i(1),
        t({'', '}'})
      }),
      s('test', {
        t('test "'), i(1, 'test name'), t('" {'),
        t({'', '    '}), i(2),
        t({'', '}'})
      }),
      s('fn', {
        t('fn '), i(1, 'name'), t('('), i(2), t(') '), i(3, 'void'), t(' {'),
        t({'', '    '}), i(4),
        t({'', '}'})
      })
    })
  end
end

return M

