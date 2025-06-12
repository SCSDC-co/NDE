return {
	"nvim-pack/nvim-spectre",
	cmd = { "Spectre" },
	keys = {
		{
			"<leader>fR",
			function()
				require("spectre").toggle()
			end,
			desc = "🔍 Replace (Spectre)",
		},
		{
			"<leader>fw",
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "🔍 Find & Replace Word",
		},
		{
			"<leader>fw",
			function()
				require("spectre").open_visual()
			end,
			mode = "v",
			desc = "🔍 Find & Replace Selection",
		},
		{
			"<leader>fc",
			function()
				require("spectre").open_file_search({ select_word = true })
			end,
			desc = "🔍 Find & Replace in Current File",
		},
	},
	config = function()
		require("spectre").setup({
			-- Color theme (matches your setup)
			color_devicons = true,
			highlight = {
				ui = "String",
				search = "DiffChange",
				replace = "DiffDelete",
			},
			
			-- Search engine configuration
			default = {
				find = {
					cmd = "rg",
					options = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
				},
				replace = {
					cmd = "sed",
				},
			},
			
			-- Alternative engines (fallbacks)
			replace_engine = {
				["sed"] = {
					cmd = "sed",
					args = {
						"-i",
						"",
						"-E",
						"-e",
					},
					options = {
						ignore_case = {
							value = "--ignore-case",
							icon = "[I]",
							desc = "ignore case",
						},
						ignore_hidden = {
							value = "--hidden",
							desc = "hidden file",
							icon = "[H]",
						},
					},
				},
			},
			
			find_engine = {
				["rg"] = {
					cmd = "rg",
					args = {
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
					},
					pattern = {
						value = "--type",
						options = {
							["gitignore"] = {
								value = "--smart-case",
								icon = "[S]",
								desc = "smart case",
							},
							["ignore"] = {
								value = "--ignore-case",
								icon = "[I]",
								desc = "ignore case",
							},
							["hidden"] = {
								value = "--hidden",
								desc = "hidden file",
								icon = "[H]",
							},
						},
					},
				},
			},
			
			-- Live update
			live_update = false, -- auto execute search again when you write to any file in Neovim
			
			-- Window configuration
			open_cmd = "vnew",
			is_open_target_win = true,
			is_insert_mode = false,
			
			-- Mapping configuration
			mapping = {
				["toggle_line"] = {
					map = "dd",
					cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
					desc = "toggle item",
				},
				["enter_file"] = {
					map = "<cr>",
					cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
					desc = "open file",
				},
				["send_to_qf"] = {
					map = "<leader>q",
					cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
					desc = "send all items to quickfix",
				},
				["replace_cmd"] = {
					map = "<leader>c",
					cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
					desc = "input replace command",
				},
				["show_option_menu"] = {
					map = "<leader>o",
					cmd = "<cmd>lua require('spectre').show_options()<CR>",
					desc = "show options",
				},
				["run_current_replace"] = {
					map = "<leader>rc",
					cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
					desc = "replace current line",
				},
				["run_replace"] = {
					map = "<leader>R",
					cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
					desc = "replace all",
				},
				["change_view_mode"] = {
					map = "<leader>v",
					cmd = "<cmd>lua require('spectre').change_view()<CR>",
					desc = "change result view mode",
				},
				["change_replace_sed"] = {
					map = "trs",
					cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
					desc = "use sed to replace",
				},
				["toggle_live_update"] = {
					map = "tu",
					cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
					desc = "update when vim writes to file",
				},
				["toggle_ignore_case"] = {
					map = "ti",
					cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
					desc = "toggle ignore case",
				},
				["toggle_ignore_hidden"] = {
					map = "th",
					cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
					desc = "toggle search hidden",
				},
				["resume_last_search"] = {
					map = "<leader>l",
					cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
					desc = "resume last search",
				},
			},
		})
		
		-- Custom highlight groups to match your theme
		vim.api.nvim_set_hl(0, "SpectreSearch", { link = "DiffChange" })
		vim.api.nvim_set_hl(0, "SpectreReplace", { link = "DiffDelete" })
		vim.api.nvim_set_hl(0, "SpectreFile", { link = "Keyword" })
		vim.api.nvim_set_hl(0, "SpectreDir", { link = "Comment" })
		vim.api.nvim_set_hl(0, "SpectreBody", { link = "String" })
	end,
}

