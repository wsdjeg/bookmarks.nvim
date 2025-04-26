local M = {}
local cache_manager = require('bookmarks.cache')
local logger = require('bookmarks.logger')
local config = require('bookmarks.config')
local notify = require('notify')
local ns = vim.api.nvim_create_namespace('bookmarks.nvim')
local util = require('bookmarks.utils')

local bookmarks

local function skip_current_buf()
    if vim.fn.bufname() == '' then
        return true
    elseif vim.o.buftype ~= '' then
        return true
    else
        return false
    end
end

local function has_annotation(file, lnum)
    return bookmarks
        and bookmarks[file]
        and bookmarks[file]['line' .. lnum]
        and bookmarks[file]['line' .. lnum]['annotation']
end

function M.add(file, lnum, text, ...)
    logger.info('add bookmarks:')
    logger.info('         file:' .. file)
    logger.info('         lnum:' .. lnum)
    logger.info('         text:' .. (text or ''))
    -- logger.info('        a:000:' .. string(a:000))
    if not bookmarks then
        M.setup()
    end
    if not bookmarks[file] then
        bookmarks[file] = {}
    end

    local opt = { sign_text = config.sign_text, sign_hl_group = config.sign_hl_group }

    if text and text ~= '' then
        opt.virt_text = { { text, 'Comment' } }
    end

    local extmark_id = vim.api.nvim_buf_set_extmark(0, ns, lnum - 1, 0, opt)
    bookmarks[file]['line' .. lnum] = {
        file = file,
        lnum = lnum,
        sign_id = extmark_id,
    }
    if text and text ~= '' then
        bookmarks[file]['line' .. lnum].annotation = text
    end
    cache_manager.write(bookmarks)
    notify.notify('bookmark added.')
end

function M.setup(opt)
    bookmarks = cache_manager.read()

    config = require('bookmarks.config').setup(opt)

    local augroup = vim.api.nvim_create_augroup('bookmarks.nvim', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = { '*' },
        group = augroup,
        callback = function(ev)
            if skip_current_buf() or vim.b[ev.buf].bookmarks_init then
                return
            end
            local f = util.unify_path(vim.api.nvim_buf_get_name(ev.buf))
            if bookmarks[f] then
                for _, bookmark in pairs(bookmarks[f]) do
                    bookmarks.sign_id =
                        vim.api.nvim_buf_set_extmark(ev.buf, ns, bookmark.lnum - 1, 0, {
                            sign_text = config.sign_text,
                            sign_hl_group = config.sign_hl_group,
                            virt_text = { { bookmark.annotation or '', 'Comment' } },
                        })
                end
            end
            vim.api.nvim_buf_set_var(ev.buf, 'bookmarks_init', true)
        end,
    })
end
--- Add bookmark with annotation
function M.annotation()
    if skip_current_buf() then
        return
    end
    local f = util.unify_path(vim.api.nvim_buf_get_name(0))
    local lnum = vim.fn.line('.')
    if has_annotation(f, lnum) then
        local annotation = vim.fn.input({
            prompt = 'Annotation:',
            default = bookmarks[f]['line' .. lnum].annotation,
            cancelreturn = '',
        })
        if annotation ~= '' then
            local sign_id = bookmarks[f]['line' .. lnum].sign_id
            vim.api.nvim_buf_set_extmark(0, ns, lnum - 1, 0, {
                id = sign_id,
                sign_text = config.sign_text,
                sign_hl_group = config.sign_hl_group,
                virt_text = { { annotation, 'Comment' } },
            })
            bookmarks[f]['line' .. lnum] = {
                file = f,
                lnum = lnum,
                sign_id = sign_id,
                annotation = annotation,
            }
        else
            notify.notify('canceled, no changes.')
        end
    else
        local annotation = vim.fn.input({
            prompt = 'Annotation:',
            cancelreturn = '',
        })
        if annotation ~= '' then
            M.add(f, lnum, annotation)
        else
            notify.notify('empty annotation, skipped!')
        end
    end
end

function M.toggle()
    if skip_current_buf() then
        return
    end
    local f = util.unify_path(vim.api.nvim_buf_get_name(0))
    local lnum = vim.fn.line('.')
    if bookmarks and bookmarks[f] and bookmarks[f]['line' .. lnum] then
        vim.api.nvim_buf_del_extmark(0, ns, bookmarks[f]['line' .. lnum].sign_id)
        bookmarks[f]['line' .. lnum] = nil
        notify.notify('bookmark deleted.')
    else
        M.add(f, lnum)
    end
end

function M.next_bookmark()
    if skip_current_buf() then
        return
    end
    local f = util.unify_path(vim.api.nvim_buf_get_name(0))
    if bookmarks and bookmarks[f] then
        local bms = {}
        for _, v in pairs(bookmarks[f]) do
            table.insert(bms, v)
        end
        table.sort(bms, function(a, b)
            return a.lnum < b.lnum
        end)
        for _, v in ipairs(bms) do
            if v.lnum > vim.fn.line('.') then
                vim.cmd(tostring(v.lnum))
                return
            end
        end
    end
end

function M.previous_bookmark()
    if skip_current_buf() then
        return
    end
    local f = util.unify_path(vim.api.nvim_buf_get_name(0))
    if bookmarks and bookmarks[f] then
        local bms = {}
        for _, v in pairs(bookmarks[f]) do
            table.insert(bms, v)
        end
        table.sort(bms, function(a, b)
            return a.lnum > b.lnum
        end)
        for _, v in ipairs(bms) do
            if v.lnum < vim.fn.line('.') then
                vim.cmd(tostring(v.lnum))
                return
            end
        end
    end
end

function M.clear()
    if skip_current_buf() then
        return
    end
    local f = util.unify_path(vim.api.nvim_buf_get_name(0))
    if bookmarks and bookmarks[f] then
        for _, v in pairs(bookmarks[f]) do
            vim.api.nvim_buf_del_extmark(0, ns, v.sign_id)
        end
        bookmarks[f] = nil
        cache_manager.write(bookmarks)
    end
end

return M
