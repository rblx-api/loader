local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UIS              = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local _isfile    = isfile   or (syn and syn.isfile)   or function() return false end
local _readfile  = readfile  or (syn and syn.readfile)  or function() return nil  end
local _writefile = writefile or (syn and syn.writefile) or function() end
local getconnections = getconnections or get_signal_cons or getconnects
                    or (syn and syn.get_signal_cons)

local function tween(obj, duration, props)
    TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local CLR = {
    Background   = Color3.fromRGB(15,  15,  18),
    Topbar       = Color3.fromRGB(8,   8,   10),
    SideBar      = Color3.fromRGB(10,  10,  13),
    TabPanel     = Color3.fromRGB(15,  15,  18),
    TabBtn       = Color3.fromRGB(37,  37,  40),
    TabBtnActive = Color3.fromRGB(255, 255, 255),
    OptionRow    = Color3.fromRGB(22,  22,  26),
    OptionStroke = Color3.fromRGB(0,   0,   0),
    Bind         = Color3.fromRGB(42,  42,  47),
    ToggleOff    = Color3.fromRGB(24,  24,  28),
    ToggleOn     = Color3.fromRGB(255, 255, 255),
    KnobOff      = Color3.fromRGB(128, 128, 133),
    KnobOn       = Color3.fromRGB(0,   0,   0),
    White        = Color3.fromRGB(255, 255, 255),
    TextPrimary  = Color3.fromRGB(255, 255, 255),
    TextSecondary= Color3.fromRGB(180, 180, 190),
    Black        = Color3.fromRGB(0,   0,   0),
}

local State = {
    NormalSpeed       = 60,
    CarrySpeed        = 30,
    LaggerSpeed       = 10.1,
    LaggerCarrySpeed  = 13,
    SpeedMode         = "Normal",
    LaggerEnabled     = false,
    LaggerCarryEnabled= false,
    InfJump           = false,
    AntiRagdoll       = false,
    FpsBoost          = false,
    MedusaCounter     = false,
    BatCounter        = false,
    BatAimbot         = false,
    AutoSwing         = false,
    AutoLeft          = false,
    AutoRight         = false,
    AutoLeftPhase     = 1,
    AutoRightPhase    = 1,
    DropEnabled       = false,
    Unwalk            = false,
    GuiVisible        = true,
    HittingCD         = false,
    MedusaLastUsed    = 0,
    MedusaDebounce    = false,
    BatCounterDB      = false,
    RemAcc            = false,
    JumpMode          = "Manual",
}

local Steal = {
    AutoSteal       = false,
    StealRadius     = 20,
    IsStealing      = false,
    LastStealTick   = 0,
    StealStart      = 0,
    Data            = {},
    plotCache       = {},
    plotCacheTime   = {},
    cachedPrompts   = {},
    promptCacheTime = 0,
}

local Conns = {
    autoLeft={}, autoRight={}, aimbot=nil, antiRag=nil,
    autoSteal=nil, batCounter=nil, medusa={}, unwalk=nil,
    progress=nil, drop={}
}

local POS = {
    L1 = Vector3.new(-476.48,-6.28, 92.73),
    L2 = Vector3.new(-483.12,-4.95, 94.80),
    R1 = Vector3.new(-476.16,-6.52, 25.62),
    R2 = Vector3.new(-483.04,-5.09, 23.14),
}

local STEAL_COOLDOWN    = 0.10
local PLOT_CACHE_DUR    = 2
local PROMPT_CACHE_REFR = 0.15
local DROP_AUTO_OFF     = 0.15
local MEDUSA_COOLDOWN   = 25
local VYSE_AIMBOT_SPEED = 56.5
local VYSE_HIT_DIST     = 5
local SWING_COOLDOWN    = 0.08

local MOVE_KEYS = {
    [Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,
    [Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,
    [Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true,
}

local CONFIG_FILE = "EnvyHubConfig.json"
local h, hrp
local unwalkAnimateRef = nil
local lastMoveDir = Vector3.new(0,0,0)
local startAntiRagdoll, stopAntiRagdoll
local startAutoLeft,    stopAutoLeft
local startAutoRight,   stopAutoRight
local startBatAimbot,   stopBatAimbot
local startBatCounter,  stopBatCounter
local startAutoSteal,   stopAutoSteal
local setupMedusaCounter, stopMedusaCounter
local startUnwalk,      stopUnwalk
local applyFPSBoost
local runDropBrainrot,  stopDropBrainrot
local doTpDown
local saveConfig, loadConfig

local MobileButtons = {Visible = true, Locked = true, Containers = {}, Buttons = {}}

local function corner(parent, r)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, r or 8)
end

local function stroke(parent, col, thick)
    local s = Instance.new("UIStroke", parent)
    s.Color           = col or CLR.OptionStroke
    s.Thickness       = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local function listLayout(parent, spacing)
    local l = Instance.new("UIListLayout", parent)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding   = UDim.new(0, spacing or 8)
    return l
end

local function pad(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding", parent)
    p.PaddingTop    = UDim.new(0, top    or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft   = UDim.new(0, left   or 0)
    p.PaddingRight  = UDim.new(0, right  or 0)
end

local function safeDestroy(name)
    pcall(function() local g = CoreGui:FindFirstChild(name); if g then g:Destroy() end end)
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then local g = pg:FindFirstChild(name); if g then g:Destroy() end end
    end)
end

local function makeToggleRow(parent, label, defaultValue, callback, layoutOrder)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = CLR.OptionRow
    row.BorderSizePixel = 0
    row.LayoutOrder = layoutOrder
    corner(row, 6)
    stroke(row, CLR.OptionStroke, 1)
    
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.6, -12, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = CLR.TextPrimary
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBtn = Instance.new("Frame", row)
    toggleBtn.Size = UDim2.new(0, 44, 0, 22)
    toggleBtn.Position = UDim2.new(1, -56, 0.5, -11)
    toggleBtn.BackgroundColor3 = defaultValue and CLR.ToggleOn or CLR.ToggleOff
    toggleBtn.BorderSizePixel = 0
    corner(toggleBtn, 11)
    
    local knob = Instance.new("Frame", toggleBtn)
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = defaultValue and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = defaultValue and CLR.KnobOn or CLR.KnobOff
    knob.BorderSizePixel = 0
    corner(knob, 9)
    
    local clicker = Instance.new("TextButton", row)
    clicker.Size = UDim2.new(1, 0, 1, 0)
    clicker.BackgroundTransparency = 1
    clicker.Text = ""
    
    local isOn = defaultValue or false
    
    local function setValue(on)
        isOn = on
        tween(toggleBtn, 0.2, {BackgroundColor3 = on and CLR.ToggleOn or CLR.ToggleOff})
        tween(knob, 0.2, {
            Position = on and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
            BackgroundColor3 = on and CLR.KnobOn or CLR.KnobOff
        })
        if callback then callback(on) end
    end
    
    clicker.MouseButton1Click:Connect(function() setValue(not isOn) end)
    
    return setValue
end

local function makeInputRow(parent, label, defaultValue, callback, layoutOrder)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = CLR.OptionRow
    row.BorderSizePixel = 0
    row.LayoutOrder = layoutOrder
    corner(row, 6)
    stroke(row, CLR.OptionStroke, 1)
    
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.6, -12, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = CLR.TextPrimary
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(0, 80, 0, 32)
    box.Position = UDim2.new(1, -92, 0.5, -16)
    box.BackgroundColor3 = CLR.Bind
    box.BorderSizePixel = 0
    box.Text = tostring(defaultValue)
    box.TextColor3 = CLR.TextPrimary
    box.Font = Enum.Font.GothamBold
    box.TextSize = 14
    box.ClearTextOnFocus = true
    corner(box, 6)
    stroke(box, CLR.OptionStroke, 1)
    
    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then
            local finalVal = math.clamp(num, 5, 100)
            box.Text = tostring(finalVal)
            if callback then callback(finalVal) end
        else
            box.Text = tostring(defaultValue)
        end
    end)
    
    return box
end

local function makeSectionLabel(parent, text, layoutOrder)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, 0, 0, 28)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = CLR.TextSecondary
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = layoutOrder
    return lbl
end

local function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "FenixMobileButtons"
    panel.Parent = LocalPlayer:WaitForChild("PlayerGui")
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.IgnoreGuiInset = true
    
    local BTN_W = 58
    local BTN_H = 58
    local CORNER = 14
    local GAP = 12
    local COL1_X = -(BTN_W + GAP + BTN_W + 10)
    local COL2_X = -(BTN_W + 10)
    local BASE_Y = 0.45
    local ROW_Y  = {-((BTN_H*4+GAP*3)/2), -((BTN_H*4+GAP*3)/2)+(BTN_H+GAP),
                    -((BTN_H*4+GAP*3)/2)+(BTN_H+GAP)*2, -((BTN_H*4+GAP*3)/2)+(BTN_H+GAP)*3}
    
    local function makeMobileBtn(name, text, defaultPos, saveKey, callback, isToggle)
        local container = Instance.new("Frame")
        container.Name = name
        container.Parent = panel
        container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        container.BackgroundTransparency = 0
        container.BorderSizePixel = 0
        container.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        container.Position = defaultPos
        corner(container, CORNER)
        stroke(container, Color3.fromRGB(255,255,255), 1)
        
        local btn = Instance.new("TextButton", container)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamBlack
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 10
        btn.TextWrapped = true
        btn.AutoButtonColor = false
        
        local active = false
        local function setActive(state)
            active = state
            if active then
                container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            else
                container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
        
        btn.MouseButton1Down:Connect(function()
            if not isToggle then container.BackgroundColor3 = Color3.fromRGB(255,255,255); btn.TextColor3 = Color3.fromRGB(0,0,0) end
        end)
        btn.MouseButton1Up:Connect(function()
            if not isToggle then container.BackgroundColor3 = Color3.fromRGB(0,0,0); btn.TextColor3 = Color3.fromRGB(255,255,255) end
        end)
        btn.MouseButton1Click:Connect(function()
            if isToggle then setActive(not active) end
            if callback then callback(setActive, active) end
        end)
        
        local dragging = false
        local dragStart = nil
        local startPos = nil
        container.InputBegan:Connect(function(input)
            if MobileButtons.Locked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = container.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End or input.UserInputState == Enum.UserInputState.Cancelled then
                        dragging = false
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        local savedPos = nil
        pcall(function() savedPos = _readfile(saveKey) end)
        if savedPos and savedPos ~= "" then
            local parts = {}
            for part in string.gmatch(savedPos, "[^,]+") do table.insert(parts, part) end
            if #parts >= 4 then
                container.Position = UDim2.new(tonumber(parts[1]), tonumber(parts[2]), tonumber(parts[3]), tonumber(parts[4]))
            end
        end
        local lastSave = 0
        container:GetPropertyChangedSignal("Position"):Connect(function()
            if tick() - lastSave > 0.5 then
                lastSave = tick()
                local pos = container.Position
                local str = string.format("%.3f,%.1f,%.3f,%.1f", pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset)
                pcall(function() _writefile(saveKey, str) end)
            end
        end)
        
        container.Visible = MobileButtons.Visible
        table.insert(MobileButtons.Containers, container)
        return setActive
    end
    
    local dropBRSetActive = makeMobileBtn("BtnDropBR", "DROP\nBR",
        UDim2.new(1, COL1_X, BASE_Y, ROW_Y[1]), "FenixBtn_dropbr.txt",
        function(setActive, currentActive)
            runDropBrainrot()
            task.delay(0.5, function()
                setActive(false)
            end)
        end, true)
    
    local autoLeftSetActive = makeMobileBtn("BtnAutoLeft", "AUTO\nLEFT",
        UDim2.new(1, COL2_X, BASE_Y, ROW_Y[1]), "FenixBtn_autoleft.txt",
        function(setActive)
            State.AutoLeft = not State.AutoLeft
            if State.AutoLeft then
                if State.BatAimbot then State.BatAimbot = false; stopBatAimbot() end
                if State.AutoRight then State.AutoRight = false; stopAutoRight() end
                startAutoLeft()
                setActive(true)
            else
                stopAutoLeft()
                setActive(false)
            end
            saveConfig()
        end, true)
    
    local autoBatSetActive = makeMobileBtn("BtnAutoBat", "BAT\nAIMBOT",
        UDim2.new(1, COL1_X, BASE_Y, ROW_Y[2]), "FenixBtn_autobat.txt",
        function(setActive)
            State.BatAimbot = not State.BatAimbot
            if State.BatAimbot then
                if State.AutoLeft then State.AutoLeft = false; stopAutoLeft() end
                if State.AutoRight then State.AutoRight = false; stopAutoRight() end
                startBatAimbot()
                setActive(true)
            else
                stopBatAimbot()
                setActive(false)
            end
            saveConfig()
        end, true)
    
    local autoRightSetActive = makeMobileBtn("BtnAutoRight", "AUTO\nRIGHT",
        UDim2.new(1, COL2_X, BASE_Y, ROW_Y[2]), "FenixBtn_autoright.txt",
        function(setActive)
            State.AutoRight = not State.AutoRight
            if State.AutoRight then
                if State.BatAimbot then State.BatAimbot = false; stopBatAimbot() end
                if State.AutoLeft then State.AutoLeft = false; stopAutoLeft() end
                startAutoRight()
                setActive(true)
            else
                stopAutoRight()
                setActive(false)
            end
            saveConfig()
        end, true)
    
    local tpDownSetActive = makeMobileBtn("BtnTpDown", "TP\nDOWN",
        UDim2.new(1, COL1_X, BASE_Y, ROW_Y[3]), "FenixBtn_tpdown.txt",
        function(setActive, currentActive)
            doTpDown()
            task.delay(0.5, function()
                setActive(false)
            end)
        end, true)
    
    local carrySpeedSetActive = makeMobileBtn("BtnCarrySpd", "CARRY\nSPD",
        UDim2.new(1, COL2_X, BASE_Y, ROW_Y[3]), "FenixBtn_carryspd.txt",
        function(setActive)
            if State.SpeedMode == "Carry" then
                State.SpeedMode = "Normal"
                setActive(false)
            else
                State.SpeedMode = "Carry"
                setActive(true)
            end
            saveConfig()
        end, true)
    
    local laggerSetActive = makeMobileBtn("BtnLaggerMode", "LAGGER\nNORM",
        UDim2.new(1, COL1_X, BASE_Y, ROW_Y[4]), "FenixBtn_laggermode.txt",
        function(setActive)
            State.LaggerEnabled = not State.LaggerEnabled
            if State.LaggerEnabled then
                if State.LaggerCarryEnabled then 
                    State.LaggerCarryEnabled = false
                    if laggerCarrySetActive then laggerCarrySetActive(false) end
                end
                Steal.AutoSteal = true
                startAutoSteal()
                setActive(true)
            else
                if not State.LaggerCarryEnabled then
                    Steal.AutoSteal = false
                    stopAutoSteal()
                end
                setActive(false)
            end
            saveConfig()
        end, true)
    
    local laggerCarrySetActive = makeMobileBtn("BtnLaggerCarry", "LAGGER\nCARRY",
        UDim2.new(1, COL2_X, BASE_Y, ROW_Y[4]), "FenixBtn_laggercarry.txt",
        function(setActive)
            State.LaggerCarryEnabled = not State.LaggerCarryEnabled
            if State.LaggerCarryEnabled then
                if State.LaggerEnabled then 
                    State.LaggerEnabled = false
                    if laggerSetActive then laggerSetActive(false) end
                end
                Steal.AutoSteal = true
                startAutoSteal()
                setActive(true)
            else
                if not State.LaggerEnabled then
                    Steal.AutoSteal = false
                    stopAutoSteal()
                end
                setActive(false)
            end
            saveConfig()
        end, true)
    
    MobileButtons.Buttons = {
        autoLeft = autoLeftSetActive,
        autoRight = autoRightSetActive,
        autoBat = autoBatSetActive,
        carrySpeed = carrySpeedSetActive,
        lagger = laggerSetActive,
        laggerCarry = laggerCarrySetActive,
        dropBR = dropBRSetActive,
        tpDown = tpDownSetActive,
    }
    
    task.spawn(function()
        task.wait(0.1)
        if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(State.AutoLeft) end
        if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(State.AutoRight) end
        if MobileButtons.Buttons.autoBat then MobileButtons.Buttons.autoBat(State.BatAimbot) end
        if MobileButtons.Buttons.carrySpeed then MobileButtons.Buttons.carrySpeed(State.SpeedMode == "Carry") end
        if MobileButtons.Buttons.lagger then MobileButtons.Buttons.lagger(State.LaggerEnabled) end
        if MobileButtons.Buttons.laggerCarry then MobileButtons.Buttons.laggerCarry(State.LaggerCarryEnabled) end
    end)
    
    return panel
end

doTpDown = function()
    pcall(function()
        local c = LocalPlayer.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local rp = RaycastParams.new()
        rp.FilterDescendantsInstances = {c}
        rp.FilterType = Enum.RaycastFilterType.Exclude
        local res = workspace:Raycast(root.Position, Vector3.new(0,-1000,0), rp)
        if res then
            root.CFrame = CFrame.new(res.Position + Vector3.new(0, root.Size.Y/2 + 0.5, 0))
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

runDropBrainrot = function()
    if State.DropEnabled then return end
    State.DropEnabled = true
    task.spawn(function()
        local colConn = RunService.Stepped:Connect(function()
            if not State.DropEnabled then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end)
        table.insert(Conns.drop, colConn)
        task.spawn(function()
            while State.DropEnabled do
                RunService.Heartbeat:Wait()
                local c = LocalPlayer.Character
                local root = c and c:FindFirstChild("HumanoidRootPart")
                if not root then continue end
                local vel = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if root and root.Parent then root.AssemblyLinearVelocity = vel end
                RunService.Stepped:Wait()
                if root and root.Parent then root.AssemblyLinearVelocity = vel + Vector3.new(0, 0.1, 0) end
            end
        end)
        task.wait(DROP_AUTO_OFF)
        stopDropBrainrot()
    end)
end

stopDropBrainrot = function()
    State.DropEnabled = false
    for _, cn in ipairs(Conns.drop) do pcall(function() cn:Disconnect() end) end
    Conns.drop = {}
end

local function findAnyTool()
    local c = LocalPlayer.Character
    if c then for _, v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then for _, v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
end

local function getClosestPlayer()
    if not hrp then return nil, math.huge end
    local cp, cd = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local ph = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and ph and ph.Health > 0 then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < cd then cd = d; cp = p end
            end
        end
    end
    return cp, cd
end

local function tryHitBat()
    if State.HittingCD then return end
    State.HittingCD = true
    pcall(function()
        local c = LocalPlayer.Character; if not c then return end
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        local tool = findAnyTool()
        if tool then
            if tool.Parent ~= c and hum2 then pcall(function() hum2:EquipTool(tool) end) end
            local remote = tool:FindFirstChildOfClass("RemoteEvent")
            if remote then pcall(function() remote:FireServer() end)
            else pcall(function() tool:Activate() end) end
        end
    end)
    task.delay(SWING_COOLDOWN, function() State.HittingCD = false end)
end

startBatAimbot = function()
    if Conns.aimbot then return end
    Conns.aimbot = RunService.Heartbeat:Connect(function()
        if not State.BatAimbot then return end
        local c = LocalPlayer.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local target, dist = getClosestPlayer()
        if target and target.Character then
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local fp  = tr.Position + tr.CFrame.LookVector * 1.5
                local dir = (fp - root.Position).Unit
                root.AssemblyLinearVelocity = dir * VYSE_AIMBOT_SPEED
                if dist <= VYSE_HIT_DIST and State.AutoSwing then tryHitBat() end
            end
        else
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

stopBatAimbot = function()
    if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
    local c = LocalPlayer.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero end
    State.HittingCD = false
end

local BAT_NAMES = {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap",
    "Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap",
    "Galaxy Slap","Glitched Slap",
}

local function findBatForCounter()
    local c  = LocalPlayer.Character; if not c then return nil end
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_NAMES) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
end

local function swingBatForCounter(bat, char)
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= char then
        if hum2 then pcall(function() hum2:EquipTool(bat) end) end
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent")
    if remote then
        pcall(function() remote:FireServer() end)
        task.wait(0.15)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.15)
        pcall(function() bat:Activate() end)
    end
end

startBatCounter = function()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not State.BatCounter or State.BatCounterDB then return end
        local char = LocalPlayer.Character; if not char then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st = hum2:GetState()
        local isRag = st == Enum.HumanoidStateType.Physics
                   or st == Enum.HumanoidStateType.Ragdoll
                   or st == Enum.HumanoidStateType.FallingDown
        if isRag then
            State.BatCounterDB = true
            task.spawn(function()
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, char) end
                task.wait(0.5)
                State.BatCounterDB = false
            end)
        end
    end)
end

stopBatCounter = function()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter = nil end
    State.BatCounterDB = false
end

local function findMedusa()
    local c = LocalPlayer.Character; if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
end

local function useMedusa()
    if State.MedusaDebounce then return end
    if tick() - State.MedusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LocalPlayer.Character; if not c then return end
    State.MedusaDebounce = true
    local med = findMedusa()
    if not med then State.MedusaDebounce = false; return end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChild("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    State.MedusaLastUsed = tick()
    State.MedusaDebounce = false
end

local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency == 1 then useMedusa() end
    end)
end

setupMedusaCounter = function(char)
    stopMedusaCounter()
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then table.insert(Conns.medusa, onAnchorChanged(part)) end
    end
    table.insert(Conns.medusa, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.medusa, onAnchorChanged(part)) end
    end))
end

stopMedusaCounter = function()
    for _, c2 in pairs(Conns.medusa) do pcall(function() c2:Disconnect() end) end
    Conns.medusa = {}
end

startAntiRagdoll = function()
    if Conns.antiRag then return end
    Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not State.AntiRagdoll then return end
        local c = LocalPlayer.Character; if not c then return end
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        local root = c:FindFirstChild("HumanoidRootPart")
        if not hum2 or not root then return end
        if hum2.Health <= 0 then return end
        local st = hum2:GetState()
        if st == Enum.HumanoidStateType.Dead then return end
        if st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown then
            pcall(function() hum2:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            pcall(function() workspace.CurrentCamera.CameraSubject = hum2 end)
            root.AssemblyLinearVelocity  = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        for _, obj in ipairs(c:GetDescendants()) do
            pcall(function()
                if obj:IsA("Motor6D") and not obj.Enabled then obj.Enabled = true end
            end)
        end
    end)
end

stopAntiRagdoll = function()
    if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag = nil end
end

startUnwalk = function()
    local c = LocalPlayer.Character; if not c then return end
    local hum2 = c:FindFirstChildOfClass("Humanoid")
    if hum2 then
        pcall(function()
            for _, track in ipairs(hum2:GetPlayingAnimationTracks()) do track:Stop(0) end
        end)
    end
    local anim = c:FindFirstChild("Animate")
    if anim and anim:IsA("LocalScript") then
        anim.Disabled = true; unwalkAnimateRef = anim
    end
    if Conns.unwalk then Conns.unwalk:Disconnect() end
    Conns.unwalk = RunService.Heartbeat:Connect(function()
        if not State.Unwalk then return end
        local c2 = LocalPlayer.Character; if not c2 then return end
        local hum3 = c2:FindFirstChildOfClass("Humanoid")
        if hum3 then
            pcall(function()
                for _, track in ipairs(hum3:GetPlayingAnimationTracks()) do track:Stop(0) end
            end)
        end
    end)
end

stopUnwalk = function()
    if Conns.unwalk then Conns.unwalk:Disconnect(); Conns.unwalk = nil end
    local c = LocalPlayer.Character
    if c and unwalkAnimateRef and unwalkAnimateRef.Parent == c then
        unwalkAnimateRef.Disabled = false
    end
    unwalkAnimateRef = nil
end

applyFPSBoost = function()
    pcall(function() setfpscap(999999999) end)
    local function pO(v)
        pcall(function()
            if v:IsA("Model") then
                v.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
            elseif v:IsA("MeshPart") then
                v.CastShadow = false; v.RenderFidelity = Enum.RenderFidelity.Performance
            elseif v:IsA("BasePart") then
                v.CastShadow = false; v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke")
                or v:IsA("Sparkles") or v:IsA("ParticleEmitter")
                or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled = false
            elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then
                v:Destroy()
            end
        end)
    end
    for _, v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L = game:GetService("Lighting")
        for _, v in pairs(L:GetDescendants()) do
            pcall(function()
                if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect")
                or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("Clouds")
                or v:IsA("ColorCorrectionEffect") then v:Destroy() end
            end)
        end
        L.GlobalShadows = false; L.FogEnd = 9e9; L.Brightness = 0
    end)
    workspace.DescendantAdded:Connect(function(v)
        if State.FpsBoost then task.spawn(pO, v) end
    end)
end

local function faceSouth()
    pcall(function()
        local c = LocalPlayer.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0,0,0) end
    end)
end

local function faceNorth()
    pcall(function()
        local c = LocalPlayer.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0,math.rad(180),0) end
    end)
end

startAutoLeft = function()
    for _, cn in ipairs(Conns.autoLeft) do pcall(function() cn:Disconnect() end) end
    Conns.autoLeft = {}; State.AutoLeftPhase = 1
    local c2 = RunService.Heartbeat:Connect(function()
        if not State.AutoLeft then return end
        local c = LocalPlayer.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if not root or not hum2 then return end
        local spd = State.NormalSpeed
        if State.AutoLeftPhase == 1 then
            local tgt = Vector3.new(POS.L1.X, root.Position.Y, POS.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                State.AutoLeftPhase = 2
                local d = POS.L2 - root.Position
                local mv = Vector3.new(d.X,0,d.Z).Unit
                hum2:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X*spd, root.AssemblyLinearVelocity.Y, mv.Z*spd)
                return
            end
            local d = POS.L1 - root.Position
            local mv = Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X*spd, root.AssemblyLinearVelocity.Y, mv.Z*spd)
        elseif State.AutoLeftPhase == 2 then
            local tgt = Vector3.new(POS.L2.X, root.Position.Y, POS.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum2:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                State.AutoLeft = false; State.AutoLeftPhase = 1
                stopAutoLeft(); faceSouth(); return
            end
            local d = POS.L2 - root.Position
            local mv = Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X*spd, root.AssemblyLinearVelocity.Y, mv.Z*spd)
        end
    end)
    table.insert(Conns.autoLeft, c2)
end

stopAutoLeft = function()
    for _, cn in ipairs(Conns.autoLeft) do pcall(function() cn:Disconnect() end) end
    Conns.autoLeft = {}; State.AutoLeftPhase = 1
    local c = LocalPlayer.Character
    if c then local hum2 = c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end

startAutoRight = function()
    for _, cn in ipairs(Conns.autoRight) do pcall(function() cn:Disconnect() end) end
    Conns.autoRight = {}; State.AutoRightPhase = 1
    local c2 = RunService.Heartbeat:Connect(function()
        if not State.AutoRight then return end
        local c = LocalPlayer.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if not root or not hum2 then return end
        local spd = State.NormalSpeed
        if State.AutoRightPhase == 1 then
            local tgt = Vector3.new(POS.R1.X, root.Position.Y, POS.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                State.AutoRightPhase = 2
                local d = POS.R2 - root.Position
                local mv = Vector3.new(d.X,0,d.Z).Unit
                hum2:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X*spd, root.AssemblyLinearVelocity.Y, mv.Z*spd)
                return
            end
            local d = POS.R1 - root.Position
            local mv = Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(d.X*spd, root.AssemblyLinearVelocity.Y, mv.Z*spd)
        elseif State.AutoRightPhase == 2 then
            local tgt = Vector3.new(POS.R2.X, root.Position.Y, POS.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum2:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                State.AutoRight = false; State.AutoRightPhase = 1
                stopAutoRight(); faceNorth(); return
            end
            local d = POS.R2 - root.Position
            local mv = Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X*spd, root.AssemblyLinearVelocity.Y, mv.Z*spd)
        end
    end)
    table.insert(Conns.autoRight, c2)
end

stopAutoRight = function()
    for _, cn in ipairs(Conns.autoRight) do pcall(function() cn:Disconnect() end) end
    Conns.autoRight = {}; State.AutoRightPhase = 1
    local c = LocalPlayer.Character
    if c then local hum2 = c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end

local function isMyPlot(pn)
    local ct = tick()
    if Steal.plotCache[pn] and (ct-(Steal.plotCacheTime[pn] or 0)) < PLOT_CACHE_DUR then
        return Steal.plotCache[pn]
    end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then Steal.plotCache[pn]=false; Steal.plotCacheTime[pn]=ct; return false end
    local plot = plots:FindFirstChild(pn)
    if not plot then Steal.plotCache[pn]=false; Steal.plotCacheTime[pn]=ct; return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            local r = yb.Enabled==true
            Steal.plotCache[pn]=r; Steal.plotCacheTime[pn]=ct; return r
        end
    end
    Steal.plotCache[pn]=false; Steal.plotCacheTime[pn]=ct; return false
end

local function findNearestPrompt()
    local c = LocalPlayer.Character; if not c then return nil end
    local root = c:FindFirstChild("HumanoidRootPart"); if not root then return nil end
    local ct = tick()
    if ct-Steal.promptCacheTime < PROMPT_CACHE_REFR and #Steal.cachedPrompts>0 then
        local np,nd=nil,math.huge
        for _, data in ipairs(Steal.cachedPrompts) do
            if data.spawn then
                local dist=(data.spawn.Position-root.Position).Magnitude
                if dist<=Steal.StealRadius and dist<nd then np=data.prompt; nd=dist end
            end
        end
        if np then return np end
    end
    Steal.cachedPrompts={}; Steal.promptCacheTime=ct
    local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
    local np,nd=nil,math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlot(plot.Name) then continue end
        local pods=plot:FindFirstChild("AnimalPodiums"); if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base=pod:FindFirstChild("Base")
                local sp=base and base:FindFirstChild("Spawn")
                if sp then
                    local att=sp:FindFirstChild("PromptAttachment")
                    if att then
                        for _, child in ipairs(att:GetChildren()) do
                            if child: