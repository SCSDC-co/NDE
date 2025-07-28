local M = {}

-- Default JSON structure
local DEFAULT_JSON = {}

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
		vim.notify("OptiSpec: Could not read JSON file: " .. json_path, vim.log.levels.WARN)
		return DEFAULT_JSON
	end
	
	local content = file:read("*all")
	file:close()
	
	if not content or content == "" then
		return DEFAULT_JSON
	end
	
	-- Parse JSON
	local ok, data = pcall(vim.json.decode, content)
	if not ok then
		vim.notify("OptiSpec: Invalid JSON in tracking file, resetting...", vim.log.levels.WARN)
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
		vim.notify("OptiSpec: Could not encode JSON data", vim.log.levels.ERROR)
		return false
	end
	
	-- Pretty format the JSON
	local formatted_content = content:gsub(",", ",\n  "):gsub("{", "{\n  "):gsub("}", "\n}")
	
	-- Write to temporary file first (atomic operation)
	local temp_file = io.open(temp_path, "w")
	if not temp_file then
		vim.notify("OptiSpec: Could not write to temporary JSON file", vim.log.levels.ERROR)
		return false
	end
	
	temp_file:write(formatted_content)
	temp_file:close()
	
	-- Move temporary file to final location
	local success = vim.fn.rename(temp_path, json_path) == 0
	if not success then
		vim.notify("OptiSpec: Could not finalize JSON file write", vim.log.levels.ERROR)
		-- Clean up temp file
		vim.fn.delete(temp_path)
		return false
	end
	
	return true
end

-- Load JSON data into cache
local function ensure_cache()
	if json_cache == nil then
		json_cache = read_json_file()
	end
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

-- Get language installation status
function M.get_language_status(language_name)
	ensure_cache()
	return json_cache[language_name] or "none"
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
	json_cache[language_name] = status
	cache_dirty = true
	
	-- Immediate flush for status changes
	return flush_cache()
end

-- Get all language statuses
function M.get_all_statuses()
	ensure_cache()
	return vim.deepcopy(json_cache)
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
	
	if json_cache[language_name] then
		json_cache[language_name] = nil
		cache_dirty = true
		return flush_cache()
	end
	
	return true
end

-- Get languages by status
function M.get_languages_by_status(status)
	ensure_cache()
	
	local languages = {}
	for lang, lang_status in pairs(json_cache) do
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
	
	for _, status in pairs(json_cache) do
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
	
	-- Check Mason tools
	local mason = require("mason-registry")
	local total_tools = 0
	local installed_tools = 0
	local mason_tools_installed = 0
	local mason_tools_total = 0
	local ts_parsers_installed = 0
	local ts_parsers_total = 0
	
	if config.mason_tools then
		for category, tools in pairs(config.mason_tools) do
			for _, tool in ipairs(tools) do
				mason_tools_total = mason_tools_total + 1
				total_tools = total_tools + 1
				local is_installed = mason.is_installed(tool)
				if is_installed then
					mason_tools_installed = mason_tools_installed + 1
					installed_tools = installed_tools + 1
				end
				-- Debug: print each mason tool check
				print(string.format("[DEBUG] Mason tool %s.%s: %s -> %s", category, tool, tool, is_installed and "INSTALLED" or "NOT_INSTALLED"))
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
			-- Debug: print each treesitter parser check
			print(string.format("[DEBUG] Treesitter parser %s: %s", parser, has_parser and "INSTALLED" or "NOT_INSTALLED"))
		end
	end
	
	-- Debug: print summary for this language
	print(string.format("[DEBUG] Language %s summary:", language_name))
	print(string.format("  Mason tools: %d/%d installed", mason_tools_installed, mason_tools_total))
	print(string.format("  Treesitter parsers: %d/%d installed", ts_parsers_installed, ts_parsers_total))
	print(string.format("  Total: %d/%d installed", installed_tools, total_tools))
	
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
	
	print(string.format("[DEBUG] Final status for %s: %s", language_name, status))
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

return M
