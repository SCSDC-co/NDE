-- Nushell language support configuration
local M = {}

-- Nushell Language Server configuration
M.lsp = {
  name = "nu_ls",
  cmd = { "nu", "--lsp" },
  filetypes = { "nu", "nushell" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern(".git")(fname)
  end,
  settings = {
    nushell = {
      -- Nushell specific settings
      completions = {
        enabled = true,
      },
      diagnostics = {
        enabled = true,
      },
      formatting = {
        enabled = true,
      },
    }
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Nushell-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Run current script
    vim.keymap.set('n', '<leader>nr', function()
      vim.cmd('terminal nu ' .. vim.fn.expand('%'))
      vim.cmd('startinsert')
    end, { desc = 'Run Nushell script', buffer = bufnr })
    
    -- Start Nushell REPL
    vim.keymap.set('n', '<leader>ns', function()
      vim.cmd('terminal nu')
      vim.cmd('startinsert')
    end, { desc = 'Start Nushell REPL', buffer = bufnr })
    
    -- Check syntax
    vim.keymap.set('n', '<leader>nc', function()
      vim.cmd('terminal nu --check ' .. vim.fn.expand('%'))
    end, { desc = 'Check Nushell syntax', buffer = bufnr })
  end,
}

-- Nushell formatter configuration
M.formatters = {}

-- Nushell-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'nu', 'nushell' },
    callback = function()
      -- Nushell indentation settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "# %s"
      vim.opt_local.smartindent = true
      
      -- Set folding for Nushell files
      vim.opt_local.foldmethod = "indent"
      vim.opt_local.foldenable = false -- Start with folds open
      
      -- Completion settings
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })
  
  -- Detect Nushell files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.nu', '*.nushell' },
    callback = function()
      vim.bo.filetype = 'nu'
    end,
  })
  
  -- Add Nushell icon for file explorer
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  if devicons_ok then
    devicons.set_icon({
      nu = {
        icon = ">_",
        color = "#4e9a06",
        name = "Nushell"
      }
    })
  end
  
  -- Lazy load Nushell-related plugins if available
  local lazy_loader = require("utils.lazy_loader")
  lazy_loader.on_filetype({"nu", "nushell"}, function()
    -- Load Nushell treesitter if available
    pcall(function() 
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "nu" },
      })
    end)
  end)
end

-- Mason tools for Nushell
M.mason_tools = {
  lsp = {},  -- No dedicated LSP server available in Mason yet
  formatters = {},
  debuggers = {},
}

return M
