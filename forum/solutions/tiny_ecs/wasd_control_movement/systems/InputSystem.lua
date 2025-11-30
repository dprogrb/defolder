-- Преобразует ввод в Velocity

local tiny = require("tinyecs.tiny")
local Velocity = require("components.Velocity")
local PlayerData = require("components.PlayerData")
local Input = require("components.Input")
local InputHandler = require("modules.input_handler")

local InputSystem = tiny.processingSystem()

function InputSystem:filter(entity)
	return entity[PlayerData] and entity[Velocity] and entity[Input]
end

function InputSystem:process(entity, dt)
	-- Считываем ввод
	local key_state = InputHandler.get_key_state()

	-- Вычисляем направление
	local direction = self:compute_direction(key_state)

	-- Обновляем Velocity
	entity[Velocity].x = direction.x * entity[PlayerData].moveSpeed
	entity[Velocity].y = direction.y * entity[PlayerData].moveSpeed
end

function InputSystem:compute_direction(key_state)
	local vm = vmath.vector3()

	if key_state[hash("down")] then
		vm.y = vm.y - 1
	end
	if key_state[hash("up")] then
		vm.y = vm.y + 1
	end
	if key_state[hash("left")] then	
		vm.x = vm.x - 1
	end
	if key_state[hash("right")] then
		vm.x = vm.x + 1
	end

	-- Нормализуем
	if vmath.length(vm) > 1 then
		vm = vmath.normalize(vm)
	end

	return vm
end

return InputSystem