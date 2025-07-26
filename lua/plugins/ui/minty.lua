return {
	{ "nvzone/volt", lazy = true },
	{
		"nvzone/minty",
		event = "BufRead",
		config = function()
			require("minty").setup({
				huefy = {
					border = true, -- Enable border for better theme integration
					mappings = function(bufs)
						-- Add your mappings here ( buffer scoped )
					end,
					-- func must return { row, col }
					position = "cursor", -- cursor | center | func(w, h)
				},

				shades = {
					border = true, -- Enable border for consistent UI
					mappings = function(buf)
						-- Add your mappings here ( buffer scoped )
						-- local api = require("minty.shades.api")
						-- vim.keymap.set("n", "s", api.save_color, { buffer = buf })
					end,
					-- func must return { row, col }
					position = "cursor", -- cursor | center | func(w, h)
				},
			})

			-- Apply our local plugin override for custom borders and theming
			require("local_plugins.minty").setup()

			-- Register which-key group
			local wk = require("which-key")
			wk.add({
				{ "<leader>c", group = " Colorpicker" },
				{ "<leader>cs", "<cmd>Shades<cr>", desc = "󱓻 Shades Picker" },
				{ "<leader>ch", "<cmd>Huefy<cr>", desc = " Hue Picker" },
			})
		end,
	},
}
