local config = {}

-- Default configuration
config.defaults = {
    -- File paths
    data_dir = vim.fn.stdpath("data") .. "/nde",
    tasks_file = vim.fn.stdpath("data") .. "/nde/opus.json",
    
    -- UI settings
    ui = {
        width = 80,
        height = 33,
        task_panel_size = "70%",
        help_panel_size = "30%",
        border_style = "rounded",
        
        -- Icons and symbols
        icons = {
            completed = "✓",
            incomplete = "✗",
            selected = "▶",
            unselected = " ",
        },
        
        -- Colors (highlight groups)
        highlights = {
            completed_task = "Comment",
            incomplete_task = "Normal",
            selected_task = "CursorLine",
            tags = "Keyword",
            border = "FloatBorder",
        }
    },
    
    -- Keymaps for the UI
    keymaps = {
        quit = { "q", "<Esc>" },
        navigate_down = { "j", "<Down>" },
        navigate_up = { "k", "<Up>" },
        toggle_complete = { "<Enter>", "<Space>" },
        add_task = "a",
        rename_task = "r",
        delete_task = "d",
        add_tag = "t",
        remove_tag = "T",
        filter_by_tag = "f",
        sort_by_name = "n",
        sort_by_completion = "c",
        show_stats = "s",
        search = "/",
    },
    
    -- Task defaults
    task_defaults = {
        completed = false,
        tags = {},
        created_at = function() return os.date("%Y-%m-%d %H:%M:%S") end,
    },
    
    -- Persistence settings
    persistence = {
        auto_save = true,
        backup_count = 3,
        pretty_json = true,
    },
    
    -- Notifications
    notifications = {
        enabled = true,
        timeout = 3000,
        level = vim.log.levels.INFO,
    }
}

-- Current configuration (starts with defaults)
config.current = vim.deepcopy(config.defaults)

-- Setup function to merge user config with defaults
function config.setup(user_config)
    if user_config then
        config.current = vim.tbl_deep_extend("force", config.current, user_config)
    end
    
    -- Ensure data directory exists
    vim.fn.mkdir(config.current.data_dir, "p")
    
    return config.current
end

-- Get configuration value with dot notation support
function config.get(key)
    if not key then
        return config.current
    end
    
    local keys = vim.split(key, ".", { plain = true })
    local value = config.current
    
    for _, k in ipairs(keys) do
        if type(value) == "table" and value[k] ~= nil then
            value = value[k]
        else
            return nil
        end
    end
    
    return value
end

-- Set configuration value with dot notation support
function config.set(key, value)
    local keys = vim.split(key, ".", { plain = true })
    local current = config.current
    
    for i = 1, #keys - 1 do
        local k = keys[i]
        if type(current[k]) ~= "table" then
            current[k] = {}
        end
        current = current[k]
    end
    
    current[keys[#keys]] = value
end

-- Validate configuration
function config.validate()
    local errors = {}
    
    -- Check required paths
    if not config.current.data_dir then
        table.insert(errors, "data_dir is required")
    end
    
    if not config.current.tasks_file then
        table.insert(errors, "tasks_file is required")
    end
    
    -- Check UI dimensions
    if config.current.ui.width <= 0 then
        table.insert(errors, "ui.width must be positive")
    end
    
    if config.current.ui.height <= 0 then
        table.insert(errors, "ui.height must be positive")
    end
    
    return #errors == 0, errors
end

return config
