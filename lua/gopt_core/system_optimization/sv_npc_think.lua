local IsValid = IsValid
local GetConVar = GetConVar
local CurTime = CurTime
local ents_GetAll = ents.GetAll
local player_GetHumans = player.GetHumans
local IsLag = GOptCore.Api.IsLag
local IsLagDifference = GOptCore.Api.IsLagDifference
local draw_distance = 1000000
local EFL_NO_THINK_FUNCTION = EFL_NO_THINK_FUNCTION

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
				if IsValid(npc) and not npc.isBgnActor and npc:IsNPC() then
					local npc_position = npc:GetPos()
					local players = player_GetHumans()
					local is_visible = false
					local is_view_vector = false

					for k = 1, #players do
						local ply = players[k]
						local distance = npc_position:DistToSqr(ply:GetPos())

						if distance <= draw_distance then
							is_visible = true
							break
						end
					end

					for k = 1, #players do
						local ply = players[k]

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
							local addition = 0
							if IsLag() or IsLagDifference() then
								addition = .5
							end

							if not is_visible and is_view_vector then
								npc:AddEFlags(EFL_NO_THINK_FUNCTION)
								npc.GOpt_NpcNoThinkDelay = CurTime() + .15 + addition
							elseif not is_visible and not is_view_vector then
								npc:AddEFlags(EFL_NO_THINK_FUNCTION)
								npc.GOpt_NpcNoThinkDelay = CurTime() + 3 + addition
							end
						end

						npc.GOpt_NpcNoThinkState = not npc.GOpt_NpcNoThinkState
						yield()
					end
				end

				::next_entity::
			end
		end

		yield()
	end
end
async.Add('GOpt.OcclusionVisible', AsyncProcess, true)

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
				npc.GOpt_NpcNoThinkDelay = 0
			end
		end
	else
		async.Add('GOpt.OcclusionVisible', AsyncProcess)
	end
end, 'gopt_npc_logic_optimization_async_update')