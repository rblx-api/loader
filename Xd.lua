print("MVP TP BATE loaded")

-- // ========================== //
-- //       MVP TP BATE          //
-- //   (GUI + Anti-Desync)      //
-- // ========================== //

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")

-- // Local Player
local LP = Players.LocalPlayer
if not LP then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LP = Players.LocalPlayer
end

-- // ========================== //
-- //          GUI              //
-- // ========================== //

local MvpTpBat = Instance.new("ScreenGui")
MvpTpBat.Name = "MvpTpBat"
MvpTpBat.IgnoreGuiInset = true
MvpTpBat.ResetOnSpawn = false
MvpTpBat.DisplayOrder = 999999
MvpTpBat.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MvpTpBat.Parent = LP:WaitForChild("PlayerGui")

-- Main Frame (draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Position = UDim2.new(0.5, -148, 0.5, -40)
MainFrame.Size = UDim2.new(0, 296, 0, 80)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MvpTpBat

local locked = false

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 1.3
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Transparency = 0.55
UIStroke.Parent = MainFrame

-- Background Image
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Size = UDim2.new(1, 0, 1, 0)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://109619268613730"
ImageLabel.ImageTransparency = 0.50
ImageLabel.ScaleType = Enum.ScaleType.Crop
ImageLabel.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 14)
UICorner2.Parent = ImageLabel

-- Dark Overlay (más oscuro para que la foto no quede iluminada)
local Overlay = Instance.new("Frame")
Overlay.ZIndex = 2
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0.18
Overlay.BorderSizePixel = 0
Overlay.Parent = MainFrame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 14)
UICorner3.Parent = Overlay

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Transparency = NumberSequence.new(0.4, 0.65)
UIGradient.Parent = Overlay

-- Title bien visible (blanco + contorno oscuro)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.ZIndex = 6
TitleLabel.Position = UDim2.new(0, 14, 0, 10)
TitleLabel.Size = UDim2.new(1, -120, 0, 18)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "MVP TP BATE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(0, 0, 0)
TitleStroke.Thickness = 1.6
TitleStroke.Transparency = 0.25
TitleStroke.Parent = TitleLabel

-- Keybind (...) + Lock + Size controls
local KeybindBtn = Instance.new("TextButton")
KeybindBtn.ZIndex = 8
KeybindBtn.Position = UDim2.new(1, -114, 0, 8)
KeybindBtn.Size = UDim2.new(0, 24, 0, 24)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
KeybindBtn.BackgroundTransparency = 0.2
KeybindBtn.BorderSizePixel = 0
KeybindBtn.Text = "..."
KeybindBtn.TextColor3 = Color3.fromRGB(235, 235, 240)
KeybindBtn.TextSize = 11
KeybindBtn.Font = Enum.Font.GothamBold
KeybindBtn.AutoButtonColor = false
KeybindBtn.Parent = MainFrame

local UICornerKey = Instance.new("UICorner")
UICornerKey.CornerRadius = UDim.new(1, 0)
UICornerKey.Parent = KeybindBtn

local UIStrokeKey = Instance.new("UIStroke")
UIStrokeKey.Color = Color3.fromRGB(255, 255, 255)
UIStrokeKey.Transparency = 0.35
UIStrokeKey.Parent = KeybindBtn

local LockBtn = Instance.new("TextButton")
LockBtn.ZIndex = 8
LockBtn.Position = UDim2.new(1, -86, 0, 8)
LockBtn.Size = UDim2.new(0, 24, 0, 24)
LockBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LockBtn.BackgroundTransparency = 0.2
LockBtn.BorderSizePixel = 0
LockBtn.Text = "🔓"
LockBtn.TextColor3 = Color3.fromRGB(235, 235, 240)
LockBtn.TextSize = 12
LockBtn.Font = Enum.Font.GothamBold
LockBtn.AutoButtonColor = false
LockBtn.Parent = MainFrame

local UICornerLock = Instance.new("UICorner")
UICornerLock.CornerRadius = UDim.new(1, 0)
UICornerLock.Parent = LockBtn

local UIStrokeLock = Instance.new("UIStroke")
UIStrokeLock.Color = Color3.fromRGB(255, 255, 255)
UIStrokeLock.Transparency = 0.35
UIStrokeLock.Parent = LockBtn

local SizeMinusBtn = Instance.new("TextButton")
SizeMinusBtn.ZIndex = 8
SizeMinusBtn.Position = UDim2.new(1, -58, 0, 8)
SizeMinusBtn.Size = UDim2.new(0, 24, 0, 24)
SizeMinusBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SizeMinusBtn.BackgroundTransparency = 0.2
SizeMinusBtn.BorderSizePixel = 0
SizeMinusBtn.Text = "−"
SizeMinusBtn.TextColor3 = Color3.fromRGB(235, 235, 240)
SizeMinusBtn.TextSize = 16
SizeMinusBtn.Font = Enum.Font.GothamBold
SizeMinusBtn.AutoButtonColor = false
SizeMinusBtn.Parent = MainFrame

local UICornerMinus = Instance.new("UICorner")
UICornerMinus.CornerRadius = UDim.new(1, 0)
UICornerMinus.Parent = SizeMinusBtn

local UIStrokeMinus = Instance.new("UIStroke")
UIStrokeMinus.Color = Color3.fromRGB(255, 255, 255)
UIStrokeMinus.Transparency = 0.35
UIStrokeMinus.Parent = SizeMinusBtn

local SizePlusBtn = Instance.new("TextButton")
SizePlusBtn.ZIndex = 8
SizePlusBtn.Position = UDim2.new(1, -30, 0, 8)
SizePlusBtn.Size = UDim2.new(0, 24, 0, 24)
SizePlusBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SizePlusBtn.BackgroundTransparency = 0.2
SizePlusBtn.BorderSizePixel = 0
SizePlusBtn.Text = "+"
SizePlusBtn.TextColor3 = Color3.fromRGB(235, 235, 240)
SizePlusBtn.TextSize = 16
SizePlusBtn.Font = Enum.Font.GothamBold
SizePlusBtn.AutoButtonColor = false
SizePlusBtn.Parent = MainFrame

local UICornerPlus = Instance.new("UICorner")
UICornerPlus.CornerRadius = UDim.new(1, 0)
UICornerPlus.Parent = SizePlusBtn

local UIStrokePlus = Instance.new("UIStroke")
UIStrokePlus.Color = Color3.fromRGB(255, 255, 255)
UIStrokePlus.Transparency = 0.35
UIStrokePlus.Parent = SizePlusBtn

-- Bottom bar con burbujita sutil
local Bar = Instance.new("Frame")
Bar.ZIndex = 5
Bar.Position = UDim2.new(0, 12, 0, 40)
Bar.Size = UDim2.new(1, -24, 0, 30)
Bar.BackgroundTransparency = 1
Bar.Parent = MainFrame

local ActionBubble = Instance.new("Frame")
ActionBubble.ZIndex = 7
ActionBubble.Size = UDim2.new(1, 0, 1, 0)
ActionBubble.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ActionBubble.BackgroundTransparency = 0.45
ActionBubble.BorderSizePixel = 0
ActionBubble.Parent = Bar

local UICornerBubble = Instance.new("UICorner")
UICornerBubble.CornerRadius = UDim.new(1, 0)
UICornerBubble.Parent = ActionBubble

local UIStrokeBubble = Instance.new("UIStroke")
UIStrokeBubble.Color = Color3.fromRGB(255, 255, 255)
UIStrokeBubble.Transparency = 0.45
UIStrokeBubble.Thickness = 1
UIStrokeBubble.Parent = ActionBubble

-- Toggle button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.ZIndex = 9
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = "ACTIVATE TP BATE"
ToggleBtn.TextColor3 = Color3.fromRGB(235, 235, 240)
ToggleBtn.TextSize = 12
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ActionBubble

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 1.35
ToggleStroke.Transparency = 0.15
ToggleStroke.Parent = ToggleBtn

-- ========================== //
-- //     TP BAT LOGIC       //
-- ========================== //

local autoBat = false
local silentAim = false
local cooldown = false

local TOGGLE_KEY = Enum.KeyCode.X
local listeningBind = false

local char, h, hrp = nil, nil, nil

local currentScale = 1
local MIN_SCALE = 0.7
local MAX_SCALE = 1.6

local function applyScale()
    MainScale.Scale = currentScale
end

local function updateBindLabel()
    KeybindBtn.Text = "..."
end

local function getBat()
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        tool = bp:FindFirstChild("Bat")
        if tool then
            tool.Parent = char
            return tool
        end
    end
    return nil
end

local function tryHit()
    if cooldown then return end
    cooldown = true
    pcall(function()
        local bat = getBat()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.05, function() cooldown = false end)
end

local function getClosest()
    if not hrp then return nil, math.huge end
    local best, bestDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    best = p
                end
            end
        end
    end
    return best, bestDist
end

local function setupChar(newChar)
    char = newChar
    task.wait(0.1)
    h = char:WaitForChild("Humanoid", 5)
    hrp = char:WaitForChild("HumanoidRootPart", 5)
end

local function setAutoBat(state)
    autoBat = state
    ToggleBtn.Text = autoBat and "DEACTIVATE TP BATE" or "ACTIVATE TP BATE"
    print("Auto Bat:", autoBat and "ON" or "OFF")
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

RunService.Heartbeat:Connect(function()
    if not (autoBat and h and hrp) then return end

    local target, dist = getClosest()
    if not target or not target.Character then return end
    local tr = target.Character:FindFirstChild("HumanoidRootPart")
    if not tr then return end

    if sethiddenproperty then
        sethiddenproperty(hrp, "PhysicsRepRootPart", tr)
        pcall(function() sethiddenproperty(hrp, "NetworkOwnership", 9999) end)
    end

    local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
    if dist > 8 then
        hrp.CFrame = CFrame.new(targetPos)
    end

    local cam = workspace.CurrentCamera
    if not silentAim then
        cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position + Vector3.new(0, 0.5, 0))
    end

    tryHit()
end)

local function isValidBindInput(inp)
    if inp.KeyCode == Enum.KeyCode.Unknown or inp.KeyCode == Enum.KeyCode.Escape then
        return false
    end
    local t = inp.UserInputType
    return t == Enum.UserInputType.Keyboard
        or t == Enum.UserInputType.Gamepad1
        or t == Enum.UserInputType.Gamepad2
        or t == Enum.UserInputType.Gamepad3
        or t == Enum.UserInputType.Gamepad4
end

UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end

    if listeningBind then
        if isValidBindInput(inp) then
            TOGGLE_KEY = inp.KeyCode
            listeningBind = false
            KeybindBtn.Text = "..."
            print("Bind set to:", TOGGLE_KEY.Name)
        end
        return
    end

    if inp.KeyCode == TOGGLE_KEY then
        setAutoBat(not autoBat)
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    setAutoBat(not autoBat)
end)

SizePlusBtn.MouseButton1Click:Connect(function()
    currentScale = math.clamp(currentScale + 0.1, MIN_SCALE, MAX_SCALE)
    applyScale()
end)

SizeMinusBtn.MouseButton1Click:Connect(function()
    currentScale = math.clamp(currentScale - 0.1, MIN_SCALE, MAX_SCALE)
    applyScale()
end)

LockBtn.MouseButton1Click:Connect(function()
    locked = not locked
    MainFrame.Draggable = not locked
    LockBtn.Text = locked and "🔒" or "🔓"
end)

KeybindBtn.MouseButton1Click:Connect(function()
    if listeningBind then return end
    listeningBind = true
    KeybindBtn.Text = "..."
    print("Press a key or controller button to bind...")
end)

updateBindLabel()

print("MVP TP BATE loaded.")
print("Click ... to set bind (PC or controller). That key toggles TP BATE. Drag to move. + / - resize. Lock freezes position.")