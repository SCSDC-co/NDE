local function clock()
	return os.date("%H:%M")
end

return {
	"nvim-lualine/lualine.nvim",
	lazy = true, -- ⚡ PERFORMANCE: Only load after colorscheme
	event = "VeryLazy", -- ⚡ PERFORMANCE: Load after everything else
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"rebelot/kanagawa.nvim",
		"catppuccin/nvim",
		"folke/tokyonight.nvim",
		"ellisonleao/gruvbox.nvim",
		"Mofiqul/vscode.nvim",
		"projekt0n/github-nvim-theme",
	},
	config = function()
		require("lualine").setup({
			options = {
				theme = "auto", -- Use auto theme for reliable colorscheme compatibility
				icons_enabled = true,
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				globalstatus = true,
				-- Hide lualine on dashboard and other special buffers
				disabled_filetypes = {
					statusline = { "alpha", "snacks_dashboard" },
					winbar = {},
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress", "location" },
				lualine_z = { clock },
			},
			extensions = {
				"neo-tree",
				"oil",
				"fugitive",
				"trouble",
				"quickfix",
				"toggleterm",
				"aerial",
				"lazy",
				"mason",
			},
		})
	end,
}
