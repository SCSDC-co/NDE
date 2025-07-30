local ui = {}

local Layout = require("nui.layout")
local Popup = require("nui.popup")
local Input = require("nui.input")
local Menu = require("nui.menu")
local core = require("opus.core")
local config = require("opus.config")
local filters = require("opus.utils.filters")

local active_layout = nil
local selected_task = 1
local tasks_popup = nil
local help_popup = nil
local filtered_tasks = nil -- Store filtered tasks when filtering
local current_filter = nil -- Store current filter info

-- Helper to refresh the task display
local function refresh_tasks()
	if not tasks_popup then
		return
	end

	local tasks_to_display = filtered_tasks or core.get_all_tasks()

	local lines = {}
	local width = 76 -- Fixed width for content area (80 - 4 for borders)

	if #tasks_to_display == 0 then
		if current_filter then
			table.insert(lines, " No tasks found with filter: " .. current_filter.value)
			table.insert(lines, " Press 'f' to clear filter")
		else
			table.insert(lines, " No tasks found. Press 'a' to add your first task!")
		end
	else
		for idx, task in ipairs(tasks_to_display) do
			local icons = config.get("ui.icons")
			local status_icon = task.completed and icons.completed or icons.incomplete
			local selection_prefix = idx == selected_task and icons.selected or icons.unselected

			local task_text = string.format("%s %s", selection_prefix, task.name)
			if task.tags and #task.tags > 0 then
				task_text = task_text .. " [" .. table.concat(task.tags, ", ") .. "]"
			end

			local padding_length = width - vim.fn.strdisplaywidth(task_text) - vim.fn.strdisplaywidth(status_icon)
			local padding = string.rep(" ", math.max(1, padding_length))

			local line = task_text .. padding .. status_icon
			table.insert(lines, line)
		end
	end

	vim.api.nvim_buf_set_option(tasks_popup.bufnr, "readonly", false)
	vim.api.nvim_buf_set_option(tasks_popup.bufnr, "modifiable", true)
	vim.api.nvim_buf_set_lines(tasks_popup.bufnr, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(tasks_popup.bufnr, "modifiable", false)
	vim.api.nvim_buf_set_option(tasks_popup.bufnr, "readonly", true)

	-- Apply syntax highlighting to status icons using git signs colors
	if #tasks_to_display > 0 then
		for idx, task in ipairs(tasks_to_display) do
			local line_num = idx - 1 -- 0-indexed for nvim_buf_add_highlight
			local line_content = lines[idx]
			if line_content then
				local icons = config.get("ui.icons")
				local status_icon = task.completed and icons.completed or icons.incomplete
				local icon_pos = line_content:find(status_icon)
				if icon_pos then
					local hl_group = task.completed and "GitSignsAdd" or "GitSignsDelete"
					vim.api.nvim_buf_add_highlight(
						tasks_popup.bufnr,
						-1, -- namespace
						hl_group,
						line_num,
						icon_pos - 1, -- start col (0-indexed)
						icon_pos + #status_icon - 1 -- end col
					)
				end
			end
		end
	end
end

-- Helper to create and show the help pane
local function create_help_pane()
	local pane_width = config.get("ui.width") - 4 -- Account for borders and padding
	local help_content = {
		"j/k/↑/↓ - Navigate │ a - Add task      │ <Enter>/<Space> - Toggle",
		"r - Rename task    │ d - Delete task   │ t - Add tag",
		"T - Remove tag     │ f - Filter by tag │ n - Sort by name",
		"c - Sort by status │ / - Search tasks  │ s - Show statistics",
	}
	local last_line_content = "q/<Esc> - Close Opus"

	-- Find the longest line to normalize width for the grid
	local max_width = 0
	for _, line in ipairs(help_content) do
		max_width = math.max(max_width, vim.fn.strdisplaywidth(line))
	end

	-- Center the main grid of commands
	local centered_lines = {}
	local grid_padding = string.rep(" ", math.floor((pane_width - max_width) / 2))
	for _, line in ipairs(help_content) do
		local line_padding = string.rep(" ", max_width - vim.fn.strdisplaywidth(line))
		table.insert(centered_lines, grid_padding .. line .. line_padding)
	end

	-- Center the last line independently
	local last_line_padding = string.rep(" ", math.floor((pane_width - vim.fn.strdisplaywidth(last_line_content)) / 2))
	table.insert(centered_lines, last_line_padding .. last_line_content)

	help_popup = Popup({
		border = { style = config.get("ui.border_style"), text = { top = " ⚡ Commands " } },
		size = { height = #centered_lines + 2 },
		buf_options = { modifiable = false, readonly = true, filetype = "opus-help" },
	})

	vim.api.nvim_buf_set_lines(help_popup.bufnr, 0, -1, false, centered_lines)

	-- Highlight the separators to match the border
	local border_hl = config.get("ui.highlights.border") or "FloatBorder"
	for i, line in ipairs(centered_lines) do
		local start_col = 1
		while true do
			local col = line:find("│", start_col)
			if not col then
				break
			end
			vim.api.nvim_buf_add_highlight(help_popup.bufnr, -1, border_hl, i - 1, col - 1, col)
			start_col = col + 1
		end
	end

	return help_popup
end

-- Helper to show input dialog with main window hidden
local function show_input(title, default_text, callback)
	-- Hide the main layout
	if active_layout then
		active_layout:hide()
	end

	local input = Input({
		position = "50%",
		size = { width = 50, height = 3 },
		enter = true,
		focusable = true,
		border = { style = "rounded", text = { top = " " .. title .. " " } },
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:" .. (config.get("ui.highlights.border") or "FloatBorder"),
		},
	}, {
		prompt = " > ",
		default_value = default_text or "",
		on_close = function()
			-- Show the main layout again
			if active_layout then
				active_layout:show()
			end
		end,
		on_submit = function(value)
			-- Hide input and show main layout
			if active_layout then
				active_layout:show()
			end
			-- Execute callback (allow empty value for clearing filters)
			if value then
				callback(value)
				refresh_tasks()
			end
		end,
	})

	-- Add exit keymaps
	input:map("i", "<Esc>", function()
		input:unmount()
	end, { noremap = true, silent = true })
	input:map("n", "q", function()
		input:unmount()
	end, { noremap = true, silent = true })
	input:map("n", "<Esc>", function()
		input:unmount()
	end, { noremap = true, silent = true })

	-- Mount and focus
	input:mount()
	vim.cmd("startinsert")
end

-- Helper to show confirmation menu
local function show_confirmation_menu(title, on_confirm)
	-- Hide the main layout
	if active_layout then
		active_layout:hide()
	end

	local menu = Menu({
		position = "50%",
		border = {
			style = "rounded",
			text = { top = " " .. title .. " " },
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:" .. (config.get("ui.highlights.border") or "FloatBorder"),
			cursorline = false,
		},
	}, {
		lines = {
			Menu.item(" ✓ Yes, delete it ", { id = "confirm" }),
			Menu.item(" ✗ No, cancel", { id = "cancel" }),
		},
		on_close = function()
			if active_layout then
				active_layout:show()
			end
		end,
		on_submit = function(item)
			if item.id == "confirm" then
				on_confirm()
			end
		end,
	})

	-- Mount the menu
	menu:mount()

	-- Apply highlighting after mount with defer_fn for reliability
	vim.defer_fn(function()
		if menu.bufnr and vim.api.nvim_buf_is_valid(menu.bufnr) then
			-- Get buffer lines to find icon positions
			local lines = vim.api.nvim_buf_get_lines(menu.bufnr, 0, -1, false)

			for i, line in ipairs(lines) do
				-- Find checkmark and highlight it with GitSignsAdd
				local checkmark_pos = line:find("✓")
				if checkmark_pos then
					vim.api.nvim_buf_add_highlight(
						menu.bufnr,
						-1,
						"GitSignsAdd",
						i - 1,
						checkmark_pos - 1,
						checkmark_pos
					)
				end

				-- Find X mark and highlight it with GitSignsDelete
				local x_pos = line:find("✗")
				if x_pos then
					vim.api.nvim_buf_add_highlight(menu.bufnr, -1, "GitSignsDelete", i - 1, x_pos - 1, x_pos)
				end
			end
		end
	end, 50) -- 50ms delay to ensure menu is fully rendered
end

-- Main function to show task manager
function ui.show_tasks()
	if active_layout then
		active_layout:unmount()
		active_layout = nil
	end

	-- Ensure tasks are loaded from file
	core.load_tasks()

	selected_task = 1

	tasks_popup = Popup({
		enter = true,
		focusable = true,
		border = { style = config.get("ui.border_style"), text = { top = " 📝 Opus Tasks " } },
		size = { height = 15 },
		buf_options = { modifiable = false, readonly = true, filetype = "opus-tasks" },
	})

	help_popup = create_help_pane()

	local ui_config = config.get("ui")
	local layout = Layout(
		{
			position = "50%",
			size = { width = ui_config.width, height = ui_config.height },
		},
		Layout.Box({
			Layout.Box(tasks_popup, { size = ui_config.task_panel_size }),
			Layout.Box(help_popup, { size = ui_config.help_panel_size }),
		}, { dir = "col" })
	)

	local keymap_opts = { noremap = true, silent = true }
	local keymaps = config.get("keymaps")

	local function update_scroll()
		local cursor_line = selected_task
		if not tasks_popup or not tasks_popup.winid then
			return
		end
		local win_height = vim.api.nvim_win_get_height(tasks_popup.winid)
		if win_height == 0 then
			return
		end

		local win_info = vim.fn.getwininfo(tasks_popup.winid)[1]
		if not win_info then
			return
		end

		local top_line = win_info.topline
		local bot_line = win_info.botline

		if cursor_line < top_line then
			vim.api.nvim_win_set_cursor(tasks_popup.winid, { cursor_line, 0 })
			vim.cmd("normal! zt")
		elseif cursor_line > bot_line - 1 then
			vim.api.nvim_win_set_cursor(tasks_popup.winid, { cursor_line, 0 })
			vim.cmd("normal! zb")
		end
	end

	tasks_popup:map("n", keymaps.navigate_down, function()
		local tasks_to_display = filtered_tasks or core.get_all_tasks()
		if #tasks_to_display > 0 then
			selected_task = math.min(selected_task + 1, #tasks_to_display)
			refresh_tasks()
			-- Move cursor to the selected line
			vim.api.nvim_win_set_cursor(tasks_popup.winid, { selected_task, 0 })
			update_scroll()
		end
	end, keymap_opts)

	tasks_popup:map("n", keymaps.navigate_up, function()
		local tasks_to_display = filtered_tasks or core.get_all_tasks()
		if #tasks_to_display > 0 then
			selected_task = math.max(selected_task - 1, 1)
			refresh_tasks()
			-- Move cursor to the selected line
			vim.api.nvim_win_set_cursor(tasks_popup.winid, { selected_task, 0 })
			update_scroll()
		end
	end, keymap_opts)

	tasks_popup:map("n", keymaps.add_task, function()
		show_input("Add New Task", "", function(name)
			core.add_task({ name = name })
		end)
	end, keymap_opts)

	tasks_popup:map("n", keymaps.rename_task, function()
		if #core.tasks > 0 then
			show_input("Rename Task", core.tasks[selected_task].name, function(name)
				core.rename_task(selected_task, name)
			end)
		end
	end, keymap_opts)

	tasks_popup:map("n", keymaps.delete_task, function()
		if #core.tasks > 0 then
			local task = core.tasks[selected_task]
			local task_name = task.name
			local truncated_name = #task_name > 30 and (task_name:sub(1, 30) .. "...") or task_name

			show_confirmation_menu("Delete '" .. truncated_name .. "'?", function()
				core.remove_task(selected_task)
				selected_task = math.max(1, math.min(selected_task, #core.tasks))
				refresh_tasks()
				vim.notify("Task deleted: " .. task_name, vim.log.levels.INFO)
			end)
		end
	end, keymap_opts)

	tasks_popup:map("n", keymaps.add_tag, function()
		if #core.tasks > 0 then
			show_input("Add Tag", "", function(tag)
				core.add_tag(selected_task, tag)
			end)
		end
	end, keymap_opts)

	tasks_popup:map("n", keymaps.toggle_complete, function()
		if #core.tasks > 0 then
			local task = core.tasks[selected_task]
			task.completed = not task.completed
			core.save_tasks()
			refresh_tasks()
		end
	end, keymap_opts)

	tasks_popup:map("n", keymaps.remove_tag, function()
		if #core.tasks > 0 and core.tasks[selected_task].tags and #core.tasks[selected_task].tags > 0 then
			local tags = core.tasks[selected_task].tags
			if #tags == 1 then
				core.remove_tag(selected_task, tags[1])
			else
				-- Show tag selection for removal
				local tag_list = table.concat(tags, ", ")
				show_input("Remove Tag (" .. tag_list .. ")", "", function(tag)
					core.remove_tag(selected_task, tag)
				end)
			end
		end
	end, keymap_opts)

	-- Filter by tag
	tasks_popup:map("n", keymaps.filter_by_tag, function()
		local all_tags = filters.get_all_tags(core.get_all_tasks())
		if #all_tags == 0 then
			vim.notify("No tags found", vim.log.levels.WARN)
			return
		end

		local tag_list = table.concat(all_tags, ", ")
		show_input("Filter by Tag (" .. tag_list .. ")", "", function(tag)
			if tag == "" then
				filtered_tasks = nil -- Clear filter
				current_filter = nil
				vim.notify("Filter cleared", vim.log.levels.INFO)
			else
				filtered_tasks = filters.by_tag(core.get_all_tasks(), tag)
				current_filter = { type = "tag", value = tag }
				if #filtered_tasks == 0 then
					vim.notify("No tasks found with tag: " .. tag, vim.log.levels.WARN)
				else
					vim.notify("Showing " .. #filtered_tasks .. " tasks with tag: " .. tag, vim.log.levels.INFO)
				end
			end

			refresh_tasks()
		end)
	end, keymap_opts)

	-- Sort by name
	tasks_popup:map("n", keymaps.sort_by_name, function()
		core.tasks = filters.sort_by_name(core.tasks)
		core.save_tasks()
		refresh_tasks()
		vim.notify("Tasks sorted by name", vim.log.levels.INFO)
	end, keymap_opts)

	-- Sort by completion status
	tasks_popup:map("n", keymaps.sort_by_completion, function()
		core.tasks = filters.sort_by_completion(core.tasks)
		core.save_tasks()
		refresh_tasks()
		vim.notify("Tasks sorted by completion status", vim.log.levels.INFO)
	end, keymap_opts)

	-- Search tasks
	tasks_popup:map("n", keymaps.search, function()
		show_input("Search Tasks", "", function(search_term)
			local all_tasks = core.get_all_tasks()
			local found_task, index = nil, -1
			for i, task in ipairs(all_tasks) do
				if task.name:lower():find(search_term:lower(), 1, true) then
					found_task = task
					index = i
					break
				end
			end

			if found_task then
				selected_task = index
				refresh_tasks()
				vim.api.nvim_win_set_cursor(tasks_popup.winid, { selected_task, 0 })
				update_scroll()
				vim.notify("Found task: " .. found_task.name, vim.log.levels.INFO)
			else
				vim.notify("No task found matching '" .. search_term .. "'", vim.log.levels.WARN)
			end
		end)
	end, keymap_opts)

	-- Show statistics
	tasks_popup:map("n", keymaps.show_stats, function()
		local stats = filters.get_stats(core.tasks)
		local message = string.format(
			"📊 Task Statistics:\n\n"
				.. "Total: %d tasks\n"
				.. "Completed: %d (%.1f%%)\n"
				.. "Incomplete: %d\n"
				.. "With tags: %d\n"
				.. "Total tags: %d",
			stats.total,
			stats.completed,
			stats.completion_rate,
			stats.incomplete,
			stats.with_tags,
			stats.total_tags
		)
		vim.notify(message, vim.log.levels.INFO, { title = "Opus Statistics", timeout = 8000 })
	end, keymap_opts)

	tasks_popup:map("n", keymaps.quit, function()
		layout:unmount()
		active_layout = nil
	end, keymap_opts)

	layout:mount()
	active_layout = layout
	refresh_tasks()
end

function ui.setup_commands()
	-- This is now handled by the NDE command suite
	-- The UI commands are integrated through :NDE opus [subcommand]
end

return ui
