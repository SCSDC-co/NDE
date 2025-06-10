return {
	{
		"Pocco81/auto-save.nvim",
		config = function()
			require("auto-save").setup({
				trigger_events = { "InsertLeave" },
				execution_message = {
					message = function()
						return ("💾 " .. vim.fn.strftime("%H:%M:%S"))
					end,
				},
			})
		end,
	},
}
