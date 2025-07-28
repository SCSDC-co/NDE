local M = {}

-- Language registry
local languages = {}
local installed_languages = {}

-- Filetype to language mapping
local filetype_map = {}

-- Setup languages module
function M.setup()
  -- Load all built-in language configurations
  M.load_builtin_languages()
  
  -- Store utilities globally
  _G.OptiSpec = _G.OptiSpec or {}
  _G.OptiSpec.languages = {
    get_language_for_filetype = M.get_language_for_filetype,
    is_language_installed = M.is_language_installed,
    register_language = M.register_language,
    get_all_languages = M.get_all_languages,
  }
end

-- Load built-in language configurations
function M.load_builtin_languages()
  -- Load language categories
  require("optispec.languages.web").setup()
  require("optispec.languages.systems").setup()
  require("optispec.languages.scripting").setup()
  require("optispec.languages.config").setup()
  require("optispec.languages.data").setup()
  require("optispec.languages.devops").setup()
  require("optispec.languages.functional").setup()
end

-- Register a language configuration
function M.register_language(name, config)
  languages[name] = config
  
  -- Build filetype mapping
  for _, ft in ipairs(config.filetypes) do
    filetype_map[ft] = name
  end
end

-- Get language for filetype
function M.get_language_for_filetype(filetype)
  return filetype_map[filetype]
end

-- Check if language is installed
function M.is_language_installed(language)
  local json_tracker = require("optispec.core.json_tracker")
  return json_tracker.is_language_installed(language)
end

-- Mark language as installed
function M.mark_language_installed(language)
  installed_languages[language] = true
end

-- Mark language as uninstalled
function M.mark_language_uninstalled(language)
  installed_languages[language] = false
end

-- Get language configuration
function M.get_language_config(language)
  return languages[language]
end

-- Get all language names (without installation status to avoid circular dependency)
function M.get_all_language_names()
  local result = {}
  for name, _ in pairs(languages) do
    table.insert(result, name)
  end
  -- Sort alphabetically
  table.sort(result)
  return result
end

-- Get all available languages
function M.get_all_languages()
  local result = {}
  for name, config in pairs(languages) do
    table.insert(result, {
      name = name,
      config = config,
      installed = M.is_language_installed(name)
    })
  end
  return result
end

return M
