-- Must Ping Lagger
-- Theme: black & white · Main menu (toggle + keybind + lock) · Settings menu
-- + Backgrounds on both windows · Gallery 2x2 with CLICK-TO-APPLY
-- + V1/V2/V3 presets (same power/delay logic as Cypher Ping Lagger)

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui", 10)
if not plrGui then
	warn("[Must] PlayerGui not found")
	return
end

local CONFIG_FILE = "MustPingLagger_Config.json"

-- ═════════ IMAGE IDS ═════════
local MAIN_BG_ID     = "108138657702122"
local SETTINGS_BG_ID = "116110824615232"
local GALLERY_IDS = {
	"108138657702122",
	"116110824615232",
	"103873496799285",
	"136327879483232",
}

local STRENGTHS = {
	{ name = "Ultra Weak",   power = 5000 },
	{ name = "Extra Weak",   power = 15000 },
	{ name = "Weak",         power = 35000 },
	{ name = "Normal",       power = 100000 },
	{ name = "Strong",       power = 200000 },
	{ name = "Extra Strong", power = 400000 },
	{ name = "Ultra Strong", power = 750000 },
}

-- Same power/delay logic as Cypher Ping Lagger profiles
local PRESETS = {
	V1 = { power = 100000, interval = 0.111 },
	V2 = { power = 97200,  interval = 0.12  },
	V3 = { power = 100000, interval = 0.120 },
}

local DEFAULT_CFG = {
	power        = 100000,
	interval     = 0.111,
	strength     = "Normal",
	preset       = "V1",
	keybindKb    = "F",
	keybindGp    = "ButtonR2",
	autoBrainrot = true,
	uiScale      = 1.0,
	locked       = false,
	posX         = nil,
	posY         = nil,
	setPosX      = nil,
	setPosY      = nil,
	mainBgId     = MAIN_BG_ID,
	settingsBgId = SETTINGS_BG_ID,
}

local cfg = {}
for k, v in pairs(DEFAULT_CFG) do cfg[k] = v end

local function resolveKb(name)
	if not name or name == "" or name == "None" then return nil end
	local ok, val = pcall(function() return Enum.KeyCode[name] end)
	return (ok and val) or nil
end

local function saveConfig()
	if not writefile then return end
	local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
	if ok and encoded then pcall(writefile, CONFIG_FILE, encoded) end
end

local function loadConfig()
	local okLoad = pcall(function()
		if not (type(isfile) == "function" and type(readfile) == "function") then return end
		if not isfile(CONFIG_FILE) then return end
		local raw = readfile(CONFIG_FILE)
		local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
		if not ok or type(data) ~= "table" then return end
		cfg.power        = tonumber(data.power) or DEFAULT_CFG.power
		cfg.interval     = tonumber(data.interval) or DEFAULT_CFG.interval
		cfg.strength     = type(data.strength) == "string" and data.strength or DEFAULT_CFG.strength
		cfg.preset       = (data.preset == "V2" or data.preset == "V3") and data.preset or "V1"
		cfg.keybindKb    = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
		cfg.keybindGp    = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
		if type(data.autoBrainrot) == "boolean" then cfg.autoBrainrot = data.autoBrainrot end
		local sc = tonumber(data.uiScale)
		if sc then cfg.uiScale = math.clamp(sc, 0.5, 1.8) end
		cfg.locked = data.locked == true
		cfg.posX = tonumber(data.posX)
		cfg.posY = tonumber(data.posY)
		cfg.setPosX = tonumber(data.setPosX)
		cfg.setPosY = tonumber(data.setPosY)
		cfg.mainBgId = type(data.mainBgId) == "string" and data.mainBgId or DEFAULT_CFG.mainBgId
		cfg.settingsBgId = type(data.settingsBgId) == "string" and data.settingsBgId or DEFAULT_CFG.settingsBgId
	end)
	if not okLoad then warn("[Must] loadConfig failed") end
end
pcall(loadConfig)

cfg.locked = false -- start unlocked so you can always drag

local active, listeningFor, remote = false, nil, nil
local brainrotMode, lastBrainrotState, manualOverride = false, false, false
local settingsOpen = false

local C = {
	bg      = Color3.fromRGB(8, 8, 8),
	panel   = Color3.fromRGB(18, 18, 18),
	card    = Color3.fromRGB(28, 28, 28),
	input   = Color3.fromRGB(22, 22, 22),
	border  = Color3.fromRGB(75, 75, 75),
	white   = Color3.fromRGB(245, 245, 245),
	soft    = Color3.fromRGB(200, 200, 200),
	dim     = Color3.fromRGB(135, 135, 135),
	black   = Color3.fromRGB(0, 0, 0),
	waiting = Color3.fromRGB(255, 220, 120),
}

for _, n in ipairs({"MustPingLaggerGui", "GalaxyPingLaggerGui"}) do
	local o = plrGui:FindFirstChild(n)
	if o then o:Destroy() end
end

local screen = Instance.new("ScreenGui")
screen.Name = "MustPingLaggerGui"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.DisplayOrder = 999
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Enabled = true

do
	local okParent = false
	if gethui then
		okParent = pcall(function() screen.Parent = gethui() end)
	end
	if not okParent or not screen.Parent then
		okParent = pcall(function() screen.Parent = plrGui end)
	end
	if not okParent or not screen.Parent then
		pcall(function() screen.Parent = game:GetService("CoreGui") end)
	end
	if not screen.Parent then
		warn("[Must] could not parent ScreenGui")
		return
	end
end

local rootScale = Instance.new("UIScale")
rootScale.Name = "RootScale"
rootScale.Scale = math.clamp(tonumber(cfg.uiScale) or 1, 0.5, 1.8)
rootScale.Parent = screen

local function tw(obj, props, t, style)
	TweenService:Create(obj, TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end
local function corner(p, r)
	local c = Instance.new("UICorner", p)
	c.CornerRadius = UDim.new(0, r or 10)
	return c
end
local function stroke(p, col, th, tr)
	local s = Instance.new("UIStroke", p)
	s.Color = col or C.border
	s.Thickness = th or 1.1
	s.Transparency = tr or 0.35
	return s
end
local function grad(p, c1, c2, rot)
	local g = Instance.new("UIGradient", p)
	g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2)})
	g.Rotation = rot or 135
	return g
end

-- creates image background + overlay; returns the ImageLabel so its image can be swapped
local function makeBgImage(parent, id, zIndex, cornerRadius)
	local img = Instance.new("ImageLabel", parent)
	img.Name = "BgImage"
	img.Size = UDim2.fromScale(1, 1)
	img.BackgroundTransparency = 1
	img.Image = "rbxassetid://" .. id
	img.ScaleType = Enum.ScaleType.Crop
	img.ImageTransparency = 0.35
	img.ZIndex = zIndex
	img.Active = false
	corner(img, cornerRadius or 14)

	local overlay = Instance.new("Frame", parent)
	overlay.Name = "BgOverlay"
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.BackgroundColor3 = C.bg
	overlay.BackgroundTransparency = 0.55
	overlay.BorderSizePixel = 0
	overlay.ZIndex = zIndex + 1
	overlay.Active = false -- no bloquear clics de botones/toggle
	corner(overlay, cornerRadius or 14)
	return img
end

local function makeDraggable(frame, handle, saveFn)
	handle = handle or frame
	local dragging, start, startPos
	handle.InputBegan:Connect(function(input)
		if cfg.locked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			start = input.Position
			startPos = frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - start
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			if saveFn then saveFn(frame.Position) end
		end
	end)
end

local function bindTap(btn, fn)
	btn.Active = true
	btn.Selectable = true
	local last = 0
	local function fire()
		local now = os.clock()
		if now - last < 0.2 then return end
		last = now
		local ok, err = pcall(fn)
		if not ok then warn("[Must] bindTap error:", err) end
	end
	-- Activated cubre mouse + touch en la mayoría de clientes
	btn.Activated:Connect(fire)
	btn.MouseButton1Click:Connect(fire)
end

local function isGamepad(kc)
	local n = kc.Name
	return n:sub(1,6)=="Button" or n:sub(1,10)=="Thumbstick" or n:sub(1,4)=="DPad" or n=="ButtonSelect" or n=="ButtonStart"
end

local BLACKLISTED = {
	[Enum.KeyCode.Escape] = true,
	[Enum.KeyCode.LeftControl] = true,
	[Enum.KeyCode.Unknown] = true,
}

local function makeToggle()
	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromOffset(44, 22)
	bg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	bg.BorderSizePixel = 0
	bg.Active = true
	corner(bg, 11)
	stroke(bg, C.border, 1, 0.5)

	local knob = Instance.new("Frame", bg)
	knob.Size = UDim2.fromOffset(18, 18)
	knob.Position = UDim2.fromOffset(2, 2)
	knob.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
	knob.BorderSizePixel = 0
	knob.Active = false
	knob.ZIndex = 2
	corner(knob, 9)

	local btn = Instance.new("TextButton", bg)
	btn.Name = "ToggleBtn"
	btn.Size = UDim2.fromScale(1, 1)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Active = true
	btn.ZIndex = 5

	local function set(v)
		local pos = v and UDim2.fromOffset(24, 2) or UDim2.fromOffset(2, 2)
		local bgc = v and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(50, 50, 50)
		local knc = v and Color3.fromRGB(20, 20, 20)   or Color3.fromRGB(225, 225, 225)
		tw(knob, {Position = pos, BackgroundColor3 = knc}, 0.15)
		tw(bg,   {BackgroundColor3 = bgc}, 0.15)
	end

	return {set = set, frame = bg, btn = btn}
end

local toggleUI = nil
local kbBindMain = nil
local lockBtnMain = nil
local mainBgImg = nil
local settingsBgImg = nil

-- ═════════ MAIN WINDOW ═════════
local MAIN_W, MAIN_H = 220, 148

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(MAIN_W, MAIN_H)
do
	local cam = workspace.CurrentCamera
	local vs = cam and cam.ViewportSize or Vector2.new(800, 600)
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local useSaved = cfg.posX and cfg.posY and not isMobile
		and cfg.posX > -50 and cfg.posY > -50
		and cfg.posX < vs.X - 40 and cfg.posY < vs.Y - 40
	if useSaved then
		main.Position = UDim2.fromOffset(cfg.posX, cfg.posY)
	else
		main.Position = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
	end
end
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.Parent = screen
corner(main, 14)
stroke(main, C.border, 1.2, 0.25)
grad(main, C.bg, Color3.fromRGB(28, 28, 28), 150)

mainBgImg = makeBgImage(main, cfg.mainBgId, 1, 14)

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 34)
header.BackgroundColor3 = C.panel
header.BorderSizePixel = 0
header.Active = true
header.ZIndex = 3
corner(header, 14)
grad(header, Color3.fromRGB(35, 35, 35), Color3.fromRGB(10, 10, 10), 120)

local headerFill = Instance.new("Frame", main)
headerFill.Size = UDim2.new(1, 0, 0, 10)
headerFill.Position = UDim2.fromOffset(0, 24)
headerFill.BackgroundColor3 = C.panel
headerFill.BorderSizePixel = 0
headerFill.Active = false
headerFill.ZIndex = 3
grad(headerFill, Color3.fromRGB(35, 35, 35), Color3.fromRGB(10, 10, 10), 120)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "MUST PING LAGGER"
title.TextColor3 = C.white
title.Font = Enum.Font.GothamBlack
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 4
title.Active = false
title.Selectable = false

local settingsBtn = Instance.new("TextButton", header)
settingsBtn.Size = UDim2.fromOffset(22, 22)
settingsBtn.Position = UDim2.new(1, -28, 0.5, -11)
settingsBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
settingsBtn.Text = "⚙"
settingsBtn.TextColor3 = C.white
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 12
settingsBtn.AutoButtonColor = false
settingsBtn.ZIndex = 5
corner(settingsBtn, 6)
stroke(settingsBtn, C.border, 1, 0.5)

makeDraggable(main, header, function(p)
	cfg.posX = p.X.Offset
	cfg.posY = p.Y.Offset
	saveConfig()
end)

local row1Lbl = Instance.new("TextLabel", main)
row1Lbl.Size = UDim2.new(0.5, 0, 0, 30)
row1Lbl.Position = UDim2.fromOffset(14, 38)
row1Lbl.BackgroundTransparency = 1
row1Lbl.Text = "Ping Lagger"
row1Lbl.TextColor3 = C.white
row1Lbl.Font = Enum.Font.GothamBold
row1Lbl.TextSize = 13
row1Lbl.TextXAlignment = Enum.TextXAlignment.Left
row1Lbl.ZIndex = 4
row1Lbl.Active = false
row1Lbl.Selectable = false

toggleUI = makeToggle()
toggleUI.frame.Parent = main
toggleUI.frame.Position = UDim2.new(1, -58, 0, 42)
toggleUI.frame.ZIndex = 10

local row2Lbl = Instance.new("TextLabel", main)
row2Lbl.Size = UDim2.new(0.5, 0, 0, 30)
row2Lbl.Position = UDim2.fromOffset(14, 72)
row2Lbl.BackgroundTransparency = 1
row2Lbl.Text = "Keybind"
row2Lbl.TextColor3 = C.white
row2Lbl.Font = Enum.Font.GothamBold
row2Lbl.TextSize = 13
row2Lbl.TextXAlignment = Enum.TextXAlignment.Left
row2Lbl.ZIndex = 4
row2Lbl.Active = false
row2Lbl.Selectable = false

kbBindMain = Instance.new("TextButton", main)
kbBindMain.Size = UDim2.fromOffset(78, 26)
kbBindMain.Position = UDim2.new(1, -90, 0, 74)
kbBindMain.BackgroundColor3 = C.input
kbBindMain.BorderSizePixel = 0
kbBindMain.Text = cfg.keybindKb
kbBindMain.TextColor3 = C.white
kbBindMain.Font = Enum.Font.GothamBold
kbBindMain.TextSize = 12
kbBindMain.AutoButtonColor = false
kbBindMain.Active = true
kbBindMain.ZIndex = 10
corner(kbBindMain, 8)
stroke(kbBindMain, C.border, 1, 0.35)

local row3Lbl = Instance.new("TextLabel", main)
row3Lbl.Size = UDim2.new(0.5, 0, 0, 30)
row3Lbl.Position = UDim2.fromOffset(14, 106)
row3Lbl.BackgroundTransparency = 1
row3Lbl.Text = "Lock"
row3Lbl.TextColor3 = C.white
row3Lbl.Font = Enum.Font.GothamBold
row3Lbl.TextSize = 13
row3Lbl.TextXAlignment = Enum.TextXAlignment.Left
row3Lbl.ZIndex = 4
row3Lbl.Active = false
row3Lbl.Selectable = false

lockBtnMain = Instance.new("TextButton", main)
lockBtnMain.Size = UDim2.fromOffset(78, 26)
lockBtnMain.Position = UDim2.new(1, -90, 0, 108)
lockBtnMain.BackgroundColor3 = C.input
lockBtnMain.BorderSizePixel = 0
lockBtnMain.Text = cfg.locked and "Unlock" or "Lock"
lockBtnMain.TextColor3 = C.white
lockBtnMain.Font = Enum.Font.GothamBold
lockBtnMain.TextSize = 12
lockBtnMain.AutoButtonColor = false
lockBtnMain.Active = true
lockBtnMain.ZIndex = 10
corner(lockBtnMain, 8)
stroke(lockBtnMain, C.border, 1, 0.35)

bindTap(lockBtnMain, function()
	cfg.locked = not cfg.locked
	lockBtnMain.Text = cfg.locked and "Unlock" or "Lock"
	saveConfig()
end)

-- ═════════ SETTINGS WINDOW ═════════
local SET_W, SET_H = 230, 305

local settings = Instance.new("Frame")
settings.Name = "Settings"
settings.Size = UDim2.fromOffset(SET_W, SET_H)
do
	local cam = workspace.CurrentCamera
	local vs = cam and cam.ViewportSize or Vector2.new(800, 600)
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local useSaved = cfg.setPosX and cfg.setPosY and not isMobile
		and cfg.setPosX > -50 and cfg.setPosY > -50
		and cfg.setPosX < vs.X - 40 and cfg.setPosY < vs.Y - 40
	if useSaved then
		settings.Position = UDim2.fromOffset(cfg.setPosX, cfg.setPosY)
	else
		settings.Position = UDim2.new(0.5, -SET_W/2, 0.5, -SET_H/2 + 40)
	end
end
settings.BackgroundColor3 = C.panel
settings.BorderSizePixel = 0
settings.Visible = false
settings.Active = true
settings.ZIndex = 30
settings.ClipsDescendants = true
settings.Parent = screen
corner(settings, 14)
stroke(settings, C.border, 1.3, 0.25)
grad(settings, C.panel, Color3.fromRGB(10, 10, 10), 160)

settingsBgImg = makeBgImage(settings, cfg.settingsBgId, 29, 14)

local setHeader = Instance.new("Frame", settings)
setHeader.Size = UDim2.new(1, 0, 0, 34)
setHeader.BackgroundColor3 = C.panel
setHeader.BorderSizePixel = 0
setHeader.Active = true
setHeader.ZIndex = 31
corner(setHeader, 14)
grad(setHeader, Color3.fromRGB(35, 35, 35), Color3.fromRGB(10, 10, 10), 120)

local setHeaderFill = Instance.new("Frame", settings)
setHeaderFill.Size = UDim2.new(1, 0, 0, 10)
setHeaderFill.Position = UDim2.fromOffset(0, 24)
setHeaderFill.BackgroundColor3 = C.panel
setHeaderFill.BorderSizePixel = 0
setHeaderFill.Active = false
setHeaderFill.ZIndex = 31
grad(setHeaderFill, Color3.fromRGB(35, 35, 35), Color3.fromRGB(10, 10, 10), 120)

local setTitle = Instance.new("TextLabel", setHeader)
setTitle.Size = UDim2.new(1, -40, 1, 0)
setTitle.Position = UDim2.fromOffset(12, 0)
setTitle.BackgroundTransparency = 1
setTitle.Text = "SETTINGS"
setTitle.TextColor3 = C.white
setTitle.Font = Enum.Font.GothamBlack
setTitle.TextSize = 13
setTitle.TextXAlignment = Enum.TextXAlignment.Left
setTitle.ZIndex = 32
setTitle.Active = false
setTitle.Selectable = false

local setClose = Instance.new("TextButton", setHeader)
setClose.Size = UDim2.fromOffset(24, 24)
setClose.Position = UDim2.new(1, -30, 0.5, -12)
setClose.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
setClose.Text = "X"
setClose.TextColor3 = C.white
setClose.Font = Enum.Font.GothamBold
setClose.TextSize = 12
setClose.AutoButtonColor = false
setClose.ZIndex = 32
corner(setClose, 6)
stroke(setClose, C.border, 1, 0.4)

makeDraggable(settings, setHeader, function(p)
	cfg.setPosX = p.X.Offset
	cfg.setPosY = p.Y.Offset
	saveConfig()
end)

local scroll = Instance.new("ScrollingFrame", settings)
scroll.Size = UDim2.new(1, -16, 1, -48)
scroll.Position = UDim2.fromOffset(8, 42)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = C.soft
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.ZIndex = 31

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 7)
list.SortOrder = Enum.SortOrder.LayoutOrder

local pad = Instance.new("UIPadding", scroll)
pad.PaddingBottom = UDim.new(0, 10)
pad.PaddingTop = UDim.new(0, 2)

local function mkRow(height)
	local row = Instance.new("Frame", scroll)
	row.Size = UDim2.new(1, -4, 0, height or 36)
	row.BackgroundColor3 = C.card
	row.BackgroundTransparency = 0.1
	row.BorderSizePixel = 0
	row.ZIndex = 32
	corner(row, 9)
	stroke(row, C.border, 1, 0.55)
	return row
end

local function mkLabel(parent, text, x, w)
	local l = Instance.new("TextLabel", parent)
	l.Size = UDim2.new(w or 0.45, 0, 1, 0)
	l.Position = UDim2.fromOffset(x or 10, 0)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = C.white
	l.Font = Enum.Font.GothamBold
	l.TextSize = 11
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.ZIndex = 33
	l.Active = false
	l.Selectable = false
	return l
end

local presetRow = Instance.new("Frame", scroll)
presetRow.Size = UDim2.new(1, -4, 0, 30)
presetRow.BackgroundTransparency = 1
presetRow.LayoutOrder = 1
presetRow.ZIndex = 32

local presetBtns = {}
local function makePreset(name, order)
	local b = Instance.new("TextButton", presetRow)
	b.Size = UDim2.new(1/3, -4, 1, 0)
	b.Position = UDim2.new((order-1)/3, 2, 0, 0)
	b.BackgroundColor3 = C.card
	b.BackgroundTransparency = 0.1
	b.BorderSizePixel = 0
	b.Text = name
	b.TextColor3 = C.dim
	b.Font = Enum.Font.GothamBlack
	b.TextSize = 11
	b.AutoButtonColor = false
	b.ZIndex = 33
	corner(b, 8)
	stroke(b, C.border, 1, 0.5)
	presetBtns[name] = b
	return b
end
makePreset("V1", 1)
makePreset("V2", 2)
makePreset("V3", 3)

local powerRow = mkRow(36)
powerRow.LayoutOrder = 2
mkLabel(powerRow, "Power")
local powerBox = Instance.new("TextBox", powerRow)
powerBox.Size = UDim2.fromOffset(90, 24)
powerBox.Position = UDim2.new(1, -100, 0.5, -12)
powerBox.BackgroundColor3 = C.input
powerBox.BorderSizePixel = 0
powerBox.Text = tostring(cfg.power)
powerBox.TextColor3 = C.white
powerBox.Font = Enum.Font.GothamBold
powerBox.TextSize = 12
powerBox.ClearTextOnFocus = false
powerBox.ZIndex = 33
corner(powerBox, 7)
stroke(powerBox, C.border, 1, 0.45)

local delayRow = mkRow(36)
delayRow.LayoutOrder = 3
mkLabel(delayRow, "Delay (secs)")
local delayBox = Instance.new("TextBox", delayRow)
delayBox.Size = UDim2.fromOffset(90, 24)
delayBox.Position = UDim2.new(1, -100, 0.5, -12)
delayBox.BackgroundColor3 = C.input
delayBox.BorderSizePixel = 0
delayBox.Text = tostring(cfg.interval)
delayBox.TextColor3 = C.white
delayBox.Font = Enum.Font.GothamBold
delayBox.TextSize = 12
delayBox.ClearTextOnFocus = false
delayBox.ZIndex = 33
corner(delayBox, 7)
stroke(delayBox, C.border, 1, 0.45)

local brRow = mkRow(36)
brRow.LayoutOrder = 4
mkLabel(brRow, "Auto Brainrot", 10, 0.65)
local brBtn = Instance.new("TextButton", brRow)
brBtn.Size = UDim2.fromOffset(52, 24)
brBtn.Position = UDim2.new(1, -62, 0.5, -12)
brBtn.BackgroundColor3 = cfg.autoBrainrot and C.white or Color3.fromRGB(45, 45, 45)
brBtn.BorderSizePixel = 0
brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
brBtn.TextColor3 = cfg.autoBrainrot and C.black or C.dim
brBtn.Font = Enum.Font.GothamBlack
brBtn.TextSize = 11
brBtn.AutoButtonColor = false
brBtn.ZIndex = 33
corner(brBtn, 12)
stroke(brBtn, C.border, 1, 0.4)

local scaleRow = mkRow(36)
scaleRow.LayoutOrder = 5
mkLabel(scaleRow, "UI Scale", 10, 0.4)
local scaleMinus = Instance.new("TextButton", scaleRow)
scaleMinus.Size = UDim2.fromOffset(28, 24)
scaleMinus.Position = UDim2.new(1, -120, 0.5, -12)
scaleMinus.BackgroundColor3 = C.input
scaleMinus.Text = "−"
scaleMinus.TextColor3 = C.white
scaleMinus.Font = Enum.Font.GothamBold
scaleMinus.TextSize = 16
scaleMinus.AutoButtonColor = false
scaleMinus.ZIndex = 33
corner(scaleMinus, 7)
stroke(scaleMinus, C.border, 1, 0.45)

local scaleLbl = Instance.new("TextLabel", scaleRow)
scaleLbl.Size = UDim2.fromOffset(48, 24)
scaleLbl.Position = UDim2.new(1, -88, 0.5, -12)
scaleLbl.BackgroundColor3 = C.input
scaleLbl.Text = string.format("%.1f", cfg.uiScale)
scaleLbl.TextColor3 = C.white
scaleLbl.Font = Enum.Font.GothamBold
scaleLbl.TextSize = 12
scaleLbl.ZIndex = 33
scaleLbl.Active = false
scaleLbl.Selectable = false
corner(scaleLbl, 7)
stroke(scaleLbl, C.border, 1, 0.45)

local scalePlus = Instance.new("TextButton", scaleRow)
scalePlus.Size = UDim2.fromOffset(28, 24)
scalePlus.Position = UDim2.new(1, -36, 0.5, -12)
scalePlus.BackgroundColor3 = C.input
scalePlus.Text = "+"
scalePlus.TextColor3 = C.white
scalePlus.Font = Enum.Font.GothamBold
scalePlus.TextSize = 16
scalePlus.AutoButtonColor = false
scalePlus.ZIndex = 33
corner(scalePlus, 7)
stroke(scalePlus, C.border, 1, 0.45)

local gpRow = mkRow(36)
gpRow.LayoutOrder = 6
mkLabel(gpRow, "Controller", 10, 0.4)
local gpBind = Instance.new("TextButton", gpRow)
gpBind.Size = UDim2.fromOffset(80, 24)
gpBind.Position = UDim2.new(1, -118, 0.5, -12)
gpBind.BackgroundColor3 = C.input
gpBind.Text = cfg.keybindGp
gpBind.TextColor3 = C.white
gpBind.Font = Enum.Font.GothamBold
gpBind.TextSize = 10
gpBind.AutoButtonColor = false
gpBind.ZIndex = 33
corner(gpBind, 7)
stroke(gpBind, C.border, 1, 0.5)

local gpClear = Instance.new("TextButton", gpRow)
gpClear.Size = UDim2.fromOffset(24, 24)
gpClear.Position = UDim2.new(1, -32, 0.5, -12)
gpClear.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
gpClear.Text = "X"
gpClear.TextColor3 = C.white
gpClear.Font = Enum.Font.GothamBlack
gpClear.TextSize = 11
gpClear.AutoButtonColor = false
gpClear.ZIndex = 33
corner(gpClear, 7)
stroke(gpClear, C.border, 1, 0.5)

-- ═════════ GALLERY (click-to-apply) ═════════
local galleryThumbs = {}
local applyTarget = "main" -- "main" | "settings"

local function updateGalleryHighlight()
	for i, thumb in ipairs(galleryThumbs) do
		local id = GALLERY_IDS[i]
		local marks = {}
		if id == cfg.mainBgId then table.insert(marks, "M") end
		if id == cfg.settingsBgId then table.insert(marks, "S") end
		local ind = thumb:FindFirstChild("Indicator")
		if ind then ind.Text = table.concat(marks, " ") end
	end
end

local galleryHeader = Instance.new("TextLabel", scroll)
galleryHeader.Size = UDim2.new(1, -4, 0, 18)
galleryHeader.BackgroundTransparency = 1
galleryHeader.Text = "GALLERY  ·  click a picture to apply it"
galleryHeader.TextColor3 = C.dim
galleryHeader.Font = Enum.Font.GothamBold
galleryHeader.TextSize = 9
galleryHeader.TextXAlignment = Enum.TextXAlignment.Left
galleryHeader.LayoutOrder = 7
galleryHeader.ZIndex = 32
galleryHeader.Active = false
galleryHeader.Selectable = false

local targetRow = Instance.new("Frame", scroll)
targetRow.Size = UDim2.new(1, -4, 0, 26)
targetRow.BackgroundTransparency = 1
targetRow.LayoutOrder = 8
targetRow.ZIndex = 32

local mainTargetBtn = Instance.new("TextButton", targetRow)
mainTargetBtn.Size = UDim2.new(0.5, -3, 1, 0)
mainTargetBtn.Position = UDim2.fromOffset(0, 0)
mainTargetBtn.BackgroundColor3 = C.white
mainTargetBtn.BorderSizePixel = 0
mainTargetBtn.Text = "→ MAIN"
mainTargetBtn.TextColor3 = C.black
mainTargetBtn.Font = Enum.Font.GothamBlack
mainTargetBtn.TextSize = 11
mainTargetBtn.AutoButtonColor = false
mainTargetBtn.ZIndex = 33
corner(mainTargetBtn, 8)

local setTargetBtn = Instance.new("TextButton", targetRow)
setTargetBtn.Size = UDim2.new(0.5, -3, 1, 0)
setTargetBtn.Position = UDim2.new(0.5, 3, 0, 0)
setTargetBtn.BackgroundColor3 = C.card
setTargetBtn.BackgroundTransparency = 0.1
setTargetBtn.BorderSizePixel = 0
setTargetBtn.Text = "→ SETTINGS"
setTargetBtn.TextColor3 = C.dim
setTargetBtn.Font = Enum.Font.GothamBlack
setTargetBtn.TextSize = 11
setTargetBtn.AutoButtonColor = false
setTargetBtn.ZIndex = 33
corner(setTargetBtn, 8)
stroke(setTargetBtn, C.border, 1, 0.5)

local function updateTargetBtns()
	if applyTarget == "main" then
		mainTargetBtn.BackgroundColor3 = C.white
		mainTargetBtn.TextColor3 = C.black
		setTargetBtn.BackgroundColor3 = C.card
		setTargetBtn.TextColor3 = C.dim
	else
		mainTargetBtn.BackgroundColor3 = C.card
		mainTargetBtn.TextColor3 = C.dim
		setTargetBtn.BackgroundColor3 = C.white
		setTargetBtn.TextColor3 = C.black
	end
	updateGalleryHighlight()
end

bindTap(mainTargetBtn, function() applyTarget = "main";     updateTargetBtns() end)
bindTap(setTargetBtn,  function() applyTarget = "settings"; updateTargetBtns() end)

local galleryRow = Instance.new("Frame", scroll)
galleryRow.Size = UDim2.new(1, -4, 0, 170)
galleryRow.BackgroundTransparency = 1
galleryRow.LayoutOrder = 9
galleryRow.ZIndex = 32

for i, id in ipairs(GALLERY_IDS) do
	local col = (i - 1) % 2
	local rowIdx = math.floor((i - 1) / 2)
	local thumb = Instance.new("ImageLabel", galleryRow)
	thumb.Name = "Gallery" .. i
	thumb.Size = UDim2.new(0.5, -4, 0.5, -4)
	thumb.Position = UDim2.new(col * 0.5, 2, rowIdx * 0.5, 2)
	thumb.BackgroundColor3 = C.card
	thumb.BorderSizePixel = 0
	thumb.Image = "rbxassetid://" .. id
	thumb.ScaleType = Enum.ScaleType.Crop
	thumb.ZIndex = 33
	thumb.Active = true
	corner(thumb, 8)
	stroke(thumb, C.border, 1, 0.4)

	local indicator = Instance.new("TextLabel", thumb)
	indicator.Name = "Indicator"
	indicator.Size = UDim2.fromOffset(30, 16)
	indicator.Position = UDim2.fromOffset(4, 4)
	indicator.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	indicator.BackgroundTransparency = 0.15
	indicator.Text = ""
	indicator.TextColor3 = C.white
	indicator.Font = Enum.Font.GothamBlack
	indicator.TextSize = 10
	indicator.ZIndex = 35
	indicator.Active = false
	indicator.Selectable = false
	corner(indicator, 4)

	galleryThumbs[i] = thumb

	bindTap(thumb, function()
		if applyTarget == "main" then
			cfg.mainBgId = id
			mainBgImg.Image = "rbxassetid://" .. id
		else
			cfg.settingsBgId = id
			settingsBgImg.Image = "rbxassetid://" .. id
		end
		saveConfig()
		updateGalleryHighlight()
	end)
end

updateTargetBtns()

-- ═════════ LOGIC (idéntica a Cypher Ping Lagger) ═════════
local pingLoopRunning = false

local function setUIActive(on)
	if toggleUI then toggleUI.set(on) end
end

local function findRemote()
	local rrs = game:FindFirstChild("RobloxReplicatedStorage")
	if not rrs then return nil end
	local found = nil
	for _, name in ipairs({"SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList"}) do
		local r = rrs:FindFirstChild(name)
		if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent") or r:IsA("RemoteFunction")) then
			found = r
			break
		end
	end
	if not found then
		for _, c in ipairs(rrs:GetChildren()) do
			if (c:IsA("RemoteEvent") or c:IsA("UnreliableRemoteEvent") or c:IsA("RemoteFunction")) and c.Name:find("Block") then
				found = c
				break
			end
		end
	end
	return found
end

remote = findRemote()

local function buildPayload(power)
	local safePower = tonumber(power) or DEFAULT_CFG.power
	if safePower < 1 then safePower = 1 end
	local main = {}
	local nested = {{}}
	local current = nested[1]
	for _ = 1, 186 do
		local n = {}
		table.insert(current, n)
		current = n
	end
	local maxRep = math.min(math.floor(safePower / 188), 10000)
	if maxRep < 1 then maxRep = 1 end
	for _ = 1, maxRep do
		table.insert(main, nested)
	end
	return main
end

local function runPingLoop()
	if not active or not remote then
		pingLoopRunning = false
		return
	end
	pingLoopRunning = true
	local currentDelay = tonumber(cfg.interval) or DEFAULT_CFG.interval
	while active and remote and pingLoopRunning do
		local payload = buildPayload(cfg.power)
		local ok = pcall(function()
			if remote:IsA("RemoteFunction") then
				remote:InvokeServer(payload)
			else
				remote:FireServer(payload)
			end
		end)
		if not ok then
			currentDelay = math.min(currentDelay * 1.5, 0.5)
		else
			currentDelay = math.max(currentDelay * 0.995, 0.05)
		end
		task.wait(currentDelay)
	end
	pingLoopRunning = false
end

local function flipLag(state, isManual)
	if not state and pingLoopRunning then
		pingLoopRunning = false
	end
	active = state
	if isManual then
		if brainrotMode then
			manualOverride = not state
		else
			manualOverride = false
		end
	end
	if active then
		if not remote then
			remote = findRemote()
			if not remote then
				active = false
				setUIActive(false)
				return
			end
		end
		setUIActive(true)
		task.spawn(runPingLoop)
	else
		setUIActive(false)
	end
end

-- Conexión del toggle IGUAL que activateBtn del Cypher (MouseButton1Click directo)
if toggleUI and toggleUI.btn then
	toggleUI.btn.MouseButton1Click:Connect(function()
		flipLag(not active, true)
	end)
end

local function applyPreset(name)
	local p = PRESETS[name]
	if not p then return end
	cfg.preset = name
	cfg.power = p.power
	cfg.interval = p.interval
	powerBox.Text = tostring(cfg.power)
	delayBox.Text = tostring(cfg.interval)
	local best, bestDiff = "Normal", math.huge
	for _, s in ipairs(STRENGTHS) do
		local d = math.abs(s.power - p.power)
		if d < bestDiff then bestDiff, best = d, s.name end
	end
	cfg.strength = best
	for n, b in pairs(presetBtns) do
		if n == name then
			b.BackgroundColor3 = C.white
			b.TextColor3 = C.black
		else
			b.BackgroundColor3 = C.card
			b.TextColor3 = C.dim
		end
	end
	saveConfig()
end

for name, b in pairs(presetBtns) do
	bindTap(b, function() applyPreset(name) end)
end

-- Highlight saved/default preset on load (same power logic as Cypher V1/V2/V3)
do
	local selected = (cfg.preset == "V2" or cfg.preset == "V3") and cfg.preset or "V1"
	if PRESETS[selected] then
		cfg.power = PRESETS[selected].power
		cfg.interval = PRESETS[selected].interval
		cfg.preset = selected
		if powerBox then powerBox.Text = tostring(cfg.power) end
		if delayBox then delayBox.Text = tostring(cfg.interval) end
		for n, b in pairs(presetBtns) do
			if n == selected then
				b.BackgroundColor3 = C.white
				b.TextColor3 = C.black
			else
				b.BackgroundColor3 = C.card
				b.TextColor3 = C.dim
			end
		end
	end
end

local function openSettings()
	settingsOpen = true
	settings.Visible = true
	settings.Size = UDim2.fromOffset(SET_W, 0)
	tw(settings, {Size = UDim2.fromOffset(SET_W, SET_H)}, 0.2, Enum.EasingStyle.Back)
	powerBox.Text = tostring(cfg.power)
	delayBox.Text = tostring(cfg.interval)
	brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
	brBtn.BackgroundColor3 = cfg.autoBrainrot and C.white or Color3.fromRGB(45, 45, 45)
	brBtn.TextColor3 = cfg.autoBrainrot and C.black or C.dim
	scaleLbl.Text = string.format("%.1f", cfg.uiScale)
	gpBind.Text = cfg.keybindGp
end

local function closeSettings()
	settingsOpen = false
	listeningFor = nil
	tw(settings, {Size = UDim2.fromOffset(SET_W, 0)}, 0.15)
	task.delay(0.16, function() settings.Visible = false end)
	updateBindLabels()
end

bindTap(settingsBtn, function()
	if settingsOpen then closeSettings() else openSettings() end
end)
bindTap(setClose, closeSettings)

powerBox.FocusLost:Connect(function()
	local n = tonumber(powerBox.Text)
	if n and n >= 1 then
		cfg.power = math.floor(n)
		powerBox.Text = tostring(cfg.power)
		saveConfig()
	else
		powerBox.Text = tostring(cfg.power)
	end
end)

delayBox.FocusLost:Connect(function()
	local n = tonumber(delayBox.Text)
	if n and n >= 0.01 then
		cfg.interval = n
		delayBox.Text = tostring(cfg.interval)
		saveConfig()
	else
		delayBox.Text = tostring(cfg.interval)
	end
end)

bindTap(brBtn, function()
	cfg.autoBrainrot = not cfg.autoBrainrot
	brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
	brBtn.TextColor3 = cfg.autoBrainrot and C.black or C.dim
	tw(brBtn, {BackgroundColor3 = cfg.autoBrainrot and C.white or Color3.fromRGB(45, 45, 45)}, 0.12)
	saveConfig()
end)

local function setScale(v)
	cfg.uiScale = math.clamp(math.floor(v * 10 + 0.5) / 10, 0.5, 1.8)
	rootScale.Scale = cfg.uiScale
	scaleLbl.Text = string.format("%.1f", cfg.uiScale)
	saveConfig()
end
bindTap(scaleMinus, function() setScale(cfg.uiScale - 0.1) end)
bindTap(scalePlus,  function() setScale(cfg.uiScale + 0.1) end)

function updateBindLabels()
	local mainTxt, mainCol
	if listeningFor == "kb" then
		mainTxt, mainCol = "...", C.waiting
	else
		mainTxt, mainCol = cfg.keybindKb, C.white
	end
	if kbBindMain then
		kbBindMain.Text = mainTxt
		kbBindMain.TextColor3 = mainCol
	end
	if gpBind then
		if listeningFor == "gp" then
			gpBind.Text, gpBind.TextColor3 = "...", C.waiting
		else
			gpBind.Text, gpBind.TextColor3 = cfg.keybindGp, C.white
		end
	end
end

bindTap(kbBindMain, function()
	listeningFor = (listeningFor == "kb") and nil or "kb"
	updateBindLabels()
end)

gpBind.MouseButton1Click:Connect(function()
	listeningFor = (listeningFor == "gp") and nil or "gp"
	updateBindLabels()
end)
gpClear.MouseButton1Click:Connect(function()
	cfg.keybindGp = "None"
	listeningFor = nil
	updateBindLabels()
	saveConfig()
end)

RunService.Heartbeat:Connect(function()
	if not cfg.autoBrainrot then
		if brainrotMode then
			brainrotMode = false
			lastBrainrotState = false
		end
		return
	end
	local char = plr.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local hasBrainrot = hum.WalkSpeed < 25
	if hasBrainrot and not lastBrainrotState then
		brainrotMode = true
		lastBrainrotState = true
		manualOverride = false
		flipLag(true)
	elseif not hasBrainrot and lastBrainrotState then
		brainrotMode = false
		lastBrainrotState = false
		manualOverride = false
		flipLag(false)
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	local kc = input.KeyCode
	if kc == Enum.KeyCode.Unknown then return end
	local isGp = isGamepad(kc)
	local isKb = input.UserInputType == Enum.UserInputType.Keyboard

	if listeningFor then
		if kc == Enum.KeyCode.Escape then
			listeningFor = nil
			updateBindLabels()
			return
		end
		if listeningFor == "kb" and isKb and not BLACKLISTED[kc] then
			cfg.keybindKb = kc.Name
			listeningFor = nil
			updateBindLabels()
			saveConfig()
			return
		end
		if listeningFor == "gp" and isGp then
			cfg.keybindGp = kc.Name
			listeningFor = nil
			updateBindLabels()
			saveConfig()
			return
		end
		return
	end

	if processed then return end

	if kc == Enum.KeyCode.LeftControl then
		main.Visible = not main.Visible
		if not main.Visible then closeSettings() end
		return
	end

	local kbEnum = resolveKb(cfg.keybindKb)
	local gpEnum = resolveKb(cfg.keybindGp)
	if (kbEnum and kc == kbEnum and isKb) or (gpEnum and kc == gpEnum and isGp) then
		flipLag(not active, true)
	end
end)

local pill = Instance.new("TextButton")
pill.Name = "MustReopen"
pill.Size = UDim2.fromOffset(130, 36)
pill.Position = UDim2.new(0.5, -65, 1, -90)
pill.BackgroundColor3 = C.bg
pill.BorderSizePixel = 0
pill.Text = "Must Lagger"
pill.TextColor3 = C.white
pill.Font = Enum.Font.GothamBlack
pill.TextSize = 12
pill.Visible = false
pill.ZIndex = 100
pill.Parent = screen
corner(pill, 12)
stroke(pill, C.border, 1.2, 0.3)

pill.MouseButton1Click:Connect(function()
	main.Visible = true
	pill.Visible = false
	main.Position = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
end)

main:GetPropertyChangedSignal("Visible"):Connect(function()
	pill.Visible = not main.Visible
end)

updateBindLabels()
setUIActive(false)
main.Visible = true
screen.Enabled = true
print("[Must Ping Lagger] loaded · click gallery images to apply")

-- ═════════ HEAD TAG ═════════
local TAG_TEXT_1 = "leak by Demi"
local TAG_TEXT_2 = "https://discord.gg/prd62mBg5"
local TAG_COLOR_1 = Color3.fromRGB(255, 255, 255)
local TAG_COLOR_2 = Color3.fromRGB(200, 200, 200)
local TAG_SIG = "Demi#" .. tostring(math.random(100000, 999999))

local function attachHeadTag(char)
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end
	local old = head:FindFirstChild("LeakByDemiTag")
	if old then old:Destroy() end

	local bb = Instance.new("BillboardGui")
	bb.Name = "LeakByDemiTag"
	bb.Adornee = head
	bb.Size = UDim2.fromOffset(280, 62)
	bb.StudsOffset = Vector3.new(0, 3.2, 0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.MaxDistance = 200
	bb.Parent = head
	bb:SetAttribute("_sig", TAG_SIG)

	local f = Instance.new("Frame", bb)
	f.Size = UDim2.fromScale(1, 1)
	f.BackgroundTransparency = 1
	f.BorderSizePixel = 0

	local l1 = Instance.new("TextLabel", f)
	l1.Size = UDim2.new(1, 0, 0.5, 0)
	l1.BackgroundTransparency = 1
	l1.Text = TAG_TEXT_1
	l1.Font = Enum.Font.GothamBlack
	l1.TextSize = 22
	l1.TextColor3 = TAG_COLOR_1
	l1.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	l1.TextStrokeTransparency = 0.2
	l1.TextXAlignment = Enum.TextXAlignment.Center
	l1.TextYAlignment = Enum.TextYAlignment.Center

	local l2 = Instance.new("TextLabel", f)
	l2.Size = UDim2.new(1, 0, 0.5, 0)
	l2.Position = UDim2.new(0, 0, 0.5, 0)
	l2.BackgroundTransparency = 1
	l2.Text = TAG_TEXT_2
	l2.Font = Enum.Font.GothamBold
	l2.TextSize = 14
	l2.TextColor3 = TAG_COLOR_2
	l2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	l2.TextStrokeTransparency = 0.3
	l2.TextXAlignment = Enum.TextXAlignment.Center
	l2.TextYAlignment = Enum.TextYAlignment.Center
end

task.spawn(function()
	while true do
		task.wait(0.4)
		local char = plr.Character
		if char then
			local head = char:FindFirstChild("Head")
			if head then
				local tag = head:FindFirstChild("LeakByDemiTag")
				if not tag then
					attachHeadTag(char)
				elseif tag:GetAttribute("_sig") ~= TAG_SIG then
					tag:Destroy()
					attachHeadTag(char)
				end
			end
		end
	end
end)

if plr.Character then attachHeadTag(plr.Character) end
plr.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	attachHeadTag(char)
end)