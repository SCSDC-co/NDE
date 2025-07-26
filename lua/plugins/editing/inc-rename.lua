-- inc-rename.nvim - Incremental LSP renaming with live preview
-- Enhanced with noice.nvim integration for beautiful UI

return {
	"smjonas/inc-rename.nvim",
	event = "LspAttach",
	opts = {
		-- Command name to use for renaming
		cmd_name = "IncRename",
		-- Highlight group for references
		hl_group = "Substitute",
		-- Preview empty name (shows what will be renamed)
		preview_empty_name = false,
		-- Show message after renaming
		show_message = true,
		-- Save command in history
		save_in_cmdline_history = true,
		-- Post hook after renaming
		post_hook = nil,
	},
	init = function()
		-- Key mappings that will trigger plugin loading
		vim.keymap.set("n", "<leader>rn", function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end, {
			expr = true,
			desc = "󰑕 Incremental Rename",
		})

		-- Alternative mapping for visual mode
		vim.keymap.set("v", "<leader>rn", function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end, {
			expr = true,
			desc = "󰑕 Incremental Rename (Visual)",
		})
	end,
	config = function(_, opts)
		require("inc_rename").setup(opts)
	end,
}
