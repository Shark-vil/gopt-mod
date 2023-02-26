local string_find = string.find
--
local DefaultAccess = { isAdmin = true }
local skipped_classes = {
	'env_*',
	'logic_*',
	'hint',
	'info_*',
	'worldspawn',
	'path_track',
	'func_*',
	'lua_run',
	'keyframe_*',
	'point_spotlight',
	'light_environment',
	'water_lod_control',
	'beam',
	'ai_*',
	'soundent',
	'player_manager',
	'scene_manager',
	'shadow_control',
	'sky_camera',
	'predicted_viewmodel',
	'phys_constraint',
	'phys_bone_follower',
	'phys_ballsocket',
	'phys_hinge',
}

function GOptCore.Api.IsSkippedClass(entity_class)
	for k = 1, #skipped_classes do
		if string_find(entity_class, skipped_classes[k]) then
			return true
		end
	end
	return false
end

if CLIENT then
	CreateConVar('gopt_occlusion_visible_strict', '0',
		{ FCVAR_ARCHIVE }, '', 0, 1)

	CreateConVar('gopt_occlusion_visible', '1',
		{ FCVAR_ARCHIVE }, '', 0, 1)

	CreateConVar('gopt_occlusion_ignore_npc', '0',
		{ FCVAR_ARCHIVE }, '', 0, 1)

	CreateConVar('gopt_occlusion_ignore_players', '0',
		{ FCVAR_ARCHIVE }, '', 0, 1)

	CreateConVar('gopt_occlusion_ignore_vehicles', '0',
		{ FCVAR_ARCHIVE }, '', 0, 1)

	CreateConVar('gopt_occlusion_trace', '0',
		{ FCVAR_ARCHIVE }, '', 0, 1)

	CreateConVar('gopt_occlusion_visible_min', '1000',
		{ FCVAR_ARCHIVE }, '', 0, 2000)

	CreateConVar('gopt_occlusion_visible_max', '2000',
		{ FCVAR_ARCHIVE }, '', 0, 5000)

	CreateConVar('gopt_cvars_optimization', '1',
		{ FCVAR_ARCHIVE }, '', 0, 1)
end

scvar.Register('gopt_occlusion_visible_server', '1',
	{ FCVAR_ARCHIVE }, '', 0, 30)
	.Access(DefaultAccess)

scvar.Register('gopt_occlusion_trace_server', '1',
	{ FCVAR_ARCHIVE }, '', 0, 30)
	.Access(DefaultAccess)

scvar.Register('gopt_log', '1',
	{ FCVAR_ARCHIVE }, '', 0, 1)

scvar.Register('gopt_focus_optimization', '1',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_update_optimization', '1',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_update_optimization_second_frame', '1',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_entity_tickrate_weapon', '0',
	{ FCVAR_ARCHIVE }, '', 0, 30)
	.Access(DefaultAccess)

scvar.Register('gopt_entity_tickrate_npc', '0',
	{ FCVAR_ARCHIVE }, '', 0, 30)
	.Access(DefaultAccess)

scvar.Register('gopt_entity_tickrate_nextbot', '0',
	{ FCVAR_ARCHIVE }, '', 0, 30)
	.Access(DefaultAccess)

scvar.Register('gopt_entity_tickrate_vehicle', '0',
	{ FCVAR_ARCHIVE }, '', 0, 30)
	.Access(DefaultAccess)

scvar.Register('gopt_entity_tickrate_other', '0',
	{ FCVAR_ARCHIVE }, '', 0, 30)
	.Access(DefaultAccess)

scvar.Register('gopt_npc_logic_optimization', '1',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_npc_logic_min_distacne', '1000',
	{ FCVAR_ARCHIVE }, '', 0, 5000)
	.Access(DefaultAccess)

scvar.Register('gopt_smooth_unfreeze', '1',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_anti_crash_system', '1',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_anti_crash_system_hard_mode', '0',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_dynamic_motion', '1',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_dynamic_motion_no_childs', '1',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_dynamic_motion_max_unfreeze_per_second', '10',
	{ FCVAR_ARCHIVE }, '', 0, 30)
	.Access(DefaultAccess)

scvar.Register('gopt_dynamic_motion_unfreeze_delay', '0.5',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_collision_lags', '1',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_collision_lags_flexable', '0',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_collision_lags_constraints', '1',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)

scvar.Register('gopt_collision_lags_constraints_flexable', '1',
	{ FCVAR_ARCHIVE }, '', 0, 1)
	.Access(DefaultAccess)