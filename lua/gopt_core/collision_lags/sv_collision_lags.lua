local IsValid = IsValid
local GetConVar = GetConVar
local CurTime = CurTime
local RemoveWaitMotion = GOptCore.Api.RemoveWaitMotion
local RemoveSmoothUnfreeze = GOptCore.Api.RemoveSmoothUnfreeze
local constraint_GetAllConstrainedEntities = constraint.GetAllConstrainedEntities
local IsLag = GOptCore.Api.IsLag
local WriteLog = GOptCore.Api.WriteLog
--
local function DisableMotion(ent)
	if not IsValid(ent) then return end

	local phy = ent:GetPhysicsObject()
	if not IsValid(phy) then return end
	phy:EnableMotion(false)

	WriteLog('[Collision Lags] ', ent, ', Position  - ', ent:GetPos(), ', Owner - ', ent.Owner)

	RemoveWaitMotion(ent)
	RemoveSmoothUnfreeze(ent)
end

hook.Add('EntityTakeDamage', 'GOpt.CollisionLags', function(ent, dmginfo)
	local cvar_collision_lags = GetConVar('gopt_collision_lags'):GetBool()
	if not cvar_collision_lags then return end

	local cvar_flexable = GetConVar('gopt_collision_lags_flexable'):GetBool()
	if cvar_flexable and not IsLag() then return end
	if not IsValid(ent) then return end
	if dmginfo:GetDamageType() ~= DMG_CRUSH then return end
	if ent:IsVehicle() or ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then return end

	ent.GOpt_CollisionLagCount = ent.GOpt_CollisionLagCount or 0
	ent.GOpt_CollisionLagDelay = ent.GOpt_CollisionLagDelay or 0
	ent.GOpt_CollisionLagResetTime = ent.GOpt_CollisionLagResetTime or 0

	if ent.GOpt_CollisionLagDelay > CurTime() then return end
	if ent.GOpt_CollisionLagCount ~= 0 and ent.GOpt_CollisionLagResetTime < CurTime() then
		ent.GOpt_CollisionLagCount = 0
		MsgN('Reset collision lag count: ', ent)
	end

	if ent.GOpt_CollisionLagCount == 5 then
		local attacker = dmginfo:GetAttacker()
		if ent:GetParent() == attacker and not IsLag() then return end

		local cvar_constraints = GetConVar('gopt_collision_lags_constraints'):GetBool()
		local cvar_constraints_flexable = GetConVar('gopt_collision_lags_constraints_flexable'):GetBool()
		if cvar_constraints then
			local constrained_entities = constraint_GetAllConstrainedEntities(ent)
			local is_constrained = IsValid(constrained_entities[attacker])

			if is_constrained and (not cvar_constraints_flexable or IsLag()) then
				DisableMotion(attacker)
				MsgN('GOpt - stop collision lag: ', attacker)
			end
		end

		DisableMotion(ent)
		MsgN('GOpt - stop collision lag: ', ent)

		ent.GOpt_CollisionLagCount = 0
	end

	ent.GOpt_CollisionLagCount = ent.GOpt_CollisionLagCount + 1
	ent.GOpt_CollisionLagDelay = CurTime() + 1
	ent.GOpt_CollisionLagResetTime = CurTime() + 3
end)