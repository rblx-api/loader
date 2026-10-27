repeat task.wait() until game:IsLoaded()

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local HttpService       = game:GetService("HttpService")
local TeleportService   = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    LocalPlayer = Players.PlayerAdded:Wait()
end
local isMobile = UserInputService.TouchEnabled

local function getGuiParent()
    local ok, result = pcall(function()
        if type(gethui) == "function" then return gethui() end
    end)
    if ok and result then return result end
    ok, result = pcall(function() return game:GetService("CoreGui") end)
    if ok and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local IMAGE_ID           = "rbxassetid://126329262656458"
local TITLE              = "XPLT FINDER"
local API_URL            = "https://pet-nexus-guard.base44.app/api/resources/compendium"
-- ── KEY RESOLVER ─────────────────────────────────────────────────────────────
-- Busca la clave en múltiples fuentes remotas/locales.
-- Formato esperado en cualquier fuente:  API_KEY="<valor>"
-- Devuelve la primera clave válida que encuentre.

local KEY_SOURCES = {
    "https://raw.githubusercontent.com/rblx-api/loader/main/.lua",
    -- agrega aquí más URLs si necesitas redundancia:
    -- "https://raw.githubusercontent.com/rblx-api/loader/main/keys.cfg",
}
local KEY_LOCAL_FILE = "XPLT_Key.cfg"   -- también busca en archivo local si el executor lo permite

local function rawFetch(url)
    -- fetch plano sin cabeceras de auth (para bootstrap de la propia key)
    local ok, res = pcall(function()
        local fn = (syn and syn.request) or http_request or request
        if fn then return fn({ Url = url, Method = "GET" }) end
    end)
    if ok and res and res.Body and #res.Body > 0 then return res.Body end
    ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and res and #res > 0 then return res end
    ok, res = pcall(function() return HttpService:GetAsync(url) end)
    if ok and res then return res end
    return nil
end

local function parseKeys(body)
    -- extrae todos los valores  API_KEY="..."  del texto
    local keys = {}
    for v in tostring(body):gmatch('API_KEY%s*=%s*"([^"]+)"') do
        if v ~= "" then keys[#keys + 1] = v end
    end
    return keys
end

local function resolveKey()
    -- 1. ⭐ script_config tabla — el usuario la puso ANTES del loadstring()
    --    Formato exacto:
    --      script_config = {
    --          API_KEY = "REN-1865F734DCBF13492061E592601BAE8F20FC"
    --      }
    --      loadstring(game:HttpGet("https://raw.githubusercontent.com/rblx-api/loader/main/.lua"))()
    local cfg = rawget(_G, "script_config")
    if type(cfg) == "table" then
        local k = cfg.API_KEY
        if type(k) == "string" and k ~= "" then
            return k
        end
    end

    -- 2. fuentes remotas (loader URL, etc.)
    for _, url in ipairs(KEY_SOURCES) do
        local body = rawFetch(url)
        if body then
            local keys = parseKeys(body)
            if keys[1] then return keys[1] end
        end
    end

    -- 3. archivo local  XPLT_Key.cfg  (si el executor expone readfile/isfile)
    if isfile and readfile and isfile(KEY_LOCAL_FILE) then
        local ok, data = pcall(readfile, KEY_LOCAL_FILE)
        if ok and data then
            local keys = parseKeys(data)
            if keys[1] then return keys[1] end
        end
    end

    -- 4. sin key → nil; las cabeceras simplemente no se envían
    return nil
end

local REN_KEY = resolveKey()
-- ─────────────────────────────────────────────────────────────────────────────
local REFRESH_INTERVAL   = 1
local MAX_ITEMS          = 300
local DEFAULT_RARITY     = "Secret"
local FORCE_INTERVAL     = 3
local AUTO_POST          = true
local POST_MIN_VALUE     = 500000000
local POST_SCAN_INTERVAL = 8
local POST_COOLDOWN      = 300

local Config = {
    autoJoin        = false,
    autoForce       = false,
    logSoundEnabled = true,
    logNotify       = true,
    antiGuard       = false,
    autoSteal       = false,
}

local function playLogSound()
    if not Config.logSoundEnabled then return end
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://113965408117166"
    sound.Volume = 1
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
    task.delay(15, function()
        if sound and sound.Parent then sound:Destroy() end
    end)
end

local blacklist     = {}
local blacklistFile = "XPLT_Blacklist.json"

local function loadBlacklist()
    if isfile and readfile and isfile(blacklistFile) then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(blacklistFile))
        end)
        if ok and type(data) == "table" then
            for _, name in ipairs(data) do
                if type(name) == "string" and name ~= "" then
                    blacklist[name] = true
                end
            end
        end
    end
end

local function saveBlacklist()
    if not writefile then return end
    local arr = {}
    for name in pairs(blacklist) do arr[#arr + 1] = name end
    table.sort(arr)
    pcall(function()
        writefile(blacklistFile, HttpService:JSONEncode(arr))
    end)
end

local function isBlacklisted(e)
    return e and e.name and blacklist[e.name] == true
end

loadBlacklist()

local rarityByName, colorByName  = {}, {}
local displayByName, iconByName  = {}, {}

local function findIcon(e)
    for _, k in ipairs({ "Icon", "IconId", "Image", "ImageId", "Thumbnail" }) do
        local v = e[k]
        if v ~= nil then
            local id = tostring(v):match("(%d%d%d%d%d+)")
            if id then return id end
        end
    end
    return nil
end

do
    local ok, err = pcall(function()
        local dataFolder   = ReplicatedStorage:WaitForChild("Data", 5)
        if not dataFolder then error("Data folder missing") end
        local assetsModule = dataFolder:WaitForChild("Assets", 5)
        if not assetsModule then error("Assets module missing") end
        local Assets = require(assetsModule)
        if type(Assets) ~= "table" or type(Assets.Directory) ~= "table" then
            error("Assets.Directory missing")
        end
        for id, e in pairs(Assets.Directory) do
            if type(e) == "table" and type(e.Rarity) == "table" then
                local r    = e.Rarity.DisplayName or e.Rarity._id
                local icon = findIcon(e)
                rarityByName[id]  = r
                colorByName[id]   = e.Rarity.Color
                displayByName[id] = e.DisplayName or tostring(id)
                iconByName[id]    = icon
                if e.DisplayName then
                    rarityByName[e.DisplayName]  = r
                    colorByName[e.DisplayName]   = e.Rarity.Color
                    displayByName[e.DisplayName] = e.DisplayName
                    iconByName[e.DisplayName]    = icon
                end
            end
        end
    end)
    if not ok then
        warn("[" .. XPLT .. "] Gagal load Assets (fallback ke default):", err)
    end
end

local function getRarity(petName)
    return rarityByName[petName]
end

local function getRarityColor(petName)
    local c = colorByName[petName]
    if typeof(c) == "Color3" then return c end
    return nil
end

local autoJoinState   = false
local autoForceState  = false
local lastAutoJoinJob = nil
local forceKey, forceJobId, forceRun = nil, nil, 0

local render, startForce, stopForce, joinServer

local ageLabels = {}
local hidden    = {}
local latest    = {}

local postedAt   = {}
local postOk, postFail, scanCount, lastPostStatus = 0, 0, 0, "-"
local postPauseUntil = 0

local VALUE_PATTERN = "^%s*%$?%s*([%d%.,]+)%s*([KkMmBbTt]?)%s*/%s*[sS]%s*$"
local UNIT_MUL      = { K = 1e3, M = 1e6, B = 1e9, T = 1e12 }

local function formatValue(v)
    local units = { {1e12,"T"}, {1e9,"B"}, {1e6,"M"}, {1e3,"K"} }
    for _, u in ipairs(units) do
        if v >= u[1] then
            return ("$%.1f%s/s"):format(v / u[1], u[2])
        end
    end
    return ("$%d/s"):format(math.floor(v))
end

local function formatAge(tsMs)
    local s = math.max(0, math.floor(os.time() - tsMs / 1000))
    return ("%d:%02d"):format(math.floor(s / 60), s % 60)
end

local function richColor(c)
    return ("rgb(%d,%d,%d)"):format(
        math.floor(c.R * 255 + 0.5),
        math.floor(c.G * 255 + 0.5),
        math.floor(c.B * 255 + 0.5))
end

local function escapeRich(s)
    return (tostring(s):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"))
end

local function httpGet(url)
    local okR, res = pcall(function()
        local fn = (syn and syn.request) or http_request or request
        if fn then return fn({ Url = url, Method = "GET", Headers = { ["x-ren-key"] = REN_KEY } }) end
        return nil
    end)
    if okR and res and res.Body then return res.Body end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and body then return body end
    local ok2, body2 = pcall(function() return HttpService:GetAsync(url) end)
    if ok2 then return body2 end
    return nil
end

local WHITE    = Color3.fromRGB(255, 255, 255)
local GRAY     = Color3.fromRGB(200, 200, 200)
local DARK     = Color3.fromRGB(120, 120, 120)
local BG       = Color3.fromRGB(25, 25, 25)
local CARD     = Color3.fromRGB(50, 50, 50)
local CARD2    = Color3.fromRGB(40, 40, 40)
local SWITCH   = Color3.fromRGB(45, 45, 45)
local SWITCHON = Color3.fromRGB(190, 190, 190)
local MUTED    = Color3.fromRGB(120, 120, 120)
local SUB_TEXT = Color3.fromRGB(175, 175, 175)

local FONT_BLACK = Enum.Font.GothamBlack
local FONT_BOLD  = Enum.Font.GothamBold
local FONT_MED   = Enum.Font.GothamMedium
local FONT_REG   = Enum.Font.Gotham

local gradients = {}

local function makeGradient(c1, c2)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0,    c1),
        ColorSequenceKeypoint.new(0.25, c2),
        ColorSequenceKeypoint.new(0.5,  c1),
        ColorSequenceKeypoint.new(0.75, c2),
        ColorSequenceKeypoint.new(1,    c1),
    })
end

local function addCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function addStroke(parent, thickness, bright)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 1
    s.Color = WHITE
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    local g = Instance.new("UIGradient")
    g.Rotation = 45
    g.Color = makeGradient(bright and WHITE or GRAY, DARK)
    g.Parent = s
    table.insert(gradients, g)
    return s, g
end

local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then obj[k] = v end
    end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end

local function tween(obj, props, time, style, dir)
    if not obj or not obj.Parent then return end
    pcall(function()
        TweenService:Create(obj, TweenInfo.new(
            time or 0.35,
            style or Enum.EasingStyle.Quint,
            dir   or Enum.EasingDirection.Out
        ), props):Play()
    end)
end

local rot = 0
RunService.Heartbeat:Connect(function(dt)
    rot = (rot + dt * 40) % 360
    for i = #gradients, 1, -1 do
        local g = gradients[i]
        if not g or not g.Parent then
            table.remove(gradients, i)
        elseif i <= 20 then
            g.Rotation = (g.Parent:IsA("UIStroke") and (45 + rot) or rot) % 360
        end
    end
end)

local GuiParent = getGuiParent()
for _, name in ipairs({
    "XPLT_Finder_UI","XPLT_KeyPrompt","CeboFinder_UI","CeboFinder","CeboEggFinder"
}) do
    local old = GuiParent:FindFirstChild(name)
    if old then old:Destroy() end
end

local scaleFactor = isMobile and 0.85 or 1

local ScreenGui = create("ScreenGui", {
    Name            = "XPLT_Finder_UI",
    ResetOnSpawn    = false,
    IgnoreGuiInset  = true,
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
    Parent          = GuiParent,
})

local Main = create("Frame", {
    Name                 = "Main",
    AnchorPoint          = Vector2.new(0.5, 0.5),
    Position             = UDim2.new(0.5, 0, 0.5, 0),
    Size                 = isMobile and UDim2.new(0, 420, 0, 280) or UDim2.new(0, 520, 0, 340),
    BackgroundColor3     = BG,
    BackgroundTransparency = 0.55,
    BorderSizePixel      = 0,
    ClipsDescendants     = true,
    ZIndex               = 1,
    Parent               = ScreenGui,
})
addCorner(Main, 12)
local MainScale = create("UIScale", { Scale = scaleFactor, Parent = Main })
addStroke(Main, 1.5, true)

create("ImageLabel", {
    Size               = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image              = IMAGE_ID,
    ImageColor3        = Color3.fromRGB(255, 255, 255),
    ImageTransparency  = 0.08,
    ScaleType          = Enum.ScaleType.Crop,
    ZIndex             = 0,
    Parent             = Main,
})

local sideW = isMobile and 100 or 130

local Sidebar = create("Frame", {
    Size                 = UDim2.new(0, sideW, 1, 0),
    BackgroundColor3     = BG,
    BackgroundTransparency = 0.35,
    BorderSizePixel      = 0,
    ZIndex               = 2,
    Parent               = Main,
})
addCorner(Sidebar, 12)

create("Frame", {
    Size                 = UDim2.new(0, 1, 0.9, 0),
    AnchorPoint          = Vector2.new(0, 0.5),
    Position             = UDim2.new(1, 0, 0.5, 0),
    BackgroundColor3     = WHITE,
    BackgroundTransparency = 0.7,
    BorderSizePixel      = 0,
    ZIndex               = 3,
    Parent               = Sidebar,
})

local Content = create("Frame", {
    Size                 = UDim2.new(1, -(sideW + 4), 1, 0),
    Position             = UDim2.new(0, sideW + 4, 0, 0),
    BackgroundTransparency = 1,
    ZIndex               = 2,
    Parent               = Main,
})

local SideHeader = create("Frame", {
    Size                 = UDim2.new(1, 0, 0, 76),
    BackgroundTransparency = 1,
    ZIndex               = 3,
    Parent               = Sidebar,
})

local TitleLbl = create("TextLabel", {
    Size                 = UDim2.new(1, -20, 0, 22),
    Position             = UDim2.new(0, 14, 0, 10),
    BackgroundTransparency = 1,
    Text                 = TITLE,
    TextColor3           = WHITE,
    TextSize             = 14,
    Font                 = FONT_BLACK,
    TextXAlignment       = Enum.TextXAlignment.Left,
    ZIndex               = 4,
    Parent               = SideHeader,
})
local titleGrad = Instance.new("UIGradient")
titleGrad.Color = makeGradient(WHITE, GRAY)
titleGrad.Parent = TitleLbl
table.insert(gradients, titleGrad)

local StatusDot = create("Frame", {
    Size             = UDim2.new(0, 6, 0, 6),
    Position         = UDim2.new(0, 16, 0, 44),
    BackgroundColor3 = DARK,
    BorderSizePixel  = 0,
    ZIndex           = 4,
    Parent           = SideHeader,
})
addCorner(StatusDot, 1)

local StatusText = create("TextLabel", {
    Size                 = UDim2.new(1, -30, 0, 16),
    Position             = UDim2.new(0, 28, 0, 39),
    BackgroundTransparency = 1,
    Text                 = "Connecting...",
    TextColor3           = DARK,
    TextSize             = 11,
    Font                 = FONT_REG,
    TextXAlignment       = Enum.TextXAlignment.Left,
    ZIndex               = 4,
    Parent               = SideHeader,
})

local PostLabel = create("TextLabel", {
    Size                 = UDim2.new(1, -20, 0, 13),
    Position             = UDim2.new(0, 14, 0, 58),
    BackgroundTransparency = 1,
    Text                 = "Post: –",
    TextColor3           = MUTED,
    TextSize             = 9,
    Font                 = FONT_REG,
    TextXAlignment       = Enum.TextXAlignment.Left,
    TextTruncate         = Enum.TextTruncate.AtEnd,
    ZIndex               = 4,
    Parent               = SideHeader,
})

local TabList = create("Frame", {
    Size                 = UDim2.new(1, 0, 1, -136),
    Position             = UDim2.new(0, 0, 0, 80),
    BackgroundTransparency = 1,
    ZIndex               = 3,
    Parent               = Sidebar,
})
create("UIListLayout", {
    Padding              = UDim.new(0, 4),
    HorizontalAlignment  = Enum.HorizontalAlignment.Center,
    SortOrder            = Enum.SortOrder.LayoutOrder,
    Parent               = TabList,
})

local TabIndicator = create("Frame", {
    Size                 = UDim2.new(1, -16, 0, 36),
    Position             = UDim2.new(0, 8, 0, 80),
    BackgroundColor3     = WHITE,
    BackgroundTransparency = 0.8,
    BorderSizePixel      = 0,
    ZIndex               = 2,
    Parent               = Sidebar,
})
addCorner(TabIndicator, 8)
addStroke(TabIndicator, 1, true)

local Tabs, Pages = {}, {}
local currentTab  = nil
local tabOrder    = { "Logs", "History", "Blacklist", "Settings" }

local function switchTab(name)
    if name == currentTab then return end
    currentTab = name
    for tabName, btn in pairs(Tabs) do
        local active = (tabName == name)
        tween(btn, { TextColor3 = active and WHITE or GRAY })
        btn.Font = active and FONT_BOLD or FONT_MED
        if Pages[tabName] then
            Pages[tabName].Visible = active
            if active then
                Pages[tabName].GroupTransparency = 1
                tween(Pages[tabName], { GroupTransparency = 0 }, 0.3)
            end
        end
    end
    local idx = 0
    for i, t in ipairs(tabOrder) do
        if t == name then idx = i - 1 break end
    end
    tween(TabIndicator, {
        Position = UDim2.new(0, 8, 0, 80 + idx * 40),
        Size     = UDim2.new(1, -16, 0, 36),
    }, 0.35)
end

for i, name in ipairs(tabOrder) do
    local btn = create("TextButton", {
        Size                 = UDim2.new(1, -20, 0, 36),
        BackgroundTransparency = 1,
        Text                 = name,
        TextColor3           = GRAY,
        TextSize             = 12,
        Font                 = FONT_BOLD,
        AutoButtonColor      = false,
        LayoutOrder          = i,
        ZIndex               = 4,
        Parent               = TabList,
    })
    btn.MouseEnter:Connect(function()
        if name ~= currentTab then tween(btn, { TextColor3 = WHITE }) end
    end)
    btn.MouseLeave:Connect(function()
        if name ~= currentTab then tween(btn, { TextColor3 = GRAY }) end
    end)
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    Tabs[name] = btn
end

local HideBtn = create("TextButton", {
    Size                 = UDim2.new(1, -24, 0, 34),
    Position             = UDim2.new(0, 12, 1, -42),
    BackgroundColor3     = CARD,
    BackgroundTransparency = 0.4,
    Text                 = "Hide",
    TextColor3           = GRAY,
    TextSize             = 12,
    Font                 = FONT_BOLD,
    AutoButtonColor      = false,
    ZIndex               = 4,
    Parent               = Sidebar,
})
addCorner(HideBtn, 10)
addStroke(HideBtn, 1, false)
HideBtn.MouseEnter:Connect(function()
    tween(HideBtn, { BackgroundTransparency = 0.1, TextColor3 = WHITE })
end)
HideBtn.MouseLeave:Connect(function()
    tween(HideBtn, { BackgroundTransparency = 0.4, TextColor3 = GRAY })
end)

local Mini = create("Frame", {
    Size                 = UDim2.new(0, 56, 0, 56),
    AnchorPoint          = Vector2.new(0, 0.5),
    Position             = UDim2.new(0, 18, 0.58, 0),
    BackgroundColor3     = BG,
    BackgroundTransparency = 0.1,
    Visible              = false,
    ClipsDescendants     = true,
    ZIndex               = 100,
    Parent               = ScreenGui,
})
addCorner(Mini, 28)
addStroke(Mini, 2, true)

local MiniImage = create("ImageLabel", {
    Size               = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image              = IMAGE_ID,
    ImageColor3        = Color3.fromRGB(255, 255, 255),
    ScaleType          = Enum.ScaleType.Crop,
    ZIndex             = 100,
    Parent             = Mini,
})
addCorner(MiniImage, 28)

local MiniBtn = create("TextButton", {
    Size               = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text               = "",
    AutoButtonColor    = false,
    ZIndex             = 101,
    Parent             = Mini,
})

HideBtn.MouseButton1Click:Connect(function()
    tween(MainScale, { Scale = 0 }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.4, function()
        Main.Visible = false
        Mini.Visible = true
        Mini.Size = UDim2.new(0, 0, 0, 0)
        tween(Mini, { Size = UDim2.new(0, 56, 0, 56) }, 0.4, Enum.EasingStyle.Back)
    end)
end)

local dragging, dragStart, startPos, moved
MiniBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging, moved = true, false
        dragStart, startPos = input.Position, Mini.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStart
    if delta.Magnitude > 10 then
        moved = true
        Mini.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
MiniBtn.MouseButton1Click:Connect(function()
    if moved then return end
    tween(Mini, { Size = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.3, function()
        Mini.Visible = false
        Main.Visible = true
        tween(MainScale, { Scale = scaleFactor }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
end)

local dragBar = create("TextButton", {
    Size               = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Text               = "",
    ZIndex             = 10,
    Parent             = Main,
})
local mainDragging, mainStart, mainPos
dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging, mainStart, mainPos = true, input.Position, Main.Position
    end
end)
dragBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not mainDragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = (input.Position - mainStart) / MainScale.Scale
    Main.Position = UDim2.new(
        mainPos.X.Scale, mainPos.X.Offset + delta.X,
        mainPos.Y.Scale, mainPos.Y.Offset + delta.Y)
end)

local function createSwitch(parent, y, labelText, configKey, onToggle)
    local frame = create("Frame", {
        Size                 = UDim2.new(1, 0, 0, 48),
        Position             = UDim2.new(0, 0, 0, y),
        BackgroundColor3     = CARD2,
        BackgroundTransparency = 0.3,
        BorderSizePixel      = 0,
        ZIndex               = 3,
        Parent               = parent,
    })
    addCorner(frame, 10)
    addStroke(frame, 1, true)

    create("TextLabel", {
        Size                 = UDim2.new(1, -70, 1, 0),
        Position             = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text                 = labelText,
        TextColor3           = WHITE,
        TextSize             = 12,
        Font                 = FONT_BOLD,
        TextXAlignment       = Enum.TextXAlignment.Left,
        ZIndex               = 4,
        Parent               = frame,
    })

    local bg = create("TextButton", {
        AnchorPoint          = Vector2.new(1, 0.5),
        Position             = UDim2.new(1, -12, 0.5, 0),
        Size                 = UDim2.new(0, 46, 0, 24),
        BackgroundColor3     = SWITCH,
        BorderSizePixel      = 0,
        Text                 = "",
        AutoButtonColor      = false,
        ZIndex               = 4,
        Parent               = frame,
    })
    addCorner(bg, 12)
    local _, grad = addStroke(bg, 1, false)

    local knob = create("Frame", {
        Size             = UDim2.new(0, 18, 0, 18),
        Position         = UDim2.new(0, 3, 0.5, -9),
        BackgroundColor3 = WHITE,
        BorderSizePixel  = 0,
        ZIndex           = 5,
        Parent           = bg,
    })
    addCorner(knob, 9)

    local function update()
        local on = Config[configKey]
        tween(bg,   { BackgroundColor3 = on and SWITCHON or SWITCH }, 0.25)
        tween(knob, { Position = on
            and UDim2.new(1, -21, 0.5, -9)
            or  UDim2.new(0,   3, 0.5, -9)
        }, 0.28, Enum.EasingStyle.Quint)
        if grad then grad.Color = makeGradient(on and WHITE or GRAY, DARK) end
    end
    update()

    bg.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        update()
        if onToggle then onToggle(Config[configKey]) end
    end)
    return frame
end

local LogsPage = create("CanvasGroup", {
    Size                 = UDim2.new(1, -32, 1, -32),
    Position             = UDim2.new(0, 16, 0, 16),
    BackgroundTransparency = 1,
    ZIndex               = 2,
    Parent               = Content,
})
Pages.Logs = LogsPage

local togglesRow = create("Frame", {
    Size                 = UDim2.new(1, 0, 0, 44),
    BackgroundTransparency = 1,
    ZIndex               = 3,
    Parent               = LogsPage,
})

local aj = createSwitch(togglesRow, 0, "Auto-Join", "autoJoin", function(v)
    autoJoinState = v
    if render then render() end
end)
aj.Size     = UDim2.new(0.48, 0, 0, 44)

local af = createSwitch(togglesRow, 0, "Auto-Force", "autoForce", function(v)
    autoForceState = v
    if not v and stopForce then stopForce() end
    if render then render() end
end)
af.Size     = UDim2.new(0.48, 0, 0, 44)
af.Position = UDim2.new(0.52, 0, 0, 0)

local feedHeader = create("Frame", {
    Size                 = UDim2.new(1, 0, 0, 20),
    Position             = UDim2.new(0, 0, 0, 52),
    BackgroundTransparency = 1,
    ZIndex               = 3,
    Parent               = LogsPage,
})

local feedTitleLbl = create("TextLabel", {
    Size                 = UDim2.new(0, 80, 1, 0),
    BackgroundTransparency = 1,
    Text                 = "LIVE FEED",
    TextColor3           = WHITE,
    TextSize             = 11,
    Font                 = FONT_BOLD,
    TextXAlignment       = Enum.TextXAlignment.Left,
    ZIndex               = 4,
    Parent               = feedHeader,
})
local ftGrad = Instance.new("UIGradient")
ftGrad.Color = makeGradient(WHITE, GRAY)
ftGrad.Parent = feedTitleLbl
table.insert(gradients, ftGrad)

local detectedLabel = create("TextLabel", {
    AnchorPoint          = Vector2.new(1, 0),
    Position             = UDim2.new(1, -56, 0, 0),
    Size                 = UDim2.new(0, 80, 1, 0),
    BackgroundTransparency = 1,
    Text                 = "0 detected",
    TextColor3           = DARK,
    TextSize             = 11,
    Font                 = FONT_REG,
    TextXAlignment       = Enum.TextXAlignment.Right,
    ZIndex               = 4,
    Parent               = feedHeader,
})

local clearBtn = create("TextButton", {
    AnchorPoint          = Vector2.new(1, 0.5),
    Position             = UDim2.new(1, 0, 0.5, 0),
    Size                 = UDim2.new(0, 48, 0, 20),
    BackgroundColor3     = SWITCH,
    BackgroundTransparency = 0.3,
    Text                 = "Clear",
    TextColor3           = WHITE,
    TextSize             = 10,
    Font                 = FONT_BOLD,
    AutoButtonColor      = false,
    ZIndex               = 4,
    Parent               = feedHeader,
})
addCorner(clearBtn, 6)

local feedBg = create("Frame", {
    Size                 = UDim2.new(1, 0, 1, -76),
    Position             = UDim2.new(0, 0, 0, 76),
    BackgroundColor3     = BG,
    BackgroundTransparency = 0.5,
    BorderSizePixel      = 0,
    ZIndex               = 2,
    Parent               = LogsPage,
})
addCorner(feedBg, 12)
addStroke(feedBg, 1, false)

local feedScroll = create("ScrollingFrame", {
    Size                 = UDim2.new(1, -8, 1, -8),
    Position             = UDim2.new(0, 4, 0, 4),
    BackgroundTransparency = 1,
    BorderSizePixel      = 0,
    CanvasSize           = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize  = Enum.AutomaticSize.Y,
    ScrollingDirection   = Enum.ScrollingDirection.Y,
    ScrollBarThickness   = 4,
    ScrollBarImageColor3 = WHITE,
    ZIndex               = 3,
    Parent               = feedBg,
})
create("UIListLayout", {
    Padding    = UDim.new(0, 6),
    SortOrder  = Enum.SortOrder.LayoutOrder,
    Parent     = feedScroll,
})
create("UIPadding", {
    PaddingTop    = UDim.new(0, 4),
    PaddingBottom = UDim.new(0, 4),
    PaddingLeft   = UDim.new(0, 4),
    PaddingRight  = UDim.new(0, 8),
    Parent        = feedScroll,
})

local HistoryPage = create("CanvasGroup", {
    Size                 = UDim2.new(1, -32, 1, -32),
    Position             = UDim2.new(0, 16, 0, 16),
    BackgroundTransparency = 1,
    Visible              = false,
    ZIndex               = 2,
    Parent               = Content,
})
Pages.History = HistoryPage

create("TextLabel", {
    Size                 = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text                 = "HISTORY  (top eggs)",
    TextColor3           = WHITE,
    TextSize             = 11,
    Font                 = FONT_BOLD,
    TextXAlignment       = Enum.TextXAlignment.Left,
    ZIndex               = 4,
    Parent               = HistoryPage,
})

local histBg = create("Frame", {
    Size                 = UDim2.new(1, 0, 1, -28),
    Position             = UDim2.new(0, 0, 0, 28),
    BackgroundColor3     = BG,
    BackgroundTransparency = 0.5,
    BorderSizePixel      = 0,
    ZIndex               = 2,
    Parent               = HistoryPage,
})
addCorner(histBg, 12)
addStroke(histBg, 1, false)

local histScroll = create("ScrollingFrame", {
    Size                 = UDim2.new(1, -8, 1, -8),
    Position             = UDim2.new(0, 4, 0, 4),
    BackgroundTransparency = 1,
    BorderSizePixel      = 0,
    CanvasSize           = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize  = Enum.AutomaticSize.Y,
    ScrollingDirection   = Enum.ScrollingDirection.Y,
    ScrollBarThickness   = 4,
    ScrollBarImageColor3 = WHITE,
    ZIndex               = 3,
    Parent               = histBg,
})
create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = histScroll })
create("UIPadding",    { PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4),
                         PaddingLeft = UDim.new(0,4), PaddingRight  = UDim.new(0,4), Parent = histScroll })

local BlacklistPage = create("CanvasGroup", {
    Size = UDim2.new(1, -32, 1, -32),
    Position = UDim2.new(0, 16, 0, 16),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 2,
    Parent = Content,
})
Pages.Blacklist = BlacklistPage

create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "BLACKLIST",
    TextColor3 = WHITE,
    TextSize = 11,
    Font = FONT_BOLD,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = BlacklistPage,
})

local blacklistBg = create("Frame", {
    Size = UDim2.new(1, 0, 1, -28),
    Position = UDim2.new(0, 0, 0, 28),
    BackgroundColor3 = BG,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ZIndex = 2,
    Parent = BlacklistPage,
})
addCorner(blacklistBg, 12)
addStroke(blacklistBg, 1, false)

local blacklistScroll = create("ScrollingFrame", {
    Size = UDim2.new(1, -8, 1, -8),
    Position = UDim2.new(0, 4, 0, 4),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = WHITE,
    ZIndex = 3,
    Parent = blacklistBg,
})
create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = blacklistScroll })
create("UIPadding", { PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4), PaddingLeft = UDim.new(0,4), PaddingRight = UDim.new(0,4), Parent = blacklistScroll })

local SettingsPage = create("CanvasGroup", {
    Size                 = UDim2.new(1, -32, 1, -32),
    Position             = UDim2.new(0, 16, 0, 16),
    BackgroundTransparency = 1,
    Visible              = false,
    ZIndex               = 2,
    Parent               = Content,
})
Pages.Settings = SettingsPage

create("TextLabel", {
    Size                 = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text                 = "SETTINGS",
    TextColor3           = WHITE,
    TextSize             = 11,
    Font                 = FONT_BOLD,
    TextXAlignment       = Enum.TextXAlignment.Left,
    ZIndex               = 4,
    Parent               = SettingsPage,
})

local SettingsScroll = create("ScrollingFrame", {
    Size                 = UDim2.new(1, 0, 1, -24),
    Position             = UDim2.new(0, 0, 0, 24),
    BackgroundTransparency = 1,
    BorderSizePixel      = 0,
    CanvasSize           = UDim2.new(0, 0, 0, 380),
    ScrollBarThickness   = 4,
    ScrollBarImageColor3 = WHITE,
    ScrollingDirection   = Enum.ScrollingDirection.Y,
    ZIndex               = 3,
    Parent               = SettingsPage,
})

local function makeSettingRow(y, labelText, defaultText, onApply)
    local frame = create("Frame", {
        Size                 = UDim2.new(1, -8, 0, 44),
        Position             = UDim2.new(0, 0, 0, y),
        BackgroundColor3     = CARD2,
        BackgroundTransparency = 0.3,
        BorderSizePixel      = 0,
        ZIndex               = 3,
        Parent               = SettingsScroll,
    })
    addCorner(frame, 10)
    addStroke(frame, 1, true)
    create("TextLabel", {
        Size                 = UDim2.new(0.4, 0, 1, 0),
        Position             = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text                 = labelText,
        TextColor3           = WHITE,
        TextSize             = 12,
        Font                 = FONT_BOLD,
        TextXAlignment       = Enum.TextXAlignment.Left,
        ZIndex               = 4,
        Parent               = frame,
    })
    local box = create("TextBox", {
        AnchorPoint          = Vector2.new(1, 0.5),
        Position             = UDim2.new(1, -14, 0.5, 0),
        Size                 = UDim2.new(0, 100, 0, 28),
        BackgroundColor3     = SWITCH,
        Text                 = defaultText,
        TextColor3           = WHITE,
        TextSize             = 12,
        Font                 = FONT_BOLD,
        ClearTextOnFocus     = false,
        ZIndex               = 4,
        Parent               = frame,
    })
    addCorner(box, 8)
    if onApply then
        box.FocusLost:Connect(function(enterPressed)
            local raw = tostring(box.Text):gsub("%s+", "")
            local num, unit = raw:match("^(%d+%.?%d*)([KkMmBbTt]?)$")
            local multiplier = ({K=1e3,M=1e6,B=1e9,T=1e12})[(unit or ""):upper()] or 1
            local value = num and tonumber(num) and tonumber(num) * multiplier
            if value and value > 0 then
                onApply(value)
            else
                box.Text = defaultText
            end
        end)
    end
    return box
end

makeSettingRow(0, "Min Threshold", "500M", function(value)
    POST_MIN_VALUE = value
    render()
end)
makeSettingRow(52, "Force Time (s)", "3", function(value)
    FORCE_INTERVAL = math.clamp(value, 1, 60)
end)
createSwitch(SettingsScroll, 112, "Log Sound", "logSoundEnabled")
createSwitch(SettingsScroll, 162, "Log Notifications", "logNotify")

local scanNowBtn = create("TextButton", {
    Size = UDim2.new(1, -8, 0, 36), Position = UDim2.new(0, 0, 0, 212),
    BackgroundColor3 = CARD, Text = "SCAN NOW", TextColor3 = WHITE,
    TextSize = 11, Font = FONT_BOLD, AutoButtonColor = true, ZIndex = 4,
    Parent = SettingsScroll,
})
addCorner(scanNowBtn, 8)
local refreshNowBtn = create("TextButton", {
    Size = UDim2.new(1, -8, 0, 36), Position = UDim2.new(0, 0, 0, 258),
    BackgroundColor3 = CARD, Text = "REFRESH FEED", TextColor3 = WHITE,
    TextSize = 11, Font = FONT_BOLD, AutoButtonColor = true, ZIndex = 4,
    Parent = SettingsScroll,
})
addCorner(refreshNowBtn, 8)
SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, 310)

local function keyOf(e)
    return e.jobId .. "|" .. e.name .. "|" .. tostring(e.ts)
end

local function clearRows()
    for _, c in ipairs(feedScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    table.clear(ageLabels)
end

local function subText(entry)
    local parts = {}
    table.insert(parts, formatAge(entry.ts))
    local rarityText = escapeRich(entry.rarity or DEFAULT_RARITY)
    if entry.rarityColor then
        rarityText = ("<font color=\"%s\">%s</font>"):format(
            richColor(entry.rarityColor), rarityText)
    end
    table.insert(parts, rarityText)
    return table.concat(parts, " • ")
end

local function addRow(data, order)
    local row = create("Frame", {
        LayoutOrder          = order,
        Size                 = UDim2.new(1, -4, 0, 54),
        BackgroundColor3     = CARD2,
        BackgroundTransparency = 0.15,
        BorderSizePixel      = 0,
        ZIndex               = 3,
        Parent               = feedScroll,
    })
    addCorner(row, 10)
    addStroke(row, 1, false)

    local bar = create("Frame", {
        Position         = UDim2.new(0, 5, 0, 5),
        Size             = UDim2.new(0, 4, 0, 44),
        BackgroundColor3 = WHITE,
        BorderSizePixel  = 0,
        ZIndex           = 4,
        Parent           = row,
    })
    addCorner(bar, 2)

    create("ImageLabel", {
        Position           = UDim2.new(0, 16, 0, 7),
        Size               = UDim2.new(0, 38, 0, 38),
        BackgroundTransparency = 1,
        Image              = data.iconId and ("rbxassetid://" .. tostring(data.iconId)) or "",
        ScaleType          = Enum.ScaleType.Fit,
        ZIndex             = 4,
        Parent             = row,
    })

    local titleLbl = create("TextLabel", {
        Position             = UDim2.new(0, 60, 0, 6),
        Size                 = UDim2.new(1, -200, 0, 22),
        BackgroundTransparency = 1,
        Text                 = "",
        TextColor3           = WHITE,
        TextSize             = 13,
        Font                 = FONT_BOLD,
        TextXAlignment       = Enum.TextXAlignment.Left,
        RichText             = true,
        TextScaled           = true,
        ZIndex               = 4,
        Parent               = row,
    })
    create("UITextSizeConstraint", { MaxTextSize = 13, MinTextSize = 8 }, titleLbl)
    titleLbl.Text = ("%s  <font color=\"rgb(255,70,80)\">[ %s ]</font>"):format(
        escapeRich(data.name), formatValue(data.value))

    local sub = create("TextLabel", {
        Position             = UDim2.new(0, 60, 0, 31),
        Size                 = UDim2.new(1, -200, 0, 14),
        BackgroundTransparency = 1,
        Text                 = "",
        TextColor3           = GRAY,
        TextSize             = 10,
        Font                 = FONT_MED,
        TextXAlignment       = Enum.TextXAlignment.Left,
        RichText             = true,
        TextTruncate         = Enum.TextTruncate.AtEnd,
        ZIndex               = 4,
        Parent               = row,
    })
    sub.Text = subText(data)
    table.insert(ageLabels, { label = sub, entry = data })

    local blBtn = create("TextButton", {
        AnchorPoint          = Vector2.new(1, 0.5),
        Position             = UDim2.new(1, -4, 0.5, 0),
        Size                 = UDim2.new(0, 24, 0, 22),
        BackgroundColor3     = CARD,
        BackgroundTransparency = 0.2,
        Text                 = "BL",
        TextColor3           = GRAY,
        TextSize             = 9,
        Font                 = FONT_BOLD,
        AutoButtonColor      = false,
        ZIndex               = 5,
        Parent               = row,
    })
    addCorner(blBtn, 5)
    addStroke(blBtn, 1, false)

    local isForced  = (forceKey == data.key)
    local frcBg     = isForced and SWITCHON or CARD
    local frcBgT    = autoForceState and 0.1 or 0.5
    local frcColor  = autoForceState and WHITE or DARK
    local frcBtn = create("TextButton", {
        AnchorPoint          = Vector2.new(1, 0.5),
        Position             = UDim2.new(1, -34, 0.5, 0),
        Size                 = UDim2.new(0, 44, 0, 22),
        BackgroundColor3     = frcBg,
        BackgroundTransparency = frcBgT,
        Text                 = "FORCE",
        TextColor3           = frcColor,
        TextSize             = 9,
        Font                 = FONT_BOLD,
        AutoButtonColor      = false,
        ZIndex               = 5,
        Parent               = row,
    })
    addCorner(frcBtn, 5)
    if isForced then addStroke(frcBtn, 1, true) end

    local joinBtn = create("TextButton", {
        AnchorPoint          = Vector2.new(1, 0.5),
        Position             = UDim2.new(1, -84, 0.5, 0),
        Size                 = UDim2.new(0, 44, 0, 22),
        BackgroundColor3     = CARD,
        BackgroundTransparency = 0.1,
        Text                 = "JOIN",
        TextColor3           = WHITE,
        TextSize             = 9,
        Font                 = FONT_BOLD,
        AutoButtonColor      = false,
        ZIndex               = 5,
        Parent               = row,
    })
    addCorner(joinBtn, 5)
    addStroke(joinBtn, 1, true)

    joinBtn.MouseButton1Click:Connect(function()
        joinServer(data.jobId)
    end)

    frcBtn.MouseButton1Click:Connect(function()
        if not autoForceState then return end
        if forceKey == data.key then
            stopForce()
        else
            startForce(data.key, data.jobId)
        end
        render()
    end)

    blBtn.MouseButton1Click:Connect(function()
        if data.name and data.name ~= "" then
            blacklist[data.name] = true
            saveBlacklist()
            StatusText.Text = "BL: " .. tostring(data.name):sub(1, 14)
            render()
        end
    end)
end

local function clearContainerRows(container)
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function renderHistory()
    clearContainerRows(histScroll)
    local best = {}
    for _, entry in ipairs(latest) do
        if (tonumber(entry.value) or 0) >= 10000000000 and not hidden[keyOf(entry)] then
            table.insert(best, entry)
        end
    end
    table.sort(best, function(a, b)
        if a.value == b.value then return (a.ts or 0) > (b.ts or 0) end
        return a.value > b.value
    end)
    if #best == 0 then
        create("TextLabel", {
            Size = UDim2.new(1, -8, 0, 34),
            BackgroundTransparency = 1,
            Text = "No logs above $10B/s",
            TextColor3 = MUTED,
            TextSize = 11,
            Font = FONT_MED,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 4,
            Parent = histScroll,
        })
        return
    end
    for index, entry in ipairs(best) do
        local row = create("Frame", {
            Size = UDim2.new(1, -4, 0, 44),
            BackgroundColor3 = CARD2,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            LayoutOrder = index,
            ZIndex = 3,
            Parent = histScroll,
        })
        addCorner(row, 8)
        addStroke(row, 1, false)
        create("TextLabel", {
            Position = UDim2.new(0, 10, 0, 2),
            Size = UDim2.new(1, -100, 0, 22),
            BackgroundTransparency = 1,
            Text = entry.name .. "  [" .. formatValue(entry.value) .. "]",
            TextColor3 = WHITE,
            TextSize = 12,
            Font = FONT_BOLD,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 4,
            Parent = row,
        })
        create("TextLabel", {
            Position = UDim2.new(0, 10, 0, 23),
            Size = UDim2.new(1, -100, 0, 16),
            BackgroundTransparency = 1,
            Text = subText(entry),
            TextColor3 = GRAY,
            TextSize = 9,
            Font = FONT_MED,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 4,
            Parent = row,
        })
        local bl = create("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -6, 0.5, 0),
            Size = UDim2.new(0, 66, 0, 26),
            BackgroundColor3 = CARD,
            Text = "BLACKLIST",
            TextColor3 = WHITE,
            TextSize = 8,
            Font = FONT_BOLD,
            AutoButtonColor = true,
            ZIndex = 5,
            Parent = row,
        })
        addCorner(bl, 6)
        bl.MouseButton1Click:Connect(function()
            blacklist[entry.name] = true
            saveBlacklist()
            StatusText.Text = "Blacklisted"
            render()
        end)
    end
end

local function renderBlacklist()
    clearContainerRows(blacklistScroll)
    local names = {}
    for name in pairs(blacklist) do table.insert(names, name) end
    table.sort(names)
    if #names == 0 then
        create("TextLabel", {
            Size = UDim2.new(1, -8, 0, 34),
            BackgroundTransparency = 1,
            Text = "Blacklist is empty",
            TextColor3 = MUTED,
            TextSize = 11,
            Font = FONT_MED,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 4,
            Parent = blacklistScroll,
        })
        return
    end
    for index, name in ipairs(names) do
        local row = create("Frame", {
            Size = UDim2.new(1, -4, 0, 40),
            BackgroundColor3 = CARD2,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            LayoutOrder = index,
            ZIndex = 3,
            Parent = blacklistScroll,
        })
        addCorner(row, 8)
        addStroke(row, 1, false)
        create("TextLabel", {
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -92, 1, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = WHITE,
            TextSize = 11,
            Font = FONT_BOLD,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 4,
            Parent = row,
        })
        local remove = create("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -6, 0.5, 0),
            Size = UDim2.new(0, 74, 0, 26),
            BackgroundColor3 = CARD,
            Text = "REMOVE",
            TextColor3 = WHITE,
            TextSize = 9,
            Font = FONT_BOLD,
            AutoButtonColor = true,
            ZIndex = 5,
            Parent = row,
        })
        addCorner(remove, 6)
        remove.MouseButton1Click:Connect(function()
            blacklist[name] = nil
            saveBlacklist()
            render()
        end)
    end
end

function render()
    local scroll = feedScroll.CanvasPosition
    clearRows()

    local shown = 0
    for _, e in ipairs(latest) do
        if tonumber(e.value) and tonumber(e.value) >= POST_MIN_VALUE
        and not hidden[keyOf(e)] and not isBlacklisted(e) then
            shown += 1
            if shown <= MAX_ITEMS then addRow(e, shown) end
        end
    end
    detectedLabel.Text = shown .. " detected"
    feedScroll.CanvasPosition = scroll
    renderHistory()
    renderBlacklist()

    if autoJoinState and #latest > 0 then
        for _, e in ipairs(latest) do
            local jid = tostring(e.jobId)
            if tonumber(e.value) and tonumber(e.value) >= POST_MIN_VALUE
            and not hidden[keyOf(e)] and not isBlacklisted(e)
            and jid ~= tostring(game.JobId)
            and jid ~= lastAutoJoinJob then
                lastAutoJoinJob = jid
                joinServer(jid)
                break
            end
        end
    end
end

clearBtn.MouseButton1Click:Connect(function()
    for _, e in ipairs(latest) do
        hidden[keyOf(e)] = true
    end
    render()
end)

TeleportService.TeleportInitFailed:Connect(function(_, result, errorMessage)
    warn("[" ..XPLT .. "] TeleportInitFailed:", tostring(result), tostring(errorMessage))
    if StatusText and StatusText.Parent then
        StatusText.Text = "Join failed"
    end
end)

joinServer = function(jobId)
    jobId = tostring(jobId or "")
    if jobId == "" or jobId == "nil" then
        warn("[" .. XPLT .. "] Join failed: empty jobId")
        return
    end
    if jobId == tostring(game.JobId) then
        warn("[" .. TITLE .. "] Already in this server")
        return
    end

    local placeId = game.PlaceId
    StatusText.Text = "Joining..."

    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
    end)
    if ok then return end
    warn("[" .. TITLE .. "] Join method 1 failed:", err)

    ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, jobId)
    end)
    if ok then return end
    warn("[" .. TITLE .. "] Join method 2 failed:", err)

    local fn = (syn and syn.request) or http_request or request
    if fn then
        ok, err = pcall(function()
            fn({
                Url    = "https://gamejoin.roblox.com/v1/join-game-instance",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["User-Agent"]   = "Roblox/WinInet",
                },
                Body = HttpService:JSONEncode({
                    placeId = placeId,
                    gameId  = jobId,
                }),
            })
        end)
        if ok then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
            end)
            return
        end
        warn("[" .. TITLE .. "] Join method 3 failed:", err)
    end

    StatusText.Text = "Join failed"
    warn("[" .. TITLE .. "] All join methods failed for jobId:", jobId)
end

stopForce = function()
    forceRun    += 1
    forceKey     = nil
    forceJobId   = nil
end

startForce = function(key, jobId)
    forceRun    += 1
    local myRun  = forceRun
    forceKey     = key
    forceJobId   = jobId
    task.spawn(function()
        while forceRun == myRun and autoForceState and ScreenGui.Parent do
            if jobId == game.JobId then
                stopForce()
                render()
                break
            end
            joinServer(jobId)
            task.wait(FORCE_INTERVAL)
        end
    end)
end

local soundBaselineReady = false
local function fetchPets()
    local body = httpGet(API_URL)
    if not body then return false end
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    if not ok or type(decoded) ~= "table" then return false end

    local list = {}
    for _, p in ipairs(decoded) do
        if p.petName and p.jobId and tonumber(p.value)
        and tonumber(p.value) >= POST_MIN_VALUE then
            local name   = tostring(p.petName)
            local rarity = getRarity(name)
                or (p.rarity and tostring(p.rarity))
                or DEFAULT_RARITY
            table.insert(list, {
                name       = name,
                value      = tonumber(p.value),
                jobId      = tostring(p.jobId),
                iconId     = p.iconId,
                key        = tostring(p.jobId) .. "|" .. name .. "|" .. tostring(p.timestamp),
                ts         = tonumber(p.timestamp) or (os.time() * 1000),
                rarity     = rarity,
                rarityColor = getRarityColor(name),
            })
        end
    end
    table.sort(list, function(a, b) return (a.ts or 0) > (b.ts or 0) end)
    if soundBaselineReady then
        local previous = {}
        for _, entry in ipairs(latest) do
            previous[entry.jobId .. "|" .. entry.name .. "|" .. math.floor(tonumber(entry.value) or 0)] = true
        end
        for _, entry in ipairs(list) do
            local value = tonumber(entry.value)
            local key = entry.jobId .. "|" .. entry.name .. "|" .. math.floor(value or 0)
            if value and value >= POST_MIN_VALUE and not previous[key] then
                playLogSound()
            end
        end
    else
        soundBaselineReady = true
    end
    latest = list
    return true
end

local function parseValue(text)
    local clean = tostring(text):gsub("<[^>]+>", "")
    local num, unit = clean:match(VALUE_PATTERN)
    if not num then return nil end
    local n = tonumber((num:gsub(",", "")))
    if not n then return nil end
    return n * (UNIT_MUL[unit:upper()] or 1)
end

local function resolveName(inst)
    local cur = inst.Parent
    for _ = 1, 8 do
        if not cur or cur == workspace then return nil end
        local key = displayByName[cur.Name] and cur.Name or nil
        if not key then
            for _, ch in ipairs(cur:GetChildren()) do
                if ch:IsA("TextLabel") then
                    local t = tostring(ch.Text):gsub("<[^>]+>", ""):match("^%s*(.-)%s*$")
                    if displayByName[t] then key = t break end
                end
            end
        end
        if key then return displayByName[key], iconByName[key] end
        cur = cur.Parent
    end
    return nil
end

local scanPets
scanPets = function()
    local found, seen, n = {}, {}, 0
    for _, d in ipairs(workspace:GetDescendants()) do
        n += 1
        if n % 3000 == 0 then task.wait() end
        if d:IsA("TextLabel") then
            local value = parseValue(d.Text)
            if value and value >= POST_MIN_VALUE then
                local name, icon = resolveName(d)
                if name then
                    local k = name .. "|" .. math.floor(value)
                    if not seen[k] then
                        seen[k] = true
                        table.insert(found, { name = name, value = value, icon = icon })
                    end
                end
            end
        end
    end
    return found
end

scanNowBtn.MouseButton1Click:Connect(function()
    scanNowBtn.Text = "SCANNING..."
    task.spawn(function()
        local ok, result = pcall(scanPets)
        scanNowBtn.Text = ok and ("SCAN COMPLETE: " .. tostring(#result)) or "SCAN FAILED"
        task.wait(2)
        if scanNowBtn.Parent then scanNowBtn.Text = "SCAN NOW" end
    end)
end)

refreshNowBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        local ok = fetchPets()
        if ok then
            StatusText.Text = "Connected"
            StatusDot.BackgroundColor3 = Color3.fromRGB(120, 220, 120)
            render()
            refreshNowBtn.Text = "FEED UPDATED"
        else
            refreshNowBtn.Text = "REFRESH FAILED"
        end
        task.wait(2)
        if refreshNowBtn.Parent then refreshNowBtn.Text = "REFRESH FEED" end
    end)
end)

local function alreadyListed(name, value)
    for _, e in ipairs(latest) do
        if e.jobId == game.JobId and e.name == name
        and math.abs(e.value - value) <= value * 0.05 then
            return true
        end
    end
    return false
end

local function httpPost(url, body)
    local fn = (syn and syn.request) or http_request or request
    if not fn then return nil, "no request fn" end
    local ok, res = pcall(fn, {
        Url     = url,
        Method  = "POST",
        Headers = { ["Content-Type"] = "application/json", ["x-ren-key"] = REN_KEY },
        Body    = body,
    })
    if ok and type(res) == "table" then
        return tonumber(res.StatusCode), res.Body
    end
    return nil, tostring(res)
end

task.spawn(function()
    while ScreenGui.Parent do
        if not AUTO_POST or game.JobId == "" then
            PostLabel.Text = "Post: off"
        elseif os.clock() >= postPauseUntil then
            local ok, found = pcall(scanPets)
            if ok then
                scanCount = #found
                for _, pet in ipairs(found) do
                    local key  = game.JobId .. "|" .. pet.name .. "|" .. math.floor(pet.value)
                    local last = postedAt[key]
                    if (not last or os.clock() - last > POST_COOLDOWN)
                    and not alreadyListed(pet.name, pet.value) then
                        postedAt[key] = os.clock()
                        local body = HttpService:JSONEncode({
                            petName   = pet.name,
                            value     = pet.value,
                            jobId     = game.JobId,
                            iconId    = pet.icon and tostring(pet.icon) or "",
                            timestamp = os.time() * 1000,
                        })
                        local status, resp = httpPost(API_URL, body)
                        if status and status >= 200 and status < 300 then
                            postOk += 1
                        else
                            postFail += 1
                            postedAt[key] = os.clock() - POST_COOLDOWN + 60
                            if status == 429 then postPauseUntil = os.clock() + 30 end
                        end
                        lastPostStatus = status and tostring(status) or tostring(resp):sub(1, 14)
                        if status == 429 then break end
                        task.wait(0.5)
                    end
                end
            else
                warn("[" .. TITLE .. "] Scan failed:", found)
            end
            PostLabel.Text = ("Scan:%d Post:%d/%d"):format(
                scanCount, postOk, postOk + postFail)
        end
        task.wait(POST_SCAN_INTERVAL)
    end
end)

task.spawn(function()
    while ScreenGui.Parent do
        for _, item in ipairs(ageLabels) do
            if item.label.Parent then
                item.label.Text = subText(item.entry)
            end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while ScreenGui.Parent do
        local ok = fetchPets()
        if ok then
            StatusText.Text               = "Connected"
            StatusDot.BackgroundColor3    = Color3.fromRGB(120, 220, 120)
            render()
        else
            StatusText.Text               = "Disconnected"
            StatusDot.BackgroundColor3    = Color3.fromRGB(220, 80, 80)
        end
        task.wait(REFRESH_INTERVAL)
    end
end)

local startupSound = Instance.new("Sound")
startupSound.SoundId = "rbxassetid://118333018638673"
startupSound.Volume = 1
startupSound.Parent = game:GetService("SoundService")
startupSound:Play()
startupSound.Ended:Connect(function()
    startupSound:Destroy()
end)

task.delay(15, function()
    if startupSound and startupSound.Parent then
        startupSound:Destroy()
    end
end)

switchTab("Logs")

Main.BackgroundTransparency = 1
MainScale.Scale = 0
tween(Main,      { BackgroundTransparency = 0.55 }, 0.3)
tween(MainScale, { Scale = scaleFactor }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

print("[" .. XPLT.. "] Loaded.")