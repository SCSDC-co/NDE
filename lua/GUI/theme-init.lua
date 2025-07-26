-- theme-init.lua
-- Helper functions for proper theme initialization

local M = {}

function M.setup_dragon()
	local highlights = require("GUI.highlights-kanagawa-dragon")
	require("kanagawa").setup({
		theme = "dragon",
		transparent = false,
		terminalColors = false,
		dimInactive = false,
		overrides = function(colors)
			return highlights
		end,
	})
	-- Force apply highlights after colorscheme loads
	vim.schedule(function()
		for name, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, opts)
		end
		-- Heirline will automatically update colors on ColorScheme event
	end)
end

function M.setup_lotus()
	local highlights = require("GUI.highlights-kanagawa-lotus")
	require("kanagawa").setup({
		theme = "lotus",
		transparent = false,
		terminalColors = false,
		dimInactive = false,
		overrides = function(colors)
			return highlights
		end,
	})
	-- Force apply highlights after colorscheme loads
	vim.schedule(function()
		for name, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, opts)
		end
		-- Heirline will automatically update colors on ColorScheme event
	end)
end

function M.setup_catppuccin_mocha()
	local highlights = require("GUI.highlights-catppuccin-mocha")
	require("catppuccin").setup({
		flavour = "mocha",
		background = {
			light = "latte",
			dark = "mocha",
		},
		transparent_background = false,
		show_end_of_buffer = false,
		term_colors = false,
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.15,
		},
		no_italic = false,
		no_bold = false,
		no_underline = false,
		styles = {
			comments = { "italic" },
			conditionals = {},
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
		},
		color_overrides = {},
		custom_highlights = function(colors)
			return highlights
		end,
		integrations = {
			cmp = true,
			gitsigns = true,
			nvimtree = true,
			treesitter = true,
			notify = false,
			mini = {
				enabled = true,
				indentscope_color = "",
			},
			alpha = true,
			dashboard = true,
			telescope = {
				enabled = true,
			},
			lsp_trouble = true,
			which_key = true,
			harpoon = true,
			mason = true,
			noice = true,
			leap = true,
			illuminate = {
				enabled = true,
				lsp = true,
			},
			rainbow_delimiters = true,
		},
	})
	-- Force apply highlights after colorscheme loads
	vim.schedule(function()
		for name, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, opts)
		end
		-- Heirline will automatically update colors on ColorScheme event
	end)
end

function M.setup_catppuccin_latte()
	local highlights = require("GUI.highlights-catppuccin-latte")
	require("catppuccin").setup({
		flavour = "latte",
		background = {
			light = "latte",
			dark = "mocha",
		},
		transparent_background = false,
		show_end_of_buffer = false,
		term_colors = false,
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.15,
		},
		no_italic = false,
		no_bold = false,
		no_underline = false,
		styles = {
			comments = { "italic" },
			conditionals = {},
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
		},
		color_overrides = {},
		custom_highlights = function(colors)
			return highlights
		end,
		integrations = {
			cmp = true,
			gitsigns = true,
			nvimtree = true,
			treesitter = true,
			notify = false,
			mini = {
				enabled = true,
				indentscope_color = "",
			},
			alpha = true,
			dashboard = true,
			telescope = {
				enabled = true,
			},
			lsp_trouble = true,
			which_key = true,
			harpoon = true,
			mason = true,
			noice = true,
			leap = true,
			illuminate = {
				enabled = true,
				lsp = true,
			},
			rainbow_delimiters = true,
		},
	})
	-- Force apply highlights after colorscheme loads
	vim.schedule(function()
		for name, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, opts)
		end
		-- Heirline will automatically update colors on ColorScheme event
	end)
end

function M.setup_tokyonight_moon()
	local highlights = require("GUI.highlights-tokyonight-moon")
	require("tokyonight").setup({
		style = "moon",
		light_style = "day",
		transparent = false,
		terminal_colors = false,
		styles = {
			comments = { italic = true },
			keywords = {},
			functions = {},
			variables = {},
			sidebars = "dark",
			floats = "dark",
		},
		sidebars = { "qf", "help", "vista_kind", "terminal", "spectre_panel", "NeogitStatus", "toggleterm" },
		day_brightness = 0.3,
		hide_inactive_statusline = false,
		dim_inactive = false,
		lualine_bold = false,
		on_colors = function(colors) end,
		on_highlights = function(highlights_default, colors)
			return highlights
		end,
	})
	-- Force apply highlights after colorscheme loads
	vim.schedule(function()
		for name, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, opts)
		end
		-- Force reload lualine with new theme
		pcall(function()
			require("lualine").setup({
				options = {
					theme = "auto",
				},
			})
		end)
	end)
end

function M.setup_tokyonight_day()
	local highlights = require("GUI.highlights-tokyonight-day")
	require("tokyonight").setup({
		style = "day",
		light_style = "day",
		transparent = false,
		terminal_colors = false,
		styles = {
			comments = { italic = true },
			keywords = {},
			functions = {},
			variables = {},
			sidebars = "light",
			floats = "light",
		},
		sidebars = { "qf", "help", "vista_kind", "terminal", "spectre_panel", "NeogitStatus", "toggleterm" },
		day_brightness = 0.3,
		hide_inactive_statusline = false,
		dim_inactive = false,
		lualine_bold = false,
		on_colors = function(colors) end,
		on_highlights = function(highlights_default, colors)
			return highlights
		end,
	})
	-- Force apply highlights after colorscheme loads
	vim.schedule(function()
		for name, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, opts)
		end
		-- Force reload lualine with new theme
		pcall(function()
			require("lualine").setup({
				options = {
					theme = "auto",
				},
			})
		end)
	end)
end

function M.setup_gruvbox_dark()
	local highlights = require("GUI.highlights-gruvbox-dark")
	require("gruvbox").setup({
		terminal_colors = false,
		undercurl = false,
		underline = true,
		bold = true,
		italic = {
			comments = true,
		},
		strikethrough = true,
		invert_selection = false,
		invert_signs = false,
		invert_tabline = false,
		invert_intend_guides = false,
		inverse = true,
		contrast = "", -- can be "hard", "soft" or empty string
		palette_overrides = {},
		overrides = highlights,
		dim_inactive = false,
		transparent_mode = false,
	})
	-- Force apply highlights after colorscheme loads
	vim.schedule(function()
		for name, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, opts)
		end
	end)
end

function M.setup_gruvbox_light()
	local highlights = require("GUI.highlights-gruvbox-light")
	vim.o.background = "light"
	require("gruvbox").setup({
		terminal_colors = false,
		undercurl = false,
		underline = true,
		bold = true,
		italic = {
			comments = true,
		},
		strikethrough = true,
		invert_selection = false,
		invert_signs = false,
		invert_tabline = false,
		invert_intend_guides = false,
		inverse = false,
		contrast = "", -- `hard`, `soft` or empty string
		palette_overrides = {},
		overrides = highlights,
		dim_inactive = false,
		transparent_mode = false,
	})
	-- Force apply highlights after colorscheme loads
	vim.schedule(function()
		for name, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, opts)
		end
	end)
end

function M.setup_vscode_dark()
	local highlights = require("GUI.highlights-vscode-dark")
	require("vscode").setup({
		style = "dark",
		transparent = false,
		italic_comments = true,
		underline_links = true,
		disable_nvimtree_bg = false,
		terminal_colors = false,
		color_overrides = {},
		group_overrides = highlights,
	})
	-- Force apply highlights after colorscheme loads
	vim.schedule(function()
		for name, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, opts)
		end
	end)
end

function M.setup_vscode_light()
	local highlights = require("GUI.highlights-vscode-light")
	require("vscode").setup({
		style = "light",
		transparent = false,
		italic_comments = true,
		underline_links = true,
		disable_nvimtree_bg = false,
		terminal_colors = false,
		color_overrides = {},
		group_overrides = highlights,
	})
	-- Force apply highlights after colorscheme loads
	vim.schedule(function()
		for name, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, opts)
		end
	end)
end

function M.setup_github_dark_default()
	local highlights = require("GUI.highlights-github-dark-default")
	require("github-theme").setup({
		options = {
			-- Compiled file's destination location
			compile_path = vim.fn.stdpath("cache") .. "/github-theme",
			compile_file_suffix = "_compiled", -- Compiled file suffix
			hide_end_of_buffer = true, -- Hide the '~' character at the end of the buffer for a cleaner look
			hide_nc_statusline = true, -- Override the underline style for non-active statuslines
			transparent = false, -- Disable setting bg (make neovim's background transparent)
			terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
			dim_inactive = false, -- Non focused panes set to alternative background
			module_default = true, -- Default enable value for modules
			styles = { -- Style to be applied to different syntax groups
				comments = "italic", -- Value is any valid attr-list value `:help attr-list`
				functions = "NONE",
				keywords = "NONE",
				variables = "NONE",
				conditionals = "NONE",
				constants = "NONE",
				numbers = "NONE",
				operators = "NONE",
				strings = "NONE",
				types = "NONE",
			},
			darken = { -- Change the default background of these groups
				floats = true,
				sidebars = {
					enable = true,
					list = { "qf", "vista_kind", "terminal", "spectre_panel", "NeogitStatus", "toggleterm" },
				},
			},
		},
		palettes = {},
		specs = {},
		groups = {
			all = highlights,
		},
	})
	-- Force apply highlights after colorscheme loads
	vim.schedule(function()
		for name, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, opts)
		end
	end)
end

function M.setup_github_light()
	local highlights = require("GUI.highlights-github-light")
	require("github-theme").setup({
		options = {
			-- Compiled file's destination location
			compile_path = vim.fn.stdpath("cache") .. "/github-theme",
			compile_file_suffix = "_compiled", -- Compiled file suffix
			hide_end_of_buffer = true, -- Hide the '~' character at the end of the buffer for a cleaner look
			hide_nc_statusline = true, -- Override the underline style for non-active statuslines
			transparent = false, -- Disable setting bg (make neovim's background transparent)
			terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
			dim_inactive = false, -- Non focused panes set to alternative background
			module_default = true, -- Default enable value for modules
			styles = { -- Style to be applied to different syntax groups
				comments = "italic", -- Value is any valid attr-list value `:help attr-list`
				functions = "NONE",
				keywords = "NONE",
				variables = "NONE",
				conditionals = "NONE",
				constants = "NONE",
				numbers = "NONE",
				operators = "NONE",
				strings = "NONE",
				types = "NONE",
			},
			darken = { -- Change the default background of these groups
				floats = true,
				sidebars = {
					enable = true,
					list = { "qf", "vista_kind", "terminal", "spectre_panel", "NeogitStatus", "toggleterm" },
				},
			},
		},
		palettes = {},
		specs = {},
		groups = {
			all = highlights,
		},
	})
	-- Force apply highlights after colorscheme loads
	vim.schedule(function()
		for name, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, name, opts)
		end
	end)
end

return M
