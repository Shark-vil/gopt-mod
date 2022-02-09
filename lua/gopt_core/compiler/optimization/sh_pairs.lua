local WriteLog = GOptCore.Api.WriteLog
local pattern = 'for(%s+)(.-),[%s+]?(.-)(%s+)in(%s+)pairs([%s+]?)%((.-)%)[%s+]?do'
local new_line_char = '\n'

GOptCore.Api.RegisterScriptOptimizer('GOpt.Opt.Pairs', function(lua_object)
	-- WriteLog('[Optimization][GOpt.Opt.pairs] > ', lua_object:GetFileName())

	local is_replaced = false
	local temp_value_index = 0
	local new_code = ''

	for line_index, code_line in lua_object:Pairs() do
		local temp_variable_name = 'v_gopt_tenp_pairs_' .. temp_value_index
		local new_block = 'local ' .. temp_variable_name .. ' = %7; for %2, %3 in next, ' .. temp_variable_name .. ' do '

		code_line, replaced_count = code_line:gsub(pattern, new_block, 1)
		new_code = new_code .. new_line_char .. code_line

		if not is_replaced and replaced_count > 0 then is_replaced = true end

		temp_value_index = temp_value_index + 1
	end

	if not is_replaced then return end

	WriteLog('[Optimization] Change "pairs" to "next" > ', lua_object:GetFilePath())

	lua_object:SetCode(new_code)
end)