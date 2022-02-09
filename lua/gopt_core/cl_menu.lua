local lang = slib.language({
	['default'] = {
		occlusion_visible_title = 'Area of visibility',
		occlusion_visible_desc = 'this setting only renders the objects the player is looking at. Unfortunately, this works even if the player looks across the entire map. For more flexible customization, you can change the distance parameters.',
		occlusion_visible_min_title = 'Minimum visibility distance',
		occlusion_visible_min_desc = 'the minimum distance at which objects will always be visible, even if the player is not looking at them.',
		occlusion_visible_max_title = 'Maximum visibility distance',
		occlusion_visible_max_desc = 'the maximum distance beyond which any objects will not be rendered, even if the player is looking at them.',
		anti_crash_title = 'Anti crash',
		anti_crash_desc = 'if this setting is active, then when lags are detected, the system will try to freeze the most malicious objects, sorting them by their number on the map. Knows how to detect large buildings and the same type of spam entities.',
		anti_crash_hard_mode_title = 'Anti crash (Hard Mode)',
		anti_crash_hard_mode_desc = 'if the server fails to interrupt the lags by any means, it will completely clear the map.',
		npc_logic_title = 'NPC logic optimization',
		npc_logic_desc = 'this setting allows you to enable the logic of NPCs only if the player is looking at them. If no player is looking at the NPC, then the logic will be processed less often than usual. This setting works even if the player is looking at the NPC through the map. For more flexible customization, you can change the distance parameters.',
		npc_logic_min_distacne_title = 'NPC alway logic distance',
		npc_logic_min_distacne_desc = 'the minimum distance at which the NPC logic will always be active, even if the player is not looking at the NPC.',
		smooth_unfreeze_title = 'Smooth defrosting',
		smooth_unfreeze_desc = 'if this parameter is active, then when you try to unfreeze a lot of props, they will unfreeze gradually.',
		dynamic_motion_title = 'Dynamic motion',
		dynamic_motion_desc = 'this setting allows you to enable flexible freezing of items. If entities are at rest, their physics will be disabled until such time as they are not affected. This is useful if you want to protect your server from a lot of unused physics-enabled props. Also useful for local play.',
		collision_lags_title = 'Collision lags',
		collision_lags_desc = 'this setting prevents the server from crashing from a lot of bad collisions.',
		collision_lags_flexable_title = 'Collision lags flexable',
		collision_lags_flexable_desc = 'this setting allows you to enable collision checking only when lags are detected. In fact, this does not always work, so I do not recommend it for use.',
		collision_lags_constraints_title = 'Collision lags constraints',
		collision_lags_constraints_desc = 'if this parameter is enabled, then all entities bound by constraints will also be frozen.',
		collision_lags_constraints_flexable_title = 'Collision lags constraints flexable',
		collision_lags_constraints_flexable_desc = 'if this parameter is enabled, then constrained entities will be frozen only when lags are detected.',
		gopt_scripts_optimization_title = 'Script optimization',
		gopt_scripts_optimization_desc = 'overrides the default script launcher and adds some optimization techniques. It also reduces the size of the code and caches it, making reloading the game faster. WARNING, THIS OPTION MAY BREAK SOME ADDONS UNDER CERTAIN CIRCUMSTANCES. DO NOT USE THIS IF YOU HAVE PROBLEMS!',
		gopt_scripts_optimization_cache_title = 'Cache scripts',
		gopt_scripts_optimization_cache_desc = 'if enabled, scripts will be cached in the file system and used on reload. The cache is not updated after creation and needs to be cleared if some addons have been updated.',
		gopt_scripts_optimization_cache_loader_title = 'Use cache loader',
		gopt_scripts_optimization_cache_loader_desc = 'if enabled, scripts will be loaded from the cache. If disabled, the cache will be updated every time the game is loaded.',
		gopt_scripts_optimization_cache_type_title = 'Caching type',
		gopt_scripts_optimization_cache_type_desc = 'filesystem type to be used for caching scripts. Recommended - SQL',
		gopt_cl_gopt_clear_scripts_cache_title = 'Clear client cache',
		gopt_sv_gopt_clear_scripts_cache_title = 'Clear server cache',
		gopt_log_title = 'Enable logs',
		gopt_log_desc = 'if enabled, the system operation history will be written to the "data/gopt_data/log.txt" file.',
		gopt_scripts_optimization_cache_compress_title = 'Use compression',
		gopt_scripts_optimization_cache_compress_desc = 'compresses data in the file system to take up less space. Only for storage type - file. (Warning! After changing this setting, you need to clear the cache!)',
		gopt_update_optimization_title = 'Think optimization',
		gopt_update_optimization_desc = 'in case of lags, "Think" type hooks will be executed less often. This setting may affect gameplay and interface visualization.',
		gopt_update_optimization_second_frame_title = 'Update with second frame',
		gopt_update_optimization_second_frame_desc = 'causes the "Think" hook to be executed not every frame, but after one frame.',
		dynamic_motion_max_unfreeze_per_second_title = 'Maximum unfreeze objects',
		dynamic_motion_max_unfreeze_per_second_desc = 'how many objects can be unfrozen in one second.',
		dynamic_motion_unfreeze_delay_title = 'Unfreeze delay',
		dynamic_motion_unfreeze_delay_desc = 'the delay between unfreezing a new collection of objects.',
	},
	['russian'] = {
		occlusion_visible_title = 'Зона видимости',
		occlusion_visible_desc = 'этот параметр отображает только те объекты, на которые смотрит игрок. К сожалению, это работает, даже если игрок просматривает всю карту. Для более гибкой настройки вы можете изменить параметры расстояния.',
		occlusion_visible_min_title = 'Минимальное расстояние видимости',
		occlusion_visible_min_desc = 'минимальное расстояние, на котором объекты всегда будут видны, даже если игрок на них не смотрит.',
		occlusion_visible_max_title = 'Максимальное расстояние видимости',
		occlusion_visible_max_desc = 'максимальное расстояние, за которым никакие объекты не будут отображаться, даже если игрок смотрит на них.',
		anti_crash_title = 'Анти краш',
		anti_crash_desc = 'если эта настройка активна, то при обнаружении лагов система будет пытаться заморозить наиболее вредоносные объекты, отсортировав их по количеству на карте. Умеет обнаруживать большие постройки и однотипные спам-объекты.',
		anti_crash_hard_mode_title = 'Анти краш (Жёсткий Режим)',
		anti_crash_hard_mode_desc = 'если серверу не удастся прервать лаги любыми методами, то он полностью очистит карту.',
		npc_logic_title = 'Оптимизация логики NPC',
		npc_logic_desc = 'этот параметр позволяет вам включать логику NPC только если игрок смотрит на них. Если ни один игрок не смотрит на NPC, то логика будет обрабатываться реже чем обычно. Этот параметр работает, даже если игрок смотрит на NPC через карту. Для более гибкой настройки вы можете изменить параметры расстояния.',
		npc_logic_min_distacne_title = 'NPC дистанция активной лооики',
		npc_logic_min_distacne_desc = 'минимальное расстояние, на котором логика NPC всегда будет активна, даже если игрок не смотрит на NPC.',
		smooth_unfreeze_title = 'Плавное размораживание',
		smooth_unfreeze_desc = 'если этот параметр активен, то при попытке разморозить много пропсов они разморозятся постепенно.',
		dynamic_motion_title = 'Динамическое движение',
		dynamic_motion_desc = 'этот параметр позволяет включить гибкое замораживание элементов. Если сущности находятся в состоянии покоя, их физика будет отключена до тех пор, пока они не будут затронуты. Это полезно, если вы хотите защитить свой сервер от большого количества неиспользуемых объектов с физикой. Также полезно для локальной игры.',
		collision_lags_title = 'Лаги при столкновении',
		collision_lags_desc = 'этот параметр предотвращает сбой сервера из-за большого количества плохих столкновений.',
		collision_lags_flexable_title = 'Гибкие лаги при столкновении',
		collision_lags_flexable_desc = 'этот параметр позволяет включить проверку столкновений только при обнаружении задержек. На самом деле это не всегда срабатывает, поэтому к использованию не рекомендую.',
		collision_lags_constraints_title = 'Лаги при столкновении - соединения',
		collision_lags_constraints_desc = 'если этот параметр включен, то все объекты связанные ограничениями также будут заморожены.',
		collision_lags_constraints_flexable_title = 'Гибкие лаги при столкновении - соединения',
		collision_lags_constraints_flexable_desc = 'если этот параметр включен, то связанные объекты будут заморожены только при обнаружении лагов.',
		gopt_scripts_optimization_title = 'Оптимизация скриптов',
		gopt_scripts_optimization_desc = 'переопределяет стандартный лаунчер скриптов и добавляет некоторые методы оптимизации. Так-же уменьшает размер кода, и кэширует его, делая повторную загрузку игры быстрее. ВНИМАНИЕ, ЭТА ОПЦИЯ МОЖЕТ СЛОМАТЬ НЕКОТОРЫЕ АДДОНЫ ПРИ ОПРЕДЕЛЁННЫХ ОБСТОЯТЕЛЬСТВАХ. НЕ ИСПОЛЬЗУЙТЕ ЭТО ЕСЛИ У ВАС ВОЗНИКАЮТ ПРОБЛЕМЫ!',
		gopt_scripts_optimization_cache_title = 'Кэшировать скрипты',
		gopt_scripts_optimization_cache_desc = 'если включено, то скрипты будут кэшироваться в файловой системе, и использоваться при повторной загрузке. Кэш не обновляется после создания, и его нужно очищать, если некоторые аддоны были обновлены.',
		gopt_scripts_optimization_cache_loader_title = 'Использовать загрузчик кэша',
		gopt_scripts_optimization_cache_loader_desc = 'если включено, то скрипты будут загружаться из кэша. Если выключено, то кэш будет обновлятся каждый раз при загрузке игры.',
		gopt_scripts_optimization_cache_type_title = 'Тип кэширования',
		gopt_scripts_optimization_cache_type_desc = 'тип файловой системы который будет использоватся для кэширования скриптов. Рекомендуется - SQL',
		gopt_cl_gopt_clear_scripts_cache_title = 'Очистить кеш клиента',
		gopt_sv_gopt_clear_scripts_cache_title = 'Очистить кеш сервера',
		gopt_log_title = 'Включить логи',
		gopt_log_desc = 'если включено, в файл "data/gopt_data/log.txt" будет записываться история работы систем.',
		gopt_scripts_optimization_cache_compress_title = 'Использовать сжатие',
		gopt_scripts_optimization_cache_compress_desc = 'сжимает данные в файловой системе для того чтобы занимать меньше места. Только для типа хранилища - file. (Внимание! После изменения этого параметра вам нужно очистить кэш!)',
		gopt_update_optimization_title = 'Оптимизация обновлений',
		gopt_update_optimization_desc = 'в случае возникновения лагов, крючки с типом "Think" будут выполнятся реже. Этот параметр может повлиять на игровой процесс и визуализацию интерфейса.',
		gopt_update_optimization_second_frame_title = 'Обновлять вторым кадром',
		gopt_update_optimization_second_frame_desc = 'заставляет крючок "Think" выполнятся не каждый кадр, а через один кадр.',
		dynamic_motion_max_unfreeze_per_second_title = 'Максимум объектов разморозки',
		dynamic_motion_max_unfreeze_per_second_desc = 'сколько объектов можно разморозить за одну секунду',
		dynamic_motion_unfreeze_delay_title = 'Задержка разморозки',
		dynamic_motion_unfreeze_delay_desc = 'задержка между разморозкой новой коллекции объектов.',
	},
})

local function AddHeaderBox(panel, description)
	panel:AddControl('Header', {
		['Description'] = '==[ ' .. description .. ' ]==',
	})
end

local function AddCheckBox(panel, cvar, name, description)
	panel:AddControl('CheckBox', {
		['Label'] = name,
		['Command'] = cvar
	}) panel:AddControl('Label', {
		['Text'] = 'Description: ' .. description,
	})
end

local function AddSliderBox(panel, cvar, name, description, has_float)
	panel:AddControl('Slider', {
		['Label'] = name,
		['Command'] = cvar,
		['Type'] = has_float and 'Float' or 'Integer',
		['Min'] = GetConVar(cvar):GetMin(),
		['Max'] = GetConVar(cvar):GetMax(),
	}) panel:AddControl('Label', {
		['Text'] = 'Description: ' .. description,
	})
end

local function GeneralMenu(panel)
	AddHeaderBox(panel, 'System')

	AddCheckBox(panel, 'gopt_log',
		lang.gopt_log_title, lang.gopt_log_desc)

	AddHeaderBox(panel, 'Optimization')

	AddCheckBox(panel, 'gopt_update_optimization',
		lang.gopt_update_optimization_title, lang.gopt_update_optimization_desc)

	AddCheckBox(panel, 'gopt_update_optimization_second_frame',
		lang.gopt_update_optimization_second_frame_title, lang.gopt_update_optimization_second_frame_desc)
end

local function ClientMenu(panel)
	AddHeaderBox(panel, 'Occlusion')

	AddCheckBox(panel, 'gopt_occlusion_visible',
		lang.occlusion_visible_title, lang.occlusion_visible_desc)

	AddSliderBox(panel, 'gopt_occlusion_visible_min',
		lang.occlusion_visible_min_title, lang.occlusion_visible_min_desc)

	AddSliderBox(panel, 'gopt_occlusion_visible_max',
		lang.occlusion_visible_max_title, lang.occlusion_visible_max_desc)
end

local function ServerMenu(panel)
	AddHeaderBox(panel, 'Anti Crash')

	AddCheckBox(panel, 'gopt_anti_crash_system',
		lang.anti_crash_title, lang.anti_crash_desc)

	AddCheckBox(panel, 'gopt_anti_crash_system_hard_mode',
		lang.anti_crash_hard_mode_title, lang.anti_crash_hard_mode_desc)

	AddHeaderBox(panel, 'NPC Logic')

	AddCheckBox(panel, 'gopt_npc_logic_optimization',
		lang.npc_logic_title, lang.npc_logic_desc)

	AddSliderBox(panel, 'gopt_npc_logic_min_distacne',
		lang.npc_logic_min_distacne_title, lang.npc_logic_min_distacne_desc)

	AddHeaderBox(panel, 'Smooth Unfreeze')

	AddCheckBox(panel, 'gopt_smooth_unfreeze',
		lang.smooth_unfreeze_title, lang.smooth_unfreeze_desc)

	AddHeaderBox(panel, 'Dynamic Motion')

	AddCheckBox(panel, 'gopt_dynamic_motion',
		lang.dynamic_motion_title, lang.dynamic_motion_desc)

	AddSliderBox(panel, 'gopt_dynamic_motion_max_unfreeze_per_second',
		lang.dynamic_motion_max_unfreeze_per_second_title, lang.dynamic_motion_max_unfreeze_per_second_desc)

	AddSliderBox(panel, 'gopt_dynamic_motion_unfreeze_delay',
		lang.dynamic_motion_unfreeze_delay_title, lang.dynamic_motion_unfreeze_delay_desc, true)

	AddHeaderBox(panel, 'Anti Collision Lags')

	AddCheckBox(panel, 'gopt_collision_lags',
		lang.collision_lags_title, lang.collision_lags_desc)

	AddCheckBox(panel, 'gopt_collision_lags_flexable',
		lang.collision_lags_flexable_title, lang.collision_lags_flexable_desc)

	AddCheckBox(panel, 'gopt_collision_lags_constraints',
		lang.collision_lags_constraints_title, lang.collision_lags_constraints_desc)

	AddCheckBox(panel, 'gopt_collision_lags_constraints_flexable',
		lang.collision_lags_constraints_flexable_title, lang.collision_lags_constraints_flexable_desc)
end

local function ScriptsMenu(panel)
	AddHeaderBox(panel, 'Scripts Optimization')

	AddCheckBox(panel, 'gopt_scripts_optimization',
		lang.gopt_scripts_optimization_title, lang.gopt_scripts_optimization_desc)

	AddHeaderBox(panel, 'Scripts Cache')

	AddCheckBox(panel, 'gopt_scripts_optimization_cache',
		lang.gopt_scripts_optimization_cache_title, lang.gopt_scripts_optimization_cache_desc)

	AddCheckBox(panel, 'gopt_scripts_optimization_cache_compress',
		lang.gopt_scripts_optimization_cache_compress_title, lang.gopt_scripts_optimization_cache_compress_desc)

	AddCheckBox(panel, 'gopt_scripts_optimization_cache_loader',
		lang.gopt_scripts_optimization_cache_loader_title, lang.gopt_scripts_optimization_cache_loader_desc)

	panel:AddControl('ListBox', {
		['Label'] = lang.gopt_scripts_optimization_cache_type_title,
		['Command'] = 'gopt_scripts_optimization_cache_type',
		['Options'] = {
			['All'] = {
				['gopt_scripts_optimization_cache_type'] = 'all',
			},
			['File'] = {
				['gopt_scripts_optimization_cache_type'] = 'file',
			},
			['SQL'] = {
				['gopt_scripts_optimization_cache_type'] = 'sql',
			},
		}
	}) panel:AddControl('Label', {
		['Text'] = 'Description: ' .. lang.gopt_scripts_optimization_cache_type_desc,
	})

	AddHeaderBox(panel, 'Reset Scripts Cache')

	panel:AddControl('Button', {
		['Label'] = 'Description: ' .. lang.gopt_cl_gopt_clear_scripts_cache_title,
		['Command'] = 'cl_gopt_clear_scripts_cache',
	})

	panel:AddControl('Button', {
		['Label'] = 'Description: ' .. lang.gopt_sv_gopt_clear_scripts_cache_title,
		['Command'] = 'sv_gopt_clear_scripts_cache',
	})
end

hook.Add('AddToolMenuCategories', 'GOpt.RegisterToolCategory', function()
	spawnmenu.AddToolCategory('Options', 'GOpt', '#GOpt' )
end)

hook.Add('PopulateToolMenu', 'GOpt.RegisterToolMenu', function()
	spawnmenu.AddToolMenuOption('Options', 'GOpt', 'GOOPT_Menu_General',
		'#General settings', '', '', GeneralMenu)

	spawnmenu.AddToolMenuOption('Options', 'GOpt', 'GOOPT_Menu_Client',
		'#Client settings', '', '', ClientMenu)

	spawnmenu.AddToolMenuOption('Options', 'GOpt', 'GOOPT_Menu_Server',
		'#Server settings', '', '', ServerMenu)

	spawnmenu.AddToolMenuOption('Options', 'GOpt', 'GOOPT_Menu_Scripts',
		'#Scripts settings', '', '', ScriptsMenu)
end)