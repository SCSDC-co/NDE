return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({
					async = true,
					lsp_fallback = false,
					timeout_ms = 500,
				})
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
			javascript = { { "prettierd", "prettier" } },
			typescript = { { "prettierd", "prettier" } },
			javascriptreact = { { "prettierd", "prettier" } },
			typescriptreact = { { "prettierd", "prettier" } },

			-- Web Technologies
			html = { { "prettierd", "prettier" } },
			css = { { "prettierd", "prettier" } },
			scss = { { "prettierd", "prettier" } },

			-- C/C++
			c = { "clang_format" },
			cpp = { "clang_format" },

			-- Other Languages
			lua = { "stylua" },
			go = { "gofmt" },
			rust = { "rustfmt" },
			java = { "google-java-format" },

			-- Data formats
			json = { { "prettierd", "prettier" } },
			yaml = { { "prettierd", "prettier" } },
			markdown = { { "prettierd", "prettier" } },

			-- Shell
			sh = { "shfmt" },
			bash = { "shfmt" },

			-- Assembly
			asm = { "asmfmt" },
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
			clang_format = {
				prepend_args = { "--style={IndentWidth: 4, UseTab: Always}" },
			},
			black = {
				prepend_args = { "--fast" },
			},
		},
	},

	config = function(_, opts)
		require("conform").setup(opts)

		-- Set filetype for assembly files
		vim.cmd([[
      autocmd BufRead,BufNewFile *.asm set filetype=asm
    ]])
	end,
}
