local IsValid = IsValid
local GetConVar = GetConVar
local FrameTime = FrameTime
local CurTime = CurTime
local ents_GetAll = ents.GetAll
local math_floor = math.floor
local player_GetHumans = player.GetHumans
local IsLag = GOptCore.Api.IsLag
local LagDifference = GOptCore.Api.LagDifference
--
local current_pass = 0
local draw_distance = 1000000

timer.Create('GOpt.MotionDebug', 1, 0, function()
	local entities = ents_GetAll()
	for i = 1, #entities do
		local ent = entities[i]
		if not ent or not IsValid(ent) or ent:GetClass() ~= 'prop_physics' then continue end

		local phy = ent:GetPhysicsObject()
		if not IsValid(phy) then continue end

		ent.GOpt_OriginalColor = ent.GOpt_OriginalColor or ent:GetColor()

		if phy:IsMotionEnabled() then
			ent:SetColor(ent.GOpt_OriginalColor)
		else
			ent:SetColor(Color(231, 103, 103))
		end
	end
end)

local function SetDrawDistance(value)
	value = value or GetConVar('gopt_npc_logic_min_distacne'):GetInt()
	draw_distance = tonumber(value)
	draw_distance = draw_distance ^ 2
end

local function AsyncProcess(yield, wait)
	SetDrawDistance()

	while true do
		local cvar_npc_logic_optimization = GetConVar('gopt_npc_logic_optimization'):GetBool()
		if not cvar_npc_logic_optimization then
			wait(1)
		else
			local entities = ents_GetAll()

			yield()

			for i = 1, #entities do
				local npc = entities[i]
				local is_visible = false
				local is_view_vector = false

				if IsValid(npc) and not npc.isBgnActor and npc:IsNPC() then
					local players = player_GetHumans()
					for k = 1, #players do
						local ply = players[k]
						local npc_position = npc:GetPos()
						local distance = npc_position:DistToSqr(ply:GetPos())

						if distance <= draw_distance then
							is_visible = true
							break
						end

						if ply:slibIsViewVector(npc_position) then
							is_view_vector = true
							break
						end
					end

					npc.GOpt_NpcNoThinkState = npc.GOpt_NpcNoThinkState or false
					npc.GOpt_NpcNoThinkDelay = npc.GOpt_NpcNoThinkDelay or 0

					if npc.GOpt_NpcNoThinkDelay < CurTime() then
						if npc.GOpt_NpcNoThinkState then
							npc:RemoveEFlags(EFL_NO_THINK_FUNCTION)
							if not is_visible and is_view_vector then
								npc.GOpt_NpcNoThinkDelay = CurTime() + .1
							else
								npc.GOpt_NpcNoThinkDelay = CurTime() + 1
							end
						else
							if not is_visible and is_view_vector then
								npc:AddEFlags(EFL_NO_THINK_FUNCTION)
								npc.GOpt_NpcNoThinkDelay = CurTime() + .15
							elseif not is_visible and not is_view_vector then
								npc:AddEFlags(EFL_NO_THINK_FUNCTION)
								npc.GOpt_NpcNoThinkDelay = CurTime() + 3
							end
						end

						npc.GOpt_NpcNoThinkState = not npc.GOpt_NpcNoThinkState
						-- yield()
					end
				end

				::next_entity::
			end

			-- local max_pass

			-- if IsLag() or LagDifference() >= 50 then
			-- 	max_pass = math_floor(1 / FrameTime())
			-- else
			-- 	max_pass = 60
			-- end

			-- current_pass = current_pass + 1
			-- if current_pass >= max_pass then
			-- 	current_pass = 0
			-- 	yield()
			-- end
		end

		yield()
	end
end
async.Add('GOpt.OcclusionVisible', AsyncProcess)

cvars.AddChangeCallback('gopt_npc_logic_min_distacne', function(_, _, value)
	SetDrawDistance(value)
end, 'gopt_npc_logic_min_distacne_update')

cvars.AddChangeCallback('gopt_npc_logic_optimization', function(_, _, value)
	if tobool(value) == false then
		async.Remove('GOpt.OcclusionVisible')

		local entities = ents_GetAll()
		for i = 1, #entities do
			local npc = entities[i]
			if IsValid(npc) and npc.GOpt_NpcNoThinkState then
				npc:RemoveEFlags(EFL_NO_THINK_FUNCTION)
				npc.GOpt_NpcNoThinkState = false
			end
		end
	else
		async.Add('GOpt.OcclusionVisible', AsyncProcess)
	end
end, 'gopt_npc_logic_optimization_async_update')