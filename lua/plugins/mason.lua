return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",
					"rust_analyzer",
					"ts_ls",
					"html",
					"cssls",
					"gopls",
					"pyright",
					"lua_ls",
					"bashls",
					"jsonls",
					"yamlls",
					"marksman",
				},
				automatic_installation = true,
			})
		end,
	},
}
