return {
  -- Mason for LSP server management
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "⟳",
            package_uninstalled = "✗",
          },
        },
        PATH = "prepend", -- This ensures Mason tools are found first
      })
    end,
  },

  -- Mason LSP Config
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",       -- Lua
          "pyright",       -- Python
          "clangd",        -- C/C++
          "rust_analyzer", -- Rust
          "ts_ls",         -- JavaScript/TypeScript
          "html",          -- HTML
          "cssls",         -- CSS
          "jsonls",        -- JSON
          "yamlls",        -- YAML
          "bashls",        -- Bash
          "gopls",         -- Go
          "marksman",      -- Markdown
        },
        automatic_installation = true,
      })
    end,
  },

  -- Mason Tool Installer for formatters (used by conform.nvim)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters only (no linters to avoid LSP conflicts)
          "stylua",              -- Lua formatter
          "black",               -- Python formatter
          "isort",               -- Python import sorting
          "prettier",            -- JS/TS/HTML/CSS/JSON/YAML/Markdown formatter
          "prettierd",           -- Faster prettier daemon
          "clang-format",        -- C/C++ formatter
          "shfmt",               -- Shell script formatter
          "google-java-format",  -- Java formatter
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,  -- 3 second delay after startup
      })
    end,
  },

  -- LSP Config with NUCLEAR duplicate prevention
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      
      -- Create diagnostic namespace
      local diagnostic_namespace = vim.api.nvim_create_namespace("primary_diagnostics")

      -- COMPLETELY disable default diagnostic handling
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
        if not result or not result.diagnostics then return end
        
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if not client then return end
        
        local bufnr = ctx.bufnr or vim.uri_to_bufnr(result.uri)
        if not vim.api.nvim_buf_is_valid(bufnr) then return end
        
        -- Only allow PRIMARY diagnostic providers
        local primary_providers = {
          python = "pyright",
          rust = "rust_analyzer",
          javascript = "ts_ls",
          typescript = "ts_ls",
          lua = "lua_ls",
          c = "clangd",
          cpp = "clangd",
          go = "gopls",
          html = "html",
          css = "cssls",
          json = "jsonls",
          yaml = "yamlls",
          bash = "bashls",
          markdown = "marksman",
        }
        
        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
        local primary = primary_providers[filetype]
        
        -- ONLY accept diagnostics from the primary provider
        if not primary or client.name ~= primary then
          return -- IGNORE all non-primary diagnostics
        end
        
        -- Validate and fix diagnostic format
        local valid_diagnostics = {}
        for _, diagnostic in ipairs(result.diagnostics) do
          -- Ensure required fields exist
          if diagnostic.range and 
             diagnostic.range.start and 
             diagnostic.range.start.line ~= nil and
             diagnostic.range.start.character ~= nil and
             diagnostic.message then
            
            local fixed_diagnostic = {
              lnum = diagnostic.range.start.line,
              col = diagnostic.range.start.character,
              end_lnum = diagnostic.range["end"] and diagnostic.range["end"].line or diagnostic.range.start.line,
              end_col = diagnostic.range["end"] and diagnostic.range["end"].character or diagnostic.range.start.character,
              message = diagnostic.message,
              severity = diagnostic.severity or vim.diagnostic.severity.INFO,
              source = client.name,
              code = diagnostic.code,
            }
            table.insert(valid_diagnostics, fixed_diagnostic)
          end
        end
        
        -- Clear all existing diagnostics first
        vim.diagnostic.reset(diagnostic_namespace, bufnr)
        
        -- Set ONLY the primary diagnostics with proper format
        if #valid_diagnostics > 0 then
          vim.diagnostic.set(diagnostic_namespace, bufnr, valid_diagnostics)
        end
      end

      -- Configure diagnostics display
      vim.diagnostic.config({
        virtual_text = {
          enabled = true,
          source = false,
          prefix = "●",
          spacing = 2,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "ℹ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = false,
          header = "",
          prefix = "",
        },
      })

      -- Simple on_attach without diagnostic logic (handled above)
      local function on_attach(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        
        local bufopt = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopt)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopt)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopt)
        -- Note: formatting handled by conform.nvim, not LSP
      end

      -- Setup servers
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            },
          },
        },
        pyright = {},
        clangd = {},
        rust_analyzer = {},
        ts_ls = {},
        gopls = {},
        jsonls = {},
        yamlls = {},
        html = {},
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore"
              }
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = "ignore"
              }
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = "ignore"
              }
            }
          }
        },
        bashls = {},
        marksman = {},
      }

      -- Setup servers with duplicate prevention
      for server, config in pairs(servers) do
        -- Check if server is already configured to prevent duplicates
        if not lspconfig[server].manager then
          lspconfig[server].setup(vim.tbl_extend("force", {
            capabilities = capabilities,
            on_attach = on_attach,
          }, config))
        end
      end
    end,
  },

  -- Schema store
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
}

