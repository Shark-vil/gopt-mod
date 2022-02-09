local CurTime = CurTime
local IsMotionLocked = GOptCore.Api.IsMotionLocked
local IsMotionDelay = GOptCore.Api.IsMotionDelay
local AddWaitMotion = GOptCore.Api.AddWaitMotion
-- local AddMotionDelay = GOptCore.Api.AddMotionDelay
--
local max_unfreeze_per_sec = GetConVar('gopt_dynamic_motion_max_unfreeze_per_second'):GetInt()
local max_unfreeze_delay = GetConVar('gopt_dynamic_motion_unfreeze_delay'):GetFloat()
local current_collide = 0
local collide_delay = 0

cvars.AddChangeCallback('gopt_dynamic_motion_max_unfreeze_per_second', function(_, _, value)
	value = tonumber(value)
	if not value then return end
	max_unfreeze_per_sec = math.floor(value)
end, 'gopt_dynamic_motion_max_unfreeze_per_second')

cvars.AddChangeCallback('gopt_dynamic_motion_unfreeze_delay', function(_, _, value)
	value = tonumber(value)
	if not value then return end
	max_unfreeze_delay = value
end, 'gopt_dynamic_motion_unfreeze_delay')

hook.Add('ShouldCollide', 'GOpt.MotionUnlocked', function(target, ent)
	if collide_delay > CurTime() then return end

	if not IsMotionLocked(target) then
		-- if IsMotionDelay(target) then AddMotionDelay(target, 1) end
		return
	end

	if IsMotionLocked(ent) then
		-- if IsMotionDelay(ent) then AddMotionDelay(ent, 1) end
		return
	end

	if IsMotionDelay(target) or IsMotionDelay(ent) then return end

	if target.GOpt_MotionPhysgunFreeze or target.GOpt_MotionVehicleActive then return end
	-- if ent.GOpt_MotionPhysgunFreeze or ent.GOpt_MotionVehicleActive then return end

	AddWaitMotion(target)

	current_collide = current_collide + 1
	if max_unfreeze_per_sec == current_collide then
		current_collide = 0
		collide_delay = CurTime() + max_unfreeze_delay
	end
end)