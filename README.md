# bookmarks.nvim

bookmarks.nvim is a simple bookmarks manager for neovim. It is inspired by [bookmarks.vim](https://github.com/wsdjeg/SpaceVim/tree/master/bundle/bookmarks.vim).

[![GitHub License](https://img.shields.io/github/license/wsdjeg/bookmarks.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/bookmarks.nvim)](https://github.com/wsdjeg/bookmarks.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/bookmarks.nvim)](https://github.com/wsdjeg/bookmarks.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/bookmarks.nvim)](https://github.com/wsdjeg/bookmarks.nvim/releases)

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
- [Setup](#setup)
- [Mappings](#mappings)
- [Telescope extension](#telescope-extension)
- [Picker.nvim source](#pickernvim-source)
- [Self-Promotion](#self-promotion)
- [License](#license)

<!-- vim-markdown-toc -->

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

## Mappings

| mappings                      | description                                 |
| ----------------------------- | ------------------------------------------- |
| `<Plug>(bookmarksToggle)`     | toggle bookmark of current line             |
| `<Plug>(bookmarksAnnotation)` | add annotation bookmark                     |
| `<Plug>(bookmarksNext)`       | jump to next bookmark in current buffer     |
| `<Plug>(bookmarksClear)`      | clear bookmarks in current buffer           |
| `<Plug>(bookmarksListAll)`    | list all bookmarks                          |
| `<Plug>(bookmarksPrevious)`   | jump to previous bookmark in current buffer |

## Telescope extension

This plugin also provides a telescope extension, which can be started using the `:Telescope bookmarks` command.

## Picker.nvim source

```
:Picker bookmarks
```

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## License

This project is licensed under the GPL-3.0 License.
