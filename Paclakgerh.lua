--[[ SHABH LAGGER - AUTO START ON HOLD WHEN AUTO BRAINROT IS ON ]]
print("[SHABH LAGGER] Loaded")

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local SETTINGS_FILE = "ShabhPacketLagger_Settings.json"

-- Purple Neon Theme Palette
local BG_MAIN       = Color3.fromRGB(10, 4, 18)
local BG_PANEL      = Color3.fromRGB(16, 8, 30)
local INPUT_BG      = Color3.fromRGB(24, 10, 45)
local BORDER_PURPLE = Color3.fromRGB(140, 30, 220)
local GLOW_PURPLE   = Color3.fromRGB(180, 50, 255)
local ACCENT_PURPLE = Color3.fromRGB(130, 20, 210)
local ACCENT_STOP   = Color3.fromRGB(200, 30, 80)
local ACCENT_ACTIVE = Color3.fromRGB(155, 45, 245)
local TEXT_PURPLE   = Color3.fromRGB(215, 175, 255)
local TEXT_WHITE    = Color3.fromRGB(255, 255, 255)

local function corner(o, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = o
	return c
end

local function stroke(o, col, th, tr)
	local s = Instance.new("UIStroke")
	s.Color = col
	s.Thickness = th or 1.5
	s.Transparency = tr or 0.2
	s.Parent = o
	return s
end

-- Cleanup old instances
pcall(function()
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then
		for _, n in ipairs({"ShabhPacketLagger", "SHABHTPacketLagger", "RTZPacketLagger", "BlindPacketLagger"}) do
			local old = pg:FindFirstChild(n)
			if old then old:Destroy() end
		end
	end
	if gethui then
		for _, g in ipairs(gethui():GetChildren()) do
			if g.Name == "ShabhPacketLagger" then g:Destroy() end
		end
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "ShabhPacketLagger"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
pcall(function() if gethui then gui.Parent = gethui() end end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

-- Compact Window Dimensions
local W = 275
local H = 485
local collapsedH = 88

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(W, H)
Main.Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2)
Main.BackgroundColor3 = BG_MAIN
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = gui
corner(Main, 16)
stroke(Main, GLOW_PURPLE, 1.8, 0.15)

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = Main

-- Title Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = BG_PANEL
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.ZIndex = 3
header.Parent = Main

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.fromOffset(12, 0)
Title.Text = "👑 SHABH LAGGER"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 12
Title.TextColor3 = TEXT_PURPLE
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 4
Title.Parent = header

-- Lock button
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.fromOffset(24, 24)
lockBtn.Position = UDim2.new(1, -58, 0.5, -12)
lockBtn.BackgroundColor3 = INPUT_BG
lockBtn.Text = "🔓"
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 11
lockBtn.TextColor3 = Color3.fromRGB(240, 190, 60)
lockBtn.AutoButtonColor = false
lockBtn.ZIndex = 4
lockBtn.Parent = header
corner(lockBtn, 7)
stroke(lockBtn, BORDER_PURPLE, 1, 0.4)

-- Old minimize / restore button
local collapseBtn = Instance.new("TextButton")
collapseBtn.Name = "CollapseBtn"
collapseBtn.Size = UDim2.fromOffset(22, 24)
collapseBtn.Position = UDim2.new(1, -30, 0.5, -12)
collapseBtn.BackgroundColor3 = INPUT_BG
collapseBtn.Text = "−"
collapseBtn.Font = Enum.Font.GothamBlack
collapseBtn.TextSize = 15
collapseBtn.TextColor3 = TEXT_WHITE
collapseBtn.AutoButtonColor = false
collapseBtn.ZIndex = 4
collapseBtn.Parent = header
corner(collapseBtn, 7)
stroke(collapseBtn, GLOW_PURPLE, 1.2, 0.25)

-- Elements list for toggling visibility
local collapsibleElements = {}

local function trackElement(obj)
	table.insert(collapsibleElements, obj)
	return obj
end

local function makeSectionLabel(text, icon, yPos)
	local iconLbl = trackElement(Instance.new("TextLabel"))
	iconLbl.BackgroundTransparency = 1
	iconLbl.Position = UDim2.fromOffset(12, yPos)
	iconLbl.Size = UDim2.fromOffset(20, 20)
	iconLbl.Text = icon
	iconLbl.Font = Enum.Font.GothamBold
	iconLbl.TextSize = 14
	iconLbl.TextColor3 = TEXT_PURPLE
	iconLbl.ZIndex = 3
	iconLbl.Parent = Main

	local lbl = trackElement(Instance.new("TextLabel"))
	lbl.BackgroundTransparency = 1
	lbl.Position = UDim2.fromOffset(35, yPos + 2)
	lbl.Size = UDim2.new(1, -47, 0, 16)
	lbl.Text = text
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 10
	lbl.TextColor3 = TEXT_WHITE
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 3
	lbl.Parent = Main
	return lbl
end
	-- POWER PRESETS (values are intentionally hidden from the interface)
	makeSectionLabel("POWER PRESET", "⚡", 48)

	local lowPlusPowerBtn = trackElement(Instance.new("TextButton"))
	lowPlusPowerBtn.Name = "LowPlusPowerBtn"
	lowPlusPowerBtn.Position = UDim2.fromOffset(12, 68)
	lowPlusPowerBtn.Size = UDim2.fromOffset(56, 32)
	lowPlusPowerBtn.BackgroundColor3 = ACCENT_ACTIVE
	lowPlusPowerBtn.Text = "LOW +"
	lowPlusPowerBtn.Font = Enum.Font.GothamBlack
	lowPlusPowerBtn.TextSize = 10
	lowPlusPowerBtn.TextColor3 = TEXT_WHITE
	lowPlusPowerBtn.AutoButtonColor = false
	lowPlusPowerBtn.ZIndex = 3
	lowPlusPowerBtn.Parent = Main
	corner(lowPlusPowerBtn, 8)
	stroke(lowPlusPowerBtn, BORDER_PURPLE, 1.1, 0.3)

	local lowPowerBtn = trackElement(Instance.new("TextButton"))
	lowPowerBtn.Name = "LowPowerBtn"
	lowPowerBtn.Position = UDim2.fromOffset(76, 68)
	lowPowerBtn.Size = UDim2.fromOffset(56, 32)
	lowPowerBtn.BackgroundColor3 = INPUT_BG
	lowPowerBtn.Text = "LOW"
	lowPowerBtn.Font = Enum.Font.GothamBlack
	lowPowerBtn.TextSize = 11
	lowPowerBtn.TextColor3 = TEXT_PURPLE
	lowPowerBtn.AutoButtonColor = false
	lowPowerBtn.ZIndex = 3
	lowPowerBtn.Parent = Main
	corner(lowPowerBtn, 8)
	stroke(lowPowerBtn, BORDER_PURPLE, 1.1, 0.3)

	local midPowerBtn = trackElement(Instance.new("TextButton"))
	midPowerBtn.Name = "MidPowerBtn"
	midPowerBtn.Position = UDim2.fromOffset(140, 68)
	midPowerBtn.Size = UDim2.fromOffset(56, 32)
	midPowerBtn.BackgroundColor3 = INPUT_BG
	midPowerBtn.Text = "MID"
	midPowerBtn.Font = Enum.Font.GothamBlack
	midPowerBtn.TextSize = 11
	midPowerBtn.TextColor3 = TEXT_PURPLE
	midPowerBtn.AutoButtonColor = false
	midPowerBtn.ZIndex = 3
	midPowerBtn.Parent = Main
	corner(midPowerBtn, 8)
	stroke(midPowerBtn, BORDER_PURPLE, 1.1, 0.3)

	local highPowerBtn = trackElement(Instance.new("TextButton"))
	highPowerBtn.Name = "HighPowerBtn"
	highPowerBtn.Position = UDim2.fromOffset(204, 68)
	highPowerBtn.Size = UDim2.fromOffset(56, 32)
	highPowerBtn.BackgroundColor3 = INPUT_BG
	highPowerBtn.Text = "HIGH"
	highPowerBtn.Font = Enum.Font.GothamBlack
	highPowerBtn.TextSize = 11
	highPowerBtn.TextColor3 = TEXT_PURPLE
	highPowerBtn.AutoButtonColor = false
	highPowerBtn.ZIndex = 3
	highPowerBtn.Parent = Main
	corner(highPowerBtn, 8)
	stroke(highPowerBtn, BORDER_PURPLE, 1.1, 0.3)

	-- 2. TOGGLE KEYBIND
makeSectionLabel("TOGGLE KEYBIND", "⚡", 108)

local KeyBtn = trackElement(Instance.new("TextButton"))
KeyBtn.Position = UDim2.fromOffset(12, 128)
KeyBtn.Size = UDim2.new(1, -62, 0, 32)
KeyBtn.BackgroundColor3 = INPUT_BG
KeyBtn.Text = "V"
KeyBtn.Font = Enum.Font.GothamBlack
KeyBtn.TextSize = 13
KeyBtn.TextColor3 = TEXT_PURPLE
KeyBtn.AutoButtonColor = false
KeyBtn.ZIndex = 3
KeyBtn.Parent = Main
corner(KeyBtn, 8)
stroke(KeyBtn, BORDER_PURPLE, 1.1, 0.3)

local saveKeyBtn = trackElement(Instance.new("TextButton"))
saveKeyBtn.Position = UDim2.new(1, -44, 0, 128)
saveKeyBtn.Size = UDim2.fromOffset(32, 32)
saveKeyBtn.BackgroundColor3 = INPUT_BG
saveKeyBtn.Text = "⌨️"
saveKeyBtn.Font = Enum.Font.GothamBold
saveKeyBtn.TextSize = 14
saveKeyBtn.TextColor3 = TEXT_WHITE
saveKeyBtn.AutoButtonColor = false
saveKeyBtn.ZIndex = 3
saveKeyBtn.Parent = Main
corner(saveKeyBtn, 8)
stroke(saveKeyBtn, BORDER_PURPLE, 1.1, 0.3)

-- 3. CONTROLLER KEYBIND
makeSectionLabel("CONTROLLER KEYBIND", "🎮", 168)

local padBtn = trackElement(Instance.new("TextButton"))
padBtn.Position = UDim2.fromOffset(12, 188)
padBtn.Size = UDim2.new(1, -62, 0, 32)
padBtn.BackgroundColor3 = INPUT_BG
padBtn.Text = "Pad: DPadDown"
padBtn.Font = Enum.Font.GothamBold
padBtn.TextSize = 12
padBtn.TextColor3 = TEXT_PURPLE
padBtn.AutoButtonColor = false
padBtn.ZIndex = 3
padBtn.Parent = Main
corner(padBtn, 8)
stroke(padBtn, BORDER_PURPLE, 1.1, 0.3)

local padSaveBtn = trackElement(Instance.new("TextButton"))
padSaveBtn.Position = UDim2.new(1, -44, 0, 188)
padSaveBtn.Size = UDim2.fromOffset(32, 32)
padSaveBtn.BackgroundColor3 = INPUT_BG
padSaveBtn.Text = "🎮"
padSaveBtn.Font = Enum.Font.GothamBold
padSaveBtn.TextSize = 14
padSaveBtn.TextColor3 = TEXT_WHITE
padSaveBtn.AutoButtonColor = false
padSaveBtn.ZIndex = 3
padSaveBtn.Parent = Main
corner(padSaveBtn, 8)
stroke(padSaveBtn, BORDER_PURPLE, 1.1, 0.3)

-- 4. CFRAME SECTION
makeSectionLabel("CFRAME", "⚙️", 228)

local studsLbl = trackElement(Instance.new("TextLabel"))
studsLbl.BackgroundTransparency = 1
studsLbl.Position = UDim2.fromOffset(12, 248)
studsLbl.Size = UDim2.fromOffset(38, 28)
studsLbl.Text = "Studs"
studsLbl.Font = Enum.Font.GothamMedium
studsLbl.TextSize = 11
studsLbl.TextColor3 = TEXT_WHITE
studsLbl.TextXAlignment = Enum.TextXAlignment.Left
studsLbl.ZIndex = 3
studsLbl.Parent = Main

local studsInput = trackElement(Instance.new("TextBox"))
studsInput.Position = UDim2.fromOffset(52, 248)
studsInput.Size = UDim2.fromOffset(60, 28)
studsInput.BackgroundColor3 = INPUT_BG
studsInput.Text = "9"
studsInput.Font = Enum.Font.GothamBlack
studsInput.TextSize = 12
studsInput.TextColor3 = TEXT_PURPLE
studsInput.ClearTextOnFocus = false
studsInput.ZIndex = 3
studsInput.Parent = Main
corner(studsInput, 7)
stroke(studsInput, BORDER_PURPLE, 1, 0.3)

local delayLbl = trackElement(Instance.new("TextLabel"))
delayLbl.BackgroundTransparency = 1
delayLbl.Position = UDim2.fromOffset(124, 248)
delayLbl.Size = UDim2.fromOffset(36, 28)
delayLbl.Text = "Delay"
delayLbl.Font = Enum.Font.GothamMedium
delayLbl.TextSize = 11
delayLbl.TextColor3 = TEXT_WHITE
delayLbl.TextXAlignment = Enum.TextXAlignment.Left
delayLbl.ZIndex = 3
delayLbl.Parent = Main

local delayInput = trackElement(Instance.new("TextBox"))
delayInput.Position = UDim2.new(1, -68, 0, 248)
delayInput.Size = UDim2.fromOffset(56, 28)
delayInput.BackgroundColor3 = INPUT_BG
delayInput.Text = "0.1"
delayInput.Font = Enum.Font.GothamBlack
delayInput.TextSize = 12
delayInput.TextColor3 = TEXT_PURPLE
delayInput.ClearTextOnFocus = false
delayInput.ZIndex = 3
delayInput.Parent = Main
corner(delayInput, 7)
stroke(delayInput, BORDER_PURPLE, 1, 0.3)

-- DISABLE CF Row
local disableCfBtn = trackElement(Instance.new("TextButton"))
disableCfBtn.Position = UDim2.fromOffset(12, 284)
disableCfBtn.Size = UDim2.new(1, -24, 0, 32)
disableCfBtn.BackgroundColor3 = Color3.fromRGB(35, 185, 95)
disableCfBtn.Text = "CFRAME: ON"
disableCfBtn.Font = Enum.Font.GothamBlack
disableCfBtn.TextSize = 10
disableCfBtn.TextColor3 = TEXT_WHITE
disableCfBtn.AutoButtonColor = false
disableCfBtn.ZIndex = 3
disableCfBtn.Parent = Main
corner(disableCfBtn, 8)
stroke(disableCfBtn, BORDER_PURPLE, 1, 0.3)

-- AUTO BRAINROT Button
local autoBrainrotBtn = trackElement(Instance.new("TextButton"))
autoBrainrotBtn.Name = "AutoBrainrotBtn"
autoBrainrotBtn.Position = UDim2.fromOffset(12, 324)
autoBrainrotBtn.Size = UDim2.new(1, -24, 0, 34)
autoBrainrotBtn.BackgroundColor3 = INPUT_BG
autoBrainrotBtn.Text = "🧠 AUTO BRAINROT: OFF"
autoBrainrotBtn.Font = Enum.Font.GothamBlack
autoBrainrotBtn.TextSize = 11
autoBrainrotBtn.TextColor3 = TEXT_PURPLE
autoBrainrotBtn.AutoButtonColor = false
autoBrainrotBtn.ZIndex = 3
autoBrainrotBtn.Parent = Main
corner(autoBrainrotBtn, 9)
stroke(autoBrainrotBtn, GLOW_PURPLE, 1.1, 0.25)

-- Status Indicator
local statusLbl = trackElement(Instance.new("TextLabel"))
statusLbl.BackgroundTransparency = 1
statusLbl.Position = UDim2.fromOffset(12, 366)
statusLbl.Size = UDim2.new(1, -24, 0, 16)
statusLbl.Text = "Status: Ready (Persistent)"
statusLbl.Font = Enum.Font.GothamMedium
statusLbl.TextSize = 10
statusLbl.TextColor3 = Color3.fromRGB(175, 145, 215)
statusLbl.TextXAlignment = Enum.TextXAlignment.Center
statusLbl.ZIndex = 3
statusLbl.Parent = Main

-- SAVE SETTINGS BUTTON
local saveSettingsBtn = trackElement(Instance.new("TextButton"))
saveSettingsBtn.Name = "SaveSettingsBtn"
saveSettingsBtn.Position = UDim2.fromOffset(12, 388)
saveSettingsBtn.Size = UDim2.new(1, -24, 0, 32)
saveSettingsBtn.BackgroundColor3 = INPUT_BG
saveSettingsBtn.Text = "SAVE SETTINGS"
saveSettingsBtn.Font = Enum.Font.GothamBlack
saveSettingsBtn.TextSize = 11
saveSettingsBtn.TextColor3 = TEXT_WHITE
saveSettingsBtn.AutoButtonColor = false
saveSettingsBtn.ZIndex = 4
saveSettingsBtn.Parent = Main
corner(saveSettingsBtn, 8)
stroke(saveSettingsBtn, BORDER_PURPLE, 1.1, 0.3)

-- START BUTTON
local StartBtn = Instance.new("TextButton")
StartBtn.Name = "StartBtn"
StartBtn.Position = UDim2.fromOffset(12, 428)
StartBtn.Size = UDim2.new(1, -24, 0, 44)
StartBtn.BackgroundColor3 = ACCENT_PURPLE
StartBtn.Text = "▶ START"
StartBtn.Font = Enum.Font.GothamBlack
StartBtn.TextSize = 16
StartBtn.TextColor3 = TEXT_WHITE
StartBtn.AutoButtonColor = false
StartBtn.ZIndex = 5
StartBtn.Parent = Main
corner(StartBtn, 12)
stroke(StartBtn, GLOW_PURPLE, 1.4, 0.1)

-- State Variables
local lagging = false
local lagThread = nil
local intensity = 152000
local toggleKey = Enum.KeyCode.V
local toggleKeyName = "V"
local padKey = Enum.KeyCode.DPadDown
local padKeyName = "DPadDown"
local listeningForKey = false
local listeningForPad = false
local isCollapsed = false
local isLocked = false
local cfDisabled = false
-- Enabled by default: holding a Brainrot automatically starts the process.
local autoBrainrotEnabled = true
local autoStartedByHold = false
local brainrotThread = nil
local cfThread = nil

-- Remote Resolution (Child #6 of ReplicatedStorage.Packages.Net)
local Event
local function resolveEvent()
	local ok, net = pcall(function()
		local pkgs = ReplicatedStorage:WaitForChild("Packages", 5)
		return pkgs and pkgs:WaitForChild("Net", 5)
	end)
	if ok and net then
		local kids = net:GetChildren()
		Event = kids[6]
	end
	return Event
end
resolveEvent()

local function applyKeybind(name)
	toggleKeyName = name or "V"
	local ok, key = pcall(function() return Enum.KeyCode[toggleKeyName] end)
	toggleKey = (ok and key) or Enum.KeyCode.V
	KeyBtn.Text = toggleKeyName
end

local function applyPadBind(name)
	padKeyName = name or "DPadDown"
	local ok, key = pcall(function() return Enum.KeyCode[padKeyName] end)
	padKey = (ok and key) or Enum.KeyCode.DPadDown
	padBtn.Text = "Pad: " .. padKeyName
end

local function saveSettings()
	if not (writefile and HttpService) then return false end
	local pos = Main.Position
	local data = {
		intensity = intensity,
		toggleKeyName = toggleKeyName,
		padKeyName = padKeyName,
		studs = tonumber(studsInput.Text) or 9,
		delay = tonumber(delayInput.Text) or 0.1,
		cfDisabled = cfDisabled,
		autoBrainrotEnabled = autoBrainrotEnabled,
		isLocked = isLocked,
		position = {
			xScale = pos.X.Scale, xOffset = pos.X.Offset,
			yScale = pos.Y.Scale, yOffset = pos.Y.Offset,
		},
	}
	local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
	if ok and encoded then
		return pcall(writefile, SETTINGS_FILE, encoded)
	end
	return false
end

local function loadSettings()
	if not (isfile and readfile and HttpService and isfile(SETTINGS_FILE)) then return end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(SETTINGS_FILE)) end)
	if not ok or type(data) ~= "table" then return end
	if data.intensity == 100000 or data.intensity == 200000 or data.intensity == 250000 or data.intensity == 350000 then
		intensity = data.intensity
	end
	if type(data.toggleKeyName) == "string" then applyKeybind(data.toggleKeyName) end
	if type(data.padKeyName) == "string" then applyPadBind(data.padKeyName) end
	if tonumber(data.studs) then studsInput.Text = tostring(data.studs) end
	if tonumber(data.delay) then delayInput.Text = tostring(data.delay) end
	if type(data.cfDisabled) == "boolean" then cfDisabled = data.cfDisabled end
	if type(data.autoBrainrotEnabled) == "boolean" then autoBrainrotEnabled = data.autoBrainrotEnabled end
	if type(data.isLocked) == "boolean" then isLocked = data.isLocked end
	local pos = data.position
	if type(pos) == "table" and tonumber(pos.xScale) and tonumber(pos.xOffset) and tonumber(pos.yScale) and tonumber(pos.yOffset) then
		Main.Position = UDim2.new(pos.xScale, pos.xOffset, pos.yScale, pos.yOffset)
	end
end

loadSettings()

local function paintActivate()
	if lagging then
		StartBtn.Text = "⏸ STOP"
		StartBtn.BackgroundColor3 = ACCENT_STOP
		statusLbl.Text = "Status: RUNNING"
		statusLbl.TextColor3 = Color3.fromRGB(90, 255, 150)
	else
		StartBtn.Text = "▶ START"
		StartBtn.BackgroundColor3 = ACCENT_PURPLE
		statusLbl.Text = "Status: Ready (Persistent)"
		statusLbl.TextColor3 = Color3.fromRGB(175, 145, 215)
	end
end

local function startLagging(fromHold)
	if lagging then return end
	lagging = true
	autoStartedByHold = (fromHold == true)
	paintActivate()
	if not Event then resolveEvent() end

	local payload = table.create(intensity, function() end)

	lagThread = task.spawn(function()
		while lagging do
			if Event then
				pcall(function() Event:FireServer(payload) end)
			end
			task.wait(0.05)
		end
	end)
end

local function stopLagging()
	if not lagging then return end
	lagging = false
	autoStartedByHold = false
	if lagThread then pcall(task.cancel, lagThread); lagThread = nil end
	paintActivate()
end

-- Auto Brainrot Loop (Delay = 0.3s)
local function paintBrainrot()
	if autoBrainrotEnabled then
		autoBrainrotBtn.Text = "🧠 AUTO BRAINROT: ON"
		autoBrainrotBtn.BackgroundColor3 = ACCENT_ACTIVE
		autoBrainrotBtn.TextColor3 = TEXT_WHITE
	else
		autoBrainrotBtn.Text = "🧠 AUTO BRAINROT: OFF"
		autoBrainrotBtn.BackgroundColor3 = INPUT_BG
		autoBrainrotBtn.TextColor3 = TEXT_PURPLE
	end
end

-- Auto Brainrot detection imported from the replacement source.
-- The game marks the carried state by lowering Humanoid.WalkSpeed.
local brainrotMode = false
local lastBrainrotState = false

RunService.Heartbeat:Connect(function()
	if not autoBrainrotEnabled then
		if brainrotMode then
			brainrotMode = false
			lastBrainrotState = false
			if autoStartedByHold and lagging then
				stopLagging()
			end
		end
		return
	end

	local char = LP.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local hasBrainrot = hum.WalkSpeed < 25

	if hasBrainrot and not lastBrainrotState then
		brainrotMode = true
		lastBrainrotState = true
		autoStartedByHold = true
		if not lagging then
			startLagging(true)
		end
	elseif not hasBrainrot and lastBrainrotState then
		brainrotMode = false
		lastBrainrotState = false
		if autoStartedByHold and lagging then
			stopLagging()
		end
		autoStartedByHold = false
	end
end)

-- CFrame Step Loop
local function startCFrameLoop()
	if cfThread then task.cancel(cfThread); cfThread = nil end
	cfThread = task.spawn(function()
		while true do
			local delayVal = tonumber(delayInput.Text) or 0.1
			delayVal = math.max(0.01, delayVal)
			local studsVal = tonumber(studsInput.Text) or 9

			if not cfDisabled and lagging then
				local char = LP.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if hrp and hum and hum.MoveDirection.Magnitude > 0 then
					hrp.CFrame = hrp.CFrame + (hum.MoveDirection.Unit * studsVal)
				end
			end
			task.wait(delayVal)
		end
	end)
end
startCFrameLoop()

	-- UI SIZE controls: change the interface height only.
	local function setCollapsed(collapsed)
		isCollapsed = collapsed
		if isCollapsed then
			collapseBtn.Text = "+"
			for _, el in ipairs(collapsibleElements) do
				el.Visible = false
			end
			StartBtn.Position = UDim2.fromOffset(12, 46)
			StartBtn.Size = UDim2.new(1, -24, 0, 34)
			StartBtn.TextSize = 13
			StartBtn.Visible = true
			TweenService:Create(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
				Size = UDim2.fromOffset(W, collapsedH)
			}):Play()
		else
			collapseBtn.Text = "−"
			StartBtn.Position = UDim2.fromOffset(12, 428)
			StartBtn.Size = UDim2.new(1, -24, 0, 44)
			StartBtn.TextSize = 16
				StartBtn.Visible = true
				TweenService:Create(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
					Size = UDim2.fromOffset(W, H)
				}):Play()
			task.delay(0.12, function()
				if not isCollapsed then
					for _, el in ipairs(collapsibleElements) do
						el.Visible = true
					end
				end
			end)
		end
	end

	collapseBtn.MouseButton1Click:Connect(function()
		setCollapsed(not isCollapsed)
	end)

	-- Buttons Connections
	local function paintPowerButtons(activeButton)
		for _, button in ipairs({lowPlusPowerBtn, lowPowerBtn, midPowerBtn, highPowerBtn}) do
			button.BackgroundColor3 = (button == activeButton) and ACCENT_ACTIVE or INPUT_BG
			button.TextColor3 = (button == activeButton) and TEXT_WHITE or TEXT_PURPLE
		end
	end

	local function choosePower(value, button)
		intensity = value
		paintPowerButtons(button)
		if lagging then
			stopLagging()
			startLagging(false)
		end
	end

	lowPlusPowerBtn.MouseButton1Click:Connect(function() choosePower(152000, lowPlusPowerBtn) end)
	lowPowerBtn.MouseButton1Click:Connect(function() choosePower(200000, lowPowerBtn) end)
	midPowerBtn.MouseButton1Click:Connect(function() choosePower(250000, midPowerBtn) end)
	highPowerBtn.MouseButton1Click:Connect(function() choosePower(350000, highPowerBtn) end)

	saveSettingsBtn.MouseButton1Click:Connect(function()
		local saved = saveSettings()
		saveSettingsBtn.Text = saved and "SAVED" or "SAVE FAILED"
		saveSettingsBtn.BackgroundColor3 = saved and Color3.fromRGB(35, 185, 95) or ACCENT_STOP
		task.delay(1.0, function()
			if saveSettingsBtn and saveSettingsBtn.Parent then
				saveSettingsBtn.Text = "SAVE SETTINGS"
				saveSettingsBtn.BackgroundColor3 = INPUT_BG
				end
		end)
	end)

	KeyBtn.MouseButton1Click:Connect(function()
	listeningForKey = true
	KeyBtn.Text = "..."
end)

padBtn.MouseButton1Click:Connect(function()
	listeningForPad = true
	padBtn.Text = "Press Pad..."
end)

disableCfBtn.MouseButton1Click:Connect(function()
			cfDisabled = not cfDisabled
			disableCfBtn.BackgroundColor3 = cfDisabled and ACCENT_STOP or Color3.fromRGB(35, 185, 95)
			disableCfBtn.Text = cfDisabled and "CFRAME: OFF" or "CFRAME: ON"
		end)

autoBrainrotBtn.MouseButton1Click:Connect(function()
	autoBrainrotEnabled = not autoBrainrotEnabled
	paintBrainrot()
end)

StartBtn.MouseButton1Click:Connect(function()
	if lagging then stopLagging() else startLagging(false) end
end)

	lockBtn.MouseButton1Click:Connect(function()
		isLocked = not isLocked
		lockBtn.Text = isLocked and "🔒" or "🔓"
	end)

-- Keybind & Pad Listeners
UIS.InputBegan:Connect(function(input, gpe)
	if listeningForKey then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			listeningForKey = false
			applyKeybind(input.KeyCode.Name)
		end
		return
	end
	if listeningForPad then
		if input.UserInputType == Enum.UserInputType.Gamepad1 then
			listeningForPad = false
			applyPadBind(input.KeyCode.Name)
		end
		return
	end
	if gpe then return end
	if input.KeyCode == toggleKey or input.KeyCode == padKey then
		if lagging then stopLagging() else startLagging(false) end
	end
end)

-- Drag System
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
	if isLocked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if not dragging or isLocked then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local d = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

if intensity == 152000 then
	paintPowerButtons(lowPlusPowerBtn)
elseif intensity == 200000 then
	paintPowerButtons(lowPowerBtn)
elseif intensity == 250000 then
	paintPowerButtons(midPowerBtn)
else
	intensity = 350000
	paintPowerButtons(highPowerBtn)
end
paintActivate()
paintBrainrot()
disableCfBtn.BackgroundColor3 = cfDisabled and ACCENT_STOP or Color3.fromRGB(35, 185, 95)
disableCfBtn.Text = cfDisabled and "CFRAME: OFF" or "CFRAME: ON"
lockBtn.Text = isLocked and "🔒" or "🔓"