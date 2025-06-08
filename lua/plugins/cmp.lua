return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "f3fora/cmp-spell",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "neovim/nvim-lspconfig",
      "onsails/lspkind.nvim", -- VSCode-like pictograms
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspconfig = require("lspconfig")
      local lspkind = require("lspkind")

      -- Load friendly snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        performance = {
          trigger_debounce_time = 500,
          throttle = 550,
          fetching_timeout = 80,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
          }),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              local menu_icon = {
                nvim_lsp = "λ",
                luasnip = "⋗",
                buffer = "Ω",
                path = "🖫",
                nvim_lua = "Π",
                calc = "🖩",
                emoji = "😀",
                spell = "✓",
              }
              vim_item.menu = menu_icon[entry.source.name]
              return vim_item
            end,
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          ["<C-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "nvim_lua", priority = 500 },
          { name = "path", priority = 300 },
        }, {
          { name = "buffer", priority = 250, keyword_length = 3 },
          { name = "calc", priority = 150 },
          { name = "emoji", priority = 100 },
          { name = "spell", priority = 100 },
        }),
        experimental = {
          ghost_text = {
            hl_group = "Comment",
          },
        },
      })

      -- Cmdline completions
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        })
      })

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Enhanced server configurations
      local servers = {
        -- Systems Programming
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
        
        -- Web Development
        ts_ls = {},
        eslint = {},
        html = {
          filetypes = { "html", "twig", "hbs"},
        },
        cssls = {},
        tailwindcss = {},
        emmet_ls = {
          filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },
        
        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ruff = {},
        
        -- Go
        gopls = {
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = {
                unusedparams = true,
              },
            },
          },
        },
        
        -- Java
        jdtls = {},
        
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        
        -- Assembly
        asm_lsp = {},
        
        -- Shell
        bashls = {},
        
        -- JSON/YAML
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require('schemastore').yaml.schemas(),
            },
          },
        },
        
        -- Docker
        dockerls = {},
        docker_compose_language_service = {},
        
        -- Other
        marksman = {}, -- Markdown
        taplo = {},    -- TOML
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end

      -- Special setup for C# with dynamic path detection
      local function find_omnisharp()
        -- Try different possible locations for omnisharp
        local possible_paths = {
          "/usr/bin/omnisharp",           -- Arch Linux package
          "/usr/local/bin/omnisharp",     -- Manual install
          "/opt/omnisharp/omnisharp",     -- Custom install
          vim.fn.expand("~/.dotnet/tools/omnisharp"), -- dotnet tool install
          "omnisharp",                    -- In PATH
        }
        
        for _, path in ipairs(possible_paths) do
          if vim.fn.executable(path) == 1 then
            return path
          end
        end
        
        -- Fallback: try to find via which command
        local which_result = vim.fn.system("which omnisharp 2>/dev/null")
        if vim.v.shell_error == 0 and which_result ~= "" then
          return vim.trim(which_result)
        end
        
        -- If not found, return nil to skip setup
        return nil
      end
      
      local omnisharp_bin = find_omnisharp()
      if omnisharp_bin then
        lspconfig.omnisharp.setup {
          cmd = { omnisharp_bin },
          capabilities = capabilities,
          root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", ".git"),
          settings = {
            FormattingOptions = {
              EnableEditorConfigSupport = true,
              OrganizeImports = true,
            },
            MsBuild = {
              LoadProjectsOnDemand = false,
            },
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = true,
              EnableImportCompletion = true,
            },
          },
        }
      else
        vim.notify("OmniSharp not found. Install via: sudo pacman -S omnisharp-roslyn", vim.log.levels.WARN)
      end
    end,
  },
  -- Schema store for JSON/YAML
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
}
