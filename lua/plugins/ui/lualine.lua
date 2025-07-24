-- Function to get highlight color (like heirline utils.get_highlight)
local function get_highlight(group, attr)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
	if ok and hl and hl[attr] then
		return string.format("#%06x", hl[attr])
	end
	return nil
end

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
		-- Extract colors from colorscheme
		local normal_bg = get_highlight("Normal", "bg")
		local bright_fg = get_highlight("Normal", "fg")
		local linenr_fg = get_highlight("LineNr", "fg")
		local green = get_highlight("String", "fg")
		local blue = get_highlight("Function", "fg")
		local red = get_highlight("DiagnosticError", "fg")
		local orange = get_highlight("WarningMsg", "fg")
		local purple = get_highlight("Statement", "fg")

		-- Override colors for gruvbox theme
		local colorscheme = vim.g.colors_name or ""
		if colorscheme == "gruvbox" then
			-- Use specific Gruvbox colors
			purple = get_highlight("GruvboxPurple", "fg") or red
			orange = get_highlight("GruvboxOrange", "fg") or orange
			red = get_highlight("GruvboxRed", "fg") or red
			blue = get_highlight("GruvboxBlue", "fg") or blue
		end

		-- Create custom lualine theme
		local theme = {
			normal = {
				a = { fg = normal_bg, bg = purple, gui = "bold" },
				b = { fg = bright_fg, bg = linenr_fg },
				c = { fg = bright_fg, bg = normal_bg },
				x = { fg = bright_fg, bg = normal_bg },
				y = { fg = bright_fg, bg = linenr_fg },
				z = { fg = normal_bg, bg = purple, gui = "bold" },
			},
			insert = {
				a = { fg = normal_bg, bg = green, gui = "bold" },
				z = { fg = normal_bg, bg = green, gui = "bold" },
				b = { fg = green, bg = linenr_fg },
				y = { fg = green, bg = linenr_fg },
			},
			visual = {
				a = { fg = normal_bg, bg = red, gui = "bold" },
				z = { fg = normal_bg, bg = red, gui = "bold" },
				b = { fg = red, bg = linenr_fg },
				y = { fg = red, bg = linenr_fg },
			},
			replace = {
				a = { fg = normal_bg, bg = blue, gui = "bold" },
				z = { fg = normal_bg, bg = blue, gui = "bold" },
				b = { fg = blue, bg = linenr_fg },
				y = { fg = blue, bg = linenr_fg },
			},
			command = {
				a = { fg = normal_bg, bg = orange, gui = "bold" },
				z = { fg = normal_bg, bg = orange, gui = "bold" },
				b = { fg = orange, bg = linenr_fg },
				y = { fg = orange, bg = linenr_fg },
			},
		}

		require("lualine").setup({
			options = {
				theme = theme,
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
