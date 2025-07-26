local M = {}
local Menu = require("nui.menu")
local Input = require("nui.input")
local Popup = require("nui.popup")

local config = {}

-- Setup browser component
function M.setup(user_config)
	config = user_config
end

-- Show language browser
function M.show()
	-- Ensure OptiSpec is fully initialized before showing browser
	if not _G.OptiSpec.initialized then
		require("optispec").ensure_initialized()
	end

	-- Get FloatBorder colors dynamically from current theme
	local function get_float_border_colors()
		local hl = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
		return {
			fg = hl.fg and ("#%06x"):format(hl.fg),
			bg = hl.bg and ("#%06x"):format(hl.bg) or nil, -- fallback if no bg
		}
	end

	local border_colors = get_float_border_colors()

	-- Define highlight groups using theme's FloatBorder colors
	vim.api.nvim_set_hl(0, "OptiSpecInstalled", { fg = "#10B981" }) -- Keep green for installed
	vim.api.nvim_set_hl(0, "OptiSpecAvailable", { fg = "#F59E0B" }) -- Keep yellow for available
	vim.api.nvim_set_hl(0, "OptiSpecBorder", { fg = border_colors.fg, bg = border_colors.bg }) -- Use FloatBorder colors
	vim.api.nvim_set_hl(0, "OptiSpecSeparator", { fg = border_colors.fg }) -- Use FloatBorder fg for separator
	vim.api.nvim_set_hl(0, "OptiSpecTitle", { fg = border_colors.fg, bg = border_colors.bg }) -- Use FloatBorder colors for title

	local languages = require("optispec.core.languages")
	local all_languages = languages.get_all_languages()

	-- Calculate the longest language name for width
	local max_name_length = 0
	for _, lang in ipairs(all_languages) do
		local name_length = #lang.name:gsub("^%l", string.upper)
		if name_length > max_name_length then
			max_name_length = name_length
		end
	end

	-- Calculate total width: emoji(2) + | + space + name + space + | + space + status
	local total_width = 2 + 1 + 1 + max_name_length + 1 + 1 + 1 + 9 + 1 -- 9 for Available/Installed

	-- Create menu items for languages
	local menu_items = {}

	for _, lang in ipairs(all_languages) do
		local emoji = M.get_language_emoji(lang.name)
		local name = lang.name:gsub("^%l", string.upper)
		local status_text = lang.installed and "Installed" or "Available"

		-- Format: emoji  |  padded_name  |  status
		local padded_name = name .. string.rep(" ", max_name_length - #name)
		local formatted_line = emoji .. " │ " .. padded_name .. " │ " .. status_text

		table.insert(menu_items, Menu.item(formatted_line, { language = lang.name, installed = lang.installed }))
	end

	-- Sort menu items: Available first (alphabetically), then Installed (alphabetically)
	table.sort(menu_items, function(a, b)
		if a.installed ~= b.installed then
			return not a.installed -- Available first (not installed)
		end
		return a.language < b.language -- Then alphabetical within each group
	end)

	-- Create the menu
	local menu = Menu({
		position = "50%",
		size = {
			width = total_width,
			height = math.min(#menu_items + 4, 25), -- Max height of 25
		},
		border = {
			style = "rounded",
			text = {
				top = "🚀 OptiSpec Language Browser",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:OptiSpecBorder,FloatTitle:OptiSpecTitle",
		},
	}, {
		lines = menu_items,
		max_width = 60,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>", "q" },
			submit = { "<CR>", "<Space>" },
		},
		on_close = function()
			print("Browser closed.")
		end,
		on_submit = function(item)
			if item.installed then
				-- Show remove confirmation
				M.show_remove_confirmation(item.language)
			else
				-- Install language
				require("optispec.core.installer").install_language(item.language)
			end
		end,
	})

	-- Mount the menu
	menu:mount()

	-- Apply syntax highlighting after mounting
	vim.schedule(function()
		local bufnr = menu.bufnr
		if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
			-- Set up syntax highlighting for status text and separators
			vim.api.nvim_buf_call(bufnr, function()
				vim.cmd([[syntax match OptiSpecInstalled "Installed" contained]])
				vim.cmd([[syntax match OptiSpecAvailable "Available" contained]])
				vim.cmd([[syntax match OptiSpecSeparator "│" contained]])
				vim.cmd(
					[[syntax region OptiSpecLine start="^" end="$" contains=OptiSpecInstalled,OptiSpecAvailable,OptiSpecSeparator]]
				)
			end)
		end
	end)
end

-- Show remove confirmation
function M.show_remove_confirmation(language_name)
	local menu_items = {
		Menu.item("⚠️  Are you sure you want to remove " .. language_name .. "?"),
		Menu.separator(""),
		Menu.item("✅ Yes - Remove"),
		Menu.item("❌ No - Cancel"),
	}

	local menu = Menu({
		position = "50%",
		size = {
			width = 50,
			height = 6,
		},
		border = {
			style = "rounded",
			text = {
				top = " Remove Language ",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:OptiSpecBorder",
		},
	}, {
		lines = menu_items,
		max_width = 40,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>", "q" },
			submit = { "<CR>", "<Space>" },
		},
		on_close = function()
			-- Reopen browser
			M.show()
		end,
		on_submit = function(item)
			if item.text:match("Yes") then
				require("optispec.core.installer").remove_language(language_name)
				-- Reopen browser to show updated status
				vim.schedule(function()
					M.show()
				end)
			else
				-- Reopen browser
				M.show()
			end
		end,
	})

	menu:mount()
end

-- Get emoji for language (reuse from prompt)
function M.get_language_emoji(language)
	local emojis = {
		python = "🐍",
		javascript = "🟨",
		typescript = "⚡",
		rust = "🦀",
		go = "🐹",
		java = "☕",
		lua = "🌙",
		ruby = "💎",
		php = "🐘",
		shell = "🐚",
		docker = "🐳",
		git = "🔧",
		markdown = "📝",
		json = "📄",
		yaml = "⚙️",
		html = "🌐",
		css = "🎨",
		vue = "💚",
		react = "⚛️",
		angular = "🅰️",
		svelte = "🧡",
		astro = "🚀",
		haskell = "🔍",
		ocaml = "🐪",
		clojure = "🔥",
		erlang = "📡",
		elixir = "💧",
		elm = "🌳",
		gleam = "✨",
		lean = "📐",
		zig = "⚡",
		nix = "❄️",
		terraform = "🏗️",
		ansible = "📦",
		helm = "🚢",
		sql = "🗃️",
		prisma = "🔷",
		r = "📊",
		tex = "📚",
		clangs = "⚙️",
		kotlin = "🎯",
		scala = "🔴",
		csharp = "💙",
		toml = "⚙️",
		cmake = "🔨",
		nushell = "🐚",
		thrift = "📡",
	}

	return emojis[language] or "📝"
end

return M
