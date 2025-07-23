-- 🔧 Cross-platform home directory detection
local home = vim.fn.expand("~")
local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
local path_separator = is_windows and ";" or ":"

-- Add LuaRocks bin to PATH
vim.env.PATH = vim.env.PATH .. path_separator .. home .. "/.luarocks/bin"
require("opts")

-- Initialize NDE Plugin Manager
require("config.plugin-manager").setup()

require("lazynvim.lazy")
-- Theme is now handled by Themery plugin
require("keymaps")
require("autocommands")

-- 🎉 Initialize NDE beginner tips system
require("nde.tips").setup({
	enabled = true, -- Show tips by default
	interval = 45000, -- 45 seconds between tips
})

-- 🔧 Initialize OptiSpec language environment
require("optispec").setup({
	languages = {},

	prompt = {
		enabled = true,
		auto_install = false,
	},

	-- Tool integration
	tools = {
		mason = { auto_update = true },
		lsp = { auto_attach = true },
		diagnostics = { merge_sources = false }, -- Disabled to improve scrolling performance
	},
})

-- 📸 Initialize SnapIcon screenshot tool
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		require("snapicon").setup({
			-- Custom configuration can be added here
			-- Uses sensible defaults if not specified
		})
	end,
	once = true, -- Only load once
})
