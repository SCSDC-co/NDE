-- Plugin Manager UI using NUI
local M = {}

local Popup = require('nui.popup')
local Menu = require('nui.menu')
local event = require('nui.utils.autocmd').event

-- Centralized data directory for NDE settings
local nde_data_dir = vim.fn.stdpath("data") .. "/nde"
vim.fn.mkdir(nde_data_dir, "p") -- Ensure directory exists

-- Get current plugin configuration
local function get_current_config()
  local config_path = nde_data_dir .. "/plugins.json"
  if vim.fn.filereadable(config_path) == 1 then
    local content = vim.fn.readfile(config_path)
    if content and #content > 0 then
      local ok, config = pcall(vim.json.decode, table.concat(content, '\n'))
      if ok and config and config.optional_plugins then
        return config.optional_plugins
      end
    end
  end
  return {}
end

-- Save plugin configuration
local function save_config(new_config)
  local config_path = nde_data_dir .. "/plugins.json"
  
  -- Create pretty-printed JSON manually for better readability
  local json_lines = { "{" }
  table.insert(json_lines, '  "optional_plugins": {')
  
  -- Sort keys for consistent output
  local sorted_keys = {}
  for key in pairs(new_config) do
    table.insert(sorted_keys, key)
  end
  table.sort(sorted_keys)
  
  -- Add each plugin with proper formatting
  for i, key in ipairs(sorted_keys) do
    local value = new_config[key] and "true" or "false"
    local comma = i < #sorted_keys and "," or ""
    table.insert(json_lines, '    "' .. key .. '": ' .. value .. comma)
  end
  
  table.insert(json_lines, '  }')
  table.insert(json_lines, '}')
  
  local json_content = table.concat(json_lines, '\n')
  
  local file = io.open(config_path, "w")
  if file then
    file:write(json_content)
    file:close()
    vim.notify("🎉 Plugin configuration saved! Restart nvim to apply changes.", vim.log.levels.INFO)
    return true
  else
    vim.notify("❌ Failed to open file for writing: " .. config_path, vim.log.levels.ERROR)
    return false
  end
end

-- Show the UI
function M.show()
  local config = get_current_config()
  local plugin_manager = require("config.plugin-manager")
  
  local menu_items = {}
  
  -- Add core plugins as read-only items
  table.insert(menu_items, Menu.separator("✨ CORE PLUGINS (Always Enabled) ✨"))
  
  -- Sort core plugins alphabetically
  local core_plugins_sorted = {}
  for _, core_plugin_path in ipairs(plugin_manager.core_plugins) do
    local plugin_name = core_plugin_path:match("/([^/]+)$")
    if plugin_name then
      table.insert(core_plugins_sorted, plugin_name)
    end
  end
  table.sort(core_plugins_sorted)
  
  for _, plugin_name in ipairs(core_plugins_sorted) do
    table.insert(menu_items, Menu.item("🔒 [CORE] " .. plugin_name, { plugin = plugin_name, enabled = true, core = true }))
  end
  
  -- Separate enabled and disabled plugins
  local enabled_plugins = {}
  local disabled_plugins = {}
  
  for plugin, enabled in pairs(config) do
    if enabled then
      table.insert(enabled_plugins, plugin)
    else
      table.insert(disabled_plugins, plugin)
    end
  end
  
  -- Sort both lists alphabetically
  table.sort(enabled_plugins)
  table.sort(disabled_plugins)
  
  -- Add enabled plugins section
  if #enabled_plugins > 0 then
    table.insert(menu_items, Menu.separator("✅ ENABLED PLUGINS ✅"))
    for _, plugin in ipairs(enabled_plugins) do
      table.insert(menu_items, Menu.item("✅ [ENABLED] " .. plugin, { plugin = plugin, enabled = true, core = false }))
    end
  end
  
  -- Add disabled plugins section
  if #disabled_plugins > 0 then
    table.insert(menu_items, Menu.separator("⭕ DISABLED PLUGINS ⭕"))
    for _, plugin in ipairs(disabled_plugins) do
      table.insert(menu_items, Menu.item("⭕ [DISABLED] " .. plugin, { plugin = plugin, enabled = false, core = false }))
    end
  end
  
  -- Show message if no optional plugins
  if #enabled_plugins == 0 and #disabled_plugins == 0 then
    table.insert(menu_items, Menu.separator("🎉 No optional plugins configured"))
  end
  
  local menu = Menu({
    position = "50%",
    size = {
      width = 80,
      height = 20,
    },
    border = {
      style = "rounded",
      text = {
        top = " 🔧 NDE Plugin Manager ",
        top_align = "center",
        bottom = " Press <Enter> to toggle, q to quit ",
        bottom_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  }, {
    lines = menu_items,
    keymap = {
      focus_next = { "j", "<Down>" },
      focus_prev = { "k", "<Up>" },
      close = { "<Esc>", "q" },
      submit = { "<CR>" },
    },
    on_submit = function(item)
      -- Skip if this is a separator (no plugin field)
      if not item.plugin then
        return
      end
      
      -- Don't allow toggling core plugins
      if item.core then
        vim.notify("🔒 Core plugins are always enabled and cannot be disabled!", vim.log.levels.INFO)
        return
      end
      
      -- Toggle plugin state
      local new_state = not item.enabled
      
      -- Get fresh config to make sure we have the latest state
      local current_config = get_current_config()
      
      -- Update the config
      current_config[item.plugin] = new_state
      
      -- Save the updated config
      local success = save_config(current_config)
      
      if success then
        vim.notify("✅ Successfully toggled " .. item.plugin .. " to " .. (new_state and "enabled" or "disabled"), vim.log.levels.INFO)
        
        -- Show restart confirmation (the menu will be closed in the restart confirmation)
        vim.defer_fn(function()
          M.show_restart_confirmation()
        end, 100)
      else
        vim.notify("❌ Failed to save changes for " .. item.plugin, vim.log.levels.ERROR)
        return
      end
    end,
  })

  menu:mount()
end

-- Show restart confirmation after plugin toggle
function M.show_restart_confirmation()
  local menu_items = {
    Menu.item("🔄 Plugin configuration changed!"),
    Menu.separator(""),
    Menu.item("✅ Restart nvim now (recommended)"),
    Menu.item("🔧 Continue and restart later"),
    Menu.item("📋 Back to plugin manager"),
  }
  
  local restart_menu = Menu({
    position = "50%",
    size = {
      width = 60,
      height = 8,
    },
    border = {
      style = "rounded",
      text = {
        top = " 🔄 Restart Required ",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  }, {
    lines = menu_items,
    keymap = {
      focus_next = { "j", "<Down>" },
      focus_prev = { "k", "<Up>" },
      close = { "<Esc>", "q" },
      submit = { "<CR>" },
    },
    on_submit = function(item)
      if not item or not item.text then
        return
      end
      
      if item.text:match("Restart nvim now") then
        -- Restart nvim
        vim.notify("🔄 Restarting nvim...", vim.log.levels.INFO)
        vim.defer_fn(function()
          vim.cmd("qall")
        end, 500)
      elseif item.text:match("Continue and restart later") then
        vim.notify("📝 Remember to restart nvim to apply plugin changes!", vim.log.levels.WARN)
        -- Close dialog
      elseif item.text:match("Back to plugin manager") then
        -- Reopen plugin manager
        vim.defer_fn(function()
          M.show()
        end, 100)
      end
    end,
    on_close = function()
      -- Default action: remind to restart
      vim.notify("📝 Remember to restart nvim to apply plugin changes!", vim.log.levels.WARN)
    end,
  })
  
  restart_menu:mount()
end

return M

