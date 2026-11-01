-- CHOCOLA UI
-- LocalScript para Roblox Studio.
-- Coloca este archivo como LocalScript en StarterPlayer > StarterPlayerScripts
-- o en StarterGui.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local DISCORD_URL = "https://discord.gg/kdds7hqTx"

-- Evita duplicar la interfaz si el script se ejecuta más de una vez.
local previous = playerGui:FindFirstChild("ChocolaUI")
if previous then
	previous:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChocolaUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(340, 205)
main.BackgroundColor3 = Color3.fromRGB(19, 19, 25)
main.BackgroundTransparency = 0.08
main.BorderSizePixel = 0
main.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(135, 91, 190)
mainStroke.Transparency = 0.25
mainStroke.Thickness = 1.4
mainStroke.Parent = main

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 27, 48)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 17, 24))
})
gradient.Rotation = 35
gradient.Parent = main

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 54)
header.BackgroundTransparency = 1
header.Parent = main

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.fromOffset(18, 0)
title.Size = UDim2.new(1, -86, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "CHOCola"
title.TextColor3 = Color3.fromRGB(245, 237, 255)
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minimize = Instance.new("TextButton")
minimize.Name = "Minimize"
minimize.AnchorPoint = Vector2.new(1, 0.5)
minimize.Position = UDim2.new(1, -12, 0.5, 0)
minimize.Size = UDim2.fromOffset(32, 30)
minimize.BackgroundColor3 = Color3.fromRGB(67, 49, 88)
minimize.BorderSizePixel = 0
minimize.Font = Enum.Font.GothamBold
minimize.Text = "—"
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.TextSize = 18
minimize.AutoButtonColor = true
minimize.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 9)
minCorner.Parent = minimize

local divider = Instance.new("Frame")
divider.Position = UDim2.fromOffset(16, 54)
divider.Size = UDim2.new(1, -32, 0, 1)
divider.BackgroundColor3 = Color3.fromRGB(115, 86, 145)
divider.BackgroundTransparency = 0.55
divider.BorderSizePixel = 0
divider.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Position = UDim2.fromOffset(18, 72)
subtitle.Size = UDim2.new(1, -36, 0, 28)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.GothamMedium
subtitle.Text = "Bienvenido a Chocola"
subtitle.TextColor3 = Color3.fromRGB(225, 215, 239)
subtitle.TextSize = 15
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = main

local info = Instance.new("TextLabel")
info.Position = UDim2.fromOffset(18, 105)
info.Size = UDim2.new(1, -36, 0, 22)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.Text = "Interfaz independiente • compatible con móvil"
info.TextColor3 = Color3.fromRGB(160, 153, 173)
info.TextSize = 11
info.TextXAlignment = Enum.TextXAlignment.Left
info.Parent = main

local discordLabel = Instance.new("TextLabel")
discordLabel.Position = UDim2.fromOffset(18, 151)
discordLabel.Size = UDim2.new(1, -36, 0, 30)
discordLabel.BackgroundColor3 = Color3.fromRGB(45, 35, 60)
discordLabel.BackgroundTransparency = 0.1
discordLabel.BorderSizePixel = 0
discordLabel.Font = Enum.Font.GothamMedium
discordLabel.Text = "Discord: " .. DISCORD_URL
discordLabel.TextColor3 = Color3.fromRGB(205, 177, 245)
discordLabel.TextSize = 11
discordLabel.TextWrapped = true
discordLabel.Parent = main

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 8)
discordCorner.Parent = discordLabel

-- Botón compacto para volver a abrir la ventana.
local reopen = Instance.new("TextButton")
reopen.Name = "Reopen"
reopen.AnchorPoint = Vector2.new(0, 0)
reopen.Position = UDim2.new(0, 18, 0, 100)
reopen.Size = UDim2.fromOffset(112, 38)
reopen.BackgroundColor3 = Color3.fromRGB(43, 32, 58)
reopen.BorderSizePixel = 0
reopen.Font = Enum.Font.GothamBold
reopen.Text = "＋  CHOCola"
reopen.TextColor3 = Color3.fromRGB(245, 237, 255)
reopen.TextSize = 13
reopen.Visible = false
reopen.Parent = screenGui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(0, 11)
reopenCorner.Parent = reopen

local reopenStroke = Instance.new("UIStroke")
reopenStroke.Color = Color3.fromRGB(135, 91, 190)
reopenStroke.Transparency = 0.25
reopenStroke.Parent = reopen

-- Arrastre mediante ratón o pantalla táctil.
local dragging = false
local dragInput
local dragStart
local startPosition

local function updateDrag(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,
		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)
end

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPosition = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input == dragInput
		or input.UserInputType == Enum.UserInputType.Touch) then
		updateDrag(input)
	end
end)

local minimized = false

minimize.Activated:Connect(function()
	if minimized then
		return
	end
	minimized = true
	local tween = TweenService:Create(
		main,
		TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = UDim2.fromOffset(340, 54)}
	)
	tween:Play()
	tween.Completed:Wait()
	main.Visible = false
	reopen.Visible = true
end)

reopen.Activated:Connect(function()
	if not minimized then
		return
	end
	reopen.Visible = false
	main.Visible = true
	main.Size = UDim2.fromOffset(340, 54)
	local tween = TweenService:Create(
		main,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = UDim2.fromOffset(340, 205)}
	)
	tween:Play()
	minimized = false
end)

-- Ajuste sencillo para pantallas estrechas.
local function fitToScreen()
	local camera = workspace.CurrentCamera
	if not camera then
		return
	end
	local viewport = camera.ViewportSize
	if viewport.X < 380 then
		main.Size = UDim2.fromOffset(math.max(270, viewport.X - 28), 205)
	end
end

fitToScreen()
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitToScreen)
end