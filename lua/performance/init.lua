-- Main performance module initialization
-- This module sets up the performance-optimized language and formatter loading

local M = {}

-- Import the performance modules
local dynamic_loader = require('performance.dynamic_loader')
local perf_langs = require('performance.langs')
local perf_formatters = require('performance.formatters')

-- Setup function that initializes everything
M.setup = function(opts)
  opts = opts or {}
  
  -- Configure dynamic loader if options provided
  if opts.dynamic_loader then
    dynamic_loader.configure(opts.dynamic_loader)
  end
  
  -- Setup languages with performance optimizations
  local lang_config = perf_langs.setup()
  
  -- Setup formatters with performance optimizations
  local formatter_config = perf_formatters.setup()
  
  -- Notify that performance optimizations are active
  vim.notify("Performance optimizations loaded successfully", vim.log.levels.INFO)
  
  return {
    languages = lang_config,
    formatters = formatter_config,
    dynamic_loader = dynamic_loader,
  }
end

-- Export submodules for direct access
M.dynamic_loader = dynamic_loader
M.langs = perf_langs
M.formatters = perf_formatters

-- Export configuration function
M.configure = dynamic_loader.configure
M.get_stats = dynamic_loader.get_performance_stats
M.clear_caches = dynamic_loader.clear_caches

return M

