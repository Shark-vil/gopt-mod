local table_HasValueBySeq = table.HasValueBySeq
-- local string_format = string.format
local istable = istable
local isfunction = isfunction
local WriteLog = GOptCore.Api.WriteLog
--
-- local new_line_char = '\n'
local parse_pattern = '[%s]?(%w+)%.(%w+)%(.-%)'
-- local var_format = 'local %s = %s'
local whitelist_libraries = {
	'util',
	'surface',
	'cam',
	'math',
	'player',
	'ents',
	'table',
	'net',
	'render',
	'sql',
	'file',
	'holo',
	'gui',
	'draw',
	'matproxy',
	'os',
	'saverestore',
	'gamemode',
	'engine',
	'system',
	'timer',
	'gmod',
	'cookie',
	'game',
	'gmsave',
	'debugoverlay',
}

local exceptions_libraries = {
	'util.AddNetworkString',
	'util.PrecacheModel',
	'surface.CreateFont',
	'surface.GetTextureID',
	'surface.CreateFont',
}

GOptCore.Api.RegisterScriptOptimizer('GOpt.Opt.LibraryVariables', function(lua_object)
	-- WriteLog('[Optimization][GOpt.Opt.LibraryVariables] > ', lua_object:GetFileName())

	local lua_code = lua_object:GetCode()
	local new_code = lua_code
	local header = ''
	local found_libraries = {}

	for library_name, function_name in lua_code:gmatch(parse_pattern) do
		if not library_name or not function_name then continue end
		if not istable(_G[library_name]) or not isfunction(_G[library_name][function_name]) then continue end

		local library_function_name = library_name .. '.' .. function_name
		local library_value_name = library_name .. '_' .. function_name

		if not table_HasValueBySeq(whitelist_libraries, library_name) then continue end
		if table_HasValueBySeq(exceptions_libraries, library_function_name) then continue end
		if table_HasValueBySeq(found_libraries, library_function_name) then continue end
		if lua_code:match('function ' .. library_function_name) then continue end
		if lua_code:match(library_value_name .. '[%s+]?=[%s+]?' .. library_function_name) then continue end

		found_libraries[#found_libraries + 1] = library_function_name
	end

	if #found_libraries > 0 then
		header = 'local GOPT_GLOBAL_LIBRARIES = {}\n'
		for i = 1, #found_libraries do
			local library_name = found_libraries[i]
			local value_name = 'GOPT_GLOBAL_LIBRARIES[' .. i .. ']'
			header = header .. value_name .. ' = ' .. library_name .. '\n'
			new_code = new_code:gsub('(%s)' .. library_name .. '%((.-)%)', '%1' .. value_name .. '(%2)')
			new_code = new_code:gsub('(%()' .. library_name .. '%((.-)%)', '%1' .. value_name .. '(%2)')
			-- new_code = new_code:Replace(library_name .. '(', value_name .. '(')
		end
	else
		return
	end

	WriteLog('[Optimization] Add libraries to the header > ', lua_object:GetFilePath())

	new_code = header .. new_code
	lua_object:SetCode(new_code)
end)

-- GOptCore.Api.RegisterScriptOptimizer('GOpt.Opt.LibraryVariables', function(lua_object)
-- 	-- WriteLog('[Optimization][GOpt.Opt.LibraryVariables] > ', lua_object:GetFileName())

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

-- 	for library_name, function_name in lua_code:gmatch(parse_pattern) do
-- 		if not library_name or not function_name then continue end
-- 		if not istable(_G[library_name]) or not isfunction(_G[library_name][function_name]) then continue end
-- 		if not table_HasValueBySeq(whitelist_libraries, library_name) then continue end
-- 		if table_HasValueBySeq(exceptions_libraries, library_name) then continue end

-- 		local original_function = library_name .. '.' .. function_name
-- 		if table_HasValueBySeq(exceptions_libraries, original_function) then continue end

-- 		local new_value_name = 'v_gopt_' .. library_name .. '_' .. function_name
-- 		local new_local_value = string_format(var_format, new_value_name, original_function)
-- 		if not OnSetValue(new_value_name) then continue end

-- 		InsertLocalValueToHeader(original_function, new_value_name, new_local_value)
-- 	end

-- 	if №header == 0 then return end

-- 	WriteLog('[Optimization] Add libraries to the header > ', lua_object:GetFilePath())

-- 	new_code = header .. new_code
-- 	lua_object:SetCode(new_code)
-- end)