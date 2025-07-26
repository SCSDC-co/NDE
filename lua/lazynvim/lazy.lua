local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Themes with high priority
	{ "rebelot/kanagawa.nvim", priority = 1000 },
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "folke/tokyonight.nvim", priority = 1000 },
	{ "ellisonleao/gruvbox.nvim", priority = 1000 },
	{ "Mofiqul/vscode.nvim", priority = 1000 },
	{ "projekt0n/github-nvim-theme", priority = 1000 },

	-- Import all organized plugins
	{ import = "plugins" },

	-- Additional dependencies
	{ "nvim-neotest/nvim-nio" },

	-- Lazy.nvim configuration
	checker = { enabled = true },
	change_detection = { notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				"matchparen",
			},
		},
	},
})
