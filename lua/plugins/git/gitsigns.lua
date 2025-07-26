return {
	"lewis6991/gitsigns.nvim",
	lazy = true, -- ⚡ PERFORMANCE: Load when needed
	event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
	config = function()
		vim.o.termguicolors = true

		-- Function to get current sign style preference
		local function get_sign_style()
			local data_dir = vim.fn.stdpath("data") .. "/nde"
		    local settings_file = data_dir .. "/general_settings.json"
			
			local ok, result = pcall(function()
				if vim.fn.filereadable(settings_file) == 1 then
					local content = vim.fn.readfile(settings_file)
					if content and #content > 0 then
						local json_ok, json_data = pcall(vim.fn.json_decode, table.concat(content, ""))
						if json_ok and json_data and json_data.gitsigns_style then
							return json_data.gitsigns_style
						end
					end
				end
				return "default"
			end)
			
			return ok and result or "default"
		end

		-- Define sign styles
		local function get_signs(style)
			if style == "modern" then
				return {
					add = { hl = "GitSignsAdd", text = "", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
					change = { hl = "GitSignsChange", text = "󰜥", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
					delete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
					topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
					changedelete = { hl = "GitSignsChange", text = "󰜥", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
					untracked = { hl = "GitSignsAdd", text = "┆", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
				}
			else -- default style
				return {
					add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
					change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
					delete = { hl = "GitSignsDelete", text = "│", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
					topdelete = { hl = "GitSignsDelete", text = "│", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
					changedelete = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
					untracked = { hl = "GitSignsAdd", text = "┆", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
				}
			end
		end

		-- Get current style and signs
		local current_style = get_sign_style()
		local signs = get_signs(current_style)

		-- Global function to toggle gitsigns style
		_G.toggle_gitsigns_style = function()
			local data_dir = vim.fn.stdpath("data") .. "/nde"
			local settings_file = data_dir .. "/general_settings.json"
			
			-- Ensure directory exists
			vim.fn.mkdir(data_dir, "p")
			
			-- Read current settings from JSON file
			local settings = { welcome_enabled = false, hardtime = false, tips_enabled = false }
			local current_style = "default"
			
			if vim.fn.filereadable(settings_file) == 1 then
				local content = vim.fn.readfile(settings_file)
				if content and #content > 0 then
					local ok, json_data = pcall(vim.fn.json_decode, table.concat(content, ""))
					if ok and json_data then
						settings = json_data
						if settings.gitsigns_style then
							current_style = settings.gitsigns_style
						end
					end
				end
			end
			
			-- Toggle to opposite style
			local new_style = current_style == "default" and "modern" or "default"
			
			-- Update settings and write back to JSON file
			settings.gitsigns_style = new_style
			local json_string = vim.fn.json_encode(settings)
			vim.fn.writefile({ json_string }, settings_file)
			
			-- Update gitsigns with new style
			local new_signs = get_signs(new_style)
			require('gitsigns').setup({
				signs = new_signs,
				signs_staged = new_signs,
				numhl = false,
				linehl = false,
				watch_gitdir = { interval = 1000 },
				sign_priority = 6,
				update_debounce = 200,
				status_formatter = nil,
				current_line_blame = true,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "right_align",
					delay = 100,
					ignore_whitespace = true,
					virt_text_priority = 100,
				},
			})
			
			-- Show notification
			local style_names = {
				default = "Default (Clean lines)",
				modern = "Modern (Icons)",
			}
			
			vim.notify(
				"Git Signs Style Changed!\n\n"
					.. "Previous: " .. style_names[current_style] .. "\n"
					.. "Current: " .. style_names[new_style] .. "\n\n"
					.. "Refresh buffers to see changes!",
				vim.log.levels.INFO,
				{ title = "GitSigns Style Toggle" }
			)
			
			-- Refresh current buffer
			vim.cmd("edit")
		end

		require("gitsigns").setup({
			signs = signs,
			signs_staged = signs,
			numhl = false,
			linehl = false,
			watch_gitdir = { interval = 1000 },
			sign_priority = 6,
			update_debounce = 200,
			status_formatter = nil,
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "right_align",
				delay = 100,
				ignore_whitespace = true,
				virt_text_priority = 100,
			},
		})
	end,
}
