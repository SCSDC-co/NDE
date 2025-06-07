local kanagawa = require("kanagawa")

kanagawa.setup({
  theme = "dragon",
  transparent = false,
  terminalColors = true,
  dimInactive = false,
})

vim.cmd("colorscheme kanagawa-dragon")
