local IsLag = GOptCore.Api.IsLag
local IsLagDifference = GOptCore.Api.IsLagDifference
local originalEffect = util.Effect
local IsFocus = GOptCore.Api.IsGameFocus

if GetConVar('gopt_update_optimization'):GetBool() then
	function util.Effect(...)
		if not IsFocus() or IsLag() or IsLagDifference() then return end
		originalEffect(...)
	end
end