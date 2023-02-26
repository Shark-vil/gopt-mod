local meta = FindMetaTable('Entity')
local IsLag = GOptCore.Api.IsLag
local IsLagDifference = GOptCore.Api.IsLagDifference
local IsValid = IsValid
local IsFocus = GOptCore.Api.IsGameFocus
local is_update_optimization = GetConVar('gopt_update_optimization'):GetBool()
local defaultIgnoreList = {
	-- 'manipulate_flex'
}

cvars.AddChangeCallback('gopt_update_optimization', function(_, _, value)
	is_update_optimization = tobool(value)
end, 'gopt_update_optimization')

local originalEmitSound = meta.EmitSound

function meta:EmitSound(...)
	if is_update_optimization and (not IsFocus() or IsLag() or IsLagDifference()) then
		return
	end
	return originalEmitSound(self, ...)
end

local function GetMaxPass(ent)
	local entityClass = ent:GetClass()

	if table.HasValueBySeq(defaultIgnoreList, entityClass) then
		return 0
	elseif table.HasValueBySeq(GOptCore.Storage.IgnoreEntitiesTickrate, entityClass) then
		return 0
	end

	if ent:IsWeapon() then
		if ent.Primary and not ent.Primary.Automatic then return 0 end
		if ent.Secondary and not ent.Secondary.Automatic then return 0 end
		return GetConVar('gopt_entity_tickrate_weapon'):GetInt()
	elseif ent:IsNPC() then
		return GetConVar('gopt_entity_tickrate_npc'):GetInt()
	elseif ent:IsVehicle() then
		return GetConVar('gopt_entity_tickrate_vehicle'):GetInt()
	elseif ent:IsNextBot() then
		return GetConVar('gopt_entity_tickrate_nextbot'):GetInt()
	else
		return GetConVar('gopt_entity_tickrate_other'):GetInt()
	end
end

hook.Add('OnEntityCreated', 'GOpt.ReplaceNewEntityThink', function(ent)
	if not IsValid(ent) or not is_update_optimization then return end

	timer.Simple(1, function()
		if not IsValid(ent) then return end

		local max_pass = GetMaxPass(ent)

		local originalThink = ent.Think
		if originalThink then
			local current_pass = 0
			local delta_current_pass = 0

			function ent:Think(...)
				if is_update_optimization then
					if not IsFocus() or IsLag() or IsLagDifference() then return end

					if max_pass > 0 then
						current_pass = current_pass - 1
						if current_pass > 0 then return end
						current_pass = max_pass
					end

					delta_current_pass = delta_current_pass + 1
					if delta_current_pass > 1 / slib.deltaTime then
						delta_current_pass = 0
						return
					end
				end

				return originalThink(ent, ...)
			end
		end

		-- May be removed. Inefficient, and in most cases will not work.
		local originalRunBehaviour = ent.RunBehaviour
		if originalRunBehaviour then
			local current_pass = 0
			local delta_current_pass = 0

			function ent:RunBehaviour(...)
				if is_update_optimization then
					if not IsFocus() or IsLag() or IsLagDifference() then return end

					if max_pass > 0 then
						current_pass = current_pass - 1
						if current_pass > 0 then return end
						current_pass = max_pass
					end

					delta_current_pass = delta_current_pass + 1
					if delta_current_pass > 1 / slib.deltaTime then
						delta_current_pass = 0
						return
					end
				end

				return originalRunBehaviour(ent, ...)
			end
		end
	end)
end)