-- Elm language support configuration and plugin specification

-- Plugin specification
local plugin_spec = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      -- Add additional Elm support
      "elmcast/elm-vim",
      ft = "elm",
      init = function()
        -- Disable elm-vim's formatting in favor of elm-format through formatter.nvim
        vim.g.elm_format_autosave = 0
        -- Disable elm-vim's syntastic checker in favor of LSP
        vim.g.elm_syntastic_show_warnings = 0
      end,
    },
  },
  ft = {
    "elm",
  },
  config = function()
    -- Ensure treesitter parsers are installed
    local treesitter = require("nvim-treesitter.configs")
    
    treesitter.setup {
      ensure_installed = {
        "elm",
      },
    }
    
    -- Elm language server setup
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    
    -- Configure Elm language server
    lspconfig.elmls.setup({
      -- Detect project root
      root_dir = util.root_pattern("elm.json"),
      
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
        
        -- Elm-specific keymaps
        vim.keymap.set("n", "<leader>em", "<cmd>ElmMake<cr>", { buffer = bufnr, desc = "Elm Make" })
        vim.keymap.set("n", "<leader>et", "<cmd>ElmTest<cr>", { buffer = bufnr, desc = "Elm Test" })
        vim.keymap.set("n", "<leader>er", "<cmd>ElmRepl<cr>", { buffer = bufnr, desc = "Elm REPL" })
        vim.keymap.set("n", "<leader>ed", "<cmd>ElmShowDocs<cr>", { buffer = bufnr, desc = "Elm Show Docs" })
        vim.keymap.set("n", "<leader>eb", "<cmd>ElmBrowseDocs<cr>", { buffer = bufnr, desc = "Elm Browse Docs" })
        
        -- Auto-format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
          end,
        })
        
        -- Notify performance framework that Elm is loaded
        local dynamic_loader = require('performance.dynamic_loader')
        if dynamic_loader and dynamic_loader.register_plugin then
          dynamic_loader.register_plugin("elmls", "languages")
        end
      end,
    })
  end,
}

-- Language configuration
local M = {}

-- Elm Language Server configuration
M.lsp = {
  name = "elmls",
  -- Configuration handled by the plugin setup
}

-- Elm formatter configuration
M.formatters = { 'elm-format' }

-- Elm-specific autocmds and settings
M.setup = function()
  -- Detect Elm files and apply settings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'elm',
    callback = function()
      -- Elm-specific settings
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "-- %s"
      
      -- Elm-specific abbreviations and snippets
      vim.cmd("iabbrev <buffer> eimp import")
      vim.cmd("iabbrev <buffer> emod module")
      vim.cmd("iabbrev <buffer> etype type")
      vim.cmd("iabbrev <buffer> ealia type alias")
      vim.cmd("iabbrev <buffer> emsg Msg")
      vim.cmd("iabbrev <buffer> emod Model")
      vim.cmd("iabbrev <buffer> eupd update")
      vim.cmd("iabbrev <buffer> eview view")
      
      -- Add Elm-specific snippets for common patterns
      vim.cmd([[
        inoremap <buffer> <expr> ecase "case  of\<CR>    _ ->\<CR>        \<Esc>2ki"
        inoremap <buffer> <expr> elet "let\<CR>    =\<CR>in\<CR>    \<Esc>3k$hi"
        inoremap <buffer> <expr> eif "if  then\<CR>    \<CR>else\<CR>    \<Esc>3k$hhi"
      ]])
    end,
  })
  
  -- Register file type detection for Elm files
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.elm" },
    callback = function()
      vim.bo.filetype = "elm"
    end,
  })
  
  -- Set up Elm commands (these are provided by elm-vim, but we register them here for clarity)
  vim.cmd([[
    command! -buffer -nargs=* ElmMake call elm#Make(<f-args>)
    command! -buffer -nargs=* ElmTest call elm#Test(<f-args>)
    command! -buffer -nargs=* ElmRepl call elm#Repl()
    command! -buffer -nargs=* ElmShowDocs call elm#ShowDocs()
    command! -buffer -nargs=* ElmBrowseDocs call elm#BrowseDocs()
  ]])
  
  -- Set up Elm functions 
  vim.api.nvim_create_user_command("ElmGenerate", function(opts)
    local args = opts.args or ""
    -- Save the current file if it's modified
    if vim.bo.modified then
      vim.cmd("write")
    end
    -- Run elm-generate in a terminal buffer
    vim.cmd("belowright 15split")
    vim.cmd("terminal elm-generate " .. args)
    vim.cmd("startinsert")
  end, { nargs = "*", desc = "Run elm-generate" })
end

-- Mason tools for Elm
M.mason_tools = {
  lsp = { 'elm-language-server' },
  formatters = { 'elm-format' },
}

-- Return both the plugin spec and the language configuration
return {
  -- Plugin specification for plugin manager
  plugin = plugin_spec,
  -- Language configuration for internal use
  config = M
}
