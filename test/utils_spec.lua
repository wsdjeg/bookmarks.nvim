-- test/utils_spec.lua
local lu = require('luaunit')
local utils = require('bookmarks.utils')

TestUtils = {}

function TestUtils:testUnifyPathExists()
  lu.assertNotNil(utils.unify_path)
  lu.assertEquals(type(utils.unify_path), 'function')
end

function TestUtils:testUnifyPathBasic()
  local result = utils.unify_path('/some/test/file.txt')
  lu.assertEquals(type(result), 'string')
  lu.assertTrue(#result > 0)
end

function TestUtils:testUnifyPathRelative()
  local result = utils.unify_path('relative/path.txt')
  -- :p modifier should expand to absolute path
  lu.assertNotNil(result:match('^/'), 'Expected absolute path, got: ' .. result)
end

function TestUtils:testUnifyPathDirectory()
  -- Create a temp directory
  local tmpdir = vim.fn.tempname()
  vim.fn.mkdir(tmpdir, 'p')
  local result = utils.unify_path(tmpdir)
  -- Directory paths should end with /
  lu.assertEquals(result:sub(-1), '/', 'Directory path should end with /, got: ' .. result)
  -- Cleanup
  vim.fn.delete(tmpdir, 'rf')
end

function TestUtils:testUnifyPathWithTrailingSlash()
  local result = utils.unify_path('/some/test/')
  -- Should preserve trailing slash
  lu.assertEquals(result:sub(-1), '/', 'Path with trailing slash should end with /')
end

function TestUtils:testUnifyPathNoBackslash()
  local result = utils.unify_path('/some/test/file.txt')
  lu.assertNil(result:match('\\'), 'Path should not contain backslash')
end

return TestUtils

