GOptCore = GOptCore or {}
GOptCore.Api = GOptCore.Api or {}
GOptCore.SQL = GOptCore.SQL or {}
GOptCore.Storage = GOptCore.Storage or {}

local root_directory = 'gopt_core'
local script = slib.CreateIncluder(root_directory, '[GOPT] Script load - {file}')

script:using('sh_gopt.lua')
script:using('sh_sql.lua')
script:using('sh_data_system.lua')
script:using('cl_menu.lua')
-- script:using('sh_codeopt.lua')

script:using('lagdetectors/sh_framelag.lua')
script:using('lagdetectors/sh_lagdifference.lua')

script:using('dynamic_motion/sv_dynamic_motion.lua')
script:using('dynamic_motion/sv_entity_created.lua')
script:using('dynamic_motion/sv_entity_removed.lua')
script:using('dynamic_motion/sv_stop_motion.lua')
script:using('dynamic_motion/sv_run_motion.lua')
script:using('dynamic_motion/sv_physgun.lua')
script:using('dynamic_motion/sv_should_collide.lua')
script:using('dynamic_motion/sv_player_vehicle.lua')

script:using('smooth_unfreeze/sv_smooth_unfreeze.lua')
script:using('smooth_unfreeze/sv_player_meta.lua')
script:using('smooth_unfreeze/sv_unfreeze_process.lua')

script:using('collision_lags/sv_collision_lags.lua')

script:using('lagging_builds/sv_lagging_builds.lua')
script:using('lagging_builds/cl_lagging_notify.lua')

script:using('occlusion_visible/cl_occlusion_visible.lua')
script:using('occlusion_visible/sv_occlusion_visible.lua')

script:using('system_optimization/sh_bad_hook_remover.lua')
script:using('system_optimization/sh_seats.lua')
script:using('system_optimization/sh_widgets.lua')
script:using('system_optimization/cl_good_cvars.lua')

script:using('update_optimization/sh_update.lua')

script:using('compiler/sh_lua_object.lua')
script:using('compiler/sh_compiler_cache.lua')
script:using('compiler/sh_example.lua')
script:using('compiler/sh_optimizations.lua')
script:using('compiler/optimization/sh_comments_remover.lua')
script:using('compiler/optimization/sh_ipairs.lua')
script:using('compiler/optimization/sh_pairs.lua')
script:using('compiler/optimization/sh_global_func_vars.lua')
script:using('compiler/optimization/sh_lib_vars.lua')
-- script:using('compiler/optimization/sh_vector.lua')
-- script:using('compiler/optimization/sh_angle.lua')
-- script:using('compiler/optimization/sh_color.lua')
script:using('compiler/optimization/sh_compact.lua')
script:using('compiler/sh_file_fixed.lua')
script:using('compiler/sh_compiler.lua')

-- script:using('sv_motion.lua')
-- script:using('sh_think_optimization.lua')
-- script:using('sh_effect_optimization.lua')