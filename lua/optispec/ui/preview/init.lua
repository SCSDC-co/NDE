local M = {}

-- Load all preview modules
local web = require("optispec.ui.preview.web")
local systems = require("optispec.ui.preview.systems")
local scripting = require("optispec.ui.preview.scripting")
local data = require("optispec.ui.preview.data")
local devops = require("optispec.ui.preview.devops")

-- Aggregate all previews
M.previews = {}

-- Add all previews from different categories
for lang, preview in pairs(web.previews) do
  M.previews[lang] = preview
end

for lang, preview in pairs(systems.previews) do
  M.previews[lang] = preview
end

for lang, preview in pairs(scripting.previews) do
  M.previews[lang] = preview
end

for lang, preview in pairs(data.previews) do
  M.previews[lang] = preview
end

for lang, preview in pairs(devops.previews) do
  M.previews[lang] = preview
end

-- Get preview for a specific language
function M.get_preview(language_name)
  return M.previews[language_name] or "-- No preview available for this language --"
end

-- Get all available preview languages
function M.get_available_languages()
  local languages = {}
  for lang, _ in pairs(M.previews) do
    table.insert(languages, lang)
  end
  table.sort(languages)
  return languages
end

return M
