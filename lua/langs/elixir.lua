-- Elixir language support configuration and plugin specification

-- Plugin specification
local plugin_spec = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      -- Add elixir-tools for better IEx integration
      "elixir-tools/elixir-tools.nvim",
      ft = { "elixir", "eelixir", "heex" },
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        local elixir = require("elixir")
        local elixirls = require("elixir.elixirls")
        
        elixir.setup({
          -- Don't initialize LSP here, we'll do it separately
          elixirls = { enable = false },
          credo = { enable = true },
          nextls = { enable = false },
        })
      end,
    },
  },
  ft = {
    "elixir",
    "eelixir",
    "heex",
    "exs",
  },
  config = function()
    -- Ensure treesitter parsers are installed
    local treesitter = require("nvim-treesitter.configs")
    
    treesitter.setup {
      ensure_installed = {
        "elixir",
        "heex",
        "eex",
        "html",
        "surface", -- For Phoenix LiveView
      },
    }
    
    -- Elixir language server setup
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    
    -- Configure Elixir language server
    lspconfig.elixirls.setup({
      -- Detect project root
      root_dir = util.root_pattern("mix.exs", ".git"),
      
      -- Configure elixir-ls
      cmd = { "elixir-ls" },
      
      settings = {
        elixirLS = {
          -- Enable dialyzer for static analysis
          dialyzerEnabled = true,
          dialyzerFormat = "dialyxir_long",
          
          -- Enable mix formatter
          fetchDeps = true,
          enableTestLenses = true,
          suggestSpecs = true,
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
        
        -- Elixir-specific keymaps
        vim.keymap.set("n", "<leader>em", "<cmd>Mix<cr>", { buffer = bufnr, desc = "Run Mix" })
        vim.keymap.set("n", "<leader>ec", "<cmd>Mix compile<cr>", { buffer = bufnr, desc = "Mix compile" })
        vim.keymap.set("n", "<leader>et", "<cmd>Mix test<cr>", { buffer = bufnr, desc = "Mix test" })
        vim.keymap.set("n", "<leader>ef", "<cmd>Mix format<cr>", { buffer = bufnr, desc = "Mix format" })
        
        -- Auto-format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            -- Check if in a Mix project before running mix format
            local mix_file = vim.fn.findfile("mix.exs", ".;")
            if mix_file ~= "" then
              -- Use mix format directly for better integration with Phoenix projects
              local file_path = vim.fn.expand("%:p")
              vim.fn.system("mix format " .. vim.fn.shellescape(file_path))
              -- Reload the buffer to reflect the changes
              vim.cmd("edit!")
            else
              -- Fallback to LSP formatting
              vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
            end
          end,
        })
        
        -- Notify performance framework that Elixir is loaded
        local dynamic_loader = require('performance.dynamic_loader')
        if dynamic_loader and dynamic_loader.register_plugin then
          dynamic_loader.register_plugin("elixirls", "languages")
        end
      end,
    })
  end,
}

-- Language configuration
local M = {}

-- Elixir Language Server configuration
M.lsp = {
  name = "elixirls",
  -- Configuration handled by the plugin setup
}

-- Elixir formatter configuration (uses built-in mix format)
M.formatters = { }  -- No external formatter needed

-- Elixir-specific autocmds and settings
M.setup = function()
  -- Detect Elixir files and apply settings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'elixir', 'eelixir', 'heex' },
    callback = function()
      -- Elixir-specific settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "# %s"
      
      -- Elixir-specific abbreviations and snippets
      vim.cmd("iabbrev <buffer> df defmodule")
      vim.cmd("iabbrev <buffer> dp defp")
      vim.cmd("iabbrev <buffer> dfs defstruct")
      vim.cmd("iabbrev <buffer> dfc defcallback")
      vim.cmd("iabbrev <buffer> dfd defdelegate")
      vim.cmd("iabbrev <buffer> dee defexception")
      vim.cmd("iabbrev <buffer> dfi defimpl")
      vim.cmd("iabbrev <buffer> dma defmacro")
      vim.cmd("iabbrev <buffer> dmap defmacrop")
      vim.cmd("iabbrev <buffer> dpt defprotocol")
      
      -- Add Elixir-specific snippets
      vim.cmd([[
        inoremap <buffer> <expr> def "def \<CR>end\<Esc>kA"
        inoremap <buffer> <expr> do "do\<CR>end\<Esc>kA"
        inoremap <buffer> <expr> im "import "
        inoremap <buffer> <expr> al "alias "
      ]])
      
      -- Phoenix snippets if in Phoenix project
      local phoenix_file = vim.fn.findfile("config/config.exs", ".;")
      if phoenix_file ~= "" and
         vim.fn.system("grep -q 'use Phoenix' " .. vim.fn.shellescape(phoenix_file)) then
        vim.cmd([[
          inoremap <buffer> <expr> phxc "defmodule \<CR>  use Phoenix.Controller\<CR>  \<CR>end\<Esc>kA"
          inoremap <buffer> <expr> phxv "defmodule \<CR>  use Phoenix.View\<CR>  \<CR>end\<Esc>kA"
          inoremap <buffer> <expr> phxl "defmodule \<CR>  use Phoenix.LiveView\<CR>  \<CR>end\<Esc>kA"
        ]])
      end
    end,
  })
  
  -- Register file type detection for Elixir files
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.ex", "*.exs" },
    callback = function()
      vim.bo.filetype = "elixir"
    end,
  })
  
  -- Register file type detection for HEEx templates
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.heex" },
    callback = function()
      vim.bo.filetype = "heex"
    end,
  })
  
  -- Register file type detection for EEx templates
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.eex" },
    callback = function()
      vim.bo.filetype = "eelixir"
    end,
  })
  
  -- Set up Mix command for running Mix tasks
  vim.api.nvim_create_user_command("Mix", function(opts)
    local args = opts.args or ""
    -- Save the current file if it's modified
    if vim.bo.modified then
      vim.cmd("write")
    end
    -- Run mix command in a terminal buffer
    vim.cmd("belowright 15split")
    vim.cmd("terminal mix " .. args)
    vim.cmd("startinsert")
  end, { nargs = "*", desc = "Run Mix command" })
  
  -- Set up IEx command for running Elixir REPL
  vim.api.nvim_create_user_command("IEx", function()
    vim.cmd("belowright 15split")
    vim.cmd("terminal iex -S mix")
    vim.cmd("startinsert")
  end, { desc = "Start IEx REPL" })
end

-- Mason tools for Elixir
M.mason_tools = {
  lsp = { 'elixir-ls' },
  linters = { 'credo' },
}

-- Return both the plugin spec and the language configuration
return {
  -- Plugin specification for plugin manager
  plugin = plugin_spec,
  -- Language configuration for internal use
  config = M
}
