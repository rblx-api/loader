local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

repeat
	task.wait()
until game:IsLoaded()

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

pcall(function()
	local existingGui = playerGui:FindFirstChild("22sHub")
	if existingGui then
		existingGui:Destroy()
	end
end)

local antiBatEnabled = false
local infJumpEnabled = false
local toggleKey = Enum.KeyCode.N
local listeningForKeybind = false
local positionLocked = false
local boxed = false
local backgroundImage = "rbxassetid://107981254222019"

local backgroundList = {
	"rbxassetid://107981254222019",
	"rbxassetid://112972499444363",
	"rbxassetid://83582398863137",
	"rbxassetid://140407618818729",
	"rbxassetid://79404041922584",
}

local antiBatConnection = nil
local antiRagdollConnection = nil

local function saveConfig()
	local config = {
		Keybind = toggleKey.Name,
		AntiBat = antiBatEnabled,
		InfJump = infJumpEnabled,
		Background = backgroundImage,
		Locked = positionLocked,
		Boxed = boxed,
	}
	pcall(function()
		writefile("22sHub_Config.json", HttpService:JSONEncode(config))
	end)
end

pcall(function()
	local ok, result = pcall(function()
		if isfile and isfile("22sHub_Config.json") then
			return HttpService:JSONDecode(readfile("22sHub_Config.json"))
		end
	end)
	if ok then
		ok = type(result) == "table"
	end
	if ok then
		if result.Keybind and Enum.KeyCode[result.Keybind] then
			toggleKey = Enum.KeyCode[result.Keybind]
		end
		if result.AntiBat ~= nil then
			antiBatEnabled = result.AntiBat == true
		end
		if result.InfJump ~= nil then
			infJumpEnabled = result.InfJump == true
		end
		if result.Background then
			backgroundImage = result.Background
		end
		if result.Locked ~= nil then
			positionLocked = result.Locked == true
		end
	end
end)

local function enableAntiBat()
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end
	if antiBatConnection then
		antiBatConnection:Disconnect()
	end
	antiBatConnection = RunService.Heartbeat:Connect(function()
		if not humanoidRootPart or not humanoidRootPart.Parent then
			return
		end
		local savedVelocity = Vector3.new(humanoidRootPart.Velocity.X, 0, humanoidRootPart.Velocity.Z)
		humanoidRootPart.Velocity = Vector3.new(1000, humanoidRootPart.Velocity.Y, 1000)
		RunService.RenderStepped:Wait()
		if humanoidRootPart and humanoidRootPart.Parent then
			humanoidRootPart.Velocity = Vector3.new(savedVelocity.X, humanoidRootPart.Velocity.Y, savedVelocity.Z)
		end
	end)
end

local function disableAntiBat()
	if antiBatConnection then
		antiBatConnection:Disconnect()
		antiBatConnection = nil
	end
end

local function startAntiRagdoll()
	if antiRagdollConnection then
		return
	end
	antiRagdollConnection = RunService.Heartbeat:Connect(function()
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoid then
			local state = humanoid:GetState()
			if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
				humanoid:ChangeState(Enum.HumanoidStateType.Running)
				workspace.CurrentCamera.CameraSubject = humanoid
				pcall(function()
					local playerModule = localPlayer.PlayerScripts:FindFirstChild("PlayerModule")
					if playerModule then
						local controlModule = playerModule:FindFirstChild("ControlModule")
						if controlModule then
							require(controlModule):Enable()
						end
					end
				end)
				if humanoidRootPart then
					humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
					humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
				end
			end
		end
		for _, descendant in ipairs(character:GetDescendants()) do
			if descendant:IsA("LocalScript") and not descendant.Enabled then
				descendant.Enabled = true
			end
		end
	end)
end

localPlayer.CharacterAdded:Connect(function()
	task.wait(0.3)
	if antiBatEnabled then
		enableAntiBat()
	end
	task.wait(0.5)
	startAntiRagdoll()
end)

UserInputService.JumpRequest:Connect(function()
	if not infJumpEnabled then
		return
	end
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoidRootPart and humanoid then
		local state = humanoid:GetState()
		if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then
			humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, 55, humanoidRootPart.Velocity.Z)
		end
	end
end)

local function createDiscordTag()
	local character = localPlayer.Character
	if not character then
		return
	end
	local head = character:FindFirstChild("Head") or character:FindFirstChild("UpperTorso")
	if not head then
		return
	end
	local existingTag = head:FindFirstChild("22s_DiscordTag")
	if existingTag then
		existingTag:Destroy()
	end
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Name = "22s_DiscordTag"
	billboardGui.Parent = head
	billboardGui.Adornee = head
	billboardGui.Size = UDim2.new(0, 220, 0, 34)
	billboardGui.StudsOffset = Vector3.new(0, 3, 0)
	billboardGui.MaxDistance = 200
	billboardGui.AlwaysOnTop = true
	local discordLabel = Instance.new("TextLabel")
	discordLabel.Parent = billboardGui
	discordLabel.BackgroundTransparency = 1
	discordLabel.Position = UDim2.new(0, 0, 0, 0)
	discordLabel.Size = UDim2.new(1, 0, 0.55, 0)
	discordLabel.Font = Enum.Font.GothamBlack
	discordLabel.Text = "discord.gg/22shub"
	discordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	discordLabel.TextScaled = true
	discordLabel.TextXAlignment = Enum.TextXAlignment.Center
	discordLabel.TextYAlignment = Enum.TextYAlignment.Center
	discordLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	discordLabel.TextStrokeTransparency = 0.2
	local tagLabel = Instance.new("TextLabel")
	tagLabel.Parent = billboardGui
	tagLabel.BackgroundTransparency = 1
	tagLabel.Position = UDim2.new(0, 0, 0.55, 0)
	tagLabel.Size = UDim2.new(1, 0, 0.45, 0)
	tagLabel.Font = Enum.Font.GothamBold
	tagLabel.Text = "22s HUB"
	tagLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	tagLabel.TextScaled = true
	tagLabel.TextXAlignment = Enum.TextXAlignment.Center
	tagLabel.TextYAlignment = Enum.TextYAlignment.Center
	tagLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	tagLabel.TextStrokeTransparency = 0.3
end

createDiscordTag()

localPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)
	createDiscordTag()
end)

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "22sHub"
mainGui.IgnoreGuiInset = true
mainGui.ResetOnSpawn = false
mainGui.DisplayOrder = 10
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainGui.Parent = playerGui

local mainWindow = Instance.new("Frame")
mainWindow.Name = "Main"
mainWindow.Active = true
mainWindow.ClipsDescendants = true
mainWindow.Position = UDim2.new(0.5, -160, 0.5, -130)
mainWindow.Size = UDim2.new(0, 320, 0, 260)
mainWindow.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainWindow.BorderSizePixel = 0
mainWindow.Parent = mainGui

do
	local windowCorner = Instance.new("UICorner")
	windowCorner.CornerRadius = UDim.new(0, 14)
	windowCorner.Parent = mainWindow
end

do
	local windowStroke = Instance.new("UIStroke")
	windowStroke.Color = Color3.fromRGB(255, 255, 255)
	windowStroke.Thickness = 1.5
	windowStroke.Transparency = 0.4
	windowStroke.Parent = mainWindow
end

local backgroundImageLabel = Instance.new("ImageLabel")
backgroundImageLabel.Name = "BGImage"
backgroundImageLabel.ZIndex = 0
backgroundImageLabel.Size = UDim2.new(1, 0, 1, 0)
backgroundImageLabel.BackgroundTransparency = 1
backgroundImageLabel.Image = backgroundImage
backgroundImageLabel.ScaleType = Enum.ScaleType.Crop
backgroundImageLabel.Parent = mainWindow
Instance.new("UICorner", backgroundImageLabel).CornerRadius = UDim.new(0, 14)

do
	local tintFrame = Instance.new("Frame")
	tintFrame.ZIndex = 1
	tintFrame.Size = UDim2.new(1, 0, 1, 0)
	tintFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	tintFrame.BackgroundTransparency = 0.5
	tintFrame.BorderSizePixel = 0
	tintFrame.Parent = mainWindow
	Instance.new("UICorner", tintFrame).CornerRadius = UDim.new(0, 14)
end

local header = Instance.new("Frame")
header.Name = "Header"
header.Active = true
header.ZIndex = 4
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundTransparency = 1
header.Parent = mainWindow

local titleLabel = Instance.new("TextLabel")
titleLabel.ZIndex = 6
titleLabel.Position = UDim2.new(0, 60, 0, 6)
titleLabel.Size = UDim2.new(0.4, 0, 0, 22)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "22s HUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.ZIndex = 6
subtitleLabel.Position = UDim2.new(0, 60, 0, 30)
subtitleLabel.Size = UDim2.new(0.7, 0, 0, 14)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "best free anti bat  •  discord.gg/22shub"
subtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitleLabel.TextSize = 9
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.Parent = header

local iconBox = Instance.new("Frame")
iconBox.ZIndex = 6
iconBox.Position = UDim2.new(0, 14, 0.5, -15)
iconBox.Size = UDim2.new(0, 30, 0, 30)
iconBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
iconBox.BorderSizePixel = 0
iconBox.ClipsDescendants = true
iconBox.Parent = header
Instance.new("UICorner", iconBox).CornerRadius = UDim.new(0, 8)

do
	local iconImage = Instance.new("ImageLabel")
	iconImage.ZIndex = 7
	iconImage.Size = UDim2.new(1, 0, 1, 0)
	iconImage.BackgroundTransparency = 1
	iconImage.Image = backgroundList[1]
	iconImage.ScaleType = Enum.ScaleType.Crop
	iconImage.Parent = iconBox
	Instance.new("UICorner", iconImage).CornerRadius = UDim.new(0, 8)
end

local headerButtons = Instance.new("Frame")
headerButtons.ZIndex = 6
headerButtons.AnchorPoint = Vector2.new(1, 0)
headerButtons.Position = UDim2.new(1, -14, 0, 6)
headerButtons.Size = UDim2.new(0, 90, 0, 22)
headerButtons.BackgroundTransparency = 1
headerButtons.Parent = header

local function createHeaderButton(name, text, xOffset, width)
	local button = Instance.new("TextButton")
	button.Name = name
	button.ZIndex = 7
	button.Position = UDim2.new(0, xOffset, 0, 0)
	button.Size = UDim2.new(0, width, 0, 22)
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.BackgroundTransparency = 0.15
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 10
	button.Font = Enum.Font.GothamBlack
	button.AutoButtonColor = false
	button.Parent = headerButtons
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
	local stroke = Instance.new("UIStroke", button)
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 1
	stroke.Transparency = 0.4
	return button
end

local lockButton = createHeaderButton("LockBtn", "🔓", 0, 24)
local bgMenuButton = createHeaderButton("BGBtn", "BG", 30, 24)
local boxButton = createHeaderButton("BoxBtn", "⧉", 60, 24)

local contentArea = Instance.new("Frame")
contentArea.ZIndex = 3
contentArea.ClipsDescendants = true
contentArea.Position = UDim2.new(0, 0, 0, 50)
contentArea.Size = UDim2.new(1, 0, 1, -50)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainWindow

local contentList = Instance.new("Frame")
contentList.ZIndex = 3
contentList.Size = UDim2.new(1, 0, 1, 0)
contentList.BackgroundTransparency = 1
contentList.Parent = contentArea

local antiBatCard = Instance.new("Frame")
antiBatCard.ZIndex = 5
antiBatCard.Position = UDim2.new(0, 14, 0, 6)
antiBatCard.Size = UDim2.new(1, -28, 0, 56)
antiBatCard.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
antiBatCard.BackgroundTransparency = 0.2
antiBatCard.BorderSizePixel = 0
antiBatCard.Parent = contentList
Instance.new("UICorner", antiBatCard).CornerRadius = UDim.new(0, 12)

do
	local cardStroke = Instance.new("UIStroke", antiBatCard)
	cardStroke.Color = Color3.fromRGB(255, 255, 255)
	cardStroke.Thickness = 1
	cardStroke.Transparency = 0.6
end

local antiBatTitle = Instance.new("TextLabel")
antiBatTitle.ZIndex = 6
antiBatTitle.Position = UDim2.new(0, 14, 0, 10)
antiBatTitle.Size = UDim2.new(1, -80, 0, 18)
antiBatTitle.BackgroundTransparency = 1
antiBatTitle.Text = "Enable Anti Bat"
antiBatTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
antiBatTitle.TextSize = 14
antiBatTitle.Font = Enum.Font.GothamBold
antiBatTitle.TextXAlignment = Enum.TextXAlignment.Left
antiBatTitle.Parent = antiBatCard

local antiBatStateLabel = Instance.new("TextLabel")
antiBatStateLabel.ZIndex = 6
antiBatStateLabel.Position = UDim2.new(0, 14, 0, 30)
antiBatStateLabel.Size = UDim2.new(1, -80, 0, 14)
antiBatStateLabel.BackgroundTransparency = 1
antiBatStateLabel.Text = "OFF"
antiBatStateLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
antiBatStateLabel.TextSize = 10
antiBatStateLabel.Font = Enum.Font.Gotham
antiBatStateLabel.TextXAlignment = Enum.TextXAlignment.Left
antiBatStateLabel.Parent = antiBatCard

local antiBatToggleTrack = Instance.new("Frame")
antiBatToggleTrack.ZIndex = 6
antiBatToggleTrack.AnchorPoint = Vector2.new(1, 0.5)
antiBatToggleTrack.Position = UDim2.new(1, -14, 0.5, 0)
antiBatToggleTrack.Size = UDim2.new(0, 50, 0, 24)
antiBatToggleTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
antiBatToggleTrack.BorderSizePixel = 0
antiBatToggleTrack.Parent = antiBatCard
Instance.new("UICorner", antiBatToggleTrack).CornerRadius = UDim.new(1, 0)

local antiBatKnob = Instance.new("Frame")
antiBatKnob.ZIndex = 7
antiBatKnob.Position = UDim2.new(0, 4, 0.5, -8)
antiBatKnob.Size = UDim2.new(0, 16, 0, 16)
antiBatKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
antiBatKnob.BorderSizePixel = 0
antiBatKnob.Parent = antiBatToggleTrack
Instance.new("UICorner", antiBatKnob).CornerRadius = UDim.new(1, 0)

local antiBatClick = Instance.new("TextButton")
antiBatClick.ZIndex = 10
antiBatClick.AnchorPoint = Vector2.new(1, 0.5)
antiBatClick.Position = UDim2.new(1, -14, 0.5, 0)
antiBatClick.Size = UDim2.new(0, 60, 0, 50)
antiBatClick.BackgroundTransparency = 1
antiBatClick.Text = ""
antiBatClick.Parent = antiBatCard

local keybindCard = Instance.new("Frame")
keybindCard.ZIndex = 5
keybindCard.Position = UDim2.new(0, 14, 0, 68)
keybindCard.Size = UDim2.new(1, -28, 0, 56)
keybindCard.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
keybindCard.BackgroundTransparency = 0.2
keybindCard.BorderSizePixel = 0
keybindCard.Parent = contentList
Instance.new("UICorner", keybindCard).CornerRadius = UDim.new(0, 12)

do
	local cardStroke = Instance.new("UIStroke", keybindCard)
	cardStroke.Color = Color3.fromRGB(255, 255, 255)
	cardStroke.Thickness = 1
	cardStroke.Transparency = 0.4
end

local keybindTitle = Instance.new("TextLabel")
keybindTitle.ZIndex = 6
keybindTitle.Position = UDim2.new(0, 14, 0.5, -9)
keybindTitle.Size = UDim2.new(0.6, 0, 0, 18)
keybindTitle.BackgroundTransparency = 1
keybindTitle.Text = "Keybind"
keybindTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keybindTitle.TextSize = 14
keybindTitle.Font = Enum.Font.GothamBold
keybindTitle.TextXAlignment = Enum.TextXAlignment.Left
keybindTitle.Parent = keybindCard

local keybindButton = Instance.new("TextButton")
keybindButton.ZIndex = 8
keybindButton.AnchorPoint = Vector2.new(1, 0.5)
keybindButton.Position = UDim2.new(1, -14, 0.5, 0)
keybindButton.Size = UDim2.new(0, 80, 0, 30)
keybindButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
keybindButton.BackgroundTransparency = 0.1
keybindButton.Text = toggleKey.Name
keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
keybindButton.TextSize = 14
keybindButton.Font = Enum.Font.GothamBlack
keybindButton.AutoButtonColor = false
keybindButton.Parent = keybindCard
Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 6)

do
	local buttonStroke = Instance.new("UIStroke", keybindButton)
	buttonStroke.Color = Color3.fromRGB(255, 255, 255)
	buttonStroke.Thickness = 1
	buttonStroke.Transparency = 0.6
end

local infJumpCard = Instance.new("Frame")
infJumpCard.ZIndex = 4
infJumpCard.Position = UDim2.new(0, 14, 0, 130)
infJumpCard.Size = UDim2.new(1, -28, 0, 44)
infJumpCard.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
infJumpCard.BackgroundTransparency = 0.2
infJumpCard.BorderSizePixel = 0
infJumpCard.Parent = contentList
Instance.new("UICorner", infJumpCard).CornerRadius = UDim.new(0, 12)

do
	local cardStroke = Instance.new("UIStroke", infJumpCard)
	cardStroke.Color = Color3.fromRGB(255, 255, 255)
	cardStroke.Thickness = 1
	cardStroke.Transparency = 0.6
end

local infJumpTitle = Instance.new("TextLabel")
infJumpTitle.ZIndex = 6
infJumpTitle.Position = UDim2.new(0, 14, 0.5, -9)
infJumpTitle.Size = UDim2.new(0.6, 0, 0, 18)
infJumpTitle.BackgroundTransparency = 1
infJumpTitle.Text = "Inf Jump"
infJumpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
infJumpTitle.TextSize = 14
infJumpTitle.Font = Enum.Font.GothamBold
infJumpTitle.TextXAlignment = Enum.TextXAlignment.Left
infJumpTitle.Parent = infJumpCard

local infJumpToggleTrack = Instance.new("Frame")
infJumpToggleTrack.ZIndex = 6
infJumpToggleTrack.AnchorPoint = Vector2.new(1, 0.5)
infJumpToggleTrack.Position = UDim2.new(1, -14, 0.5, 0)
infJumpToggleTrack.Size = UDim2.new(0, 44, 0, 24)
infJumpToggleTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
infJumpToggleTrack.BorderSizePixel = 0
infJumpToggleTrack.Parent = infJumpCard
Instance.new("UICorner", infJumpToggleTrack).CornerRadius = UDim.new(1, 0)

local infJumpKnob = Instance.new("Frame")
infJumpKnob.ZIndex = 7
infJumpKnob.Position = UDim2.new(0, 3, 0.5, -7)
infJumpKnob.Size = UDim2.new(0, 14, 0, 14)
infJumpKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
infJumpKnob.BorderSizePixel = 0
infJumpKnob.Parent = infJumpToggleTrack
Instance.new("UICorner", infJumpKnob).CornerRadius = UDim.new(1, 0)

local infJumpClick = Instance.new("TextButton")
infJumpClick.ZIndex = 14
infJumpClick.AnchorPoint = Vector2.new(1, 0.5)
infJumpClick.Position = UDim2.new(1, -10, 0.5, 0)
infJumpClick.Size = UDim2.new(0, 60, 0, 40)
infJumpClick.BackgroundTransparency = 1
infJumpClick.Text = ""
infJumpClick.Parent = infJumpCard

local resizeHandle = Instance.new("TextButton")
resizeHandle.ZIndex = 15
resizeHandle.AnchorPoint = Vector2.new(1, 1)
resizeHandle.Position = UDim2.new(1, -2, 1, -2)
resizeHandle.Size = UDim2.new(0, 12, 0, 12)
resizeHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
resizeHandle.BackgroundTransparency = 0.55
resizeHandle.Text = "◢"
resizeHandle.TextColor3 = Color3.fromRGB(255, 255, 255)
resizeHandle.TextSize = 10
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.AutoButtonColor = false
resizeHandle.Parent = mainWindow
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 4)

do
	local draggingResize = false
	local dragStart = nil
	local startSize = nil

	resizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingResize = true
			dragStart = input.Position
			startSize = mainWindow.AbsoluteSize
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if draggingResize and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			local newWidth = math.clamp(startSize.X + delta.X, 260, 520)
			local newHeight = math.clamp(startSize.Y + delta.Y, 200, 420)
			mainWindow.Size = UDim2.new(0, newWidth, 0, newHeight)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingResize = false
		end
	end)
end

local backgroundMenu = Instance.new("Frame")
backgroundMenu.ZIndex = 20
backgroundMenu.Visible = false
backgroundMenu.AnchorPoint = Vector2.new(1, 0)
backgroundMenu.Position = UDim2.new(1, -14, 0, 34)
backgroundMenu.Size = UDim2.new(0, 180, 0, #backgroundList * 36 + 12)
backgroundMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
backgroundMenu.BackgroundTransparency = 0.1
backgroundMenu.BorderSizePixel = 0
backgroundMenu.Parent = header
Instance.new("UICorner", backgroundMenu).CornerRadius = UDim.new(0, 10)

do
	local menuStroke = Instance.new("UIStroke", backgroundMenu)
	menuStroke.Color = Color3.fromRGB(255, 255, 255)
	menuStroke.Thickness = 1
	menuStroke.Transparency = 0.4
end

do
	local menuLayout = Instance.new("UIListLayout", backgroundMenu)
	menuLayout.Padding = UDim.new(0, 5)
	menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
end

do
	local menuPadding = Instance.new("UIPadding", backgroundMenu)
	menuPadding.PaddingTop = UDim.new(0, 6)
	menuPadding.PaddingBottom = UDim.new(0, 6)
	menuPadding.PaddingLeft = UDim.new(0, 6)
	menuPadding.PaddingRight = UDim.new(0, 6)
end

do
	local backgroundButtonsList = {}

	for index, backgroundId in ipairs(backgroundList) do
		local backgroundButton
		do
			backgroundButton = Instance.new("TextButton")
			backgroundButton.ZIndex = 21
			backgroundButton.Size = UDim2.new(1, 0, 0, 32)
			backgroundButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			backgroundButton.BackgroundTransparency = 0.2
			backgroundButton.Text = ""
			backgroundButton.AutoButtonColor = false
			backgroundButton.Parent = backgroundMenu
			Instance.new("UICorner", backgroundButton).CornerRadius = UDim.new(0, 6)

			do
				local thumbnail = Instance.new("ImageLabel")
				thumbnail.ZIndex = 22
				thumbnail.Position = UDim2.new(0, 4, 0.5, -12)
				thumbnail.Size = UDim2.new(0, 24, 0, 24)
				thumbnail.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				thumbnail.BorderSizePixel = 0
				thumbnail.Image = backgroundId
				thumbnail.ScaleType = Enum.ScaleType.Crop
				thumbnail.Parent = backgroundButton
				Instance.new("UICorner", thumbnail).CornerRadius = UDim.new(0, 4)
			end
		end

		do
			local backgroundLabel = Instance.new("TextLabel")
			backgroundLabel.ZIndex = 22
			backgroundLabel.Position = UDim2.new(0, 34, 0, 0)
			backgroundLabel.Size = UDim2.new(1, -12, 1, 0)
			backgroundLabel.BackgroundTransparency = 1
			backgroundLabel.Text = "Background " .. index .. (index == 1 and "  (default)" or "")
			backgroundLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			backgroundLabel.TextSize = 11
			backgroundLabel.Font = Enum.Font.Gotham
			backgroundLabel.TextXAlignment = Enum.TextXAlignment.Left
			backgroundLabel.Parent = backgroundButton
		end

		do
			local selectedDot = Instance.new("Frame")
			selectedDot.ZIndex = 21
			selectedDot.AnchorPoint = Vector2.new(1, 0.5)
			selectedDot.Position = UDim2.new(1, -6, 0.5, 0)
			selectedDot.Size = UDim2.new(0, 6, 0, 6)
			selectedDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			selectedDot.BorderSizePixel = 0
			selectedDot.Visible = backgroundId == backgroundImage
			selectedDot.Parent = backgroundButton
			Instance.new("UICorner", selectedDot).CornerRadius = UDim.new(1, 0)

			backgroundButton.MouseButton1Click:Connect(function()
				backgroundImage = backgroundId
				backgroundImageLabel.Image = backgroundId
				for _, otherButton in ipairs(backgroundButtonsList) do
					local selected = otherButton:FindFirstChild("Selected")
					if selected then
						selected.Visible = false
					end
				end
				selectedDot.Visible = true
				saveConfig()
				backgroundMenu.Visible = false
			end)
		end

		backgroundButtonsList[#backgroundButtonsList + 1] = backgroundButton
	end
end

bgMenuButton.MouseButton1Click:Connect(function()
	backgroundMenu.Visible = not backgroundMenu.Visible
end)

local function animateAntiBatToggle(knob, track, enabled, label)
	TweenService:Create(knob, TweenInfo.new(0.15), {
		Position = enabled and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8),
		BackgroundColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 220, 220),
	}):Play()
	TweenService:Create(track, TweenInfo.new(0.2), {
		BackgroundColor3 = enabled and Color3.fromRGB(90, 90, 90) or Color3.fromRGB(60, 60, 60),
	}):Play()
	if label then
		label.Text = enabled and "ON" or "OFF"
		label.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
	end
end

local function animateInfJumpToggle(knob, track, enabled)
	TweenService:Create(knob, TweenInfo.new(0.2), {
		Position = enabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
		BackgroundColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 220, 220),
	}):Play()
	TweenService:Create(track, TweenInfo.new(0.15), {
		BackgroundColor3 = enabled and Color3.fromRGB(90, 90, 90) or Color3.fromRGB(60, 60, 60),
	}):Play()
end

local function setAntiBat(enabled)
	antiBatEnabled = enabled == true
	if antiBatEnabled then
		enableAntiBat()
	else
		disableAntiBat()
	end
	animateAntiBatToggle(antiBatKnob, antiBatToggleTrack, antiBatEnabled, antiBatStateLabel)
	saveConfig()
end

local function setInfJump(enabled)
	infJumpEnabled = enabled == true
	animateInfJumpToggle(infJumpKnob, infJumpToggleTrack, infJumpEnabled)
	saveConfig()
end

local function toggleFeatures()
	local enableBoth = not (antiBatEnabled and infJumpEnabled)
	setAntiBat(enableBoth)
	setInfJump(enableBoth)
end

antiBatClick.MouseButton1Click:Connect(function()
	setAntiBat(not antiBatEnabled)
end)

infJumpClick.MouseButton1Click:Connect(function()
	setInfJump(not infJumpEnabled)
end)

keybindButton.MouseButton1Click:Connect(function()
	if listeningForKeybind then
		return
	end
	listeningForKeybind = true
	keybindButton.Text = "..."
	keybindButton.TextColor3 = Color3.fromRGB(255, 200, 100)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	if listeningForKeybind then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			toggleKey = input.KeyCode
			listeningForKeybind = false
			keybindButton.Text = toggleKey.Name
			keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			saveConfig()
		end
		return
	end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == toggleKey then
		toggleFeatures()
	end
end)

lockButton.MouseButton1Click:Connect(function()
	positionLocked = not positionLocked
	lockButton.Text = positionLocked and "🔒" or "🔓"
	lockButton.TextColor3 = positionLocked and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(255, 255, 255)
	saveConfig()
end)

do
	local fullSize = UDim2.new(0, 320, 0, 260)
	local fullPosition = UDim2.new(0.5, -160, 0.5, -130)
	local boxedSize = UDim2.new(0, 56, 0, 56)
	local boxedPosition = UDim2.new(0.5, -28, 0.5, -28)

	boxButton.MouseButton1Click:Connect(function()
		boxed = not boxed

		if boxed then
			mainWindow.Size = boxedSize
			mainWindow.Position = boxedPosition
			contentArea.Visible = false
			titleLabel.Visible = false
			subtitleLabel.Visible = false
			iconBox.Visible = false
			headerButtons.Visible = false
			backgroundMenu.Visible = false
			resizeHandle.Visible = false
			boxButton.Visible = true
			boxButton.Position = UDim2.new(0.5, -12, 0.5, -12)
			boxButton.Size = UDim2.new(0, 24, 0, 24)
			boxButton.Text = "⧉"
			boxButton.Parent = mainWindow
		else
			mainWindow.Size = fullSize
			mainWindow.Position = fullPosition
			contentArea.Visible = true
			titleLabel.Visible = true
			subtitleLabel.Visible = true
			iconBox.Visible = true
			headerButtons.Visible = true
			resizeHandle.Visible = true
			boxButton.Parent = headerButtons
			boxButton.Position = UDim2.new(0, 60, 0, 0)
			boxButton.Size = UDim2.new(0, 24, 0, 24)
			boxButton.Text = "⧉"
		end

		saveConfig()
	end)
end

do
	local draggingWindow = false
	local dragStart = nil
	local startPosition = nil

	header.InputBegan:Connect(function(input)
		if positionLocked then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingWindow = true
			dragStart = input.Position
			startPosition = mainWindow.Position
		end
	end)

	mainWindow.InputBegan:Connect(function(input)
		if positionLocked then
			return
		end
		if not boxed then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingWindow = true
			dragStart = input.Position
			startPosition = mainWindow.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if positionLocked then
			return
		end
		local isDragMovement = draggingWindow
		if draggingWindow then
			isDragMovement = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
		end
		if isDragMovement then
			local delta = input.Position - dragStart
			mainWindow.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingWindow = false
		end
	end)
end

startAntiRagdoll()
animateAntiBatToggle(antiBatKnob, antiBatToggleTrack, antiBatEnabled, antiBatStateLabel)
animateInfJumpToggle(infJumpKnob, infJumpToggleTrack, infJumpEnabled)

if antiBatEnabled then
	enableAntiBat()
end

keybindButton.Text = toggleKey.Name
backgroundImageLabel.Image = backgroundImage
lockButton.Text = positionLocked and "🔒" or "🔓"