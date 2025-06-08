return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "williamboman/mason.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
      sources = {
        -- Formatters (only widely available ones)
        formatting.black,
        formatting.isort,
        formatting.clang_format.with({
          filetypes = { "c", "cpp" },
        }),
        formatting.prettier.with({
          filetypes = {
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "css",
            "scss",
            "html",
            "json",
            "yaml",
            "markdown",
          },
        }),
        formatting.shfmt,
        formatting.stylua,
        
        -- Diagnostics/Linters
        diagnostics.mypy.with({
          condition = function(utils)
            return utils.root_has_file({ "mypy.ini", ".mypy.ini", "pyproject.toml" })
          end,
        }),
        diagnostics.shellcheck,
        
        -- Code Actions
        code_actions.shellcheck,
      },
      
      -- Format on save
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                filter = function(c)
                  return c.name == "null-ls"
                end,
                bufnr = bufnr,
              })
            end,
          })
        end
      end,
    })
  end,
}

