-- Clean by Prince Bot | .gg/freesource
print("[VENOT] Packet Lagger loaded")

local __VENOT_NET_OK = false

task.spawn(function()
	pcall(function()

pcall(function() 

task.spawn(function()
pcall(function()
end)
end)

        end)

	end)
	__VENOT_NET_OK = true
end)

local function __qwrRequireNet()
	return __VENOT_NET_OK == true
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local CONFIG_FILE = "VENOT_Lagger_Config.json"

local BG     = Color3.fromRGB(8, 8, 10)
local INPUT  = Color3.fromRGB(18, 18, 20)
local WHITE  = Color3.fromRGB(245, 245, 248)
local DIM    = Color3.fromRGB(150, 150, 158)
local BLACK  = Color3.fromRGB(0, 0, 0)
local OFF_BG = Color3.fromRGB(22, 22, 26)
local ON_BG  = Color3.fromRGB(36, 36, 42)
local HOVER  = Color3.fromRGB(40, 40, 48)
local SEL_BG = Color3.fromRGB(48, 48, 56)

local function tween(obj, props, t)
	TweenService:Create(obj, TweenInfo.new(t or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

pcall(function()
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then
		local old = pg:FindFirstChild("VENOTPacketLagger") or pg:FindFirstChild("VENOTPacketLagger")
		if old then old:Destroy() end
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "VENOTPacketLagger"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = LP:WaitForChild("PlayerGui")

local W, H = 230, 285
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, W, 0, H)
Main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
Main.BackgroundColor3 = BG
Main.BorderSizePixel = 0
Main.ClipsDescendants = false
Main.Active = true
Main.Parent = gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local uiScale = Instance.new("UIScale", Main)
uiScale.Scale = 1
local uiScaleValue = 1.00

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = BLACK
MainStroke.Thickness = 2
MainStroke.Transparency = 0
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local Title = Instance.new("TextLabel", Main)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 10)
Title.Size = UDim2.new(1, -70, 0, 18)
Title.Text = "VENOT PACKET LAGGER"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = WHITE
Title.ZIndex = 3

local underLine = Instance.new("Frame", Main)
underLine.Size = UDim2.new(1, -24, 0, 1)
underLine.Position = UDim2.new(0, 12, 0, 32)
underLine.BackgroundColor3 = WHITE
underLine.BackgroundTransparency = 0.15
underLine.BorderSizePixel = 0
underLine.ZIndex = 3
Instance.new("UICorner", underLine).CornerRadius = UDim.new(1, 0)

local CollapseBtn = Instance.new("TextButton", Main)
CollapseBtn.Size = UDim2.new(0, 20, 0, 20)
CollapseBtn.Position = UDim2.new(1, -28, 0, 10)
CollapseBtn.BackgroundColor3 = INPUT
CollapseBtn.BorderSizePixel = 0
CollapseBtn.Text = "−"
CollapseBtn.Font = Enum.Font.GothamBlack
CollapseBtn.TextSize = 14
CollapseBtn.TextColor3 = WHITE
CollapseBtn.AutoButtonColor = false
CollapseBtn.ZIndex = 10
Instance.new("UICorner", CollapseBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", CollapseBtn).Color = BLACK

local LockBtn = Instance.new("TextButton", Main)
LockBtn.Name = "LockBtn"
LockBtn.Size = UDim2.new(0, 22, 0, 22)
LockBtn.Position = UDim2.new(1, -54, 0, 9)
LockBtn.BackgroundColor3 = INPUT
LockBtn.BorderSizePixel = 0
LockBtn.Text = "🔓"
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextSize = 14
LockBtn.TextColor3 = WHITE
LockBtn.AutoButtonColor = false
LockBtn.Active = true
LockBtn.ZIndex = 30
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", LockBtn).Color = BLACK
local LOCK_ICON = "🔒"
local UNLOCK_ICON = "🔓"

local ModeRow = Instance.new("Frame", Main)
ModeRow.Position = UDim2.new(0, 12, 0, 42)
ModeRow.Size = UDim2.new(1, -24, 0, 26)
ModeRow.BackgroundTransparency = 1
ModeRow.ZIndex = 5

local MobileBtn = Instance.new("TextButton", ModeRow)
MobileBtn.Size = UDim2.new(0.48, 0, 1, 0)
MobileBtn.BackgroundColor3 = INPUT
MobileBtn.BorderSizePixel = 0
MobileBtn.Text = "MOBILE"
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.TextSize = 10
MobileBtn.TextColor3 = WHITE
MobileBtn.AutoButtonColor = false
MobileBtn.ZIndex = 6
Instance.new("UICorner", MobileBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MobileBtn).Color = BLACK

local PcBtn = Instance.new("TextButton", ModeRow)
PcBtn.Size = UDim2.new(0.48, 0, 1, 0)
PcBtn.Position = UDim2.new(0.52, 0, 0, 0)
PcBtn.BackgroundColor3 = INPUT
PcBtn.BorderSizePixel = 0
PcBtn.Text = "PC"
PcBtn.Font = Enum.Font.GothamBold
PcBtn.TextSize = 10
PcBtn.TextColor3 = WHITE
PcBtn.AutoButtonColor = false
PcBtn.ZIndex = 6
Instance.new("UICorner", PcBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", PcBtn).Color = BLACK

local PowerLbl = Instance.new("TextLabel", Main)
PowerLbl.BackgroundTransparency = 1
PowerLbl.Position = UDim2.new(0, 12, 0, 74)
PowerLbl.Size = UDim2.new(1, -24, 0, 12)
PowerLbl.Text = "POWER"
PowerLbl.Font = Enum.Font.GothamBold
PowerLbl.TextSize = 9
PowerLbl.TextXAlignment = Enum.TextXAlignment.Left
PowerLbl.TextColor3 = DIM
PowerLbl.ZIndex = 3

local PowerBox = Instance.new("TextBox", Main)
PowerBox.Position = UDim2.new(0, 12, 0, 88)
PowerBox.Size = UDim2.new(1, -24, 0, 30)
PowerBox.BackgroundColor3 = INPUT
PowerBox.BorderSizePixel = 0
PowerBox.Text = "16000"
PowerBox.PlaceholderText = "power"
PowerBox.Font = Enum.Font.GothamBold
PowerBox.TextSize = 13
PowerBox.TextColor3 = WHITE
PowerBox.PlaceholderColor3 = DIM
PowerBox.ClearTextOnFocus = false
PowerBox.ZIndex = 5
Instance.new("UICorner", PowerBox).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", PowerBox).Color = BLACK

local KeyLbl = Instance.new("TextLabel", Main)
KeyLbl.BackgroundTransparency = 1
KeyLbl.Position = UDim2.new(0, 12, 0, 126)
KeyLbl.Size = UDim2.new(1, -24, 0, 12)
KeyLbl.Text = "KEYBOARD"
KeyLbl.Font = Enum.Font.GothamBold
KeyLbl.TextSize = 9
KeyLbl.TextXAlignment = Enum.TextXAlignment.Left
KeyLbl.TextColor3 = DIM
KeyLbl.ZIndex = 3

local KeyBtn = Instance.new("TextButton", Main)
KeyBtn.Position = UDim2.new(0, 12, 0, 140)
KeyBtn.Size = UDim2.new(1, -24, 0, 30)
KeyBtn.BackgroundColor3 = INPUT
KeyBtn.BorderSizePixel = 0
KeyBtn.Text = "[ Q ]"
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 12
KeyBtn.TextColor3 = WHITE
KeyBtn.AutoButtonColor = false
KeyBtn.ZIndex = 5
Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", KeyBtn).Color = BLACK

local StartBtn = Instance.new("TextButton", Main)
StartBtn.Name = "ToggleBtn"
StartBtn.Position = UDim2.new(0, 12, 0, 182)
StartBtn.Size = UDim2.new(1, -24, 0, 34)
StartBtn.BackgroundColor3 = OFF_BG
StartBtn.BorderSizePixel = 0
StartBtn.Text = "START"
StartBtn.Font = Enum.Font.GothamBlack
StartBtn.TextSize = 13
StartBtn.TextColor3 = WHITE
StartBtn.AutoButtonColor = false
StartBtn.Active = true
StartBtn.ZIndex = 50
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 10)
local stStroke = Instance.new("UIStroke", StartBtn)
stStroke.Color = BLACK
stStroke.Thickness = 2
stStroke.Transparency = 0

local ScaleLbl = Instance.new("TextLabel", Main)
ScaleLbl.BackgroundTransparency = 1
ScaleLbl.Position = UDim2.new(0, 12, 0, 220)
ScaleLbl.Size = UDim2.new(1, -24, 0, 12)
ScaleLbl.Text = "UI SIZE"
ScaleLbl.Font = Enum.Font.GothamBold
ScaleLbl.TextSize = 9
ScaleLbl.TextXAlignment = Enum.TextXAlignment.Left
ScaleLbl.TextColor3 = DIM
ScaleLbl.ZIndex = 3

local ScaleRow = Instance.new("Frame", Main)
ScaleRow.Name = "ScaleRow"
ScaleRow.Position = UDim2.new(0, 12, 0, 234)
ScaleRow.Size = UDim2.new(1, -24, 0, 28)
ScaleRow.BackgroundTransparency = 1
ScaleRow.ZIndex = 5

local ScaleMinus = Instance.new("TextButton", ScaleRow)
ScaleMinus.Size = UDim2.new(0, 36, 1, 0)
ScaleMinus.BackgroundColor3 = INPUT
ScaleMinus.BorderSizePixel = 0
ScaleMinus.Text = "−"
ScaleMinus.Font = Enum.Font.GothamBlack
ScaleMinus.TextSize = 16
ScaleMinus.TextColor3 = WHITE
ScaleMinus.AutoButtonColor = false
ScaleMinus.ZIndex = 6
Instance.new("UICorner", ScaleMinus).CornerRadius = UDim.new(0, 7)
Instance.new("UIStroke", ScaleMinus).Color = BLACK

local ScaleLabel = Instance.new("TextLabel", ScaleRow)
ScaleLabel.Size = UDim2.new(1, -80, 1, 0)
ScaleLabel.Position = UDim2.new(0, 40, 0, 0)
ScaleLabel.BackgroundColor3 = INPUT
ScaleLabel.BorderSizePixel = 0
ScaleLabel.Text = "100%"
ScaleLabel.Font = Enum.Font.GothamBold
ScaleLabel.TextSize = 12
ScaleLabel.TextColor3 = WHITE
ScaleLabel.ZIndex = 6
Instance.new("UICorner", ScaleLabel).CornerRadius = UDim.new(0, 7)
Instance.new("UIStroke", ScaleLabel).Color = BLACK

local ScalePlus = Instance.new("TextButton", ScaleRow)
ScalePlus.Size = UDim2.new(0, 36, 1, 0)
ScalePlus.Position = UDim2.new(1, -36, 0, 0)
ScalePlus.BackgroundColor3 = INPUT
ScalePlus.BorderSizePixel = 0
ScalePlus.Text = "+"
ScalePlus.Font = Enum.Font.GothamBlack
ScalePlus.TextSize = 16
ScalePlus.TextColor3 = WHITE
ScalePlus.AutoButtonColor = false
ScalePlus.ZIndex = 6
Instance.new("UICorner", ScalePlus).CornerRadius = UDim.new(0, 7)
Instance.new("UIStroke", ScalePlus).Color = BLACK

local lagging = false
local lagThread = nil
local intensity = 16000
local toggleKey = Enum.KeyCode.Q
local toggleKeyName = "Q"
local listeningForKey = false
local clickLock = false
local selectedMode = "PC"
local uiLocked = false
local dragging, dragStart, startPos = false, nil, nil
local saveConfig

local function clampPower(v)
	v = tonumber(v)
	if not v then return intensity end
	return math.clamp(math.floor(v), 1, 150000)
end

local function updatePower()
	intensity = clampPower(PowerBox.Text)
	PowerBox.Text = tostring(intensity)
end

local function setPower(v)
	intensity = clampPower(v)
	PowerBox.Text = tostring(intensity)
end

local function paintMode()
	if selectedMode == "MOBILE" then
		MobileBtn.BackgroundColor3 = SEL_BG
		PcBtn.BackgroundColor3 = INPUT
	else
		PcBtn.BackgroundColor3 = SEL_BG
		MobileBtn.BackgroundColor3 = INPUT
	end
end

local function applyUiScale(v)
	uiScaleValue = math.clamp(math.floor(v * 100 + 0.5) / 100, 0.70, 1.60)
	uiScale.Scale = uiScaleValue
	ScaleLabel.Text = string.format("%d%%", math.floor(uiScaleValue * 100 + 0.5))
end

local function applyKeybind(name)
	toggleKeyName = name or "Q"
	local ok, key = pcall(function() return Enum.KeyCode[toggleKeyName] end)
	toggleKey = (ok and key) or Enum.KeyCode.Q
	KeyBtn.Text = "[ " .. toggleKeyName .. " ]"
end

saveConfig = function()
	updatePower()
	pcall(function()
		if writefile then
			writefile(CONFIG_FILE, HttpService:JSONEncode({
				Power = intensity,
				Keybind = toggleKeyName,
				Mode = selectedMode,
				Scale = uiScaleValue,
				Locked = uiLocked,
				PX_S = Main.Position.X.Scale, PX_O = Main.Position.X.Offset,
				PY_S = Main.Position.Y.Scale, PY_O = Main.Position.Y.Offset,
			}))
		end
	end)
end

local function loadConfig()
	if not (readfile and isfile and isfile(CONFIG_FILE)) then return end
	local ok, cfg = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
	if not (ok and type(cfg) == "table") then return end
	if tonumber(cfg.Power) then
		intensity = clampPower(cfg.Power)
		PowerBox.Text = tostring(intensity)
	end
	if type(cfg.Keybind) == "string" and cfg.Keybind ~= "" then
		applyKeybind(cfg.Keybind)
	end
	if cfg.Mode == "MOBILE" or cfg.Mode == "PC" then
		selectedMode = cfg.Mode
		paintMode()
	end
	if tonumber(cfg.Scale) then
		applyUiScale(tonumber(cfg.Scale))
	end
	if cfg.Locked == true then
		uiLocked = true
	end

end

local Event
local function resolveEvent()
	local ok, net = pcall(function()
		local packages = RS:FindFirstChild("Packages") or RS:WaitForChild("Packages", 2)
		if not packages then return nil end
		return packages:FindFirstChild("Net") or packages:WaitForChild("Net", 2)
	end)
	if ok and net then
		Event = net:GetChildren()[230]
	end
	return Event
end
resolveEvent()

local function paintOn()
	StartBtn.Text = "STOP"
	StartBtn.TextColor3 = WHITE
	StartBtn.BackgroundColor3 = ON_BG
	stStroke.Color = BLACK
end

local function paintOff()
	StartBtn.Text = "START"
	StartBtn.TextColor3 = WHITE
	StartBtn.BackgroundColor3 = OFF_BG
	stStroke.Color = BLACK
end

local function startLagging()
	if lagging then return end
	if not __VENOT_NET_OK then
		local t0 = os.clock()
		while not __VENOT_NET_OK and os.clock() - t0 < 0.45 do
			task.wait(0.05)
		end
	end
	if not __qwrRequireNet() then
		warn("[VENOT] Net integrity offline — rejoin / do not remove packet layer")
		paintOff()
		return
	end
	updatePower()
	lagging = true
	paintOn()
	if not Event then resolveEvent() end
	if not Event then
		warn("[VENOT] Event not found")
		return
	end
	local payload = table.create(intensity, function() end)
	lagThread = task.spawn(function()
		while lagging do
			for _ = 1, 3 do
				pcall(function() Event:FireServer(payload) end)
			end
			task.wait(0.01)
		end
	end)
end

local function stopLagging()
	if not lagging then return end
	lagging = false
	if lagThread then
		pcall(task.cancel, lagThread)
		lagThread = nil
	end
	paintOff()
end

local function toggleLag()
	if clickLock then return end
	clickLock = true
	if lagging then stopLagging() else startLagging() end
	task.delay(0.12, function() clickLock = false end)
end

local function selectMobile()
	selectedMode = "MOBILE"
	setPower(10000)
	paintMode()
	saveConfig()
end

local function selectPC()
	selectedMode = "PC"
	setPower(16000)
	paintMode()
	saveConfig()
end

local function paintLock()
	if uiLocked then
		LockBtn.Text = LOCK_ICON
		LockBtn.BackgroundColor3 = SEL_BG
	else
		LockBtn.Text = UNLOCK_ICON
		LockBtn.BackgroundColor3 = INPUT
	end
end

local function toggleLock()
	uiLocked = not uiLocked
	if uiLocked then
		dragging = false
	end
	paintLock()
	saveConfig()
end

LockBtn.MouseButton1Click:Connect(toggleLock)
LockBtn.Activated:Connect(toggleLock)
LockBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		toggleLock()
	end
end)

MobileBtn.MouseButton1Click:Connect(selectMobile)
MobileBtn.Activated:Connect(selectMobile)
PcBtn.MouseButton1Click:Connect(selectPC)
PcBtn.Activated:Connect(selectPC)

ScaleMinus.MouseButton1Click:Connect(function()
	applyUiScale(uiScaleValue - 0.10)
	saveConfig()
end)
ScaleMinus.Activated:Connect(function()
	applyUiScale(uiScaleValue - 0.10)
	saveConfig()
end)
ScalePlus.MouseButton1Click:Connect(function()
	applyUiScale(uiScaleValue + 0.10)
	saveConfig()
end)
ScalePlus.Activated:Connect(function()
	applyUiScale(uiScaleValue + 0.10)
	saveConfig()
end)

PowerBox.FocusLost:Connect(function()
	updatePower()
	saveConfig()
end)

StartBtn.MouseButton1Click:Connect(toggleLag)
StartBtn.Activated:Connect(toggleLag)
StartBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		toggleLag()
	end
end)

StartBtn.MouseEnter:Connect(function()
	if not lagging then tween(StartBtn, {BackgroundColor3 = HOVER}, 0.1) end
end)
StartBtn.MouseLeave:Connect(function()
	StartBtn.BackgroundColor3 = lagging and ON_BG or OFF_BG
	StartBtn.TextColor3 = WHITE
end)

KeyBtn.MouseButton1Click:Connect(function()
	if listeningForKey then return end
	listeningForKey = true
	KeyBtn.Text = "press key..."
end)
KeyBtn.Activated:Connect(function()
	if listeningForKey then return end
	listeningForKey = true
	KeyBtn.Text = "press key..."
end)

UIS.InputBegan:Connect(function(input, gpe)
	if listeningForKey then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			listeningForKey = false
			applyKeybind(input.KeyCode.Name)
			KeyBtn.BackgroundColor3 = INPUT
			saveConfig()
		end
		return
	end
	if gpe then return end
	if input.KeyCode == toggleKey then
		toggleLag()
	end
end)

local collapsed = false
local FULL_H = H
local MINI_H_OPEN = 92
local animating = false

CollapseBtn.MouseButton1Click:Connect(function()
	if animating then return end
	collapsed = not collapsed
	animating = true

	if collapsed then
		CollapseBtn.Text = "+"
		ModeRow.Visible = false
		PowerLbl.Visible = false
		PowerBox.Visible = false
		KeyLbl.Visible = false
		KeyBtn.Visible = false
		ScaleRow.Visible = false
		ScaleLbl.Visible = false

		Title.Visible = true
		underLine.Visible = true
		StartBtn.Visible = true
		underLine.Position = UDim2.new(0, 12, 0, 32)
		StartBtn.Position = UDim2.new(0, 12, 0, 42)
		StartBtn.Size = UDim2.new(1, -24, 0, 40)
		StartBtn.TextSize = 14

		local tw = TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, W, 0, MINI_H_OPEN),
		})
		tw:Play()
		tw.Completed:Wait()
		animating = false
	else
		CollapseBtn.Text = "−"
		Title.Visible = true
		underLine.Visible = true
		StartBtn.Visible = true
		ModeRow.Visible = false
		PowerLbl.Visible = false
		PowerBox.Visible = false
		KeyLbl.Visible = false
		KeyBtn.Visible = false
		ScaleRow.Visible = false
		ScaleLbl.Visible = false

		local tw = TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, W, 0, FULL_H),
		})
		tw:Play()
		tw.Completed:Wait()

		underLine.Position = UDim2.new(0, 12, 0, 32)
		StartBtn.Position = UDim2.new(0, 12, 0, 182)
		StartBtn.Size = UDim2.new(1, -24, 0, 34)
		StartBtn.TextSize = 13
		ModeRow.Visible = true
		PowerLbl.Visible = true
		PowerBox.Visible = true
		KeyLbl.Visible = true
		KeyBtn.Visible = true
		ScaleRow.Visible = true
		ScaleLbl.Visible = true
		animating = false
	end
end)

Title.InputBegan:Connect(function(input)
	if uiLocked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)
UIS.InputChanged:Connect(function(input)
	if not dragging or uiLocked then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
	local d = input.Position - dragStart
	Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if dragging then
			dragging = false
			saveConfig()
		end
	end
end)

Main.Size = UDim2.new(0, W, 0, 0)
Main.BackgroundTransparency = 1
task.defer(function()
	loadConfig()
	paintMode()
	Main.Position = UDim2.new(0.5, -W * uiScaleValue / 2, 0.5, -H * uiScaleValue / 2)
	paintLock()
end)
tween(Main, {Size = UDim2.new(0, W, 0, FULL_H), BackgroundTransparency = 0}, 0.25)
paintOff()
paintMode()
paintLock()
Main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
print("[VENOT] Ready · key=" .. toggleKeyName)