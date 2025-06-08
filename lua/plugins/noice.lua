return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		require("noice").setup({
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
			},
			notify = {
				enabled = true,
				view = "notify",
			},
			messages = {
				enabled = true,
				view = "notify",
			},
			views = {
				cmdline_popup = {
					position = {
						row = 5,
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = "Normal:NoiceCmdlinePopup,FloatBorder:NoiceCmdlinePopupBorder",
					},
				},
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = false,
			},
		})

    -- Set custom highlights for all noice backgrounds
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "#181616", fg = "#dcd7ba" })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { bg = "#181616", fg = "#626978" })
    vim.api.nvim_set_hl(0, "NoiceCmdlineIconCmdline", { bg = "#181616", fg = "#626978" })
    vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { bg = "#181616", fg = "#626978" })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { bg = "#181616", fg = "#7e9cd8" })
    vim.api.nvim_set_hl(0, "NoicePopup", { bg = "#181616", fg = "#dcd7ba" })
    vim.api.nvim_set_hl(0, "NoicePopupBorder", { bg = "#181616", fg = "#626978" })
    vim.api.nvim_set_hl(0, "NoiceConfirm", { bg = "#181616", fg = "#dcd7ba" })
    vim.api.nvim_set_hl(0, "NoiceConfirmBorder", { bg = "#181616", fg = "#626978" })
    vim.api.nvim_set_hl(0, "NoiceMini", { bg = "#181616", fg = "#dcd7ba" })
    vim.api.nvim_set_hl(0, "NoiceFormatProgressDone", { bg = "#181616", fg = "#76946a" })
    vim.api.nvim_set_hl(0, "NoiceFormatProgressTodo", { bg = "#181616", fg = "#626978" })
    vim.api.nvim_set_hl(0, "NoiceFormatTitle", { bg = "#181616", fg = "#7e9cd8" })
    vim.api.nvim_set_hl(0, "NoiceFormatEvent", { bg = "#181616", fg = "#a3d4d5" })
    vim.api.nvim_set_hl(0, "NoiceFormatKind", { bg = "#181616", fg = "#e6c384" })
    vim.api.nvim_set_hl(0, "NoiceFormatDate", { bg = "#181616", fg = "#938aa9" })
    vim.api.nvim_set_hl(0, "NoiceLspProgressTitle", { bg = "#181616", fg = "#7e9cd8" })
    vim.api.nvim_set_hl(0, "NoiceLspProgressClient", { bg = "#181616", fg = "#a3d4d5" })
    vim.api.nvim_set_hl(0, "NoiceLspProgressSpinner", { bg = "#181616", fg = "#e6c384" })
    
    -- Fix command line prompt background specifically
    vim.api.nvim_set_hl(0, "NoiceCmdlinePrompt", { bg = "#181616", fg = "#7e9cd8" })
    vim.api.nvim_set_hl(0, "MsgArea", { bg = "#181616", fg = "#dcd7ba" })
    vim.api.nvim_set_hl(0, "MsgSeparator", { bg = "#181616", fg = "#626978" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#181616", fg = "#dcd7ba" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#181616", fg = "#626978" })
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "#181616", fg = "#dcd7ba" })
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2d2a2e", fg = "#dcd7ba" })
    vim.api.nvim_set_hl(0, "PmenuBorder", { bg = "#181616", fg = "#626978" })

		-- Configure nvim-notify
		require("notify").setup({
			background_colour = "#181616",
			fps = 30,
			icons = {
				DEBUG = "",
				ERROR = "",
				INFO = "",
				TRACE = "✎",
				WARN = "",
			},
			level = 2,
			minimum_width = 50,
			render = "default",
			stages = "fade_in_slide_out",
			timeout = 3000,
			top_down = true,
		})
	end,
}
