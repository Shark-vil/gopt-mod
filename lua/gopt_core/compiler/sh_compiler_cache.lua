hook.Add('GOpt.ScriptInclude', 'GOpt.ScriptsCacheWriter', function(lua_object, success)
	GOptCore.Api.WriteCahce(lua_object)
	if not success then GOptCore.Api.WriteErrorCahce(lua_object) end
end)