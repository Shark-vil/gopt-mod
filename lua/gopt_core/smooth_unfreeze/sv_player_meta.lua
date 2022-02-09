local IsValid = IsValid
local CurTime = CurTime
local AddSmoothUnfreeze = GOptCore.Api.AddSmoothUnfreeze
local IsSmoothUnfreeze = GOptCore.Api.IsSmoothUnfreeze
local GetConstraintEntities = GOptCore.Api.GetConstraintEntities
--
local meta = FindMetaTable('Player')

GOptCore.Storage.PlayerPhysgunUnfreeze = GOptCore.Storage.PlayerPhysgunUnfreeze or meta.PhysgunUnfreeze

function meta:PhysgunUnfreeze(...)
	if not GetConVar('gopt_smooth_unfreeze'):GetBool() then
		return GOptCore.Storage.PlayerPhysgunUnfreeze(self, ...)
	end

	if self.GOpt_DelayPhysgunUnfreeze and self.GOpt_DelayPhysgunUnfreeze > CurTime() then
		return 0
	end

	self.GOpt_DelayPhysgunUnfreeze = CurTime() + .3

	local tr = self:GetEyeTrace()
	local ent = tr.Entity

	if not tr.HitNonWorld or not IsValid(ent) then return 0 end

	if not IsSmoothUnfreeze(ent) then
		local entities = GetConstraintEntities(ent)

		for i = 1, #entities do
			local other_ent = entities[i]

			if IsSmoothUnfreeze(other_ent) then
				continue
			end

			AddSmoothUnfreeze(ply, other_ent)
		end

		return #entities
	end

	return 0
end