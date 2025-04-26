# bookmarks.nvim

bookmarks.nvim is a simple bookmarks manager for neovim.

## Installation

with [nvim-plug](https://github.com/wsdjeg/nvim-plug):

```lua
require('plug').add({
    {
        'wsdjeg/bookmarks.nvim',
        config = function()
            vim.keymap.set('n', 'mm', '<Plug>(bookmarksToggle)', { noremap = false })
        end,
    },
})
```
