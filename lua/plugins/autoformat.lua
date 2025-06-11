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
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },

			-- Web Technologies
			html = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },

			-- C/C++
			c = { "clang-format" },
			cpp = { "clang-format" },

			-- Other Languages
			lua = { "stylua" },
			go = { "gofmt" },
			rust = { "rustfmt" },
			java = { "google-java-format" },

			-- Data formats
			json = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },

			-- Shell
			sh = { "shfmt" },
			bash = { "shfmt" },

			-- Note: Assembly (asm) formatter not available
		},

		format_on_save = {
			timeout_ms = 1000,
			lsp_fallback = true,  -- Allow LSP fallback if prettier fails
			quiet = false,  -- Show errors if formatting fails
		},

		formatters = {
			-- prettierd will use its default configuration and look for .prettierrc files
			-- (keeps default length limits)
			shfmt = {
				prepend_args = { "-i", "0", "-ci", "-bn", "-s" },  -- -i 0 uses tabs, -s for simplify code
			},
			stylua = {
				prepend_args = { "--indent-type", "Tabs", "--indent-width", "4", "--column-width", "999999" },
			},
			["clang-format"] = {
				prepend_args = { "--style={IndentWidth: 4, UseTab: Always, TabWidth: 4, ColumnLimit: 0}" },
			},
			black = {
				prepend_args = { "--fast", "--line-length", "999999", "--skip-string-normalization" },
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
