local function SetVehicleNoThink(vehicle)
	if IsValid(vehicle) and vehicle:GetClass() == 'prop_vehicle_prisoner_pod' then
		vehicle:AddEFlags(EFL_NO_THINK_FUNCTION)
	end
end

hook.Add('OnEntityCreated', 'GOpt.VehicleSeatsOptimize', function(ent)
	timer.Simple(0, function()
		SetVehicleNoThink(ent)
	end)
end)

hook.Add('InitPostEntity', 'GOpt.VehicleSeatsOptimize', function()
	timer.Simple(1, function()
		local entities = ents.GetAll()
		for i = 1, #entities do
			SetVehicleNoThink(entities[i])
		end
	end)
end)

hook.Add('PlayerLeaveVehicle', 'VehicleSeatsOptimizeLeave', function(ply, vehicle)
	SetVehicleNoThink(vehicle)
end)

hook.Add('PlayerEnteredVehicle', 'VehicleSeatsOptimizeLeave', function(ply, vehicle)
	if IsValid(vehicle) and vehicle:GetClass() == 'prop_vehicle_prisoner_pod' then
		local animate = vehicle:GetSaveTable()
		if animate['m_bEnterAnimOn'] or animate['m_bExitAnimOn'] then
			vehicle:RemoveEFlags(EFL_NO_THINK_FUNCTION)
		else
			vehicle:AddEFlags(EFL_NO_THINK_FUNCTION)
		end
	end
end)