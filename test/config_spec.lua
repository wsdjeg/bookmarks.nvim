-- test/config_spec.lua
local lu = require('luaunit')
local config_module = require('bookmarks.config')

TestConfig = {}

function TestConfig:testDefaultConfig()
  local cfg = config_module.setup()
  lu.assertEquals(cfg.sign_text, '=>')
  lu.assertEquals(cfg.sign_hl_group, 'Normal')
end

function TestConfig:testCustomSignText()
  local cfg = config_module.setup({
    sign_text = '★',
  })
  lu.assertEquals(cfg.sign_text, '★')
end

function TestConfig:testCustomSignHlGroup()
  local cfg = config_module.setup({
    sign_hl_group = 'BookmarkSign',
  })
  lu.assertEquals(cfg.sign_hl_group, 'BookmarkSign')
end

function TestConfig:testCustomAllOptions()
  local cfg = config_module.setup({
    sign_text = '>>',
    sign_hl_group = 'WarningMsg',
  })
  lu.assertEquals(cfg.sign_text, '>>')
  lu.assertEquals(cfg.sign_hl_group, 'WarningMsg')
end

function TestConfig:testEmptySetup()
  local cfg = config_module.setup({})
  lu.assertEquals(cfg.sign_text, '=>')
  lu.assertEquals(cfg.sign_hl_group, 'Normal')
end

function TestConfig.testSetupIsFunction()
  lu.assertEquals(type(config_module.setup), 'function')
end

return TestConfig

