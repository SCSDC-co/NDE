return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = false, lsp_fallback = false })
			end,
			mode = "n",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			-- Python
			python = { "black", "isort" },

			-- JavaScript/TypeScript
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },

			-- Web Technologies
			html = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			scss = { "prettierd", "prettier", stop_after_first = true },

			-- C/C++
			c = { "clang-format" },
			cpp = { "clang-format" },

			-- Other Languages
			lua = { "stylua" },
			go = { "gofmt" },
			rust = { "rustfmt" },
			java = { "google-java-format" },

			-- Data formats
			json = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },

			-- Shell
			sh = { "shfmt" },
			bash = { "shfmt" },

			-- Note: Assembly (asm) formatter not available
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = false,
		},

		formatters = {
			prettierd = {
				prepend_args = { "--tab-width", "4", "--use-tabs", "true" },
			},
			prettier = {
				prepend_args = { "--tab-width", "4", "--use-tabs", "true" },
			},
			shfmt = {
				prepend_args = { "-i", "4", "-ci", "-bn" },
			},
			stylua = {
				prepend_args = { "--indent-type", "Tabs", "--indent-width", "4" },
			},
			["clang-format"] = {
				prepend_args = { "--style={IndentWidth: 4, UseTab: Always}" },
			},
			black = {
				prepend_args = { "--fast" },
			},
		},
	},

	config = function(_, opts)
		-- Ensure Mason PATH is available for conform.nvim
		local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
		vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
		
		require("conform").setup(opts)

		-- Set filetype for assembly files
		vim.cmd([[
      autocmd BufRead,BufNewFile *.asm set filetype=asm
    ]])
	end,
}
