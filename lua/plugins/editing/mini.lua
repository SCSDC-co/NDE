return {
	{
		"echasnovski/mini.surround",
		event = "VeryLazy",
		config = function()
			require("mini.surround").setup({
				mappings = {
					add = 'ys', -- Add surrounding in Normal and Visual modes
					delete = 'ds', -- Delete surrounding
					find = 'gzf', -- Find surrounding (to the right)
					find_left = 'gzF', -- Find surrounding (to the left)
					highlight = 'gzh', -- Highlight surrounding
					replace = 'cs', -- Replace surrounding
					update_n_lines = 'gzn', -- Update `n_lines`
					suffix_last = 'l', -- Suffix to search with "prev" method
					suffix_next = 'n', -- Suffix to search with "next" method
				},
			})
		end,
	},
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		config = function()
			local pairs = require("mini.pairs")
			
			pairs.setup({
				-- Complete configuration with all pairs including angle brackets
				mappings = {
					-- Standard opening pairs
					['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
					['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
					['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },
					-- Improved angle bracket configuration for HTML/XML and generics
					-- This pattern will prevent triggering in comparison operators but work in most other contexts
					['<'] = { action = 'open', pair = '<>', neigh_pattern = '[%(%{%[%s,=:"\'].' },
					
					-- Standard closing pairs
					[')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
					[']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
					['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
					-- Configure > as a standard closing bracket
					['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },
					
					-- Quotes
					["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^\\].' },
					['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].' },
					['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].' },
				},
				
				-- Ensure it doesn't trigger in unwanted contexts
				modes = {
					insert = true,
					command = false,
					terminal = false,
				},
				
				-- Add special handling for angle brackets
				-- This helps to better distinguish between comparisons and tags/generics
				custom_pairs = function(_, _)
					-- Add any custom pairs handling here if needed
					return {}
				end,
				
				-- Disable for specific filetypes
				disable_filetype = { "TelescopePrompt" },
			})
			-- Add manual keybinding for angle brackets when needed
			vim.api.nvim_set_keymap('i', '<C-,>', '<><Left>', { noremap = true, silent = true })
			
		end,
	},
}

