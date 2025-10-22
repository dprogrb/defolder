-- modules/input_handler.lua
local M = {} -- Создаем модуль как таблицу
local SMOOTHING = 10 -- Скорость сглаживания движения (чем больше, тем резче)

-- КОНСТАНТЫ ХЭШЕЙ (вычисляются один раз при загрузке модуля)
local HASH_UP = hash("up")
local HASH_DOWN = hash("down")
local HASH_LEFT = hash("left")
local HASH_RIGHT = hash("right")
local HASH_W = hash("w")
local HASH_A = hash("a")
local HASH_S = hash("s")
local HASH_D = hash("d")
local HASH_PAUSE = hash("pause")
local HASH_INTERACT = hash("interact")

-- Аналогия: Как блокнот, где input_handler записывает:
-- "Какие кнопки сейчас нажаты" → key_state
-- "Куда должен двигаться персонаж" → movement
-- "Что игрок хочет сделать прямо сейчас" → actions
M.key_state = {} -- Какие клавиши сейчас зажаты
M.movement = vmath.vector3() -- Финальный вектор движения (с сглаживанием)
M.smoothed_movement = vmath.vector3() -- Промежуточный вектор для сглаживания
M.aim_direction = vmath.vector3(1, 0, 0) -- Куда смотрит персонаж (по умолчанию вправо)
M.actions = { pause = false, interact = false } -- Одноразовые события

-- Что делает process_input()
-- Запоминает состояние клавиш: W нажата = key_state[HASH_W] = true
-- Обрабатывает одноразовые события: Пауза нажата = actions.pause = true
-- Аналогия: Как секретарь, который записывает "Звонил Блинчик в 14:30, просил перезвонить"
function M.process_input(action_id, action)
	-- Обновляем состояние всех клавиш (нажата/отпущена)
	if action.pressed then
		M.key_state[action_id] = true -- Клавиша нажата
	elseif action.released then
		M.key_state[action_id] = false -- Клавиша отпущена
	end

	-- Обрабатываем специальные одноразовые действия (только при нажатии)
	if action_id == HASH_PAUSE and action.pressed then
		M.actions.pause = true -- Игрок хочет переключить паузу
	elseif action_id == HASH_INTERACT and action.pressed then
		M.actions.interact = true -- Игрок хочет взаимодействовать с объектом
	end
end

-- Переводчик движения compute_raw_movement()
-- Что делает:
-- Читает состояние клавиш и превращает их в вектор направления
-- Нормализует вектор, чтобы диагональное движение не было быстрее
-- Примеры результатов:
-- W нажата → (0, 1, 0) — вверх
-- W + D нажаты → (0.707, 0.707, 0) — вверх-вправо с нормальной скоростью
-- Ничего не нажато → (0, 0, 0) — стоим
local function compute_raw_movement()
	local mv = vmath.vector3() -- Создаем пустой вектор (0, 0, 0)
	-- Проверяем нажатие клавиш движения вверх (стрелка или W)
	if M.key_state[HASH_UP] or M.key_state[HASH_W] then 
		mv.y = mv.y + 1  -- Добавляем движение вверх
	end
	-- Проверяем нажатие клавиш движения вниз (стрелка или S)
	if M.key_state[HASH_DOWN] or M.key_state[HASH_S] then 
		mv.y = mv.y - 1  -- Добавляем движение вниз
	end
	-- Проверяем нажатие клавиш движения влево (стрелка или A)
	if M.key_state[HASH_LEFT] or M.key_state[HASH_A] then 
		mv.x = mv.x - 1  -- Добавляем движение влево
	end
	-- Проверяем нажатие клавиш движения вправо (стрелка или D)
	if M.key_state[HASH_RIGHT] or M.key_state[HASH_D] then
		mv.x = mv.x + 1  -- Добавляем движение вправо
	end

	-- Если есть движение в любом направлении, нормализуем вектор
	if vmath.length(mv) > 0 then
		mv = vmath.normalize(mv) -- Приводим длину к 1, чтобы диагональ не была быстрее
	end
	return mv -- Возвращаем направление движения (-1 до 1 по каждой оси)
end

-- Что делает:
-- Получает желаемое направление от compute_raw_movement()
-- Плавно переходит от текущего движения к желаемому
-- SMOOTHING = 10 — скорость перехода (больше = резче)
-- Аналогия: Как рулевое управление автомобиля — вы резко поворачиваете руль, но машина поворачивает плавно
function M.update(dt)
	local target = compute_raw_movement() -- Куда ХОТИМ двигаться
	-- Выполняем сглаживание движения
	M.smoothed_movement = vmath.lerp( -- Плавно переходим
	math.min(dt * SMOOTHING, 1), -- Коэффициент интерполяции с защитой от лагов
	M.smoothed_movement, -- От текущего движения
	target -- К желаемому
)
M.movement = M.smoothed_movement -- Сохраняем результат
end

-- PUBLIC API — интерфейс для внешнего мира
-- function M.get_movement()    -- Возвращает финальный вектор движения
-- function M.get_aim_direction() -- Возвращает направление взгляда
-- function M.get_actions()     -- Возвращает одноразовые события
-- function M.reset_actions()   -- Сбрасывает события после обработки
-- Что делает: Предоставляет чистый интерфейс для других частей игры

-- Возвращает текущий сглаженный вектор движения для применения к персонажу
function M.get_movement()
return M.movement
end

-- Возвращает направление, куда смотрит персонаж (используется для анимаций/стрельбы)
function M.get_aim_direction()
return M.aim_direction
end

-- Сбрасывает все одноразовые события в false (вызывается каждый кадр после обработки)
function M.reset_actions()
M.actions.pause = false -- Событие "пауза" обработано
M.actions.interact = false -- Событие "взаимодействие" обработано
end

-- Возвращает таблицу с текущими одноразовыми событиями
function M.get_actions()
return M.actions
end

-- Экспортируем модуль для использования в других файлах
return M
