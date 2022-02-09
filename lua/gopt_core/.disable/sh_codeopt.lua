local _G = _G
local file_Read = file.Read
local file_Find = file.Find
local file_IsDir = file.IsDir
local file_CreateDir = file.CreateDir
local file_Delete = file.Delete
local string_GetPathFromFilename = string.GetPathFromFilename
local string_GetFileFromFilename = string.GetFileFromFilename
local debug_getinfo = debug.getinfo
local string_format = string.format
local string_find = string.find
local file_Write = file.Write
local file_Append = file.Append
local file_Exists = file.Exists
local string_gsub = string.gsub
local string_Trim = string.Trim
local string_Explode = string.Explode
local table_HasValueBySeq = table.HasValueBySeq
local table_remove = table.remove
local util_MD5 = util.MD5
local isfunction = isfunction
local tostring = tostring
--
file_CreateDir('gopt_scripts_compile_cache')
file_CreateDir('gopt_scripts_compile_cache/clientside')
file_CreateDir('gopt_scripts_compile_cache/serverside')
--
GOptCore.Storage.OriginalInclude = GOptCore.Storage.OriginalInclude or include
GOptCore.Storage.OriginalAddCSLuaFile = GOptCore.Storage.OriginalAddCSLuaFile or AddCSLuaFile
--
local past_include_directory
local logpath = 'gopt_scripts_compile_cache/log.txt'
if file_Exists(logpath, 'DATA') then
	file_Write(logpath, '');
end

if not GetConVar('gopt_scripts_optimization'):GetBool() then
	return
end

local global_method_whitlelist = {
	-- 'IsValid',
	-- 'Color',
	-- 'pairs',
	-- 'ipairs',
	-- 'tonumber',
	-- 'tostring',
	-- 'tobool',
	-- 'totable',
	-- 'isfunction',
	-- 'isstring',
	-- 'isnumber',
	-- 'istable',
	-- 'isentity',
	-- 'IsColor',
	-- 'type',
	-- 'CurTime',
	-- 'SysTime',
	-- 'RealTime',
}

-- for name in pairs(_G) do
-- 	if not table_HasValueBySeq(global_method_whitlelist, name) then
-- 		global_method_whitlelist[#global_method_whitlelist + 1] = name
-- 	end
-- end

local function include_log(logtext)
	logtext = tostring(logtext)
	if not logtext or #logtext == 0 then return end

	local prefix = SERVER and '[SERVER] ' or '[CLIENT] '
	if not file_Exists(logpath, 'DATA') then
		file_Write(logpath, prefix .. logtext .. '\n')
	else
		file_Append(logpath, prefix .. logtext .. '\n')
	end
end

local function lines_pairs(lua_code)
	local code_lines = {}
	lua_code = lua_code .. '\n'

	for code_line in lua_code:gmatch('(.-)\n') do
		code_line = string_Trim(code_line)
		if code_line and #code_line ~= 0 then
			if code_line:sub(1, 1) == '.' or code_line:sub(1, 1) == ':' then
				code_lines[#code_lines] = code_lines[#code_lines] .. code_line
			else
				code_lines[#code_lines + 1] = code_line
			end
		end
	end

	local lines = #code_lines
	local index = 0
	return function()
		index = index + 1
		if index <= lines then return index, code_lines[index] end
	end
end

local function CodeCOmpression(lua_code)
	local compression_code = ''
	-- lua_code = lua_code:gsub('%-%-%[(.-)%[(.+)%]%1%]', '\n')
	-- lua_code = lua_code:gsub('%/%*(.+)%*%/', '\n')
	-- lua_code = lua_code:gsub('%-%-(.-)\n', '\n')
	-- lua_code = lua_code:gsub('(%s+)//(.-)\n', '\n')

	for _, vode_line in lines_pairs(lua_code) do
		compression_code = compression_code .. '\n' .. vode_line
	end

	return string_Trim(compression_code)
end

local function CodeOptimization(lua_code, include_filepath)
	do
		local filename = string_GetFileFromFilename(include_filepath)
		local directory_path = string_GetPathFromFilename(include_filepath)
		local postfix = SERVER and 'serverside' or 'clientside'
		local saved_path = 'gopt_scripts_compile_cache/' .. postfix .. '/'
		saved_path = saved_path .. directory_path
		saved_path = saved_path .. filename .. '.dat'
		if file_Exists(saved_path, 'DATA') then
			return file_Read(saved_path, 'DATA')
		end
	end

	local header = ''
	lua_code = CodeCOmpression(lua_code)
	local new_lua_code = lua_code
	local registred_local_values = {}
	local exceptions_functions = {
		'AddCSLuaFile',
		'include',
		-- 'isstring',
		-- 'tostring',
		-- 'xpcall',
		-- 'pcall',
		-- 'unpack',
	}
	local exceptions_libraries = {
		'hook',
		'GOptCore',
		'slib',
		'DLib',
		'vgui',
		'ENT',
		'PANEL',
		'TOOL',
		'SWEP',
		'cvars',
		'cookie',
		'gmod',
		'gamemode',
		'timer',
		'system',
		'util.AddNetworkString',
		'util.SteamIDTo64',
		'concommand',
		'file',
		'surface.CreateFont',
		'EasyChat.ChatHUD',
	}

	local function OnSetValue(new_value_name)
		if table_HasValueBySeq(registred_local_values, new_value_name) then return false end
		registred_local_values[#registred_local_values + 1] = new_value_name
		return true
	end

	local function InsertLocalValueToHeader(k, new_value_name, new_local_value)
		new_lua_code = string_gsub(new_lua_code, '(%s)' .. k .. '%((.-)%)', '%1' .. new_value_name .. '(%2)')
		header = header .. new_local_value .. '\n'
	end

	for function_name, _ in new_lua_code:gmatch('[%s]?(%w+)%(.-%)') do
		if not function_name or not isfunction(_G[function_name]) then continue end
		if table_HasValueBySeq(exceptions_functions, function_name) then continue end
		-- if not table_HasValueBySeq(global_method_whitlelist, function_name) then continue end
		local new_value_name = function_name
		local new_local_value = string_format('local %s = %s', new_value_name, function_name)
		if string_find(new_lua_code, new_local_value) or not OnSetValue(new_value_name) then continue end
		InsertLocalValueToHeader(function_name, new_value_name, new_local_value)
	end

	do
		local pattern = 'for(%s+)(.-),[%s+]?(.-)(%s+)in(%s+)ipairs([%s+]?)%((.-)%)[%s+]?do'
		local temp_value_index = 0
		local new_code = ''
		for _, code_line in lines_pairs(new_lua_code) do
			local temp_variable_name = 'v_gopt_tenp_' .. tostring(temp_value_index)
			local new_block = 'local ' .. temp_variable_name .. ' = %7\nfor %2 = 1, #' .. temp_variable_name .. ' do\nlocal %3 = ' .. temp_variable_name .. '[%2]\nif not %3 then break end'

			code_line, replaced_count = code_line:gsub(pattern, new_block, 1)
			new_code = new_code .. '\n' .. code_line

			if replaced_count ~= 0 then
				temp_value_index = temp_value_index + 1
			end
		end
		new_lua_code = string_Trim(new_code)
	end

	do
		local exists_variables = {}
		local pattern = '([^%w]Color%([%s-]?%d+[%s-]?%,[%s-]?%d+[%s-]?,[%s-]?%d+[%s-]?%))'
		local temp_value_index = 0
		local new_code = ''
		for _, code_line in lines_pairs(new_lua_code) do
			local temp_variable_name = 'v_gopt_color_' .. tostring(temp_value_index)
			local temp_code_line = code_line

			for color in code_line:gmatch(pattern) do
				local first_char = color:sub(1, 1)
		    color = color:sub(2)

				if exists_variables[color] then
					temp_variable_name = exists_variables[color]
				end

				local new_local_value = string_format('local %s = %s', temp_variable_name, color)
				temp_code_line, replaced_count = temp_code_line:gsub(pattern, first_char .. temp_variable_name, 1)

				if replaced_count ~= 0 then
					if not exists_variables[color] then
						header = header .. new_local_value .. '\n'
						exists_variables[color] = temp_variable_name
					end
					temp_value_index = temp_value_index + 1
				end
			end

			new_code = new_code .. '\n' .. temp_code_line
		end
		new_lua_code = string_Trim(new_code)
	end

	do
		local exists_variables = {}
		local pattern = '([^%w]Vector%([%s-]?%d+[%s-]?%,[%s-]?%d+[%s-]?,[%s-]?%d+[%s-]?%))'
		local temp_value_index = 0
		local new_code = ''
		for _, code_line in lines_pairs(new_lua_code) do
			local temp_variable_name = 'v_gopt_vector_' .. tostring(temp_value_index)
			local temp_code_line = code_line

			for color in code_line:gmatch(pattern) do
				local first_char = color:sub(1, 1)
		    color = color:sub(2)

				if exists_variables[color] then
					temp_variable_name = exists_variables[color]
				end

				local new_local_value = string_format('local %s = %s', temp_variable_name, color)
				temp_code_line, replaced_count = temp_code_line:gsub(pattern, first_char .. temp_variable_name, 1)

				if replaced_count ~= 0 then
					if not exists_variables[color] then
						header = header .. new_local_value .. '\n'
						exists_variables[color] = temp_variable_name
					end
					temp_value_index = temp_value_index + 1
				end
			end

			new_code = new_code .. '\n' .. temp_code_line
		end
		new_lua_code = string_Trim(new_code)
	end

	do
		local exists_variables = {}
		local pattern = '([^%w]Angle%([%s-]?%d+[%s-]?%,[%s-]?%d+[%s-]?,[%s-]?%d+[%s-]?%))'
		local temp_value_index = 0
		local new_code = ''
		for _, code_line in lines_pairs(new_lua_code) do
			local temp_variable_name = 'v_gopt_angle_' .. tostring(temp_value_index)
			local temp_code_line = code_line

			for color in code_line:gmatch(pattern) do
				local first_char = color:sub(1, 1)
		    color = color:sub(2)

				if exists_variables[color] then
					temp_variable_name = exists_variables[color]
				end

				local new_local_value = string_format('local %s = %s', temp_variable_name, color)
				temp_code_line, replaced_count = temp_code_line:gsub(pattern, first_char .. temp_variable_name, 1)

				if replaced_count ~= 0 then
					if not exists_variables[color] then
						header = header .. new_local_value .. '\n'
						exists_variables[color] = temp_variable_name
					end
					temp_value_index = temp_value_index + 1
				end
			end

			new_code = new_code .. '\n' .. temp_code_line
		end
		new_lua_code = string_Trim(new_code)
	end

	-- for library_name, _ in new_lua_code:gmatch('[%s]?(%w+)%.(.-)') do
	-- 	if library_name and _G[library_name] then
	-- 		if table_HasValueBySeq(exceptions_libraries, library_name) then continue end
	-- 		local new_value_name = library_name
	-- 		local new_local_value = string_format('local %s = %s', new_value_name, library_name)
	-- 		if string_find(new_lua_code, new_local_value) or not OnSetValue(new_value_name) then continue end
	-- 		InsertLocalValueToHeader(library_name, new_value_name, new_local_value)
	-- 	end
	-- end

	for library_name, function_name in new_lua_code:gmatch('[%s]?(%w+)%.(%w+)%(.-%)') do
		if not library_name or not function_name then continue end
		if not istable(_G[library_name]) or not isfunction(_G[library_name][function_name]) then continue end
		if table_HasValueBySeq(exceptions_libraries, library_name) then continue end

		local original_function = library_name .. '.' .. function_name
		if table_HasValueBySeq(exceptions_libraries, original_function) then continue end

		local new_value_name = 'v_gopt_' .. library_name .. '_' .. function_name
		local new_local_value = string_format('local %s = %s', new_value_name, original_function)
		if not OnSetValue(new_value_name) then continue end
		InsertLocalValueToHeader(original_function, new_value_name, new_local_value)
	end

	new_lua_code = header .. new_lua_code
	-- new_lua_code = 'do\n' .. new_lua_code .. '\nend'

	if new_lua_code ~= lua_code then
		-- local compressed_lua_code = CodeCOmpression(new_lua_code)
		local compressed_lua_code = new_lua_code
		local filename = string_GetFileFromFilename(include_filepath)
		local directory_path = string_GetPathFromFilename(include_filepath)

		local postfix = SERVER and 'serverside' or 'clientside'
		local saved_path = 'gopt_scripts_compile_cache/' .. postfix .. '/'
		saved_path = saved_path .. directory_path

		if not file_Exists(saved_path, 'DATA') then
			file_CreateDir(saved_path)
		end

		saved_path = saved_path .. filename .. '.dat'
		if file_Exists(saved_path, 'DATA') then
			local file_data = file_Read(saved_path, 'DATA')
			if not file_data or util_MD5(file_data) ~= util_MD5(compressed_lua_code) then
				file_Write(saved_path, compressed_lua_code)
			end
		else
			file_Write(saved_path, compressed_lua_code)
		end

		return compressed_lua_code
	end

	return lua_code
end

local function script_Exists(file_path)
	if not file_path then return false end
	if file_Exists(file_path, 'LUA') and not file_IsDir(file_path, 'LUA') then return true end

	local file_data = file_Read(file_path, 'LUA')
	if file_data and #file_data ~= 0 then return true end

	local directory_path = string_GetPathFromFilename(file_path)
	if not directory_path then return false end

	local files, _ = file_Find(directory_path .. '*', 'LUA')
	if not files then return false end

	return table_HasValueBySeq(files, string_GetFileFromFilename(file_path))
end

local function FileIsValid(file_path)
	return script_Exists(file_path)
end

local function PartPairsFoundValidPath(file_path)
	local combine_explode = string_Explode('/', file_path)
	while #combine_explode > 0 do
		local parse_filename = ''
		local count = #combine_explode
		for i = 1, count do
			if i == count then
				parse_filename = parse_filename .. combine_explode[i]
			else
				parse_filename = parse_filename .. combine_explode[i] .. '/'
			end
		end

		-- include_log('Parse filename [2]: ' .. parse_filename)

		if FileIsValid(parse_filename) then
			return parse_filename
		end

		table_remove(combine_explode, 1)
	end
end

local function GetValidFilePath(filepath_src, target_script_filepath)
	local include_filepath
	-- local filepath_dir_src = filepath_src:gsub('/[^/]*$', '')
	local filepath_dir_src = string_gsub(filepath_src, '/[^/]*$', '')

	filepath_src = filepath_src or ''
	target_script_filepath = target_script_filepath or ''

	if target_script_filepath and #target_script_filepath ~= 0 then
		include_filepath = target_script_filepath
		-- include_log('Parse filename [1]: ' .. include_filepath)
		if FileIsValid(include_filepath) then return include_filepath end
	end

	if not target_script_filepath or #target_script_filepath == 0 then
		include_filepath = PartPairsFoundValidPath(filepath_src)
		if include_filepath then return include_filepath end
	else
		include_filepath = PartPairsFoundValidPath(filepath_dir_src .. '/' .. target_script_filepath)
		if include_filepath then return include_filepath end
	end

	if past_include_directory and #past_include_directory ~= 0 then
		if not target_script_filepath then
			include_filepath = past_include_directory .. '/' .. filepath_src
		else
			include_filepath = past_include_directory .. '/' .. target_script_filepath
		end

		-- include_log('Parse filename [3]: ' .. include_filepath)
		if FileIsValid(include_filepath) then return include_filepath end
	end
end

function GOptCore.Api.AddCSLuaFile(target_script_filepath)
	local debug_info = debug_getinfo(2, 'S')
	local filepath_src = debug_info.source
	local include_filepath

	if filepath_src and filepath_src:sub(1, 1) == '@' then
		filepath_src = filepath_src:sub(2)
		include_filepath = GetValidFilePath(filepath_src, target_script_filepath)

		if include_filepath then
			past_include_directory = filepath_src:gsub('/[^/]*$', '')

			include_log('AddCSLuaFile: ' .. include_filepath)
			return GOptCore.Storage.OriginalAddCSLuaFile(include_filepath)
		end
	end

	include_log('Failed AddCSLuaFile: '
	.. filepath_src
	.. ' > '
	.. tostring(target_script_filepath)
	.. ' > '
	.. tostring(include_filepath))

	return GOptCore.Storage.OriginalAddCSLuaFile(target_script_filepath)
end

function GOptCore.Api.ScriptInclude(target_script_filepath)
	local debug_info = debug_getinfo(2, 'S')
	local filepath_src = debug_info.source
	local include_filepath

	-- include_log(filepath_src .. ' > ' .. tostring(target_script_filepath))

	if filepath_src and filepath_src:sub(1, 1) == '@' then
		filepath_src = filepath_src:sub(2)
		include_filepath = GetValidFilePath(filepath_src, target_script_filepath)

		if include_filepath then
			local lua_code = file_Read(include_filepath, 'LUA')
			if lua_code and #lua_code ~= 0 then
				past_include_directory = filepath_src:gsub('/[^/]*$', '')

				local optimized_code = CodeOptimization(lua_code, include_filepath)
				local execute_function = CompileString(optimized_code, include_filepath, false)
				if execute_function and isfunction(execute_function) then
					include_log('Include: ' .. include_filepath)
					return execute_function()
				end
			end
		end
	end

	include_log('Failed Include: '
	.. filepath_src
	.. ' > '
	.. tostring(target_script_filepath)
	.. ' > '
	.. tostring(include_filepath))

	if include_filepath then
		local filename = string_GetFileFromFilename(include_filepath)
		local directory_path = string_GetPathFromFilename(include_filepath)
		local postfix = SERVER and 'serverside' or 'clientside'
		local saved_path = 'gopt_scripts_compile_cache/' .. postfix .. '/'
		saved_path = saved_path .. directory_path
		saved_path = saved_path .. filename .. '.dat'

		if file_Exists(saved_path, 'DATA') then
			-- local code_text = file_Read(include_filepath, 'LUA')
			-- local warning_block = ''
			-- warning_block = warning_block .. '------------------------------------\n'
			-- warning_block = warning_block .. '------- SCRIPT INCLUDE ERROR -------\n'
			-- warning_block = warning_block .. '------------------------------------\n'
			-- code_text = warning_block .. code_text
			-- file_Write(saved_path, code_text)
			file_Delete(saved_path)
		end

		return GOptCore.Storage.OriginalInclude(include_filepath)
	else
		return GOptCore.Storage.OriginalInclude(target_script_filepath)
	end
end

concommand.Add('gopt_clear_scripts_cache', function()
	file.Delete('gopt_scripts_compile_cache/*')
	MsgN('GOpt scripts cache cleaned!')
end)

include = GOptCore.Api.ScriptInclude
AddCSLuaFile = GOptCore.Api.AddCSLuaFile