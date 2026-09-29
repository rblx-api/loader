print("deobf by discord.gg/speedhub")
print("deobf by discord.gg/speedhub")
print("deobf by discord.gg/speedhub")
print("deobf by discord.gg/speedhub")
print("deobf by discord.gg/speedhub")

--[[
    Ghoxt Hub
    ─────────────────────────────────────────────────────────────────────────
    Cleaned from a Luarmor/Luraph v15 wrapped build.
    Inf Jump "Hold" logic ported from SpeedHub (PreSimulation + IsKeyDown).
    - ACTIVE / INACTIVE status row above Anti Bat
    - IMG cycles the background, - collapses the panel
    - Inf Jump: HOLD Space / ButtonA to keep rising, release to fall
    - Anti Bat: jitter X/Z velocity while moving
    - Config persisted to ghoxtHub_config.json
]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")
local GuiService       = game:GetService("GuiService")

local localPlayer = Players.LocalPlayer

-- ─── Inf Jump tunables (from SpeedHub Hold logic) ───────────────────────────
local INF_JUMP_BOOST    = 55     -- vertical speed applied when jumping
local INF_JUMP_MIN_Y    = 35     -- boost only if Y velocity is below this
local INF_JUMP_MAX_FALL = -120   -- clamp falling speed

-- ─── Anti Bat tunable ───────────────────────────────────────────────────────
local ANTIBAT_RANGE = 4000

local BACKGROUND_IDS = {
    "79999011724260",
}

local config = {
    AntiBatEnabled = false,
    InfJumpEnabled = false,
    Keybind        = "V",
    BackgroundId   = BACKGROUND_IDS[1],
}

local CONFIG_FILE = "ghoxtHub_config.json"
local bgIndex     = 1

local function saveConfig()
    if writefile then
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(config))
        end)
    end
end

local function loadConfig()
    if isfile and isfile(CONFIG_FILE) then
        local ok, result = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if ok and type(result) == "table" then
            if type(result.Keybind) == "string"         then config.Keybind = result.Keybind end
            if type(result.AntiBatEnabled) == "boolean" then config.AntiBatEnabled = result.AntiBatEnabled end
            if type(result.InfJumpEnabled) == "boolean" then config.InfJumpEnabled = result.InfJumpEnabled end
            if type(result.BackgroundId) == "string"    then config.BackgroundId = result.BackgroundId end
        end
    end
    for i, id in ipairs(BACKGROUND_IDS) do
        if id == config.BackgroundId then bgIndex = i break end
    end
end

-- ─── Anti-Bat ────────────────────────────────────────────────────────────────
local antiBatConn   = nil
local antiBatActive = false

local function startAntiBat()
    if antiBatConn then return end
    antiBatActive = true

    antiBatConn = RunService.Heartbeat:Connect(function()
        if not antiBatActive then return end
        local character = localPlayer.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local v = hrp.Velocity
        hrp.Velocity = Vector3.new(
            math.random(-ANTIBAT_RANGE, ANTIBAT_RANGE),
            v.Y,
            math.random(-ANTIBAT_RANGE, ANTIBAT_RANGE)
        )
        RunService.RenderStepped:Wait()
        if hrp and hrp.Parent then
            hrp.Velocity = v
        end
    end)
end

local function stopAntiBat()
    antiBatActive = false
    if antiBatConn then
        antiBatConn:Disconnect()
        antiBatConn = nil
    end
end

-- ─── Inf Jump (SpeedHub "Hold" logic) ───────────────────────────────────────
-- While the toggle is on, holding Space / ButtonA keeps re-applying upward
-- velocity every PreSimulation tick. Release → normal physics + fall clamp.
local infJumpConn   = nil
local infJumpActive = false

local function applyInfJumpBoost(root)
    if not root then return end
    local velocity = root.AssemblyLinearVelocity
    if velocity.Y < INF_JUMP_MIN_Y then
        root.AssemblyLinearVelocity = Vector3.new(velocity.X, INF_JUMP_BOOST, velocity.Z)
    end
    if velocity.Y < INF_JUMP_MAX_FALL then
        root.AssemblyLinearVelocity = Vector3.new(velocity.X, INF_JUMP_MAX_FALL, velocity.Z)
    end
end

local function startInfJump()
    if infJumpConn then return end
    infJumpActive = true
    config.InfJumpEnabled = true

    infJumpConn = RunService.PreSimulation:Connect(function()
        if not infJumpActive then return end
        local char = localPlayer.Character
        if not char then return end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end

        -- Space OR the humanoid's own Jump flag (mobile / gamepad jump button)
        local held = UserInputService:IsKeyDown(Enum.KeyCode.Space)
            or UserInputService:IsKeyDown(Enum.KeyCode.ButtonA)
            or (hum.Jump == true)

        if held then
            applyInfJumpBoost(root)
        else
            local v = root.AssemblyLinearVelocity
            if v.Y < INF_JUMP_MAX_FALL then
                root.AssemblyLinearVelocity = Vector3.new(v.X, INF_JUMP_MAX_FALL, v.Z)
            end
        end
    end)
end

local function stopInfJump()
    infJumpActive = false
    config.InfJumpEnabled = false
    if infJumpConn then
        infJumpConn:Disconnect()
        infJumpConn = nil
    end
end

-- ─── Theme (Red) ─────────────────────────────────────────────────────────────
local theme = {
    bg        = Color3.fromRGB(0, 0, 0),
    dark      = Color3.fromRGB(20, 8, 8),
    panel     = Color3.fromRGB(30, 12, 12),
    accent    = Color3.fromRGB(220, 40, 40),
    red       = Color3.fromRGB(255, 60, 60),
    green     = Color3.fromRGB(80, 255, 80),
    white     = Color3.fromRGB(255, 255, 255),
    gray      = Color3.fromRGB(200, 180, 180),
    toggleOff = Color3.fromRGB(45, 20, 20),
}

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local panelW   = isMobile and 220 or 280
local panelH   = isMobile and 220 or 240

for _, name in ipairs({ "Ghoxt Hub", "Clean Anti Bat", "Space Anti Bat", "Space X Hook Anti Bat" }) do
    local old = CoreGui:FindFirstChild(name)
    if old then old:Destroy() end
end

-- ─── GUI root ────────────────────────────────────────────────────────────────
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "Ghoxt Hub"
screenGui.ResetOnSpawn   = false
screenGui.DisplayOrder   = 10
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent         = CoreGui

local frame = Instance.new("Frame")
frame.Name             = "Main"
frame.Size             = UDim2.fromOffset(panelW, panelH)
frame.Position         = UDim2.new(0.5, -panelW / 2, 0.5, -panelH / 2)
frame.BackgroundColor3 = theme.bg
frame.BorderSizePixel  = 0
frame.Active           = true
frame.ClipsDescendants = true
frame.Parent           = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

local background = Instance.new("ImageLabel")
background.Name                   = "Background"
background.Size                   = UDim2.new(1, 0, 1, 0)
background.Image                  = "rbxassetid://" .. config.BackgroundId
background.ScaleType              = Enum.ScaleType.Crop
background.BackgroundTransparency = 1
background.ZIndex                 = 0
background.Parent                 = frame
Instance.new("UICorner", background).CornerRadius = UDim.new(0, 16)

local header = Instance.new("Frame")
header.Name                   = "Header"
header.BackgroundTransparency = 1
header.Size                   = UDim2.new(1, 0, 0, 48)
header.Active                 = true
header.ZIndex                 = 5
header.Parent                 = frame

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position               = UDim2.new(0, 16, 0, 6)
title.Size                   = UDim2.new(1, -140, 0, 18)
title.Font                   = Enum.Font.GothamBlack
title.Text                   = "Ghoxt Hub"
title.TextColor3             = theme.white
title.TextSize               = isMobile and 14 or 15
title.TextXAlignment         = Enum.TextXAlignment.Left
title.ZIndex                 = 5
title.Parent                 = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position               = UDim2.new(0, 16, 0, 26)
subtitle.Size                   = UDim2.new(1, -140, 0, 14)
subtitle.Font                   = Enum.Font.Gotham
subtitle.Text                   = "Anti Bat"
subtitle.TextColor3             = theme.gray
subtitle.TextSize               = isMobile and 10 or 11
subtitle.TextXAlignment         = Enum.TextXAlignment.Left
subtitle.ZIndex                 = 5
subtitle.Parent                 = header

-- IMG button (24x24 at 1,-12)
local imgButton = Instance.new("TextButton")
imgButton.Name                   = "IMG"
imgButton.AnchorPoint            = Vector2.new(1, 0.5)
imgButton.Position               = UDim2.new(1, -12, 0.5, 0)
imgButton.Size                   = UDim2.fromOffset(24, 24)
imgButton.BackgroundColor3       = theme.dark
imgButton.BackgroundTransparency = 0.5
imgButton.Text                   = "IMG"
imgButton.TextColor3             = theme.white
imgButton.TextSize               = 10
imgButton.Font                   = Enum.Font.GothamBlack
imgButton.ZIndex                 = 5
imgButton.Parent                 = header
Instance.new("UICorner", imgButton).CornerRadius = UDim.new(0, 6)

imgButton.MouseButton1Click:Connect(function()
    bgIndex += 1
    if bgIndex > #BACKGROUND_IDS then bgIndex = 1 end
    config.BackgroundId = BACKGROUND_IDS[bgIndex]
    background.Image = "rbxassetid://" .. config.BackgroundId
    saveConfig()
end)

-- Collapse "-" button (24x24 at 1,-40)
local collapseButton = Instance.new("TextButton")
collapseButton.Name                   = "Minimize"
collapseButton.AnchorPoint            = Vector2.new(1, 0.5)
collapseButton.Position               = UDim2.new(1, -40, 0.5, 0)
collapseButton.Size                   = UDim2.fromOffset(24, 24)
collapseButton.BackgroundColor3       = theme.dark
collapseButton.BackgroundTransparency = 0.5
collapseButton.Text                   = "-"
collapseButton.TextColor3             = theme.white
collapseButton.TextSize               = 16
collapseButton.Font                   = Enum.Font.GothamBlack
collapseButton.ZIndex                 = 5
collapseButton.Parent                 = header
Instance.new("UICorner", collapseButton).CornerRadius = UDim.new(0, 6)

local content = Instance.new("Frame")
content.Name                   = "Content"
content.BackgroundTransparency = 1
content.Position               = UDim2.new(0, 12, 0, 48)
content.Size                   = UDim2.new(1, -24, 1, -48)
content.ClipsDescendants       = true
content.ZIndex                 = 2
content.Parent                 = frame

local collapsed = false
collapseButton.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    if collapsed then
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            { Size = UDim2.fromOffset(panelW, 48) }):Play()
        content.Visible = false
        collapseButton.Text = "+"
    else
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            { Size = UDim2.fromOffset(panelW, panelH) }):Play()
        content.Visible = true
        collapseButton.Text = "-"
    end
end)

-- ─── Status row (ACTIVE / INACTIVE) ────────────────────────────────────────
local statusRow = Instance.new("Frame")
statusRow.Position               = UDim2.new(0, 12, 0, 8)
statusRow.Size                   = UDim2.new(1, -24, 0, isMobile and 28 or 32)
statusRow.BackgroundColor3       = theme.dark
statusRow.BackgroundTransparency = 0.5
statusRow.ZIndex                 = 4
statusRow.Parent                 = content
Instance.new("UICorner", statusRow).CornerRadius = UDim.new(0, 12)

local statusDot = Instance.new("Frame")
statusDot.Position         = UDim2.new(0, 14, 0.5, -4)
statusDot.Size             = UDim2.fromOffset(8, 8)
statusDot.BackgroundColor3 = theme.red
statusDot.BorderSizePixel  = 0
statusDot.ZIndex           = 6
statusDot.Parent           = statusRow
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new("TextLabel")
statusLabel.Position               = UDim2.new(0, 30, 0, 0)
statusLabel.Size                   = UDim2.new(0, 100, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text                   = "Status"
statusLabel.TextColor3             = theme.white
statusLabel.TextSize               = isMobile and 11 or 13
statusLabel.Font                   = Enum.Font.GothamBlack
statusLabel.TextXAlignment         = Enum.TextXAlignment.Left
statusLabel.ZIndex                 = 6
statusLabel.Parent                 = statusRow

local statusValue = Instance.new("TextLabel")
statusValue.Position               = UDim2.new(1, -80, 0, 0)
statusValue.Size                   = UDim2.new(0, 60, 1, 0)
statusValue.BackgroundTransparency = 1
statusValue.Text                   = "INACTIVE"
statusValue.TextColor3             = theme.red
statusValue.TextSize               = isMobile and 12 or 14
statusValue.Font                   = Enum.Font.GothamBlack
statusValue.TextXAlignment         = Enum.TextXAlignment.Right
statusValue.ZIndex                 = 6
statusValue.Parent                 = statusRow

local function refreshStatus()
    local active = antiBatActive or infJumpActive
    statusValue.Text           = active and "ACTIVE" or "INACTIVE"
    statusValue.TextColor3     = active and theme.green or theme.red
    statusDot.BackgroundColor3 = active and theme.green or theme.red
end

-- ─── Toggle rows ────────────────────────────────────────────────────────────
local antiBatAnimate, infJumpAnimate

local function makeToggle(parent, y, label, initialState, onToggle)
    local row = Instance.new("Frame")
    row.Position               = UDim2.new(0, 12, 0, y)
    row.Size                   = UDim2.new(1, -24, 0, isMobile and 38 or 50)
    row.BackgroundColor3       = theme.dark
    row.BackgroundTransparency = 0.5
    row.ZIndex                 = 4
    row.Parent                 = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)

    local text = Instance.new("TextLabel")
    text.Position               = UDim2.new(0, 14, 0.5, -9)
    text.Size                   = UDim2.new(0, 150, 0, 18)
    text.BackgroundTransparency = 1
    text.Text                   = label
    text.TextColor3             = theme.white
    text.TextSize               = isMobile and 12 or 14
    text.Font                   = Enum.Font.GothamBlack
    text.TextXAlignment         = Enum.TextXAlignment.Left
    text.ZIndex                 = 6
    text.Parent                 = row

    local track = Instance.new("Frame")
    track.Position            = UDim2.new(1, -58, 0.5, -11)
    track.Size                = UDim2.fromOffset(44, 22)
    track.BackgroundColor3    = initialState and theme.accent or theme.toggleOff
    track.BorderSizePixel     = 0
    track.ZIndex              = 6
    track.Parent              = row
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Position         = initialState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.Size             = UDim2.fromOffset(16, 16)
    knob.BackgroundColor3 = initialState and theme.bg or theme.white
    knob.BorderSizePixel  = 0
    knob.ZIndex           = 7
    knob.Parent           = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local hit = Instance.new("TextButton")
    hit.Position               = UDim2.new(1, -65, 0, 0)
    hit.Size                   = UDim2.fromOffset(50, isMobile and 38 or 50)
    hit.BackgroundTransparency = 1
    hit.Text                   = ""
    hit.ZIndex                 = 10
    hit.Parent                 = row

    local function animate(state)
        local pos     = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        local knobBg  = state and theme.bg    or theme.white
        local trackBg = state and theme.accent or theme.toggleOff
        TweenService:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Position = pos, BackgroundColor3 = knobBg }):Play()
        TweenService:Create(track, TweenInfo.new(0.16), { BackgroundColor3 = trackBg }):Play()
    end

    hit.MouseButton1Click:Connect(function()
        onToggle()
        if label == "Anti Bat" then animate(antiBatActive) else animate(infJumpActive) end
        refreshStatus()
        saveConfig()
    end)

    return animate
end

antiBatAnimate = makeToggle(content, isMobile and 44 or 48, "Anti Bat", config.AntiBatEnabled, function()
    if not antiBatActive then
        startAntiBat()
        config.AntiBatEnabled = true
    else
        stopAntiBat()
        config.AntiBatEnabled = false
    end
end)

infJumpAnimate = makeToggle(content, isMobile and 88 or 106, "Inf Jump", config.InfJumpEnabled, function()
    if not infJumpActive then
        startInfJump()
        infJumpAnimate(true)
    else
        stopInfJump()
        infJumpAnimate(false)
    end
end)

-- ─── Keybind row ────────────────────────────────────────────────────────────
local keybindRow = Instance.new("Frame")
keybindRow.Position               = UDim2.new(0, 12, 0, isMobile and 132 or 164)
keybindRow.Size                   = UDim2.new(1, -40, 0, isMobile and 28 or 32)
keybindRow.BackgroundColor3       = theme.dark
keybindRow.BackgroundTransparency = 0.5
keybindRow.ZIndex                 = 4
keybindRow.Parent                 = content
Instance.new("UICorner", keybindRow).CornerRadius = UDim.new(0, 12)

local keybindLabel = Instance.new("TextLabel")
keybindLabel.Position               = UDim2.new(0, 14, 0, 0)
keybindLabel.Size                   = UDim2.new(0, 100, 1, 0)
keybindLabel.BackgroundTransparency = 1
keybindLabel.Text                   = "Keybind"
keybindLabel.TextColor3             = theme.white
keybindLabel.TextSize               = isMobile and 11 or 13
keybindLabel.Font                   = Enum.Font.GothamBlack
keybindLabel.TextXAlignment         = Enum.TextXAlignment.Left
keybindLabel.ZIndex                 = 6
keybindLabel.Parent                 = keybindRow

local keybindButton = Instance.new("TextButton")
keybindButton.AnchorPoint            = Vector2.new(1, 0.5)
keybindButton.Position               = UDim2.new(1, -12, 0.5, 0)
keybindButton.Size                   = UDim2.fromOffset(52, 20)
keybindButton.BackgroundColor3       = Color3.fromRGB(50, 15, 15)
keybindButton.BackgroundTransparency = 0.5
keybindButton.Text                   = config.Keybind
keybindButton.TextColor3             = theme.white
keybindButton.TextSize               = isMobile and 10 or 12
keybindButton.Font                   = Enum.Font.GothamBlack
keybindButton.ZIndex                 = 6
keybindButton.Parent                 = keybindRow
Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 6)

local listening        = false
local listenConnection = nil

keybindButton.MouseButton1Click:Connect(function()
    if listening then
        if listenConnection then listenConnection:Disconnect() listenConnection = nil end
        listening = false
        keybindButton.Text = config.Keybind
        keybindButton.TextColor3 = theme.white
        return
    end
    listening = true
    keybindButton.Text = "..."
    keybindButton.TextColor3 = theme.red
    listenConnection = UserInputService.InputBegan:Connect(function(input)
        if not listening then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode == Enum.KeyCode.Escape then
            listening = false
            keybindButton.Text = config.Keybind
            keybindButton.TextColor3 = theme.white
            if listenConnection then listenConnection:Disconnect() listenConnection = nil end
            return
        end
        config.Keybind = input.KeyCode.Name
        keybindButton.Text = config.Keybind
        keybindButton.TextColor3 = theme.white
        listening = false
        if listenConnection then listenConnection:Disconnect() listenConnection = nil end
        saveConfig()
    end)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if input.KeyCode.Name ~= config.Keybind then return end
    if not antiBatActive then
        startAntiBat()
        config.AntiBatEnabled = true
    else
        stopAntiBat()
        config.AntiBatEnabled = false
    end
    antiBatAnimate(antiBatActive)
    refreshStatus()
    saveConfig()
end)

-- ─── Dragging ───────────────────────────────────────────────────────────────
local dragging   = false
local dragStart  = nil
local startPos   = nil
local touchIndex = nil

local function clampToViewport(pos)
    local cam = workspace.CurrentCamera
    local viewport = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local inset = GuiService:GetGuiInset()
    local x = math.clamp(pos.X.Offset + pos.X.Scale * viewport.X, 0,
        math.max(0, viewport.X - frame.AbsoluteSize.X))
    local y = math.clamp(pos.Y.Offset + pos.Y.Scale * (viewport.Y - inset.Y), 0,
        math.max(0, viewport.Y - inset.Y - frame.AbsoluteSize.Y))
    return UDim2.fromOffset(x, y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging   = true
        dragStart  = input.Position
        startPos   = frame.Position
        touchIndex = input.UserInputType == Enum.UserInputType.Touch and input.UserInputIndex or nil
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    if isTouch or input.UserInputType == Enum.UserInputType.MouseMovement then
        if isTouch and touchIndex and input.UserInputIndex ~= touchIndex then return end
        local delta = input.Position - dragStart
        frame.Position = clampToViewport(UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if not dragging then return end
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    if isTouch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if isTouch and touchIndex and input.UserInputIndex ~= touchIndex then return end
        dragging   = false
        touchIndex = nil
    end
end)

-- ─── Init ───────────────────────────────────────────────────────────────────
loadConfig()

if config.AntiBatEnabled then
    startAntiBat()
    antiBatAnimate(true)
end
if config.InfJumpEnabled then
    startInfJump()
    infJumpAnimate(true)
end
refreshStatus()

frame.Size = UDim2.fromOffset(0, 0)
TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    { Size = UDim2.fromOffset(panelW, panelH) }):Play()

print("[Ghoxt Hub] loaded - Inf Jump Hold ported, no phone-home")