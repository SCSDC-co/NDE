local json_utils = {}

-- Pretty print JSON with proper indentation
function json_utils.encode_pretty(data, indent)
    indent = indent or ""
    local next_indent = indent .. "    "
    
    if type(data) == "table" then
        if #data > 0 then
            -- Array
            local result = "[\n"
            for i, value in ipairs(data) do
                result = result .. next_indent .. json_utils.encode_pretty(value, next_indent)
                if i < #data then
                    result = result .. ","
                end
                result = result .. "\n"
            end
            result = result .. indent .. "]"
            return result
        else
            -- Object
            local result = "{\n"
            local keys = {}
            for k in pairs(data) do
                table.insert(keys, k)
            end
            table.sort(keys)
            
            for i, key in ipairs(keys) do
                local value = data[key]
                result = result .. next_indent .. '"' .. key .. '": ' .. json_utils.encode_pretty(value, next_indent)
                if i < #keys then
                    result = result .. ","
                end
                result = result .. "\n"
            end
            result = result .. indent .. "}"
            return result
        end
    elseif type(data) == "string" then
        return '"' .. data .. '"'
    elseif type(data) == "boolean" then
        return data and "true" or "false"
    elseif type(data) == "number" then
        return tostring(data)
    else
        return "null"
    end
end

return json_utils
