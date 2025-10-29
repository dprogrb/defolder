local M = {}

local key_state = {}

function M.process_input(action_id, action)
	if action.pressed then
		key_state[action_id] = true
	end
	if action.released then
		key_state[action_id] = false
	end
end

function M.get_key_state_table()
	return key_state
end

return M