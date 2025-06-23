-- Git language and integration support configuration
local M = {}

-- Git has no dedicated LSP server - functionality handled by plugins
-- This module provides git-specific file settings and keymaps
M.lsp = nil

-- Git-specific autocmds and settings
M.setup = function()
  -- Git commit message settings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'gitcommit' },
    callback = function()
      -- Commit message settings
      vim.opt_local.spell = true
      vim.opt_local.spelllang = "en_us"
      vim.opt_local.textwidth = 72
      vim.opt_local.colorcolumn = "50,72"
      vim.opt_local.syntax = "gitcommit"
      
      -- Set cursor to start of file
      vim.cmd("normal! gg")
      
      -- Highlight first line (subject) differently
      vim.cmd([[
        syntax match gitcommitSummary "^.\{0,50\}" contained containedin=gitcommitFirstLine
        highlight link gitcommitSummary Title
      ]])
    end,
  })
  
  -- Git rebase settings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'gitrebase' },
    callback = function()
      -- Rebase settings
      vim.opt_local.syntax = "gitrebase"
      
      -- Commands for rebase operations
      vim.keymap.set('n', 'p', function()
        vim.cmd('normal! ciwpick<ESC>')
      end, { buffer = true, desc = 'Change to pick' })
      
      vim.keymap.set('n', 'r', function()
        vim.cmd('normal! ciwreword<ESC>')
      end, { buffer = true, desc = 'Change to reword' })
      
      vim.keymap.set('n', 'e', function()
        vim.cmd('normal! ciwedit<ESC>')
      end, { buffer = true, desc = 'Change to edit' })
      
      vim.keymap.set('n', 's', function()
        vim.cmd('normal! ciwsquash<ESC>')
      end, { buffer = true, desc = 'Change to squash' })
      
      vim.keymap.set('n', 'f', function()
        vim.cmd('normal! ciwfixup<ESC>')
      end, { buffer = true, desc = 'Change to fixup' })
      
      vim.keymap.set('n', 'd', function()
        vim.cmd('normal! ciwdrop<ESC>')
      end, { buffer = true, desc = 'Change to drop' })
    end,
  })
  
  -- Git config settings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'gitconfig' },
    callback = function()
      -- Git config settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.syntax = "gitconfig"
    end,
  })
  
  -- Detect git files that aren't detected automatically
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { 
      '.gitconfig', '.gitmodules', '.gitattributes', '.gitignore', 
      'COMMIT_EDITMSG', 'MERGE_MSG', 'TAG_EDITMSG', 'NOTES_EDITMSG', 'EDIT_DESCRIPTION',
    },
    callback = function()
      -- Set appropriate filetype based on filename
      local filename = vim.fn.expand('%:t')
      if filename == 'COMMIT_EDITMSG' or filename == 'MERGE_MSG' or filename == 'TAG_EDITMSG' then
        vim.bo.filetype = 'gitcommit'
      elseif filename == '.gitconfig' or filename == '.gitmodules' then
        vim.bo.filetype = 'gitconfig'
      else
        vim.bo.filetype = 'git'
      end
    end,
  })
  
  -- Lazy load git plugins if available
  local lazy_loader = require("utils.lazy_loader")
  lazy_loader.on_filetype({"gitcommit", "gitrebase", "gitconfig", "git"}, function()
    -- Check if fugitive is available and load it
    pcall(function() 
      require("fugitive").setup()
    end)
    
    -- Check if gitsigns is available and load it
    pcall(function() 
      require("gitsigns").setup()
    end)
  end)
end

-- Mason tools for Git (no LSP server needed)
M.mason_tools = {
  lsp = {},  -- No LSP server for git
  formatters = {},
  debuggers = {},
}

return M
