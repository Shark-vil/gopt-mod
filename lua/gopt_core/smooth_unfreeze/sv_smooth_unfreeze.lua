local table_remove = table.remove
--
local unfreeze_entitiees = {}

function GOptCore.Api.GetSmoothUnfreezeEntities()
	return unfreeze_entitiees
end

function GOptCore.Api.IsSmoothUnfreeze(ent)
	for i = #unfreeze_entitiees, 1, -1 do
		local value = unfreeze_entitiees[i]
		if value and value.ent == ent then return true end
	end
	return false
end

function GOptCore.Api.AddSmoothUnfreeze(ply, ent)
	if GOptCore.Api.IsSmoothUnfreeze(ent) then return end

	GOptCore.Api.AddMotionDelay(ent)
	GOptCore.Api.RemoveWaitMotion(ent)

	unfreeze_entitiees[#unfreeze_entitiees + 1] = {
		ply = ply,
		ent = ent
	}
end

function GOptCore.Api.RemoveSmoothUnfreeze(ent)
	for i = #unfreeze_entitiees, 1, -1 do
		local value = unfreeze_entitiees[i]
		if value and value.ent == ent then
			table_remove(unfreeze_entitiees, i)
			break
		end
	end
end

function GOptCore.Api.RemoveSmoothUnfreezeById(index)
	local count = #unfreeze_entitiees
	if count == 0 or count < index then return end
	table_remove(unfreeze_entitiees, index)
end

