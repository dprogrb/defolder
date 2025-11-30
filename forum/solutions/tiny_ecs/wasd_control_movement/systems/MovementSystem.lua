local tiny = require("tinyecs.tiny")
local Position = require("components.Position")
local Velocity = require("components.Velocity")
local GoID = require("components.GoID")

local MovementSystem = tiny.processingSystem()

local ARENA_LEFT = 0
local ARENA_RIGHT = 960
local ARENA_TOP = 640
local ARENA_BOTTOM = 0

function MovementSystem:filter(entity)
	return entity[Position] and entity[Velocity] and entity[GoID]
end

-- В MovementSystem:
function MovementSystem:process(entity, dt)
	local pos = entity[Position]
	local vel = entity[Velocity]
	local go_id = entity[GoID]

	if not go_id or not go_id.id then return end

	pos.x = pos.x + vel.x * dt
	pos.y = pos.y + vel.y * dt

	pos.x = self:clamp(pos.x, ARENA_LEFT, ARENA_RIGHT)
	pos.y = self:clamp(pos.y, ARENA_BOTTOM, ARENA_TOP)

	go.set(".", "position", vmath.vector3(pos.x, pos.y, 0))
end


function MovementSystem:clamp(value, min_val, max_val)
	return math.max(min_val, math.min(max_val, value))
end
	
return MovementSystem