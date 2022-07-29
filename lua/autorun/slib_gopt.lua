hook.Add('PostGamemodeLoaded', 'GOpt.SLibraryChecker', function()
	if slib ~= nil then return end

	if SERVER then
		AddCSLuaFile('gopt_core/errors/sh_slib_error.lua')
	end

	include('gopt_core/errors/sh_slib_error.lua')
end)