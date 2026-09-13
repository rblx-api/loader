local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer

local connections = {}
local featureStates = { FreezePlayer = false }

local function toggleFreeze(isEnabled)
	if isEnabled then
		featureStates.FreezePlayer = true
		local connection = RunService.Stepped:Connect(function()
			if not featureStates.FreezePlayer then
				connection:Disconnect()
				return
			end
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					local character = player.Character
					if character then
						local humanoid = character:FindFirstChildWhichIsA("Humanoid")
						if humanoid then
							humanoid.WalkSpeed = 0
							humanoid.JumpPower = 0
							humanoid.AutoRotate = false
						end
						for _, object in ipairs(character:GetDescendants()) do
							if object:IsA("BasePart") then
								object.CanCollide = false
							end
						end
					end
				end
			end
		end)
		table.insert(connections, connection)
	else
		featureStates.FreezePlayer = false
		for _, connection in ipairs(connections) do
			if typeof(connection) == "RBXScriptConnection" then
				connection:Disconnect()
			end
		end
		connections = {}
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local character = player.Character
				if character then
					local humanoid = character:FindFirstChildWhichIsA("Humanoid")
					if humanoid then
						humanoid.WalkSpeed = 16
						humanoid.JumpPower = 50
						humanoid.AutoRotate = true
					end
				end
			end
		end
	end
end

local function getGuiParent()
	if typeof(gethui) == "function" then
		local success, result = pcall(gethui)
		if success and result then return result end
	end
	local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
	if success and coreGui then return coreGui end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local function createInstance(className, properties, parent)
	local instance = Instance.new(className)
	for property, value in pairs(properties or {}) do
		instance[property] = value
	end
	instance.Parent = parent
	return instance
end

local function addCorner(object, radius)
	return createInstance("UICorner", { CornerRadius = UDim.new(0, radius) }, object)
end

local function addStroke(object, color, thickness)
	return createInstance("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, object)
end

local parentGui = getGuiParent()
if parentGui:FindFirstChild("LarpAntiAntiDesyncGui") then
	parentGui.LarpAntiAntiDesyncGui:Destroy()
end

local screenGui = createInstance("ScreenGui", {
	Name = "LarpAntiAntiDesyncGui",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, parentGui)

if type(syn) == "table" and type(syn.protect_gui) == "function" then
	pcall(syn.protect_gui, screenGui)
elseif typeof(protectgui) == "function" then
	pcall(protectgui, screenGui)
end

local mainFrame = createInstance("Frame", {
	Size = UDim2.fromOffset(230, 92),
	Position = UDim2.new(0.5, -115, 0.5, -46),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Active = true,
	ZIndex = 40,
}, screenGui)
addCorner(mainFrame, 13)
addStroke(mainFrame, Color3.fromRGB(39, 39, 39), 1.3)

local contentHolder = createInstance("Frame", {
	Size = UDim2.new(1, -6, 1, -6),
	Position = UDim2.fromOffset(3, 3),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	ZIndex = 40,
}, mainFrame)
addCorner(contentHolder, 10)

createInstance("ImageLabel", {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Image = "rbxassetid://75092645422723",
	ScaleType = Enum.ScaleType.Crop,
	ImageTransparency = 0.22,
	ZIndex = 40,
}, contentHolder)

createInstance("Frame", {
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(2, 2, 2),
	BackgroundTransparency = 0.74,
	BorderSizePixel = 0,
	ZIndex = 41,
}, contentHolder)

local headerFrame = createInstance("Frame", {
	Size = UDim2.new(1, 0, 0, 31),
	BackgroundColor3 = Color3.fromRGB(4, 4, 4),
	BorderSizePixel = 0,
	ZIndex = 42,
}, contentHolder)

createInstance("Frame", {
	Size = UDim2.new(1, 0, 0, 1),
	Position = UDim2.new(0, 0, 1, -1),
	BackgroundColor3 = Color3.fromRGB(34, 34, 34),
	BorderSizePixel = 0,
	ZIndex = 43,
}, headerFrame)

createInstance("TextLabel", {
	Size = UDim2.new(1, -76, 1, 0),
	Position = UDim2.fromOffset(12, 0),
	BackgroundTransparency = 1,
	Text = "AntiBat Y Anti Lag",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 43,
}, headerFrame)

local toggleButton = createInstance("TextButton", {
	Size = UDim2.new(1, -18, 0, 39),
	Position = UDim2.fromOffset(9, 43),
	BackgroundColor3 = Color3.fromRGB(16, 16, 16),
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Text = "ACTIVATE",
	TextColor3 = Color3.fromRGB(226, 52, 52),
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	ZIndex = 42,
}, contentHolder)
addCorner(toggleButton, 10)

local isActive = false
local function updateButtonState(state)
	isActive = state
	if state then
		toggleButton.Text = "DEACTIVATE"
		toggleButton.BackgroundColor3 = Color3.fromRGB(228, 34, 34)
		toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		toggleFreeze(true)
	else
		toggleButton.Text = "ACTIVATE"
		toggleButton.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
		toggleButton.TextColor3 = Color3.fromRGB(226, 52, 52)
		toggleFreeze(false)
	end
end

toggleButton.Activated:Connect(function()
	updateButtonState(not isActive)
end)

toggleButton.MouseEnter:Connect(function()
	local targetColor = isActive and Color3.fromRGB(236, 44, 44) or Color3.fromRGB(32, 32, 32)
	TweenService:Create(toggleButton, TweenInfo.new(0.12), { BackgroundColor3 = targetColor }):Play()
end)

toggleButton.MouseLeave:Connect(function()
	local targetColor = isActive and Color3.fromRGB(228, 34, 34) or Color3.fromRGB(16, 16, 16)
	TweenService:Create(toggleButton, TweenInfo.new(0.12), { BackgroundColor3 = targetColor }):Play()
end)

local isDragging = false
local dragOffset = Vector2.new()
local startPosition = UDim2.new()

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = true
		dragOffset = input.Position
		startPosition = mainFrame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = Vector2.new(input.Position.X - dragOffset.X, input.Position.Y - dragOffset.Y)
		mainFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = false
	end
end)

updateButtonState(false)