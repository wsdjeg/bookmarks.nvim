-- test/example_spec.lua
-- Example test file demonstrating the test pattern for bookmarks.nvim

local lu = require('luaunit')
local bookmarks = require('bookmarks')
local cache = require('bookmarks.cache')

TestExample = {}

function TestExample:setUp()
  -- Use temp file for isolated cache
  self.tmpfile = vim.fn.tempname() .. '.json'
  cache.set_path(self.tmpfile)
  bookmarks.setup()
end

function TestExample:tearDown()
  os.remove(self.tmpfile)
end

function TestExample:testBookmarksModuleExists()
  lu.assertNotNil(bookmarks)
  lu.assertEquals(type(bookmarks), 'table')
end

function TestExample:testBasicArithmetic()
  lu.assertEquals(1 + 1, 2)
end

return TestExample

