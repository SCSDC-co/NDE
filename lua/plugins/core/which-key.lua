return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		delay = 200, -- Increased delay to avoid interfering with Codeium
		expand = 1,
		notify = true,

		-- Plugins
		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			presets = {
				operators = true, -- Re-enable operators to fix Codeium interference
				motions = true,
				text_objects = true,
				windows = true,
				nav = true,
				z = true,
				g = true,
			},
		},

		-- Window settings
		win = {
			border = "rounded",
			padding = { 1, 2 },
			wo = {
				winblend = 0,
			},
		},

		-- Layout settings
		layout = {
			height = { min = 4, max = 25 },
			width = { min = 20, max = 50 },
			spacing = 3,
			align = "left",
		},

		-- Key mappings
		keys = {
			scroll_down = "<c-d>",
			scroll_up = "<c-u>",
		},

		-- Sorting and filtering
		sort = { "local", "order", "group", "alphanum", "mod" },
		expand = 0,

		-- Icons
		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
			ellipsis = "…",
			mappings = true,
			rules = {},
			colors = true,
			keys = {
				Up = " ",
				Down = " ",
				Left = " ",
				Right = " ",
				C = "󰘴",
				M = "󰘵",
				D = "󰘳",
				S = "󰘴",
				CR = "󰌑",
				Esc = "󱊷",
				ScrollWheelDown = "󰍽",
				ScrollWheelUp = "󰍾",
				NL = "󰌑",
				BS = "󰁮",
				Space = "󱁐",
				Tab = "󰌒",
				F1 = "󱊫",
				F2 = "󱊬",
				F3 = "󱊭",
				F4 = "󱊮",
				F5 = "󱊯",
				F6 = "󱊰",
				F7 = "󱊱",
				F8 = "󱊲",
				F9 = "󱊳",
				F10 = "󱊴",
				F11 = "󱊵",
				F12 = "󱊶",
			},
		},

		show_help = true,
		show_keys = true,
		disable = {
			buftypes = {},
			filetypes = { "TelescopePrompt", "alpha" },
		},

		-- Key mappings definitions
		spec = {
			-- Leader mappings
			{ "<leader>f", group = "🔍 Find" },
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
			{ "<leader>fp", "<cmd>Telescope yank_history<cr>", desc = "📋 Clipboard History" },

			{
				"<leader>e",
				function()
					local neotree_win = nil
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
						if bufname:match("neo%-tree filesystem") then
							neotree_win = win
							break
						end
					end
					if neotree_win then
						vim.cmd("Neotree close")
					else
						require("neo-tree.command").execute({ source = "filesystem", dir = "/" })
					end
				end,
				desc = "🌲 File Explorer (Root)",
			},

			{ "<leader>b", group = "📋 Buffer" },
			{ "<leader>bc", "<cmd>bdelete<cr>", desc = "Close Buffer" },
			{ "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close Others" },

			{ "<leader>g", group = "🌲 Git" },
			{ "<leader>s", group = "💾 Sessions" },
			{ "<leader>m", group = "🎣 Harpoon" },
			{ "<leader>L", group = "🏆 Legendary" },

			{ "<leader>d", group = "🐛 Debug" },
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle DAP UI",
			},

			{ "<leader>S", group = "🔄 Surround" },
			{ "<leader>Sa", "ys", desc = "Add Surround", remap = true },
			{ "<leader>Sc", "cs", desc = "Change Surround", remap = true },
			{ "<leader>Sd", "ds", desc = "Delete Surround", remap = true },

			{ "<leader>j", "<cmd>call append(line('.'), '')<cr>", desc = "➕ Insert Line Below" },
			{ "<leader>k", "<cmd>call append(line('.') - 1, '')<cr>", desc = "➕ Insert Line Above" },

			-- Vim Training (vim-be-good)
			{ "<leader>v", group = "🎮 Training" },
			{ "<leader>vt", "<cmd>VimBeGood<cr>", desc = "Training Mode" },

			-- Function keys
			{ "<F1>", desc = "🔴 Toggle Breakpoint" },
			{ "<F2>", desc = "▶️ Debug Continue" },
			{ "<F3>", desc = "⬇️ Debug Step Into" },
			{ "<F4>", desc = "➡️ Debug Step Over" },
			{ "<F7>", desc = "🔧 VSCode-style Terminal" },
			{ "<F8>", desc = "🚀 Universal Code Runner" },
			{ "<F9>", desc = "🔗 Add Parentheses (ysiw()" },
			{ "<F10>", desc = '💬 Add Quotes (ysiw")' },
			{ "<F11>", desc = "🔥 Toggle LazyGit Terminal" },
			{ "<F12>", desc = "💻 Toggle Terminal" },

			-- Yanky clipboard cycling (after paste)
			{ "p", desc = "📋 Yanky Put After" },
			{ "P", desc = "📋 Yanky Put Before" },
			{ "gp", desc = "📋 Yanky G-Put After" },
			{ "gP", desc = "📋 Yanky G-Put Before" },
			{ "<c-p>", desc = "📋 Yanky Previous Entry" },
			{ "<c-n>", desc = "📋 Yanky Next Entry" },

			{ "<leader>J", group = "☕ Java", buffer = bufnr },
			{ "<leader>Jo", desc = "📦 Organize Imports", buffer = bufnr },
			{ "<leader>Jv", desc = "🔧 Extract Variable", buffer = bufnr },
			{ "<leader>Jc", desc = "📌 Extract Constant", buffer = bufnr },
			{ "<leader>Jm", desc = "🔨 Extract Method", buffer = bufnr, mode = "v" },
			{ "<leader>Jt", desc = "🧪 Test Nearest Method", buffer = bufnr },
			{ "<leader>JT", desc = "🧪 Test Class", buffer = bufnr },
			{ "<leader>Ju", desc = "🔄 Update Config", buffer = bufnr },

			-- Blink
			{ "<leader>B", group = "👀 Blink" },
			{ "<leader>B;", "<cmd>lua require('blink.chartoggle').toggle_char_eol(';')<cr>", desc = "Toggle ; at eol" },
			{ "<leader>B,", "<cmd>lua require('blink.chartoggle').toggle_char_eol(',')<cr>", desc = "Toggle , at eol" },

			-- Colorpicker
			{ "<leader>c", group = "🎨 Colorpicker" },
			{ "<leader>cs", "<cmd>Shades<cr>", desc = "󱓻 Shades Picker" },
			{ "<leader>ch", "<cmd>Huefy<cr>", desc = "🌈 Hue Picker" },
		},
	},

	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

	end,
}
