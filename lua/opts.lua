-- ===== PERFORMANCE OPTIMIZATIONS ===== --

-- Reduce logging noise
vim.lsp.set_log_level("ERROR")

-- Suppress excessive info messages
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
	if level == vim.log.levels.INFO and (string.find(msg, "LSP") or string.find(msg, "Configured") or string.find(msg, "loaded")) then
		return -- Suppress LSP info messages
	end
	original_notify(msg, level, opts)
end

-- Core performance settings
vim.opt.ttyfast = true              -- Fast terminal connection
vim.opt.updatetime = 50             -- Faster CursorHold events (default 4000ms)
vim.opt.timeoutlen = 300            -- Faster key sequence timeout
vim.opt.ttimeoutlen = 10            -- Faster key code timeout
vim.opt.redrawtime = 1500           -- Time limit for syntax highlighting
vim.opt.synmaxcol = 200             -- Limit syntax highlighting to 200 columns
-- vim.opt.regexpengine = 1            -- Commented out due to compatibility issues

-- Memory and performance optimizations
vim.opt.maxmempattern = 20000       -- Increase memory for pattern matching
vim.opt.history = 100               -- Limit command history (default 10000)
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
vim.g.loaded_matchparen = 1
vim.g.loaded_tutor_mode_plugin = 1
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

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- Folding optimization - defer expensive operations
vim.opt.foldmethod = "manual"        -- Start with manual, switch to expr later
vim.opt.foldenable = false           -- Disable folding initially for speed
vim.opt.foldlevel = 99

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

-- Custom highlights
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e6c384", bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5e5c64" })

-- Diagnostic configuration is now handled in LSP plugin

-- Diagnostic configuration is now completely handled in LSP plugin with nuclear approach

-- Performance autocmds
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
	callback = function()
		vim.opt.updatetime = 50
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
	callback = function()
		vim.opt.updatetime = 1000  -- Slower updates when not focused
	end,
})

-- Optimize large files
vim.api.nvim_create_autocmd("BufReadPre", {
	callback = function()
		local file_size = vim.fn.getfsize(vim.fn.expand("%"))
		if file_size > 1024 * 1024 then  -- 1MB
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

-- LSP timeout logic removed - it was too aggressive and restarting healthy clients
-- If you experience actual LSP issues, you can manually restart with :LspRestart
