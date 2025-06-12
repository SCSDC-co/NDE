return {
	"GustavEikaas/code-playground.nvim",
	config = function()
		require("code-playground").setup({
			split_direction = "vsplit", -- split | vsplit
			auto_change_cwd = false,
			animation = "wave", -- wave | spinner
		})
	end,
}
