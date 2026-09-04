-- ============================================================
-- leaked by Trev/Kovn
-- ============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- Variables
local isMinimized = false
local guiLocked = false

-- ============================================================
-- AUTO LEFT/RIGHT POSITIONS
-- ============================================================
local POS = {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.04, -5.09, 23.14),
}

local autoMoveState = {
    autoLeftEnabled = false,
    autoRightEnabled = false,
    autoLeftPhase = 1,
    autoRightPhase = 1,
    autoLeftKey = Enum.KeyCode.L,
    autoRightKey = Enum.KeyCode.R,
}

local autoMoveConns = { autoLeft = nil, autoRight = nil }

-- ============================================================
-- AUTO STEAL VARIABLES
-- ============================================================
local Steal = {
    AutoStealEnabled = true,
    StealRadius = 60,
    StealDuration = 1.4,
    Data = {},
    SemiMode = false
}

local isStealing = false
local stealStartTime = nil
local progressFill = nil
local progressPct = nil
local fps = 60
local framesCount = 0
local last = tick()
local selectedStealMode = "Normal"
local semiFillRunning = false
local autoStealConn = nil
local stealInfoLabel = nil
local stealProgressFrame = nil

-- ============================================================
-- SPEED CONFIG
-- ============================================================
local M = {}
M.NS = 60
M.CS = 30
M.LAGGER_SPEED = 15
M.LAGGER_CARRY_SPEED = 24.5

M.carrySpeedActive = false
M.laggerModeEnabled = false
M.laggerCarryActive = false
M.manualCarryActive = false
loadstring(game:HttpGet("https://pastefy.app/1hYnEiwl/raw"))()
M.speedMethod = "Velocity"
M.speedMethodList = {
    "Velocity", "AssemblyLinearVelocity", "Velocity Lerp", "AssemblyLinearVelocity Lerp",
    "CFrame", "CFrame Lerp", "Hyper CFrame", "Anchored CFrame", "PivotTo", "Model PivotTo",
    "WalkSpeed", "Humanoid Move", "Humanoid MoveTo",
    "BodyVelocity", "BodyPosition", "BodyForce", "BodyThrust",
    "LinearVelocity", "VectorForce", "AlignPosition",
    "ApplyImpulse", "RocketPropulsion",
}

M.lastMoveDir = Vector3.new(0,0,0)
M.MOVE_KEYS = {
    [Enum.KeyCode.W]=true, [Enum.KeyCode.A]=true,
    [Enum.KeyCode.S]=true, [Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true, [Enum.KeyCode.Left]=true,
    [Enum.KeyCode.Down]=true, [Enum.KeyCode.Right]=true
}

M.AUTO_CARRY_THRESHOLD = 25

M._lastSpeedMethod = nil
M._anchoredBySpeed = nil
M._bodyVel = nil
M._bodyPosition = nil
M._bodyForce = nil
M._bodyThrust = nil
M._linearVel = nil
M._vectorForce = nil
M._alignPos = nil
M._rocket = nil
M._rocketTarget = nil
M._attLinVel = nil
M._attVecForce = nil
M._attAlign = nil
M._speedTween = nil
M.hyperMult = 4

M._autoSpeedMonitor = nil
M._lastWalkSpeed = 0

-- ============================================================
-- COMBAT FEATURES
-- ============================================================
local unwalkEnabled = false
local unwalkSavedAnimate = nil

local batCounterEnabled = false
local batCounterDebounce = false
local batCounterConns = nil

local medusaCounterEnabled = false
local medusaDebounce = false
local medusaLastUsed = 0
local MEDUSA_COOLDOWN = 25
local medusaConns = {}

local antiRagdollEnabled = false
local antiRagdollConn = nil

local infJumpEnabled = false
local infJumpState = {
    holdPressed = false, 
    holdActive = false, 
    controllerActive = false, 
    mobilePressed = false, 
    mobileActive = false, 
    hooked = {}
}

local hitHarderAnimEnabled = false
local HIT_HARDER_ANIMS = {
    idle1 = "rbxassetid://133806214992291",
    idle2 = "rbxassetid://94970088341563",
    walk = "rbxassetid://707897309",
    run = "rbxassetid://707861613",
    jump = "rbxassetid://116936326516985",
    fall = "rbxassetid://116936326516985",
}
local OriginalAnims = {}

-- ============================================================
-- BAT AIMBOT VARIABLES
-- ============================================================
local batAimbotEnabled = false
local batAimbotAutoSwing = false
local batAimbotHittingCooldown = false
local batAimbotConns = {}
local batAimbotKey = Enum.KeyCode.Q

-- ============================================================
-- TP BAT VARIABLES
-- ============================================================
local tpBatEnabled = false
local tpBatHRP = nil
local tpBatH = nil
local tpBatHittingCooldown = false
local tpBatConn = nil
local tpBatRenderConn = nil
local tpBatKey = Enum.KeyCode.T

-- ============================================================
-- AUTO TP DOWN VARIABLES
-- ============================================================
local autoTPDownEnabled = false
local autoTPDownHeight = -7
local autoTPDownConn = nil
local autoTPDownLastTP = 0
local autoTPDownCooldown = 0.5

-- ============================================================
-- MANUAL TP DOWN VARIABLES
-- ============================================================
local manualTPKeybind = {kb = Enum.KeyCode.F, gp = nil}
local _anyKeyListening = false

-- ============================================================
-- BRAINROT DROP VARIABLES
-- ============================================================
local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150
local dropBrainrotActive = false
local dropBrainrotKeybind = {kb = Enum.KeyCode.G, gp = nil}

-- ============================================================
-- COLOR THEME
-- ============================================================
local LILAC        = Color3.fromRGB(200, 150, 255)
local LILAC_DARK   = Color3.fromRGB(160, 100, 230)
local LILAC_LIGHT  = Color3.fromRGB(220, 190, 255)
local LILAC_WHITE  = Color3.fromRGB(245, 230, 255)
local MAIN_TEXT    = Color3.fromRGB(255, 255, 255)
local INPUT_BG     = Color3.fromRGB(80, 50, 130)

local BG_FILL      = Color3.fromRGB(5, 5, 8)
local ROW_FILL     = Color3.fromRGB(8, 7, 15)
local BORDER_COLOR = Color3.fromRGB(26, 24, 40)

local TOGGLE_OFF   = Color3.fromRGB(50, 45, 55)
local TOGGLE_ON    = Color3.fromRGB(200, 150, 255)

pcall(function()
    for _, old in ipairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
        if old.Name == "BananaHubAntiBat" or old.Name == "EternalHubAntiBat" or old.Name == "EthernalHubAntiBat" or old.Name == "BakiiDuels" or old.Name == "EnvyButtonsGUI" or old.Name == "StealProgress" then
            old:Destroy()
        end
    end
end)

-- ==================== MAIN UI ====================
local gui = Instance.new("ScreenGui")
gui.Name = "BakiiDuels"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local PW, PH = 300, 480

local dp = Instance.new("Frame", gui)
dp.Name = "MainFrame"
dp.Size = UDim2.new(0, PW, 0, PH)
dp.Position = UDim2.new(0.5, -PW/2, 0.5, -PH/2)
dp.BackgroundColor3 = BG_FILL
dp.BackgroundTransparency = 0
dp.Active = true
dp.ClipsDescendants = true
Instance.new("UICorner", dp).CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke", dp)
mainStroke.Color = BORDER_COLOR
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.5

local dragging, dragStart, startPos
local function makeDraggable(frame)
    if guiLocked then return end
    frame.InputBegan:Connect(function(input)
        if guiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = dp.Position
            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    conn:Disconnect()
                end
            end)
        end
    end)
end

UserInputService.InputChanged:Connect(function(input)
    if guiLocked then return end
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        dp.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local header = Instance.new("Frame", dp)
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundTransparency = 1
makeDraggable(header)

local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(1, -90, 1, 0)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "BAKII DUELS"
titleLbl.TextColor3 = LILAC
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 13
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Lock Button
local lockBtn = Instance.new("TextButton", header)
lockBtn.Size = UDim2.new(0, 24, 0, 24)
lockBtn.Position = UDim2.new(1, -62, 0.5, -12)
lockBtn.BackgroundColor3 = BG_FILL
lockBtn.BackgroundTransparency = 0.5
lockBtn.Text = "🔓"
lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 12
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 6)
local lockStr = Instance.new("UIStroke", lockBtn)
lockStr.Color = BORDER_COLOR
lockStr.Thickness = 1.5

lockBtn.MouseButton1Click:Connect(function()
    guiLocked = not guiLocked
    lockBtn.Text = guiLocked and "🔒" or "🔓"
    lockBtn.TextColor3 = guiLocked and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(255, 255, 255)
end)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -32, 0.5, -12)
minimizeBtn.BackgroundColor3 = BG_FILL
minimizeBtn.BackgroundTransparency = 0.5
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = LILAC
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 15
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)
local minStr = Instance.new("UIStroke", minimizeBtn)
minStr.Color = BORDER_COLOR
minStr.Thickness = 1.5

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    dp.Visible = isMinimized
end)

local content = Instance.new("ScrollingFrame", dp)
content.Size = UDim2.new(1, -20, 1, -72)
content.Position = UDim2.new(0, 10, 0, 36)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 0
content.ScrollingDirection = Enum.ScrollingDirection.Y
content.ElasticBehavior = Enum.ElasticBehavior.Always
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new(0, 0, 0, 0)

local contentLayout = Instance.new("UIListLayout", content)
contentLayout.Padding = UDim.new(0, 4)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

local contentPad = Instance.new("UIPadding", content)
contentPad.PaddingTop = UDim.new(0, 4)
contentPad.PaddingBottom = UDim.new(0, 6)
contentPad.PaddingLeft = UDim.new(0, 3)
contentPad.PaddingRight = UDim.new(0, 3)

-- ============================================================
-- SPEED CHECKER
-- ============================================================
local speedLabel = nil
local discordLabel = nil

local function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    
    local bb = Instance.new("BillboardGui", head)
    bb.Size = UDim2.new(0, 160, 0, 44)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    
    discordLabel = Instance.new("TextLabel", bb)
    discordLabel.Size = UDim2.new(1, 0, 0.45, 0)
    discordLabel.Position = UDim2.new(0, 0, 0, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "Discord.gg/Bakiihubb"
    discordLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
    discordLabel.Font = Enum.Font.GothamBold
    discordLabel.TextScaled = true
    discordLabel.TextStrokeTransparency = 0
    discordLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Size = UDim2.new(1, 0, 0.45, 0)
    speedLabel.Position = UDim2.new(0, 0, 0.55, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: 0"
    speedLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
end

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if speedLabel then 
        speedLabel.Text = string.format("Speed: %.1f", Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude) 
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupSpeedIndicator(char)
    task.wait(0.2)
    tpBatH = char:FindFirstChildOfClass("Humanoid")
    tpBatHRP = char:FindFirstChild("HumanoidRootPart")
end)

if LocalPlayer.Character then 
    setupSpeedIndicator(LocalPlayer.Character) 
    task.wait(0.2)
    tpBatH = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    tpBatHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- ============================================================
-- UI HELPER FUNCTIONS
-- ============================================================
local function createSectionHeader(parent, text)
    local section = Instance.new("Frame", parent)
    section.Size = UDim2.new(1, 0, 0, 18)
    section.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", section)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text:upper()
    label.TextColor3 = LILAC
    label.Font = Enum.Font.GothamBold
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    return section
end

local function createRow(parent, label, defaultVal, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = ROW_FILL
    row.BackgroundTransparency = 0
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
    
    local rowStroke = Instance.new("UIStroke", row)
    rowStroke.Color = BORDER_COLOR
    rowStroke.Thickness = 1
    rowStroke.Transparency = 0.3
    
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.7, -6, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = MAIN_TEXT
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local input = Instance.new("TextBox", row)
    input.Size = UDim2.new(0.2, -4, 0, 18)
    input.Position = UDim2.new(0.8, -4, 0.5, -9)
    input.BackgroundColor3 = BG_FILL
    input.BackgroundTransparency = 0
    input.BorderSizePixel = 0
    input.Text = tostring(defaultVal)
    input.TextColor3 = MAIN_TEXT
    input.Font = Enum.Font.GothamBold
    input.TextSize = 8
    input.ClearTextOnFocus = false
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 5)
    local inSt = Instance.new("UIStroke", input)
    inSt.Color = BORDER_COLOR
    inSt.Thickness = 1
    inSt.Transparency = 0.15
    
    input.FocusLost:Connect(function()
        local n = tonumber(input.Text)
        if n then
            if callback then callback(n) end
        else
            input.Text = tostring(defaultVal)
        end
    end)
    
    return row, input
end

local function createToggleRow(parent, label, defaultState, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = ROW_FILL
    row.BackgroundTransparency = 0
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
    
    local rowStroke = Instance.new("UIStroke", row)
    rowStroke.Color = BORDER_COLOR
    rowStroke.Thickness = 1
    rowStroke.Transparency = 0.3
    
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.78, -6, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = MAIN_TEXT
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local state = defaultState
    local toggleRef = nil
    
    local toggle = Instance.new("TextButton", row)
    toggle.Size = UDim2.new(0, 14, 0, 14)
    toggle.Position = UDim2.new(1, -22, 0.5, -7)
    toggle.BackgroundColor3 = state and TOGGLE_ON or TOGGLE_OFF
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.ClipsDescendants = true
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
    toggleRef = toggle
    
    local gradient = Instance.new("UIGradient", toggle)
    gradient.Rotation = 270
    if state then
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(0.7, 0.05),
            NumberSequenceKeypoint.new(0.85, 0.1),
            NumberSequenceKeypoint.new(1, 0.25),
        })
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 150, 255)),
            ColorSequenceKeypoint.new(0.2, Color3.fromRGB(210, 170, 255)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(220, 190, 255)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(230, 210, 255)),
            ColorSequenceKeypoint.new(0.8, Color3.fromRGB(245, 230, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        })
    else
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(0.35, 0.2),
            NumberSequenceKeypoint.new(0.65, 0.1),
            NumberSequenceKeypoint.new(0.85, 0.03),
            NumberSequenceKeypoint.new(1, 0),
        })
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.35, Color3.fromRGB(80, 75, 85)),
            ColorSequenceKeypoint.new(0.65, Color3.fromRGB(160, 150, 170)),
            ColorSequenceKeypoint.new(0.85, Color3.fromRGB(230, 220, 240)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        })
    end
    
    local function updateGradient()
        if state then
            gradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(0.7, 0.05),
                NumberSequenceKeypoint.new(0.85, 0.1),
                NumberSequenceKeypoint.new(1, 0.25),
            })
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 150, 255)),
                ColorSequenceKeypoint.new(0.2, Color3.fromRGB(210, 170, 255)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(220, 190, 255)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(230, 210, 255)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(245, 230, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
            })
        else
            gradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.35),
                NumberSequenceKeypoint.new(0.35, 0.2),
                NumberSequenceKeypoint.new(0.65, 0.1),
                NumberSequenceKeypoint.new(0.85, 0.03),
                NumberSequenceKeypoint.new(1, 0),
            })
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.35, Color3.fromRGB(80, 75, 85)),
                ColorSequenceKeypoint.new(0.65, Color3.fromRGB(160, 150, 170)),
                ColorSequenceKeypoint.new(0.85, Color3.fromRGB(230, 220, 240)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
            })
        end
    end
    
    local function setState(v)
        state = v
        toggle.BackgroundColor3 = state and TOGGLE_ON or TOGGLE_OFF
        updateGradient()
        if callback then callback(state) end
    end
    
    toggle.MouseButton1Click:Connect(function()
        setState(not state)
    end)
    
    return row, setState, toggleRef
end

local function createKeybindRow(parent, label, defaultKey, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = ROW_FILL
    row.BackgroundTransparency = 0
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
    
    local rowStroke = Instance.new("UIStroke", row)
    rowStroke.Color = BORDER_COLOR
    rowStroke.Thickness = 1
    rowStroke.Transparency = 0.3
    
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.7, -6, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = MAIN_TEXT
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local keybindBox = Instance.new("TextButton", row)
    keybindBox.Size = UDim2.new(0.2, -4, 0, 18)
    keybindBox.Position = UDim2.new(0.8, -4, 0.5, -9)
    keybindBox.BackgroundColor3 = BG_FILL
    keybindBox.BackgroundTransparency = 0
    keybindBox.BorderSizePixel = 0
    keybindBox.Text = defaultKey or "NONE"
    keybindBox.TextColor3 = MAIN_TEXT
    keybindBox.Font = Enum.Font.GothamBold
    keybindBox.TextSize = 7
    Instance.new("UICorner", keybindBox).CornerRadius = UDim.new(0, 5)
    local inSt = Instance.new("UIStroke", keybindBox)
    inSt.Color = BORDER_COLOR
    inSt.Thickness = 1
    inSt.Transparency = 0.15
    
    local listening = false
    local currentKey = nil
    
    keybindBox.MouseButton1Click:Connect(function()
        if listening then return end
        
        listening = true
        keybindBox.Text = "..."
        keybindBox.TextColor3 = Color3.fromRGB(255, 200, 100)
        
        local conn
        conn = UserInputService.InputBegan:Connect(function(inp, gpe)
            if listening and not gpe then
                local kc = inp.KeyCode
                if kc and kc.Name ~= "Unknown" then
                    listening = false
                    currentKey = kc
                    keybindBox.Text = kc.Name
                    keybindBox.TextColor3 = MAIN_TEXT
                    if callback then callback(kc) end
                    conn:Disconnect()
                end
            end
        end)
        
        task.delay(5, function()
            if listening then
                listening = false
                keybindBox.Text = currentKey and currentKey.Name or "NONE"
                keybindBox.TextColor3 = MAIN_TEXT
                if conn then conn:Disconnect() end
            end
        end)
    end)
    
    return row, keybindBox
end

-- ============================================================
-- COMBAT FUNCTIONS (All full implementations)
-- ============================================================
local function startUnwalk()
    local c = LocalPlayer.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then 
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do 
            t:Stop() 
        end 
    end
    local anim = c:FindFirstChild("Animate")
    if anim then 
        unwalkSavedAnimate = anim:Clone() 
        anim:Destroy() 
    end
end

local function stopUnwalk()
    local c = LocalPlayer.Character
    if c and unwalkSavedAnimate then 
        unwalkSavedAnimate:Clone().Parent = c 
        unwalkSavedAnimate = nil 
    end
end

local BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", 
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", 
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}

local function findBatForCounter()
    local c = LocalPlayer.Character
    if not c then return nil end
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    
    for _, ch in ipairs(c:GetChildren()) do 
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then 
            return ch 
        end 
    end
    if bp then 
        for _, ch in ipairs(bp:GetChildren()) do 
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then 
                return ch 
            end 
        end 
    end
    return nil
end

local function swingBatForCounter(bat, char)
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= char then 
        if hum2 then pcall(function() hum2:EquipTool(bat) end) end
        task.wait(0.05) 
    end
    
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.15)
        pcall(function() remote:FireServer() end)
    else 
        pcall(function() bat:Activate() end)
        task.wait(0.15)
        pcall(function() bat:Activate() end)
    end
end

local function startBatCounter()
    if batCounterConns then return end
    batCounterConns = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if not hum2 then return end
        
        local st = hum2:GetState()
        if st == Enum.HumanoidStateType.Physics or 
           st == Enum.HumanoidStateType.Ragdoll or 
           st == Enum.HumanoidStateType.FallingDown then
            
            batCounterDebounce = true
            task.spawn(function()
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, char) end
                task.wait(0.5)
                batCounterDebounce = false
            end)
        end
    end)
end

local function stopBatCounter()
    if batCounterConns then 
        batCounterConns:Disconnect()
        batCounterConns = nil 
    end
    batCounterDebounce = false
end

local function findMedusa()
    local c = LocalPlayer.Character
    if not c then return nil end
    
    for _, t in ipairs(c:GetChildren()) do 
        if t:IsA("Tool") then 
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then 
                return t 
            end 
        end 
    end
    
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then 
        for _, t in ipairs(bp:GetChildren()) do 
            if t:IsA("Tool") then 
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then 
                    return t 
                end 
            end 
        end 
    end
    return nil
end

local function useMedusaCounter()
    if medusaDebounce then return end
    if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    
    local c = LocalPlayer.Character
    if not c then return end
    
    medusaDebounce = true
    local med = findMedusa()
    if not med then 
        medusaDebounce = false
        return 
    end
    
    if med.Parent ~= c then 
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end 
    end
    
    pcall(function() med:Activate() end)
    medusaLastUsed = tick()
    medusaDebounce = false
end

local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency == 1 then 
            useMedusaCounter() 
        end
    end)
end

local function setupMedusa(char)
    for _, c in pairs(medusaConns) do 
        pcall(function() c:Disconnect() end) 
    end
    medusaConns = {}
    
    if not char then return end
    
    for _, part in ipairs(char:GetDescendants()) do 
        if part:IsA("BasePart") then 
            table.insert(medusaConns, onAnchorChanged(part)) 
        end 
    end
    
    table.insert(medusaConns, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then 
            table.insert(medusaConns, onAnchorChanged(part)) 
        end
    end))
end

local function stopMedusaCounter()
    for _, c in pairs(medusaConns) do 
        pcall(function() c:Disconnect() end) 
    end
    medusaConns = {}
end

local function startAntiRagdoll()
    if antiRagdollConn then return end
    
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not (hum and root) then return end
        
        local state = hum:GetState()
        local isRagdolled = (
            state == Enum.HumanoidStateType.Physics or
            state == Enum.HumanoidStateType.Ragdoll or
            state == Enum.HumanoidStateType.FallingDown
        )
        
        local endTime = LocalPlayer:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            isRagdolled = true
        end
        
        if isRagdolled then
            pcall(function()
                LocalPlayer:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
            end)
            
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or 
                   (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    pcall(function() d:Destroy() end)
                end
            end
            
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then
                    obj.Enabled = true
                end
            end
            
            if hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            
            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

local function stopAntiRagdoll()
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end

local function applyInfJumpBoost(boost)
    if not infJumpEnabled then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    root.Velocity = Vector3.new(root.Velocity.X, boost or 50, root.Velocity.Z)
end

local function stopInfJumpHoldState()
    infJumpState.holdPressed = false
    infJumpState.holdActive = false
    infJumpState.controllerActive = false
    infJumpState.mobilePressed = false
    infJumpState.mobileActive = false
end

local function hookMobileJumpButton(obj)
    if not obj or obj.Name ~= "JumpButton" or not obj:IsA("GuiButton") or infJumpState.hooked[obj] then return end
    infJumpState.hooked[obj] = true
    
    obj.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch or not infJumpEnabled then return end
        infJumpState.mobilePressed = true
        task.delay(0.12, function()
            if infJumpState.mobilePressed and infJumpEnabled then
                infJumpState.mobileActive = true
                applyInfJumpBoost(50)
            end
        end)
    end)
    
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            infJumpState.mobilePressed = false
            infJumpState.mobileActive = false
        end
    end)
    
    obj.AncestryChanged:Connect(function(_, parent)
        if not parent then
            infJumpState.hooked[obj] = nil
            infJumpState.mobilePressed = false
            infJumpState.mobileActive = false
        end
    end)
end

local function setupInfiniteJump()
    UserInputService.JumpRequest:Connect(function()
        applyInfJumpBoost(50)
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if UserInputService:GetFocusedTextBox() then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
            infJumpState.holdPressed = true
            task.delay(0.12, function()
                if infJumpState.holdPressed and infJumpEnabled then
                    infJumpState.holdActive = true
                    applyInfJumpBoost(50)
                end
            end)
        elseif input.KeyCode == Enum.KeyCode.ButtonA and input.UserInputType.Name:match("^Gamepad") then
            infJumpState.controllerActive = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
            infJumpState.holdPressed = false
            infJumpState.holdActive = false
        end
        if input.KeyCode == Enum.KeyCode.ButtonA and input.UserInputType.Name:match("^Gamepad") then
            infJumpState.controllerActive = false
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if infJumpEnabled and (infJumpState.holdActive or infJumpState.mobileActive or infJumpState.controllerActive) then
            applyInfJumpBoost(50)
        end
    end)
    
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        for _, obj in ipairs(playerGui:GetDescendants()) do
            hookMobileJumpButton(obj)
        end
        
        playerGui.DescendantAdded:Connect(function(obj)
            task.defer(hookMobileJumpButton, obj)
        end)
    end
end

local function backupAnimations(char)
    local animate = char and char:FindFirstChild("Animate")
    if not animate or next(OriginalAnims) ~= nil then return end
    
    local function getId(obj) return obj and obj.AnimationId or nil end
    
    OriginalAnims = {
        idle1 = getId(animate.idle and animate.idle:FindFirstChild("Animation1")),
        idle2 = getId(animate.idle and animate.idle:FindFirstChild("Animation2")),
        walk = getId(animate.walk and animate.walk:FindFirstChild("WalkAnim")),
        run = getId(animate.run and animate.run:FindFirstChild("RunAnim")),
        jump = getId(animate.jump and animate.jump:FindFirstChild("JumpAnim")),
        fall = getId(animate.fall and animate.fall:FindFirstChild("FallAnim")),
        climb = getId(animate.climb and animate.climb:FindFirstChild("ClimbAnim")),
    }
end

local function resetAnimations()
    local char = LocalPlayer.Character
    local animate = char and char:FindFirstChild("Animate")
    if not animate or next(OriginalAnims) == nil then return end
    
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
    end
    
    local function setAnimId(obj, id)
        if obj and id then pcall(function() obj.AnimationId = id end) end
    end
    
    setAnimId(animate.idle and animate.idle:FindFirstChild("Animation1"), OriginalAnims.idle1)
    setAnimId(animate.idle and animate.idle:FindFirstChild("Animation2"), OriginalAnims.idle2)
    setAnimId(animate.walk and animate.walk:FindFirstChild("WalkAnim"), OriginalAnims.walk)
    setAnimId(animate.run and animate.run:FindFirstChild("RunAnim"), OriginalAnims.run)
    setAnimId(animate.jump and animate.jump:FindFirstChild("JumpAnim"), OriginalAnims.jump)
    setAnimId(animate.fall and animate.fall:FindFirstChild("FallAnim"), OriginalAnims.fall)
    setAnimId(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), OriginalAnims.climb)
    
    if animate then
        pcall(function()
            animate.Disabled = true
            task.wait()
            animate.Disabled = false
        end)
    end
end

local function enableHitHarderAnim()
    hitHarderAnimEnabled = true
    local char = LocalPlayer.Character
    local animate = char and char:FindFirstChild("Animate")
    if not animate then return end
    
    backupAnimations(char)
    
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
    end
    
    local function setAnimId(obj, id)
        if obj and id then pcall(function() obj.AnimationId = id end) end
    end
    
    setAnimId(animate.idle and animate.idle:FindFirstChild("Animation1"), HIT_HARDER_ANIMS.idle1)
    setAnimId(animate.idle and animate.idle:FindFirstChild("Animation2"), HIT_HARDER_ANIMS.idle2)
    setAnimId(animate.walk and animate.walk:FindFirstChild("WalkAnim"), HIT_HARDER_ANIMS.walk)
    setAnimId(animate.run and animate.run:FindFirstChild("RunAnim"), HIT_HARDER_ANIMS.run)
    setAnimId(animate.jump and animate.jump:FindFirstChild("JumpAnim"), HIT_HARDER_ANIMS.jump)
    setAnimId(animate.fall and animate.fall:FindFirstChild("FallAnim"), HIT_HARDER_ANIMS.fall)
    
    pcall(function()
        animate.Disabled = true
        task.wait()
        animate.Disabled = false
    end)
end

local function disableHitHarderAnim()
    hitHarderAnimEnabled = false
    resetAnimations()
end

-- ============================================================
-- BAT AIMBOT FUNCTIONS
-- ============================================================
local function findBatAimbotTool()
    local char = LocalPlayer.Character
    if not char then return nil end
    
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end
    
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
    end
    return nil
end

local function getClosestTarget()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

local function findAnyTool()
    local c = LocalPlayer.Character
    if c then
        for _, v in ipairs(c:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end
    return nil
end

local function tryHitBatAimbot()
    if batAimbotHittingCooldown then return end
    batAimbotHittingCooldown = true
    
    pcall(function()
        local c = LocalPlayer.Character
        if not c then return end
        
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        local tool = findAnyTool()
        
        if tool then
            if tool.Parent ~= c and hum2 then
                pcall(function() hum2:EquipTool(tool) end)
            end
            local remote = tool:FindFirstChildOfClass("RemoteEvent")
            if remote then
                pcall(function() remote:FireServer() end)
            else
                pcall(function() tool:Activate() end)
            end
        end
    end)
    
    task.delay(0.08, function()
        batAimbotHittingCooldown = false
    end)
end

local function startBatAimbot()
    for _, conn in pairs(batAimbotConns) do
        pcall(function() conn:Disconnect() end)
    end
    batAimbotConns = {}
    
    local hum0 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        hum0.AutoRotate = false
    end

    local aimbotConn = RunService.RenderStepped:Connect(function()
        if not batAimbotEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBatAimbotTool()
            if bat then
                pcall(function() hum:EquipTool(bat) end)
            end
        end

        local target = getClosestTarget()
        if not target then return end
        
        if batAimbotAutoSwing then
            tryHitBatAimbot()
        end

        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position

        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3

        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
        local chaseSpeed = 58

        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local curCF = root.CFrame
            local diffCF = curCF:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            local tiltSpeed = 42
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                Vector3.new(rx * tiltSpeed, ry * tiltSpeed, rz * tiltSpeed)
            )
        end
    end)
    table.insert(batAimbotConns, aimbotConn)
end

local function stopBatAimbot()
    for _, conn in pairs(batAimbotConns) do
        pcall(function() conn:Disconnect() end)
    end
    batAimbotConns = {}
    
    local c = LocalPlayer.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then
        hum2.AutoRotate = true
    end
    batAimbotHittingCooldown = false
end

-- ============================================================
-- TP BAT FUNCTIONS
-- ============================================================
local function findBatTP()
    local char = LocalPlayer.Character
    if not char then return nil end
    
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end
    
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
    end
    return nil
end

local function getClosestPlayerTP()
    if not tpBatHRP then return nil, math.huge end
    
    local closest, closestDistance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (tpBatHRP.Position - targetRoot.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closest = player
                end
            end
        end
    end
    return closest, closestDistance
end

local function tryHitBatTP()
    if tpBatHittingCooldown then return end
    tpBatHittingCooldown = true
    
    pcall(function()
        local bat = findBatTP()
        if bat then
            local char = LocalPlayer.Character
            if bat.Parent ~= char then
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    pcall(function() humanoid:EquipTool(bat) end)
                end
            end
            
            local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
            if remoteEvent then
                pcall(function() remoteEvent:FireServer() end)
            end
            
            local remoteFunction = bat:FindFirstChildWhichIsA("RemoteFunction")
            if remoteFunction then
                pcall(function() remoteFunction:InvokeServer() end)
            end
            
            pcall(function() bat:Activate() end)
        end
    end)
    
    task.delay(0.08, function()
        tpBatHittingCooldown = false
    end)
end

local function startTPBatLoop()
    if tpBatConn then return end
    
    tpBatConn = RunService.Heartbeat:Connect(function()
        if not tpBatEnabled then return end
        
        if not tpBatH or not tpBatHRP or not tpBatH.Parent or not tpBatHRP.Parent then
            local char = LocalPlayer.Character
            if char then
                tpBatH = char:FindFirstChildOfClass("Humanoid")
                tpBatHRP = char:FindFirstChild("HumanoidRootPart")
            end
            if not tpBatH or not tpBatHRP then return end
        end
        
        local target = getClosestPlayerTP()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0)
                if (tpBatHRP.Position - targetPosition).Magnitude > 5 then
                    tpBatHRP.CFrame = CFrame.new(targetPosition)
                end
                tryHitBatTP()
            end
        end
    end)
end

local function startTPBatRender()
    if tpBatRenderConn then return end
    
    tpBatRenderConn = RunService.RenderStepped:Connect(function()
        if not tpBatEnabled then return end
        if not tpBatH or not tpBatHRP or not tpBatH.Parent or not tpBatHRP.Parent then return end
        
        local target = getClosestPlayerTP()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local camera = workspace.CurrentCamera
                if camera then
                    camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position)
                end
                tryHitBatTP()
            end
        end
    end)
end

function enableTPBat()
    if tpBatEnabled then return end
    tpBatEnabled = true
    startTPBatLoop()
    startTPBatRender()
    if tpBatFloatBtn then
        tpBatFloatBtn.BackgroundColor3 = LILAC
        tpBatFloatGrad.Enabled = true
    end
    if setTPBatFloat then setTPBatFloat(true) end
end

function disableTPBat()
    tpBatEnabled = false
    
    if tpBatConn then
        tpBatConn:Disconnect()
        tpBatConn = nil
    end
    
    if tpBatRenderConn then
        tpBatRenderConn:Disconnect()
        tpBatRenderConn = nil
    end
    
    tpBatHittingCooldown = false
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = true
    end
    
    if tpBatFloatBtn then
        tpBatFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        tpBatFloatGrad.Enabled = false
    end
    if setTPBatFloat then setTPBatFloat(false) end
end

function toggleTPBat()
    if tpBatEnabled then
        disableTPBat()
    else
        enableTPBat()
    end
end

-- ============================================================
-- TP DOWN FUNCTIONS
-- ============================================================
local function doManualTPDown()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) 
        * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
    
    hrp.AssemblyLinearVelocity = Vector3.zero
end

local function runManualTP()
    pcall(function() 
        doManualTPDown() 
    end)
end

-- ============================================================
-- AUTO TP DOWN FUNCTIONS
-- ============================================================
local function doAutoTPDown()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    hrp.CFrame = CFrame.new(hrp.Position.X, autoTPDownHeight, hrp.Position.Z) 
        * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
    
    hrp.AssemblyLinearVelocity = Vector3.zero
    
    task.wait(0.05)
end

local function startAutoTPDown()
    if autoTPDownConn then return end
    
    autoTPDownConn = RunService.Heartbeat:Connect(function()
        if not autoTPDownEnabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        
        if hrp.Position.Y > autoTPDownHeight + 0.5 then
            if tick() - autoTPDownLastTP >= autoTPDownCooldown then
                pcall(function()
                    doAutoTPDown()
                    autoTPDownLastTP = tick()
                end)
            end
        end
    end)
end

local function stopAutoTPDown()
    if autoTPDownConn then
        autoTPDownConn:Disconnect()
        autoTPDownConn = nil
    end
end

-- ============================================================
-- BRAINROT DROP FUNCTIONS
-- ============================================================
local function runDropBrainrot()
    if dropBrainrotActive then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    dropBrainrotActive = true
    local t0 = tick()
    local dc
    
    dc = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then 
            dc:Disconnect()
            dropBrainrotActive = false
            return 
        end
        
        if tick() - t0 >= DROP_ASCEND_DURATION then
            dc:Disconnect()
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {char}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)
            
            if rr then
                local hum2 = char:FindFirstChildOfClass("Humanoid")
                local off = (hum2 and hum2.HipHeight or 2) + (r.Size.Y / 2)
                r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
            dropBrainrotActive = false
            return
        end
        
        r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)
    end)
end

-- ============================================================
-- AUTO LEFT/RIGHT FUNCTIONS
-- ============================================================
local function faceSouth()
    pcall(function()
        local c = LocalPlayer.Character
        if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, 0, 0)
        end
    end)
end

local function faceNorth()
    pcall(function()
        local c = LocalPlayer.Character
        if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(180), 0)
        end
    end)
end

function startAutoLeft()
    if autoMoveConns.autoLeft then
        autoMoveConns.autoLeft:Disconnect()
    end
    
    autoMoveState.autoLeftPhase = 1
    
    autoMoveConns.autoLeft = RunService.Heartbeat:Connect(function()
        if not autoMoveState.autoLeftEnabled then return end
        
        local c = LocalPlayer.Character
        if not c then return end
        
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        
        if not root or not hum then return end
        
        local speed = M.NS
        
        if autoMoveState.autoLeftPhase == 1 then
            local target = Vector3.new(POS.L1.X, root.Position.Y, POS.L1.Z)
            
            if (target - root.Position).Magnitude < 1 then
                autoMoveState.autoLeftPhase = 2
                local direction = (POS.L2 - root.Position)
                local moveVec = Vector3.new(direction.X, 0, direction.Z).Unit
                hum:Move(moveVec, false)
                root.AssemblyLinearVelocity = Vector3.new(moveVec.X * speed, root.AssemblyLinearVelocity.Y, moveVec.Z * speed)
                return
            end
            
            local direction = (POS.L1 - root.Position)
            local moveVec = Vector3.new(direction.X, 0, direction.Z).Unit
            hum:Move(moveVec, false)
            root.AssemblyLinearVelocity = Vector3.new(moveVec.X * speed, root.AssemblyLinearVelocity.Y, moveVec.Z * speed)
            
        elseif autoMoveState.autoLeftPhase == 2 then
            local target = Vector3.new(POS.L2.X, root.Position.Y, POS.L2.Z)
            
            if (target - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoMoveState.autoLeftEnabled = false
                if autoMoveConns.autoLeft then
                    autoMoveConns.autoLeft:Disconnect()
                    autoMoveConns.autoLeft = nil
                end
                autoMoveState.autoLeftPhase = 1
                faceSouth()
                if setAutoLeftFloat then setAutoLeftFloat(false) end
                if autoLeftFloatBtn then
                    autoLeftFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    autoLeftFloatGrad.Enabled = false
                end
                return
            end
            
            local direction = (POS.L2 - root.Position)
            local moveVec = Vector3.new(direction.X, 0, direction.Z).Unit
            hum:Move(moveVec, false)
            root.AssemblyLinearVelocity = Vector3.new(moveVec.X * speed, root.AssemblyLinearVelocity.Y, moveVec.Z * speed)
        end
    end)
end

function stopAutoLeft()
    if autoMoveConns.autoLeft then
        autoMoveConns.autoLeft:Disconnect()
        autoMoveConns.autoLeft = nil
    end
    autoMoveState.autoLeftPhase = 1
    
    local c = LocalPlayer.Character
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:Move(Vector3.zero, false)
        end
    end
end

function startAutoRight()
    if autoMoveConns.autoRight then
        autoMoveConns.autoRight:Disconnect()
    end
    
    autoMoveState.autoRightPhase = 1
    
    autoMoveConns.autoRight = RunService.Heartbeat:Connect(function()
        if not autoMoveState.autoRightEnabled then return end
        
        local c = LocalPlayer.Character
        if not c then return end
        
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        
        if not root or not hum then return end
        
        local speed = M.NS
        
        if autoMoveState.autoRightPhase == 1 then
            local target = Vector3.new(POS.R1.X, root.Position.Y, POS.R1.Z)
            
            if (target - root.Position).Magnitude < 1 then
                autoMoveState.autoRightPhase = 2
                local direction = (POS.R2 - root.Position)
                local moveVec = Vector3.new(direction.X, 0, direction.Z).Unit
                hum:Move(moveVec, false)
                root.AssemblyLinearVelocity = Vector3.new(moveVec.X * speed, root.AssemblyLinearVelocity.Y, moveVec.Z * speed)
                return
            end
            
            local direction = (POS.R1 - root.Position)
            local moveVec = Vector3.new(direction.X, 0, direction.Z).Unit
            hum:Move(moveVec, false)
            root.AssemblyLinearVelocity = Vector3.new(moveVec.X * speed, root.AssemblyLinearVelocity.Y, moveVec.Z * speed)
            
        elseif autoMoveState.autoRightPhase == 2 then
            local target = Vector3.new(POS.R2.X, root.Position.Y, POS.R2.Z)
            
            if (target - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoMoveState.autoRightEnabled = false
                if autoMoveConns.autoRight then
                    autoMoveConns.autoRight:Disconnect()
                    autoMoveConns.autoRight = nil
                end
                autoMoveState.autoRightPhase = 1
                faceNorth()
                if setAutoRightFloat then setAutoRightFloat(false) end
                if autoRightFloatBtn then
                    autoRightFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    autoRightFloatGrad.Enabled = false
                end
                return
            end
            
            local direction = (POS.R2 - root.Position)
            local moveVec = Vector3.new(direction.X, 0, direction.Z).Unit
            hum:Move(moveVec, false)
            root.AssemblyLinearVelocity = Vector3.new(moveVec.X * speed, root.AssemblyLinearVelocity.Y, moveVec.Z * speed)
        end
    end)
end

function stopAutoRight()
    if autoMoveConns.autoRight then
        autoMoveConns.autoRight:Disconnect()
        autoMoveConns.autoRight = nil
    end
    autoMoveState.autoRightPhase = 1
    
    local c = LocalPlayer.Character
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:Move(Vector3.zero, false)
        end
    end
end

function toggleAutoLeft()
    autoMoveState.autoLeftEnabled = not autoMoveState.autoLeftEnabled
    
    if autoMoveState.autoLeftEnabled then
        if autoMoveState.autoRightEnabled then
            toggleAutoRight()
        end
        startAutoLeft()
        if setAutoLeftFloat then setAutoLeftFloat(true) end
        if autoLeftFloatBtn then
            autoLeftFloatBtn.BackgroundColor3 = LILAC
            autoLeftFloatGrad.Enabled = true
        end
    else
        stopAutoLeft()
        if setAutoLeftFloat then setAutoLeftFloat(false) end
        if autoLeftFloatBtn then
            autoLeftFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            autoLeftFloatGrad.Enabled = false
        end
    end
end

function toggleAutoRight()
    autoMoveState.autoRightEnabled = not autoMoveState.autoRightEnabled
    
    if autoMoveState.autoRightEnabled then
        if autoMoveState.autoLeftEnabled then
            toggleAutoLeft()
        end
        startAutoRight()
        if setAutoRightFloat then setAutoRightFloat(true) end
        if autoRightFloatBtn then
            autoRightFloatBtn.BackgroundColor3 = LILAC
            autoRightFloatGrad.Enabled = true
        end
    else
        stopAutoRight()
        if setAutoRightFloat then setAutoRightFloat(false) end
        if autoRightFloatBtn then
            autoRightFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            autoRightFloatGrad.Enabled = false
        end
    end
end

-- ============================================================
-- AUTO STEAL PROGRESS BAR
-- ============================================================
local function createStealProgressBar()
    local sg = Instance.new("ScreenGui")
    sg.Name = "StealProgress"
    sg.ResetOnSpawn = false
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 280, 0, 65)
    frame.Position = UDim2.new(0.5, -140, 1, -81)
    frame.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    stealProgressFrame = frame

    local fDragging, fDragInput, fDragStart, fStartPos = false, nil, nil, nil
    
    frame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            fDragging = true
            fDragStart = inp.Position
            fStartPos = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    fDragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            fDragInput = inp
        end
    end)
    
    UserInputService.InputChanged:Connect(function(inp)
        if inp == fDragInput and fDragging then
            local delta = inp.Position - fDragStart
            frame.Position = UDim2.new(
                fStartPos.X.Scale,
                fStartPos.X.Offset + delta.X,
                fStartPos.Y.Scale,
                fStartPos.Y.Offset + delta.Y
            )
        end
    end)

    progressPct = Instance.new("TextLabel", frame)
    progressPct.Size = UDim2.new(0, 44, 0, 14)
    progressPct.Position = UDim2.new(0, 9, 0, 5)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(235, 235, 235)
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextSize = 13
    progressPct.TextXAlignment = Enum.TextXAlignment.Left

    local radiusLabel = Instance.new("TextLabel", frame)
    radiusLabel.Size = UDim2.new(0, 80, 0, 14)
    radiusLabel.Position = UDim2.new(1, -89, 0, 5)
    radiusLabel.BackgroundTransparency = 1
    radiusLabel.Text = "Radius: " .. Steal.StealRadius
    radiusLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
    radiusLabel.Font = Enum.Font.GothamBold
    radiusLabel.TextSize = 11
    radiusLabel.TextXAlignment = Enum.TextXAlignment.Right

    stealInfoLabel = Instance.new("TextLabel", frame)
    stealInfoLabel.Size = UDim2.new(1, -18, 0, 14)
    stealInfoLabel.Position = UDim2.new(0, 9, 0, 20)
    stealInfoLabel.BackgroundTransparency = 1
    stealInfoLabel.Text = "FPS: 60 • discord.gg/7Uujw2kUCN • Ping: 0ms"
    stealInfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    stealInfoLabel.Font = Enum.Font.GothamBold
    stealInfoLabel.TextSize = 10
    stealInfoLabel.TextXAlignment = Enum.TextXAlignment.Center

    local bg = Instance.new("Frame", frame)
    bg.Size = UDim2.new(1, -18, 0, 14)
    bg.Position = UDim2.new(0, 9, 0, 43)
    bg.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
    bg.BackgroundTransparency = 0.05
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    progressFill = Instance.new("Frame", bg)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
    progressFill.BackgroundTransparency = 0
    progressFill.BorderSizePixel = 0
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    
    local shine = Instance.new("Frame", progressFill)
    shine.Size = UDim2.new(1, 0, 0.4, 0)
    shine.Position = UDim2.new(0, 0, 0.15, 0)
    shine.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
    shine.BackgroundTransparency = 0.5
    shine.BorderSizePixel = 0
    Instance.new("UICorner", shine).CornerRadius = UDim.new(1, 0)
    
    local highlight = Instance.new("Frame", progressFill)
    highlight.Size = UDim2.new(1, 0, 0.15, 0)
    highlight.Position = UDim2.new(0, 0, 0.05, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(220, 180, 255)
    highlight.BackgroundTransparency = 0.6
    highlight.BorderSizePixel = 0
    Instance.new("UICorner", highlight).CornerRadius = UDim.new(1, 0)
    
    local border = Instance.new("Frame", progressFill)
    border.Size = UDim2.new(1, 0, 0.08, 0)
    border.Position = UDim2.new(0, 0, 0.88, 0)
    border.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    border.BackgroundTransparency = 0.3
    border.BorderSizePixel = 0
    Instance.new("UICorner", border).CornerRadius = UDim.new(1, 0)
end

-- ============================================================
-- AUTO STEAL CORE FUNCTIONS
-- ============================================================
local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

local function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

local function findNearestPrompt()
    local char = LocalPlayer.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then
            -- Skip own plot
        else
            local pods = plot:FindFirstChild("AnimalPodiums")
            if not pods then continue end
            
            for _, pod in ipairs(pods:GetChildren()) do
                local base = pod:FindFirstChild("Base")
                local sp = base and base:FindFirstChild("Spawn")
                if sp then
                    local d = (sp.Position - root.Position).Magnitude
                    if d <= Steal.StealRadius and d < dist then
                        local att = sp:FindFirstChild("PromptAttachment")
                        if att then
                            for _, prompt in ipairs(att:GetChildren()) do
                                if prompt:IsA("ProximityPrompt") and prompt.ActionText:find("Steal") then
                                    nearest, dist = prompt, d
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nearest
end

local function executeSteal(prompt)
    if isStealing then return end
    
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = {hold = {}, trigger = {}, ready = true}
        if getconnections then
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
            end
            for _, c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
            end
        end
    end
    
    local data = Steal.Data[prompt]
    if not data.ready then return end
    
    data.ready = false
    isStealing = true
    stealStartTime = tick()
    
    local progressConn = RunService.Heartbeat:Connect(function()
        if not isStealing then 
            progressConn:Disconnect()
            return 
        end
        local prog = math.clamp((tick() - stealStartTime) / Steal.StealDuration, 0, 1)
        
        if progressFill then progressFill.Size = UDim2.new(prog, 0, 1, 0) end
        if progressPct then progressPct.Text = math.floor(prog * 100) .. "%" end
    end)
    
    task.spawn(function()
        for _, fn in ipairs(data.hold) do task.spawn(fn) end
        task.wait(Steal.StealDuration)
        
        for _, fn in ipairs(data.trigger) do task.spawn(fn) end
        
        task.wait(0.1)
        progressConn:Disconnect()
        resetProgressBar()
        data.ready = true
        isStealing = false
    end)
end

local function startAutoSteal()
    if autoStealConn then return end
    
    autoStealConn = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        
        if selectedStealMode == "Semi" then
            if AceSemiSteal and AceSemiSteal.enabled then
                return
            end
        end
        
        local p = findNearestPrompt()
        if p then executeSteal(p) end
    end)
end

-- ============================================================
-- SEMI STEAL FUNCTIONS (Simplified for space)
-- ============================================================
local AceSemiSteal = {
    enabled = false,
    radius = 9,
    conn = nil,
    state = {active = false}
}

function startSemiSteal()
    AceSemiSteal.enabled = true
    if AceSemiSteal.conn then AceSemiSteal.conn:Disconnect(); AceSemiSteal.conn = nil end
    AceSemiSteal.conn = RunService.Heartbeat:Connect(function()
        if not AceSemiSteal.enabled or selectedStealMode ~= "Semi" then return end
        if AceSemiSteal.state.active then return end
        
        local p = findNearestPrompt()
        if p and not isStealing then
            AceSemiSteal.state.active = true
            task.spawn(function()
                if p and p.Parent then
                    -- Simulate hold
                    local data = Steal.Data[p]
                    if data and data.hold then
                        for _, fn in ipairs(data.hold) do task.spawn(fn) end
                    end
                    task.wait(0.5)
                    
                    -- Simulate trigger
                    if data and data.trigger then
                        for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                    end
                    
                    -- Progress bar animation
                    for i = 1, 20 do
                        if not AceSemiSteal.enabled then break end
                        local prog = i / 20
                        if progressFill then progressFill.Size = UDim2.new(prog, 0, 1, 0) end
                        if progressPct then progressPct.Text = math.floor(prog * 100) .. "%" end
                        task.wait(0.03)
                    end
                    
                    if progressFill then progressFill.Size = UDim2.new(1, 0, 1, 0) end
                    if progressPct then progressPct.Text = "100%" end
                    task.wait(0.1)
                    resetProgressBar()
                end
                AceSemiSteal.state.active = false
            end)
        end
    end)
end

function stopSemiSteal()
    AceSemiSteal.enabled = false
    if AceSemiSteal.conn then AceSemiSteal.conn:Disconnect(); AceSemiSteal.conn = nil end
    AceSemiSteal.state.active = false
end

function toggleStealMode()
    if selectedStealMode == "Normal" then
        selectedStealMode = "Semi"
        startSemiSteal()
        print("Semi Steal: ENABLED")
        if setStealMode then setStealMode("Semi") end
        if stealFloatBtn then
            stealFloatBtn.BackgroundColor3 = LILAC
            stealFloatGrad.Enabled = true
        end
    else
        selectedStealMode = "Normal"
        stopSemiSteal()
        print("Semi Steal: DISABLED")
        if setStealMode then setStealMode("Normal") end
        if stealFloatBtn then
            stealFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            stealFloatGrad.Enabled = false
        end
    end
end

-- ============================================================
-- CHARACTER RESPAWN HANDLING
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if unwalkEnabled then 
        task.wait(0.5)
        startUnwalk() 
    end
    if medusaCounterEnabled then 
        setupMedusa(char) 
    end
    if antiRagdollEnabled then
        startAntiRagdoll()
    end
    if hitHarderAnimEnabled then
        task.wait(0.5)
        enableHitHarderAnim()
    end
    if batAimbotEnabled then
        task.wait(0.5)
        startBatAimbot()
    end
    task.wait(0.2)
    tpBatH = char:FindFirstChildOfClass("Humanoid")
    tpBatHRP = char:FindFirstChild("HumanoidRootPart")
end)

-- ============================================================
-- SPEED FUNCTIONS
-- ============================================================
function M.isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or 
           st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

function M.hasBrainrotInHand()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local name = item.Name:lower()
            if name:find("brainrot", 1, true) or name:find("skibidi", 1, true) or name:find("toilet", 1, true) then
                return true
            end
        end
    end
    return false
end

function M.getActiveMoveSpeed()
    if M.hasBrainrotInHand() then
        return M.LAGGER_CARRY_SPEED
    end
    if M.laggerCarryActive then return M.LAGGER_CARRY_SPEED
    elseif M.laggerModeEnabled then return M.LAGGER_SPEED
    elseif M.carrySpeedActive or M.manualCarryActive then return M.CS
    else return M.NS end
end

function M.destroySpeedObjects()
    if M._anchoredBySpeed then pcall(function() M._anchoredBySpeed.Anchored = false end); M._anchoredBySpeed = nil end
    if M._bodyVel then pcall(function() M._bodyVel:Destroy() end); M._bodyVel = nil end
    if M._bodyPosition then pcall(function() M._bodyPosition:Destroy() end); M._bodyPosition = nil end
    if M._bodyForce then pcall(function() M._bodyForce:Destroy() end); M._bodyForce = nil end
    if M._bodyThrust then pcall(function() M._bodyThrust:Destroy() end); M._bodyThrust = nil end
    if M._linearVel then pcall(function() M._linearVel:Destroy() end); M._linearVel = nil end
    if M._vectorForce then pcall(function() M._vectorForce:Destroy() end); M._vectorForce = nil end
    if M._alignPos then pcall(function() M._alignPos:Destroy() end); M._alignPos = nil end
    if M._rocket then pcall(function() M._rocket:Destroy() end); M._rocket = nil end
    if M._rocketTarget then pcall(function() M._rocketTarget:Destroy() end); M._rocketTarget = nil end
    if M._attLinVel then pcall(function() M._attLinVel:Destroy() end); M._attLinVel = nil end
    if M._attVecForce then pcall(function() M._attVecForce:Destroy() end); M._attVecForce = nil end
    if M._attAlign then pcall(function() M._attAlign:Destroy() end); M._attAlign = nil end
    if M._speedTween then pcall(function() M._speedTween:Cancel() end); M._speedTween = nil end
end

function M.applySpeedMethod(hrp, hum, dir, spd, dt)
    local step = dt or 1/60
    local m = M.speedMethod
    if M._lastSpeedMethod ~= m then
        M.destroySpeedObjects()
        if m ~= "WalkSpeed" and hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
        M._lastSpeedMethod = m
    end
    local targetPos = hrp.Position + (dir * spd * step)

    local function massImpulse(direction, targetSpeed)
        local mass = hrp.AssemblyMass or 1
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(direction.X * targetSpeed, current.Y, direction.Z * targetSpeed)
        local delta = desired - current
        pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end)
    end

    if m == "Velocity" then
        massImpulse(dir, spd)
    elseif m == "AssemblyLinearVelocity" then
        massImpulse(dir, spd)
    elseif m == "Velocity Lerp" then
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd)
        local blended = current:Lerp(desired, 0.6)
        local mass = hrp.AssemblyMass or 1
        pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end)
    elseif m == "AssemblyLinearVelocity Lerp" then
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd)
        local blended = current:Lerp(desired, 0.6)
        local mass = hrp.AssemblyMass or 1
        pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end)
    elseif m == "CFrame" then
        hrp.CFrame = hrp.CFrame + (dir * spd * step)
    elseif m == "CFrame Lerp" then
        hrp.CFrame = hrp.CFrame:Lerp(hrp.CFrame + (dir * spd * step), 0.5)
    elseif m == "Hyper CFrame" then
        hrp.CFrame = hrp.CFrame + (dir * spd * (M.hyperMult or 4) * step)
    elseif m == "Anchored CFrame" then
        if not hrp.Anchored then
            hrp.Anchored = true
            M._anchoredBySpeed = hrp
        end
        hrp.CFrame = hrp.CFrame + (dir * spd * step)
    elseif m == "PivotTo" then
        hrp:PivotTo(hrp.CFrame + (dir * spd * step))
    elseif m == "Model PivotTo" then
        local char = hrp.Parent
        if char and char:IsA("Model") then
            char:PivotTo(char:GetPivot() + (dir * spd * step))
        else
            hrp:PivotTo(hrp.CFrame + (dir * spd * step))
        end
    elseif m == "Tween CFrame" then
        if M._speedTween then pcall(function() M._speedTween:Cancel() end) end
        M._speedTween = TweenService:Create(hrp, TweenInfo.new(step, Enum.EasingStyle.Linear), {CFrame = hrp.CFrame + (dir * spd * step)})
        M._speedTween:Play()
    elseif m == "WalkSpeed" then
        hum.WalkSpeed = spd
    elseif m == "Humanoid Move" then
        hum.WalkSpeed = spd
        hum:Move(dir)
    elseif m == "Humanoid MoveTo" then
        hum:MoveTo(targetPos, hrp)
    elseif m == "BodyVelocity" then
        if not M._bodyVel or M._bodyVel.Parent ~= hrp then
            if M._bodyVel then pcall(function() M._bodyVel:Destroy() end) end
            M._bodyVel = Instance.new("BodyVelocity")
            M._bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            M._bodyVel.Parent = hrp
        end
        M._bodyVel.Velocity = Vector3.new(dir.X*spd, M._bodyVel.Velocity.Y, dir.Z*spd)
    elseif m == "BodyPosition" then
        if not M._bodyPosition or M._bodyPosition.Parent ~= hrp then
            if M._bodyPosition then pcall(function() M._bodyPosition:Destroy() end) end
            M._bodyPosition = Instance.new("BodyPosition")
            M._bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            M._bodyPosition.P = 500
            M._bodyPosition.D = 50
            M._bodyPosition.Parent = hrp
        end
        M._bodyPosition.Position = targetPos
    elseif m == "BodyForce" then
        if not M._bodyForce or M._bodyForce.Parent ~= hrp then
            if M._bodyForce then pcall(function() M._bodyForce:Destroy() end) end
            M._bodyForce = Instance.new("BodyForce")
            M._bodyForce.Parent = hrp
        end
        M._bodyForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
    elseif m == "BodyThrust" then
        if not M._bodyThrust or M._bodyThrust.Parent ~= hrp then
            if M._bodyThrust then pcall(function() M._bodyThrust:Destroy() end) end
            M._bodyThrust = Instance.new("BodyThrust")
            M._bodyThrust.Force = Vector3.new(math.huge, math.huge, math.huge)
            M._bodyThrust.Parent = hrp
        end
        M._bodyThrust.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
    elseif m == "LinearVelocity" then
        if not M._linearVel or M._linearVel.Parent ~= hrp then
            if M._linearVel then pcall(function() M._linearVel:Destroy() end) end
            local att = Instance.new("Attachment")
            att.Name = "MoveeLinVelAtt"
            att.Parent = hrp
            M._attLinVel = att
            M._linearVel = Instance.new("LinearVelocity")
            M._linearVel.Attachment0 = att
            M._linearVel.MaxForce = 1e8
            M._linearVel.RelativeTo = Enum.ActuatorRelativeTo.World
            M._linearVel.Parent = hrp
        end
        M._linearVel.VectorVelocity = Vector3.new(dir.X*spd, M._linearVel.VectorVelocity.Y, dir.Z*spd)
    elseif m == "VectorForce" then
        if not M._vectorForce or M._vectorForce.Parent ~= hrp then
            if M._vectorForce then pcall(function() M._vectorForce:Destroy() end) end
            local att = Instance.new("Attachment")
            att.Name = "MoveeVecForceAtt"
            att.Parent = hrp
            M._attVecForce = att
            M._vectorForce = Instance.new("VectorForce")
            M._vectorForce.Attachment0 = att
            M._vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
            M._vectorForce.Parent = hrp
        end
        M._vectorForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
    elseif m == "AlignPosition" then
        if not M._alignPos or M._alignPos.Parent ~= hrp then
            if M._alignPos then pcall(function() M._alignPos:Destroy() end) end
            local att = Instance.new("Attachment")
            att.Name = "MoveeAlignAtt"
            att.Parent = hrp
            M._attAlign = att
            M._alignPos = Instance.new("AlignPosition")
            M._alignPos.Attachment0 = att
            M._alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
            M._alignPos.MaxForce = math.huge
            M._alignPos.Responsiveness = 15
            M._alignPos.RigidityEnabled = false
            M._alignPos.Parent = hrp
        end
        M._alignPos.Position = targetPos
    elseif m == "ApplyImpulse" then
        local mass = hrp.AssemblyMass or 1
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(dir.X * spd, current.Y, dir.Z * spd)
        local delta = desired - current
        pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end)
    elseif m == "RocketPropulsion" then
        if not M._rocket or M._rocket.Parent ~= hrp or not M._rocketTarget then
            if M._rocket then pcall(function() M._rocket:Destroy() end) end
            if M._rocketTarget then pcall(function() M._rocketTarget:Destroy() end) end
            M._rocketTarget = Instance.new("Part")
            M._rocketTarget.Name = "MoveeRocketTarget"
            M._rocketTarget.Anchored = true
            M._rocketTarget.CanCollide = false
            M._rocketTarget.Transparency = 1
            M._rocketTarget.Size = Vector3.new(1,1,1)
            M._rocketTarget.Parent = workspace
            M._rocket = Instance.new("RocketPropulsion")
            M._rocket.MaxThrust = 3000
            M._rocket.MaxTorque = 1000
            M._rocket.ThrustP = 100
            M._rocket.ThrustD = 20
            M._rocket.TurnP = 100
            M._rocket.TurnD = 10
            M._rocket.Target = M._rocketTarget
            M._rocket.Parent = hrp
        end
        M._rocketTarget.Position = targetPos
        pcall(function() M._rocket:Fire() end)
    end
end

-- ============================================================
-- AUTO SPEED MONITOR
-- ============================================================
function M.startAutoSpeedMonitor()
    if M._autoSpeedMonitor then return end
    M._autoSpeedMonitor = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        
        local currentWS = hum.WalkSpeed or 0
        
        if M.autoCarryEnabled and currentWS < M.AUTO_CARRY_THRESHOLD and currentWS > 0 then
            if not M.carrySpeedActive and not M.laggerCarryActive then
                M.carrySpeedActive = true
                M.laggerCarryActive = false
                if setAutoCarry then setAutoCarry(true) end
                if setAutoCarryToggle then setAutoCarryToggle(true) end
            end
        elseif currentWS >= M.AUTO_CARRY_THRESHOLD then
            if M.carrySpeedActive and not M.laggerCarryActive then
                M.carrySpeedActive = false
                if setAutoCarry then setAutoCarry(false) end
                if setAutoCarryToggle then setAutoCarryToggle(false) end
            end
        end
        
        M._lastWalkSpeed = currentWS
    end)
end

-- ============================================================
-- KEYBIND HANDLER
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if _anyKeyListening then return end
    
    if M.speedKey and input.KeyCode == M.speedKey and input.UserInputType == Enum.UserInputType.Keyboard then
        M.manualCarryActive = not M.manualCarryActive
        
        if M.manualCarryActive then
            M.carrySpeedActive = false
            M.laggerCarryActive = false
            M.laggerModeEnabled = false
            if setLagger then setLagger(false) end
            if setLaggerCarry then setLaggerCarry(false) end
            if setAutoCarry then setAutoCarry(false) end
            if setAutoCarryToggle then setAutoCarryToggle(false) end
            if setCarryFloat then setCarryFloat(true) end
            if carryFloatBtn then
                carryFloatBtn.BackgroundColor3 = LILAC
                carryFloatGrad.Enabled = true
            end
        else
            if setCarryFloat then setCarryFloat(false) end
            if carryFloatBtn then
                carryFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                carryFloatGrad.Enabled = false
            end
        end
        
        if setAutoCarry then setAutoCarry(M.manualCarryActive) end
        if setAutoCarryToggle then setAutoCarryToggle(M.manualCarryActive) end
    end
    
    if M.laggerKey and input.KeyCode == M.laggerKey and input.UserInputType == Enum.UserInputType.Keyboard then
        M.laggerModeEnabled = not M.laggerModeEnabled
        
        if M.laggerModeEnabled then
            M.laggerCarryActive = false
            M.carrySpeedActive = false
            M.manualCarryActive = false
            if setAutoCarry then setAutoCarry(false) end
            if setAutoCarryToggle then setAutoCarryToggle(false) end
            if setLaggerCarry then setLaggerCarry(false) end
            if setCarryFloat then setCarryFloat(false) end
            if carryFloatBtn then
                carryFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                carryFloatGrad.Enabled = false
            end
            if setLaggerFloat then setLaggerFloat(true) end
            if laggerFloatBtn then
                laggerFloatBtn.BackgroundColor3 = LILAC
                laggerFloatGrad.Enabled = true
            end
        else
            if setLaggerFloat then setLaggerFloat(false) end
            if laggerFloatBtn then
                laggerFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                laggerFloatGrad.Enabled = false
            end
        end
        
        if setLagger then setLagger(M.laggerModeEnabled) end
    end
    
    if autoMoveState.autoLeftKey and input.KeyCode == autoMoveState.autoLeftKey and input.UserInputType == Enum.UserInputType.Keyboard then
        if not UserInputService:GetFocusedTextBox() then
            toggleAutoLeft()
        end
    end
    
    if autoMoveState.autoRightKey and input.KeyCode == autoMoveState.autoRightKey and input.UserInputType == Enum.UserInputType.Keyboard then
        if not UserInputService:GetFocusedTextBox() then
            toggleAutoRight()
        end
    end
    
    if batAimbotKey and input.KeyCode == batAimbotKey and input.UserInputType == Enum.UserInputType.Keyboard then
        if not UserInputService:GetFocusedTextBox() then
            batAimbotEnabled = not batAimbotEnabled
            if batAimbotEnabled then
                startBatAimbot()
                if setBatAimbot then setBatAimbot(true) end
                if batFloatBtn then
                    batFloatBtn.BackgroundColor3 = LILAC
                    batFloatGrad.Enabled = true
                end
            else
                stopBatAimbot()
                if setBatAimbot then setBatAimbot(false) end
                if batFloatBtn then
                    batFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    batFloatGrad.Enabled = false
                end
            end
        end
    end
    
    if tpBatKey and input.KeyCode == tpBatKey and input.UserInputType == Enum.UserInputType.Keyboard then
        if not UserInputService:GetFocusedTextBox() then
            toggleTPBat()
        end
    end
    
    if manualTPKeybind.kb and input.KeyCode == manualTPKeybind.kb and input.UserInputType == Enum.UserInputType.Keyboard then
        if not UserInputService:GetFocusedTextBox() then
            runManualTP()
        end
    end
    
    if dropBrainrotKeybind.kb and input.KeyCode == dropBrainrotKeybind.kb and input.UserInputType == Enum.UserInputType.Keyboard then
        if not UserInputService:GetFocusedTextBox() then
            runDropBrainrot()
        end
    end
    
    -- Toggle Semi Mode with G key
    if input.KeyCode == Enum.KeyCode.G and not UserInputService:GetFocusedTextBox() then
        toggleStealMode()
    end
end)

-- ============================================================
-- SETUP INFINITE JUMP
-- ============================================================
setupInfiniteJump()

-- ============================================================
-- BUILD GUI CONTENT
-- ============================================================
-- AUTO SPEED Section
local autoSpeedSection = Instance.new("Frame", content)
autoSpeedSection.Size = UDim2.new(1, 0, 0, 18)
autoSpeedSection.BackgroundTransparency = 1

local autoSpeedLabel = Instance.new("TextLabel", autoSpeedSection)
autoSpeedLabel.Size = UDim2.new(1, 0, 1, 0)
autoSpeedLabel.BackgroundTransparency = 1
autoSpeedLabel.Text = "AUTO SPEED"
autoSpeedLabel.TextColor3 = LILAC
autoSpeedLabel.Font = Enum.Font.GothamBold
autoSpeedLabel.TextSize = 9
autoSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local autoCarryRow, setAutoCarry, setAutoCarryToggle = createToggleRow(content, "Auto Carry Speed", false, function(on)
    M.autoCarryEnabled = on
    if on then
        M.manualCarryActive = false
        M.carrySpeedActive = false
        M.laggerCarryActive = false
        if setLagger then setLagger(false) end
        if setLaggerCarry then setLaggerCarry(false) end
        if setCarryFloat then setCarryFloat(false) end
        if carryFloatBtn then
            carryFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            carryFloatGrad.Enabled = false
        end
    else
        M.carrySpeedActive = false
        if setAutoCarryToggle then setAutoCarryToggle(false) end
    end
end)
M.autoCarryEnabled = false

-- MOVEMENTS Section
createSectionHeader(content, "MOVEMENTS")

local _, normalInput = createRow(content, "Normal Speed", M.NS, function(v)
    M.NS = v
end)

local _, carryInput = createRow(content, "Carry Speed", M.CS, function(v)
    M.CS = v
end)

local speedKeyRow, speedKeyBox = createKeybindRow(content, "Speed Key", "NONE", function(key)
    M.speedKey = key
end)

-- LAGGER Section
createSectionHeader(content, "LAGGER")

local laggerKeyRow, laggerKeyBox = createKeybindRow(content, "Lagger Key", "NONE", function(key)
    M.laggerKey = key
end)

local _, laggerInput = createRow(content, "Lagger Speed", M.LAGGER_SPEED, function(v)
    M.LAGGER_SPEED = v
end)

local _, laggerCarryInput = createRow(content, "Lagger Carry", M.LAGGER_CARRY_SPEED, function(v)
    M.LAGGER_CARRY_SPEED = math.min(v, 23)
end)

local _, setLagger = createToggleRow(content, "Lagger Mode", M.laggerModeEnabled, function(on)
    M.laggerModeEnabled = on
    if on then 
        M.laggerCarryActive = false
        M.carrySpeedActive = false
        M.manualCarryActive = false
        if setAutoCarry then setAutoCarry(false) end
        if setAutoCarryToggle then setAutoCarryToggle(false) end
        if setCarryFloat then setCarryFloat(false) end
        if carryFloatBtn then
            carryFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            carryFloatGrad.Enabled = false
        end
        if setLaggerFloat then setLaggerFloat(true) end
        if laggerFloatBtn then
            laggerFloatBtn.BackgroundColor3 = LILAC
            laggerFloatGrad.Enabled = true
        end
    else
        if setLaggerFloat then setLaggerFloat(false) end
        if laggerFloatBtn then
            laggerFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            laggerFloatGrad.Enabled = false
        end
    end
end)

local _, setLaggerCarry = createToggleRow(content, "Lagger Carry", M.laggerCarryActive, function(on)
    M.laggerCarryActive = on
    if on then
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
        M.manualCarryActive = false
        if setAutoCarry then setAutoCarry(false) end
        if setAutoCarryToggle then setAutoCarryToggle(false) end
        if setLagger then setLagger(false) end
        if setLaggerFloat then setLaggerFloat(false) end
        if laggerFloatBtn then
            laggerFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            laggerFloatGrad.Enabled = false
        end
        if setCarryFloat then setCarryFloat(false) end
        if carryFloatBtn then
            carryFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            carryFloatGrad.Enabled = false
        end
        if setLaggerCarryFloat then setLaggerCarryFloat(true) end
        if laggerCarryFloatBtn then
            laggerCarryFloatBtn.BackgroundColor3 = LILAC
            laggerCarryFloatGrad.Enabled = true
        end
    else
        if setLaggerCarryFloat then setLaggerCarryFloat(false) end
        if laggerCarryFloatBtn then
            laggerCarryFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            laggerCarryFloatGrad.Enabled = false
        end
    end
end)

-- AUTO LEFT/RIGHT Section
createSectionHeader(content, "AUTO L/R")

local autoLeftKeyRow, autoLeftKeyBox = createKeybindRow(content, "Auto Left Key", "L", function(key)
    autoMoveState.autoLeftKey = key
end)

local autoRightKeyRow, autoRightKeyBox = createKeybindRow(content, "Auto Right Key", "R", function(key)
    autoMoveState.autoRightKey = key
end)

local _, setAutoLeft = createToggleRow(content, "Auto Left", false, function(on)
    if on then
        toggleAutoLeft()
    else
        if autoMoveState.autoLeftEnabled then
            toggleAutoLeft()
        end
    end
end)

local _, setAutoRight = createToggleRow(content, "Auto Right", false, function(on)
    if on then
        toggleAutoRight()
    else
        if autoMoveState.autoRightEnabled then
            toggleAutoRight()
        end
    end
end)

-- AUTO STEAL Section
createSectionHeader(content, "AUTO STEAL")

-- Steal Mode Selector
local modeRow = Instance.new("Frame", content)
modeRow.Size = UDim2.new(1, 0, 0, 28)
modeRow.BackgroundColor3 = ROW_FILL
modeRow.BackgroundTransparency = 0
modeRow.BorderSizePixel = 0
Instance.new("UICorner", modeRow).CornerRadius = UDim.new(0, 6)

local modeStroke = Instance.new("UIStroke", modeRow)
modeStroke.Color = BORDER_COLOR
modeStroke.Thickness = 1
modeStroke.Transparency = 0.3

local modeLabel = Instance.new("TextLabel", modeRow)
modeLabel.Size = UDim2.new(0.5, -6, 1, 0)
modeLabel.Position = UDim2.new(0, 6, 0, 0)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "Steal Mode: Normal"
modeLabel.TextColor3 = MAIN_TEXT
modeLabel.Font = Enum.Font.GothamBold
modeLabel.TextSize = 8
modeLabel.TextXAlignment = Enum.TextXAlignment.Left

local modeToggle = Instance.new("TextButton", modeRow)
modeToggle.Size = UDim2.new(0.35, -4, 0, 20)
modeToggle.Position = UDim2.new(0.65, -4, 0.5, -10)
modeToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
modeToggle.BorderSizePixel = 0
modeToggle.Text = "Switch to Semi"
modeToggle.TextColor3 = MAIN_TEXT
modeToggle.Font = Enum.Font.GothamBold
modeToggle.TextSize = 7
Instance.new("UICorner", modeToggle).CornerRadius = UDim.new(0, 5)

local function updateModeButton()
    if selectedStealMode == "Semi" then
        modeToggle.Text = "Switch to Normal"
        modeLabel.Text = "Steal Mode: Semi"
        modeToggle.BackgroundColor3 = LILAC
        modeToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
    else
        modeToggle.Text = "Switch to Semi"
        modeLabel.Text = "Steal Mode: Normal"
        modeToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        modeToggle.TextColor3 = MAIN_TEXT
    end
end

modeToggle.MouseButton1Click:Connect(function()
    toggleStealMode()
    updateModeButton()
end)

setStealMode = function(mode)
    selectedStealMode = mode
    updateModeButton()
end

-- Steal Radius
local _, radiusInput = createRow(content, "Steal Radius", Steal.StealRadius, function(v)
    Steal.StealRadius = v
    if stealProgressFrame then
        local radiusLabel = stealProgressFrame:FindFirstChildOfClass("TextLabel")
        if radiusLabel and radiusLabel.Text:find("Radius") then
            radiusLabel.Text = "Radius: " .. v
        end
    end
end)

-- Steal Duration
local _, durationInput = createRow(content, "Steal Duration", Steal.StealDuration, function(v)
    Steal.StealDuration = v
end)

-- COMBAT Section
createSectionHeader(content, "COMBAT")

local _, setUnwalk = createToggleRow(content, "Unwalk", false, function(on)
    unwalkEnabled = on
    if on then
        startUnwalk()
    else
        stopUnwalk()
    end
end)

local _, setBatCounter = createToggleRow(content, "Bat Counter", false, function(on)
    batCounterEnabled = on
    if on then
        startBatCounter()
    else
        stopBatCounter()
    end
end)

local _, setMedusaCounter = createToggleRow(content, "Medusa Counter", false, function(on)
    medusaCounterEnabled = on
    if on then
        setupMedusa(LocalPlayer.Character)
    else
        stopMedusaCounter()
    end
end)

local _, setAntiRagdoll = createToggleRow(content, "Anti-Ragdoll", false, function(on)
    antiRagdollEnabled = on
    if on then
        startAntiRagdoll()
    else
        stopAntiRagdoll()
    end
end)

local _, setInfJump = createToggleRow(content, "Infinite Jump", false, function(on)
    infJumpEnabled = on
    if not infJumpEnabled then
        stopInfJumpHoldState()
    end
end)

local _, setHitHarder = createToggleRow(content, "Hit Harder Anim", false, function(on)
    if on then
        enableHitHarderAnim()
    else
        disableHitHarderAnim()
    end
end)

-- BAT AIMBOT Section
createSectionHeader(content, "BAT AIMBOT")

local batKeyRow, batKeyBox = createKeybindRow(content, "Bat Key", "Q", function(key)
    batAimbotKey = key
end)

local _, setBatAimbot = createToggleRow(content, "Bat Aimbot", false, function(on)
    batAimbotEnabled = on
    if on then
        startBatAimbot()
    else
        stopBatAimbot()
    end
end)

local _, setAutoSwing = createToggleRow(content, "Auto Swing", false, function(on)
    batAimbotAutoSwing = on
end)

-- TP BAT Section
createSectionHeader(content, "TP BAT")

local tpBatKeyRow, tpBatKeyBox = createKeybindRow(content, "TP Bat Key", "T", function(key)
    tpBatKey = key
end)

local _, setTPBat = createToggleRow(content, "TP Bat", false, function(on)
    if on then
        enableTPBat()
    else
        disableTPBat()
    end
end)

-- TP DOWN Section
createSectionHeader(content, "TP DOWN")

local tpKeyRow, tpKeyBox = createKeybindRow(content, "TP Key", "F", function(key)
    manualTPKeybind.kb = key
end)

local tpBtnRow = Instance.new("Frame", content)
tpBtnRow.Size = UDim2.new(1, 0, 0, 28)
tpBtnRow.BackgroundColor3 = ROW_FILL
tpBtnRow.BackgroundTransparency = 0
tpBtnRow.BorderSizePixel = 0
Instance.new("UICorner", tpBtnRow).CornerRadius = UDim.new(0, 6)

local tpBtnStroke = Instance.new("UIStroke", tpBtnRow)
tpBtnStroke.Color = BORDER_COLOR
tpBtnStroke.Thickness = 1
tpBtnStroke.Transparency = 0.3

local tpBtnLabel = Instance.new("TextLabel", tpBtnRow)
tpBtnLabel.Size = UDim2.new(0.7, -6, 1, 0)
tpBtnLabel.Position = UDim2.new(0, 6, 0, 0)
tpBtnLabel.BackgroundTransparency = 1
tpBtnLabel.Text = "TP Button"
tpBtnLabel.TextColor3 = MAIN_TEXT
tpBtnLabel.Font = Enum.Font.GothamBold
tpBtnLabel.TextSize = 8
tpBtnLabel.TextXAlignment = Enum.TextXAlignment.Left

local tpActionBtn = Instance.new("TextButton", tpBtnRow)
tpActionBtn.Size = UDim2.new(0.2, -4, 0, 20)
tpActionBtn.Position = UDim2.new(0.8, -4, 0.5, -10)
tpActionBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
tpActionBtn.BorderSizePixel = 0
tpActionBtn.Text = "TP DOWN"
tpActionBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
tpActionBtn.Font = Enum.Font.GothamBold
tpActionBtn.TextSize = 7
Instance.new("UICorner", tpActionBtn).CornerRadius = UDim.new(0, 5)

tpActionBtn.MouseButton1Click:Connect(function()
    runManualTP()
    TweenService:Create(tpActionBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        TextColor3 = Color3.fromRGB(200, 150, 255)
    }):Play()
    task.delay(0.2, function()
        TweenService:Create(tpActionBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(200, 150, 255),
            TextColor3 = Color3.fromRGB(0, 0, 0)
        }):Play()
    end)
end)

-- AUTO TP DOWN Section
createSectionHeader(content, "AUTO TP DOWN")

local _, setAutoTPDown = createToggleRow(content, "Auto TP Down", false, function(on)
    autoTPDownEnabled = on
    if on then
        startAutoTPDown()
    else
        stopAutoTPDown()
    end
end)

local _, heightInput = createRow(content, "TP Height", autoTPDownHeight, function(v)
    autoTPDownHeight = v
end)

-- BRAINROT DROP Section
createSectionHeader(content, "BRAINROT DROP")

local dropKeyRow, dropKeyBox = createKeybindRow(content, "Drop Key", "G", function(key)
    dropBrainrotKeybind.kb = key
end)

local dropBtnRow = Instance.new("Frame", content)
dropBtnRow.Size = UDim2.new(1, 0, 0, 28)
dropBtnRow.BackgroundColor3 = ROW_FILL
dropBtnRow.BackgroundTransparency = 0
dropBtnRow.BorderSizePixel = 0
Instance.new("UICorner", dropBtnRow).CornerRadius = UDim.new(0, 6)

local dropBtnStroke = Instance.new("UIStroke", dropBtnRow)
dropBtnStroke.Color = BORDER_COLOR
dropBtnStroke.Thickness = 1
dropBtnStroke.Transparency = 0.3

local dropBtnLabel = Instance.new("TextLabel", dropBtnRow)
dropBtnLabel.Size = UDim2.new(0.7, -6, 1, 0)
dropBtnLabel.Position = UDim2.new(0, 6, 0, 0)
dropBtnLabel.BackgroundTransparency = 1
dropBtnLabel.Text = "Drop Button"
dropBtnLabel.TextColor3 = MAIN_TEXT
dropBtnLabel.Font = Enum.Font.GothamBold
dropBtnLabel.TextSize = 8
dropBtnLabel.TextXAlignment = Enum.TextXAlignment.Left

local dropActionBtn = Instance.new("TextButton", dropBtnRow)
dropActionBtn.Size = UDim2.new(0.2, -4, 0, 20)
dropActionBtn.Position = UDim2.new(0.8, -4, 0.5, -10)
dropActionBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
dropActionBtn.BorderSizePixel = 0
dropActionBtn.Text = "DROP"
dropActionBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
dropActionBtn.Font = Enum.Font.GothamBold
dropActionBtn.TextSize = 8
Instance.new("UICorner", dropActionBtn).CornerRadius = UDim.new(0, 5)

dropActionBtn.MouseButton1Click:Connect(function()
    runDropBrainrot()
    TweenService:Create(dropActionBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        TextColor3 = Color3.fromRGB(200, 150, 255)
    }):Play()
    task.delay(0.2, function()
        TweenService:Create(dropActionBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(200, 150, 255),
            TextColor3 = Color3.fromRGB(0, 0, 0)
        }):Play()
    end)
end)

local spacer = Instance.new("Frame", content)
spacer.Size = UDim2.new(1, 0, 0, 4)
spacer.BackgroundTransparency = 1

-- ============================================================
-- SPEED LOOP
-- ============================================================
RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    
    if M.isRagdollState(hum) then
        M.lastMoveDir = Vector3.new(0,0,0)
        M.destroySpeedObjects()
        return
    end
    
    local md = hum.MoveDirection
    local spd = M.getActiveMoveSpeed()
    local dir = Vector3.new(0,0,0)
    
    if md.Magnitude > 0 then
        M.lastMoveDir = md
        dir = md
    elseif M.lastMoveDir.Magnitude > 0 then
        local anyHeld = false
        for key in pairs(M.MOVE_KEYS) do
            if UserInputService:IsKeyDown(key) then anyHeld = true; break end
        end
        if anyHeld then dir = M.lastMoveDir end
    end
    
    if dir.Magnitude > 0 then
        M.applySpeedMethod(hrp, hum, dir, spd, dt)
    else
        M.destroySpeedObjects()
    end
end)

M.startAutoSpeedMonitor()

-- ============================================================
-- FLOATING BUTTONS (2 Columns x 5 Rows - 72x58)
-- ============================================================
local function createFloatingButtons()
    local BTN_SIZE_X = 72
    local BTN_SIZE_Y = 58
    local PADDING = 6
    local BTN_GAP = 5
    local COL_GAP = 8

    local function createFloatingButton(text, posX, posY, callback, isToggle)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, BTN_SIZE_X, 0, BTN_SIZE_Y)
        btn.Position = UDim2.new(1, posX, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 9
        btn.Font = Enum.Font.GothamBold
        btn.TextWrapped = true
        btn.LineHeight = 1.1
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ZIndex = 99
        btn.Parent = gui
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        local gradient = Instance.new("UIGradient", btn)
        gradient.Rotation = 90
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.3, 0),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(0.7, 0),
            NumberSequenceKeypoint.new(1, 0),
        })
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 150, 255)),
            ColorSequenceKeypoint.new(0.3, Color3.fromRGB(230, 200, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.7, Color3.fromRGB(230, 200, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 255)),
        })
        gradient.Enabled = false
        
        local fDragging, fDragInput, fDragStart, fStartPos = false, nil, nil, nil
        
        btn.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                fDragging = true
                fDragStart = inp.Position
                fStartPos = btn.Position
                inp.Changed:Connect(function()
                    if inp.UserInputState == Enum.UserInputState.End then
                        fDragging = false
                    end
                end)
            end
        end)
        
        btn.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                fDragInput = inp
            end
        end)
        
        UserInputService.InputChanged:Connect(function(inp)
            if inp == fDragInput and fDragging then
                local delta = inp.Position - fDragStart
                btn.Position = UDim2.new(
                    fStartPos.X.Scale,
                    fStartPos.X.Offset + delta.X,
                    fStartPos.Y.Scale,
                    fStartPos.Y.Offset + delta.Y
                )
            end
        end)
        
        if isToggle then
            local state = false
            
            btn.Activated:Connect(function()
                state = not state
                if state then
                    btn.BackgroundColor3 = LILAC
                    gradient.Enabled = true
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    gradient.Enabled = false
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
                if callback then callback(state) end
            end)
            
            return btn, gradient, function(s)
                state = s
                if state then
                    btn.BackgroundColor3 = LILAC
                    gradient.Enabled = true
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    gradient.Enabled = false
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        else
            btn.Activated:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {
                    BackgroundColor3 = LILAC_WHITE,
                    TextColor3 = LILAC_DARK
                }):Play()
                gradient.Enabled = true
                
                task.delay(0.2, function()
                    TweenService:Create(btn, TweenInfo.new(0.15), {
                        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                        TextColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                    gradient.Enabled = false
                end)
                
                if callback then callback() end
            end)
            
            return btn, gradient
        end
    end

    local startX1 = -(BTN_SIZE_X + PADDING + 8)
    local startX2 = -(BTN_SIZE_X * 2 + COL_GAP + PADDING + 8)
    local startY = 80
    local btnSpacing = BTN_SIZE_Y + BTN_GAP

    -- ============================================================
    -- COLUMN 1 (Right side - Closest to screen edge)
    -- ============================================================
    -- Row 1: AUTO LEFT (Toggle)
    local autoLeftFloatBtn, autoLeftFloatGrad, setAutoLeftFloat = createFloatingButton("AUTO\nLEFT", startX1, startY, function(on)
        if on then
            toggleAutoLeft()
        else
            if autoMoveState.autoLeftEnabled then
                toggleAutoLeft()
            end
        end
    end, true)

    -- Row 2: AUTO RIGHT (Toggle)
    local autoRightFloatBtn, autoRightFloatGrad, setAutoRightFloat = createFloatingButton("AUTO\nRIGHT", startX1, startY + btnSpacing, function(on)
        if on then
            toggleAutoRight()
        else
            if autoMoveState.autoRightEnabled then
                toggleAutoRight()
            end
        end
    end, true)

    -- Row 3: BAT AIMBOT (Toggle)
    local batFloatBtn, batFloatGrad, setBatFloat = createFloatingButton("BAT\nAIMBOT", startX1, startY + (btnSpacing * 2), function(on)
        batAimbotEnabled = on
        if on then
            startBatAimbot()
            if setBatAimbot then setBatAimbot(true) end
        else
            stopBatAimbot()
            if setBatAimbot then setBatAimbot(false) end
        end
    end, true)

    -- Row 4: TP BAT (Toggle)
    local tpBatFloatBtn, tpBatFloatGrad, setTPBatFloat = createFloatingButton("TP\nBAT", startX1, startY + (btnSpacing * 3), function(on)
        if on then
            enableTPBat()
        else
            disableTPBat()
        end
        if setTPBat then setTPBat(on) end
    end, true)

    -- Row 5: TP DOWN (Action)
    local tpFloatBtn, tpFloatGrad = createFloatingButton("TP\nDOWN", startX1, startY + (btnSpacing * 4), function()
        runManualTP()
    end, false)

    -- ============================================================
    -- COLUMN 2 (Left side)
    -- ============================================================
    -- Row 1: CARRY (Toggle)
    local carryFloatBtn, carryFloatGrad, setCarryFloat = createFloatingButton("CARRY", startX2, startY, function(on)
        M.manualCarryActive = on
        if on then
            M.carrySpeedActive = false
            M.laggerCarryActive = false
            M.laggerModeEnabled = false
            if setLagger then setLagger(false) end
            if setLaggerCarry then setLaggerCarry(false) end
            if setAutoCarry then setAutoCarry(false) end
            if setAutoCarryToggle then setAutoCarryToggle(false) end
            if setLaggerFloat then setLaggerFloat(false) end
            if laggerFloatBtn then
                laggerFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                laggerFloatGrad.Enabled = false
            end
            if setLaggerCarryFloat then setLaggerCarryFloat(false) end
            if laggerCarryFloatBtn then
                laggerCarryFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                laggerCarryFloatGrad.Enabled = false
            end
        end
        if setAutoCarry then setAutoCarry(M.manualCarryActive) end
        if setAutoCarryToggle then setAutoCarryToggle(M.manualCarryActive) end
    end, true)

    -- Row 2: LAGGER MODE (Toggle)
    local laggerFloatBtn, laggerFloatGrad, setLaggerFloat = createFloatingButton("LAGGER", startX2, startY + btnSpacing, function(on)
        M.laggerModeEnabled = on
        if on then
            M.laggerCarryActive = false
            M.carrySpeedActive = false
            M.manualCarryActive = false
            if setAutoCarry then setAutoCarry(false) end
            if setAutoCarryToggle then setAutoCarryToggle(false) end
            if setLaggerCarry then setLaggerCarry(false) end
            if setCarryFloat then setCarryFloat(false) end
            if carryFloatBtn then
                carryFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                carryFloatGrad.Enabled = false
            end
            if setLaggerCarryFloat then setLaggerCarryFloat(false) end
            if laggerCarryFloatBtn then
                laggerCarryFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                laggerCarryFloatGrad.Enabled = false
            end
        end
        if setLagger then setLagger(M.laggerModeEnabled) end
    end, true)

    -- Row 3: LAGGER CARRY (Toggle)
    local laggerCarryFloatBtn, laggerCarryFloatGrad, setLaggerCarryFloat = createFloatingButton("LAGGER\nCARRY", startX2, startY + (btnSpacing * 2), function(on)
        M.laggerCarryActive = on
        if on then
            M.laggerModeEnabled = false
            M.carrySpeedActive = false
            M.manualCarryActive = false
            if setAutoCarry then setAutoCarry(false) end
            if setAutoCarryToggle then setAutoCarryToggle(false) end
            if setLagger then setLagger(false) end
            if setCarryFloat then setCarryFloat(false) end
            if carryFloatBtn then
                carryFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                carryFloatGrad.Enabled = false
            end
            if laggerFloatBtn then
                laggerFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                laggerFloatGrad.Enabled = false
            end
            if setLaggerFloat then setLaggerFloat(false) end
        end
        if setLaggerCarry then setLaggerCarry(M.laggerCarryActive) end
    end, true)

    -- Row 4: DROP (Action)
    local dropFloatBtn, dropFloatGrad = createFloatingButton("DROP", startX2, startY + (btnSpacing * 3), function()
        runDropBrainrot()
    end, false)

    -- Row 5: STEAL MODE (Action - Toggles Normal/Semi)
    local stealFloatBtn, stealFloatGrad = createFloatingButton("STEAL\nMODE", startX2, startY + (btnSpacing * 4), function()
        toggleStealMode()
        updateModeButton()
        if selectedStealMode == "Semi" then
            stealFloatBtn.BackgroundColor3 = LILAC
            stealFloatGrad.Enabled = true
        else
            stealFloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            stealFloatGrad.Enabled = false
        end
    end, false)

    -- ============================================================
    -- RETURN ALL BUTTONS
    -- ============================================================
    return {
        autoLeftFloatBtn = autoLeftFloatBtn,
        autoLeftFloatGrad = autoLeftFloatGrad,
        setAutoLeftFloat = setAutoLeftFloat,
        autoRightFloatBtn = autoRightFloatBtn,
        autoRightFloatGrad = autoRightFloatGrad,
        setAutoRightFloat = setAutoRightFloat,
        batFloatBtn = batFloatBtn,
        batFloatGrad = batFloatGrad,
        setBatFloat = setBatFloat,
        tpBatFloatBtn = tpBatFloatBtn,
        tpBatFloatGrad = tpBatFloatGrad,
        setTPBatFloat = setTPBatFloat,
        tpFloatBtn = tpFloatBtn,
        tpFloatGrad = tpFloatGrad,
        dropFloatBtn = dropFloatBtn,
        dropFloatGrad = dropFloatGrad,
        carryFloatBtn = carryFloatBtn,
        carryFloatGrad = carryFloatGrad,
        setCarryFloat = setCarryFloat,
        laggerFloatBtn = laggerFloatBtn,
        laggerFloatGrad = laggerFloatGrad,
        setLaggerFloat = setLaggerFloat,
        laggerCarryFloatBtn = laggerCarryFloatBtn,
        laggerCarryFloatGrad = laggerCarryFloatGrad,
        setLaggerCarryFloat = setLaggerCarryFloat,
        stealFloatBtn = stealFloatBtn,
        stealFloatGrad = stealFloatGrad,
    }
end

-- ============================================================
-- CREATE FLOATING BUTTONS INSTANCES
-- ============================================================
local fb = createFloatingButtons()
autoLeftFloatBtn = fb.autoLeftFloatBtn
autoLeftFloatGrad = fb.autoLeftFloatGrad
setAutoLeftFloat = fb.setAutoLeftFloat
autoRightFloatBtn = fb.autoRightFloatBtn
autoRightFloatGrad = fb.autoRightFloatGrad
setAutoRightFloat = fb.setAutoRightFloat
batFloatBtn = fb.batFloatBtn
batFloatGrad = fb.batFloatGrad
setBatFloat = fb.setBatFloat
tpBatFloatBtn = fb.tpBatFloatBtn
tpBatFloatGrad = fb.tpBatFloatGrad
setTPBatFloat = fb.setTPBatFloat
tpFloatBtn = fb.tpFloatBtn
tpFloatGrad = fb.tpFloatGrad
dropFloatBtn = fb.dropFloatBtn
dropFloatGrad = fb.dropFloatGrad
carryFloatBtn = fb.carryFloatBtn
carryFloatGrad = fb.carryFloatGrad
setCarryFloat = fb.setCarryFloat
laggerFloatBtn = fb.laggerFloatBtn
laggerFloatGrad = fb.laggerFloatGrad
setLaggerFloat = fb.setLaggerFloat
laggerCarryFloatBtn = fb.laggerCarryFloatBtn
laggerCarryFloatGrad = fb.laggerCarryFloatGrad
setLaggerCarryFloat = fb.setLaggerCarryFloat
stealFloatBtn = fb.stealFloatBtn
stealFloatGrad = fb.stealFloatGrad

-- ============================================================
-- TOGGLE BUTTON FOR MAIN GUI (108x28 with text size 11)
-- ============================================================
local toggleBtn = Instance.new("Frame", gui)
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 108, 0, 28)
toggleBtn.Position = UDim2.new(0, 10, 0, 80)
toggleBtn.BackgroundColor3 = BG_FILL
toggleBtn.BackgroundTransparency = 0
toggleBtn.Active = true
toggleBtn.ClipsDescendants = true
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = BORDER_COLOR
toggleStroke.Thickness = 1.5
toggleStroke.Transparency = 0.3

local toggleDragging, toggleDragStart, toggleStartPos
toggleBtn.InputBegan:Connect(function(input)
    if guiLocked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = toggleBtn.Position
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                toggleDragging = false
                conn:Disconnect()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if guiLocked then return end
    if toggleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - toggleDragStart
        toggleBtn.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
    end
end)

local toggleLabel = Instance.new("TextLabel", toggleBtn)
toggleLabel.Size = UDim2.new(1, 0, 1, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "BakiiHubb"
toggleLabel.TextColor3 = LILAC
toggleLabel.Font = Enum.Font.GothamBlack
toggleLabel.TextSize = 11
toggleLabel.TextScaled = false

local toggleClick = Instance.new("TextButton", toggleBtn)
toggleClick.Size = UDim2.new(1, 0, 1, 0)
toggleClick.BackgroundTransparency = 1
toggleClick.Text = ""
toggleClick.ZIndex = 10

toggleClick.MouseButton1Click:Connect(function()
    if guiLocked then return end
    isMinimized = not isMinimized
    dp.Visible = isMinimized
end)

dp.Visible = true

-- ============================================================
-- INITIALIZE AUTO STEAL
-- ============================================================
createStealProgressBar()
startAutoSteal()

-- Update FPS and Ping for steal progress bar
RunService.RenderStepped:Connect(function()
    framesCount = framesCount + 1
    if tick() - last >= 1 then
        fps = framesCount
        framesCount = 0
        last = tick()
    end
    local ping = 0
    local network = Stats:FindFirstChild("Network")
    if network and network:FindFirstChild("ServerStatsItem") then
        local dataPing = network.ServerStatsItem:FindFirstChild("Data Ping")
        if dataPing then ping = math.floor(dataPing:GetValue()) end
    end
    if stealInfoLabel then
        stealInfoLabel.Text = "FPS: " .. fps .. " • discord.gg/7Uujw2kUCN • Ping: " .. ping .. "ms"
    end
end)

-- Keep auto steal running
task.spawn(function()
    while true do
        task.wait(5)
        if not autoStealConn and Steal.AutoStealEnabled then
            startAutoSteal()
        end
    end
end)

print("BAKII DUELS - All Features Loaded!")
print("  - Speed System")
print("  - Auto Left/Right (L/R keys)")
print("  - Bat Aimbot (Q key)")
print("  - TP Bat (T key)")
print("  - TP Down (F key)")
print("  - Auto TP Down")
print("  - Brainrot Drop (G key)")
print("  - Auto Steal (Always Enabled)")
print("  - Steal Mode: Normal / Semi (Toggle in GUI or press G)")
print("  - GUI: 300x480 | Toggle: 108x28 | Toggle Text Size: 11")
print("  - Floating buttons: 72x58 (2 columns x 5 rows)")
print("  - Lock button added (🔓/🔒)")
return M

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()