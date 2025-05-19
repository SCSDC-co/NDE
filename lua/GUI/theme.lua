local kanagawa = require("kanagawa")

kanagawa.setup({
  theme = "dragon",
  transparent = true,
  terminalColors = true,
  dimInactive = false,
  overrides = function(colors)
    return {
      LineNr = { bg = "NONE", fg = "#f3f3f3" },
      CursorLineNr = { bg = "NONE", fg = "#f3f3f3" }
  }
  end,
})

vim.cmd("colorscheme kanagawa-dragon")
