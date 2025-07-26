return {
	"echasnovski/mini.move",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("mini.move").setup({
			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				-- Move visual selection in Visual mode
				left = "<M-H>",
				right = "<M-L>",
				down = "<M-J>",
				up = "<M-K>",

				-- Move current line in Normal mode
				line_left = "<M-H>",
				line_right = "<M-L>",
				line_down = "<M-J>",
				line_up = "<M-K>",
			},

			-- Options which control moving behavior
			options = {
				-- Automatically reindent selection during linewise vertical move
				reindent_linewise = true,
			},
		})
	end,
}
