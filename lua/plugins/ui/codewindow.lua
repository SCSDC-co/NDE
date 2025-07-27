return {
	"gorbit99/codewindow.nvim",
	event = { "BufRead", "BufNewFile" },
	config = function()
		local codewindow = require("codewindow")

		-- Get FloatBorder colors dynamically from current theme
		local function get_float_border_colors()
			local hl = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
			return {
				fg = hl.fg and ("#%06x"):format(hl.fg),
				bg = hl.bg and ("#%06x"):format(hl.bg) or nil,
			}
		end

		local border_colors = get_float_border_colors()

		-- Set up highlight group for codewindow border
		vim.api.nvim_set_hl(0, "CodewindowBorder", { fg = border_colors.fg, bg = border_colors.bg })

		codewindow.setup({
			-- Minimap window settings
			minimap_width = 20, -- Width of the minimap window
			width_multiplier = 1, -- How many characters one dot represents
			z_index = 1, -- Lower z-index to avoid conflicts
			use_lsp = true, -- Use LSP to show errors and warnings on the minimap
			use_treesitter = true, -- Use treesitter to show scope
			use_git = true, -- Show git additions/deletions

			-- Visual settings
			exclude_filetypes = {
				"neo-tree",
				"aerial",
				"snacks_dashboard",
				"lazy",
				"help",
				"qf",
				"dap-repl",
				"dapui_console",
				"dapui_watches",
				"dapui_stacks",
				"dapui_breakpoints",
				"dapui_scopes",
			},

			-- Auto-open/close settings
			auto_enable = false, -- Don't auto-enable for all buffers

			-- Colors (will adapt to theme)
			window_border = "rounded", -- Match NDE's rounded borders
		})

		-- Set up which-key mappings for minimap control
		local wk = require("which-key")
		wk.add({
			{ "<leader>m", group = "󰍉 Minimap" },
			{
				"<leader>mt",
				function()
					codewindow.toggle_minimap()
				end,
				desc = "Toggle Minimap",
			},
			{
				"<leader>mo",
				function()
					codewindow.open_minimap()
				end,
				desc = "Open Minimap",
			},
			{
				"<leader>mc",
				function()
					codewindow.close_minimap()
				end,
				desc = "Close Minimap",
			},
			{
				"<leader>mf",
				function()
					codewindow.toggle_focus()
				end,
				desc = "Focus Minimap",
			},
		})

		-- Update border colors when theme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				local new_border_colors = get_float_border_colors()
				vim.api.nvim_set_hl(0, "CodewindowBorder", { fg = new_border_colors.fg, bg = new_border_colors.bg })
			end,
		})
	end,
}
