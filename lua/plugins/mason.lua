return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- Systems Programming
          "clangd",           -- C/C++
          "rust_analyzer",    -- Rust
          "omnisharp",        -- C#
          "asm_lsp",          -- Assembly
          
          -- Web Development
          "ts_ls",            -- TypeScript/JavaScript
          "eslint",           -- ESLint
          "html",             -- HTML
          "cssls",            -- CSS
          "tailwindcss",      -- Tailwind CSS
          "emmet_ls",         -- Emmet
          
          -- Backend Languages
          "pyright",          -- Python
          "ruff",             -- Python linting
          "gopls",            -- Go
          "jdtls",            -- Java
          
          -- Scripting & Config
          "lua_ls",           -- Lua
          "bashls",           -- Bash
          
          -- Data & Markup
          "jsonls",           -- JSON
          "yamlls",           -- YAML
          "marksman",         -- Markdown
          "taplo",            -- TOML
          
          -- DevOps
          "dockerls",         -- Docker
          "docker_compose_language_service", -- Docker Compose
        },
        automatic_installation = true,
      })
    end,
  },
}
