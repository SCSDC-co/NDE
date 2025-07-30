local ui = {}

local Layout = require("nui.layout")
local Popup = require("nui.popup")
local Input = require("nui.input")
local core = require("opus.core")

local active_layout = nil
local selected_task = 1
local tasks_popup = nil
local help_popup = nil

-- Helper to refresh the task display
local function refresh_tasks()
	if not tasks_popup then
		return
	end

	local lines = {}
	local width = 76 -- Fixed width for content area (80 - 4 for borders)

	if #core.tasks == 0 then
		table.insert(lines, " No tasks found. Press 'a' to add your first task!")
	else
		for idx, task in ipairs(core.tasks) do
			local status_icon = task.completed and "✓" or "✗"
			local selection_prefix = idx == selected_task and "▶" or " "

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
end

-- Helper to create and show the help pane
local function create_help_pane()
	local help_lines = {
		" j/k or ↑/↓  - Navigate tasks",
		" a           - Add new task",
		" <Enter>     - Toggle task completion",
		" r           - Rename selected task",
		" d           - Delete selected task",
		" t           - Add tag to task",
		" q/<Esc>     - Close Opus",
	}

	help_popup = Popup({
		border = { style = "rounded", text = { top = " ⚡ Commands " } },
		size = { height = #help_lines + 2 },
		buf_options = { modifiable = false, readonly = true, filetype = "opus-help" },
	})

	vim.api.nvim_buf_set_lines(help_popup.bufnr, 0, -1, false, help_lines)
	return help_popup
end

-- Helper to show input dialog
local function show_input(title, default_text, callback)
	local input = Input({
		position = "50%",
		size = { width = 50 },
		border = { style = "rounded", text = { top = " " .. title .. " " } },
		win_options = { winhighlight = "Normal:Normal,FloatBorder:Normal" },
	}, {
		prompt = "> ",
		default_value = default_text or "",
		on_close = function()
			if tasks_popup then
				vim.api.nvim_set_current_win(tasks_popup.winid)
			end
		end,
		on_submit = function(value)
			if value and #value > 0 then
				callback(value)
			end
			if tasks_popup then
				vim.api.nvim_set_current_win(tasks_popup.winid)
				refresh_tasks()
			end
		end,
	})
	input:mount()
end

-- Main function to show task manager
function ui.show_tasks()
	if active_layout then
		active_layout:unmount()
		active_layout = nil
	end

	selected_task = 1

	tasks_popup = Popup({
		enter = true,
		focusable = true,
		border = { style = "rounded", text = { top = " 📝 Opus Tasks " } },
		size = { height = 15 },
		buf_options = { modifiable = false, readonly = true, filetype = "opus-tasks" },
	})

	help_popup = create_help_pane()

	-- Calculate help panel size dynamically based on actual content
	local help_lines = {
		" j/k or ↑/↓  - Navigate tasks",
		" a           - Add new task",
		" <Enter>     - Toggle task completion",
		" r           - Rename selected task",
		" d           - Delete selected task",
		" t           - Add tag to task",
		" q/<Esc>     - Close Opus",
	}
	local help_size = #help_lines + 2 -- Add 2 for borders

	local layout = Layout(
		{
			position = "50%",
			size = { width = 80, height = 33 },
		},
		Layout.Box({
			Layout.Box(tasks_popup, { size = "70%" }),
			Layout.Box(help_popup, { size = "30%" }),
		}, { dir = "col" })
	)

	local keymap_opts = { noremap = true, silent = true }

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

	tasks_popup:map("n", { "j", "<Down>" }, function()
		if #core.tasks > 0 then
			selected_task = math.min(selected_task + 1, #core.tasks)
			refresh_tasks()
			update_scroll()
		end
	end, keymap_opts)

	tasks_popup:map("n", { "k", "<Up>" }, function()
		if #core.tasks > 0 then
			selected_task = math.max(selected_task - 1, 1)
			refresh_tasks()
			update_scroll()
		end
	end, keymap_opts)

	tasks_popup:map("n", "a", function()
		show_input("Add New Task", "", function(name)
			core.add_task({ name = name, completed = false, tags = {} })
		end)
	end, keymap_opts)

	tasks_popup:map("n", "r", function()
		if #core.tasks > 0 then
			show_input("Rename Task", core.tasks[selected_task].name, function(name)
				core.rename_task(selected_task, name)
			end)
		end
	end, keymap_opts)

	tasks_popup:map("n", "d", function()
		if #core.tasks > 0 then
			core.remove_task(selected_task)
			selected_task = math.max(1, math.min(selected_task, #core.tasks))
			refresh_tasks()
		end
	end, keymap_opts)

	tasks_popup:map("n", "t", function()
		if #core.tasks > 0 then
			show_input("Add Tag", "", function(tag)
				core.add_tag(selected_task, tag)
			end)
		end
	end, keymap_opts)

	tasks_popup:map("n", "<Enter>", function()
		if #core.tasks > 0 then
			local task = core.tasks[selected_task]
			task.completed = not task.completed
			core.save_tasks()
			refresh_tasks()
		end
	end, keymap_opts)

	tasks_popup:map("n", { "q", "<Esc>" }, function()
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
