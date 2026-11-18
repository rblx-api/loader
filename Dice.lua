-- Delta Executor Compact Sliced-Height Dice Script
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Remove existing GUI if already running
if CoreGui:FindFirstChild("ShortHeightDiceGui") then
    CoreGui.ShortHeightDiceGui:Destroy()
end

-- Create ScreenGui (with fallback to PlayerGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShortHeightDiceGui"
screenGui.Parent = CoreGui
if not screenGui.Parent then
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Spin Sound Effect
local spinSound = Instance.new("Sound")
spinSound.SoundId = "rbxassetid://9061477123"
spinSound.Volume = 1
spinSound.Parent = screenGui

-- Main Window Frame (Height shortened to stop right at the spin button)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 245)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -122)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 215, 0)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -145, 0, 24)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Dice Roller"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- =================================================
-- CUSTOM THEMES (Heaven Gates, Tunnel Car, Hell, Dark Tech)
-- =================================================
local themes = {
    {
        Name = "Heaven Gates", 
        Bg = Color3.fromRGB(250, 245, 230),  
        Panel = Color3.fromRGB(255, 238, 190), 
        Text = Color3.fromRGB(120, 70, 10),   
        Stroke = Color3.fromRGB(218, 165, 32)
    },
    {
        Name = "Tunnel Car", 
        Bg = Color3.fromRGB(25, 30, 40),     
        Panel = Color3.fromRGB(40, 50, 70),    
        Text = Color3.fromRGB(135, 206, 250), 
        Stroke = Color3.fromRGB(0, 191, 255)
    },
    {
        Name = "Hell", 
        Bg = Color3.fromRGB(28, 8, 8),        
        Panel = Color3.fromRGB(48, 14, 14),    
        Text = Color3.fromRGB(255, 100, 100),
        Stroke = Color3.fromRGB(255, 69, 0)
    },
    {
        Name = "Dark Tech", 
        Bg = Color3.fromRGB(18, 18, 22),     
        Panel = Color3.fromRGB(26, 26, 32),     
        Text = Color3.fromRGB(240, 240, 255),
        Stroke = Color3.fromRGB(70, 70, 95)
    }
}
local currentThemeIndex = 1
local themePanels = {}
local themeTexts = {}

local function applyTheme(index)
    local t = themes[index]
    mainFrame.BackgroundColor3 = t.Bg
    title.TextColor3 = t.Text
    mainStroke.Color = t.Stroke
    for _, panel in ipairs(themePanels) do
        if panel and panel.Parent then panel.BackgroundColor3 = t.Panel end
    end
    for _, txt in ipairs(themeTexts) do
        if txt and txt.Parent then txt.TextColor3 = t.Text end
    end
end

-- Theme Cycle Button
local themeButton = Instance.new("TextButton")
themeButton.Size = UDim2.new(0, 65, 0, 18)
themeButton.Position = UDim2.new(1, -140, 0, 3)
themeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
themeButton.Font = Enum.Font.GothamBold
themeButton.Text = themes[1].Name
themeButton.TextColor3 = Color3.fromRGB(255, 215, 0)
themeButton.TextSize = 7.5
themeButton.Parent = mainFrame

local themeCorner = Instance.new("UICorner")
themeCorner.CornerRadius = UDim.new(0, 4)
themeCorner.Parent = themeButton

themeButton.MouseButton1Click:Connect(function()
    currentThemeIndex = currentThemeIndex + 1
    if currentThemeIndex > #themes then currentThemeIndex = 1 end
    themeButton.Text = themes[currentThemeIndex].Name
    applyTheme(currentThemeIndex)
end)
-- =================================================

-- =================================================
-- "SKIN FACE DICE" BUTTON (Hides / Minimizes GUI)
-- =================================================
local isHidden = false
local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(0, 68, 0, 18)
hideButton.Position = UDim2.new(1, -70, 0, 3)
hideButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
hideButton.Font = Enum.Font.GothamBold
hideButton.Text = "Skin Face Dice"
hideButton.TextColor3 = Color3.fromRGB(200, 200, 220)
hideButton.TextSize = 7.5
hideButton.Parent = mainFrame

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 4)
hideCorner.Parent = hideButton

local contentContainer = Instance.new("Folder")
contentContainer.Name = "ContentContainer"
contentContainer.Parent = mainFrame

hideButton.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    if isHidden then
        mainFrame.Size = UDim2.new(0, 260, 0, 24)
        hideButton.Text = "Show"
        for _, child in ipairs(contentContainer:GetChildren()) do child.Visible = false end
    else
        mainFrame.Size = UDim2.new(0, 260, 0, 245)
        hideButton.Text = "Skin Face Dice"
        for _, child in ipairs(contentContainer:GetChildren()) do child.Visible = true end
    end
end)
-- =================================================

-- Dice Container (Horizontal layout for the 4 compact dice)
local diceContainer = Instance.new("Frame")
diceContainer.Size = UDim2.new(1, -16, 0, 38)
diceContainer.Position = UDim2.new(0, 8, 0, 25)
diceContainer.BackgroundTransparency = 1
diceContainer.Parent = contentContainer

local uiLayout = Instance.new("UIListLayout")
uiLayout.FillDirection = Enum.FillDirection.Horizontal
uiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0, 4)
uiLayout.Parent = diceContainer

-- Available Colors Palette
local colorList = {
    {Name = "Purple", Color = Color3.fromRGB(147, 112, 219)},
    {Name = "Blue",   Color = Color3.fromRGB(65, 105, 225)},
    {Name = "Green",  Color = Color3.fromRGB(50, 205, 50)},
    {Name = "Yellow", Color = Color3.fromRGB(255, 215, 0)},
    {Name = "Orange", Color = Color3.fromRGB(255, 140, 0)},
    {Name = "Red",    Color = Color3.fromRGB(220, 20, 60)}
}

local function applySingleDot(diceFrame)
    for _, child in ipairs(diceFrame:GetChildren()) do
        if child.Name == "Dot" then child:Destroy() end
    end
    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.Size = UDim2.new(0, 7, 0, 7)
    dot.Position = UDim2.new(0.5, -3.5, 0.5, -3.5)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    dot.Parent = diceFrame
end

local diceFrames = {}
for i = 1, 4 do
    local dice = Instance.new("Frame")
    dice.Size = UDim2.new(0, 52, 0, 38)
    dice.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dice.BorderSizePixel = 0
    dice.Parent = diceContainer
    
    local diceCorner = Instance.new("UICorner")
    diceCorner.CornerRadius = UDim.new(0, 5)
    diceCorner.Parent = dice
    
    local diceStroke = Instance.new("UIStroke")
    diceStroke.Color = Color3.fromRGB(255, 255, 255)
    diceStroke.Transparency = 0.3
    diceStroke.Thickness = 1
    diceStroke.Parent = dice
    
    table.insert(diceFrames, dice)
end

-- Profit Display Panel
local trackerFrame = Instance.new("Frame")
trackerFrame.Size = UDim2.new(1, -16, 0, 22)
trackerFrame.Position = UDim2.new(0, 8, 0, 66)
trackerFrame.BackgroundColor3 = themes[1].Panel
trackerFrame.BorderSizePixel = 0
trackerFrame.Parent = contentContainer
table.insert(themePanels, trackerFrame)

local trackerCorner = Instance.new("UICorner")
trackerCorner.CornerRadius = UDim.new(0, 4)
trackerCorner.Parent = trackerFrame

local profitTitleLabel = Instance.new("TextLabel")
profitTitleLabel.Size = UDim2.new(0.4, 0, 1, 0)
profitTitleLabel.Position = UDim2.new(0, 6, 0, 0)
profitTitleLabel.BackgroundTransparency = 1
profitTitleLabel.Font = Enum.Font.GothamBold
profitTitleLabel.Text = "PROFIT:"
profitTitleLabel.TextColor3 = themes[1].Text
profitTitleLabel.TextSize = 9.5
profitTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
profitTitleLabel.Parent = trackerFrame
table.insert(themeTexts, profitTitleLabel)

local profitValueLabel = Instance.new("TextLabel")
profitValueLabel.Size = UDim2.new(0.6, -6, 1, 0)
profitValueLabel.Position = UDim2.new(0.4, 0, 0, 0)
profitValueLabel.BackgroundTransparency = 1
profitValueLabel.Font = Enum.Font.GothamBold
profitValueLabel.Text = "0"
profitValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
profitValueLabel.TextSize = 10
profitValueLabel.TextXAlignment = Enum.TextXAlignment.Right
profitValueLabel.Parent = trackerFrame

local currentProfit = 0
local function updateProfitDisplay()
    profitValueLabel.Text = tostring(currentProfit)
    if currentProfit > 0 then
        profitValueLabel.TextColor3 = Color3.fromRGB(50, 205, 50)
    elseif currentProfit < 0 then
        profitValueLabel.TextColor3 = Color3.fromRGB(220, 20, 60)
    else
        profitValueLabel.TextColor3 = themes[currentThemeIndex].Text
    end
end

-- =================================================
-- RECENT ROLLS HISTORY LOG (#1 at top, up to #10 at bottom - Square Blocks)
-- =================================================
local historyFrame = Instance.new("Frame")
historyFrame.Size = UDim2.new(1, -16, 0, 78)
historyFrame.Position = UDim2.new(0, 8, 0, 91)
historyFrame.BackgroundColor3 = themes[1].Panel
historyFrame.BorderSizePixel = 0
historyFrame.Parent = contentContainer
table.insert(themePanels, historyFrame)

local historyCorner = Instance.new("UICorner")
historyCorner.CornerRadius = UDim.new(0, 4)
historyCorner.Parent = historyFrame

local historyTitle = Instance.new("TextLabel")
historyTitle.Size = UDim2.new(1, 0, 0, 13)
historyTitle.Position = UDim2.new(0, 5, 0, 1)
historyTitle.BackgroundTransparency = 1
historyTitle.Font = Enum.Font.GothamBold
historyTitle.Text = "Recent Rolls (#1 to #10):"
historyTitle.TextColor3 = themes[1].Text
historyTitle.TextSize = 8
historyTitle.TextXAlignment = Enum.TextXAlignment.Left
historyTitle.Parent = historyFrame
table.insert(themeTexts, historyTitle)

local historyScroll = Instance.new("ScrollingFrame")
historyScroll.Size = UDim2.new(1, -6, 1, -14)
historyScroll.Position = UDim2.new(0, 3, 0, 13)
historyScroll.BackgroundTransparency = 1
historyScroll.BorderSizePixel = 0
historyScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
historyScroll.ScrollBarThickness = 2
historyScroll.Parent = historyFrame

local historyLayout = Instance.new("UIListLayout")
historyLayout.FillDirection = Enum.FillDirection.Vertical
historyLayout.SortOrder = Enum.SortOrder.LayoutOrder
historyLayout.Padding = UDim.new(0, 2)
historyLayout.Parent = historyScroll

local recentRollsData = {}

local function updateHistoryDisplay()
    for _, child in ipairs(historyScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    for index, rollColors in ipairs(recentRollsData) do
        local rowContainer = Instance.new("Frame")
        rowContainer.Size = UDim2.new(1, 0, 0, 11)
        rowContainer.BackgroundTransparency = 1
        rowContainer.Parent = historyScroll
        
        local numLabel = Instance.new("TextLabel")
        numLabel.Size = UDim2.new(0, 16, 1, 0)
        numLabel.BackgroundTransparency = 1
        numLabel.Font = Enum.Font.GothamBold
        numLabel.Text = "#" .. index
        numLabel.TextColor3 = themes[currentThemeIndex].Text
        numLabel.TextSize = 7.5
        numLabel.TextXAlignment = Enum.TextXAlignment.Left
        numLabel.Parent = rowContainer
        table.insert(themeTexts, numLabel)
        
        local boxesContainer = Instance.new("Frame")
        boxesContainer.Size = UDim2.new(1, -18, 1, 0)
        boxesContainer.Position = UDim2.new(0, 16, 0, 0)
        boxesContainer.BackgroundTransparency = 1
        boxesContainer.Parent = rowContainer
        
        local rowLayout = Instance.new("UIListLayout")
        rowLayout.FillDirection = Enum.FillDirection.Horizontal
        rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
        rowLayout.Padding = UDim.new(0, 3)
        rowLayout.Parent = boxesContainer
        
        for _, colData in ipairs(rollColors) do
            local colorBox = Instance.new("Frame")
            colorBox.Size = UDim2.new(0, 11, 0, 11)
            colorBox.BackgroundColor3 = colData.Color
            colorBox.BorderSizePixel = 0
            colorBox.Parent = boxesContainer
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 2)
            boxCorner.Parent = colorBox
        end
    end
    historyScroll.CanvasSize = UDim2.new(0, 0, 0, #recentRollsData * 13)
end
-- =================================================

-- Plus (+) and Minus (-) Profit Buttons
local plusButton = Instance.new("TextButton")
plusButton.Size = UDim2.new(0, 25, 0, 25)
plusButton.Position = UDim2.new(0, 8, 0, 173)
plusButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
plusButton.Font = Enum.Font.GothamBold
plusButton.Text = "+"
plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
plusButton.TextSize = 13
plusButton.Parent = contentContainer

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 4)
plusCorner.Parent = plusButton

plusButton.MouseButton1Click:Connect(function()
    currentProfit = currentProfit + 1
    updateProfitDisplay()
end)

local minusButton = Instance.new("TextButton")
minusButton.Size = UDim2.new(0, 25, 0, 25)
minusButton.Position = UDim2.new(0, 36, 0, 173)
minusButton.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
minusButton.Font = Enum.Font.GothamBold
minusButton.Text = "-"
minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minusButton.TextSize = 13
minusButton.Parent = contentContainer

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 4)
minusCorner.Parent = minusButton

minusButton.MouseButton1Click:Connect(function()
    currentProfit = currentProfit - 1
    updateProfitDisplay()
end)

-- Spin Button
local spinButton = Instance.new("TextButton")
spinButton.Size = UDim2.new(1, -66, 0, 25)
spinButton.Position = UDim2.new(0, 64, 0, 173)
spinButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
spinButton.Font = Enum.Font.GothamBold
spinButton.Text = "SPIN DICE"
spinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spinButton.TextSize = 10
spinButton.Parent = contentContainer

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 4)
btnCorner.Parent = spinButton

-- Lag-Free 100% Fair Spin Animation Logic
local isSpinning = false
local function spinDice()
    if isSpinning then return end
    isSpinning = true
    spinButton.Text = "SPINNING..."
    
    spinSound:Play()
    
    local elapsed = 0
    local duration = 0.5
    local interval = 0.07
    local timer = 0
    
    while elapsed < duration do
        local dt = RunService.RenderStepped:Wait()
        elapsed = elapsed + dt
        timer = timer + dt
        
        if timer >= interval then
            timer = 0
            for _, diceFrame in ipairs(diceFrames) do
                local randomColorData = colorList[math.random(1, #colorList)]
                diceFrame.BackgroundColor3 = randomColorData.Color
                applySingleDot(diceFrame)
            end
        end
    end
    
    local rollColorSet = {}
    for _, diceFrame in ipairs(diceFrames) do
        local finalColorData = colorList[math.random(1, #colorList)]
        diceFrame.BackgroundColor3 = finalColorData.Color
        applySingleDot(diceFrame)
        table.insert(rollColorSet, finalColorData)
    end
    
    table.insert(recentRollsData, 1, rollColorSet)
    if #recentRollsData > 10 then
        table.remove(recentRollsData, 11)
    end
    updateHistoryDisplay()
    
    spinButton.Text = "SPIN DICE"
    isSpinning = false
end

spinButton.MouseButton1Click:Connect(spinDice)

-- Apply initial theme setup
applyTheme(1)

-- Initial spin on execution
spinDice()