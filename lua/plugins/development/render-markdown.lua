return {
	"MeanderingProgrammer/render-markdown.nvim",
	lazy = true, -- ⚡ PERFORMANCE: Only load for markdown files
	ft = "markdown", -- ⚡ PERFORMANCE: Only load for markdown
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {},
}
