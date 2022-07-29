local LocalPlayer = LocalPlayer
local IsValid = IsValid
local GetConVar = GetConVar
local FrameTime = FrameTime
local table_sort = table.sort
local ents_GetAll = ents.GetAll
local math_floor = math.floor
local IsLag = GOptCore.Api.IsLag
local LagDifference = GOptCore.Api.LagDifference
--
local current_pass = 0
local always_draw_distance = 1000000
local draw_distance = 4000000
local is_occlusion_trace = false
local cvar_occlusion_ignore_npc = GetConVar('gopt_occlusion_ignore_npc')
local cvar_occlusion_ignore_players = GetConVar('gopt_occlusion_ignore_players')
local cvar_occlusion_ignore_vehicles = GetConVar('gopt_occlusion_ignore_vehicles')
-- local class_prop_physics = 'prop_physics'

local function SetOcclusionTrace(value)
	value = value or GetConVar('gopt_occlusion_trace'):GetBool()
	is_occlusion_trace = tobool(value)
end

local function SetDrawDistance(value)
	value = value or GetConVar('gopt_occlusion_visible_max'):GetInt()
	draw_distance = tonumber(value)
	draw_distance = draw_distance ^ 2
end

local function SetAlwaysDrawDistance(value)
	value = value or GetConVar('gopt_occlusion_visible_min'):GetInt()
	always_draw_distance = tonumber(value)
	always_draw_distance = always_draw_distance ^ 2
end

local function IsValidEntity(ent)
		if IsValid(ent) and ent ~= LocalPlayer() and not ent.isBgnActor and not ent:slibIsDoor() then
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

			return true
		end

		return false
end

local function AsyncProcess(yield, wait)
	SetDrawDistance()
	SetAlwaysDrawDistance()
	SetOcclusionTrace()

	local cvar_occlusion_visible = GetConVar('gopt_occlusion_visible')
	local cvar_occlusion_visible_strict = GetConVar('gopt_occlusion_visible_strict')

	while true do
		if not cvar_occlusion_visible:GetBool() or cvar_occlusion_visible_strict:GetBool() then
			wait(1)
		else
			local ply = LocalPlayer()
			local position = ply:GetPos()
			local entities = ents_GetAll()
			local playerWeapons = ply:GetWeapons()

			yield()

			table_sort(entities, function(a, b)
				if IsValid(a) and IsValid(b) then
					return a:GetPos():DistToSqr(position) > b:GetPos():DistToSqr(position)
				end
			end)

			yield()

			for i = 1, #entities do
				local ent = entities[i]

				if IsValidEntity(ent) and not table.HasValueBySeq(playerWeapons, ent) then
					local entity_position = ent:GetPos()
					local distance = entity_position:DistToSqr(position)
					local is_draw = draw_distance == 0 or distance <= draw_distance
					local is_always_draw = distance <= always_draw_distance

					if not is_always_draw then
						if is_occlusion_trace then
							is_always_draw = ply:slibIsTraceEntity(ent, distance)
						else
							is_always_draw = ply:slibIsViewVector(entity_position)
						end
					end

					if is_draw and is_always_draw then
						ent:SetNoDraw(false)
						ent.GOpt_OcclusionNoDraw = false
					else
						ent:SetNoDraw(true)
						ent.GOpt_OcclusionNoDraw = true
					end

					local max_pass

					if IsLag() or LagDifference() >= 50 then
						max_pass = math_floor(1 / FrameTime())
					else
						max_pass = 60
					end

					current_pass = current_pass + 1
					if current_pass >= max_pass then
						current_pass = 0
						yield()
					end
				end
			end
		end

		yield()
	end
end
async.Add('GOpt.OcclusionVisible', AsyncProcess, true)

cvars.AddChangeCallback('gopt_occlusion_trace', function(_, _, value)
	SetOcclusionTrace(value)
end, 'gopt_occlusion_trace')

cvars.AddChangeCallback('gopt_occlusion_visible_max', function(_, _, value)
	SetDrawDistance(value)
end, 'gopt_occlusion_visible_max_update')

cvars.AddChangeCallback('gopt_occlusion_visible_min', function(_, _, value)
	SetAlwaysDrawDistance(value)
end, 'gopt_occlusion_visible_min_update')

cvars.AddChangeCallback('gopt_occlusion_visible', function(_, _, value)
	if tobool(value) == false then
		async.Remove('GOpt.OcclusionVisible')

		local entities = ents_GetAll()
		for i = 1, #entities do
			local ent = entities[i]
			if IsValid(ent) and ent.GOpt_OcclusionNoDraw then
				ent:SetNoDraw(false)
				ent.GOpt_OcclusionNoDraw = false
			end
		end
	else
		async.Add('GOpt.OcclusionVisible', AsyncProcess, true)
	end
end, 'gopt_occlusion_visible_async_update')