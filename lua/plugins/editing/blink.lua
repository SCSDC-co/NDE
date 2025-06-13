	return {
		"saghen/blink.nvim",
		build = "cargo build --release",
		lazy = true, -- ⚡ PERFORMANCE: Only load when needed
		keys = {
			-- chartoggle
			{
				"<leader>B;",
				function()
					require("blink.chartoggle").toggle_char_eol(";")
				end,
				mode = { "n", "v" },
				desc = "Toggle ; at eol",
			},
			{
				"<leader>B,",
				function()
					require("blink.chartoggle").toggle_char_eol(",")
				end,
				mode = { "n", "v" },
				desc = "Toggle , at eol",
			},
		},
	opts = {
		chartoggle = { enabled = true },
	},
}
