local kanagawa = require("kanagawa")

kanagawa.setup({
  theme = "dragon", 
  transparent = false, 
  terminalColors = true,
  dimInactive = true,
  overrides = function(colors)
    return {
    }
  end,
})

vim.cmd("colorscheme kanagawa-dragon")
