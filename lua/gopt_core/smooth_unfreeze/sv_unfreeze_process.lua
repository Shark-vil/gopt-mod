local GetSmoothUnfreezeEntities = GOptCore.Api.GetSmoothUnfreezeEntities
local RemoveSmoothUnfreezeById = GOptCore.Api.RemoveSmoothUnfreezeById
local IsLag = GOptCore.Api.IsLag
local gamemode_Call = gamemode.Call
local IsValid = IsValid
local CurTime = CurTime
--

async.Add('GOpt.SmoothUnfreeze', function(yield, wait)
	while true do
		local unfreeze_entitiees = GetSmoothUnfreezeEntities()

		for i = #unfreeze_entitiees, 1, -1 do
			local value = unfreeze_entitiees[i]
			if not value then continue end

			local ent = value.ent
			local ply = value.ply

			if IsValid(ent) then
				local phy = ent:GetPhysicsObject()
				if IsValid(phy) then
					ent.GOpt_MotionIgnoreDelay = CurTime() + 2
					ent.GOpt_MotionLocked = false

					if not gamemode_Call('CanPlayerUnfreeze', ply, ent, phy) then
						continue
					end

					phy:EnableMotion(true)
					phy:Wake()

					gamemode_Call('PlayerUnfrozeObject', ply, ent, phy)

					RemoveSmoothUnfreezeById(i)

					if IsLag() then
						wait(.1)
					else
						yield()
					end
				end
			end
		end

		yield()
	end
end)