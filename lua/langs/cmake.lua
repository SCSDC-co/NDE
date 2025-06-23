-- CMake language support configuration and plugin specification

-- Plugin specification
local plugin_spec = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = {
    "cmake",
  },
  config = function()
    -- Ensure treesitter parsers are installed
    local treesitter = require("nvim-treesitter.configs")
    
    treesitter.setup {
      ensure_installed = {
        "cmake",
      },
    }
    
    -- CMake language server setup
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    
    -- Configure CMake language server
    lspconfig.cmake.setup({
      -- Detect project root
      root_dir = util.root_pattern("CMakeLists.txt", ".git"),
      
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
        
        -- Notify performance framework that CMake is loaded
        local dynamic_loader = require('performance.dynamic_loader')
        if dynamic_loader and dynamic_loader.register_plugin then
          dynamic_loader.register_plugin("cmake", "languages")
        end
      end,
    })
  end,
}

-- Language configuration
local M = {}

-- CMake Language Server configuration
M.lsp = {
  name = "cmake",
  -- Configuration handled by the plugin setup
}

-- CMake formatter configuration - simply reference the formatter
M.formatters = { 'cmake-format' }

-- CMake-specific autocmds and settings
M.setup = function()
  -- Detect CMake files and apply settings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'cmake',
    callback = function()
      -- CMake-specific settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "# %s"
      
      -- CMake-specific abbreviations
      vim.cmd("iabbrev <buffer> cmr cmake_minimum_required(VERSION")
      vim.cmd("iabbrev <buffer> cp project(")
      vim.cmd("iabbrev <buffer> cae add_executable(")
      vim.cmd("iabbrev <buffer> cal add_library(")
      vim.cmd("iabbrev <buffer> cit include_directories(")
      vim.cmd("iabbrev <buffer> clt link_target_libraries(")
    end,
  })
  
  -- Register file type detection for CMake files
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "CMakeLists.txt", "*.cmake" },
    callback = function()
      vim.bo.filetype = "cmake"
    end,
  })
end

-- Mason tools for CMake
M.mason_tools = {
  lsp = { 'cmake-language-server' },
  formatters = { 'cmake-format' },
}

-- Return both the plugin spec and the language configuration
return {
  -- Plugin specification for plugin manager
  plugin = plugin_spec,
  -- Language configuration for internal use
  config = M
}
