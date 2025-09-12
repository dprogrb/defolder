local M = {}
-- Загрузка и парсинг JSON файла из ресурсов по пути "/assets/json/card_data.json"
local json_text = sys.load_resource("/assets/json/card_data.json")
if json_text then
	-- Парсим JSON текст в Lua таблицу и сохраняем в M.cards
	M.cards = json.decode(json_text)
else
	-- Если файл не загружен, выводим сообщение об ошибке и инициализируем пустую таблицу
	print("Ошибка загрузки JSON файла")
	M.cards = {}
end

-- Инициализация текущего индекса карты (по умолчанию 5)
M.current_index = 5

-- Функция возвращает текущую карту из списка по индексу
function M.get_current_card()
	return M.cards[M.current_index]
end

-- изменяем изображение спрайта для текущей карты
function M.update_sprite(go_url)
	local card = M.get_current_card()
	if card and card.image then
		-- Убираем расширение .png из имени файла для flipbook
		local anim_id = hash(card.image:gsub("%.png$", ""))
		-- Отправляем сообщение игровому объекту-спрайту сменить анимацию
		msg.post(go_url, "play_animation", { id = anim_id })
	end
end

-- Функция изменения description для текущей карты
function M.update_description(go_url)
	local card = M.cards[M.current_index]
	msg.post(go_url, "update_description", {description = card.description})
end

-- Функция изменения title для текущей карты
function M.update_title(go_url)
	local card = M.cards[M.current_index]
	msg.post(go_url, "update_title", {title = card.title})
end

-- Функция меняет текущую карту при свайпе влево или вправо
-- direction: "left" или "right" - направление свайпа
function M.swipe_change(direction)
	if direction == "right" then
		M.current_index = M.current_index + 1 -- сдвигаем индекс карты вправо
		if M.current_index > #M.cards then
			-- Если индекс превысил количество карт, ограничиваем последний элемент
			-- Чтобы зациклить, можно раскомментировать строку ниже
			-- M.current_index = 1 -- переход к первой карте
			M.current_index = #M.cards -- оставляем последний индекс
		end
	elseif direction == "left" then
		M.current_index = M.current_index - 1 -- сдвигаем индекс карты влево
		if M.current_index < 1 then
			-- Если индекс стал меньше 1, ограничиваем первый элемент
			-- Для зацикливания можно раскомментировать строку ниже
			-- M.current_index = #M.cards -- переход к последней карте
			M.current_index = 1 -- остаемся на первой карте
		end
	end
	-- Выводим в консоль текущую карту для отладки
	pprint(M.cards[M.current_index])
end

return M
