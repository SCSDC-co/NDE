-- YAML language support configuration
local M = {}

-- YAML Language Server configuration
M.lsp = {
  name = "yamlls",  -- Must match primary provider in nuclear diagnostic system
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.ansible" },
  settings = {
    yaml = {
      -- Schema integration with schemastore.nvim
      schemas = function()
        -- Load schemas from schemastore.nvim if available
        local status_ok, schemastore = pcall(require, "schemastore")
        if status_ok then
          return schemastore.yaml.schemas({
            select = {
              "docker-compose.yml",
              "GitHub Workflow",
              "GitHub Action",
              "gitlab-ci",
              "Kubernetes",
              "Helm Chart.yaml",
              "Kustomization",
              "AWS CloudFormation",
              "AWS SAM",
              "OpenAPI",
              "CircleCI",
              "Travis CI",
              "Jenkins",
              "Ansible Playbook",
              "Ansible Role",
              "cloudformation",
              "docker-compose",
              "helm",
              "kustomization",
              "yaml",
            },
          })
        else
          -- Fallback schemas if schemastore not available
          return {
            {
              fileMatch = { "docker-compose*.yml", "docker-compose*.yaml" },
              url = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
            },
            {
              fileMatch = { ".github/workflows/*.yml", ".github/workflows/*.yaml" },
              url = "https://json.schemastore.org/github-workflow.json",
            },
            {
              fileMatch = { "kubernetes/*.yml", "kubernetes/*.yaml" },
              url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.20.5-standalone-strict/all.json",
            },
            {
              fileMatch = { "kustomization.yml", "kustomization.yaml" },
              url = "https://json.schemastore.org/kustomization.json",
            },
          }
        end
      end,
      -- Format settings (handled by prettierd)
      format = {
        enable = false,  -- We use prettierd instead
      },
      -- Validation against schema
      validate = true,
      -- YAML hover configuration
      hover = true,
      -- Completion settings
      completion = true,
      -- Improve custom tags support
      customTags = {
        "!include scalar",
        "!reference sequence",
        "!vault scalar",
        "!ansible sequence",
      },
    },
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by prettierd)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- YAML-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>ys', function()
      vim.cmd('silent %!yq -y sort_keys(.)')
      vim.notify("YAML sorted", vim.log.levels.INFO)
    end, { desc = 'Sort YAML keys (yq)', buffer = bufnr })
  end,
  init_options = {
    provideFormatter = false,  -- We use prettierd
  },
}

-- YAML formatter configuration
M.formatters = { 'prettierd' }
M.formatter_opts = {
  prettierd = {
    -- YAML-specific formatter settings
    prepend_args = {
      "--parser", "yaml",
      "--print-width", "80",
    },
  },
}

-- YAML-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'yaml', 'yaml.docker-compose', 'yaml.ansible' },
    callback = function()
      -- YAML indentation settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = '# %s'
      
      -- Add YAML specific syntax highlighting improvements
      vim.cmd([[
        syntax match yamlKeyValueDelimiter /:\s\+/ containedin=yamlPlainScalar
        highlight link yamlKeyValueDelimiter Delimiter
      ]])
      
      -- Set folding for YAML files
      vim.opt_local.foldmethod = 'indent'
      vim.opt_local.foldenable = false -- Start with folds open
    end,
  })
  
  -- Detect specific YAML file types
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { 'docker-compose*.yml', 'docker-compose*.yaml' },
    callback = function()
      vim.bo.filetype = 'yaml.docker-compose'
    end,
  })
  
  -- Ansible YAML files
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { 'playbook*.yml', 'playbook*.yaml', 'roles/*/tasks/*.yml', 'roles/*/tasks/*.yaml', 'roles/*/defaults/*.yml', 'roles/*/defaults/*.yaml' },
    callback = function()
      vim.bo.filetype = 'yaml.ansible'
    end,
  })
end

-- Mason tools for YAML
M.mason_tools = {
  lsp = { 'yamlls' },
  formatters = { 'prettierd', 'yq' },
  debuggers = {},
}

return M
