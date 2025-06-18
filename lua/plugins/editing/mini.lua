return {
	{
		"echasnovski/mini.surround",
		event = "VeryLazy",
		config = function()
			require("mini.surround").setup({
				mappings = {
					add = 'ys', -- Add surrounding in Normal and Visual modes
					delete = 'ds', -- Delete surrounding
					find = 'gzf', -- Find surrounding (to the right)
					find_left = 'gzF', -- Find surrounding (to the left)
					highlight = 'gzh', -- Highlight surrounding
					replace = 'cs', -- Replace surrounding
					update_n_lines = 'gzn', -- Update `n_lines`
					suffix_last = 'l', -- Suffix to search with "prev" method
					suffix_next = 'n', -- Suffix to search with "next" method
				},
			})
		end,
	},
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		config = function()
			require("mini.pairs").setup()
		end,
	},
}

