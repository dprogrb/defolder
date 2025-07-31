-- Создаём модуль для управления состояниями игры
local M = {}

-- Определяем начальное состояние игры как "main_menu"
-- Возможные состояния: "main_menu" (главное меню), "playing" (игра активна), "paused" (игра на паузе)
M.state = "main_menu"

-- Функция для установки нового состояния игры
function M.set_state(new_state)
	-- Если устанавливается состояние "paused" (пауза)
	if new_state == "paused" then
		-- Отправляем сообщение объекту "controller:/controller" для установки временного шага в 0 (пауза физики/анимации)
		-- factor = 0 останавливает обновление, mode = 1 указывает на непрерывный режим
		msg.post("controller:/controller", "set_time_step", { factor = 0, mode = 1 })
		-- Выводим отладочное сообщение с новым состоянием
		print("GAME_STATE: " .. new_state)
		-- Если устанавливается состояние "playing" (игра активна)
	elseif new_state == "playing" then
		-- Отправляем сообщение для установки временного шага в 1 (нормальное обновление игры)
		msg.post("controller:/controller", "set_time_step", { factor = 1, mode = 1 })
		-- Выводим отладочное сообщение с новым состоянием
		print("GAME_STATE: " .. new_state)
		-- Если устанавливается состояние "main_menu" (главное меню)
	elseif new_state == "main_menu" then
		-- Никаких дополнительных сообщений не отправляем, только логируем
		print("GAME_STATE: " .. new_state)
	end
	-- Обновляем текущее состояние модуля
	M.state = new_state
end

-- Функция для получения текущего состояния игры
function M.get_state()
	-- Возвращаем текущее значение M.state
	return M.state
end

-- Функция проверки, находится ли игра в состоянии "main_menu"
function M.is_main_menu()
	-- Возвращает true, если текущее состояние — "main_menu", иначе false
	return M.state == "main_menu"
end

-- Функция проверки, находится ли игра в состоянии "playing"
function M.is_playing()
	-- Возвращает true, если текущее состояние — "playing", иначе false
	return M.state == "playing"
end

-- Функция проверки, находится ли игра на паузе
function M.is_paused()
	-- Возвращает true, если текущее состояние — "paused", иначе false
	return M.state == "paused"
end

-- Функция для перехода в главное меню
function M.to_main_menu()
	-- Устанавливаем состояние "main_menu" через set_state
	M.set_state("main_menu")
end

-- Функция для начала игры
function M.start_game()
	-- Устанавливаем состояние "playing" через set_state
	M.set_state("playing")
end

-- Функция для постановки игры на паузу
function M.pause()
	-- Проверяем, что игра в состоянии "playing", чтобы избежать паузы из других состояний
	if M.is_playing() then
		-- Устанавливаем состояние "paused" через set_state
		M.set_state("paused")
	end
end

-- Функция для возобновления игры
function M.resume()
	-- Проверяем, что игра в состоянии "paused", чтобы возобновить только из паузы
	if M.is_paused() then
		-- Устанавливаем состояние "playing" через set_state
		M.set_state("playing")
	end
end

-- Функция для переключения между паузой и игрой
function M.toggle_pause()
	-- Если игра на паузе, возобновляем её
	if M.is_paused() then
		M.resume()
		-- Если игра активна, ставим на паузу
	elseif M.is_playing() then
		M.pause()
	end
end

-- Возвращаем модуль для использования в других скриптах
return M