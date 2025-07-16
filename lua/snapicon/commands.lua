local M = {}

-- Store configuration
M.config = {}

-- Setup commands
function M.setup(config)
	M.config = config
	
	-- Create the main Silicon command
	vim.api.nvim_create_user_command(M.config.command.name, function(opts)
		-- Handle range if provided
		local start_line, end_line = nil, nil
		if opts.range > 0 then
			start_line = opts.line1
			end_line = opts.line2
		end
		require("snapicon.core").take_screenshot(start_line, end_line)
	end, { 
		range = M.config.command.range,
		desc = "Take a screenshot of selected code"
	})
end

return M
