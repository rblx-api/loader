local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local TweenService= game:GetService("TweenService")
local UIS         = game:GetService("UserInputService")
local LP          = Players.LocalPlayer

local State = {
    enabled      = false,
    cooldown     = false,
    locked       = false,
}

-- ── Keybind configuration (customizable) ─────────────────────
local KeybindSettings = {
    toggle = Enum.KeyCode.V,   -- Default: V
}

-- Function to change keybind
local function setToggleKeybind(keyCode)
    KeybindSettings.toggle = keyCode
    updateKeybindDisplay()
end

-- ── Core helpers ──────────────────────────────────────────

local function getHRP()
    local char = LP.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getBat()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        tool = bp:FindFirstChild("Bat")
        if tool then tool.Parent = char; return tool end
    end
    return nil
end

local function tryHitBat()
    if State.cooldown then return end
    State.cooldown = true
    pcall(function()
        local bat = getBat()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function() State.cooldown = false end)
end

local function getClosestPlayer()
    local hrp = getHRP()
    if not hrp then return nil, math.huge end
    local cp, cd = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < cd then cd = d; cp = p end
            end
        end
    end
    return cp, cd
end

-- ── Aimbot loop ───────────────────────────────────────────

RunService.RenderStepped:Connect(function()
    if not State.enabled then return end
    local hrp = getHRP()
    if not hrp then return end
    local target, dist = getClosestPlayer()
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local fp  = tr.Position + tr.CFrame.LookVector * 1.5
            local dir = (fp - hrp.Position).Unit
            hrp.Velocity = Vector3.new(dir.X * 56.5, dir.Y * 56.5, dir.Z * 56.5)
            if dist <= 5 then tryHitBat() end
        end
    end
end)

-- ── Keybind handler ────────────────────────────────────────
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Toggle key (customizable)
    if input.KeyCode == KeybindSettings.toggle then
        setToggle(not State.enabled)
    end
end)

-- ── UI ────────────────────────────────────────────────────

-- Remove old instance if re-running
local OLD = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("SakuraGUI")
if OLD then OLD:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name          = "SakuraGUI"
gui.ResetOnSpawn  = false
gui.DisplayOrder  = 20
gui.IgnoreGuiInset= true
gui.Parent        = LP:WaitForChild("PlayerGui")

-- Main frame (slightly taller for keybind UI)
local frame = Instance.new("Frame", gui)
frame.Size              = UDim2.new(0, 220, 0, 155)
frame.Position          = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3  = Color3.fromRGB(26, 18, 22)
frame.BorderSizePixel   = 0
frame.Active            = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Color     = Color3.fromRGB(255, 183, 197)
stroke.Thickness = 1

-- Title
local title = Instance.new("TextLabel", frame)
title.Size               = UDim2.new(1, -12, 0, 28)
title.Position           = UDim2.new(0, 12, 0, 6)
title.BackgroundTransparency = 1
title.Text               = "SAKURA ANTI BYPASS"
title.TextColor3         = Color3.fromRGB(255, 145, 164)
title.Font               = Enum.Font.GothamBlack
title.TextSize           = 13
title.TextXAlignment     = Enum.TextXAlignment.Left

-- Status label
local statusLbl = Instance.new("TextLabel", frame)
statusLbl.Size               = UDim2.new(0.5, 0, 0, 20)
statusLbl.Position           = UDim2.new(0, 12, 0, 39)
statusLbl.BackgroundTransparency = 1
statusLbl.Text               = "OFF"
statusLbl.TextColor3         = Color3.fromRGB(160, 150, 155)
statusLbl.Font               = Enum.Font.GothamBold
statusLbl.TextSize           = 12
statusLbl.TextXAlignment     = Enum.TextXAlignment.Left

-- Toggle pill
local pillBg = Instance.new("Frame", frame)
pillBg.Size             = UDim2.new(0, 44, 0, 22)
pillBg.Position         = UDim2.new(1, -54, 0, 38)
pillBg.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
pillBg.BorderSizePixel  = 0
Instance.new("UICorner", pillBg).CornerRadius = UDim.new(1, 0)
local pillStroke = Instance.new("UIStroke", pillBg)
pillStroke.Color     = Color3.fromRGB(255, 183, 197)
pillStroke.Thickness = 1

local dot = Instance.new("Frame", pillBg)
dot.Size            = UDim2.new(0, 16, 0, 16)
dot.Position        = UDim2.new(0, 3, 0.5, -8)
dot.BackgroundColor3= Color3.fromRGB(180, 100, 130)
dot.BorderSizePixel = 0
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

-- Keybind setting section
local keybindSection = Instance.new("Frame", frame)
keybindSection.Size = UDim2.new(1, -24, 0, 40)
keybindSection.Position = UDim2.new(0, 12, 0, 68)
keybindSection.BackgroundColor3 = Color3.fromRGB(35, 25, 30)
keybindSection.BorderSizePixel = 0
Instance.new("UICorner", keybindSection).CornerRadius = UDim.new(0, 6)

local keybindLabel = Instance.new("TextLabel", keybindSection)
keybindLabel.Size = UDim2.new(0, 80, 1, 0)
keybindLabel.Position = UDim2.new(0, 10, 0, 0)
keybindLabel.BackgroundTransparency = 1
keybindLabel.Text = "Toggle Key:"
keybindLabel.TextColor3 = Color3.fromRGB(255, 183, 197)
keybindLabel.Font = Enum.Font.GothamBold
keybindLabel.TextSize = 11
keybindLabel.TextXAlignment = Enum.TextXAlignment.Left

local keybindValue = Instance.new("TextButton", keybindSection)
keybindValue.Size = UDim2.new(0, 60, 0, 28)
keybindValue.Position = UDim2.new(1, -70, 0.5, -14)
keybindValue.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
keybindValue.Text = "V"
keybindValue.TextColor3 = Color3.fromRGB(255, 255, 255)
keybindValue.Font = Enum.Font.GothamBold
keybindValue.TextSize = 12
keybindValue.BorderSizePixel = 0
Instance.new("UICorner", keybindValue).CornerRadius = UDim.new(0, 4)
local keybindStroke = Instance.new("UIStroke", keybindValue)
keybindStroke.Color = Color3.fromRGB(255, 183, 197)
keybindStroke.Thickness = 1

local keybindHint = Instance.new("TextLabel", keybindSection)
keybindHint.Size = UDim2.new(0, 100, 0, 12)
keybindHint.Position = UDim2.new(0, 10, 1, -14)
keybindHint.BackgroundTransparency = 1
keybindHint.Text = "(click to change)"
keybindHint.TextColor3 = Color3.fromRGB(130, 120, 125)
keybindHint.Font = Enum.Font.GothamMedium
keybindHint.TextSize = 8
keybindHint.TextXAlignment = Enum.TextXAlignment.Left

-- Waiting for keybind modal
local waitingFrame = nil
local function showWaitingForKey()
    if waitingFrame then waitingFrame:Destroy() end
    
    waitingFrame = Instance.new("Frame", gui)
    waitingFrame.Size = UDim2.new(0, 200, 0, 80)
    waitingFrame.Position = UDim2.new(0.5, -100, 0.5, -40)
    waitingFrame.BackgroundColor3 = Color3.fromRGB(26, 18, 22)
    waitingFrame.BackgroundTransparency = 0.1
    waitingFrame.BorderSizePixel = 0
    Instance.new("UICorner", waitingFrame).CornerRadius = UDim.new(0, 12)
    local waitStroke = Instance.new("UIStroke", waitingFrame)
    waitStroke.Color = Color3.fromRGB(255, 183, 197)
    waitStroke.Thickness = 2
    
    local waitText = Instance.new("TextLabel", waitingFrame)
    waitText.Size = UDim2.new(1, -20, 0, 30)
    waitText.Position = UDim2.new(0, 10, 0.3, 0)
    waitText.BackgroundTransparency = 1
    waitText.Text = "Press any key..."
    waitText.TextColor3 = Color3.fromRGB(255, 183, 197)
    waitText.Font = Enum.Font.GothamBold
    waitText.TextSize = 14
    
    local cancelBtn = Instance.new("TextButton", waitingFrame)
    cancelBtn.Size = UDim2.new(0, 60, 0, 25)
    cancelBtn.Position = UDim2.new(0.5, -30, 1, -35)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
    cancelBtn.Text = "Cancel"
    cancelBtn.TextColor3 = Color3.fromRGB(255, 183, 197)
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.TextSize = 11
    cancelBtn.BorderSizePixel = 0
    Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 4)
    
    local connection
    connection = UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            setToggleKeybind(input.KeyCode)
            if waitingFrame then waitingFrame:Destroy() end
            connection:Disconnect()
        end
    end)
    
    cancelBtn.MouseButton1Click:Connect(function()
        if waitingFrame then waitingFrame:Destroy() end
        connection:Disconnect()
    end)
end

local function updateKeybindDisplay()
    local keyName = KeybindSettings.toggle.Name
    keybindValue.Text = keyName
end

-- Keybind button click
keybindValue.MouseButton1Click:Connect(function()
    showWaitingForKey()
end)

-- Discord Link (Bottom Left)
local discordLbl = Instance.new("TextLabel", frame)
discordLbl.Size               = UDim2.new(0, 120, 0, 20)
discordLbl.Position           = UDim2.new(0, 12, 1, -26)
discordLbl.BackgroundTransparency = 1
discordLbl.Text               = "discord.gg/Jrp7UGpDux"
discordLbl.TextColor3         = Color3.fromRGB(255, 183, 197)
discordLbl.Font               = Enum.Font.GothamMedium
discordLbl.TextSize           = 10
discordLbl.TextXAlignment     = Enum.TextXAlignment.Left

-- Lock Button (Bottom Right)
local lockBtn = Instance.new("TextButton", frame)
lockBtn.Size            = UDim2.new(0, 60, 0, 22)
lockBtn.Position        = UDim2.new(1, -72, 1, -28)
lockBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
lockBtn.Text            = "🔒 LOCK"
lockBtn.TextColor3      = Color3.fromRGB(255, 183, 197)
lockBtn.Font            = Enum.Font.GothamBold
lockBtn.TextSize        = 10
lockBtn.BorderSizePixel = 0
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 6)
local lockStroke = Instance.new("UIStroke", lockBtn)
lockStroke.Color     = Color3.fromRGB(255, 183, 197)
lockStroke.Thickness = 1

-- Animation Constants
local C_ON_BG  = Color3.fromRGB(255, 145, 164)
local C_OFF_BG = Color3.fromRGB(45, 25, 35)
local C_WHITE  = Color3.fromRGB(255, 255, 255)
local C_DIM    = Color3.fromRGB(180, 100, 130)
local C_ACCENT2= Color3.fromRGB(255, 183, 197)
local C_BORDER = Color3.fromRGB(255, 145, 164)
local ti       = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
local tiBack   = TweenInfo.new(0.2, Enum.EasingStyle.Back)

local function setToggle(on)
    State.enabled = on
    statusLbl.Text      = on and "ON" or "OFF"
    statusLbl.TextColor3= on and Color3.fromRGB(255, 183, 197) or Color3.fromRGB(160, 150, 155)
    TweenService:Create(pillBg,    ti,     {BackgroundColor3 = on and C_ON_BG or C_OFF_BG}):Play()
    TweenService:Create(pillStroke,ti,     {Color            = on and C_ACCENT2 or C_BORDER}):Play()
    TweenService:Create(dot,       tiBack, {
        Position         = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = on and C_WHITE or C_DIM,
    }):Play()
end

local function setLock(locked)
    State.locked = locked
    if locked then
        lockBtn.Text = "🔓 UNLOCK"
        lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TweenService:Create(lockBtn, ti, {BackgroundColor3 = Color3.fromRGB(255, 80, 100)}):Play()
        TweenService:Create(lockStroke, ti, {Color = Color3.fromRGB(255, 255, 255)}):Play()
    else
        lockBtn.Text = "🔒 LOCK"
        lockBtn.TextColor3 = Color3.fromRGB(255, 183, 197)
        TweenService:Create(lockBtn, ti, {BackgroundColor3 = Color3.fromRGB(45, 25, 35)}):Play()
        TweenService:Create(lockStroke, ti, {Color = Color3.fromRGB(255, 183, 197)}):Play()
    end
end

-- Clickable overlay for toggle
local clk = Instance.new("TextButton", frame)
clk.Size               = UDim2.new(1, 0, 0, 44)
clk.Position           = UDim2.new(0, 0, 0, 27)
clk.BackgroundTransparency = 1
clk.Text               = ""
clk.ZIndex             = 5
clk.MouseButton1Click:Connect(function()
    setToggle(not State.enabled)
end)

-- Lock button click
lockBtn.MouseButton1Click:Connect(function()
    setLock(not State.locked)
end)

-- Drag (respects lock state)
do
    local dragging, dragStart, startPos = false, nil, nil
    frame.InputBegan:Connect(function(inp)
        if not State.locked and (inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch) then
            dragging  = true
            dragStart = inp.Position
            startPos  = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End
                or inp.UserInputState == Enum.UserInputState.Cancelled then
                    dragging = false
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch then
            local dx = inp.Position.X - dragStart.X
            local dy = inp.Position.Y - dragStart.Y
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + dx,
                startPos.Y.Scale, startPos.Y.Offset + dy
            )
        end
    end)
end

-- Initial setup
setLock(false)
updateKeybindDisplay()

-- ===================== END =====================