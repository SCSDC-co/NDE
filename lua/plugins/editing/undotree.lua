return {
	"mbbill/undotree",
	cmd = "UndotreeToggle", -- Lazy load on command
	keys = {
		{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
	},
	config = function()
		-- Configure undotree settings
		vim.g.undotree_WindowLayout = 1 -- Layout: undotree only, no diff at all
		vim.g.undotree_SplitWidth = 40 -- Width of the undotree window
		vim.g.undotree_SetFocusWhenToggle = 1 -- Focus undotree when toggled
		vim.g.undotree_TreeNodeShape = '●' -- Use bullet points for tree nodes
		vim.g.undotree_TreeVertShape = '│' -- Vertical line character
		vim.g.undotree_TreeSplitShape = '/' -- Split line character
		vim.g.undotree_DiffAutoOpen = 0 -- Disable diff auto-opening
		
		-- Show relative timestamps instead of absolute
		vim.g.undotree_RelativeTimestamp = 1
		
		-- Short indicators for better readability
		vim.g.undotree_ShortIndicators = 1
		
		-- Help text
		vim.g.undotree_HelpLine = 1
		
		-- Custom theming to match Kanagawa Dragon
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "undotree",
			callback = function()
				-- Set undotree-specific highlights
				vim.api.nvim_set_hl(0, "UndotreeNode", { fg = "#C8C093" })
				vim.api.nvim_set_hl(0, "UndotreeNodeCurrent", { fg = "#E6C384", bold = true })
				vim.api.nvim_set_hl(0, "UndotreeSeq", { fg = "#7AA89F" })
				vim.api.nvim_set_hl(0, "UndotreeNext", { fg = "#98BB6C" })
				vim.api.nvim_set_hl(0, "UndotreeTimeStamp", { fg = "#957FB8" })
				vim.api.nvim_set_hl(0, "UndotreeSaved", { fg = "#7E9CD8" })
				vim.api.nvim_set_hl(0, "UndotreeHead", { fg = "#E6C384", bold = true })
				vim.api.nvim_set_hl(0, "UndotreeBranch", { fg = "#FF9E3B" })
				vim.api.nvim_set_hl(0, "UndotreeCurrent", { fg = "#E6C384", bold = true })
				vim.api.nvim_set_hl(0, "UndotreeHelp", { fg = "#54546D" })
			end,
		})
		
		-- Auto-create undodir if it doesn't exist
		local undodir = vim.fn.expand("~/.config/nvim/undodir")
		if vim.fn.isdirectory(undodir) == 0 then
			vim.fn.mkdir(undodir, "p")
		end
		
		-- Set persistent undo
		vim.opt.undofile = true
		vim.opt.undodir = undodir
		vim.opt.undolevels = 10000 -- Increase undo levels
		vim.opt.undoreload = 10000 -- Increase undo reload
		
	end,
}
