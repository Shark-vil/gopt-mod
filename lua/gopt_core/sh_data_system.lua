local os_date = os.date
--
local main_directory = 'gopt_data'
local log_file_stream = slib.FileStream(main_directory .. '/log.txt', false, true)

function GOptCore.Api.WriteLog(...)
	if not GetConVar('gopt_log'):GetBool() then return end
	local prefix = SERVER and '[SERVER]' or '[CLIENT]'
	local date_time = os_date('%Y-%m-%d %H:%M:%S')
	log_file_stream.WriteLine('[', date_time, '] ', prefix, ' ', ...)
end

function GOptCore.Api.ClearLog()
	log_file_stream.Clear()
end

if SERVER then
	GOptCore.Api.ClearLog()
end