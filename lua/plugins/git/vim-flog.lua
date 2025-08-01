-- 🚀 NDE 3.0.0 Renaissance Update: vim-flog for commit tree visualization
return {
	{
		"rbong/vim-flog",
		tag = "v3.0.0", -- Pin to latest stable version
		dependencies = {
			"tpope/vim-fugitive", -- vim-flog requires vim-fugitive
		},
		cmd = { "Flog", "Flogsplit", "Floggit" },
		keys = {
			{ "<leader>gl", "<cmd>Flog<cr>", desc = "Git Log (Flog)" },
			{ "<leader>gL", "<cmd>Flogsplit<cr>", desc = "Git Log Split (Flog)" },
		},
		config = function()
			-- Configure vim-flog settings for proper graph display
			vim.g.flog_permanent_default_opts = {
				max_count = 2000,
				all = true,
				graph = true, -- Explicitly enable graph
				format = "%C(auto)%h %C(bold blue)%an %C(reset)%C(green)(%ar) %C(reset)%s%C(auto)%d", -- 🔥 Cool format
				date = "relative", -- Use relative dates like "2 hours ago"
			}

			-- Enable enhanced graph visualization (v3.0.0 features)
			vim.g.flog_enable_dynamic_branch_hl = true -- Better branch colors
			vim.g.flog_enable_dynamic_commit_hl = true -- Better commit highlighting
			vim.g.flog_enable_extended_chars = true
			vim.g.flog_enable_extra_padding = true

			-- Force graph to always show
			vim.g.flog_default_opts = {
				graph = true,
				all = true,
			}

			-- Custom keymaps for flog buffer
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "flog",
				callback = function()
					local opts = { buffer = true, silent = true }

					-- Navigation
					vim.keymap.set("n", "q", "<cmd>q<cr>", opts)
					vim.keymap.set("n", "<Tab>", "<Plug>(FlogVNextCommitRight)", opts)
					vim.keymap.set("n", "<S-Tab>", "<Plug>(FlogVPrevCommitRight)", opts)

					-- Git actions
					vim.keymap.set("n", "gb", "<Plug>(FlogVDiffRight)", opts)
					vim.keymap.set("n", "gs", "<Plug>(FlogVSplitRight)", opts)
					vim.keymap.set("n", "gd", "<Plug>(FlogVDiff)", opts)
					vim.keymap.set("n", "go", "<Plug>(FlogVOpen)", opts)

					-- Useful shortcuts
					vim.keymap.set("n", "<CR>", "<Plug>(FlogVOpen)", opts)
					vim.keymap.set("n", "o", "<Plug>(FlogVOpen)", opts)
				end,
			})
		end,
	},
}
