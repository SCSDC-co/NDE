local M = {}

-- Fun tips for beginners with emojis! 🎉
local tips = {
	{
		title = "🚀 Navigation Basics",
		content = {
			"🏃‍♂️ Use 'h j k l' to move around (left, down, up, right)",
			"✏️ Press 'i' to enter Insert mode, 'Esc' to exit",
			"🦘 Use 'w' to jump to next word, 'b' to jump back",
			"🔝 Press 'gg' to go to top, 'G' to go to bottom",
			"📍 Use '0' to go to line start, '$' to go to line end",
		},
	},
	{
		title = "📁 File Operations",
		content = {
			"💾 ':w' to save file, ':q' to quit",
			"🚪 ':wq' to save and quit, ':q!' to quit without saving",
			"🔍 '<leader>ff' to find files (Telescope magic!)",
			"🕵️ '<leader>fg' to search in files (grep power!)",
			"🌳 '<leader>e' to toggle file explorer",
		},
	},
	{
		title = "⚡ Editing Power",
		content = {
			"🗑️ 'dd' to delete line, 'yy' to copy line",
			"📋 'p' to paste after cursor, 'P' to paste before",
			"⏪ 'u' to undo, 'Ctrl+r' to redo",
			"🎯 'ciw' to change word, 'diw' to delete word",
			"✨ 'V' for visual line mode, 'v' for visual mode",
		},
	},
	{
		title = "🧭 Code Navigation",
		content = {
			"🎯 'gd' to go to definition (jump to the source!)",
			"🔗 'gr' to find references (see who's using this!)",
			"📚 'K' to show hover documentation",
			"🛠️ '<leader>ca' for code actions (fix it!)",
			"🚨 ']d' and '[d' to navigate diagnostics",
		},
	},
	{
		title = "🪟 Window Management",
		content = {
			"➖ ':split' or ':sp' for horizontal split",
			"➡️  ':vsplit' or ':vs' for vertical split",
			"🧭 'Ctrl+w h/j/k/l' to navigate between windows",
			"📏 'Ctrl+w +/-' to resize windows",
			"⚖️ 'Ctrl+w =' to equalize window sizes",
		},
	},
	{
		title = "💻 Terminal & Tasks",
		content = {
			"🖥️ '<leader>tt' to toggle terminal",
			"📐 '<leader>th' for horizontal terminal",
			"📏 '<leader>tv' for vertical terminal",
			"🚪 'Ctrl+\\' then 'Ctrl+n' to exit terminal mode",
			"⚡  Use ':!' to run shell commands",
		},
	},
	{
		title = "🎨 Pro Tips",
		content = {
			"🌟  Use '.' to repeat last command",
			"🔄 'Ctrl+o' to go back, 'Ctrl+i' to go forward",
			"📝 'o' to create new line below, 'O' for above",
			"🎪 'f{char}' to find character in line",
			"🎭 '%' to jump between matching brackets",
		},
	},
	{
		title = "🚀 Advanced Moves",
		content = {
			"🏆 'ci(' to change inside parentheses",
			"🎯 'da\"' to delete around quotes",
			"📦 'yap' to yank around paragraph",
			"🔥 'C' to change from cursor to end of line",
			"⚡  'D' to delete from cursor to end of line",
			"🚀 'F8' to run code (universal runner for any language!)",
		},
	},
}

local current_tip = 1
local last_shown_tip = nil -- Track last shown tip to prevent duplicates
local tip_timer = nil
local tip_interval = 45000 -- 45 seconds (a bit longer to read)

-- Settings persistence - centralized in nde folder
local nde_data_dir = vim.fn.stdpath("data") .. "/nde"
local settings_file = nde_data_dir .. "/tips_settings.json"

-- Ensure the nde data directory exists
vim.fn.mkdir(nde_data_dir, "p")
local tips_enabled = true
local welcome_enabled = true

-- Load settings from file
local function load_settings()
	local file = io.open(settings_file, "r")
	if file then
		local content = file:read("*all")
		file:close()
		local ok, settings = pcall(vim.fn.json_decode, content)
		if ok and settings then
			tips_enabled = settings.tips_enabled ~= false
			welcome_enabled = settings.welcome_enabled ~= false
			-- Load hardtime setting
			if settings.hardtime ~= nil then
				vim.g.nde_hardmode_enabled = settings.hardtime
			end
		end
	end
end

-- Save settings to file
local function save_settings()
	local settings = {
		tips_enabled = tips_enabled,
		welcome_enabled = welcome_enabled,
		hardtime = vim.g.nde_hardmode_enabled,
	}
	local file = io.open(settings_file, "w")
	if file then
		file:write(vim.fn.json_encode(settings))
		file:close()
	end
end

-- Check if current buffer is a file (not empty, terminal, etc.)
local function is_in_file()
	local buftype = vim.bo.buftype
	local filetype = vim.bo.filetype
	local bufname = vim.api.nvim_buf_get_name(0)

	-- Don't show tips in special buffers
	if buftype ~= "" then
		return false
	end

	-- Don't show tips in help, terminal, or other special filetypes
	local excluded_filetypes = {
		"help",
		"terminal",
		"NvimTree",
		"neo-tree",
		"TelescopePrompt",
		"TelescopeResults",
		"dashboard",
		"alpha",
		"startify",
		"lazy",
		"mason",
		"lspinfo",
		"checkhealth",
		"qf",
	}

	for _, ft in ipairs(excluded_filetypes) do
		if filetype == ft then
			return false
		end
	end

	-- Must have a filename (not an empty buffer)
	return bufname ~= ""
end
local fun_messages = {
	"🎉 Here's another awesome tip!",
	"💡 Time for some Vim wisdom!",
	"🚀 Level up your coding skills!",
	"✨ Master these moves!",
	"🔥 Hot tip incoming!",
	"🏆 Pro tip alert!",
	"🎯 Precision editing ahead!",
	"⚡  Speed boost unlocked!",
}

-- Show tip notification with random fun message
local function show_tip(tip)
	if not tips_enabled then
		return
	end

	local content = table.concat(tip.content, "\n")
	local fun_msg = fun_messages[math.random(#fun_messages)]

	-- Use nvim-notify directly to avoid noice formatting
	local notify = require("notify")
	notify(content, vim.log.levels.INFO, {
		title = fun_msg .. " " .. tip.title,
		timeout = 6000,
		render = "default",
	})
end

-- Start tip rotation
local function start_tips()
	if tip_timer then
		tip_timer:stop()
		tip_timer:close()
	end

	tip_timer = vim.loop.new_timer()
	tip_timer:start(
		tip_interval,
		tip_interval,
		vim.schedule_wrap(function()
			-- Only show tips when in a file and tips are enabled
			if tips_enabled and #tips > 0 and is_in_file() then
				show_tip(tips[current_tip])
				last_shown_tip = current_tip
				current_tip = current_tip % #tips + 1
			end
		end)
	)
end

-- Stop tip rotation
local function stop_tips()
	if tip_timer then
		tip_timer:stop()
		tip_timer:close()
		tip_timer = nil
	end
end

-- Show epic welcome message
local function show_welcome()
	-- Check if welcome messages are enabled
	if not welcome_enabled then
		return
	end

	vim.defer_fn(function()
		if tips_enabled then
			-- Welcome message when tips are enabled
			vim.notify(
				"🎉 Welcome to NDE (Neovim Development Environment)! 🎉\n\n"
					.. "🚀 Ready to code with power and simplicity\n"
					.. "💡 Fun tips will appear every 45 seconds\n"
					.. "⚙️ Use :NDE to access all commands\n"
					.. "🎯 Type :NDE help for the full command list\n\n"
					.. "🔥 First epic tip coming right up...",
				vim.log.levels.INFO,
				{
					title = "🌟 NDE is Ready to Rock! 🌟",
					timeout = 5000,
				}
			)

			-- Show first tip after welcome
			vim.defer_fn(function()
				if #tips > 0 then
					show_tip(tips[1])
				end
			end, 3000)
		else
			-- Welcome message when tips are disabled
			vim.notify(
				"🎉 Welcome back to NDE! 🎉\n\n"
					.. "🚀 Ready to code with power and simplicity\n"
					.. "😴 Tips are currently sleeping (you disabled them)\n"
					.. "💡 Use :NDE tips on to wake them up anytime\n"
					.. "⚙️ Use :NDE to access all commands\n"
					.. "🎯 Type :NDE help for the full command list\n\n"
					.. "🔥 Happy coding without distractions!",
				vim.log.levels.INFO,
				{
					title = "🌟 NDE is Ready (Tips Off) 🌟",
					timeout = 5000,
				}
			)
		end
	end, 1000)
end

-- Save hardtime setting (exposed for command suite)
M.save_hardtime = function(enabled)
	vim.g.nde_hardmode_enabled = enabled
	save_settings()
end

-- Expose functions for command suite
M.enable = function()
	tips_enabled = true
	save_settings()
	start_tips()
	vim.notify("🎉 Tips enabled! Get ready for awesome advice! 💡", vim.log.levels.INFO)
end

M.disable = function()
	tips_enabled = false
	save_settings()
	stop_tips()
	vim.notify("😴 Tips disabled. They'll be waiting when you're ready!", vim.log.levels.INFO)
end

M.toggle = function()
	tips_enabled = not tips_enabled
	save_settings()
	if tips_enabled then
		start_tips()
		vim.notify("🎉 Tips enabled! Let the learning begin! 🚀", vim.log.levels.INFO)
	else
		stop_tips()
		vim.notify("😴 Tips paused. Use :NDE tips on to resume!", vim.log.levels.INFO)
	end
end

M.show_current = function()
	if #tips > 0 then
		show_tip(tips[current_tip])
		last_shown_tip = current_tip
	end
end

M.show_next = function()
	current_tip = current_tip % #tips + 1
	show_tip(tips[current_tip])
	last_shown_tip = current_tip
end

M.show_random = function()
	local random_tip
	-- Ensure random tip is different from last shown (if we have more than 1 tip)
	if #tips > 1 and last_shown_tip then
		repeat
			random_tip = math.random(#tips)
		until random_tip ~= last_shown_tip
	else
		random_tip = math.random(#tips)
	end
	show_tip(tips[random_tip])
	last_shown_tip = random_tip
	vim.notify("🎲 Random tip served! 🎯", vim.log.levels.INFO)
end

M.show_welcome = function()
	show_welcome()
end

-- Welcome message toggle functions
M.welcome_toggle = function()
	welcome_enabled = not welcome_enabled
	save_settings()
	if welcome_enabled then
		vim.notify("🎉 Welcome messages enabled! You'll see them on startup! 👋", vim.log.levels.INFO)
	else
		vim.notify("😴 Welcome messages disabled. Quiet startups from now on!", vim.log.levels.INFO)
	end
end

M.show_status = function()
	vim.notify(
		"📊 NDE Status Dashboard:\n\n"
			.. "💡 Tips: "
			.. (tips_enabled and "Enabled & Rocking! 🎉" or "Sleeping 😴")
			.. "\n"
			.. "👋 Welcome Messages: "
			.. (welcome_enabled and "Enabled & Welcoming! 🎉" or "Disabled 😴")
			.. "\n"
			.. "🎯 Current tip: "
			.. current_tip
			.. "/"
			.. #tips
			.. "\n"
			.. "⏰ Tip interval: "
			.. (tip_interval / 1000)
			.. "s\n"
			.. "📚 Total tips available: "
			.. #tips
			.. " awesome tips!\n"
			.. "🚀 NDE is running smooth!",
		vim.log.levels.INFO,
		{ title = "🌟 NDE Status Report" }
	)
end

-- Setup function
function M.setup(opts)
	opts = opts or {}

	-- Check if settings file exists
	local settings_exist = vim.loop.fs_stat(settings_file) ~= nil

	if settings_exist then
		-- Load saved settings if they exist
		load_settings()
	else
		-- First time setup - use provided defaults or true
		tips_enabled = opts.enabled ~= false -- Default to true unless explicitly set to false
		save_settings() -- Save the initial setting
	end

	-- Override defaults with user options
	tip_interval = opts.interval or tip_interval

	-- Seed random for fun messages
	math.randomseed(os.time())

	-- Setup NDE command suite
	local command_suite = require("nde.command-suite")
	command_suite.setup()

	-- Show welcome message on startup (temporarily disabled to fix dashboard positioning)
	show_welcome()

	-- Start tips if enabled
	if tips_enabled then
		vim.defer_fn(start_tips, 6000) -- Start after 6 seconds
	end
end

-- Cleanup on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		stop_tips()
	end,
})

return M
