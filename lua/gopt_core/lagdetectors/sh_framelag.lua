local SysTime = SysTime
local CurTime = CurTime
local math_Round = math.Round
--
local last_time_difference = 9999
local delta_time = 0
local lag_point = 0.07
local lag_count = 0
local lag_count_delay = 0
local is_real_lag = false

local function GetCurrentDelta()
	local time_difference = SysTime() - CurTime()
	delta_time = time_difference - last_time_difference
	delta_time = math_Round(delta_time, 6)
	last_time_difference = time_difference
	return delta_time
end

timer.Create('GOpt.FrameLagDetector', 1, 0,  function()
	local delta = GetCurrentDelta()
	local is_lag = delta >= lag_point

	if is_lag then
		if lag_count < 5 then
			lag_count = lag_count + 1
			lag_count_delay = CurTime() + 1
			is_lag = false
		end
	else
		if lag_count_delay < CurTime() and lag_count - 1 >= 0 then
			lag_count = lag_count - 1
		end
	end

	is_real_lag = is_lag

	-- if is_real_lag then
	-- 	hook.Run('GOpt.LagDetector.FrameTime', delta)
	-- end
end)

function GOptCore.Api.IsLag()
	return is_real_lag
end