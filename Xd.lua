--// Rainbow Mobile Shiftlock — Clean Circle + Lock (Like Image)
--// LocalScript — StarterPlayer > StarterPlayerScripts

local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UserInputService= game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local GameSettings    = UserSettings():GetService("UserGameSettings")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local shiftOn = false
local locked  = true
local hue     = 0

--=============================================================
-- GUI
--=============================================================
local gui = Instance.new("ScreenGui")
gui.Name           = "RainbowShiftlock"
gui.ResetOnSpawn   = false
gui.IgnoreGuiInset = true
gui.DisplayOrder   = 9999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent         = playerGui

--=============================================================
-- SHIFTLOCK BUTTON (Matches image: Circle, thick border, lock icon)
--=============================================================
local btn = Instance.new("TextButton")
btn.Name             = "ShiftButton"
btn.AnchorPoint      = Vector2.new(0.5, 0.5)
btn.Size             = UDim2.fromOffset(72, 72)
btn.Position         = UDim2.new(1, -56, 0.5, 0)
btn.BackgroundColor3 = Color3.fromRGB(30, 25, 22) -- Dark background like the image
btn.Text             = ""
btn.AutoButtonColor  = false
btn.BorderSizePixel  = 0
btn.Active           = true
btn.ClipsDescendants = false
btn.Parent           = gui

-- Make it a perfect circle
Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

-- Rainbow border stroke (thick like the image)
local glow = Instance.new("UIStroke")
glow.Thickness    = 5
glow.Color        = Color3.fromHSV(0, 1, 1)
glow.Transparency = 0
glow.Parent       = btn

-- The lock icon in the middle
local icon = Instance.new("TextLabel")
icon.Name                   = "Icon"
icon.AnchorPoint            = Vector2.new(0.5, 0.5)
icon.Position               = UDim2.fromScale(0.5, 0.5)
icon.Size                   = UDim2.fromScale(1, 1)
icon.BackgroundTransparency = 1
icon.Text                   = "🔒"
icon.TextSize               = 34
icon.Font                   = Enum.Font.GothamBold
icon.TextColor3             = Color3.fromRGB(240, 240, 240)
icon.ZIndex                 = 3
icon.Parent                 = btn

-- Pulse ring (expands on activation)
local pulse = Instance.new("Frame")
pulse.Name                   = "Pulse"
pulse.AnchorPoint            = Vector2.new(0.5, 0.5)
pulse.Position               = UDim2.fromScale(0.5, 0.5)
pulse.Size                   = UDim2.fromScale(1, 1)
pulse.BackgroundTransparency = 1
pulse.BorderSizePixel        = 0
pulse.ZIndex                 = 1
pulse.Parent                 = btn
Instance.new("UICorner", pulse).CornerRadius = UDim.new(1, 0)

local pulseStroke = Instance.new("UIStroke")
pulseStroke.Thickness    = 4
pulseStroke.Color        = Color3.fromRGB(0, 240, 255)
pulseStroke.Transparency = 1
pulseStroke.Parent       = pulse

--=============================================================
-- MOVE-LOCK BUTTON (Small button to drag it)
--=============================================================
local lockBtn = Instance.new("TextButton")
lockBtn.Name             = "LockButton"
lockBtn.AnchorPoint      = Vector2.new(0.5, 0.5)
lockBtn.Size             = UDim2.fromOffset(40, 40)
lockBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
lockBtn.Text             = "🔒"
lockBtn.TextSize         = 18
lockBtn.Font             = Enum.Font.GothamBold
lockBtn.TextColor3       = Color3.new(1, 1, 1)
lockBtn.AutoButtonColor  = false
lockBtn.BorderSizePixel  = 0
lockBtn.Active           = true
lockBtn.Parent           = gui

Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(1, 0)

local lockStroke = Instance.new("UIStroke")
lockStroke.Thickness    = 2
lockStroke.Color        = Color3.fromRGB(0, 240, 255)
lockStroke.Transparency = 0.3
lockStroke.Parent       = lockBtn

local function updateLockPos()
    lockBtn.Position = UDim2.new(
        btn.Position.X.Scale, btn.Position.X.Offset - 86,
        btn.Position.Y.Scale, btn.Position.Y.Offset
    )
    task.defer(function()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp     = cam.ViewportSize
        local half   = lockBtn.AbsoluteSize / 2
        local center = lockBtn.AbsolutePosition + half
        local cx     = math.clamp(center.X, half.X, vp.X - half.X)
        local cy     = math.clamp(center.Y, half.Y, vp.Y - half.Y)
        if math.abs(cx - center.X) > 1 or math.abs(cy - center.Y) > 1 then
            lockBtn.Position = UDim2.fromOffset(cx, cy)
        end
    end)
end
updateLockPos()

--=============================================================
-- RAINBOW ANIMATION
--=============================================================
RunService.Heartbeat:Connect(function(dt)
    hue = (hue + dt * 0.35) % 1
    
    -- Button border rainbow
    glow.Color        = Color3.fromHSV(hue, 1, 1)
    pulseStroke.Color = Color3.fromHSV(hue, 1, 1)
end)

--=============================================================
-- PULSE ANIMATION
--=============================================================
local function playPulse()
    pulse.Size               = UDim2.fromScale(1, 1)
    pulseStroke.Transparency = 0.2
    TweenService:Create(pulse, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.fromScale(1.5, 1.5),
    }):Play()
    TweenService:Create(pulseStroke, TweenInfo.new(0.5), {
        Transparency = 1,
    }):Play()
end

--=============================================================
-- SHIFTLOCK LOGIC
--=============================================================
local function setShiftlock(state)
    shiftOn = state

    local char = player.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")

    if shiftOn then
        player.CameraMode         = Enum.CameraMode.Classic
        GameSettings.RotationType = Enum.RotationType.CameraRelative
        if hum then
            hum.AutoRotate   = true
            hum.CameraOffset = Vector3.new(1.5, 0.5, 0)
        end
        icon.Text      = "🔓" -- Unlocked padlock
        glow.Thickness = 6
        playPulse()
    else
        GameSettings.RotationType = Enum.RotationType.MovementRelative
        if hum then
            hum.CameraOffset = Vector3.zero
        end
        icon.Text      = "🔒" -- Locked padlock
        glow.Thickness = 5
    end
end

player.CharacterAdded:Connect(function(char)
    if not char:WaitForChild("Humanoid", 10) then return end
    task.wait(0.2)
    if shiftOn then setShiftlock(true) end
end)

--=============================================================
-- LOCK TOGGLE
--=============================================================
lockBtn.Activated:Connect(function()
    locked = not locked
    lockBtn.Text     = locked and "🔒" or "🔓"
    lockStroke.Color = locked and Color3.fromRGB(0, 240, 255)
                               or Color3.fromRGB(255, 200, 60)
end)

--=============================================================
-- SHIFT BUTTON: tap = toggle | drag (when unlocked) = move
--=============================================================
local function clampButton()
    task.wait()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp     = cam.ViewportSize
    local half   = btn.AbsoluteSize / 2
    local center = btn.AbsolutePosition + half
    local cx     = math.clamp(center.X, half.X, vp.X - half.X)
    local cy     = math.clamp(center.Y, half.Y, vp.Y - half.Y)
    btn.Position = UDim2.fromOffset(cx, cy)
    updateLockPos()
end

btn.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.Touch
    and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

    local didMove     = false
    local startPosNow = btn.Position
    local startInput  = Vector2.new(input.Position.X, input.Position.Y)
    local dragConn

    if not locked then
        dragConn = UserInputService.InputChanged:Connect(function(changed)
            if changed.UserInputType == Enum.UserInputType.Touch then
                if changed ~= input then return end
            elseif changed.UserInputType == Enum.UserInputType.MouseMovement then
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            else
                return
            end

            local delta = Vector2.new(changed.Position.X, changed.Position.Y) - startInput
            if not didMove and delta.Magnitude > 8 then
                didMove = true
            end
            if didMove then
                btn.Position = UDim2.new(
                    startPosNow.X.Scale, startPosNow.X.Offset + delta.X,
                    startPosNow.Y.Scale, startPosNow.Y.Offset + delta.Y
                )
                updateLockPos()
            end
        end)
    end

    local endConn
    endConn = input.Changed:Connect(function()
        if input.UserInputState ~= Enum.UserInputState.End then return end
        endConn:Disconnect()
        if dragConn then dragConn:Disconnect() end

        if didMove then
            clampButton()
        else
            setShiftlock(not shiftOn)
        end
    end)
end)