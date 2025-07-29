local M = {}

-- Functional and Academic Languages
function M.setup()
  -- Haskell
  require("optispec.core.languages").register_language("haskell", {
    filetypes = { "haskell", "lhaskell" },
    mason_tools = {
      lsp = { "haskell-language-server" },
      formatters = { "fourmolu" },
      dap = { "haskell-debug-adapter" },
    },
    lsp = {
      name = "hls",
      settings = {},
    },
    treesitter = { "haskell" },
  })

  -- OCaml
  require("optispec.core.languages").register_language("ocaml", {
    filetypes = { "ocaml", "ocaml_interface" },
    mason_tools = {
      lsp = { "ocaml-lsp" },
      formatters = { "ocamlformat" },
      dap = { "ocamlearlybird" },
    },
    lsp = {
      name = "ocamllsp",
      settings = {},
    },
    treesitter = { "ocaml", "ocaml_interface" },
  })

  -- Clojure
  require("optispec.core.languages").register_language("clojure", {
    filetypes = { "clojure", "edn" },
    mason_tools = {
      lsp = { "clojure_lsp" },
    },
    lsp = {
      name = "clojure_lsp",
      settings = {},
    },
    treesitter = { "clojure" },
  })

  -- Erlang
  require("optispec.core.languages").register_language("erlang", {
    filetypes = { "erlang" },
    mason_tools = {
      lsp = { "erlangls" },
      dap = { "erlang-debugger" },
    },
    lsp = {
      name = "erlangls",
      settings = {},
    },
    treesitter = { "erlang" },
  })

  -- Elm
  require("optispec.core.languages").register_language("elm", {
    filetypes = { "elm" },
    mason_tools = {
      lsp = { "elmls" },
      formatters = { "elm-format" },
    },
    lsp = {
      name = "elmls",
      settings = {},
    },
    treesitter = { "elm" },
  })

  -- Gleam
  require("optispec.core.languages").register_language("gleam", {
    filetypes = { "gleam" },
    mason_tools = {
      lsp = { "gleam" },
    },
    lsp = {
      name = "gleam",
      settings = {},
    },
    treesitter = { "gleam" },
  })

  -- Lean
  require("optispec.core.languages").register_language("lean", {
    filetypes = { "lean" },
    mason_tools = {
      lsp = { "lean3ls" },
    },
    lsp = {
      name = "lean3ls",
      settings = {},
    },
    treesitter = { "lean" },
  })
end

return M
