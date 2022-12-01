local M = {}

local source = {}

function source:is_available()
    return true
end

function source:complete(params, callback)
    callback({
      { label = 'app_acne_sfra' },
    })
end

function source:execute(completion_item, callback)
    callback(completion_item)
end

require('cmp').register_source('sfcc', source)

return M
