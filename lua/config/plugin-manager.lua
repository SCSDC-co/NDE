-- NDE Plugin Manager - Core vs Optional Plugin System
-- This file manages the separation between always-loaded core plugins
-- and user-configurable optional plugins

local M = {}

-- Core plugins that are always loaded (essential for NDE functionality)
M.core_plugins = {
  -- Core functionality
  "core/dashboard",
  "core/snacks", 
  "core/which-key",
  "core/hardtime",
  
  -- UI essentials
  "ui/bufferline",
  "ui/hlchunk",
  "ui/lualine",
  "ui/noice",
  "ui/satellite",
  "ui/themery",
  "ui/virt-column",
  "ui/zen",
  "ui/dropbar",
  
  -- Navigation essentials
  "navigation/neotree",
  "navigation/smart-splits",
  "navigation/telescope",
  
  -- Editing essentials
  "editing/cmp", -- Includes all CMP sources: nvim-lsp, buffer, path, cmdline, nvim-lua, calc, emoji, spell, luasnip, signature-help
  "editing/mini", -- Contains mini.surround, mini.pairs
  "editing/mini-align",
  "editing/mini-comment", -- mini.comment
  "editing/repeat",
  "editing/undotree",
  "editing/yanky",
  
  -- Development essentials
  "development/code-runner",
  "development/render-markdown",
  "development/codeium", -- CMP source integration
  "development/supermaven", -- CMP source integration
  
  -- Git essentials
  "git/vim-fugitive",
  "git/gitsigns",
  
  -- Terminal essentials
  "terminal/betterterm",
}

-- Load user configuration for optional plugins
local function load_user_config()
  local config_path = vim.fn.stdpath("config") .. "/nde-config.lua"
  
  -- Default configuration
  local default_config = {
    optional_plugins = {
      -- Core category
      legendary = false,
      persistence = false,
      ["vim-be-good"] = false,
      
      -- UI category
      animate = false,
      ["highlight-colors"] = false,
      incline = false,
      presence = false,
      ["rainbow-delimiters"] = false,
      ["symbol-usage"] = false,
      ["url-open"] = false,
      minty = false,
      
      -- Navigation category
      aerial = false,
      harpoon = false,
      leap = false,
      numb = false,
      oil = false,
      
      -- Editing category
      autotag = false,
      blink = false,
      dial = false,
      hlargs = false,
      illuminate = false,
      snippet = false,
      spectre = false,
      tabout = false,
      treesj = false,
      ["visual-multi"] = false,
      
      -- Development category
      avante = false,
      playground = false,
      ["todo-comments"] = false,
      trouble = false,
      
      -- Git category
      diffview = false,
      ["vim-flog"] = false,
      
      -- Terminal category
      toggleterm = false,
      
      -- Coding category
      refactoring = false,
    }
  }
  
  -- Try to load user config, fallback to default
  local user_config = default_config
  if vim.fn.filereadable(config_path) == 1 then
    local ok, loaded_config = pcall(dofile, config_path)
    if ok and type(loaded_config) == "table" then
      user_config = vim.tbl_deep_extend("force", default_config, loaded_config)
    end
  end
  
  return user_config
end

-- Get list of plugins to load based on configuration
function M.get_plugins_to_load()
  local plugins = {}
  local user_config = load_user_config()
  
  -- Always load core plugins
  for _, plugin_path in ipairs(M.core_plugins) do
    table.insert(plugins, plugin_path)
  end
  
  -- Add optional plugins based on user configuration
  for plugin_name, enabled in pairs(user_config.optional_plugins) do
    if enabled then
      -- Find the plugin file in the directory structure
      local plugin_path = M.find_plugin_path(plugin_name)
      if plugin_path then
        table.insert(plugins, plugin_path)
      end
    end
  end
  
  return plugins
end

-- Helper function to find plugin path in directory structure
function M.find_plugin_path(plugin_name)
  local categories = { "core", "ui", "navigation", "editing", "development", "git", "terminal", "coding" }
  
  for _, category in ipairs(categories) do
    local plugin_file = vim.fn.stdpath("config") .. "/lua/plugins/" .. category .. "/" .. plugin_name .. ".lua"
    if vim.fn.filereadable(plugin_file) == 1 then
      return category .. "/" .. plugin_name
    end
  end
  
  return nil
end

-- Create default user configuration file if it doesn't exist
function M.create_default_config()
  local config_path = vim.fn.stdpath("config") .. "/nde-config.lua"
  
  if vim.fn.filereadable(config_path) == 0 then
    local config_content = [[-- NDE User Configuration
-- Configure which optional plugins to enable/disable
-- Set to true to enable, false to disable

return {
  optional_plugins = {
    -- Core category
    legendary = false,
    persistence = false,
    ["vim-be-good"] = false,
    
    -- UI category
    animate = false,
    ["highlight-colors"] = false,
    incline = false,
    presence = false,
    ["rainbow-delimiters"] = false,
    ["symbol-usage"] = false,
    ["url-open"] = false,
    minty = false,
    
    -- Navigation category
    aerial = false,
    harpoon = false,
    leap = false,
    numb = false,
    oil = false,
    
    -- Editing category
    autotag = false,
    blink = false,
    dial = false,
    hlargs = false,
    illuminate = false,
    snippet = false,
    spectre = false,
    tabout = false,
    treesj = false,
    ["visual-multi"] = false,
    
    -- Development category
    avante = false,
    playground = false,
    ["todo-comments"] = false,
    trouble = false,
    
    -- Git category
    diffview = false,
    ["vim-flog"] = false,
    
    -- Terminal category
    toggleterm = false,
    
    -- Coding category
    refactoring = false,
  }
}
]]
    
    local file = io.open(config_path, "w")
    if file then
      file:write(config_content)
      file:close()
      vim.notify("Created NDE configuration file: " .. config_path, vim.log.levels.INFO)
    end
  end
end

-- Initialize the plugin manager
function M.setup()
  -- Create default config if needed
  M.create_default_config()
  
  vim.notify("NDE Plugin Manager initialized - Core plugins: " .. #M.core_plugins, vim.log.levels.INFO)
end

return M
