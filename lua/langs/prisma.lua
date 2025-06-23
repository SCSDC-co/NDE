-- Prisma language support configuration
local M = {}

-- Prisma Language Server configuration
M.lsp = {
  name = "prismals",
  cmd = { "prisma-language-server", "--stdio" },
  filetypes = { "prisma" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("schema.prisma", "package.json", ".git")(fname)
  end,
  settings = {
    prisma = {
      -- Prisma specific settings
      prismaFmtBinPath = "",
    }
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by prisma-fmt)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- Prisma-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Generate Prisma client
    vim.keymap.set('n', '<leader>pg', function()
      vim.cmd('terminal npx prisma generate')
      vim.cmd('startinsert')
    end, { desc = 'Prisma generate', buffer = bufnr })
    
    -- Run Prisma migrations
    vim.keymap.set('n', '<leader>pm', function()
      vim.cmd('terminal npx prisma migrate dev')
      vim.cmd('startinsert')
    end, { desc = 'Prisma migrate', buffer = bufnr })
    
    -- Open Prisma studio
    vim.keymap.set('n', '<leader>ps', function()
      vim.cmd('terminal npx prisma studio')
      vim.cmd('startinsert')
    end, { desc = 'Prisma studio', buffer = bufnr })
    
    -- Reset database
    vim.keymap.set('n', '<leader>pr', function()
      vim.cmd('terminal npx prisma migrate reset')
      vim.cmd('startinsert')
    end, { desc = 'Prisma reset', buffer = bufnr })
  end,
}

-- Prisma formatter configuration
M.formatters = { 'prisma-fmt' }

-- Prisma-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'prisma' },
    callback = function()
      -- Prisma indentation settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "// %s"
      vim.opt_local.smartindent = true
      
      -- Set folding for Prisma files
      vim.opt_local.foldmethod = "indent"
      vim.opt_local.foldenable = false -- Start with folds open
      
      -- Completion settings
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })
  
  -- Detect Prisma files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.prisma' },
    callback = function()
      vim.bo.filetype = 'prisma'
    end,
  })
end

-- Mason tools for Prisma
M.mason_tools = {
  lsp = { 'prismals' },
  formatters = { 'prisma-fmt' },
  debuggers = {},
}

return M
