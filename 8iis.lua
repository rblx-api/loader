-- Infinity Jump - małe GUI (styl Cursor Hub)
-- Działa na PC i mobile (hold Space / przycisk)

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")

local LocalPlayer      = Players.LocalPlayer
local isMobile         = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- ============================================================
-- KONFIGURACJA
-- ============================================================
local E = {
    InfinityJump = false,
}

local V = {
    INFINITE_JUMP_POWER = 50,
    CLICK_JUMP_POWER    = 55,
    GuiX                = 30,
    GuiY                = 200,
}

-- ============================================================
-- HOOK META (spoof velocity dla anty-cheatów)
-- ============================================================
local _velHookInit = false
local oldSpeedIndex, oldSpeedNewIndex
local spoofedVelocity = Vector3.zero

local function initVelocityHooks()
    if _velHookInit then return end
    _velHookInit = true
    pcall(function()
        if not (getrawmetatable and setreadonly and newcclosure and checkcaller) then return end
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        oldSpeedIndex = mt.__index
        mt.__index = newcclosure(function(self, key)
            if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart"
                   and LocalPlayer.Character and self:IsDescendantOf(LocalPlayer.Character) then
                    return spoofedVelocity
                end
            end
            return oldSpeedIndex(self, key)
        end)
        oldSpeedNewIndex = mt.__newindex
        mt.__newindex = newcclosure(function(self, key, value)
            if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart"
                   and LocalPlayer.Character and self:IsDescendantOf(LocalPlayer.Character) then
                    spoofedVelocity = value
                    return
                end
            end
            return oldSpeedNewIndex(self, key, value)
        end)
        setreadonly(mt, true)
    end)
end

local function getSpeedRealVelocity(root)
    if oldSpeedIndex then
        return oldSpeedIndex(root, "AssemblyLinearVelocity")
    end
    return root.AssemblyLinearVelocity
end

initVelocityHooks()

-- ============================================================
-- INFINITY JUMP LOGIC
-- ============================================================
local holdJumpPressed = false
local holdJumpActive  = false

local function applyInfJumpBoost(power)
    if not E.InfinityJump then return end
    local char = LocalPlayer.Character
    if not char then return end
    local h = char:FindFirstChild("HumanoidRootPart")
    if not h then return end
    local realVel = getSpeedRealVelocity(h)
    local nv = Vector3.new(realVel.X, power, realVel.Z)
    if oldSpeedNewIndex then
        oldSpeedNewIndex(h, "Velocity", nv)
    else
        h.Velocity = nv
    end
end

-- JumpRequest (tap)
UserInputService.JumpRequest:Connect(function()
    if E.InfinityJump then
        applyInfJumpBoost(V.CLICK_JUMP_POWER)
    end
end)

-- Hold (Space / ButtonA)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
        holdJumpPressed = true
        task.delay(0.12, function()
            if holdJumpPressed then
                holdJumpActive = true
                applyInfJumpBoost(V.INFINITE_JUMP_POWER)
            end
        end)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
        holdJumpPressed = false
        holdJumpActive = false
    end
end)

-- Heartbeat: hold mode
RunService.Heartbeat:Connect(function()
    if not E.InfinityJump then return end
    if holdJumpActive then
        applyInfJumpBoost(V.INFINITE_JUMP_POWER)
    end
    spoofedVelocity = Vector3.zero
end)

-- ============================================================
-- MAŁE GUI (przeciągalne, styl Cursor Hub)
-- ============================================================
local function mkCorner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end
local function mkStroke(p, col, thick, tr)
    local s = Instance.new("UIStroke", p)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = col or Color3.fromRGB(90, 90, 105)
    s.Thickness = thick or 1
    s.Transparency = tr or 0.35
    return s
end
local function tw(obj, props)
    TweenService:Create(obj, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local C_ROW    = Color3.fromRGB(6, 6, 9)
local C_WHITE  = Color3.fromRGB(255, 255, 255)
local C_DIM    = Color3.fromRGB(180, 180, 190)
local C_TOGGLE = Color3.fromRGB(18, 18, 26)
local C_KNOB   = Color3.fromRGB(238, 238, 245)
local C_STROKE = Color3.fromRGB(60, 60, 72)

local SG = Instance.new("ScreenGui")
SG.Name = "CursorHub_InfJump"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.DisplayOrder = 999
pcall(function() SG:SetAttribute("_chv4", true) end)
if not pcall(function() SG.Parent = CoreGui end) then
    SG.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local W, H = 200, 56
local Main = Instance.new("Frame", SG)
Main.Name = "InfJumpGui"
Main.Size = UDim2.new(0, W, 0, H)
Main.Position = UDim2.new(0, V.GuiX, 0, V.GuiY)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
mkCorner(Main, 12)
mkStroke(Main, C_WHITE, 1.1, 0.35)

-- Gradient w tle
local bgGrad = Instance.new("UIGradient", Main)
bgGrad.Color = ColorSequence.new(Color3.fromRGB(20, 20, 32), Color3.fromRGB(6, 6, 10))
bgGrad.Rotation = 110

-- Tytuł
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -16, 0, 22)
Title.Position = UDim2.new(0, 12, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "INFINITY JUMP"
Title.TextColor3 = C_WHITE
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Title.TextStrokeTransparency = 0.4

-- Toggle row
local Row = Instance.new("Frame", Main)
Row.Size = UDim2.new(1, -16, 0, 22)
Row.Position = UDim2.new(0, 8, 0, 28)
Row.BackgroundTransparency = 1

local StatusLbl = Instance.new("TextLabel", Row)
StatusLbl.Size = UDim2.new(0.6, 0, 1, 0)
StatusLbl.Position = UDim2.new(0, 4, 0, 0)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "OFF"
StatusLbl.TextColor3 = C_DIM
StatusLbl.Font = Enum.Font.GothamBold
StatusLbl.TextSize = 11
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left

local pillW, pillH, knobSz = 34, 18, 13
local Pill = Instance.new("Frame", Row)
Pill.Size = UDim2.new(0, pillW, 0, pillH)
Pill.Position = UDim2.new(1, -pillW - 4, 0.5, -pillH / 2)
Pill.BackgroundColor3 = C_TOGGLE
Pill.BackgroundTransparency = 0.6
Pill.BorderSizePixel = 0
mkCorner(Pill, 9)
local PillStroke = Instance.new("UIStroke", Pill)
PillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
PillStroke.Color = C_STROKE
PillStroke.Thickness = 1
PillStroke.Transparency = 0.45

local Knob = Instance.new("Frame", Pill)
Knob.Size = UDim2.new(0, knobSz, 0, knobSz)
Knob.Position = UDim2.new(0, 2, 0.5, -knobSz / 2)
Knob.BackgroundColor3 = C_KNOB
Knob.BorderSizePixel = 0
mkCorner(Knob, 999)

local function updateVisual(state)
    tw(Pill, {
        BackgroundTransparency = state and 0 or 0.6,
        BackgroundColor3 = state and C_WHITE or C_TOGGLE,
    })
    tw(PillStroke, {
        Transparency = state and 0.05 or 0.45,
        Color = state and C_WHITE or C_STROKE,
    })
    tw(Knob, {
        Position = state and UDim2.new(1, -knobSz - 2, 0.5, -knobSz / 2)
                      or UDim2.new(0, 2, 0.5, -knobSz / 2),
        BackgroundColor3 = state and Color3.fromRGB(6, 6, 10) or C_KNOB,
    })
    StatusLbl.Text = state and "ON" or "OFF"
    StatusLbl.TextColor3 = state and C_WHITE or C_DIM
end

updateVisual(E.InfinityJump)

local PillBtn = Instance.new("TextButton", Pill)
PillBtn.Size = UDim2.new(2, 0, 2, 0)
PillBtn.Position = UDim2.new(-0.5, 0, -0.5, 0)
PillBtn.BackgroundTransparency = 1
PillBtn.Text = ""
PillBtn.ZIndex = 8
PillBtn.MouseButton1Click:Connect(function()
    E.InfinityJump = not E.InfinityJump
    updateVisual(E.InfinityJump)
end)

-- ============================================================
-- DRAG
-- ============================================================
local dragging, dragStart, startPos = false, nil, nil
Title.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inp.Position
        startPos = Main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                dragging = false
                V.GuiX = Main.Position.X.Offset
                V.GuiY = Main.Position.Y.Offset
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if dragging and dragStart and startPos
    and (inp.UserInputType == Enum.UserInputType.MouseMovement
      or inp.UserInputType == Enum.UserInputType.Touch) then
        local d = inp.Position - dragStart
        Main.Position = UDim2.new(0, startPos.X.Offset + d.X, 0, startPos.Y.Offset + d.Y)
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        V.GuiX = Main.Position.X.Offset
        V.GuiY = Main.Position.Y.Offset
    end
end)

print("[Infinity Jump] Załadowano. Przeciągnij nagłówek aby przesunąć GUI.")