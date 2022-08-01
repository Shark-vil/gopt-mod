---------------------------------------
-- Import
---------------------------------------
local LocalPlayer = LocalPlayer
local IsValid = IsValid
local FrameTime =  FrameTime
local LerpVector = LerpVector
local LocalToWorld = LocalToWorld
local Vector = Vector
local table_sort = table.sort
local util_TraceLine = util.TraceLine
local coroutine_yield = coroutine.yield
local ents_GetAll = ents.GetAll
local IsValidOcclusionCheck = GOptCore.Api.IsValidOcclusionCheck

---------------------------------------
-- Variables
---------------------------------------
local view_distance = 4000000
local always_view_distance = 250000
local zero_angle = Angle()
local current_pass = 0
local local_player = nil
local cvar_occlusion_visible_strict = GetConVar('gopt_occlusion_visible_strict')

---------------------------------------
-- Functions
---------------------------------------
local function pass_yield()
	current_pass = current_pass + 1
	-- if current_pass > 1 / slib.deltaTime then
	if current_pass > 1 / FrameTime() then
		current_pass = 0
		coroutine_yield()
	end
end

local function is_hit(target, pos1, pos2)
	local tr = util_TraceLine({
		start = pos1,
		endpos = pos2,
		filter = function(ent)
			return IsValid(ent) and ent ~= local_player
		end
	})

	if tr.Entity ~= target then return false end

	return true
end

local function trace_entity(ent)
	local ply = local_player
	local eye_pos = ply:EyePos()
	local ent_pos = ent:GetPos()
	local ent_ang = ent:GetAngles()
	local obb_center = ent:OBBCenter()
	local obb_max = LerpVector(.15, ent:OBBMaxs(), obb_center)
	local obb_min = LerpVector(.15, ent:OBBMins(), obb_center)

	local obb_vec_x_size = Vector(obb_max.x * 2, 0, 0)
	local obb_vec_z_size =  Vector(0, 0, obb_max.z * 2)
	local obb_vec_x_z_size = Vector(obb_max.x * 2, 0, obb_max.z * 2)

	local vec_0 = LocalToWorld(obb_center, zero_angle, ent_pos, ent_ang)
	local vec_1 = LocalToWorld(obb_max, zero_angle, ent_pos, ent_ang)
	local vec_2 = LocalToWorld(obb_min, zero_angle, ent_pos, ent_ang)
	local vec_3 =  LocalToWorld(obb_max - obb_vec_x_size, zero_angle, ent_pos, ent_ang)
	local vec_4 =  LocalToWorld(obb_max - obb_vec_x_z_size, zero_angle, ent_pos, ent_ang)
	local vec_5 =  LocalToWorld(obb_max - obb_vec_z_size, zero_angle, ent_pos, ent_ang)
	local vec_6 =  LocalToWorld(obb_min + obb_vec_x_size, zero_angle, ent_pos, ent_ang)
	local vec_7 =  LocalToWorld(obb_min + obb_vec_x_z_size, zero_angle, ent_pos, ent_ang)
	local vec_8 =  LocalToWorld(obb_min + obb_vec_z_size, zero_angle, ent_pos, ent_ang)

	pass_yield()

	local points = { vec_0, vec_1, vec_2, vec_3, vec_4, vec_5, vec_6, vec_7, vec_8 }

	table_sort(points, function(first_vector, second_vector)
		return first_vector:DistToSqr(eye_pos) < second_vector:DistToSqr(eye_pos)
	end)

	pass_yield()

	for i = 1, 9 do
		if is_hit(ent, eye_pos, points[i]) then
			return true
		end
	end

	return false
end

local function handler()
	local_player = local_player or LocalPlayer()
	if not local_player or not cvar_occlusion_visible_strict:GetBool() then return end

	local ply = local_player
	local player_position = ply:GetPos()
	local entities = ents_GetAll()
	local near_entities = {}
	local near_entities_count = 0
	local count = #entities

	for i = 1, count do
		local ent = entities[i]
		if not IsValidOcclusionCheck(ent) then continue end

		local ent_pos = ent:GetPos()
		local distance = player_position:DistToSqr(ent:GetPos())

		-- if ent.EntityCullingNoDrawDefault == nil then
		-- 	ent.EntityCullingNoDrawDefault = ent:GetNoDraw()
		-- end

		-- if ent.EntityCullingNoDrawDefault then continue end

		if distance > view_distance then
			ent:SetNoDraw(true)
		elseif distance <= always_view_distance then
			ent:SetNoDraw(false)
		elseif not ply:slibIsViewVector(ent_pos) then
			ent:SetNoDraw(true)
		else
			near_entities_count = near_entities_count + 1
			near_entities[near_entities_count] = ent
		end

		-- pass_yield()
	end

	pass_yield()

	table_sort(near_entities, function(first_ent, second_ent)
		if IsValid(first_ent) and IsValid(second_ent) then
			return first_ent:GetPos():DistToSqr(player_position)
				< second_ent:GetPos():DistToSqr(player_position)
		end
	end)

	pass_yield()

	for i = 1, near_entities_count do
		local ent = near_entities[i]
		if not IsValid(ent) then continue end
		ent:SetNoDraw(not trace_entity(ent))
		-- pass_yield()
	end
end
async.AddDedic('GOpt.EntityCulling.Renderer', handler)