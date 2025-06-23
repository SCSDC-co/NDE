-- Haskell language support configuration
local M = {}

-- Haskell Language Server configuration
M.lsp = {
  name = "hls",  -- Must match primary provider in nuclear diagnostic system
  cmd = { "haskell-language-server-wrapper", "--lsp" },
  filetypes = { "haskell", "lhaskell" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern(
      "*.cabal",
      "cabal.project",
      "stack.yaml",
      "package.yaml",
      "hie.yaml",
      ".git"
    )(fname)
  end,
  settings = {
    haskell = {
      formattingProvider = "fourmolu",  -- Use fourmolu for formatting
      cabalFormattingProvider = "cabalfmt", -- Use cabalfmt for .cabal files
      
      -- HLS plugin configuration
      plugin = {
        stan = { globalOn = false },  -- Disable stan by default (can be noisy)
        haddockComments = { globalOn = true },
        splice = { globalOn = true },
        hlint = { 
          globalOn = true,
          codeActionsOn = true,
          diagnosticsOn = true 
        },
        moduleName = { globalOn = true },
        pragmas = { globalOn = true, completionOn = true },
        importLens = { globalOn = true },
        refineImports = { globalOn = true },
        rename = { globalOn = true },
        retrie = { globalOn = true },
        tactics = { globalOn = true, config = { max_use_ctor_actions = 5, timeout_duration = 2 } },
        qualifyImportedNames = { globalOn = true },
        evalPlugin = { globalOn = true },
        class = { globalOn = true },
      },
      
      -- Check when saving
      checkProject = true,
      checkParents = "CheckOnSave",
      
      -- Misc settings
      maxCompletions = 40,
      formattingOptimizeImports = true,
    }
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by formatter)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- Haskell-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Start REPL
    vim.keymap.set('n', '<leader>hr', function()
      vim.cmd('terminal ghci')
      vim.cmd('startinsert')
    end, { desc = 'Start GHCi REPL', buffer = bufnr })
    
    -- Cabal build
    vim.keymap.set('n', '<leader>hb', function()
      vim.cmd('terminal cabal build')
      vim.cmd('startinsert')
    end, { desc = 'Cabal build', buffer = bufnr })
    
    -- Cabal run
    vim.keymap.set('n', '<leader>hc', function()
      vim.cmd('terminal cabal run')
      vim.cmd('startinsert')
    end, { desc = 'Cabal run', buffer = bufnr })
    
    -- Stack build
    vim.keymap.set('n', '<leader>hs', function()
      vim.cmd('terminal stack build')
      vim.cmd('startinsert')
    end, { desc = 'Stack build', buffer = bufnr })
    
    -- Stack run
    vim.keymap.set('n', '<leader>hu', function()
      vim.cmd('terminal stack run')
      vim.cmd('startinsert')
    end, { desc = 'Stack run', buffer = bufnr })
    
    -- Format
    vim.keymap.set('n', '<leader>hf', function()
      vim.lsp.buf.format({ async = true })
    end, { desc = 'Format Haskell file', buffer = bufnr })
    
    -- Show type (HLS specific)
    vim.keymap.set('n', '<leader>ht', function()
      vim.cmd('TypeSignature')
    end, { desc = 'Show type signature', buffer = bufnr })
    
    -- HLS eval (requires eval plugin)
    vim.keymap.set('n', '<leader>he', function()
      vim.cmd('Eval')
    end, { desc = 'Evaluate Haskell expression', buffer = bufnr })
    
    -- Add import
    vim.keymap.set('n', '<leader>hi', function()
      local module = vim.fn.input('Module to import: ')
      if module and module ~= '' then
        vim.cmd('normal mz')
        vim.cmd('normal gg')
        vim.cmd('normal /^import<CR>')
        vim.cmd('normal O')
        vim.cmd('normal iimport ' .. module)
        vim.cmd('normal `z')
      end
    end, { desc = 'Add import', buffer = bufnr })
  end,
}

-- Haskell formatter configuration
M.formatters = { 'fourmolu' }
M.formatter_opts = {
  fourmolu = {},  -- Using configuration from fourmolu.lua
}

-- Haskell-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'haskell', 'lhaskell' },
    callback = function()
      -- Haskell indentation settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "-- %s"
      vim.opt_local.smartindent = true
      
      -- Enhanced syntax highlighting
      vim.cmd([[
        syntax match haskellOperators "[!#$%&*+./<=>?@\\^|~-]"
        highlight link haskellOperators Operator
        
        syntax match haskellTopLevelDecl "^\s*\([a-zA-Z][\w']*\|([!#$%&*+./<=>?@\\^|~-]\+)\)\(\s*,\s*[a-zA-Z][\w']*\)*\s*::"
        highlight link haskellTopLevelDecl Function
        
        syntax match haskellTypeDecl "\<\([A-Z][a-zA-Z0-9_']*\)\>"
        highlight link haskellTypeDecl Type
      ]])
      
      -- Set folding for Haskell files
      vim.opt_local.foldmethod = "indent"
      vim.opt_local.foldenable = false -- Start with folds open
      
      -- Completion settings
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
      
      -- Custom text object for Haskell functions
      vim.cmd([[
        onoremap <buffer> af :<c-u>normal! ][kV][$%<cr>
        vnoremap <buffer> af :<c-u>normal! ][kV][$%<cr>
      ]])
    end,
  })
  
  -- Detect Haskell files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.hs', '*.lhs' },
    callback = function()
      local filename = vim.fn.expand("%:e")
      if filename == "lhs" then
        vim.bo.filetype = 'lhaskell'
      else
        vim.bo.filetype = 'haskell'
      end
    end,
  })
  
  -- Add Haskell icon for file explorer
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  if devicons_ok then
    devicons.set_icon({
      hs = {
        icon = "λ",
        color = "#5e5086",
        name = "Haskell"
      },
      lhs = {
        icon = "λ",
        color = "#5e5086",
        name = "LHaskell"
      }
    })
  end
  
  -- Lazy load Haskell-related plugins if available
  local lazy_loader = require("utils.lazy_loader")
  lazy_loader.on_filetype({"haskell", "lhaskell"}, function()
    -- Load Haskell treesitter if available
    pcall(function() 
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "haskell" },
      })
    end)
  end)
  
  -- Add Haskell commands
  vim.api.nvim_create_user_command("HaskellNewModule", function(opts)
    local module_name = opts.args
    if module_name and module_name ~= "" then
      local parts = vim.split(module_name, ".", {plain = true})
      local filename = table.concat(parts, "/") .. ".hs"
      
      -- Create directory structure if needed
      local dir = vim.fn.fnamemodify(filename, ":h")
      if dir ~= "." then
        vim.fn.mkdir(dir, "p")
      end
      
      -- Create the file with module declaration
      local file = io.open(filename, "w")
      if file then
        file:write("module " .. module_name .. " where\n\n")
        file:close()
        
        -- Open the new file
        vim.cmd("edit " .. filename)
      else
        vim.notify("Failed to create module file", vim.log.levels.ERROR)
      end
    else
      vim.notify("Please provide a module name", vim.log.levels.ERROR)
    end
  end, { nargs = 1, desc = "Create a new Haskell module" })
  
  vim.api.nvim_create_user_command("HaskellAddPackage", function(opts)
    local pkg = opts.args
    if pkg and pkg ~= "" then
      vim.cmd('terminal cabal add-package ' .. pkg)
      vim.cmd('startinsert')
    else
      vim.notify("Please provide a package name", vim.log.levels.ERROR)
    end
  end, { nargs = 1, desc = "Add Haskell package dependency" })
end

-- Mason tools for Haskell
-- Note: HLS is managed by GHCup, not Mason, to avoid conflicts
M.mason_tools = {
  lsp = {}, -- hls excluded - using system installation via GHCup
  formatters = { 'fourmolu', 'cabal-fmt' },
  debuggers = {},
}

return M
