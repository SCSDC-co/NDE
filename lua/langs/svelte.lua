-- Svelte language support configuration
local M = {}

-- Svelte Language Server configuration
M.lsp = {
  name = "svelte",
  cmd = { "svelteserver", "--stdio" },
  filetypes = { "svelte" },
  settings = {
    svelte = {
      plugin = {
        html = { completions = { enable = true, emmet = false } },
        svelte = { completions = { enable = true, emmet = true } },
        css = { completions = { enable = true, emmet = true } },
      },
    },
  },
  capabilities = nil, -- Will be set by main LSP config
  on_attach = function(client, bufnr)
    -- Disable LSP formatting (handled by prettierd)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}

-- Svelte formatter configuration (uses prettierd)
M.formatters = { 'prettierd' }

-- Svelte-specific autocmds and settings
M.setup = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'svelte' },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "<!-- %s -->"
    end,
  })
  
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.svelte' },
    callback = function()
      vim.bo.filetype = 'svelte'
    end,
  })
end

-- Mason tools for Svelte
M.mason_tools = {
  lsp = { 'svelte' },
  formatters = { 'prettierd' },
  debuggers = {},
}

return M
