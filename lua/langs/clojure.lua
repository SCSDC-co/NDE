-- Clojure language support configuration and plugin specification

-- Plugin specification
local plugin_spec = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Conjure for REPL integration
    {
      "Olical/conjure",
      ft = { "clojure", "fennel", "janet" },
      config = function()
        vim.g["conjure#eval#result_register"] = "c"
        vim.g["conjure#log#hud#width"] = 0.8
        vim.g["conjure#log#hud#height"] = 0.7
        vim.g["conjure#log#hud#enabled"] = true
        vim.g["conjure#log#botright"] = true
        vim.g["conjure#extract#tree_sitter#enabled"] = true
      end,
    },
    -- Parinfer for structural editing
    {
      "gpanders/nvim-parinfer",
      ft = { "clojure", "scheme", "lisp" },
    },
  },
  ft = {
    "clojure",
    "clojurescript",
    "edn",
  },
  config = function()
    -- Ensure treesitter parsers are installed
    local treesitter = require("nvim-treesitter.configs")
    
    treesitter.setup {
      ensure_installed = {
        "clojure",
      },
    }
    
    -- Clojure language server setup
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    
    -- Configure Clojure language server
    lspconfig.clojure_lsp.setup({
      -- Detect project root
      root_dir = util.root_pattern("deps.edn", "project.clj", "build.boot", "shadow-cljs.edn", "bb.edn"),
      
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
        
        -- Clojure-specific keybindings
        vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<leader>ce", function()
          vim.lsp.buf.code_action({ context = { only = { "refactor.extract" } } })
        end, bufopts)
        
        -- Auto-format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
          end,
        })
        
        -- Notify performance framework that Clojure is loaded
        local dynamic_loader = require('performance.dynamic_loader')
        if dynamic_loader and dynamic_loader.register_plugin then
          dynamic_loader.register_plugin("clojure_lsp", "languages")
        end
      end,
    })
  end,
}

-- Language configuration
local M = {}

-- Clojure Language Server configuration
M.lsp = {
  name = "clojure_lsp",
  -- Configuration handled by the plugin setup
}

-- Clojure formatter configuration - simply reference the formatter
M.formatters = { 'zprint' }

-- Clojure-specific autocmds and settings
M.setup = function()
  -- Detect Clojure files and apply settings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'clojure', 'clojurescript', 'edn' },
    callback = function()
      -- Clojure-specific settings
      vim.opt_local.lisp = true
      vim.opt_local.lispwords = "defn,def,defonce,defmulti,defmethod,defmacro,defstruct,deftype,defprotocol,defrecord,reify,extend-type,extend-protocol,letfn,->"
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = ";; %s"
      
      -- Enable rainbow parentheses if available
      local ok, rainbow = pcall(require, "nvim-treesitter.configs")
      if ok then
        rainbow.setup {
          rainbow = {
            enable = true,
            extended_mode = true,
            max_file_lines = 1000,
          }
        }
      end
    end,
  })
  
  -- Register file type detection for Clojure files
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.clj", "*.cljs", "*.cljc", "*.edn" },
    callback = function()
      local ext = vim.fn.expand("%:e")
      if ext == "cljs" then
        vim.bo.filetype = "clojurescript"
      elseif ext == "clj" or ext == "cljc" then
        vim.bo.filetype = "clojure"
      elseif ext == "edn" then
        vim.bo.filetype = "clojure"
      end
    end,
  })
end

-- Mason tools for Clojure
M.mason_tools = {
  lsp = { 'clojure-lsp' },
  formatters = { 'zprint' },
}

-- Return both the plugin spec and the language configuration
return {
  -- Plugin specification for plugin manager
  plugin = plugin_spec,
  -- Language configuration for internal use
  config = M
}
