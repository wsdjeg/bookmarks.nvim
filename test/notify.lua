-- test/notify.lua
-- Mock notify module for testing

local M = {}

M.messages = {}

function M.notify(msg, level, opts)
  table.insert(M.messages, msg)
  return M
end

function M.reset()
  M.messages = {}
end

return M

