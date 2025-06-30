local M = {}

-- Default configuration
local default_config = {
  -- Languages to install immediately (optional)
  languages = {},
  
  -- Prompt settings
  prompt = {
    enabled = true,        -- Show prompts for new languages
    auto_install = false,  -- Ask before installing
  },
  
  -- Tool integration
  tools = {
    mason = { auto_update = true },
    lsp = { auto_attach = true },
    diagnostics = { merge_sources = true },
  },
  
}

-- Store the configuration
M.config = {}

-- Setup function
function M.setup(opts)
  -- Merge user config with defaults
  M.config = vim.tbl_deep_extend("force", default_config, opts or {})

  -- Create Mason command immediately but defer actual setup
  vim.api.nvim_create_user_command('Mason', function()
    M.ensure_initialized()
    require('mason.ui').open()
  end, { desc = 'Open Mason' })
  
  -- Only setup essential autocmds for file detection (lightweight)
  require("optispec.core.autocmds").setup(M.config)
  
  -- Lazy-load everything else when needed
  _G.OptiSpec = _G.OptiSpec or {}
  _G.OptiSpec.config = M.config
  _G.OptiSpec.initialized = false
  
  -- Pre-install specified languages (these bypass the prompt system)
  if M.config.languages and #M.config.languages > 0 then
    M.ensure_initialized()
    require("optispec.core.installer").install_languages(M.config.languages)
  end
end

-- Ensure all modules are initialized (called when first needed)
function M.ensure_initialized()
  if _G.OptiSpec.initialized then
    return
  end
  
  -- Initialize core modules
  require("optispec.core.init").setup(M.config)
  
  -- Setup UI
  require("optispec.ui.init").setup(M.config)
  
  _G.OptiSpec.initialized = true
end

-- Public API functions
function M.install(language)
  M.ensure_initialized()
  require("optispec.core.installer").install_language(language)
end

function M.remove(language)
  M.ensure_initialized()
  require("optispec.core.installer").remove_language(language)
end

function M.status()
  M.ensure_initialized()
  require("optispec.ui.status").show()
end

function M.update()
  M.ensure_initialized()
  require("optispec.core.installer").update_all()
end

function M.browse()
  M.ensure_initialized()
  require("optispec.ui.browser").show()
end

-- Collect all plugins from core modules
function M.get_plugins()
  local plugins = {}
  
  -- Add plugins from each core module
  local core_modules = {
    "mason",
    "lsp", 
    "formatters",
    "linters",
    "debugger",
    "treesitter",
    "diagnostics"
  }
  
  for _, module_name in ipairs(core_modules) do
    local ok, module = pcall(require, "optispec.core." .. module_name)
    if ok and module.plugins then
      for _, plugin in ipairs(module.plugins) do
        table.insert(plugins, plugin)
      end
    end
  end
  
  return plugins
end

return M
