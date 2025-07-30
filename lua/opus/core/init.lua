local core = {}

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
    local encoded = vim.json.encode(core.tasks)
    local file = io.open(core.tasks_file, "w")
    if file then
        file:write(encoded)
        file:close()
    end
end

-- Functionality to add, remove, complete, rename tasks and add tags
function core.add_task(task)
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

return core


