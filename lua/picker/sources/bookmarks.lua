local M = {}
local bookmarks = require('bookmarks')
local util = require('bookmarks.utils')

local previewer = require('picker.previewer.file')

function M.get()
    local p = {}

    for f, l in pairs(bookmarks.get()) do
        for nr, b in pairs(l) do
            table.insert(p, {
                file = util.unify_path(f, ':.'),
                linenr = tonumber(string.match(nr, '%d+')),
                text = b.annotation or b.context,
            })
        end
    end
    return vim.tbl_map(function(t)
        return {
            value = t,
            str = string.format('%s:%d:%s', t.file, t.linenr, t.text),
            highlight = {
                {
                    #t.file + #tostring(t.linenr) + 1,
                    #t.file + #tostring(t.linenr) + #t.text + 1,
                    'Comment',
                },
            },
        }
    end, p)
end

function M.default_action(entry)
    vim.cmd('edit ' .. entry.value.file)
    vim.cmd(tostring(entry.value.linenr))
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
    previewer.preview(item.value.file, win, buf, item.value.linenr)
end

return M
