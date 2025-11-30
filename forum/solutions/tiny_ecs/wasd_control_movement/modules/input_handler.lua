local M = {}

local key_state = {}

function M.process_input(action_id, action)
	if action.pressed then
		key_state[action_id] = true
	elseif action.released then
		key_state[action_id] = false
	end
end

function M.get_key_state()
	return key_state
end

function M.reset_key_state()
	key_state = {}
end
	
return M