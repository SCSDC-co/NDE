return {
	"goolord/alpha-nvim",
	lazy = false,
	priority = 100,
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
			dashboard.button("p", "🔧  Plugins", ":Lazy<CR>"),
			dashboard.button("l", "🔨  LSP Manager", ":Mason<CR>"),
			dashboard.button("q", "🚪  Quit", ":qa<CR>"),
		}

		dashboard.section.header.opts.hl = "DashboardHeader"
		dashboard.section.buttons.opts.hl = "DashboardButtons"

		require("alpha").setup(dashboard.config)

		if vim.fn.argc() == 0 then
			require("alpha").start()
		end
	end,
}
