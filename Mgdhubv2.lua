-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Existing UI Cleanup
if game.CoreGui:FindFirstChild("PornoHub_Script") then
    game.CoreGui.PornoHub_Script:Destroy()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PornoHub_Script"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

----------------------------------------------------
-- 1. INTRO SCREEN (PORNO HUB STYLE)
----------------------------------------------------
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
IntroFrame.BorderSizePixel = 0
IntroFrame.Parent = ScreenGui

local LogoContainer = Instance.new("Frame")
LogoContainer.Size = UDim2.new(0, 340, 0, 80)
LogoContainer.Position = UDim2.new(0.5, -170, 0.5, -40)
LogoContainer.BackgroundTransparency = 1
LogoContainer.Parent = IntroFrame

-- Text: "Porno"
local Text1 = Instance.new("TextLabel")
Text1.Size = UDim2.new(0.5, 0, 1, 0)
Text1.Position = UDim2.new(0, 0, 0, 0)
Text1.BackgroundTransparency = 1
Text1.Text = "Porno"
Text1.TextColor3 = Color3.fromRGB(255, 255, 255)
Text1.TextScaled = true
Text1.Font = Enum.Font.SourceSansBold
Text1.Parent = LogoContainer

-- Text: "Hub" (Orange Box)
local Text2Box = Instance.new("Frame")
Text2Box.Size = UDim2.new(0.45, 0, 0.8, 0)
Text2Box.Position = UDim2.new(0.52, 0, 0.1, 0)
Text2Box.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
Text2Box.BorderSizePixel = 0
Text2Box.Parent = LogoContainer

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = Text2Box

local Text2 = Instance.new("TextLabel")
Text2.Size = UDim2.new(1, 0, 1, 0)
Text2.BackgroundTransparency = 1
Text2.Text = "Hub"
Text2.TextColor3 = Color3.fromRGB(0, 0, 0)
Text2.TextScaled = true
Text2.Font = Enum.Font.SourceSansBold
Text2.Parent = Text2Box

-- Main UI Visibility State (Intro bittikten sonra açık olacak)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 360)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false -- Başlangıçta gizli, intro bitince açılacak
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 140, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Intro Fade Out & Main Menu Reveal Sequence
task.delay(2.2, function()
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local fadeTween = TweenService:Create(IntroFrame, tweenInfo, {BackgroundTransparency = 1})
    
    for _, child in pairs(LogoContainer:GetDescendants()) do
        if child:IsA("TextLabel") then
            TweenService:Create(child, tweenInfo, {TextTransparency = 1}):Play()
        elseif child:IsA("Frame") then
            TweenService:Create(child, tweenInfo, {BackgroundTransparency = 1}):Play()
        end
    end
    
    fadeTween:Play()
    fadeTween.Completed:Connect(function()
        IntroFrame:Destroy()
        MainFrame.Visible = true -- Intro tamamen silinince UI ekrana gelir
    end)
end)

----------------------------------------------------
-- 2. MAIN HUB WINDOW & COMPONENTS
----------------------------------------------------

-- Title Bar
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 40)
TitleLabel.Position = UDim2.new(0, 10, 0, 8)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "PORNO HUB - Mobile Menu"
TitleLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

----------------------------------------------------
-- 3. BUTTON CREATOR FUNCTION (KOLAYLIK İÇİN)
----------------------------------------------------
local function createButton(name, posY, text)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansSemibold
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    return btn
end

-- 1. Fix Walk Button
local FixWalkBtn = createButton("FixWalkBtn", 55, "🔓 Yürüme Kilit Çöz (Fix Walk)")
FixWalkBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.PlatformStand = false
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if PlayerGui then
                local TouchGui = PlayerGui:FindFirstChild("TouchGui")
                if TouchGui then
                    TouchGui.Enabled = false
                    task.wait(0.1)
                    TouchGui.Enabled = true
                end
            end
        end
    end
end)

-- 2. Infinity Jump Button
local infJumpEnabled = false
local InfJumpBtn = createButton("InfJumpBtn", 100, "🦘 Infinity Jump: KAPALI")
InfJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    InfJumpBtn.Text = "🦘 Infinity Jump: " .. (infJumpEnabled and "AÇIK" or "KAPALI")
    InfJumpBtn.TextColor3 = infJumpEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 3. Anti Ragdoll Button
local antiRagdollEnabled = false
local AntiRagdollBtn = createButton("AntiRagdollBtn", 145, "🛡️ Anti Ragdoll: KAPALI")
AntiRagdollBtn.MouseButton1Click:Connect(function()
    antiRagdollEnabled = not antiRagdollEnabled
    AntiRagdollBtn.Text = "🛡️ Anti Ragdoll: " .. (antiRagdollEnabled and "AÇIK" or "KAPALI")
    AntiRagdollBtn.TextColor3 = antiRagdollEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

RunService.Stepped:Connect(function()
    if antiRagdollEnabled and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end)

-- 4. NoClip Button
local noclipEnabled = false
local NoclipBtn = createButton("NoclipBtn", 190, "👻 NoClip (Duvar Geçme): KAPALI")
NoclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    NoclipBtn.Text = "👻 NoClip (Duvar Geçme): " .. (noclipEnabled and "AÇIK" or "KAPALI")
    NoclipBtn.TextColor3 = noclipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

----------------------------------------------------
-- 4. SPEED TEXTBOX SECTION
----------------------------------------------------
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.4, 0, 0, 38)
SpeedLabel.Position = UDim2.new(0.05, 0, 0, 235)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Hız Ayarla:"
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedLabel.TextSize = 15
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MainFrame

local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(0.47, 0, 0, 38)
SpeedInput.Position = UDim2.new(0.48, 0, 0, 235)
SpeedInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedInput.Text = "16"
SpeedInput.TextColor3 = Color3.fromRGB(255, 140, 0)
SpeedInput.TextSize = 16
SpeedInput.Font = Enum.Font.SourceSansBold
SpeedInput.PlaceholderText = "Hız yaz..."
SpeedInput.Parent = MainFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = SpeedInput

SpeedInput.FocusLost:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
    end
end)

-- Loop to lock speed
task.spawn(function()
    while task.wait(0.2) do
        local val = tonumber(SpeedInput.Text)
        if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
        end
    end
end)

----------------------------------------------------
-- 5. TOGGLE BUTTON (OPEN / CLOSE UI)
----------------------------------------------------
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "PH_Toggle"
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -24)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Text = "PH"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 24)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 140, 0)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleBtn

local uiVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    MainFrame.Visible = uiVisible
end)