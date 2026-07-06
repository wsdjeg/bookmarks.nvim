# bookmarks.nvim

bookmarks.nvim is a simple bookmarks manager for neovim. It is inspired by [bookmarks.vim](https://github.com/wsdjeg/SpaceVim/tree/master/bundle/bookmarks.vim).

[![GitHub License](https://img.shields.io/github/license/wsdjeg/bookmarks.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/bookmarks.nvim)](https://github.com/wsdjeg/bookmarks.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/bookmarks.nvim)](https://github.com/wsdjeg/bookmarks.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/bookmarks.nvim)](https://github.com/wsdjeg/bookmarks.nvim/releases)

<!-- vim-markdown-toc GFM -->

- [Features](#features)
- [Installation](#installation)
    - [lazy.nvim](#lazynvim)
    - [nvim-plug](#nvim-plug)
- [Configuration](#configuration)
- [Mappings](#mappings)
- [Telescope extension](#telescope-extension)
- [Picker.nvim source](#pickernvim-source)
- [API](#api)
- [Self-Promotion](#self-promotion)
- [License](#license)

<!-- vim-markdown-toc -->

## Features

- Toggle bookmarks on any line
- Add annotations to bookmarks
- Navigate between bookmarks in current buffer
- List all bookmarks via quickfix list
- Telescope extension support
- Picker.nvim source support
- Bookmarks persist across sessions
- Auto-update bookmark positions when lines are modified

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'wsdjeg/bookmarks.nvim',
    keys = {
        { 'mm', '<Plug>(bookmarksToggle)', mode = 'n' },
        { 'mi', '<Plug>(bookmarksAnnotation)', mode = 'n' },
        { 'mn', '<Plug>(bookmarksNext)', mode = 'n' },
        { 'mp', '<Plug>(bookmarksPrevious)', mode = 'n' },
        { 'mc', '<Plug>(bookmarksClear)', mode = 'n' },
        { 'ma', '<Plug>(bookmarksListAll)', mode = 'n' },
    },
    opts = {
        sign_text = '=>',
        sign_hl_group = 'Normal',
    },
    dependencies = {
        'wsdjeg/notify.nvim',
        'wsdjeg/logger.nvim',
    },
}
```

### [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
    {
        'wsdjeg/bookmarks.nvim',
        keys = {
            { 'n', 'mm', '<Plug>(bookmarksToggle)', { noremap = false } },
            { 'n', 'mi', '<Plug>(bookmarksAnnotation)', { noremap = false } },
            { 'n', 'mn', '<Plug>(bookmarksNext)', { noremap = false } },
            { 'n', 'mc', '<Plug>(bookmarksClear)', { noremap = false } },
            { 'n', 'ma', '<Plug>(bookmarksListAll)', { noremap = false } },
            { 'n', 'mp', '<Plug>(bookmarksPrevious)', { noremap = false } },
        },
        opts = {
            sign_text = '=>',
            sign_hl_group = 'Normal',
        },
        depends = { { 'wsdjeg/notify.nvim' }, { 'wsdjeg/logger.nvim' } },
    },
})
```

## Configuration

The plugin can be configured by passing options to the `setup()` function or via the `opts` field in your package manager.

| Option | Type | Default | Description |
| ------ | ---- | ------- | ----------- |
| `sign_text` | string | `'=>'` | The sign text displayed in the sign column |
| `sign_hl_group` | string | `'Normal'` | The highlight group for the sign |

Example:

```lua
require('bookmarks').setup({
    sign_text = '⚑',      -- Use a bookmark symbol
    sign_hl_group = 'WarningMsg', -- Use a different highlight
})
```

## Mappings

| mappings                      | description                                 |
| ----------------------------- | ------------------------------------------- |
| `<Plug>(bookmarksToggle)`     | toggle bookmark of current line             |
| `<Plug>(bookmarksAnnotation)` | add annotation bookmark                     |
| `<Plug>(bookmarksNext)`       | jump to next bookmark in current buffer     |
| `<Plug>(bookmarksClear)`      | clear bookmarks in current buffer           |
| `<Plug>(bookmarksListAll)`    | list all bookmarks in quickfix window      |
| `<Plug>(bookmarksPrevious)`   | jump to previous bookmark in current buffer |

## Telescope extension

This plugin provides a telescope extension, which can be started using the `:Telescope bookmarks` command.

```vim
:Telescope bookmarks
```

## Picker.nvim source

This plugin also provides a source for [picker.nvim](https://github.com/wsdjeg/picker.nvim):

```vim
:Picker bookmarks
```

## API

You can also use the following Lua API in your own plugins:

```lua
local bookmarks = require('bookmarks')

-- Get all bookmarks
local all_bookmarks = bookmarks.get()

-- Toggle bookmark at current line
bookmarks.toggle()

-- Add bookmark with annotation
bookmarks.add(file, lnum, annotation, context)

-- Add annotation to current line
bookmarks.annotation()

-- Jump to next/previous bookmark in current buffer
bookmarks.next_bookmark()
bookmarks.previous_bookmark()

-- Clear all bookmarks in current buffer
bookmarks.clear()

-- List all bookmarks in quickfix window
bookmarks.setqflist()
```

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## License

This project is licensed under the GPL-3.0 License.
