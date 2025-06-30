local M = {}

-- Configuration and Markup Languages
function M.setup()
  -- JSON
  require("optispec.core.languages").register_language("json", {
    filetypes = { "json", "jsonc" },
    mason_tools = {
      lsp = { "json-lsp" },
      formatters = { "prettierd" },
      linters = { "jsonlint" },
    },
    lsp = {
      name = "jsonls",
      settings = {},
    },
    treesitter = { "json" },
  })

  -- YAML
  require("optispec.core.languages").register_language("yaml", {
    filetypes = { "yaml", "yml" },
    mason_tools = {
      lsp = { "yaml-language-server" },
      formatters = { "prettierd" },
      linters = { "yamllint" },
    },
    lsp = {
      name = "yamlls",
      settings = {},
    },
    treesitter = { "yaml" },
  })

  -- TOML
  require("optispec.core.languages").register_language("toml", {
    filetypes = { "toml" },
    mason_tools = {
      lsp = { "taplo" },
      formatters = { "taplo" },
    },
    lsp = {
      name = "taplo",
      settings = {},
    },
    treesitter = { "toml" },
  })

  -- Markdown
  require("optispec.core.languages").register_language("markdown", {
    filetypes = { "markdown", "md" },
    mason_tools = {
      lsp = { "marksman" },
      formatters = { "prettierd" },
      linters = { "markdownlint" },
    },
    lsp = {
      name = "marksman",
      settings = {},
    },
    treesitter = { "markdown", "markdown_inline" },
  })

  -- Nix
  require("optispec.core.languages").register_language("nix", {
    filetypes = { "nix" },
    mason_tools = {
      lsp = { "nil_ls" },
      formatters = { "alejandra" },
    },
    lsp = {
      name = "nil_ls",
      settings = {},
    },
    treesitter = { "nix" },
  })

  -- CMake
  require("optispec.core.languages").register_language("cmake", {
    filetypes = { "cmake" },
    mason_tools = {
      lsp = { "cmake" },
    },
    lsp = {
      name = "cmake",
      settings = {},
    },
    treesitter = { "cmake" },
  })

  -- Git
  require("optispec.core.languages").register_language("git", {
    filetypes = { "gitcommit", "gitrebase", "gitconfig" },
    mason_tools = {},
    treesitter = { "git_config", "git_rebase", "gitcommit", "gitignore" },
  })

  -- LaTeX
  require("optispec.core.languages").register_language("tex", {
    filetypes = { "tex", "latex" },
    mason_tools = {
      lsp = { "texlab" },
    },
    lsp = {
      name = "texlab",
      settings = {},
    },
    treesitter = { "latex" },
  })

  -- Lua
  require("optispec.core.languages").register_language("lua", {
    filetypes = { "lua" },
    mason_tools = {
      lsp = { "lua_ls" },
      formatters = { "stylua" },
      linters = { "luacheck" },
    },
    lsp = {
      name = "lua_ls",
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    },
    treesitter = { "lua" },
  })

  -- Nushell
  require("optispec.core.languages").register_language("nushell", {
    filetypes = { "nu" },
    mason_tools = {
      lsp = { "nushell" },
    },
    lsp = {
      name = "nushell",
      settings = {},
    },
    treesitter = { "nu" },
  })

  -- Thrift
  require("optispec.core.languages").register_language("thrift", {
    filetypes = { "thrift" },
    mason_tools = {},
    treesitter = { "thrift" },
  })
end

return M
