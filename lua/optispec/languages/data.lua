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
		-- none-ls source configurations for linters
		none_ls_sources = {
			sqlfluff = function()
				local null_ls = require("null-ls")
				return {
					method = null_ls.methods.DIAGNOSTICS,
					filetypes = { "sql", "mysql", "plsql" },
					generator = {
						fn = function(params, done)
							local content = table.concat(params.content, "\n")
							
							-- Run sqlfluff asynchronously
							vim.system(
								{ "sqlfluff", "lint", "--format", "json", "-" },
								{
									stdin = content,
									text = true,
								},
								function(result)
									local diagnostics = {}
									if result.stdout then
										local ok, json_data = pcall(vim.json.decode, result.stdout)
										if ok and json_data then
											for _, violation in ipairs(json_data.violations or {}) do
												table.insert(diagnostics, {
													row = violation.line_no,
													col = violation.line_pos,
													message = violation.description,
													code = violation.code,
													source = "sqlfluff",
													severity = vim.diagnostic.severity.WARN,
												})
											end
										end
									end
									done(diagnostics)
								end
							)
						end,
						async = true,
					},
				}
			end,
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
			dap = { "php-debug-adapter" },
		},
		lsp = {
			name = "phpactor",
			settings = {},
		},
		-- none-ls source configurations for linters
		none_ls_sources = {
			phpcs = function()
				local null_ls = require("null-ls")
				return {
					method = null_ls.methods.DIAGNOSTICS,
					filetypes = { "php" },
					generator = {
						fn = function(params, done)
							local content = table.concat(params.content, "\n")
							
							-- Run phpcs asynchronously
							vim.system(
								{ "phpcs", "--report=json", "--stdin-path=" .. params.bufname, "-" },
								{
									stdin = content,
									text = true,
								},
								function(result)
									local diagnostics = {}
									if result.stdout then
										local ok, json_data = pcall(vim.json.decode, result.stdout)
										if ok and json_data and json_data.files then
											for filename, file in pairs(json_data.files) do
												for _, message in ipairs(file.messages or {}) do
													table.insert(diagnostics, {
														row = message.line,
														col = message.column,
														message = message.message,
														code = message.source,
														source = "phpcs",
														severity = message.type == "ERROR" and vim.diagnostic.severity.ERROR
																  or message.type == "WARNING" and vim.diagnostic.severity.WARN
																  or vim.diagnostic.severity.INFO,
													})
												end
											end
										end
									end
									done(diagnostics)
								end
							)
						end,
						async = true,
					},
				}
			end,
		},
		treesitter = { "php" },
	})
end

return M
