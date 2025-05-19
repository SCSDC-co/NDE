return {
  "goolord/alpha-nvim",
  lazy = false,
  priority = 100,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.cmd("colorscheme kanagawa-dragon")

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        vim.cmd("hi! DashboardHeader guifg=#008b2b guibg=NONE")
        vim.cmd("hi! DashboardButtons guifg=#FFFFFF guibg=NONE")
        vim.cmd("hi! DashboardShortcut guifg=#FFFFFF guibg=NONE")
      end,
    })

    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[      ___           ___                       ___     ]],
      [[     /\__\         /\__\          ___        /\__\    ]],
      [[    /::|  |       /:/  /         /\  \      /::|  |   ]],
      [[   /:|:|  |      /:/  /          \:\  \    /:|:|  |   ]],
      [[  /:/|:|  |__   /:/__/  ___      /::\__\  /:/|:|__|__ ]],
      [[ /:/ |:| /\__\  |:|  | /\__\  __/:/\/__/ /:/ |::::\__\]],
      [[ \/__|:|/:/  /  |:|  |/:/  / /\/:/  /    \/__/~~/:/  /]],
      [[     |:/:/  /   |:|__/:/  /  \::/__/           /:/  / ]],
      [[     |::/  /     \::::/__/    \:\__\          /:/  /  ]],
      [[     /:/  /       ~~~~         \/__/         /:/  /   ]],
      [[     \/__/                                   \/__/    ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button("f", "🔍  Find File", ":lua require('telescope.builtin').find_files({ hidden = true })<CR>"),
      dashboard.button("r", "🕘  Recent Files", ":Telescope oldfiles<CR>"),
      dashboard.button("n", "📄  New File", ":ene <BAR> startinsert <CR>"),
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
