local machine = require("modules.statemachine")
local monarch = require("monarch.monarch")

local M = {}


--local pl_url = "/player#player_manager"
M.machine = machine.create({
	initial = "main_menu",
	events = {
		{ name = "main_menu", from = "game_over", to = "main_menu" },
		{ name = "game", from = { "main_menu", "upgrade", "game_over" }, to = "game" },
		{ name = "upgrade", from = "game", to = "upgrade" },
		{ name = "game_over", from = "game", to = "game_over" },			
	},
	callbacks = {
		onbeforemain_menu = function(self, event, from, to)
			--machine:main_menu()
			print("Я вхожу в MAIN_MENU!")
		end,
		onbeforegame = function(self, event, from, to)
			msg.post("game:/game_manager#wave_manager", "game")
			print("Я вхожу в GAME!")
			msg.post("game:/spawner#spawner", "spawn_enemies")
			msg.post("game:/spawner#spawner", "reset_settings")
		end,
		onbeforeupgrade = function(self, event, from, to)
			--machine:upgrade()
			print("Я вхожу в UPGRADE!") 
			msg.post("/game_manager#wave_manager", "upgrade")
			M.on_pause()
			M.set_current_wave()
			monarch.show(hash("upgrade")) 
		end,
		onbeforegame_over = function(self, event, from, to)
			--machine:game_over()
			print("Я вхожу в GAME_OVER!")
			msg.post("/game_manager#wave_manager", "game_over")
			M.on_pause()
			monarch.show(hash("game_over")) 
		end,
	}

})	

local current_wave = 1
local isPause = false

function M.get_current_wave()
	return current_wave
end

function M.set_current_wave()
	current_wave = current_wave + 1
end	

function M.reset_current_wave()
	current_wave = 1
end

function M.on_pause()
	msg.post("controller:/game#game_proxy", "set_time_step", {factor = 0, mode = 0})
end


return M
