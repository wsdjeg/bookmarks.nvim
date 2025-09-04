local default = {
    sign_text = '=>',
    sign_hl_group = 'Normal'

}

--- @class BookmarksOpt
--- @field sign_text? string
--- @field sign_hl_group? string

return {
	setup = function(opt)
		return vim.tbl_deep_extend("force", default, opt or {})
	end,
}
