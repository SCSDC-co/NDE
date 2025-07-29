local M = {}

-- Format JSON with proper indentation
function M.format_json(json_string)
	local result = {}
	local indent_level = 0
	local in_string = false
	local escape_next = false
	
	for i = 1, #json_string do
		local char = json_string:sub(i, i)
		
		if escape_next then
			escape_next = false
		elseif char == '\\' and in_string then
			escape_next = true
		elseif char == '"' then
			in_string = not in_string
		elseif not in_string then
			if char == '{' or char == '[' then
				table.insert(result, char)
				indent_level = indent_level + 1
				table.insert(result, '\n' .. string.rep('  ', indent_level))
				goto continue
			elseif char == '}' or char == ']' then
				indent_level = indent_level - 1
				table.insert(result, '\n' .. string.rep('  ', indent_level) .. char)
				goto continue
			elseif char == ',' then
				table.insert(result, char)
				table.insert(result, '\n' .. string.rep('  ', indent_level))
				goto continue
			elseif char == ':' then
				table.insert(result, char)
				-- Add space after colon
				if i < #json_string and json_string:sub(i + 1, i + 1) ~= ' ' then
					table.insert(result, ' ')
				end
				goto continue
			end
		end
		
		table.insert(result, char)
		::continue::
	end
	
	return table.concat(result)
end

-- Default JSON structure
local DEFAULT_JSON = {
	languages = {},
	linters = true
}

-- Cache for JSON data to avoid frequent file reads
local json_cache = nil
local cache_dirty = false

-- Get the JSON file path
local function get_json_path()
	local data_dir = vim.fn.stdpath("data")
	local nde_dir = data_dir .. "/nde"
	local json_path = nde_dir .. "/optispec.json"
	
	-- Ensure directory exists
	if vim.fn.isdirectory(nde_dir) == 0 then
		vim.fn.mkdir(nde_dir, "p")
	end
	
	return json_path
end

-- Read JSON file with error handling
local function read_json_file()
	local json_path = get_json_path()
	
	-- Check if file exists
	if vim.fn.filereadable(json_path) == 0 then
		return DEFAULT_JSON
	end
	
	-- Read file content
	local file = io.open(json_path, "r")
	if not file then
		vim.notify(string.format("OptiSpec Error: Could not read JSON file: %s", json_path), vim.log.levels.ERROR)
		return DEFAULT_JSON
	end
	
	local content = file:read("*all")
	file:close()
	
	if not content or content == "" then
		vim.notify("OptiSpec Error: JSON file is empty, using defaults", vim.log.levels.WARN)
		return DEFAULT_JSON
	end
	
	-- Parse JSON
	local ok, data = pcall(vim.json.decode, content)
	if not ok then
		vim.notify("OptiSpec Error: Invalid JSON format in tracking file, resetting to defaults", vim.log.levels.ERROR)
		return DEFAULT_JSON
	end
	
	return data or DEFAULT_JSON
end

-- Write JSON file with atomic operations
local function write_json_file(data)
	local json_path = get_json_path()
	local temp_path = json_path .. ".tmp"
	
	-- Encode JSON with pretty formatting
	local ok, content = pcall(vim.json.encode, data)
	if not ok then
		vim.notify("OptiSpec Error: Could not encode JSON data for writing", vim.log.levels.ERROR)
		return false
	end
	
	-- Pretty format the JSON
	local formatted_content = M.format_json(content)
	
	-- Write to temporary file first (atomic operation)
	local temp_file = io.open(temp_path, "w")
	if not temp_file then
		vim.notify(string.format("OptiSpec Error: Could not create temporary file: %s", temp_path), vim.log.levels.ERROR)
		return false
	end
	
	local write_ok, write_err = pcall(temp_file.write, temp_file, formatted_content)
	temp_file:close()
	
	if not write_ok then
		vim.notify(string.format("OptiSpec Error: Failed to write JSON content: %s", write_err or "unknown error"), vim.log.levels.ERROR)
		vim.fn.delete(temp_path)
		return false
	end
	
	-- Move temporary file to final location
	local success = vim.fn.rename(temp_path, json_path) == 0
	if not success then
		vim.notify(string.format("OptiSpec Error: Could not move temporary file to: %s", json_path), vim.log.levels.ERROR)
		-- Clean up temp file
		vim.fn.delete(temp_path)
		return false
	end
	
	return true
end

-- Save cache to file if dirty
local function flush_cache()
	if cache_dirty and json_cache then
		if write_json_file(json_cache) then
			cache_dirty = false
			return true
		end
	end
	return false
end

-- Initialize JSON file with all available languages
local function initialize_with_all_languages()
	local languages_module = require("optispec.core.languages")
	-- Get language names without checking installation status to avoid circular dependency
	local all_language_names = languages_module.get_all_language_names()
	
	local initialized_data = {
		languages = {},
		linters = true
	}
	
	-- Add all languages with "none" status by default
	for _, lang_name in ipairs(all_language_names) do
		initialized_data.languages[lang_name] = "none"
	end
	
	vim.notify(string.format("OptiSpec: Initializing JSON with %d languages", #all_language_names), vim.log.levels.INFO)
	return initialized_data
end

-- Load JSON data into cache
local function ensure_cache()
	if json_cache == nil then
		-- Check if file exists, if not initialize with all languages
		local json_path = get_json_path()
		if vim.fn.filereadable(json_path) == 0 then
			-- File doesn't exist, initialize with all languages
			json_cache = initialize_with_all_languages()
			cache_dirty = true
			-- Save immediately
			flush_cache()
		else
			-- File exists, read it
			json_cache = read_json_file()
			-- Handle old format - if languages field doesn't exist, migrate inline
			if not json_cache.languages then
				-- This is the old format, convert it
				local old_data = json_cache
				json_cache = {
					languages = old_data,
					linters = true
				}
				cache_dirty = true
				-- Save the new format immediately
				flush_cache()
			else
				-- Check if we need to add any missing languages
				local languages_module = require("optispec.core.languages")
				local all_language_names = languages_module.get_all_language_names()
				local needs_update = false
				
				for _, lang_name in ipairs(all_language_names) do
					if json_cache.languages[lang_name] == nil then
						json_cache.languages[lang_name] = "none"
						needs_update = true
					end
				end
				
				if needs_update then
					cache_dirty = true
					flush_cache()
				end
			end
		end
	end
end

-- Get language installation status
function M.get_language_status(language_name)
	ensure_cache()
	return json_cache.languages[language_name] or "none"
end

-- Set language installation status
function M.set_language_status(language_name, status)
	-- Validate status
	local valid_statuses = { "none", "partial", "full" }
	if not vim.tbl_contains(valid_statuses, status) then
		vim.notify("OptiSpec: Invalid status '" .. status .. "' for language " .. language_name, vim.log.levels.ERROR)
		return false
	end
	
	ensure_cache()
	
	-- Update cache
	json_cache.languages[language_name] = status
	cache_dirty = true
	
	-- Immediate flush for status changes
	return flush_cache()
end

-- Get all language statuses
function M.get_all_statuses()
	ensure_cache()
	return vim.deepcopy(json_cache.languages)
end

-- Check if language is fully installed
function M.is_language_installed(language_name)
	return M.get_language_status(language_name) == "full"
end

-- Check if language has partial installation
function M.is_language_partial(language_name)
	return M.get_language_status(language_name) == "partial"
end

-- Remove language from tracking
function M.remove_language(language_name)
	ensure_cache()
	
	if json_cache.languages[language_name] then
		json_cache.languages[language_name] = nil
		cache_dirty = true
		return flush_cache()
	end
	
	return true
end

-- Get languages by status
function M.get_languages_by_status(status)
	ensure_cache()
	
	local languages = {}
	for lang, lang_status in pairs(json_cache.languages) do
		if lang_status == status then
			table.insert(languages, lang)
		end
	end
	
	-- Sort alphabetically
	table.sort(languages)
	return languages
end

-- Get installation statistics
function M.get_stats()
	ensure_cache()
	
	local stats = {
		full = 0,
		partial = 0,
		none = 0,
		total = 0
	}
	
	for _, status in pairs(json_cache.languages) do
		if stats[status] then
			stats[status] = stats[status] + 1
		end
		stats.total = stats.total + 1
	end
	
	return stats
end

-- Verify installation status by checking actual tools
function M.verify_language_status(language_name)
	local languages_module = require("optispec.core.languages")
	local config = languages_module.get_language_config(language_name)
	
	if not config then
		return "none"
	end
	
	-- Use OptiSpec's mason utilities for consistent checking
	local mason_utils = _G.OptiSpec and _G.OptiSpec.mason
	if not mason_utils then
		-- Fallback to direct mason-registry access
		local ok, mason_registry = pcall(require, "mason-registry")
		if not ok then
			return "none"
		end
		mason_utils = { is_tool_installed = function(tool) return mason_registry.is_installed(tool) end }
	end
	local total_tools = 0
	local installed_tools = 0
	local mason_tools_installed = 0
	local mason_tools_total = 0
	local ts_parsers_installed = 0
	local ts_parsers_total = 0
	
	-- Check Mason tools
	if config.mason_tools then
		for category, tools in pairs(config.mason_tools) do
			for _, tool in ipairs(tools) do
				mason_tools_total = mason_tools_total + 1
				total_tools = total_tools + 1
				local is_installed = mason_utils.is_tool_installed(tool)
				if is_installed then
					mason_tools_installed = mason_tools_installed + 1
					installed_tools = installed_tools + 1
				end
			end
		end
	end
	
	-- Check treesitter parsers
	if config.treesitter then
		local ts_parsers = require("nvim-treesitter.parsers")
		for _, parser in ipairs(config.treesitter) do
			ts_parsers_total = ts_parsers_total + 1
			total_tools = total_tools + 1
			local has_parser = ts_parsers.has_parser(parser)
			if has_parser then
				ts_parsers_installed = ts_parsers_installed + 1
				installed_tools = installed_tools + 1
			end
		end
	end
	
	
	-- Determine status
	local status
	if total_tools == 0 then
		status = "none"
	elseif installed_tools == 0 then
		status = "none"
	elseif installed_tools == total_tools then
		status = "full"
	else
		status = "partial"
	end
	
	return status
end

-- Update language status based on actual installation
function M.update_language_status(language_name)
	local actual_status = M.verify_language_status(language_name)
	return M.set_language_status(language_name, actual_status)
end

-- Refresh all language statuses
function M.refresh_all_statuses()
	local languages_module = require("optispec.core.languages")
	local all_languages = languages_module.get_all_languages()
	
	local updated = 0
	for _, lang_info in ipairs(all_languages) do
		local old_status = M.get_language_status(lang_info.name)
		local new_status = M.verify_language_status(lang_info.name)
		
		if old_status ~= new_status then
			M.set_language_status(lang_info.name, new_status)
			updated = updated + 1
		end
	end
	
	vim.notify("OptiSpec: Refreshed status for " .. updated .. " languages", vim.log.levels.INFO)
	return updated
end

-- Force save cache (useful for cleanup)
function M.save()
	return flush_cache()
end

-- Clear all data (useful for testing)
function M.clear_all()
	json_cache = {}
	cache_dirty = true
	return flush_cache()
end

-- Get JSON file path (for debugging)
function M.get_file_path()
	return get_json_path()
end

-- Get current linter setting
function M.get_linters_status()
	ensure_cache()
	return json_cache.linters
end

-- Set linter setting
function M.set_linters_status(status)
	ensure_cache()
	json_cache.linters = status
	cache_dirty = true
	return flush_cache()
end

-- Toggle linters
function M.toggle_linters()
	ensure_cache()
	local new_status = not json_cache.linters
	json_cache.linters = new_status
	cache_dirty = true
	local success = flush_cache()
	return success, new_status
end

-- Initialize JSON tracking system on Neovim startup
function M.init()
	-- This will ensure the JSON file is created if it doesn't exist
	ensure_cache()
	
	-- Auto-refresh all language statuses on startup to ensure JSON reflects actual state
	vim.defer_fn(function()
		-- Only refresh if OptiSpec is fully initialized to avoid circular dependencies
		if _G.OptiSpec and _G.OptiSpec.initialized then
			vim.notify("OptiSpec: Refreshing language statuses on startup...", vim.log.levels.INFO)
			M.refresh_all_statuses()
		else
			-- Schedule refresh after OptiSpec is fully initialized
			vim.defer_fn(function()
				if _G.OptiSpec and _G.OptiSpec.initialized then
					vim.notify("OptiSpec: Refreshing language statuses...", vim.log.levels.INFO)
					M.refresh_all_statuses()
				end
			end, 2000) -- Try again after 2 seconds
		end
	end, 1000) -- Initial delay to allow other systems to initialize
end

return M
