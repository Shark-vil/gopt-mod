local IsLag = GOptCore.Api.IsLag
local IsLagDifference = GOptCore.Api.IsLagDifference
local originalHookAdd = hook.Add
local table_HasValueBySeq =  table.HasValueBySeq
local string_StartWith = string.StartWith
local string_Trim = string.Trim
local isstring = isstring
local IsFocus = GOptCore.Api.IsGameFocus
local isfunction = isfunction

local updateHooks = {
	'think',
	'tick',
}

local systemHooks = {
	'slib',
	'gopt'
}

local function IsSystemHook(hookName)
	if SERVER and not isstring(hookName) then
		return isentity(hookName) and hookName:IsWeapon()
	end

	local normalHookName = string_Trim(hookName:lower())
	for i = 1, #systemHooks do
		if string_StartWith(normalHookName, systemHooks[i]) then
			return true
		end
	end

	return false
end

local function OverrideHookAdd()
	function hook.Add(hookType, hookName, func, ...)
		if not isfunction(func) then return end

		local normalHookType = string_Trim(hookType:lower())
		local hasSecondFrame = false
		local useSecondFrame = GetConVar('gopt_update_optimization_second_frame'):GetBool()

		if not table_HasValueBySeq(updateHooks, normalHookType) or IsSystemHook(hookName) then
			return originalHookAdd(hookType, hookName, func)
		end

		return originalHookAdd(hookType, hookName, function(...)
			if not IsFocus() or IsLag() or IsLagDifference() then return end
			if useSecondFrame then
				hasSecondFrame = not hasSecondFrame
				if not hasSecondFrame then return end
			end
			return func(...)
		end, ...)
	end
end

local useUpdateOptimization = GetConVar('gopt_update_optimization'):GetBool()
if useUpdateOptimization then
	OverrideHookAdd()
end

hook.Add('InitPostEntity', 'GOpt.UpdateOptimizer.Init', function()
	timer.Simple(1, function()
		local allowHooks = hook.GetTable()
		if allowHooks['Think'] then
			for hookName, hookFunction in pairs(allowHooks['Think']) do
				hook.Add('Think', hookName, hookFunction)
			end
		end
		if allowHooks['Tick'] then
			for hookName, hookFunction in pairs(allowHooks['Tick']) do
				hook.Add('Tick', hookName, hookFunction)
			end
		end
	end)
end)