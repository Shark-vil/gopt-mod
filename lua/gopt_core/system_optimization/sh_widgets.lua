GOptCore.Storage.WidgetsPlayerTick = GOptCore.Storage.WidgetsPlayerTick or widgets.PlayerTick

hook.Add('PreGamemodeLoaded', 'GOpt.WidgetsRemover', function()
	function widgets.PlayerTick() end
	hook.Remove('PlayerTick', 'TickWidgets')
end)

-- hook.Add('OnEntityCreated', 'GOpt.BackWidgets',function(ent)
-- 	if ent:IsWidget() then
-- 		MsgN('Fucked widgets back')

-- 		-- widgets.PlayerTick = GOptCore.Storage.WidgetsPlayerTick

-- 		-- hook.Add('PlayerTick', 'TickWidgets', function(pl, mv)
-- 		-- 	widgets.PlayerTick(pl, mv)
-- 		-- end)

-- 		hook.Remove('OnEntityCreated','BackWidgets')
-- 	end
-- end)