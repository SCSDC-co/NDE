return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = true, -- ⚡ PERFORMANCE: Only load when searching
		keys = {
			{ "<leader>ff", desc = "Telescope Find Files (All)" },
			{ "<leader>fg", desc = "Telescope Live Grep" },
			{ "<leader>fb", desc = "Telescope Buffers" },
			{ "<leader>fh", desc = "Telescope Help" },
		},
		cmd = { "Telescope" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					hidden = true,
					winblend = 0,
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					prompt_prefix = "🔎 ",
					selection_caret = " ",
					mappings = {
						i = {
							["<esc>"] = require("telescope.actions").close,
						},
					},
				},
			})

			-- Load yanky extension only if yanky plugin is available
			local has_yanky = pcall(require, "yanky")
			if has_yanky then
				telescope.load_extension("yank_history")
			end

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({ hidden = true })
			end, { desc = "Telescope Find Files (All)" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope Live Grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope Help" })
		end,
	},
}
