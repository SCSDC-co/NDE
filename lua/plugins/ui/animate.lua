return {
	"echasnovski/mini.animate",
	event = "VeryLazy",
	config = function()
		local animate = require("mini.animate")
		
		animate.setup({
			-- Cursor movement animation
			cursor = {
				enable = true,
				timing = animate.gen_timing.exponential({ easing = "out", duration = 250, unit = "total" }),
				path = animate.gen_path.line(),
			},
			
			-- Scrolling animation
			scroll = {
				enable = true,
				timing = animate.gen_timing.exponential({ easing = "out", duration = 200, unit = "total" }),
				subscroll = animate.gen_subscroll.equal(),
			},
			
			-- Window resize animation
			resize = {
				enable = true,
				timing = animate.gen_timing.exponential({ easing = "out", duration = 150, unit = "total" }),
				subresize = animate.gen_subresize.equal(),
			},
			
			-- Window open/close animation
			open = {
				enable = true,
				timing = animate.gen_timing.exponential({ easing = "out", duration = 200, unit = "total" }),
				winconfig = animate.gen_winconfig.wipe({ direction = "from_edge" }),
				winblend = animate.gen_winblend.linear({ from = 80, to = 0 }),
			},
			
			close = {
				enable = true,
				timing = animate.gen_timing.exponential({ easing = "in", duration = 100, unit = "total" }),
				winconfig = animate.gen_winconfig.wipe({ direction = "to_edge" }),
				winblend = animate.gen_winblend.linear({ from = 0, to = 80 }),
			},
		})
		
		-- Optional: Disable animations for specific filetypes or when performance is needed
		local group = vim.api.nvim_create_augroup("MiniAnimateConfig", { clear = true })
		
		-- Disable animations in terminal buffers for better performance
		vim.api.nvim_create_autocmd("TermOpen", {
			group = group,
			callback = function()
				vim.b.minianimate_disable = true
			end,
		})
		
		-- Disable animations for very large files (>1000 lines) for performance
		vim.api.nvim_create_autocmd("BufEnter", {
			group = group,
			callback = function()
				local lines = vim.api.nvim_buf_line_count(0)
				if lines > 1000 then
					vim.b.minianimate_disable = true
				else
					vim.b.minianimate_disable = false
				end
			end,
		})
	end,
}

