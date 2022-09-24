local IsValid = IsValid
local pairs = pairs
local GetConstraintEntities = constraint.GetAllConstrainedEntities
local SetLockMotion = GOptCore.Api.SetLockMotion
local AddWaitMotion = GOptCore.Api.AddWaitMotion
local table_Combine = table.Combine
local table_ValuesToArray = table.ValuesToArray
--

hook.Add('PlayerEnteredVehicle', 'GOpt.MotionUnlockVehicle', function(ply, vehicle)
	local entities = GetConstraintEntities(vehicle)
	local parent = vehicle:GetParent()
	if IsValid(parent) then
		table_Combine(entities, table_ValuesToArray(GetConstraintEntities(parent)))
	end

	for _, ent in pairs(entities) do
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
		table_Combine(entities, table_ValuesToArray(GetConstraintEntities(parent)))
	end

	for _, ent in pairs(entities) do
		if ent and IsValid(ent) and ent.GOpt_MotionVehicleActive then
			ent.GOpt_MotionVehicleActive = false
		end
	end
end)