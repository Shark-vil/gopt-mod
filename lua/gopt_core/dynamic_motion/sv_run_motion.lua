local IsValid = IsValid
local GetConVar = GetConVar
local AddWaitMotion = GOptCore.Api.AddWaitMotion
local pairs = pairs
local GetConstraintEntities = constraint.GetAllConstrainedEntities
local GetWaitMotionEntities = GOptCore.Api.GetWaitMotionEntities
local IsMotionLocked = GOptCore.Api.IsMotionLocked
local AddMotionDelay = GOptCore.Api.AddMotionDelay
local SetLockMotion = GOptCore.Api.SetLockMotion
local IsLag = GOptCore.Api.IsLag
local RemoveWaitMotionById = GOptCore.Api.RemoveWaitMotionById
--

async.Add('GOpt.DynamicMotion.EnableWaitEntities', function(yield, wait)
	local current_pass = 0

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
					for _, other_ent in pairs(entities) do
						if other_ent ~= ent then
							AddWaitMotion(other_ent)
						end
					end

					local phy = ent:GetPhysicsObject()
					if IsValid(phy) then
						phy:EnableMotion(true)
						phy:Wake()
						phy:SetVelocity(Vector(0, 0, 0))

						if IsLag() then
							wait(.1)
						else
							yield()
						end
					end

					current_pass = current_pass + 1
					if current_pass >= 1 / slib.deltaTime then
						current_pass = 0
						yield()
					end
				end

				RemoveWaitMotionById(i)
			end
		end

		yield()
	end
end, true)