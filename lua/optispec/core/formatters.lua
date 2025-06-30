local M = {}

-- Setup conform.nvim with default formatters
function M.setup()
  -- Add Mason bin to PATH so conform can find tools automatically
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
  
  require("conform").setup({
    formatters_by_ft = {
      -- Web Development (using prettierd for speed)
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      sass = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      
      -- Python (autopep8 fixes indentation, then black for style)
      python = { "autopep8", "black" },
      
      -- Go
      go = { "gofmt" },
      
      -- Rust
      rust = { "rustfmt" },
      
      -- C/C++
      c = { "clang-format" },
      cpp = { "clang-format" },
      
      -- Java
      java = { "google-java-format" },
      
      -- Lua
      lua = { "stylua" },
      
      -- Shell
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      
      -- SQL
      sql = { "sqlfluff" },
      
      -- PHP
      php = { "php-cs-fixer" },
      
      -- Ruby
      ruby = { "rubocop" },
      
      -- Elixir
      elixir = { "mix" },
      
      -- Haskell
      haskell = { "fourmolu" },
      
      -- OCaml
      ocaml = { "ocamlformat" },
      
      -- Terraform
      terraform = { "terraform_fmt" },
      
      -- Docker
      dockerfile = { "hadolint" },
      
      -- TOML
      toml = { "taplo" },
      
      -- XML
      xml = { "xmlformat" },
    },
    
    -- Format on save
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    
    -- Default format options
    default_format_opts = {
      lsp_fallback = true,
    },
  })
  
  -- Store formatter utilities globally
  _G.OptiSpec = _G.OptiSpec or {}
  _G.OptiSpec.formatters = {
    add_formatter = M.add_formatter,
    format_buffer = M.format_buffer,
  }
  
  -- Set up format keymap
  vim.keymap.set("n", "<leader>f", function()
    require("conform").format({ async = true, lsp_fallback = true })
  end, { desc = "Format buffer" })
end

-- Add formatter for a filetype
function M.add_formatter(filetype, formatter)
  local conform = require("conform")
  local current_formatters = conform.formatters_by_ft[filetype] or {}
  
  -- Add formatter if not already present
  if not vim.tbl_contains(current_formatters, formatter) then
    table.insert(current_formatters, formatter)
    conform.formatters_by_ft[filetype] = current_formatters
  end
end

-- Format current buffer
function M.format_buffer()
  require("conform").format({ async = true, lsp_fallback = true })
end

-- Plugin definitions
M.plugins = {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    config = function()
      M.setup({})
    end
  }
}

return M
