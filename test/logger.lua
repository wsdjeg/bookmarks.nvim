-- test/logger.lua
-- Mock logger.nvim module for testing

local M = {}

function M.derive(name)
  return {
    info = function(msg) end,
    debug = function(msg) end,
    warn = function(msg) end,
    error = function(msg) end,
  }
end

return M

