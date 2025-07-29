local M = {}
local Menu = require("nui.menu")
local Input = require("nui.input")
local Popup = require("nui.popup")
local Layout = require("nui.layout")

local config = {}

-- Setup browser component
function M.setup(user_config)
	config = user_config
end

-- Helper function to create tool status items for right panel
local function create_tool_status_items(language_name, languages)
	local lang_config = languages.get_language_config(language_name)
	local tool_items = {}

	if not lang_config or not lang_config.mason_tools then
		table.insert(tool_items, Menu.item("No tools configured"))
		return tool_items
	end

	-- Get mason utility for checking tool installation
	local mason_utils = _G.OptiSpec and _G.OptiSpec.mason
	local treesitter_utils = _G.OptiSpec and _G.OptiSpec.treesitter

	-- Check each tool type
	local tool_types = {
		{ key = "lsp", label = "LSP" },
		{ key = "linter", label = "Linter" },
		{ key = "formatters", label = "Formatter" },
		{ key = "dap", label = "Debugger" },
	}

	for _, tool_type in ipairs(tool_types) do
		local tools = lang_config.mason_tools[tool_type.key]
		if tools and #tools > 0 then
			local tool_name = tools[1] -- Get first tool
			local is_installed = false

			-- Use Mason utility to check if tool is installed
			if mason_utils and mason_utils.is_tool_installed then
				is_installed = mason_utils.is_tool_installed(tool_name)
			end

			local status = is_installed and "Installed" or "None"
			-- Calculate exact spacing for right alignment
			local label_part = string.format("%-10s %s", tool_type.label .. ":", tool_name)
			-- Dynamic panel width: editor width * 0.42 (total layout) * 0.6 (right panel)
			local panel_width = math.floor((vim.o.columns * 0.42 * 0.6) - 2)
			local padding_spaces = panel_width - #label_part - #status
			local formatted_line = label_part .. string.rep(" ", math.max(1, padding_spaces)) .. status
			table.insert(tool_items, Menu.item(formatted_line))
		else
			local formatted_line = string.format("%-10s %s", tool_type.label .. ":", "Not configured")
			table.insert(tool_items, Menu.item(formatted_line))
		end
	end

	-- Add treesitter parser info
	if lang_config.treesitter then
		local parser_name = lang_config.treesitter[1] or "unknown"
		local parser_installed = false

		-- Use Treesitter utility to check if parser is installed
		if treesitter_utils and treesitter_utils.is_parser_installed then
			parser_installed = treesitter_utils.is_parser_installed(parser_name)
		end

		local status = parser_installed and "Installed" or "None"
		-- Calculate exact spacing for right alignment
		local label_part = string.format("%-10s %s", "Parser:", parser_name)
		local panel_width = 45 -- Approximate width of tools panel
		local padding_spaces = panel_width - #label_part - #status
		local formatted_line = label_part .. string.rep(" ", math.max(1, padding_spaces)) .. status
		table.insert(tool_items, Menu.item(formatted_line))
	end

	return tool_items
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

	-- Get git sign colors from current theme
	local function get_git_sign_colors()
		local git_add = vim.api.nvim_get_hl(0, { name = "GitSignsAdd" })
		local git_change = vim.api.nvim_get_hl(0, { name = "GitSignsChange" })
		local git_delete = vim.api.nvim_get_hl(0, { name = "GitSignsDelete" })

		return {
			installed = git_add.fg and ("#%06x"):format(git_add.fg) or "#10B981", -- fallback green
			partial = git_change.fg and ("#%06x"):format(git_change.fg) or "#F59E0B", -- fallback yellow
			available = git_delete.fg and ("#%06x"):format(git_delete.fg) or "#EF4444", -- fallback red
		}
	end

	local git_colors = get_git_sign_colors()

	-- Define highlight groups using git sign colors
	vim.api.nvim_set_hl(0, "OptiSpecInstalled", { fg = git_colors.installed }) -- Git add color for installed
	vim.api.nvim_set_hl(0, "OptiSpecPartial", { fg = git_colors.partial }) -- Git change color for partial
	vim.api.nvim_set_hl(0, "OptiSpecAvailable", { fg = git_colors.available }) -- Git delete color for available
	vim.api.nvim_set_hl(0, "OptiSpecBorder", { fg = border_colors.fg, bg = border_colors.bg }) -- Use FloatBorder colors
	vim.api.nvim_set_hl(0, "OptiSpecSeparator", { fg = border_colors.fg }) -- Use FloatBorder fg for separator
	vim.api.nvim_set_hl(0, "OptiSpecTitle", { fg = border_colors.fg, bg = border_colors.bg }) -- Use FloatBorder colors for title
	
	-- Create invisible cursor using multiple approaches
	local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
	local cursorline_hl = vim.api.nvim_get_hl(0, { name = "CursorLine" })
	
	-- Try to get the appropriate background color
	local bg_color = "NONE"
	if cursorline_hl.bg then
		bg_color = ("#%06x"):format(cursorline_hl.bg)
	elseif normal_hl.bg then
		bg_color = ("#%06x"):format(normal_hl.bg)
	end
	
	-- Create invisible cursor with no foreground and matching background
	vim.api.nvim_set_hl(0, "OptiSpecInvisibleCursor", { 
		bg = bg_color,
		fg = bg_color,
		reverse = false,
		underline = false,
		bold = false
	})

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

	-- Get JSON tracker for proper status detection
	local json_tracker = require("optispec.core.json_tracker")

	for _, lang in ipairs(all_languages) do
		local emoji = M.get_language_emoji(lang.name)
		local name = lang.name:gsub("^%l", string.upper)

		-- Get proper status from JSON tracker
		local lang_status = json_tracker.get_language_status(lang.name)
		local status_text
		local is_installed = false

		if lang_status == "full" then
			status_text = "Installed"
			is_installed = true
		elseif lang_status == "partial" then
			status_text = "Partial"
			is_installed = true
		else
			status_text = "Available"
			is_installed = false
		end

		-- Format: emoji  |  padded_name  |  status
		local padded_name = name .. string.rep(" ", max_name_length - #name)
		local formatted_line = emoji .. " │ " .. padded_name .. " │ " .. status_text

		table.insert(menu_items, Menu.item(formatted_line, { language = lang.name, installed = is_installed }))
	end

	-- Sort menu items: Available, Partial, then Installed (all alphabetically within groups)
	table.sort(menu_items, function(a, b)
		-- Get status for each item
		local status_a = json_tracker.get_language_status(a.language)
		local status_b = json_tracker.get_language_status(b.language)

		-- Define sort order: none < partial < full
		local order = { none = 1, partial = 2, full = 3 }
		local order_a = order[status_a] or 1
		local order_b = order[status_b] or 1

		if order_a ~= order_b then
			return order_a < order_b
		end

		-- Same status, sort alphabetically
		return a.language < b.language
	end)

	-- Variables for dual-pane interaction
	local current_selected_language = all_languages[1] and all_languages[1].name or "python"
	local tools_popup = nil
	local preview_popup = nil

	-- Load previews
	local previews = require("optispec.ui.preview")

	-- Create function to update tools content
	local function update_tools_content(language_name)
		if not tools_popup then
			return
		end

		local tool_items = create_tool_status_items(language_name, languages)
		local lines = {}
		for _, item in ipairs(tool_items) do
			table.insert(lines, item.text)
		end

		-- Update popup content
		vim.api.nvim_buf_set_lines(tools_popup.bufnr, 0, -1, false, lines)

		-- Update border title
		tools_popup.border:set_text("top", " 🔧 " .. language_name:gsub("^%l", string.upper) .. " Tools ", "center")

		-- Apply syntax highlighting
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(tools_popup.bufnr) then
				vim.api.nvim_buf_call(tools_popup.bufnr, function()
					vim.cmd([[syntax match OptiSpecInstalled "Installed" contained]])
					vim.cmd([[syntax match OptiSpecAvailable "None" contained]])
					vim.cmd(
						[[syntax region OptiSpecLine start="^" end="$" contains=OptiSpecInstalled,OptiSpecAvailable]]
					)
				end)
			end
		end)
	end

	-- Create function to update preview content
	local function update_preview_content(language_name)
		if not preview_popup then
			return
		end

		local preview_code = previews.get_preview(language_name)
		local preview_lines = vim.split(preview_code, "\n")

		-- Update popup content
		vim.api.nvim_buf_set_lines(preview_popup.bufnr, 0, -1, false, preview_lines)

		-- Update border title
		preview_popup.border:set_text(
			"top",
			" 📄 " .. language_name:gsub("^%l", string.upper) .. " Preview ",
			"center"
		)

		-- Apply basic syntax highlighting based on language
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(preview_popup.bufnr) then
				vim.api.nvim_buf_call(preview_popup.bufnr, function()
					-- Set filetype for syntax highlighting if possible
					local filetype_map = {
						-- Web languages
						javascript = "javascript",
						typescript = "typescript",
						html = "html",
						css = "css",
						vue = "vue",
						react = "javascriptreact",
						angular = "typescript",
						svelte = "svelte",
						astro = "astro",
						-- Systems languages
						rust = "rust",
						go = "go",
						clangs = "c",
						zig = "zig",
						java = "java",
						kotlin = "kotlin",
						scala = "scala",
						csharp = "cs",
						-- Scripting languages
						python = "python",
						ruby = "ruby",
						php = "php",
						shell = "sh",
						lua = "lua",
						perl = "perl",
						r = "r",
						haskell = "haskell",
						ocaml = "ocaml",
						clojure = "clojure",
						erlang = "erlang",
						elixir = "elixir",
						elm = "elm",
						gleam = "gleam",
						lean = "lean",
						-- Data languages
						json = "json",
						yaml = "yaml",
						toml = "toml",
						markdown = "markdown",
						xml = "xml",
						sql = "sql",
						prisma = "prisma",
						tex = "tex",
						-- DevOps languages
						docker = "dockerfile",
						nix = "nix",
						terraform = "terraform",
						ansible = "yaml.ansible",
						helm = "yaml",
						git = "gitconfig",
						cmake = "cmake",
						nushell = "nu",
						thrift = "thrift",
					}
					local filetype = filetype_map[language_name] or "text"
					vim.bo[preview_popup.bufnr].filetype = filetype
				end)
			end
		end)
	end

	-- Create languages panel (left side)
	local languages_menu = Menu({
		border = {
			style = "rounded",
			text = {
				top = " 🚀 OptiSpec Languages ",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:OptiSpecBorder,FloatTitle:OptiSpecTitle,Cursor:OptiSpecInvisibleCursor,lCursor:OptiSpecInvisibleCursor",
			cursorline = true,
		},
	}, {
		lines = menu_items,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>", "q" },
			submit = { "<CR>", "<Space>" },
		},
		on_change = function(item)
			-- Update both panels when selection changes
			if item and item.language then
				current_selected_language = item.language
				update_tools_content(current_selected_language)
				update_preview_content(current_selected_language)
			end
		end,
		on_submit = function(item)
			-- Get actual status from JSON tracker
			local actual_status = json_tracker.get_language_status(item.language)

			if actual_status == "full" then
				-- Fully installed - show remove confirmation
				M.show_remove_confirmation(item.language)
			elseif actual_status == "partial" then
				-- Partially installed - complete the installation
				vim.notify("Completing installation of " .. item.language .. "...", vim.log.levels.INFO)
				require("optispec.core.installer").install_language(item.language)
			else
				-- Not installed - install language
				require("optispec.core.installer").install_language(item.language)
			end
		end,
	})

	-- Create tools panel (right side)
	local initial_tool_items = create_tool_status_items(current_selected_language, languages)
	local initial_lines = {}
	for _, item in ipairs(initial_tool_items) do
		table.insert(initial_lines, item.text)
	end

	tools_popup = Popup({
		border = {
			style = "rounded",
			text = {
				top = "  🔧 " .. current_selected_language:gsub("^%l", string.upper) .. " Tools  ",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:OptiSpecBorder,FloatTitle:OptiSpecTitle,Cursor:OptiSpecInvisibleCursor,lCursor:OptiSpecInvisibleCursor",
			cursorline = false,
		},
	})

	-- Create preview panel
	local initial_preview_lines = vim.split(previews.get_preview(current_selected_language), "\n")

	preview_popup = Popup({
		border = {
			style = "rounded",
			text = {
				top = "  📄 " .. current_selected_language:gsub("^%l", string.upper) .. " Preview  ",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:OptiSpecBorder,FloatTitle:OptiSpecTitle,Cursor:OptiSpecInvisibleCursor,lCursor:NONE",
			cursorline = false,
		},
	})

	-- Create the layout
	local layout = Layout(
		{
			position = "50%",
			size = {
				width = "42%",
				height = "70%",
			},
		},
		Layout.Box({
			Layout.Box(languages_menu, { size = "40%" }),
			Layout.Box({
				Layout.Box(tools_popup, { size = "50%" }),
				Layout.Box(preview_popup, { size = "50%" }),
			}, { dir = "col", size = "60%" }),
		}, { dir = "row" })
	)

	-- Mount the layout
	layout:mount()

	-- Set initial content for tools popup
	vim.api.nvim_buf_set_lines(tools_popup.bufnr, 0, -1, false, initial_lines)

	-- Set initial content for preview popup
	vim.api.nvim_buf_set_lines(preview_popup.bufnr, 0, -1, false, initial_preview_lines)

	-- Apply syntax highlighting after mounting
	vim.schedule(function()
		local bufnr = languages_menu.bufnr
		if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
			-- Set up syntax highlighting for status text and separators
			vim.api.nvim_buf_call(bufnr, function()
				vim.cmd([[syntax match OptiSpecInstalled "Installed" contained]])
				vim.cmd([[syntax match OptiSpecPartial "Partial" contained]])
				vim.cmd([[syntax match OptiSpecAvailable "Available" contained]])
				vim.cmd([[syntax match OptiSpecSeparator "│" contained]])
				vim.cmd(
					[[syntax region OptiSpecLine start="^" end="$" contains=OptiSpecInstalled,OptiSpecPartial,OptiSpecAvailable,OptiSpecSeparator]]
				)
			end)
		end

		-- Apply syntax highlighting for initial tools panel
		local tools_bufnr = tools_popup.bufnr
		if tools_bufnr and vim.api.nvim_buf_is_valid(tools_bufnr) then
			vim.api.nvim_buf_call(tools_bufnr, function()
				vim.cmd([[syntax match OptiSpecInstalled "Installed" contained]])
				vim.cmd([[syntax match OptiSpecAvailable "None" contained]])
				vim.cmd([[syntax region OptiSpecLine start="^" end="$" contains=OptiSpecInstalled,OptiSpecAvailable]])
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
