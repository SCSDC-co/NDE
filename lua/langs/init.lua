local M = {}

-- Available language modules
local languages = {
  "python",
  "rust", 
  "c_cpp",
  "javascript_typescript",
  "lua",
  "go",
  "java",
}

-- Cache for loaded configurations
local _cached_configs = nil
local _setup_done = false

-- Load all language configurations
local function load_languages()
  if _cached_configs then
    return _cached_configs
  end
  
  local configs = {}
  for _, lang in ipairs(languages) do
    local success, config = pcall(require, 'langs.' .. lang)
    if success then
      configs[lang] = config
      -- Setup language-specific configurations
      if config.setup then
        config.setup()
      end
    else
      vim.notify("Failed to load language: " .. lang, vim.log.levels.WARN)
    end
  end
  
  _cached_configs = configs
  return configs
end

-- Get all LSP configurations
M.get_lsp_configs = function()
  local lang_configs = load_languages()
  local lsp_configs = {}
  
  for lang_name, config in pairs(lang_configs) do
    if config.lsp and not config.lsp.managed_by_plugin then
      lsp_configs[config.lsp.name] = config.lsp
    end
  end
  
  return lsp_configs
end

-- Get all DAP configurations
M.get_dap_configs = function()
  local lang_configs = load_languages()
  local dap_configs = {}
  
  for lang_name, config in pairs(lang_configs) do
    if config.dap then
      dap_configs[lang_name] = config.dap
    end
  end
  
  return dap_configs
end

-- Get all Mason tools needed
M.get_mason_tools = function()
  local lang_configs = load_languages()
  local tools = {
    lsp = {},
    formatters = {},
    debuggers = {},
  }
  
  for _, config in pairs(lang_configs) do
    if config.mason_tools then
      if config.mason_tools.lsp then
        vim.list_extend(tools.lsp, config.mason_tools.lsp)
      end
      if config.mason_tools.formatters then
        vim.list_extend(tools.formatters, config.mason_tools.formatters)
      end
      if config.mason_tools.debuggers then
        vim.list_extend(tools.debuggers, config.mason_tools.debuggers)
      end
    end
  end
  
  -- Remove duplicates
  for category, tool_list in pairs(tools) do
    local unique_tools = {}
    local seen = {}
    for _, tool in ipairs(tool_list) do
      if not seen[tool] then
        seen[tool] = true
        table.insert(unique_tools, tool)
      end
    end
    tools[category] = unique_tools
  end
  
  return tools
end

-- Get plugin configurations that need special handling
M.get_plugin_configs = function()
  local lang_configs = load_languages()
  local plugin_configs = {}
  
  for lang_name, config in pairs(lang_configs) do
    if config.lsp and config.lsp.managed_by_plugin then
      plugin_configs[config.lsp.plugin] = {
        language = lang_name,
        config = config,
      }
    end
  end
  
  return plugin_configs
end

-- Setup all languages
M.setup = function()
  local lang_configs = load_languages()
  
  if not _setup_done then
    _setup_done = true
  end
  
  return {
    lsp_configs = M.get_lsp_configs(),
    dap_configs = M.get_dap_configs(),
    mason_tools = M.get_mason_tools(),
    plugin_configs = M.get_plugin_configs(),
  }
end

return M

