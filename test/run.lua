-- test/run.lua
-- Test runner for headless Neovim

local lu = require('luaunit')

-- Add test directory to runtime path
vim.opt.runtimepath:append('.')

-- Setup package.path to support test submodules
package.path = 'test/?.lua;lua/?.lua;' .. package.path

-- Get test files based on PATTERN parameter
local function get_test_files()
  local pattern = _G.TEST_PATTERN
  _G.TEST_PATTERN = nil

  if not pattern or pattern == '' then
    local files = vim.split(vim.fn.globpath('test', '**/*_spec.lua'), '\n')
    if files[#files] == '' then
      table.remove(files)
    end
    return files
  end

  local files = {}

  if pattern:match('^test/') or pattern:match('^test\\') then
    if vim.fn.filereadable(pattern) == 1 then
      table.insert(files, pattern)
    else
      print(string.format('[ERROR] Test file not found: %s', pattern))
      return {}
    end
  else
    files = vim.split(vim.fn.globpath('test', string.format('**/*%s*_spec.lua', pattern)), '\n')
    if #files == 0 then
      files = vim.split(vim.fn.globpath('test', string.format('%s*_spec.lua', pattern)), '\n')
    end
    if #files == 0 then
      files = vim.split(vim.fn.globpath('test', string.format('**/%s_spec.lua', pattern)), '\n')
    end
    local filtered = {}
    for _, f in ipairs(files) do
      if f ~= '' then
        table.insert(filtered, f)
      end
    end
    files = filtered
  end

  return files
end

-- Run all tests
local function run_tests()
  local test_files = get_test_files()

  print('=== bookmarks.nvim Test Suite ===')
  if _G.TEST_PATTERN and _G.TEST_PATTERN ~= '' then
    print(string.format('Filter: %s', _G.TEST_PATTERN))
  end
  print(string.format('Found %d test file(s)\n', #test_files))

  if #test_files == 0 then
    print('[ERROR] No test files found')
    return 1
  end

  local loaded_count = 0
  local failed_count = 0

  for _, test_file in ipairs(test_files) do
    local ok, err = pcall(dofile, test_file)
    if ok then
      print(string.format('[OK] Loaded: %s', test_file))
      loaded_count = loaded_count + 1
    else
      print(string.format('[FAIL] Failed to load: %s', test_file))
      print(string.format('  Error: %s', err))
      failed_count = failed_count + 1
    end
  end

  print(
    string.format(
      '\n=== Loaded %d/%d test files ===',
      loaded_count,
      #test_files
    )
  )

  if failed_count > 0 then
    print(string.format('[ERROR] Failed to load %d test files', failed_count))
    return 1
  end

  print('\nRunning tests...\n')
  local runner = lu.LuaUnit:new()
  runner:setOutputType('tap')
  local result = runner:runSuite()

  return result
end

local exit_code = run_tests()

os.exit(exit_code)

