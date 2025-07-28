local M = {}

-- Setup none-ls with linter support
function M.setup(config)
	-- Add Mason bin to PATH so none-ls can find tools automatically
	local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
	vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

	local null_ls = require("null-ls")

	-- Configure none-ls for linters only
	null_ls.setup({
		-- Start with empty sources (will be populated dynamically)
		sources = {},

		-- Diagnostics format compatible with tiny-inline-diagnostic
		diagnostics_format = "#{m} [#{c}]",

		-- Debounce for better performance
		debounce = 250,

		-- Update in insert mode for real-time feedback
		update_in_insert = true,

		-- Default on_attach function
		on_attach = function(client, bufnr)
			-- Call custom on_attach if provided
			if config and config.on_attach then
				config.on_attach(client, bufnr)
			end
		end,

		-- Use LSP capabilities if provided
		capabilities = config and config.capabilities or vim.lsp.protocol.make_client_capabilities(),

		-- Root directory detection
		root_dir = require("null-ls.utils").root_pattern(
			".null-ls-root",
			".neoconf.json",
			"Makefile",
			".git",
			"package.json",
			"Cargo.toml",
			"pyproject.toml",
			"setup.py",
			"requirements.txt",
			"go.mod",
			"composer.json"
		),
	})

	-- Store null-ls reference for dynamic source management
	M.null_ls = null_ls
end

-- Load linters for a language when it's activated
function M.load_language_linters(language_name)
	local languages_module = require("optispec.core.languages")
	local config = languages_module.get_language_config(language_name)
	
	if not config or not config.mason_tools or not config.mason_tools.linter then
		return false
	end

	local null_ls = M.null_ls
	if not null_ls then
		return false
	end

	-- Get available diagnostics from none-ls
	local available_diagnostics = null_ls.builtins.diagnostics
	local sources_to_add = {}

	-- Add each configured linter if it exists in none-ls
	for _, linter_name in ipairs(config.mason_tools.linter) do
		if available_diagnostics[linter_name] then
			table.insert(sources_to_add, available_diagnostics[linter_name])
		end
	end

	-- Register sources with none-ls
	if #sources_to_add > 0 then
		null_ls.register(sources_to_add)
		return true
	end

	return false
end

-- Plugin definitions
M.plugins = {
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			M.setup({})
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = nil, -- We'll handle installation through OptiSpec
				automatic_installation = false, -- Managed by OptiSpec
				handlers = {},
			})
		end,
	},
}

return M
