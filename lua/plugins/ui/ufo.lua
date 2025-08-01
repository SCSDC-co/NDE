return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
		"nvim-treesitter/nvim-treesitter",
	},
	event = "BufReadPost",
	keys = {
		{
			"zR",
			function()
				require("ufo").openAllFolds()
			end,
			desc = "Open all folds",
		},
		{
			"zM",
			function()
				require("ufo").closeAllFolds()
			end,
			desc = "Close all folds",
		},
		{
			"zr",
			function()
				require("ufo").openFoldsExceptKinds()
			end,
			desc = "Fold less",
		},
		{
			"zm",
			function()
				require("ufo").closeFoldsWith()
			end,
			desc = "Fold more",
		},
		{
			"zp",
			function()
				require("ufo").peekFoldedLinesUnderCursor()
			end,
			desc = "Peek fold",
		},
	},
	config = function()
		-- UFO configuration
		require("ufo").setup({
			-- Use treesitter and LSP for folding
			provider_selector = function(bufnr, filetype, buftype)
				-- Use LSP for better folding if available
				local lsp_clients = vim.lsp.get_clients({ bufnr = bufnr })
				if #lsp_clients > 0 then
					return { "lsp", "treesitter" }
				else
					return { "treesitter", "indent" }
				end
			end,

			-- Custom fold text
			fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
				local fold_lines = endLnum - lnum + 1

				-- Add line count right after the folded content
				local suffix = string.format("  %d lines", fold_lines)
				table.insert(virtText, { suffix, "Comment" })

				return virtText
			end,

			-- Preview configuration
			preview = {
				win_config = {
					border = "rounded",
					winblend = 12,
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
				},
				mappings = {
					scrollB = "<C-b>",
					scrollF = "<C-f>",
					scrollU = "<C-u>",
					scrollD = "<C-d>",
				},
			},

			-- Enable preview for peek
			enable_get_fold_virt_text = true,
		})
	end,
}
