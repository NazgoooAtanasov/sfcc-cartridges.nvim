local M = {}

function os.capture(cmd)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    return s
end

local check_dw_dir = function ()
    local dw_json = io.open("./dw.json", "r")

    if dw_json ~= nil then
        io.close(dw_json)
        return true
    end

    return false
end

local split = function(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local index_of = function(table, searched_value)
    for idx, value in ipairs(table) do
        if value == searched_value then return idx end
    end

    return -1;
end

local join_table_for_path = function (table, join)
    local str = "*/"

    for index, value in ipairs(table) do
        if index == #table then
            str = str..value
        else
            str = str..value..join
        end
    end

    return str
end

local get_cartridge_files = function ()
    local out = os.capture("find . \\( -name \"build-suite\" -o -name \"node_modules\" -o -name \"test\" -o -name \"static\" -o -name \"client\" \\) -prune -o -name \"*.js\"")
    local full_file_paths = split(out, "\n")

    local file_paths = {}
    for _, value in ipairs(full_file_paths) do
        value = string.gsub(value, ".js", "") -- removing the file extension from the string
        local file_path_split = split(value, "/")
        local cartridge_str_idx = index_of(file_path_split, "cartridge")

        local path = join_table_for_path({ unpack(file_path_split, cartridge_str_idx, #file_path_split) }, "/")
        table.insert(file_paths, {
            label = path,
            insertText = "const "..file_path_split[#file_path_split].." = require('"..path.."');"
        })
    end

    return file_paths
end

local source = {
    require_suggestions = nil
}

function source:is_available()
    return true
end

function source:complete(_, callback)
    if check_dw_dir() then
        if source.require_suggestions == nil then
            -- at some point that caching thing has to be revalidated
            source.require_suggestions = get_cartridge_files()
        end

        callback(source.require_suggestions)
    else
        callback({})
    end
end

function source:execute(completion_item, callback)
    callback(completion_item)
end

function M.setup(opts)
    require('cmp').register_source(
        opts.sourceName ~= nil and opts.sourceName or 'sfcc',
        source
    )
end

return M
