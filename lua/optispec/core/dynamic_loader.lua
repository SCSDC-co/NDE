local M = {}

-- Track what's been loaded to avoid duplicate loading
local loaded_languages = {}
local loading_languages = {}

-- Setup dynamic loading system
function M.setup(config)
	-- Create autogroup for dynamic loading
	local augroup = vim.api.nvim_create_augroup("OptiSpecDynamicLoader", { clear = true })

	-- Load language tools when opening files of that type
	local function handle_buffer_load(ev)
		-- Skip special buffer types
		local buftype = vim.bo[ev.buf].buftype
		if buftype ~= "" then
			return -- Skip nofile, terminal, quickfix, etc.
		end
		
		-- Skip unnamed buffers
		local bufname = vim.api.nvim_buf_get_name(ev.buf)
		if bufname == "" or bufname:match("^%s*$") then
			return
		end
		
		local filetype = vim.bo[ev.buf].filetype
		if not filetype or filetype == "" then
			return
		end

		M.load_language_for_filetype(filetype)
	end

	-- Trigger on buffer read/new file
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = augroup,
		callback = handle_buffer_load,
	})

	-- Also trigger on filetype detection (sometimes filetype is set after buffer load)
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = augroup,
		callback = function(ev)
			-- Skip special buffer types
			local buftype = vim.bo[ev.buf].buftype
			if buftype ~= "" then
				return -- Skip nofile, terminal, quickfix, etc.
			end
			
			-- Skip unnamed buffers
			local bufname = vim.api.nvim_buf_get_name(ev.buf)
			if bufname == "" or bufname:match("^%s*$") then
				return
			end

			M.load_language_for_filetype(ev.match)
		end,
	})

	-- Also trigger for current buffer if already open
	vim.schedule(function()
		local current_ft = vim.bo.filetype
		if current_ft and current_ft ~= "" then
			M.load_language_for_filetype(current_ft)
		end
	end)
end

-- Load language tools for specific filetype
function M.load_language_for_filetype(filetype)
	-- Debug notification
	if vim.g.optispec_debug_loading then
		vim.notify(
			string.format("🔍 Dynamic Loader: Checking filetype '%s'", filetype),
			vim.log.levels.DEBUG,
			{ title = "🚀 OptiSpec Debug" }
		)
	end

	-- Ensure OptiSpec is initialized (this loads all language configs)
	if not _G.OptiSpec or not _G.OptiSpec.initialized then
		local optispec = require("optispec")
		optispec.ensure_initialized()
	end

	-- Get language for this filetype
	local languages_module = require("optispec.core.languages")
	local language = languages_module.get_language_for_filetype(filetype)

	if not language then
		if vim.g.optispec_debug_loading then
			vim.notify(
				string.format("❌ No language found for filetype '%s'", filetype),
				vim.log.levels.DEBUG,
				{ title = "🚀 OptiSpec Debug" }
			)
		end
		return -- No language config for this filetype
	end

	if vim.g.optispec_debug_loading then
		vim.notify(
			string.format("🎯 Found language '%s' for filetype '%s'", language, filetype),
			vim.log.levels.DEBUG,
			{ title = "🚀 OptiSpec Debug" }
		)
	end

	-- Skip if already loaded or currently loading
	if loaded_languages[language] then
		if vim.g.optispec_debug_loading then
			vim.notify(
				string.format("✅ Language '%s' already loaded, skipping", language),
				vim.log.levels.DEBUG,
				{ title = "🚀 OptiSpec Debug" }
			)
		end
		return
	end

	if loading_languages[language] then
		if vim.g.optispec_debug_loading then
			vim.notify(
				string.format("⏳ Language '%s' already loading, skipping", language),
				vim.log.levels.DEBUG,
				{ title = "🚀 OptiSpec Debug" }
			)
		end
		return
	end

	-- Check if language tools are installed
	local is_installed = languages_module.is_language_installed(language)
	if vim.g.optispec_debug_loading then
		vim.notify(
			string.format("🔧 Language '%s' installed: %s", language, tostring(is_installed)),
			vim.log.levels.DEBUG,
			{ title = "🚀 OptiSpec Debug" }
		)
	end

	if not is_installed then
		return -- Tools not installed, let normal prompt system handle it
	end

	-- Mark as loading to prevent duplicate attempts
	loading_languages[language] = true

	-- Notify user about loading
	vim.notify(
		string.format("🚀 Loading %s tools for %s...", language, filetype),
		vim.log.levels.INFO,
		{ title = "OptiSpec Dynamic Loader" }
	)

	-- Load the language tools
	M.load_language_tools(language, filetype)
end

-- Load specific tools for a language
function M.load_language_tools(language, filetype)
	local languages_module = require("optispec.core.languages")
	local config = languages_module.get_language_config(language)

	if not config then
		loading_languages[language] = nil
		return
	end

	vim.schedule(function()
		local success = true
		local errors = {}
		
		-- Load LSP servers for this language
		local lsp_ok, lsp_err = pcall(M.load_lsp_servers, language, config, filetype)
		if not lsp_ok then
			success = false
			table.insert(errors, "LSP: " .. tostring(lsp_err))
		end

		-- Load formatters for this language
		local fmt_ok, fmt_err = pcall(M.load_formatters, language, config, filetype)
		if not fmt_ok then
			success = false
			table.insert(errors, "Formatters: " .. tostring(fmt_err))
		end

		-- Load debuggers for this language
		local dap_ok, dap_err = pcall(M.load_debuggers, language, config, filetype)
		if not dap_ok then
			success = false
			table.insert(errors, "Debugger: " .. tostring(dap_err))
		end

		-- Mark as loaded (even if some components failed)
		loaded_languages[language] = true
		loading_languages[language] = nil

		-- Notify user about completion
		if vim.g.optispec_notify_loading ~= false then
			if success then
				vim.notify(
					string.format("✅ OptiSpec: Successfully loaded %s tools for %s", language, filetype),
					vim.log.levels.INFO,
					{ title = "OptiSpec Dynamic Loader" }
				)
			else
				vim.notify(
					string.format("⚠️ OptiSpec: Loaded %s tools with some errors:\n%s", language, table.concat(errors, "\n")),
					vim.log.levels.WARN,
					{ title = "OptiSpec Dynamic Loader" }
				)
			end
		end
	end)
end

-- Load LSP servers for language
function M.load_lsp_servers(language, config, filetype)
	if not config.lsp or not config.lsp.name then
		return
	end

	local lsp_module = require("optispec.core.lsp")

	-- Use the actual LSP server name from config, not the Mason tool name
	local lsp_server_name = config.lsp.name
	
	-- Check if the corresponding Mason tools are installed
	if config.mason_tools and config.mason_tools.lsp then
		local mason = require("mason-registry")
		local tools_installed = false
		
		-- Check if at least one LSP tool is installed
		for _, tool_name in ipairs(config.mason_tools.lsp) do
			if mason.is_installed(tool_name) then
				tools_installed = true
				break
			end
		end
		
		if tools_installed and lsp_module.setup_server then
			-- Setup the LSP server with its proper name and settings
			lsp_module.setup_server(lsp_server_name, config.lsp.settings or {})
		end
	else
		-- No Mason tools specified, just setup the LSP server if module exists
		if lsp_module.setup_server then
			lsp_module.setup_server(lsp_server_name, config.lsp.settings or {})
		end
	end
end

-- Load formatters for language
function M.load_formatters(language, config, filetype)
	if not config.mason_tools or not config.mason_tools.formatters then
		return
	end

	-- Formatters are typically loaded automatically by conform.nvim
	-- when needed, so we just ensure they're registered
	local conform = require("conform")

	-- Update formatters configuration for this filetype if needed
	local formatters_by_ft = conform.formatters_by_ft or {}
	if not formatters_by_ft[filetype] and config.formatters then
		formatters_by_ft[filetype] = config.formatters
		conform.setup({ formatters_by_ft = formatters_by_ft })
	end
end

-- Load debuggers for language
function M.load_debuggers(language, config, filetype)
	if not config.mason_tools or not config.mason_tools.dap then
		return
	end

	-- Check if debugger module is available and has the required function
	local ok_debugger, debugger_module = pcall(require, "optispec.core.debugger")
	if not ok_debugger then
		return -- Debugger module not available
	end

	-- For now, DAP setup is handled globally, so we just return success
	-- Individual language DAP configurations are typically set up during
	-- the main debugger initialization, not dynamically loaded
	-- TODO: Implement per-language DAP configuration if needed
end

-- Get loading status
function M.get_status()
	return {
		loaded = vim.tbl_keys(loaded_languages),
		loading = vim.tbl_keys(loading_languages),
		total_loaded = vim.tbl_count(loaded_languages),
	}
end

-- Reset loading state (useful for debugging)
function M.reset()
	loaded_languages = {}
	loading_languages = {}
end

-- Force load a language (bypass checks)
function M.force_load_language(language)
	local languages_module = require("optispec.core.languages")
	local config = languages_module.get_language_config(language)

	if not config then
		return
	end

	-- Reset the loading state for this language
	loaded_languages[language] = nil
	loading_languages[language] = nil

	-- Check if language tools are now installed
	local is_installed = languages_module.is_language_installed(language)
	if not is_installed then
		return -- Still not installed
	end

	-- Use the first filetype for loading, or current buffer filetype if it matches
	local filetype = config.filetypes[1]
	local current_ft = vim.bo.filetype
	if current_ft and vim.tbl_contains(config.filetypes, current_ft) then
		filetype = current_ft
	end

	if filetype then
		M.load_language_for_filetype(filetype)
	end
end

return M
