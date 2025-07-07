--[[
🤖 GOOGLE GEMINI SETUP GUIDE:

1. Get your Gemini API key:
   • Go to: https://aistudio.google.com/app/apikey
   • Sign in with Google account
   • Click "Create API Key"
   • Copy the generated key

2. Add to your shell profile (~/.zshrc or ~/.bashrc):
   export GEMINI_API_KEY="your_gemini_api_key_here"

3. IMPORTANT: Restart your terminal completely (not just source)
   This ensures Neovim inherits the environment variable

4. Launch Neovim from the same terminal and use <leader>aa!

💡 Gemini Flash has 1M token context window (HUGE!)
💡 Free tier: 15 requests/minute, 1500 requests/day
💡 Perfect for code explanations, debugging, and refactoring
💡 Chat-based interface - no inline suggestions clutter
--]]

return {
	"yetone/avante.nvim",
	event = { "BufReadPost", "BufNewFile" }, -- Load only when opening files
	lazy = true,
	version = false, -- set this if you want to always pull the latest change
	build = "make", -- Build the plugin
	opts = {
		-- add any opts here
	},
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"hrsh7th/nvim-cmp", -- for completions
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	config = function()
		-- Auto-load GEMINI_API_KEY from shell profile if not in environment
		if not os.getenv("GEMINI_API_KEY") then
			local zshrc = io.open(os.getenv("HOME") .. "/.zshrc", "r")
			if zshrc then
				local content = zshrc:read("*a")
				zshrc:close()
				local key = content:match("export GEMINI_API_KEY=([^\n]+)")
				if key then
					key = key:gsub('"', ""):gsub("'", "") -- Remove quotes
					vim.env.GEMINI_API_KEY = key
				end
			end
		end

		require("avante").setup({
			-- Configuration for Google Gemini provider
			provider = "gemini", -- Use Google Gemini provider
			behaviour = {
				auto_suggestions = false, -- Disable inline suggestions
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = false,
			},
			system_prompt = "You are Gemini, Google's AI assistant. Be helpful and accurate with coding tasks.", -- Gemini system prompt
			mappings = {
				--- @class AvanteConflictMappings
				diff = {
					ours = "co",
					theirs = "ct",
					all_theirs = "ca",
					both = "cb",
					cursor = "cc",
					next = "]x",
					prev = "[x",
				},
				suggestion = {
					accept = "<M-l>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
				jump = {
					next = "]]",
					prev = "[[",
				},
				submit = {
					normal = "<CR>",
					insert = "<C-s>",
				},
				sidebar = {
					apply_all = "A",
					apply_cursor = "a",
					switch_windows = "<Tab>",
					reverse_switch_windows = "<S-Tab>",
				},
			},
			hints = { enabled = true },
			windows = {
				position = "right", -- the position of the sidebar
				wrap = true, -- similar to vim.o.wrap
				width = 30, -- default % based on available width
				sidebar_header = {
					align = "center", -- left, center, right for title
					rounded = true,
				},
			},
			highlights = {
				--- @type AvanteConflictHighlights
				diff = {
					current = "DiffText",
					incoming = "DiffAdd",
				},
			},
			--- @class AvanteConflictUserConfig
			diff = {
				autojump = true,
				---@type string | fun(): any
				list_opener = "copen",
			},
			-- Use Google Gemini provider configuration
			providers = {
				gemini = {
					endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
					model = "gemini-1.5-flash-latest", -- Free tier model
					api_key_name = "GEMINI_API_KEY",
					extra_request_body = {
						temperature = 0.7,
						maxOutputTokens = 4096,
					},
				},
			},
		})

		-- 🎨 Kanagawa Dragon themed highlights for Avante with Gemini
		vim.api.nvim_set_hl(0, "AvanteTitle", { fg = "#E6C384", bold = true })
		vim.api.nvim_set_hl(0, "AvanteReversedTitle", { fg = "#181616", bg = "#E6C384" })
		vim.api.nvim_set_hl(0, "AvanteSubtitle", { fg = "#C8C093" })
		vim.api.nvim_set_hl(0, "AvanteReversedSubtitle", { fg = "#181616", bg = "#C8C093" })
		vim.api.nvim_set_hl(0, "AvanteThirdTitle", { fg = "#7AA89F" })
		vim.api.nvim_set_hl(0, "AvanteReversedThirdTitle", { fg = "#181616", bg = "#7AA89F" })

		-- 🖼️ Custom Avante sidebar border styling
		vim.api.nvim_set_hl(0, "AvanteSidebarWinSeparator", { fg = "#0D0C0C", bg = "#0D0C0C" })
		vim.api.nvim_set_hl(0, "AvanteSidebarWinHorizontalSeparator", { fg = "#181616", bg = "#181616" })

		-- 🤖 Which-key group for Gemini AI commands
		local wk = require("which-key")
		wk.add({
			{ "<leader>a", group = "🤖 AI Assistant" },
		})
	end,
}
