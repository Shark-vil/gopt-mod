local IsValid = IsValid
local pairs = pairs
local GetConstraintEntities = constraint.GetAllConstrainedEntities
local IsMotionLocked = GOptCore.Api.IsMotionLocked
local SetLockMotion = GOptCore.Api.SetLockMotion
local RemoveWaitMotion = GOptCore.Api.RemoveWaitMotion
local AddMotionDelay = GOptCore.Api.AddMotionDelay
--

hook.Add('OnPhysgunPickup', 'GOpt.MotionPhysgunPickup', function(_, ent)
	local entities = GetConstraintEntities(ent)
	for _, other_ent in pairs(entities) do
		other_ent.GOpt_MotionPhysgunFreeze = true

		if IsMotionLocked(other_ent) then
			AddMotionDelay(other_ent)
			SetLockMotion(other_ent, false)
			RemoveWaitMotion(other_ent)

			local phy = other_ent:GetPhysicsObject()
			if IsValid(phy) then
				phy:EnableMotion(true)
				phy:Wake()
			end
		end
	end
end)

local on_physgun_freeze_entities = {}

hook.Add('PhysgunDrop', 'GOpt.MotionPhysgunDrop', function(_, ent)
	if on_physgun_freeze_entities[ent] then
		on_physgun_freeze_entities[ent] = false
		return
	end

	local entities = GetConstraintEntities(ent)
	for _, other_ent in pairs(entities) do
		if other_ent.GOpt_MotionPhysgunFreeze then
			other_ent.GOpt_MotionPhysgunFreeze = false
			AddMotionDelay(other_ent)
			SetLockMotion(other_ent, false)
			RemoveWaitMotion(other_ent)
		end
	end
end)

hook.Add('OnPhysgunFreeze', 'GOpt.MotionPhysgunFreeze', function(_, phy, ent)
	on_physgun_freeze_entities[ent] = true

	local entities = GetConstraintEntities(ent)
	for _, other_ent in pairs(entities) do
		if other_ent.GOpt_MotionPhysgunFreeze then
			other_ent.GOpt_MotionPhysgunFreeze = true
			AddMotionDelay(other_ent)
			SetLockMotion(other_ent, false)
			RemoveWaitMotion(other_ent)
		end
	end
end)