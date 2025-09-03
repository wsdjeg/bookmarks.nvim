local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local conf = require('telescope.config').values
local entry_display = require('telescope.pickers.entry_display')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local util = require('bookmarks.utils')

local function get_all_bookmarks()
  local p = {}
  local bookmarks = require('bookmarks').get()

  for f, l in pairs(bookmarks) do
    for nr, b in pairs(l) do
      table.insert(p, {
        file = util.unify_path(f, ':.'),
        linenr = tonumber(string.match(nr, '%d+')),
        text = b.annotation or b.context,
      })
    end
  end
  return p
end

local function show_changes(opts)
  opts = opts or {}
  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = 80 },
      { remaining = true },
    },
  })
  local function make_display(entry)
    return displayer({
      { entry.value.file .. ':' .. entry.value.linenr, 'TelescopeResultsVariable' },
      { entry.value.text, 'TelescopeResultsComment' },
    })
  end
  pickers
    .new(opts, {
      prompt_title = 'Bookmarks',
      finder = finders.new_table({
        results = get_all_bookmarks(),
        entry_maker = function(entry)
          return {
            value = entry,
            display = make_display,
            ordinal = entry.file,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.cmd('e ' .. entry.value.file)
          -- vim.api.nvim_win_set_cursor(0, { entry.value.linenr, 1 })
          vim.cmd(entry.value.linenr)
        end)
        return true
      end,
    })
    :find()
end

local function run()
  show_changes()
end

return require('telescope').register_extension({
  exports = {
    bookmarks = run,
  },
})

