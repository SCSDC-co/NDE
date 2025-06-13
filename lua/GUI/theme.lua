local kanagawa = require('kanagawa')

kanagawa.setup({
	theme = 'dragon',
	transparent = false,
	terminalColors = true,
	dimInactive = false,
	overrides = function(colors)
		return {
			NormalLineNr = { bg = '#181616' },
			LineNr = { bg = '#181616' },
			CursorLineNr = { bg = '#181616' },
			SignColumn = { bg = '#181616' },
			GitSignsAdd = { bg = '#181616' },
			GitSignsChange = { bg = '#181616' },
			GitSignsDelete = { bg = '#181616' },
			DiagnosticSignError = { bg = '#181616' },
			DiagnosticSignWarn = { bg = '#181616' },
			DiagnosticSignInfo = { bg = '#181616' },
			DiagnosticSignHint = { bg = '#181616' },
			VertSplit = { fg = '#0D0C0C', bg = '#0D0C0C' },
			WinSeparator = { fg = '#0D0C0C', bg = '#0D0C0C' },
			BufferLineOffset = { bg = '#0d0c0c', fg = '#8BA4B0', bold = true },
			BufferLineOffsetSeparator = { bg = '#0d0c0c', fg = '#0d0c0c' },
		}
	end,
})

vim.cmd('colorscheme kanagawa-dragon')
