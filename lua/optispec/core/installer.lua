local M = {}

-- Install a language and all its tools
function M.install_language(language_name)
  local languages = require("optispec.core.languages")
  local config = languages.get_language_config(language_name)
  
  if not config then
    vim.notify("Language '" .. language_name .. "' not found", vim.log.levels.ERROR)
    return false
  end
  
  vim.notify("Installing " .. language_name .. " development tools...", vim.log.levels.INFO)
  
  -- Install Mason tools
  if config.mason_tools then
    M.install_mason_tools(config.mason_tools)
  end
  
  -- Setup LSP
  if config.lsp then
    M.setup_lsp_server(config.lsp)
  end
  
  -- Install treesitter parsers
  if config.treesitter then
    M.install_treesitter_parsers(config.treesitter)
  end
  
  -- Setup debugger if available
  if config.dap then
    M.setup_debugger(language_name, config.dap)
  end
  
  -- Update JSON tracking status immediately and then schedule periodic updates
  local json_tracker = require("optispec.core.json_tracker")
  
  -- Initial status update
  json_tracker.update_language_status(language_name)
  
  -- Schedule periodic status checks to catch async installations
  vim.defer_fn(function()
    json_tracker.update_language_status(language_name)
  end, 1000) -- Check after 1 second
  
  vim.defer_fn(function()
    json_tracker.update_language_status(language_name)
  end, 3000) -- Check after 3 seconds
  
  vim.defer_fn(function()
    json_tracker.update_language_status(language_name)
  end, 5000) -- Final check after 5 seconds

  -- Trigger dynamic loading for the current buffer if it matches this language
  vim.schedule(function()
    local current_filetype = vim.bo.filetype
    if current_filetype and current_filetype ~= "" then
      local language_for_ft = languages.get_language_for_filetype(current_filetype)
      if language_for_ft == language_name then
        -- Clear the dynamic loader state for this language so it can be loaded again
        local dynamic_loader = require("optispec.core.dynamic_loader")
        dynamic_loader.force_load_language(language_name)
      end
    end
  end)
  
  vim.notify("✓ " .. language_name .. " tools installed successfully!", vim.log.levels.INFO)
  
  -- Notify user to restart Neovim for changes to take effect
  vim.notify(
    "Language \"" .. language_name .. "\" installed successfully!\n" ..
    "To ensure all LSP servers, formatters, and tools work properly,\n" ..
    "check that Mason installed every tool before restarting! Then restart Neovim.",
    vim.log.levels.INFO
  )
  
  return true
end

-- Install multiple languages
function M.install_languages(language_list)
  for _, language in ipairs(language_list) do
    M.install_language(language)
  end
end

-- Remove a language and its tools
function M.remove_language(language_name)
  local languages = require("optispec.core.languages")
  local config = languages.get_language_config(language_name)
  
  if not config then
    vim.notify("Language '" .. language_name .. "' not found", vim.log.levels.ERROR)
    return false
  end
  
  vim.notify("Removing " .. language_name .. " development tools...", vim.log.levels.INFO)
  
  -- Remove Mason tools
  if config.mason_tools then
    M.remove_mason_tools(config.mason_tools)
  end
  
  -- Remove treesitter parsers
  if config.treesitter then
    M.remove_treesitter_parsers(config.treesitter)
  end
  
  -- Update JSON tracking status
  local json_tracker = require("optispec.core.json_tracker")
  json_tracker.update_language_status(language_name)
  
  -- Schedule a final status check to ensure removal is complete
  vim.defer_fn(function()
    json_tracker.update_language_status(language_name)
  end, 1000)
  
  vim.notify("✓ " .. language_name .. " tools removed successfully!", vim.log.levels.INFO)
  
  -- Notify user to restart Neovim for changes to take effect
  vim.notify(
    "Language \"" .. language_name .. "\" removed successfully!\n" ..
    "To ensure all settings are properly updated,\n" ..
    "check that Mason installed every tool before restarting! Then restart Neovim.",
    vim.log.levels.INFO
  )

  return true
end

-- Install Mason tools for a language
function M.install_mason_tools(mason_tools)
  local mason = _G.OptiSpec.mason
  
  if not mason then
    vim.notify("Mason utilities not available. Please ensure OptiSpec is properly initialized.", vim.log.levels.ERROR)
    return false
  end
  
  for category, tools in pairs(mason_tools) do
    for _, tool in ipairs(tools) do
      if not mason.is_tool_installed(tool) then
        vim.notify("Installing " .. tool .. "...", vim.log.levels.INFO)
        local success = mason.install_tool(tool)
        if not success then
          vim.notify("Failed to install " .. tool, vim.log.levels.WARN)
        end
      end
    end
  end
  
  return true
end

-- Remove Mason tools for a language
function M.remove_mason_tools(mason_tools)
  local mason = _G.OptiSpec.mason
  
  for category, tools in pairs(mason_tools) do
    for _, tool in ipairs(tools) do
      if mason.is_tool_installed(tool) then
        vim.notify("Removing " .. tool .. "...", vim.log.levels.INFO)
        mason.uninstall_tool(tool)
      end
    end
  end
end

-- Setup LSP server
function M.setup_lsp_server(lsp_config)
  local lsp = _G.OptiSpec.lsp
  
  if lsp and lsp.setup_server then
    lsp.setup_server(lsp_config.name, lsp_config.settings or {})
  end
end

-- Install treesitter parsers
function M.install_treesitter_parsers(parsers)
  local treesitter = _G.OptiSpec.treesitter
  
  if treesitter and treesitter.install_parsers then
    treesitter.install_parsers(parsers)
  else
    -- Fallback to direct treesitter call
    for _, parser in ipairs(parsers) do
      vim.cmd("TSInstall " .. parser)
    end
  end
end

-- Remove treesitter parsers
function M.remove_treesitter_parsers(parsers)
  local treesitter = _G.OptiSpec.treesitter
  
  if treesitter and treesitter.remove_parsers then
    treesitter.remove_parsers(parsers)
  else
    -- Fallback to direct treesitter call
    for _, parser in ipairs(parsers) do
      vim.cmd("TSUninstall " .. parser)
    end
  end
end

-- Setup debugger configuration
function M.setup_debugger(language_name, dap_config)
  local debugger = _G.OptiSpec.debugger
  
  if debugger and dap_config then
    -- Basic debugger setup - language-specific configs can override this
    debugger.setup_adapter(language_name, dap_config.adapter or {})
    debugger.setup_configuration(language_name, dap_config.configurations or {})
  end
end

-- Update all installed tools
function M.update_all()
  local mason = _G.OptiSpec.mason
  
  if mason then
    mason.update_all()
  end
  
  vim.notify("✓ All tools updated successfully!", vim.log.levels.INFO)
end

-- Get installation status
function M.get_status()
  local languages = require("optispec.core.languages")
  local all_languages = languages.get_all_languages()
  
  local installed = {}
  local available = {}
  
  for _, lang in ipairs(all_languages) do
    if lang.installed then
      table.insert(installed, lang.name)
    else
      table.insert(available, lang.name)
    end
  end
  
  -- Update tracked status
  for _, lang in ipairs(all_languages) do
    local json_tracker = require("optispec.core.json_tracker")
    local status = json_tracker.verify_language_status(lang.name)
    json_tracker.set_language_status(lang.name, status)
  end
  
  return {
    installed = installed,
    available = available,
    total = #all_languages
  }
end

return M
