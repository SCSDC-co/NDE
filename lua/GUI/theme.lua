local kanagawa = require("kanagawa")

kanagawa.setup({
	theme = "dragon",
	transparent = false,
	terminalColors = false,
	dimInactive = false,
	overrides = function(colors)
		return {
			NormalLineNr = { bg = "#181616" },
			LineNr = { bg = "#181616" },
			CursorLineNr = { bg = "#181616" },
			SignColumn = { bg = "#181616" },
			GitSignsAdd = { bg = "#181616" },
			GitSignsChange = { bg = "#181616" },
			GitSignsDelete = { bg = "#181616" },
			DiagnosticSignError = { bg = "#181616" },
			DiagnosticSignWarn = { bg = "#181616" },
			DiagnosticSignInfo = { bg = "#181616" },
			DiagnosticSignHint = { bg = "#181616" },
			VertSplit = { fg = "#0D0C0C", bg = "#0D0C0C" },
			WinSeparator = { fg = "#0D0C0C", bg = "#0D0C0C" },
			BufferLineOffset = { bg = "#0d0c0c", fg = "#8BA4B0", bold = true },
			BufferLineOffsetSeparator = { bg = "#0d0c0c", fg = "#0d0c0c" },
			TerminalNormal = { bg = "#181616" },
			TerminalBorder = { fg = "#181616", bg = "#181616" },
			Terminal = { bg = "#181616" },
			WhichKey = { fg = "#B7B39B", bg = "#181616" },
			WhichKeyGroup = { fg = "#54546D", bg = "#181616" },
			WhichKeyDesc = { fg = "#7FA5A6", bg = "#181616" },
			WhichKeyValue = { fg = "#7FA5A6", bg = "#181616" },
			WhichKeySeparator = { fg = "#54546D", bg = "#181616" },
			WhichKeyFloat = { bg = "#181616" },
			WhichKeyBorder = { fg = "#54546D", bg = "#181616" },
			WhichKeyTitle = { fg = "#54546D", bg = "#181616" },
			WhichKeyNormal = { bg = "#181616" },
		}
	end,
})

vim.cmd("colorscheme kanagawa-dragon")
