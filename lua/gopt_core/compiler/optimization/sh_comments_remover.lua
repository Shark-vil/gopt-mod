local WriteLog = GOptCore.Api.WriteLog

GOptCore.Api.RegisterScriptOptimizer('GOpt.Opt.RemoveComments', function(lua_object)
	local lua_code = lua_object:GetCode()
	local new_lua_code = ''
	local index = 1
	local lock_chnages_index = 0
	local skip_append_index = 0
	local count = #lua_code
	local logger = {}

	local function str(start_index, end_index)
		if not end_index and start_index then
			end_index = index + start_index - 1
			start_index = index
		elseif not start_index then
			start_index = index
			end_index = start_index
		end
		return lua_code:sub(start_index, end_index)
	end

	while index <= count do
		local lock_append_char = false
		local char = str()

		if lock_chnages_index < index then
			if str(2) == '/*' then
				for i = index + 3, count do
					if str(i, i + 1) == '*/' then
						index = i + 1
						lock_append_char = true

						if not logger['one'] then
							WriteLog('[Optimization] Remove /* */ comment > ', lua_object:GetFilePath())
							logger['one'] = true
						end

						break
					end
				end
			end

			if not lock_append_char and str(3) == '--[' then
				local nesting, nesting_count

				for i = index + 3, count do
					if str(i, i) == '[' then
						nesting = ''
						for _ = 1, i - index - 3 do
							nesting = nesting .. '='
						end
						nesting = ']' .. nesting .. ']'
						nesting_count = #nesting
						break
					elseif str(i, i) ~= '=' then
						break
					end
				end

				if nesting then
					for i = index + 3, count do
						if str(i, i + nesting_count - 1) == nesting then
							index = i + nesting_count - 1
							lock_append_char = true

							if not logger['two'] then
								WriteLog('[Optimization] Remove --[[ ]] comment > ', lua_object:GetFilePath())
								logger['two'] = true
							end

							break
						end
					end
				end
			end

			if not lock_append_char and str(2) == '--' or str(2) == '//' then
				for i = index + 2, count do
					if str(i, i) == '\n' or str(i, i) == '\r' then
						index = i - 1
						lock_append_char = true

						if not logger['three'] then
							WriteLog('[Optimization] Remove // and -- comment > ', lua_object:GetFilePath())
							logger['three'] = true
						end

						break
					end
				end
			end

			if not lock_append_char then
				if char == '\'' or char == '"' then
					for i = index + 1, count do
						if str(i, i) == char and (str(i - 1, i - 1) ~= '\\' or str(i - 2, i - 1) == '\\\\') then
							lock_chnages_index = i + 1
							break
						end
					end
				elseif char == '[' then
					local nesting, nesting_count

					for i = index + 1, count do
						if str(i, i) == '[' then
							nesting = ''
							for _ = 1, i - index - 1 do
								nesting = nesting .. '='
							end
							nesting = ']' .. nesting .. ']'
							nesting_count = #nesting
							break
						elseif str(i, i) ~= '=' then
							break
						end
					end

					if nesting then
						for i = index + 1, count do
							if str(i, i + nesting_count - 1) == nesting then
								lock_chnages_index = i + nesting_count - 1
								skip_append_index = i + nesting_count - 1

								local new_string = str(index + nesting_count, i - 1)
								new_lua_code = new_lua_code .. '\''
								for text in new_string:gmatch('[^\r\n]+') do
									text = text .. '\\n'
									text = text:gsub('\'', '\\\'')
									new_lua_code = new_lua_code .. text
								end
								new_lua_code = new_lua_code .. '\''

								if not logger['four'] then
									WriteLog('[Optimization] Convert text-block to one line  > ', lua_object:GetFilePath())
									logger['four'] = true
								end

								break
							end
						end
					end
				end
			end
		end

		if not lock_append_char and index > skip_append_index then
			new_lua_code = new_lua_code .. char
		end

		index = index + 1
	end

	lua_object:SetCode(new_lua_code)
end)