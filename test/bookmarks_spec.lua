-- test/bookmarks_spec.lua
local lu = require('luaunit')
local bookmarks = require('bookmarks')
local cache = require('bookmarks.cache')
local utils = require('bookmarks.utils')

TestBookmarks = {}

function TestBookmarks:setUp()
  -- Use temp cache file (unique with hrtime)
  self.tmpfile = '/tmp/bookmarks_nvim_test_' .. tostring(vim.loop.hrtime()) .. '.json'
  cache.set_path(self.tmpfile)

  -- Re-setup with clean cache
  bookmarks.setup()

  -- Create a temp buffer with content
  self.tmpbuf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(self.tmpbuf, 0, -1, false, {
    'line 1',
    'line 2',
    'line 3',
    'line 4',
    'line 5',
  })
  -- Set buffer name so skip_buf returns false
  local tmpname = '/tmp/bookmarks_test_file_' .. tostring(self.tmpbuf) .. '.lua'
  vim.api.nvim_buf_set_name(self.tmpbuf, tmpname)
  -- Set buftype to empty (normal buffer)
  vim.bo[self.tmpbuf].buftype = ''
  -- Set as current buffer
  vim.api.nvim_set_current_buf(self.tmpbuf)
end

function TestBookmarks:tearDown()
  -- Clean up buffer
  if self.tmpbuf and vim.api.nvim_buf_is_valid(self.tmpbuf) then
    vim.api.nvim_buf_delete(self.tmpbuf, { force = true })
  end
  -- Clean up cache
  os.remove(self.tmpfile)
end

function TestBookmarks:testSetupReturnsModule()
  lu.assertNotNil(bookmarks)
  lu.assertEquals(type(bookmarks.setup), 'function')
  lu.assertEquals(type(bookmarks.toggle), 'function')
  lu.assertEquals(type(bookmarks.add), 'function')
  lu.assertEquals(type(bookmarks.clear), 'function')
  lu.assertEquals(type(bookmarks.get), 'function')
  lu.assertEquals(type(bookmarks.annotation), 'function')
  lu.assertEquals(type(bookmarks.next_bookmark), 'function')
  lu.assertEquals(type(bookmarks.previous_bookmark), 'function')
  lu.assertEquals(type(bookmarks.setqflist), 'function')
end

function TestBookmarks:testGetReturnsTable()
  local result = bookmarks.get()
  lu.assertEquals(type(result), 'table')
end

function TestBookmarks:testAddBookmark()
  local file = utils.unify_path(vim.api.nvim_buf_get_name(0))
  bookmarks.add(file, 1, '', 'line 1')

  local all = bookmarks.get()
  lu.assertNotNil(all[file])
  lu.assertNotNil(all[file]['line1'])
  lu.assertEquals(all[file]['line1'].lnum, 1)
  lu.assertEquals(all[file]['line1'].file, file)
end

function TestBookmarks:testAddBookmarkWithAnnotation()
  local file = utils.unify_path(vim.api.nvim_buf_get_name(0))
  bookmarks.add(file, 2, 'important note', 'line 2')

  local all = bookmarks.get()
  lu.assertNotNil(all[file]['line2'])
  lu.assertEquals(all[file]['line2'].annotation, 'important note')
end

function TestBookmarks:testToggleAddsBookmark()
  -- Move cursor to line 3
  vim.api.nvim_win_set_cursor(0, { 3, 0 })

  bookmarks.toggle()

  local file = utils.unify_path(vim.api.nvim_buf_get_name(0))
  local all = bookmarks.get()
  lu.assertNotNil(all[file])
  lu.assertNotNil(all[file]['line3'])
end

function TestBookmarks:testToggleRemovesBookmark()
  -- Add bookmark first
  local file = utils.unify_path(vim.api.nvim_buf_get_name(0))
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  bookmarks.toggle()

  -- Toggle again to remove
  bookmarks.toggle()

  local all = bookmarks.get()
  -- After removing, the line entry should be nil
  if all[file] then
    lu.assertNil(all[file]['line1'])
  end
end

function TestBookmarks:testClearBookmarks()
  local file = utils.unify_path(vim.api.nvim_buf_get_name(0))

  -- Add some bookmarks
  bookmarks.add(file, 1, '', 'line 1')
  bookmarks.add(file, 3, '', 'line 3')

  -- Clear all
  bookmarks.clear()

  local all = bookmarks.get()
  lu.assertNil(all[file])
end

function TestBookmarks:testClearOnEmptyBuffer()
  -- Should not crash when clearing a buffer with no bookmarks
  bookmarks.clear()
  local all = bookmarks.get()
  local file = utils.unify_path(vim.api.nvim_buf_get_name(0))
  lu.assertNil(all[file])
end

function TestBookmarks:testNextBookmark()
  local file = utils.unify_path(vim.api.nvim_buf_get_name(0))

  -- Add bookmarks at lines 2 and 4
  bookmarks.add(file, 2, '', 'line 2')
  bookmarks.add(file, 4, '', 'line 4')

  -- Move cursor to line 1
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  bookmarks.next_bookmark()

  -- Cursor should be at line 2
  local cursor = vim.api.nvim_win_get_cursor(0)
  lu.assertEquals(cursor[1], 2)
end

function TestBookmarks:testPreviousBookmark()
  local file = utils.unify_path(vim.api.nvim_buf_get_name(0))

  -- Add bookmarks at lines 2 and 4
  bookmarks.add(file, 2, '', 'line 2')
  bookmarks.add(file, 4, '', 'line 4')

  -- Move cursor to line 5
  vim.api.nvim_win_set_cursor(0, { 5, 0 })
  bookmarks.previous_bookmark()

  -- Cursor should be at line 4
  local cursor = vim.api.nvim_win_get_cursor(0)
  lu.assertEquals(cursor[1], 4)
end

function TestBookmarks:testNextBookmarkNoBookmarks()
  -- Should not crash when no bookmarks exist
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  bookmarks.next_bookmark()
  -- Cursor should stay at line 1
  local cursor = vim.api.nvim_win_get_cursor(0)
  lu.assertEquals(cursor[1], 1)
end

function TestBookmarks:testPreviousBookmarkNoBookmarks()
  -- Should not crash when no bookmarks exist
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  bookmarks.previous_bookmark()
  local cursor = vim.api.nvim_win_get_cursor(0)
  lu.assertEquals(cursor[1], 1)
end

function TestBookmarks:testSetqflist()
  local file = utils.unify_path(vim.api.nvim_buf_get_name(0))

  -- Add bookmarks
  bookmarks.add(file, 1, 'annotation 1', 'line 1')
  bookmarks.add(file, 3, '', 'line 3')

  -- Set quickfix list
  bookmarks.setqflist()

  -- Verify quickfix list has items
  local qf = vim.fn.getqflist()
  lu.assertTrue(#qf >= 2)
end

function TestBookmarks:testAddMultipleBookmarksSameFile()
  local file = utils.unify_path(vim.api.nvim_buf_get_name(0))

  bookmarks.add(file, 1, '', 'line 1')
  bookmarks.add(file, 2, '', 'line 2')
  bookmarks.add(file, 3, '', 'line 3')

  local all = bookmarks.get()
  lu.assertNotNil(all[file]['line1'])
  lu.assertNotNil(all[file]['line2'])
  lu.assertNotNil(all[file]['line3'])
end

function TestBookmarks:testBookmarkPersistsToCache()
  local file = utils.unify_path(vim.api.nvim_buf_get_name(0))
  bookmarks.add(file, 1, 'test annotation', 'line 1')

  -- Read directly from cache
  local cached = cache.read()
  lu.assertNotNil(cached[file])
  lu.assertNotNil(cached[file]['line1'])
  lu.assertEquals(cached[file]['line1'].annotation, 'test annotation')
end

return TestBookmarks

