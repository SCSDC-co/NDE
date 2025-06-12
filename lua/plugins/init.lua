-- Load all plugins from organized subdirectories
local plugins = {}

-- Define plugin categories and their directories
local categories = {
  "core",
  "ui", 
  "navigation",
  "editing",
  "development",
  "lsp",
  "debugging",
  "git",
  "terminal"
}

-- Load plugins from each category
for _, category in ipairs(categories) do
  local category_path = "plugins." .. category
  
  -- Get all .lua files in the category directory
  local plugin_files = vim.fn.glob(vim.fn.stdpath("config") .. "/lua/plugins/" .. category .. "/*.lua", false, true)
  
  for _, file_path in ipairs(plugin_files) do
    local file_name = vim.fn.fnamemodify(file_path, ":t:r")  -- Get filename without extension
    local plugin_config = require(category_path .. "." .. file_name)
    
    -- Add the plugin configuration to our plugins table
    if type(plugin_config) == "table" then
      table.insert(plugins, plugin_config)
    end
  end
end

return plugins

