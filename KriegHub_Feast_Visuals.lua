local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local HttpService  = game:GetService("HttpService")
local LP = Players.LocalPlayer
local Krieg = {
Flags = {},
Connections = {},
ThemeMap = {},
ThemeList = {},
CurrentTheme = "New Year",
ToggleKey = Enum.KeyCode.RightControl,
ConfigFolder = "KriegHub",
ParticlesOn = true,
UserScale = 1,
}
local WHITE, BLACK = Color3.new(1, 1, 1), Color3.new(0, 0, 0)
local FS_OK = typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function"
local Store = {
dir = "KriegHub",
file = "KriegHub/ui.json",
data = {
Theme = "New Year", Accent = false, TextColor = "Auto",
Font = "Gotham", FontCustom = "", Lang = "English",
Wallpaper = "", WallDim = 0.45, WallMini = true, PanelAlpha = 0,
Particles = true, Density = 1, Notifs = true, Key = "RightControl", Scale = 1, TextScale = 1,
AutoRun = false,
ThemeWall = true,
MiniBar = true, MiniPos = "Top", MiniFps = true, MiniPing = true, MiniClock = true, MiniClose = true,
Ver = 0,
},
}
local S = Store.data
do
local queued = false
function Store.ensureDir()
pcall(function()
if typeof(isfolder) == "function" and typeof(makefolder) == "function" and not isfolder(Store.dir) then
makefolder(Store.dir)
end
end)
end
function Store.load()
if not FS_OK then return end
pcall(function()
if not isfile(Store.file) then return end
local d = HttpService:JSONDecode(readfile(Store.file))
if type(d) ~= "table" then return end
for k, v in pairs(d) do
if S[k] ~= nil and (type(v) == type(S[k]) or k == "Accent" or k == "TextColor") then S[k] = v end
end
end)
end
function Store.save()
if not FS_OK or queued then return end
queued = true
task.delay(.6, function()
queued = false
pcall(function()
Store.ensureDir()
writefile(Store.file, HttpService:JSONEncode(S))
end)
end)
end
function Store.set(k, v)
S[k] = v
Store.save()
end
end
Store.load()
if S.Ver < 3 then
S.Theme = "New Year"
S.Ver = 3
Store.save()
end
local Lang = {
cur = "English",
list = { "English", "Русский", "Қазақша" },
dict = {
["Русский"] = {
["Halloween"] = "Хэллоуин",
["Basic"] = "Базовый",
["New Year"] = "Новый год",
["Rain"] = "Дождь",
["Summer"] = "Лето",
["Spring"] = "Весна",
["Autumn"] = "Осень",
["Sakura"] = "Сакура",
["Valentine"] = "Валентин",
["Clean and simple"] = "Чисто и просто",
["Spooky season"] = "Жуткий сезон",
["Snow and lights"] = "Снег и огоньки",
["Calm and cozy"] = "Тихо и уютно",
["Sun and sea"] = "Солнце и море",
["Fresh and green"] = "Свежо и зелено",
["Falling leaves"] = "Падающие листья",
["Cherry blossom"] = "Цветение сакуры",
["Love is in the air"] = "Любовь витает в воздухе",
["Find a section..."] = "Найти раздел...",
["press"] = "нажми",
["none"] = "нет",
["Filter by name"] = "Поиск по нику",
["Server is empty for now"] = "На сервере пока никого",
["Paste a link first"] = "Сначала вставь ссылку",
["This is not a link"] = "Это не ссылка",
["Your executor can't load images from links"] = "Твой экзекутор не умеет грузить картинки по ссылке",
["Could not download the image"] = "Не удалось скачать картинку",
["GIF is not supported, use PNG or JPG"] = "GIF не поддерживается, используй PNG или JPG",
["The link is not a PNG or JPG image"] = "Ссылка ведёт не на PNG или JPG",
["Could not save the image"] = "Не удалось сохранить картинку",
["close"] = "закрыть",
["Overview"] = "Обзор",
["Home"] = "Главная",
["Round"] = "Раунд",
["Murderer"] = "Убийца",
["Sheriff"] = "Шериф",
["World"] = "Мир",
["Visuals"] = "Визуалы",
["Teleport"] = "Телепорт",
["Farming"] = "Фарм",
["You"] = "Ты",
["Character"] = "Персонаж",
["Emotes"] = "Эмоции",
["Fun"] = "Приколы",
["NEW"] = "НОВОЕ",
["Social"] = "Общение",
["Chat"] = "Чат",
["Music"] = "Музыка",
["Community"] = "Сообщество",
["System"] = "Система",
["Configs"] = "Конфиги",
["Mobile"] = "Телефон",
["Server"] = "Сервер",
["Settings"] = "Настройки",
["Welcome back"] = "С возвращением",
["Profile"] = "Профиль",
["days"] = "дн.",
["KRIEG MEMBER"] = "УЧАСТНИК KRIEG",
["Live"] = "В реальном времени",
["Updates every half second"] = "Обновляется каждые полсекунды",
["FPS"] = "FPS",
["Ping"] = "Пинг",
["Players"] = "Игроки",
["Session"] = "Сессия",
["Season"] = "Сезон",
["Pick a style for the whole menu"] = "Выбери стиль для всего меню",
["Changelog"] = "Что нового",
["Live scenes for every style"] = "Живые сцены для каждого стиля",
["Your own wallpaper"] = "Свои обои",
["15 fonts and 3 languages"] = "15 шрифтов и 3 языка",
["Settings are saved"] = "Настройки сохраняются",
["UI"] = "UI",
["Smaller, cleaner window"] = "Окно меньше и аккуратнее",
["Tools for when you hold the knife"] = "Инструменты, когда у тебя нож",
["Knife"] = "Нож",
["Throw"] = "Бросок",
["Cosmetic"] = "Косметика",
["Close range"] = "Ближний бой",
["Reach"] = "Дальность удара",
["Longer knife hit range"] = "Нож бьёт дальше",
["Reach distance"] = "Дистанция удара",
["Quick equip"] = "Быстро достать",
["Pull out the knife instantly"] = "Мгновенно достаёт нож",
["Alerts"] = "Оповещения",
["Sheriff nearby"] = "Шериф рядом",
["Warns when the sheriff is close"] = "Предупреждает, когда шериф близко",
["Round start sound"] = "Звук начала раунда",
["Throwing"] = "Метание",
["Throw assist"] = "Помощь при броске",
["Priority"] = "Приоритет",
["Nearest"] = "Ближайший",
["Sheriff first"] = "Сначала шериф",
["Hero first"] = "Сначала герой",
["Lowest HP"] = "Меньше всего HP",
["Lead"] = "Упреждение",
["Tip"] = "Подсказка",
["Lead controls how far ahead of a moving target the throw is aimed. Start low and raise it slowly."] = "Упреждение задаёт, насколько впереди движущейся цели целится бросок. Начни с малого и повышай постепенно.",
["Knife trail"] = "След ножа",
["Off"] = "Выкл",
["Ember"] = "Угли",
["Void"] = "Пустота",
["Frost"] = "Иней",
["Toxic"] = "Яд",
["Gold"] = "Золото",
["Aim helpers and gun tools"] = "Помощь в прицеливании и пистолет",
["Aim"] = "Прицел",
["Gun"] = "Пистолет",
["Aim helper"] = "Помощь в прицеливании",
["Soft aim"] = "Мягкий прицел",
["Gently pulls aim to the target"] = "Плавно тянет прицел к цели",
["Smoothness"] = "Плавность",
["FOV"] = "FOV",
["Aim point"] = "Точка прицела",
["Upper body"] = "Верх тела",
["Head"] = "Голова",
["Center"] = "Центр",
["FOV circle"] = "Круг FOV",
["Show circle"] = "Показывать круг",
["Fill circle"] = "Заливка круга",
["Thickness"] = "Толщина",
["Dropped gun"] = "Выпавший пистолет",
["Highlight dropped gun"] = "Подсвечивать пистолет",
["Outline the gun when the sheriff dies"] = "Обводит пистолет, когда шериф умирает",
["Announce drop"] = "Сообщать о выпадении",
["Pick up gun"] = "Подобрать пистолет",
["See more of the round and the map"] = "Больше видишь в раунде и на карте",
["Atmosphere"] = "Атмосфера",
["Highlights"] = "Подсветка",
["Outline players by role"] = "Обводка игроков по роли",
["Enabled"] = "Включено",
["Roles to show"] = "Какие роли показывать",
["Hero"] = "Герой",
["Innocent"] = "Невинный",
["Unknown"] = "Неизвестно",
["Range"] = "Дальность",
["Only visible"] = "Только видимые",
["Labels"] = "Подписи",
["Names"] = "Ники",
["Distance"] = "Расстояние",
["Role tag"] = "Метка роли",
["Highlight style"] = "Стиль подсветки",
["Soft"] = "Мягкий",
["Outline"] = "Контур",
["Neon"] = "Неон",
["Ghost"] = "Призрак",
["Hologram"] = "Голограмма",
["Shadow"] = "Тень",
["Color source"] = "Цвет",
["Role color"] = "Цвет роли",
["Theme accent"] = "Цвет стиля",
["Rainbow"] = "Радуга",
["Lighting"] = "Освещение",
["Bright map"] = "Светлая карта",
["Removes dark shadows"] = "Убирает тёмные тени",
["Clear fog"] = "Убрать туман",
["Clock time"] = "Время суток",
["Color grading"] = "Цветокоррекция",
["Saturation"] = "Насыщенность",
["Contrast"] = "Контраст",
["Weather"] = "Погода",
["Snow"] = "Снег",
["Fog"] = "Туман",
["Storm"] = "Гроза",
["Intensity"] = "Сила",
["Sky"] = "Небо",
["Skybox"] = "Скайбокс",
["Default"] = "Обычный",
["Blood moon"] = "Кровавая луна",
["Night"] = "Ночь",
["Galaxy"] = "Галактика",
["Sunset"] = "Закат",
["Slow sky rotation"] = "Медленное вращение неба",
["Move around the map quickly"] = "Быстро перемещайся по карте",
["Places"] = "Места",
["Lobby"] = "Лобби",
["Map"] = "Карта",
["Spawn"] = "Спавн",
["Safe spot"] = "Безопасное место",
["Travel"] = "Перемещение",
["Method"] = "Способ",
["Smooth"] = "Плавно",
["Instant"] = "Мгновенно",
["Speed"] = "Скорость",
["Go to player"] = "К игроку",
["Coins and progress"] = "Монеты и прогресс",
["Coins"] = "Монеты",
["Coin collector"] = "Сбор монет",
["Collect coins"] = "Собирать монеты",
["Picks up coins around the map"] = "Подбирает монеты по карте",
["Stay away from murderer"] = "Держаться подальше от убийцы",
["Movement"] = "Передвижение",
["Walk"] = "Пешком",
["Safety"] = "Безопасность",
["Anti AFK"] = "Анти-АФК",
["Stop when bag is full"] = "Стоп, когда сумка полная",
["This session"] = "Эта сессия",
["Rounds"] = "Раунды",
["Per hour"] = "В час",
["Reset"] = "Сбросить",
["Movement, physics and protection"] = "Движение, физика и защита",
["Physics"] = "Физика",
["Protection"] = "Защита",
["Walk through walls"] = "Сквозь стены",
["Air jump"] = "Прыжок в воздухе",
["Jump again while in the air"] = "Ещё один прыжок в воздухе",
["Flight"] = "Полёт",
["Bunny hop"] = "Банихоп",
["Wall climb"] = "Лазать по стенам",
["Custom walk speed"] = "Своя скорость ходьбы",
["Walk speed"] = "Скорость ходьбы",
["Custom jump"] = "Свой прыжок",
["Jump power"] = "Сила прыжка",
["Gravity"] = "Гравитация",
["Hip height"] = "Высота",
["Low gravity jump"] = "Прыжок с низкой гравитацией",
["Spin"] = "Вращение",
["Spin speed"] = "Скорость вращения",
["Anti push"] = "Анти-толчок",
["Ignore other players pushing you"] = "Другие игроки не могут тебя толкать",
["Anti ragdoll"] = "Анти-рэгдолл",
["Animation packs and dances"] = "Наборы анимаций и танцы",
["Packs"] = "Наборы",
["Dances"] = "Танцы",
["Animation pack"] = "Набор анимаций",
["Pack"] = "Набор",
["Zombie"] = "Зомби",
["Ninja"] = "Ниндзя",
["Robot"] = "Робот",
["Levitation"] = "Левитация",
["Stylish"] = "Стильный",
["Mage"] = "Маг",
["Use pack"] = "Использовать набор",
["Animation speed"] = "Скорость анимации",
["Seasonal packs"] = "Сезонные наборы",
["Phantom"] = "Фантом",
["Mummy"] = "Мумия",
["Dance 1"] = "Танец 1",
["Dance 2"] = "Танец 2",
["Dance 3"] = "Танец 3",
["Wave"] = "Помахать",
["Loop dance"] = "Танцевать по кругу",
["Harmless jokes and cosmetics"] = "Безобидные шутки и косметика",
["Cosmetics"] = "Косметика",
["Look"] = "Внешний вид",
["Only you can see these"] = "Это видишь только ты",
["Headless look"] = "Без головы",
["Korblox leg look"] = "Нога Korblox",
["Hat"] = "Шапка",
["None"] = "Нет",
["Pumpkin"] = "Тыква",
["Witch hat"] = "Шляпа ведьмы",
["Santa hat"] = "Шапка Санты",
["Halo"] = "Нимб",
["Toys"] = "Игрушки",
["Toy"] = "Игрушка",
["Hoverboard"] = "Ховерборд",
["Candy bucket"] = "Ведро конфет",
["Broom"] = "Метла",
["Balloon"] = "Шарик",
["Always hold toy"] = "Всегда держать игрушку",
["Emote spam"] = "Спам эмоцией",
["Emote"] = "Эмоция",
["wave"] = "помахать",
["point"] = "указать",
["cheer"] = "радость",
["laugh"] = "смех",
["dance"] = "танец",
["Repeat"] = "Повторять",
["Actions"] = "Действия",
["Follow selected"] = "Следовать за выбранным",
["Orbit selected"] = "Кружить вокруг выбранного",
["Copy their emotes"] = "Копировать эмоции",
["Messages and chat tools"] = "Сообщения и инструменты чата",
["Send"] = "Отправить",
["History"] = "История",
["Message"] = "Сообщение",
["Write something..."] = "Напиши что-нибудь...",
["Notifications"] = "Уведомления",
["Sound on mention"] = "Звук при упоминании",
["Preview popup"] = "Показать уведомление",
["This is how a popup looks"] = "Так выглядит уведомление",
["Keep history"] = "Сохранять историю",
["Nothing saved yet. Turn on history to keep messages from this server."] = "Пока ничего не сохранено. Включи историю, чтобы сохранять сообщения с этого сервера.",
["Background sounds while you play"] = "Фоновые звуки во время игры",
["Player"] = "Плеер",
["Library"] = "Библиотека",
["Now playing"] = "Сейчас играет",
["Sound ID"] = "ID звука",
["Play"] = "Играть",
["Stop"] = "Стоп",
["Sound"] = "Звук",
["Volume"] = "Громкость",
["Seasonal picks"] = "Сезонная подборка",
["Night walk"] = "Ночная прогулка",
["Snowfall"] = "Снегопад",
["Summer breeze"] = "Летний бриз",
["People using KRIEG HUB"] = "Люди с KRIEG HUB",
["Online"] = "Онлайн",
["In this server"] = "На этом сервере",
["Everywhere"] = "Везде",
["Refresh"] = "Обновить",
["Your tag"] = "Твой тег",
["Show tag above head"] = "Тег над головой",
["Tag style"] = "Стиль тега",
["Clean"] = "Чистый",
["Glow"] = "Свечение",
["Seasonal"] = "Сезонный",
["Save your setup and load it later"] = "Сохрани настройки и загрузи позже",
["Local"] = "Локальные",
["Shared"] = "Общие",
["Save"] = "Сохранить",
["Config name"] = "Название конфига",
["Load"] = "Загрузить",
["Delete"] = "Удалить",
["Saved configs"] = "Сохранённые конфиги",
["Config"] = "Конфиг",
["default"] = "обычный",
["legit"] = "легит",
["seasonal"] = "сезонный",
["Load on start"] = "Загружать при запуске",
["Shared configs"] = "Общие конфиги",
["Sharing configs with friends is coming in a future update."] = "Обмен конфигами с друзьями появится в следующих обновлениях.",
["Touch controls for phones and tablets"] = "Управление для телефонов и планшетов",
["Button"] = "Кнопка",
["Open button"] = "Кнопка открытия",
["Show button"] = "Показывать кнопку",
["Size"] = "Размер",
["Opacity"] = "Непрозрачность",
["Placement"] = "Расположение",
["Corner"] = "Угол",
["Top left"] = "Сверху слева",
["Top right"] = "Сверху справа",
["Bottom left"] = "Снизу слева",
["Bottom right"] = "Снизу справа",
["Allow dragging"] = "Можно перетаскивать",
["Info about this server"] = "Информация о сервере",
["Info"] = "Инфо",
["Place ID"] = "ID плейса",
["Rejoin"] = "Перезайти",
["Find another server"] = "Найти другой сервер",
["Copy server ID"] = "Скопировать ID сервера",
["Make the menu yours"] = "Сделай меню своим",
["Seasons"] = "Сезоны",
["Appearance"] = "Оформление",
["Interface"] = "Интерфейс",
["Mini bar"] = "Мини-бар",
["Other"] = "Прочее",
["Style"] = "Стиль",
["Colors, scene, particles and mini bar"] = "Цвета, сцена, частицы и мини-бар",
["Effects"] = "Эффекты",
["Live scene"] = "Живая сцена",
["Animated picture behind the menu"] = "Анимированная картинка за меню",
["Particles"] = "Частицы",
["Snow, leaves, petals and more"] = "Снег, листья, лепестки и не только",
["Amount"] = "Количество",
["Animated border"] = "Анимированная рамка",
["Accent"] = "Акцент",
["Override the style color"] = "Свой цвет вместо цвета стиля",
["Use style color"] = "Вернуть цвет стиля",
["Wallpaper"] = "Обои",
["Your own picture behind the menu"] = "Своя картинка за меню",
["Image link or Roblox image ID"] = "Ссылка на картинку или Roblox ID",
["Activate"] = "Активировать",
["Loading..."] = "Загрузка...",
["Wallpaper is on"] = "Обои установлены",
["Remove"] = "Убрать",
["Darken"] = "Затемнение",
["Also in mini bar"] = "Также в мини-баре",
["PNG or JPG link. Your style effects stay, only the built-in scene is replaced."] = "Ссылка на PNG или JPG. Эффекты стиля останутся, заменится только встроенная сцена.",
["Panels"] = "Панели",
["Panel transparency"] = "Прозрачность панелей",
["Font"] = "Шрифт",
["Applies to the whole menu"] = "Применяется ко всему меню",
["Text size"] = "Размер текста",
["Language"] = "Язык",
["Controls"] = "Управление",
["Open / hide menu"] = "Открыть / скрыть меню",
["Layout"] = "Макет",
["Menu size"] = "Размер меню",
["Compact sidebar"] = "Компактная боковая панель",
["The small bar at the top of the screen"] = "Маленькая панель вверху экрана",
["Show mini bar"] = "Показывать мини-бар",
["Particles inside"] = "Частицы внутри",
["Position"] = "Положение",
["Top"] = "Сверху",
["Bottom"] = "Снизу",
["Show on bar"] = "Что показывать",
["Clock"] = "Часы",
["Close button"] = "Кнопка закрытия",
["Saving"] = "Сохранение",
["Settings are saved automatically"] = "Настройки сохраняются автоматически",
["Your executor can't save files"] = "Твой экзекутор не умеет сохранять файлы",
["Status"] = "Статус",
["On"] = "Вкл",
["Reset all settings"] = "Сбросить все настройки",
["Run the script again to apply"] = "Запусти скрипт заново, чтобы применить",
["About"] = "О скрипте",
["Name"] = "Название",
["Version"] = "Версия",
["Styles"] = "Стили",
["Fonts"] = "Шрифты",
["Menu hidden"] = "Меню скрыто",
["Press the menu key or click the mini bar"] = "Нажми клавишу меню или кликни по мини-бару",
["Your settings are loaded"] = "Твои настройки загружены",
["Settings can't be saved in this executor"] = "В этом экзекуторе настройки не сохраняются",
["All"] = "Все",
["Apply"] = "Применить",
["Apply color"] = "Применить цвет",
["Auto"] = "Авто",
["Black"] = "Чёрный",
["White"] = "Белый",
["Cream"] = "Кремовый",
["Pink"] = "Розовый",
["Mint"] = "Мятный",
["Corner radius"] = "Скругление углов",
["Custom font applied"] = "Свой шрифт применён",
["Light"] = "Светлый",
["Dark"] = "Тёмный",
["Drag the bottom right corner of the menu to resize it."] = "Тяни за правый нижний угол меню, чтобы изменить размер.",
["Everyone on this server. Tap a player for actions"] = "Все на этом сервере. Нажми на игрока для действий",
["Spectate"] = "Наблюдать",
["Fling"] = "Флинг",
["Watch from their view"] = "Смотреть его глазами",
["Go to this player"] = "Переместиться к игроку",
["Push them away"] = "Отбросить игрока",
["Friend"] = "Друг",
["More fonts"] = "Ещё шрифты",
["Name, Roblox font ID or a .ttf link"] = "Название, Roblox ID шрифта или ссылка на .ttf",
["e.g. Lobster, 12187365364 or https://...ttf"] = "например Lobster, 12187365364 или https://...ttf",
["On this server"] = "На этом сервере",
["Panel color"] = "Цвет панелей",
["Pick a color that is easy to read on your wallpaper"] = "Выбери цвет, который хорошо читается на твоих обоях",
["Players tab with actions"] = "Вкладка игроков с действиями",
["Reset window size"] = "Сбросить размер окна",
["Resize the menu from its corner"] = "Размер меню тянется за угол",
["Search player"] = "Найти игрока",
["Text color"] = "Цвет текста",
["Text color and 105 fonts"] = "Цвет текста и 105 шрифтов",
["Use the format #RRGGBB"] = "Используй формат #RRGGBB",
["Your color, for example #FFAA00"] = "Свой цвет, например #FFAA00",
["Your font"] = "Свой шрифт",
["Type a font name, ID or link"] = "Введи название, ID или ссылку",
["Your executor can't load fonts from links"] = "Твой экзекутор не умеет грузить шрифты по ссылке",
["Could not load the font"] = "Не удалось загрузить шрифт",
["Could not download the font"] = "Не удалось скачать шрифт",
["Link must lead to a .ttf or .otf file"] = "Ссылка должна вести на файл .ttf или .otf",
["Could not save the font"] = "Не удалось сохранить шрифт",
["Font not found"] = "Шрифт не найден",
},
["Қазақша"] = {
["Halloween"] = "Хэллоуин",
["Basic"] = "Негізгі",
["New Year"] = "Жаңа жыл",
["Rain"] = "Жаңбыр",
["Summer"] = "Жаз",
["Spring"] = "Көктем",
["Autumn"] = "Күз",
["Sakura"] = "Сакура",
["Valentine"] = "Валентин",
["Clean and simple"] = "Таза әрі қарапайым",
["Spooky season"] = "Қорқынышты маусым",
["Snow and lights"] = "Қар мен шамдар",
["Calm and cozy"] = "Тыныш әрі жайлы",
["Sun and sea"] = "Күн мен теңіз",
["Fresh and green"] = "Балғын әрі жасыл",
["Falling leaves"] = "Түскен жапырақтар",
["Cherry blossom"] = "Сакура гүлдеуі",
["Love is in the air"] = "Махаббат ауада",
["Find a section..."] = "Бөлім іздеу...",
["press"] = "бас",
["none"] = "жоқ",
["Filter by name"] = "Аты бойынша іздеу",
["Server is empty for now"] = "Серверде әзірге ешкім жоқ",
["Paste a link first"] = "Алдымен сілтемені қой",
["This is not a link"] = "Бұл сілтеме емес",
["Your executor can't load images from links"] = "Экзекуторың сілтемеден сурет жүктей алмайды",
["Could not download the image"] = "Суретті жүктеу мүмкін болмады",
["GIF is not supported, use PNG or JPG"] = "GIF қолдау көрсетілмейді, PNG не JPG қолдан",
["The link is not a PNG or JPG image"] = "Сілтеме PNG не JPG суретке апармайды",
["Could not save the image"] = "Суретті сақтау мүмкін болмады",
["close"] = "жабу",
["Overview"] = "Шолу",
["Home"] = "Басты бет",
["Round"] = "Раунд",
["Murderer"] = "Өлтіруші",
["Sheriff"] = "Шериф",
["World"] = "Әлем",
["Visuals"] = "Визуал",
["Teleport"] = "Телепорт",
["Farming"] = "Фарм",
["You"] = "Сен",
["Character"] = "Кейіпкер",
["Emotes"] = "Эмоциялар",
["Fun"] = "Көңіл көтеру",
["NEW"] = "ЖАҢА",
["Social"] = "Әлеуметтік",
["Chat"] = "Чат",
["Music"] = "Музыка",
["Community"] = "Қауымдастық",
["System"] = "Жүйе",
["Configs"] = "Конфигтер",
["Mobile"] = "Телефон",
["Server"] = "Сервер",
["Settings"] = "Баптаулар",
["Welcome back"] = "Қайта оралуыңмен",
["Profile"] = "Профиль",
["days"] = "күн",
["KRIEG MEMBER"] = "KRIEG МҮШЕСІ",
["Live"] = "Тікелей",
["Updates every half second"] = "Әр жарты секунд сайын жаңарады",
["FPS"] = "FPS",
["Ping"] = "Пинг",
["Players"] = "Ойыншылар",
["Session"] = "Сессия",
["Season"] = "Маусым",
["Pick a style for the whole menu"] = "Бүкіл мәзірге стиль таңда",
["Changelog"] = "Жаңалықтар",
["Live scenes for every style"] = "Әр стильге тірі көріністер",
["Your own wallpaper"] = "Өз тұсқағазың",
["15 fonts and 3 languages"] = "15 қаріп және 3 тіл",
["Settings are saved"] = "Баптаулар сақталады",
["UI"] = "UI",
["Smaller, cleaner window"] = "Терезе кішірек әрі ұқыпты",
["Tools for when you hold the knife"] = "Пышақ қолыңда болғандағы құралдар",
["Knife"] = "Пышақ",
["Throw"] = "Лақтыру",
["Cosmetic"] = "Безендіру",
["Close range"] = "Жақын қашықтық",
["Reach"] = "Соққы қашықтығы",
["Longer knife hit range"] = "Пышақ алысырақ тиеді",
["Reach distance"] = "Соққы аралығы",
["Quick equip"] = "Тез алу",
["Pull out the knife instantly"] = "Пышақты бірден шығарады",
["Alerts"] = "Ескертулер",
["Sheriff nearby"] = "Шериф жақын",
["Warns when the sheriff is close"] = "Шериф жақындағанда ескертеді",
["Round start sound"] = "Раунд басталу дыбысы",
["Throwing"] = "Лақтыру",
["Throw assist"] = "Лақтыруға көмек",
["Priority"] = "Басымдық",
["Nearest"] = "Ең жақын",
["Sheriff first"] = "Алдымен шериф",
["Hero first"] = "Алдымен батыр",
["Lowest HP"] = "HP ең аз",
["Lead"] = "Алдын ала көздеу",
["Tip"] = "Кеңес",
["Lead controls how far ahead of a moving target the throw is aimed. Start low and raise it slowly."] = "Алдын ала көздеу қозғалыстағы нысананың қаншалықты алдына лақтыратынын анықтайды. Аздан бастап, біртіндеп көтер.",
["Knife trail"] = "Пышақ ізі",
["Off"] = "Өшірулі",
["Ember"] = "Шоқ",
["Void"] = "Бостық",
["Frost"] = "Аяз",
["Toxic"] = "Улы",
["Gold"] = "Алтын",
["Aim helpers and gun tools"] = "Көздеуге көмек және тапанша",
["Aim"] = "Көздеу",
["Gun"] = "Тапанша",
["Aim helper"] = "Көздеу көмекшісі",
["Soft aim"] = "Жұмсақ көздеу",
["Gently pulls aim to the target"] = "Көздеуді нысанаға ақырын тартады",
["Smoothness"] = "Жұмсақтық",
["FOV"] = "FOV",
["Aim point"] = "Көздеу нүктесі",
["Upper body"] = "Дененің үсті",
["Head"] = "Бас",
["Center"] = "Орта",
["FOV circle"] = "FOV шеңбері",
["Show circle"] = "Шеңберді көрсету",
["Fill circle"] = "Шеңберді бояу",
["Thickness"] = "Қалыңдық",
["Dropped gun"] = "Түсіп қалған тапанша",
["Highlight dropped gun"] = "Тапаншаны белгілеу",
["Outline the gun when the sheriff dies"] = "Шериф өлгенде тапаншаны белгілейді",
["Announce drop"] = "Түскенін хабарлау",
["Pick up gun"] = "Тапаншаны алу",
["See more of the round and the map"] = "Раундта және картада көбірек көр",
["Atmosphere"] = "Атмосфера",
["Highlights"] = "Белгілеу",
["Outline players by role"] = "Ойыншыларды рөлі бойынша белгілеу",
["Enabled"] = "Қосулы",
["Roles to show"] = "Көрсетілетін рөлдер",
["Hero"] = "Батыр",
["Innocent"] = "Бейкүнә",
["Unknown"] = "Белгісіз",
["Range"] = "Қашықтық",
["Only visible"] = "Тек көрінетіндер",
["Labels"] = "Жазулар",
["Names"] = "Аттар",
["Distance"] = "Арақашықтық",
["Role tag"] = "Рөл белгісі",
["Highlight style"] = "Белгілеу стилі",
["Soft"] = "Жұмсақ",
["Outline"] = "Контур",
["Neon"] = "Неон",
["Ghost"] = "Елес",
["Hologram"] = "Голограмма",
["Shadow"] = "Көлеңке",
["Color source"] = "Түс көзі",
["Role color"] = "Рөл түсі",
["Theme accent"] = "Стиль түсі",
["Rainbow"] = "Кемпірқосақ",
["Lighting"] = "Жарық",
["Bright map"] = "Жарық карта",
["Removes dark shadows"] = "Қараңғы көлеңкелерді алады",
["Clear fog"] = "Тұманды алу",
["Clock time"] = "Тәулік уақыты",
["Color grading"] = "Түс түзету",
["Saturation"] = "Қанықтық",
["Contrast"] = "Контраст",
["Weather"] = "Ауа райы",
["Snow"] = "Қар",
["Fog"] = "Тұман",
["Storm"] = "Найзағай",
["Intensity"] = "Күші",
["Sky"] = "Аспан",
["Skybox"] = "Скайбокс",
["Default"] = "Әдепкі",
["Blood moon"] = "Қанды ай",
["Night"] = "Түн",
["Galaxy"] = "Галактика",
["Sunset"] = "Күн батуы",
["Slow sky rotation"] = "Аспанның баяу айналуы",
["Move around the map quickly"] = "Картада тез қозғал",
["Places"] = "Орындар",
["Lobby"] = "Лобби",
["Map"] = "Карта",
["Spawn"] = "Спавн",
["Safe spot"] = "Қауіпсіз орын",
["Travel"] = "Қозғалыс",
["Method"] = "Тәсіл",
["Smooth"] = "Баяу",
["Instant"] = "Бірден",
["Speed"] = "Жылдамдық",
["Go to player"] = "Ойыншыға бару",
["Coins and progress"] = "Тиындар мен прогресс",
["Coins"] = "Тиындар",
["Coin collector"] = "Тиын жинаушы",
["Collect coins"] = "Тиын жинау",
["Picks up coins around the map"] = "Картадағы тиындарды жинайды",
["Stay away from murderer"] = "Өлтірушіден аулақ болу",
["Movement"] = "Қозғалыс",
["Walk"] = "Жаяу",
["Safety"] = "Қауіпсіздік",
["Anti AFK"] = "Анти-АФК",
["Stop when bag is full"] = "Сөмке толса тоқтау",
["This session"] = "Осы сессия",
["Rounds"] = "Раундтар",
["Per hour"] = "Сағатына",
["Reset"] = "Тазарту",
["Movement, physics and protection"] = "Қозғалыс, физика және қорғаныс",
["Physics"] = "Физика",
["Protection"] = "Қорғаныс",
["Walk through walls"] = "Қабырға арқылы өту",
["Air jump"] = "Ауада секіру",
["Jump again while in the air"] = "Ауада тағы секіру",
["Flight"] = "Ұшу",
["Bunny hop"] = "Банихоп",
["Wall climb"] = "Қабырғаға өрмелеу",
["Custom walk speed"] = "Өз жүру жылдамдығы",
["Walk speed"] = "Жүру жылдамдығы",
["Custom jump"] = "Өз секіруің",
["Jump power"] = "Секіру күші",
["Gravity"] = "Гравитация",
["Hip height"] = "Биіктік",
["Low gravity jump"] = "Төмен гравитациялы секіру",
["Spin"] = "Айналу",
["Spin speed"] = "Айналу жылдамдығы",
["Anti push"] = "Итеруге қарсы",
["Ignore other players pushing you"] = "Басқалардың итеруін елемеу",
["Anti ragdoll"] = "Анти-рэгдолл",
["Animation packs and dances"] = "Анимация жинақтары мен билер",
["Packs"] = "Жинақтар",
["Dances"] = "Билер",
["Animation pack"] = "Анимация жинағы",
["Pack"] = "Жинақ",
["Zombie"] = "Зомби",
["Ninja"] = "Ниндзя",
["Robot"] = "Робот",
["Levitation"] = "Левитация",
["Stylish"] = "Сәнді",
["Mage"] = "Сиқыршы",
["Use pack"] = "Жинақты қолдану",
["Animation speed"] = "Анимация жылдамдығы",
["Seasonal packs"] = "Маусымдық жинақтар",
["Phantom"] = "Фантом",
["Mummy"] = "Мумия",
["Dance 1"] = "Би 1",
["Dance 2"] = "Би 2",
["Dance 3"] = "Би 3",
["Wave"] = "Қол бұлғау",
["Loop dance"] = "Қайталап билеу",
["Harmless jokes and cosmetics"] = "Зиянсыз әзілдер мен безендіру",
["Cosmetics"] = "Безендіру",
["Look"] = "Сыртқы түр",
["Only you can see these"] = "Мұны тек сен көресің",
["Headless look"] = "Бассыз көрініс",
["Korblox leg look"] = "Korblox аяғы",
["Hat"] = "Бас киім",
["None"] = "Жоқ",
["Pumpkin"] = "Асқабақ",
["Witch hat"] = "Мыстан қалпағы",
["Santa hat"] = "Аяз ата қалпағы",
["Halo"] = "Нұр шеңбер",
["Toys"] = "Ойыншықтар",
["Toy"] = "Ойыншық",
["Hoverboard"] = "Ховерборд",
["Candy bucket"] = "Кәмпит шелегі",
["Broom"] = "Сыпырғыш",
["Balloon"] = "Әуе шары",
["Always hold toy"] = "Ойыншықты үнемі ұстау",
["Emote spam"] = "Эмоция спамы",
["Emote"] = "Эмоция",
["wave"] = "қол бұлғау",
["point"] = "нұсқау",
["cheer"] = "қуану",
["laugh"] = "күлу",
["dance"] = "би",
["Repeat"] = "Қайталау",
["Actions"] = "Әрекеттер",
["Follow selected"] = "Таңдалғанның соңынан еру",
["Orbit selected"] = "Таңдалғанды айналу",
["Copy their emotes"] = "Эмоцияларын көшіру",
["Messages and chat tools"] = "Хабарламалар мен чат құралдары",
["Send"] = "Жіберу",
["History"] = "Тарих",
["Message"] = "Хабарлама",
["Write something..."] = "Бірдеңе жаз...",
["Notifications"] = "Хабарландырулар",
["Sound on mention"] = "Атауда дыбыс",
["Preview popup"] = "Хабарландыруды көрсету",
["This is how a popup looks"] = "Хабарландыру осылай көрінеді",
["Keep history"] = "Тарихты сақтау",
["Nothing saved yet. Turn on history to keep messages from this server."] = "Әзірге ештеңе сақталмаған. Осы сервердің хабарламаларын сақтау үшін тарихты қос.",
["Background sounds while you play"] = "Ойын кезіндегі фондық дыбыстар",
["Player"] = "Ойнатқыш",
["Library"] = "Кітапхана",
["Now playing"] = "Қазір ойнап тұр",
["Sound ID"] = "Дыбыс ID",
["Play"] = "Ойнату",
["Stop"] = "Тоқтату",
["Sound"] = "Дыбыс",
["Volume"] = "Дыбыс деңгейі",
["Seasonal picks"] = "Маусымдық таңдау",
["Night walk"] = "Түнгі серуен",
["Snowfall"] = "Қар жауу",
["Summer breeze"] = "Жазғы самал",
["People using KRIEG HUB"] = "KRIEG HUB қолданушылары",
["Online"] = "Онлайн",
["In this server"] = "Осы серверде",
["Everywhere"] = "Барлық жерде",
["Refresh"] = "Жаңарту",
["Your tag"] = "Сенің тегің",
["Show tag above head"] = "Бас үстінде тег",
["Tag style"] = "Тег стилі",
["Clean"] = "Таза",
["Glow"] = "Жарқырау",
["Seasonal"] = "Маусымдық",
["Save your setup and load it later"] = "Баптауларды сақтап, кейін жүкте",
["Local"] = "Жергілікті",
["Shared"] = "Ортақ",
["Save"] = "Сақтау",
["Config name"] = "Конфиг атауы",
["Load"] = "Жүктеу",
["Delete"] = "Жою",
["Saved configs"] = "Сақталған конфигтер",
["Config"] = "Конфиг",
["default"] = "әдепкі",
["legit"] = "легит",
["seasonal"] = "маусымдық",
["Load on start"] = "Іске қосқанда жүктеу",
["Shared configs"] = "Ортақ конфигтер",
["Sharing configs with friends is coming in a future update."] = "Достармен конфиг бөлісу келесі жаңартуларда шығады.",
["Touch controls for phones and tablets"] = "Телефон мен планшетке арналған басқару",
["Button"] = "Батырма",
["Open button"] = "Ашу батырмасы",
["Show button"] = "Батырманы көрсету",
["Size"] = "Өлшемі",
["Opacity"] = "Мөлдірсіздік",
["Placement"] = "Орналасуы",
["Corner"] = "Бұрыш",
["Top left"] = "Жоғарғы сол",
["Top right"] = "Жоғарғы оң",
["Bottom left"] = "Төменгі сол",
["Bottom right"] = "Төменгі оң",
["Allow dragging"] = "Сүйреуге болады",
["Info about this server"] = "Сервер туралы ақпарат",
["Info"] = "Ақпарат",
["Place ID"] = "Плейс ID",
["Rejoin"] = "Қайта кіру",
["Find another server"] = "Басқа сервер табу",
["Copy server ID"] = "Сервер ID көшіру",
["Make the menu yours"] = "Мәзірді өзіңе бейімде",
["Seasons"] = "Маусымдар",
["Appearance"] = "Безендіру",
["Interface"] = "Интерфейс",
["Mini bar"] = "Мини-бар",
["Other"] = "Басқа",
["Style"] = "Стиль",
["Colors, scene, particles and mini bar"] = "Түстер, көрініс, бөлшектер және мини-бар",
["Effects"] = "Эффектілер",
["Live scene"] = "Тірі көрініс",
["Animated picture behind the menu"] = "Мәзір артындағы анимациялы сурет",
["Particles"] = "Бөлшектер",
["Snow, leaves, petals and more"] = "Қар, жапырақ, гүл жапырақшалары және т.б.",
["Amount"] = "Мөлшері",
["Animated border"] = "Анимациялы жиек",
["Accent"] = "Акцент",
["Override the style color"] = "Стиль түсінің орнына өз түсің",
["Use style color"] = "Стиль түсін қайтару",
["Wallpaper"] = "Тұсқағаз",
["Your own picture behind the menu"] = "Мәзір артындағы өз суретің",
["Image link or Roblox image ID"] = "Сурет сілтемесі не Roblox ID",
["Activate"] = "Қосу",
["Loading..."] = "Жүктелуде...",
["Wallpaper is on"] = "Тұсқағаз орнатылды",
["Remove"] = "Алып тастау",
["Darken"] = "Күңгірттеу",
["Also in mini bar"] = "Мини-барда да",
["PNG or JPG link. Your style effects stay, only the built-in scene is replaced."] = "PNG не JPG сілтемесі. Стиль эффектілері қалады, тек кірістірілген көрініс ауысады.",
["Panels"] = "Панельдер",
["Panel transparency"] = "Панельдердің мөлдірлігі",
["Font"] = "Қаріп",
["Applies to the whole menu"] = "Бүкіл мәзірге қолданылады",
["Text size"] = "Мәтін өлшемі",
["Language"] = "Тіл",
["Controls"] = "Басқару",
["Open / hide menu"] = "Мәзірді ашу / жасыру",
["Layout"] = "Орналасым",
["Menu size"] = "Мәзір өлшемі",
["Compact sidebar"] = "Ықшам бүйір панель",
["The small bar at the top of the screen"] = "Экранның жоғарғы жағындағы шағын панель",
["Show mini bar"] = "Мини-барды көрсету",
["Particles inside"] = "Ішіндегі бөлшектер",
["Position"] = "Орны",
["Top"] = "Жоғарыда",
["Bottom"] = "Төменде",
["Show on bar"] = "Барда көрсету",
["Clock"] = "Сағат",
["Close button"] = "Жабу батырмасы",
["Saving"] = "Сақтау",
["Settings are saved automatically"] = "Баптаулар автоматты түрде сақталады",
["Your executor can't save files"] = "Экзекуторың файл сақтай алмайды",
["Status"] = "Күйі",
["On"] = "Қосулы",
["Reset all settings"] = "Барлық баптауларды тазарту",
["Run the script again to apply"] = "Қолдану үшін скриптті қайта іске қос",
["About"] = "Скрипт туралы",
["Name"] = "Атауы",
["Version"] = "Нұсқа",
["Styles"] = "Стильдер",
["Fonts"] = "Қаріптер",
["Menu hidden"] = "Мәзір жасырылды",
["Press the menu key or click the mini bar"] = "Мәзір пернесін бас не мини-барды бас",
["Your settings are loaded"] = "Баптауларың жүктелді",
["Settings can't be saved in this executor"] = "Бұл экзекуторда баптаулар сақталмайды",
["All"] = "Барлығы",
["Apply"] = "Қолдану",
["Apply color"] = "Түсті қолдану",
["Auto"] = "Авто",
["Black"] = "Қара",
["White"] = "Ақ",
["Cream"] = "Кілегей",
["Pink"] = "Қызғылт",
["Mint"] = "Жалбыз",
["Corner radius"] = "Бұрыш дөңгелектігі",
["Custom font applied"] = "Өз қаріпің қолданылды",
["Light"] = "Ашық",
["Dark"] = "Қараңғы",
["Drag the bottom right corner of the menu to resize it."] = "Өлшемін өзгерту үшін мәзірдің оң жақ төменгі бұрышынан тарт.",
["Everyone on this server. Tap a player for actions"] = "Осы сервердегілер. Әрекеттер үшін ойыншыны бас",
["Spectate"] = "Бақылау",
["Fling"] = "Флинг",
["Watch from their view"] = "Оның көзімен көру",
["Go to this player"] = "Ойыншыға бару",
["Push them away"] = "Ойыншыны лақтыру",
["Friend"] = "Дос",
["More fonts"] = "Тағы қаріптер",
["Name, Roblox font ID or a .ttf link"] = "Атауы, Roblox қаріп ID не .ttf сілтемесі",
["e.g. Lobster, 12187365364 or https://...ttf"] = "мысалы Lobster, 12187365364 не https://...ttf",
["On this server"] = "Осы серверде",
["Panel color"] = "Панель түсі",
["Pick a color that is easy to read on your wallpaper"] = "Тұсқағазыңда оңай оқылатын түсті таңда",
["Players tab with actions"] = "Әрекеттері бар ойыншылар бөлімі",
["Reset window size"] = "Терезе өлшемін тазарту",
["Resize the menu from its corner"] = "Мәзір өлшемі бұрыштан өзгереді",
["Search player"] = "Ойыншыны іздеу",
["Text color"] = "Мәтін түсі",
["Text color and 105 fonts"] = "Мәтін түсі және 105 қаріп",
["Use the format #RRGGBB"] = "#RRGGBB пішімін қолдан",
["Your color, for example #FFAA00"] = "Өз түсің, мысалы #FFAA00",
["Your font"] = "Өз қаріпің",
["Type a font name, ID or link"] = "Атауын, ID не сілтемені жаз",
["Your executor can't load fonts from links"] = "Экзекуторың сілтемеден қаріп жүктей алмайды",
["Could not load the font"] = "Қаріпті жүктеу мүмкін болмады",
["Could not download the font"] = "Қаріпті жүктеп алу мүмкін болмады",
["Link must lead to a .ttf or .otf file"] = "Сілтеме .ttf не .otf файлға апаруы керек",
["Could not save the font"] = "Қаріпті сақтау мүмкін болмады",
["Font not found"] = "Қаріп табылмады",
},
},
reg = setmetatable({}, { __mode = "k" }),
ph = setmetatable({}, { __mode = "k" }),
cbs = {},
}
do
local add = {
["Русский"] = {
["Admin Panel"] = "Админ-панель", ["OVERVIEW"] = "ОБЗОР", ["FARM"] = "ФАРМ", ["WORLD"] = "МИР", ["YOU"] = "ТЫ",
["Auto Farm"] = "Авто фарм", ["Farm"] = "Фарм", ["Training"] = "Тренировка", ["Auto Training"] = "Авто тренировка",
["Auto 2x Button"] = "Авто кнопка 2x", ["Equip"] = "Экипировка", ["Auto Equip Best"] = "Авто экип лучших",
["Equip Interval"] = "Интервал экипировки", ["Misc"] = "Прочее",
["Auto Sell"] = "Авто продажа", ["Sell If Income Below"] = "Продавать, если доход ниже", ["Keep Mutations"] = "Оставлять с мутацией",
["Sell Interval"] = "Интервал продажи", ["Sell Now"] = "Продать сейчас",
["Starter Area"] = "Стартовая зона", ["Training Spot"] = "Место тренировки", ["Placement Marker"] = "Метка размещения", ["Sell Place"] = "Место продажи",
["About Us"] = "О нас", ["Thanks for using our menu!"] = "Спасибо, что пользуешься нашим меню!", ["Copy link"] = "Скопировать ссылку",
["Done"] = "Готово", ["Link copied"] = "Ссылка скопирована", ["Link"] = "Ссылка",
["Configs and interface"] = "Конфиги и интерфейс", ["Saved as files"] = "Сохраняются файлами", ["Saved for this session only"] = "Только на эту сессию",
["Config Name"] = "Название конфига", ["my config"] = "мой конфиг", ["Config List"] = "Список конфигов", ["Save Config"] = "Сохранить конфиг",
["Load Config"] = "Загрузить конфиг", ["Delete Config"] = "Удалить конфиг", ["Refresh List"] = "Обновить список", ["Auto Load Config"] = "Автозагрузка конфига",
["Saved"] = "Сохранён", ["Loaded"] = "Загружен", ["Auto Load"] = "Автозагрузка", ["Will load on start"] = "Будет загружаться при запуске",
["Toggle Menu"] = "Открыть / скрыть меню", ["Press a key..."] = "Нажми клавишу...", ["UI Scale"] = "Размер меню", ["Reset Size"] = "Сбросить размер",
["Unload Menu"] = "Выгрузить меню", ["Theme"] = "Тема", ["Sky"] = "Голубой", ["Gold"] = "Золотой", ["Mini Bar"] = "Мини-бар",
["Menu loaded"] = "Меню загружено", ["hide / show"] = "скрыть / показать",
["Languages, fonts, wallpaper, mini bar"] = "Языки, шрифты, обои, мини-бар", ["Auto Farm, Auto Training, Auto Sell"] = "Авто фарм, авто тренировка, авто продажа",
["Teleports without falling"] = "Телепорты без падений", ["Configs and Auto Load"] = "Конфиги и автозагрузка",
["Creator"] = "Создатель", ["Telegram channel"] = "Telegram-канал", ["Subscribe to the channel — regular updates come out there"] = "Подпишись на канал — там выходят регулярные обновления", ["Link copied to clipboard"] = "Ссылка скопирована в буфер обмена",
["STEAL"] = "КРАЖА", ["Steal Panel"] = "Стил панель", ["Auto Steal"] = "Авто кража", ["Tween Speed"] = "Скорость полёта",
["Hop Distance"] = "Длина прыжка", ["Guard Wait"] = "Ждать охранника", ["Sort"] = "Сортировка", ["Value"] = "Ценность",
["Only eggs I can escape with"] = "Только яйца, с которыми убегу", ["Return to Base"] = "Вернуться на базу", ["Eggs"] = "Яйца",
["No eggs on the map"] = "На карте нет яиц", ["Steal"] = "Украсть", ["Egg delivered"] = "Яйцо доставлено на базу", ["Steal failed"] = "Не получилось украсть",
["Filter"] = "Фильтр", ["No picture found on this page"] = "На странице не найдена картинка",
["WEBP is not supported, use PNG or JPG"] = "WEBP не поддерживается, используй PNG или JPG",
["Pinterest link, PNG/JPG link or Roblox image ID"] = "Ссылка Pinterest, PNG/JPG или Roblox ID",
["Days"] = "Дни", ["Hours"] = "Часы", ["Minutes"] = "Минуты", ["Seconds"] = "Секунды",
["Until New Year"] = "До Нового года", ["Happy New Year!"] = "С Новым годом!",
["New Year decor"] = "Новогодний декор",
},
["Қазақша"] = {
["Admin Panel"] = "Әкімші панелі", ["OVERVIEW"] = "ШОЛУ", ["FARM"] = "ФАРМ", ["WORLD"] = "ӘЛЕМ", ["YOU"] = "СЕН",
["Auto Farm"] = "Авто фарм", ["Farm"] = "Фарм", ["Training"] = "Жаттығу", ["Auto Training"] = "Авто жаттығу",
["Auto 2x Button"] = "Авто 2x батырмасы", ["Equip"] = "Жабдықтау", ["Auto Equip Best"] = "Ең жақсысын авто кию",
["Equip Interval"] = "Жабдықтау аралығы", ["Misc"] = "Басқа",
["Auto Sell"] = "Авто сату", ["Sell If Income Below"] = "Табыс төмен болса сату", ["Keep Mutations"] = "Мутациялыларды қалдыру",
["Sell Interval"] = "Сату аралығы", ["Sell Now"] = "Қазір сату",
["Starter Area"] = "Бастапқы аймақ", ["Training Spot"] = "Жаттығу орны", ["Placement Marker"] = "Орналастыру белгісі", ["Sell Place"] = "Сату орны",
["About Us"] = "Біз туралы", ["Thanks for using our menu!"] = "Мәзірімізді қолданғаныңа рахмет!", ["Copy link"] = "Сілтемені көшіру",
["Done"] = "Дайын", ["Link copied"] = "Сілтеме көшірілді", ["Link"] = "Сілтеме",
["Configs and interface"] = "Конфигтер және интерфейс", ["Saved as files"] = "Файл ретінде сақталады", ["Saved for this session only"] = "Тек осы сессияға",
["Config Name"] = "Конфиг атауы", ["my config"] = "менің конфигім", ["Config List"] = "Конфигтер тізімі", ["Save Config"] = "Конфигті сақтау",
["Load Config"] = "Конфигті жүктеу", ["Delete Config"] = "Конфигті жою", ["Refresh List"] = "Тізімді жаңарту", ["Auto Load Config"] = "Конфигті автожүктеу",
["Saved"] = "Сақталды", ["Loaded"] = "Жүктелді", ["Auto Load"] = "Автожүктеу", ["Will load on start"] = "Іске қосқанда жүктеледі",
["Toggle Menu"] = "Мәзірді ашу / жасыру", ["Press a key..."] = "Пернені бас...", ["UI Scale"] = "Мәзір өлшемі", ["Reset Size"] = "Өлшемді қалпына келтіру",
["Unload Menu"] = "Мәзірді өшіру", ["Theme"] = "Тақырып", ["Sky"] = "Көгілдір", ["Gold"] = "Алтын", ["Mini Bar"] = "Мини-бар",
["Menu loaded"] = "Мәзір жүктелді", ["hide / show"] = "жасыру / көрсету",
["Languages, fonts, wallpaper, mini bar"] = "Тілдер, қаріптер, тұсқағаз, мини-бар", ["Auto Farm, Auto Training, Auto Sell"] = "Авто фарм, авто жаттығу, авто сату",
["Teleports without falling"] = "Құламай телепорт", ["Configs and Auto Load"] = "Конфигтер және автожүктеу",
["Creator"] = "Жасаушы", ["Telegram channel"] = "Telegram-арна", ["Subscribe to the channel — regular updates come out there"] = "Арнаға жазыл — онда жүйелі жаңартулар шығады", ["Link copied to clipboard"] = "Сілтеме алмасу буферіне көшірілді",
["STEAL"] = "ҰРЛЫҚ", ["Steal Panel"] = "Стил панель", ["Auto Steal"] = "Авто ұрлау", ["Tween Speed"] = "Ұшу жылдамдығы",
["Hop Distance"] = "Секіру ұзындығы", ["Guard Wait"] = "Күзетшіні күту", ["Sort"] = "Сұрыптау", ["Value"] = "Құндылық",
["Only eggs I can escape with"] = "Тек қашып үлгеретін жұмыртқалар", ["Return to Base"] = "Базаға қайту", ["Eggs"] = "Жұмыртқалар",
["No eggs on the map"] = "Картада жұмыртқа жоқ", ["Steal"] = "Ұрлау", ["Egg delivered"] = "Жұмыртқа базаға жеткізілді", ["Steal failed"] = "Ұрлау сәтсіз аяқталды",
["Filter"] = "Сүзгі", ["No picture found on this page"] = "Бетте сурет табылмады",
["WEBP is not supported, use PNG or JPG"] = "WEBP қолдау көрсетілмейді, PNG не JPG қолдан",
["Pinterest link, PNG/JPG link or Roblox image ID"] = "Pinterest сілтемесі, PNG/JPG не Roblox ID",
["Days"] = "Күн", ["Hours"] = "Сағат", ["Minutes"] = "Минут", ["Seconds"] = "Секунд",
["Until New Year"] = "Жаңа жылға дейін", ["Happy New Year!"] = "Жаңа жылың құтты болсын!",
["New Year decor"] = "Жаңа жыл безендіруі",
},
}
for lang, t in pairs(add) do
for k, v in pairs(t) do Lang.dict[lang][k] = v end
end
local found = false
for _, n in ipairs(Lang.list) do if n == S.Lang then found = true end end
Lang.cur = found and S.Lang or "English"
end
do
local add2 = {
["Русский"] = {
["Auto 20 Power"] = "Авто 20 силы", ["Auto Buy"] = "Авто покупка", ["Auto Buy Food"] = "Авто покупка еды", ["Auto Buy Plot"] = "Авто покупка плота",
["Auto Claim"] = "Авто сбор", ["Auto Claim Free Shop Reward"] = "Забирать бесплатную награду", ["Auto Claim Index Rewards"] = "Забирать награды Index",
["Auto Claim Milestones"] = "Забирать награды за коллекцию", ["Auto Claim Offline Earnings"] = "Забирать оффлайн-доход", ["Auto Dream Farm"] = "Авто фарм сна",
["Auto Index"] = "Авто Index", ["Auto Infusion"] = "Авто вливание", ["Auto Upgrade"] = "Авто прокачка", ["Auto Upgrade Pull-Up Bar"] = "Авто прокачка турника",
["Best = zone with most uncaught dream animals. Deeper = more kinds"] = "Best — зона, где больше всего непойманных. Глубже — больше видов",
["Buy"] = "Покупка", ["Buy Items"] = "Что покупать", ["Check Every"] = "Проверять каждые", ["Claim Now"] = "Забрать сейчас",
["Claim Rewards Now"] = "Забрать награды", ["Clicks through the flight and the reveal so throws go faster"] = "Прокликивает полёт и показ животного — броски быстрее",
["Dream Zone"] = "Зона сна", ["Dreamland"] = "Dreamland", ["Event"] = "Ивент", ["Fast Throw"] = "Быстрый бросок",
["Food: buys the next better food as soon as you have the money and equips it"] = "Еда: покупает следующую лучшую, как только хватает денег, и экипирует",
["Index Hunter"] = "Охота за Index", ["Normal farm between dreams"] = "Обычный фарм между снами", ["Potions per Infusion"] = "Зелий за вливание",
["Picks the zone with the most uncaught animals you can reach and throws deep into it"] = "Выбирает зону, где больше всего непойманных, и кидает в её глубину",
["Progress"] = "Прогресс", ["Puts Dream Potions into your best-earning animal (+25% Dream chance per potion)"] = "Вливает зелья в самое доходное животное (+25% шанс Dream за зелье)",
["Reset Session"] = "Сбросить сессию", ["Rewards"] = "Награды", ["Skip Throw Animation"] = "Пропуск анимации броска", ["Stats"] = "Статистика",
["Teleport to Mr. Hush"] = "Телепорт к Mr. Hush", ["Throw Depth"] = "Глубина броска", ["Upgrade"] = "Прокачка",
["Upgrade Everything Now"] = "Прокачать всё сейчас", ["Wizard (Mr. Hush)"] = "Волшебник (Mr. Hush)", ["Zone"] = "Зона",
["Session"] = "Сессия", ["Status"] = "Статус", ["Nothing to claim yet"] = "Пока нечего забирать", ["Plot upgraded"] = "Плот прокачан",
["Pull-up bar upgraded"] = "Турник прокачан", ["Offline earnings claimed"] = "Оффлайн-доход собран", ["Free reward claimed"] = "Бесплатная награда собрана",
["Everything in reach is collected!"] = "Всё доступное уже собрано!", ["Game modules not found"] = "Модули игры не найдены",
["Event modules not found"] = "Модули ивента не найдены", ["Not enough power for a dream zone"] = "Не хватает силы до зоны сна",
["Wizard stand not found"] = "Стенд волшебника не найден", ["Auto Run"] = "Автозапуск", ["Run on join"] = "Запускать при входе в игру",
["Show all themes"] = "Показать все темы", ["Hide themes"] = "Скрыть темы", ["Live theme wallpapers"] = "Живые обои тем",
["Also restarts the menu by itself after teleports and rejoins"] = "Меню само перезапустится после телепорта и реджойна",
},
["Қазақша"] = {
["Auto 20 Power"] = "Авто 20 күш", ["Auto Buy"] = "Авто сатып алу", ["Auto Buy Food"] = "Тамақты авто сатып алу", ["Auto Buy Plot"] = "Учаскені авто сатып алу",
["Auto Claim"] = "Авто жинау", ["Auto Claim Free Shop Reward"] = "Тегін сыйлықты алу", ["Auto Claim Index Rewards"] = "Index сыйлықтарын алу",
["Auto Claim Milestones"] = "Коллекция сыйлықтарын алу", ["Auto Claim Offline Earnings"] = "Офлайн табысты алу", ["Auto Dream Farm"] = "Түс фармы",
["Auto Index"] = "Авто Index", ["Auto Infusion"] = "Авто құю", ["Auto Upgrade"] = "Авто жақсарту", ["Auto Upgrade Pull-Up Bar"] = "Турникті авто жақсарту",
["Best = zone with most uncaught dream animals. Deeper = more kinds"] = "Best — ұсталмаған жануарлар көп аймақ. Тереңірек — түрлері көп",
["Buy"] = "Сатып алу", ["Buy Items"] = "Не сатып алу", ["Check Every"] = "Тексеру аралығы", ["Claim Now"] = "Қазір алу",
["Claim Rewards Now"] = "Сыйлықтарды алу", ["Clicks through the flight and the reveal so throws go faster"] = "Ұшу мен көрсетуді өткізіп жібереді — лақтыру жылдамырақ",
["Dream Zone"] = "Түс аймағы", ["Dreamland"] = "Dreamland", ["Event"] = "Ивент", ["Fast Throw"] = "Жылдам лақтыру",
["Food: buys the next better food as soon as you have the money and equips it"] = "Тамақ: ақша жеткенде келесі жақсысын сатып алып, киеді",
["Index Hunter"] = "Index аулау", ["Normal farm between dreams"] = "Түстер арасында қалыпты фарм", ["Potions per Infusion"] = "Бір құюға дәрі",
["Picks the zone with the most uncaught animals you can reach and throws deep into it"] = "Ұсталмағандары көп аймақты таңдап, тереңіне лақтырады",
["Progress"] = "Прогресс", ["Puts Dream Potions into your best-earning animal (+25% Dream chance per potion)"] = "Дәрілерді ең табысты жануарға құяды (+25% Dream мүмкіндігі)",
["Reset Session"] = "Сессияны тастау", ["Rewards"] = "Сыйлықтар", ["Skip Throw Animation"] = "Лақтыру анимациясын өткізу", ["Stats"] = "Статистика",
["Teleport to Mr. Hush"] = "Mr. Hush-қа телепорт", ["Throw Depth"] = "Лақтыру тереңдігі", ["Upgrade"] = "Жақсарту",
["Upgrade Everything Now"] = "Бәрін қазір жақсарту", ["Wizard (Mr. Hush)"] = "Сиқыршы (Mr. Hush)", ["Zone"] = "Аймақ",
["Session"] = "Сессия", ["Status"] = "Күйі", ["Nothing to claim yet"] = "Әзірге алатын ештеңе жоқ", ["Plot upgraded"] = "Учаске жақсартылды",
["Pull-up bar upgraded"] = "Турник жақсартылды", ["Offline earnings claimed"] = "Офлайн табыс алынды", ["Free reward claimed"] = "Тегін сыйлық алынды",
["Everything in reach is collected!"] = "Қолжетімдінің бәрі жиналды!", ["Game modules not found"] = "Ойын модульдері табылмады",
["Event modules not found"] = "Ивент модульдері табылмады", ["Not enough power for a dream zone"] = "Түс аймағына күш жетпейді",
["Wizard stand not found"] = "Сиқыршы стенді табылмады", ["Auto Run"] = "Автоіске қосу", ["Run on join"] = "Ойынға кіргенде іске қосу",
["Show all themes"] = "Барлық тақырыптар", ["Hide themes"] = "Тақырыптарды жасыру", ["Live theme wallpapers"] = "Тақырыптың тірі тұсқағаздары",
["Also restarts the menu by itself after teleports and rejoins"] = "Телепорт пен қайта кіруден кейін мәзір өзі қосылады",
},
}
for lang, t in pairs(add2) do
if Lang.dict[lang] then for k, v in pairs(t) do Lang.dict[lang][k] = v end end
end
end
local function tr(s)
if type(s) ~= "string" then return s end
local d = Lang.dict[Lang.cur]
return (d and d[s]) or s
end
local function SetTr(obj, base)
Lang.reg[obj] = base
obj.Text = tr(base)
end
local function OnLang(fn) table.insert(Lang.cbs, fn) end
function Lang.set(name)
Lang.cur = name
for obj, base in pairs(Lang.reg) do
if obj.Parent then obj.Text = tr(base) end
end
for obj, base in pairs(Lang.ph) do
if obj.Parent then obj.PlaceholderText = tr(base) end
end
for _, fn in ipairs(Lang.cbs) do task.spawn(fn) end
end
local FONTS, FONTS_MORE = {}, {}
local FONT_FAMILY
local FontLib = {}
do
local function fam(enumName)
local ok, f = pcall(function() return Font.fromEnum(Enum.Font[enumName]) end)
if ok and f then return f.Family end
return "rbxasset://fonts/families/GothamSSm.json"
end
local function id(n) return "rbxassetid://" .. n end
FONTS = {
{ "Gotham", fam("Gotham") },
{ "Montserrat", "rbxasset://fonts/families/Montserrat.json" },
{ "Roboto", fam("Roboto") },
{ "Ubuntu", fam("Ubuntu") },
{ "Builder Sans", fam("BuilderSans") },
{ "Nunito", fam("Nunito") },
{ "Oswald", fam("Oswald") },
{ "Jura", fam("Jura") },
{ "Arimo", fam("Arimo") },
{ "Roboto Mono", fam("RobotoMono") },
{ "Fredoka One", fam("FredokaOne") },
{ "Michroma", fam("Michroma") },
{ "Bangers", fam("Bangers") },
{ "Creepster", fam("Creepster") },
{ "Permanent Marker", fam("PermanentMarker") },
}
FONTS_MORE = {
{ "Amatic SC", fam("AmaticSC") }, { "Denk One", fam("DenkOne") }, { "Fondamento", fam("Fondamento") },
{ "Grenze Gotisch", fam("GrenzeGotisch") }, { "Indie Flower", fam("IndieFlower") }, { "Josefin Sans", fam("JosefinSans") },
{ "Kalam", fam("Kalam") }, { "Luckiest Guy", fam("LuckiestGuy") }, { "Merriweather", fam("Merriweather") },
{ "Patrick Hand", fam("PatrickHand") }, { "Roboto Condensed", fam("RobotoCondensed") }, { "Sarpanch", fam("Sarpanch") },
{ "Special Elite", fam("SpecialElite") }, { "Titillium Web", fam("TitilliumWeb") }, { "Source Sans", fam("SourceSans") },
{ "Arial", fam("Arial") }, { "Highway", fam("Highway") }, { "Sci-Fi", fam("SciFi") },
{ "Arcade", fam("Arcade") }, { "Fantasy", fam("Fantasy") }, { "Antique", fam("Antique") },
{ "Bodoni", fam("Bodoni") }, { "Garamond", fam("Garamond") }, { "Cartoon", fam("Cartoon") }, { "Code", fam("Code") },
{ "Inter", id(12187365364) }, { "Poppins", id(11702779409) }, { "Lato", id(11598289817) },
{ "Open Sans", id(11598121416) }, { "Raleway", id(11702779240) }, { "Rubik", id(12187365977) },
{ "Kanit", id(12187373592) }, { "Quicksand", id(12187371324) }, { "Work Sans", id(12187373327) },
{ "Mulish", id(12187372629) }, { "Nunito Sans", id(12187363368) }, { "Fira Sans", id(12187374954) },
{ "Barlow", id(12187372847) }, { "Noto Sans", id(12187370747) }, { "PT Sans", id(12187606934) },
{ "PT Serif", id(12187606624) }, { "Roboto Slab", id(12187368625) }, { "Lora", id(12187366657) },
{ "Playfair Display", id(12187374765) }, { "Libre Baskerville", id(12187365769) }, { "Cairo", id(12187377099) },
{ "Mukta", id(12187365559) }, { "Hind", id(12187361116) }, { "Teko", id(12187376174) },
{ "Rajdhani", id(12187375422) }, { "Audiowide", id(12187360881) }, { "Silkscreen", id(12187371840) },
{ "Bungee Inline", id(12187370000) }, { "Bungee Shade", id(12187367666) }, { "Monoton", id(12187374098) },
{ "Codystar", id(12187363887) }, { "Faster One", id(12187370928) }, { "Unica One", id(12187364842) },
{ "Prompt", id(12187607287) }, { "Sono", id(12187374537) }, { "Builder Extended", id(16658237174) },
{ "Builder Mono", id(16658246179) }, { "Lobster", id(8836875837) }, { "Pacifico", id(12187367362) },
{ "Dancing Script", id(8764312106) }, { "Great Vibes", id(12187375958) }, { "Caveat", id(12187369802) },
{ "Shadows Into Light", id(12187607493) }, { "Yellowtail", id(12187373881) }, { "Damion", id(12187607722) },
{ "Tangerine", id(12187376545) }, { "Parisienne", id(12187361943) }, { "Italianno", id(12187374273) },
{ "Finger Paint", id(12187375716) }, { "Fuzzy Bubbles", id(11322590111) }, { "Rye", id(12187372175) },
{ "Kings", id(12187371622) }, { "Frijole", id(12187375194) }, { "Eater", id(12187372382) },
{ "Nosifer", id(12187377325) }, { "Caesar Dressing", id(12187368843) }, { "Akronim", id(12187368317) },
{ "Barrio", id(12187371991) }, { "Irish Grover", id(12187376910) }, { "Rubik Burned", id(12187363148) },
{ "Rubik Wet Paint", id(12187369046) }, { "Rubik Maze", id(12187366475) }, { "Blaka", id(12187365104) },
{ "Marhey", id(12187364648) }, { "Noto Serif JP", id(12187369639) },
}
function FontLib.byName(name)
local low = name:lower():gsub("%s", "")
for _, list in ipairs({ FONTS, FONTS_MORE }) do
for _, f in ipairs(list) do
if f[1]:lower():gsub("%s", "") == low then return f[2], f[1] end
end
end
return nil
end
local function hashOf(str)
local h = 0
for i = 1, #str do h = (h * 31 + str:byte(i)) % 1000000007 end
return tostring(h)
end
function FontLib.resolve(src, cb)
src = (src or ""):gsub("^%s+", ""):gsub("%s+$", "")
if src == "" then cb(false, "Type a font name, ID or link") return end
local num = src:match("^(%d+)$") or src:match("rbxassetid://(%d+)") or src:match("/library/(%d+)") or src:match("/store/asset/(%d+)") or src:match("[?&]id=(%d+)")
if num then cb(true, "rbxassetid://" .. num) return end
if src:match("^rbxasset://") then cb(true, src) return end
if src:match("^https?://") then
local getAsset = getcustomasset or getsynasset
local req = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
if type(getAsset) ~= "function" or type(writefile) ~= "function" then
cb(false, "Your executor can't load fonts from links")
return
end
local base = Store.dir .. "/font_" .. hashOf(src)
local function finish()
local ok, fam_ = pcall(getAsset, base .. ".json")
if ok and fam_ then cb(true, fam_) else cb(false, "Could not load the font") end
end
local okE, exists = pcall(function() return isfile and isfile(base .. ".json") end)
if okE and exists then finish() return end
if type(req) ~= "function" then cb(false, "Your executor can't load fonts from links") return end
task.spawn(function()
local ok, res = pcall(req, { Url = src, Method = "GET" })
if not ok or type(res) ~= "table" or not res.Body or (res.StatusCode and res.StatusCode >= 400) then
cb(false, "Could not download the font")
return
end
local body = res.Body
local head = body:sub(1, 4)
if not (head == "\0\1\0\0" or head == "OTTO" or head == "true") then
cb(false, "Link must lead to a .ttf or .otf file")
return
end
Store.ensureDir()
local okW = pcall(writefile, base .. ".ttf", body)
local okA, asset = pcall(getAsset, base .. ".ttf")
if not (okW and okA and asset) then cb(false, "Could not save the font") return end
local faces = {}
for _, w in ipairs({ { "Regular", 400 }, { "Medium", 500 }, { "SemiBold", 600 }, { "Bold", 700 }, { "Heavy", 900 } }) do
table.insert(faces, { name = w[1], weight = w[2], style = "normal", assetId = asset })
end
pcall(writefile, base .. ".json", HttpService:JSONEncode({ name = "KriegCustom", faces = faces }))
finish()
end)
return
end
local known = FontLib.byName(src)
if known then cb(true, known) return end
local ok, f = pcall(function() return Font.fromName((src:gsub("%s", ""))) end)
if ok and f then cb(true, f.Family) return end
cb(false, "Font not found")
end
FONT_FAMILY = FONTS[1][2]
local known = S.Font ~= "Custom" and FontLib.byName(S.Font)
if known then FONT_FAMILY = known end
end
local GOTHAM = "rbxasset://fonts/families/GothamSSm.json"
local MONT = "rbxasset://fonts/families/Montserrat.json"
local FONT = {}
local function RebuildFonts()
local f = FONT_FAMILY or GOTHAM
FONT.Reg   = Font.new(f, Enum.FontWeight.Medium)
FONT.Med   = Font.new(f, Enum.FontWeight.SemiBold)
FONT.Semi  = Font.new(f, Enum.FontWeight.Bold)
FONT.Bold  = Font.new(f, Enum.FontWeight.Bold)
FONT.Heavy = (f == GOTHAM) and Font.new(MONT, Enum.FontWeight.ExtraBold) or Font.new(f, Enum.FontWeight.ExtraBold)
end
RebuildFonts()
local function Create(class, props, children)
local o = Instance.new(class)
for k, v in pairs(props or {}) do
if k ~= "Parent" then o[k] = v end
end
for _, c in ipairs(children or {}) do c.Parent = o end
if props and props.Parent then o.Parent = props.Parent end
return o
end
local function Corner(r) return Create("UICorner", { CornerRadius = UDim.new(0, r or 8) }) end
local function Round() return Create("UICorner", { CornerRadius = UDim.new(1, 0) }) end
local function Pad(t, b, l, r)
return Create("UIPadding", {
PaddingTop = UDim.new(0, t), PaddingBottom = UDim.new(0, b or t),
PaddingLeft = UDim.new(0, l or t), PaddingRight = UDim.new(0, r or l or t),
})
end
local function List(pad, dir)
return Create("UIListLayout", {
Padding = UDim.new(0, pad or 0),
FillDirection = dir or Enum.FillDirection.Vertical,
SortOrder = Enum.SortOrder.LayoutOrder,
})
end
local function Tween(o, t, props, style, dir)
local tw = TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
tw:Play()
return tw
end
local function Connect(sig, fn)
local c = sig:Connect(fn)
table.insert(Krieg.Connections, c)
return c
end
local function UScale()
local o = Krieg._ScaleObj
return (o and o.Scale > 0) and o.Scale or 1
end
local function IsClick(i)
return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end
local function IsMove(i)
return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch
end
local function MakeTheme(bg, accent, accent2, icon, particle)
return {
Bg = bg,
Card = bg:Lerp(WHITE, .04),
Card2 = bg:Lerp(WHITE, .075),
Hover = bg:Lerp(WHITE, .11),
Stroke = bg:Lerp(accent, .16):Lerp(WHITE, .07),
Accent = accent,
Accent2 = accent2,
Glow = accent:Lerp(WHITE, .45),
AccentDark = accent:Lerp(bg, .62),
Text = Color3.fromRGB(236, 241, 248),
Sub = Color3.fromRGB(164, 176, 194):Lerp(accent, .1),
Off = bg:Lerp(WHITE, .14),
Icon = icon, Particle = particle,
}
end
Krieg.ThemeBase = {}
local function AddTheme(name, bg, accent, accent2, icon, particle)
Krieg.ThemeBase[name] = { bg, accent, accent2, icon, particle }
Krieg.ThemeMap[name] = MakeTheme(bg, accent, accent2, icon, particle)
table.insert(Krieg.ThemeList, name)
end
local function BuildTheme(name)
local b = Krieg.ThemeBase[name] or Krieg.ThemeBase["New Year"]
local th = MakeTheme(b[1], Krieg.AccentOverride or b[2], b[3], b[4], b[5])
if Krieg.TextOverride then
th.Text = Krieg.TextOverride
th.Sub = Krieg.TextOverride:Lerp(th.Bg, .38)
end
return th
end
AddTheme("Basic",     Color3.fromRGB(14, 15, 19), Color3.fromRGB(122, 132, 255), Color3.fromRGB(138, 150, 255), "circle",    "dot")
AddTheme("Halloween", Color3.fromRGB(12, 18, 18), Color3.fromRGB(255, 136, 38),  Color3.fromRGB(255, 170, 80),  "pumpkin",   "ember")
AddTheme("New Year",  Color3.fromRGB(9, 18, 32),  Color3.fromRGB(112, 176, 255), Color3.fromRGB(160, 206, 255), "snowflake", "snow")
AddTheme("Rain",      Color3.fromRGB(11, 13, 19), Color3.fromRGB(104, 160, 255), Color3.fromRGB(196, 132, 255), "cloud",     "rain")
AddTheme("Summer",    Color3.fromRGB(19, 16, 12), Color3.fromRGB(248, 182, 60),  Color3.fromRGB(255, 202, 100), "sun",       "dot")
AddTheme("Spring",    Color3.fromRGB(12, 18, 14), Color3.fromRGB(88, 198, 128),  Color3.fromRGB(126, 214, 152), "sprout",    "petal")
AddTheme("Sakura",    Color3.fromRGB(17, 12, 30), Color3.fromRGB(186, 140, 255), Color3.fromRGB(226, 172, 255), "flower",    "petal")
AddTheme("Valentine", Color3.fromRGB(20, 11, 14), Color3.fromRGB(238, 78, 108),  Color3.fromRGB(246, 112, 136), "heart",     "heart")
if type(S.Accent) == "table" and #S.Accent == 3 then Krieg.AccentOverride = Color3.fromRGB(table.unpack(S.Accent)) end
if type(S.TextColor) == "table" and #S.TextColor == 3 then Krieg.TextOverride = Color3.fromRGB(table.unpack(S.TextColor)) end
local Current = BuildTheme(Krieg.ThemeBase[S.Theme] and S.Theme or "New Year")
local Registry, ThemeHooks = {}, {}
local function Bind(obj, prop, key)
table.insert(Registry, { obj, prop, key })
obj[prop] = Current[key]
return obj
end
local function OnTheme(fn) table.insert(ThemeHooks, fn) end
function Krieg:SetTheme(name)
if not self.ThemeBase[name] then return end
local th = BuildTheme(name)
Current = th
self.CurrentTheme = name
Store.set("Theme", name)
for _, r in ipairs(Registry) do
if r[1].Parent then Tween(r[1], .45, { [r[2]] = th[r[3]] }) end
end
for _, f in ipairs(ThemeHooks) do task.spawn(f, th) end
if self.PlayThemeWall and self.Walls then task.spawn(self.PlayThemeWall, self, name) end
end
local function Stroke(parent, key, thick, transp)
local s = Create("UIStroke", { Thickness = thick or 1, Transparency = transp or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent })
Bind(s, "Color", key or "Stroke")
return s
end
local TextScale = S.TextScale
local function Text(parent, text, size, key, font, props)
local l = Instance.new("TextLabel")
local noTr = props and props.NoTr
if props then props.NoTr = nil end
text = text or ""
l.BackgroundTransparency = 1
l.Text = noTr and text or tr(text)
l.TextSize = math.floor((size or 13) * TextScale + .5)
l:SetAttribute("KSize", size or 13)
l.FontFace = font or FONT.Med
l.RichText = true
l.TextXAlignment = Enum.TextXAlignment.Left
l.TextYAlignment = Enum.TextYAlignment.Center
for k, v in pairs(props or {}) do l[k] = v end
if key then Bind(l, "TextColor3", key) end
if not noTr and text ~= "" then Lang.reg[l] = text end
l.Parent = parent
return l
end
local Shimmers = {}
local function AddShimmer(g, mode, speed)
table.insert(Shimmers, { g = g, mode = mode, speed = speed or 1, phase = math.random() * 3 })
end
table.insert(Krieg.Connections, RunService.RenderStepped:Connect(function(dt)
local now = os.clock()
for i = #Shimmers, 1, -1 do
local s = Shimmers[i]
if not s.g.Parent then
table.remove(Shimmers, i)
elseif s.mode == "rotate" then
s.g.Rotation = (s.g.Rotation + s.speed * dt) % 360
else
local p = (now * s.speed + s.phase) % 3
local x = p < 1.4 and (-1.25 + 2.5 * (p / 1.4)) or 1.25
s.g.Offset = Vector2.new(x, 0)
end
end
end))
local function AccentSeq(th)
return ColorSequence.new({
ColorSequenceKeypoint.new(0, th.Accent),
ColorSequenceKeypoint.new(.35, th.Glow),
ColorSequenceKeypoint.new(.7, th.Accent2),
ColorSequenceKeypoint.new(1, th.Accent),
})
end
local function ThemeGrad(parent, rot, spin)
local g = Create("UIGradient", { Rotation = rot or 0, Color = AccentSeq(Current), Parent = parent })
OnTheme(function(th) g.Color = AccentSeq(th) end)
if spin then AddShimmer(g, "rotate", spin) end
return g
end
local function Shine(parent, corner, speed, strength)
local f = Create("Frame", {
Name = "Shine", Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BorderSizePixel = 0, Parent = parent,
}, { Create("UICorner", { CornerRadius = corner or UDim.new(0, 8) }) })
local g = Create("UIGradient", {
Rotation = 18,
Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(.4, 1),
NumberSequenceKeypoint.new(.5, strength or .7),
NumberSequenceKeypoint.new(.6, 1), NumberSequenceKeypoint.new(1, 1),
}),
Parent = f,
})
AddShimmer(g, "sweep", speed or .55)
return f
end
local function VerticalSheen(parent, amount)
return Create("UIGradient", {
Rotation = 90,
Color = ColorSequence.new(WHITE, Color3.new(1 - (amount or .08), 1 - (amount or .08), 1 - (amount or .08))),
Parent = parent,
})
end
local Icons = {}
local function L(a, b, c, d) return { "l", a, b, c, d } end
local function P(...) return { "p", { ... } } end
local function C(x, y, r) return { "c", x, y, r } end
local function D(x, y, r) return { "d", x, y, r } end
local function R(x, y, w, h, rad, rot) return { "r", x, y, w, h, rad or 0, rot or 0 } end
local function FR(cx, cy, w, h, rad, rot) return { "f", cx, cy, w, h, rad or 0, rot or 0 } end
local function A(cx, cy, r, a1, a2)
local pts = {}
local n = math.max(6, math.floor(math.abs(a2 - a1) / 12))
for i = 0, n do
local a = math.rad(a1 + (a2 - a1) * i / n)
table.insert(pts, cx + r * math.cos(a))
table.insert(pts, cy + r * math.sin(a))
end
return { "p", pts }
end
Icons.home      = { P(3, 10.5, 12, 3, 21, 10.5), P(5, 9, 5, 20, 19, 20, 19, 9), P(10, 20, 10, 14, 14, 14, 14, 20) }
Icons.zap       = { P(13, 2, 3, 14, 12, 14, 11, 22, 21, 10, 12, 10, 13, 2) }
Icons.sprout    = { L(12, 21, 12, 11), R(3, 6, 9.5, 5, 2.5, 32), R(12, 4.5, 9.5, 5, 2.5, -32) }
Icons.cart      = { P(2, 3, 5, 3, 7.5, 15, 19, 15, 21, 7, 6, 7), D(9, 20, 1.5), D(18, 20, 1.5) }
Icons.navigation= { P(3, 11, 22, 2, 13, 21, 11, 13, 3, 11) }
Icons.user      = { C(12, 8, 4), A(12, 22, 8, 180, 360) }
Icons.search    = { C(11, 11, 7), L(16.2, 16.2, 21, 21) }
Icons.x         = { L(6, 6, 18, 18), L(18, 6, 6, 18) }
Icons.minus     = { L(5, 12, 19, 12) }
Icons.plus      = { L(5, 12, 19, 12), L(12, 5, 12, 19) }
Icons.sidebar   = { R(3, 3, 18, 18, 4), L(9.5, 3, 9.5, 21) }
Icons.chevron   = { P(6, 9, 12, 15, 18, 9) }
Icons.chevronR  = { P(9, 6, 15, 12, 9, 18) }
Icons.check     = { P(5, 12.5, 10, 17.5, 19, 7) }
Icons.activity  = { P(22, 12, 18, 12, 15, 21, 9, 3, 6, 12, 2, 12) }
Icons.sparkles  = { P(12, 3, 13.8, 10.2, 21, 12, 13.8, 13.8, 12, 21, 10.2, 13.8, 3, 12, 10.2, 10.2, 12, 3) }
Icons.snowflake = { L(12, 2, 12, 22), L(3.3, 7, 20.7, 17), L(3.3, 17, 20.7, 7), P(9.5, 4.3, 12, 6.8, 14.5, 4.3), P(9.5, 19.7, 12, 17.2, 14.5, 19.7) }
Icons.monitor   = { R(2, 3, 20, 14, 3), L(8, 21, 16, 21), L(12, 17, 12, 21) }
Icons.wifi      = { A(12, 20, 15, 228, 312), A(12, 20, 10, 228, 312), A(12, 20, 5, 228, 312), D(12, 19.5, 1.3) }
Icons.signal    = { L(4, 20, 4, 17), L(9, 20, 9, 13), L(14, 20, 14, 9), L(19, 20, 19, 5) }
Icons.clock     = { C(12, 12, 10), P(12, 6, 12, 12, 16, 14) }
Icons.file      = { R(5, 2, 14, 20, 3), L(9, 8, 15, 8), L(9, 12, 15, 12), L(9, 16, 13, 16) }
Icons.folder    = { P(3, 7, 3, 18, 4, 19, 20, 19, 21, 18, 21, 9, 20, 8, 12, 8, 10, 5, 4, 5, 3, 6, 3, 7) }
Icons.save      = { R(3, 3, 18, 18, 3), P(7.5, 3, 7.5, 8, 15, 8, 15, 3), R(7, 13, 10, 8, 1) }
Icons.trash     = { L(3, 6, 21, 6), P(5, 6, 6, 21, 18, 21, 19, 6), P(9, 6, 9, 3, 15, 3, 15, 6) }
Icons.refresh   = { A(12, 12, 8, -90, 180), P(1.5, 14.5, 4, 11.5, 6.5, 14.5) }
Icons.keyboard  = { R(2, 6, 20, 12, 3), D(6.5, 10, 1), D(10.5, 10, 1), D(14.5, 10, 1), D(18, 10, 1), L(7.5, 14, 16.5, 14) }
Icons.link      = { R(3.5, 12, 11, 6, 3, -45), R(9.5, 6, 11, 6, 3, -45) }
Icons.copy      = { R(8, 8, 13, 13, 3), P(16, 8, 16, 4, 4, 4, 4, 16, 8, 16) }
Icons.dumbbell  = { L(7, 12, 17, 12), R(3.5, 7, 3.5, 10, 1.5), R(17, 7, 3.5, 10, 1.5), L(1.8, 10, 1.8, 14), L(22.2, 10, 22.2, 14) }
Icons.paw       = { C(12, 15.5, 4.5), C(5.5, 9.5, 2), C(9.5, 5, 2), C(14.5, 5, 2), C(18.5, 9.5, 2) }
Icons.target    = { C(12, 12, 10), C(12, 12, 6), D(12, 12, 1.7) }
Icons.info      = { C(12, 12, 10), L(12, 16.5, 12, 11.5), D(12, 7.8, 1.3) }
Icons.shield    = { P(12, 22, 5, 18.5, 4, 16, 4, 5.5, 12, 2, 20, 5.5, 20, 16, 19, 18.5, 12, 22) }
Icons.power     = { A(12, 13, 8, -55, 235), L(12, 2, 12, 11) }
Icons.eye       = { A(12, 19, 11, -140, -40), A(12, 5, 11, 40, 140), C(12, 12, 3) }
Icons.circle    = { C(12, 12, 8) }
Icons.dot       = { D(12, 12, 3) }
Icons.pumpkin   = { C(12, 13.5, 8), R(9, 5.5, 6, 16, 3), L(12, 5.5, 13.2, 2.2) }
Icons.cloud     = { R(3, 5, 18, 10, 5), L(8, 18, 7, 21), L(12, 18, 11, 21.5), L(16, 18, 15, 21) }
Icons.leaf      = { R(5, 6.5, 16, 9, 4.5, -45), L(3.5, 20.5, 9, 15) }
Icons.dollar    = { L(12, 2, 12, 22), P(17, 5.5, 9.5, 5.5, 7, 7.2, 7, 10, 9.5, 11.6, 14.5, 12.4, 17, 14, 17, 16.8, 14.5, 18.5, 7, 18.5) }
Icons.grip      = { L(20, 12, 12, 20), L(20, 16.5, 16.5, 20) }
Icons.gripV     = { D(9, 6, 1.6), D(15, 6, 1.6), D(9, 12, 1.6), D(15, 12, 1.6), D(9, 18, 1.6), D(15, 18, 1.6) }
Icons.image     = { R(3, 3, 18, 18, 3), C(9, 9, 2), P(21, 15, 16, 10, 5, 21) }
Icons.type      = { P(4, 7, 4, 4, 20, 4, 20, 7), L(12, 4, 12, 20), L(9, 20, 15, 20) }
Icons.globe     = { C(12, 12, 10), L(2, 12, 22, 12), R(7.5, 2, 9, 20, 4.5) }
Icons.panel     = { R(3, 3, 18, 18, 4), L(3, 9, 21, 9) }
Icons.palette   = Icons.sparkles
Icons.star      = Icons.sparkles
do
local g = { C(12, 12, 3), C(12, 12, 6.6) }
for k = 0, 7 do
local a = math.rad(k * 45)
table.insert(g, FR(12 + 9 * math.cos(a), 12 + 9 * math.sin(a), 3.4, 3.6, 1, k * 45))
end
Icons.settings = g
local s = { C(12, 12, 4) }
for k = 0, 7 do
local a = math.rad(k * 45)
table.insert(s, L(12 + 7 * math.cos(a), 12 + 7 * math.sin(a), 12 + 9.6 * math.cos(a), 12 + 9.6 * math.sin(a)))
end
Icons.sun = s
local f = { D(12, 12, 1.6) }
for k = 0, 4 do
local a = math.rad(-90 + 72 * k)
table.insert(f, C(12 + 5 * math.cos(a), 12 + 5 * math.sin(a), 3.2))
end
Icons.flower = f
local pts = {}
for i = 0, 36 do
local t = i / 36 * math.pi * 2
local x = 16 * math.sin(t) ^ 3
local y = 13 * math.cos(t) - 5 * math.cos(2 * t) - 2 * math.cos(3 * t) - math.cos(4 * t)
table.insert(pts, 12 + x * .56)
table.insert(pts, 11.2 - y * .56)
end
Icons.heart = { { "p", pts } }
end
Icons.settings = { P(18.85, 9.78, 21.45, 10.29, 21.45, 13.71, 18.85, 14.22, 18.41, 15.27, 19.89, 17.47, 17.47, 19.89, 15.27, 18.41, 14.22, 18.85, 13.71, 21.45, 10.29, 21.45, 9.78, 18.85, 8.73, 18.41, 6.53, 19.89, 4.11, 17.47, 5.59, 15.27, 5.15, 14.22, 2.55, 13.71, 2.55, 10.29, 5.15, 9.78, 5.59, 8.73, 4.11, 6.53, 6.53, 4.11, 8.73, 5.59, 9.78, 5.15, 10.29, 2.55, 13.71, 2.55, 14.22, 5.15, 15.27, 5.59, 17.47, 4.11, 19.89, 6.53, 18.41, 8.73, 18.85, 9.78), C(12, 12, 3) }
Icons.sprout = { L(12, 21, 12, 11), P(12, 12, 11.8, 10.97, 11.56, 9.98, 11.27, 9.06, 10.91, 8.24, 10.44, 7.54, 9.87, 6.97, 9.19, 6.54, 8.41, 6.24, 7.52, 6.06, 6.56, 5.98, 5.55, 5.97, 4.5, 6), P(12, 12, 10.95, 12.03, 9.94, 12.02, 8.98, 11.94, 8.09, 11.76, 7.31, 11.46, 6.63, 11.03, 6.06, 10.46, 5.59, 9.76, 5.23, 8.94, 4.94, 8.02, 4.7, 7.03, 4.5, 6), P(12, 10, 13.05, 10.03, 14.06, 10.02, 15.02, 9.94, 15.91, 9.76, 16.69, 9.46, 17.37, 9.03, 17.94, 8.46, 18.41, 7.76, 18.77, 6.94, 19.06, 6.02, 19.3, 5.03, 19.5, 4), P(12, 10, 12.2, 8.97, 12.44, 7.98, 12.73, 7.06, 13.09, 6.24, 13.56, 5.54, 14.13, 4.97, 14.81, 4.54, 15.59, 4.24, 16.48, 4.06, 17.44, 3.98, 18.45, 3.97, 19.5, 4) }
Icons.gift = { R(3, 8, 18, 5, 1.5, 0), R(4.5, 13, 15, 8, 1.5, 0), L(12, 8, 12, 21), P(12, 8, 10.5, 4.6, 8, 3.6, 6.6, 5.2, 7.6, 7.2, 12, 8), P(12, 8, 13.5, 4.6, 16, 3.6, 17.4, 5.2, 16.4, 7.2, 12, 8) }
Icons.upgrade = { P(6, 12, 12, 6, 18, 12), P(6, 18, 12, 12, 18, 18) }
Icons.panelLeft = { L(4.5, 7, 19.5, 7), L(4.5, 12, 14.5, 12), L(4.5, 17, 19.5, 17) }
Icons.book = { R(4.5, 2.5, 15, 19, 2.5), L(8.5, 2.5, 8.5, 21.5), L(11.5, 8, 16, 8), L(11.5, 12, 16, 12) }
Icons.palette = { P(14.46, 21.18, 12.88, 21.46, 11.28, 21.47, 9.69, 21.22, 8.17, 20.7, 6.77, 19.93, 5.51, 18.93, 4.43, 17.74, 3.57, 16.39, 2.96, 14.91, 2.6, 13.34, 2.5, 11.74, 2.68, 10.15, 3.13, 8.61, 3.83, 7.16, 4.76, 5.85, 5.89, 4.72, 7.21, 3.8, 8.65, 3.11, 10.2, 2.67, 11.79, 2.5, 13.39, 2.6, 14.96, 2.97, 16.43, 3.6, 17.78, 4.46, 18.97, 5.54, 19.96, 6.81, 20.72, 8.22, 21.23, 9.74, 21.48, 11.33, 21.45, 12.93, 21.16, 14.51, 20.61, 16.01, 18.2, 16, 16, 16.4, 14.6, 17.8, 14.3, 19.6, 14.46, 21.18), D(7.6, 12.4, 1.5), D(9.6, 7.6, 1.5), D(14.6, 7.4, 1.5), D(17.4, 11, 1.5) }
Icons.pin = { P(6.37, 12.75, 5.89, 11.72, 5.6, 10.63, 5.5, 9.5, 5.6, 8.37, 5.89, 7.28, 6.37, 6.25, 7.02, 5.32, 7.82, 4.52, 8.75, 3.87, 9.78, 3.39, 10.87, 3.1, 12, 3, 13.13, 3.1, 14.22, 3.39, 15.25, 3.87, 16.18, 4.52, 16.98, 5.32, 17.63, 6.25, 18.11, 7.28, 18.4, 8.37, 18.5, 9.5, 18.4, 10.63, 18.11, 11.72, 17.63, 12.75, 12, 21.5, 6.4, 12.75), C(12, 9.5, 2.4) }
Icons.home = { P(3, 10.5, 12, 3, 21, 10.5), P(5, 9, 5, 19, 6, 20, 10, 20, 10, 14.5, 14, 14.5, 14, 20, 18, 20, 19, 19, 19, 9) }
local IconPNG = {
_pumpkin = "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",
activity = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACg0lEQVR42tXYP2/TQBjH8e9zsVADoguiUrMgIXVA6cAbyCtgQ91Y2BC8oQqEYIGpVQfE0oUBEQlVYu7G1grUsgSBoLHvx2An9b/Y9Smo4FviRGf7PnfP81xs4u8ejku/gcOw8AexyyVyGJuMGTMMHoWamhP6IEkaZ2edW9OPJtTXVyWK9VODsFu4FqARa4Docy8MqamLIbYAjwFbCL/MOUiBjiQl8lIokmsc24gBCQ4jDkVyDUCwBcCU37hgpFYg6a1eSErCkFwL0Bmww0tgGoi04M6R0DNJsc50Sys6lZe0330E7UDvhdDrUCTXCrQHwE4wUivQbSG0qpMwpIsAOUVCr8KQ3MIcdA7kEMZuIFKWlk0ml7UrJSAna0Eq9nfz84WrqKcj+TlQ+k0gUoRD3OEpK0wwhCGuMSAmyoA8YBi7PMiQnmffkgEO2Z73T7PwKr94xCGWPsuBykecA5pNfD3SedUrHwdCbtF09ejxic/zJxU9JuxjeEYM8NlEG54+G3ji+gtFgPGQbW5iWG7mT3gyP2chksMzYo2EiGO+F/o/xvKBZpVYqEZHFSkfkhs5OisGmqu9oKusrfJKKoekVfunkh5hGYNln6rFxSrhVsxZloEX+3fIK1WkqBKSnfZFdQFYRLJSzuq4L6qr03kkUClndd46tiG1AnUlKiKtK9JxM5A6l/A80oi7rLcAEXW8QYJ4xyk3gPt8AXpMeQMLd0wKR/qhiZJmIAXsl2dI4irX8c1AISOYraTZprhhBYWNYJa4hccDH3NJfUl/Y1Mky+rXXstVFIr0TYmmbUAKGoFwTDjEERWq3tJGkFaCTY011rCmbhSa/bvvKi74isH++7ctfwAeJQR7yH5mkwAAAABJRU5ErkJggg==",
book = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACR0lEQVR42u2Yv2sUQRTHPzM7oGiUqNiciFgFvUYwKQRFBO0tBFtT2/pXWIvY2Qj6J4iCjZwiCkEk1mqtFtGQnLc7X4udnIeZmd0ld6S5N9wWN8O8X9/39vvWiNmKbdw3mMZTGTH76YHF0GfAgP4evFBqGRWyeidJeisrp0I2uZL3uFTosFQQnifw+HyogWi0XdKxitMcYkgBFCwBhlTCtvma3I8Gx+iInuq3KjWLV6UtPVdPxEIVU1AIPZMkVfLhklFm1afeyLVTYIVOaaSylf0aGyAtB+NaJPkoDo/lJT36wHceJGJs8VzgJiAW28HUCi1JGkm6qyeSpPU0DIVuSRpKutbegx1Z4EDAmgMKPGARJthWg/nYBFRbw7QWH4IiSqBMnNrIXeFatxRxnkccZGOcC4NY5Acfcy3Hdegpj1mJ7tzIKbAzbqYdPDCs8pCTmIlkCsMXPnEPnzK1rQIPrHN1Vy04Sm6H/T2HqMBGS+3wdEL0D/n/t2mmpaCaeE7+tzmvg3kddKiD3a8cTbMOPMKM3wY7IaryhMbRlaeBpkl+Z86u5wr2u5JtgKTBJYiXazIyr2CTIQBlkrKUwK/uCmz4XeEsAMe5k/TRczl4Z9tTxzOqxsy6nZSSLsWoY2wItIgXXKdCWCwgRg1AcXzmIn9qxt40gFgZ9fRaXWRN5+IDSHyMrfGywgL3WQa+sZoZkWCLD5TxfZdkD/A+zGqwzasWFeW7DYEGhxAF8DNwImVaue86J9e56GuggfoyuVk4t8z8Y0iT/AVnppMw/mxL9QAAAABJRU5ErkJggg==",
cart = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAC7UlEQVR42tWYu2sUURTGf/fObEziA1MYiZpGwZAHJASJhYWClaU2+ieIhaWFvfgXiLEPlnbBTggoxlfUgFHTrGlECCiEiDE7M5/F3l3j7N15bDaF9zazM2fv2fN95zvnzBqxt8vu8fmEzo0A4+7Vr5PuODDa8wgsYpQH9LKBAcQhtrjOSpeikBV6qfR6rvqTXW8fyTEJkwySNFnZFQd1iO5zBIMBBhgkJuAiTwiIdw9RYxuhUOiKpF+SbrnPXYHIYhAQA8vEVIBpl7Bd0UECzoVhjTVOAlOEiKADJ//qKBVSIPRIUqxtDXUji8I06cBbLhNTYZ4fLq4SSdOiI08ElyTF2t1abOgorYMEWGYLizrUcUyNmH53VgtEAF+pMgqI1dIU9zNMQsBTICRqhagO0kNJkWoaKVUwKjK66VR0raEi66EJXgA1QqZ2FPEi4IgLQA81FhsQWW8Wv3dPpjFYwBTaCX2cBSyfWGvkX6uDBPjAJhXgDCL24ejZBhjnGDXg2V+J+iIwrPMRA0ywv3BNtcA5V24WsntyACwDEYOcKsyCgPNpBto3/VdA5EqeLaTgmF5m0gz4v5wAb1wkM4VLBExwPM2A34GAVb5TASYdqh0y0M6BZYMVAMYYcBnSEQPt8LXAa2Cbw4xhCbGZO0D0+RjIInDJ/Y5xEmokmTsmYcTHgL/Y1Q9+R0IP4jZXc7uCQQy564Uik51B7KPKUURQohaBOE0Vm8cBWH5TxZY4HgIClviy8/j2s6lFjHOvOS0Vm3/WuZEeOfOG3zI92WtrM8VTruXLFfdS47spPRF5B6/sIhADAUnbaEyWTZEXkD4CNju1sZnwWELu8plVZjnozad8m4wuGAjdaY5Sc+5OSZv2xxuhfn1TpEixIkU60TLEFLCxOQSHzUyyVDqyyYFoVlKiRNJjGc8QlmuT5cDI6oDm9FNbmteQ10GuTZE0HSakmlM22trkK9m49x8yhJZhUyQCu7PHlrUx//2/LX8AKpP54VNh3ZsAAAAASUVORK5CYII=",
check = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABhElEQVR42u2XP07DMBxGPzvpwszGxAaBDVY2JEYOwQE4BBfgEIiZO6AMldgYWREdOwFKSvMYGqkhcRKbhAEpqVRV+fM9/+xn1zHobw+rCTABJsA/AlgZmWaeGWmpMOIvK4iEDpUqVdKoguEfg2WHZwDmCIPZXrUjdE6kQvc61qcKR97g9seIWyDnizVniKh6fYz4ayAnB67q8UMBMeISWJEBN+WZ0QAR4oR31mTAHSKuDu9QgEXs8QpkwCMzomb87wEbNZ/K+Bd2MVjXna6WmbabK/Ex4gHIKFhy0Bzc/gqsp5oF567BdQMshoSUlKTjoaaas/bG/CzcIOYALFoRTTVnXd3pBny0IrzU7Ouit9KNJsJTza5BtoiEhRPhrWa3RXELIkDNPk3diAA1++dBHXGEQtT0mWh1xD4X/mr6zeQ6Ygnkfmr6LnZbxArKby81/VfTahUBaoYs11sE/mqG/R9sECkpp+HxeO3srIrGL/9dDX77TiSZ8Pjx9qbT+8EEmAAdxzdA4fhyvrK/0AAAAABJRU5ErkJggg==",
chevron = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABG0lEQVR42u3WMU7DQBCF4Td2LkBn+hRoD4AoOTgpXaSHioYquQAoigD/FBhkO+vd2YKK9UquZt7nsYuxob+9GlWgAhWowL8FGpmsAE/UG+nGwRU/lEzQyBTUq1fQoE02vtWgm7E+NgXzYxhiD8CRgNigxGkR1zwDsP/tn5z193xSp52CPhJTtPpUpwdtdZJk0ZqLZ2owAgfgnJmiRXQ8jZWv3GK0y6pYY4MIHDPEPP6N+7HTAXzHpYlYfHTOtY+XJtzx60CKKIhPAWtEUXwaiBNF8TlgSRzYclUSnweWxAuPJfEeYEq8w3h3xvuA+RTnkngvMCWK4v3AD9HTc+ePJ7Nw1haLbxE5NtolgSTzx5cC9belAhWoQAXi1xfcoSykn32/OwAAAABJRU5ErkJggg==",
chevronR = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABK0lEQVR42u2XMU4DMRBF/zhuuEFOQOEDIEp6zoxEs0UOECREn1BQwqJAtI+CBAkRktnxbhPtTjv6z+Oxv2cNjfslTYAJcAaAJJPFF2L4l9INX0GSqahRo6JOOVQC/4dhiAUAawoio77h29t3zXWnom2giqP8hFFYAZtoFacSEqKwjiNOp+Q6hCepCuFLq0B4Sw0j/O0KIvocuRCi3708hEhDAvaIZ+ADWFGw44je3kJGXPJExwZY/HhWlRf99hbpRe3e7uu86G/MEHMegE/glSuM2XBb9C2/3DX5jZthm3xIfsBjGpL3A4LyXkBY3geokPcAquR9T2aFPK5H/zEuj3MuaqPyXi+6UKtb3StrO8Zc1NBwHZvrGH/4zQ5hJFlMvs/4Pv1CTYDzBXwBWbEF35iIt7sAAAAASUVORK5CYII=",
circle = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADlUlEQVR42u2Yy2sdZRiHn7mcBIONNDQxIlVbYkNbtBgEhUINil2IRV0Igoi61K1bRdA/QRRdCCJKF64EgyhSrYpZKIiYqm2watVGQ1pa7bE5l5nHRb6c5tznEEWQzreYmTO/9/7yXk4k/+4Vc1nAfy0gHQgdhbv/tICIBMgajCNiInLyAqT2d2JEFp6HGQFWuRjeE+wnJO2jeUwGjHMXs+xjklGgzG8c42M+4GcgIe/pMrufWMTdvuyyna7zvuFtG5AdT3f2iZj6vGVVV603Mc9cDfcXvSqgO55uMUjIuJ432Q9UGAZkkR9ZAia4jmlSoEpKzLc8zJckjUgVcFEi7vEXtWKunvRZbzZtfI+c9im/Drbpn852s6Kb77d7Wq2oNZ92tPElNW0wGvJJzwVU2ZnOsWhnH5k45HwgPO1+EVNjow2YONiz24WAPOnWJkxXAYn4XCBacq9YaicLYkripMcC+vVObmp3T+QuV61Zs+LtYsleqZyKOzxr3ap6oF1EJ/1fCaF7pi97AuKRYMN77XFoNRrHPGtm7imv6OTTLjn3uVq36nSriLgl++EgW6kS8SoXiQvVzQh4AahR4v7WFtDeD2aRlIy3iIpUSyAD5viDYeAOaKFqc9G8qieMw3uRE4tHVP3JUjNd3GSqDHEtAN+TF3TQeklfBGQb471b5pVsAeD3AdupLAEZI4xu6Hw9mOQDN9+8WNP/izIAE4N1XiKuBmIqlJsp4yYzI1ZZAmAHEdlGU/toL1NAzArLvSxIgAUk40Z2Nvuyp/Y5W5hB4DiV5uRoj8FRImqUuK9wmBMi7mYbVeCTNqq2fL7GC2bqd6YmhUvFEbVm5i2tpaIT+HAodk8UKnapeI9aVT/rV+wwMXLGzJp1z7srMOit/ZinzK2oh/qX6zXAS6H8fuNkTytSccSjAT1XpOGstcxRjweiBafEyLQlGpGJsTjhh2E0WHG7UXtX7la6brIcRJzx0aaWn5o22BzyB7Viph7sPFd09+ysF0Kwdd7HnWxCjPmg7zfGFn2oW7R6DV63cpgpMjKGgHN8xSK/ApPsZB8TQB0pscxjvEtKfbDZdC0/XmsaFDde68Pk297QK9f6pSDe6ZzVwDS3Zs28IeQjH9iAHGg2bR7f93IvB9jDeNgPVjjBp7zDF6Ew5JtZQC4tGcOMhf3gTFhB1hXY1IazVhLjloWp/ZdNCbg0nkSNzChKdPmvhP+/gL8Bgu/UrY8IGzEAAAAASUVORK5CYII=",
clock = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAE4UlEQVR42rWYW4xdUxjHf2vvM6PTSVXTTjXaaBEkKhKK6IMoVeJR8IQQHry5xAMVTxIikZg+ubwIkRBCCW8jOom0DNK4hBZNWuoSUZ2qSzrnsvfPw1lnn32uM9Ow98M5e+31ff/z/b+1vu+/TpD/96osanaIn/63AIGEgOQlx2nPyCDjeWYkJDSKpzGWADX+KQFJfrIAgYQMGOUyruRy1jPBOIETHOEwe9nNDP/MC+KgOxXxLB/zOwdd3zvphaXZfe5h7k930uOq1qz2OG+NVX3Bs8XE0M9TP4oCgZxb2MEZQJVTADjG9/zELLCcdaxnAoAqowSOs51ngdAn6T2YwcTgU6rOqfqrz3uDEx2zVrjFSQ+VZr3kmJjMR1EwEV9V69bU33zQVcU7ur4t824PqQ1r6rRLeyG63Vei+6oN9XXPELFiampwo3vc40aDqakVEZf7jJpbVacdM+3MRSdARXyqcP9wHAtFZDOqflikNESQO61HiNeil74AqXijWrOu3iZWioCDQdxrw4YHOmhqgmy1ZmZVva9z0Xayv8rfzK2pD4kjHdEl4pSq+7sy0px5q1q3YdXzYrxdAKk4GdfEzoKaToD3Vf2mB6AJsSNav12OoWy+zr9tmHnUifJvWBBAMHXUA+bWzN3UhkiKogb3ME6DhCc4Qjq8hPXZTlDjIQISuL97owWDox40N/eIy2NKFxNBM4ep+9TcP13VmpHE3y+bOIsGgZ0cJ2XxjU4SMl4GqixjK5C2qGl2qquAHNjZt6Is5MqBd8ioIFdT4r7J4OXAKMf5ZL4WMjQP+zlIhcAmIGsD5MAGIHCIY0XnHewoNMPvGU/J+RaAtYwhoR3BElYD8EPMSP8rA6SCZCR9QAJwEMhZwarmcxKHlzIOwGxJO3SaCqwkI2MDU2wjGwByFMhZEv0V+2BhkqVOiiRsY4optpGTEYb7aL2sMgfAqQNUj0DgbmYYIaFOowDpXhLLgYRa9FeqRV+o+mmfLdTZZm7yo9iT66ru9oKisKTiW7ELjjct2oXuXVV/d9kQiFZ9aoPMqR/HWtC0+lrVzzp3cgD2IjVWcvEQVvO4P99kMzczw0gUBO0sncO5ZMDnrZ3cjuBqtao+3d2TBmomvMndJYoq4r3qCfXOlpc2u0v9xVz90bG+xW4QSCeBn6qZJ1zbIrTcjVsN464FxNACCR0JvkatdbacMvp51qyb+aPjg3TawLvZmfdGgC29AM2BF2MMz/V05PnuEXF7zOJ0WR2VGQye6d9RRN2xKIgR8Vpz69bVS/v15FYM90RV1HCrOLIgokbECz0WldETg2RLK9Uvq1Vz57y9GBueZrzO2UjPLkOntqNHGyxxOk7Wpx2LIEmPikgKzbfdLFp81atH+q3lpU6rNRvqPm8pYkitxLtNwfXOFMr0K9fMJ35bEOO+UhLmX/qIF3VRFTzf+6NWrZqp77m63/brdwBJyIEHeJwxMjJGATnAtxzmd+A01nMu51MBGkAFeZJHyaPlAs5oTR43+kY8Ls3Z6DlCZTE+nXJzYbPgM1or2Ct80dnCaXOlZ8XzX77ptuGHwGHH2CQW6DVsYQuXsJYV8Zz8Bz/zBR+wi8OleSd5EA9NfQOMs4JxYI5Z/urz/qQAmo0kBbKuXp0SyOeXaMHF/BUSSitjoUb/9985/wLNp73t5bfP/AAAAABJRU5ErkJggg==",
cloud = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAC70lEQVR42u2WTYscVRSGn1vVXSh+bDRCElDHqEiiCxcJQxJBRJeKSiAr8ReIvyB/R8FFUEk2whASph0UEYQICiKCZnA2IkRlurrqPi66Zuyu6VtTJRhczDmry1t13nvvOe85N8h/axlHBEcERwSjTjQQesSQDrWGJJYjsfc9BOJqmtUEARB4iOM9zrDD7w1NTJyv5ZmIb/mJd6yNRlMWjUZ3/Mx3F/5c8tXhH/VqE6JydqjP7aanVlEcDJ/5iLfV0tK+VjlVt336IEU7BxmRT3mdkgLYZMJuk49Ursac5TWgpOBrzjNrVdUSXy6+oU6tvevb0tNfdludqu+Jo/QV5eJ1o6X6pjjq6XjWqTOj3xgMhtUEQXzQHVU3xfHih51eiB+qtaVPLucha93oSY5RATcI3QpdskjGBlAxZq2JlOhFe82hGthy3P8jSzc7gV/5jRFwAXv1ob1tyQUgp+bnVtUdENmG0dLai2LRK8WFeMq7Vka/N08neV5g7zQFt+167zJ9zm/VXfVKu0yXhRYIZNzkPCUFNR9xi2lnqgMj1rnMA5QU/MiL/NEltPklrTWyifa3XfVPzx1sFaub3bNuqVo77eGVqt+53kj1EII5xdj3/crdXrufedsrPrwqvImBszc61niix9j8hR+IqYGTGpmBfJDYRtRDRubirO039B0+9O/JuyhrlNF3/f86QUbgeSZMOE0gIyNwprVexLszlFDDpqpfiMFMnLTW/+BZajiNkj0mcj/PUDfNNxAZ8/j++62NO/SKMgIv8Rg1OR8AY+AFTlCT8zFQtPA8RZF1jJBLQM6Ma80OX22+3gBiC4/DchDE+7yj6q3mOYYbqv5kYTC08GQus+S5XuEEJXAVyIkc4xwRuEFJgUt4dqjOW/sP4paVU0ufap4ll5quf1kct/COE6QJvlR1a78EP7dy5l8eb9ryIs4wgnnI006ceMbQEMwDTpqMLOODCQ4jpL+HDoXsCezf4YObXc+A97yb/g3kLJ+xTGVEWgAAAABJRU5ErkJggg==",
copy = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACdUlEQVR42u2YvYsTYRDGf/PueiZRvELSCJr2EOQQe41XWSkWgv2B+K/YiaL4J9hYWqYTFS1s9LzCr+YEC0UPuSSX3fexyLLmY7+S3FlI3mkCO8vzzjwzz8zGxOEexxKg5IQTcAJshveH/j7fwfTPInCIszyixi5GFVxDnKDHbbYKotDQTE7opeY5z4WcyLZwLJtHiPEElakXMUYT8HlRh6mrQ3wnACI+VwQ4TQ1HVL2KAiDgA2tJhosL3NNho6zqXGEBlhXozH3wtz6qRTA3gCrcUdViWEwq4vKLhHPqlgGOJgJWcIlgaH4AhzJy/hMDvqRPgiSmmQGGhLaoTUDe5xzwgDWMPp+IM6hPm9oJdSRJ24l4jD65rGfqysunAuElddVXX11JsXp6o+vTolEOEAhdVCzJazBhsSJFipPfknQjeWMGACfTK0n9UtEbSNpRQzYSfSkHDk+L83hWeM3TnPZyeNq0iTjFOi9Gya5CcoOQCMcT7hR4vaeNRxybvYr8CFCYqZ0hEceT/vDzN5onghxxjvKUabkXzSnXLp0Hhi12iTCTzHHC9g4OIAY8LTrp3rPKLnfpcnRRgGFCThLjabAx5nNhkSSFY3vagIDgcEgWhrHJQ5pYuogI2OEejw8iAg+849LENhEQc4Y6EQ5HmFN1YX7BT6/vmqgoS1QG9ohyhQJ+p5koAPAJFzaSOE8PjwFX+FYg19cAh7GfNzKzzWQKtCWvQenAieT1Q6tj47YUYDgAryYTq19gwwts5o/MfHNCN/WxNIKvujU99E1V15Y669RzdmkB+7zl1zRHVb/RMlaqal7VPwLLVTVzdbTlXwn/P8AfFlF5vblVifcAAAAASUVORK5CYII=",
dollar = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADRUlEQVR42s2YPatcVRSGn73PmeRqEYwS0iikkBi5hUb8qGwUTGlvIYqFChELQcFC4w+wEBPEHyBaiGAhiBCxGu4FW4mIH4XgFS/R5BaSO3P2fizmZD6uc86cM7mCazfDMHuvvdZe77veNUF6WEQgkLtvCb0crGGxxy8DmwwZsknosc9uKxjFLVWHYuy4j7LHTWBAAk4AmUCn7Jadj4/IVQqg+m/eAKCYFEafLWXn4oxzR08+O5e8xtItO9w6QZ2YSXLyksNcDwcRyDzARTbYA85yHPibrdl+5Bg3eJErDVG0lFgp4nn3XG3bYjD0K9OK+3iPc8CII+siebmDABS8ylscY0zkCNf4ncA93A6M+OVACnZ5mdAnRYX4vqpjVT/ybgvxsqrf19ieobwnkgMJeIpEZsAOr/HxEsQ49yn0K1OJZH7lNIHfeJgdStICwMIcDiRgc5k2P3IAItfZoSDVxyze3lUYaKeKUMNs0Ke99HFwE7VjrDno0BxMknEXmcQpLrBBRUG5npvYmJ4xkcRR3mabcyRGpDpZgZKC2JFVl1ZvNLjptqo3VP3M533MoarfLeBlxWpukRh9xavq2FQzTjaru77kE57xZH2ZtRxMosBTfqJq5ciReY7ekn/6ek2KYR0HMz591r+mMUxs5MhK1W98sD2OVTmMRvGkZ3zcF/xZTdM4kiN13wsOmhmpi/SYPeWXavZHH/UZP1V1X9Vv3ayFzVoOJqpoYOnXql6pv33an6ZOGrVS7FjLmURVs04gUlLyOQ9xiX0K8lQr3aJsuWmZikTBdc6zRUFs1krlLfBYooBac4TDEV7LWlM6TGV3MPoKuAOhmdJjq1wPxIU1U3aRQMW9fMUjVCRu6/8G+UC3yv9Sds/xLndSMQC+mNOAHZRdRO7nQzbYm7bKgFNlt40c5yywz1Gu8Q4XSQ3NcymsgtRk3WYjk3rZ020gvZVHHpB4kyf5oa3Y21L0AScICxU+U3YCf/AGW22aaPWMFhZ4dVHZxW49rWwdO2yZADKh1oBrTji5rpywoOZmuiOSu4yB5crJ0rlDq2lWwcOb0ea1UupLkGUPYpMxBbALxM6CsuvEXmulocPm9rhs/Y/+DJln2B72DzKGrPD3PC0+AAAAAElFTkSuQmCC",
dot = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABQ0lEQVR42u2XPU4DMRBGv/FuRJUUqWiSigYOwYHgBFwBLsAlKLkAQsAFKFgkgqBAFEjQZaNdP4osP5vGXm2ChGS7sWzPPI/8zVg2tNnmlAAJkAAJkAB/DzDZpgCmXCZEM4o1I9b9cuNITu/N0fz6IjChXIe6UKFCNzrSUD7SlnB3iG0u+d1u2WtWAj3s3nBscQ2UVHg8NSXwwBiH9QfkiAOgbEVQAifNak+AQ1xRU7UANZ4ZAxSKwQWv12uoHbmVnSbTRFMpJFgXpbSs03wnADJ9aCa/onqEXvQkib4RZJLO5FS3ZmuZzjVXHgLEyXTEHVBS4/F4FsAbEyycCbGJtkvRUtEr++tKtC/EmGPuWVDxyClTRBZjG1vslqVtoIkyPWseX+yM+HKdqfq+eOLcdwH8PDeog5GlD0gCJEACJMB/AHwCu+u4w5jAqI0AAAAASUVORK5CYII=",
dumbbell = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAB4klEQVR42u2XvW7UQBSFvzseJcKRojRhixQoVUKRhjegoOABUMQj0EBDkyIUpKJMRZUXCA+wdLwAQkpoqFCERBFFKNVG/KznUOyw8d3NbuwiCAl7Co+tOefMvXN/bBM3ewU6gU6gE+gE/k0BI2CtmWagTNML5e5N6WegwhULSzZYQS2smIcSQoVQIZPJtKwjJX3RHZmCaDCmUZYZEX5pFHos6buknfx8/ZiLCgRgl2P2WQDgFolEYrHVEXvUAvscswuESOIhL4EtPvEaSASMQGolUNVQQ57wFNjiPf0IlFT8YJElBykwrFGeGEYxngMsZcYSInBGQaTg1MEGiF+Ndp+AgXtzmhnPRgJ/1KML3nu85Tbn1+SDIVb4xpEL+Tj2Qo2UGlEAtludwQMnoL9Yi6Izt+7VQ5ZZb5DPwjjhI89rcWdeoMrzoRP4wCti7d28TQ7ZzijPVI1ctErFkIqeg5WEhuVOhIkQ72XG1ZEFFxSUU6GWSERv7kwXVRNpOciMFxAJ9HnBI95xkF0iFwdNi/YlKnLAJvd5Q39UKmCPvfGJCCO1bjge9ZNnYz9Mleuevko6191W5dqjauV6sqMZYo0NTvjcoqfNQd14yzRd9SFgqGW5nomy7heqE+gEOoH/QeA3Iwghxg2CnrQAAAAASUVORK5CYII=",
eye = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACoklEQVR42u2Wz0tUURTHv/e9GRViYGpR/gLJKNCFtalNW5l02Y+d/0G2a2PgX1BEEK1sHREithEiAjfVQoVQkFaNpsyUkmiB+ZyZ9z4tvI7znMl5E1abd+5m3rnnfL9nzrn3nGvQ3xVHMUFMEBPEBHUlETGM/UB8Sa79HSio72rqNDsjx8LWEldSIP6UwC0DX1G3ArWrQ1clvdOaVuQoq5kqy2qh9nJwEKKVISYIqCUBEwzRGrKvWrWUhgRCDDPPBgBFPIoh8FJZs8E8wwiRwEQh2DPqZtxCFcqg6+T4wldyrJV1+7vjdFd4V6zDNXDlK607uqu0inLkSvqs13qjvK4rozMy+qa3eq6TuqaMuiT5CpTUlh7qibaq6hHicxFtLADgATDNIClEC69CKZqhHZFigOkK6wXaLErNFLmIThYBDx+Yo9/unGAWKJSLXQBWOG13+5kDfDxgkc4wReW5Eb2sWPeAEZIIQzOG2zbGEi95wbb9eoBoxiCSjBCUiXstWojAwdBD3hrtMIgwuBgcxHt8inhkEOISG/gELNkQXAxikB3rnafH+lUQuIgpwCNgiT5EEmNPRYp1ACYRTTQjHgElSpyzsRqSiD6WCPCAqYM0OZE60V738SQZGUk7If3RUjdFBjGHT4kfXESIDlbxCcjREj1FRxVZ3LNl3eIx98kBu8AYogknWpGPPqan+BS60wXgO2cbO6a/u2gDpBCtfLA9qARAlr7GL9o+RZpRNoGCBVtmjFtkeMYyHrvkmOQmN3jKsiUtAJuMkj4M31izy7HKT7bJs4oftdlFa9clPPtvAtsuDjQNt+taA8evOXD8KAMn2si8rB4ldEFdOi8pq6yy8vRRs/VH5n8d+tXPFhRIcmSO79kSPx1jgpggJvgXBL8AoU90Sv9KWuEAAAAASUVORK5CYII=",
file = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACEklEQVR42u2YzYrUQBSFv6r+wWlFFz5AP4JLZUBpceNKcSGI2wH/3sQXEHeCiDuXvoEg6MKNOBsVXCiIjKCMOtOpvsdFQhNnqpJ0Og0OdBWEQHLvrbr3nMo9cWK1w3PUA/Q7WICoyLNTlfNK09LoMVs8gMeAMcdqnGd8nL+d2l9keqGLeqE/MplSw2Ta0xtdKywiM+6+J3RBM0mmrGbOJEnXC6uGAbycXknaV5ORSfqskZzcYV+xGniMMe/xeF7zvCK/HmPChECfTV7Gip2C6Yg+Ac8z7tcUeZsJhji+GA+sFGhAiMLV0SfjRHFv7YhmGIGAiwIwf74kk3MXSnCglut1AX4z5ilDfuL+CeIQJ5lyk1/tAzjA84DNince8vg/Pk3zIt7jCadxh8osxA53OLdcDUZ84vyB/JfrAJeWS5HhGSYwJIYVLG+4g9yRiy7EmnwtmvJgtubBmgcr4sFgNTwwXHFVnfu2PFDpSrc8yPG/x222o1+5znjwiLNHoLuO80CIb9yNMKMzHrh5kf3yKTI8gwN4SR3fLWHq6UUB6Qvrlse1m8M0EJLWAdid72qhANOCr5f5WtP8XgU8jmlzAeLk1NM7mbJG7XuQ6btOiVj7nhYgV4ref79m5ovYWkyA5ILohj402sEX3UpLqGoRuMEZNkolj1Fxylt+pOtUJWMrxGkXMjYHaxNCWVshvv4ZAsBfOURAHEbbbL4AAAAASUVORK5CYII=",
flower = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAD6UlEQVR42u2Xv2tUWRTHv/e+N5kiFpIQEsg/sEJmQRdMsbppFiysFEWwENRKWQRJL1hZTCG2kkrRTuyEFCmyZC02LEpYcMfCRWEhMG6UaMi8ee/ezxZz55n58WbG3ZXdIvcV8+a87z3n3nO/58c16MsOq30D/7WB+DOwRlZGEvIamRtmZGQkV/jvXzBghCZ1THOSftWa/pQZcRcMfwwWscgm7bHJIsJihs8exUCEuA9AQkpKAsD98OUfG4gQ14EEl+/AkQDXRzEx3D1ignc4MuA2hznMbSDD8Y6JgPhbBiwxMWUsp4EGcCf/didITmMpExNji/TYgvAz8sqUKZHXXMDdVaSSSop0V5IVmpNXokyZvEx/XXEh47/RUU1pS6tKZQqom6qiBU2orp/1i+gbHX1cIyos5wfqeQOkPS5KgTf4HLdMJcweeAYWcYxtICMhI8lV+I5D/iRNAhK2OdZropszhkk2IXDdB1LS8dst8SFGYJNJTCevbJf30VVNK9GYXuqs5nRWL2Xlw9Gn8vJKwywvuwc1pkTTuioUFZ2BwWDYwOOoMxuks9TxeD7wNt/BWz7g8V0oh2cjaOnrIoM4yBYADxBlLGXEAwDqzHCKJzzhFDPUC1BbHOwMvriHVC13lAMRP70nmtEPOiqprN+VFKB6K0VPYljHkbFNJcgqbJPhWed57qLnrOP7oBzr3cmj00CMuBbSQJ1FvmeROpABj9gNrHHs8ihI96IawLWgpZCmlnFqOU1bIwNWOZ7T0gHHWQ1f2iMBaox3V4l+gXaI10GxI8XhaHKRmKdARgY8JeYiTVxAtAy95tCwQGubmGGJj2QdUfyCKmsArFHlRUc0Z3xkiZlRUoVy0DSPw4qzfI0PmWeeh/n+srCjx0zvmTlCPYiJWGAXtyc9tFRd4Ur+3k4Xjl0WiDoPd7ABi+VZyJgrnOEES0FV+4ElTnCGlYB6hu1fdIpcdCRMXM6lN3PWZMDNXL4ckEdGd1GMuICnAZxElCkRMcVO2AXsMEVEiTLiJNDAc6E7Avqniu6etSkr5GXk5PO04OVkQplsDu5ybd9eTKqFGntZXk05ZTqvA3IyMnI6oPPK5NSU1+VQw2th5gidncEwRg1PCtxjngo39gRUKwBvUGGee0CKp8ZYd6kZxKIIcQ5o9iSDKtWeRNIEzhU1YYP6uWpQ2ySlAcAKJUqsANAgpRlMVYt7vEGNl7jEq3yl77lFGYOhzC3e5/JXXOpP0NYzqH238hrXd/paZf2mn/RHYBGSZvWtvlKiDf2onbxqf/b9oPvS0apXRnb0y8iwC0j72iT5jlXaQPCh1ymzfxHfN/D/N/AXcdihINmmLIwAAAAASUVORK5CYII=",
folder = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACGklEQVR42u2Yy2oUYRCFv+ruqBARRCJEsjboiEsFN4o+go/gQvEFfAddK6IvIoiCC8HgRkWj4mWZLHTlBZxbfy56Lp25pju6CVP/rqepU3X+6qpTE/J/LWEBsO8BshE4gZjwXvE8rw4Qlt3PcxBYP4OMDqd4wCF+jDgK5Ah/uM7mLoIYz13ERFz1k7Pss8umhlQ5fffhaT+qLfOJzrs21btiVg2guIOEnA3O0eIAbb5OSHSdnJyMKzwlpVuVohBf2rXjTy+LaSmGMBPvqE1zv3jY1NRkygnDZJyiEDdU3ZyQZhgedFMHNM07JYhspJ4SEhypIklpco3nJOTcpDGFon613eAdGZ0yRYn4WNUPg4x2nky8rTbtOs+2bQyzGAI8mQkQpj2a5llL3bLRv4usQi00ucp9VoiJzaSgaI1l2qzykAvFW9muyy0neM/FGe0iQc7yiOPIChTffFKpopOZ3SgneM0bEmJwxRUyoBdT4BSKioCXenTVAug3bqd223z0t8XIXAAsABYANQBij5Bjs2LY7Io52yGf05Rnh9uhNWiJJQCBY4iscoa3tePPOcE6OTEMPBsMuzZBm6M841XNDAI5yRptlvg+ENMl6bjVG9l7s5b6y/NGId/KUqnhtv/CfntpKFvCsnxvcG+Gatid9vjGLV4Mhdf4AlK3gsorSmmLCEeFx14389i5aoWTYqhP0Vj+sfgrYf8D/AVIW5ek+B56lgAAAABJRU5ErkJggg==",
gift = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADtUlEQVR42tWYz2tcVRTHP/fNi5E2tNCFkCZSi5BQGqi/NoIbXbhw5cLSpRH6BwhFEZe6KFIXVsWlq4rRVaEURES6ybIiaooIarSBqKQtjlanmZn7cTHXad6b914mkYK9D4a57957zj33nO/5nvuC3NmWcbcryBtHAxkgsXZ7AYg0nHNwPDtDScxAdX/Yc+dHlJFxkCWWOEakj7QISVwL6dNnniWWmMYGOVY/wQnxU1W7XvS4ewrjEz7jx/6l6pfuMTOrllSnoCW+rnbs2FP1e885YzA46zmvqBrteEs9L7YM4yvIxFc0iVbdVPUzg3gx2RXTWFc9m1aNpaAlnkoi+r7k+7bVrpvqMQ/YsWtX7fiRp9XopnoqrRxTwbI9/1ZPizjrW+ot9T1fTf8+dE7Es2rHnss7U3AyibmQ+vf6ixq9adtotOPBNHIhzTw5voLBaV5Op3vCKRFfTP3B79siTnki9S/X+SCvQTC8xnkCssQ6q3zFBj1aCGREMt7hUR5gGtNsEkrGxEFmcEXtpF3Xta4ddcVQh4OsMv9ktAicASaHNva3JIs4TBI5k8AZAi2ylJsac1ExqzzCHIdZ4AiHOFBaeZ2rrPANP/IdX9RKKCkIyF5mh9moTReZYD8zPMgCx7mPQJsPuMK3rHODLoEJ9hEBCfzGjZKKQv4J7vNrtV866WjHttcSnnte83c7I7P6Rtc8VPRHOTiP+F9aX326iIdymEYiIYVedfgOzK5Pzt1mRpNAqI3psqJR8dtSZp64q86CkOysbpGciXoFEviVdaZ3XSpktPmhGEWjYTrLXKUFAXmTh4GrLFbysARWywrykSlrrNXufAOAP/m80T82OzkjEOg1ODfUlkCOljh5haOKeL59vpEpACaZL+20GsM12bQez00Aq8BwHR8EIjMspD0XDR5URg5z6e0KKjLDPD+NxldeE88x0UpW6Ym8AmAjGG6uTTMigUtcIktWBOR5DgMbvDv0QUbkIZ6lTz4uo2XifGLal0tjn6i6Unr7XKL9p6pov7m63ktOnkI2I3JPsjofWpDTY/+dvh+4+/vBTXoFyA3cuPVdD/hjdwoy4HEWC06+H4ADLBaC4YnGk6h08pxRh8XtuFB7cnwn/8sK5cySpytVt4SLVhUT1B3R9qwQUjRtwwT1d7RqVgjIGzwG/MwLFclutVpBXumWOlYYZKFODR+EcTh5KyuU2TgiLeA6LbJB0VNYE3dS/FaXw0dddtmj9aXu6BP+X98qBnS6ozXhrv/a8g9GHGtMzlvyNgAAAABJRU5ErkJggg==",
globe = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAFPklEQVR42rWXX6xdRRXGfzNn7yPtlZAaijWUkGKRNPICVVKjhkLVBx+0JvJAkAgP0ugDaIgKwWg0scQ2ij4IIUGjohhRQXxTsAXCAxSINKJAY0Kp3Bikrfyx5d6z956fD2fOvvuc+6e9N3TmYZ+Zs/b6Ztae+da3gpzaVizLOuSnby9AIBKQ1HHcmzez2MsnsIhE6na0itOAAcc6QJJWChCINECfD/JRLuFc1jJF4C1e5RBP8xiPc+yEIC7WeyJu8DsecLF20Nu8sGO9QF/K/bu9zddVbaysbWxMJpONtZWNqrP+1PPEaDhZgGAUr3Ba1ZnOihur1rHZfVJf84v5zZMACEaDuzvOX/IVNXUcN9ntgY7Vz10lxhMBDFf/a7VyoB72ej/iERtr9e/ucqf71MbaY273Kl9SawfqXlfPh5h0X2T3s9bqvZ4j/kKdVX9sP9vdog7UR8U13q4mZ9W9rrI3HqhxgELc3bq/ScR3Om1S/2EQS0ujuEdtnPFcEa+xyhC/yV4WBOiJn1EHVurnxNLo+SZr9VaxlDy7I+9qq8F3iNsc2Dir3jB+aGPnWsmZ3IlAwU38kpJEyqQAb+UnSGKmc5NrSv7CtUQiDbt4H2nOb+yQQuIW1jKg5H6+R0GNHWKLY7wTx2ivouRX/IiCmj67sKXF1jDSsJ4v0FBylB2EeUS21AhqenyNf9Kn4lNspqE3CQA7mKImspNX6S1NYQswDgz4OgEJfHlyq4GGPlchfQ5zF4Fm2ZklEXmA5+gjn+ZMmmGYYhvfzWygJnAfr9Nj+YlOIg13A7OczjYYBim2mepSIAH3tadl+XuAP9JQIJeNPvMIIHAJ0OcNniLkRDPqc9lhrodOQpqbi7zAQQoCm4e3bJQyK+A8IPACRybWNMpeAxKD/Iv2HhwnjR2HxH7eC5xDQU3AYEQ2cQdbKAkcYX8nRAFZzRYk8CIv5n8C8h42kYj8lf9O2F/A2Ujica7jOcKQ/Yb8+Ha2Wt0nxniKZRGTIfof0xMWfTYggcNjX+cM1iGBf3F8TCbIWawZD9Go/03VJ8TQMnoUL1Ar9VstERfiNZlNLx/jzsLg71T9j/1hCh2GqCRwEICNnN65BS5ACIvNDhlJNgEwTTWkx9hql6eRAe/ioqzkQn52AzDXJ3XfyHoj59MAz4xSQWzX8Eh+bTt2IzexUscofFxYReSTlFTAI+Nkl4An+DclcAWrRkS1Aqq4Gugzw4N53O6g4Dj3EphlPVfiiM2X0XokLucDVET+xPSI8GMH/XYqeiS+zRRpmXsYfpfdefTD+akv0eMA91BQsZ7vk5ZZORTU3MzFDCh5mIezbB7LyRL4JscoqNjB56kol0yS3VZS8TG+S00EvtopVToAicghbqSHNPyEbVSUnUCVneMZO98oUFJxIb8FEgW38hS9TkacJ7zuzpJ2xqtFPMNXTOqTYrS0sBT/kAXjRhE/4dF8s/cYxrXdpHTseZp7s7H+wCnxgTz+Rmt3baaPZ8TozTbZ4lnXZnW7qPiN4mr3qgNr9Xm3+2HfyOL3Ib/kdd6fxe+sn/VSn2yV6bOuO5H4HUFMeU9HmO/z5Qn5nkzqER/LNUKjPuhZC1U6CxUgwzV8xeOtMJ9LI5WVdWemslKTO40LVQeLlVDDOL4/U6/Zber0JrtW/bMfat856RpttNkt/syjiybGN/29H1+6CFyqjI2ZQtaxla1czNmsyXXya0yzn0fZw6GO3QoL8TkZOcUapoAZjvLmAv+vCGB4V3tAM0EWPcKEJloxwDhj0qadk1QVp1i2/B9nl6y1LByhYwAAAABJRU5ErkJggg==",
grip = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABDUlEQVR42u2YPU7EMBCF3ziGM4SeYpUDIEoOvq2Lpd8CcQ1+RMF+FFm0cWItbDKBxp5uxvqex5oXSzG07gqqAlWgClSBKlAFqsCfCwSZLGcanvjDmh00OmijpKQu6wKfaBA3PAOwQxjWV4LT6T/VaqtbvUuyrOZ0+pY98AG8cIfRfFe98a88IMKpvgY+Dnf446/yPf54G17QEoESvhC++A2JRDfswg9vtCWjeeL3wBvwuEzgHN7BaD/hFxrtd/jZRgvFyTmLv0QgYHQ8jWw1zsS5PuinYneckx52PcnE+UY7CQw/CnkmLnNyf0WJxP0RNs0UYt6jP33eiw++JMULwUiyAWyaGS2r/yr+XeAL2kXzCczGJFQAAAAASUVORK5CYII=",
gripV = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAArElEQVR42u2XTQqDMBCF34yCZ/EC3Xj/TTeuPE2KXzfSRevUSg3SMjMQwiPk5WfyQQzVDVca/L1BuznC5JJm8aH+PIytHc4vvXf6TgMTanWRdNVN9lhtpK8FcTqiZwRgpF+UWF/NeHrD6ZiAQgEmOhwL9d0GDWIACiztgGhCPZinepmeeEQHXXL1Mj35oR2AiupVlCxKFiWLkkXJomRRsihZ9CMssvzpp8HXcQfR/NDEpkSgTwAAAABJRU5ErkJggg==",
heart = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAEGElEQVR42u2YO2gVWRjH/2dmbmSFBS0iJlkLSbEoNhZKVhfRbbSIVRAE0XZBwSKLWRDBRostFgsbK8Eq2KfQwi1CMIKCii9SLIgurCIGJN7k3szM+W0x353cx8x97INlYe8p7j0z3/f/n/M9z7kO/bOfQP8T/NsEUSlxRp1KCuRVFAtOgbykUJLk5YuAXGEUhUp7POstUUoQKRX6Wt8o0ri+05p+0oJWWgCyX1/qW/2oL/SLflWiRS3JKVTShkfrcAjHOT7R/HnLY6YQEQ5HhJjiMW9bZD5xzrRbEFvhQ8Qp7gNQI8YDsA5AyhmEwyHOkDa98cTUALjPKUMpJKggZgCo26o+84GqQXlgliGGmAW8gVf5wGeTzrRmDKmDIETsp0ZMHVjlCvsYYws7OMkCkBIDN7kJxKTAAifZwRbG2McVVoE6MTX2N++iAR/gGOONbfseu9t8cxGIiSH/vtgmsZt7pv2GMRxBO0HAvG3zJZsRFQKcOTVEXAISUlIS4BIiNKc7AiqIzbw0hHmCVgKHGGaNlJSP7EJEbbFVQSwCCQmwiKi0xUuE2MVHUlLWGG7E04b9j+CpA9dandTkoQPEpKTEHGiPlTxIrgF1PEcaEoElvXRITl7SvIKCwuAlPdKyEFrWI3vSnlKB5iV5OR0y1CYTPQQ8VUY7k8W8JOYAmLNZUZKOUsUDDxsoke0A1W0NFZsXFbfv9bOkH2xtne9RRYGQUz1HyR00A6wBU1YMBh8RjilDmWkESmB2kh7Y7KDK27RTqLBk/RnOQUmB0ANDbQnTGh7PO4Y30mSAEeAY5h0eT609TLNEu2NpcrsjD/ozkLhtCHfaEy2LinFWSYiB4wNTRIjjQEzCKuMbcdaaSheAOinv2VmYSmUjROzkPSl14EJRsROOEMdT2+QLRvqmCBEjvDDNp4ZU0A9CHBMsm+ATtvZFESK28sS0lpnANWt1Ck9QNeFnbO/piwixnWemUWWiW0drKBymZtZcYk9XigixhyXzXI3DndLFSifyFrjMsVKKCHEsNymcKJIsU5xkJVc8W1D9sw5xNl/ICpPFCynf+l5eAzVSPKfz80QD3iFO40mpAa/ZW7bPbtYd5TmwTgpcZhOBUTgCNnEZSFkHnjNa7qnu8bGNW2DZfdfqTVan7lrWwi22dQuE7uVLebOvA7OIkBAxC9Tz5q9upbFXhYwQ54GYdaPI4NeJgfOIqHvl7ZWnWbRM5xRXuZrDTxdE18AEDW9M5zZv+GS6v4rbX7WsIK4DCR5PAlwvPNz8aQJHxBCv8oPXK4aIehlnEIKsgB0lJiEh5mj/3cL1eRF3ktBvGpH0u76y+d94y0SBnG4oUKAbcoWnP/V/CVTpwWpS0lzJwewvEzTOagPAD0qQ3YnTgdb0n/+35Q/4Z1FMG/gDlQAAAABJRU5ErkJggg==",
home = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADL0lEQVR42t2Yz4scVRDHP6+7FyYsBERDUAy5rTKRQE4RFTEevHnw7CkngzcvevQ/8CiB6M2/wJMKCXjYTfYgMYcsLAYUDxFMAsFE4vR0v4+H7u2Z2emZ7tkfIFafut+r962qb3VVdQc5Xkn4TwEkBMJqOqtsTomIRNLjAFijZMgmm5ynJOutZ78rE1/3vqqPfV9MDX00+xweTMUPfaaOHKn6iZiYHAVAdcjnquaqji3VqyZieliAVBz4jVqYq9v+oOaO1e99oQ7egQEy8Yw3myO/dV38Si0dqbue74LoJvZ3dWSpftGE7FNVR30I70esln4kJgaDmfiBT+qVDsK7iR2pD3xPzBo7M/GC9xrflhDeh9g7bsxFOhNPe6Ob8D7EnmxVTcXMa12E9yM2XRDI0E34ImLzGWIXp8KE8Lyd8HZixy3ELkvmivCijfCJLXiiJrY0+qcb4lrvQnjaXaPFFOFhGiAxOPS2mhst1bsdwZmH+E4tjObqrkNDFZOJ/dvqM1VLdddkYkWPghi8oRZan7K9pz3bcAaMeEgAJK7UTEUg8JinDOY7WiBwmU1ucoltwiE6/G+8zRZbXCZU51StLwI7vAXA+qGGiHVu82bjVQNQoUuycmj2SyRBQm30DEBcEvmkjvB0zCG07o4T62cBlts1ozQdgi7JehAnQ64y4C9Cbbmc5B+usLPAixUAqpT9mosta9d4ozvjsh4ZXg1dkbR5a6QkcAqItVcHBqgy6xEpUPBr/fQMAxKKo+Ggmkoh5R6vAikl13l3X1Yd4fi+4gdFttLu0LwTxwRgU9YOPb6v+JmxV9r6eFACUBBJCHVBD0vMq/YU5O0MJTNWCDyPRF7kNSIlkYK4ICEjsdnzEq8Qcd7gbJ+jMiYw5jl+5GcCEpALdZWc9jJyluuN1gYvM2aNh0AyUz7mWt/Q+80QMpGxhb807fWneuabllx96sV6+Fk4eCXiOf+wTbaamedW6/rfvtOMP80VnA9awTm+5NRUZog84GN26uI3bF3/jFtk+/kKtuVGbCifTQAWPqnukvniHVzUA2zJ9NhzvRNgz6ZJCNo9WLbeCfD//BlyAPkXLd3UWVyaDkMAAAAASUVORK5CYII=",
image = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADf0lEQVR42u2YTYgcRRTHf1Vd21myijnJLh5WjOAyEQ8LQthDGBNBZANBD54FRTyIJxX04jlnc/cqiHhQEY3BgA5q/IiCGxUkfkCSRWQl4sadnu76e+janp6P7u1eJojgq8tMT9X//96r99VjxM0Vy/8E/zaBmyGxmBIxRtPAp25tIBHZ3gQWDywz3xJ8wOXi9LhdpWWFHtDH+lteXk3Fy2tHF/VIQCitUQsiMo7xIRZNGrtnuFjgMV4fc9SY/kYXJPW1HxlIuqKDMjLTLbB4lvkRi+Vz3sEWV23CJ1Vq7+nSJcWxxidlG8bD9CCOFMsbnG7pou/o4hEL9XngS0QOTwIcwrIFxBMRMkRJuSXY6psllCfFk3CY19jgEm+zSoInrVy+XSYDZNzFRywBsE6X41yYlkr7q0UGyDjNEn0AEhZ4pbjs4WmDqS8rdQSHOIaI+YGviPGssowvnbB4hEaetSpqlggwbPNn+O5GktKzQo8eHZJSSDckELDFFxgSVukywPI9PxVOishY4i3WWOMc9+GJ2xNYXuQGMcIzBzxHFjSNyFjkA+4mIWGRsyzze3sXOS5ygh59Ur7mJO9iyQr4c3QYEBOTcjtnOVqBNlZJ7wk15WUhFyrjnTpc/I4ioUVthIr1h66FE5KUSToe9oTlaoPYYxE/l5rJUPuEmG0e5jd6LDLAYYr4a9EaPcJiMVPgb3CST7nMg2wyV2RyNorZpPd6fOlqh/DrnMfh2OAEm0SB4taxvKi9g/Kvo77fVrfY4YSO6Bd5pfL6VUfKZ5sSVMMjFAs9IWmgTNI1dYat0zaeFiadk44EQxpcnmdIZxfbzgA+pzDF7j5LvLo7+tiZwDPSWg807Qdt4fMLfZZHmedJTE7nZggPHseXnCnVs1oXtYXPZQGDG+JWD7+OfqmkJZziPPOkU0+4kqq7TaiCYDcWdki5g/foMCDiCut8A+xUqJMCfwW3mPqmn4SAe4hNXmCFlAjL+6xwf41zLJ5ToUcn1eXayCjSJUlpqfw2l1ReW7pNlEdHN8IVkfESb2LwwRJflLu95xMHPM/1uuE3rznPBG3aylU9NTm+uwlf3svj+VjMNk9zdWIWqurgCd9yvf4FJB+7P5O0U1TMdiuafDY9Dw6EtJpr4PtyHmf1TT9/Aemop56OTjScfS6juti+Ke/J+WhlZgNPjQX/lb8S/gHdcHH8XE4sgQAAAABJRU5ErkJggg==",
info = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAE5klEQVR42rWYS6xdUxjHf2vvc67enlCNXkRLPaIdXJGgGgai3hETBiKCkBh0iBhQ6UhCJE2UicdEiIQQGhEThIaoNKSJigiaqLReafVWVfWex94/g7POvvucve+jN6w9OFl7f+v71vdY/++/TpD/dzROSDrEX/9bA4GEgOQlxWnlzWyL55FISOgVs3GWAB2OlQxJvlgDgYQMGONyrmI9q5mgReA4B9nHLj5jJ8fmNeJsTyrieT7uD842fnKrF5Wka5651J/hVo+o2rFdUT541/YlzxcTQ52muhAFAjm38wxnAW1OAuAwP/EzU8AyVrGaCQDajBE4wiaeB0JN0is2g4nBLapOq/q7L3qzE0NSy93gVveWpF5xXEzmC1EwEV9Xu3bUAz7silLgGjZMi2Cc7P3uVXt21O0urZoYVd+I6tv21Dc9S6SkNBS/qQ0Rl/mcmttWtzteMl9joCFuKdQ/Gt+FkcpKRzaE99mNJt6IWmoNpOJtaseuerfYqMR03HHrvL7Ojplt9YHhoh2O/goPmNtRHxGbQ4oScbP73e/mSqSb4l1q155t18RMjhhIxa2xJraNhKb/9Y7iDNxROVpN8Zm4+p3y1/L+Vvm3PTMPOVHeQ5GdV+3Ytm3HV0cjbTB1zD3mdsy9bMZEUoAabKRFj4QnOUhagy67aZKQ0GR3zXGCDo8QkMCDowctGBzzR3NzD7qsKMbyDoMt31P1PVu1Eomp36q5f7lC+hIzEb5S7agvVtwfKEBc7/rSrFrkm9TjMUuNmRAF4GogB7bVIgpIIOELvojtpzpy4F0yGsg1wyFKxW1q7p8un2V/8z9BTCK4fznQkhS2zwUCezlcdN7R3haYZAc7mCQUxTHsY0rO9wCsZBwJM2i6xJ91tIYrILhT1c/rULPIwrNq5nHP7ks1IoovpQXAVIk7VAuxSQZMAPkseYBDQM6SqG/BtEUS5BAplEjAAsYglm2mAThlTtaTDrGj+rEMSOhEfSRR4TEOALA6pnxxQ+B8IOEwB/vzpNjZPgDO4+SY/RMfgQxYA8BvHOtnaeag7UI6nMYlsxThwojlBVxIBnw1CGhSuPZJ3Peti/YgAW6hSRf4ZBTscKm/mqv7Ha+Bsn7lf6Tqd7OgUSJ+GU/BysFZGXjQ4B/eJNBmFXdirJfRkc3BrVNyrmUdXRLe55cC8EvW19ixa+Z+WxWe1vdplz177qnxoN+Zd0VE3jCDB8NN8eXY9F6odOT5oKIZobpPXqjryYnBc/w7kqh7a5p+cNId7nCy0lCb4vXmdu2q6+p68sCHjZEV9bxObC4IuJviRR6OzOjJ2WjLTGvXtrnT3lO8K3sxvPs+j7vRqRiejw3D3I4KN1ji9iisT0ea1ahJehKJTXCTWVzxTZWP1NXyUrerHXvqt95e+NCnvn36O5C/yZ0FM/3GM+cjvwMTLV8rEfOvfcyLKzxorQ/GqmqbqR96el2zqruAJOTAQzzBOBkZY4Ds4Xv28QdwKqu5kLU0Ym9oIE+xmTyuXMAdrR/HSd+KVHHaXuUKlUX/9AOvLNYs+I42cPYKX3aqUNqv9KyYH/Vtb5j7EjjXNTaJzedMNrCBS1nJ8nhP/pNf2M2nfMy+ktwiL+IhQhy0WE4LmGaKozXfF2Wg30hSIBtB0ZRAPn97DZ5Ixwqlyljoov/775x/AdSYe184dI4lAAAAAElFTkSuQmCC",
keyboard = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACYUlEQVR42u2Wu2tUQRTGfzM7m4fE2GlhIFppKouAAcEnFgYFsRFLKwXLgBi00L9CsEqvlUVqGyGgRQQFLdRGI6wKMaKbzT7ms9jZ3dm79252TSyEe2713Tv3fOcx52HEvxVLTpAT5AT/P4HbZVKR6D1GSeU9R4aUAo1sAosHphn7S+U1Pra1xD6Fxwqd1XNtystrWPHyqmhVV4Km8HQ8KNDgFM+wiAZgoCtY/XETWSxwlSdRoCL7jV5I2tJOpCZpTXtkZLo9sHimeY/F8pJlKkxS4DsTCDCU2ZeJm6jINy5ymjqOE6y0fYjiPxMsuCs0pxWtar7t32xfPKsVvdJJzUuqyOu8UKH5LSY4EggeyKkUHD6ookY0obUMPKWi9gZU0qKkqqRzHYK0ompQpxgSb6hRw/fFHeQGq9oRYIF1ytzhMxZLORN/oshvFlhnk3u8S9y0RA5aIbovhA5oSoS7YPriJjokdD3cwihELqMmRyhFZS8spahGu3EHDdjsADwGi8dgopM+UtLCCoVWpDoMAaGeOzH1PSbEZ3u/b0NgMczwiDF+YjL7q0FMUuEmb7OafD8Pljg+YBddYi7LiPSB43D4PuS9Whwuvapcoj8ClKlTBy7xkP1RmrMm2FduhT9+hXcmnaCKxwAXKGHxbPGY0QHs3+IMo1g8l0P2qr0TzQCW1xylMURo0tqM5QeH2WhdDdd2tUCDRZ7iqGdduQF2FAfcZiNt4DTbxTV92NHA+aIbWSOzNXbGOcZ4lPLBFxao8oaN7qGfXFsSS8dury3NdO9k8fLbLV758psT5AQ5QYr8AWWHTFG+vW/9AAAAAElFTkSuQmCC",
leaf = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACQUlEQVR42u2Xv2vUYBjHv++bXIsOTlLa0cFFdBPteJOLbs6OCl38ExRBQR20Dh1cOjjpJjh01IoF7dRBRXEQBBEnEa6Hl0vej0NzuTsuyeVN4mTfLEfIfT7vj+d5ksegfzusDgWHgqYjbPBfIyMJlUa6oe7KjZKc3y2tIFAi6aiWZfRTPUlWruBZfC+DRZznKd8YEPGd53QRJv95f3yAuI0DICHmYKwjbJ6kDv4RkDBgNCJiYAMRNBOM8RFDYI+73GEXSIiAC3mK+vj7GewmEOF4ibB1BZP4CLiHMISEWMQ24OixNHvY9fFhiupguQ5EwNnZTWqKFyGWtVRwbnaTmuJFB7EFOPqs+Auq4K+lh/w2TUIPQRX81SwrLiNCP0E1fMwAeJYXpOWCAHEji/ty/AsWfUuFRZwhZlgJ3ykqd8WCELEJDIAHc/Emb3vKBAYR8AmAL5ip5XvgywVL/MYBGxgW6uHLBcf5hQM2J+574svOwGD5CMTss81pQhYIfPHlh2xYB4Y44E16dy1Lq0r4MkEHsYojwRHT5yG3eO2LLxYEiBX2cMTE2Zt3lHSV8UWCALHMe5hAj1/wT1jILwtVBQf4D2mS7XOFx3zlDzE/2OJSFmU1BdP4Hl2EWOQEJzmWFhFT/VNh3uy7KA3PUYUK/L6k5uPDLCu8Zp4nKMY3uKbLc+v4scBiOMXntvEjgcEg3gH9dvHMtFBH1NdFvVKouKUeamqLdthhtb3ZI3JbqOJupWETaIUk0ya+fhP4HzXifwE6oBxk8kpopgAAAABJRU5ErkJggg==",
link = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABk0lEQVR42u2XMUvDQBiG3yQFHdzdRVA6uru5+RMUHf0VUjsLIqKu7hZRoYviJk7+gO6CUNzFpmnucbGVNom5y1UQ7GXJcDzPXb6Ply8B+t0VaiaYCf68oOZ9wFAoEErzNwT44U3u+5RuEClVXbtaVVctPShQ3mmp+tQQO3wwXEeIMLvPDw/QAwYkwCYimo5giE9JgDd6JKRcT0vwjY+BOxboAPCMCPwF4/h7xAkQY2hN4wZZ/NmoBhv+gigXH5MAB/5dFCK2C/DNvNO7CULEEjGGJBdfyxbYRRAyT0QDiIG2Ld5WMPy25xhS3lnkGOiX4+0EEaLOITd0AIOhO+qcEryNYDJzwAAxAxt8uWA8c8ZXoxxfJshmjgFeueWU9aLGtBfkZY4BniZKX1FQnDlXRMzZnP4ngXPmuAkqZI6LoFLm2AsqZo69oIbY/+r7ti++SHDhnjlugiaQuGWOWw1WSIG+S+a4dtEeA7fMKXryZ9NQRmva0rJedKlHRUWjbfkqGn4txlo/gcVg7iuY/ULNBP9H8AkdC+bnDfg7bgAAAABJRU5ErkJggg==",
minus = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAAnUlEQVR42u2UMQ7CQAwExycKKjoewcsQL4p4Ul7AI+ioqFiKREEJF8gdCtWuO0vekb2SQ6yrhAEGGGCAAQYYsECbDFJAVHh1c49xM/TXDRLiwJktN4ISdiB23DlymWyhV4VCqNUvagefvlYPeZxBd6KGPVEcsxBXTtMT5UMuu//HqZTp1NmDiHe/+Q2iwl7fMvAvMsAAAwwwwIAZPQEwxW6j3SQnzQAAAABJRU5ErkJggg==",
monitor = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACIUlEQVR42u2XvW7VQBCFv11vkQSERJE6okACGkRLgS4dHaJBPAGIBwDxCogHQDwDoqCgQBQ0SBAoKAClATqQAg0XoZDc2Hso7Ov42us1dohI4dnClnc1Z2Z2fo6NOFixjAD/G8D9Y1BRyxqjuvLGkZ6SkLUDWDywxtJA5bt8LrVUfSqWFbqoF/otL6++4uW1rbe6Umgq1p4HCRkXeI5Fi072ShkLXOVhJVAV+41eS9rRfmRX0hetyMgsemDxrPERi+UNT2px/DvrPRMmpDjO83LuQzVNV3CkWB5xd2CINpjgEUfCdeArQI60d0WlHM0zs+p9qNA8KfQGgDQU1rHZjQAjwAgweOi74PduTTYOYIrnFumgVge/ihlmwgAzPAa4xObAgXMZsBhmTVZhAMs7TpENCM+eZFh+cIIpJqc/rhzNCRl3eIwL9/XCSgMosu+AW0xDQz8nG9f0qZOcxOSrrrfRlnkclznLcuXKq3tnuAfc5kPgjgTMeM+0nXghlIjIeiZJeho9U9PgGpdkgsWXx34VgJMkML/ExjzPugqtjddZPN8A2CFrBdhnq0gWCvLw9qLFv4W5xbZiuy1DpDrR6gfgywTM39PizTcStFWMYtaf5gFL/MQgDOIcx4EtXhV3IY6xzQ02Il60ZHNOv9cblZopa3xbL88HljvoAdUVovusYloTU4jv3IyFyHRWS7ygOsvNdux2KVBLa+nhwWFnFX8AJjfu1QCG2MMAAAAASUVORK5CYII=",
navigation = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADnUlEQVR42rWYT6gVZRjGn++b0Ut5k9DI4tJCCCGvgSRGf0Bw4cLoD9LChQuxbZR3F4IgJOgmLNpG2SJaVGgbN27Km7cQ7yoJJCzCWxFdwjSke87MfD8X8845c86ZOc4959xvFmcWZ57n+d73fd7343NoDVakIMkpSI61AC+B+gmDO2VCe7Sg7zUrJy8m8zgie9vHRfJ1BeEnAx7b7+t8B0CgTcKPCDcp8PUcYRGAjBRIgTlEPA64N/CNvM01AFqkRhJYYgNu9B14i/mjHOPXHvAWkADHETEaB3wr7/IXACsEAL7gELfICCyzGYdbPYHHI8RTnOG2gee6P+MFxEngf+B0rn91BJGB7+QTWiXw23zEDoTYwl0CGf/xBC7/d3NwhxDP8xVZCXyZM2xFiCkcJ0z/h6jwxSgWykz/n5xgi9FHOB7mHwIpbbYV+u9HMGih1MB/YY5NpcDFiKO2r0+7+ocRDFoooQ3ANY4wjRCxBc7hmOZ3AimBp0u7VnMLJQD8wEHW94DL9L9h+s+X9VcR1FvoIq/2pVwd/VNcJ5AAzw4jqLfQOfZVghf6D5qHv0FFevsJvH1YZaHneuirzLdIoA3s7dXfv4OdfGxVkvRZqA481/8K0AYWu+XZS+BxbGfeYp0QyPiN93jSIPzQ5iG+tQC91q+/IHCIK0BKQiAQuMHLPT6OOyEcdPhe0/8TLm9w9QSQkZAayR+cZ47dPFiqFz9AIC5Yvg4XDa4uRJe4RbEyCxfATc4xx242VOrfRUZC4AbrBvX3J/kx9nOKef7tgLfMvQBLXGK2ZxcR4kvTf7RKf1WZ1hGl5uRunXsc22iRdgfkMIKic8a1RCkZK8x0KCLEWWvQx6v11/WifqLH2c/XZqUDBu1xzHCXjKw7IJsSVBE9Y7X+vmmNEB/0D8jVEpR71Eb+BuCqlavjEe6Q9Q7IwafZ2TQI3dFVSUE7NCMUCb2ph9SW11ktySvUfNtwJseIdywgBxC+ekCOugMJSZftNL5HUtBhbVJbkT7Xz0P0q/kZVExbFhZR3YAcNclF17wAZKzwAIeqB+ToIcqDMy8p1ZRe0ltCkaTTDYLb+OglXrST801rhgMDcpwQdbMQrN9WDMhxCLpZSAmk1QNynBx0s4CcJOlk520iOShnISVUD8jxQpRnYZmsfkCOR5Bn4TIA11lXcwwYk8AxywILbL9/gebP6FcJTo0+jVcN7EVx0dFIx5rctmitLkMq1j10oo2APftEMwAAAABJRU5ErkJggg==",
palette = "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",
panel = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACbklEQVR42u2XzWoTURTHf+dmSFI0dNXWGhVRIdSVgjsXio/gxqW6EPEV3PgA4lKsD6AgrlzoAwguCoJLEdGoNbgwpaV+NR9z/y5M05nJpJ1bLILknM0MyT3/M+eej/8xsbfimAD8a4Bo7C+GBdgRY7LFlG/cEQe6WkL4YgAOD1Q4SLmg8ZjPbAxPjn5bSp3QrO7ovTry8tpJvLx6+qBFHRUqZe3lmT+ppiQpVq+g9iVJbZ0fWBgL4GSa0UdJHYVKR9K6jsvSEFEm+n1ucoQuZVZ5SBvYqZcYUOMSdbrUuM3FTOon0EyoqmV5xWqrIQJ0Xm/lFeunZgeWBuoyvtSZx+N4wBuqRAW1yhfuYvSZopEu3ygRHsOoUKIPtInweXmdK56I1cFzFcO2EjZK/AlgfZjZ/YAi6wK9wfN3lDz7p9AcYoH7VOhyFmE0aWIUHRaGmGcBj+MlosN1XmP4zUs2oSX9TVnavOo976bJEN1jhgrHEEablUBL0xxAGJ/4wVdupEO0VQkNST1Jt4SiwlUQCV0ZVPOFZBUkQ+QoZS5VAdMg/RZt2U2mqUuNGAsYOZY5mZgM0VhPtOtv0IRVTAAmAMUALNiShQHEgRA2bA62Pfn1eAzYP0JptqfQfaaGrrEdbZlSS16xljUXRFv26ZW8Ym2onmZ3UQqrxC+eco0eh3jBIiuFGp5R4yqn6FLmOa0MBR6hjoe1tmvq2NXpLAHO0neH5xxPmAZ6Ae26DHS4zKMRCp9L3xt6rLUg/7/pmc7k0fe8BaREDMxxgnKhihAx72gNTxZYodyQ6YWVrC+6o23uaSFLoA9ZAifd9L8C+A2bafJHyIufgwAAAABJRU5ErkJggg==",
panelLeft = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAAzUlEQVR42u2XOw7CMBBE30YUVHQcgpMhToQ4Uk7AIeioqBiKCJSPHZJFASOtXcWSZ7Q7flrFxLKrIgzCIAwWN1gNDAWYU625e28fmb5YQYXYcWLNFWOusyE23Nhz7lSh5zaZUK1PV/3SQmj5kNsZNC06ssVcMQtx4dBtUSrk+f0fuVkNvv3yIKyvmKvAnPIay6AwkhPUvntFBZGcozb3eN0k96hN7WJJTlI7NeRpqE0E0k9ygto5FZiH2p9zEDM5ZnLM5H+dyfEDEgZhAA9fQ0U+Q9b3YwAAAABJRU5ErkJggg==",
paw = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADD0lEQVR42u2YTWsUQRCG3+6ezcH4iZfkIERFPIioESSQgxBREAXxpEfxD4i/SBAE0ZsoGFAUEZIoifiJB8WToiYRiYrJ7s48HqYzO85OemYXvKi9l5mafqtmquqtql6D/uyy+jcMGJlaspIV1XgFo9i/ShKQ9WnAKpG0XlZL2V2ZbO1F6GcQO7nKez5yk1GExZbIAjpC6i2GHXxgdX3nECqVuf4MOMR1YBmAFWAGWyIzoW8Iu2c9n0hIeM0sENNiGw3mC7KRkJtsRYidJKMfWsruu2VRv0G2iNveEdAEXhIhJgsyh8H05qIUYDEc4AeQEANwHJXKXIapYcD6nLA+Jcd4yE9WeMKJLE27ZR1MQZ8hTKyUqSNyelsgWkeGCBCvBrFMLm07DMlfBYhXTSxXMNPZbYOYEgOuVxLVwVQRK0iiOpioglhRVxdIA1cfU0GsDokcUc4xrhamJMjlJOqEeDNbchkk3JqYUqKVkWh1+1Eu8ZQFFnnFFU5nIS7HrMnk9OEIO3PvKHYxSXFN55K4iKkoFXliWcRhFoEWzUx5er3M2S4XuqpS0Zk10mKOtmtOm9TUgKQXeq5Ye3RAUlMDSjSuablsAED01pMt4q7PkTccyz5/jEc+Z17TCBXr6pY5ATRJeMswwuBwGMQgM97wOZRL4J4MRIjLJKwARxAD2ZMGYjfLtEi4H54rwj3Z8AKAl11KnO9sMM9Gv7uPnrxJw5KkOZnCTiOjx5La2qqhrIT0PJuuzp9x6dO232P7H36XNC9J2itK+tR+SZG+6nOh/NVOU4e4RkKTmIM+tJ3wD/ONNglT/QY5NXDKJ+Ms63xFjTxbb/k2c6H/NE1LwKw3McXeTD7CDc+P9wyGiWaCZzSnWKOaVkNNDaile5pTW/s0oUG1ZOV0Urd8qehrfE/ddIYWsEKSq6VpD74YnqyrXbRqYpxnXnGblr96x6lq9XUMpEoanOcOH4lJWOABF9hQR31VDH6f96SNGpLRvL5kEao+P9Y8iBvZHNmMnGLVgpqeTvpp6UA9gMz/vxL+fgO/AJFXUMareOAcAAAAAElFTkSuQmCC",
pin = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAD7ElEQVR42rWYT2gdVRTGv3tnHmJJaWxtEYo0C8EmVdKShbgVq0YhurEW0oUbSSkuSy0IuhcXgkvBZuFeUKHFglFIukyaGtsGDaWrJF00xCCa+fdzMSfD5L2Z9yZPMxfeg3vvOd+5351zvvOeQ/v7+H32r7BxIE6SlBVBoayJoWtAUaB0zyuNAZwkJD2nF/SBNnVC0kMd0lda0h+SnFyPk9BtBAjxOj8T0/7E/MirpV01o5f7Y1wHICUiKZwnRKQAzPEiIuwHIERcZBWIiczxKve5z2oBEwNbXOwG0c39BQC2AVjgKiMM4nAMMsxVbpVWL9RD1JMzBcRsA3d4G1ex601+ByJiYKruLqrce8QRHpOxDcwwgHAEeJwNT4BHPM0MEJHxmCNm2QjAcxOIgBkO1B4/RBwwCLiJbwYQIsaBbTKWOViKyxsJQTETIA6ybGcdrwql3b3D02LWTCZKJr6Dxp1wJiycWVr49tuq4n8ISIFlfGHgEWNMs8gi04wVEA6PZ9kshjrvoer9OWfxXyni94jzpWyOOV+4ChFXyNgm41znu1QFcAOIgefNiUecJrXLzD9TTpdWT5rFjU6AKj34S1KgP7Vhhc5LuiyvWC3d0z21FMvrsq0gaVVrCqz4001w8sp4QpLTmh7ZXCLpjFCouxrVqO4qFDojKTGV2NSGnKTDkrC5noqW9SFfT/Q6QU7ZQ0noGR21uVDSgpwSjWhRixpRIqcFSaG5O6SnhKR1Sb4N4n+95OvNLvlr09t35OQlZfK6rUklakmSWko0qdvyptBOE0KZ0LXeilZOtPldZaI60fLv+eaJVi4VKe+XjlxdKgLEG6RETUtFbnLWmF5jsFQjO4udIyDkju0+W6UJ1eU6YNbU6lpXxQ0Qn9jOJQJcpzDVCc4pYtPcV2r7Bo8Y5h/b91r1vvrIPrXIVniSoEIyHQHaddKguSbn3C6Z8WeVNAWISyaYjzhcrWf1XUWAeJmMmJiMsY74PI5n2SIlAt6tb7+6t11f2hnmabXRFCC+t9XvunV39QCOgAEemPh8tIumAPEeEJGyyXFcNT1NWse3gIiEvzlZpJfHc5R1o+dS9+60e/MbIr4xIn4qHIWIaZv95b80v3msx4pYpxChFYedcw1Xt1tNAfLoJo3tDY7bzazYzXzcvbNuApA7+MEI+RYhvqh9t/oC8DiG2CIhAsY5RWrZ8VIv/psB5E4+tJx9wK8W/+e96WkK4Ahw3AL7jZOQscJAb3qaAuTvyQgxCSkpSV3t7x8gJyOvr71Voi+AvL7+BsB6fe3sH2BHXuaYY7RXcpWH28OfIa5oqZwamzn29tcJRQe7LwB9PP8CnZ0ng+kyJywAAAAASUVORK5CYII=",
plus = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABQ0lEQVR42u2XTU7DMBCFv3GChLpAQqhLDoCy4lQVJ0IchmVQewLYcYCKDYsKQZPHIlGVxs6fSgRC9mwsa8bP8/Jm7JiYdzgiQARoeRs2Lcb+jkwdRkZOTjYpC40zkxNaS5KehNzIONIJJ4EzCmAJlBij2E1Hb+8QbyTAfj4VJZUwYqFFgH8GkAYgFdS6a6xWcwVq3SiHAMqDs7++r2dlb0PpadcOccMD57x7JzTELZfAjrXf9hEXfLDiuZXFUcc0oY1OGZvDPrXN/pFDFN2zxIIt7ZoF8Mlrx8Wy5a6PoiZZ/poTepQkvXT4hKICFLmOq0RDekGhqzQsU0MeRa6RuAXqQBjyYdNONSvA8fHph3OKzS4C/AJA0S3HU192VVldUUyImQRQQXyRANtWXf/I6xo5mTLlypXVb+1RZoq/ULHQIsA3BEoxErN0VK0AAAAASUVORK5CYII=",
power = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAEB0lEQVR42s2Yv2tUWRTHP/e+SSGYaBR1URsXImiqBW0WtnALi/wd1hZCQBBUULCyEbERLCwsFa1MYNdiMawguLCFu2u1/lxITNAmycy899libsZ5k/cmM2GFva97757zPb/uOd/7goywIgKBYniRMBLANlYcYWdgmgUWmCaMIOdwTzCKv6q6IMYh5WiMYAmMkQP7gILAUNFtDK0+Ih/JgPbXyQFA1imMrwfwn1dRGMLaLfbEgQERtzAhIqbQjQiQkbNzy1NbENhJXg8Ra9xukHOWVzznWO2xigSO8ZxXnCWnUROqykMVxAt21mMxS0frJ1X/SLsy8XHadaEr1/fECusjGbe5Ss4a8GZgiN4Aa+Rc5TYZscKLTZhj4iV13Zb6yHGjodKDYHTcR2rLdfVSki49/eqjeNJ1m7bUm0kVlQAbX26qLZuue3Jzl+pXHz3qe7WpXpdkfR3ARhO8niTee9RYhigDNMQ76pr6UGz0pK0aAIMN8WGSupO0VAJE8ZCfbZv70X19ttQBdPze50dz2372UDlMsVQ/cJ5x2kRusEgccjQWRBa5QaTNOOf72mGf/U1zC5fcs6mqoziv6ss+DzoVtcclC3ObZR9iyf4pxmgTeMByGvBfvgrsJSevmCESWeYBgTZjTPX6UAY4gRTAXEWPDECLjIzFLr8o99Q5oEBOlILUdTMT76tt205VTN1ocNqnPnU6FWd/AKds21bvJ219VRTFJ6q+c0dfjIchBbjDd6o+qc4BQA7AJ1YHUJd6yrLKpx4tlUM/S+/qCrTo8otq+EaPlr4kdwbLAQD2MrGt8TvBXkhaio00x26uM+A3IGc3+0flDgRgP7vJk5Zsw89ymT5DWkSOj0QON7JznEgLeVZ9DgReJsUznQobYYnMJKCXpTyVCm3SFQsLl52sHoC1RRqcdNnCwhUne4u814OMFe4RWGeSM4PJSAXBOcMk6wTusfIlA2xq19MWtsxddKLivFY/0eCEi+a2LJwud4HNB35OXVfvimNDhCk4Jt5NUnP9TWbzyDzoawub6jWxsYUX0YZ4TW1a+NqDg0dmp0md6nKKc2mQhhrbO8PxXJdXnOptc9UAnYl6U22mznggvc26BCAYzZLyA6kDNxMHaWxFWzp2ZV7RRF0+OOvhSg8OO+uHRFn0ilmVr3WRxVlNTEGXvOWMR5L7mUec8ZZLPTtm6+5tDIjuRd+quauJf675l7/7wj+TUl01V996sT5Tg+oDd3nZQtW2a+ZurNw126oWXnbXoFvnoIt4Rg78wGl+5PuK7wv8zDy/dHdu46YfiEn0O07zDYf4FnjN3/zDPC+SGcWgxrj1r4SMQF6pIpBhve2j/auIREikpnMLKIbjff+jnyHbXP8Cag4ikKNdmlQAAAAASUVORK5CYII=",
pumpkin = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAEL0lEQVR42rWYXYhVVRTHf/ucO3dEnBEHtcCkDHNImz6kKDT8yLQPBJMoeol8qJ6EHoIezJ4KCuolIrBACOoh6iHFjIKgD+0LzKAmy6zxQfGLkcq8Ofeee86vhznc5t479yttH7jnnHv2+q+911p7rf/eQXpuMYGMrLvOoWcFAevuHVr0H+BvZxsjSOhKwl6u2OBKU/WcwwajzjJRz+O/n4jzDLCiS+meZhCM/EFNHfcK6WYGvRkIV6gV9XWx0I1U1JOB4EFA4O1uo6gX8wRneFzVMQsGw6WbQSCmCKxjAWXgHaT/UoVpZFx73m9mYtWRmlc6urn9Sg5EpMA81rGaG7mFiEDKQUbZx8ccA2Kytt5oO3bEa93hGadrf/qWt07p2WOYxmLBZy2pOmFitQadWnUif3rV2XnvnhTE4pXuz8Gtg1bNVC2bqoe8qbWK1vBLPa6WzdQxt/urmtbAx93m9zX1f7mmlYpWtl/oCbWsJj7jLAe8YGrm5+5Rq+qwsVv9I+9Vcvn0vphuQcUW/SoXPOFKEUfURH3UtfmXu/MQGM3fx5xj1Lz4omkqRMp2bqNCkVOs5wv6CVTyr7OYnT+VCczgJ+7kEEUqLOJlsma8qOk9YwlPUSWiwmZ+pI9kSpxnpFNSd0KBU2zkd2ISHmYVKXF7BQF5kn5SCjzH1/SRtE0EVfo4yhPECDydp8KWCgIpQzxARpFjvEREtWOuSYh5kwMUSVnLcKOZoga+ABuYQ4XATi4QdZWSA/AKkNDHfY2YzU5egxRIeZfQJTVJgb2cox9YDfVSUVPXGwgUGOPnyTDuKiFHnOVbArCMPrKpiTxqcHCRBQD8RtalgSZRAkcAmcu89lE0iwEATvfImeQkkDKTwdwrHYhX1ivhayXRqOBvSgDMb47oDpF0GRBRplQvGdVNMzDBSQAWEUi7rLqQIYuBiHHOtJtBDIwiKddwdb0t244+Y4DlCBymXB8czT74jEBCH5u6dnNMYD1zqQD72i+0DPiIEkXgcQpdMmiRrXn5391+oWXEnGQPEWWGeYyUQkf4Ain3spaEAt/wHVE7BZMWfZGMmJQXWELSQUVMlSF25Kv++Wa/RU15JeIgr1EgZZBdXE6Vvrr+ccPoZ/IeC0ko8gF7iGv1oiUvCsYOejgvhKMuFvG6ppJ5l5E4309yajDuwum2JK2K/oilHOisW8Qhq6bqLnfmqq4XN3m0Rl42TM8rWtOWNZ6vcaIvfcQjDbRlix9OYU0PtdovtCNeN3tErVrWnKr8S7wmfxMr6mnvab0daU8dh3wjh50wNTXLr9TUsomqu72q3W6n05YJ73CvFadvn7p5Ss+LoO/L2MgqljKPmcAE4/zCft7nQB7o2cXs9GPMAfoZYhAocZYLdQO46KOEiKjhdKL5n0twVhFqicDui1H4D6ctPbXof8bnH8DY2/cGEf9AAAAAAElFTkSuQmCC",
refresh = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADmUlEQVR42u2YT4gcRRTGv6ruYXNYjZpEkRWS1VPWYNiICh40l0Au4sGLincvHgyI5CbmEiEu+UMOEhcvgoIGQZCwISGJwhgWxItEIwmJyrooJAu7arLd1V0/D10z6ZmdPz07k1uqLkNNVX3ve6/qe6/aoLvbrO4B9GnxgOYgKZIkIa8KATQMZx7KRwVghbbrhIwu6U85nddFSVLUhwnVusEg5im3H/mA3QgRd1+5PgBPggu/DjKOsMMCCIthim/5hev8F4BukwNXeQcRYYYDuMNljMfYwyEWAEgA2N+NxWCb2xYrN7GPRSAhBQ5hiNeyWA8DgyUKgX2U04DDAR93CvfgAGWoGsIyCzhS4DlENDqAwmkWMQMkeK4wEUZGBiAMMeKrEO7v2oM9PEDBYhN/kZPh2NYKMQo19bK6qRlZZYr1aptGM4puMGxkCY/nOg+Ee9+BgZWRWQcrZLWskzJy2qbp8r7lzYy8EPIyA0MYGdUleaFJ6c4Otk2O66prSoSkMkgc0CVJkYymO8m1IWIDPwFwjS2Y7vrYJQpiMysA/NBU36avjCLl+kQ75OQ0qZMhGoO1Zd1osbzEoIZ4D4LGO2A2jA7CoMY1AL4oC0YjH70GOHzQ+RR4t3em6uGiT8srC6xnuU1G1kyGHge8vFa6uvYI8XRgP1e+y1ZeU/paGyRFcsFzRlZen2mnfMVbYWT0oqRM0tmW04n4HrgFzPMSNN2U4Jkvn4c+eiROAY6cp8oMGgBwg8cRlwG4xU2AygAWwwQr5MACtRCTAGDYTp06uxCWw0BCzgnmuMhUxfsQI44Aq8BHrZErT6shXiAnxbPAg5VPUITYyr9k5PzDRKtcNwgWlkbBkgQ4h6VWwT1Fqj8T7D/WfvLaJ1vGWSQnCZct7uOiIkEeD+H17Gh3aidvvg2kpMBMGDM9kqU4CqQ44I0qST9C7G8u+ZzNASQKrizcGYeNnmAOcCTAgaplS4T4EMhJgQX2cX9HBpMcYAlIyYDTmE7lY3fqs/hmYfgHR3mFJ3mIMQz3sYs3+ZJlAFbxwPuBYeXS0SKe5+dQSTcUaonfucxiU7NWg/q+vqasrFC2xIhHOB8q6aRZsBdbrgZp/JvDTHevrXvXRUUYt/IWv7K2Oa5wnIdLMzv23k8oEzLTuJ7RFu3UXq3oN41po77RBV2VkxTLyw/zRjOKlHX5L+r/0qz2CDSyMpIy2fCUbZQ4d/kZe+9bxSja/5h4oqx6ADoRAAAAAElFTkSuQmCC",
save = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACwUlEQVR42u2XPWsUQRjHfzM7BBIFiyBYGc5GJYVaKqJGLOyMEMVKTGNhL4gfwdZ8EbEQQSGFISiI4As2KlgoSFQSfEtyu/O3uLnjbnd2b9kjRMVnmtt7Zp7/zPP+GLG1ZNlGAIvBlO6o5vbIbJeKLIZpllhiOnLPau4gKbaMElk9liQty8opke2tRC7KNTFZLnp7kQGWDJjE46O7ityELL/NRQ56oMUYGyRAwn7AoNyePLfNO7JwukJFVmhGj/RLXvXJy2tdz3Q+SOhbg+IToRPKJHm1A4RXO7ry3EySdCFIKQGwMnoiaUNNqC3pgyZk+s3dHwcWzxRvsFiecpd5poAvLBSjB3GZFvCZhXDyFKdIcRxjecDYOf0fDDe5KfRAkvRKcVe+n+NelLQhrzODSsp7UdcHJnCMDQnFjhc6wJGyM7zND3PTLlBKCnj28jCqoiN4LJ4UgDQaK5UAMEmGZ4LTJXvSkkCtBWCAlIRkyNmVYSm/CmCe2+zGYEqT2ArXSrhDATLgOSdzKaJoiQ6UbVZwxirFg+oUnCojeYRBpSoynVzQHKAjhlIh+uOL/t8B4Ea+gh8VwG/tCxz7hsTqe9abAligxWtsSSwIYZlhkSTk1AYvsNiQ5X2EI6hMh7VsIAw+AMWCUKMCGDyGRRb7eh6L5zCzZM3rwaAfOe5xK/fvHLN1PMzV9LYdOFzPlI6UXaO5qcXh8BUmVK8fdTiysoB0kUoG8DMU/a/h+0f47lZj+BZ+rwbO955LVAJs4jHAWT6RkLEnxMNRruSMfDxw5pjGkXIuzA2b5ROOASwvOFDHO6Jl1rJKi7X+SugGtJqQcYM7uF6fY4IVioHW5WRBmMUB11nLTQmR9v2S3jZqfj/qarF9Lw6BFs84hxjvMzk1CusmL1krDiCxKTMyCNWkyMn4GGsaVTofy0tG/4v+Pw/wG4hZVXErDtEEAAAAAElFTkSuQmCC",
search = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADj0lEQVR42u2YzWtcVRiHn/uRSUMsraW1TcHgF0RChdiFIqFYUHQhri0UoSAIboRu3Kn/gVUX7lyJIMUiLuzCTSlYoRZC60e11A+0baIGpaa1zdyZuY+LnNxkJnPvnZRUN567mHvOee95zns+fu85E8ntTTH/A/5rQDqwZRR+3WhARExETl7kEyQfFBTV2CV0wtsQdwA3aBY1A0GqADEiMft4mscYZyuwwBXO8CknWATiwq/yZNmTiHjIs/ZLFzzscGFV8ZRVpOIDnlA1s9nV+HL+rI8Ey4qn/xCltNnPMbaRkZAAs3zHJWAXE9wDSIsGTQ7xASnt9Q1RIj7u3+qiqh/6lJuL2hGnfddMgx8HqgdqbVFs5L1eDQ1cdH9Rnpoah9yUX6iZHTs+WoXoD/gsNH/S7WJiYlTURyam4ohHg9X3jhqvsqgEpOLzatPcH91WOomJmHo6DOOr5ZPdnY2MTPzG3Ja505VrJBHv87ptO867Rfr7sPajfWqmflS7BFPxzeDDwTLreI2gPbME5m2iGinIiXiHFinybKkM9kwwnlR1zpEyp7uGFGdUvWjS3z7u6n9OyjgAX3GTuFbMEmAGkDG2DxZwNrMFgCsDB6NLQIdRtq6KGRWAKBgNHlbsCUg1gOtcA2AnDCDFAGNAwk0W+ncr7upLRMZlAPYwRF7WqyJ1gCkg4jfmB/EgAc4gLcbZS1QzCzFwN1PkyDlaJHUeLLl4PKz/l7DGgxh5gU1kRBwvnYU1UjHsT+a2zZysFOLYyB3+YceOC941mFQsbfeXw/afqQiKsYn4SdDTI+VdWbs3Yxt+HT48akNWRYGVyID4VlCtX9xh1GNTEQ8S8WEzczP1cx8sylNT0zAQu/1YbdlSD4tD6wn6ificmttUr/mGe7rq7/d1f1cz23bMnXeqXHnLg/4B3iOlyTDQ4UvO8TOwm4eYYhOQ0Qh7IWGOJzlfEvwrtH7ab1VdtN11bMnDYeCyr3g1zMOck/29qD54jfqas0XDLVvm4f1Pj7hL3OtsWBAliCq1X1p4d3rQ973gX+bmXvcHj/miYyI2xEnnqhB1ASUpYDudcMIxG0VJFJqrRFB3tjQy7dlESbFYqUfUA1ZEJDY26iMIlYhBAdSeL3oR8UYCehGzTi6Lx0YBViNuqKeX1XXjbpltUs7zBL8yMtgN59a9OOWplSGK3Oh7d76+W+atIAyHuNsE+Lf/SvgH5gLIJSr/GqYAAAAASUVORK5CYII=",
send = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAEKElEQVR42rWYT2gcZRjGn+/b3TTQEosW2oRSidBLozmIodiDipUWxRYt1EN7Uqx6EQQRRQQV6clDPAkGrB5iAy1qEcxBQdRoaEtBShs0l1iEVrRa1LQ22d35fh7mnT+7md0ku3GGhWHY/T3f97z/dsahNT+cvIIkpyA51hbt5FXP3/JrBvcqCwXV1aNH9b2mNSQnL7o/PWUcQjjuZZRZ4uMMwpe7XLVXpKAgaVgHtV/DkqSgSF4VSZS7CCSG3q79ekIjcpJQJC+voJJOSCqv3hBHiZJdb+MZvmIRgIgakZkTCFQZRPhO0Zs5zCmuG3qRxqMOTCE8Wjm6bNd9HGCcP22lCfpHjnODQACgBjyHKK9EwKfoHvbyHr8YMkH/yoc8xCBTBOoEIAA3GUC49gKt0m/R1nmNjznAJsR6LpgxsUGBydigVgIZWgzzFudTdAyZZ5In2WLf2MpPtqPfOUmgChzCxTsvctvb9XZe5Ezqag2AKl/zAttS00Q/M4afZ4RJIPAPm2KD8gKt0q9O1dZ/mlcZSvcYh31Liv+XXQxYgCdQwkq+7tqm30WOsjNdSBlvgAx/g92IN4EF4LHEoPwONham3yVGuZ9KA1oF+AcQPcwAgd/oSwxC8eqH+IYruSKJ0+8YD7PBgBm6Fb7E3UCVwFhcAZmAOGvoGhERcxznILel6FJqYGt8L+Jtu7Mni0BeoEqdQESdd7kVISr0NKFb4SuICnMAzLEuMyiz6LtckcA8H3BPCnTL4MuUEPfZvdG8Qfkg7+aEhXbRAv05jxg8iUAxPv6MAVVgV96g5jS9k3e42lCz53iaPoNXWuAdopfLAMzkUr5pB0mZbeYl6zo1K7FLvM7tCNHPxSX42MR9VgFHGw1qbhXeRHo5zJQZtQDA34yxhwsF+NiQj4AaEXclTa5YICmn+OrBNCoLDaOkEe8Qt3CVAJzL508rgaQvLY1KRJ2Iaw14UcZxyBbxcrNB7edBc1QiasCz1kXzifuJNcXBZoOWn2hJVNbxiqXhZw0Qj+hnniibwqsTiA2Lm92sDcVhXJrpZcQR4GY2hVcvELcNx/Pm9Pu5UvKIL4DIprDvVMDh2MgfBCKuM4DDG+4OqtQhm8KN50r//KKS/tIxOVW1Xkfsl17SPlVUkzQuV0hbxV9cxyALRAQuswFnuzjdPIU7syhJyAmLw1OWrDsseScaW1znAjuBGoHzeCqI15ZO4c4F4iB+a/WwF0elaAp3I1BGPG4N70vESNEU7kbA4agwS6BGYCtvFE3hbgTidSYFN84PRVO4O4Gk4LCHjdrSKdxZoTUXnBTS35+URJtfrPqZMi64QCAqmsLd7UAK8vpZn8opUpB0SkGltnte9ZkVXOEU7i7IWcGdzR622323UwHHDqaZZshaXsvT/Q9vW7Q2L0O8vVtZ5vgPwKokfsA4jo4AAAAASUVORK5CYII=",
settings = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAEv0lEQVR42u2Yz2vcRRTAPzPzXZMGFEk9hErV2tjYCP7AiwcpQtWLEhAELeIpBw/iUVBBL4J/QQ89tyII5tBC0WpBrNbUgyiC1Vg0kggqGGmxtrvZ/X4/Hr6zm912a7dKiwdnDvudmffevN/vzQa5uqMYES5REvvWFYlyFMTwX5AgIq/yJL/R5SZwE+/wOoHqstgOn8FkMopJ3O2wsTufRpPJMJxSHK44pKSkIhGAWUpafTqvV7NAIFFRUiJhuPjDDCpTHGCBWUoSkRkSicSPLLHEj3k1QyRRMssCB5hC0igqiuKEn6n6u/MiLqq65o0i3uiaqosizvu7qp85kbEH5nDyH6otm6q+6Q5/UfW4GAzicVV/cYdvqtq0pX447IpB8qlHfl3Vjm31T9t2LN1nsLAwuM/Sjm3/VNt2NGPUV6RLGTlQMsFhHmKdBm0+JlGwzgSRDpGV7KaykncmWKcg8TFtGqzzEIeZoBwwd59yoltc7HH/tPi8Z9RK1WWnDUajwWmXNZ+c8Xnx6Z4Ui24xbihqUD1vqU1LT7tHbIgznrDlEeeclOzrQZx0ziO2POFMhtzjaUub6lv9ahq84JCVLfWE2DBYiMntveDjgq/tJrEw2BBPqC0rDw2/IIp3eTYb9gWx6PlEuChSN3ZihnwhG/ysd/X70oU+NK+2LT3nzgwWBhwvDFwUDRlqp+csbavzg37UT75wXDyYjfW545lAl3TRs0ExsB8d9/OMdVAct7hYRRsIt3naylKd7hO1e35DjuaNkyhOq6WVp73tQjvV9SAgj7CVGe5jO7cQCHzCw5Q1EwSk4DmeYgeRHzjIXv4gUgGBQOIoDyKywvd8wRKrfEDAOg6S+FpfGu7YVOey8Woep/xkIFV/7WxPikKcU5s5puvxWk25K8opS1t9AKtuzgYNRsdcVFuW+bSp/uBktlEwuNnVPgZblp6qFVUgkYpVpknAKt/wFWu8zVoWMdFhngdoMUbJQVo8zgQttvEyL1LQQQJr7OIpNnM3O9lCIrIKRKquCo6qlafcdFEwRfFTS9s2fVTEe12ztHLZxkB013OTp6zUozVu7CW6OtmdJ9KgIObEFqi4nmkiBe/yPtcxxpfsJ1KxlVsyJkikoEHkfE524dIV7eKqV1eqZvYZOD+wfxnkblIFSWyiok2HqsdZ4AzLVJQ8xj20aHIzz1IR+ZmVjFlL2qFNxSZSpjbQtkSgYhtLPSMv9xl5gftpcT0fsZ8mz7CFda7jME0KOjlOtvUZuSJtsD6Km97gUnbOerTUNbfmPPW3bjpqoO30u3xWM/Gru0YLtNFSRaRikpd4gluJ/MR7vMFK7k5HSBWjJLv6t+Ht3uH4lSS7K0vXG7DxStP1aAWnW/T/UcG56iXzKhX9wVRxloBU3Mke2hR0mOE4JznCHJO9/jkgk8xxhJMcZ4YOBW32cCcVEjg7vPm96o1XLXi38dV1j/Witm6oXhELC/GV3KDVp3rM9fxdd6fhGja/17h9vwYPkK6ipjzggrPimNG9altd9lu/dTmv9hodE2dd8IBTFyrn0hf0GynlIOoM5Mp6VQdjGoLVN4tLvG0DEZCSBJwkDZTHlHdriEgAKvynL/1/9RAP//8ZcrnxF3/I2pbWbfEuAAAAAElFTkSuQmCC",
shield = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACqElEQVR42u2YsWsUQRTGv5ndBAxaKEkhpNBGiEkhxEKwiI0IFiJYiFiIsTN/gYW95i8QrASLFIqVIOk0RiUoQhQsDGKloMVpYy53u/uzuHGze5ndm41YeTPNHW/e9817b3bmmzGoQYuUSbLKFOxmAkeaPthYaRiJDQKPhVKhM1rVqs7LKhGKg7yp75YIIca4wgp/2lsWOIAQkbNX9mqTIcIixCQ32QCgQ5cuWwB8YZEj+UjTjMAQu1+z3KUFQJskjyCjDcAmS8y5kbGfxJeU2Dmc4wmZA+/BPuYscyy5/21nXeEyYy5htp7AulmMs8A6AIlLSIs7zObjpljka540gA1uMOmit/URTHG70tkS5WUdNIkdBBbDNE+Dwq9L4zNmilFsl9UiXgGZm/egAvoWQpcEeIF8BAbxhoRu+BL0LOWEhI/OtiNFYhnI+Mz+sI+o72PcwxoZ8KFIEPdtZpLRL7Xc5hDWMklGI9rUDxlJpmiMvfuTUVIeFrDjJDI+NFsxfDcNn5/VP25DgiHBkGBI8B8SpH+xWUtG2U5/mxuRNF55CIWdBvvyc7EigrZQokM6JtMweVbooKaVCbXyCRcIUCTploxSxbomGh6ZVkaXtFcdGd0vRUFRuIzwiYyMb4wVdM/g3tMf74GUn0xsawoKiUCRurono44mdF0okS3ns2LuVqlSXdS0urJ6pO+KCoWmrIwO03b6bJnTJdXjV0Q92XWCB6SkdICTqOjR7yBWgY67C9SRFMEBUraA1/Xq2mKZ4WVJW/tI/OCwztFB8r1XnAs1JFXg75hntFje6huOakn84FcZLXkPuKNFlSSnOM7DCnCvDq9b236SBuD1BH6SpAn4YAIfSQPwMIIyyXPWmGckDBwR/BgiRaULSRT64mJ28ZwThb60SNJvf7E9/ry20boAAAAASUVORK5CYII=",
sidebar = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAACbUlEQVR42u2Yz2oUQRDGf90zmWTRXBQT4hpRFBbci0Lu+gxectQcfAnfQMSbQl5AL54VvXgQFvHkyYOIf+MiwY0GBd3Zne7Pg+3ojjP7DyQ5bNdhpnvo+rqrq6u+GiP+b7PsAwCLwUy7FLPXJrIYmrRo0ZxyF6oSI6tIsayeSpKeyCpWJFsqpkpPXG44LA7lu3DAYTx+yEojVPY9LjWLxzHPURIsnpQIiGgAhrJDc3ygG2aONJEVWtINvVYqL69Rzcurr7fa1AmhqKivTP0ZvZEkOfXVVz+A+NArk0yS1NGFoKESwMroiN5JSjVpSyV91SmZQYi4YP2MqxynR8IX7tDB4LnESaDDzdIzMMAi69Tpsch1LhacecAx0YK25OXUUSMffyBJei6GyIpeysvpu5aCpiC2sJY6K3gst3nBPDEJMUnwt5iYufAclAU+cgtDRo3G4PUtuukcERnwCYsjw+KDUURW6aZg2AlvyfBQoRzYTxgQ4oKGEbFIU8Sc/ZsPZgAzgBnADGAGMC2AmZxGTwbgJoQweQY0w6mjx2OAgyEJ2tAHQ1yZk2MyavnSGEZbamrLy2lLy/n4wzFoywE9k5dTV/VBdhcPYEX84B5X6HOMFpvsYPCsAnCIy5XmWWSDs/RIeEy7QIH/oY6r2p2aOvZ0rkiAy8jvee1KknpKlSqVC+Q3HSKS1NX6KPL7G6KhuwFk3PZN97VWRt/LisAIByxzmgSLuMYa8J6NCi8Sjle085kjKxyHBbbZ/ksBdHk08sq68Uoo8KFOMxg8IgI+E2F/mbWU1/lJq8w/ftVUSy01i6XFeGI0+5Ww1/ngJ5ASCHgtsSVnAAAAAElFTkSuQmCC",
signal = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABIElEQVR42u3X0U3DMBDG8f85ZQLEFBkAqatWjMJjECN0h4oJIPl4IKpAdV0uvlRJVeftEvl0vp8Tx8S8I3FPcE/gmMmw0/lsHUwTRktHR3tSheovUxJ6lyS9CaXfdzchFQh4oAeegAHjuPKbkOkT4oMG+JpPUfODZiX74Iz53JjWg+HY2hkqKJnPEwgwn4ReJUn78amKfVAwH9GDovk4RWfML/R74DA/rQcO8/4KvOadFRggXngGdmz/11TfEjnNexO4zU9T5DC/gH1Qaf5yDyrNlysIMF+qIMR8eYkCzJcShJi/rKjS/AL2QZ9hWhP7o0jAI31QLKPIEJ80wAFIDFhFLHMuSjK16tSpHU8/dbHxuvIvVO5lVxNbz0/gTSf4BpFV+TuEXNq5AAAAAElFTkSuQmCC",
snowflake = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADs0lEQVR42s2Yz4sURxTHv1Xd401Ushu8L0jM4sF/QPDiYZn1P/BiDh4ELwFP6hLjYQ8mZPA/8GDYHARBCOQnggwbBRc8qAmCy7KLh8WDLsrszPR8cqjqmuqZnpmezUrsgqapeq++r15933tVbdAUjxWSjHrVVcxUAHt47BSSRvNqqql5mSn0qNYMFrEKQBNhK+oprWRFIqNMUk2ZpFlJPaVC2WTVKgBu8lRdvVEiqSvJ+Df/HcAI1SXdl1XN70aiTItC9ytATPBhgrgCwPeI3wD4B/EtAFe8xJg2aWuF2KBNC7jOzwCs8TWwS5uNSGpPAM6+BrBLBrTBv3vsAo3pVpAgkgF7DJaEH4AOGfnTow38SIIdkk+KoKOsjlUM4jugTc8DuOnzsVGaBQCLuMpTGhxA2EIgGVIP4dbQ9dMXrXc6B2jwlKv9UOwjL3rr1jiLEGmkHkOUTe/GxVnW/CyL+Xr6AHUgowXAPU4OgDjf/gX0WA9rjic/yT0AWmRAvQjgxJfYAbq0gTYNjhb8ajH8AsCzyPtu9CgNr9UFdlgadFHO5jluA7BLD3jNJWqIBOsV/gDgBSbwS9S4xOtAXLjNXBwbwxw4xQO/VIAnLHhnJYjfPYAw1BBigSeR9ANODbKpSCrrh87xMlK7ywmvlgM4r5/gbiT1knNeyo6PZBdqB1niHdChA7S4yechF71AzHCTVhh/xxIHAxUqpAonNsedaEe2+Io/PcBFNiOv32FuVJiNzkU5+U7zMHJD5hNFv+chp4eipnKyy3fkPOshgom+1jlf5vVps6lBHOIy22Te9h4Z21zmULnXi81OrEdW0lttqFPo72hDb8NJaY8VLd+HMzwCoBNc5L4ecWa8/8e7yC39OCueSYOP61nh+GgGjaOpQRxmmfeB6x/4hqYPqWU+hP73LHN49G6M486riI4rfIn4NSS7L/gpGn01mk9V2L/qfZ2EZJfvzerkiBj2+rFC/G5yAYtISAvJzpIiLBcGYvrY6GRnEEe4wU4hA80G7w6na7dTs4WstMMNjpSla4u4xlZJDk3HFpyyvLrFtbKaXI9EHocqUL1kLvA4mqE+XJPzor/JRdIBRkwq+o55qc+yJUW/f2y5xcxQ4FQ7tjiNGW6VHVuKLd3zwSv9RI6OH+3w+78d3z/iBSS3r04dYX3R/9vTuj7J+moAimLWRfLz0Gf25xpLuMZ+5u+bEvt5jZUyGRmhjhJJ25Ksuvt703dxO0+TJvP+3l+pfUI/Q/IfImY6nX8BKy75RXixFeEAAAAASUVORK5CYII=",
sparkles = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADgElEQVR42u2YX2sdRRjGf7PnNKahaCFGCwVRkIIJJrZgamOTCwNKRfQbCF7qlR9A8E6/gd9CoRcVhARpco7RRC0NNuKV2losqSGobfNnz+7Pi51szklisweP2At3YJmd2Zl3532eed53Nsi/eyU8UAYSAqG7MeHBcVFCYIQmTUa6WoVVSyI2VF2IT5VK1emDeMzbZrbc9GR1E0kXrhzjUQAeYhwIvcUgAOeBHIGp6gbqFQ3k5bQ7prJeglwgsKrm5updH4+tPcKgQGCIHAjkDHCmqnuTLhEIHe7qmYH2KYtVT8bWnmCwi4Au2VBz//SxaigkXSCQAp9xEUg5xli19SeVEAglMZssAgITkbL/aB8U4hyQKaCPlKtss0kfMIUE6uSF5HSHQTCxbq18HnTVXF02iEtq7ronyv6adZODEakf8MWSITkwwAgvMslZhmiRMI9AkzNkHOcbvmSeJte4F8fXCPtW1CbHu1/Q56hv+7E/u3OlbqpvifiGumVa9l33E9/1eQc6PBDrnRGtn1OcY4pxno4tKdIX679wjpsEBmgwFtu2CRyJ9Rt8zRxNVri7N2QmyDAf8QRPlj0ZSWTJHywzzwqz/Bq32nFeY5hJRnk4uiGjVnLqBj/yDisE8h0DAfmKcQBaMTzCBg1mWOB71kqMLO8AgzzDC0wzxdHS24WhRc4W7yV7KJWVkgySssUW6T7iUTpwi3tsxJYQZSXfT9PE4LCXXS+By0zNY33Nz/3ACx4Vg0Gs+aofOuNafCM3NSvH3nHO4R2gO0E+wWnGmeQ5Bg8A+Qqv8BuBPi7y8gEg/84yDb5gmeuH0XTQad/zU2+10XRLfVPE19XtNpquOuP7TrdtvDaa1jskuRCGnDVmmQUeYZTzTHCak6TkkZwvkQN1bnGFeRp8x3pJghpijNz3lYpi8++ViiU5UCoKYQnd50WFoSPiJTVzwyEH3TBXZ8T6309cLR5IRgsJzAHb9PMsp+hnG1ggAC2y+2pppbRFpBFjxwSbsXXhEJnuwkAOXOU2Q8AFWkAfd1iqGJUrJ76X1Ja5mZnaqJqdVs+L5gAJJOTAYm/zIiGiYNSc+Q5N6nnquFE9ga+6gqSEVeAaNwu17136votCDiwBtd6eD3ZRALjcxSmw6yNUaupTvT9CFSj8QEKdb/kpkrXHp8zgiE2bjrTr/WEl+P+vhP/6b8tfmArnKLOnL+kAAAAASUVORK5CYII=",
sprout = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAC7klEQVR42u2YPW8UVxSGn3tnbCMLiaDIiXAJEgoiSoXSIP4ERKKgobKi+A/kN/APKKGMlBQmKVMEcBwRRVGa2IkiZCk0URryZdY7Hw/FXo1nd2dWXmwKFM8pdnc+znvnPR/vPRvk9R6RNx0gPxYvIX16vACBSECkbgGF5tfo1CsHOaNqvi9TklFQdqzCV6VEIle5yoec4SIVkT3+Zp+P+XnsLeyykKz7ahRx3W27ju/EePBsPpVVtoIVCQSkboUvUrPC51wDSiqWmis1NYFloG7CPgVQJ35PUZCzN8V4BM6xwRUKIjk5//KMAQNO8z4VOd8C+UE08onVX+Iui5zmLQoyfuUvnrDJJlXiHWo+4wpDFoEH3GOLP6iRNe5SscBPE0tu8R7FJ528brsu4oK4pu5buufN5tlM/EqtLLzQRAmR8cDilqVDq5bzgYWqD31HXPaptUP1tpibpYWd9bmquy5JOz3a2ZGLd9ShuuOWP7rtP6qWDtUfPONH6r76WFxIjnKD19WBtfeTn16AdfWF+okYzFz1hhua3G54z9qBet2QHAUXxMfpjluzAKJ43sJK/TIxO7Kb7llaqpW1+tyzKdszc/G2OrT2qYuT9TNeXrjkrva4GDkve+D31bWx81MAo5e7P4OEUi16CXw0XsN9ALdmhLFU654U+N5zxnaCdgEEg4szE7GeqJCDJF4Zz/9ugBGDs0qpnFGGsas1TvfRKD5KNOmGN1w1MyTgQi195q6/+7Vf+KnXjE2Zdti0HkTg3aadZTDRzjJ+4wNqcv7rFB/6etF4Paz4UNXCwRgdlbrd3JelGNFv80pKpe4YEpWHsD7J7BLFwCqRyC+8BwQOp7Yz0Ns1uewpl/xG1Z2m7g9hs7YtVWtjMtK24rg3XjbZEYhtpT3+rWNKif/j5vcE4ATgBGBegKpv1Dv6lDnq/m9TzTs45nPMZVKQAX+mOYejCs6kjAYvu+mmlw8vmB5hjH0tQR4NhXM9E974f1teArqoWNAh9YXqAAAAAElFTkSuQmCC",
star = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADgElEQVR42u2YX2sdRRjGf7PnNKahaCFGCwVRkIIJJrZgamOTCwNKRfQbCF7qlR9A8E6/gd9CoRcVhARpco7RRC0NNuKV2losqSGobfNnz+7Pi51szklisweP2At3YJmd2Zl3532eed53Nsi/eyU8UAYSAqG7MeHBcVFCYIQmTUa6WoVVSyI2VF2IT5VK1emDeMzbZrbc9GR1E0kXrhzjUQAeYhwIvcUgAOeBHIGp6gbqFQ3k5bQ7prJeglwgsKrm5updH4+tPcKgQGCIHAjkDHCmqnuTLhEIHe7qmYH2KYtVT8bWnmCwi4Au2VBz//SxaigkXSCQAp9xEUg5xli19SeVEAglMZssAgITkbL/aB8U4hyQKaCPlKtss0kfMIUE6uSF5HSHQTCxbq18HnTVXF02iEtq7ronyv6adZODEakf8MWSITkwwAgvMslZhmiRMI9AkzNkHOcbvmSeJte4F8fXCPtW1CbHu1/Q56hv+7E/u3OlbqpvifiGumVa9l33E9/1eQc6PBDrnRGtn1OcY4pxno4tKdIX679wjpsEBmgwFtu2CRyJ9Rt8zRxNVri7N2QmyDAf8QRPlj0ZSWTJHywzzwqz/Bq32nFeY5hJRnk4uiGjVnLqBj/yDisE8h0DAfmKcQBaMTzCBg1mWOB71kqMLO8AgzzDC0wzxdHS24WhRc4W7yV7KJWVkgySssUW6T7iUTpwi3tsxJYQZSXfT9PE4LCXXS+By0zNY33Nz/3ACx4Vg0Gs+aofOuNafCM3NSvH3nHO4R2gO0E+wWnGmeQ5Bg8A+Qqv8BuBPi7y8gEg/84yDb5gmeuH0XTQad/zU2+10XRLfVPE19XtNpquOuP7TrdtvDaa1jskuRCGnDVmmQUeYZTzTHCak6TkkZwvkQN1bnGFeRp8x3pJghpijNz3lYpi8++ViiU5UCoKYQnd50WFoSPiJTVzwyEH3TBXZ8T6309cLR5IRgsJzAHb9PMsp+hnG1ggAC2y+2pppbRFpBFjxwSbsXXhEJnuwkAOXOU2Q8AFWkAfd1iqGJUrJ76X1Ja5mZnaqJqdVs+L5gAJJOTAYm/zIiGiYNSc+Q5N6nnquFE9ga+6gqSEVeAaNwu17136votCDiwBtd6eD3ZRALjcxSmw6yNUaupTvT9CFSj8QEKdb/kpkrXHp8zgiE2bjrTr/WEl+P+vhP/6b8tfmArnKLOnL+kAAAAASUVORK5CYII=",
sun = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAEDklEQVR42rWYTWgdVRTH//fe0bS+2GJBhIgrq2BCDIFuLKmCYkFw9Soq4geuxK2uostiV924EnEjSIUiFlcWigiKie2iYEFTsYKr5FWqFl9Sk/fezPxczH23M2/mJTMpmbuZuR/n+5z/uWNQo8dKSpseaLI7VdrsjGmowZSktUYnqDsc4gRdurT9V61Rl7zBIH4BYCV81xhRA1UlJyT9E75rPFUMnIzSylhBRtKmJFNiYGWFkp0ZGL/JVrAwXoBx8VXB2JZIoAUtalZpBaHscFyhc6pZLWrB6zg2ihziGDGwzhwiyjlZiGvExFwecXKEmGMdiDk2GmG2ZILjctrQpM5rWnEwYbbzhpycBsFYmZFjTeu8JrUhp+OFtZIGFsMcXaAPdJhG2NzaDEssMYPJzYppOv5El7ncWmUeWMQ8HaAHrBVYlEdGfs3v7jBf3l2dsZlMm8AKEzl7Wz9uJ98EK35npq+rk8lRYAE3mfQutjmXRzg/O8lNCOSjuqUiQsxwhVXaXumhZAe5L+cTi2izyhVmqskztppapXLap1s+KtC8XteTekhWq7qoM/o+pFVLW0oqE3PbamqDnAbLaRKKz6feeDa3u2E1NRgMDss5IGErEO8xAJZpeQHM7su1Q5wGeqTA75zlDD97JvDFtkFcYOC8ujYYZaj448CAmJh3mPB732CdhB7wXAiA4bmMQgiLfKWpjqYPgS3gXYTB4bCIF7xWX22DbmYYRVap2npfm+rJCB3Qlt7SVRkh9JPmJP2hwzLCl+RIAy3pqKQ/9bBuySnVY/pY+9SVEZrQfn2gc7JKMzNM0R+JkUveQAf5C4DPC5JGGE4BMQmP+JVLIxT6TCHsTi2I8bUxDm/D+dgjnN0JMlNZrellvad7ZLxZbuhtT/BfXdchSUdEDq+MUj0hKdLf6viZN/WR7g8U/tMprWUmuu1kw6jLI8QnpPSA1xARERF3IZ4ipk/KhUKgFimYYpiagv9tCN6jQJ+EDV4M68/Q8WxfCjXIjlBw5VpkQudADm0TfaZX1dOEpB/0o2Id0bOS+rpb3+npQq9qAiZTp7MzPnVaLAP9XKTF9IDfeADjE2wXpcLmFL+Xs4F07N++4UEPQbsqdhkGtHIue54vWWVAwnW+5pUc2RZuPIt6gGMCqcM8yoFCKOwAOPUh0+Uy2d4JZG4H+s6POwD9PW5b9rzxihAngfUgfVRw6EUAlgtyRkGLdeDkqCfqN78GcZmYmGsVFWts81uFQgssMltymEVcAOBqCQUdYpZFFsroOAboKlxrEd8C8GsFzFrGgG9U0SiNv0IlY29naf0rlMqbAtn9HnZUySKtewmshk5JOiTjBTB7cxFv06XLiSYX8T3/ldCMQdZB2yb/W8xe/875H9T19Mma8e/5AAAAAElFTkSuQmCC",
target = "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",
trash = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAC7klEQVR42sWYyW4TQRCGv27HxMGOE4vYREgcOBIucOUGL8PyQCwHniTiipIXgAsKEmJJSCKI4y2Op4vD9Iwns3X3IdBzGKmna/lr+d1lJVzv0tesnxUPFwRQJV/ifVMvruS/ItAIO7yhxRBF1heF0GXGcz46UEj1o0QLsid164MgukaHA4EATSIMjUI5CBGKPmBy6LxDJGiEUxrAgi+5r3dpoVn452BZLcuq0fZEg888sJGP9w27PAEUOt2/Km/yBkwalOXbgPXREGXcijL7phDU7NuWqUa4z1taDIEN4AyFoBAe0QMm7OewP7T7e2lVxXLQZcYzPlkUtl6Q/cpKiSQK2hcR2bdaS5NsEBvbejrRhXoHle/5bIheMwDu0AUWHBDS5MI9VoEJX4FfvLgaouRpCvJORIwMZdvVQpmGRJpyICIiu4I0sl+zgYgtfgci1ulma8HZjm02AfhpU66LfWBsFc+sSAeFdnFlWkE3uYGgmAKaaOlaMcmH1sBm2jw+Bjq0WbCSStdUyMS+N4JYecMqHrtKDY4zIspLuQLWc9I1CMZW5Ja399nTIzeC3xmf/FfHvk/dORgzRQODIAN969Z5vYE4TTM00A4y0LYGztw5mDAE4HZK4T5rG2gwZuQO0QUzAFpBCNYAxTwt8soQKeAkjarxKlRjEcAfVx/EcZwCsEojAEHLor90GdDAEQA9z0KNKbIPts20KwcJ3TVZ9fY/OTvzu/z+sITtTxYJWR8WNZYZmKYc77tisk6y5zRwZA30vBAooEObyCLwMBBO2JVkTcmNM5Swa8m6HEEYYdeSdTmCcMKuJOsqBKGEPagi6+KPfkLYa0AbjXaOiRpdTdbl88GEc3rAFoa50/s5sFVF1uUGLhgBhse8r5tdMpeWHQTFRZGsqyecCGGTp95ZWKAYlfXBSklMDcMgqk70fOOyeBcszsnx6PqKfvEqXjuqHvOybKStHsRV0PW98rSu2A1TT25k+Zd/JVz7vy1/AZCcrjCPp4hFAAAAAElFTkSuQmCC",
type = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABiElEQVR42u2XsU7DQAyGP1+DhBhACHXkAaATTwU8EfAwjEXtCwAbD1AxwIAQNPcz9EiT9JIctIUl9pT47N8+++5sE9slRw/QQVkNToC1rE+T++UP059F4BCnXLPLK0YM1xAHwEuLfJ93LrgvRaEFm5zQRJugOyEX7JYiELBDjmfQmHoFz5vlOcYQ8N9RZoXIIZ4ZAHOeGgwcswd8tMh3ccxXnBIhqFtJ0mPYNCr8S7lrLbh1vqPnIA9LLXokfaleqFWScPhCPwKwWH5EDmThuCia4KUJVUrUo0I/GoEhPhkAs5q/adSkX0qSaaSxxhqFU/HTJEf1USp3ATSwqyXSsDVu2Ih+tYp8W8ElUES/f9F6gB6gB+gBeoB/mA/iLiyaGFeaDFwxBVhX95ElP4MeQtfpS0Y7n9f2AcQhTrgpZoYzDoE3JsUscM5DRxQtLYfJhKaV3j9XXvmeFusaONt2UaRs0RVDbKUhFmLGZdcWpQ2BzTPZBkJ2jYaU0gWmR2AR81o3B/1dBHwBYA6kGp9fCPcAAAAASUVORK5CYII=",
upgrade = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABNElEQVR42u2XMU7DQBBF/6x9CGipInOBlFx+ixyAAtGTkgYiBaQ8ijgxsI49I0MBWluytph5b722v9aGfvdIqoIq+GeCJJPFeowI/lCMfvAOGh20UlZWp4Nadx++s0Fc8wjAlg7R+jr9+CvugT37mCKGfwPgPaKIzR6e2fYjpyKGf2HNTUwRwb9yhxC3EUUU39IiOr8iild/dSvi+KAihk8YRoooxvDpIv5zxZgieQQJo+OhwDeIFZl8nu1XxRNdf3eTAsMQG2BX4MssGhQ7YHPudwm+48ezaFA4BaclymTWBX4si46K49I5lqh83PNZlOJf8vA6+rJoqK9Z9OezSHFFJIs0q1iURZpRLMwizSgWZpEcigVZJIfiYhZNb359m9zJqnFBEpLMvYeeqLf6n1wFVaAPqDUkw411WfkAAAAASUVORK5CYII=",
user = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADrUlEQVR42u2Yz2tUVxTHP/e+iQqxBikqxHRRkG6UQsBNu7DY0kVpl6UpoT/+B4srceFCFHHTdRECRUGkJQjtonRjaVMXQgt1ISJFCtZoY2J/mjfz3ny6yM04M5mZN0lqodB7NsObd8733HvO+Z5zX5AnuyL/A/zXAALhSQFEaoAI1MiG9mjINM0oARgjspQAV8D+AYAAyCTvcYhniNzhKuf5CghDQFglwWD0rKWda8btYqjSrzafGf1ULV1uGc9tqHOOGqsgqgAy8aya21RvedHzXk8gekmMmwGI4vNqw8LCI25NoO/7u6W5+lpyYoMANfFDdVn9IB1YZhTfTLua3QxAMIjfq/qjMZnG4Ij4jarzjg4OdaxIsTEmALhKE2i2Ei9wBSjZxXhK5A1W8io1FF0kESgACVUWqgB+ZR6Ag9jmaaDJC0CNRe7CwHKrDPJHNs3Vd8WaNWuOiC9ZWLfpF1WJWl0FL6p1S//wrdbzV7ybYKeSG32liosySj7mHXK2Al/zLQUHeRWos4UrvNwK/Qa5KBgddU6tW29RRWGu3nSPYXOVTMrxp7zYMl2kX1+6t5oohgFYLaM3/MQ7Fpbe83OnW1RSIcM1nEikAEbZS8YdfgMySE1okw0nEPsaymhWtZzBAKvGdzHOJK/zHA+Ap7nJZ3zHz/wyBEhFFeCEJ1yw11rwhBNtb64zyCPiuBdcUrXhclvTLF22oeqSFxxPb68LIIiHvKWpG6jWnfeGN5xvVcTKP7c81J+y+/XhzDOWLRMPveS0+9xhMLjDfU57yYctkNIzZma9QPpR3Cm1sK7e9ng66W6Z8Li31bqFeqo3K/UO7dHW5DDjzvQ0MxqSRLMU2J3OqA1z9WivcPcyfyy1+RWvsNbnfEPyeGW3DfXYWojuKSI65qKldfXIAOOdIEcSpS86ZuwkkLX+n0yBuzyE+ccQl5PWye49dE9Bkz6yYemiu7t9GTA9RXe7aGnDR052kmDs6s9TbKMgcpr7xIpWsrqaRO5zmkjBNqa6On1XcV1Tmy64PU1Fw0kwuN0Fm+q1zqLrPP/Dal09VzWv9Uzuc0n7cLt27LgFvJ04fnbdV6VAYDb15+n2UWztXLSFnOs45Pk/joP8QM4IMNJ/8KoBkT9ZqhimerE+3OUeEdjTPmnUWlssgQOUwF882tCNNSenBJ4FmqvXq84YQEbGT+Trvt6uRPMBGRlLHXbbyiW43znnPFA97fQst1X9/e364d/92hIJ1QP5QGtr9P8G23LWezfVxNEAAAAASUVORK5CYII=",
wifi = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAAD+0lEQVR42u2Xz2tUVxTHP/fN06gwDARJUxCKFArRWoJgDVKlhQaEFncirdtutBs3+QeCPxaibuyuoAuxdOXCFrootNAuasEgtaZSFBUUUUSJipmZzMyni7nz5k1mJhltsynes3k/zv2ee88533PPDbKyI+G1gf+9gXQAnUBCQCDEL81nabBsEgaX2l0CNGjwL3T6GUgI1ONziXd4j0+p84wASJEC3/EHfzMXdQrY20gvAy3wDXzOm4wzxht9lveAv7jCfc5zt68ROyUxiDjmKR/ZGlUr1mxk7w1rVqxm74885ZiIwaQTsRO+IOKEZy2rOu+C7fHcx1Ge574uOK9q2bNO5FCitF0UKFBjC1+xE5AqQwDcYpbfuMJN5piPMVhLibcZZ4JNbASgwmoC8AtfcpWUepZfHWvf62N1wYqq9zzsdodkCRlyu4e9p2rFBfWxe/P7aHke13g6qqnOesjhLC6pBRNDThILppm/hz3kbG72addEVJqBwV3OqFXr6iX3x3WnWdD7STAxjXvZ7yW1blWdcVcTubmV6Zz1o3FzhRx0c70Fkyitt7aZ1pyjOaRpsYBYtGzVF+odd4vBNAMPcX39pFMziLu9o76watmiBBMSfuID4Gf28TCXAW02b2ATW3mfUsyMOX5nhlnuLmJxMxNH+JYPgV/5iEYzFKOe9IjrJLfepgNGnPJyR97neXHZKUdy2kSEdR7xpKNisjhk5Pg47gkfRLA8b1vcbo4HnnA8VwPoTIu2/9rebAZsKpaGcgb61Nte97q3fZp9K8fSMdXB4Rxed9gScdhzaj0WgWde9KA7HHXIYHDIUXd40Is+iwWlrp5zuMNVPWtRU2GPNzW65L7TbuybQxud9n50md50T7eJbvgxa+q8WvV4FsLUQgeT2zwe8bjVOKPm2GIT3dV0Inr3WqyNafe2cwtKY/29FmdNLK6mvVw07UMvWBJX5TKjYJqtP83xPLhKLHnBh053u6j3kVliDihEmjXp06thaFGyqVnKDtBlj8xGrPutN1jLx2xld9T4gRl+ZD77S9RPlj8yF1OlIBY95o0uHt/wmMUOj/esuyxTjHGbM5HLlQy89Tzjtn7AgxgoiJPW1Ip1VZ94y1s+UbVuRa05uThvBjeQiudtxFJ3xknXu9rVrnfSM7HcNTzfUSJfegf74um8s+vvzngS71t6B8Glu1L5hC18wx1SjM1yAwjUeIvPuMr3sW99hd60ZaKV6W2ggDmW+KrNb6vrDDRoEJB3+QL4mj8JSEKCWQfbbziYJAY3x3PgqZu7W8R+kgx8UZEDFClTpsiBwWeu+A1nxV0UBr6Idwd5sGkvcdPvTFP+ewOD3dr+lYHXN/2VGP8AyhbE4oqTlwsAAAAASUVORK5CYII=",
x = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABmElEQVR42u2XP0vDQBiHf5f0C7jVVYpI3KVufnAdM3RXQbo49Q8ILtpiSfM4JLU2vVzeEzoI6UHp8N7z5L0kv7s6dNpPol7QC/6pIJGTi5AH6h3hiaUJX8Z0kMgpU65cmUoNOvGpSl3V9b4uOBwOh5gAMCdDDFBgpIhzpgBMfub/Gu3rvNZQD8pUBLpItdVQ9xppLcl5a46uKcGRMQO+OrpIEUOe6soPbnCkzSrfxASRMe9QHOI/uatnGgQVLqzw4b19tt28sMKMbxeEFBH4kKBNEYUPC/yKKHyXoKmYMeIsBt8taCpeeYzBWwQ7xQIooP5e2/A2QQW6ZEpJQcGWJbc2PMbMR9KbVruI10YL815huIrqwXw+WKKlIWmNS7R/7jfAO/P619ymsOOrxBxz0RmDEQLfWyuuYxSx+IEhaY2C9syJUsTjIxV/wUcp2rbM7sT0KUxbZrXpvxgirZm0Ge5Y0X4uWhkSc69YtZ2LQgcvSyDvFUbBbolycsamtKkUObl/iU5++PULEiHJmfAd9a7/n9wLeoG+AezctEkch1+dAAAAAElFTkSuQmCC",
zap = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAADbElEQVR42rWYz4scRRiGn6ru2Q2iexOTNWZR9GD0IsqgJw/+A95k8eQpyVW8R/BuDiLBiyBCrgGJ5pIVUdi4CIJo9CKYkCgIJhfR3Znp7sfD1MzO7Pzo7t2169Z01Vv1fe/7vV91kJZPRCBQNfs8tAQI2HY/bXf/LNts8xyh4Vybj2DmCX9U9aYYDfWz8hbBySj4lOfZo8MaUBGO8wQd8aI6sFCviVmTeU2Xz8VNdWDlQL2c3tWOZonKKOjyMSVZCsvt42RRpGSdq5yAcdTvHB9AILDKVdYpyNJ54C40VEQtNXPxitpTb3tdrRz4pBiPI8kj7vQtrOz6iap/+rA0UUEdwD53+uo5STL7IZ3uiACZ2HXXwp56SVzzD1W/aKqCZQBRXPf3FP1rYnTDvmUbFSzWwT53+qxwi00yKk7SoWijAhbUolHd6dKnw31e529WKDmTyHmPSFy4uWm/aMCd18TMXHwnBeyF5jU4n3uqAZu8SwFknGeLnIIcOJ2k+SG7C6wnIGvscY5f0ilquPN+SmcwiDctUprrnp0Rjeu5kxvEYBR3apYtLSzsWfrdCGDakwORnK/pJu68wj+Q0jW0y8s8SphrNJF/OUsHqYi8yjdklNMhmqw7lX/59Fw5hSWaH1iONZ/NCm2WO/lMAONSzVf2J/J2AGC/7hTqBXHVODNCAgnjMVz+8Tl5mwKIYtc9Cwfqey17jVV30vI/+cj0OYdJHiZwi5NURCq+Ig7h53L8PD+PlTrU/BU26dPhAS/za0rulOGERMGepWUtzyd7onman1NNQwOOD3net/DWeM6sX+TzS0UA3lrC8VGIniIj8huQUU70GhUrXOIjcorlnhyWusMZexNusEjzC/0g1nbOp1gZu0Gc8YtINW/+fjWtEk/Cwr565AZ3gEB5wC+mubPAcFzS7QwBAnCXSI+LbDIgA96YoeYhmt9c/EAtHPiM+OZy7rRvfjPxM1Xvm/uSewf84ogAw5rzvarf+pj36rjTHgAfSj3RDb9cVHcODxDFDftqZakWS/ziUFeoAJyigwRC4sty7rS8ZQbgiaQVqci4wBZ5/fJtrrEbSSMlnYV150gApwEoyPmct5vtvqnQ9nui3abcaZ9kiWRkPFhWdw5fKqLBs2677YvNbwaTntzuf0XV5vP8//qNM3r+A7SUQtO9oWosAAAAAElFTkSuQmCC",
}
local IconAsset = {}
local function B64Decode(data)
local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local map = {}
for i = 1, 64 do map[b:sub(i, i)] = i - 1 end
local out, buf, bits = {}, 0, 0
for i = 1, #data do
local v = map[data:sub(i, i)]
if v then
buf = buf * 64 + v
bits += 6
if bits >= 8 then
bits -= 8
local byte = math.floor(buf / 2 ^ bits) % 256
out[#out + 1] = string.char(byte)
buf = buf % 2 ^ bits
end
end
end
return table.concat(out)
end
local function IconImage(name)
if IconAsset[name] ~= nil then return IconAsset[name] or nil end
IconAsset[name] = false
local data = IconPNG[name]
local getAsset = getcustomasset or getsynasset
if not data or type(getAsset) ~= "function" or type(writefile) ~= "function" then return nil end
local ok, id = pcall(function()
local dir = "KriegHub/icons"
if typeof(isfolder) == "function" and typeof(makefolder) == "function" then
if not isfolder("KriegHub") then makefolder("KriegHub") end
if not isfolder(dir) then makefolder(dir) end
end
local path = dir .. "/v3_" .. name .. ".png"
if not (typeof(isfile) == "function" and isfile(path)) then writefile(path, B64Decode(data)) end
return getAsset(path)
end)
if ok and type(id) == "string" and id ~= "" then IconAsset[name] = id return id end
return nil
end
local function BuildIcon(parent, name, size, color, thick)
local img = IconImage(name)
if img then
local holder = Create("ImageLabel", { BackgroundTransparency = 1, Size = UDim2.fromOffset(size, size), Image = img, ImageColor3 = color, ScaleType = Enum.ScaleType.Fit, Parent = parent })
local api = { Frame = holder }
function api:SetColor(c, tt)
if tt and tt > 0 then Tween(holder, tt, { ImageColor3 = c }) else holder.ImageColor3 = c end
end
function api:SetTransparency(a, tt)
if tt and tt > 0 then Tween(holder, tt, { ImageTransparency = a }) else holder.ImageTransparency = a end
end
return api
end
local def = Icons[name] or Icons.dot
local s = size / 24
local t = thick or math.max(1.2, 1.85 * s)
local holder = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(size, size), Parent = parent })
local parts = {}
local function line(x1, y1, x2, y2)
x1, y1, x2, y2 = x1 * s, y1 * s, x2 * s, y2 * s
local dx, dy = x2 - x1, y2 - y1
local len = math.sqrt(dx * dx + dy * dy)
local f = Create("Frame", {
AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2),
Size = UDim2.fromOffset(len + t, t), Rotation = math.deg(math.atan2(dy, dx)),
BorderSizePixel = 0, BackgroundColor3 = color, Parent = holder,
}, { Round() })
table.insert(parts, { f, "BackgroundColor3", "BackgroundTransparency" })
end
for _, p in ipairs(def) do
local k = p[1]
if k == "l" then
line(p[2], p[3], p[4], p[5])
elseif k == "p" then
local pts = p[2]
for i = 1, #pts - 2, 2 do line(pts[i], pts[i + 1], pts[i + 2], pts[i + 3]) end
elseif k == "c" then
local r = p[4] * s
local f = Create("Frame", {
AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromOffset(p[2] * s, p[3] * s),
Size = UDim2.fromOffset(2 * r - t, 2 * r - t), BackgroundTransparency = 1, Parent = holder,
}, { Round() })
local st = Create("UIStroke", { Thickness = t, Color = color, Parent = f })
table.insert(parts, { st, "Color", "Transparency" })
elseif k == "d" then
local r = p[4] * s
local f = Create("Frame", {
AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromOffset(p[2] * s, p[3] * s),
Size = UDim2.fromOffset(2 * r, 2 * r), BackgroundColor3 = color, BorderSizePixel = 0, Parent = holder,
}, { Round() })
table.insert(parts, { f, "BackgroundColor3", "BackgroundTransparency" })
elseif k == "r" then
local x, y, w, h, rad, rot = p[2] * s, p[3] * s, p[4] * s, p[5] * s, p[6] * s, p[7]
local f = Create("Frame", {
AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromOffset(x + w / 2, y + h / 2),
Size = UDim2.fromOffset(w - t, h - t), Rotation = rot, BackgroundTransparency = 1, Parent = holder,
}, { Create("UICorner", { CornerRadius = UDim.new(0, math.max(0, rad - t / 2)) }) })
local st = Create("UIStroke", { Thickness = t, Color = color, Parent = f })
table.insert(parts, { st, "Color", "Transparency" })
elseif k == "f" then
local f = Create("Frame", {
AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromOffset(p[2] * s, p[3] * s),
Size = UDim2.fromOffset(p[4] * s, p[5] * s), Rotation = p[7], BackgroundColor3 = color,
BorderSizePixel = 0, Parent = holder,
}, { Create("UICorner", { CornerRadius = UDim.new(0, p[6] * s) }) })
table.insert(parts, { f, "BackgroundColor3", "BackgroundTransparency" })
end
end
local api = { Frame = holder }
function api:SetColor(c, tt)
for _, pp in ipairs(parts) do
if tt and tt > 0 then Tween(pp[1], tt, { [pp[2]] = c }) else pp[1][pp[2]] = c end
end
end
function api:SetTransparency(a, tt)
for _, pp in ipairs(parts) do
if tt and tt > 0 then Tween(pp[1], tt, { [pp[3]] = a }) else pp[1][pp[3]] = a end
end
end
return api
end
local function Icon(parent, name, size, key, thick)
local api = BuildIcon(parent, name, size, key and Current[key] or WHITE, thick)
if key then OnTheme(function(th) api:SetColor(th[key], .4) end) end
return api
end
local function Centered(api)
api.Frame.AnchorPoint = Vector2.new(.5, .5)
api.Frame.Position = UDim2.fromScale(.5, .5)
return api
end
local function Ripple(btn)
local m = UIS:GetMouseLocation()
local inset = game:GetService("GuiService"):GetGuiInset()
local x, y = m.X - btn.AbsolutePosition.X, m.Y - btn.AbsolutePosition.Y
local r = Create("Frame", {
AnchorPoint = Vector2.new(.5, .5), BackgroundColor3 = WHITE, BackgroundTransparency = .82,
Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(0, 0), Parent = btn,
}, { Round() })
local s = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.2
Tween(r, .6, { Size = UDim2.fromOffset(s, s), BackgroundTransparency = 1 })
task.delay(.6, function() r:Destroy() end)
end
local MemConfigs, MemAutoload = {}, nil
function Krieg:_Ensure()
if FS_OK and typeof(isfolder) == "function" and typeof(makefolder) == "function" then
if not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end
if not isfolder(self.ConfigFolder .. "/configs") then makefolder(self.ConfigFolder .. "/configs") end
end
end
function Krieg:_Path(name) return self.ConfigFolder .. "/configs/" .. name .. ".json" end
function Krieg:SaveConfig(name)
if not name or name == "" then return false end
local data = { Theme = self.CurrentTheme, Flags = {} }
for flag, api in pairs(self.Flags) do
local v = api.Value
if typeof(v) == "EnumItem" then v = { __key = v.Name } end
data.Flags[flag] = v
end
local json = HttpService:JSONEncode(data)
if FS_OK then
self:_Ensure()
writefile(self:_Path(name), json)
else
MemConfigs[name] = json
end
return true
end
function Krieg:LoadConfig(name)
if not name or name == "" then return false end
local json
if FS_OK then
if isfile(self:_Path(name)) then json = readfile(self:_Path(name)) end
else
json = MemConfigs[name]
end
if not json then return false end
local ok, data = pcall(HttpService.JSONDecode, HttpService, json)
if not ok or type(data) ~= "table" then return false end
if data.Theme then self:SetTheme(data.Theme) end
for flag, v in pairs(data.Flags or {}) do
local api = self.Flags[flag]
if api then
if type(v) == "table" and v.__key then v = Enum.KeyCode[v.__key] end
pcall(api.Set, api, v)
end
end
return true
end
function Krieg:DeleteConfig(name)
if not name then return end
if FS_OK then
if typeof(delfile) == "function" and isfile(self:_Path(name)) then delfile(self:_Path(name)) end
else
MemConfigs[name] = nil
end
end
function Krieg:ListConfigs()
local out = {}
if FS_OK and typeof(listfiles) == "function" then
self:_Ensure()
for _, f in ipairs(listfiles(self.ConfigFolder .. "/configs")) do
local n = f:match("([^/\\]+)%.json$")
if n then table.insert(out, n) end
end
else
for n in pairs(MemConfigs) do table.insert(out, n) end
end
table.sort(out)
return out
end
function Krieg:SetAutoload(name)
local p = self.ConfigFolder .. "/autoload.txt"
if FS_OK then
self:_Ensure()
if name then writefile(p, name)
elseif typeof(delfile) == "function" and isfile(p) then delfile(p) end
else
MemAutoload = name
end
end
function Krieg:GetAutoload()
local p = self.ConfigFolder .. "/autoload.txt"
if FS_OK then
if isfile(p) then return readfile(p) end
return nil
end
return MemAutoload
end
function Krieg:LoadAutoload()
local n = self:GetAutoload()
if n and n ~= "" and self:LoadConfig(n) then
self:Notify({ Title = "Auto Load", Content = tr("Loaded") .. ": " .. n, Icon = "folder" })
end
end
local Section = {}
Section.__index = Section
local function Register(sec, name, frame, isSection)
table.insert(sec.Tab.Elements, { Name = string.lower(name or ""), Raw = name or "", Frame = frame, IsSection = isSection })
end
local function FitControl(row, control, labels, maxW, minW)
local function upd()
local w = row.AbsoluteSize.X / UScale()
if w <= 0 then return end
local cw = math.clamp(math.floor(w * .46), minW or 90, maxW or 160)
control.Size = UDim2.fromOffset(cw, control.Size.Y.Offset)
for _, l in ipairs(labels) do
l.Size = UDim2.new(1, -(cw + 12), l.Size.Y.Scale, l.Size.Y.Offset)
end
end
row:GetPropertyChangedSignal("AbsoluteSize"):Connect(upd)
task.defer(upd)
end
local function RowWithText(sec, name, desc, rightWidth)
local h = desc and 46 or 36
local row = Create("TextButton", {
Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
Parent = sec.Content,
})
local rw = rightWidth or 60
local labels = {}
if desc then
labels[1] = Text(row, name, 13, "Text", FONT.Semi, { Position = UDim2.fromOffset(0, 5), Size = UDim2.new(1, -rw, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd })
labels[2] = Text(row, desc, 11, "Sub", FONT.Reg, { Position = UDim2.fromOffset(0, 24), Size = UDim2.new(1, -rw, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd })
else
labels[1] = Text(row, name, 13, "Text", FONT.Semi, { Size = UDim2.new(1, -rw, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd })
end
Register(sec, name, row)
return row, labels
end
function Section:Toggle(cfg)
local state = cfg.Default and true or false
local row = RowWithText(self, cfg.Name, cfg.Description, 60)
local sw = Create("Frame", { AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, 0, .5, 0), Size = UDim2.fromOffset(42, 24), Parent = row }, { Round() })
local swStroke = Stroke(sw, "Stroke")
local fill = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BackgroundTransparency = 1, Parent = sw }, { Round() })
ThemeGrad(fill, 0)
local shine = Shine(fill, UDim.new(1, 0), .5, .55)
local knob = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.new(0, 12, .5, 0), Size = UDim2.fromOffset(18, 18), BackgroundColor3 = WHITE, Parent = sw }, { Round() })
Create("UIStroke", { Color = BLACK, Transparency = .82, Thickness = 1, Parent = knob })
local function render(t)
Tween(sw, t, { BackgroundColor3 = Current.Off })
Tween(fill, t, { BackgroundTransparency = state and 0 or 1 })
Tween(swStroke, t, { Transparency = state and 1 or 0 })
shine.Visible = state
Tween(knob, t, { Position = UDim2.new(0, state and 30 or 12, .5, 0) }, Enum.EasingStyle.Back)
end
render(0)
OnTheme(function() render(.3) end)
local api = { Value = state, Type = "Toggle" }
function api:Set(v, silent)
state = v and true or false
api.Value = state
render(.32)
Tween(knob, .12, { Size = UDim2.fromOffset(22, 18) })
task.delay(.12, function() Tween(knob, .25, { Size = UDim2.fromOffset(18, 18) }, Enum.EasingStyle.Back) end)
if not silent and cfg.Callback then task.spawn(cfg.Callback, state) end
end
row.MouseButton1Click:Connect(function() api:Set(not state) end)
if cfg.Flag then Krieg.Flags[cfg.Flag] = api end
if state and cfg.Callback then task.spawn(cfg.Callback, true) end
return api
end
function Section:Slider(cfg)
local min, max = cfg.Min or 0, cfg.Max or 100
local inc = cfg.Increment or 1
local value = math.clamp(cfg.Default or min, min, max)
local suffix = cfg.Suffix or ""
local row = Create("Frame", { Size = UDim2.new(1, 0, 0, 54), BackgroundTransparency = 1, Parent = self.Content })
Text(row, cfg.Name, 13, "Text", FONT.Semi, { Size = UDim2.new(1, -80, 0, 26), TextTruncate = Enum.TextTruncate.AtEnd })
local box = Create("TextBox", {
AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 1), Size = UDim2.fromOffset(66, 24),
FontFace = FONT.Bold, TextSize = 12, ClearTextOnFocus = false, Text = "", Parent = row,
}, { Corner(7) })
Bind(box, "BackgroundColor3", "Card2"); Bind(box, "TextColor3", "Text")
local boxStroke = Stroke(box)
local track = Create("TextButton", { Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = row })
local bar = Create("Frame", { AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, 0, .5, 0), Size = UDim2.new(1, 0, 0, 6), Parent = track }, { Round() })
Bind(bar, "BackgroundColor3", "Off")
local fill = Create("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = WHITE, Parent = bar }, { Round() })
ThemeGrad(fill, 0)
Shine(fill, UDim.new(1, 0), .45, .45)
local knob = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.new(0, 0, .5, 0), Size = UDim2.fromOffset(16, 16), BackgroundColor3 = WHITE, Parent = bar }, { Round() })
Stroke(knob, "Accent", 2.5)
local api = { Value = value, Type = "Slider" }
local function fmt(v)
if inc < 1 then
local m = tostring(inc):match("%.(%d+)$")
return string.format("%." .. (m and #m or 2) .. "f", v)
end
return tostring(math.floor(v + .5))
end
local function render(t)
local a = (value - min) / (max - min)
Tween(fill, t, { Size = UDim2.new(a, 0, 1, 0) })
Tween(knob, t, { Position = UDim2.new(a, 0, .5, 0) })
box.Text = fmt(value) .. suffix
end
function api:Set(v, silent)
v = tonumber(v) or value
v = math.clamp(math.floor((v - min) / inc + .5) * inc + min, min, max)
value = v
api.Value = v
render(.15)
if not silent and cfg.Callback then task.spawn(cfg.Callback, v) end
end
render(0)
local dragging = false
local function fromX(x)
local a = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
api:Set(min + (max - min) * a)
end
track.InputBegan:Connect(function(i)
if IsClick(i) then
dragging = true
Tween(knob, .2, { Size = UDim2.fromOffset(20, 20) }, Enum.EasingStyle.Back)
fromX(i.Position.X)
end
end)
track.MouseEnter:Connect(function() if not dragging then Tween(knob, .2, { Size = UDim2.fromOffset(18, 18) }) end end)
track.MouseLeave:Connect(function() if not dragging then Tween(knob, .2, { Size = UDim2.fromOffset(16, 16) }) end end)
Connect(UIS.InputChanged, function(i)
if dragging and IsMove(i) then fromX(i.Position.X) end
end)
Connect(UIS.InputEnded, function(i)
if dragging and IsClick(i) then
dragging = false
Tween(knob, .2, { Size = UDim2.fromOffset(16, 16) })
end
end)
box.Focused:Connect(function() Tween(boxStroke, .2, { Color = Current.Accent }) end)
box.FocusLost:Connect(function()
Tween(boxStroke, .2, { Color = Current.Stroke })
api:Set(tonumber((box.Text:gsub("[^%d%.%-]", ""))) or value)
end)
Register(self, cfg.Name, row)
if cfg.Flag then Krieg.Flags[cfg.Flag] = api end
return api
end
function Section:Button(cfg)
local primary = cfg.Primary
local btn = Create("TextButton", {
Size = UDim2.new(1, 0, 0, 36), Text = "", AutoButtonColor = false, ClipsDescendants = true, Parent = self.Content,
}, { Corner(9) })
local st
if primary then
btn.BackgroundColor3 = WHITE
ThemeGrad(btn, 0)
Shine(btn, UDim.new(0, 9), .5, .6)
else
Bind(btn, "BackgroundColor3", "Card2")
st = Stroke(btn)
end
local holder = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = btn }, {
Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder }),
})
if cfg.Icon then
local ic = Icon(holder, cfg.Icon, 15, primary and nil or "Accent")
if primary then ic:SetColor(WHITE) end
end
local lbl = Text(holder, cfg.Name, 13, primary and nil or "Text", FONT.Semi, { Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 2 })
if primary then lbl.TextColor3 = WHITE end
local sc = Create("UIScale", { Parent = btn })
btn.MouseEnter:Connect(function()
if not primary then
Tween(btn, .2, { BackgroundColor3 = Current.Hover })
Tween(st, .2, { Color = Current.Accent:Lerp(Current.Stroke, .45) })
end
end)
btn.MouseLeave:Connect(function()
if not primary then
Tween(btn, .2, { BackgroundColor3 = Current.Card2 })
Tween(st, .2, { Color = Current.Stroke })
end
Tween(sc, .2, { Scale = 1 })
end)
btn.MouseButton1Down:Connect(function() Tween(sc, .1, { Scale = .97 }) end)
btn.MouseButton1Up:Connect(function() Tween(sc, .3, { Scale = 1 }, Enum.EasingStyle.Back) end)
btn.MouseButton1Click:Connect(function()
Ripple(btn)
if cfg.Callback then task.spawn(cfg.Callback) end
end)
Register(self, cfg.Name, btn)
return btn
end
function Section:Dropdown(cfg)
local options = cfg.Options or {}
local multi = cfg.Multi
local value = cfg.Default
if value == nil then value = multi and {} or options[1] end
local holder = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = self.Content }, { List(5) })
local row = Create("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, LayoutOrder = 1, Parent = holder })
local ddLabel = Text(row, cfg.Name, 13, "Text", FONT.Semi, { Size = UDim2.new(1, -165, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd })
local btn = Create("TextButton", { AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, 0, .5, 0), Size = UDim2.fromOffset(155, 30), Text = "", AutoButtonColor = false, Parent = row }, { Corner(8) })
FitControl(row, btn, { ddLabel }, 165, 95)
Bind(btn, "BackgroundColor3", "Card2")
local bst = Stroke(btn)
local valLbl = Text(btn, "", 12, "Text", FONT.Med, { Position = UDim2.fromOffset(11, 0), Size = UDim2.new(1, -36, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, NoTr = true })
local arrow = Icon(btn, "chevron", 14, "Sub")
arrow.Frame.AnchorPoint = Vector2.new(1, .5)
arrow.Frame.Position = UDim2.new(1, -10, .5, 0)
local list = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true, LayoutOrder = 2, Visible = false, Parent = holder }, { Corner(9) })
Bind(list, "BackgroundColor3", "Card2"); Stroke(list)
local scroll = Create("ScrollingFrame", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = list,
}, { List(2), Pad(4, 4, 4, 4) })
Bind(scroll, "ScrollBarImageColor3", "Accent")
local api = { Value = value, Type = "Dropdown" }
local open, items = false, {}
local function isSel(o)
if multi then return table.find(value, o) ~= nil end
return value == o
end
local function display()
if multi then
local t = {}
for _, v in ipairs(value) do table.insert(t, tr(tostring(v))) end
valLbl.Text = #t > 0 and table.concat(t, ", ") or tr("None")
else
valLbl.Text = value ~= nil and tr(tostring(value)) or tr("None")
end
end
local function paint(t)
for o, it in pairs(items) do
local s = isSel(o)
Tween(it.Button, t or .2, { BackgroundTransparency = s and .82 or 1, BackgroundColor3 = Current.Accent })
Tween(it.Label, t or .2, { TextColor3 = s and Current.Accent or Current.Text })
it.Check:SetColor(Current.Accent)
it.Check:SetTransparency(s and 0 or 1, t or .2)
end
end
local function height() return math.min(#options, 5) * 32 + 6 end
local function setOpen(v)
open = v
Tween(arrow.Frame, .3, { Rotation = v and 180 or 0 })
Tween(bst, .2, { Color = v and Current.Accent or Current.Stroke })
if v then
list.Visible = true
Tween(list, .35, { Size = UDim2.new(1, 0, 0, height()) })
else
Tween(list, .25, { Size = UDim2.new(1, 0, 0, 0) })
task.delay(.25, function() if not open then list.Visible = false end end)
end
end
local function build()
for _, it in pairs(items) do it.Button:Destroy() end
items = {}
for i, o in ipairs(options) do
local b = Create("TextButton", { Size = UDim2.new(1, 0, 0, 30), Text = "", AutoButtonColor = false, BackgroundTransparency = 1, LayoutOrder = i, Parent = scroll }, { Corner(7) })
local lbl = Text(b, tostring(o), 12, nil, FONT.Med, { Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -36, 1, 0), TextColor3 = Current.Text })
local chk = BuildIcon(b, "check", 13, Current.Accent)
chk.Frame.AnchorPoint = Vector2.new(1, .5)
chk.Frame.Position = UDim2.new(1, -10, .5, 0)
items[o] = { Button = b, Label = lbl, Check = chk }
b.MouseEnter:Connect(function() if not isSel(o) then Tween(b, .15, { BackgroundTransparency = .5, BackgroundColor3 = Current.Hover }) end end)
b.MouseLeave:Connect(function() if not isSel(o) then Tween(b, .15, { BackgroundTransparency = 1 }) end end)
b.MouseButton1Click:Connect(function()
if multi then
local idx = table.find(value, o)
if idx then table.remove(value, idx) else table.insert(value, o) end
api:Set(value)
else
api:Set(o)
setOpen(false)
end
end)
end
paint(0)
if open then Tween(list, .2, { Size = UDim2.new(1, 0, 0, height()) }) end
end
function api:Set(v, silent)
value = v
api.Value = v
display(); paint()
if not silent and cfg.Callback then task.spawn(cfg.Callback, v) end
end
function api:Refresh(newOptions, keep)
options = newOptions or {}
if not keep then
if multi then value = {} elseif not table.find(options, value) then value = options[1] end
api.Value = value
end
build(); display()
end
btn.MouseButton1Click:Connect(function() setOpen(not open) end)
OnTheme(function() paint(.3) end)
OnLang(display)
build(); display()
Register(self, cfg.Name, holder)
if cfg.Flag then Krieg.Flags[cfg.Flag] = api end
return api
end
function Section:Input(cfg)
local row, labels = RowWithText(self, cfg.Name, cfg.Description, 170)
local box = Create("TextBox", {
AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, 0, .5, 0), Size = UDim2.fromOffset(155, 30),
FontFace = FONT.Med, TextSize = 12, Text = cfg.Default or "", PlaceholderText = tr(cfg.Placeholder or "..."),
ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
}, { Corner(8), Pad(0, 0, 11, 11) })
Bind(box, "BackgroundColor3", "Card2"); Bind(box, "TextColor3", "Text"); Bind(box, "PlaceholderColor3", "Sub")
Lang.ph[box] = cfg.Placeholder or "..."
box.TextTruncate = Enum.TextTruncate.AtEnd
FitControl(row, box, labels, 165, 95)
local st = Stroke(box)
box.Focused:Connect(function() Tween(st, .2, { Color = Current.Accent }) end)
local api = { Value = box.Text, Type = "Input", Box = box }
function api:Set(v, silent)
box.Text = tostring(v or "")
api.Value = box.Text
if not silent and cfg.Callback then task.spawn(cfg.Callback, api.Value) end
end
box.FocusLost:Connect(function()
Tween(st, .2, { Color = Current.Stroke })
api:Set(box.Text)
end)
if cfg.Flag then Krieg.Flags[cfg.Flag] = api end
return api
end
function Section:Keybind(cfg)
local key = cfg.Default or Enum.KeyCode.F
local row = RowWithText(self, cfg.Name, cfg.Description, 120)
local btn = Create("TextButton", {
AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, 0, .5, 0), Size = UDim2.fromOffset(0, 26),
AutomaticSize = Enum.AutomaticSize.X, FontFace = FONT.Bold, TextSize = 11, Text = key.Name, AutoButtonColor = false, Parent = row,
}, { Corner(7), Pad(0, 0, 12, 12) })
Bind(btn, "BackgroundColor3", "Card2"); Bind(btn, "TextColor3", "Text")
local st = Stroke(btn)
local api = { Value = key, Type = "Keybind" }
local listening = false
function api:Set(v, silent)
if typeof(v) == "string" then v = Enum.KeyCode[v] end
if typeof(v) ~= "EnumItem" then return end
key = v
api.Value = v
btn.Text = v.Name
if not silent and cfg.Changed then task.spawn(cfg.Changed, v) end
end
btn.MouseButton1Click:Connect(function()
listening = true
btn.Text = tr("Press a key...")
Tween(st, .2, { Color = Current.Accent })
end)
Connect(UIS.InputBegan, function(i, gp)
if listening then
if i.UserInputType == Enum.UserInputType.Keyboard then
listening = false
Tween(st, .2, { Color = Current.Stroke })
if i.KeyCode == Enum.KeyCode.Escape then btn.Text = key.Name else api:Set(i.KeyCode) end
end
return
end
if not gp and i.KeyCode == key and cfg.Callback then task.spawn(cfg.Callback, key) end
end)
if cfg.Flag then Krieg.Flags[cfg.Flag] = api end
return api
end
function Section:Label(text, prefix)
local l = Text(self.Content, prefix and "" or text, 12, "Sub", FONT.Reg, { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, NoTr = prefix ~= nil })
if prefix then
local function upd() l.Text = prefix .. tr(text) end
upd()
OnLang(upd)
end
Create("UIPadding", { PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3), Parent = l })
Register(self, text, l)
local api = { Label = l }
function api:Center()
l.TextXAlignment = Enum.TextXAlignment.Center
return self
end
function api:Set(t)
if prefix then text = t; l.Text = prefix .. tr(t) else SetTr(l, t) end
end
return api
end
function Section:Paragraph(title, body)
local f = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = self.Content }, { Corner(9), Pad(11, 11, 13, 13), List(5) })
Bind(f, "BackgroundColor3", "Card2"); Stroke(f)
Text(f, title, 13, "Text", FONT.Bold, { Size = UDim2.new(1, 0, 0, 18) })
Text(f, body, 12, "Sub", FONT.Reg, { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, LayoutOrder = 2 })
Register(self, title, f)
return f
end
function Section:Tiles(items, cols)
cols = cols or 2
local wrap = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = self.Content }, { List(10) })
local f = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 1, Parent = wrap })
local grid = Create("UIGridLayout", { CellSize = UDim2.new(1 / cols, -10, 0, 62), CellPadding = UDim2.fromOffset(10, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = f })
local tail = Create("Frame", { Size = UDim2.new(1, 0, 0, 62), BackgroundTransparency = 1, LayoutOrder = 2, Visible = false, Parent = wrap })
Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = tail })
local lastC, lastTile
local function upd()
local w = wrap.AbsoluteSize.X / UScale()
if w <= 0 then return end
local c = (w < 300 and 1) or (w < 520 and math.min(cols, 2)) or cols
grid.CellSize = UDim2.new(1 / c, -math.ceil(10 * (c - 1) / c), 0, 62)
if lastTile then
local odd = c > 1 and (#items % c) == 1
lastTile.Parent = odd and tail or f
lastTile.Size = UDim2.new(0, math.floor((w - 10 * (c - 1)) / c), 0, 62)
tail.Visible = odd
end
lastC = c
end
task.defer(upd)
wrap:GetPropertyChangedSignal("AbsoluteSize"):Connect(upd)
for i, it in ipairs(items) do
local b = Create("TextButton", { Text = "", AutoButtonColor = false, LayoutOrder = i, ClipsDescendants = true, Parent = f }, { Corner(12) })
if i == #items then lastTile = b end
Bind(b, "BackgroundColor3", "Card2")
VerticalSheen(b, .12)
local st = Stroke(b)
local ib = Create("Frame", { Size = UDim2.fromOffset(38, 38), Position = UDim2.new(0, 12, .5, -19), Parent = b }, { Corner(11) })
Bind(ib, "BackgroundColor3", "AccentDark")
local iconApi = Centered(Icon(ib, it.Icon or "dot", 18, "Glow"))
Text(b, it.Name, 13, "Text", FONT.Semi, { Position = UDim2.fromOffset(62, 0), Size = UDim2.new(1, -96, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd })
local arrow = Icon(b, "chevronR", 14, "Sub")
arrow.Frame.AnchorPoint = Vector2.new(1, .5)
arrow.Frame.Position = UDim2.new(1, -14, .5, 0)
local sc = Create("UIScale", { Parent = b })
b.MouseEnter:Connect(function()
Tween(st, .2, { Color = Current.Accent })
Tween(b, .2, { BackgroundColor3 = Current.Hover })
Tween(arrow.Frame, .25, { Position = UDim2.new(1, -9, .5, 0) }, Enum.EasingStyle.Back)
Tween(iconApi.Frame, .3, { Rotation = 12 }, Enum.EasingStyle.Back)
end)
b.MouseLeave:Connect(function()
Tween(st, .2, { Color = Current.Stroke })
Tween(b, .2, { BackgroundColor3 = Current.Card2 })
Tween(arrow.Frame, .25, { Position = UDim2.new(1, -14, .5, 0) })
Tween(iconApi.Frame, .3, { Rotation = 0 })
Tween(sc, .2, { Scale = 1 })
end)
b.MouseButton1Down:Connect(function() Tween(sc, .1, { Scale = .97 }) end)
b.MouseButton1Up:Connect(function() Tween(sc, .3, { Scale = 1 }, Enum.EasingStyle.Back) end)
b.MouseButton1Click:Connect(function()
Ripple(b)
if it.Callback then task.spawn(it.Callback) end
end)
Register(self, it.Name, b)
end
task.defer(upd)
return wrap
end
function Section:Divider()
local d = Create("Frame", { Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, Parent = self.Content })
Bind(d, "BackgroundColor3", "Stroke")
return d
end
Krieg.Panels, Krieg.Walls, Krieg.GridRefreshers, Krieg.NYDecor = {}, {}, {}, {}
local function ForEachText(fn)
if not Krieg.Gui then return end
for _, o in ipairs(Krieg.Gui:GetDescendants()) do
if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then fn(o) end
end
end
function Krieg:_RefreshGrids()
for _, f in ipairs(self.GridRefreshers) do pcall(f) end
end
function Krieg:ApplyFontFamily(fam)
FONT_FAMILY = fam
RebuildFonts()
ForEachText(function(o)
if o:GetAttribute("KFixed") then return end
pcall(function()
local w = o.FontFace.Weight
if fam == GOTHAM and w == Enum.FontWeight.ExtraBold then
o.FontFace = Font.new(MONT, w)
else
o.FontFace = Font.new(fam, w, o.FontFace.Style)
end
end)
end)
end
function Krieg:SetFontByName(name)
local fam = FontLib.byName(name)
if not fam then return end
Store.set("Font", name)
self:ApplyFontFamily(fam)
self:_RefreshGrids()
end
function Krieg:SetCustomFont(src, silent)
FontLib.resolve(src, function(ok, res)
if ok then
S.FontCustom = src
Store.set("Font", "Custom")
self:ApplyFontFamily(res)
self:_RefreshGrids()
if not silent then self:Notify({ Title = "Font", Content = "Custom font applied", Icon = "type" }) end
elseif not silent then
self:Notify({ Title = "Font", Content = res, Icon = "x" })
end
end)
end
function Krieg:ApplyTextScale(v)
TextScale = v
ForEachText(function(o)
local base = o:GetAttribute("KSize")
if not base then
base = o.TextSize
o:SetAttribute("KSize", base)
end
o.TextSize = math.floor(base * v + .5)
end)
end
function Krieg:SetLanguage(name)
Store.set("Lang", name)
Lang.set(name)
self:_RefreshGrids()
end
local function ToRGB(c)
return { math.floor(c.R * 255 + .5), math.floor(c.G * 255 + .5), math.floor(c.B * 255 + .5) }
end
function Krieg:SetAccent(c)
self.AccentOverride = c
S.Accent = c and ToRGB(c) or false
Store.save()
self:SetTheme(self.CurrentTheme)
end
function Krieg:SetTextColor(c)
self.TextOverride = c
S.TextColor = c and ToRGB(c) or "Auto"
Store.save()
self:SetTheme(self.CurrentTheme)
end
function Krieg:SetPanelAlpha(a)
S.PanelAlpha = a
for i = #self.Panels, 1, -1 do
local p = self.Panels[i]
if p.Parent then p.BackgroundTransparency = a else table.remove(self.Panels, i) end
end
end
function Krieg:ApplyWallpaper(image)
local on = image ~= nil and image ~= ""
self.WallActive = on
self.WallImage = on and image or nil
for _, w in ipairs(self.Walls) do
local show = on and (not w.mini or S.WallMini)
w[1].Image = on and image or ""
w[1].Visible = show
w[2].Visible = show
w[2].BackgroundTransparency = 1 - S.WallDim
end
for _, b in ipairs(self._Blobs or {}) do b.Visible = not on end
end
function Krieg:SetWallDim(v)
S.WallDim = v
for _, w in ipairs(self.Walls) do w[2].BackgroundTransparency = 1 - v end
end
local Wall = {}
do
local function hashOf(s)
local h = 0
for i = 1, #s do h = (h * 31 + s:byte(i)) % 1000000007 end
return tostring(h)
end
local UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"
local function fetch(req, url)
for _ = 1, 6 do
local ok, res = pcall(req, {
Url = url, Method = "GET",
Headers = { ["User-Agent"] = UA, ["Accept"] = "image/png,image/jpeg,image/*;q=0.9,text/html;q=0.8,*/*;q=0.5" },
})
if not ok or type(res) ~= "table" then return nil end
local code = tonumber(res.StatusCode) or 200
if code >= 300 and code < 400 then
local h = res.Headers or {}
local loc = h.Location or h.location or h.LOCATION
if type(loc) ~= "string" then return nil end
if loc:sub(1, 1) == "/" then loc = (url:match("^(https?://[^/]+)") or "") .. loc end
url = loc
elseif code >= 400 or type(res.Body) ~= "string" then
return nil
else
return res.Body
end
end
end
local function imageKind(body)
if body:sub(1, 4) == "\137PNG" then return "png" end
if body:sub(1, 2) == "\255\216" then return "jpg" end
if body:sub(1, 3) == "GIF" then return "gif" end
if body:sub(1, 4) == "RIFF" and body:sub(9, 12) == "WEBP" then return "webp" end
return nil
end
local function imagesInPage(html)
html = html:gsub("\\/", "/"):gsub("\\u002F", "/"):gsub("&amp;", "&")
local list, seen = {}, {}
local function add(u)
if u and not seen[u] then seen[u] = true table.insert(list, u) end
end
add(html:match('(https://i%.pinimg%.com/originals/[^"\'%s<>\\]+)'))
add(html:match('<meta[^>]-property=["\']og:image["\'][^>]-content=["\']([^"\']+)'))
add(html:match('<meta[^>]-content=["\']([^"\']+)["\'][^>]-property=["\']og:image'))
add(html:match('<meta[^>]-name=["\']twitter:image["\'][^>]-content=["\']([^"\']+)'))
add(html:match('(https://i%.pinimg%.com/736x/[^"\'%s<>\\]+)'))
add(html:match('(https://i%.pinimg%.com/[^"\'%s<>\\]+%.jpe?g)'))
return list
end
function Wall.resolve(src, cb)
src = (src or ""):gsub("^%s+", ""):gsub("%s+$", "")
if src == "" then cb(false, "Paste a link first") return end
local id = src:match("^(%d+)$") or src:match("rbxassetid://(%d+)") or src:match("roblox%.com.-[?&]id=(%d+)") or src:match("roblox%.com/library/(%d+)") or src:match("/decal/(%d+)") or src:match("create%.roblox%.com/store/asset/(%d+)") or src:match("roblox%.com/catalog/(%d+)")
if id then cb(true, "rbxassetid://" .. id) return end
if not src:match("^https?://") then
if src:match("^[%w%-]+%.[%w%.%-]+/") then src = "https://" .. src else cb(false, "This is not a link") return end
end
local getAsset = getcustomasset or getsynasset
local req = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
if type(getAsset) ~= "function" or type(writefile) ~= "function" or type(req) ~= "function" then
cb(false, "Your executor can't load images from links")
return
end
local base = Store.dir .. "/wall_" .. hashOf(src)
for _, ext in ipairs({ "png", "jpg" }) do
local okE, exists = pcall(function() return isfile and isfile(base .. "." .. ext) end)
if okE and exists then
local ok, asset = pcall(getAsset, base .. "." .. ext)
if ok and asset then cb(true, asset) return end
end
end
task.spawn(function()
local body = fetch(req, src)
if not body then cb(false, "Could not download the image") return end
local kind = imageKind(body)
if not kind then
local found = false
for _, u in ipairs(imagesInPage(body)) do
local b2 = fetch(req, u)
local k2 = b2 and imageKind(b2)
if k2 then body, kind, found = b2, k2, true break end
end
if not found then cb(false, "No picture found on this page") return end
end
if kind == "gif" then cb(false, "GIF is not supported, use PNG or JPG") return end
if kind == "webp" then cb(false, "WEBP is not supported, use PNG or JPG") return end
Store.ensureDir()
local path = base .. "." .. kind
local okW = pcall(writefile, path, body)
local okA, asset = pcall(getAsset, path)
if okW and okA and asset then cb(true, asset) else cb(false, "Could not save the image") end
end)
end
end
function Krieg:ResolveWallpaper(src, cb) Wall.resolve(src, cb) end
local WALL_BASE = "https://raw.githubusercontent.com/zuzinn888-star/THROWFOODFOR/refs/heads/main/"
Krieg.ThemeWalls = {
["Sakura"]    = { file = "sakura",    sheets = 4, frames = 60, fps = 8 },
["Halloween"] = { file = "halloween", sheets = 3, frames = 40, fps = 8 },
["Rain"]      = { file = "rain",      sheets = 4, frames = 48, fps = 8 },
["New Year"]  = { file = "newyear",   sheets = 3, frames = 39, fps = 8 },
}
local SHEET_C, SHEET_R, FRAME_W, FRAME_H = 3, 5, 320, 180
local animToken = 0
Krieg.ThemeWallAssets = {}
local function stopAnim()
animToken += 1
Krieg.AnimWall = nil
for _, w in ipairs(Krieg.Walls or {}) do
w[1].ImageRectSize = Vector2.zero
w[1].ImageRectOffset = Vector2.zero
end
end
function Krieg:StopThemeWall()
stopAnim()
if not (S.Wallpaper ~= "" and self.WallImage) then self:ApplyWallpaper(nil) end
end
function Krieg:LoadThemeWall(name, cb)
local def = self.ThemeWalls[name]
if not def then cb(nil) return end
if self.ThemeWallAssets[name] then cb(self.ThemeWallAssets[name]) return end
local assets, left, failed = {}, def.sheets, false
for i = 1, def.sheets do
Wall.resolve(WALL_BASE .. def.file .. "_" .. i .. ".jpg", function(ok, res)
if ok then assets[i] = res else failed = true end
left -= 1
if left == 0 then
if failed then cb(nil) else self.ThemeWallAssets[name] = assets; cb(assets) end
end
end)
end
end
function Krieg:PlayThemeWall(name)
stopAnim()
if S.Wallpaper ~= "" or S.ThemeWall == false then return end
local def = self.ThemeWalls[name]
if not def then self:ApplyWallpaper(nil) return end
local my = animToken
self:LoadThemeWall(name, function(assets)
if my ~= animToken or not assets then return end
self:ApplyWallpaper(assets[1])
self.AnimWall = name
local per = SHEET_C * SHEET_R
local size = Vector2.new(FRAME_W, FRAME_H)
local lastSheet = 0
task.spawn(function()
local t0 = os.clock()
while my == animToken and self.Gui and self.Gui.Parent do
local f = math.floor((os.clock() - t0) * def.fps) % def.frames
local sheet = math.floor(f / per) + 1
local k = f % per
local off = Vector2.new((k % SHEET_C) * FRAME_W, math.floor(k / SHEET_C) * FRAME_H)
for _, w in ipairs(self.Walls) do
if sheet ~= lastSheet then w[1].Image = assets[sheet] end
w[1].ImageRectSize = size
w[1].ImageRectOffset = off
end
lastSheet = sheet
task.wait(1 / def.fps)
end
end)
end)
end
function Krieg:CreateWindow(o)
o = o or {}
local THEME = (self.ThemeBase[S.Theme] and S.Theme) or o.Theme or "New Year"
if not self.ThemeBase[THEME] then THEME = "New Year" end
Current = BuildTheme(THEME)
self.CurrentTheme = THEME
self.ToggleKey = o.ToggleKey or self.ToggleKey
pcall(function() self.ToggleKey = Enum.KeyCode[S.Key] or self.ToggleKey end)
self.UserScale = S.Scale
self.ParticlesOn = S.Particles
self.ConfigFolder = o.ConfigFolder or self.ConfigFolder
local DEF_W, DEF_H = o.Width or 900, o.Height or 560
local MIN_W, MIN_H = 600, 400
local SIDE, TOP = 200, 64
local W, H = DEF_W, DEF_H
local PG = LP:WaitForChild("PlayerGui")
local old = PG:FindFirstChild("KriegHub")
if old then old:Destroy() end
local Gui = Create("ScreenGui", { Name = "KriegHub", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 50, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PG })
self.Gui = Gui
Connect(Gui:GetPropertyChangedSignal("Enabled"), function()
if not Gui.Enabled then Gui.Enabled = true end
end)
local Window = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.fromOffset(W, H), BackgroundTransparency = 1, Visible = false, Parent = Gui })
local Scale = Create("UIScale", { Scale = 1, Parent = Window })
Krieg._ScaleObj = Scale
Krieg.WindowFrame = Window
local function fitScale()
local cam = workspace.CurrentCamera
if not cam then return 1 end
local v = cam.ViewportSize
return math.min(1, (v.X - 24) / W, (v.Y - 24) / H)
end
local Shadow = Create("ImageLabel", {
AnchorPoint = Vector2.new(.5, .5), Position = UDim2.new(.5, 0, .5, 6), Size = UDim2.new(1, 70, 1, 70),
BackgroundTransparency = 1, Image = "rbxassetid://6014261993", ImageColor3 = BLACK, ImageTransparency = 1,
ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450), Parent = Window,
})
local Main = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, Parent = Window }, { Corner(16) })
Bind(Main, "BackgroundColor3", "Bg")
VerticalSheen(Main, .1)
local WallImg = Create("ImageLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, Image = "", Visible = false, Parent = Main }, { Corner(16) })
local WallShade = Create("Frame", { Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, Visible = false, Parent = Main }, { Corner(16) })
Bind(WallShade, "BackgroundColor3", "Bg")
table.insert(self.Walls, { WallImg, WallShade })
local Inner = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = Main })
local Overlay = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 10, Parent = Main }, { Corner(16) })
Bind(Overlay, "BackgroundColor3", "Bg")
local Outline = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 20, Parent = Window }, { Corner(16) })
local OutlineStroke = Create("UIStroke", { Color = WHITE, Thickness = 1.5, Transparency = 1, Parent = Outline })
local og = ThemeGrad(OutlineStroke, 0, 45)
og.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(.25, .35),
NumberSequenceKeypoint.new(.5, .7), NumberSequenceKeypoint.new(.75, .35), NumberSequenceKeypoint.new(1, 0),
})
local Fx = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, Parent = Inner })
local function Blob(key, size, pos)
local b = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = pos, Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, Parent = Fx })
for i = 1, 7 do
local c = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.fromScale(i / 7, i / 7), BackgroundTransparency = .975, BorderSizePixel = 0, Parent = b }, { Round() })
Bind(c, "BackgroundColor3", key)
end
return b
end
local blob1 = Blob("Accent", 520, UDim2.fromScale(.82, .05))
local blob2 = Blob("Accent2", 420, UDim2.fromScale(.12, 1))
self._Blobs = { blob1, blob2 }
task.spawn(function()
while Gui.Parent do
Tween(blob1, 6, { Position = UDim2.fromScale(.7, .15) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
Tween(blob2, 6, { Position = UDim2.fromScale(.25, .9) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
task.wait(6)
Tween(blob1, 6, { Position = UDim2.fromScale(.85, .02) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
Tween(blob2, 6, { Position = UDim2.fromScale(.1, 1.02) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
task.wait(6)
end
end)
local Particles = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = Fx })
local Top = Create("Frame", { Size = UDim2.new(1, 0, 0, TOP), BackgroundTransparency = 1, Parent = Inner })
local HLine = Create("Frame", { Position = UDim2.fromOffset(0, TOP), Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, Parent = Inner })
Bind(HLine, "BackgroundColor3", "Stroke")
local Logo = Create("Frame", { Position = UDim2.fromOffset(18, 13), Size = UDim2.fromOffset(38, 38), BackgroundColor3 = WHITE, Parent = Top }, { Corner(11) })
ThemeGrad(Logo, 0, 35)
Text(Logo, "K", 20, nil, FONT.Heavy, { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = WHITE })
Shine(Logo, UDim.new(0, 11), .4, .55)
local Badge = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.new(1, -1, 1, -1), Size = UDim2.fromOffset(17, 17), Parent = Logo }, { Round() })
Bind(Badge, "BackgroundColor3", "Bg"); Stroke(Badge, "Accent", 1.2)
local badgeHolder = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = Badge })
local TitleRow = Create("Frame", { Position = UDim2.fromOffset(66, 13), Size = UDim2.fromOffset(200, 22), BackgroundTransparency = 1, Parent = Top }, {
Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center }),
})
Text(TitleRow, o.Title or "KRIEG", 17, "Text", FONT.Heavy, { Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X })
local Hub = Text(TitleRow, o.AccentWord or "HUB", 17, nil, FONT.Heavy, { Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X, TextColor3 = WHITE, LayoutOrder = 2 })
local hubGrad = ThemeGrad(Hub, 0)
AddShimmer(hubGrad, "rotate", 70)
Text(Top, o.Subtitle or "Admin Panel", 11, "Sub", FONT.Med, { Position = UDim2.fromOffset(66, 35), Size = UDim2.fromOffset(200, 16) })
local function IconButton(icon, props)
local b = Create("TextButton", { Size = UDim2.fromOffset(36, 36), Text = "", AutoButtonColor = false }, { Corner(10) })
for k, v in pairs(props or {}) do b[k] = v end
Bind(b, "BackgroundColor3", "Card2")
local st = Stroke(b)
local ref = { ic = Centered(BuildIcon(b, icon, 16, Current.Sub)) }
local sc = Create("UIScale", { Parent = b })
local hover = false
local function paint(t)
Tween(b, t, { BackgroundColor3 = hover and Current.Hover or Current.Card2 })
Tween(st, t, { Color = hover and Current.Accent:Lerp(Current.Stroke, .45) or Current.Stroke })
ref.ic:SetColor(hover and Current.Text or Current.Sub, t)
end
b.MouseEnter:Connect(function() hover = true; paint(.2) end)
b.MouseLeave:Connect(function() hover = false; paint(.2); Tween(sc, .2, { Scale = 1 }) end)
b.MouseButton1Down:Connect(function() Tween(sc, .1, { Scale = .9 }) end)
b.MouseButton1Up:Connect(function() Tween(sc, .3, { Scale = 1 }, Enum.EasingStyle.Back) end)
OnTheme(function() paint(.35) end)
b.Parent = Top
return b, ref
end
local SideBtn = IconButton("panelLeft", { Position = UDim2.fromOffset(SIDE + 14, 14) })
local CloseBtn = IconButton("x", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 14) })
local MinBtn, MinIcon = IconButton("minus", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -60, 0, 14) })
local SearchFrame = Create("Frame", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -106, 0, 14), Size = UDim2.fromOffset(230, 36), Parent = Top }, { Corner(10) })
Bind(SearchFrame, "BackgroundColor3", "Card2")
local SearchStroke = Stroke(SearchFrame)
local sIcon = Icon(SearchFrame, "search", 15, "Sub")
sIcon.Frame.AnchorPoint = Vector2.new(0, .5)
sIcon.Frame.Position = UDim2.new(0, 12, .5, 0)
local Search = Create("TextBox", {
Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -70, 1, 0), BackgroundTransparency = 1, Text = "",
PlaceholderText = tr("Find a section..."), FontFace = FONT.Med, TextSize = 12, ClearTextOnFocus = false,
TextXAlignment = Enum.TextXAlignment.Left, Parent = SearchFrame,
})
Bind(Search, "TextColor3", "Text"); Bind(Search, "PlaceholderColor3", "Sub")
Lang.ph[Search] = "Find a section..."
local Slash = Create("Frame", { AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -8, .5, 0), Size = UDim2.fromOffset(22, 20), Parent = SearchFrame }, { Corner(6) })
Bind(Slash, "BackgroundColor3", "Bg"); Stroke(Slash)
Text(Slash, "/", 11, "Sub", FONT.Bold, { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center })
local Pill = Create("TextButton", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -348, 0, 16), Size = UDim2.fromOffset(0, 32), AutomaticSize = Enum.AutomaticSize.X, Text = "", AutoButtonColor = false, Parent = Top }, { Round(), Pad(0, 0, 12, 14) })
Bind(Pill, "BackgroundColor3", "AccentDark")
local pillStroke = Create("UIStroke", { Color = WHITE, Transparency = .35, Parent = Pill })
ThemeGrad(pillStroke, 0, 60)
Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 7), VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Parent = Pill })
local pillIconHolder = Create("Frame", { Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, Parent = Pill })
local PillLbl = Text(Pill, "", 12, "Text", FONT.Semi, { Size = UDim2.fromOffset(0, 32), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 2 })
local badgeIcon, pillIcon
local function refreshHeader()
if badgeIcon then badgeIcon.Frame:Destroy() end
if pillIcon then pillIcon.Frame:Destroy() end
badgeIcon = Centered(BuildIcon(badgeHolder, Current.Icon, 10, Current.Accent, 1.1))
pillIcon = BuildIcon(pillIconHolder, Current.Icon, 14, Current.Glow)
SetTr(PillLbl, Krieg.CurrentTheme)
end
refreshHeader()
OnTheme(refreshHeader)
local Sidebar = Create("Frame", { Position = UDim2.fromOffset(0, TOP + 1), Size = UDim2.new(0, SIDE, 1, -TOP - 1), BackgroundTransparency = 1, Parent = Inner })
local VLine = Create("Frame", { Position = UDim2.new(0, SIDE, 0, TOP + 1), Size = UDim2.new(0, 1, 1, -TOP - 1), BorderSizePixel = 0, Parent = Inner })
Bind(VLine, "BackgroundColor3", "Stroke")
local TabList = Create("ScrollingFrame", {
Size = UDim2.new(1, 0, 1, -80), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = Sidebar,
}, { List(3), Pad(10, 10, 12, 12) })
local ProfileMini = Create("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -12), Size = UDim2.new(1, -24, 0, 58), Parent = Sidebar }, { Corner(12) })
Bind(ProfileMini, "BackgroundColor3", "Card"); Stroke(ProfileMini)
VerticalSheen(ProfileMini, .12)
local ring = Create("Frame", { Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(38, 38), BackgroundColor3 = WHITE, Parent = ProfileMini }, { Round() })
ThemeGrad(ring, 0, 90)
local Avatar = Create("ImageLabel", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.new(1, -4, 1, -4), Parent = ring }, { Round() })
Bind(Avatar, "BackgroundColor3", "Card2")
local MiniName = Text(ProfileMini, LP.DisplayName, 13, "Text", FONT.Bold, { Position = UDim2.fromOffset(56, 11), Size = UDim2.new(1, -82, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd })
local MiniUser = Text(ProfileMini, "@" .. LP.Name, 11, "Sub", FONT.Reg, { Position = UDim2.fromOffset(56, 29), Size = UDim2.new(1, -82, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd })
local Online = Create("Frame", { AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -13, .5, 0), Size = UDim2.fromOffset(8, 8), BackgroundColor3 = Color3.fromRGB(70, 222, 125), Parent = ProfileMini }, { Round() })
local OnlinePulse = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(70, 222, 125), Parent = Online }, { Round() })
task.spawn(function()
while Online.Parent do
OnlinePulse.Size = UDim2.fromScale(1, 1); OnlinePulse.BackgroundTransparency = .3
Tween(OnlinePulse, 1.4, { Size = UDim2.fromScale(2.6, 2.6), BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
task.wait(1.6)
end
end)
local headshot = ""
local avatarTargets = { Avatar }
task.spawn(function()
local ok, img = pcall(Players.GetUserThumbnailAsync, Players, LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
if ok then
headshot = img
for _, a in ipairs(avatarTargets) do a.Image = img end
end
end)
local Content = Create("Frame", { Position = UDim2.fromOffset(SIDE + 1, TOP + 1), Size = UDim2.new(1, -SIDE - 1, 1, -TOP - 1), BackgroundTransparency = 1, Parent = Inner })
local PageTitle = Text(Content, "", 22, "Text", FONT.Bold, { Position = UDim2.fromOffset(22, 16), Size = UDim2.new(1, -44, 0, 26), TextTruncate = Enum.TextTruncate.AtEnd })
local PageSub = Text(Content, "", 12, "Sub", FONT.Reg, { Position = UDim2.fromOffset(22, 42), Size = UDim2.new(1, -44, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd })
local Pages = Create("Frame", { Position = UDim2.fromOffset(0, 70), Size = UDim2.new(1, 0, 1, -70), BackgroundTransparency = 1, ClipsDescendants = true, Parent = Content })
local Grip = Create("TextButton", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -4, 1, -4), Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, Text = "", ZIndex = 21, Parent = Window })
local gripIcon = Centered(BuildIcon(Grip, "grip", 18, Current.Sub))
gripIcon:SetTransparency(1)
Grip.MouseEnter:Connect(function() gripIcon:SetColor(Current.Accent, .2) end)
Grip.MouseLeave:Connect(function() gripIcon:SetColor(Current.Sub, .2) end)
local NotifyHolder = Create("Frame", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -18, 1, -18), Size = UDim2.fromOffset(300, 500), BackgroundTransparency = 1, Parent = Gui }, {
Create("UIListLayout", { Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Bottom, SortOrder = Enum.SortOrder.LayoutOrder }),
})
function Krieg:Notify(n)
n = n or {}
if not S.Notifs then return end
local th = Current
local wrap = Create("Frame", { Size = UDim2.new(1, 0, 0, 70), BackgroundTransparency = 1, Parent = NotifyHolder })
local card = Create("Frame", { Position = UDim2.new(1, 30, 0, 0), Size = UDim2.fromScale(1, 1), BackgroundColor3 = th.Card, Parent = wrap }, { Corner(12) })
VerticalSheen(card, .12)
local st = Create("UIStroke", { Color = WHITE, Transparency = .45, Parent = card })
local g = Create("UIGradient", { Color = AccentSeq(th), Parent = st })
AddShimmer(g, "rotate", 80)
local ib = Create("Frame", { Position = UDim2.fromOffset(12, 14), Size = UDim2.fromOffset(34, 34), BackgroundColor3 = th.AccentDark, Parent = card }, { Corner(10) })
Centered(BuildIcon(ib, n.Icon or "info", 17, th.Glow))
Create("TextLabel", { BackgroundTransparency = 1, Position = UDim2.fromOffset(56, 12), Size = UDim2.new(1, -66, 0, 18), FontFace = FONT.Bold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = th.Text, Text = tr(n.Title or "Krieg Hub"), Parent = card })
Create("TextLabel", { BackgroundTransparency = 1, Position = UDim2.fromOffset(56, 31), Size = UDim2.new(1, -66, 0, 28), FontFace = FONT.Reg, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextColor3 = th.Sub, Text = tr(n.Content or ""), Parent = card })
local barBg = Create("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -6), Size = UDim2.new(1, -24, 0, 3), BackgroundColor3 = th.Off, BorderSizePixel = 0, Parent = card }, { Round() })
local bar = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BorderSizePixel = 0, Parent = barBg }, { Round() })
Create("UIGradient", { Color = AccentSeq(th), Parent = bar })
Tween(card, .55, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Back)
local d = n.Duration or 4
Tween(bar, d, { Size = UDim2.fromScale(0, 1) }, Enum.EasingStyle.Linear)
task.delay(d, function()
Tween(card, .4, { Position = UDim2.new(1, 30, 0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
task.wait(.4)
Tween(wrap, .25, { Size = UDim2.new(1, 0, 0, 0) })
task.wait(.25)
wrap:Destroy()
end)
end
local Win = { Tabs = {}, Current = nil, Order = 0 }
local collapsed, minimized, visible = false, false, false
local groupHeaders = {}
function Win:Group(name)
self.Order += 1
local h = Text(TabList, name, 10, "Sub", FONT.Bold, { Size = UDim2.new(1, 0, 0, 28), LayoutOrder = self.Order, TextYAlignment = Enum.TextYAlignment.Bottom, TextTransparency = .2 })
Create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingBottom = UDim.new(0, 5), Parent = h })
table.insert(groupHeaders, h)
return h
end
local function paintTabs(t)
for _, tab in ipairs(Win.Tabs) do
local on = tab == Win.Current
Tween(tab.Button, t, { BackgroundTransparency = on and 0 or 1, BackgroundColor3 = Current.Card2 })
Tween(tab.Glow, t, { BackgroundTransparency = on and 0 or 1 })
Tween(tab.Bar, t, { Size = UDim2.fromOffset(3, on and 20 or 0) }, Enum.EasingStyle.Back)
Tween(tab.Dot, t, { BackgroundTransparency = (on and not collapsed) and 0 or 1, BackgroundColor3 = Current.Accent })
Tween(tab.BtnStroke, t, { Transparency = on and 0 or 1 })
tab.IconApi:SetColor(on and Current.Accent or Current.Sub, t)
Tween(tab.NameLbl, t, { TextColor3 = on and Current.Text or Current.Sub, TextTransparency = collapsed and 1 or 0 })
end
end
OnTheme(function() paintTabs(.35) end)
function Win:SelectTab(tab)
if self.Current == tab then return end
local prev = self.Current
self.Current = tab
paintTabs(.3)
if prev then prev.Page.Visible = false end
tab.Page.Visible = true
tab.Page.Position = UDim2.fromOffset(0, 18)
Tween(tab.Page, .45, { Position = UDim2.fromOffset(0, 0) })
SetTr(PageTitle, tab.Name)
if tab.SubFn then Lang.reg[PageSub] = nil; PageSub.Text = tab.SubFn() else SetTr(PageSub, tab.Subtitle or "") end
PageTitle.TextTransparency, PageSub.TextTransparency = 1, 1
PageTitle.Position = UDim2.fromOffset(32, 16)
Tween(PageTitle, .4, { TextTransparency = 0, Position = UDim2.fromOffset(22, 16) })
Tween(PageSub, .55, { TextTransparency = 0 })
tab:Relayout()
for i, sec in ipairs(tab.Sections) do
sec.Inner.Position = UDim2.fromOffset(0, 14)
task.delay(i * .045, function() Tween(sec.Inner, .45, { Position = UDim2.fromOffset(0, 0) }) end)
end
end
OnLang(function()
local t = Win.Current
if t and t.SubFn then PageSub.Text = t.SubFn() end
end)
local PADX, PADT, GAP = 20, 4, 12
local function layoutTab(tab)
local s = UScale()
local w = tab.Page.AbsoluteWindowSize.X / s - PADX * 2
if w <= 0 then return end
local cols = (w >= 560 and #tab.Sections > 1) and 2 or 1
local colW = cols == 2 and math.floor((w - GAP) / 2) or math.floor(w)
local hs = { 0, 0 }
local order = {}
local balance = false
if cols == 2 then
order = tab.Sections
local hasL, hasR = false, false
for _, sec in ipairs(tab.Sections) do
if sec.Side == "Right" then hasR = true else hasL = true end
end
balance = not (hasL and hasR)
else
for _, sec in ipairs(tab.Sections) do if sec.Side ~= "Right" then table.insert(order, sec) end end
for _, sec in ipairs(tab.Sections) do if sec.Side == "Right" then table.insert(order, sec) end end
end
local lastSec = order[#order]
for idx, sec in ipairs(order) do
local c = 1
if cols == 2 then
if balance then c = (hs[1] <= hs[2]) and 1 or 2 else c = (sec.Side == "Right") and 2 or 1 end
end
local h = math.floor(sec.Inner.AbsoluteSize.Y / s + .5)
local other = c == 1 and 2 or 1
if cols == 2 and idx > 1 and sec == lastSec and hs[other] <= hs[c] + 40 then
local top = math.max(hs[1], hs[2])
sec.Frame.Size = UDim2.fromOffset(colW * 2 + GAP, h)
sec.Frame.Position = UDim2.fromOffset(PADX, PADT + top)
hs[1], hs[2] = top + h + GAP, top + h + GAP
else
sec.Frame.Size = UDim2.fromOffset(colW, h)
sec.Frame.Position = UDim2.fromOffset(PADX + (c - 1) * (colW + GAP), PADT + hs[c])
hs[c] += h + GAP
end
end
tab.Page.CanvasSize = UDim2.fromOffset(0, math.max(hs[1], hs[2]) + 16)
end
function Win:Tab(cfg)
self.Order += 1
local tab = { Name = cfg.Name, Subtitle = cfg.Subtitle, SubFn = cfg.SubFn, Sections = {}, Elements = {} }
local btn = Create("TextButton", { Size = UDim2.new(1, 0, 0, 38), Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BackgroundColor3 = Current.Card2, LayoutOrder = self.Order, Parent = TabList }, { Corner(10) })
tab.Button = btn
tab.BtnStroke = Create("UIStroke", { Color = WHITE, Transparency = 1, Parent = btn })
Bind(tab.BtnStroke, "Color", "Stroke")
tab.Glow = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = btn }, { Corner(10) })
Bind(tab.Glow, "BackgroundColor3", "Accent")
Create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, .78), NumberSequenceKeypoint.new(.6, 1), NumberSequenceKeypoint.new(1, 1) }), Parent = tab.Glow })
tab.Bar = Create("Frame", { AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, -12, .5, 0), Size = UDim2.fromOffset(3, 0), BackgroundColor3 = WHITE, BorderSizePixel = 0, Parent = btn }, { Round() })
ThemeGrad(tab.Bar, 90)
local iconHolder = Create("Frame", { Position = UDim2.fromOffset(11, 10), Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1, Parent = btn })
tab.IconApi = BuildIcon(iconHolder, cfg.Icon or "dot", 18, Current.Sub)
tab.NameLbl = Text(btn, cfg.Name, 13, nil, FONT.Semi, { Position = UDim2.fromOffset(40, 0), Size = UDim2.new(1, -60, 1, 0), TextColor3 = Current.Sub })
tab.Dot = Create("Frame", { AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -12, .5, 0), Size = UDim2.fromOffset(5, 5), BackgroundTransparency = 1, BackgroundColor3 = Current.Accent, Parent = btn }, { Round() })
local isc = Create("UIScale", { Parent = iconHolder })
btn.MouseEnter:Connect(function()
Tween(isc, .25, { Scale = 1.12 }, Enum.EasingStyle.Back)
if Win.Current ~= tab then Tween(btn, .2, { BackgroundTransparency = .5 }) end
end)
btn.MouseLeave:Connect(function()
Tween(isc, .25, { Scale = 1 })
if Win.Current ~= tab then Tween(btn, .2, { BackgroundTransparency = 1 }) end
end)
btn.MouseButton1Click:Connect(function() Win:SelectTab(tab) end)
local page = Create("ScrollingFrame", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
CanvasSize = UDim2.new(), Visible = false, ScrollingDirection = Enum.ScrollingDirection.Y,
VerticalScrollBarInset = Enum.ScrollBarInset.Always, Parent = Pages,
})
Bind(page, "ScrollBarImageColor3", "Accent")
tab.Page = page
local pending = false
function tab:Relayout()
if pending then return end
pending = true
task.defer(function()
pending = false
layoutTab(tab)
end)
end
page:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() tab:Relayout() end)
function tab:Section(scfg)
local frame = Create("Frame", { Size = UDim2.fromOffset(300, 0), BackgroundTransparency = 1, Parent = page })
local card = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = frame }, { Corner(14), List(0) })
Bind(card, "BackgroundColor3", "Card")
card.BackgroundTransparency = S.PanelAlpha
table.insert(Krieg.Panels, card)
VerticalSheen(card, .1)
local fst = Stroke(card)
local hh = scfg.Subtitle and 58 or 48
local head = Create("TextButton", { Size = UDim2.new(1, 0, 0, hh), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = 1, Parent = card })
do
local frost = Create("Frame", { Size = UDim2.new(1, -24, 0, 1), Position = UDim2.fromOffset(12, 0), BackgroundColor3 = Color3.fromRGB(220, 238, 255), BorderSizePixel = 0, ZIndex = 3, Visible = Krieg.CurrentTheme == "New Year", Parent = head })
Create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(.25, .35), NumberSequenceKeypoint.new(.75, .35), NumberSequenceKeypoint.new(1, 1) }), Parent = frost })
table.insert(Krieg.NYDecor, frost)
end
local ic = Icon(head, scfg.Icon or "sparkles", 17, "Accent")
ic.Frame.Position = UDim2.fromOffset(16, scfg.Subtitle and 12 or 15)
Text(head, scfg.Name, 14, "Text", FONT.Bold, { Position = UDim2.fromOffset(42, scfg.Subtitle and 10 or 0), Size = UDim2.new(1, -84, 0, scfg.Subtitle and 22 or hh), TextTruncate = Enum.TextTruncate.AtEnd })
if scfg.Subtitle then
Text(head, scfg.Subtitle, 11, "Sub", FONT.Reg, { Position = UDim2.fromOffset(42, 31), Size = UDim2.new(1, -84, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd })
end
local chev = Icon(head, "chevron", 15, "Sub")
chev.Frame.AnchorPoint = Vector2.new(1, 0)
chev.Frame.Position = UDim2.new(1, -16, 0, scfg.Subtitle and 13 or 16)
local body = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ClipsDescendants = true, LayoutOrder = 2, Parent = card })
local content = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = body }, { List(6), Pad(0, 14, 16, 16) })
card.MouseEnter:Connect(function() Tween(fst, .25, { Color = Current.Accent:Lerp(Current.Stroke, .55) }) end)
card.MouseLeave:Connect(function() Tween(fst, .25, { Color = Current.Stroke }) end)
card:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() self:Relayout() end)
local sec = setmetatable({ Content = content, Tab = self, Frame = frame, Inner = card, Head = head, Body = body, Side = scfg.Side, Name = scfg.Name }, Section)
Register(sec, scfg.Name, frame, true)
local open = true
local function setOpen(v, instant)
open = v
Tween(chev.Frame, .35, { Rotation = v and 0 or -90 }, Enum.EasingStyle.Back)
local s = UScale()
if v then
body.Visible = true
local target = content.AbsoluteSize.Y / s
body.AutomaticSize = Enum.AutomaticSize.None
body.Size = UDim2.new(1, 0, 0, 0)
Tween(body, instant and 0 or .4, { Size = UDim2.new(1, 0, 0, target) })
task.delay(instant and 0 or .41, function() if open then body.AutomaticSize = Enum.AutomaticSize.Y end end)
else
body.AutomaticSize = Enum.AutomaticSize.None
body.Size = UDim2.new(1, 0, 0, content.AbsoluteSize.Y / s)
Tween(body, instant and 0 or .32, { Size = UDim2.new(1, 0, 0, 0) })
task.delay(instant and 0 or .33, function() if not open then body.Visible = false end end)
end
end
head.MouseButton1Click:Connect(function() setOpen(not open) end)
if scfg.Collapsed then task.defer(setOpen, false, true) end
table.insert(self.Sections, sec)
self:Relayout()
return sec
end
table.insert(self.Tabs, tab)
if not self.Current then self:SelectTab(tab) end
return tab
end
local function ResponsiveGrid(frame, layout, count, cellH, gap, rule)
local function upd()
local w = frame.AbsoluteSize.X / UScale()
if w <= 0 then return end
local c = rule(w)
layout.CellSize = UDim2.new(1 / c, -math.ceil(gap * (c - 1) / c), 0, cellH)
layout.CellPadding = UDim2.fromOffset(gap, gap)
local rows = math.ceil(count / c)
frame.Size = UDim2.new(1, 0, 0, rows * cellH + (rows - 1) * gap)
end
frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(upd)
task.defer(upd)
end
function Win:CreateHome(cfg)
cfg = cfg or {}
local tab = self:Tab({ Name = "Home", Icon = "home", SubFn = function() return tr("Welcome back") .. ", " .. LP.DisplayName end })
local prof = tab:Section({ Name = "Profile", Icon = "user" })
local pf = Create("Frame", { Size = UDim2.new(1, 0, 0, 76), BackgroundTransparency = 1, Parent = prof.Content })
local bigRing = Create("Frame", { Position = UDim2.fromOffset(0, 4), Size = UDim2.fromOffset(68, 68), BackgroundColor3 = WHITE, Parent = pf }, { Corner(18) })
ThemeGrad(bigRing, 0, 70)
local big = Create("ImageLabel", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.new(1, -5, 1, -5), Image = headshot, Parent = bigRing }, { Corner(16) })
Bind(big, "BackgroundColor3", "Card2")
table.insert(avatarTargets, big)
Text(pf, LP.DisplayName, 17, "Text", FONT.Bold, { Position = UDim2.fromOffset(82, 8), Size = UDim2.new(1, -82, 0, 22) })
local ageL = Text(pf, "", 12, "Sub", FONT.Reg, { Position = UDim2.fromOffset(82, 30), Size = UDim2.new(1, -82, 0, 16), NoTr = true })
local function updAge() ageL.Text = "@" .. LP.Name .. "  ·  " .. LP.AccountAge .. " " .. tr("days") end
updAge()
OnLang(updAge)
local tag = Create("Frame", { Position = UDim2.fromOffset(82, 51), Size = UDim2.fromOffset(0, 21), AutomaticSize = Enum.AutomaticSize.X, Parent = pf }, { Corner(6), Pad(0, 0, 7, 9) })
Bind(tag, "BackgroundColor3", "AccentDark"); Stroke(tag, "Accent", 1, .45)
Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5), VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Parent = tag })
Icon(tag, "check", 11, "Glow")
Text(tag, cfg.Badge or "KRIEG MEMBER", 10, "Glow", FONT.Bold, { Size = UDim2.fromOffset(0, 21), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 2 })
local live = tab:Section({ Name = "Live", Icon = "activity" })
local grid = Create("Frame", { Size = UDim2.new(1, 0, 0, 142), BackgroundTransparency = 1, Parent = live.Content })
local gridLayout = Create("UIGridLayout", { CellSize = UDim2.new(.5, -5, 0, 66), CellPadding = UDim2.fromOffset(10, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = grid })
ResponsiveGrid(grid, gridLayout, 4, 66, 10, function(w) return w >= 250 and 2 or 1 end)
local function Stat(icon, name, i)
local f = Create("Frame", { LayoutOrder = i, Parent = grid }, { Corner(11) })
Bind(f, "BackgroundColor3", "Card2"); Stroke(f)
VerticalSheen(f, .12)
local ic = Icon(f, icon, 13, "Accent")
ic.Frame.Position = UDim2.fromOffset(12, 12)
Text(f, name, 11, "Sub", FONT.Med, { Position = UDim2.fromOffset(31, 10), Size = UDim2.new(1, -40, 0, 17), TextTruncate = Enum.TextTruncate.AtEnd })
return Text(f, "-", 19, "Text", FONT.Bold, { Position = UDim2.fromOffset(12, 32), Size = UDim2.new(1, -24, 0, 24), TextTruncate = Enum.TextTruncate.AtEnd, NoTr = true })
end
local fpsL, pingL, plrL, sesL = Stat("monitor", "FPS", 1), Stat("wifi", "Ping", 2), Stat("user", "Players", 3), Stat("clock", "Session", 4)
local frames, start = 0, os.clock()
Connect(RunService.RenderStepped, function() frames += 1 end)
task.spawn(function()
while Gui.Parent do
fpsL.Text = tostring(frames * 2); frames = 0
local ok, p = pcall(function() return LP:GetNetworkPing() * 1000 end)
pingL.Text = ok and (math.floor(p) .. " ms") or "-"
plrL.Text = #Players:GetPlayers() .. "/" .. Players.MaxPlayers
local s = math.floor(os.clock() - start)
sesL.Text = string.format("%02d:%02d:%02d", s // 3600, (s % 3600) // 60, s % 60)
task.wait(.5)
end
end)
local nys = tab:Section({ Name = "New Year", Icon = "snowflake", Side = "Right" })
local ng = Create("Frame", { Size = UDim2.new(1, 0, 0, 72), BackgroundTransparency = 1, Parent = nys.Content }, {
Create("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1) }),
Create("UIGridLayout", { CellSize = UDim2.new(.25, -6, 1, 0), CellPadding = UDim2.fromOffset(8, 0), SortOrder = Enum.SortOrder.LayoutOrder }),
})
local cells = {}
for i, k in ipairs({ "Days", "Hours", "Minutes", "Seconds" }) do
local f = Create("Frame", { LayoutOrder = i, Parent = ng }, { Corner(11) })
Bind(f, "BackgroundColor3", "Card2")
Stroke(f)
VerticalSheen(f, .12)
cells[i] = Text(f, "00", 21, "Text", FONT.Heavy, { Size = UDim2.new(1, 0, 0, 28), Position = UDim2.fromOffset(0, 9), TextXAlignment = Enum.TextXAlignment.Center, NoTr = true })
Text(f, k, 10, "Sub", FONT.Med, { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -21), TextXAlignment = Enum.TextXAlignment.Center })
end
local nyMsg = Text(nys.Content, "", 12, "Accent", FONT.Semi, { Size = UDim2.new(1, 0, 0, 18), TextXAlignment = Enum.TextXAlignment.Center, NoTr = true })
task.spawn(function()
while Gui.Parent do
local now = os.date("*t")
local left = math.max(0, os.time({ year = now.year + 1, month = 1, day = 1, hour = 0, min = 0, sec = 0 }) - os.time(now))
cells[1].Text = string.format("%02d", left // 86400)
cells[2].Text = string.format("%02d", (left % 86400) // 3600)
cells[3].Text = string.format("%02d", (left % 3600) // 60)
cells[4].Text = string.format("%02d", left % 60)
if now.month == 1 and now.day <= 7 then
nyMsg.Text = tr("Happy New Year!")
else
nyMsg.Text = tr("Until New Year") .. " " .. (now.year + 1)
end
task.wait(1)
end
end)
local season = tab:Section({ Name = "Season", Icon = "sparkles", Side = "Right" })
local sg = Create("Frame", { Size = UDim2.new(1, 0, 0, 160), BackgroundTransparency = 1, ClipsDescendants = false, Parent = season.Content })
local sgLayout = Create("UIGridLayout", { CellSize = UDim2.new(.5, -5, 0, 74), CellPadding = UDim2.fromOffset(10, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sg })
local SHOWN = 4
local expanded = false
local tileBtns = {}
local function relayoutSeason()
local n = expanded and #Krieg.ThemeList or math.min(SHOWN, #Krieg.ThemeList)
for i, b in ipairs(tileBtns) do b.Visible = i <= n end
local rows = math.ceil(n / 2)
sg.Size = UDim2.new(1, 0, 0, rows * 74 + (rows - 1) * 10)
end
local tiles = {}
local function paintTiles()
for name, t in pairs(tiles) do
local on = name == Krieg.CurrentTheme
Tween(t.Stroke, .35, { Color = on and Krieg.ThemeMap[name].Accent or Current.Stroke, Thickness = on and 2 or 1, Transparency = on and 0 or .2 })
Tween(t.Check, .4, { Size = on and UDim2.fromOffset(18, 18) or UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back)
end
end
for i, name in ipairs(Krieg.ThemeList) do
local th = Krieg.ThemeMap[name]
local b = Create("TextButton", { Text = "", AutoButtonColor = false, BackgroundColor3 = th.Bg, ClipsDescendants = true, LayoutOrder = i, Parent = sg }, { Corner(12) })
tileBtns[i] = b
local sw = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BorderSizePixel = 0, Parent = b }, { Corner(12) })
Create("UIGradient", { Rotation = 35, Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, th.Bg:Lerp(th.Accent, .08)), ColorSequenceKeypoint.new(.55, th.Bg:Lerp(th.Accent, .28)), ColorSequenceKeypoint.new(1, th.Accent2:Lerp(th.Bg, .25)) }), Parent = sw })
local prev = Create("ImageLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, Image = "", Visible = false, Parent = b }, { Corner(12) })
local def = Krieg.ThemeWalls and Krieg.ThemeWalls[name]
if def then
Wall.resolve(WALL_BASE .. def.file .. "_1.jpg", function(ok, res)
if ok and prev.Parent then
prev.Image = res
prev.ImageRectSize = Vector2.new(FRAME_W, FRAME_H)
prev.ImageRectOffset = Vector2.new(FRAME_W, FRAME_H * 2)
prev.Visible = true
end
end)
end
local shade = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK, BorderSizePixel = 0, Parent = b }, { Corner(12) })
Create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(.45, .85), NumberSequenceKeypoint.new(1, .25) }), Parent = shade })
local st = Create("UIStroke", { Color = Current.Stroke, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = b })
Create("Frame", { Position = UDim2.new(0, 12, 1, -27), Size = UDim2.fromOffset(14, 3), BackgroundColor3 = th.Accent, BorderSizePixel = 0, Parent = b }, { Round() })
local tl = Create("TextLabel", { BackgroundTransparency = 1, Position = UDim2.new(0, 12, 1, -22), Size = UDim2.new(1, -40, 0, 16), Text = name, TextColor3 = WHITE, FontFace = FONT.Bold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = b })
tl:SetAttribute("KFixed", true)
SetTr(tl, name)
local check = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.new(1, -16, 1, -15), Size = UDim2.fromOffset(0, 0), BackgroundColor3 = th.Accent, ClipsDescendants = true, Parent = b }, { Round() })
Centered(BuildIcon(check, "check", 12, WHITE, 1.8))
tiles[name] = { Stroke = st, Check = check }
local tsc = Create("UIScale", { Parent = b })
b.MouseEnter:Connect(function() Tween(tsc, .25, { Scale = 1.03 }, Enum.EasingStyle.Back); Tween(shade, .2, { BackgroundTransparency = .15 }) end)
b.MouseLeave:Connect(function() Tween(tsc, .2, { Scale = 1 }); Tween(shade, .2, { BackgroundTransparency = 0 }) end)
b.MouseButton1Click:Connect(function() Krieg:SetTheme(name) end)
end
local more = Create("TextButton", { Size = UDim2.new(1, 0, 0, 30), Text = "", AutoButtonColor = false, Parent = season.Content }, { Corner(9) })
Bind(more, "BackgroundColor3", "Card2")
Stroke(more)
local moreLbl = Text(more, "Show all themes", 12, "Sub", FONT.Semi, { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center })
more.MouseButton1Click:Connect(function()
expanded = not expanded
SetTr(moreLbl, expanded and "Hide themes" or "Show all themes")
relayoutSeason()
end)
relayoutSeason()
paintTiles()
OnTheme(paintTiles)
local cl = tab:Section({ Name = "Changelog", Icon = "file", Side = "Right", Collapsed = true })
for _, line in ipairs(cfg.Changelog or { "v2.0 — новый дизайн Krieg Hub" }) do
cl:Label(line, "•  ")
end
return tab
end
local applySize
local function TileGrid(sec, cols, h)
local f = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = sec.Content })
Create("UIGridLayout", { CellSize = UDim2.new(1 / cols, -math.ceil(8 * (cols - 1) / cols), 0, h), CellPadding = UDim2.fromOffset(8, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = f })
return f
end
local function Tile(parent, order)
local b = Create("TextButton", { Text = "", AutoButtonColor = false, LayoutOrder = order, Parent = parent }, { Corner(10) })
Bind(b, "BackgroundColor3", "Card2")
VerticalSheen(b, .12)
local st = Create("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = Current.Stroke, Parent = b })
local sc = Create("UIScale", { Parent = b })
b.MouseEnter:Connect(function() Tween(sc, .22, { Scale = 1.04 }, Enum.EasingStyle.Back) end)
b.MouseLeave:Connect(function() Tween(sc, .2, { Scale = 1 }) end)
b.MouseButton1Down:Connect(function() Tween(sc, .1, { Scale = .96 }) end)
b.MouseButton1Up:Connect(function() Tween(sc, .3, { Scale = 1.04 }, Enum.EasingStyle.Back) end)
return b, st
end
local function Mark(st, on)
Tween(st, .25, { Color = on and Current.Accent or Current.Stroke, Thickness = on and 1.8 or 1 })
end
function Win:CreateSettings()
local tab = self:Tab({ Name = "Settings", Icon = "settings", Subtitle = "Configs and interface" })
Krieg.SettingsTab = tab
local cs = tab:Section({ Name = "Configs", Icon = "folder", Subtitle = FS_OK and "Saved as files" or "Saved for this session only" })
local nameBox = cs:Input({ Name = "Config Name", Placeholder = "my config" })
local listDD = cs:Dropdown({ Name = "Config List", Options = Krieg:ListConfigs() })
local autoTg
cs:Button({ Name = "Save Config", Icon = "save", Primary = true, Callback = function()
local n = nameBox.Value ~= "" and nameBox.Value or listDD.Value
if Krieg:SaveConfig(n) then
listDD:Refresh(Krieg:ListConfigs(), true); listDD:Set(n, true)
Krieg:Notify({ Title = "Config", Content = tr("Saved") .. ": " .. n, Icon = "save" })
end
end })
cs:Button({ Name = "Load Config", Icon = "folder", Callback = function()
if Krieg:LoadConfig(listDD.Value) then
Krieg:Notify({ Title = "Config", Content = tr("Loaded") .. ": " .. tostring(listDD.Value), Icon = "folder" })
end
end })
cs:Button({ Name = "Delete Config", Icon = "trash", Callback = function()
Krieg:DeleteConfig(listDD.Value)
if Krieg:GetAutoload() == listDD.Value then Krieg:SetAutoload(nil); autoTg:Set(false, true) end
listDD:Refresh(Krieg:ListConfigs())
end })
cs:Button({ Name = "Refresh List", Icon = "refresh", Callback = function() listDD:Refresh(Krieg:ListConfigs(), true) end })
autoTg = cs:Toggle({ Name = "Auto Load Config", Default = Krieg:GetAutoload() ~= nil, Callback = function(v)
if v and listDD.Value then
Krieg:SetAutoload(listDD.Value)
Krieg:Notify({ Title = "Auto Load", Content = tr("Will load on start") .. ": " .. listDD.Value, Icon = "check" })
elseif not v then
Krieg:SetAutoload(nil)
end
end })
local ui = tab:Section({ Name = "Interface", Icon = "monitor", Side = "Right" })
ui:Keybind({ Name = "Toggle Menu", Default = Krieg.ToggleKey, Changed = function(k)
Krieg.ToggleKey = k
Store.set("Key", k.Name)
end })
ui:Toggle({ Name = "Notifications", Default = S.Notifs, Callback = function(v) Store.set("Notifs", v) end })
ui:Slider({ Name = "UI Scale", Min = .6, Max = 1.3, Increment = .05, Default = S.Scale, Callback = function(v)
Krieg.UserScale = v
Store.set("Scale", v)
if visible then Tween(Scale, .35, { Scale = fitScale() * v }) end
end })
ui:Button({ Name = "Reset Size", Icon = "refresh", Callback = function() applySize(DEF_W, DEF_H, .4) end })
ui:Button({ Name = "Unload Menu", Icon = "power", Callback = function() Krieg:Destroy() end })
local lg = tab:Section({ Name = "Language", Icon = "globe", Side = "Right" })
local lgrid = TileGrid(lg, 3, 52)
local codes = { ["English"] = "EN", ["Русский"] = "RU", ["Қазақша"] = "KZ" }
local ltiles = {}
for i, name in ipairs(Lang.list) do
local b, st = Tile(lgrid, i)
Text(b, codes[name], 15, "Accent", FONT.Heavy, { Size = UDim2.new(1, 0, 0, 22), Position = UDim2.fromOffset(0, 7), TextXAlignment = Enum.TextXAlignment.Center, NoTr = true })
Text(b, name, 11, "Sub", FONT.Med, { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -19), TextXAlignment = Enum.TextXAlignment.Center, NoTr = true })
ltiles[name] = st
b.MouseButton1Click:Connect(function() Krieg:SetLanguage(name) end)
end
local function paintLang() for n, st in pairs(ltiles) do Mark(st, n == Lang.cur) end end
paintLang()
OnTheme(paintLang)
table.insert(Krieg.GridRefreshers, paintLang)
local ap = self:Tab({ Name = "Appearance", Icon = "palette", Subtitle = "Make the menu yours" })
local st = ap:Section({ Name = "Style", Icon = "sparkles" })
local themeDD = st:Dropdown({ Name = "Theme", Options = Krieg.ThemeList, Default = Krieg.CurrentTheme, Callback = function(v) Krieg:SetTheme(v) end })
OnTheme(function() if themeDD.Value ~= Krieg.CurrentTheme then themeDD:Set(Krieg.CurrentTheme, true) end end)
st:Label("Accent")
local arow = Create("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Parent = st.Content }, {
Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder }),
})
local ACC = {
Color3.fromRGB(232, 72, 72), Color3.fromRGB(255, 128, 36), Color3.fromRGB(245, 190, 40), Color3.fromRGB(80, 205, 120),
Color3.fromRGB(40, 190, 210), Color3.fromRGB(70, 125, 255), Color3.fromRGB(150, 95, 255), Color3.fromRGB(235, 85, 170), WHITE,
}
local rings = {}
for i, c in ipairs(ACC) do
local d = Create("TextButton", { Size = UDim2.fromOffset(20, 20), BackgroundColor3 = c, Text = "", AutoButtonColor = false, LayoutOrder = i, Parent = arow }, { Corner(6) })
local ring = Create("UIStroke", { Thickness = 2, Color = WHITE, Transparency = 1, Parent = d })
rings[i] = { ring, c }
d.MouseEnter:Connect(function() Tween(d, .15, { Size = UDim2.fromOffset(24, 24) }, Enum.EasingStyle.Back) end)
d.MouseLeave:Connect(function() Tween(d, .15, { Size = UDim2.fromOffset(20, 20) }) end)
d.MouseButton1Click:Connect(function() Krieg:SetAccent(c) end)
end
local function paintAcc()
for _, r in ipairs(rings) do
r[1].Color = Current.Text
Tween(r[1], .2, { Transparency = (Krieg.AccentOverride == r[2]) and 0 or 1 })
end
end
paintAcc()
OnTheme(paintAcc)
st:Button({ Name = "Use style color", Icon = "refresh", Callback = function() Krieg:SetAccent(nil) end })
st:Label("Text color")
local tcg = TileGrid(st, 4, 46)
local TC = {
{ "Auto" }, { "White", WHITE }, { "Black", Color3.fromRGB(18, 18, 22) }, { "Cream", Color3.fromRGB(255, 240, 214) },
{ "Pink", Color3.fromRGB(255, 170, 205) }, { "Mint", Color3.fromRGB(150, 240, 200) }, { "Sky", Color3.fromRGB(150, 205, 255) }, { "Gold", Color3.fromRGB(255, 214, 110) },
}
local tct = {}
for i, ch in ipairs(TC) do
local b, s2 = Tile(tcg, i)
local sw = Create("Frame", { Size = UDim2.fromOffset(18, 18), AnchorPoint = Vector2.new(.5, 0), Position = UDim2.new(.5, 0, 0, 6), BackgroundColor3 = ch[2] or WHITE, Parent = b }, {
Round(), Create("UIStroke", { Color = Color3.fromRGB(128, 128, 128), Transparency = .4 }),
})
if not ch[2] then Create("UIGradient", { Rotation = 45, Color = ColorSequence.new(WHITE, Color3.fromRGB(18, 18, 22)), Parent = sw }) end
Text(b, ch[1], 10, "Sub", FONT.Med, { Size = UDim2.new(1, -4, 0, 13), Position = UDim2.new(0, 2, 1, -17), TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd })
tct[i] = { s2, ch[2] }
b.MouseButton1Click:Connect(function() Krieg:SetTextColor(ch[2]) end)
end
local function paintTC()
local cur = Krieg.TextOverride
for _, t in ipairs(tct) do
Mark(t[1], (t[2] == nil and cur == nil) or (t[2] ~= nil and cur ~= nil and t[2] == cur))
end
end
paintTC()
OnTheme(paintTC)
local fx = ap:Section({ Name = "Effects", Icon = "snowflake" })
fx:Toggle({ Name = "Particles", Default = S.Particles, Callback = function(v)
Krieg.ParticlesOn = v
Store.set("Particles", v)
end })
fx:Slider({ Name = "Amount", Min = .25, Max = 2, Increment = .05, Default = S.Density, Suffix = "x", Callback = function(v) Store.set("Density", v) end })
fx:Slider({ Name = "Panel transparency", Min = 0, Max = .7, Increment = .05, Default = S.PanelAlpha, Callback = function(v)
Krieg:SetPanelAlpha(v)
Store.save()
end })
local wp = ap:Section({ Name = "Wallpaper", Icon = "image", Side = "Right" })
local url = wp:Input({ Name = "Link", Placeholder = "Image link or Roblox image ID", Default = S.Wallpaper })
wp:Label("Pinterest link, PNG/JPG link or Roblox image ID")
wp:Button({ Name = "Activate", Icon = "check", Primary = true, Callback = function()
local src = url.Box.Text
url:Set(src, true)
Krieg:Notify({ Title = "Wallpaper", Content = "Loading...", Icon = "image", Duration = 2 })
Krieg:ResolveWallpaper(src, function(ok, res)
if ok then
Store.set("Wallpaper", src)
Krieg:StopThemeWall()
Krieg:ApplyWallpaper(res)
Krieg:Notify({ Title = "Wallpaper", Content = "Wallpaper is on", Icon = "image" })
else
Krieg:Notify({ Title = "Wallpaper", Content = res, Icon = "x" })
end
end)
end })
wp:Button({ Name = "Remove", Icon = "trash", Callback = function()
url:Set("", true)
Store.set("Wallpaper", "")
Krieg:ApplyWallpaper(nil)
Krieg:PlayThemeWall(Krieg.CurrentTheme)
end })
wp:Slider({ Name = "Darken", Min = 0, Max = .9, Increment = .05, Default = S.WallDim, Callback = function(v)
Krieg:SetWallDim(v)
Store.save()
end })
wp:Toggle({ Name = "Live theme wallpapers", Default = S.ThemeWall, Callback = function(v)
Store.set("ThemeWall", v)
if v then Krieg:PlayThemeWall(Krieg.CurrentTheme) elseif S.Wallpaper == "" then Krieg:StopThemeWall() end
end })
wp:Toggle({ Name = "Also in mini bar", Default = S.WallMini, Callback = function(v)
Store.set("WallMini", v)
if Krieg.WallActive then Krieg:ApplyWallpaper(Krieg.WallImage) end
end })
local fs = ap:Section({ Name = "Font", Icon = "type", Side = "Right" })
local ftiles = {}
local function paintFonts() for n, s2 in pairs(ftiles) do Mark(s2, n == S.Font) end end
local function fontTile(parent, f, i)
local b, s2 = Tile(parent, i)
local smp = Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 6), Text = "Aa Яя", TextSize = 17, FontFace = Font.new(f[2], Enum.FontWeight.Bold), Parent = b })
smp:SetAttribute("KFixed", true)
Bind(smp, "TextColor3", "Accent")
local nl = Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -6, 0, 14), Position = UDim2.new(0, 3, 1, -18), Text = f[1], TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd, FontFace = Font.new(f[2], Enum.FontWeight.Regular), Parent = b })
nl:SetAttribute("KFixed", true)
Bind(nl, "TextColor3", "Sub")
ftiles[f[1]] = s2
b.MouseButton1Click:Connect(function() Krieg:SetFontByName(f[1]) end)
end
local fg = TileGrid(fs, 3, 54)
for i, f in ipairs(FONTS) do fontTile(fg, f, i) end
local moreHolder, moreMade
fs:Button({ Name = "More fonts", Icon = "chevron", Callback = function()
if not moreMade then
moreMade = true
for i, f in ipairs(FONTS_MORE) do fontTile(moreHolder, f, i) end
paintFonts()
moreHolder.Visible = true
else
moreHolder.Visible = not moreHolder.Visible
end
end })
moreHolder = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false, Parent = fs.Content })
Create("UIGridLayout", { CellSize = UDim2.new(1 / 3, -6, 0, 54), CellPadding = UDim2.fromOffset(8, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = moreHolder })
paintFonts()
OnTheme(paintFonts)
table.insert(Krieg.GridRefreshers, paintFonts)
local cf = fs:Input({ Name = "Your font", Placeholder = "e.g. Lobster, 12187365364 or https://...ttf", Default = S.Font == "Custom" and S.FontCustom or "" })
fs:Button({ Name = "Apply", Icon = "check", Primary = true, Callback = function() Krieg:SetCustomFont(cf.Value) end })
fs:Button({ Name = "Reset", Icon = "refresh", Callback = function()
cf:Set("", true)
S.FontCustom = ""
Krieg:SetFontByName("Gotham")
end })
fs:Slider({ Name = "Text size", Min = .8, Max = 1.2, Increment = .01, Default = S.TextScale, Suffix = "x", Callback = function(v)
Store.set("TextScale", v)
Krieg:ApplyTextScale(v)
end })
local mbt = self:Tab({ Name = "Mini Bar", Icon = "panel" })
local m1 = mbt:Section({ Name = "Mini Bar", Icon = "panel" })
m1:Toggle({ Name = "Show mini bar", Default = S.MiniBar, Callback = function(v)
Store.set("MiniBar", v)
if Krieg.Mini then Krieg.Mini.Frame.Visible = v end
end })
m1:Dropdown({ Name = "Position", Options = { "Top", "Bottom" }, Default = S.MiniPos, Callback = function(v)
Store.set("MiniPos", v)
if Krieg.Mini then Krieg.Mini.SetPos(v) end
end })
local m2 = mbt:Section({ Name = "Show on bar", Icon = "eye", Side = "Right" })
for _, it in ipairs({ { "FPS", "MiniFps", "fps" }, { "Ping", "MiniPing", "ping" }, { "Clock", "MiniClock", "clock" } }) do
m2:Toggle({ Name = it[1], Default = S[it[2]], Callback = function(v)
Store.set(it[2], v)
if Krieg.Mini then Krieg.Mini.SetSeg(it[3], v) end
end })
end
m2:Toggle({ Name = "Close button", Default = S.MiniClose, Callback = function(v)
Store.set("MiniClose", v)
if Krieg.Mini then Krieg.Mini.Close.Visible = v end
end })
return tab
end
Search:GetPropertyChangedSignal("Text"):Connect(function()
local q = string.lower(Search.Text)
local function hit(raw)
return string.find(string.lower(raw), q, 1, true) ~= nil or string.find(string.lower(tr(raw)), q, 1, true) ~= nil
end
for _, tab in ipairs(Win.Tabs) do
local tabMatch = q == "" or hit(tab.Name)
local any = tabMatch
for _, el in ipairs(tab.Elements) do
local m = tabMatch or hit(el.Raw or el.Name)
if m then any = true end
if not el.IsSection then el.Frame.Visible = m end
end
tab.Button.Visible = any
end
for _, h in ipairs(groupHeaders) do h.Visible = q == "" and not collapsed end
end)
Search.Focused:Connect(function() Tween(SearchStroke, .2, { Color = Current.Accent }) end)
Search.FocusLost:Connect(function() Tween(SearchStroke, .2, { Color = Current.Stroke }) end)
local userCollapsed, autoCollapsed = false, false
local function setCollapsed(v, t)
if collapsed == v then return end
collapsed = v
t = t or .4
local sw = collapsed and 64 or SIDE
Tween(Sidebar, t, { Size = UDim2.new(0, sw, 1, -TOP - 1) })
Tween(VLine, t, { Position = UDim2.new(0, sw, 0, TOP + 1) })
Tween(Content, t, { Position = UDim2.fromOffset(sw + 1, TOP + 1), Size = UDim2.new(1, -sw - 1, 1, -TOP - 1) })
Tween(ProfileMini, t, { Size = UDim2.new(1, -24, 0, 58), Position = UDim2.new(0, 12, 1, -12) })
Tween(ring, t, { Position = collapsed and UDim2.new(.5, -19, 0, 10) or UDim2.fromOffset(10, 10) })
Tween(MiniName, .2, { TextTransparency = collapsed and 1 or 0 })
Tween(MiniUser, .2, { TextTransparency = collapsed and 1 or 0 })
Online.Visible = not collapsed
for _, h in ipairs(groupHeaders) do h.Visible = not collapsed and Search.Text == "" end
paintTabs(.25)
end
SideBtn.MouseButton1Click:Connect(function()
userCollapsed = not collapsed
autoCollapsed = false
setCollapsed(not collapsed)
end)
local function adapt(w)
if w < 740 then
if not collapsed then autoCollapsed = true; setCollapsed(true, .25) end
elseif autoCollapsed and not userCollapsed then
autoCollapsed = false
setCollapsed(false, .25)
end
local leftEdge = SIDE + 14 + 36 + 14
local avail = (w - 106) - leftEdge
local sw = math.min(230, avail)
SearchFrame.Visible = sw >= 130
SearchFrame.Size = UDim2.fromOffset(math.max(sw, 130), 36)
local pillW = Pill.AbsoluteSize.X / UScale()
if pillW < 40 then pillW = 130 end
Pill.Visible = SearchFrame.Visible and (avail - sw - 12) >= pillW
Pill.Position = UDim2.new(1, -106 - sw - 12, 0, 16)
end
local topLayout = adapt
task.defer(adapt, W)
applySize = function(w, h, t)
local s = Scale.Scale
local p = Window.Position
local np = UDim2.new(p.X.Scale, p.X.Offset + (w - W) * s / 2, p.Y.Scale, p.Y.Offset + (h - H) * s / 2)
W, H = w, h
topLayout(w)
if t then
Tween(Window, t, { Size = UDim2.fromOffset(w, minimized and TOP or h), Position = np })
else
Window.Size = UDim2.fromOffset(w, minimized and TOP or h)
Window.Position = np
end
end
do
local resizing, rsStart, rsSize, rsPos
Grip.InputBegan:Connect(function(i)
if IsClick(i) and not minimized then
resizing, rsStart, rsSize, rsPos = true, i.Position, Vector2.new(W, H), Window.Position
gripIcon:SetColor(Current.Accent, .2)
end
end)
Connect(UIS.InputChanged, function(i)
if resizing and IsMove(i) then
local s = Scale.Scale
local cam = workspace.CurrentCamera.ViewportSize
local d = (i.Position - rsStart) / s
local w = math.clamp(rsSize.X + d.X, MIN_W, cam.X / s)
local h = math.clamp(rsSize.Y + d.Y, MIN_H, cam.Y / s)
W, H = w, h
topLayout(w)
Window.Size = UDim2.fromOffset(w, h)
Window.Position = UDim2.new(rsPos.X.Scale, rsPos.X.Offset + (w - rsSize.X) * s / 2, rsPos.Y.Scale, rsPos.Y.Offset + (h - rsSize.Y) * s / 2)
end
end)
Connect(UIS.InputEnded, function(i)
if resizing and IsClick(i) then
resizing = false
gripIcon:SetColor(Current.Sub, .3)
end
end)
end
do
local dragging, startPos, startInput
Top.InputBegan:Connect(function(i)
if IsClick(i) then dragging, startPos, startInput = true, Window.Position, i.Position end
end)
Connect(UIS.InputChanged, function(i)
if dragging and IsMove(i) then
local d = i.Position - startInput
Tween(Window, .1, { Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) }, Enum.EasingStyle.Quad)
end
end)
Connect(UIS.InputEnded, function(i)
if IsClick(i) then dragging = false end
end)
end
local animId = 0
local function show()
animId += 1
local id = animId
visible = true
Window.Visible = true
Inner.Visible = false
Overlay.BackgroundTransparency = 1
local target = fitScale() * Krieg.UserScale
Scale.Scale = target * .9
Tween(Scale, .55, { Scale = target }, Enum.EasingStyle.Back)
Tween(Main, .25, { BackgroundTransparency = 0 })
Tween(OutlineStroke, .4, { Transparency = 0 })
Tween(Shadow, .4, { ImageTransparency = .35 })
gripIcon:SetTransparency(minimized and 1 or 0, .4)
task.delay(.16, function()
if id ~= animId then return end
Overlay.BackgroundTransparency = 0
Inner.Visible = true
Inner.Position = UDim2.fromOffset(0, 10)
Tween(Inner, .45, { Position = UDim2.fromOffset(0, 0) })
Tween(Overlay, .4, { BackgroundTransparency = 1 })
end)
end
local function hide()
animId += 1
local id = animId
visible = false
Tween(Overlay, .15, { BackgroundTransparency = 0 })
gripIcon:SetTransparency(1, .15)
task.delay(.15, function()
if id ~= animId then return end
Inner.Visible = false
Tween(Scale, .28, { Scale = fitScale() * Krieg.UserScale * .92 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
Tween(Main, .25, { BackgroundTransparency = 1 })
Tween(Overlay, .25, { BackgroundTransparency = 1 })
Tween(OutlineStroke, .25, { Transparency = 1 })
Tween(Shadow, .25, { ImageTransparency = 1 })
task.delay(.28, function() if id == animId and not visible then Window.Visible = false end end)
end)
end
function Win:Toggle() if visible then hide() else show() end end
function Win:Show() show() end
function Win:Hide() hide() end
MinBtn.MouseButton1Click:Connect(function()
minimized = not minimized
local s = Scale.Scale
local p = Window.Position
local dh = (minimized and (TOP - H) or (H - TOP)) * s / 2
if minimized then
Sidebar.Visible = false; VLine.Visible = false; Content.Visible = false
else
task.delay(.12, function()
if not minimized then Sidebar.Visible = true; VLine.Visible = true; Content.Visible = true end
end)
end
Tween(Window, .45, { Size = UDim2.fromOffset(W, minimized and TOP or H), Position = UDim2.new(p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset + dh) })
MinIcon.ic.Frame:Destroy()
MinIcon.ic = Centered(BuildIcon(MinBtn, minimized and "plus" or "minus", 16, Current.Sub))
gripIcon:SetTransparency(minimized and 1 or 0, .2)
end)
CloseBtn.MouseButton1Click:Connect(function()
hide()
Krieg:Notify({ Title = "Menu hidden", Content = "Press the menu key or click the mini bar", Icon = "eye", Duration = 3 })
end)
Pill.MouseButton1Click:Connect(function()
for _, t in ipairs(Win.Tabs) do
if t.Name == "Home" then Win:SelectTab(t) return end
end
end)
Connect(UIS.InputBegan, function(i, gp)
if i.KeyCode == Krieg.ToggleKey then Win:Toggle() return end
if not gp and i.KeyCode == Enum.KeyCode.Slash and visible then
task.defer(function() Search:CaptureFocus(); Search.Text = "" end)
end
end)
if UIS.TouchEnabled then
local mb = Create("TextButton", { Position = UDim2.new(0, 16, .4, 0), Size = UDim2.fromOffset(48, 48), Text = "", BackgroundColor3 = WHITE, Parent = Gui }, { Corner(14) })
ThemeGrad(mb, 0, 40)
Text(mb, "K", 21, nil, FONT.Heavy, { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = WHITE })
Shine(mb, UDim.new(0, 14), .4, .55)
mb.MouseButton1Click:Connect(function() Win:Toggle() end)
end
do
local function hex(c)
return string.format("#%02X%02X%02X", math.floor(c.R * 255 + .5), math.floor(c.G * 255 + .5), math.floor(c.B * 255 + .5))
end
local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
local RED = Color3.fromRGB(232, 72, 72)
local H_LIST = function(pad)
return Create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, pad), VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder })
end
local Mini = Create("Frame", {
Name = "MiniBar", AnchorPoint = Vector2.new(.5, 0), Position = UDim2.new(.5, 0, 0, 12),
Size = UDim2.fromOffset(0, 38), AutomaticSize = Enum.AutomaticSize.X, BorderSizePixel = 0,
ClipsDescendants = true, Visible = S.MiniBar, ZIndex = 5, Parent = Gui,
}, { Corner(12), Create("UIScale", { Scale = math.clamp(vp.X / 900, .72, 1) }) })
Bind(Mini, "BackgroundColor3", "Bg")
VerticalSheen(Mini, .1)
local miniStroke = Create("UIStroke", { Color = WHITE, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = Mini })
ThemeGrad(miniStroke, 0, 45)
local mwImg = Create("ImageLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, Image = "", Visible = false, Parent = Mini }, { Corner(12) })
local mwShade = Create("Frame", { Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, Visible = false, Parent = Mini }, { Corner(12) })
Bind(mwShade, "BackgroundColor3", "Bg")
table.insert(self.Walls, { mwImg, mwShade, mini = true })
local MiniRow = Create("Frame", { Size = UDim2.fromOffset(0, 38), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = Mini }, { Pad(0, 0, 8, 8), H_LIST(9) })
local drag
local function dragHandle(h)
h.InputBegan:Connect(function(i)
if IsClick(i) then drag = { s = i.Position, p = Mini.Position } end
end)
end
Connect(UIS.InputChanged, function(i)
if drag and IsMove(i) then
local d = i.Position - drag.s
Mini.Position = UDim2.new(drag.p.X.Scale, drag.p.X.Offset + d.X, drag.p.Y.Scale, drag.p.Y.Offset + d.Y)
end
end)
Connect(UIS.InputEnded, function(i) if IsClick(i) then drag = nil end end)
local ord = 0
local function O() ord += 1 return ord end
local grip = Create("Frame", { Size = UDim2.fromOffset(12, 20), BackgroundTransparency = 1, LayoutOrder = O(), Parent = MiniRow })
Centered(Icon(grip, "gripV", 16, "Sub"))
dragHandle(grip)
local brand = Create("TextButton", { Size = UDim2.fromOffset(0, 38), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = O(), Parent = MiniRow }, { H_LIST(7) })
local mav = Create("ImageLabel", { Size = UDim2.fromOffset(26, 26), Image = headshot, LayoutOrder = 1, Parent = brand }, { Corner(9) })
Bind(mav, "BackgroundColor3", "Card2")
Stroke(mav, "Accent", 1.5, .25)
table.insert(avatarTargets, mav)
local mbrand = Text(brand, "", 13, "Text", FONT.Heavy, { Size = UDim2.fromOffset(0, 38), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 2, NoTr = true })
local function brandText() mbrand.Text = 'krieg <font color="' .. hex(Current.Accent) .. '">hub</font>' end
brandText()
OnTheme(brandText)
local bsc = Create("UIScale", { Parent = brand })
brand.MouseEnter:Connect(function() Tween(bsc, .2, { Scale = 1.05 }, Enum.EasingStyle.Back) end)
brand.MouseLeave:Connect(function() Tween(bsc, .2, { Scale = 1 }) end)
brand.MouseButton1Click:Connect(function() Win:Toggle() end)
local segs = {}
local function segment(key)
local div = Create("Frame", { Size = UDim2.fromOffset(1, 16), BorderSizePixel = 0, LayoutOrder = O(), Parent = MiniRow })
Bind(div, "BackgroundColor3", "Stroke")
local s = Create("Frame", { Size = UDim2.fromOffset(0, 38), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, LayoutOrder = O(), Parent = MiniRow }, { H_LIST(4) })
dragHandle(s)
segs[key] = { s, div }
return s
end
local function val(parent, t, order, key, font, size)
return Text(parent, t, size or 12, key or "Text", font or FONT.Bold, { Size = UDim2.fromOffset(0, 38), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = order, NoTr = true })
end
local fpsSeg = segment("fps")
local fpsV = val(fpsSeg, "60", 1)
val(fpsSeg, "fps", 2, "Sub", FONT.Reg, 11)
local pingSeg = segment("ping")
local pingIc = BuildIcon(pingSeg, "signal", 13, Color3.fromRGB(90, 210, 120))
pingIc.Frame.LayoutOrder = 1
local pingV = val(pingSeg, "0", 2)
val(pingSeg, "ms", 3, "Sub", FONT.Reg, 11)
local clockSeg = segment("clock")
local cic = Icon(clockSeg, "clock", 12, "Accent")
cic.Frame.LayoutOrder = 1
local clockV = val(clockSeg, "00:00", 2)
local mClose = Create("TextButton", { Size = UDim2.fromOffset(0, 26), AutomaticSize = Enum.AutomaticSize.X, Text = "", AutoButtonColor = false, LayoutOrder = O(), Parent = MiniRow }, { Corner(8), Pad(0, 0, 8, 10), H_LIST(5) })
Bind(mClose, "BackgroundColor3", "Card2")
local mcs = Stroke(mClose)
local xic = Icon(mClose, "x", 11, "Text")
xic.Frame.LayoutOrder = 1
Text(mClose, "close", 11, "Text", FONT.Semi, { Size = UDim2.fromOffset(0, 26), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 2 })
mClose.MouseEnter:Connect(function() Tween(mClose, .2, { BackgroundColor3 = RED }); Tween(mcs, .2, { Color = RED }) end)
mClose.MouseLeave:Connect(function() Tween(mClose, .2, { BackgroundColor3 = Current.Card2 }); Tween(mcs, .2, { Color = Current.Stroke }) end)
mClose.MouseButton1Click:Connect(function() Krieg:Destroy() end)
local mf, macc = 0, 0
Connect(RunService.RenderStepped, function(dt) mf += 1; macc += dt end)
local StatsSvc = game:GetService("Stats")
task.spawn(function()
while Gui.Parent do
if macc > 0 then
fpsV.Text = tostring(math.floor(mf / macc + .5))
mf, macc = 0, 0
end
local p = 0
local ok, v = pcall(function() return StatsSvc.Network.ServerStatsItem["Data Ping"]:GetValue() end)
if ok and type(v) == "number" and v > 0 then
p = math.floor(v + .5)
else
local ok2, v2 = pcall(function() return LP:GetNetworkPing() * 2000 end)
if ok2 and type(v2) == "number" then p = math.floor(v2 + .5) end
end
pingV.Text = tostring(p)
pingIc:SetColor((p < 90 and Color3.fromRGB(90, 210, 120)) or (p < 160 and Color3.fromRGB(240, 190, 60)) or RED, .3)
clockV.Text = os.date("%H:%M")
task.wait(.5)
end
end)
local function setSeg(key, on)
local s = segs[key]
if s then s[1].Visible = on; s[2].Visible = on end
end
setSeg("fps", S.MiniFps)
setSeg("ping", S.MiniPing)
setSeg("clock", S.MiniClock)
mClose.Visible = S.MiniClose
local function setPos(v)
if v == "Bottom" then
Mini.AnchorPoint = Vector2.new(.5, 1)
Mini.Position = UDim2.new(.5, 0, 1, -12)
else
Mini.AnchorPoint = Vector2.new(.5, 0)
Mini.Position = UDim2.new(.5, 0, 0, 12)
end
end
setPos(S.MiniPos)
Krieg.Mini = { Frame = Mini, SetSeg = setSeg, Close = mClose, SetPos = setPos }
local target = Mini.Position
Mini.Position = target + UDim2.fromOffset(0, S.MiniPos == "Bottom" and 70 or -70)
Tween(Mini, .6, { Position = target }, Enum.EasingStyle.Back)
end
do
local NY = Krieg.NYDecor
local BULB = {
Color3.fromRGB(255, 196, 110), Color3.fromRGB(255, 92, 84), Color3.fromRGB(255, 226, 170),
Color3.fromRGB(96, 214, 140), Color3.fromRGB(255, 176, 72), Color3.fromRGB(110, 170, 255),
}
local WIRE = Color3.fromRGB(28, 36, 32)
local Garland = Create("Frame", { Position = UDim2.fromOffset(0, TOP - 2), Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, ZIndex = 3, Parent = Inner })
table.insert(NY, Garland)
local bulbs = {}
local function seg(a, b)
local d = b - a
Create("Frame", {
AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromOffset((a.X + b.X) / 2, (a.Y + b.Y) / 2),
Size = UDim2.fromOffset(d.Magnitude + .6, 1), Rotation = math.deg(math.atan2(d.Y, d.X)),
BackgroundColor3 = WIRE, BorderSizePixel = 0, ZIndex = 3, Parent = Garland,
})
end
local lastW = -1
local function buildGarland()
local w = Garland.AbsoluteSize.X / UScale()
if w <= 0 or math.abs(w - lastW) < 2 then return end
lastW = w
for _, c in ipairs(Garland:GetChildren()) do c:Destroy() end
bulbs = {}
local spans = math.max(3, math.floor(w / 190))
local perSpan = 5
local idx = 0
for sIdx = 0, spans - 1 do
local x0, x1 = w * sIdx / spans, w * (sIdx + 1) / spans
local sag = 9
local function at(t) return Vector2.new(x0 + (x1 - x0) * t, 1 + sag * 4 * t * (1 - t)) end
local prev = at(0)
for k = 1, 16 do
local p = at(k / 16)
seg(prev, p)
prev = p
end
for b = 1, perSpan do
idx += 1
local p = at(b / (perSpan + 1))
local col = BULB[(idx % #BULB) + 1]
local tilt = (b - (perSpan + 1) / 2) * 7
local holder = Create("Frame", { AnchorPoint = Vector2.new(.5, 0), Position = UDim2.fromOffset(p.X, p.Y - 1), Size = UDim2.fromOffset(8, 14), Rotation = tilt, BackgroundTransparency = 1, ZIndex = 3, Parent = Garland })
local glowL = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromOffset(4, 9), Size = UDim2.fromOffset(26, 26), BackgroundColor3 = col, BackgroundTransparency = .9, BorderSizePixel = 0, ZIndex = 2, Parent = holder }, { Round() })
local glowS = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromOffset(4, 9), Size = UDim2.fromOffset(14, 14), BackgroundColor3 = col, BackgroundTransparency = .75, BorderSizePixel = 0, ZIndex = 2, Parent = holder }, { Round() })
Create("Frame", { AnchorPoint = Vector2.new(.5, 0), Position = UDim2.fromOffset(4, 0), Size = UDim2.fromOffset(4, 4), BackgroundColor3 = Color3.fromRGB(58, 66, 62), BorderSizePixel = 0, ZIndex = 4, Parent = holder }, { Corner(1) })
local glass = Create("Frame", { AnchorPoint = Vector2.new(.5, 0), Position = UDim2.fromOffset(4, 3), Size = UDim2.fromOffset(6, 10), BackgroundColor3 = col, BorderSizePixel = 0, ZIndex = 4, Parent = holder }, { Round() })
Create("UIGradient", { Rotation = 90, Color = ColorSequence.new(col:Lerp(WHITE, .45), col), Parent = glass })
Create("Frame", { Position = UDim2.fromOffset(1, 2), Size = UDim2.fromOffset(2, 3), BackgroundColor3 = WHITE, BackgroundTransparency = .35, BorderSizePixel = 0, ZIndex = 5, Parent = glass }, { Round() })
table.insert(bulbs, { glass = glass, gl = glowL, gs = glowS, phase = idx * .9 })
end
end
end
Garland:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() task.defer(buildGarland) end)
task.defer(buildGarland)
local Scene = Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = Fx })
table.insert(NY, Scene)
local drift = Create("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 70), BackgroundColor3 = Color3.fromRGB(214, 232, 255), BorderSizePixel = 0, Parent = Scene })
Create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(.7, .93), NumberSequenceKeypoint.new(1, .86) }), Parent = drift })
for _, c in ipairs({ { 0, 0, 45 }, { 1, 0, 135 } }) do
local f = Create("Frame", { AnchorPoint = Vector2.new(c[1], c[2]), Position = UDim2.fromScale(c[1], c[2]), Size = UDim2.fromOffset(220, 160), BackgroundColor3 = Color3.fromRGB(205, 228, 255), BorderSizePixel = 0, Parent = Scene })
Create("UIGradient", { Rotation = c[3], Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, .9), NumberSequenceKeypoint.new(.45, 1), NumberSequenceKeypoint.new(1, 1) }), Parent = f })
end
if Krieg.Mini then
local frost = Create("Frame", { Size = UDim2.new(1, -24, 0, 1), Position = UDim2.fromOffset(12, 0), BackgroundColor3 = Color3.fromRGB(220, 238, 255), BorderSizePixel = 0, Parent = Krieg.Mini.Frame })
Create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(.3, .3), NumberSequenceKeypoint.new(.7, .3), NumberSequenceKeypoint.new(1, 1) }), Parent = frost })
table.insert(NY, frost)
end
Connect(RunService.Heartbeat, function()
if not visible or Krieg.CurrentTheme ~= "New Year" then return end
local t = os.clock()
for _, b in ipairs(bulbs) do
local k = (math.sin(t * 1.8 - b.phase) + 1) / 2
k = k * k * (3 - 2 * k)
b.glass.BackgroundTransparency = .45 - .45 * k
b.gs.BackgroundTransparency = 1 - .3 * k
b.gl.BackgroundTransparency = 1 - .13 * k
end
end)
local function setDecor()
local on = Krieg.CurrentTheme == "New Year"
for i = #NY, 1, -1 do
local o = NY[i]
if o.Parent then o.Visible = on else table.remove(NY, i) end
end
end
setDecor()
OnTheme(setDecor)
end
do
local img = IconImage("_pumpkin")
local HW = {}
if img then
local spots = { { 0, 34, 54, -6 }, { 1, -118, 46, 4 }, { 1, -74, 34, -3 } }
for _, sp in ipairs(spots) do
local hold = Create("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(sp[1], sp[2], 1, 8), Size = UDim2.fromOffset(sp[3], sp[3] * .94), BackgroundTransparency = 1, ZIndex = 8, Parent = Inner })
local glow = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .6), Size = UDim2.fromScale(1.9, 1.5), BackgroundColor3 = Color3.fromRGB(255, 150, 50), BackgroundTransparency = .9, BorderSizePixel = 0, ZIndex = 7, Parent = hold }, { Round() })
Create("ImageLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = img, Rotation = sp[4], ZIndex = 9, Parent = hold })
table.insert(HW, { hold = hold, glow = glow, ph = math.random() * 6 })
end
end
Connect(RunService.Heartbeat, function()
local on = Krieg.CurrentTheme == "Halloween" and visible and not minimized
for _, p in ipairs(HW) do
p.hold.Visible = on
if on then
local t = os.clock() * 7 + p.ph
local fl = (math.sin(t) + math.sin(t * 2.3) * .5 + 1.5) / 3
p.glow.BackgroundTransparency = .93 - .1 * fl
end
end
end)
end
task.spawn(function()
while Gui.Parent do
local th = Current
local kind = th.Particle
if Krieg.ParticlesOn and visible and not minimized then
local x = math.random()
local obj, finish, dur
local rot = math.random(-180, 180)
if kind == "rain" then
obj = Create("Frame", { Size = UDim2.fromOffset(1, math.random(12, 20)), Rotation = 12, BorderSizePixel = 0, BackgroundColor3 = th.Glow, BackgroundTransparency = .55, Position = UDim2.new(x, 0, 0, -24), Parent = Particles })
dur = math.random(7, 11) / 10
finish = { Position = UDim2.new(x - .05, 0, 1, 24) }
elseif kind == "ember" then
local sz = math.random(2, 4)
obj = Create("Frame", { Size = UDim2.fromOffset(sz, sz), BorderSizePixel = 0, BackgroundColor3 = th.Accent, BackgroundTransparency = .3, Position = UDim2.new(x, 0, 1, 10), Parent = Particles }, { Round() })
dur = math.random(50, 80) / 10
finish = { Position = UDim2.new(x + (math.random() - .5) * .2, 0, 0, -10), BackgroundTransparency = 1 }
elseif kind == "dot" then
local sz = math.random(2, 4)
obj = Create("Frame", { Size = UDim2.fromOffset(sz, sz), BorderSizePixel = 0, BackgroundColor3 = th.Glow, BackgroundTransparency = math.random(40, 75) / 100, Position = UDim2.new(x, 0, 0, -10), Parent = Particles }, { Round() })
dur = math.random(70, 110) / 10
finish = { Position = UDim2.new(x + (math.random() - .5) * .15, 0, 1, 10) }
elseif kind == "petal" or kind == "leaf" then
local w = kind == "leaf" and math.random(6, 8) or math.random(5, 7)
obj = Create("Frame", { Size = UDim2.fromOffset(w, math.floor(w * .6)), Rotation = rot, BorderSizePixel = 0, BackgroundColor3 = math.random() < .5 and th.Accent or th.Accent2, BackgroundTransparency = .35, Position = UDim2.new(x, 0, 0, -12), Parent = Particles }, { Round() })
dur = math.random(60, 95) / 10
finish = { Position = UDim2.new(x + (math.random() - .3) * .25, 0, 1, 12), Rotation = rot + math.random(180, 540) }
else
if kind == "snow" and math.random() < .65 then
local sz = math.random(2, 4)
obj = Create("Frame", { Size = UDim2.fromOffset(sz, sz), BorderSizePixel = 0, BackgroundColor3 = WHITE, BackgroundTransparency = math.random(35, 70) / 100, Position = UDim2.new(x, 0, 0, -10), Parent = Particles }, { Round() })
else
local ic = BuildIcon(Particles, kind == "heart" and "heart" or "snowflake", math.random(9, 13), kind == "heart" and th.Accent or th.Glow, 1)
ic:SetTransparency(math.random(35, 60) / 100)
obj = ic.Frame
obj.Position = UDim2.new(x, 0, 0, -16)
obj.Rotation = rot
end
dur = math.random(65, 100) / 10
finish = { Position = UDim2.new(x + (math.random() - .5) * .18, 0, 1, 16), Rotation = rot + math.random(-120, 120) }
end
local tw = Tween(obj, dur, finish, Enum.EasingStyle.Linear)
tw.Completed:Connect(function() obj:Destroy() end)
end
task.wait((kind == "rain" and .05 or .28) / math.max(S.Density, .1))
end
end)
Connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
if visible then Scale.Scale = fitScale() * Krieg.UserScale end
end)
if S.Wallpaper ~= "" then
self:ResolveWallpaper(S.Wallpaper, function(ok, res) if ok then self:ApplyWallpaper(res) end end)
else
task.defer(function() self:PlayThemeWall(self.CurrentTheme) end)
end
if S.Font == "Custom" and S.FontCustom ~= "" then self:SetCustomFont(S.FontCustom, true) end
self.Window = Win
task.defer(show)
return Win
end
function Krieg:Destroy()
if self.Visuals and self.Visuals.destroy then pcall(self.Visuals.destroy) end
pcall(RunService.UnbindFromRenderStep, RunService, "KriegPower")
for _, c in ipairs(self.Connections) do pcall(function() c:Disconnect() end) end
self.Connections = {}
Registry, ThemeHooks, Shimmers = {}, {}, {}
if self.Gui then self.Gui:Destroy() end
end
local VIM         = game:GetService("VirtualInputManager")
local GuiService  = game:GetService("GuiService")
local function PG() return LP:FindFirstChild("PlayerGui") end
local function Path(root, ...)
local cur = root
for _, n in ipairs({ ... }) do
if not cur then return nil end
cur = cur:FindFirstChild(n)
end
return cur
end
local function Shown(o)
if not o or not o.Parent then return false end
local cur = o
while cur do
if cur:IsA("LayerCollector") then return cur.Enabled end
if cur:IsA("GuiObject") and not cur.Visible then return false end
cur = cur.Parent
end
return true
end
local function Prop(o, name)
if not o then return nil end
local v = o:GetAttribute(name)
if v ~= nil then return v end
local c = o:FindFirstChild(name)
if c and c:IsA("ValueBase") then return c.Value end
return nil
end
local G = {
SuperHUD  = function() return Path(PG(), "SuperThrowHUD") end,
Marker    = function() return Path(PG(), "ThrowSequence", "Meter", "Bar", "Marker") end,
Shine     = function() return Path(PG(), "ThrowSequence", "Meter", "Bar", "Shine") end,
TapBonus  = function() return Path(PG(), "TrainingSequence", "TapBonusLayer", "TapBonus") end,
EquipBest = function() return Path(PG(), "AnimalsPanelGui", "AnimalsPanel", "Body", "Content", "EquipBest") end,
SellList  = function() return Path(PG(), "SellShop", "SellPanel", "Body", "Content", "List") end,
}
local Places = {
Starter   = function() local a = workspace:FindFirstChild("StarterArea"); return a and (a:FindFirstChild("Start") or a) end,
Training  = function() return Path(workspace, "LocalPlotProps", "TrainingArea", "TrainingSpot") end,
Placement = function() return workspace:FindFirstChild("PlacementMarker") end,
SellPad   = function() return Path(workspace, "SellPlace", "ZonePad") end,
}
local MARKER_POS = UDim2.new(.5, 0, .02, 0)
local SHINE_POS  = UDim2.new(.1, 0, 5, 0)
local SHINE_SIZE = UDim2.new(.22, 0, 10, 0)
local Gen = {}
local function Run(key, fn)
Gen[key] = (Gen[key] or 0) + 1
local id = Gen[key]
local function alive() return Gen[key] == id and Krieg.Gui ~= nil and Krieg.Gui.Parent ~= nil end
task.spawn(fn, alive)
end
local function Stop(key) Gen[key] = (Gen[key] or 0) + 1 end
local function Sleep(t, alive)
local e = os.clock() + t
while os.clock() < e do
if alive and not alive() then return false end
task.wait(.05)
end
return not alive or alive()
end
local function WaitUntil(cond, timeout, alive)
local e = os.clock() + (timeout or math.huge)
while os.clock() < e do
if alive and not alive() then return false end
if cond() then return true end
RunService.Heartbeat:Wait()
end
return false
end
local function ClickAt(x, y)
pcall(function()
VIM:SendMouseButtonEvent(x, y, 0, true, game, 1)
task.wait(.05)
VIM:SendMouseButtonEvent(x, y, 0, false, game, 1)
end)
end
local function FreeScreenPoint()
local v = workspace.CurrentCamera.ViewportSize
local cands = {
Vector2.new(v.X * .5, v.Y * .5), Vector2.new(v.X * .5, v.Y * .9), Vector2.new(v.X * .5, v.Y * .15),
Vector2.new(v.X * .05, v.Y * .5), Vector2.new(v.X * .95, v.Y * .5),
}
local wf = Krieg.WindowFrame
if not (wf and wf.Visible) then return cands[1] end
local a, s = wf.AbsolutePosition, wf.AbsoluteSize
for _, c in ipairs(cands) do
if c.X < a.X or c.X > a.X + s.X or c.Y < a.Y or c.Y > a.Y + s.Y then return c end
end
return cands[2]
end
local function ClickScreen()
local p = FreeScreenPoint()
ClickAt(p.X, p.Y)
end
local function PressButton(b)
if not b then return false end
if not b:IsA("GuiButton") then
local d = b:FindFirstChildWhichIsA("GuiButton", true)
if d then b = d end
end
if b:IsA("GuiButton") then
if typeof(getconnections) == "function" then
for _, sig in ipairs({ b.MouseButton1Click, b.Activated, b.MouseButton1Down }) do
local ok, cons = pcall(getconnections, sig)
if ok and type(cons) == "table" and #cons > 0 then
for _, c in ipairs(cons) do pcall(function() c:Fire() end) end
return true
end
end
elseif typeof(firesignal) == "function" then
if pcall(firesignal, b.MouseButton1Click) then return true end
end
end
if b:IsA("GuiObject") then
local a, s = b.AbsolutePosition, b.AbsoluteSize
local gui = b:FindFirstAncestorWhichIsA("ScreenGui")
local inset = (gui and not gui.IgnoreGuiInset) and GuiService:GetGuiInset() or Vector2.zero
ClickAt(a.X + s.X / 2 + inset.X, a.Y + s.Y / 2 + inset.Y)
return true
end
return false
end
local function Jump()
local ok = pcall(function()
VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
task.wait(.1)
VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end)
if not ok then
local c = LP.Character
local hum = c and c:FindFirstChildOfClass("Humanoid")
if hum then hum.Jump = true end
end
end
local function Char()
local c = LP.Character
if not c then return end
return c, c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
end
local function TopPoint(target)
if typeof(target) ~= "Instance" then return nil end
local part = target:IsA("BasePart") and target or nil
if not part and target:IsA("Model") then
part = target.PrimaryPart
if not part then return target:GetPivot().Position end
end
if not part then part = target:FindFirstChildWhichIsA("BasePart", true) end
if not part then return nil end
return part.Position + Vector3.new(0, part.Size.Y / 2, 0)
end
local RAGDOLL = { Enum.HumanoidStateType.Ragdoll, Enum.HumanoidStateType.FallingDown }
local guardUntil = 0
local function StillBody(char)
for _, p in ipairs(char:GetDescendants()) do
if p:IsA("BasePart") then
p.AssemblyLinearVelocity = Vector3.zero
p.AssemblyAngularVelocity = Vector3.zero
end
end
end
local function SafeTP(target)
local char, hrp, hum = Char()
if not hrp then return false end
local cf
if typeof(target) == "CFrame" then
cf = target
else
local top = TopPoint(target)
if not top then return false end
local h = (hum and hum.RigType == Enum.HumanoidRigType.R15) and (hum.HipHeight + hrp.Size.Y / 2) or 3
cf = CFrame.new(top + Vector3.new(0, h + .25, 0)) * hrp.CFrame.Rotation
end
guardUntil = os.clock() + 1.5
if hum then
for _, s in ipairs(RAGDOLL) do pcall(hum.SetStateEnabled, hum, s, false) end
hum.Sit = false
hum.PlatformStand = false
end
StillBody(char)
hrp.Anchored = true
char:PivotTo(cf)
RunService.Heartbeat:Wait()
RunService.Heartbeat:Wait()
if hrp.Parent then
StillBody(char)
hrp.Anchored = false
end
if hum and hum.Parent then hum:ChangeState(Enum.HumanoidStateType.Running) end
task.delay(1.6, function()
if os.clock() >= guardUntil and hum and hum.Parent then
for _, s in ipairs(RAGDOLL) do pcall(hum.SetStateEnabled, hum, s, true) end
end
end)
return true
end
Connect(RunService.Heartbeat, function()
if os.clock() > guardUntil then return end
local _, hrp, hum = Char()
if hum then
local st = hum:GetState()
if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Physics then
hum:ChangeState(Enum.HumanoidStateType.GettingUp)
end
hum.PlatformStand = false
end
if hrp then
local v = hrp.AssemblyLinearVelocity
if v.Y < -35 then hrp.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z) end
end
end)
local function IsTraining()
local v = Prop(LP, "Training")
return v == true or v == 1 or v == "true"
end
local function EnsureTraining(alive)
while alive() do
if IsTraining() then return true end
for _ = 1, 3 do
if not alive() then return false end
SafeTP(Places.Training())
if WaitUntil(IsTraining, 2.5, alive) then return true end
end
SafeTP(Places.Placement())
Sleep(1, alive)
end
return false
end
local State = { Throwing = false }
local function ApplyShine()
local s = G.Shine()
if Shown(s) then
if s.Position ~= SHINE_POS then s.Position = SHINE_POS end
if s.Size ~= SHINE_SIZE then s.Size = SHINE_SIZE end
end
end
local function FarmOnce(alive)
State.Throwing = false
while alive() and not Shown(G.SuperHUD()) do
SafeTP(Places.Starter())
WaitUntil(function() return Shown(G.SuperHUD()) end, 3, alive)
end
if not alive() then return false end
State.Throwing = true
local hudAt = os.clock()
local got = WaitUntil(function()
ApplyShine()
return Shown(G.Marker())
end, 3, alive)
if not got then
State.Throwing = false
if alive() then SafeTP(Places.Starter()) end
return false
end
WaitUntil(function()
ApplyShine()
return os.clock() - hudAt >= 1.5
end, 5, alive)
if not alive() then State.Throwing = false return false end
local prev
local ready = WaitUntil(function()
ApplyShine()
local m = G.Marker()
if not Shown(m) then return false end
local x = m.Position.X.Scale
local hit = math.abs(x - .5) <= .012
or (prev ~= nil and math.abs(prev - x) < .25 and (prev - .5) * (x - .5) < 0)
prev = x
return hit and math.abs(m.Position.Y.Scale - .02) <= .05
end, 12, alive)
if not ready then
State.Throwing = false
if alive() then SafeTP(Places.Starter()) end
return false
end
ClickScreen()
local done = WaitUntil(function() return not Shown(G.SuperHUD()) end, 30, alive)
State.Throwing = false
return done
end
local SUFFIX = {
k = 3, m = 6, b = 9, t = 12, qa = 15, qd = 15, qi = 18, qn = 18, sx = 21, sp = 24, oc = 27,
no = 30, dc = 33, de = 33, ud = 36, dd = 39, td = 42, qad = 45, qid = 48, sxd = 51, spd = 54,
ocd = 57, nod = 60, vg = 63,
}
local function ParseNum(s)
if type(s) == "number" then return s end
s = tostring(s or ""):gsub("[%s,%$]", ""):gsub("/[sS]$", "")
if s == "" then return 0 end
local n = tonumber(s)
if n then return n end
local num, suf = s:match("^([%d%.]+)(%a+)$")
num = tonumber(num)
if not num then return nil end
local p = SUFFIX[suf:lower()]
return p and num * 10 ^ p or nil
end
local SellCfg = {}
local function FindRow(id)
local list = G.SellList()
if not list then return nil end
return list:FindFirstChild("Row_" .. id) or list:FindFirstChild("Row_a" .. id)
end
local function SellRow(id, alive)
local row = FindRow(id)
if not row then return false end
PressButton(Path(row, "Side", "Sell"))
local yes
WaitUntil(function()
yes = Path(row, "Confirm", "Yes")
return yes ~= nil and Shown(yes)
end, 2, alive)
if yes then PressButton(yes) end
Sleep(.35, alive)
return true
end
local SellBusy = false
local function SellPass(alive)
if SellBusy then return end
SellBusy = true
local ok, err = pcall(function()
local minInc = ParseNum(SellCfg.MinIncome and SellCfg.MinIncome.Value) or 0
if minInc <= 0 then return end
local bp = LP:FindFirstChild("Backpack")
if not bp then return end
local todo = {}
for _, it in ipairs(bp:GetChildren()) do
local id = Prop(it, "AnimalId")
local inc = ParseNum(Prop(it, "Income"))
if id ~= nil and inc then
local mut = Prop(it, "Mutation")
local hasMut = mut ~= nil and mut ~= false and mut ~= "" and tostring(mut) ~= "None"
if inc < minInc and not (SellCfg.KeepMutations.Value and hasMut) then
table.insert(todo, tostring(id))
end
end
end
if #todo == 0 then return end
local missing = {}
for _, id in ipairs(todo) do
if not alive() then return end
if not SellRow(id, alive) then table.insert(missing, id) end
end
if #missing > 0 and Places.SellPad() then
local _, hrp = Char()
local back = hrp and hrp.CFrame
SafeTP(Places.SellPad())
Sleep(1, alive)
if back then SafeTP(back) end
Sleep(1, alive)
for _, id in ipairs(missing) do
if not alive() then return end
SellRow(id, alive)
end
end
end)
SellBusy = false
if not ok then warn("[Krieg] Auto Sell:", err) end
end
local function SetPower(on)
pcall(RunService.UnbindFromRenderStep, RunService, "KriegPower")
if not on then return end
RunService:BindToRenderStep("KriegPower", Enum.RenderPriority.Last.Value + 10, function()
if not (Krieg.Gui and Krieg.Gui.Parent) then
pcall(RunService.UnbindFromRenderStep, RunService, "KriegPower")
return
end
ApplyShine()
local m = G.Marker()
if Shown(m) and m.Position ~= MARKER_POS then m.Position = MARKER_POS end
end)
end
local Ex = {}
local function Exclusive(key, on)
if not on then return end
for k, api in pairs(Ex) do
if k ~= key and api.Value then api:Set(false) end
end
end

-- Все визуальные эффекты AreVisuals без второго меню.
function Krieg:InitVisuals()
-- LocalScript -> StarterPlayer > StarterPlayerScripts
-- AreVisuals (liquid glass menu). Читаемая версия с адаптацией для телефона и ПК.
--  * тап / ЛКМ по названию  = включить / выключить функцию
--  * тап по значку ≡ (или ПКМ) = открыть настройки
--  * на телефоне: вкладки и прокручиваемые карточки; на ПК: круговое меню
--  * заголовок панели на ПК = перетаскивание
--  * кнопка "Menu" сверху или RightShift = показать / скрыть меню

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--------------------------------------------------------------------
-- ТЕМА / ХЕЛПЕРЫ
--------------------------------------------------------------------
local ACCENT = Color3.fromRGB(72, 226, 192)
local DARK = Color3.fromRGB(16, 20, 24)
local WHITE = Color3.new(1, 1, 1)
local MENU_KEY = Enum.KeyCode.RightShift

local menuOpen = true
local blur
local BLUR_SIZE = 16
local StreamerMod
local shownName = function()
	return player.Name
end

-- смена акцентного цвета "на лету"
local accentCbs = {}
local function onAccent(fn)
	table.insert(accentCbs, fn)
	fn()
end
local function setAccent(c)
	ACCENT = c
	for _, f in ipairs(accentCbs) do
		pcall(f)
	end
end
local function rowOnColor()
	return Color3.new(ACCENT.R * 0.64, ACCENT.G * 0.885, ACCENT.B * 0.9)
end
local function rgbStr(c)
	return string.format("rgb(%d,%d,%d)", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

local FONT_REG = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local FONT_BOLD = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do
		o[k] = v
	end
	if parent then
		o.Parent = parent
	end
	return o
end

local function tw(obj, t, props, style, dir)
	local tween = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	tween:Play()
	return tween
end

local function corner(parent, r)
	return new("UICorner", {CornerRadius = UDim.new(0, r)}, parent)
end

-- блик по краю: "жидкое стекло"
local function edge(parent, thickness, transparency)
	local s = new("UIStroke", {
		Color = WHITE,
		Thickness = thickness or 1.2,
		Transparency = transparency or 0.4,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, parent)
	new("UIGradient", {
		Rotation = 35,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.45, 0.85),
			NumberSequenceKeypoint.new(0.55, 0.85),
			NumberSequenceKeypoint.new(1, 0.1),
		}),
	}, s)
	return s
end

-- liquid glass: полупрозрачная заливка + градиент + блик сверху (без обводки)
local function glassStyle(frame)
	frame.BackgroundColor3 = Color3.fromRGB(140, 172, 198)
	frame.BackgroundTransparency = 0.5
	new("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(150, 185, 215)),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.05),
			NumberSequenceKeypoint.new(0.55, 0.3),
			NumberSequenceKeypoint.new(1, 0.15),
		}),
	}, frame)
	local hl = new("Frame", {
		Size = UDim2.new(1, -10, 0.46, 0),
		Position = UDim2.fromOffset(5, 2),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.7,
		BorderSizePixel = 0,
		Active = false,
	}, frame)
	new("UICorner", {CornerRadius = UDim.new(1, 0)}, hl)
	new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(0.15, 1)}, hl)
end

local function text(parent, str, size, props)
	local l = new("TextLabel", {
		BackgroundTransparency = 1,
		Text = str,
		TextSize = size,
		FontFace = FONT_REG,
		TextColor3 = Color3.fromRGB(235, 240, 242),
		TextXAlignment = Enum.TextXAlignment.Left,
		BorderSizePixel = 0,
	}, nil)
	for k, v in pairs(props or {}) do
		l[k] = v
	end
	l.Parent = parent
	return l
end

local function isPress(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

local function fadeGroup(g, on)
	if on then
		g.Visible = true
		tw(g, 0.3, {GroupTransparency = 0})
	else
		local t = tw(g, 0.3, {GroupTransparency = 1})
		t.Completed:Connect(function()
			if g.GroupTransparency >= 0.99 then
				g.Visible = false
			end
		end)
	end
end

-- единый менеджер перетаскивания (мышь + палец)
local activeMove, activeEnd, activeScroller
local function startDrag(onMove, onEnd, scroller)
	activeMove, activeEnd, activeScroller = onMove, onEnd, scroller
	if scroller then
		scroller.ScrollingEnabled = false
	end
end
UIS.InputChanged:Connect(function(i)
	if activeMove and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		activeMove(i.Position)
	end
end)
UIS.InputEnded:Connect(function(i)
	if activeMove and isPress(i) then
		local e, s = activeEnd, activeScroller
		activeMove, activeEnd, activeScroller = nil, nil, nil
		if s then
			s.ScrollingEnabled = true
		end
		if e then
			e()
		end
	end
end)

--------------------------------------------------------------------
-- МОДУЛИ (данные)
--------------------------------------------------------------------
local modules = {}
local refreshKeybinds = function() end

local function Module(cfg)
	local m = {
		name = cfg.name,
		key = cfg.key,
		noToggle = cfg.noToggle,
		noBind = cfg.noBind,
		statusFns = {},
		enabled = false,
		v = {},
		settings = cfg.settings or {},
		onToggle = cfg.onToggle or function() end,
		onChange = cfg.onChange or function() end,
	}
	for _, s in ipairs(m.settings) do
		m.v[s.name] = s.default
	end
	function m.changed(name, value)
		m.v[name] = value
		m.onChange(name, value)
	end
	function m.setStatus(name, str, color)
		local f = m.statusFns[name]
		if f then
			f(str, color)
		end
	end
	table.insert(modules, m)
	return m
end

local function setEnabled(mod, on)
	if mod.enabled == on then
		return
	end
	mod.enabled = on
	if mod.setVisual then
		mod.setVisual(on)
	end
	mod.onToggle(on)
	refreshKeybinds()
end

--------------------------------------------------------------------
-- HUD (watermark / keybinds)
--------------------------------------------------------------------
local hud = new("ScreenGui", {Name = "AreVisualsHUD", ResetOnSpawn = false, DisplayOrder = 5, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, playerGui)

--------------------------------------------------------------------
-- SCREEN: ASPECT RATIO
--------------------------------------------------------------------
-- Ratio = Resolution из твоего кода: 1 = нормально, меньше = сильнее растяжение
local aspect = {cur = 1}

local AspectMod = Module({
	name = "Aspect Ratio",
	key = Enum.KeyCode.Z,
	settings = {
		{type = "slider", name = "Ratio", min = 0, max = 1, step = 0.01, default = 0.65},
	},
})

-- как в твоём коде: Camera.CFrame * CFrame.new(0,0,0, 1,0,0, 0,Resolution,0, 0,0,1)
-- Resolution = значение слайдера (1 = нормально), плавно подъезжает к нужному значению
RunService.RenderStepped:Connect(function(dt)
	local cam = workspace.CurrentCamera
	if not cam then
		return
	end
	local want = AspectMod.enabled and math.max(AspectMod.v.Ratio, 0.05) or 1
	aspect.cur += (want - aspect.cur) * (1 - math.exp(-dt * 9))
	if math.abs(aspect.cur - 1) > 0.002 then
		cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, aspect.cur, 0, 0, 0, 1)
	end
end)

--------------------------------------------------------------------
-- SCREEN: WATERMARK  (AV nick fps time)
--------------------------------------------------------------------
local wmAccent = ACCENT
local wm = new("CanvasGroup", {
	Name = "Watermark",
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 8),
	Size = UDim2.fromOffset(180, 32),
	BackgroundColor3 = DARK,
	BackgroundTransparency = 0.38,
	BorderSizePixel = 0,
	GroupTransparency = 1,
	Visible = false,
}, hud)
new("UICorner", {CornerRadius = UDim.new(0, 12)}, wm)
new("UIGradient", {Rotation = 60, Transparency = NumberSequence.new(0, 0.3)}, wm)
local wmLabel = text(wm, "", 13, {
	Size = UDim2.fromScale(1, 1),
	RichText = true,
	FontFace = FONT_BOLD,
	TextXAlignment = Enum.TextXAlignment.Center,
	TextColor3 = WHITE,
	ZIndex = 5,
})
wmLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
	wm.Size = UDim2.fromOffset(math.ceil(wmLabel.TextBounds.X) + 40, 32)
end)

local WatermarkMod
WatermarkMod = Module({
	name = "Watermark",
	key = Enum.KeyCode.X,
	settings = {
		{type = "toggle", name = "Nick", default = true},
		{type = "toggle", name = "FPS", default = true},
		{type = "toggle", name = "Time", default = true},
	},
	onToggle = function(on)
		fadeGroup(wm, on)
	end,
})

do
	local fps, acc = 60, 1
	RunService.RenderStepped:Connect(function(dt)
		fps += (1 / math.max(dt, 1e-4) - fps) * 0.08
		acc += dt
		if acc < 0.25 or not WatermarkMod.enabled then
			return
		end
		acc = 0
		local parts = {string.format('<font color="%s">NK</font>', rgbStr(wmAccent))}
		if WatermarkMod.v.Nick then
			table.insert(parts, shownName())
		end
		if WatermarkMod.v.FPS then
			table.insert(parts, math.floor(fps + 0.5) .. " fps")
		end
		if WatermarkMod.v.Time then
			table.insert(parts, os.date("%H:%M"))
		end
		wmLabel.Text = table.concat(parts, '  <font transparency="0.65">\u{2022}</font>  ')
	end)
end

--------------------------------------------------------------------
-- SCREEN: KEYBINDS
--------------------------------------------------------------------
local kbAccent = ACCENT
local kb = new("CanvasGroup", {
	Name = "Keybinds",
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 12, 0.5, 0),
	Size = UDim2.fromOffset(170, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundColor3 = DARK,
	BackgroundTransparency = 0.4,
	BorderSizePixel = 0,
	GroupTransparency = 1,
	Visible = false,
}, hud)
corner(kb, 12)
edge(kb, 1.2, 0.4)
new("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)}, kb)
new("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, kb)
text(kb, "Keybinds", 14, {Size = UDim2.new(1, 0, 0, 18), FontFace = FONT_BOLD, LayoutOrder = 0})

local KeybindsMod = Module({
	name = "Keybinds",
	key = Enum.KeyCode.C,
	settings = {
		{type = "toggle", name = "Only active", default = false},
	},
	onToggle = function(on)
		fadeGroup(kb, on)
	end,
	onChange = function()
		refreshKeybinds()
	end,
})

refreshKeybinds = function()
	for _, c in ipairs(kb:GetChildren()) do
		if c.Name == "Row" then
			c:Destroy()
		end
	end
	local order = 1
	for _, m in ipairs(modules) do
		if m.key and (m.enabled or not KeybindsMod.v["Only active"]) then
			local row = new("Frame", {Name = "Row", Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, LayoutOrder = order}, kb)
			local col = m.enabled and kbAccent or Color3.fromRGB(190, 197, 200)
			text(row, m.name, 12, {Size = UDim2.new(1, -40, 1, 0), TextColor3 = col, TextTruncate = Enum.TextTruncate.AtEnd})
			text(row, "[" .. m.key.Name .. "]", 12, {Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(1, -40, 0, 0), TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = col})
			order += 1
		end
	end
end

--------------------------------------------------------------------
-- SCREEN: CUSTOM CURSOR (DOT)  - по твоему коду: точка вместо курсора + шифтлок отключён
--------------------------------------------------------------------
local ContextActionService = game:GetService("ContextActionService")
local cursorGui = new("ScreenGui", {Name = "AreVisualsCursor", IgnoreGuiInset = true, ResetOnSpawn = false, DisplayOrder = 999999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, playerGui)
local dot = new("Frame", {
	Name = "Dot",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.fromOffset(6, 6),
	BackgroundColor3 = WHITE,
	BorderSizePixel = 0,
	Active = false,
	Visible = false,
}, cursorGui)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, dot)
local dotStroke = new("UIStroke", {Color = Color3.new(0, 0, 0), Thickness = 1, Transparency = 0.6}, dot)

local cursor = {conn = nil, mouseLockWas = nil}
local CursorMod = Module({
	name = "Custom Cursor",
	key = Enum.KeyCode.V,
	settings = {
		{type = "slider", name = "Size", min = 2, max = 20, step = 1, default = 6},
		{type = "color", name = "Color", default = WHITE},
		{type = "toggle", name = "Outline", default = true},
	},
	onToggle = function(on)
		dot.Visible = on
		if cursor.conn then
			cursor.conn:Disconnect()
			cursor.conn = nil
		end
		if on then
			-- отключаем шифтлок
			pcall(function()
				cursor.mouseLockWas = player.DevEnableMouseLock
				player.DevEnableMouseLock = false
			end)
			ContextActionService:BindActionAtPriority(
				"AreVisualsBlockShiftLock",
				function()
					return Enum.ContextActionResult.Sink
				end,
				false,
				Enum.ContextActionPriority.High.Value + 100,
				Enum.KeyCode.LeftShift,
				Enum.KeyCode.RightShift
			)
			cursor.conn = RunService.RenderStepped:Connect(function()
				UIS.MouseIconEnabled = false
				local pos
				if UIS.MouseEnabled then
					pos = UIS:GetMouseLocation()
				else
					local cam = workspace.CurrentCamera
					pos = cam and (cam.ViewportSize / 2) or Vector2.new(0, 0)
				end
				dot.Position = UDim2.fromOffset(pos.X, pos.Y)
			end)
		else
			ContextActionService:UnbindAction("AreVisualsBlockShiftLock")
			pcall(function()
				if cursor.mouseLockWas ~= nil then
					player.DevEnableMouseLock = cursor.mouseLockWas
				end
			end)
			UIS.MouseIconEnabled = true
		end
	end,
	onChange = function(name, value)
		if name == "Size" then
			dot.Size = UDim2.fromOffset(value, value)
		elseif name == "Color" then
			dot.BackgroundColor3 = value
		elseif name == "Outline" then
			dotStroke.Enabled = value
		end
	end,
})

--------------------------------------------------------------------
-- WORLD: WEATHER MOODS
--------------------------------------------------------------------
local WEATHERS = {
	{name = "Clear",  clock = 14,   bright = 2.2, exposure = 0,    dens = 0.25, offset = 0,    haze = 0, glare = 0, atmo = Color3.fromRGB(199, 215, 235), sat = 0.05,  rain = 0},
	{name = "Rain",   clock = 16,   bright = 1.2, exposure = -0.3, dens = 0.45, offset = 0.15, haze = 2, glare = 0, atmo = Color3.fromRGB(140, 150, 165), sat = -0.2,  rain = 90},
	{name = "Storm",  clock = 17.5, bright = 0.6, exposure = -0.6, dens = 0.55, offset = 0.2,  haze = 3, glare = 0, atmo = Color3.fromRGB(90, 95, 110),   sat = -0.3,  rain = 220, storm = true},
	{name = "Fog",    clock = 12,   bright = 1.5, exposure = -0.2, dens = 0.8,  offset = 0.3,  haze = 4, glare = 0, atmo = Color3.fromRGB(200, 205, 210), sat = -0.35, rain = 0},
	{name = "Sunset", clock = 18.1, bright = 2,   exposure = 0,    dens = 0.35, offset = 0.1,  haze = 2, glare = 1, atmo = Color3.fromRGB(255, 170, 120), sat = 0.2,   rain = 0},
}

local weather = {idx = 1, color = WHITE, snap = nil, atmo = nil, atmoCreated = false, cc = nil, tweens = {}, token = 0, flashToken = 0}
local rainTarget = 0

local function cancelWeatherTweens()
	for _, t in ipairs(weather.tweens) do
		t:Cancel()
	end
	weather.tweens = {}
end

local function weatherProps()
	local w = WEATHERS[weather.idx]
	local c = weather.color
	return w,
		{ClockTime = w.clock, Brightness = w.bright, ExposureCompensation = w.exposure},
		{Density = w.dens, Offset = w.offset, Haze = w.haze, Glare = w.glare, Color = Color3.new(w.atmo.R * c.R, w.atmo.G * c.G, w.atmo.B * c.B)},
		{TintColor = c, Saturation = w.sat}
end

local function flashLoop()
	weather.flashToken += 1
	local my = weather.flashToken
	if not (WEATHERS[weather.idx].storm and weather.cc) then
		return
	end
	task.spawn(function()
		while weather.flashToken == my do
			task.wait(math.random(40, 90) / 10)
			if weather.flashToken ~= my or not weather.cc then
				break
			end
			for _ = 1, math.random(1, 2) do
				weather.cc.Brightness = 0.45
				tw(weather.cc, 0.5, {Brightness = 0}, Enum.EasingStyle.Sine)
				task.wait(0.22)
			end
		end
	end)
end

local function applyWeather(smooth)
	if not weather.cc then
		return
	end
	local w, lp, ap, cp = weatherProps()
	cancelWeatherTweens()
	rainTarget = w.rain
	if smooth then
		local info = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		for _, pair in ipairs({{Lighting, lp}, {weather.atmo, ap}, {weather.cc, cp}}) do
			local t = TweenService:Create(pair[1], info, pair[2])
			t:Play()
			table.insert(weather.tweens, t)
		end
	else
		for k, v in pairs(lp) do
			Lighting[k] = v
		end
		for k, v in pairs(ap) do
			weather.atmo[k] = v
		end
		for k, v in pairs(cp) do
			weather.cc[k] = v
		end
	end
	flashLoop()
end

local WeatherMod = Module({
	name = "Weather Moods",
	key = Enum.KeyCode.B,
	settings = {
		{type = "list", name = "Weather", options = {"Clear", "Rain", "Storm", "Fog", "Sunset"}, default = 1},
		{type = "color", name = "Color", default = WHITE},
	},
	onToggle = function(on)
		weather.token += 1
		local my = weather.token
		if on then
			weather.snap = {
				ClockTime = Lighting.ClockTime,
				Brightness = Lighting.Brightness,
				ExposureCompensation = Lighting.ExposureCompensation,
			}
			local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
			weather.atmoCreated = false
			if atmo then
				weather.atmoSnap = {Density = atmo.Density, Offset = atmo.Offset, Haze = atmo.Haze, Glare = atmo.Glare, Color = atmo.Color}
			else
				atmo = new("Atmosphere", {Name = "VisualsAtmosphere", Density = 0, Offset = 0, Haze = 0, Glare = 0}, Lighting)
				weather.atmoCreated = true
				weather.atmoSnap = nil
			end
			weather.atmo = atmo
			weather.cc = new("ColorCorrectionEffect", {Name = "VisualsWeatherCC"}, Lighting)
			applyWeather(true)
		else
			weather.flashToken += 1
			cancelWeatherTweens()
			rainTarget = 0
			local cc, atmo = weather.cc, weather.atmo
			if cc then
				local info = TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				TweenService:Create(Lighting, info, weather.snap):Play()
				TweenService:Create(cc, info, {TintColor = WHITE, Saturation = 0, Brightness = 0}):Play()
				if atmo then
					if weather.atmoCreated then
						TweenService:Create(atmo, info, {Density = 0, Haze = 0, Glare = 0, Offset = 0}):Play()
					elseif weather.atmoSnap then
						TweenService:Create(atmo, info, weather.atmoSnap):Play()
					end
				end
				local created = weather.atmoCreated
				task.delay(1.5, function()
					if weather.token ~= my then
						return
					end
					cc:Destroy()
					if created and atmo then
						atmo:Destroy()
					end
					weather.cc, weather.atmo = nil, nil
				end)
			end
		end
	end,
	onChange = function(name, value)
		if name == "Weather" then
			weather.idx = value
			applyWeather(true)
		elseif name == "Color" then
			weather.color = value
			applyWeather(false)
		end
	end,
})

-- дождь (3D, капли живут в мире вокруг камеры)
do
	local RAIN_MAX, RAIN_R, RAIN_H = 260, 34, 30
	local folder
	local parts, pos = {}, {}
	local count = 0
	local tilt = CFrame.Angles(0, 0, math.rad(8))

	RunService.RenderStepped:Connect(function(dt)
		count += (rainTarget - count) * (1 - math.exp(-dt * 2))
		local n = math.floor(count + 0.5)
		if n == 0 and not folder then
			return
		end
		local cam = workspace.CurrentCamera
		if not cam then
			return
		end
		if not folder then
			folder = new("Folder", {Name = "AreVisualsRain"}, workspace)
			for i = 1, RAIN_MAX do
				parts[i] = new("Part", {
					Anchored = true,
					CanCollide = false,
					CanQuery = false,
					CanTouch = false,
					CastShadow = false,
					Material = Enum.Material.Neon,
					Color = Color3.fromRGB(190, 210, 235),
					Transparency = 0.45,
					Size = Vector3.new(0.06, 1.6, 0.06),
					CFrame = CFrame.new(0, -1e4, 0),
				}, folder)
			end
		end

		local c = cam.CFrame.Position
		local speed = WEATHERS[weather.idx].storm and 85 or 65
		local list, cfs = {}, {}
		for i = 1, RAIN_MAX do
			local p = pos[i]
			if i <= n then
				if not p then
					p = Vector3.new(c.X + (math.random() * 2 - 1) * RAIN_R, c.Y + math.random() * RAIN_H - 8, c.Z + (math.random() * 2 - 1) * RAIN_R)
				else
					p += Vector3.new(speed * 0.14 * dt, -speed * dt, 0)
					local dx, dz = p.X - c.X, p.Z - c.Z
					if dx > RAIN_R then p -= Vector3.new(2 * RAIN_R, 0, 0) elseif dx < -RAIN_R then p += Vector3.new(2 * RAIN_R, 0, 0) end
					if dz > RAIN_R then p -= Vector3.new(0, 0, 2 * RAIN_R) elseif dz < -RAIN_R then p += Vector3.new(0, 0, 2 * RAIN_R) end
					if p.Y < c.Y - 10 then
						p = Vector3.new(c.X + (math.random() * 2 - 1) * RAIN_R, c.Y + RAIN_H * (0.5 + math.random() * 0.5), c.Z + (math.random() * 2 - 1) * RAIN_R)
					end
				end
				pos[i] = p
				table.insert(list, parts[i])
				table.insert(cfs, CFrame.new(p) * tilt)
			elseif p then
				pos[i] = nil
				parts[i].CFrame = CFrame.new(0, -1e4, 0)
			end
		end
		if #list > 0 then
			workspace:BulkMoveTo(list, cfs, Enum.BulkMoveMode.FireCFrameChanged)
		end
		if n == 0 then
			folder:Destroy()
			folder, parts, pos = nil, {}, {}
		end
	end)
end

--------------------------------------------------------------------
-- WORLD: SNOW
--------------------------------------------------------------------
local snow = {part = nil, emitter = nil, conn = nil}

local SnowMod
SnowMod = Module({
	name = "Snow",
	key = Enum.KeyCode.N,
	settings = {
		{type = "slider", name = "Count", min = 0, max = 1500, step = 25, default = 500},
		{type = "color", name = "Color", default = WHITE},
	},
	onToggle = function(on)
		if snow.conn then
			snow.conn:Disconnect()
			snow.conn = nil
		end
		if on then
			local part = new("Part", {
				Name = "VisualsSnow",
				Anchored = true,
				CanCollide = false,
				CanQuery = false,
				CanTouch = false,
				CastShadow = false,
				Transparency = 1,
				Size = Vector3.new(80, 44, 80),
			}, workspace)
			local em = new("ParticleEmitter", {
				Rate = SnowMod.v.Count / 9,
				Lifetime = NumberRange.new(8, 10),
				Speed = NumberRange.new(5, 8),
				SpreadAngle = Vector2.new(15, 15),
				EmissionDirection = Enum.NormalId.Bottom,
				Size = NumberSequence.new(0.35),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.1, 0.15),
					NumberSequenceKeypoint.new(0.85, 0.15),
					NumberSequenceKeypoint.new(1, 1),
				}),
				LightEmission = 0.35,
				LightInfluence = 0,
				Color = ColorSequence.new(SnowMod.v.Color),
				Rotation = NumberRange.new(0, 360),
				RotSpeed = NumberRange.new(-60, 60),
				Acceleration = Vector3.new(1.2, 0, 0.6),
				Enabled = SnowMod.v.Count > 0,
			}, part)
			pcall(function()
				em.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
			end)
			snow.part, snow.emitter = part, em
			snow.conn = RunService.RenderStepped:Connect(function()
				local cam = workspace.CurrentCamera
				if cam then
					part.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, 14, 0))
				end
			end)
		elseif snow.part then
			snow.emitter.Enabled = false
			Debris:AddItem(snow.part, 10) -- снежинки доживают в мире
			snow.part, snow.emitter = nil, nil
		end
	end,
	onChange = function(name, value)
		if not snow.emitter then
			return
		end
		if name == "Count" then
			snow.emitter.Rate = value / 9
			snow.emitter.Enabled = value > 0
		elseif name == "Color" then
			snow.emitter.Color = ColorSequence.new(value)
		end
	end,
})

--------------------------------------------------------------------
-- WORLD: JUMP CIRCLES (твой код)
--------------------------------------------------------------------
local LIFETIME = 1.5
local FADE_IN = 0.2
local PART_SIZE = 14
local START_SCALE = 0.18
local END_SCALE = 0.5
local MAX_ALPHA = 0.35

local JumpMod

-- стиль 2 (как в старых майнкрафт-читах): тонкие внутренний и внешний круги,
-- между ними по кругу AREVISUALS. Всё появляется сразу (без анимации), в конце плавно гаснет.
local function createTextRing(position)
	local COLOR = JumpMod.v.Color
	local DUR = 1.8
	local FADE_AT = DUR - 0.8
	local FULL = PART_SIZE * 50 -- размер SurfaceGui в пикселях
	local C = FULL / 2
	local D_IN, D_OUT = FULL * 0.32, FULL * 0.52

	local part = Instance.new("Part")
	part.Name = "JumpCircleText"
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Transparency = 1
	part.Size = Vector3.new(PART_SIZE, 0.05, PART_SIZE)
	part.CFrame = CFrame.new(position + Vector3.new(0, 0.06, 0))

	local sg = Instance.new("SurfaceGui")
	sg.Face = Enum.NormalId.Top
	sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	sg.PixelsPerStud = 50
	sg.LightInfluence = 0
	sg.AlwaysOnTop = false
	sg.Parent = part

	local root = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(FULL, FULL),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, sg)
	part.Parent = workspace

	local fadeOut = TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

	local function ring(diameter, thickness, alpha)
		local f = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(diameter, diameter),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, root)
		new("UICorner", {CornerRadius = UDim.new(1, 0)}, f)
		local st = new("UIStroke", {Color = COLOR, Thickness = thickness, Transparency = alpha, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, f)
		task.delay(FADE_AT, function()
			TweenService:Create(st, fadeOut, {Transparency = 1}):Play()
		end)
	end
	ring(D_IN, 2, 0.1)
	ring(D_IN, 7, 0.78)
	ring(D_OUT, 2, 0.1)
	ring(D_OUT, 7, 0.78)

	-- текст по кругу между кольцами
	local word = "NK KRIEGHUB "
	local rMid = (D_IN + D_OUT) / 4
	local fontPx = 36
	local slots = math.floor(2 * math.pi * rMid / (fontPx * 0.95))
	local N = math.max(1, math.floor(slots / #word)) * #word
	for i = 0, N - 1 do
		local ch = word:sub(i % #word + 1, i % #word + 1)
		if ch ~= " " then
			local ang = (i / N) * 2 * math.pi
			local lbl = new("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(fontPx, fontPx),
				Position = UDim2.fromOffset(C + rMid * math.sin(ang), C - rMid * math.cos(ang)),
				Rotation = math.deg(ang),
				BackgroundTransparency = 1,
				Text = ch,
				TextSize = fontPx,
				Font = Enum.Font.Michroma,
				TextColor3 = COLOR,
				TextTransparency = 0.05,
				TextStrokeColor3 = COLOR,
				TextStrokeTransparency = 0.8,
				BorderSizePixel = 0,
			}, root)
			task.delay(FADE_AT, function()
				TweenService:Create(lbl, fadeOut, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
			end)
		end
	end

	Debris:AddItem(part, DUR + 0.2)
end

local function createCircle(position)
	if JumpMod.v.Style == 2 then
		return createTextRing(position)
	end
	local COLOR = JumpMod.v.Color
	local part = Instance.new("Part")
	part.Name = "JumpCircle"
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Transparency = 1
	part.Size = Vector3.new(PART_SIZE, 0.05, PART_SIZE)
	part.CFrame = CFrame.new(position + Vector3.new(0, 0.06, 0))

	local sg = Instance.new("SurfaceGui")
	sg.Face = Enum.NormalId.Top
	sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	sg.PixelsPerStud = 50
	sg.LightInfluence = 0
	sg.AlwaysOnTop = false
	sg.Parent = part

	local function makeLayer(strokeThickness)
		local frame = Instance.new("Frame")
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Position = UDim2.fromScale(0.5, 0.5)
		frame.Size = UDim2.fromScale(START_SCALE, START_SCALE)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Parent = sg

		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(1, 0)
		c.Parent = frame

		local stroke = Instance.new("UIStroke")
		stroke.Color = COLOR
		stroke.Thickness = strokeThickness
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Transparency = 1
		stroke.Parent = frame

		return frame, stroke
	end

	local main, mainStroke = makeLayer(4)
	local glow1, glowStroke1 = makeLayer(14)
	local glow2, glowStroke2 = makeLayer(28)

	part.Parent = workspace

	local grow = TweenInfo.new(LIFETIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local fadeIn = TweenInfo.new(FADE_IN, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local fadeOut = TweenInfo.new(LIFETIME - FADE_IN, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

	local layers = {
		{main, mainStroke, MAX_ALPHA},
		{glow1, glowStroke1, MAX_ALPHA + 0.45},
		{glow2, glowStroke2, MAX_ALPHA + 0.58},
	}

	for _, l in ipairs(layers) do
		local frame, stroke, alpha = l[1], l[2], l[3]
		TweenService:Create(frame, grow, {Size = UDim2.fromScale(END_SCALE, END_SCALE)}):Play()
		local tIn = TweenService:Create(stroke, fadeIn, {Transparency = alpha})
		tIn:Play()
		tIn.Completed:Connect(function()
			TweenService:Create(stroke, fadeOut, {Transparency = 1}):Play()
		end)
	end

	Debris:AddItem(part, LIFETIME + 0.1)
end

JumpMod = Module({
	name = "Jump Circles",
	key = Enum.KeyCode.M,
	settings = {
		{type = "list", name = "Style", options = {"Classic", "AreVisuals"}, default = 1},
		{type = "color", name = "Color", default = WHITE},
	},
})

local function onCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")
	local root = character:WaitForChild("HumanoidRootPart")
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = {character}
	humanoid.StateChanged:Connect(function(_, newState)
		if JumpMod.enabled and newState == Enum.HumanoidStateType.Jumping then
			local result = workspace:Raycast(root.Position, Vector3.new(0, -12, 0), rayParams)
			if result then
				createCircle(result.Position)
			end
		end
	end)
end
if player.Character then
	task.spawn(onCharacter, player.Character)
end
player.CharacterAdded:Connect(onCharacter)

--------------------------------------------------------------------
-- WORLD: SKYBOX
--------------------------------------------------------------------
local SKYBOXES = {
	{name = "Default", faces = {
		Bk = "rbxasset://textures/sky/sky512_bk.tex", Dn = "rbxasset://textures/sky/sky512_dn.tex",
		Ft = "rbxasset://textures/sky/sky512_ft.tex", Lf = "rbxasset://textures/sky/sky512_lf.tex",
		Rt = "rbxasset://textures/sky/sky512_rt.tex", Up = "rbxasset://textures/sky/sky512_up.tex",
	}},
}
-- addSky(имя, Bk, Dn, Ft, Lf, Rt, Up)  — сюда можно добавлять свои скайбоксы (ID картинок)
local function addSky(name, bk, dn, ft, lf, rt, up)
	local function id(n)
		return "rbxassetid://" .. n
	end
	table.insert(SKYBOXES, {
		name = tostring(#SKYBOXES), -- нумерация: 1, 2, 3...
		preview = "rbxthumb://type=Asset&id=" .. ft .. "&w=150&h=150",
		faces = {Bk = id(bk), Dn = id(dn), Ft = id(ft), Lf = id(lf), Rt = id(rt), Up = id(up)},
	})
end
addSky("Sky 1", 144933338, 144931530, 144933262, 144933244, 144933299, 144931564)
addSky("Sky 2", 2570432999, 2570433005, 2570432998, 2570433000, 2570432997, 2570432996)
addSky("Night", 151165214, 151165197, 151165224, 151165191, 151165206, 151165227)
addSky("Sky 4", 225469345, 225469349, 225469359, 225469364, 225469372, 225469380)
addSky("Red", 1012890, 1012891, 1012887, 1012889, 1012888, 1014449)
addSky("Sunset", 323494035, 323494368, 323494130, 323494252, 323494067, 323493360)

local skyState = {sky = nil, hidden = {}}
local SkyMod
local function applySky()
	if not SkyMod.enabled then
		return
	end
	if skyState.sky then
		skyState.sky:Destroy()
		skyState.sky = nil
	end
	local def = SKYBOXES[SkyMod.v.Sky]
	local sky = Instance.new("Sky")
	sky.Name = "AreVisualsSky"
	for k, v in pairs(def.faces) do
		sky["Skybox" .. k] = v
	end
	sky.Parent = Lighting -- parent последним, чтобы текстуры подхватились
	skyState.sky = sky
end

SkyMod = Module({
	name = "Skybox",
	key = Enum.KeyCode.J,
	settings = {
		{type = "gallery", name = "Sky", items = SKYBOXES, default = 2},
	},
	onToggle = function(on)
		if on then
			for _, c in ipairs(Lighting:GetChildren()) do
				if c:IsA("Sky") then
					table.insert(skyState.hidden, c)
					c.Parent = nil
				end
			end
			applySky()
		else
			if skyState.sky then
				skyState.sky:Destroy()
				skyState.sky = nil
			end
			for _, c in ipairs(skyState.hidden) do
				c.Parent = Lighting
			end
			skyState.hidden = {}
		end
	end,
	onChange = function()
		applySky()
	end,
})

--------------------------------------------------------------------
-- PLAYER: SELF CHAMS
--------------------------------------------------------------------
local skinGhost
local chams = {hl = nil, saved = {}, hue = 0, acc = 0}
local ChamsMod

local function chamsClearParts()
	for part, st in pairs(chams.saved) do
		if part.Parent then
			part.Material = st.m
			part.Color = st.c
		end
	end
	chams.saved = {}
end

local function chamsApply()
	local char = skinGhost or player.Character
	if not char or not ChamsMod.enabled then
		return
	end
	local mode, color = ChamsMod.v.Mode, ChamsMod.v.Color
	if mode == 1 then -- ForceField
		if chams.hl then
			chams.hl:Destroy()
			chams.hl = nil
		end
		for _, d in ipairs(char:GetDescendants()) do
			if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
				if not chams.saved[d] then
					chams.saved[d] = {m = d.Material, c = d.Color}
				end
				if d.Material ~= Enum.Material.ForceField or d.Color ~= color then
					d.Material = Enum.Material.ForceField
					d.Color = color
				end
			end
		end
	else -- Flat / Chromatic (Highlight)
		chamsClearParts()
		if not chams.hl or chams.hl.Parent ~= char then
			if chams.hl then
				chams.hl:Destroy()
			end
			chams.hl = new("Highlight", {Name = "AreVisualsChams", Adornee = char, DepthMode = Enum.HighlightDepthMode.Occluded}, char)
		end
		if mode == 2 then
			chams.hl.FillColor = color
			chams.hl.FillTransparency = 0
			chams.hl.OutlineTransparency = 1
		else
			chams.hl.FillTransparency = 0.2
			chams.hl.OutlineColor = WHITE
			chams.hl.OutlineTransparency = 0.2
		end
	end
end

ChamsMod = Module({
	name = "Self Chams",
	key = Enum.KeyCode.K,
	settings = {
		{type = "list", name = "Mode", options = {"ForceField", "Flat", "Chromatic"}, default = 1},
		{type = "color", name = "Color", default = ACCENT},
	},
	onToggle = function(on)
		if on then
			chamsApply()
		else
			chamsClearParts()
			if chams.hl then
				chams.hl:Destroy()
				chams.hl = nil
			end
		end
	end,
	onChange = function()
		chamsApply()
	end,
})

RunService.Heartbeat:Connect(function(dt)
	if not ChamsMod.enabled then
		return
	end
	chams.acc += dt
	if ChamsMod.v.Mode == 3 and chams.hl then
		chams.hue = (chams.hue + dt * 0.25) % 1
		chams.hl.FillColor = Color3.fromHSV(chams.hue, 0.9, 1)
	end
	if chams.acc > 0.5 then
		chams.acc = 0
		chamsApply()
	end
end)
player.CharacterAdded:Connect(function()
	task.wait(1)
	chams.saved = {}
	chams.hl = nil
	chamsApply()
end)

--------------------------------------------------------------------
-- PLAYER: PETS (питомцы бегут за игроком с задержкой, на месте стоят справа)
--------------------------------------------------------------------
local InsertService = game:GetService("InsertService")
local PET_DEFS = {
	{key = "Pig", id = 10081806634, height = 1.7},
	{key = "Tortoise", id = 9408387677, height = 1.1},
}
local pets = {list = {}, folder = nil, conn = nil, loading = {}, move = 0, t = 0, dir = Vector3.new(0, 0, -1)}
local PetsMod
local petRay = RaycastParams.new()
petRay.FilterType = Enum.RaycastFilterType.Exclude

local function petPart(model, size, color, cf, shape)
	local p = Instance.new("Part")
	p.Size = size
	p.Color = color
	p.Material = Enum.Material.SmoothPlastic
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	if shape then
		p.Shape = shape
	end
	p.CFrame = cf
	p.Parent = model
	return p
end

-- запасная модель, если ассет не удалось загрузить из клиента
local function petFallback(key)
	local m = Instance.new("Model")
	m.Name = key
	if key == "Pig" then
		local pink, dark = Color3.fromRGB(255, 170, 190), Color3.fromRGB(240, 130, 160)
		local body = petPart(m, Vector3.new(1.2, 1, 1.8), pink, CFrame.new(0, 0.9, 0))
		petPart(m, Vector3.new(0.9, 0.85, 0.8), pink, CFrame.new(0, 1.15, -1.2))
		petPart(m, Vector3.new(0.45, 0.35, 0.25), dark, CFrame.new(0, 1.05, -1.65))
		for _, sx in ipairs({-0.4, 0.4}) do
			for _, sz in ipairs({-0.6, 0.6}) do
				petPart(m, Vector3.new(0.3, 0.5, 0.3), pink, CFrame.new(sx, 0.25, sz))
			end
			petPart(m, Vector3.new(0.25, 0.3, 0.1), dark, CFrame.new(sx * 0.8, 1.7, -1.1))
		end
		m.PrimaryPart = body
	else
		local green, dark = Color3.fromRGB(96, 150, 80), Color3.fromRGB(70, 110, 55)
		local shell = petPart(m, Vector3.new(1.8, 1, 2), dark, CFrame.new(0, 0.75, 0), Enum.PartType.Ball)
		petPart(m, Vector3.new(0.5, 0.45, 0.6), green, CFrame.new(0, 0.55, -1.15))
		for _, sx in ipairs({-0.6, 0.6}) do
			for _, sz in ipairs({-0.55, 0.55}) do
				petPart(m, Vector3.new(0.35, 0.3, 0.4), green, CFrame.new(sx, 0.2, sz))
			end
		end
		m.PrimaryPart = shell
	end
	return m
end

local function petLoad(def)
	local model = Instance.new("Model")
	model.Name = def.key
	local loaded = false
	local ok, res = pcall(function()
		return InsertService:LoadAsset(def.id)
	end)
	if ok and res then
		for _, c in ipairs(res:GetChildren()) do
			c.Parent = model
		end
		res:Destroy()
		loaded = true
	else
		-- запасной путь (работает не везде)
		local ok2, objs = pcall(function()
			return game:GetObjects("rbxassetid://" .. def.id)
		end)
		if ok2 and objs then
			for _, o in ipairs(objs) do
				o.Parent = model
			end
			loaded = true
		end
	end
	local partsCount = 0
	if loaded then
		for _, d in ipairs(model:GetDescendants()) do
			if d:IsA("BaseScript") or d:IsA("Humanoid") or d:IsA("Animator") or d:IsA("Sound") then
				d:Destroy()
			elseif d:IsA("BasePart") then
				d.Anchored = true
				d.CanCollide = false
				d.CanQuery = false
				d.CanTouch = false
				d.Massless = true
				partsCount += 1
			end
		end
	end
	if partsCount == 0 then
		model:Destroy()
		model = petFallback(def.key)
	end
	return model
end

local function petRescale(pet)
	local target = pet.def.height * PetsMod.v.Size
	pcall(function()
		pet.model:ScaleTo(target / pet.baseH)
	end)
	local cf, sz = pet.model:GetBoundingBox()
	pet.offset = pet.model:GetPivot():ToObjectSpace(cf)
	pet.halfH = sz.Y / 2
end

local function petSpawn(def)
	if pets.list[def.key] or pets.loading[def.key] then
		return
	end
	pets.loading[def.key] = true
	task.spawn(function()
		local model = petLoad(def)
		pets.loading[def.key] = nil
		if not PetsMod.enabled or not PetsMod.v[def.key] or pets.list[def.key] or not pets.folder then
			model:Destroy()
			return
		end
		local pet = {model = model, def = def, pos = nil, y = nil, dir = Vector3.new(0, 0, -1)}
		local okS, sc = pcall(function()
			return model:GetScale()
		end)
		local _, sz = model:GetBoundingBox()
		pet.baseH = math.max(sz.Y / ((okS and sc) or 1), 0.1)
		petRescale(pet)
		model.Parent = pets.folder
		pets.list[def.key] = pet
	end)
end

local function petSync()
	if not PetsMod.enabled then
		return
	end
	for _, def in ipairs(PET_DEFS) do
		if PetsMod.v[def.key] then
			petSpawn(def)
		else
			local pet = pets.list[def.key]
			if pet then
				pet.model:Destroy()
				pets.list[def.key] = nil
			end
		end
	end
end

local function petStep(dt)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	pets.t += dt
	local vel = root.AssemblyLinearVelocity
	local flatVel = Vector3.new(vel.X, 0, vel.Z)
	local moving = flatVel.Magnitude > 2
	pets.move += ((moving and 1 or 0) - pets.move) * (1 - math.exp(-dt * 3))
	local lv, rv = root.CFrame.LookVector, root.CFrame.RightVector
	local look = Vector3.new(lv.X, 0, lv.Z)
	look = look.Magnitude > 0.01 and look.Unit or Vector3.new(0, 0, -1)
	local right = Vector3.new(rv.X, 0, rv.Z)
	right = right.Magnitude > 0.01 and right.Unit or Vector3.new(1, 0, 0)
	if moving then
		pets.dir = pets.dir:Lerp(flatVel.Unit, 1 - math.exp(-dt * 6))
	end
	local mdir = pets.dir.Magnitude > 0.01 and pets.dir.Unit or look
	petRay.FilterDescendantsInstances = {char, pets.folder}
	local rp = root.Position
	local base = Vector3.new(rp.X, 0, rp.Z)
	local idx = 0
	for _, def in ipairs(PET_DEFS) do
		local pet = pets.list[def.key]
		if pet then
			idx += 1
			-- на месте: справа от игрока; в движении: позади с небольшим разбросом
			local idle = right * (3 + (idx - 1) * 2.4) - look * 0.6
			local mv = -mdir * (3.6 + (idx - 1) * 2.6) + right * ((idx % 2 == 0) and 1.3 or -1.3)
			local target = base + idle:Lerp(mv, pets.move)
			if not pet.pos or (pet.pos - base).Magnitude > 70 then
				pet.pos = target
			end
			local old = pet.pos
			pet.pos = old + (target - old) * (1 - math.exp(-dt * (2.2 + pets.move)))
			local delta = pet.pos - old
			local walking = delta.Magnitude / math.max(dt, 1e-3) > 0.8
			local want = walking and delta.Unit or look
			pet.dir = pet.dir:Lerp(want, 1 - math.exp(-dt * 8))
			if pet.dir.Magnitude < 0.01 then
				pet.dir = look
			end
			local hit = workspace:Raycast(Vector3.new(pet.pos.X, rp.Y + 3, pet.pos.Z), Vector3.new(0, -40, 0), petRay)
			local gy = hit and hit.Position.Y or (rp.Y - 3)
			pet.y = pet.y and (pet.y + (gy - pet.y) * (1 - math.exp(-dt * 12))) or gy
			local hop = walking and math.abs(math.sin(pets.t * 9 + idx)) * 0.22 or 0
			local face = CFrame.lookAt(Vector3.zero, pet.dir.Unit) * CFrame.Angles(0, math.rad(PetsMod.v.Rotation), 0)
			local bb = CFrame.new(pet.pos.X, pet.y + pet.halfH + hop, pet.pos.Z) * face
			pet.model:PivotTo(bb * pet.offset:Inverse())
		end
	end
end

PetsMod = Module({
	name = "Pets",
	key = Enum.KeyCode.O,
	settings = {
		{type = "toggle", name = "Pig", default = true},
		{type = "toggle", name = "Tortoise", default = true},
		{type = "slider", name = "Size", min = 0.5, max = 2, step = 0.1, default = 1},
		{type = "slider", name = "Rotation", min = 0, max = 270, step = 90, default = 0},
	},
	onToggle = function(on)
		if pets.conn then
			pets.conn:Disconnect()
			pets.conn = nil
		end
		if on then
			pets.folder = new("Folder", {Name = "AreVisualsPets"}, workspace)
			pets.conn = RunService.RenderStepped:Connect(petStep)
			petSync()
		else
			for key, pet in pairs(pets.list) do
				pet.model:Destroy()
				pets.list[key] = nil
			end
			if pets.folder then
				pets.folder:Destroy()
				pets.folder = nil
			end
		end
	end,
	onChange = function(name)
		if not PetsMod.enabled then
			return
		end
		if name == "Size" then
			for _, pet in pairs(pets.list) do
				petRescale(pet)
			end
		elseif name == "Pig" or name == "Tortoise" then
			petSync()
		end
	end,
})

--------------------------------------------------------------------
-- PLAYER: TRAIL (разные стили)
--------------------------------------------------------------------
local trail = {objs = {}}
local TrailMod

local function trailRainbow()
	local k = {}
	for i = 0, 6 do
		table.insert(k, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 0.85, 1)))
	end
	return ColorSequence.new(k)
end

local function trailColorSeq(style, color)
	if style == 2 then
		return trailRainbow()
	elseif style == 1 then
		return ColorSequence.new(color, color:Lerp(Color3.new(0, 0, 0), 0.55))
	end
	return ColorSequence.new(color)
end

local function trailClear()
	for _, o in ipairs(trail.objs) do
		o:Destroy()
	end
	trail.objs = {}
end

local function trailBuild()
	trailClear()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not root then
		return
	end
	local style, color, life = TrailMod.v.Style, TrailMod.v.Color, TrailMod.v.Lifetime
	local function add(o)
		table.insert(trail.objs, o)
		return o
	end
	local foot = -(root.Size.Y / 2) - (hum and hum.HipHeight or 2) + 0.15

	if style == 4 then -- Sparkles
		local at = add(new("Attachment", {Position = Vector3.new(0, foot + 0.4, 0)}, root))
		add(new("ParticleEmitter", {
			Rate = 40,
			Lifetime = NumberRange.new(life * 0.6, life),
			Speed = NumberRange.new(0.5, 2),
			SpreadAngle = Vector2.new(180, 180),
			Drag = 2,
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)}),
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}),
			Color = ColorSequence.new(color),
			LightEmission = 1,
			LightInfluence = 0,
			Rotation = NumberRange.new(0, 360),
			RotSpeed = NumberRange.new(-90, 90),
		}, at))
	elseif style == 5 then -- Fire
		local at = add(new("Attachment", {Position = Vector3.new(0, foot + 0.3, 0)}, root))
		add(new("ParticleEmitter", {
			Rate = 70,
			Lifetime = NumberRange.new(life * 0.4, life * 0.7),
			Speed = NumberRange.new(1, 3),
			SpreadAngle = Vector2.new(25, 25),
			Acceleration = Vector3.new(0, 6, 0),
			Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.1), NumberSequenceKeypoint.new(1, 0)}),
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1)}),
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 90)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 120, 30)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 30, 10)),
			}),
			LightEmission = 1,
			LightInfluence = 0,
			Rotation = NumberRange.new(0, 360),
		}, at))
	else -- Ribbon / Rainbow / Ground
		local a0, a1
		if style == 3 then
			a0 = add(new("Attachment", {Position = Vector3.new(-0.7, foot, 0)}, root))
			a1 = add(new("Attachment", {Position = Vector3.new(0.7, foot, 0)}, root))
		else
			a0 = add(new("Attachment", {Position = Vector3.new(0, 1.1, 0)}, root))
			a1 = add(new("Attachment", {Position = Vector3.new(0, -1.1, 0)}, root))
		end
		add(new("Trail", {
			Attachment0 = a0,
			Attachment1 = a1,
			Lifetime = life,
			MinLength = 0.05,
			FaceCamera = style ~= 3,
			LightEmission = style == 2 and 1 or 0.6,
			LightInfluence = 0,
			Color = trailColorSeq(style, color),
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(1, 1)}),
			WidthScale = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.25)}),
		}, root))
	end
end

local function trailRecolor()
	local style, color = TrailMod.v.Style, TrailMod.v.Color
	for _, o in ipairs(trail.objs) do
		if o:IsA("Trail") then
			o.Color = trailColorSeq(style, color)
		elseif o:IsA("ParticleEmitter") and style == 4 then
			o.Color = ColorSequence.new(color)
		end
	end
end

TrailMod = Module({
	name = "Trail",
	key = Enum.KeyCode.Y,
	settings = {
		{type = "list", name = "Style", options = {"Ribbon", "Rainbow", "Ground", "Sparkles", "Fire"}, default = 1},
		{type = "color", name = "Color", default = ACCENT},
		{type = "slider", name = "Lifetime", min = 0.2, max = 3, step = 0.1, default = 1.2},
	},
	onToggle = function(on)
		if on then
			trailBuild()
		else
			trailClear()
		end
	end,
	onChange = function(name)
		if not TrailMod.enabled then
			return
		end
		if name == "Color" then
			trailRecolor()
		else
			trailBuild()
		end
	end,
})
player.CharacterAdded:Connect(function()
	if TrailMod.enabled then
		task.wait(1)
		trailBuild()
	end
end)

--------------------------------------------------------------------
-- PLAYER: CHINA HAT (ступенчатый конус из дисков, без ассетов)
--------------------------------------------------------------------
local hat = {parts = {}, folder = nil, head = nil, t = 0, conn = nil}
local HatMod
local HAT_LAYERS, HAT_R, HAT_H = 22, 1.2, 0.7

local function hatClear()
	if hat.folder then
		hat.folder:Destroy()
	end
	hat.folder, hat.parts, hat.head = nil, {}, nil
end

local function hatBuild(head)
	hatClear()
	hat.head = head
	hat.folder = new("Folder", {Name = "AreVisualsHat"}, workspace)
	local dy = HAT_H / HAT_LAYERS
	for i = 0, HAT_LAYERS - 1 do
		local r = HAT_R * (1 - i / HAT_LAYERS) + 0.03
		local disc = new("Part", {
			Shape = Enum.PartType.Cylinder,
			Size = Vector3.new(dy + 0.01, r * 2, r * 2),
			Material = Enum.Material.Neon,
			Transparency = 0.35,
			Color = HatMod.v.Color,
			Anchored = false,
			CanCollide = false,
			CanQuery = false,
			CanTouch = false,
			CastShadow = false,
			Massless = true,
		}, hat.folder)
		disc.CFrame = head.CFrame * CFrame.new(0, head.Size.Y / 2 + 0.12 + i * dy, 0) * CFrame.Angles(0, 0, math.pi / 2)
		local w = Instance.new("WeldConstraint")
		w.Part0 = head
		w.Part1 = disc
		w.Parent = disc
		table.insert(hat.parts, disc)
	end
end

local function hatStep(dt)
	local body = skinGhost or player.Character
	local head = body and body:FindFirstChild("Head")
	if not head then
		if hat.head then
			hatClear()
		end
		return
	end
	if head ~= hat.head then
		hatBuild(head)
	end
	hat.t += dt
	local cam = workspace.CurrentCamera
	local close = cam and (cam.CFrame.Position - head.Position).Magnitude < 2.4
	local base = HatMod.v.Color
	local rainbow = HatMod.v.Rainbow
	local n = #hat.parts
	for i, d in ipairs(hat.parts) do
		local f = (i - 1) / n
		if rainbow then
			d.Color = Color3.fromHSV((hat.t * 0.2 + f * 0.35) % 1, 0.75, 1)
		else
			d.Color = base:Lerp(WHITE, f * 0.45)
		end
		d.LocalTransparencyModifier = close and 1 or 0
	end
end

HatMod = Module({
	name = "China Hat",
	key = Enum.KeyCode.H,
	settings = {
		{type = "color", name = "Color", default = ACCENT},
		{type = "toggle", name = "Rainbow", default = false},
	},
	onToggle = function(on)
		if hat.conn then
			hat.conn:Disconnect()
			hat.conn = nil
		end
		if on then
			hat.conn = RunService.RenderStepped:Connect(hatStep)
		else
			hatClear()
		end
	end,
})

--------------------------------------------------------------------
-- PLAYER: NEON CROWN
-- Сплошной обод и восемь зубцов с шариками, без внешних моделей.
--------------------------------------------------------------------
local crown = {folder = nil, parts = {}, head = nil, conn = nil, t = 0, acc = 0}
local CrownMod
local CROWN_TEETH = 8
local CROWN_SEGMENTS = 64

local function crownClear()
	if crown.folder then
		crown.folder:Destroy()
	end
	crown.folder, crown.parts, crown.head = nil, {}, nil
end

local function crownPart(head, size, cf, shape, level)
	local part = new("Part", {
		Name = "CrownNeon",
		Size = size,
		Shape = shape or Enum.PartType.Block,
		Material = Enum.Material.Neon,
		Color = HatMod.v.Color,
		Transparency = 0.18,
		Anchored = false,
		CanCollide = false,
		CanQuery = false,
		CanTouch = false,
		CastShadow = false,
		Massless = true,
	}, crown.folder)
	part.CFrame = head.CFrame * cf
	local weld = Instance.new("WeldConstraint")
	weld.Part0, weld.Part1, weld.Parent = head, part, part
	table.insert(crown.parts, {part = part, level = level})
	return part
end

local function crownBuild(head)
	crownClear()
	crown.head = head
	crown.folder = new("Folder", {Name = "AreVisualsCrown"}, workspace)
	local size = CrownMod.v.Size
	local radius = 0.82 * size
	local thickness = 0.09 * size
	local bandBottom = head.Size.Y / 2 + 0.12 + CrownMod.v.Lift
	local bandHeight = 0.24 * size
	local toothBase = bandBottom + bandHeight - 0.025 * size
	local toothHeight = 0.67 * size
	local chord = 2 * radius * math.sin(math.pi / CROWN_SEGMENTS) + 0.018 * size
	for i = 0, CROWN_SEGMENTS - 1 do
		local angle = (i + 0.5) * math.pi * 2 / CROWN_SEGMENTS
		local x, z = math.sin(angle) * radius, math.cos(angle) * radius
		local rotation = CFrame.Angles(0, angle, 0)
		crownPart(head, Vector3.new(chord, bandHeight, thickness),
			CFrame.new(x, bandBottom + bandHeight / 2, z) * rotation, nil, 0)
		-- Вершины повторяются через равный угол; между ними плавная выемка.
		local crest = math.abs(math.cos(angle * CROWN_TEETH / 2)) ^ 3.25
		local wallHeight = (0.11 + toothHeight * crest)
		crownPart(head, Vector3.new(chord, wallHeight, thickness),
			CFrame.new(x, toothBase + wallHeight / 2, z) * rotation, nil, crest)
	end
	for i = 0, CROWN_TEETH - 1 do
		local angle = i * math.pi * 2 / CROWN_TEETH
		local x, z = math.sin(angle) * radius, math.cos(angle) * radius
		crownPart(head, Vector3.new(0.11, 0.11, 0.11) * size,
			CFrame.new(x, toothBase + 0.11 * size + toothHeight, z),
			Enum.PartType.Ball, 1)
		local studAngle = angle + math.pi / CROWN_TEETH
		crownPart(head, Vector3.new(0.055, 0.055, 0.055) * size,
			CFrame.new(math.sin(studAngle) * (radius + thickness / 2),
				bandBottom + bandHeight / 2,
				math.cos(studAngle) * (radius + thickness / 2)),
			Enum.PartType.Ball, 0.2)
	end
end

local function crownStep(dt)
	crown.acc += dt
	if crown.acc < 0.05 then return end
	local elapsed = crown.acc
	crown.acc = 0
	local body = skinGhost or player.Character
	local head = body and body:FindFirstChild("Head")
	if not head then
		if crown.head then crownClear() end
		return
	end
	if head ~= crown.head then crownBuild(head) end
	crown.t += elapsed
	local match = CrownMod.v["Match China Hat"]
	local rainbow = match and HatMod.v.Rainbow or CrownMod.v.Rainbow
	local base = match and HatMod.v.Color or CrownMod.v.Color
	local cam = workspace.CurrentCamera
	local close = cam and (cam.CFrame.Position - head.Position).Magnitude < 2.4
	for _, item in ipairs(crown.parts) do
		if rainbow then
			item.part.Color = Color3.fromHSV((crown.t * 0.2 + item.level * 0.35) % 1, 0.75, 1)
		else
			item.part.Color = base:Lerp(WHITE, item.level * 0.25)
		end
		item.part.LocalTransparencyModifier = close and 1 or 0
	end
end

CrownMod = Module({
	name = "Neon Crown",
	settings = {
		{type = "toggle", name = "Match China Hat", default = true},
		{type = "color", name = "Color", default = ACCENT},
		{type = "toggle", name = "Rainbow", default = false},
		{type = "slider", name = "Size", min = 0.6, max = 1.6, step = 0.1, default = 1},
		{type = "slider", name = "Lift", min = 0, max = 0.8, step = 0.05, default = 0},
	},
	onToggle = function(on)
		if crown.conn then
			crown.conn:Disconnect()
			crown.conn = nil
		end
		if on then
			crown.conn = RunService.RenderStepped:Connect(crownStep)
			crownStep(1)
		else
			crownClear()
		end
	end,
	onChange = function(name)
		if CrownMod.enabled and (name == "Size" or name == "Lift") then
			local body = skinGhost or player.Character
			local head = body and body:FindFirstChild("Head")
			if head then crownBuild(head) end
		end
	end,
})

--------------------------------------------------------------------
-- PLAYER: FROZEN HORNS (точная геометрия и огонь Roblox asset 74891470)
--------------------------------------------------------------------
local frozen = {accessory = nil, body = nil, conn = nil, acc = 0}
local FrozenMod
local FieryMod
local FROZEN_MESH = "rbxassetid://215680403"
local FROZEN_TEXTURE = "rbxassetid://658646189"
local FIERY_TEXTURE = "rbxassetid://215676264"

local function frozenClear()
	if frozen.accessory then frozen.accessory:Destroy() end
	frozen.accessory, frozen.body = nil, nil
end

local function hornsApply(accessory, mod, texture)
	if not accessory then return end
	local handle = accessory:FindFirstChild("Handle")
	if not handle then return end
	local mesh = handle:FindFirstChildOfClass("SpecialMesh")
	if mod.v.Neon then
		handle.Material = Enum.Material.Neon
		handle.Color = mod.v["Neon Color"]
		if mesh then mesh.TextureId = "" end
	else
		handle.Material = Enum.Material.Plastic
		handle.BrickColor = BrickColor.new(194)
		if mesh then mesh.TextureId = texture end
	end
	-- Fire остаётся дочерним объектом Handle в обоих режимах.
end

local function hornsCreate(body, head, name, texture, fireColor, secondaryColor)
	for _, old in ipairs(body:GetChildren()) do
		if old.Name == name then old:Destroy() end
	end

	local accessory = new("Accessory", {
		Name = name,
		AttachmentPoint = CFrame.new(0, -0.8, 0),
	})
	local handle = new("Part", {
		Name = "Handle",
		Size = Vector3.new(1.23, 0.76, 1.41),
		BrickColor = BrickColor.new(194),
		Material = Enum.Material.Plastic,
		CanCollide = false, CanTouch = false, CanQuery = false,
		CastShadow = false, Massless = true, Anchored = false,
	}, accessory)
	new("SpecialMesh", {
		Name = "Mesh",
		MeshType = Enum.MeshType.FileMesh,
		MeshId = FROZEN_MESH,
		TextureId = texture,
	}, handle)
	new("Fire", {
		Name = "Fire",
		Color = fireColor,
		SecondaryColor = secondaryColor,
		Enabled = true,
	}, handle)
	local accessoryAttachment = new("Attachment", {
		Name = "HatAttachment",
		CFrame = CFrame.new(0, -0.7, -0.000272),
	}, handle)
	local headAttachment = head:FindFirstChild("HatAttachment")
	if headAttachment and headAttachment:IsA("Attachment") then
		handle.CFrame = head.CFrame * headAttachment.CFrame * accessoryAttachment.CFrame:Inverse()
	else
		handle.CFrame = head.CFrame * CFrame.new(0, head.Size.Y / 2 + 0.7, 0)
	end
	accessory.Parent = body
	local weld = Instance.new("WeldConstraint")
	weld.Part0, weld.Part1, weld.Parent = head, handle, handle
	return accessory
end

local function frozenApply()
	hornsApply(frozen.accessory, FrozenMod, FROZEN_TEXTURE)
end

local function frozenAttach()
	if not FrozenMod.enabled then return end
	local body = skinGhost or player.Character
	local head = body and body:FindFirstChild("Head")
	if not head or not head:IsA("BasePart") then return end
	if frozen.body == body and frozen.accessory and frozen.accessory.Parent then return end
	frozenClear()
	frozen.accessory = hornsCreate(body, head, "AreVisualsFrozenHorns", FROZEN_TEXTURE,
		Color3.fromRGB(52, 206, 236), Color3.fromRGB(2, 64, 139))
	frozen.body = body
	frozenApply()
end

FrozenMod = Module({
	name = "Frozen Horns",
	settings = {
		{type = "toggle", name = "Neon", default = false},
		{type = "color", name = "Neon Color", default = Color3.fromRGB(20, 180, 255)},
	},
	onToggle = function(on)
		if frozen.conn then frozen.conn:Disconnect(); frozen.conn = nil end
		if on then
			if FieryMod and FieryMod.enabled then setEnabled(FieryMod, false) end
			frozenAttach()
			frozen.conn = RunService.Heartbeat:Connect(function(dt)
				frozen.acc += dt
				if frozen.acc >= 0.5 then
					frozen.acc = 0
					frozenAttach()
				end
			end)
		else
			frozenClear()
		end
	end,
	onChange = function()
		frozenApply()
	end,
})

local fiery = {accessory = nil, body = nil, conn = nil, acc = 0}

local function fieryClear()
	if fiery.accessory then fiery.accessory:Destroy() end
	fiery.accessory, fiery.body = nil, nil
end

local function fieryAttach()
	if not FieryMod.enabled then return end
	local body = skinGhost or player.Character
	local head = body and body:FindFirstChild("Head")
	if not head or not head:IsA("BasePart") then return end
	if fiery.body == body and fiery.accessory and fiery.accessory.Parent then return end
	fieryClear()
	fiery.accessory = hornsCreate(body, head, "AreVisualsFieryHorns", FIERY_TEXTURE,
		Color3.fromRGB(236, 139, 70), Color3.fromRGB(139, 80, 55))
	fiery.body = body
	hornsApply(fiery.accessory, FieryMod, FIERY_TEXTURE)
end

FieryMod = Module({
	name = "Fiery Horns",
	settings = {
		{type = "toggle", name = "Neon", default = false},
		{type = "color", name = "Neon Color", default = Color3.fromRGB(255, 105, 34)},
	},
	onToggle = function(on)
		if fiery.conn then fiery.conn:Disconnect(); fiery.conn = nil end
		if on then
			if FrozenMod.enabled then setEnabled(FrozenMod, false) end
			fieryAttach()
			fiery.conn = RunService.Heartbeat:Connect(function(dt)
				fiery.acc += dt
				if fiery.acc >= 0.5 then
					fiery.acc = 0
					fieryAttach()
				end
			end)
		else
			fieryClear()
		end
	end,
	onChange = function()
		hornsApply(fiery.accessory, FieryMod, FIERY_TEXTURE)
	end,
})

--------------------------------------------------------------------
-- PLAYER: AURA (эффектная аура вокруг персонажа)
-- Рунное кольцо на земле + орбитальные неоновые кометы + фонтан частиц.
-- Всё процедурное, без ассетов. Видно всем вокруг.
-- (всё хранится в таблице aura, чтобы не плодить top-level локалы)
--------------------------------------------------------------------
local AuraMod
local aura = {
	folder = nil, ringPart = nil, strokes = {}, ticks = {}, motes = {}, emitter = nil,
	conn = nil, t = 0, hue = 0, MOTES = 6,
	styles = {
		{name = "Nebula", colors = {Color3.fromRGB(120, 80, 255), Color3.fromRGB(80, 200, 255)},
			emit = ColorSequence.new(Color3.fromRGB(150, 110, 255), Color3.fromRGB(90, 210, 255)), rate = 55, mode = "rise"},
		{name = "Inferno", colors = {Color3.fromRGB(255, 180, 60), Color3.fromRGB(200, 30, 20)},
			emit = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 225, 90)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 110, 30)), ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 25, 10))}), rate = 85, mode = "fire"},
		{name = "Thunder", colors = {Color3.fromRGB(130, 205, 255), Color3.fromRGB(60, 80, 220)},
			emit = ColorSequence.new(Color3.fromRGB(210, 240, 255), Color3.fromRGB(90, 130, 255)), rate = 75, mode = "spark"},
		{name = "Sakura", colors = {Color3.fromRGB(255, 185, 212), Color3.fromRGB(255, 120, 175)},
			emit = ColorSequence.new(Color3.fromRGB(255, 215, 228), Color3.fromRGB(255, 140, 190)), rate = 34, mode = "petal"},
		{name = "Divine", colors = {Color3.fromRGB(255, 240, 180), Color3.fromRGB(255, 200, 90)},
			emit = ColorSequence.new(Color3.fromRGB(255, 250, 215), Color3.fromRGB(255, 205, 100)), rate = 48, mode = "holy"},
		{name = "Void", colors = {Color3.fromRGB(60, 30, 80), Color3.fromRGB(170, 50, 220)},
			emit = ColorSequence.new(Color3.fromRGB(100, 40, 150), Color3.fromRGB(195, 75, 240)), rate = 55, mode = "rise"},
	},
}

function aura.curColor()
	if AuraMod.v.Rainbow then
		return Color3.fromHSV(aura.hue % 1, 0.8, 1)
	end
	return AuraMod.v.Color
end

function aura.clear()
	if aura.conn then
		aura.conn:Disconnect()
		aura.conn = nil
	end
	if aura.folder then
		aura.folder:Destroy()
		aura.folder = nil
	end
	aura.ringPart, aura.emitter = nil, nil
	aura.strokes, aura.ticks, aura.motes = {}, {}, {}
end

function aura.emitProps(st)
	local base = {
		Rate = st.rate, Lifetime = NumberRange.new(1, 1.8), Speed = NumberRange.new(4, 7),
		SpreadAngle = Vector2.new(10, 10), Acceleration = Vector3.new(0, 3, 0), Drag = 1,
		Rotation = NumberRange.new(0, 360), RotSpeed = NumberRange.new(-120, 120),
		LightEmission = 1, LightInfluence = 0, Color = st.emit,
		Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 0)}),
		Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(1, 1)}),
		EmissionDirection = Enum.NormalId.Top,
	}
	if st.mode == "fire" then
		base.Speed = NumberRange.new(5, 9)
		base.Acceleration = Vector3.new(0, 7, 0)
		base.SpreadAngle = Vector2.new(22, 22)
	elseif st.mode == "spark" then
		base.Speed = NumberRange.new(7, 12)
		base.Acceleration = Vector3.new(0, 1, 0)
		base.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.45), NumberSequenceKeypoint.new(1, 0)})
	elseif st.mode == "petal" then
		base.Speed = NumberRange.new(2, 4)
		base.Acceleration = Vector3.new(1, -2, 0.5)
		base.SpreadAngle = Vector2.new(180, 180)
		base.Drag = 2
		base.Lifetime = NumberRange.new(2.2, 3.4)
		base.Size = NumberSequence.new(0.55)
		base.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.12, 0.1), NumberSequenceKeypoint.new(0.85, 0.1), NumberSequenceKeypoint.new(1, 1)})
	elseif st.mode == "holy" then
		base.Speed = NumberRange.new(2.5, 4.5)
		base.Acceleration = Vector3.new(0, 2.5, 0)
		base.Drag = 1.5
	end
	return base
end

function aura.build()
	aura.clear()
	local char = skinGhost or player.Character
	if not char or not AuraMod.enabled then
		return
	end
	local st = aura.styles[AuraMod.v.Style]
	local color = aura.curColor()
	aura.folder = new("Folder", {Name = "AreVisualsAura"}, workspace)

	-- кольцо рун на земле
	local FULL = 12 * 50
	local C = FULL / 2
	local ringPart = new("Part", {
		Name = "AreVisualsAuraRing", Anchored = true, CanCollide = false, CanQuery = false,
		CanTouch = false, CastShadow = false, Transparency = 1, Size = Vector3.new(12, 0.05, 12),
		CFrame = CFrame.new(0, -1e4, 0),
	}, aura.folder)
	local sg = new("SurfaceGui", {Face = Enum.NormalId.Top, SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud, PixelsPerStud = 50, LightInfluence = 0, AlwaysOnTop = false}, ringPart)
	local rroot = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(FULL, FULL), BackgroundTransparency = 1, BorderSizePixel = 0}, sg)

	local function ring(d, th, a)
		local f = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1, BorderSizePixel = 0}, rroot)
		new("UICorner", {CornerRadius = UDim.new(1, 0)}, f)
		local s = new("UIStroke", {Color = color, Thickness = th, Transparency = a, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, f)
		table.insert(aura.strokes, {s, a})
	end
	ring(FULL * 0.52, 3, 0.1)
	ring(FULL * 0.52, 9, 0.72)
	ring(FULL * 0.3, 2, 0.2)
	ring(FULL * 0.3, 7, 0.78)

	-- рунные чёрточки по кругу между кольцами
	local rMid, N = FULL * 0.205, 36
	for i = 0, N - 1 do
		local ang = (i / N) * 2 * math.pi
		local long = (i % 3 == 0)
		local tk = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(3, long and 20 or 10),
			Position = UDim2.fromOffset(C + rMid * math.sin(ang), C - rMid * math.cos(ang)),
			Rotation = math.deg(ang), BackgroundColor3 = color, BorderSizePixel = 0,
			BackgroundTransparency = long and 0.1 or 0.45,
		}, rroot)
		table.insert(aura.ticks, tk)
	end

	-- фонтан частиц из центра
	local coreAtt = new("Attachment", {Position = Vector3.new(0, 0.2, 0)}, ringPart)
	aura.emitter = new("ParticleEmitter", aura.emitProps(st), coreAtt)
	aura.ringPart = ringPart

	-- орбитальные кометы
	for _ = 1, aura.MOTES do
		local p = new("Part", {
			Name = "AreVisualsAuraMote", Shape = Enum.PartType.Ball, Material = Enum.Material.Neon,
			Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false, CastShadow = false,
			Size = Vector3.new(0.45, 0.45, 0.45), Color = color, CFrame = CFrame.new(0, -1e4, 0),
		}, aura.folder)
		local a0 = new("Attachment", {Position = Vector3.new(0, 0.28, 0)}, p)
		local a1 = new("Attachment", {Position = Vector3.new(0, -0.28, 0)}, p)
		local tr = new("Trail", {
			Attachment0 = a0, Attachment1 = a1, Lifetime = 0.4, FaceCamera = true,
			LightEmission = 1, LightInfluence = 0, Color = ColorSequence.new(color),
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(1, 1)}),
			WidthScale = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}),
		}, p)
		table.insert(aura.motes, {part = p, trail = tr})
	end

	aura.conn = RunService.RenderStepped:Connect(function(dt)
		local body = skinGhost or player.Character
		local root = body and body:FindFirstChild("HumanoidRootPart")
		if not root then
			return
		end
		aura.t += dt
		if AuraMod.v.Rainbow then
			aura.hue = (aura.hue + dt * 0.18) % 1
		end
		local col = aura.curColor()
		local size = AuraMod.v.Size
		local speed = AuraMod.v.Speed
		local hum = body:FindFirstChildOfClass("Humanoid")
		local footY = root.Position.Y - (root.Size.Y / 2 + (hum and hum.HipHeight or 2) - 0.1)
		local pulse = 0.5 + 0.5 * math.sin(aura.t * 2.4)

		if aura.ringPart then
			aura.ringPart.Size = Vector3.new(12 * size, 0.05, 12 * size)
			aura.ringPart.CFrame = CFrame.new(root.Position.X, footY + 0.06, root.Position.Z) * CFrame.Angles(0, aura.t * speed * 0.5, 0)
		end
		for _, s in ipairs(aura.strokes) do
			s[1].Color = col
			s[1].Transparency = s[2] + (1 - s[2]) * pulse * 0.4
		end
		for _, tk in ipairs(aura.ticks) do
			tk.BackgroundColor3 = col
		end
		if aura.emitter then
			aura.emitter.Color = AuraMod.v.Rainbow and ColorSequence.new(col) or st.emit
		end

		for i, m in ipairs(aura.motes) do
			local ang = aura.t * speed + (i / aura.MOTES) * math.pi * 2
			local r = (2.4 + 0.35 * math.sin(aura.t * 2 + i)) * size
			local y = math.sin(aura.t * 1.7 + i * 1.3) * 1.3
			m.part.CFrame = CFrame.new(root.Position.X + math.cos(ang) * r, root.Position.Y + y, root.Position.Z + math.sin(ang) * r)
			m.part.Color = col
			m.part.Size = Vector3.new(0.45, 0.45, 0.45) * size
			m.trail.Color = ColorSequence.new(col)
		end
	end)
end

AuraMod = Module({
	name = "Aura",
	key = Enum.KeyCode.F,
	settings = {
		{type = "gallery", name = "Style", items = aura.styles, default = 1},
		{type = "color", name = "Color", default = Color3.fromRGB(140, 100, 255)},
		{type = "toggle", name = "Rainbow", default = false},
		{type = "slider", name = "Size", min = 0.5, max = 2, step = 0.1, default = 1},
		{type = "slider", name = "Speed", min = 0.5, max = 4, step = 0.1, default = 1.6},
	},
	onToggle = function(on)
		if on then
			aura.build()
		else
			aura.clear()
		end
	end,
	onChange = function(name)
		if AuraMod.enabled and name == "Style" then
			aura.build()
		end
		-- Color / Rainbow / Size / Speed подхватываются в RenderStepped на лету
	end,
})
player.CharacterAdded:Connect(function()
	if AuraMod.enabled then
		task.wait(1)
		if AuraMod.enabled then
			aura.build()
		end
	end
end)

--------------------------------------------------------------------
-- WORLD: SKY SHADERS (пресеты освещения: небо, атмосфера, цвет, bloom, лучи)
--------------------------------------------------------------------
local function rgb(r, g, b)
	return Color3.fromRGB(r, g, b)
end
local SHADERS = {
	{name = "Realistic Day", colors = {rgb(63, 118, 201), rgb(176, 205, 235)}, clock = 13.5, bright = 3,
		ambient = rgb(70, 70, 80), outdoor = rgb(120, 125, 140),
		atmo = {Density = 0.3, Offset = 0.25, Color = rgb(199, 215, 235), Decay = rgb(106, 112, 125), Glare = 0.3, Haze = 1.2},
		cc = {TintColor = rgb(255, 250, 242), Saturation = 0.12, Contrast = 0.08, Brightness = 0},
		bloom = {0.35, 24, 0.95}, rays = {0.12, 0.7}},
	{name = "Golden Hour", colors = {rgb(255, 160, 90), rgb(255, 214, 160)}, clock = 17.6, bright = 2.5,
		ambient = rgb(90, 70, 60), outdoor = rgb(140, 110, 90),
		atmo = {Density = 0.38, Offset = 0.3, Color = rgb(255, 200, 150), Decay = rgb(255, 150, 80), Glare = 1, Haze = 2},
		cc = {TintColor = rgb(255, 232, 205), Saturation = 0.25, Contrast = 0.12, Brightness = 0},
		bloom = {0.6, 30, 0.8}, rays = {0.3, 0.8}},
	{name = "Pink Dusk", colors = {rgb(110, 70, 160), rgb(255, 170, 200)}, clock = 18.4, bright = 1.8,
		ambient = rgb(80, 60, 90), outdoor = rgb(130, 100, 150),
		atmo = {Density = 0.4, Offset = 0.3, Color = rgb(255, 170, 210), Decay = rgb(200, 110, 190), Glare = 0.6, Haze = 2.4},
		cc = {TintColor = rgb(255, 225, 245), Saturation = 0.3, Contrast = 0.1, Brightness = 0},
		bloom = {0.7, 36, 0.75}, rays = {0.2, 0.9}},
	{name = "Night Moon", colors = {rgb(8, 12, 35), rgb(40, 60, 110)}, clock = 0.5, bright = 1.2,
		ambient = rgb(30, 40, 70), outdoor = rgb(50, 65, 110),
		atmo = {Density = 0.25, Offset = 0, Color = rgb(40, 60, 110), Decay = rgb(20, 30, 60), Glare = 0, Haze = 0.5},
		cc = {TintColor = rgb(200, 215, 255), Saturation = -0.05, Contrast = 0.1, Brightness = 0.02},
		bloom = {0.6, 30, 0.8}, rays = {0, 0.5}},
	{name = "Overcast", colors = {rgb(120, 128, 138), rgb(190, 195, 200)}, clock = 12, bright = 1.6,
		ambient = rgb(110, 115, 120), outdoor = rgb(150, 155, 160),
		atmo = {Density = 0.55, Offset = 0.1, Color = rgb(170, 175, 182), Decay = rgb(140, 145, 150), Glare = 0, Haze = 4},
		cc = {TintColor = rgb(235, 240, 245), Saturation = -0.25, Contrast = 0.05, Brightness = 0},
		bloom = {0.15, 20, 1}, rays = {0, 0.5}},
	{name = "Cyberpunk", colors = {rgb(30, 10, 70), rgb(255, 60, 190)}, clock = 21.5, bright = 2.2,
		ambient = rgb(60, 20, 90), outdoor = rgb(110, 40, 160),
		atmo = {Density = 0.45, Offset = 0.2, Color = rgb(255, 60, 200), Decay = rgb(90, 30, 200), Glare = 0.4, Haze = 3},
		cc = {TintColor = rgb(255, 215, 255), Saturation = 0.45, Contrast = 0.25, Brightness = 0},
		bloom = {1.0, 40, 0.6}, rays = {0.1, 0.5}},
	{name = "Arctic", colors = {rgb(110, 170, 230), rgb(225, 240, 255)}, clock = 11, bright = 3,
		ambient = rgb(100, 120, 140), outdoor = rgb(160, 185, 210),
		atmo = {Density = 0.35, Offset = 0.2, Color = rgb(200, 225, 255), Decay = rgb(150, 190, 230), Glare = 0.2, Haze = 1.5},
		cc = {TintColor = rgb(225, 240, 255), Saturation = -0.05, Contrast = 0.15, Brightness = 0},
		bloom = {0.3, 24, 0.95}, rays = {0.15, 0.6}},
	{name = "Toxic", colors = {rgb(70, 120, 30), rgb(200, 240, 110)}, clock = 16, bright = 2,
		ambient = rgb(50, 80, 40), outdoor = rgb(90, 140, 60),
		atmo = {Density = 0.5, Offset = 0.2, Color = rgb(160, 230, 80), Decay = rgb(90, 160, 40), Glare = 0.2, Haze = 3.5},
		cc = {TintColor = rgb(225, 255, 200), Saturation = 0.2, Contrast = 0.15, Brightness = 0},
		bloom = {0.5, 30, 0.8}, rays = {0.1, 0.6}},
	{name = "Blood Moon", colors = {rgb(40, 8, 12), rgb(200, 40, 40)}, clock = 0, bright = 1.1,
		ambient = rgb(60, 20, 22), outdoor = rgb(90, 35, 38),
		atmo = {Density = 0.42, Offset = 0.15, Color = rgb(180, 50, 50), Decay = rgb(120, 25, 25), Glare = 0.3, Haze = 2.5},
		cc = {TintColor = rgb(255, 210, 205), Saturation = 0.15, Contrast = 0.22, Brightness = -0.02},
		bloom = {0.7, 34, 0.75}, rays = {0.1, 0.6}},
	{name = "Synthwave", colors = {rgb(90, 20, 140), rgb(255, 60, 170)}, clock = 19.2, bright = 1.9,
		ambient = rgb(70, 25, 90), outdoor = rgb(120, 45, 150),
		atmo = {Density = 0.45, Offset = 0.25, Color = rgb(255, 90, 200), Decay = rgb(120, 40, 220), Glare = 0.6, Haze = 2.6},
		cc = {TintColor = rgb(255, 220, 255), Saturation = 0.4, Contrast = 0.2, Brightness = 0},
		bloom = {0.9, 40, 0.65}, rays = {0.22, 0.85}},
	{name = "Aurora", colors = {rgb(10, 25, 45), rgb(70, 230, 170)}, clock = 1, bright = 1.3,
		ambient = rgb(30, 55, 60), outdoor = rgb(45, 80, 85),
		atmo = {Density = 0.35, Offset = 0.1, Color = rgb(70, 220, 170), Decay = rgb(30, 110, 130), Glare = 0.3, Haze = 1.4},
		cc = {TintColor = rgb(215, 255, 240), Saturation = 0.25, Contrast = 0.14, Brightness = 0.02},
		bloom = {0.6, 32, 0.78}, rays = {0.14, 0.7}},
	{name = "Sahara", colors = {rgb(220, 150, 70), rgb(255, 225, 160)}, clock = 12.5, bright = 3.2,
		ambient = rgb(120, 95, 60), outdoor = rgb(165, 135, 95),
		atmo = {Density = 0.6, Offset = 0.3, Color = rgb(240, 205, 150), Decay = rgb(220, 160, 90), Glare = 0.8, Haze = 4.5},
		cc = {TintColor = rgb(255, 240, 215), Saturation = 0.15, Contrast = 0.1, Brightness = 0.02},
		bloom = {0.4, 28, 0.85}, rays = {0.28, 0.8}},
	{name = "Horror", colors = {rgb(18, 20, 24), rgb(80, 90, 95)}, clock = 23, bright = 0.7,
		ambient = rgb(28, 30, 34), outdoor = rgb(42, 46, 50),
		atmo = {Density = 0.85, Offset = 0.2, Color = rgb(120, 128, 132), Decay = rgb(50, 55, 60), Glare = 0, Haze = 6},
		cc = {TintColor = rgb(220, 228, 232), Saturation = -0.45, Contrast = 0.2, Brightness = -0.03},
		bloom = {0.1, 18, 1}, rays = {0, 0.5}},
	{name = "Pastel Dawn", colors = {rgb(255, 200, 215), rgb(190, 225, 255)}, clock = 6.4, bright = 2.3,
		ambient = rgb(120, 110, 125), outdoor = rgb(170, 160, 180),
		atmo = {Density = 0.4, Offset = 0.25, Color = rgb(255, 215, 230), Decay = rgb(200, 190, 230), Glare = 0.4, Haze = 2.2},
		cc = {TintColor = rgb(255, 238, 245), Saturation = 0.1, Contrast = 0.05, Brightness = 0.03},
		bloom = {0.55, 34, 0.75}, rays = {0.2, 0.85}},
	{name = "Underwater", colors = {rgb(10, 60, 90), rgb(60, 180, 200)}, clock = 11, bright = 1.6,
		ambient = rgb(40, 80, 95), outdoor = rgb(55, 110, 125),
		atmo = {Density = 0.75, Offset = 0.15, Color = rgb(60, 160, 190), Decay = rgb(20, 90, 120), Glare = 0.1, Haze = 5},
		cc = {TintColor = rgb(210, 245, 255), Saturation = 0.1, Contrast = 0.1, Brightness = -0.01},
		bloom = {0.35, 26, 0.85}, rays = {0.1, 0.7}},
	{name = "Galaxy", colors = {rgb(12, 10, 40), rgb(120, 80, 230)}, clock = 0.2, bright = 1.1,
		ambient = rgb(35, 30, 65), outdoor = rgb(55, 48, 100),
		atmo = {Density = 0.3, Offset = 0.05, Color = rgb(110, 80, 210), Decay = rgb(50, 35, 120), Glare = 0.2, Haze = 1},
		cc = {TintColor = rgb(225, 220, 255), Saturation = 0.2, Contrast = 0.16, Brightness = 0.02},
		bloom = {0.8, 38, 0.72}, rays = {0.12, 0.6}},
}

local shader = {snap = nil, atmo = nil, atmoCreated = false, atmoSnap = nil, cc = nil, bloom = nil, rays = nil, tweens = {}, token = 0}
local ShaderMod

local function shaderCancel()
	for _, t in ipairs(shader.tweens) do
		t:Cancel()
	end
	shader.tweens = {}
end

local function shaderApply(smooth)
	if not shader.cc then
		return
	end
	local p = SHADERS[ShaderMod.v.Preset]
	local targets = {
		{Lighting, {ClockTime = p.clock, Brightness = p.bright, Ambient = p.ambient, OutdoorAmbient = p.outdoor}},
		{shader.atmo, p.atmo},
		{shader.cc, p.cc},
		{shader.bloom, {Intensity = p.bloom[1], Size = p.bloom[2], Threshold = p.bloom[3]}},
		{shader.rays, {Intensity = p.rays[1], Spread = p.rays[2]}},
	}
	shaderCancel()
	for _, pair in ipairs(targets) do
		if smooth then
			local t = TweenService:Create(pair[1], TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), pair[2])
			t:Play()
			table.insert(shader.tweens, t)
		else
			for k, v in pairs(pair[2]) do
				pair[1][k] = v
			end
		end
	end
end

ShaderMod = Module({
	name = "Sky Shaders",
	key = Enum.KeyCode.G,
	settings = {
		{type = "gallery", name = "Preset", items = SHADERS, default = 1},
	},
	onToggle = function(on)
		shader.token += 1
		local my = shader.token
		if on then
			task.spawn(function()
				-- Weather Moods меняет то же освещение, поэтому сначала выключаем его
				if WeatherMod.enabled then
					setEnabled(WeatherMod, false)
					task.wait(1.7)
				end
				if shader.token ~= my or not ShaderMod.enabled then
					return
				end
				shader.snap = {ClockTime = Lighting.ClockTime, Brightness = Lighting.Brightness, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient}
				local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
				shader.atmoCreated = false
				shader.atmoSnap = nil
				if atmo then
					shader.atmoSnap = {Density = atmo.Density, Offset = atmo.Offset, Color = atmo.Color, Decay = atmo.Decay, Glare = atmo.Glare, Haze = atmo.Haze}
				else
					atmo = new("Atmosphere", {Name = "AreVisualsShaderAtmo", Density = 0, Offset = 0, Haze = 0, Glare = 0}, Lighting)
					shader.atmoCreated = true
				end
				shader.atmo = atmo
				shader.cc = new("ColorCorrectionEffect", {Name = "AreVisualsShaderCC"}, Lighting)
				shader.bloom = new("BloomEffect", {Name = "AreVisualsShaderBloom", Intensity = 0, Size = 24, Threshold = 1}, Lighting)
				shader.rays = new("SunRaysEffect", {Name = "AreVisualsShaderRays", Intensity = 0, Spread = 0.5}, Lighting)
				shaderApply(true)
			end)
		else
			shaderCancel()
			local cc, atmo, bloom, rays = shader.cc, shader.atmo, shader.bloom, shader.rays
			if cc then
				local info = TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				if shader.snap then
					TweenService:Create(Lighting, info, shader.snap):Play()
				end
				TweenService:Create(cc, info, {TintColor = WHITE, Saturation = 0, Contrast = 0, Brightness = 0}):Play()
				TweenService:Create(bloom, info, {Intensity = 0}):Play()
				TweenService:Create(rays, info, {Intensity = 0}):Play()
				if atmo then
					if shader.atmoCreated then
						TweenService:Create(atmo, info, {Density = 0, Haze = 0, Glare = 0, Offset = 0}):Play()
					elseif shader.atmoSnap then
						TweenService:Create(atmo, info, shader.atmoSnap):Play()
					end
				end
				local created = shader.atmoCreated
				task.delay(1.5, function()
					if shader.token ~= my then
						return
					end
					cc:Destroy()
					bloom:Destroy()
					rays:Destroy()
					if created and atmo then
						atmo:Destroy()
					end
					shader.cc, shader.atmo, shader.bloom, shader.rays = nil, nil, nil, nil
				end)
			end
		end
	end,
	onChange = function()
		shaderApply(true)
	end,
})

--------------------------------------------------------------------
-- PLAYER: SKINCHANGER
-- Делает клиентскую копию модели выбранного ника и накладывает на неё твою анимацию,
-- настоящий персонаж у тебя на экране скрывается. Видишь это только ты.
--------------------------------------------------------------------
local skin = {ticket = 0, motors = {}, hide = {}, ghostParts = {}, decalOrig = {}, offset = 0, acc = 0, conn = nil, origDesc = nil}
local SkinMod
local C_OK, C_WAIT, C_ERR = Color3.fromRGB(120, 230, 150), Color3.fromRGB(255, 220, 120), Color3.fromRGB(255, 120, 120)

local function getHumanoid()
	local c = player.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function skinCollectReal()
	skin.motors, skin.hide = {}, {}
	local char = player.Character
	if not char or not skinGhost then
		return
	end
	local gm = {}
	for _, d in ipairs(skinGhost:GetDescendants()) do
		if d:IsA("Motor6D") and not d:FindFirstAncestorOfClass("Accessory") then
			gm[d.Name] = d
		end
	end
	for _, d in ipairs(char:GetDescendants()) do
		if d:IsA("Motor6D") and not d:FindFirstAncestorOfClass("Accessory") and not d:FindFirstAncestorOfClass("Tool") and gm[d.Name] then
			table.insert(skin.motors, {real = d, ghost = gm[d.Name]})
		elseif d:IsA("BasePart") and not d:FindFirstAncestorOfClass("Tool") then
			table.insert(skin.hide, d)
		elseif d:IsA("Decal") and not d:FindFirstAncestorOfClass("Tool") then
			if skin.decalOrig[d] == nil then
				skin.decalOrig[d] = d.Transparency
			end
			d.Transparency = 1
		end
	end
end

local function skinDestroyGhost()
	if skin.conn then
		skin.conn:Disconnect()
		skin.conn = nil
	end
	if skinGhost then
		skinGhost:Destroy()
		skinGhost = nil
	end
	for _, p in ipairs(skin.hide) do
		if p.Parent then
			p.LocalTransparencyModifier = 0
		end
	end
	for d, o in pairs(skin.decalOrig) do
		if d.Parent then
			d.Transparency = o
		end
	end
	skin.hide, skin.motors, skin.ghostParts, skin.decalOrig = {}, {}, {}, {}
end

local function skinStep(dt)
	local g, char = skinGhost, player.Character
	if not g or not char then
		return
	end
	local root = char:FindFirstChild("HumanoidRootPart")
	local groot = g.PrimaryPart
	if not root or not groot then
		return
	end
	skin.acc += dt
	if skin.acc > 0.5 then
		skin.acc = 0
		skinCollectReal()
	end
	for _, p in ipairs(skin.motors) do
		p.ghost.Transform = p.real.Transform
	end
	groot.CFrame = root.CFrame * CFrame.new(0, skin.offset, 0)
	for _, p in ipairs(skin.hide) do
		p.LocalTransparencyModifier = 1
	end
	local cam = workspace.CurrentCamera
	local close = cam and (cam.CFrame.Position - root.Position).Magnitude < 2.2
	for _, p in ipairs(skin.ghostParts) do
		p.LocalTransparencyModifier = close and 1 or 0
		p.CanCollide = false
	end
end

local function skinApply(username)
	username = (username or ""):match("^%s*(.-)%s*$")
	if username == "" then
		SkinMod.setStatus("Output", "", ACCENT)
		return
	end
	if not getHumanoid() then
		SkinMod.setStatus("Output", "No character", C_ERR)
		return
	end
	skin.ticket += 1
	local my = skin.ticket
	SkinMod.setStatus("Output", "Loading...", C_WAIT)
	task.spawn(function()
		local ok, userId = pcall(function()
			return Players:GetUserIdFromNameAsync(username)
		end)
		if not ok or not userId then
			if my == skin.ticket then
				SkinMod.setStatus("Output", "User not found", C_ERR)
			end
			return
		end
		local ok2, desc = pcall(function()
			return Players:GetHumanoidDescriptionFromUserId(userId)
		end)
		if not ok2 or not desc then
			if my == skin.ticket then
				SkinMod.setStatus("Output", "Failed to load", C_ERR)
			end
			return
		end
		if my ~= skin.ticket or not SkinMod.enabled then
			return
		end
		local hum = getHumanoid()
		if not hum then
			return
		end
		local ok3, model = pcall(function()
			return Players:CreateHumanoidModelFromDescription(desc, hum.RigType)
		end)
		if my ~= skin.ticket or not SkinMod.enabled then
			if ok3 and model then
				model:Destroy()
			end
			return
		end
		if not ok3 or not model then
			-- запасной вариант: применить описание прямо к своему персонажу (локально)
			if not skin.origDesc then
				local okd, od = pcall(function()
					return hum:GetAppliedDescription()
				end)
				if okd then
					skin.origDesc = od
				end
			end
			local ok4 = pcall(function()
				hum:ApplyDescription(desc)
			end)
			SkinMod.setStatus("Output", ok4 and "Applied" or "Blocked by game", ok4 and C_OK or C_ERR)
			return
		end

		skinDestroyGhost()
		model.Name = "AreVisualsGhost"
		for _, d in ipairs(model:GetDescendants()) do
			if d:IsA("BasePart") then
				d.CanCollide = false
				d.CanQuery = false
				d.CanTouch = false
				d.Massless = true
				pcall(function()
					d.TopSurface = Enum.SurfaceType.Smooth
					d.BottomSurface = Enum.SurfaceType.Smooth
					d.LeftSurface = Enum.SurfaceType.Smooth
					d.RightSurface = Enum.SurfaceType.Smooth
					d.FrontSurface = Enum.SurfaceType.Smooth
					d.BackSurface = Enum.SurfaceType.Smooth
				end)
				table.insert(skin.ghostParts, d)
			end
		end
		-- ждём загрузки мешей и текстур, иначе модель сначала видна "кубиками"
		pcall(function()
			game:GetService("ContentProvider"):PreloadAsync({model})
		end)
		if my ~= skin.ticket or not SkinMod.enabled then
			model:Destroy()
			return
		end
		local gh = model:FindFirstChildOfClass("Humanoid")
		local groot = model:FindFirstChild("HumanoidRootPart")
		if not groot then
			model:Destroy()
			SkinMod.setStatus("Output", "Failed to build", C_ERR)
			return
		end
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if root and gh then
			skin.offset = (gh.HipHeight + groot.Size.Y / 2) - (hum.HipHeight + root.Size.Y / 2)
		else
			skin.offset = 0
		end
		-- Humanoid копии включает коллизии торса/головы и расталкивает настоящего персонажа
		-- (из-за этого игрока кидало в стороны) - удаляем его и все скрипты внутри модели
		for _, d in ipairs(model:GetDescendants()) do
			if d:IsA("Humanoid") or d:IsA("Animator") or d:IsA("BaseScript") then
				d:Destroy()
			end
		end
		groot.Anchored = true
		model.PrimaryPart = groot
		model.Parent = workspace
		skinGhost = model
		skinCollectReal()
		skin.conn = RunService.RenderStepped:Connect(skinStep)
		SkinMod.setStatus("Output", "Applied", C_OK)
	end)
end

SkinMod = Module({
	name = "Skinchanger",
	key = Enum.KeyCode.L,
	settings = {
		{type = "input", name = "Output", placeholder = "Roblox username", default = ""},
	},
	onToggle = function(on)
		if on then
			skinApply(SkinMod.v.Output)
		else
			skin.ticket += 1
			skinDestroyGhost()
			local hum = getHumanoid()
			if hum and skin.origDesc then
				pcall(function()
					hum:ApplyDescription(skin.origDesc)
				end)
			end
			skin.origDesc = nil
			SkinMod.setStatus("Output", "", ACCENT)
		end
	end,
	onChange = function(name, value)
		if name == "Output" and SkinMod.enabled then
			skinApply(value)
		end
	end,
})
player.CharacterAdded:Connect(function()
	if SkinMod.enabled then
		skinDestroyGhost()
		skin.origDesc = nil
		task.wait(1.5)
		skinApply(SkinMod.v.Output)
	end
end)

--------------------------------------------------------------------
-- PLAYER: STREAMER MODE
-- Меняет ник: в UI игры (PlayerGui), над головой, в Watermark и в чате (TextChatService).
-- Системное меню Roblox (пауза, список игроков) скриптам игры недоступно -
-- список игроков можно скрыть настройкой Hide Playerlist.
--------------------------------------------------------------------
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local sm = {tracked = {}, conns = {}, applying = false, prevIncoming = nil, playerlistWas = nil}
local PH = "\u{E000}"

local function smName()
	local n = StreamerMod.v.Name
	if not n or n:match("^%s*$") then
		return "Streamer"
	end
	return n
end

local function smEsc(str)
	return (str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0"))
end

local function smReplace(str)
	local out = str
	for _, n in ipairs({player.DisplayName, player.Name}) do
		if n ~= "" and out:find(n, 1, true) then
			out = out:gsub("%f[%w_]" .. smEsc(n) .. "%f[^%w_]", PH)
		end
	end
	if out:find(PH, 1, true) then
		local nn = smName()
		out = out:gsub(PH, function()
			return nn
		end)
	end
	return out
end

local function smFix(obj)
	local t = obj.Text
	local n = smReplace(t)
	if n ~= t then
		local rec = sm.tracked[obj]
		sm.applying = true
		rec.orig, rec.repl = t, n
		obj.Text = n
		sm.applying = false
	end
end

local function smProcess(obj)
	if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then
		return
	end
	local sg = obj:FindFirstAncestorOfClass("ScreenGui")
	if sg and sg.Name:sub(1, 10) == "AreVisuals" then
		return
	end
	local rec = sm.tracked[obj]
	if not rec then
		rec = {}
		sm.tracked[obj] = rec
		rec.conn = obj:GetPropertyChangedSignal("Text"):Connect(function()
			if not sm.applying and StreamerMod.enabled then
				smFix(obj)
			end
		end)
	end
	smFix(obj)
end

local function smChat(on)
	if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
		return
	end
	if on then
		local okRead, prev = pcall(function()
			return TextChatService.OnIncomingMessage
		end)
		sm.prevIncoming = okRead and prev or nil
		pcall(function()
			TextChatService.OnIncomingMessage = function(message)
				local props
				if sm.prevIncoming then
					local okp, res = pcall(sm.prevIncoming, message)
					if okp and res then
						props = res
					end
				end
				props = props or Instance.new("TextChatMessageProperties")
				local prefix = (props.PrefixText ~= "" and props.PrefixText) or message.PrefixText
				local body = (props.Text ~= "" and props.Text) or message.Text
				local np, nb = smReplace(prefix), smReplace(body)
				if np ~= prefix then
					props.PrefixText = np
				end
				if nb ~= body then
					props.Text = nb
				end
				return props
			end
		end)
	else
		pcall(function()
			TextChatService.OnIncomingMessage = sm.prevIncoming
		end)
		sm.prevIncoming = nil
	end
end

local function smPlayerlist(hide)
	if hide then
		if sm.playerlistWas == nil then
			local ok, was = pcall(function()
				return StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
			end)
			sm.playerlistWas = ok and was or true
		end
		pcall(function()
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
		end)
	elseif sm.playerlistWas ~= nil then
		local was = sm.playerlistWas
		sm.playerlistWas = nil
		pcall(function()
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, was)
		end)
	end
end

local function smEnable()
	for _, d in ipairs(playerGui:GetDescendants()) do
		smProcess(d)
	end
	table.insert(sm.conns, playerGui.DescendantAdded:Connect(function(d)
		task.defer(smProcess, d)
	end))
	local function hook(char)
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.DisplayName = smName()
		end
		for _, d in ipairs(char:GetDescendants()) do
			smProcess(d)
		end
		table.insert(sm.conns, char.DescendantAdded:Connect(function(d)
			task.defer(smProcess, d)
		end))
	end
	if player.Character then
		hook(player.Character)
	end
	table.insert(sm.conns, player.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		if StreamerMod.enabled then
			hook(char)
		end
	end))
	smChat(true)
	if StreamerMod.v["Hide Playerlist"] then
		smPlayerlist(true)
	end
end

local function smDisable()
	for _, c in ipairs(sm.conns) do
		c:Disconnect()
	end
	sm.conns = {}
	sm.applying = true
	for obj, rec in pairs(sm.tracked) do
		if rec.conn then
			rec.conn:Disconnect()
		end
		if rec.repl and obj.Parent and obj.Text == rec.repl then
			obj.Text = rec.orig
		end
	end
	sm.applying = false
	sm.tracked = {}
	local hum = getHumanoid()
	if hum then
		hum.DisplayName = player.DisplayName
	end
	smChat(false)
	smPlayerlist(false)
end

StreamerMod = Module({
	name = "Streamer Mode",
	key = Enum.KeyCode.P,
	settings = {
		{type = "input", name = "Name", placeholder = "Fake nickname", default = "Streamer"},
		{type = "toggle", name = "Hide Playerlist", default = true},
	},
	onToggle = function(on)
		if on then
			smEnable()
		else
			smDisable()
		end
	end,
	onChange = function(name, value)
		if not StreamerMod.enabled then
			return
		end
		if name == "Hide Playerlist" then
			smPlayerlist(value)
		else
			smDisable()
			smEnable()
		end
	end,
})
shownName = function()
	if StreamerMod and StreamerMod.enabled then
		return smName()
	end
	return player.Name
end

--------------------------------------------------------------------
-- WORLD: GRAPHICS (улучшение картинки: bloom, лучи, цветокоррекция, глубина резкости, отражения)
-- "RTX" в Roblox - это набор пост-эффектов Lighting, настоящей трассировки лучей нет.
--------------------------------------------------------------------
local GFX_PRESETS = {
	{name = "RTX", colors = {Color3.fromRGB(40, 70, 120), Color3.fromRGB(255, 190, 130)},
		bloom = {0.55, 32, 0.85}, rays = {0.18, 0.75}, exposure = 0.1, softShadow = 0.15,
		cc = {Brightness = 0.02, Contrast = 0.18, Saturation = 0.2, Tint = Color3.fromRGB(255, 248, 240)},
		dof = {0.12, 150, 90}},
	{name = "Cinematic", colors = {Color3.fromRGB(20, 40, 60), Color3.fromRGB(230, 150, 90)},
		bloom = {0.4, 28, 0.9}, rays = {0.1, 0.6}, exposure = -0.1, softShadow = 0.25,
		cc = {Brightness = -0.02, Contrast = 0.25, Saturation = -0.05, Tint = Color3.fromRGB(240, 246, 255)},
		dof = {0.18, 100, 60}},
	{name = "Vibrant", colors = {Color3.fromRGB(255, 80, 150), Color3.fromRGB(80, 220, 255)},
		bloom = {0.45, 26, 0.9}, rays = {0.15, 0.7}, exposure = 0.05, softShadow = 0.15,
		cc = {Brightness = 0, Contrast = 0.12, Saturation = 0.45, Tint = WHITE},
		dof = {0.05, 150, 90}},
	{name = "Realistic", colors = {Color3.fromRGB(120, 140, 120), Color3.fromRGB(210, 205, 190)},
		bloom = {0.25, 20, 0.95}, rays = {0.08, 0.5}, exposure = 0, softShadow = 0.2,
		cc = {Brightness = 0, Contrast = 0.1, Saturation = -0.08, Tint = Color3.fromRGB(255, 252, 246)},
		dof = {0.1, 200, 120}},
	{name = "Soft Glow", colors = {Color3.fromRGB(255, 200, 220), Color3.fromRGB(255, 245, 235)},
		bloom = {1.0, 44, 0.7}, rays = {0.25, 0.9}, exposure = 0.15, softShadow = 0.3,
		cc = {Brightness = 0.04, Contrast = 0.05, Saturation = 0.15, Tint = Color3.fromRGB(255, 238, 245)},
		dof = {0.06, 150, 90}},
}

local gfx = {snap = nil, cc = nil, bloom = nil, rays = nil, dof = nil, motion = nil, tweens = {}, token = 0, lastLook = nil, mblur = 0}
local GfxMod

local function gfxCancel()
	for _, t in ipairs(gfx.tweens) do
		t:Cancel()
	end
	gfx.tweens = {}
end

local function gfxApply(smooth)
	if not gfx.cc then
		return
	end
	local p = GFX_PRESETS[GfxMod.v.Preset]
	local I = GfxMod.v.Intensity
	local lighting = {ExposureCompensation = p.exposure * I}
	if GfxMod.v.Reflections then
		lighting.EnvironmentSpecularScale = 1
		lighting.EnvironmentDiffuseScale = 1
	elseif gfx.snap then
		lighting.EnvironmentSpecularScale = gfx.snap.EnvironmentSpecularScale
		lighting.EnvironmentDiffuseScale = gfx.snap.EnvironmentDiffuseScale
	end
	if GfxMod.v["Soft Shadows"] then
		lighting.ShadowSoftness = p.softShadow
	elseif gfx.snap then
		lighting.ShadowSoftness = gfx.snap.ShadowSoftness
	end
	local targets = {
		{Lighting, lighting},
		{gfx.bloom, {Intensity = p.bloom[1] * I, Size = p.bloom[2], Threshold = p.bloom[3]}},
		{gfx.rays, {Intensity = p.rays[1] * I, Spread = p.rays[2]}},
		{gfx.cc, {Brightness = p.cc.Brightness * I, Contrast = p.cc.Contrast * I, Saturation = p.cc.Saturation * I, TintColor = WHITE:Lerp(p.cc.Tint, I)}},
		{gfx.dof, {FarIntensity = GfxMod.v["Depth of Field"] and p.dof[1] * I or 0, FocusDistance = p.dof[2], InFocusRadius = p.dof[3], NearIntensity = 0}},
	}
	gfxCancel()
	for _, pair in ipairs(targets) do
		if smooth then
			local okT, t = pcall(function()
				return TweenService:Create(pair[1], TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), pair[2])
			end)
			if okT and t then
				t:Play()
				table.insert(gfx.tweens, t)
			end
		else
			for k, v in pairs(pair[2]) do
				pcall(function()
					pair[1][k] = v
				end)
			end
		end
	end
end

GfxMod = Module({
	name = "Graphics",
	key = Enum.KeyCode.I,
	settings = {
		{type = "gallery", name = "Preset", items = GFX_PRESETS, default = 1},
		{type = "slider", name = "Intensity", min = 0, max = 1, step = 0.05, default = 0.8},
		{type = "toggle", name = "Reflections", default = true},
		{type = "toggle", name = "Soft Shadows", default = true},
		{type = "toggle", name = "Depth of Field", default = false},
		{type = "toggle", name = "Motion Blur", default = false},
	},
	onToggle = function(on)
		gfx.token += 1
		local my = gfx.token
		if on then
			gfx.snap = {}
			for _, k in ipairs({"ExposureCompensation", "EnvironmentDiffuseScale", "EnvironmentSpecularScale", "ShadowSoftness"}) do
				pcall(function()
					gfx.snap[k] = Lighting[k]
				end)
			end
			gfx.cc = new("ColorCorrectionEffect", {Name = "AreVisualsGfxCC"}, Lighting)
			gfx.bloom = new("BloomEffect", {Name = "AreVisualsGfxBloom", Intensity = 0, Size = 24, Threshold = 1}, Lighting)
			gfx.rays = new("SunRaysEffect", {Name = "AreVisualsGfxRays", Intensity = 0, Spread = 0.5}, Lighting)
			gfx.dof = new("DepthOfFieldEffect", {Name = "AreVisualsGfxDoF", FarIntensity = 0, NearIntensity = 0, FocusDistance = 100, InFocusRadius = 50}, Lighting)
			gfx.motion = new("BlurEffect", {Name = "AreVisualsGfxMotion", Size = 0}, Lighting)
			gfx.mblur = 0
			gfxApply(true)
		else
			gfxCancel()
			local cc, bloom, rays, dof, motion = gfx.cc, gfx.bloom, gfx.rays, gfx.dof, gfx.motion
			if cc then
				local info = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				if gfx.snap then
					local restore = {}
					for k, v in pairs(gfx.snap) do
						restore[k] = v
					end
					pcall(function()
						TweenService:Create(Lighting, info, restore):Play()
					end)
				end
				TweenService:Create(cc, info, {Brightness = 0, Contrast = 0, Saturation = 0, TintColor = WHITE}):Play()
				TweenService:Create(bloom, info, {Intensity = 0}):Play()
				TweenService:Create(rays, info, {Intensity = 0}):Play()
				TweenService:Create(dof, info, {FarIntensity = 0}):Play()
				motion.Size = 0
				task.delay(1.3, function()
					if gfx.token ~= my then
						return
					end
					cc:Destroy()
					bloom:Destroy()
					rays:Destroy()
					dof:Destroy()
					motion:Destroy()
					gfx.cc, gfx.bloom, gfx.rays, gfx.dof, gfx.motion = nil, nil, nil, nil, nil
				end)
			end
		end
	end,
	onChange = function(name)
		gfxApply(name ~= "Intensity")
	end,
})

-- motion blur: размытие зависит от скорости поворота камеры
RunService.RenderStepped:Connect(function(dt)
	if not (GfxMod.enabled and gfx.motion) then
		gfx.lastLook = nil
		return
	end
	local cam = workspace.CurrentCamera
	if not cam then
		return
	end
	local look = cam.CFrame.LookVector
	local target = 0
	if GfxMod.v["Motion Blur"] and gfx.lastLook and dt > 0 then
		local ang = math.acos(math.clamp(look:Dot(gfx.lastLook), -1, 1))
		target = math.clamp(ang / dt * 2.5, 0, 12)
	end
	gfx.lastLook = look
	gfx.mblur += (target - gfx.mblur) * (1 - math.exp(-dt * 12))
	gfx.motion.Size = gfx.mblur
end)

--------------------------------------------------------------------
-- WORLD: POTATO GRAPHICS (все материалы -> пластик)
--------------------------------------------------------------------
local potato = {orig = setmetatable({}, {__mode = "k"}), conn = nil, token = 0, shadowsWas = nil}
local PotatoMod

local function potatoIsMine(inst)
	local a = inst.Parent
	while a and a ~= workspace do
		local n = a.Name
		if n:sub(1, 10) == "AreVisuals" or n == "JumpCircle" or n == "JumpCircleText" then
			return true
		end
		a = a.Parent
	end
	return false
end

local function potatoApply(d)
	if not d:IsA("BasePart") or d:IsA("Terrain") then
		return
	end
	if player.Character and d:IsDescendantOf(player.Character) then
		return -- не трогаем свой персонаж (Self Chams)
	end
	if potatoIsMine(d) then
		return
	end
	if potato.orig[d] == nil then
		potato.orig[d] = {d.Material, d.MaterialVariant}
	end
	local m = PotatoMod.v.Smooth and Enum.Material.SmoothPlastic or Enum.Material.Plastic
	if d.Material ~= m then
		d.Material = m
	end
	if d.MaterialVariant ~= "" then
		d.MaterialVariant = ""
	end
end

local function potatoScanAll(my)
	local n = 0
	for _, d in ipairs(workspace:GetDescendants()) do
		if potato.token ~= my then
			return
		end
		potatoApply(d)
		n += 1
		if n % 600 == 0 then
			task.wait()
		end
	end
end

PotatoMod = Module({
	name = "Potato Graphics",
	settings = {
		{type = "toggle", name = "Smooth", default = false},
		{type = "toggle", name = "No Shadows", default = true},
	},
	onToggle = function(on)
		potato.token += 1
		local my = potato.token
		if potato.conn then
			potato.conn:Disconnect()
			potato.conn = nil
		end
		if on then
			potato.conn = workspace.DescendantAdded:Connect(function(d)
				if PotatoMod.enabled then
					potatoApply(d)
				end
			end)
			if PotatoMod.v["No Shadows"] then
				potato.shadowsWas = Lighting.GlobalShadows
				Lighting.GlobalShadows = false
			end
			task.spawn(potatoScanAll, my)
		else
			if potato.shadowsWas ~= nil then
				Lighting.GlobalShadows = potato.shadowsWas
				potato.shadowsWas = nil
			end
			task.spawn(function()
				local n = 0
				for part, o in pairs(potato.orig) do
					if potato.token ~= my then
						return
					end
					if part.Parent then
						part.Material = o[1]
						part.MaterialVariant = o[2]
					end
					potato.orig[part] = nil
					n += 1
					if n % 600 == 0 then
						task.wait()
					end
				end
			end)
		end
	end,
	onChange = function(name)
		if not PotatoMod.enabled then
			return
		end
		if name == "Smooth" then
			potato.token += 1
			task.spawn(potatoScanAll, potato.token)
		elseif name == "No Shadows" then
			if PotatoMod.v["No Shadows"] then
				if potato.shadowsWas == nil then
					potato.shadowsWas = Lighting.GlobalShadows
				end
				Lighting.GlobalShadows = false
			elseif potato.shadowsWas ~= nil then
				Lighting.GlobalShadows = potato.shadowsWas
				potato.shadowsWas = nil
			end
		end
	end,
})

--------------------------------------------------------------------
-- SCREEN: DBD MOVEMENT (визуальный эффект камеры: плавное отставание + небольшой занос)
--------------------------------------------------------------------
local dbd = {off = Vector3.zero, vel = Vector3.zero, roll = 0, conn = nil}
local DbdMod

local function dbdStep(dt)
	local cam = workspace.CurrentCamera
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not cam or not root then
		return
	end
	dt = math.min(dt, 1 / 20)
	local v = root.AssemblyLinearVelocity
	local flat = Vector3.new(v.X, 0, v.Z)
	local lagK, swayK = DbdMod.v.Lag, DbdMod.v.Sway
	-- камера отстаёт от бега; пружина с недодемпфированием даёт лёгкий перелёт ("занос")
	local target = -flat * (0.09 * lagK)
	local stiff = 55
	local damp = 2 * math.sqrt(stiff) * 0.55
	local acc = (target - dbd.off) * stiff - dbd.vel * damp
	dbd.vel += acc * dt
	dbd.off += dbd.vel * dt
	-- лёгкий крен по боковой скорости
	local lat = flat:Dot(cam.CFrame.RightVector)
	local targetRoll = math.clamp(-lat * 0.004 * swayK, -0.08, 0.08)
	dbd.roll += (targetRoll - dbd.roll) * (1 - math.exp(-dt * 6))
	cam.CFrame = (cam.CFrame + dbd.off) * CFrame.Angles(0, 0, dbd.roll)
end

DbdMod = Module({
	name = "DBD Movement",
	key = Enum.KeyCode.U,
	settings = {
		{type = "slider", name = "Lag", min = 0, max = 1, step = 0.05, default = 0.6},
		{type = "slider", name = "Sway", min = 0, max = 1, step = 0.05, default = 0.5},
	},
	onToggle = function(on)
		if dbd.conn then
			dbd.conn:Disconnect()
			dbd.conn = nil
		end
		if on then
			dbd.off, dbd.vel, dbd.roll = Vector3.zero, Vector3.zero, 0
			dbd.conn = RunService.RenderStepped:Connect(dbdStep)
		end
	end,
})
	local function destroyVisuals()
		for _, mod in ipairs(modules) do
			if mod.enabled then pcall(setEnabled, mod, false) end
		end
		hud:Destroy()
		cursorGui:Destroy()
	end
	return {
		Screen = {AspectMod, DbdMod, WatermarkMod, KeybindsMod, CursorMod},
		World = {WeatherMod, SnowMod, SkyMod, ShaderMod, GfxMod, PotatoMod, JumpMod},
		Player = {ChamsMod, HatMod, CrownMod, FrozenMod, FieryMod, AuraMod, TrailMod, PetsMod, SkinMod, StreamerMod},
		setEnabled = setEnabled,
		refreshKeybinds = refreshKeybinds,
		setAccent = setAccent,
		setWatermarkAccent = function(c) wmAccent = c end,
		setWatermarkBackground = function(c) wm.BackgroundColor3 = c end,
		setKeybindAccent = function(c) kbAccent = c; refreshKeybinds() end,
		setKeybindBackground = function(c) kb.BackgroundColor3 = c end,
		destroy = destroyVisuals,
	}
end
Krieg.Visuals = Krieg:InitVisuals()

local Window = Krieg:CreateWindow({
Title = "KRIEG",
AccentWord = "HUB",
Subtitle = "Admin Panel",
Theme = "New Year",
ToggleKey = Enum.KeyCode.RightControl,
ConfigFolder = "KriegHub",
Width = 900,
Height = 560,
})
Window:Group("OVERVIEW")
Window:CreateHome({
Badge = "KRIEG MEMBER",
Changelog = {
"New Year decor",
"Languages, fonts, wallpaper, mini bar",
"Auto Farm, Auto Training, Auto Sell",
"Teleports without falling",
"Configs and Auto Load",
},
})
Window:Group("FARM")
local FarmTab = Window:Tab({ Name = "Auto Farm", Icon = "sprout" })
local farmSec = FarmTab:Section({ Name = "Farm", Icon = "target" })
Ex.farm = farmSec:Toggle({ Name = "Auto Farm", Flag = "AutoFarm", Callback = function(v)
Exclusive("farm", v)
if not v then Stop("farm") return end
Run("farm", function(alive)
while alive() do
FarmOnce(alive)
task.wait(.2)
end
end)
end })
farmSec:Toggle({ Name = "Auto 20 Power", Flag = "Auto20Power", Callback = SetPower })
local trainSec = FarmTab:Section({ Name = "Training", Icon = "dumbbell", Side = "Right" })
Ex.train = trainSec:Toggle({ Name = "Auto Training", Flag = "AutoTraining", Callback = function(v)
Exclusive("train", v)
if not v then Stop("train") return end
Run("train", function(alive)
while alive() do
EnsureTraining(alive)
Sleep(1, alive)
end
end)
end })
trainSec:Toggle({ Name = "Auto 2x Button", Flag = "Auto2x", Callback = function(v)
if not v then Stop("x2") return end
Run("x2", function(alive)
while alive() do
local b = G.TapBonus()
if Shown(b) then
PressButton(b)
WaitUntil(function() return not Shown(G.TapBonus()) end, 1, alive)
else
task.wait(.1)
end
end
end)
end })
local equipSec = FarmTab:Section({ Name = "Equip", Icon = "shield" })
local equipInterval
equipSec:Toggle({ Name = "Auto Equip Best", Flag = "AutoEquip", Callback = function(v)
if not v then Stop("equip") return end
Run("equip", function(alive)
while alive() do
PressButton(G.EquipBest())
Sleep(equipInterval and equipInterval.Value or 10, alive)
end
end)
end })
equipInterval = equipSec:Slider({ Name = "Equip Interval", Min = 1, Max = 60, Default = 10, Suffix = "s", Flag = "EquipInterval" })
local miscSec = FarmTab:Section({ Name = "Misc", Icon = "clock", Side = "Right" })
local antiAfk = miscSec:Toggle({ Name = "Anti AFK", Flag = "AntiAFK", Callback = function(v)
if not v then Stop("afk") return end
Run("afk", function(alive)
while alive() do
if not Sleep(300, alive) then break end
Jump()
end
end)
end })
Connect(LP.Idled, function()
if antiAfk.Value then
pcall(function()
local VU = game:GetService("VirtualUser")
VU:CaptureController()
VU:ClickButton2(Vector2.new())
end)
end
end)
do
local RS = game:GetService("ReplicatedStorage")
local Up = {}
local function Inv(name, ...)
local r = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild(name)
if not r then return { Ok = false } end
local ok, res = pcall(r.InvokeServer, r, ...)
return (ok and type(res) == "table") and res or { Ok = false }
end
local function DataC()
if Up.Data == nil then
local ok, d = pcall(require, LP.PlayerScripts.Client.Controllers.DataController)
Up.Data = ok and d or false
end
return Up.Data or nil
end
local function Get(path)
local d = DataC()
if not d then return nil end
local ok, v = pcall(function() return d.GetPath and d:GetPath(path) or d:Get(path) end)
return ok and v or nil
end
local function Money()
return tonumber(Get("Money")) or 0
end
local function FoodList()
if Up.Foods ~= nil then return Up.Foods or nil end
local ok, cfg = pcall(require, RS.Config.FoodsConfig)
if not ok or type(cfg) ~= "table" then Up.Foods = false return nil end
local list = cfg.List or cfg.All or cfg.Foods or cfg
Up.Foods = (type(list) == "table" and #list > 0) and list or false
return Up.Foods or nil
end
local function PriceOf(f)
if type(f) ~= "table" then return nil end
return tonumber(f.Price or f.Cost or f.Money)
end
local function BuyFoodPass()
local list = FoodList()
if not list then return end
local cfg = Up.Cfg
if cfg == nil then
local ok, c = pcall(require, RS.Config.FoodsConfig)
cfg = ok and c or false
Up.Cfg = cfg
end
local from = (tonumber(Get("EquippedFood")) or 0) + 1
for i = from, #list do
local locked = cfg and cfg.IsLocked and select(2, pcall(cfg.IsLocked, i))
if locked == true then return end
if Get("OwnedFoods." .. i) == true then
Inv("Shop_Equip", i)
else
local price = PriceOf(list[i])
if price and Money() < price then return end
local r = Inv("Shop_Buy", i)
if r.Ok then
Inv("Shop_Equip", i)
Krieg:Notify({ Title = "Auto Upgrade", Content = "Bought food #" .. i, Icon = "cart", Duration = 2 })
end
return
end
end
end
local UpCfg = {}
local UpTab = Window:Tab({ Name = "Auto Upgrade", Icon = "upgrade" })
local function Loop(key, fn)
return function(v)
if not v then Stop(key) return end
Run(key, function(alive)
while alive() do
if not State.Throwing then pcall(fn) end
Sleep(UpCfg.Every and UpCfg.Every.Value or 3, alive)
end
end)
end
end
local claimSec = UpTab:Section({ Name = "Auto Claim", Icon = "check", Side = "Right" })
local function Slow(key, fn)
return function(v)
if not v then Stop(key) return end
Run(key, function(alive)
while alive() do
pcall(fn)
Sleep(60, alive)
end
end)
end
end
claimSec:Toggle({ Name = "Auto Claim Offline Earnings", Flag = "ClaimOffline", Callback = Slow("cloffline", function()
if Inv("Offline_Claim").Ok then Krieg:Notify({ Title = "Auto Claim", Content = "Offline earnings claimed", Icon = "dollar", Duration = 2 }) end
end) })
claimSec:Toggle({ Name = "Auto Claim Free Shop Reward", Flag = "ClaimFree", Callback = Slow("clfree", function()
if Inv("Shop_ClaimFree").Ok then Krieg:Notify({ Title = "Auto Claim", Content = "Free reward claimed", Icon = "gift", Duration = 2 }) end
end) })
local buySec = UpTab:Section({ Name = "Buy", Icon = "cart" })
buySec:Toggle({ Name = "Auto Buy Food", Flag = "UpFood2", Callback = Loop("upfood", BuyFoodPass) })
buySec:Toggle({ Name = "Auto Buy Plot", Flag = "UpFence2", Callback = Loop("upfence", function()
if Inv("Plot_UpgradeFence").Ok then
Krieg:Notify({ Title = "Auto Upgrade", Content = "Plot upgraded", Icon = "home", Duration = 2 })
end
end) })
buySec:Label("Food: buys the next better food as soon as you have the money and equips it")
local upSec = UpTab:Section({ Name = "Upgrade", Icon = "dumbbell", Side = "Right" })
upSec:Toggle({ Name = "Auto Upgrade Pull-Up Bar", Flag = "UpStand2", Callback = Loop("upstand", function()
if Inv("Stand_Upgrade").Ok then
Krieg:Notify({ Title = "Auto Upgrade", Content = "Pull-up bar upgraded", Icon = "dumbbell", Duration = 2 })
end
end) })
local setSec = UpTab:Section({ Name = "Settings", Icon = "settings" })
UpCfg.Every = setSec:Slider({ Name = "Check Every", Min = 1, Max = 30, Default = 3, Suffix = "s", Flag = "UpEvery" })
setSec:Button({ Name = "Upgrade Everything Now", Icon = "zap", Primary = true, Callback = function()
task.spawn(function()
pcall(BuyFoodPass)
Inv("Plot_UpgradeFence")
Inv("Stand_Upgrade")
Krieg:Notify({ Title = "Auto Upgrade", Content = "Done", Icon = "check", Duration = 2 })
end)
end })
local skipSec = FarmTab:Section({ Name = "Fast Throw", Icon = "clock" })
skipSec:Toggle({ Name = "Skip Throw Animation", Flag = "FastSkip", Callback = function(v)
if not v then Stop("skip") return end
task.spawn(function()
Inv("Player_SetSetting", "AutoSkip", true)
end)
Run("skip", function(alive)
while alive() do
local cam = workspace.CurrentCamera
if cam and cam.CFrame.Position.Z < -150 then
ClickScreen()
task.wait(.25)
else
task.wait(.15)
end
end
end)
end })
skipSec:Label("Clicks through the flight and the reveal so throws go faster")
end
local SellTab = Window:Tab({ Name = "Auto Sell", Icon = "cart" })
local sell = SellTab:Section({ Name = "Auto Sell", Icon = "dollar" })
local sellInterval
sell:Toggle({ Name = "Auto Sell", Flag = "AutoSell", Callback = function(v)
if not v then Stop("sell") return end
Run("sell", function(alive)
while alive() do
if not State.Throwing then SellPass(alive) end
Sleep(sellInterval and sellInterval.Value or 30, alive)
end
end)
end })
sellInterval = sell:Slider({ Name = "Sell Interval", Min = 5, Max = 120, Default = 30, Suffix = "s", Flag = "SellInterval" })
sell:Button({ Name = "Sell Now", Icon = "dollar", Primary = true, Callback = function()
SellPass(function() return Krieg.Gui ~= nil and Krieg.Gui.Parent ~= nil end)
end })
local filter = SellTab:Section({ Name = "Filter", Icon = "target", Side = "Right" })
SellCfg.MinIncome = filter:Input({ Name = "Sell If Income Below", Placeholder = "2.5Qad", Default = "0", Flag = "MinIncome" })
filter:Label("K · M · B · T · Qa · Qi · Sx · Sp · Oc · No · Dc · Ud · Dd · Td · Qad")
SellCfg.KeepMutations = filter:Toggle({ Name = "Keep Mutations", Default = true, Flag = "KeepMutations" })
do
local RS = game:GetService("ReplicatedStorage")
local Ix = { Mods = nil, Last = nil }
local IxCfg = {}
local function Mods()
if Ix.Mods then return Ix.Mods end
local m = {}
local ok = pcall(function()
m.Areas = require(RS.Config.AreasConfig)
m.Area = require(RS.Shared.AreaUtil)
m.Game = require(RS.Config.GameConfig)
m.Level = require(RS.Config.LevelConfig)
m.Animals = require(RS.AnimalsData)
m.Rewards = require(RS.Config.IndexRewardsConfig)
m.Data = require(LP.PlayerScripts.Client.Controllers.DataController)
end)
if not ok then return nil end
Ix.Mods = m
return m
end
local function Inv(name, ...)
local r = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild(name)
if not r then return { Ok = false } end
local ok, res = pcall(r.InvokeServer, r, ...)
return (ok and type(res) == "table") and res or { Ok = false }
end
local function Index()
local m = Mods()
local ok, v = pcall(function() return m.Data:Get("Index") end)
return (ok and type(v) == "table") and v or {}
end
local function PowerRange()
local m = Mods()
local lv = 1
pcall(function() lv = m.Data:Get("Level") or 1 end)
local hi = m.Level.ThrowPowerForLevel(lv)
return math.min(m.Level.MinThrowPower, hi), hi
end
local function Missing(key)
local m = Mods()
local list = m.Animals[key]
if type(list) ~= "table" then return 0, 0 end
local idx, miss = Index(), 0
for _, a in ipairs(list) do
if not idx[a.ModelName or a.Name] then miss += 1 end
end
return miss, #list
end
local function PowerFor(geoArea)
local m = Mods()
local launchZ = m.Area.GetLaunchPosition().Z
local margin = m.Game.Throw.LandingEdgeMargin or 8
local bonus = m.Game.Throw.MeterBonusStuds or 0
local depth = (IxCfg.Depth and IxCfg.Depth.Value or 90) / 100
local lo, hi = PowerRange()
local len = math.max(geoArea.ZStart - geoArea.ZEnd, 1)
local edge = margin + bonus / 2 + 3
local z = geoArea.ZStart - math.clamp(len * depth, math.min(edge, len / 2), math.max(len - edge, len / 2))
local p = math.floor(launchZ - z - bonus / 2)
if p >= hi then
local _, idx = m.Area.ComputeLanding(hi + bonus, 0)
local _, idxMin = m.Area.ComputeLanding(hi, 0)
if idx == geoArea.Index and idxMin == geoArea.Index then return 0 end
return nil
end
return math.max(p, lo)
end
local function PickArea()
local m = Mods()
local want = IxCfg.Zone and IxCfg.Zone.Value or "Best"
local best, bestP, bestScore
for i, a in ipairs(m.Area.GetAll()) do
local miss = Missing(a.Key)
if miss > 0 and (want == "Best" or want == a.Key) then
local p = PowerFor(a)
if p then
local score = miss * 1000 + i
if not bestScore or score > bestScore then best, bestP, bestScore = a, p, score end
end
end
end
return best, bestP
end
local function SetPower(p)
if Ix.Last == p then return end
if Inv("Player_SetThrowPower", p).Ok then Ix.Last = p end
end
local function CollectionKeys()
local m = Mods()
local keys, seen = {}, {}
local function scan(t, d)
if type(t) ~= "table" or d > 3 then return end
if type(t.Key) == "string" and (t.Trail or t.Area or t.Tab) and not seen[t.Key] then
seen[t.Key] = true
table.insert(keys, t.Key)
end
for _, v in pairs(t) do if type(v) == "table" then scan(v, d + 1) end end
end
scan(m.Rewards, 0)
return keys
end
local function ClaimAll()
if not Mods() then return 0 end
local n = 0
for _, k in ipairs(CollectionKeys()) do
local r = Inv("IndexRewards_Claim", k)
if r.Ok then
n += 1
Krieg:Notify({ Title = "Auto Index", Content = "Claimed " .. k .. " reward", Icon = "check", Duration = 3 })
end
end
return n
end
local IndexTab = Window:Tab({ Name = "Auto Index", Icon = "book" })
local is = IndexTab:Section({ Name = "Index Hunter", Icon = "target" })
Ex.index = is:Toggle({ Name = "Auto Index", Flag = "AutoIndex", Callback = function(v)
Exclusive("index", v)
if not v then
Stop("index")
Ix.Last = nil
task.spawn(Inv, "Player_SetThrowPower", 0)
return
end
if not Mods() then
Krieg:Notify({ Title = "Auto Index", Content = "Game modules not found", Icon = "x", Duration = 4 })
return
end
Run("index", function(alive)
local lastKey
while alive() do
local area, p = PickArea()
if not area then
Krieg:Notify({ Title = "Auto Index", Content = "Everything in reach is collected!", Icon = "check", Duration = 5 })
Sleep(30, alive)
else
if lastKey ~= area.Key then
lastKey = area.Key
Krieg:Notify({ Title = "Auto Index", Content = "Hunting in " .. tr(area.Name or area.Key), Icon = "target", Duration = 3 })
end
SetPower(p)
FarmOnce(alive)
if IxCfg.Claim and IxCfg.Claim.Value then pcall(ClaimAll) end
end
task.wait(.2)
end
end)
end })
IxCfg.Zone = is:Dropdown({ Name = "Zone", Options = { "Best", "Forest", "Savana", "Desert", "Jungle", "Ocean", "Mountains", "Taiga", "Winter", "PrehistoricForest", "DeepWaters", "Hell", "AncientRuins", "MythicalParadise", "ShadowRealm", "HarvestFields", "PhantomHarbor", "NuclearWasteland", "CursedCarnival", "EclipseKingdom" }, Default = "Best", Flag = "IndexZone" })
IxCfg.Depth = is:Slider({ Name = "Throw Depth", Min = 10, Max = 95, Default = 90, Suffix = "%", Flag = "IndexDepth" })
IxCfg.Claim = is:Toggle({ Name = "Auto Claim Index Rewards", Default = true, Flag = "IndexClaim" })
is:Button({ Name = "Claim Rewards Now", Icon = "check", Primary = true, Callback = function()
task.spawn(function()
if ClaimAll() == 0 then Krieg:Notify({ Title = "Auto Index", Content = "Nothing to claim yet", Icon = "clock", Duration = 2 }) end
end)
end })
is:Label("Picks the zone with the most uncaught animals you can reach and throws deep into it")
local ps = IndexTab:Section({ Name = "Progress", Icon = "book", Side = "Right" })
local lTotal = ps:Label("…", ""):Center()
local lTarget = ps:Label("…", ""):Center()
local lZones = ps:Label("…", ""):Center()
task.spawn(function()
while Krieg.Gui and Krieg.Gui.Parent do
if IndexTab.Page.Visible and Krieg.Window then
pcall(function()
local m = Mods()
if not m then lTotal:Set("Game modules not found") return end
local got, all = 0, 0
local rows = {}
for _, a in ipairs(m.Area.GetAll()) do
local miss, n = Missing(a.Key)
got += n - miss
all += n
if miss > 0 and #rows < 6 then
table.insert(rows, (a.Name or a.Key) .. ": " .. (n - miss) .. "/" .. n .. (PowerFor(a) and "" or " (too far)"))
end
end
lTotal:Set("Index: " .. got .. " / " .. all)
local area = PickArea()
lTarget:Set(area and ("Target: " .. (area.Name or area.Key)) or "Target: nothing left in reach")
lZones:Set(#rows > 0 and table.concat(rows, "\n") or "All zones complete")
end)
end
task.wait(1.5)
end
end)
end
do
local Feast = { LastPrime = 0, WasActive = false, LastCook = 0, LastClaim = 0 }
local EventTab = Window:Tab({ Name = "Event", Icon = "gift" })
local es = EventTab:Section({ Name = "Thanksgiving Feast", Icon = "sparkles" })
local FeastShared = require(game:GetService("ReplicatedStorage").Shared.Thanksgiving)
local function FeastGui()
local pg = LP:FindFirstChild("PlayerGui")
return pg and pg:FindFirstChild("ThanksgivingEvent")
end

local function FindWorld(name)
return workspace:FindFirstChild(name, true)
end

local function ThanksgivingPicnic()
return workspace:FindFirstChild("ThanksgivingPicnic")
end

local function TurkeyChef()
local picnic = ThanksgivingPicnic()
return picnic and picnic:FindFirstChild("TurkeyChef") or nil
end

local function PartOf(obj)
if not obj then return nil end
if obj:IsA("BasePart") then return obj end
if obj:IsA("Model") and obj.PrimaryPart then return obj.PrimaryPart end
return obj:FindFirstChildWhichIsA("BasePart", true)
end

local function FeastPrompt(name)
local chef = TurkeyChef()
if not chef then return nil end
local anchor = chef:FindFirstChild(name .. "Anchor")
return (anchor and anchor:FindFirstChild(name)) or chef:FindFirstChild(name, true)
end

local function FeastTimerText()
local state = FeastShared.State()
local target = state.Active and state.RunEnd or state.NextStart
if not target then return state.Ended and "Feast ended" or "Timer unavailable" end
local seconds = math.max(0, math.floor(target - workspace:GetServerTimeNow()))
return (state.Active and "FEAST ENDS IN " or "NEXT FEAST IN ") .. string.format("%d:%02d", math.floor(seconds / 60), seconds % 60)
end
local function FeastActive()
return FeastShared.IsActive()
end

local function FeastTarget()
local chef = TurkeyChef()
if chef then
local root = chef:FindFirstChild("RootPart") or chef.PrimaryPart or PartOf(chef)
if root then return root end
end
local picnic = ThanksgivingPicnic()
if picnic then
local tableModel = picnic:FindFirstChild("Picnictable") or picnic:FindFirstChild("PicnicTable")
local part = PartOf(tableModel) or PartOf(picnic)
if part then return part end
end
for _, name in ipairs({ "PicnicBasketFull", "PicnicTableWithBell", "CookStandWallDecor" }) do
local part = PartOf(FindWorld(name))
if part then return part end
end
end

local function TriggerFeastPrompt(prompt, alive)
if not prompt or typeof(fireproximityprompt) ~= "function" then return false end
local part = PartOf(prompt.Parent)
if part then
SafeTP(part)
if alive then Sleep(.35, alive) else task.wait(.35) end
end
local ok = pcall(function()
prompt.HoldDuration = 0
fireproximityprompt(prompt)
end)
return ok
end

local function PrimeFeast(alive, force)
local now = os.clock()
if not force and now - Feast.LastPrime < 30 then return false end
Feast.LastPrime = now
local active = FeastActive()
local openPrompt = FeastPrompt("OpenPrompt")
local talkPrompt = FeastPrompt("TalkPrompt")
local prompt
if active then
prompt = (openPrompt and openPrompt.Enabled and openPrompt)
or (talkPrompt and talkPrompt.Enabled and talkPrompt)
or openPrompt or talkPrompt
else
prompt = (talkPrompt and talkPrompt.Enabled and talkPrompt)
or (openPrompt and openPrompt.Enabled and openPrompt)
or talkPrompt or openPrompt
end
return TriggerFeastPrompt(prompt, alive)
end

local INGREDIENTS = {
{ "Cranberry Sauce", "Pile1CranberrySauce" },
{ "Sweet Potato", "Pile2SweetPotato" },
{ "Cornbread", "Pile3Cornbread" },
{ "Stuffing", "Pile4Stuffing" },
}

local function IngredientProgress()
local gui = FeastGui()
if not gui then return "Event GUI unavailable" end
return "Sweet Potato: " .. tostring(gui:GetAttribute("SweetPotato") or 0)
.. " | Cranberry: " .. tostring(gui:GetAttribute("Cranberry") or 0)
.. " | Cornbread: " .. tostring(gui:GetAttribute("Cornbread") or 0)
end

local function FeastActions()
local gui = FeastGui()
if not gui then return end
local now = os.clock()
local total = (gui:GetAttribute("SweetPotato") or 0)
 + (gui:GetAttribute("Cranberry") or 0)
 + (gui:GetAttribute("Cornbread") or 0)
local cook = gui:FindFirstChild("CookRequested")
if cook and cook:IsA("BindableEvent") and total >= 3 and now - Feast.LastCook >= 5 then
local order = total >= 9 and 3 or total >= 6 and 2 or 1
Feast.LastCook = now
cook:Fire(order)
end
if now - Feast.LastClaim >= 5 then
local claim = gui:FindFirstChild("ClaimRequested")
local gobbler = gui:FindFirstChild("GobblerClaimRequested")
if (gui:GetAttribute("ChefClaimable") or 0) > 0 and claim and claim:IsA("BindableEvent") then
claim:Fire()
Feast.LastClaim = now
elseif gui:GetAttribute("GobblerReady") == true and gobbler and gobbler:IsA("BindableEvent") then
gobbler:Fire()
Feast.LastClaim = now
end
end
end

Ex.event = es:Toggle({ Name = "Auto Feast Farm", Flag = "AutoFeast", Callback = function(v)
Exclusive("event", v)
if not v then Stop("event") return end
Feast.WasActive = false
Feast.LastPrime = 0
Run("event", function(alive)
while alive() do
local active = FeastActive()
if active then
if not Feast.WasActive then
local feastPart = FeastTarget()
if feastPart then
SafeTP(feastPart)
Sleep(.5, alive)
end
end
FeastActions()
Sleep(2, alive)
else
Sleep(2, alive)
end
Feast.WasActive = active
task.wait(.2)
end
end)
end })
es:Label("Waits for the real Feast, teleports to the chef, cooks and claims rewards.")

local act = EventTab:Section({ Name = "Feast Actions", Icon = "target", Side = "Right" })
act:Toggle({ Name = "Auto Turkey Chef", Flag = "FeastInteract", Callback = function(v)
if not v then Stop("feastInteract") return end
Run("feastInteract", function(alive)
while alive() do
if FeastActive() then PrimeFeast(alive, true) end
Sleep(10, alive)
end
end)
end })
act:Button({ Name = "Open Turkey Chef", Icon = "mouse-pointer-click", Primary = true, Callback = function()
if not PrimeFeast(nil, true) then
Krieg:Notify({ Title = "Thanksgiving Feast", Content = "Turkey Chef prompt not found", Icon = "x", Duration = 3 })
end
end })
act:Button({ Name = "Teleport to Feast", Icon = "navigation", Callback = function()
local part = FeastTarget()
if part then
SafeTP(part)
else
Krieg:Notify({ Title = "Thanksgiving Feast", Content = "Feast area not found", Icon = "x", Duration = 3 })
end
end })
act:Button({ Name = "Refresh Feast Status", Icon = "refresh", Callback = function()
Krieg:Notify({ Title = "Thanksgiving Feast", Content = FeastTimerText() or "Feast timer not found", Icon = "clock", Duration = 3 })
end })

local ss = EventTab:Section({ Name = "Status", Icon = "clock" })
local lState = ss:Label("…", "")
local lTimer = ss:Label("…", "")
local lIngredients = ss:Label("…", "")
task.spawn(function()
while Krieg.Gui and Krieg.Gui.Parent do
if EventTab.Page.Visible and Krieg.Window then
pcall(function()
local active = FeastActive()
lState:Set(active and "FEAST ACTIVE — animals are collecting" or "Waiting for the next Feast")
lTimer:Set(FeastTimerText() or "Timer unavailable")
lIngredients:Set(active and IngredientProgress() or "Ingredients appear when the Feast starts")
end)
end
task.wait(1)
end
end)
end
do
local RS = game:GetService("ReplicatedStorage")
local St = {}
local function DataC()
if St.Data == nil then
local ok, d = pcall(require, LP.PlayerScripts.Client.Controllers.DataController)
St.Data = ok and d or false
end
return St.Data or nil
end
local function Get(k)
local d = DataC()
if not d then return nil end
local ok, v = pcall(d.Get, d, k)
return ok and v or nil
end
local function Count(t)
local n = 0
if type(t) == "table" then for _ in pairs(t) do n += 1 end end
return n
end
local NAMES = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", "Vg" }
local function Fmt(n)
n = tonumber(n) or 0
local neg = n < 0
n = math.abs(n)
local i = 1
while n >= 1000 and i < #NAMES do n /= 1000; i += 1 end
local s = (n >= 100 and string.format("%.0f", n)) or (n >= 10 and string.format("%.1f", n)) or string.format("%.2f", n)
return (neg and "-" or "") .. "$" .. s .. NAMES[i]
end
local function Snapshot()
St.T0 = os.clock()
St.Money0 = tonumber(Get("Money")) or 0
St.Index0 = Count(Get("Index"))
St.Tokens0 = 0
St.Throws = 0
end
Snapshot()
task.spawn(function()
local far = false
while Krieg.Gui and Krieg.Gui.Parent do
local cam = workspace.CurrentCamera
local z = cam and cam.CFrame.Position.Z or 0
if z < -200 then
far = true
elseif far then
far = false
St.Throws += 1
end
task.wait(.1)
end
end)
local StatsTab = Window:Tab({ Name = "Stats", Icon = "activity" })
local sess = StatsTab:Section({ Name = "Session", Icon = "clock" })
local lTime = sess:Label("…", "")
local lMoney = sess:Label("…", "")
local lRate = sess:Label("…", "")
local lThrows = sess:Label("…", "")
sess:Button({ Name = "Reset Session", Icon = "refresh", Callback = Snapshot })
local prog = StatsTab:Section({ Name = "Progress", Icon = "activity", Side = "Right" })
local lIndex = prog:Label("…", "")
local lTokens = prog:Label("…", "")
local lLevel = prog:Label("…", "")
task.spawn(function()
while Krieg.Gui and Krieg.Gui.Parent do
if StatsTab.Page.Visible and Krieg.Window then
pcall(function()
local dt = math.max(os.clock() - St.T0, 1)
local h, m, sec = math.floor(dt / 3600), math.floor(dt / 60) % 60, math.floor(dt) % 60
lTime:Set(string.format("Session time: %d:%02d:%02d", h, m, sec))
local money = tonumber(Get("Money")) or 0
local gained = money - St.Money0
lMoney:Set("Money earned: " .. Fmt(gained) .. "  (now " .. Fmt(money) .. ")")
lRate:Set("Per hour: " .. Fmt(gained / dt * 3600))
lThrows:Set("Throws: " .. St.Throws .. "  ·  " .. string.format("%.1f", St.Throws / dt * 3600) .. " / hour")
local idx = Count(Get("Index"))
lIndex:Set("Index: " .. idx .. "  (+" .. (idx - St.Index0) .. " this session)")
lTokens:Set("Feast: open the Event tab for live progress")
lLevel:Set("Level: " .. tostring(Get("Level") or "?") .. "  ·  Throw power: " .. tostring(LP:FindFirstChild("leaderstats") and LP.leaderstats:FindFirstChild("Throw Power") and LP.leaderstats["Throw Power"].Value or "?"))
end)
end
task.wait(1)
end
end)
end
Window:Group("WORLD")
local TpTab = Window:Tab({ Name = "Teleport", Icon = "pin" })
local tp = TpTab:Section({ Name = "Places", Icon = "navigation" })
tp:Tiles({
{ Name = "Starter Area", Icon = "home", Callback = function() SafeTP(Places.Starter()) end },
{ Name = "Training Spot", Icon = "dumbbell", Callback = function() SafeTP(Places.Training()) end },
{ Name = "Placement Marker", Icon = "target", Callback = function() SafeTP(Places.Placement()) end },
{ Name = "Sell Place", Icon = "cart", Callback = function() SafeTP(Places.SellPad()) end },
{ Name = "Thanksgiving Feast", Icon = "sparkles", Callback = function()
local picnic = workspace:FindFirstChild("ThanksgivingPicnic")
local chef = picnic and picnic:FindFirstChild("TurkeyChef")
local pad = chef and (chef:FindFirstChild("RootPart") or chef.PrimaryPart or chef:FindFirstChildWhichIsA("BasePart", true))
if pad then SafeTP(pad) else Krieg:Notify({ Title = "Teleport", Content = "Turkey Chef not found", Icon = "x", Duration = 2 }) end
end },
}, 2)
do
local TG_LINK = "https://t.me/KREVETKASCRIPTS"
local TG_NAME = "KREVETKA SCRIPTS"
Icons.send = { P(22, 2, 11, 13), P(22, 2, 15, 22, 11, 13, 2, 9, 22, 2) }
local function CopyTG(silent)
local ok = typeof(setclipboard) == "function" and pcall(setclipboard, TG_LINK)
if not ok and typeof(toclipboard) == "function" then ok = pcall(toclipboard, TG_LINK) end
if not silent then
if ok then
Krieg:Notify({ Title = "Done", Content = "Link copied to clipboard", Icon = "check" })
else
Krieg:Notify({ Title = "Link", Content = TG_LINK, Duration = 8, Icon = "link" })
end
end
return ok
end
local TGAvatar = { image = nil, waiting = {} }
local function SetTGAvatar(img, fallbackHolder)
if TGAvatar.image then img.Image = TGAvatar.image return end
table.insert(TGAvatar.waiting, { img, fallbackHolder })
end
task.spawn(function()
Krieg:ResolveWallpaper(TG_LINK, function(ok, res)
if not ok then return end
TGAvatar.image = res
for _, w in ipairs(TGAvatar.waiting) do
if w[1].Parent then
w[1].Image = res
if w[2] then w[2].Visible = false end
end
end
end)
end)
local function AvatarCircle(parent, size, pos)
local ring = Create("Frame", { Size = UDim2.fromOffset(size, size), Position = pos or UDim2.new(), BackgroundColor3 = WHITE, Parent = parent }, { Round() })
ThemeGrad(ring, 0, 80)
local inner = Create("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.new(1, -4, 1, -4), BackgroundColor3 = Color3.fromRGB(42, 171, 238), ClipsDescendants = true, Parent = ring }, { Round() })
local plane = Centered(BuildIcon(inner, "send", math.floor(size * .48), WHITE, math.max(1.4, size / 22)))
local img = Create("ImageLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = "", ScaleType = Enum.ScaleType.Crop, Parent = inner }, { Round() })
SetTGAvatar(img, plane.Frame)
return ring
end
-- Вкладки визуалов внутри оригинального окна Krieg Hub.
function Krieg:AddVisualTabs(window)
	local visual = self.Visuals
	if not visual then return end

	local function colorToHex(color)
		return string.format("#%02X%02X%02X", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	end
	local function hexToColor(value)
		local hex = tostring(value):gsub("%s", ""):gsub("#", "")
		if #hex ~= 6 or not hex:match("^%x+$") then return nil end
		return Color3.fromRGB(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16))
	end
	local function addColor(section, name, initial, apply, flag)
		local input
		input = section:Input({
			Name = name .. " (#RRGGBB)", Default = colorToHex(initial), Placeholder = "#RRGGBB", Flag = flag,
			Callback = function(value)
				local color = hexToColor(value)
				if color then
					apply(color)
					input:Set(colorToHex(color), true)
				else
					Krieg:Notify({Title = name, Content = "Use a color like #40E0D0", Icon = "x", Duration = 3})
				end
			end,
		})
		return input
	end
	local function addModule(tab, mod)
		local section = tab:Section({Name = mod.name, Icon = "sparkles"})
		local flagPrefix = "Visual" .. mod.name:gsub("%W", "")
		local enableControl
		if not mod.noToggle then
			enableControl = section:Toggle({Name = "Enabled", Default = mod.enabled, Flag = flagPrefix .. "Enabled", Callback = function(on)
				local ok, err = pcall(visual.setEnabled, mod, on)
				if not ok then
					pcall(visual.setEnabled, mod, not on)
					mod.enabled = not on
					enableControl:Set(not on, true)
					Krieg:Notify({Title = mod.name, Content = tostring(err), Icon = "x", Duration = 5})
				end
			end})
		end
		for _, setting in ipairs(mod.settings) do
			local name = setting.name
			local current = mod.v[name]
			local settingFlag = flagPrefix .. name:gsub("%W", "")
			if setting.type == "toggle" then
				section:Toggle({Name = name, Default = current, Flag = settingFlag, Callback = function(v) mod.changed(name, v) end})
			elseif setting.type == "slider" or setting.type == "stepped" then
				section:Slider({Name = name, Min = setting.min, Max = setting.max, Increment = setting.step or 1, Default = current, Flag = settingFlag, Callback = function(v) mod.changed(name, v) end})
			elseif setting.type == "list" then
				local options = setting.options
				section:Dropdown({Name = name, Options = options, Default = options[current], Flag = settingFlag, Callback = function(v)
					local index = table.find(options, v)
					if index then mod.changed(name, index) end
				end})
			elseif setting.type == "gallery" then
				local options = {}
				for index, item in ipairs(setting.items) do options[index] = tostring(item.name or item.Name or index) end
				section:Dropdown({Name = name, Options = options, Default = options[current], Flag = settingFlag, Callback = function(v)
					local index = table.find(options, v)
					if index then mod.changed(name, index) end
				end})
			elseif setting.type == "color" then
				addColor(section, name, current, function(color) mod.changed(name, color) end, settingFlag)
			elseif setting.type == "input" then
				section:Input({Name = name, Default = current, Placeholder = setting.placeholder or "...", Flag = settingFlag, Callback = function(v) mod.changed(name, v) end})
			end
		end
		if not mod.noBind and mod.key then
			section:Keybind({Name = "Bind", Default = mod.key, Flag = flagPrefix .. "Bind", Changed = function(key)
				mod.key = key
				visual.refreshKeybinds()
			end, Callback = function()
				if enableControl then enableControl:Set(not enableControl.Value) end
			end})
		end
	end

	window:Group("VISUALS")
	local screenTab = window:Tab({Name = "Visual Screen", Icon = "monitor"})
	local worldTab = window:Tab({Name = "Visual World", Icon = "sun"})
	local playerTab = window:Tab({Name = "Visual Player", Icon = "user"})
	for _, mod in ipairs(visual.Screen) do addModule(screenTab, mod) end
	for _, mod in ipairs(visual.World) do addModule(worldTab, mod) end
	for _, mod in ipairs(visual.Player) do addModule(playerTab, mod) end

	local hudTab = window:Tab({Name = "Visual HUD", Icon = "eye"})
	local style = hudTab:Section({Name = "Accent", Icon = "sparkles"})
	addColor(style, "Visual accent", Color3.fromRGB(72, 226, 192), visual.setAccent, "VisualHUDAccent")
	local watermark = hudTab:Section({Name = "Watermark", Icon = "monitor"})
	addColor(watermark, "Accent", Color3.fromRGB(72, 226, 192), visual.setWatermarkAccent, "VisualWatermarkAccent")
	addColor(watermark, "Background", Color3.fromRGB(140, 172, 198), visual.setWatermarkBackground, "VisualWatermarkBackground")
	local binds = hudTab:Section({Name = "Keybinds", Icon = "eye"})
	addColor(binds, "Accent", Color3.fromRGB(72, 226, 192), visual.setKeybindAccent, "VisualKeybindAccent")
	addColor(binds, "Background", Color3.fromRGB(16, 20, 24), visual.setKeybindBackground, "VisualKeybindBackground")
end

Krieg:AddVisualTabs(Window)

Window:Group("YOU")
Window:CreateSettings()
do
local LOADER_URL = "https://raw.githubusercontent.com/zuzinn888-star/THROWFOODFOR/refs/heads/main/KriegHub_protected5.lua"
local LOADER = 'loadstring(game:HttpGet("' .. LOADER_URL .. '"))()\n'
local ar = Krieg.SettingsTab and Krieg.SettingsTab:Section({ Name = "Auto Run", Icon = "power" })
if ar then
local ready = false
ar:Toggle({ Name = "Run on join", Flag = "AutoRun", Default = S.AutoRun, Callback = function(v)
Store.set("AutoRun", v)
if not v or not ready then return end
pcall(setclipboard, LOADER)
Krieg:Notify({ Title = "Auto Run", Content = "Loader copied — paste it into Real → Auto-Execute", Icon = "copy", Duration = 6 })
end })
ar:Label("Also restarts the menu by itself after teleports and rejoins")
ready = true
end
local qot = queue_on_teleport or (syn and syn.queue_on_teleport)
if typeof(qot) == "function" then
Connect(LP.OnTeleport, function(st)
if st == Enum.TeleportState.Started and Krieg.Flags.AutoRun and Krieg.Flags.AutoRun.Value then pcall(qot, LOADER) end
end)
end
end
local AboutTab = Window:Tab({ Name = "About Us", Icon = "info" })
local creator = AboutTab:Section({ Name = "Creator", Icon = "user" })
do
local card = Create("Frame", { Size = UDim2.new(1, 0, 0, 72), BackgroundTransparency = 1, Parent = creator.Content })
AvatarCircle(card, 60, UDim2.fromOffset(0, 6))
Text(card, TG_NAME, 17, "Text", FONT.Heavy, { Position = UDim2.fromOffset(74, 10), Size = UDim2.new(1, -74, 0, 22), NoTr = true })
Text(card, "Telegram channel", 12, "Sub", FONT.Med, { Position = UDim2.fromOffset(74, 32), Size = UDim2.new(1, -74, 0, 16) })
Text(card, "t.me/KREVETKASCRIPTS", 12, "Accent", FONT.Semi, { Position = UDim2.fromOffset(74, 50), Size = UDim2.new(1, -74, 0, 16), NoTr = true })
end
creator:Paragraph("Krieg Hub", "Subscribe to the channel — regular updates come out there")
creator:Button({ Name = "Copy link", Icon = "copy", Primary = true, Callback = function() CopyTG(false) end })
local aboutInfo = AboutTab:Section({ Name = "Krieg Hub", Icon = "info", Side = "Right" })
aboutInfo:Paragraph("Krieg Hub", "Thanks for using our menu!")
local function ShowTGPopup()
local gui = Krieg.Gui
if not gui then return end
local holder = Create("TextButton", {
Name = "TGPopup", AnchorPoint = Vector2.new(.5, 1), Position = UDim2.new(.5, 0, 1, 90),
Size = UDim2.fromOffset(360, 66), Text = "", AutoButtonColor = false, ZIndex = 60, Parent = gui,
}, { Corner(16) })
Bind(holder, "BackgroundColor3", "Card")
VerticalSheen(holder, .12)
local st = Create("UIStroke", { Color = WHITE, Thickness = 1.5, Parent = holder })
ThemeGrad(st, 0, 90)
local sc = Create("UIScale", { Scale = math.clamp((workspace.CurrentCamera.ViewportSize.X - 20) / 380, .7, 1), Parent = holder })
AvatarCircle(holder, 46, UDim2.fromOffset(10, 10))
Text(holder, TG_NAME, 14, "Text", FONT.Heavy, { Position = UDim2.fromOffset(66, 10), Size = UDim2.new(1, -80, 0, 18), NoTr = true, TextTruncate = Enum.TextTruncate.AtEnd })
Text(holder, "Subscribe to the channel — regular updates come out there", 11, "Sub", FONT.Med, { Position = UDim2.fromOffset(66, 29), Size = UDim2.new(1, -80, 0, 14), TextTruncate = Enum.TextTruncate.AtEnd })
Text(holder, "t.me/KREVETKASCRIPTS", 11, "Accent", FONT.Semi, { Position = UDim2.fromOffset(66, 45), Size = UDim2.new(1, -80, 0, 14), NoTr = true })
local bar = Create("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 16, 1, -3), Size = UDim2.new(1, -32, 0, 2), BackgroundColor3 = WHITE, BorderSizePixel = 0, Parent = holder }, { Round() })
ThemeGrad(bar, 0)
holder.MouseButton1Click:Connect(function() CopyTG(false) end)
local baseScale = sc.Scale
holder.MouseEnter:Connect(function() Tween(sc, .2, { Scale = baseScale * 1.04 }, Enum.EasingStyle.Back) end)
holder.MouseLeave:Connect(function() Tween(sc, .2, { Scale = baseScale }) end)
Tween(holder, .6, { Position = UDim2.new(.5, 0, 1, -24) }, Enum.EasingStyle.Back)
Tween(bar, 5, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)
task.delay(5, function()
if not holder.Parent then return end
Tween(holder, .4, { Position = UDim2.new(.5, 0, 1, 90) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
task.wait(.45)
holder:Destroy()
end)
end
if S.TextScale ~= 1 then Krieg:ApplyTextScale(S.TextScale) end
Krieg:LoadAutoload()
task.delay(1.2, ShowTGPopup)
Krieg:Notify({ Title = "Krieg Hub", Content = tr("Menu loaded") .. ". " .. Krieg.ToggleKey.Name .. " — " .. tr("hide / show"), Icon = "sparkles" })
end
