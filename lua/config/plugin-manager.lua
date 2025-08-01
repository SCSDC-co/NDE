-- NDE Plugin Manager - Core vs Optional Plugin System
-- This file manages the separation between always-loaded core plugins
-- and user-configurable optional plugins

local M = {}

-- Core plugins that are always loaded (essential for NDE functionality)
M.core_plugins = {
	-- Core functionality
	"core/snacks",
	"core/which-key",
	"core/optispec", -- Essential for loading Mason, lspconfig, dap, treesitter, conform, and more
	"core/hardtime",
	"core/vim-be-good", -- Vim training game

	-- UI essentials
	"ui/bufferline",
	"ui/lualine",
	"ui/noice",
	"ui/statuscolumn",
	"ui/ufo", -- Advanced folding with line count display
	"ui/themery",
	"ui/virt-column",
	"ui/zen",
	"ui/rainbow-delimiters",
	"ui/highlight-colors",
	"ui/highlighting", -- matchparen.nvim and local-highlight.nvim

	-- Navigation essentials
	"navigation/neotree",
	"navigation/smart-splits",
	"navigation/telescope",
	"navigation/leap",

	-- Editing essentials
	"editing/cmp", -- Includes all CMP sources: nvim-lsp, buffer, path, cmdline, nvim-lua, calc, emoji, spell, luasnip, signature-help
	"editing/inc-rename", -- Incremental LSP renaming with noice.nvim integration
	"editing/mini", -- Contains mini.surround, mini.pairs
	"editing/mini-align",
	"editing/mini-comment", -- mini.comment
	"editing/repeat",
	"editing/undotree",

	-- Development essentials
	"development/code-runner",
	"development/codeium", -- CMP source integration
	"development/supermaven", -- CMP source integration
	"development/tiny-inline-diagnostic", -- Inline diagnostic display
	"development/tiny-code-actions", -- Code actions with snacks.nvim picker
	"development/nvim-lightbulb", -- Code action indicators in sign column

	-- Git essentials
	"git/vim-fugitive",
	"git/gitsigns",

	-- Terminal essentials
	"terminal/betterterm",
}

-- Centralized data directory for NDE settings
local nde_data_dir = vim.fn.stdpath("data") .. "/nde"
vim.fn.mkdir(nde_data_dir, "p") -- Ensure directory exists

-- Load user configuration for optional plugins
local function load_user_config()
	local config_path = nde_data_dir .. "/plugins.json"

	-- Default configuration
	local default_config = {
		optional_plugins = {
			-- Core category
			legendary = false,
			persistence = false,

			-- UI category
			animate = false,
			codewindow = false,
			dropbar = false,
			incline = false,
			presence = false,
			satellite = false,
			["symbol-usage"] = false,
			["url-open"] = false,
			minty = false,

			-- Navigation category
			aerial = false,
			harpoon = false,
			hydra = false,
			numb = false,
			oil = false,

			-- Editing category
			autotag = false,
			blink = false,
			dial = false,
			hlargs = false,
			["mini-move"] = false,
			snippet = false,
			spectre = false,
			tabout = false,
			treesj = false,
			["visual-multi"] = false,
			yanky = false,

			-- Development category
			avante = false,
			playground = false,
			["render-markdown"] = false,
			["todo-comments"] = false,
			trouble = false,

			-- Git category
			diffview = false,
			["vim-flog"] = false,

			-- Terminal category
			toggleterm = false,

			-- Coding category
			refactoring = false,
		},
	}

	-- Automatically load and merge JSON config
	local user_config = default_config

	local function update_config()
		if vim.fn.filereadable(config_path) == 1 then
			local content = vim.fn.readfile(config_path)
			if content and #content > 0 then
				local ok, loaded_config = pcall(vim.json.decode, table.concat(content, "\n"))
				if ok and type(loaded_config) == "table" and loaded_config.optional_plugins then
					-- Merge existing config with new defaults
					for plugin_name, default_value in pairs(default_config.optional_plugins) do
						if loaded_config.optional_plugins[plugin_name] == nil then
							-- Add new plugin with default value
							loaded_config.optional_plugins[plugin_name] = default_value
						end
					end
					user_config.optional_plugins = loaded_config.optional_plugins
					
					-- Write back the merged config
					M.write_config(loaded_config)
				end
			end
		end
	end

	update_config()

	-- Watch for changes to the config file
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = config_path,
		callback = update_config
	})

	return user_config
end

-- Get list of plugins to load based on configuration
function M.get_plugins_to_load()
	local plugins = {}
	local user_config = load_user_config()

	-- Always load core plugins
	for _, plugin_path in ipairs(M.core_plugins) do
		table.insert(plugins, plugin_path)
	end

	-- Add optional plugins based on user configuration
	for plugin_name, enabled in pairs(user_config.optional_plugins) do
		if enabled then
			-- Find the plugin file in the directory structure
			local plugin_path = M.find_plugin_path(plugin_name)
			if plugin_path then
				table.insert(plugins, plugin_path)
			end
		end
	end

	return plugins
end

-- Helper function to write config back to JSON file
function M.write_config(config)
	local config_path = nde_data_dir .. "/plugins.json"
	
	-- Create pretty-printed JSON manually for better readability
	local json_lines = { "{" }
	table.insert(json_lines, '  "optional_plugins": {')

	-- Sort keys for consistent output
	local sorted_keys = {}
	for key in pairs(config.optional_plugins) do
		table.insert(sorted_keys, key)
	end
	table.sort(sorted_keys)

	-- Add each plugin with proper formatting
	for i, key in ipairs(sorted_keys) do
		local value = config.optional_plugins[key] and "true" or "false"
		local comma = i < #sorted_keys and "," or ""
		table.insert(json_lines, '    "' .. key .. '": ' .. value .. comma)
	end

	table.insert(json_lines, "  }")
	table.insert(json_lines, "}")

	local json_content = table.concat(json_lines, "\n")

	local file = io.open(config_path, "w")
	if file then
		file:write(json_content)
		file:close()
	else
		vim.notify("Failed to write config file", vim.log.levels.ERROR)
	end
end

-- Helper function to find plugin path in directory structure
function M.find_plugin_path(plugin_name)
	local categories = { "core", "ui", "navigation", "editing", "development", "git", "terminal", "coding" }

	for _, category in ipairs(categories) do
		local plugin_file = vim.fn.stdpath("config") .. "/lua/plugins/" .. category .. "/" .. plugin_name .. ".lua"
		if vim.fn.filereadable(plugin_file) == 1 then
			return category .. "/" .. plugin_name
		end
	end

	return nil
end

-- Create default user configuration file if it doesn't exist
function M.create_default_config()
	local config_path = nde_data_dir .. "/plugins.json"

	if vim.fn.filereadable(config_path) == 0 then
		local default_config = {
			optional_plugins = {
				-- Core category
				legendary = false,
				persistence = false,

				-- UI category
				animate = false,
				codewindow = false,
				dropbar = false,
				incline = false,
				presence = false,
				satellite = false,
				["symbol-usage"] = false,
				["url-open"] = false,
				minty = false,

				-- Navigation category
				aerial = false,
				harpoon = false,
				hydra = false,
				numb = false,
				oil = false,

				-- Editing category
				autotag = false,
				blink = false,
				dial = false,
				hlargs = false,
				["mini-move"] = false,
				snippet = false,
				spectre = false,
				tabout = false,
				treesj = false,
				["visual-multi"] = false,
				yanky = false,

				-- Development category
				avante = false,
				playground = false,
				["render-markdown"] = false,
				["todo-comments"] = false,
				trouble = false,

				-- Git category
				diffview = false,
				["vim-flog"] = false,

				-- Terminal category
				toggleterm = false,

				-- Coding category
				refactoring = false,
			},
		}

		-- Create pretty-printed JSON manually for better readability
		local json_lines = { "{" }
		table.insert(json_lines, '  "optional_plugins": {')

		-- Sort keys for consistent output
		local sorted_keys = {}
		for key in pairs(default_config.optional_plugins) do
			table.insert(sorted_keys, key)
		end
		table.sort(sorted_keys)

		-- Add each plugin with proper formatting
		for i, key in ipairs(sorted_keys) do
			local value = default_config.optional_plugins[key] and "true" or "false"
			local comma = i < #sorted_keys and "," or ""
			table.insert(json_lines, '    "' .. key .. '": ' .. value .. comma)
		end

		table.insert(json_lines, "  }")
		table.insert(json_lines, "}")

		local json_content = table.concat(json_lines, "\n")

		local file = io.open(config_path, "w")
		if file then
			file:write(json_content)
			file:close()
			vim.notify("Created NDE configuration file: " .. config_path, vim.log.levels.INFO)
		else
			vim.notify("Failed to create default JSON configuration", vim.log.levels.ERROR)
		end
	end
end

-- Initialize the plugin manager
function M.setup()
	-- Create default config if needed
	M.create_default_config()

	vim.notify("NDE Plugin Manager initialized - Core plugins: " .. #M.core_plugins, vim.log.levels.INFO)
end

return M
