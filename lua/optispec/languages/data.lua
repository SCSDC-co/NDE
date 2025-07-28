local M = {}

-- Data and Database Languages
function M.setup()
	-- SQL
	require("optispec.core.languages").register_language("sql", {
		filetypes = { "sql", "mysql", "plsql" },
		mason_tools = {
			lsp = { "sqlls" },
			formatters = { "sql-formatter" },
			linter = { "sqlfluff" },
		},
		lsp = {
			name = "sqlls",
			settings = {},
		},
		treesitter = { "sql" },
	})

	-- Prisma
	require("optispec.core.languages").register_language("prisma", {
		filetypes = { "prisma" },
		mason_tools = {
			lsp = { "prisma-language-server" },
			formatters = { "prisma-fmt" },
		},
		lsp = {
			name = "prismals",
			settings = {},
		},
		treesitter = { "prisma" },
	})

	-- R
	require("optispec.core.languages").register_language("r", {
		filetypes = { "r", "rmd" },
		mason_tools = {
			lsp = { "r-languageserver" },
		},
		lsp = {
			name = "r_language_server",
			settings = {},
		},
		treesitter = { "r" },
	})

	-- PHP
	require("optispec.core.languages").register_language("php", {
		filetypes = { "php" },
		mason_tools = {
			lsp = { "phpactor" },
			formatters = { "php-cs-fixer" },
			linter = { "phpcs" },
		},
		lsp = {
			name = "phpactor",
			settings = {},
		},
		treesitter = { "php" },
	})
end

return M
