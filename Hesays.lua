-- Delta Executor Advanced Theme-Selectable Fair Dice Script
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Remove existing GUI if already running
if CoreGui:FindFirstChild("ThemedDiceGui") then
    CoreGui.ThemedDiceGui:Destroy()
end

-- Create ScreenGui (with fallback to PlayerGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ThemedDiceGui"
screenGui.Parent = CoreGui
if not screenGui.Parent then
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Main Window Frame (Compact & Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 310, 0, 375)
mainFrame.Position = UDim2.new(0.5, -155, 0.5, -187)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 80)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -170, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Advanced Dice"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- =================================================
-- BACKGROUND THEMES CONFIGURATION
-- =================================================
local themes = {
    {Name = "Dark Tech",     Bg = Color3.fromRGB(20, 20, 24),     Panel = Color3.fromRGB(28, 28, 35)},
    {Name = "Midnight Blue", Bg = Color3.fromRGB(15, 25, 45),     Panel = Color3.fromRGB(22, 36, 62)},
    {Name = "Deep Purple",   Bg = Color3.fromRGB(30, 15, 40),     Panel = Color3.fromRGB(45, 24, 60)},
    {Name = "Crimson Dark",  Bg = Color3.fromRGB(40, 15, 15),     Panel = Color3.fromRGB(60, 22, 22)},
    {Name = "Forest Green",  Bg = Color3.fromRGB(15, 35, 25),     Panel = Color3.fromRGB(22, 50, 36)},
    {Name = "Pure Clean",    Bg = Color3.fromRGB(40, 40, 40),     Panel = Color3.fromRGB(55, 55, 55)}
}
local currentThemeIndex = 1

-- Forward declaration for container elements to apply themes to
local themeUpdateTargets = {}

local function applyTheme(index)
    local t = themes[index]
    mainFrame.BackgroundColor3 = t.Bg
    for _, panel in ipairs(themeUpdateTargets) do
        if panel and panel.Parent then
            panel.BackgroundColor3 = t.Panel
        end
    end
end

-- Theme Cycle Button
local themeButton = Instance.new("TextButton")
themeButton.Size = UDim2.new(0, 68, 0, 22)
themeButton.Position = UDim2.new(1, -168, 0, 4)
themeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
themeButton.Font = Enum.Font.GothamBold
themeButton.Text = "Theme"
themeButton.TextColor3 = Color3.fromRGB(220, 220, 240)
themeButton.TextSize = 9
themeButton.Parent = mainFrame

local themeCorner = Instance.new("UICorner")
themeCorner.CornerRadius = UDim.new(0, 5)
themeCorner.Parent = themeButton

themeButton.MouseButton1Click:Connect(function()
    currentThemeIndex = currentThemeIndex + 1
    if currentThemeIndex > #themes then
        currentThemeIndex = 1
    end
    themeButton.Text = themes[currentThemeIndex].Name
    applyTheme(currentThemeIndex)
end)
-- =================================================

-- =================================================
-- "SKIN FACE DICE" BUTTON (Hides / Minimizes GUI)
-- =================================================
local isHidden = false
local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(0, 85, 0, 22)
hideButton.Position = UDim2.new(1, -95, 0, 4)
hideButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
hideButton.Font = Enum.Font.GothamBold
hideButton.Text = "Skin Face Dice"
hideButton.TextColor3 = Color3.fromRGB(200, 200, 220)
hideButton.TextSize = 9
hideButton.Parent = mainFrame

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 5)
hideCorner.Parent = hideButton

local contentContainer = Instance.new("Folder")
contentContainer.Name = "ContentContainer"
contentContainer.Parent = mainFrame

hideButton.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    if isHidden then
        mainFrame.Size = UDim2.new(0, 310, 0, 30)
        hideButton.Text = "Show Dice"
        for _, child in ipairs(contentContainer:GetChildren()) do
            child.Visible = false
        end
    else
        mainFrame.Size = UDim2.new(0, 310, 0, 375)
        hideButton.Text = "Skin Face Dice"
        for _, child in ipairs(contentContainer:GetChildren()) do
            child.Visible = true
        end
    end
end)
-- =================================================

-- Dice Container (Horizontal layout for the 4 advanced compact dice)
local diceContainer = Instance.new("Frame")
diceContainer.Size = UDim2.new(1, -24, 0, 55)
diceContainer.Position = UDim2.new(0, 12, 0, 32)
diceContainer.BackgroundTransparency = 1
diceContainer.Parent = contentContainer

local uiLayout = Instance.new("UIListLayout")
uiLayout.FillDirection = Enum.FillDirection.Horizontal
uiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0, 6)
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

-- Create the 4 Advanced Styled Dice Elements
local diceFrames = {}
for i = 1, 4 do
    local dice = Instance.new("Frame")
    dice.Size = UDim2.new(0, 66, 0, 55)
    dice.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dice.BorderSizePixel = 0
    dice.Parent = diceContainer
    
    local diceCorner = Instance.new("UICorner")
    diceCorner.CornerRadius = UDim.new(0, 8)
    diceCorner.Parent = dice
    
    local diceStroke = Instance.new("UIStroke")
    diceStroke.Color = Color3.fromRGB(255, 255, 255)
    diceStroke.Transparency = 0.5
    diceStroke.Thickness = 1.5
    diceStroke.Parent = dice
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = "Die " .. i
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
    label.TextStrokeTransparency = 0.3
    label.Parent = dice
    
    table.insert(diceFrames, {Frame = dice, Label = label})
end

-- Combined Profit Display Panel
local trackerFrame = Instance.new("Frame")
trackerFrame.Size = UDim2.new(1, -24, 0, 30)
trackerFrame.Position = UDim2.new(0, 12, 0, 93)
trackerFrame.BackgroundColor3 = themes[1].Panel
trackerFrame.BorderSizePixel = 0
trackerFrame.Parent = contentContainer
table.insert(themeUpdateTargets, trackerFrame)

local trackerCorner = Instance.new("UICorner")
trackerCorner.CornerRadius = UDim.new(0, 6)
trackerCorner.Parent = trackerFrame

local profitTitleLabel = Instance.new("TextLabel")
profitTitleLabel.Size = UDim2.new(0.4, 0, 1, 0)
profitTitleLabel.Position = UDim2.new(0, 10, 0, 0)
profitTitleLabel.BackgroundTransparency = 1
profitTitleLabel.Font = Enum.Font.GothamBold
profitTitleLabel.Text = "PROFIT:"
profitTitleLabel.TextColor3 = Color3.fromRGB(180, 180, 195)
profitTitleLabel.TextSize = 11
profitTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
profitTitleLabel.Parent = trackerFrame

local profitValueLabel = Instance.new("TextLabel")
profitValueLabel.Size = UDim2.new(0.6, -10, 1, 0)
profitValueLabel.Position = UDim2.new(0.4, 0, 0, 0)
profitValueLabel.BackgroundTransparency = 1
profitValueLabel.Font = Enum.Font.GothamBold
profitValueLabel.Text = "0"
profitValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
profitValueLabel.TextSize = 12
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
        profitValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- =================================================
-- RECENT ROLLS HISTORY LOG (#1 at top, up to #10 at bottom)
-- =================================================
local historyFrame = Instance.new("Frame")
historyFrame.Size = UDim2.new(1, -24, 0, 120)
historyFrame.Position = UDim2.new(0, 12, 0, 128)
historyFrame.BackgroundColor3 = themes[1].Panel
historyFrame.BorderSizePixel = 0
historyFrame.Parent = contentContainer
table.insert(themeUpdateTargets, historyFrame)

local historyCorner = Instance.new("UICorner")
historyCorner.CornerRadius = UDim.new(0, 6)
historyCorner.Parent = historyFrame

local historyTitle = Instance.new("TextLabel")
historyTitle.Size = UDim2.new(1, 0, 0, 18)
historyTitle.Position = UDim2.new(0, 8, 0, 2)
historyTitle.BackgroundTransparency = 1
historyTitle.Font = Enum.Font.GothamBold
historyTitle.Text = "Recent Rolls (#1 to #10):"
historyTitle.TextColor3 = Color3.fromRGB(150, 150, 165)
historyTitle.TextSize = 10
historyTitle.TextXAlignment = Enum.TextXAlignment.Left
historyTitle.Parent = historyFrame

local historyScroll = Instance.new("ScrollingFrame")
historyScroll.Size = UDim2.new(1, -10, 1, -20)
historyScroll.Position = UDim2.new(0, 5, 0, 18)
historyScroll.BackgroundTransparency = 1
historyScroll.BorderSizePixel = 0
historyScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
historyScroll.ScrollBarThickness = 3
historyScroll.Parent = historyFrame

local historyLayout = Instance.new("UIListLayout")
historyLayout.FillDirection = Enum.FillDirection.Vertical
historyLayout.SortOrder = Enum.SortOrder.LayoutOrder
historyLayout.Padding = UDim.new(0, 4)
historyLayout.Parent = historyScroll

local recentRollsData = {}

local function updateHistoryDisplay()
    for _, child in ipairs(historyScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    for index, rollColors in ipairs(recentRollsData) do
        local rowContainer = Instance.new("Frame")
        rowContainer.Size = UDim2.new(1, 0, 0, 15)
        rowContainer.BackgroundTransparency = 1
        rowContainer.Parent = historyScroll
        
        local numLabel = Instance.new("TextLabel")
        numLabel.Size = UDim2.new(0, 24, 1, 0)
        numLabel.BackgroundTransparency = 1
        numLabel.Font = Enum.Font.GothamBold
        numLabel.Text = "#" .. index
        numLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
        numLabel.TextSize = 10
        numLabel.TextXAlignment = Enum.TextXAlignment.Left
        numLabel.Parent = rowContainer
        
        local boxesContainer = Instance.new("Frame")
        boxesContainer.Size = UDim2.new(1, -28, 1, 0)
        boxesContainer.Position = UDim2.new(0, 24, 0, 0)
        boxesContainer.BackgroundTransparency = 1
        boxesContainer.Parent = rowContainer
        
        local rowLayout = Instance.new("UIListLayout")
        rowLayout.FillDirection = Enum.FillDirection.Horizontal
        rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
        rowLayout.Padding = UDim.new(0, 4)
        rowLayout.Parent = boxesContainer
        
        for _, col3 in ipairs(rollColors) do
            local colorBox = Instance.new("Frame")
            colorBox.Size = UDim2.new(0, 47, 0, 15)
            colorBox.BackgroundColor3 = col3
            colorBox.BorderSizePixel = 0
            colorBox.Parent = boxesContainer
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 3)
            boxCorner.Parent = colorBox
        end
    end
    historyScroll.CanvasSize = UDim2.new(0, 0, 0, #recentRollsData * 19)
end
-- =================================================

-- Plus (+) and Minus (-) Profit Buttons
local plusButton = Instance.new("TextButton")
plusButton.Size = UDim2.new(0, 36, 0, 34)
plusButton.Position = UDim2.new(0, 12, 0, 256)
plusButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
plusButton.Font = Enum.Font.GothamBold
plusButton.Text = "+"
plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
plusButton.TextSize = 18
plusButton.Parent = contentContainer

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 6)
plusCorner.Parent = plusButton

plusButton.MouseButton1Click:Connect(function()
    currentProfit = currentProfit + 1
    updateProfitDisplay()
end)

local minusButton = Instance.new("TextButton")
minusButton.Size = UDim2.new(0, 36, 0, 34)
minusButton.Position = UDim2.new(0, 52, 0, 256)
minusButton.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
minusButton.Font = Enum.Font.GothamBold
minusButton.Text = "-"
minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minusButton.TextSize = 18
minusButton.Parent = contentContainer

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 6)
minusCorner.Parent = minusButton

minusButton.MouseButton1Click:Connect(function()
    currentProfit = currentProfit - 1
    updateProfitDisplay()
end)

-- Spin Button
local spinButton = Instance.new("TextButton")
spinButton.Size = UDim2.new(1, -100, 0, 34)
spinButton.Position = UDim2.new(0, 92, 0, 256)
spinButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
spinButton.Font = Enum.Font.GothamBold
spinButton.Text = "SPIN DICE"
spinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spinButton.TextSize = 13
spinButton.Parent = contentContainer

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = spinButton

-- Lag-Free Fair Spin Animation Logic
local isSpinning = false
local function spinDice()
    if isSpinning then return end
    isSpinning = true
    spinButton.Text = "SPINNING..."
    
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
            for _, diceData in ipairs(diceFrames) do
                local randomColorData = colorList[math.random(1, #colorList)]
                diceData.Frame.BackgroundColor3 = randomColorData.Color
                diceData.Label.Text = randomColorData.Name
            end
        end
    end
    
    -- Final Completely Fair Results
    local rollColorSet = {}
    for _, diceData in ipairs(diceFrames) do
        local finalColorData = colorList[math.random(1, #colorList)]
        
        diceData.Frame.BackgroundColor3 = finalColorData.Color
        diceData.Label.Text = finalColorData.Name
        table.insert(rollColorSet, finalColorData.Color)
    end
    
    -- Save visual color set to recent history (Newest #1 at top, max 10)
    table.insert(recentRollsData, 1, rollColorSet)
    if #recentRollsData > 10 then
        table.remove(recentRollsData, 11)
    end
    updateHistoryDisplay()
    
    spinButton.Text = "SPIN DICE"
    isSpinning = false
end

spinButton.MouseButton1Click:Connect(spinDice)

-- Footer minimal info
local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, 0, 0, 18)
footerLabel.Position = UDim2.new(0, 0, 1, -20)
footerLabel.BackgroundTransparency = 1
footerLabel.Font = Enum.Font.Gotham
footerLabel.Text = "Drag header to move"
footerLabel.TextColor3 = Color3.fromRGB(110, 110, 125)
footerLabel.TextSize = 9
footerLabel.Parent = contentContainer

-- Initial spin on execution
spinDice()