if SERVER then
	hook.Add('GOpt.ScriptCompile', 'GOpt.CodeEditTest.Server', function(lua_object)
		-- local lua_code = lua_object:GetCode()
		-- lua_code = 'print("Hello Server!")\n' .. lua_code
		-- lua_object:SetCode(lua_code)
	end)
else
	hook.Add('GOpt.ScriptCompile', 'GOpt.CodeEditTest.Client', function(lua_object)
		-- local lua_code = lua_object:GetCode()
		-- lua_code = 'print("Hello Client!")\n' .. lua_code
		-- lua_object:SetCode(lua_code)
	end)
end