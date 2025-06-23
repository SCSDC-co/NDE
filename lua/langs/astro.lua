-- Astro language support configuration and plugin specification

-- Plugin specification
local plugin_spec = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = {
    "astro",
  },
  config = function()
    -- Ensure treesitter parsers are installed
    local treesitter = require("nvim-treesitter.configs")
    
    treesitter.setup {
      ensure_installed = {
        "astro",
        "html",
        "javascript",
        "typescript",
        "tsx",
        "css",
      },
    }
    
    -- Astro language server setup
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    
    -- Configure Astro language server
    lspconfig.astro.setup({
      -- Use pattern detection for project root
      root_dir = util.root_pattern("astro.config.mjs", "astro.config.js", "package.json"),
      
      -- Default settings
      init_options = {
        configuration = {
          typescript = {
            tsdk = "",
          },
        },
      },
      
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      
      on_attach = function(client, bufnr)
        -- LSP keybindings
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, bufopts)
        
        -- Auto-format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
          end,
        })
        
        -- Set up comments for Astro files (HTML-style in markup, JS-style in script)
        vim.api.nvim_buf_set_option(bufnr, "commentstring", "<!-- %s -->")
        
        -- Notify performance framework that Astro is loaded
        local dynamic_loader = require('performance.dynamic_loader')
        if dynamic_loader and dynamic_loader.register_plugin then
          dynamic_loader.register_plugin("astro", "languages")
        end
      end,
    })
  end,
}

-- Language configuration
local M = {}

-- Astro Language Server configuration
M.lsp = {
  name = "astro",
  -- Configuration handled by the plugin setup
}

-- Astro formatter configuration (using prettierd)
M.formatters = { 'prettierd' }
M.formatter_opts = {
  ['prettierd'] = {
    -- Ensure prettierd knows to handle .astro files
    prepend_args = { '--parser', 'astro' },
  }
}

-- Astro-specific autocmds and settings
M.setup = function()
  -- Detect Astro files and apply settings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'astro',
    callback = function()
      -- Astro-specific settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      
      -- Set up context-aware commenting
      vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = 0,
        callback = function()
          local line = vim.api.nvim_get_current_line()
          if line:match("<script") or line:match("<style") then
            vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
          else
            vim.api.nvim_buf_set_option(0, "commentstring", "<!-- %s -->")
          end
        end,
      })
    end,
  })
  
  -- Register file type detection for .astro files
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.astro",
    callback = function()
      vim.bo.filetype = "astro"
    end,
  })
end

-- Mason tools for Astro
M.mason_tools = {
  lsp = { 'astro-language-server' },
  formatters = { 'prettierd' },
}

-- Return both the plugin spec and the language configuration
return {
  -- Plugin specification for plugin manager
  plugin = plugin_spec,
  -- Language configuration for internal use
  config = M
}
