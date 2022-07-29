local Color = Color
local IsValid = IsValid
local ents_GetAll = ents.GetAll

if SERVER then
	timer.Create('GOpt.MotionDebug', 1, 0, function()
		local entities = ents_GetAll()
		for i = 1, #entities do
			local ent = entities[i]
			if not ent or not IsValid(ent) or ent:GetClass() ~= 'prop_physics' then continue end

			local phy = ent:GetPhysicsObject()
			if not IsValid(phy) then continue end

			ent.GOpt_OriginalColor = ent.GOpt_OriginalColor or ent:GetColor()

			if not ent.GOpt_MotionLocked and phy:IsMotionEnabled() then
				ent:SetColor(ent.GOpt_OriginalColor)
			elseif ent.GOpt_MotionLocked then
				ent:SetColor(Color(231, 103, 103))
			end
		end
	end)
end