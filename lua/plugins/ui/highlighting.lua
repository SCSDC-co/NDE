return {
	-- Local word highlighting
	{
		"tzachar/local-highlight.nvim",
		lazy = false,
		config = function()
			require("local-highlight").setup({
				hlgroup = "LocalHighlight",
				cw_hlgroup = "LocalHighlightWrite",
				insert_mode = true,
				min_match_len = 2,
				max_match_len = math.huge,
				disable_file_types = { "help", "qf", "neo-tree", "Telescope", "floggraph", "aerial", "dashboard" },
				-- Only highlight words that appear multiple times
				highlight_single_match = false,
			})

			-- Use default local-highlight colors for better compatibility
		end,
	},

	-- Standalone matchparen plugin
	{
		"monkoose/matchparen.nvim",
		lazy = false,
		opts = {
			enabled = true,
			debounce_time = 0,
			hl_group = "LocalHighlight",
		},
	},
}
