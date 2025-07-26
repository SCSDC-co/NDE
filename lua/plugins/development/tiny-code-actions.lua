return {
	"rachartier/tiny-code-action.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		-- Using snacks.nvim as picker (already a core plugin)
		{
			"folke/snacks.nvim",
			opts = {
				terminal = {},
			},
		},
	},
	event = "LspAttach",
	keys = {
		{
			"<leader>Ca",
			function()
				require("tiny-code-action").code_action()
			end,
			mode = { "n", "x" },
			desc = "Code Action",
			noremap = true,
			silent = true,
		},
	},
	opts = {
		--- The backend to use, currently only "vim", "delta", "difftastic", "diffsofancy" are supported
		backend = "vim",

		-- The picker to use, "telescope", "snacks", "select", "buffer" are supported
		picker = "snacks",

		backend_opts = {
			delta = {
				-- Header from delta can be quite large.
				-- You can remove them by setting this to the number of lines to remove
				header_lines_to_remove = 4,

				-- The arguments to pass to delta
				args = {
					"--line-numbers",
				},
			},
			difftastic = {
				header_lines_to_remove = 1,

				-- The arguments to pass to difftastic
				args = {
					"--color=always",
					"--display=inline",
					"--syntax-highlight=on",
				},
			},
			diffsofancy = {
				header_lines_to_remove = 4,
			},
		},

		-- The icons to use for the code actions
		signs = {
			quickfix = { "", { link = "DiagnosticWarning" } },
			others = { "", { link = "DiagnosticWarning" } },
			refactor = { "", { link = "DiagnosticInfo" } },
			["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
			["refactor.extract"] = { "", { link = "DiagnosticError" } },
			["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
			["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
			["source"] = { "", { link = "DiagnosticError" } },
			["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
			["codeAction"] = { "", { link = "DiagnosticWarning" } },
		},
	},
}
