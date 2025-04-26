local cache = vim.fn.stdpath("data") .. "\\bookmarks.nvim\\bookmarks.json"

local M = {}

function M.write(data)
	vim.fn.writefile({ vim.json.encode(data) }, cache)
end

function M.read()
	if vim.fn.filereadable(cache) == 1 then
		local data = table.concat(vim.fn.readfile(cache), "")
		if data ~= "" then
			return vim.json.decode(data)
		else
			return {}
		end
	else
		return {}
	end
end

return M
