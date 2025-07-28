local M = {}

-- Systems Programming Language Configurations
function M.setup()
  -- Rust
  require("optispec.core.languages").register_language("rust", {
    filetypes = { "rust" },
    mason_tools = {
      lsp = { "rust_analyzer" },
      formatters = { "rustfmt" },
      linter = { "clippy" },
    },
    lsp = {
      name = "rust_analyzer",
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          checkOnSave = { command = "clippy" },
        },
      },
    },
    treesitter = { "rust" },
  })

  -- Go
  require("optispec.core.languages").register_language("go", {
    filetypes = { "go" },
    mason_tools = {
      lsp = { "gopls" },
      formatters = { "gofmt" },
      linter = { "golangci_lint" },
      dap = { "delve" },
    },
    lsp = {
      name = "gopls",
      settings = {},
    },
    treesitter = { "go" },
  })

  -- C/C++ (clangd)
  require("optispec.core.languages").register_language("clangs", {
    filetypes = { "c", "cpp", "objc", "objcpp" },
    mason_tools = {
      lsp = { "clangd" },
      formatters = { "clang-format" },
      linter = { "cppcheck" },
      dap = { "codelldb" },
    },
    lsp = {
      name = "clangd",
      settings = {},
    },
    treesitter = { "c", "cpp" },
  })

  -- Zig
  require("optispec.core.languages").register_language("zig", {
    filetypes = { "zig" },
    mason_tools = {
      lsp = { "zls" },
    },
    lsp = {
      name = "zls",
      settings = {},
    },
    treesitter = { "zig" },
  })

  -- Java
  require("optispec.core.languages").register_language("java", {
    filetypes = { "java" },
    mason_tools = {
      lsp = { "jdtls" },
      formatters = { "google-java-format" },
      dap = { "java-debug-adapter" },
    },
    lsp = {
      name = "jdtls",
      settings = {},
    },
    treesitter = { "java" },
  })

  -- Kotlin
  require("optispec.core.languages").register_language("kotlin", {
    filetypes = { "kotlin" },
    mason_tools = {
      lsp = { "kotlin-language-server" },
    },
    lsp = {
      name = "kotlin_language_server",
      settings = {},
    },
    treesitter = { "kotlin" },
  })

  -- Scala
  require("optispec.core.languages").register_language("scala", {
    filetypes = { "scala" },
    mason_tools = {
      lsp = { "metals" },
    },
    lsp = {
      name = "metals",
      settings = {},
    },
    treesitter = { "scala" },
  })

  -- C# (OmniSharp)
  require("optispec.core.languages").register_language("csharp", {
    filetypes = { "cs", "cshtml" },
    mason_tools = {
      lsp = { "omnisharp" },
      formatters = { "csharpier" },
    },
    lsp = {
      name = "omnisharp",
      settings = {},
    },
    treesitter = { "c_sharp" },
  })
end

return M
