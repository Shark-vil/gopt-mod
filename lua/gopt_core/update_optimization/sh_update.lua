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
local max_pass = 20
local current_pass = 0
local CurTime = CurTime
local last_warning_notify_time = 0
local registred_think_functions = {}
local is_second_frame = false
local process

local function AsyncProcess(...)
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

		for i = 1, #registred_think_functions do
			local value = registred_think_functions[i]
			if value and value.func then value.func(...) end
			if enable_opt and (IsLag() or IsLagDifference()) then
				if last_warning_notify_time < CurTime() then
					MsgC(warning_color, warning_header, text_color, warning_message, '\n')
					if SERVER then
						WriteLog('[Lags Compensation] ', warning_message)
					end
					last_warning_notify_time = CurTime() + 2
				end
				async_yield()
			end
		end

		-- if enable_opt then
		-- 	if current_pass == max_pass then
		-- 		current_pass = 0
		-- 		async_yield()
		-- 	else
		-- 		current_pass = current_pass + 1
		-- 	end
		-- end

		async_yield()
	end
end

local function IsSkippedHook(hookName)
	if not isstring(hookName) then return false end

	local skipped_hooks = {
		'slib_async_GOpt*',
		'GOpt*',
	}

	for i = 1, #skipped_hooks do
		if string.find(hookName, skipped_hooks[i]) then return true end
	end

	return false
end

original_hookAdd('Think', 'GOpt.OptimizationThinkProcess', function(...)
	if not process or not async_resume(process, ...) then
		process = async_create(AsyncProcess)
		async_resume(process, ...)
	end
end)

function hook.Add(hookType, hookName, func)
	if isstring(hookType) and hookType:lower() == 'think' and not IsSkippedHook(hookName) then
		local index, value = table.WhereFindBySeq(registred_think_functions, function(_, v)
			return v.hookName == hookName
		end)

		if index ~= -1 then
			value.func = func
		else
			table.insert(registred_think_functions, {
				hookName = hookName,
				func = func
			})
		end

		return
	end

	return original_hookAdd(hookType, hookName, func)
end

function hook.Remove(hookType, hookName)
	if isstring(hookType) and hookType:lower() == 'think' and not IsSkippedHook(hookName) then
		local index, _ = table.WhereFindBySeq(registred_think_functions, function(_, v)
			return v.hookName == hookName
		end)

		if index ~= -1 then
			table.remove(registred_think_functions, index)
			return
		end
	end

	return original_hookRemove(hookType, hookName)
end

local registred_hooks = hook.GetTable()
if registred_hooks and registred_hooks['Think'] then
	for hookName, func in pairs(registred_hooks['Think']) do
		if not IsSkippedHook(hookName) then
			hook.Remove('Think', hookName)
			hook.Add('Think', hookName, func)
		end
	end
end

function hook.GetTable()
	local hooks_list = original_hookGetTable()

	for _, v in ipairs(registred_think_functions) do
		hooks_list['Think'] = hooks_list['Think'] or {}
		hooks_list['Think'][v.hookName] = v.func
	end

	return hooks_list
end