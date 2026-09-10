if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

local CONFIG_FILE = "S2HubBypassConfig.json"
local DEPTH = 296
local SPAM_DELAY = 0.12

local State = {
	keybind = Enum.KeyCode.C,
	power = 97000,
	powerPC = 97000,
	powerMobile = 72000,
	active = false,
	isMobile = false,
	autoBrainrot = false,
	_thread = nil,
	_bomb = nil,
}

local BLUE = Color3.fromRGB(80, 120, 255)
local BLUE_DIM = Color3.fromRGB(80, 100, 180)
local BLUE_STROKE = Color3.fromRGB(50, 80, 180)
local TEXT = Color3.fromRGB(245, 250, 255)
local MUTED = Color3.fromRGB(180, 200, 255)
local GOLD = Color3.fromRGB(255, 208, 96)
local BG = Color3.fromRGB(6, 7, 18)
local HDR = Color3.fromRGB(8, 10, 24)

local function loadConfig()
	pcall(function()
		if type(isfile) ~= "function" or not isfile(CONFIG_FILE) then return end
		local d = HttpService:JSONDecode(readfile(CONFIG_FILE))
		if type(d) ~= "table" then return end
		if type(d.Keybind) == "string" and Enum.KeyCode[d.Keybind] then
			State.keybind = Enum.KeyCode[d.Keybind]
		end
		if type(d.power) == "number" then State.power = math.clamp(math.floor(d.power), 1, 999999) end
		if type(d.powerPC) == "number" then State.powerPC = math.clamp(math.floor(d.powerPC), 1, 999999) end
		if type(d.powerMobile) == "number" then State.powerMobile = math.clamp(math.floor(d.powerMobile), 1, 999999) end
		if d.isMobile == true then State.isMobile = true end
		if d.autoBrainrot == true then State.autoBrainrot = true end
	end)
end

local function saveConfig()
	pcall(function()
		if type(writefile) ~= "function" then return end
		writefile(CONFIG_FILE, HttpService:JSONEncode({
			Keybind = State.keybind.Name,
			power = State.power,
			powerPC = State.powerPC,
			powerMobile = State.powerMobile,
			isMobile = State.isMobile,
			autoBrainrot = State.autoBrainrot,
		}))
	end)
end

loadConfig()
if State.isMobile then
	State.power = State.powerMobile
else
	State.power = State.powerPC
end

local function formatPower(n)
	n = tonumber(n) or 0
	if n >= 1000000 then
		local v = n / 1000000
		if v == math.floor(v) then return tostring(math.floor(v)) .. "M" end
		return string.format("%.1fM", v)
	end
	if n >= 1000 then
		local v = n / 1000
		if v == math.floor(v) then return tostring(math.floor(v)) .. "K" end
		return string.format("%.1fK", v)
	end
	return tostring(n)
end

local function buildBomb(power)
	local maintable, spammedtable = {}, {}
	table.insert(spammedtable, {})
	local z = spammedtable[1]
	for _ = 1, DEPTH do
		local t = {}
		table.insert(z, t)
		z = t
	end
	local maxRep = math.max(1, math.floor((tonumber(power) or 70000) / (DEPTH + 2)))
	for _ = 1, maxRep do
		table.insert(maintable, spammedtable)
	end
	return maintable
end

local function stopBypass()
	State.active = false
	if State._thread then
		pcall(task.cancel, State._thread)
		State._thread = nil
	end
	State._bomb = nil
end

local function startBypass()
	stopBypass()
	State.active = true
	State._bomb = buildBomb(State.power)
	State._thread = task.spawn(function()
		while State.active do
			local b = State._bomb
			if b then
				pcall(function()
					game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(b)
				end)
			end
			task.wait(SPAM_DELAY)
		end
	end)
end

local function toggleBypass()
	if State.active then
		stopBypass()
	else
		startBypass()
	end
	return State.active
end

local parent = LP:WaitForChild("PlayerGui")
pcall(function()
	parent = gethui() or game:GetService("CoreGui")
end)

for _, v in ipairs(parent:GetChildren()) do
	if v.Name == "S2HubBypassGui" then
		v:Destroy()
	end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "S2HubBypassGui"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
	if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
end)
ScreenGui.Parent = parent

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Active = true
Main.Position = UDim2.new(0.5, 240, 0.5, -143)
Main.Size = UDim2.new(0, 240, 0, 374)
Main.BackgroundColor3 = BG
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = BLUE
MainStroke.Transparency = 0.82

local BgImg = Instance.new("ImageLabel")
BgImg.ZIndex = 2
BgImg.Size = UDim2.new(1, 0, 1, 0)
BgImg.BackgroundTransparency = 1
BgImg.BorderSizePixel = 0
BgImg.Image = "rbxassetid://118131424737973"
BgImg.ImageTransparency = 0.88
BgImg.ScaleType = Enum.ScaleType.Crop
BgImg.Parent = Main
Instance.new("UICorner", BgImg).CornerRadius = UDim.new(0, 20)

local Header = Instance.new("Frame")
Header.ZIndex = 3
Header.Size = UDim2.new(1, 0, 0, 46)
Header.BackgroundColor3 = HDR
Header.BackgroundTransparency = 0.1
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 20)

local Title = Instance.new("TextLabel")
Title.ZIndex = 4
Title.Position = UDim2.new(0, 14, 0.5, -16)
Title.Size = UDim2.new(1, -50, 0, 16)
Title.BackgroundTransparency = 1
Title.Text = "S2 J'R HUB"
Title.TextColor3 = TEXT
Title.TextSize = 13
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Sub = Instance.new("TextLabel")
Sub.ZIndex = 4
Sub.Position = UDim2.new(0, 14, 0.5, 2)
Sub.Size = UDim2.new(1, -50, 0, 12)
Sub.BackgroundTransparency = 1
Sub.Text = "discord.gg/S2HUB"
Sub.TextColor3 = BLUE
Sub.TextSize = 11
Sub.Font = Enum.Font.GothamMedium
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.ZIndex = 4
MinBtn.Position = UDim2.new(1, -36, 0.5, -11)
MinBtn.Size = UDim2.new(0, 22, 0, 22)
MinBtn.BackgroundColor3 = BLUE
MinBtn.BackgroundTransparency = 0.88
MinBtn.BorderSizePixel = 0
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(130, 175, 255)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.GothamBlack
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 7)
local MinStroke = Instance.new("UIStroke", MinBtn)
MinStroke.Color = BLUE_STROKE
MinStroke.Transparency = 0.75

local HeaderFill = Instance.new("Frame")
HeaderFill.ZIndex = 3
HeaderFill.Position = UDim2.new(0, 0, 0, 34)
HeaderFill.Size = UDim2.new(1, 0, 0, 12)
HeaderFill.BackgroundColor3 = HDR
HeaderFill.BackgroundTransparency = 0.1
HeaderFill.BorderSizePixel = 0
HeaderFill.Parent = Main

local Line = Instance.new("Frame")
Line.ZIndex = 4
Line.Position = UDim2.new(0, 12, 0, 46)
Line.Size = UDim2.new(1, -24, 0, 1)
Line.BackgroundColor3 = BLUE
Line.BackgroundTransparency = 0.92
Line.BorderSizePixel = 0
Line.Parent = Main

local Body = Instance.new("Frame")
Body.Position = UDim2.new(0, 0, 0, 47)
Body.Size = UDim2.new(1, 0, 0, 259)
Body.BackgroundTransparency = 1
Body.BorderSizePixel = 0
Body.Parent = Main

local Ring = Instance.new("Frame")
Ring.ZIndex = 3
Ring.Position = UDim2.new(0.5, -57, 0, 14)
Ring.Size = UDim2.new(0, 114, 0, 114)
Ring.BackgroundColor3 = BLUE
Ring.BackgroundTransparency = 0.88
Ring.BorderSizePixel = 0
Ring.Parent = Body
Instance.new("UICorner", Ring).CornerRadius = UDim.new(0, 57)
local RingStroke = Instance.new("UIStroke", Ring)
RingStroke.Color = BLUE
RingStroke.Thickness = 2.5
RingStroke.Transparency = 0.55

local Inner = Instance.new("Frame")
Inner.ZIndex = 4
Inner.Position = UDim2.new(0.5, -50, 0, 21)
Inner.Size = UDim2.new(0, 100, 0, 100)
Inner.BackgroundColor3 = BG
Inner.BackgroundTransparency = 0.45
Inner.BorderSizePixel = 0
Inner.Parent = Body
Instance.new("UICorner", Inner).CornerRadius = UDim.new(0, 50)

local PowerTag = Instance.new("TextLabel")
PowerTag.ZIndex = 5
PowerTag.Position = UDim2.new(0, 0, 0.5, -24)
PowerTag.Size = UDim2.new(1, 0, 0, 14)
PowerTag.BackgroundTransparency = 1
PowerTag.Text = "POWER"
PowerTag.TextColor3 = BLUE
PowerTag.TextSize = 10
PowerTag.Font = Enum.Font.GothamBlack
PowerTag.Parent = Inner

local PowerBtn = Instance.new("TextButton")
PowerBtn.ZIndex = 5
PowerBtn.Position = UDim2.new(0, 0, 0.5, -14)
PowerBtn.Size = UDim2.new(1, 0, 0, 36)
PowerBtn.BackgroundTransparency = 1
PowerBtn.Text = formatPower(State.power)
PowerBtn.TextColor3 = TEXT
PowerBtn.TextSize = 26
PowerBtn.Font = Enum.Font.GothamBlack
PowerBtn.AutoButtonColor = false
PowerBtn.Parent = Inner

local PowerBox = Instance.new("TextBox")
PowerBox.Visible = false
PowerBox.ZIndex = 6
PowerBox.Position = UDim2.new(0, 0, 0.5, -14)
PowerBox.Size = UDim2.new(1, 0, 0, 36)
PowerBox.BackgroundTransparency = 1
PowerBox.Text = tostring(State.power)
PowerBox.TextColor3 = TEXT
PowerBox.TextSize = 20
PowerBox.Font = Enum.Font.GothamBlack
PowerBox.ClearTextOnFocus = false
PowerBox.Parent = Inner

local ModeBar = Instance.new("Frame")
ModeBar.ZIndex = 3
ModeBar.Position = UDim2.new(0.5, -80, 0, 136)
ModeBar.Size = UDim2.new(0, 160, 0, 28)
ModeBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ModeBar.BackgroundTransparency = 0.6
ModeBar.BorderSizePixel = 0
ModeBar.Parent = Body
Instance.new("UICorner", ModeBar).CornerRadius = UDim.new(0, 14)
local ModeStroke = Instance.new("UIStroke", ModeBar)
ModeStroke.Color = BLUE
ModeStroke.Transparency = 0.88

local PcBtn = Instance.new("TextButton")
PcBtn.ZIndex = 4
PcBtn.Position = UDim2.new(0, 2, 0, 2)
PcBtn.Size = UDim2.new(0.5, -3, 1, -4)
PcBtn.BackgroundColor3 = BLUE
PcBtn.BorderSizePixel = 0
PcBtn.Text = "PC"
PcBtn.TextColor3 = TEXT
PcBtn.TextSize = 10
PcBtn.Font = Enum.Font.GothamBlack
PcBtn.AutoButtonColor = false
PcBtn.Parent = ModeBar
Instance.new("UICorner", PcBtn).CornerRadius = UDim.new(0, 12)

local MobBtn = Instance.new("TextButton")
MobBtn.ZIndex = 4
MobBtn.Position = UDim2.new(0.5, 1, 0, 2)
MobBtn.Size = UDim2.new(0.5, -3, 1, -4)
MobBtn.BackgroundTransparency = 1
MobBtn.BorderSizePixel = 0
MobBtn.Text = "MOBILE"
MobBtn.TextColor3 = BLUE_DIM
MobBtn.TextSize = 10
MobBtn.Font = Enum.Font.GothamBlack
MobBtn.AutoButtonColor = false
MobBtn.Parent = ModeBar
Instance.new("UICorner", MobBtn).CornerRadius = UDim.new(0, 12)

local AutoBtn = Instance.new("TextButton")
AutoBtn.ZIndex = 3
AutoBtn.Position = UDim2.new(0, 20, 0, 172)
AutoBtn.Size = UDim2.new(0, 200, 0, 34)
AutoBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AutoBtn.BackgroundTransparency = 0.65
AutoBtn.BorderSizePixel = 0
AutoBtn.Text = ""
AutoBtn.AutoButtonColor = false
AutoBtn.Parent = Body
Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0, 11)
local AutoStroke = Instance.new("UIStroke", AutoBtn)
AutoStroke.Color = BLUE
AutoStroke.Transparency = 0.9

local AutoLbl = Instance.new("TextLabel")
AutoLbl.ZIndex = 4
AutoLbl.Position = UDim2.new(0, 12, 0, 0)
AutoLbl.Size = UDim2.new(0.6, 0, 1, 0)
AutoLbl.BackgroundTransparency = 1
AutoLbl.Text = "Auto Brainrot"
AutoLbl.TextColor3 = MUTED
AutoLbl.TextSize = 10
AutoLbl.Font = Enum.Font.GothamBold
AutoLbl.TextXAlignment = Enum.TextXAlignment.Left
AutoLbl.Parent = AutoBtn

local AutoTrack = Instance.new("Frame")
AutoTrack.ZIndex = 4
AutoTrack.Position = UDim2.new(1, -46, 0.5, -10)
AutoTrack.Size = UDim2.new(0, 36, 0, 20)
AutoTrack.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
AutoTrack.BorderSizePixel = 0
AutoTrack.Parent = AutoBtn
Instance.new("UICorner", AutoTrack).CornerRadius = UDim.new(0, 10)
local AutoTrackStroke = Instance.new("UIStroke", AutoTrack)
AutoTrackStroke.Color = BLUE_STROKE
AutoTrackStroke.Transparency = 0.6

local AutoKnob = Instance.new("Frame")
AutoKnob.ZIndex = 5
AutoKnob.Position = UDim2.new(0, 3, 0.5, -7)
AutoKnob.Size = UDim2.new(0, 14, 0, 14)
AutoKnob.BackgroundColor3 = BLUE_STROKE
AutoKnob.BorderSizePixel = 0
AutoKnob.Parent = AutoTrack
Instance.new("UICorner", AutoKnob).CornerRadius = UDim.new(0, 7)

local KeyRow = Instance.new("TextButton")
KeyRow.ZIndex = 3
KeyRow.Position = UDim2.new(0, 20, 0, 212)
KeyRow.Size = UDim2.new(0, 200, 0, 34)
KeyRow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
KeyRow.BackgroundTransparency = 0.65
KeyRow.BorderSizePixel = 0
KeyRow.Text = ""
KeyRow.AutoButtonColor = false
KeyRow.Parent = Body
Instance.new("UICorner", KeyRow).CornerRadius = UDim.new(0, 11)
local KeyStroke = Instance.new("UIStroke", KeyRow)
KeyStroke.Color = BLUE
KeyStroke.Transparency = 0.9

local KeyLbl = Instance.new("TextLabel")
KeyLbl.ZIndex = 4
KeyLbl.Position = UDim2.new(0, 12, 0, 0)
KeyLbl.Size = UDim2.new(0.5, 0, 1, 0)
KeyLbl.BackgroundTransparency = 1
KeyLbl.Text = "Keybind"
KeyLbl.TextColor3 = MUTED
KeyLbl.TextSize = 10
KeyLbl.Font = Enum.Font.GothamBold
KeyLbl.TextXAlignment = Enum.TextXAlignment.Left
KeyLbl.Parent = KeyRow

local KeyVal = Instance.new("TextLabel")
KeyVal.ZIndex = 4
KeyVal.Position = UDim2.new(0.5, 0, 0, 0)
KeyVal.Size = UDim2.new(0.5, -12, 1, 0)
KeyVal.BackgroundTransparency = 1
KeyVal.Text = State.keybind.Name
KeyVal.TextColor3 = GOLD
KeyVal.TextSize = 10
KeyVal.Font = Enum.Font.GothamBlack
KeyVal.TextXAlignment = Enum.TextXAlignment.Right
KeyVal.Parent = KeyRow

local ActBtn = Instance.new("TextButton")
ActBtn.ZIndex = 5
ActBtn.Position = UDim2.new(0, 20, 0, 306)
ActBtn.Size = UDim2.new(0, 200, 0, 40)
ActBtn.BackgroundColor3 = BLUE
ActBtn.BorderSizePixel = 0
ActBtn.Text = "ACTIVATE"
ActBtn.TextColor3 = TEXT
ActBtn.TextSize = 13
ActBtn.Font = Enum.Font.GothamBlack
ActBtn.AutoButtonColor = false
ActBtn.Parent = Main
Instance.new("UICorner", ActBtn).CornerRadius = UDim.new(0, 14)
local ActStroke = Instance.new("UIStroke", ActBtn)
ActStroke.Color = BLUE
ActStroke.Transparency = 0.55

local listening = false
local minimized = false
local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quad)

local function refreshPower()
	PowerBtn.Text = formatPower(State.power)
	PowerBox.Text = tostring(State.power)
end

local function applyPower(n)
	State.power = math.clamp(math.floor(n), 1, 999999)
	if State.isMobile then
		State.powerMobile = State.power
	else
		State.powerPC = State.power
	end
	refreshPower()
	saveConfig()
	if State.active then
		startBypass()
	end
end

local function setMode(mobile)
	State.isMobile = mobile
	State.power = mobile and State.powerMobile or State.powerPC
	if mobile then
		PcBtn.BackgroundTransparency = 1
		PcBtn.TextColor3 = BLUE_DIM
		MobBtn.BackgroundColor3 = BLUE
		MobBtn.BackgroundTransparency = 0
		MobBtn.TextColor3 = TEXT
	else
		MobBtn.BackgroundTransparency = 1
		MobBtn.TextColor3 = BLUE_DIM
		PcBtn.BackgroundColor3 = BLUE
		PcBtn.BackgroundTransparency = 0
		PcBtn.TextColor3 = TEXT
	end
	refreshPower()
	saveConfig()
	if State.active then
		startBypass()
	end
end

local function setAutoVisual(on)
	TweenService:Create(AutoKnob, ti, {
		Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
		BackgroundColor3 = on and BLUE or BLUE_STROKE,
	}):Play()
	TweenService:Create(AutoTrack, ti, {
		BackgroundColor3 = on and Color3.fromRGB(40, 70, 160) or Color3.fromRGB(20, 20, 40),
	}):Play()
end

local function setActiveVisual(on)
	if on then
		ActBtn.Text = "RUNNING"
		ActBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 110)
		ActStroke.Color = Color3.fromRGB(40, 180, 110)
	else
		ActBtn.Text = "ACTIVATE"
		ActBtn.BackgroundColor3 = BLUE
		ActStroke.Color = BLUE
	end
end

local function doToggle()
	local on = toggleBypass()
	setActiveVisual(on)
end

PowerBtn.MouseButton1Click:Connect(function()
	PowerBtn.Visible = false
	PowerBox.Visible = true
	PowerBox.Text = tostring(State.power)
	PowerBox:CaptureFocus()
end)

PowerBox.FocusLost:Connect(function()
	local n = tonumber(PowerBox.Text)
	PowerBox.Visible = false
	PowerBtn.Visible = true
	if n then
		applyPower(n)
	else
		refreshPower()
	end
end)

PcBtn.MouseButton1Click:Connect(function()
	setMode(false)
end)

MobBtn.MouseButton1Click:Connect(function()
	setMode(true)
end)

AutoBtn.MouseButton1Click:Connect(function()
	State.autoBrainrot = not State.autoBrainrot
	setAutoVisual(State.autoBrainrot)
	saveConfig()
	if State.autoBrainrot then
		if not State.active then
			startBypass()
			setActiveVisual(true)
		end
	end
end)

KeyRow.MouseButton1Click:Connect(function()
	if listening then return end
	listening = true
	KeyVal.Text = "Press keybind..."
end)

ActBtn.MouseButton1Click:Connect(doToggle)

MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	Body.Visible = not minimized
	ActBtn.Visible = not minimized
	Line.Visible = not minimized
	HeaderFill.Visible = not minimized
	MinBtn.Text = minimized and "+" or "−"
	TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
		Size = minimized and UDim2.new(0, 240, 0, 46) or UDim2.new(0, 240, 0, 374),
	}):Play()
end)

local dragging, dragStart, startPos = false, nil, nil
Header.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = inp.Position
		startPos = Main.Position
		inp.Changed:Connect(function()
			if inp.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
UserInputService.InputChanged:Connect(function(inp)
	if not dragging then return end
	if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
		local d = inp.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

UserInputService.InputBegan:Connect(function(inp, gp)
	if listening then
		if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode ~= Enum.KeyCode.Unknown then
			State.keybind = inp.KeyCode
			KeyVal.Text = State.keybind.Name
			listening = false
			saveConfig()
		end
		return
	end
	if gp then return end
	if inp.KeyCode == State.keybind then
		doToggle()
	end
	if inp.KeyCode == Enum.KeyCode.RightControl or inp.KeyCode == Enum.KeyCode.Insert then
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)

LP.CharacterAdded:Connect(function()
	if State.autoBrainrot then
		task.wait(0.4)
		if not State.active then
			startBypass()
			setActiveVisual(true)
		else
			startBypass()
		end
	end
end)

setMode(State.isMobile)
setAutoVisual(State.autoBrainrot)
setActiveVisual(false)
refreshPower()

if State.autoBrainrot then
	startBypass()
	setActiveVisual(true)
end