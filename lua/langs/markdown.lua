-- Markdown language support configuration
local M = {}

-- Markdown Language Server configuration
M.lsp = {
  name = "marksman",  -- Must match primary provider in nuclear diagnostic system
  cmd = { "marksman", "server" },
  filetypes = { "markdown", "markdown.mdx" },
  settings = {
    -- Marksman doesn't have many settings compared to other LSPs
    -- but we'll include what's relevant
    marksman = {
      -- General settings for marksman
      includePaths = { "**/*.md", "**/*.markdown", "**/*.mdx" },
      excludePaths = { "**/node_modules/**", "**/dist/**", "**/build/**" },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by prettierd)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- Markdown-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Preview markdown
    vim.keymap.set('n', '<leader>mp', function()
      local filename = vim.fn.expand('%:p')
      vim.cmd('silent !glow "' .. filename .. '"')
    end, { desc = 'Preview Markdown (glow)', buffer = bufnr })
    
    -- Toggle checkbox
    vim.keymap.set('n', '<leader>mc', function()
      local line = vim.fn.getline('.')
      if line:match('%[%s%]') then
        vim.cmd('s/\\[\\s\\]/[x]/e')
      elseif line:match('%[x%]') then
        vim.cmd('s/\\[x\\]/[ ]/e')
      else
        -- If no checkbox, add one at the beginning of the line
        vim.cmd('s/^\\s*\\([-*+]\\s\\)\\?/\\1[ ] /e')
      end
      vim.cmd('nohlsearch')
    end, { desc = 'Toggle Markdown Checkbox', buffer = bufnr })
    
    -- Generate table of contents
    vim.keymap.set('n', '<leader>mt', function()
      vim.cmd("silent !markdown-toc --no-first-h1 -i " .. vim.fn.shellescape(vim.fn.expand('%:p')))
      vim.cmd('e')
      vim.notify("Table of contents generated", vim.log.levels.INFO)
    end, { desc = 'Generate TOC', buffer = bufnr })
  end,
  init_options = {
    provideFormatter = false,  -- We use prettierd
  },
}

-- Markdown formatter configuration
M.formatters = { 'prettierd' }
M.formatter_opts = {
  prettierd = {
    -- Markdown-specific formatter settings
    prepend_args = {
      "--parser", "markdown",
      "--print-width", "80",
      "--prose-wrap", "always",
    },
  },
}

-- Markdown-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'markdown.mdx' },
    callback = function()
      -- Markdown indentation and editing settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.spell = true
      vim.opt_local.spelllang = "en_us"
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
      vim.opt_local.breakindent = true
      vim.opt_local.showbreak = "↪ "
      
      -- Set conceallevel to show formatting in a clean way
      vim.opt_local.conceallevel = 2
      vim.opt_local.concealcursor = "nc"
      
      -- Set foldmethod for Markdown files
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt_local.foldenable = false -- Start with folds open
      
      -- Add custom syntax for markdown tasks
      vim.cmd([[
        syntax match markdownTask "\[ \]" conceal cchar=☐
        syntax match markdownTaskDone "\[x\]" conceal cchar=✓
        highlight markdownTask guifg=#ffb86c gui=nocombine
        highlight markdownTaskDone guifg=#50fa7b gui=nocombine
      ]])
      
      -- Add helpful commands
      vim.api.nvim_buf_create_user_command(0, "MarkdownToc", function()
        vim.cmd("silent !markdown-toc --no-first-h1 -i " .. vim.fn.shellescape(vim.fn.expand('%:p')))
        vim.cmd('e')
        vim.notify("Table of contents generated", vim.log.levels.INFO)
      end, { desc = "Generate Table of Contents" })
      
      vim.api.nvim_buf_create_user_command(0, "MarkdownPreview", function()
        local filename = vim.fn.expand('%:p')
        vim.cmd('silent !glow "' .. filename .. '"')
      end, { desc = "Preview Markdown with Glow" })
    end,
  })
  
  -- Detect MDX files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.mdx' },
    callback = function()
      vim.bo.filetype = 'markdown.mdx'
    end,
  })
  
  -- Lazy load the markdown preview plugin if available
  local lazy_loader = require("utils.lazy_loader")
  lazy_loader.on_filetype({"markdown", "markdown.mdx"}, function()
    -- Check if markdown preview plugin is available and load it
    pcall(function() 
      require("markdown-preview").setup()
    end)
  end)
end

-- Mason tools for Markdown
M.mason_tools = {
  lsp = { 'marksman' },
  formatters = { 'prettierd', 'markdownlint' },
  debuggers = {},
}

return M
