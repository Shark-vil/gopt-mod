snet.RegisterCallback('GOpt.LaggingBuildsNotify', function(ply, text)
	local color_text = {
		Color(255, 85, 85, 200),
		'[Admin] ',
		Color(43, 255, 0, 200),
		'[GOpt Lags] ',
		Color(255, 255, 255, 200),
		' ',
		text
	}

	MsgN(unpack(color_text))
	chat.AddText(unpack(color_text))
end)