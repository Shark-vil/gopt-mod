local onfreeze = true
local lag_poll = {}
local locked_ents = {}

local function IsLockedEntity(ent)
	for i = #locked_ents, 1, -1 do
		if locked_ents[i] == ent then return true end
	end
	return false
end

local function LockEntity(ent)
	if IsLockedEntity(ent) then return end
	table.insert(locked_ents, ent)
end

local function UnlockEntity(ent)
	for i = #locked_ents, 1, -1 do
		if locked_ents[i] == ent then
			table.remove(locked_ents, i)
			break
		end
	end
end

hook.Add('OnPhysgunPickup', 'GOpt.MotionOptimization.OnPhysgunPickup', function(_, ent)
	local phy = ent:GetPhysicsObject()
	if not IsValid(phy) then return end

	for i = #lag_poll, 1, -1 do
		local value = lag_poll[i]
		if value.phy and value.phy == phy then
			table.remove(lag_poll, i)
			break
		end
	end

	LockEntity(ent)
end)

hook.Add('PhysgunDrop', 'GOpt.MotionOptimization.PhysgunDrop', function(_, ent)
	UnlockEntity(ent)
end)

hook.Add('OnPhysgunFreeze', 'GOpt.MotionOptimization.OnPhysgunFreeze', function(_, phy, ent)
	for i = #lag_poll, 1, -1 do
		local value = lag_poll[i]
		if value.phy and value.phy == phy then
			table.remove(lag_poll, i)
			break
		end
	end

	UnlockEntity(ent)
end)

local function AsyncProcess()
	while true do
		if onfreeze then
			local allow_entities = ents.GetAll()
			local valid_entities = {}

			for i = 1, #allow_entities do
				local ent = allow_entities[i]
				if ent and IsValid(ent) then
					local phy = ent:GetPhysicsObject()
					if IsValid(phy) and phy:IsMotionEnabled() and not IsLockedEntity(ent) then
						table.insert(valid_entities, phy)
					end
				end
			end

			for i = 1, #valid_entities do
				local phy = valid_entities[i]

				lag_poll[#lag_poll + 1] = {
					phy = phy,
					vel = phy:GetVelocity(),
				}

				phy:EnableMotion(false)

				coroutine.yield()
			end
		else
			for i = 1, #lag_poll do
				local value = lag_poll[i]
				local phy = value.phy
				local vel = value.vel

				if IsValid(phy) and not phy:IsMotionEnabled() and not IsLockedEntity(phy:GetEntity()) then
					phy:EnableMotion(true)
					phy:SetVelocity(vel)

					coroutine.yield()
				end
			end

			lag_poll = {}
		end

		onfreeze = not onfreeze

		coroutine.yield()
	end
end

local process
hook.Add('Think', 'GOpt.MotionOptimization', function()
	if not process or not coroutine.resume(process) then
		process = coroutine.create(AsyncProcess)
		coroutine.resume(process)
	end
end)