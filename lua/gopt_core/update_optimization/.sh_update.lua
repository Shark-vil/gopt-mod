--[[
local GetConVar = GetConVar
local warning_color = Color(245, 148,22)
local text_color = Color(185, 185, 185)
local warning_header = '[WARNING] '
local warning_message = 'lag noticed! "Think" hooks were forcibly slowed down.'
local original_hookAdd = hook.Add
local original_hookRemove = hook.Remove
local original_hookGetTable = hook.GetTable
local async_resume = coroutine.resume
local async_create = coroutine.create
local async_yield = coroutine.yield
local IsLag = GOptCore.Api.IsLag
local IsLagDifference = GOptCore.Api.IsLagDifference
local WriteLog = GOptCore.Api.WriteLog
local CurTime = CurTime
local last_warning_notify_time = 0
local registred_think_functions = {}
local registred_tick_functions = {}
local is_second_frame = false
local think_task
local tick_task

scommand.Create('registred_think_functions').OnShared(function()
	PrintTable(registred_think_functions)
end).Register()

scommand.Create('registred_tick_functions').OnShared(function()
	PrintTable(registred_tick_functions)
end).Register()

local function AsyncProcess(table_functions, ...)
	local current_pass = 0
	local isentity = isentity
	local IsValid = IsValid
	local table_remove = table.remove
	local GetConVar = GetConVar

	while true do
		local enable_opt = GetConVar('gopt_update_optimization'):GetBool()
		local enable_second_frame = GetConVar('gopt_update_optimization_second_frame'):GetBool()

		if enable_second_frame then
			if not is_second_frame then
				is_second_frame = true
				async_yield()
				continue
			else
				is_second_frame = false
			end
		end

		for i = #table_functions, 1, -1 do
			local value = table_functions[i]
			if not value or (isentity(value) and not IsValid(value.hookName)) then
				table_remove(table_functions, i)
				continue
			end

			if value and value.func then value.func(...) end
			if enable_opt then
				if IsLag() or IsLagDifference() then
					if last_warning_notify_time < CurTime() then
						MsgC(warning_color, warning_header, text_color, warning_message, '\n')
						if SERVER then
							WriteLog('[Lags Compensation] ', warning_message)
						end
						last_warning_notify_time = CurTime() + 2
					end
					async_yield()
				end

				current_pass = current_pass + 1
				if current_pass >= 1 / slib.deltaTime then
					current_pass = 0
					async_yield()
				end
			end
		end

		async_yield()
	end
end

local function IsSkippedHook(hookName)
	if not isstring(hookName) then return false end

	local skipped_hooks = {
		'slib*',
		'gopt*',
	}

	local lowerHookName = hookName:lower()
	for i = 1, #skipped_hooks do
		if string.find(lowerHookName, skipped_hooks[i]) then return true end
	end

	return false
end

original_hookAdd('Think', 'GOpt.OptimizationThinkProcess', function(...)
	if not think_task or not async_resume(think_task, registred_think_functions, ...) then
		think_task = async_create(AsyncProcess)
		async_resume(think_task, registred_think_functions, ...)
	end
end)

original_hookAdd('Tick', 'GOpt.OptimizationTickProcess', function(...)
	if not tick_task or not async_resume(tick_task, registred_tick_functions, ...) then
		tick_task = async_create(AsyncProcess)
		async_resume(tick_task, registred_tick_functions, ...)
	end
end)

function hook.Add(hookType, hookName, func)
	if isstring(hookType)
		and (hookType:lower() == 'think' or hookType:lower() == 'tick')
		and not IsSkippedHook(hookName)
	then
		local tbl = hookType:lower() == 'think' and registred_think_functions or registred_tick_functions

		print(hookType, hookName)

		local index, value = table.WhereFindBySeq(tbl, function(_, v)
			return v.hookName == hookName
		end)

		if index ~= -1 then
			value.func = func
		else
			table.insert(tbl, {
				hookName = hookName,
				func = func
			})
		end

		return
	end

	return original_hookAdd(hookType, hookName, func)
end

function hook.Remove(hookType, hookName)
	if isstring(hookType)
		and (hookType:lower() == 'think' or hookType:lower() == 'tick')
		and not IsSkippedHook(hookName)
	then
		local tbl = hookType:lower() == 'think' and registred_think_functions or registred_tick_functions

		local index, _ = table.WhereFindBySeq(tbl, function(_, v)
			return v.hookName == hookName
		end)

		if index ~= -1 then
			table.remove(tbl, index)
			return
		end
	end

	return original_hookRemove(hookType, hookName)
end

local registred_hooks = hook.GetTable()
if registred_hooks then
	if registred_hooks['Think'] then
		for hookName, func in pairs(registred_hooks['Think']) do
			if not IsSkippedHook(hookName) then
				hook.Remove('Think', hookName)
				hook.Add('Think', hookName, func)
			end
		end
	end
	if registred_hooks['Tick'] then
		for hookName, func in pairs(registred_hooks['Tick']) do
			if not IsSkippedHook(hookName) then
				hook.Remove('Tick', hookName)
				hook.Add('Tick', hookName, func)
			end
		end
	end
end

function hook.GetTable()
	local hooks_list = original_hookGetTable()

	for _, v in ipairs(registred_think_functions) do
		hooks_list['Think'] = hooks_list['Think'] or {}
		hooks_list['Think'][v.hookName] = v.func
	end

	for _, v in ipairs(registred_tick_functions) do
		hooks_list['Tick'] = hooks_list['Tick'] or {}
		hooks_list['Tick'][v.hookName] = v.func
	end

	return hooks_list
end
--]]