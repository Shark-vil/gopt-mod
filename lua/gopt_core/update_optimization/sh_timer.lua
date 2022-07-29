local IsLag = GOptCore.Api.IsLag
local IsLagDifference = GOptCore.Api.IsLagDifference
local HasSecondFrame = false
local originalTimerCreate = timer.Create
local string_StartWith = string.StartWith
local IsFocus = GOptCore.Api.IsGameFocus

if GetConVar('gopt_update_optimization'):GetBool() then
	local useSecondFrame = GetConVar('gopt_update_optimization_second_frame'):GetBool()

	function timer.Create(identifier, delay, repetitions, func)
		if string_StartWith(identifier:lower(), 'gopt') then
			return originalTimerCreate(identifier, delay, repetitions, func)
		end

		return originalTimerCreate(identifier, delay, repetitions, repetitions ~= 0 and func or function(...)
			if not IsFocus() or IsLag() or IsLagDifference() then return end
			if useSecondFrame then
				HasSecondFrame = not HasSecondFrame
				if not HasSecondFrame then return end
			end
			return func(...)
		end)
	end
end