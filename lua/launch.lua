-- 🔧 Cross-platform home directory detection
local home = vim.fn.expand("~")
local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
local path_separator = is_windows and ";" or ":"

-- Add LuaRocks bin to PATH
vim.env.PATH = vim.env.PATH .. path_separator .. home .. "/.luarocks/bin"
require("opts")

require("lazynvim.lazy")
require("GUI.theme")
require("keymaps")

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
		diagnostics = { merge_sources = false },
	},
})
