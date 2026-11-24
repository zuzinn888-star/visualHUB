-- LocalScript -> StarterPlayer > StarterPlayerScripts
-- AreVisuals (liquid glass menu). Читаемая версия с адаптацией для телефона и ПК.
--  * тап / ЛКМ по названию  = включить / выключить функцию
--  * тап по значку ≡ (или ПКМ) = открыть настройки
--  * заголовок панели = перетаскивание
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

--------------------------------------------------------------------
-- SETTINGS (настройка самого UI / watermark / keybinds)
--------------------------------------------------------------------
local menuProxy = setmetatable({}, {
	__index = function(_, k)
		if k == "key" then
			return MENU_KEY
		end
	end,
	__newindex = function(_, k, v)
		if k == "key" then
			MENU_KEY = v or Enum.KeyCode.RightShift
		end
	end,
})

local UIMod = Module({
	name = "UI",
	noToggle = true,
	noBind = true,
	settings = {
		{type = "color", name = "Accent", default = ACCENT},
		{type = "menubind", name = "Menu Bind"},
		{type = "slider", name = "Blur", min = 0, max = 30, step = 1, default = 16},
	},
	onChange = function(name, value)
		if name == "Accent" then
			setAccent(value)
		elseif name == "Blur" then
			BLUR_SIZE = value
			if menuOpen and blur then
				tw(blur, 0.3, {Size = value})
			end
		end
	end,
})

local WMStyleMod = Module({
	name = "Watermark",
	noToggle = true,
	noBind = true,
	settings = {
		{type = "color", name = "Accent", default = ACCENT},
		{type = "color", name = "Background", default = Color3.fromRGB(140, 172, 198)},
	},
	onChange = function(name, value)
		if name == "Accent" then
			wmAccent = value
		else
			wm.BackgroundColor3 = value
		end
	end,
})

local KBStyleMod = Module({
	name = "Keybinds",
	noToggle = true,
	noBind = true,
	settings = {
		{type = "color", name = "Accent", default = ACCENT},
		{type = "color", name = "Background", default = DARK},
	},
	onChange = function(name, value)
		if name == "Accent" then
			kbAccent = value
			refreshKeybinds()
		else
			kb.BackgroundColor3 = value
		end
	end,
})

--------------------------------------------------------------------
-- МЕНЮ: РАЗМЕРЫ
--------------------------------------------------------------------
local PW = 190          -- ширина панели
local GAP = 10
local HEADER = 40
local ROW_H = 34
local PADX = 3
local MOD_H = ROW_H + PADX * 2
local TABS = {
	{name = "Screen", mods = {AspectMod, DbdMod, WatermarkMod, KeybindsMod, CursorMod}},
	{name = "World", mods = {WeatherMod, SnowMod, SkyMod, ShaderMod, GfxMod, PotatoMod, JumpMod}},
	{name = "Player", mods = {ChamsMod, HatMod, CrownMod, FrozenMod, FieryMod, AuraMod, TrailMod, PetsMod, SkinMod, StreamerMod}},
	{name = "Settings", mods = {UIMod, WMStyleMod, KBStyleMod}},
}

local gui = new("ScreenGui", {Name = "AreVisuals", IgnoreGuiInset = false, ResetOnSpawn = false, DisplayOrder = 10, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, playerGui)
local dimGui = new("ScreenGui", {Name = "AreVisualsDim", IgnoreGuiInset = true, ResetOnSpawn = false, DisplayOrder = 9, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, playerGui)
local dim = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Active = false}, dimGui)
local holder = new("Frame", {BackgroundTransparency = 1, Size = UDim2.fromOffset(800, 800)}, gui)
local uiScale = new("UIScale", {}, holder)
local scale = 1
local radialSize = 0.82
local panels = {}
local radialX = {0, -250, 0, 250}
local radialY = {-360, -150, 140, -140}
local compactLayout = false
local applyResponsiveLayout

blur = new("BlurEffect", {Name = "AreVisualsBlur", Size = 0}, Lighting)

local function updateScale()
	local s = gui.AbsoluteSize
	compactLayout = UIS.TouchEnabled or s.X < 760 or s.Y < 560
	scale = compactLayout and 1 or math.clamp(math.min(s.X / 790, s.Y / 790) * radialSize, 0.4, 1.2)
	uiScale.Scale = scale
	holder.Size = UDim2.fromOffset(s.X / scale, s.Y / scale)
	for i, p in ipairs(panels) do
		p.ty = s.Y / scale / 2 + radialY[i]
	end
	if applyResponsiveLayout then applyResponsiveLayout() end
end
updateScale()
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)

--------------------------------------------------------------------
-- МЕНЮ: ЭЛЕМЕНТЫ НАСТРОЕК
--------------------------------------------------------------------
local listening -- {mod=, update=}
local settingsFlyout, settingsFlyoutBody, settingsFlyoutTitle, activeFlyoutClose

local function rowFrame(parent, h, order)
	local r = new("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = WHITE, BackgroundTransparency = 0.92, BorderSizePixel = 0, LayoutOrder = order}, parent)
	corner(r, 9)
	return r
end

local function hitButton(parent)
	return new("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false}, parent)
end

local function buildSlider(parent, def, mod, order, ctx)
	local row = rowFrame(parent, 42, order)
	text(row, def.name, 12, {Size = UDim2.new(0.5, 0, 0, 18), Position = UDim2.fromOffset(10, 4)})
	local val = text(row, "", 12, {Size = UDim2.new(0.4, 0, 0, 18), Position = UDim2.new(0.6, -10, 0, 4), TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = ACCENT})
	local track = new("Frame", {Size = UDim2.new(1, -20, 0, 4), Position = UDim2.new(0, 10, 1, -13), BackgroundColor3 = WHITE, BackgroundTransparency = 0.8, BorderSizePixel = 0}, row)
	corner(track, 2)
	local fill = new("Frame", {Size = UDim2.fromScale(0, 1), BackgroundColor3 = ACCENT, BorderSizePixel = 0}, track)
	corner(fill, 2)
	local knob = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(13, 13), Position = UDim2.fromScale(0, 0.5), BackgroundColor3 = WHITE, BorderSizePixel = 0}, track)
	corner(knob, 10)

	local function render(v)
		local a = (v - def.min) / (def.max - def.min)
		fill.Size = UDim2.fromScale(a, 1)
		knob.Position = UDim2.fromScale(a, 0.5)
		val.Text = (v % 1 == 0) and tostring(v) or string.format("%.2f", v)
	end
	render(mod.v[def.name])
	onAccent(function()
		fill.BackgroundColor3 = ACCENT
		val.TextColor3 = ACCENT
	end)

	local function fromX(x)
		local a = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local v = def.min + a * (def.max - def.min)
		if def.step then
			v = math.floor(v / def.step + 0.5) * def.step
		end
		v = math.clamp(v, def.min, def.max)
		render(v)
		if mod.v[def.name] ~= v then
			mod.changed(def.name, v)
		end
	end

	local hit = hitButton(row)
	hit.InputBegan:Connect(function(i)
		if isPress(i) then
			fromX(i.Position.X)
			startDrag(function(pos)
				fromX(pos.X)
			end, nil, ctx.scroller)
		end
	end)
	return 42
end

local function buildStepped(parent, def, mod, order, ctx)
	local n = #def.options
	local row = rowFrame(parent, 62, order)
	text(row, def.name, 12, {Size = UDim2.new(0.5, 0, 0, 18), Position = UDim2.fromOffset(10, 4)})
	local val = text(row, "", 12, {Size = UDim2.new(0.4, 0, 0, 18), Position = UDim2.new(0.6, -10, 0, 4), TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = ACCENT})
	local track = new("Frame", {Size = UDim2.new(1, -44, 0, 4), Position = UDim2.new(0, 22, 0, 31), BackgroundColor3 = WHITE, BackgroundTransparency = 0.8, BorderSizePixel = 0}, row)
	corner(track, 2)
	local fill = new("Frame", {Size = UDim2.fromScale(0, 1), BackgroundColor3 = ACCENT, BorderSizePixel = 0}, track)
	corner(fill, 2)

	local labels = {}
	for i = 1, n do
		local f = (i - 1) / (n - 1)
		local tick = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(8, 8), Position = UDim2.fromScale(f, 0.5), BackgroundColor3 = WHITE, BackgroundTransparency = 0.55, BorderSizePixel = 0}, track)
		corner(tick, 8)
		labels[i] = text(row, def.options[i], 11, {
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.fromOffset(44, 14),
			Position = UDim2.new(f, 0, 0, 12),
			TextXAlignment = Enum.TextXAlignment.Center,
		})
		labels[i].Parent = track
	end
	local knob = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(15, 15), Position = UDim2.fromScale(0, 0.5), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 3}, track)
	corner(knob, 10)

	local function markIdx(idx)
		val.Text = def.options[idx]
		for i = 1, n do
			tw(labels[i], 0.2, {TextColor3 = i == idx and ACCENT or Color3.fromRGB(200, 206, 208)})
		end
	end
	local function place(frac, animate)
		if animate then
			tw(knob, 0.25, {Position = UDim2.fromScale(frac, 0.5)})
			tw(fill, 0.25, {Size = UDim2.fromScale(frac, 1)})
		else
			knob.Position = UDim2.fromScale(frac, 0.5)
			fill.Size = UDim2.fromScale(frac, 1)
		end
	end
	local cur = mod.v[def.name]
	place((cur - 1) / (n - 1), false)
	markIdx(cur)
	onAccent(function()
		fill.BackgroundColor3 = ACCENT
		markIdx(mod.v[def.name])
	end)

	local function fromX(x)
		local a = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		place(a, false)
		local idx = math.floor(a * (n - 1) + 0.5) + 1
		if idx ~= mod.v[def.name] then
			markIdx(idx)
			mod.changed(def.name, idx)
		end
	end

	local hit = hitButton(row)
	hit.InputBegan:Connect(function(i)
		if isPress(i) then
			fromX(i.Position.X)
			startDrag(function(pos)
				fromX(pos.X)
			end, function()
				place((mod.v[def.name] - 1) / (n - 1), true)
			end, ctx.scroller)
		end
	end)
	return 62
end

local function buildToggle(parent, def, mod, order)
	local row = rowFrame(parent, 32, order)
	text(row, def.name, 12, {Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.fromOffset(12, 0)})
	local box = new("Frame", {AnchorPoint = Vector2.new(1, 0.5), Size = UDim2.fromOffset(34, 18), Position = UDim2.new(1, -12, 0.5, 0), BackgroundColor3 = WHITE, BackgroundTransparency = 0.8, BorderSizePixel = 0}, row)
	new("UICorner", {CornerRadius = UDim.new(1, 0)}, box)
	local knob = new("Frame", {Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(2, 2), BackgroundColor3 = WHITE, BorderSizePixel = 0}, box)
	new("UICorner", {CornerRadius = UDim.new(1, 0)}, knob)
	local function render(on, animate)
		local p1 = {BackgroundColor3 = on and ACCENT or WHITE, BackgroundTransparency = on and 0.1 or 0.8}
		local p2 = {Position = on and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2)}
		if animate then
			tw(box, 0.2, p1)
			tw(knob, 0.2, p2)
		else
			for k, v in pairs(p1) do box[k] = v end
			for k, v in pairs(p2) do knob[k] = v end
		end
	end
	render(mod.v[def.name], false)
	local hit = hitButton(row)
	hit.MouseButton1Click:Connect(function()
		local on = not mod.v[def.name]
		render(on, true)
		mod.changed(def.name, on)
	end)
	onAccent(function()
		render(mod.v[def.name], false)
	end)
	return 32
end

local function buildList(parent, def, mod, order)
	local n = #def.options
	local h = n * 28 + (n - 1) * 4
	local cont = new("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1, LayoutOrder = order}, parent)
	new("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, cont)
	local items = {}
	local function render(sel, animate)
		for i, it in ipairs(items) do
			local p = {BackgroundColor3 = i == sel and ACCENT or WHITE, BackgroundTransparency = i == sel and 0.45 or 0.92}
			if animate then
				tw(it.f, 0.2, p)
			else
				for k, v in pairs(p) do it.f[k] = v end
			end
		end
	end
	for i, o in ipairs(def.options) do
		local f = rowFrame(cont, 28, i)
		text(f, o, 12, {Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(12, 0)})
		items[i] = {f = f}
		local hit = hitButton(f)
		hit.MouseButton1Click:Connect(function()
			if mod.v[def.name] ~= i then
				render(i, true)
				mod.changed(def.name, i)
			end
		end)
	end
	render(mod.v[def.name], false)
	onAccent(function()
		render(mod.v[def.name], false)
	end)
	return h
end

local function buildColor(parent, def, mod, order, ctx)
	local row = rowFrame(parent, 134, order)
	local h, s, v = Color3.toHSV(mod.v[def.name])

	local sv = new("TextButton", {Size = UDim2.new(1, -12, 0, 100), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = Color3.fromHSV(h, 1, 1), Text = "", AutoButtonColor = false, BorderSizePixel = 0}, row)
	corner(sv, 8)
	local w = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BorderSizePixel = 0}, sv)
	corner(w, 8)
	new("UIGradient", {Transparency = NumberSequence.new(0, 1)}, w)
	local b = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0}, sv)
	corner(b, 8)
	new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(1, 0)}, b)
	local svKnob = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3}, sv)
	corner(svKnob, 10)
	new("UIStroke", {Color = WHITE, Thickness = 2}, svKnob)

	local hue = new("TextButton", {Size = UDim2.new(1, -12, 0, 14), Position = UDim2.fromOffset(6, 114), BackgroundColor3 = WHITE, Text = "", AutoButtonColor = false, BorderSizePixel = 0}, row)
	corner(hue, 7)
	new("UIGradient", {Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
		ColorSequenceKeypoint.new(1 / 6, Color3.fromHSV(1 / 6, 1, 1)),
		ColorSequenceKeypoint.new(2 / 6, Color3.fromHSV(2 / 6, 1, 1)),
		ColorSequenceKeypoint.new(3 / 6, Color3.fromHSV(3 / 6, 1, 1)),
		ColorSequenceKeypoint.new(4 / 6, Color3.fromHSV(4 / 6, 1, 1)),
		ColorSequenceKeypoint.new(5 / 6, Color3.fromHSV(5 / 6, 1, 1)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 1, 1)),
	})}, hue)
	local hueKnob = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(8, 18), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 3}, hue)
	corner(hueKnob, 4)
	new("UIStroke", {Color = Color3.new(0, 0, 0), Thickness = 1, Transparency = 0.6}, hueKnob)

	local function render()
		sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		svKnob.Position = UDim2.fromScale(s, 1 - v)
		hueKnob.Position = UDim2.fromScale(h, 0.5)
	end
	local function push()
		render()
		mod.changed(def.name, Color3.fromHSV(h, s, v))
	end
	render()

	sv.InputBegan:Connect(function(i)
		if isPress(i) then
			local function upd(pos)
				s = math.clamp((pos.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
				v = 1 - math.clamp((pos.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
				push()
			end
			upd(i.Position)
			startDrag(upd, nil, ctx.scroller)
		end
	end)
	hue.InputBegan:Connect(function(i)
		if isPress(i) then
			local function upd(pos)
				h = math.clamp((pos.X - hue.AbsolutePosition.X) / hue.AbsoluteSize.X, 0, 0.999)
				push()
			end
			upd(i.Position)
			startDrag(upd, nil, ctx.scroller)
		end
	end)
	return 134
end

local function buildInput(parent, def, mod, order)
	local row = rowFrame(parent, 58, order)
	text(row, def.name, 12, {Size = UDim2.new(0.4, 0, 0, 18), Position = UDim2.fromOffset(10, 4)})
	local status = text(row, "", 11, {Size = UDim2.new(0.6, -10, 0, 18), Position = UDim2.new(0.4, 0, 0, 4), TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = ACCENT})
	local box = new("TextBox", {
		Size = UDim2.new(1, -20, 0, 26),
		Position = UDim2.fromOffset(10, 26),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.88,
		Text = mod.v[def.name] or "",
		PlaceholderText = def.placeholder or "",
		PlaceholderColor3 = Color3.fromRGB(150, 158, 162),
		TextColor3 = WHITE,
		TextSize = 12,
		FontFace = FONT_REG,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		BorderSizePixel = 0,
	}, row)
	corner(box, 8)
	new("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}, box)
	mod.statusFns[def.name] = function(t, c)
		status.Text = t
		status.TextColor3 = c or ACCENT
	end
	box.FocusLost:Connect(function()
		mod.changed(def.name, box.Text)
	end)
	return 58
end

local function buildGallery(parent, def, mod, order)
	local items = def.items
	local rows = math.ceil(#items / 2)
	local h = rows * 66 + (rows - 1) * 6
	local cont = new("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1, LayoutOrder = order}, parent)
	new("UIGridLayout", {
		CellSize = UDim2.new(0.5, -3, 0, 66),
		CellPadding = UDim2.fromOffset(6, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
	}, cont)
	local tiles = {}
	for i, it in ipairs(items) do
		local tile = new("ImageButton", {
			BackgroundColor3 = Color3.fromRGB(44, 52, 58),
			Image = it.preview or "",
			ScaleType = Enum.ScaleType.Crop,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			LayoutOrder = i,
		}, cont)
		corner(tile, 9)
		if not it.preview then
			tile.BackgroundColor3 = WHITE
			local c1 = it.colors and it.colors[1] or Color3.fromRGB(90, 160, 215)
			local c2 = it.colors and it.colors[2] or Color3.fromRGB(205, 228, 245)
			new("UIGradient", {Rotation = 90, Color = ColorSequence.new(c1, c2)}, tile)
		end
		local shade = new("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 20), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.4, BorderSizePixel = 0}, tile)
		text(shade, it.name, 11, {Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, FontFace = FONT_BOLD, TextColor3 = WHITE})
		local stroke = new("UIStroke", {Color = WHITE, Thickness = 2, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, tile)
		tiles[i] = stroke
		tile.MouseButton1Click:Connect(function()
			if mod.v[def.name] ~= i then
				mod.changed(def.name, i)
				for j, st in ipairs(tiles) do
					tw(st, 0.2, {Transparency = j == i and 0 or 1, Color = j == i and ACCENT or WHITE})
				end
			end
		end)
	end
	onAccent(function()
		for j, st in ipairs(tiles) do
			local sel = mod.v[def.name] == j
			st.Transparency = sel and 0 or 1
			st.Color = sel and ACCENT or WHITE
		end
	end)
	return h
end

local function buildBind(parent, mod, order, label)
	local row = rowFrame(parent, 30, order)
	text(row, label or "Bind", 12, {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.fromOffset(10, 0)})
	local val = text(row, "", 12, {Size = UDim2.new(0.5, -10, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = ACCENT})
	local function update()
		val.Text = mod.key and mod.key.Name or "None"
		val.TextColor3 = ACCENT
	end
	update()
	onAccent(update)
	local hit = hitButton(row)
	hit.MouseButton1Click:Connect(function()
		listening = {mod = mod, update = update}
		val.Text = "..."
		val.TextColor3 = Color3.fromRGB(255, 220, 120)
	end)
	return 30
end

--------------------------------------------------------------------
-- МЕНЮ: ФУНКЦИЯ (строка + настройки)
--------------------------------------------------------------------
local function buildModule(body, mod, order, ctx)
	local holderM = new("Frame", {Name = mod.name, Size = UDim2.new(1, 0, 0, MOD_H), BackgroundTransparency = 1, ClipsDescendants = true, LayoutOrder = order}, body)
	mod.holder = holderM

	local row = new("Frame", {Position = UDim2.fromOffset(PADX, PADX), Size = UDim2.new(1, -PADX * 2, 0, ROW_H), BackgroundColor3 = WHITE, BackgroundTransparency = 0.9, BorderSizePixel = 0}, holderM)
	corner(row, 10)
	local accentBar = new("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 4, 0.5, 0), Size = UDim2.fromOffset(3, 0), BackgroundColor3 = ACCENT, BackgroundTransparency = 0.05, BorderSizePixel = 0, ZIndex = 3}, row)
	corner(accentBar, 2)
	onAccent(function() accentBar.BackgroundColor3 = ACCENT end)
	new("UIGradient", {
		Rotation = 20,
		Color = ColorSequence.new(WHITE, Color3.fromRGB(215, 232, 238)),
		Transparency = NumberSequence.new(0, 0.3),
	}, row)
	local rowScale = new("UIScale", {}, row)

	local nameBtn = new("TextButton", {
		Size = UDim2.new(1, -40, 1, 0),
		BackgroundTransparency = 1,
		Text = mod.name,
		TextSize = 13,
		FontFace = FONT_REG,
		TextColor3 = Color3.fromRGB(215, 221, 224),
		TextXAlignment = Enum.TextXAlignment.Left,
		AutoButtonColor = false,
	}, row)
	new("UIPadding", {PaddingLeft = UDim.new(0, 12)}, nameBtn)

	local setBtn = new("TextButton", {Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(1, -40, 0, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false}, row)
	local bars = {}
	for i = 0, 2 do
		bars[i] = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(14, 2),
			Position = UDim2.new(0.5, 0, 0.5, (i - 1) * 4),
			BackgroundColor3 = Color3.fromRGB(205, 211, 214),
			BorderSizePixel = 0,
		}, setBtn)
		corner(bars[i], 2)
	end

	-- настройки
	local sFrame = new("Frame", {Position = UDim2.fromOffset(PADX, MOD_H + 2), BackgroundTransparency = 1, Size = UDim2.new(1, -PADX * 2, 0, 10)}, holderM)
	new("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, sFrame)
	local total, count = 0, 0
	local function add(h)
		total += h
		count += 1
	end
	for i, def in ipairs(mod.settings) do
		if def.type == "slider" then
			add(buildSlider(sFrame, def, mod, i, ctx))
		elseif def.type == "stepped" then
			add(buildStepped(sFrame, def, mod, i, ctx))
		elseif def.type == "toggle" then
			add(buildToggle(sFrame, def, mod, i))
		elseif def.type == "list" then
			add(buildList(sFrame, def, mod, i))
		elseif def.type == "color" then
			add(buildColor(sFrame, def, mod, i, ctx))
		elseif def.type == "input" then
			add(buildInput(sFrame, def, mod, i))
		elseif def.type == "gallery" then
			add(buildGallery(sFrame, def, mod, i))
		elseif def.type == "menubind" then
			add(buildBind(sFrame, menuProxy, i, def.name))
		end
	end
	if not mod.noBind then
		add(buildBind(sFrame, mod, 100))
	end
	total += (count - 1) * 4
	sFrame.Size = UDim2.new(1, -PADX * 2, 0, total)
	-- состояния
	local hover, open = false, false
	function mod.setVisual(on)
		tw(row, 0.28, {BackgroundColor3 = on and rowOnColor() or WHITE, BackgroundTransparency = on and 0.38 or (hover and 0.84 or 0.9)})
		tw(nameBtn, 0.28, {TextColor3 = on and WHITE or Color3.fromRGB(215, 221, 224)})
		tw(accentBar, 0.3, {Size = UDim2.fromOffset(3, on and (ROW_H - 12) or 0)}, Enum.EasingStyle.Back)
	end

	local function toggleOpen()
		if not open and activeFlyoutClose then activeFlyoutClose() end
		open = not open
		if open then
			sFrame.Parent = settingsFlyoutBody
			sFrame.Position = UDim2.fromOffset(6, 0)
			sFrame.Size = UDim2.new(1, -12, 0, total)
			settingsFlyoutBody.CanvasSize = UDim2.fromOffset(0, total + 10)
			settingsFlyoutTitle.Text = mod.name
			settingsFlyout.Visible = true
			activeFlyoutClose = function() if open then toggleOpen() end end
		else
			sFrame.Parent = holderM
			sFrame.Position = UDim2.fromOffset(PADX, MOD_H + 2)
			sFrame.Size = UDim2.new(1, -PADX * 2, 0, total)
			settingsFlyout.Visible = false
			activeFlyoutClose = nil
		end
		for _, b in pairs(bars) do
			tw(b, 0.25, {BackgroundColor3 = open and ACCENT or Color3.fromRGB(205, 211, 214)})
		end
	end

	function mod.getH()
		return MOD_H
	end

	nameBtn.MouseButton1Click:Connect(function()
		if mod.noToggle then
			toggleOpen()
		else
			setEnabled(mod, not mod.enabled)
		end
	end)
	nameBtn.MouseButton2Click:Connect(toggleOpen)
	setBtn.MouseButton1Click:Connect(toggleOpen)
	onAccent(function()
		if mod.enabled and mod.setVisual then
			mod.setVisual(true)
		end
		for _, b in pairs(bars) do
			b.BackgroundColor3 = open and ACCENT or Color3.fromRGB(205, 211, 214)
		end
	end)

	nameBtn.MouseButton1Down:Connect(function()
		tw(rowScale, 0.12, {Scale = 0.97})
	end)
	local function release()
		tw(rowScale, 0.2, {Scale = 1}, Enum.EasingStyle.Back)
	end
	nameBtn.MouseButton1Up:Connect(release)
	nameBtn.MouseLeave:Connect(function()
		hover = false
		release()
		if not mod.enabled then
			tw(row, 0.2, {BackgroundTransparency = 0.9})
		end
	end)
	nameBtn.MouseEnter:Connect(function()
		hover = true
		if not mod.enabled then
			tw(row, 0.2, {BackgroundTransparency = 0.84})
		end
	end)
end

--------------------------------------------------------------------
-- МЕНЮ: ПАНЕЛИ
--------------------------------------------------------------------
local zTop = 1

-- The glass ring is decorative; the existing module rows remain interactive.
local ring = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(760, 760), BackgroundColor3 = DARK,
	BackgroundTransparency = 0.84, BorderSizePixel = 0, ZIndex = 1,
}, holder)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, ring)
edge(ring, 2.2, 0.12)
local ringDividers = {}
for _, spec in ipairs({
	{-195, -195, 45}, {195, -195, -45},
	{-195, 195, -45}, {195, 195, 45},
}) do
	local divider = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, spec[1], 0.5, spec[2]),
		Size = UDim2.fromOffset(205, 2), Rotation = spec[3],
		BackgroundColor3 = WHITE, BackgroundTransparency = 0.2,
		BorderSizePixel = 0, ZIndex = 1,
	}, holder)
	table.insert(ringDividers, divider)
end

local center = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(230, 246), BackgroundColor3 = DARK,
	BackgroundTransparency = 0.43, BorderSizePixel = 0, ZIndex = 2,
}, holder)
corner(center, 15)
edge(center, 2.4, 0.05)
new("UIGradient", {Rotation = 50, Transparency = NumberSequence.new(0.12, 0.48)}, center)
text(center, "KREVETKASCRIPTS", 18, {
	Position = UDim2.fromOffset(10, 63), Size = UDim2.new(1, -20, 0, 34),
	TextXAlignment = Enum.TextXAlignment.Center, FontFace = FONT_BOLD,
	TextColor3 = WHITE, ZIndex = 3,
})
new("Frame", {
	Position = UDim2.fromOffset(20, 129), Size = UDim2.new(1, -40, 0, 2),
	BackgroundColor3 = WHITE, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 3,
}, center)

local mobileTitle = text(holder, "KREVETKASCRIPTS", 17, {
	Position = UDim2.fromOffset(16, 12), Size = UDim2.new(1, -150, 0, 36),
	FontFace = FONT_BOLD, TextColor3 = WHITE, ZIndex = 4, Visible = false,
})
local mobileCanvas = new("ScrollingFrame", {
	AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 106),
	Size = UDim2.new(1, -24, 1, -118), BackgroundTransparency = 1,
	BorderSizePixel = 0, ScrollBarThickness = 4, ScrollBarImageColor3 = ACCENT,
	ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(),
	Visible = false, Active = true, ZIndex = 2,
}, holder)
onAccent(function() mobileCanvas.ScrollBarImageColor3 = ACCENT end)

local sizeLabel = text(center, "82%", 12, {
	Position = UDim2.fromOffset(88, 13), Size = UDim2.fromOffset(54, 24),
	TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = WHITE, ZIndex = 4,
})
local function sizeButton(label, x, delta)
	local button = new("TextButton", {
		Position = UDim2.fromOffset(x, 13), Size = UDim2.fromOffset(28, 25),
		Text = label, TextSize = 18, FontFace = FONT_BOLD,
		TextColor3 = WHITE, BackgroundColor3 = DARK,
		BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 4,
	}, center)
	corner(button, 7)
	button.MouseButton1Click:Connect(function()
		radialSize = math.clamp(math.floor((radialSize + delta) * 100 + 0.5) / 100, 0.6, 1.2)
		sizeLabel.Text = math.floor(radialSize * 100 + 0.5) .. "%"
		updateScale()
	end)
end
sizeButton("−", 56, -0.08)
sizeButton("+", 146, 0.08)

settingsFlyout = new("CanvasGroup", {
	AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(250, 330),
	BackgroundColor3 = DARK, BackgroundTransparency = 0.28,
	GroupTransparency = 0, BorderSizePixel = 0, Visible = false, ZIndex = 8,
}, holder)
corner(settingsFlyout, 14)
edge(settingsFlyout, 1.5, 0.15)
settingsFlyoutTitle = text(settingsFlyout, "Settings", 15, {
	Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -50, 0, 30),
	FontFace = FONT_BOLD, TextColor3 = WHITE, ZIndex = 9,
})
local flyoutClose = new("TextButton", {
	Position = UDim2.new(1, -36, 0, 7), Size = UDim2.fromOffset(28, 28),
	Text = "×", TextSize = 19, TextColor3 = WHITE,
	BackgroundTransparency = 1, ZIndex = 9,
}, settingsFlyout)
flyoutClose.MouseButton1Click:Connect(function()
	if activeFlyoutClose then activeFlyoutClose() end
end)
settingsFlyoutBody = new("ScrollingFrame", {
	Position = UDim2.fromOffset(8, 43), Size = UDim2.new(1, -16, 1, -51),
	BackgroundTransparency = 1, BorderSizePixel = 0,
	ScrollBarThickness = 3, ScrollBarImageColor3 = ACCENT,
	ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 9,
}, settingsFlyout)
local function positionFlyout()
	local width = gui.AbsoluteSize.X / scale
	if compactLayout then
		settingsFlyout.AnchorPoint = Vector2.new(0.5, 0.5)
		settingsFlyout.Position = UDim2.fromScale(0.5, 0.5)
		settingsFlyout.Size = UDim2.fromOffset(math.max(1, math.min(width - 24, 390)), math.max(1, math.min(gui.AbsoluteSize.Y - 36, 520)))
	else
		settingsFlyout.AnchorPoint = Vector2.new(0, 0.5)
		settingsFlyout.Position = UDim2.new(0.5, math.min(390, width / 2 - 258), 0.5, 0)
		settingsFlyout.Size = UDim2.fromOffset(250, 330)
	end
end
positionFlyout()
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(positionFlyout)
uiScale:GetPropertyChangedSignal("Scale"):Connect(positionFlyout)

local function clampX(x)
	local half = holder.AbsoluteSize.X / scale / 2 - PW / 2
	return math.clamp(x, -half, half)
end

for idx, tab in ipairs(TABS) do
	local dx = radialX[idx]
	local frame = new("CanvasGroup", {
		Name = tab.name,
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.fromOffset(PW, 120),
		BackgroundColor3 = DARK,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = 1,
	}, holder)
	corner(frame, 16)
	-- Rows float over the circular glass surface.

	local header = new("TextButton", {Size = UDim2.new(1, 0, 0, HEADER), BackgroundTransparency = 1, Text = "", AutoButtonColor = false}, frame)
	text(header, tab.name, 15, {Size = UDim2.fromScale(1, 1), FontFace = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = WHITE})
	do
		local hdDiv = new("Frame", {AnchorPoint = Vector2.new(0.5, 0), Size = UDim2.new(1, -24, 0, 2), Position = UDim2.new(0.5, 0, 1, -2), BackgroundColor3 = ACCENT, BackgroundTransparency = 0.2, BorderSizePixel = 0}, header)
		corner(hdDiv, 2)
		new("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)})}, hdDiv)
		onAccent(function() hdDiv.BackgroundColor3 = ACCENT end)
	end

	local body = new("ScrollingFrame", {
		Position = UDim2.fromOffset(6, HEADER + 6),
		Size = UDim2.new(1, -12, 0, 100),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = ACCENT,
		ScrollBarImageTransparency = 0.3,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.None,
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, frame)
	new("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, body)
	onAccent(function()
		body.ScrollBarImageColor3 = ACCENT
	end)

	local py = gui.AbsoluteSize.Y / scale / 2 + radialY[idx]
	local p = {name = tab.name, dim = 0, frame = frame, body = body, mods = tab.mods, tx = dx, ty = py, cx = dx, cy = py, appear = 1, target = 0, wait = (idx - 1) * 0.07, col = 0, collapsed = false}
	table.insert(panels, p)

	if #tab.mods == 0 then
		text(body, "Empty", 12, {Size = UDim2.new(1, 0, 0, 30), TextXAlignment = Enum.TextXAlignment.Center, TextTransparency = 0.5})
	end
	for i, mod in ipairs(tab.mods) do
		buildModule(body, mod, i, {scroller = settingsFlyoutBody})
	end

	-- тап по заголовку = свернуть/развернуть, перетаскивание = двигать (тап не срабатывает при драге)
	header.InputBegan:Connect(function(i)
		if compactLayout then return end
		if isPress(i) then
			zTop += 1
			frame.ZIndex = zTop
			local sx, sy, ox, oy = i.Position.X, i.Position.Y, p.tx, p.ty
			local moved = false
			startDrag(function(pos)
				if not moved and (Vector2.new(pos.X, pos.Y) - Vector2.new(sx, sy)).Magnitude > 7 then
					moved = true
				end
				if moved then
					p.tx = clampX(ox + (pos.X - sx) / scale)
					p.ty = math.clamp(oy + (pos.Y - sy) / scale, 0, holder.AbsoluteSize.Y / scale - 70)
				end
			end, function()
				if not moved then
					p.collapsed = not p.collapsed
				end
			end)
		end
	end)
	header.MouseButton1Click:Connect(function()
		if compactLayout then p.collapsed = not p.collapsed end
	end)
end

--------------------------------------------------------------------
-- МЕНЮ: ПОИСК (внизу)
--------------------------------------------------------------------
local searchBar = new("CanvasGroup", {
	Name = "Search",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 52),
	Size = UDim2.fromOffset(190, 36),
	BackgroundColor3 = DARK,
	BackgroundTransparency = 0.38,
	BorderSizePixel = 0,
	GroupTransparency = 1,
	ZIndex = 3,
}, holder)
corner(searchBar, 12)
edge(searchBar, 1.2, 0.4)
new("UIGradient", {Rotation = 60, Transparency = NumberSequence.new(0, 0.3)}, searchBar)
local searchBox = new("TextBox", {
	Size = UDim2.new(1, -24, 1, 0),
	Position = UDim2.fromOffset(12, 0),
	BackgroundTransparency = 1,
	Text = "",
	PlaceholderText = "Search",
	PlaceholderColor3 = Color3.fromRGB(150, 158, 162),
	TextColor3 = WHITE,
	TextSize = 13,
	FontFace = FONT_REG,
	TextXAlignment = Enum.TextXAlignment.Left,
	ClearTextOnFocus = false,
	BorderSizePixel = 0,
	ZIndex = 4,
}, searchBar)

local function applySearch(q)
	q = (q or ""):lower():match("^%s*(.-)%s*$")
	for _, p in ipairs(panels) do
		local tabHit = q ~= "" and p.name:lower():find(q, 1, true) ~= nil
		local any = false
		for _, m in ipairs(p.mods) do
			local match = q == "" or tabHit or m.name:lower():find(q, 1, true) ~= nil
			if match then
				any = true
			end
			if match == (m.hidden == true) then -- состояние поменялось
				m.hidden = not match
				if match then
					m.holder.Visible = true
					tw(m.holder, 0.38, {Size = UDim2.new(1, 0, 0, m.getH())})
				else
					local t = tw(m.holder, 0.3, {Size = UDim2.new(1, 0, 0, 0)})
					t.Completed:Connect(function(state)
						if state == Enum.PlaybackState.Completed and m.hidden then
							m.holder.Visible = false
						end
					end)
				end
			end
		end
		p.searchEmpty = q ~= "" and not any
	end
end
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	applySearch(searchBox.Text)
end)

-- плавное движение / авто-высота панелей
RunService.RenderStepped:Connect(function(dt)
	local follow = 1 - math.exp(-dt * 16)
	local appearK = 1 - math.exp(-dt * 9)
	local holderH = holder.AbsoluteSize.Y / scale
	local allHidden = true
	local mobileY = 8
	local mobilePanelW = math.max(200, math.min(gui.AbsoluteSize.X - 24, 480))
	for _, p in ipairs(panels) do
		if p.wait > 0 then
			p.wait -= dt
		else
			p.appear += (p.target - p.appear) * appearK
		end
		p.cx += (p.tx - p.cx) * follow
		p.cy += (p.ty - p.cy) * follow

		local content, visN = 0, 0
		for _, m in ipairs(p.mods) do
			if m.holder.Visible then
				content += m.holder.Size.Y.Offset
				visN += 1
			end
		end
		content += math.max(visN - 1, 0) * 2
		if visN == 0 then
			content = 30
		end
		local avail = compactLayout and math.max(130, gui.AbsoluteSize.Y - 190) or math.max(90, holderH - p.cy - HEADER - 66)
		local cap = compactLayout and 330 or ((p.name == "Player" and 185) or (p.name == "World" and 260) or 215)
		local bodyH = math.min(content, avail, cap)
		p.col += (((p.collapsed or p.searchEmpty) and 1 or 0) - p.col) * (1 - math.exp(-dt * 12))
		local openK = 1 - p.col
		p.body.Size = UDim2.new(1, -12, 0, bodyH * openK)
		p.body.CanvasSize = UDim2.fromOffset(0, content)
		p.body.Visible = openK > 0.03
		local panelH = HEADER + (6 + bodyH + 10) * openK
		p.frame.Size = UDim2.fromOffset(compactLayout and mobilePanelW or PW, panelH)

		p.dim += ((p.searchEmpty and 0.62 or 0) - p.dim) * (1 - math.exp(-dt * 10))
		p.frame.GroupTransparency = math.clamp(math.max(p.appear, p.dim), 0, 1)
		if compactLayout then
			p.frame.Position = UDim2.fromOffset(0, mobileY + p.appear * 12)
			mobileY += panelH + 12
		else
			p.frame.Position = UDim2.new(0.5, p.cx, 0, p.cy + p.appear * 26)
		end
		if p.appear < 0.98 then
			allHidden = false
		end
	end
	if compactLayout then
		mobileCanvas.CanvasSize = UDim2.fromOffset(0, mobileY + 8)
	end
	local ap = panels[1] and panels[1].appear or 1
	searchBar.GroupTransparency = math.clamp(ap, 0, 1)
	if compactLayout then
		searchBar.Position = UDim2.new(0.5, 0, 0, 57 + ap * 10)
	else
		local searchOffset = settingsFlyout.Visible and 82 or 52
		searchBar.Position = UDim2.new(0.5, 0, 0.5, searchOffset + ap * 20)
	end
	if not menuOpen and allHidden then
		holder.Visible = false
	end
end)

--------------------------------------------------------------------
-- МЕНЮ: ОТКРЫТЬ / ЗАКРЫТЬ
--------------------------------------------------------------------
local menuBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -12, 0, 8),
	Size = UDim2.fromOffset(120, 34),
	BackgroundTransparency = 1,
	Text = "",
	AutoButtonColor = false,
	ZIndex = 50,
}, gui)
local menuBg = new("Frame", {Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, ZIndex = 50, Active = false}, menuBtn)
menuBg.BackgroundColor3 = DARK
menuBg.BackgroundTransparency = 0.38
new("UICorner", {CornerRadius = UDim.new(0, 12)}, menuBg)
local menuLbl = text(menuBtn, "NK_KriegHUB", 13, {
	Size = UDim2.fromScale(1, 1),
	TextXAlignment = Enum.TextXAlignment.Center,
	FontFace = FONT_BOLD,
	TextColor3 = WHITE,
	ZIndex = 52,
})
local menuScale = new("UIScale", {}, menuBtn)
menuBtn.MouseButton1Down:Connect(function()
	tw(menuScale, 0.12, {Scale = 0.93})
end)
local function menuRelease()
	tw(menuScale, 0.25, {Scale = 1}, Enum.EasingStyle.Back)
end
menuBtn.MouseButton1Up:Connect(menuRelease)
menuBtn.MouseLeave:Connect(menuRelease)
local menuDragMoved = false
menuBtn.InputBegan:Connect(function(input)
	if not isPress(input) then return end
	menuDragMoved = false
	local start = input.Position
	local origin = Vector2.new(
		menuBtn.Position.X.Scale * gui.AbsoluteSize.X + menuBtn.Position.X.Offset - menuBtn.AnchorPoint.X * menuBtn.AbsoluteSize.X,
		menuBtn.Position.Y.Scale * gui.AbsoluteSize.Y + menuBtn.Position.Y.Offset - menuBtn.AnchorPoint.Y * menuBtn.AbsoluteSize.Y
	)
	startDrag(function(pos)
		local delta = Vector2.new(pos.X - start.X, pos.Y - start.Y)
		if not menuDragMoved and delta.Magnitude < 6 then return end
		menuDragMoved = true
		menuBtn.AnchorPoint = Vector2.zero
		local bounds = gui.AbsoluteSize - menuBtn.AbsoluteSize
		menuBtn.Position = UDim2.fromOffset(
			math.clamp(origin.X + delta.X, 0, math.max(0, bounds.X)),
			math.clamp(origin.Y + delta.Y, 0, math.max(0, bounds.Y))
		)
	end)
end)

local function setMenu(open)
	menuOpen = open
	if not open and activeFlyoutClose then activeFlyoutClose() end
	if open then
		holder.Visible = true
	end
	tw(dim, 0.4, {BackgroundTransparency = open and 0.82 or 1})
	tw(blur, 0.45, {Size = open and BLUR_SIZE or 0})
	for i, p in ipairs(panels) do
		p.target = open and 0 or 1
		p.wait = open and (i - 1) * 0.07 or 0
	end
end
menuBtn.MouseButton1Click:Connect(function()
	if menuDragMoved then
		menuDragMoved = false
		return
	end
	setMenu(not menuOpen)
end)

applyResponsiveLayout = function()
	local mobile = compactLayout
	ring.Visible = not mobile
	for _, divider in ipairs(ringDividers) do divider.Visible = not mobile end
	center.Visible = not mobile
	mobileTitle.Visible = mobile
	mobileCanvas.Visible = mobile
	menuBtn.Size = UDim2.fromOffset(mobile and 124 or 120, mobile and 44 or 34)
	searchBar.Size = UDim2.fromOffset(mobile and math.max(200, math.min(gui.AbsoluteSize.X - 24, 480)) or 190, mobile and 42 or 36)
	if mobile then
		mobileCanvas.Size = UDim2.fromOffset(math.max(200, math.min(gui.AbsoluteSize.X - 24, 480)), math.max(100, gui.AbsoluteSize.Y - 118))
	end
	for _, p in ipairs(panels) do
		p.frame.Parent = mobile and mobileCanvas or holder
		p.frame.AnchorPoint = mobile and Vector2.zero or Vector2.new(0.5, 0)
	end
	positionFlyout()
end
updateScale()

-- заставка при запуске: по центру плавно появляется NK_KriegHUB / канал, затем открывается меню
setMenu(false)
do
	local introGui = new("ScreenGui", {Name = "AreVisualsIntro", IgnoreGuiInset = true, ResetOnSpawn = false, DisplayOrder = 20, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, playerGui)
	local intro = new("CanvasGroup", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(math.max(260, math.min(520, gui.AbsoluteSize.X - 20)), 120),
		BackgroundTransparency = 1,
		GroupTransparency = 1,
	}, introGui)
	local introScale = new("UIScale", {Scale = 0.9}, intro)
	text(intro, 'NK_<font color="' .. rgbStr(ACCENT) .. '">KriegHUB</font>', compactLayout and 32 or 56, {
		Size = UDim2.new(1, 0, 0, 66),
		Position = UDim2.fromOffset(0, 6),
		RichText = true,
		FontFace = FONT_BOLD,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextColor3 = WHITE,
	})
	text(intro, "t.me/KREVETKASCRIPTS", 18, {
		Size = UDim2.new(1, 0, 0, 26),
		Position = UDim2.fromOffset(0, 78),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextColor3 = Color3.fromRGB(200, 208, 212),
	})
	tw(intro, 0.9, {GroupTransparency = 0})
	tw(introScale, 1.3, {Scale = 1})
	task.delay(2.1, function()
		setMenu(true)
	end)
	task.delay(2.4, function()
		tw(intro, 0.8, {GroupTransparency = 1})
		tw(introScale, 0.8, {Scale = 1.06})
	end)
	task.delay(3.5, function()
		introGui:Destroy()
	end)
end

--------------------------------------------------------------------
-- КЛАВИШИ
--------------------------------------------------------------------
UIS.InputBegan:Connect(function(input, gpe)
	if listening then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			local l = listening
			listening = nil
			if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
				l.mod.key = nil
			else
				l.mod.key = input.KeyCode
			end
			l.update()
			refreshKeybinds()
		end
		return
	end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then
		return
	end
	if input.KeyCode == MENU_KEY and not UIS:GetFocusedTextBox() then
		setMenu(not menuOpen)
		return
	end
	if gpe then
		return
	end
	for _, m in ipairs(modules) do
		if m.key and m.key == input.KeyCode then
			setEnabled(m, not m.enabled)
		end
	end
end)

refreshKeybinds()
