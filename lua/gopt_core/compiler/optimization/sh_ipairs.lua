local WriteLog = GOptCore.Api.WriteLog
local pattern = 'for(%s+)(.-),[%s+]?(.-)(%s+)in(%s+)ipairs([%s+]?)%((.-)%)[%s+]?do'
local new_line_char = '\n'

GOptCore.Api.RegisterScriptOptimizer('GOpt.Opt.IPairs', function(lua_object)
	-- WriteLog('[Optimization][GOpt.Opt.ipairs] > ', lua_object:GetFileName())

	local is_replaced = false
	local temp_value_index = 0
	local new_code = ''

	for line_index, code_line in lua_object:Pairs() do
		local temp_variable_name = 'v_gopt_tenp_ipairs_' .. temp_value_index
		local new_block = 'local ' .. temp_variable_name .. ' = %7; for %2 = 1, #' .. temp_variable_name .. ' do local %3 = ' .. temp_variable_name .. '[%2]; if not %3 then break end; '

		code_line, replaced_count = code_line:gsub(pattern, new_block, 1)
		new_code = new_code .. new_line_char .. code_line

		if not is_replaced and replaced_count > 0 then is_replaced = true end

		temp_value_index = temp_value_index + 1
	end

	if is_replaced then return end

	WriteLog('[Optimization] Change "ipairs" to "simple for" > ', lua_object:GetFilePath())

	lua_object:SetCode(new_code)
end)