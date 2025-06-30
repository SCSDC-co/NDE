local M = {}

-- Setup nvim-lint with default linters
function M.setup(config)
  -- Add Mason bin to PATH so nvim-lint can find tools automatically
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
  
  local lint = require("lint")
  
  -- Configure linters by filetype
  lint.linters_by_ft = {
    -- Web Development
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    
    -- Python
    python = { "flake8" },
    
    -- Go
    go = { "golangcilint" },
    
    -- Rust (rustc provides good diagnostics via LSP)
    -- rust = {},
    
    -- C/C++
    c = { "cppcheck" },
    cpp = { "cppcheck" },
    
    -- Shell
    sh = { "shellcheck" },
    bash = { "shellcheck" },
    zsh = { "shellcheck" },
    
    -- Lua
    lua = { "luacheck" },
    
    -- Docker
    dockerfile = { "hadolint" },
    
    -- YAML
    yaml = { "yamllint" },
    
    -- JSON
    json = { "jsonlint" },
    
    -- Markdown
    markdown = { "markdownlint" },
    
    -- SQL
    sql = { "sqlfluff" },
    
    -- PHP
    php = { "phpcs" },
    
    -- Ruby
    ruby = { "rubocop" },
    
    -- Terraform
    terraform = { "tflint" },
    
    -- TOML
    toml = { "taplo" },
  }
  
  -- Configure jsonlint with full path if needed
  local jsonlint_path = vim.fn.exepath("jsonlint")
  if jsonlint_path ~= "" then
    lint.linters.jsonlint.cmd = jsonlint_path
  end
  
  -- Setup autocommands for linting
  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
  
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })
  
  -- Store linter utilities globally
  _G.OptiSpec = _G.OptiSpec or {}
  _G.OptiSpec.linters = {
    add_linter = M.add_linter,
    lint_buffer = M.lint_buffer,
  }
end

-- Add linter for a filetype
function M.add_linter(filetype, linter)
  local lint = require("lint")
  local current_linters = lint.linters_by_ft[filetype] or {}
  
  -- Add linter if not already present
  if not vim.tbl_contains(current_linters, linter) then
    table.insert(current_linters, linter)
    lint.linters_by_ft[filetype] = current_linters
  end
end

-- Lint current buffer
function M.lint_buffer()
  require("lint").try_lint()
end

-- Plugin definitions
M.plugins = {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      M.setup({})
    end
  }
}

return M
