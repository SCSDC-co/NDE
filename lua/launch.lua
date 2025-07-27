-- 🚀 NDE Settings Migration - Handle renaming tips_settings.json to general_settings.json
local function migrate_nde_settings()
	local nde_data_dir = vim.fn.stdpath("data") .. "/nde"
	local old_settings_file = nde_data_dir .. "/tips_settings.json"
	local new_settings_file = nde_data_dir .. "/general_settings.json"

	-- Only migrate if old file exists and new file doesn't exist
	if vim.fn.filereadable(old_settings_file) == 1 and vim.fn.filereadable(new_settings_file) == 0 then
		-- Try to rename using vim.fn.rename first (more reliable)
		local success = vim.fn.rename(old_settings_file, new_settings_file)
		if success == 0 then -- vim.fn.rename returns 0 on success
			vim.notify(
				"📁 Settings file renamed successfully!\n\n"
					.. "Old: tips_settings.json\n"
					.. "New: general_settings.json\n\n"
					.. "All your preferences have been preserved! 🎉",
				vim.log.levels.INFO,
				{ title = "🚀 NDE Settings Migration", timeout = 3000 }
			)
		else
			-- Fallback: copy content and delete old file
			local old_content = vim.fn.readfile(old_settings_file)
			if old_content and #old_content > 0 then
				vim.fn.writefile(old_content, new_settings_file)
				if vim.fn.delete(old_settings_file) == 0 then -- delete returns 0 on success
					vim.notify(
						"📁 Settings file migrated (copied)!\n\n" .. "Your preferences have been preserved! 🎉",
						vim.log.levels.INFO,
						{ title = "🚀 NDE Settings Migration", timeout = 3000 }
					)
				else
					vim.notify(
						"⚠️ Migration completed but couldn't delete old file\n\n"
							.. "Please manually delete: "
							.. old_settings_file,
						vim.log.levels.WARN,
						{ title = "🚀 NDE Settings Migration", timeout = 5000 }
					)
				end
			else
				vim.notify(
					"❌ Migration failed - couldn't read old settings file",
					vim.log.levels.ERROR,
					{ title = "🚀 NDE Settings Migration" }
				)
			end
		end
	end
end

-- Run migration before anything else
migrate_nde_settings()

-- 🔧 Cross-platform home directory detection
local home = vim.fn.expand("~")
local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
local path_separator = is_windows and ";" or ":"

-- Add LuaRocks bin to PATH
vim.env.PATH = vim.env.PATH .. path_separator .. home .. "/.luarocks/bin"
require("opts")

-- Initialize NDE Plugin Manager
require("config.plugin-manager").setup()

require("lazynvim.lazy")
-- Theme is now handled by Themery plugin
require("keymaps")
require("autocommands")

-- 🎉 Initialize NDE beginner tips system
require("nde.tips").setup({
	enabled = true, -- Show tips by default
	interval = 45000, -- 45 seconds between tips
})

-- 🔧 Initialize OptiSpec language environment
require("optispec").setup({
	languages = {},

	prompt = {
		enabled = true,
		auto_install = false,
	},

	-- Tool integration
	tools = {
		mason = { auto_update = true },
		lsp = { auto_attach = true },
		diagnostics = { merge_sources = false }, -- Disabled to improve scrolling performance
	},
})

-- 📸 Initialize SnapIcon screenshot tool
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		require("snapicon").setup({
			-- Custom configuration can be added here
			-- Uses sensible defaults if not specified
		})
	end,
	once = true, -- Only load once
})
