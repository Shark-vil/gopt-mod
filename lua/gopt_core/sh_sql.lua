GOptCore.SQL.ScriptCache = slib.Instance('SQL')
GOptCore.SQL.ScriptCache:SetModel('GOPT_SCRIPT_CACHE', {
	{ name = 'id', type = 'integer', primary_key = true, auto = true },
	{ name = 'script_path', type = 'text' },
	{ name = 'script_code', type = 'text', compress = true },
})

--[=[
GOptCore.SQL.ScriptCache:ResetTable()

local lua_code = [[
	for k, v in ipairs(player.GetAll()) do
		print('Ok', "OR OK")
	end
]]

GOptCore.SQL.ScriptCache:Insert({
	fields = {
		{ name = 'script_path', value = 'lua/autorun/script.sh' },
		{ name = 'script_code', value = lua_code }
	}
})

GOptCore.SQL.ScriptCache:Update({
	fields = {
		{ name = 'script_path', value = 'lua/script.sh' },
	},
	where = { name = 'id', value = '1' }
})

local read_data = GOptCore.SQL.ScriptCache:Read({
	fields = {
		{ name = 'script_path' },
		{ name = 'script_code', base64 = true }
	},
	where = { name = 'script_path', value = 'lua/autorun/script.sh' },
	first = true
})

if read_data then
	local script_path = read_data['script_path']
	local script_code = read_data['script_code']
	print(script_path, script_code)
end
]=]