local M = {}
local cache_manager = require("bookmarks.cache")
local logger = require("bookmarks.logger")
local config = require("bookmarks.config")
local notify = require("notify")
local ns = vim.api.nvim_create_namespace("bookmarks.nvim")

local bookmarks

local function skip_current_buf()
	if vim.fn.bufname() == "" then
		return true
	elseif vim.o.buftype ~= "" then
		return true
	else
		return false
	end
end

function M.add(file, lnum, text, ...)
	logger.info("add bookmarks:")
	logger.info("         file:" .. file)
	logger.info("         lnum:" .. lnum)
	logger.info("         text:" .. text)
	-- logger.info('        a:000:' .. string(a:000))
	if not bookmarks then
		M.setup()
	end
	if not bookmarks[file] then
		bookmarks[file] = {}
	end

	local opt = { sign_text = config.sign_text, sign_hl_group = config.sign_hl_group }

	if text and text ~= "" then
		opt.virt_text = { { text, "Comment" } }
	end

	vim.api.nvim_buf_set_extmark(0, ns, lnum, 0, opt)
end

function M.setup(opt)
	bookmarks = cache_manager.read()

	config = require("bookmarks.config").setup(opt)
end

return M
