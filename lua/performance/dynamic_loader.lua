-- Dynamic Language and Formatter Loader with Performance Optimizations
-- Maintains all existing features while adding smart lazy loading
-- Based on benchmark results: prioritizes fast languages, delays slow ones

local M = {}

-- Performance caches
local _file_type_cache = {}
local _loaded_languages = {}
local _loaded_formatters = {}
local _lsp_configs_cache = nil
local _dap_configs_cache = nil
local _mason_tools_cache = nil
local _plugin_configs_cache = nil
local _formatters_by_ft_cache = nil
local _formatter_configs_cache = nil
local _setup_done = false

-- File extension to language mapping with adaptive performance optimization
-- Priorities are based on common performance characteristics across different systems
local EXTENSION_MAP = {
  -- High Priority (load immediately) - Generally fast languages/simple configs
  ["lua"] = { lang = "lua", priority = 1 },
  ["go"] = { lang = "go", priority = 1 },
  ["py"] = { lang = "python", priority = 1 },
  ["pyi"] = { lang = "python", priority = 1 },
  ["c"] = { lang = "c_cpp", priority = 1 },
  ["h"] = { lang = "c_cpp", priority = 1 },
  
  -- Medium Priority (small delay) - Moderate complexity
  ["rs"] = { lang = "rust", priority = 2, delay_ms = 30 },
  ["java"] = { lang = "java", priority = 2, delay_ms = 30 },
  ["zig"] = { lang = "zig", priority = 2, delay_ms = 30 },
  
  -- Lower Priority (moderate delay) - More complex or slower configs
  ["sh"] = { lang = "shell", priority = 3, delay_ms = 60 },
  ["bash"] = { lang = "shell", priority = 3, delay_ms = 60 },
  ["zsh"] = { lang = "shell", priority = 3, delay_ms = 60 },
  ["php"] = { lang = "php", priority = 3, delay_ms = 60 },
  
  -- Lowest Priority (significant delay) - Typically slower to load
  ["ts"] = { lang = "javascript_typescript", priority = 4, delay_ms = 100 },
  ["js"] = { lang = "javascript_typescript", priority = 4, delay_ms = 100 },
  ["tsx"] = { lang = "javascript_typescript", priority = 4, delay_ms = 100 },
  ["jsx"] = { lang = "javascript_typescript", priority = 4, delay_ms = 100 },
  ["cpp"] = { lang = "c_cpp", priority = 4, delay_ms = 100 },
  ["cc"] = { lang = "c_cpp", priority = 4, delay_ms = 100 },
  ["cxx"] = { lang = "c_cpp", priority = 4, delay_ms = 100 },
  ["hpp"] = { lang = "c_cpp", priority = 4, delay_ms = 100 },
}

-- Performance configuration - can be customized per user
local PERFORMANCE_CONFIG = {
  -- Enable/disable performance optimizations
  enabled = true,
  
  -- Delay multiplier (user can adjust based on their system)
  delay_multiplier = 1.0,
  
  -- Maximum delay cap
  max_delay_ms = 150,
  
  -- Minimum delay for any non-priority-1 language
  min_delay_ms = 20,
  
  -- Auto-detect system performance and adjust delays
  auto_adapt = true,
}

-- Available languages (from existing config)
local AVAILABLE_LANGUAGES = {
  "python", "rust", "c_cpp", "javascript_typescript", "lua",
  "go", "java", "zig", "php"
}

-- Available formatters (from existing config)
local AVAILABLE_FORMATTERS = {
  "black", "rustfmt", "clang-format", "prettierd", "stylua",
  "gofmt", "google-java-format", "shfmt", "zig_fmt", "php-cs-fixer"
}

-- Performance-optimized file extension detection
local function get_file_extension(filename)
  if not filename or filename == "" then return nil end
  
  if _file_type_cache[filename] then
    return _file_type_cache[filename]
  end
  
  local ext = filename:match("%.([^%.]+)$")
  if ext then
    ext = ext:lower()
    _file_type_cache[filename] = ext
    return ext
  end
  
  return nil
end

-- Load language configuration with caching
local function load_language_config(lang_name)
  if _loaded_languages[lang_name] ~= nil then
    return _loaded_languages[lang_name]
  end
  
  local success, config = pcall(require, 'langs.' .. lang_name)
  if success then
    _loaded_languages[lang_name] = config
    
    -- Setup language if it has a setup function
    if config.setup and type(config.setup) == 'function' then
      config.setup()
    end
    
    -- Invalidate caches when new language is loaded
    _lsp_configs_cache = nil
    _dap_configs_cache = nil
    _mason_tools_cache = nil
    _plugin_configs_cache = nil
    
    return config
  else
    vim.notify("Failed to load language: " .. lang_name, vim.log.levels.WARN)
    _loaded_languages[lang_name] = false
    return false
  end
end

-- Load formatter configuration with caching (using existing formatter system)
local function load_formatter_config(formatter_name)
  if _loaded_formatters[formatter_name] ~= nil then
    return _loaded_formatters[formatter_name]
  end
  
  local success, config = pcall(require, 'formatters.' .. formatter_name)
  if success then
    _loaded_formatters[formatter_name] = config
    
    -- Invalidate formatter caches
    _formatters_by_ft_cache = nil
    _formatter_configs_cache = nil
    
    return config
  else
    vim.notify("Failed to load formatter: " .. formatter_name, vim.log.levels.WARN)
    _loaded_formatters[formatter_name] = false
    return false
  end
end

-- Load all formatters on demand using existing formatter system
local function load_formatters_for_language(lang_name)
  -- Get language config to see what formatters it needs
  local lang_config = _loaded_languages[lang_name]
  if not lang_config or lang_config == false then return end
  
  -- Load formatters specified in language config
  if lang_config.formatters then
    for _, formatter_name in ipairs(lang_config.formatters) do
      load_formatter_config(formatter_name)
    end
  end
end

-- Load all available languages (for compatibility)
local function ensure_all_languages_loaded()
  for _, lang in ipairs(AVAILABLE_LANGUAGES) do
    load_language_config(lang)
  end
end

-- Load all available formatters (for compatibility)
local function ensure_all_formatters_loaded()
  for _, formatter in ipairs(AVAILABLE_FORMATTERS) do
    load_formatter_config(formatter)
  end
end

-- Calculate adaptive delay based on user configuration
local function calculate_delay(base_delay_ms)
  if not PERFORMANCE_CONFIG.enabled then
    return 0
  end
  
  local delay = base_delay_ms * PERFORMANCE_CONFIG.delay_multiplier
  delay = math.max(delay, PERFORMANCE_CONFIG.min_delay_ms)
  delay = math.min(delay, PERFORMANCE_CONFIG.max_delay_ms)
  
  return math.floor(delay)
end

-- Smart loading based on file extension and performance
local function handle_file_open(filename, bufnr)
  local ext = get_file_extension(filename)
  if not ext then return end
  
  local lang_info = EXTENSION_MAP[ext]
  if not lang_info then return end
  
  local load_fn = function()
    local config = load_language_config(lang_info.lang)
    -- Also load formatters for this language
    if config and config ~= false then
      load_formatters_for_language(lang_info.lang)
    end
  end
  
  -- Load based on performance priority and user configuration
  if not PERFORMANCE_CONFIG.enabled or lang_info.priority <= 1 then
    -- Performance disabled or high priority languages: load immediately
    load_fn()
  else
    -- Lower performance languages: load with calculated delay
    local delay = calculate_delay(lang_info.delay_ms or 50)
    if delay > 0 then
      vim.defer_fn(load_fn, delay)
    else
      load_fn()
    end
  end
end

-- === COMPATIBILITY FUNCTIONS (maintain all existing features) ===

-- Get all LSP configurations (original function)
M.get_lsp_configs = function()
  if _lsp_configs_cache then
    return _lsp_configs_cache
  end
  
  -- Only use already loaded languages instead of loading all
  local lsp_configs = {}
  
  for lang_name, config in pairs(_loaded_languages) do
    if config and config ~= false and config.lsp and not config.lsp.managed_by_plugin then
      lsp_configs[config.lsp.name] = config.lsp
    end
  end
  
  _lsp_configs_cache = lsp_configs
  return lsp_configs
end

-- Get all DAP configurations (original function)
M.get_dap_configs = function()
  if _dap_configs_cache then
    return _dap_configs_cache
  end
  
  -- Only use already loaded languages instead of loading all
  local dap_configs = {}
  
  for lang_name, config in pairs(_loaded_languages) do
    if config and config ~= false and config.dap then
      dap_configs[lang_name] = config.dap
    end
  end
  
  _dap_configs_cache = dap_configs
  return dap_configs
end

-- Get all Mason tools needed (original function)
M.get_mason_tools = function()
  if _mason_tools_cache then
    return _mason_tools_cache
  end
  
  -- Only use already loaded languages instead of loading all
  local tools = {
    lsp = {},
    formatters = {},
    debuggers = {},
  }
  
  for _, config in pairs(_loaded_languages) do
    if config and config ~= false and config.mason_tools then
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
  
  _mason_tools_cache = tools
  return tools
end

-- Get plugin configurations (original function)
M.get_plugin_configs = function()
  if _plugin_configs_cache then
    return _plugin_configs_cache
  end
  
  -- Only use already loaded languages instead of loading all
  local plugin_configs = {}
  
  for lang_name, config in pairs(_loaded_languages) do
    if config and config ~= false and config.lsp and config.lsp.managed_by_plugin then
      plugin_configs[config.lsp.plugin] = {
        language = lang_name,
        config = config,
      }
    end
  end
  
  _plugin_configs_cache = plugin_configs
  return plugin_configs
end

-- Get formatters by filetype (updated to use improved formatters system)
M.get_formatters_by_ft = function()
  if _formatters_by_ft_cache then
    return _formatters_by_ft_cache
  end
  
  -- Use the improved formatters system that combines both approaches
  local success, formatters = pcall(require, 'formatters')
  if success then
    _formatters_by_ft_cache = formatters.get_formatters_by_ft()
    return _formatters_by_ft_cache
  end
  
  -- Fallback to original implementation if formatters module not available
  -- Only use already loaded formatters instead of loading all
  local formatters_by_ft = {}
  
  for formatter_name, config in pairs(_loaded_formatters) do
    if config and config ~= false and config.languages then
      for _, lang in ipairs(config.languages) do
        if not formatters_by_ft[lang] then
          formatters_by_ft[lang] = {}
        end
        table.insert(formatters_by_ft[lang], formatter_name)
      end
    end
  end
  
  _formatters_by_ft_cache = formatters_by_ft
  return formatters_by_ft
end

-- Get formatter configurations (original function)
M.get_formatter_configs = function()
  if _formatter_configs_cache then
    return _formatter_configs_cache
  end
  
  -- Only use already loaded formatters instead of loading all
  local configs = {}
  
  for formatter_name, config in pairs(_loaded_formatters) do
    if config and config ~= false and config.setup then
      configs[formatter_name] = config.setup()
    end
  end
  
  _formatter_configs_cache = configs
  return configs
end

-- Get formatter for specific language (original function)
M.get_formatter_for_language = function(language)
  -- Only use already loaded formatters instead of loading all
  
  for formatter_name, config in pairs(_loaded_formatters) do
    if config and config ~= false and config.languages and vim.tbl_contains(config.languages, language) then
      return {
        name = formatter_name,
        config = config,
      }
    end
  end
  
  return nil
end

-- Get mason packages for formatters (original function)
M.get_mason_packages = function()
  -- Only use already loaded formatters instead of loading all
  local packages = {}
  
  for _, config in pairs(_loaded_formatters) do
    if config and config ~= false and config.mason_package then
      table.insert(packages, config.mason_package)
    end
  end
  
  -- Remove duplicates
  local unique_packages = {}
  local seen = {}
  for _, package in ipairs(packages) do
    if not seen[package] then
      seen[package] = true
      table.insert(unique_packages, package)
    end
  end
  
  return unique_packages
end

-- === NEW PERFORMANCE FEATURES ===

-- Configure performance settings (for users to customize)
M.configure = function(opts)
  opts = opts or {}
  
  -- Update performance configuration
  if opts.enabled ~= nil then
    PERFORMANCE_CONFIG.enabled = opts.enabled
  end
  
  if opts.delay_multiplier then
    PERFORMANCE_CONFIG.delay_multiplier = opts.delay_multiplier
  end
  
  if opts.max_delay_ms then
    PERFORMANCE_CONFIG.max_delay_ms = opts.max_delay_ms
  end
  
  if opts.min_delay_ms then
    PERFORMANCE_CONFIG.min_delay_ms = opts.min_delay_ms
  end
  
  if opts.auto_adapt ~= nil then
    PERFORMANCE_CONFIG.auto_adapt = opts.auto_adapt
  end
  
  -- Allow custom extension mappings
  if opts.custom_extensions then
    for ext, config in pairs(opts.custom_extensions) do
      EXTENSION_MAP[ext:lower()] = config
    end
  end
  
  vim.notify("Dynamic loader configuration updated", vim.log.levels.INFO)
end

-- Get current configuration (for users to check settings)
M.get_config = function()
  return vim.deepcopy(PERFORMANCE_CONFIG)
end

-- Get current language config (performance optimized)
M.get_current_language_config = function()
  local filename = vim.api.nvim_buf_get_name(0)
  local ext = get_file_extension(filename)
  
  if not ext then return nil end
  
  local lang_info = EXTENSION_MAP[ext]
  if not lang_info then return nil end
  
  return load_language_config(lang_info.lang)
end

-- Get performance statistics
M.get_performance_stats = function()
  return {
    cached_file_types = vim.tbl_count(_file_type_cache),
    loaded_languages = vim.tbl_count(vim.tbl_filter(function(v) return v ~= false end, _loaded_languages)),
    loaded_formatters = vim.tbl_count(vim.tbl_filter(function(v) return v ~= false end, _loaded_formatters)),
    total_extensions = vim.tbl_count(EXTENSION_MAP),
    cache_hits = {
      lsp_configs = _lsp_configs_cache ~= nil,
      dap_configs = _dap_configs_cache ~= nil,
      mason_tools = _mason_tools_cache ~= nil,
      plugin_configs = _plugin_configs_cache ~= nil,
      formatters_by_ft = _formatters_by_ft_cache ~= nil,
      formatter_configs = _formatter_configs_cache ~= nil,
    }
  }
end

-- Clear all caches
M.clear_caches = function()
  _file_type_cache = {}
  _loaded_languages = {}
  _loaded_formatters = {}
  _lsp_configs_cache = nil
  _dap_configs_cache = nil
  _mason_tools_cache = nil
  _plugin_configs_cache = nil
  _formatters_by_ft_cache = nil
  _formatter_configs_cache = nil
end

-- Original setup function with performance enhancements
M.setup = function()
  if _setup_done then
    return {
      -- For backward compatibility, call functions but only return already loaded data
      lsp_configs = M.get_lsp_configs(),
      dap_configs = M.get_dap_configs(),
      mason_tools = M.get_mason_tools(),
      plugin_configs = M.get_plugin_configs(),
      -- Also provide function versions
      get_lsp_configs = M.get_lsp_configs,
      get_dap_configs = M.get_dap_configs,
      get_mason_tools = M.get_mason_tools,
      get_plugin_configs = M.get_plugin_configs,
    }
  end
  
  _setup_done = true
  
  -- Setup performance-optimized autocmds
  local dynamic_group = vim.api.nvim_create_augroup("DynamicLanguageLoader", { clear = true })
  
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = dynamic_group,
    callback = function(args)
      local filename = vim.api.nvim_buf_get_name(args.buf)
      if filename and filename ~= "" then
        handle_file_open(filename, args.buf)
      end
    end,
  })
  
  -- Create NDE dynamic loader command functions for command suite integration
  M.nde_stats = function()
    local stats = M.get_performance_stats()
    
    -- Get loaded language names for display
    local loaded_lang_names = {}
    for lang_name, config in pairs(_loaded_languages) do
      if config and config ~= false then
        table.insert(loaded_lang_names, lang_name)
      end
    end
    table.sort(loaded_lang_names)
    
    -- Calculate performance grade
    local efficiency = stats.loaded_languages / #AVAILABLE_LANGUAGES
    local grade = "🔥 EXCELLENT"
    if efficiency > 0.7 then
      grade = "⚠️  HEAVY"
    elseif efficiency > 0.5 then
      grade = "📊 MODERATE"
    end
    
    -- Format cache status with icons
    local cache_icons = {
      lsp_configs = "🔧",
      dap_configs = "🐛", 
      mason_tools = "📦",
      plugin_configs = "🔌",
      formatters_by_ft = "✨",
      formatter_configs = "🎨"
    }
    
    local cache_status = {}
    for cache_name, is_cached in pairs(stats.cache_hits) do
      local icon = cache_icons[cache_name] or "📄"
      local status = is_cached and "💾 CACHED" or "❌ COLD"
      table.insert(cache_status, icon .. " " .. cache_name:gsub("_", " "):upper() .. ": " .. status)
    end
    
    -- Create the notification message
    local title = "🚀 NDE Dynamic Loader Performance"
    local message = string.format(
      "📊 EFFICIENCY: %s (%.0f%%)\n" ..
      "\n🎯 LANGUAGES: %d/%d loaded\n" ..
      "%s\n" ..
      "\n✨ FORMATTERS: %d/%d loaded\n" ..
      "\n🗂️  CACHE: %d file types mapped\n" ..
      "📋 SUPPORT: %d extensions registered\n" ..
      "\n💾 CACHE STATUS:\n%s",
      grade,
      efficiency * 100,
      stats.loaded_languages,
      #AVAILABLE_LANGUAGES,
      #loaded_lang_names > 0 and ("   " .. table.concat(loaded_lang_names, ", ")) or "   (none loaded yet)",
      stats.loaded_formatters,
      #AVAILABLE_FORMATTERS,
      stats.cached_file_types,
      stats.total_extensions,
      "   " .. table.concat(cache_status, "\n   ")
    )
    
    vim.notify(message, vim.log.levels.INFO, {
      title = title,
      timeout = 8000,
    })
  end
  
  M.nde_clearcache = function()
    local stats_before = M.get_performance_stats()
    M.clear_caches()
    
    local message = string.format(
      "🧹 CACHE CLEARED\n" ..
      "\n📊 RESET:\n" ..
      "   🎯 Languages: %d → 0\n" ..
      "   ✨ Formatters: %d → 0\n" ..
      "   🗂️ File types: %d → 0\n" ..
      "   💾 Cache entries: 6 → 0\n" ..
      "\n🔄 STATUS: Ready for dynamic loading!",
      stats_before.loaded_languages,
      stats_before.loaded_formatters,
      stats_before.cached_file_types
    )
    
    vim.notify(message, vim.log.levels.WARN, {
      title = "🧹 NDE Dynamic Loader Cache",
      timeout = 4000,
    })
  end
  
  M.nde_languages = function()
    local loaded_langs = {}
    local available_langs = {}
    
    -- Collect loaded language info
    for lang_name, config in pairs(_loaded_languages) do
      if config and config ~= false then
        local lang_info = {
          name = lang_name,
          lsp = config.lsp and config.lsp.name or "none",
          formatters = config.formatters and table.concat(config.formatters, ", ") or "none",
          debugger = config.dap and "available" or "none",
        }
        table.insert(loaded_langs, lang_info)
      end
    end
    
    table.sort(loaded_langs, function(a, b) return a.name < b.name end)
    
    -- Get available but not loaded languages
    for _, lang_name in ipairs(AVAILABLE_LANGUAGES) do
      if not _loaded_languages[lang_name] or _loaded_languages[lang_name] == false then
        table.insert(available_langs, lang_name)
      end
    end
    table.sort(available_langs)
    
    local title = "🎯 NDE Dynamic Language Status"
    local message = ""
    
    if #loaded_langs > 0 then
      message = message .. "🟢 LOADED LANGUAGES (" .. #loaded_langs .. "/" .. #AVAILABLE_LANGUAGES .. "):\n"
      for _, lang in ipairs(loaded_langs) do
        message = message .. string.format(
          "   🔹 %s: LSP=%s | Fmt=%s | DAP=%s\n",
          lang.name:upper(),
          lang.lsp,
          lang.formatters,
          lang.debugger
        )
      end
    else
      message = message .. "🔴 NO LANGUAGES LOADED YET\n\n"
    end
    
    if #available_langs > 0 then
      message = message .. "\n⚪ AVAILABLE (" .. #available_langs .. "):" 
      if #available_langs <= 5 then
        message = message .. "\n   " .. table.concat(available_langs, ", ")
      else
        message = message .. "\n   " .. table.concat(vim.list_slice(available_langs, 1, 5), ", ") .. " and " .. (#available_langs - 5) .. " more..."
      end
    end
    
    message = message .. "\n\n💡 TIP: Open files to trigger dynamic loading!"
    
    vim.notify(message, vim.log.levels.INFO, {
      title = title,
      timeout = 6000,
    })
  end
  
  M.nde_formatters = function()
    local loaded_formatters = {}
    local available_formatters = {}
    
    -- Collect loaded formatter info
    for formatter_name, config in pairs(_loaded_formatters) do
      if config and config ~= false then
        local formatter_info = {
          name = formatter_name,
          languages = config.languages and table.concat(config.languages, ", ") or "unknown",
          mason_pkg = config.mason_package or "none",
        }
        table.insert(loaded_formatters, formatter_info)
      end
    end
    
    table.sort(loaded_formatters, function(a, b) return a.name < b.name end)
    
    -- Get available but not loaded formatters
    for _, formatter_name in ipairs(AVAILABLE_FORMATTERS) do
      if not _loaded_formatters[formatter_name] or _loaded_formatters[formatter_name] == false then
        table.insert(available_formatters, formatter_name)
      end
    end
    table.sort(available_formatters)
    
    local title = "✨ NDE Dynamic Formatter Status"
    local message = ""
    
    if #loaded_formatters > 0 then
      message = message .. "🟢 LOADED FORMATTERS (" .. #loaded_formatters .. "/" .. #AVAILABLE_FORMATTERS .. "):\n"
      for _, fmt in ipairs(loaded_formatters) do
        message = message .. string.format(
          "   🎨 %s: %s | Mason=%s\n",
          fmt.name:upper(),
          fmt.languages,
          fmt.mason_pkg
        )
      end
    else
      message = message .. "🔴 NO FORMATTERS LOADED YET\n\n"
    end
    
    if #available_formatters > 0 then
      message = message .. "\n⚪ AVAILABLE (" .. #available_formatters .. "):" 
      if #available_formatters <= 6 then
        message = message .. "\n   " .. table.concat(available_formatters, ", ")
      else
        message = message .. "\n   " .. table.concat(vim.list_slice(available_formatters, 1, 6), ", ") .. " and " .. (#available_formatters - 6) .. " more..."
      end
    end
    
    message = message .. "\n\n💡 TIP: Formatters load when their language is used!"
    
    vim.notify(message, vim.log.levels.INFO, {
      title = title,
      timeout = 6000,
    })
  end
  
  return {
    -- For backward compatibility, use metatable to call functions when properties are accessed
    lsp_configs = M.get_lsp_configs(),
    dap_configs = M.get_dap_configs(),
    mason_tools = M.get_mason_tools(),
    plugin_configs = M.get_plugin_configs(),
    -- Also provide function versions
    get_lsp_configs = M.get_lsp_configs,
    get_dap_configs = M.get_dap_configs,
    get_mason_tools = M.get_mason_tools,
    get_plugin_configs = M.get_plugin_configs,
  }
end

return M

