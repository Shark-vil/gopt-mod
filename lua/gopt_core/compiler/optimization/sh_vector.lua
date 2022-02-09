local WriteLog = GOptCore.Api.WriteLog
local table_HasValueBySeq = table.HasValueBySeq
-- local string_format = string.format
local pattern = '([^%w]Vector%([%s-]?%d+[%s-]?%,[%s-]?%d+[%s-]?,[%s-]?%d+[%s-]?%))'
-- local new_line_char = '\n'

GOptCore.Api.RegisterScriptOptimizer('GOpt.Opt.Vector', function(lua_object)
	-- WriteLog('[Optimization][GOpt.Opt.Color] > ', lua_object:GetFileName())

	local found_vectors = {}
	local header = ''
	local new_code = lua_object:GetCode()

	for match_var in new_code:gmatch(pattern) do
		match_var = match_var:sub(2)
		if table_HasValueBySeq(found_vectors, match_var) then continue end
		found_vectors[#found_vectors + 1] = match_var
	end

	if #found_vectors > 0 then
		header = 'local GOPT_VECTORS_VARS = {}\n'
		for i = 1, #found_vectors do
			local vector_name = found_vectors[i]
			local value_name = 'GOPT_VECTORS_VARS[' .. i .. ']'
			header = header .. value_name .. ' = ' .. vector_name .. '\n'
			-- new_code = new_code:gsub(vector_name, value_name)
			new_code = new_code:Replace(vector_name, value_name)
		end
	else
		return
	end

	WriteLog('[Optimization] Vectors caching > ', lua_object:GetFilePath())

	new_code = header .. new_code
	lua_object:SetCode(new_code)
end)

-- GOptCore.Api.RegisterScriptOptimizer('GOpt.Opt.Vector', function(lua_object)
-- 	-- WriteLog('[Optimization][GOpt.Opt.Vector] > ', lua_object:GetFileName())

-- 	local is_replaced = false
-- 	local exists_variables = {}
-- 	local temp_value_index = 0
-- 	local header = ''
-- 	local new_code = ''

-- 	for line_index, code_line in lua_object:Pairs() do
-- 		local temp_variable_name = 'v_gopt_vector_' .. temp_value_index
-- 		local temp_code_line = code_line

-- 		for match_var in code_line:gmatch(pattern) do
-- 			local first_char = match_var:sub(1, 1)
-- 			match_var = match_var:sub(2)

-- 			if exists_variables[match_var] then
-- 				temp_variable_name = exists_variables[match_var]
-- 			end

-- 			local new_local_value = string_format('local %s = %s', temp_variable_name, match_var)
-- 			temp_code_line, replaced_count = temp_code_line:gsub(pattern, first_char .. temp_variable_name, 1)

-- 			if replaced_count ~= 0 and not exists_variables[match_var] then
-- 				header = header .. new_local_value .. new_line_char
-- 				exists_variables[match_var] = temp_variable_name
-- 			end

-- 			if not is_replaced and replaced_count > 0 then is_replaced = true end

-- 			temp_value_index = temp_value_index + 1
-- 		end

-- 		new_code = new_code .. temp_code_line .. new_line_char
-- 	end

-- 	if not is_replaced then return end

-- 	WriteLog('[Optimization] Vectors caching > ', lua_object:GetFilePath())

-- 	new_code = header .. new_code
-- 	lua_object:SetCode(new_code)
-- end)