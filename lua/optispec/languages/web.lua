local M = {}

-- Web Development Language Configurations
function M.setup()
  -- JavaScript
  require("optispec.core.languages").register_language("javascript", {
    filetypes = { "javascript", "javascriptreact" },
    mason_tools = {
      lsp = { "typescript-language-server" },
      formatters = { "prettierd" },
      dap = { "node-debug2-adapter" },
    },
    lsp = {
      name = "ts_ls",
      settings = {},
    },
    treesitter = { "javascript", "tsx" },
  })
  
  -- TypeScript
  require("optispec.core.languages").register_language("typescript", {
    filetypes = { "typescript", "typescriptreact" },
    mason_tools = {
      lsp = { "typescript-language-server" },
      formatters = { "prettierd" },
      dap = { "node-debug2-adapter" },
    },
    lsp = {
      name = "ts_ls",
      settings = {},
    },
    treesitter = { "typescript", "tsx" },
  })

  -- Vue
  require("optispec.core.languages").register_language("vue", {
    filetypes = { "vue" },
    mason_tools = {
      lsp = { "vue-language-server" },
      formatters = { "prettierd" },
    },
    lsp = {
      name = "vue_ls",
      settings = {},
    },
    treesitter = { "vue" },
  })

  -- Angular
  require("optispec.core.languages").register_language("angular", {
    filetypes = { "typescript", "html", "scss" },
    mason_tools = {
      lsp = { "angular-language-server" },
      formatters = { "prettierd" },
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
    },
    lsp = {
      name = "svelte",
      settings = {},
    },
    treesitter = { "svelte" },
  })

  -- Tailwind CSS
  require("optispec.core.languages").register_language("tailwindcss", {
    filetypes = { "typescript", "javascript", "html", "css", "scss", "svelte", "vue" },
    mason_tools = {
      lsp = { "tailwindcss-language-server" },
    },
    lsp = {
      name = "tailwindcss-language-server",
      settings = {},
    },
    treesitter = {},
  })

  -- Astro
  require("optispec.core.languages").register_language("astro", {
    filetypes = { "astro" },
    mason_tools = {
      lsp = { "astro-language-server" },
      formatters = { "prettierd" },
    },
    lsp = {
      name = "astro-language-server",
      settings = {},
    },
    treesitter = { "astro" },
  })
end

return M
