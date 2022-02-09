GOptCore.Storage.OriginalFileRead = GOptCore.Storage.OriginalFileRead or file.Read

function GOptCore.Api.FileRead(file_path, data_type)
	if string.EndsWith(file_path, '.lua') and not GOptCore.Storage.IncludeLocker then
		local postfix = SERVER and 'serverside' or 'clientside'
		local cache_path = 'gopt_data/cache/' .. postfix .. '/' .. file_path .. '.dat'
		if file.Exists(cache_path, 'DATA') then
			return GOptCore.Storage.OriginalFileRead(cache_path, 'DATA')
		end
	end
	return GOptCore.Storage.OriginalFileRead(file_path, data_type)
end
file.Read = GOptCore.Api.FileRead

-- GOptCore.Storage.OriginalFileFind = GOptCore.Storage.OriginalFileFind or file.Find

-- function GOptCore.Api.FileFind(find_path, data_type)
-- 	if CLIENT and data_type == 'LUA' then
-- 		local files, directories = file.Find('gopt_data/cache/clientside/' .. find_path, 'DATA')
-- 		if files then return files, directories end
-- 	end

-- 	return GOptCore.Storage.OriginalFileFind(find_path, data_type)
-- end
-- file.Find = GOptCore.Api.FileFind

-- hook.Add('GOpt.ScriptCompile', 'GOpt.Opt.FileFunctionsFixed', function(lua_object)
-- 	if SERVER then return end
-- 	local lua_code = lua_object:GetCode()
-- 	lua_code = lua_code:gsub('file.Exists', 'slib.FileExists')
-- 	lua_object:SetCode(lua_code)
-- end)