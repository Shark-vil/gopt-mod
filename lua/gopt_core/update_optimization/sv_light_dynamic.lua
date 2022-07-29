local dynamic_lights = {}
local dynamic_lights_max = 5

timer.Create('GOpt.MaxLightDynamic.Check', .5, 0, function()
	for i = #dynamic_lights, 1, -1 do
		local light = dynamic_lights[i]
		if not light or not IsValid(light) then
			table.remove(dynamic_lights, i)
		end
	end
end)

hook.Add('OnEntityCreated', 'GOpt.MaxLightDynamic', function(ent)
	if ent:GetClass() ~= 'light_dynamic' then return end
	if #dynamic_lights == dynamic_lights_max then
		ent:Remove()
		return
	end

	table.insert(dynamic_lights, ent)
end)