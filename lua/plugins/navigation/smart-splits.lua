return {
	"mrjones2014/smart-splits.nvim",
	-- Load lazily when using navigation keys
	keys = {
		{ "<C-h>", desc = " Move to left window (smart)" },
		{ "<C-j>", desc = " Move to below window (smart)" },
		{ "<C-k>", desc = " Move to above window (smart)" },
		{ "<C-l>", desc = " Move to right window (smart)" },
		{ "<A-h>", desc = "󰩨 Resize window left" },
		{ "<A-j>", desc = "󰩨 Resize window down" },
		{ "<A-k>", desc = "󰩨 Resize window up" },
		{ "<A-l>", desc = "󰩨 Resize window right" },
		{ "<C-Left>", desc = "󰩨 Resize window left" },
		{ "<C-Down>", desc = "󰩨 Resize window down" },
		{ "<C-Up>", desc = "󰩨 Resize window up" },
		{ "<C-Right>", desc = "󰩨 Resize window right" },
		{ "<leader>Wh", desc = "󰓡 Swap window left" },
		{ "<leader>Wj", desc = "󰓢 Swap window down" },
		{ "<leader>Wk", desc = "󰓢 Swap window up" },
		{ "<leader>Wl", desc = "󰓡 Swap window right" },
	},
	config = function()
		local smart_splits = require("smart-splits")

		smart_splits.setup({
			-- Ignored buffer types (won't resize/move)
			ignored_buftypes = {
				"nofile",
				"quickfix",
				"prompt",
			},
			-- Ignored filetypes (won't resize/move)
			ignored_filetypes = {
				"NvimTree",
				"neo-tree",
				"sagaoutline",
				"aerial",
				"toggleterm",
				"TelescopePrompt",
				"spectre_panel",
			},
			-- Default amount for window resizing
			default_amount = 3,
			-- whether to wrap movement at edges of screen
			at_edge = "wrap",
			-- when moving cursor to edge of screen, should we move to the next window?
			move_cursor_same_row = false,
			-- cursor follows focus when changing windows
			cursor_follows_swapped_bufs = false,
			-- resize mode settings
			resize_mode = {
				-- when entering resize mode, should we enter normal mode?
				quit_key = "<ESC>",
				-- when in resize mode, resize by this amount
				resize_keys = { "h", "j", "k", "l" },
				-- when in resize mode, should we silently ignore attempts to resize windows that can't be resized?
				silent = false,
				-- hooks for resize mode
				hooks = {
					on_enter = function()
						vim.notify("Entering resize mode... (ESC to exit)", vim.log.levels.INFO)
					end,
					on_leave = function()
						vim.notify("Exiting resize mode", vim.log.levels.INFO)
					end,
				},
			},
			-- ignore these autocmd events (i.e. 'WinLeave') while processing function
			ignored_events = {
				"BufEnter",
				"WinEnter",
			},
			-- enable or disable a multiplexer integration;
			multiplexer_integration = "tmux",
			-- disable multiplexer navigation if current multiplexer pane is zoomed
			disable_multiplexer_nav_when_zoomed = true,
		})

		-- Enhanced window navigation (replaces your existing Ctrl+hjkl)
		vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = " Move to left window (smart)" })
		vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = " Move to below window (smart)" })
		vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = " Move to above window (smart)" })
		vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = " Move to right window (smart)" })

		-- Window resizing with Alt+arrow keys (more intuitive)
		vim.keymap.set("n", "<A-h>", smart_splits.resize_left, { desc = "󰩨 Resize window left" })
		vim.keymap.set("n", "<A-j>", smart_splits.resize_down, { desc = "󰩨 Resize window down" })
		vim.keymap.set("n", "<A-k>", smart_splits.resize_up, { desc = "󰩨 Resize window up" })
		vim.keymap.set("n", "<A-l>", smart_splits.resize_right, { desc = "󰩨 Resize window right" })

		-- Alternative resize mappings with Ctrl+Arrow for ergonomics
		vim.keymap.set("n", "<C-Left>", smart_splits.resize_left, { desc = "󰩨 Resize window left" })
		vim.keymap.set("n", "<C-Down>", smart_splits.resize_down, { desc = "󰩨 Resize window down" })
		vim.keymap.set("n", "<C-Up>", smart_splits.resize_up, { desc = "󰩨 Resize window up" })
		vim.keymap.set("n", "<C-Right>", smart_splits.resize_right, { desc = "󰩨 Resize window right" })

		-- Window swapping (moving windows around) - using uppercase W to avoid LSP conflicts
		vim.keymap.set("n", "<leader>Wh", smart_splits.swap_buf_left, { desc = "󰓡 Swap window left" })
		vim.keymap.set("n", "<leader>Wj", smart_splits.swap_buf_down, { desc = "󰓢 Swap window down" })
		vim.keymap.set("n", "<leader>Wk", smart_splits.swap_buf_up, { desc = "󰓢 Swap window up" })
		vim.keymap.set("n", "<leader>Wl", smart_splits.swap_buf_right, { desc = "󰓡 Swap window right" })

		-- Note: Manual resize mode available via default smart-splits resize functions above
	end,
}
