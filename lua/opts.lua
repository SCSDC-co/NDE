-- Reduce logging noise
vim.lsp.set_log_level("ERROR")

-- Suppress excessive info messages
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if level == vim.log.levels.INFO and (string.find(msg, "LSP") or string.find(msg, "Configured") or string.find(msg, "loaded")) then
    return  -- Suppress LSP info messages
  end
  original_notify(msg, level, opts)
end

vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	callback = function()
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldlevel = 99
	end,
})

vim.opt.cursorline = true

-- Custom highlights
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e6c384", bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5e5c64" })

-- Diagnostic configuration is now handled in LSP plugin

-- Diagnostic configuration is now completely handled in LSP plugin with nuclear approach

-- LSP timeout logic removed - it was too aggressive and restarting healthy clients
-- If you experience actual LSP issues, you can manually restart with :LspRestart
