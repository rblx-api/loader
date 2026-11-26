-- Voryx Intro (from M10RU / fearhub style)
-- Black space + stars + title + charge line

local Players = game:GetService("Players")

-- Bat hit sound (Bat Aim / Bat V2 / TP Bat)
_G.VoryxPlayBatHitSound = _G.VoryxPlayBatHitSound or function()
	local ok, err = pcall(function()
		if _G._voryxBatHitCd and (tick() - _G._voryxBatHitCd) < 0.12 then return end
		_G._voryxBatHitCd = tick()
		local parent = game:GetService("SoundService")
		local char = game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			parent = char.HumanoidRootPart
		end
		local s = Instance.new("Sound")
		s.Name = "VoryxBatHit"
		s.SoundId = "rbxassetid://102865919016574"
		s.Volume = 1
		s.Parent = parent
		s:Play()
		task.delay(1, function()
			pcall(function() s:Stop(); s:Destroy() end)
		end)
	end)
end
local function playBatHitSound()
	pcall(function() _G.VoryxPlayBatHitSound() end)
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

local CYAN_ACCENT = Color3.fromRGB(120, 220, 255)
local CYAN_FILL = Color3.fromRGB(0, 190, 230)
local NAVY_DEEP = Color3.fromRGB(8, 28, 55)
local ICE_LIGHT = Color3.fromRGB(185, 240, 255)

local function getSafeGuiParent()
	local function canParent(parent)
		if typeof(parent) ~= "Instance" then return false end
		local probe = Instance.new("ScreenGui")
		probe.Name = "VoryxIntroProbe"
		probe.Enabled = false
		local ok = pcall(function() probe.Parent = parent end)
		pcall(function() probe:Destroy() end)
		return ok
	end
	if type(gethui) == "function" then
		local ok, parent = pcall(gethui)
		if ok and canParent(parent) then return parent end
	end
	local pg = LP and (LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 10))
	if canParent(pg) then return pg end
	local ok, core = pcall(function() return game:GetService("CoreGui") end)
	if ok and canParent(core) then return core end
	return LP:WaitForChild("PlayerGui")
end

local function protectGui(gui)
	pcall(function()
		if syn and syn.protect_gui then syn.protect_gui(gui)
		elseif protectgui then protectgui(gui) end
	end)
end

local function safeHttpGet(url)
	local ok, res = pcall(function() return game:HttpGet(url) end)
	if ok and res then return res end
	local req = request or http_request or (syn and syn.request)
	if req then
		local ok2, r = pcall(function()
			local response = req({Url = url, Method = "GET"})
			return response and (response.Body or response.body)
		end)
		if ok2 and r then return r end
	end
	return nil
end

local function safeWriteFile(name, content)
	if writefile then pcall(writefile, name, content) end
end

local function safeIsFile(name)
	if isfile then
		local ok, res = pcall(isfile, name)
		return ok and res
	end
	return false
end

local function safeGetAsset(path)
	if getsynasset then
		local ok, res = pcall(getsynasset, path)
		if ok and res then return res end
	end
	if getcustomasset then
		local ok, res = pcall(getcustomasset, path)
		if ok and res then return res end
	end
	return ""
end

local function tween(obj, dur, style, dir, props)
	local ti = TweenInfo.new(dur, style or Enum.EasingStyle.Sine, dir or Enum.EasingDirection.Out)
	local tw = TweenService:Create(obj, ti, props)
	tw:Play()
	return tw
end

local function playVoryxIntro()
	local parent = getSafeGuiParent()
	pcall(function()
		local old = parent:FindFirstChild("VoryxIntro")
		if old then old:Destroy() end
	end)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "VoryxIntro"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 5000
	protectGui(screenGui)
	screenGui.Parent = parent

	local finished = false
	local starConnection = nil

	local space = Instance.new("Frame")
	space.Name = "Space"
	space.Size = UDim2.fromScale(1, 1)
	space.BackgroundColor3 = Color3.fromRGB(8, 18, 32)
	space.BorderSizePixel = 0
	space.Parent = screenGui

	local content = Instance.new("CanvasGroup")
	content.Name = "Content"
	content.Size = UDim2.fromScale(1, 1)
	content.BackgroundTransparency = 1
	content.GroupTransparency = 1
	content.Parent = space

	-- stars
	local rng = Random.new()
	local stars = {}
	local streaks = {}
	for i = 1, 48 do
		local star = Instance.new("Frame")
		star.Size = UDim2.fromOffset(rng:NextInteger(1, 3), rng:NextInteger(1, 3))
		star.Position = UDim2.fromScale(rng:NextNumber(), rng:NextNumber())
		star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		star.BackgroundTransparency = rng:NextNumber(0.1, 0.55)
		star.BorderSizePixel = 0
		star.ZIndex = 2
		Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
		star.Parent = content
		table.insert(stars, {
			object = star,
			x = star.Position.X.Scale,
			y = star.Position.Y.Scale,
			speed = rng:NextNumber(0.02, 0.08),
			phase = rng:NextNumber(0, math.pi * 2),
		})
	end
	for i = 1, 10 do
		local streak = Instance.new("Frame")
		streak.Size = UDim2.fromOffset(rng:NextInteger(18, 42), 1)
		streak.Position = UDim2.fromScale(rng:NextNumber(), rng:NextNumber(0, 0.85))
		streak.BackgroundColor3 = ICE_LIGHT
		streak.BackgroundTransparency = 0.35
		streak.BorderSizePixel = 0
		streak.ZIndex = 2
		streak.Parent = content
		table.insert(streaks, {
			object = streak,
			x = streak.Position.X.Scale,
			y = streak.Position.Y.Scale,
			speed = rng:NextNumber(0.12, 0.28),
		})
	end

	starConnection = RunService.RenderStepped:Connect(function(delta)
		if finished then return end
		local clock = os.clock()
		for _, record in ipairs(stars) do
			local object = record.object
			if object and object.Parent then
				record.y = record.y + record.speed * delta
				if record.y > 1.05 then
					record.y = -0.05
					record.x = rng:NextNumber()
				end
				object.Position = UDim2.fromScale(record.x, record.y)
				local pulse = 0.15 + 0.4 * (0.5 + 0.5 * math.sin(clock * 2.2 + record.phase))
				object.BackgroundTransparency = math.clamp(pulse, 0, 0.9)
				-- red glow tint slight
				object.BackgroundColor3 = Color3.fromRGB(255, 230, 235)
			end
		end
		for _, record in ipairs(streaks) do
			local object = record.object
			if object and object.Parent then
				record.x = record.x + record.speed * delta
				if record.x > 1.15 then
					record.x = -0.15
					record.y = rng:NextNumber(0, 0.85)
				end
				object.Position = UDim2.fromScale(record.x, record.y)
				object.BackgroundTransparency = 0.2 + 0.35 * math.abs(math.sin(clock * 1.5 + record.y * 6))
			end
		end
	end)

	local titleHolder = Instance.new("Frame")
	titleHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	titleHolder.Position = UDim2.fromScale(0.5, 0.5)
	titleHolder.Size = UDim2.fromScale(0.5, 0.11)
	titleHolder.BackgroundTransparency = 1
	titleHolder.ZIndex = 6
	titleHolder.Parent = content

	local titleGlow = Instance.new("TextLabel")
	titleGlow.Size = UDim2.fromScale(1, 1)
	titleGlow.BackgroundTransparency = 1
	titleGlow.Text = "Voryx.gg"
	titleGlow.Font = Enum.Font.GothamBlack
	titleGlow.TextScaled = true
	titleGlow.TextColor3 = NAVY_DEEP
	titleGlow.TextTransparency = 1
	titleGlow.ZIndex = 5
	local glowStroke = Instance.new("UIStroke", titleGlow)
	glowStroke.Color = CYAN_FILL
	glowStroke.Thickness = 2.5
	glowStroke.Transparency = 1
	titleGlow.Parent = titleHolder

	local title = Instance.new("TextLabel")
	title.Size = UDim2.fromScale(1, 1)
	title.BackgroundTransparency = 1
	title.Text = "Voryx.gg"
	title.Font = Enum.Font.GothamBlack
	title.TextScaled = true
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextTransparency = 1
	title.ZIndex = 6
	local titleGradient = Instance.new("UIGradient", title)
	titleGradient.Rotation = 90
	titleGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, ICE_LIGHT),
		ColorSequenceKeypoint.new(0.45, CYAN_FILL),
		ColorSequenceKeypoint.new(1, CYAN_ACCENT),
	})
	title.Parent = titleHolder

	local track = Instance.new("Frame")
	track.AnchorPoint = Vector2.new(0.5, 0.5)
	track.Position = UDim2.fromScale(0.5, 0.6)
	track.Size = UDim2.new(0.4, 0, 0, 4)
	track.BackgroundColor3 = Color3.fromRGB(40, 12, 18)
	track.BackgroundTransparency = 1
	track.BorderSizePixel = 0
	track.ClipsDescendants = true
	track.ZIndex = 6
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
	local trackStroke = Instance.new("UIStroke", track)
	trackStroke.Color = CYAN_FILL
	trackStroke.Thickness = 1
	trackStroke.Transparency = 1
	track.Parent = content

	local fill = Instance.new("Frame")
	fill.Size = UDim2.fromScale(0, 1)
	fill.BackgroundColor3 = CYAN_ACCENT
	fill.BorderSizePixel = 0
	fill.ZIndex = 7
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
	local fillGradient = Instance.new("UIGradient", fill)
	fillGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, NAVY_DEEP),
		ColorSequenceKeypoint.new(0.65, CYAN_ACCENT),
		ColorSequenceKeypoint.new(1, ICE_LIGHT),
	})
	fill.Parent = track

	local fillHead = Instance.new("Frame")
	fillHead.AnchorPoint = Vector2.new(0.5, 0.5)
	fillHead.Position = UDim2.fromScale(0, 0.5)
	fillHead.Size = UDim2.new(0, 10, 0, 10)
	fillHead.BackgroundColor3 = ICE_LIGHT
	fillHead.BackgroundTransparency = 1
	fillHead.BorderSizePixel = 0
	fillHead.ZIndex = 8
	Instance.new("UICorner", fillHead).CornerRadius = UDim.new(1, 0)
	fillHead.Parent = track

	local skipBtn = Instance.new("TextButton")
	skipBtn.AnchorPoint = Vector2.new(1, 0)
	skipBtn.Position = UDim2.new(1, -14, 0, 14)
	skipBtn.Size = UDim2.fromOffset(78, 32)
	skipBtn.BackgroundColor3 = Color3.fromRGB(30, 8, 12)
	skipBtn.BackgroundTransparency = 0.15
	skipBtn.BorderSizePixel = 0
	skipBtn.Text = "SKIP"
	skipBtn.Font = Enum.Font.GothamBold
	skipBtn.TextSize = 13
	skipBtn.TextColor3 = Color3.fromRGB(255, 240, 242)
	skipBtn.ZIndex = 20
	skipBtn.Parent = screenGui
	Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 8)
	local sk = Instance.new("UIStroke", skipBtn)
	sk.Color = CYAN_FILL
	sk.Thickness = 1.3

	local function finishIntro()
		if finished then return end
		finished = true
		_G.__VoryxIntroDone = true
		if starConnection then
			pcall(function() starConnection:Disconnect() end)
			starConnection = nil
		end
		pcall(function()
			TweenService:Create(content, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {GroupTransparency = 1}):Play()
			TweenService:Create(space, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
		end)
		task.delay(0.55, function()
			pcall(function() screenGui:Destroy() end)
		end)
	end

	skipBtn.Activated:Connect(finishIntro)
	UserInputService.InputBegan:Connect(function(input)
		if finished then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			-- optional: single tap skip anywhere - keep only skip button to avoid accidental skip
		end
	end)

	task.spawn(function()
		-- music
		pcall(function()
			local file = "sunburn_intro_redrum.mp3"
			if not safeIsFile(file) then
				local songData = safeHttpGet("https://file.garden/algLafWA1jk8WMfK/redrum_spotdown.org%202.mp3")
				if songData then safeWriteFile(file, songData) end
			end
			local asset = safeGetAsset(file)
			if asset and asset ~= "" then
				local sound = Instance.new("Sound")
				sound.Name = "VoryxIntroSong"
				sound.SoundId = asset
				sound.Volume = 0.8
				sound.Parent = screenGui
				pcall(function() sound.TimePosition = 56 end)
				sound:Play()
			end
		end)

		if finished or not screenGui.Parent then return end

		tween(content, 0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {GroupTransparency = 0})
		tween(titleGlow, 0.95, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {TextTransparency = 0.55})
		tween(glowStroke, 0.95, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {Transparency = 0.5})
		tween(title, 0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {TextTransparency = 0})
		tween(titleHolder, 0.95, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
			Size = UDim2.fromScale(0.62, 0.142),
			Position = UDim2.fromScale(0.5, 0.45),
		})

		task.spawn(function()
			local dim = false
			while not finished and screenGui.Parent do
				dim = not dim
				tween(glowStroke, 1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, {
					Transparency = dim and 0.75 or 0.5,
				})
				task.wait(1.1)
			end
		end)

		task.wait(0.45)
		if finished then return end

		tween(track, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {BackgroundTransparency = 0})
		tween(trackStroke, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {Transparency = 0.35})
		tween(fillHead, 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {BackgroundTransparency = 0})
		tween(fill, 4.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {Size = UDim2.fromScale(1, 1)})
		tween(fillHead, 4.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {Position = UDim2.fromScale(1, 0.5)})

		task.spawn(function()
			local big = false
			while not finished and screenGui.Parent do
				big = not big
				tween(fillHead, 0.34, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, {
					Size = UDim2.new(0, big and 16 or 10, 0, big and 16 or 10),
				})
				task.wait(0.34)
			end
		end)

		task.wait(4.8)
		if finished then return end

		tween(title, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {TextTransparency = 1})
		tween(titleGlow, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {TextTransparency = 1})
		tween(titleHolder, 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
			Size = UDim2.fromScale(0.68, 0.156),
			Position = UDim2.fromScale(0.5, 0.44),
		})
		task.wait(0.14)
		finishIntro()
	end)
end

-- preload + play
task.spawn(function()
	pcall(function()
		local file = "sunburn_intro_redrum.mp3"
		if not safeIsFile(file) then
			local songData = safeHttpGet("https://file.garden/algLafWA1jk8WMfK/redrum_spotdown.org%202.mp3")
			if songData then safeWriteFile(file, songData) end
		end
	end)
	task.wait(0.25)
	playVoryxIntro()
end)


task.spawn(function() task.wait(8) _G.__VoryxIntroDone = true end)


do
	local t0 = os.clock()
	while not _G.__VoryxIntroDone and (os.clock() - t0) < 8 do
		task.wait(0.05)
	end
	_G.__VoryxIntroDone = nil
end

-- Auto Grab photo integration: Asset ID 115554680985900.




-- ============================================================
--  Voryx | EDICIÓN MORADO CON NEGRO – MODIFICADO CON NIGHT #3.VS
-- ============================================================


-- MENU MENU INTEGRATION
-- Visual shell transplanted onto NIGHT while preserving its feature callbacks.
-- AutoGrab, Rojo/Negro, keybinds, pages and saved state remain owned by NIGHT.
-- SECCIÓN 1: CONFIGURACIÓN INICIAL (BRANDING, COLORES, STATE)
-- ============================================================
local CANDY_BRAND = " VORYX.GG "
local CANDY_DISCORD = "https://discord.gg/nXF6KGHBS"
local CANDY_COLORS = {
	BG = Color3.fromRGB(8, 14, 28),
	PANEL = Color3.fromRGB(14, 14, 14),
	CARD = Color3.fromRGB(24, 24, 24),
	ACCENT = Color3.fromRGB(0, 190, 230),
	PURPLE = Color3.fromRGB(120, 220, 255),
	ICE = Color3.fromRGB(255, 200, 210),
	HOVER = Color3.fromRGB(30, 30, 30),
	TEXT = Color3.fromRGB(255, 255, 255),
	SECONDARY = Color3.fromRGB(200, 200, 200),
	STROKE = Color3.fromRGB(235, 235, 235),
	INPUT = Color3.fromRGB(0, 190, 230),
	OFF = Color3.fromRGB(18, 18, 18)
}

local BG         = Color3.fromRGB(8, 14, 28)
local SIDEBAR_BG = Color3.fromRGB(14, 14, 14)
local CARD_BG    = Color3.fromRGB(24, 24, 24)
local CARD_HOV   = Color3.fromRGB(0, 190, 230)
local KB_BG      = Color3.fromRGB(18, 18, 18)

local WHITE      = Color3.fromRGB(255, 255, 255)
local DIM        = Color3.fromRGB(200, 200, 200)
local DIM2       = Color3.fromRGB(24, 24, 24)

local BORDER     = Color3.fromRGB(60, 60, 68)
local BORDER2    = Color3.fromRGB(38, 38, 44)
local OPTION_TRANSPARENCY = 0.42
local OPTION_HOVER_TRANSPARENCY = 0.22
local TAB_TRANSPARENCY = 0.35
local TAB_HOVER_TRANSPARENCY = 0.16
local INPUT_TRANSPARENCY = 0.24

repeat task.wait() until game:IsLoaded()

pcall(function()
	for _, f in ipairs({
		"Vereuxv2_positions.json", "Vereuxv2_positions.backup.json", "Vereuxv2_positions.tmp.json"
	}) do
		if type(isfile)=="function" and isfile(f) and type(delfile)=="function" then pcall(delfile, f) end
	end
end)

-- Starborn font (apply to every letter/label)
do
	task.spawn(function()
		local function httpGet(url)
			local body = nil
			pcall(function() body = game:HttpGet(url) end)
			if type(body) == "string" and #body > 1000 then return body end
			local req = (request or http_request or (syn and syn.request))
			if type(req) == "function" then
				local ok, res = pcall(function() return req({Url = url, Method = "GET"}) end)
				if ok and res then
					local b = res.Body or res.body
					if type(b) == "string" and #b > 1000 then return b end
				end
			end
			return nil
		end

		if type(writefile) ~= "function" then return end
		if type(getcustomasset) ~= "function" then return end

		-- download ttf
		local need = true
		if type(isfile) == "function" and isfile("starborn.ttf") then
			need = false
		end
		if need then
			local data = httpGet("https://files.catbox.moe/pwgdui.ttf")
			if not data then return end
			pcall(writefile, "starborn.ttf", data)
		end

		local okA, ttfAsset = pcall(getcustomasset, "starborn.ttf")
		if not okA or not ttfAsset then return end

		local HttpService = game:GetService("HttpService")
		local jsonName = "starborn_sprite.json"
		pcall(writefile, jsonName, HttpService:JSONEncode({
			name = "Starborn",
			faces = {{
				name = "Regular",
				weight = 400,
				style = "normal",
				assetId = ttfAsset,
			}}
		}))

		local okJ, jsonAsset = pcall(getcustomasset, jsonName)
		if not okJ or not jsonAsset then return end

		local okF, font = pcall(function() return Font.new(jsonAsset) end)
		if not okF or not font then
			okF, font = pcall(function() return Font.new(getcustomasset(jsonName)) end)
		end
		if not okF or not font then return end

		_G.SPRITE_STARBORN = font

		local function applyOne(v)
			if not v or not v.Parent then return end
			if not (v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox")) then return end
			-- never touch YouTube Music Player / SinisterYMP UI
			local p = v
			for _ = 1, 12 do
				if not p then break end
				if p:IsA("ScreenGui") then
					local n = tostring(p.Name or "")
					if n == "SinisterYMP" or n:find("YouTube", 1, true) or n:find("YMP", 1, true) or n:find("Music", 1, true) then
						return
					end
					break
				end
				p = p.Parent
			end
			local ok = pcall(function()
				local fs = tostring(v.FontFace)
				if fs:find("BuilderIcons", 1, true) then return end
				v.FontFace = font
			end)
		end

		local function scan(root)
			if not root then return end
			for _, v in ipairs(root:GetDescendants()) do
				applyOne(v)
			end
		end

		local function hook(root)
			if not root then return end
			scan(root)
			pcall(function()
				root.DescendantAdded:Connect(function(obj)
					task.defer(function() applyOne(obj) end)
				end)
			end)
		end

		-- apply many times so late UI + intro words get font
		for i = 1, 25 do
			pcall(function() hook(game:GetService("CoreGui")) end)
			pcall(function()
				local LP = game:GetService("Players").LocalPlayer
				if LP then
					local pg = LP:FindFirstChild("PlayerGui")
					if pg then hook(pg) end
				end
			end)
			-- also any ScreenGui named intro
			pcall(function()
				local cg = game:GetService("CoreGui")
				local intro = cg:FindFirstChild("SpriteDuels_Intro")
				if intro then scan(intro) end
			end)
			task.wait(0.2)
		end
	end)
end

-- ============================================================
-- (multi-intro removed)







local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- ===== ESTILO MORADO CON NEGRO Y RESPUESTA TÁCTIL DE BOTONES =====
local BUTTON_TAUPE = Color3.fromRGB(0, 190, 230)
local BUTTON_TOUCH_BLACK = Color3.fromRGB(0, 0, 0)

local function bindTaupeButton(button)
    if not button:IsA("TextButton") or button:GetAttribute("TaupeButtonBound") then return end
    if button.BackgroundTransparency >= 0.95 then return end
    button:SetAttribute("TaupeButtonBound", true)
    button.AutoButtonColor = false
    button.BackgroundColor3 = BUTTON_TAUPE
    button.Activated:Connect(function()
        if not button.Parent then return end
        button.BackgroundColor3 = BUTTON_TOUCH_BLACK
        task.delay(0.14, function()
            if button and button.Parent then button.BackgroundColor3 = BUTTON_TAUPE end
        end)
    end)
end


-- SECCIÓN 2: ALERTA DE PING ALTO
task.spawn(function()
    local env = (getgenv and getgenv()) or _G
    env.__SPRITE_HIGH_PING_RUN = (env.__SPRITE_HIGH_PING_RUN or 0) + 1
    local thisRun = env.__SPRITE_HIGH_PING_RUN
    env.__SPRITE_INTRO_FINISHED_RUN = 0
    local shown = false

    local function getPingMilliseconds()
        local ok, value = pcall(function()
            local stats = game:GetService("Stats")
            local network = stats:FindFirstChild("Network")
            local serverStats = network and network:FindFirstChild("ServerStatsItem")
            local pingItem = serverStats and (serverStats:FindFirstChild("Data Ping") or serverStats:FindFirstChild("Ping"))
            if not pingItem then
                return nil
            end

            local numericValue
            pcall(function()
                numericValue = pingItem:GetValue()
            end)
            if type(numericValue) == "number" then
                return numericValue
            end

            local valueString = pingItem:GetValueString()
            return tonumber(tostring(valueString):match("[%d%.]+"))
        end)
        return ok and tonumber(value) or nil
    end

    local function showHighPingAlert()
        local TweenService = game:GetService("TweenService")
        local CoreGui = game:GetService("CoreGui")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local playerGui = player and player:FindFirstChildOfClass("PlayerGui")

        pcall(function()
            local old = CoreGui:FindFirstChild("CryonHighPingAlert")
            if old then old:Destroy() end
        end)
        pcall(function()
            local old = playerGui and playerGui:FindFirstChild("CryonHighPingAlert")
            if old then old:Destroy() end
        end)

        local gui = Instance.new("ScreenGui")
        gui.Name = "CryonHighPingAlert"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = false
        gui.DisplayOrder = 10000
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

        local parented = pcall(function()
            gui.Parent = CoreGui
        end)
        if not parented or not gui.Parent then
            gui.Parent = playerGui
        end
        if not gui.Parent then
            gui:Destroy()
            return
        end

        local bar = Instance.new("Frame")
        bar.Name = "AlertBar"
        bar.AnchorPoint = Vector2.new(0.5, 0)
        bar.Position = UDim2.new(0.5, 0, 0, -44)
        bar.Size = UDim2.new(0, 310, 0, 32)
        bar.BackgroundColor3 = Color3.fromRGB(10,10,12)
        bar.BackgroundTransparency = 0.06
        bar.BorderSizePixel = 0
        bar.ClipsDescendants = true
        bar.ZIndex = 100
        bar.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = bar

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 170, 210)
        stroke.Transparency = 0.2
        stroke.Thickness = 1
        stroke.Parent = bar

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(8,8,10)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 170, 210)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,10)),
        })
        gradient.Parent = bar

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.Text = "high ping! Your ping is more than 150."
        label.TextColor3 = Color3.fromRGB(0, 190, 230)
        label.TextSize = 13
        label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        label.TextStrokeTransparency = 0.55
        label.TextWrapped = false
        label.TextScaled = false
        label.ZIndex = 102
        label.Parent = bar

        local slideIn = TweenService:Create(
            bar,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 0, 0, 10)}
        )
        slideIn:Play()
        slideIn.Completed:Wait()

        task.wait(2)

        local slideOut = TweenService:Create(
            bar,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, 0, -44)}
        )
        slideOut:Play()
        slideOut.Completed:Wait()
        gui:Destroy()
    end

    while env.__SPRITE_HIGH_PING_RUN == thisRun and env.__SPRITE_INTRO_FINISHED_RUN ~= thisRun do
        task.wait(0.1)
    end

    while env.__SPRITE_HIGH_PING_RUN == thisRun and not shown do
        local ping = getPingMilliseconds()
        if ping and ping > 150 then
            shown = true
            showHighPingAlert()
            break
        end
        task.wait(1)
    end
end)

-- SECCIÓN 3: INTRO ANIMADA (la mejor + canción Ajjan.Vs)
-- RANDOM IMAGE + MUSIC + BEAT EFFECTS + SKIP
do
	local envI = (getgenv and getgenv()) or _G
	-- Complex intro disabled: splash handles background + MENU letters
	task.spawn(function()
		task.wait(5)
		envI.__SPRITE_INTRO_FINISHED_RUN = envI.__SPRITE_HIGH_PING_RUN or 0
	end)
	if false then
		task.spawn(function()
--============================================================
-- VORYX.GG INTRO
-- YOUR ORIGINAL VERSION
-- RANDOM IMAGE + MUSIC + BEAT EFFECTS + SKIP
--============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--============================================================
-- SETTINGS
--============================================================

-- Canción de Ajjan.Vs Intro (make by ! kaii)
local MUSIC_SOUND_ID =
	"rbxassetid://136350225160627"

local MUSIC_VOLUME =
	0.75

local BPM =
	100

local BEAT =
	60 / BPM

-- IMAGE 2 FIRST
-- IMAGE 1 SECOND
-- THEN RANDOM WITHOUT REPEATING
local IMAGES = {
	"rbxassetid://77955798667352",
	"rbxassetid://77955798667352",
	"rbxassetid://77955798667352",
	"rbxassetid://77955798667352"
}

--============================================================
-- CLEAN OLD
--============================================================

for _, name in ipairs({
	"SpriteDuelsIntro"
}) do

	local old =
		PlayerGui:FindFirstChild(name)

	if old then
		old:Destroy()
	end

end

--============================================================
-- IMAGE ORDER
--============================================================

local lastImage =
	shared.SpriteDuels_LastImage

local imageIndex

if not shared.SpriteDuels_Run then

	shared.SpriteDuels_Run =
		1

	imageIndex =
		2

elseif shared.SpriteDuels_Run == 1 then

	shared.SpriteDuels_Run =
		2

	imageIndex =
		1

else

	local choices = {}

	for i = 1, #IMAGES do

		if i ~= lastImage then
			table.insert(
				choices,
				i
			)
		end

	end

	imageIndex =
		choices[
			math.random(
				1,
				#choices
			)
		]

end

shared.SpriteDuels_LastImage =
	imageIndex

local IMAGE_ID =
	IMAGES[imageIndex]

--============================================================
-- INTRO STATE
--============================================================

local introActive =
	true

local introFinished =
	false

local introSound =
	nil

--============================================================
-- GUI
--============================================================

local gui =
	Instance.new("ScreenGui")

gui.Name =
	"SpriteDuelsIntro"

gui.IgnoreGuiInset =
	true

gui.ResetOnSpawn =
	false

gui.DisplayOrder =
	999999

gui.ZIndexBehavior =
	Enum.ZIndexBehavior.Sibling

pcall(function()
	gui.Parent = game:GetService("CoreGui")
end)
if not gui.Parent then
	gui.Parent = PlayerGui
end

--============================================================
-- BACKGROUND
--============================================================

local background =
	Instance.new("Frame")

background.Size =
	UDim2.fromScale(
		1,
		1
	)

background.BackgroundColor3 =
	Color3.fromRGB(
		0,
		0,
		0
	)

background.BorderSizePixel =
	0

background.ClipsDescendants =
	true

background.Parent =
	gui

--============================================================
-- IMAGE
--============================================================

local image =
	Instance.new("ImageLabel")

image.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

image.Position =
	UDim2.fromScale(
		0.5,
		0.5
	)

image.Size =
	UDim2.fromScale(
		1.08,
		1.08
	)

image.BackgroundTransparency =
	1

image.Image =
	IMAGE_ID

image.ImageTransparency =
	0

image.ImageColor3 =
	Color3.fromRGB(255, 255, 255)

image.ScaleType =
	Enum.ScaleType.Crop

image.ZIndex =
	1

image.Visible =
	true

task.spawn(function()
	local asset = tostring(IMAGE_ID):match("%d+") or "77955798667352"
	local urls = {
		"rbxassetid://" .. asset,
		"rbxthumb://type=Asset&id=" .. asset .. "&w=768&h=432",
		"rbxthumb://type=Asset&id=" .. asset .. "&w=420&h=420",
	}
	pcall(function()
		game:GetService("ContentProvider"):PreloadAsync(urls)
	end)
	for i = 1, 20 do
		if not image or not image.Parent then break end
		image.Image = urls[((i - 1) % #urls) + 1]
		image.ImageTransparency = 0
		image.Visible = true
		local okLoad = false
		pcall(function() okLoad = image.IsLoaded end)
		if okLoad then break end
		task.wait(0.2)
	end
end)

image.Parent =
	background

--============================================================
-- DARK OVERLAY
--============================================================

local dark =
	Instance.new("Frame")

dark.Size =
	UDim2.fromScale(
		1,
		1
	)

dark.BackgroundColor3 =
	Color3.fromRGB(
		0,
		0,
		0
	)

dark.BackgroundTransparency =
	0.55

dark.BorderSizePixel =
	0

dark.ZIndex =
	2

dark.Parent =
	background

--============================================================
-- SKIP INTRO BUTTON
--============================================================

local skip =
	Instance.new("TextButton")

skip.AnchorPoint =
	Vector2.new(
		1,
		1
	)

skip.Position =
	UDim2.new(
		1,
		-14,
		1,
		-14
	)

skip.Size =
	UDim2.fromOffset(
		105,
		36
	)

skip.BackgroundColor3 =
	Color3.fromRGB(
		15,
		15,
		18
	)

skip.BackgroundTransparency =
	0.15

skip.BorderSizePixel =
	0

skip.Text =
	"SKIP INTRO"

skip.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

skip.TextSize =
	12

skip.Font =
	Enum.Font.GothamBold

skip.AutoButtonColor =
	false

skip.ZIndex =
	500

skip.Parent =
	gui

local skipCorner =
	Instance.new("UICorner")

skipCorner.CornerRadius =
	UDim.new(
		0,
		7
	)

skipCorner.Parent =
	skip

local skipStroke =
	Instance.new("UIStroke")

skipStroke.Color =
	Color3.fromRGB(
		255,
		255,
		255
	)

skipStroke.Transparency =
	0.75

skipStroke.Thickness =
	1

skipStroke.Parent =
	skip

--============================================================
-- FLASH
--============================================================

local flash =
	Instance.new("Frame")

flash.Size =
	UDim2.fromScale(
		1,
		1
	)

flash.BackgroundColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

flash.BackgroundTransparency =
	1

flash.BorderSizePixel =
	0

flash.ZIndex =
	400

flash.Parent =
	gui

--============================================================
-- TITLE
--============================================================

local introTitle =
	Instance.new("TextLabel")

introTitle.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

introTitle.Position =
	UDim2.fromScale(
		0.5,
		0.5
	)

introTitle.Size =
	UDim2.fromScale(
		1.1,
		0.22
	)

introTitle.BackgroundTransparency =
	1

introTitle.Text =
	"VORYX.GG"

introTitle.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

introTitle.Visible =
	true

introTitle.TextTransparency =
	0

introTitle.TextStrokeTransparency =
	0.25

introTitle.TextStrokeColor3 =
	Color3.fromRGB(0, 0, 0)

introTitle.TextScaled =
	true

introTitle.Font =
	Enum.Font.GothamBlack

introTitle.ZIndex =
	20

introTitle.Parent =
	background

local titleStroke =
	Instance.new("UIStroke")

titleStroke.Color =
	Color3.fromRGB(
		0,
		0,
		0
	)

titleStroke.Thickness =
	3

titleStroke.Transparency =
	0.2

titleStroke.Parent =
	introTitle

--============================================================
-- SUBTITLE
--============================================================

local introSubtitle =
	Instance.new("TextLabel")

introSubtitle.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

introSubtitle.Position =
	UDim2.fromScale(
		0.5,
		0.59
	)

introSubtitle.Size =
	UDim2.fromScale(
		0.6,
		0.05
	)

introSubtitle.BackgroundTransparency =
	1

introSubtitle.Text =
	"https://discord.gg/nXF6KGHBS-duels"

introSubtitle.TextColor3 =
	Color3.fromRGB(
		205,
		205,
		205
	)

introSubtitle.TextTransparency =
	0

introSubtitle.TextStrokeTransparency =
	0.35

introSubtitle.TextStrokeColor3 =
	Color3.fromRGB(0, 0, 0)

introSubtitle.TextScaled =
	true

introSubtitle.Font =
	Enum.Font.GothamBold

introSubtitle.ZIndex =
	20

introSubtitle.Parent =
	background

task.spawn(function()
	local url = IMAGE_ID
	pcall(function()
		game:GetService("ContentProvider"):PreloadAsync({url})
	end)
	for i = 1, 20 do
		if image and image.Parent then
			image.Image = url
			image.ImageTransparency = 0
			image.ImageColor3 = Color3.fromRGB(255, 255, 255)
			image.Visible = true
		end
		if introTitle and introTitle.Parent then
			introTitle.Text = "VORYX.GG"
			introTitle.TextTransparency = 0
			introTitle.TextStrokeTransparency = 0
			introTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			introTitle.Visible = true
		end
		if introSubtitle and introSubtitle.Parent then
			introSubtitle.TextTransparency = 0
			introSubtitle.Visible = true
		end
		task.wait(0.15)
	end
end)

--============================================================
-- PLAY MUSIC (canción Ajjan.Vs – rbxassetid://136350225160627)
--============================================================

task.spawn(function()

	if not introActive then
		return
	end

	introSound =
		Instance.new("Sound")

	introSound.Name =
		"SpriteDuelsIntroMusic"

	introSound.SoundId =
		MUSIC_SOUND_ID

	introSound.Volume =
		MUSIC_VOLUME

	introSound.Looped =
		false

	introSound.Parent =
		SoundService

	pcall(function()
		introSound:Play()
	end)

end)

--============================================================
-- FINISH
--============================================================

local function finishIntro()

	if introFinished then
		return
	end

	introFinished =
		true

	introActive =
		false

	pcall(function()
		local env = (getgenv and getgenv()) or _G
		env.__SPRITE_INTRO_FINISHED_RUN = env.__SPRITE_HIGH_PING_RUN or 0
	end)

	if introSound then

		pcall(function()

			TweenService:Create(
				introSound,
				TweenInfo.new(
					0.35
				),
				{
					Volume = 0
				}
			):Play()

		end)

		task.delay(
			0.4,
			function()

				pcall(function()

					introSound:Stop()
					introSound:Destroy()

				end)

			end
		)

	end

	pcall(function()
		gui:Destroy()
	end)

end

--============================================================
-- SKIP
--============================================================

skip.MouseButton1Click:Connect(
	finishIntro
)

--============================================================
-- SKIP HOVER
--============================================================

skip.MouseEnter:Connect(function()

	TweenService:Create(
		skip,
		TweenInfo.new(
			0.12
		),
		{
			BackgroundColor3 =
				Color3.fromRGB(
					55,
					55,
					60
				)
		}
	):Play()

end)

skip.MouseLeave:Connect(function()

	TweenService:Create(
		skip,
		TweenInfo.new(
			0.12
		),
		{
			BackgroundColor3 =
				Color3.fromRGB(
					15,
					15,
					18
				)
		}
	):Play()

end)

--============================================================
-- IMAGE FADE IN
--============================================================

TweenService:Create(
	image,
	TweenInfo.new(
		1.1,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.Out
	),
	{
		ImageTransparency =
			0
	}
):Play()

--============================================================
-- SLOW ZOOM
--============================================================

TweenService:Create(
	image,
	TweenInfo.new(
		18,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut
	),
	{
		Size =
			UDim2.fromScale(
				1.18,
				1.18
			)
	}
):Play()

--============================================================
-- BEAT FLASH
--============================================================

task.spawn(function()

	while introActive
		and gui.Parent do

		flash.BackgroundTransparency =
			0.8

		TweenService:Create(
			flash,
			TweenInfo.new(
				0.12,
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			),
			{
				BackgroundTransparency =
					1
			}
		):Play()

		task.wait(
			BEAT
		)

	end

end)

--============================================================
-- TITLE
--============================================================

task.wait(1.5)

if not introActive then
	return
end

TweenService:Create(
	introTitle,
	TweenInfo.new(
		0.7,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.Out
	),
	{
		Size =
			UDim2.fromScale(
				0.9,
				0.18
			),

		TextTransparency =
			0
	}
):Play()

TweenService:Create(
	titleStroke,
	TweenInfo.new(
		0.5
	),
	{
		Transparency =
			0
	}
):Play()

--============================================================
-- TITLE SHAKE
--============================================================

task.wait(1)

for i = 1, 18 do

	if not introActive then
		return
	end

	introTitle.Position =
		UDim2.fromScale(
			0.5 +
				math.random(
					-8,
					8
				) / 1000,

			0.5 +
				math.random(
					-8,
					8
				) / 1000
		)

	task.wait(
		0.025
	)

end

introTitle.Position =
	UDim2.fromScale(
		0.5,
		0.5
	)

--============================================================
-- SUBTITLE
--============================================================

TweenService:Create(
	introSubtitle,
	TweenInfo.new(
		0.6,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.Out
	),
	{
		TextTransparency =
			0
	}
):Play()

--============================================================
-- HOLD
--============================================================

task.wait(7)

if not introActive then
	return
end

--============================================================
-- FINAL BEAT FLASHES
--============================================================

for i = 1, 14 do

	if not introActive then
		return
	end

	flash.BackgroundTransparency =
		0

	task.wait(
		0.025
	)

	flash.BackgroundTransparency =
		1

	task.wait(
		0.065
	)

end

--============================================================
-- EXTRA HOLD
--============================================================

task.wait(2)

if not introActive then
	return
end

--============================================================
-- TITLE FADE
--============================================================

TweenService:Create(
	introTitle,
	TweenInfo.new(
		1.2,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.In
	),
	{
		TextTransparency =
			1
	}
):Play()

TweenService:Create(
	introSubtitle,
	TweenInfo.new(
		1,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.In
	),
	{
		TextTransparency =
			1
	}
):Play()

TweenService:Create(
	titleStroke,
	TweenInfo.new(
		1
	),
	{
		Transparency =
			1
	}
):Play()

--============================================================
-- IMAGE FADE
--============================================================

TweenService:Create(
	image,
	TweenInfo.new(
		1.5,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.In
	),
	{
		ImageTransparency =
			1
	}
):Play()

TweenService:Create(
	dark,
	TweenInfo.new(
		1.5
	),
	{
		BackgroundTransparency =
			1
	}
):Play()

--============================================================
-- MUSIC FADE
--============================================================

if introSound and
	introSound.Parent then

	TweenService:Create(
		introSound,
		TweenInfo.new(
			1.5,
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.In
		),
		{
			Volume =
				0
		}
	):Play()

end

--============================================================
-- FINAL BLACK FADE
--============================================================

local finalFade =
	Instance.new("Frame")

finalFade.Size =
	UDim2.fromScale(
		1,
		1
	)

finalFade.BackgroundColor3 =
	Color3.fromRGB(
		0,
		0,
		0
	)

finalFade.BackgroundTransparency =
	1

finalFade.BorderSizePixel =
	0

finalFade.ZIndex =
	1000

finalFade.Parent =
	gui

TweenService:Create(
	finalFade,
	TweenInfo.new(
		1.5,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.In
	),
	{
		BackgroundTransparency =
			0
	}
):Play()

task.wait(
	1.6
)

finishIntro()

		end)
	end
end


-- ANIMATIONS isolated (no locals into main hub)
;(function()
local currentAnimPack = nil
local originalAnims = nil -- guarda las animaciones normales del personaje

ANIM_PACKS = {
	["Adidas Sports"] = {WalkAnim=18537392113,RunAnim=18537384940,JumpAnim=18537380791,FallAnim=18537367238,SwimIdle=18537387180,Swim=18537389531,Animation1=18537376492,Animation2=18537371272,ClimbAnim=18537363391},
	["Adidas Community"] = {WalkAnim=122150855457006,RunAnim=82598234841035,JumpAnim=75290611992385,FallAnim=98600215928904,SwimIdle=109346520324160,Swim=133308483266208,Animation1=122257458498464,Animation2=102357151005774,ClimbAnim=88763136693023},
	["Adidas Aura"] = {WalkAnim=83842218823011,RunAnim=118320322718866,JumpAnim=109996626521204,FallAnim=95603166884636,SwimIdle=94922130551805,Swim=134530128383903,Animation1=110211186840347,Animation2=114191137265065,ClimbAnim=97824616490448},
	["Wicked Popular"] = {WalkAnim=92072849924640,RunAnim=72301599441680,JumpAnim=104325245285198,FallAnim=121152442762481,Animation1=118832222982049,ClimbAnim=131326830509784,SwimIdle=113199415118199,Swim=99384245425157,Animation2=76049494037641},
	["Elder"] = {WalkAnim=10921111375,RunAnim=10921104374,JumpAnim=10921107367,FallAnim=10921105765,SwimIdle=10921110146,Swim=10921108971,ClimbAnim=10921100400,Animation1=10921101664,Animation2=10921102574},
	["Zombie"] = {WalkAnim=10921355261,RunAnim=616163682,JumpAnim=10921351278,FallAnim=10921350320,SwimIdle=10921353442,Swim=10921352344,Animation1=10921344533,Animation2=10921345304,ClimbAnim=10921343576},
	["Mage"] = {WalkAnim=10921152678,RunAnim=10921148209,JumpAnim=10921149743,FallAnim=10921148939,SwimIdle=10921151661,Swim=10921150788,ClimbAnim=10921143404,Animation1=10921144709,Animation2=10921145797},
	["Catwalk Glam"] = {WalkAnim=109168724482748,RunAnim=81024476153754,JumpAnim=116936326516985,FallAnim=92294537340807,SwimIdle=98854111361360,Swim=134591743181628,ClimbAnim=119377220967554,Animation1=133806214992291,Animation2=94970088341563},
	["Astronaut"] = {WalkAnim=10921046031,RunAnim=10921039308,JumpAnim=10921042494,FallAnim=10921040576,SwimIdle=10921045006,Swim=10921044000,ClimbAnim=10921032124,Animation1=10921034824,Animation2=10921036806},
	['Wicked "Dancing Through Life"'] = {WalkAnim=73718308412641,RunAnim=135515454877967,JumpAnim=78508480717326,FallAnim=78147885297412,SwimIdle=129183123083281,Swim=110657013921774,ClimbAnim=129447497744818,Animation1=92849173543269,Animation2=132238900951109},
	["Werewolf"] = {WalkAnim=10921342074,RunAnim=10921336997,FallAnim=10921337907,SwimIdle=10921341319,Swim=10921340419,ClimbAnim=10921329322,Animation1=10921330408,Animation2=10921333667},
	["Superhero"] = {WalkAnim=10921298616,RunAnim=10921291831,JumpAnim=10921294559,FallAnim=10921293373,SwimIdle=10921297391,Swim=10921295495,ClimbAnim=10921286911,Animation1=10921288909,Animation2=10921290167},
	["Toy"] = {WalkAnim=10921312010,RunAnim=10921306285,JumpAnim=10921308158,FallAnim=10921307241,SwimIdle=10921310341,Swim=10921309319,ClimbAnim=10921300839,Animation1=10921301576},
	["No Boundaries"] = {WalkAnim=18747074203,RunAnim=18747070484,JumpAnim=18747069148,FallAnim=18747062535,SwimIdle=18747071682,Swim=18747073181,ClimbAnim=18747060903,Animation1=18747067405,Animation2=18747063918},
	["NFL"] = {WalkAnim=110358958299415,RunAnim=117333533048078,JumpAnim=119846112151352,FallAnim=129773241321032,SwimIdle=79090109939093,Swim=132697394189921,ClimbAnim=134630013742019,Animation1=92080889861410,Animation2=74451233229259},
	["Amazon Unboxed"] = {WalkAnim=90478085024465,RunAnim=134824450619865,JumpAnim=121454505477205,FallAnim=94788218468396,SwimIdle=129126268464847,Swim=105962919001086,ClimbAnim=121145883950231,Animation1=98281136301627},
	["Vampire"] = {WalkAnim=10921326949,RunAnim=10921320299,JumpAnim=10921322186,FallAnim=10921321317,SwimIdle=10921325443,Swim=10921324408,ClimbAnim=10921314188,Animation1=10921315373},
	["Ninja"] = {RunAnim=656118852,WalkAnim=656121766,JumpAnim=656117878,FallAnim=656115606,Swim=656119721,SwimIdle=656121397,ClimbAnim=656114359,Idle={656117400,656118341,886742569}},
	["Robot"] = {RunAnim=616091570,WalkAnim=616095330,JumpAnim=616090535,FallAnim=616087089,Swim=616092998,SwimIdle=616094091,ClimbAnim=616086039,Idle={616088211,616089559,885531463}},
	["Levitation"] = {RunAnim=616010382,WalkAnim=616013216,JumpAnim=616008936,FallAnim=616005863,Swim=616011509,SwimIdle=616012453,ClimbAnim=616003713,Idle={616006778,616008087,886862142}},
	["Stylish"] = {RunAnim=616140816,WalkAnim=616146177,JumpAnim=616139451,FallAnim=616134815,Swim=616143377,SwimIdle=616144772,ClimbAnim=616133594,Idle={616136790,616138447,886888594}},
	["Bubbly"] = {RunAnim=910025107,WalkAnim=910034870,JumpAnim=910016857,FallAnim=910001910,Swim=910028158,SwimIdle=910030921,ClimbAnim=909997997,Idle={910004836,910009958,1018536639}},
	["Cartoon"] = {RunAnim=742638842,WalkAnim=742640026,JumpAnim=742637942,FallAnim=742637151,Swim=742639220,SwimIdle=742639812,ClimbAnim=742636889,Idle={742637544,742638445,885477856}},
}
_animApplying = false
function _animWaitForAnimate(char)
	for _=1,40 do
		local a=char:FindFirstChild("Animate")
		if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then return a end
		task.wait(0.1)
	end
	return nil
end
function _animSetAnim(obj,id)
	if not obj or not id then return end
	local sid = tostring(id)
	if not sid:find("rbxassetid://") then
		sid = "rbxassetid://" .. sid:gsub("%D", "")
	end
	pcall(function() obj.AnimationId = sid end)
end
function _animStopTracks(hum)
	if not hum then return end
	for _,t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
end
function _animEnsure(folder,name)
	if not folder then return nil end
	local a=folder:FindFirstChild(name)
	if not a then a=Instance.new("Animation");a.Name=name;a.Parent=folder end
	return a
end
function _animPick(pack,...)
	for i=1,select("#",...) do
		local k=select(i,...);local v=pack[k];if v~=nil then return v end
	end
	return nil
end

-- Guarda las animaciones originales (normales) del personaje la primera vez
local function _animSaveOriginals(animate)
	if originalAnims or not animate then return end
	local function getId(folder, animName)
		if not folder then return nil end
		local a = folder:FindFirstChild(animName)
		return a and a.AnimationId or nil
	end
	originalAnims = {
		RunAnim   = getId(animate:FindFirstChild("run"), "RunAnim"),
		WalkAnim  = getId(animate:FindFirstChild("walk"), "WalkAnim"),
		JumpAnim  = getId(animate:FindFirstChild("jump"), "JumpAnim"),
		FallAnim  = getId(animate:FindFirstChild("fall"), "FallAnim"),
		ClimbAnim = getId(animate:FindFirstChild("climb"), "ClimbAnim"),
		Swim      = getId(animate:FindFirstChild("swim"), "Swim"),
		SwimIdle  = getId(animate:FindFirstChild("swimidle"), "SwimIdle"),
		Animation1 = getId(animate:FindFirstChild("idle"), "Animation1"),
		Animation2 = getId(animate:FindFirstChild("idle"), "Animation2"),
	}
end

-- Restaura animaciones normales (Off / Default)
local function restoreDefaultAnims(char)
	char = char or LP.Character
	if not char then return false end
	local animate = _animWaitForAnimate(char)
	if not animate then return false end
	local hum = char:FindFirstChildOfClass("Humanoid")
	_animStopTracks(hum)

	-- Si tenemos originales guardados, los usamos
	if originalAnims then
		_animSetAnim(_animEnsure(animate:FindFirstChild("run"), "RunAnim"), originalAnims.RunAnim)
		_animSetAnim(_animEnsure(animate:FindFirstChild("walk"), "WalkAnim"), originalAnims.WalkAnim)
		_animSetAnim(_animEnsure(animate:FindFirstChild("jump"), "JumpAnim"), originalAnims.JumpAnim)
		_animSetAnim(_animEnsure(animate:FindFirstChild("fall"), "FallAnim"), originalAnims.FallAnim)
		_animSetAnim(_animEnsure(animate:FindFirstChild("climb"), "ClimbAnim"), originalAnims.ClimbAnim)
		_animSetAnim(_animEnsure(animate:FindFirstChild("swim"), "Swim"), originalAnims.Swim)
		_animSetAnim(_animEnsure(animate:FindFirstChild("swimidle"), "SwimIdle"), originalAnims.SwimIdle)
		local idleFolder = animate:FindFirstChild("idle")
		if idleFolder then
			_animSetAnim(_animEnsure(idleFolder, "Animation1"), originalAnims.Animation1)
			_animSetAnim(_animEnsure(idleFolder, "Animation2"), originalAnims.Animation2)
		end
	else
		-- Fallback: IDs por defecto de Roblox R15
		local DEFAULT = {
			RunAnim = "rbxassetid://913376220",
			WalkAnim = "rbxassetid://913402848",
			JumpAnim = "rbxassetid://507765000",
			FallAnim = "rbxassetid://507767968",
			ClimbAnim = "rbxassetid://507765644",
			Swim = "rbxassetid://913384386",
			SwimIdle = "rbxassetid://913389285",
			Animation1 = "rbxassetid://507766666",
			Animation2 = "rbxassetid://507766951",
		}
		_animSetAnim(_animEnsure(animate:FindFirstChild("run"), "RunAnim"), DEFAULT.RunAnim)
		_animSetAnim(_animEnsure(animate:FindFirstChild("walk"), "WalkAnim"), DEFAULT.WalkAnim)
		_animSetAnim(_animEnsure(animate:FindFirstChild("jump"), "JumpAnim"), DEFAULT.JumpAnim)
		_animSetAnim(_animEnsure(animate:FindFirstChild("fall"), "FallAnim"), DEFAULT.FallAnim)
		_animSetAnim(_animEnsure(animate:FindFirstChild("climb"), "ClimbAnim"), DEFAULT.ClimbAnim)
		_animSetAnim(_animEnsure(animate:FindFirstChild("swim"), "Swim"), DEFAULT.Swim)
		_animSetAnim(_animEnsure(animate:FindFirstChild("swimidle"), "SwimIdle"), DEFAULT.SwimIdle)
		local idleFolder = animate:FindFirstChild("idle")
		if idleFolder then
			_animSetAnim(_animEnsure(idleFolder, "Animation1"), DEFAULT.Animation1)
			_animSetAnim(_animEnsure(idleFolder, "Animation2"), DEFAULT.Animation2)
		end
	end

	animate.Disabled = true
	task.wait(0.08)
	animate.Disabled = false
	if hum then
		pcall(function()
			hum:ChangeState(Enum.HumanoidStateType.Landed)
			task.wait(0.04)
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end)
	end
	return true
end

function applyAnimationPack(packName)
	if _animApplying then return false end
	_animApplying = true

	-- Off / Normal / Default → volver a animaciones normales
	if packName == nil or packName == "" or packName == "Off" or packName == "Normal" or packName == "Default" then
		local ok = pcall(restoreDefaultAnims)
		currentAnimPack = nil
		_animApplying = false
		return ok
	end

	local pack = ANIM_PACKS[packName]
	if not pack then _animApplying = false; return false end

	local okApply = pcall(function()
		local char = LP.Character
		if not char then
			char = LP.CharacterAdded:Wait()
		end
		local animate = _animWaitForAnimate(char)
		if not animate then return end

		-- Guardar originales antes de aplicar el primer pack
		_animSaveOriginals(animate)

		local hum = char:FindFirstChildOfClass("Humanoid")
		_animStopTracks(hum)
		_animSetAnim(_animEnsure(animate:FindFirstChild("run"),"RunAnim"),   _animPick(pack,"RunAnim","Run"))
		_animSetAnim(_animEnsure(animate:FindFirstChild("walk"),"WalkAnim"), _animPick(pack,"WalkAnim","Walk"))
		_animSetAnim(_animEnsure(animate:FindFirstChild("jump"),"JumpAnim"), _animPick(pack,"JumpAnim","Jump"))
		_animSetAnim(_animEnsure(animate:FindFirstChild("fall"),"FallAnim"), _animPick(pack,"FallAnim","Fall"))
		_animSetAnim(_animEnsure(animate:FindFirstChild("climb"),"ClimbAnim"),_animPick(pack,"ClimbAnim","Climb"))
		_animSetAnim(_animEnsure(animate:FindFirstChild("swim"),"Swim"),      _animPick(pack,"Swim"))
		_animSetAnim(_animEnsure(animate:FindFirstChild("swimidle"),"SwimIdle"),_animPick(pack,"SwimIdle") or _animPick(pack,"Swim"))
		local idleFolder = animate:FindFirstChild("idle")
		if idleFolder then
			local a1 = _animPick(pack,"Animation1"); local a2 = _animPick(pack,"Animation2")
			if a1 or a2 then
				local id1 = a1 or a2; local id2 = a2 or a1 or id1
				local s1 = idleFolder:FindFirstChild("Animation1"); if not s1 then s1 = Instance.new("Animation"); s1.Name = "Animation1"; s1.Parent = idleFolder end
				local s2 = idleFolder:FindFirstChild("Animation2"); if not s2 then s2 = Instance.new("Animation"); s2.Name = "Animation2"; s2.Parent = idleFolder end
				_animSetAnim(s1, id1); _animSetAnim(s2, id2)
			elseif pack.Idle and #pack.Idle > 0 then
				for i = 1, math.max(2, #pack.Idle) do
					local s = idleFolder:FindFirstChild("Animation"..i); if not s then s = Instance.new("Animation"); s.Name = "Animation"..i; s.Parent = idleFolder end
					if pack.Idle[i] then _animSetAnim(s, pack.Idle[i]) end
				end
			end
		end
		animate.Disabled = true
		task.wait(0.08)
		animate.Disabled = false
		if hum then
			pcall(function()
				hum:ChangeState(Enum.HumanoidStateType.Landed)
				task.wait(0.04)
				hum:ChangeState(Enum.HumanoidStateType.Running)
			end)
		end
	end)
	currentAnimPack = packName
	_animApplying = false
	return okApply and true or false
end

-- re-apply pack after respawn (o restaurar normales si está en Off)
pcall(function()
	LP.CharacterAdded:Connect(function()
		task.delay(0.8, function()
			if currentAnimPack and ANIM_PACKS[currentAnimPack] then
				pcall(applyAnimationPack, currentAnimPack)
			elseif currentAnimPack == nil or currentAnimPack == "Off" then
				-- no forzar pack; dejar animaciones por defecto del juego
			end
		end)
	end)
end)

_G.NIGHT_applyAnimationPack = applyAnimationPack
_G.NIGHT_restoreDefaultAnims = restoreDefaultAnims
_G.NIGHT_getCurrentAnimPack = function() return currentAnimPack end
_G.NIGHT_setCurrentAnimPack = function(n) currentAnimPack = n end
end)()


-- ============================================================
-- Pack Accessory (Bleed 1/2/3) – tomado de VisDuels
-- ============================================================
;(function()
	_G.NIGHT_OriginalOutfit = _G.NIGHT_OriginalOutfit or {shirt = nil, pants = nil}
	_G.NIGHT_OriginalAccessories = _G.NIGHT_OriginalAccessories or {}

	local ACCESSORY_PACK_ORDER = {"Off", "Bleed 1", "Bleed 2", "Bleed 3", "Homero", "Tryhard", "Venom"}
	local currentAccessoryPack = "Off"

	local BLEED_PACKS = {
		["Bleed 1"] = {
			accessory   = 306969564,
			offset      = Vector3.new(0, 0.3, 0),
			headMesh    = "http://www.roblox.com/asset/?id=134079402",
			headTexture = "http://www.roblox.com/asset/?id=133940918",
			shirt       = "http://www.roblox.com/asset/?id=10632503795",
			pants       = "http://www.roblox.com/asset/?id=123161592384863",
			korblox     = "right",
		},
		["Bleed 2"] = {
			accessory   = 1744060292,
			offset      = Vector3.new(0, 1.4, -0.2),
			headMesh    = "http://www.roblox.com/asset/?id=134079402",
			headTexture = "http://www.roblox.com/asset/?id=133940918",
			shirt       = "http://www.roblox.com/asset/?id=11526718530",
			pants       = "http://www.roblox.com/asset/?id=93710523210027",
			korblox     = "right",
		},
		["Bleed 3"] = {
			accessory   = 112564966849233,
			offset      = Vector3.new(0, 0.6, 0),
			headMesh    = "http://www.roblox.com/asset/?id=134079402",
			headTexture = "http://www.roblox.com/asset/?id=133940918",
			shirt       = "http://www.roblox.com/asset/?id=11849088376",
			pants       = "http://www.roblox.com/asset/?id=16534673928",
			korblox     = "right",
		},
		-- Skins from NEYMAR.VS (Homero / Tryhard / Venom)
		["Homero"] = {
			headMesh    = "rbxassetid://137685008029440",
			shirt       = "rbxassetid://6281968058",
			pants       = "rbxassetid://1073888653",
			bodyColors  = "homero",
		},
		["Tryhard"] = {
			headMesh    = "rbxassetid://11711107876",
			shirt       = "rbxassetid://14101026303",
			pants       = "rbxassetid://4620736485",
		},
		["Venom"] = {
			shirt       = "rbxassetid://13950309240",
			pants       = "rbxassetid://12421776639",
			bodyColors  = "allBlack",
		},
	}

	local function saveOriginalOutfit(char)
		if not char then return end
		local shirt = char:FindFirstChildWhichIsA("Shirt")
		local pants = char:FindFirstChildWhichIsA("Pants")
		_G.NIGHT_OriginalOutfit.shirt = shirt and shirt.ShirtTemplate or nil
		_G.NIGHT_OriginalOutfit.pants = pants and pants.PantsTemplate or nil
	end

	local function restoreOriginalOutfit(char)
		if not char then return end
		for _, obj in ipairs(char:GetChildren()) do
			if obj:IsA("Shirt") or obj:IsA("Pants") then obj:Destroy() end
		end
		if _G.NIGHT_OriginalOutfit.shirt then
			local s = Instance.new("Shirt"); s.ShirtTemplate = _G.NIGHT_OriginalOutfit.shirt; s.Parent = char
		end
		if _G.NIGHT_OriginalOutfit.pants then
			local p = Instance.new("Pants"); p.PantsTemplate = _G.NIGHT_OriginalOutfit.pants; p.Parent = char
		end
	end

	local function clearAllOutfit(char)
		if not char then return end
		for _, obj in ipairs(char:GetChildren()) do
			if obj:IsA("Shirt") or obj:IsA("Pants") then obj:Destroy() end
		end
	end

	local function saveOriginalAccessories(char)
		_G.NIGHT_OriginalAccessories = {}
		if not char then return end
		for _, child in ipairs(char:GetChildren()) do
			if child:IsA("Accessory") or child:IsA("Hat") then
				table.insert(_G.NIGHT_OriginalAccessories, child:Clone())
			end
		end
	end

	local function restoreOriginalAccessories(char)
		if not char then return end
		for _, child in ipairs(char:GetChildren()) do
			if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then
				child:Destroy()
			end
		end
		for _, clone in ipairs(_G.NIGHT_OriginalAccessories) do
			if clone and clone.Parent == nil then
				clone:Clone().Parent = char
			end
		end
		_G.NIGHT_OriginalAccessories = {}
	end

	local function clearAllAccessories(char)
		if not char then return end
		for _, child in ipairs(char:GetChildren()) do
			if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then
				child:Destroy()
			end
			if child.Name:find("Korblox_") or child.Name:find("Headless_") then
				child:Destroy()
			end
		end
		for _, partName in ipairs({"Head","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}) do
			local part = char:FindFirstChild(partName)
			if part and part:IsA("BasePart") then part.Transparency = 0 end
		end
	end

	local function applyBleedOutfit(packName)
		local config = BLEED_PACKS[packName]
		if not config then return false end
		local char = LP.Character
		if not char then return false end
		char:WaitForChild("Head", 10)
		local head = char:FindFirstChild("Head")
		if not head then return false end

		if config.headMesh then
			for _, d in ipairs(char:GetChildren()) do
				if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
					pcall(function() d:Destroy() end)
				end
			end
			local done = false
			if head:IsA("MeshPart") then
				done = pcall(function()
					head.MeshId = config.headMesh
					if config.headTexture then head.TextureID = config.headTexture end
				end)
			end
			if not done then
				local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
				sm.Parent = head
				sm.MeshType = Enum.MeshType.FileMesh
				sm.MeshId = config.headMesh
				sm.TextureId = config.headTexture or ""
			end
		end

		if config.shirt then
			local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
			s.Name = "Shirt"; s.ShirtTemplate = config.shirt; s.Parent = char
		end
		if config.pants then
			local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
			p.Name = "Pants"; p.PantsTemplate = config.pants; p.Parent = char
		end

		-- Body colors (NEYMAR.VS Homero / Venom)
		if config.bodyColors == "homero" then
			local redColor = Color3.fromRGB(255, 0, 0)
			local blackColor = Color3.fromRGB(0, 0, 0)
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					if part.Name == "Head" or part.Name:find("Torso") or part.Name:find("Arm") then
						part.Color = redColor
					elseif part.Name:find("Leg") then
						part.Color = blackColor
					end
				end
			end
		elseif config.bodyColors == "allBlack" then
			local blackColor = Color3.fromRGB(8, 14, 28)
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Color = blackColor
				end
			end
		end

		if config.accessory and head then
			local old = char:FindFirstChild("AuFfitAccessory")
			if old then old:Destroy() end
			local objs
			local ok, res = pcall(function()
				return game:GetObjects("rbxassetid://" .. tostring(config.accessory))
			end)
			if ok and type(res) == "table" and #res > 0 then
				objs = res
			else
				ok, res = pcall(function()
					return game:GetService("InsertService"):LoadAsset(config.accessory)
				end)
				if ok and res then objs = {res} end
			end
			if objs then
				local handle
				for _, o in ipairs(objs) do
					if o:IsA("BasePart") then handle = o; break end
					local f = o:FindFirstChildWhichIsA("BasePart", true)
					if f then handle = f; break end
				end
				if handle then
					local h = handle:Clone()
					h.Name = "AuFfitAccessory"
					h.CanCollide = false
					h.Anchored = false
					h.Massless = true
					h.Parent = char
					local weld = Instance.new("Weld")
					weld.Part0 = head
					weld.Part1 = h
					weld.C0 = CFrame.new(config.offset or Vector3.zero)
					weld.Parent = h
				end
				for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
			end
		end

		if config.korblox and config.korblox ~= "none" then
			local function attachKorblox(side)
				local ids = { left = 139607673, right = 139607718 }
				local targets = { left = "LeftUpperLeg", right = "RightUpperLeg" }
				local hides = {
					left  = {"LeftUpperLeg","LeftLowerLeg","LeftFoot"},
					right = {"RightUpperLeg","RightLowerLeg","RightFoot"}
				}
				local targetPart = char:FindFirstChild(targets[side])
				if not targetPart then return false end
				for _, partName in ipairs(hides[side]) do
					local limb = char:FindFirstChild(partName)
					if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
				end
				local success, objects = pcall(function()
					return game:GetObjects("rbxassetid://" .. ids[side])
				end)
				if not success or not objects or #objects == 0 then return false end
				local assetModel = objects[1]
				local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
				if not mainMesh then assetModel:Destroy(); return false end
				mainMesh.CanCollide = false
				mainMesh.Massless = true
				mainMesh.CFrame = targetPart.CFrame
				local weld = Instance.new("WeldConstraint")
				weld.Part0 = targetPart
				weld.Part1 = mainMesh
				weld.Parent = mainMesh
				assetModel.Parent = char
				return true
			end
			if config.korblox == "left" then attachKorblox("left")
			elseif config.korblox == "right" then attachKorblox("right") end
		end
		return true
	end

	local function applyAccessoryPack(packName)
		local char = LP.Character
		if not char then return end
		currentAccessoryPack = packName or "Off"
		if packName == "Off" then
			clearAllAccessories(char)
			restoreOriginalOutfit(char)
			restoreOriginalAccessories(char)
			return
		end
		if not _G.NIGHT_OriginalOutfit.shirt and not _G.NIGHT_OriginalOutfit.pants then
			saveOriginalOutfit(char)
		end
		if #_G.NIGHT_OriginalAccessories == 0 then
			saveOriginalAccessories(char)
		end
		clearAllOutfit(char)
		clearAllAccessories(char)
		applyBleedOutfit(packName)
	end

	_G.NIGHT_applyAccessoryPack = applyAccessoryPack
	_G.NIGHT_getCurrentAccessoryPack = function() return currentAccessoryPack end
	_G.NIGHT_setCurrentAccessoryPack = function(n) currentAccessoryPack = n end
	_G.NIGHT_ACCESSORY_PACK_ORDER = ACCESSORY_PACK_ORDER

	pcall(function()
		LP.CharacterAdded:Connect(function()
			task.delay(1.0, function()
				if currentAccessoryPack and currentAccessoryPack ~= "Off" then
					pcall(applyAccessoryPack, currentAccessoryPack)
				end
			end)
		end)
	end)
end)()


-- Anti Die system (isolated, no discord on billboard)
;(function()
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	local LP = Players.LocalPlayer
	local enabled = false
	local heartConn, charAddedConn = nil, nil
	local deathConns = {}
	local billboardGui, billboardFrame, billboardUpdater = nil, nil, nil

	local function destroyBillboard()
		if billboardUpdater then pcall(function() billboardUpdater:Disconnect() end); billboardUpdater = nil end
		if billboardGui then pcall(function() billboardGui:Destroy() end); billboardGui = nil end
		billboardFrame = nil
	end

	local function createBillboard(char)
		if not char then return end
		local head = char:FindFirstChild("Head")
		if not head then return end
		destroyBillboard()
		billboardGui = Instance.new("ScreenGui")
		billboardGui.Name = "NightAntiDieBillboard"
		billboardGui.ResetOnSpawn = false
		billboardGui.IgnoreGuiInset = true
		pcall(function() billboardGui.Parent = game:GetService("CoreGui") end)
		if not billboardGui.Parent then
			billboardGui.Parent = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
		end
		billboardFrame = Instance.new("Frame", billboardGui)
		billboardFrame.Size = UDim2.new(0, 160, 0, 36)
		billboardFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		billboardFrame.BackgroundTransparency = 0.3
		billboardFrame.BorderSizePixel = 0
		Instance.new("UICorner", billboardFrame).CornerRadius = UDim.new(0, 8)
		local txt1 = Instance.new("TextLabel", billboardFrame)
		txt1.Size = UDim2.new(1, 0, 1, 0)
		txt1.BackgroundTransparency = 1
		txt1.Text = "ANTI DIE"
		txt1.TextColor3 = Color3.fromRGB(255, 255, 255)
		txt1.Font = Enum.Font.GothamBlack
		txt1.TextSize = 18
		txt1.TextXAlignment = Enum.TextXAlignment.Center
		txt1.TextYAlignment = Enum.TextYAlignment.Center
		local camera = Workspace.CurrentCamera
		billboardUpdater = RunService.Heartbeat:Connect(function()
			if not billboardGui or not billboardGui.Parent then return end
			if not head or not head.Parent then billboardFrame.Visible = false; return end
			local pos, onScreen = camera:WorldToScreenPoint(head.Position)
			if onScreen then
				billboardFrame.Position = UDim2.new(0, pos.X - 80, 0, pos.Y - 40)
				billboardFrame.Visible = true
			else
				billboardFrame.Visible = false
			end
		end)
	end

	local function protectChar(char)
		if not char then return end
		local hum = char:WaitForChild("Humanoid", 5)
		if not hum then return end
		hum.MaxHealth = math.huge
		hum.Health = math.huge
		table.insert(deathConns, hum.StateChanged:Connect(function(_, new)
			if not enabled then return end
			if new == Enum.HumanoidStateType.Dead then
				hum.Health = math.huge
				hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			end
		end))
		hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		table.insert(deathConns, hum:GetPropertyChangedSignal("Health"):Connect(function()
			if not enabled then return end
			if hum.Health < hum.MaxHealth then hum.Health = math.huge end
		end))
		if heartConn then heartConn:Disconnect() end
		heartConn = RunService.Heartbeat:Connect(function()
			if not enabled then return end
			if hum and hum.Parent and hum.Health < hum.MaxHealth then hum.Health = math.huge end
		end)
		createBillboard(char)
	end

	local function startProtect()
		for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
		deathConns = {}
		if heartConn then heartConn:Disconnect(); heartConn = nil end
		if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end
		protectChar(LP.Character)
		charAddedConn = LP.CharacterAdded:Connect(function(c)
			if not enabled then return end
			task.wait(0.1)
			for _, c2 in ipairs(deathConns) do pcall(function() c2:Disconnect() end) end
			deathConns = {}
			protectChar(c)
		end)
	end

	local function stopProtect()
		for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
		deathConns = {}
		if heartConn then heartConn:Disconnect(); heartConn = nil end
		if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end
		destroyBillboard()
		local char = LP.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
				hum.MaxHealth = 100
				hum.Health = math.min(hum.Health, 100)
			end
		end
	end

	_G.NIGHT_setAntiDie = function(on)
		enabled = on and true or false
		if enabled then startProtect() else stopProtect() end
	end
	_G.NIGHT_getAntiDie = function() return enabled end
end)()


-- Music packs (Chocolate + hub songs)
;(function()
	local SoundService = game:GetService("SoundService")
	local current = nil
	local sound = nil
	local PACKS = {
		["Tryhard"] = {id = "rbxassetid://137188221417776", vol = 0.7},
		["Tryhard 2"] = {id = "rbxassetid://77142753938657", vol = 0.7},
		["Tryhard Def"] = {id = "rbxassetid://75196377290071", vol = 0.7},
		["XD"] = {id = "rbxassetid://90813223538688", vol = 0.7},
		["67"] = {id = "rbxassetid://98859392001383", vol = 0.7},
		["3AM"] = {id = "rbxassetid://73755162651548", vol = 0.7},
		["Beretta"] = {id = "rbxassetid://94281718874647", vol = 0.7},
		["Brasil"] = {id = "rbxassetid://91225667489242", vol = 0.7},
		["Brasil 2"] = {id = "rbxassetid://135750430892149", vol = 0.7},
		["Migizin"] = {id = "rbxassetid://91630262633548", vol = 0.7},
		["Perra"] = {id = "rbxassetid://105750367277221", vol = 0.75},
		["Pa Tripea"] = {id = "rbxassetid://78434183704781", vol = 0.75},
		["Ajjan"] = {id = "rbxassetid://136350225160627", vol = 0.75},
		["Choco Intro"] = {id = "rbxassetid://90089940136467", vol = 0.75},
		["Cursed"] = {id = "rbxassetid://111808555599832", vol = 0.7},
		["Scythe"] = {id = "rbxassetid://9113305311", vol = 0.7},
	}
	local NAMES = {"Off","Tryhard","Tryhard 2","Tryhard Def","XD","67","3AM","Beretta","Brasil","Brasil 2","Migizin","Perra","Pa Tripea","Ajjan","Choco Intro","Cursed","Scythe"}

	local function stop()
		if sound then
			pcall(function() sound:Stop(); sound:Destroy() end)
			sound = nil
		end
	end

	local function play(name)
		stop()
		current = name
		if not name or name == "Off" then return end
		local pack = PACKS[name]
		if not pack then return end
		pcall(function()
			local parent = SoundService
			pcall(function() if gethui then parent = gethui() end end)
			local s = Instance.new("Sound")
			s.Name = "NightMusic_" .. tostring(name):gsub("%s","_")
			s.SoundId = pack.id
			s.Volume = pack.vol or 0.7
			s.Looped = true
			s.Parent = parent
			s:Play()
			sound = s
		end)
	end

	local function cycle()
		local idx = 1
		for i, n in ipairs(NAMES) do
			if n == current then idx = i; break end
		end
		idx = idx % #NAMES + 1
		play(NAMES[idx])
		return NAMES[idx]
	end

	_G.NIGHT_musicPlay = play
	_G.NIGHT_musicStop = stop
	_G.NIGHT_musicCycle = cycle
	_G.NIGHT_musicGet = function() return current or "Off" end
	_G.NIGHT_musicNames = NAMES
end)()


-- Dual keybind helper (outside main IIFE to save locals)
_G.NIGHT_rowDualKB = function(baseCard, cLabel, WHITE, DIM, KB_BG, INPUT_TRANSPARENCY, BORDER, UIS, TweenService, State, tabName, label, kbEntry)
	local c = baseCard(tabName, 48)
	local titleLabel = cLabel(c, label, 10, 120, 11, WHITE, Enum.Font.GothamBold)
	titleLabel.Position = UDim2.new(0, 10, 0.5, -8)
	local function makeHalf(isPad)
		local b = Instance.new("TextButton", c)
		b.Size = UDim2.new(0, 52, 0, 22)
		b.BackgroundColor3 = KB_BG
		b.BackgroundTransparency = INPUT_TRANSPARENCY
		b.BorderSizePixel = 0
		b.TextColor3 = WHITE
		b.Font = Enum.Font.GothamBold
		b.TextSize = 8
		b.ZIndex = 11
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
		local bs = Instance.new("UIStroke", b); bs.Color = BORDER; bs.Thickness = 1
		local function refresh()
			if isPad then
				b.Text = kbEntry.gp and ("GP:" .. kbEntry.gp.Name) or "Pad"
			else
				b.Text = kbEntry.kb and kbEntry.kb.Name or "PC"
			end
		end
		refresh()
		local li, lc = false, nil
		b.MouseButton1Click:Connect(function()
			if li then
				li = false; _anyKeyListening = false
				if lc then lc:Disconnect(); lc = nil end
				refresh(); b.TextColor3 = WHITE
				return
			end
			li = true; _anyKeyListening = true
			b.Text = "···"; b.TextColor3 = DIM
			lc = UIS.InputBegan:Connect(function(inp)
				if not li then return end
				local isKb = inp.UserInputType == Enum.UserInputType.Keyboard
				local isGp = string.sub(inp.UserInputType.Name, 1, 7) == "Gamepad"
				if not isKb and not isGp then return end
				if inp.KeyCode == Enum.KeyCode.Escape then
					li = false; _anyKeyListening = false
					if lc then lc:Disconnect(); lc = nil end
					refresh(); b.TextColor3 = WHITE
					return
				end
				if isPad then kbEntry.gp = inp.KeyCode else kbEntry.kb = inp.KeyCode end
				li = false; _anyKeyListening = false
				if lc then lc:Disconnect(); lc = nil end
				refresh(); b.TextColor3 = WHITE
				if State.requestConfigSave then State.requestConfigSave() end
			end)
		end)
		return b
	end
	local pcBtn = makeHalf(false)
	pcBtn.Position = UDim2.new(1, -114, 0.5, -11)
	local padBtn = makeHalf(true)
	padBtn.Position = UDim2.new(1, -58, 0.5, -11)
end


-- Skins + Medusa Reset (isolated)
;(function()
	local Players = game:GetService("Players")
	local LP = Players.LocalPlayer
	local current = "Off"
	local medusaOn = false
	local medusaBusy = false
	local medusaConns = {}
	local medusaCharConn = nil
	local resetFn = nil

	_G.NIGHT_registerInstaReset = function(fn) resetFn = fn end

	local function clearAccessories()
		local char = LP.Character
		if not char then return end
		for _, child in ipairs(char:GetChildren()) do
			if child.Name:find("Korblox_") or child.Name:find("Headless_") then
				pcall(function() child:Destroy() end)
			end
		end
		for _, partName in ipairs({"Head", "RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
			local part = char:FindFirstChild(partName)
			if part and part:IsA("BasePart") then part.Transparency = 0 end
		end
	end

	local function attachKorblox()
		local char = LP.Character
		if not char then return end
		local targetPart = char:FindFirstChild("RightUpperLeg")
		if not targetPart then return end
		local old = char:FindFirstChild("Korblox_RightLeg")
		if old then old:Destroy() end
		for _, n in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
			local limb = char:FindFirstChild(n)
			if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
		end
		local ok, objects = pcall(function() return game:GetObjects("rbxassetid://139607718") end)
		if not ok or not objects or #objects == 0 then return end
		local assetModel = objects[1]
		assetModel.Name = "Korblox_RightLeg"
		local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
		if not mainMesh then return end
		mainMesh.CanCollide = false
		mainMesh.CFrame = targetPart.CFrame
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = targetPart
		weld.Part1 = mainMesh
		weld.Parent = mainMesh
		assetModel.Parent = char
	end

	local function attachHeadless()
		local char = LP.Character
		if not char then return end
		local targetPart = char:FindFirstChild("Head")
		if not targetPart then return end
		local old = char:FindFirstChild("Headless_Headless")
		if old then old:Destroy() end
		targetPart.Transparency = 1
		local ok, objects = pcall(function() return game:GetObjects("rbxassetid://134082579") end)
		if not ok or not objects or #objects == 0 then return end
		local assetModel = objects[1]
		assetModel.Name = "Headless_Headless"
		local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
		if not mainMesh then return end
		mainMesh.CanCollide = false
		mainMesh.CFrame = targetPart.CFrame
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = targetPart
		weld.Part1 = mainMesh
		weld.Parent = mainMesh
		assetModel.Parent = char
	end

	local function applySkin(packName)
		current = packName or "Off"
		clearAccessories()
		if current == "Korblox" or current == "Both" then pcall(attachKorblox) end
		if current == "Headless" or current == "Both" then pcall(attachHeadless) end
	end

	_G.NIGHT_applySkin = applySkin
	_G.NIGHT_getSkin = function() return current end

	LP.CharacterAdded:Connect(function()
		task.delay(0.45, function()
			if current and current ~= "Off" then pcall(applySkin, current) end
		end)
	end)

	local function clearMedusa()
		for _, c in ipairs(medusaConns) do pcall(function() c:Disconnect() end) end
		medusaConns = {}
	end

	local function tryReset()
		if not medusaOn or medusaBusy then return end
		medusaBusy = true
		task.spawn(function()
			if resetFn then pcall(resetFn) end
			task.wait(1.1)
			medusaBusy = false
		end)
	end

	local function watchPart(part)
		if not part or not part:IsA("BasePart") then return end
		table.insert(medusaConns, part:GetPropertyChangedSignal("Anchored"):Connect(function()
			if not medusaOn then return end
			if part.Anchored and part.Transparency == 1 then
				tryReset()
			end
		end))
	end

	local function watchChar(char)
		clearMedusa()
		if not char then return end
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then watchPart(part) end
		end
		table.insert(medusaConns, char.DescendantAdded:Connect(function(part)
			if part:IsA("BasePart") then watchPart(part) end
		end))
	end

	_G.NIGHT_setMedusaReset = function(on)
		medusaOn = on and true or false
		if medusaOn then
			if not medusaCharConn then
				medusaCharConn = LP.CharacterAdded:Connect(watchChar)
			end
			if LP.Character then watchChar(LP.Character) end
		else
			clearMedusa()
		end
	end
	_G.NIGHT_getMedusaReset = function() return medusaOn end
end)()

-- SECCIÓN 4: VARIABLES GLOBALES Y STATE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

;(function()
local NS, CS, LS, LS2 = 60, 30, 15, 24.5

local laggerPhase = 0

ninoTimeEnabled = false
ninoTimerGuiBB = nil
ninoTimerText = nil
ninoStunActive = false
ninoStunStartTime = 0
ninoStunDuration = 3.0
ninoStunConnection = nil
ninoStateChangedConnection = nil
ninoLastDisplayedSecond = nil
setNinoTimeVisual = nil

function ninoCreateBillboard()
	if ninoTimerGuiBB then return end
	local char = LP.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end
	ninoTimerGuiBB = Instance.new("BillboardGui")
	ninoTimerGuiBB.Name = "NinoTimeBB"
	ninoTimerGuiBB.Adornee = head
	ninoTimerGuiBB.Size = UDim2.new(0, 120, 0, 36)
	ninoTimerGuiBB.StudsOffset = Vector3.new(0, 3.5, 0)
	ninoTimerGuiBB.AlwaysOnTop = true
	ninoTimerGuiBB.Parent = game:GetService("CoreGui")
	ninoTimerText = Instance.new("TextLabel", ninoTimerGuiBB)
	ninoTimerText.Size = UDim2.new(1, 0, 1, 0)
	ninoTimerText.BackgroundTransparency = 1
	ninoTimerText.Text = "READY!!"
	ninoTimerText.TextColor3 = Color3.fromRGB(45,180,90)
	ninoTimerText.Font = Enum.Font.GothamBlack
	ninoTimerText.TextSize = 20
	ninoTimerText.TextStrokeTransparency = 0.5
	ninoTimerText.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	ninoTimerText.TextXAlignment = Enum.TextXAlignment.Center
	ninoTimerText.TextYAlignment = Enum.TextYAlignment.Center
end

function ninoUpdateDisplay()
	if not ninoTimerText then return end
	if not ninoStunActive then
		ninoTimerText.Text = "READY!!"
		ninoTimerText.TextColor3 = Color3.fromRGB(45,180,90)
		ninoTimerText.TextSize = 20
		if ninoTimerGuiBB then ninoTimerGuiBB.Enabled = ninoTimeEnabled end
		return
	end
	local elapsed = tick() - ninoStunStartTime
	local remaining = math.max(0, ninoStunDuration - elapsed)
	if remaining <= 0 then
		ninoStunActive = false
		if ninoStunConnection then ninoStunConnection:Disconnect(); ninoStunConnection = nil end
		ninoTimerText.Text = "READY!!"
		ninoTimerText.TextColor3 = Color3.fromRGB(45,180,90)
		ninoTimerText.TextSize = 20
		if ninoTimerGuiBB then ninoTimerGuiBB.Enabled = true end
		return
	end
	local second = math.ceil(remaining)
	if second ~= ninoLastDisplayedSecond then
		ninoLastDisplayedSecond = second
		ninoTimerText.Text = tostring(second)
		ninoTimerText.TextSize = 32
		if second == 3 then ninoTimerText.TextColor3 = Color3.fromRGB(72,28,115)
		elseif second == 2 then ninoTimerText.TextColor3 = Color3.fromRGB(45,180,90)
		elseif second == 1 then ninoTimerText.TextColor3 = Color3.fromRGB(170,95,235) end
	end
	if ninoTimerGuiBB then ninoTimerGuiBB.Enabled = true end
end

function ninoOnStunDetected()
	if not ninoTimeEnabled then return end
	if ninoStunActive then return end
	ninoStunActive = true
	ninoStunStartTime = tick()
	ninoLastDisplayedSecond = nil
	ninoCreateBillboard()
	ninoUpdateDisplay()
	if ninoStunConnection then ninoStunConnection:Disconnect() end
	ninoStunConnection = RunService.Heartbeat:Connect(ninoUpdateDisplay)
end

function ninoSetupDetection(char)
	if ninoStateChangedConnection then ninoStateChangedConnection:Disconnect() end
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	ninoStateChangedConnection = hum.StateChanged:Connect(function(_, newState)
		if not ninoTimeEnabled then return end
		local isStunned = (newState == Enum.HumanoidStateType.Physics or
		                   newState == Enum.HumanoidStateType.Ragdoll or
		                   newState == Enum.HumanoidStateType.FallingDown)
		if isStunned then ninoOnStunDetected() end
	end)
end

function setNinoTime(enabled)
	ninoTimeEnabled = enabled
	if setNinoTimeVisual then setNinoTimeVisual(enabled) end
	if not enabled then
		if ninoStunConnection then ninoStunConnection:Disconnect(); ninoStunConnection = nil end
		ninoStunActive = false
		if ninoTimerGuiBB then ninoTimerGuiBB.Enabled = false end
		if ninoStateChangedConnection then ninoStateChangedConnection:Disconnect(); ninoStateChangedConnection = nil end
	else
		ninoCreateBillboard()
		local char = LP.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				local st = hum:GetState()
				if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll then ninoOnStunDetected() end
			end
			ninoSetupDetection(char)
		end
	end
end
local State = {
	speedToggled = false, laggerToggled = false, autoBatToggled = false,
	speedProfile = "Normal",
	profileLaggerNormalSpeed = 40,
	profileLaggerCarrySpeed = 20,
	profileCustomNormalSpeed = 69,
	profileCustomCarrySpeed = 35,
	hittingCooldown = false, infJumpEnabled = false,
	antiRagdollEnabled = false, fpsBoostEnabled = false,
	antiLagEnabled = false,
	guiVisible = true,
	noIntro = (((getgenv and getgenv()) or _G).__SPRITE_NO_INTRO_SAVED == true),
	introEnabled = (((getgenv and getgenv()) or _G).__SPRITE_NO_INTRO_SAVED ~= true), selectedIntroMusic = 1,
	isStealing = false, stealStartTime = nil, lastStealTick = 0,
	lastKnownHealth = 100,
	dropActive = false,
	dropBrainrotActive = false,
	autoLeftEnabled = false, autoRightEnabled = false,
	tpBatEnabled = false,
	unwalkEnabled = false,
	stretchRezEnabled = false, removeAccessoriesEnabled = false,
	darkModeEnabled = false, skyStyle = "Off",
	backgroundAssetId = "92526927384077",
	backgroundAssetIds = {
		"92526927384077",
		"119466264281320",
		"108199149509537",
		"121087678749100",
		"98596557474777",
		"124833425021074",
		"93357962442247",
		"83757812751907",
	},
	imageChoiceVisuals = {},
	buttonImages = {}, -- name -> assetId string ("" = none)
    dropConn = nil,
    dropBrainrotConn = nil,
    autoCarryEnabled = true,
    batV1Speed = 60,
    batV2Speed = 60,
}

local _anyKeyListening, uiLocked = false, false
local setLockUIVisual, MobilePanel, rebuildMobileButtons, resetMobileButtons
local autoSavePositions = function() end
local mobilePanelStyle = "darkhub"
local mobileBtnFrames, mobileBtnActive, allMobileBtns = {}, {}, {}
local mobileButtonsByName = {}
local mobileButtonDefaultPositions = {}
local BTN_POSITIONS_DH = {
	Drop       = UDim2.new(1, -128, 1, -430),
	AutoLeft   = UDim2.new(1, -64, 1, -430),
	AutoBat    = UDim2.new(1, -128, 1, -368),
	AutoRight  = UDim2.new(1, -64, 1, -368),
	TPDown     = UDim2.new(1, -128, 1, -306),
	Speed      = UDim2.new(1, -64, 1, -306),
	Lagger     = UDim2.new(1, -128, 1, -244),
	TPBat      = UDim2.new(1, -64, 1, -244),
	AutoTP     = UDim2.new(1, -128, 1, -182),
	Taunt      = UDim2.new(1, -64, 1, -182),
	MusicPad   = UDim2.new(1, -128, 1, -120),
	InstaReset = UDim2.new(1, -64, 1, -120),
	BatV2      = UDim2.new(1, -128, 1, -58),
}

local KB = {
	AutoLeft  = {kb = Enum.KeyCode.Z,           gp = nil},
	AutoRight = {kb = Enum.KeyCode.C,           gp = nil},
	Drop      = {kb = Enum.KeyCode.X,           gp = nil},
	TPDown    = {kb = Enum.KeyCode.F,           gp = nil},
	AutoBat   = {kb = Enum.KeyCode.E,           gp = nil},
	AutoBatV2 = {kb = nil,                      gp = nil},
	TPBat     = {kb = nil,                      gp = nil},
	Speed     = {kb = Enum.KeyCode.Q,           gp = nil},
	Lagger    = {kb = Enum.KeyCode.R,           gp = nil},
	InstaReset= {kb = nil,                      gp = nil},
	GuiHide   = {kb = Enum.KeyCode.LeftControl, gp = nil},
	MusicPC   = {kb = Enum.KeyCode.M,           gp = nil},
	MusicPad  = {kb = nil,                      gp = Enum.KeyCode.DPadUp},
	Taunt     = {kb = nil,                      gp = nil},
}

local function kbMatch(entry, kc)
	return kc == entry.kb or (entry.gp and kc == entry.gp)
end

local function getProfileNormalSpeed()
	if State.speedProfile == "Lagger" then return State.profileLaggerNormalSpeed end
	if State.speedProfile == "Custom" then return State.profileCustomNormalSpeed or 69 end
	return NS
end

local function getProfileCarrySpeed()
	if State.speedProfile == "Lagger" then return State.profileLaggerCarrySpeed end
	if State.speedProfile == "Custom" then return State.profileCustomCarrySpeed or 35 end
	return CS
end

local AP = {
	L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), L_FACE=Vector3.new(-482.25,-4.96,92.09),
	R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), R_FACE=Vector3.new(-482.06,-6.93,35.47),
}

local Steal = {
	AutoStealEnabled = false, StealRadius = 8, StealDuration = 1.3,
	Data = {}, plotCache = {}, plotCacheTime = {},
	cachedPrompts = {}, promptCacheTime = 0,
}

local Conns = {
	autoSteal = nil, antiRag = nil,
	anchor = {}, progress = nil,
}

local safetyPositionIsValid
local startBatAimbot, stopBatAimbot
local function findAnyToolMob()
	local c=LP.Character
	if c then for _,v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
	local bp=LP:FindFirstChildOfClass("Backpack")
	if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
	return nil
end
local function getClosestPlayerMob2()
	local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil,math.huge end
	local cp,cd=nil,math.huge
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LP and p.Character then
			local tr=p.Character:FindFirstChild("HumanoidRootPart")
			local ph=p.Character:FindFirstChildOfClass("Humanoid")
			if tr and ph and ph.Health>0 then
				local d=(root.Position-tr.Position).Magnitude
				if d<cd then cd=d; cp=p end
			end
		end
	end
	return cp,cd
end
local MOB_SWING_COOLDOWN=0.08

local function tryHitBatMob()
	if State.hittingCooldown then return end; State.hittingCooldown=true
	pcall(function()
		local c=LP.Character; if not c then return end
		local hum2=c:FindFirstChildOfClass("Humanoid"); local tool=findAnyToolMob()
		if tool then
			if tool.Parent~=c and hum2 then pcall(function() hum2:EquipTool(tool) end) end
			local remote=tool:FindFirstChildOfClass("RemoteEvent")
			if remote then pcall(function() remote:FireServer() end)
			else pcall(function() tool:Activate() end) end
		end
	end)
	pcall(function() _G.VoryxPlayBatHitSound() end)
	task.delay(MOB_SWING_COOLDOWN,function() State.hittingCooldown=false end)
end
local _aimbotTarget = nil

local function findBat()
	local char = LP.Character; if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, tool in ipairs(bp:GetChildren()) do
			if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
		end
	end
	return nil
end

local function getClosestTarget()
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local closest, minDist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health > 0 then
				local dist = (tRoot.Position - root.Position).Magnitude
				if dist < minDist then minDist = dist; closest = tRoot end
			end
		end
	end
	return closest
end

-- ============================================================
--  FUNCIONES DE BAT AIMBOT V1 (modificadas para excluir TP Bat)
-- ============================================================
stopBatAimbot = function()
	if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
	_aimbotTarget = nil
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
	local hum2 = c and c:FindFirstChildOfClass("Humanoid")
	if hum2 then hum2.AutoRotate = true end
	State.hittingCooldown = false
	_autoBatTarget = nil
	_autoBatEquippedThisRun = false
end

startBatAimbot = function()
	-- El Aimbot normal usa ahora el comportamiento predictivo de Empire Duels.
	if State.tpBatEnabled then
		State._setTPBatEnabled(false)
	end

	if Conns.aimbot then Conns.aimbot:Disconnect() end
	State._empireAimbotLastScan = 0
	State._empireAimbotTarget = nil

	local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum0 then hum0.AutoRotate = false end

	Conns.aimbot = RunService.Heartbeat:Connect(function()
		if not State.autoBatToggled then return end
		local char = LP.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not root or not hum then return end

		if not char:FindFirstChildOfClass("Tool") then
			local bat = findBat()
			if bat then pcall(function() hum:EquipTool(bat) end) end
		end

		local now = tick()
		local target = State._empireAimbotTarget
		if now - (State._empireAimbotLastScan or 0) > 0.1 or not target or not target.Parent then
			State._empireAimbotLastScan = now
			target = getClosestTarget()
			State._empireAimbotTarget = target
		else
			local targetHum = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
			if not targetHum or targetHum.Health <= 0 then
				target = nil
				State._empireAimbotTarget = nil
			end
		end

		if not target then
			hum.AutoRotate = true
			root.AssemblyAngularVelocity = Vector3.zero
			return
		end

		hum.AutoRotate = false
		_aimbotTarget = target
		local targetVel = target.AssemblyLinearVelocity
		local myPos = root.Position
		local targetPos = target.Position
		local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
		local direction = predictPos - myPos
		local flatDir = Vector3.new(direction.X, 0, direction.Z)
		if flatDir.Magnitude > 0.01 then
			flatDir = flatDir.Unit
		else
			flatDir = Vector3.new(0, 0, 1)
		end

		local chaseSpeed = State.batV1Speed or 58
		local desiredHeight = targetPos.Y + 3.7
		local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
		if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
		yVel = math.clamp(yVel, -70, 110)
		local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
		root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

		local predictTime = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
		local predictedPos = targetPos + targetVel * predictTime
		local toPredict = predictedPos - myPos
		if toPredict.Magnitude > 0.1 then
			local goalCF = CFrame.lookAt(myPos, predictedPos)
			local diffCF = root.CFrame:Inverse() * goalCF
			local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
			rx = math.clamp(rx, -2.5, 2.5)
			ry = math.clamp(ry, -2.5, 2.5)
			rz = math.clamp(rz, -2.5, 2.5)
			root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
		end

		if State.autoSwingEnabled then
			local bat = char:FindFirstChildOfClass("Tool") or findBat()
			if bat and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
		end
	end)
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
end)

local PLOT_CACHE_DURATION, PROMPT_CACHE_REFRESH, STEAL_COOLDOWN = 2, 0.15, 0.1

local h, hrp, speedLbl
local setAutoGrab, setAutoBat, setInfJump, setSuperJump, setAntiRag, setFps, setUnwalkToggle, autoLeftSetVisual, autoRightSetVisual, autoBatSetVisual, setIntroToggle, setNoIntroToggle
local setAntiLag, setStretchRez, setRemoveAccessories, setDarkMode, setSkyStyle, setSkySelectorVisual
local setMedusaCounter, setBatCounter, setInstaGrab, setAutoSwingVisual
local startAntiRagdoll, stopAntiRagdoll, applyFPSBoost, startAutoSteal, stopAutoSteal
local mobileSpeedSetActive, mobileLaggerSetActive, mobileLaggerCarrySetActive, saveConfig, loadConfig = nil, nil, nil, nil, nil

State._configLoading = false
State._configLoaded = false
State._saveAfterLoad = false
State._saveRequestId = 0
State._lastSaveError = nil
State._configDirty = false
State._positionDirty = false

State._resolveFileFunction = function(name)
	local direct = nil
	if name == "writefile" then direct = writefile
	elseif name == "readfile" then direct = readfile
	elseif name == "isfile" then direct = isfile
	elseif name == "delfile" then direct = delfile
	elseif name == "makefolder" then direct = makefolder
	elseif name == "isfolder" then direct = isfolder end
	if type(direct) == "function" then return direct end

	local environments = {}
	pcall(function()
		if getgenv then table.insert(environments, getgenv()) end
	end)
	pcall(function()
		if getrenv then table.insert(environments, getrenv()) end
	end)
	table.insert(environments, _G)

	for _, environment in ipairs(environments) do
		if type(environment) == "table" then
			local candidate = rawget(environment, name)
			if type(candidate) == "function" then return candidate end
			local synEnvironment = rawget(environment, "syn")
			if type(synEnvironment) == "table" then
				local synCandidate = rawget(synEnvironment, name)
				if type(synCandidate) == "function" then return synCandidate end
			end
		end
	end

	if type(syn) == "table" and type(syn[name]) == "function" then
		return syn[name]
	end
	return nil
end

State._safeWriteFile = function(path, data)
	local writer = State._resolveFileFunction("writefile")
	if type(writer) ~= "function" then
		return false, "writefile no disponible en este ejecutor"
	end
	local ok, err = pcall(writer, path, data)
	if not ok then return false, tostring(err) end
	return true
end

State._safeReadFile = function(path)
	local reader = State._resolveFileFunction("readfile")
	if type(reader) ~= "function" then
		return nil, "readfile no disponible en este ejecutor"
	end
	local ok, result = pcall(reader, path)
	if not ok or type(result) ~= "string" or result == "" then
		return nil, ok and "archivo vacío" or tostring(result)
	end
	return result
end

State._safeDeleteFile = function(path)
	local deleter = State._resolveFileFunction("delfile")
	if type(deleter) ~= "function" then return false end
	local ok = pcall(deleter, path)
	return ok
end

State._readValidJsonFile = function(path)
	local raw = State._safeReadFile(path)
	if type(raw) ~= "string" then return nil, nil end
	local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
	if not ok or type(decoded) ~= "table" then return nil, raw end
	return decoded, raw
end

State._writeVerifiedJson = function(path, encoded)
	local writeOk, writeErr = State._safeWriteFile(path, encoded)
	if not writeOk then return false, writeErr end
	local decoded, raw = State._readValidJsonFile(path)
	if type(decoded) ~= "table" or raw ~= encoded then
		return false, "la verificación del archivo falló: " .. tostring(path)
	end
	return true
end

State._atomicJsonSave = function(mainPath, backupPath, tempPath, encoded)
	local jsonOk, decoded = pcall(function() return HttpService:JSONDecode(encoded) end)
	if not jsonOk or type(decoded) ~= "table" then
		return false, "JSON inválido antes de guardar"
	end

	local currentData, currentRaw = State._readValidJsonFile(mainPath)

	if type(currentData) == "table" and currentRaw == encoded then
		return true
	end

	if type(currentData) == "table" and type(currentRaw) == "string" then
		local backupOk, backupErr = State._safeWriteFile(backupPath, currentRaw)
		if not backupOk then return false, backupErr end
	end

	local tempOk, tempErr = State._safeWriteFile(tempPath, encoded)
	if not tempOk then return false, tempErr end

	local mainOk, mainErr = State._safeWriteFile(mainPath, encoded)
	if not mainOk then return false, mainErr end

	if type(currentData) ~= "table" then
		State._safeWriteFile(backupPath, encoded)
	end

	return true
end

State.requestConfigSave = function()
	if State._configLoading or not State._configLoaded then
		State._saveAfterLoad = true
		State._configDirty = true
		return
	end
	if State._configLoadFailed then
		return
	end

	State._configDirty = true
	State._saveRequestId = State._saveRequestId + 1
	local requestId = State._saveRequestId

	task.delay(1.75, function()
		if requestId ~= State._saveRequestId or State._configLoading then return end
		if not State._configDirty then return end
		if saveConfig then
			local ok, result = pcall(saveConfig)
			if not ok then State._lastSaveError = tostring(result) end
		end
	end)
end
local normalBox, carryBox, laggerBox, laggerBox2, durValBtn, uiScaleBox
local modeValLbl, progressFill, progressPct, progressRadLbl
local radValBtn
local alConn, arConn, alPhase, arPhase = nil, nil, 1, 1
local autoTPDownEnabled, autoTPDownConn, autoTPDownHeight = false, nil, 20

local startBatAimbotV2, stopBatAimbotV2
local _autoBatLastScan = 0
local _autoBatTarget = nil
local _autoBatEquippedThisRun = false

local autoBatV2SetVisual, setAutoBatV2, setHideButtonsVisual, setAutoTPDownVisual

local btnInstaReset = nil

State.buttonsSizeValue = State.buttonsSizeValue or 50
State.buttonsShape = State.buttonsShape or "Normal"

function getMobileButtonPixels(value)
	value = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
	return math.floor(36 + (value * 0.48) + 0.5)
end

function normalizeMobileButtonsShape(shape)
	shape = tostring(shape or "Normal")
	if shape == "Circle" or shape == "Normal" or shape == "Square" or shape == "Rectangle" then
		return shape
	end
	return "Normal"
end

function applyShapeToMobileButton(button)
	if not button or not button.Parent then return end

	local pixels = getMobileButtonPixels(State.buttonsSizeValue)
	local textPixels = math.clamp(math.floor(8 + State.buttonsSizeValue * 0.07 + 0.5), 8, 15)
	local shape = normalizeMobileButtonsShape(State.buttonsShape)
	local width, height = pixels, pixels
	local radius = UDim.new(0, math.clamp(math.floor(pixels * 0.30 + 0.5), 8, math.floor(pixels / 2)))

	if shape == "Circle" then
		radius = UDim.new(1, 0)
	elseif shape == "Square" then
		radius = UDim.new(0, 0)
	elseif shape == "Rectangle" then
		width = math.floor(pixels * 1.55 + 0.5)
		height = math.max(28, math.floor(pixels * 0.75 + 0.5))
		radius = UDim.new(0, math.max(5, math.floor(height * 0.18 + 0.5)))
	end

	button.Size = UDim2.new(0, width, 0, height)
	button.TextSize = textPixels

	local corner = button:FindFirstChild("ButtonShapeCorner")
	if not corner or not corner:IsA("UICorner") then
		corner = button:FindFirstChildOfClass("UICorner")
	end
	if not corner then
		corner = Instance.new("UICorner")
		corner.Parent = button
	end
	corner.Name = "ButtonShapeCorner"
	corner.CornerRadius = radius

	-- Sincronizar esquina de la imagen del botón
	local img = button:FindFirstChild("ButtonImage")
	if img and img:IsA("ImageLabel") then
		local imgCorner = img:FindFirstChild("ButtonImageCorner")
		if not imgCorner then
			imgCorner = Instance.new("UICorner")
			imgCorner.Name = "ButtonImageCorner"
			imgCorner.Parent = img
		end
		imgCorner.CornerRadius = radius
	end
end

function applyMobileButtonsShape(shape)
	State.buttonsShape = normalizeMobileButtonsShape(shape)
	for _, mobileBtn in pairs(mobileButtonsByName) do
		applyShapeToMobileButton(mobileBtn)
	end
	for _, specialBtn in ipairs({btnBatV2, btnInstaReset}) do
		applyShapeToMobileButton(specialBtn)
	end
	return State.buttonsShape
end

function applyMobileButtonsSize(value)
	State.buttonsSizeValue = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
	applyMobileButtonsShape(State.buttonsShape)
end

-- ===== IMÁGENES EN BOTONES MÓVILES (usa los mismos assetIds del script) =====
function ensureButtonImageLabel(button)
	if not button or not button.Parent then return nil end
	local img = button:FindFirstChild("ButtonImage")
	if img and img:IsA("ImageLabel") then return img end
	img = Instance.new("ImageLabel")
	img.Name = "ButtonImage"
	img.Size = UDim2.new(1, 0, 1, 0)
	img.Position = UDim2.new(0, 0, 0, 0)
	img.BackgroundTransparency = 1
	img.ImageTransparency = 0.15
	img.ScaleType = Enum.ScaleType.Crop
	img.ZIndex = button.ZIndex
	img.Image = ""
	img.Parent = button
	-- Esquinas iguales al botón
	local corner = button:FindFirstChild("ButtonShapeCorner")
	if corner then
		local imgCorner = Instance.new("UICorner")
		imgCorner.Name = "ButtonImageCorner"
		imgCorner.CornerRadius = corner.CornerRadius
		imgCorner.Parent = img
	end
	return img
end

function applyImageToMobileButton(button, assetId)
	if not button then return end
	local img = ensureButtonImageLabel(button)
	if not img then return end
	assetId = tostring(assetId or "")
	if assetId == "" or assetId == "None" or assetId == "Off" then
		img.Image = ""
		img.Visible = false
		return
	end
	img.Visible = true
	local idStr = assetId:gsub("%D", "")
	img.Image = "rbxthumb://type=Asset&id=" .. idStr .. "&w=420&h=420"
	task.defer(function()
		if img and img.Parent and (img.Image == "" or img.IsLoaded == false) then
			img.Image = "rbxassetid://" .. idStr
		end
	end)
end

function setMobileButtonImage(name, assetId)
	State.buttonImages[name] = (assetId and assetId ~= "" and assetId ~= "None" and assetId ~= "Off") and tostring(assetId) or ""
	local btn = mobileButtonsByName[name]
	if btn then
		applyImageToMobileButton(btn, State.buttonImages[name])
	end
	-- Botones especiales
	if name == "BatV2" and btnBatV2 then
		applyImageToMobileButton(btnBatV2, State.buttonImages[name])
	elseif name == "InstaReset" and btnInstaReset then
		applyImageToMobileButton(btnInstaReset, State.buttonImages[name])
	end
	if State.requestConfigSave then State.requestConfigSave() end
end

function applyAllButtonImages()
	for name, id in pairs(State.buttonImages or {}) do
		local btn = mobileButtonsByName[name]
		if btn then applyImageToMobileButton(btn, id) end
	end
	if btnBatV2 and State.buttonImages["BatV2"] then
		applyImageToMobileButton(btnBatV2, State.buttonImages["BatV2"])
	end
	if btnInstaReset and State.buttonImages["InstaReset"] then
		applyImageToMobileButton(btnInstaReset, State.buttonImages["InstaReset"])
	end
end

local MedusaConfig = {
	Enabled = false,
	Radius = 15,
	Delay = 0.15,
	LastUsed = 0,
	RadiusPart = nil
}

local SAFETY_VOID_MARGIN = 18
local SAFETY_MAX_FLOOR_RAY = 4000
local safetyLastGroundedCFrame = nil
local safetyRestoring = false

local function safetyVoidY()
	local ok, value = pcall(function() return workspace.FallenPartsDestroyHeight end)
	if ok and type(value) == "number" then return value end
	return -500
end

local function safetyFiniteNumber(value)
	return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

safetyPositionIsValid = function(position)
	return typeof(position) == "Vector3"
		and safetyFiniteNumber(position.X)
		and safetyFiniteNumber(position.Y)
		and safetyFiniteNumber(position.Z)
		and position.Y > safetyVoidY() + SAFETY_VOID_MARGIN
end

local function safetyCharacterParts()
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not humanoid or humanoid.Health <= 0 or not root then
		return nil, nil, nil
	end
	return character, humanoid, root
end

local function safetyFloorPosition(root, character)
	if not root or not character or not safetyPositionIsValid(root.Position) then return nil end

	local ignore = {character}
	if MedusaConfig and MedusaConfig.RadiusPart then
		table.insert(ignore, MedusaConfig.RadiusPart)
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local offset = (humanoid and humanoid.HipHeight or 2) + (root.Size.Y / 2) + 0.05
	local origin = root.Position + Vector3.new(0, 5, 0)
	local distanceToVoid = math.max(100, origin.Y - safetyVoidY() + 50)
	local rayDistance = math.min(SAFETY_MAX_FLOOR_RAY, distanceToVoid)
	local hitPosition = nil

	pcall(function()
		local params = RaycastParams.new()
		params.FilterDescendantsInstances = ignore
		params.FilterType = Enum.RaycastFilterType.Exclude
		pcall(function() params.RespectCanCollide = true end)
		local result = workspace:Raycast(origin, Vector3.new(0, -rayDistance, 0), params)
		if result and result.Instance and result.Position then
			hitPosition = result.Position
		end
	end)

	if not hitPosition then
		pcall(function()
			local ray = Ray.new(origin, Vector3.new(0, -rayDistance, 0))
			local part, position = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
			if part and position then hitPosition = position end
		end)
	end

	if not hitPosition then return nil end
	local landing = Vector3.new(root.Position.X, hitPosition.Y + offset, root.Position.Z)
	if not safetyPositionIsValid(landing) then return nil end
	return landing
end

local function safetyTeleport(root, humanoid, destination, preserveYaw)
	if not root or not root.Parent or not humanoid or humanoid.Health <= 0 then return false end
	if not safetyPositionIsValid(destination) then return false end

	local yaw = 0
	if preserveYaw ~= false then
		local _, currentYaw, _ = root.CFrame:ToOrientation()
		yaw = currentYaw
	end

	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	root.CFrame = CFrame.new(destination) * CFrame.Angles(0, yaw, 0)
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	pcall(function() humanoid.PlatformStand = false end)
	return true
end

local function safetyTeleportToFloor(character, humanoid, root)
	local landing = safetyFloorPosition(root, character)
	if not landing then
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		return false
	end
	return safetyTeleport(root, humanoid, landing, true)
end

RunService.Heartbeat:Connect(function()
	local character, humanoid, root = safetyCharacterParts()
	if not character then return end

	if safetyPositionIsValid(root.Position)
		and humanoid.FloorMaterial ~= Enum.Material.Air
		and root.AssemblyLinearVelocity.Magnitude < 180 then
		safetyLastGroundedCFrame = root.CFrame
	end

	local riskyMovement = State.dropActive
		or State.dropBrainrotActive
		or autoTPDownEnabled
		or State.tpBatEnabled
		or State.autoBatToggled
		or State.autoBatV2Enabled

	if riskyMovement and not safetyPositionIsValid(root.Position) and not safetyRestoring then
		safetyRestoring = true
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		if safetyLastGroundedCFrame and safetyPositionIsValid(safetyLastGroundedCFrame.Position) then
			root.CFrame = safetyLastGroundedCFrame + Vector3.new(0, 2, 0)
		end
		task.defer(function() safetyRestoring = false end)
	end
end)

local function showDiscordInProgressBar()
	if not progressPct or not progressFill then return end

	local originalText = progressPct.Text
	local originalColor = progressPct.TextColor3
	local originalSize = progressPct.TextSize
	local originalAlign = progressPct.TextXAlignment

	progressPct.Text = " VORYX.GG ·  Dominando!!!"
	progressPct.TextColor3 = Color3.fromRGB(0, 170, 210)
	progressPct.TextSize = 13
	progressPct.TextXAlignment = Enum.TextXAlignment.Center
	progressPct.ZIndex = 12

	if progressRadLbl then progressRadLbl.Visible = false end

	task.delay(4, function()
		if progressPct then
			progressPct.Text = originalText or "0%"
			progressPct.TextColor3 = originalColor or Color3.fromRGB(200,200,230)
			progressPct.TextSize = originalSize or 11
			progressPct.TextXAlignment = originalAlign or Enum.TextXAlignment.Left
			progressPct.ZIndex = 5
		end
		if progressRadLbl then progressRadLbl.Visible = true end
	end)
end

local function stopAutoLeft()
	if alConn then alConn:Disconnect(); alConn = nil end
	alPhase = 1
	local char = LP.Character
	if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

local function stopAutoRight()
	if arConn then arConn:Disconnect(); arConn = nil end
	arPhase = 1
	local char = LP.Character
	if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

-- ============================================================
--  AUTO LEFT / RIGHT (con exclusión de TP Bat)
-- ============================================================
local function startAutoLeft()
	if State.tpBatEnabled then
		State._setTPBatEnabled(false)
	end

	if alConn then alConn:Disconnect() end
	alPhase = 1
	alConn = RunService.Heartbeat:Connect(function()
		if not State.autoLeftEnabled then return end
		local char = LP.Character; if not char then return end
		local hrp2 = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp2 or not hum then return end
		local spd = getProfileNormalSpeed()
		if alPhase == 1 then
			local tgt = Vector3.new(AP.L1.X, hrp2.Position.Y, AP.L1.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				alPhase = 2
				local d = AP.L2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
			end
			local d = AP.L1 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		elseif alPhase == 2 then
			local tgt = Vector3.new(AP.L2.X, hrp2.Position.Y, AP.L2.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				hum:Move(Vector3.zero,false); hrp2.AssemblyLinearVelocity = Vector3.zero
				State.autoLeftEnabled = false
				if alConn then alConn:Disconnect(); alConn = nil end
				alPhase = 1
				if autoLeftSetVisual then autoLeftSetVisual(false) end
				if (AP.L_FACE - hrp2.Position).Magnitude > 0.01 then
					hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.L_FACE.X, hrp2.Position.Y, AP.L_FACE.Z))
				end
				return
			end
			local d = AP.L2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		end
	end)
end

local function startAutoRight()
	if State.tpBatEnabled then
		State._setTPBatEnabled(false)
	end

	if arConn then arConn:Disconnect() end
	arPhase = 1
	arConn = RunService.Heartbeat:Connect(function()
		if not State.autoRightEnabled then return end
		local char = LP.Character; if not char then return end
		local hrp2 = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp2 or not hum then return end
		local spd = getProfileNormalSpeed()
		if arPhase == 1 then
			local tgt = Vector3.new(AP.R1.X, hrp2.Position.Y, AP.R1.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				arPhase = 2
				local d = AP.R2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
			end
			local d = AP.R1 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		elseif arPhase == 2 then
			local tgt = Vector3.new(AP.R2.X, hrp2.Position.Y, AP.R2.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				hum:Move(Vector3.zero,false); hrp2.AssemblyLinearVelocity = Vector3.zero
				State.autoRightEnabled = false
				if arConn then arConn:Disconnect(); arConn = nil end
				arPhase = 1
				if autoRightSetVisual then autoRightSetVisual(false) end
				if (AP.R_FACE - hrp2.Position).Magnitude > 0.01 then
					hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.R_FACE.X, hrp2.Position.Y, AP.R_FACE.Z))
				end
				return
			end
			local d = AP.R2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		end
	end)
end

-- SECCIÓN 5: FUNCIONES DE DROP Y TP DOWN
local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150
local _tpDownActive = false

local function runDrop()
	if not State._manualDropRequest then return end
	State._manualDropRequest = false
	if State.dropActive then return end
	local char = LP.Character; if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
	State.dropActive = true
	local t0 = tick()
	State.dropConn = RunService.Heartbeat:Connect(function()
		local r = char and char:FindFirstChild("HumanoidRootPart")
		if not r then 
			if State.dropConn then State.dropConn:Disconnect(); State.dropConn = nil end
			State.dropActive = false
			return 
		end
		
		pcall(function()
			if not _tpDownActive then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum and hum.FloorMaterial == Enum.Material.Air and r.Position.Y >= autoTPDownHeight then
					r.CFrame = CFrame.new(Vector3.new(r.Position.X, -6.84, r.Position.Z))
						* CFrame.Angles(0, select(2, r.CFrame:ToEulerAnglesYXZ()), 0)
					r.AssemblyLinearVelocity = Vector3.zero
				end
			end
		end)

		if tick() - t0 >= DROP_ASCEND_DURATION then
			if State.dropConn then State.dropConn:Disconnect(); State.dropConn = nil end
			local rp = RaycastParams.new()
			rp.FilterDescendantsInstances = {char}
			rp.FilterType = Enum.RaycastFilterType.Exclude
			local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)
			if rr then
				local hum2 = char:FindFirstChildOfClass("Humanoid")
				local off = (hum2 and hum2.HipHeight or 2) + (r.Size.Y / 2)
				r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
				r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end
			State.dropActive = false
			return
		end
		r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)
	end)
end

local _tpDownActive = false
local function runTPDown()
	if _tpDownActive then return end
	_tpDownActive = true
	pcall(function()
		local character, humanoid, root = safetyCharacterParts()
		if character then safetyTeleportToFloor(character, humanoid, root) end
	end)
	_tpDownActive = false
end

State._tpBatHittingCooldown = false
State._tpBatHRP = nil
State._tpBatH = nil

State._tpBatGetTool = function()
	local char = LP.Character
	if not char then return nil end

	local bat = char:FindFirstChild("Bat")
	if bat then return bat end

	local backpack = LP:FindFirstChild("Backpack")
	if backpack then
		bat = backpack:FindFirstChild("Bat")
		if bat then
			bat.Parent = char
			return bat
		end
	end

	return nil
end

State._tpBatTryHit = function()
	if State._tpBatHittingCooldown then return end
	State._tpBatHittingCooldown = true

	pcall(function()
		local bat = State._tpBatGetTool()
		if bat then
			bat:Activate()

			local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
			if remoteEvent then
				remoteEvent:FireServer()
			end

			local remoteFunction = bat:FindFirstChildWhichIsA("RemoteFunction")
			if remoteFunction then
				pcall(function()
					remoteFunction:InvokeServer()
				end)
			end
		end
	end)

	pcall(function() _G.VoryxPlayBatHitSound() end)
	task.delay(0.08, function()
		State._tpBatHittingCooldown = false
	end)
end

State._tpBatClosest = function()
	if not State._tpBatHRP then return nil, math.huge end

	local closest, closestDistance = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LP and player.Character then
			local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local distance = (State._tpBatHRP.Position - targetRoot.Position).Magnitude
				if distance < closestDistance then
					closestDistance = distance
					closest = player
				end
			end
		end
	end

	return closest, closestDistance
end

-- ============================================================
--  TP BAT (con desactivación de Auto Left/Right y Bat V1/V2)
-- ============================================================
State._setTPBatEnabled = function(on)
	on = on == true

	if on then
		if State.autoLeftEnabled then
			State.autoLeftEnabled = false
			stopAutoLeft()
			if autoLeftSetVisual then autoLeftSetVisual(false) end
		end
		if State.autoRightEnabled then
			State.autoRightEnabled = false
			stopAutoRight()
			if autoRightSetVisual then autoRightSetVisual(false) end
		end
		if State.autoBatToggled then
			State.autoBatToggled = false
			if autoBatSetVisual then autoBatSetVisual(false) end
			stopBatAimbot()
		end
		if State.autoBatV2Enabled then
			State.autoBatV2Enabled = false
			if autoBatV2SetVisual then autoBatV2SetVisual(false) end
			if mobileBatV2SetActive then mobileBatV2SetActive(false) end
			stopBatAimbotV2()
		end
	else
	end

	State.tpBatEnabled = on
	if State._tpBatSetter then State._tpBatSetter(on) end
	if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
end

RunService.Heartbeat:Connect(function()
	if not State.tpBatEnabled then return end

	if not State._tpBatH or not State._tpBatHRP
		or not State._tpBatH.Parent or not State._tpBatHRP.Parent then
		local char = LP.Character
		if char then
			State._tpBatH = char:FindFirstChildOfClass("Humanoid")
			State._tpBatHRP = char:FindFirstChild("HumanoidRootPart")
		end
		if not State._tpBatH or not State._tpBatHRP then return end
	end

	local target = State._tpBatClosest()
	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			if sethiddenproperty then
				pcall(function()
					sethiddenproperty(State._tpBatHRP, "PhysicsRepRootPart", targetRoot)
				end)
			end

			local targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0)
			if (State._tpBatHRP.Position - targetPosition).Magnitude > 5 then
				State._tpBatHRP.CFrame = CFrame.new(targetPosition)
			end

			local camera = workspace.CurrentCamera
			if camera then
				camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position)
			end

			State._tpBatTryHit()
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if not State.tpBatEnabled then return end
	if not State._tpBatH or not State._tpBatHRP then return end
	if not State._tpBatH.Parent or not State._tpBatHRP.Parent then return end

	local target = State._tpBatClosest()
	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			local camera = workspace.CurrentCamera
			if camera then
				camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position)
			end
			State._tpBatTryHit()
		end
	end
end)

LP.CharacterAdded:Connect(function(character)
	task.wait(0.2)
	State._tpBatH = character:FindFirstChildOfClass("Humanoid")
	State._tpBatHRP = character:FindFirstChild("HumanoidRootPart")
end)

if LP.Character then
	task.spawn(function()
		task.wait(0.2)
		State._tpBatH = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		State._tpBatHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	end)
end

local function startAutoTPDown()
	if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
	autoTPDownConn = task.spawn(function()
		while autoTPDownEnabled do
			task.wait(0.1)
			pcall(function()
				local char = LP.Character; if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
				local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
				if hum.FloorMaterial ~= Enum.Material.Air then return end
				if root.Position.Y < autoTPDownHeight then return end
				safetyTeleportToFloor(char, hum, root)
			end)
		end
	end)
end

local function stopAutoTPDown()
	autoTPDownEnabled = false
	if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
end

local function cursedInstaReset()
	local char = LP.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- RESET de Ice Hub: conserva X/Z y aplica el impulso vertical observado.
	hrp.AssemblyLinearVelocity = Vector3.new(
		hrp.AssemblyLinearVelocity.X,
		10000000,
		hrp.AssemblyLinearVelocity.Z
	)
end
pcall(function() if _G.NIGHT_registerInstaReset then _G.NIGHT_registerInstaReset(cursedInstaReset) end end)

for _, name in pairs({"FEARV2GUI"}) do
	local old = game:GetService("CoreGui"):FindFirstChild(name)
	if old then old:Destroy() end
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end
end

-- SECCIÓN 6: GUI PRINCIPAL
local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
	local moved = false
	frame.Active = true

	local function finishDrag()
		if not dragging then return end
		dragging = false
		dragInput = nil
		if moved then
			moved = false
			if State.requestPositionSave then State.requestPositionSave() end
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end

	frame.InputBegan:Connect(function(inp)
		if uiLocked then return end
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			dragInput = inp.UserInputType == Enum.UserInputType.Touch and inp or nil
			dragStart = inp.Position
			startPos = frame.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then finishDrag() end
			end)
		end
	end)

	frame.InputChanged:Connect(function(inp)
		if uiLocked then finishDrag(); return end
		if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
			dragInput = inp
		end
	end)

	UIS.InputChanged:Connect(function(inp)
		if uiLocked then finishDrag(); return end
		if dragging and (inp == dragInput or inp.UserInputType == Enum.UserInputType.MouseMovement) then
			local d = inp.Position - dragStart
			if math.abs(d.X) > 1 or math.abs(d.Y) > 1 then moved = true end
			do
				local cam = workspace.CurrentCamera
				local vs = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
				local nx = startPos.X.Offset + d.X
				local ny = startPos.Y.Offset + d.Y
				-- rough clamp using scale anchors bottom-right style buttons
				if startPos.X.Scale >= 0.5 then
					nx = math.clamp(nx, -vs.X + 40, -40)
					ny = math.clamp(ny, -vs.Y + 40, -40)
				else
					nx = math.clamp(nx, 0, vs.X - 40)
					ny = math.clamp(ny, 0, vs.Y - 40)
				end
				frame.Position = UDim2.new(startPos.X.Scale, nx, startPos.Y.Scale, ny)
			end
		end
	end)

	UIS.InputEnded:Connect(function(inp)
		if dragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
			finishDrag()
		end
	end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "CTDuelsGUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true

gui.DescendantAdded:Connect(function(child)
    task.defer(function() bindTaupeButton(child) end)
end)
task.defer(function()
    for _, child in ipairs(gui:GetDescendants()) do bindTaupeButton(child) end
end)
if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
	gui.Parent = LP:WaitForChild("PlayerGui")
end

local _C={
	[1]=Color3.fromRGB(0,0,0),
	[2]=Color3.fromRGB(6,6,8),
	[3]=Color3.fromRGB(12,12,14),
	[4]=Color3.fromRGB(235,235,240),
	[5]=Color3.fromRGB(150,150,160),
	[6]=Color3.fromRGB(190,190,200),
	[7]=Color3.fromRGB(250,250,255),
	[8]=Color3.fromRGB(130,130,140),
	[9]=Color3.fromRGB(22,22,26),
	[10]=Color3.fromRGB(18,18,22),
}
local BG=_C[1];local SIDEBAR_BG=_C[2];local CARD_BG=_C[3];local CARD_HOV=_C[4]
local BORDER=_C[5];local BORDER2=_C[6];local WHITE=_C[7];local DIM=_C[8]
local DIM2=_C[9];local KB_BG=_C[10];local INPUT_BG=_C[10]

local function makeDraggableY(guiObject)
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    guiObject.Active = true

    local function finishDrag()
        if not dragging then return end
        dragging = false
        if moved then
            moved = false
            if State.requestPositionSave then State.requestPositionSave() end
            if State.requestConfigSave then State.requestConfigSave() end
        end
    end

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then finishDrag() end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.abs(delta.Y) > 1 then moved = true end
            local newY = startPos.Y.Offset + delta.Y
            local visibleOffset = 375

            local frameHeight = guiObject.AbsoluteSize.Y
            local screenHeight = guiObject.Parent.AbsoluteSize.Y

            local minY = visibleOffset - frameHeight
            local maxY = screenHeight - visibleOffset
            local clampedY = math.clamp(newY, minY, maxY)

            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset, startPos.Y.Scale, clampedY)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            finishDrag()
        end
    end)
end

local W, H, SW =384, 542, 92
local CORNER = 26

local uiScaleValue = 80
local mainUIScale = nil
local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0.5, -math.floor(W/2), 0.5, -math.floor(H/2))
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Visible = false
main.BackgroundTransparency = 0

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, CORNER)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = BORDER
mainStroke.Thickness = 1.25
mainStroke.Transparency = 0.08

local premiumInnerBorder = Instance.new("Frame", main)
premiumInnerBorder.Name = "PremiumInnerBorder"
premiumInnerBorder.Size = UDim2.new(1, -8, 1, -8)
premiumInnerBorder.Position = UDim2.new(0, 4, 0, 4)
premiumInnerBorder.BackgroundTransparency = 1
premiumInnerBorder.BorderSizePixel = 0
premiumInnerBorder.ZIndex = 2
local premiumInnerCorner = Instance.new("UICorner", premiumInnerBorder)
premiumInnerCorner.CornerRadius = UDim.new(0, math.max(CORNER - 4, 0))
local premiumInnerStroke = Instance.new("UIStroke", premiumInnerBorder)
premiumInnerStroke.Color = Color3.fromRGB(150,150,160)
premiumInnerStroke.Thickness = 1
premiumInnerStroke.Transparency = 0.48

mainUIScale = Instance.new("UIScale", main)
mainUIScale.Scale = 0.90

local fullUIBackground = Instance.new("ImageLabel", main)
fullUIBackground.Name = "FullUIBackground"
fullUIBackground.Size = UDim2.new(1, -2, 1, -2)
fullUIBackground.Position = UDim2.new(0, 1, 0, 1)
fullUIBackground.BackgroundColor3 = Color3.fromRGB(6, 16, 10)
fullUIBackground.BackgroundTransparency = 0
fullUIBackground.BorderSizePixel = 0
fullUIBackground.Image = "rbxassetid://" .. tostring(State.backgroundAssetId or "92526927384077")
fullUIBackground.ImageTransparency = 0.05
fullUIBackground.ImageColor3 = Color3.fromRGB(255, 255, 255)
fullUIBackground.ScaleType = Enum.ScaleType.Crop
fullUIBackground.Visible = true
fullUIBackground.ZIndex = 1
local fullUIBackgroundCorner = Instance.new("UICorner", fullUIBackground)
fullUIBackgroundCorner.CornerRadius = UDim.new(0, math.max(CORNER - 1, 0))
task.spawn(function()
	local id = tostring(State.backgroundAssetId or "92526927384077")
	local url = "rbxassetid://" .. id
	pcall(function()
		game:GetService("ContentProvider"):PreloadAsync({url})
	end)
	for attempt = 1, 12 do
		if fullUIBackground and fullUIBackground.Parent then
			fullUIBackground.Image = url
			fullUIBackground.ImageTransparency = 0.08
			fullUIBackground.Visible = true
			fullUIBackground.ScaleType = Enum.ScaleType.Crop
			-- if still empty, try again next loop
			if fullUIBackground.Image == url and fullUIBackground.IsLoaded then
				break
			end
		end
		task.wait(0.2)
	end
	-- final force
	task.wait(0.5)
	if fullUIBackground and fullUIBackground.Parent then
		fullUIBackground.Image = url
		fullUIBackground.ImageTransparency = 0.08
		fullUIBackground.Visible = true
	end
end)

-- ============================================================
--  EFECTOS DE PARTÍCULAS EN LA UI (ambient + sparkles)
-- ============================================================
do
	local PARTICLE_COLORS = {
		Color3.fromRGB(0, 170, 210),
		Color3.fromRGB(235,235,240),
		Color3.fromRGB(200,200,210),
		Color3.fromRGB(190,190,200),
		Color3.fromRGB(220,220,230),
		Color3.fromRGB(200,200,210),
	}

	local particleLayer = Instance.new("Frame", main)
	particleLayer.Name = "UIParticleLayer"
	particleLayer.Size = UDim2.new(1, 0, 1, 0)
	particleLayer.Position = UDim2.new(0, 0, 0, 0)
	particleLayer.BackgroundTransparency = 1
	particleLayer.BorderSizePixel = 0
	particleLayer.ClipsDescendants = true
	particleLayer.ZIndex = 2
	Instance.new("UICorner", particleLayer).CornerRadius = UDim.new(0, CORNER)

	local activeParticles = {}
	local MAX_PARTICLES = 18
	local particleEnabled = true
	local rng = Random.new()

	local function spawnParticle()
		if not particleEnabled or not main.Visible or not particleLayer.Parent then return end
		if #activeParticles >= MAX_PARTICLES then return end

		local size = rng:NextInteger(2, 5)
		local p = Instance.new("Frame")
		p.Name = "UIParticle"
		p.Size = UDim2.fromOffset(size, size)
		p.BackgroundColor3 = PARTICLE_COLORS[rng:NextInteger(1, #PARTICLE_COLORS)]
		p.BackgroundTransparency = rng:NextNumber(0.15, 0.45)
		p.BorderSizePixel = 0
		p.ZIndex = 3
		p.AnchorPoint = Vector2.new(0.5, 0.5)
		Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)

		local glow = Instance.new("UIStroke", p)
		glow.Color = p.BackgroundColor3
		glow.Thickness = 1.2
		glow.Transparency = 0.55

		local startX = rng:NextNumber(0.02, 0.98)
		local startY = rng:NextNumber(0.55, 1.05)
		p.Position = UDim2.new(startX, 0, startY, 0)
		p.Parent = particleLayer

		local lifetime = rng:NextNumber(2.8, 5.5)
		local driftX = rng:NextNumber(-0.12, 0.12)
		local riseY = rng:NextNumber(-0.55, -0.28)
		local endX = math.clamp(startX + driftX, 0.01, 0.99)
		local endY = math.clamp(startY + riseY, -0.08, 0.95)
		local endSize = size * rng:NextNumber(0.3, 0.7)

		table.insert(activeParticles, p)

		local fadeIn = TweenService:Create(p, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = rng:NextNumber(0.05, 0.25)
		})
		local move = TweenService:Create(p, TweenInfo.new(lifetime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Position = UDim2.new(endX, 0, endY, 0),
			Size = UDim2.fromOffset(endSize, endSize),
			BackgroundTransparency = 1
		})
		local glowFade = TweenService:Create(glow, TweenInfo.new(lifetime * 0.9, Enum.EasingStyle.Quad), {
			Transparency = 1
		})

		fadeIn:Play()
		move:Play()
		glowFade:Play()

		task.delay(lifetime + 0.15, function()
			for i = #activeParticles, 1, -1 do
				if activeParticles[i] == p then
					table.remove(activeParticles, i)
					break
				end
			end
			if p and p.Parent then p:Destroy() end
		end)
	end

	task.spawn(function()
		while particleLayer and particleLayer.Parent do
			if main.Visible and particleEnabled then
				spawnParticle()
				if rng:NextNumber() < 0.35 then
					task.wait(0.08)
					spawnParticle()
				end
			end
			task.wait(rng:NextNumber(0.22, 0.55))
		end
	end)

	local function burstParticles(count)
		count = count or 10
		for i = 1, count do
			task.delay(i * 0.04, spawnParticle)
		end
	end

	State._uiParticleBurst = burstParticles
	State._uiParticleEnabled = function(on)
		particleEnabled = on == true
		if not particleEnabled then
			for _, p in ipairs(activeParticles) do
				if p and p.Parent then p:Destroy() end
			end
			activeParticles = {}
		end
	end

	task.defer(function()
		task.wait(0.6)
		if main.Visible then burstParticles(12) end
	end)
end

State._tabBgImages = State._tabBgImages or {}

State.applyBackgroundImage = function(assetId, shouldSave)
	assetId = tostring(assetId or "")
	local valid = false
	for _, id in ipairs(State.backgroundAssetIds) do
		if id == assetId then valid = true; break end
	end
	if not valid then assetId = tostring(State.backgroundAssetIds[1] or "92526927384077") end

	State.backgroundAssetId = assetId
	local url = "rbxassetid://" .. tostring(assetId)
	local function forceBg()
		if not fullUIBackground or not fullUIBackground.Parent then return false end
		fullUIBackground.Visible = true
		fullUIBackground.ImageColor3 = Color3.fromRGB(255, 255, 255)
		fullUIBackground.BackgroundColor3 = Color3.fromRGB(6, 16, 10)
		fullUIBackground.BackgroundTransparency = 0
		fullUIBackground.Image = url
		fullUIBackground.ScaleType = Enum.ScaleType.Crop
		fullUIBackground.ImageTransparency = 0.05
		return true
	end
	forceBg()
	task.spawn(function()
		pcall(function()
			game:GetService("ContentProvider"):PreloadAsync({url})
		end)
		for attempt = 1, 12 do
			forceBg()
			if fullUIBackground and (fullUIBackground.Image == "" or fullUIBackground.ImageTransparency >= 1) then
				fullUIBackground.Image = "rbxthumb://type=Asset&id=" .. tostring(assetId) .. "&w=420&h=420"
				fullUIBackground.ImageTransparency = 0.05
			end
			task.wait(0.2)
		end
	end)

	-- Aplicar la misma foto de fondo a los botones laterales (tabs del sidebar)
	local idStr = tostring(assetId)
	local imgUrl = "rbxthumb://type=Asset&id=" .. idStr .. "&w=420&h=420"
	for _, img in pairs(State._tabBgImages) do
		if img and img.Parent then
			img.Image = imgUrl
			img.ImageTransparency = 0.28
			img.Visible = true
			-- fallback si rbxthumb no carga
			task.defer(function()
				if img and img.Parent and (img.Image == "" or img.IsLoaded == false) then
					img.Image = "rbxassetid://" .. idStr
				end
			end)
		end
	end

	for id, visual in pairs(State.imageChoiceVisuals) do
		local selected = id == assetId
		if visual.stroke then
			visual.stroke.Color = selected and WHITE or BORDER
			visual.stroke.Thickness = selected and 2.2 or 1
		end
		if visual.badge then
			visual.badge.Text = selected and ("✓ " .. tostring(visual.index)) or tostring(visual.index)
			visual.badge.BackgroundColor3 = selected and WHITE or Color3.fromRGB(14,14,16)
			visual.badge.TextColor3 = selected and BG or WHITE
		end
	end

	if shouldSave and State.requestConfigSave then
		State.requestConfigSave()
	end
end

local topbar = Instance.new("Frame", main)
topbar.Size = UDim2.new(1, 0, 0, 48)
topbar.BackgroundColor3 = Color3.fromRGB(10, 22, 14)
topbar.BackgroundTransparency = 0.32
topbar.BorderSizePixel = 0
topbar.ZIndex = 10
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, CORNER)
local topPatch = Instance.new("Frame", topbar)
topPatch.Size = UDim2.new(1, 0, 0, CORNER)
topPatch.Position = UDim2.new(0, 0, 1, -CORNER)
topPatch.BackgroundColor3 = SIDEBAR_BG
topPatch.BackgroundTransparency = 0.32
topPatch.BorderSizePixel = 0
topPatch.ZIndex = 9
local topDiv = Instance.new("Frame", topbar)
topDiv.Size = UDim2.new(1, 0, 0, 1)
topDiv.Position = UDim2.new(0, 0, 1, -1)
topDiv.BackgroundColor3 = BORDER
topDiv.BorderSizePixel = 0
topDiv.ZIndex = 11

local premiumTopLine = Instance.new("Frame", topbar)
premiumTopLine.Name = "PremiumTopLine"
premiumTopLine.Size = UDim2.new(1, -28, 0, 2)
premiumTopLine.Position = UDim2.new(0, 14, 0, 3)
premiumTopLine.BackgroundColor3 = WHITE
premiumTopLine.BorderSizePixel = 0
premiumTopLine.ZIndex = 14
local premiumTopCorner = Instance.new("UICorner", premiumTopLine)
premiumTopCorner.CornerRadius = UDim.new(1, 0)
local premiumTopGradient = Instance.new("UIGradient", premiumTopLine)
premiumTopGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8,8,10)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 170, 210)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,10))
})
premiumTopGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.55),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.55)
})

local titleLbl = Instance.new("TextLabel", topbar)
titleLbl.Size = UDim2.new(0, 190, 1, 0)
titleLbl.Position = UDim2.new(0, 17, 0, -3)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "VORYX.GG"
titleLbl.TextColor3 = WHITE
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 15
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 12

local verLbl = Instance.new("TextLabel", topbar)
verLbl.Size = UDim2.new(0, 240, 0, 14)
verLbl.Position = UDim2.new(0, 18, 0, 28)
verLbl.BackgroundTransparency = 1
verLbl.Text = "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ  VORYX.GG  · Vs Dominando!!!"
verLbl.TextColor3 = DIM
verLbl.Font = Enum.Font.Gotham
verLbl.TextSize = 8
verLbl.TextXAlignment = Enum.TextXAlignment.Left
verLbl.ZIndex = 12

local minBtn = Instance.new("TextButton", topbar)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -36, 0.5, -13)
minBtn.BackgroundColor3 = KB_BG
minBtn.BorderSizePixel = 0
minBtn.Text = "–"
minBtn.TextColor3 = WHITE
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 16
minBtn.ZIndex = 200
minBtn.Active = true
minBtn.AutoButtonColor = true
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", minBtn).Color = BORDER
minBtn.MouseEnter:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV}):Play() end)
minBtn.MouseLeave:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=KB_BG}):Play() end)

do
	local dragging = false
	local dragInput = nil
	local dragStart = nil
	local startPosition = nil
	local moved = false

	local dragZone = Instance.new("TextButton", main)
	dragZone.Name = "TopbarDragZone"
	dragZone.Size = UDim2.new(1, -44, 0, 48)
	dragZone.Position = UDim2.new(0, 0, 0, 0)
	dragZone.BackgroundTransparency = 1
	dragZone.BorderSizePixel = 0
	dragZone.Text = ""
	dragZone.AutoButtonColor = false
	dragZone.Active = true
	dragZone.ZIndex = 12

	local function finishDrag()
		if not dragging then return end
		dragging = false
		dragInput = nil
		if moved then
			moved = false
			pcall(function() if clampMainOnScreen then clampMainOnScreen() end end)
			if State.requestPositionSave then State.requestPositionSave() end
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end

	dragZone.InputBegan:Connect(function(input)
		if uiLocked then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then return end

		dragging = true
		moved = false
		dragInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
		dragStart = input.Position
		startPosition = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				finishDrag()
			end
		end)
	end)

	dragZone.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if uiLocked then finishDrag(); return end
		if not dragging then return end
		if input ~= dragInput and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

		local delta = input.Position - dragStart

		if math.abs(delta.X) > 1 or math.abs(delta.Y) > 1 then moved = true end
		main.Position = UDim2.new(
			startPosition.X.Scale, startPosition.X.Offset + delta.X,
			startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
		)
	end)

	UIS.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch) then
			finishDrag()
		end
	end)
end


-- Keep hub on-screen so topbar drag is always reachable (mobile)
function clampMainOnScreen()
	if not main or not main.Parent then return end
	local cam = workspace.CurrentCamera
	if not cam then return end
	local vp = cam.ViewportSize
	if vp.X < 10 or vp.Y < 10 then return end
	-- force Absolute layout update
	local absPos = main.AbsolutePosition
	local absSize = main.AbsoluteSize
	if absSize.X < 10 or absSize.Y < 10 then
		absSize = Vector2.new(W, H)
	end
	local maxX = math.max(0, vp.X - absSize.X)
	local maxY = math.max(0, vp.Y - absSize.Y)
	local x = math.clamp(absPos.X, 0, maxX)
	local y = math.clamp(absPos.Y, 0, maxY)
	-- keep at least top 40px of hub visible for drag zone
	if y + 40 > vp.Y then
		y = math.max(0, vp.Y - 48)
	end
	if absPos.X ~= x or absPos.Y ~= y then
		main.Position = UDim2.fromOffset(x, y)
	end
end

task.spawn(function()
	for i = 1, 15 do
		task.wait(0.25)
		pcall(clampMainOnScreen)
	end
end)
pcall(function()
	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		task.defer(function() pcall(clampMainOnScreen) end)
	end)
end)
if workspace.CurrentCamera then
	pcall(function()
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			task.defer(function() pcall(clampMainOnScreen) end)
		end)
	end)
end


local TAB_BAR_H = 54
local sidebar = Instance.new("Frame", main)
sidebar.Name = "BottomTabs"
sidebar.Size = UDim2.new(1, 0, 0, TAB_BAR_H)
sidebar.Position = UDim2.new(0, 0, 1, -TAB_BAR_H)
sidebar.BackgroundColor3 = SIDEBAR_BG
sidebar.BackgroundTransparency = 0.12
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 5
sidebar.ClipsDescendants = true
sidebar.Active = true
do local _sc=Instance.new("UICorner",sidebar); _sc.CornerRadius=UDim.new(0,CORNER) end
-- top edge line for bottom bar
do local _sd=Instance.new("Frame",sidebar); _sd.Size=UDim2.new(1,0,0,1); _sd.Position=UDim2.new(0,0,0,0); _sd.BackgroundColor3=BORDER; _sd.BorderSizePixel=0; _sd.ZIndex=6 end

local content = Instance.new("Frame", main)
content.Name = "ContentArea"
content.Size = UDim2.new(1, 0, 1, -(48 + TAB_BAR_H))
content.Position = UDim2.new(0, 0, 0, 48)
content.BackgroundColor3 = BG
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ClipsDescendants = true
content.ZIndex = 100

local mini = Instance.new("TextButton", gui)
mini.Name = "CTDuelsMini"
mini.Size = UDim2.new(0, 90, 0, 32)
mini.Position = UDim2.new(0, 20, 0, 70)
mini.BackgroundColor3 = BG
mini.BorderSizePixel = 0
mini.Text = "MENU"
mini.TextColor3 = WHITE
mini.Font = Enum.Font.GothamBold
mini.TextSize = 11
mini.TextXAlignment = Enum.TextXAlignment.Center
mini.ZIndex = 20
mini.Visible = true
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 16)
local miniStroke = Instance.new("UIStroke", mini)
miniStroke.Color = Color3.fromRGB(0, 170, 210)
miniStroke.Thickness = 1.5

makeDraggable(main)
makeDraggable(topbar)
makeDraggable(sidebar)
makeDraggable(mini)
mini.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)

local function showGui()
    main.Visible = true
    mini.Visible = false
    State.guiVisible = true

    main.BackgroundTransparency = 0
    mainUIScale.Scale = 0.85

    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    TweenService:Create(mainUIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = uiScaleValue / 100}):Play()

    if State._uiParticleBurst then
        task.defer(function() State._uiParticleBurst(10) end)
    end
end

local function hideGui()
    TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(mainUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0.85}):Play()

    task.delay(0.2, function()
        main.Visible = false
        mini.Visible = true
        State.guiVisible = false
    end)
end

minBtn.MouseButton1Click:Connect(hideGui)
minBtn.Activated:Connect(hideGui)
mini.MouseButton1Click:Connect(showGui)
mini.MouseEnter:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=CARD_HOV}):Play() end)
mini.MouseLeave:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=BG}):Play() end)

local tabs = {}
local tabPages = {}
local activeTabName = nil
local tabDefs = {
	{name="Speed"},
	{name="Bat Aimbot"},
	{name="Mechanics"},
	{name="Movement"},
	{name="Performance"},
	{name="Settings"},
	{name="Background"},
	{name="Songs"},
	{name="Animations"},
	{name="Keybins"},
}
local switchTab
local pageLOs = {}

local tabListFrame = Instance.new("ScrollingFrame", sidebar)
tabListFrame.Size = UDim2.new(1, -8, 1, -8)
tabListFrame.Position = UDim2.new(0, 4, 0, 4)
tabListFrame.BackgroundTransparency = 1
tabListFrame.BorderSizePixel = 0
tabListFrame.ZIndex = 6
tabListFrame.ScrollBarThickness = 3
tabListFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 230)
tabListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
tabListFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
tabListFrame.ScrollingDirection = Enum.ScrollingDirection.X
tabListFrame.ElasticBehavior = Enum.ElasticBehavior.Never

local tabLL = Instance.new("UIListLayout", tabListFrame)
tabLL.FillDirection = Enum.FillDirection.Horizontal
tabLL.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLL.VerticalAlignment = Enum.VerticalAlignment.Center
tabLL.SortOrder = Enum.SortOrder.LayoutOrder
tabLL.Padding = UDim.new(0, 6)
local tabPad = Instance.new("UIPadding", tabListFrame)
tabPad.PaddingTop = UDim.new(0, 2)
tabPad.PaddingBottom = UDim.new(0, 2)
tabPad.PaddingLeft = UDim.new(0, 6)
tabPad.PaddingRight = UDim.new(0, 6)

local ACTIVE_TAB_BG  = CARD_HOV
local ACTIVE_TAB_TXT = WHITE
local IDLE_TAB_BG    = CARD_BG
local IDLE_TAB_TXT   = WHITE

switchTab = function(name)
	activeTabName = name
	for _, td in ipairs(tabDefs) do
		local t = tabs[td.name]
		local isA = td.name == name
		TweenService:Create(t.frame, TweenInfo.new(0.14), {
			BackgroundColor3 = isA and ACTIVE_TAB_BG or IDLE_TAB_BG,
			BackgroundTransparency = isA and 0.35 or 0.55
		}):Play()
		TweenService:Create(t.lbl, TweenInfo.new(0.14), {
			TextColor3 = isA and ACTIVE_TAB_TXT or IDLE_TAB_TXT
		}):Play()
		if t.mark then
			TweenService:Create(t.mark, TweenInfo.new(0.14), {
				BackgroundTransparency = isA and 0.02 or 1
			}):Play()
		end
		if t.overlay then
			TweenService:Create(t.overlay, TweenInfo.new(0.14), {
				BackgroundTransparency = isA and 0.78 or 0.62
			}):Play()
		end
		if t.bgImg then
			TweenService:Create(t.bgImg, TweenInfo.new(0.14), {
				ImageTransparency = isA and 0.18 or 0.28
			}):Play()
		end
		tabPages[td.name].Visible = isA
	end
end

for i, td in ipairs(tabDefs) do
	local btn = Instance.new("TextButton", tabListFrame)
	btn.Size = UDim2.new(0, 88, 1, 0)
	btn.BackgroundColor3 = IDLE_TAB_BG
	btn.BackgroundTransparency = 0.55
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.LayoutOrder = i
	btn.ZIndex = 7
	btn.ClipsDescendants = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)
	local bSt = Instance.new("UIStroke", btn)
	bSt.Color = BORDER
	bSt.Thickness = 1

	-- Foto de fondo del background seleccionado en cada botón lateral (más visible)
	local idStr0 = tostring(State.backgroundAssetId or "92526927384077")
	local tabBgImg = Instance.new("ImageLabel", btn)
	tabBgImg.Name = "TabBackgroundImage"
	tabBgImg.Size = UDim2.new(1, 0, 1, 0)
	tabBgImg.Position = UDim2.new(0, 0, 0, 0)
	tabBgImg.BackgroundTransparency = 1
	tabBgImg.BorderSizePixel = 0
	tabBgImg.Image = "rbxthumb://type=Asset&id=" .. idStr0 .. "&w=420&h=420"
	tabBgImg.ImageTransparency = 0.28
	tabBgImg.ScaleType = Enum.ScaleType.Crop
	tabBgImg.ZIndex = 8
	Instance.new("UICorner", tabBgImg).CornerRadius = UDim.new(0, 11)
	task.defer(function()
		if tabBgImg and tabBgImg.Parent and (tabBgImg.Image == "" or tabBgImg.IsLoaded == false) then
			tabBgImg.Image = "rbxassetid://" .. idStr0
		end
	end)
	State._tabBgImages = State._tabBgImages or {}
	table.insert(State._tabBgImages, tabBgImg)

	-- Overlay oscuro para legibilidad del texto
	local tabOverlay = Instance.new("Frame", btn)
	tabOverlay.Name = "TabDarkOverlay"
	tabOverlay.Size = UDim2.new(1, 0, 1, 0)
	tabOverlay.BackgroundColor3 = Color3.fromRGB(8, 14, 28)
	tabOverlay.BackgroundTransparency = 0.62
	tabOverlay.BorderSizePixel = 0
	tabOverlay.ZIndex = 8
	Instance.new("UICorner", tabOverlay).CornerRadius = UDim.new(0, 11)

	local lbl = Instance.new("TextLabel", btn)
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.Position = UDim2.new(0, 0, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = td.name
	lbl.TextColor3 = IDLE_TAB_TXT
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = (td.name == "Performance" or td.name == "Background") and 8 or 9
	lbl.TextXAlignment = Enum.TextXAlignment.Center
	lbl.TextWrapped = false
	lbl.TextTruncate = Enum.TextTruncate.AtEnd
	lbl.ZIndex = 11
	local activeMark = Instance.new("Frame", btn)
	activeMark.Name = "ActiveMark"
	activeMark.Size = UDim2.new(0, 3, 0, 14)
	activeMark.Position = UDim2.new(0, 3, 0.5, -7)
	activeMark.BackgroundColor3 = WHITE
	activeMark.BackgroundTransparency = 1
	activeMark.BorderSizePixel = 0
	activeMark.ZIndex = 12
	Instance.new("UICorner", activeMark).CornerRadius = UDim.new(1, 0)

	tabs[td.name] = {frame=btn, lbl=lbl, mark=activeMark, bgImg=tabBgImg, overlay=tabOverlay}

	local page = Instance.new("ScrollingFrame", content)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundColor3 = BG
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = BORDER
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Visible = false
	page.ZIndex = 3
	local pll = Instance.new("UIListLayout", page)
	pll.SortOrder = Enum.SortOrder.LayoutOrder
	pll.Padding = UDim.new(0, 7)
	local pp = Instance.new("UIPadding", page)
	pp.PaddingLeft = UDim.new(0, 13)
	pp.PaddingRight = UDim.new(0, 13)
	pp.PaddingTop = UDim.new(0, 12)
	pp.PaddingBottom = UDim.new(0, 12)
	tabPages[td.name] = page
	pageLOs[td.name] = 0
	btn.Activated:Connect(function()
		switchTab(td.name)
		if State._uiParticleBurst then State._uiParticleBurst(4) end
	end)
	btn.MouseEnter:Connect(function()
		if activeTabName ~= td.name then
			TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3=ACTIVE_TAB_BG, BackgroundTransparency=0.4}):Play()
			if tabOverlay then TweenService:Create(tabOverlay, TweenInfo.new(0.1), {BackgroundTransparency=0.72}):Play() end
			if tabBgImg then TweenService:Create(tabBgImg, TweenInfo.new(0.1), {ImageTransparency=0.2}):Play() end
		end
	end)
	btn.MouseLeave:Connect(function()
		if activeTabName ~= td.name then
			TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3=IDLE_TAB_BG, BackgroundTransparency=0.55}):Play()
			if tabOverlay then TweenService:Create(tabOverlay, TweenInfo.new(0.1), {BackgroundTransparency=0.62}):Play() end
			if tabBgImg then TweenService:Create(tabBgImg, TweenInfo.new(0.1), {ImageTransparency=0.28}):Play() end
		end
	end)
end

local function lo(tabName) pageLOs[tabName] = pageLOs[tabName] + 1; return pageLOs[tabName] end
local function pg(tabName) return tabPages[tabName] end

local function makeSecHeader(tabName, text)
	local f = Instance.new("Frame", pg(tabName))
	f.Size = UDim2.new(1, 0, 0, 24)
	f.BackgroundTransparency = 1
	f.BorderSizePixel = 0
	f.LayoutOrder = lo(tabName)
	f.ZIndex = 4

	local accent = Instance.new("Frame", f)
	accent.Size = UDim2.new(0, 3, 0, 12)
	accent.Position = UDim2.new(0, 0, 0.5, -6)
	accent.BackgroundColor3 = WHITE
	accent.BorderSizePixel = 0
	accent.ZIndex = 5
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

	local t = Instance.new("TextLabel", f)
	t.Size = UDim2.new(1, -12, 0, 16)
	t.Position = UDim2.new(0, 9, 0, 1)
	t.BackgroundTransparency = 1
	t.Text = text:upper()
	t.TextColor3 = WHITE
	t.Font = Enum.Font.GothamBold
	t.TextSize = 8
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.TextWrapped = false
	t.TextTruncate = Enum.TextTruncate.AtEnd
	t.ZIndex = 5

	local line = Instance.new("Frame", f)
	line.Size = UDim2.new(1, -9, 0, 1)
	line.Position = UDim2.new(0, 9, 1, -2)
	line.BackgroundColor3 = BORDER
	line.BackgroundTransparency = 0.25
	line.BorderSizePixel = 0
	line.ZIndex = 4
end

local _unwalkSavedAnimate = nil
local function startUnwalk()
    local c = LP.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end end
    local anim = c:FindFirstChild("Animate")
    if anim then _unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end
local function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then starterAnim:Clone().Parent = c
            elseif _unwalkSavedAnimate then _unwalkSavedAnimate:Clone().Parent = c end
        end
    end
    _unwalkSavedAnimate = nil
end

local function baseCard(tabName, h2)
	local c = Instance.new("Frame", pg(tabName))
	c.Size = UDim2.new(1, 0, 0, h2 or 38)
	c.BackgroundColor3 = CARD_BG
	c.BackgroundTransparency = OPTION_TRANSPARENCY
	c.BorderSizePixel = 0
	c.LayoutOrder = lo(tabName)
	c.ZIndex = 4
	Instance.new("UICorner", c).CornerRadius = UDim.new(0, 12)
	local cSt = Instance.new("UIStroke", c)
	cSt.Color = Color3.fromRGB(70, 190, 120)
	cSt.Thickness = 1
	cSt.Transparency = 0.35

	local sideAccent = Instance.new("Frame", c)
	sideAccent.Name = "VisualAccent"
	sideAccent.Size = UDim2.new(0, 2, 0.54, 0)
	sideAccent.Position = UDim2.new(0, 1, 0.23, 0)
	sideAccent.BackgroundColor3 = BORDER
	sideAccent.BackgroundTransparency = 0.2
	sideAccent.BorderSizePixel = 0
	sideAccent.ZIndex = 5
	Instance.new("UICorner", sideAccent).CornerRadius = UDim.new(1, 0)

	local bottomDetail = Instance.new("Frame", c)
	bottomDetail.Name = "BottomDetail"
	bottomDetail.Size = UDim2.new(1, -24, 0, 1)
	bottomDetail.Position = UDim2.new(0, 12, 1, -1)
	bottomDetail.BackgroundColor3 = Color3.fromRGB(150,150,160)
	bottomDetail.BackgroundTransparency = 0.58
	bottomDetail.BorderSizePixel = 0
	bottomDetail.ZIndex = 5

	c.MouseEnter:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play() end)
	c.MouseLeave:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play() end)
	return c
end

local function cLabel(p, text, x, w, sz, col, font, xa)
	local l = Instance.new("TextLabel", p)
	l.Size = UDim2.new(0, w or 140, 1, 0)
	l.Position = UDim2.new(0, x or 10, 0, 0)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = col or WHITE
	l.Font = font or Enum.Font.GothamBold
	l.TextSize = sz or 11
	l.TextXAlignment = xa or Enum.TextXAlignment.Left
	l.TextTransparency = 0
	l.TextStrokeTransparency = 0.35
	l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	l.ZIndex = 120
	return l
end

local function makePillToggle(parent, defOn, onToggle)
	local PW, PH = 36, 19
	local pbg = Instance.new("Frame", parent)
	pbg.Size = UDim2.new(0, PW, 0, PH)
	pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2)
	pbg.BackgroundColor3 = defOn and WHITE or DIM2
	pbg.BorderSizePixel = 0
	pbg.ZIndex = 8
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10)
	local ps = Instance.new("UIStroke", pbg); ps.Color = defOn and WHITE or BORDER2; ps.Thickness = 1
	local dot = Instance.new("Frame", pbg)
	dot.Size = UDim2.new(0, 13, 0, 13)
	dot.Position = defOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
	dot.BackgroundColor3 = defOn and BG or BORDER
	dot.BorderSizePixel = 0
	dot.ZIndex = 9
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	local isOn = defOn or false
	local function setV(on)
		isOn = on
		TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or DIM2}):Play()
		TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
		TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6),
			BackgroundColor3 = on and BG or BORDER
		}):Play()
	end
	local clk = Instance.new("TextButton", parent)
	clk.Size = UDim2.new(1, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.MouseButton1Click:Connect(function()
		if _anyKeyListening then return end
		isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return setV
end

local function makeKB(parent, kbEntry, onChange)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0, 44, 0, 20)
	b.BackgroundColor3 = KB_BG
	b.BackgroundTransparency = INPUT_TRANSPARENCY
	b.BorderSizePixel = 0
	local function getDisplayText()
		if kbEntry.gp then return "GP:"..kbEntry.gp.Name
		elseif kbEntry.kb then return kbEntry.kb.Name
		else return "None" end
	end
	b.Text = getDisplayText()
	State._bindButtons = State._bindButtons or {}
	State._bindButtons[kbEntry] = b
	b.TextColor3 = WHITE
	b.Font = Enum.Font.GothamBold
	b.TextSize = 8
	b.ZIndex = 11
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local bs = Instance.new("UIStroke", b); bs.Color = BORDER; bs.Thickness = 1
	local li = false; local lc; local pv = b.Text
	b.MouseButton1Click:Connect(function()
		if li then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; b.Text=pv; b.TextColor3=WHITE; return end
		pv=b.Text; li=true; _anyKeyListening=true; b.Text="···"; b.TextColor3=DIM
		TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play()
		lc = UIS.InputBegan:Connect(function(inp)
			if not li then return end
			local isKb = inp.UserInputType == Enum.UserInputType.Keyboard
			local isGp = string.sub(inp.UserInputType.Name, 1, 7) == "Gamepad"
			if not isKb and not isGp then return end
			if inp.KeyCode == Enum.KeyCode.Escape then
				li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
				b.Text=pv; b.TextColor3=WHITE; TweenService:Create(bs,TweenInfo.new(0.1),{Color=BORDER}):Play(); return
			end
			if isGp then
				kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
				b.Text = "GP:"..inp.KeyCode.Name; pv = b.Text
			else
				kbEntry.kb = inp.KeyCode; kbEntry.gp = nil
				b.Text = inp.KeyCode.Name; pv = b.Text
			end
			b.TextColor3=WHITE
			li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
			TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER}):Play()
			if onChange then onChange(inp.KeyCode) end
			if isGp then
				kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
			else
				kbEntry.kb = inp.KeyCode; kbEntry.gp = nil
			end
			if State.requestConfigSave then State.requestConfigSave() end
		end)
	end)
	return b
end

local function rowToggle(tabName, label, sub, defOn, onToggle)
	local c = baseCard(tabName, sub and 58 or 38)
	local titleLabel = cLabel(c, label, 10, 160, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 160, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = cLabel(c, sub, 10, 170, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 170, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	return makePillToggle(c, defOn, onToggle)
end

local function rowToggleKB(tabName, label, sub, kbEntry, defOn, onToggle, onKeyChange)
	local c = baseCard(tabName, sub and 58 or 38)
	local titleLabel = cLabel(c, label, 10, 120, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 120, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = cLabel(c, sub, 10, 150, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 150, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local kb = makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
	kb.Position = UDim2.new(1, -(44+10+36+8+19), 0.5, -10)
	kb.ZIndex = 11
	local PW, PH = 36, 19
	local pbg = Instance.new("Frame", c)
	pbg.Size = UDim2.new(0, PW, 0, PH)
	pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2)
	pbg.BackgroundColor3 = defOn and WHITE or DIM2
	pbg.BorderSizePixel = 0
	pbg.ZIndex = 8
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10)
	local ps = Instance.new("UIStroke", pbg); ps.Color = defOn and WHITE or BORDER2; ps.Thickness = 1
	local dot = Instance.new("Frame", pbg)
	dot.Size = UDim2.new(0, 13, 0, 13)
	dot.Position = defOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
	dot.BackgroundColor3 = defOn and BG or BORDER
	dot.BorderSizePixel = 0
	dot.ZIndex = 9
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	local isOn = defOn or false
	local function setV(on)
		isOn = on
		TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or DIM2}):Play()
		TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
		TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6),
			BackgroundColor3 = on and BG or BORDER
		}):Play()
	end
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(1, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.MouseButton1Click:Connect(function()
		if _anyKeyListening then return end
		isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return setV, kb
end

local function rowKBOnly(tabName, label, sub, kbEntry, onKeyChange)
	local c = baseCard(tabName, sub and 58 or 38)
	local titleLabel = cLabel(c, label, 10, 160, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 160, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = cLabel(c, sub, 10, 170, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 170, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local kb = makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	return kb
end


local function rowInput(tabName, label, sub, default, onChange)
	local c = baseCard(tabName, sub and 58 or 38)
	local titleLabel = cLabel(c, label, 10, 130, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 130, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = cLabel(c, sub, 10, 160, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 160, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local box = Instance.new("TextBox", c)
	box.Size = UDim2.new(0, 64, 0, 24)
	box.Position = UDim2.new(1, -74, 0.5, -12)
	box.BackgroundColor3 = INPUT_BG
	box.BackgroundTransparency = INPUT_TRANSPARENCY
	box.BorderSizePixel = 0
	box.Text = tostring(default)
	box.TextColor3 = WHITE
	box.Font = Enum.Font.GothamBold
	box.TextSize = 11
	box.ClearTextOnFocus = false
	box.ZIndex = 11
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
	local bs = Instance.new("UIStroke", box); bs.Color = BORDER; bs.Thickness = 1; bs.ZIndex = 12
	box.Focused:Connect(function() TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play() end)
	box.FocusLost:Connect(function()
		TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER}):Play()
		if onChange then local n = tonumber(box.Text); if n then onChange(n) else box.Text = tostring(default) end end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return box
end

local function rowActionBtn(tabName, label, onClick)
	local b = Instance.new("TextButton", pg(tabName))
	b.Size = UDim2.new(1, 0, 0, 36)
	b.BackgroundColor3 = CARD_BG
	b.BackgroundTransparency = OPTION_TRANSPARENCY
	b.BorderSizePixel = 0
	b.Text = label
	b.TextColor3 = WHITE
	b.Font = Enum.Font.GothamBold
	b.TextSize = 11
	b.LayoutOrder = lo(tabName)
	b.ZIndex = 5
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
	local bSt = Instance.new("UIStroke", b)
	bSt.Color = BORDER
	bSt.Thickness = 1.2

	local pressScale = Instance.new("UIScale", b)
	pressScale.Scale = 1

	b.MouseButton1Click:Connect(function()
		TweenService:Create(pressScale, TweenInfo.new(0.06), {Scale=0.975}):Play()
		TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play()
		task.delay(0.08, function()
			if pressScale and pressScale.Parent then
				TweenService:Create(pressScale, TweenInfo.new(0.09, Enum.EasingStyle.Back), {Scale=1}):Play()
			end
		end)
		task.delay(0.15, function()
			if b and b.Parent then
				TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play()
			end
		end)
		if onClick then pcall(onClick) end
	end)
	b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play() end)
	b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play() end)
	return b
end

local function rowCycleSelector(tabName, label, options, defaultValue, onChange)
	local c = baseCard(tabName, 40)
	cLabel(c, label, 10, 110, 11, WHITE, Enum.Font.GothamBold)

	local left = Instance.new("TextButton", c)
	left.Size = UDim2.new(0, 26, 0, 24)
	left.Position = UDim2.new(1, -142, 0.5, -12)
	left.BackgroundColor3 = INPUT_BG
	left.BackgroundTransparency = INPUT_TRANSPARENCY
	left.BorderSizePixel = 0
	left.Text = "←"
	left.TextColor3 = WHITE
	left.Font = Enum.Font.GothamBlack
	left.TextSize = 15
	left.ZIndex = 12
	Instance.new("UICorner", left).CornerRadius = UDim.new(0, 12)
	local leftStroke = Instance.new("UIStroke", left); leftStroke.Color = BORDER; leftStroke.Thickness = 1

	local valueLabel = Instance.new("TextLabel", c)
	valueLabel.Size = UDim2.new(0, 78, 0, 24)
	valueLabel.Position = UDim2.new(1, -112, 0.5, -12)
	valueLabel.BackgroundColor3 = INPUT_BG
	valueLabel.BackgroundTransparency = INPUT_TRANSPARENCY
	valueLabel.BorderSizePixel = 0
	valueLabel.TextColor3 = WHITE
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 9
	valueLabel.TextXAlignment = Enum.TextXAlignment.Center
	valueLabel.ZIndex = 11
	Instance.new("UICorner", valueLabel).CornerRadius = UDim.new(0, 12)
	local valueStroke = Instance.new("UIStroke", valueLabel); valueStroke.Color = BORDER; valueStroke.Thickness = 1

	local right = Instance.new("TextButton", c)
	right.Size = UDim2.new(0, 26, 0, 24)
	right.Position = UDim2.new(1, -30, 0.5, -12)
	right.BackgroundColor3 = INPUT_BG
	right.BackgroundTransparency = INPUT_TRANSPARENCY
	right.BorderSizePixel = 0
	right.Text = "→"
	right.TextColor3 = WHITE
	right.Font = Enum.Font.GothamBlack
	right.TextSize = 15
	right.ZIndex = 12
	Instance.new("UICorner", right).CornerRadius = UDim.new(0, 12)
	local rightStroke = Instance.new("UIStroke", right); rightStroke.Color = BORDER; rightStroke.Thickness = 1

	local index = 1
	for i, option in ipairs(options) do
		if option == defaultValue then index = i; break end
	end

	local function setValue(value, fireCallback)
		if type(value) == "number" then
			index = ((math.floor(value) - 1) % #options) + 1
		else
			for i, option in ipairs(options) do
				if option == value then index = i; break end
			end
		end
		valueLabel.Text = options[index]
		if fireCallback and onChange then pcall(onChange, options[index], index) end
		return options[index]
	end

	local function move(direction)
		setValue(index + direction, true)
		if State.requestConfigSave then State.requestConfigSave() end
	end

	left.Activated:Connect(function() move(-1) end)
	right.Activated:Connect(function() move(1) end)
	left.MouseEnter:Connect(function() TweenService:Create(left, TweenInfo.new(0.1), {BackgroundTransparency=0.05}):Play() end)
	left.MouseLeave:Connect(function() TweenService:Create(left, TweenInfo.new(0.1), {BackgroundTransparency=INPUT_TRANSPARENCY}):Play() end)
	right.MouseEnter:Connect(function() TweenService:Create(right, TweenInfo.new(0.1), {BackgroundTransparency=0.05}):Play() end)
	right.MouseLeave:Connect(function() TweenService:Create(right, TweenInfo.new(0.1), {BackgroundTransparency=INPUT_TRANSPARENCY}):Play() end)

	setValue(defaultValue, false)
	return setValue, function() return options[index] end
end

-- SECCIÓN 7: PESTAÑA SPEED Y AUTO CARRY
do
makeSecHeader("Speed", "Speed Configuration")

do
	local c = baseCard("Speed", 48)
	cLabel(c, "Speed Profile", 10, 92, 11, WHITE, Enum.Font.GothamBold)

	local holder = Instance.new("Frame", c)
	holder.Name = "SpeedProfileSelector"
	holder.Size = UDim2.new(0, 150, 0, 28)
	holder.Position = UDim2.new(1, -160, 0.5, -14)
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.ZIndex = 12

	local layout = Instance.new("UIListLayout", holder)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 6)

	local function makeProfileButton(label)
		local b = Instance.new("TextButton", holder)
		b.Name = label .. "Profile"
		b.Size = UDim2.new(0, 72, 0, 28)
		b.BackgroundColor3 = CARD_BG
		b.BackgroundTransparency = 0.12
		b.BorderSizePixel = 0
		b.Text = string.upper(label)
		b.TextColor3 = DIM
		b.TextSize = 10
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = false
		b.ZIndex = 13
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		local stroke = Instance.new("UIStroke", b)
		stroke.Color = Color3.fromRGB(150,150,160)
		stroke.Thickness = 1
		stroke.Transparency = 0.3
		return b, stroke
	end

	local normalProfileBtn, normalProfileStroke = makeProfileButton("Normal")
	local laggerProfileBtn, laggerProfileStroke = makeProfileButton("Lagger")
	local customProfileBtn, customProfileStroke = makeProfileButton("Custom")

	local function refreshProfileVisual()
		local function paint(btn, stroke, active)
			TweenService:Create(btn, TweenInfo.new(0.12), {
				BackgroundColor3 = active and Color3.fromRGB(0, 170, 210) or CARD_BG,
				TextColor3 = active and WHITE or DIM,
				BackgroundTransparency = active and 0.02 or 0.12
			}):Play()
			stroke.Color = active and Color3.fromRGB(0, 170, 210) or Color3.fromRGB(150,150,160)
		end
		paint(normalProfileBtn, normalProfileStroke, State.speedProfile == "Normal")
		paint(laggerProfileBtn, laggerProfileStroke, State.speedProfile == "Lagger")
		paint(customProfileBtn, customProfileStroke, State.speedProfile == "Custom")
	end

	local function selectProfile(profile)
		if profile == "Lagger" then
			State.speedProfile = "Lagger"
		elseif profile == "Custom" then
			State.speedProfile = "Custom"
		else
			State.speedProfile = "Normal"
		end
		refreshProfileVisual()
		if normalBox then
			normalBox.Text = tostring(getProfileNormalSpeed())
		end
		if carryBox then
			carryBox.Text = tostring(getProfileCarrySpeed())
		end
		if modeValLbl then
			if State.laggerToggled then
				modeValLbl.Text = laggerPhase == 2 and "Lagger 2" or "Lagger 1"
			elseif State.speedToggled then
				modeValLbl.Text = State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry"
			else
				modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"
			end
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end

	normalProfileBtn.Activated:Connect(function() selectProfile("Normal") end)
	customProfileBtn.MouseButton1Click:Connect(function() selectProfile("Custom") end)
	laggerProfileBtn.Activated:Connect(function() selectProfile("Lagger") end)

	State._refreshSpeedProfileVisual = refreshProfileVisual
	State._selectSpeedProfile = selectProfile
	refreshProfileVisual()
end

normalBox = rowInput("Speed", "Normal Speed", nil, NS, function(v)
	if v > 0 and v <= 500 then
		if State.speedProfile == "Lagger" then
			State.profileLaggerNormalSpeed = v
		elseif State.speedProfile == "Custom" then
			State.profileCustomNormalSpeed = v
		else
			NS = v
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)
carryBox = rowInput("Speed", "Carry Speed", nil, CS, function(v)
	if v > 0 and v <= 500 then
		if State.speedProfile == "Lagger" then
			State.profileLaggerCarrySpeed = v
		else
			CS = v
			_G.CarrySpeedValue = v
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)
laggerBox = rowInput("Speed", "Lagger 1", nil, LS, function(v) if v>0 and v<=500 then LS=v end end)
laggerBox2 = rowInput("Speed", "Lagger 2", nil, LS2, function(v) if v>0 and v<=500 then LS2=v end end)

-- ===== TOGGLE AUTO CARRY (AHORA PERSISTE) =====
do
    local sv
    sv = rowToggle("Speed", "Auto Carry", "Se activa carry automáticamente al agarrar el Brainrot", State.autoCarryEnabled,
    function(on)
        State.autoCarryEnabled = on
        if State.requestConfigSave then State.requestConfigSave() end
    end)
    State.autoCarrySetVisual = sv
end

do
	local c = baseCard("Speed", 38)
	cLabel(c, "Mode", 10, 80, 11, WHITE, Enum.Font.GothamBold)
	modeValLbl = cLabel(c, "Normal", 88, 80, 10, DIM, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
	local kb = makeKB(c, KB.Speed, function(k) end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(0.65, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.Active = true
	clk.Activated:Connect(function()
		if _anyKeyListening then return end
		State.speedToggled = not State.speedToggled
		if State.speedToggled then
			State.laggerToggled = false
			if mobileLaggerSetActive then mobileLaggerSetActive(false) end
		end
		if mobileSpeedSetActive then mobileSpeedSetActive(State.speedToggled) end
		modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
		if State.requestConfigSave then State.requestConfigSave() end
	end)
end

do
	local c = baseCard("Speed", 38)
	cLabel(c, "Lagger Mode", 10, 120, 11, WHITE, Enum.Font.GothamBold)
	local kb = makeKB(c, KB.Lagger, function(k) KB.Lagger.kb = k end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(0.65, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.Active = true
	clk.Activated:Connect(function()
		if _anyKeyListening then return end
		State.laggerToggled = not State.laggerToggled
		if State.laggerToggled then
			State.speedToggled = false
			if mobileSpeedSetActive then mobileSpeedSetActive(false) end
		end
		modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
		if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
end

makeSecHeader("Bat Aimbot", "Bat Combat V1 & V2")
do
	local sv
	sv, _ = rowToggleKB("Bat Aimbot", "Auto Bat V1", "Modo predictivo", KB.AutoBat, false,
	function(on)
		State.autoBatToggled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatV2Enabled then
				State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if mobileBatV2SetActive then mobileBatV2SetActive(false) end
				stopBatAimbotV2()
			end
			if State.tpBatEnabled then State._setTPBatEnabled(false) end
			startBatAimbot()
		else
			stopBatAimbot()
		end
		if mobileBatV1SetActive then mobileBatV1SetActive(on) end
	end,
	function(k) KB.AutoBat.kb = k end)
	autoBatSetVisual = sv
	setAutoBat = sv
end

do
	local sv
	sv, _ = rowToggleKB("Bat Aimbot", "bat v2", "Versión avanzada ", KB.AutoBatV2, false,
	function(on)
		State.autoBatV2Enabled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatToggled then
				State.autoBatToggled = false
				if autoBatSetVisual then autoBatSetVisual(false) end
				stopBatAimbot()
			end
			if State.tpBatEnabled then State._setTPBatEnabled(false) end
			if startBatAimbotV2 then startBatAimbotV2() end
		else
			if stopBatAimbotV2 then stopBatAimbotV2() end
		end
		if mobileBatV2SetActive then mobileBatV2SetActive(on) end
	end,
	function() end)
	autoBatV2SetVisual = sv
	setAutoBatV2 = sv
end

State._setTPBatEnabled = function(on)
	on = on == true

	if on then
		if State.autoLeftEnabled then
			State.autoLeftEnabled = false
			stopAutoLeft()
			if autoLeftSetVisual then autoLeftSetVisual(false) end
		end
		if State.autoRightEnabled then
			State.autoRightEnabled = false
			stopAutoRight()
			if autoRightSetVisual then autoRightSetVisual(false) end
		end
		if State.autoBatToggled then
			State.autoBatToggled = false
			if autoBatSetVisual then autoBatSetVisual(false) end
			stopBatAimbot()
		end
		if State.autoBatV2Enabled then
			State.autoBatV2Enabled = false
			if autoBatV2SetVisual then autoBatV2SetVisual(false) end
			if mobileBatV2SetActive then mobileBatV2SetActive(false) end
			stopBatAimbotV2()
		end
	else
	end

	State.tpBatEnabled = on
	if State._tpBatSetter then State._tpBatSetter(on) end
	if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
end

State._tpBatConfigSetVisual = rowToggleKB("Bat Aimbot", "TP BAT", "Teleport y golpe automático", KB.TPBat, false,
function(on)
	State._setTPBatEnabled(on)
	if State._tpBatSetter then State._tpBatSetter(on) end
end,
function() end)

makeSecHeader("Mechanics", "Game Mechanics")

if not KB.InstaReset then KB.InstaReset = {kb=nil, gp=nil} end

local cInsta = baseCard("Mechanics", 48)
cInsta.LayoutOrder = lo("Mechanics")
cLabel(cInsta, "Insta Reset", 10, 120, 11, WHITE, Enum.Font.GothamBold)
local slInsta = cLabel(cInsta, "Reset Instantáneo", 10, 150, 9, DIM, Enum.Font.Gotham)
slInsta.Size = UDim2.new(0, 150, 0, 13); slInsta.Position = UDim2.new(0, 10, 0, 24)

local plusBtn = Instance.new("TextButton", cInsta)
plusBtn.Size = UDim2.new(0, 20, 0, 20)
plusBtn.Position = UDim2.new(1, -(44+10+36+8+20+4), 0.5, -10)
plusBtn.BackgroundColor3 = KB_BG
plusBtn.BorderSizePixel = 0
plusBtn.Text = "+"
plusBtn.TextColor3 = WHITE
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 14
plusBtn.ZIndex = 11
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 10)
local pbs = Instance.new("UIStroke", plusBtn); pbs.Color = BORDER; pbs.Thickness = 1
plusBtn.MouseButton1Click:Connect(function()
	TweenService:Create(plusBtn, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV}):Play()
	task.delay(0.1, function() TweenService:Create(plusBtn, TweenInfo.new(0.1), {BackgroundColor3=KB_BG}):Play() end)

	if btnInstaReset then
		btnInstaReset.Visible = not btnInstaReset.Visible
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)

local kbInsta = makeKB(cInsta, KB.InstaReset, function() end)
kbInsta.Position = UDim2.new(1, -(44+10+36+8), 0.5, -10)
kbInsta.ZIndex = 11

local setInstaToggleVisual
setInstaToggleVisual = makePillToggle(cInsta, false, function(on)
	State.instaResetEnabled = on
	if on then
		if btnInstaReset then
			TweenService:Create(btnInstaReset, TweenInfo.new(0.08), {BackgroundColor3=WHITE, TextColor3=BG}):Play()
			task.delay(0.22, function()
				TweenService:Create(btnInstaReset, TweenInfo.new(0.15), {BackgroundColor3=BG, TextColor3=WHITE}):Play()
			end)
		end

		task.spawn(cursedInstaReset)

		task.wait(0.2)
		if setInstaToggleVisual then setInstaToggleVisual(false) end
	end
end)

-- Animation Pack under Bat Skin
do
	local ANIMS = {
		"Normal", "Adidas Sports", "Adidas Community", "Adidas Aura", "Wicked Popular",
		"Elder", "Zombie", "Mage", "Catwalk Glam", "Astronaut", "Werewolf", "Superhero",
		"Toy", "No Boundaries", "NFL", "Amazon Unboxed", "Vampire", "Ninja", "Robot",
		"Levitation", "Stylish", "Bubbly", "Cartoon"
	}
	State.animPackIndex = State.animPackIndex or 1
	State.animPackName = State.animPackName or "Normal"
	local c = baseCard("Mechanics", 58)
	c.LayoutOrder = -99
	local title = cLabel(c, "Animation Pack", 10, 150, 11, WHITE, Enum.Font.GothamBold)
	title.Position = UDim2.new(0, 10, 0, 6)
	title.Size = UDim2.new(0, 150, 0, 18)
	local sub = cLabel(c, "Cycle animation pack", 10, 170, 9, DIM, Enum.Font.Gotham)
	sub.Position = UDim2.new(0, 10, 0, 28)
	sub.Size = UDim2.new(0, 170, 0, 16)
	local nameLbl = Instance.new("TextLabel", c)
	nameLbl.Size = UDim2.new(0, 100, 0, 28)
	nameLbl.Position = UDim2.new(1, -170, 0.5, -14)
	nameLbl.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
	nameLbl.BackgroundTransparency = 0.1
	nameLbl.Text = ANIMS[State.animPackIndex]
	nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.TextSize = 9
	nameLbl.TextScaled = true
	nameLbl.ZIndex = 120
	Instance.new("UICorner", nameLbl).CornerRadius = UDim.new(0, 8)
	local prevBtn = Instance.new("TextButton", c)
	prevBtn.Size = UDim2.new(0, 28, 0, 28)
	prevBtn.Position = UDim2.new(1, -68, 0.5, -14)
	prevBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
	prevBtn.Text = "<"
	prevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	prevBtn.Font = Enum.Font.GothamBold
	prevBtn.TextSize = 14
	prevBtn.ZIndex = 120
	prevBtn.AutoButtonColor = false
	Instance.new("UICorner", prevBtn).CornerRadius = UDim.new(0, 8)
	local nextBtn = Instance.new("TextButton", c)
	nextBtn.Size = UDim2.new(0, 28, 0, 28)
	nextBtn.Position = UDim2.new(1, -36, 0.5, -14)
	nextBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
	nextBtn.Text = ">"
	nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	nextBtn.Font = Enum.Font.GothamBold
	nextBtn.TextSize = 14
	nextBtn.ZIndex = 120
	nextBtn.AutoButtonColor = false
	Instance.new("UICorner", nextBtn).CornerRadius = UDim.new(0, 8)
	local function refresh()
		local name = ANIMS[State.animPackIndex]
		nameLbl.Text = name
		State.animPackName = name
		pcall(function()
			if _G.NIGHT_applyAnimationPack then _G.NIGHT_applyAnimationPack(name) end
		end)
		if State.requestConfigSave then State.requestConfigSave() end
	end
	prevBtn.MouseButton1Click:Connect(function()
		State.animPackIndex = State.animPackIndex - 1
		if State.animPackIndex < 1 then State.animPackIndex = #ANIMS end
		refresh()
	end)
	nextBtn.MouseButton1Click:Connect(function()
		State.animPackIndex = State.animPackIndex + 1
		if State.animPackIndex > #ANIMS then State.animPackIndex = 1 end
		refresh()
	end)
end

setInfJump       = rowToggle("Mechanics", "Infinite Jump",  nil, false, function(on) State.infJumpEnabled = on end)
setSuperJump     = rowToggle("Mechanics", "Infinite Jump Hold",     nil, false, function(on) State.superJumpEnabled = on end)
setLinieVisual   = rowToggle("Mechanics", "Linia ESP", nil, false, function(on) State.linieEnabled = on end)
setAntiRag       = rowToggle("Mechanics", "Anti Ragdoll",   nil, false, function(on) State.antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end end)
setUnwalkToggle  = rowToggle("Mechanics", "Unwalk",         nil, false, function(on) State.unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end end)
setMedusaCounter = rowToggle("Mechanics", "Medusa Counter", nil, false, function(on) State.medusaCounterEnabled=on; if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end end)
setBatCounter = rowToggle("Mechanics", "Bat Counter",    nil, false, function(on) State.batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end end)

setAutoMedusaVisual = rowToggle("Mechanics", "Auto Medusa", "Uso automático y predictivo", false, function(on)
	MedusaConfig.Enabled = on
end)

rowToggle("Mechanics", "Medusa Reset", "Resetea al ser petrificado", false, function(on)
	pcall(function() if _G.NIGHT_setMedusaReset then _G.NIGHT_setMedusaReset(on) end end)
	State.autoResetEnabled = on
	if State.requestConfigSave then State.requestConfigSave() end
end)

setNinoTimeVisual = rowToggle("Mechanics", "Nino time", "Contador de stun de 3 segundos", false, function(on)
	setNinoTime(on)
	if State.requestConfigSave then State.requestConfigSave() end
end)

rowInput("Mechanics", "Medusa Radius", "Rango de detección", MedusaConfig.Radius, function(v)
	MedusaConfig.Radius = v
	if MedusaConfig.RadiusPart then
		MedusaConfig.RadiusPart.Size = Vector3.new(0.2, MedusaConfig.Radius*2, MedusaConfig.Radius*2)
	end
end)


rowInput("Mechanics", "Medusa Delay", "Spam Delay", MedusaConfig.Delay, function(v)
	MedusaConfig.Delay = v
end)



RunService.Heartbeat:Connect(function()
    if not State.superJumpEnabled then return end
    local c = LP.Character
    if not c then return end
    local root = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)

    if isJumpHeld and root.Velocity.Y < 35 then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end

    if root.Velocity.Y < -120 then
        root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
    end
end)

makeSecHeader("Movement", "Movement & Teleport")
rowKBOnly("Movement", "TP Down", "Teleport to floor", KB.TPDown, function(k) KB.TPDown.kb=k end)
do
	local sv
	sv, _ = rowToggleKB("Movement", "Auto Left", nil, KB.AutoLeft, false,
	function(on)
		State.autoLeftEnabled = on
		if on then
			if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			if State.autoBatV2Enabled then
				State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if mobileBatV2SetActive then mobileBatV2SetActive(false) end
				stopBatAimbotV2()
			end
			if State.tpBatEnabled then State._setTPBatEnabled(false) end
			local char = LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hum and hrp and hum.WalkSpeed > 0 and not hrp.Anchored then
				startAutoLeft()
			end
		else stopAutoLeft() end
		if mobileAutoLeftSetActive then mobileAutoLeftSetActive(on) end
	end, function(k) KB.AutoLeft.kb=k end)
	autoLeftSetVisual = sv
end
do
	local sv
	sv, _ = rowToggleKB("Movement", "Auto Right", nil, KB.AutoRight, false,
	function(on)
		State.autoRightEnabled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			if State.autoBatV2Enabled then State.autoBatV2Enabled=false; if autoBatV2SetVisual then autoBatV2SetVisual(false) end; stopBatAimbotV2() end
			if State.tpBatEnabled then State._setTPBatEnabled(false) end
			local char = LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hum and hrp and hum.WalkSpeed > 0 and not hrp.Anchored then
				startAutoRight()
			end
		else stopAutoRight() end
		if mobileAutoRightSetActive then mobileAutoRightSetActive(on) end
	end, function(k) KB.AutoRight.kb=k end)
	autoRightSetVisual = sv
end
rowKBOnly("Movement", "Drop",    nil, KB.Drop,   function(k) KB.Drop.kb=k end)

do
	setAutoTPDownVisual = rowToggle("Movement", "Auto TP Down", nil, false, function(on)
		autoTPDownEnabled = on
		if mobileAutoTPSetActive then mobileAutoTPSetActive(on) end
		if on then startAutoTPDown() else stopAutoTPDown() end
	end)
	rowInput("Movement", "TP Down Height", nil, autoTPDownHeight, function(v)
		autoTPDownHeight = math.clamp(v, 0, 500)
	end)
end


-- ============================================================
-- ANTI DROP (404 system - velocity spoof)
-- ============================================================
do
	local Players = game:GetService("Players")
	local LP = Players.LocalPlayer
	local mt = nil
	pcall(function() mt = getrawmetatable(game) end)
	local oldIdx, oldNewIdx
	local spoofedVelocity = Vector3.zero
	local antiDropActive = false

	local function startAntiDrop()
		if antiDropActive then return end
		if not mt then
			pcall(function() mt = getrawmetatable(game) end)
		end
		if not mt then return end
		if typeof(newcclosure) ~= "function" then return end
		oldIdx = mt.__index
		oldNewIdx = mt.__newindex
		pcall(function() setreadonly(mt, false) end)
		mt.__index = newcclosure(function(self, key)
			if typeof(checkcaller) == "function" and not checkcaller() then
				if (key == "AssemblyLinearVelocity" or key == "Velocity") then
					if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" then
						local char = LP.Character
						if char and self:IsDescendantOf(char) then
							return spoofedVelocity
						end
					end
				end
			end
			return oldIdx(self, key)
		end)
		mt.__newindex = newcclosure(function(self, key, value)
			if typeof(checkcaller) == "function" and not checkcaller() then
				if (key == "AssemblyLinearVelocity" or key == "Velocity") then
					if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" then
						local char = LP.Character
						if char and self:IsDescendantOf(char) then
							spoofedVelocity = value
							return
						end
					end
				end
			end
			return oldNewIdx(self, key, value)
		end)
		pcall(function() setreadonly(mt, true) end)
		antiDropActive = true
		State.antiDropEnabled = true
	end

	local function stopAntiDrop()
		if not antiDropActive then return end
		if mt and oldIdx then
			pcall(function() setreadonly(mt, false) end)
			mt.__index = oldIdx
			mt.__newindex = oldNewIdx
			pcall(function() setreadonly(mt, true) end)
			oldIdx = nil
			oldNewIdx = nil
		end
		antiDropActive = false
		State.antiDropEnabled = false
		spoofedVelocity = Vector3.zero
	end

	_G.SPRITE_startAntiDrop = startAntiDrop
	_G.SPRITE_stopAntiDrop = stopAntiDrop
	_G.SPRITE_setAntiDrop = function(on)
		if on then startAntiDrop() else stopAntiDrop() end
	end
	-- Auto enable
	task.defer(function()
		pcall(startAntiDrop)
		State.antiDropEnabled = true
	end)
	_G.SPRITE_autoAntiDrop = true

	
makeSecHeader("Performance", "Anti Drop")
	rowToggle("Performance", "Anti Drop", "404 system - prevents brainrot drop", true, function(on)
		pcall(function()
			if on then startAntiDrop() else stopAntiDrop() end
		end)
		if State.requestConfigSave then State.requestConfigSave() end
	end)
end

-- ============================================================
-- KEYBINS TAB (PC + Controller)
-- ============================================================
do
	makeSecHeader("Keybins", "Menu & Lateral Buttons")

	local order = {
		{"GuiHide", "Open / Hide Menu"},
		{"AutoLeft", "Auto Left"},
		{"AutoRight", "Auto Right"},
		{"Drop", "Drop Brainrot"},
		{"TPDown", "TP Down"},
		{"AutoBat", "Auto Bat"},
		{"AutoBatV2", "Auto Bat V2"},
		{"TPBat", "TP Bat"},
		{"Speed", "Speed"},
		{"Lagger", "Lagger"},
		{"InstaReset", "Insta Reset"},
		{"MusicPC", "Music (PC)"},
		{"MusicPad", "Music (Controller)"},
		{"Taunt", "Taunt"},
	}

	local listening = nil -- {key, kind="kb"|"gp", label}

	local function keyName(kc)
		if not kc then return "None" end
		return tostring(kc.Name or kc)
	end

	local function refreshLabel(lbl, entry)
		local pc = keyName(entry.kb)
		local gp = keyName(entry.gp)
		lbl.Text = "PC: " .. pc .. "  |  Pad: " .. gp
	end

	for _, item in ipairs(order) do
		local key, title = item[1], item[2]
		if KB[key] then
			local c = baseCard("Keybins", 58)
			cLabel(c, title, 10, 160, 11, WHITE, Enum.Font.GothamBold)
			local info = Instance.new("TextLabel", c)
			info.Size = UDim2.new(0, 200, 0, 16)
			info.Position = UDim2.new(0, 10, 0, 32)
			info.BackgroundTransparency = 1
			info.TextColor3 = DIM
			info.Font = Enum.Font.Gotham
			info.TextSize = 10
			info.TextXAlignment = Enum.TextXAlignment.Left
			info.ZIndex = 120
			refreshLabel(info, KB[key])

			local function makeBindBtn(text, xOff, kind)
				local b = Instance.new("TextButton", c)
				b.Size = UDim2.new(0, 52, 0, 24)
				b.Position = UDim2.new(1, xOff, 0.5, -12)
				b.BackgroundColor3 = Color3.fromRGB(20, 40, 28)
				b.Text = text
				b.TextColor3 = WHITE
				b.Font = Enum.Font.GothamBold
				b.TextSize = 10
				b.ZIndex = 120
				b.AutoButtonColor = false
				Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
				b.MouseButton1Click:Connect(function()
					listening = {key = key, kind = kind, label = info, btn = b}
					b.Text = "..."
					info.Text = "Press a key / button..."
				end)
				return b
			end
			makeBindBtn("PC", -120, "kb")
			makeBindBtn("Pad", -62, "gp")
			local clr = Instance.new("TextButton", c)
			clr.Size = UDim2.new(0, 40, 0, 24)
			clr.Position = UDim2.new(1, -40, 0.5, -12)
			clr.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
			clr.Text = "Clr"
			clr.TextColor3 = WHITE
			clr.Font = Enum.Font.GothamBold
			clr.TextSize = 10
			clr.ZIndex = 120
			Instance.new("UICorner", clr).CornerRadius = UDim.new(0, 6)
			clr.MouseButton1Click:Connect(function()
				if listening and listening.key == key then listening = nil end
				KB[key].kb = nil
				KB[key].gp = nil
				refreshLabel(info, KB[key])
				if State.requestConfigSave then State.requestConfigSave() end
			end)
		end
	end

	UIS.InputBegan:Connect(function(input, gp)
		if not listening then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if listening.kind == "kb" then
				KB[listening.key].kb = input.KeyCode
			end
		elseif input.UserInputType == Enum.UserInputType.Gamepad1
			or input.UserInputType == Enum.UserInputType.Gamepad2 then
			if listening.kind == "gp" then
				KB[listening.key].gp = input.KeyCode
			end
		else
			return
		end
		if listening.btn then listening.btn.Text = (listening.kind == "kb") and "PC" or "Pad" end
		refreshLabel(listening.label, KB[listening.key])
		listening = nil
		if State.requestConfigSave then State.requestConfigSave() end
	end)
end


makeSecHeader("Performance", "Performance")

-- ============================================================
--  ELIMINADO EL TOGGLE DE HITBOX FOLLOWER
-- ============================================================

do
	local _Lighting = game:GetService("Lighting")
	local _antiLagConn = nil

	local function applyAntiLag(instance)
		if instance:IsA("ParticleEmitter") then
			instance.Enabled = false
		elseif instance:IsA("Decal") then
			instance.Transparency = 1
		elseif instance:IsA("BasePart") then
			instance.Material = Enum.Material.Plastic
			instance.Reflectance = 0
			instance.CastShadow = false
		end
	end

	local function optimizeLighting()
		_Lighting.GlobalShadows = false
		_Lighting.FogEnd = 9e9
		_Lighting.Brightness = 1
		_Lighting.EnvironmentDiffuseScale = 0
		_Lighting.EnvironmentSpecularScale = 0
		for _, child in pairs(_Lighting:GetChildren()) do
			if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("SunRaysEffect") then
				child.Enabled = false
			end
		end
	end

	local function enableAntiLag()
		optimizeLighting()
		for _, desc in pairs(workspace:GetDescendants()) do
			applyAntiLag(desc)
			if desc:IsA("Accessory") then desc:Destroy() end
		end
		if _antiLagConn then _antiLagConn:Disconnect() end
		_antiLagConn = workspace.DescendantAdded:Connect(function(desc)
			applyAntiLag(desc)
			if desc:IsA("Accessory") then desc:Destroy() end
		end)
	end

	local function disableAntiLag()
		if _antiLagConn then _antiLagConn:Disconnect(); _antiLagConn = nil end
	end

	setAntiLag = function(on)
		State.antiLagEnabled = on
		if on then enableAntiLag() else disableAntiLag() end
	end
	local setAntiLagVisual = rowToggle("Performance", "Anti Lag", nil, false, function(on) setAntiLag(on) end)
	local rawSetAntiLag = setAntiLag
	setAntiLag = function(on) setAntiLagVisual(on); rawSetAntiLag(on) end
end

do
	local connection = nil
	local function rawSet(on)
		State.stretchRezEnabled = on
		if on then
			workspace.CurrentCamera.FieldOfView = 120
			if connection then connection:Disconnect() end
			connection = RunService.RenderStepped:Connect(function()
				if not State.stretchRezEnabled then
					if connection then connection:Disconnect(); connection = nil end
					return
				end
				workspace.CurrentCamera.FieldOfView = 120
			end)
		else
			if connection then connection:Disconnect(); connection = nil end
			workspace.CurrentCamera.FieldOfView = 70
		end
	end
	local visual = rowToggle("Performance", "Stretch Rez", nil, false, function(on) rawSet(on) end)
	setStretchRez = function(on) visual(on); rawSet(on) end
end

do
	local connection = nil
	local function removeFromCharacter(character)
		if not character then return end
		for _, obj in ipairs(character:GetDescendants()) do
			if obj:IsA("Accessory") or obj:IsA("Hat") then
				pcall(function() obj:Destroy() end)
			end
		end
	end
	local function rawSet(on)
		State.removeAccessoriesEnabled = on
		if on then
			for _, player in pairs(Players:GetPlayers()) do
				removeFromCharacter(player.Character)
			end
			if not connection then
				connection = Players.PlayerAdded:Connect(function(player)
					player.CharacterAdded:Connect(function(character)
						task.wait(0.5)
						if State.removeAccessoriesEnabled then removeFromCharacter(character) end
					end)
				end)
			end
		else
			if connection then connection:Disconnect(); connection = nil end
		end
	end
	local visual = rowToggle("Performance", "Remove Accessories", nil, false, function(on) rawSet(on) end)
	setRemoveAccessories = function(on) visual(on); rawSet(on) end
end

do
	local Lighting = game:GetService("Lighting")
	local defaults = {
		Brightness = Lighting.Brightness,
		ClockTime = Lighting.ClockTime,
		ExposureCompensation = Lighting.ExposureCompensation,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		Ambient = Lighting.Ambient,
		FogColor = Lighting.FogColor,
	}
	local styles = {
		{name="Off"},
		{name="Galaxy", tint=Color3.fromRGB(0, 170, 210), ambient=Color3.fromRGB(15, 40, 80), atmosphere=Color3.fromRGB(150,150,160), decay=Color3.fromRGB(10, 25, 50)},
		{name="Aurora", tint=Color3.fromRGB(190,190,200), ambient=Color3.fromRGB(20, 50, 90), atmosphere=Color3.fromRGB(0, 170, 210), decay=Color3.fromRGB(15, 35, 70)},
		{name="Green", tint=Color3.fromRGB(165,255,165), ambient=Color3.fromRGB(35,92,42), atmosphere=Color3.fromRGB(78,232,98), decay=Color3.fromRGB(14,48,20)},
		{name="Blue", tint=Color3.fromRGB(57,198,255), ambient=Color3.fromRGB(12,58,118), atmosphere=Color3.fromRGB(27,148,255), decay=Color3.fromRGB(15,30,76)},
		{name="Red", tint=Color3.fromRGB(255,80,80), ambient=Color3.fromRGB(120,20,40), atmosphere=Color3.fromRGB(200,50,50), decay=Color3.fromRGB(100,20,30)},
		{name="Pink", tint=Color3.fromRGB(255,175,228), ambient=Color3.fromRGB(120,38,90), atmosphere=Color3.fromRGB(255,98,195), decay=Color3.fromRGB(62,14,48)},
		{name="Orange", tint=Color3.fromRGB(255,195,125), ambient=Color3.fromRGB(18,58,130), atmosphere=Color3.fromRGB(18,135,255), decay=Color3.fromRGB(6,28,68)},
		{name="Cyan", tint=Color3.fromRGB(145,255,255), ambient=Color3.fromRGB(8,95,105), atmosphere=Color3.fromRGB(20,225,240), decay=Color3.fromRGB(8,48,58)},
	}
	local function findStyle(name)
		for _, style in ipairs(styles) do
			if style.name == name then return style end
		end
		return styles[1]
	end
	local function clearSky()
		for _, name in ipairs({"GalaxySky", "CryonColorSky", "CryonSkyTint", "CryonSkyAtmosphere", "CryonSkyBloom"}) do
			local object = Lighting:FindFirstChild(name)
			if object then object:Destroy() end
		end
	end
	local function apply(styleName)
		local style = findStyle(styleName)
		clearSky()
		State.skyStyle = style.name
		State.darkModeEnabled = style.name ~= "Off"
		if style.name == "Off" then
			Lighting.Brightness = defaults.Brightness
			Lighting.ClockTime = defaults.ClockTime
			Lighting.ExposureCompensation = defaults.ExposureCompensation
			Lighting.OutdoorAmbient = defaults.OutdoorAmbient
			Lighting.Ambient = defaults.Ambient
			Lighting.FogColor = defaults.FogColor
			return style.name
		end
		local sky = Instance.new("Sky")
		sky.Name = "CryonColorSky"
		sky.SkyboxBk = "rbxassetid://159454299"
		sky.SkyboxDn = "rbxassetid://159454296"
		sky.SkyboxFt = "rbxassetid://159454293"
		sky.SkyboxLf = "rbxassetid://159454286"
		sky.SkyboxRt = "rbxassetid://159454289"
		sky.SkyboxUp = "rbxassetid://159454291"
		sky.StarCount = 3000
		sky.Parent = Lighting
		local correction = Instance.new("ColorCorrectionEffect")
		correction.Name = "CryonSkyTint"
		correction.TintColor = style.tint
		correction.Brightness = 0.05
		correction.Contrast = 0.16
		correction.Saturation = 0.12
		correction.Parent = Lighting
		local atmosphere = Instance.new("Atmosphere")
		atmosphere.Name = "CryonSkyAtmosphere"
		atmosphere.Color = style.atmosphere
		atmosphere.Decay = style.decay
		atmosphere.Density = 0.20
		atmosphere.Offset = 0.05
		atmosphere.Glare = style.name == "Aurora" and 0.42 or 0.2
		atmosphere.Haze = style.name == "Aurora" and 1.55 or 0.85
		atmosphere.Parent = Lighting
		local bloom = Instance.new("BloomEffect")
		bloom.Name = "CryonSkyBloom"
		bloom.Intensity = style.name == "Aurora" and 0.62 or 0.42
		bloom.Size = 28
		bloom.Threshold = 1.05
		bloom.Parent = Lighting
		Lighting.Brightness = 1.45
		Lighting.ClockTime = 0
		Lighting.ExposureCompensation = 0.10
		Lighting.OutdoorAmbient = style.ambient
		Lighting.Ambient = style.ambient:Lerp(Color3.fromRGB(12, 12, 12), 0.16)
		Lighting.FogColor = style.atmosphere:Lerp(Color3.fromRGB(8, 8, 8), 0.05)
		return style.name
	end
	local names = {}
	for _, style in ipairs(styles) do table.insert(names, style.name) end
	setSkySelectorVisual = rowCycleSelector("Performance", "Sky Color", names, State.skyStyle or "Off", function(styleName)
		apply(styleName)
	end)
	setSkyStyle = function(styleName)
		local applied = apply(styleName)
		if setSkySelectorVisual then setSkySelectorVisual(applied, false) end
		return applied
	end
	setDarkMode = function(on)
		return setSkyStyle(on and ((State.skyStyle and State.skyStyle ~= "Off") and State.skyStyle or "Galaxy") or "Off")
	end
end

setNoIntroToggle = rowToggle("Performance", "No Intro", "Desactiva la intro al volver a ejecutar", State.noIntro == true, function(on)
    State.noIntro = on == true
    State.introEnabled = not State.noIntro
    if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

makeSecHeader("Settings", "Interface & Binds")

uiScaleBox = rowInput("Settings", "UI Scale", nil, uiScaleValue, function(v)
	local n = math.clamp(math.floor(v + 0.5), 50, 150)
	uiScaleValue = n
	if mainUIScale then mainUIScale.Scale = n / 100 end
	if uiScaleBox then uiScaleBox.Text = tostring(n) end
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

buttonsSizeBox = rowInput("Settings", "Buttons Size", "0 = mínimo • 100 = máximo", State.buttonsSizeValue, function(v)
	local n = math.clamp(math.floor(v + 0.5), 0, 100)
	applyMobileButtonsSize(n)
	if buttonsSizeBox then buttonsSizeBox.Text = tostring(n) end
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

State._buttonsShapeSelectorVisual = rowCycleSelector(
	"Settings",
	"Buttons Shape",
	{"Circle", "Normal", "Square", "Rectangle"},
	State.buttonsShape,
	function(shapeName)
		applyMobileButtonsShape(shapeName)
	end
)

rowKBOnly("Settings", "Hide / Show GUI", nil, KB.GuiHide, function(k) KB.GuiHide.kb=k end)

setHideButtonsVisual = rowToggle("Settings", "Hide Buttons", "Oculta todos los botones flotantes", false, function(on)
	State.hideButtonsEnabled = on
	local visible = not on

	if MobilePanel then MobilePanel.Visible = visible end
	for _, mobileBtn in pairs(mobileButtonsByName) do
		if mobileBtn and mobileBtn.Parent then
			mobileBtn.Visible = visible
		end
	end

	if btnBatV2 then btnBatV2.Visible = visible end
	if btnInstaReset then btnInstaReset.Visible = visible end
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

setLockUIVisual = rowToggle("Settings", "Lock UI", nil, false, function(on)
	uiLocked = on
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

makeSecHeader("Songs", "Songs")

-- Open full YouTube Music Player (Sinister theme)
local __SINISTER_YMP_SRC = [=[--
--discord.gg/nXF6KGHBS
getgenv().YMP = getgenv().YMP or false

if getgenv().YMP then
	return
end

getgenv().YMP = true
pcall(function()
	if _G.__SinisterYMPSound and _G.__SinisterYMPSound.Parent then
		-- keep playing until user picks a new song; do not stop on open
	end
end)

local fn = cloneref or function(arg)
	return arg
end

local tweenInfo = TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tbl = { Ordem = "relevance", Data = "any", Duracao = "any", Pagina = 1 }
local tweenInfo3 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local ordem = "relevance"
local data = "any"
local duracao = "any"
local tbl2 = { "relevance", "view" }
local tbl3 = { "any", "hours", "today", "week", "month", "year" }
local tbl4 = { "any", "short", "medium", "long" }
local tbl5 = {}
local tbl6 = {}
local tbl7 = {}
local tbl8 = {}
local tbl9 = {}
local tbl10 = {}
local tbl11 = {}
local v = fn(game:GetService("CoreGui"))
local v2 = fn(game:GetService("StarterGui"))
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SinisterYMP"
screenGui.Parent = v
screenGui.IgnoreGuiInset = true
HttpService = fn(game:GetService("HttpService"))
local v3 = fn(game:GetService("Lighting"))
local v4 = fn(game:GetService("Players"))
local userId = v4.LocalPlayer.UserId
local str = v4.LocalPlayer.LocaleId:lower()
local v5 = fn(game:GetService("LogService"))
local v6 = fn(game:GetService("TweenService"))
fn(Instance.new("Sound"))
local v7 = fn(game:GetService("SoundService"))
local v8 = fn(game:GetService("Workspace"))
fn(game:GetService("RunService"))
fn(game:GetService("TextService"))
local v9 = fn(game:GetService("UserInputService"))
local currentCamera = v8.CurrentCamera
local flag = false
local flag2 = false
local screenGui2 = nil
local n = 1
local str2 = "Todos"
local flag3 = false
local flag4 = false
local n2 = 0
local v10 = nil
local tweenInfo4 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo5 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo6 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local flag5 = true
local flag6 = false
local str3 = "https://ymp-api.ddns.net"
-- Conexión en tiempo real con el servidor DESACTIVADA (no se envía el HWID ni se reciben mensajes)
local websocket_ = nil
local flag7 = false
local flag8 = false
local str4 = "Auto"
local v11 = nil
local flag9 = false
local v12 = nil
local udim2 = nil
local flag10 = false
local flag11 = false
local flag12 = false
local flag13 = false
local tween = nil
local n3 = 0
local text = nil
local flag14 = false
local layoutOrder = 0
local udim22 = UDim2.new(0, 4, 0, 4)
local udim23 = UDim2.new(0, 4, 1, 4)
local flag15 = true
local tween2 = nil
local v13 = nil
local tween3 = nil
local flag16 = false
local flag17 = false
local request_ = request or http_request or syn_request or syn and syn.request or http and http.request or fluxus and fluxus.request or getgenv and getgenv().request
local requestAsync

if request_ then
	requestAsync = request_
else
	requestAsync = http and http.request_async
end

local writeClipboard = setclipboard or toclipboard or syn and syn.write_clipboard
local setclipboard_

if writeClipboard then
	setclipboard_ = writeClipboard
else
	setclipboard_ = fluxus and fluxus.setclipboard
end

local gethwid_ = gethwid and gethwid()

if not gethwid_ then
	gethwid_ = syn and syn.gethwid and syn.gethwid()
end

gethwid_ = gethwid_ or fluxus and fluxus.gethwid and fluxus.gethwid()
local hwid

if gethwid_ then
	hwid = gethwid_
else
	hwid = getgenv and getgenv().hwid
end

local v14 = hwid or userId
local flag18 = typeof(clonefunction) == "function" and clonefunction or nil
local v15 = flag18 and flag18(pcall) or pcall
local v16 = flag18 and flag18(typeof) or typeof

CheckRequest = function()
	local v17 = v15(function()
		return ishooked
	end) and ishooked or nil

	local v18 = v15(function()
		return restorefunction
	end) and restorefunction or nil

	if v16(v18) == "function" and v16(v17) == "function" then
		local v19, v20 = v15(v17, v17)

		if v19 and v20 then
			v15(v18, v17)
		end
	end

	if v16(v17) == "function" then
		local v19, v20 = v15(v17, requestAsync)
		if v19 and v20 then
			return false
		end
		local v21, v22 = v15(v17, game.HttpGet)
		if v21 and v22 then
			return false
		end
	end

	return true
end

if not CheckRequest() then
	return
end

-- Comprobación de versión remota eliminada (evitaba cargar el script original y retrasaba el inicio)

-- Avisos remotos desactivados (antes se descargaban desde GitHub)
local ok2, result2 = false, nil

if ok2 then
	local ok3, result3 = pcall(function()
		return HttpService:JSONDecode(result2)
	end)

	if ok3 and result3 then
		local str6 = (result3.title or ""):gsub("%s+", "")
		local str7 = (result3.text or ""):gsub("%s+", "")

		if str6 ~= "" or str7 ~= "" then
			v2:SetCore("SendNotification", {
				Title = result3.title or "Empty",
				Text = result3.text or "Empty",
				Icon = "rbxassetid://83758613781843",
				Duration = 10,
			})

			task.wait(5)
		end
	end
end

Carregar = function() end

Traducao = {
	Sucesso = "Success",
	Erro = "Error",
	Imcompativel = "Your executor does not have support",
	Navegacao = "Navigation",
	Player = "Media Player",
	Add = "Add New",
	Equalizador = "Audio adjustment",
	Welcome = "Welcome",
	Dev = "Creator",
	Hey = "Hey you!",
	Play = "Play a song for me",
	Volume = "Volume",
	Freque = "Sound frequencies",
	Efeitos = "Sound effects",
	Graves = "Bass",
	Medios = "Mids",
	Agudos = "Treble",
	Nenhum = "None",
	Todos = "All",
	Musicas = "Musics",
	Favoritos = "Favorites",
	Favoritado = "Added to favorites",
	Desfavoritado = "Removed from favorites",
	Excluido = "Content deleted",
	Vazio = "Empty",
	VazioTexto = "There is nothing in this category at the moment",
	Search = "Search",
	Pesquisar = "Search for a YouTube title or link",
	Pesquisar2 = "Search for a YouTube title or link, or a Roblox ID",
	PesquiseTitle = "Start a search",
	PesquiseText = "We'll do our best to find your video or music",
	PesquiseTextPL = "We'll search through your entire playlist",
	SemResutadoTitle = "No results",
	SemResutadoText = "We checked everywhere possible, but we couldn't find any results for that search",
	SemResutadoTextPL = "We didn't find any results for that search in your playlist",
	LocalTitle = "Local Audios",
	LocalText = "There's nothing here yet, Add new audio files to the 'Local Audio' folder of the script",
	EscolhaFor = "Select the desired format",
	Musica = "Music",
	Cancelar = "Cancel",
	De = "By",
	In = "In",
	ErroCrackTitle = "Request denied",
	ErroCrackText = "It appears you do not have a valid Premium key",
	ErroTitle = "Something went wrong",
	ErroText = "There was an instability on our servers or in your internet connection, Please try again",
	Aguarde = "Please wait",
	Dados = "We are obtaining data from your file",
	MaisUmPauco = "Almost ready",
	Baixando = "We are downloading your file to add it to your playlist",
	Baixado = "Download complete!",
	Terminou = "Everything went well, and it's already been added to your playlist",
	Priv1 = "Download and play videos",
	Priv2 = "Advanced search",
	PP = "Premium Privilege",
	SobrePri1 = "You will be able to download and watch any YouTube video",
	SobrePri2 = "Have an advanced search that includes search filters and more pages of results",
	SobrePri3 = "You can use MiniPlayer to watch videos or control music on a small floating window",
	SobrePri4 = "Add and listen to any audio from the Roblox library",
	SobrePri5 = "You will be able to interact in Global Chat and converse with other YouTube Music Player users in real time",
	SobrePri6 = "The floating button will have a stylish yellow look!",
	Key = "Enter the Premium key here",
	Link = "Get a free key",
	Robux = "Buy a key with Robux",
	KeyInvalida = "The key you provided is invalid or has expired!",
	KeyErro = "An error occurred while validating your key, Please try again in a few seconds",
	JaTemKey = "It seems to me that you already have a registered key",
	LinkCopiado = "Link copied!",
	Navegador = "Paste the link into your browser to get the key",
	TooMany = "Too many requests",
	RateLi = "You are making too many requests, Wait a few seconds and try again!",
	KeyError = "An error occurred in the key system, Please try again",
	OpcaoBloqueadaTitle = "Option blocked",
	OpcaoBloqueadaText = "Get a Premium key to use this!",
	NenhumaMidia = "No valid tracks found in your playlist's current category!",
	PlayMode = "Playback mode",
	Auto = "Auto-skip: The next track from the current category in your playlist will be selected automatically",
	Repetir = "Repeat: The current track you are listening to will be repeated on a loop",
	Random = "Random: The system will randomly select a track from the current category of your playlist",
	PlayModeRepetir = "No valid tracks found in your playlist's current category, Repeating...",
	DownloadFazendo = "Wait for the system to finish loading the images",
	RecursoTi = "Resource unavailable",
	RecursoTe = "The main equalizer options are not compatible with video",
	RsetadoEqua = "All the changes you made to the equalizer have been removed!",
	NaoPodePagina = "You cannot change pages at the moment",
	NaoPodeFiltro = "Do a search before applying filters!",
	Processando = "Processing...",
	Filter = "Search filters",
	Order = "Order:",
	UploaDate = "Upload Date:",
	Duration = "Duration:",
	AplicarF = "Apply filters",
	RemoverF = "Remove filters",
	Relevance = "Relevance",
	View = "Most viewed",
	Any = "Any",
	Hours = "Last hours",
	Today = "Today",
	Week = "This week",
	Month = "This month",
	Year = "This year",
	Short = "Short(less than 4 minutes)",
	Long = "Long(more than 20 minutes)",
	Medium = "Medium(4 to 20 minutes)",
	JaTemRoblox = "You already have this Roblox ID in your playlist!",
	JaTemMusica = "You already have this song in your playlist!",
	JaTemVideo = "You already have this video in your playlist!",
	FiltrosRemovidos = "All applied filters have been removed!",
	FiltrosJaPadrao = "All filters are already defined by default!",
	Privado = "This audio has been set to private or deleted, It cannot be played",
	VocePremium = "Validated Key",
	Keyless = "Global Chat keyless",
	KeylessOn = "Keyless mode is enabled, Global chat is now unlocked!",
	KeylessOff = "Keyless mode has been disabled, Global Chat is blocked!",
	VocePremiumTexto = "Your Premium has been successfully activated, Enjoy your privileges!",
	Respeito = "Follow the rules to avoid being banned",
	RegrasTi = "Chat Rules",
	Regras = "No insults, No racism, No inappropriate or malicious content, No spam, No suspicious links",
	Sistema = "System",
	EnvieGc = "Write something...",
	GcKey = "Get a premium key to send messages in global chat",
	GcBan = "You have been banned from Global Chat, You can appeal on Discord using your ID:",
	GcUnban = "You have been unbanned from global chat, Behave yourself to avoid being banned again!",
	Banido = "You have been banned",
	Desbanido = "You have been unbanned",
	ExploitIcomGC = "Your executor does not support Global Chat!",
	TraducaoSystem = "Translation",
	TraduOn = "The Global Chat translation system has been enabled",
	TraduOff = "The Global Chat translation system has been disabled",
	TextoCopiado = "Copied message",
	Mutado = "Sounds Removed",
	Desmutado = "Sounds Restored",
	SobreMute = "All game sounds have been removed",
	SobreUnmute = "All the game sounds have been restored",
	AvisoReport1 = "Report Notice — You are about to report the user",
	AvisoReport2 = "on Global Chat, Are you sure you want to continue? False reports that do not involve an actual rule violation may result in a ban.",
	ReportSucesso = "Report sent!",
	ReportSucesso2 = "Your report has been submitted to our staff team, We will review it and take the necessary actions",
	MotivoReport = "Enter the reason for the report here",
	ReportErro = "Report Error",
	ReportErro1 = "For security reasons, you must have a valid Premium key to submit reports",
	ReportErro2 = "The reported message could not be found, Are you attempting to submit a false report?",
	ReportErro3 = "An error occurred while processing the report, Please try again",
	ReportErro4 = "You can only submit new reports every 2 minutes",
	ReportErro5 = "Are you seriously trying to report yourself?",
	ReportErro6 = "You have already reported this message",
	ReportErro7 = "This message has already been reported by another user",
	ReportErro8 = "You are banned and cannot submit reports",
	ReportErro10 = "Write a reason in your report!",
	ReportErro11 = "The reason must be a minimum of 10 characters and a maximum of 200 characters",
	Aviso = "Warning",
	FecharAviso = "Close warn",
	MsgMod = "Message from the moderator:",
	Tutorial = "The link has been copied successfully — Paste it into your browser for instructions on how to resolve download errors",
	Tentando = "Trying Again",
	TentandoTexto = "We will try downloading again",
	GCmudo = "Global Chat muted",
	GCmudoTexto = "New messages will not be notified via the floating button",
	GCunmudo = "Global Chat unmuted",
	GCunmudoTexto = "You will be notified of each new message",
	MidiaErro = "Error loading media",
	MidiaErroMsg = "Could not load: Unsupported executor or corrupted file",
}

pcall(function()
	if str == "en-us" or not Traducao then
		return
	end
	local str6 = str:sub(1, 2)
	local tbl12 = {}
	local tbl13 = {}
	local n4 = 0

	for k, v17 in pairs(Traducao) do
		n4 += 1
		tbl12[n4] = k
		tbl13[n4] = v17
	end

	local str7 = table.concat(tbl13, " || ")

	local ok3, result3 = pcall(function()
		return game:HttpGet("https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" .. str6 .. "&dt=t&q=" .. HttpService:UrlEncode(str7))
	end)

	if ok3 and result3 then
		local data2 = HttpService:JSONDecode(result3)
		local v17 = data2 and data2[1]
		local str8 = ""

		if v17 then
			for _, v18 in ipairs(data2[1]) do
				str8 ..= v18[1] or ""
			end
		end

		local parts = str8:split("||")

		for i = 1, n4 do
			local v18 = parts[i]

			if v18 then
				Traducao[tbl12[i]] = v18:match("^%s*(.-)%s*$")
			end
		end
	end
end)

TraduzirMsg = function(arg)
	local str6 = (str or "en"):sub(1, 2)

	local ok3, result3 = pcall(function()
		local response = game:HttpGet("https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" .. str6 .. "&dt=t&q=" .. HttpService:UrlEncode(arg))
		local data2 = HttpService:JSONDecode(response)

		if data2 and data2[1] then
			if data2[2] == str6 then
				return arg
			end
			local tbl12 = {}

			for _, v17 in ipairs(data2[1]) do
				table.insert(tbl12, v17[1] or "")
			end

			return table.concat(tbl12):match("^%s*(.-)%s*$")
		end

		return arg
	end)

	arg = ok3 and result3 or arg
	return arg
end

local sound = Instance.new("Sound")
sound.Looped = false
sound.Parent = v7

local function fn2(arg)
	-- Sonidos de la interfaz (clics, avisos, minimizar) desactivados
end

local function fn3(text2, text3, arg, arg2)
	if text2 == "Premium Key" or (Traducao and (text2 == Traducao.OpcaoBloqueadaTitle or text2 == Traducao.ErroCrackTitle)) then
		return
	end
	if Traducao and (text2 == Traducao.Mutado or text2 == Traducao.Desmutado or text2 == Traducao.PlayMode or text2 == Traducao.Aguarde) then
		return
	end
	if type(text2) ~= "string" then
		local v17 = tostring
		text2 = text2 or ""
		text2 = v17(text2)
	end

	if type(text3) ~= "string" then
		local v17 = tostring
		text3 = text3 or ""
		text3 = v17(text3)
	end

	if type(arg) ~= "number" then
		arg = 3
	end

	n2 += 1
	local v17 = n2
	fn2(arg2 ~= nil and type(arg2) == "number" and tostring(arg2) or "129485210015224")
	local notifGui = v4.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("NotifGui")

	if not notifGui then
		notifGui = Instance.new("ScreenGui")
		notifGui.Name = "NotifGui"
		notifGui.ResetOnSpawn = false
		notifGui.Parent = v
	end

	if v10 and v10.Parent then
		v10:Destroy()
		v10 = nil
	end

	local imageButton = Instance.new("ImageButton")
	imageButton.Size = UDim2.new(0, 0, 0, 0)
	imageButton.Position = UDim2.new(0, 8, 0, 8)
	imageButton.AnchorPoint = Vector2.new(0, 0)
	imageButton.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
	imageButton.BackgroundTransparency = 0.08
	imageButton.BorderSizePixel = 0
	imageButton.AutomaticSize = Enum.AutomaticSize.Y
	imageButton.ClipsDescendants = true
	imageButton.Parent = notifGui
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = imageButton
	local uiPad = Instance.new("UIPadding")
	uiPad.PaddingBottom = UDim.new(0, 6)
	uiPad.Parent = imageButton
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Thickness = 0
	uiStroke.Parent = imageButton
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -10, 0, 18)
	textLabel.Position = UDim2.new(0, 5, 0, 5)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text2
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = false
	textLabel.TextSize = 17
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.Parent = imageButton
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -10, 0, -2)
	textLabel2.Position = UDim2.new(0, 5, 0, 24)
	textLabel2.BackgroundTransparency = 1
	textLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
	textLabel2.Font = Enum.Font.SourceSans
	textLabel2.Size = UDim2.new(1, -10, 0, 0)
	textLabel2.AutomaticSize = Enum.AutomaticSize.Y
	textLabel2.TextWrapped = true
	textLabel2.TextSize = 14
	textLabel2.Text = ""
	textLabel2.TextXAlignment = Enum.TextXAlignment.Left
	textLabel2.TextYAlignment = Enum.TextYAlignment.Center
	textLabel2.Parent = imageButton
	v10 = imageButton
	local tween4 = v6:Create(imageButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 250, 0, 46) })
	imageButton.Size = UDim2.new(0, 0, 0, 46)
	tween4:Play()
	task.wait(0.1)
	uiStroke.Thickness = 1.5
	textLabel2.Text = text3
	local flag19 = false

	local function fn4()
		if flag19 then
			return
		end
		flag19 = true
		if not imageButton or not imageButton.Parent then
			return
		end
		textLabel.Text = ""
		textLabel2.Text = ""
		local uiStroke2 = imageButton:FindFirstChildOfClass("UIStroke")

		if uiStroke2 then
			uiStroke2:Destroy()
		end

		local tween5 = v6:Create(imageButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, imageButton.Size.Y.Offset) })
		tween5:Play()

		tween5.Completed:Connect(function()
			if not imageButton.Parent then
				return
			end
			local tween6 = v6:Create(imageButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, 0) })
			tween6:Play()

			tween6.Completed:Connect(function()
				if imageButton then
					imageButton:Destroy()
				end

				if v10 == imageButton then
					v10 = nil
				end
			end)
		end)
	end

	imageButton.MouseButton1Click:Connect(fn4)

	task.delay(arg, function()
		if v17 ~= n2 then
			return
		end
		fn4()
	end)
end

for _, v17 in ipairs({
	"writefile",
	"readfile",
	"isfile",
	"delfile",
	"listfiles",
	"makefolder",
	"isfolder",
	"delfolder",
	"getcustomasset",
}) do
	if type(_G[v17] or getgenv()[v17]) ~= "function" then
		fn3(Traducao.Erro, Traducao.Imcompativel, 15)
		Carregar()
		getgenv().YMP = false
		return
	end
end

if not requestAsync then
	fn3(Traducao.Erro, Traducao.Imcompativel, 15)
	Carregar()
	getgenv().YMP = false
	return
end

if not isfolder("YouTube Music Player") then
	makefolder("YouTube Music Player")
end

if not isfolder("YouTube Music Player/Musics") then
	makefolder("YouTube Music Player/Musics")
end

if not isfolder("YouTube Music Player/Videos") then
	makefolder("YouTube Music Player/Videos")
end

if not isfolder("YouTube Music Player/Roblox IDS") then
	makefolder("YouTube Music Player/Roblox IDS")
end

if not isfolder("YouTube Music Player/Local Audios") then
	makefolder("YouTube Music Player/Local Audios")
end

if not isfolder("YouTube Music Player/Internal") then
	makefolder("YouTube Music Player/Internal")
end

if not isfolder("YouTube Music Player/Internal/Cache") then
	makefolder("YouTube Music Player/Internal/Cache")
end

if isfolder("YouTube Music Player/Cache") then
	delfolder("YouTube Music Player/Cache")
end

if not isfile("YouTube Music Player/Internal/Data.json") then
	writefile("YouTube Music Player/Internal/Data.json", "[{\"Key\":\"\",\"Favorites\":[]}]")
end

if not isfile("YouTube Music Player/[ IMPORTANT ] README.txt") then
	writefile("YouTube Music Player/[ IMPORTANT ] README.txt", [[[ YouTube Music Player ]

This script was developed by @Termux_404
I am deeply grateful for using my script! :D

[>] If you want to add audio files without downloading them using the script's search and download engine, place the MP3 file in the folder "Local Audios"
Make sure the file is not corrupted or too large, otherwise the audio will not play.

[ Social media ]

Discord server: https://discord.gg/kbh2dEdnYP

YouTube channel: https://youtube.com/@termux_404

Scriptblox: https://scriptblox.com/u/Termux_404

Have a good game and enjoy!]])
end

if not isfile("YouTube Music Player/Internal/Cache/ABOUT CACHE.txt") then
	writefile("YouTube Music Player/Internal/Cache/ABOUT CACHE.txt", [[[YouTube Music Player Cache]

This folder is used to temporarily store images to help things load faster.

All files here will be cleared the first time you execute the script.

You can ignore everything here without any problem! :D]])
end

if isfile("YouTube Music Player/[YMP] README.txt") then
	delfile("YouTube Music Player/[YMP] README.txt")
end

for _, v17 in ipairs(listfiles("YouTube Music Player/Internal/Cache")) do
	if not string.find(v17, "ABOUT CACHE.txt") then
		delfile(v17)
	end
end

if isfile("YouTube Music Player/Musics/TAn5b0_j64s.mp3") then
	delfile("YouTube Music Player/Musics/TAn5b0_j64s.mp3")
end

-- Cancion predeterminada de bienvenida eliminada: ya no se descarga y se borra si existe
pcall(function()
	if isfile("YouTube Music Player/Musics/LvvrO6JifEA.mp3") then
		delfile("YouTube Music Player/Musics/LvvrO6JifEA.mp3")
	end
end)

Corner = function(parent, arg, arg2)
	local uiCorner = Instance.new("UICorner")

	if arg2 == nil then
		uiCorner.CornerRadius = UDim.new(0, arg)
	else
		uiCorner.CornerRadius = UDim.new(arg, arg2)
	end

	uiCorner.Parent = parent
end

Stroke = function(parent, arg, arg2, arg3, thickness, transparency)
	local uiStroke = parent:FindFirstChildOfClass("UIStroke")

	if not uiStroke then
		uiStroke = Instance.new("UIStroke")
		uiStroke.Parent = parent
	end

	uiStroke.Color = Color3.fromRGB(arg, arg2, arg3)
	uiStroke.Thickness = thickness

	if transparency ~= nil then
		uiStroke.Transparency = transparency
	end
end

Draggable = function(arg, arg2)
	if not arg or not arg:IsA("GuiObject") then
		return
	end
	local flag19 = false
	local v17 = nil
	local position = nil
	local position2 = nil
	local n4 = 2
	arg:SetAttribute("Blocked", false)
	arg:SetAttribute("Moved", false)

	local function fn4(arg3)
		local n5 = arg3.Position - position

		if not arg:GetAttribute("Moved") and n5.Magnitude > n4 then
			arg:SetAttribute("Moved", true)
		end

		local n6 = position2.X.Offset + n5.X
		local n7 = position2.Y.Offset + n5.Y

		if arg2 then
			local screenGui3 = arg:FindFirstAncestorWhichIsA("ScreenGui")

			if screenGui3 then
				local absoluteSize = screenGui3.AbsoluteSize
				local absoluteSize2 = arg.AbsoluteSize
				local anchorPoint = arg.AnchorPoint
				local uiStroke = arg:FindFirstChildWhichIsA("UIStroke")
				local enabled = uiStroke and uiStroke.Enabled
				local n8 = 0

				if enabled then
					n8 = uiStroke.Thickness
				end

				local n9 = -position2.Y.Scale * absoluteSize.Y + anchorPoint.Y * absoluteSize2.Y + n8
				local n10 = (1 - position2.Y.Scale) * absoluteSize.Y - (1 - anchorPoint.Y) * absoluteSize2.Y - n8
				n6 = math.clamp(n6, -position2.X.Scale * absoluteSize.X + anchorPoint.X * absoluteSize2.X + n8, (1 - position2.X.Scale) * absoluteSize.X - (1 - anchorPoint.X) * absoluteSize2.X - n8)
				n7 = math.clamp(n7, n9, n10)
			end
		end

		arg.Position = UDim2.new(position2.X.Scale, n6, position2.Y.Scale, n7)
	end

	arg.InputBegan:Connect(function(input)
		if flag19 then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag19 = true
			v17 = input
			position = input.Position
			position2 = arg.Position
			arg:SetAttribute("Blocked", true)
			arg:SetAttribute("Moved", false)
			local connection = nil

			connection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag19 = false
					v17 = nil
					arg:SetAttribute("Blocked", false)
					connection:Disconnect()
				end
			end)
		end
	end)

	arg.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if not v17 then
				v17 = input
			end
		end
	end)

	v9.InputChanged:Connect(function(input)
		if flag19 and input == v17 then
			fn4(input)
		end
	end)
end

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Size = UDim2.new(0, 587, 0, 360)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Active = true
frame.Visible = false
frame.Parent = screenGui
local imageButton = Instance.new("ImageButton")
imageButton.Size = UDim2.new(0, 250, 0, 60)
imageButton.AnchorPoint = Vector2.new(0.5, 0)
imageButton.Position = UDim2.new(0.5, 0, 0, 20)
imageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
imageButton.Image = ""
imageButton.AutoButtonColor = false
imageButton.Visible = false
imageButton.Parent = screenGui
ContadorJA = Instance.new("Frame")
ContadorJA.Size = UDim2.new(0, 17, 0, 17)
ContadorJA.Position = UDim2.new(1, -12, 0, -5)
ContadorJA.BackgroundColor3 = Color3.fromRGB(250, 92, 92)
ContadorJA.Visible = false
ContadorJA.Parent = imageButton
ContadorJANU = Instance.new("TextLabel")
ContadorJANU.Size = UDim2.new(0, 15, 0, 15)
ContadorJANU.Position = UDim2.new(0, 1, 0, 1)
ContadorJANU.BackgroundTransparency = 1
ContadorJANU.Text = "0"
ContadorJANU.TextColor3 = Color3.fromRGB(0, 0, 0)
ContadorJANU.TextScaled = true
ContadorJANU.Parent = ContadorJA
Draggable(imageButton, true)
Draggable(frame)
-- Franja superior en negro intenso (solo el fondo vacio; botones y textos quedan encima)
do
	frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	local grad = Instance.new("UIGradient")
	grad.Name = "FondoTopNegro"
	grad.Rotation = 90
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(48 / 360, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(48 / 360 + 0.0005, Color3.fromRGB(16, 8, 10)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 8, 10))
	})
	grad.Parent = frame
end
Mutar = Instance.new("ImageButton")
Mutar.Size = UDim2.new(0, 30, 0, 30)
Mutar.Position = UDim2.new(0, 6, 0, 6)
Mutar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Mutar.Image = "rbxassetid://109518972658686"
Mutar.Visible = false
Mutar.Parent = frame
BotaoFechar = Instance.new("ImageButton")
BotaoFechar.Size = UDim2.new(0, 30, 0, 30)
BotaoFechar.Position = UDim2.new(1, -36, 0, 6)
BotaoFechar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
BotaoFechar.BackgroundTransparency = 1
BotaoFechar.BorderSizePixel = 0
BotaoFechar.Parent = frame
X = Instance.new("ImageLabel")
X.AnchorPoint = Vector2.new(0.5, 0.5)
X.Size = UDim2.new(0, 17, 0, 17)
X.Position = UDim2.new(0.5, 0, 0.5, 0)
X.BackgroundTransparency = 1
X.Image = ""
X.Parent = BotaoFechar
local guion = Instance.new("Frame")
guion.AnchorPoint = Vector2.new(0.5, 0.5)
guion.Size = UDim2.new(0, 16, 0, 4)
guion.Position = UDim2.new(0.5, 0, 0.5, 0)
guion.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
guion.BorderSizePixel = 0
guion.Parent = BotaoFechar
Titulo = Instance.new("Frame")
Titulo.Size = UDim2.new(0, 496, 0, 30)
Titulo.Position = UDim2.new(0, 42, 0, 6)
Titulo.BackgroundColor3 = Color3.fromRGB(40, 14, 18)
Titulo.BackgroundTransparency = 0
Titulo.BorderSizePixel = 0
Titulo.Parent = frame
LogoCirculo = Instance.new("Frame")
LogoCirculo.Name = "LogoCirculo"
LogoCirculo.Size = UDim2.new(0, 26, 0, 26)
LogoCirculo.Position = UDim2.new(0, 4, 0.5, -13)
LogoCirculo.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
LogoCirculo.BorderSizePixel = 0
LogoCirculo.Parent = Titulo
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = LogoCirculo
LogoPlay = Instance.new("TextLabel")
LogoPlay.Name = "LogoPlay"
LogoPlay.AnchorPoint = Vector2.new(0.5, 0.5)
LogoPlay.Size = UDim2.new(0, 18, 0, 18)
LogoPlay.Position = UDim2.new(0.5, 1, 0.5, 0)
LogoPlay.BackgroundTransparency = 1
LogoPlay.Text = "\u{25B6}"
LogoPlay.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoPlay.TextScaled = true
LogoPlay.Font = Enum.Font.GothamBold
LogoPlay.Parent = LogoCirculo
TextoTitulo = Instance.new("TextLabel")
TextoTitulo.Size = UDim2.new(1, -40, 1, -4)
TextoTitulo.Position = UDim2.new(0, 36, 0, 2)
TextoTitulo.BackgroundTransparency = 1
TextoTitulo.Text = "Music"
TextoTitulo.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoTitulo.TextScaled = false
TextoTitulo.TextSize = 20
TextoTitulo.Font = Enum.Font.GothamBold
TextoTitulo.TextXAlignment = Enum.TextXAlignment.Left
TextoTitulo.TextYAlignment = Enum.TextYAlignment.Center
TextoTitulo.Parent = Titulo
LogoCirculo.Visible = false
TextoTitulo.Visible = false
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 5)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Linha.BorderSizePixel = 0
Linha.Parent = frame
Navegacao = Instance.new("Frame")
Navegacao.Size = UDim2.new(0, 160, 0, 76)
Navegacao.Position = UDim2.new(0, 7, 0, 54)
Navegacao.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Navegacao.BorderSizePixel = 0
Navegacao.Visible = true
Navegacao.ClipsDescendants = true
Navegacao.Parent = frame
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(0, 158, 0, 64)
BaseSF.Position = UDim2.new(0, 1, 0, 6)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Parent = Navegacao
ScrollNave = Instance.new("ScrollingFrame")
ScrollNave.Size = UDim2.new(1, 0, 1, 0)
ScrollNave.Position = UDim2.new(0, 0, 0, 0)
ScrollNave.BackgroundTransparency = 1
ScrollNave.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollNave.ScrollBarImageTransparency = 0.5
ScrollNave.BorderSizePixel = 0
ScrollNave.ScrollBarThickness = 1
ScrollNave.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollNave.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollNave.ClipsDescendants = false
ScrollNave.Parent = BaseSF
Botao3 = Instance.new("ImageButton")
Botao3.Name = "Botao3"
Botao3.Size = UDim2.new(0, 124, 0, 22)
Botao3.Position = UDim2.new(0, 17, 0, 5)
Botao3.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Botao3.AutoButtonColor = false
Botao3.Parent = ScrollNave
Botao4 = Instance.new("ImageButton")
Botao4.Name = "Botao4"
Botao4.Size = UDim2.new(0, 124, 0, 22)
Botao4.Position = UDim2.new(0, 17, 0, 33)
Botao4.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Botao4.AutoButtonColor = false
Botao4.Parent = ScrollNave
Icone3 = Instance.new("ImageLabel")
Icone3.Size = UDim2.new(0, 20, 0, 20)
Icone3.Position = UDim2.new(0, 1, 0, 1)
Icone3.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Icone3.Image = "rbxassetid://116645068635461"
Icone3.Parent = Botao3
Icone4 = Instance.new("ImageLabel")
Icone4.Size = UDim2.new(0, 20, 0, 20)
Icone4.Position = UDim2.new(0, 1, 0, 1)
Icone4.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Icone4.Image = "rbxassetid://71048917954785"
Icone4.Parent = Botao4
Nome3 = Instance.new("TextLabel")
Nome3.Size = UDim2.new(0, 90, 1, 0)
Nome3.Position = UDim2.new(0, 25, 0, 0)
Nome3.BackgroundTransparency = 1
Nome3.Text = Traducao.Equalizador
Nome3.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome3.Font = Enum.Font.SourceSansBold
Nome3.TextScaled = true
Nome3.Parent = Botao3
Nome4 = Instance.new("TextLabel")
Nome4.Size = UDim2.new(0, 90, 1, 0)
Nome4.Position = UDim2.new(0, 25, 0, 0)
Nome4.BackgroundTransparency = 1
Nome4.Text = Traducao.Add
Nome4.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome4.Font = Enum.Font.SourceSansBold
Nome4.TextScaled = true
Nome4.Parent = Botao4
Playlist = Instance.new("Frame")
Playlist.Size = UDim2.new(0, 160, 0, 239)
Playlist.Position = UDim2.new(0, 420, 0, 54)
Playlist.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Playlist.BorderSizePixel = 0
Playlist.Visible = false
Playlist.Parent = frame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
Linha.BorderSizePixel = 0
Linha.Parent = Playlist
Linha2 = Instance.new("Frame")
Linha2.Size = UDim2.new(1, 0, 0, 2)
Linha2.Position = UDim2.new(0, 0, 0, 195)
Linha2.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
Linha2.BorderSizePixel = 0
Linha2.Parent = Playlist
TituloPlayL = Instance.new("Frame")
TituloPlayL.Size = UDim2.new(0, 150, 0, 32)
TituloPlayL.Position = UDim2.new(0, 5, 0, 5)
TituloPlayL.BackgroundColor3 = Color3.fromRGB(185, 34, 34)
TituloPlayL.Parent = Playlist
FotoPlayL = Instance.new("ImageLabel")
FotoPlayL.Size = UDim2.new(0, 32, 0, 32)
FotoPlayL.Position = UDim2.new(0, 0, 0, 0)
FotoPlayL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FotoPlayL.BackgroundTransparency = 0.5
FotoPlayL.Image = "rbxassetid://96966806844504"
FotoPlayL.Parent = TituloPlayL
NomePlayL = Instance.new("TextLabel")
NomePlayL.Size = UDim2.new(0, 102, 1, 0)
NomePlayL.Position = UDim2.new(0, 37, 0, 0)
NomePlayL.BackgroundTransparency = 1
NomePlayL.Text = "Playlist"
NomePlayL.TextColor3 = Color3.fromRGB(255, 0, 0)
NomePlayL.Font = Enum.Font.SourceSansBold
NomePlayL.TextScaled = true
NomePlayL.Parent = TituloPlayL
EsquerdaPL = Instance.new("ImageButton")
EsquerdaPL.Size = UDim2.new(0, 32, 0, 32)
EsquerdaPL.Position = UDim2.new(0, 6, 0, 202)
EsquerdaPL.BackgroundColor3 = Color3.fromRGB(237, 76, 66)
EsquerdaPL.Image = "rbxassetid://121046797518772"
EsquerdaPL.Parent = Playlist
DireitaPL = Instance.new("ImageButton")
DireitaPL.Size = UDim2.new(0, 32, 0, 32)
DireitaPL.Position = UDim2.new(0, 122, 0, 202)
DireitaPL.BackgroundColor3 = Color3.fromRGB(237, 76, 66)
DireitaPL.Image = "rbxassetid://132437763424488"
DireitaPL.Parent = Playlist
Vazio = Instance.new("ImageLabel")
Vazio.Size = UDim2.new(0, 70, 0, 70)
Vazio.Position = UDim2.new(0, 45, 0, 63)
Vazio.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Vazio.BackgroundTransparency = 1
Vazio.Image = "rbxassetid://123712679435265"
Vazio.Visible = false
Vazio.Parent = Playlist
VazioLocal = Instance.new("ImageLabel")
VazioLocal.Size = UDim2.new(0, 70, 0, 70)
VazioLocal.Position = UDim2.new(0, 45, 0, 63)
VazioLocal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
VazioLocal.BackgroundTransparency = 1
VazioLocal.Image = "rbxassetid://103453753684654"
VazioLocal.Visible = false
VazioLocal.Parent = Playlist
AguardandoPL = Instance.new("ImageLabel")
AguardandoPL.Size = UDim2.new(0, 70, 0, 70)
AguardandoPL.Position = UDim2.new(0, 45, 0, 63)
AguardandoPL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AguardandoPL.BackgroundTransparency = 1
AguardandoPL.Image = "rbxassetid://128559285276409"
AguardandoPL.Visible = false
AguardandoPL.Parent = Playlist
SemResultadoPL = Instance.new("ImageLabel")
SemResultadoPL.Size = UDim2.new(0, 70, 0, 70)
SemResultadoPL.Position = UDim2.new(0, 45, 0, 63)
SemResultadoPL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SemResultadoPL.BackgroundTransparency = 1
SemResultadoPL.Image = "rbxassetid://109542040841239"
SemResultadoPL.Visible = false
SemResultadoPL.Parent = Playlist
ErroPL = Instance.new("TextLabel")
ErroPL.Size = UDim2.new(0, 150, 0, 42)
ErroPL.Position = UDim2.new(0, 5, 0, 149)
ErroPL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ErroPL.BackgroundTransparency = 0.5
ErroPL.RichText = true
ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Vazio .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.VazioTexto .. "</font>"
ErroPL.Font = Enum.Font.SourceSansBold
ErroPL.TextScaled = true
ErroPL.Visible = false
ErroPL.Parent = Playlist
FrameAbaPL = Instance.new("Frame")
FrameAbaPL.Size = UDim2.new(0, 70, 0, 32)
FrameAbaPL.Position = UDim2.new(0, 45, 0, 202)
FrameAbaPL.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
FrameAbaPL.BackgroundTransparency = 0.5
FrameAbaPL.Parent = Playlist
AbaPL = Instance.new("TextLabel")
AbaPL.Size = UDim2.new(1, -6, 1, -6)
AbaPL.Position = UDim2.new(0, 3, 0, 3)
AbaPL.BackgroundTransparency = 1
AbaPL.Text = Traducao.Todos
AbaPL.TextColor3 = Color3.fromRGB(255, 0, 0)
AbaPL.Font = Enum.Font.SourceSansBold
AbaPL.TextScaled = true
AbaPL.Visible = true
AbaPL.Parent = FrameAbaPL
PesquisaPL = Instance.new("TextBox")
PesquisaPL.Size = UDim2.new(1, -6, 1, -6)
PesquisaPL.Position = UDim2.new(0, 3, 0, 3)
PesquisaPL.BackgroundTransparency = 1
PesquisaPL.Text = ""
PesquisaPL.PlaceholderText = Traducao.Search
PesquisaPL.TextColor3 = Color3.fromRGB(255, 255, 255)
PesquisaPL.Font = Enum.Font.SourceSansBold
PesquisaPL.TextScaled = true
PesquisaPL.TextWrapped = true
PesquisaPL.Visible = false
PesquisaPL.Parent = FrameAbaPL
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(0, 158, 0, 149)
BaseSF.Position = UDim2.new(0, 1, 0, 45)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Parent = Playlist
ScrollTodos = Instance.new("ScrollingFrame")
ScrollTodos.Name = "ScrollTodos"
ScrollTodos.Size = UDim2.new(1, 0, 1, 0)
ScrollTodos.Position = UDim2.new(0, 0, 0, 0)
ScrollTodos.BackgroundTransparency = 1
ScrollTodos.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollTodos.ScrollBarImageTransparency = 0.5
ScrollTodos.BorderSizePixel = 0
ScrollTodos.ScrollBarThickness = 1
ScrollTodos.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollTodos.CanvasPosition = Vector2.new(0, 0)
ScrollTodos.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollTodos.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollTodos.Visible = true
ScrollTodos.Parent = BaseSF
ScrollMusicas = Instance.new("ScrollingFrame")
ScrollMusicas.Name = "ScrollMusicas"
ScrollMusicas.Size = UDim2.new(1, 0, 1, 0)
ScrollMusicas.Position = UDim2.new(0, 0, 0, 0)
ScrollMusicas.BackgroundTransparency = 1
ScrollMusicas.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollMusicas.ScrollBarImageTransparency = 0.5
ScrollMusicas.BorderSizePixel = 0
ScrollMusicas.ScrollBarThickness = 1
ScrollMusicas.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollMusicas.CanvasPosition = Vector2.new(0, 0)
ScrollMusicas.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollMusicas.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollMusicas.Visible = false
ScrollMusicas.Parent = BaseSF
ScrollVideos = Instance.new("ScrollingFrame")
ScrollVideos.Name = "ScrollVideos"
ScrollVideos.Size = UDim2.new(1, 0, 1, 0)
ScrollVideos.Position = UDim2.new(0, 0, 0, 0)
ScrollVideos.BackgroundTransparency = 1
ScrollVideos.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollVideos.ScrollBarImageTransparency = 0.5
ScrollVideos.BorderSizePixel = 0
ScrollVideos.ScrollBarThickness = 1
ScrollVideos.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollVideos.CanvasPosition = Vector2.new(0, 0)
ScrollVideos.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollVideos.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollVideos.Visible = false
ScrollVideos.Parent = BaseSF
ScrollRoblox = Instance.new("ScrollingFrame")
ScrollRoblox.Name = "ScrollRoblox"
ScrollRoblox.Size = UDim2.new(1, 0, 1, 0)
ScrollRoblox.Position = UDim2.new(0, 0, 0, 0)
ScrollRoblox.BackgroundTransparency = 1
ScrollRoblox.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollRoblox.ScrollBarImageTransparency = 0.5
ScrollRoblox.BorderSizePixel = 0
ScrollRoblox.ScrollBarThickness = 1
ScrollRoblox.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollRoblox.CanvasPosition = Vector2.new(0, 0)
ScrollRoblox.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollRoblox.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollRoblox.Visible = false
ScrollRoblox.Parent = BaseSF
ScrollFav = Instance.new("ScrollingFrame")
ScrollFav.Name = "ScrollFav"
ScrollFav.Size = UDim2.new(1, 0, 1, 0)
ScrollFav.Position = UDim2.new(0, 0, 0, 0)
ScrollFav.BackgroundTransparency = 1
ScrollFav.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollFav.ScrollBarImageTransparency = 0.5
ScrollFav.BorderSizePixel = 0
ScrollFav.ScrollBarThickness = 1
ScrollFav.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollFav.CanvasPosition = Vector2.new(0, 0)
ScrollFav.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollFav.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollFav.Visible = false
ScrollFav.Parent = BaseSF
ScrollLocal = Instance.new("ScrollingFrame")
ScrollLocal.Name = "ScrollLocal"
ScrollLocal.Size = UDim2.new(1, 0, 1, 0)
ScrollLocal.Position = UDim2.new(0, 0, 0, 0)
ScrollLocal.BackgroundTransparency = 1
ScrollLocal.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollLocal.ScrollBarImageTransparency = 0.5
ScrollLocal.BorderSizePixel = 0
ScrollLocal.ScrollBarThickness = 1
ScrollLocal.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollLocal.CanvasPosition = Vector2.new(0, 0)
ScrollLocal.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollLocal.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollLocal.Visible = false
ScrollLocal.Parent = BaseSF
ScrollPesquisa = Instance.new("ScrollingFrame")
ScrollPesquisa.Name = "ScrollPesquisa"
ScrollPesquisa.Size = UDim2.new(1, 0, 1, 0)
ScrollPesquisa.Position = UDim2.new(0, 0, 0, 0)
ScrollPesquisa.BackgroundTransparency = 1
ScrollPesquisa.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollPesquisa.ScrollBarImageTransparency = 0.5
ScrollPesquisa.BorderSizePixel = 0
ScrollPesquisa.ScrollBarThickness = 1
ScrollPesquisa.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollPesquisa.CanvasPosition = Vector2.new(0, 0)
ScrollPesquisa.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollPesquisa.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollPesquisa.Visible = false
ScrollPesquisa.Parent = BaseSF
Tela1 = Instance.new("Frame")
Tela1.Size = UDim2.new(0, 573, 0, 251)
Tela1.Position = UDim2.new(0, 7, 0, 48)
Tela1.BackgroundTransparency = 1
Tela1.BorderSizePixel = 0
Tela1.Visible = true
Tela1.Parent = frame
Tela2 = Instance.new("Frame")
Tela2.Size = UDim2.new(0, 247, 0, 251)
Tela2.Position = UDim2.new(0, 170, 0, 48)
Tela2.BackgroundTransparency = 1
Tela2.BorderSizePixel = 0
Tela2.Visible = false
Tela2.Parent = frame
Tela3 = Instance.new("Frame")
Tela3.Size = UDim2.new(0, 247, 0, 251)
Tela3.Position = UDim2.new(0, 170, 0, 48)
Tela3.BackgroundTransparency = 1
Tela3.BorderSizePixel = 0
Tela3.Visible = false
Tela3.Parent = frame
Tela4 = Instance.new("Frame")
Tela4.Size = UDim2.new(0, 247, 0, 251)
Tela4.Position = UDim2.new(0, 170, 0, 48)
Tela4.BackgroundTransparency = 1
Tela4.BorderSizePixel = 0
Tela4.Visible = false
Tela4.Parent = frame
Tela5 = Instance.new("Frame")
Tela5.Size = UDim2.new(0, 247, 0, 251)
Tela5.Position = UDim2.new(0, 170, 0, 48)
Tela5.BackgroundTransparency = 1
Tela5.BorderSizePixel = 0
Tela5.Visible = false
Tela5.Parent = frame
Tela6 = Instance.new("Frame")
Tela6.Size = UDim2.new(0, 247, 0, 251)
Tela6.Position = UDim2.new(0, 170, 0, 48)
Tela6.BackgroundTransparency = 1
Tela6.BorderSizePixel = 0
Tela6.Visible = false
Tela6.Parent = frame
Welcome = Instance.new("Frame")
Welcome.Size = UDim2.new(0, 235, 0, 43)
Welcome.Position = UDim2.new(0, 6, 0, 6)
Welcome.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Welcome.BorderSizePixel = 0
Welcome.Visible = false
Welcome.Parent = Tela1
HomeBox = Instance.new("TextBox")
HomeBox.Size = UDim2.new(1, -196, 1, -6)
HomeBox.Position = UDim2.new(0, 14, 0, 3)
HomeBox.Text = ""
HomeBox.PlaceholderText = "What do you want to play?"
HomeBox.TextScaled = false
HomeBox.TextSize = 15
HomeBox.TextWrapped = false
HomeBox.ClipsDescendants = true
HomeBox.ClearTextOnFocus = false
HomeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeBox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
HomeBox.Font = Enum.Font.Gotham
HomeBox.TextXAlignment = Enum.TextXAlignment.Left
HomeBox.BackgroundTransparency = 1
HomeBox.Parent = Titulo
RefreshHome = Instance.new("ImageButton")
RefreshHome.Name = "RefreshHome"
RefreshHome.Size = UDim2.new(0, 24, 0, 24)
RefreshHome.Position = UDim2.new(1, -30, 0.5, -12)
RefreshHome.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
RefreshHome.AutoButtonColor = true
RefreshHome.Image = "rbxassetid://130610275359163"
RefreshHome.Parent = Titulo

HomeTopo = Instance.new("ImageButton")
HomeTopo.Name = "HomeTopo"
HomeTopo.Size = UDim2.new(0, 30, 0, 30)
HomeTopo.Position = UDim2.new(0, 6, 0, 6)
HomeTopo.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
HomeTopo.BorderSizePixel = 0
HomeTopo.Image = "rbxassetid://107770126918811"
HomeTopo.Parent = frame
Corner(HomeTopo, 15)
ScrollHome = Instance.new("ScrollingFrame")
ScrollHome.Name = "ScrollHome"
ScrollHome.Size = UDim2.new(0, 565, 0, 203)
ScrollHome.Position = UDim2.new(0, 4, 0, 44)
ScrollHome.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScrollHome.BackgroundTransparency = 1
ScrollHome.BorderSizePixel = 0
ScrollHome.ScrollBarThickness = 4
ScrollHome.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollHome.ScrollBarImageTransparency = 0.5
ScrollHome.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollHome.CanvasPosition = Vector2.new(0, 0)
ScrollHome.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollHome.ClipsDescendants = true
ScrollHome.Parent = Tela1
HomeInfo = Instance.new("TextLabel")
HomeInfo.Name = "HomeInfo"
HomeInfo.AnchorPoint = Vector2.new(0.5, 0.5)
HomeInfo.Size = UDim2.new(1, -10, 0, 40)
HomeInfo.Position = UDim2.new(0.5, 0, 0.5, 0)
HomeInfo.BackgroundTransparency = 1
HomeInfo.RichText = true
HomeInfo.Text = "<font color=\"rgb(255,255,255)\">Cargando...</font>"
HomeInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeInfo.Font = Enum.Font.SourceSansBold
HomeInfo.TextSize = 16
HomeInfo.TextWrapped = true
HomeInfo.Visible = true
HomeInfo.Parent = ScrollHome

ScrollHome2 = Instance.new("ScrollingFrame")
ScrollHome2.Name = "ScrollHome2"
ScrollHome2.Size = UDim2.new(0, 560, 0, 80)
ScrollHome2.Position = UDim2.new(0, 6, 0, 85)
ScrollHome2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScrollHome2.BackgroundTransparency = 1
ScrollHome2.BorderSizePixel = 0
ScrollHome2.ScrollBarThickness = 2
ScrollHome2.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollHome2.ScrollBarImageTransparency = 0.5
ScrollHome2.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollHome2.CanvasPosition = Vector2.new(0, 0)
ScrollHome2.ScrollingDirection = Enum.ScrollingDirection.X
ScrollHome2.ClipsDescendants = true
ScrollHome2.Parent = Tela1
ScrollHome2.Visible = false
ScrollHome3 = Instance.new("ScrollingFrame")
ScrollHome3.Name = "ScrollHome3"
ScrollHome3.Size = UDim2.new(0, 560, 0, 80)
ScrollHome3.Position = UDim2.new(0, 6, 0, 166)
ScrollHome3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScrollHome3.BackgroundTransparency = 1
ScrollHome3.BorderSizePixel = 0
ScrollHome3.ScrollBarThickness = 2
ScrollHome3.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollHome3.ScrollBarImageTransparency = 0.5
ScrollHome3.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollHome3.CanvasPosition = Vector2.new(0, 0)
ScrollHome3.ScrollingDirection = Enum.ScrollingDirection.X
ScrollHome3.ClipsDescendants = true
ScrollHome3.Parent = Tela1
ScrollHome3.Visible = false
Dev = Instance.new("Frame")
Dev.Size = UDim2.new(0, 235, 0, 61)
Dev.Position = UDim2.new(0, 6, 0, 58)
Dev.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Dev.BorderSizePixel = 0
Dev.Visible = false
Dev.Parent = Tela1
FotoDev = Instance.new("ImageLabel")
FotoDev.Size = UDim2.new(0, 47, 0, 46)
FotoDev.Position = UDim2.new(0, 7, 0, 8)
FotoDev.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FotoDev.BackgroundTransparency = 0.5
FotoDev.Image = "rbxassetid://86887253295141"
FotoDev.Parent = Dev
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(0, 2, 1, 0)
Linha.Position = UDim2.new(0, 62, 0, 0)
Linha.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
Linha.BorderSizePixel = 0
Linha.Parent = Dev
TextoDev = Instance.new("TextLabel")
TextoDev.Size = UDim2.new(1, -70, 1, 0)
TextoDev.Position = UDim2.new(0, 66, 0, 0)
TextoDev.BackgroundTransparency = 1
TextoDev.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoDev.Font = Enum.Font.SourceSansBold
TextoDev.TextScaled = true
TextoDev.RichText = true
TextoDev.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Dev .. "</font>\n<font color=\"rgb(178,34,34)\">Termux_404</font>"
TextoDev.Parent = Dev
Social = Instance.new("Frame")
Social.Size = UDim2.new(0, 235, 0, 117)
Social.Position = UDim2.new(0, 6, 0, 128)
Social.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Social.BorderSizePixel = 0
Social.Visible = false
Social.Parent = Tela1
SocialTitulo = Instance.new("Frame")
SocialTitulo.Size = UDim2.new(1, 0, 0, 30)
SocialTitulo.Position = UDim2.new(0, 0, 0, 0)
SocialTitulo.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
SocialTitulo.BorderSizePixel = 0
SocialTitulo.Parent = Social
SocialTexto = Instance.new("TextLabel")
SocialTexto.Size = UDim2.new(1, 0, 1, 0)
SocialTexto.Position = UDim2.new(0, 0, 0, 0)
SocialTexto.BackgroundTransparency = 1
SocialTexto.Text = "Social"
SocialTexto.TextColor3 = Color3.fromRGB(220, 80, 95)
SocialTexto.Font = Enum.Font.SourceSansBold
SocialTexto.TextScaled = true
SocialTexto.Parent = SocialTitulo
Discord = Instance.new("ImageButton")
Discord.Size = UDim2.new(0, 223, 0, 32)
Discord.Position = UDim2.new(0, 6, 0, 40)
Discord.BackgroundColor3 = Color3.fromRGB(143, 42, 234)
Discord.Parent = Social
UIScaleDis = Instance.new("UIScale")
UIScaleDis.Parent = Discord
IconeDiscord = Instance.new("ImageLabel")
IconeDiscord.Size = UDim2.new(0, 32, 0, 32)
IconeDiscord.Position = UDim2.new(0, 0, 0, 0)
IconeDiscord.BackgroundColor3 = Color3.fromRGB(40, 100, 240)
IconeDiscord.Image = "rbxassetid://90602349315916"
IconeDiscord.Parent = Discord
TextoDiscord = Instance.new("TextLabel")
TextoDiscord.Size = UDim2.new(1, -50, 1, 0)
TextoDiscord.Position = UDim2.new(0, 39, 0, 0)
TextoDiscord.BackgroundTransparency = 1
TextoDiscord.Text = "Discord"
TextoDiscord.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoDiscord.Font = Enum.Font.Garamond
TextoDiscord.TextScaled = true
TextoDiscord.Parent = Discord
You = Instance.new("ImageButton")
You.Size = UDim2.new(0, 223, 0, 32)
You.Position = UDim2.new(0, 6, 0, 79)
You.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
You.Parent = Social
UIScaleYou = Instance.new("UIScale")
UIScaleYou.Parent = You
IconeYou = Instance.new("ImageLabel")
IconeYou.Size = UDim2.new(0, 32, 0, 32)
IconeYou.Position = UDim2.new(0, 0, 0, 0)
IconeYou.BackgroundColor3 = Color3.fromRGB(40, 100, 240)
IconeYou.Image = "rbxassetid://111196037573101"
IconeYou.Parent = You
TextoYou = Instance.new("TextLabel")
TextoYou.Size = UDim2.new(1, -50, 1, 0)
TextoYou.Position = UDim2.new(0, 39, 0, 0)
TextoYou.BackgroundTransparency = 1
TextoYou.Text = "YouTube"
TextoYou.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoYou.Font = Enum.Font.Garamond
TextoYou.TextScaled = true
TextoYou.Parent = You
Musica = Instance.new("ImageLabel")
Musica.Size = UDim2.new(0, 235, 0, 120)
Musica.Position = UDim2.new(0, 6, 0, 6)
Musica.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Musica.BorderSizePixel = 0
Musica.Visible = true
Musica.ImageRectOffset = Vector2.new(0, 0)
Musica.ImageRectSize = Vector2.new(0, 0)
Musica.Image = "rbxassetid://120329190202259"
Musica.Parent = Tela2
Video = Instance.new("VideoFrame")
Video.Size = UDim2.new(0, 235, 0, 120)
Video.Position = UDim2.new(0, 6, 0, 6)
Video.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Video.BorderSizePixel = 0
Video.Visible = false
Video.Video = ""
Video.Volume = 1
Video.Looped = false
Video.Parent = nil
BotaoTela = Instance.new("ImageButton")
BotaoTela.Size = UDim2.new(0, 235, 0, 120)
BotaoTela.Position = UDim2.new(0, 6, 0, 6)
BotaoTela.BackgroundTransparency = 1
BotaoTela.ClipsDescendants = true
BotaoTela.Visible = true
BotaoTela.ZIndex = 2
BotaoTela.Parent = Tela2
TempoAtual = Instance.new("Frame")
TempoAtual.Size = UDim2.new(0, 55, 0, 20)
TempoAtual.Position = UDim2.new(0, 6, 0, 6)
TempoAtual.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TempoAtual.BackgroundTransparency = 0.5
TempoAtual.ZIndex = 2
TempoAtual.Parent = BotaoTela
TempoTotal = Instance.new("Frame")
TempoTotal.Size = UDim2.new(0, 55, 0, 20)
TempoTotal.Position = UDim2.new(0, 174, 0, 6)
TempoTotal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TempoTotal.BackgroundTransparency = 0.5
TempoTotal.ZIndex = 2
TempoTotal.Parent = BotaoTela
TimerAtual = Instance.new("TextLabel")
TimerAtual.Size = UDim2.new(1, 0, 1, 0)
TimerAtual.Position = UDim2.new(0, 0, 0, 0)
TimerAtual.BackgroundTransparency = 1
TimerAtual.Text = "00:00"
TimerAtual.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerAtual.TextScaled = true
TimerAtual.Font = Enum.Font.SourceSansBold
TimerAtual.ZIndex = 2
TimerAtual.Parent = TempoAtual
TimerTotal = Instance.new("TextLabel")
TimerTotal.Size = UDim2.new(1, 0, 1, 0)
TimerTotal.Position = UDim2.new(0, 0, 0, 0)
TimerTotal.BackgroundTransparency = 1
TimerTotal.Text = "00:00"
TimerTotal.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerTotal.TextScaled = true
TimerTotal.Font = Enum.Font.SourceSansBold
TimerTotal.ZIndex = 2
TimerTotal.Parent = TempoTotal
Repetir = Instance.new("ImageButton")
Repetir.Size = UDim2.new(0, 30, 0, 30)
Repetir.Position = UDim2.new(0.5, -35, 0.5, -54)
Repetir.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Repetir.BackgroundTransparency = 0.5
Repetir.BorderSizePixel = 0
Repetir.Image = "rbxassetid://72571947341676"
Repetir.ZIndex = 2
Repetir.Parent = BotaoTela
Miniplayer = Instance.new("ImageButton")
Miniplayer.Size = UDim2.new(0, 30, 0, 30)
Miniplayer.Position = UDim2.new(0.5, 5, 0.5, -54)
Miniplayer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Miniplayer.BackgroundTransparency = 0.5
Miniplayer.BorderSizePixel = 0
Miniplayer.Image = "rbxassetid://102723588572082"
Miniplayer.ZIndex = 2
Miniplayer.Parent = BotaoTela
BarraProgresso = Instance.new("ImageButton")
BarraProgresso.Size = UDim2.new(0, 223, 0, 10)
BarraProgresso.Position = UDim2.new(0, 6, 0, 103)
BarraProgresso.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
BarraProgresso.BorderSizePixel = 0
BarraProgresso.AutoButtonColor = false
BarraProgresso.ZIndex = 2
BarraProgresso.Parent = BotaoTela
Rastro = Instance.new("Frame")
Rastro.Size = UDim2.new(0, 0, 1, 0)
Rastro.Position = UDim2.new(0, 0, 0, 0)
Rastro.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Rastro.BorderSizePixel = 0
Rastro.ZIndex = 2
Rastro.Parent = BarraProgresso
BolaProgresso = Instance.new("ImageButton")
BolaProgresso.Size = UDim2.new(0, 16, 0, 16)
BolaProgresso.Position = UDim2.new(0, 0, 0, -3)
BolaProgresso.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
BolaProgresso.BorderSizePixel = 0
BolaProgresso.AnchorPoint = Vector2.new(0, 0)
BolaProgresso.ZIndex = 2
BolaProgresso.Parent = BarraProgresso
MicroBola = Instance.new("Frame")
MicroBola.Size = UDim2.new(0, 6, 0, 6)
MicroBola.Position = UDim2.new(0, 5, 0, 5)
MicroBola.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MicroBola.BorderSizePixel = 0
MicroBola.ZIndex = 2
MicroBola.Parent = BolaProgresso
PlayerInfo = Instance.new("VideoFrame")
PlayerInfo.Size = UDim2.new(0, 235, 0, 61)
PlayerInfo.Position = UDim2.new(0, 6, 0, 135)
PlayerInfo.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
PlayerInfo.BorderSizePixel = 0
PlayerInfo.Parent = Tela2
FotoAutor = Instance.new("ImageLabel")
FotoAutor.Size = UDim2.new(0, 50, 0, 49)
FotoAutor.Position = UDim2.new(0, 6, 0, 6)
FotoAutor.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
FotoAutor.BorderSizePixel = 0
FotoAutor.Visible = true
FotoAutor.Image = "rbxassetid://130243480255582"
FotoAutor.Parent = PlayerInfo
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(0, 2, 1, 0)
Linha.Position = UDim2.new(0, 63, 0, 0)
Linha.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
Linha.BorderSizePixel = 0
Linha.Parent = PlayerInfo
Linhah = Instance.new("Frame")
Linhah.Size = UDim2.new(0, 2, 1, 0)
Linhah.Position = UDim2.new(0, 170, 0, 0)
Linhah.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
Linhah.BorderSizePixel = 0
Linhah.Parent = PlayerInfo
TituloMusica = Instance.new("TextLabel")
TituloMusica.Size = UDim2.new(1, -140, 1, -8)
TituloMusica.Position = UDim2.new(0, 70, 0, 4)
TituloMusica.BackgroundTransparency = 1
TituloMusica.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloMusica.Font = Enum.Font.SourceSansBold
TituloMusica.TextScaled = true
TituloMusica.RichText = true
TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Hey .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.Play .. "</font>"
TituloMusica.Parent = PlayerInfo
Disco = Instance.new("ImageLabel")
Disco.Size = UDim2.new(0, 50, 0, 49)
Disco.Position = UDim2.new(0, 179, 0, 6)
Disco.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Disco.BorderSizePixel = 0
Disco.Visible = true
Disco.Image = "rbxassetid://76801681748723"
Disco.ClipsDescendants = true
Disco.Parent = PlayerInfo
Controles = Instance.new("Frame")
Controles.Size = UDim2.new(0, 235, 0, 40)
Controles.Position = UDim2.new(0, 6, 0, 205)
Controles.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Controles.BorderSizePixel = 0
Controles.Parent = Tela2
Voltar = Instance.new("ImageButton")
Voltar.Size = UDim2.new(0, 30, 0, 30)
Voltar.Position = UDim2.new(0, 10, 0.5, -15)
Voltar.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Voltar.BackgroundTransparency = 1
Voltar.BorderSizePixel = 0
Voltar.Image = "rbxassetid://88757150664292"
Voltar.Parent = Controles
Retroceder = Instance.new("ImageButton")
Retroceder.Size = UDim2.new(0, 30, 0, 30)
Retroceder.Position = UDim2.new(0, 55, 0.5, -15)
Retroceder.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Retroceder.BackgroundTransparency = 1
Retroceder.BorderSizePixel = 0
Retroceder.Image = "rbxassetid://122950454234379"
Retroceder.Parent = Controles
Play = Instance.new("ImageButton")
Play.Size = UDim2.new(0, 30, 0, 30)
Play.Position = UDim2.new(0.5, -15, 0.5, -15)
Play.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Play.BackgroundTransparency = 1
Play.BorderSizePixel = 0
Play.Image = "rbxassetid://110560238983134"
Play.Parent = Controles
Adiantar = Instance.new("ImageButton")
Adiantar.Size = UDim2.new(0, 30, 0, 30)
Adiantar.Position = UDim2.new(1, -85, 0.5, -15)
Adiantar.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Adiantar.BackgroundTransparency = 1
Adiantar.BorderSizePixel = 0
Adiantar.Image = "rbxassetid://102857578902137"
Adiantar.Parent = Controles
Pular = Instance.new("ImageButton")
Pular.Size = UDim2.new(0, 30, 0, 30)
Pular.Position = UDim2.new(1, -40, 0.5, -15)
Pular.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Pular.BackgroundTransparency = 1
Pular.BorderSizePixel = 0
Pular.Image = "rbxassetid://82401540450034"
Pular.Parent = Controles
BarraBaixo = Instance.new("Frame")
BarraBaixo.Name = "BarraBaixo"
BarraBaixo.Size = UDim2.new(1, 0, 0, 60)
BarraBaixo.Position = UDim2.new(0, 0, 0, 300)
BarraBaixo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BarraBaixo.BorderSizePixel = 0
BarraBaixo.Parent = frame
BarFoto = Instance.new("ImageLabel")
BarFoto.Size = UDim2.new(0, 44, 0, 44)
BarFoto.Position = UDim2.new(0, 6, 0, 8)
BarFoto.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
BarFoto.BorderSizePixel = 0
BarFoto.ScaleType = Enum.ScaleType.Crop
BarFoto.Parent = BarraBaixo
BarTitulo = Instance.new("TextLabel")
BarTitulo.Size = UDim2.new(0, 150, 0, 44)
BarTitulo.Position = UDim2.new(0, 54, 0, 8)
BarTitulo.BackgroundTransparency = 1
BarTitulo.TextColor3 = Color3.fromRGB(255, 255, 255)
BarTitulo.Font = Enum.Font.SourceSansBold
BarTitulo.TextScaled = true
BarTitulo.RichText = true
BarTitulo.TextXAlignment = Enum.TextXAlignment.Left
BarTitulo.Text = TituloMusica.Text
BarTitulo.Parent = BarraBaixo
BarBtn = function(nome, img, x)
	local b = Instance.new("ImageButton")
	b.Name = nome
	b.Size = UDim2.new(0, 24, 0, 24)
	b.Position = UDim2.new(0, x, 0, 5)
	b.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
	b.BorderSizePixel = 0
	b.Image = img
	b.Parent = BarraBaixo
	Corner(b, 12)
	return b
end
BarRepetir = BarBtn("BarRepetir", Repetir.Image, 249)
BarVoltar = BarBtn("BarVoltar", Voltar.Image, 277)
BarRetroceder = BarBtn("BarRetroceder", Retroceder.Image, 305)
BarPlay = BarBtn("BarPlay", Play.Image, 333)
BarAdiantar = BarBtn("BarAdiantar", Adiantar.Image, 361)
BarPular = BarBtn("BarPular", Pular.Image, 389)
BarTimeA = Instance.new("TextLabel")
BarTimeA.Size = UDim2.new(0, 30, 0, 14)
BarTimeA.Position = UDim2.new(0, 208, 0, 38)
BarTimeA.BackgroundTransparency = 1
BarTimeA.Text = TimerAtual.Text
BarTimeA.TextColor3 = Color3.fromRGB(190, 190, 190)
BarTimeA.TextScaled = true
BarTimeA.Font = Enum.Font.SourceSansBold
BarTimeA.Parent = BarraBaixo
BarProg = Instance.new("ImageButton")
BarProg.Size = UDim2.new(0, 180, 0, 14)
BarProg.Position = UDim2.new(0, 241, 0, 38)
BarProg.BackgroundTransparency = 1
BarProg.AutoButtonColor = false
BarProg.Parent = BarraBaixo
BarTrilho = Instance.new("Frame")
BarTrilho.Size = UDim2.new(1, 0, 0, 4)
BarTrilho.Position = UDim2.new(0, 0, 0.5, -2)
BarTrilho.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
BarTrilho.BorderSizePixel = 0
BarTrilho.Parent = BarProg
BarRastro = Instance.new("Frame")
BarRastro.Size = UDim2.new(0, 0, 1, 0)
BarRastro.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BarRastro.BorderSizePixel = 0
BarRastro.Parent = BarTrilho
BarTimeT = Instance.new("TextLabel")
BarTimeT.Size = UDim2.new(0, 30, 0, 14)
BarTimeT.Position = UDim2.new(0, 424, 0, 38)
BarTimeT.BackgroundTransparency = 1
BarTimeT.Text = TimerTotal.Text
BarTimeT.TextColor3 = Color3.fromRGB(190, 190, 190)
BarTimeT.TextScaled = true
BarTimeT.Font = Enum.Font.SourceSansBold
BarTimeT.Parent = BarraBaixo
BarVolIcon = Instance.new("ImageButton")
BarVolIcon.Size = UDim2.new(0, 20, 0, 20)
BarVolIcon.Position = UDim2.new(0, 490, 0, 20)
BarVolIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
BarVolIcon.BorderSizePixel = 0
BarVolIcon.Image = Mutar.Image
BarVolIcon.Parent = BarraBaixo
Corner(BarVolIcon, 10)
BarVol = Instance.new("ImageButton")
BarVol.Size = UDim2.new(0, 60, 0, 16)
BarVol.Position = UDim2.new(0, 516, 0, 22)
BarVol.BackgroundTransparency = 1
BarVol.AutoButtonColor = false
BarVol.Parent = BarraBaixo
BarVolTrilho = Instance.new("Frame")
BarVolTrilho.Size = UDim2.new(1, 0, 0, 4)
BarVolTrilho.Position = UDim2.new(0, 0, 0.5, -2)
BarVolTrilho.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
BarVolTrilho.BorderSizePixel = 0
BarVolTrilho.Parent = BarVol
BarVolRastro = Instance.new("Frame")
BarVolRastro.Size = UDim2.new(1, 0, 1, 0)
BarVolRastro.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BarVolRastro.BorderSizePixel = 0
BarVolRastro.Parent = BarVolTrilho
BarDrag = false
BarVolDrag = false
BarRatio = 0
BarVolSet = function(vol)
	BarVolRastro.Size = UDim2.new(math.clamp(tonumber(vol) or 1, 0, 1), 0, 1, 0)
end
TituloMusica:GetPropertyChangedSignal("Text"):Connect(function()
	BarTitulo.Text = TituloMusica.Text
end)
Play:GetPropertyChangedSignal("Image"):Connect(function()
	BarPlay.Image = Play.Image
end)
Repetir:GetPropertyChangedSignal("Image"):Connect(function()
	BarRepetir.Image = Repetir.Image
end)
Mutar:GetPropertyChangedSignal("Image"):Connect(function()
	BarVolIcon.Image = Mutar.Image
end)
TimerAtual:GetPropertyChangedSignal("Text"):Connect(function()
	if not BarDrag then
		BarTimeA.Text = TimerAtual.Text
	end
end)
TimerTotal:GetPropertyChangedSignal("Text"):Connect(function()
	BarTimeT.Text = TimerTotal.Text
end)
local imageButton2 = Instance.new("ImageButton")
imageButton2.Size = UDim2.new(0.27, 0, 0.37, 0)
imageButton2.AnchorPoint = Vector2.new(1, 1)
imageButton2.Position = UDim2.new(1, -20, 1, -20)
imageButton2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
imageButton2.BorderSizePixel = 0
imageButton2.BackgroundTransparency = 1
imageButton2.AutoButtonColor = false
imageButton2.Active = true
imageButton2.Visible = false
imageButton2.ZIndex = 3
imageButton2.Parent = nil
Draggable(imageButton2, true)
MiniMusica = Instance.new("ImageLabel")
MiniMusica.Size = UDim2.new(1, 0, 1, 0)
MiniMusica.Position = UDim2.new(0, 0, 0, 0)
MiniMusica.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniMusica.BorderSizePixel = 0
MiniMusica.Visible = true
MiniMusica.ImageRectOffset = Vector2.new(0, 0)
MiniMusica.ImageRectSize = Vector2.new(0, 0)
MiniMusica.Image = "rbxassetid://120329190202259"
MiniMusica.ZIndex = 3
MiniMusica.Parent = imageButton2
MiniVideo = Instance.new("VideoFrame")
MiniVideo.Size = UDim2.new(1, 0, 1, 0)
MiniVideo.Position = UDim2.new(0, 0, 0, 0)
MiniVideo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniVideo.BorderSizePixel = 0
MiniVideo.Visible = false
MiniVideo.Video = ""
MiniVideo.Volume = 1
MiniVideo.Looped = false
MiniVideo.ZIndex = 3
MiniVideo.Parent = imageButton2
MiniBack = Instance.new("ImageButton")
MiniBack.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniBack.AnchorPoint = Vector2.new(0.5, 1)
MiniBack.Position = UDim2.new(0.105, 0, 0.94, 0)
MiniBack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniBack.BackgroundTransparency = 0.5
MiniBack.Image = "rbxassetid://122582556337724"
MiniBack.Visible = false
MiniBack.ZIndex = 3
MiniBack.Parent = imageButton2
MiniRetroceder = Instance.new("ImageButton")
MiniRetroceder.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniRetroceder.AnchorPoint = Vector2.new(0.5, 1)
MiniRetroceder.Position = UDim2.new(0.3025, 0, 0.94, 0)
MiniRetroceder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniRetroceder.BackgroundTransparency = 0.5
MiniRetroceder.Image = "rbxassetid://95993997488260"
MiniRetroceder.Visible = false
MiniRetroceder.ZIndex = 3
MiniRetroceder.Parent = imageButton2
MiniPlay = Instance.new("ImageButton")
MiniPlay.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniPlay.AnchorPoint = Vector2.new(0.5, 1)
MiniPlay.Position = UDim2.new(0.5, 0, 0.94, 0)
MiniPlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniPlay.BackgroundTransparency = 0.5
MiniPlay.Image = "rbxassetid://119936293795425"
MiniPlay.Visible = false
MiniPlay.ZIndex = 3
MiniPlay.Parent = imageButton2
MiniAvancar = Instance.new("ImageButton")
MiniAvancar.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniAvancar.AnchorPoint = Vector2.new(0.5, 1)
MiniAvancar.Position = UDim2.new(0.6975, 0, 0.94, 0)
MiniAvancar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniAvancar.BackgroundTransparency = 0.5
MiniAvancar.Image = "rbxassetid://95582496868769"
MiniAvancar.Visible = false
MiniAvancar.ZIndex = 3
MiniAvancar.Parent = imageButton2
MiniSkip = Instance.new("ImageButton")
MiniSkip.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniSkip.AnchorPoint = Vector2.new(0.5, 1)
MiniSkip.Position = UDim2.new(0.895, 0, 0.94, 0)
MiniSkip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniSkip.BackgroundTransparency = 0.5
MiniSkip.Image = "rbxassetid://101914600863480"
MiniSkip.Visible = false
MiniSkip.ZIndex = 3
MiniSkip.Parent = imageButton2

-- Botones del reproductor: solo el simbolo, sin el circulo rojo
do
	local function EsPausa(img)
		img = tostring(img or "")
		return img:find("80704722265943", 1, true) ~= nil or img:find("110232191351528", 1, true) ~= nil
	end
	local function Simbolo(btn, texto)
		btn.ImageTransparency = 1
		btn.BackgroundTransparency = 1
		local l = Instance.new("TextLabel")
		l.Name = "Simbolo"
		l.AnchorPoint = Vector2.new(0.5, 0.5)
		l.Position = UDim2.new(0.5, 0, 0.5, 0)
		l.Size = UDim2.new(0.8, 0, 0.8, 0)
		l.BackgroundTransparency = 1
		l.Text = texto
		l.TextColor3 = Color3.fromRGB(255, 255, 255)
		l.Font = Enum.Font.SourceSansBold
		l.TextScaled = true
		l.ZIndex = btn.ZIndex + 1
		l.Parent = btn
		return l
	end
	-- Flecha circular dibujada (sin depender de la fuente) + el numero 10
	local function Flecha10(btn, derecha)
		btn.ImageTransparency = 1
		btn.BackgroundTransparency = 1
		local ring = Instance.new("Frame")
		ring.Name = "Flecha"
		ring.AnchorPoint = Vector2.new(0, 0.5)
		ring.Position = UDim2.new(0.0, 0, 0.5, 0)
		ring.Size = UDim2.new(0.42, 0, 0.42, 0)
		ring.BackgroundTransparency = 1
		ring.ZIndex = btn.ZIndex + 1
		ring.Parent = btn
		local ar = Instance.new("UIAspectRatioConstraint")
		ar.AspectRatio = 1
		ar.DominantAxis = Enum.DominantAxis.Height
		ar.Parent = ring
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(1, 0)
		c.Parent = ring
		local st = Instance.new("UIStroke")
		st.Color = Color3.fromRGB(255, 255, 255)
		st.Thickness = 2
		st.Parent = ring
		local g = Instance.new("UIGradient")
		g.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.8, 0),
			NumberSequenceKeypoint.new(0.81, 1),
			NumberSequenceKeypoint.new(1, 1)
		})
		g.Rotation = derecha and 0 or 180
		g.Parent = st
		local punta = Instance.new("Frame")
		punta.AnchorPoint = Vector2.new(0.5, 0.5)
		punta.Position = UDim2.new(derecha and 0.81 or 0.19, 0, 0.11, 0)
		punta.Size = UDim2.new(0.3, 0, 0.3, 0)
		punta.Rotation = 45
		punta.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		punta.BorderSizePixel = 0
		punta.ZIndex = btn.ZIndex + 1
		punta.Parent = ring
		local t = Instance.new("TextLabel")
		t.Name = "Diez"
		t.AnchorPoint = Vector2.new(1, 0.5)
		t.Position = UDim2.new(1, 0, 0.5, 0)
		t.Size = UDim2.new(0.44, 0, 0.6, 0)
		t.BackgroundTransparency = 1
		t.Text = "10"
		t.TextColor3 = Color3.fromRGB(255, 255, 255)
		t.Font = Enum.Font.SourceSansBold
		t.TextScaled = true
		t.ZIndex = btn.ZIndex + 1
		t.Parent = btn
	end
	local function Grupo(voltar, retro, play, adiantar, pular)
		Simbolo(voltar, "|\226\151\128")
		Flecha10(retro, false)
		Flecha10(adiantar, true)
		Simbolo(pular, "\226\150\182|")
		local lp = Simbolo(play, "\226\150\182")
		local pausa = Instance.new("Frame")
		pausa.Name = "Pausa"
		pausa.AnchorPoint = Vector2.new(0.5, 0.5)
		pausa.Position = UDim2.new(0.5, 0, 0.5, 0)
		pausa.Size = UDim2.new(0.36, 0, 0.5, 0)
		pausa.BackgroundTransparency = 1
		pausa.Visible = false
		pausa.ZIndex = play.ZIndex + 1
		pausa.Parent = play
		for i = 0, 1 do
			local barra = Instance.new("Frame")
			barra.Position = UDim2.new(i * 0.64, 0, 0, 0)
			barra.Size = UDim2.new(0.36, 0, 1, 0)
			barra.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			barra.BorderSizePixel = 0
			barra.ZIndex = play.ZIndex + 1
			barra.Parent = pausa
		end
		local function sync()
			local p = EsPausa(play.Image)
			lp.Visible = not p
			pausa.Visible = p
		end
		sync()
		play:GetPropertyChangedSignal("Image"):Connect(sync)
	end
	Grupo(Voltar, Retroceder, Play, Adiantar, Pular)
	Grupo(BarVoltar, BarRetroceder, BarPlay, BarAdiantar, BarPular)
	Grupo(MiniBack, MiniRetroceder, MiniPlay, MiniAvancar, MiniSkip)
end
TelaCheia = Instance.new("ImageButton")
TelaCheia.Size = UDim2.new(0.18, -8, 0.27, 0)
TelaCheia.AnchorPoint = Vector2.new(0.5, 0)
TelaCheia.Position = UDim2.new(0.105, 0, 0.03, 0)
TelaCheia.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TelaCheia.BackgroundTransparency = 0.5
TelaCheia.Image = "rbxassetid://73952228795506"
TelaCheia.Visible = false
TelaCheia.ZIndex = 3
TelaCheia.Parent = imageButton2
FecharMini = Instance.new("ImageButton")
FecharMini.Size = UDim2.new(0.18, -8, 0.27, 0)
FecharMini.AnchorPoint = Vector2.new(0.5, 0)
FecharMini.Position = UDim2.new(0.895, 0, 0.03, 0)
FecharMini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FecharMini.BackgroundTransparency = 0.5
FecharMini.Image = "rbxassetid://71780293592221"
FecharMini.Visible = false
FecharMini.ZIndex = 3
FecharMini.Parent = imageButton2
TituloEqua = Instance.new("Frame")
TituloEqua.Size = UDim2.new(0, 235, 0, 43)
TituloEqua.Position = UDim2.new(0, 6, 0, 6)
TituloEqua.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloEqua.BorderSizePixel = 0
TituloEqua.Parent = Tela3
NomeEqua = Instance.new("TextLabel")
NomeEqua.Size = UDim2.new(1, 0, 1, 0)
NomeEqua.Position = UDim2.new(0, 0, 0, 0)
NomeEqua.BackgroundTransparency = 1
NomeEqua.Text = Traducao.Equalizador
NomeEqua.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeEqua.Font = Enum.Font.SourceSansBold
NomeEqua.TextScaled = true
NomeEqua.Parent = TituloEqua
EquaFrame = Instance.new("Frame")
EquaFrame.Size = UDim2.new(0, 235, 0, 187)
EquaFrame.Position = UDim2.new(0, 6, 0, 58)
EquaFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
EquaFrame.BorderSizePixel = 0
EquaFrame.Parent = Tela3
NoEquaFrame = Instance.new("Frame")
NoEquaFrame.Size = UDim2.new(0, 235, 0, 129)
NoEquaFrame.Position = UDim2.new(0, 6, 0, 116)
NoEquaFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
NoEquaFrame.BorderSizePixel = 0
NoEquaFrame.Visible = false
NoEquaFrame.Parent = Tela3
Blockedicon = Instance.new("ImageLabel")
Blockedicon.Size = UDim2.new(0, 60, 0, 60)
Blockedicon.AnchorPoint = Vector2.new(0.5, 0.5)
Blockedicon.Position = UDim2.new(0.5, 0, 0.5, -23)
Blockedicon.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
Blockedicon.BackgroundTransparency = 1
Blockedicon.Image = "rbxassetid://140149151607570"
Blockedicon.Parent = NoEquaFrame
ErroEqua = Instance.new("TextLabel")
ErroEqua.Size = UDim2.new(0, 224, 0, 42)
ErroEqua.Position = UDim2.new(0, 5, 0, 82)
ErroEqua.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ErroEqua.BackgroundTransparency = 0.5
ErroEqua.RichText = true
ErroEqua.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.RecursoTi .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.RecursoTe .. "</font>"
ErroEqua.Font = Enum.Font.SourceSansBold
ErroEqua.TextScaled = true
ErroEqua.Parent = NoEquaFrame
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(1, 0, 1, -4)
BaseSF.Position = UDim2.new(0, 0, 0, 2)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Parent = EquaFrame
ScrollEqua = Instance.new("ScrollingFrame")
ScrollEqua.Size = UDim2.new(1, -1, 1, 0)
ScrollEqua.Position = UDim2.new(0, 0, 0, 0)
ScrollEqua.BackgroundTransparency = 1
ScrollEqua.BorderSizePixel = 0
ScrollEqua.ScrollBarThickness = 1
ScrollEqua.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollEqua.ScrollBarImageTransparency = 0.5
ScrollEqua.CanvasSize = UDim2.new(0, 0, 0, 1015)
ScrollEqua.CanvasPosition = Vector2.new(0, 0)
ScrollEqua.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollEqua.ScrollingEnabled = true
ScrollEqua.ClipsDescendants = true
ScrollEqua.Parent = BaseSF
Volume = Instance.new("Frame")
Volume.Size = UDim2.new(0, 219, 0, 35)
Volume.Position = UDim2.new(0, 8, 0, 5)
Volume.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Volume.Parent = ScrollEqua
IconeVolume = Instance.new("ImageLabel")
IconeVolume.Size = UDim2.new(0, 35, 0, 35)
IconeVolume.Position = UDim2.new(0, 0, 0, 0)
IconeVolume.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeVolume.BackgroundTransparency = 0
IconeVolume.Image = "rbxassetid://89282663179812"
IconeVolume.Parent = Volume
VolumeBox = Instance.new("TextBox")
VolumeBox.Size = UDim2.new(0, 182, 1, 0)
VolumeBox.Position = UDim2.new(0, 39, 0, 0)
VolumeBox.BackgroundTransparency = 1
VolumeBox.Text = "1"
VolumeBox.PlaceholderText = Traducao.Volume
VolumeBox.TextWrapped = true
VolumeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
VolumeBox.Font = Enum.Font.SourceSansBold
VolumeBox.TextScaled = true
VolumeBox.Parent = Volume
Pitch = Instance.new("Frame")
Pitch.Size = UDim2.new(0, 219, 0, 35)
Pitch.Position = UDim2.new(0, 8, 0, 50)
Pitch.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Pitch.Parent = ScrollEqua
IconePitch = Instance.new("ImageLabel")
IconePitch.Size = UDim2.new(0, 35, 0, 35)
IconePitch.Position = UDim2.new(0, 0, 0, 0)
IconePitch.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconePitch.BackgroundTransparency = 0
IconePitch.Image = "rbxassetid://102339134358611"
IconePitch.Parent = Pitch
PitchBox = Instance.new("TextBox")
PitchBox.Size = UDim2.new(0, 182, 1, 0)
PitchBox.Position = UDim2.new(0, 39, 0, 0)
PitchBox.BackgroundTransparency = 1
PitchBox.Text = "1"
PitchBox.PlaceholderText = "Pitch"
PitchBox.TextWrapped = true
PitchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PitchBox.Font = Enum.Font.SourceSansBold
PitchBox.TextScaled = true
PitchBox.Parent = Pitch
FrequenciaTitulo = Instance.new("Frame")
FrequenciaTitulo.Size = UDim2.new(0, 219, 0, 25)
FrequenciaTitulo.Position = UDim2.new(0, 8, 0, 105)
FrequenciaTitulo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FrequenciaTitulo.BackgroundTransparency = 0.6
FrequenciaTitulo.BorderSizePixel = 1
FrequenciaTitulo.Parent = ScrollEqua
TextoFrenquencia = Instance.new("TextLabel")
TextoFrenquencia.Size = UDim2.new(1, -70, 1, -4)
TextoFrenquencia.Position = UDim2.new(0, 35, 0, 2)
TextoFrenquencia.BackgroundTransparency = 1
TextoFrenquencia.Text = Traducao.Freque
TextoFrenquencia.Font = Enum.Font.Garamond
TextoFrenquencia.TextColor3 = Color3.fromRGB(255, 0, 0)
TextoFrenquencia.TextScaled = true
TextoFrenquencia.Parent = FrequenciaTitulo
Graves = Instance.new("Frame")
Graves.Size = UDim2.new(0, 219, 0, 35)
Graves.Position = UDim2.new(0, 8, 0, 150)
Graves.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Graves.Parent = ScrollEqua
IconeGraves = Instance.new("ImageLabel")
IconeGraves.Size = UDim2.new(0, 35, 0, 35)
IconeGraves.Position = UDim2.new(0, 0, 0, 0)
IconeGraves.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeGraves.BackgroundTransparency = 0
IconeGraves.Image = "rbxassetid://91932971942355"
IconeGraves.Parent = Graves
GravesBox = Instance.new("TextBox")
GravesBox.Size = UDim2.new(0, 182, 1, 0)
GravesBox.Position = UDim2.new(0, 39, 0, 0)
GravesBox.BackgroundTransparency = 1
GravesBox.Text = "1"
GravesBox.PlaceholderText = Traducao.Graves
GravesBox.TextWrapped = true
GravesBox.TextColor3 = Color3.fromRGB(255, 255, 255)
GravesBox.Font = Enum.Font.SourceSansBold
GravesBox.TextScaled = true
GravesBox.Parent = Graves
Medios = Instance.new("Frame")
Medios.Size = UDim2.new(0, 219, 0, 35)
Medios.Position = UDim2.new(0, 8, 0, 195)
Medios.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Medios.Parent = ScrollEqua
IconeMedios = Instance.new("ImageLabel")
IconeMedios.Size = UDim2.new(0, 35, 0, 35)
IconeMedios.Position = UDim2.new(0, 0, 0, 0)
IconeMedios.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeMedios.BackgroundTransparency = 0
IconeMedios.Image = "rbxassetid://91932971942355"
IconeMedios.Parent = Medios
MediosBox = Instance.new("TextBox")
MediosBox.Size = UDim2.new(0, 182, 1, 0)
MediosBox.Position = UDim2.new(0, 39, 0, 0)
MediosBox.BackgroundTransparency = 1
MediosBox.Text = "1"
MediosBox.PlaceholderText = Traducao.Medios
MediosBox.TextWrapped = true
MediosBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MediosBox.Font = Enum.Font.SourceSansBold
MediosBox.TextScaled = true
MediosBox.Parent = Medios
Agudos = Instance.new("Frame")
Agudos.Size = UDim2.new(0, 219, 0, 35)
Agudos.Position = UDim2.new(0, 8, 0, 240)
Agudos.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Agudos.Parent = ScrollEqua
IconeAgudos = Instance.new("ImageLabel")
IconeAgudos.Size = UDim2.new(0, 35, 0, 35)
IconeAgudos.Position = UDim2.new(0, 0, 0, 0)
IconeAgudos.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeAgudos.BackgroundTransparency = 0
IconeAgudos.Image = "rbxassetid://91932971942355"
IconeAgudos.Parent = Agudos
AgudosBox = Instance.new("TextBox")
AgudosBox.Size = UDim2.new(0, 182, 1, 0)
AgudosBox.Position = UDim2.new(0, 39, 0, 0)
AgudosBox.BackgroundTransparency = 1
AgudosBox.Text = "1"
AgudosBox.PlaceholderText = Traducao.Agudos
AgudosBox.TextWrapped = true
AgudosBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AgudosBox.Font = Enum.Font.SourceSansBold
AgudosBox.TextScaled = true
AgudosBox.Parent = Agudos
EfeitosTitulo = Instance.new("Frame")
EfeitosTitulo.Size = UDim2.new(0, 219, 0, 25)
EfeitosTitulo.Position = UDim2.new(0, 8, 0, 295)
EfeitosTitulo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
EfeitosTitulo.BackgroundTransparency = 0.6
EfeitosTitulo.BorderSizePixel = 1
EfeitosTitulo.Parent = ScrollEqua
TextoEfeitos = Instance.new("TextLabel")
TextoEfeitos.Size = UDim2.new(1, -70, 1, -4)
TextoEfeitos.Position = UDim2.new(0, 35, 0, 2)
TextoEfeitos.BackgroundTransparency = 1
TextoEfeitos.Text = Traducao.Efeitos
TextoEfeitos.Font = Enum.Font.Garamond
TextoEfeitos.TextColor3 = Color3.fromRGB(255, 0, 0)
TextoEfeitos.TextScaled = true
TextoEfeitos.Parent = EfeitosTitulo
Nenhum = Instance.new("ImageButton")
Nenhum.Name = "Nenhum"
Nenhum.Size = UDim2.new(0, 219, 0, 35)
Nenhum.Position = UDim2.new(0, 8, 0, 340)
Nenhum.AutoButtonColor = false
Nenhum.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
Nenhum.Parent = ScrollEqua
IconeNenhum = Instance.new("ImageLabel")
IconeNenhum.Size = UDim2.new(0, 35, 0, 35)
IconeNenhum.Position = UDim2.new(0, 0, 0, 0)
IconeNenhum.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeNenhum.BackgroundTransparency = 0
IconeNenhum.Image = "rbxassetid://130043384241999"
IconeNenhum.Parent = Nenhum
NenhumTexto = Instance.new("TextLabel")
NenhumTexto.Size = UDim2.new(0, 182, 1, 0)
NenhumTexto.Position = UDim2.new(0, 39, 0, 0)
NenhumTexto.BackgroundTransparency = 1
NenhumTexto.Text = Traducao.Nenhum
NenhumTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
NenhumTexto.Font = Enum.Font.SourceSansBold
NenhumTexto.TextScaled = true
NenhumTexto.Parent = Nenhum
Reverb = Instance.new("ImageButton")
Reverb.Name = "Reverb"
Reverb.Size = UDim2.new(0, 219, 0, 35)
Reverb.Position = UDim2.new(0, 8, 0, 385)
Reverb.AutoButtonColor = false
Reverb.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Reverb.Parent = ScrollEqua
IconeReverb = Instance.new("ImageLabel")
IconeReverb.Size = UDim2.new(0, 35, 0, 35)
IconeReverb.Position = UDim2.new(0, 0, 0, 0)
IconeReverb.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeReverb.BackgroundTransparency = 0
IconeReverb.Image = "rbxassetid://72645952367955"
IconeReverb.Parent = Reverb
ReverbTexto = Instance.new("TextLabel")
ReverbTexto.Size = UDim2.new(0, 182, 1, 0)
ReverbTexto.Position = UDim2.new(0, 39, 0, 0)
ReverbTexto.BackgroundTransparency = 1
ReverbTexto.Text = "Reverb"
ReverbTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
ReverbTexto.Font = Enum.Font.SourceSansBold
ReverbTexto.TextScaled = true
ReverbTexto.Parent = Reverb
Echo = Instance.new("ImageButton")
Echo.Name = "Echo"
Echo.Size = UDim2.new(0, 219, 0, 35)
Echo.Position = UDim2.new(0, 8, 0, 430)
Echo.AutoButtonColor = false
Echo.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Echo.Parent = ScrollEqua
IconeEcho = Instance.new("ImageLabel")
IconeEcho.Size = UDim2.new(0, 35, 0, 35)
IconeEcho.Position = UDim2.new(0, 0, 0, 0)
IconeEcho.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeEcho.BackgroundTransparency = 0
IconeEcho.Image = "rbxassetid://72645952367955"
IconeEcho.Parent = Echo
EchoTexto = Instance.new("TextLabel")
EchoTexto.Size = UDim2.new(0, 182, 1, 0)
EchoTexto.Position = UDim2.new(0, 39, 0, 0)
EchoTexto.BackgroundTransparency = 1
EchoTexto.Text = "Echo"
EchoTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
EchoTexto.Font = Enum.Font.SourceSansBold
EchoTexto.TextScaled = true
EchoTexto.Parent = Echo
Distortion = Instance.new("ImageButton")
Distortion.Name = "Distortion"
Distortion.Size = UDim2.new(0, 219, 0, 35)
Distortion.Position = UDim2.new(0, 8, 0, 475)
Distortion.AutoButtonColor = false
Distortion.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Distortion.Parent = ScrollEqua
IconeDistortion = Instance.new("ImageLabel")
IconeDistortion.Size = UDim2.new(0, 35, 0, 35)
IconeDistortion.Position = UDim2.new(0, 0, 0, 0)
IconeDistortion.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeDistortion.Image = "rbxassetid://72645952367955"
IconeDistortion.Parent = Distortion
DistortionTexto = Instance.new("TextLabel")
DistortionTexto.Size = UDim2.new(0, 182, 1, 0)
DistortionTexto.Position = UDim2.new(0, 39, 0, 0)
DistortionTexto.BackgroundTransparency = 1
DistortionTexto.Text = "Distortion"
DistortionTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DistortionTexto.Font = Enum.Font.SourceSansBold
DistortionTexto.TextScaled = true
DistortionTexto.Parent = Distortion
Chorus = Instance.new("ImageButton")
Chorus.Name = "Chorus"
Chorus.Size = UDim2.new(0, 219, 0, 35)
Chorus.Position = UDim2.new(0, 8, 0, 520)
Chorus.AutoButtonColor = false
Chorus.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Chorus.Parent = ScrollEqua
IconeChorus = Instance.new("ImageLabel")
IconeChorus.Size = UDim2.new(0, 35, 0, 35)
IconeChorus.Position = UDim2.new(0, 0, 0, 0)
IconeChorus.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeChorus.Image = "rbxassetid://72645952367955"
IconeChorus.Parent = Chorus
ChorusTexto = Instance.new("TextLabel")
ChorusTexto.Size = UDim2.new(0, 182, 1, 0)
ChorusTexto.Position = UDim2.new(0, 39, 0, 0)
ChorusTexto.BackgroundTransparency = 1
ChorusTexto.Text = "Chorus"
ChorusTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
ChorusTexto.Font = Enum.Font.SourceSansBold
ChorusTexto.TextScaled = true
ChorusTexto.Parent = Chorus
Flanger = Instance.new("ImageButton")
Flanger.Name = "Flanger"
Flanger.Size = UDim2.new(0, 219, 0, 35)
Flanger.Position = UDim2.new(0, 8, 0, 565)
Flanger.AutoButtonColor = false
Flanger.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Flanger.Parent = ScrollEqua
IconeFlanger = Instance.new("ImageLabel")
IconeFlanger.Size = UDim2.new(0, 35, 0, 35)
IconeFlanger.Position = UDim2.new(0, 0, 0, 0)
IconeFlanger.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeFlanger.Image = "rbxassetid://72645952367955"
IconeFlanger.Parent = Flanger
FlangerTexto = Instance.new("TextLabel")
FlangerTexto.Size = UDim2.new(0, 182, 1, 0)
FlangerTexto.Position = UDim2.new(0, 39, 0, 0)
FlangerTexto.BackgroundTransparency = 1
FlangerTexto.Text = "Flanger"
FlangerTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
FlangerTexto.Font = Enum.Font.SourceSansBold
FlangerTexto.TextScaled = true
FlangerTexto.Parent = Flanger
Tremolo = Instance.new("ImageButton")
Tremolo.Name = "Tremolo"
Tremolo.Size = UDim2.new(0, 219, 0, 35)
Tremolo.Position = UDim2.new(0, 8, 0, 610)
Tremolo.AutoButtonColor = false
Tremolo.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Tremolo.Parent = ScrollEqua
IconeTremolo = Instance.new("ImageLabel")
IconeTremolo.Size = UDim2.new(0, 35, 0, 35)
IconeTremolo.Position = UDim2.new(0, 0, 0, 0)
IconeTremolo.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeTremolo.Image = "rbxassetid://72645952367955"
IconeTremolo.Parent = Tremolo
TremoloTexto = Instance.new("TextLabel")
TremoloTexto.Size = UDim2.new(0, 182, 1, 0)
TremoloTexto.Position = UDim2.new(0, 39, 0, 0)
TremoloTexto.BackgroundTransparency = 1
TremoloTexto.Text = "Tremolo"
TremoloTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
TremoloTexto.Font = Enum.Font.SourceSansBold
TremoloTexto.TextScaled = true
TremoloTexto.Parent = Tremolo
Compressor = Instance.new("ImageButton")
Compressor.Name = "Compressor"
Compressor.Size = UDim2.new(0, 219, 0, 35)
Compressor.Position = UDim2.new(0, 8, 0, 655)
Compressor.AutoButtonColor = false
Compressor.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Compressor.Parent = ScrollEqua
IconeCompressor = Instance.new("ImageLabel")
IconeCompressor.Size = UDim2.new(0, 35, 0, 35)
IconeCompressor.Position = UDim2.new(0, 0, 0, 0)
IconeCompressor.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeCompressor.Image = "rbxassetid://72645952367955"
IconeCompressor.Parent = Compressor
CompressorTexto = Instance.new("TextLabel")
CompressorTexto.Size = UDim2.new(0, 182, 1, 0)
CompressorTexto.Position = UDim2.new(0, 39, 0, 0)
CompressorTexto.BackgroundTransparency = 1
CompressorTexto.Text = "Compressor"
CompressorTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CompressorTexto.Font = Enum.Font.SourceSansBold
CompressorTexto.TextScaled = true
CompressorTexto.Parent = Compressor
Radio = Instance.new("ImageButton")
Radio.Name = "Radio"
Radio.Size = UDim2.new(0, 219, 0, 35)
Radio.Position = UDim2.new(0, 8, 0, 700)
Radio.AutoButtonColor = false
Radio.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Radio.Parent = ScrollEqua
IconeRadio = Instance.new("ImageLabel")
IconeRadio.Size = UDim2.new(0, 35, 0, 35)
IconeRadio.Position = UDim2.new(0, 0, 0, 0)
IconeRadio.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeRadio.Image = "rbxassetid://72645952367955"
IconeRadio.Parent = Radio
RadioTexto = Instance.new("TextLabel")
RadioTexto.Size = UDim2.new(0, 182, 1, 0)
RadioTexto.Position = UDim2.new(0, 39, 0, 0)
RadioTexto.BackgroundTransparency = 1
RadioTexto.Text = "Radio"
RadioTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
RadioTexto.Font = Enum.Font.SourceSansBold
RadioTexto.TextScaled = true
RadioTexto.Parent = Radio
Cinema = Instance.new("ImageButton")
Cinema.Name = "Cinema"
Cinema.Size = UDim2.new(0, 219, 0, 35)
Cinema.Position = UDim2.new(0, 8, 0, 745)
Cinema.AutoButtonColor = false
Cinema.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Cinema.Parent = ScrollEqua
IconeCinema = Instance.new("ImageLabel")
IconeCinema.Size = UDim2.new(0, 35, 0, 35)
IconeCinema.Position = UDim2.new(0, 0, 0, 0)
IconeCinema.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeCinema.Image = "rbxassetid://72645952367955"
IconeCinema.Parent = Cinema
CinemaTexto = Instance.new("TextLabel")
CinemaTexto.Size = UDim2.new(0, 182, 1, 0)
CinemaTexto.Position = UDim2.new(0, 39, 0, 0)
CinemaTexto.BackgroundTransparency = 1
CinemaTexto.Text = "Cinema"
CinemaTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CinemaTexto.Font = Enum.Font.SourceSansBold
CinemaTexto.TextScaled = true
CinemaTexto.Parent = Cinema
Underwater = Instance.new("ImageButton")
Underwater.Name = "Underwater"
Underwater.Size = UDim2.new(0, 219, 0, 35)
Underwater.Position = UDim2.new(0, 8, 0, 790)
Underwater.AutoButtonColor = false
Underwater.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Underwater.Parent = ScrollEqua
IconeUnderwater = Instance.new("ImageLabel")
IconeUnderwater.Size = UDim2.new(0, 35, 0, 35)
IconeUnderwater.Position = UDim2.new(0, 0, 0, 0)
IconeUnderwater.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeUnderwater.Image = "rbxassetid://72645952367955"
IconeUnderwater.Parent = Underwater
UnderwaterTexto = Instance.new("TextLabel")
UnderwaterTexto.Size = UDim2.new(0, 182, 1, 0)
UnderwaterTexto.Position = UDim2.new(0, 39, 0, 0)
UnderwaterTexto.BackgroundTransparency = 1
UnderwaterTexto.Text = "Underwater"
UnderwaterTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
UnderwaterTexto.Font = Enum.Font.SourceSansBold
UnderwaterTexto.TextScaled = true
UnderwaterTexto.Parent = Underwater
Kid = Instance.new("ImageButton")
Kid.Name = "Kid"
Kid.Size = UDim2.new(0, 219, 0, 35)
Kid.Position = UDim2.new(0, 8, 0, 835)
Kid.AutoButtonColor = false
Kid.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Kid.Parent = ScrollEqua
IconeKid = Instance.new("ImageLabel")
IconeKid.Size = UDim2.new(0, 35, 0, 35)
IconeKid.Position = UDim2.new(0, 0, 0, 0)
IconeKid.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeKid.BackgroundTransparency = 0
IconeKid.Image = "rbxassetid://72645952367955"
IconeKid.Parent = Kid
KidTexto = Instance.new("TextLabel")
KidTexto.Size = UDim2.new(0, 182, 1, 0)
KidTexto.Position = UDim2.new(0, 39, 0, 0)
KidTexto.BackgroundTransparency = 1
KidTexto.Text = "Kid"
KidTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
KidTexto.Font = Enum.Font.SourceSansBold
KidTexto.TextScaled = true
KidTexto.Parent = Kid
Robot = Instance.new("ImageButton")
Robot.Name = "Robot"
Robot.Size = UDim2.new(0, 219, 0, 35)
Robot.Position = UDim2.new(0, 8, 0, 880)
Robot.AutoButtonColor = false
Robot.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Robot.Parent = ScrollEqua
IconeRobot = Instance.new("ImageLabel")
IconeRobot.Size = UDim2.new(0, 35, 0, 35)
IconeRobot.Position = UDim2.new(0, 0, 0, 0)
IconeRobot.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeRobot.BackgroundTransparency = 0
IconeRobot.Image = "rbxassetid://72645952367955"
IconeRobot.Parent = Robot
RobotTexto = Instance.new("TextLabel")
RobotTexto.Size = UDim2.new(0, 182, 1, 0)
RobotTexto.Position = UDim2.new(0, 39, 0, 0)
RobotTexto.BackgroundTransparency = 1
RobotTexto.Text = "Bug"
RobotTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
RobotTexto.Font = Enum.Font.SourceSansBold
RobotTexto.TextScaled = true
RobotTexto.Parent = Robot
Slowed = Instance.new("ImageButton")
Slowed.Name = "Slowed"
Slowed.Size = UDim2.new(0, 219, 0, 35)
Slowed.Position = UDim2.new(0, 8, 0, 925)
Slowed.AutoButtonColor = false
Slowed.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Slowed.Parent = ScrollEqua
IconeSlowed = Instance.new("ImageLabel")
IconeSlowed.Size = UDim2.new(0, 35, 0, 35)
IconeSlowed.Position = UDim2.new(0, 0, 0, 0)
IconeSlowed.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeSlowed.BackgroundTransparency = 0
IconeSlowed.Image = "rbxassetid://72645952367955"
IconeSlowed.Parent = Slowed
SlowedTexto = Instance.new("TextLabel")
SlowedTexto.Size = UDim2.new(0, 182, 1, 0)
SlowedTexto.Position = UDim2.new(0, 39, 0, 0)
SlowedTexto.BackgroundTransparency = 1
SlowedTexto.Text = "Slowed"
SlowedTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
SlowedTexto.Font = Enum.Font.SourceSansBold
SlowedTexto.TextScaled = true
SlowedTexto.Parent = Slowed
ResetarEqua = Instance.new("ImageButton")
ResetarEqua.Name = "Resetar"
ResetarEqua.Size = UDim2.new(0, 219, 0, 35)
ResetarEqua.Position = UDim2.new(0, 8, 0, 975)
ResetarEqua.AutoButtonColor = false
ResetarEqua.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
ResetarEqua.Parent = ScrollEqua
ResetarTexto = Instance.new("TextLabel")
ResetarTexto.Size = UDim2.new(1, 0, 1, 0)
ResetarTexto.Position = UDim2.new(0, 0, 0, 0)
ResetarTexto.BackgroundTransparency = 1
ResetarTexto.Text = "Reset"
ResetarTexto.TextColor3 = Color3.fromRGB(255, 0, 0)
ResetarTexto.Font = Enum.Font.SourceSansBold
ResetarTexto.TextScaled = true
ResetarTexto.Parent = ResetarEqua
Pesquisa = Instance.new("Frame")
Pesquisa.Size = UDim2.new(0, 235, 0, 43)
Pesquisa.Position = UDim2.new(0, 6, 0, 6)
Pesquisa.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Pesquisa.BorderSizePixel = 0
Pesquisa.Parent = Tela4
Lupa = Instance.new("ImageButton")
Lupa.Size = UDim2.new(0, 43, 0, 43)
Lupa.Position = UDim2.new(0, 0, 0, 0)
Lupa.BackgroundColor3 = Color3.fromRGB(40, 14, 18)
Lupa.Image = "rbxassetid://78857002895466"
Lupa.Active = true
Lupa.Parent = Pesquisa
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(0, 2, 1, 0)
Linha.Position = UDim2.new(0, 43, 0, 0)
Linha.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
Linha.BorderSizePixel = 0
Linha.Parent = Pesquisa
PesquisarBox = Instance.new("TextBox")
PesquisarBox.Size = UDim2.new(0, 139, 0, 37)
PesquisarBox.Position = UDim2.new(0, 48, 0, 3)
PesquisarBox.Text = ""
PesquisarBox.PlaceholderText = Traducao.Pesquisar
PesquisarBox.TextScaled = true
PesquisarBox.TextWrapped = true
PesquisarBox.ClearTextOnFocus = false
PesquisarBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PesquisarBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
PesquisarBox.BackgroundTransparency = 1
PesquisarBox.Active = true
PesquisarBox.Parent = Pesquisa
Linha2 = Instance.new("Frame")
Linha2.Size = UDim2.new(0, 2, 1, 0)
Linha2.Position = UDim2.new(0, 190, 0, 0)
Linha2.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
Linha2.BorderSizePixel = 0
Linha2.Parent = Pesquisa
Filtro = Instance.new("ImageButton")
Filtro.Size = UDim2.new(0, 33, 0, 33)
Filtro.Position = UDim2.new(0, 197, 0, 5)
Filtro.AutoButtonColor = false
Filtro.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Filtro.Image = "rbxassetid://128216827107080"
Filtro.Parent = Pesquisa
DownloadFrame = Instance.new("Frame")
DownloadFrame.Size = UDim2.new(0, 235, 0, 151)
DownloadFrame.Position = UDim2.new(0, 6, 0, 58)
DownloadFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
DownloadFrame.BorderSizePixel = 0
DownloadFrame.Parent = Tela4
DownloadFrameTexto = Instance.new("TextLabel")
DownloadFrameTexto.Size = UDim2.new(0, 223, 0, 40)
DownloadFrameTexto.Position = UDim2.new(0, 6, 0, 105)
DownloadFrameTexto.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DownloadFrameTexto.BackgroundTransparency = 0.5
DownloadFrameTexto.RichText = true
DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseText .. "</font>"
DownloadFrameTexto.Font = Enum.Font.SourceSansBold
DownloadFrameTexto.TextScaled = true
DownloadFrameTexto.Visible = true
DownloadFrameTexto.Parent = DownloadFrame
padding2 = Instance.new("UIPadding")
padding2.PaddingLeft = UDim.new(0, 2)
padding2.PaddingRight = UDim.new(0, 2)
padding2.PaddingTop = UDim.new(0, 2)
padding2.PaddingBottom = UDim.new(0, 2)
padding2.Parent = DownloadFrameTexto
PaginaFrame = Instance.new("Frame")
PaginaFrame.Size = UDim2.new(0, 235, 0, 27)
PaginaFrame.Position = UDim2.new(0, 6, 0, 218)
PaginaFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
PaginaFrame.BorderSizePixel = 0
PaginaFrame.Visible = false
PaginaFrame.Parent = Tela4
ScrollPagina = Instance.new("ScrollingFrame")
ScrollPagina.Size = UDim2.new(1, -6, 1, 0)
ScrollPagina.Position = UDim2.new(0, 3, 0, 0)
ScrollPagina.BackgroundTransparency = 1
ScrollPagina.BorderSizePixel = 0
ScrollPagina.ScrollBarThickness = 1
ScrollPagina.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollPagina.ScrollBarImageTransparency = 0.5
ScrollPagina.CanvasSize = UDim2.new(0, 280, 0, 0)
ScrollPagina.ScrollingDirection = Enum.ScrollingDirection.X
ScrollPagina.ClipsDescendants = true
ScrollPagina.Parent = PaginaFrame
PaginaEsperandoFrame = Instance.new("Frame")
PaginaEsperandoFrame.Size = UDim2.new(0, 235, 0, 27)
PaginaEsperandoFrame.Position = UDim2.new(0, 6, 0, 218)
PaginaEsperandoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
PaginaEsperandoFrame.BorderSizePixel = 0
PaginaEsperandoFrame.Visible = true
PaginaEsperandoFrame.Parent = Tela4
PaginaEsperandoIcon = Instance.new("ImageLabel")
PaginaEsperandoIcon.Size = UDim2.new(0, 27, 0, 27)
PaginaEsperandoIcon.Position = UDim2.new(0, 0, 0, 0)
PaginaEsperandoIcon.BackgroundTransparency = 1
PaginaEsperandoIcon.Image = "rbxassetid://130610275359163"
PaginaEsperandoIcon.Parent = PaginaEsperandoFrame
PaginaEsperandoText = Instance.new("TextLabel")
PaginaEsperandoText.Size = UDim2.new(1, -36, 1, 0)
PaginaEsperandoText.Position = UDim2.new(0, 32, 0, 0)
PaginaEsperandoText.RichText = true
PaginaEsperandoText.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.RecursoTi .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.NaoPodePagina .. "</font>"
PaginaEsperandoText.TextScaled = true
PaginaEsperandoText.Font = Enum.Font.SourceSansBold
PaginaEsperandoText.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
PaginaEsperandoText.BackgroundTransparency = 1
PaginaEsperandoText.BorderSizePixel = 0
PaginaEsperandoText.Parent = PaginaEsperandoFrame
Aguardando = Instance.new("ImageLabel")
Aguardando.Size = UDim2.new(0, 80, 0, 80)
Aguardando.AnchorPoint = Vector2.new(0.5, 0.5)
Aguardando.Position = UDim2.new(0.5, 2, 0.5, -20)
Aguardando.BackgroundTransparency = 1
Aguardando.Image = "rbxassetid://130321829564804"
Aguardando.Visible = true
Aguardando.Parent = DownloadFrame
Loading = Instance.new("ImageLabel")
Loading.Size = UDim2.new(0, 75, 0, 75)
Loading.AnchorPoint = Vector2.new(0.5, 0.5)
Loading.Position = UDim2.new(0.5, 0, 0.5, -2)
Loading.BackgroundTransparency = 1
Loading.Image = "rbxassetid://124877910068047"
Loading.Visible = false
Loading.Parent = DownloadFrame
SemResultado = Instance.new("ImageLabel")
SemResultado.Size = UDim2.new(0, 80, 0, 80)
SemResultado.AnchorPoint = Vector2.new(0.5, 0.5)
SemResultado.Position = UDim2.new(0.5, 3, 0.5, -20)
SemResultado.BackgroundTransparency = 1
SemResultado.Image = "rbxassetid://94766101394526"
SemResultado.Visible = false
SemResultado.Parent = DownloadFrame
Resultados = Instance.new("Frame")
Resultados.Size = UDim2.new(1, 0, 1, -4)
Resultados.Position = UDim2.new(0, 0, 0, 2)
Resultados.BackgroundTransparency = 1
Resultados.BorderSizePixel = 0
Resultados.ClipsDescendants = true
Resultados.Parent = DownloadFrame
FiltroFrame = Instance.new("Frame")
FiltroFrame.Size = UDim2.new(1, 0, 1, 0)
FiltroFrame.Position = UDim2.new(0, 0, 0, 0)
FiltroFrame.BackgroundTransparency = 1
FiltroFrame.BorderSizePixel = 0
FiltroFrame.Visible = false
FiltroFrame.Parent = Resultados
TituloFiltro = Instance.new("TextLabel")
TituloFiltro.Size = UDim2.new(0, 227, 0, 24)
TituloFiltro.Position = UDim2.new(0, 4, 0, 2)
TituloFiltro.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TituloFiltro.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloFiltro.BackgroundTransparency = 0.5
TituloFiltro.BorderSizePixel = 0
TituloFiltro.Text = Traducao.Filter
TituloFiltro.TextSize = 12
TituloFiltro.Parent = FiltroFrame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 30)
Linha.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
Linha.BorderSizePixel = 0
Linha.Parent = FiltroFrame
ScrollFiltro = Instance.new("ScrollingFrame")
ScrollFiltro.Size = UDim2.new(1, -1, 1, -10)
ScrollFiltro.Position = UDim2.new(0, 0, 0, 34)
ScrollFiltro.BackgroundTransparency = 1
ScrollFiltro.BorderSizePixel = 0
ScrollFiltro.ScrollBarThickness = 1
ScrollFiltro.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollFiltro.ScrollBarImageTransparency = 0.5
ScrollFiltro.CanvasSize = UDim2.new(0, 0, 0, 210)
ScrollFiltro.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFiltro.ClipsDescendants = true
ScrollFiltro.Parent = FiltroFrame
Relevancia = Instance.new("ImageButton")
Relevancia.Size = UDim2.new(0, 221, 0, 35)
Relevancia.Position = UDim2.new(0, 7, 0, 5)
Relevancia.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Relevancia.BorderSizePixel = 0
Relevancia.AutoButtonColor = false
Relevancia.Parent = ScrollFiltro
DataUpload = Instance.new("ImageButton")
DataUpload.Size = UDim2.new(0, 221, 0, 35)
DataUpload.Position = UDim2.new(0, 7, 0, 50)
DataUpload.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
DataUpload.BackgroundTransparency = 0
DataUpload.BorderSizePixel = 0
DataUpload.AutoButtonColor = false
DataUpload.Active = true
DataUpload.Parent = ScrollFiltro
Duracao = Instance.new("ImageButton")
Duracao.Size = UDim2.new(0, 221, 0, 35)
Duracao.Position = UDim2.new(0, 7, 0, 95)
Duracao.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Duracao.BorderSizePixel = 0
Duracao.AutoButtonColor = false
Duracao.Parent = ScrollFiltro
IconeRelevancia = Instance.new("ImageLabel")
IconeRelevancia.Size = UDim2.new(0, 35, 0, 35)
IconeRelevancia.Position = UDim2.new(0, 0, 0, 0)
IconeRelevancia.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
IconeRelevancia.BackgroundTransparency = 0
IconeRelevancia.Image = "rbxassetid://86663364934636"
IconeRelevancia.Parent = Relevancia
IconeDataUpload = Instance.new("ImageLabel")
IconeDataUpload.Size = UDim2.new(0, 35, 0, 35)
IconeDataUpload.Position = UDim2.new(0, 0, 0, 0)
IconeDataUpload.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
IconeDataUpload.BackgroundTransparency = 0
IconeDataUpload.Image = "rbxassetid://102239634857456"
IconeDataUpload.ImageTransparency = 0
IconeDataUpload.Parent = DataUpload
IconeDuracao = Instance.new("ImageLabel")
IconeDuracao.Size = UDim2.new(0, 35, 0, 35)
IconeDuracao.Position = UDim2.new(0, 0, 0, 0)
IconeDuracao.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
IconeDuracao.BackgroundTransparency = 0
IconeDuracao.Image = "rbxassetid://124803568759863"
IconeDuracao.Parent = Duracao
RelevanciaTexto = Instance.new("TextLabel")
RelevanciaTexto.Size = UDim2.new(0, 178, 1, 0)
RelevanciaTexto.Position = UDim2.new(0, 39, 0, 0)
RelevanciaTexto.BackgroundTransparency = 1
RelevanciaTexto.Text = Traducao.Order .. "\n" .. Traducao.Relevance
RelevanciaTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
RelevanciaTexto.Font = Enum.Font.SourceSansBold
RelevanciaTexto.TextScaled = true
RelevanciaTexto.Parent = Relevancia
DataUploadTexto = Instance.new("TextLabel")
DataUploadTexto.Size = UDim2.new(0, 178, 1, 0)
DataUploadTexto.Position = UDim2.new(0, 39, 0, 0)
DataUploadTexto.BackgroundTransparency = 1
DataUploadTexto.Text = Traducao.UploaDate .. "\n" .. Traducao.Any
DataUploadTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DataUploadTexto.Font = Enum.Font.SourceSansBold
DataUploadTexto.TextScaled = true
DataUploadTexto.Parent = DataUpload
DuracaoTexto = Instance.new("TextLabel")
DuracaoTexto.Size = UDim2.new(0, 178, 1, 0)
DuracaoTexto.Position = UDim2.new(0, 39, 0, 0)
DuracaoTexto.BackgroundTransparency = 1
DuracaoTexto.Text = Traducao.Duration .. "\n" .. Traducao.Any
DuracaoTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DuracaoTexto.Font = Enum.Font.SourceSansBold
DuracaoTexto.TextScaled = true
DuracaoTexto.Parent = Duracao
AplicarFiltro = Instance.new("ImageButton")
AplicarFiltro.Size = UDim2.new(0, 100, 0, 35)
AplicarFiltro.Position = UDim2.new(0, 7, 0, 145)
AplicarFiltro.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
AplicarFiltro.BackgroundTransparency = 0.9
AplicarFiltro.BorderSizePixel = 0
AplicarFiltro.AutoButtonColor = false
AplicarFiltro.Parent = ScrollFiltro
RemoverFiltro = Instance.new("ImageButton")
RemoverFiltro.Size = UDim2.new(0, 100, 0, 35)
RemoverFiltro.Position = UDim2.new(0, 128, 0, 145)
RemoverFiltro.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
RemoverFiltro.BackgroundTransparency = 0.9
RemoverFiltro.BorderSizePixel = 0
RemoverFiltro.AutoButtonColor = false
RemoverFiltro.Parent = ScrollFiltro
NomeAplicarFiltro = Instance.new("TextLabel")
NomeAplicarFiltro.Size = UDim2.new(1, -8, 1, -8)
NomeAplicarFiltro.Position = UDim2.new(0, 4, 0, 4)
NomeAplicarFiltro.BackgroundTransparency = 1
NomeAplicarFiltro.Text = Traducao.AplicarF
NomeAplicarFiltro.TextColor3 = Color3.fromRGB(16, 8, 10)
NomeAplicarFiltro.Font = Enum.Font.SourceSansBold
NomeAplicarFiltro.TextScaled = true
NomeAplicarFiltro.Parent = AplicarFiltro
NomeRemoverFiltro = Instance.new("TextLabel")
NomeRemoverFiltro.Size = UDim2.new(1, -8, 1, -8)
NomeRemoverFiltro.Position = UDim2.new(0, 4, 0, 4)
NomeRemoverFiltro.BackgroundTransparency = 1
NomeRemoverFiltro.Text = Traducao.RemoverF
NomeRemoverFiltro.TextColor3 = Color3.fromRGB(16, 8, 10)
NomeRemoverFiltro.Font = Enum.Font.SourceSansBold
NomeRemoverFiltro.TextScaled = true
NomeRemoverFiltro.Parent = RemoverFiltro
Formato = Instance.new("Frame")
Formato.Size = UDim2.new(0, 177, 0, 243)
Formato.Position = UDim2.new(0, 392, 0, 4)
Formato.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Formato.BackgroundTransparency = 0
Formato.BorderSizePixel = 0
Formato.Visible = false
Formato.Parent = Tela1
local formatoCorner = Instance.new("UICorner")
formatoCorner.CornerRadius = UDim.new(0, 5)
formatoCorner.Parent = Formato
TituloFormato = Instance.new("TextLabel")
TituloFormato.Size = UDim2.new(0, 165, 0, 22)
TituloFormato.Position = UDim2.new(0, 6, 0, 5)
TituloFormato.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TituloFormato.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloFormato.BackgroundTransparency = 0.5
TituloFormato.BorderSizePixel = 0
TituloFormato.Text = Traducao.EscolhaFor
TituloFormato.TextSize = 11
TituloFormato.Parent = Formato
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 30)
Linha.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
Linha.BorderSizePixel = 0
Linha.Parent = Formato
Thumbfor = Instance.new("ImageLabel")
Thumbfor.Size = UDim2.new(0, 155, 0, 87)
Thumbfor.Position = UDim2.new(0, 11, 0, 37)
Thumbfor.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Thumbfor.Image = "rbxassetid://0"
Thumbfor.ImageRectOffset = Vector2.new(0, 0)
Thumbfor.ImageRectSize = Vector2.new(0, 0)
Thumbfor.Parent = Formato
Titulofor = Instance.new("Frame")
Titulofor.Size = UDim2.new(0, 155, 0, 46)
Titulofor.Position = UDim2.new(0, 11, 0, 129)
Titulofor.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Titulofor.Parent = Formato
TextoTituloFor = Instance.new("TextLabel")
TextoTituloFor.Size = UDim2.new(1, -10, 1, -10)
TextoTituloFor.Position = UDim2.new(0, 5, 0, 5)
TextoTituloFor.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextoTituloFor.BackgroundTransparency = 1
TextoTituloFor.BorderSizePixel = 0
TextoTituloFor.RichText = true
TextoTituloFor.Text = ""
TextoTituloFor.TextScaled = true
TextoTituloFor.Parent = Titulofor
BotaoMp3 = Instance.new("ImageButton")
BotaoMp3.Size = UDim2.new(0, 155, 0, 26)
BotaoMp3.Position = UDim2.new(0, 11, 0, 181)
BotaoMp3.BackgroundColor3 = Color3.fromRGB(30, 215, 96)
BotaoMp3.BackgroundTransparency = 0
BotaoMp3.AutoButtonColor = true
BotaoMp3.Parent = Formato
BotaoMp4 = Instance.new("ImageButton")
BotaoMp4.Size = UDim2.new(0, 75, 0, 26)
BotaoMp4.Position = UDim2.new(0, 91, 0, 181)
BotaoMp4.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
BotaoMp4.BackgroundTransparency = 0.9
BotaoMp4.AutoButtonColor = false
BotaoMp4.Visible = false
BotaoMp4.Parent = Formato
BotaoCancelar = Instance.new("ImageButton")
BotaoCancelar.Size = UDim2.new(0, 155, 0, 26)
BotaoCancelar.Position = UDim2.new(0, 11, 0, 211)
BotaoCancelar.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
BotaoCancelar.Parent = Formato
NomeMp3 = Instance.new("TextLabel")
NomeMp3.Size = UDim2.new(1, -8, 1, -8)
NomeMp3.Position = UDim2.new(0, 4, 0, 4)
NomeMp3.BackgroundTransparency = 1
NomeMp3.Text = Traducao.Musica
NomeMp3.TextColor3 = Color3.fromRGB(0, 0, 0)
NomeMp3.Font = Enum.Font.SourceSansBold
NomeMp3.TextScaled = true
NomeMp3.Parent = BotaoMp3
NomeMp4 = Instance.new("TextLabel")
NomeMp4.Size = UDim2.new(1, -8, 1, -8)
NomeMp4.Position = UDim2.new(0, 4, 0, 4)
NomeMp4.BackgroundTransparency = 1
NomeMp4.Text = "Video"
NomeMp4.TextColor3 = Color3.fromRGB(144, 238, 144)
NomeMp4.Font = Enum.Font.SourceSansBold
NomeMp4.TextScaled = true
NomeMp4.Parent = BotaoMp4
NomeCancel = Instance.new("TextLabel")
NomeCancel.Size = UDim2.new(1, -8, 1, -8)
NomeCancel.Position = UDim2.new(0, 4, 0, 4)
NomeCancel.BackgroundTransparency = 1
NomeCancel.Text = Traducao.Cancelar
NomeCancel.TextColor3 = Color3.fromRGB(255, 255, 255)
NomeCancel.Font = Enum.Font.SourceSansBold
NomeCancel.TextScaled = true
NomeCancel.Parent = BotaoCancelar
Erro = Instance.new("ImageLabel")
Erro.Size = UDim2.new(0, 80, 0, 80)
Erro.AnchorPoint = Vector2.new(0.5, 0.5)
Erro.Position = UDim2.new(0.5, -3, 0.5, -20)
Erro.BackgroundTransparency = 1
Erro.Image = "rbxassetid://80694922314021"
Erro.Visible = false
Erro.Parent = Resultados
Baixando = Instance.new("ImageLabel")
Baixando.Size = UDim2.new(0, 80, 0, 80)
Baixando.AnchorPoint = Vector2.new(0.5, 0.5)
Baixando.Position = UDim2.new(0.5, -3, 0.5, -20)
Baixando.BackgroundTransparency = 1
Baixando.Image = "rbxassetid://76931060119037"
Baixando.Visible = false
Baixando.Parent = Resultados
Concluido = Instance.new("ImageLabel")
Concluido.Size = UDim2.new(0, 77, 0, 77)
Concluido.AnchorPoint = Vector2.new(0.5, 0.5)
Concluido.Position = UDim2.new(0.5, -3, 0.5, -20)
Concluido.BackgroundTransparency = 1
Concluido.Image = "rbxassetid://135264044346021"
Concluido.Visible = false
Concluido.Parent = Resultados
Tutorial = Instance.new("ImageButton")
Tutorial.Size = UDim2.new(0, 25, 0, 25)
Tutorial.Position = UDim2.new(0, 7, 0, 5)
Tutorial.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Tutorial.BorderSizePixel = 0
Tutorial.Visible = false
Tutorial.Parent = Resultados
TutoTexto = Instance.new("TextLabel")
TutoTexto.Size = UDim2.new(1, 0, 1, 0)
TutoTexto.Position = UDim2.new(0, 0, 0, 0)
TutoTexto.BackgroundTransparency = 1
TutoTexto.Text = "?"
TutoTexto.TextColor3 = Color3.fromRGB(188, 11, 35)
TutoTexto.Font = Enum.Font.SourceSansBold
TutoTexto.TextScaled = true
TutoTexto.Parent = Tutorial
Novamente = Instance.new("ImageButton")
Novamente.Size = UDim2.new(0, 25, 0, 25)
Novamente.Position = UDim2.new(0, 203, 0, 5)
Novamente.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Novamente.BorderSizePixel = 0
Novamente.Visible = false
Novamente.Parent = Resultados
FotoNova = Instance.new("ImageLabel")
FotoNova.Size = UDim2.new(0, 18, 0, 18)
FotoNova.Position = UDim2.new(0, 3, 0, 3)
FotoNova.BackgroundTransparency = 1
FotoNova.ImageTransparency = 0
FotoNova.Image = "rbxassetid://95528695645064"
FotoNova.Parent = Novamente
ScrollDownload = Instance.new("ScrollingFrame")
ScrollDownload.Size = UDim2.new(1, -1, 1, 0)
ScrollDownload.Position = UDim2.new(0, 0, 0, 0)
ScrollDownload.BackgroundTransparency = 1
ScrollDownload.BorderSizePixel = 0
ScrollDownload.ScrollBarThickness = 1
ScrollDownload.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollDownload.ScrollBarImageTransparency = 0.5
ScrollDownload.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollDownload.CanvasPosition = Vector2.new(0, 0)
ScrollDownload.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollDownload.ClipsDescendants = true
ScrollDownload.Visible = false
ScrollDownload.Parent = Resultados
TituloGC = Instance.new("Frame")
TituloGC.Size = UDim2.new(0, 235, 0, 43)
TituloGC.Position = UDim2.new(0, 6, 0, 6)
TituloGC.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloGC.BorderSizePixel = 0
TituloGC.Parent = Tela5
NomeGC = Instance.new("TextLabel")
NomeGC.Size = UDim2.new(1, 0, 1, 0)
NomeGC.Position = UDim2.new(0, 0, 0, 0)
NomeGC.BackgroundTransparency = 1
NomeGC.Text = "Global Chat"
NomeGC.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeGC.Font = Enum.Font.SourceSansBold
NomeGC.TextScaled = true
NomeGC.Parent = TituloGC
GCFrame = Instance.new("Frame")
GCFrame.Size = UDim2.new(0, 235, 0, 187)
GCFrame.Position = UDim2.new(0, 6, 0, 58)
GCFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
GCFrame.BorderSizePixel = 0
GCFrame.Parent = Tela5
Regras = Instance.new("TextButton")
Regras.Size = UDim2.new(0, 19, 0, 19)
Regras.Position = UDim2.new(0, 5, 0, 3)
Regras.Text = "R"
Regras.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Regras.TextColor3 = Color3.fromRGB(255, 255, 255)
Regras.BackgroundTransparency = 0.5
Regras.Parent = GCFrame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 25)
Linha.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
Linha.BorderSizePixel = 0
Linha.Parent = GCFrame
AvisoGC = Instance.new("TextLabel")
AvisoGC.Size = UDim2.new(0, 177, 0, 19)
AvisoGC.Position = UDim2.new(0, 29, 0, 3)
AvisoGC.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AvisoGC.BackgroundTransparency = 0.5
AvisoGC.Text = Traducao.Respeito
AvisoGC.TextColor3 = Color3.fromRGB(255, 255, 255)
AvisoGC.Font = Enum.Font.SourceSansBold
AvisoGC.TextScaled = true
AvisoGC.Visible = true
AvisoGC.Parent = GCFrame
padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 3)
padding.PaddingRight = UDim.new(0, 3)
padding.PaddingTop = UDim.new(0, 3)
padding.PaddingBottom = UDim.new(0, 3)
padding.Parent = AvisoGC
NotificarGC = Instance.new("ImageButton")
NotificarGC.Size = UDim2.new(0, 19, 0, 19)
NotificarGC.Position = UDim2.new(0, 211, 0, 3)
NotificarGC.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
NotificarGC.BackgroundTransparency = 0.5
NotificarGC.Parent = GCFrame
Sino = Instance.new("ImageLabel")
Sino.Size = UDim2.new(0, 17, 0, 16)
Sino.Position = UDim2.new(0, 1, 0, 1)
Sino.Image = "rbxassetid://115374069603142"
Sino.BackgroundTransparency = 1
Sino.Parent = NotificarGC
EsperandoIMG = Instance.new("ImageLabel")
EsperandoIMG.Size = UDim2.new(0, 90, 0, 90)
EsperandoIMG.AnchorPoint = Vector2.new(0.5, 0.5)
EsperandoIMG.Position = UDim2.new(0.5, -3, 0.5, -5)
EsperandoIMG.BackgroundTransparency = 1
EsperandoIMG.Image = "rbxassetid://18836713445"
EsperandoIMG.Visible = true
EsperandoIMG.Parent = GCFrame
BaseFinalGC = Instance.new("Frame")
BaseFinalGC.Size = UDim2.new(0, 40, 0, 40)
BaseFinalGC.AnchorPoint = Vector2.new(0.5, 0.5)
BaseFinalGC.Position = UDim2.new(0.5, 0, 0.5, 26)
BaseFinalGC.BorderSizePixel = 0
BaseFinalGC.BackgroundTransparency = 1
BaseFinalGC.ZIndex = 2
BaseFinalGC.ClipsDescendants = true
BaseFinalGC.Parent = GCFrame
FinalGC = Instance.new("ImageButton")
FinalGC.Size = UDim2.new(0, 32, 0, 32)
FinalGC.Position = UDim2.new(0, 4, 1, 4)
FinalGC.ZIndex = 2
FinalGC.Image = "rbxassetid://128357204583758"
FinalGC.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
FinalGC.Parent = BaseFinalGC
ScrollGC = Instance.new("ScrollingFrame")
ScrollGC.Size = UDim2.new(1, -2, 1, -73)
ScrollGC.Position = UDim2.new(0, 1, 0, 28)
ScrollGC.BackgroundTransparency = 1
ScrollGC.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollGC.ScrollBarImageTransparency = 0.5
ScrollGC.BorderSizePixel = 0
ScrollGC.ScrollBarThickness = 1
ScrollGC.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollGC.CanvasPosition = Vector2.new(0, 0)
ScrollGC.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollGC.ClipsDescendants = true
ScrollGC.Visible = false
ScrollGC.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollGC.Parent = GCFrame
paddinggc = Instance.new("UIPadding")
paddinggc.PaddingLeft = UDim.new(0, 5)
paddinggc.PaddingRight = UDim.new(0, 5)
paddinggc.PaddingTop = UDim.new(0, 5)
paddinggc.PaddingBottom = UDim.new(0, 5)
paddinggc.Parent = ScrollGC
layoutgc = Instance.new("UIListLayout")
layoutgc.Parent = ScrollGC
layoutgc.SortOrder = Enum.SortOrder.LayoutOrder
layoutgc.Padding = UDim.new(0, 9)
Linha2 = Instance.new("Frame")
Linha2.Size = UDim2.new(1, 0, 0, 2)
Linha2.Position = UDim2.new(0, 0, 0, 143)
Linha2.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
Linha2.BorderSizePixel = 0
Linha2.Parent = GCFrame
MsgFrame = Instance.new("Frame")
MsgFrame.Size = UDim2.new(0, 223, 0, 32)
MsgFrame.Position = UDim2.new(0, 6, 0, 150)
MsgFrame.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
MsgFrame.BorderSizePixel = 0
MsgFrame.Parent = GCFrame
MsgErroGC = Instance.new("TextLabel")
MsgErroGC.Size = UDim2.new(0, 215, 0, 28)
MsgErroGC.Position = UDim2.new(0, 4, 0, 2)
MsgErroGC.Text = Traducao.GcKey
MsgErroGC.TextScaled = true
MsgErroGC.TextColor3 = Color3.fromRGB(220, 220, 220)
MsgErroGC.BackgroundTransparency = 1
MsgErroGC.Visible = true
MsgErroGC.Parent = MsgFrame
Traduzir = Instance.new("ImageButton")
Traduzir.Size = UDim2.new(0, 24, 0, 24)
Traduzir.Position = UDim2.new(0, 4, 0, 4)
Traduzir.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Traduzir.Visible = false
Traduzir.Parent = MsgFrame
FotoTradu = Instance.new("ImageLabel")
FotoTradu.Size = UDim2.new(0, 18, 0, 18)
FotoTradu.Position = UDim2.new(0, 3, 0, 3)
FotoTradu.BackgroundTransparency = 1
FotoTradu.ImageTransparency = 0
FotoTradu.Image = "rbxassetid://84867288877251"
FotoTradu.Parent = Traduzir
LinhaTraducao = Instance.new("Frame")
LinhaTraducao.Size = UDim2.new(0, 1, 1, 0)
LinhaTraducao.Position = UDim2.new(0, 32, 0, 0)
LinhaTraducao.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
LinhaTraducao.BorderSizePixel = 0
LinhaTraducao.Visible = false
LinhaTraducao.Parent = MsgFrame
GCBox = Instance.new("TextBox")
GCBox.Size = UDim2.new(0, 151, 0, 28)
GCBox.Position = UDim2.new(0, 36, 0, 2)
GCBox.Text = ""
GCBox.ClearTextOnFocus = false
GCBox.PlaceholderText = Traducao.EnvieGc
GCBox.TextScaled = true
GCBox.TextColor3 = Color3.fromRGB(255, 255, 255)
GCBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
GCBox.BackgroundTransparency = 1
GCBox.Active = false
GCBox.Visible = false
GCBox.Parent = MsgFrame
SendGC = Instance.new("ImageButton")
SendGC.Size = UDim2.new(0, 32, 0, 32)
SendGC.Position = UDim2.new(0, 191, 0, 0)
SendGC.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
SendGC.Visible = false
SendGC.Parent = MsgFrame
Aviao = Instance.new("ImageLabel")
Aviao.Size = UDim2.new(0, 24, 0, 24)
Aviao.Position = UDim2.new(0, 4, 0, 4)
Aviao.BackgroundTransparency = 1
Aviao.ImageTransparency = 0
Aviao.Image = "rbxassetid://111380412941011"
Aviao.Parent = SendGC
TituloPremium = Instance.new("Frame")
TituloPremium.Size = UDim2.new(0, 235, 0, 43)
TituloPremium.Position = UDim2.new(0, 6, 0, 6)
TituloPremium.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloPremium.BorderSizePixel = 0
TituloPremium.Parent = Tela6
NomePremium = Instance.new("TextLabel")
NomePremium.Size = UDim2.new(1, 0, 1, 0)
NomePremium.Position = UDim2.new(0, 0, 0, 0)
NomePremium.BackgroundTransparency = 1
NomePremium.Text = "Premium"
NomePremium.TextColor3 = Color3.fromRGB(255, 255, 0)
NomePremium.Font = Enum.Font.SourceSansBold
NomePremium.TextScaled = true
NomePremium.Parent = TituloPremium
Privilegios = Instance.new("Frame")
Privilegios.Size = UDim2.new(0, 235, 0, 100)
Privilegios.Position = UDim2.new(0, 6, 0, 58)
Privilegios.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Privilegios.BorderSizePixel = 0
Privilegios.Parent = Tela6
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(1, 0, 1, -4)
BaseSF.Position = UDim2.new(0, 0, 0, 2)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Visible = true
BaseSF.Parent = Privilegios
ScrollPremium = Instance.new("ScrollingFrame")
ScrollPremium.Size = UDim2.new(1, -2, 1, 0)
ScrollPremium.Position = UDim2.new(0, 0, 0, 0)
ScrollPremium.BackgroundTransparency = 1
ScrollPremium.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollPremium.ScrollBarImageTransparency = 0.5
ScrollPremium.BorderSizePixel = 0
ScrollPremium.ScrollBarThickness = 1
ScrollPremium.CanvasSize = UDim2.new(0, 0, 0, 270)
ScrollPremium.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollPremium.ClipsDescendants = false
ScrollPremium.Parent = BaseSF
Priv1 = Instance.new("ImageButton")
Priv1.Size = UDim2.new(0, 221, 0, 35)
Priv1.Position = UDim2.new(0, 7, 0, 5)
Priv1.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
Priv1.AutoButtonColor = false
Priv1.Parent = ScrollPremium
Priv2 = Instance.new("ImageButton")
Priv2.Size = UDim2.new(0, 221, 0, 35)
Priv2.Position = UDim2.new(0, 7, 0, 50)
Priv2.BackgroundColor3 = Color3.fromRGB(220, 80, 95)
Priv2.AutoButtonColor = false
Priv2.Parent = ScrollPremium
Priv3 = Instance.new("ImageButton")
Priv3.Size = UDim2.new(0, 221, 0, 35)
Priv3.Position = UDim2.new(0, 7, 0, 95)
Priv3.BackgroundColor3 = Color3.fromRGB(72, 61, 139)
Priv3.AutoButtonColor = false
Priv3.Parent = ScrollPremium
Priv4 = Instance.new("ImageButton")
Priv4.Size = UDim2.new(0, 221, 0, 35)
Priv4.Position = UDim2.new(0, 7, 0, 140)
Priv4.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Priv4.AutoButtonColor = false
Priv4.Parent = ScrollPremium
Priv5 = Instance.new("ImageButton")
Priv5.Size = UDim2.new(0, 221, 0, 35)
Priv5.Position = UDim2.new(0, 7, 0, 185)
Priv5.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Priv5.AutoButtonColor = false
Priv5.Parent = ScrollPremium
Priv6 = Instance.new("ImageButton")
Priv6.Size = UDim2.new(0, 221, 0, 35)
Priv6.Position = UDim2.new(0, 7, 0, 230)
Priv6.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
Priv6.AutoButtonColor = false
Priv6.Parent = ScrollPremium
IconePriv1 = Instance.new("ImageLabel")
IconePriv1.Size = UDim2.new(0, 35, 0, 35)
IconePriv1.Position = UDim2.new(0, 0, 0, 0)
IconePriv1.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
IconePriv1.Image = "rbxassetid://140605327166526"
IconePriv1.Parent = Priv1
IconePriv2 = Instance.new("ImageLabel")
IconePriv2.Size = UDim2.new(0, 35, 0, 35)
IconePriv2.Position = UDim2.new(0, 0, 0, 0)
IconePriv2.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
IconePriv2.Image = "rbxassetid://128999640209878"
IconePriv2.Parent = Priv2
IconePriv3 = Instance.new("ImageLabel")
IconePriv3.Size = UDim2.new(0, 35, 0, 35)
IconePriv3.Position = UDim2.new(0, 0, 0, 0)
IconePriv3.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
IconePriv3.Image = "rbxassetid://126724539196702"
IconePriv3.Parent = Priv3
IconePriv4 = Instance.new("ImageLabel")
IconePriv4.Size = UDim2.new(0, 35, 0, 35)
IconePriv4.Position = UDim2.new(0, 0, 0, 0)
IconePriv4.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
IconePriv4.Image = "rbxassetid://77651842919295"
IconePriv4.Parent = Priv4
IconePriv5 = Instance.new("ImageLabel")
IconePriv5.Size = UDim2.new(0, 35, 0, 35)
IconePriv5.Position = UDim2.new(0, 0, 0, 0)
IconePriv5.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
IconePriv5.Image = "rbxassetid://129506682254424"
IconePriv5.Parent = Priv5
IconePriv6 = Instance.new("ImageLabel")
IconePriv6.Size = UDim2.new(0, 35, 0, 35)
IconePriv6.Position = UDim2.new(0, 0, 0, 0)
IconePriv6.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
IconePriv6.Image = "rbxassetid://135757623745817"
IconePriv6.Parent = Priv6
TextoPriv1 = Instance.new("TextLabel")
TextoPriv1.Size = UDim2.new(0, 160, 1, 0)
TextoPriv1.Position = UDim2.new(0, 45, 0, 0)
TextoPriv1.BackgroundTransparency = 1
TextoPriv1.Text = Traducao.Priv1
TextoPriv1.TextColor3 = Color3.fromRGB(144, 238, 144)
TextoPriv1.Font = Enum.Font.SourceSansBold
TextoPriv1.TextScaled = true
TextoPriv1.Parent = Priv1
TextoPriv2 = Instance.new("TextLabel")
TextoPriv2.Size = UDim2.new(0, 160, 1, 0)
TextoPriv2.Position = UDim2.new(0, 45, 0, 0)
TextoPriv2.BackgroundTransparency = 1
TextoPriv2.Text = Traducao.Priv2
TextoPriv2.TextColor3 = Color3.fromRGB(173, 216, 230)
TextoPriv2.Font = Enum.Font.SourceSansBold
TextoPriv2.TextScaled = true
TextoPriv2.Parent = Priv2
TextoPriv3 = Instance.new("TextLabel")
TextoPriv3.Size = UDim2.new(0, 160, 1, 0)
TextoPriv3.Position = UDim2.new(0, 45, 0, 0)
TextoPriv3.BackgroundTransparency = 1
TextoPriv3.Text = "MiniPlayer"
TextoPriv3.TextColor3 = Color3.fromRGB(186, 85, 211)
TextoPriv3.Font = Enum.Font.SourceSansBold
TextoPriv3.TextScaled = true
TextoPriv3.Parent = Priv3
TextoPriv4 = Instance.new("TextLabel")
TextoPriv4.Size = UDim2.new(0, 160, 1, 0)
TextoPriv4.Position = UDim2.new(0, 45, 0, 0)
TextoPriv4.BackgroundTransparency = 1
TextoPriv4.Text = "Roblox Audio"
TextoPriv4.TextColor3 = Color3.fromRGB(255, 99, 71)
TextoPriv4.Font = Enum.Font.SourceSansBold
TextoPriv4.TextScaled = true
TextoPriv4.Parent = Priv4
TextoPriv5 = Instance.new("TextLabel")
TextoPriv5.Size = UDim2.new(0, 160, 1, 0)
TextoPriv5.Position = UDim2.new(0, 45, 0, 0)
TextoPriv5.BackgroundTransparency = 1
TextoPriv5.Text = "Global Chat"
TextoPriv5.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoPriv5.Font = Enum.Font.SourceSansBold
TextoPriv5.TextScaled = true
TextoPriv5.Parent = Priv5
TextoPriv6 = Instance.new("TextLabel")
TextoPriv6.Size = UDim2.new(0, 160, 1, 0)
TextoPriv6.Position = UDim2.new(0, 45, 0, 0)
TextoPriv6.BackgroundTransparency = 1
TextoPriv6.Text = "Premium UI"
TextoPriv6.TextColor3 = Color3.fromRGB(139, 69, 19)
TextoPriv6.Font = Enum.Font.SourceSansBold
TextoPriv6.TextScaled = true
TextoPriv6.Parent = Priv6
local frame2 = Instance.new("Frame")
frame2.Size = UDim2.new(0, 235, 0, 78)
frame2.Position = UDim2.new(0, 6, 0, 167)
frame2.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
frame2.BorderSizePixel = 0
frame2.Visible = false
frame2.Parent = Tela6
IconeKeyOk = Instance.new("ImageLabel")
IconeKeyOk.Size = UDim2.new(0, 40, 0, 40)
IconeKeyOk.AnchorPoint = Vector2.new(0.5, 0)
IconeKeyOk.Position = UDim2.new(0.5, 0, 0, 2)
IconeKeyOk.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
IconeKeyOk.BackgroundTransparency = 1
IconeKeyOk.Image = "rbxassetid://132948829118667"
IconeKeyOk.Parent = frame2
PremiumOkTexto = Instance.new("TextLabel")
PremiumOkTexto.Size = UDim2.new(0, 225, 0, 30)
PremiumOkTexto.Position = UDim2.new(0, 5, 0, 44)
PremiumOkTexto.RichText = true
PremiumOkTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.VocePremium .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.VocePremiumTexto .. "</font>"
PremiumOkTexto.TextScaled = true
PremiumOkTexto.Font = Enum.Font.SourceSansBold
PremiumOkTexto.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PremiumOkTexto.BackgroundTransparency = 0.5
PremiumOkTexto.BorderSizePixel = 0
PremiumOkTexto.Parent = frame2
KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 235, 0, 43)
KeyFrame.Position = UDim2.new(0, 6, 0, 167)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
KeyFrame.BorderSizePixel = 0
KeyFrame.Visible = true
KeyFrame.Parent = Tela6
SendKey = Instance.new("ImageButton")
SendKey.Size = UDim2.new(0, 43, 0, 43)
SendKey.Position = UDim2.new(0, 0, 0, 0)
SendKey.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
SendKey.Parent = KeyFrame
IconeKey = Instance.new("ImageLabel")
IconeKey.Size = UDim2.new(0, 30, 0, 30)
IconeKey.Position = UDim2.new(0, 6, 0, 6)
IconeKey.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
IconeKey.BackgroundTransparency = 1
IconeKey.Image = "rbxassetid://108124574887969"
IconeKey.Parent = SendKey
KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0, 186, 0, 41)
KeyBox.Position = UDim2.new(0, 47, 0, 1)
KeyBox.Text = ""
KeyBox.ClearTextOnFocus = false
KeyBox.PlaceholderText = Traducao.Key
KeyBox.TextScaled = true
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.BackgroundTransparency = 1
KeyBox.Active = true
KeyBox.Parent = KeyFrame
GetKey = Instance.new("ImageButton")
GetKey.Size = UDim2.new(0, 235, 0, 26)
GetKey.Position = UDim2.new(0, 6, 0, 219)
GetKey.BackgroundColor3 = Color3.fromRGB(90, 30, 40)
GetKey.Visible = true
GetKey.Parent = Tela6
SetaES = Instance.new("ImageButton")
SetaES.Size = UDim2.new(0, 26, 0, 26)
SetaES.Position = UDim2.new(0, 0, 0, 0)
SetaES.BackgroundColor3 = Color3.fromRGB(90, 30, 40)
SetaES.Parent = GetKey
SetaDI = Instance.new("ImageButton")
SetaDI.Size = UDim2.new(0, 26, 0, 26)
SetaDI.Position = UDim2.new(0, 209, 0, 0)
SetaDI.BackgroundColor3 = Color3.fromRGB(90, 30, 40)
SetaDI.Parent = GetKey
Esquerda = Instance.new("TextLabel")
Esquerda.Size = UDim2.new(0, 20, 0, 20)
Esquerda.Position = UDim2.new(0, 3, 0, 2)
Esquerda.BackgroundTransparency = 1
Esquerda.Text = "<"
Esquerda.TextColor3 = Color3.fromRGB(0, 0, 0)
Esquerda.Font = Enum.Font.SourceSansBold
Esquerda.TextSize = 25
Esquerda.Parent = SetaES
Direita = Instance.new("TextLabel")
Direita.Size = UDim2.new(0, 20, 0, 20)
Direita.Position = UDim2.new(0, 3, 0, 2)
Direita.BackgroundTransparency = 1
Direita.Text = ">"
Direita.TextColor3 = Color3.fromRGB(0, 0, 0)
Direita.Font = Enum.Font.SourceSansBold
Direita.TextSize = 25
Direita.Parent = SetaDI
GetKeyTexto = Instance.new("TextLabel")
GetKeyTexto.Size = UDim2.new(0, 165, 1, 0)
GetKeyTexto.Position = UDim2.new(0, 35, 0, 0)
GetKeyTexto.BackgroundTransparency = 1
GetKeyTexto.Text = Traducao.Link
GetKeyTexto.TextColor3 = Color3.fromRGB(220, 80, 95)
GetKeyTexto.Font = Enum.Font.SourceSansBold
GetKeyTexto.TextScaled = true
GetKeyTexto.Parent = GetKey
ReportFrame = Instance.new("Frame")
ReportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ReportFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ReportFrame.Size = UDim2.new(0, 300, 0, 250)
ReportFrame.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
ReportFrame.BorderSizePixel = 0
ReportFrame.Visible = false
ReportFrame.Parent = screenGui
TituloReportFrame = Instance.new("Frame")
TituloReportFrame.Size = UDim2.new(0, 286, 0, 30)
TituloReportFrame.Position = UDim2.new(0, 7, 0, 6)
TituloReportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloReportFrame.Parent = ReportFrame
TextoTituloReportFrame = Instance.new("TextLabel")
TextoTituloReportFrame.Size = UDim2.new(1, 0, 1, -4)
TextoTituloReportFrame.Position = UDim2.new(0, 0, 0, 2)
TextoTituloReportFrame.BackgroundTransparency = 1
TextoTituloReportFrame.Text = "Report"
TextoTituloReportFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoTituloReportFrame.TextScaled = true
TextoTituloReportFrame.Font = Enum.Font.Highway
TextoTituloReportFrame.Parent = TituloReportFrame
LinhaReport = Instance.new("Frame")
LinhaReport.Size = UDim2.new(1, 0, 0, 5)
LinhaReport.Position = UDim2.new(0, 0, 0, 42)
LinhaReport.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
LinhaReport.BorderSizePixel = 0
LinhaReport.Parent = ReportFrame
TextoReportFrameFrame = Instance.new("Frame")
TextoReportFrameFrame.Size = UDim2.new(0, 286, 0, 135)
TextoReportFrameFrame.Position = UDim2.new(0, 7, 0, 54)
TextoReportFrameFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TextoReportFrameFrame.Parent = ReportFrame
TextoReportFrame = Instance.new("TextLabel")
TextoReportFrame.Size = UDim2.new(0, 276, 0, 90)
TextoReportFrame.Position = UDim2.new(0, 5, 0, 5)
TextoReportFrame.BackgroundTransparency = 1
TextoReportFrame.Text = ""
TextoReportFrame.TextXAlignment = Enum.TextXAlignment.Left
TextoReportFrame.TextColor3 = Color3.fromRGB(192, 192, 192)
TextoReportFrame.TextScaled = true
TextoReportFrame.Font = Enum.Font.Highway
TextoReportFrame.Parent = TextoReportFrameFrame
LinhaMotivo = Instance.new("Frame")
LinhaMotivo.Size = UDim2.new(1, 0, 0, 2)
LinhaMotivo.Position = UDim2.new(0, 0, 0, 100)
LinhaMotivo.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
LinhaMotivo.BorderSizePixel = 0
LinhaMotivo.Parent = TextoReportFrameFrame
Motivo = Instance.new("Frame")
Motivo.Size = UDim2.new(0, 274, 0, 23)
Motivo.Position = UDim2.new(0, 6, 0, 107)
Motivo.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Motivo.BorderSizePixel = 0
Motivo.Parent = TextoReportFrameFrame
MotivoBox = Instance.new("TextBox")
MotivoBox.Size = UDim2.new(1, -6, 1, -6)
MotivoBox.Position = UDim2.new(0, 3, 0, 3)
MotivoBox.BackgroundTransparency = 1
MotivoBox.Text = ""
MotivoBox.PlaceholderText = Traducao.MotivoReport
MotivoBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MotivoBox.Font = Enum.Font.SourceSansBold
MotivoBox.TextScaled = true
MotivoBox.ClearTextOnFocus = false
MotivoBox.Parent = Motivo
Denunciar = Instance.new("ImageButton")
Denunciar.Size = UDim2.new(0, 100, 0, 30)
Denunciar.Position = UDim2.new(0, 193, 0, 210)
Denunciar.BackgroundColor3 = Color3.fromRGB(207, 55, 52)
Denunciar.Active = true
Denunciar.Parent = ReportFrame
FotoReport = Instance.new("ImageLabel")
FotoReport.Size = UDim2.new(0, 40, 0, 40)
FotoReport.Position = UDim2.new(0, 131, 0, 200)
FotoReport.BackgroundTransparency = 1
FotoReport.Image = ""
FotoReport.Parent = ReportFrame
CancelarReport = Instance.new("ImageButton")
CancelarReport.Size = UDim2.new(0, 100, 0, 30)
CancelarReport.Position = UDim2.new(0, 7, 0, 210)
CancelarReport.BackgroundColor3 = Color3.fromRGB(127, 127, 127)
CancelarReport.Active = true
CancelarReport.Parent = ReportFrame
DenunciarTexto = Instance.new("TextLabel")
DenunciarTexto.Size = UDim2.new(1, -6, 1, -6)
DenunciarTexto.Position = UDim2.new(0, 3, 0, 3)
DenunciarTexto.BackgroundTransparency = 1
DenunciarTexto.Text = "Report"
DenunciarTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DenunciarTexto.TextScaled = true
DenunciarTexto.Parent = Denunciar
CancelarReportTexto = Instance.new("TextLabel")
CancelarReportTexto.Size = UDim2.new(1, -6, 1, -6)
CancelarReportTexto.Position = UDim2.new(0, 3, 0, 3)
CancelarReportTexto.BackgroundTransparency = 1
CancelarReportTexto.Text = Traducao.Cancelar
CancelarReportTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CancelarReportTexto.TextScaled = true
CancelarReportTexto.Parent = CancelarReport
BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0
BlurEffect.Parent = v3
Warn = Instance.new("Frame")
Warn.AnchorPoint = Vector2.new(0.5, 0.5)
Warn.Position = UDim2.new(0.5, 0, 0.5, 0)
Warn.Size = UDim2.new(0, 300, 0, 250)
Warn.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
Warn.BorderSizePixel = 0
Warn.Visible = false
Warn.Parent = screenGui
TituloWarn = Instance.new("Frame")
TituloWarn.Size = UDim2.new(0, 286, 0, 30)
TituloWarn.Position = UDim2.new(0, 7, 0, 6)
TituloWarn.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloWarn.Parent = Warn
TextoTituloWarn = Instance.new("TextLabel")
TextoTituloWarn.Size = UDim2.new(1, 0, 1, -4)
TextoTituloWarn.Position = UDim2.new(0, 0, 0, 2)
TextoTituloWarn.BackgroundTransparency = 1
TextoTituloWarn.Text = Traducao.Aviso
TextoTituloWarn.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoTituloWarn.TextScaled = true
TextoTituloWarn.Font = Enum.Font.Highway
TextoTituloWarn.Parent = TituloWarn
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 5)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Linha.BorderSizePixel = 0
Linha.Parent = Warn
TextoWarnFrame = Instance.new("Frame")
TextoWarnFrame.Size = UDim2.new(0, 286, 0, 125)
TextoWarnFrame.Position = UDim2.new(0, 7, 0, 54)
TextoWarnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TextoWarnFrame.Parent = Warn
TextoWarn = Instance.new("TextLabel")
TextoWarn.Size = UDim2.new(0, 276, 0, 115)
TextoWarn.Position = UDim2.new(0, 5, 0, 5)
TextoWarn.BackgroundTransparency = 1
TextoWarn.Text = ""
TextoWarn.TextXAlignment = Enum.TextXAlignment.Left
TextoWarn.TextColor3 = Color3.fromRGB(192, 192, 192)
TextoWarn.TextScaled = true
TextoWarn.Font = Enum.Font.Highway
TextoWarn.Parent = TextoWarnFrame
CloseWarn = Instance.new("ImageButton")
CloseWarn.Size = UDim2.new(0, 150, 0, 30)
CloseWarn.AnchorPoint = Vector2.new(0.5, 0.5)
CloseWarn.Position = UDim2.new(0.5, 0, 0, 215)
CloseWarn.BackgroundColor3 = Color3.fromRGB(207, 55, 52)
CloseWarn.BackgroundTransparency = 0
CloseWarn.Parent = Warn
CloseWarnTexto = Instance.new("TextLabel")
CloseWarnTexto.Size = UDim2.new(1, -6, 1, -6)
CloseWarnTexto.Position = UDim2.new(0, 3, 0, 3)
CloseWarnTexto.BackgroundTransparency = 1
CloseWarnTexto.Text = Traducao.FecharAviso
CloseWarnTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseWarnTexto.TextScaled = true
CloseWarnTexto.Parent = CloseWarn

YmpHwid = function()
	return v14
end

YmpClipboard = function(arg)
	if setclipboard_ then
		pcall(function()
			setclipboard_(arg)
		end)
	end
end

YmpRequest = function(...)
	return requestAsync(...)
end

scrolls = { ScrollTodos, ScrollMusicas, ScrollVideos, ScrollRoblox, ScrollFav, ScrollLocal, ScrollPesquisa }

ApiInfo = function(arg)
	local n4 = 0

	while n4 < 8 do
		n4 += 1

		local ok3, result3, result4, result5, result6 = pcall(function()
			local response = game:HttpGet(str3 .. "/info?url=" .. "https://youtu.be/" .. arg)
			local data2 = HttpService:JSONDecode(response)
			return data2.Name, data2.Author, data2.Thumbnail, data2.AuthorUrl
		end)

		if ok3 and result3 then
			return result3, result4, result5, result6
		end
		task.wait(0.35)
	end

	return nil
end

ApiRoblox = function(arg)
	local n4 = 0

	while n4 < 8 do
		n4 += 1

		local ok3, result3, result4, result5, result6 = pcall(function()
			local response = game:HttpGet(str3 .. "/roblox?assetId=" .. tostring(arg))
			local data2 = HttpService:JSONDecode(response)
			return data2.Name, data2.Creator.Id, data2.Creator.Name, data2.Public
		end)

		if ok3 and result3 then
			return result3, result4, result5, result6
		end
		task.wait(0.35)
	end

	return nil
end

local flag19 = false
local flag20 = false

processQueue = function()
	if flag7 then
		return
	end
	flag7 = true

	while #tbl7 > 0 do
		table.remove(tbl7, 1)()
	end

	flag7 = false
end

FavoritarFile = function(arg)
	task.spawn(function()
		table.insert(tbl7, function()
			local ok3, result3 = pcall(function()
				return HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))
			end)

			local v17 = ok3 and result3
			local tbl12

			if v17 then
				tbl12 = v17
			else
				tbl12 = { { Key = "", Favorites = tbl6 or {} } }
			end

			tbl12[1] = tbl12[1] or { Key = "", Favorites = {} }
			tbl12[1].Favorites = tbl12[1].Favorites or {}
			local favorites = tbl12[1].Favorites

			for _, favorite in ipairs(favorites) do
				if favorite == arg then
					tbl6 = favorites
					return
				end
			end

			table.insert(favorites, arg)
			tbl6 = favorites

			pcall(function()
				writefile("YouTube Music Player/Internal/Data.json", HttpService:JSONEncode(tbl12))
			end)
		end)

		processQueue()
	end)
end

DesfavoritarFile = function(arg)
	task.spawn(function()
		table.insert(tbl7, function()
			local ok3, result3 = pcall(function()
				return HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))
			end)

			ok3 = ok3 and result3
			local tbl12

			if ok3 then
				tbl12 = ok3
			else
				tbl12 = { { Key = "", Favorites = tbl6 or {} } }
			end

			tbl12[1] = tbl12[1] or { Key = "", Favorites = {} }
			tbl12[1].Favorites = tbl12[1].Favorites or {}
			local favorites = tbl12[1].Favorites

			for i, favorite in ipairs(favorites) do
				if favorite == arg then
					table.remove(favorites, i)
					break
				end
			end

			tbl6 = favorites

			pcall(function()
				writefile("YouTube Music Player/Internal/Data.json", HttpService:JSONEncode(tbl12))
			end)
		end)

		processQueue()
	end)
end

pcall(function()
	local data2 = HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))

	if data2[1] and data2[1].Favorites then
		tbl6 = data2[1].Favorites
	end
end)

local sound2 = Instance.new("Sound")
sound2.Parent = v7
sound2.Looped = false
sound2.Volume = 1
sound2.SoundId = ""

local function SinisterStopPreviousMusic()
	pcall(function()
		if _G.__SinisterYMPSound and _G.__SinisterYMPSound.Parent then
			_G.__SinisterYMPSound:Stop()
			pcall(function() _G.__SinisterYMPSound:Destroy() end)
		end
		_G.__SinisterYMPSound = nil
	end)
	pcall(function()
		local ss = game:GetService("SoundService")
		for _, s in ipairs(ss:GetChildren()) do
			if s:IsA("Sound") and (s.Name == "SinisterYMPKeep" or (s.SoundId and s.SoundId ~= "" and s.Playing)) then
				-- only stop our kept tracks marked
				if s:GetAttribute("SinisterYMP") then
					s:Stop()
					pcall(function() s:Destroy() end)
				end
			end
		end
	end)
	pcall(function()
		if sound2 and sound2.Playing then sound2:Stop() end
	end)
	pcall(function()
		if sound and sound.Playing then sound:Stop() end
	end)
	pcall(function()
		if v12 and typeof(v12) == "Instance" and v12:IsA("Sound") and v12 ~= sound2 then
			v12:Stop()
		end
	end)
end


sound2.PlaybackSpeed = 1
Equalizer = Instance.new("EqualizerSoundEffect")
Equalizer.LowGain = 1
Equalizer.MidGain = 1
Equalizer.HighGain = 1
Equalizer.Parent = sound2
VolumesOriginais = {}
MuteCon = nil
Mutado = false

GlobalMute = function(arg)
	pcall(function()
		if arg then
			if Mutado then
				return
			end
			Mutado = true

			local function fn4(arg2)
				pcall(function()
					if not arg2:IsA("Sound") then
						return
					end

					if arg2 == sound2 or arg2 == sound then
						return
					end

					if VolumesOriginais[arg2] == nil then
						VolumesOriginais[arg2] = arg2.Volume
					end

					arg2.Volume = 0
				end)
			end

			for _, descendant in ipairs(game:GetDescendants()) do
				fn4(descendant)
			end

			MuteCon = game.DescendantAdded:Connect(function(descendant)
				if Mutado then
					fn4(descendant)
				end
			end)
		else
			if not Mutado then
				return
			end
			Mutado = false

			if MuteCon then
				MuteCon:Disconnect()
				MuteCon = nil
			end

			for k, v17 in pairs(VolumesOriginais) do
				pcall(function()
					if k and k.Parent and k ~= sound2 then
						k.Volume = v17
					end
				end)
			end

			table.clear(VolumesOriginais)
		end
	end)
end

MutarToggle = function()
	if Mutar.Image == "rbxassetid://109518972658686" then
		Mutar.Image = "rbxassetid://139303337799549"
		fn3(Traducao.Mutado, Traducao.SobreMute, 5)
		GlobalMute(true)
	else
		Mutar.Image = "rbxassetid://109518972658686"
		fn3(Traducao.Desmutado, Traducao.SobreUnmute, 5)
		GlobalMute(false)
	end
end

Mutar.MouseButton1Click:Connect(MutarToggle)
BarVolIcon.MouseButton1Click:Connect(MutarToggle)

BibliotecaMusicas = {}
BilbliotecaVideos = {}
BibliotecaRoblox = {}
BibliotecaLocal = {}
Girando = false
Congelado = false
GiroBackup = 1
GiroSpeed = 1

Girar = function(arg)
	if arg then
		Girando = true
		Congelado = false
	else
		Girando = false
		Disco.Rotation = 0
		Congelado = false
	end
end

SetFreeze = function(arg)
	Congelado = arg
end

task.spawn(function()
	while true do
		if Girando and not Congelado and GiroSpeed > 0 then
			local v17 = Disco
			v17.Rotation = v17.Rotation + GiroSpeed
		end

		task.wait(0.02)
	end
end)

formatar = function(arg)
	local n4 = math.floor(arg / 60)
	local n5 = math.floor(arg % 60)
	return string.format("%02d:%02d", n4, n5)
end

Reset = function()
	Rastro.Size = UDim2.new(0, 0, 1, 0)
	BarRastro.Size = UDim2.new(0, 0, 1, 0)
	BolaProgresso.AnchorPoint = Vector2.new(0, 0.5)
	BolaProgresso.Position = UDim2.new(0, 0, 0.5, 0)
	TimerAtual.Text = "00:00"
end

setProgress = function(arg)
	local n4 = math.clamp(arg, 0, 1)
	Rastro.Size = UDim2.new(n4, 0, 1, 0)
	if not BarDrag then
		BarRastro.Size = UDim2.new(n4, 0, 1, 0)
	end
	BolaProgresso.AnchorPoint = Vector2.new(n4, 0.5)
	BolaProgresso.Position = UDim2.new(n4, 0, 0.5, 0)
end

getProgress = function(arg)
	local x = BarraProgresso.AbsolutePosition.X
	local x2 = BarraProgresso.AbsoluteSize.X
	if x2 <= 0 then
		return 0
	end
	return math.clamp((arg - x) / x2, 0, 1)
end

seek = function(arg)
	local v17 = v12
	local flag21 = v12

	if v17 then
		flag21 = v17.TimeLength > 0
	end

	if flag21 then
		TimerAtual.Text = formatar(arg * v17.TimeLength)
	end
end

BarraProgresso.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local v17 = v12
		local flag21 = v12

		if v17 then
			flag21 = v17.TimeLength > 0
		end

		if flag21 and flag9 then
			flag8 = true
			local v18 = getProgress(input.Position.X)
			setProgress(v18)
			seek(v18)
		end
	end
end)

BolaProgresso.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local v17 = v12
		local flag21 = v12

		if v17 then
			flag21 = v17.TimeLength > 0
		end

		if flag21 and flag9 then
			flag8 = true
		end
	end
end)

v9.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if flag8 then
			local v17 = v12
			local flag21 = v12

			if v17 then
				flag21 = v17.TimeLength > 0
			end

			if flag21 and flag9 then
				local timeLength = v17.TimeLength
				v17.TimePosition = math.clamp(getProgress(input.Position.X), 0, 0.999) * timeLength
			end

			flag8 = false
		end
	end
end)

v9.InputChanged:Connect(function(input)
	if flag8 then
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local v17 = v12
			local flag21 = v12

			if v17 then
				flag21 = v17.TimeLength > 0
			end

			if flag21 and flag9 then
				local n4 = math.clamp(getProgress(input.Position.X), 0, 0.999)
				setProgress(n4)
				seek(n4)
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(0.1)
		local v17 = v12
		local flag21 = v12

		if v17 then
			flag21 = v17.TimeLength > 0
		end

		if flag21 and not flag8 and not BarDrag then
			local timePosition = v17.TimePosition
			setProgress(timePosition / v17.TimeLength)
			TimerAtual.Text = formatar(timePosition)
		end
	end
end)

Equalizador = function(arg)
	if arg == true then
		EquaFrame.Size = UDim2.new(0, 235, 0, 187)
		NoEquaFrame.Visible = false
		ScrollEqua.ScrollingEnabled = true
	else
		EquaFrame.Size = UDim2.new(0, 235, 0, 49)
		NoEquaFrame.Visible = true
		ScrollEqua.CanvasPosition = Vector2.new(0, 0)
		ScrollEqua.ScrollingEnabled = false
	end
end

Selecionar = function(arg, arg2)
	local tbl12 = { ScrollTodos, ScrollMusicas, ScrollVideos, ScrollRoblox, ScrollFav, ScrollLocal, ScrollPesquisa }
	local v17 = nil

	for _, v18 in ipairs(tbl12) do
		for _, child in ipairs(v18:GetChildren()) do
			if child:IsA("ImageButton") then
				local v19 = string.split(child.Name, ":")
				if v19[1] == arg2 and v19[2] == arg then
					v17 = child
					break
				end
			end
		end

		if not v17 then
			continue
		end
		break
	end

	if not v17 then
		return
	end

	local function fn4(arg3)
		local imageLabel = arg3:FindFirstChildOfClass("ImageLabel")
		arg3.BackgroundColor3 = Color3.fromRGB(16, 8, 10)

		if imageLabel then
			Stroke(imageLabel, 50, 50, 50, 2)
		end

		Stroke(arg3, 50, 50, 50, 2)

		for _, child in ipairs(arg3:GetChildren()) do
			if child:IsA("ImageButton") then
				Stroke(child, 50, 50, 50, 2)
			end
		end
	end

	if BotaoSelecionadoAtual == v17 then
		for _, v18 in ipairs(tbl12) do
			for _, child in ipairs(v18:GetChildren()) do
				if child:IsA("ImageButton") then
					fn4(child)
				end
			end
		end

		BotaoSelecionadoAtual = nil
		return
	end

	for _, v18 in ipairs(tbl12) do
		for _, child in ipairs(v18:GetChildren()) do
			if child:IsA("ImageButton") then
				fn4(child)
			end
		end
	end

	local imageLabel = v17:FindFirstChildOfClass("ImageLabel")
	v17.BackgroundColor3 = Color3.fromRGB(139, 0, 0)

	if imageLabel then
		Stroke(imageLabel, 255, 0, 0, 2)
	end

	Stroke(v17, 255, 0, 0, 2)

	for _, child in ipairs(v17:GetChildren()) do
		if child:IsA("ImageButton") then
			Stroke(child, 255, 0, 0, 2)
		end
	end

	BotaoSelecionadoAtual = v17
end

CurrentMediaId = nil
thumbAtual = nil
BloquearMidia = false

resetSound = function(arg)
	if arg then
		pcall(function()
			arg:Stop()
			arg.SoundId = ""
			arg.TimePosition = 0
		end)
	end
end

resetVideo = function(arg)
	if arg then
		pcall(function()
			arg:Pause()
			arg.Video = ""
			arg.TimePosition = 0
		end)
	end
end

local function fn4(arg, arg2)
	if not arg2 or not arg then
		return
	end

	if BloquearMidia then
		fn3(Traducao.Aguarde, Traducao.DownloadFazendo, 5)
		return
	end
	resetSound(sound2)
	resetVideo(Video)
	resetVideo(MiniVideo)
	BloquearMidia = true
	local n4 = math.random()
	CurrentRequestId = n4
	task.wait(0.05)
	CurrentMediaId = arg2
	thumbAtual = nil
	local currentPlaying = arg .. ":" .. arg2
	Selecionar(arg, arg2)
	local visible = imageButton2.Visible

	if _G.CurrentPlaying == currentPlaying then
		_G.CurrentPlaying = nil
		Reset()
		Play.Image = "rbxassetid://110560238983134"
		MiniPlay.Image = "rbxassetid://119936293795425"
		flag9 = false
		Girar(false)
		Equalizador(true)
		GiroSpeed = GiroBackup
		BloquearMidia = false

		if visible then
			Musica.Image = "rbxassetid://109021809317392"
		else
			Musica.Image = "rbxassetid://120329190202259"
		end

		Musica.ImageRectOffset = Vector2.new(0, 0)
		Musica.ImageRectSize = Vector2.new(0, 0)
		MiniMusica.Image = "rbxassetid://120329190202259"
		MiniMusica.ImageRectOffset = Vector2.new(0, 0)
		MiniMusica.ImageRectSize = Vector2.new(0, 0)
		Musica.Visible = true
		MiniMusica.Visible = true
		Video.Visible = false
		MiniVideo.Visible = false
		TimerTotal.Text = "00:00"
		FotoAutor.Image = "rbxassetid://130243480255582"
		TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Hey .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Play .. "</font>"
		return
	end

	_G.CurrentPlaying = currentPlaying
	Play.Image = "rbxassetid://80704722265943"
	MiniPlay.Image = "rbxassetid://110232191351528"
	flag9 = true

	if sound2 then
		pcall(function()
			sound2:Stop()
			sound2.TimePosition = 0
		end)
	end

	if Video then
		pcall(function()
			Video:Pause()
			Video.TimePosition = 0
		end)
	end

	if MiniVideo then
		pcall(function()
			MiniVideo:Pause()
			MiniVideo.TimePosition = 0
		end)
	end

	local function fn5(arg3)
		v12 = arg3 and (visible and MiniVideo or Video) or sound2
		Musica.Visible = true
		MiniMusica.Visible = true
		Video.Visible = arg3 and not visible
		MiniVideo.Visible = arg3 and visible
	end

	local function fn6(arg3, arg4)
		return "<font color=\"rgb(255,255,255)\">" .. arg3 .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.De .. " " .. arg4 .. "</font>"
	end

	local function fn7(arg3)
		local n5 = math.floor(arg3 or 0)
		return string.format("%02d:%02d", math.floor(n5 / 60), n5 % 60)
	end

	local function fn8(arg3)
		local ok3, result3 = pcall(function()
			return getcustomasset(arg3)
		end)

		if ok3 and typeof(result3) == "string" then
			return result3
		end
		return nil
	end

	local function fn9(arg3, arg4)
		local str6 = "YouTube Music Player/Internal/Cache/" .. arg4 .. ".png"
		if isfile(str6) then
			return fn8(str6)
		end

		local ok3 = pcall(function()
			local response = game:HttpGet(arg3)
			if not response or typeof(response) ~= "string" or #response < 50 then
				return
			end
			writefile(str6, response)
		end)

		task.wait(0.08)
		if not ok3 or not isfile(str6) then
			return nil
		end
		return fn8(str6)
	end

	local function fn10()
		if arg == "Musica" then
			for _, v17 in ipairs(BibliotecaMusicas) do
				if v17.id == arg2 then
					return v17
				end
			end
		elseif arg == "Video" then
			for _, v17 in ipairs(BilbliotecaVideos) do
				if v17.id == arg2 then
					return v17
				end
			end
		elseif arg == "Roblox" then
			for _, v17 in ipairs(BibliotecaRoblox) do
				if v17.id == arg2 then
					return v17
				end
			end
		elseif arg == "Local" then
			for _, v17 in ipairs(BibliotecaLocal) do
				if v17.name == arg2 then
					return v17
				end
			end
		end
	end

	local v17 = fn10()
	if not v17 then
		return
	end
	TimerTotal.Text = "00:00"
	Girar(true)

	if arg == "Musica" or arg == "Video" then
		fn5(arg == "Video")
		local v18 = visible and MiniMusica or Musica
		v18.Image = "rbxassetid://108154884074176"
		v18.ImageRectOffset = Vector2.new(0, 0)
		v18.ImageRectSize = Vector2.new(0, 0)
		FotoAutor.Image = "rbxassetid://108154884074176"
		TituloMusica.Text = fn6(v17.name, v17.author)

		task.spawn(function()
			task.wait(0.05)
			if CurrentRequestId ~= n4 then
				return
			end
			local authorUrl = v17.authorUrl and fn9(v17.authorUrl, "author_" .. arg2)
			if CurrentRequestId ~= n4 then
				return
			end
			FotoAutor.Image = authorUrl or "rbxassetid://106804518898726"

			if arg == "Musica" and v17.thumb then
				local v19 = fn9(v17.thumb, "thumb_" .. arg2)
				if CurrentRequestId ~= n4 then
					return
				end

				if v19 then
					v18.Image = v19
					thumbAtual = v19
					v18.ImageRectOffset = Vector2.new(0, 45)
					v18.ImageRectSize = Vector2.new(480, 270)
				else
					v18.Image = "rbxassetid://110787075859454"
					v18.ImageRectOffset = Vector2.new(0, 0)
					v18.ImageRectSize = Vector2.new(0, 0)
				end
			end

			BloquearMidia = false
		end)

		if arg == "Musica" then
			pcall(function()
				pcall(SinisterStopPreviousMusic)
				sound2.SoundId = getcustomasset("YouTube Music Player/Musics/" .. arg2 .. ".mp3")
				sound2:Play()
				Equalizador(true)
				GiroSpeed = GiroBackup

				task.spawn(function()
					local n5 = 0

					while sound2.TimeLength == 0 and n5 < 5 do
						n5 += task.wait(0.1)
					end

					if CurrentRequestId ~= n4 then
						return
					end
					TimerTotal.Text = fn7(sound2.TimeLength)
				end)
			end)
		else
			pcall(function()
				local v19 = getcustomasset("YouTube Music Player/Videos/" .. arg2 .. ".webm")
				local v20 = visible and MiniVideo or Video
				v20.Video = v19
				v20:Play()
				Equalizador(false)
				GiroSpeed = 1

				task.spawn(function()
					local n5 = 0

					while v20.TimeLength == 0 and n5 < 5 do
						n5 += task.wait(0.1)
					end

					if CurrentRequestId ~= n4 then
						return
					end
					TimerTotal.Text = fn7(v20.TimeLength)
				end)
			end)
		end
	elseif arg == "Roblox" then
		fn5(false)
		local v18 = visible and MiniMusica or Musica
		v18.Image = "rbxassetid://100415102639682"
		v18.ImageRectOffset = Vector2.new(0, 0)
		v18.ImageRectSize = Vector2.new(0, 0)
		TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. v17.name .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.De .. " " .. v17.creatorName .. "</font>"
		FotoAutor.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. v17.creatorId .. "&width=420&height=420&format=png"

		pcall(function()
			sound2.SoundId = "rbxassetid://" .. arg2
			sound2:Play()
			Equalizador(true)
			GiroSpeed = GiroBackup

			task.spawn(function()
				local n5 = 0

				while sound2.TimeLength == 0 and n5 < 5 do
					n5 += task.wait(0.1)
				end

				if CurrentRequestId ~= n4 then
					return
				end
				TimerTotal.Text = fn7(sound2.TimeLength)
			end)
		end)

		BloquearMidia = false
	elseif arg == "Local" then
		fn5(false)
		local v18 = visible and MiniMusica or Musica
		v18.Image = "rbxassetid://84131152943912"
		v18.ImageRectOffset = Vector2.new(0, 0)
		v18.ImageRectSize = Vector2.new(0, 0)
		TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. arg2 .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.In .. " " .. Traducao.LocalTitle .. "</font>"
		FotoAutor.Image = "rbxassetid://99316239950686"

		pcall(function()
			pcall(SinisterStopPreviousMusic)
			sound2.SoundId = getcustomasset("YouTube Music Player/Local Audios/" .. arg2 .. ".mp3")
			sound2:Play()
			Equalizador(true)
			GiroSpeed = GiroBackup

			task.spawn(function()
				local n5 = 0

				while sound2.TimeLength == 0 and n5 < 5 do
					n5 += task.wait(0.1)
				end

				if CurrentRequestId ~= n4 then
					return
				end
				TimerTotal.Text = fn7(sound2.TimeLength)
			end)
		end)

		BloquearMidia = false
	end
end

SetMiniPlayer = function(visible)
	imageButton2.Visible = visible

	local function fn5(arg)
		if arg then
			pcall(function()
				arg:Pause()
				arg:Stop()
				arg.Video = nil
			end)
		end
	end

	local function fn6(arg)
		local v17 = nil

		pcall(function()
			v17 = getcustomasset(arg)
		end)

		return v17
	end

	local function fn7(arg, arg2)
		if not arg then
			return
		end

		if arg2 then
			arg.ImageRectOffset = Vector2.new(0, 45)
			arg.ImageRectSize = Vector2.new(480, 270)
		else
			arg.ImageRectOffset = Vector2.new(0, 0)
			arg.ImageRectSize = Vector2.new(0, 0)
		end
	end

	local function fn8(arg)
		if arg == "rbxassetid://108154884074176" then
			return "loading"
		end

		if arg == "rbxassetid://110787075859454" then
			return "empty"
		end

		if arg == "rbxassetid://84131152943912" then
			return "special"
		end

		if arg == "rbxassetid://109021809317392" then
			return "mini"
		end

		if arg == "rbxassetid://100415102639682" then
			return "roblox"
		end
		return "default"
	end

	local function fn9(arg, arg2)
		if arg2 == "loading" then
			arg.Image = "rbxassetid://108154884074176"
			fn7(arg, false)
		elseif arg2 == "empty" then
			arg.Image = "rbxassetid://110787075859454"
			fn7(arg, false)
		elseif arg2 == "special" then
			arg.Image = "rbxassetid://84131152943912"
			fn7(arg, false)
		elseif arg2 == "mini" then
			arg.Image = "rbxassetid://109021809317392"
			fn7(arg, false)
		elseif arg2 == "roblox" then
			arg.Image = "rbxassetid://100415102639682"
			fn7(arg, false)
		else
			arg.Image = "rbxassetid://120329190202259"
			fn7(arg, false)
		end
	end

	if visible then
		if Musica then
			Musica.Visible = true
			local v17 = fn8(Musica.Image)
			fn9(MiniMusica, v17)
			Musica.Image = "rbxassetid://109021809317392"
			fn7(Musica, false)
		end

		if MiniMusica then
			MiniMusica.Visible = true

			if thumbAtual then
				MiniMusica.Image = thumbAtual
				fn7(MiniMusica, true)
				Musica.Image = "rbxassetid://109021809317392"
				fn7(Musica, false)
			end
		end

		if Video and Video.Visible then
			local timePosition = Video.TimePosition
			local v17 = fn6("YouTube Music Player/Videos/" .. CurrentMediaId .. ".webm")
			fn5(Video)

			if MiniVideo and v17 then
				fn5(MiniVideo)
				MiniVideo.Visible = true
				MiniVideo.Video = v17
				MiniVideo.TimePosition = timePosition
				MiniVideo:Play()
				v12 = MiniVideo
				Play.Image = "rbxassetid://80704722265943"
				MiniPlay.Image = "rbxassetid://110232191351528"
			end

			Video.Visible = false
		elseif MiniVideo and MiniVideo.Visible then
			Video.Visible = false
		end
	else
		if MiniVideo and MiniVideo.Visible then
			local timePosition = MiniVideo.TimePosition
			local v17 = fn6("YouTube Music Player/Videos/" .. CurrentMediaId .. ".webm")
			fn5(MiniVideo)

			if Video and v17 then
				fn5(Video)
				Video.Visible = true
				Video.Video = v17
				Video.TimePosition = timePosition
				Video:Play()
				v12 = Video
				Play.Image = "rbxassetid://80704722265943"
				MiniPlay.Image = "rbxassetid://110232191351528"
			end
		end

		if Musica then
			Musica.Visible = true

			if MiniMusica then
				MiniMusica.Visible = true
			end

			if MiniMusica then
				local v17 = fn8(MiniMusica.Image)
				fn9(Musica, v17)

				if thumbAtual then
					Musica.Image = thumbAtual
					fn7(Musica, true)
				end
			end
		end
	end
end

SortMedia = function(arg, arg2)
	local attribute = arg:GetAttribute("Build")
	local attribute2 = arg2:GetAttribute("Build")
	if attribute and not attribute2 then
		return true
	end

	if attribute2 and not attribute then
		return false
	end
	local tag = arg:FindFirstChild("tag")
	local tag2 = arg2:FindFirstChild("tag")

	if tag then
		tag = tag.Text:match("^%s*(.-)%s*$"):lower()
	end

	tag = tag or ""

	if tag2 then
		tag2 = tag2.Text:match("^%s*(.-)%s*$"):lower()
	end

	return tag < (tag2 or "")
end

GetScrollAtual = function()
	for _, v17 in ipairs(scrolls) do
		if v17.Visible then
			return v17
		end
	end
end

GetLista = function(arg)
	local tbl12 = {}

	for _, child in ipairs(arg:GetChildren()) do
		if child:IsA("ImageButton") then
			if not child:GetAttribute("Privado") then
				local match, v17 = child.Name:match("(.+):(.+)")

				if match and v17 then
					if not ((v17 == "Video" or v17 == "Roblox") and not flag19) then
						table.insert(tbl12, child)
					end
				end
			end
		end
	end

	table.sort(tbl12, SortMedia)
	return tbl12
end

GetSelecionado = function(arg)
	for _, v17 in ipairs(arg) do
		if v17.BackgroundColor3 == Color3.fromRGB(139, 0, 0) then
			return v17
		end
	end
end

PlayBtn = function(arg)
	local match, v17 = arg.Name:match("(.+):(.+)")

	if match and v17 then
		fn4(v17, match)
	end
end

Pause = function()
	if not v12 or not flag9 then
		return
	end

	if v12:IsA("Sound") then
		if v12.Playing then
			v12:Pause()
			Play.Image = "rbxassetid://110560238983134"
			MiniPlay.Image = "rbxassetid://119936293795425"
			SetFreeze(true)
		else
			v12:Resume()
			Play.Image = "rbxassetid://80704722265943"
			MiniPlay.Image = "rbxassetid://110232191351528"
			SetFreeze(false)
		end
	elseif v12:IsA("VideoFrame") then
		if v12.Playing then
			v12:Pause()
			Play.Image = "rbxassetid://110560238983134"
			MiniPlay.Image = "rbxassetid://119936293795425"
			SetFreeze(true)
		else
			v12:Play()
			Play.Image = "rbxassetid://80704722265943"
			MiniPlay.Image = "rbxassetid://110232191351528"
			SetFreeze(false)
		end
	end
end

Avancar10s = function()
	if not v12 or not flag9 then
		return
	end
	local v17 = v12
	if v17.TimeLength <= 0 then
		return
	end
	local timePosition = v17.TimePosition + 10

	if v17.TimeLength < timePosition then
		timePosition = v17.TimeLength
	end

	v17.TimePosition = timePosition
end

Retroceder10s = function()
	if not v12 or not flag9 then
		return
	end
	local v17 = v12
	if v17.TimeLength <= 0 then
		return
	end
	local timePosition = v17.TimePosition - 10

	if timePosition < 0 then
		timePosition = 0
	end

	v17.TimePosition = timePosition
end

Skip = function()
	local v17 = GetScrollAtual()
	if not v17 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end
	local v18 = GetLista(v17)
	if #v18 == 0 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end

	if #v18 == 1 then
		if v18[1].BackgroundColor3 ~= Color3.fromRGB(139, 0, 0) then
			PlayBtn(v18[1])
		end

		return
	end

	local v19 = GetSelecionado(v18)
	if not v19 then
		PlayBtn(v18[1])
		return
	end
	local v20 = nil

	for i, v21 in ipairs(v18) do
		if v21 == v19 then
			v20 = i
			break
		else
			v20 = nil
		end
	end

	local n4 = v20 + 1

	if n4 > #v18 then
		n4 = 1
	end

	PlayBtn(v18[n4])
end

Back = function()
	local v17 = GetScrollAtual()
	if not v17 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end
	local v18 = GetLista(v17)
	if #v18 == 0 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end

	if #v18 == 1 then
		if v18[1].BackgroundColor3 ~= Color3.fromRGB(139, 0, 0) then
			PlayBtn(v18[1])
		end

		return
	end

	local v19 = GetSelecionado(v18)
	if not v19 then
		PlayBtn(v18[1])
		return
	end
	local v20 = nil

	for i, v21 in ipairs(v18) do
		if v21 == v19 then
			v20 = i
			break
		else
			v20 = nil
		end
	end

	local n4 = v20 - 1

	if n4 < 1 then
		n4 = #v18
	end

	PlayBtn(v18[n4])
end

EscolherRandom = function(arg)
	local tbl12 = {}
	local v17 = GetSelecionado(arg)

	for _, v18 in ipairs(arg) do
		if v18 ~= v17 and not tbl5[v18] then
			table.insert(tbl12, v18)
		end
	end

	if #tbl12 == 0 then
		tbl5 = {}

		for _, v18 in ipairs(arg) do
			if v18 ~= v17 then
				table.insert(tbl12, v18)
			end
		end
	end

	if #tbl12 == 0 then
		return v17
	end
	local v18 = tbl12[math.random(1, #tbl12)]
	tbl5[v18] = true
	return v18
end

HandleEnded = function(arg)
	if str4 == "nill" then
		return
	end
	task.wait()
	arg.Looped = false
	local v17 = GetScrollAtual()

	if v17 ~= v11 then
		tbl5 = {}
		v11 = v17
	end

	if not v17 then
		fn3(Traducao.PlayMode, Traducao.PlayModeRepetir, 5)
		v12.TimePosition = 0
		v12:Play()
		return
	end

	local v18 = GetLista(v17)

	if #v18 == 0 then
		fn3(Traducao.PlayMode, Traducao.PlayModeRepetir, 5)
		v12.TimePosition = 0
		v12:Play()
		return
	end

	local v19 = GetSelecionado(v18)

	if v19 then
		tbl5[v19] = true
	end

	if #v18 == 1 then
		if not v19 then
			PlayBtn(v18[1])
		else
			fn3(Traducao.PlayMode, Traducao.PlayModeRepetir, 5)
			v12.TimePosition = 0
			v12:Play()
		end

		return
	end

	if str4 == "Random" then
		local v20 = EscolherRandom(v18)

		if v20 then
			PlayBtn(v20)
		end

		return
	end

	Skip()
end

sound2.Ended:Connect(function()
	HandleEnded(sound2)
end)

Video.Ended:Connect(function()
	if Video and Video.Visible then
		HandleEnded(Video)
	end
end)

MiniVideo.Ended:Connect(function()
	if MiniVideo and MiniVideo.Visible then
		HandleEnded(MiniVideo)
	end
end)

Deletar = function(arg, arg2)
	if BloquearMidia then
		fn3(Traducao.Aguarde, Traducao.DownloadFazendo, 5)
		return
	end

	if _G.CurrentPlaying then
		local match, v17 = _G.CurrentPlaying:match("^(.-)%:(.+)$")

		if v17 == arg then
			fn4(match, v17)
		end
	end

	local tbl12 = {
		"YouTube Music Player/Internal/Cache/author_" .. arg .. ".png",
		"YouTube Music Player/Internal/Cache/thumb_" .. arg .. ".png",
	}

	for _, v17 in ipairs({
		"YouTube Music Player/Musics/" .. arg .. ".mp3",
		"YouTube Music Player/Videos/" .. arg .. ".webm",
		"YouTube Music Player/Roblox IDS/" .. arg .. ".rbx",
		"YouTube Music Player/Local Audios/" .. arg .. ".mp3",
	}) do
		if isfile(v17) then
			delfile(v17)
		end
	end

	for _, v17 in ipairs(tbl12) do
		if isfile(v17) then
			delfile(v17)
		end
	end

	for i = #BibliotecaMusicas, 1, -1 do
		if BibliotecaMusicas[i].id == arg then
			table.remove(BibliotecaMusicas, i)
		end
	end

	for i = #BilbliotecaVideos, 1, -1 do
		if BilbliotecaVideos[i].id == arg then
			table.remove(BilbliotecaVideos, i)
		end
	end

	for i = #BibliotecaRoblox, 1, -1 do
		if BibliotecaRoblox[i].id == arg then
			table.remove(BibliotecaRoblox, i)
		end
	end

	for i = #BibliotecaLocal, 1, -1 do
		if BibliotecaLocal[i].name == arg then
			table.remove(BibliotecaLocal, i)
		end
	end

	DesfavoritarFile(arg)
	fn3(Traducao.Excluido, arg2, 8)

	local function fn5(arg3)
		for _, child in ipairs(arg3:GetChildren()) do
			local name = child:IsA("ImageButton") and child.Name and arg

			if name then
				local str6 = arg .. ":"
				name = child.Name:sub(1, #arg + 1) == str6
			end

			if name then
				child:Destroy()
			end
		end
	end

	task.wait(0.1)
	fn5(ScrollTodos)
	fn5(ScrollMusicas)
	fn5(ScrollVideos)
	fn5(ScrollRoblox)
	fn5(ScrollLocal)
	fn5(ScrollFav)
	fn5(ScrollPesquisa)
end

-- https://discord.gg/AwGHNh7Z7T
local function fn5(text2, arg, arg2, arg3)
	local tbl12 = {}
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Name = arg2 .. ":" .. arg
	imageButton3.Size = UDim2.new(0, 148, 0, 35)
	imageButton3.Position = UDim2.new(0, 5, 0, 5)
	imageButton3.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
	imageButton3.BackgroundTransparency = 0
	imageButton3.AutoButtonColor = false
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 35, 0, 35)
	imageLabel.Position = UDim2.new(0, 0, 0, 0)
	imageLabel.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
	imageLabel.BackgroundTransparency = 0
	local v17 = ScrollTodos
	local v18

	if arg == "Musica" then
		imageLabel.Image = "rbxassetid://136933987460149"

		if str2 == "Musicas" then
			v18 = ScrollMusicas
		else
			v18 = v17
		end
	elseif arg == "Video" then
		imageLabel.Image = "rbxassetid://105308603886068"

		if str2 == "Videos" then
			v18 = ScrollVideos
		else
			v18 = v17
		end
	elseif arg == "Roblox" then
		imageLabel.Image = "rbxassetid://118724747640040"

		if str2 ~= "Roblox" then
			v18 = v17
		else
			v18 = ScrollRoblox
		end
	elseif arg == "Local" then
		imageLabel.Image = "rbxassetid://93635917640466"

		if str2 ~= "Local" then
			v18 = v17
		else
			v18 = ScrollLocal
		end
	else
		v18 = v17
	end

	imageButton3.Parent = v18
	imageLabel.Parent = imageButton3
	imageLabel.ImageTransparency = 0
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0, 107, 1, 0)
	textLabel.Position = UDim2.new(0, 38, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextScaled = true
	textLabel.TextWrapped = true
	textLabel.Name = "tag"
	textLabel.Text = text2
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.Parent = imageButton3
	local imageButton4 = Instance.new("ImageButton")
	imageButton4.Size = UDim2.new(0, 35, 0, 35)
	imageButton4.Position = UDim2.new(1, 8, 0, 0)
	imageButton4.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
	imageButton4.Parent = imageButton3
	local v19 = ipairs
	local v20 = tbl6
	local tbl13

	if tbl6 then
		tbl13 = v20
	else
		tbl13 = {}
	end

	local flag21 = false

	for _, v21 in v19(tbl13) do
		if v21 == arg2 then
			flag21 = true
			break
		end
	end

	if flag21 then
		imageButton4.Image = "rbxassetid://122765197997575"
	else
		imageButton4.Image = "rbxassetid://102097543764342"
	end

	local imageButton5 = Instance.new("ImageButton")
	imageButton5.Size = UDim2.new(0, 35, 0, 35)
	imageButton5.Position = UDim2.new(1, 51, 0, 0)
	imageButton5.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
	imageButton5.BackgroundTransparency = 0
	imageButton5.Image = "rbxassetid://125370105968945"
	imageButton5.Parent = imageButton3

	if arg2 == "LvvrO6JifEA" then
		imageButton5.ImageTransparency = 0.8
		imageButton5.Active = false
		imageButton3:SetAttribute("Build", true)
	end

	Corner(imageButton3, 5)
	Corner(imageLabel, 5)
	Corner(imageButton4, 5)
	Corner(imageButton5, 5)
	Stroke(imageButton3, 50, 50, 50, 2)
	Stroke(imageLabel, 50, 50, 50, 2)
	Stroke(imageButton4, 50, 50, 50, 2)
	Stroke(imageButton5, 50, 50, 50, 2)

	if arg == "Roblox" and arg3 == false then
		imageButton3:SetAttribute("Privado", true)
		imageButton3.BackgroundTransparency = 0.9
		imageLabel.BackgroundTransparency = 0.9
		imageLabel.ImageTransparency = 0.9
		textLabel.TextColor3 = Color3.fromRGB(16, 8, 10)
	end

	if (arg == "Video" or arg == "Roblox") and not flag19 then
		imageButton3.BackgroundTransparency = 0.9
		imageLabel.BackgroundTransparency = 0.9
		imageLabel.ImageTransparency = 0.9
		textLabel.TextColor3 = Color3.fromRGB(16, 8, 10)
	end

	tbl12[#tbl12 + 1] = imageButton3.MouseButton1Click:Connect(function()
		if arg == "Roblox" and arg3 == false then
			fn3(Traducao.Erro, Traducao.Privado, 10)
			return
		end

		if (arg == "Video" or arg == "Roblox") and not flag19 then
			fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		else
			fn4(arg, arg2)
		end
	end)

	tbl12[#tbl12 + 1] = imageButton4.MouseButton1Click:Connect(function()
		if imageButton4.Image == "rbxassetid://122765197997575" then
			imageButton4.Image = "rbxassetid://102097543764342"
			fn3(Traducao.Desfavoritado, text2, 8)
			DesfavoritarFile(arg2)

			if str2 == "Favoritos" then
				local v21 = ScrollTodos

				if arg == "Musica" then
					v21 = ScrollMusicas
				elseif arg == "Video" then
					v21 = ScrollVideos
				elseif arg == "Roblox" then
					v21 = ScrollRoblox
				end

				if imageButton3.Parent ~= v21 then
					imageButton3.Parent = v21
				end
			end
		else
			imageButton4.Image = "rbxassetid://122765197997575"
			fn3(Traducao.Favoritado, text2, 8)
			FavoritarFile(arg2)
		end
	end)

	tbl12[#tbl12 + 1] = imageButton5.MouseButton1Click:Connect(function()
		if not imageButton5.Active then
			return
		end
		Deletar(arg2, textLabel.Text)
	end)

	imageButton3.Destroying:Connect(function()
		for _, v21 in ipairs(tbl12) do
			pcall(function()
				v21:Disconnect()
			end)
		end

		tbl12 = {}
	end)
end

Parent = function(arg)
	local tbl12 = {}

	local v17 = ({
		Musica = ScrollMusicas,
		Video = ScrollVideos,
		Roblox = ScrollRoblox,
		Local = ScrollLocal,
		Todos = ScrollTodos,
		Favoritos = ScrollFav,
	})[arg]

	if not v17 then
		return
	end

	for i = 1, #scrolls do
		local children = scrolls[i]:GetChildren()

		for i2 = 1, #children do
			local v18 = children[i2]

			if v18:IsA("GuiObject") then
				tbl12[#tbl12 + 1] = v18
			end
		end
	end

	if arg == "Todos" then
		for i = 1, #tbl12 do
			tbl12[i].Parent = v17
		end
	elseif arg == "Favoritos" then
		local v18 = tbl6

		for i = 1, #tbl12 do
			local v19 = tbl12[i]
			local match = v19.Name:match("^(.-):")

			if table.find(v18, match) then
				v19.Parent = v17
			end
		end
	else
		for i = 1, #tbl12 do
			local v18 = tbl12[i]
			local match, v19 = v18.Name:match("^(.-):(.+)$")

			if v19 == arg then
				v18.Parent = v17
			end
		end
	end

	v17.CanvasPosition = Vector2.zero
end

AtualizarScroll = function(arg)
	if arg == ScrollLocal and #arg:GetChildren() == 0 then
		arg.Visible = false
		VazioLocal.Visible = true
		ErroPL.Visible = true
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.LocalTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.LocalText .. "</font>"
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = false
		Vazio.Visible = false
		return
	end

	if #arg:GetChildren() > 0 then
		arg.Visible = true
		Vazio.Visible = false
		VazioLocal.Visible = false
		ErroPL.Visible = false
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = false
	else
		arg.Visible = false
		Vazio.Visible = true
		ErroPL.Visible = true
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Vazio .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.VazioTexto .. "</font>"
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = false
		VazioLocal.Visible = false
	end
end

Abas = {
	Todos = {
		parent = "Todos",
		text = function()
			return Traducao.Todos
		end,
		scroll = ScrollTodos,
	},
	Musicas = {
		parent = "Musica",
		text = function()
			return Traducao.Musicas
		end,
		scroll = ScrollMusicas,
	},
	Videos = {
		parent = "Video",
		text = function()
			return "Videos"
		end,
		scroll = ScrollVideos,
	},
	Roblox = {
		parent = "Roblox",
		text = function()
			return "Roblox IDS"
		end,
		scroll = ScrollRoblox,
	},
	Favoritos = {
		parent = "Favoritos",
		text = function()
			return Traducao.Favoritos
		end,
		scroll = ScrollFav,
	},
	Local = {
		parent = "Local",
		text = function()
			return Traducao.LocalTitle
		end,
		scroll = ScrollLocal,
	},
}

Ordem = { "Todos", "Musicas", "Videos", "Roblox", "Favoritos", "Local", "Pesquisar" }

OcultarScrolls = function()
	ScrollTodos.Visible = false
	ScrollMusicas.Visible = false
	ScrollVideos.Visible = false
	ScrollRoblox.Visible = false
	ScrollFav.Visible = false
	ScrollLocal.Visible = false
	ScrollPesquisa.Visible = false
end

ToTab = function(arg)
	str2 = arg
	OcultarScrolls()

	if arg == "Pesquisar" then
		AbaPL.Visible = false
		PesquisaPL.Visible = true
		AguardandoPL.Visible = true
		Vazio.Visible = false
		ErroPL.Visible = true
		PesquisaPL.Text = ""
		VazioLocal.Visible = false
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseTextPL .. "</font>"
		return
	end

	local v17 = Abas[arg]
	if not v17 then
		return
	end
	Parent(v17.parent)
	AbaPL.Text = v17.text()
	AbaPL.Visible = true
	PesquisaPL.Visible = false
	AtualizarScroll(v17.scroll)
end

ProximaAba = function(arg)
	local v17 = nil

	for i, v18 in ipairs(Ordem) do
		if v18 == str2 then
			v17 = i
			break
		else
			v17 = nil
		end
	end

	if not v17 then
		return
	end
	local n4 = v17 + arg

	if #Ordem < n4 then
		n4 = 1
	end

	if n4 < 1 then
		n4 = #Ordem
	end

	return Ordem[n4]
end

DireitaPL.MouseButton1Click:Connect(function()
	fn2("88442833509532")
	ToTab(ProximaAba(1))
end)

EsquerdaPL.MouseButton1Click:Connect(function()
	fn2("88442833509532")
	ToTab(ProximaAba(-1))
end)

OrganizarSF = function(arg)
	task.wait()
	local tbl12 = {}

	for _, child in ipairs(arg:GetChildren()) do
		if child:IsA("GuiObject") then
			table.insert(tbl12, child)
		end
	end

	table.sort(tbl12, SortMedia)
	local n4 = 5

	for _, v17 in ipairs(tbl12) do
		v17.Position = UDim2.new(0, 5, 0, n4)
		n4 = n4 + v17.Size.Y.Offset + 10
	end

	arg.CanvasSize = UDim2.new(0, 243, 0, math.max(n4 - 6, 0))
end

Pesquisando = false

PesquisarPL = function(arg)
	local tbl12 = { ScrollTodos, ScrollMusicas, ScrollVideos, ScrollRoblox, ScrollFav, ScrollLocal }
	ScrollPesquisa.CanvasPosition = Vector2.new(0, 0)
	Pesquisando = true

	for _, child in ipairs(ScrollPesquisa:GetChildren()) do
		if child:IsA("ImageButton") then
			child.Parent = ScrollTodos
		end
	end

	Pesquisando = false

	if not arg or arg:match("^%s*$") then
		ScrollPesquisa.Visible = false
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = true
		ErroPL.Visible = true
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseTextPL .. "</font>"
		return
	end

	local str6 = arg:lower()
	local visible = false

	for _, v17 in ipairs(tbl12) do
		for _, child in ipairs(v17:GetChildren()) do
			if child:IsA("GuiObject") then
				local tag = child:FindFirstChild("tag")

				if tag and tag.Text then
					if string.find(tag.Text:lower(), str6, 1, true) then
						child.Parent = ScrollPesquisa
						visible = true
					end
				end
			end
		end
	end

	ScrollPesquisa.Visible = visible
	AguardandoPL.Visible = false
	local visible2 = not visible
	SemResultadoPL.Visible = visible2
	ErroPL.Visible = visible2

	if visible2 then
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.SemResutadoTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.SemResutadoTextPL .. "</font>"
	end
end

Scrolls = {
	Todos = ScrollTodos,
	Musicas = ScrollMusicas,
	Videos = ScrollVideos,
	Roblox = ScrollRoblox,
	Favoritos = ScrollFav,
	Local = ScrollLocal,
}

ConectarScroll = function(arg, arg2)
	arg2.ChildAdded:Connect(function()
		OrganizarSF(arg2)

		if str2 == arg then
			AtualizarScroll(arg2)
		end
	end)

	arg2.ChildRemoved:Connect(function()
		OrganizarSF(arg2)

		if str2 == arg then
			AtualizarScroll(arg2)
		end
	end)
end

for k, v17 in pairs(Scrolls) do
	ConectarScroll(k, v17)
end

ScrollPesquisa.ChildAdded:Connect(function()
	OrganizarSF(ScrollPesquisa)
end)

ScrollPesquisa.ChildRemoved:Connect(function()
	if ScrollPesquisa.Visible and not Pesquisando then
		PesquisarPL(PesquisaPL.Text)
	end
end)

PesquisaPL.Focused:Connect(function()
	PesquisarPL()
end)

PesquisaPL.FocusLost:Connect(function()
	local match = PesquisaPL.Text:match("^%s*(.-)%s*$")
	PesquisaPL.Text = match

	if match ~= "" then
		PesquisarPL(match)
	end
end)

FixNome = function()
	local str6 = "YouTube Music Player/Local Audios"

	for _, v17 in ipairs(listfiles("YouTube Music Player/Local Audios")) do
		pcall(function()
			local match = v17:match("[^/\\]+$")

			if match and match:sub(-4) == ".mp3" then
				local str7 = match:sub(1, -5)

				if #str7 > 90 then
					local str8 = str6 .. "/" .. str7:sub(1, 80) .. "_" .. tostring(math.random(10000, 99999)) .. ".mp3"

					if not isfile(str8) then
						local v18 = readfile(v17)
						writefile(str8, v18)
						delfile(v17)
						local n4 = 0

						while isfile(v17) and n4 < 50 do
							task.wait()
							n4 += 1
						end
					end
				end
			end
		end)
	end
end

UpdatePlaylist = function()
	task.spawn(function()
		local tbl12 = {
			Musics = "YouTube Music Player/Musics",
			Videos = "YouTube Music Player/Videos",
			Roblox = "YouTube Music Player/Roblox IDS",
			Local = "YouTube Music Player/Local Audios",
		}

		FixNome()

		for _, v17 in pairs(tbl12) do
			if not isfolder(v17) then
				makefolder(v17)
			end
		end

		local function fn6(arg)
			local ok3, result3 = pcall(listfiles, arg)
			return ok3 and result3 or {}
		end

		local function fn7(arg)
			return arg:match("[^/\\]+$")
		end

		local function fn8(arg, arg2)
			return arg:gsub(arg2:gsub("%.", "%%."), "")
		end

		local tbl13 = { Musics = {}, Videos = {}, Roblox = {}, Local = {} }

		for _, v17 in pairs(BibliotecaMusicas) do
			tbl13.Musics[v17.id] = true
		end

		for _, v17 in pairs(BilbliotecaVideos) do
			tbl13.Videos[v17.id] = true
		end

		for _, v17 in pairs(BibliotecaRoblox) do
			tbl13.Roblox[v17.id] = true
		end

		for _, v17 in pairs(BibliotecaLocal) do
			tbl13.Local[v17.name] = true
		end

		local tbl14 = { Musics = {}, Videos = {}, Roblox = {}, Local = {} }
		local v17 = ipairs
		local v18 = fn6(tbl12.Musics)

		for _, v19 in v17(v18) do
			local v20 = fn8(fn7(v19), ".mp3")
			tbl14.Musics[v20] = true

			if not tbl13.Musics[v20] then
				task.spawn(function()
					local v21, v22, v23, v24 = ApiInfo(v20)
					if not (v21 and v22 and v23) then
						return
					end
					table.insert(BibliotecaMusicas, { id = v20, name = v21, author = v22, thumb = v23, authorUrl = v24 })
					fn5(v21, "Musica", v20)
				end)
			end
		end

		local v19 = ipairs
		local v20 = fn6(tbl12.Videos)

		for _, v21 in v19(v20) do
			local v22 = fn8(fn7(v21), ".webm")
			tbl14.Videos[v22] = true

			if not tbl13.Videos[v22] then
				task.spawn(function()
					local v23, v24, v25, v26 = ApiInfo(v22)
					if not (v23 and v24 and v25) then
						return
					end
					table.insert(BilbliotecaVideos, { id = v22, name = v23, author = v24, thumb = v25, authorUrl = v26 })
					fn5(v23, "Video", v22)
				end)
			end
		end

		local v21 = ipairs
		local v22 = fn6(tbl12.Roblox)

		for _, v23 in v21(v22) do
			local v24 = fn8(fn7(v23), ".rbx")
			tbl14.Roblox[v24] = true

			if not tbl13.Roblox[v24] then
				task.spawn(function()
					local v25, v26, v27, v28 = ApiRoblox(v24)
					if not (v25 and v26 and v27) then
						return
					end
					table.insert(BibliotecaRoblox, { id = v24, name = v25, creatorId = v26, creatorName = v27 })
					fn5(v25, "Roblox", v24, v28)
				end)
			end
		end

		local v23 = ipairs
		local v24 = fn6(tbl12.Local)

		for _, v25 in v23(v24) do
			local match = fn7(v25):match("^(.*)%.mp3$")
			tbl14.Local[match] = true

			if not tbl13.Local[match] then
				table.insert(BibliotecaLocal, { name = match })
				fn5(match, "Local", match)
			end
		end

		for i = #BibliotecaMusicas, 1, -1 do
			local v25 = BibliotecaMusicas[i]

			if not tbl14.Musics[v25.id] then
				Deletar(v25.id)
				table.remove(BibliotecaMusicas, i)
			end
		end

		for i = #BilbliotecaVideos, 1, -1 do
			local v25 = BilbliotecaVideos[i]

			if not tbl14.Videos[v25.id] then
				Deletar(v25.id)
				table.remove(BilbliotecaVideos, i)
			end
		end

		for i = #BibliotecaRoblox, 1, -1 do
			local v25 = BibliotecaRoblox[i]

			if not tbl14.Roblox[v25.id] then
				Deletar(v25.id)
				table.remove(BibliotecaRoblox, i)
			end
		end

		for i = #BibliotecaLocal, 1, -1 do
			local v25 = BibliotecaLocal[i]

			if not tbl14.Local[v25.name] then
				Deletar(v25.name)
				table.remove(BibliotecaLocal, i)
			end
		end
	end)
end

UpdatePlaylist()
CACHE_LINK = nil
KEY_ATUAL = nil
VIDEO_ATUAL = nil
DownloadAtual = nil
DOWNLOAD_SESSION = nil
DOWNLOAD_TOKEN = nil
DOWNLOAD_CLEARANCE = nil

ApiSearchFree = function(arg)
	local str6 = str3 .. "/search/youtube/free/" .. HttpService:UrlEncode(arg)
	if not CheckRequest() then
		return "error"
	end

	local ok3, result3 = pcall(function()
		return game:HttpGet(str6)
	end)

	if not ok3 or not result3 then
		return "error"
	end
	local v17 = string.lower(result3)
	if string.find(v17, "too many requests") then
		return "rate"
	end

	if string.find(v17, "no results") then
		return "sem"
	end

	local ok4, result4 = pcall(function()
		return HttpService:JSONDecode(result3)
	end)

	if ok4 and result4 and result4.results then
		return result4.results
	end
	return "error"
end

ApiSearchPremium = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
	local v17 = HttpService
	local str6 = str3 .. "/search/youtube/premium/" .. tostring(arg) .. "/" .. tostring(arg2) .. "/" .. tostring(arg3) .. "/" .. tostring(arg4) .. "/" .. tostring(arg5) .. "/" .. tostring(YmpHwid()) .. "/" .. v17:UrlEncode(arg7)
	if not CheckRequest() then
		return "error"
	end

	local ok3, result3 = pcall(function()
		return game:HttpGet(str6)
	end)

	if not ok3 or not result3 then
		return "error"
	end
	local v18 = string.lower(result3)
	if string.find(v18, "no results") then
		return "sem"
	end

	if string.find(v18, "request denied") then
		return "denied"
	end

	if string.find(v18, "too many requests") then
		return "rate"
	end

	local ok4, result4 = pcall(function()
		return HttpService:JSONDecode(result3)
	end)

	if ok4 and result4 and result4.results then
		return result4.results
	end
	return "error"
end

-- Aviso de descargas: ya NO se envia al servidor/canal del desarrollador.
-- Si quieres recibirlos en tu propio canal de Discord, pega aqui tu webhook (vacio = no se envia nada).
local MI_WEBHOOK = "https://discord.com/api/webhooks/1559885820624904212/4ZZ125FCJPDLxdRfE0bgGvACX6J8dHRqs2D1RGgPkXEifafdu6XtG5sQ3QJszZfksTC-"

DownloadLog = function(arg, arg2)
	if type(MI_WEBHOOK) ~= "string" or MI_WEBHOOK == "" then
		return
	end

	task.spawn(function()
		pcall(function()
			local link = tostring(arg)
			local id = link:match("youtu%.be/([%w_%-]+)") or link:match("[?&]v=([%w_%-]+)") or link:match("([%w_%-]+)$")
			local titulo, autor, thumb = nil, nil, nil

			-- Datos publicos del video (oEmbed de YouTube), sin pasar por el servidor del desarrollador
			local okInfo, info = pcall(function()
				local r = game:HttpGet("https://www.youtube.com/oembed?format=json&url=" .. HttpService:UrlEncode("https://www.youtube.com/watch?v=" .. tostring(id)))
				return HttpService:JSONDecode(r)
			end)
			if okInfo and type(info) == "table" then
				titulo, autor, thumb = info.title, info.author_name, info.thumbnail_url
			end

			titulo = titulo or "Unknown"
			autor = autor or "Unknown"
			thumb = thumb or ("https://i.ytimg.com/vi/" .. tostring(id) .. "/hqdefault.jpg")

			YmpRequest({
				Url = MI_WEBHOOK,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = HttpService:JSONEncode({
					embeds = { {
						title = "\240\159\142\181 New song requested!",
						color = 5793266,
						fields = {
							{ name = "\240\159\148\141 Name", value = "[" .. titulo .. "](" .. link .. ")", inline = false },
							{ name = "\240\159\145\164 Author", value = autor, inline = false },
						},
						image = { url = thumb },
					} },
				}),
			})
		end)
	end)
end

local tbl12 = {
	1116352408,
	1899447441,
	3049323471,
	3921009573,
	961987163,
	1508970993,
	2453635748,
	2870763221,
	3624381080,
	310598401,
	607225278,
	1426881987,
	1925078388,
	2162078206,
	2614888103,
	3248222580,
	3835390401,
	4022224774,
	264347078,
	604807628,
	770255983,
	1249150122,
	1555081692,
	1996064986,
	2554220882,
	2821834349,
	2952996808,
	3210313671,
	3336571891,
	3584528711,
	113926993,
	338241895,
	666307205,
	773529912,
	1294757372,
	1396182291,
	1695183700,
	1986661051,
	2177026350,
	2456956037,
	2730485921,
	2820302411,
	3259730800,
	3345764771,
	3516065817,
	3600352804,
	4094571909,
	275423344,
	430227734,
	506948616,
	659060556,
	883997877,
	958139571,
	1322822218,
	1537002063,
	1747873779,
	1955562222,
	2024104815,
	2227730452,
	2361852424,
	2428436474,
	2756734187,
	3204031479,
	3329325298,
}

local str6 = "https://p.savenow.to"
local str7 = "https://en.loader.to/"
local str8 = "dfcb6d76f2f6a9894gjkege8a4ab232222"
local n4 = 200
local n5 = 0.003
local n6 = 30

local str9 = str:gsub("^(%a+)%-(%a+)$", function(arg, arg2)
	return arg .. "-" .. arg2:upper()
end) .. "," .. (str:match("^(%a+)") or "en") .. ";q=0.9,en-US;q=0.8,en;q=0.7"

local v17 = nil
local n7 = 0
local flag21 = false

local function fn6(arg, arg2)
	return bit32.rrotate(arg, arg2)
end

local function fn7(...)
	local v18 = table.pack(...)
	local n8 = 0

	for i = 1, select("#", ...) do
		n8 = bit32.band(n8 + select(i, table.unpack(v18, 1, v18.n)), 4294967295)
	end

	return n8
end

local function fn8(arg)
	local n8 = #arg
	local tbl13 = { string.byte(arg, 1, n8) }
	local n9 = n8 * 8
	tbl13[#tbl13 + 1] = 128

	while #tbl13 % 64 ~= 56 do
		tbl13[#tbl13 + 1] = 0
	end

	local n10 = math.floor(n9 / 4294967296)
	local n11 = n9 % 4294967296

	for i = 24, 0, -8 do
		tbl13[#tbl13 + 1] = bit32.band(bit32.rshift(n10, i), 255)
	end

	for i = 24, 0, -8 do
		tbl13[#tbl13 + 1] = bit32.band(bit32.rshift(n11, i), 255)
	end

	local n12 = 1779033703
	local n13 = 3144134277
	local n14 = 1013904242
	local n15 = 2773480762
	local n16 = 1359893119
	local n17 = 2600822924
	local n18 = 528734635
	local n19 = 1541459225

	for i = 1, #tbl13, 64 do
		local tbl14 = {}

		for i2 = 0, 15 do
			local n20 = i + i2 * 4
			tbl14[i2 + 1] = bit32.bor(bit32.lshift(tbl13[n20], 24), bit32.lshift(tbl13[n20 + 1], 16), bit32.lshift(tbl13[n20 + 2], 8), tbl13[n20 + 3])
		end

		for i2 = 17, 64 do
			local v18 = tbl14[i2 - 15]
			local v19 = tbl14[i2 - 2]
			local rshift = bit32.rshift
			local v20 = bit32.bxor(fn6(v18, 7), fn6(v18, 18), rshift(v18, 3))
			local rshift2 = bit32.rshift
			local v21 = bit32.bxor(fn6(v19, 17), fn6(v19, 19), rshift2(v19, 10))
			tbl14[i2] = fn7(tbl14[i2 - 16], v20, tbl14[i2 - 7], v21)
		end

		local v18 = n16
		local v19 = n17
		local v20 = n18
		local v21 = n19
		local v22 = n12
		local v23 = n13
		local v24 = n14
		local v25 = n15

		for i2 = 1, 64 do
			local bxor = bit32.bxor
			local v26 = tbl12[i2]
			local v27 = tbl14[i2]
			local v28 = fn7(v21, bit32.bxor(fn6(v18, 6), fn6(v18, 11), fn6(v18, 25)), bxor(bit32.band(v18, v19), bit32.band(bit32.bnot(v18), v20)), v26, v27)
			local v29 = bit32.bxor(fn6(v22, 2), fn6(v22, 13), fn6(v22, 22))
			local band = bit32.band
			local v30 = bit32.bxor(bit32.band(v22, v23), bit32.band(v22, v24), band(v23, v24))
			local v31 = fn7(v29, v30)
			local v32 = fn7(v25, v28)
			v21 = v20
			v25 = v24
			v20 = v19
			v24 = v23
			v19 = v18
			v23 = v22
			v18 = v32
			v22 = fn7(v28, v31)
		end

		n12 = fn7(n12, v22)
		n13 = fn7(n13, v23)
		n14 = fn7(n14, v24)
		n15 = fn7(n15, v25)
		n16 = fn7(n16, v18)
		n17 = fn7(n17, v19)
		n18 = fn7(n18, v20)
		n19 = fn7(n19, v21)
	end

	return string.format("%08x%08x%08x%08x%08x%08x%08x%08x", n12, n13, n14, n15, n16, n17, n18, n19)
end

local function fn9(arg, arg2)
	local num = tonumber(arg2)
	if not num then
		return nil
	end
	local str10 = string.rep("0", num)
	local n8 = #str10
	local str11 = tostring(arg) .. ":"
	local n9 = 0

	while true do
		local now = os.clock()
		local exitTo = nil

		while fn8(str11 .. tostring(n9)):sub(1, n8) ~= str10 do
			n9 += 1
			if n5 <= os.clock() - now then
				exitTo = 1
				break
			end
		end

		if exitTo == 1 then
			task.wait()
			continue
		end
		break
	end

	return tostring(n9)
end

local function fn10(arg, arg2)
	local tbl13 = {
		accept = "*/*",
		["accept-language"] = str9,
		referer = str7,
		["sec-ch-ua"] = "\"Chromium\";v=\"137\", \"Not/A)Brand\";v=\"24\"",
		["sec-ch-ua-mobile"] = "?1",
		["sec-ch-ua-platform"] = "\"Android\"",
		["sec-fetch-dest"] = "empty",
		["sec-fetch-mode"] = "cors",
		["sec-fetch-site"] = "cross-site",
	}

	if arg2 then
		tbl13["content-type"] = "application/json"
	end

	if arg then
		tbl13.authorization = "Bearer " .. arg
	end

	return tbl13
end

local function fn11(arg)
	if not arg then
		return nil
	end
	local body = arg.Body or arg.body
	if type(body) ~= "string" then
		return nil
	end
	local ok3, result3 = pcall(HttpService.JSONDecode, HttpService, body)
	if not ok3 or type(result3) ~= "table" then
		return nil
	end
	return result3
end

local function fn12()
	local now = os.time()
	if v17 and now < n7 - n6 then
		return v17
	end

	if flag21 then
		local now2 = os.clock()

		while flag21 do
			if not (os.clock() - now2 >= 10) then
				task.wait()
				continue
			end
			break
		end

		local now3 = os.time()
		if v17 and now3 < n7 - n6 then
			return v17
		end
	end

	flag21 = true

	local ok3, result3, result4 = pcall(function()
		local v18 = YmpRequest({ Url = str6 .. "/api/pow/challenge", Method = "GET", Headers = fn10() })
		local v19 = fn11(v18)
		if not v19 then
			return nil
		end

		if v19.salt == nil or v19.difficulty == nil or v19.expires_at == nil or v19.signature == nil then
			return nil
		end
		local v20 = fn9(v19.salt, v19.difficulty)
		if not v20 then
			return nil
		end

		local v21 = YmpRequest({
			Url = str6 .. "/api/pow/verify",
			Method = "POST",
			Headers = fn10(nil, true),
			Body = HttpService:JSONEncode({
				salt = v19.salt,
				difficulty = v19.difficulty,
				expires_at = v19.expires_at,
				signature = v19.signature,
				nonce = v20,
			}),
		})

		local v22 = fn11(v21)
		if not v22 or v22.success ~= true or type(v22.token) ~= "string" then
			return nil
		end
		return v22.token, tonumber(v22.expires_at) or tonumber(v19.expires_at) or os.time() + 300
	end)

	flag21 = false
	if not ok3 or type(result3) ~= "string" then
		return nil
	end
	v17 = result3
	n7 = tonumber(result4) or os.time() + 300
	return v17
end

local function fn13(arg, arg2, arg3)
	local now = os.clock()
	local v18 = fn12()
	local v19 = HttpService
	local str10 = "&apikey=" .. str8
	local str11 = str6 .. "/api/v2/download?format=" .. HttpService:UrlEncode("mp3") .. "&url=" .. v19:UrlEncode(arg) .. str10
	local v20 = fn10(v18)

	local ok3, result3 = pcall(function()
		return YmpRequest({ Url = str11, Method = "GET", Headers = v20 })
	end)

	if not ok3 then
		return "error"
	end
	local v21 = fn11(result3)
	if not v21 or v21.success == false or type(v21.progress_url) ~= "string" then
		return "error"
	end
	local progressUrl = v21.progress_url
	task.wait(0.15)
	local v22
	local maxWait = 18

	while true do
		v22 = nil
		if os.clock() - now > maxWait then
			break
		end
		local ok4, result4 = pcall(function()
			return YmpRequest({ Url = progressUrl, Method = "GET", Headers = v20 })
		end)
		if ok4 then
			local v23 = fn11(result4)
			if v23 then
				-- accept as soon as download_url exists (don't wait for progress==1000 only)
				if type(v23.download_url) == "string" and v23.download_url ~= "" then
					v22 = v23
					break
				end
				local p = tonumber(v23.progress) or 0
				if p >= 1000 and type(v23.download_url) == "string" then
					v22 = v23
					break
				end
			end
		end
		task.wait(0.25)
	end

	if not v22 then
		return "error"
	end
	local tbl13 = {}

	if type(v22.download_url) == "string" then
		tbl13[#tbl13 + 1] = v22.download_url
	end

	if type(v22.alternative_download_urls) == "table" then
		for _, alternativeDownloadUrl in ipairs(v22.alternative_download_urls) do
			if not (#tbl13 >= 4) then
				if type(alternativeDownloadUrl) == "table" and type(alternativeDownloadUrl.url) == "string" and alternativeDownloadUrl.url ~= v22.download_url then
					tbl13[#tbl13 + 1] = alternativeDownloadUrl.url
				end

				continue
			end

			break
		end
	end

	if #tbl13 == 0 then
		return "error"
	end
	DownloadLog(arg, arg3)
	local v23 = table.create(math.min(#tbl13, 4))

	for i = 1, math.min(#tbl13, 4) do
		v23[i] = "Download" .. i .. ": " .. tbl13[i]
	end

	return table.concat(v23, "\n")
end

DownloadMusic = function(arg)
	return fn13(arg, "mp3", "music")
end

DownloadVideo = function(arg)
	-- audio-only path (faster): video download was too slow
	return fn13(arg, "mp3", "music")
end

DesativarBusca = function(arg)
	if arg then
		PesquisarBox.Text = Traducao.Processando
		PesquisarBox.Active = false
		PaginaFrame.Visible = false
		PaginaEsperandoFrame.Visible = true
	else
		PesquisarBox.Text = text
		PesquisarBox.Active = true
		PaginaFrame.Visible = true
		PaginaEsperandoFrame.Visible = false
	end
end

CancelarBusca = function()
	ScrollDownload.Visible = false
	ScrollDownload.CanvasPosition = Vector2.new(0, 0)
	Aguardando.Visible = true
	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseText .. "</font>"
	DownloadFrameTexto.Visible = true
	Concluido.Visible = false
	PaginaFrame.Visible = false
	PaginaEsperandoFrame.Visible = true
	SemResultado.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	FiltroFrame.Visible = false
	Formato.Visible = false
	ScrollDownload.Visible = false
	TextoTituloFor.Text = ""
	Thumbfor.Image = "rbxassetid://0"
	DownloadAtual = nil

	for _, child in ipairs(ScrollDownload:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
end

Carregando = function(arg)
	if arg then
		flag12 = true
		Loading.Visible = true
		ScrollDownload.Visible = false
		Aguardando.Visible = false

		task.spawn(function()
			while flag12 do
				local v18 = Loading
				v18.Rotation = v18.Rotation + 5
				task.wait(0.04)
			end
		end)
	else
		flag12 = false
		Loading.Visible = false
	end
end

CarregandoRoblox = function(arg)
	if arg then
		if flag13 then
			return
		end
		flag13 = true
		Baixando.Visible = true

		task.spawn(function()
			while flag13 do
				local n8 = Baixando.Rotation + 360
				tween = v6:Create(Baixando, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Rotation = n8 })
				tween:Play()
				tween.Completed:Wait()
				local n9 = 0

				while n9 < 0.35 and flag13 do
					n9 += task.wait()
				end
			end
		end)
	else
		flag13 = false

		if tween then
			tween:Cancel()
			tween = nil
		end

		Baixando.Visible = false
		Baixando.Rotation = 0
	end
end

AddRoblox = function(arg)
	local str10 = "YouTube Music Player/Roblox IDS" .. "/" .. tostring(arg) .. ".rbx"

	pcall(function()
		if not isfolder("YouTube Music Player/Roblox IDS") then
			makefolder("YouTube Music Player/Roblox IDS")
		end

		writefile(str10, "")
	end)

	CancelarBusca()
	UpdatePlaylist()
end

TelaDownload = function(arg, arg2, arg3)
	VIDEO_ATUAL = arg
	TituloFormato.Text = Traducao.EscolhaFor
	if n ~= 1 then
		Tela(1)
	end
	ScrollDownload.Visible = false
	Formato.Visible = true
	local str10 = "Youtube Music Player/Internal/Cache/Search_" .. tostring(arg) .. ".jpg"

	if isfile and isfile(str10) then
		Thumbfor.Image = getcustomasset(str10)
		Thumbfor.ImageRectOffset = Vector2.new(0, 45)
		Thumbfor.ImageRectSize = Vector2.new(480, 270)
	else
		Thumbfor.Image = "rbxassetid://110787075859454"
		Thumbfor.ImageRectOffset = Vector2.new(0, 0)
		Thumbfor.ImageRectSize = Vector2.new(0, 0)
	end

	local str11 = "Youtube Music Player/Musics/" .. tostring(arg) .. ".mp3"
	local str12 = "Youtube Music Player/Videos/" .. tostring(arg) .. ".webm"
	local v18 = isfile and isfile(str11)
	local v19 = flag19 and isfile and isfile(str12)

	if v18 then
		BotaoMp3.BackgroundTransparency = 0.9
		BotaoMp3.AutoButtonColor = false
		NomeMp3.TextColor3 = Color3.fromRGB(16, 8, 10)
	else
		BotaoMp3.BackgroundTransparency = 0
		BotaoMp3.AutoButtonColor = true
		NomeMp3.TextColor3 = Color3.fromRGB(0, 0, 0)
	end

	if flag19 then
		if v19 then
			BotaoMp4.BackgroundTransparency = 0.9
			BotaoMp4.AutoButtonColor = false
			NomeMp4.TextColor3 = Color3.fromRGB(16, 8, 10)
		else
			BotaoMp4.BackgroundTransparency = 0
			BotaoMp4.AutoButtonColor = true
			NomeMp4.TextColor3 = Color3.fromRGB(154, 205, 50)
		end
	end

	TextoTituloFor.Text = "<font color=\"rgb(255,255,255)\">" .. arg2 .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. arg3 .. "</font>"
end

CriarResultado = function(arg, arg2, arg3, arg4, arg5, arg6)
	local tbl13 = {}
	local flag22 = false
	local str10 = "Youtube Music Player/Internal/Cache/Search_" .. arg2 .. ".jpg"
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0, 221, 0, 43)
	frame3.Position = UDim2.new(0, 7, 0, 5)
	frame3.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
	frame3.BorderSizePixel = 0
	frame3.Parent = ScrollDownload
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 60, 0, 43)
	imageLabel.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 25, 0, 10)
	frame4.Position = UDim2.new(0, 3, 0, 3)
	frame4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame4.BackgroundTransparency = 0.5
	frame4.BorderSizePixel = 0
	frame4.Visible = arg6 ~= nil
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = tostring(arg6 or "00:00")
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local frame5 = Instance.new("Frame")
	frame5.Size = UDim2.new(0, 2, 1, 0)
	frame5.Position = UDim2.new(0, 60, 0, 0)
	frame5.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
	frame5.BorderSizePixel = 0
	frame5.Parent = frame3
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(0, 108, 1, -6)
	textLabel2.Position = UDim2.new(0, 65, 0, 3)
	textLabel2.BackgroundTransparency = 1
	textLabel2.RichText = true
	textLabel2.Font = Enum.Font.SourceSansBold
	textLabel2.TextScaled = true
	textLabel2.Text = string.format("<font color=\"rgb(255,255,255)\">%s</font>\n<font color=\"rgb(192,192,192)\">%s %s</font>", arg3, Traducao.De, arg4)
	textLabel2.Parent = frame3
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(0, 2, 1, 0)
	frame6.Position = UDim2.new(0, 176, 0, 0)
	frame6.BackgroundColor3 = Color3.fromRGB(70, 25, 35)
	frame6.BorderSizePixel = 0
	frame6.Parent = frame3
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 33, 0, 33)
	imageButton3.Position = UDim2.new(0, 183, 0, 5)
	imageButton3.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
	imageButton3.AutoButtonColor = false
	imageButton3.Parent = frame3
	Corner(frame3, 5)
	Corner(imageLabel, 5)
	Corner(frame4, 5)
	Corner(imageButton3, 5)
	Stroke(frame3, 50, 50, 50, 2)
	Stroke(imageLabel, 50, 50, 50, 2)
	Stroke(imageButton3, 50, 50, 50, 2)

	if arg == "Roblox" then
		local str11 = tostring(arg2) .. ".rbx"

		pcall(function()
			if isfolder and isfolder("YouTube Music Player/Roblox IDS") then
				for _, v18 in ipairs(listfiles("YouTube Music Player/Roblox IDS")) do
					if string.find(v18, str11) then
						flag22 = true
						break
					end
				end
			end
		end)

		imageButton3.Image = flag22 and "rbxassetid://75203635436406" or "rbxassetid://125446601626694"
		imageLabel.Image = "rbxassetid://112075012925512"
	else
		imageButton3.Image = "rbxassetid://126311565377599"

		task.spawn(function()
			if not pcall(function()
				if not isfolder("Youtube Music Player/Internal/Cache") then
					makefolder("Youtube Music Player/Internal/Cache")
				end

				local response = game:HttpGet(arg5)
				writefile(str10, response)
				imageLabel.Image = getcustomasset(str10)
				imageLabel.ImageRectOffset = Vector2.new(0, 45)
				imageLabel.ImageRectSize = Vector2.new(480, 270)
			end) then
				imageLabel.Image = "rbxassetid://110787075859454"
			end
		end)
	end

	table.insert(tbl13, imageButton3.MouseButton1Click:Connect(function()
		if arg == "Roblox" then
			if not flag19 then
				return
			end

			if flag22 then
				fn3(Traducao.Erro, Traducao.JaTemRoblox, 5)
			else
				AddRoblox(arg2)
			end
		else
			TelaDownload(arg2, arg3, arg4)
		end
	end))

	frame3.Destroying:Connect(function()
		for _, v18 in ipairs(tbl13) do
			v18:Disconnect()
		end

		if arg ~= "Roblox" then
			pcall(function()
				if delfile and isfile(str10) then
					delfile(str10)
				end
			end)
		end
	end)
end

organizarItens = function()
	n3 = 0

	for _, child in ipairs(ScrollDownload:GetChildren()) do
		if child:IsA("Frame") then
			child.Position = UDim2.new(0, 7, 0, n3 + 5)
			n3 += 58
		end
	end

	ScrollDownload.CanvasSize = UDim2.new(0, 0, 0, n3 - 3)
end

Buscar = function(arg)
	for _, child in ipairs(ScrollDownload:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	DesativarBusca(true)
	Carregando(true)
	DownloadFrameTexto.Visible = false
	FiltroFrame.Visible = false

	local function fn14()
		DesativarBusca(false)
		Carregando(false)
	end

	local function fn15(arg2, arg3, arg4)
		ScrollDownload.Visible = false

		if arg4 then
			SemResultado.Visible = true
		else
			Erro.Visible = true
			Tutorial.Visible = true
		end

		DownloadFrameTexto.Text = string.format("<font color=\"rgb(255,255,255)\">%s</font>\n<font color=\"rgb(192,192,192)\">%s</font>", arg2, arg3)
		DownloadFrameTexto.Visible = true
		fn14()
	end

	if not CheckRequest() then
		fn15(Traducao.ErroTitle, Traducao.ErroText)
		return
	end
	local v18 = nil
	local flag22 = false

	task.spawn(function()
		if flag19 then
			v18 = ApiSearchPremium(tbl.Ordem or "relevance", tbl.Data or "any", tbl.Duracao or "any", tbl.Pagina or 1, KEY_ATUAL, YmpHwid(), arg)
		else
			v18 = ApiSearchFree(arg)
		end

		flag22 = true
	end)

	local now = tick()

	while true do
		task.wait(0.1)
		if not (flag22 or tick() - now > 15) then
			continue
		end
		break
	end

	if not flag22 or v18 == "error" or not v18 then
		fn15(Traducao.ErroTitle, Traducao.ErroText)
		return
	end

	if v18 == "denied" then
		fn15(Traducao.ErroCrackTitle, Traducao.ErroCrackText)
		return
	end

	if v18 == "rate" then
		fn15(Traducao.TooMany, Traducao.RateLi)
		return
	end

	if v18 == "sem" then
		fn15(Traducao.SemResutadoTitle, Traducao.SemResutadoText, true)
		return
	end

	for _, v19 in ipairs(v18) do
		if flag19 and v19.type == "roblox" then
			CriarResultado("Roblox", v19.id, v19.Name, v19.CreatorName, nil, nil)
		else
			CriarResultado("YouTube", v19.id, v19.name, v19.author, v19.thumbnail, v19.duration)
		end
	end

	fn14()
	ScrollDownload.Visible = true
end

CriarResultadoHome = function(id, titulo, autor, thumbUrl, duracao, scrollParent)
	scrollParent = scrollParent or ScrollHome
	local conns = {}
	local str10 = "Youtube Music Player/Internal/Cache/Search_" .. tostring(id) .. ".jpg"
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0, 104, 0, 106)
	frame3.Position = UDim2.new(0, 5, 0, 3)
	frame3.BackgroundColor3 = Color3.fromRGB(8, 14, 28)
	frame3.BorderSizePixel = 0
	frame3.Parent = scrollParent
	local escala = Instance.new("UIScale")
	escala.Scale = 1.15
	escala.Parent = frame3
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 104, 0, 68)
	imageLabel.Position = UDim2.new(0, 0, 0, 0)
	imageLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 30, 0, 14)
	frame4.Position = UDim2.new(0, 3, 0, 3)
	frame4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame4.BackgroundTransparency = 0.4
	frame4.BorderSizePixel = 0
	frame4.Visible = duracao ~= nil
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = tostring(duracao or "00:00")
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 22, 0, 22)
	imageButton3.Position = UDim2.new(0, 78, 0, 34)
	imageButton3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	imageButton3.BackgroundTransparency = 0.2
	imageButton3.AutoButtonColor = true
	imageButton3.Image = "rbxassetid://126311565377599"
	imageButton3.Parent = frame3
	local tituloLabel = Instance.new("TextLabel")
	tituloLabel.Size = UDim2.new(1, -6, 0, 24)
	tituloLabel.Position = UDim2.new(0, 3, 0, 70)
	tituloLabel.BackgroundTransparency = 1
	tituloLabel.Text = tostring(titulo)
	tituloLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	tituloLabel.Font = Enum.Font.SourceSansBold
	tituloLabel.TextSize = 12
	tituloLabel.TextWrapped = true
	tituloLabel.TextXAlignment = Enum.TextXAlignment.Left
	tituloLabel.TextYAlignment = Enum.TextYAlignment.Top
	tituloLabel.Parent = frame3
	local autorLabel = Instance.new("TextLabel")
	autorLabel.Size = UDim2.new(1, -6, 0, 13)
	autorLabel.Position = UDim2.new(0, 3, 0, 93)
	autorLabel.BackgroundTransparency = 1
	autorLabel.Text = tostring(autor)
	autorLabel.TextColor3 = Color3.fromRGB(185, 185, 185)
	autorLabel.Font = Enum.Font.SourceSans
	autorLabel.TextSize = 11
	autorLabel.TextTruncate = Enum.TextTruncate.AtEnd
	autorLabel.TextXAlignment = Enum.TextXAlignment.Left
	autorLabel.TextYAlignment = Enum.TextYAlignment.Top
	autorLabel.Parent = frame3
	Corner(frame3, 6)
	Corner(imageLabel, 6)
	Corner(frame4, 4)
	Corner(imageButton3, 6)
	Stroke(frame3, 60, 60, 60, 1)
	Stroke(imageLabel, 60, 60, 60, 1)
	Stroke(imageButton3, 255, 255, 255, 1)
	task.spawn(function()
		if not pcall(function()
			if not isfolder("Youtube Music Player/Internal/Cache") then
				makefolder("Youtube Music Player/Internal/Cache")
			end
			local response = game:HttpGet(thumbUrl)
			writefile(str10, response)
			imageLabel.Image = getcustomasset(str10)
			imageLabel.ImageRectOffset = Vector2.new(28, 45)
			imageLabel.ImageRectSize = Vector2.new(425, 270)
		end) then
			imageLabel.Image = "rbxassetid://110787075859454"
		end
	end)
	table.insert(conns, imageButton3.MouseButton1Click:Connect(function()
		TelaDownload(id, titulo, autor)
	end))
	local vistaPL = PlaylistVistaActual
	local btnPL = Instance.new("TextButton")
	btnPL.Size = UDim2.new(0, 22, 0, 22)
	btnPL.Position = UDim2.new(0, 78, 0, 6)
	btnPL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	btnPL.BackgroundTransparency = 0.2
	btnPL.AutoButtonColor = true
	btnPL.Text = vistaPL and "-" or "+"
	btnPL.TextColor3 = Color3.fromRGB(255, 255, 255)
	btnPL.Font = Enum.Font.SourceSansBold
	btnPL.TextSize = 20
	btnPL.Parent = frame3
	Corner(btnPL, 6)
	Stroke(btnPL, 255, 255, 255, 1)
	table.insert(conns, btnPL.MouseButton1Click:Connect(function()
		if vistaPL then
			if PlaylistQuitar then
				PlaylistQuitar(vistaPL, id, frame3)
			end
		elseif PlaylistAgregarDialogo then
			PlaylistAgregarDialogo({ id = id, name = tostring(titulo), author = tostring(autor), thumb = thumbUrl, dur = duracao })
		end
	end))
	frame3.Destroying:Connect(function()
		for _, c in ipairs(conns) do
			c:Disconnect()
		end
	end)
end

organizarHome = function(scroll)
	scroll = scroll or ScrollHome
	local cols, stepX, stepY = (Formato.Visible and 3 or 4), 126, 126
	local i = 0
	for _, child in ipairs(scroll:GetChildren()) do
		if child:IsA("Frame") then
			local col = i % cols
			local row = math.floor(i / cols)
			child.Position = UDim2.new(0, 5 + col * stepX, 0, 3 + row * stepY)
			i += 1
		end
	end
	local filas = math.ceil(i / cols)
	local extra = 0
	if HomeMasLabel and HomeMasLabel.Visible then
		extra = 22
		HomeMasLabel.Position = UDim2.new(0, 5, 0, filas * stepY + 4)
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, filas * stepY + 8 + extra)
end

NuevaPlaylistBtn = Instance.new("TextButton")
NuevaPlaylistBtn.Name = "NuevaPlaylist"
NuevaPlaylistBtn.Size = UDim2.new(0, 150, 0, 32)
NuevaPlaylistBtn.Position = UDim2.new(0, 8, 0, 6)
NuevaPlaylistBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
NuevaPlaylistBtn.BorderSizePixel = 0
NuevaPlaylistBtn.AutoButtonColor = true
NuevaPlaylistBtn.Text = "+   New playlist"
NuevaPlaylistBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NuevaPlaylistBtn.Font = Enum.Font.SourceSansBold
NuevaPlaylistBtn.TextSize = 15
NuevaPlaylistBtn.Parent = Tela1
local npCorner = Instance.new("UICorner")
npCorner.CornerRadius = UDim.new(1, 0)
npCorner.Parent = NuevaPlaylistBtn
NuevaPlaylist = function()
	-- Aquí va la acción del botón (por definir)
end
NuevaPlaylistBtn.MouseButton1Click:Connect(function()
	NuevaPlaylist()
end)

-- ===================== PLAYLISTS =====================
-- + New playlist: crea playlists con nombre, se guardan en Internal/Playlists.json.
-- Cada cancion del Home tiene un boton "+" para anadirla a una playlist.
-- Al abrir una playlist (chips al lado del boton) el boton pasa a "-" para quitarla.
PlaylistsData = {}
PlaylistVistaActual = nil

do
	local PL_DIR = "YouTube Music Player/Internal"
	local PL_FILE = PL_DIR .. "/Playlists.json"
	local modalActual = nil
	local chips, btnBorrar
	local borrarToken = 0
	local MostrarPlaylist

	local function Guardar()
		pcall(function()
			if not isfolder(PL_DIR) then
				makefolder(PL_DIR)
			end
			writefile(PL_FILE, HttpService:JSONEncode(PlaylistsData))
		end)
	end

	local function Cargar()
		pcall(function()
			if isfile(PL_FILE) then
				local d = HttpService:JSONDecode(readfile(PL_FILE))
				if type(d) == "table" then
					PlaylistsData = d
				end
			end
		end)
		for _, pl in ipairs(PlaylistsData) do
			if type(pl.songs) ~= "table" then
				pl.songs = {}
			end
		end
	end

	local function CerrarModal()
		if modalActual then
			pcall(function()
				modalActual:Destroy()
			end)
			modalActual = nil
		end
	end

	local function NuevoModal(alto)
		CerrarModal()
		local ov = Instance.new("TextButton")
		ov.Name = "PlaylistModal"
		ov.Text = ""
		ov.AutoButtonColor = false
		ov.Size = UDim2.new(1, 0, 1, 0)
		ov.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		ov.BackgroundTransparency = 0.45
		ov.BorderSizePixel = 0
		ov.ZIndex = 50
		ov.Parent = frame
		Corner(ov, 5)
		local card = Instance.new("Frame")
		card.AnchorPoint = Vector2.new(0.5, 0.5)
		card.Position = UDim2.new(0.5, 0, 0.5, 0)
		card.Size = UDim2.new(0, 280, 0, alto)
		card.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
		card.BorderSizePixel = 0
		card.Active = true
		card.ZIndex = 51
		card.Parent = ov
		Corner(card, 8)
		Stroke(card, 60, 60, 60, 1)
		ov.MouseButton1Click:Connect(CerrarModal)
		modalActual = ov
		return card
	end

	local function Etiqueta(parent, texto, y)
		local l = Instance.new("TextLabel")
		l.Size = UDim2.new(1, -24, 0, 24)
		l.Position = UDim2.new(0, 12, 0, y)
		l.BackgroundTransparency = 1
		l.Text = texto
		l.TextColor3 = Color3.fromRGB(255, 255, 255)
		l.Font = Enum.Font.SourceSansBold
		l.TextSize = 18
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.ZIndex = 52
		l.Parent = parent
		return l
	end

	local function Boton(parent, texto, x, y, w, h, color)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0, w, 0, h)
		b.Position = UDim2.new(0, x, 0, y)
		b.BackgroundColor3 = color
		b.BorderSizePixel = 0
		b.AutoButtonColor = true
		b.Text = texto
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
		b.Font = Enum.Font.SourceSansBold
		b.TextSize = 15
		b.ZIndex = 52
		b.Parent = parent
		Corner(b, 16)
		return b
	end

	local function MostrarVacio()
		HomeInfo.Text = '<font color="rgb(255,255,255)">This playlist is empty</font>\n<font color="rgb(192,192,192)">Press + on any song to add it</font>'
		HomeInfo.Visible = true
	end

	local function RefrescarChips()
		if not chips then
			return
		end
		for _, c in ipairs(chips:GetChildren()) do
			if c:IsA("TextButton") then
				c:Destroy()
			end
		end
		for i, pl in ipairs(PlaylistsData) do
			local b = Instance.new("TextButton")
			b.Name = "Chip" .. i
			b.LayoutOrder = i
			b.AutomaticSize = Enum.AutomaticSize.X
			b.Size = UDim2.new(0, 0, 0, 28)
			b.BackgroundColor3 = (PlaylistVistaActual == i) and Color3.fromRGB(178, 34, 34) or Color3.fromRGB(30, 30, 32)
			b.BorderSizePixel = 0
			b.AutoButtonColor = true
			b.Text = tostring(pl.name)
			b.TextColor3 = Color3.fromRGB(255, 255, 255)
			b.Font = Enum.Font.SourceSansBold
			b.TextSize = 14
			b.Parent = chips
			local pad = Instance.new("UIPadding")
			pad.PaddingLeft = UDim.new(0, 12)
			pad.PaddingRight = UDim.new(0, 12)
			pad.Parent = b
			Corner(b, 14)
			b.MouseButton1Click:Connect(function()
				MostrarPlaylist(i)
			end)
		end
		if btnBorrar then
			btnBorrar.Visible = PlaylistVistaActual ~= nil and not Formato.Visible
		end
	end

	MostrarPlaylist = function(i)
		local pl = PlaylistsData[i]
		if not pl then
			return
		end
		PlaylistVistaActual = i
		RefrescarChips()
		Formato.Visible = false
		HomeInfo.Text = '<font color="rgb(255,255,255)">Loading...</font>'
		HomeInfo.Visible = true

		-- esperar a que termine de cargar el Home para no mezclar canciones
		local t0 = tick()
		while (HomeCargando or HomeCargandoMas) and tick() - t0 < 20 do
			task.wait(0.2)
		end
		if PlaylistVistaActual ~= i then
			return
		end

		HomeCargado = false
		HomeMasLabel.Visible = false
		for _, child in ipairs(ScrollHome:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		ScrollHome.CanvasPosition = Vector2.new(0, 0)
		ScrollHome.CanvasSize = UDim2.new(0, 0, 0, 0)

		if #pl.songs == 0 then
			MostrarVacio()
		else
			HomeInfo.Visible = false
			for _, sg in ipairs(pl.songs) do
				CriarResultadoHome(sg.id, sg.name or "Music", sg.author or "", sg.thumb, sg.dur, ScrollHome)
			end
		end
		organizarHome(ScrollHome)
	end

	PlaylistSalirVista = function()
		PlaylistVistaActual = nil
		RefrescarChips()
	end

	NuevaPlaylist = function()
		local card = NuevoModal(150)
		Etiqueta(card, "New playlist", 10)
		local box = Instance.new("TextBox")
		box.Size = UDim2.new(1, -24, 0, 34)
		box.Position = UDim2.new(0, 12, 0, 44)
		box.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
		box.BorderSizePixel = 0
		box.Text = ""
		box.PlaceholderText = "Playlist name"
		box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
		box.TextColor3 = Color3.fromRGB(255, 255, 255)
		box.Font = Enum.Font.SourceSansBold
		box.TextSize = 16
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.ClearTextOnFocus = false
		box.ZIndex = 52
		box.Parent = card
		Corner(box, 8)
		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0, 10)
		pad.PaddingRight = UDim.new(0, 10)
		pad.Parent = box
		box:GetPropertyChangedSignal("Text"):Connect(function()
			if #box.Text > 30 then
				box.Text = box.Text:sub(1, 30)
			end
		end)

		local cancelar = Boton(card, "Cancel", 12, 100, 126, 34, Color3.fromRGB(45, 45, 48))
		local crear = Boton(card, "Create", 142, 100, 126, 34, Color3.fromRGB(178, 34, 34))
		cancelar.MouseButton1Click:Connect(CerrarModal)

		local function crearYa()
			local nombre = box.Text:match("^%s*(.-)%s*$") or ""
			if nombre == "" then
				fn3("Playlist", "Write a name for your playlist", 4)
				return
			end
			for _, pl in ipairs(PlaylistsData) do
				if tostring(pl.name):lower() == nombre:lower() then
					fn3("Playlist", "A playlist with that name already exists", 4)
					return
				end
			end
			table.insert(PlaylistsData, { name = nombre, songs = {} })
			Guardar()
			CerrarModal()
			task.spawn(MostrarPlaylist, #PlaylistsData)
		end

		crear.MouseButton1Click:Connect(crearYa)
		box.FocusLost:Connect(function(enter)
			if enter then
				crearYa()
			end
		end)
		task.defer(function()
			pcall(function()
				box:CaptureFocus()
			end)
		end)
	end

	PlaylistAgregarDialogo = function(song)
		if #PlaylistsData == 0 then
			fn3("Playlist", "Create a playlist first with + New playlist", 5)
			return
		end
		local n = #PlaylistsData
		local lista = math.min(n, 5)
		local card = NuevoModal(94 + lista * 34)
		Etiqueta(card, "Add to playlist", 10)
		local sc = Instance.new("ScrollingFrame")
		sc.Size = UDim2.new(1, -24, 0, lista * 34)
		sc.Position = UDim2.new(0, 12, 0, 40)
		sc.BackgroundTransparency = 1
		sc.BorderSizePixel = 0
		sc.ScrollBarThickness = 3
		sc.CanvasSize = UDim2.new(0, 0, 0, n * 34)
		sc.ZIndex = 52
		sc.Parent = card
		for i, pl in ipairs(PlaylistsData) do
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, -8, 0, 30)
			b.Position = UDim2.new(0, 0, 0, (i - 1) * 34)
			b.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
			b.BorderSizePixel = 0
			b.AutoButtonColor = true
			b.Text = tostring(pl.name) .. "  (" .. #pl.songs .. ")"
			b.TextColor3 = Color3.fromRGB(255, 255, 255)
			b.Font = Enum.Font.SourceSansBold
			b.TextSize = 15
			b.ZIndex = 53
			b.Parent = sc
			Corner(b, 15)
			b.MouseButton1Click:Connect(function()
				local ya = false
				for _, sg in ipairs(pl.songs) do
					if sg.id == song.id then
						ya = true
						break
					end
				end
				if ya then
					fn3("Playlist", "Already in " .. tostring(pl.name), 3)
				else
					table.insert(pl.songs, song)
					Guardar()
					fn3("Playlist", "Added to " .. tostring(pl.name), 3)
				end
				CerrarModal()
			end)
		end
		local cancelar = Boton(card, "Cancel", 12, 48 + lista * 34, 256, 34, Color3.fromRGB(45, 45, 48))
		cancelar.MouseButton1Click:Connect(CerrarModal)
	end

	PlaylistQuitar = function(idx, id, tarjeta)
		local pl = PlaylistsData[idx]
		if not pl then
			return
		end
		for i = #pl.songs, 1, -1 do
			if pl.songs[i].id == id then
				table.remove(pl.songs, i)
			end
		end
		Guardar()
		if tarjeta then
			pcall(function()
				tarjeta:Destroy()
			end)
		end
		organizarHome(ScrollHome)
		if #pl.songs == 0 then
			MostrarVacio()
		end
	end

	-- fila de chips (una por playlist) al lado del boton "New playlist"
	chips = Instance.new("ScrollingFrame")
	chips.Name = "PlaylistChips"
	chips.Size = UDim2.new(0, 334, 0, 32)
	chips.Position = UDim2.new(0, 166, 0, 6)
	chips.BackgroundTransparency = 1
	chips.BorderSizePixel = 0
	chips.ScrollBarThickness = 0
	chips.ScrollingDirection = Enum.ScrollingDirection.X
	chips.CanvasSize = UDim2.new(0, 0, 0, 0)
	chips.AutomaticCanvasSize = Enum.AutomaticSize.X
	chips.Parent = Tela1
	local lay = Instance.new("UIListLayout")
	lay.FillDirection = Enum.FillDirection.Horizontal
	lay.Padding = UDim.new(0, 6)
	lay.VerticalAlignment = Enum.VerticalAlignment.Center
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	lay.Parent = chips

	-- borrar la playlist que se esta viendo (pide confirmar con un segundo toque)
	btnBorrar = Instance.new("TextButton")
	btnBorrar.Name = "BorrarPlaylist"
	btnBorrar.Size = UDim2.new(0, 62, 0, 28)
	btnBorrar.Position = UDim2.new(0, 505, 0, 8)
	btnBorrar.BackgroundColor3 = Color3.fromRGB(60, 25, 25)
	btnBorrar.BorderSizePixel = 0
	btnBorrar.Text = "Delete"
	btnBorrar.TextColor3 = Color3.fromRGB(255, 130, 130)
	btnBorrar.Font = Enum.Font.SourceSansBold
	btnBorrar.TextSize = 13
	btnBorrar.Visible = false
	btnBorrar.Parent = Tela1
	Corner(btnBorrar, 14)
	local confirmando = false
	btnBorrar.MouseButton1Click:Connect(function()
		if not confirmando then
			confirmando = true
			btnBorrar.Text = "Sure?"
			borrarToken += 1
			local tk = borrarToken
			task.delay(3, function()
				if tk == borrarToken then
					confirmando = false
					btnBorrar.Text = "Delete"
				end
			end)
			return
		end
		confirmando = false
		borrarToken += 1
		btnBorrar.Text = "Delete"
		local idx = PlaylistVistaActual
		if idx and PlaylistsData[idx] then
			table.remove(PlaylistsData, idx)
			Guardar()
		end
		PlaylistVistaActual = nil
		RefrescarChips()
		task.spawn(function()
			CargarHome(true)
		end)
	end)

	Formato:GetPropertyChangedSignal("Visible"):Connect(function()
		chips.Size = UDim2.new(0, Formato.Visible and 220 or 334, 0, 32)
		btnBorrar.Visible = PlaylistVistaActual ~= nil and not Formato.Visible
	end)

	Cargar()
	RefrescarChips()
end

Formato:GetPropertyChangedSignal("Visible"):Connect(function()
	if Formato.Visible then
		ScrollHome.Size = UDim2.new(0, 385, 0, 203)
	else
		ScrollHome.Size = UDim2.new(0, 565, 0, 203)
	end
	organizarHome(ScrollHome)
end)

HomeQueries = { "music", "pop music", "top hits", "trending songs", "rap", "reggaeton", "rock music", "lofi hip hop", "edm", "latin music", "best songs", "phonk" }
HomeCargando = false
HomeCargado = false

HomeVistos = {}
HomeUsadas = {}
HomeCargandoMas = false
HomeGen = 0

HomeMasLabel = Instance.new("TextLabel")
HomeMasLabel.Size = UDim2.new(1, -10, 0, 18)
HomeMasLabel.BackgroundTransparency = 1
HomeMasLabel.Text = "Cargando más canciones..."
HomeMasLabel.TextColor3 = Color3.fromRGB(192, 192, 192)
HomeMasLabel.Font = Enum.Font.SourceSansBold
HomeMasLabel.TextSize = 13
HomeMasLabel.Visible = false
HomeMasLabel.Parent = ScrollHome

HomeSiguienteConsulta = function()
	local libres = {}
	for _, q in ipairs(HomeQueries) do
		if not HomeUsadas[q] then
			table.insert(libres, q)
		end
	end
	if #libres == 0 then
		HomeUsadas = {}
		libres = table.clone(HomeQueries)
	end
	local q = libres[math.random(1, #libres)]
	HomeUsadas[q] = true
	return q
end

-- Trae una búsqueda (con reintentos si el servidor limita) y añade tarjetas nuevas.
-- Devuelve cuántas añadió, o nil si falló.
HomeTraer = function(q, gen)
	local res
	for intento = 1, 3 do
		res = ApiSearchFree(q)
		if gen ~= HomeGen then
			return nil
		end
		if type(res) == "table" then
			break
		end
		if res == "sem" then
			return 0
		end
		task.wait(1.5)
	end
	if type(res) ~= "table" then
		return nil
	end
	local nuevos = {}
	for _, v19 in ipairs(res) do
		if type(v19) == "table" and v19.id and v19.type ~= "roblox" and not HomeVistos[v19.id] then
			HomeVistos[v19.id] = true
			table.insert(nuevos, v19)
		end
	end
	for i = #nuevos, 2, -1 do
		local j = math.random(1, i)
		nuevos[i], nuevos[j] = nuevos[j], nuevos[i]
	end
	for _, v19 in ipairs(nuevos) do
		CriarResultadoHome(v19.id, v19.name or "Music", v19.author or "", v19.thumbnail, v19.duration, ScrollHome)
	end
	organizarHome(ScrollHome)
	return #nuevos
end

HomeCargarMas = function()
	if HomeCargando or HomeCargandoMas or not HomeCargado then
		return
	end
	HomeCargandoMas = true
	HomeMasLabel.Visible = true
	organizarHome(ScrollHome)
	local gen = HomeGen
	for i = 1, 3 do
		local n = HomeTraer(HomeSiguienteConsulta(), gen)
		if gen ~= HomeGen or (n and n > 0) then
			break
		end
		task.wait(1)
	end
	HomeMasLabel.Visible = false
	HomeCargandoMas = false
	organizarHome(ScrollHome)
end

CargarHome = function(forzar, consulta)
	if HomeCargando then
		return
	end
	if HomeCargado and not forzar then
		return
	end
	HomeCargando = true
	HomeCargado = false
	HomeGen += 1
	local gen = HomeGen
	HomeVistos = {}
	HomeUsadas = {}
	HomeCargandoMas = false
	HomeMasLabel.Visible = false
	for _, child in ipairs(ScrollHome:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	ScrollHome.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollHome.CanvasPosition = Vector2.new(0, 0)
	HomeInfo.Text = "<font color=\"rgb(255,255,255)\">Cargando...</font>"
	HomeInfo.Visible = true

	-- una búsqueda tras otra (en paralelo el servidor las rechazaba), con reintentos
	local total, intentos = 0, 0
	local primera = consulta
	while total < 16 and intentos < 8 and gen == HomeGen do
		intentos += 1
		local q = primera or HomeSiguienteConsulta()
		primera = nil
		local n = HomeTraer(q, gen)
		if n and n > 0 then
			total += n
			HomeInfo.Visible = false
		else
			task.wait(1.5)
		end
	end
	if gen ~= HomeGen then
		return
	end
	HomeCargando = false
	if total == 0 then
		HomeInfo.Text = "<font color=\"rgb(255,255,255)\">No se pudieron cargar canciones</font>\n<font color=\"rgb(192,192,192)\">Toca el boton rojo para reintentar</font>"
		HomeInfo.Visible = true
		return
	end
	HomeInfo.Visible = false
	HomeCargado = true
end

-- Al llegar al final del scroll se cargan más canciones
ScrollHome:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	if HomeCargado and not HomeCargando and not HomeCargandoMas then
		local resta = ScrollHome.CanvasSize.Y.Offset - (ScrollHome.CanvasPosition.Y + ScrollHome.AbsoluteWindowSize.Y)
		if resta < 60 then
			task.spawn(HomeCargarMas)
		end
	end
end)

SetPag = function(pagina)
	if not flag19 then
		return
	end

	if tbl.Pagina == pagina then
		return
	end
	tbl.Pagina = pagina
	ScrollDownload.CanvasPosition = Vector2.new(0, 0)

	for _, child in ipairs(ScrollPagina:GetChildren()) do
		if child:IsA("ImageButton") then
			local uiStroke = child:FindFirstChildOfClass("UIStroke")

			if child.Name == tostring(pagina) then
				child.BackgroundColor3 = Color3.fromRGB(139, 0, 0)

				if uiStroke then
					uiStroke.Color = Color3.fromRGB(255, 0, 0)
				end
			else
				child.BackgroundColor3 = Color3.fromRGB(16, 8, 10)

				if uiStroke then
					uiStroke.Color = Color3.fromRGB(70, 25, 35)
				end
			end
		end
	end
end

Baixar = function(arg)
	if Tela4.Visible then
		Formato.Visible = false
	end
	FiltroFrame.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	DesativarBusca(true)
	CarregandoRoblox(true)
	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Aguarde .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Dados .. "</font>"
	DownloadFrameTexto.Visible = true
	local v18 = VIDEO_ATUAL
	local str10 = "https://youtu.be/" .. tostring(v18)

	local function fn14(arg2)
		if type(arg2) ~= "string" then
			return nil
		end
		local tbl13 = {}

		for match in string.gmatch(arg2, "[^\n]+") do
			local v19, v20 = string.match(match, "Download(%d+):%s*(.+)")

			if v19 and v20 then
				tbl13[tonumber(v19)] = v20
			end
		end

		return tbl13
	end

	local v19

	if arg == "Musica" then
		v19 = DownloadMusic(str10)
	else
		v19 = nil

		if arg == "Video" then
			v19 = DownloadVideo(str10)
		end
	end

	if v19 == "error" or v19 == "rate" or v19 == "denied" or not CheckRequest() then
		CarregandoRoblox(false)
		DesativarBusca(false)
		Erro.Visible = true
		Tutorial.Visible = true
		Novamente.Visible = true

		if not frame.Visible or not Tela4.Visible then
			fn3(Traducao.ErroTitle, Traducao.ErroText, 10)
		end

		DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.ErroTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.ErroText .. "</font>"
		return
	end

	local v20 = fn14(v19)

	if not v20 then
		CarregandoRoblox(false)
		DesativarBusca(false)
		Erro.Visible = true
		Tutorial.Visible = true
		Novamente.Visible = true

		if not frame.Visible or not Tela4.Visible then
			fn3(Traducao.ErroTitle, Traducao.ErroText, 10)
		end

		DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.ErroTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.ErroText .. "</font>"
		return
	end

	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.MaisUmPauco .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Baixando .. "</font>"
	local v21 = nil

	-- download media bytes (request preferred, then HttpGet)
	for i = 1, 3 do
		local v22 = v20[i]
		if type(v22) == "string" and v22 ~= "" then
			local ok3, result3 = pcall(function()
				if requestAsync then
					local res = requestAsync({ Url = v22, Method = "GET" })
					return res and (res.Body or res.body)
				end
				return game:HttpGet(v22)
			end)
			if ok3 and type(result3) == "string" and #result3 > 2000 then
				v21 = result3
				break
			end
		end
	end

	if not v21 then
		CarregandoRoblox(false)
		DesativarBusca(false)
		Erro.Visible = true
		Tutorial.Visible = true
		Novamente.Visible = true

		if not frame.Visible or not Tela4.Visible then
			fn3(Traducao.ErroTitle, Traducao.ErroText, 10)
		end

		DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.ErroTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.ErroText .. "</font>"
		return
	end

	local str11 = "YouTube Music Player/Musics"
	local str13 = str11 .. "/" .. tostring(v18) .. ".mp3"

	pcall(function()
		if not isfolder("YouTube Music Player") then makefolder("YouTube Music Player") end
		if not isfolder(str11) then makefolder(str11) end
		writefile(str13, v21)
	end)

	-- auto play right after save
	pcall(function()
		if type(getcustomasset) == "function" and sound2 then
			pcall(SinisterStopPreviousMusic)
			local asset = getcustomasset(str13)
			sound2.SoundId = asset
			if sound2.Volume <= 0 then sound2.Volume = 1 end
			sound2:Play()
			v12 = sound2
			flag9 = true
			CurrentMediaId = tostring(v18)
			if Play then Play.Image = "rbxassetid://80704722265943" end
			if MiniPlay then MiniPlay.Image = "rbxassetid://110232191351528" end
		end
	end)

	task.wait(0.1)
	pcall(UpdatePlaylist)
	CarregandoRoblox(false)
	DesativarBusca(false)
	Concluido.Visible = true

	if not frame.Visible or not Tela4.Visible then
		fn3(Traducao.Baixado, Traducao.Terminou, 6)
	end

	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Baixado .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Terminou .. "</font>"
end

local BaixarOriginal = Baixar
Baixar = function(arg)
	TituloFormato.Text = "Descargando..."
	pcall(BaixarOriginal, arg)
	TituloFormato.Text = Traducao.EscolhaFor
end

for i = 1, 10 do
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 21, 0, 21)
	imageButton3.Position = UDim2.new(0, 3 + (i - 1) * 28, 0, 3)
	imageButton3.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
	imageButton3.BackgroundTransparency = 0.9
	imageButton3.Name = i
	imageButton3.Parent = ScrollPagina
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.TextColor3 = Color3.fromRGB(16, 8, 10)
	textLabel.BackgroundTransparency = 1
	textLabel.BorderSizePixel = 0
	textLabel.Text = tostring(i)
	textLabel.Parent = imageButton3
	Corner(imageButton3, 20)
	Stroke(imageButton3, 50, 50, 50, 1)
	local uiStroke = imageButton3:FindFirstChildOfClass("UIStroke")

	if i == 1 then
		imageButton3.BackgroundTransparency = 0
		imageButton3.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

		if uiStroke then
			uiStroke.Color = Color3.fromRGB(255, 0, 0)
		end
	end

	imageButton3.MouseButton1Click:Connect(function()
		if i == tbl.Pagina then
			return
		end

		if not flag19 then
			fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
			return
		end

		if Loading.Visible or Baixando.Visible then
			return
		end
		SetPag(i)
		Concluido.Visible = false
		DownloadFrameTexto.Visible = false
		SemResultado.Visible = false
		Erro.Visible = false
		Tutorial.Visible = false
		Novamente.Visible = false
		Buscar(text)
	end)
end

AplicarFiltro.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if not PaginaFrame.Visible then
		fn3(Traducao.Erro, Traducao.NaoPodeFiltro, 10)
		return
	end
	tbl.Ordem = ordem
	tbl.Data = data
	tbl.Duracao = duracao
	DownloadFrameTexto.Visible = false
	SemResultado.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	Formato.Visible = false
	ScrollDownload.Visible = true
	TextoTituloFor.Text = ""
	Thumbfor.Image = "rbxassetid://0"
	SetPag(1)
	Buscar(text)
end)

RemoverFiltro.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if ordem == "relevance" and data == "any" and duracao == "any" then
		fn3(Traducao.Erro, Traducao.FiltrosJaPadrao, 10)
		return
	end
	ordem = "relevance"
	data = "any"
	duracao = "any"
	tbl.Ordem = ordem
	tbl.Data = data
	tbl.Duracao = duracao
	RelevanciaTexto.Text = Traducao.Order .. "\n" .. Traducao.Relevance
	DataUploadTexto.Text = Traducao.UploaDate .. "\n" .. Traducao.Any
	DuracaoTexto.Text = Traducao.Duration .. "\n" .. Traducao.Any
	DownloadFrameTexto.Visible = false
	SemResultado.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	fn3(Traducao.Sucesso, Traducao.FiltrosRemovidos, 5)

	if PaginaFrame.Visible then
		Formato.Visible = false
		ScrollDownload.Visible = true
		TextoTituloFor.Text = ""
		Thumbfor.Image = "rbxassetid://0"
		SetPag(1)
		Buscar(text)
	end
end)

Relevancia.MouseButton1Click:Connect(function()
	for i, v18 in ipairs(tbl2) do
		if v18 == ordem then
			ordem = tbl2[i % #tbl2 + 1]
			break
		end
	end

	RelevanciaTexto.Text = Traducao.Order .. "\n" .. Traducao[ordem:gsub("^%l", string.upper)]
end)

DataUpload.MouseButton1Click:Connect(function()
	for i, v18 in ipairs(tbl3) do
		if v18 == data then
			data = tbl3[i % #tbl3 + 1]
			break
		end
	end

	DataUploadTexto.Text = Traducao.UploaDate .. "\n" .. Traducao[data:gsub("^%l", string.upper)]
end)

Duracao.MouseButton1Click:Connect(function()
	for i, v18 in ipairs(tbl4) do
		if v18 == duracao then
			duracao = tbl4[i % #tbl4 + 1]
			break
		end
	end

	DuracaoTexto.Text = Traducao.Duration .. "\n" .. Traducao[duracao:gsub("^%l", string.upper)]
end)

Filtro.MouseButton1Click:Connect(function()
	if Loading.Visible or Baixando.Visible then
		return
	end

	if not FiltroFrame.Visible then
		tbl10 = {}

		for _, v18 in ipairs({
			DownloadFrameTexto,
			Aguardando,
			Loading,
			SemResultado,
			Formato,
			ScrollDownload,
			Concluido,
			SemResultado,
			Erro,
		}) do
			if v18.Visible then
				table.insert(tbl10, v18)
				v18.Visible = false
			end
		end

		FiltroFrame.Visible = true
	else
		for _, v18 in ipairs(tbl10) do
			if v18 then
				v18.Visible = true
			end
		end

		tbl10 = {}
		FiltroFrame.Visible = false
	end
end)

ClearSearch = function()
	pcall(function()
		if isfolder("Youtube Music Player/Internal/Cache") then
			local Cache = listfiles("Youtube Music Player/Internal/Cache")

			for _, v18 in ipairs(Cache) do
				if string.find(v18, "Search_") then
					delfile(v18)
				end
			end
		end
	end)
end

PesquisarBox.FocusLost:Connect(function()
	local match = PesquisarBox.Text:match("^%s*(.-)%s*$")
	if match == "" then
		PesquisarBox.Text = ""
		return
	end
	ClearSearch()
	text = tostring(match)
	SetPag(1)
	Buscar(text)
end)

PesquisarBox.Focused:Connect(function()
	CancelarBusca()
end)

HomeBox.FocusLost:Connect(function()
	local match = HomeBox.Text:match("^%s*(.-)%s*$")
	if match == "" then
		HomeBox.Text = ""
		return
	end
	HomeBox.Text = ""
	local minus = match:lower()
	if minus:find("youtu") or minus:find("http") then
		Tela(4)
		CancelarBusca()
		ClearSearch()
		text = tostring(match)
		SetPag(1)
		Buscar(text)
		return
	end
	if Tela then
		Tela(1)
	end
	task.spawn(function()
		CargarHome(true, match)
	end)
end)

Lupa.MouseButton1Down:Connect(function()
	if not PesquisarBox.Active then
		return
	end
	flag14 = PesquisarBox:IsFocused()
end)

Lupa.MouseButton1Click:Connect(function()
	if not PesquisarBox.Active then
		return
	end

	if flag14 then
		PesquisarBox:ReleaseFocus()
	else
		PesquisarBox:CaptureFocus()
	end
end)

BotaoMp3.MouseButton1Click:Connect(function()
	if isfile("YouTube Music Player/Musics" .. "/" .. tostring(VIDEO_ATUAL) .. ".mp3") then
		fn3(Traducao.Erro, Traducao.JaTemMusica, 5)
		return
	end
	Baixar("Musica")
	DownloadAtual = "M"
end)

BotaoMp4.MouseButton1Click:Connect(function()
	-- force fast audio path instead of full video
	if isfile("YouTube Music Player/Musics" .. "/" .. tostring(VIDEO_ATUAL) .. ".mp3") then
		fn3(Traducao.Erro, Traducao.JaTemMusica, 5)
		return
	end
	Baixar("Musica")
	DownloadAtual = "M"
end)

BotaoCancelar.MouseButton1Click:Connect(function()
	Formato.Visible = false
	ScrollDownload.Visible = true
	TextoTituloFor.Text = ""
	Thumbfor.Image = "rbxassetid://0"
end)

Novamente.MouseButton1Click:Connect(function()
	if DownloadAtual == "M" then
		fn3(Traducao.Tentando, Traducao.TentandoTexto, 7)
		Baixar("Musica")
	elseif DownloadAtual == "V" then
		fn3(Traducao.Tentando, Traducao.TentandoTexto, 7)
		Baixar("Video")
	end
end)

Tutorial.MouseButton1Click:Connect(function()
	fn3(Traducao.LinkCopiado, Traducao.Tutorial, 8)
	YmpClipboard("https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/Tutorial.txt")
end)

ScrollDownload.ChildAdded:Connect(function(child)
	if not child:IsA("Frame") then
		return
	end
	organizarItens()
end)

ScrollDownload.ChildRemoved:Connect(function(child)
	if not child:IsA("Frame") then
		return
	end
	organizarItens()
end)

SetVolume = function(volume)
	sound2.Volume = volume
	Video.Volume = volume
	MiniVideo.Volume = volume
	VolumeBox.Text = tostring(volume)
	BarVolSet(volume)
end

SetPitch = function(playbackSpeed)
	sound2.PlaybackSpeed = playbackSpeed
	GiroSpeed = playbackSpeed
	GiroBackup = playbackSpeed
	PitchBox.Text = tostring(playbackSpeed)
end

SetEqualizer = function(lowGain, midGain, highGain)
	Equalizer.LowGain = lowGain
	Equalizer.MidGain = midGain
	Equalizer.HighGain = highGain
	GravesBox.Text = tostring(lowGain)
	MediosBox.Text = tostring(midGain)
	AgudosBox.Text = tostring(highGain)
end

EquaValue = function(arg, arg2)
	local v18 = string.match(string.gsub(string.gsub(arg, "^%s+", ""), "%s+$", ""), "-?%d+%.?%d*")
	if not v18 then
		return arg2
	end
	local num = tonumber(v18)
	if not num then
		return arg2
	end
	return (math.clamp(num, -1000, 1000))
end

SetEffect = function(arg)
	for _, child in pairs(sound2:GetChildren()) do
		if child:IsA("SoundEffect") then
			child:Destroy()
		end
	end

	SetPitch(1)
	SetEqualizer(1, 1, 1)
	if arg == "Nenhum" then
		return
	end

	if arg == "Reverb" then
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 2.6
		reverbSoundEffect.Density = 0.75
		reverbSoundEffect.Diffusion = 0.9
		reverbSoundEffect.WetLevel = -9
		reverbSoundEffect.DryLevel = 0
		SetEqualizer(-1, 0, -3)
	elseif arg == "Echo" then
		local echoSoundEffect = Instance.new("EchoSoundEffect", sound2)
		echoSoundEffect.Delay = 0.7
		echoSoundEffect.Feedback = 0.5
		echoSoundEffect.WetLevel = -6
		echoSoundEffect.DryLevel = 0
	elseif arg == "Distortion" then
		Instance.new("DistortionSoundEffect", sound2).Level = 0.4
		SetEqualizer(-4, 2, -2)
	elseif arg == "Chorus" then
		local chorusSoundEffect = Instance.new("ChorusSoundEffect", sound2)
		chorusSoundEffect.Depth = 0.25
		chorusSoundEffect.Rate = 1.2
		chorusSoundEffect.Mix = 0.6
	elseif arg == "Flanger" then
		local flangeSoundEffect = Instance.new("FlangeSoundEffect", sound2)
		flangeSoundEffect.Depth = 0.4
		flangeSoundEffect.Rate = 2
		flangeSoundEffect.Mix = 0.5
	elseif arg == "Tremolo" then
		local tremoloSoundEffect = Instance.new("TremoloSoundEffect", sound2)
		tremoloSoundEffect.Depth = 0.5
		tremoloSoundEffect.Frequency = 8
	elseif arg == "Compressor" then
		local compressorSoundEffect = Instance.new("CompressorSoundEffect", sound2)
		compressorSoundEffect.Threshold = -25
		compressorSoundEffect.Ratio = 15
		compressorSoundEffect.Attack = 0.02
		compressorSoundEffect.Release = 0.1
	elseif arg == "Radio" then
		Instance.new("DistortionSoundEffect", sound2).Level = 0.25
		local compressorSoundEffect = Instance.new("CompressorSoundEffect", sound2)
		compressorSoundEffect.Threshold = -10
		compressorSoundEffect.Ratio = 12
		compressorSoundEffect.Attack = 0.02
		compressorSoundEffect.Release = 0.08
		local equalizerSoundEffect = Instance.new("EqualizerSoundEffect", sound2)
		equalizerSoundEffect.LowGain = -10
		equalizerSoundEffect.MidGain = 10
		equalizerSoundEffect.HighGain = -12
		SetPitch(0.97)
	elseif arg == "Cinema" then
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 5
		reverbSoundEffect.Density = 0.7
		reverbSoundEffect.WetLevel = -15
		reverbSoundEffect.DryLevel = 0
		SetEqualizer(6, -2, 2)
	elseif arg == "Underwater" then
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 1.5
		reverbSoundEffect.Density = 1
		reverbSoundEffect.WetLevel = -6
		reverbSoundEffect.DryLevel = -4
		SetEqualizer(4, -12, -25)
	elseif arg == "Kid" then
		SetPitch(1.45)
		SetEqualizer(-5, 2, 4)
	elseif arg == "Robot" then
		local flangeSoundEffect = Instance.new("FlangeSoundEffect", sound2)
		flangeSoundEffect.Depth = 0.5
		flangeSoundEffect.Rate = 3
		local tremoloSoundEffect = Instance.new("TremoloSoundEffect", sound2)
		tremoloSoundEffect.Depth = 1
		tremoloSoundEffect.Frequency = 4
		SetEqualizer(-5, 5, 2)
	elseif arg == "Slowed" then
		SetPitch(0.72)
		Instance.new("DistortionSoundEffect", sound2).Level = 0.35
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 4
		reverbSoundEffect.WetLevel = -10
		SetEqualizer(8, -2, -12)
	end
end

SelecionarEqua = function(arg)
	local children = ScrollEqua:GetChildren()

	local function fn14(arg2)
		if not arg2:IsA("ImageButton") or arg2.Name == "Resetar" then
			return
		end
		local imageLabel = arg2:FindFirstChildOfClass("ImageLabel")
		arg2.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
		Stroke(arg2, 50, 50, 50, 2)

		if imageLabel then
			Stroke(imageLabel, 50, 50, 50, 2)
		end
	end

	for _, child in ipairs(children) do
		fn14(child)
	end

	local imageLabel = arg:FindFirstChildOfClass("ImageLabel")
	arg.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
	Stroke(arg, 255, 0, 0, 2)

	if imageLabel then
		Stroke(imageLabel, 255, 0, 0, 2)
	end

	if arg.Name == "Nenhum" then
		SetEffect("Nenhum")
	elseif arg.Name == "Reverb" then
		SetEffect("Reverb")
	elseif arg.Name == "Echo" then
		SetEffect("Echo")
	elseif arg.Name == "Distortion" then
		SetEffect("Distortion")
	elseif arg.Name == "Chorus" then
		SetEffect("Chorus")
	elseif arg.Name == "Flanger" then
		SetEffect("Flanger")
	elseif arg.Name == "Tremolo" then
		SetEffect("Tremolo")
	elseif arg.Name == "Compressor" then
		SetEffect("Compressor")
	elseif arg.Name == "Radio" then
		SetEffect("Radio")
	elseif arg.Name == "Cinema" then
		SetEffect("Cinema")
	elseif arg.Name == "Underwater" then
		SetEffect("Underwater")
	elseif arg.Name == "Kid" then
		SetEffect("Kid")
	elseif arg.Name == "Robot" then
		SetEffect("Robot")
	elseif arg.Name == "Slowed" then
		SetEffect("Slowed")
	end
end

VolumeBox.FocusLost:Connect(function()
	SetVolume(EquaValue(VolumeBox.Text, 1))
end)

PitchBox.FocusLost:Connect(function()
	SetPitch(EquaValue(PitchBox.Text, 1))
end)

GravesBox.FocusLost:Connect(function()
	local v18 = EquaValue
	local text2 = AgudosBox.Text
	SetEqualizer(EquaValue(GravesBox.Text, 1), EquaValue(MediosBox.Text, 1), v18(text2, 1))
end)

MediosBox.FocusLost:Connect(function()
	local v18 = EquaValue
	local text2 = AgudosBox.Text
	SetEqualizer(EquaValue(GravesBox.Text, 1), EquaValue(MediosBox.Text, 1), v18(text2, 1))
end)

AgudosBox.FocusLost:Connect(function()
	local v18 = EquaValue
	local text2 = AgudosBox.Text
	SetEqualizer(EquaValue(GravesBox.Text, 1), EquaValue(MediosBox.Text, 1), v18(text2, 1))
end)

for _, child in ipairs(ScrollEqua:GetChildren()) do
	if child:IsA("ImageButton") and child.Name ~= "Resetar" then
		child.MouseButton1Click:Connect(function()
			SelecionarEqua(child)
		end)
	end
end

ResetarEqua.MouseButton1Click:Connect(function()
	SetVolume(1)
	SetPitch(1)
	SelecionarEqua(Nenhum)
	fn3(Traducao.Sucesso, Traducao.RsetadoEqua, 5)
end)

NumeroGC = function(arg)
	if arg == false then
		ContadorJA.Visible = false
		ContadorJANU.Text = "0"
		return
	end

	ContadorJA.Visible = not flag17
	local text2 = ContadorJANU.Text
	if text2 == "9+" then
		return
	end
	local n8 = tonumber(text2) or 1

	if n8 < 9 then
		local n9 = n8 + 1
		ContadorJANU.Text = tostring(n9)
	else
		ContadorJANU.Text = "9+"
	end
end


Tela = function(arg)
	if arg == n then
		return
	end
	local tbl13 = { Tela1, Tela2, Tela3, Tela4, Tela5, Tela6 }
	local v18 = ScrollNave:FindFirstChild("Botao" .. arg)
	if arg == 5 and v18 and v18.BackgroundTransparency > 0 then
		fn3(Traducao.Erro, Traducao.ExploitIcomGC, 5)
		return
	end
	n = arg

	if arg == 5 then
		NumeroGC(false)
	end

	for i = 1, #tbl13 do
		tbl13[i].Visible = false
	end

	fn2("102702078778790")

	for _, child in ipairs(ScrollNave:GetChildren()) do
		if child:IsA("ImageButton") then
			child.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
			local uiStroke = child:FindFirstChild("UIStroke")

			if uiStroke then
				uiStroke.Color = Color3.fromRGB(70, 25, 35)
			end

			local imageLabel = child:FindFirstChildWhichIsA("ImageLabel")

			if imageLabel then
				local uiStroke2 = imageLabel:FindFirstChild("UIStroke")

				if uiStroke2 then
					uiStroke2.Color = Color3.fromRGB(70, 25, 35)
				end
			end
		end
	end

	if tbl13[arg] then
		tbl13[arg].Visible = true
	end

	if v18 then
		local color = Color3.fromRGB(139, 0, 0)
		local color2 = Color3.fromRGB(255, 255, 255)

		if arg == 6 then
			color = Color3.fromRGB(0, 190, 230)
			color2 = Color3.fromRGB(184, 134, 11)
		end

		v18.BackgroundColor3 = color
		local uiStroke = v18:FindFirstChild("UIStroke")

		if uiStroke then
			uiStroke.Color = color2
		end

		local imageLabel = v18:FindFirstChildWhichIsA("ImageLabel")

		if imageLabel then
			local uiStroke2 = imageLabel:FindFirstChild("UIStroke")

			if uiStroke2 then
				uiStroke2.Color = color2
			end
		end
	end
end

HomeTopo.MouseButton1Click:Connect(function()
	if PlaylistSalirVista then
		PlaylistSalirVista()
	end
	Formato.Visible = false
	HomeBox.Text = ""
	Tela(1)
	ScrollHome.CanvasPosition = Vector2.new(0, 0)
	task.spawn(function()
		CargarHome(false)
	end)
end)

Botao3.MouseButton1Click:Connect(function()
	Tela(3)
end)

Botao4.MouseButton1Click:Connect(function()
	Tela(4)
end)

RefreshHome.MouseButton1Click:Connect(function()
	if PlaylistSalirVista then
		PlaylistSalirVista()
	end
	task.spawn(function()
		CargarHome(true)
	end)
end)

task.spawn(function()
	task.wait(1.5)
	CargarHome(false)
end)

Discord.MouseButton1Click:Connect(function()
	if flag3 then
		return
	end
	flag3 = true
	local tween4 = v6:Create(UIScaleDis, tweenInfo, { Scale = 0.9 })
	local tween5 = v6:Create(IconeDiscord, tweenInfo, { Rotation = -6 })
	tween4:Play()
	tween5:Play()
	tween4.Completed:Wait()
	local tween6 = v6:Create(UIScaleDis, tweenInfo2, { Scale = 1 })
	local tween7 = v6:Create(IconeDiscord, tweenInfo2, { Rotation = 0 })
	tween6:Play()
	tween7:Play()
	fn3(Traducao.LinkCopiado, "https://discord.gg/kbh2dEdnYP", 10)
	YmpClipboard("https://discord.gg/kbh2dEdnYP")
	tween6.Completed:Wait()
	flag3 = false
end)

You.MouseButton1Click:Connect(function()
	if flag4 then
		return
	end
	flag4 = true
	local tween4 = v6:Create(UIScaleYou, tweenInfo, { Scale = 0.9 })
	local tween5 = v6:Create(IconeYou, tweenInfo, { Rotation = -6 })
	tween4:Play()
	tween5:Play()
	tween4.Completed:Wait()
	local tween6 = v6:Create(UIScaleYou, tweenInfo2, { Scale = 1 })
	local tween7 = v6:Create(IconeYou, tweenInfo2, { Rotation = 0 })
	tween6:Play()
	tween7:Play()
	fn3("YouTube", "@Termux_404", 10)
	tween6.Completed:Wait()
	flag4 = false
end)

local tbl13 = {}
local tween4 = v6:Create(TempoAtual, tweenInfo4, { Position = UDim2.new(0, 6, 0, 6) })
local tween5 = v6:Create(TempoTotal, tweenInfo4, { Position = UDim2.new(0, 174, 0, 6) })
local tween6 = v6:Create(Repetir, tweenInfo4, { Position = UDim2.new(0.5, -35, 0.5, -54) })
local tween7 = v6:Create(Miniplayer, tweenInfo4, { Position = UDim2.new(0.5, 5, 0.5, -54) })
local create = v6.Create
local v18 = BarraProgresso
local tbl14 = { Position = UDim2.new(0, 6, 0, 103) }
tbl13[1] = tween4
tbl13[2] = tween5
tbl13[3] = tween6
tbl13[4] = tween7

do
	local values = table.pack(create(v6, v18, tweenInfo4, tbl14))
	table.move(values, 1, values.n, 5, tbl13)
end

tweensMostrar = tbl13
local tbl15 = {}
local tween8 = v6:Create(TempoAtual, tweenInfo4, { Position = UDim2.new(0, -60, 0, 6) })
local tween9 = v6:Create(TempoTotal, tweenInfo4, { Position = UDim2.new(0, 235, 0, 6) })
local tween10 = v6:Create(Repetir, tweenInfo4, { Position = UDim2.new(0.5, -35, 0.5, -120) })
local tween11 = v6:Create(Miniplayer, tweenInfo4, { Position = UDim2.new(0.5, 5, 0.5, -120) })
local create2 = v6.Create
local v19 = BarraProgresso
local tbl16 = { Position = UDim2.new(0, 6, 0, 125) }
tbl15[1] = tween8
tbl15[2] = tween9
tbl15[3] = tween10
tbl15[4] = tween11

do
	local values = table.pack(create2(v6, v19, tweenInfo4, tbl16))
	table.move(values, 1, values.n, 5, tbl15)
end

tweensOcultar = tbl15
infoTweenMini = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
listaControlesMini = { MiniBack, MiniRetroceder, MiniPlay, MiniAvancar, MiniSkip, TelaCheia, FecharMini }

Exibir = function()
	if flag6 then
		return
	end
	flag6 = true
	fn2("123430321654900")
	task.wait(0.1)
	flag5 = not flag5
	local v20 = flag5 and tweensMostrar or tweensOcultar

	for _, v21 in ipairs(v20) do
		v21:Play()
	end

	v20[1].Completed:Wait()
	flag6 = false
end

BotaoTela.MouseButton1Click:Connect(function()
	Exibir()
end)

CicloRepetir = function()
	if Repetir.Image == "rbxassetid://72571947341676" then
		Repetir.Image = "rbxassetid://133261841375114"
		fn3(Traducao.PlayMode, Traducao.Repetir, 8)
		str4 = "nill"
		sound2.Looped = true
		Video.Looped = true
		MiniVideo.Looped = true
	elseif Repetir.Image == "rbxassetid://133261841375114" then
		Repetir.Image = "rbxassetid://70388482182322"
		fn3(Traducao.PlayMode, Traducao.Random, 8)
		str4 = "Random"
		sound2.Looped = false
		Video.Looped = false
		MiniVideo.Looped = false
	else
		Repetir.Image = "rbxassetid://72571947341676"
		fn3(Traducao.PlayMode, Traducao.Auto, 8)
		str4 = "Auto"
		sound2.Looped = false
		Video.Looped = false
		MiniVideo.Looped = false
	end
end

Repetir.MouseButton1Click:Connect(CicloRepetir)
BarRepetir.MouseButton1Click:Connect(CicloRepetir)

Miniplayer.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if BloquearMidia then
		fn3(Traducao.Aguarde, Traducao.DownloadFazendo, 5)
		return
	end

	if Miniplayer.Image == "rbxassetid://102723588572082" then
		Miniplayer.Image = "rbxassetid://84519235983477"
		fn2("85730811347567")
		SetMiniPlayer(true)
	elseif Miniplayer.Image == "rbxassetid://84519235983477" then
		Miniplayer.Image = "rbxassetid://102723588572082"
		fn2("85730811347567")
		SetMiniPlayer(false)
	end
end)

aplicarVisibilidadeMini = function(arg)
	flag11 = true
	local n8 = #listaControlesMini

	for _, v20 in ipairs(listaControlesMini) do
		if arg then
			v20.Visible = true
		end

		local tbl17 = {}

		if v20:IsA("ImageButton") or v20:IsA("ImageLabel") then
			tbl17.ImageTransparency = arg and 0 or 1
		end

		if v20:IsA("TextButton") or v20:IsA("TextLabel") then
			tbl17.TextTransparency = arg and 0 or 1
		end

		if v20.BackgroundTransparency ~= nil then
			tbl17.BackgroundTransparency = arg and 0 or 1
		end

		local tween12 = v6:Create(v20, infoTweenMini, tbl17)
		tween12:Play()

		tween12.Completed:Once(function()
			n8 -= 1

			if not arg then
				v20.Visible = false
			end

			if n8 <= 0 then
				flag11 = false
			end
		end)
	end
end

imageButton2.MouseButton1Click:Connect(function()
	if flag11 then
		return
	end

	if imageButton2:GetAttribute("Blocked") then
		return
	end

	if imageButton2:GetAttribute("Moved") then
		imageButton2:SetAttribute("Moved", false)
		return
	end
	estadoMiniUI = not estadoMiniUI
	aplicarVisibilidadeMini(estadoMiniUI)
end)

imageButton.MouseButton1Click:Connect(function()
	if imageButton:GetAttribute("Blocked") then
		return
	end

	if imageButton:GetAttribute("Moved") then
		imageButton:SetAttribute("Moved", false)
		return
	end
	imageButton.Visible = false
	frame.Visible = true

	if Tela5.Visible then
		NumeroGC(false)
	end

	fn2("122954374321453")
end)

BotaoFechar.MouseButton1Click:Connect(function()
	-- close UI but KEEP music playing
	pcall(function()
		local ss = game:GetService("SoundService")
		-- keep active sound outside destroyed UI
		if sound2 and sound2:IsA("Sound") then
			sound2.Name = "SinisterYMPKeep"
			sound2:SetAttribute("SinisterYMP", true)
			sound2.Parent = ss
			_G.__SinisterYMPSound = sound2
		end
		if sound and sound:IsA("Sound") and sound.Playing then
			sound.Parent = ss
			if not _G.__SinisterYMPSound then _G.__SinisterYMPSound = sound end
		end
		if v12 and typeof(v12) == "Instance" and v12:IsA("Sound") then
			v12.Parent = ss
			_G.__SinisterYMPSound = v12
			if not v12.Playing then
				-- leave as-is if already playing
			end
		end
	end)
	frame.Visible = false
	if imageButton then imageButton.Visible = false end
	if imageButton2 then imageButton2.Visible = false end
	pcall(function()
		if getgenv then getgenv().YMP = false end
	end)
	_G.__SinisterYMPOpen = false
	-- destroy only the visual UI; sounds already moved to SoundService
	pcall(function()
		if screenGui then
			for _, ch in ipairs(screenGui:GetDescendants()) do
				if ch:IsA("Sound") then
					pcall(function() ch.Parent = game:GetService("SoundService") end)
				end
			end
			screenGui:Destroy()
		end
	end)
end)

animar = function(arg)
	if tbl8[arg] then
		return
	end
	tbl8[arg] = true
	local size = arg.Size
	local position = arg.Position

	if tbl9[arg] then
		for _, v20 in ipairs(tbl9[arg]) do
			v20:Cancel()
		end
	end

	tbl9[arg] = {}
	fn2("136328893130485")
	local tween12 = v6:Create(arg, tweenInfo5, { Size = size - UDim2.new(0, 6, 0, 6), Position = position + UDim2.new(0, 3, 0, 3) })
	local tween13 = v6:Create(arg, tweenInfo6, { Size = size, Position = position })
	local tween14 = v6:Create(arg, TweenInfo.new(0.05), { Rotation = 6 })
	local tween15 = v6:Create(arg, TweenInfo.new(0.05), { Rotation = -6 })
	local tween16 = v6:Create(arg, TweenInfo.new(0.05), { Rotation = 0 })
	table.insert(tbl9[arg], tween12)
	table.insert(tbl9[arg], tween13)
	table.insert(tbl9[arg], tween14)
	table.insert(tbl9[arg], tween15)
	table.insert(tbl9[arg], tween16)
	tween12:Play()
	tween12.Completed:Wait()
	tween13:Play()
	tween14:Play()
	tween14.Completed:Wait()
	tween15:Play()
	tween15.Completed:Wait()
	tween16:Play()
	tween16.Completed:Wait()
	tbl8[arg] = nil
end

FecharMini.MouseButton1Click:Connect(function()
	fn2("85730811347567")
	Miniplayer.Image = "rbxassetid://102723588572082"
	SetMiniPlayer(false)
end)

Voltar.MouseButton1Click:Connect(function()
	Back()
	animar(Voltar)
end)

Retroceder.MouseButton1Click:Connect(function()
	Retroceder10s()
	animar(Retroceder)
end)

Play.MouseButton1Click:Connect(function()
	Pause()
	animar(Play)
end)

Adiantar.MouseButton1Click:Connect(function()
	Avancar10s()
	animar(Adiantar)
end)

Pular.MouseButton1Click:Connect(function()
	Skip()
	animar(Pular)
end)

BarFotoSync = function()
	local fonte = Musica
	if MiniMusica.ImageRectSize.X > 0 then
		fonte = MiniMusica
	elseif Musica.ImageRectSize.X > 0 then
		fonte = Musica
	elseif Musica.Image == "rbxassetid://109021809317392" then
		fonte = MiniMusica
	end
	BarFoto.Image = fonte.Image
	BarFoto.ImageRectOffset = fonte.ImageRectOffset
	BarFoto.ImageRectSize = fonte.ImageRectSize
end

for _, alvo in ipairs({ Musica, MiniMusica }) do
	alvo:GetPropertyChangedSignal("Image"):Connect(BarFotoSync)
	alvo:GetPropertyChangedSignal("ImageRectOffset"):Connect(BarFotoSync)
	alvo:GetPropertyChangedSignal("ImageRectSize"):Connect(BarFotoSync)
end
BarFotoSync()

-- Tarjeta minimizada: miniatura + título + autor + duración
MiniCardFoto = Instance.new("ImageLabel")
MiniCardFoto.Size = UDim2.new(0, 48, 0, 48)
MiniCardFoto.Position = UDim2.new(0, 6, 0, 6)
MiniCardFoto.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
MiniCardFoto.BorderSizePixel = 0
MiniCardFoto.ScaleType = Enum.ScaleType.Crop
MiniCardFoto.Parent = imageButton
Corner(MiniCardFoto, 6)
MiniCardTitulo = Instance.new("TextLabel")
MiniCardTitulo.Size = UDim2.new(1, -124, 1, -8)
MiniCardTitulo.Position = UDim2.new(0, 60, 0, 4)
MiniCardTitulo.BackgroundTransparency = 1
MiniCardTitulo.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniCardTitulo.Font = Enum.Font.SourceSansBold
MiniCardTitulo.TextScaled = true
MiniCardTitulo.RichText = true
MiniCardTitulo.TextXAlignment = Enum.TextXAlignment.Left
MiniCardTitulo.Text = TituloMusica.Text
MiniCardTitulo.Parent = imageButton
MiniCardTempo = Instance.new("TextLabel")
MiniCardTempo.Size = UDim2.new(0, 50, 0, 18)
MiniCardTempo.AnchorPoint = Vector2.new(1, 0.5)
MiniCardTempo.Position = UDim2.new(1, -8, 0.5, 0)
MiniCardTempo.BackgroundTransparency = 1
MiniCardTempo.TextColor3 = Color3.fromRGB(190, 190, 190)
MiniCardTempo.Font = Enum.Font.SourceSansBold
MiniCardTempo.TextScaled = true
MiniCardTempo.TextXAlignment = Enum.TextXAlignment.Right
MiniCardTempo.Text = TimerTotal.Text
MiniCardTempo.Parent = imageButton
TituloMusica:GetPropertyChangedSignal("Text"):Connect(function()
	MiniCardTitulo.Text = TituloMusica.Text
end)
TimerTotal:GetPropertyChangedSignal("Text"):Connect(function()
	MiniCardTempo.Text = TimerTotal.Text
end)
MiniCardSync = function()
	MiniCardFoto.Image = BarFoto.Image
	MiniCardFoto.ImageRectOffset = BarFoto.ImageRectOffset
	MiniCardFoto.ImageRectSize = BarFoto.ImageRectSize
end
BarFoto:GetPropertyChangedSignal("Image"):Connect(MiniCardSync)
BarFoto:GetPropertyChangedSignal("ImageRectOffset"):Connect(MiniCardSync)
BarFoto:GetPropertyChangedSignal("ImageRectSize"):Connect(MiniCardSync)
MiniCardSync()

BarVoltar.MouseButton1Click:Connect(function()
	Back()
end)

BarRetroceder.MouseButton1Click:Connect(function()
	Retroceder10s()
end)

BarPlay.MouseButton1Click:Connect(function()
	Pause()
end)

BarAdiantar.MouseButton1Click:Connect(function()
	Avancar10s()
end)

BarPular.MouseButton1Click:Connect(function()
	Skip()
end)

BarPodeBuscar = function()
	local v17 = v12
	return v17 and v17.TimeLength > 0 and flag9
end

BarProgUpdate = function(x)
	local w = BarProg.AbsoluteSize.X
	if w <= 0 then
		return
	end
	BarRatio = math.clamp((x - BarProg.AbsolutePosition.X) / w, 0, 0.999)
	BarRastro.Size = UDim2.new(BarRatio, 0, 1, 0)
	if v12 and v12.TimeLength > 0 then
		BarTimeA.Text = formatar(BarRatio * v12.TimeLength)
	end
end

BarVolUpdate = function(x)
	local w = BarVol.AbsoluteSize.X
	if w <= 0 then
		return
	end
	local ratio = math.clamp((x - BarVol.AbsolutePosition.X) / w, 0, 1)
	SetVolume(math.floor(ratio * 100 + 0.5) / 100)
end

BarProg.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if BarPodeBuscar() then
			BarDrag = true
			BarProgUpdate(input.Position.X)
		end
	end
end)

BarVol.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		BarVolDrag = true
		BarVolUpdate(input.Position.X)
	end
end)

v9.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if BarDrag then
			BarProgUpdate(input.Position.X)
		elseif BarVolDrag then
			BarVolUpdate(input.Position.X)
		end
	end
end)

v9.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if BarDrag then
			BarDrag = false
			if BarPodeBuscar() then
				v12.TimePosition = BarRatio * v12.TimeLength
			end
		end
		BarVolDrag = false
	end
end)

MiniBack.MouseButton1Click:Connect(function()
	Back()
	animar(MiniBack)
end)

MiniRetroceder.MouseButton1Click:Connect(function()
	Retroceder10s()
	animar(MiniRetroceder)
end)

MiniPlay.MouseButton1Click:Connect(function()
	Pause()
	animar(MiniPlay)
end)

MiniAvancar.MouseButton1Click:Connect(function()
	Avancar10s()
	animar(MiniAvancar)
end)

MiniSkip.MouseButton1Click:Connect(function()
	Skip()
	animar(MiniSkip)
end)

TelaCheia.MouseButton1Click:Connect(function()
	if isAnimating then
		return
	end
	isAnimating = true
	flag10 = not flag10
	local udim24

	if flag10 then
		udim24 = UDim2.new(udim2.X.Scale * 1.4, 0, udim2.Y.Scale * 1.4, 0)
		TelaCheia.Image = "rbxassetid://104681366724942"
		fn2("125296945528316")
		MiniBack.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniRetroceder.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniPlay.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniAvancar.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniSkip.Size = UDim2.new(0.18, -8, 0.29, 0)
		TelaCheia.Size = UDim2.new(0.18, -8, 0.29, 0)
		FecharMini.Size = UDim2.new(0.18, -8, 0.29, 0)
	else
		udim24 = udim2
		TelaCheia.Image = "rbxassetid://73952228795506"
		fn2("125296945528316")
		MiniBack.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniRetroceder.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniPlay.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniAvancar.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniSkip.Size = UDim2.new(0.18, -8, 0.27, 0)
		TelaCheia.Size = UDim2.new(0.18, -8, 0.27, 0)
		FecharMini.Size = UDim2.new(0.18, -8, 0.27, 0)
	end

	local tween12 = v6:Create(imageButton2, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Size = udim24 })
	tween12:Play()

	tween12.Completed:Connect(function()
		isAnimating = false
	end)
end)

REPORT_ID = nil
REPORT_MOTIVO = nil

local function fn14(arg)
	if REPORT_MOTIVO == nil then
		fn3(Traducao.ReportErro, Traducao.ReportErro10, 8)
		return
	end
	local n8 = #REPORT_MOTIVO
	if n8 < 10 or n8 > 200 then
		fn3(Traducao.ReportErro, Traducao.ReportErro11, 8)
		return
	end
	Denunciar.Active = false
	CancelarReport.Active = false
	DenunciarTexto.Text = "..."
	CancelarReportTexto.Text = "..."

	local ok3, result3 = pcall(function()
		return YmpRequest({
			Url = str3 .. "/report",
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode({ key = KEY_ATUAL, hwid = YmpHwid(), msgid = tostring(arg), reason = REPORT_MOTIVO }),
		})
	end)

	if ok3 then
		local str10 = tostring(result3.Body or result3):gsub("^\"", ""):gsub("\"$", "")

		if str10 == "request denied" then
			fn3(Traducao.ReportErro, Traducao.ReportErro1, 8)
		elseif str10 == "invalid report" then
			fn3(Traducao.ReportErro, Traducao.ReportErro2, 8)
		elseif str10 == "server error" then
			fn3(Traducao.ReportErro, Traducao.ReportErro3, 8)
		elseif str10 == "too many reports" then
			fn3(Traducao.ReportErro, Traducao.ReportErro4, 8)
		elseif str10 == "reporting to oneself is not allowed" then
			fn3(Traducao.ReportErro, Traducao.ReportErro5, 8)
		elseif str10 == "already reported by you" then
			fn3(Traducao.ReportErro, Traducao.ReportErro6, 8)
		elseif str10 == "already reported by another" then
			fn3(Traducao.ReportErro, Traducao.ReportErro7, 8)
		elseif str10 == "banned" then
			fn3(Traducao.ReportErro, Traducao.ReportErro8, 8)
		elseif string.find(tostring(str10), "reported") then
			fn3(Traducao.ReportSucesso, Traducao.ReportSucesso2, 8)
			task.wait(0.5)
			REPORT_ID = nil
			REPORT_MOTIVO = nil
			TextoReportFrame.Text = ""
			MotivoBox.Text = ""
			FotoReport.Image = ""
			ReportFrame.Visible = false
			frame.Visible = true
		else
			fn3(Traducao.ReportErro, Traducao.ReportErro3, 8)
		end
	else
		fn3(Traducao.ReportErro, Traducao.ReportErro3, 8)
	end

	task.wait(0.5)
	Denunciar.Active = true
	CancelarReport.Active = true
	DenunciarTexto.Text = "Report"
	CancelarReportTexto.Text = Traducao.Cancelar
end

Reportar = function(arg, arg2, image)
	REPORT_ID = arg2
	TextoReportFrame.Text = Traducao.AvisoReport1 .. " '{" .. arg .. "}' " .. Traducao.AvisoReport2
	FotoReport.Image = image
	ReportFrame.Visible = true
	frame.Visible = false
end

local function fn15(arg)
	if Warn.Visible then
		return
	end

	if v12 and v12.Playing then
		Pause()
	end

	if frame.Visible then
		frame.Visible = false
	end

	if imageButton.Visible then
		imageButton.Visible = false
	end

	if ReportFrame.Visible then
		REPORT_ID = nil
		TextoReportFrame.Text = ""
		FotoReport.Image = ""
		ReportFrame.Visible = false
	end

	task.wait(0.1)
	CloseWarn.BackgroundTransparency = 0.7
	CloseWarnTexto.TextColor3 = Color3.fromRGB(16, 8, 10)
	Warn.Visible = true
	BlurEffect.Size = 56
	fn2("107089652181213")
	TextoWarn.Text = Traducao.MsgMod .. " " .. arg
	task.wait(5)
	CloseWarn.BackgroundTransparency = 0
	CloseWarnTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
end

ProFinal = function()
	local n8 = ScrollGC.AbsoluteCanvasSize.Y - ScrollGC.AbsoluteWindowSize.Y

	if tween3 then
		tween3:Cancel()
	end

	tween3 = v6:Create(ScrollGC, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CanvasPosition = Vector2.new(0, n8) })
	tween3:Play()
end

ChekFinal = function()
	local y = ScrollGC.CanvasPosition.Y
	return math.max(ScrollGC.AbsoluteCanvasSize.Y - ScrollGC.AbsoluteWindowSize.Y, 0) - y <= 5
end

local function fn16(arg, text2, arg2, arg3)
	layoutOrder += 1
	task.wait()

	local function fn17(arg4)
		if not (FotoTradu and FotoTradu.Image == "rbxassetid://72657045512999") then
			return arg4
		end

		local ok3, result3 = pcall(function()
			return TraduzirMsg(arg4)
		end)

		return ok3 and result3 or arg4
	end

	local v20 = fn17(arg2 or "")
	local result3 = nil

	if arg ~= "ymp" then
		local num = tonumber(arg)
		if not num then
			return
		end

		if tbl11[num] then
			result3 = tbl11[num]
		else
			local ok3

			ok3, result3 = pcall(function()
				local response = game:HttpGet("https://users.roblox.com/v1/users/" .. num)

				return {
					displayName = game:GetService("HttpService"):JSONDecode(response).displayName,
					image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. num .. "&width=420&height=420&format=png",
				}
			end)

			if not ok3 or not result3 or not result3.displayName then
				return
			end
			tbl11[num] = result3
		end
	end

	if not Tela5.Visible or imageButton.Visible == true then
		NumeroGC()
	end

	local v21 = ChekFinal()
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0.9, 0, 0, 0)
	frame3.AutomaticSize = Enum.AutomaticSize.Y
	frame3.BackgroundTransparency = 1
	frame3.BorderSizePixel = 0
	frame3.LayoutOrder = layoutOrder
	frame3.Parent = ScrollGC
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Parent = frame3
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 10)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 40, 0, 40)
	imageLabel.Position = UDim2.new(0, 1, 0, 1)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 60, 0, 15)
	frame4.Position = UDim2.new(0, 47, 0, 12)
	frame4.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
	frame4.BorderSizePixel = 0
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(192, 192, 192)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 1)
	uiPadding.PaddingTop = UDim.new(0, 1)
	uiPadding.PaddingRight = UDim.new(0, 1)
	uiPadding.PaddingBottom = UDim.new(0, 1)
	uiPadding.Parent = textLabel
	local frame5 = Instance.new("Frame")
	frame5.Size = UDim2.new(0, 60, 0, 15)
	frame5.Position = UDim2.new(0, 112, 0, 12)
	frame5.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
	frame5.BorderSizePixel = 0
	frame5.Parent = imageLabel
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -7, 1, 0)
	textLabel2.Position = UDim2.new(0, 4, 0, 0)
	textLabel2.BackgroundTransparency = 1
	textLabel2.TextColor3 = Color3.fromRGB(192, 192, 192)
	textLabel2.Font = Enum.Font.SourceSansBold
	textLabel2.TextScaled = true
	textLabel2.Parent = frame5
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 17, 0, 17)
	imageButton3.Position = UDim2.new(0, 177, 0, 12)
	imageButton3.BackgroundTransparency = 1
	imageButton3.BorderSizePixel = 0
	imageButton3.Parent = imageLabel
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.Size = UDim2.new(1, 0, 1, 0)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Font = Enum.Font.SourceSansBold
	textLabel3.TextScaled = true
	textLabel3.TextColor3 = Color3.fromRGB(192, 192, 192)
	textLabel3.Text = "C"
	textLabel3.Parent = imageButton3
	local imageButton4 = Instance.new("ImageButton")
	imageButton4.Size = UDim2.new(0, 17, 0, 17)
	imageButton4.Position = UDim2.new(0, 200, 0, 12)
	imageButton4.BackgroundTransparency = 1
	imageButton4.BorderSizePixel = 0
	imageButton4.Visible = arg ~= tostring(userId) and arg ~= "ymp"
	imageButton4.Parent = imageLabel
	local imageLabel2 = Instance.new("ImageLabel")
	imageLabel2.Size = UDim2.new(0, 10, 0, 10)
	imageLabel2.Position = UDim2.new(0, 4, 0, 4)
	imageLabel2.BackgroundTransparency = 1
	imageLabel2.Image = "rbxassetid://74995247007994"
	imageLabel2.Parent = imageButton4
	local textSize = game:GetService("TextService"):GetTextSize(v20, 16, Enum.Font.SourceSansBold, Vector2.new(170, math.huge))
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(0, 180, 0, textSize.Y + 10)
	frame6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame6.BackgroundTransparency = 0.7
	frame6.BorderSizePixel = 0
	frame6.Parent = frame3
	local textLabel4 = Instance.new("TextLabel")
	textLabel4.Size = UDim2.new(0, 170, 0, textSize.Y)
	textLabel4.BackgroundTransparency = 1
	textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel4.Font = Enum.Font.SourceSansBold
	textLabel4.TextWrapped = true
	textLabel4.TextXAlignment = Enum.TextXAlignment.Left
	textLabel4.TextYAlignment = Enum.TextYAlignment.Top
	textLabel4.TextSize = 14
	textLabel4.Text = v20
	textLabel4.Parent = frame6
	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.PaddingLeft = UDim.new(0, 5)
	uiPadding2.PaddingRight = UDim.new(0, 5)
	uiPadding2.PaddingTop = UDim.new(0, 5)
	uiPadding2.PaddingBottom = UDim.new(0, 5)
	uiPadding2.Parent = frame6

	imageButton3.MouseButton1Click:Connect(function()
		fn3(Traducao.TextoCopiado, v20, 5)
		YmpClipboard(v20)
	end)

	if arg == "ymp" then
		imageLabel.Image = "rbxassetid://83758613781843"
		imageLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		textLabel.Text = "YMP OFFICIAL"
		textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		textLabel2.Text = Traducao.Sistema
		textLabel2.TextColor3 = Color3.fromRGB(255, 0, 0)
		textLabel3.TextColor3 = Color3.fromRGB(255, 0, 0)
		Stroke(imageLabel, 255, 255, 255, 1)
		Stroke(frame4, 255, 255, 255, 1)
		Stroke(frame5, 255, 255, 255, 1)
		Stroke(imageButton3, 255, 255, 255, 1)
		Stroke(imageButton4, 255, 255, 255, 1)
		Stroke(textLabel2, 255, 255, 255, 0.5)
		Stroke(textLabel3, 255, 255, 255, 0.5)
		Stroke(textLabel, 255, 255, 255, 0.5)
	else
		imageLabel.Image = result3.image and result3.image ~= "" and result3.image or "rbxassetid://106804518898726"
		textLabel.Text = result3.displayName
		textLabel2.Text = text2
		Stroke(imageLabel, 50, 50, 50, 1)
		Stroke(frame4, 50, 50, 50, 1)
		Stroke(frame5, 50, 50, 50, 1)
		Stroke(imageButton3, 50, 50, 50, 1)
		Stroke(imageButton4, 50, 50, 50, 1)
		Stroke(textLabel, 50, 50, 50, 0.5)
	end

	Corner(imageLabel, 30)
	Corner(frame4, 30)
	Corner(frame5, 30)
	Corner(imageButton3, 30)
	Corner(imageButton4, 30)
	Corner(frame6, 5)
	Stroke(frame6, 50, 50, 50, 0.2)

	imageButton4.MouseButton1Click:Connect(function()
		if not flag19 then
			fn3(Traducao.ReportErro, Traducao.ReportErro1, 10)
			return
		end
		Reportar(text2, arg3, imageLabel.Image)
	end)

	if v21 then
		task.wait()
		ProFinal()
	end
end

local function fn17(arg, text2, arg2, arg3, arg4)
	layoutOrder += 1
	task.wait()
	local str10 = arg4 or ""

	local function fn18(arg5)
		local tbl17 = {}
		local n8 = 1

		while n8 <= #arg5 do
			local v20, v21, v22, v23 = string.find(arg5, "<:([%w_]+):(%d+)>", n8)

			if v20 then
				if v20 > n8 then
					table.insert(tbl17, { tipo = "texto", valor = string.sub(arg5, n8, v20 - 1) })
				end

				table.insert(tbl17, { tipo = "emoji", id = v23 })
				n8 = v21 + 1
			else
				table.insert(tbl17, { tipo = "texto", valor = string.sub(arg5, n8) })
				break
			end
		end

		return tbl17
	end

	local function fn19(arg5)
		if not (FotoTradu and FotoTradu.Image == "rbxassetid://72657045512999") then
			return arg5
		end

		local ok3, result3 = pcall(function()
			return TraduzirMsg(arg5)
		end)

		return ok3 and result3 or arg5
	end

	local v20 = fn18(str10)

	for _, v21 in ipairs(v20) do
		if v21.tipo == "texto" then
			v21.valor = fn19(v21.valor)
		end
	end

	local tbl17 = {}

	for _, v21 in ipairs(v20) do
		if v21.tipo == "emoji" then
			local id = v21.id
			local str11 = "YouTube Music Player/internal/Cache/emoji_" .. id .. ".png"

			if isfile and isfile(str11) then
				tbl17[id] = getcustomasset(str11)
			else
				local ok3, result3 = pcall(function()
					return game:HttpGet("https://cdn.discordapp.com/emojis/" .. id .. ".png")
				end)

				ok3 = ok3 and result3 and writefile
				local str12 = "rbxassetid://110787075859454"

				if ok3 then
					if pcall(function()
						writefile(str11, result3)
					end) and getcustomasset then
						str12 = getcustomasset(str11)
					end
				end

				tbl17[id] = str12
			end
		end
	end

	local str11 = "YouTube Music Player/internal/Cache/Dc_" .. tostring(arg) .. ".jpg"
	local image

	if isfile and isfile(str11) then
		image = getcustomasset(str11)
	else
		local ok3, result3 = pcall(function()
			return game:HttpGet(arg3)
		end)

		ok3 = ok3 and writefile
		image = "rbxassetid://106804518898726"

		if ok3 then
			if pcall(function()
				writefile(str11, result3)
			end) and getcustomasset then
				image = getcustomasset(str11)
			end
		end
	end

	if not Tela5.Visible or imageButton.Visible == true then
		NumeroGC()
	end

	local v21 = ChekFinal()
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0.9, 0, 0, 0)
	frame3.AutomaticSize = Enum.AutomaticSize.Y
	frame3.BackgroundTransparency = 1
	frame3.BorderSizePixel = 0
	frame3.LayoutOrder = layoutOrder
	frame3.Parent = ScrollGC
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Parent = frame3
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 10)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 40, 0, 40)
	imageLabel.Position = UDim2.new(0, 4, 0, 4)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = image
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 60, 0, 15)
	frame4.Position = UDim2.new(0, 47, 0, 12)
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text2 or ""
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 1)
	uiPadding.PaddingTop = UDim.new(0, 1)
	uiPadding.PaddingRight = UDim.new(0, 1)
	uiPadding.PaddingBottom = UDim.new(0, 1)
	uiPadding.Parent = textLabel
	local frame5 = Instance.new("Frame")
	frame5.Size = UDim2.new(0, 60, 0, 15)
	frame5.Position = UDim2.new(0, 112, 0, 12)
	frame5.BorderSizePixel = 0
	frame5.Parent = imageLabel
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -7, 1, 0)
	textLabel2.Position = UDim2.new(0, 4, 0, 0)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Font = Enum.Font.SourceSansBold
	textLabel2.TextScaled = true
	textLabel2.Parent = frame5
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(1, -10, 0, 0)
	frame6.AutomaticSize = Enum.AutomaticSize.Y
	frame6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame6.BackgroundTransparency = 0.7
	frame6.Parent = frame3
	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.PaddingLeft = UDim.new(0, 5)
	uiPadding2.PaddingRight = UDim.new(0, 5)
	uiPadding2.PaddingTop = UDim.new(0, 5)
	uiPadding2.PaddingBottom = UDim.new(0, 5)
	uiPadding2.Parent = frame6
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 17, 0, 17)
	imageButton3.Position = UDim2.new(0, 177, 0, 12)
	imageButton3.BorderSizePixel = 0
	imageButton3.Parent = imageLabel
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.Size = UDim2.new(1, -7, 1, 0)
	textLabel3.Position = UDim2.new(0, 3, 0, 0)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Font = Enum.Font.SourceSansBold
	textLabel3.TextScaled = true
	textLabel3.Text = "C"
	textLabel3.Parent = imageButton3
	local uiListLayout2 = Instance.new("UIListLayout")
	uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout2.Wraps = true
	uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout2.Padding = UDim.new(0, 2)
	uiListLayout2.Parent = frame6
	local uiPadding3 = Instance.new("UIPadding")
	uiPadding3.PaddingLeft = UDim.new(0, 5)
	uiPadding3.PaddingTop = UDim.new(0, 5)
	uiPadding3.PaddingRight = UDim.new(0, 5)
	uiPadding3.PaddingBottom = UDim.new(0, 5)
	uiPadding3.Parent = frame6

	imageButton3.MouseButton1Click:Connect(function()
		fn3(Traducao.TextoCopiado, arg4, 5)
		YmpClipboard(arg4)
	end)

	local function fn20(text3)
		if text3 == "" then
			return
		end
		local textLabel4 = Instance.new("TextLabel")
		textLabel4.BackgroundTransparency = 1
		textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel4.Font = Enum.Font.SourceSansBold
		textLabel4.TextSize = 14
		textLabel4.TextWrapped = true
		textLabel4.TextXAlignment = Enum.TextXAlignment.Left
		textLabel4.TextYAlignment = Enum.TextYAlignment.Top
		textLabel4.Text = text3
		local textSize = game:GetService("TextService"):GetTextSize(text3, 16, Enum.Font.SourceSansBold, Vector2.new(170, math.huge))
		local max = math.max
		local y = textSize.Y
		textLabel4.Size = UDim2.new(0, math.min(textSize.X, 170), 0, max(y, 21))
		textLabel4.Parent = frame6
	end

	local function fn21(arg5)
		local imageLabel2 = Instance.new("ImageLabel")
		imageLabel2.Size = UDim2.new(0, 21, 0, 21)
		imageLabel2.BackgroundTransparency = 1
		imageLabel2.Image = tbl17[arg5]
		imageLabel2.Parent = frame6
	end

	for _, v22 in ipairs(v20) do
		if v22.tipo == "texto" then
			fn20(v22.valor)
		else
			fn21(v22.id)
		end
	end

	if arg2 == "Mod" then
		textLabel.TextColor3 = Color3.fromRGB(255, 160, 122)
		frame4.BackgroundColor3 = Color3.fromRGB(255, 99, 71)
		frame5.BackgroundColor3 = Color3.fromRGB(255, 99, 71)
		imageButton3.BackgroundColor3 = Color3.fromRGB(255, 99, 71)
		textLabel2.Text = "Mod"
		textLabel2.TextColor3 = Color3.fromRGB(255, 160, 122)
		textLabel3.TextColor3 = Color3.fromRGB(255, 160, 122)
		Stroke(frame4, 255, 160, 122, 1)
		Stroke(imageLabel, 255, 160, 122, 1.5)
		Stroke(frame5, 255, 160, 122, 1)
		Stroke(imageButton3, 255, 160, 122, 1)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	elseif arg2 == "Admin" then
		textLabel.TextColor3 = Color3.fromRGB(220, 20, 60)
		frame4.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
		frame5.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
		imageButton3.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
		textLabel2.Text = "Admin"
		textLabel2.TextColor3 = Color3.fromRGB(220, 20, 60)
		textLabel3.TextColor3 = Color3.fromRGB(220, 20, 60)
		Stroke(frame4, 220, 20, 60, 1)
		Stroke(imageLabel, 220, 20, 60, 1)
		Stroke(frame5, 220, 20, 60, 1)
		Stroke(imageButton3, 220, 20, 60, 1)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	elseif arg2 == "Dev" then
		textLabel.TextColor3 = Color3.fromRGB(0, 190, 230)
		frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
		frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
		imageButton3.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
		textLabel2.Text = "Dev"
		textLabel2.TextColor3 = Color3.fromRGB(0, 190, 230)
		textLabel3.TextColor3 = Color3.fromRGB(0, 190, 230)
		Stroke(frame4, 0, 0, 0, 1.5)
		Stroke(imageLabel, 0, 0, 0, 1.5)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(frame5, 0, 0, 0, 1.5)
		Stroke(imageButton3, 0, 0, 0, 1.5)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	else
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		frame4.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
		frame5.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
		imageButton3.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
		textLabel2.Text = "Discord"
		textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
		Stroke(frame4, 255, 255, 255, 1)
		Stroke(imageLabel, 255, 255, 255, 1)
		Stroke(textLabel, 0, 0, 0, 0.5)
		Stroke(frame5, 255, 255, 255, 1)
		Stroke(imageButton3, 255, 255, 255, 1)
		Stroke(textLabel2, 0, 0, 0, 0.5)
		Stroke(textLabel3, 0, 0, 0, 0.5)
	end

	Corner(imageLabel, 30)
	Corner(frame4, 30)
	Corner(frame5, 30)
	Corner(imageButton3, 30)
	Corner(frame6, 5)
	Stroke(frame6, 50, 50, 50, 0.2)

	if v21 then
		task.wait()
		ProFinal()
	end
end

IndoFinal = function(arg)
	if arg == v13 then
		return
	end
	estadoAtual = arg
	local v20 = arg and udim23 or udim22

	if v13 then
		tween2:Cancel()
	end

	tween2 = v6:Create(FinalGC, tweenInfo3, { Position = v20 })
	tween2:Play()
end

ScrollGC:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	local y = ScrollGC.CanvasPosition.Y
	local flag22 = math.max(ScrollGC.AbsoluteCanvasSize.Y - ScrollGC.AbsoluteWindowSize.Y, 0) - y <= 120

	if flag22 ~= flag15 then
		flag15 = flag22
		IndoFinal(flag22)
	end
end)

FinalGC.MouseButton1Click:Connect(function()
	ProFinal()
end)

ScrollGC.ChildAdded:Connect(function()
	local tbl17 = {}
	EsperandoIMG.Visible = false
	ScrollGC.Visible = true

	for _, child in ipairs(ScrollGC:GetChildren()) do
		if child:IsA("Frame") then
			table.insert(tbl17, child)
		end
	end

	if #tbl17 > 30 then
		table.sort(tbl17, function(arg, arg2)
			return arg.LayoutOrder < arg2.LayoutOrder
		end)

		task.wait()
		tbl17[1]:Destroy()
	end
end)

local function fn18(arg)
	MsgErroGC.Visible = true
	MsgErroGC.Text = Traducao.GcBan .. " " .. tostring(arg or "")
	GCBox.Active = false
	GCBox.Visible = false
	SendGC.Visible = false
	Traduzir.Visible = false
	LinhaTraducao.Visible = false
	fn3(Traducao.Banido, Traducao.GcBan .. " " .. tostring(arg or ""), 10)
end

local function fn19()
	fn3(Traducao.Desbanido, Traducao.GcUnban, 10)

	if flag19 then
		MsgErroGC.Visible = false
		GCBox.Active = true
		GCBox.Visible = true
		SendGC.Visible = true
		Traduzir.Visible = true
		LinhaTraducao.Visible = true
	else
		MsgErroGC.Text = Traducao.GcKey
	end
end

local function fn20(arg)
	if arg == flag20 then
		return
	end

	if flag19 then
		return
	end

	if arg then
		if not flag16 and websocket_ ~= nil then
			flag20 = true
			MsgErroGC.Visible = false
			GCBox.Active = true
			GCBox.Visible = true
			SendGC.Visible = true
			Traduzir.Visible = true
			LinhaTraducao.Visible = true
			fn3(Traducao.Keyless, Traducao.KeylessOn, 15, 93360393539898)
		end
	elseif not flag19 and not flag16 then
		flag20 = false
		MsgErroGC.Visible = true
		MsgErroGC.Text = Traducao.GcKey
		GCBox.Active = false
		GCBox.Visible = false
		SendGC.Visible = false
		Traduzir.Visible = false
		LinhaTraducao.Visible = false
		fn3(Traducao.Keyless, Traducao.KeylessOff, 15, 93360393539898)
	end
end

-- Conexión websocket del chat global eliminada

local function fn21(arg)
	if not arg or arg == "" then
		return
	end

	if not CheckRequest() then
		return
	end

	local v20 = YmpRequest({
		Url = str3 .. "/sendgc",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({ key = KEY_ATUAL, hwid = YmpHwid(), Userid = userId, msg = arg }),
	})

	if v20 and v20.Body then
		local str10 = tostring(v20.Body):gsub("%s+", ""):gsub("\"", "")

		if str10 == "banned" then
			flag16 = true
			fn18()
		elseif str10 == "requestdenied" then
			fn3(Traducao.ErroCrackTitle, Traducao.ErroCrackText, 10)
		end
	end

	return v20
end

SendGC.MouseButton1Click:Connect(function()
	if Aviao.ImageTransparency ~= 0 then
		return
	end
	local text2 = GCBox.Text

	if text2 and text2 ~= "" then
		GCBox.Text = ""
		Aviao.ImageTransparency = 0.7
		fn21(text2)
		task.wait(3)
		Aviao.ImageTransparency = 0
	end
end)

GCBox.FocusLost:Connect(function()
	local match = GCBox.Text:gsub("[\r\n]", ""):match("^%s*(.-)%s*$")
	if match == "" then
		GCBox.Text = ""
		return
	end

	if #match > 200 then
		match = match:sub(1, 200)
	end

	GCBox.Text = match
end)

Regras.MouseButton1Click:Connect(function()
	fn3(Traducao.RegrasTi, Traducao.Regras, 10)
end)

NotificarGC.MouseButton1Click:Connect(function()
	if Sino.Image == "rbxassetid://115374069603142" then
		Sino.Image = "rbxassetid://89973491623305"
		fn3(Traducao.GCmudo, Traducao.GCmudoTexto, 6)
		flag17 = true
	else
		Sino.Image = "rbxassetid://115374069603142"
		fn3(Traducao.GCunmudo, Traducao.GCunmudoTexto, 6)
		flag17 = false
	end
end)

Denunciar.MouseButton1Click:Connect(function()
	if not Denunciar.Active then
		return
	end
	fn14(REPORT_ID)
end)

MotivoBox.FocusLost:Connect(function()
	local match = MotivoBox.Text:match("^%s*(.-)%s*$")

	if match == "" then
		MotivoBox.Text = ""
		REPORT_MOTIVO = nil
	else
		REPORT_MOTIVO = match
	end
end)

CancelarReport.MouseButton1Click:Connect(function()
	if not CancelarReport.Active then
		return
	end
	REPORT_ID = nil
	REPORT_MOTIVO = nil
	TextoReportFrame.Text = ""
	MotivoBox.Text = ""
	FotoReport.Image = ""
	ReportFrame.Visible = false
	frame.Visible = true
end)

CloseWarn.MouseButton1Click:Connect(function()
	if CloseWarn.BackgroundTransparency ~= 0 then
		return
	end
	Warn.Visible = false
	BlurEffect.Size = 0
	imageButton.Visible = true
	fn2("88442833509532")
end)

Traduzir.MouseButton1Click:Connect(function()
	if FotoTradu.Image == "rbxassetid://84867288877251" then
		FotoTradu.Image = "rbxassetid://72657045512999"
		fn3(Traducao.TraducaoSystem, Traducao.TraduOn, 5)
	else
		FotoTradu.Image = "rbxassetid://84867288877251"
		fn3(Traducao.TraducaoSystem, Traducao.TraduOff, 5)
	end
end)

Priv1.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri1, 8)
end)

Priv2.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri2, 8)
end)

Priv3.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri3, 8)
end)

Priv4.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri4, 8)
end)

Priv5.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri5, 8)
end)

Priv6.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri6, 8)
end)

local function fn22()
	pcall(function()
		game:GetService("Players").LocalPlayer:Kick("[Sussy Activity]\nPlease do not attempt to crack the script!")
	end)

	pcall(function()
		game:GetService("Players").LocalPlayer:Remove()
	end)

	pcall(function()
		game:GetService("Players").LocalPlayer:Destroy()
	end)

	pcall(function()
		game:GetService("Players").LocalPlayer.Parent = nil
	end)

	task.wait(0.35)

	while true do
	end
end

LockedUIS = { Video, imageButton2, frame2 }

for _, v20 in ipairs(LockedUIS) do
	if v20:IsA("GuiObject") then
		v20:GetPropertyChangedSignal("Visible"):Connect(function()
			if v20.Visible == true and flag19 == false then
				fn22()
			end
		end)
	end
end

SetKey = function(key)
	task.spawn(function()
		table.insert(tbl7, function()
			local ok3, result3 = pcall(function()
				return HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))
			end)

			local v20 = ok3 and result3
			local tbl17

			if v20 then
				tbl17 = v20
			else
				tbl17 = { { Key = "", Favorites = tbl6 or {} } }
			end

			tbl17[1] = tbl17[1] or { Key = "", Favorites = {} }
			tbl17[1].Key = key or ""

			pcall(function()
				writefile("YouTube Music Player/Internal/Data.json", HttpService:JSONEncode(tbl17))
			end)
		end)

		processQueue()
	end)
end

local function fn23()
	if flag19 == true then
		return
	end
	flag19 = true
	KeyFrame.Visible = false
	GetKey.Visible = false
	PremiumOkTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.VocePremium .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.VocePremiumTexto .. "</font>"
	frame2.Visible = true
	imageButton2.Parent = screenGui
	Video.Parent = Tela2
	BotaoMp4.BackgroundTransparency = 0
	NomeMp4.TextColor3 = Color3.fromRGB(154, 205, 50)
	BotaoMp4.AutoButtonColor = true
	AplicarFiltro.BackgroundTransparency = 0
	RemoverFiltro.BackgroundTransparency = 0
	NomeAplicarFiltro.TextColor3 = Color3.fromRGB(154, 205, 50)
	NomeRemoverFiltro.TextColor3 = Color3.fromRGB(178, 34, 34)
	AplicarFiltro.AutoButtonColor = true
	RemoverFiltro.AutoButtonColor = true
	PesquisarBox.PlaceholderText = Traducao.Pesquisar2
	imageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Stroke(imageButton, 255, 215, 0, 1.5)

	if not flag16 and websocket_ ~= nil and not flag20 then
		MsgErroGC.Visible = false
		GCBox.Active = true
		GCBox.Visible = true
		SendGC.Visible = true
		Traduzir.Visible = true
		LinhaTraducao.Visible = true
	end

	for _, child in ipairs(ScrollPagina:GetChildren()) do
		if child:IsA("ImageButton") and child.Name ~= "1" then
			child.BackgroundTransparency = 0
			local textLabel = child:FindFirstChildOfClass("TextLabel")

			if textLabel then
				textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end
	end

	for _, v20 in ipairs(scrolls) do
		for _, child in ipairs(v20:GetChildren()) do
			if child:IsA("ImageButton") and not child:GetAttribute("Privado") then
				local match = child.Name:match(":(.+)$")
				child.Name:match("^(.-):")
				local tag = child:FindFirstChild("tag")
				local imageLabel = child:FindFirstChildWhichIsA("ImageLabel")

				if match and tag and imageLabel then
					if match == "Video" or match == "Roblox" then
						child.BackgroundTransparency = 0
						imageLabel.BackgroundTransparency = 0
						imageLabel.ImageTransparency = 0
						tag.TextColor3 = Color3.fromRGB(255, 255, 255)
					end
				end
			end
		end
	end
end

Token = nil

local function fn24()
	pcall(function()
		local fn25

		fn25 = function(arg, arg2)
			local tbl17 = arg2 or {}
			local kind = typeof(arg)
			if kind == "nil" then
				return "nil"
			end

			if kind == "string" then
				return arg
			end

			if kind == "number" then
				if arg ~= arg then
					return "nan"
				end
				local str10 = ""

				if arg < 0 then
					arg = -arg
					str10 = "-"
				end

				local n8 = math.floor(arg)
				local n9 = arg - n8
				local str11 = ""

				repeat
					str11 = string.char(48 + n8 % 10) .. str11
					n8 = math.floor(n8 / 10)
				until n8 == 0

				if n9 > 0 then
					str11 ..= "."
					local n10 = 0

					while n9 > 0 and n10 < 6 do
						local n11 = n9 * 10
						local n12 = math.floor(n11)
						str11 ..= string.char(48 + n12)
						n9 = n11 - n12
						n10 += 1
					end
				end

				return str10 .. str11
			end

			if kind == "boolean" then
				if arg then
					return "true"
				end
				return "false"
			end

			if kind == "table" then
				if tbl17[arg] then
					return "{cycle}"
				end
				tbl17[arg] = true
				local tbl18 = {}

				for k, v20 in pairs(arg) do
					table.insert(tbl18, "[" .. fn25(k, tbl17) .. "]=" .. fn25(v20, tbl17))
				end

				return "{ " .. table.concat(tbl18, ", ") .. " }"
			end

			return "<" .. kind .. ">"
		end

		local jobId = game.JobId
		local str10 = HttpService:GenerateGUID(false) .. HttpService:GenerateGUID(false) .. jobId .. tick() .. os.clock() .. os.time() .. os.date("%Y%m%d%H%M%S") .. math.random() .. fn25({})
		local n8 = 2166136261

		for i = 1, #str10 do
			local v20 = string.byte(str10, i)
			local n9 = bit32.bxor(n8, v20) * 16777619 % 4294967296
			n8 = bit32.bxor(n9, bit32.rshift(n9, 13)) * 2246822519 % 4294967296
		end

		math.randomseed(n8)
		local str11 = ""
		local n9 = 1

		while true do
			local n10 = math.random(1, 62)
			local str12 = str11 .. string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", n10, n10)
			local n11 = bit32.bxor(n8, n10 * n9) * 3266489917 % 4294967296
			n8 = bit32.bxor(n11, bit32.lshift(n11, 11))

			if #str12 > 10 and bit32.band(n8, 3) == 0 then
				local n12 = math.floor(#str12 / 2)
				local str13 = string.sub(str12, 1, n12)
				str12 = string.sub(str12, n12 + 1) .. str13
			end

			if #str12 > 15 and bit32.band(n8, 7) == 1 then
				str11 = ""

				for i = #str12, 1, -1 do
					str11 ..= string.sub(str12, i, i)
				end
			else
				str11 = str12
			end

			local v20 = bit32.band(n8, 15)
			if not (#str11 > 110 and v20 == 0 or #str11 > 111) then
				n9 += 1
				continue
			end
			break
		end

		Token = str11
	end)
end

local function fn25(arg)
	local tbl17 = { bit32.bxor, bit32.lrotate, string.byte, string.format, tostring }

	if typeof(ishooked) == "function" and typeof(restorefunction) == "function" then
		local ok3, result3 = pcall(ishooked, ishooked)

		if ok3 and result3 then
			pcall(restorefunction, ishooked)
		end

		local v20 = ishooked

		for _, v21 in ipairs(tbl17) do
			local ok4, result4 = pcall(v20, v21)
			if not ok4 or result4 then
				return
			end
		end
	end

	local function fn26(arg2)
		local str10 = tostring(arg2 or "nil")
		local n8 = 2246822507
		local n9 = 3266489909
		local n10 = 2146245185

		for i = 1, #str10 do
			local v20 = string.byte(str10, i)
			n8 = (bit32.lrotate(bit32.bxor(n8, v20 + i), 13) * 5 + 3864292196) % 4294967296
			n9 = (bit32.lrotate(bit32.bxor(n9, n8 + v20), 17) * 3 + 2246822507) % 4294967296
			n10 = (bit32.lrotate(bit32.bxor(n10, n9 + i), 19) * 7 + 2815685321) % 4294967296
		end

		local v20 = bit32.bxor(n8, n9, n10, 2674666769)
		local str11 = string.format("%08x%08x%08x%08x%08x", n8, n9, n10, 2674666769, v20)
		return (str11 .. string.reverse(str11)):sub(1, 40)
	end

	if arg == fn26(Token) and #Token > 110 then
		fn23()
	else
		SetKey("")
	end
end

local function fn26(arg)
	local now = os.clock()
	local flag22 = false
	local str10 = nil

	task.spawn(function()
		local v20 = HttpService
		local str11 = str3 .. "/check/" .. arg .. "/" .. YmpHwid() .. "/" .. v20:UrlEncode(Token)

		local ok3, result3 = pcall(function()
			return game:HttpGet(str11)
		end)

		if not CheckRequest() then
			fn3(Traducao.Erro, Traducao.FalhaAoChekar, 10)
			KeyBox.Active = true
			str10 = "error"
			flag22 = true
			return
		end

		if not (ok3 and result3) then
			fn3(Traducao.Erro, Traducao.FalhaAoChekar, 10)
			KeyBox.Active = true
			str10 = "error"
			flag22 = true
			return
		end

		local v21 = string.lower(result3)

		if string.find(v21, "request denied") then
			str10 = "invalid"
			flag22 = true
			return
		end

		if string.find(v21, "too many request") then
			str10 = "too"
			flag22 = true
			return
		end

		if string.find(v21, "already registered") then
			str10 = "already"
			flag22 = true
			return
		end

		local v22 = string.match(result3, "Ok:%s*(.+)")

		if not v22 then
			str10 = "error"
			flag22 = true
			return
		end

		task.wait(1)
		fn25(v22)
		SetKey(arg)
		str10 = "ok"
		flag22 = true
	end)

	while not flag22 do
		if os.clock() - now > 10 then
			return "error"
		end
		task.wait()
	end

	return str10 or "error"
end

local function fn27()
	if CACHE_LINK ~= nil then
		YmpClipboard(CACHE_LINK)
		fn3(Traducao.LinkCopiado, Traducao.Navegador, 10)
		return CACHE_LINK
	end

	if not CheckRequest() then
		return nil
	end

	local ok3, result3 = pcall(function()
		return game:HttpGet(str3 .. "/getkey?hwid=" .. tostring(YmpHwid()))
	end)

	if not ok3 or not result3 then
		fn3("Premium Key", Traducao.KeyError, 5)
		return nil
	end
	local data2 = nil

	pcall(function()
		data2 = game:GetService("HttpService"):JSONDecode(result3)
	end)

	if not data2 or not data2.success or not data2.url then
		fn3("Premium Key", Traducao.KeyError, 5)
		return nil
	end
	CACHE_LINK = data2.url
	YmpClipboard(CACHE_LINK)
	fn3(Traducao.LinkCopiado, Traducao.Navegador, 10)
	return CACHE_LINK
end

SetaES.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(90, 30, 40) then
		GetKey.BackgroundColor3 = Color3.fromRGB(0, 190, 230)
		SetaES.BackgroundColor3 = Color3.fromRGB(0, 190, 230)
		SetaDI.BackgroundColor3 = Color3.fromRGB(0, 190, 230)
		GetKeyTexto.Text = Traducao.Robux
		GetKeyTexto.TextColor3 = Color3.fromRGB(185, 240, 255)
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(0, 190, 230) then
		GetKey.BackgroundColor3 = Color3.fromRGB(90, 30, 40)
		SetaES.BackgroundColor3 = Color3.fromRGB(90, 30, 40)
		SetaDI.BackgroundColor3 = Color3.fromRGB(90, 30, 40)
		GetKeyTexto.Text = Traducao.Link
		GetKeyTexto.TextColor3 = Color3.fromRGB(220, 80, 95)
	end
end)

SetaDI.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(90, 30, 40) then
		GetKey.BackgroundColor3 = Color3.fromRGB(0, 190, 230)
		SetaES.BackgroundColor3 = Color3.fromRGB(0, 190, 230)
		SetaDI.BackgroundColor3 = Color3.fromRGB(0, 190, 230)
		GetKeyTexto.Text = Traducao.Robux
		GetKeyTexto.TextColor3 = Color3.fromRGB(185, 240, 255)
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(0, 190, 230) then
		GetKey.BackgroundColor3 = Color3.fromRGB(90, 30, 40)
		SetaES.BackgroundColor3 = Color3.fromRGB(90, 30, 40)
		SetaDI.BackgroundColor3 = Color3.fromRGB(90, 30, 40)
		GetKeyTexto.Text = Traducao.Link
		GetKeyTexto.TextColor3 = Color3.fromRGB(220, 80, 95)
	end
end)

local function fn28(text2)
	fn3("Premium Key", text2, 5)
	KeyBox.Active = false
	KeyBox.TextColor3 = Color3.fromRGB(255, 0, 0)
	KeyBox.Text = text2
	task.wait(0.35)
	KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	KeyBox.Text = ""
	KeyBox.Active = true
end

local function fn29()
	if KEY_ATUAL and KEY_ATUAL ~= "" then
		KeyBox.Active = false
		fn24()

		if not KEY_ATUAL:match("^KEY_") and not KEY_ATUAL:match("^FREE_") then
			fn28(Traducao.KeyInvalida)
			SetKey("")
			return
		end

		local v20 = fn26(KEY_ATUAL)
		if v20 == true then
			return
		end

		if v20 == "invalid" then
			fn28(Traducao.KeyInvalida)
			SetKey("")
		elseif v20 == "error" then
			fn28(Traducao.KeyErro)
		elseif v20 == "already" then
			fn28(Traducao.JaTemKey)
		elseif v20 == "too" then
			fn28(Traducao.RateLi)
		end
	end
end

KeyBox.FocusLost:Connect(function()
	if KeyBox.Active and KeyBox.Text then
		local match = KeyBox.Text:match("^%s*(.-)%s*$")
		if match == "" then
			KeyBox.Text = ""
			return
		end
		KEY_ATUAL = match
		fn29()
	end
end)

GetKey.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(0, 190, 230) then
		fn3(Traducao.LinkCopiado, "https://www.roblox.com/games/113089627618447/CHAOTIC-Purchase", 8)
		YmpClipboard("https://www.roblox.com/games/113089627618447/CHAOTIC-Purchase")
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(90, 30, 40) then
		fn27()
	end
end)

uiScale = frame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", frame)

Resize = function()
	local viewportSize = currentCamera.ViewportSize
	uiScale.Scale = math.min(viewportSize.X * 0.8 / frame.AbsoluteSize.X / uiScale.Scale, viewportSize.Y * 0.8 / frame.AbsoluteSize.Y / uiScale.Scale, 1)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)

	task.defer(function()
		if flag8 then
			return
		end
		local v20 = v12
		local flag22 = v12

		if v20 then
			flag22 = v20.TimeLength > 0
		end

		if flag22 then
			setProgress(v20.TimePosition / v20.TimeLength)
		end
	end)
end

ResizeJa = function()
	imageButton.AnchorPoint = Vector2.new(0.5, 0)
	imageButton.Position = UDim2.new(0.5, 0, 0, 20)
end

ResizeMiniPlayer = function()
	local viewportSize = currentCamera.ViewportSize

	if viewportSize.Y > viewportSize.X then
		udim2 = UDim2.new(0.45, 0, 0.1, 0)
	else
		udim2 = UDim2.new(0.27, 0, 0.37, 0)
	end

	local udim24

	if flag10 then
		udim24 = UDim2.new(udim2.X.Scale * 1.4, 0, udim2.Y.Scale * 1.4, 0)
	else
		udim24 = udim2
	end

	imageButton2.Size = udim24
	imageButton2.Position = UDim2.new(1, -20, 1, -20)
end

currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	Resize()
	ResizeJa()
	ResizeMiniPlayer()
end)

Resize()
ResizeJa()
ResizeMiniPlayer()

game:GetService("GuiService").MenuOpened:Connect(function()
	if flag or not frame.Visible then
		return
	end
	frame.Visible = false
	imageButton.Visible = true
end)

v5.MessageOut:Connect(function(arg)
	if type(arg) ~= "string" then
		return
	end
	local str10 = arg:lower():gsub("%s+", "")

	if str10:match("^failedtoloadrbxasset://.+%.mp3$") or str10:match("^failedtoloadrbxasset://.+%.webm$") then
		-- aviso de error de medios eliminado
	end
end)

Corner(frame, 5)
Corner(imageButton, 10)
Corner(ContadorJA, 30)
Corner(Titulo, 30)
Corner(Mutar, 30)
Corner(BotaoFechar, 22)
Corner(Welcome, 5)
Corner(Navegacao, 5)
Corner(Playlist, 5)
Corner(TituloPlayL, 32)
Corner(FotoPlayL, 32)
Corner(Botao3, 5)
Corner(Botao4, 5)
Corner(Icone3, 5)
Corner(Icone4, 5)
Corner(EsquerdaPL, 5)
Corner(FrameAbaPL, 5)
Corner(DireitaPL, 5)
Corner(ErroPL, 5)
Corner(Dev, 5)
Corner(FotoDev, 50)
Corner(Social, 5)
Corner(SocialTitulo, 5)
Corner(You, 32)
Corner(IconeYou, 32)
Corner(Discord, 32)
Corner(IconeDiscord, 32)
Corner(Musica, 5)
Corner(Video, 5)
Corner(TempoAtual, 5)
Corner(TempoTotal, 5)
Corner(Repetir, 30)
Corner(Novamente, 30)
Corner(Miniplayer, 30)
Corner(BarraProgresso, 30)
Corner(Rastro, 30)
Corner(BolaProgresso, 30)
Corner(MicroBola, 10)
Corner(PlayerInfo, 5)
Corner(FotoAutor, 50)
Corner(Disco, 50)
Corner(Controles, 5)
Corner(Voltar, 40)
Corner(Retroceder, 40)
Corner(Play, 40)
Corner(Adiantar, 40)
Corner(Pular, 40)
Corner(MiniMusica, 10)
Corner(MiniVideo, 10)
Corner(MiniBack, 2, 0)
Corner(MiniRetroceder, 2, 0)
Corner(MiniPlay, 1, 0)
Corner(MiniAvancar, 1, 0)
Corner(MiniSkip, 1, 0)
Corner(TelaCheia, 1, 0)
Corner(FecharMini, 1, 0)
Corner(TituloEqua, 5)
Corner(EquaFrame, 5)
Corner(NoEquaFrame, 5)
Corner(ErroEqua, 5)
Corner(Volume, 5)
Corner(IconeVolume, 5)
Corner(Pitch, 5)
Corner(IconePitch, 5)
Corner(FrequenciaTitulo, 5)
Corner(Graves, 5)
Corner(IconeGraves, 5)
Corner(Medios, 5)
Corner(IconeMedios, 5)
Corner(Agudos, 5)
Corner(IconeAgudos, 5)
Corner(EfeitosTitulo, 5)
Corner(Nenhum, 5)
Corner(IconeNenhum, 5)
Corner(Reverb, 5)
Corner(IconeReverb, 5)
Corner(Echo, 5)
Corner(IconeEcho, 5)
Corner(Distortion, 5)
Corner(IconeDistortion, 5)
Corner(Chorus, 5)
Corner(IconeChorus, 5)
Corner(Flanger, 5)
Corner(IconeFlanger, 5)
Corner(Tremolo, 5)
Corner(IconeTremolo, 5)
Corner(Compressor, 5)
Corner(IconeCompressor, 5)
Corner(Radio, 5)
Corner(IconeRadio, 5)
Corner(Cinema, 5)
Corner(IconeCinema, 5)
Corner(Underwater, 5)
Corner(IconeUnderwater, 5)
Corner(Kid, 5)
Corner(IconeKid, 5)
Corner(Robot, 5)
Corner(IconeRobot, 5)
Corner(Slowed, 5)
Corner(IconeSlowed, 5)
Corner(ResetarEqua, 5)
Corner(Pesquisa, 5)
Corner(Lupa, 5)
Corner(Filtro, 5)
Corner(DownloadFrame, 5)
Corner(PaginaFrame, 5)
Corner(PaginaEsperandoFrame, 5)
Corner(PaginaEsperandoIcon, 5)
Corner(SemResultadoTexto, 5)
Corner(ErroTexto, 5)
Corner(Tutorial, 30)
Corner(BaixandoTexto, 5)
Corner(DownloadFrameTexto, 5)
Corner(Relevancia, 5)
Corner(DataUpload, 5)
Corner(Duracao, 5)
Corner(IconeRelevancia, 5)
Corner(IconeDataUpload, 5)
Corner(IconeDuracao, 5)
Corner(AplicarFiltro, 5)
Corner(RemoverFiltro, 5)
Corner(Thumbfor, 5)
Corner(Titulofor, 5)
Corner(TituloFiltro, 30)
Corner(TituloFormato, 30)
Corner(BotaoMp3, 13)
Corner(BotaoMp4, 5)
Corner(BotaoCancelar, 13)
Corner(TituloGC, 5)
Corner(GCFrame, 5)
Corner(Traduzir, 5)
Corner(SendGC, 5)
Corner(MsgFrame, 5)
Corner(AvisoGC, 30)
Corner(FinalGC, 32)
Corner(TituloPremium, 5)
Corner(Privilegios, 5)
Corner(Priv1, 35)
Corner(Priv2, 35)
Corner(Priv3, 35)
Corner(Priv4, 35)
Corner(Priv5, 35)
Corner(Priv6, 35)
Corner(IconePriv1, 35)
Corner(IconePriv2, 35)
Corner(IconePriv3, 35)
Corner(IconePriv4, 35)
Corner(IconePriv5, 35)
Corner(IconePriv6, 35)
Corner(frame2, 5)
Corner(PremiumOkTexto, 5)
Corner(KeyFrame, 5)
Corner(SendKey, 5)
Corner(GetKey, 5)
Corner(SetaES, 5)
Corner(SetaDI, 5)
Corner(ReportFrame, 5)
Corner(TituloReportFrame, 30)
Corner(TextoReportFrameFrame, 5)
Corner(Motivo, 5)
Corner(CancelarReport, 7)
Corner(FotoReport, 50)
Corner(Denunciar, 7)
Corner(Warn, 5)
Corner(TituloWarn, 30)
Corner(TextoWarnFrame, 5)
Corner(CloseWarn, 7)
Stroke(frame, 0, 0, 0, 5)
Stroke(imageButton, 50, 50, 50, 1.5)
Stroke(ContadorJA, 255, 255, 255, 1)
Stroke(ContadorJANU, 255, 255, 255, 0.5)
Stroke(Mutar, 255, 255, 255, 1)
Stroke(Titulo, 36, 36, 36, 1.5)
Stroke(TextoTitulo, 0, 0, 0, 1.5)
Stroke(Welcome, 50, 50, 50, 1.5)
Stroke(Navegacao, 50, 50, 50, 1.5)
Stroke(Playlist, 50, 50, 50, 1.5)
Stroke(TituloPlayL, 255, 255, 255, 1)
Stroke(FotoPlayL, 255, 255, 255, 1)
Stroke(NomePlayL, 255, 255, 255, 1)
Stroke(AbaPL, 255, 255, 255, 1)
Stroke(Botao3, 50, 50, 50, 2)
Stroke(Botao4, 50, 50, 50, 2)
Stroke(Icone3, 50, 50, 50, 2)
Stroke(Icone4, 50, 50, 50, 2)
Stroke(Nome3, 0, 0, 0, 1.5)
Stroke(Nome4, 0, 0, 0, 1.5)
Stroke(EsquerdaPL, 255, 255, 255, 1)
Stroke(FrameAbaPL, 255, 255, 255, 1)
Stroke(DireitaPL, 255, 255, 255, 1)
Stroke(Dev, 50, 50, 50, 1.5)
Stroke(FotoDev, 178, 34, 34, 1.5)
Stroke(TextoDev, 0, 0, 0, 2)
Stroke(Social, 50, 50, 50, 1.5)
Stroke(SocialTitulo, 50, 50, 50, 1.5)
Stroke(SocialTexto, 0, 0, 0, 2)
Stroke(Discord, 0, 0, 0, 1.5)
Stroke(IconeDiscord, 0, 0, 0, 1.5)
Stroke(TextoDiscord, 0, 0, 0, 1.5)
Stroke(You, 255, 255, 255, 1.5)
Stroke(IconeYou, 255, 255, 255, 1.5)
Stroke(TextoYou, 0, 0, 0, 1.5)
Stroke(Musica, 50, 50, 50, 1.5)
Stroke(Video, 50, 50, 50, 1.5)
Stroke(TempoAtual, 50, 50, 50, 1)
Stroke(TempoTotal, 50, 50, 50, 1)
Stroke(Repetir, 50, 50, 50, 1)
Stroke(Novamente, 50, 50, 50, 1)
Stroke(Miniplayer, 50, 50, 50, 1)
Stroke(BolaProgresso, 255, 255, 255, 1)
Stroke(BarraProgresso, 50, 50, 50, 1.5)
Stroke(PlayerInfo, 50, 50, 50, 1.5)
Stroke(FotoAutor, 178, 34, 34, 1.5)
Stroke(Disco, 178, 34, 34, 1.5)
Stroke(Controles, 178, 34, 34, 1.5)
Stroke(Voltar, 255, 255, 255, 1)
Stroke(Retroceder, 255, 255, 255, 1)
Stroke(Play, 255, 255, 255, 1)
Stroke(Adiantar, 255, 255, 255, 1)
Stroke(Pular, 255, 255, 255, 1)
Stroke(TituloMusica, 0, 0, 0, 1)
Stroke(MiniMusica, 255, 255, 255, 1, 0.5)
Stroke(MiniVideo, 255, 255, 255, 1, 0.5)
Stroke(TituloEqua, 50, 50, 50, 1.5)
Stroke(NomeEqua, 255, 255, 255, 1)
Stroke(EquaFrame, 50, 50, 50, 1.5)
Stroke(NoEquaFrame, 50, 50, 50, 1.5)
Stroke(Volume, 50, 50, 50, 2)
Stroke(IconeVolume, 50, 50, 50, 2)
Stroke(VolumeBox, 0, 0, 0, 1)
Stroke(Pitch, 50, 50, 50, 2)
Stroke(IconePitch, 50, 50, 50, 2)
Stroke(PitchBox, 0, 0, 0, 1)
Stroke(FrequenciaTitulo, 50, 50, 50, 2)
Stroke(TextoFrenquencia, 255, 255, 255, 0.4)
Stroke(Graves, 50, 50, 50, 2)
Stroke(IconeGraves, 50, 50, 50, 2)
Stroke(GravesBox, 0, 0, 0, 1)
Stroke(Medios, 50, 50, 50, 2)
Stroke(IconeMedios, 50, 50, 50, 2)
Stroke(MediosBox, 0, 0, 0, 1)
Stroke(Agudos, 50, 50, 50, 2)
Stroke(IconeAgudos, 50, 50, 50, 2)
Stroke(AgudosBox, 0, 0, 0, 1)
Stroke(EfeitosTitulo, 50, 50, 50, 2)
Stroke(Nenhum, 255, 0, 0, 2)
Stroke(IconeNenhum, 255, 0, 0, 2)
Stroke(NenhumTexto, 0, 0, 0, 1)
Stroke(Reverb, 50, 50, 50, 2)
Stroke(IconeReverb, 50, 50, 50, 2)
Stroke(ReverbTexto, 0, 0, 0, 1)
Stroke(Echo, 50, 50, 50, 2)
Stroke(IconeEcho, 50, 50, 50, 2)
Stroke(EchoTexto, 0, 0, 0, 1)
Stroke(Distortion, 50, 50, 50, 2)
Stroke(IconeDistortion, 50, 50, 50, 2)
Stroke(DistortionTexto, 0, 0, 0, 1)
Stroke(Chorus, 50, 50, 50, 2)
Stroke(IconeChorus, 50, 50, 50, 2)
Stroke(ChorusTexto, 0, 0, 0, 1)
Stroke(Flanger, 50, 50, 50, 2)
Stroke(IconeFlanger, 50, 50, 50, 2)
Stroke(FlangerTexto, 0, 0, 0, 1)
Stroke(Tremolo, 50, 50, 50, 2)
Stroke(IconeTremolo, 50, 50, 50, 2)
Stroke(TremoloTexto, 0, 0, 0, 1)
Stroke(Compressor, 50, 50, 50, 2)
Stroke(IconeCompressor, 50, 50, 50, 2)
Stroke(CompressorTexto, 0, 0, 0, 1)
Stroke(Radio, 50, 50, 50, 2)
Stroke(IconeRadio, 50, 50, 50, 2)
Stroke(RadioTexto, 0, 0, 0, 1)
Stroke(Cinema, 50, 50, 50, 2)
Stroke(IconeCinema, 50, 50, 50, 2)
Stroke(CinemaTexto, 0, 0, 0, 1)
Stroke(Underwater, 50, 50, 50, 2)
Stroke(IconeUnderwater, 50, 50, 50, 2)
Stroke(UnderwaterTexto, 0, 0, 0, 1)
Stroke(Kid, 50, 50, 50, 2)
Stroke(IconeKid, 50, 50, 50, 2)
Stroke(KidTexto, 0, 0, 0, 1)
Stroke(Robot, 50, 50, 50, 2)
Stroke(IconeRobot, 50, 50, 50, 2)
Stroke(RobotTexto, 0, 0, 0, 1)
Stroke(Slowed, 50, 50, 50, 2)
Stroke(IconeSlowed, 50, 50, 50, 2)
Stroke(SlowedTexto, 0, 0, 0, 1)
Stroke(ResetarEqua, 20, 20, 20, 2)
Stroke(ResetarTexto, 255, 255, 255, 1)
Stroke(TextoEfeitos, 255, 255, 255, 0.4)
Stroke(Pesquisa, 50, 50, 50, 1.5)
Stroke(Lupa, 50, 50, 50, 1.5)
Stroke(PesquisarBox, 255, 0, 0, 0.3)
Stroke(Filtro, 50, 50, 50, 2)
Stroke(Tutorial, 50, 50, 50, 1.5)
Stroke(TutoTexto, 255, 255, 255, 0.5)
Stroke(DownloadFrame, 50, 50, 50, 1.5)
Stroke(PaginaFrame, 50, 50, 50, 1.5)
Stroke(PaginaEsperandoFrame, 50, 50, 50, 1.5)
Stroke(PaginaEsperandoIcon, 50, 50, 50, 1.5)
Stroke(Relevancia, 50, 50, 50, 2)
Stroke(DataUpload, 50, 50, 50, 2)
Stroke(Duracao, 50, 50, 50, 2)
Stroke(IconeRelevancia, 50, 50, 50, 2)
Stroke(IconeDataUpload, 50, 50, 50, 2)
Stroke(IconeDuracao, 50, 50, 50, 2)
Stroke(AplicarFiltro, 50, 50, 50, 2)
Stroke(RemoverFiltro, 50, 50, 50, 2)
Stroke(Thumbfor, 50, 50, 50, 1.5)
Stroke(Titulofor, 50, 50, 50, 1.5)
Stroke(BotaoMp3, 30, 215, 96, 1.5)
Stroke(BotaoMp4, 50, 50, 50, 1.5)
Stroke(BotaoCancelar, 50, 50, 50, 1.5)
Stroke(TituloGC, 50, 50, 50, 1.5)
Stroke(NomeGC, 255, 255, 255, 1)
Stroke(GCFrame, 50, 50, 50, 1.5)
Stroke(MsgFrame, 50, 50, 50, 1)
Stroke(Traduzir, 50, 50, 50, 1)
Stroke(SendGC, 50, 50, 50, 1)
Stroke(FinalGC, 255, 255, 255, 1)
Stroke(TituloPremium, 50, 50, 50, 1.5)
Stroke(NomePremium, 0, 0, 200, 1)
Stroke(Privilegios, 50, 50, 50, 1.5)
Stroke(Priv1, 0, 0, 0, 2)
Stroke(Priv2, 0, 0, 0, 2)
Stroke(Priv3, 0, 0, 0, 2)
Stroke(Priv4, 0, 0, 0, 2)
Stroke(Priv5, 0, 0, 0, 2)
Stroke(Priv6, 0, 0, 0, 2)
Stroke(IconePriv1, 0, 0, 0, 2)
Stroke(IconePriv2, 0, 0, 0, 2)
Stroke(IconePriv3, 0, 0, 0, 2)
Stroke(IconePriv4, 0, 0, 0, 1.5)
Stroke(IconePriv5, 0, 0, 0, 2)
Stroke(IconePriv6, 0, 0, 0, 2)
Stroke(TextoPriv1, 0, 0, 0, 1)
Stroke(TextoPriv2, 0, 0, 0, 1)
Stroke(TextoPriv3, 0, 0, 0, 1)
Stroke(TextoPriv4, 0, 0, 0, 1)
Stroke(TextoPriv5, 0, 0, 0, 1)
Stroke(TextoPriv6, 0, 0, 0, 1)
Stroke(frame2, 50, 50, 50, 1.5)
Stroke(KeyFrame, 50, 50, 50, 1.5)
Stroke(SendKey, 50, 50, 50, 1.5)
Stroke(KeyBox, 0, 0, 0, 1.5)
Stroke(GetKey, 0, 0, 0, 1.5)
Stroke(SetaES, 0, 0, 0, 1.5)
Stroke(SetaDI, 0, 0, 0, 1.5)
Stroke(GetKeyTexto, 0, 0, 0, 1.5)
Stroke(ReportFrame, 255, 0, 0, 5)
Stroke(TituloReportFrame, 50, 50, 50, 1.5)
Stroke(TextoTituloReportFrame, 0, 0, 0, 1.5)
Stroke(TextoReportFrameFrame, 50, 50, 50, 1.5)
Stroke(CancelarReport, 0, 0, 0, 1.5)
Corner(Regras, 30)
Corner(NotificarGC, 30)
Stroke(Motivo, 50, 50, 50, 1)
Stroke(FotoReport, 50, 50, 50, 1.5)
Stroke(Denunciar, 0, 0, 0, 1.5)
Stroke(DenunciarTexto, 0, 0, 0, 1.5)
Stroke(CancelarReportTexto, 0, 0, 0, 1.5)
Stroke(Warn, 255, 0, 0, 5)
Stroke(TituloWarn, 50, 50, 50, 1.5)
Stroke(TextoTituloWarn, 0, 0, 0, 1.5)
Stroke(TextoWarnFrame, 50, 50, 50, 1.5)
Stroke(CloseWarn, 0, 0, 0, 1.5)
Stroke(CloseWarnTexto, 0, 0, 0, 1.5)

-- Se eliminan los apartados "Audio adjustment" y "Add New"
Botao3:Destroy()
Botao4:Destroy()
Navegacao.Visible = false

-- Chat global / keyless desactivado

pcall(function()
	local data2 = HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))

	if data2[1] and data2[1].Key and data2[1].Key ~= "" then
		KEY_ATUAL = data2[1].Key
		KeyBox.Text = KEY_ATUAL
		fn29()
	end
end)

frame.Visible = true
]=]
rowActionBtn("Songs", "Open Music", function()
	if _G.__SinisterYMPOpen then
		local still = false
		pcall(function()
			local cg = game:GetService("CoreGui")
			for _, g in ipairs(cg:GetChildren()) do
				if g:IsA("ScreenGui") and (g.Name == "SinisterYMP" or tostring(g.Name):find("YMP")) then
					still = true
					g.Enabled = true
					for _, d in ipairs(g:GetDescendants()) do
						if d.Name == "Main" or d.Name == "Frame" then
							pcall(function() d.Visible = true end)
						end
					end
				end
			end
		end)
		if still then return end
		_G.__SinisterYMPOpen = false
	end
	local ok, err = pcall(function()
		if type(getgenv) == "function" then getgenv().YMP = false end
		local fn, e = loadstring(__SINISTER_YMP_SRC)
		if not fn then error(e or "loadstring failed") end
		fn()
		_G.__SinisterYMPOpen = true
	end)
	if not ok then
		warn("[Voryx.gg] Open Music failed: " .. tostring(err))
		pcall(function()
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Open Music",
				Text = tostring(err),
				Duration = 6,
			})
		end)
	end
end)

do
	local songParent = game:GetService("CoreGui")
	local starterGui = game:GetService("StarterGui")
	local assetFunction = getcustomasset or getsynasset

	local function notifySong(title, message)
		warn("[Voryx " .. string.upper(title) .. "] " .. tostring(message))
		pcall(function()
			starterGui:SetCore("SendNotification", {
				Title = title,
				Text = tostring(message),
				Duration = 6
			})
		end)
	end

	local function fileExists(path)
		if type(isfile) ~= "function" then
			return false
		end
		local ok, exists = pcall(isfile, path)
		return ok and exists == true
	end

	local function validAudio(data)
		if type(data) ~= "string" or #data < 2048 then
			return false
		end
		local header = data:sub(1, 256):lower()
		return not (
			header:find("<html", 1, true)
			or header:find("<!doctype", 1, true)
			or header:find("access denied", 1, true)
			or header:find("not found", 1, true)
			or header:find("error", 1, true)
		)
	end

	local function downloadAudio(url, path)
		if type(writefile) ~= "function" then
			return false, "writefile no está disponible"
		end

		local data, lastError
		local requestFunction = request
			or http_request
			or (syn and syn.request)
			or (fluxus and fluxus.request)

		if type(requestFunction) == "function" then
			local ok, response = pcall(requestFunction, {
				Url = url,
				Method = "GET",
				Headers = {
					["User-Agent"] = "Mozilla/5.0",
					["Accept"] = "audio/mpeg,audio/*;q=0.9,*/*;q=0.8"
				}
			})
			if ok and type(response) == "table" then
				local code = tonumber(response.StatusCode or response.Status or response.status_code) or 0
				local body = response.Body or response.body
				if (code == 0 or (code >= 200 and code < 300)) and validAudio(body) then
					data = body
				else
					lastError = "respuesta HTTP inválida (" .. tostring(code) .. ")"
				end
			elseif not ok then
				lastError = tostring(response)
			end
		end

		if not data then
			local ok, result = pcall(function()
				return game:HttpGet(url, true)
			end)
			if ok and validAudio(result) then
				data = result
			elseif not ok then
				lastError = tostring(result)
			elseif not lastError then
				lastError = "el enlace no devolvió un MP3 válido"
			end
		end

		if not data then
			return false, lastError or "no se pudo descargar el audio"
		end

		local ok, err = pcall(writefile, path, data)
		if not ok then
			return false, tostring(err)
		end
		return true
	end

	local function addSong(config)
		local sound
		local wantedOn = false
		local preparing = false
		local started = false
		local loadedConnection

		local function destroySound()
			if loadedConnection then
				loadedConnection:Disconnect()
				loadedConnection = nil
			end
			if sound then
				pcall(function() sound:Destroy() end)
				sound = nil
			end
			started = false
		end

		local function createSound()
			if type(assetFunction) ~= "function" then
				return false, "getcustomasset/getsynasset no está disponible"
			end

			local ok, assetId = pcall(assetFunction, config.file)
			if not ok or type(assetId) ~= "string" or assetId == "" then
				return false, "el archivo local todavía no está disponible"
			end

			destroySound()
			sound = Instance.new("Sound")
			sound.Name = config.soundName
			sound.SoundId = assetId
			sound.Volume = config.volume
			sound.Looped = true
			sound.Parent = songParent

			if config.startAt and config.startAt > 0 then
				pcall(function() sound.TimePosition = config.startAt end)
				loadedConnection = sound.Loaded:Connect(function()
					if loadedConnection then
						loadedConnection:Disconnect()
						loadedConnection = nil
					end
					if sound and sound.Parent then
						pcall(function() sound.TimePosition = config.startAt end)
					end
				end)
			end
			return true
		end

		local function playNow()
			if not sound or not sound.Parent then
				return
			end
			if started then
				local ok = pcall(function() sound:Resume() end)
				if not ok then
					pcall(function() sound:Play() end)
				end
			else
				if config.startAt and config.startAt > 0 then
					pcall(function() sound.TimePosition = config.startAt end)
				end
				pcall(function() sound:Play() end)
				started = true
			end
		end

		local function prepare()
			if sound and sound.Parent then
				if wantedOn then playNow() end
				return
			end
			if preparing then return end
			preparing = true

			local alreadyDownloaded = fileExists(config.file)
			local created = select(1, createSound())

			if not created then
				if not alreadyDownloaded then
					notifySong(config.title, "Descargando " .. config.title .. " por primera vez...")
				end
				local downloaded, downloadError = downloadAudio(config.url, config.file)
				if not downloaded then
					preparing = false
					if config.notifications then
						notifySong(config.title, "No se pudo descargar: " .. tostring(downloadError))
					else
						warn("[Voryx SONGS] " .. config.title .. ": " .. tostring(downloadError))
					end
					return
				end
				local okCreate, createError = createSound()
				if not okCreate then
					preparing = false
					if config.notifications then
						notifySong(config.title, tostring(createError))
					else
						warn("[Voryx SONGS] " .. config.title .. ": " .. tostring(createError))
					end
					return
				end
			end

			preparing = false
			if wantedOn then playNow() end
		end

		if fileExists(config.file) then
			task.defer(function()
				if not sound then
					createSound()
				end
			end)
		end

		rowToggle("Songs", config.title, nil, false, function(on)
			wantedOn = on
			if on then
				if sound and sound.Parent then
					playNow()
				else
					task.spawn(prepare)
				end
			elseif sound then
				pcall(function() sound:Pause() end)
			end
		end)
	end

	local songs = {
		{
			title = "Tuff Song",
			url = "https://files.catbox.moe/rvf2vy.mp3",
			file = "tuffsong.mp3",
			soundName = "CTDuels_TuffSong",
			volume = 0.75
		},
		{
			title = "orula",
			url = "https://files.catbox.moe/v20ko9.mp3",
			file = "friosong.mp3",
			soundName = "CTDuels_Orula",
			volume = 0.85
		},
		{
			title = "X.O.X.O",
			url = "https://files.catbox.moe/jghp0f.mp3",
			file = "xoxosong.mp3",
			soundName = "CTDuels_XOXO",
			volume = 0.75
		},
		{
			title = "beretta",
			url = "https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3",
			file = "overseer_beretta_filegarden.mp3",
			soundName = "CTDuels_Beretta",
			volume = 0.75,
			startAt = 10,
			notifications = true
		},
		{
			title = "to the O",
			url = "https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3",
			file = "overseer_to_the_o_filegarden.mp3",
			soundName = "CTDuels_ToTheO",
			volume = 0.75,
			notifications = true
		},
		{
			title = "LAJA",
			url = "https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3",
			file = "overseer_laja_nadie_ta_frio_filegarden.mp3",
			soundName = "CTDuels_LAJA",
			volume = 0.75,
			notifications = true
		},
		{
			title = "HORA 0",
			url = "https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3",
			file = "overseer_hora_0_filegarden.mp3",
			soundName = "CTDuels_HORA_0",
			volume = 0.75,
			notifications = true
		},
		{
			title = "Lucid Dreams",
			url = "https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3",
			file = "overseer_lucid_dreams_filegarden.mp3",
			soundName = "CTDuels_LucidDreams",
			volume = 0.75,
			notifications = true
		}
	}

	for _, config in ipairs(songs) do
		addSong(config)
	end
end

local saveBtn; saveBtn = rowActionBtn("Settings", "Save Config", function()
	if saveConfig then
		local ok, saved = pcall(saveConfig, saveBtn)
		if (not ok or saved ~= true) and State._lastSaveError then
			warn("[Voryx AUTO SAVE] " .. tostring(State._lastSaveError))
		end
	elseif State.savePositionBackup then
		local saved = State.savePositionBackup()
		if saveBtn and saveBtn.Parent then
			local previous = saveBtn.Text
			saveBtn.Text = saved and "Positions Saved!" or "Save Failed!"
			task.delay(1.5, function()
				if saveBtn and saveBtn.Parent then saveBtn.Text = previous end
			end)
		end
	end
end)

local importCodeBoxRef = nil
local importCodeRaw = ""
do
	local c = baseCard("Settings", 72)
	cLabel(c, "Share Code", 10, 200, 11, WHITE, Enum.Font.GothamBold)
	local sl = cLabel(c, "Pega el código aquí para Import", 10, 240, 9, DIM, Enum.Font.Gotham)
	sl.Position = UDim2.new(0, 10, 0, 28)
	local box = Instance.new("TextBox", c)
	box.Size = UDim2.new(1, -20, 0, 26)
	box.Position = UDim2.new(0, 10, 0, 42)
	box.BackgroundColor3 = INPUT_BG
	box.BackgroundTransparency = INPUT_TRANSPARENCY
	box.BorderSizePixel = 0
	box.Text = ""
	box.PlaceholderText = "SV1:..."
	box.TextColor3 = WHITE
	box.PlaceholderColor3 = DIM
	box.Font = Enum.Font.Code
	box.TextSize = 10
	box.ClearTextOnFocus = false
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.ZIndex = 6
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
	box:GetPropertyChangedSignal("Text"):Connect(function()
		importCodeRaw = box.Text or ""
	end)
	importCodeBoxRef = box
end

local function _sinisterBuildLiveConfigJson()
	-- compact share payload (short keys)
	local ok, encoded = pcall(function()
		local cfg = {
			v = 9,
			ns = NS, cs = CS,
			ln = State.profileLaggerNormalSpeed, lc = State.profileLaggerCarrySpeed,
			cn = State.profileCustomNormalSpeed, cc = State.profileCustomCarrySpeed,
			sp = State.speedProfile,
			ls = LS, l2 = LS2,
			us = uiScaleValue,
			bg = State.backgroundAssetId,
			bs = State.buttonsSizeValue,
			bh = State.buttonsShape,
			st = State.speedToggled == true,
			lm = State.laggerToggled == true,
			ac = State.autoCarryEnabled == true,
			b1 = State.batV1Speed, b2 = State.batV2Speed,
			im = State.selectedIntroMusic,
			ni = State.noIntro == true,
		}
		if CONFIG then
			cfg.sr = CONFIG.STEAL_RANGE
			cfg.ae = CONFIG.AUTO_STEAL_ENABLED == true
		end
		return HttpService:JSONEncode(cfg)
	end)
	if ok and type(encoded) == "string" and encoded ~= "" then return encoded end
	return nil
end
local function _sinisterEncodeShare(raw)
	if type(raw) ~= "string" or raw == "" then return nil end
	local ok, encoded = pcall(function()
		if crypt and crypt.base64encode then return "S2:" .. crypt.base64encode(raw) end
		if base64_encode then return "S2:" .. base64_encode(raw) end
		return "S0:" .. raw
	end)
	if ok and type(encoded) == "string" then return encoded end
	return "S0:" .. raw
end
local function _sinisterExpandShare(tbl)
	if type(tbl) ~= "table" then return tbl end
	-- map short keys -> full config keys for loadConfig compatibility
	local map = {
		v = "configVersion", ns = "normalSpeed", cs = "carrySpeed",
		ln = "profileLaggerNormalSpeed", lc = "profileLaggerCarrySpeed",
		cn = "profileCustomNormalSpeed", cc = "profileCustomCarrySpeed",
		sp = "speedProfile", ls = "laggerSpeed", l2 = "laggerCarrySpeed",
		us = "uiScale", bg = "backgroundAssetId", bs = "buttonsSizeValue",
		bh = "buttonsShape", st = "speedToggled", lm = "laggerMode",
		ac = "autoCarryEnabled", b1 = "batV1Speed", b2 = "batV2Speed",
		im = "selectedIntroMusic", ni = "noIntro", sr = "stealRadius", ae = "autoStealEnabled",
	}
	local out = {}
	for k, v in pairs(tbl) do
		out[map[k] or k] = v
	end
	if out.configVersion == nil then out.configVersion = 9 end
	return out
end
local function _sinisterDecodeShare(code)
	if type(code) ~= "string" then return nil end
	code = code:gsub("^%s+", ""):gsub("%s+$", "")
	if code == "" then return nil end
	local raw = nil
	if code:sub(1, 3) == "S2:" or code:sub(1, 4) == "SV1:" then
		local payload = code:sub(code:sub(1, 3) == "S2:" and 4 or 5)
		local ok, decoded = pcall(function()
			if crypt and crypt.base64decode then return crypt.base64decode(payload) end
			if base64_decode then return base64_decode(payload) end
			return nil
		end)
		if ok and type(decoded) == "string" and decoded ~= "" then raw = decoded end
	elseif code:sub(1, 3) == "S0:" or code:sub(1, 4) == "SV0:" then
		raw = code:sub(code:sub(1, 3) == "S0:" and 4 or 5)
	elseif code:sub(1, 1) == "{" then
		raw = code
	else
		raw = code
	end
	return raw
end


local genBtn
genBtn = rowActionBtn("Settings", "Generate Code", function()
	local function setMsg(msg)
		if genBtn and genBtn.Parent then
			genBtn.Text = msg
			task.delay(1.8, function() if genBtn and genBtn.Parent then genBtn.Text = "Generate Code" end end)
		end
	end
	State._configLoading = false; State._configLoadFailed = false; State._configLoaded = true
	State._saveInProgress = false; State._allowInitialConfigCreation = true
	pcall(function() if saveConfig then saveConfig(genBtn) end end)
	task.wait(0.05)
	local raw = nil
	if type(State._lastConfigJson) == "string" and State._lastConfigJson ~= "" then raw = State._lastConfigJson end
	if not raw and State._safeReadFile then local r = State._safeReadFile(CONFIG_FILE); if type(r) == "string" and r ~= "" then raw = r end end
	if not raw then raw = _sinisterBuildLiveConfigJson() end
	if type(raw) ~= "string" or raw == "" then setMsg("No data") return end
	pcall(function()
		if State._safeWriteFile then State._safeWriteFile(CONFIG_FILE, raw)
		elseif type(writefile) == "function" then writefile(CONFIG_FILE, raw) end
		State._lastConfigJson = raw
	end)
	local code = _sinisterEncodeShare(raw)
	if not code then setMsg("Encode fail") return end
	importCodeRaw = code
	if importCodeBoxRef and importCodeBoxRef.Parent then importCodeBoxRef.Text = code end
	local copied = _sinisterCopyText(code)
	setMsg(copied and "Copied!" or "Ready (no clip)")
end)
local importBtn
importBtn = rowActionBtn("Settings", "Import Config", function()
	local function setMsg(msg)
		if importBtn and importBtn.Parent then
			importBtn.Text = msg
			task.delay(1.8, function() if importBtn and importBtn.Parent then importBtn.Text = "Import Config" end end)
		end
	end
	local code = importCodeRaw
	if (not code or code == "") and importCodeBoxRef then code = importCodeBoxRef.Text end
	local decoded = _sinisterDecodeShare(code)
	if type(decoded) ~= "string" or decoded == "" then setMsg("Invalid code") return end
	local okJ, decodedTable = pcall(function() return HttpService:JSONDecode(decoded) end)
	if not okJ or type(decodedTable) ~= "table" then setMsg("Bad JSON") return end
	decodedTable = _sinisterExpandShare(decodedTable)
	local decodedFull = HttpService:JSONEncode(decodedTable)
	local okW = false
	if State._safeWriteFile then okW = State._safeWriteFile(CONFIG_FILE, decodedFull) == true
	elseif type(writefile) == "function" then okW = pcall(writefile, CONFIG_FILE, decodedFull) end
	State._lastConfigJson = decodedFull; State._configLoaded = true; State._configLoadFailed = false
	local okL = pcall(function() if loadConfig then loadConfig() end end)
	setMsg((okW or okL) and "Imported!" or "Partial import")
end)

rowActionBtn("Settings", "Reset Mobile Buttons", function()
    if resetMobileButtons then
        resetMobileButtons()
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -150, 0, 80)
    end
    if setAutoGrabLocked then
        setAutoGrabLocked(false, true)
    end
    if setAutoGrab then
        setAutoGrab(false)
    end
end)

end

State.buildBackgroundPage = function()
	makeSecHeader("Background", "Background Images")

	local infoCard = baseCard("Background", 46)
	cLabel(infoCard, "Choose a background", 10, 250, 11, WHITE, Enum.Font.GothamBold)
	local infoSub = cLabel(infoCard, "Tap an image to apply and save it", 10, 280, 9, DIM, Enum.Font.Gotham)
	infoSub.Size = UDim2.new(1, -20, 0, 14)
	infoSub.Position = UDim2.new(0, 10, 0, 25)

	local totalBgs = #State.backgroundAssetIds
	local rows = math.ceil(totalBgs / 2)
	local gridH = rows * 88 + 8

	local grid = Instance.new("Frame", pg("Background"))
	grid.Name = "BackgroundImageGrid"
	grid.Size = UDim2.new(1, -4, 0, gridH)
	grid.BackgroundTransparency = 1
	grid.BorderSizePixel = 0
	grid.ClipsDescendants = false
	grid.LayoutOrder = lo("Background")
	grid.ZIndex = 4

	local layout = Instance.new("UIGridLayout", grid)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.FillDirectionMaxCells = 2
	layout.CellSize = UDim2.new(0.5, -5, 0, 80)
	layout.CellPadding = UDim2.new(0, 8, 0, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Top

	for index, assetId in ipairs(State.backgroundAssetIds) do
		local thumb = Instance.new("ImageButton", grid)
		thumb.Name = "BackgroundImage" .. tostring(index)
		thumb.LayoutOrder = index
		thumb.BackgroundColor3 = Color3.fromRGB(12, 24, 16)
		thumb.BackgroundTransparency = 0
		thumb.BorderSizePixel = 0
		thumb.AutoButtonColor = false
		thumb.ClipsDescendants = true
		local idStr = tostring(assetId)
		thumb.ImageColor3 = Color3.fromRGB(255, 255, 255)
		thumb.ImageTransparency = 0
		thumb.ScaleType = Enum.ScaleType.Crop
		thumb.Image = "rbxassetid://" .. idStr
		task.spawn(function()
			pcall(function()
				game:GetService("ContentProvider"):PreloadAsync({"rbxassetid://" .. idStr})
			end)
			for i = 1, 6 do
				if not thumb or not thumb.Parent then return end
				thumb.Image = "rbxassetid://" .. idStr
				thumb.ImageColor3 = Color3.fromRGB(255, 255, 255)
				thumb.ImageTransparency = 0
				task.wait(0.25)
			end
			-- if still not visible try rbxthumb
			if thumb and thumb.Parent then
				thumb.Image = "rbxthumb://type=Asset&id=" .. idStr .. "&w=420&h=420"
			end
		end)
		thumb.ZIndex = 6
		Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 12)

		local thumbStroke = Instance.new("UIStroke", thumb)
		thumbStroke.Color = BORDER
		thumbStroke.Thickness = 1

		local badge = Instance.new("TextLabel", thumb)
		badge.AnchorPoint = Vector2.new(1, 1)
		badge.Size = UDim2.new(0, 28, 0, 18)
		badge.Position = UDim2.new(1, -5, 1, -5)
		badge.BackgroundColor3 = Color3.fromRGB(12, 22, 40)
		badge.BackgroundTransparency = 0.08
		badge.BorderSizePixel = 0
		badge.Text = tostring(index)
		badge.TextColor3 = WHITE
		badge.Font = Enum.Font.GothamBlack
		badge.TextSize = 9
		badge.ZIndex = 8
		Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)

		State.imageChoiceVisuals[assetId] = {stroke=thumbStroke, badge=badge, index=index}
		thumb.Activated:Connect(function()
			State.applyBackgroundImage(assetId, true)
		end)
	end

	State.applyBackgroundImage(State.backgroundAssetId, false)
	task.defer(function()
		task.wait(0.5)
		pcall(function() State.applyBackgroundImage(State.backgroundAssetId, false) end)
	end)
end
State.buildBackgroundPage()
State.buildBackgroundPage = nil

-- Re-apply hub background a few times so it sticks
task.spawn(function()
	for i = 1, 6 do
		pcall(function()
			if State.applyBackgroundImage and State.backgroundAssetId then
				State.applyBackgroundImage(State.backgroundAssetId, false)
			end
		end)
		task.wait(0.4)
	end
end)


-- ============================================================
--  APARTADO: IMÁGENES PARA LOS BOTONES MÓVILES
--  Usa exactamente los mismos assetIds que el selector de fondo
-- ============================================================
makeSecHeader("Background", "Button Images")
do
	local btnNames = {
		{"Drop", "Drop"},
		{"AutoLeft", "Auto Left"},
		{"AutoRight", "Auto Right"},
		{"AutoBat", "Bat Aimbot"},
		{"Speed", "Carry Spd"},
		{"Lagger", "Lagger"},
		{"TPDown", "TP Down"},
		{"TPBat", "TP Bat"},
		{"AutoTP", "Auto TP"},
		{"Taunt", "Taunt"},
		{"MusicPad", "Music Pad"},
		{"BatV2", "Bat V2"},
		{"InstaReset", "Insta Reset"},
	}

	-- Opciones legibles + mapa a assetId reales del script
	local imageOptions = {"None"}
	local optionToId = {["None"] = ""}
	local idToOption = {[""] = "None"}

	local function addOption(label, assetId)
		table.insert(imageOptions, label)
		optionToId[label] = tostring(assetId)
		idToOption[tostring(assetId)] = label
	end

	addOption("Default BG", State.backgroundAssetId or "92526927384077")
	for i, id in ipairs(State.backgroundAssetIds) do
		addOption("Image " .. i, id)
	end

	local infoCard = baseCard("Background", 40)
	cLabel(infoCard, "Imágenes en botones móviles", 10, 260, 11, WHITE, Enum.Font.GothamBold)
	local infoSub = cLabel(infoCard, "Usa las mismas imágenes del selector de fondo", 10, 280, 9, DIM, Enum.Font.Gotham)
	infoSub.Size = UDim2.new(1, -20, 0, 14)
	infoSub.Position = UDim2.new(0, 10, 0, 22)

	for _, pair in ipairs(btnNames) do
		local internalName, displayName = pair[1], pair[2]
		local savedId = State.buttonImages[internalName] or ""
		local currentLabel = idToOption[tostring(savedId)] or "None"

		rowCycleSelector("Background", displayName, imageOptions, currentLabel, function(selected)
			local assetId = optionToId[selected] or ""
			setMobileButtonImage(internalName, assetId)
		end)
	end
end

makeSecHeader("Animations", "Animation Packs")
-- Bat Skin Changer (KATANA / SCYTHE / BAN HAMMER / NONE)
do
	local SKINS = {"KATANA", "SCYTHE", "BAN HAMMER", "NONE"}
	State.batSkinIndex = State.batSkinIndex or 1
	State.batSkinName = State.batSkinName or "KATANA"
	local function findBatTool()
		local char = LP.Character
		if char then
			local tool = char:FindFirstChild("Bat")
			if tool and tool:IsA("Tool") then return tool end
		end
		local bp = LP:FindFirstChildOfClass("Backpack")
		if bp then
			local tool = bp:FindFirstChild("Bat")
			if tool and tool:IsA("Tool") then return tool end
		end
		return nil
	end
	local function removeBatSkin(tool)
		if not tool then return end
		local folder = tool:FindFirstChild("FlowerSkin_KatanaRealistic")
		if folder then folder:Destroy() end
		local handle = tool:FindFirstChild("Handle")
		if handle and handle:IsA("BasePart") then
			handle.Transparency = 0
			handle.LocalTransparencyModifier = 0
		end
	end
	local function buildProxy(tool, skinName)
		local handle = tool and tool:FindFirstChild("Handle")
		if not handle or not handle:IsA("BasePart") then return end
		removeBatSkin(tool)
		if skinName == "NONE" then return end
		handle.Transparency = 1
		handle.LocalTransparencyModifier = 1
		local folder = Instance.new("Folder")
		folder.Name = "FlowerSkin_KatanaRealistic"
		folder.Parent = tool
		local model = Instance.new("Model")
		model.Name = "FlowerSkin_AssetKatana"
		model.Parent = folder
		local function add(name, size, offset, color, material)
			local part = Instance.new("Part")
			part.Name = name
			part.Size = size
			part.Color = color
			part.Material = material or Enum.Material.Neon
			part.Anchored = false
			part.CanCollide = false
			part.Massless = true
			part.Parent = model
			part.CFrame = handle.CFrame * (offset or CFrame.identity)
			local w = Instance.new("WeldConstraint")
			w.Part0 = handle
			w.Part1 = part
			w.Parent = part
			return part
		end
		local red, red2, gold = Color3.fromRGB(200, 0, 0), Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 185, 50)
		if skinName == "SCYTHE" then
			add("Handle2", Vector3.new(0.18, 3.4, 0.18), CFrame.new(0, 0.2, 0), Color3.fromRGB(15, 15, 18), Enum.Material.Metal)
			add("SharpParts", Vector3.new(2.4, 0.18, 0.42), CFrame.new(0.75, 1.55, 0) * CFrame.Angles(0, 0, math.rad(-25)), red)
		elseif skinName == "BAN HAMMER" then
			add("Handle2", Vector3.new(0.22, 3.2, 0.22), CFrame.new(0, 0.1, 0), Color3.fromRGB(20, 20, 22), Enum.Material.Metal)
			add("WeaponPart", Vector3.new(1.8, 0.75, 0.75), CFrame.new(0, 1.55, 0), red)
		else
			add("Handle2", Vector3.new(0.22, 1.0, 0.22), CFrame.new(0, -0.85, 0), Color3.fromRGB(10, 10, 12), Enum.Material.Metal)
			add("SharpParts", Vector3.new(0.22, 3.35, 0.12), CFrame.new(0, 1.05, 0), red2)
			add("WeaponPart", Vector3.new(0.3, 2.7, 0.08), CFrame.new(0.08, 1.15, 0), red)
			add("NeonAccent", Vector3.new(0.75, 0.12, 0.42), CFrame.new(0, -0.28, 0), gold)
		end
	end
	local function applyBatSkin(skinName)
		State.batSkinName = skinName
		local tool = findBatTool()
		if tool then
			pcall(function() buildProxy(tool, skinName) end)
		end
	end
	local c = baseCard("Animations", 58)
	c.LayoutOrder = 1
	local title = cLabel(c, "Bat Skin Changer", 10, 150, 11, WHITE, Enum.Font.GothamBold)
	title.Position = UDim2.new(0, 10, 0, 6)
	title.Size = UDim2.new(0, 150, 0, 18)
	local sub = cLabel(c, "Cycle bat skin", 10, 160, 9, DIM, Enum.Font.Gotham)
	sub.Position = UDim2.new(0, 10, 0, 28)
	sub.Size = UDim2.new(0, 160, 0, 16)
	local nameLbl = Instance.new("TextLabel", c)
	nameLbl.Size = UDim2.new(0, 100, 0, 28)
	nameLbl.Position = UDim2.new(1, -170, 0.5, -14)
	nameLbl.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
	nameLbl.BackgroundTransparency = 0.1
	nameLbl.Text = SKINS[State.batSkinIndex]
	nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.TextSize = 10
	nameLbl.ZIndex = 120
	Instance.new("UICorner", nameLbl).CornerRadius = UDim.new(0, 8)
	local prevBtn = Instance.new("TextButton", c)
	prevBtn.Size = UDim2.new(0, 28, 0, 28)
	prevBtn.Position = UDim2.new(1, -68, 0.5, -14)
	prevBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
	prevBtn.Text = "<"
	prevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	prevBtn.Font = Enum.Font.GothamBold
	prevBtn.TextSize = 14
	prevBtn.ZIndex = 120
	prevBtn.AutoButtonColor = false
	Instance.new("UICorner", prevBtn).CornerRadius = UDim.new(0, 8)
	local nextBtn = Instance.new("TextButton", c)
	nextBtn.Size = UDim2.new(0, 28, 0, 28)
	nextBtn.Position = UDim2.new(1, -36, 0.5, -14)
	nextBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
	nextBtn.Text = ">"
	nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	nextBtn.Font = Enum.Font.GothamBold
	nextBtn.TextSize = 14
	nextBtn.ZIndex = 120
	nextBtn.AutoButtonColor = false
	Instance.new("UICorner", nextBtn).CornerRadius = UDim.new(0, 8)
	local function refresh()
		local skin = SKINS[State.batSkinIndex]
		nameLbl.Text = skin
		applyBatSkin(skin)
		if State.requestConfigSave then State.requestConfigSave() end
	end
	prevBtn.MouseButton1Click:Connect(function()
		State.batSkinIndex = State.batSkinIndex - 1
		if State.batSkinIndex < 1 then State.batSkinIndex = #SKINS end
		refresh()
	end)
	nextBtn.MouseButton1Click:Connect(function()
		State.batSkinIndex = State.batSkinIndex + 1
		if State.batSkinIndex > #SKINS then State.batSkinIndex = 1 end
		refresh()
	end)
	task.spawn(function()
		while gui and gui.Parent do
			if State.batSkinName and State.batSkinName ~= "NONE" then
				local tool = findBatTool()
				if tool and not tool:FindFirstChild("FlowerSkin_KatanaRealistic") then
					pcall(function() applyBatSkin(State.batSkinName) end)
				end
			end
			task.wait(0.6)
		end
	end)
end


State._animPackSelectorVisual = rowCycleSelector("Animations", "Anim Pack", {"Normal","Adidas Sports","Adidas Community","Adidas Aura","Wicked Popular","Elder","Zombie","Mage","Catwalk Glam","Astronaut","Werewolf","Superhero","Toy","No Boundaries","NFL","Amazon Unboxed","Vampire","Ninja","Robot","Levitation","Stylish","Bubbly","Cartoon"}, "Normal", function(name)
	pcall(function()
		if _G.NIGHT_applyAnimationPack then
			_G.NIGHT_applyAnimationPack(name) -- "Normal" / "Off" restaura animaciones por defecto
		end
	end)
	if State.requestConfigSave then State.requestConfigSave() end
end)

makeSecHeader("Animations", "Skins")
State._skinPackSelectorVisual = rowCycleSelector("Animations", "Skin Pack", {"Off","Korblox","Headless","Both"}, "Off", function(name)
	pcall(function() if _G.NIGHT_applySkin then _G.NIGHT_applySkin(name) end end)
	if State.requestConfigSave then State.requestConfigSave() end
end)

makeSecHeader("Animations", "Anti Die")
rowToggle("Animations", "Anti Die", "Previene la muerte", false, function(on)
	pcall(function() if _G.NIGHT_setAntiDie then _G.NIGHT_setAntiDie(on) end end)
end)

makeSecHeader("Animations", "Pack Accessory")
State._accessoryPackSelectorVisual = rowCycleSelector(
	"Animations",
	"Pack Accessory",
	_G.NIGHT_ACCESSORY_PACK_ORDER or {"Off","Bleed 1","Bleed 2","Bleed 3","Homero","Tryhard","Venom"},
	"Off",
	function(name)
		pcall(function()
			if _G.NIGHT_applyAccessoryPack then
				_G.NIGHT_applyAccessoryPack(name)
			end
		end)
		if State.requestConfigSave then State.requestConfigSave() end
	end
)

makeSecHeader("Animations", "Music")
do
	local musicOpts = _G.NIGHT_musicNames or {"Off","Tryhard","Tryhard 2","Tryhard Def","XD","67","3AM","Beretta","Brasil","Brasil 2","Migizin"}
	State._musicPackSelectorVisual = rowCycleSelector("Animations", "Music Pack", musicOpts, "Off", function(name)
		pcall(function() if _G.NIGHT_musicPlay then _G.NIGHT_musicPlay(name) end end)
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	if not KB.MusicPC then KB.MusicPC = {kb = Enum.KeyCode.M, gp = nil} end
	if not KB.MusicPad then KB.MusicPad = {kb = nil, gp = Enum.KeyCode.DPadUp} end
	if not KB.Taunt then KB.Taunt = {kb=nil, gp=nil} end
end


-- SECCIÓN 8: BOTONES MÓVILES
do
    	local BTN_SIZE = 54
	local BTN_GAP  = 8
	local PADDING  = 6
	MobilePanel = Instance.new("Frame")
	MobilePanel.Name = "MobileButtonsPanel"
	MobilePanel.Size = UDim2.new(0, PADDING * 2 + 3 * BTN_SIZE + 2 * BTN_GAP, 0, PADDING * 2 + 4 * BTN_SIZE + 3 * BTN_GAP)
	MobilePanel.Position = UDim2.new(1, -140, 0, 10)
	MobilePanel.BackgroundColor3 = Color3.fromRGB(16,16,18)
	MobilePanel.BackgroundTransparency = 1
	MobilePanel.BorderSizePixel = 0
	MobilePanel.ZIndex = 1
	MobilePanel.Parent = gui

	local Q_OFF      = Color3.fromRGB(12, 12, 10)
	local Q_ON       = Color3.fromRGB(0, 190, 230)
	local Q_TEXT_OFF = Color3.fromRGB(255, 255, 255)

	State._purpleAnimatedButtons = State._purpleAnimatedButtons or {}
	State._purpleAnimationPeriod = 5.5

	local purpleTextPalette = {
		Color3.fromRGB(16,16,18),
		Color3.fromRGB(0, 170, 210),
		Color3.fromRGB(180,180,190),
		Color3.fromRGB(0, 190, 230),
		Color3.fromRGB(210,210,220),
		Color3.fromRGB(180,180,190),
	}

	local function checkSpeedAndDropBeforeAction(stateCheckName, actionCallback)
		task.spawn(function()
			local char = LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			
			if hum then
				if hum.WalkSpeed < 20 then
					if State[stateCheckName] and actionCallback then
						actionCallback()
					end
					return
				end
				
				while hum and hum.WalkSpeed >= 20 and hum.WalkSpeed <= 24 and State[stateCheckName] do
					task.wait(0.5) 
					
					char = LP.Character
					hum = char and char:FindFirstChildOfClass("Humanoid")
				end
				
				if hum and hum.WalkSpeed >= 30 and State[stateCheckName] and actionCallback then
					actionCallback()
				end
			end
		end)
	end

	local function paletteColor(palette, progress)
		local count = #palette
		if count == 0 then return Color3.fromRGB(230,230,235) end
		if count == 1 then return palette[1] end
		progress = progress % 1
		local scaled = progress * count
		local index = math.floor(scaled) + 1
		local nextIndex = (index % count) + 1
		local alpha = scaled - math.floor(scaled)
		alpha = alpha * alpha * (3 - 2 * alpha)
		return palette[index]:Lerp(palette[nextIndex], alpha)
	end

	State._registerPurpleAnimatedButton = function(button)
		if not button then return end
		button:SetAttribute("PurpleActive", false)
		button:SetAttribute("TaupeFlash", false)
		button.BackgroundColor3 = Q_OFF
		button.TextColor3 = Q_TEXT_OFF
		State._purpleAnimatedButtons[button] = {
			background = button.BackgroundColor3,
			text = button.TextColor3,
		}
	end

	if not State._purpleAnimationStarted then
		State._purpleAnimationStarted = true
		task.spawn(function()
			local lastClock = os.clock()
			while gui and gui.Parent do
				local now = os.clock()
				local dt = math.min(now - lastClock, 0.1)
				lastClock = now
				local progress = (now / State._purpleAnimationPeriod) % 1
				local animatedRed = paletteColor(purpleTextPalette, progress)
				local blend = 1 - math.exp(-dt * 8)

				for button, visual in pairs(State._purpleAnimatedButtons) do
					if button and button.Parent then
						local active = button:GetAttribute("PurpleActive") == true
						local flash = button:GetAttribute("TaupeFlash") == true
						local targetBackground
						local targetText

						if active or flash then
							targetBackground = Q_ON
							targetText = Color3.fromRGB(200,200,210)
						else
							targetBackground = Q_OFF
							targetText = Q_TEXT_OFF
						end

						visual.background = visual.background:Lerp(targetBackground, blend)
						visual.text = visual.text:Lerp(targetText, blend)
						button.BackgroundColor3 = visual.background
						button.TextColor3 = visual.text
					else
						State._purpleAnimatedButtons[button] = nil
					end
				end

				RunService.RenderStepped:Wait()
			end
		end)
	end

	State._blueShineLabels = State._blueShineLabels or {}
	State._blueShineGradients = State._blueShineGradients or {}

	local function attachBlueTextShine(button)
		if not button or button:FindFirstChild("BlueTextShine") then return end

		button.TextTransparency = 1

		local shineText = Instance.new("TextLabel")
		shineText.Name = "BlueTextShine"
		shineText.BackgroundTransparency = 1
		shineText.BorderSizePixel = 0
		shineText.Size = UDim2.fromScale(1, 1)
		shineText.Position = UDim2.fromScale(0, 0)
		shineText.Text = button.Text
		shineText.TextColor3 = Color3.fromRGB(255, 255, 255)
		shineText.TextTransparency = 0
		shineText.TextScaled = button.TextScaled
		shineText.TextSize = button.TextSize
		shineText.Font = button.Font
		shineText.TextWrapped = button.TextWrapped
		shineText.LineHeight = button.LineHeight
		shineText.TextXAlignment = button.TextXAlignment
		shineText.TextYAlignment = button.TextYAlignment
		shineText.ZIndex = button.ZIndex + 1
		shineText.Active = false
		shineText.Selectable = false
		shineText.Parent = button

		local shineGradient = Instance.new("UIGradient")
		shineGradient.Name = "CleanBlueShine"
		shineGradient.Rotation = 0
		shineGradient.Offset = Vector2.new(-1.25, 0)
		shineGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 190, 230)),
			ColorSequenceKeypoint.new(0.38, Color3.fromRGB(16,16,18)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 170, 210)),
			ColorSequenceKeypoint.new(0.62, Color3.fromRGB(16,16,18)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 190, 230)),
		})
		shineGradient.Parent = shineText

		State._blueShineLabels[button] = shineText
		State._blueShineGradients[button] = shineGradient

		button:GetPropertyChangedSignal("Text"):Connect(function()
			if shineText.Parent then shineText.Text = button.Text end
		end)
		button:GetPropertyChangedSignal("Visible"):Connect(function()

			if shineText.Parent then shineText.Visible = button.Visible end
		end)
		button:GetPropertyChangedSignal("TextSize"):Connect(function()
			if shineText.Parent then shineText.TextSize = button.TextSize end
		end)
		button:GetPropertyChangedSignal("ZIndex"):Connect(function()
			if shineText.Parent then shineText.ZIndex = button.ZIndex + 1 end
		end)
	end

	if not State._blueShineSequenceStarted then
		State._blueShineSequenceStarted = true
		task.spawn(function()
			while gui and gui.Parent do
				local animatedAny = false
				for button, gradient in pairs(State._blueShineGradients) do
					if not (gui and gui.Parent) then break end
					if button and button.Parent and gradient and gradient.Parent and button.Visible then
						animatedAny = true
						gradient.Offset = Vector2.new(-1.25, 0)
						local tween = TweenService:Create(
							gradient,
							TweenInfo.new(1.45, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
							{Offset = Vector2.new(1.25, 0)}
						)
						tween:Play()
						tween.Completed:Wait()
						task.wait(0.06)
					elseif button and not button.Parent then
						State._blueShineLabels[button] = nil
						State._blueShineGradients[button] = nil
					end
				end
				if not animatedAny then task.wait(0.5) else task.wait(0.8) end
			end
		end)
	end

	local function attachSatisfyingButtonFX(btn)
	if not btn or btn:GetAttribute("VoryxFX") then return end
	btn:SetAttribute("VoryxFX", true)

	local corner = btn:FindFirstChild("ButtonShapeCorner") or btn:FindFirstChildOfClass("UICorner")
	if not corner then
		corner = Instance.new("UICorner")
		corner.Name = "ButtonShapeCorner"
		corner.Parent = btn
	end

	local stroke = btn:FindFirstChild("VoryxGlowStroke")
	if not stroke then
		stroke = Instance.new("UIStroke")
		stroke.Name = "VoryxGlowStroke"
		stroke.Color = Color3.fromRGB(0, 200, 235)
		stroke.Thickness = 1.2
		stroke.Transparency = 0.55
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Parent = btn
	end

	local scale = btn:FindFirstChild("VoryxPressScale")
	if not scale then
		scale = Instance.new("UIScale")
		scale.Name = "VoryxPressScale"
		scale.Scale = 1
		scale.Parent = btn
	end

	-- soft idle glow (opacity only)
	task.spawn(function()
		while btn and btn.Parent do
			local t0 = tick()
			while btn and btn.Parent and (tick() - t0) < 1.35 do
				local a = (math.sin((tick() - t0) * math.pi * 2 / 1.35) + 1) * 0.5
				stroke.Transparency = 0.35 + a * 0.4
				stroke.Thickness = 1.1 + a * 0.7
				task.wait()
			end
			task.wait(0.05)
		end
	end)

	local function pressFX()
		pcall(function()
			TweenService:Create(scale, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.92}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.07), {
				Transparency = 0.05,
				Thickness = 2.4,
				Color = Color3.fromRGB(140, 240, 255)
			}):Play()
		end)
		task.delay(0.08, function()
			if not btn or not btn.Parent then return end
			pcall(function()
				TweenService:Create(scale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
				TweenService:Create(stroke, TweenInfo.new(0.22), {
					Transparency = 0.5,
					Thickness = 1.2,
					Color = Color3.fromRGB(0, 200, 235)
				}):Play()
			end)
		end)
	end

	btn.MouseButton1Down:Connect(pressFX)
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			pressFX()
		end
	end)
end

local function createMobileButton(name, displayText, col, row, isToggle, onAction)
		local xPos = PADDING + col * (BTN_SIZE + BTN_GAP)
		local yPos = PADDING + row * (BTN_SIZE + BTN_GAP)

		local btn = Instance.new("TextButton")
		btn.Name = "Btn_" .. name
		btn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
		local defaultPos = (BTN_POSITIONS_DH and BTN_POSITIONS_DH[name]) or UDim2.new(1, -128 + (col or 0) * 64, 1, -430 + (row or 0) * 62)
		btn.Position = defaultPos
		btn.BackgroundColor3 = Q_OFF
		btn.Text = displayText
		btn.TextColor3 = Q_TEXT_OFF
		btn.TextScaled = false; btn.TextSize = 11
		btn.Font = Enum.Font.GothamBold
		btn.TextWrapped = true; btn.LineHeight = 1.2
		btn.BorderSizePixel = 0; btn.AutoButtonColor = false
		btn.ZIndex = 50
		btn.Parent = gui
		btn.Visible = true
		btn.ZIndex = 50
		State._registerPurpleAnimatedButton(btn)
		attachBlueTextShine(btn)
		attachSatisfyingButtonFX(btn)
		mobileButtonsByName[name] = btn
		mobileButtonDefaultPositions[name] = defaultPos
		makeDraggable(btn)
		btn.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				if State.requestConfigSave then State.requestConfigSave() end
			end
		end)
		Instance.new("UICorner", btn).Name = "ButtonShapeCorner"

		-- Imagen de fondo del botón (usa los mismos assets del script)
		ensureButtonImageLabel(btn)
		if State.buttonImages[name] and State.buttonImages[name] ~= "" then
			applyImageToMobileButton(btn, State.buttonImages[name])
		end

		local mobileStroke = Instance.new("UIStroke")
		mobileStroke.Name = "BlueOuterStroke"
		mobileStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		mobileStroke.Color = Color3.fromRGB(220,220,230)
		mobileStroke.Thickness = 0.9
		mobileStroke.Transparency = 0.22
		mobileStroke.LineJoinMode = Enum.LineJoinMode.Round
		mobileStroke.Parent = btn

		applyMobileButtonsSize(State.buttonsSizeValue)

		local isOn = false
		local function setter(s)
			isOn = s
			btn:SetAttribute("PurpleActive", s == true)
		end

		local function flash()
			btn:SetAttribute("TaupeFlash", true)
			task.delay(0.35, function()
				if btn and btn.Parent then
					btn:SetAttribute("TaupeFlash", false)
				end
			end)
		end

		btn.Activated:Connect(function()
			if isToggle then
				isOn = not isOn; setter(isOn)
				if onAction then onAction(isOn) end
			else
				flash()
				if onAction then onAction() end
			end
			if State.requestConfigSave then State.requestConfigSave() end
		end)

		return btn, setter
	end

	createMobileButton("Drop", "DROP\nBR", 0, 0, false, function() State._manualDropRequest = true; task.spawn(runDrop) end)

	-- TAUNT: voryx on top
	local _tauntBusy = false
	local function doNightTaunt()
		if _tauntBusy then return end
		_tauntBusy = true
		local msg = "voryx on top"
		pcall(function()
			local TextChatService = game:GetService("TextChatService")
			local channel = TextChatService:FindFirstChild("TextChannels")
			channel = channel and (channel:FindFirstChild("RBXGeneral") or channel:FindFirstChildWhichIsA("TextChannel"))
			if channel and channel.SendAsync then
				channel:SendAsync(msg)
				return
			end
		end)
		pcall(function()
			local chat = game:GetService("Chat")
			if chat and chat.SubmitMessage then
				chat:SubmitMessage(msg, "All")
			end
		end)
		pcall(function()
			local rep = game:GetService("ReplicatedStorage")
			local ev = rep:FindFirstChild("DefaultChatSystemChatEvents")
			ev = ev and ev:FindFirstChild("SayMessageRequest")
			if ev then ev:FireServer(msg, "All") end
		end)
		task.delay(1.2, function() _tauntBusy = false end)
	end
	createMobileButton("Taunt", "TAUNT VORYX.GG ", 1, 5, false, function()
		task.spawn(doNightTaunt)
	end)


	createMobileButton("MusicPad", "MUSIC\nPAD", 1, 6, false, function()
		pcall(function() if _G.NIGHT_musicCycle then _G.NIGHT_musicCycle() end end)
	end)

	-- FLOAT: hold ~10 studs altitude; auto-off on lagback
	createMobileButton("Float", "FLOAT", 1, 4, true, function(on)
		State.floatEnabled = on == true
		if State.floatConn then
			pcall(function() State.floatConn:Disconnect() end)
			State.floatConn = nil
		end
		State.floatBaseY = nil
		State.floatLastPos = nil
		State.floatLagStrikes = 0
		if not State.floatEnabled then return end
		State.floatConn = RunService.Heartbeat:Connect(function()
			if not State.floatEnabled then return end
			local char = LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not char or not hum or not root or hum.Health <= 0 then return end

			if State.floatBaseY == nil then
				State.floatBaseY = root.Position.Y
			end
			local targetY = State.floatBaseY + 10

			-- lagback detection
			if State.floatLastPos then
				local delta = (root.Position - State.floatLastPos).Magnitude
				local expected = root.AssemblyLinearVelocity.Magnitude * 0.05
				if delta > math.max(18, expected * 3 + 12) then
					State.floatLagStrikes = (State.floatLagStrikes or 0) + 1
					if State.floatLagStrikes >= 3 then
						State.floatEnabled = false
						State.floatBaseY = nil
						if State.floatConn then
							pcall(function() State.floatConn:Disconnect() end)
							State.floatConn = nil
						end
						return
					end
				else
					State.floatLagStrikes = math.max(0, (State.floatLagStrikes or 0) - 1)
				end
			end
			State.floatLastPos = root.Position

			local y = root.Position.Y
			local vy = root.AssemblyLinearVelocity.Y
			local err = targetY - y
			-- soft hold + jump pulses
			if err > 1.5 then
				pcall(function()
					hum:ChangeState(Enum.HumanoidStateType.Jumping)
				end)
				root.AssemblyLinearVelocity = Vector3.new(
					root.AssemblyLinearVelocity.X,
					math.clamp(err * 2.2, 8, 42),
					root.AssemblyLinearVelocity.Z
				)
			elseif err < -2.5 then
				root.AssemblyLinearVelocity = Vector3.new(
					root.AssemblyLinearVelocity.X,
					math.clamp(err * 1.5, -30, -4),
					root.AssemblyLinearVelocity.Z
				)
			else
				root.AssemblyLinearVelocity = Vector3.new(
					root.AssemblyLinearVelocity.X,
					vy * 0.55 + err * 1.1,
					root.AssemblyLinearVelocity.Z
				)
			end
		end)
	end)
	btnBatV2 = Instance.new("TextButton")
	btnBatV2.Name = "Btn_BatnV2"
	btnBatV2.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
	btnBatV2.Position = BTN_POSITIONS_DH.BatV2 or UDim2.new(1, -128, 1, -58)
	btnBatV2.BackgroundColor3 = Q_OFF
	btnBatV2.Text = "BAT V2"
	btnBatV2.TextColor3 = Q_TEXT_OFF
	btnBatV2.TextScaled = false; btnBatV2.TextSize = 11
	btnBatV2.Font = Enum.Font.GothamBold
	btnBatV2.TextWrapped = true; btnBatV2.LineHeight = 1.2
	btnBatV2.BorderSizePixel = 0; btnBatV2.AutoButtonColor = false
	btnBatV2.ZIndex = 1
	btnBatV2.Parent = gui
	State._registerPurpleAnimatedButton(btnBatV2)
	attachBlueTextShine(btnBatV2)
	Instance.new("UICorner", btnBatV2).Name = "ButtonShapeCorner"
	ensureButtonImageLabel(btnBatV2)
	if State.buttonImages["BatV2"] and State.buttonImages["BatV2"] ~= "" then
		applyImageToMobileButton(btnBatV2, State.buttonImages["BatV2"])
	end
	local batV2Stroke = Instance.new("UIStroke")
	batV2Stroke.Name = "BlueOuterStroke"
	batV2Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	batV2Stroke.Color = Color3.fromRGB(220,220,230)
	batV2Stroke.Thickness = 0.9
	batV2Stroke.Transparency = 0.22
	batV2Stroke.LineJoinMode = Enum.LineJoinMode.Round
	batV2Stroke.Parent = btnBatV2
	applyMobileButtonsSize(State.buttonsSizeValue)

	makeDraggable(btnBatV2)
	btnBatV2.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end)

	State._batV2On = false
	State._setBatV2Visual = function(s)
		State._batV2On = s
		btnBatV2:SetAttribute("PurpleActive", s == true)
		if autoBatV2SetVisual then autoBatV2SetVisual(s) end
	end

	btnBatV2.Activated:Connect(function()
		State._batV2On = not State._batV2On
		State._setBatV2Visual(State._batV2On)
		State.autoBatV2Enabled = State._batV2On
		
		if _G.setRagdollTpState then _G.setRagdollTpState(not State._batV2On) end

		if State._batV2On then
			if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatToggled then
				State.autoBatToggled = false
				if autoBatSetVisual then autoBatSetVisual(false) end
				stopBatAimbot()
			end
			if State.tpBatEnabled then State._setTPBatEnabled(false) end
			checkSpeedAndDropBeforeAction("autoBatV2Enabled", function()
				if startBatAimbotV2 then startBatAimbotV2() end
			end)
		else
			if stopBatAimbotV2 then stopBatAimbotV2() end
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end)

	local oldAutoBatV2SetVisual = autoBatV2SetVisual
	autoBatV2SetVisual = function(on)
		State._batV2On = on
		btnBatV2:SetAttribute("PurpleActive", on == true)
		if oldAutoBatV2SetVisual then oldAutoBatV2SetVisual(on) end
	end
	mobileBatV2SetActive = function(on) autoBatV2SetVisual(on) end

	btnInstaReset = Instance.new("TextButton")
	btnInstaReset.Name = "Btn_InstaReset"
	btnInstaReset.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
	btnInstaReset.Position = BTN_POSITIONS_DH.InstaReset or UDim2.new(1, -64, 1, -120)
	btnInstaReset.BackgroundColor3 = Q_OFF
	btnInstaReset.Text = "INSTA\nRESET"
	btnInstaReset.TextColor3 = Q_TEXT_OFF
	btnInstaReset.TextScaled = false; btnInstaReset.TextSize = 11
	btnInstaReset.Font = Enum.Font.GothamBold
	btnInstaReset.TextWrapped = true; btnInstaReset.LineHeight = 1.2
	btnInstaReset.BorderSizePixel = 0; btnInstaReset.AutoButtonColor = false
	btnInstaReset.ZIndex = 1
	btnInstaReset.Parent = gui
	State._registerPurpleAnimatedButton(btnInstaReset)
	attachBlueTextShine(btnInstaReset)
	Instance.new("UICorner", btnInstaReset).Name = "ButtonShapeCorner"
	ensureButtonImageLabel(btnInstaReset)
	if State.buttonImages["InstaReset"] and State.buttonImages["InstaReset"] ~= "" then
		applyImageToMobileButton(btnInstaReset, State.buttonImages["InstaReset"])
	end
	local instaResetStroke = Instance.new("UIStroke")
	instaResetStroke.Name = "BlueOuterStroke"
	instaResetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	instaResetStroke.Color = Color3.fromRGB(220,220,230)
	instaResetStroke.Thickness = 0.9
	instaResetStroke.Transparency = 0.22
	instaResetStroke.LineJoinMode = Enum.LineJoinMode.Round
	instaResetStroke.Parent = btnInstaReset
	applyMobileButtonsSize(State.buttonsSizeValue)

	makeDraggable(btnInstaReset)
	btnInstaReset.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end)

	btnInstaReset.Activated:Connect(function()
		btnInstaReset:SetAttribute("TaupeFlash", true)
		task.delay(0.35, function()
			if btnInstaReset and btnInstaReset.Parent then
				btnInstaReset:SetAttribute("TaupeFlash", false)
			end
		end)

		if setInstaToggleVisual then
			setInstaToggleVisual(true)
			task.delay(0.2, function() setInstaToggleVisual(false) end)
		end

		task.spawn(cursedInstaReset)
		if State.requestConfigSave then State.requestConfigSave() end
	end)

	resetMobileButtons = function()
		for name, btn in pairs(mobileButtonsByName) do
			local defaultPos = mobileButtonDefaultPositions[name]
			if btn and defaultPos then btn.Position = defaultPos end
		end
		btnBatV2.Position = BTN_POSITIONS_DH.BatV2 or UDim2.new(1, -128, 1, -58)
		btnInstaReset.Position = BTN_POSITIONS_DH.InstaReset or UDim2.new(1, -64, 1, -120)
		if State.requestPositionSave then State.requestPositionSave() end
		if State.requestConfigSave then State.requestConfigSave() end
	end

	-- Aplicar imágenes guardadas a todos los botones (mismos assets del script)
	task.defer(function()
		pcall(applyAllButtonImages)
	end)

	do
		local setter = select(2, createMobileButton("AutoLeft", "AUTO\nLEFT", 1, 0, true, function(on)
			State.autoLeftEnabled = on
			if on then
				local requiredTpEnable = false
				if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
				if State.autoBatToggled then 
					State.autoBatToggled=false; 
					if autoBatSetVisual then autoBatSetVisual(false) end; 
					stopBatAimbot()
					requiredTpEnable = true
				end
				if State.autoBatV2Enabled then
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if mobileBatV2SetActive then mobileBatV2SetActive(false) end
					stopBatAimbotV2()
					requiredTpEnable = true
				end
				if State.tpBatEnabled then State._setTPBatEnabled(false) end

				if requiredTpEnable and _G.setRagdollTpState then _G.setRagdollTpState(true) end

				local char = LP.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if hum and root and hum.WalkSpeed > 0 and not root.Anchored then 
					checkSpeedAndDropBeforeAction("autoLeftEnabled", function()
						startAutoLeft() 
					end)
				end
			else
				stopAutoLeft()
			end
		end))
		local previous = autoLeftSetVisual
		autoLeftSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoLeftSetActive = function(on) autoLeftSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoLeft = setter end
		local btn = mobileButtonsByName["AutoLeft"]
		if btn then
			btn.TextColor3 = Color3.fromRGB(255,255,255)
		end
	end

	do
		local setter = select(2, createMobileButton("AutoBat", "BAT\nAIMBOT", 0, 1, true, function(on)
			State.autoBatToggled = on
			
			if _G.setRagdollTpState then _G.setRagdollTpState(not on) end

			if on then
				if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
				if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
				if State._batV2On then
					State._batV2On = false
					State._setBatV2Visual(false)
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if stopBatAimbotV2 then stopBatAimbotV2() end
				end
				if State.tpBatEnabled then State._setTPBatEnabled(false) end
				checkSpeedAndDropBeforeAction("autoBatToggled", function()
					startBatAimbot() 
				end)
			else
				stopBatAimbot()
			end
		end))
		local previous = autoBatSetVisual
		autoBatSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileBatV1SetActive = function(on) autoBatSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoBat = setter end
	end

	do
		local setter = select(2, createMobileButton("AutoRight", "AUTO\nRIGHT", 1, 1, true, function(on)
			State.autoRightEnabled = on
			if on then
				local requiredTpEnable = false
				if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
				if State.autoBatToggled then 
					State.autoBatToggled=false; 
					if autoBatSetVisual then autoBatSetVisual(false) end; 
					stopBatAimbot()
					requiredTpEnable = true
				end
				if State.autoBatV2Enabled then
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if mobileBatV2SetActive then mobileBatV2SetActive(false) end
					stopBatAimbotV2()
					requiredTpEnable = true
				end
				if State.tpBatEnabled then State._setTPBatEnabled(false) end

				if requiredTpEnable and _G.setRagdollTpState then _G.setRagdollTpState(true) end

				local char = LP.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if hum and root and hum.WalkSpeed > 0 and not root.Anchored then 
					checkSpeedAndDropBeforeAction("autoRightEnabled", function()
						startAutoRight() 
					end)
				end
			else
				stopAutoRight()
			end
		end))
		local previous = autoRightSetVisual
		autoRightSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoRightSetActive = function(on) autoRightSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoRight = setter end
		local btn = mobileButtonsByName["AutoRight"]
		if btn then
			btn.TextColor3 = Color3.fromRGB(255,255,255)
		end
	end

	createMobileButton("TPDown", "TP\nDOWN", 0, 2, false, function() task.spawn(runTPDown) end)

	State._tpBatButton, State._tpBatSetter = createMobileButton("TPBat", "TP\nBAT", 0, 4, true, function(on)
		State._setTPBatEnabled(on)
		if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
	end)
	State._tpBatSetVisual = function(on)
		State._setTPBatEnabled(on)
		if State._tpBatSetter then State._tpBatSetter(on) end
		if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
	end

	do
		local setter = select(2, createMobileButton("Speed", "CARRY\nSPD", 1, 2, true, function(on)
			State.speedToggled = on
			if on then
				State.laggerToggled = false
				laggerPhase = 0
				if mobileLaggerSetActive then mobileLaggerSetActive(false) end
				if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry" end
			else
				if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal" end
			end
		end))
		mobileSpeedSetActive = function(on) setter(on) end
	end

	do
		local setter = select(2, createMobileButton("AutoTP", "AUTO\nTP", 1, 3, true, function(on)
			autoTPDownEnabled = on
			if on then
				if startAutoTPDown then task.spawn(startAutoTPDown) end
			else
				if stopAutoTPDown then stopAutoTPDown() end
			end
		end))
		local previous = setAutoTPDownVisual
		setAutoTPDownVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoTPSetActive = function(on) setAutoTPDownVisual(on) end
	end

	do
		local cycle = 0
		local button, setter
		button, setter = createMobileButton("Lagger", "LAGGER\nOff", 0, 3, true, function()
			if cycle == 0 or cycle == 2 then
				cycle = 1
				State.laggerToggled = true
				laggerPhase = 1
				State.speedToggled = false
				if mobileSpeedSetActive then mobileSpeedSetActive(false) end
				if modeValLbl then modeValLbl.Text = "Lagger 1" end
				button.Text = "LAGGER\n1"
				task.defer(function() setter(true) end)
			elseif cycle == 1 then
				cycle = 2
				State.laggerToggled = true
				laggerPhase = 2
				State.speedToggled = false
				if mobileSpeedSetActive then mobileSpeedSetActive(false) end
				if modeValLbl then modeValLbl.Text = "Lagger 2" end
				button.Text = "LAGGER\n2"
				task.defer(function() setter(true) end)
			end
		end)
		mobileLaggerSetActive = function(on)
			if on then
				cycle = (laggerPhase == 2) and 2 or 1
				laggerPhase = cycle
				State.laggerToggled = true
				button.Text = cycle == 2 and "LAGGER\n2" or "LAGGER\n1"
				setter(true)
			else
				cycle = 0
				laggerPhase = 0
				State.laggerToggled = false
				button.Text = "LAGGER\nOff"
				setter(false)
			end
		end
	end

	do
		local wasFrozen = false
		local prevInfJump = false
		local prevSuperJump = false
		local prevSpeedToggle = false

		RunService.Heartbeat:Connect(function()
			local char = LP.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildOfClass("Humanoid")
			if not hrp or not hum then return end

			local isCurrentlyFrozen = hrp.Anchored or hum.WalkSpeed == 0

			if isCurrentlyFrozen then
				if State.autoBatV2Enabled or State._batV2On then
					State._batV2On = false
					State._setBatV2Visual(false)
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if stopBatAimbotV2 then stopBatAimbotV2() end
					if _G.setRagdollTpState then _G.setRagdollTpState(true) end
				end

				if State.autoBatToggled then
					State.autoBatToggled = false
					if autoBatSetVisual then autoBatSetVisual(false) end
					stopBatAimbot()
					if _G.setRagdollTpState then _G.setRagdollTpState(true) end
				end

				if not wasFrozen then
					wasFrozen = true
					prevInfJump = State.infJumpEnabled
					prevSuperJump = State.superJumpEnabled
					prevSpeedToggle = State.speedToggled

					if State.infJumpEnabled then
						State.infJumpEnabled = false
						if setInfJump then setInfJump(false) end
					end
					if State.superJumpEnabled then
						State.superJumpEnabled = false
						if setSuperJump then setSuperJump(false) end
					end
					if State.speedToggled then
						State.speedToggled = false
						if mobileSpeedSetActive then mobileSpeedSetActive(false) end
						if modeValLbl then
							modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
						end
					end

					if State.dropActive then
						if State.dropConn then
							State.dropConn:Disconnect()
							State.dropConn = nil
						end
						State.dropActive = false
					end
					if State.dropBrainrotActive then
						if State.dropBrainrotConn then
							State.dropBrainrotConn:Disconnect()
							State.dropBrainrotConn = nil
						end
						State.dropBrainrotActive = false
					end

					if State.autoLeftEnabled then stopAutoLeft() end
					if State.autoRightEnabled then stopAutoRight() end
				end
			else
				if wasFrozen then
					wasFrozen = false

					if prevInfJump then
						State.infJumpEnabled = true
						if setInfJump then setInfJump(true) end
					end
					if prevSuperJump then
						State.superJumpEnabled = true
						if setSuperJump then setSuperJump(true) end
					end
					if prevSpeedToggle then
						State.speedToggled = true
						if mobileSpeedSetActive then mobileSpeedSetActive(true) end
						if modeValLbl then
							modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
						end
					end

					if State.autoLeftEnabled then startAutoLeft() end
					if State.autoRightEnabled then startAutoRight() end
				end
			end
		end)
	end
end


-- SECCIÓN 9: ESP (LÍNEA)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESP = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESP[player] then return end

    local Line = Drawing.new("Line")
    Line.Color = Color3.fromRGB(16,16,18)
    Line.Thickness = 0.1
    Line.Transparency = 0.7
    Line.Visible = false

    local Distance = Drawing.new("Text")
    Distance.Color = Color3.fromRGB(230,230,235)
    Distance.Size = 11
    Distance.Center = true
    Distance.Outline = true
    Distance.Visible = false

    ESP[player] = {Line, Distance}
end

for _, v in ipairs(Players:GetPlayers()) do
    CreateESP(v)
end

Players.PlayerAdded:Connect(CreateESP)

Players.PlayerRemoving:Connect(function(player)
    if ESP[player] then
        for _, obj in ipairs(ESP[player]) do
            obj:Remove()
        end
        ESP[player] = nil
    end
    if player.Character then
        local hl = player.Character:FindFirstChild("HologramRed")
        if hl then hl:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera

    for player, objs in pairs(ESP) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local head = char and char:FindFirstChild("Head")

        if State.linieEnabled and hrp and hum and head and hum.Health > 0 then
            local pos, visible = Camera:WorldToViewportPoint(hrp.Position)

            local holo = char:FindFirstChild("HologramRed")
            if not holo then
                holo = Instance.new("Highlight")
                holo.Name = "HologramRed"
                holo.FillColor = Color3.fromRGB(16,16,18)
                holo.FillTransparency = 0.5
                holo.OutlineColor = Color3.fromRGB(0, 170, 210)
                holo.OutlineTransparency = 0.2
                holo.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                holo.Parent = char
            else
                holo.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end

            if visible then
                local distance = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local feetPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - feetPos.Y)

                objs[1].Visible = true
                objs[1].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                objs[1].To = Vector2.new(pos.X, pos.Y)

                objs[2].Visible = true
                objs[2].Position = Vector2.new(pos.X, pos.Y - height / 2 - 16)
                objs[2].Text = distance .. " Studs"

            else
                for _, obj in ipairs(objs) do
                    obj.Visible = false
                end
            end
        else
            if char then
                local hl = char:FindFirstChild("HologramRed")
                if hl then hl:Destroy() end
            end
            for _, obj in ipairs(objs) do
                obj.Visible = false
            end
        end
    end
end)

State._positionConfigFile = "Vereuxv2_positions.json"
State._positionBackupFile = "Vereuxv2_positions.backup.json"
State._positionTempFile = "Vereuxv2_positions.tmp.json"
State._positionSaveRequestId = 0

State._positionSnapshot = function(guiObject)
    if not guiObject then return nil end
    local ok, position = pcall(function() return guiObject.Position end)
    if not ok or not position then return nil end
    return {xs=position.X.Scale, xo=position.X.Offset, ys=position.Y.Scale, yo=position.Y.Offset}
end

State._restoreSavedPosition = function(guiObject, data)
    if not guiObject or type(data) ~= "table" or data.xs == nil then return end
    pcall(function()
        guiObject.Position = UDim2.new(
            tonumber(data.xs) or 0,
            tonumber(data.xo) or 0,
            tonumber(data.ys) or 0,
            tonumber(data.yo) or 0
        )
    end)
end

State.savePositionBackup = function()
    local buttonPositions = {}
    for name, button in pairs(mobileButtonsByName) do
        buttonPositions[name] = State._positionSnapshot(button)
    end

    local payload = {
        version = 2,
        mainPos = State._positionSnapshot(main),
        miniPos = State._positionSnapshot(mini),
        panelPos = State._positionSnapshot(MobilePanel),
        pbPos = State._positionSnapshot(pbFrame),
        batV2Pos = State._positionSnapshot(btnBatV2),
        instaResetPos = State._positionSnapshot(btnInstaReset),
        autoStealBarPos = State._positionSnapshot(State.autoStealBarFrame),
        mobileButtonPositions = buttonPositions,
    }

    local encodedOk, encoded = pcall(function() return HttpService:JSONEncode(payload) end)
    if not encodedOk then return false end

    if encoded == State._lastPositionJson then
        State._positionDirty = false
        return true
    end

    local saved, err = State._atomicJsonSave(
        State._positionConfigFile,
        State._positionBackupFile,
        State._positionTempFile,
        encoded
    )
    if saved then
        State._lastPositionJson = encoded
        State._positionDirty = false
    else
        State._lastSaveError = err
    end
    return saved
end

State.loadPositionBackup = function()
    local mainData, mainRaw = State._readValidJsonFile(State._positionConfigFile)
    local tempData, tempRaw = State._readValidJsonFile(State._positionTempFile)
    local backupData, backupRaw = State._readValidJsonFile(State._positionBackupFile)

    local data, raw, recovered = nil, nil, false
    if type(tempData) == "table" and (type(mainData) ~= "table" or tempRaw ~= mainRaw) then
        data, raw, recovered = tempData, tempRaw, true
    elseif type(mainData) == "table" then
        data, raw = mainData, mainRaw
    elseif type(backupData) == "table" then
        data, raw, recovered = backupData, backupRaw, true
    end

    if type(data) ~= "table" then return false end
    State._lastPositionJson = raw
    State._positionDirty = false

    local function apply()
        State._restoreSavedPosition(main, data.mainPos)
        State._restoreSavedPosition(mini, data.miniPos)
        State._restoreSavedPosition(MobilePanel, data.panelPos)
        State._restoreSavedPosition(pbFrame, data.pbPos)
        State._restoreSavedPosition(btnBatV2, data.batV2Pos)
        State._restoreSavedPosition(btnInstaReset, data.instaResetPos)
        State._restoreSavedPosition(State.autoStealBarFrame, data.autoStealBarPos)
        if type(data.mobileButtonPositions) == "table" then
            for name, positionData in pairs(data.mobileButtonPositions) do
                State._restoreSavedPosition(mobileButtonsByName[name], positionData)
            end
        end
    end

    apply()
    task.delay(0.45, apply)
    task.delay(1.2, apply)

    if recovered and type(raw) == "string" then
        task.defer(function()
            State._atomicJsonSave(
                State._positionConfigFile,
                State._positionBackupFile,
                State._positionTempFile,
                raw
            )
        end)
    end
    return true
end

State.requestPositionSave = function()
    State._positionDirty = true
    State._positionSaveRequestId = State._positionSaveRequestId + 1
    local requestId = State._positionSaveRequestId

    task.delay(0.55, function()
        if requestId ~= State._positionSaveRequestId then return end
        if not State._positionDirty then return end
        local ok, result = pcall(State.savePositionBackup)
        if not ok then State._lastSaveError = tostring(result) end
    end)
end

task.spawn(function()
    task.wait(0.15)
    pcall(State.loadPositionBackup)
end)

-- SECCIÓN 10: BAT AIMBOT V2 Y FUNCIONES DE CONTEO
local function getAutoBatTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    if now - _autoBatLastScan <= 0.1 and _autoBatTarget and _autoBatTarget.Parent then
        local hum = _autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
        local char = _autoBatTarget.Parent
        local hasAntiBat = char:FindFirstChild("Anti-Bat") or char:FindFirstChild("AntiBat") or char:FindFirstChild("Shield")
        if hum and hum.Health > 0 and not hasAntiBat then return _autoBatTarget end
    end
    _autoBatLastScan = now
    _autoBatTarget = nil
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local tChar = plr.Character

            local hasAntiBat = tChar:FindFirstChild("Anti-Bat") or tChar:FindFirstChild("AntiBat") or tChar:FindFirstChild("Shield")

            if tRoot and hum and hum.Health > 0 and not hasAntiBat then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    _autoBatTarget = closest
    return _autoBatTarget
end

local LUST_BYPASS_AIMBOT_SPEED = 60
local BAT_V2_FOLLOW_DIST = 1.0
local BAT_V2_HEIGHT_OFFSET = 1.5
local BAT_V2_VERTICAL_OFFSET = 0.0
local BAT_V2_HIT_DIST = 4.5
local BAT_V2_SWING_COOLDOWN = 0.1

local bypassHittingCooldown = false

local function getClosestPlayerV2()
    local char = LP.Character
    if not char then return nil, math.huge end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end

    local closest, bestDistance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance < bestDistance then
                    bestDistance = distance
                    closest = player
                end
            end
        end
    end

    return closest, bestDistance
end

local function tryHitBypassBat()
    if bypassHittingCooldown then return end
    bypassHittingCooldown = true

    pcall(function()
        local char = LP.Character
        if not char then return end

        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatToolLust(currentTool) then
            bypassHittingCooldown = false
            return
        end

        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    pcall(function() humanoid:EquipTool(bat) end)
                end
            end

            local remote = bat:FindFirstChildOfClass("RemoteEvent")
            if remote then
                pcall(function() remote:FireServer() end)
            else
                pcall(function() bat:Activate() end)
            end
        end
    end)

    pcall(function() _G.VoryxPlayBatHitSound() end)
    task.delay(BAT_V2_SWING_COOLDOWN, function()
        bypassHittingCooldown = false
    end)
    task.delay(0.2, function()
        if bypassHittingCooldown then
            bypassHittingCooldown = false
        end
    end)
end

startBatAimbotV2 = function()
    if State.tpBatEnabled then
        State._setTPBatEnabled(false)
    end

    if Conns.aimbotV2 then return end
    State.autoBatV2Enabled = true

    Conns.aimbotV2 = RunService.Heartbeat:Connect(function()
        if not State.autoBatV2Enabled then return end

        local char = LP.Character
        if not char then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then return end

        local humanoidState = humanoid:GetState()
        if humanoidState == Enum.HumanoidStateType.Physics
            or humanoidState == Enum.HumanoidStateType.Ragdoll
            or humanoidState == Enum.HumanoidStateType.FallingDown then
            return
        end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then
                pcall(function() humanoid:EquipTool(bat) end)
            end
        end

        local target = getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetVelocity = targetRoot.AssemblyLinearVelocity
                local movementDirection = targetVelocity.Magnitude > 0.1
                    and targetVelocity.Unit
                    or targetRoot.CFrame.LookVector

                local offset = movementDirection * BAT_V2_FOLLOW_DIST
                    + Vector3.new(0, BAT_V2_HEIGHT_OFFSET + BAT_V2_VERTICAL_OFFSET, 0)
                local desiredPosition = targetRoot.Position + offset
                local directionToTarget = desiredPosition - root.Position

                local speed = State.batV2Speed or 60
                if directionToTarget.Magnitude > 0.5 then
                    local movementVector = directionToTarget.Unit * speed
                    root.AssemblyLinearVelocity = Vector3.new(
                        movementVector.X,
                        movementVector.Y,
                        movementVector.Z
                    )
                else
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                    if root.AssemblyLinearVelocity.Magnitude < 1 then
                        root.AssemblyLinearVelocity = Vector3.zero
                    end
                end

                if State.autoSwingEnabled
                    and (root.Position - targetRoot.Position).Magnitude <= BAT_V2_HIT_DIST then
                    tryHitBypassBat()
                end
            end
        else
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
            if root.AssemblyLinearVelocity.Magnitude < 1 then
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end

stopBatAimbotV2 = function()
    State.autoBatV2Enabled = false

    if Conns.aimbotV2 then
        Conns.aimbotV2:Disconnect()
        Conns.aimbotV2 = nil
    end

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.AutoRotate = true
        humanoid.PlatformStand = false
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
        pcall(function()
            if sethiddenproperty then
                sethiddenproperty(root, "PhysicsRepRootPart", nil)
            end
        end)
    end

    bypassHittingCooldown = false
    State.lastMoveDir = Vector3.zero
end

-- SECCIÓN 11: AUTO STEAL (NIGHT #3.VS) CON PERSISTENCIA
;(function()

local function _isfile(path)
    local checker = State._resolveFileFunction("isfile")
    if type(checker) == "function" then
        local ok, exists = pcall(checker, path)
        if ok then return exists == true end
    end
    local raw = State._safeReadFile(path)
    return type(raw) == "string"
end
local function _readfile(path)
    local raw, err = State._safeReadFile(path)
    if type(raw) ~= "string" then error(err or "readfile failed", 0) end
    return raw
end
local function _writefile(path, data)
    local ok, err = State._safeWriteFile(path, data)
    if not ok then error(err or "writefile failed", 0) end
    return true
end
local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local PLOT_CACHE_DURATION=2; local PROMPT_CACHE_REFRESH=0.15
local STEAL_COOLDOWN=0.1; local MEDUSA_COOLDOWN=25; local DROP_AUTO_OFF_DELAY=0.15
local CONFIG_FILE="Vereuxv2.json"
State._configTempFile="Vereuxv2.tmp.json"
State._legacyConfigFile="Vereuxv2.json"
State._configBackupFile="Vereuxv2.backup.json"
State._legacyConfigBackupFile="Vereuxvs.backup.json"
State._legacyConfigTempFile="VereuxV2Config.tmp.json"

State.autoLeftPhase=1; State.autoRightPhase=1
State.medusaLastUsed=0; State.medusaDebounce=false; State.medusaCounterEnabled=false
State.batAimbotToggled=false; State.autoSwingEnabled=false
State.hittingCooldown=false
State.batCounterEnabled=false; State.batCounterDebounce=false
State.dropEnabled=false; State._tpInProgress=false
State.lastMoveDir=Vector3.new(0,0,0)
State._prevCarry=CS; State._prevSpeed=false
State.laggerEnabled=false

Conns.autoLeft=nil; Conns.autoRight=nil; Conns.aimbot=nil
Conns.batCounter=nil; Conns.unwalk=nil

local Presets={}
local PRESET_FILE="FEARV2Presets.json"; local LAST_PRESET_FILE="FEARV2LastPreset.json"
local function buildPresetSnapshot()
    return {normalSpeed=NS,carrySpeed=CS,laggerSpeed=LS,stealRadius=Steal.StealRadius,
        infJump=State.infJumpEnabled,
        antiRagdoll=State.antiRagdollEnabled,fpsBoost=State.fpsBoostEnabled,
        medusaCounter=State.medusaCounterEnabled,batCounter=State.batCounterEnabled,
        autoSteal=Steal.AutoStealEnabled,
        skinPack=(function() local ok,n=pcall(function() return _G.NIGHT_getSkin and _G.NIGHT_getSkin() end) return (ok and n) or "Off" end)(),
        medusaReset=State.autoResetEnabled,uiScale=uiScaleValue}
end
local function savePresetsFile()
    local ok,enc=pcall(function() return HttpService:JSONEncode(Presets) end)
    if ok then pcall(function() _writefile(PRESET_FILE,enc) end) end
end
local function loadPresetsFile()
    local hasFile=false; pcall(function() hasFile=_isfile(PRESET_FILE) end)
    if not hasFile then return end
    local raw; pcall(function() raw=_readfile(PRESET_FILE) end)
    if not raw then return end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then Presets=dec end
end
local function saveLastPresetName(name)
    local ok,enc=pcall(function() return HttpService:JSONEncode({lastPreset=name}) end)
    if ok then pcall(function() _writefile(LAST_PRESET_FILE,enc) end) end
end
local function loadLastPresetName()
    local hasFile=false; pcall(function() hasFile=_isfile(LAST_PRESET_FILE) end)
    if not hasFile then return nil end
    local raw; pcall(function() raw=_readfile(LAST_PRESET_FILE) end)
    if not raw then return nil end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then return dec.lastPreset end; return nil
end

local function createRadiusPart()
	local p = Instance.new("Part")
	p.Name = "MedusaRadius"
	p.Anchored = true
	p.CanCollide = false
	pcall(function() p.CanQuery = false end)
	p.Transparency = 1
	p.Material = Enum.Material.Neon
	p.Color = Color3.fromRGB(0, 170, 210)
	p.Shape = Enum.PartType.Cylinder
	p.Size = Vector3.new(0.2, MedusaConfig.Radius*2, MedusaConfig.Radius*2)
	p.Parent = workspace
	MedusaConfig.RadiusPart = p
end

local function isMedusaEquipped()
	local char = LP.Character
	if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and tool.Name == "Medusa's Head" then
			return tool
		end
	end
	return nil
end

RunService.Heartbeat:Connect(function()
	if not MedusaConfig.Enabled then
		if MedusaConfig.RadiusPart then MedusaConfig.RadiusPart.Transparency = 1 end
		return
	end

	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if not MedusaConfig.RadiusPart then createRadiusPart() end
	MedusaConfig.RadiusPart.Transparency = 0.7
	MedusaConfig.RadiusPart.CFrame = CFrame.new(root.Position + Vector3.new(0, -2.5, 0)) * CFrame.Angles(0, 0, math.rad(90))

	local tool = isMedusaEquipped()
	if tool and (tick() - MedusaConfig.LastUsed >= MedusaConfig.Delay) then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local pRoot = plr.Character.HumanoidRootPart
				if (pRoot.Position - root.Position).Magnitude <= MedusaConfig.Radius then
					tool:Activate()
					MedusaConfig.LastUsed = tick()
					break
				end
			end
		end
	end
end)

local function doTpDown()
    pcall(function()
        local character, humanoid, root = safetyCharacterParts()
        if character then safetyTeleportToFloor(character, humanoid, root) end
    end)
end

local function runDropBrainrot()
        if State.dropBrainrotActive then return end
        local char, hum, root = safetyCharacterParts()
        if not char then return end
        State.dropBrainrotActive=true; local t0=tick()
        State.dropBrainrotConn = RunService.Heartbeat:Connect(function()
                local currentChar=LP.Character
                local r=currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                local currentHum=currentChar and currentChar:FindFirstChildOfClass("Humanoid")
                if not r or not currentHum or currentHum.Health<=0 then
                        if State.dropBrainrotConn then State.dropBrainrotConn:Disconnect(); State.dropBrainrotConn = nil end
                        State.dropBrainrotActive=false
                        return
                end
                if tick()-t0>=DROP_ASCEND_DURATION then
                        if State.dropBrainrotConn then State.dropBrainrotConn:Disconnect(); State.dropBrainrotConn = nil end
                        r.AssemblyLinearVelocity=Vector3.zero
                        r.AssemblyAngularVelocity=Vector3.zero
                        safetyTeleportToFloor(currentChar,currentHum,r)
                        State.dropBrainrotActive=false
                        return
                end
                r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,DROP_ASCEND_SPEED,r.AssemblyLinearVelocity.Z)
        end)
end

local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
    local c=LP.Character; if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)); if t then return t end
    end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end) end
end
local function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled then return end
        if State.batCounterDebounce then return end
        local char=LP.Character; if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            State.batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter()
                if bat then swingBatForCounter(bat,char) end
                task.wait(0.5); State.batCounterDebounce=false
            end)
        end
    end)
end
local function stopBatCounter()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
    State.batCounterDebounce=false
end

local function findMedusa()
    local c=LP.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChildOfClass("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
local function useMedusaCounter()
    if State.medusaDebounce then return end; if tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character; if not c then return end; State.medusaDebounce=true
    local med=findMedusa(); if not med then State.medusaDebounce=false; return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end); State.medusaLastUsed=tick(); State.medusaDebounce=false
end
local function onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency==1 then useMedusaCounter() end end) end
local function setupMedusaCounter(char)
    for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
end
local function stopMedusaCounter() for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={} end

local function faceSouth() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,0,0) end end) end
local function faceNorth() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,math.rad(180),0) end end) end

local function startAutoLeft()
    if State.tpBatEnabled then
        State._setTPBatEnabled(false)
    end

    if Conns.autoLeft then Conns.autoLeft:Disconnect() end; State.autoLeftPhase=1
    Conns.autoLeft=RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=getProfileNormalSpeed()
        if State.autoLeftPhase==1 then
            local tgt=Vector3.new(AP.L1.X,root.Position.Y,AP.L1.Z); if (tgt-root.Position).Magnitude<1 then State.autoLeftPhase=2; local d=(AP.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(AP.L1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoLeftPhase==2 then
            local tgt=Vector3.new(AP.L2.X,root.Position.Y,AP.L2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoLeftEnabled=false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1; if autoLeftSetVisual then autoLeftSetVisual(false) end; faceSouth(); return end
            local d=(AP.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
local function stopAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end
local function startAutoRight()
    if State.tpBatEnabled then
        State._setTPBatEnabled(false)
    end

    if Conns.autoRight then Conns.autoRight:Disconnect() end; State.autoRightPhase=1
    Conns.autoRight=RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=getProfileNormalSpeed()
        if State.autoRightPhase==1 then
            local tgt=Vector3.new(AP.R1.X,root.Position.Y,AP.R1.Z); if (tgt-root.Position).Magnitude<1 then State.autoRightPhase=2; local d=(AP.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(AP.R1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoRightPhase==2 then
            local tgt=Vector3.new(AP.R2.X,root.Position.Y,AP.R2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoRightEnabled=false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1; if autoRightSetVisual then autoRightSetVisual(false) end; faceNorth(); return end
            local d=(AP.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
local function stopAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end

local antiRagdollConn = nil

local function resetAntiRagdollCharacter(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)

        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
        hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint")
                or obj:IsA("BallSocketConstraint")
                or obj:IsA("HingeConstraint") then
                obj.Enabled = true
            elseif obj:IsA("BasePart") then
                obj.CanCollide = true
                obj.AssemblyLinearVelocity = Vector3.zero
                obj.AssemblyAngularVelocity = Vector3.zero
            end
        end

        workspace.CurrentCamera.CameraSubject = hum

        local playerModule = LP.PlayerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local controlModule = playerModule:FindFirstChild("ControlModule")
            if controlModule then
                local success, module = pcall(require, controlModule)
                if success and module and module.Enable then
                    module:Enable()
                end
            end
        end
    end)
end

startAntiRagdoll = function()
    if antiRagdollConn then return end

    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not State.antiRagdollEnabled then return end

        local char = LP.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local state = hum:GetState()

        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Dead
            or hum.PlatformStand == true
            or hum.Sit == true then

            resetAntiRagdollCharacter(char)
        end
    end)
end

stopAntiRagdoll = function()
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end

local ContentProvider = game:GetService("ContentProvider")
local Anims = {
    idle1 = "rbxassetid://133806214992291",
    idle2 = "rbxassetid://94970088341563",
    walk = "rbxassetid://707897309",
    run = "rbxassetid://707861613",
    jump = "rbxassetid://116936326516985",
    fall = "rbxassetid://116936326516985",
    climb = "rbxassetid://116936326516985",
    swim = "rbxassetid://116936326516985",
    swimidle = "rbxassetid://116936326516985"
}

task.spawn(function() pcall(function() ContentProvider:PreloadAsync(Anims) end) end)

local function applyAnimPack(char)
    local a = char:FindFirstChild("Animate")
    if not a then return end
    local function s(o, id) if o then o.AnimationId = id end end

    s(a.idle and a.idle.Animation1, Anims.idle1)
    s(a.idle and a.idle.Animation2, Anims.idle2)
    s(a.walk and a.walk.WalkAnim, Anims.walk)
    s(a.run and a.run.RunAnim, Anims.run)
    s(a.jump and a.jump.JumpAnim, Anims.jump)
    s(a.fall and a.fall.FallAnim, Anims.fall)
    s(a.climb and a.climb.ClimbAnim, Anims.climb)
    s(a.swim and a.swim.Swim, Anims.swim)
    s(a.swimidle and a.swimidle.SwimIdle, Anims.swimidle)
end

local animHBConn
function startNuevaAnimacion()
    if animHBConn then animHBConn:Disconnect(); animHBConn = nil end
    local char = LP.Character
    if char then
        applyAnimPack(char)
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if hum2 then
            for _, t in ipairs(hum2:GetPlayingAnimationTracks()) do t:Stop(0) end
            hum2:ChangeState(Enum.HumanoidStateType.Running)
        end
    end

    animHBConn = RunService.Heartbeat:Connect(function()
        if not State.nuevaAnimacionEnabled then return end
        local c = LP.Character
        if c then applyAnimPack(c) end
    end)
end

function stopNuevaAnimacion()
    if animHBConn then animHBConn:Disconnect(); animHBConn = nil end
end

local applyFPSBoost
applyFPSBoost=function()
    pcall(function() setfpscap(999999999) end)
    local function pO(v) pcall(function()
        if v:IsA("Model") then v.LevelOfDetail=Enum.ModelLevelOfDetail.Disabled; v.ModelStreamingMode=Enum.ModelStreamingMode.Nonatomic
        elseif v:IsA("MeshPart") then v.CastShadow=false; v.DoubleSided=false; v.RenderFidelity=Enum.RenderFidelity.Performance
        elseif v:IsA("BasePart") then v.CastShadow=false; v.Material=Enum.Material.Plastic; v.Reflectance=0
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1
        elseif v:IsA("SpecialMesh") then v.TextureId=""
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=false
        elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then v:Destroy()
        elseif v:IsA("Attachment") then v.Visible=false end
    end) end
    for _,v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L=game:GetService("Lighting")
        for _,v in pairs(L:GetDescendants()) do pcall(function() if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end end) end
        pcall(function() sethiddenproperty(L,"Technology",Enum.Technology.Legacy) end)
        L.GlobalShadows=false; L.FogEnd=9e9; L.Brightness=0
        local ter=workspace:FindFirstChildOfClass("Terrain")
        if ter then pcall(function() sethiddenproperty(ter,"Decoration",false) end); ter.WaterReflectance=0; ter.WaterTransparency=0.7; ter.WaterWaveSize=0; ter.WaterWaveSpeed=0 end
    end)
    workspace.DescendantAdded:Connect(function(v) if State.fpsBoostEnabled then task.spawn(pO,v) end end)
end

repeat task.wait() until game:IsLoaded()


-- ============================================================
--  AUTO STEAL (Bless/Yout bar + system) — Voryx.gg theme
-- ============================================================
CONFIG = CONFIG or {}
CONFIG.AUTO_STEAL_ENABLED = true
CONFIG.STEAL_RANGE = CONFIG.STEAL_RANGE or 15
CONFIG.HOLD_MIN = 1.3
CONFIG.HOLD_MAX = 1.3
CONFIG.COOLDOWN = 0.25

Steal = Steal or {}
Steal.AutoStealEnabled = true
Steal.StealRadius = CONFIG.STEAL_RANGE or 15
Steal.StealDuration = 1.3
Steal.Data = Steal.Data or {}

local isStealing = false
local stealConnection = nil
local autoGrabStopTime = 0.96
local autoGrabStopEnabled = true
local progressFill, progressPct, pbFrame

local _plotsCache, _plotsCacheTime = nil, 0
local function getPlotsRoot()
	local now = tick()
	if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
		return _plotsCache
	end
	_plotsCache = workspace:FindFirstChild("Plots")
	_plotsCacheTime = now
	return _plotsCache
end

local function isMyPlotByName(plotName)
	local plotsRoot = getPlotsRoot()
	if not plotsRoot then return false end
	local plot = plotsRoot:FindFirstChild(plotName)
	if not plot then return false end
	local sign = plot:FindFirstChild("PlotSign")
	if sign then
		local yb = sign:FindFirstChild("YourBase")
		if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
	end
	return false
end

local function findNearestPrompt()
	local char = LP.Character
	if not char then return nil, nil end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return nil, nil end
	local plotsRoot = getPlotsRoot()
	if not plotsRoot then return nil, nil end
	local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil
	local rpos = root.Position
	for _, plot in ipairs(plotsRoot:GetChildren()) do
		if not isMyPlotByName(plot.Name) then
			local pods = plot:FindFirstChild("AnimalPodiums")
			if pods then
				for _, pod in ipairs(pods:GetChildren()) do
					pcall(function()
						local base = pod:FindFirstChild("Base")
						local spawn = base and base:FindFirstChild("Spawn")
						if spawn then
							local dist = (spawn.Position - rpos).Magnitude
							if dist < nearestDist and dist <= (Steal.StealRadius or 15) then
								local att = spawn:FindFirstChild("PromptAttachment")
								local list = att and att:GetChildren() or spawn:GetDescendants()
								for _, child in ipairs(list) do
									if child:IsA("ProximityPrompt") and child.ActionText then
										local t = child.ActionText
										if t:find("Steal") or t:find("Brainrot") or t:find("Grab") then
											nearestPrompt = child
											nearestDist = dist
											nearestName = pod.Name
											break
										end
									end
								end
							end
						end
					end)
				end
			end
		end
	end
	return nearestPrompt, nearestName
end

local function executeSteal(prompt, podName)
	if isStealing then return end
	if math.random(30) == 1 then
		for p in pairs(Steal.Data) do
			if not p.Parent then Steal.Data[p] = nil end
		end
	end
	if not Steal.Data[prompt] then
		Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
		pcall(function()
			if getconnections then
				for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
					if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
				end
				for _, c in ipairs(getconnections(prompt.Triggered)) do
					if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
				end
			end
		end)
	end
	local data = Steal.Data[prompt]
	if not data.ready then return end
	data.ready = false
	isStealing = true
	if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
	if progressPct then progressPct.Text = "0%" end
	task.spawn(function()
		for _, f in ipairs(data.hold) do task.spawn(f) end
		local startTime = tick()
		local duration = Steal.StealDuration or 1.3
		local promptFired = false
		if autoGrabStopEnabled then
			while isStealing and Steal.AutoStealEnabled do
				local elapsed = tick() - startTime
				if elapsed >= autoGrabStopTime then break end
				local progress = math.clamp(elapsed / duration, 0, 1)
				if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
				if progressPct then progressPct.Text = math.floor(progress * 100) .. "%" end
				if not prompt.Parent or not prompt.Parent.Parent then break end
				local char = LP.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hrp and prompt.Parent and prompt.Parent.Parent then
					if (hrp.Position - prompt.Parent.Parent.Position).Magnitude > (Steal.StealRadius or 15) then break end
				end
				task.wait()
			end
			local stopProgress = math.clamp(autoGrabStopTime / duration, 0, 1)
			if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
			if progressPct then progressPct.Text = math.floor(stopProgress * 100) .. "%" end
			local phase2Start = tick()
			local phase2Timeout = 2.0
			while isStealing and Steal.AutoStealEnabled and (tick() - phase2Start) < phase2Timeout do
				if not prompt.Parent then break end
				local char = LP.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				local inRange = true
				if hrp and prompt.Parent and prompt.Parent.Parent then
					inRange = (hrp.Position - prompt.Parent.Parent.Position).Magnitude <= (Steal.StealRadius or 15)
				end
				if inRange and not promptFired then
					promptFired = true
					local rem = math.max(duration - autoGrabStopTime, 0.05)
					local t0 = tick()
					while (tick() - t0) < rem and isStealing do
						local p = stopProgress + (1 - stopProgress) * math.clamp((tick() - t0) / rem, 0, 1)
						if progressFill then progressFill.Size = UDim2.new(p, 0, 1, 0) end
						if progressPct then progressPct.Text = math.floor(p * 100) .. "%" end
						task.wait()
					end
					if progressFill then progressFill.Size = UDim2.new(1, 0, 1, 0) end
					if progressPct then progressPct.Text = "100%" end
					pcall(function()
						if fireproximityprompt then fireproximityprompt(prompt) end
						if #data.trigger > 0 then
							for _, f in ipairs(data.trigger) do task.spawn(f) end
						else
							local remote = game:GetService("ReplicatedStorage"):FindFirstChild("StealAnimal")
							if remote and podName then remote:FireServer(podName) end
						end
					end)
					task.wait(0.1)
					pcall(function()
						if fireproximityprompt then fireproximityprompt(prompt) end
						for _, f in ipairs(data.trigger) do task.spawn(f) end
					end)
					break
				end
				task.wait()
			end
		else
			while isStealing and Steal.AutoStealEnabled do
				local elapsed = tick() - startTime
				local progress = math.clamp(elapsed / duration, 0, 1)
				if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
				if progressPct then progressPct.Text = math.floor(progress * 100) .. "%" end
				if not prompt.Parent then break end
				if elapsed >= duration and not promptFired then
					promptFired = true
					pcall(function()
						if fireproximityprompt then fireproximityprompt(prompt) end
						if #data.trigger > 0 then
							for _, f in ipairs(data.trigger) do task.spawn(f) end
						end
					end)
					break
				end
				task.wait()
			end
		end
		task.wait(0.15)
		if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
		if progressPct then progressPct.Text = "0%" end
		data.ready = true
		isStealing = false
	end)
end

function startAutoSteal()
	if stealConnection then
		local okc = false
		pcall(function() okc = stealConnection.Connected end)
		if okc then
			Steal.StealRadius = CONFIG.STEAL_RANGE or Steal.StealRadius
			Steal.AutoStealEnabled = true
			CONFIG.AUTO_STEAL_ENABLED = true
			return true
		end
		pcall(function() stealConnection:Disconnect() end)
		stealConnection = nil
	end
	Steal.StealRadius = CONFIG.STEAL_RANGE or 15
	Steal.AutoStealEnabled = true
	CONFIG.AUTO_STEAL_ENABLED = true
	if pbFrame then pbFrame.Visible = true end
	stealConnection = RunService.Heartbeat:Connect(function()
		if not Steal.AutoStealEnabled or isStealing then return end
		local p, n = findNearestPrompt()
		if p then executeSteal(p, n) end
	end)
	return true
end

function stopAutoSteal()
	if stealConnection then
		pcall(function() stealConnection:Disconnect() end)
		stealConnection = nil
	end
	isStealing = false
	Steal.AutoStealEnabled = false
	CONFIG.AUTO_STEAL_ENABLED = false
	if progressFill then
		pcall(function()
			TweenService:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
		end)
	end
	if progressPct then progressPct.Text = "0%" end
end

-- ===== BARRA AUTO GRAB (Bless/Yout style, Voryx colors) =====
do
	local parentGui = game:GetService("CoreGui")
	pcall(function() if gethui then parentGui = gethui() end end)
	for _, name in ipairs({"YoutAutoGrabBar", "NocturnalStealBar", "VoryxStealBar", "CandyStealBar", ".gg/VioletteCC"}) do
		local old = parentGui:FindFirstChild(name)
		if old then pcall(function() old:Destroy() end) end
	end

	local guiBar = Instance.new("ScreenGui")
	guiBar.Name = "VoryxStealBar"
	guiBar.ResetOnSpawn = false
	guiBar.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	guiBar.DisplayOrder = 500
	pcall(function() if syn and syn.protect_gui then syn.protect_gui(guiBar) end end)
	guiBar.Parent = parentGui

	pbFrame = Instance.new("Frame")
	pbFrame.Name = "YoutAutoGrabBar"
	pbFrame.Size = UDim2.new(0, 344, 0, 56)
	pbFrame.Position = UDim2.new(0.5, -172, 0.80, 0)
	pbFrame.BackgroundColor3 = Color3.fromRGB(5, 20, 32)
	pbFrame.BackgroundTransparency = 0.04
	pbFrame.BorderSizePixel = 0
	pbFrame.Active = true
	pbFrame.Visible = true
	pbFrame.ZIndex = 500
	pbFrame.Parent = guiBar
	Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 12)

	local pbPanelGrad = Instance.new("UIGradient", pbFrame)
	pbPanelGrad.Rotation = 90
	pbPanelGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(18, 45, 68)),
		ColorSequenceKeypoint.new(0.48, Color3.fromRGB(7, 22, 38)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(5, 10, 20)),
	})

	local pbOuterStroke = Instance.new("UIStroke", pbFrame)
	pbOuterStroke.Name = "OuterStroke"
	pbOuterStroke.Color = Color3.fromRGB(0, 190, 230)
	pbOuterStroke.Thickness = 1.1
	pbOuterStroke.Transparency = 0.35

	local progressTitle = Instance.new("TextLabel", pbFrame)
	progressTitle.Name = "DiscordText"
	progressTitle.Size = UDim2.new(1, -14, 0, 16)
	progressTitle.Position = UDim2.new(0, 7, 0, 4)
	progressTitle.BackgroundTransparency = 1
	progressTitle.Text = "voryx.gg"
	progressTitle.TextColor3 = Color3.fromRGB(185, 240, 255)
	progressTitle.Font = Enum.Font.FredokaOne
	progressTitle.TextSize = 12
	progressTitle.TextXAlignment = Enum.TextXAlignment.Center
	progressTitle.ZIndex = 506

	local pbTopRow = Instance.new("Frame", pbFrame)
	pbTopRow.Size = UDim2.new(0, 92, 0, 14)
	pbTopRow.Position = UDim2.new(1, -98, 1, -17)
	pbTopRow.BackgroundTransparency = 1
	pbTopRow.ZIndex = 504

	local fpsNeon = Instance.new("TextLabel", pbTopRow)
	fpsNeon.Name = "FPSNeon"
	fpsNeon.Size = UDim2.new(0.5, -5, 1, 0)
	fpsNeon.Position = UDim2.new(0, 5, 0, 0)
	fpsNeon.BackgroundTransparency = 1
	fpsNeon.Text = "-- FPS"
	fpsNeon.TextColor3 = Color3.fromRGB(165, 220, 255)
	fpsNeon.Font = Enum.Font.FredokaOne
	fpsNeon.TextSize = 8
	fpsNeon.TextXAlignment = Enum.TextXAlignment.Left
	fpsNeon.ZIndex = 506

	local pingNeon = Instance.new("TextLabel", pbTopRow)
	pingNeon.Name = "PingNeon"
	pingNeon.Size = UDim2.new(0.5, -2, 1, 0)
	pingNeon.Position = UDim2.new(0.5, 1, 0, 0)
	pingNeon.BackgroundTransparency = 1
	pingNeon.Text = "-- MS"
	pingNeon.TextColor3 = Color3.fromRGB(165, 220, 255)
	pingNeon.Font = Enum.Font.FredokaOne
	pingNeon.TextSize = 8
	pingNeon.TextXAlignment = Enum.TextXAlignment.Right
	pingNeon.ZIndex = 506

	local pbBarBg = Instance.new("Frame", pbFrame)
	pbBarBg.Name = "BarBg"
	pbBarBg.Size = UDim2.new(1, -14, 0, 20)
	pbBarBg.Position = UDim2.new(0, 7, 0, 22)
	pbBarBg.BackgroundColor3 = Color3.fromRGB(3, 8, 16)
	pbBarBg.BorderSizePixel = 0
	pbBarBg.ClipsDescendants = true
	pbBarBg.ZIndex = 500
	Instance.new("UICorner", pbBarBg).CornerRadius = UDim.new(0, 8)

	local trackStroke = Instance.new("UIStroke", pbBarBg)
	trackStroke.Color = Color3.fromRGB(0, 120, 160)
	trackStroke.Thickness = 1
	trackStroke.Transparency = 0.15

	progressFill = Instance.new("Frame", pbBarBg)
	progressFill.Size = UDim2.new(0, 0, 1, 0)
	progressFill.BackgroundColor3 = Color3.fromRGB(0, 190, 230)
	progressFill.BorderSizePixel = 0
	progressFill.ClipsDescendants = true
	progressFill.ZIndex = 502
	Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 8)

	local fillGrad = Instance.new("UIGradient", progressFill)
	fillGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(185, 240, 255)),
		ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 190, 230)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 120, 180)),
	})

	local fillHighlight = Instance.new("Frame", progressFill)
	fillHighlight.Size = UDim2.new(1, -6, 0.35, 0)
	fillHighlight.Position = UDim2.new(0, 3, 0, 1)
	fillHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	fillHighlight.BackgroundTransparency = 0.72
	fillHighlight.BorderSizePixel = 0
	fillHighlight.ZIndex = 503
	Instance.new("UICorner", fillHighlight).CornerRadius = UDim.new(1, 0)

	local shimmer = Instance.new("Frame", progressFill)
	shimmer.Name = "Shimmer"
	shimmer.Size = UDim2.new(0, 34, 1, 0)
	shimmer.Position = UDim2.new(0, -34, 0, 0)
	shimmer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	shimmer.BackgroundTransparency = 0.58
	shimmer.BorderSizePixel = 0
	shimmer.ZIndex = 504
	Instance.new("UICorner", shimmer).CornerRadius = UDim.new(1, 0)
	local shimmerGrad = Instance.new("UIGradient", shimmer)
	shimmerGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0.00, 1),
		NumberSequenceKeypoint.new(0.50, 0.25),
		NumberSequenceKeypoint.new(1.00, 1),
	})

	progressPct = Instance.new("TextLabel", pbBarBg)
	progressPct.Size = UDim2.new(1, 0, 1, 0)
	progressPct.BackgroundTransparency = 1
	progressPct.Text = "0%"
	progressPct.TextColor3 = Color3.fromRGB(245, 250, 255)
	progressPct.Font = Enum.Font.FredokaOne
	progressPct.TextSize = 11
	progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	progressPct.TextStrokeTransparency = 0.25
	progressPct.TextXAlignment = Enum.TextXAlignment.Center
	progressPct.ZIndex = 505

	-- shimmer loop
	task.spawn(function()
		while pbFrame and pbFrame.Parent do
			shimmer.Position = UDim2.new(0, -60, 0, 0)
			pcall(function()
				TweenService:Create(shimmer, TweenInfo.new(1.6, Enum.EasingStyle.Linear), {
					Position = UDim2.new(1, 20, 0, 0)
				}):Play()
			end)
			task.wait(1.6)
		end
	end)

	-- fps / ping
	task.spawn(function()
		local lastFrame = tick()
		local fpsSamples = {}
		RunService.RenderStepped:Connect(function()
			local now = tick()
			local dt = now - lastFrame
			lastFrame = now
			if dt > 0 then
				table.insert(fpsSamples, 1 / dt)
				if #fpsSamples > 20 then table.remove(fpsSamples, 1) end
				local sum = 0
				for _, v in ipairs(fpsSamples) do sum = sum + v end
				fpsNeon.Text = string.format("%d FPS", math.floor(sum / #fpsSamples + 0.5))
			end
		end)
		while pbFrame and pbFrame.Parent do
			local ping = 0
			pcall(function()
				ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
			end)
			pingNeon.Text = string.format("%d MS", ping)
			task.wait(0.5)
		end
	end)

	-- drag
	local dragging, dragStart, startPos
	pbFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = pbFrame.Position
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - dragStart
			pbFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	if State then State.autoStealBarFrame = pbFrame end
	pcall(startAutoSteal)
end

print("[Voryx.gg] Auto Steal (Bless bar) loaded")


RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- SECCIÓN 12: PERSISTENCIA (SAVE/LOAD) CON AUTO CARRY Y AUTO STEAL
saveConfig = function(btn)
    if State._configLoading or not State._configLoaded then
        State._saveAfterLoad = true
        return false
    end

    if State._configLoadFailed and not btn then
        return false
    end

    if State._saveInProgress then
        State._saveQueued = true
        return false
    end

    State._saveInProgress = true

    local function keySnapshot(entry)
        return {
            kb = entry and entry.kb and entry.kb.Name or nil,
            gp = entry and entry.gp and entry.gp.Name or nil,
        }
    end

    local function positionSnapshot(guiObject)
        if not guiObject then return nil end
        local ok, p = pcall(function() return guiObject.Position end)
        if not ok or not p then return nil end
        return {
            xs = p.X.Scale,
            xo = p.X.Offset,
            ys = p.Y.Scale,
            yo = p.Y.Offset,
        }
    end

    local savedStealRadius = Steal.StealRadius
    local savedAutoStealEnabled = Steal.AutoStealEnabled
    if CONFIG then
        if type(CONFIG.STEAL_RANGE) == "number" then
            savedStealRadius = CONFIG.STEAL_RANGE
        end
        if CONFIG.AUTO_STEAL_ENABLED ~= nil then
            savedAutoStealEnabled = CONFIG.AUTO_STEAL_ENABLED == true
        end
    end

    local cfg = {
        configVersion = 8,

        normalSpeed = NS,
        carrySpeed = CS,
        profileLaggerNormalSpeed = State.profileLaggerNormalSpeed,
        profileLaggerCarrySpeed = State.profileLaggerCarrySpeed,
        speedProfile = State.speedProfile,
        laggerSpeed = LS,
        laggerCarrySpeed = LS2,
        stealRadius = savedStealRadius,
        stealDuration = Steal.StealDuration,

        uiScale = uiScaleValue,
        backgroundAssetId = State.backgroundAssetId,
        animPack = (function()
            local ok, name = pcall(function()
                if _G.NIGHT_getCurrentAnimPack then return _G.NIGHT_getCurrentAnimPack() end
            end)
            if ok and type(name) == "string" and name ~= "" then return name end
            return nil
        end)(),
        musicPack = (function()
            local ok, name = pcall(function()
                if _G.NIGHT_musicGet then return _G.NIGHT_musicGet() end
            end)
            if ok and type(name) == "string" and name ~= "" then return name end
            return "Off"
        end)(),
        skinPack = (function()
            local ok, name = pcall(function()
                if _G.NIGHT_getSkin then return _G.NIGHT_getSkin() end
            end)
            if ok and type(name) == "string" and name ~= "" then return name end
            return "Off"
        end)(),
        accessoryPack = (function()
            local ok, name = pcall(function()
                if _G.NIGHT_getCurrentAccessoryPack then return _G.NIGHT_getCurrentAccessoryPack() end
            end)
            if ok and type(name) == "string" and name ~= "" then return name end
            return "Off"
        end)(),
        musicPCKey = keySnapshot(KB.MusicPC),
        tauntKey = keySnapshot(KB.Taunt),
        musicPadKey = keySnapshot(KB.MusicPad),
        buttonsSize = State.buttonsSizeValue,
        buttonsShape = State.buttonsShape,
        buttonImages = State.buttonImages or {},
        uiLocked = uiLocked,
        autoGrabLocked = State.autoGrabLocked == true,
        guiVisible = State.guiVisible,

        autoLeftKey = keySnapshot(KB.AutoLeft),
        autoRightKey = keySnapshot(KB.AutoRight),
        dropKey = keySnapshot(KB.Drop),
        tpDownKey = keySnapshot(KB.TPDown),
        autoBatKey = keySnapshot(KB.AutoBat),
        autoBatV2Key = keySnapshot(KB.AutoBatV2),
        instaResetKey = keySnapshot(KB.InstaReset),
        tpBatKey = keySnapshot(KB.TPBat),
        speedKey = keySnapshot(KB.Speed),
        laggerKey = keySnapshot(KB.Lagger),
        guiHideKey = keySnapshot(KB.GuiHide),

        infJump = State.infJumpEnabled,
        superJump = State.superJumpEnabled,
        antiRagdoll = State.antiRagdollEnabled,
        fpsBoost = State.fpsBoostEnabled,
        medusaCounter = State.medusaCounterEnabled,
        ninoTime = ninoTimeEnabled,
        batCounter = State.batCounterEnabled,
        autoStealEnabled = savedAutoStealEnabled,
        unwalkEnabled = State.unwalkEnabled,
        desyncEnabled = State.desyncEnabled,
        autoSwing = State.autoSwingEnabled,
        autoBatToggled = State.autoBatToggled,
        autoBatV2Toggled = State.autoBatV2Enabled,
        tpBatEnabled = State.tpBatEnabled,
        stretchRez = State.stretchRezEnabled,
        removeAccessories = State.removeAccessoriesEnabled,
        antiLag = State.antiLagEnabled,
        darkMode = State.darkModeEnabled,
        skyStyle = State.skyStyle,
        noIntro = State.noIntro == true,
        introEnabled = State.noIntro ~= true,
        selectedIntroMusic = State.selectedIntroMusic,
        autoTPDown = autoTPDownEnabled,
        autoTPDownHeight = autoTPDownHeight,

        speedToggled = State.speedToggled,
        laggerMode = State.laggerToggled,
        laggerPhase = laggerPhase,

        linieEnabled = State.linieEnabled,
        autoMedusaEnabled = MedusaConfig and MedusaConfig.Enabled or nil,
        medusaRadius = MedusaConfig and MedusaConfig.Radius or nil,
        medusaDelay = MedusaConfig and MedusaConfig.Delay or nil,
        nuevaAnimacion = State.nuevaAnimacionEnabled,
        instaReset = State.instaResetEnabled,
        instaResetVisible = btnInstaReset and btnInstaReset.Visible or nil,
        hideButtons = State.hideButtonsEnabled,

        autoCarryEnabled = State.autoCarryEnabled,

        batV1Speed = State.batV1Speed,
        batV2Speed = State.batV2Speed,

        panelPos = positionSnapshot(MobilePanel),
        mobileButtonPositions = (function()
            local positions = {}
            for name, mobileBtn in pairs(mobileButtonsByName) do
                positions[name] = positionSnapshot(mobileBtn)
            end
            return positions
        end)(),
        mainPos = positionSnapshot(main),
        miniPos = positionSnapshot(mini),
        pbPos = positionSnapshot(pbFrame),
        batV2Pos = positionSnapshot(btnBatV2),
        instaResetPos = positionSnapshot(btnInstaReset),
        autoStealBarPos = positionSnapshot(frame),
    }

    local encodeOk, encoded = pcall(function()
        return HttpService:JSONEncode(cfg)
    end)

    local saved = false
    if encodeOk and encoded then
        if not btn and encoded == State._lastConfigJson then
            State._configDirty = false
            State._saveInProgress = false
            State._saveQueued = false
            return true
        end

        local atomicOk, atomicResult, atomicErr = pcall(function()
            return State._atomicJsonSave(
                CONFIG_FILE,
                State._configBackupFile,
                State._configTempFile,
                encoded
            )
        end)

        saved = atomicOk and atomicResult == true
        if saved then
            State._lastConfigJson = encoded
            State._lastSaveError = nil
            State._configLoadFailed = false
            State._allowInitialConfigCreation = false

            if State.savePositionBackup then pcall(State.savePositionBackup) end

            State._configDirty = false
        else
            State._lastConfigJson = nil
            State._lastSaveError = tostring((atomicOk and atomicErr) or atomicResult or "No se pudo escribir la configuración")
            warn("[Voryx AUTO SAVE] " .. State._lastSaveError)
        end
    else
        State._lastSaveError = "No se pudo convertir la configuración a JSON"
    end

    State._saveInProgress = false

    if btn and btn.Parent then
        local previousText = btn.Text
        btn.Text = saved and "Saved!" or "Failed!"
        task.delay(1.5, function()
            if btn and btn.Parent then btn.Text = previousText end
        end)
    end

    if State._saveQueued then
        State._saveQueued = false
        if State.requestConfigSave then State.requestConfigSave() end
    end

    return saved
end

loadConfig = function()
    local function readConfigFile(path)
        local decoded, raw = State._readValidJsonFile(path)
        if type(decoded) ~= "table" then return nil, raw end
        return decoded, raw
    end

    local mainCfg, mainRaw = readConfigFile(CONFIG_FILE)
    local tempCfg, tempRaw = readConfigFile(State._configTempFile)
    local backupCfg, backupRaw = readConfigFile(State._configBackupFile)
    local legacyCfg, legacyRaw = readConfigFile(State._legacyConfigFile)
    local legacyTempCfg, legacyTempRaw = readConfigFile(State._legacyConfigTempFile)
    local legacyBackupCfg, legacyBackupRaw = readConfigFile(State._legacyConfigBackupFile)

    local cfg, raw = nil, nil
    local loadedFromBackup = false
    local loadedFromLegacy = false
    local loadedFromTemp = false

    if type(tempCfg) == "table" and (type(mainCfg) ~= "table" or tempRaw ~= mainRaw) then
        cfg, raw = tempCfg, tempRaw
        loadedFromTemp = true
    elseif type(mainCfg) == "table" then
        cfg, raw = mainCfg, mainRaw
    elseif type(backupCfg) == "table" then
        cfg, raw = backupCfg, backupRaw
        loadedFromBackup = true
    elseif type(legacyTempCfg) == "table" and (type(legacyCfg) ~= "table" or legacyTempRaw ~= legacyRaw) then
        cfg, raw = legacyTempCfg, legacyTempRaw
        loadedFromLegacy = true
        loadedFromTemp = true
    elseif type(legacyCfg) == "table" then
        cfg, raw = legacyCfg, legacyRaw
        loadedFromLegacy = true
    elseif type(legacyBackupCfg) == "table" then
        cfg, raw = legacyBackupCfg, legacyBackupRaw
        loadedFromLegacy = true
        loadedFromBackup = true
    end

    local hadAnyConfigFile = false
    for _, path in ipairs({
        CONFIG_FILE,
        State._configTempFile,
        State._configBackupFile,
        State._legacyConfigFile,
        State._legacyConfigTempFile,
        State._legacyConfigBackupFile,
    }) do
        local exists = false
        pcall(function() exists = _isfile(path) end)
        if exists then hadAnyConfigFile = true break end
    end

    if not cfg then
        State._configLoaded = true
        State._configLoadFailed = hadAnyConfigFile
        State._allowInitialConfigCreation = not hadAnyConfigFile
        State._saveAfterLoad = false
        State._lastSaveError = hadAnyConfigFile and "Se encontraron configuraciones dañadas; no se sobrescribieron" or nil
        if State.loadPositionBackup then pcall(State.loadPositionBackup) end
        return false
    end

    State._configLoading = true
    State._configLoadFailed = false
    State._allowInitialConfigCreation = false

    local applyOk = pcall(function()
        if type(cfg.normalSpeed) == "number" then
            NS = cfg.normalSpeed
            if normalBox then normalBox.Text = tostring(NS) end
        end
        if type(cfg.carrySpeed) == "number" then
            CS = cfg.carrySpeed
            if carryBox then carryBox.Text = tostring(CS) end
        end
        if type(cfg.profileLaggerNormalSpeed) == "number" then
            State.profileLaggerNormalSpeed = cfg.profileLaggerNormalSpeed
        end
        if type(cfg.profileLaggerCarrySpeed) == "number" then
            State.profileLaggerCarrySpeed = cfg.profileLaggerCarrySpeed
        end
        if type(cfg.laggerSpeed) == "number" then
            LS = cfg.laggerSpeed
            if laggerBox then laggerBox.Text = tostring(LS) end
        end
        if type(cfg.laggerCarrySpeed) == "number" then
            LS2 = cfg.laggerCarrySpeed
            if laggerBox2 then laggerBox2.Text = tostring(LS2) end
        end

        if type(cfg.uiScale) == "number" then
            uiScaleValue = math.clamp(math.floor(cfg.uiScale + 0.5), 50, 150)
            if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
            if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
        end

        if cfg.backgroundAssetId and State.applyBackgroundImage then
            State.applyBackgroundImage(cfg.backgroundAssetId, false)
        elseif State.applyBackgroundImage then
            State.applyBackgroundImage(State.backgroundAssetId, false)
        end

        if type(cfg.animPack) == "string" and cfg.animPack ~= "" and cfg.animPack ~= "Off" and cfg.animPack ~= "Normal" and cfg.animPack ~= "Default" then
            pcall(function()
                if _G.NIGHT_setCurrentAnimPack then _G.NIGHT_setCurrentAnimPack(cfg.animPack) end
                if _G.NIGHT_applyAnimationPack then _G.NIGHT_applyAnimationPack(cfg.animPack) end
            end)
            if State._animPackSelectorVisual then
                pcall(function() State._animPackSelectorVisual(cfg.animPack, false) end)
            end
        elseif cfg.animPack == "Off" or cfg.animPack == "Normal" or cfg.animPack == "Default" or cfg.animPack == nil then
            pcall(function()
                if _G.NIGHT_applyAnimationPack then _G.NIGHT_applyAnimationPack("Normal") end
                if _G.NIGHT_setCurrentAnimPack then _G.NIGHT_setCurrentAnimPack(nil) end
            end)
            if State._animPackSelectorVisual then
                pcall(function() State._animPackSelectorVisual("Normal", false) end)
            end
        end

        if type(cfg.musicPack) == "string" and cfg.musicPack ~= "" then
            pcall(function()
                if _G.NIGHT_musicPlay then _G.NIGHT_musicPlay(cfg.musicPack) end
            end)
            if State._musicPackSelectorVisual then
                pcall(function() State._musicPackSelectorVisual(cfg.musicPack, false) end)
            end
        end

        if type(cfg.skinPack) == "string" and cfg.skinPack ~= "" then
            local skinName = cfg.skinPack
            pcall(function()
                if _G.NIGHT_applySkin then _G.NIGHT_applySkin(skinName) end
            end)
            if State._skinPackSelectorVisual then
                pcall(function() State._skinPackSelectorVisual(skinName, false) end)
            end
            -- Reaplicar tras un momento por si el personaje aún no está listo
            task.delay(0.6, function()
                pcall(function()
                    if _G.NIGHT_applySkin then _G.NIGHT_applySkin(skinName) end
                end)
            end)
            task.delay(1.5, function()
                pcall(function()
                    if _G.NIGHT_applySkin then _G.NIGHT_applySkin(skinName) end
                end)
            end)
        end

        if type(cfg.accessoryPack) == "string" and cfg.accessoryPack ~= "" then
            local accName = cfg.accessoryPack
            pcall(function()
                if _G.NIGHT_setCurrentAccessoryPack then _G.NIGHT_setCurrentAccessoryPack(accName) end
                if _G.NIGHT_applyAccessoryPack then _G.NIGHT_applyAccessoryPack(accName) end
            end)
            if State._accessoryPackSelectorVisual then
                pcall(function() State._accessoryPackSelectorVisual(accName, false) end)
            end
            task.delay(0.8, function()
                pcall(function()
                    if _G.NIGHT_applyAccessoryPack then _G.NIGHT_applyAccessoryPack(accName) end
                end)
            end)
            task.delay(1.6, function()
                pcall(function()
                    if _G.NIGHT_applyAccessoryPack then _G.NIGHT_applyAccessoryPack(accName) end
                end)
            end)
        end

        if type(cfg.buttonsSize) == "number" then
            State.buttonsSizeValue = math.clamp(math.floor(cfg.buttonsSize + 0.5), 0, 100)
        end
        if cfg.buttonsShape ~= nil then
            State.buttonsShape = normalizeMobileButtonsShape(cfg.buttonsShape)
        end
        applyMobileButtonsSize(State.buttonsSizeValue)
        if buttonsSizeBox then buttonsSizeBox.Text = tostring(State.buttonsSizeValue) end
        if State._buttonsShapeSelectorVisual then
            State._buttonsShapeSelectorVisual(State.buttonsShape, false)
        end

        -- Cargar imágenes de botones (mismos assets del script)
        if type(cfg.buttonImages) == "table" then
            State.buttonImages = cfg.buttonImages
            task.defer(function()
                pcall(applyAllButtonImages)
            end)
        end

        if cfg.uiLocked ~= nil then
            uiLocked = cfg.uiLocked == true
            if setLockUIVisual then setLockUIVisual(uiLocked) end
        end

        if cfg.autoGrabLocked ~= nil then
            pcall(function()
                setAutoGrabLocked(cfg.autoGrabLocked == true, true)
            end)
        end

        if cfg.guiVisible ~= nil then
            State.guiVisible = cfg.guiVisible == true
            if main then main.Visible = State.guiVisible end
            if mini then mini.Visible = not State.guiVisible end
        end

        if cfg.selectedIntroMusic ~= nil then
            State.selectedIntroMusic = cfg.selectedIntroMusic
            if getgenv and getgenv().FEARV2MusicBtn then
                getgenv().FEARV2MusicBtn.Text = "Music " .. tostring(State.selectedIntroMusic)
            end
        end
        if cfg.noIntro ~= nil then
            State.noIntro = cfg.noIntro == true
        elseif cfg.introEnabled ~= nil then
            State.noIntro = cfg.introEnabled ~= true
        end
        State.introEnabled = not State.noIntro
        if setNoIntroToggle then setNoIntroToggle(State.noIntro, false) end
        if setIntroToggle then setIntroToggle(State.introEnabled, false) end

        if type(cfg.autoTPDownHeight) == "number" then
            autoTPDownHeight = math.clamp(cfg.autoTPDownHeight, 0, 500)
        end
        if cfg.autoTPDown ~= nil then
            autoTPDownEnabled = cfg.autoTPDown == true
            if setAutoTPDownVisual then setAutoTPDownVisual(autoTPDownEnabled) end
            if autoTPDownEnabled then startAutoTPDown() else stopAutoTPDown() end
        end

        local savedRadius = cfg.stealRadius or cfg.grabRadius
        if savedRadius == 61 or savedRadius == 63 then
            savedRadius = 10
        end
        if type(savedRadius) == "number" then
            -- Cap the saved value so an older config cannot restore a larger Auto Grab range.
            savedRadius = math.min(savedRadius, 8)
            Steal.StealRadius = savedRadius
            if progressRadLbl then progressRadLbl.Text = "Radius: " .. tostring(savedRadius) end
            if radValBtn then radValBtn.Text = tostring(savedRadius) end
            if radBox then radBox.Text = tostring(savedRadius) end
            if CONFIG then CONFIG.STEAL_RANGE = savedRadius end
        end
        if type(cfg.stealDuration) == "number" then
            Steal.StealDuration = cfg.stealDuration
            if durValBtn then durValBtn.Text = tostring(Steal.StealDuration) end
        end

        if MedusaConfig then
            if type(cfg.medusaRadius) == "number" then
                MedusaConfig.Radius = cfg.medusaRadius
                if MedusaConfig.RadiusPart then
                    MedusaConfig.RadiusPart.Size = Vector3.new(0.2, MedusaConfig.Radius * 2, MedusaConfig.Radius * 2)
                end
            end
            if type(cfg.medusaDelay) == "number" then
                MedusaConfig.Delay = cfg.medusaDelay
            end
        end

        local function loadKey(entry, data)
            if not entry or type(data) ~= "table" then return end
            entry.kb = nil
            entry.gp = nil
            if data.kb and Enum.KeyCode[data.kb] then entry.kb = Enum.KeyCode[data.kb] end
            if data.gp and Enum.KeyCode[data.gp] then entry.gp = Enum.KeyCode[data.gp] end

            if State._bindButtons and State._bindButtons[entry] then
                State._bindButtons[entry].Text =
                    entry.gp and ("GP:" .. entry.gp.Name)
                    or (entry.kb and entry.kb.Name or "None")
            end
        end

        loadKey(KB.AutoLeft, cfg.autoLeftKey)
        loadKey(KB.AutoRight, cfg.autoRightKey)
        loadKey(KB.Drop, cfg.dropKey)
        loadKey(KB.TPDown, cfg.tpDownKey)
        loadKey(KB.AutoBat, cfg.autoBatKey)
        loadKey(KB.AutoBatV2, cfg.autoBatV2Key)
        loadKey(KB.InstaReset, cfg.instaResetKey)
        loadKey(KB.TPBat, cfg.tpBatKey)
        loadKey(KB.Speed, cfg.speedKey)
        loadKey(KB.Lagger, cfg.laggerKey)
        loadKey(KB.GuiHide, cfg.guiHideKey)
        loadKey(KB.MusicPC, cfg.musicPCKey)
        loadKey(KB.MusicPad, cfg.musicPadKey)
        loadKey(KB.Taunt, cfg.tauntKey)

        if cfg.infJump ~= nil then
            State.infJumpEnabled = cfg.infJump == true
            if setInfJump then setInfJump(State.infJumpEnabled) end
        end
        if cfg.superJump ~= nil then
            State.superJumpEnabled = cfg.superJump == true
            if setSuperJump then setSuperJump(State.superJumpEnabled) end
        end
        if cfg.antiRagdoll ~= nil then
            State.antiRagdollEnabled = cfg.antiRagdoll == true
            if setAntiRag then setAntiRag(State.antiRagdollEnabled) end
            if State.antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end
        end
        if cfg.fpsBoost ~= nil then
            State.fpsBoostEnabled = cfg.fpsBoost == true
            if setFps then setFps(State.fpsBoostEnabled) end
            if State.fpsBoostEnabled then pcall(applyFPSBoost) end
        end
        if cfg.medusaCounter ~= nil then
            State.medusaCounterEnabled = cfg.medusaCounter == true
            if setMedusaCounter then setMedusaCounter(State.medusaCounterEnabled) end
            if State.medusaCounterEnabled then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
            if cfg.medusaReset ~= nil then
                State.autoResetEnabled = cfg.medusaReset == true
                pcall(function() if _G.NIGHT_setMedusaReset then _G.NIGHT_setMedusaReset(State.autoResetEnabled) end end)
            end
        end
        if cfg.ninoTime ~= nil then setNinoTime(cfg.ninoTime == true) end
        if cfg.batCounter ~= nil then
            State.batCounterEnabled = cfg.batCounter == true
            if setBatCounter then setBatCounter(State.batCounterEnabled) end
            if State.batCounterEnabled then startBatCounter() else stopBatCounter() end
        end
        if cfg.autoStealEnabled ~= nil then
            local autoStealOn = cfg.autoStealEnabled == true
            Steal.AutoStealEnabled = autoStealOn
            if CONFIG then CONFIG.AUTO_STEAL_ENABLED = autoStealOn end
            if setAutoGrab then setAutoGrab(autoStealOn) end

            if progressPct then progressPct.Text = autoStealOn and "READY" or "IDLE" end
            if toggleBtn then
                if autoStealOn then
                    toggleBtn.Text = "STOP"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 210)
                    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
                    btnStroke.Color = Color3.fromRGB(190,190,200)
                    btnGrad.Color = ColorSequence.new(Color3.fromRGB(0, 170, 210), Color3.fromRGB(150,150,160))
                else
                    toggleBtn.Text = "START"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(12,12,14)
                    toggleBtn.TextColor3 = Color3.fromRGB(180,180,180)
                    btnStroke.Color = Color3.fromRGB(40,40,48)
                    btnGrad.Color = ColorSequence.new(Color3.fromRGB(16,16,18), Color3.fromRGB(14,14,16))
                end
            end

            if autoStealOn then pcall(startAutoSteal) else pcall(stopAutoSteal) end
        end
        if cfg.autoSwing ~= nil then
            State.autoSwingEnabled = cfg.autoSwing == true
            if setAutoSwingVisual then setAutoSwingVisual(State.autoSwingEnabled) end
        end
        if cfg.unwalkEnabled ~= nil then
            State.unwalkEnabled = cfg.unwalkEnabled == true
            if setUnwalkToggle then setUnwalkToggle(State.unwalkEnabled) end
            if State.unwalkEnabled then startUnwalk() else stopUnwalk() end
        end

        if cfg.stretchRez ~= nil and setStretchRez then
            State.stretchRezEnabled = cfg.stretchRez == true
            setStretchRez(State.stretchRezEnabled)
        end
        if cfg.removeAccessories ~= nil and setRemoveAccessories then
            State.removeAccessoriesEnabled = cfg.removeAccessories == true
            setRemoveAccessories(State.removeAccessoriesEnabled)
        end
        if cfg.antiLag ~= nil and setAntiLag then
            State.antiLagEnabled = cfg.antiLag == true
            setAntiLag(State.antiLagEnabled)
        end

        if cfg.skyStyle ~= nil and setSkyStyle then
            setSkyStyle(cfg.skyStyle)
        elseif cfg.darkMode ~= nil and setDarkMode then
            setDarkMode(cfg.darkMode == true)
        end

        if cfg.desyncEnabled ~= nil then
            State.desyncEnabled = cfg.desyncEnabled == true
            task.defer(function()
                if setDesync then setDesync(State.desyncEnabled) end
                if saDesync then saDesync(State.desyncEnabled) end
                if State.desyncEnabled and startDesyncSession then startDesyncSession() end
            end)
        end

        if cfg.linieEnabled ~= nil then
            State.linieEnabled = cfg.linieEnabled == true
            if setLinieVisual then setLinieVisual(State.linieEnabled) end
        end
        if cfg.autoMedusaEnabled ~= nil then
            if MedusaConfig then MedusaConfig.Enabled = cfg.autoMedusaEnabled == true end
            if setAutoMedusaVisual then setAutoMedusaVisual(cfg.autoMedusaEnabled == true) end
        end

        if cfg.nuevaAnimacion ~= nil then
            State.nuevaAnimacionEnabled = cfg.nuevaAnimacion == true
            if setNuevaAnimacionVisual then setNuevaAnimacionVisual(State.nuevaAnimacionEnabled) end
            if State.nuevaAnimacionEnabled then
                task.defer(startNuevaAnimacion)
            else
                task.defer(stopNuevaAnimacion)
            end
        end

        local savedInstaReset = cfg.instaReset
        if savedInstaReset == nil then savedInstaReset = cfg.instaResetEnabled end
        if savedInstaReset ~= nil then
            State.instaResetEnabled = savedInstaReset == true
            if setInstaToggleVisual then setInstaToggleVisual(State.instaResetEnabled) end
        end

        if cfg.hideButtons ~= nil then
            State.hideButtonsEnabled = cfg.hideButtons == true
            if setHideButtonsVisual then setHideButtonsVisual(State.hideButtonsEnabled) end

            local visible = not State.hideButtonsEnabled
            if MobilePanel then MobilePanel.Visible = visible end
            for _, mobileBtn in pairs(mobileButtonsByName) do
                if mobileBtn then mobileBtn.Visible = visible end
            end
            if btnBatV2 then btnBatV2.Visible = visible end
            if btnInstaReset then
                btnInstaReset.Visible = visible and (cfg.instaResetVisible ~= false)
            end
        elseif cfg.instaResetVisible ~= nil and btnInstaReset then
            btnInstaReset.Visible = cfg.instaResetVisible == true
        end

        State.speedProfile = cfg.speedProfile == "Lagger" and "Lagger" or "Normal"
        if State._refreshSpeedProfileVisual then State._refreshSpeedProfileVisual() end
        if normalBox then
            normalBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS)
        end
        if carryBox then
            carryBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS)
        end

        State.speedToggled = cfg.speedToggled == true
        State.laggerToggled = cfg.laggerMode == true
        laggerPhase = tonumber(cfg.laggerPhase) or (State.laggerToggled and 1 or 0)
        laggerPhase = math.clamp(math.floor(laggerPhase), 0, 2)

        if State.laggerToggled then
            State.speedToggled = false
        elseif laggerPhase ~= 0 then
            laggerPhase = 0
        end

        if mobileSpeedSetActive then mobileSpeedSetActive(State.speedToggled) end
        if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
        if modeValLbl then
            modeValLbl.Text =
                laggerPhase == 2 and "Lagger Carry"
                or (State.laggerToggled and "Lagger")
                or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry"))
                or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal")
        end

        State._setTPBatEnabled(cfg.tpBatEnabled == true)
        if State._tpBatSetVisual then State._tpBatSetVisual(State.tpBatEnabled) end
        if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(State.tpBatEnabled) end

        local autoBatV1 = cfg.autoBatToggled == true
        local autoBatV2 = cfg.autoBatV2Toggled == true
        if autoBatV1 then autoBatV2 = false end

        State.autoBatToggled = autoBatV1
        State.autoBatV2Enabled = autoBatV2

        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
        if autoBatV2SetVisual then autoBatV2SetVisual(State.autoBatV2Enabled) end
        if State.autoBatToggled then
            task.defer(startBatAimbot)
        elseif State.autoBatV2Enabled then
            task.defer(startBatAimbotV2)
        else
            pcall(stopBatAimbot)
            if stopBatAimbotV2 then pcall(stopBatAimbotV2) end
        end

        if type(cfg.batV1Speed) == "number" then
            State.batV1Speed = cfg.batV1Speed
            if batV1SpeedBox then batV1SpeedBox.Text = tostring(State.batV1Speed) end
        end
        if type(cfg.batV2Speed) == "number" then
            State.batV2Speed = cfg.batV2Speed
            if batV2SpeedBox then batV2SpeedBox.Text = tostring(State.batV2Speed) end
        end

        if cfg.autoCarryEnabled ~= nil then
            State.autoCarryEnabled = cfg.autoCarryEnabled == true
            if State.autoCarrySetVisual then
                State.autoCarrySetVisual(State.autoCarryEnabled)
            end
        end

        local function restorePosition(guiObject, data)
            if guiObject and type(data) == "table" and data.xs ~= nil then
                guiObject.Position = UDim2.new(
                    data.xs,
                    data.xo or 0,
                    data.ys or 0,
                    data.yo or 0
                )
            end
        end

        local function restoreSavedPositions()
            restorePosition(main, cfg.mainPos)
            restorePosition(mini, cfg.miniPos)
            restorePosition(MobilePanel, cfg.panelPos)

            if type(cfg.mobileButtonPositions) == "table" then
                for name, positionData in pairs(cfg.mobileButtonPositions) do
                    restorePosition(mobileButtonsByName[name], positionData)
                end
            end

            restorePosition(pbFrame, cfg.pbPos)
            restorePosition(btnBatV2, cfg.batV2Pos)
            restorePosition(btnInstaReset, cfg.instaResetPos)
            restorePosition(frame, cfg.autoStealBarPos)
        end

        restoreSavedPositions()
        task.delay(0.7, restoreSavedPositions)
        task.delay(1.35, function()
            restoreSavedPositions()
            task.defer(function()
                if State.loadPositionBackup and not State._positionDirty then
                    pcall(State.loadPositionBackup)
                end
            end)
        end)
    end)

    State._configLoading = false
    State._configLoaded = true
    State._configLoadFailed = not applyOk

    if applyOk then
        State._lastConfigJson = raw
        State._lastSaveError = nil
        State._configDirty = false
    else
        State._lastSaveError = "La configuración se leyó, pero no se pudo aplicar; no será sobrescrita"
    end

    local pendingSave = State._saveAfterLoad
    State._saveAfterLoad = false

    if applyOk and (loadedFromBackup or loadedFromLegacy or loadedFromTemp or pendingSave) then
        if loadedFromBackup or loadedFromLegacy or loadedFromTemp then State._lastConfigJson = nil end
        State.requestConfigSave()
    end

    return applyOk
end

State._otherSpeedLabels = State._otherSpeedLabels or {}
State._otherSpeedConnections = State._otherSpeedConnections or {}

State._attachOtherSpeedBillboard = function(player, character)
    if not player or player == LP or not character then return end

    task.spawn(function()
        local head = character:WaitForChild("Head", 8)
        local root = character:WaitForChild("HumanoidRootPart", 8)
        local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 8)
        if not head or not root or not humanoid then return end

        local old = head:FindFirstChild("SPRITEOtherSpeedBB")
        if old then old:Destroy() end

        local bb = Instance.new("BillboardGui")
        bb.Name = "SPRITEOtherSpeedBB"
        bb.Adornee = head
        bb.Parent = head
        bb.Size = UDim2.new(0, 180, 0, 36)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.MaxDistance = 1000

        local label = Instance.new("TextLabel")
        label.Name = "OtherSpeedBillLbl"
        label.Parent = bb
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "0.0"
        label.TextColor3 = Color3.fromRGB(0, 170, 210)
        label.Font = Enum.Font.GothamBlack
        label.TextScaled = true
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

        State._otherSpeedLabels[player] = {
            label = label,
            root = root,
            humanoid = humanoid,
        }
    end)
end

State._setupOtherPlayerBillboard = function(player)
    if not player or player == LP then return end

    local previousConnection = State._otherSpeedConnections[player]
    if previousConnection then
        pcall(function() previousConnection:Disconnect() end)
    end

    State._otherSpeedConnections[player] = player.CharacterAdded:Connect(function(character)
        State._attachOtherSpeedBillboard(player, character)
    end)

    if player.Character then
        State._attachOtherSpeedBillboard(player, player.Character)
    end
end

task.spawn(function()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        State._setupOtherPlayerBillboard(otherPlayer)
    end
end)

Players.PlayerAdded:Connect(function(player)
    State._setupOtherPlayerBillboard(player)
end)

Players.PlayerRemoving:Connect(function(player)
    local connection = State._otherSpeedConnections[player]
    if connection then pcall(function() connection:Disconnect() end) end
    State._otherSpeedConnections[player] = nil
    State._otherSpeedLabels[player] = nil
end)

task.spawn(function()
    while gui and gui.Parent do
        for player, data in pairs(State._otherSpeedLabels) do
            local label = data and data.label
            local root = data and data.root
            local humanoid = data and data.humanoid

            if player.Parent and label and label.Parent and root and root.Parent and humanoid and humanoid.Health > 0 then
                local velocity = root.AssemblyLinearVelocity
                local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                label.Text = string.format("%.1f", horizontalSpeed)
                label.Visible = true
            elseif label and label.Parent then
                label.Visible = false
            end
        end
        task.wait(0.08)
    end
end)

local h,hrp,speedLbl
local function setupChar(char)
    task.wait(0.1)
    h=char:WaitForChild("Humanoid",5)
    hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end

    restartMovement()

    local head=char:FindFirstChild("Head")
    if head then
        local oldBB=head:FindFirstChild("SpriteSpeedBB"); if oldBB then oldBB:Destroy() end
        local bb=Instance.new("BillboardGui",head); bb.Name="SpriteSpeedBB"
        bb.Size=UDim2.new(0,160,0,24); bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true
        speedLbl=Instance.new("TextLabel",bb); speedLbl.Name="SpeedBillLbl"
        speedLbl.Size=UDim2.new(0,160,0,24); speedLbl.Position=UDim2.new(0,0,0,0); speedLbl.BackgroundTransparency=1
        speedLbl.Text="0.0"; speedLbl.TextColor3=Color3.fromRGB(0, 170, 210)
        speedLbl.Font=Enum.Font.GothamBlack; speedLbl.TextScaled=true
        speedLbl.TextStrokeTransparency=0; speedLbl.TextStrokeColor3=Color3.fromRGB(0, 0, 0)
    end


    if State.unwalkEnabled then task.wait(0.3); startUnwalk() end
    stopAntiRagdoll()
    if State.antiRagdollEnabled then task.wait(0.5); startAntiRagdoll() end

    if State.medusaCounterEnabled then setupMedusaCounter(char) end

    if State.autoBatToggled then stopBatAimbot(); task.wait(0.2); pcall(startBatAimbot) end
    if State.batCounterEnabled then task.wait(0.3); startBatCounter() end
    if Steal.AutoStealEnabled then pcall(stopAutoSteal); task.wait(0.5); pcall(startAutoSteal) end
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end
    local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
end)

-- ============================================================================
--  MOVIMIENTO ESTILO ACE DUELS (Carry Speed)
--  Velocity override directo como Ace: Normal / Carry / Lagger
-- ============================================================================
local moveConn = nil
local speedEnabled = true
local batV2Active = false

local function isRagdollStateLocal(hum)
	if not hum then return true end
	local st = hum:GetState()
	return hum.PlatformStand
		or st == Enum.HumanoidStateType.Physics
		or st == Enum.HumanoidStateType.Ragdoll
		or st == Enum.HumanoidStateType.FallingDown
end

local function getActiveMoveSpeedAce()
	-- Misma lógica que Ace Duels: Lagger > Carry > Normal
	if State.laggerToggled then
		return (laggerPhase == 2) and LS2 or LS
	elseif State.speedToggled then
		return getProfileCarrySpeed()
	else
		return getProfileNormalSpeed()
	end
end

local function startMovement()
	if moveConn then moveConn:Disconnect(); moveConn = nil end
	moveConn = RunService.RenderStepped:Connect(function()
		if not (h and hrp) then return end
		if State._tpInProgress then return end

		pcall(function()
			if speedLbl then
				local hspd = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
				speedLbl.Text = string.format("%.1f", hspd)
			end
		end)

		if not speedEnabled then return end
		if isRagdollStateLocal(h) then
			State.lastMoveDir = Vector3.new(0, 0, 0)
			return
		end

		if State.autoBatToggled or State.autoLeftEnabled or State.autoRightEnabled or batV2Active then
			return
		end

		local md = h.MoveDirection
		local spd = getActiveMoveSpeedAce()

		if md.Magnitude > 0 then
			State.lastMoveDir = md
			hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
		elseif State.antiRagdollEnabled and State.lastMoveDir and State.lastMoveDir.Magnitude > 0 then
			local anyHeld = false
			for key in pairs(MOVE_KEYS) do
				if UIS:IsKeyDown(key) then anyHeld = true; break end
			end
			if anyHeld then
				local dir = State.lastMoveDir
				hrp.Velocity = Vector3.new(dir.X * spd, hrp.Velocity.Y, dir.Z * spd)
			end
		end
	end)
end

local function stopMovement()
	if moveConn then moveConn:Disconnect(); moveConn = nil end
end

local function restartMovement()
	stopMovement()
	startMovement()
end

startMovement()

local oldStartAutoLeft = startAutoLeft
local oldStopAutoLeft = stopAutoLeft
startAutoLeft = function()
	oldStartAutoLeft()
	restartMovement()
end
stopAutoLeft = function()
	oldStopAutoLeft()
	restartMovement()
end

local oldStartAutoRight = startAutoRight
local oldStopAutoRight = stopAutoRight
startAutoRight = function()
	oldStartAutoRight()
	restartMovement()
end
stopAutoRight = function()
	oldStopAutoRight()
	restartMovement()
end

local oldStartBat = startBatAimbot
local oldStopBat = stopBatAimbot
startBatAimbot = function()
	oldStartBat()
	restartMovement()
end
stopBatAimbot = function()
	oldStopBat()
	restartMovement()
end

local oldStartBatV2 = startBatAimbotV2
local oldStopBatV2 = stopBatAimbotV2
startBatAimbotV2 = function()
	batV2Active = true
	oldStartBatV2()
	restartMovement()
end
stopBatAimbotV2 = function()
	batV2Active = false
	oldStopBatV2()
	restartMovement()
end

-- ============================================================================

UIS.InputBegan:Connect(function(inp,gp)
    if _anyKeyListening then return end
    if gp and string.sub(inp.UserInputType.Name, 1, 7) ~= "Gamepad" then return end
    local kc=inp.KeyCode; if kc==Enum.KeyCode.Unknown then return end
    if kbMatch(KB.Speed,kc) then
        State.laggerToggled = false; laggerPhase = 0
        State.speedToggled = not State.speedToggled
        if mobileLaggerSetActive then mobileLaggerSetActive(false) end
        if modeValLbl then modeValLbl.Text = State.speedToggled and "Carry" or "Normal" end
    elseif kbMatch(KB.AutoLeft,kc) then
        State.autoLeftEnabled=not State.autoLeftEnabled
        if State.autoLeftEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoLeftEnabled and State.tpBatEnabled then State._setTPBatEnabled(false) end
        if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(State.autoLeftEnabled) end
    elseif kbMatch(KB.AutoRight,kc) then
        State.autoRightEnabled=not State.autoRightEnabled
        if State.autoRightEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoRightEnabled and State.tpBatEnabled then State._setTPBatEnabled(false) end
        if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(State.autoRightEnabled) end
    elseif kbMatch(KB.Drop,kc) then
        if not State.dropActive then State._manualDropRequest = true; task.spawn(runDrop) end
    elseif kbMatch(KB.TPDown,kc) then
        task.spawn(doTpDown)
    elseif kbMatch(KB.Lagger,kc) then
        if laggerPhase == 1 then
            laggerPhase = 2; State.laggerToggled = true; State.speedToggled = false
            if mobileLaggerSetActive then mobileLaggerSetActive(true) end
            if modeValLbl then modeValLbl.Text = "Lagger 2" end
        else
            laggerPhase = 1; State.laggerToggled = true; State.speedToggled = false
            if mobileSpeedSetActive then mobileSpeedSetActive(false) end
            if mobileLaggerSetActive then mobileLaggerSetActive(true) end
            if modeValLbl then modeValLbl.Text = "Lagger 1" end
        end
    elseif kbMatch(KB.AutoBat,kc) then
        State.autoBatToggled=not State.autoBatToggled
        if State.autoBatToggled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            if State.tpBatEnabled then State._setTPBatEnabled(false) end
            pcall(startBatAimbot)
        else stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
    elseif kbMatch(KB.AutoBatV2,kc) then
        State.autoBatV2Enabled = not State.autoBatV2Enabled
        if State.autoBatV2Enabled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
            if State.tpBatEnabled then State._setTPBatEnabled(false) end
            if startBatAimbotV2 then startBatAimbotV2() end
        else
            if stopBatAimbotV2 then stopBatAimbotV2() end
        end
        if autoBatV2SetVisual then autoBatV2SetVisual(State.autoBatV2Enabled) end
    elseif kbMatch(KB.TPBat,kc) then
        State._setTPBatEnabled(not State.tpBatEnabled)
        if State._tpBatSetVisual then State._tpBatSetVisual(State.tpBatEnabled) end
    elseif kbMatch(KB.InstaReset,kc) then
        task.spawn(cursedInstaReset)
        if btnInstaReset and btnInstaReset.Parent then
            btnInstaReset:SetAttribute("TaupeFlash", true)
            task.delay(0.35, function() if btnInstaReset and btnInstaReset.Parent then btnInstaReset:SetAttribute("TaupeFlash", false) end end)
        end
        if setInstaToggleVisual then
            setInstaToggleVisual(true)
            task.delay(0.2, function() if setInstaToggleVisual then setInstaToggleVisual(false) end end)
        end
    elseif kbMatch(KB.GuiHide,kc) then
        State.guiVisible=not State.guiVisible
        pcall(function() main.Visible=State.guiVisible end)
        pcall(function() mini.Visible=not State.guiVisible end)
    elseif (KB.MusicPC and kbMatch(KB.MusicPC,kc)) or (KB.MusicPad and kbMatch(KB.MusicPad,kc)) then
        pcall(function()
            if _G.NIGHT_musicCycle then _G.NIGHT_musicCycle() end
        end)
        if State.requestConfigSave then State.requestConfigSave() end
    elseif KB.Taunt and kbMatch(KB.Taunt,kc) then
        pcall(function()
            local btn = mobileButtonsByName and mobileButtonsByName["Taunt"]
            if btn then btn:Activate() end
        end)
    end

    if State.requestConfigSave then State.requestConfigSave() end
end)

loadPresetsFile()

task.spawn(function()
    local lastPresetName = loadLastPresetName()
    if lastPresetName and lastPresetName ~= "" then
        for _, preset in ipairs(Presets) do
            if preset.name == lastPresetName then
                pcall(function() applyPreset(preset.data) end)
                break
            end
        end
    end

    task.wait(0.2)
    local loaded = loadConfig()

    -- Ya no forzamos la barra arriba: se puede mover y se guarda la posición.
    -- Si no hay posición guardada, queda en el centro superior por defecto.

    task.wait(0.5)
    if not loaded and State._allowInitialConfigCreation then
        pcall(saveConfig)
    end
end)

Players.LocalPlayer.AncestryChanged:Connect(function(_, parent)
    if parent == nil and State._configLoaded and not State._configLoadFailed then
        if State._configDirty then pcall(saveConfig) end
        if State._positionDirty and State.savePositionBackup then
            pcall(State.savePositionBackup)
        end
    end
end)

pcall(function()
    game:BindToClose(function()
        if State._configLoaded and not State._configLoadFailed then
            if State._configDirty then pcall(saveConfig) end
            if State._positionDirty and State.savePositionBackup then
                pcall(State.savePositionBackup)
            end
        end
    end)
end)

-- ============================================================
--  AUTO CARRY – Monitoreo de velocidad (20-25) con condición de Lagger
-- ============================================================
task.spawn(function()
    while gui and gui.Parent do
        task.wait(0.5)
        if State.autoCarryEnabled and not State.laggerToggled then
            local char = LP.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    local ws = hum.WalkSpeed
                    if ws >= 20 and ws <= 25 and not State.speedToggled then
                        State.speedToggled = true
                        if mobileSpeedSetActive then mobileSpeedSetActive(true) end
                        if modeValLbl then
                            modeValLbl.Text = State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry"
                        end
                    end
                end
            end
        end
    end
end)

-- ===== NUEVAS CASILLAS PARA VELOCIDAD DE BAT V1 Y V2 =====
local batV1SpeedBox = rowInput("Bat Aimbot", "Bat V1 Speed", "Velocidad de persecución", State.batV1Speed, function(v)
	if v > 0 and v <= 500 then
		State.batV1Speed = v
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)

local batV2SpeedBox = rowInput("Bat Aimbot", "Bat V2 Speed", "Velocidad de persecución", State.batV2Speed, function(v)
	if v > 0 and v <= 500 then
		State.batV2Speed = v
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)

print("[Voryx.gg] Loaded!")

end)()
end)()