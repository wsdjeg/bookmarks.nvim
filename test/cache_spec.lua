-- test/cache_spec.lua
local lu = require('luaunit')
local cache = require('bookmarks.cache')

TestCache = {}

function TestCache:setUp()
  -- Use a temp file for each test (unique with hrtime)
  self.tmpfile = '/tmp/bookmarks_nvim_test_cache_' .. tostring(vim.loop.hrtime()) .. '.json'
  cache.set_path(self.tmpfile)
end

function TestCache:tearDown()
  -- Clean up temp file
  os.remove(self.tmpfile)
end

function TestCache:testWriteAndRead()
  local data = {
    ['/tmp/test.lua'] = {
      ['line1'] = { file = '/tmp/test.lua', lnum = 1, sign_id = 1 },
    },
  }

  cache.write(data)
  local result = cache.read()

  lu.assertNotNil(result)
  lu.assertNotNil(result['/tmp/test.lua'])
  lu.assertNotNil(result['/tmp/test.lua']['line1'])
  lu.assertEquals(result['/tmp/test.lua']['line1'].lnum, 1)
  lu.assertEquals(result['/tmp/test.lua']['line1'].file, '/tmp/test.lua')
end

function TestCache:testWriteNewFile()
  -- Write to a file that doesn't exist yet
  local data = { test = 'value' }
  cache.write(data)
  lu.assertTrue(vim.fn.filereadable(self.tmpfile) == 1)
end

function TestCache:testReadEmpty()
  local result = cache.read()
  -- Non-existent file should return empty table
  lu.assertEquals(result, {})
end

function TestCache:testWriteEmptyTable()
  cache.write({})
  local result = cache.read()
  lu.assertEquals(result, {})
end

function TestCache:testWriteComplexData()
  local data = {
    ['/path/to/file.lua'] = {
      ['line5'] = {
        file = '/path/to/file.lua',
        lnum = 5,
        sign_id = 100,
        annotation = 'important function',
      },
      ['line10'] = {
        file = '/path/to/file.lua',
        lnum = 10,
        sign_id = 101,
      },
    },
  }

  cache.write(data)
  local result = cache.read()

  lu.assertEquals(result['/path/to/file.lua']['line5'].annotation, 'important function')
  lu.assertEquals(result['/path/to/file.lua']['line5'].sign_id, 100)
  lu.assertEquals(result['/path/to/file.lua']['line10'].sign_id, 101)
end

function TestCache:testOverwrite()
  cache.write({ key = 'value1' })
  cache.write({ key = 'value2' })
  local result = cache.read()
  lu.assertEquals(result.key, 'value2')
end

function TestCache:testSetPathGetPath()
  local path = '/tmp/test_custom_path.json'
  cache.set_path(path)
  lu.assertEquals(cache.get_path(), path)
end

return TestCache

