-- Scala language support configuration
local M = {}

-- Scala Language Server configuration
M.lsp = {
  name = "metals",
  cmd = { "metals" },
  filetypes = { "scala", "sbt" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("build.sbt", "build.sc", ".git")(fname)
  end,
  settings = {
    metals = {
      -- Enable import completion
      enableImportCompletion = true,
      -- Show implicit arguments and conversions
      showImplicitArguments = true,
      showImplicitConversions = true,
      -- Show inferred types
      showInferredType = true,
      -- Exclude packages from completion
      excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Scala-specific keymaps
    vim.keymap.set('n', '<leader>sb', function()
      vim.cmd('terminal sbt compile')
      vim.cmd('startinsert')
    end, { desc = 'SBT compile', buffer = bufnr })
    
    vim.keymap.set('n', '<leader>sr', function()
      vim.cmd('terminal sbt run')
      vim.cmd('startinsert')
    end, { desc = 'SBT run', buffer = bufnr })
  end,
}

-- Scala formatter configuration
M.formatters = { 'scalafmt' }

-- Scala-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'scala', 'sbt' },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "// %s"
    end,
  })
  
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.scala', '*.sbt', '*.sc' },
    callback = function()
      local ext = vim.fn.expand('%:e')
      if ext == 'sbt' then
        vim.bo.filetype = 'sbt'
      else
        vim.bo.filetype = 'scala'
      end
    end,
  })
end

-- Mason tools for Scala
M.mason_tools = {
  lsp = {},  -- Metals is installed via coursier, not Mason
  formatters = { 'scalafmt' },
  debuggers = {},
}

return M
