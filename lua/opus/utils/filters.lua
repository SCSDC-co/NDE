local filters = {}

-- Filter tasks by completion status
function filters.by_completion(tasks, completed)
    local filtered = {}
    for _, task in ipairs(tasks) do
        if task.completed == completed then
            table.insert(filtered, task)
        end
    end
    return filtered
end

-- Filter tasks by tag
function filters.by_tag(tasks, tag)
    local filtered = {}
    for _, task in ipairs(tasks) do
        if task.tags then
            for _, task_tag in ipairs(task.tags) do
                if task_tag == tag then
                    table.insert(filtered, task)
                    break
                end
            end
        end
    end
    return filtered
end

-- Search tasks by name (case insensitive)
function filters.by_name(tasks, search_term)
    local filtered = {}
    local lower_search = search_term:lower()
    for _, task in ipairs(tasks) do
        if task.name and task.name:lower():find(lower_search, 1, true) then
            table.insert(filtered, task)
        end
    end
    return filtered
end

-- Get all unique tags from tasks
function filters.get_all_tags(tasks)
    local tags = {}
    local tag_set = {}
    
    for _, task in ipairs(tasks) do
        if task.tags then
            for _, tag in ipairs(task.tags) do
                if not tag_set[tag] then
                    tag_set[tag] = true
                    table.insert(tags, tag)
                end
            end
        end
    end
    
    table.sort(tags)
    return tags
end

-- Sort tasks by name
function filters.sort_by_name(tasks, ascending)
    ascending = ascending ~= false -- default to true
    local sorted = vim.deepcopy(tasks)
    table.sort(sorted, function(a, b)
        if ascending then
            return (a.name or ""):lower() < (b.name or ""):lower()
        else
            return (a.name or ""):lower() > (b.name or ""):lower()
        end
    end)
    return sorted
end

-- Sort tasks by completion status (incomplete first by default)
function filters.sort_by_completion(tasks, completed_first)
    completed_first = completed_first or false
    local sorted = vim.deepcopy(tasks)
    table.sort(sorted, function(a, b)
        if completed_first then
            return (a.completed and 1 or 0) > (b.completed and 1 or 0)
        else
            return (a.completed and 1 or 0) < (b.completed and 1 or 0)
        end
    end)
    return sorted
end

-- Get task statistics
function filters.get_stats(tasks)
    local total = #tasks
    local completed = 0
    local with_tags = 0
    local total_tags = 0
    
    for _, task in ipairs(tasks) do
        if task.completed then
            completed = completed + 1
        end
        if task.tags and #task.tags > 0 then
            with_tags = with_tags + 1
            total_tags = total_tags + #task.tags
        end
    end
    
    return {
        total = total,
        completed = completed,
        incomplete = total - completed,
        with_tags = with_tags,
        total_tags = total_tags,
        completion_rate = total > 0 and (completed / total * 100) or 0
    }
end

return filters
