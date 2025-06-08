return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      -- Python
      python = { "black", "isort" },
      
      -- JavaScript/TypeScript
      javascript = { { "prettierd", "prettier" } },
      typescript = { { "prettierd", "prettier" } },
      javascriptreact = { { "prettierd", "prettier" } },
      typescriptreact = { { "prettierd", "prettier" } },
      
      -- Web Technologies
      html = { { "prettierd", "prettier" } },
      css = { { "prettierd", "prettier" } },
      scss = { { "prettierd", "prettier" } },
      
      -- C/C++
      c = { "clang_format" },
      cpp = { "clang_format" },
      
      -- Other Languages
      lua = { "stylua" },
      go = { "gofmt" },
      rust = { "rustfmt" },
      java = { "google-java-format" },
      
      -- Data formats
      json = { { "prettierd", "prettier" } },
      yaml = { { "prettierd", "prettier" } },
      markdown = { { "prettierd", "prettier" } },
      
      -- Shell
      sh = { "shfmt" },
      bash = { "shfmt" },
      
      -- Assembly
      asm = { "asmfmt" },
    },
    
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
      black = {
        prepend_args = { "--fast" },
      },
      clang_format = {
        prepend_args = { "--style=file" },
      },
    },
  },
  
  config = function(_, opts)
    require("conform").setup(opts)
    
    -- Set filetype for assembly files
    vim.cmd([[
      autocmd BufRead,BufNewFile *.asm set filetype=asm
    ]])
  end,
}
