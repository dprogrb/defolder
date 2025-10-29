local M = {}


local HASH_UP = hash("up")
local HASH_DOWN = hash("down")
local HASH_LEFT = hash("left")
local HASH_RIGHT = hash("right")

local vm = vmath.vector3()

function M.compute_raw_movement(key_state)
	if key_state[HASH_UP] then
		vm.y = vm.y + 1
	end
	if key_state[HASH_DOWN] then
		vm.y = vm.y - 1
	end
	if key_state[HASH_RIGHT] then
		vm.x = vm.x + 1
	end
	if key_state[HASH_LEFT] then
		vm.x = vm.x - 1
	end

	if vmath.length(vm) > 1 then
		vm = vmath.normalize(vm)
	end
end

function M.update(self, dt)
	local pos = go.get_position(self.url_player)
	go.set_position(pos + vm * self.speed * dt, self.url_player)

	vm = vmath.vector3()
end

return M