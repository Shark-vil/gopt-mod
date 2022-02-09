local IsValid = IsValid
local GetConstraintEntities = GOptCore.Api.GetConstraintEntities
local SetLockMotion = GOptCore.Api.SetLockMotion
local AddWaitMotion = GOptCore.Api.AddWaitMotion
local table_Combine = table.Combine
--

hook.Add('PlayerEnteredVehicle', 'GOpt.MotionUnlockVehicle', function(ply, vehicle)
	local entities = GetConstraintEntities(vehicle)
	local parent = vehicle:GetParent()
	if IsValid(parent) then
		table_Combine(entities, GetConstraintEntities(parent, entities))
	end

	for k = 1, #entities do
		local ent = entities[k]
		if ent and IsValid(ent) and not ent.GOpt_MotionVehicleActive then
			ent.GOpt_MotionVehicleActive = true

			SetLockMotion(ent, false)
			AddWaitMotion(ent)

			local phy = ent:GetPhysicsObject()
			if IsValid(phy) then
				phy:EnableMotion(true)
				phy:Wake()
			end
		end
	end
end)

hook.Add('CanExitVehicle', 'GOpt.MotionUnlockVehicle', function(vehicle, ply)
	local entities = GetConstraintEntities(vehicle)
	local parent = vehicle:GetParent()
	if IsValid(parent) then
		table_Combine(entities, GetConstraintEntities(parent))
	end

	for k = 1, #entities do
		local ent = entities[k]
		if ent and IsValid(ent) and ent.GOpt_MotionVehicleActive then
			ent.GOpt_MotionVehicleActive = false
		end
	end
end)