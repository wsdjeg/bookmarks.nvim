local cache = vim.fn.stdpath('data') .. '/nvim-bookmarks.json'

local logger = require('bookmarks.logger')

local M = {}

--- Set cache file path (for testing)
--- @param path string
function M.set_path(path)
    cache = path
end

--- Get cache file path
--- @return string
function M.get_path()
    return cache
end

function M.write(data)
    -- Ensure parent directory exists
    local parent = vim.fn.fnamemodify(cache, ':h')
    if vim.fn.isdirectory(parent) == 0 then
        vim.fn.mkdir(parent, 'p')
    end
    vim.fn.writefile({ vim.json.encode(data) }, cache)
end

function M.read()
    if vim.fn.filereadable(cache) == 1 then
        local data = table.concat(vim.fn.readfile(cache), '')
        if data ~= '' then
            return vim.json.decode(data)
        else
            return {}
        end
    else
        logger.error(string.format('%s is not readable.', cache))
        return {}
    end
end

return M

