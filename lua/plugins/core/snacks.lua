-- 🚀 NDE 3.0.0 Renaissance Update: Enhanced snacks.nvim
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	config = function(_, opts)
		-- Setup snacks normally
		local snacks = require("snacks")
		snacks.setup(opts)

		-- Add cursor positioning after snacks setup
		vim.api.nvim_create_autocmd({ "User" }, {
			pattern = "SnacksDashboardOpened",
			callback = function()
				vim.schedule(function()
					if vim.bo.filetype == "snacks_dashboard" then
						-- Find first button line
						local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
						for i, line in ipairs(lines) do
							-- Look for lines with the find file icon or text
							if line:match("󰱼") or line:match("Find File") or line:match("f.*Find") then
								vim.api.nvim_win_set_cursor(0, { i, 0 })
								break
							end
						end
					end
				end)
			end,
		})
	end,
	opts = {
		-- Smooth scrolling
		scroll = {
			enabled = true,
			animate = {
				duration = { step = 15, total = 250 },
				easing = "linear",
			},
			spamming = 10,
			filter = function(buf)
				return vim.bo[buf].filetype ~= "dashboard"
					and vim.bo[buf].filetype ~= "snacks_dashboard"
					and vim.bo[buf].filetype ~= "snacks_explorer"
					and vim.bo[buf].filetype ~= "toggleterm"
			end,
		},

		-- 🚀 NEW: Big file handling for performance
		bigfile = {
			enabled = true,
			size = 1.5 * 1024 * 1024, -- 1.5MB
			setup = function(ctx)
				vim.cmd("syntax clear")
				vim.opt_local.foldmethod = "manual"
				vim.opt_local.spell = false
				vim.opt_local.swapfile = false
				vim.opt_local.undofile = false
				vim.opt_local.wrap = false
				vim.opt_local.list = false
				-- Disable expensive plugins for big files
				vim.b.minipairs_disable = true
				vim.b.miniindentscope_disable = true
				Snacks.util.info(
					"Big file detected ("
						.. math.floor(ctx.size / 1024 / 1024 * 100) / 100
						.. "MB). Optimizing performance...",
					{ title = "Big File" }
				)
			end,
		},

		-- Indent guides configuration (replaces hlchunk)
		indent = {
			enabled = true,
			indent = {
				priority = 1,
				enabled = true,
				char = "│", -- Same char as hlchunk
				only_scope = false,
				only_current = false,
				hl = "HLIndent1", -- Use hlchunk indent highlight
			},
			-- Animation settings
			animate = {
				enabled = true,
				style = "out",
				easing = "linear",
				duration = {
					step = 20,
					total = 150,
				},
			},
			-- Scope highlighting (replaces hlchunk chunk)
			scope = {
				enabled = true,
				priority = 200,
				char = "│",
				underline = false,
				only_current = false,
				hl = "HLChunk1", -- Use hlchunk scope highlight
			},
			-- Chunk disabled (we use scope instead)
			chunk = {
				enabled = false,
			},
			-- Filter to exclude filetypes (same as hlchunk)
			filter = function(buf)
				local ft = vim.bo[buf].filetype
				return vim.g.snacks_indent ~= false
					and vim.b[buf].snacks_indent ~= false
					and vim.bo[buf].buftype == ""
					and not vim.tbl_contains({
						"dashboard",
						"snacks_dashboard",
						"help",
						"lspinfo",
						"packer",
						"checkhealth",
						"man",
						"mason",
						"neo-tree",
						"Trouble",
						"trouble",
						"lazy",
						"notify",
						"toggleterm",
						"lazyterm",
					}, ft)
			end,
		},

		-- Dashboard configuration
		dashboard = {
			enabled = true,
			width = 60,
			row = nil, -- center vertically
			col = nil, -- center horizontally
			preset = {
				header = [[
  ███▄    █ ▓█████▄ ▓█████    
   ██ ▀█   █ ▒██▀ ██▌▓█   ▀   
  ▓██  ▀█ ██▒░██   █▌▒███     
  ▓██▒  ▐▌██▒░▓█▄   ▌▒▓█  ▄   
  ▒██░   ▓██░░▒████▓ ░▒████▒  
  ░ ▒░   ▒ ▒  ▒▒▓  ▒ ░░ ▒░ ░  
  ░ ░░   ░ ▒░ ░ ▒  ▒  ░ ░  ░  
     ░   ░ ░  ░ ░  ░    ░     
           ░    ░       ░  ░  
                         ]],
				keys = {
					{
						icon = "󰱼",
						key = "f",
						desc = "Find File",
						action = ":lua require('telescope.builtin').find_files({ hidden = true })",
					},
					{ icon = "󱋡", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
					{ icon = "󰝒", key = "n", desc = "New File", action = ":ene | startinsert" },
					{ icon = "󰊴", key = "v", desc = "Vim Training", action = ":VimBeGood" },
					{ icon = "󰒲", key = "l", desc = "Lazy", action = ":Lazy" },
					{ icon = "", key = "p", desc = "Plugin Manager", action = ":NDE pluginmanager" },
					{ icon = "󱁤", key = "m", desc = "Mason", action = ":Mason" },
					{ icon = "", key = "o", desc = "OptiSpec Browser", action = ":NDE optispec browse" },
					{ icon = "󰏘", key = "t", desc = "Theme Switcher", action = ":Themery" },
					{ icon = "", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ section = "startup" },
			},
		},

		-- Disable modules we don't use
		input = { enabled = false },
		notifier = { enabled = false },
		quickfile = { enabled = false },
		words = { enabled = false },
	},
}
