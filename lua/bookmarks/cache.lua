local cache = vim.fn.stdpath('data') .. '\\nvim-bookmarks.json'

local logger = require('code-runner.logger')

local M = {}

function M.write(data)
    if vim.fn.filereadable(cache) == 1 then
        vim.fn.writefile({ vim.json.encode(data) }, cache)
    else
        logger.error(string.format('%s is not readable.', cache))
    end
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
