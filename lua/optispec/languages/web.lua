local M = {}

-- Web Development Language Configurations
function M.setup()
  -- JavaScript
  require("optispec.core.languages").register_language("javascript", {
    filetypes = { "javascript", "javascriptreact" },
    mason_tools = {
      lsp = { "typescript-language-server" },
      formatters = { "prettierd" },
      linter = { "eslint_d" },
      dap = { "js-debug-adapter" },
    },
    lsp = {
      name = "ts_ls",
      settings = {},
    },
    -- none-ls source configurations for linters
    none_ls_sources = {
      eslint_d = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "javascript", "javascriptreact" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run eslint_d asynchronously
              vim.system(
                { "eslint_d", "--format", "json", "--stdin", "--stdin-filename", params.bufname },
                {
                  stdin = content,
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    local ok, json_data = pcall(vim.json.decode, result.stdout)
                    if ok and json_data and #json_data > 0 then
                      for _, file in ipairs(json_data) do
                        for _, message in ipairs(file.messages or {}) do
                          table.insert(diagnostics, {
                            row = message.line,
                            col = message.column,
                            message = message.message,
                            code = message.ruleId,
                            source = "eslint_d",
                            severity = message.severity == 2 and vim.diagnostic.severity.ERROR
                                      or message.severity == 1 and vim.diagnostic.severity.WARN
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
    treesitter = { "javascript", "tsx" },
  })
  
  -- TypeScript
  require("optispec.core.languages").register_language("typescript", {
    filetypes = { "typescript", "typescriptreact" },
    mason_tools = {
      lsp = { "typescript-language-server" },
      formatters = { "prettierd" },
      linter = { "eslint_d" },
      dap = { "js-debug-adapter" },
    },
    lsp = {
      name = "ts_ls",
      settings = {},
    },
    -- none-ls source configurations for linters
    none_ls_sources = {
      eslint_d = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "typescript", "typescriptreact" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run eslint_d asynchronously
              vim.system(
                { "eslint_d", "--format", "json", "--stdin", "--stdin-filename", params.bufname },
                {
                  stdin = content,
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    local ok, json_data = pcall(vim.json.decode, result.stdout)
                    if ok and json_data and #json_data > 0 then
                      for _, file in ipairs(json_data) do
                        for _, message in ipairs(file.messages or {}) do
                          table.insert(diagnostics, {
                            row = message.line,
                            col = message.column,
                            message = message.message,
                            code = message.ruleId,
                            source = "eslint_d",
                            severity = message.severity == 2 and vim.diagnostic.severity.ERROR
                                      or message.severity == 1 and vim.diagnostic.severity.WARN
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
    treesitter = { "typescript", "tsx" },
  })

  -- Vue
  require("optispec.core.languages").register_language("vue", {
    filetypes = { "vue" },
    mason_tools = {
      lsp = { "vue-language-server" },
      formatters = { "prettierd" },
      linter = { "eslint_d" },
      dap = { "js-debug-adapter" },
    },
    lsp = {
      name = "vue_ls",
      settings = {},
    },
    -- none-ls source configurations for linters
    none_ls_sources = {
      eslint_d = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "vue" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run eslint_d asynchronously
              vim.system(
                { "eslint_d", "--format", "json", "--stdin", "--stdin-filename", params.bufname },
                {
                  stdin = content,
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    local ok, json_data = pcall(vim.json.decode, result.stdout)
                    if ok and json_data and #json_data > 0 then
                      for _, file in ipairs(json_data) do
                        for _, message in ipairs(file.messages or {}) do
                          table.insert(diagnostics, {
                            row = message.line,
                            col = message.column,
                            message = message.message,
                            code = message.ruleId,
                            source = "eslint_d",
                            severity = message.severity == 2 and vim.diagnostic.severity.ERROR
                                      or message.severity == 1 and vim.diagnostic.severity.WARN
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
    treesitter = { "vue" },
  })

  -- Angular
  require("optispec.core.languages").register_language("angular", {
    filetypes = { "typescript", "scss" },
    mason_tools = {
      lsp = { "angular-language-server" },
      formatters = { "prettierd" },
      linter = { "eslint_d" },
      dap = { "js-debug-adapter" },
    },
    lsp = {
      name = "angularls",
      settings = {},
    },
    treesitter = { "html", "typescript", "scss" },
  })

  -- Svelte
  require("optispec.core.languages").register_language("svelte", {
    filetypes = { "svelte" },
    mason_tools = {
      lsp = { "svelte-language-server" },
      formatters = { "prettierd" },
      linter = { "eslint_d" },
      dap = { "js-debug-adapter" },
    },
    lsp = {
      name = "svelte",
      settings = {},
    },
    treesitter = { "svelte" },
  })

  -- Tailwind CSS
  require("optispec.core.languages").register_language("tailwindcss", {
    filetypes = { 
      "typescript", "javascript", "html", "css", "scss", "sass", "less",
      "svelte", "vue", "astro", "javascriptreact", "typescriptreact",
      -- ASP.NET and related
      "razor", "cshtml", "vbhtml", "aspx", "ascx", "master",
      -- PHP frameworks
      "php", "blade", "twig",
      -- Other templating engines
      "ejs", "erb", "handlebars", "hbs", "mustache", "liquid",
      -- JSX/TSX variants
      "jsx", "tsx"
    },
    mason_tools = {
      lsp = { "tailwindcss-language-server" },
    },
    lsp = {
      name = "tailwindcss-language-server",
      settings = {
        -- Enable Tailwind CSS IntelliSense for more file types
        includeLanguages = {
          razor = "html",
          cshtml = "html",
          vbhtml = "html",
          aspx = "html",
          ascx = "html",
          master = "html",
          blade = "html",
          twig = "html",
          ejs = "html",
          erb = "html",
          handlebars = "html",
          hbs = "html",
          mustache = "html",
          liquid = "html",
        },
        -- Experimental features
        experimental = {
          classRegex = {
            -- ASP.NET Razor syntax
            "class=\"([^\"]*)\"",
            "class='([^']*)'",
            "@class=\"([^\"]*)\"",
            "@class='([^']*)'",
            -- React className
            "className=\"([^\"]*)\"",
            "className='([^']*)'",
            -- Vue class binding
            ":class=\"([^\"]*)\"",
            ":class='([^']*)'",
            "v-bind:class=\"([^\"]*)\"",
            "v-bind:class='([^']*)'",
          },
        },
      },
    },
    treesitter = {},
  })

  -- Emmet (HTML/CSS abbreviation expansion)
  require("optispec.core.languages").register_language("emmet", {
    filetypes = { 
      "html", "xhtml", "xml", "css", "scss", "sass", "less", "stylus",
      "javascriptreact", "typescriptreact", "vue", "svelte", "astro",
      -- ASP.NET and related
      "razor", "cshtml", "vbhtml", "aspx", "ascx", "master",
      -- PHP frameworks
      "php", "blade", "twig",
      -- Other templating engines
      "ejs", "erb", "handlebars", "hbs", "mustache", "liquid",
      -- JSX/TSX variants
      "jsx", "tsx"
    },
    mason_tools = {
      lsp = { "emmet-language-server" },
    },
    lsp = {
      name = "emmet_language_server",
      settings = {
        -- Enable emmet for more filetypes
        filetypes = {
          "html", "xhtml", "xml", "css", "scss", "sass", "less", "stylus",
          "javascriptreact", "typescriptreact", "vue", "svelte", "astro",
          "razor", "cshtml", "vbhtml", "aspx", "ascx", "master",
          "php", "blade", "twig",
          "ejs", "erb", "handlebars", "hbs", "mustache", "liquid",
          "jsx", "tsx"
        },
        -- Show expanded abbreviations in completion
        showExpandedAbbreviation = "always",
        -- Show abbreviations as snippets
        showAbbreviationSuggestions = true,
        -- Include languages that have snippets disabled
        includeLanguages = {},
        -- Variables to be used in snippets
        variables = {},
        -- Exclude languages from emmet abbreviations
        excludeLanguages = {},
        -- Extend language support
        extensionsPath = {},
        -- Preferences for emmet
        preferences = {},
        -- Show suggestions even when prefix doesn't match
        showSuggestionsAsSnippets = false,
        -- Syntaxes for which to show emmet suggestions
        syntaxProfiles = {},
      },
    },
    treesitter = {},
  })

  -- CSS
  require("optispec.core.languages").register_language("css", {
    filetypes = { "css", "scss", "sass", "less" },
    mason_tools = {
      lsp = { "css-lsp" },
      formatters = { "prettierd" },
      linter = { "stylelint" },
    },
    lsp = {
      name = "cssls",
      settings = {},
    },
    -- none-ls source configurations for linters
    none_ls_sources = {
      stylelint = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "css", "scss", "sass", "less" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run stylelint asynchronously
              vim.system(
                { "stylelint", "--formatter", "json", "--stdin", "--stdin-filename", params.bufname },
                {
                  stdin = content,
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    local ok, json_data = pcall(vim.json.decode, result.stdout)
                    if ok and json_data and #json_data > 0 then
                      for _, file in ipairs(json_data) do
                        for _, warning in ipairs(file.warnings or {}) do
                          table.insert(diagnostics, {
                            row = warning.line,
                            col = warning.column,
                            message = warning.text,
                            code = warning.rule,
                            source = "stylelint",
                            severity = warning.severity == "error" and vim.diagnostic.severity.ERROR
                                      or warning.severity == "warning" and vim.diagnostic.severity.WARN
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
    treesitter = { "css", "scss" },
  })

  -- HTML
  require("optispec.core.languages").register_language("html", {
    filetypes = { "html" },
    mason_tools = {
      lsp = { "html-lsp" },
      formatters = { "prettierd" },
      linter = { "htmlhint" },
    },
    lsp = {
      name = "html",
      settings = {},
    },
    -- none-ls source configurations for linters
    none_ls_sources = {
      htmlhint = function()
        local null_ls = require("null-ls")
        return {
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "html" },
          generator = {
            fn = function(params, done)
              local content = table.concat(params.content, "\n")
              
              -- Run htmlhint asynchronously
              vim.system(
                { "htmlhint", "--format", "json", "--stdin" },
                {
                  stdin = content,
                  text = true,
                },
                function(result)
                  local diagnostics = {}
                  if result.stdout then
                    local ok, json_data = pcall(vim.json.decode, result.stdout)
                    if ok and json_data then
                      for _, message in ipairs(json_data.messages or {}) do
                        table.insert(diagnostics, {
                          row = message.line,
                          col = message.col,
                          message = message.message,
                          code = message.rule.id,
                          source = "htmlhint",
                          severity = message.type == "error" and vim.diagnostic.severity.ERROR
                                    or message.type == "warning" and vim.diagnostic.severity.WARN
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
    treesitter = { "html" },
  })

  -- Astro
  require("optispec.core.languages").register_language("astro", {
    filetypes = { "astro" },
    mason_tools = {
      lsp = { "astro-language-server" },
      formatters = { "prettierd" },
      dap = { "js-debug-adapter" },
    },
    lsp = {
      name = "astro-language-server",
      settings = {},
    },
    treesitter = { "astro" },
  })
end

return M
