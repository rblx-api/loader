-- Servicios necesarios
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Contenedor principal de la GUI (copiado y adaptado)
local G = {}

G.Riddler = Instance.new("ScreenGui")
G.Riddler.Name = "Riddler"
G.Riddler.ResetOnSpawn = false
G.Riddler.DisplayOrder = 251
G.Riddler.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
G.Riddler.Parent = playerGui

-- Main (Frame) -> Tus medidas originales exactas (316 x 544)
G.Main = Instance.new("Frame")
G.Main.Name = "Main"
G.Main.Active = true
G.Main.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
G.Main.BorderSizePixel = 0
G.Main.ClipsDescendants = true
G.Main.Position = UDim2.new(0.5, -158, 0.5, -272)
G.Main.Size = UDim2.new(0, 316, 0, 544)
G.Main.Parent = G.Riddler

G.UICorner = Instance.new("UICorner", G.Main)
G.UICorner.CornerRadius = UDim.new(0, 14)

G.UIGradient = Instance.new("UIGradient", G.Main)
G.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 15, 21)), ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 9))})
G.UIGradient.Rotation = 90

G.UIStroke = Instance.new("UIStroke", G.Main)
G.UIStroke.Color = Color3.fromRGB(235, 90, 175)
G.UIStroke.Thickness = 1.2
G.UIStroke.Transparency = 0.45

-- Barra Superior
G.Frame = Instance.new("Frame", G.Main)
G.Frame.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame.BorderSizePixel = 0
G.Frame.Size = UDim2.new(1, 0, 0, 44)
Instance.new("UICorner", G.Frame).CornerRadius = UDim.new(0, 14)

G.TextLabel = Instance.new("TextLabel", G.Frame)
G.TextLabel.BackgroundTransparency = 1
G.TextLabel.Position = UDim2.new(0, 44, 0, 0)
G.TextLabel.Size = UDim2.new(1, -132, 1, 0)
G.TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel.Text = "RIDDLER"
G.TextLabel.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextLabel.TextSize = 15
G.TextLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Botones de Navegación Superior (Test, Feed, Minimizar)
G.TextButton = Instance.new("TextButton", G.Frame) -- Test Button
G.TextButton.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton.Position = UDim2.new(1, -149, 0.5, -11)
G.TextButton.Size = UDim2.new(0, 38, 0, 22)
G.TextButton.Text = "Test"
G.TextButton.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton.TextSize = 10
Instance.new("UICorner", G.TextButton)

G.TextButton_2 = Instance.new("TextButton", G.Frame) -- Feed Button
G.TextButton_2.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_2.Position = UDim2.new(1, -108, 0.5, -11)
G.TextButton_2.Size = UDim2.new(0, 38, 0, 22)
G.TextButton_2.Text = "Feed"
G.TextButton_2.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_2.TextSize = 10
Instance.new("UICorner", G.TextButton_2)

-- Botón de Minimizar (Reemplaza el Home genérico para que funcione como minimizar real)
G.TextButton_3 = Instance.new("TextButton", G.Frame) 
G.TextButton_3.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_3.Position = UDim2.new(1, -67, 0.5, -11)
G.TextButton_3.Size = UDim2.new(0, 38, 0, 22)
G.TextButton_3.Text = "_"
G.TextButton_3.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_3.TextSize = 14
Instance.new("UICorner", G.TextButton_3)

-- Contenedor Principal de Opciones (Frame_23)
G.Frame_23 = Instance.new("Frame", G.Main)
G.Frame_23.BackgroundTransparency = 1
G.Frame_23.Position = UDim2.new(0, 10, 0, 48)
G.Frame_23.Size = UDim2.new(1, -20, 1, -54)

G.UIListLayout = Instance.new("UIListLayout", G.Frame_23)
G.UIListLayout.Padding = UDim.new(0, 5)
G.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- [Función de Arrastre para la ventana principal]
local function makeDraggable(topbarObject, object)
	local dragging = false
	local dragInput, dragStart, startPos

	topbarObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = object.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	game:GetService("RunService").RenderStepped:Connect(function()
		if dragging and dragInput then
			local delta = dragInput.Position - dragStart
			object.Position = UDim2.new(
				startPos.X.Scale, 
				startPos.X.Offset + delta.X, 
				startPos.Y.Scale, 
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

makeDraggable(G.Frame, G.Main)

-- [Función del botón Minimizar]
local isMinimized = false
G.TextButton_3.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		G.Frame_23.Visible = false
		G.Main.Size = UDim2.new(0, 316, 0, 44)
		G.TextButton_3.Text = "+"
	else
		G.Main.Size = UDim2.new(0, 316, 0, 544)
		G.Frame_23.Visible = true
		G.TextButton_3.Text = "_"
	end
end)

-- 1. Estado / Ready
local statusFrame = Instance.new("Frame", G.Frame_23)
statusFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
statusFrame.Size = UDim2.new(1, 0, 0, 32)
statusFrame.LayoutOrder = 1
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 9)
local statusDot = Instance.new("Frame", statusFrame)
statusDot.BackgroundColor3 = Color3.fromRGB(55, 195, 105)
statusDot.Position = UDim2.new(0, 12, 0.5, -4)
statusDot.Size = UDim2.new(0, 8, 0, 8)
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(0, 4)
local statusText = Instance.new("TextLabel", statusFrame)
statusText.BackgroundTransparency = 1
statusText.Position = UDim2.new(0, 28, 0, 0)
statusText.Size = UDim2.new(1, -32, 1, 0)
statusText.Text = "ready - active"
statusText.TextColor3 = Color3.fromRGB(55, 195, 105)
statusText.TextSize = 12
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)

-- Función auxiliar para crear Toggles funcionales
local function createToggle(parent, order, title, callback)
	local container = Instance.new("Frame", parent)
	container.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
	container.Size = UDim2.new(1, 0, 0, 31)
	container.LayoutOrder = order
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 9)
	Instance.new("UIStroke", container).Color = Color3.fromRGB(42, 35, 52)

	local label = Instance.new("TextLabel", container)
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 12, 0, 0)
	label.Size = UDim2.new(1, -56, 1, 0)
	label.Text = title
	label.TextColor3 = Color3.fromRGB(185, 175, 210)
	label.TextSize = 11
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)

	local switchBg = Instance.new("Frame", container)
	switchBg.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
	switchBg.Position = UDim2.new(1, -46, 0.5, -9)
	switchBg.Size = UDim2.new(0, 36, 0, 18)
	Instance.new("UICorner", switchBg).CornerRadius = UDim.new(0, 9)

	local switchDot = Instance.new("Frame", switchBg)
	switchDot.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
	switchDot.Position = UDim2.new(0, 2, 0.5, -7)
	switchDot.Size = UDim2.new(0, 14, 0, 14)
	Instance.new("UICorner", switchDot).CornerRadius = UDim.new(0, 7)

	local btn = Instance.new("TextButton", container)
	btn.BackgroundTransparency = 1
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.Text = ""

	local toggled = false
	btn.MouseButton1Click:Connect(function()
		toggled = not toggled
		if toggled then
			switchBg.BackgroundColor3 = Color3.fromRGB(235, 90, 175)
			switchDot.Position = UDim2.new(1, -16, 0.5, -7)
		else
			switchBg.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
			switchDot.Position = UDim2.new(0, 2, 0.5, -7)
		end
		if callback then callback(toggled) end
	end)
end

-- 2. AI Toggle
local aiContainer = Instance.new("Frame", G.Frame_23)
aiContainer.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
aiContainer.Size = UDim2.new(1, 0, 0, 44)
aiContainer.LayoutOrder = 2
Instance.new("UICorner", aiContainer).CornerRadius = UDim.new(0, 9)
local aiLabel = Instance.new("TextLabel", aiContainer)
aiLabel.BackgroundTransparency = 1
aiLabel.Position = UDim2.new(0, 14, 0, 0)
aiLabel.Size = UDim2.new(1, -80, 1, 0)
aiLabel.Text = "AI  -  OFF"
aiLabel.TextColor3 = Color3.fromRGB(185, 175, 210)
aiLabel.TextSize = 13
aiLabel.TextXAlignment = Enum.TextXAlignment.Left
aiLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local aiSwitchBg = Instance.new("Frame", aiContainer)
aiSwitchBg.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
aiSwitchBg.Position = UDim2.new(1, -60, 0.5, -12)
aiSwitchBg.Size = UDim2.new(0, 48, 0, 24)
Instance.new("UICorner", aiSwitchBg).CornerRadius = UDim.new(0, 12)
local aiSwitchDot = Instance.new("Frame", aiSwitchBg)
aiSwitchDot.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
aiSwitchDot.Position = UDim2.new(0, 3, 0.5, -9)
aiSwitchDot.Size = UDim2.new(0, 18, 0, 18)
Instance.new("UICorner", aiSwitchDot).CornerRadius = UDim.new(0, 9)

local aiBtn = Instance.new("TextButton", aiContainer)
aiBtn.BackgroundTransparency = 1
aiBtn.Size = UDim2.new(1, 0, 1, 0)
aiBtn.Text = ""

local aiState = false
aiBtn.MouseButton1Click:Connect(function()
	aiState = not aiState
	if aiState then
		aiLabel.Text = "AI  -  ON"
		aiLabel.TextColor3 = Color3.fromRGB(55, 195, 105)
		aiSwitchBg.BackgroundColor3 = Color3.fromRGB(55, 195, 105)
		aiSwitchDot.Position = UDim2.new(1, -21, 0.5, -9)
	else
		aiLabel.Text = "AI  -  OFF"
		aiLabel.TextColor3 = Color3.fromRGB(185, 175, 210)
		aiSwitchBg.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
		aiSwitchDot.Position = UDim2.new(0, 3, 0.5, -9)
	end
end)

-- 3. LISTEN Toggle
local listenContainer = Instance.new("Frame", G.Frame_23)
listenContainer.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
listenContainer.Size = UDim2.new(1, 0, 0, 44)
listenContainer.LayoutOrder = 3
Instance.new("UICorner", listenContainer).CornerRadius = UDim.new(0, 9)
local listenLabel = Instance.new("TextLabel", listenContainer)
listenLabel.BackgroundTransparency = 1
listenLabel.Position = UDim2.new(0, 14, 0, 0)
listenLabel.Size = UDim2.new(1, -80, 1, 0)
listenLabel.Text = "LISTEN  -  OFF"
listenLabel.TextColor3 = Color3.fromRGB(185, 175, 210)
listenLabel.TextSize = 13
listenLabel.TextXAlignment = Enum.TextXAlignment.Left
listenLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local listenSwitchBg = Instance.new("Frame", listenContainer)
listenSwitchBg.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
listenSwitchBg.Position = UDim2.new(1, -60, 0.5, -12)
listenSwitchBg.Size = UDim2.new(0, 48, 0, 24)
Instance.new("UICorner", listenSwitchBg).CornerRadius = UDim.new(0, 12)
local listenSwitchDot = Instance.new("Frame", listenSwitchBg)
listenSwitchDot.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
listenSwitchDot.Position = UDim2.new(0, 3, 0.5, -9)
listenSwitchDot.Size = UDim2.new(0, 18, 0, 18)
Instance.new("UICorner", listenSwitchDot).CornerRadius = UDim.new(0, 9)

local listenBtn = Instance.new("TextButton", listenContainer)
listenBtn.BackgroundTransparency = 1
listenBtn.Size = UDim2.new(1, 0, 1, 0)
listenBtn.Text = ""

local listenState = false
listenBtn.MouseButton1Click:Connect(function()
	listenState = not listenState
	if listenState then
		listenLabel.Text = "LISTEN  -  ON"
		listenLabel.TextColor3 = Color3.fromRGB(55, 195, 105)
		listenSwitchBg.BackgroundColor3 = Color3.fromRGB(55, 195, 105)
		listenSwitchDot.Position = UDim2.new(1, -21, 0.5, -9)
	else
		listenLabel.Text = "LISTEN  -  OFF"
		listenLabel.TextColor3 = Color3.fromRGB(185, 175, 210)
		listenSwitchBg.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
		listenSwitchDot.Position = UDim2.new(0, 3, 0.5, -9)
	end
end)

-- 4. Question Box Display
local qFrame = Instance.new("Frame", G.Frame_23)
qFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
qFrame.Size = UDim2.new(1, 0, 0, 62)
qFrame.LayoutOrder = 4
Instance.new("UICorner", qFrame).CornerRadius = UDim.new(0, 9)
Instance.new("UIStroke", qFrame).Color = Color3.fromRGB(42, 35, 52)

local qTitle = Instance.new("TextLabel", qFrame)
qTitle.BackgroundTransparency = 1
qTitle.Position = UDim2.new(0, 11, 0, 5)
qTitle.Size = UDim2.new(1, -16, 0, 11)
qTitle.Text = "QUESTION"
qTitle.TextColor3 = Color3.fromRGB(235, 90, 175)
qTitle.TextSize = 9
qTitle.TextXAlignment = Enum.TextXAlignment.Left
qTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local qContent = Instance.new("TextLabel", qFrame)
qContent.BackgroundTransparency = 1
qContent.Position = UDim2.new(0, 11, 0, 18)
qContent.Size = UDim2.new(1, -22, 0, 40)
qContent.Text = "Esperando acertijo..."
qContent.TextColor3 = Color3.fromRGB(185, 175, 210)
qContent.TextSize = 10
qContent.TextWrapped = true
qContent.TextXAlignment = Enum.TextXAlignment.Left
qContent.TextYAlignment = Enum.TextYAlignment.Top
qContent.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)

-- 5. Answer Box
local ansFrame = Instance.new("Frame", G.Frame_23)
ansFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
ansFrame.Size = UDim2.new(1, 0, 0, 54)
ansFrame.LayoutOrder = 5
Instance.new("UICorner", ansFrame).CornerRadius = UDim.new(0, 9)
Instance.new("UIStroke", ansFrame).Color = Color3.fromRGB(235, 90, 175)

local ansTitle = Instance.new("TextLabel", ansFrame)
ansTitle.BackgroundTransparency = 1
ansTitle.Position = UDim2.new(0, 11, 0, 5)
ansTitle.Size = UDim2.new(1, -16, 0, 11)
ansTitle.Text = "ANSWER"
ansTitle.TextColor3 = Color3.fromRGB(235, 90, 175)
ansTitle.TextSize = 9
ansTitle.TextXAlignment = Enum.TextXAlignment.Left
ansTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local ansBox = Instance.new("TextBox", ansFrame)
ansBox.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
ansBox.Position = UDim2.new(0, 9, 0, 19)
ansBox.Size = UDim2.new(1, -18, 0, 28)
ansBox.Text = ""
ansBox.TextColor3 = Color3.fromRGB(235, 90, 175)
ansBox.TextSize = 14
ansBox.PlaceholderText = "la respuesta aparecerá aquí..."
ansBox.PlaceholderColor3 = Color3.fromRGB(185, 175, 210)
ansBox.ClearTextOnFocus = false
ansBox.TextXAlignment = Enum.TextXAlignment.Left
ansBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
Instance.new("UICorner", ansBox).CornerRadius = UDim.new(0, 7)

-- 6. Botones de Acción
local actionFrame = Instance.new("Frame", G.Frame_23)
actionFrame.BackgroundTransparency = 1
actionFrame.Size = UDim2.new(1, 0, 0, 33)
actionFrame.LayoutOrder = 6
local actionLayout = Instance.new("UIListLayout", actionFrame)
actionLayout.FillDirection = Enum.FillDirection.Horizontal
actionLayout.Padding = UDim.new(0, 6)
actionLayout.SortOrder = Enum.SortOrder.LayoutOrder

local copyBtn = Instance.new("TextButton", actionFrame)
copyBtn.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
copyBtn.Size = UDim2.new(0.33, -4, 1, 0)
copyBtn.Text = "COPY"
copyBtn.TextColor3 = Color3.fromRGB(245, 240, 255)
copyBtn.TextSize = 12
copyBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", copyBtn)

local clearBtn = Instance.new("TextButton", actionFrame)
clearBtn.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
clearBtn.Size = UDim2.new(0.33, -4, 1, 0)
clearBtn.Text = "CLEAR"
clearBtn.TextColor3 = Color3.fromRGB(245, 240, 255)
clearBtn.TextSize = 12
clearBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", clearBtn)

local redeemBtn = Instance.new("TextButton", actionFrame)
redeemBtn.BackgroundColor3 = Color3.fromRGB(235, 90, 175)
redeemBtn.Size = UDim2.new(0.33, -4, 1, 0)
redeemBtn.Text = "REDEEM"
redeemBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
redeemBtn.TextSize = 13
redeemBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
Instance.new("UICorner", redeemBtn)

copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(ansBox.Text)
		copyBtn.Text = "COPIED!"
		task.wait(1)
		copyBtn.Text = "COPY"
	end
end)

clearBtn.MouseButton1Click:Connect(function()
	ansBox.Text = ""
	qContent.Text = "Esperando acertijo..."
end)

redeemBtn.MouseButton1Click:Connect(function()
	redeemBtn.Text = "SENT!"
	task.wait(1)
	redeemBtn.Text = "REDEEM"
end)

createToggle(G.Frame_23, 7, "AUTO REDEEM ANSWER", function(state) end)
createToggle(G.Frame_23, 8, "SECURE ANSWER (1-3)", function(state) end)
createToggle(G.Frame_23, 9, "AUTO COPY ANSWER", function(state) end)
createToggle(G.Frame_23, 10, "OPEN FEED ON HIT", function(state) end)

-- Selector de Modelo
local modelFrame = Instance.new("Frame", G.Frame_23)
modelFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
modelFrame.Size = UDim2.new(1, 0, 0, 31)
modelFrame.LayoutOrder = 11
Instance.new("UICorner", modelFrame)

local modelText = Instance.new("TextLabel", modelFrame)
modelText.BackgroundTransparency = 1
modelText.Position = UDim2.new(0, 12, 0, 0)
modelText.Size = UDim2.new(0, 56, 0, 31)
modelText.Text = "MODEL"
modelText.TextColor3 = Color3.fromRGB(185, 175, 210)
modelText.TextSize = 11
modelText.TextXAlignment = Enum.TextXAlignment.Left
modelText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)

local switchModelBg = Instance.new("Frame", modelFrame)
switchModelBg.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
switchModelBg.Position = UDim2.new(1, -177, 0.5, -11)
switchModelBg.Size = UDim2.new(0, 168, 0, 23)
Instance.new("UICorner", switchModelBg).CornerRadius = UDim.new(0, 7)

local fasterBtn = Instance.new("TextButton", switchModelBg)
fasterBtn.BackgroundColor3 = Color3.fromRGB(235, 90, 175)
fasterBtn.Position = UDim2.new(0, 1, 0, 1)
fasterBtn.Size = UDim2.new(0.5, -2, 1, -2)
fasterBtn.Text = "FASTER"
fasterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fasterBtn.TextSize = 10
fasterBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", fasterBtn).CornerRadius = UDim.new(0, 6)

local fastBtn = Instance.new("TextButton", switchModelBg)
fastBtn.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
fastBtn.Position = UDim2.new(0.5, 1, 0, 1)
fastBtn.Size = UDim2.new(0.5, -2, 1, -2)
fastBtn.Text = "FAST"
fastBtn.TextColor3 = Color3.fromRGB(185, 175, 210)
fastBtn.TextSize = 10
fastBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", fastBtn).CornerRadius = UDim.new(0, 6)

fasterBtn.MouseButton1Click:Connect(function()
	fasterBtn.BackgroundColor3 = Color3.fromRGB(235, 90, 175)
	fasterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	fastBtn.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
	fastBtn.TextColor3 = Color3.fromRGB(185, 175, 210)
end)

fastBtn.MouseButton1Click:Connect(function()
	fastBtn.BackgroundColor3 = Color3.fromRGB(235, 90, 175)
	fastBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	fasterBtn.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
	fasterBtn.TextColor3 = Color3.fromRGB(185, 175, 210)
end)

-- Ventana FEED
local Feed = Instance.new("Frame", G.Riddler)
Feed.Name = "Feed"
Feed.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
Feed.Position = UDim2.new(0.5, 20, 0.5, -272)
Feed.Size = UDim2.new(0, 348, 0, 392)
Feed.Visible = false
Instance.new("UICorner", Feed).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", Feed).Color = Color3.fromRGB(235, 90, 175)

local fHeader = Instance.new("Frame", Feed)
fHeader.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
fHeader.Size = UDim2.new(1, 0, 0, 44)
Instance.new("UICorner", fHeader).CornerRadius = UDim.new(0, 14)
makeDraggable(fHeader, Feed)

local fTitle = Instance.new("TextLabel", fHeader)
fTitle.BackgroundTransparency = 1
fTitle.Position = UDim2.new(0, 44, 0, 0)
fTitle.Size = UDim2.new(1, -204, 1, 0)
fTitle.Text = "SOLVE LOG"
fTitle.TextColor3 = Color3.fromRGB(245, 240, 255)
fTitle.TextSize = 15
fTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local closeFeed = Instance.new("TextButton", fHeader)
closeFeed.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
closeFeed.Position = UDim2.new(1, -32, 0.5, -12)
closeFeed.Size = UDim2.new(0, 24, 0, 24)
closeFeed.Text = "X"
closeFeed.TextColor3 = Color3.fromRGB(245, 240, 255)
Instance.new("UICorner", closeFeed)

closeFeed.MouseButton1Click:Connect(function() Feed.Visible = false end)
G.TextButton_2.MouseButton1Click:Connect(function() Feed.Visible = not Feed.Visible end)

-- Ventana TEST
local TestWindow = Instance.new("Frame", G.Riddler)
TestWindow.Name = "TestWindow"
TestWindow.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
TestWindow.Position = UDim2.new(0.5, -380, 0.5, -272)
TestWindow.Size = UDim2.new(0, 300, 0, 214)
TestWindow.Visible = false
Instance.new("UICorner", TestWindow).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", TestWindow).Color = Color3.fromRGB(235, 90, 175)

local tHeader = Instance.new("Frame", TestWindow)
tHeader.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
tHeader.Size = UDim2.new(1, 0, 0, 44)
Instance.new("UICorner", tHeader).CornerRadius = UDim.new(0, 14)
makeDraggable(tHeader, TestWindow)

local tTitle = Instance.new("TextLabel", tHeader)
tTitle.BackgroundTransparency = 1
tTitle.Position = UDim2.new(0, 44, 0, 0)
tTitle.Size = UDim2.new(1, -132, 1, 0)
tTitle.Text = "TEST SENDER"
tTitle.TextColor3 = Color3.fromRGB(245, 240, 255)
tTitle.TextSize = 15
tTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local closeTest = Instance.new("TextButton", tHeader)
closeTest.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
closeTest.Position = UDim2.new(1, -28, 0.5, -11)
closeTest.Size = UDim2.new(0, 22, 0, 22)
closeTest.Text = "X"
closeTest.TextColor3 = Color3.fromRGB(245, 240, 255)
Instance.new("UICorner", closeTest)

closeTest.MouseButton1Click:Connect(function() TestWindow.Visible = false end)
G.TextButton.MouseButton1Click:Connect(function() TestWindow.Visible = not TestWindow.Visible end)

print("¡Script actualizado conservando tus tamaños originales y con funciones de arrastre y minimizar!")