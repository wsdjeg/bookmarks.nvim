vim.keymap.set('n', '<Plug>(bookmarksToggle)', '', {
    callback = function()
        require('bookmarks').toggle()
    end,
    noremap = true,
})
