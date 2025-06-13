return {
	"ggandor/leap.nvim",
	lazy = true, -- ⚡ PERFORMANCE: Load on keys only
	keys = {
		{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
		{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
		{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
	},
	config = function()
		require("leap").add_default_mappings()
	end,
}
