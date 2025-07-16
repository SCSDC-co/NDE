local M = {}

-- Store configuration
M.config = {}

-- Setup keymaps
function M.setup(config)
	M.config = config
	
	-- Set up main screenshot keybinding
	vim.keymap.set("x", M.config.keymaps.take_screenshot, ":<C-u>Silicon<CR>", {
		desc = "Take code screenshot",
		noremap = true,
		silent = true
	})
end

return M
