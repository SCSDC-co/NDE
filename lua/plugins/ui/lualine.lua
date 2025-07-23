local function clock()
	return os.date("%H:%M:%S")
end

return {
	"nvim-lualine/lualine.nvim",
	lazy = true, -- ⚡ PERFORMANCE: Only load after colorscheme
	event = "VeryLazy", -- ⚡ PERFORMANCE: Load after everything else
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"rebelot/kanagawa.nvim", -- Ensure kanagawa loads first
	},
	config = function()
		require("lualine").setup({
			options = {
				theme = "auto", -- Let lualine detect theme automatically
				icons_enabled = true,
				section_separators = { left = "", right = "" },
				component_separators = "|",
				globalstatus = true,
				-- Hide lualine on dashboard and other special buffers
				disabled_filetypes = {
					statusline = { "alpha", "dashboard" },
					winbar = {},
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics", clock },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
