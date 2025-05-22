local kanagawa = require("kanagawa")

kanagawa.setup({
  theme = "dragon",
  transparent = true,
  terminalColors = true,
  dimInactive = false,
  overrides = function(colors)
    return {
      LineNr = { bg = "NONE", fg = "#f3f3f3" },
      CursorLineNr = { bg = "NONE", fg = "#f3f3f3" },
      SignColumn = { bg = "NONE" },
      DiagnosticSignError = { bg = "NONE" },
      DiagnosticSignWarn = { bg = "NONE" },
      DiagnosticSignInfo = { bg = "NONE" },
      DiagnosticSignHint = { bg = "NONE" },
  }
  end,
})

vim.cmd("colorscheme kanagawa-dragon")
