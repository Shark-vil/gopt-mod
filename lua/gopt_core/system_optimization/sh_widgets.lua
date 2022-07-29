GOptCore.Storage.WidgetsPlayerTick = GOptCore.Storage.WidgetsPlayerTick or widgets.PlayerTick

hook.Add('PreGamemodeLoaded', 'GOpt.WidgetsRemover', function()
	function widgets.PlayerTick() end
	hook.Remove('PlayerTick', 'TickWidgets')
end)