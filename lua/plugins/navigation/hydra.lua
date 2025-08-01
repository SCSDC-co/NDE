return {
	"nvimtools/hydra.nvim",
	cmd = "Hydra",
	keys = { "<leader>hw", "<leader>hb" },
	dependencies = { "folke/which-key.nvim" },
	config = function()
		local Hydra = require("hydra")

		-- Window Navigation Hydra
		local window_hydra = Hydra({
			name = "Window Navigation",
			mode = "n",
			body = "<leader>hw",
			heads = {
				-- Window Movement
				{ "h", "<C-w>h", { desc = "Move to left window" } },
				{ "j", "<C-w>j", { desc = "Move to bottom window" } },
				{ "k", "<C-w>k", { desc = "Move to top window" } },
				{ "l", "<C-w>l", { desc = "Move to right window" } },

				-- Window Resizing
				{ "H", "<C-w>5<", { desc = "Decrease width" } },
				{ "J", "<C-w>5-", { desc = "Decrease height" } },
				{ "K", "<C-w>5+", { desc = "Increase height" } },
				{ "L", "<C-w>5>", { desc = "Increase width" } },

				-- Window Operations
				{ "s", "<C-w>s", { desc = "Split horizontally", exit = true } },
				{ "v", "<C-w>v", { desc = "Split vertically", exit = true } },
				{ "c", "<C-w>c", { desc = "Close window", exit = true } },
				{ "o", "<C-w>o", { desc = "Close other windows", exit = true } },

				-- Window Swapping
				{ "x", "<C-w>x", { desc = "Swap with next" } },
				{ "r", "<C-w>r", { desc = "Rotate windows" } },

				-- Equal size
				{ "=", "<C-w>=", { desc = "Equal size" } },

				-- Exit
				{ "q", nil, { exit = true, desc = "Quit hydra" } },
				{ "<Esc>", nil, { exit = true, desc = "Quit hydra" } },
			},
			config = {
				color = "pink",
				invoke_on_body = true,
				hint = {
					position = "bottom",
					show_name = true,
					float_opts = {
						border = "rounded",
					},
				},
			},
		})

		-- Buffer Navigation Hydra
		local buffer_hydra = Hydra({
			name = "Buffer Navigation",
			mode = "n",
			body = "<leader>hb",
			heads = {
				-- Buffer Navigation
				{ "n", ":bnext<CR>", { desc = "Next buffer" } },
				{ "p", ":bprev<CR>", { desc = "Previous buffer" } },
				{ "f", ":bfirst<CR>", { desc = "First buffer" } },
				{ "l", ":blast<CR>", { desc = "Last buffer" } },

				-- Buffer Operations
				{ "d", ":bdelete<CR>", { desc = "Delete buffer", exit = true } },
				{ "D", ":bdelete!<CR>", { desc = "Force delete buffer", exit = true } },

				-- Exit
				{ "q", nil, { exit = true, desc = "Quit hydra" } },
				{ "<Esc>", nil, { exit = true, desc = "Quit hydra" } },
			},
			config = {
				color = "blue",
				invoke_on_body = true,
				hint = {
					position = "bottom",
					show_name = true,
					float_opts = {
						border = "rounded",
					},
				},
			},
		})

		-- Register which-key group
		local wk = require("which-key")
		wk.add({
			{ "<leader>h", group = "󰸼 Hydra Modes" },
			{ "<leader>hw", desc = "Window Navigation", mode = "n" },
			{ "<leader>hb", desc = "Buffer Navigation", mode = "n" },
		})
	end,
}
