return {
	"zaldih/themery.nvim",
	lazy = false,
	priority = 1000,
	keys = {
		-- Keybinding moved to which-key group <leader>G
	},
	config = function()
		require("themery").setup({
			themes = {
				-- ────── DARK THEMES ──────
				{
					name = "────── DARK THEMES ──────",
					colorscheme = "kanagawa-dragon",
					before = [[
                        -- This is just a separator, don't apply
                    ]],
				},
				{
					name = "Kanagawa Dragon",
					colorscheme = "kanagawa-dragon",
					before = [[
                        require("GUI.theme-init").setup_dragon()
                    ]],
				},
				{
					name = "Catppuccin Mocha",
					colorscheme = "catppuccin-mocha",
					before = [[
                        require("GUI.theme-init").setup_catppuccin_mocha()
                    ]],
				},
				{
					name = "TokyoNight Moon",
					colorscheme = "tokyonight-moon",
					before = [[
                        require("GUI.theme-init").setup_tokyonight_moon()
                    ]],
				},
				{
					name = "Gruvbox Dark",
					colorscheme = "gruvbox",
					before = [[
                        require("GUI.theme-init").setup_gruvbox_dark()
                    ]],
				},
				{
					name = "VSCode Dark",
					colorscheme = "vscode",
					before = [[
                        require("GUI.theme-init").setup_vscode_dark()
                    ]],
				},
				{
					name = "GitHub Dark Default",
					colorscheme = "github_dark_default",
					before = [[
                        require("GUI.theme-init").setup_github_dark_default()
                    ]],
				},
				{
					name = "Nord",
					colorscheme = "nord",
					before = [[
                        require("GUI.theme-init").setup_nord()
                    ]],
				},
				{
					name = "Terafox",
					colorscheme = "terafox",
					before = [[
                        require("GUI.theme-init").setup_terafox()
                    ]],
				},

				-- ────── LIGHT THEMES ─────
				{
					name = "────── LIGHT THEMES ─────",
					colorscheme = "kanagawa-lotus",
					before = [[
                        -- This is just a separator, don't apply
                    ]],
				},
				{
					name = "Kanagawa Lotus",
					colorscheme = "kanagawa-lotus",
					before = [[
                        require("GUI.theme-init").setup_lotus()
                    ]],
				},
				{
					name = "Catppuccin Latte",
					colorscheme = "catppuccin-latte",
					before = [[
                        require("GUI.theme-init").setup_catppuccin_latte()
                    ]],
				},
				{
					name = "TokyoNight Day",
					colorscheme = "tokyonight-day",
					before = [[
                        require("GUI.theme-init").setup_tokyonight_day()
                    ]],
				},
				{
					name = "VSCode Light",
					colorscheme = "vscode",
					before = [[
                        require("GUI.theme-init").setup_vscode_light()
                    ]],
				},
				{
					name = "GitHub Light",
					colorscheme = "github_light",
					before = [[
                        require("GUI.theme-init").setup_github_light()
                    ]],
				},
				{
					name = "Gruvbox Light",
					colorscheme = "gruvbox",
					before = [[
                        require("GUI.theme-init").setup_gruvbox_light()
                    ]],
				},
			},
			-- Live preview while navigating themes
			livePreview = true,
			-- Auto-save theme preference
			-- themeConfigFile = vim.fn.stdpath("config") .. "/lua/settings/theme.lua",
		})

		-- Initialize default theme on first load only
		if vim.g.colors_name == nil then
			require("GUI.theme-init").setup_dragon()
			vim.cmd("colorscheme kanagawa-dragon")
		end
	end,
}
