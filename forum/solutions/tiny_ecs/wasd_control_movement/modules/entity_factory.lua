-- Создает сущности
local Position = require("components.Position")
local Velocity = require("components.Velocity")
local Player = require("components.PlayerData")
local GoID = require("components.GoID")
local Input = require("components.Input")

local M = {}

function M.create_player(world, x, y, go_id)
	local entity = {
		[Position] = { x = x, y = y },
		[Velocity] = { x = 0, y = 0 },
		[Player] = { 
			moveSpeed = 200
		},
		[Input] = {},
		[GoID] = { id = go_id }
	}

	world:addEntity(entity)
	return entity
end

return M
