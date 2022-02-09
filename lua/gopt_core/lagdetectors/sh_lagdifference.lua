local CurTime = CurTime
local table_remove = table.remove
--
local last_delta_time_collection = {}
local delta_time_history = {}
local lag_difference = 0
local lag_difference_skip_delay = 0
local lock_think = false

function GOptCore.Api.LagDifference()
	return lag_difference
end

function GOptCore.Api.IsLagDifference(critical_difference)
	if not critical_difference then critical_difference = 75 end
	return lag_difference >= critical_difference
end

hook.Add('Think', 'GOpt.CalculateFrame', function()
	lock_think = not lock_think
	if lock_think then return end

	local last_delta_time_collection_count = #last_delta_time_collection
	if last_delta_time_collection_count == 10 then
		local last_delta_time_summ = 0
		for i = 1, last_delta_time_collection_count do
			last_delta_time_summ = last_delta_time_summ + last_delta_time_collection[i]
		end

		local current_delta_time_average = last_delta_time_summ / 10
		local delta_time_history_count = #delta_time_history
		if delta_time_history_count == 10 then
			local difference_summ = 0

			for i = 1, delta_time_history_count do
				local past_delta_time = delta_time_history[i]
				local max_number, min_number

				if current_delta_time_average > past_delta_time then
					max_number = current_delta_time_average
					min_number = past_delta_time
				else
					max_number = past_delta_time
					min_number = current_delta_time_average
				end

				local difference = ((max_number - min_number) / max_number) * 100
				difference_summ = difference_summ + difference
			end

			lag_difference = difference_summ / delta_time_history_count

			if lag_difference >= 50 and lag_difference_skip_delay < CurTime() then
				lag_difference_skip_delay = CurTime() + 1
				-- hook.Run('GOpt.LagDetector.Difference', lag_difference)
				return
			end

			table_remove(delta_time_history, 1)
		end

		delta_time_history[#delta_time_history + 1] = current_delta_time_average
		last_delta_time_collection = {}
	end

	last_delta_time_collection[#last_delta_time_collection + 1] = slib.deltaTime
end)