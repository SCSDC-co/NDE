local kanagawa = require("kanagawa")
local highlights = require("GUI.highlights")

kanagawa.setup({
	theme = "dragon",
	transparent = false,
	terminalColors = false,
	dimInactive = false,
	overrides = function(colors)
		return highlights
	end,
})

vim.cmd("colorscheme kanagawa-dragon")

