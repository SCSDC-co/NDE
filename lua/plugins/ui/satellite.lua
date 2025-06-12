return {
	"lewis6991/satellite.nvim",
	event = "VeryLazy",
	config = function()
		require("satellite").setup({
			current_only = true,
			winblend = 0,
			zindex = 40,
			excluded_filetypes = {},
			width = 2,
			handlers = {
				cursor = { enabled = true },
				search = { enabled = true },
				diagnostic = { enabled = true },
				gitsigns = { enabled = true },
				marks = { enabled = true },
			},
		})
	end,
}
