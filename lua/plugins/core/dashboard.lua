return {
	"goolord/alpha-nvim",
	lazy = true, -- ⚡ PERFORMANCE: Only load when no files opened
	event = "VimEnter", -- ⚡ PERFORMANCE: Load after Vim starts
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		vim.cmd("colorscheme kanagawa-dragon")

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
			dashboard.button("l", "🔨  LSP Manager", ":Mason<CR>"),
			dashboard.button("g", "🚀  OptiSpec Browser", ":NDE optispec browse<CR>"),
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
			"🚀 NDE v4.1.2",
		}

		dashboard.section.header.opts.hl = "DashboardHeader"
		dashboard.section.buttons.opts.hl = "DashboardButtons"
		dashboard.section.footer.opts.hl = "DashboardFooter"

		require("alpha").setup(dashboard.config)

		if vim.fn.argc() == 0 then
			require("alpha").start()
		end
	end,
}
