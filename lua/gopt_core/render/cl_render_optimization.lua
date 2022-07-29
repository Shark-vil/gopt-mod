local IsFocus = GOptCore.Api.IsGameFocus

hook.Add('PreRender', 'GOpt.Render.GameFocusOptimization', function()
	if not IsFocus() then
		return true
	end
end)