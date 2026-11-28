print("Exe Speed Bypass loaded")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- Black / white / gray color scheme
local C_BG = Color3.fromRGB(0, 0, 0)
local C_PANEL = Color3.fromRGB(30, 30, 30)
local C_ROW = Color3.fromRGB(60, 60, 60)
local C_NEON = Color3.fromRGB(255, 255, 255)
local C_MINT = Color3.fromRGB(200, 200, 200)
local C_MID = Color3.fromRGB(120, 120, 120)
local C_DIM = Color3.fromRGB(80, 80, 80)
local C_EDGE = Color3.fromRGB(50, 50, 50)
local C_EDGE2 = Color3.fromRGB(100, 100, 100)

local GUI_NAME = "JK7 HUB"
local WM_NAME = "IrishWatermark" -- unused, kept for compatibility

-- Scaling factor for a smaller UI
local S = 0.8

local function safeParent()
	local ok, hidden = pcall(function()
		return (gethui and gethui()) or (get_hidden_gui and get_hidden_gui())
	end)
	if ok and typeof(hidden) == "Instance" then return hidden end
	if pcall(function() return CoreGui.Name end) then return CoreGui end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local Parent = safeParent()

-- Clean old instances
for _, v in ipairs(Parent:GetChildren()) do
	if v.Name == GUI_NAME then pcall(function() v:Destroy() end) end
end
pcall(function()
	local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if pg and pg:FindFirstChild(WM_NAME) then pg[WM_NAME]:Destroy() end
end)

local State = {
	Mode = "PC",
	Power = 97000,
	Active = false,
	Keybind = Enum.KeyCode.V,
	Binding = false,
	Hidden = false,
	Minimized = false,
	Locked = false,
}

local lagConn = nil
local lagAmount = 0.15

local function applyPower(val)
	State.Power = math.clamp(math.floor(val), 9000, 500000)
	local t = (State.Power - 10000) / 490000
	if t < 0 then t = 0 end
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

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = Parent

local function corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r * S)
	c.Parent = p
	return c
end

local function stroke(p, col, th)
	local s = Instance.new("UIStroke")
	s.Color = col
	s.Thickness = th * S
	s.Parent = p
	return s
end

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Active = true
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.5, -165 * S, 0.5, -150 * S)
Main.Size = UDim2.new(0, 330 * S, 0, 300 * S)
Main.BackgroundColor3 = C_BG
Main.BackgroundTransparency = 0
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
corner(Main, 28)

-- Background image copied from the supplied JK7 HUB CODE SNIPER script
local MainImg = Instance.new("ImageLabel")
MainImg.Name = "JK7HubBackground"
MainImg.Size = UDim2.new(1, 0, 1, 0)
MainImg.Position = UDim2.fromOffset(0, 0)
MainImg.BackgroundTransparency = 1
MainImg.BorderSizePixel = 0
MainImg.Image = "rbxthumb://type=Asset&id=118953269416540&w=420&h=420"
MainImg.ImageTransparency = 0.08
MainImg.ScaleType = Enum.ScaleType.Crop
MainImg.ZIndex = 1
MainImg.Parent = Main
corner(MainImg, 28)

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = Main

local MainStroke = stroke(Main, C_NEON, 3.2)

-- Title
local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Text = "JK7 HUB"
Title.TextSize = 19 * S
Title.TextColor3 = C_MINT
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 10
Title.Position = UDim2.new(0, 18 * S, 0, 12 * S)
Title.Size = UDim2.new(1, -105 * S, 0, 26 * S)
Title.Parent = Main

local SubTitle = Instance.new("TextLabel")
SubTitle.BackgroundTransparency = 1
SubTitle.Text = ""
SubTitle.TextSize = 10 * S
SubTitle.TextColor3 = C_DIM
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 10
SubTitle.Position = UDim2.new(0, 18 * S, 0, 38 * S)
SubTitle.Size = UDim2.new(1, -105 * S, 0, 14 * S)
SubTitle.Parent = Main

-- Lock / Unlock button (next to minimize)
local LockBtn = Instance.new("TextButton")
LockBtn.Position = UDim2.new(1, -74 * S, 0, 14 * S)
LockBtn.Size = UDim2.new(0, 28 * S, 0, 28 * S)
LockBtn.BackgroundColor3 = C_ROW
LockBtn.BorderSizePixel = 0
LockBtn.Text = "🔓"
LockBtn.TextColor3 = C_MID
LockBtn.TextSize = 13 * S
LockBtn.Font = Enum.Font.GothamBlack
LockBtn.AutoButtonColor = false
LockBtn.ZIndex = 10
LockBtn.Parent = Main
corner(LockBtn, 10)
stroke(LockBtn, C_EDGE, 1.5)

local MinBtn = Instance.new("TextButton")
MinBtn.Position = UDim2.new(1, -42 * S, 0, 14 * S)
MinBtn.Size = UDim2.new(0, 28 * S, 0, 28 * S)
MinBtn.BackgroundColor3 = C_ROW
MinBtn.BorderSizePixel = 0
MinBtn.Text = "-"
MinBtn.TextColor3 = C_MID
MinBtn.TextSize = 14 * S
MinBtn.Font = Enum.Font.GothamBlack
MinBtn.AutoButtonColor = false
MinBtn.ZIndex = 10
MinBtn.Parent = Main
corner(MinBtn, 10)
stroke(MinBtn, C_EDGE, 1.5)

local Divider = Instance.new("Frame")
Divider.Position = UDim2.new(0, 14 * S, 0, 64 * S)
Divider.Size = UDim2.new(1, -28 * S, 0, 1)
Divider.BackgroundColor3 = C_NEON
Divider.BorderSizePixel = 0
Divider.ZIndex = 10
Divider.Parent = Main

local Body = Instance.new("Frame")
Body.Position = UDim2.new(0, 14 * S, 0, 76 * S)
Body.Size = UDim2.new(1, -28 * S, 0, 260 * S)
Body.BackgroundTransparency = 1
Body.ZIndex = 7
Body.Parent = Main

local function makeRow(y, height, labelText)
	local row = Instance.new("Frame")
	row.Position = UDim2.new(0, 0, 0, y * S)
	row.Size = UDim2.new(1, 0, 0, height * S)
	row.BackgroundColor3 = C_PANEL
	row.BackgroundTransparency = 0.18
	row.BorderSizePixel = 0
	row.ZIndex = 8
	row.Parent = Body
	corner(row, 14)
	stroke(row, C_EDGE, 1.2)


	local tick = Instance.new("Frame")
	tick.Position = UDim2.new(0, 0, 0.5, -14 * S)
	tick.Size = UDim2.new(0, 3, 0, 28 * S)
	tick.BackgroundColor3 = C_NEON
	tick.BorderSizePixel = 0
	tick.ZIndex = 9
	tick.Parent = row
	corner(tick, 4)

	local lbl = Instance.new("TextLabel")
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextSize = 12 * S
	lbl.TextColor3 = C_MID
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 9
	lbl.Position = UDim2.new(0, 16 * S, 0, 0)
	lbl.Size = UDim2.new(0.42, 0, 1, 0)
	lbl.Parent = row

	return row
end

local ModeRow = makeRow(0, 44, "Mode")

local PCBtn = Instance.new("TextButton")
PCBtn.Position = UDim2.new(1, -186 * S, 0.5, -14 * S)
PCBtn.Size = UDim2.new(0, 84 * S, 0, 28 * S)
PCBtn.BackgroundColor3 = C_NEON
PCBtn.BorderSizePixel = 0
PCBtn.Text = "PC"
PCBtn.TextColor3 = C_BG
PCBtn.TextSize = 11 * S
PCBtn.Font = Enum.Font.GothamBold
PCBtn.AutoButtonColor = false
PCBtn.ZIndex = 9
PCBtn.Parent = ModeRow
corner(PCBtn, 10)
stroke(PCBtn, C_EDGE, 1.5)

local MobileBtn = Instance.new("TextButton")
MobileBtn.Position = UDim2.new(1, -96 * S, 0.5, -14 * S)
MobileBtn.Size = UDim2.new(0, 88 * S, 0, 28 * S)
MobileBtn.BackgroundColor3 = C_ROW
MobileBtn.BorderSizePixel = 0
MobileBtn.Text = "MOBILE"
MobileBtn.TextColor3 = C_DIM
MobileBtn.TextSize = 11 * S
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.AutoButtonColor = false
MobileBtn.ZIndex = 9
MobileBtn.Parent = ModeRow
corner(MobileBtn, 10)
stroke(MobileBtn, C_EDGE, 1.5)

local PowerRow = makeRow(54, 44, "Power")

local PowerBox = Instance.new("TextBox")
PowerBox.Position = UDim2.new(1, -112 * S, 0.5, -14 * S)
PowerBox.Size = UDim2.new(0, 104 * S, 0, 28 * S)
PowerBox.BackgroundColor3 = C_BG
PowerBox.BorderSizePixel = 0
PowerBox.Text = tostring(State.Power)
PowerBox.TextColor3 = C_MINT
PowerBox.TextSize = 12 * S
PowerBox.Font = Enum.Font.GothamBold
PowerBox.PlaceholderText = "Power"
PowerBox.PlaceholderColor3 = C_DIM
PowerBox.ClearTextOnFocus = false
PowerBox.ZIndex = 9
PowerBox.Parent = PowerRow
corner(PowerBox, 10)
stroke(PowerBox, C_EDGE2, 1.5)

local BypassRow = makeRow(108, 56, "Bypass")

-- GUI Size row (visual scaling only; does not alter bypass logic)
local GuiSizeRow = makeRow(172, 44, "GUI Size")
local GuiSizeBox = Instance.new("TextBox")
GuiSizeBox.Position = UDim2.new(1, -92 * S, 0.5, -14 * S)
GuiSizeBox.Size = UDim2.new(0, 46 * S, 0, 28 * S)
GuiSizeBox.BackgroundTransparency = 1 -- remove the rectangle around the percentage
GuiSizeBox.BorderSizePixel = 0
GuiSizeBox.Text = "100%"
GuiSizeBox.TextColor3 = C_MINT
GuiSizeBox.TextSize = 11 * S
GuiSizeBox.Font = Enum.Font.GothamBold
GuiSizeBox.PlaceholderText = "%"
GuiSizeBox.PlaceholderColor3 = C_DIM
GuiSizeBox.ClearTextOnFocus = false
GuiSizeBox.TextXAlignment = Enum.TextXAlignment.Center
GuiSizeBox.ZIndex = 9
GuiSizeBox.Parent = GuiSizeRow

local GuiSizeMinus = Instance.new("TextButton")
GuiSizeMinus.Name = "GuiSizeMinus"
GuiSizeMinus.Position = UDim2.new(1, -132 * S, 0.5, -13 * S)
GuiSizeMinus.Size = UDim2.new(0, 24 * S, 0, 26 * S)
GuiSizeMinus.BackgroundColor3 = C_ROW
GuiSizeMinus.BorderSizePixel = 0
GuiSizeMinus.Text = "-"
GuiSizeMinus.TextColor3 = C_MINT
GuiSizeMinus.TextSize = 15 * S
GuiSizeMinus.Font = Enum.Font.GothamBold
GuiSizeMinus.AutoButtonColor = false
GuiSizeMinus.ZIndex = 9
GuiSizeMinus.Parent = GuiSizeRow
corner(GuiSizeMinus, 7)

local GuiSizePlus = Instance.new("TextButton")
GuiSizePlus.Name = "GuiSizePlus"
GuiSizePlus.Position = UDim2.new(1, -40 * S, 0.5, -13 * S)
GuiSizePlus.Size = UDim2.new(0, 24 * S, 0, 26 * S)
GuiSizePlus.BackgroundColor3 = C_ROW
GuiSizePlus.BorderSizePixel = 0
GuiSizePlus.Text = "+"
GuiSizePlus.TextColor3 = C_MINT
GuiSizePlus.TextSize = 15 * S
GuiSizePlus.Font = Enum.Font.GothamBold
GuiSizePlus.AutoButtonColor = false
GuiSizePlus.ZIndex = 9
GuiSizePlus.Parent = GuiSizeRow
corner(GuiSizePlus, 7)


local KeyBtn = Instance.new("TextButton")
KeyBtn.Position = UDim2.new(1, -182 * S, 0.5, -18 * S)
KeyBtn.Size = UDim2.new(0, 60 * S, 0, 36 * S)
KeyBtn.BackgroundColor3 = C_ROW
KeyBtn.BorderSizePixel = 0
KeyBtn.Text = State.Keybind.Name
KeyBtn.TextColor3 = C_MID
KeyBtn.TextSize = 13 * S
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.AutoButtonColor = false
KeyBtn.ZIndex = 9
KeyBtn.Parent = BypassRow
corner(KeyBtn, 12)
stroke(KeyBtn, C_EDGE, 1.8)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Position = UDim2.new(1, -116 * S, 0.5, -18 * S)
ToggleBtn.Size = UDim2.new(0, 108 * S, 0, 36 * S)
ToggleBtn.BackgroundColor3 = C_ROW
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = C_MID
ToggleBtn.TextSize = 13 * S
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.AutoButtonColor = false
ToggleBtn.ZIndex = 9
ToggleBtn.Parent = BypassRow
corner(ToggleBtn, 12)
stroke(ToggleBtn, C_EDGE, 1.8)

-- Mini
local Mini = Instance.new("Frame")
Mini.Name = "Mini"
Mini.Active = true
Mini.Visible = false
Mini.ClipsDescendants = true
Mini.Position = UDim2.new(0.5, -165 * S, 0.5, -33 * S)
Mini.Size = UDim2.new(0, 330 * S, 0, 66 * S)
Mini.BackgroundColor3 = C_BG
Mini.BorderSizePixel = 0
Mini.Parent = ScreenGui
corner(Mini, 28)

local MiniImg = Instance.new("ImageLabel")
MiniImg.Name = "JK7HubMiniBackground"
MiniImg.Size = UDim2.new(1, 0, 1, 0)
MiniImg.Position = UDim2.fromOffset(0, 0)
MiniImg.BackgroundTransparency = 1
MiniImg.BorderSizePixel = 0
MiniImg.Image = "rbxthumb://type=Asset&id=118953269416540&w=420&h=420"
MiniImg.ImageTransparency = 0.08
MiniImg.ScaleType = Enum.ScaleType.Crop
MiniImg.ZIndex = 1
MiniImg.Parent = Mini
corner(MiniImg, 28)

local MiniScale = Instance.new("UIScale")
MiniScale.Scale = 1
MiniScale.Parent = Mini

local MiniStroke = stroke(Mini, C_NEON, 3.2)

local MiniLbl = Instance.new("TextLabel")
MiniLbl.BackgroundTransparency = 1
MiniLbl.Text = "JK7 HUB"
MiniLbl.TextSize = 13 * S
MiniLbl.TextColor3 = C_MINT
MiniLbl.Font = Enum.Font.GothamBlack
MiniLbl.TextXAlignment = Enum.TextXAlignment.Left
MiniLbl.ZIndex = 8
MiniLbl.Position = UDim2.new(0, 18 * S, 0, 0)
MiniLbl.Size = UDim2.new(1, -70 * S, 1, 0)
MiniLbl.Parent = Mini

local MaxBtn = Instance.new("TextButton")
MaxBtn.Position = UDim2.new(1, -42 * S, 0.5, -14 * S)
MaxBtn.Size = UDim2.new(0, 28 * S, 0, 28 * S)
MaxBtn.BackgroundColor3 = C_ROW
MaxBtn.BorderSizePixel = 0
MaxBtn.Text = "+"
MaxBtn.TextColor3 = C_MID
MaxBtn.TextSize = 16 * S
MaxBtn.Font = Enum.Font.GothamBlack
MaxBtn.AutoButtonColor = false
MaxBtn.ZIndex = 8
MaxBtn.Parent = Mini
corner(MaxBtn, 10)
stroke(MaxBtn, C_EDGE, 1.5)

-- WATERMARK REMOVED (no floating label above player)

-- =========================================================

local function setActive(on)
	State.Active = on

	if on then
		ToggleBtn.Text = "ACTIVE"
		ToggleBtn.BackgroundColor3 = C_NEON
		ToggleBtn.TextColor3 = C_BG
		startLag()
	else
		ToggleBtn.Text = "OFF"
		ToggleBtn.BackgroundColor3 = C_ROW
		ToggleBtn.TextColor3 = C_MID
		stopLag()
	end

	-- No bell sound
end

local function updateBypassLayout()
	if State.Mode == "MOBILE" then
		KeyBtn.Visible = false
		ToggleBtn.Position = UDim2.new(1, -182 * S, 0.5, -18 * S)
		ToggleBtn.Size = UDim2.new(0, 174 * S, 0, 36 * S)
	else
		KeyBtn.Visible = true
		ToggleBtn.Position = UDim2.new(1, -116 * S, 0.5, -18 * S)
		ToggleBtn.Size = UDim2.new(0, 108 * S, 0, 36 * S)
	end
end

local function setMode(mode)
	State.Mode = mode
	if mode == "PC" then
		PCBtn.BackgroundColor3 = C_NEON
		PCBtn.TextColor3 = C_BG
		MobileBtn.BackgroundColor3 = C_ROW
		MobileBtn.TextColor3 = C_DIM
		applyPower(97000)
		PowerBox.Text = tostring(State.Power)
	else
		MobileBtn.BackgroundColor3 = C_NEON
		MobileBtn.TextColor3 = C_BG
		PCBtn.BackgroundColor3 = C_ROW
		PCBtn.TextColor3 = C_DIM
		applyPower(72000)
		PowerBox.Text = tostring(State.Power)
	end
	updateBypassLayout()
	if State.Active then
		stopLag()
		startLag()
	end
end

PCBtn.MouseButton1Click:Connect(function() setMode("PC") end)
MobileBtn.MouseButton1Click:Connect(function() setMode("MOBILE") end)

ToggleBtn.MouseButton1Click:Connect(function()
	setActive(not State.Active)
end)

PowerBox.FocusLost:Connect(function()
	local n = tonumber(PowerBox.Text)
	if n and n > 0 then
		applyPower(n)
	end
	PowerBox.Text = tostring(State.Power)
	if State.Active then
		stopLag()
		startLag()
	end
end)

KeyBtn.MouseButton1Click:Connect(function()
	State.Binding = true
	KeyBtn.Text = "..."
end)

local GuiScalePercent = 100
local function setGuiScale(percent)
	GuiScalePercent = math.clamp(math.floor(percent + 0.5), 60, 140)
	local scale = GuiScalePercent / 100
	MainScale.Scale = scale
	MiniScale.Scale = scale
	GuiSizeBox.Text = tostring(GuiScalePercent) .. "%"
end

local function setMinimized(on)
	State.Minimized = on
	if on then
		Mini.Position = Main.Position
		Main.Visible = false
		MiniScale.Scale = GuiScalePercent / 100
		Mini.Visible = true
	else
		Main.Position = Mini.Position
		Mini.Visible = false
		MainScale.Scale = GuiScalePercent / 100
		Main.Visible = true
	end
end

-- Lock / Unlock handling
local dragTarget, dragStart, dragOrigin = nil, nil, nil
local function setLocked(on)
	State.Locked = on
	if on then
		LockBtn.Text = "🔒"
		LockBtn.BackgroundColor3 = C_ROW
		LockBtn.TextColor3 = C_MINT
		dragTarget = nil
	else
		LockBtn.Text = "🔓"
		LockBtn.BackgroundColor3 = C_ROW
		LockBtn.TextColor3 = C_MID
	end
end

LockBtn.MouseButton1Click:Connect(function()
	setLocked(not State.Locked)
end)

GuiSizeBox.FocusLost:Connect(function()
	local percent = tonumber((GuiSizeBox.Text:gsub("%%", "")))
	if percent then
		setGuiScale(percent)
	else
		GuiSizeBox.Text = tostring(GuiScalePercent) .. "%"
	end
end)

GuiSizeMinus.MouseButton1Click:Connect(function()
	setGuiScale(GuiScalePercent - 10)
end)

GuiSizePlus.MouseButton1Click:Connect(function()
	setGuiScale(GuiScalePercent + 10)
end)

MinBtn.MouseButton1Click:Connect(function() setMinimized(true) end)
MaxBtn.MouseButton1Click:Connect(function() setMinimized(false) end)

local function hookDrag(frame, moveTarget)
	frame.InputBegan:Connect(function(input)
		if State.Locked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragTarget = moveTarget
			dragStart = Vector2.new(input.Position.X, input.Position.Y)
			dragOrigin = moveTarget.Position
		end
	end)
end

hookDrag(Main, Main)
hookDrag(Mini, Mini)

UserInputService.InputChanged:Connect(function(input)
	if not dragTarget then return end
	if State.Locked then
		dragTarget = nil
		return
	end
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
	elseif input.KeyCode == Enum.KeyCode.LeftControl then
		State.Hidden = not State.Hidden
		ScreenGui.Enabled = not State.Hidden
	end
end)

ScreenGui.Destroying:Connect(function()
	stopLag()
end)

setMode("PC")
updateBypassLayout()
MinBtn.Visible = true

MainScale.Scale = GuiScalePercent / 100
MiniScale.Scale = GuiScalePercent / 100