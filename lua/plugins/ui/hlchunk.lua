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
					{ fg = "#2a2a2a" },
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
				style = {
					{ fg = "#FF9E3B" },
				},
				chars = {
					horizontal_line = "─",
					vertical_line = "│",
					left_top = "╭",
					left_bottom = "╰",
				    right_arrow = "─",
				},
				-- Disable textobject annotations (removes ▶ def tags)
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

			-- Disable context/scope annotations (the annoying ▶ def tags)
			context = {
				enable = false,
			},

			-- Disable line number highlighting
			line_num = {
				enable = false,
			},

			-- Disable blank line highlighting
			blank = {
				enable = false,
			},
		})
		
		-- Force set highlight groups after setup
		vim.defer_fn(function()
			-- Indent highlight groups (with the darker color as requested)
			vim.api.nvim_set_hl(0, "HLIndent1", { fg = "#2a2a2a" })
			vim.api.nvim_set_hl(0, "HLIndent2", { fg = "#2a2a2a" })
			vim.api.nvim_set_hl(0, "HLIndent3", { fg = "#2a2a2a" })
			vim.api.nvim_set_hl(0, "HLIndent4", { fg = "#2a2a2a" })
			vim.api.nvim_set_hl(0, "HLIndent5", { fg = "#2a2a2a" })
			-- Chunk highlight groups
			vim.api.nvim_set_hl(0, "HLChunk1", { fg = "#FF9E3B" })
			vim.api.nvim_set_hl(0, "HLChunk2", { fg = "#FF9E3B" })
			vim.api.nvim_set_hl(0, "HLChunk3", { fg = "#FF9E3B" })
			vim.api.nvim_set_hl(0, "HLChunk4", { fg = "#FF9E3B" })
			vim.api.nvim_set_hl(0, "HLChunk5", { fg = "#FF9E3B" })
		end, 100)
	end,
}
