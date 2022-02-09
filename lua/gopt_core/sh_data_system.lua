local ipairs = ipairs
local file_Find = file.Find
local file_Delete = file.Delete
local os_date = os.date
--
local main_directory = 'gopt_data'
local cache_directory = main_directory .. '/cache'
local error_cache_directory = main_directory .. '/error'
local log_file_stream = slib.FileStream(main_directory .. '/log.txt', false, true)

local function RecursiveCacheDeletion(directory_path)
	if not directory_path then
		local postfix = SERVER and 'serverside' or 'clientside'
		directory_path = cache_directory .. '/' .. postfix .. '/'
	end

	local files, directories = file_Find(directory_path .. '*', 'DATA')
	if files then
		for _, file_name in ipairs(files) do
			file_Delete(directory_path .. file_name)
		end
	end

	if directories then
		for _, directory_name in ipairs(directories) do
			RecursiveCacheDeletion(directory_path .. directory_name .. '/')
			file_Delete(directory_path .. directory_name)
		end
	end
end

function GOptCore.Api.GetCacheFilePath(lua_object, custom_cache_directory)
	if not lua_object then return end

	custom_cache_directory = custom_cache_directory or cache_directory

	local postfix = SERVER and 'serverside' or 'clientside'
	local directory_path = custom_cache_directory .. '/' .. postfix .. '/' .. lua_object:GetDirectoryPath()
	local file_name = lua_object:GetFileName()
	local file_path = directory_path .. '/' .. file_name .. '.dat'

	return file_path
end

function GOptCore.Api.GetCacheFileStream(lua_object, custom_cache_directory)
	if not lua_object then return end

	local file_path = GOptCore.Api.GetCacheFilePath(lua_object, custom_cache_directory)
	if not file_path then return end

	return slib.FileStream(file_path, false, true)
end

function GOptCore.Api.WriteCahce(lua_object)
	if not lua_object then return end

	if GetConVar('gopt_scripts_optimization_cache'):GetBool() then
		local cache_type = GetConVar('gopt_scripts_optimization_cache_type'):GetString()
		if cache_type ~= 'sql' and cache_type ~= 'file' and cache_type ~= 'all' then
			cache_type = 'sql'
		end

		local script_file_path = lua_object:GetFilePath()
		local write_data = lua_object:GetCode()

		if cache_type == 'file' or cache_type == 'all' then
			local file_path = GOptCore.Api.GetCacheFilePath(lua_object)
			if file_path then
				local is_compress = GetConVar('gopt_scripts_optimization_cache_compress'):GetBool()
				local file_stream = slib.FileStream(file_path, is_compress, true)
				if file_stream then
					file_stream.Write(write_data)
				end
			end
		end

		if cache_type == 'sql' or cache_type == 'all' then
			GOptCore.SQL.ScriptCache:InsertOrUpdate({
				fields = {
					{ name = 'script_path', value = script_file_path },
					{ name = 'script_code', value = write_data }
				},
				where = { name = 'script_path', value = script_file_path },
			})
		end
	end
end

function GOptCore.Api.WriteErrorCahce(lua_object)
	if not lua_object then return end

	if GetConVar('gopt_scripts_optimization_cache'):GetBool() then
		local write_data = lua_object:GetCode()
		local file_stream = GOptCore.Api.GetCacheFileStream(lua_object, error_cache_directory)
		if file_stream then file_stream.Write(write_data) end
	end
end

function GOptCore.Api.ReadCache(lua_object)
	if not lua_object then return end
	if not GetConVar('gopt_scripts_optimization_cache'):GetBool() then return end

	local cache_type = GetConVar('gopt_scripts_optimization_cache_type'):GetString()
	if cache_type ~= 'sql' and cache_type ~= 'file' and cache_type ~= 'all' then
		cache_type = 'sql'
	end

	local sql_read_data

	if cache_type == 'sql' or cache_type == 'all' then
		local script_file_path = lua_object:GetFilePath()
		sql_read_data = GOptCore.SQL.ScriptCache:Read({
			fields = {
				{ name = 'script_code' }
			},
			where = { name = 'script_path', value = script_file_path },
			first = true
		})
	end

	if sql_read_data then
		return sql_read_data['script_code']
	elseif cache_type == 'file' or cache_type == 'all' then
		local file_path = GOptCore.Api.GetCacheFilePath(lua_object)
		if file_path then
			local is_compress = GetConVar('gopt_scripts_optimization_cache_compress'):GetBool()
			local file_stream = slib.FileStream(file_path, is_compress, true)
			if file_stream then
				return file_stream.Read()
			end
		end
	end
end

function GOptCore.Api.ClearCache()
	local cache_type = GetConVar('gopt_scripts_optimization_cache_type'):GetString()
	if cache_type ~= 'sql' and cache_type ~= 'file' and cache_type ~= 'all' then
		cache_type = 'sql'
	end

	if cache_type == 'file' or cache_type == 'all' then
		RecursiveCacheDeletion()
	end

	if cache_type == 'sql' or cache_type == 'all' then
		GOptCore.SQL.ScriptCache:ResetTable()
	end
end

function GOptCore.Api.ClearErrorCache()
	local postfix = SERVER and 'serverside' or 'clientside'
	local directory_path = error_cache_directory .. '/' .. postfix .. '/'
	RecursiveCacheDeletion(directory_path)
end

function GOptCore.Api.WriteLog(...)
	if not GetConVar('gopt_log'):GetBool() then return end
	local prefix = SERVER and '[SERVER]' or '[CLIENT]'
	local date_time = os_date('%Y-%m-%d %H:%M:%S')
	log_file_stream.WriteLine('[', date_time, '] ', prefix, ' ', ...)
end

function GOptCore.Api.ClearLog()
	log_file_stream.Clear()
end

if CLIENT then
	concommand.Add('cl_gopt_clear_scripts_cache', function()
		GOptCore.Api.ClearCache()
		GOptCore.Api.ClearErrorCache()
	end)
end

scommand.Create('sv_gopt_clear_scripts_cache').OnServer(function(ply)
	GOptCore.Api.ClearCache()
	GOptCore.Api.ClearErrorCache()
end).Access( { isAdmin = true } ).Register()

if SERVER then
	GOptCore.Api.ClearLog()
end

GOptCore.Api.ClearErrorCache()