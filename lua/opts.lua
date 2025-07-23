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

-- Disable deprecation warnings
vim.g.deprecation_warnings = false

-- Confirm quitting without saving
vim.opt.confirm = true

-- Folding optimization - defer expensive operations
vim.opt.foldmethod = "manual" -- Start with manual, switch to expr later
vim.opt.foldenable = false -- Disable folding initially for speed
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
vim.opt.scrolloff = 4 -- Keep cursor 4 lines away from screen edges
vim.opt.sidescrolloff = 8 -- Keep cursor 8 columns away from screen edges

-- Custom highlights
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e6c384", bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5e5c64" })

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

-- ===== LSP SCROLLING OPTIMIZATION ===== --
-- Buffer detachment approach: temporarily detach LSP clients from buffer during scrolling

local scroll_debounce_timer = nil
local last_line = nil
local scroll_threshold = 3 -- Consider it scrolling if moving more than 3 lines
local lsp_disabled = false
local detached_clients = {}

local function disable_lsp_during_scroll()
	if lsp_disabled then
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	
	-- Clear all diagnostics immediately
	vim.diagnostic.reset(nil, bufnr)
	
	-- Disable diagnostic display
	vim.diagnostic.config({
		virtual_text = false,
		signs = false,
		update_in_insert = false,
		underline = false,
		severity_sort = false,
	}, bufnr)

	-- Detach all LSP clients from current buffer
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, client in pairs(clients) do
		if client.attached_buffers[bufnr] then
			-- Store client info for reattachment
			table.insert(detached_clients, {
				client = client,
				bufnr = bufnr,
				name = client.name
			})
			
			-- Detach client from buffer
			vim.lsp.buf_detach_client(bufnr, client.id)
		end
	end

	lsp_disabled = true
end

local function enable_lsp_after_scroll()
	if not lsp_disabled then
		return
	end

	-- Reattach all detached clients
	for _, client_info in pairs(detached_clients) do
		vim.schedule(function()
			-- Reattach client to buffer
			vim.lsp.buf_attach_client(client_info.bufnr, client_info.client.id)
		end)
	end

	-- Clear detached clients list
	detached_clients = {}

	-- Re-enable diagnostics with delay to allow reattachment
	vim.schedule(function()
		vim.diagnostic.config({
			virtual_text = {
				spacing = 4,
				source = "if_many",
				prefix = "●",
			},
			signs = true,
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end)

	lsp_disabled = false
end

-- Use WinScrolled event for more accurate scroll detection
vim.api.nvim_create_autocmd({ "WinScrolled" }, {
	callback = function()
		if not lsp_disabled then
			disable_lsp_during_scroll()
		end

		-- Reset debounce timer
		if scroll_debounce_timer then
			vim.fn.timer_stop(scroll_debounce_timer)
		end

		-- Re-enable LSP features after scrolling stops
		scroll_debounce_timer = vim.fn.timer_start(100, function()
			enable_lsp_after_scroll()
			scroll_debounce_timer = nil
		end)
	end,
})

-- Fallback using CursorMoved for other navigation
vim.api.nvim_create_autocmd({ "CursorMoved" }, {
	callback = function()
		local current_line = vim.fn.line(".")

		-- Only trigger during significant cursor movements (likely scrolling)
		if last_line and math.abs(current_line - last_line) >= scroll_threshold then
			if not lsp_disabled then
				disable_lsp_during_scroll()
			end

			-- Reset debounce timer
			if scroll_debounce_timer then
				vim.fn.timer_stop(scroll_debounce_timer)
			end

			-- Re-enable LSP features after scrolling stops
			scroll_debounce_timer = vim.fn.timer_start(100, function()
				enable_lsp_after_scroll()
				scroll_debounce_timer = nil
			end)
		end

		last_line = current_line
	end,
})
