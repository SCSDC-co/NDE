local M = {}

-- Debug mode (set to true to enable debug prints)
local DEBUG = false

local function debug_print(...)
	if DEBUG then
		print("[DiagMerge]", ...)
	end
end

-- Check if two diagnostics are similar (same position and similar content)
local function are_diagnostics_similar(diag1, diag2)
	-- Must be at same position
	if diag1.lnum ~= diag2.lnum or diag1.col ~= diag2.col then
		return false
	end

	-- Must be same severity
	if diag1.severity ~= diag2.severity then
		return false
	end

	-- Check if messages are identical
	if diag1.message == diag2.message then
		return true
	end

	-- Check if messages are similar (normalize whitespace and check for key phrases)
	local msg1 = diag1.message:lower():gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
	local msg2 = diag2.message:lower():gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

	-- Check if one message contains the other (for cases like "unused variable" vs "'var' is unused")
	if msg1:find(msg2, 1, true) or msg2:find(msg1, 1, true) then
		return true
	end

	-- Check for common patterns that should be merged
	local similar_patterns = {
		{ "unused", "not used" },
		{ "undefined", "not defined" },
		{ "missing", "required" },
		{ "syntax error", "invalid syntax" },
		{ "import", "imported" },
	}

	for _, pattern in ipairs(similar_patterns) do
		local has_pattern1_in_msg1 = msg1:find(pattern[1]) ~= nil
		local has_pattern1_in_msg2 = msg2:find(pattern[1]) ~= nil
		local has_pattern2_in_msg1 = msg1:find(pattern[2]) ~= nil
		local has_pattern2_in_msg2 = msg2:find(pattern[2]) ~= nil

		if (has_pattern1_in_msg1 and has_pattern2_in_msg2) or (has_pattern2_in_msg1 and has_pattern1_in_msg2) then
			return true
		end
	end

	return false
end

-- Track all diagnostics by buffer and namespace
local all_diagnostics = {}

-- Merge and deduplicate diagnostics for a buffer
local function merge_diagnostics_for_buffer(bufnr)
	if not all_diagnostics[bufnr] then
		return
	end

	debug_print("Merging diagnostics for buffer", bufnr)

	local all_diags = {}
	local lsp_diags = {}
	local other_diags = {}

	-- Collect all diagnostics from all namespaces
	for ns, diags in pairs(all_diagnostics[bufnr]) do
		local ns_name = ""
		local namespace_info = vim.api.nvim_get_namespaces()
		for name, ns_id in pairs(namespace_info) do
			if ns_id == ns then
				ns_name = name
				break
			end
		end

		debug_print("Processing namespace:", ns_name, "(", ns, ") with", #diags, "diagnostics")

		-- Check if this is an LSP namespace
		local is_lsp = ns_name:match("vim_lsp") or ns_name:match("lsp")

		for _, diag in ipairs(diags) do
			if is_lsp then
				table.insert(lsp_diags, diag)
			else
				table.insert(other_diags, diag)
			end
		end
	end

	debug_print("Found", #lsp_diags, "LSP diagnostics and", #other_diags, "other diagnostics")

	-- Start with LSP diagnostics (they have priority)
	local merged_diags = vim.deepcopy(lsp_diags)

	-- Add non-LSP diagnostics that don't duplicate LSP ones
	for _, other_diag in ipairs(other_diags) do
		local is_duplicate = false

		for _, lsp_diag in ipairs(lsp_diags) do
			if are_diagnostics_similar(other_diag, lsp_diag) then
				debug_print("Filtering duplicate:", other_diag.message, "(similar to LSP:", lsp_diag.message, ")")
				is_duplicate = true
				break
			end
		end

		if not is_duplicate then
			table.insert(merged_diags, other_diag)
		end
	end

	debug_print("Final merged diagnostics count:", #merged_diags)

	-- Set the merged diagnostics in a dedicated namespace
	local merge_ns = vim.api.nvim_create_namespace("optispec_merged")

	-- Use the original function directly to avoid recursion
	local original_diagnostic_set = vim.diagnostic.set
	original_diagnostic_set(merge_ns, bufnr, merged_diags, {})
end

-- Setup diagnostics merging
function M.setup(config)
	-- Configure diagnostics display
	vim.diagnostic.config({
		virtual_text = true,
		signs = true,
		update_in_insert = true,
		severity_sort = true,
		underline = true,
		float = {
			show_header = true,
			source = "always",
			border = "rounded",
		},
	})

	if not config.tools.diagnostics.merge_sources then
		return
	end

	debug_print("Setting up diagnostics merging")

	-- Store the original function before overriding
	local original_diagnostic_set = vim.diagnostic.set

	-- Hook into vim.diagnostic.set to intercept all diagnostics
	vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
		-- Skip our own merged namespace to avoid recursion
		local ns_name = ""
		local namespace_info = vim.api.nvim_get_namespaces()
		for name, ns_id in pairs(namespace_info) do
			if ns_id == namespace then
				ns_name = name
				break
			end
		end

		if ns_name == "optispec_merged" then
			return original_diagnostic_set(namespace, bufnr, diagnostics, opts)
		end

		-- Skip empty diagnostics (clearing calls)
		if #diagnostics == 0 then
			debug_print("Skipping empty diagnostics for namespace:", ns_name)
			all_diagnostics[bufnr] = all_diagnostics[bufnr] or {}
			all_diagnostics[bufnr][namespace] = nil
			return
		end

		debug_print(
			"Intercepted diagnostics for namespace:",
			ns_name,
			"(",
			namespace,
			") buffer:",
			bufnr,
			"count:",
			#diagnostics
		)

		-- Store diagnostics for this namespace
		all_diagnostics[bufnr] = all_diagnostics[bufnr] or {}
		all_diagnostics[bufnr][namespace] = diagnostics

		-- Schedule merging (debounced)
		vim.schedule(function()
			merge_diagnostics_for_buffer(bufnr)
		end)
	end

	-- Clean up cache when buffer is deleted
	vim.api.nvim_create_autocmd("BufDelete", {
		callback = function(ev)
			all_diagnostics[ev.buf] = nil
		end,
	})
end

-- Plugin definitions (diagnostics module doesn't need its own plugins)
-- It works by hooking into LSP diagnostics
M.plugins = {}

return M
