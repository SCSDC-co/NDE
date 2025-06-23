-- Terraform language support configuration
local M = {}

-- Terraform Language Server configuration
M.lsp = {
  name = "terraformls",
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern(".terraform", ".git")(fname)
  end,
  settings = {
    terraform = {
      validation = {
        enableEnhancedValidation = true,
      },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Terraform-specific keymaps
    vim.keymap.set('n', '<leader>ti', function()
      vim.cmd('terminal terraform init')
      vim.cmd('startinsert')
    end, { desc = 'Terraform init', buffer = bufnr })
    
    vim.keymap.set('n', '<leader>tp', function()
      vim.cmd('terminal terraform plan')
      vim.cmd('startinsert')
    end, { desc = 'Terraform plan', buffer = bufnr })
    
    vim.keymap.set('n', '<leader>ta', function()
      vim.cmd('terminal terraform apply')
      vim.cmd('startinsert')
    end, { desc = 'Terraform apply', buffer = bufnr })
  end,
}

-- Terraform formatter configuration
M.formatters = { 'terraform-fmt' }

-- Terraform-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'terraform', 'terraform-vars' },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "# %s"
    end,
  })
  
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.tf', '*.tfvars' },
    callback = function()
      local ext = vim.fn.expand('%:e')
      if ext == 'tfvars' then
        vim.bo.filetype = 'terraform-vars'
      else
        vim.bo.filetype = 'terraform'
      end
    end,
  })
end

-- Mason tools for Terraform
M.mason_tools = {
  lsp = { 'terraformls' },
  formatters = { 'terraform_fmt' },
  debuggers = {},
}

return M
