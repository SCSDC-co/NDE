-- NDE Command Suite
-- Centralized command system for all NDE functionality

local M = {}

-- Import modules
local tips = require("nde.tips")

-- Snippets functionality
local function list_snippets()
	-- Check if LuaSnip is available
	local ok, ls = pcall(require, "luasnip")
	if not ok then
		vim.notify(
			"❌ LuaSnip not available\n\n" .. "Install LuaSnip to use snippets functionality",
			vim.log.levels.ERROR,
			{ title = "🚀 NDE Snippets" }
		)
		return
	end

	local ft = vim.bo.filetype
	if ft == "" then
		vim.notify(
			"⚠️  No filetype detected\n\n" .. "Open a file with a recognized filetype to see available snippets",
			vim.log.levels.WARN,
			{ title = "🚀 NDE Snippets" }
		)
		return
	end

	local snippets = ls.get_snippets(ft)
	if not snippets or vim.tbl_isempty(snippets) then
		vim.notify(
			"📝 No snippets available for filetype: "
				.. ft
				.. "\n\n"
				.. "Supported languages include: Python, JavaScript/TypeScript, Rust, Go, C/C++, Lua, HTML, SQL",
			vim.log.levels.INFO,
			{ title = "🚀 NDE Snippets" }
		)
		return
	end

	local snippet_list = {}
	for _, snippet in pairs(snippets) do
		table.insert(snippet_list, "• " .. snippet.trigger)
	end

	vim.notify(
		"🎯 Available snippets for "
			.. ft
			.. ":\n\n"
			.. table.concat(snippet_list, "\n")
			.. "\n\n"
			.. "💡 Use <C-f> to expand snippets, <C-b>/<C-f> to navigate placeholders",
		vim.log.levels.INFO,
		{ title = "🚀 NDE Snippets - " .. ft:upper(), timeout = 10000 }
	)
end

-- Function to open help buffer
local function open_help_buffer()
	-- Path to the help file
	local help_file = vim.fn.stdpath("config") .. "/lua/nde/doc/nde-help.txt"
	
	-- Check if help file exists
	if vim.fn.filereadable(help_file) == 0 then
		vim.notify(
			"❌ Help file not found: " .. help_file,
			vim.log.levels.ERROR,
			{ title = "🚀 NDE Help" }
		)
		return
	end
	
	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true)
	if buf == 0 then
		vim.notify(
			"❌ Failed to create help buffer",
			vim.log.levels.ERROR,
			{ title = "🚀 NDE Help" }
		)
		return
	end
	
	-- Read the help file content
	local lines = vim.fn.readfile(help_file)
	if not lines then
		vim.notify(
			"❌ Failed to read help file",
			vim.log.levels.ERROR,
			{ title = "🚀 NDE Help" }
		)
		return
	end
	
	-- Set buffer content
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	
	-- Set buffer options
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "buflisted", false)
	vim.api.nvim_buf_set_option(buf, "swapfile", false)
	vim.api.nvim_buf_set_option(buf, "readonly", true)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "filetype", "help")
	
	-- Open buffer in a new window (split)
	vim.cmd("split")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)
	
	-- Set window options
	vim.api.nvim_win_set_option(win, "wrap", false)
	vim.api.nvim_win_set_option(win, "number", false)
	vim.api.nvim_win_set_option(win, "relativenumber", false)
	vim.api.nvim_win_set_option(win, "cursorline", true)
	
	-- Set buffer name
	vim.api.nvim_buf_set_name(buf, "NDE Help")
	
	-- Add keymaps for navigation and closing
	local opts = { buffer = buf, silent = true }
	vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
	vim.keymap.set("n", "<ESC>", "<cmd>close<cr>", opts)
	
	vim.notify(
		"📚 NDE Help opened!\n\n" ..
		"Press 'q' or <ESC> to close",
		vim.log.levels.INFO,
		{ title = "🚀 NDE Help", timeout = 3000 }
	)
end

-- Main NDE command handler
local function handle_nde_command(opts)
	local args = vim.split(opts.args, " ", { trimempty = true })
	local cmd = args[1] or "help"
	local subcmd = args[2]
	local action = args[3]

	-- Tips commands
	if cmd == "tips" then
		if subcmd == "on" then
			tips.enable()
		elseif subcmd == "off" then
			tips.disable()
		else
			tips.toggle()
		end
	elseif cmd == "tip" then
		if subcmd == "show" then
			tips.show_current()
		elseif subcmd == "next" then
			tips.show_next()
		elseif subcmd == "random" then
			tips.show_random()
		else
			tips.show_current()
		end

	-- Codeium commands
	elseif cmd == "codeiumauth" then
		if subcmd == "help" then
			vim.notify(
				"💡 Codeium Authentication Help:\n\n"
					.. "When you run :Codeium Auth, you'll see options like:\n"
					.. "1: Open Default Browser\n"
					.. "2: Copy URL to Clipboard\n"
					.. "3: Display URL\n"
					.. "4: I already have a key\n\n"
					.. "🔥 IMPORTANT: Type a NUMBER (1-4) and press ENTER!\n\n"
					.. "💡 TIP: Option 1 (browser) is usually the easiest",
				vim.log.levels.INFO,
				{ title = "🤖 Codeium Auth Help", timeout = 8000 }
			)
		else
			-- Show codeiumauth help
			vim.notify(
				"🤖 NDE Codeium Commands:\n\n"
					.. "📚 :NDE codeiumauth help - Show authentication help\n\n"
					.. "💡 TIP: Run :Codeium Auth to authenticate with Codeium",
				vim.log.levels.INFO,
				{ title = "🤖 NDE Codeium Help", timeout = 5000 }
			)
		end

	-- Hardmode commands
	elseif cmd == "hardmode" then
		if subcmd == "on" then
			local ok, hardtime = pcall(require, "hardtime")
			if ok then
				hardtime.enable()
				-- Save state persistently using JSON
				tips.save_hardtime(true)
				vim.notify(
					"🔥 Hard Mode ENABLED! 💪\n\n"
						.. "No more lazy hjkl movements!\n"
						.. "Time to level up your Vim skills!\n\n"
						.. "💡 Use :NDE hardmode off to disable\n"
						.. "💾 Setting saved permanently!",
					vim.log.levels.INFO,
					{ title = "🚀 NDE Hard Mode" }
				)
			else
				vim.notify(
					"❌ Hardtime plugin not found\n\n" .. "Install hardtime.nvim to use this feature",
					vim.log.levels.ERROR,
					{ title = "🚀 NDE Hard Mode" }
				)
			end
		elseif subcmd == "off" then
			local ok, hardtime = pcall(require, "hardtime")
			if ok then
				hardtime.disable()
				-- Save state persistently using JSON
				tips.save_hardtime(false)
				vim.notify(
					"😌 Hard Mode DISABLED\n\n"
						.. "Back to comfortable editing...\n\n"
						.. "💡 Use :NDE hardmode on to re-enable\n"
						.. "💾 Setting saved permanently!",
					vim.log.levels.INFO,
					{ title = "🚀 NDE Hard Mode" }
				)
			else
				vim.notify(
					"❌ Hardtime plugin not found\n\n" .. "Install hardtime.nvim to use this feature",
					vim.log.levels.ERROR,
					{ title = "🚀 NDE Hard Mode" }
				)
			end
		else
			-- Show current status and help
			local ok, hardtime = pcall(require, "hardtime")
			local status = "Unknown"
			if ok then
				local is_enabled = vim.g.nde_hardmode_enabled ~= false -- default to true
				status = is_enabled and "🔥 ENABLED" or "😌 DISABLED"
			end

			vim.notify(
				"🔥 NDE Hard Mode Commands:\n\n"
					.. "📊 CURRENT STATUS: "
					.. status
					.. "\n\n"
					.. "🚀 :NDE hardmode on - Enable hard mode (discipline mode)\n"
					.. "😌 :NDE hardmode off - Disable hard mode\n\n"
					.. "💡 WHAT IS HARD MODE?\n"
					.. "• Prevents excessive use of hjkl movements (max 6 repeats)\n"
					.. "• Forces you to use better Vim motions\n"
					.. "• Helps build muscle memory for efficient editing\n"
					.. "• Makes you a better Vim user! 💪\n\n"
					.. "🎯 TIP: Use w, b, f, t, /, ?, etc. instead of hjkl spam!\n"
					.. "💾 Settings are saved permanently between sessions!",
				vim.log.levels.INFO,
				{ title = "🚀 NDE Hard Mode Help", timeout = 10000 }
			)
		end

	-- Snippets commands
	elseif cmd == "snippetslist" then
		list_snippets()

	-- General commands
	elseif cmd == "welcome" then
		if subcmd == "toggle" then
			tips.welcome_toggle()
		else
			tips.show_welcome()
		end
	elseif cmd == "status" then
		tips.show_status()

	-- Minty commands
	elseif cmd == "minty" then
		if subcmd == "help" then
			vim.notify(
				"🎨 Minty Color Picker Usage:\n\n"
					.. "🖱️  For mouse users, it's easy to click & hover\n\n"
					.. "⌨️  NOTE: For keyboard users, these are the mappings:\n\n"
					.. "🔄 <Ctrl> + t : cycle through windows\n"
					.. "⭾ <Tab> or <S-Tab> : cycle through clickables in current window\n"
					.. "↵ <CR> i.e enter to click on the area\n"
					.. "← → moving cursor with h or l in slider",
				vim.log.levels.INFO,
				{ title = "🎨 NDE Minty Color Picker", timeout = 8000 }
			)
		else
			-- Show minty commands overview
			vim.notify(
				"🎨 NDE Minty Commands:\n\n"
					.. "📚 :NDE minty help - Show usage instructions\n\n"
					.. "💡 TIP: Use <leader>cs and <leader>ch for color picker shortcuts",
				vim.log.levels.INFO,
				{ title = "🎨 NDE Minty Help", timeout = 5000 }
			)
		end

	-- SnapIcon commands
	elseif cmd == "snapicon" then
		if subcmd == "config" then
			-- Show current configuration in a user-friendly format
			local snapicon = require("snapicon")
			local config = snapicon.get_config()

			local config_display = "📸 SnapIcon Configuration:\n\n"
				.. "🎨 APPEARANCE:\n"
				.. "   Theme: "
				.. config.silicon.theme
				.. "\n"
				.. "   Background: "
				.. config.silicon.background
				.. "\n"
				.. "   Font: "
				.. config.silicon.font
				.. "\n"
				.. "   Padding: "
				.. config.silicon.pad_vert
				.. "px (vertical), "
				.. config.silicon.pad_horiz
				.. "px (horizontal)\n"
				.. "   Window Controls: "
				.. (config.silicon.show_window_controls and "Yes" or "No")
				.. "\n\n"
				.. "📁 OUTPUT:\n"
				.. "   Directory: "
				.. (config.output.dir or "~/Pictures (default)")
				.. "\n"
				.. "   Filename Template: "
				.. config.output.filename_template
				.. "\n"
				.. "   Full Path Title: "
				.. (config.output.use_full_path_title and "Yes" or "No")
				.. "\n"
				.. "   Copy to Clipboard: "
				.. (config.output.copy_to_clipboard and "Yes" or "No")
				.. "\n\n"
				.. "⌨️  KEYBINDINGS:\n"
				.. "   Screenshot: "
				.. config.keymaps.take_screenshot
				.. "\n\n"
				.. "💻 COMMANDS:\n"
				.. "   Command Name: :"
				.. config.command.name
				.. "\n"
				.. "   Range Support: "
				.. (config.command.range and "Yes" or "No")
				.. "\n\n"
				.. "🔧 WHICH-KEY:\n"
				.. "   Enabled: "
				.. (config.which_key.enabled and "Yes" or "No")
				.. "\n"
				.. "   Group Key: "
				.. config.which_key.group_key
				.. "\n"
				.. "   Group Name: "
				.. config.which_key.group_name

			vim.notify(config_display, vim.log.levels.INFO, { title = "📸 SnapIcon Configuration", timeout = 12000 })
		elseif subcmd == "help" then
			-- Show help
			vim.notify(
				"📸 SnapIcon Usage:\n\n"
					.. "1. **Visual Selection**: Select code in visual mode (v or V)\n"
					.. "2. **Take Screenshot**: Press <leader>S or use :Silicon command\n\n"
					.. "⚙️  FEATURES:\n"
					.. "• 🎨 Configurable themes and styling\n"
					.. "• 📁 Flexible output options\n"
					.. "• 🪟 Full file path in window title\n"
					.. "• 🌈 Automatic language detection\n"
					.. "• 📋 Visual selection support\n\n"
					.. "💡 TIP: Screenshots are saved to your Pictures directory!",
				vim.log.levels.INFO,
				{ title = "📸 SnapIcon Help", timeout = 10000 }
			)
		else
			-- SnapIcon commands overview
			vim.notify(
				"📸 SnapIcon Commands:\n\n"
					.. "⚙️  :NDE snapicon config - Show current configuration\n"
					.. "📚 :NDE snapicon help - Show usage instructions\n\n"
					.. "💡 QUICK START:\n"
					.. "1. Select code in visual mode (v or V)\n"
					.. "2. Press <leader>S to take screenshot\n"
					.. "3. Find your beautiful screenshot in ~/Pictures!\n\n"
					.. "🎯 TIP: Uses Silicon for beautiful code screenshots!",
				vim.log.levels.INFO,
				{ title = "📸 SnapIcon Screenshot Tool", timeout = 8000 }
			)
		end

	-- GitSigns commands
	elseif cmd == "gitsigns" then
		if subcmd == "toggle" then
			-- Toggle gitsigns style
			if _G.toggle_gitsigns_style then
				_G.toggle_gitsigns_style()
			else
				vim.notify(
					"❌ GitSigns toggle function not available\n\n" .. "Make sure GitSigns plugin is loaded!",
					vim.log.levels.ERROR,
					{ title = "🔧 GitSigns Toggle" }
				)
			end
		else
			-- GitSigns commands help
			vim.notify(
				"🔧 NDE GitSigns Commands:\n\n"
					.. "🔄 :NDE gitsigns toggle - Toggle sign style\n\n"
					.. "📊 AVAILABLE STYLES:\n"
					.. "• Default (Clean lines) - Simple vertical bars\n"
					.. "• Modern (Icons) - Beautiful git status icons\n\n"
					.. "💡 TIP: Style preference is saved automatically!",
				vim.log.levels.INFO,
				{ title = "🔧 NDE GitSigns Help", timeout = 8000 }
			)
		end

	-- Dashboard commands
	elseif cmd == "dashboard" then
		if subcmd == "toggleheader" then
			-- Toggle dashboard header style
			local data_dir = vim.fn.stdpath("data") .. "/nde"
			local settings_file = data_dir .. "/general_settings.json"

			-- Ensure directory exists
			vim.fn.mkdir(data_dir, "p")

			-- Read current settings from JSON file
			local settings = { welcome_enabled = false, hardtime = false, tips_enabled = false }
			local current_style = "artistic" -- default

			if vim.fn.filereadable(settings_file) == 1 then
				local content = vim.fn.readfile(settings_file)
				if content and #content > 0 then
					local ok, json_data = pcall(vim.fn.json_decode, table.concat(content, ""))
					if ok and json_data then
						settings = json_data
						if settings.dashboard_header == "simple" then
							current_style = "simple"
						end
					end
				end
			end

			-- Toggle to opposite style
			local new_style = current_style == "simple" and "artistic" or "simple"
			local new_setting = new_style == "simple" and "simple" or "artistic"

			-- Update settings and write back to JSON file
			settings.dashboard_header = new_setting
			local json_string = vim.fn.json_encode(settings)
			vim.fn.writefile({ json_string }, settings_file)

			-- Show notification
			local style_names = {
				simple = "Classic-style (Clean)",
				artistic = "NDE-style (Artistic)",
			}

			vim.notify(
				"🎨 Dashboard Header Style Changed!\n\n"
					.. "📊 Previous: "
					.. style_names[current_style]
					.. "\n"
					.. "✨ Current: "
					.. style_names[new_style]
					.. "\n\n"
					.. "🔄 Restart Neovim or reopen dashboard to see changes\n\n"
					.. "💡 TIP: Press 'h' on the dashboard to toggle styles!",
				vim.log.levels.INFO,
				{ title = "🎨 Dashboard Header Toggle", timeout = 8000 }
			)

			-- If currently on dashboard, suggest refresh
			if vim.bo.filetype == "snacks_dashboard" then
				vim.schedule(function()
					vim.notify(
						"🔄 Close and reopen dashboard to see the new header style!",
						vim.log.levels.INFO,
						{ title = "🎨 Dashboard Refresh" }
					)
				end)
			end
		else
			-- Dashboard commands help
			vim.notify(
				"🎨 NDE Dashboard Commands:\n\n"
					.. "🔄 :NDE dashboard toggleheader - Toggle header style\n\n"
					.. "📊 AVAILABLE STYLES:\n"
					.. "• Classic-style (Clean) - Clean, readable block letters\n"
					.. "• NDE-style (Artistic) - Original artistic design\n\n"
					.. "💡 TIP: Press 'h' on the dashboard for quick toggle!",
				vim.log.levels.INFO,
				{ title = "🎨 NDE Dashboard Help", timeout = 8000 }
			)
		end

	-- Plugin Manager commands
	elseif cmd == "pluginmanager" then
		require("config.ui.plugin_manager").show()

	-- OptiSpec commands
	elseif cmd == "optispec" then
		if subcmd == "status" then
			-- Show OptiSpec status
			local optispec = require("optispec")
			optispec.status()
		elseif subcmd == "browse" then
			-- Open OptiSpec language browser
			local optispec = require("optispec")
			optispec.browse()
		elseif subcmd == "install" then
			-- Install a language
			if action then
				local optispec = require("optispec")
				optispec.install(action)
			else
				vim.notify(
					"📦 OptiSpec Install Command:\n\n"
						.. "Usage: :NDE optispec install <language>\n\n"
						.. "Examples:\n"
						.. "• :NDE optispec install python\n"
						.. "• :NDE optispec install javascript\n"
						.. "• :NDE optispec install rust\n\n"
						.. "💡 TIP: Use :NDE optispec browse to see all available languages",
					vim.log.levels.INFO,
					{ title = "🚀 OptiSpec Install" }
				)
			end
		elseif subcmd == "remove" then
			-- Remove a language
			if action then
				local optispec = require("optispec")
				optispec.remove(action)
			else
				vim.notify(
					"🗑️  OptiSpec Remove Command:\n\n"
						.. "Usage: :NDE optispec remove <language>\n\n"
						.. "Examples:\n"
						.. "• :NDE optispec remove python\n"
						.. "• :NDE optispec remove javascript\n\n"
						.. "⚠️  WARNING: This will remove all tools for the language!",
					vim.log.levels.WARN,
					{ title = "🚀 OptiSpec Remove" }
				)
			end
		elseif subcmd == "update" then
			-- Update all OptiSpec tools
			local optispec = require("optispec")
			optispec.update()
		else
			-- OptiSpec help menu
			vim.notify(
				"🚀 OptiSpec Commands:\n\n"
					.. "📊 :NDE optispec status - Show installed languages\n"
					.. "🌐 :NDE optispec browse - Browse available languages\n"
					.. "📦 :NDE optispec install <lang> - Install language tools\n"
					.. "🗑️ :NDE optispec remove <lang> - Remove language tools\n"
					.. "🔄 :NDE optispec update - Update all tools\n\n"
					.. "💡 FEATURES:\n"
					.. "• 🎯 Zero-bloat start - install only what you need\n"
					.. "• 🧠 Smart diagnostic merging (LSP + linters)\n"
					.. "• ⚡ Auto-detection for 50+ languages\n"
					.. "• 🎨 Beautiful NUI-powered interfaces\n\n"
					.. "🎮 TIP: Open any file and OptiSpec will prompt to install tools!",
				vim.log.levels.INFO,
				{ title = "🚀 OptiSpec Language Manager", timeout = 12000 }
			)
		end
	elseif cmd == "help" or cmd == "" then
		-- Open NDE help documentation in a proper buffer
		open_help_buffer()
	else
		-- Unknown command
		vim.notify(
			"❌ Unknown NDE command: " .. cmd .. "\n\n" .. "Use :NDE help to see all available commands",
			vim.log.levels.WARN,
			{ title = "🚀 NDE Command Suite" }
		)
	end
end

-- Tab completion function
local function complete_nde_command(ArgLead, CmdLine, CursorPos)
	local args = vim.split(CmdLine, " ", { trimempty = true })
	local arg_count = #args

	-- If we're still typing the command name
	if CmdLine:sub(-1) ~= " " then
		arg_count = arg_count - 1
	end

	if arg_count == 1 then
		-- First level commands
		local commands = {
			"help",
			"tips",
			"tip",
			"codeiumauth",
			"hardmode",
			"snippetslist",
			"welcome",
			"status",
			"minty",
			"snapicon",
			"gitsigns",
			"dashboard",
			"optispec",
			"pluginmanager",
		}
		return vim.tbl_filter(function(cmd)
			return cmd:match("^" .. vim.pesc(ArgLead))
		end, commands)
	elseif arg_count == 2 then
		local cmd = args[2]
		if cmd == "tips" then
			return { "on", "off" }
		elseif cmd == "tip" then
			return { "show", "next", "random" }
		elseif cmd == "codeiumauth" then
			return { "help" }
		elseif cmd == "hardmode" then
			return { "on", "off" }
		elseif cmd == "minty" then
			return { "help" }
		elseif cmd == "welcome" then
			return { "toggle" }
		elseif cmd == "snapicon" then
			return { "config", "help" }
		elseif cmd == "optispec" then
			return { "status", "browse", "install", "remove", "update" }
		elseif cmd == "dashboard" then
			return { "toggleheader" }
		elseif cmd == "gitsigns" then
			return { "toggle" }
		elseif cmd == "gitsigns" then
			return { "toggle" }
		end
	elseif arg_count == 3 then
		local cmd = args[2]
		local subcmd = args[3]
		if cmd == "optispec" and (subcmd == "install" or subcmd == "remove") then
			-- Get available languages for completion
			local languages = {
				"python",
				"javascript",
				"typescript",
				"rust",
				"go",
				"c_cpp",
				"java",
				"lua",
				"shell",
				"yaml",
				"json",
				"markdown",
				"html",
				"css",
				"vue",
				"react",
				"angular",
				"svelte",
				"php",
				"ruby",
				"elixir",
				"haskell",
				"scala",
				"kotlin",
				"clojure",
				"docker",
				"terraform",
				"ansible",
			}
			return vim.tbl_filter(function(lang)
				return lang:match("^" .. vim.pesc(ArgLead))
			end, languages)
		end
	end

	return {}
end

-- Setup the main NDE command
function M.setup()
	vim.api.nvim_create_user_command("NDE", handle_nde_command, {
		nargs = "*",
		complete = complete_nde_command,
		desc = "NDE Command Suite - Type :NDE help for all commands",
	})
end

return M
