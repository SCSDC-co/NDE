-- C# language support configuration
local M = {}

-- C# Language Server configuration (OmniSharp)
M.lsp = {
  name = "omnisharp",
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  filetypes = { "cs", "csharp" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("*.sln", "*.csproj", ".git")(fname)
  end,
  settings = {
    omnisharp = {
      -- Enable import completion
      enableImportCompletion = true,
      -- Enable MSBuild project system
      enableMsBuildLoadProjectsOnDemand = false,
      -- Enable Roslyn analyzers
      enableRoslynAnalyzers = true,
      -- Enable semantic highlighting
      enableSemanticHighlighting = true,
      -- Auto-detect SDK version
      useGlobalMono = "never",
      -- Organize imports on format
      organizeImportsOnFormat = true,
      -- Enable async completion
      enableAsyncCompletion = true,
    }
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by csharpier)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- C#-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Build project
    vim.keymap.set('n', '<leader>cb', function()
      vim.cmd('terminal dotnet build')
      vim.cmd('startinsert')
    end, { desc = 'Build .NET project', buffer = bufnr })
    
    -- Run project
    vim.keymap.set('n', '<leader>cr', function()
      vim.cmd('terminal dotnet run')
      vim.cmd('startinsert')
    end, { desc = 'Run .NET project', buffer = bufnr })
    
    -- Test project
    vim.keymap.set('n', '<leader>ct', function()
      vim.cmd('terminal dotnet test')
      vim.cmd('startinsert')
    end, { desc = 'Test .NET project', buffer = bufnr })
    
    -- Restore packages
    vim.keymap.set('n', '<leader>cR', function()
      vim.cmd('terminal dotnet restore')
      vim.cmd('startinsert')
    end, { desc = 'Restore .NET packages', buffer = bufnr })
  end,
}

-- C# formatter configuration
M.formatters = { 'csharpier' }

-- C#-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'cs', 'csharp' },
    callback = function()
      -- C# indentation settings
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "// %s"
      vim.opt_local.smartindent = true
      
      -- Set folding for C# files
      vim.opt_local.foldmethod = "indent"
      vim.opt_local.foldenable = false -- Start with folds open
      
      -- Completion settings
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })
  
  -- Detect C# files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.cs' },
    callback = function()
      vim.bo.filetype = 'cs'
    end,
  })
end

-- Mason tools for C#
M.mason_tools = {
  lsp = { 'omnisharp' },
  formatters = { 'csharpier' },
  debuggers = { 'netcoredbg' },
}

return M
