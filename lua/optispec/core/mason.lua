local M = {}

-- Setup Mason with OptiSpec configuration
function M.setup(config)
	-- Initialize Mason first (with safe loading)
	local has_mason, mason = pcall(require, "mason")
	if not has_mason then
		vim.notify("Mason not available, skipping setup", vim.log.levels.WARN)
		return
	end
	
	mason.setup({
		ui = {
			check_outdated_packages_on_open = config.tools.mason.auto_update,
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
		install_root_dir = vim.fn.stdpath("data") .. "/mason",
	})

	-- Setup mason-lspconfig integration if available
	local has_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
	if has_mason_lspconfig then
		mason_lspconfig.setup({
			-- Don't automatically install servers - we handle this per language
			automatic_installation = false,
		})
	end

	-- Create Mason command if it doesn't exist
	if not vim.api.nvim_get_commands({}).Mason then
		vim.api.nvim_create_user_command("Mason", function()
			require("mason.ui").open()
		end, { desc = "Open Mason" })
	end

	-- Store Mason utilities globally for other modules
	_G.OptiSpec = _G.OptiSpec or {}
	_G.OptiSpec.mason = {
		install_tool = M.install_tool,
		uninstall_tool = M.uninstall_tool,
		is_tool_installed = M.is_tool_installed,
		update_all = M.update_all,
	}
end

-- Install a Mason tool
function M.install_tool(tool_name)
	local ok, mason_registry = pcall(require, "mason-registry")
	if not ok then
		vim.notify("Mason registry not available", vim.log.levels.ERROR)
		return false
	end

	-- Check if package exists in registry
	local has_package_ok, has_package = pcall(mason_registry.has_package, tool_name)
	if not has_package_ok or not has_package then
		vim.notify("Package '" .. tool_name .. "' not found in Mason registry", vim.log.levels.WARN)
		return false
	end

	local is_installed_ok, is_installed = pcall(mason_registry.is_installed, tool_name)
	if is_installed_ok and not is_installed then
		local package_ok, package = pcall(mason_registry.get_package, tool_name)
		if package_ok then
			package:install()
			return true
		end
	end

	return false -- Already installed or error
end

-- Uninstall a Mason tool
function M.uninstall_tool(tool_name)
	local mason_registry = require("mason-registry")

	if mason_registry.is_installed(tool_name) then
		local package = mason_registry.get_package(tool_name)
		package:uninstall()
		return true
	end

	return false -- Not installed
end

-- Check if a tool is installed
function M.is_tool_installed(tool_name)
	local ok, mason_registry = pcall(require, "mason-registry")
	if not ok then
		return false
	end

	local ok2, result = pcall(mason_registry.is_installed, tool_name)
	if not ok2 then
		return false
	end

	return result
end

-- Update all installed tools
function M.update_all()
	local config = _G.OptiSpec.config

	-- If auto_update is enabled, Mason handles updates automatically
	if config.tools.mason.auto_update then
		vim.notify("Auto-update is enabled. Mason handles updates automatically.", vim.log.levels.INFO)
		return
	end

	local mason_registry = require("mason-registry")

	for _, package in ipairs(mason_registry.get_installed_packages()) do
		package:check_new_version(function(success, result_or_err)
			if success then
				package:install()
			end
		end)
	end
end

-- Install multiple tools
function M.install_tools(tools)
	for _, tool in ipairs(tools) do
		M.install_tool(tool)
	end
end

-- Plugin definitions
M.plugins = {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
		config = function()
			M.setup({
				tools = {
					mason = { auto_update = true },
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		lazy = true,
	},
}

return M
