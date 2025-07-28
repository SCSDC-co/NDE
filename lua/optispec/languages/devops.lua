local M = {}

-- DevOps and Infrastructure Languages
function M.setup()
  -- Docker
  require("optispec.core.languages").register_language("docker", {
    filetypes = { "dockerfile" },
    mason_tools = {
      lsp = { "dockerls" },
      linter = { "hadolint" },
    },
    lsp = {
      name = "dockerls",
      settings = {},
    },
    treesitter = { "dockerfile" },
  })

  -- Terraform
  require("optispec.core.languages").register_language("terraform", {
    filetypes = { "terraform", "tf" },
    mason_tools = {
      lsp = { "terraform-ls" },
      formatters = { "terraform" },
      linter = { "tfsec" },
    },
    lsp = {
      name = "terraformls",
      settings = {},
    },
    treesitter = { "terraform" },
  })

  -- Ansible
  require("optispec.core.languages").register_language("ansible", {
    filetypes = { "yaml.ansible", "yml.ansible" },
    mason_tools = {
      lsp = { "ansiblels" },
      linter = { "ansible_lint" },
    },
    lsp = {
      name = "ansiblels",
      settings = {},
    },
    treesitter = { "yaml" },
  })

  -- Helm
  require("optispec.core.languages").register_language("helm", {
    filetypes = { "helm" },
    mason_tools = {
      lsp = { "helm_ls" },
    },
    lsp = {
      name = "helm_ls",
      settings = {},
    },
    treesitter = { "yaml" },
  })

  -- Rego (Open Policy Agent)
  require("optispec.core.languages").register_language("rego", {
    filetypes = { "rego" },
    mason_tools = {
      lsp = { "regols" },
    },
    lsp = {
      name = "regols",
      settings = {},
    },
    treesitter = { "rego" },
  })
end

return M
