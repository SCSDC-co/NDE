-- Initialize Opus Task Manager
local opus = {}

-- Core functionality
opus.core = require("opus.core")

-- UI components
opus.ui = require("opus.ui")

-- Configuration
opus.config = require("opus.config")

-- Setup function
function opus.setup(user_config)
    -- Setup configuration
    opus.config.setup(user_config)

    -- Load or initialize tasks
    opus.core.load_tasks()

    -- Setup commands
    opus.ui.setup_commands()
end

return opus
