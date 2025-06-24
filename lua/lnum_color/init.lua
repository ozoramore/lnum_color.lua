local lnum_colors = {
	["LineNrGroup1"] = "LineNrGroup1",
	["LineNrGroup2"] = "LineNrGroup2",
	["LineNrGroup3"] = "LineNrGroup3",
	["LineNrGroup4"] = "LineNrGroup4",
	["LineNrInterval"] = "LineNrInterval",
}

local def_hl = {
	["LineNrGroup1"] = { fg = "yellow" },
	["LineNrGroup2"] = { fg = "orange" },
	["LineNrGroup3"] = { fg = "lightred" },
	["LineNrGroup4"] = { fg = "red" },
	["LineNrInterval"] = { fg = "lightblue" },
}

local function color_def(tbl)
	for name, text in pairs(tbl) do
		vim.fn.sign_define(name, { numhl = text })
	end
end

local set_def_hl = function(tbl)
	for n, v in pairs(tbl) do
		if vim.fn.hlexists(n) == 0 then vim.api.nvim_set_hl(0, n, v) end
	end
end

local set_lnum_colors = function(name, lnum)
	vim.fn.sign_place(0, "LineNrGroup", name, vim.fn.expand("%p"), { lnum = lnum })
end

local function set_static_sign(interval, lnum)
	if lnum % interval == 0 then
		set_lnum_colors("LineNrInterval", lnum)
	end
end

local function set_dynamic_sign(get_name, lnum)
	local name = get_name(lnum, vim.api.nvim_win_get_cursor(0)[1])
	if name then set_lnum_colors(name, lnum) end
end

local function per_line_exec(func, prefunc, postfunc)
	if prefunc then prefunc() end
	for i = 1, vim.api.nvim_buf_line_count(0) do func(i) end
	if postfunc then postfunc() end
end

local M = {}

M.default = function(lnum, current_line)
	if lnum == current_line then return nil end
	local range = math.abs(lnum - current_line)
	if range == 1 then return 'LineNrGroup1' end
	if range == 2 then return 'LineNrGroup2' end
	if range == 3 then return 'LineNrGroup3' end
	if range == 4 then return 'LineNrGroup4' end
	return nil
end

local default_opts = {
	interval = 10,
	get_name = nil,
}

M.setup = function(opts)
	
	local final_opts = vim.tbl.deep_extend("force", default_opts, opts or {})


	set_def_hl(def_hl)
	color_def(lnum_colors)

	

	local prefunc = function() vim.fn.sign_unplace("LineNrGroup") end
	local numhl = function(i)
		if final_opts.interval and final_opts.interval ~= 0 then set_static_sign(final_opts.interval, i) end
		if final_opts.get_name then set_dynamic_sign(final_opts.get_name, i) end
	end

	local cb = { callback = function() per_line_exec(numhl, prefunc) end }
	local event = { "TextChanged", "BufRead", "BufNewFile", "CursorMoved", "CursorMovedI" }
	vim.api.nvim_create_autocmd(event, cb)
end

return M
