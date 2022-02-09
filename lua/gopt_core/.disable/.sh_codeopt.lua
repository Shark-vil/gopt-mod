local file_Exists = file.Exists
local file_Read = file.Read
local string_GetPathFromFilename = string.GetPathFromFilename
local string_GetFileFromFilename = string.GetFileFromFilename
local debug_getinfo = debug.getinfo
local string_format = string.format
local string_find = string.find
local file_Write = file.Write
local string_gsub = string.gsub
--
file.CreateDir('gopt_scripts_compile_log')
--
GOptCore.Storage.OriginalInclude = GOptCore.Storage.OriginalInclude or include
--
local past_include_directory

local function CodeOptimization(lua_code, include_filepath)
	local header = ''
	local registred_local_values = {}
	local new_lua_code = lua_code

	local function OnSetValue(new_local_value)
		if table.HasValueBySeq(registred_local_values, new_local_value) then return false end
		registred_local_values[#registred_local_values + 1] = new_local_value
		return true
	end

	local function CodeValueIsValid(k)
		if string_find(new_lua_code, k .. '(%s-)=') or string_find(new_lua_code, k .. '=') then return false end
		if string.find(new_lua_code, 'function(.-)' .. k .. '(.-)%)') then return false end
		return true
	end

	local function InsertLocalValueToHeader(k, new_value_name, new_local_value)
		new_lua_code = string_gsub(new_lua_code, '(%s)' .. k .. '%((.-)%)', '%1' .. new_value_name .. '(%2)')
		header = header .. new_local_value .. '\n'
	end

	for k, v in new_lua_code:gmatch('%s(%w+)%(.-%)') do
		if k == 'function' or v == 'function' then continue end

		local new_value_name = '_' .. k
		local new_local_value = string_format('local %s = %s;', new_value_name, k)
		if not OnSetValue(new_local_value) or not CodeValueIsValid(k) then continue end
		InsertLocalValueToHeader(k, new_value_name, new_local_value)
	end

	for k, v in new_lua_code:gmatch('%s(%w+)%.(%w+)%(.-%)') do
		if k == 'function' or v == 'function' then continue end

		local new_value_name = '_' .. k .. '_' .. v
		local new_local_value = string_format('local %s = %s;', new_value_name, k .. '.' .. v)
		if not OnSetValue(new_local_value) or not CodeValueIsValid(k) then continue end
		InsertLocalValueToHeader(k, new_value_name, new_local_value)
	end

	for k, v in new_lua_code:gmatch('%s!(%w+)%(.-%)') do
		if k == 'function' or v == 'function' then continue end

		local new_value_name = '_' .. k
		local new_local_value = string_format('local %s = %s;', new_value_name, k)
		if not OnSetValue(new_local_value) or not CodeValueIsValid(k) then continue end
		InsertLocalValueToHeader(k, new_value_name, new_local_value)
	end

	for k, v in new_lua_code:gmatch('%s!(%w+)%.(%w+)%(.-%)') do
		if k == 'function' or v == 'function' then continue end

		local new_value_name = '_' .. k .. '_' .. v
		local new_local_value = string_format('local %s = %s;', new_value_name, k .. '.' .. v)
		if not OnSetValue(new_local_value) or not CodeValueIsValid(k) then continue end
		InsertLocalValueToHeader(k, new_value_name, new_local_value)
	end

	new_lua_code = header .. new_lua_code

	if new_lua_code ~= lua_code then
		local filename = string_GetFileFromFilename(include_filepath)
		local directory_path = string_GetPathFromFilename(include_filepath)
		local saved_path = 'gopt_scripts_compile_log/'
		saved_path = saved_path .. directory_path

		if not file.Exists(saved_path, 'DATA') then
			file.CreateDir(saved_path)
		end

		saved_path = saved_path .. filename .. '.txt'
		file_Write(saved_path, new_lua_code)

		return new_lua_code
	end

	return lua_code
end

local function GetValidFilePath(filepath_src, target_script_filepath)
	local include_filepath = 'lua/' .. target_script_filepath

	if not file_Exists(include_filepath, 'GAME') then
		include_filepath = filepath_src .. '/' .. target_script_filepath
	end

	if not file_Exists(include_filepath, 'GAME') then
		include_filepath = target_script_filepath
	end

	if not file_Exists(include_filepath, 'GAME') and past_include_directory then
		include_filepath = past_include_directory .. target_script_filepath
	end

	if not file_Exists(include_filepath, 'GAME') then
		return
	end

	return include_filepath
end

function GOptCore.Api.ScriptInclude(target_script_filepath)
	if GetConVar('gopt_scripts_optimization'):GetBool() then
		local debug_info = debug_getinfo(2, 'S')
		local filepath_src = debug_info.source

		if filepath_src and filepath_src:sub(1, 1) == '@' then
			filepath_src = filepath_src:sub(2):gsub('/[^/]*$', '')
			local include_filepath = GetValidFilePath(filepath_src, target_script_filepath)
			if include_filepath and file_Exists(include_filepath, 'GAME') then
				local lua_code = file_Read(include_filepath, 'GAME')
				if lua_code and #lua_code ~= 0 then
					local optimized_code = CodeOptimization(lua_code, include_filepath)
					local execute_function = CompileString(optimized_code, include_filepath)
					if execute_function then
						-- MsgN('Script Override: ' .. include_filepath)
						past_include_directory = string_GetPathFromFilename(include_filepath)
						return execute_function()
					end
				end
			end
		end
	end

	return GOptCore.Storage.OriginalInclude(target_script_filepath)
end

include = GOptCore.Api.ScriptInclude



local function GetValidFilePath(filepath_src, target_script_filepath)
	local include_filepath
	local filepath_dir_src = filepath_src:gsub('/[^/]*$', '')

	filepath_src = filepath_src or ''
	target_script_filepath = target_script_filepath or ''

	if past_include_directory then
		include_filepath = past_include_directory .. '/' .. target_script_filepath
		include_log('Parse filename [1]: ' .. include_filepath)
		if FileIsValid(include_filepath) then return include_filepath end

		include_filepath = PartPairsFoundValidPath(include_filepath)
		if include_filepath then return include_filepath end

		include_filepath = filepath_src .. '/' .. target_script_filepath
		include_log('Parse filename [2]: ' .. include_filepath)
		if FileIsValid(include_filepath) then return include_filepath end
	end

	include_filepath = target_script_filepath
	include_log('Parse filename [3]: ' .. include_filepath)
	if FileIsValid(include_filepath) then return include_filepath end

	if not target_script_filepath and filepath_src and FileIsValid(filepath_src) then
		return filepath_src
	end

	include_filepath = filepath_dir_src .. '/' .. target_script_filepath
	include_log('Parse filename [4]: ' .. include_filepath)
	if FileIsValid(include_filepath) then return include_filepath end

	local combine_string = filepath_dir_src .. '/' .. target_script_filepath
	if not target_script_filepath or #target_script_filepath == 0 then
		combine_string = filepath_src
	end

	include_filepath = PartPairsFoundValidPath(combine_string)
	if include_filepath then return include_filepath end

	if not file_Exists(include_filepath) or file.IsDir(include_filepath, 'LUA') then
		return
	end

	return include_filepath
end