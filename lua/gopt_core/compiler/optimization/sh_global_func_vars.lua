local table_HasValueBySeq = table.HasValueBySeq
-- local string_find = string.find
-- local string_format = string.format
local isfunction = isfunction
local WriteLog = GOptCore.Api.WriteLog
--
-- local new_line_char = '\n'
-- local var_format = 'local %s = %s'
local parse_pattern = '[%s]?(%w+)%(.-%)'
local exceptions_functions = {
	'FindMetaTable',
	'DamageInfo',
	'AddCSLuaFile',
	'include',
	'CreateConVar',
	'RunConsoleCommand',
	'print',
	'MsgN',
	'MsgC',
	'Msg',
	'MsgAll',
	'PrintMessage',
	'PrintTable',
	'SafeRemoveEntityDelayed',
	'PrecacheParticleSystem',
	'pcall',
	'ErrorNoHalt',
	'pcall',
	'error',
	'Color',
	'Angle',
	'Vector',
	'setmetatable',
	'getmetatable',
}

GOptCore.Api.RegisterScriptOptimizer('GOpt.Opt.GlobalFunctionsVariables', function(lua_object)
	local lua_code = lua_object:GetCode()
	local new_code = lua_code
	local header = ''
	local found_functions = {}

	for function_name, _ in lua_code:gmatch(parse_pattern) do
		if not function_name or not isfunction(_G[function_name]) then continue end
		if table_HasValueBySeq(exceptions_functions, function_name) then continue end
		if table_HasValueBySeq(found_functions, function_name) then continue end
		if lua_code:match('function ' .. function_name) then continue end
		if lua_code:match(function_name .. '[%s+]?=[%s+]?' .. function_name) then continue end
		found_functions[#found_functions + 1] = function_name
	end

	if #found_functions > 0 then
		header = 'local GOPT_GLOBAL_FUNCTIONS = {}\n'
		for i = 1, #found_functions do
			local function_name = found_functions[i]
			if lua_code:match('function ' .. function_name) then continue end
			local value_name = 'GOPT_GLOBAL_FUNCTIONS[' .. i .. ']'
			header = header .. value_name .. ' = ' .. function_name .. '\n'
			new_code = new_code:gsub('(%s)' .. function_name .. '%((.-)%)', '%1' .. value_name .. '(%2)')
			new_code = new_code:gsub('(%()' .. function_name .. '%((.-)%)', '%1' .. value_name .. '(%2)')
			-- new_code = new_code:Replace(function_name .. '(', value_name .. '(')
		end
	else
		return
	end

	WriteLog('[Optimization] Add global functions to the header > ', lua_object:GetFilePath())

	new_code = header .. new_code
	lua_object:SetCode(new_code)
end)

-- GOptCore.Api.RegisterScriptOptimizer('GOpt.Opt.GlobalFunctionsVariables', function(lua_object)
-- 	-- WriteLog('[Optimization][GOpt.Opt.GlobalFunctionsVariables] > ', lua_object:GetFileName())

-- 	local lua_code = lua_object:GetCode()
-- 	local new_code = lua_code
-- 	local header = ''
-- 	local registred_values = {}

-- 	local function OnSetValue(value_name)
-- 		if table_HasValueBySeq(registred_values, value_name) then return false end
-- 		registred_values[#registred_values + 1] = value_name
-- 		return true
-- 	end

-- 	local function InsertLocalValueToHeader(original_value, value_name, value_line)
-- 		header = header .. value_line .. new_line_char
-- 		new_code = new_code:gsub('(%s)' .. original_value .. '%((.-)%)', '%1' .. value_name .. '(%2)')
-- 	end

-- 	for function_name, _ in lua_code:gmatch(parse_pattern) do
-- 		if not function_name or not isfunction(_G[function_name]) then continue end
-- 		if table_HasValueBySeq(exceptions_functions, function_name) then continue end

-- 		local new_value_name = function_name
-- 		local new_local_value = string_format(var_format, new_value_name, function_name)
-- 		if string_find(new_code, new_local_value) or not OnSetValue(new_value_name) then continue end

-- 		InsertLocalValueToHeader(function_name, new_value_name, new_local_value)
-- 	end

-- 	if №header == 0 then return end

-- 	WriteLog('[Optimization] Add global functions to the header > ', lua_object:GetFilePath())

-- 	new_code = header .. new_code
-- 	lua_object:SetCode(new_code)
-- end)