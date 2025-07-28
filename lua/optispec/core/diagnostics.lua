local M = {}

-- Setup diagnostics merging
function M.setup(config)
	-- Define cool diagnostic signs
	local signs = {
		[vim.diagnostic.severity.ERROR] = "",
		[vim.diagnostic.severity.WARN] = "",
		[vim.diagnostic.severity.HINT] = "󰌵",
		[vim.diagnostic.severity.INFO] = ""
	}

	-- Configure diagnostics display
	vim.diagnostic.config({
		virtual_text = false, -- Disabled for tiny-inline-diagnostic compatibility
		signs = {
			text = signs,
		},
		update_in_insert = true,
		severity_sort = true,
		underline = false,
		float = {
			show_header = true,
			source = "always",
			border = "rounded",
			prefix = function(diagnostic, i, total)
				local icon, hl_group = signs[vim.diagnostic.severity[diagnostic.severity]], "DiagnosticSign" .. vim.diagnostic.severity[diagnostic.severity]
				return icon .. " ", hl_group
			end,
		},
	})

	-- Diagnostic merging is disabled for now to avoid performance issues
	-- TODO: Implement a simpler, more efficient merging system in the future
	return

end

-- Plugin definitions (diagnostics module doesn't need its own plugins)
-- It works by hooking into LSP diagnostics
M.plugins = {}

return M
