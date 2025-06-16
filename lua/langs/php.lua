-- PHP Language Configuration
-- Popular web development language with dynamic loading support

local M = {}

-- LSP Configuration
M.lsp = {
  name = "phpactor",
  config = {
    settings = {
      phpactor = {
        files = {
          maxSize = 5000000, -- 5MB limit
        },
        completion = {
          insertUseStatements = true,
        },
        codeTransform = {
          importGlobals = true,
        },
        symfony = {
          enabled = true,
        },
      }
    },
    filetypes = { "php" },
    root_dir = function(fname)
      return require('lspconfig.util').root_pattern("composer.json", ".git")(fname)
    end,
    init_options = {
      ["language_server_phpstan.enabled"] = false,
      ["language_server_psalm.enabled"] = false,
    },
  }
}

-- Alternative LSP (Intelephense)
M.lsp_alternative = {
  name = "intelephense",
  config = {
    settings = {
      intelephense = {
        files = {
          maxSize = 5000000,
          associations = { "*.php", "*.phtml" },
          exclude = {
            "**/.git/**",
            "**/node_modules/**",
            "**/bower_components/**",
            "**/vendor/**/Tests/**",
            "**/vendor/**/tests/**",
          },
        },
        environment = {
          includePaths = {},
        },
        completion = {
          insertUseDeclaration = true,
          fullyQualifyGlobalConstantsAndFunctions = false,
          triggerParameterHints = true,
          maxItems = 100,
        },
        format = {
          enable = true,
        },
        diagnostics = {
          enable = true,
        },
      },
    },
    filetypes = { "php" },
    root_dir = function(fname)
      return require('lspconfig.util').root_pattern("composer.json", ".git")(fname)
    end,
  }
}

-- Debug Configuration (using Xdebug)
M.dap = {
  adapters = {
    php = {
      type = "executable",
      command = "node",
      args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" }
    }
  },
  configurations = {
    {
      name = "Listen for Xdebug",
      type = "php",
      request = "launch",
      port = 9003,
      stopOnEntry = false,
      pathMappings = {},
    },
    {
      name = "Launch currently open script",
      type = "php",
      request = "launch",
      program = "${file}",
      cwd = "${fileDirname}",
      port = 0,
      runtimeArgs = {
        "-dxdebug.start_with_request=yes"
      },
      env = {
        XDEBUG_MODE = "debug,develop",
        XDEBUG_CONFIG = "client_port=${port}"
      }
    },
  }
}

-- Mason tools needed
M.mason_tools = {
  lsp = { "phpactor", "intelephense" },
  debuggers = { "php-debug-adapter" },
  formatters = { "php-cs-fixer", "phpcbf" }
}

-- File extensions this language handles
M.extensions = { "php", "phtml" }

-- Formatter configuration
M.formatters = { "php-cs-fixer", "phpcbf" }

-- Linter configuration
M.linters = {
  {
    name = "phpstan",
    command = "phpstan",
    args = { "analyse", "--error-format=raw", "--no-progress", "%filepath" },
    stream = "stdout",
    ignore_exitcode = true
  },
  {
    name = "psalm",
    command = "psalm",
    args = { "--output-format=emacs", "%filepath" },
    stream = "stdout",
    ignore_exitcode = true
  }
}

-- PHP specific keymaps and settings
local function setup_php_keymaps()
  local map = vim.keymap.set
  
  -- PHP specific commands
  map('n', '<leader>pr', '<cmd>!php %<cr>', { desc = 'Run current PHP file', buffer = true })
  map('n', '<leader>pc', '<cmd>!php -l %<cr>', { desc = 'Check PHP syntax', buffer = true })
  map('n', '<leader>pf', '<cmd>!php-cs-fixer fix %<cr>', { desc = 'Fix PHP code style', buffer = true })
  map('n', '<leader>pt', '<cmd>!./vendor/bin/phpunit<cr>', { desc = 'Run PHPUnit tests', buffer = true })
  map('n', '<leader>pa', '<cmd>!./vendor/bin/phpstan analyse<cr>', { desc = 'Run PHPStan analysis', buffer = true })
  map('n', '<leader>ps', '<cmd>!./vendor/bin/psalm<cr>', { desc = 'Run Psalm analysis', buffer = true })
end

-- PHP specific autocmds
local function setup_php_autocmds()
  local group = vim.api.nvim_create_augroup('PHPConfig', { clear = true })
  
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'php',
    group = group,
    callback = function()
      -- PHP specific settings
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
      
      -- Set up keymaps
      setup_php_keymaps()
    end,
  })
end

-- Setup function
function M.setup()
  setup_php_autocmds()
  
  -- Add PHP snippets if available
  if pcall(require, 'luasnip') then
    local ls = require('luasnip')
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    
    ls.add_snippets('php', {
      s('php', {
        t('<?php'),
        t({'', ''}), i(1),
      }),
      s('class', {
        t('class '), i(1, 'ClassName'), t(' {'),
        t({'', '    '}), i(2),
        t({'', '}'})
      }),
      s('function', {
        t('function '), i(1, 'name'), t('('), i(2), t(') {'),
        t({'', '    '}), i(3),
        t({'', '}'})
      }),
      s('method', {
        t('public function '), i(1, 'name'), t('('), i(2), t(') {'),
        t({'', '    '}), i(3),
        t({'', '}'})
      })
    })
  end
end

return M

