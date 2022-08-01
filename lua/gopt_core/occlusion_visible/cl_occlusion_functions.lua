local IsValid = IsValid
local LocalPlayer = LocalPlayer
-- local string_StartWith = string.StartWith
--
local cvar_occlusion_ignore_npc = GetConVar('gopt_occlusion_ignore_npc')
local cvar_occlusion_ignore_players = GetConVar('gopt_occlusion_ignore_players')
local cvar_occlusion_ignore_vehicles = GetConVar('gopt_occlusion_ignore_vehicles')
--

local function IsProp(ent)
	-- return string_StartWith(ent:GetClass(), 'prop_')
	local entity_class = ent:GetClass()
	return entity_class == 'prop_physics' or entity_class == 'prop_static'
end

function GOptCore.Api.IsValidOcclusionCheck(ent)
	if not IsValid(ent) then return false end
	if ent == LocalPlayer() then return false end
	if ent.isBgnActor then return false end
	if ent:slibIsDoor() then return false end

	local is_npc = ent:IsNPC() or ent:IsNextBot()
	if is_npc then
		return not cvar_occlusion_ignore_npc:GetBool()
	end

	local is_vehicle = ent:IsVehicle()
	if is_vehicle then
		return not cvar_occlusion_ignore_vehicles:GetBool()
	end

	local is_player = ent:IsPlayer()
	if is_player then
		return not cvar_occlusion_ignore_players:GetBool()
	end

	if IsProp(ent) or ent:IsWeapon() then
		return true
	end

	return false
end