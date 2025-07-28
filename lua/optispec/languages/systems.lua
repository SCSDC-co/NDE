local M = {}

-- Systems Programming Language Configurations
function M.setup()
  -- Rust
  require("optispec.core.languages").register_language("rust", {
    filetypes = { "rust" },
    mason_tools = {
      lsp = { "rust_analyzer" },
      formatters = { "rustfmt" },
      linter = { "clippy" },
      dap = { "codelldb" },
    },
    lsp = {
      name = "rust_analyzer",
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          checkOnSave = { command = "clippy" },
        },
      },
    },
    -- none-ls source configurations for linters
    none_ls_sources = {
      clippy = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "rust" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run cargo clippy asynchronously
              vim.system(
                { "cargo", "clippy", "--message-format=json-diagnostic-rendered-ansi", "--quiet" },
                {
                  cwd = vim.fn.fnamemodify(params.bufname, ":h"),
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    for line in result.stdout:gmatch("[^\n]+") do
                      local ok, json_data = pcall(vim.json.decode, line)
                      if ok and json_data.reason == "compiler-message" then
                        local message = json_data.message
                        if message.spans and #message.spans > 0 then
                          for _, span in ipairs(message.spans) do
                            if span.is_primary then
                              table.insert(diagnostics, {
                                row = span.line_start,
                                col = span.column_start,
                                message = message.message,
                                code = message.code and message.code.code or "clippy",
                                source = "clippy",
                                severity = message.level == "error" and vim.diagnostic.severity.ERROR
                                          or message.level == "warning" and vim.diagnostic.severity.WARN
                                          or vim.diagnostic.severity.INFO,
                              })
                            end
                          end
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
    treesitter = { "rust" },
  })

  -- Go
  require("optispec.core.languages").register_language("go", {
    filetypes = { "go" },
    mason_tools = {
      lsp = { "gopls" },
      formatters = { "gofmt" },
      linter = { "golangci_lint" },
      dap = { "delve" },
    },
    lsp = {
      name = "gopls",
      settings = {},
    },
    -- none-ls source configurations for linters
    none_ls_sources = {
      golangci_lint = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "go" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run golangci-lint asynchronously
              vim.system(
                { "golangci-lint", "run", "--out-format", "json", params.bufname },
                {
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    local ok, json_data = pcall(vim.json.decode, result.stdout)
                    if ok and json_data.Issues then
                      for _, issue in ipairs(json_data.Issues) do
                        table.insert(diagnostics, {
                          row = issue.Pos.Line,
                          col = issue.Pos.Column,
                          message = issue.Text,
                          code = issue.FromLinter,
                          source = "golangci-lint",
                          severity = issue.Severity == "error" and vim.diagnostic.severity.ERROR
                                    or issue.Severity == "warning" and vim.diagnostic.severity.WARN
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
    treesitter = { "go" },
  })

  -- C/C++ (clangd)
  require("optispec.core.languages").register_language("clangs", {
    filetypes = { "c", "cpp", "objc", "objcpp" },
    mason_tools = {
      lsp = { "clangd" },
      formatters = { "clang-format" },
      linter = { "cppcheck" },
      dap = { "codelldb" },
    },
    lsp = {
      name = "clangd",
      settings = {},
    },
    -- none-ls source configurations for linters
    none_ls_sources = {
      cppcheck = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "c", "cpp", "objc", "objcpp" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run cppcheck asynchronously
              vim.system(
                { "cppcheck", "--enable=all", "--xml", "--xml-version=2", params.bufname },
                {
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stderr then
                    -- Parse XML output from stderr
                    for line in result.stderr:gmatch("[^\n]+") do
                      local location_match = line:match('<location file="[^"]*" line="(%d+)" column="(%d+)"')
                      local message_start = line:find('<error id="')
                      if location_match and message_start then
                        local row, col = line:match('<location file="[^"]*" line="(%d+)" column="(%d+)"')
                        local severity, id, msg = line:match('<error id="([^"]+)" severity="([^"]+)" msg="([^"]+)"')
                        if row and col and msg then
                          table.insert(diagnostics, {
                            row = tonumber(row),
                            col = tonumber(col),
                            message = msg,
                            code = id,
                            source = "cppcheck",
                            severity = severity == "error" and vim.diagnostic.severity.ERROR
                                      or severity == "warning" and vim.diagnostic.severity.WARN
                                      or severity == "style" and vim.diagnostic.severity.INFO
                                      or vim.diagnostic.severity.HINT,
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
    treesitter = { "c", "cpp" },
  })

  -- Zig
  require("optispec.core.languages").register_language("zig", {
    filetypes = { "zig" },
    mason_tools = {
      lsp = { "zls" },
      dap = { "codelldb" },
    },
    lsp = {
      name = "zls",
      settings = {},
    },
    treesitter = { "zig" },
  })

  -- Java
  require("optispec.core.languages").register_language("java", {
    filetypes = { "java" },
    mason_tools = {
      lsp = { "jdtls" },
      formatters = { "google-java-format" },
      dap = { "java-debug-adapter" },
    },
    lsp = {
      name = "jdtls",
      settings = {},
    },
    treesitter = { "java" },
  })

  -- Kotlin
  require("optispec.core.languages").register_language("kotlin", {
    filetypes = { "kotlin" },
    mason_tools = {
      lsp = { "kotlin-language-server" },
      dap = { "kotlin-debug-adapter" },
    },
    lsp = {
      name = "kotlin_language_server",
      settings = {},
    },
    treesitter = { "kotlin" },
  })

  -- Scala
  require("optispec.core.languages").register_language("scala", {
    filetypes = { "scala" },
    mason_tools = {
      lsp = { "metals" },
    },
    lsp = {
      name = "metals",
      settings = {},
    },
    treesitter = { "scala" },
  })

  -- C# (OmniSharp)
  require("optispec.core.languages").register_language("csharp", {
    filetypes = { "cs", "cshtml" },
    mason_tools = {
      lsp = { "omnisharp" },
      formatters = { "csharpier" },
      dap = { "netcoredbg" },
    },
    lsp = {
      name = "omnisharp",
      settings = {},
    },
    treesitter = { "c_sharp" },
  })
end

return M
