-- Initialize Opus Task Manager
local opus = {}

-- Core functionality
opus.core = require("opus.core")

-- UI components
opus.ui = require("opus.ui")

-- Setup function
function opus.setup()
    -- Ensure storage directory exists
    local data_dir = vim.fn.stdpath("data") .. "/nde"
    vim.fn.mkdir(data_dir, "p")

    -- Load or initialize tasks
    opus.core.load_tasks()

    -- Setup commands
    opus.ui.setup_commands()
end

return opus
