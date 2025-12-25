local machine = require("modules.statemachine")
local monarch = require("monarch.monarch")


local M = {}

M.machine = machine.create({
	initial = "none",
	events = {
		{ name = "menu", from = { "none", "pause", "game_over", "menu_settings", "records", "authors" }, to = "menu" },
		{ name = "records", from = "menu", to = "records" },
		{ name = "authors", from = "menu", to = "authors" },
		{ name = "game", from = { "menu", "game_over", "game_settings", "pause" }, to = "game" },
		{ name = "pause", from = { "game", "game_settings" }, to = "pause" },
		{ name = "game_settings", from = { "pause" }, to = "game_settings" },
		{ name = "menu_settings", from = { "menu" }, to = "menu_settings" },
		{ name = "game_over", from = "game", to = "game_over" },
	},
	callbacks = {
		-- MENU
		onbeforemenu = function(self, event, from, to)
			print("Я вхожу в MENU!")
		end,
		-- GAME
		onbeforegame = function(self, event, from, to)
			print("Я вхожу в GAME!")
		end,
		-- PAUSE
		onbeforepause = function(self, event, from, to)
			print("Я вхожу в PAUSE!")
		end,
		-- GAME_OVER
		onbeforegame_over = function(self, event, from, to)
			print("Я вхожу в GAME_OVER!")
		end,
		-- SETTINGS
		onbeforegame_settings = function(self, event, from, to)
			print("Я вхожу в GAME SETTINGS!")
		end,
		onbeforemenu_settings = function(self, event, from, to)
			print("Я вхожу в MENU SETTINGS!")
		end,
		onbeforemenu_authors = function(self, event, from, to)
			print("Я вхожу в AUTHORS!")
		end,
		onbeforemenu_records = function(self, event, from, to)
			print("Я вхожу в RECORDS!")
		end,
	}
})

return M