local IsValid = IsValid
local GetConVar = GetConVar
local AddWaitMotion = GOptCore.Api.AddWaitMotion
local GetConstraintEntities = GOptCore.Api.GetConstraintEntities
local GetWaitMotionEntities = GOptCore.Api.GetWaitMotionEntities
local IsMotionLocked = GOptCore.Api.IsMotionLocked
local AddMotionDelay = GOptCore.Api.AddMotionDelay
local SetLockMotion = GOptCore.Api.SetLockMotion
local IsLag = GOptCore.Api.IsLag
local RemoveWaitMotionById = GOptCore.Api.RemoveWaitMotionById
--

async.Add('GOpt.DynamicMotion.EnableWaitEntities', function(yield, wait)
	while true do
		if not GetConVar('gopt_dynamic_motion'):GetBool() then
			wait(1)
		else
			local wait_entities = GetWaitMotionEntities()
			for i = #wait_entities, 1, -1 do
				local ent = wait_entities[i]

				if IsValid(ent) and IsMotionLocked(ent) then
					AddMotionDelay(ent, 4)
					SetLockMotion(ent, false)

					local entities = GetConstraintEntities(ent)
					for k = 1, #entities do
						if entities[k] ~= ent then
							AddWaitMotion(entities[k])
						end
					end

					local phy = ent:GetPhysicsObject()
					if IsValid(phy) then
						phy:EnableMotion(true)
						phy:Wake()

						if IsLag() then
							wait(.1)
						else
							yield()
						end
					end
				end

				RemoveWaitMotionById(i)
			end
		end

		yield()
	end
end)