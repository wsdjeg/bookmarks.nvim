local default = {
    sign_text = '=>',
    sign_hl_group = 'Normal'

}

return {
	setup = function(opt)
		return vim.tbl_deep_extend("force", default, opt or {})
	end,
}
