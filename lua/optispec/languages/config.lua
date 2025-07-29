local M = {}

-- Configuration and Markup Languages
function M.setup()
	-- JSON
	require("optispec.core.languages").register_language("json", {
		filetypes = { "json", "jsonc" },
		mason_tools = {
			lsp = { "json-lsp" },
			formatters = { "prettierd" },
			linter = { "jsonlint" },
		},
		lsp = {
			name = "jsonls",
			settings = {},
		},
		-- none-ls source configurations for linters
		none_ls_sources = {
			jsonlint = function()
				local null_ls = require("null-ls")
				return {
					method = null_ls.methods.DIAGNOSTICS,
					filetypes = { "json", "jsonc" },
					generator = {
						fn = function(params, done)
							local content = table.concat(params.content, "\n")
							
							-- Run jsonlint asynchronously
							vim.system(
								{ "jsonlint", "--compact" },
								{
									stdin = content,
									text = true,
								},
								function(result)
									local diagnostics = {}
									if result.stderr then
										for line in result.stderr:gmatch("[^\n]+") do
											local line_num, col_num, message = line:match("line (%d+), col (%d+), (.+)")
											if line_num and col_num and message then
												table.insert(diagnostics, {
													row = tonumber(line_num),
													col = tonumber(col_num),
													message = message,
													code = "jsonlint",
													source = "jsonlint",
													severity = vim.diagnostic.severity.ERROR,
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
		treesitter = { "json" },
	})

	-- YAML
	require("optispec.core.languages").register_language("yaml", {
		filetypes = { "yaml", "yml" },
		mason_tools = {
			lsp = { "yaml-language-server" },
			formatters = { "prettierd" },
			linter = { "yamllint" },
		},
		lsp = {
			name = "yamlls",
			settings = {},
		},
		-- none-ls source configurations for linters
		none_ls_sources = {
			yamllint = function()
				local null_ls = require("null-ls")
				return {
					method = null_ls.methods.DIAGNOSTICS,
					filetypes = { "yaml", "yml" },
					generator = {
						fn = function(params, done)
							local content = table.concat(params.content, "\n")
							
							-- Run yamllint asynchronously
							vim.system(
								{ "yamllint", "--format", "parsable", "-" },
								{
									stdin = content,
									text = true,
								},
								function(result)
									local diagnostics = {}
									if result.stdout then
										for line in result.stdout:gmatch("[^\n]+") do
											local line_num, col_num, level, message = line:match("stdin:(%d+):(%d+): %[(%w+)%] (.+)")
											if line_num and col_num then
												table.insert(diagnostics, {
													row = tonumber(line_num),
													col = tonumber(col_num),
													message = message or "YAML lint error",
													code = "yamllint",
													source = "yamllint",
													severity = level == "error" and vim.diagnostic.severity.ERROR
															  or level == "warning" and vim.diagnostic.severity.WARN
															  or vim.diagnostic.severity.INFO,
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
		treesitter = { "yaml" },
	})

	-- TOML
	require("optispec.core.languages").register_language("toml", {
		filetypes = { "toml" },
		mason_tools = {
			lsp = { "taplo" },
			formatters = { "taplo" },
		},
		lsp = {
			name = "taplo",
			settings = {},
		},
		treesitter = { "toml" },
	})

	-- Markdown
	require("optispec.core.languages").register_language("markdown", {
		filetypes = { "markdown", "md" },
		mason_tools = {
			lsp = { "marksman" },
			formatters = { "prettierd" },
			linter = { "markdownlint" },
		},
		lsp = {
			name = "marksman",
			settings = {},
		},
		-- none-ls source configurations for linters
		none_ls_sources = {
			markdownlint = function()
				local null_ls = require("null-ls")
				return {
					method = null_ls.methods.DIAGNOSTICS,
					filetypes = { "markdown", "md" },
					generator = {
						fn = function(params, done)
							local content = table.concat(params.content, "\n")
							
							-- Run markdownlint asynchronously
							vim.system(
								{ "markdownlint", "--json", "--stdin" },
								{
									stdin = content,
									text = true,
								},
								function(result)
									local diagnostics = {}
									if result.stdout then
										local ok, json_data = pcall(vim.json.decode, result.stdout)
										if ok and json_data then
											for filename, errors in pairs(json_data) do
												for _, error in ipairs(errors) do
													table.insert(diagnostics, {
														row = error.lineNumber,
														col = error.columnNumber or 1,
														message = error.ruleDescription .. ": " .. error.errorDetail,
														code = error.ruleNames[1],
														source = "markdownlint",
														severity = vim.diagnostic.severity.WARN,
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
		treesitter = { "markdown", "markdown_inline" },
	})

	-- Nix
	require("optispec.core.languages").register_language("nix", {
		filetypes = { "nix" },
		mason_tools = {
			lsp = { "nil" },
			formatters = { "alejandra" },
		},
		lsp = {
			name = "nil_ls",
			settings = {},
		},
		treesitter = { "nix" },
	})

	-- CMake
	require("optispec.core.languages").register_language("cmake", {
		filetypes = { "cmake" },
		mason_tools = {
			lsp = { "cmake-language-server" },
		},
		lsp = {
			name = "cmake",
			settings = {},
		},
		treesitter = { "cmake" },
	})

	-- Git
	require("optispec.core.languages").register_language("git", {
		filetypes = { "gitcommit", "gitrebase", "gitconfig" },
		mason_tools = {},
		treesitter = { "git_config", "git_rebase", "gitcommit", "gitignore" },
	})

	-- LaTeX
	require("optispec.core.languages").register_language("tex", {
		filetypes = { "tex", "latex" },
		mason_tools = {
			lsp = { "texlab" },
		},
		lsp = {
			name = "texlab",
			settings = {},
		},
		treesitter = { "latex" },
	})

	-- Lua
	require("optispec.core.languages").register_language("lua", {
		filetypes = { "lua" },
		mason_tools = {
			lsp = { "lua-language-server" },
			formatters = { "stylua" },
			linter = { "luacheck" },
			dap = { "local-lua-debugger-vscode" },
		},
		lsp = {
			name = "lua_ls",
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		},
		-- none-ls source configurations for linters
		none_ls_sources = {
			luacheck = function()
				local null_ls = require("null-ls")
				return {
					method = null_ls.methods.DIAGNOSTICS,
					filetypes = { "lua" },
					generator = {
						fn = function(params, done)
							local content = table.concat(params.content, "\n")
							
							-- Run luacheck asynchronously
							vim.system(
								{ "luacheck", "--formatter", "plain", "--codes", "-" },
								{
									stdin = content,
									text = true,
								},
								function(result)
									local diagnostics = {}
									if result.stdout then
										for line in result.stdout:gmatch("[^\n]+") do
											local line_num, col_num, level, code, message = line:match("stdin:(%d+):(%d+): %((%w+)%) %((%w+)%) (.+)")
											if line_num and col_num then
												table.insert(diagnostics, {
													row = tonumber(line_num),
													col = tonumber(col_num),
													message = message or "Luacheck error",
													code = code,
													source = "luacheck",
													severity = level == "error" and vim.diagnostic.severity.ERROR
															  or level == "warning" and vim.diagnostic.severity.WARN
															  or vim.diagnostic.severity.INFO,
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
		treesitter = { "lua" },
	})

	-- Nushell
	require("optispec.core.languages").register_language("nushell", {
		filetypes = { "nu" },
		mason_tools = {
			lsp = { "nushell" },
		},
		lsp = {
			name = "nushell",
			settings = {},
		},
		treesitter = { "nu" },
	})

	-- Thrift
	require("optispec.core.languages").register_language("thrift", {
		filetypes = { "thrift" },
		mason_tools = {},
		treesitter = { "thrift" },
	})
end

return M
