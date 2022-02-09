local IsValid = IsValid
local CurTime = CurTime
local IsMotionLocked = GOptCore.Api.IsMotionLocked
local AddMotionDelay = GOptCore.Api.AddMotionDelay
local SetLockMotion = GOptCore.Api.SetLockMotion
local RemoveWaitMotion = GOptCore.Api.RemoveWaitMotion
--
local max_damage_for_one_sec = 20
local current_damage = 0
local damage_delay = 0

hook.Add('EntityTakeDamage', 'GOpt.DamageMotion', function(ent, dmginfo)
	if damage_delay > CurTime() then return end
	if not IsMotionLocked(ent) then return end

	AddMotionDelay(ent)
	SetLockMotion(ent, false)

	local phy = ent:GetPhysicsObject()
	if IsValid(phy) then
		phy:EnableMotion(true)
		phy:Wake()
		phy:ApplyForceOffset(dmginfo:GetDamageForce(), dmginfo:GetDamagePosition())
	end

	RemoveWaitMotion(ent)

	current_damage = current_damage + 1
	if max_damage_for_one_sec == current_damage then
		current_damage = 0
		damage_delay = CurTime() + .5
	end
end)