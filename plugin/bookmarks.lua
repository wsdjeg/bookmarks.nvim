vim.keymap.set('n', '<Plug>(bookmarksToggle)', '', {
    callback = function()
        require('bookmarks').toggle()
    end,
    noremap = true,
})
vim.keymap.set('n', '<Plug>(bookmarksAnnotation)', '', {
    callback = function()
        require('bookmarks').annotation()
    end,
    noremap = true,
})
vim.keymap.set('n', '<Plug>(bookmarksNext)', '', {
    callback = function()
        require('bookmarks').next_bookmark()
    end,
    noremap = true,
})
vim.keymap.set('n', '<Plug>(bookmarksPrevious)', '', {
    callback = function()
        require('bookmarks').previous_bookmark()
    end,
    noremap = true,
})
vim.keymap.set('n', '<Plug>(bookmarksClear)', '', {
    callback = function()
        require('bookmarks').clear()
    end,
    noremap = true,
})
vim.keymap.set('n', '<Plug>(bookmarksListAll)', '', {
    callback = function()
        require('bookmarks').setqflist()
    end,
    noremap = true,
})
