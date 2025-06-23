-- Helm language support configuration
local M = {}

-- Helm Language Server configuration (using yamlls with Helm schemas)
M.lsp = {
  name = "yamlls",  -- Must match primary provider in nuclear diagnostic system
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "helm" },
  settings = {
    yaml = {
      schemas = {
        -- Helm chart schemas
        ["https://json.schemastore.org/chart.json"] = "Chart.yaml",
        ["https://json.schemastore.org/helmfile.json"] = "helmfile.yaml",
        -- Kubernetes schemas for templates
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.20.5-standalone-strict/all.json"] = "templates/*.yaml",
      },
      format = {
        enable = false,  -- We use prettierd instead
      },
      validate = true,
      hover = true,
      completion = true,
      customTags = {
        "!include scalar",
        "!reference sequence",
      },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by prettierd)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- Helm-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Helm commands
    vim.keymap.set('n', '<leader>ht', function()
      vim.cmd('terminal helm template . --debug')
      vim.cmd('startinsert')
    end, { desc = 'Helm template debug', buffer = bufnr })
    
    vim.keymap.set('n', '<leader>hl', function()
      vim.cmd('terminal helm lint .')
      vim.cmd('startinsert')
    end, { desc = 'Helm lint', buffer = bufnr })
    
    vim.keymap.set('n', '<leader>hi', function()
      local release_name = vim.fn.input('Release name: ')
      if release_name and release_name ~= '' then
        vim.cmd('terminal helm install ' .. release_name .. ' .')
        vim.cmd('startinsert')
      end
    end, { desc = 'Helm install', buffer = bufnr })
    
    vim.keymap.set('n', '<leader>hu', function()
      local release_name = vim.fn.input('Release name: ')
      if release_name and release_name ~= '' then
        vim.cmd('terminal helm upgrade ' .. release_name .. ' .')
        vim.cmd('startinsert')
      end
    end, { desc = 'Helm upgrade', buffer = bufnr })
  end,
}

-- Helm formatter configuration
M.formatters = { 'prettierd' }
M.formatter_opts = {
  prettierd = {
    -- Helm-specific formatter settings
    prepend_args = {
      "--parser", "yaml",
      "--print-width", "80",
    },
  },
}

-- Helm-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'helm' },
    callback = function()
      -- Helm indentation settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = '# %s'
      
      -- Set folding for Helm files
      vim.opt_local.foldmethod = 'indent'
      vim.opt_local.foldenable = false -- Start with folds open
    end,
  })
  
  -- Detect Helm files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { 
      'templates/*.yaml', 'templates/*.yml',
      'Chart.yaml', 'Chart.yml',
      'values.yaml', 'values.yml',
      'helmfile.yaml', 'helmfile.yml'
    },
    callback = function()
      vim.bo.filetype = 'helm'
    end,
  })
  
  -- Add Helm icon for file explorer
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  if devicons_ok then
    devicons.set_icon({
      ["Chart.yaml"] = {
        icon = "⎈",
        color = "#326ce5",
        name = "Helm"
      },
      ["values.yaml"] = {
        icon = "⎈",
        color = "#326ce5",
        name = "HelmValues"
      }
    })
  end
  
  -- Lazy load Helm-related plugins if available
  local lazy_loader = require("utils.lazy_loader")
  lazy_loader.on_filetype({"helm"}, function()
    -- Load Helm treesitter if available
    pcall(function() 
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "yaml" },
      })
    end)
  end)
end

-- Mason tools for Helm
M.mason_tools = {
  lsp = { 'yamlls' },
  formatters = { 'prettierd' },
  debuggers = {},
}

return M
