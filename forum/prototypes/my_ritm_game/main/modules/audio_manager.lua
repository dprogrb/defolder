local M = {}

-- Таблица треков
local tracks = {
	music = {
		url = "/track#sound",
		loop = false, -- Отключено для теста
		state = "stopped"
	}
}

function M.play(name)
	local track = tracks[name]
	if not track then 
		print("Audio error: Track not found: " .. tostring(name))
		return 
	end
	print("Playing track: " .. name .. ", url: " .. track.url)
	sound.play(track.url, { loop = track.loop })
	track.state = "playing"
end

function M.pause(name)
	local track = tracks[name]
	if not track or track.state ~= "playing" then 
		print("Audio warning: Cannot pause track: " .. tostring(name) .. ", state: " .. tostring(track and track.state or "nil"))
		return 
	end
	print("Pausing track: " .. name)
	sound.pause(track.url, true)
	track.state = "paused"
end

function M.resume(name)
	local track = tracks[name]
	if not track or track.state ~= "paused" then 
		print("Audio warning: Cannot resume track: " .. tostring(name) .. ", state: " .. tostring(track and track.state or "nil"))
		return 
	end
	print("Resuming track: " .. name)
	sound.pause(track.url, false) -- Используем set_paused для возобновления
	track.state = "playing"
end

function M.stop(name)
	local track = tracks[name]
	if not track then 
		print("Audio error: Track not found: " .. tostring(name))
		return 
	end
	print("Stopping track: " .. name)
	sound.stop(track.url)
	track.state = "stopped"
end

function M.get_state(name)
	local track = tracks[name]
	if not track then 
		print("Audio error: Track not found: " .. tostring(name))
		return "unknown" 
	end
	return track.state
end

function M.set_gain(name, value)
	local track = tracks[name]
	if not track then 
		print("Audio error: Track not found: " .. tostring(name))
		return 
	end
	print("Setting gain for track: " .. name .. ", value: " .. value)
	sound.set_gain(track.url, value)
end

function M.register(name, url, loop)
	print("Registering track: " .. name .. ", url: " .. url .. ", loop: " .. tostring(loop))
	tracks[name] = {
		url = url,
		loop = loop or false,
		state = "stopped"
	}
end

return M