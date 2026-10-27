-- maded and leaked by rzgr1ks at fpsl
-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- Eski GUI temizliği
if CoreGui:FindFirstChild("AmbitiousHubPvP") then
    CoreGui.AmbitiousHubPvP:Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AmbitiousHubPvP"
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

---------------------------------------------------------
-- AUTO STEAL İÇİN İLERLEME ÇUBUĞU
---------------------------------------------------------
local StealFrame = Instance.new("Frame")
StealFrame.Name = "StealProgressBar"
StealFrame.Size = UDim2.new(0, 180, 0, 30)
StealFrame.Position = UDim2.new(0.5, -90, 0.65, 0)
StealFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
StealFrame.BorderSizePixel = 0
StealFrame.Visible = false
StealFrame.Parent = ScreenGui

local StealCorner = Instance.new("UICorner")
StealCorner.CornerRadius = UDim.new(0, 6)
StealCorner.Parent = StealFrame

local StealStroke = Instance.new("UIStroke")
StealStroke.Color = Color3.fromRGB(250, 200, 20)
StealStroke.Thickness = 1.5
StealStroke.Parent = StealFrame

local StealFill = Instance.new("Frame")
StealFill.Size = UDim2.new(0, 0, 1, 0)
StealFill.BackgroundColor3 = Color3.fromRGB(250, 200, 20)
StealFill.BorderSizePixel = 0
StealFill.Parent = StealFrame

local StealFillCorner = Instance.new("UICorner")
StealFillCorner.CornerRadius = UDim.new(0, 6)
StealFillCorner.Parent = StealFill

local StealText = Instance.new("TextLabel")
StealText.Size = UDim2.new(1, 0, 1, 0)
StealText.BackgroundTransparency = 1
StealText.Text = "0%"
StealText.TextColor3 = Color3.fromRGB(255, 255, 255)
StealText.Font = Enum.Font.GothamBold
StealText.TextSize = 12
StealText.ZIndex = 2
StealText.Parent = StealFrame

---------------------------------------------------------
-- Main Frame
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 265) 
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -132)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local OuterStroke = Instance.new("UIStroke")
OuterStroke.Thickness = 1.5
OuterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
OuterStroke.Color = Color3.fromRGB(255, 255, 255)
OuterStroke.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 200, 20)),
    ColorSequenceKeypoint.new(0.04, Color3.fromRGB(250, 200, 20)),
    ColorSequenceKeypoint.new(0.05, Color3.fromRGB(12, 14, 18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 18))
})
UIGradient.Rotation = 0
UIGradient.Parent = OuterStroke

local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false)
local tween = TweenService:Create(UIGradient, tweenInfo, {Rotation = 360})
tween:Play()

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 18)
TitleLabel.Position = UDim2.new(0, 0, 0, 6)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Ambitious Hub  |  PvP"
TitleLabel.TextSize = 12
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.ZIndex = 2
TitleLabel.Parent = MainFrame

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Size = UDim2.new(1, 0, 0, 12)
SubtitleLabel.Position = UDim2.new(0, 0, 0, 22)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "https://discord.gg/ambitioushub"
SubtitleLabel.TextSize = 9
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.ZIndex = 2
SubtitleLabel.Parent = MainFrame

task.spawn(function()
    local hue = 0
    while task.wait() do
        hue = (hue + 0.006) % 1
        local rgbColor = Color3.fromHSV(hue, 0.75, 1)
        TitleLabel.TextColor3 = rgbColor
        SubtitleLabel.TextColor3 = rgbColor
    end
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.Position = UDim2.new(1, -22, 0, 6)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(235, 50, 50)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 2
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local LeftColumn = Instance.new("Frame")
LeftColumn.Size = UDim2.new(0, 146, 0, 230)
LeftColumn.Position = UDim2.new(0, 8, 0, 42)
LeftColumn.BackgroundTransparency = 1
LeftColumn.ZIndex = 2
LeftColumn.Parent = MainFrame
local LeftLayout = Instance.new("UIListLayout")
LeftLayout.Padding = UDim.new(0, 4)
LeftLayout.Parent = LeftColumn

local RightColumn = Instance.new("Frame")
RightColumn.Size = UDim2.new(0, 146, 0, 230)
RightColumn.Position = UDim2.new(1, -154, 0, 42)
RightColumn.BackgroundTransparency = 1
RightColumn.ZIndex = 2
RightColumn.Parent = MainFrame
local RightLayout = Instance.new("UIListLayout")
RightLayout.Padding = UDim.new(0, 4)
RightLayout.Parent = RightColumn

---------------------------------------------------------
-- 1. YENİLENEN BOOSTER (Speed Boost'un LinearVelocity & Hook Yöntemi)
---------------------------------------------------------
local BoosterEnabled = false
local BoostLinVel = nil
local BoostAtt = nil

local function ApplyBooster(enabled)
    BoosterEnabled = enabled
    if not enabled then
        if BoostLinVel then pcall(function() BoostLinVel:Destroy() end) BoostLinVel = nil end
        if BoostAtt then pcall(function() BoostAtt:Destroy() end) BoostAtt = nil end
    end
end

local function ensureBoostLinVel(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    if BoostLinVel and BoostLinVel.Parent == hrp then
        return BoostLinVel
    end

    if BoostLinVel then pcall(function() BoostLinVel:Destroy() end) end
    if BoostAtt then pcall(function() BoostAtt:Destroy() end) end

    BoostAtt = Instance.new("Attachment")
    BoostAtt.Name = "AmbitiousBoostAtt"
    BoostAtt.Parent = hrp

    BoostLinVel = Instance.new("LinearVelocity")
    BoostLinVel.Name = "AmbitiousBoostLinVel"
    BoostLinVel.Attachment0 = BoostAtt
    -- CS Speed X/Z için çalışırken bu sadece Y ekseni için çalışır (Çatışmazlar)
    BoostLinVel.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
    BoostLinVel.LineDirection = Vector3.new(0, 1, 0)
    BoostLinVel.RelativeTo = Enum.ActuatorRelativeTo.World
    BoostLinVel.MaxForce = 0 -- Yerdeyken müdahale etmez (merdiven çıkabilmek için)
    BoostLinVel.LineVelocity = 0
    BoostLinVel.Parent = hrp

    return BoostLinVel
end

-- CS Speed'de olan Metatable Hook mantığının aynısı Booster'a da eklendi
pcall(function()
    if not (getrawmetatable and setreadonly and newcclosure) then return end
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    local oldIndex = mt.__index
    mt.__index = newcclosure(function(self, key)
        if BoosterEnabled and (key == "AssemblyLinearVelocity" or key == "Velocity") then
            if typeof(self) == "Instance" and self:IsA("BasePart")
                and self.Name == "HumanoidRootPart"
                and LocalPlayer.Character and self:IsDescendantOf(LocalPlayer.Character) then
                return Vector3.zero
            end
        end
        return oldIndex(self, key)
    end)
    
    local oldNewIndex = mt.__newindex
    mt.__newindex = newcclosure(function(self, key, value)
        if BoosterEnabled and (key == "AssemblyLinearVelocity" or key == "Velocity") then
            if typeof(self) == "Instance" and self:IsA("BasePart")
                and self.Name == "HumanoidRootPart"
                and LocalPlayer.Character and self:IsDescendantOf(LocalPlayer.Character) then
                return
            end
        end
        return oldNewIndex(self, key, value)
    end)
    setreadonly(mt, true)
end)

local jumpDebounce = false

-- Zıplama gücünü artır (Artık Speed Boost Hook'una takılmaz)
UserInputService.JumpRequest:Connect(function()
    if BoosterEnabled and LocalPlayer.Character and not jumpDebounce then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air then
            jumpDebounce = true
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            
            local lv = ensureBoostLinVel(LocalPlayer.Character)
            if lv then
                lv.MaxForce = 1e6
                lv.LineVelocity = 75
                task.delay(0.2, function()
                    if lv and lv.Parent then
                        lv.LineVelocity = 0
                        lv.MaxForce = 0
                    end
                    jumpDebounce = false
                end)
            else
                jumpDebounce = false
            end
        end
    end
end)

-- Havada yumuşak süzülme (Glide)
RunService.RenderStepped:Connect(function()
    if BoosterEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            local lv = ensureBoostLinVel(LocalPlayer.Character)
            if lv then
                if hum:GetState() == Enum.HumanoidStateType.Freefall or hum.FloorMaterial == Enum.Material.Air then
                    if lv.LineVelocity ~= 75 then
                        lv.MaxForce = 1e6
                        lv.LineVelocity = -10
                    end
                else
                    if lv.LineVelocity ~= 75 then
                        lv.MaxForce = 0
                        lv.LineVelocity = 0
                    end
                end
            end
        end
    end
end)

---------------------------------------------------------
-- 2. DOSYADAN ALINAN YENİ SPEED BOOST SİSTEMİ (DOKUNULMADI)
---------------------------------------------------------
local SpeedBoostEnabled = false

local NS = 60
local CS = 30
local LAGGER_SPEED = 40
local LAGGER_CARRY_SPEED = 20

local speedMode = false
local laggerToggled = false
local laggerPhase = 0

local autoCarrySpeedEnabled = false
local antiRagdollSpeedEnabled = true

local MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}

local function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand == true
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
end

local function getActiveMoveSpeed()
    local laggerOn = laggerToggled == true
    local laggerCarry = laggerOn and (laggerPhase == 2)

    if speedMode and not laggerOn then
        return tonumber(CS) or 30
    end
    if laggerOn then
        if laggerCarry then
            return tonumber(LAGGER_CARRY_SPEED) or 20
        end
        return tonumber(LAGGER_SPEED) or 40
    end
    
    return tonumber(NS) or 60
end

local _linVel, _linVelAtt0, _linVelAtt1, _linVelChar = nil, nil, nil, nil
local spoofedVelocity = Vector3.zero

local function destroyLinVel()
    if _linVel then pcall(_linVel.Destroy, _linVel) end
    if _linVelAtt0 then pcall(_linVelAtt0.Destroy, _linVelAtt0) end
    if _linVelAtt1 then pcall(_linVelAtt1.Destroy, _linVelAtt1) end
    _linVel, _linVelAtt0, _linVelAtt1, _linVelChar = nil, nil, nil, nil
end

local function setupLinearVelocity(char)
    destroyLinVel()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        local ok, res = pcall(function() return char:WaitForChild("HumanoidRootPart", 5) end)
        if ok then hrp = res end
    end
    if not hrp then return end

    local att0 = Instance.new("Attachment")
    att0.Name = "OrvynLinVelAtt0"
    att0.Parent = hrp

    local att1 = Instance.new("Attachment")
    att1.Name = "OrvynLinVelAtt1"
    att1.Parent = hrp

    local lv = Instance.new("LinearVelocity")
    lv.Name = "OrvynLinVel"
    lv.Attachment0 = att0
    lv.Attachment1 = att1
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
    lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.MaxForce = 1e6
    lv.PlaneVelocity = Vector2.new(0, 0)
    lv.Parent = hrp

    _linVel = lv
    _linVelAtt0 = att0
    _linVelAtt1 = att1
    _linVelChar = char
end

local function setLinVelXZ(x, z)
    if _linVel and _linVel.Parent then
        pcall(function()
            _linVel.PlaneVelocity = Vector2.new(x, z)
        end)
    end
end

local function clearLinVel()
    if _linVel and _linVel.Parent then
        pcall(function()
            _linVel.PlaneVelocity = Vector2.new(0, 0)
        end)
    end
end

local function ensureLinVel()
    local char = LocalPlayer.Character
    if not char then return false end
    if _linVel and _linVel.Parent and _linVelChar == char then
        return true
    end
    setupLinearVelocity(char)
    return _linVel ~= nil and _linVel.Parent ~= nil
end

pcall(function()
    if not (getrawmetatable and setreadonly and newcclosure) then return end
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldIndex = mt.__index
    mt.__index = newcclosure(function(self, key)
        if key == "AssemblyLinearVelocity" or key == "Velocity" then
            if typeof(self) == "Instance" and self:IsA("BasePart")
                and self.Name == "HumanoidRootPart"
                and LocalPlayer.Character and self:IsDescendantOf(LocalPlayer.Character) then
                return spoofedVelocity
            end
        end
        return oldIndex(self, key)
    end)
    local oldNewIndex = mt.__newindex
    mt.__newindex = newcclosure(function(self, key, value)
        if key == "AssemblyLinearVelocity" or key == "Velocity" then
            if typeof(self) == "Instance" and self:IsA("BasePart")
                and self.Name == "HumanoidRootPart"
                and LocalPlayer.Character and self:IsDescendantOf(LocalPlayer.Character) then
                return
            end
        end
        return oldNewIndex(self, key, value)
    end)
    setreadonly(mt, true)
end)

RunService.Heartbeat:Connect(function()
    spoofedVelocity = Vector3.zero
end)

local lastMoveDir = Vector3.zero

local function ApplySpeedBoost(enabled)
    SpeedBoostEnabled = enabled
    if not enabled then
        clearLinVel()
        destroyLinVel()
    end
end

RunService.RenderStepped:Connect(function()
    if not SpeedBoostEnabled then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    local ws = hum.WalkSpeed
    if ws > 18 and ws < 25 then
        speedMode = true
    else
        speedMode = false
    end

    if isRagdollState(hum) then
        lastMoveDir = Vector3.zero
        clearLinVel()
        return
    end

    ensureLinVel()

    local md = hum.MoveDirection
    local spd = getActiveMoveSpeed()

    if md.Magnitude > 0 then
        lastMoveDir = md
        setLinVelXZ(md.X * spd, md.Z * spd)
    elseif antiRagdollSpeedEnabled and lastMoveDir.Magnitude > 0 then
        local anyHeld = false
        for key in pairs(MOVE_KEYS) do
            if UserInputService:IsKeyDown(key) then
                anyHeld = true
                break
            end
        end
        if anyHeld then
            setLinVelXZ(lastMoveDir.X * spd, lastMoveDir.Z * spd)
        else
            clearLinVel()
        end
    else
        clearLinVel()
    end
end)

---------------------------------------------------------
-- 3. OTO TP & ANTI RAGDOLL SİSTEMİ
---------------------------------------------------------
local AutoTp1Enabled = false
local AutoTp2Enabled = false
local AntiRagdollConnection = nil
local AntiRagdollResetCooldown = 0
local WasRagdolled = false

local function IsPlayerRagdolled()
    local char = LocalPlayer.Character
    if not char then return false end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            return true
        end
    end
    
    if char:FindFirstChild("Ragdoll") or char:FindFirstChild("IsRagdolled") or char:FindFirstChild("Ragdolled") then
        return true
    end
    return false
end

-- Sadece Ragdoll Anında Işınlanma Mantığı
RunService.Heartbeat:Connect(function()
    local currentlyRagdolled = IsPlayerRagdolled()
    
    if currentlyRagdolled and not WasRagdolled then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if AutoTp1Enabled then
                hrp.CFrame = CFrame.new(Vector3.new(-474.5, -6.8, 91.7))
            elseif AutoTp2Enabled then
                hrp.CFrame = CFrame.new(Vector3.new(-474.2, -6.8, 30.9))
            end
        end
    end
    
    WasRagdolled = currentlyRagdolled
end)

local function forceResetAntiRagdoll()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
        root.RotVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end

        workspace.CurrentCamera.CameraSubject = hum
    end)
end

local function ApplyAntiRagdoll(enabled)
    if enabled then
        if AntiRagdollConnection then return end
        AntiRagdollConnection = RunService.Heartbeat:Connect(function()
            if IsPlayerRagdolled() then
                local now = tick()
                if now - AntiRagdollResetCooldown > 0.1 then
                    AntiRagdollResetCooldown = now
                    forceResetAntiRagdoll()
                end
            end
        end)
    else
        if AntiRagdollConnection then
            AntiRagdollConnection:Disconnect()
            AntiRagdollConnection = nil
        end
    end
end

---------------------------------------------------------
-- 4. Hitbox Expander & Silah Fonksiyonları
---------------------------------------------------------
local HitboxEnabled = false
local HitboxObjects = {}

local function ClearHitboxes()
    for player, data in pairs(HitboxObjects) do
        if data.Part then pcall(function() data.Part:Destroy() end) end
        if data.BbGui then pcall(function() data.BbGui:Destroy() end) end
        if data.OriginalSize and data.HRP then
            pcall(function()
                data.HRP.Size = data.OriginalSize
                data.HRP.Transparency = 1
                data.HRP.CanCollide = false
            end)
        end
    end
    HitboxObjects = {}
end

task.spawn(function()
    local hue = 0
    while task.wait() do
        hue = (hue + 0.01) % 1
        local currentColor = Color3.fromHSV(hue, 0.85, 1)

        if HitboxEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        if not HitboxObjects[player] then
                            HitboxObjects[player] = { HRP = hrp, OriginalSize = hrp.Size }
                            local boxPart = Instance.new("Part")
                            boxPart.Size = Vector3.new(8, 8, 8)
                            boxPart.Transparency = 0.75
                            boxPart.Material = Enum.Material.SmoothPlastic
                            boxPart.CanCollide = false
                            boxPart.Anchored = false

                            local weld = Instance.new("Weld")
                            weld.Part0 = hrp
                            weld.Part1 = boxPart
                            weld.Parent = boxPart
                            boxPart.Parent = player.Character

                            local bbGui = Instance.new("BillboardGui")
                            bbGui.Adornee = boxPart
                            bbGui.Size = UDim2.new(0, 150, 0, 30)
                            bbGui.StudsOffset = Vector3.new(0, 5, 0)
                            bbGui.AlwaysOnTop = true
                            bbGui.Parent = boxPart

                            local nameLabel = Instance.new("TextLabel")
                            nameLabel.Size = UDim2.new(1, 0, 1, 0)
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.Text = player.DisplayName or player.Name
                            nameLabel.Font = Enum.Font.GothamBold
                            nameLabel.TextSize = 11
                            nameLabel.TextStrokeTransparency = 0.2
                            nameLabel.Parent = bbGui

                            HitboxObjects[player].Part = boxPart
                            HitboxObjects[player].BbGui = bbGui
                            HitboxObjects[player].Label = nameLabel
                        end
                        hrp.Size = Vector3.new(8, 8, 8)
                        hrp.Transparency = 1
                        hrp.CanCollide = false

                        local obj = HitboxObjects[player]
                        if obj.Part then obj.Part.Color = currentColor end
                        if obj.Label then obj.Label.TextColor3 = currentColor end
                    end
                end
            end
        else
            ClearHitboxes()
        end
    end
end)

local LaserGunFire = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net") and ReplicatedStorage.Packages.Net:FindFirstChild("RE/LaserGun_Fire")

local function fireLaserGunOnce()
    local Character = LocalPlayer.Character
    if not Character then return end
    local Tool = Character:FindFirstChildOfClass("Tool")
    if not Tool or Tool.Name ~= "Laser Gun" then return end
    local origin = Character.PrimaryPart and Character.PrimaryPart.Position
    if not origin then return end

    if LaserGunFire then
        for _ = 1, 60 do
            local requestId = HttpService:GenerateGUID(false):lower():gsub("%-", "")
            local direction = Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2)).Unit
            LaserGunFire:FireServer(requestId, origin, direction, workspace:GetServerTimeNow())
        end
    end
end

local AutoFireLaserCapeEnabled = false
local PaintballWhileStealEnabled = false
local FuckerWhileStealEnabled = false
local HitWhileStealingEnabled = false

---------------------------------------------------------
-- Auto Steal
---------------------------------------------------------
local AutoStealEnabled = false
local IsInsideAutoStealRange = false
local CurrentStealPrompt = nil
local StealHoldStartTime = 0

task.spawn(function()
    while task.wait(1) do
        if not AutoStealEnabled then 
            IsInsideAutoStealRange = false
            if CurrentStealPrompt then pcall(function() CurrentStealPrompt:InputHoldEnd() end) CurrentStealPrompt = nil end
            continue 
        end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local nearest, minDist = nil, 17
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and (string.find(string.lower(obj.Name), "steal") or string.find(string.lower(obj.ActionText), "steal")) then
                obj.MaxActivationDistance = 17
                local pos = obj.Parent and (obj.Parent:IsA("BasePart") and obj.Parent.Position or obj.Parent:IsA("Attachment") and obj.Parent.WorldPosition)
                if pos then
                    local dist = (pos - hrp.Position).Magnitude
                    if dist <= 17 and dist < minDist then minDist = dist nearest = obj end
                end
            end
        end

        if nearest then
            IsInsideAutoStealRange = true
            if CurrentStealPrompt ~= nearest then
                if CurrentStealPrompt then pcall(function() CurrentStealPrompt:InputHoldEnd() end) end
                CurrentStealPrompt = nearest
                StealHoldStartTime = tick()
                pcall(function() CurrentStealPrompt:InputHoldBegin() end)
            end
        else
            IsInsideAutoStealRange = false
            if CurrentStealPrompt then pcall(function() CurrentStealPrompt:InputHoldEnd() end) CurrentStealPrompt = nil end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if AutoStealEnabled then
        StealFrame.Visible = true
        if CurrentStealPrompt then
            local duration = CurrentStealPrompt.HoldDuration <= 0 and 0.1 or CurrentStealPrompt.HoldDuration
            local progress = math.clamp((tick() - StealHoldStartTime) / duration, 0, 1)
            StealFill.Size = UDim2.new(progress, 0, 1, 0)
            StealText.Text = math.floor(progress * 100) .. "%"
        else
            StealFill.Size = UDim2.new(0, 0, 1, 0)
            StealText.Text = "0%"
        end
    else
        StealFrame.Visible = false
    end
end)

---------------------------------------------------------
-- GUI OLUŞTURUCULAR
---------------------------------------------------------
local function CreateToggle(parent, text, hasKeybind, defaultKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 26)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(35, 38, 46)
    Stroke.Thickness = 1
    Stroke.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 6, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(235, 235, 235)
    Label.TextSize = 8
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    if hasKeybind then
        local KeybindBtn = Instance.new("TextButton")
        KeybindBtn.Size = UDim2.new(0, 20, 0, 14)
        KeybindBtn.Position = UDim2.new(1, -25, 0.5, -7)
        KeybindBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
        KeybindBtn.Text = defaultKey or "X"
        KeybindBtn.TextColor3 = Color3.fromRGB(250, 200, 20)
        KeybindBtn.TextSize = 8
        KeybindBtn.Font = Enum.Font.GothamBold
        KeybindBtn.Parent = Frame
        
        local KCorner = Instance.new("UICorner")
        KCorner.CornerRadius = UDim.new(0, 3)
        KCorner.Parent = KeybindBtn

        local boundKey = Enum.KeyCode.X
        pcall(function() boundKey = Enum.KeyCode[defaultKey] end)

        UserInputService.InputBegan:Connect(function(input, gp)
            if not gp and input.KeyCode == boundKey then
                if callback then task.spawn(callback, true) end
            end
        end)
    else
        local SwitchTrack = Instance.new("TextButton")
        SwitchTrack.Size = UDim2.new(0, 26, 0, 13)
        SwitchTrack.Position = UDim2.new(1, -30, 0.5, -6.5)
        SwitchTrack.BackgroundColor3 = Color3.fromRGB(45, 48, 56)
        SwitchTrack.Text = ""
        SwitchTrack.AutoButtonColor = false
        SwitchTrack.Parent = Frame
        
        local TrackCorner = Instance.new("UICorner")
        TrackCorner.CornerRadius = UDim.new(1, 0)
        TrackCorner.Parent = SwitchTrack

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 9, 0, 9)
        Knob.Position = UDim2.new(0, 2, 0.5, -4.5)
        Knob.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        Knob.Parent = SwitchTrack
        
        local KnobCorner = Instance.new("UICorner")
        KnobCorner.CornerRadius = UDim.new(1, 0)
        KnobCorner.Parent = Knob

        local toggled = false
        SwitchTrack.MouseButton1Click:Connect(function()
            toggled = not toggled
            local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if toggled then
                TweenService:Create(SwitchTrack, tweenInfo, {BackgroundColor3 = Color3.fromRGB(250, 200, 20)}):Play()
                TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(1, -11, 0.5, -4.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                TweenService:Create(SwitchTrack, tweenInfo, {BackgroundColor3 = Color3.fromRGB(45, 48, 56)}):Play()
                TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -4.5), BackgroundColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            end
            if callback then task.spawn(callback, toggled) end
        end)
    end
end

---------------------------------------------------------
-- TELEPORT BUTONLARI (Glow Efektli)
---------------------------------------------------------
local Tp1Btn, Tp1Stroke, Tp1Label
local Tp2Btn, Tp2Stroke, Tp2Label

local function UpdateTpVisuals()
    if AutoTp1Enabled then
        Tp1Stroke.Color = Color3.fromRGB(250, 200, 20)
        Tp1Label.TextColor3 = Color3.fromRGB(250, 200, 20)
    else
        Tp1Stroke.Color = Color3.fromRGB(35, 38, 46)
        Tp1Label.TextColor3 = Color3.fromRGB(150, 150, 150)
    end

    if AutoTp2Enabled then
        Tp2Stroke.Color = Color3.fromRGB(250, 200, 20)
        Tp2Label.TextColor3 = Color3.fromRGB(250, 200, 20)
    else
        Tp2Stroke.Color = Color3.fromRGB(35, 38, 46)
        Tp2Label.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end

local function CreateTpButton(parent, text, isTp1)
    local Frame = Instance.new("TextButton")
    Frame.Size = UDim2.new(1, 0, 0, 26)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    Frame.BorderSizePixel = 0
    Frame.Text = ""
    Frame.AutoButtonColor = false
    Frame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(35, 38, 46)
    Stroke.Thickness = 1
    Stroke.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(150, 150, 150)
    Label.TextSize = 9
    Label.Font = Enum.Font.GothamBold
    Label.Parent = Frame
    
    Frame.MouseButton1Click:Connect(function()
        if isTp1 then
            AutoTp1Enabled = not AutoTp1Enabled
            if AutoTp1Enabled then AutoTp2Enabled = false end 
        else
            AutoTp2Enabled = not AutoTp2Enabled
            if AutoTp2Enabled then AutoTp1Enabled = false end
        end
        UpdateTpVisuals()
    end)

    return Frame, Stroke, Label
end

---------------------------------------------------------
-- UI Elemanlarını Yerleştirme
---------------------------------------------------------
CreateToggle(LeftColumn, "BOOSTER", false, nil, function(v) ApplyBooster(v) end)
CreateToggle(LeftColumn, "SPEED BOOST", false, nil, function(v) ApplySpeedBoost(v) end)
CreateToggle(LeftColumn, "ANTI RAGDOLL", false, nil, function(v) ApplyAntiRagdoll(v) end)
CreateToggle(LeftColumn, "HITBOX EXPANDER", false, nil, function(v) HitboxEnabled = v if not v then ClearHitboxes() end end)
CreateToggle(LeftColumn, "HIT WHILE STEALING", false, nil, function(v) HitWhileStealingEnabled = v end)

Tp1Btn, Tp1Stroke, Tp1Label = CreateTpButton(LeftColumn, "TELEPORT 1", true)
Tp2Btn, Tp2Stroke, Tp2Label = CreateTpButton(LeftColumn, "TELEPORT 2", false)

CreateToggle(RightColumn, "LASERGUN FUCKER", true, "X", function() fireLaserGunOnce() end)
CreateToggle(RightColumn, "AUTO FIRE LASER CAPE", false, nil, function(v) AutoFireLaserCapeEnabled = v end)
CreateToggle(RightColumn, "PAINTBALL WHILE STEALIN", false, nil, function(v) PaintballWhileStealEnabled = v end)
CreateToggle(RightColumn, "AUTO STEAL", false, nil, function(v) AutoStealEnabled = v end)
CreateToggle(RightColumn, "FUCKER WHILE STEAL", false, nil, function(v) FuckerWhileStealEnabled = v end)