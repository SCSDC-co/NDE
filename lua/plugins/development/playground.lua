return {
	"GustavEikaas/code-playground.nvim",
	lazy = true, -- ⚡ PERFORMANCE: Only load on command
	cmd = { "PlaygroundToggle", "PlaygroundLoad", "PlaygroundSave" },
	config = function()
		require("code-playground").setup({
			split_direction = "vsplit", -- split | vsplit
			auto_change_cwd = false,
			animation = "wave", -- wave | spinner
		})
	end,
}
