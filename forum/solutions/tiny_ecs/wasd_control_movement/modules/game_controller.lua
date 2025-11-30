-- Управляет всеми системами
local tiny = require("tinyecs.tiny")
local InputSystem = require("systems.InputSystem")
local MovementSystem = require("systems.MovementSystem")
local InputHandler = require("modules.input_handler")
local EntityFactory = require("modules.entity_factory")

local GameController = {}


function GameController.new()
	-- print("InputSystem type:", type(InputSystem))
	-- print("MovementSystem type:", type(MovementSystem))
	
	local instance = {}

	instance.world = tiny.world(InputSystem, MovementSystem)	

	instance.player = EntityFactory.create_player(
		instance.world,
		640,
		360,
		"#sprite"
	)

	print("Game initialized!")

	function instance:update(dt)
		self.world:update(dt)
	end

	function instance:on_input(action_id, action)
		InputHandler.process_input(action_id, action)
	end

	return instance
end

return GameController  