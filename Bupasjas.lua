print("Leaked by Neymarish")
print("Leaked by Neymarish")
print("Leaked by Neymarish")
print("Leaked by Neymarish")
print("Leaked by Neymarish")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Colores premium
local C_BG = Color3.fromRGB(10, 10, 12)
local C_STROKE = Color3.fromRGB(50, 50, 58)
local C_HEADER = Color3.fromRGB(16, 16, 20)
local C_LINE = Color3.fromRGB(38, 38, 45)
local C_WHITE = Color3.fromRGB(255, 255, 255)
local C_MUTED = Color3.fromRGB(140, 140, 155)
local C_CARD = Color3.fromRGB(18, 18, 22)
local C_BTN = Color3.fromRGB(26, 26, 32)
local C_BTN_STK = Color3.fromRGB(55, 55, 65)
local C_BLUE = Color3.fromRGB(0, 140, 255)
local C_OFF = Color3.fromRGB(32, 32, 38)
local C_ON = Color3.fromRGB(0, 140, 255)
local C_LOCK = Color3.fromRGB(255, 190, 60)
local C_TEXT = Color3.fromRGB(230, 230, 240)

local GUI_NAME = "StickBypassGui"

for _, v in ipairs(PlayerGui:GetChildren()) do
	if v.Name == GUI_NAME then pcall(function() v:Destroy() end) end
end

local State = {
	Mode = "PC",
	Power = 97000,
	Active = false,
	Keybind = Enum.KeyCode.V,
	Binding = false,
	Hidden = false,
	Locked = false,
	StartTime = 0,
}

local lagConn = nil
local lagAmount = 0.15

local function applyPower(val)
	State.Power = math.clamp(math.floor(val), 10000, 500000)
	local t = (State.Power - 10000) / 490000
	lagAmount = t * 0.2
end
applyPower(State.Power)

local function startLag()
	if lagConn then lagConn:Disconnect() end
	lagConn = RunService.RenderStepped:Connect(function()
		if not State.Active then return end
		if lagAmount > 0 then
			local t = tick()
			while tick() - t < lagAmount do end
		end
	end)
end

local function stopLag()
	if lagConn then
		lagConn:Disconnect()
		lagConn = nil
	end
end

local function corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = p
	return c
end

local function stroke(p, col, th)
	local s = Instance.new("UIStroke")
	s.Color = col
	s.Thickness = th
	s.Transparency = 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = p
	return s
end

local function shortPower(n)
	if n >= 1000 then
		local k = n / 1000
		if k % 1 == 0 then
			return string.format("%dK", k)
		end
		return string.format("%.1fK", k)
	end
	return tostring(n)
end

-- ===================== GUI PRINCIPAL =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Position = UDim2.new(0.5, -112, 0.5, -145)
MainFrame.Size = UDim2.new(0, 224, 0, 290)
MainFrame.BackgroundColor3 = C_BG
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
corner(MainFrame, 16)
stroke(MainFrame, C_STROKE, 1.4)

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.BackgroundColor3 = C_HEADER
Header.BorderSizePixel = 0
Header.Position = UDim2.new(0, 0, 0, 0)
Header.Size = UDim2.new(1, 0, 0, 38)
Header.ZIndex = 5
Header.Parent = MainFrame
corner(Header, 16)

local HeaderBottom = Instance.new("Frame")
HeaderBottom.BackgroundColor3 = C_HEADER
HeaderBottom.BorderSizePixel = 0
HeaderBottom.Position = UDim2.new(0, 0, 0.5, 0)
HeaderBottom.Size = UDim2.new(1, 0, 0.5, 0)
HeaderBottom.ZIndex = 5
HeaderBottom.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.BackgroundColor3 = C_LINE
HeaderLine.BorderSizePixel = 0
HeaderLine.Position = UDim2.new(0, 0, 1, -1)
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.ZIndex = 6
HeaderLine.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "STICK BYPASS"
Title.TextColor3 = C_WHITE
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 14, 0, 0)
Title.Size = UDim2.new(1, -110, 1, 0)
Title.ZIndex = 7
Title.Parent = Header

-- Candado
local LockBtn = Instance.new("TextButton")
LockBtn.Name = "LockBtn"
LockBtn.Text = "🔓"
LockBtn.TextColor3 = C_MUTED
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextSize = 15
LockBtn.AutoButtonColor = false
LockBtn.BackgroundColor3 = C_BTN
LockBtn.BorderSizePixel = 0
LockBtn.Position = UDim2.new(1, -98, 0.5, -13)
LockBtn.Size = UDim2.new(0, 30, 0, 26)
LockBtn.ZIndex = 8
LockBtn.Parent = Header
corner(LockBtn, 8)
stroke(LockBtn, C_BTN_STK, 1)

-- Hide
local HideBtn = Instance.new("TextButton")
HideBtn.Text = "Hide"
HideBtn.TextColor3 = C_MUTED
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 11
HideBtn.AutoButtonColor = false
HideBtn.BackgroundColor3 = C_BTN
HideBtn.BorderSizePixel = 0
HideBtn.Position = UDim2.new(1, -62, 0.5, -13)
HideBtn.Size = UDim2.new(0, 50, 0, 26)
HideBtn.ZIndex = 8
HideBtn.Parent = Header
corner(HideBtn, 8)
stroke(HideBtn, C_BTN_STK, 1)

-- Body
local Body = Instance.new("Frame")
Body.Name = "Body"
Body.BackgroundTransparency = 1
Body.Position = UDim2.new(0, 0, 0, 38)
Body.Size = UDim2.new(1, 0, 1, -38)
Body.ZIndex = 2
Body.Parent = MainFrame

-- Segmento PC / MOBILE
local Seg = Instance.new("Frame")
Seg.BackgroundColor3 = C_CARD
Seg.BorderSizePixel = 0
Seg.Position = UDim2.new(0, 14, 0, 14)
Seg.Size = UDim2.new(1, -28, 0, 30)
Seg.ZIndex = 4
Seg.Parent = Body
corner(Seg, 9)
stroke(Seg, C_STROKE, 1)

local SegPill = Instance.new("Frame")
SegPill.BackgroundColor3 = C_BLUE
SegPill.BorderSizePixel = 0
SegPill.Position = UDim2.new(0, 3, 0, 3)
SegPill.Size = UDim2.new(0.5, -4, 1, -6)
SegPill.ZIndex = 5
SegPill.Parent = Seg
corner(SegPill, 7)

local PCBtn = Instance.new("TextButton")
PCBtn.Text = "PC"
PCBtn.TextColor3 = C_WHITE
PCBtn.Font = Enum.Font.GothamBold
PCBtn.TextSize = 12
PCBtn.BackgroundTransparency = 1
PCBtn.AutoButtonColor = false
PCBtn.Position = UDim2.new(0, 0, 0, 0)
PCBtn.Size = UDim2.new(0.5, 0, 1, 0)
PCBtn.ZIndex = 6
PCBtn.Parent = Seg

local MobileBtn = Instance.new("TextButton")
MobileBtn.Text = "MOBILE"
MobileBtn.TextColor3 = C_WHITE
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.TextSize = 12
MobileBtn.BackgroundTransparency = 1
MobileBtn.AutoButtonColor = false
MobileBtn.Position = UDim2.new(0.5, 0, 0, 0)
MobileBtn.Size = UDim2.new(0.5, 0, 1, 0)
MobileBtn.ZIndex = 6
MobileBtn.Parent = Seg

-- Dial
local Dial = Instance.new("Frame")
Dial.BackgroundTransparency = 1
Dial.AnchorPoint = Vector2.new(0.5, 0)
Dial.Position = UDim2.new(0.5, 0, 0, 54)
Dial.Size = UDim2.new(0, 124, 0, 124)
Dial.ZIndex = 4
Dial.Parent = Body
corner(Dial, 62)

local DialStroke = Instance.new("UIStroke")
DialStroke.Thickness = 4
DialStroke.Color = C_BLUE
DialStroke.LineJoinMode = Enum.LineJoinMode.Round
DialStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
DialStroke.Parent = Dial

local DialGradient = Instance.new("UIGradient")
DialGradient.Rotation = 0
DialGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 30, 80)),
	ColorSequenceKeypoint.new(0.35, Color3.fromRGB(0, 90, 210)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 160, 255)),
	ColorSequenceKeypoint.new(0.65, Color3.fromRGB(0, 90, 210)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 30, 80)),
})
DialGradient.Parent = DialStroke

local DialInner = Instance.new("Frame")
DialInner.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
DialInner.BorderSizePixel = 0
DialInner.AnchorPoint = Vector2.new(0.5, 0.5)
DialInner.Position = UDim2.new(0.5, 0, 0.5, 0)
DialInner.Size = UDim2.new(1, -8, 1, -8)
DialInner.ZIndex = 4
DialInner.Parent = Dial
corner(DialInner, 58)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Text = "OFFLINE"
StatusLbl.TextColor3 = C_MUTED
StatusLbl.Font = Enum.Font.GothamBold
StatusLbl.TextSize = 11
StatusLbl.BackgroundTransparency = 1
StatusLbl.Position = UDim2.new(0, 0, 0, 16)
StatusLbl.Size = UDim2.new(1, 0, 0, 14)
StatusLbl.ZIndex = 5
StatusLbl.Parent = DialInner

local PowerLbl = Instance.new("TextLabel")
PowerLbl.Text = shortPower(State.Power)
PowerLbl.TextColor3 = C_WHITE
PowerLbl.Font = Enum.Font.GothamBlack
PowerLbl.TextSize = 30
PowerLbl.BackgroundTransparency = 1
PowerLbl.Position = UDim2.new(0, 0, 0, 32)
PowerLbl.Size = UDim2.new(1, 0, 0, 34)
PowerLbl.ZIndex = 5
PowerLbl.Parent = DialInner

local TimerLbl = Instance.new("TextLabel")
TimerLbl.Text = "00:00"
TimerLbl.TextColor3 = C_MUTED
TimerLbl.Font = Enum.Font.Gotham
TimerLbl.TextSize = 12
TimerLbl.BackgroundTransparency = 1
TimerLbl.Position = UDim2.new(0, 0, 0, 66)
TimerLbl.Size = UDim2.new(1, 0, 0, 14)
TimerLbl.ZIndex = 5
TimerLbl.Parent = DialInner

local PowerBox = Instance.new("TextBox")
PowerBox.Text = tostring(State.Power)
PowerBox.TextColor3 = C_TEXT
PowerBox.Font = Enum.Font.GothamBold
PowerBox.TextSize = 12
PowerBox.AnchorPoint = Vector2.new(0.5, 1)
PowerBox.Position = UDim2.new(0.5, 0, 1, -12)
PowerBox.Size = UDim2.new(0.68, 0, 0, 22)
PowerBox.BackgroundColor3 = C_BTN
PowerBox.BorderSizePixel = 0
PowerBox.ClearTextOnFocus = false
PowerBox.ZIndex = 6
PowerBox.Parent = DialInner
corner(PowerBox, 7)
stroke(PowerBox, C_BTN_STK, 1)

-- Keybind
local KeyRow = Instance.new("Frame")
KeyRow.BackgroundColor3 = C_CARD
KeyRow.BorderSizePixel = 0
KeyRow.Position = UDim2.new(0, 14, 0, 190)
KeyRow.Size = UDim2.new(1, -28, 0, 32)
KeyRow.ZIndex = 4
KeyRow.Parent = Body
corner(KeyRow, 9)
stroke(KeyRow, C_STROKE, 1)

local KeyLbl = Instance.new("TextLabel")
KeyLbl.Text = "KEYBIND"
KeyLbl.TextColor3 = C_MUTED
KeyLbl.Font = Enum.Font.GothamBold
KeyLbl.TextSize = 11
KeyLbl.BackgroundTransparency = 1
KeyLbl.TextXAlignment = Enum.TextXAlignment.Left
KeyLbl.Position = UDim2.new(0, 14, 0, 0)
KeyLbl.Size = UDim2.new(0, 70, 0, 32)
KeyLbl.ZIndex = 5
KeyLbl.Parent = KeyRow

local KeyBtn = Instance.new("TextButton")
KeyBtn.Text = State.Keybind.Name
KeyBtn.TextColor3 = C_WHITE
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 13
KeyBtn.AutoButtonColor = false
KeyBtn.BackgroundColor3 = C_BTN
KeyBtn.BorderSizePixel = 0
KeyBtn.Position = UDim2.new(1, -74, 0.5, -12)
KeyBtn.Size = UDim2.new(0, 60, 0, 24)
KeyBtn.ZIndex = 6
KeyBtn.Parent = KeyRow
corner(KeyBtn, 7)
stroke(KeyBtn, C_BTN_STK, 1)

-- BOTÓN ON/OFF grande y bien visible
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = C_MUTED
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 15
ToggleBtn.AutoButtonColor = false
ToggleBtn.BackgroundColor3 = C_OFF
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0, 14, 0, 234)
ToggleBtn.Size = UDim2.new(1, -28, 0, 36)
ToggleBtn.ZIndex = 5
ToggleBtn.Parent = Body
corner(ToggleBtn, 11)
stroke(ToggleBtn, C_STROKE, 1.3)

-- ===================== MINI =====================
local MiniFrame = Instance.new("Frame")
MiniFrame.Name = "Mini"
MiniFrame.Active = true
MiniFrame.Visible = false
MiniFrame.ClipsDescendants = true
MiniFrame.Position = UDim2.new(0.5, -112, 0.5, -40)
MiniFrame.Size = UDim2.new(0, 224, 0, 80)
MiniFrame.BackgroundColor3 = C_BG
MiniFrame.BorderSizePixel = 0
MiniFrame.ZIndex = 40
MiniFrame.Parent = ScreenGui
corner(MiniFrame, 14)
stroke(MiniFrame, C_STROKE, 1.3)

local MiniHeader = Instance.new("Frame")
MiniHeader.BackgroundColor3 = C_HEADER
MiniHeader.BorderSizePixel = 0
MiniHeader.Position = UDim2.new(0, 0, 0, 0)
MiniHeader.Size = UDim2.new(1, 0, 0, 34)
MiniHeader.ZIndex = 42
MiniHeader.Parent = MiniFrame
corner(MiniHeader, 14)

local MiniHeaderBottom = Instance.new("Frame")
MiniHeaderBottom.BackgroundColor3 = C_HEADER
MiniHeaderBottom.BorderSizePixel = 0
MiniHeaderBottom.Position = UDim2.new(0, 0, 0.5, 0)
MiniHeaderBottom.Size = UDim2.new(1, 0, 0.5, 0)
MiniHeaderBottom.ZIndex = 42
MiniHeaderBottom.Parent = MiniHeader

local MiniLbl = Instance.new("TextLabel")
MiniLbl.Text = "STICK BYPASS"
MiniLbl.TextColor3 = C_WHITE
MiniLbl.Font = Enum.Font.GothamBlack
MiniLbl.TextSize = 13
MiniLbl.BackgroundTransparency = 1
MiniLbl.TextXAlignment = Enum.TextXAlignment.Left
MiniLbl.Position = UDim2.new(0, 12, 0, 0)
MiniLbl.Size = UDim2.new(1, -110, 1, 0)
MiniLbl.ZIndex = 43
MiniLbl.Parent = MiniHeader

-- Candado en mini (al lado de Unhide)
local MiniLockBtn = Instance.new("TextButton")
MiniLockBtn.Name = "MiniLockBtn"
MiniLockBtn.Text = "🔓"
MiniLockBtn.TextColor3 = C_MUTED
MiniLockBtn.Font = Enum.Font.GothamBold
MiniLockBtn.TextSize = 14
MiniLockBtn.AutoButtonColor = false
MiniLockBtn.BackgroundColor3 = C_BTN
MiniLockBtn.BorderSizePixel = 0
MiniLockBtn.Position = UDim2.new(1, -98, 0.5, -12)
MiniLockBtn.Size = UDim2.new(0, 28, 0, 24)
MiniLockBtn.ZIndex = 44
MiniLockBtn.Parent = MiniHeader
corner(MiniLockBtn, 7)
stroke(MiniLockBtn, C_BTN_STK, 1)

local UnhideBtn = Instance.new("TextButton")
UnhideBtn.Text = "Unhide"
UnhideBtn.TextColor3 = C_MUTED
UnhideBtn.Font = Enum.Font.GothamBold
UnhideBtn.TextSize = 11
UnhideBtn.AutoButtonColor = false
UnhideBtn.BackgroundColor3 = C_BTN
UnhideBtn.BorderSizePixel = 0
UnhideBtn.Position = UDim2.new(1, -64, 0.5, -12)
UnhideBtn.Size = UDim2.new(0, 52, 0, 24)
UnhideBtn.ZIndex = 44
UnhideBtn.Parent = MiniHeader
corner(UnhideBtn, 7)
stroke(UnhideBtn, C_BTN_STK, 1)

-- Toggle grande en mini
local MiniToggle = Instance.new("TextButton")
MiniToggle.Name = "MiniToggle"
MiniToggle.Text = "OFF"
MiniToggle.TextColor3 = C_MUTED
MiniToggle.Font = Enum.Font.GothamBlack
MiniToggle.TextSize = 14
MiniToggle.AutoButtonColor = false
MiniToggle.BackgroundColor3 = C_OFF
MiniToggle.BorderSizePixel = 0
MiniToggle.Position = UDim2.new(0, 12, 0, 40)
MiniToggle.Size = UDim2.new(1, -24, 0, 30)
MiniToggle.ZIndex = 42
MiniToggle.Parent = MiniFrame
corner(MiniToggle, 9)
stroke(MiniToggle, C_STROKE, 1.2)

-- ===================== LÓGICA =====================
local TW = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function setActive(on)
	State.Active = on
	if on then
		State.StartTime = os.clock()
		StatusLbl.Text = "ONLINE"
		StatusLbl.TextColor3 = C_BLUE
		ToggleBtn.Text = "ON"
		ToggleBtn.TextColor3 = C_WHITE
		MiniToggle.Text = "ON"
		MiniToggle.TextColor3 = C_WHITE
		TweenService:Create(ToggleBtn, TW, {BackgroundColor3 = C_ON}):Play()
		TweenService:Create(MiniToggle, TW, {BackgroundColor3 = C_ON}):Play()
		startLag()
	else
		StatusLbl.Text = "OFFLINE"
		StatusLbl.TextColor3 = C_MUTED
		ToggleBtn.Text = "OFF"
		ToggleBtn.TextColor3 = C_MUTED
		MiniToggle.Text = "OFF"
		MiniToggle.TextColor3 = C_MUTED
		TimerLbl.Text = "00:00"
		TweenService:Create(ToggleBtn, TW, {BackgroundColor3 = C_OFF}):Play()
		TweenService:Create(MiniToggle, TW, {BackgroundColor3 = C_OFF}):Play()
		stopLag()
	end
end

local function setMode(mode)
	State.Mode = mode
	if mode == "PC" then
		TweenService:Create(SegPill, TW, {Position = UDim2.new(0, 3, 0, 3)}):Play()
		applyPower(97000)
	else
		TweenService:Create(SegPill, TW, {Position = UDim2.new(0.5, 1, 0, 3)}):Play()
		applyPower(72000)
	end
	PowerBox.Text = tostring(State.Power)
	PowerLbl.Text = shortPower(State.Power)
	if State.Active then
		stopLag()
		startLag()
	end
end

local function setPower(n)
	applyPower(n)
	PowerBox.Text = tostring(State.Power)
	PowerLbl.Text = shortPower(State.Power)
	if State.Active then
		stopLag()
		startLag()
	end
end

local function setHidden(on)
	State.Hidden = on
	if on then
		MiniFrame.Position = MainFrame.Position
		MainFrame.Visible = false
		MiniFrame.Visible = true
	else
		MainFrame.Position = MiniFrame.Position
		MiniFrame.Visible = false
		MainFrame.Visible = true
	end
end

local function setLocked(on)
	State.Locked = on
	if on then
		LockBtn.Text = "🔒"
		LockBtn.TextColor3 = C_LOCK
		MiniLockBtn.Text = "🔒"
		MiniLockBtn.TextColor3 = C_LOCK
	else
		LockBtn.Text = "🔓"
		LockBtn.TextColor3 = C_MUTED
		MiniLockBtn.Text = "🔓"
		MiniLockBtn.TextColor3 = C_MUTED
	end
end

HideBtn.Activated:Connect(function() setHidden(true) end)
UnhideBtn.Activated:Connect(function() setHidden(false) end)
PCBtn.Activated:Connect(function() setMode("PC") end)
MobileBtn.Activated:Connect(function() setMode("MOBILE") end)
ToggleBtn.Activated:Connect(function() setActive(not State.Active) end)
MiniToggle.Activated:Connect(function() setActive(not State.Active) end)
LockBtn.Activated:Connect(function() setLocked(not State.Locked) end)
MiniLockBtn.Activated:Connect(function() setLocked(not State.Locked) end)

PowerBox.FocusLost:Connect(function()
	local n = tonumber(PowerBox.Text)
	if n and n > 0 then
		setPower(n)
	else
		PowerBox.Text = tostring(State.Power)
	end
end)

KeyBtn.Activated:Connect(function()
	State.Binding = true
	KeyBtn.Text = "..."
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	if State.Binding then
		if input.KeyCode == Enum.KeyCode.Unknown then return end
		State.Binding = false
		if input.KeyCode ~= Enum.KeyCode.Escape then
			State.Keybind = input.KeyCode
		end
		KeyBtn.Text = State.Keybind.Name
		return
	end
	if gpe then return end
	if input.KeyCode == State.Keybind then
		setActive(not State.Active)
	elseif input.KeyCode == Enum.KeyCode.RightControl then
		setHidden(not State.Hidden)
	end
end)

-- Drag
local dragTarget, dragStart, dragOrigin
local function hookDrag(frame, target)
	frame.InputBegan:Connect(function(input)
		if State.Locked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragTarget = target
			dragStart = Vector2.new(input.Position.X, input.Position.Y)
			dragOrigin = target.Position
		end
	end)
end
hookDrag(MainFrame, MainFrame)
hookDrag(MiniFrame, MiniFrame)
hookDrag(Header, MainFrame)
hookDrag(MiniHeader, MiniFrame)

UserInputService.InputChanged:Connect(function(input)
	if not dragTarget or State.Locked then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement
	and input.UserInputType ~= Enum.UserInputType.Touch then return end
	local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
	dragTarget.Position = UDim2.new(
		dragOrigin.X.Scale, math.floor(dragOrigin.X.Offset + delta.X),
		dragOrigin.Y.Scale, math.floor(dragOrigin.Y.Offset + delta.Y)
	)
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragTarget = nil
	end
end)

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)
	if State.Active then
		stopLag()
		startLag()
	end
end)

local gradAccum = 0
RunService.RenderStepped:Connect(function(dt)
	gradAccum = (gradAccum + 110 * dt) % 360
	DialGradient.Rotation = gradAccum
	if State.Active then
		local elapsed = os.clock() - State.StartTime
		local mins = math.floor(elapsed / 60)
		local secs = math.floor(elapsed % 60)
		TimerLbl.Text = string.format("%02d:%02d", mins, secs)
	end
end)

ScreenGui.Destroying:Connect(function()
	stopLag()
end)

setMode("PC")
MainFrame.Visible = true
MainScale.Scale = 0.88
TweenService:Create(
	MainScale,
	TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{Scale = 1}
):Play()