return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      c = { "clangtidy" },
      cpp = { "clangtidy" },
      python = { "flake8" },
      javascript = { "eslint" },
      typescript = { "eslint" },
      asm = { "asmfmt" }, 
      css = { "stylelint" },
      html = { "tidy" }, 
      lua = { "luacheck" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
