-- Performance-optimized language loader integration
-- This module wraps the dynamic loader for the langs directory

local dynamic_loader = require('performance.dynamic_loader')
local M = {}

-- Initialize the dynamic loader with performance optimizations
M.setup = function()
  return dynamic_loader.setup()
end

-- Export all the original functions for compatibility
M.get_lsp_configs = dynamic_loader.get_lsp_configs
M.get_dap_configs = dynamic_loader.get_dap_configs
M.get_mason_tools = dynamic_loader.get_mason_tools
M.get_plugin_configs = dynamic_loader.get_plugin_configs

-- Export new performance functions
M.get_current_language_config = dynamic_loader.get_current_language_config
M.get_performance_stats = dynamic_loader.get_performance_stats
M.clear_caches = dynamic_loader.clear_caches

return M

