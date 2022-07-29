local meta = FindMetaTable('Entity')
local IsLag = GOptCore.Api.IsLag
local IsLagDifference = GOptCore.Api.IsLagDifference
local originalEmitSound = EmitSound
local originalMetaEmitSound = meta.EmitSound
local IsFocus = GOptCore.Api.IsGameFocus

if GetConVar('gopt_update_optimization'):GetBool() then
	function EmitSound(...)
		if not IsFocus() or IsLag() or IsLagDifference() then return end
		originalEmitSound(...)
	end

	function meta:EmitSound(...)
		if not IsFocus() or IsLag() or IsLagDifference() then return end
		originalMetaEmitSound(self, ...)
	end
end