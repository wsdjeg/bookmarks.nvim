# bookmarks.nvim

bookmarks.nvim is a simple bookmarks manager for neovim. It is inspired by [bookmarks.vim](https://github.com/wsdjeg/SpaceVim/tree/master/bundle/bookmarks.vim).

## Installation

with [nvim-plug](https://github.com/wsdjeg/nvim-plug):

```lua
require('plug').add({
    {
        'wsdjeg/bookmarks.nvim',
        config = function()
            vim.keymap.set('n', 'mm', '<Plug>(bookmarksToggle)', { noremap = false })
            vim.keymap.set('n', 'mi', '<Plug>(bookmarksAnnotation)', { noremap = false })
            vim.keymap.set('n', 'mn', '<Plug>(bookmarksNext)', { noremap = false })
            vim.keymap.set('n', 'mc', '<Plug>(bookmarksClear)', { noremap = false })
            vim.keymap.set('n', 'ma', '<Plug>(bookmarksListAll)', { noremap = false })
            vim.keymap.set('n', 'mp', '<Plug>(bookmarksPrevious)', { noremap = false })
            require('bookmarks').setup()
        end,
        depends = { { 'wsdjeg/notify.nvim' }, { 'wsdjeg/logger.nvim' } },
    },
})
```

## Setup

```lua
require('bookmarks').setup({
    sign_text = '=>',
    sign_hl_group = 'Normal',
})
```

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg) and
[Twitter](http://twitter.com/wsdtty).

## License

This project is licensed under the GPL-3.0 License.
