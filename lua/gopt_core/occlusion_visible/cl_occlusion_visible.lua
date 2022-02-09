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
local class_prop_physics = 'prop_physics'

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
	if IsValid(ent) and ent ~= LocalPlayer() and not ent.isBgnActor and (
		ent:GetClass() == class_prop_physics
		or ent:IsVehicle()
		or ((ent:IsPlayer() or ent:IsNPC()) and slib.IsAlive(ent))
		or ent:IsNextBot()
	) then
		return true
	end
	return false
end

local function AsyncProcess(yield, wait)
	SetDrawDistance()
	SetAlwaysDrawDistance()

	while true do
		local cvar_occlusion_visible = GetConVar('gopt_occlusion_visible'):GetBool()
		if not cvar_occlusion_visible then
			wait(1)
		else
			local ply = LocalPlayer()
			local position = ply:GetPos()
			local entities = ents_GetAll()

			yield()

			table_sort(entities, function(a, b)
				if IsValid(a) and IsValid(b) then
					return a:GetPos():DistToSqr(position) > b:GetPos():DistToSqr(position)
				end
			end)

			yield()

			for i = 1, #entities do
				local ent = entities[i]

				if IsValidEntity(ent) then
					local entity_position = ent:GetPos()
					local distance = entity_position:DistToSqr(position)

					if distance <= draw_distance and (
						distance <= always_draw_distance or ply:slibIsViewVector(entity_position)
					) then
						if ent:GetNoDraw() then
							ent:SetNoDraw(false)
							ent.GOpt_OcclusionNoDraw = false
						end
					else
						if not ent:GetNoDraw() then
							ent:SetNoDraw(true)
							ent.GOpt_OcclusionNoDraw = true
						end
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
async.Add('GOpt.OcclusionVisible', AsyncProcess)

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
		async.Add('GOpt.OcclusionVisible', AsyncProcess)
	end
end, 'gopt_occlusion_visible_async_update')