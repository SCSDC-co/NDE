-- Performance-optimized formatter integration
-- This module provides a performance-aware wrapper around the existing formatter system
-- It dynamically loads formatters based on file types and performance characteristics

local M = {}

-- Import the original formatter system
local original_formatters = require('formatters')
local dynamic_loader = require('performance.dynamic_loader')

-- Cache for current buffer formatter info
local _current_buffer_formatters = {}

-- Performance-optimized formatter detection for current buffer
M.get_current_buffer_formatters = function()
  local bufnr = vim.api.nvim_get_current_buf()
  
  -- Check cache first
  if _current_buffer_formatters[bufnr] then
    return _current_buffer_formatters[bufnr]
  end
  
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if not filename or filename == "" then return {} end
  
  -- Get file extension and corresponding language
  local ext = filename:match("%.([^%.]+)$")
  if not ext then return {} end
  ext = ext:lower()
  
  -- Get current language config from dynamic loader
  local lang_config = dynamic_loader.get_current_language_config()
  if not lang_config or not lang_config.formatters then return {} end
  
  -- Load the specific formatters for this language
  local formatters = {}
  for _, formatter_name in ipairs(lang_config.formatters) do
    local success, formatter_config = pcall(require, 'formatters.' .. formatter_name)
    if success then
      formatters[formatter_name] = formatter_config
    end
  end
  
  _current_buffer_formatters[bufnr] = formatters
  return formatters
end

-- Get formatter configuration for current buffer (performance optimized)
M.get_current_formatter_config = function()
  local formatters = M.get_current_buffer_formatters()
  local configs = {}
  
  for formatter_name, formatter_config in pairs(formatters) do
    if formatter_config.setup then
      configs[formatter_name] = formatter_config.setup()
    end
  end
  
  return configs
end

-- Get formatters by filetype for current session (uses dynamic loading)
M.get_formatters_by_ft = function()
  return dynamic_loader.get_formatters_by_ft()
end

-- Get all formatter configurations (uses dynamic loading)
M.get_formatter_configs = function()
  return dynamic_loader.get_formatter_configs()
end

-- Get mason packages (uses dynamic loading)
M.get_mason_packages = function()
  return dynamic_loader.get_mason_packages()
end

-- Get formatter for specific language (uses dynamic loading)
M.get_formatter_for_language = function(language)
  return dynamic_loader.get_formatter_for_language(language)
end

-- Performance-aware setup function
M.setup = function()
  -- Setup autocmd to clear buffer cache when buffer is deleted
  local formatter_group = vim.api.nvim_create_augroup("PerformanceFormatters", { clear = true })
  
  vim.api.nvim_create_autocmd("BufDelete", {
    group = formatter_group,
    callback = function(args)
      _current_buffer_formatters[args.buf] = nil
    end,
  })
  
  -- For compatibility, also call the original formatters setup
  local original_result = original_formatters.setup()
  
  -- Create performance monitoring command
  vim.api.nvim_create_user_command("FormattersPerformanceStats", function()
    local current_formatters = M.get_current_buffer_formatters()
    local current_count = vim.tbl_count(current_formatters)
    local cached_buffers = vim.tbl_count(_current_buffer_formatters)
    
    print("=== Formatters Performance Stats ===")
    print("Current buffer formatters: " .. current_count)
    print("Cached buffer formatters: " .. cached_buffers)
    
    if current_count > 0 then
      print("\nCurrent buffer formatters:")
      for name, _ in pairs(current_formatters) do
        print("  - " .. name)
      end
    end
  end, { desc = "Show formatters performance statistics" })
  
  return {
    formatters_by_ft = M.get_formatters_by_ft(),
    formatters = M.get_formatter_configs(),
  }
end

-- Clear formatter caches
M.clear_caches = function()
  _current_buffer_formatters = {}
end

return M

