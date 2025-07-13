return {
	"shellRaining/hlchunk.nvim",
	lazy = true, -- ⚡ PERFORMANCE: Only load when viewing code
	event = { "BufReadPost", "BufNewFile" }, -- Load after buffer is fully loaded
	config = function()
		require("hlchunk").setup({
			indent = {
				enable = true,
				chars = {
					"│",
				},
				style = {
					{ fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("HLIndent1")), "fg", "gui") },
					{ fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("HLIndent2")), "fg", "gui") },
					{ fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("HLIndent3")), "fg", "gui") },
					{ fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("HLIndent4")), "fg", "gui") },
					{ fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("HLIndent5")), "fg", "gui") },
				},
				exclude_filetypes = {
					"dashboard",
					"help",
					"lspinfo",
					"packer",
					"checkhealth",
					"man",
					"mason",
					"neo-tree",
				},
			},

			chunk = {
				enable = true,
				chars = {
					horizontal_line = "─",
					vertical_line = "│",
					left_top = "╭",
					left_bottom = "╰",
					right_arrow = "─",
				},
				style = {
					{ fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("HLChunk1")), "fg", "gui") },
					{ fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("HLChunk2")), "fg", "gui") },
					{ fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("HLChunk3")), "fg", "gui") },
					{ fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("HLChunk4")), "fg", "gui") },
					{ fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("HLChunk5")), "fg", "gui") },
				},
				textobject = "",
				exclude_filetypes = {
					"dashboard",
					"help",
					"lspinfo",
					"packer",
					"checkhealth",
					"man",
					"mason",
					"neo-tree",
				},
			},

			context = {
				enable = false,
			},

			line_num = {
				enable = false,
			},

			blank = {
				enable = false,
			},
		})

	end,
}
