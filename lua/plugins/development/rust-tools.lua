return {
  "mrcjkb/rustaceanvim",
  version = "^4", -- Recommended
  lazy = false, -- This plugin is already lazy
  ft = { "rust" },
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    -- Get Rust configuration from language module
    local rust_config = require('langs.rust')
    
    -- Set up rustaceanvim with our configuration
    vim.g.rustaceanvim = rust_config.rustaceanvim_config
    
    -- Additional Rust-specific keymaps
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'rust',
      callback = function(args)
        local bufnr = args.buf
        
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
    })
  end,
}

