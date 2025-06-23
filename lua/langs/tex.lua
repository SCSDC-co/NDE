-- TeX/LaTeX language support configuration
local M = {}

-- TeX Language Server configuration
M.lsp = {
  name = "texlab",
  cmd = { "texlab" },
  filetypes = { "tex", "plaintex", "bib" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern(".latexmkrc", ".git")(fname)
  end,
  settings = {
    texlab = {
      rootDirectory = nil,
      build = {
        executable = "latexmk",
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        onSave = false,
        forwardSearchAfter = false,
      },
      auxDirectory = ".",
      forwardSearch = {
        executable = nil,
        args = {},
      },
      chktex = {
        onOpenAndSave = false,
        onEdit = false,
      },
      diagnosticsDelay = 300,
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- TeX-specific keymaps
    vim.keymap.set('n', '<leader>lb', function()
      vim.cmd('terminal latexmk -pdf ' .. vim.fn.expand('%'))
      vim.cmd('startinsert')
    end, { desc = 'LaTeX build', buffer = bufnr })
    
    vim.keymap.set('n', '<leader>lc', function()
      vim.cmd('terminal latexmk -C')
      vim.cmd('startinsert')
    end, { desc = 'LaTeX clean', buffer = bufnr })
  end,
}

-- TeX formatter configuration
M.formatters = { 'latexindent' }

-- TeX-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'tex', 'plaintex', 'bib' },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "% %s"
      vim.opt_local.spell = true
      vim.opt_local.spelllang = "en_us"
    end,
  })
  
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.tex', '*.cls', '*.sty', '*.bib' },
    callback = function()
      local ext = vim.fn.expand('%:e')
      if ext == 'bib' then
        vim.bo.filetype = 'bib'
      else
        vim.bo.filetype = 'tex'
      end
    end,
  })
end

-- Mason tools for TeX
M.mason_tools = {
  lsp = { 'texlab' },
  formatters = { 'latexindent' },
  debuggers = {},
}

return M
