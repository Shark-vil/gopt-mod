originalHookAdd = originalHookAdd or hook.Add
originalHookRemove = originalHookRemove or hook.Remove
thinkHookStorage = thinkHookStorage or {}

local process
local FrameTime = FrameTime
local async_resume = coroutine.resume
local async_create = coroutine.create
local async_yield = coroutine.yield
local async_wait = coroutine.wait
local IsLag = GOptCore.Api.IsLag

local function IsValidHookType(hookType, validHookType)
	return hookType:lower() == validHookType
end

local function AsyncProcess()
	while true do
		for i = 1, #thinkHookStorage do
			local value = thinkHookStorage[i]
			if value and value.func then value.func() end
			if IsLag() then async_yield() end
		end
		async_yield()
	end
end

originalHookAdd('Think', 'OptimizationThink', function()
	if not process or not async_resume(process) then
		process = async_create(AsyncProcess)
		async_resume(process)
	end
end)

function hook.Add(hookType, hookName, func)
	if IsValidHookType(hookType, 'think') then
		local index, value = table.WhereFindBySeq(thinkHookStorage, function(_, v)
			return v.hookName == hookName
		end)

		if index ~= -1 then
			value.func = func
		else
			table.insert(thinkHookStorage, {
				hookName = hookName,
				func = func
			})
		end

		return
	end

	originalHookAdd(hookType, hookName, func)
end

function hook.Remove(hookType, hookName)
	if IsValidHookType(hookType, 'think') then
		local index, _ = table.WhereFindBySeq(thinkHookStorage, function(_, v)
			return v.hookName == hookName
		end)

		if index ~= -1 then
			table.remove(thinkHookStorage, index)
			return
		end
	end

	originalHookRemove(hookType, hookName)
end

local allowHooks = hook.GetTable()
if allowHooks and allowHooks['Think'] then
	for hookName, func in pairs(allowHooks['Think']) do
		if hookName ~= 'OptimizationThink' then
			hook.Remove('Think', hookName)
			hook.Add('Think', hookName, func)
		end
	end
end