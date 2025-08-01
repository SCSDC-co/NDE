return {
	"luukvbaal/statuscol.nvim",
	lazy = false, -- Load immediately for statuscolumn to work properly
	config = function()
		local builtin = require("statuscol.builtin")
		require("statuscol").setup({
			setopt = true, -- Use statuscol to set 'statuscolumn'
			relculnr = true, -- Relative line numbers
			relculright = false,
			bt_ignore = { "neo-tree", "aerial", "trouble", "help" },
			ft_ignore = { "neo-tree", "aerial", "trouble", "help", "dashboard" },
			segments = {
				-- Sign column
				{
					sign = { namespace = { "diagnostic/signs", "gitsigns" }, maxwidth = 2, colwidth = 2, auto = true },
					click = "v:lua.ScSa",
				},
				-- Line numbers
				{
					text = { builtin.lnumfunc, " " },
					condition = { true, builtin.not_empty },
					click = "v:lua.ScLa",
				},
				-- Fold column with custom appearance
				{
					text = { builtin.foldfunc },
					condition = { builtin.not_empty },
					click = "v:lua.ScFa",
					hl = "FoldColumn",
				},
				-- Optional divider/separator
				{
					text = { " " },
					condition = { true },
					hl = "StatusColumnSeparator",
				},
			},
		})

		-- Set better fold characters using Unicode
		vim.opt.fillchars = {
			fold = " ", -- Fill character for closed folds
			foldopen = "", -- Opened fold indicator
			foldclose = "", -- Closed fold indicator
			foldsep = "│", -- Fold separator (vertical line)
			eob = " ", -- End of buffer
		}
	end,
}
