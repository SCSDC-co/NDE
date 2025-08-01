return {
	"kosayoda/nvim-lightbulb",
	event = "LspAttach",
	config = function()
		require("nvim-lightbulb").setup({
			autocmd = {
				enabled = true,
				updatetime = 50,
				events = { "CursorHold", "CursorHoldI" },
				pattern = { "*" },
			},
			ignore = {
				ft = { "snacks_dashboard", "neo-tree", "aerial" },
			},
			priority = 9999,
			virtual_text = {
				enabled = true,
				text = " 󰌵",
				lens_text = " ",
				pos = "eol",
				hl = "LightBulbVirtualText",
				hl_mode = "combine",
			},
			float = { enabled = false },
			status_text = { enabled = false },
			number = { enabled = false },
			line = { enabled = false },
			sign = { enabled = false },
		})
	end,
}
