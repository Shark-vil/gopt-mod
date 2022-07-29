local filePath = 'gopt_data/entity_tickrate_ignore'

do
	local fileData = slib.FileRead(filePath)
	if fileData then
		GOptCore.Storage.IgnoreEntitiesTickrate = fileData
	end
end

hook.Add('slib.FirstPlayerSpawn', 'Gopt.IgnoreEntitiesListSync', function(ply)
	if not ply:IsAdmin() then return end

	local fileData = GOptCore.Storage.IgnoreEntitiesTickrate
	snet.Invoke('cl_gopt_menu_ignore_entities_list_sync', ply, fileData)
	snet.Invoke('cl_gopt_menu_ignore_entities_list_sync_menu', ply, fileData)
end)

snet.Callback('sv_gopt_menu_ignore_entities_list_sync', function(ply)
	local fileData = slib.FileRead(filePath)
	if not fileData then return end

	snet.Invoke('cl_gopt_menu_ignore_entities_list_sync', ply, fileData)
	snet.Invoke('cl_gopt_menu_ignore_entities_list_sync_menu', ply, fileData)
end).Protect()

snet.Callback('sv_gopt_menu_ignore_entities_list_add', function(ply, entityClass)
	local fileData = slib.FileRead(filePath) or {}
	table.InsertNoValue(fileData, entityClass)

	slib.FileWrite(filePath, fileData)
	GOptCore.Storage.IgnoreEntitiesTickrate = fileData

	snet.Invoke('cl_gopt_menu_ignore_entities_list_sync', ply, fileData)
	snet.Invoke('cl_gopt_menu_ignore_entities_list_sync_menu', ply, fileData)
end).Protect()

snet.Callback('sv_gopt_menu_ignore_entities_list_delete', function(ply, entityClass)
	local fileData = slib.FileRead(filePath)
	if not fileData then return end
	table.RemoveValueBySeq(fileData, entityClass)

	slib.FileWrite(filePath, fileData)
	GOptCore.Storage.IgnoreEntitiesTickrate = fileData

	snet.Invoke('cl_gopt_menu_ignore_entities_list_sync', ply, fileData)
	snet.Invoke('cl_gopt_menu_ignore_entities_list_sync_menu', ply, fileData)
end).Protect()