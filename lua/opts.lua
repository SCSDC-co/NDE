---@diagnostic disable: undefined-global

-- ===== PERFORMANCE OPTIMIZATIONS ===== --

-- Reduce logging noise
vim.lsp.set_log_level("ERROR")

-- Suppress excessive info messages
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
	if
		level == vim.log.levels.INFO
		and (string.find(msg, "LSP") or string.find(msg, "Configured") or string.find(msg, "loaded"))
	then
		return -- Suppress LSP info messages
	end
	-- Also suppress LSP client quit messages during scrolling optimization
	if
		msg
		and (
			string.find(msg, "quit with exit code")
			or string.find(msg, "Check log for errors")
			or string.find(msg, "Client.*quit")
		)
	then
		return -- Suppress LSP client restart messages
	end
	original_notify(msg, level, opts)
end

-- Core performance settings
vim.opt.ttyfast = true -- Fast terminal connection
vim.opt.updatetime = 200 -- Reasonable update time
vim.opt.timeoutlen = 300 -- Faster key sequence timeout
vim.opt.ttimeoutlen = 10 -- Faster key code timeout
vim.opt.redrawtime = 1500 -- Time limit for syntax highlighting
vim.opt.synmaxcol = 200 -- Limit syntax highlighting to 200 columns

-- Enable smooth scrolling for better experience
if vim.fn.has("nvim-0.10") == 1 then
	vim.opt.smoothscroll = true
end

-- vim.opt.regexpengine = 1            -- Commented out due to compatibility issues

-- Memory and performance optimizations
vim.opt.maxmempattern = 20000 -- Increase memory for pattern matching
vim.opt.history = 100 -- Limit command history (default 10000)
-- vim.opt.shadafile = "NONE"          -- Commented out to avoid issues, use :set shada= if needed

-- Disable some built-in plugins for speed
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_matchit = 1
vim.g.loaded_tutor_mode_plugin = 1

-- Force enable matchparen after config loads
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.g.loaded_matchparen = nil
		vim.cmd("runtime plugin/matchparen.vim")
	end,
})
vim.g.loaded_spellfile_plugin = 1

vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.list = true

vim.opt.listchars = {
	eol = "⬎",
	tab = "  ",
	trail = " ",
	extends = " ",
	precedes = " ",
	nbsp = " ",
}

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- Disable deprecation warnings
vim.g.deprecation_warnings = false

-- Confirm quitting without saving
vim.opt.confirm = true

-- Folding optimization - defer expensive operations
vim.opt.foldmethod = "manual" -- Start with manual, switch to expr later
vim.opt.foldenable = true -- Enable folding for statuscolumn
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "1" -- Enable fold column for statuscolumn

-- Defer treesitter folding setup until after buffer load
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		vim.schedule(function()
			-- Only enable treesitter folding for supported filetypes
			local ft = vim.bo.filetype
			if ft ~= "" and ft ~= "help" and ft ~= "dashboard" then
				vim.opt_local.foldmethod = "expr"
				vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.opt_local.foldenable = true
			end
		end)
	end,
})

vim.opt.cursorline = true
vim.opt.scrolloff = 4 -- Keep cursor 4 lines away from screen edges
vim.opt.sidescrolloff = 8 -- Keep cursor 8 columns away from screen edges

-- Additional scrolling performance improvements
vim.opt.lazyredraw = false -- Don't use lazyredraw as it can cause issues with modern plugins
vim.opt.scroll = 0 -- Use default scroll amount (half screen)
vim.opt.mouse = "a" -- Enable mouse support for better scrolling
vim.opt.mousescroll = "ver:3,hor:0" -- Smooth mouse scrolling

-- Diagnostic configuration is now handled in LSP plugin

-- Diagnostic configuration is now completely handled in LSP plugin with nuclear approach

-- Performance autocmds
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
	callback = function()
		vim.opt.updatetime = 200
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
	callback = function()
		vim.opt.updatetime = 1000 -- Slower updates when not focused
	end,
})

-- Optimize large files
vim.api.nvim_create_autocmd("BufReadPre", {
	callback = function()
		local file_size = vim.fn.getfsize(vim.fn.expand("%"))
		if file_size > 1024 * 1024 then -- 1MB
			vim.opt_local.syntax = "off"
			vim.opt_local.wrap = false
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
			vim.opt_local.cursorline = false
			vim.opt_local.foldmethod = "manual"
			vim.b.large_file = true
		end
	end,
})

-- Disable fold column for Neo-tree specifically
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	pattern = { "neo-tree" },
	callback = function()
		vim.opt_local.foldcolumn = "0"
	end,
})
