local lang = slib.language({
	['default'] = {
		control_description = 'Description: ',
		focus_optimization_title = 'Focus optimization',
		focus_optimization_desc = 'disables rendering of the game if the window is not in focus.',
		cvars_optimization_title = 'Cvars optimization',
		cvars_optimization_desc = 'includes the most optimal convar parameters for the client. If you turn it off, it will return the previous settings.',
		occlusion_ignore_npc = 'Ignore for NPC\'s',
		occlusion_ignore_players = 'Ignore for players',
		occlusion_ignore_vehicles = 'Ignore for vehicles',
		occlusion_visible_title = 'Area of visibility',
		occlusion_visible_desc = 'this setting only renders the objects the player is looking at. Unfortunately, this works even if the player looks across the entire map. For more flexible customization, you can change the distance parameters.',
		occlusion_trace_title = 'Raytracing visibility',
		occlusion_trace_desc = 'use ray tracing to optimize visibility more. This is useful if there are many rooms and small spaces on the map. May cause incorrect display of buildings. Disable this option if it does not work correctly.',
		occlusion_visible_strict_title = 'Strict tracing',
		occlusion_visible_strict_desc = 'Uses a stricter tracing mechanism. (Not recommended, this feature is experimental and may be removed in the future.)',
		occlusion_visible_min_title = 'Minimum visibility distance',
		occlusion_visible_min_desc = 'the minimum distance at which objects will always be visible, even if the player is not looking at them.',
		occlusion_visible_max_title = 'Maximum visibility distance',
		occlusion_visible_max_desc = 'the maximum distance beyond which any objects will not be rendered, even if the player is looking at them. Set this value to "0" if you want to always see the objects you are looking at.',
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
		dynamic_motion_no_childs_title = 'Dynamics without wire',
		dynamic_motion_no_childs_desc = 'Dynamic prop movement will only work if the object has no connections to other objects. Remove this if you want stricter restrictions.',
		collision_lags_title = 'Collision lags',
		collision_lags_desc = 'this setting prevents the server from crashing from a lot of bad collisions.',
		collision_lags_flexable_title = 'Collision lags flexable',
		collision_lags_flexable_desc = 'this setting allows you to enable collision checking only when lags are detected. In fact, this does not always work, so I do not recommend it for use.',
		collision_lags_constraints_title = 'Collision lags constraints',
		collision_lags_constraints_desc = 'if this parameter is enabled, then all entities bound by constraints will also be frozen.',
		collision_lags_constraints_flexable_title = 'Collision lags constraints flexable',
		collision_lags_constraints_flexable_desc = 'if this parameter is enabled, then constrained entities will be frozen only when lags are detected.',
		gopt_cl_gopt_clear_scripts_cache_title = 'Clear client cache',
		gopt_sv_gopt_clear_scripts_cache_title = 'Clear server cache',
		gopt_log_title = 'Enable logs',
		gopt_log_desc = 'if enabled, the system operation history will be written to the "data/gopt_data/log.txt" file.',
		gopt_update_optimization_title = 'Think optimization',
		gopt_update_optimization_desc = 'in case of lags, "Think" type hooks will be executed less often. This setting may affect gameplay and interface visualization.',
		gopt_update_optimization_second_frame_title = 'Update with second frame',
		gopt_update_optimization_second_frame_desc = 'causes the "Think" hook to be executed not every frame, but after one frame.',
		dynamic_motion_max_unfreeze_per_second_title = 'Maximum unfreeze objects',
		dynamic_motion_max_unfreeze_per_second_desc = 'how many objects can be unfrozen in one second.',
		dynamic_motion_unfreeze_delay_title = 'Unfreeze delay',
		dynamic_motion_unfreeze_delay_desc = 'the delay between unfreezing a new collection of objects.',
		gopt_entity_tickrate = 'limits the number of ticks an entity can take. Not recommended for vehicles and weapons.'
	},
	['russian'] = {
		control_description = 'Описание: ',
		focus_optimization_title = 'Оптимизация фокуса',
		focus_optimization_desc = 'отключает рендер игры, если окно не в фокусе.',
		cvars_optimization_title = 'Оптимизация кваров',
		cvars_optimization_desc = 'включает наиболее оптимальные параметры конваров для клиента. Если выключить - вернёт прежние настройки.',
		occlusion_ignore_npc = 'Игнорировать для NPC\'s',
		occlusion_ignore_players = 'Игнорировать для игроков',
		occlusion_ignore_vehicles = 'Игнорировать для автотранспорта',
		occlusion_visible_title = 'Зона видимости',
		occlusion_visible_desc = 'этот параметр отображает только те объекты, на которые смотрит игрок. К сожалению, это работает, даже если игрок просматривает всю карту. Для более гибкой настройки вы можете изменить параметры расстояния.',
		occlusion_trace_title = 'Трассировка зоны видимости',
		occlusion_trace_desc = 'использовать трассировку лучей для большей оптимизации видимости. Это полезно, если на карте много комнат и маленьких пространств. Может вызвать некорректное отображение построек. Отключите этот параметр если он работает некорректно.',
		occlusion_visible_strict_title = 'Строгая трассировка',
		occlusion_visible_strict_desc = 'Использует более строгий механизм трассировки. (Не рекомендуется использовать, функция эксперементальная и может быть удалена в будущем.)',
		occlusion_visible_min_title = 'Минимальное расстояние видимости',
		occlusion_visible_min_desc = 'минимальное расстояние, на котором объекты всегда будут видны, даже если игрок на них не смотрит.',
		occlusion_visible_max_title = 'Максимальное расстояние видимости',
		occlusion_visible_max_desc = 'максимальное расстояние, за которым никакие объекты не будут отображаться, даже если игрок смотрит на них. Установите это значение на "0", если хотите всегда видеть объекты на которые вы смотрите.',
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
		dynamic_motion_no_childs_title = 'Динамика без связей',
		dynamic_motion_no_childs_desc = 'Динамическое движение пропов будет работать только если объект не имеет никаких связей с другими объектами. Уберите это, если хотите более строгие ограничения.',
		collision_lags_title = 'Лаги при столкновении',
		collision_lags_desc = 'этот параметр предотвращает сбой сервера из-за большого количества плохих столкновений.',
		collision_lags_flexable_title = 'Гибкие лаги при столкновении',
		collision_lags_flexable_desc = 'этот параметр позволяет включить проверку столкновений только при обнаружении задержек. На самом деле это не всегда срабатывает, поэтому к использованию не рекомендую.',
		collision_lags_constraints_title = 'Лаги при столкновении - соединения',
		collision_lags_constraints_desc = 'если этот параметр включен, то все объекты связанные ограничениями также будут заморожены.',
		collision_lags_constraints_flexable_title = 'Гибкие лаги при столкновении - соединения',
		collision_lags_constraints_flexable_desc = 'если этот параметр включен, то связанные объекты будут заморожены только при обнаружении лагов.',
		gopt_cl_gopt_clear_scripts_cache_title = 'Очистить кеш клиента',
		gopt_sv_gopt_clear_scripts_cache_title = 'Очистить кеш сервера',
		gopt_log_title = 'Включить логи',
		gopt_log_desc = 'если включено, в файл "data/gopt_data/log.txt" будет записываться история работы систем.',
		gopt_update_optimization_title = 'Оптимизация обновлений',
		gopt_update_optimization_desc = 'в случае возникновения лагов, крючки с типом "Think" будут выполнятся реже. Этот параметр может повлиять на игровой процесс и визуализацию интерфейса.',
		gopt_update_optimization_second_frame_title = 'Обновлять вторым кадром',
		gopt_update_optimization_second_frame_desc = 'заставляет крючок "Think" выполнятся не каждый кадр, а через один кадр.',
		dynamic_motion_max_unfreeze_per_second_title = 'Максимум объектов разморозки',
		dynamic_motion_max_unfreeze_per_second_desc = 'сколько объектов можно разморозить за одну секунду',
		dynamic_motion_unfreeze_delay_title = 'Задержка разморозки',
		dynamic_motion_unfreeze_delay_desc = 'задержка между разморозкой новой коллекции объектов.',
		gopt_entity_tickrate = 'ограничивает количество тиков, которые может совершить сущность. Не рекомендуется ставить для транспорта и оружия.'
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
	})

	if description and description ~= '' then
		panel:AddControl('Label', {
			['Text'] = lang.control_description .. description,
		})
	end
end

local function AddSliderBox(panel, cvar, name, description, has_float)
	panel:AddControl('Slider', {
		['Label'] = name,
		['Command'] = cvar,
		['Type'] = has_float and 'Float' or 'Integer',
		['Min'] = GetConVar(cvar):GetMin(),
		['Max'] = GetConVar(cvar):GetMax(),
	})

	if description and description ~= '' then
		panel:AddControl('Label', {
			['Text'] = lang.control_description .. description,
		})
	end
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

	AddHeaderBox(panel, 'Entity Tickrate')

	panel:AddControl('Label', {
		['Text'] = 'Description: ' .. lang.gopt_entity_tickrate,
	})

	AddSliderBox(panel, 'gopt_entity_tickrate_weapon', 'Weapon', '')
	AddSliderBox(panel, 'gopt_entity_tickrate_npc', 'NPC', '')
	AddSliderBox(panel, 'gopt_entity_tickrate_nextbot', 'NextBot', '')
	AddSliderBox(panel, 'gopt_entity_tickrate_vehicle', 'Vehicle', '')
	AddSliderBox(panel, 'gopt_entity_tickrate_other', 'Other', '')

	panel:AddControl('Label', {
		['Text'] = 'Ignore Entities',
	})

	local IgnoreEntitiesList = vgui.Create('DListView', panel)
	IgnoreEntitiesList:SetSize(0, 250)
	IgnoreEntitiesList:Dock(TOP)
	IgnoreEntitiesList:DockMargin(5, 5, 5, 5)
	IgnoreEntitiesList:SetMultiSelect(false)
	IgnoreEntitiesList:AddColumn('Class')
	IgnoreEntitiesList.OnRowSelected = function(lst, index, pnl)
		if not LocalPlayer():IsAdmin() then return end
		snet.InvokeServer('sv_gopt_menu_ignore_entities_list_delete', pnl:GetColumnText(1))
	end

	local AddIgnoreEntityTextBox = vgui.Create('DTextEntry', panel)
	AddIgnoreEntityTextBox:Dock(TOP)
	AddIgnoreEntityTextBox:DockMargin(5, 5, 5, 5)
	AddIgnoreEntityTextBox:SetPlaceholderText('Add entity class')
	AddIgnoreEntityTextBox.OnEnter = function(self)
		if not LocalPlayer():IsAdmin() then return end

		local entityClass = self:GetValue()
		entityClass = string.Trim(entityClass)
		entityClass = string.lower(entityClass)

		if not entityClass or #entityClass == 0 then return end

		for _, line in ipairs(IgnoreEntitiesList:GetLines()) do
				if line:GetValue(1) == entityClass then return end
		end

		snet.InvokeServer('sv_gopt_menu_ignore_entities_list_add', entityClass)
		AddIgnoreEntityTextBox:SetValue('')
	end

	panel:AddControl('Label', { ['Text'] = '' })

	snet.Callback('cl_gopt_menu_ignore_entities_list_sync_menu', function(_, entities)
		IgnoreEntitiesList:Clear()
		for _, v in ipairs(entities) do
			IgnoreEntitiesList:AddLine(v)
		end
	end)

	snet.InvokeServer('sv_gopt_menu_ignore_entities_list_sync')
end

local function ClientMenu(panel)
	AddHeaderBox(panel, 'Game')

	AddCheckBox(panel, 'gopt_focus_optimization',
		lang.focus_optimization_title, lang.focus_optimization_desc)

	AddHeaderBox(panel, 'Occlusion')

	AddCheckBox(panel, 'gopt_occlusion_trace',
		lang.occlusion_trace_title, lang.occlusion_trace_desc)

	AddCheckBox(panel, 'gopt_occlusion_visible_strict',
		lang.occlusion_visible_strict_title, lang.occlusion_visible_strict_desc)

	AddCheckBox(panel, 'gopt_occlusion_visible',
		lang.occlusion_visible_title, lang.occlusion_visible_desc)

	AddSliderBox(panel, 'gopt_occlusion_visible_min',
		lang.occlusion_visible_min_title, lang.occlusion_visible_min_desc)

	AddSliderBox(panel, 'gopt_occlusion_visible_max',
		lang.occlusion_visible_max_title, lang.occlusion_visible_max_desc)

	AddCheckBox(panel, 'gopt_occlusion_ignore_npc', lang.occlusion_ignore_npc)
	AddCheckBox(panel, 'gopt_occlusion_ignore_players', lang.occlusion_ignore_players)
	AddCheckBox(panel, 'gopt_occlusion_ignore_vehicles', lang.occlusion_ignore_vehicles)

	AddHeaderBox(panel, 'Cvars')

	AddCheckBox(panel, 'gopt_cvars_optimization',
		lang.cvars_optimization_title, lang.cvars_optimization_desc)
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

	AddCheckBox(panel, 'gopt_dynamic_motion_no_childs',
		lang.dynamic_motion_no_childs_title, lang.dynamic_motion_no_childs_desc)

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
end)

snet.Callback('cl_gopt_menu_ignore_entities_list_sync', function(_, entities)
	GOptCore.Storage.IgnoreEntitiesTickrate = entities
end)