local M = {}

-- Scripting Languages Configurations
function M.setup()
  -- Python
  require("optispec.core.languages").register_language("python", {
    filetypes = { "python" },
    mason_tools = {
      lsp = { "pyright" },
      formatters = { "autopep8", "black" },
      linter = { "flake8" },
      dap = { "debugpy" },
    },
    lsp = {
      name = "pyright",
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    },
    -- none-ls source configurations for linters
    none_ls_sources = {
      flake8 = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "python" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run flake8 asynchronously
              vim.system(
                { "flake8", "--format", "%(row)d:%(col)d: %(code)s %(text)s", "--stdin-display-name", params.bufname, "-" },
                {
                  stdin = content,
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    for line in result.stdout:gmatch("[^\n]+") do
                      local row, col, code, message = line:match("(%d+):(%d+): (%w+) (.+)")
                      if row then
                        table.insert(diagnostics, {
                          row = tonumber(row),
                          col = tonumber(col),
                          message = message,
                          code = code,
                          source = "flake8",
                          severity = code:sub(1,1) == "E" and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
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
    treesitter = { "python" },
  })

  -- Shell
  require("optispec.core.languages").register_language("shell", {
    filetypes = { "sh", "bash", "zsh" },
    mason_tools = {
      lsp = { "bashls" },
      formatters = { "shfmt" },
      linter = { "shellcheck" },
      dap = { "bash-debug-adapter" },
    },
    lsp = {
      name = "bashls",
      settings = {},
    },
    -- none-ls source configurations for linters
    none_ls_sources = {
      shellcheck = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "sh", "bash", "zsh" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run shellcheck asynchronously
              vim.system(
                { "shellcheck", "--format=json", "-" },
                {
                  stdin = content,
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    local ok, json_data = pcall(vim.json.decode, result.stdout)
                    if ok and json_data then
                      for _, item in ipairs(json_data) do
                        table.insert(diagnostics, {
                          row = item.line,
                          col = item.column,
                          message = item.message,
                          code = "SC" .. item.code,
                          source = "shellcheck",
                          severity = item.level == "error" and vim.diagnostic.severity.ERROR 
                                    or item.level == "warning" and vim.diagnostic.severity.WARN
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
    treesitter = { "bash" },
  })

  -- Ruby
  require("optispec.core.languages").register_language("ruby", {
    filetypes = { "ruby" },
    mason_tools = {
      lsp = { "solargraph" },
      formatters = { "rubocop" },
      linter = { "rubocop" },
    },
    lsp = {
      name = "solargraph",
      settings = {},
    },
    -- none-ls source configurations for linters
    none_ls_sources = {
      rubocop = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "ruby" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run rubocop asynchronously
              vim.system(
                { "rubocop", "--format", "json", "--stdin", params.bufname },
                {
                  stdin = content,
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    local ok, json_data = pcall(vim.json.decode, result.stdout)
                    if ok and json_data and json_data.files then
                      for _, file in ipairs(json_data.files) do
                        for _, offense in ipairs(file.offenses or {}) do
                          table.insert(diagnostics, {
                            row = offense.location.start_line,
                            col = offense.location.start_column,
                            message = offense.message,
                            code = offense.cop_name,
                            source = "rubocop",
                            severity = offense.severity == "error" and vim.diagnostic.severity.ERROR
                                      or offense.severity == "warning" and vim.diagnostic.severity.WARN
                                      or offense.severity == "convention" and vim.diagnostic.severity.INFO
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
    treesitter = { "ruby" },
  })

  -- Elixir
  require("optispec.core.languages").register_language("elixir", {
    filetypes = { "elixir", "eelixir" },
    mason_tools = {
      lsp = { "elixirls" },
      dap = { "elixir-ls" },
    },
    lsp = {
      name = "elixirls",
      settings = {},
    },
    treesitter = { "elixir" },
  })

  -- Perl
  require("optispec.core.languages").register_language("perl", {
    filetypes = { "perl" },
    mason_tools = {
      lsp = { "perlpls" },
      dap = { "perl-debug-adapter" },
    },
    lsp = {
      name = "perlpls",
      settings = {},
    },
    treesitter = { "perl" },
  })
end

return M

