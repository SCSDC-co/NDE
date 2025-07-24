-- 💾 persistence.nvim: Automatic session management
-- Automatically saves and restores sessions based on current working directory
-- Perfect for maintaining project state across nvim restarts

return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {
		-- Directory where session files are saved
		dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),

		-- Save session options
		options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },

		-- Save session on exit
		save_empty = true,

		-- Pre-save hook to clean up before saving
		pre_save = function()
			-- Close any floating windows or popups
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local config = vim.api.nvim_win_get_config(win)
				if config.relative ~= "" then
					vim.api.nvim_win_close(win, false)
				end
			end
		end,
	},
	keys = {
		{
			"<leader>ss",
			function()
				require("persistence").save()
			end,
			desc = "💾 Save Session",
		},
		{
			"<leader>sl",
			function()
				require("persistence").load()
			end,
			desc = "📂 Load Session (Current Dir)",
		},
		{
			"<leader>sL",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "📂 Load Last Session",
		},
		{
			"<leader>sd",
			function()
				require("persistence").stop()
			end,
			desc = "🚫 Stop Session (Don't Save on Exit)",
		},
	},
}
