-- 🚀 NDE 3.0.0 Renaissance Update: edgy.nvim for powerful layout management
return {
	"folke/edgy.nvim",
	event = "BufReadPost",
	keys = {
		{
			"<leader>n",
			function()
				-- Toggle edgy layout
				require("edgy").toggle()

				-- Sequential window opening with proper timing
				local function open_layout_sequence()
					-- Check git and open flog
					vim.defer_fn(function()
						local buf_name = vim.api.nvim_buf_get_name(0)
						local file_dir = vim.fn.fnamemodify(buf_name, ":h")

						-- If file_dir is empty or problematic, use current working directory
						if file_dir == "" or file_dir == "." or file_dir == vim.fn.expand("~") then
							file_dir = vim.fn.getcwd()
						end

						local git_cmd = "cd " .. file_dir .. " && git rev-parse --is-inside-work-tree 2>/dev/null"

						local handle = io.popen(git_cmd)
						local result = handle and handle:read("*a") or ""
						if handle then
							handle:close()
						end

						if result:match("true") then
							-- Change directory temporarily
							local old_cwd = vim.fn.getcwd()
							vim.cmd("lcd " .. file_dir)

							-- Load fugitive and open Flog
							vim.cmd("silent! Git status")

							vim.defer_fn(function()
								-- Use explicit graph options for better display
								local ok, err = pcall(vim.cmd, "Flogsplit -all")
								if not ok then
									pcall(vim.cmd, "Flog -all")
								end
								-- Restore directory
								vim.cmd("lcd " .. old_cwd)
							end, 200)
						end
					end, 50)

					-- Open neo-tree at system root directory
					vim.defer_fn(function()
						require("neo-tree.command").execute({
							source = "filesystem",
							dir = "/",
							position = "left",
						})
					end, 100)

					-- Open aerial
					vim.defer_fn(function()
						pcall(vim.cmd, "AerialToggle")
					end, 150)

					-- Open undotree
					vim.defer_fn(function()
						pcall(vim.cmd, "UndotreeToggle")
					end, 200)

					-- Focus back to editor window
					vim.defer_fn(function()
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							local buf = vim.api.nvim_win_get_buf(win)
							local ft = vim.bo[buf].filetype
							local bt = vim.bo[buf].buftype

							-- Focus on normal text editor buffers
							if
								(
									ft == ""
									or (
										ft ~= "neo-tree"
										and ft ~= "aerial"
										and ft ~= "floggraph"
										and ft ~= "flog"
										and ft ~= "undotree"
									)
								) and bt == ""
							then
								vim.api.nvim_set_current_win(win)
								return
							end
						end
					end, 250)
				end

				-- Execute the sequence
				open_layout_sequence()
			end,
			desc = "Toggle Layout",
		},
	},
	opts = {
		left = {
			{
				title = "Neo-Tree",
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == "filesystem"
				end,
				size = { height = 0.6 },
			},
			{
				title = "Git Log",
				ft = "floggraph",
				size = { height = 0.4 },
			},
		},
		right = {
			{
				title = "Outline",
				ft = "aerial",
				size = { height = 0.4 },
			},
			{
				title = "Undo Tree",
				ft = "undotree",
				size = { height = 0.6 },
			},
		},
		options = {
			left = { size = 40 },
			right = { size = 40 },
		},
		animate = {
			enabled = false,
		},
	},
}
