local WriteLog = GOptCore.Api.WriteLog
--
GOptCore.Storage.OriginalInclude = GOptCore.Storage.OriginalInclude or include
GOptCore.Storage.OriginalAddCSLuaFile = GOptCore.Storage.OriginalAddCSLuaFile or AddCSLuaFile
GOptCore.Storage.AlreadyRegistredScripts = GOptCore.Storage.AlreadyRegistredScripts or {}
GOptCore.Storage.AlreadyIncludedScripts = GOptCore.Storage.AlreadyIncludedScripts or {}
GOptCore.Storage.IncludeLocker = GOptCore.Storage.IncludeLocker or false
--
local past_includer_folder

local function FoundScriptPathParsingBySegments(script_path)
	local combine_explode = string.Explode('/', script_path)
	while #combine_explode > 0 do
		local parse_filename = ''
		local count_parts = #combine_explode

		for index = 1, count_parts do
			if index == count_parts then
				parse_filename = parse_filename .. combine_explode[index]
			else
				parse_filename = parse_filename .. combine_explode[index] .. '/'
			end
		end

		-- WriteLog('Found [2]: ', parse_filename)

		if slib.FileExists(parse_filename, 'LUA') then
			return parse_filename
		end

		table.remove(combine_explode, 1)
	end
end

local function FoundScriptPath(script_path, includer_folder)
	if includer_folder and #includer_folder ~= 0 then
		if slib.FileExists(includer_folder .. script_path, 'LUA') then
			-- WriteLog('Found [1]: ', includer_folder .. script_path)
			return includer_folder .. script_path
		end

		local found_script_path = FoundScriptPathParsingBySegments(includer_folder .. script_path)
		if found_script_path then return found_script_path end
	end

	if slib.FileExists(script_path, 'LUA') then
		-- WriteLog('Found [3]: ', script_path)
		return script_path
	end

	if past_includer_folder and #past_includer_folder ~= 0 then
		-- WriteLog('Found [4]: ', past_includer_folder .. script_path)
		return past_includer_folder .. script_path
	end
end

local function ScriptNameNormalize(script_path)
	if string.StartWith(script_path, 'addons/') then
		script_path = script_path:gsub('addons/.+/lua/(.-)', '%1')
	end
	if string.StartWith(script_path, 'gamemodes/') then
		script_path = script_path:gsub('gamemodes/(.-)', '%1')
	end
	if string.StartWith(script_path, 'lua/') then
		script_path = script_path:gsub('lua/(.-)', '%1')
	end
	if string.StartWith(script_path, 'gamemodes/') then
		script_path = script_path:gsub('gamemodes/(.-)', '%1')
	end
	if string.StartWith(script_path, 'sandbox/entities/weapons/gmod_tool/') then
		script_path = script_path:gsub('sandbox/entities/(.-)', '%1')
	end
	return script_path
end

function GOptCore.Api.ScriptRegisterFromClients(script_path)
	local debug_info = debug.getinfo(2, 'S')
	local includer_path = debug_info.source
	local current_includer_path, current_includer_folder

	if includer_path:sub(1, 1) == '@' then
		current_includer_path = ScriptNameNormalize(includer_path:sub(2))
		current_includer_folder = string.GetPathFromFilename(current_includer_path)
	end

	if not script_path then
		script_path = current_includer_path
	end

	-- if GOptCore.Storage.AlreadyRegistredScripts[script_path] then return end
	-- GOptCore.Storage.AlreadyRegistredScripts[script_path] = true

	local real_script_path = FoundScriptPath(script_path, current_includer_folder)

	if GOptCore.Storage.AlreadyRegistredScripts[real_script_path] then return end
	GOptCore.Storage.AlreadyRegistredScripts[real_script_path] = true

	if real_script_path then
		WriteLog('AddCSLuaFile: ', real_script_path)
		return GOptCore.Storage.OriginalAddCSLuaFile(real_script_path)
	end

	WriteLog('Error AddCSLuaFile: ', real_script_path, ' [Use the original function]')
	return GOptCore.Storage.OriginalAddCSLuaFile(script_path)
end

function GOptCore.Api.ScriptInclude(script_path)
	if not GetConVar('gopt_scripts_optimization'):GetBool() then
		return GOptCore.Storage.OriginalInclude(script_path)
	end

	GOptCore.Storage.IncludeLocker = true

	local lua_object
	local debug_info = debug.getinfo(2, 'S')
	local includer_path = debug_info.source
	local error_message = 'Unknown error'
	local current_includer_path, current_includer_folder

	if includer_path:sub(1, 1) == '@' then
		current_includer_path = ScriptNameNormalize(includer_path:sub(2))
		current_includer_folder = string.GetPathFromFilename(current_includer_path)

		if not GOptCore.Storage.AlreadyIncludedScripts[current_includer_path] and (
			string.StartWith(includer_path, '@gamemodes/')
			or string.StartWith(current_includer_path, 'entities/')
		) and (
			string.EndsWith(current_includer_path, '/init.lua')
			or string.EndsWith(current_includer_path, '/cl_init.lua')
		) then
			GOptCore.Storage.AlreadyIncludedScripts[current_includer_path] = true
			GOptCore.Storage.IncludeLocker = false
			return GOptCore.Api.ScriptInclude(current_includer_path)
		end
	end

	WriteLog('Detect include: ', includer_path, ' > ', script_path)

	-- WriteLog('[Debug include] Start: ', includer_path, ' > ', script_path)
	-- WriteLog('current_includer_path: ', tostring(current_includer_path))
	-- WriteLog('current_includer_folder: ', tostring(current_includer_folder))
	-- WriteLog('past_includer_folder: ', tostring(past_includer_folder))
	-- WriteLog('[Debug include] End')

	local real_script_path = FoundScriptPath(script_path, current_includer_folder)
	if real_script_path then
		past_includer_folder = string.GetPathFromFilename(real_script_path)

		-- if GOptCore.Storage.AlreadyIncludedScripts[past_includer_folder] then return end
		-- GOptCore.Storage.AlreadyIncludedScripts[past_includer_folder] = true

		lua_object = slib.Instance('LuaObject', real_script_path)
		if IsValid(lua_object) then
			if not file.Exists(real_script_path, 'LUA') then
				PrecacheSentenceFile('lua/' .. real_script_path)
			end

			local cache_lua_code
			if GetConVar('gopt_scripts_optimization_cache_loader'):GetBool() then
				cache_lua_code = GOptCore.Api.ReadCache(lua_object)
				if cache_lua_code and #cache_lua_code ~= 0 then
					WriteLog('Include cache: ', lua_object:GetFilePath())
					lua_object:SetCode(cache_lua_code)
				else
					cache_lua_code = nil
				end
			end

			if not cache_lua_code then
				-- hook.Run('GOpt.ScriptCompile', lua_object)
				slib.SafeHookRun('GOpt.ScriptCompile', lua_object)
			end

			local lua_code = lua_object:GetCode()
			local compile_result = CompileString(lua_code, real_script_path, false)
			if compile_result then
				if isfunction(compile_result) then
					WriteLog('Include: ', real_script_path)
					-- hook.Run('GOpt.ScriptInclude', lua_object, true)
					slib.SafeHookRun('GOpt.ScriptInclude', lua_object, true)
					GOptCore.Storage.IncludeLocker = false

					-- Тихие ошибки
					local result = { xpcall(compile_result, function(err)
						MsgC('\n', Color(243, 106, 106), 'GOPT INCLUDE ERROR', '\n')
						MsgC(Color(219, 208, 208), debug.traceback(err), '\n')
					end) }

					local succ = result[1]
					if succ then
						table.remove(result, 1)
						return unpack(result)
					end
					-- return compile_result()
				elseif isstring(compile_result) then
					error_message = compile_result
				end
			end
		end
	end

	-- hook.Run('GOpt.ScriptInclude', lua_object, false)
	slib.SafeHookRun('GOpt.ScriptInclude', lua_object, false)
	GOptCore.Storage.IncludeLocker = false

	WriteLog('Error include: ', error_message)

	-- return GOptCore.Storage.OriginalInclude(script_path)

	if real_script_path then
		MsgC('\n', Color(245, 215, 49), 'Use original includer - ', real_script_path, '\n')
		return GOptCore.Storage.OriginalInclude(real_script_path)
	else
		MsgC('\n', Color(245, 215, 49), 'Use original includer - ', script_path, '\n')
		return GOptCore.Storage.OriginalInclude(script_path)
	end
end

include = GOptCore.Api.ScriptInclude
AddCSLuaFile = GOptCore.Api.ScriptRegisterFromClients