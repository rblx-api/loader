local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Colors
local RED = Color3.fromRGB(255, 0, 0) 
local DARK_RED = Color3.fromRGB(180, 0, 0)
local BLACK = Color3.fromRGB(0, 0, 0)    
local WHITE = Color3.fromRGB(255, 255, 255)

---------------------------------------------------------
-- 1. Billboard GUI (Above head text)
---------------------------------------------------------
local function createBillboard()
    if LocalPlayer.Character then
        local head = LocalPlayer.Character:FindFirstChild("Head")
        if head then
            local oldBillboard = head:FindFirstChild("BrayBillboard")
            if oldBillboard then oldBillboard:Destroy() end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "BrayBillboard"
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3.0, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = head

            local linkLabel = Instance.new("TextLabel")
            linkLabel.Size = UDim2.new(1, 0, 1, 0)
            linkLabel.BackgroundTransparency = 1
            linkLabel.Text = "Made by BRAY"
            linkLabel.TextColor3 = RED
            linkLabel.Font = Enum.Font.GothamBold
            linkLabel.TextSize = 18
            linkLabel.Parent = billboard
        end
    end
end

LocalPlayer.CharacterAdded:Connect(createBillboard)
if LocalPlayer.Character then createBillboard() end

---------------------------------------------------------
-- 2. Main Screen GUI (Compact Custom Native UI with Image)
---------------------------------------------------------
local existing = PlayerGui:FindFirstChild("BrayAntiLagGUI")
if existing then existing:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrayAntiLagGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 75)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = RED
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Blossom Pink Outline
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = DARK_RED
mainStroke.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 28)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "BRAY ANTI LAG"
title.TextColor3 = WHITE
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 2
title.Parent = mainFrame

-- Minimize Button 
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 26, 0, 20)
minimizeBtn.Position = UDim2.new(1, -32, 0, 4)
minimizeBtn.BackgroundColor3 = DARK_RED
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = WHITE
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.ZIndex = 2
minimizeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = minimizeBtn

local minimizeStroke = Instance.new("UIStroke")
minimizeStroke.Thickness = 1
minimizeStroke.Color = DARK_RED
minimizeStroke.Parent = minimizeBtn

-- Main Toggle Button (Pink & See-through)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 125, 0, 32)
toggleBtn.Position = UDim2.new(0, 10, 0, 34)
toggleBtn.BackgroundColor3 = RED
toggleBtn.BackgroundTransparency = 0.5 
toggleBtn.Text = "ANTI LAG OFF"
toggleBtn.TextColor3 = WHITE
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.ZIndex = 2
toggleBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Thickness = 2
btnStroke.Color = DARK_RED
btnStroke.Parent = toggleBtn

-- Lock Button (Beside the feature, no emojis)
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0, 45, 0, 32)
lockBtn.Position = UDim2.new(0, 145, 0, 34)
lockBtn.BackgroundColor3 = RED
lockBtn.BackgroundTransparency = 0.5 
lockBtn.Text = "Lock"
lockBtn.TextColor3 = WHITE
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 12
lockBtn.ZIndex = 2
lockBtn.Parent = mainFrame

local lockCorner = Instance.new("UICorner")
lockCorner.CornerRadius = UDim.new(0, 8)
lockCorner.Parent = lockBtn

local lockStroke = Instance.new("UIStroke")
lockStroke.Thickness = 2
lockStroke.Color = DARK_RED
lockStroke.Parent = lockBtn

---------------------------------------------------------
-- 3. Flashing Animation (White & Grey)
---------------------------------------------------------
local flashTime = 0
local greyFlash = Color3.fromRGB(160, 160, 160)

RunService.RenderStepped:Connect(function(dt)
    flashTime = flashTime + dt * 3 
    local alpha = 0.5 + 0.5 * math.sin(flashTime)
    local currentColor = WHITE:Lerp(greyFlash, alpha)

    title.TextColor3 = currentColor
    toggleBtn.TextColor3 = currentColor
end)

---------------------------------------------------------
-- 4. Logic (Minimize, Lock & Anti-Lag Toggle)
---------------------------------------------------------
local isMinimized = false
local defaultSize = UDim2.new(0, 200, 0, 75)
local minSize = UDim2.new(0, 200, 0, 30)

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        mainFrame.Size = minSize
        toggleBtn.Visible = false
        lockBtn.Visible = false
        minimizeBtn.Text = "+"
    else
        mainFrame.Size = defaultSize
        toggleBtn.Visible = true
        lockBtn.Visible = true
        minimizeBtn.Text = "-"
    end
end)

-- Functional Lock Button Logic
local isLocked = false
lockBtn.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    if isLocked then
        lockBtn.Text = "Locked"
        mainFrame.Draggable = false -- This freezes the menu in place
    else
        lockBtn.Text = "Lock"
        mainFrame.Draggable = true -- This lets you move it again
    end
end)

-- Anti Lag Logic
local isEnabled = false
local connection = nil

local function applyAntiLag()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA('BloomEffect') or child:IsA('BlurEffect') or child:IsA('SunRaysEffect') then
            child.Enabled = false
        end
    end

    for _, descendant in pairs(Workspace:GetDescendants()) do
        if descendant:IsA('ParticleEmitter') then
            descendant.Enabled = false
        elseif descendant:IsA('Decal') then
            descendant.Transparency = 1
        elseif descendant:IsA('BasePart') then
            descendant.Material = Enum.Material.Plastic
            descendant.Reflectance = 0
            descendant.CastShadow = false
        end
        if descendant:IsA('Accessory') then
            descendant:Destroy()
        end
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    
    if isEnabled then
        toggleBtn.Text = "ANTI LAG ON"
        applyAntiLag()
        
        if connection then connection:Disconnect() end
        connection = Workspace.DescendantAdded:Connect(function(descendant)
            if descendant:IsA('ParticleEmitter') then
                descendant.Enabled = false
            elseif descendant:IsA('Decal') then
                descendant.Transparency = 1
            elseif descendant:IsA('BasePart') then
                descendant.Material = Enum.Material.Plastic
                descendant.Reflectance = 0
                descendant.CastShadow = false
            end
            if descendant:IsA('Accessory') then
                descendant:Destroy()
            end
        end)
    else
        toggleBtn.Text = "ANTI LAG OFF"
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)

print("✅ BRAY ANTI LAG loaded!")