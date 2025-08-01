local M = {}

-- Initialize OptiSpec core functionality
function M.setup(config)
	-- Store config globally
	_G.OptiSpec = _G.OptiSpec or {}
	_G.OptiSpec.config = config

	-- Initialize Mason
	require("optispec.core.mason").setup(config)

	-- Initialize LSP with CMP support if enabled
	require("optispec.core.lsp").setup(config)

	-- Initialize formatters
	require("optispec.core.formatters").setup()

	-- Initialize debugger
	require("optispec.core.debugger").setup(config)

	-- Initialize treesitter
	require("optispec.core.treesitter").setup(config)

	-- Initialize diagnostics merging
	if config.tools.diagnostics.merge_sources then
		require("optispec.core.diagnostics").setup(config)
	end

	-- Setup language configurations (tools load on-demand when filetypes are opened)
	require("optispec.core.languages").setup()

	-- Initialize JSON tracking system
	require("optispec.core.json_tracker").init()

	-- Setup dynamic loader for file-type based tool loading
	require("optispec.core.dynamic_loader").setup(config)
end

return M
