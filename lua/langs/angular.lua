-- Angular language support configuration and plugin specification

-- Plugin specification
local plugin_spec = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = {
    "typescript",
    "html",
    "typescriptreact",
    "typescript.tsx",
  },
  config = function()
    -- Ensure treesitter parsers are installed
    local treesitter = require("nvim-treesitter.configs")
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    
    treesitter.setup {
      ensure_installed = {
        "typescript",
        "javascript",
        "html",
        "css",
      },
    }
    
    -- Angular language server setup
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    
    lspconfig.angularls.setup({
      root_dir = util.root_pattern("angular.json", "project.json"),
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
        
        -- Notify performance framework that Angular is loaded
        local dynamic_loader = require('performance.dynamic_loader')
        if dynamic_loader and dynamic_loader.register_plugin then
          dynamic_loader.register_plugin("angularls", "languages")
        end
      end,
    })
  end,
}

-- Language configuration
local M = {}

-- Angular Language Server configuration
M.lsp = {
  name = "angularls",
  -- No special configuration needed for Angular LS
}

-- Angular formatter configuration (using prettierd)
M.formatters = { 'prettierd' }
M.formatter_opts = {}

-- Angular-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = {'typescript', 'html', 'css'},
    callback = function()
      -- Angular-specific settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
    end,
  })
  
  -- Register Angular-specific file patterns
  vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    pattern = {
      '*.component.ts',
      '*.service.ts',
      '*.module.ts',
      '*.directive.ts',
      '*.pipe.ts',
      '*.resolver.ts',
      '*.guard.ts',
    },
    callback = function()
      vim.bo.filetype = 'typescript'
    end,
  })
end

-- Mason tools for Angular
M.mason_tools = {
  lsp = { 'angular-language-server' },
  formatters = { 'prettierd' },
}

-- Return both the plugin spec and the language configuration
return {
  -- Plugin specification for plugin manager
  plugin = plugin_spec,
  -- Language configuration for internal use
  config = M
}
