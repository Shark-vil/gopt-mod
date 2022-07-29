local dynamic_particles = {}
local dynamic_particles_max = 5

timer.Create('GOpt.MaxPrticlesDynamic.Check', .5, 0, function()
	for i = #dynamic_particles, 1, -1 do
		local particle = dynamic_particles[i]
		if not particle or not IsValid(particle) then
			table.remove(dynamic_particles, i)
		end
	end
end)

hook.Add('OnEntityCreated', 'GOpt.MaxParticleDynamic', function(ent)
	if ent:GetClass() ~= 'info_particle_system' then return end
	if #dynamic_particles == dynamic_particles_max then
		ent:Remove()
		return
	end

	table.insert(dynamic_particles, ent)
end)