-- Servicios necesarios
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Contenedor principal de la GUI
local G = {}

G.HavenHub = Instance.new("ScreenGui")
G.HavenHub.Name = "HavenHub"
G.HavenHub.ResetOnSpawn = false
G.HavenHub.DisplayOrder = 251
G.HavenHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
G.HavenHub.Parent = playerGui

-- Configuración de Animaciones
local tweenInfoOpen = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local tweenInfoClose = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

local function abrirVentana(frame, targetSize)
	frame.Visible = true
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)

	local tween = TweenService:Create(frame, tweenInfoOpen, {
		Size = targetSize,
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	tween:Play()
end

local function cerrarVentana(frame, callback)
	local tween = TweenService:Create(frame, tweenInfoClose, {
		Size = UDim2.new(0, 0, 0, 0)
	})
	tween:Play()
	tween.Completed:Connect(function()
		frame.Visible = false
		if callback then callback() end
	end)
end

-- [SISTEMA DE ARRASTRE FLUIDO]
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

	RunService.RenderStepped:Connect(function()
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

-- Main (Frame)
G.Main = Instance.new("Frame")
G.Main.Name = "Main"
G.Main.Active = true
G.Main.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
G.Main.BorderSizePixel = 0
G.Main.ClipsDescendants = true
G.Main.Position = UDim2.new(0.5, -140, 0.5, -210)
G.Main.Size = UDim2.new(0, 280, 0, 420)
G.Main.Parent = G.HavenHub

G.UICorner = Instance.new("UICorner", G.Main)
G.UICorner.CornerRadius = UDim.new(0, 12)

G.UIGradient = Instance.new("UIGradient", G.Main)
G.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 15, 21)), ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 9))})
G.UIGradient.Rotation = 90

G.UIStroke = Instance.new("UIStroke", G.Main)
G.UIStroke.Color = Color3.fromRGB(140, 60, 220)
G.UIStroke.Thickness = 1.5
G.UIStroke.Transparency = 0.2

-- Barra Superior Main
G.Frame = Instance.new("Frame", G.Main)
G.Frame.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame.BorderSizePixel = 0
G.Frame.Size = UDim2.new(1, 0, 0, 36)
Instance.new("UICorner", G.Frame).CornerRadius = UDim.new(0, 12)

G.TextLabel = Instance.new("TextLabel", G.Frame)
G.TextLabel.BackgroundTransparency = 1
G.TextLabel.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel.Size = UDim2.new(1, -95, 1, 0)
G.TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel.Text = "HAVEN HUB"
G.TextLabel.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextLabel.TextSize = 12
G.TextLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Botón Test
G.TextButton = Instance.new("TextButton", G.Frame) 
G.TextButton.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton.Position = UDim2.new(1, -128, 0.5, -9)
G.TextButton.Size = UDim2.new(0, 32, 0, 18)
G.TextButton.Text = "Test"
G.TextButton.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton.TextSize = 9
Instance.new("UICorner", G.TextButton).CornerRadius = UDim.new(0, 4)

-- Botón Feed
G.TextButton_2 = Instance.new("TextButton", G.Frame) 
G.TextButton_2.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_2.Position = UDim2.new(1, -92, 0.5, -9)
G.TextButton_2.Size = UDim2.new(0, 32, 0, 18)
G.TextButton_2.Text = "Feed"
G.TextButton_2.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_2.TextSize = 9
Instance.new("UICorner", G.TextButton_2).CornerRadius = UDim.new(0, 4)

-- Botón de Minimizar
G.TextButton_3 = Instance.new("TextButton", G.Frame) 
G.TextButton_3.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_3.Position = UDim2.new(1, -56, 0.5, -9)
G.TextButton_3.Size = UDim2.new(0, 32, 0, 18)
G.TextButton_3.Text = "_"
G.TextButton_3.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_3.TextSize = 12
Instance.new("UICorner", G.TextButton_3).CornerRadius = UDim.new(0, 4)

makeDraggable(G.Frame, G.Main)

-- Contenedor con Scroll
G.ScrollingFrame = Instance.new("ScrollingFrame", G.Main)
G.ScrollingFrame.BackgroundTransparency = 1
G.ScrollingFrame.Position = UDim2.new(0, 8, 0, 40)
G.ScrollingFrame.Size = UDim2.new(1, -16, 1, -44)
G.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 750)
G.ScrollingFrame.ScrollBarThickness = 3
G.ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(140, 60, 220)

G.UIListLayout = Instance.new("UIListLayout", G.ScrollingFrame)
G.UIListLayout.Padding = UDim.new(0, 5)
G.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Minimizar
local isMinimized = false
G.TextButton_3.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		G.ScrollingFrame.Visible = false
		TweenService:Create(G.Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 280, 0, 36)
		}):Play()
		G.TextButton_3.Text = "+"
	else
		G.ScrollingFrame.Visible = true
		TweenService:Create(G.Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 280, 0, 420)
		}):Play()
		G.TextButton_3.Text = "_"
	end
end)

-- Estado / Ready
local statusFrame = Instance.new("Frame", G.ScrollingFrame)
statusFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
statusFrame.Size = UDim2.new(1, 0, 0, 28)
statusFrame.LayoutOrder = 1
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 8)
local statusDot = Instance.new("Frame", statusFrame)
statusDot.BackgroundColor3 = Color3.fromRGB(55, 195, 105)
statusDot.Position = UDim2.new(0, 10, 0.5, -3)
statusDot.Size = UDim2.new(0, 6, 0, 6)
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(0, 3)
local statusText = Instance.new("TextLabel", statusFrame)
statusText.BackgroundTransparency = 1
statusText.Position = UDim2.new(0, 24, 0, 0)
statusText.Size = UDim2.new(1, -24, 1, 0)
statusText.Text = "ready - active"
statusText.TextColor3 = Color3.fromRGB(55, 195, 105)
statusText.TextSize = 11
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)

-- Función Toggles
local function createToggle(parent, order, title, callback)
	local container = Instance.new("Frame", parent)
	container.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
	container.Size = UDim2.new(1, 0, 0, 28)
	container.LayoutOrder = order
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", container).Color = Color3.fromRGB(42, 35, 52)

	local label = Instance.new("TextLabel", container)
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 10, 0, 0)
	label.Size = UDim2.new(1, -48, 1, 0)
	label.Text = title
	label.TextColor3 = Color3.fromRGB(185, 175, 210)
	label.TextSize = 10
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)

	local switchBg = Instance.new("Frame", container)
	switchBg.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
	switchBg.Position = UDim2.new(1, -38, 0.5, -8)
	switchBg.Size = UDim2.new(0, 30, 0, 16)
	Instance.new("UICorner", switchBg).CornerRadius = UDim.new(0, 8)

	local switchDot = Instance.new("Frame", switchBg)
	switchDot.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
	switchDot.Position = UDim2.new(0, 2, 0.5, -6)
	switchDot.Size = UDim2.new(0, 12, 0, 12)
	Instance.new("UICorner", switchDot).CornerRadius = UDim.new(0, 6)

	local btn = Instance.new("TextButton", container)
	btn.BackgroundTransparency = 1
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.Text = ""

	local toggled = false
	btn.MouseButton1Click:Connect(function()
		toggled = not toggled
		if toggled then
			switchBg.BackgroundColor3 = Color3.fromRGB(140, 60, 220)
			switchDot.Position = UDim2.new(1, -14, 0.5, -6)
		else
			switchBg.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
			switchDot.Position = UDim2.new(0, 2, 0.5, -6)
		end
		if callback then callback(toggled) end
	end)
end

-- Controles AI y Listen
local aiContainer = Instance.new("Frame", G.ScrollingFrame)
aiContainer.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
aiContainer.Size = UDim2.new(1, 0, 0, 34)
aiContainer.LayoutOrder = 2
Instance.new("UICorner", aiContainer).CornerRadius = UDim.new(0, 8)
local aiLabel = Instance.new("TextLabel", aiContainer)
aiLabel.BackgroundTransparency = 1
aiLabel.Position = UDim2.new(0, 10, 0, 0)
aiLabel.Size = UDim2.new(1, -65, 1, 0)
aiLabel.Text = "AI  -  OFF"
aiLabel.TextColor3 = Color3.fromRGB(185, 175, 210)
aiLabel.TextSize = 11
aiLabel.TextXAlignment = Enum.TextXAlignment.Left
aiLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local aiSwitchBg = Instance.new("Frame", aiContainer)
aiSwitchBg.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
aiSwitchBg.Position = UDim2.new(1, -50, 0.5, -10)
aiSwitchBg.Size = UDim2.new(0, 40, 0, 20)
Instance.new("UICorner", aiSwitchBg).CornerRadius = UDim.new(0, 10)
local aiSwitchDot = Instance.new("Frame", aiSwitchBg)
aiSwitchDot.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
aiSwitchDot.Position = UDim2.new(0, 2, 0.5, -8)
aiSwitchDot.Size = UDim2.new(0, 16, 0, 16)
Instance.new("UICorner", aiSwitchDot).CornerRadius = UDim.new(0, 8)

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
		aiSwitchDot.Position = UDim2.new(1, -18, 0.5, -8)
	else
		aiLabel.Text = "AI  -  OFF"
		aiLabel.TextColor3 = Color3.fromRGB(185, 175, 210)
		aiSwitchBg.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
		aiSwitchDot.Position = UDim2.new(0, 2, 0.5, -8)
	end
end)

local listenContainer = Instance.new("Frame", G.ScrollingFrame)
listenContainer.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
listenContainer.Size = UDim2.new(1, 0, 0, 34)
listenContainer.LayoutOrder = 3
Instance.new("UICorner", listenContainer).CornerRadius = UDim.new(0, 8)
local listenLabel = Instance.new("TextLabel", listenContainer)
listenLabel.BackgroundTransparency = 1
listenLabel.Position = UDim2.new(0, 10, 0, 0)
listenLabel.Size = UDim2.new(1, -65, 1, 0)
listenLabel.Text = "LISTEN  -  OFF"
listenLabel.TextColor3 = Color3.fromRGB(185, 175, 210)
listenLabel.TextSize = 11
listenLabel.TextXAlignment = Enum.TextXAlignment.Left
listenLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local listenSwitchBg = Instance.new("Frame", listenContainer)
listenSwitchBg.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
listenSwitchBg.Position = UDim2.new(1, -50, 0.5, -10)
listenSwitchBg.Size = UDim2.new(0, 40, 0, 20)
Instance.new("UICorner", listenSwitchBg).CornerRadius = UDim.new(0, 10)
local listenSwitchDot = Instance.new("Frame", listenSwitchBg)
listenSwitchDot.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
listenSwitchDot.Position = UDim2.new(0, 2, 0.5, -8)
listenSwitchDot.Size = UDim2.new(0, 16, 0, 16)
Instance.new("UICorner", listenSwitchDot).CornerRadius = UDim.new(0, 8)

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
		listenSwitchDot.Position = UDim2.new(1, -18, 0.5, -8)
	else
		listenLabel.Text = "LISTEN  -  OFF"
		listenLabel.TextColor3 = Color3.fromRGB(185, 175, 210)
		listenSwitchBg.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
		listenSwitchDot.Position = UDim2.new(0, 2, 0.5, -8)
	end
end)

-- Preguntas y Respuestas
local qFrame = Instance.new("Frame", G.ScrollingFrame)
qFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
qFrame.Size = UDim2.new(1, 0, 0, 54)
qFrame.LayoutOrder = 4
Instance.new("UICorner", qFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", qFrame).Color = Color3.fromRGB(42, 35, 52)

local qTitle = Instance.new("TextLabel", qFrame)
qTitle.BackgroundTransparency = 1
qTitle.Position = UDim2.new(0, 10, 0, 4)
qTitle.Size = UDim2.new(1, -12, 0, 10)
qTitle.Text = "QUESTION"
qTitle.TextColor3 = Color3.fromRGB(140, 60, 220)
qTitle.TextSize = 8
qTitle.TextXAlignment = Enum.TextXAlignment.Left
qTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local qContent = Instance.new("TextLabel", qFrame)
qContent.BackgroundTransparency = 1
qContent.Position = UDim2.new(0, 10, 0, 15)
qContent.Size = UDim2.new(1, -20, 0, 35)
qContent.Text = "Esperando acertijo..."
qContent.TextColor3 = Color3.fromRGB(185, 175, 210)
qContent.TextSize = 9
qContent.TextWrapped = true
qContent.TextXAlignment = Enum.TextXAlignment.Left
qContent.TextYAlignment = Enum.TextYAlignment.Top
qContent.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)

local ansFrame = Instance.new("Frame", G.ScrollingFrame)
ansFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
ansFrame.Size = UDim2.new(1, 0, 0, 48)
ansFrame.LayoutOrder = 5
Instance.new("UICorner", ansFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", ansFrame).Color = Color3.fromRGB(140, 60, 220)

local ansTitle = Instance.new("TextLabel", ansFrame)
ansTitle.BackgroundTransparency = 1
ansTitle.Position = UDim2.new(0, 10, 0, 4)
ansTitle.Size = UDim2.new(1, -12, 0, 10)
ansTitle.Text = "ANSWER"
ansTitle.TextColor3 = Color3.fromRGB(140, 60, 220)
ansTitle.TextSize = 8
ansTitle.TextXAlignment = Enum.TextXAlignment.Left
ansTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local ansBox = Instance.new("TextBox", ansFrame)
ansBox.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
ansBox.Position = UDim2.new(0, 8, 0, 16)
ansBox.Size = UDim2.new(1, -16, 0, 26)
ansBox.Text = ""
ansBox.TextColor3 = Color3.fromRGB(180, 120, 255)
ansBox.TextSize = 12
ansBox.PlaceholderText = "la respuesta..."
ansBox.PlaceholderColor3 = Color3.fromRGB(185, 175, 210)
ansBox.ClearTextOnFocus = false
ansBox.TextXAlignment = Enum.TextXAlignment.Left
ansBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
Instance.new("UICorner", ansBox).CornerRadius = UDim.new(0, 6)

local actionFrame = Instance.new("Frame", G.ScrollingFrame)
actionFrame.BackgroundTransparency = 1
actionFrame.Size = UDim2.new(1, 0, 0, 28)
actionFrame.LayoutOrder = 6
local actionLayout = Instance.new("UIListLayout", actionFrame)
actionLayout.FillDirection = Enum.FillDirection.Horizontal
actionLayout.Padding = UDim.new(0, 5)
actionLayout.SortOrder = Enum.SortOrder.LayoutOrder

local copyBtn = Instance.new("TextButton", actionFrame)
copyBtn.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
copyBtn.Size = UDim2.new(0.33, -4, 1, 0)
copyBtn.Text = "COPY"
copyBtn.TextColor3 = Color3.fromRGB(245, 240, 255)
copyBtn.TextSize = 10
copyBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)

local clearBtn = Instance.new("TextButton", actionFrame)
clearBtn.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
clearBtn.Size = UDim2.new(0.33, -4, 1, 0)
clearBtn.Text = "CLEAR"
clearBtn.TextColor3 = Color3.fromRGB(245, 240, 255)
clearBtn.TextSize = 10
clearBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)

local redeemBtn = Instance.new("TextButton", actionFrame)
redeemBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 220)
redeemBtn.Size = UDim2.new(0.33, -4, 1, 0)
redeemBtn.Text = "REDEEM"
redeemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
redeemBtn.TextSize = 11
redeemBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
Instance.new("UICorner", redeemBtn).CornerRadius = UDim.new(0, 6)

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

createToggle(G.ScrollingFrame, 7, "AUTO REDEEM ANSWER", function(state) end)
createToggle(G.ScrollingFrame, 8, "SECURE ANSWER (1-3)", function(state) end)
createToggle(G.ScrollingFrame, 9, "AUTO COPY ANSWER", function(state) end)
createToggle(G.ScrollingFrame, 10, "OPEN FEED ON HIT", function(state) end)

-- Selector de Modelo
local modelFrame = Instance.new("Frame", G.ScrollingFrame)
modelFrame.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
modelFrame.Size = UDim2.new(1, 0, 0, 28)
modelFrame.LayoutOrder = 11
Instance.new("UICorner", modelFrame).CornerRadius = UDim.new(0, 8)

local modelText = Instance.new("TextLabel", modelFrame)
modelText.BackgroundTransparency = 1
modelText.Position = UDim2.new(0, 10, 0, 0)
modelText.Size = UDim2.new(0, 50, 0, 28)
modelText.Text = "MODEL"
modelText.TextColor3 = Color3.fromRGB(185, 175, 210)
modelText.TextSize = 10
modelText.TextXAlignment = Enum.TextXAlignment.Left
modelText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)

local switchModelBg = Instance.new("Frame", modelFrame)
switchModelBg.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
switchModelBg.Position = UDim2.new(1, -152, 0.5, -9)
switchModelBg.Size = UDim2.new(0, 144, 0, 20)
Instance.new("UICorner", switchModelBg).CornerRadius = UDim.new(0, 6)

local fasterBtn = Instance.new("TextButton", switchModelBg)
fasterBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 220)
fasterBtn.Position = UDim2.new(0, 1, 0, 1)
fasterBtn.Size = UDim2.new(0.5, -2, 1, -2)
fasterBtn.Text = "FASTER"
fasterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fasterBtn.TextSize = 9
fasterBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", fasterBtn).CornerRadius = UDim.new(0, 5)

local fastBtn = Instance.new("TextButton", switchModelBg)
fastBtn.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
fastBtn.Position = UDim2.new(0.5, 1, 0, 1)
fastBtn.Size = UDim2.new(0.5, -2, 1, -2)
fastBtn.Text = "FAST"
fastBtn.TextColor3 = Color3.fromRGB(185, 175, 210)
fastBtn.TextSize = 9
fastBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", fastBtn).CornerRadius = UDim.new(0, 5)

fasterBtn.MouseButton1Click:Connect(function()
	fasterBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 220)
	fasterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	fastBtn.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
	fastBtn.TextColor3 = Color3.fromRGB(185, 175, 210)
end)

fastBtn.MouseButton1Click:Connect(function()
	fastBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 220)
	fastBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	fasterBtn.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
	fasterBtn.TextColor3 = Color3.fromRGB(185, 175, 210)
end)

-- [APARTADO: AYUDA - ROBA UN BRAINROT]
local helpHeaderContainer = Instance.new("Frame", G.ScrollingFrame)
helpHeaderContainer.BackgroundColor3 = Color3.fromRGB(24, 20, 32)
helpHeaderContainer.Size = UDim2.new(1, 0, 0, 24)
helpHeaderContainer.LayoutOrder = 12
Instance.new("UICorner", helpHeaderContainer).CornerRadius = UDim.new(0, 6)

local helpHeaderText = Instance.new("TextLabel", helpHeaderContainer)
helpHeaderText.BackgroundTransparency = 1
helpHeaderText.Position = UDim2.new(0, 10, 0, 0)
helpHeaderText.Size = UDim2.new(1, -10, 1, 0)
helpHeaderText.Text = "--- AYUDA : ROBA UN BRAINROT ---"
helpHeaderText.TextColor3 = Color3.fromRGB(180, 120, 255)
helpHeaderText.TextSize = 9
helpHeaderText.TextXAlignment = Enum.TextXAlignment.Left
helpHeaderText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

-- ==========================================
-- [ANTI RAGDOLL OPTIMIZADO]
-- ==========================================
local antiRagdollActive = false
RunService.Stepped:Connect(function()
	if antiRagdollActive then
		local char = player.Character
		if char then
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			local rootPart = char:FindFirstChild("HumanoidRootPart")
			if humanoid and rootPart then
				local state = humanoid:GetState()
				if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
					rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y, 0)
					humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				end
			end
		end
	end
end)

createToggle(G.ScrollingFrame, 13, "ANTI RAGDOLL", function(state)
	antiRagdollActive = state
end)

-- ==========================================
-- [AUTO COMPRAR MEJORADO PARA BRAINROTS]
-- ==========================================
local autoBuyActive = false
task.spawn(function()
	while true do
		if autoBuyActive then
			pcall(function()
				for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
					if obj:IsA("RemoteEvent") then
						local name = string.lower(obj.Name)
						if name:find("buy") or name:find("purchase") or name:find("comprar") or name:find("brainrot") or name:find("spin") or name:find("roll") then
							obj:FireServer()
						end
					end
				end
			end)
		end
		task.wait(0.3)
	end
end)

createToggle(G.ScrollingFrame, 14, "AUTO COMPRAR (BRAINROT)", function(state)
	autoBuyActive = state
end)

-- ==========================================
-- [ANTI-LAG OPTIMIZADO]
-- ==========================================
local antiLagActive = false
createToggle(G.ScrollingFrame, 15, "ANTI-LAG (OPTIMIZADOR)", function(state)
	antiLagActive = state
	if antiLagActive then
		pcall(function()
			Lighting.GlobalShadows = false
			Lighting.Brightness = 2
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
			
			for _, v in ipairs(Workspace:GetDescendants()) do
				if v:IsA("BasePart") then
					v.Material = Enum.Material.SmoothPlastic
					v.Reflectance = 0
				elseif v:IsA("Decal") or v:IsA("Texture") then
					v.Transparency = 1
				end
			end
		end)
		print("Haven Hub: Anti-Lag activado correctamente.")
	else
		pcall(function()
			Lighting.GlobalShadows = true
		end)
		print("Haven Hub: Anti-Lag desactivado.")
	end
end)


-- ==========================================
-- VENTANA FEED (CENTRADA Y MOVIBLE)
-- ==========================================
local Feed = Instance.new("Frame", G.HavenHub)
Feed.Name = "Feed"
Feed.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
Feed.AnchorPoint = Vector2.new(0.5, 0.5)
Feed.Position = UDim2.new(0.5, 0, 0.5, 0)
Feed.Size = UDim2.new(0, 300, 0, 320)
Feed.Visible = false
Instance.new("UICorner", Feed).CornerRadius = UDim.new(0, 12)
local feedStroke = Instance.new("UIStroke", Feed)
feedStroke.Color = Color3.fromRGB(140, 60, 220)
feedStroke.Thickness = 1.5
feedStroke.Transparency = 0.2

local fHeader = Instance.new("Frame", Feed)
fHeader.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
fHeader.Size = UDim2.new(1, 0, 0, 36)
Instance.new("UICorner", fHeader).CornerRadius = UDim.new(0, 12)
makeDraggable(fHeader, Feed)

local fTitle = Instance.new("TextLabel", fHeader)
fTitle.BackgroundTransparency = 1
fTitle.Position = UDim2.new(0, 10, 0, 0)
fTitle.Size = UDim2.new(1, -40, 1, 0)
fTitle.Text = "SOLVE LOG (FEED)"
fTitle.TextColor3 = Color3.fromRGB(245, 240, 255)
fTitle.TextSize = 12
fTitle.TextXAlignment = Enum.TextXAlignment.Left
fTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local closeFeed = Instance.new("TextButton", fHeader)
closeFeed.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
closeFeed.Position = UDim2.new(1, -28, 0.5, -10)
closeFeed.Size = UDim2.new(0, 20, 0, 20)
closeFeed.Text = "X"
closeFeed.TextColor3 = Color3.fromRGB(245, 240, 255)
Instance.new("UICorner", closeFeed).CornerRadius = UDim.new(0, 4)

local feedScroll = Instance.new("ScrollingFrame", Feed)
feedScroll.BackgroundTransparency = 1
feedScroll.Position = UDim2.new(0, 8, 0, 45)
feedScroll.Size = UDim2.new(1, -16, 1, -55)
feedScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
feedScroll.ScrollBarThickness = 3
feedScroll.ScrollBarImageColor3 = Color3.fromRGB(140, 60, 220)

local feedList = Instance.new("UIListLayout", feedScroll)
feedList.Padding = UDim.new(0, 4)

local feedLogText = Instance.new("TextLabel", feedScroll)
feedLogText.BackgroundTransparency = 1
feedLogText.Size = UDim2.new(1, 0, 1, 0)
feedLogText.Text = "[HavenHub] Sistema iniciado con éxito.\nEsperando registros de aciertos..."
feedLogText.TextColor3 = Color3.fromRGB(185, 175, 210)
feedLogText.TextSize = 10
feedLogText.TextXAlignment = Enum.TextXAlignment.Left
feedLogText.TextYAlignment = Enum.TextYAlignment.Top
feedLogText.TextWrapped = true
feedLogText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)

closeFeed.MouseButton1Click:Connect(function()
	cerrarVentana(Feed)
end)

G.TextButton_2.MouseButton1Click:Connect(function()
	if Feed.Visible then
		cerrarVentana(Feed)
	else
		abrirVentana(Feed, UDim2.new(0, 300, 0, 320))
	end
end)


-- ==========================================
-- VENTANA TEST (CENTRADA Y MOVIBLE)
-- ==========================================
local TestWindow = Instance.new("Frame", G.HavenHub)
TestWindow.Name = "TestWindow"
TestWindow.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
TestWindow.AnchorPoint = Vector2.new(0.5, 0.5)
TestWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
TestWindow.Size = UDim2.new(0, 260, 0, 180)
TestWindow.Visible = false
Instance.new("UICorner", TestWindow).CornerRadius = UDim.new(0, 12)
local testStroke = Instance.new("UIStroke", TestWindow)
testStroke.Color = Color3.fromRGB(140, 60, 220)
testStroke.Thickness = 1.5
testStroke.Transparency = 0.2

local tHeader = Instance.new("Frame", TestWindow)
tHeader.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
tHeader.Size = UDim2.new(1, 0, 0, 36)
Instance.new("UICorner", tHeader).CornerRadius = UDim.new(0, 12)
makeDraggable(tHeader, TestWindow)

local tTitle = Instance.new("TextLabel", tHeader)
tTitle.BackgroundTransparency = 1
tTitle.Position = UDim2.new(0, 10, 0, 0)
tTitle.Size = UDim2.new(1, -40, 1, 0)
tTitle.Text = "TEST SENDER"
tTitle.TextColor3 = Color3.fromRGB(245, 240, 255)
tTitle.TextSize = 12
tTitle.TextXAlignment = Enum.TextXAlignment.Left
tTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local closeTestBtn = Instance.new("TextButton", tHeader)
closeTestBtn.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
closeTestBtn.Position = UDim2.new(1, -26, 0.5, -10)
closeTestBtn.Size = UDim2.new(0, 20, 0, 20)
closeTestBtn.Text = "X"
closeTestBtn.TextColor3 = Color3.fromRGB(245, 240, 255)
Instance.new("UICorner", closeTestBtn).CornerRadius = UDim.new(0, 4)

local testContentBox = Instance.new("TextBox", TestWindow)
testContentBox.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
testContentBox.Position = UDim2.new(0, 10, 0, 45)
testContentBox.Size = UDim2.new(1, -20, 0, 75)
testContentBox.Text = "Mensaje de prueba..."
testContentBox.TextColor3 = Color3.fromRGB(180, 120, 255)
testContentBox.TextSize = 11
testContentBox.ClearTextOnFocus = false
testContentBox.TextXAlignment = Enum.TextXAlignment.Left
testContentBox.TextYAlignment = Enum.TextYAlignment.Top
testContentBox.TextWrapped = true
Instance.new("UICorner", testContentBox).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", testContentBox).Color = Color3.fromRGB(42, 35, 52)

local testSendBtn = Instance.new("TextButton", TestWindow)
testSendBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 220)
testSendBtn.Position = UDim2.new(0, 10, 0, 130)
testSendBtn.Size = UDim2.new(1, -20, 0, 32)
testSendBtn.Text = "ENVIAR PRUEBA"
testSendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
testSendBtn.TextSize = 11
testSendBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
Instance.new("UICorner", testSendBtn).CornerRadius = UDim.new(0, 8)

testSendBtn.MouseButton1Click:Connect(function()
	testSendBtn.Text = "¡ENVIADO!"
	task.wait(1)
	testSendBtn.Text = "ENVIAR PRUEBA"
end)

closeTestBtn.MouseButton1Click:Connect(function()
	cerrarVentana(TestWindow)
end)

G.TextButton.MouseButton1Click:Connect(function()
	if TestWindow.Visible then
		cerrarVentana(TestWindow)
	else
		abrirVentana(TestWindow, UDim2.new(0, 260, 0, 180))
	end
end)

print("¡HAVEN HUB actualizado con éxito: Anti Ragdoll, Auto Comprar y Anti-Lag integrados!")