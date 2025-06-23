-- Erlang language support configuration and plugin specification

-- Plugin specification
local plugin_spec = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = {
    "erlang",
  },
  config = function()
    -- Ensure treesitter parsers are installed
    local treesitter = require("nvim-treesitter.configs")
    
    treesitter.setup {
      ensure_installed = {
        "erlang",
      },
    }
    
    -- Erlang language server setup
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    
    -- Configure Erlang language server
    lspconfig.erlangls.setup({
      -- Detect project root
      root_dir = util.root_pattern("rebar.config", "erlang.mk", ".git"),
      
      -- Add erlang_ls configuration options
      settings = {
        erlangls = {
          -- Auto-discover project dependencies
          autoDiscoverProjectDependencies = true,
          -- Ignore specified OTP apps
          ignoreOtpApps = {},
          -- Include paths
          includePaths = {},
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
        
        -- Erlang-specific keymaps
        vim.keymap.set("n", "<leader>rb", "<cmd>Rebar3<cr>", { buffer = bufnr, desc = "Run Rebar3" })
        vim.keymap.set("n", "<leader>rc", "<cmd>Rebar3 compile<cr>", { buffer = bufnr, desc = "Rebar3 compile" })
        vim.keymap.set("n", "<leader>rt", "<cmd>Rebar3 eunit<cr>", { buffer = bufnr, desc = "Rebar3 eunit" })
        vim.keymap.set("n", "<leader>rf", "<cmd>Rebar3 fmt<cr>", { buffer = bufnr, desc = "Rebar3 format" })
        vim.keymap.set("n", "<leader>rs", "<cmd>Rebar3 shell<cr>", { buffer = bufnr, desc = "Rebar3 shell" })
        
        -- Auto-format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
          end,
        })
        
        -- Notify performance framework that Erlang is loaded
        local dynamic_loader = require('performance.dynamic_loader')
        if dynamic_loader and dynamic_loader.register_plugin then
          dynamic_loader.register_plugin("erlangls", "languages")
        end
      end,
    })
  end,
}

-- Language configuration
local M = {}

-- Erlang Language Server configuration
M.lsp = {
  name = "erlangls",
  -- Configuration handled by the plugin setup
}

-- Erlang formatter configuration
M.formatters = { 'erlfmt' }

-- Erlang-specific autocmds and settings
M.setup = function()
  -- Detect Erlang files and apply settings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'erlang',
    callback = function()
      -- Erlang-specific settings
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "% %s"
      
      -- Erlang-specific abbreviations and snippets
      vim.cmd("iabbrev <buffer> -mod -module().<left><left>")
      vim.cmd("iabbrev <buffer> -exp -export([]).<left><left>")
      vim.cmd("iabbrev <buffer> -inc -include(\"\").<left><left><left>")
      vim.cmd("iabbrev <buffer> -def -define(, ).<left><left><left>")
      vim.cmd("iabbrev <buffer> -rec -record(, {}).<left><left><left><left>")
      vim.cmd("iabbrev <buffer> -beh -behaviour().<left><left>")
      
      -- Add Erlang-specific snippets for common patterns
      vim.cmd([[
        inoremap <buffer> <expr> efun "fun() ->\<CR>    \<CR>end\<Esc>2k$hi"
        inoremap <buffer> <expr> ecase "case  of\<CR>    _ ->\<CR>        \<Esc>2k$hi"
        inoremap <buffer> <expr> eif "if\<CR>     ->\<CR>        \<CR>    true ->\<CR>        \<CR>end\<Esc>5k$hi"
        inoremap <buffer> <expr> emod "-module().\<CR>\<CR>-export([]).\<CR>\<CR>\<Esc>4k$hi"
      ]])
    end,
  })
  
  -- Register file type detection for Erlang files
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.erl", "*.hrl", "*.escript", "rebar.config", "sys.config", "app.config" },
    callback = function()
      vim.bo.filetype = "erlang"
    end,
  })
  
  -- Set up Rebar3 command for running Rebar3 tasks
  vim.api.nvim_create_user_command("Rebar3", function(opts)
    local args = opts.args or ""
    -- Save the current file if it's modified
    if vim.bo.modified then
      vim.cmd("write")
    end
    -- Run rebar3 command in a terminal buffer
    vim.cmd("belowright 15split")
    vim.cmd("terminal rebar3 " .. args)
    vim.cmd("startinsert")
  end, { nargs = "*", desc = "Run Rebar3 command" })
  
  -- Set up ErlShell command for running Erlang shell
  vim.api.nvim_create_user_command("ErlShell", function()
    vim.cmd("belowright 15split")
    vim.cmd("terminal erl")
    vim.cmd("startinsert")
  end, { desc = "Start Erlang shell" })
end

-- Mason tools for Erlang
M.mason_tools = {
  lsp = { 'erlang-ls' },
  formatters = { 'erlfmt' },
}

-- Return both the plugin spec and the language configuration
return {
  -- Plugin specification for plugin manager
  plugin = plugin_spec,
  -- Language configuration for internal use
  config = M
}
