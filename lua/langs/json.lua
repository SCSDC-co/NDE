-- JSON language support configuration
local M = {}

-- JSON Language Server configuration
M.lsp = {
  name = "jsonls",  -- Must match primary provider in nuclear diagnostic system
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc", "json5" },
  settings = {
    json = {
      -- Schema integration with schemastore.nvim
      schemas = function()
        -- Load schemas from schemastore.nvim if available
        local status_ok, schemastore = pcall(require, "schemastore")
        if status_ok then
          return schemastore.json.schemas({
            select = {
              "package.json",
              "tsconfig.json",
              ".prettierrc",
              ".eslintrc",
              "lerna.json",
              "nest-cli.json",
              "vercel.json",
              "nx.json",
              "manifest.json",
              "composer.json",
              ".babelrc.json",
              ".jshintrc",
              ".stylelintrc",
              "jsconfig.json",
              "project.json",
              "dart.json",
              "deno.json",
              "workflows.json",
              "GitHub Action",
              "npm package.json",
              "JSON Schema Draft",
            },
          })
        else
          -- Fallback schemas if schemastore not available
          return {
            {
              fileMatch = { "package.json" },
              url = "https://json.schemastore.org/package.json",
            },
            {
              fileMatch = { "tsconfig*.json" },
              url = "https://json.schemastore.org/tsconfig.json",
            },
            {
              fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
              url = "https://json.schemastore.org/prettierrc.json",
            },
            {
              fileMatch = { ".eslintrc", ".eslintrc.json" },
              url = "https://json.schemastore.org/eslintrc.json",
            },
          }
        end
      end,
      -- Format settings (handled by prettierd)
      format = {
        enable = false,  -- We use prettierd instead
      },
      -- Validation against schema
      validate = {
        enable = true,
      },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by prettierd)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- JSON-specific keymaps
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>js', function()
      vim.cmd('silent %!jq -S .')
      vim.notify("JSON sorted", vim.log.levels.INFO)
    end, { desc = 'Sort JSON (jq)', buffer = bufnr })
  end,
  init_options = {
    provideFormatter = false,  -- We use prettierd
  },
}

-- JSON formatter configuration
M.formatters = { 'prettierd' }
M.formatter_opts = {
  prettierd = {
    -- JSON-specific formatter settings
    prepend_args = {
      "--parser", "json",
      "--print-width", "80",
    },
  },
}

-- JSON-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'json', 'jsonc', 'json5' },
    callback = function()
      -- JSON indentation settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.conceallevel = 0 -- Don't conceal quotes
      
      -- Fold by syntax in JSON files
      vim.opt_local.foldmethod = 'syntax'
      vim.opt_local.foldenable = false -- Start with folds open
    end,
  })
  
  -- Enable jsonc filetype detection
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.jsonc', '*.json5', 'tsconfig*.json', '.eslintrc.json' },
    callback = function()
      vim.bo.filetype = 'jsonc'
    end,
  })
end

-- Mason tools for JSON
M.mason_tools = {
  lsp = { 'jsonls' },
  formatters = { 'prettierd', 'jq' },
  debuggers = {},
}

return M
