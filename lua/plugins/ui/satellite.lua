return {
	"lewis6991/satellite.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- Setup satellite with error handling
		local ok, satellite = pcall(require, "satellite")
		if not ok then
			return
		end

		-- Wrap satellite setup to catch any errors
		pcall(function()
			satellite.setup({
				current_only = true,
				winblend = 0,
				zindex = 40,
			    excluded_filetypes = { 
				   "neo-tree", 
				   "minty", 
				   "minty_shades", 
				   "minty_huefy",
				   "nofile",
				   "prompt",
				   "popup",
				   "scratch"
			    },
			    excluded_buftypes = {
				   "nofile",
				   "prompt",
				   "popup",
				   "terminal",
				   "scratch"
			    },
				width = 2,
				handlers = {
					cursor = { enabled = true },
					search = { enabled = true },
					diagnostic = { enabled = true },
					gitsigns = { enabled = true },
					marks = { enabled = true },
				},
			})
		end)

		-- Create an autocmd to suppress satellite error messages
		vim.api.nvim_create_autocmd("User", {
			pattern = "*",
			callback = function()
				-- Suppress satellite errors in the background
				local old_print = print
				print = function(msg)
					if type(msg) == "string" and msg:match("satellite%.nvim.*Invalid") then
						return
					end
					return old_print(msg)
				end
			end,
			once = true,
		})
	end,
}
