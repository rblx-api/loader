if not game:IsLoaded() then game.Loaded:Wait() end

local __ok, __err = xpcall(function()

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local Workspace         = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local ALIVE = true

------------------------------------------------------------
-- CFRAME WALK STATE
------------------------------------------------------------
local State = {
    Enabled = false,
    Power = 100000,
    Conn = nil,
    DiedConn = nil,
}

local function getHum()
    local c = LP.Character
    if not c then return nil, nil end
    return c:FindFirstChildOfClass("Humanoid"), c:FindFirstChild("HumanoidRootPart")
end

local function getMoveDirection()
    local cam = Camera.CFrame
    local dir = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then
        dir = dir + cam.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then
        dir = dir - cam.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then
        dir = dir - cam.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then
        dir = dir + cam.RightVector
    end
    dir = Vector3.new(dir.X, 0, dir.Z)
    if dir.Magnitude < 0.1 then return nil end
    return dir.Unit
end

local function forceAntiReset(hum)
    if not hum or not hum.Parent then return end
    pcall(function()
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        if hum.Health <= 0 or hum.Health < 5 then
            hum.Health = hum.MaxHealth
        end
    end)
end

local function hookDied(hum)
    if State.DiedConn then
        pcall(function() State.DiedConn:Disconnect() end)
        State.DiedConn = nil
    end
    if not hum then return end
    State.DiedConn = hum.Died:Connect(function()
        task.defer(function()
            if not State.Enabled then return end
            forceAntiReset(hum)
            if hum and hum.Parent then
                hum.Health = hum.MaxHealth
            end
        end)
    end)
end

local function applyCFrame(dt)
    local hum, hrp = getHum()
    if not hum or not hrp then return end

    forceAntiReset(hum)
    hum.WalkSpeed = 0
    hum.JumpPower = 0

    pcall(function()
        hrp:SetNetworkOwner(LP)
    end)
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)

    local move = getMoveDirection()
    if not move then return end

    local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
    local mult = 0.000025
    if tool then mult = mult * 0.7 end

    local speed = State.Power * mult
    hrp.CFrame = hrp.CFrame + (move * speed * 60 * dt)
end

local function start()
    if State.Conn then State.Conn:Disconnect() end
    local hum = getHum()
    if hum then
        forceAntiReset(hum)
        hookDied(hum)
    end
    State.Conn = RunService.Heartbeat:Connect(function(dt)
        if not State.Enabled or not ALIVE then return end
        applyCFrame(dt)
    end)
end

local function stop()
    if State.Conn then
        State.Conn:Disconnect()
        State.Conn = nil
    end
    if State.DiedConn then
        pcall(function() State.DiedConn:Disconnect() end)
        State.DiedConn = nil
    end
    local hum, hrp = getHum()
    if hum then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        hum.BreakJointsOnDeath = true
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
    end
    if hrp then
        pcall(function() hrp:SetNetworkOwner(nil) end)
    end
end

local function setActive(on)
    State.Enabled = on
    if on then start() else stop() end
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.6)
    local hum = char:WaitForChild("Humanoid", 3)
    if hum and State.Enabled then
        forceAntiReset(hum)
        hookDied(hum)
        start()
    end
end)

------------------------------------------------------------
-- GUI
------------------------------------------------------------
local C = {
    WIN   = Color3.fromRGB(14, 12, 22),
    TOP   = Color3.fromRGB(28, 24, 42),
    SEP   = Color3.fromRGB(70, 55, 110),
    DIM   = Color3.fromRGB(170, 155, 210),
    TEXT  = Color3.fromRGB(235, 230, 255),
    ACCENT = Color3.fromRGB(140, 90, 255),
    ON    = Color3.fromRGB(90, 40, 180),
    OFF   = Color3.fromRGB(32, 28, 48),
}

local FAMILY = "rbxasset://fonts/families/GothamSSm.json"
pcall(function() FAMILY = Font.fromEnum(Enum.Font.BuilderSans).Family end)
local function mkFont(w)
    local ok, f = pcall(function() return Font.new(FAMILY, w) end)
    return ok and f or Font.fromEnum(Enum.Font.GothamBold)
end
local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do pcall(function() o[k] = v end) end
    if parent then o.Parent = parent end
    return o
end
local function round(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function stroke(o, color, t)
    return new("UIStroke", { Color = color or C.SEP, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
end
local function text(parent, str, size, weight, color, xa)
    return new("TextLabel", {
        BackgroundTransparency = 1, Text = str or "", TextSize = size,
        TextColor3 = color or C.TEXT, TextXAlignment = xa or Enum.TextXAlignment.Left,
        FontFace = mkFont(weight or Enum.FontWeight.Medium), TextTruncate = Enum.TextTruncate.AtEnd
    }, parent)
end

pcall(function()
    for _, where in ipairs({ gethui and gethui() or nil, game:GetService("CoreGui"), LP:FindFirstChild("PlayerGui") }) do
        local old = where and where:FindFirstChild("CFrameWalk")
        if old then old:Destroy() end
    end
end)

local gui = new("ScreenGui", {
    Name = "CFrameWalk", ResetOnSpawn = false, IgnoreGuiInset = true,
    DisplayOrder = 1000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})
if not pcall(function() gui.Parent = gethui() end) or not gui.Parent then
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) or not gui.Parent then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end
end
gui.AncestryChanged:Connect(function()
    if gui.Parent == nil then
        ALIVE = false
        setActive(false)
    end
end)

local frame = new("Frame", {
    Size = UDim2.fromOffset(168, 108),
    Position = UDim2.new(1, -186, 0, 18), -- upper right
    BackgroundColor3 = C.WIN,
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
    Active = true
}, gui)
round(frame, 14)
new("UIGradient", { Rotation = 90, Color = ColorSequence.new(C.TOP, C.WIN) }, frame)

local outline = stroke(frame, C.SEP, 1.3)
local shine = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.SEP),
        ColorSequenceKeypoint.new(0.4, C.SEP),
        ColorSequenceKeypoint.new(0.5, C.ACCENT),
        ColorSequenceKeypoint.new(0.6, C.SEP),
        ColorSequenceKeypoint.new(1, C.SEP)
    })
}, outline)
task.spawn(function()
    while ALIVE do
        shine.Rotation = (shine.Rotation + 2) % 360
        RunService.RenderStepped:Wait()
    end
end)

local scale = new("UIScale", {}, frame)
pcall(function()
    local vp = Workspace.CurrentCamera.ViewportSize
    local mobile = UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled or math.min(vp.X, vp.Y) < 600)
    scale.Scale = (mobile and math.clamp(vp.Y / 520, 0.7, 1) or math.clamp(vp.Y / 960, 0.85, 1.25))
end)

local title = text(frame, "CFRAME WALK", 12, Enum.FontWeight.Bold, C.DIM)
title.Position = UDim2.fromOffset(12, 9)
title.Size = UDim2.new(1, -24, 0, 14)

new("Frame", {
    Position = UDim2.new(0, 10, 0, 28),
    Size = UDim2.new(1, -20, 0, 1),
    BackgroundColor3 = C.SEP,
    BorderSizePixel = 0
}, frame)

local toggle = new("TextButton", {
    Position = UDim2.fromOffset(10, 40),
    Size = UDim2.new(1, -20, 0, 54),
    BackgroundColor3 = C.OFF,
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "OFF",
    TextSize = 17,
    TextColor3 = C.DIM,
    FontFace = mkFont(Enum.FontWeight.Bold)
}, frame)
round(toggle, 10)
local tStroke = stroke(toggle, C.SEP, 1)

local function paint()
    if State.Enabled then
        TweenService:Create(toggle, TweenInfo.new(0.18), {
            BackgroundColor3 = C.ON,
            BackgroundTransparency = 0
        }):Play()
        toggle.Text = "ON"
        toggle.TextColor3 = C.TEXT
        tStroke.Color = C.ACCENT
    else
        TweenService:Create(toggle, TweenInfo.new(0.18), {
            BackgroundColor3 = C.OFF,
            BackgroundTransparency = 0.05
        }):Play()
        toggle.Text = "OFF"
        toggle.TextColor3 = C.DIM
        tStroke.Color = C.SEP
    end
end

toggle.MouseButton1Click:Connect(function()
    setActive(not State.Enabled)
    paint()
end)
paint()

do
    local dragging, startP, startPos
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local m = UserInputService:GetMouseLocation()
            if m.Y - frame.AbsolutePosition.Y < 34 * scale.Scale then
                dragging, startP, startPos = true, i.Position, frame.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = (i.Position - startP) / math.max(scale.Scale, 0.01)
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then
        frame.Visible = not frame.Visible
    end
end)

UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.R then
        setActive(not State.Enabled)
        paint()
    end
end)

end, function(err)
    warn("[CFrame Walk] fatal: " .. tostring(err))
end)