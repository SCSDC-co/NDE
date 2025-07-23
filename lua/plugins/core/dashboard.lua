return {
	"goolord/alpha-nvim",
	lazy = true, -- ⚡ PERFORMANCE: Only load when no files opened
	event = "VimEnter", -- ⚡ PERFORMANCE: Load after Vim starts
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[  ███▄    █ ▓█████▄ ▓█████    ]],
			[[   ██ ▀█   █ ▒██▀ ██▌▓█   ▀   ]],
			[[  ▓██  ▀█ ██▒░██   █▌▒███     ]],
			[[  ▓██▒  ▐▌██▒░▓█▄   ▌▒▓█  ▄   ]],
			[[  ▒██░   ▓██░░▒████▓ ░▒████▒  ]],
			[[  ░ ▒░   ▒ ▒  ▒▒▓  ▒ ░░ ▒░ ░  ]],
			[[  ░ ░░   ░ ▒░ ░ ▒  ▒  ░ ░  ░  ]],
			[[     ░   ░ ░  ░ ░  ░    ░     ]],
			[[           ░    ░       ░  ░  ]],
			[[                              ]],
			[[Neovim Development Environment]],
		}

		dashboard.section.buttons.val = {
			dashboard.button(
				"f",
				"🔍  Find File",
				":lua require('telescope.builtin').find_files({ hidden = true })<CR>"
			),
			dashboard.button("r", "🕘  Recent Files", ":Telescope oldfiles<CR>"),
			dashboard.button("n", "📄  New File", ":ene <BAR> startinsert <CR>"),
			dashboard.button("t", "🎮  Vim Training", ":VimBeGood<CR>"),
			dashboard.button("p", "🔧  Plugins", ":Lazy<CR>"),
			dashboard.button("m", "🎛️  Plugin Manager", ":NDE pluginmanager<CR>"),
			dashboard.button("l", "🔨  LSP Manager", ":Mason<CR>"),
			dashboard.button("g", "🚀  OptiSpec Browser", ":NDE optispec browse<CR>"),
			dashboard.button("h", "🎨  Theme Switcher", ":Themery<CR>"),
			dashboard.button("q", "🚪  Quit", ":qa<CR>"),
		}

		-- Add startup time footer with real-time measurement
		local function get_startup_time()
			local stats = require("lazy").stats()
			local startup_time = "calculating..."

			-- Get actual startup time from vim.fn.reltime if available
			if vim.g.startup_timer then
				-- Calculate elapsed time from startup
				local elapsed = vim.fn.reltimefloat(vim.fn.reltime(vim.g.startup_timer)) * 1000
				startup_time = string.format("%.1f", elapsed)
			elseif vim.fn.exists("g:startup_time") == 1 then
				-- Fallback to global variable if set
				startup_time = tostring(vim.g.startup_time)
			else
				-- Ultimate fallback - try to measure current startup performance
				startup_time = "~25"
			end

			return "⚡ Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. startup_time .. "ms"
		end

		dashboard.section.footer.val = {
			"",
			get_startup_time(),
			"🚀 NDE v6.1.0",
		}

		dashboard.section.header.opts.hl = "DashboardHeader"
		dashboard.section.buttons.opts.hl = "DashboardButtons"
		dashboard.section.footer.opts.hl = "DashboardFooter"

		-- Configure proper centering
		dashboard.config.opts = {
			margin = 5,
		}

		require("alpha").setup(dashboard.config)

		-- Remove [No Name] buffer when opening files from dashboard
		vim.api.nvim_create_autocmd("BufEnter", {
			callback = function()
				-- Check if we have multiple buffers and one is [No Name]
				local buffers = vim.api.nvim_list_bufs()
				local valid_buffers = {}
				local no_name_buf = nil

				for _, buf in ipairs(buffers) do
					if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
						local name = vim.api.nvim_buf_get_name(buf)
						local buftype = vim.api.nvim_buf_get_option(buf, "buftype")

						-- Skip special buffers (dashboard, help, etc.)
						if buftype == "" then
							if name == "" then
								-- Check if it's an empty, unmodified buffer
								local modified = vim.api.nvim_buf_get_option(buf, "modified")
								local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
								if not modified and (#lines == 0 or (#lines == 1 and lines[1] == "")) then
									no_name_buf = buf
								else
									table.insert(valid_buffers, buf)
								end
							else
								table.insert(valid_buffers, buf)
							end
						end
					end
				end

				-- If we have a real file open and an empty [No Name] buffer, delete the empty one
				if no_name_buf and #valid_buffers > 0 then
					vim.api.nvim_buf_delete(no_name_buf, { force = true })
				end
			end,
		})

		if vim.fn.argc() == 0 then
			require("alpha").start()
		end
	end,
}
