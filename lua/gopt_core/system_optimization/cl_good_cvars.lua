hook.Add('Initialize', 'GOpt.GoodCvarsSetting', function()
	RunConsoleCommand('gmod_mcore_test', '1')
	RunConsoleCommand('mat_queue_mode', '-1')
	RunConsoleCommand('cl_threaded_bone_setup', '1')
	RunConsoleCommand('cl_threaded_client_leaf_system', '1')
	RunConsoleCommand('r_threaded_client_shadow_manager', '1')
	RunConsoleCommand('r_threaded_particles', '1')
	RunConsoleCommand('r_threaded_renderables', '1')
	RunConsoleCommand('r_queued_ropes', '1')
	RunConsoleCommand('studio_queue_mode', '1')
	-- RunConsoleCommand('mat_specular', '0')
end)