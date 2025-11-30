-- systems/movement_system.lua
local tiny = require("tinyecs.tiny")
local Position = require("components.position")
local Velocity = require("components.velocity")
local GoID = require("components.go_id")

local MovementSystem = tiny.processingSystem()

function MovementSystem:filter(entity)
	return entity[Position] and entity[Velocity]
end

function MovementSystem:process(entity, dt)
	entity[Position].x = entity[Position].x + entity[Velocity].x * dt
	entity[Position].y = entity[Position].y + entity[Velocity].y * dt

	go.set(entity[GoID], "position", vmath.vector3(entity[Position].x, entity[Position].y, 0))
end

return MovementSystem