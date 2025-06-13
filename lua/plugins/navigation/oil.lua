return {
	"stevearc/oil.nvim",
	lazy = true, -- ⚡ PERFORMANCE: Only load when needed
	keys = {
		{ "<leader>o", "<CMD>Oil<CR>", desc = "🛢️ Open Oil file manager" },
		{ "<leader>O", "<CMD>Oil --float<CR>", desc = "🛢️ Open Oil floating window" },
	},
	cmd = { "Oil" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
			default_file_explorer = false, -- Keep Neo-tree as default

			-- Id is automatically added at the beginning, and name at the end
			columns = {
				"icon",
				"permissions",
				"size",
				"mtime",
			},

			-- Buffer-local options to use for oil buffers
			buf_options = {
				buflisted = false,
				bufhidden = "hide",
			},

			-- Window-local options to use for oil buffers
			win_options = {
				wrap = false,
				signcolumn = "no",
				cursorcolumn = false,
				foldcolumn = "0",
				spell = false,
				list = false,
				conceallevel = 3,
				concealcursor = "nvic",
			},

			-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
			delete_to_trash = true,

			-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
			skip_confirm_for_simple_edits = false,

			-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
			prompt_save_on_select_new_entry = true,

			-- Oil will automatically delete hidden buffers after this delay
			cleanup_delay_ms = 2000,
			lsp_file_methods = {
				-- Time to wait for LSP file operations to complete before skipping
				timeout_ms = 1000,
				-- Set to true to autosave buffers that are updated with LSP willRenameFiles
				autosave_changes = false,
			},

			-- Constrain the cursor to the editable parts of the oil buffer
			constrain_cursor = "editable",

			-- Set to true to watch the filesystem for changes and reload oil
			watch_for_changes = false,

			-- Keymaps in oil buffer
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-s>"] = "actions.select_vsplit",
				["<C-h>"] = "actions.select_split",
				["<C-t>"] = "actions.select_tab",
				["<C-p>"] = "actions.preview",
				["<C-c>"] = "actions.close",
				["<C-l>"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
			},

			-- Set to false to disable all of the above keymaps
			use_default_keymaps = true,

			view_options = {
				-- Show files and directories that start with "."
				show_hidden = true,
				-- This function defines what is considered a "hidden" file
				is_hidden_file = function(name, bufnr)
					return vim.startswith(name, ".")
				end,
				-- This function defines what will never be shown, even when `show_hidden` is set
				is_always_hidden = function(name, bufnr)
					return false
				end,
				sort = {
					-- sort order can be "asc" or "desc"
					-- see :help oil-columns to see which columns are sortable
					{ "type", "asc" },
					{ "name", "asc" },
				},
			},

			-- Configuration for the floating window in oil.open_float
			float = {
				-- Padding around the floating window
				padding = 2,
				max_width = 0,
				max_height = 0,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
				-- This is the config that will be passed to nvim_open_win.
				override = function(conf)
					return conf
				end,
			},

			-- Configuration for the actions floating preview window
			preview = {
				-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				max_width = 0.9,
				-- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
				min_width = { 40, 0.4 },
				-- optionally define an integer/float for the exact width of the preview window
				width = nil,
				-- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				max_height = 0.9,
				min_height = { 5, 0.1 },
				-- optionally define an integer/float for the exact height of the preview window
				height = nil,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
			},

			-- Configuration for the floating progress window
			progress = {
				max_width = 0.9,
				min_width = { 40, 0.4 },
				width = nil,
				max_height = { 10, 0.9 },
				min_height = { 5, 0.1 },
				height = nil,
				border = "rounded",
				minimized_border = "none",
				win_options = {
					winblend = 0,
				},
			},

			-- Configuration for the floating SSH window
			ssh = {
				border = "rounded",
			},
		})

		-- Keymaps for oil
		vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>", { desc = "🛢️ Open Oil file manager" })
		vim.keymap.set("n", "<leader>O", "<CMD>Oil --float<CR>", { desc = "🛢️ Open Oil floating window" })
	end,
}
