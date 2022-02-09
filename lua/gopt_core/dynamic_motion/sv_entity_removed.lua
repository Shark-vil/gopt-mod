local IsValid = IsValid
local ents_FindInSphere = ents.FindInSphere
local AddWaitMotion = GOptCore.Api.AddWaitMotion
--

hook.Add('EntityRemoved', 'GOpt.MotionEntityRemoved', function(ent)
	local position = ent:GetPos()
	local radius = ent:BoundingRadius() + 25
	local entities = ents_FindInSphere(position, radius)

	for i = 1, #entities do
		local target = entities[i]
		if target == ent or not IsValid(target) or not target.GOpt_MotionLocked then
			continue
		end

		AddWaitMotion(target)
	end
end)