return {
	"akinsho/bufferline.nvim",
	lazy = true, -- ⚡ PERFORMANCE: Load after startup
	event = "VeryLazy", -- ⚡ PERFORMANCE: Load after startup
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		-- Create custom highlight group for close button
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				local linenr_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("LineNr")), "fg#")
				local gitsigns_delete_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("GitSignsDelete")), "fg#")
				vim.api.nvim_set_hl(0, "BufferLineCloseButtonCustom", {
					fg = gitsigns_delete_fg ~= "" and gitsigns_delete_fg,
					bg = linenr_fg ~= "" and linenr_fg,
				})
			end,
		})

		-- Set initial highlight
		local linenr_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("LineNr")), "fg#")
		local gitsigns_delete_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("GitSignsDelete")), "fg#")
		vim.api.nvim_set_hl(0, "BufferLineCloseButtonCustom", {
			fg = gitsigns_delete_fg ~= "" and gitsigns_delete_fg,
			bg = linenr_fg ~= "" and linenr_fg,
		})

		-- Function to close Neovim (make it globally accessible)
		_G.close_neovim_from_bufferline = function()
			vim.cmd("confirm qa")
		end

		require("bufferline").setup({
			options = {
				mode = "buffers",
				diagnostics = "nvim_lsp",
				show_buffer_close_icons = true,
				show_close_icon = false,
				separator_style = "thin",
				always_show_bufferline = false, -- Only show when 2+ buffers

				-- Custom areas
				custom_areas = {
					right = function()
						local result = {}

						-- Tabs display first (commented out - bufferline shows buffers, not tabs)
						-- local tabpages = vim.api.nvim_list_tabpages()
						-- local current_tab = vim.api.nvim_get_current_tabpage()

						-- if #tabpages > 1 then
						--	local tabs_text = ""
						--	for i, tabpage in ipairs(tabpages) do
						--		local is_current = tabpage == current_tab
						--		local tab_text = is_current and ("[" .. i .. "]") or (" " .. i .. " ")
						--		tabs_text = tabs_text .. tab_text
						--	end

						--	table.insert(result, {
						--		text = tabs_text .. " │ ",
						--		link = "BufferLineTab",
						--	})
						-- end

						-- Close button (X) at the far right
						table.insert(result, {
							text = "%@v:lua.close_neovim_from_bufferline@ ✕ %X",
							link = "BufferLineCloseButtonCustom",
						})

						return result
					end,
				},
				offsets = {
					{
						filetype = "neo-tree",
						text = "",
						text_align = "left",
						separator = true,
						highlight = "BufferLineOffset",
						separator_highlight = "BufferLineOffsetSeparator",
					},
				},
			},
		})

		-- Buffer navigation shortcuts
		vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
		vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
		vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
		vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })

		-- Tab navigation shortcuts
		vim.keymap.set("n", "<leader>h", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })
		vim.keymap.set("n", "<leader>l", "<Cmd>tabnext<CR>", { desc = "Next tab" })
	end,
}
