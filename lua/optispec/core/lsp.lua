local M = {}

-- Default LSP on_attach function
-- Note: LSP diagnostics will be merged with linter diagnostics by the diagnostics module
local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  
  -- Mappings
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
end

-- Setup LSP configuration
function M.setup(config)
  -- Store config for later use
  M.config = config
  M.capabilities = vim.lsp.protocol.make_client_capabilities()
  
  -- Setup lspconfig
  local lspconfig = require("lspconfig")
  
  -- Store reference for language modules to use
  _G.OptiSpec = _G.OptiSpec or {}
  _G.OptiSpec.lsp = {
    capabilities = M.capabilities,
    on_attach = on_attach,
    setup_server = M.setup_server
  }
end

-- Setup individual LSP server
function M.setup_server(server_name, server_config)
  local lspconfig = require("lspconfig")
  
  -- Merge with default config
  local config = vim.tbl_deep_extend("force", {
    capabilities = M.capabilities,
    on_attach = on_attach,
  }, server_config or {})
  
  -- Setup the server
  lspconfig[server_name].setup(config)
end

-- Plugin definitions
M.plugins = {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-lspconfig.nvim" },
    config = function()
      M.setup({
        tools = {
          lsp = { auto_attach = true }
        }
      })
      
      -- Initialize diagnostics when LSP loads
      require("optispec.core.diagnostics").setup({
        tools = {
          diagnostics = { merge_sources = true }
        }
      })
    end
  }
}

return M
