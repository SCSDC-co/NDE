return {
  "mrcjkb/rustaceanvim",
  version = "^4", -- Recommended
  lazy = false, -- This plugin is already lazy
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
        -- Automatically set inlay hints (type hints)
        autoSetHints = true,
        
        -- Options for runnables
        runnables = {
          use_telescope = true,
        },
        
        -- Options for debuggables
        debuggables = {
          use_telescope = true,
        },
        
        -- Automatically call RustReloadWorkspace when writing to a Cargo.toml file.
        reload_workspace_from_cargo_toml = true,
        
        -- These apply to the default RustSetInlayHints command
        inlay_hints = {
          -- automatically set inlay hints (type hints)
          auto = true,
          
          -- Only show inlay hints for the current line
          only_current_line = false,
          
          -- whether to show parameter hints with the inlay hints or not
          show_parameter_hints = true,
          
          -- prefix for parameter hints
          parameter_hints_prefix = "<- ",
          
          -- prefix for all the other hints (type, chaining)
          other_hints_prefix = "=> ",
          
          -- whether to align to the length of the longest line in the file
          max_len_align = false,
          
          -- padding from the left if max_len_align is true
          max_len_align_padding = 1,
          
          -- whether to align to the extreme right or not
          right_align = false,
          
          -- padding from the right if right_align is true
          right_align_padding = 7,
          
          -- The color of the hints
          highlight = "Comment",
        },
        
        -- Options for hover actions
        hover_actions = {
          -- the border that is used for the hover window
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
          
          -- Maximal width of the hover window. Nil means no max.
          max_width = nil,
          
          -- Maximal height of the hover window. Nil means no max.
          max_height = nil,
          
          -- whether the hover action window gets automatically focused
          auto_focus = false,
        },
        
        -- Settings for showing the crate graph based on graphviz and the dot
        crate_graph = {
          -- Backend used for displaying the graph
          backend = "x11",
          
          -- Where to store the output, nil for no output stored (relative
          -- path from pwd)
          output = nil,
          
          -- true for all crates.io and external crates, false only the local
          -- crates
          full = true,
          
          -- List of backends found on: https://graphviz.org/docs/outputs/
          enabled_graphviz_backends = {
            "bmp",
            "cgimage",
            "canon",
            "dot",
            "gv",
            "xdot",
            "xdot1.2",
            "xdot1.4",
            "eps",
            "exr",
            "fig",
            "gd",
            "gd2",
            "gif",
            "gtk",
            "ico",
            "imap",
            "cmapx",
            "imap_np",
            "cmapx_np",
            "ismap",
            "jp2",
            "jpg",
            "jpeg",
            "jpe",
            "json",
            "json0",
            "dot_json",
            "xdot_json",
            "pdf",
            "pic",
            "pct",
            "pict",
            "plain",
            "plain-ext",
            "png",
            "pov",
            "ps",
            "ps2",
            "psd",
            "sgi",
            "svg",
            "svgz",
            "tga",
            "tif",
            "tiff",
            "tk",
            "vml",
            "vmlz",
            "wbmp",
            "webp",
            "xlib",
            "x11",
          },
        },
      },
      
      -- LSP configuration
      server = {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_attach = function(client, bufnr)
          -- Hover actions
          vim.keymap.set("n", "<C-space>", function()
            vim.cmd.RustLsp({'hover', 'actions'})
          end, { buffer = bufnr, desc = "Rust hover actions" })
          
          -- Code action groups
          vim.keymap.set("n", "<leader>a", function()
            vim.cmd.RustLsp('codeAction')
          end, { buffer = bufnr, desc = "Rust code actions" })
          
          -- Rust-specific keymaps
          vim.keymap.set("n", "<leader>rr", function()
            vim.cmd.RustLsp('runnables')
          end, { buffer = bufnr, desc = "Rust runnables" })
          
          vim.keymap.set("n", "<leader>rd", function()
            vim.cmd.RustLsp('debuggables')
          end, { buffer = bufnr, desc = "Rust debuggables" })
          
          vim.keymap.set("n", "<leader>rm", function()
            vim.cmd.RustLsp('expandMacro')
          end, { buffer = bufnr, desc = "Expand macro" })
          
          vim.keymap.set("n", "<leader>rc", function()
            vim.cmd.RustLsp('openCargo')
          end, { buffer = bufnr, desc = "Open Cargo.toml" })
          
          vim.keymap.set("n", "<leader>rp", function()
            vim.cmd.RustLsp('parentModule')
          end, { buffer = bufnr, desc = "Parent module" })
          
          vim.keymap.set("n", "<leader>rg", function()
            vim.cmd.RustLsp('crateGraph')
          end, { buffer = bufnr, desc = "View crate graph" })
        end,
        
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
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
            -- Enable experimental features
            experimental = {
              procAttrMacros = true,
            },
            -- Inlay hints
            inlayHints = {
              bindingModeHints = {
                enable = false,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 25,
              },
              closureReturnTypeHints = {
                enable = "never",
              },
              lifetimeElisionHints = {
                enable = "never",
                useParameterNames = false,
              },
              maxLength = 25,
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = "never",
              },
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
      
      -- DAP configuration
      dap = {
        adapter = {
          type = "executable",
          command = "lldb-vscode",
          name = "rt_lldb",
        },
      },
    }
  end,
}

