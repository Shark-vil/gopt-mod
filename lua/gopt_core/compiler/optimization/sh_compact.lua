local WriteLog = GOptCore.Api.WriteLog
-- local new_line_char = '\n'
-- local comments_patterns = {
-- 	'--%[([%=+]?)%[(.-)%]%1%]',
-- 	'%/%*(.-)%*%/',
-- 	'%-%-(.-)\n',
-- 	'%/%/(.-)\n',
-- }

GOptCore.Api.RegisterScriptOptimizer('GOpt.Opt.Compact', function(lua_object)
	WriteLog('[Optimization] Compressing code into one line > ', lua_object:GetFileName())

	local lua_code = lua_object:GetCode()
	local new_lua_code = ''

	for code_line in lua_code:gmatch('[^\r\n]+') do
		code_line = code_line:gsub('^%s*(.-)%s*$', '%1')
		if #code_line ~= 0 then
			new_lua_code = new_lua_code .. code_line .. ' '
		end
	end

	lua_object:SetCode(new_lua_code)
end)