local IsValid = IsValid
local AddMotionDelay = GOptCore.Api.AddMotionDelay
local timer_Simple = timer.Simple
--

hook.Add('OnEntityCreated', 'GOpt.MotionIgnore', function(ent)
	timer_Simple(0, function()
		-- if not IsValid(ent) or ent:GetClass() ~= 'prop_physics' then return end
		if not IsValid(ent) then return end

		local phy = ent:GetPhysicsObject()
		if not IsValid(phy) then return end

		AddMotionDelay(ent)

		-- ent:AddEFlags(EFL_NO_THINK_FUNCTION)
		ent:SetCustomCollisionCheck(true)
	end)
end)