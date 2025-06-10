return {
	"mfussenegger/nvim-jdtls",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
	},
	ft = "java",
	config = function()
		local jdtls = require("jdtls")
		local mason_registry = require("mason-registry")

		-- Get paths to jdtls installation
		local jdtls_pkg = mason_registry.get_package("jdtls")
		local jdtls_path = jdtls_pkg:get_install_path()

		-- Determine OS-specific launcher
		local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

		-- Configuration and workspace paths
		local config_path = jdtls_path .. "/config_linux"
		if vim.fn.has("mac") == 1 then
			config_path = jdtls_path .. "/config_mac"
		elseif vim.fn.has("win32") == 1 then
			config_path = jdtls_path .. "/config_win"
		end

		-- Workspace path (project-specific)
		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		local workspace_dir = vim.fn.expand("~/.cache/jdtls/workspace/") .. project_name

		-- Enhanced capabilities with nvim-cmp
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if cmp_nvim_lsp_ok then
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
		end

		-- Extended LSP capabilities for Java
		local extendedClientCapabilities = jdtls.extendedClientCapabilities
		extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

		-- JDTLS configuration
		local config = {
			cmd = {
				"java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xms1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				launcher_jar,
				"-configuration",
				config_path,
				"-data",
				workspace_dir,
			},
			root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
			capabilities = capabilities,

			settings = {
				java = {
					eclipse = {
						downloadSources = true,
					},
					configuration = {
						updateBuildConfiguration = "interactive",
						runtimes = {},
					},
					maven = {
						downloadSources = true,
					},
					implementationsCodeLens = {
						enabled = true,
					},
					referencesCodeLens = {
						enabled = true,
					},
					format = {
						enabled = true,
						settings = {
							url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
							profile = "GoogleStyle",
						},
					},
					signatureHelp = { enabled = true },
					contentProvider = { preferred = "fernflower" },
					completion = {
						favoriteStaticMembers = {
							"org.hamcrest.MatcherAssert.assertThat",
							"org.hamcrest.Matchers.*",
							"org.hamcrest.CoreMatchers.*",
							"org.junit.jupiter.api.Assertions.*",
							"java.util.Objects.requireNonNull",
							"java.util.Objects.requireNonNullElse",
							"org.mockito.Mockito.*",
						},
						filteredTypes = {
							"com.sun.*",
							"io.micrometer.shaded.*",
							"java.awt.*",
							"jdk.*",
							"sun.*",
						},
					},
					sources = {
						organizeImports = {
							starThreshold = 9999,
							staticStarThreshold = 9999,
						},
					},
					codeGeneration = {
						toString = {
							template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
						},
						useBlocks = true,
					},
				},
			},

			init_options = {
				bundles = {},
				extendedClientCapabilities = extendedClientCapabilities,
			},

			on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Java-specific keymaps
				local bufopts = { noremap = true, silent = true, buffer = bufnr }

				-- LSP keymaps
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, bufopts)
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, bufopts)

				-- Java-specific keymaps using leader + J
				vim.keymap.set("n", "<leader>Jo", jdtls.organize_imports, { desc = "Organize Imports", buffer = bufnr })
				vim.keymap.set("n", "<leader>Jv", jdtls.extract_variable, { desc = "Extract Variable", buffer = bufnr })
				vim.keymap.set("n", "<leader>Jc", jdtls.extract_constant, { desc = "Extract Constant", buffer = bufnr })
				vim.keymap.set(
					"n",
					"<leader>Jt",
					jdtls.test_nearest_method,
					{ desc = "Test Nearest Method", buffer = bufnr }
				)
				vim.keymap.set("n", "<leader>JT", jdtls.test_class, { desc = "Test Class", buffer = bufnr })
				vim.keymap.set(
					"n",
					"<leader>Ju",
					"<Cmd>JdtUpdateConfig<CR>",
					{ desc = "Update Config", buffer = bufnr }
				)

				-- Visual mode keymaps
				vim.keymap.set("v", "<leader>Jv", function()
					jdtls.extract_variable(true)
				end, { desc = "Extract Variable", buffer = bufnr })
				vim.keymap.set("v", "<leader>Jc", function()
					jdtls.extract_constant(true)
				end, { desc = "Extract Constant", buffer = bufnr })
				vim.keymap.set("v", "<leader>Jm", function()
					jdtls.extract_method(true)
				end, { desc = "Extract Method", buffer = bufnr })

				-- Auto-format on save
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
					end,
				})
			end,
		}

		-- Start JDTLS
		jdtls.start_or_attach(config)
	end,
}
