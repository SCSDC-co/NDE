return {
	"folke/zen-mode.nvim",
	lazy = true, -- ⚡ PERFORMANCE: Load on command only
	cmd = "ZenMode",
	keys = {
		{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
	},
	opts = {},
}
