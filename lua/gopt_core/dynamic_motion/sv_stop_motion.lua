local GetConVar = GetConVar
local ents_GetAll = ents.GetAll
local IsStoppedMotionMovement = GOptCore.Api.IsStoppedMotionMovement
local RemoveWaitMotion = GOptCore.Api.RemoveWaitMotion
local SetLockMotion = GOptCore.Api.SetLockMotion
--

async.Add('GOpt.DynamicMotion.StopMotion', function(yield, wait)
	while true do
		if not GetConVar('gopt_dynamic_motion'):GetBool() then
			wait(1)
		else
			local entities = ents_GetAll()

			for i = 1, #entities do
				local ent = entities[i]
				if IsStoppedMotionMovement(ent) then
					local phy = ent:GetPhysicsObject()
					phy:EnableMotion(false)

					RemoveWaitMotion(ent)
					SetLockMotion(ent, true)

					print('Stop motion', ent)

					yield()
				end
			end
		end

		wait(.1)
	end
end, true)