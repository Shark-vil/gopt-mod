local game_IsDedicated = game.IsDedicated
local game_SinglePlayer = game.SinglePlayer
local player_GetHumans = player.GetHumans
local system_HasFocus = system.HasFocus
local focusOptimizationCvar = GetConVar('gopt_focus_optimization')

function GOptCore.Api.IsGameFocus()
	if not focusOptimizationCvar:GetBool() then return true end
	if SERVER then
		if game_IsDedicated() then return true end
		return (game_SinglePlayer() or #player_GetHumans() > 1) or system_HasFocus()
	else
		return system_HasFocus()
	end
end