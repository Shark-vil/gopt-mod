local IsValid = IsValid
local ents_GetAll = ents.GetAll
local IsLag = GOptCore.Api.IsLag
local RemoveWaitMotion = GOptCore.Api.RemoveWaitMotion
local RemoveSmoothUnfreeze = GOptCore.Api.RemoveSmoothUnfreeze
local GetConstraintEntities = constraint.GetAllConstrainedEntities
local table_sort = table.sort
local table_ValuesToArray = table.ValuesToArray
local table_WhereFindBySeq = table.WhereFindBySeq
local IsSkippedClass = GOptCore.Api.IsSkippedClass
local WriteLog = GOptCore.Api.WriteLog
--
local lag_count = 0

local function DisableMotion(ent)
	if not IsValid(ent) or IsSkippedClass(ent:GetClass()) then return end

	local phy = ent:GetPhysicsObject()
	if not IsValid(phy) then return end
	phy:EnableMotion(false)

	if SERVER then
		WriteLog('[Build Lags] ', ent, ', Position  - ', ent:GetPos(), ', Owner - ', ent.Owner)
	end

	RemoveWaitMotion(ent)
	RemoveSmoothUnfreeze(ent)
end

local function Notify(...)
	local text_args = { ... }
	local text = ''

	for i = 1, #text_args do
		text = text .. text_args[i]
	end

	MsgN('[GOpt Lags] ' .. text)
	if SERVER then
		WriteLog('[GOpt Lags] ' .. text)
	end

	local players = player.GetAll()
	for i = 1, #players do
		local ply = players[i]
		if IsValid(ply) and ply:IsAdmin() then
			snet.Invoke('GOpt.LaggingBuildsNotify', ply, text)
		end
	end
end

local function RunningLagFixerAsync(yield, wait)
	local buildings = {}
	local other_entities = {}

	do
		local entities = ents_GetAll()
		local used_ents = {}

		for i = 1, #entities do
			local ent = entities[i]
			if IsValid(ent) and ent:EntIndex() ~= 0 and not used_ents[ent] then
				local childs = table_ValuesToArray(GetConstraintEntities(ent))
				local count = #childs

				if count == 1 then
					local class = ent:GetClass()

					if not IsSkippedClass(class) then
						local _, value = table_WhereFindBySeq(other_entities, function(_, v)
							return v.class == class
						end)

						if value then
							value.entities[#value.entities + 1] = ent
						else
							other_entities[#other_entities + 1] = {
								class = class,
								entities = { ent }
							}
						end
					end
				else
					local index = #buildings + 1
					buildings[index] = {
						entities = childs,
						count = count
					}

					for k = 1, count do
						local other_ent = childs[k]
						if IsValid(other_ent) then
							used_ents[other_ent] = true
							RemoveSmoothUnfreeze(other_ent)
						end
					end
				end

				-- yield()
			end
		end
	end

	yield()

	do
		-- Notify('Sorting entities')

		table_sort(other_entities, function(a, b)
			return #a.entities > #b.entities
		end)

		yield()

		for i = 1, #other_entities do
			local value = other_entities[i]
			local entities = value.entities
			Notify('Stop entity lags: ', value.class)

			for k = 1, #entities do
				local ent = entities[k]
				DisableMotion(ent)

				yield()

				if not IsLag() then
					lag_count = 0
					return
				end
			end
		end
	end

	yield()

	do
		-- Notify('Sorting buildings')

		table_sort(buildings, function(a, b)
			return a.count > b.count
		end)

		yield()

		for i = 1, #buildings do
			local value = buildings[i]
			local count = value.count
			local entities = value.entities
			Notify('Stop building #' .. i .. ' lags: ', count, ' entities')

			for k = 1, #entities do
				local ent = entities[k]
				DisableMotion(ent)

				yield()

				if not IsLag() then
					lag_count = 0
					return
				end
			end
		end
	end

	wait(3)

	do
		Notify('Unable to fix lags. Hard freezing is applied.')

		local entities = ents_GetAll()
		for i = 1, #entities do
			local ent = entities[i]
			DisableMotion(ent)

			yield()

			if not IsLag() then
				lag_count = 0
				return
			end
		end
	end

	if GetConVar('gopt_anti_crash_system_hard_mode'):GetBool() then
		wait(3)

		if not IsLag() then
			lag_count = 0
			return
		end

		RunConsoleCommand('gmod_admin_cleanup')
		Notify('The hard lag stop mode is enabled, the map has been completely cleared!')
	end
end

hook.Add('PlayerSay', 'GOpt.LagFixerChatStart', function(ply, text)
	if not ply:IsAdmin() then return end
	if string.Trim(text:lower()) == '/lags' then
		Notify('Forced lag fixed')

		local entities = ents_GetAll()

		for i = 1, #entities do
			local ent = entities[i]
			DisableMotion(ent)
		end

		return ''
	end
end)

async.Add('GOpt.LaggingBuildsDetector', function(yield, wait)
	while true do
		if not GetConVar('gopt_anti_crash_system'):GetBool() then
			wait(1)
		else
			if IsLag() then
				wait(1)

				if lag_count ~= 5 then
					lag_count = lag_count + 1
					Notify('Found lags: ', lag_count, ' / 5')
				else
					RunningLagFixerAsync(yield, wait)

					if lag_count == 0 then
						Notify('The lags have stopped')
					end
				end
			elseif lag_count - 1 >= 0 then
				lag_count = lag_count - 1
				Notify('Reduction lags: ', lag_count, ' / 5')
			end
		end

		yield()
	end
end)