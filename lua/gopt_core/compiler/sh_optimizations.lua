local table_WhereFindBySeq = table.WhereFindBySeq
local WriteLog = GOptCore.Api.WriteLog
--
GOptCore.Storage.RegistredOptimizations = GOptCore.Storage.RegistredOptimizations or {}

function GOptCore.Api.RegisterScriptOptimizer(name, func)
	local _, value = table_WhereFindBySeq(GOptCore.Storage.RegistredOptimizations, function(_ , value)
		return value.name == name
	end)

	if value then
		value.func = func
	else
		table.insert(GOptCore.Storage.RegistredOptimizations, { name = name, func = func })
	end
end

hook.Add('GOpt.ScriptCompile', 'GOpt.ScriptsOptimizations', function(lua_object)
	for i = 1, #GOptCore.Storage.RegistredOptimizations do
		GOptCore.Storage.RegistredOptimizations[i].func(lua_object)
	end

	local lua_code = lua_object:GetCode()

	if not lua_code or #lua_code == 0 then
		local warning_message = '[Warning] There is no code in the script, but it is used  > '
		warning_message = warning_message .. lua_object:GetFilePath()

		lua_code = 'print("' .. warning_message .. '")'
		lua_object:SetCode(lua_code)

		WriteLog(warning_message)
	end
end)