-- 🚀 NDE 3.0.0 Renaissance Update: Enhanced snacks.nvim
return {
	'folke/snacks.nvim',
	priority = 1000,
	lazy = false,
	opts = {
		-- Smooth scrolling
		scroll = {
			enabled = true,
			animate = {
				duration = { step = 15, total = 250 },
				easing = 'linear',
			},
			spamming = 10,
			filter = function(buf)
				return vim.bo[buf].filetype ~= 'dashboard'
					and vim.bo[buf].filetype ~= 'alpha'
					and vim.bo[buf].filetype ~= 'snacks_explorer'
					and vim.bo[buf].filetype ~= 'toggleterm'
			end,
		},

		-- 🚀 NEW: Big file handling for performance
		bigfile = {
			enabled = true,
			size = 1.5 * 1024 * 1024, -- 1.5MB
			setup = function(ctx)
				vim.cmd("syntax clear")
				vim.opt_local.foldmethod = "manual"
				vim.opt_local.spell = false
				vim.opt_local.swapfile = false
				vim.opt_local.undofile = false
				vim.opt_local.wrap = false
				vim.opt_local.list = false
				-- Disable expensive plugins for big files
				vim.b.minipairs_disable = true
				vim.b.miniindentscope_disable = true
				Snacks.util.info("Big file detected (" .. math.floor(ctx.size / 1024 / 1024 * 100) / 100 .. "MB). Optimizing performance...", { title = "Big File" })
			end,
		},

		-- Indent guides configuration (replaces hlchunk)
		indent = {
			enabled = true,
			indent = {
				priority = 1,
				enabled = true,
				char = "│", -- Same char as hlchunk
				only_scope = false,
				only_current = false,
				hl = "HLIndent1", -- Use hlchunk indent highlight
			},
			-- Animation settings
			animate = {
				enabled = true,
				style = "out",
				easing = "linear",
				duration = {
					step = 20,
					total = 150,
				},
			},
			-- Scope highlighting (replaces hlchunk chunk)
			scope = {
				enabled = true,
				priority = 200,
				char = "│",
				underline = false,
				only_current = false,
				hl = "HLChunk1", -- Use hlchunk scope highlight
			},
			-- Chunk disabled (we use scope instead)
			chunk = {
				enabled = false,
			},
			-- Filter to exclude filetypes (same as hlchunk)
			filter = function(buf)
				local ft = vim.bo[buf].filetype
				return vim.g.snacks_indent ~= false 
					and vim.b[buf].snacks_indent ~= false 
					and vim.bo[buf].buftype == ""
					and not vim.tbl_contains({
						"dashboard", "help", "lspinfo", "packer", "checkhealth", 
						"man", "mason", "neo-tree", "alpha", "Trouble", "trouble",
						"lazy", "notify", "toggleterm", "lazyterm"
					}, ft)
			end,
		},

		-- Disable modules we don't use
		dashboard = { enabled = false },
		input = { enabled = false },
		notifier = { enabled = false },
		quickfile = { enabled = false },
		words = { enabled = false },
	},
}
