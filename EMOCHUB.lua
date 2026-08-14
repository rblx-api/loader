-- cxyro dumper: https://discord.gg/WW8Qm77dhF

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TokinuHubGalaxy"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 270)
MainFrame.Position = UDim2.new(0, 40, 0, 60)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(180, 180, 200)
UIStroke.Transparency = 0.7
UIStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 28)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Tokinu Hub"
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(220, 220, 240)
Title.Parent = MainFrame

-- Footer / Discord invite
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, -20, 0, 16)
Footer.Position = UDim2.new(0, 10, 1, -22)
Footer.BackgroundTransparency = 1
Footer.Text = "discord.gg/tokinu"
Footer.TextColor3 = Color3.fromRGB(180, 180, 200)
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 11
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.Parent = MainFrame

-- Settings values
local Settings = {
    Speed = 27,
    JumpPower = 50
}

-- Create toggle buttons
local function CreateToggleButton(name, yOffset, defaultText)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 32)
    button.Position = UDim2.new(0, 10, 0, yOffset)
    button.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
    button.BackgroundTransparency = 0.5
    button.Text = defaultText or (name .. ": OFF")
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(240, 240, 255)
    button.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(200, 200, 220)
    stroke.Transparency = 0.6
    stroke.Parent = button

    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.4
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.5
        }):Play()
    end)

    return button
end

-- Speed & Jump settings panel
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(1, -20, 0, 65)
SettingsFrame.Position = UDim2.new(0, 10, 0, 154)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SettingsFrame.BackgroundTransparency = 0.3
SettingsFrame.Parent = MainFrame

local corner5 = Instance.new("UICorner")
corner5.CornerRadius = UDim.new(0, 8)
corner5.Parent = SettingsFrame

local stroke5 = Instance.new("UIStroke")
stroke5.Thickness = 1
stroke5.Color = Color3.fromRGB(180, 180, 200)
stroke5.Transparency = 0.7
stroke5.Parent = SettingsFrame

local function CreateSettingRow(labelText, defaultValue, yOffset)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -5, 0, 22)
    label.Position = UDim2.new(0, 5, 0, yOffset)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = SettingsFrame

    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(0.5, -10, 0, 22)
    textbox.Position = UDim2.new(0.5, 0, 0, yOffset)
    textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    textbox.BackgroundTransparency = 0.4
    textbox.Text = tostring(defaultValue)
    textbox.TextColor3 = Color3.fromRGB(240, 240, 255)
    textbox.Font = Enum.Font.Gotham
    textbox.TextSize = 12
    textbox.PlaceholderText = labelText
    textbox.PlaceholderColor3 = Color3.fromRGB(180, 180, 200)
    textbox.Parent = SettingsFrame

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 5)
    tbCorner.Parent = textbox

    return textbox
end

local speedBox = CreateSettingRow("Speed:", 27, 5)
local jumpBox = CreateSettingRow("Jump:", 50, 32)

-- Toggles
local DesyncButton = CreateToggleButton("Desync", 40, "Desync: OFF")
local SpeedButton  = CreateToggleButton("Speed",  78, "Speed: ON")
local UnwalkButton = CreateToggleButton("Unwalk", 116, "Unwalk: OFF")

-- Desync ESP folder
local DesyncESPFolder = Instance.new("Folder")
DesyncESPFolder.Name = "DesyncESP"
DesyncESPFolder.Parent = workspace

-- Simple visual feedback when toggle is ON
local function SetButtonOn(btn)
    btn.Text = btn.Text:gsub("OFF", "ON")
    TweenService:Create(btn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(80, 150, 80),
        BackgroundTransparency = 0.3
    }):Play()
end

-- ==================
--    DESYNC TOGGLE
-- ==================
DesyncButton.MouseButton1Click:Connect(function()
    SetButtonOn(DesyncButton)

    local char = LocalPlayer.Character
    if not char then return end

    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
    end

    task.wait(0.2)

    -- Some network flags (most likely won't work anymore in 2025/2026)
    pcall(function()
        setfflag("PhysicsSenderMaxBandwidthBps", "20000")
        setfflag("LargeReplicatorEnabled9", "true")
        setfflag("LargeReplicatorWrite5", "true")
        -- ... other flags
    end)

    DesyncESPFolder:ClearAllChildren()

    local serverPosPart = Instance.new("Part")
    serverPosPart.Name = "Server Position"
    serverPosPart.Size = Vector3.new(2, 5, 2)
    serverPosPart.Anchored = true
    serverPosPart.CanCollide = false
    serverPosPart.Material = Enum.Material.Neon
    serverPosPart.Color = Color3.fromRGB(255, 100, 100)
    serverPosPart.Transparency = 0.3
    serverPosPart.Parent = DesyncESPFolder

    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(255, 100, 100)
    hl.OutlineColor = Color3.fromRGB(255, 100, 100)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Parent = serverPosPart

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.Adornee = serverPosPart
    billboard.AlwaysOnTop = true
    billboard.Parent = serverPosPart

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = "Server Position"
    label.TextColor3 = Color3.fromRGB(255, 100, 100)
    label.TextStrokeTransparency = 0.5
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then
        serverPosPart.CFrame = CFrame.new(hrp.Position)

        -- Update every ~0.15s when position changes
        hrp:GetPropertyChangedSignal("Position"):Connect(function()
            task.wait(0.15)
            if char.Parent then
                local newHrp = char:FindFirstChild("HumanoidRootPart")
                if newHrp then
                    serverPosPart.CFrame = CFrame.new(newHrp.Position)
                end
            end
        end)
    end
end)

-- ==================
--    SPEED TOGGLE
-- ==================
SpeedButton.MouseButton1Click:Connect(function()
    SetButtonOn(SpeedButton)
    -- Actual speed implementation missing in original code
end)

-- ==================
--    UNWALK TOGGLE
-- ==================
UnwalkButton.MouseButton1Click:Connect(function()
    SetButtonOn(UnwalkButton)

    local char = LocalPlayer.Character
    if not char then return end

    task.spawn(function()
        local animate = char:FindFirstChild("Animate")
        if not animate then return end

        -- Remove default walk & run animations
        local walk = animate:FindFirstChild("walk")
        if walk then
            local anim = walk:FindFirstChild("WalkAnim")
            if anim and anim:IsA("Animation") then
                anim.AnimationId = ""
            end
        end

        local run = animate:FindFirstChild("run")
        if run then
            local anim = run:FindFirstChild("RunAnim")
            if anim and anim:IsA("Animation") then
                anim.AnimationId = ""
            end
        end

        -- Stop any currently playing walk/run animations
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Name:lower():find("walk") then
                    track:Stop()
                end
            end
        end

        -- Block new walk animations
        animate.DescendantAdded:Connect(function(desc)
            if desc:IsA("Animation") and desc.Name:lower():find("walk") then
                desc.AnimationId = ""
            end
        end)
    end)
end)

-- Basic input validation for speed/jump values
speedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(speedBox.Text)
        if num and num > 0 then
            Settings.Speed = num
        else
            speedBox.Text = "27"
        end
    end
end)

jumpBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(jumpBox.Text)
        if num and num > 0 then
            Settings.JumpPower = num
        else
            jumpBox.Text = "50"
        end
    end
end)

print("Tokinu Hub loaded")