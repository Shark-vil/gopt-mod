local CLASS = {}

function CLASS:Instance(script_path)
	local private = {}
	private.script_path = script_path
	private.directory_path = string.GetPathFromFilename(script_path)
	private.lua_code = file.Read(script_path, 'LUA')

	local public = {}

	function public:IsValid()
		local lua_code = private.lua_code
		if not lua_code or #lua_code == 0 then return false end
		return true
	end

	function public:GetCode()
		local lua_code = private.lua_code
		return lua_code
	end

	function public:GetDirectoryPath()
		return private.directory_path
	end

	function public:GetFilePath()
		return private.script_path
	end

	function public:GetFileName()
		return string.GetFileFromFilename(private.script_path)
	end

	function public:SetCode(new_lua_code)
		private.lua_code = new_lua_code
	end

	function public:Pairs()
		return slib.StringLinePairs(private.lua_code)
	end

	return public
end

slib.SetComponent('LuaObject', CLASS)