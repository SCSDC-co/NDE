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
		{
			"<leader>F",
			"<Cmd>ConformInfo<CR>",
			mode = "n",
			desc = "Formatter info",
		},
	},
	config = function()
		-- Load formatters configuration
		local formatters_config = require("formatters").setup()
		
		-- Ensure Mason PATH is available for conform.nvim
		local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
		vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
		
		-- Setup conform.nvim with our formatters
		require("conform").setup({
			formatters_by_ft = formatters_config.formatters_by_ft,
			formatters = formatters_config.formatters,
			
			format_on_save = {
				timeout_ms = 1000,
				lsp_fallback = true,
				quiet = false,
			},
			
			-- Additional formatting options
			log_level = vim.log.levels.WARN,
			notify_on_error = true,
		})

		-- Set filetype for assembly files (no formatter available)
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = "*.asm",
			callback = function()
				vim.bo.filetype = "asm"
			end,
		})
		
		-- Additional file type detection
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = { "*.zsh", "*.zshrc" },
			callback = function()
				vim.bo.filetype = "zsh"
			end,
		})
	end,
}
