-- Shell scripting language configuration
-- Bash, Zsh, and other shell scripts

local M = {}

-- LSP Configuration (using bash-language-server)
M.lsp = {
  name = "bashls",
  config = {
    filetypes = { "sh", "bash", "zsh" },
    settings = {
      bashIde = {
        globPattern = "**/*@(.sh|.inc|.bash|.command|.zsh)"
      }
    },
    root_dir = function(fname)
      return require('lspconfig.util').find_git_ancestor(fname)
    end,
  }
}

-- Formatter configuration
M.formatters = { "shfmt" }

-- Shell-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'sh', 'bash', 'zsh' },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.textwidth = 80
      
      -- Shell-specific keymaps
      local opts = { noremap = true, silent = true, buffer = true }
      vim.keymap.set('n', '<leader>sr', '<cmd>!chmod +x % && %<cr>', { desc = 'Make executable and run', buffer = true })
      vim.keymap.set('n', '<leader>sc', '<cmd>!shellcheck %<cr>', { desc = 'Check with shellcheck', buffer = true })
    end,
  })
end

-- Mason tools for Shell
M.mason_tools = {
  lsp = { 'bash-language-server' },
  formatters = { 'shfmt' },
  debuggers = {}, -- No specific debugger for shell scripts
}

-- File extensions this language handles
M.extensions = { "sh", "bash", "zsh" }

return M

