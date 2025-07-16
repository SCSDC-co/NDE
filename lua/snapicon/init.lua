local M = {}

-- Default configuration
local default_config = {
	-- Screenshot settings
	silicon = {
		background = "#181616",
		theme = "Visual Studio Dark+",
		font = "FiraCode Nerd Font Mono=34",
		pad_vert = 80,
		pad_horiz = 50,
		show_window_controls = true,
	},
	
	-- Output settings
	output = {
		dir = nil, -- nil means use XDG_PICTURES_DIR or ~/Pictures
		filename_template = "silicon-{timestamp}.png", -- {timestamp}, {filename}, {filepath}
		use_full_path_title = true, -- Show full path in window title
		copy_to_clipboard = true, -- Copy screenshot to clipboard (Linux only)
	},
	
	-- Keybindings
	keymaps = {
		take_screenshot = "<leader>S",
	},
	
	-- Command settings
	command = {
		name = "Silicon",
		range = true,
	},
	
	-- Which-key integration
	which_key = {
		enabled = true,
		group_key = "<leader>C",
		group_name = "📸 Silicon",
	},
}

-- Store the configuration
M.config = {}

-- Setup function
function M.setup(opts)
	-- Merge user config with defaults
	M.config = vim.tbl_deep_extend("force", default_config, opts or {})
	
	-- Initialize core functionality
	require("snapicon.core").setup(M.config)
	
	-- Setup keybindings
	require("snapicon.keymaps").setup(M.config)
	
	-- Setup commands
	require("snapicon.commands").setup(M.config)
	
	-- Setup which-key integration if enabled
	if M.config.which_key.enabled then
		require("snapicon.which_key").setup(M.config)
	end
end

-- Public API functions
function M.take_screenshot()
	require("snapicon.core").take_screenshot()
end

function M.get_config()
	return M.config
end

return M
