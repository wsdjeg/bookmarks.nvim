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
