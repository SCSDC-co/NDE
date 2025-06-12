return {
	"saghen/blink.nvim",
	build = "cargo build --release",
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
	lazy = false,
	opts = {
		chartoggle = { enabled = true },
	},
}
