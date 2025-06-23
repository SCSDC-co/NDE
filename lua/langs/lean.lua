-- Lean language support configuration
local M = {}

-- Lean Language Server configuration
M.lsp = {
  name = "lean_ls",
  cmd = { "lean", "--server" },
  filetypes = { "lean" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("leanpkg.toml", "lean-toolchain", ".git")(fname)
  end,
  settings = {
    lean = {
      -- Lean 4 specific settings
      infoViewAutoOpen = true,
      infoViewAutoOpenShowGoal = true,
      infoViewAllErrorsOnLine = true,
      infoViewFilterIndex = -1,
      -- Memory and performance settings
      serverArgs = {},
      serverEnv = {},
    }
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Lean-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Check type
    vim.keymap.set('n', '<leader>lt', function()
      vim.lsp.buf.hover()
    end, { desc = 'Lean check type', buffer = bufnr })
    
    -- Show goal
    vim.keymap.set('n', '<leader>lg', function()
      vim.cmd('LeanGoalAtCursor')
    end, { desc = 'Lean show goal', buffer = bufnr })
    
    -- Restart server
    vim.keymap.set('n', '<leader>lr', function()
      vim.cmd('LspRestart')
    end, { desc = 'Restart Lean server', buffer = bufnr })
    
    -- Build project
    vim.keymap.set('n', '<leader>lb', function()
      vim.cmd('terminal lean --make')
      vim.cmd('startinsert')
    end, { desc = 'Build Lean project', buffer = bufnr })
  end,
}

-- Lean formatter configuration (using lean itself for formatting)
M.formatters = {}

-- Lean-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'lean' },
    callback = function()
      -- Lean indentation settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "-- %s"
      vim.opt_local.smartindent = true
      
      -- Set folding for Lean files
      vim.opt_local.foldmethod = "indent"
      vim.opt_local.foldenable = false -- Start with folds open
      
      -- Completion settings
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })
  
  -- Detect Lean files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.lean' },
    callback = function()
      vim.bo.filetype = 'lean'
    end,
  })
  
  -- Add Lean icon for file explorer
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  if devicons_ok then
    devicons.set_icon({
      lean = {
        icon = "∀",
        color = "#2e8b57",
        name = "Lean"
      }
    })
  end
  
  -- Lazy load Lean-related plugins if available
  local lazy_loader = require("utils.lazy_loader")
  lazy_loader.on_filetype({"lean"}, function()
    -- Load Lean treesitter if available
    pcall(function() 
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lean" },
      })
    end)
  end)
end

-- Mason tools for Lean
-- Note: Lean LS is not available in mason-lspconfig, needs manual installation
M.mason_tools = {
  lsp = {}, -- 'lean_ls' not available in mason-lspconfig
  formatters = {},
  debuggers = {},
}

return M
