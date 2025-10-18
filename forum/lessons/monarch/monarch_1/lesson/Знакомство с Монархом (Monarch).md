Это второе вложение темы "Знакомство с Монархом в Defold. Переходы в главное меню/игру/игровая пауза(попап)" на форуме defolder.com

Рекомендую ознакомиться с первым вложением этого урока: https://defolder.com/t/znakomstvo-s-monarhom-v-defold-perehody-v-glavnoe-menyu-igru-igrovaya-pauza-popap/100


## План работ

Создать сцену для главного меню.

Создать сцену для игры.

Создать сцену для игрового меню.

Создать gui-макеты для каждой сцены.

Реализовать переключение между сценами, используя Монарх и GUI-узлы.
- Переход с сцены **main_menu** в **game**.
- Открытие **game_pause**.
- Переход с **game_pause** в **main_menu** и **game**.

Создадим для каждой сцены шаблон из файлов:

<img src="/lesson/png/1.png">


У вас должно получиться вот так:

<img src="/lesson/png/2.png">


Кликните по `game.collection` и **collection**, задайте имя **game**:

<img src="/lesson/png/3.png">

Для других коллекций сделайте аналогичные действия:

<img src="/lesson/png/4.png">

<img src="/lesson/png/5.png">

Создадим GUI макеты.

Для начала перейдём в `game.project` и узнаем заданные настройки ширины и высоты экрана:
<img src="/lesson/png/6.png">

Теперь создадим корневой узел для макета в `main_menu.gui` (в следующий раз я не буду упоминать это действие):

<img src="/lesson/png/7.png">

Дадим её имя "**root**" и выставим такие значения:

<img src="/lesson/png/8.png">

Посмотрите, теперь наш корневой узел расположен по всему экрану:

<img src="/lesson/png/9.png">

Это необязательно, но можно ещё установить и **Stretch** в **Adjust Mode**:

<img src="/lesson/png/10.png">

Теперь в наш **root** поместим шаблон кнопки из папки `gui/templates/button.gui`:

<img src="/lesson/png/11.png">

<img src="/lesson/png/12.png">

Изменим ей **id** на **button_start** (для удобства):

<img src="/lesson/png/13.png">


Создадим в папке **controller** скрипт `controller.script`:

<img src="/lesson/png/14.png">

<img src="/lesson/png/15.png">

Перейдём в `controller.collection` и создадим там игровой объект и затем переименуем его на **controller**:

<img src="/lesson/png/16.png">

<img src="/lesson/png/17.png">

Добавим компонент `controller.script`:

<img src="/lesson/png/18.png">

<img src="/lesson/png/19.png">

В этой же коллекции controller.collection создадим игровой объект с id **main_menu**:

<img src="/lesson/png/20.png">

В этом игровом объекте мы создадим компонент **Collection Proxy** (Прокси Коллекцию):

<img src="/lesson/png/21.png">

В качестве коллекции в этом компоненте укажем коллекцию `main_menu.collection`:

<img src="/lesson/png/22.png">

<img src="/lesson/png/23.png">

Переименуем её на `main_menu_proxy` (для удобства):

<img src="/lesson/png/24.png">

Тем же способом, которым мы добавили в игровой объект компонент `controller.script`, добавим скрипт монарха **screen_proxy**:

<img src="/lesson/png/25.png">

В свойствах этого скрипта мы внесём изменения.

В параметр **screen_proxy** зададим имя нашей прокси-коллекции — `main_menu_proxy`.

В параметр **screen_id** зададим значения **main_menu**. С помощью этого имени мы будем обращаться к этой прокси при работе с API Монарха.

<img src="/lesson/png/26.png">

Перейдём в `controller.script` и вставим такой код:
~~~ LUA
-- controller.script

local monarch = require "monarch.monarch" -- [1]

function init(self) -- [2]
	msg.post(".", "acquire_input_focus") -- [3]
	msg.post("#", "start_main_menu") [] -- [4]

end

function on_message(self, message_id, message, sender) -- [5]
	if message_id == hash("start_main_menu") then -- [6]
		monarch.show(hash("main_menu")) -- [7]
	end
end

~~~

Сохраним проект `(ctrl + S)`.

Соберем и запустим проект `(ctrl + B)`:

<img src="/lesson/png/27.png">

Постараюсь объяснить по простому:
1.  Делаем возможным использовать код, расположенный в этой папке:
<img src="/lesson/png/28.png">
2. Функция, которая начинает своё выполнение кода, только в процессе создания игрового объекта.
3. Отправляем сообщение игре: "Считывай данные с устройств ввода". Как пример, с мыши или клавиатуры. Т.е если я кликаю на клавишу мыши или набираю что-то на клавиатуре, то компьютер это обрабатывает.
4. Отправляем сообщение в этот же скрипт (для этого указана `"#"`, чтобы скрипт обработал его).
5.  Функция для обработки сообщений, поступающих в этот скрипт (у нас это `controller.script`).
6. Проверяем, если пришло сообщение с хэшем `hash("start_main_menu")`.
7. Используем функцию из файла monarch.lua (модуля), чтобы показать сцену main_menu (мы указывали в screen_proxy screen_id):
<img src="/lesson/png/29.png">

Если привести аналогию с человеком.
Человек спит.
Во время пробуждения он говорит себе: "Я могу работать".
А потом говорит себе: "Отрой глаза" и с помощью функции глаз он открывает глаза.

Если вы зайдёте в `monarch.lua`, то увидите созданную там функцию **show**, которая позволяет открыть прокси-коллекцию:

<img src="/lesson/png/30.png">

Давайте внесём изменения в `main_menu.gui`, изменим цвет корневому узлу:

<img src="/lesson/png/31.png">

Теперь сохраним проект и снова его запустим:

<img src="/lesson/png/32.png">

Вы также можете изменить текст для текстового узла кнопки здесь:

<img src="/lesson/png/33.png">

Скрывать узлы с помощью свойства параметра:

<img src="/lesson/png/34.png">


Теперь создайте подобным образом другие сцены: **game**, **game_pause**:

Макет сцены **game**:

<img src="/lesson/png/35.png">

<img src="/lesson/png/36.png">

Макет `game_pause.gui`:

<img src="/lesson/png/37.png">

<img src="/lesson/png/38.png">

В `controller.collection` создайте игровые объекты, содержащие прокси-коллекции и скрипт screen.proxy для остальных сцен:

<img src="/lesson/png/39.png">

Перейдём в `main_menu.gui_script` и вставим такой код:
~~~ Lua
-- main_menu.gui_script

local monarch = require "monarch.monarch"

function init(self)
    self.button_start = gui.get_node("button_start/root")  -- [1]
    self.button_text = gui.get_node("button_start/text") -- [2]
    -- Настраиваем текст кнопки
    gui.set_text(self.button_text, "START") -- [3]
    -- Запрашиваем input focus
    msg.post(".", "acquire_input_focus")
end


function on_input(self, action_id, action)
    if action_id == hash("touch") then
        -- Проверяем клик по кнопке
        if gui.pick_node(self.button_start, action.x, action.y) then -- [4]
            if action.pressed then -- [5]
                gui.set_scale(self.button_start, vmath.vector3(0.97, 0.97, 1)) -- [6]
            elseif action.released then -- [7]
                gui.animate(self.button_start, gui.PROP_SCALE, 
                vmath.vector3(1.03, 1.03, 1), 
                gui.EASING_INOUTQUAD,
                0.3, 0, 
                function()
                    -- Вернем масштаб после анимации и переключим окно
                    gui.set_scale(self.button_start, vmath.vector3(1, 1, 1))
                    monarch.show(hash("game"))
                end,
                gui.PLAYBACK_ONCE_PINGPONG
            ) -- [8]
            end
            return true  -- [9]
        end
    end

end

~~~

1. Получаем **id** узла и записываем его в переменную `self.button_start`.
2. Получаем **id** узла и записываем его в переменную `self.button_text`.
3. Устанавливаем свойство **text** равное "START" текстовому узлу, ссылающемуся на значение, хранящиеся в переменной `self.button_text`.
4. Если кликнули по узлу `button_start/root` (значение хранится в `self.button_start`) был совершен `"touch"`, то выполни определенные команды.
5. Если клавиша из **game.input_binding** `(touch)` была нажата.
6. Измени масштаб коревому узлу кнопки.
7. Если клавиша из **input_binding** `(touch)` была отпущена.
8. Проиграй анимацию для кнопки.
9. Прекращай обрабатывать этот **actions(touch)**.

После клика на кнопку **"START"** вы переходите на коллекцию `game.collection`:
<img src="/lesson/gif/gif_2.gif">

Теперь перейдём в файл `input_binding` и добавим новую привязку ввода:

<img src="/lesson/png/40.png">

<img src="/lesson/png/41.png">

В game.gui_script добавим такой код:
~~~ Lua
-- game.gui_script

local monarch = require "monarch.monarch"

function init(self)
    msg.post(".", "acquire_input_focus")
end

function on_input(self, action_id, action)
    if action_id == hash("esc") and action.pressed then -- 1
        monarch.show(hash("game_pause"), {no_stack = true}) -- 2
    end
end
~~~

1. Если была нажат клавиша с привязкой на esc.
2. Показываем сцену монарха, не помещая его в стек вызовов монарха.

Сохраним и запустим проект, нажмём на клавишу "ESC" на клавиатуре:
<img src="/lesson/gif/gif_3.gif">

Теперь перейдём в `game_pause.gui_script` и вставим такой туда код:
~~~ Lua
local monarch = require "monarch.monarch"

function init(self)
	-- Получаем узлы 
	self.button_continue_root = gui.get_node("button_continue/root")  -- root кнопки
	self.button_continue_text = gui.get_node("button_continue/text") -- text кнопки
	self.button_to_menu_root = gui.get_node("button_to_menu/root")  -- root кнопки
	self.button_to_menu_text = gui.get_node("button_to_menu/text") -- text кнопки
	-- Настраиваем текст кнопки
	gui.set_text(self.button_continue_text, "CONTINUE")
	gui.set_text(self.button_to_menu_text, "MENU")
	-- Запрашиваем input focus
	msg.post(".", "acquire_input_focus")
end

function on_input(self, action_id, action)
	if action_id == hash("esc") and action.pressed then
		monarch.hide(hash("game_pause")) -- [1]
	end
	if action_id == hash("touch") then
		-- Проверяем клик по кнопке
		if gui.pick_node(self.button_continue_root, action.x, action.y) then
			--print("Button picked!")
			if action.pressed then
				gui.set_scale(self.button_continue_root, vmath.vector3(0.97, 0.97, 1))
			elseif action.released then
				gui.animate(self.button_continue_root, gui.PROP_SCALE, 
				vmath.vector3(1.03, 1.03, 1), 
				gui.EASING_INOUTQUAD, 0.3, 0, 
				nil, gui.PLAYBACK_ONCE_PINGPONG)
				gui.set_scale(self.button_continue_root, vmath.vector3(1, 1, 1))
			end
			monarch.hide(hash("game_pause")) -- [1]
			return true  -- Потребляем input
		end

		if gui.pick_node(self.button_to_menu_root, action.x, action.y) then
			if action.pressed then
				gui.set_scale(self.button_to_menu_root, vmath.vector3(0.97, 0.97, 1))
			elseif action.released then
				gui.animate(self.button_to_menu_root, gui.PROP_SCALE, 
				vmath.vector3(1.03, 1.03, 1), 
				gui.EASING_INOUTQUAD, 0.3, 0, 
				nil, gui.PLAYBACK_ONCE_PINGPONG)
				gui.set_scale(self.button_to_menu_root, vmath.vector3(1, 1, 1))
			end
			-- Закрываем game_pause
			monarch.hide(hash("game_pause")) -- [1]
			monarch.show(hash("main_menu"), { clear = true }) -- [2]
			return true  -- Потребляем input
		end
	end
end
~~~

1. `monarch.hide(hash("game_pause"))` закроет попап, показанный с `no_stack`.
2. `monarch.show(hash("main_menu"), { clear = true })` удалит все экраны из стека и покажет `main_menu`.
   
Сохраняем и запускаем проект:
<img src="/lesson/gif/gif_4.gif">

