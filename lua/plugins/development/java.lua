return {
	"mfussenegger/nvim-jdtls",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
	},
	ft = "java",
	config = function()
		local jdtls = require("jdtls")
		
		-- Get Java configuration from language module
		local java_config = require('langs.java')
		local config = java_config.jdtls_config()
		
		-- Extended LSP capabilities for Java
		local extendedClientCapabilities = jdtls.extendedClientCapabilities
		extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
		
		-- Add extended capabilities to config
		config.init_options = {
			bundles = {},
			extendedClientCapabilities = extendedClientCapabilities,
		}
		
		-- Add on_attach function
		config.on_attach = function(client, bufnr)
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
		end

		-- Start JDTLS
		jdtls.start_or_attach(config)
	end,
}
