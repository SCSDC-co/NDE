return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	config = function()
		-- Default configuration
		require("tiny-inline-diagnostic").setup({
			preset = "modern",

			transparent_bg = false,
			transparent_cursorline = false,

			hi = {
				error = "DiagnosticError",
				warn = "DiagnosticWarn",
				info = "DiagnosticInfo",
				hint = "DiagnosticHint",
				arrow = "NonText",

				background = "CursorLine",

				mixing_color = "None",
			},

			options = {
				show_source = {
					enabled = false,
					if_many = false,
				},

				use_icons_from_diagnostic = true,

				-- Set the arrow icon to the same color as the first diagnostic severity
				set_arrow_to_diag_color = false,

				-- Add messages to diagnostics when multiline diagnostics are enabled
				-- If set to false, only signs will be displayed
				add_messages = true,

				-- Time (in milliseconds) to throttle updates while moving the cursor
				-- Increase this value for better performance if your computer is slow
				-- or set to 0 for immediate updates and better visual
				throttle = 20,

				-- Minimum message length before wrapping to a new line
				softwrap = 30,

				multilines = {
					-- Enable multiline diagnostic messages
					enabled = true,

					-- Always show messages on all lines for multiline diagnostics
					always_show = false,

					-- Trim whitespaces from the start/end of each line
					trim_whitespaces = false,

					-- Replace tabs with spaces in multiline diagnostics
					tabstop = 4,
				},

				-- Display all diagnostic messages on the cursor line
				show_all_diags_on_cursorline = false,

				-- Enable diagnostics in Insert mode
				-- If enabled, it is better to set the `throttle` option to 0 to avoid visual artifacts
				enable_on_insert = true,

				-- Enable diagnostics in Select mode (e.g when auto inserting with Blink)
				enable_on_select = false,

				overflow = {
					-- Manage how diagnostic messages handle overflow
					-- Options:
					-- "wrap" - Split long messages into multiple lines
					-- "none" - Do not truncate messages
					-- "oneline" - Keep the message on a single line, even if it's long
					mode = "wrap",

					-- Trigger wrapping to occur this many characters earlier when mode == "wrap".
					-- Increase this value appropriately if you notice that the last few characters
					-- of wrapped diagnostics are sometimes obscured.
					padding = 0,
				},

				-- Configuration for breaking long messages into separate lines
				break_line = {
					-- Enable the feature to break messages after a specific length
					enabled = false,

					-- Number of characters after which to break the line
					after = 30,
				},

				-- Custom format function for diagnostic messages
				-- Example:
				-- format = function(diagnostic)
				--     return diagnostic.message .. " [" .. diagnostic.source .. "]"
				-- end
				format = nil,

			virt_texts = {
					-- Priority for virtual text display
					priority = 2048,
				},

				severity = {
					vim.diagnostic.severity.ERROR,
					vim.diagnostic.severity.WARN,
					vim.diagnostic.severity.INFO,
					vim.diagnostic.severity.HINT,
				},

				-- Events to attach diagnostics to buffers
				-- You should not change this unless the plugin does not work with your configuration
				overwrite_events = nil,

				signs = {
					left = "",
					right = "",
					diag = "●",
					arrow = "      ",
					up_arrow = "     ",
					vertical = " │",
					vertical_end = " └",
				},
			},
			disabled_ft = {}, -- List of filetypes to disable the plugin
		})
	end,
}
