return {
	'akinsho/bufferline.nvim',
	lazy = true, -- ⚡ PERFORMANCE: Load after startup
	event = 'VeryLazy', -- ⚡ PERFORMANCE: Load after startup
	version = '*',
	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		require('bufferline').setup({
			options = {
				mode = 'buffers',
				diagnostics = 'nvim_lsp',
				show_buffer_close_icons = true,
				show_close_icon = false,
				separator_style = 'thin',
				always_show_bufferline = true,
				offsets = {
					{
						filetype = 'neo-tree',
						text = '',
						text_align = 'left',
						separator = true,
						highlight = 'BufferLineOffset',
						separator_highlight = 'BufferLineOffsetSeparator',
					},
				},
			},
		})

		vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next tab' })
		vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Prev tab' })
	end,
}
