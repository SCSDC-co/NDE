local core = {}
local json_utils = require("opus.utils.json")
local config = require("opus.config")

-- Path to the tasks JSON file
core.tasks_file = vim.fn.stdpath("data") .. "/nde/opus.json"

-- Task list
core.tasks = {}

-- Load tasks from JSON file
function core.load_tasks()
    local ok, content = pcall(vim.fn.readfile, core.tasks_file)
    if ok and #content > 0 then
        local success, decoded = pcall(vim.json.decode, table.concat(content, "\n"))
        if success then
            core.tasks = decoded
        else
            vim.notify("Failed to decode tasks JSON: "..decoded, vim.log.levels.ERROR)
        end
    end
end

-- Save tasks to JSON file
function core.save_tasks()
    -- Ensure data directory exists
    local data_dir = vim.fn.stdpath("data") .. "/nde"
    vim.fn.mkdir(data_dir, "p")
    
    local encoded = json_utils.encode_pretty(core.tasks)
    local file = io.open(core.tasks_file, "w")
    if file then
        file:write(encoded)
        file:close()
    end
end

-- Functionality to add, remove, complete, rename tasks and add tags
function core.add_task(task)
    local task_defaults = config.get("task_defaults")
    task = vim.tbl_deep_extend("force", vim.deepcopy(task_defaults), task)
    table.insert(core.tasks, task)
    core.save_tasks()
end

function core.remove_task(index)
    table.remove(core.tasks, index)
    core.save_tasks()
end

function core.complete_task(index)
    if core.tasks[index] then
        core.tasks[index].completed = true
        core.save_tasks()
    end
end

function core.rename_task(index, new_name)
    if core.tasks[index] then
        core.tasks[index].name = new_name
        core.save_tasks()
    end
end

function core.add_tag(index, tag)
    if core.tasks[index] then
        core.tasks[index].tags = core.tasks[index].tags or {}
        table.insert(core.tasks[index].tags, tag)
        core.save_tasks()
    end
end

-- Remove a tag from a task
function core.remove_tag(index, tag)
    if core.tasks[index] and core.tasks[index].tags then
        for i, task_tag in ipairs(core.tasks[index].tags) do
            if task_tag == tag then
                table.remove(core.tasks[index].tags, i)
                break
            end
        end
        core.save_tasks()
    end
end

-- Toggle task completion
function core.toggle_task(index)
    if core.tasks[index] then
        core.tasks[index].completed = not core.tasks[index].completed
        core.save_tasks()
    end
end

-- Get task by index
function core.get_task(index)
    return core.tasks[index]
end

-- Get all tasks
function core.get_all_tasks()
    return core.tasks
end

-- Clear all completed tasks
function core.clear_completed()
    local new_tasks = {}
    for _, task in ipairs(core.tasks) do
        if not task.completed then
            table.insert(new_tasks, task)
        end
    end
    core.tasks = new_tasks
    core.save_tasks()
    return #core.tasks
end

-- Initialize core with configuration
function core.setup(user_config)
    config.setup(user_config)
    core.tasks_file = config.get("tasks_file")
end

return core


