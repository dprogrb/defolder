Молодец, что продолжаешь изучать Defold!

Да, я буду это повторять из урока в урок!

Ассет краба взят из с этого сайта: https://camacebra.itch.io/crab-pixel-art

--- 


За теоретическую основу был взят этот пост: https://defolder.com/t/matematika-v-defold-chast-2-ejlery-radiany-i-kvaterniony-vrashhenie-obektov-v-tryohmernom-prostranstve/55?u=d_bl1n
Настоятельно рекомендую ознакомиться с этим материалом.


Запустите проект (ctrl + B).

Краб смотрит "наверх".

Давайте изменим поворот игровому объекту:

~~~ Lua
function init(self)
	go.set(".", "euler.z", 120) --задаём свойство объекта "поворот по оси z" на значение 120
end
~~~

Давайте "анимируем" игровой объект, обратившись к свойству "euler.z"
~~~ Lua
function init(self)
	go.animate(".", "euler.z", go.PLAYBACK_LOOP_FORWARD, -360, go.EASING_LINEAR, 2)
end
~~~

Игровой объект поворачивается в сторону курсора мыши:
~~~ Lua
function init(self)
	msg.post(".", "acquire_input_focus")
end

function on_input(self, action_id, action)
	if not action_id then
		local cursor_pos = vmath.vector3(action.x, action.y, 0)
		local pos = go.get_position()
		local angle = math.atan2(pos.x-cursor_pos.x, cursor_pos.y-pos.y)
		go.set_rotation(vmath.quat_rotation_z(angle))
	end
end
~~~

Пример 1: Спиннер (волчок)
Цель: Научиться создавать бесконечно вращающийся объект.

~~~ Lua
function init(self)
	-- Запускаем бесконечное вращение
	-- 360 градусов = полный оборот против часовой стрелки
	go.animate(".", "euler.z", go.PLAYBACK_LOOP_FORWARD, -360, go.EASING_LINEAR, 2.0)
	-- Время: 2 секунды на один полный оборот
	msg.post(".", "acquire_input_focus")
end

function on_input(self, action_id, action)
	if action_id == hash("space") and action.pressed then
		print("fddf")
		-- Остановить и ускорить
		go.cancel_animations(".", "euler.z")

		go.animate(".", "euler.z", go.PLAYBACK_LOOP_FORWARD, -3600, go.EASING_LINEAR, 1.0)
		-- Теперь 10 оборотов за 1 секунду! 
	end
end
~~~

Пример 6: Вращение вокруг центра (орбита)

Цель: Объект вращается вокруг другого объекта, как планета вокруг звезды.

~~~ Lua
-- orbiter.script
function init(self)
	self.orbit_center = go.get_position()
	self.orbit_radius = 100  -- расстояние от центра
	self.orbit_angle = 0     -- текущий угол на орбите
	self.orbit_speed = 90    -- градусов в секунду
end

function update(self, dt)
	-- Увеличиваем угол орбиты
	self.orbit_angle = self.orbit_angle + self.orbit_speed * dt

	-- Нормализуем угол (чтобы не рос до бесконечности)
	self.orbit_angle = self.orbit_angle % 360

	-- Вычисляем позицию на орбите
	local angle_rad = math.rad(self.orbit_angle)
	local orbit_x = self.orbit_center.x + math.cos(angle_rad) * self.orbit_radius
	local orbit_y = self.orbit_center.y + math.sin(angle_rad) * self.orbit_radius

	-- Устанавливаем новую позицию
	local pos = vmath.vector3(orbit_x, orbit_y, go.get_position().z)
	go.set_position(pos)

	-- Опционально: поворачиваем объект лицом вверх
	go.set(".", "euler.z", self.orbit_angle)
end
~~~

Пример 8: Маятник (колебание)

Цель: Объект качается влево-вправо.

~~~ Lua
-- pendulum.script
function init(self)
	self.time = 0
	self.amplitude = 45      -- максимальный угол (±45°)
	self.frequency = 2       -- колебаний в секунду
end

function update(self, dt)
	self.time = self.time + dt

	-- Вычисляем угол с помощью синуса (гладкое колебание)
	local angle = self.amplitude * math.sin(2 * math.pi * self.frequency * self.time)

	go.set(".", "euler.z", angle)
end
~~~