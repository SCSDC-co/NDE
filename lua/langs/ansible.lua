-- Ansible language support configuration and plugin specification

-- Plugin specification
local plugin_spec = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = {
    "yaml",
    "yaml.ansible",
  },
  config = function()
    -- Ensure treesitter parsers are installed
    local treesitter = require("nvim-treesitter.configs")
    
    treesitter.setup {
      ensure_installed = {
        "yaml",
      },
    }
    
    -- Ansible language server setup
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    
    -- Configure Ansible language server
    lspconfig.ansiblels.setup({
      -- Use a custom filetypes function to detect Ansible in YAML files
      filetypes = { "yaml.ansible", "ansible", "yaml" },
      
      -- Detect Ansible project structure
      root_dir = util.root_pattern("ansible.cfg", ".ansible.cfg", "galaxy.yml", "requirements.yml"),
      
      -- Default settings
      settings = {
        ansible = {
          ansible = {
            path = "ansible",
          },
          executionEnvironment = {
            enabled = false,
          },
          python = {
            interpreterPath = "python",
          },
          validation = {
            enabled = true,
            lint = {
              enabled = true,
              path = "ansible-lint",
            },
          },
        },
      },
      
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      
      on_attach = function(client, bufnr)
        -- LSP keybindings
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, bufopts)
        
        -- Auto-format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
          end,
        })
        
        -- Notify performance framework that Ansible is loaded
        local dynamic_loader = require('performance.dynamic_loader')
        if dynamic_loader and dynamic_loader.register_plugin then
          dynamic_loader.register_plugin("ansiblels", "languages")
        end
      end,
    })
  end,
}

-- Language configuration
local M = {}

-- Ansible Language Server configuration
M.lsp = {
  name = "ansiblels",
  -- Configuration handled by the plugin setup
}

-- Ansible formatter configuration (using prettierd)
M.formatters = { 'prettierd' }
M.formatter_opts = {}

-- Ansible-specific autocmds and settings
M.setup = function()
  -- Detect Ansible YAML files
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = {
      "*/playbooks/*.yml",
      "*/playbooks/*.yaml",
      "*/roles/*.yml",
      "*/roles/*.yaml",
      "*/inventory/*.yml",
      "*/inventory/*.yaml",
      "*/tasks/*.yml",
      "*/tasks/*.yaml",
      "*/handlers/*.yml",
      "*/handlers/*.yaml",
      "*/group_vars/*.yml",
      "*/group_vars/*.yaml",
      "*/host_vars/*.yml",
      "*/host_vars/*.yaml",
      "*ansible*.yml",
      "*ansible*.yaml",
      "playbook.yml",
      "playbook.yaml",
      "site.yml",
      "site.yaml",
    },
    callback = function()
      vim.bo.filetype = "yaml.ansible"
      
      -- Apply Ansible-specific settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      
      -- Add special Ansible comments for LS
      vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
    end,
  })
  
  -- Also detect if a YAML file contains Ansible content
  vim.api.nvim_create_autocmd("BufRead", {
    pattern = { "*.yml", "*.yaml" },
    callback = function()
      local content = vim.api.nvim_buf_get_lines(0, 0, 100, false)
      local joined_content = table.concat(content, "\n")
      
      -- Check for common Ansible patterns
      if joined_content:match("hosts:") or 
         joined_content:match("tasks:") or 
         joined_content:match("roles:") or 
         joined_content:match("become:") or
         joined_content:match("- name:") then
        vim.bo.filetype = "yaml.ansible"
        
        -- Apply Ansible-specific settings
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
      end
    end,
  })
end

-- Mason tools for Ansible
M.mason_tools = {
  lsp = { 'ansible-language-server' },
  formatters = { 'prettierd' },
  linters = { 'ansible-lint' },
}

-- Return both the plugin spec and the language configuration
return {
  -- Plugin specification for plugin manager
  plugin = plugin_spec,
  -- Language configuration for internal use
  config = M
}
