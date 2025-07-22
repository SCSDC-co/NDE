-- NDE Plugin Loader - Integrates with Plugin Manager
-- This system loads only core plugins + user-enabled optional plugins

local plugin_manager = require("config.plugin-manager")
local plugins = {}

-- Get list of plugins to load (core + enabled optional)
local plugins_to_load = plugin_manager.get_plugins_to_load()

-- Load each plugin configuration
for _, plugin_path in ipairs(plugins_to_load) do
  local category, plugin_name = plugin_path:match("^([^/]+)/(.+)$")
  if category and plugin_name then
    local full_path = "plugins." .. category .. "." .. plugin_name
    
    -- Safely load the plugin configuration
    local ok, plugin_config = pcall(require, full_path)
    if ok and type(plugin_config) == "table" then
      table.insert(plugins, plugin_config)
    else
      vim.notify("Failed to load plugin: " .. full_path, vim.log.levels.WARN)
    end
  end
end

-- Also add the missing 'coding' category to scan for any enabled plugins
local coding_files = vim.fn.glob(vim.fn.stdpath("config") .. "/lua/plugins/coding/*.lua", false, true)
for _, file_path in ipairs(coding_files) do
  local file_name = vim.fn.fnamemodify(file_path, ":t:r")
  local user_config = require("config.plugin-manager")
  
  -- Check if this coding plugin is enabled in user config
  local config_path = vim.fn.stdpath("config") .. "/nde-config.lua"
  if vim.fn.filereadable(config_path) == 1 then
    local ok, loaded_config = pcall(dofile, config_path)
    if ok and loaded_config and loaded_config.optional_plugins and loaded_config.optional_plugins[file_name] then
      local plugin_config = require("plugins.coding." .. file_name)
      if type(plugin_config) == "table" then
        table.insert(plugins, plugin_config)
      end
    end
  end
end

return plugins

