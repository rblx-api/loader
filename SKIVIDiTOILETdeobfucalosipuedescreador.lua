local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local SoundService     = game:GetService("SoundService")

local rawPrint, rawWarn = print, warn
local function print(...)
    return rawPrint("#####")
end
local function warn(...)
    return rawWarn("#####")
end

local lp        = Players.LocalPlayer
local playerGui = lp:WaitForChild("PlayerGui")

local DEFAULT_CONFIG = {
    API_URL            = "https://egg-logs-api.apps.bot-hosting.cloud",
    API_SECRET         = "sk_egg_7f3a9c1b24d84e5f9a06c3d7b1e852fa4c6d9031",
    UI_SCALE           = 0.7,
    MIN_RARITY         = 3,
    MIN_MONEY          = 0,
    CHECK_INTERVAL     = 1,
    MAX_DISPLAY        = 200,
    FORCE_DELAY        = 0.03,
    FORCE_AUTO_DISABLE = 5,
    BACKGROUND_IMAGE   = "rbxassetid://84064858467855",
}
local CONFIG = {}
for k, v in pairs(DEFAULT_CONFIG) do CONFIG[k] = v end

local CONFIG_FILE = "renhub_joiner_v5.json"
local function saveConfig()
    if writefile then
        pcall(writefile, CONFIG_FILE, HttpService:JSONEncode({
            MIN_RARITY = CONFIG.MIN_RARITY, MIN_MONEY = CONFIG.MIN_MONEY,
            CHECK_INTERVAL = CONFIG.CHECK_INTERVAL, MAX_DISPLAY = CONFIG.MAX_DISPLAY,
            FORCE_DELAY = CONFIG.FORCE_DELAY, FORCE_AUTO_DISABLE = CONFIG.FORCE_AUTO_DISABLE,
            UI_SCALE = CONFIG.UI_SCALE,
        }))
    end
end
local function loadConfig()
    if readfile and isfile and isfile(CONFIG_FILE) then
        local ok, data = pcall(readfile, CONFIG_FILE)
        if ok and data then
            local okDec, decoded = pcall(function() return HttpService:JSONDecode(data) end)
            if okDec and type(decoded) == "table" then
                for k, v in pairs(decoded) do
                    if CONFIG[k] ~= nil and type(CONFIG[k]) == type(v) then CONFIG[k] = v end
                end
            end
        end
    end
end
loadConfig()

local state = {
    autoJoin = false, autoForce = false,
    lastJobId = "", joined = false, bestData = nil,
    isMinimized = false, authenticated = false,
}

local force = {
    expiresAt = 0, active = false, running = false,
    targetJobId = nil, attempts = 0, lastError = nil, lastNotify = 0,
}
local function isForceActive() return force.active and tick() < force.expiresAt end

local Theme = {
    BgMain  = Color3.fromRGB(15, 15, 19),
    BgLight = Color3.fromRGB(24, 22, 28),
    Accent  = Color3.fromRGB(255, 72, 72),
    Accent2 = Color3.fromRGB(255, 150, 60),
    Gold    = Color3.fromRGB(255, 200, 60),
    Text    = Color3.fromRGB(240, 238, 244),
    TextDim = Color3.fromRGB(150, 150, 165),
    Green   = Color3.fromRGB(80, 220, 140),
    Stroke  = Color3.fromRGB(48, 46, 56),
}
local RARITY_COLOR = {
    [0]=Color3.fromRGB(200,200,200),[1]=Color3.fromRGB(80,200,80),
    [2]=Color3.fromRGB(80,130,255),[3]=Color3.fromRGB(180,80,255),
    [4]=Color3.fromRGB(255,165,0), [5]=Color3.fromRGB(255,80,80),
    [6]=Color3.fromRGB(255,255,80),
}
local RARITY_NAME = {
    [0]="Common",[1]="Uncommon",[2]="Rare",[3]="Epic",
    [4]="Legendary",[5]="Mythic",[6]="Divine",
}

local ACCESS_SOUND_ID = "rbxassetid://474545527"
local accessSoundPlayed = false
local function playUiSound()
    if accessSoundPlayed then return end
    accessSoundPlayed = true
    local sound = Instance.new("Sound")
    sound.Name = "REN_NOTIFICER_AccessSound"
    sound.SoundId = ACCESS_SOUND_ID
    sound.Volume = 0.25
    sound.Looped = false
    sound.Parent = SoundService
    local ok = pcall(function() sound:Play() end)
    if not ok then sound:Destroy(); return end
    sound.Ended:Connect(function()
        if sound and sound.Parent then sound:Destroy() end
    end)
    task.delay(8, function()
        if sound and sound.Parent then sound:Destroy() end
    end)
end

local function new(cls, props, parent)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    if o:IsA("TextButton") or o:IsA("ImageButton") then
        o.AutoButtonColor = false
        o.MouseEnter:Connect(function()
            if o.Parent and o.Visible then
                local original = o.BackgroundColor3
                TweenService:Create(o, TweenInfo.new(0.08), { BackgroundColor3 = original:Lerp(Color3.new(1, 1, 1), 0.08) }):Play()
            end
        end)
        o.MouseLeave:Connect(function()
            if o.Parent then
                local target = o:GetAttribute("RENOriginalColor")
                if typeof(target) == "Color3" then
                    TweenService:Create(o, TweenInfo.new(0.10), { BackgroundColor3 = target }):Play()
                end
            end
        end)
        o:SetAttribute("RENOriginalColor", o.BackgroundColor3)
    end
    return o
end
local function corner(p, r) new("UICorner", { CornerRadius = UDim.new(0, r or 6) }, p) end
local function stroke(p, c, t) new("UIStroke", { Color = c or Theme.Stroke, Thickness = t or 1 }, p) end
local function clamp(n, mn, mx) return math.max(mn, math.min(mx, n)) end

local function formatRate(v)
    v = tonumber(v) or 0
    if v >= 1e12 then return string.format("$%.2fT/s", v/1e12) end
    if v >= 1e9  then return string.format("$%.2fB/s", v/1e9) end
    if v >= 1e6  then return string.format("$%.2fM/s", v/1e6) end
    if v >= 1e3  then return string.format("$%.1fK/s", v/1e3) end
    return string.format("$%.0f/s", v)
end
local function resolveImage(img)
    if not img then return "rbxassetid://7755684428" end
    if type(img) == "number" then return "rbxassetid://" .. img end
    return img
end

local function getServerIds(egg)
    if type(egg) ~= "table" then return nil, game.PlaceId end
    local rawJobId = egg.job_id or egg.jobId or egg.server_id or egg.serverId
    local jobId = type(rawJobId) == "string" and rawJobId or nil
    local placeId = tonumber(egg.place_id or egg.placeId) or game.PlaceId
    return jobId, placeId
end

local function httpGetRaw(endpoint)
    local req = (syn and syn.request) or (http and http.request) or request
    if not req then return nil, "no request fn" end
    if type(CONFIG.API_SECRET) ~= "string" or CONFIG.API_SECRET == "" then
        return nil, "API not configured: use a server-side proxy; client secrets are unsafe"
    end
    local ok, res = pcall(req, {
        Url = CONFIG.API_URL .. endpoint, Method = "GET",
        Headers = { ["X-Secret-Key"] = CONFIG.API_SECRET },
    })
    if not ok then return nil, "req err: " .. tostring(res) end
    if not res or not res.Body then return nil, "empty" end
    if res.StatusCode == 401 then return nil, "401 unauthorized" end
    if res.StatusCode ~= 200 then return nil, "HTTP " .. tostring(res.StatusCode) end
    local okDec, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
    if not okDec then return nil, "json err: " .. tostring(data) end
    return data, nil
end

local notifyContainer = nil
local function notify(text, color)
    if not notifyContainer or state.isMinimized then return end
    local n = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundColor3 = color or Theme.BgLight, BackgroundTransparency = 0.1,
        Text = text, TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 10,
        ZIndex = 999, Parent = notifyContainer,
    })
    corner(n, 4)
    task.delay(3, function()
        if n and n.Parent then
            TweenService:Create(n, TweenInfo.new(0.4), { BackgroundTransparency = 1, TextTransparency = 1 }):Play()
            task.wait(0.5); n:Destroy()
        end
    end)
end

TeleportService.TeleportInitFailed:Connect(function(player, errCode, errMsg)
    if player == lp then
        force.lastError = tostring(errMsg)
        if tick() - force.lastNotify > 1 then
            force.lastNotify = tick()
            notify("TP[" .. tostring(errCode) .. "]: " .. tostring(errMsg):sub(1, 30), Theme.Accent)
        end
    end
end)

local function fireTeleport(egg)
    local jobId, placeId = getServerIds(egg)
    if type(jobId) ~= "string" or jobId == "" then return false, "Missing JobId" end
    if #jobId < 30 then return false, "Invalid JobId format" end

    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, jobId, lp)
    end)
    if not ok then return false, tostring(err) end
    return true
end

local function activateForceTimer(duration)
    force.active    = true
    force.expiresAt = tick() + duration
end

local function startForceSpam(egg)
    if not egg then return end
    local jobId = getServerIds(egg)
    if not jobId then notify("Missing JobId", Theme.Accent); return end

    force.targetJobId = jobId
    force.attempts    = 0
    activateForceTimer(CONFIG.FORCE_AUTO_DISABLE)
    if force.running then return end
    force.running = true

    task.spawn(function()
        while isForceActive() do
            force.attempts = force.attempts + 1
            fireTeleport(egg)
            task.wait(CONFIG.FORCE_DELAY)
        end
        force.running     = false
        force.active      = false
        force.targetJobId = nil
    end)
end

local oldGui = playerGui:FindFirstChild("REN_NOTIFICER") or playerGui:FindFirstChild("RenHubEggJoiner")
if oldGui then oldGui:Destroy() end

local screenGui = new("ScreenGui", {
    Name = "REN_NOTIFICER", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = playerGui,
})

local camera = workspace.CurrentCamera
local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
local UI_WIDTH = math.max(340, math.min(520, viewport.X - 24))
local UI_HEIGHT = math.max(400, math.min(560, viewport.Y - 24))

local mainFrame = new("Frame", {
    Size = UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT),
    Position = UDim2.new(0.5, -math.floor(UI_WIDTH / 2), 0.5, -math.floor(UI_HEIGHT / 2)),
    BackgroundColor3 = Theme.BgMain, BorderSizePixel = 0,
    ClipsDescendants = true, Visible = false, Parent = screenGui,
})
corner(mainFrame, 14); stroke(mainFrame, Theme.Stroke, 1.5)
local mainScale = new("UIScale", { Scale = CONFIG.UI_SCALE, Parent = mainFrame })

local ACCESS_KEY = "REN-HUB"
local loginLayer = new("Frame", {
    Name = "AccessGate", Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(5, 6, 10), BackgroundTransparency = 0.12,
    BorderSizePixel = 0, ZIndex = 100, Parent = screenGui,
})
local loginWidth = math.max(290, math.min(380, viewport.X - 24))
local loginCard = new("Frame", {
    Name = "AccessCard", Size = UDim2.new(0, loginWidth, 0, 310),
    Position = UDim2.new(0.5, -math.floor(loginWidth / 2), 0.5, -155),
    BackgroundColor3 = Color3.fromRGB(17, 18, 24), BorderSizePixel = 0,
    ZIndex = 101, Parent = loginLayer,
})
corner(loginCard, 16); stroke(loginCard, Color3.fromRGB(75, 44, 51), 1.5)
new("UIGradient", {
    Color = ColorSequence.new(Color3.fromRGB(28, 24, 32), Color3.fromRGB(13, 14, 19)),
    Rotation = 90, Parent = loginCard,
})
new("Frame", {
    Size = UDim2.new(1, 0, 0, 4), BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0, ZIndex = 102, Parent = loginCard,
})
local loginIcon = new("ImageLabel", {
    Size = UDim2.new(0, 38, 0, 38), Position = UDim2.new(0.5, -19, 0, 24),
    BackgroundColor3 = Color3.fromRGB(43, 24, 31), Image = "rbxassetid://6026568224",
    ImageColor3 = Theme.Accent, ZIndex = 103, Parent = loginCard,
})
corner(loginIcon, 12)
new("TextLabel", {
    Size = UDim2.new(1, -24, 0, 28), Position = UDim2.new(0, 12, 0, 72),
    BackgroundTransparency = 1, Text = "RENHUB ACCESS", TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold, TextSize = 20, ZIndex = 103, Parent = loginCard,
})
new("TextLabel", {
    Size = UDim2.new(1, -28, 0, 18), Position = UDim2.new(0, 14, 0, 101),
    BackgroundTransparency = 1, Text = "SECURE CLIENT PANEL", TextColor3 = Theme.TextDim,
    Font = Enum.Font.GothamMedium, TextSize = 10, ZIndex = 103, Parent = loginCard,
})
new("TextLabel", {
    Size = UDim2.new(1, -36, 0, 18), Position = UDim2.new(0, 18, 0, 137),
    BackgroundTransparency = 1, Text = "ACCESS KEY", TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 103, Parent = loginCard,
})
local passHolder = new("Frame", {
    Size = UDim2.new(1, -36, 0, 42), Position = UDim2.new(0, 18, 0, 158),
    BackgroundColor3 = Color3.fromRGB(9, 10, 14), BorderSizePixel = 0,
    ZIndex = 103, Parent = loginCard,
})
corner(passHolder, 8); stroke(passHolder, Theme.Stroke, 1)
local passwordBox = new("TextBox", {
    Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1, Text = "", TextColor3 = Theme.Text,
    TextTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 15,
    ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Center,
    PlaceholderText = "Enter access key", PlaceholderColor3 = Theme.TextDim,
    ZIndex = 104, Parent = passHolder,
})
local passwordMask = new("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1, Text = "TYPE KEY HERE", TextColor3 = Theme.TextDim,
    Font = Enum.Font.GothamMedium, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Center,
    Active = false, ZIndex = 105, Parent = passHolder,
})
local loginStatus = new("TextLabel", {
    Size = UDim2.new(1, -36, 0, 18), Position = UDim2.new(0, 18, 0, 204),
    BackgroundTransparency = 1, Text = "FORMAT: XXX-XXX", TextColor3 = Theme.TextDim,
    Font = Enum.Font.GothamMedium, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 103, Parent = loginCard,
})
local loginButton = new("TextButton", {
    Size = UDim2.new(1, -36, 0, 40), Position = UDim2.new(0, 18, 0, 230),
    BackgroundColor3 = Theme.Accent, Text = "UNLOCK PANEL", TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 103, Parent = loginCard,
})
corner(loginButton, 8)
new("UIGradient", { Color = ColorSequence.new(Theme.Accent, Theme.Accent2), Rotation = 0, Parent = loginButton })
new("TextLabel", {
    Size = UDim2.new(1, -32, 0, 18), Position = UDim2.new(0, 16, 1, -23),
    BackgroundTransparency = 1, Text = "RENHUB  /  ACCESS CONTROL", TextColor3 = Color3.fromRGB(92, 94, 108),
    Font = Enum.Font.GothamMedium, TextSize = 8, ZIndex = 103, Parent = loginCard,
})

local normalizingPassword = false
local function normalizePassword(raw)
    raw = string.upper(tostring(raw or ""))
    raw = raw:gsub("[%s_]+", "-"):gsub("[^A-Z0-9%-]", ""):gsub("%-+", "-")
    raw = raw:gsub("^%-", "")
    local compact = raw:gsub("%-", "")
    if #compact > 3 then
        return compact:sub(1, 3) .. "-" .. compact:sub(4, 7)
    end
    if raw:sub(-1) == "-" then return raw end
    return compact
end
passwordBox:GetPropertyChangedSignal("Text"):Connect(function()
    if normalizingPassword then return end
    normalizingPassword = true
    local normalized = normalizePassword(passwordBox.Text)
    if passwordBox.Text ~= normalized then
        passwordBox.Text = normalized
        passwordBox.CursorPosition = #normalized + 1
    end
    passwordMask.Text = normalized:gsub("[^%-]", "*")
    normalizingPassword = false
end)
local function tryUnlock()
    if state.authenticated then return end
    local entered = normalizePassword(passwordBox.Text)
    if entered == ACCESS_KEY then
        state.authenticated = true
        loginStatus.Text = "ACCESS GRANTED"
        loginStatus.TextColor3 = Theme.Green
        playUiSound()
        TweenService:Create(loginCard, TweenInfo.new(0.18), {
            Position = UDim2.new(0.5, -math.floor(loginWidth / 2), 0.5, -170),
            BackgroundTransparency = 1,
        }):Play()
        task.delay(0.18, function()
            if loginLayer and loginLayer.Parent then loginLayer.Visible = false end
            mainFrame.Visible = true
        end)
    else
        loginStatus.Text = "INVALID KEY - TRY AGAIN"
        loginStatus.TextColor3 = Theme.Accent
        passwordBox.Text = ""
        passwordMask.Text = ""
        passwordBox:CaptureFocus()
        TweenService:Create(passHolder, TweenInfo.new(0.06), { BackgroundColor3 = Color3.fromRGB(52, 20, 26) }):Play()
        task.delay(0.14, function()
            if passHolder and passHolder.Parent then
                TweenService:Create(passHolder, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(9, 10, 14) }):Play()
            end
        end)
    end
end
loginButton.Activated:Connect(tryUnlock)
passwordBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then tryUnlock() end
end)

local bgImage = new("ImageLabel", {
    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
    Image = CONFIG.BACKGROUND_IMAGE, ScaleType = Enum.ScaleType.Crop,
    ImageTransparency = 0.15, Parent = mainFrame,
})

local bgOverlay = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Theme.BgMain, BackgroundTransparency = 0.5,
    BorderSizePixel = 0, Parent = mainFrame,
})

notifyContainer = new("Frame", {
    Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 10, 1, -66),
    BackgroundTransparency = 1, ZIndex = 998, Parent = mainFrame,
})

local topBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundColor3 = Theme.BgLight, BackgroundTransparency = 0.35,
    BorderSizePixel = 0, Parent = mainFrame,
})
corner(topBar, 12); stroke(topBar, Theme.Stroke, 1)

local title = new("TextLabel", {
    Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1, Text = "RENHUB  /  EGG INTELLIGENCE", TextTruncate = Enum.TextTruncate.AtEnd,
    TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left, Parent = topBar,
})
new("UIGradient", { Color = ColorSequence.new(Theme.Accent, Theme.Accent2) }, title)

local diagBtn = new("ImageButton", {
    Size = UDim2.new(0, 28, 1, 0), Position = UDim2.new(1, -84, 0, 0),
    BackgroundTransparency = 1, Image = "rbxassetid://6031154871", ImageColor3 = Theme.TextDim,
    Parent = topBar,
})
local settingsBtn = new("ImageButton", {
    Size = UDim2.new(0, 28, 1, 0), Position = UDim2.new(1, -56, 0, 0),
    BackgroundTransparency = 1, Image = "rbxassetid://6031280882", ImageColor3 = Theme.TextDim,
    Parent = topBar,
})
local minBtn = new("ImageButton", {
    Size = UDim2.new(0, 28, 1, 0), Position = UDim2.new(1, -28, 0, 0),
    BackgroundTransparency = 1, Image = "rbxassetid://6026568240", ImageColor3 = Theme.TextDim,
    Parent = topBar,
})

local bestFrame = new("Frame", {
    Size = UDim2.new(1, -12, 0, 74), Position = UDim2.new(0, 6, 0, 32),
    BackgroundColor3 = Theme.BgLight, BackgroundTransparency = 0.3,
    BorderSizePixel = 0, Parent = mainFrame,
})
corner(bestFrame, 8); stroke(bestFrame, Theme.Gold, 1.5)

local bestIcon = new("ImageLabel", {
    Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 10, 0.5, -25),
    BackgroundTransparency = 1, Image = "rbxassetid://7755684428", Parent = bestFrame,
})
new("TextLabel", {
    Size = UDim2.new(1, -170, 0, 12), Position = UDim2.new(0, 68, 0, 6),
    BackgroundTransparency = 1, Text = "THE BEST EGG",
    TextColor3 = Theme.Gold, Font = Enum.Font.GothamBold, TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left, Parent = bestFrame,
})
local bestName = new("TextLabel", {
    Size = UDim2.new(1, -170, 0, 16), Position = UDim2.new(0, 68, 0, 20),
    BackgroundTransparency = 1, Text = "Searching...",
    TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = bestFrame,
})
local bestMoney = new("TextLabel", {
    Size = UDim2.new(1, -170, 0, 14), Position = UDim2.new(0, 68, 0, 42),
    BackgroundTransparency = 1, Text = "$0/s",
    TextColor3 = Theme.Green, Font = Enum.Font.GothamBold, TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left, Parent = bestFrame,
})

local bestJoinBtn = new("TextButton", {
    Size = UDim2.new(0, 54, 0, 30), Position = UDim2.new(1, -118, 0.5, -15),
    BackgroundColor3 = Theme.Accent, Text = "JOIN", TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold, TextSize = 10, Parent = bestFrame,
})
corner(bestJoinBtn, 5)
new("UIGradient", { Color = ColorSequence.new(Theme.Accent, Theme.Accent2) }, bestJoinBtn)

local bestForceBtn = new("TextButton", {
    Size = UDim2.new(0, 54, 0, 30), Position = UDim2.new(1, -60, 0.5, -15),
    BackgroundColor3 = Theme.Accent2, Text = "FORCE", TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold, TextSize = 9, Parent = bestFrame,
})
corner(bestForceBtn, 5)

bestJoinBtn.MouseButton1Click:Connect(function()
    if state.bestData then
        state.joined = true
        local ok, err = fireTeleport(state.bestData)
        if not ok then notify("ERROR: " .. err, Theme.Accent) end
    end
end)
bestForceBtn.MouseButton1Click:Connect(function()
    if state.bestData then
        state.joined = true
        startForceSpam(state.bestData)
    end
end)

local toggleFrame = new("Frame", {
    Size = UDim2.new(1, -12, 0, 26), Position = UDim2.new(0, 6, 0, 110),
    BackgroundTransparency = 1, Parent = mainFrame,
})

local function createMiniToggle(text, xPos, stateKey, onChange)
    local bg = new("TextButton", {
        Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(xPos, 0, 0, 0),
        BackgroundColor3 = Theme.BgLight, BackgroundTransparency = 0.3,
        Text = "", AutoButtonColor = false, Parent = toggleFrame,
    })
    corner(bg, 5); stroke(bg)
    new("TextLabel", {
        Size = UDim2.new(1, -28, 1, 0), Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = bg,
    })
    local dot = new("Frame", {
        Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -18, 0.5, -5),
        BackgroundColor3 = Theme.Stroke, Parent = bg,
    })
    corner(dot, 999)
    local function refresh()
        TweenService:Create(dot, TweenInfo.new(0.2), {
            BackgroundColor3 = state[stateKey] and Theme.Accent or Theme.Stroke,
        }):Play()
    end
    refresh()
    bg.MouseButton1Click:Connect(function()
        state[stateKey] = not state[stateKey]
        refresh()
        onChange(state[stateKey])
    end)
end

createMiniToggle("Auto-Join", 0.02, "autoJoin", function(v) end)
createMiniToggle("Auto-Force", 0.50, "autoForce", function(v)
    if v then
        activateForceTimer(CONFIG.FORCE_AUTO_DISABLE)
        if state.bestData then startForceSpam(state.bestData) end
    else
        force.active = false
    end
end)

local listFrame = new("ScrollingFrame", {
    Size = UDim2.new(1, -12, 1, -146), Position = UDim2.new(0, 6, 0, 140),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = mainFrame,
})
new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = listFrame })

local function renderList(eggsList)
    for _, c in ipairs(listFrame:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    if type(eggsList) ~= "table" then
        state.bestData = nil
        bestName.Text = "Invalid API response"
        bestMoney.Text = "$0/s"
        bestName.TextColor3 = Theme.Accent
        return
    end
    local safeEggs = {}
    for _, item in ipairs(eggsList) do
        if type(item) == "table" then table.insert(safeEggs, item) end
    end
    eggsList = safeEggs
    if #eggsList == 0 then
        state.bestData = nil
        bestName.Text = "No eggs available"
        bestMoney.Text = "$0/s"
        bestName.TextColor3 = Theme.Text
        return
    end

    table.sort(eggsList, function(a, b)
        return (tonumber(a.income) or 0) > (tonumber(b.income) or 0)
    end)

    local bestEgg = eggsList[1]
    state.bestData = bestEgg
    local r = bestEgg.rarity or 0

    bestName.Text = string.format("[%s] %s", RARITY_NAME[r] or "?", bestEgg.name or "?")
    bestName.TextColor3 = RARITY_COLOR[r] or Theme.Text
    bestMoney.Text = formatRate(bestEgg.income)
    bestIcon.Image = resolveImage(bestEgg.image)

    local maxN = math.min(CONFIG.MAX_DISPLAY, #eggsList)
    for i = 1, maxN do
        local egg   = eggsList[i]
        local jobId = getServerIds(egg)
        local isBest = (i == 1)
        local eggRarity = egg.rarity or 0
        local rCol   = RARITY_COLOR[eggRarity] or Theme.Text
        local income = tonumber(egg.income) or 0
        local scale  = tonumber(egg.scale)  or 1
        local weight = tonumber(egg.weight) or 0

        local row = new("Frame", {
            Size = UDim2.new(1, -4, 0, 44),
            BackgroundColor3 = Theme.BgLight, BackgroundTransparency = 0.3,
            BorderSizePixel = 0, LayoutOrder = i, Parent = listFrame,
        })
        corner(row, 6)
        stroke(row, isBest and Theme.Gold or Theme.Stroke, isBest and 2 or 1)

        new("Frame", {
            Size = UDim2.new(0, 3, 0.7, 0), Position = UDim2.new(0, 0, 0.15, 0),
            BackgroundColor3 = rCol, BorderSizePixel = 0, Parent = row,
        })
        new("ImageLabel", {
            Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0, 10, 0.5, -16),
            BackgroundTransparency = 1, Image = resolveImage(egg.image), Parent = row,
        })
        new("TextLabel", {
            Size = UDim2.new(1, -170, 0, 15), Position = UDim2.new(0, 48, 0, 5),
            BackgroundTransparency = 1, Text = (isBest and "* " or "") .. (egg.name or "?"),
            TextColor3 = isBest and Theme.Gold or Theme.Text,
            Font = Enum.Font.GothamBold, TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
        })
        new("TextLabel", {
            Size = UDim2.new(0.5, 0, 0, 15), Position = UDim2.new(0, 48, 0, 24),
            BackgroundTransparency = 1, Text = formatRate(income),
            TextColor3 = Theme.Green, Font = Enum.Font.GothamBold, TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
        })
        new("TextLabel", {
            Size = UDim2.new(0, 90, 0, 12), Position = UDim2.new(0.53, 0, 0, 26),
            BackgroundTransparency = 1, Text = string.format("x%.1f | %.0fKg", scale, weight),
            TextColor3 = Theme.TextDim, Font = Enum.Font.GothamMedium, TextSize = 8,
            TextXAlignment = Enum.TextXAlignment.Right, Parent = row,
        })

        local joinBtn = new("TextButton", {
            Size = UDim2.new(0, 50, 0, 30), Position = UDim2.new(1, -110, 0.5, -15),
            BackgroundColor3 = Theme.Accent, Text = "JOIN", TextColor3 = Theme.Text,
            Font = Enum.Font.GothamBold, TextSize = 9, Parent = row,
        })
        corner(joinBtn, 5)
        joinBtn.MouseButton1Click:Connect(function()
            if jobId then
                state.joined = true
                local ok, err = fireTeleport(egg)
                if not ok then notify("ERROR: " .. err, Theme.Accent) end
            else
                notify("ERROR: Missing JobId (invalid server)", Theme.Accent)
            end
        end)

        local forceBtn = new("TextButton", {
            Size = UDim2.new(0, 54, 0, 30), Position = UDim2.new(1, -58, 0.5, -15),
            BackgroundColor3 = Theme.Accent2, Text = "FORCE", TextColor3 = Theme.Text,
            Font = Enum.Font.GothamBold, TextSize = 9, Parent = row,
        })
        corner(forceBtn, 5)

        task.spawn(function()
            while row.Parent and jobId do
                if force.targetJobId == jobId and isForceActive() then
                    TweenService:Create(forceBtn, TweenInfo.new(0.25), { BackgroundTransparency = 0.4 }):Play()
                    task.wait(0.25)
                    TweenService:Create(forceBtn, TweenInfo.new(0.25), { BackgroundTransparency = 0 }):Play()
                    task.wait(0.25)
                else
                    forceBtn.BackgroundTransparency = 0
                    task.wait(0.5)
                end
            end
        end)

        forceBtn.MouseButton1Click:Connect(function()
            if jobId then
                state.joined = true
                startForceSpam(egg)
            else
                notify("ERROR: Missing JobId", Theme.Accent)
            end
        end)
    end
end

local configPanel = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.BgMain,
    BackgroundTransparency = 0.05, BorderSizePixel = 0, Visible = false, Parent = mainFrame,
})
corner(configPanel, 12)

new("TextLabel", {
    Size = UDim2.new(1, -60, 0, 28), Position = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1, Text = "CONFIGURATION",
    TextColor3 = Theme.Gold, Font = Enum.Font.GothamBold, TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left, Parent = configPanel,
})
local closeConfigBtn = new("TextButton", {
    Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -34, 0, 0),
    BackgroundTransparency = 1, Text = "X", TextColor3 = Theme.TextDim,
    Font = Enum.Font.GothamBold, TextSize = 14, Parent = configPanel,
})

local configScroll = new("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -80), Position = UDim2.new(0, 8, 0, 32),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = configPanel,
})
new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = configScroll })

local configBoxes, orderCounter = {}, 0
local function addSectionHeader(text)
    orderCounter = orderCounter + 1
    new("TextLabel", {
        Size = UDim2.new(1, -6, 0, 20), BackgroundTransparency = 1,
        Text = text, TextColor3 = Theme.Accent2,
        Font = Enum.Font.GothamBold, TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = orderCounter, Parent = configScroll,
    })
end
local function addConfigField(label, key)
    orderCounter = orderCounter + 1
    local row = new("Frame", {
        Size = UDim2.new(1, -6, 0, 26), BackgroundTransparency = 1,
        LayoutOrder = orderCounter, Parent = configScroll,
    })
    new("TextLabel", {
        Size = UDim2.new(0, 170, 1, 0), BackgroundTransparency = 1,
        Text = label, TextColor3 = Theme.Text,
        Font = Enum.Font.GothamMedium, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    local box = new("TextBox", {
        Size = UDim2.new(1, -180, 1, 0), Position = UDim2.new(0, 175, 0, 0),
        BackgroundColor3 = Theme.BgMain, BackgroundTransparency = 0.3,
        Text = tostring(CONFIG[key]), TextColor3 = Theme.Text,
        Font = Enum.Font.GothamMedium, TextSize = 10,
        ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Center, Parent = row,
    })
    corner(box, 4); stroke(box)
    new("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, box)
    configBoxes[key] = box
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then
            if key == "MIN_RARITY" then n = clamp(n, 0, 6)
            elseif key == "MIN_MONEY" then n = math.max(0, n)
            elseif key == "CHECK_INTERVAL" then n = clamp(n, 1, 600)
            elseif key == "MAX_DISPLAY" then n = clamp(n, 10, 2000)
            elseif key == "FORCE_DELAY" then n = clamp(n, 0.005, 10)
            elseif key == "FORCE_AUTO_DISABLE" then n = clamp(n, 1, 120)
            elseif key == "UI_SCALE" then n = clamp(n, 0.5, 1.2); mainScale.Scale = n end
            CONFIG[key] = n; saveConfig()
        end
        box.Text = tostring(CONFIG[key])
    end)
end

addSectionHeader("> JOIN BEHAVIOR")
addConfigField("UI Scale (0.5-1.2)", "UI_SCALE")
addConfigField("Min Rarity (0-6)", "MIN_RARITY")
addConfigField("Min Money ($/s)", "MIN_MONEY")
addConfigField("Force Delay (s)", "FORCE_DELAY")
addConfigField("Force Auto-Disable (s)", "FORCE_AUTO_DISABLE")
addSectionHeader("> SCANNING")
addConfigField("Check Interval (s)", "CHECK_INTERVAL")
addConfigField("Max Eggs Display", "MAX_DISPLAY")

local btnBar = new("Frame", {
    Size = UDim2.new(1, -16, 0, 32), Position = UDim2.new(0, 8, 1, -38),
    BackgroundTransparency = 1, Parent = configPanel,
})
local resetBtn = new("TextButton", {
    Size = UDim2.new(0.48, 0, 1, 0), BackgroundColor3 = Theme.BgLight,
    Text = "RESET", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 10, Parent = btnBar,
})
corner(resetBtn, 5); stroke(resetBtn)
resetBtn.MouseButton1Click:Connect(function()
    for k, v in pairs(DEFAULT_CONFIG) do
        if configBoxes[k] then CONFIG[k] = v; configBoxes[k].Text = tostring(v) end
    end
    saveConfig(); notify("Settings reset", Theme.Green)
end)
local closeBtn2 = new("TextButton", {
    Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0),
    BackgroundColor3 = Theme.Accent, Text = "CLOSE", TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold, TextSize = 10, Parent = btnBar,
})
corner(closeBtn2, 5)
new("UIGradient", { Color = ColorSequence.new(Theme.Accent, Theme.Accent2) }, closeBtn2)

settingsBtn.MouseButton1Click:Connect(function() configPanel.Visible = not configPanel.Visible end)
closeConfigBtn.MouseButton1Click:Connect(function() configPanel.Visible = false end)
closeBtn2.MouseButton1Click:Connect(function() configPanel.Visible = false end)

local diagPanel = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.BgMain,
    BackgroundTransparency = 0.02, BorderSizePixel = 0, Visible = false, Parent = mainFrame,
})
corner(diagPanel, 12)

new("TextLabel", {
    Size = UDim2.new(1, -60, 0, 28), Position = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1, Text = "API DIAGNOSTIC",
    TextColor3 = Theme.Accent2, Font = Enum.Font.GothamBold, TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left, Parent = diagPanel,
})
local closeDiagBtn = new("TextButton", {
    Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -34, 0, 0),
    BackgroundTransparency = 1, Text = "X", TextColor3 = Theme.TextDim,
    Font = Enum.Font.GothamBold, TextSize = 14, Parent = diagPanel,
})
closeDiagBtn.MouseButton1Click:Connect(function() diagPanel.Visible = false end)

local diagScroll = new("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -80), Position = UDim2.new(0, 8, 0, 32),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = diagPanel,
})
new("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = diagScroll })

local diagOrder = 0
local function diagLine(text, color)
    diagOrder = diagOrder + 1
    new("TextLabel", {
        Size = UDim2.new(1, -4, 0, 16), BackgroundTransparency = 1,
        Text = text, TextColor3 = color or Theme.Text, Font = Enum.Font.Code, TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = false, LayoutOrder = diagOrder, Parent = diagScroll,
    })
end

diagBtn.MouseButton1Click:Connect(function()
    diagPanel.Visible = not diagPanel.Visible
    if diagPanel.Visible then
        for _, c in ipairs(diagScroll:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
        diagOrder = 0
        local data, err = httpGetRaw("/logs/all-eggs")
        if not data then diagLine("ERROR: " .. tostring(err), Theme.Accent) return end
        local list = (type(data) == "table" and type(data.eggs) == "table") and data.eggs or data
        if type(list) ~= "table" then diagLine("ERROR: Invalid API payload", Theme.Accent); return end
        diagLine("HTTP 200. Eggs found: " .. tostring(#list), Theme.Green)
        if #list > 0 then
            table.sort(list, function(a, b) return (tonumber(a.income) or 0) > (tonumber(b.income) or 0) end)
            diagLine("Top 1: " .. tostring(list[1].name) .. " ($" .. tostring(list[1].income) .. "/s)")
            local jid = getServerIds(list[1])
            diagLine("Server ID: hidden", jid and Theme.Green or Theme.Accent)
        end
    end
end)

task.spawn(function()
    while true do
        if state.authenticated then
            local okAll, allData = pcall(httpGetRaw, "/logs/all-eggs")
            if okAll and allData then
                local list = (type(allData) == "table" and type(allData.eggs) == "table") and allData.eggs or allData
                if type(list) == "table" then
                    renderList(list)
                else
                    state.bestData = nil
                end

                if state.bestData and state.autoJoin and not state.joined then
                    local r = tonumber(state.bestData.rarity) or 0
                    local inc = tonumber(state.bestData.income) or 0
                    local jobId = getServerIds(state.bestData)
                    local meetsMin = state.autoForce or isForceActive() or (r >= CONFIG.MIN_RARITY and inc >= CONFIG.MIN_MONEY)
                    if meetsMin and jobId and jobId ~= state.lastJobId and jobId ~= game.JobId then
                        state.lastJobId = jobId
                        state.joined = true
                        if state.autoForce or isForceActive() then
                            startForceSpam(state.bestData)
                        else
                            fireTeleport(state.bestData)
                        end
                    end
                end
            end
            task.wait(CONFIG.CHECK_INTERVAL)
            state.joined = false
        else
            task.wait(0.25)
        end
    end
end)

local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if configPanel.Visible or diagPanel.Visible or state.isMinimized then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true; dragStart = input.Position; startPos  = mainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

minBtn.MouseButton1Click:Connect(function()
    state.isMinimized = not state.isMinimized
    local targetSize = state.isMinimized and UDim2.new(0, UI_WIDTH, 0, 28) or UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT)

    if state.isMinimized then
        bestFrame.Visible = false
        toggleFrame.Visible = false
        listFrame.Visible = false
        configPanel.Visible = false
        diagPanel.Visible = false
        bgOverlay.BackgroundTransparency = 0.8
    else
        task.wait(0.2)
        bestFrame.Visible = true
        toggleFrame.Visible = true
        listFrame.Visible = true
        bgOverlay.BackgroundTransparency = 0.5
    end

    TweenService:Create(mainFrame, TweenInfo.new(0.2), { Size = targetSize }):Play()
end)