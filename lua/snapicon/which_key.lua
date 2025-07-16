local M = {}

-- Store configuration
M.config = {}

-- Setup which-key integration
function M.setup(config)
	M.config = config
	
	-- Set up which-key group (optional)
	local ok, wk = pcall(require, "which-key")
	if ok then
		wk.add({
			{ M.config.which_key.group_key, group = M.config.which_key.group_name },
		})
	end
end

return M
