local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- // THEME (SAKURA BLOSSOM STYLE)
local BG         = Color3.fromRGB(25, 10, 15)       
local BORDER     = Color3.fromRGB(255, 183, 197)   
local BORDER2    = Color3.fromRGB(255, 105, 180)   
local WHITE      = Color3.fromRGB(255, 255, 255)   
local BLACK      = Color3.fromRGB(0, 0, 0)

-- // STATE
local State = {
    ShieldActive = false,
    DesyncActive = false,
    isUiLocked = false,
    isMinimized = false,
    isHelpOpen = false
}

-- // CLEANUP OLD GUI
local guiName = "LeakSlivAntiDesyncBypassGUI"
pcall(function()
    local old = game:GetService("CoreGui"):FindFirstChild(guiName)
    if old then old:Destroy() end
end)
pcall(function()
    local old2 = LP:WaitForChild("PlayerGui"):FindFirstChild(guiName)
    if old2 then old2:Destroy() end
end)

-- // GUI SETUP 
local gui = Instance.new("ScreenGui")
gui.Name = guiName
gui.ResetOnSpawn = false 
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true 

local parented = false
pcall(function()
    gui.Parent = gethui()
    parented = true
end)
if not parented then
    pcall(function()
        gui.Parent = game:GetService("CoreGui")
        parented = true
    end)
end
if not parented then
    gui.Parent = LP:WaitForChild("PlayerGui")
end

-- Main Frame
local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, 210, 0, 195) -- Adjusted base height for the new button
main.Position = UDim2.new(0.5, -105, 0.5, -80)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = BORDER
mainStroke.Thickness = 1

-- Background Image 
local bgImage = Instance.new("ImageLabel", main)
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxthumb://type=Asset&id=11696859442&w=420&h=420"
bgImage.ImageTransparency = 0.2
bgImage.ScaleType = Enum.ScaleType.Crop 
bgImage.ZIndex = 1 
Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 10) 

-- Dragging Logic
local dragging, dragInput, dragStart, mainStart = false, nil, nil, nil
main.InputBegan:Connect(function(inp)
    if State.isUiLocked then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inp.Position
        mainStart = main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
main.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end
end)
UIS.InputChanged:Connect(function(inp)
    if inp == dragInput and dragging then
        local dx = inp.Position.X - dragStart.X
        local dy = inp.Position.Y - dragStart.Y
        main.Position = UDim2.new(mainStart.X.Scale, mainStart.X.Offset+dx, mainStart.Y.Scale, mainStart.Y.Offset+dy)
    end
end)

-- // HEADER
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundTransparency = 1 
header.BorderSizePixel = 0
header.ZIndex = 5
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(1, -30, 1, 0)
titleLbl.Position = UDim2.new(0, 0, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "ANTI DESYNC BYPASS"
titleLbl.TextColor3 = BORDER
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 10
titleLbl.TextXAlignment = Enum.TextXAlignment.Center 
titleLbl.ZIndex = 6

-- // MINIMIZE BUTTON
local minimizeBtn = Instance.new("TextButton", main)
minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
minimizeBtn.Position = UDim2.new(1, -26, 0, 7)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = WHITE
minimizeBtn.Font = Enum.Font.GothamBlack
minimizeBtn.TextSize = 14
minimizeBtn.ZIndex = 10
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 5)

-- // CONTENT AREA
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -16, 1, -45)
content.Position = UDim2.new(0, 8, 0, 40)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ZIndex = 2

-- // DISCORD LINK
local discordBubble = Instance.new("Frame", content)
discordBubble.Size = UDim2.new(1, -8, 0, 22)
discordBubble.Position = UDim2.new(0, 4, 0, 0)
discordBubble.BackgroundColor3 = BLACK 
discordBubble.BackgroundTransparency = 0.5 
discordBubble.BorderSizePixel = 0
discordBubble.ZIndex = 3

Instance.new("UICorner", discordBubble).CornerRadius = UDim.new(0, 4)
local discordStroke = Instance.new("UIStroke", discordBubble)
discordStroke.Color = BORDER2
discordStroke.Thickness = 1

local discordTxt = Instance.new("TextLabel", discordBubble)
discordTxt.Size = UDim2.new(1, 0, 1, 0)
discordTxt.BackgroundTransparency = 1
discordTxt.Text = "https://discord.gg/9evN5GwFZr"
discordTxt.TextColor3 = WHITE 
discordTxt.Font = Enum.Font.GothamBold
discordTxt.TextSize = 11 
discordTxt.ZIndex = 4

-- // SHIELD TOGGLE ROW
local shieldRow = Instance.new("Frame", content)
shieldRow.Size = UDim2.new(1, 0, 0, 26)
shieldRow.Position = UDim2.new(0, 0, 0, 28)
shieldRow.BackgroundTransparency = 1 
shieldRow.BorderSizePixel = 0
shieldRow.ZIndex = 3

local shieldBtn = Instance.new("TextButton", shieldRow)
shieldBtn.Size = UDim2.new(1, -8, 1, -4)
shieldBtn.Position = UDim2.new(0, 4, 0, 2)
shieldBtn.BackgroundColor3 = WHITE 
shieldBtn.BackgroundTransparency = 0.5 
shieldBtn.BorderSizePixel = 0
shieldBtn.Text = "ANTI DESYNC: OFF"
shieldBtn.TextColor3 = BLACK
shieldBtn.Font = Enum.Font.GothamBold
shieldBtn.TextSize = 10
shieldBtn.ZIndex = 12
Instance.new("UICorner", shieldBtn).CornerRadius = UDim.new(0, 4)
local shieldBtnStroke = Instance.new("UIStroke", shieldBtn)
shieldBtnStroke.Color = BORDER2
shieldBtnStroke.Thickness = 1

shieldBtn.MouseButton1Click:Connect(function()
    State.ShieldActive = not State.ShieldActive
    shieldBtn.Text = State.ShieldActive and "ANTI DESYNC: ON" or "ANTI DESYNC: OFF"
    TweenService:Create(shieldBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = State.ShieldActive and BORDER2 or WHITE
    }):Play()
    shieldBtn.TextColor3 = State.ShieldActive and WHITE or BLACK
end)

-- // DESYNC TOGGLE ROW
local desyncRow = Instance.new("Frame", content)
desyncRow.Size = UDim2.new(1, 0, 0, 26)
desyncRow.Position = UDim2.new(0, 0, 0, 59)
desyncRow.BackgroundTransparency = 1 
desyncRow.BorderSizePixel = 0
desyncRow.ZIndex = 3

local desyncBtn = Instance.new("TextButton", desyncRow)
desyncBtn.Size = UDim2.new(1, -8, 1, -4)
desyncBtn.Position = UDim2.new(0, 4, 0, 2)
desyncBtn.BackgroundColor3 = WHITE 
desyncBtn.BackgroundTransparency = 0.5 
desyncBtn.BorderSizePixel = 0
desyncBtn.Text = "VELOCITY DESYNC: OFF"
desyncBtn.TextColor3 = BLACK
desyncBtn.Font = Enum.Font.GothamBold
desyncBtn.TextSize = 10
desyncBtn.ZIndex = 12
Instance.new("UICorner", desyncBtn).CornerRadius = UDim.new(0, 4)
local desyncBtnStroke = Instance.new("UIStroke", desyncBtn)
desyncBtnStroke.Color = BORDER2
desyncBtnStroke.Thickness = 1

desyncBtn.MouseButton1Click:Connect(function()
    State.DesyncActive = not State.DesyncActive
    desyncBtn.Text = State.DesyncActive and "VELOCITY DESYNC: ON" or "VELOCITY DESYNC: OFF"
    TweenService:Create(desyncBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = State.DesyncActive and BORDER2 or WHITE
    }):Play()
    desyncBtn.TextColor3 = State.DesyncActive and WHITE or BLACK
end)

-- // HELP BUTTON ROW
local helpRow = Instance.new("Frame", content)
helpRow.Size = UDim2.new(1, 0, 0, 26)
helpRow.Position = UDim2.new(0, 0, 0, 90)
helpRow.BackgroundTransparency = 1 
helpRow.BorderSizePixel = 0
helpRow.ZIndex = 3

local helpBtn = Instance.new("TextButton", helpRow)
helpBtn.Size = UDim2.new(1, -8, 1, -4)
helpBtn.Position = UDim2.new(0, 4, 0, 2)
helpBtn.BackgroundColor3 = WHITE 
helpBtn.BackgroundTransparency = 0.5 
helpBtn.BorderSizePixel = 0
helpBtn.Text = "Need Help >"
helpBtn.TextColor3 = BLACK
helpBtn.Font = Enum.Font.GothamBold
helpBtn.TextSize = 10
helpBtn.ZIndex = 12
Instance.new("UICorner", helpBtn).CornerRadius = UDim.new(0, 4)
local helpBtnStroke = Instance.new("UIStroke", helpBtn)
helpBtnStroke.Color = BORDER2
helpBtnStroke.Thickness = 1

-- // LOCK UI BUTTON
local lockRow = Instance.new("Frame", content)
lockRow.Size = UDim2.new(1, 0, 0, 20)
lockRow.Position = UDim2.new(0, 0, 0, 121)
lockRow.BackgroundTransparency = 1
lockRow.ZIndex = 3

local lockBtn = Instance.new("TextButton", lockRow)
lockBtn.Size = UDim2.new(1, -8, 1, 0)
lockBtn.Position = UDim2.new(0, 4, 0, 0)
lockBtn.BackgroundColor3 = WHITE
lockBtn.BackgroundTransparency = 0.5
lockBtn.BorderSizePixel = 0
lockBtn.Text = "Lock UI Dragging"
lockBtn.TextColor3 = BLACK
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 9
lockBtn.ZIndex = 12
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 4)

lockBtn.MouseButton1Click:Connect(function()
    State.isUiLocked = not State.isUiLocked
    lockBtn.Text = State.isUiLocked and "Unlock UI" or "Lock UI Dragging"
    lockBtn.TextColor3 = State.isUiLocked and BORDER2 or BLACK
end)

-- // HELP TEXT AREA (Hidden by default)
local helpTextFrame = Instance.new("Frame", content)
helpTextFrame.Size = UDim2.new(1, -8, 0, 85)
helpTextFrame.Position = UDim2.new(0, 4, 0, 147)
helpTextFrame.BackgroundColor3 = BLACK
helpTextFrame.BackgroundTransparency = 0.5
helpTextFrame.BorderSizePixel = 0
helpTextFrame.Visible = false
helpTextFrame.ZIndex = 3
Instance.new("UICorner", helpTextFrame).CornerRadius = UDim.new(0, 4)
local helpTextStroke = Instance.new("UIStroke", helpTextFrame)
helpTextStroke.Color = BORDER2
helpTextStroke.Thickness = 1

local helpTextLbl = Instance.new("TextLabel", helpTextFrame)
helpTextLbl.Size = UDim2.new(1, -8, 1, -8)
helpTextLbl.Position = UDim2.new(0, 4, 0, 4)
helpTextLbl.BackgroundTransparency = 1
helpTextLbl.Text = "🛡️ SHIELD: Rapidly orbits you out of the way to dodge bat hits.\n\n💨 DESYNC: Spoofs your velocity to break tracking physics.\n\n🔒 LOCK: Freezes the menu so it can't be dragged."
helpTextLbl.TextColor3 = WHITE
helpTextLbl.Font = Enum.Font.GothamMedium
helpTextLbl.TextSize = 9
helpTextLbl.TextXAlignment = Enum.TextXAlignment.Left
helpTextLbl.TextYAlignment = Enum.TextYAlignment.Top
helpTextLbl.TextWrapped = true
helpTextLbl.ZIndex = 4

-- // HELP BUTTON LOGIC
helpBtn.MouseButton1Click:Connect(function()
    if State.isMinimized then return end
    State.isHelpOpen = not State.isHelpOpen
    helpBtn.Text = State.isHelpOpen and "Need Help v" or "Need Help >"
    
    if State.isHelpOpen then
        helpTextFrame.Visible = true
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 210, 0, 285)}):Play()
    else
        helpTextFrame.Visible = false
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 210, 0, 195)}):Play()
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    State.isMinimized = not State.isMinimized
    
    if State.isMinimized then
        content.Visible = false
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 210, 0, 35)}):Play()
    else
        local targetHeight = State.isHelpOpen and 285 or 195
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 210, 0, targetHeight)}):Play()
        task.wait(0.15)
        content.Visible = true
    end
end)

local function getChar()
    return LP.Character or LP.CharacterAdded:Wait()
end

RunService.Heartbeat:Connect(function()
    if not (State.ShieldActive or State.DesyncActive) then return end
    
    local char = getChar()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    
    -- 1. Velocity Desync 
    if State.DesyncActive then
        local oldVelocity = hrp.Velocity
        hrp.Velocity = Vector3.new(999, 0, 999) 
        RunService.RenderStepped:Wait()
        hrp.Velocity = oldVelocity
    end
    
    -- 2. Radius Anti-Bat Shield 
    if State.ShieldActive then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local enemyHrp = player.Character:FindFirstChild("HumanoidRootPart")
                local enemyTool = player.Character:FindFirstChildWhichIsA("Tool")
                
                if enemyHrp then
                    local distance = (hrp.Position - enemyHrp.Position).Magnitude
                    
                    if distance < 8 and enemyTool and enemyTool.Name == "Bat" then
                        local angle = math.rad(tick() * 500)
                        hrp.CFrame = hrp.CFrame * CFrame.new(math.sin(angle) * 3, 0, math.cos(angle) * 3)
                    end
                end
            end
        end
    end
end)