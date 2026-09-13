--[[
    Nightmare anti anti desync â€“ Freeze other players
    Singleâ€‘button toggle, no spam, no extra fluff.
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Global state (persist across script reloads)
connections = connections or {}
connections.FreezePlayer = connections.FreezePlayer or {}
featureStates = featureStates or {}
featureStates.FreezePlayer = false

-- ============================================================
--  FEATURE LOGIC â€“ Freeze other players
-- ============================================================
local function toggleFreeze(enabled)
    if enabled then
        featureStates.FreezePlayer = true

        local conn = RunService.Stepped:Connect(function()
            if not featureStates.FreezePlayer then
                conn:Disconnect()
                return
            end

            local myChar = LocalPlayer.Character
            if not myChar then return end

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local char = plr.Character
                    if char then
                        -- Freeze humanoid
                        local hum = char:FindFirstChildWhichIsA("Humanoid")
                        if hum then
                            hum.WalkSpeed = 0
                            hum.JumpPower = 0
                            hum.AutoRotate = false
                        end

                        -- Disable collisions on all parts
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
        end)

        table.insert(connections.FreezePlayer, conn)

    else
        featureStates.FreezePlayer = false

        -- Clean up connections
        for _, conn in ipairs(connections.FreezePlayer) do
            if conn then
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                elseif typeof(conn) == "thread" then
                    task.cancel(conn)
                end
            end
        end
        connections.FreezePlayer = {}

        -- Restore other players to default
        local DEFAULT_WALK = 16
        local DEFAULT_JUMP = 50
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local char = plr.Character
                if char then
                    local hum = char:FindFirstChildWhichIsA("Humanoid")
                    if hum then
                        hum.WalkSpeed = DEFAULT_WALK
                        hum.JumpPower = DEFAULT_JUMP
                        hum.AutoRotate = true
                    end
                end
            end
        end
    end
end

-- ============================================================
--  GUI BUILDERS
-- ============================================================
local function getGuiParent()
    if typeof(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then return result end
    end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then return core end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function newInstance(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function addCorner(obj, radius)
    return newInstance("UICorner", { CornerRadius = UDim.new(0, radius) }, obj)
end

local function addStroke(obj, color, thickness, transparency)
    return newInstance("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, obj)
end

-- ============================================================
--  BUILD THE GUI
-- ============================================================
local parent = getGuiParent()
local existing = parent:FindFirstChild("NightmareAntiAntiDesyncGui")
if existing then existing:Destroy() end

local gui = newInstance("ScreenGui", {
    Name = "NightmareAntiAntiDesyncGui",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

-- Protect GUI (if executor supports it)
if type(syn) == "table" and type(syn.protect_gui) == "function" then
    pcall(syn.protect_gui, gui)
elseif typeof(protectgui) == "function" then
    pcall(protectgui, gui)
end

pcall(function() gui.Parent = parent end)
if not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Main container
local frame = newInstance("Frame", {
    Size = UDim2.fromOffset(520, 285),
    Position = UDim2.new(0.5, -260, 0.5, -142),
    BackgroundColor3 = Color3.fromRGB(8, 8, 10),
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Active = true,
    ZIndex = 40,
}, gui)
addCorner(frame, 16)
addStroke(frame, Color3.fromRGB(255, 0, 0), 2)

-- Inner holder
local holder = newInstance("Frame", {
    Size = UDim2.new(1, -8, 1, -8),
    Position = UDim2.fromOffset(4, 4),
    BackgroundColor3 = Color3.fromRGB(13, 13, 17),
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 40,
}, frame)
addCorner(holder, 13)

-- Red top accent
newInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 4),
    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
    BorderSizePixel = 0,
    ZIndex = 44,
}, holder)

-- Header
local header = newInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 78),
    Position = UDim2.fromOffset(0, 4),
    BackgroundColor3 = Color3.fromRGB(15, 15, 19),
    BorderSizePixel = 0,
    ZIndex = 42,
}, holder)

newInstance("TextLabel", {
    Size = UDim2.new(1, -190, 1, 0),
    Position = UDim2.fromOffset(24, 0),
    BackgroundTransparency = 1,
    Text = "Nightmare anti anti desync",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 43,
}, header)

-- Header control buttons
local minusBtn = newInstance("TextButton", {
    Size = UDim2.fromOffset(62, 54),
    Position = UDim2.new(1, -190, 0, 12),
    BackgroundColor3 = Color3.fromRGB(17, 19, 25),
    BorderSizePixel = 0,
    Text = "−",
    TextColor3 = Color3.fromRGB(225, 225, 230),
    Font = Enum.Font.Gotham,
    TextSize = 24,
    AutoButtonColor = false,
    ZIndex = 44,
}, header)
addCorner(minusBtn, 18)
addStroke(minusBtn, Color3.fromRGB(45, 50, 62), 1.5)

local plusBtn = newInstance("TextButton", {
    Size = UDim2.fromOffset(62, 54),
    Position = UDim2.new(1, -120, 0, 12),
    BackgroundColor3 = Color3.fromRGB(17, 19, 25),
    BorderSizePixel = 0,
    Text = "+",
    TextColor3 = Color3.fromRGB(225, 225, 230),
    Font = Enum.Font.Gotham,
    TextSize = 24,
    AutoButtonColor = false,
    ZIndex = 44,
}, header)
addCorner(plusBtn, 18)
addStroke(plusBtn, Color3.fromRGB(45, 50, 62), 1.5)

local closeBtn = newInstance("TextButton", {
    Size = UDim2.fromOffset(62, 54),
    Position = UDim2.new(1, -50, 0, 12),
    BackgroundColor3 = Color3.fromRGB(17, 19, 25),
    BorderSizePixel = 0,
    Text = "−",
    TextColor3 = Color3.fromRGB(225, 225, 230),
    Font = Enum.Font.Gotham,
    TextSize = 24,
    AutoButtonColor = false,
    ZIndex = 44,
}, header)
addCorner(closeBtn, 18)
addStroke(closeBtn, Color3.fromRGB(45, 50, 62), 1.5)

-- Main toggle row
local toggleRow = newInstance("Frame", {
    Size = UDim2.new(1, -42, 0, 82),
    Position = UDim2.fromOffset(21, 94),
    BackgroundColor3 = Color3.fromRGB(17, 17, 22),
    BorderSizePixel = 0,
    ZIndex = 42,
}, holder)
addCorner(toggleRow, 18)

newInstance("TextLabel", {
    Size = UDim2.new(1, -180, 1, 0),
    Position = UDim2.fromOffset(24, 0),
    BackgroundTransparency = 1,
    Text = "Anti Anti Desync",
    TextColor3 = Color3.fromRGB(235, 235, 240),
    Font = Enum.Font.Gotham,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 43,
}, toggleRow)

-- Toggle switch
local toggleBtn = newInstance("TextButton", {
    Size = UDim2.fromOffset(92, 52),
    Position = UDim2.new(1, -112, 0.5, -26),
    BackgroundColor3 = Color3.fromRGB(35, 35, 43),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "",
    ZIndex = 43,
}, toggleRow)
addCorner(toggleBtn, 26)
addStroke(toggleBtn, Color3.fromRGB(58, 62, 75), 1.5)

local toggleKnob = newInstance("Frame", {
    Size = UDim2.fromOffset(38, 38),
    Position = UDim2.fromOffset(7, 7),
    BackgroundColor3 = Color3.fromRGB(220, 220, 230),
    BorderSizePixel = 0,
    ZIndex = 44,
}, toggleBtn)
addCorner(toggleKnob, 19)

-- Keybind row
local keyRow = newInstance("Frame", {
    Size = UDim2.new(1, -42, 0, 82),
    Position = UDim2.fromOffset(21, 188),
    BackgroundColor3 = Color3.fromRGB(17, 17, 22),
    BorderSizePixel = 0,
    ZIndex = 42,
}, holder)
addCorner(keyRow, 18)

newInstance("TextLabel", {
    Size = UDim2.new(1, -190, 1, 0),
    Position = UDim2.fromOffset(24, 0),
    BackgroundTransparency = 1,
    Text = "Keybind",
    TextColor3 = Color3.fromRGB(205, 205, 212),
    Font = Enum.Font.Gotham,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 43,
}, keyRow)

local keyBtn = newInstance("TextButton", {
    Size = UDim2.fromOffset(130, 58),
    Position = UDim2.new(1, -148, 0.5, -29),
    BackgroundColor3 = Color3.fromRGB(9, 9, 12),
    BorderSizePixel = 0,
    Text = "B",
    TextColor3 = Color3.fromRGB(240, 240, 245),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    AutoButtonColor = false,
    ZIndex = 43,
}, keyRow)
addCorner(keyBtn, 17)
addStroke(keyBtn, Color3.fromRGB(55, 60, 72), 1.5)

-- ============================================================
--  STATE & BUTTON BEHAVIOUR
-- ============================================================
local active = false

local function setActive(state)
    active = state
    if state then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        toggleKnob.Position = UDim2.new(1, -45, 0, 7)
        toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleFreeze(true)
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
        toggleKnob.Position = UDim2.fromOffset(7, 7)
        toggleKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
        toggleFreeze(false)
    end
end

toggleBtn.Activated:Connect(function()
    setActive(not active)
end)

closeBtn.Activated:Connect(function()
    frame.Visible = false
end)

plusBtn.Activated:Connect(function()
    frame.Size = UDim2.fromOffset(560, 305)
end)

minusBtn.Activated:Connect(function()
    frame.Size = UDim2.fromOffset(520, 285)
end)

setActive(false)

-- ============================================================
--  DRAGGING (move the window)
-- ============================================================
local dragging = false
local dragStart, startPos

local function onInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end

frame.InputBegan:Connect(onInputBegan)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                     input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Start with the feature off
setActive(false)

print("Nightmare anti anti desync loaded â€“ click the button to freeze other players.")