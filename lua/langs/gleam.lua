-- Gleam language support configuration
local M = {}

-- Gleam Language Server configuration
M.lsp = {
  name = "gleam_ls",  -- Must match primary provider in nuclear diagnostic system
  cmd = { "gleam", "lsp" },
  filetypes = { "gleam" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("gleam.toml", ".git")(fname)
  end,
  settings = {
    gleam = {
      -- Gleam language server specific settings
      diagnostics = {
        enabled = true,
      },
      hover = {
        enabled = true,
      },
      inlayHints = {
        enabled = true,
        typeAnnotations = true,
        parameterNames = true,
        functionLikeReturnTypes = true,
      },
      checkOnSave = true,
      enableExperimentalFeatures = true,
      erlangEnabled = true,  -- Support Erlang integration
      elmEnabled = false,    -- Disable Elm integration
      telemetry = {
        enabled = false,
      },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by gleam format)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- Gleam-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Build project
    vim.keymap.set('n', '<leader>gb', function()
      vim.cmd('terminal gleam build')
      vim.cmd('startinsert')
    end, { desc = 'Gleam build', buffer = bufnr })
    
    -- Run tests
    vim.keymap.set('n', '<leader>gt', function()
      vim.cmd('terminal gleam test')
      vim.cmd('startinsert')
    end, { desc = 'Gleam test', buffer = bufnr })
    
    -- Run project
    vim.keymap.set('n', '<leader>gr', function()
      vim.cmd('terminal gleam run')
      vim.cmd('startinsert')
    end, { desc = 'Gleam run', buffer = bufnr })
    
    -- Format file
    vim.keymap.set('n', '<leader>gf', function()
      vim.lsp.buf.format({ async = true })
    end, { desc = 'Format Gleam file', buffer = bufnr })
    
    -- Add Hex dependency
    vim.keymap.set('n', '<leader>ga', function()
      local dep = vim.fn.input('Dependency name: ')
      if dep and dep ~= '' then
        vim.cmd('terminal gleam add ' .. dep)
        vim.cmd('startinsert')
      end
    end, { desc = 'Gleam add dependency', buffer = bufnr })
    
    -- Generate docs
    vim.keymap.set('n', '<leader>gd', function()
      vim.cmd('terminal gleam docs build')
      vim.cmd('startinsert')
    end, { desc = 'Gleam generate docs', buffer = bufnr })
    
    -- Interactive REPL
    vim.keymap.set('n', '<leader>gi', function()
      vim.cmd('terminal gleam shell')
      vim.cmd('startinsert')
    end, { desc = 'Gleam interactive shell', buffer = bufnr })
  end,
}

-- Gleam formatter configuration (for conform.nvim)
M.formatters = { 'gleam_format' }
M.formatter_opts = {
  gleam_format = {
    -- Gleam format has no special options needed
  },
}

-- Gleam-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'gleam',
    callback = function()
      -- Gleam indentation settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "// %s"
      
      -- Add syntax highlighting enhancements
      vim.cmd([[
        syntax match gleamKeyword "\<\(pub\|type\|fn\|let\|case\|if\|else\|import\|as\|const\|external\)\>"
        highlight link gleamKeyword Keyword
        
        syntax match gleamType "\<[A-Z][a-zA-Z0-9_]*\>"
        highlight link gleamType Type
        
        syntax region gleamString start=/"/ end=/"/ skip=/\\"/ contains=gleamStringEscape
        highlight link gleamString String
        
        syntax match gleamFunction "\<[a-z][a-zA-Z0-9_]*\>("he=e-1
        highlight link gleamFunction Function
      ]])
      
      -- Set folding for Gleam files
      vim.opt_local.foldmethod = "indent"
      vim.opt_local.foldenable = false -- Start with folds open
      
      -- Completion settings
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })
  
  -- Detect Gleam files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.gleam' },
    callback = function()
      vim.bo.filetype = 'gleam'
    end,
  })
  
  -- Register Gleam icon for file explorer
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  if devicons_ok then
    devicons.set_icon({
      gleam = {
        icon = "💎",
        color = "#ffaff3",
        name = "Gleam"
      }
    })
  end
  
  -- Lazy load Gleam-related plugins if available
  local lazy_loader = require("utils.lazy_loader")
  lazy_loader.on_filetype({"gleam"}, function()
    -- Load Gleam treesitter if available
    pcall(function() 
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "gleam" },
      })
    end)
  end)
  
  -- Add Gleam commands
  vim.api.nvim_create_user_command("GleamNew", function(opts)
    local project_name = opts.args
    if project_name and project_name ~= "" then
      vim.cmd('terminal gleam new ' .. project_name)
      vim.cmd('startinsert')
    else
      vim.notify("Please provide a project name", vim.log.levels.ERROR)
    end
  end, { nargs = 1, desc = "Create a new Gleam project" })
  
  vim.api.nvim_create_user_command("GleamUpdate", function()
    vim.cmd('terminal gleam update')
    vim.cmd('startinsert')
  end, { desc = "Update Gleam dependencies" })
end

-- Mason tools for Gleam
M.mason_tools = {
  lsp = {},  -- Gleam LSP is installed via Gleam itself, not Mason
  formatters = {},  -- Gleam format is built-in
  debuggers = {},
}

return M
