repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local env = (type(getgenv) == "function" and getgenv()) or _G

-- ============ CLEANUP ANCIENNE INSTANCE ============
pcall(function()
	local old = PlayerGui:FindFirstChild("WaveAntiBatUI")
	if old then old:Destroy() end
end)
pcall(function()
	local prev = env.__WAVE_ANTIBAT_RUNTIME
	if type(prev) == "table" and type(prev.destroy) == "function" then prev.destroy() end
end)

local runtime = { alive = true }
env.__WAVE_ANTIBAT_RUNTIME = runtime
local conns = {}
local function track(c)
	table.insert(conns, c)
	return c
end

-- ============ CONFIG ============
local ANTI_BAT_POWER = 7000
local INF_JUMP_SPEED = 50
local SLIDER_MIN, SLIDER_MAX = 50, 120

local state = {
	AntiBat = false,
	InfJump = false,
	Scale = 81,
}
local antiTpKey = Enum.KeyCode.Five
local bindingKey = false

local THEMES = {
	{ name = "Weather", image = "rbxasset://textures/OLeebFt7dopXKY.png" },
	{ name = "Ember",   image = "rbxasset://textures/DPcYZGy0M2ksSoR.png" },
	{ name = "Kira",    image = "rbxasset://textures/G7bSihbekl.png" },
	{ name = "Jolyne",  image = "rbxasset://textures/7SpXAZD.png" },
}
local DEFAULT_BG = "rbxasset://textures/67vQDF3.png"

-- ============ LOGIQUE ANTI BAT (Gotham) ============
local function antiBatStep()
	if not state.AntiBat then return end
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local vel = root.AssemblyLinearVelocity
	local y = vel.Y
	local origXZ = Vector3.new(vel.X, 0, vel.Z)
	root.AssemblyLinearVelocity = Vector3.new(ANTI_BAT_POWER, y, ANTI_BAT_POWER)
	RunService.RenderStepped:Wait()
	if root.Parent then
		root.AssemblyLinearVelocity = Vector3.new(origXZ.X, root.AssemblyLinearVelocity.Y, origXZ.Z)
	end
end

local function antiRagdollStep()
	if not state.AntiBat then return end
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if hum then
		local st = hum:GetState()
		if st == Enum.HumanoidStateType.Physics
			or st == Enum.HumanoidStateType.Ragdoll
			or st == Enum.HumanoidStateType.FallingDown then
			hum:ChangeState(Enum.HumanoidStateType.Running)
			workspace.CurrentCamera.CameraSubject = hum
			pcall(function()
				local pm = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
				if pm then require(pm:FindFirstChild("ControlModule")):Enable() end
			end)
			if root then
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
			end
		end
	end
	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("Motor6D") and not obj.Enabled then
			obj.Enabled = true
		end
	end
end

-- ============ LOGIQUE INF JUMP (Gotham) ============
local OFF_POS = Vector3.new(0, -1000, 0)
local ijPlatform = Instance.new("Part")
ijPlatform.Name = "InfJumpPlatform"
ijPlatform.Size = Vector3.new(8, 0.5, 8)
ijPlatform.Anchored = true
ijPlatform.CanCollide = true
ijPlatform.Transparency = 1
ijPlatform.Material = Enum.Material.ForceField
ijPlatform.Position = OFF_POS
ijPlatform.Parent = workspace

local function infJumpStep()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not (state.InfJump and root and hum) then
		ijPlatform.Position = OFF_POS
		return
	end
	local jumping = UserInputService:IsKeyDown(Enum.KeyCode.Space)
		or hum:GetState() == Enum.HumanoidStateType.Jumping
		or hum.Jump
	if jumping then
		ijPlatform.Position = root.Position - Vector3.new(0, 3.5, 0)
		local v = root.AssemblyLinearVelocity
		if v.Y < INF_JUMP_SPEED then
			root.AssemblyLinearVelocity = Vector3.new(v.X, INF_JUMP_SPEED, v.Z)
		end
	else
		ijPlatform.Position = OFF_POS
	end
end

track(RunService.Heartbeat:Connect(antiBatStep))
track(RunService.Heartbeat:Connect(antiRagdollStep))
track(RunService.Heartbeat:Connect(infJumpStep))

-- ============ HELPERS UI ============
local BLUE = Color3.fromRGB(45, 130, 230)
local DARK_BLUE = Color3.fromRGB(25, 90, 185)
local NAVY = Color3.fromRGB(8, 18, 48)
local HEADER_BG = Color3.fromRGB(5, 12, 35)
local BTN = Color3.fromRGB(10, 22, 55)
local BTN_ON = Color3.fromRGB(20, 45, 100)
local WHITE = Color3.fromRGB(240, 245, 255)
local FONT_HEAVY = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)

local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do
		o[k] = v
	end
	if parent then o.Parent = parent end
	return o
end

local function corner(parent, r)
	return new("UICorner", { CornerRadius = UDim.new(0, r or 8) }, parent)
end

local function stroke(parent, color, thick)
	return new("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = color or DARK_BLUE,
		Thickness = thick or 1.5,
	}, parent)
end

local function makeButton(parent, text, pos, size)
	local b = new("TextButton", {
		BackgroundColor3 = BTN,
		BackgroundTransparency = 0.42,
		BorderSizePixel = 0,
		Position = pos,
		Size = size,
		ZIndex = 4,
		AutoButtonColor = false,
		FontFace = FONT_HEAVY,
		Text = text,
		TextColor3 = WHITE,
		TextSize = 12,
	}, parent)
	corner(b, 8)
	stroke(b, DARK_BLUE, 1)
	return b
end

-- ============ GUI ============
local Gui = new("ScreenGui", {
	Name = "WaveAntiBatUI",
	ResetOnSpawn = false,
	DisplayOrder = 2147483647,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, PlayerGui)

-- Panneau principal
local Panel = new("Frame", {
	Name = "AntiBatPanel",
	Active = true,
	BackgroundColor3 = NAVY,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Position = UDim2.new(0, 772, 0, 339),
	Size = UDim2.new(0, 230, 0, 186),
}, Gui)
corner(Panel, 14)
stroke(Panel, DARK_BLUE, 1.5)
local PanelScale = new("UIScale", { Scale = state.Scale / 100 }, Panel)

local BgImage = new("ImageLabel", {
	Name = "BackgroundImage",
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 1, 0),
	ZIndex = 0,
	Image = DEFAULT_BG,
	ImageTransparency = 0.18,
	ScaleType = Enum.ScaleType.Crop,
}, Panel)
corner(BgImage, 14)

local Shade = new("Frame", {
	Name = "BackgroundShade",
	BackgroundColor3 = NAVY,
	BackgroundTransparency = 0.28,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 1, 0),
}, Panel)
corner(Shade, 14)

-- Header (zone de drag + engrenage)
local Header = new("Frame", {
	Name = "Header",
	Active = true,
	BackgroundColor3 = HEADER_BG,
	BackgroundTransparency = 0.42,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 28),
	ZIndex = 3,
}, Panel)
corner(Header, 14)

local HeaderLine = new("Frame", {
	BackgroundColor3 = BLUE,
	BackgroundTransparency = 0.18,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 12, 1, -3),
	Size = UDim2.new(1, -24, 0, 2),
	ZIndex = 4,
}, Header)
corner(HeaderLine, 1)

new("TextLabel", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 12, 0, 1),
	Size = UDim2.new(1, -50, 0, 24),
	ZIndex = 4,
	FontFace = FONT_HEAVY,
	Text = "WAVE ANTI BAT",
	TextColor3 = BLUE,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

local GearBtn = new("TextButton", {
	Name = "SizeSettingsButton",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(1, -34, 0, 2),
	Size = UDim2.new(0, 28, 0, 24),
	ZIndex = 6,
	AutoButtonColor = false,
	Text = "",
}, Header)

local GearIcon = new("ImageLabel", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 19, 0, 19),
	ZIndex = 7,
	Image = "rbxasset://textures/ui/Settings/MenuBarIcons/GameSettingsTab.png",
	ImageColor3 = BLUE,
	ScaleType = Enum.ScaleType.Fit,
}, GearBtn)

-- Page principale (toggles)
local MainPage = new("Frame", {
	Name = "MainPage",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 0, 28),
	Size = UDim2.new(1, 0, 1, -28),
	ZIndex = 3,
}, Panel)

new("TextLabel", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 18, 0, 12),
	Size = UDim2.new(0, 74, 0, 24),
	ZIndex = 4,
	FontFace = FONT_HEAVY,
	Text = "KEYBIND",
	TextColor3 = BLUE,
	TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left,
}, MainPage)

local KeyBtn = new("TextButton", {
	BackgroundColor3 = BTN,
	BackgroundTransparency = 0.42,
	BorderSizePixel = 0,
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -12, 0, 12),
	Size = UDim2.new(0, 74, 0, 24),
	ZIndex = 4,
	AutoButtonColor = false,
	FontFace = FONT_HEAVY,
	Text = antiTpKey.Name,
	TextColor3 = WHITE,
	TextSize = 10,
}, MainPage)
corner(KeyBtn, 6)
stroke(KeyBtn, DARK_BLUE, 1)

local AntiBatBtn = makeButton(MainPage, "ANTI BAT", UDim2.new(0, 12, 0, 42), UDim2.new(1, -24, 0, 32))
local InfJumpBtn = makeButton(MainPage, "INFINITE JUMP", UDim2.new(0, 12, 0, 80), UDim2.new(1, -24, 0, 32))

-- Page réglages (UI SIZE + CHANGE THEME)
local SettingsPage = new("Frame", {
	Name = "SizeSliderPage",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 12, 0, 46),
	Size = UDim2.new(1, -24, 0, 112),
	Visible = false,
	ZIndex = 5,
}, Panel)

new("TextLabel", {
	Name = "Title",
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 0, 22),
	ZIndex = 6,
	FontFace = FONT_HEAVY,
	Text = "UI SIZE",
	TextColor3 = BLUE,
	TextSize = 12,
}, SettingsPage)

local Track = new("Frame", {
	Name = "Track",
	BackgroundColor3 = DARK_BLUE,
	BackgroundTransparency = 0.08,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 17, 0, 42),
	Size = UDim2.new(1, -34, 0, 7),
	ZIndex = 7,
}, SettingsPage)
corner(Track, 4)

local Fill = new("Frame", {
	Name = "Fill",
	BackgroundColor3 = BLUE,
	BorderSizePixel = 0,
	Size = UDim2.new(0, 0, 1, 0),
	ZIndex = 8,
}, Track)
corner(Fill, 3)

local Knob = new("Frame", {
	Name = "Knob",
	BackgroundColor3 = BLUE,
	BorderSizePixel = 0,
	Size = UDim2.new(0, 14, 0, 14),
	ZIndex = 9,
}, Track)
corner(Knob, 999)
stroke(Knob, WHITE, 1)

local ValueLabel = new("TextLabel", {
	Name = "Value",
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 56),
	Size = UDim2.new(1, 0, 0, 24),
	ZIndex = 8,
	FontFace = FONT_HEAVY,
	Text = "",
	TextColor3 = WHITE,
	TextSize = 12,
}, SettingsPage)

local ChangeThemeBtn = new("TextButton", {
	Name = "ChangeThemeButton",
	BackgroundColor3 = BTN,
	BackgroundTransparency = 0.42,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 0, 82),
	Size = UDim2.new(1, 0, 0, 28),
	ZIndex = 7,
	AutoButtonColor = false,
	FontFace = FONT_HEAVY,
	Text = "CHANGE THEME",
	TextColor3 = WHITE,
	TextSize = 11,
}, SettingsPage)
corner(ChangeThemeBtn, 8)
stroke(ChangeThemeBtn, DARK_BLUE, 1)

-- Discord (toujours visible)
new("TextLabel", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 12, 1, -24),
	Size = UDim2.new(1, -24, 0, 18),
	ZIndex = 4,
	FontFace = FONT_HEAVY,
	Text = "discord.gg/waveduels",
	TextColor3 = BLUE,
	TextSize = 10,
}, Panel)

-- Overlay de choix de thème
local ThemeOverlay = new("Frame", {
	Name = "ThemePickerOverlay",
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 0.45,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 1, 0),
	Visible = false,
	ZIndex = 50,
}, Gui)

local ThemePicker = new("Frame", {
	Name = "ThemePicker",
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = NAVY,
	BorderSizePixel = 0,
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 360, 0, 230),
	ZIndex = 51,
}, ThemeOverlay)
corner(ThemePicker, 14)
stroke(ThemePicker, DARK_BLUE, 1.5)

new("TextLabel", {
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 16, 0, 6),
	Size = UDim2.new(1, -52, 0, 34),
	ZIndex = 52,
	FontFace = FONT_HEAVY,
	Text = "CHANGE THEME",
	TextColor3 = BLUE,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
}, ThemePicker)

local CloseBtn = new("TextButton", {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(1, -38, 0, 8),
	Size = UDim2.new(0, 30, 0, 30),
	ZIndex = 52,
	AutoButtonColor = false,
	FontFace = FONT_HEAVY,
	Text = "X",
	TextColor3 = BLUE,
	TextSize = 14,
}, ThemePicker)

local ThemeScroll = new("ScrollingFrame", {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 14, 0, 46),
	Size = UDim2.new(1, -16, 1, -56),
	ZIndex = 52,
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	ScrollBarImageColor3 = BLUE,
	ScrollBarThickness = 4,
}, ThemePicker)
new("UIPadding", { PaddingTop = UDim.new(0, 2), PaddingLeft = UDim.new(0, 2), PaddingBottom = UDim.new(0, 4) }, ThemeScroll)
new("UIGridLayout", {
	CellPadding = UDim2.new(0, 14, 0, 10),
	CellSize = UDim2.new(0, 158, 0, 150),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, ThemeScroll)

-- ============ LOGIQUE UI ============
local SLIDER_RANGE = SLIDER_MAX - SLIDER_MIN

local function setScale(pct)
	pct = math.clamp(math.round(pct), SLIDER_MIN, SLIDER_MAX)
	state.Scale = pct
	PanelScale.Scale = pct / 100
	local frac = (pct - SLIDER_MIN) / SLIDER_RANGE
	Fill.Size = UDim2.new(frac, 0, 1, 0)
	Knob.Position = UDim2.new(frac, -7, 0.5, -7)
	ValueLabel.Text = pct .. "%"
end

local function setTheme(t)
	BgImage.Image = t.image
	ThemeOverlay.Visible = false
end

for i, t in ipairs(THEMES) do
	local card = new("TextButton", {
		Name = t.name .. "ThemeCard",
		BackgroundColor3 = BTN,
		BackgroundTransparency = 0.42,
		BorderSizePixel = 0,
		LayoutOrder = i,
		ZIndex = 53,
		AutoButtonColor = false,
		Text = "",
	}, ThemeScroll)
	corner(card, 10)
	stroke(card, DARK_BLUE, 1.5)

	local img = new("ImageLabel", {
		BackgroundColor3 = HEADER_BG,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 8, 0, 8),
		Size = UDim2.new(1, -16, 0, 102),
		ZIndex = 54,
		Image = t.image,
		ScaleType = Enum.ScaleType.Crop,
	}, card)
	corner(img, 8)

	new("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 6, 1, -34),
		Size = UDim2.new(1, -12, 0, 28),
		ZIndex = 54,
		FontFace = FONT_HEAVY,
		Text = t.name,
		TextColor3 = WHITE,
		TextSize = 12,
	}, card)

	card.MouseButton1Click:Connect(function()
		setTheme(t)
	end)
end

-- Pages : principal / réglages
local showingSettings = false
local function refreshPages()
	MainPage.Visible = not showingSettings
	SettingsPage.Visible = showingSettings
	GearIcon.ImageColor3 = showingSettings and WHITE or BLUE
end

GearBtn.MouseButton1Click:Connect(function()
	showingSettings = not showingSettings
	refreshPages()
end)

ChangeThemeBtn.MouseButton1Click:Connect(function()
	ThemeOverlay.Visible = true
end)
CloseBtn.MouseButton1Click:Connect(function()
	ThemeOverlay.Visible = false
end)

-- Toggles
local function refreshToggle(btn, label, on)
	btn.Text = label .. " : " .. (on and "ON" or "OFF")
	btn.TextColor3 = on and BLUE or WHITE
	btn.BackgroundColor3 = on and BTN_ON or BTN
end

local function refreshToggles()
	refreshToggle(AntiBatBtn, "ANTI BAT", state.AntiBat)
	refreshToggle(InfJumpBtn, "INF JUMP", state.InfJump)
	KeyBtn.Text = bindingKey and "..." or antiTpKey.Name
end

AntiBatBtn.MouseButton1Click:Connect(function()
	state.AntiBat = not state.AntiBat
	refreshToggles()
end)
InfJumpBtn.MouseButton1Click:Connect(function()
	state.InfJump = not state.InfJump
	refreshToggles()
end)

-- Keybind : clic puis touche (Espace interdit), la touche active/désactive Anti Bat
KeyBtn.MouseButton1Click:Connect(function()
	if bindingKey then return end
	bindingKey = true
	refreshToggles()
end)

track(UserInputService.InputBegan:Connect(function(input, gp)
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	if bindingKey then
		if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.Space then
			antiTpKey = input.KeyCode
		end
		bindingKey = false
		refreshToggles()
		return
	end
	if not gp and input.KeyCode == antiTpKey then
		state.AntiBat = not state.AntiBat
		refreshToggles()
	end
end))

-- ============ SLIDER UI SIZE ============
local sliding = false

local function updateSlider(input)
	-- ratio calculé à chaque événement : reste correct même si le panneau est mis à l'échelle
	local rel = (input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X
	setScale(SLIDER_MIN + math.clamp(rel, 0, 1) * SLIDER_RANGE)
end

for _, obj in ipairs({ Track, Knob }) do
	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliding = true
			updateSlider(input)
		end
	end)
end

-- ============ DRAG DU PANNEAU ============
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Panel.Position
	end
end)

track(UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end
	if sliding then
		updateSlider(input)
	elseif dragging then
		local d = input.Position - dragStart
		local vp = workspace.CurrentCamera.ViewportSize
		local nx = math.clamp(startPos.X.Offset + d.X, 0, math.max(0, vp.X - Panel.AbsoluteSize.X))
		local ny = math.clamp(startPos.Y.Offset + d.Y, 0, math.max(0, vp.Y - Panel.AbsoluteSize.Y))
		Panel.Position = UDim2.new(0, nx, 0, ny)
	end
end))

track(UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
		sliding = false
	end
end))

-- ============ INIT ============
setScale(state.Scale)
refreshPages()
refreshToggles()

-- ============ DESTROY ============
runtime.destroy = function()
	runtime.alive = false
	for _, c in ipairs(conns) do
		pcall(function() c:Disconnect() end)
	end
	table.clear(conns)
	pcall(function() ijPlatform:Destroy() end)
	pcall(function() Gui:Destroy() end)
	if env.__WAVE_ANTIBAT_RUNTIME == runtime then
		env.__WAVE_ANTIBAT_RUNTIME = nil
	end
end

return Gui