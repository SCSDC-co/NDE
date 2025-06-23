-- Tailwind CSS language support configuration
local M = {}

-- Tailwind CSS Language Server configuration
M.lsp = {
  name = "tailwindcss",
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    return util.root_pattern("tailwind.config.js", "tailwind.config.ts", "postcss.config.js", "package.json", ".git")(fname)
  end,
  settings = {
    tailwindCSS = {
      classAttributes = { "class", "className", "classList", "ngClass" },
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        invalidVariant = "error",
        recommendedVariantOrder = "warning"
      },
      validate = true
    }
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Tailwind-specific functionality
  end,
}

-- Tailwind formatter configuration (uses prettierd)
M.formatters = { 'prettierd' }

-- Tailwind-specific autocmds and settings
M.setup = function()
  -- Tailwind is primarily an LSP for other file types
  -- No specific file type settings needed
end

-- Mason tools for Tailwind
M.mason_tools = {
  lsp = { 'tailwindcss' },
  formatters = { 'prettierd' },
  debuggers = {},
}

return M
