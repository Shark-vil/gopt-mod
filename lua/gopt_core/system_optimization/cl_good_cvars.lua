local changeConvarList = {
	['gmod_mcore_test'] = '1',
	['mat_queue_mode'] = '-1',
	['cl_threaded_bone_setup'] = '1',
	['cl_threaded_client_leaf_system'] = '1',
	['r_threaded_client_shadow_manager'] = '1',
	['r_threaded_particles'] = '1',
	['r_threaded_renderables'] = '1',
	['r_queued_ropes'] = '1',
	['studio_queue_mode'] = '1',
	['mat_specular'] = '0',
	['cl_forcepreload'] = '1',
	['r_fastzreject'] = '1',
	['mp_decals'] = '50',
	['r_decals'] = '1024',
	['r_WaterDrawReflection'] = '0',
}

local function CvarsOptimization()
	if not file.Exists('gopt_data/cvars.json', 'DATA') then
		if not file.Exists('gopt_data', 'DATA') then file.CreateDir('gopt_data') end
		local save_cvars = {}
		for cvar_name, _ in pairs(changeConvarList) do
			if ConVarExists(cvar_name) then
				save_cvars[cvar_name] = GetConVar(cvar_name):GetString()
			end
		end
		file.Write('gopt_data/cvars.json', util.TableToJSON(save_cvars, true))
	end

	for cvar_name, cvar_value in pairs(changeConvarList) do
		RunConsoleCommand(cvar_name, cvar_value)
	end
end

local function CvarsOptimizationRollback()
	if not file.Exists('gopt_data/cvars.json', 'DATA') then return end

	local fileReadData = file.Read('gopt_data/cvars.json', 'DATA')
	local savedCvars = util.JSONToTable(fileReadData)

	for cvar_name, cvar_value in pairs(savedCvars) do
		RunConsoleCommand(cvar_name, cvar_value)
	end

	file.Delete('gopt_data/cvars.json')
end

hook.Add('Initialize', 'GOpt.GoodCvarsSetting', function()
	if GetConVar('gopt_cvars_optimization'):GetBool() then
		CvarsOptimization()
	else
		CvarsOptimizationRollback()
	end
end)

cvars.AddChangeCallback('gopt_cvars_optimization', function(_, _, newValue)
	if tobool(newValue) then
		CvarsOptimization()
	else
		CvarsOptimizationRollback()
	end
end, 'gopt_cvars_optimization')