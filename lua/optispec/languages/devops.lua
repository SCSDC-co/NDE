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
    -- none-ls source configurations for linters
    none_ls_sources = {
      hadolint = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "dockerfile" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run hadolint asynchronously
              vim.system(
                { "hadolint", "--format", "json", "-" },
                {
                  stdin = content,
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    for line in result.stdout:gmatch("[^\n]+") do
                      local ok, json_data = pcall(vim.json.decode, line)
                      if ok and json_data then
                        table.insert(diagnostics, {
                          row = json_data.line,
                          col = json_data.column,
                          message = json_data.message,
                          code = json_data.code,
                          source = "hadolint",
                          severity = json_data.level == "error" and vim.diagnostic.severity.ERROR
                                    or json_data.level == "warning" and vim.diagnostic.severity.WARN
                                    or json_data.level == "info" and vim.diagnostic.severity.INFO
                                    or vim.diagnostic.severity.HINT,
                        })
                      end
                    end
                  end
                  done(diagnostics)
                end
              )
            end,
            async = true,
          },
        }
      end,
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
    -- none-ls source configurations for linters
    none_ls_sources = {
      tfsec = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "terraform", "tf" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run tfsec asynchronously
              vim.system(
                { "tfsec", "--format", "json", "--no-colour", "." },
                {
                  cwd = vim.fn.fnamemodify(params.bufname, ":h"),
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    local ok, json_data = pcall(vim.json.decode, result.stdout)
                    if ok and json_data and json_data.results then
                      for _, finding in ipairs(json_data.results) do
                        if finding.location and finding.location.filename == params.bufname then
                          table.insert(diagnostics, {
                            row = finding.location.start_line,
                            col = 1,
                            message = finding.description,
                            code = finding.rule_id,
                            source = "tfsec",
                            severity = finding.severity == "HIGH" and vim.diagnostic.severity.ERROR
                                      or finding.severity == "MEDIUM" and vim.diagnostic.severity.WARN
                                      or vim.diagnostic.severity.INFO,
                          })
                        end
                      end
                    end
                  end
                  done(diagnostics)
                end
              )
            end,
            async = true,
          },
        }
      end,
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
    -- none-ls source configurations for linters
    none_ls_sources = {
      ansible_lint = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "yaml.ansible", "yml.ansible" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run ansible-lint asynchronously
              vim.system(
                { "ansible-lint", "--format", "json", params.bufname },
                {
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    for line in result.stdout:gmatch("[^\n]+") do
                      local ok, json_data = pcall(vim.json.decode, line)
                      if ok and json_data then
                        table.insert(diagnostics, {
                          row = json_data.location.lines.begin,
                          col = json_data.location.columns.begin or 1,
                          message = json_data.message,
                          code = json_data.rule.id,
                          source = "ansible-lint",
                          severity = json_data.level == "error" and vim.diagnostic.severity.ERROR
                                    or json_data.level == "warning" and vim.diagnostic.severity.WARN
                                    or vim.diagnostic.severity.INFO,
                        })
                      end
                    end
                  end
                  done(diagnostics)
                end
              )
            end,
            async = true,
          },
        }
      end,
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
