local IsValid = IsValid
local table_remove = table.remove
local constraint_GetAllConstrainedEntities = constraint.GetAllConstrainedEntities
-- local IsLag = GOptCore.Api.IsLag
local pairs = pairs
local math_abs = math.abs
local MOVETYPE_VPHYSICS = MOVETYPE_VPHYSICS
-- local coroutine_running = coroutine.running
-- local coroutine_yield = coroutine.yield
--
CreateConVar('gopt_motion_optimization', '1', FCVAR_ARCHIVE, '', 0, 1)

local wait_entities = {}

function GOptCore.Api.AddMotionDelay(ent, delay)
	delay = delay or 2.5
	ent.GOpt_MotionIgnoreDelay = CurTime() + delay
end

function GOptCore.Api.IsMotionDelay(ent)
	ent.GOpt_MotionIgnoreDelay = ent.GOpt_MotionIgnoreDelay or 0
	return ent.GOpt_MotionIgnoreDelay > CurTime()
end

function GOptCore.Api.SetLockMotion(ent, state)
	ent.GOpt_MotionLocked = state
end

function GOptCore.Api.IsMotionLocked(ent)
	return ent.GOpt_MotionLocked or false
end

function GOptCore.Api.GetWaitMotionEntities()
	return wait_entities
end

function GOptCore.Api.IsWaitMotion(ent)
	for i = #wait_entities, 1, -1 do
		if wait_entities[i] == ent then return true end
	end
	return false
end

function GOptCore.Api.AddWaitMotion(ent)
	if GOptCore.Api.IsWaitMotion(ent) then return end
	wait_entities[#wait_entities + 1] = ent
end

function GOptCore.Api.RemoveWaitMotion(ent)
	for i = #wait_entities, 1, -1 do
		if wait_entities[i] == ent then
			table_remove(wait_entities, i)
			break
		end
	end
end

function GOptCore.Api.RemoveWaitMotionById(index)
	local count = #wait_entities
	if count == 0 or count < index then return end
	table_remove(wait_entities, index)
end

function GOptCore.Api.GetConstraintEntities(ent)
	local entities = { ent }
	local index = 1

	for k, v in pairs(constraint_GetAllConstrainedEntities(ent)) do
		if v ~= ent then
			index = index + 1
			entities[index] = v
		end
	end

	return entities
end

function GOptCore.Api.IsValidStoppedMotionMovement(ent, skip_constraint)
	if not IsValid(ent) or ent:GetMoveType() ~= MOVETYPE_VPHYSICS then return false end
	if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then return false end
	if GOptCore.Api.IsMotionLocked(ent) then return false end
	if GOptCore.Api.IsMotionDelay(ent) then return false end
	if ent.GOpt_MotionPhysgunFreeze then return false end
	if ent.GOpt_MotionVehicleActive then return false end
	if GOptCore.Api.IsSkippedClass(ent:GetClass()) then return false end

	local phy = ent:GetPhysicsObject()
	if not IsValid(phy) or not phy:IsMotionEnabled() then return false end

	-- if not skip_constraint then
	-- 	local entities = GOptCore.Api.GetConstraintEntities(ent)
	-- 	for i = 1, #entities do
	-- 		local other_ent = entities[i]
	-- 		if IsValid(other_ent)
	-- 			and other_ent ~= ent
	-- 			and not GOptCore.Api.IsValidStoppedMotionMovement(other_ent, true)
	-- 		then
	-- 			return false
	-- 		end

	-- 		if coroutine_running() then
	-- 			coroutine_yield()
	-- 		end
	-- 	end
	-- end

	return true
end

function GOptCore.Api.IsStoppedMotionMovement(ent)
	if not GOptCore.Api.IsValidStoppedMotionMovement(ent) then return false end

	local phy = ent:GetPhysicsObject()
	local velocity = phy:GetVelocity()
	local scale = 3.5
	local x = math_abs(velocity.x)
	local y = math_abs(velocity.y)
	local z = math_abs(velocity.z)

	if x <= scale and y <= scale and z <= scale then
		return true
	end

	GOptCore.Api.AddMotionDelay(ent, 1)

	return false
end