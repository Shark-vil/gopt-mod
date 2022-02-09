originalEffect = originalEffect or util.Effect
originalEmitSound = originalEmitSound or EmitSound

local IsLag = GOptCore.Api.IsLag

function util.Effect(...)
	if IsLag() then return end
	originalEffect(...)
end

function EmitSound(...)
	if IsLag() then return end
	originalEmitSound(...)
end