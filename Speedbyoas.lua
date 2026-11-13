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

-- Colores
local C_BLACK = Color3.fromRGB(12, 12, 14)
local C_STROKE = Color3.fromRGB(45, 45, 50)
local C_HEADER = Color3.fromRGB(18, 18, 22)
local C_HAIRLINE = Color3.fromRGB(40, 40, 45)
local C_WHITE = Color3.new(1, 1, 1)
local C_GREY43 = Color3.fromRGB(130, 130, 140)
local C_BTNBG = Color3.fromRGB(22, 22, 26)
local C_BTNSTK = Color3.fromRGB(55, 55, 60)
local C_SEGSTK = Color3.fromRGB(60, 60, 70)
local C_BLUE = Color3.fromRGB(0, 130, 255)
local C_DIALSTK = Color3.fromRGB(0, 145, 255)
local C_DIALBG = Color3.fromRGB(16, 16, 20)
local C_GREY49 = Color3.fromRGB(140, 140, 150)
local C_GREY41 = Color3.fromRGB(120, 120, 130)
local C_BOXTXT = Color3.fromRGB(220, 220, 225)
local C_BOXBG = Color3.fromRGB(20, 20, 24)
local C_ROWBG = Color3.fromRGB(20, 20, 24)
local C_ROWSTK = Color3.fromRGB(50, 50, 55)
local C_KEYTXT = Color3.fromRGB(245, 245, 250)
local C_KEYBG = Color3.fromRGB(30, 30, 35)
local C_KEYSTK = Color3.fromRGB(55, 55, 60)
local C_OFFBG = Color3.fromRGB(35, 35, 40)
local C_ONBG = Color3.fromRGB(0, 130, 255)

local GUI_NAME = "SpeedBypassGui"

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
MainFrame.Position = UDim2.new(0.5, -95, 0.5, -118)
MainFrame.Size = UDim2.new(0, 190, 0, 235)
MainFrame.BackgroundColor3 = C_BLACK
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
corner(MainFrame, 14)
stroke(MainFrame, C_STROKE, 1.3)

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = MainFrame

local Body = Instance.new("Frame")
Body.Name = "Body"
Body.BackgroundTransparency = 1
Body.Position = UDim2.new(0, 0, 0, 32)
Body.Size = UDim2.new(1, 0, 1, -32)
Body.ZIndex = 1
Body.ClipsDescendants = true
Body.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.BackgroundColor3 = C_HEADER
Header.BorderSizePixel = 0
Header.Position = UDim2.new(0, 0, 0, 0)
Header.Size = UDim2.new(1, 0, 0, 32)
Header.ZIndex = 4
Header.Parent = MainFrame
corner(Header, 14)

local HeaderLine = Instance.new("Frame")
HeaderLine.BackgroundColor3 = C_HAIRLINE
HeaderLine.BorderSizePixel = 0
HeaderLine.Position = UDim2.new(0, 0, 1, -1)
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.ZIndex = 5
HeaderLine.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "SPEED BYPASS"
Title.TextColor3 = C_WHITE
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.ZIndex = 6
Title.Parent = Header

local HideBtn = Instance.new("TextButton")
HideBtn.Text = "Hide"
HideBtn.TextColor3 = C_GREY43
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 10
HideBtn.AutoButtonColor = false
HideBtn.BackgroundColor3 = C_BTNBG
HideBtn.BorderSizePixel = 0
HideBtn.Position = UDim2.new(1, -58, 0.5, -11)
HideBtn.Size = UDim2.new(0, 48, 0, 22)
HideBtn.ZIndex = 7
HideBtn.Parent = Header
corner(HideBtn, 7)
stroke(HideBtn, C_BTNSTK, 1)

-- Segmento PC / MOBILE
local Seg = Instance.new("Frame")
Seg.BackgroundColor3 = C_BTNBG
Seg.BorderSizePixel = 0
Seg.Position = UDim2.new(0, 12, 0, 10)
Seg.Size = UDim2.new(1, -24, 0, 26)
Seg.ZIndex = 4
Seg.Parent = Body
corner(Seg, 8)
stroke(Seg, C_SEGSTK, 1)

local SegPill = Instance.new("Frame")
SegPill.BackgroundColor3 = C_BLUE
SegPill.BorderSizePixel = 0
SegPill.Position = UDim2.new(0, 2, 0, 2)
SegPill.Size = UDim2.new(0.5, -3, 1, -4)
SegPill.ZIndex = 5
SegPill.Parent = Seg
corner(SegPill, 6)

local PCBtn = Instance.new("TextButton")
PCBtn.Text = "PC"
PCBtn.TextColor3 = C_WHITE
PCBtn.Font = Enum.Font.GothamMedium
PCBtn.TextSize = 11
PCBtn.BackgroundTransparency = 1
PCBtn.AutoButtonColor = false
PCBtn.Position = UDim2.new(0, 0, 0, 0)
PCBtn.Size = UDim2.new(0.5, 0, 1, 0)
PCBtn.ZIndex = 6
PCBtn.Parent = Seg

local MobileBtn = Instance.new("TextButton")
MobileBtn.Text = "MOBILE"
MobileBtn.TextColor3 = C_WHITE
MobileBtn.Font = Enum.Font.GothamMedium
MobileBtn.TextSize = 11
MobileBtn.BackgroundTransparency = 1
MobileBtn.AutoButtonColor = false
MobileBtn.Position = UDim2.new(0.5, 0, 0, 0)
MobileBtn.Size = UDim2.new(0.5, 0, 1, 0)
MobileBtn.ZIndex = 6
MobileBtn.Parent = Seg

-- Dial de potencia
local Dial = Instance.new("Frame")
Dial.BackgroundTransparency = 1
Dial.AnchorPoint = Vector2.new(0.5, 0)
Dial.Position = UDim2.new(0.5, 0, 0, 46)
Dial.Size = UDim2.new(0, 110, 0, 110)
Dial.ZIndex = 4
Dial.Parent = Body
corner(Dial, 55)

local DialStroke = Instance.new("UIStroke")
DialStroke.Thickness = 3.5
DialStroke.Color = C_DIALSTK
DialStroke.LineJoinMode = Enum.LineJoinMode.Round
DialStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
DialStroke.Parent = Dial

local DialGradient = Instance.new("UIGradient")
DialGradient.Rotation = 0
DialGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 25, 70)),
	ColorSequenceKeypoint.new(0.38, Color3.fromRGB(0, 80, 190)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 145, 255)),
	ColorSequenceKeypoint.new(0.62, Color3.fromRGB(0, 80, 190)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 25, 70)),
})
DialGradient.Parent = DialStroke

local DialInner = Instance.new("Frame")
DialInner.BackgroundColor3 = C_DIALBG
DialInner.BorderSizePixel = 0
DialInner.AnchorPoint = Vector2.new(0.5, 0.5)
DialInner.Position = UDim2.new(0.5, 0, 0.5, 0)
DialInner.Size = UDim2.new(1, -7, 1, -7)
DialInner.ZIndex = 4
DialInner.Parent = Dial
corner(DialInner, 52)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Text = "OFFLINE"
StatusLbl.TextColor3 = C_GREY49
StatusLbl.Font = Enum.Font.GothamBold
StatusLbl.TextSize = 10
StatusLbl.BackgroundTransparency = 1
StatusLbl.Position = UDim2.new(0, 0, 0, 12)
StatusLbl.Size = UDim2.new(1, 0, 0, 14)
StatusLbl.ZIndex = 5
StatusLbl.Parent = DialInner

local PowerLbl = Instance.new("TextLabel")
PowerLbl.Text = shortPower(State.Power)
PowerLbl.TextColor3 = C_WHITE
PowerLbl.Font = Enum.Font.GothamBlack
PowerLbl.TextSize = 26
PowerLbl.BackgroundTransparency = 1
PowerLbl.Position = UDim2.new(0, 0, 0, 28)
PowerLbl.Size = UDim2.new(1, 0, 0, 30)
PowerLbl.ZIndex = 5
PowerLbl.Parent = DialInner

local TimerLbl = Instance.new("TextLabel")
TimerLbl.Text = "00:00"
TimerLbl.TextColor3 = C_GREY41
TimerLbl.Font = Enum.Font.Gotham
TimerLbl.TextSize = 10
TimerLbl.BackgroundTransparency = 1
TimerLbl.Position = UDim2.new(0, 0, 0, 58)
TimerLbl.Size = UDim2.new(1, 0, 0, 14)
TimerLbl.ZIndex = 5
TimerLbl.Parent = DialInner

local PowerBox = Instance.new("TextBox")
PowerBox.Text = tostring(State.Power)
PowerBox.TextColor3 = C_BOXTXT
PowerBox.Font = Enum.Font.GothamBold
PowerBox.TextSize = 11
PowerBox.AnchorPoint = Vector2.new(0.5, 1)
PowerBox.Position = UDim2.new(0.5, 0, 1, -10)
PowerBox.Size = UDim2.new(0.7, 0, 0, 20)
PowerBox.BackgroundColor3 = C_BOXBG
PowerBox.BorderSizePixel = 0
PowerBox.ClearTextOnFocus = false
PowerBox.ZIndex = 6
PowerBox.Parent = DialInner
corner(PowerBox, 6)

-- Keybind
local KeyRow = Instance.new("Frame")
KeyRow.BackgroundColor3 = C_ROWBG
KeyRow.BorderSizePixel = 0
KeyRow.Position = UDim2.new(0, 12, 0, 165)
KeyRow.Size = UDim2.new(1, -24, 0, 26)
KeyRow.ZIndex = 4
KeyRow.Parent = Body
corner(KeyRow, 8)
stroke(KeyRow, C_ROWSTK, 1)

local KeyLbl = Instance.new("TextLabel")
KeyLbl.Text = "KEYBIND:"
KeyLbl.TextColor3 = C_GREY49
KeyLbl.Font = Enum.Font.GothamBold
KeyLbl.TextSize = 9
KeyLbl.BackgroundTransparency = 1
KeyLbl.TextXAlignment = Enum.TextXAlignment.Left
KeyLbl.Position = UDim2.new(0, 10, 0, 0)
KeyLbl.Size = UDim2.new(0, 55, 0, 26)
KeyLbl.ZIndex = 5
KeyLbl.Parent = KeyRow

local KeyBtn = Instance.new("TextButton")
KeyBtn.Text = State.Keybind.Name
KeyBtn.TextColor3 = C_KEYTXT
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 11
KeyBtn.AutoButtonColor = false
KeyBtn.BackgroundColor3 = C_KEYBG
KeyBtn.BorderSizePixel = 0
KeyBtn.Position = UDim2.new(1, -68, 0.5, -10)
KeyBtn.Size = UDim2.new(0, 58, 0, 20)
KeyBtn.ZIndex = 6
KeyBtn.Parent = KeyRow
corner(KeyBtn, 6)
stroke(KeyBtn, C_KEYSTK, 1)

-- ===================== BOTÓN ON/OFF (rectangular) =====================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = C_GREY43
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.AutoButtonColor = false
ToggleBtn.BackgroundColor3 = C_OFFBG
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0, 12, 0, 198)
ToggleBtn.Size = UDim2.new(1, -24, 0, 28)
ToggleBtn.ZIndex = 5
ToggleBtn.Parent = Body
corner(ToggleBtn, 9)
stroke(ToggleBtn, C_STROKE, 1.2)

-- ===================== MINI =====================
local MiniFrame = Instance.new("Frame")
MiniFrame.Name = "Mini"
MiniFrame.Active = true
MiniFrame.Visible = false
MiniFrame.ClipsDescendants = true
MiniFrame.Position = UDim2.new(0.5, -95, 0.5, -32)
MiniFrame.Size = UDim2.new(0, 190, 0, 64)
MiniFrame.BackgroundColor3 = C_BLACK
MiniFrame.BorderSizePixel = 0
MiniFrame.ZIndex = 40
MiniFrame.Parent = ScreenGui
corner(MiniFrame, 12)
stroke(MiniFrame, C_STROKE, 1.2)

local MiniHeader = Instance.new("Frame")
MiniHeader.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
MiniHeader.BorderSizePixel = 0
MiniHeader.Position = UDim2.new(0, 0, 0, 0)
MiniHeader.Size = UDim2.new(1, 0, 0, 26)
MiniHeader.ZIndex = 42
MiniHeader.Parent = MiniFrame
corner(MiniHeader, 12)

local MiniLbl = Instance.new("TextLabel")
MiniLbl.Text = "SPEED BYPASS"
MiniLbl.TextColor3 = C_WHITE
MiniLbl.Font = Enum.Font.GothamBold
MiniLbl.TextSize = 11
MiniLbl.BackgroundTransparency = 1
MiniLbl.TextXAlignment = Enum.TextXAlignment.Left
MiniLbl.Position = UDim2.new(0, 12, 0, 0)
MiniLbl.Size = UDim2.new(1, -70, 1, 0)
MiniLbl.ZIndex = 43
MiniLbl.Parent = MiniHeader

local UnhideBtn = Instance.new("TextButton")
UnhideBtn.Text = "Unhide"
UnhideBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
UnhideBtn.Font = Enum.Font.GothamBold
UnhideBtn.TextSize = 10
UnhideBtn.AutoButtonColor = false
UnhideBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
UnhideBtn.BorderSizePixel = 0
UnhideBtn.Position = UDim2.new(1, -58, 0.5, -10)
UnhideBtn.Size = UDim2.new(0, 50, 0, 20)
UnhideBtn.ZIndex = 44
UnhideBtn.Parent = MiniHeader
corner(UnhideBtn, 6)
stroke(UnhideBtn, Color3.fromRGB(55, 55, 60), 1)

local MiniToggle = Instance.new("TextButton")
MiniToggle.Name = "MiniToggle"
MiniToggle.Text = "OFF"
MiniToggle.TextColor3 = C_GREY43
MiniToggle.Font = Enum.Font.GothamBold
MiniToggle.TextSize = 12
MiniToggle.AutoButtonColor = false
MiniToggle.BackgroundColor3 = C_OFFBG
MiniToggle.BorderSizePixel = 0
MiniToggle.Position = UDim2.new(0, 10, 0, 32)
MiniToggle.Size = UDim2.new(1, -20, 0, 24)
MiniToggle.ZIndex = 42
MiniToggle.Parent = MiniFrame
corner(MiniToggle, 8)
stroke(MiniToggle, C_STROKE, 1)

-- ===================== LÓGICA =====================
local TW = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

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
		TweenService:Create(ToggleBtn, TW, {BackgroundColor3 = C_ONBG}):Play()
		TweenService:Create(MiniToggle, TW, {BackgroundColor3 = C_ONBG}):Play()
		startLag()
	else
		StatusLbl.Text = "OFFLINE"
		StatusLbl.TextColor3 = C_GREY49
		ToggleBtn.Text = "OFF"
		ToggleBtn.TextColor3 = C_GREY43
		MiniToggle.Text = "OFF"
		MiniToggle.TextColor3 = C_GREY43
		TimerLbl.Text = "00:00"
		TweenService:Create(ToggleBtn, TW, {BackgroundColor3 = C_OFFBG}):Play()
		TweenService:Create(MiniToggle, TW, {BackgroundColor3 = C_OFFBG}):Play()
		stopLag()
	end
end

local function setMode(mode)
	State.Mode = mode
	if mode == "PC" then
		TweenService:Create(SegPill, TW, {Position = UDim2.new(0, 2, 0, 2)}):Play()
		applyPower(97000)
	else
		TweenService:Create(SegPill, TW, {Position = UDim2.new(0.5, 1, 0, 2)}):Play()
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

HideBtn.Activated:Connect(function() setHidden(true) end)
UnhideBtn.Activated:Connect(function() setHidden(false) end)
PCBtn.Activated:Connect(function() setMode("PC") end)
MobileBtn.Activated:Connect(function() setMode("MOBILE") end)
ToggleBtn.Activated:Connect(function() setActive(not State.Active) end)
MiniToggle.Activated:Connect(function() setActive(not State.Active) end)

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

UserInputService.InputChanged:Connect(function(input)
	if not dragTarget then return end
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
	gradAccum = (gradAccum + 108 * dt) % 360
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
MainScale.Scale = 0.9
TweenService:Create(
	MainScale,
	TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{Scale = 1}
):Play()