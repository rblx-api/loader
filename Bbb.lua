if not game:IsLoaded() then game.Loaded:Wait() end
print("[RENHUB] Iniciando script (Conectado a Bot-Hosting)...")

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local HttpService       = game:GetService("HttpService")
local TeleportService   = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then LocalPlayer = Players.PlayerAdded:Wait() end
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

local IMAGE_ID           = "rbxassetid://84064858467855"
local TITLE              = "RENHUB FINDER"

-- ⚠️ CONFIGURACIÓN DE TU API EN BOT-HOSTING ⚠️
local BASE_URL           = "https://36oscvxwyd.apps.bot-hosting.cloud"
local ROUTE_PREFIX       = "d53ed5f73ad46269fa62c1b695230d50b66c5f5d"
local API_SECRET_KEY     = "478523528b57b15f1df333e788b59cf65be2ee8904ea913365ccc4d3e700aaa1"

-- Endpoints (GET para leer, POST para enviar)
local API_GET_URL        = BASE_URL .. "/" .. ROUTE_PREFIX .. "/logs"
local API_POST_URL       = BASE_URL .. "/" .. ROUTE_PREFIX .. "/report" 

local REFRESH_INTERVAL   = 1
local SCAN_INTERVAL      = 8
local POST_MIN_VALUE     = 5000000000
local POST_MAX_VALUE     = 11000000000
local MAX_LOG_AGE_S      = 240
local SAVE_EGG_VALUE     = 5000000000
local DEFAULT_RARITY     = "Secret"

local STEAL_URL   = "https://raw.githubusercontent.com/tienkhanh1/Chilli-Hub-Script/refs/heads/main/StealAnEggg"
local DISCORD_URL = "https://discord.gg/KTzpStW3Qj"
local VALID_KEY   = "XPLT X RENHUB COLABORACION"
local VALID_PASS  = "FREE_3d116e8768bb1c390bc007c114143b67"
local AUTH_FILE   = "RENHUB_Auth.json"
local TOP_EGGS_FILE = "RENHUB_TopEggs.json"

local Config = {
    autoJoin        = false,
    autoForce       = false,
    enableAutoJoinBtn  = false,
    enableAutoForceBtn = false,
    autoSteal       = false,
    logSoundEnabled = true,
    logNotify       = true,
}

local FORCE_TARGET_VALUE = 5000000000
local FORCE_DURATION     = 5
local FORCE_INTERVAL     = 3

local blacklist, blacklistFile = {}, "RENHUB_Blacklist.json"
local function loadBlacklist()
    if isfile and readfile and isfile(blacklistFile) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(blacklistFile)) end)
        if ok and type(data) == "table" then
            for _, name in ipairs(data) do
                if type(name) == "string" and name ~= "" then blacklist[name] = true end
            end
        end
    end
end
local function saveBlacklist()
    if not writefile then return end
    local arr = {}
    for name in pairs(blacklist) do arr[#arr + 1] = name end
    table.sort(arr)
    pcall(function() writefile(blacklistFile, HttpService:JSONEncode(arr)) end)
end
local function isBlacklisted(e) return e and e.name and blacklist[e.name] == true end
loadBlacklist()

local savedTopEggs = {}
local function loadTopEggs()
    if isfile and readfile and isfile(TOP_EGGS_FILE) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(TOP_EGGS_FILE)) end)
        if ok and type(data) == "table" then savedTopEggs = data end
    end
end
local function saveTopEggs()
    if not writefile then return end
    pcall(function() writefile(TOP_EGGS_FILE, HttpService:JSONEncode(savedTopEggs)) end)
end
loadTopEggs()

local rarityByName, colorByName, displayByName, iconByName = {}, {}, {}, {}
local function findIcon(e)
    for _, k in ipairs({ "Icon", "IconId", "Image", "ImageId", "Thumbnail" }) do
        local v = e[k]
        if v ~= nil then
            local id = tostring(v):match("(%d%d%d%d%d+)")
            if id then return id end
        end
    end
end
do
    local ok, err = pcall(function()
        local dataFolder   = ReplicatedStorage:WaitForChild("Data", 5)
        if not dataFolder then error("Data folder missing") end
        local assetsModule = dataFolder:WaitForChild("Assets", 5)
        if not assetsModule then error("Assets module missing") end
        local Assets = require(assetsModule)
        if type(Assets) ~= "table" or type(Assets.Directory) ~= "table" then error("Assets.Directory missing") end
        for id, e in pairs(Assets.Directory) do
            if type(e) == "table" and type(e.Rarity) == "table" then
                local r    = e.Rarity.DisplayName or e.Rarity._id
                local icon = findIcon(e)
                rarityByName[id], colorByName[id] = r, e.Rarity.Color
                displayByName[id], iconByName[id] = e.DisplayName or tostring(id), icon
                if e.DisplayName then
                    rarityByName[e.DisplayName], colorByName[e.DisplayName]   = r, e.Rarity.Color
                    displayByName[e.DisplayName], iconByName[e.DisplayName]   = e.DisplayName, icon
                end
            end
        end
    end)
end

local function getRarity(name) return rarityByName[name] end
local function getRarityColor(name)
    local c = colorByName[name]
    if typeof(c) == "Color3" then return c end
end

local autoJoinState, autoForceState = false, false
local lastAutoJoinJob = nil
local render, joinServer
local activeRows, hidden = {}, {}
local rowDataMap = {}
local localLogCache = {} 

local VALUE_PATTERN = "^%s*%$?%s*([%d%.,]+)%s*([KkMmBbTt]?)%s*/%s*[sS]%s*$"
local UNIT_MUL      = { K = 1e3, M = 1e6, B = 1e9, T = 1e12 }

local function formatValue(v)
    local units = { {1e12,"T"}, {1e9,"B"}, {1e6,"M"}, {1e3,"K"} }
    for _, u in ipairs(units) do
        if v >= u[1] then return ("$%.1f%s/s"):format(v / u[1], u[2]) end
    end
    return ("$%d/s"):format(math.floor(v))
end
local function formatAge(tsMs)
    local now = os.time()
    local ts = math.floor(tsMs / 1000)
    if ts > now then ts = now end 
    local s = math.max(0, now - ts)
    return ("%d:%02d"):format(math.floor(s / 60), s % 60)
end
local function richColor(c)
    return ("rgb(%d,%d,%d)"):format(math.floor(c.R*255+.5), math.floor(c.G*255+.5), math.floor(c.B*255+.5))
end
local function escapeRich(s) return (tostring(s):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")) end

local function getHeaders()
    return {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer " .. API_SECRET_KEY,
        ["x-api-key"] = API_SECRET_KEY
    }
end

local function httpGet(url)
    local okR, res = pcall(function()
        local fn = (syn and syn.request) or http_request or request
        if fn then return fn({ Url = url, Method = "GET", Headers = getHeaders() }) end
    end)
    if okR and res and res.Body then return res.Body end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and body then return body end
    local ok2, body2 = pcall(function() return HttpService:GetAsync(url) end)
    if ok2 then return body2 end
end

local function httpPost(url, body)
    local fn = (syn and syn.request) or http_request or request
    if not fn then return nil end
    local ok, res = pcall(fn, { Url = url, Method = "POST", Headers = getHeaders(), Body = body })
    if ok and type(res) == "table" then return tonumber(res.StatusCode) end
    return nil
end

local function copyToClipboard(text)
    if setclipboard then pcall(setclipboard, text) return true end
    if toclipboard then pcall(toclipboard, text) return true end
    if typeof(syn) == "table" and syn and syn.write_clipboard then pcall(function() syn.write_clipboard(text) end); return true end
    return false
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

local FONT_BLACK = Enum.Font.GothamBlack
local FONT_BOLD  = Enum.Font.GothamBold
local FONT_MED   = Enum.Font.GothamMedium
local FONT_REG   = Enum.Font.Gotham

local gradients = {}
local function makeGradient(c1, c2)
    return ColorSequence.new({ ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(0.25, c2), ColorSequenceKeypoint.new(0.5, c1), ColorSequenceKeypoint.new(0.75, c2), ColorSequenceKeypoint.new(1, c1) })
end
local function addCorner(parent, radius)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius); c.Parent = parent; return c
end
local function addStroke(parent, thickness, bright)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 1; s.Color = WHITE; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = parent
    local g = Instance.new("UIGradient")
    g.Rotation = 45; g.Color = makeGradient(bright and WHITE or GRAY, DARK); g.Parent = s
    table.insert(gradients, g); return s, g
end
local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do if k ~= "Parent" then obj[k] = v end end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end
local function tween(obj, props, time, style, dir)
    if not obj or not obj.Parent then return end
    pcall(function() TweenService:Create(obj, TweenInfo.new(time or 0.35, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props):Play() end)
end

local rot = 0
RunService.Heartbeat:Connect(function(dt)
    rot = (rot + dt * 40) % 360
    for i = #gradients, 1, -1 do
        local g = gradients[i]
        if not g or not g.Parent then table.remove(gradients, i)
        elseif i <= 20 then g.Rotation = (g.Parent:IsA("UIStroke") and (45 + rot) or rot) % 360 end
    end
end)

local GuiParent = getGuiParent()
for _, name in ipairs({ "RENHUB_Finder_UI", "RENHUB_KeyPrompt" }) do
    local old = GuiParent:FindFirstChild(name)
    if old then old:Destroy() end
end

local function loadAuth()
    if isfile and readfile and isfile(AUTH_FILE) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(AUTH_FILE)) end)
        if ok and type(data) == "table" and data.key == VALID_KEY and data.pass == VALID_PASS then return true end
    end
    return false
end
local function saveAuth()
    if not writefile then return end
    pcall(function() writefile(AUTH_FILE, HttpService:JSONEncode({ key = VALID_KEY, pass = VALID_PASS })) end)
end

local AUTH_OK = loadAuth()
if not AUTH_OK then
    local KeyGui = create("ScreenGui", { Name = "RENHUB_KeyPrompt", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = GuiParent })
    create("Frame", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.45, BorderSizePixel = 0, ZIndex = 1, Parent = KeyGui })
    local KeyBox = create("Frame", { AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0.5,0,0.5,0), Size = isMobile and UDim2.new(0, 340, 0, 430) or UDim2.new(0, 420, 0, 440), BackgroundColor3 = BG, BorderSizePixel = 0, ZIndex = 2, Parent = KeyGui })
    addCorner(KeyBox, 14); addStroke(KeyBox, 1.5, true)

    create("TextLabel", { Size = UDim2.new(1,0,0,30), Position = UDim2.new(0,0,0,14), BackgroundTransparency = 1, Text = "RENHUB FINDER - KEY SYSTEM", TextColor3 = WHITE, TextSize = 16, Font = FONT_BLACK, ZIndex = 3, Parent = KeyBox })
    create("TextLabel", { Size = UDim2.new(1,-30,0,54), Position = UDim2.new(0,15,0,50), BackgroundTransparency = 1, Text = "UNETE al Discord para conseguir tu KEY y PASSWORD:\n" .. DISCORD_URL, TextColor3 = GRAY, TextSize = 11, Font = FONT_MED, TextWrapped = true, ZIndex = 3, Parent = KeyBox })
    local CopyDiscord = create("TextButton", { Size = UDim2.new(0,220,0,28), Position = UDim2.new(0.5,-110,0,112), BackgroundColor3 = CARD, Text = "COPIAR LINK DE DISCORD", TextColor3 = WHITE, TextSize = 10, Font = FONT_BOLD, AutoButtonColor = false, ZIndex = 3, Parent = KeyBox })
    addCorner(CopyDiscord, 8); addStroke(CopyDiscord, 1, true)

    create("TextLabel", { Size = UDim2.new(1,-30,0,14), Position = UDim2.new(0,15,0,152), BackgroundTransparency = 1, Text = "KEY:", TextColor3 = WHITE, TextSize = 11, Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3, Parent = KeyBox })
    local KeyInput = create("TextBox", { Size = UDim2.new(1,-30,0,32), Position = UDim2.new(0,15,0,170), BackgroundColor3 = SWITCH, Text = "", PlaceholderText = "XPLT X RENHUB COLABORACION", PlaceholderColor3 = MUTED, TextColor3 = WHITE, TextSize = 12, Font = FONT_BOLD, ClearTextOnFocus = false, ZIndex = 3, Parent = KeyBox })
    addCorner(KeyInput, 8)

    create("TextLabel", { Size = UDim2.new(1,-30,0,14), Position = UDim2.new(0,15,0,212), BackgroundTransparency = 1, Text = "PASSWORD:", TextColor3 = WHITE, TextSize = 11, Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3, Parent = KeyBox })
    local PassInput = create("TextBox", { Size = UDim2.new(1,-30,0,32), Position = UDim2.new(0,15,0,230), BackgroundColor3 = SWITCH, Text = "", PlaceholderText = "FREE_...", PlaceholderColor3 = MUTED, TextColor3 = WHITE, TextSize = 12, Font = FONT_BOLD, ClearTextOnFocus = false, ZIndex = 3, Parent = KeyBox })
    addCorner(PassInput, 8)

    local ErrLbl = create("TextLabel", { Size = UDim2.new(1,-30,0,26), Position = UDim2.new(0,15,0,270), BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(255,70,80), TextSize = 10, Font = FONT_BOLD, TextWrapped = true, ZIndex = 3, Parent = KeyBox })
    local VerifyBtn = create("TextButton", { Size = UDim2.new(1,-30,0,38), Position = UDim2.new(0,15,0,302), BackgroundColor3 = SWITCHON, Text = "VERIFICAR", TextColor3 = Color3.fromRGB(25,25,25), TextSize = 12, Font = FONT_BLACK, AutoButtonColor = false, ZIndex = 3, Parent = KeyBox })
    addCorner(VerifyBtn, 10)

    CopyDiscord.MouseButton1Click:Connect(function()
        if copyToClipboard(DISCORD_URL) then ErrLbl.TextColor3 = Color3.fromRGB(120,220,120); ErrLbl.Text = "Link copiado al portapapeles"
        else ErrLbl.TextColor3 = Color3.fromRGB(255,200,80); ErrLbl.Text = "Copia manualmente el link" end
    end)
    VerifyBtn.MouseButton1Click:Connect(function()
        local key  = tostring(KeyInput.Text):gsub("^%s+",""):gsub("%s+$","")
        local pass = tostring(PassInput.Text):gsub("^%s+",""):gsub("%s+$","")
        if key == "" or pass == "" then ErrLbl.TextColor3 = Color3.fromRGB(255,70,80); ErrLbl.Text = "Debes ingresar KEY y PASSWORD"; return end
        if key == VALID_KEY and pass == VALID_PASS then AUTH_OK = true; saveAuth(); pcall(function() KeyGui:Destroy() end)
        else ErrLbl.TextColor3 = Color3.fromRGB(255,70,80); ErrLbl.Text = "KEY o PASSWORD incorrecta - unete al Discord" end
    end)
    PassInput.FocusLost:Connect(function(enter) if enter then VerifyBtn:CaptureFocus() end end)
    repeat task.wait() until AUTH_OK or not KeyGui.Parent
    if not AUTH_OK then return end
end

local scaleFactor = isMobile and 0.85 or 1
local ScreenGui = create("ScreenGui", { Name = "RENHUB_Finder_UI", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = GuiParent })
local Main = create("Frame", { Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = isMobile and UDim2.new(0, 420, 0, 280) or UDim2.new(0, 520, 0, 340), BackgroundColor3 = BG, BackgroundTransparency = 0.55, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 1, Parent = ScreenGui })
addCorner(Main, 12)
local MainScale = create("UIScale", { Scale = scaleFactor, Parent = Main })
addStroke(Main, 1.5, true)
create("ImageLabel", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Image = IMAGE_ID, ImageColor3 = WHITE, ImageTransparency = 0.08, ScaleType = Enum.ScaleType.Crop, ZIndex = 0, Parent = Main })

local sideW = isMobile and 100 or 130
local Sidebar = create("Frame", { Size = UDim2.new(0, sideW, 1, 0), BackgroundColor3 = BG, BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2, Parent = Main })
addCorner(Sidebar, 12)
create("Frame", { Size = UDim2.new(0,1,0.9,0), AnchorPoint = Vector2.new(0,0.5), Position = UDim2.new(1,0,0.5,0), BackgroundColor3 = WHITE, BackgroundTransparency = 0.7, BorderSizePixel = 0, ZIndex = 3, Parent = Sidebar })
local Content = create("Frame", { Size = UDim2.new(1, -(sideW + 4), 1, 0), Position = UDim2.new(0, sideW + 4, 0, 0), BackgroundTransparency = 1, ZIndex = 2, Parent = Main })
local SideHeader = create("Frame", { Size = UDim2.new(1,0,0,76), BackgroundTransparency = 1, ZIndex = 3, Parent = Sidebar })
local TitleLbl = create("TextLabel", { Size = UDim2.new(1,-20,0,22), Position = UDim2.new(0,14,0,10), BackgroundTransparency = 1, Text = TITLE, TextColor3 = WHITE, TextSize = 14, Font = FONT_BLACK, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = SideHeader })
local titleGrad = Instance.new("UIGradient")
titleGrad.Color = makeGradient(WHITE, GRAY); titleGrad.Parent = TitleLbl
table.insert(gradients, titleGrad)
local StatusDot = create("Frame", { Size = UDim2.new(0,6,0,6), Position = UDim2.new(0,16,0,44), BackgroundColor3 = DARK, BorderSizePixel = 0, ZIndex = 4, Parent = SideHeader })
addCorner(StatusDot, 1)
local StatusText = create("TextLabel", { Size = UDim2.new(1,-30,0,16), Position = UDim2.new(0,28,0,39), BackgroundTransparency = 1, Text = "Connecting...", TextColor3 = DARK, TextSize = 11, Font = FONT_REG, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = SideHeader })

local TabList = create("Frame", { Size = UDim2.new(1,0,1,-136), Position = UDim2.new(0,0,0,80), BackgroundTransparency = 1, ZIndex = 3, Parent = Sidebar })
create("UIListLayout", { Padding = UDim.new(0,4), HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabList })
local TabIndicator = create("Frame", { Size = UDim2.new(1,-16,0,36), Position = UDim2.new(0,8,0,80), BackgroundColor3 = WHITE, BackgroundTransparency = 0.8, BorderSizePixel = 0, ZIndex = 2, Parent = Sidebar })
addCorner(TabIndicator, 8); addStroke(TabIndicator, 1, true)

local Tabs, Pages, currentTab = {}, {}, nil
local tabOrder = { "Logs", "History", "Blacklist", "Settings" }
local function switchTab(name)
    if name == currentTab then return end
    currentTab = name
    for tabName, btn in pairs(Tabs) do
        local active = (tabName == name)
        tween(btn, { TextColor3 = active and WHITE or GRAY })
        btn.Font = active and FONT_BOLD or FONT_MED
        if Pages[tabName] then
            Pages[tabName].Visible = active
            if active then Pages[tabName].GroupTransparency = 1; tween(Pages[tabName], { GroupTransparency = 0 }, 0.3) end
        end
    end
    local idx = 0
    for i, t in ipairs(tabOrder) do if t == name then idx = i - 1 break end end
    tween(TabIndicator, { Position = UDim2.new(0,8,0,80 + idx * 40), Size = UDim2.new(1,-16,0,36) }, 0.35)
end
for i, name in ipairs(tabOrder) do
    local btn = create("TextButton", { Size = UDim2.new(1,-20,0,36), BackgroundTransparency = 1, Text = name, TextColor3 = GRAY, TextSize = 12, Font = FONT_BOLD, AutoButtonColor = false, LayoutOrder = i, ZIndex = 4, Parent = TabList })
    btn.MouseEnter:Connect(function() if name ~= currentTab then tween(btn, {TextColor3=WHITE}) end end)
    btn.MouseLeave:Connect(function() if name ~= currentTab then tween(btn, {TextColor3=GRAY}) end end)
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    Tabs[name] = btn
end

local HideBtn = create("TextButton", { Size = UDim2.new(1,-24,0,34), Position = UDim2.new(0,12,1,-42), BackgroundColor3 = CARD, BackgroundTransparency = 0.4, Text = "Hide", TextColor3 = GRAY, TextSize = 12, Font = FONT_BOLD, AutoButtonColor = false, ZIndex = 4, Parent = Sidebar })
addCorner(HideBtn, 10); addStroke(HideBtn, 1, false)

local Mini = create("Frame", { Size = UDim2.new(0,56,0,56), AnchorPoint = Vector2.new(0,0.5), Position = UDim2.new(0,18,0.58,0), BackgroundColor3 = BG, BackgroundTransparency = 0.1, Visible = false, ClipsDescendants = true, ZIndex = 100, Parent = ScreenGui })
addCorner(Mini, 28); addStroke(Mini, 2, true)
local MiniImage = create("ImageLabel", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Image = IMAGE_ID, ImageColor3 = WHITE, ScaleType = Enum.ScaleType.Crop, ZIndex = 100, Parent = Mini })
addCorner(MiniImage, 28)
local MiniBtn = create("TextButton", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 101, Parent = Mini })

HideBtn.MouseButton1Click:Connect(function()
    tween(MainScale, { Scale = 0 }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.4, function() Main.Visible = false; Mini.Visible = true; Mini.Size = UDim2.new(0,0,0,0); tween(Mini, { Size = UDim2.new(0,56,0,56) }, 0.4, Enum.EasingStyle.Back) end)
end)
local dragging, dragStart, startPos, moved
MiniBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging, moved = true, false; dragStart, startPos = input.Position, Mini.Position end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStart
    if delta.Magnitude > 10 then moved = true; Mini.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end
end)
MiniBtn.MouseButton1Click:Connect(function()
    if moved then return end
    tween(Mini, { Size = UDim2.new(0,0,0,0) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.3, function() Mini.Visible = false; Main.Visible = true; tween(MainScale, { Scale = scaleFactor }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out) end)
end)

local dragBar = create("TextButton", { Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1, Text = "", ZIndex = 10, Parent = Main })
local mainDragging, mainStart, mainPos
dragBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then mainDragging, mainStart, mainPos = true, input.Position, Main.Position end end)
dragBar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then mainDragging = false end end)
UserInputService.InputChanged:Connect(function(input)
    if not mainDragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = (input.Position - mainStart) / MainScale.Scale
    Main.Position = UDim2.new(mainPos.X.Scale, mainPos.X.Offset + delta.X, mainPos.Y.Scale, mainPos.Y.Offset + delta.Y)
end)

local function createSwitch(parent, y, labelText, configKey, onToggle)
    local frame = create("Frame", { Size = UDim2.new(1,0,0,48), Position = UDim2.new(0,0,0,y), BackgroundColor3 = CARD2, BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 3, Parent = parent })
    addCorner(frame, 10); addStroke(frame, 1, true)
    local lbl = create("TextLabel", { Size = UDim2.new(1,-70,1,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = labelText, TextColor3 = WHITE, TextSize = 12, Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = frame })
    local bg = create("TextButton", { AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-12,0.5,0), Size = UDim2.new(0,46,0,24), BackgroundColor3 = SWITCH, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 4, Parent = frame })
    addCorner(bg, 12)
    local _, grad = addStroke(bg, 1, false)
    local knob = create("Frame", { Size = UDim2.new(0,18,0,18), Position = UDim2.new(0,3,0.5,-9), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 5, Parent = bg })
    addCorner(knob, 9)
    
    local function updateUI()
        local on = Config[configKey]
        tween(bg, { BackgroundColor3 = on and SWITCHON or SWITCH }, 0.25)
        tween(knob, { Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9) }, 0.28, Enum.EasingStyle.Quint)
        if grad then grad.Color = makeGradient(on and WHITE or GRAY, DARK) end
    end
    
    updateUI()
    
    local switchObj = {}
    switchObj.Frame = frame
    switchObj.SetState = function(val)
        if Config[configKey] ~= val then
            Config[configKey] = val
            updateUI()
            if onToggle then onToggle(val) end
        end
    end
    
    bg.MouseButton1Click:Connect(function() switchObj.SetState(not Config[configKey]) end)
    return switchObj
end

local LogsPage = create("CanvasGroup", { Size = UDim2.new(1,-32,1,-32), Position = UDim2.new(0,16,0,16), BackgroundTransparency = 1, ZIndex = 2, Parent = Content })
Pages.Logs = LogsPage
local togglesRow = create("Frame", { Size = UDim2.new(1,0,0,44), BackgroundTransparency = 1, ZIndex = 3, Parent = LogsPage })
local ajSwitch
ajSwitch = createSwitch(togglesRow, 0, "Auto-Join", "autoJoin", function(v) 
    autoJoinState = v; if render then render() end 
end)
ajSwitch.Frame.Size = UDim2.new(0.48,0,0,44)

local afSwitch
afSwitch = createSwitch(togglesRow, 0, "Auto-Force", "autoForce", function(v) 
    autoForceState = v; if render then render() end 
end)
afSwitch.Frame.Size = UDim2.new(0.48,0,0,44); afSwitch.Frame.Position = UDim2.new(0.52,0,0,0)

local feedHeader = create("Frame", { Size = UDim2.new(1,0,0,20), Position = UDim2.new(0,0,0,52), BackgroundTransparency = 1, ZIndex = 3, Parent = LogsPage })
local feedTitleLbl = create("TextLabel", { Size = UDim2.new(0,80,1,0), BackgroundTransparency = 1, Text = "LIVE FEED", TextColor3 = WHITE, TextSize = 11, Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = feedHeader })
local ftGrad = Instance.new("UIGradient")
ftGrad.Color = makeGradient(WHITE, GRAY); ftGrad.Parent = feedTitleLbl
table.insert(gradients, ftGrad)
local detectedLabel = create("TextLabel", { AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-56,0,0), Size = UDim2.new(0,80,1,0), BackgroundTransparency = 1, Text = "0 detected", TextColor3 = DARK, TextSize = 11, Font = FONT_REG, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 4, Parent = feedHeader })
local clearBtn = create("TextButton", { AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,0,0.5,0), Size = UDim2.new(0,48,0,20), BackgroundColor3 = SWITCH, BackgroundTransparency = 0.3, Text = "Clear", TextColor3 = WHITE, TextSize = 10, Font = FONT_BOLD, AutoButtonColor = false, ZIndex = 4, Parent = feedHeader })
addCorner(clearBtn, 6)
local feedBg = create("Frame", { Size = UDim2.new(1,0,1,-76), Position = UDim2.new(0,0,0,76), BackgroundColor3 = BG, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 2, Parent = LogsPage })
addCorner(feedBg, 12); addStroke(feedBg, 1, false)
local feedScroll = create("ScrollingFrame", { Size = UDim2.new(1,-8,1,-8), Position = UDim2.new(0,4,0,4), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 4, ScrollBarImageColor3 = WHITE, ZIndex = 3, Parent = feedBg })
create("UIListLayout", { Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = feedScroll })
create("UIPadding", { PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4), PaddingLeft = UDim.new(0,4), PaddingRight = UDim.new(0,8), Parent = feedScroll })

local HistoryPage = create("CanvasGroup", { Size = UDim2.new(1,-32,1,-32), Position = UDim2.new(0,16,0,16), BackgroundTransparency = 1, Visible = false, ZIndex = 2, Parent = Content })
Pages.History = HistoryPage
create("TextLabel", { Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, Text = "HISTORY (top eggs guardados)", TextColor3 = WHITE, TextSize = 11, Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = HistoryPage })
local histBg = create("Frame", { Size = UDim2.new(1,0,1,-28), Position = UDim2.new(0,0,0,28), BackgroundColor3 = BG, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 2, Parent = HistoryPage })
addCorner(histBg, 12); addStroke(histBg, 1, false)
local histScroll = create("ScrollingFrame", { Size = UDim2.new(1,-8,1,-8), Position = UDim2.new(0,4,0,4), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 4, ScrollBarImageColor3 = WHITE, ZIndex = 3, Parent = histBg })
create("UIListLayout", { Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = histScroll })
create("UIPadding", { PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4), PaddingLeft = UDim.new(0,4), PaddingRight = UDim.new(0,4), Parent = histScroll })

local BlacklistPage = create("CanvasGroup", { Size = UDim2.new(1,-32,1,-32), Position = UDim2.new(0,16,0,16), BackgroundTransparency = 1, Visible = false, ZIndex = 2, Parent = Content })
Pages.Blacklist = BlacklistPage
create("TextLabel", { Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, Text = "BLACKLIST", TextColor3 = WHITE, TextSize = 11, Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = BlacklistPage })
local blacklistBg = create("Frame", { Size = UDim2.new(1,0,1,-28), Position = UDim2.new(0,0,0,28), BackgroundColor3 = BG, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 2, Parent = BlacklistPage })
addCorner(blacklistBg, 12); addStroke(blacklistBg, 1, false)
local blacklistScroll = create("ScrollingFrame", { Size = UDim2.new(1,-8,1,-8), Position = UDim2.new(0,4,0,4), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 4, ScrollBarImageColor3 = WHITE, ZIndex = 3, Parent = blacklistBg })
create("UIListLayout", { Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = blacklistScroll })
create("UIPadding", { PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4), PaddingLeft = UDim.new(0,4), PaddingRight = UDim.new(0,4), Parent = blacklistScroll })

local SettingsPage = create("CanvasGroup", { Size = UDim2.new(1,-32,1,-32), Position = UDim2.new(0,16,0,16), BackgroundTransparency = 1, Visible = false, ZIndex = 2, Parent = Content })
Pages.Settings = SettingsPage
create("TextLabel", { Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, Text = "SETTINGS", TextColor3 = WHITE, TextSize = 11, Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = SettingsPage })
local SettingsScroll = create("ScrollingFrame", { Size = UDim2.new(1,0,1,-24), Position = UDim2.new(0,0,0,24), BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0,0,0,530), ScrollBarThickness = 4, ScrollBarImageColor3 = WHITE, ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 3, Parent = SettingsPage })

local function makeSettingRow(y, labelText, defaultText, onApply)
    local frame = create("Frame", { Size = UDim2.new(1,-8,0,44), Position = UDim2.new(0,0,0,y), BackgroundColor3 = CARD2, BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 3, Parent = SettingsScroll })
    addCorner(frame, 10); addStroke(frame, 1, true)
    create("TextLabel", { Size = UDim2.new(0.5,0,1,0), Position = UDim2.new(0,14,0,0), BackgroundTransparency = 1, Text = labelText, TextColor3 = WHITE, TextSize = 11, Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = frame })
    local box = create("TextBox", { AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-14,0.5,0), Size = UDim2.new(0,80,0,28), BackgroundColor3 = SWITCH, Text = defaultText, TextColor3 = WHITE, TextSize = 12, Font = FONT_BOLD, ClearTextOnFocus = false, ZIndex = 4, Parent = frame })
    addCorner(box, 8)
    if onApply then
        box.FocusLost:Connect(function()
            local raw = tostring(box.Text):gsub("%s+", "")
            local num, unit = raw:match("^(%d+%.?%d*)([KkMmBbTt]?)$")
            local mult = ({K=1e3,M=1e6,B=1e9,T=1e12})[(unit or ""):upper()] or 1
            local v = num and tonumber(num) and tonumber(num) * mult
            if v and v > 0 then onApply(v) else box.Text = defaultText end
        end)
    end
    return box
end

makeSettingRow(0, "Min Threshold", "5B", function(v) POST_MIN_VALUE = v; render() end)
createSwitch(SettingsScroll, 52, "Permitir Auto-Join", "enableAutoJoinBtn", function(v) 
    if not v then ajSwitch.SetState(false) end 
end)
createSwitch(SettingsScroll, 108, "Permitir Auto-Force", "enableAutoForceBtn", function(v) 
    if not v then afSwitch.SetState(false) end 
end)
makeSettingRow(164, "Force Valor Minimo", "5B", function(v) FORCE_TARGET_VALUE = v end)
makeSettingRow(216, "Force Duracion (s)", "5", function(v) FORCE_DURATION = v end)
createSwitch(SettingsScroll, 268, "Log Sound", "logSoundEnabled")
createSwitch(SettingsScroll, 324, "Log Notifications", "logNotify")

local stealRun = 0
createSwitch(SettingsScroll, 380, "Auto-Steal (exec 3s)", "autoSteal", function(v)
    stealRun += 1; if not v then return end
    local myRun = stealRun
    task.spawn(function()
        task.wait(3); if stealRun ~= myRun or not Config.autoSteal then return end
        local ok, err = pcall(function() local code = game:HttpGet(STEAL_URL); if type(code) ~= "string" or #code == 0 then error("empty response") end; local fn = loadstring(code); if fn then fn() else error("loadstring fallo") end end)
        if not ok then warn("Steal script error:", err); if StatusText and StatusText.Parent then StatusText.Text = "Steal exec failed"; StatusText.TextColor3 = Color3.fromRGB(220,80,80) end
        else if StatusText and StatusText.Parent then StatusText.Text = "Steal script loaded"; StatusText.TextColor3 = Color3.fromRGB(120,220,120) end end
    end)
end)

local refreshNowBtn = create("TextButton", { Size = UDim2.new(1,-8,0,36), Position = UDim2.new(0,0,0,436), BackgroundColor3 = CARD, Text = "REFRESH FEED", TextColor3 = WHITE, TextSize = 11, Font = FONT_BOLD, AutoButtonColor = true, ZIndex = 4, Parent = SettingsScroll })
addCorner(refreshNowBtn, 8)

local function keyOf(e) return e.jobId .. "|" .. e.name end
local function subText(entry)
    local parts = { formatAge(entry.ts) }
    local r = entry.rarity or DEFAULT_RARITY
    if entry.rarityColor then 
        r = "<font color=\"" .. richColor(entry.rarityColor) .. "\">" .. escapeRich(r) .. "</font>" 
    else
        r = escapeRich(r)
    end
    table.insert(parts, r); return table.concat(parts, " - ")
end

local function createRow(data, order)
    local row = create("CanvasGroup", { LayoutOrder = order, Size = UDim2.new(1,-4,0,60), BackgroundColor3 = CARD2, BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 3, Parent = feedScroll, GroupTransparency = 0 })
    addCorner(row, 10); addStroke(row, 1, false)
    create("Frame", { Position = UDim2.new(0,5,0,5), Size = UDim2.new(0,4,0,50), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 4, Parent = row })
    addCorner(row:GetChildren()[1], 2)
    create("ImageLabel", { Position = UDim2.new(0,16,0,11), Size = UDim2.new(0,38,0,38), BackgroundTransparency = 1, Image = data.iconId and ("rbxassetid://" .. data.iconId) or "", ScaleType = Enum.ScaleType.Fit, ZIndex = 4, Parent = row })
    
    local titleLbl = create("TextLabel", { Position = UDim2.new(0,60,0,6), Size = UDim2.new(1,-155,0,22), BackgroundTransparency = 1, TextColor3 = WHITE, TextSize = 13, Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, RichText = true, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4, Parent = row })
    titleLbl.Text = ("%s  <font color=\"rgb(255,70,80)\">[ %s ]</font>"):format(escapeRich(data.name), formatValue(data.value))
    
    local sub = create("TextLabel", { Position = UDim2.new(0,60,0,31), Size = UDim2.new(1,-155,0,14), BackgroundTransparency = 1, TextColor3 = GRAY, TextSize = 10, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, RichText = true, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4, Parent = row })
    sub.Text = subText(data)
    
    rowDataMap[row] = { data = data, subLabel = sub }

    local blBtn = create("TextButton", { AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-4,0.5,0), Size = UDim2.new(0,24,0,22), BackgroundColor3 = CARD, BackgroundTransparency = 0.2, Text = "X", TextColor3 = Color3.fromRGB(255,70,70), TextSize = 11, Font = FONT_BOLD, AutoButtonColor = false, ZIndex = 5, Parent = row })
    addCorner(blBtn, 5); addStroke(blBtn, 1, false)

    local frcBtn = create("TextButton", { AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-34,0.5,0), Size = UDim2.new(0,44,0,22), BackgroundColor3 = CARD, BackgroundTransparency = 0.5, Text = "FORCE", TextColor3 = DARK, TextSize = 9, Font = FONT_BOLD, AutoButtonColor = false, ZIndex = 5, Parent = row })
    addCorner(frcBtn, 5)

    local joinBtn = create("TextButton", { AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-84,0.5,0), Size = UDim2.new(0,44,0,22), BackgroundColor3 = CARD, BackgroundTransparency = 0.1, Text = "JOIN", TextColor3 = WHITE, TextSize = 9, Font = FONT_BOLD, AutoButtonColor = false, ZIndex = 5, Parent = row })
    addCorner(joinBtn, 5); addStroke(joinBtn, 1, true)

    joinBtn.MouseButton1Click:Connect(function() joinServer(data.jobId) end)
    frcBtn.MouseButton1Click:Connect(function()
        if not Config.enableAutoForceBtn then return end
        local start = os.clock()
        task.spawn(function()
            while os.clock() - start < FORCE_DURATION do
                if data.jobId == game.JobId then break end
                joinServer(data.jobId)
                task.wait(FORCE_INTERVAL)
            end
        end)
    end)
    blBtn.MouseButton1Click:Connect(function() 
        hidden[keyOf(data)] = true
        render()
    end)
    
    return row
end

local function clearContainerRows(container) for _, child in ipairs(container:GetChildren()) do if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end end end

local function renderHistory()
    clearContainerRows(histScroll)
    if #savedTopEggs == 0 then create("TextLabel", { Size = UDim2.new(1,-8,0,34), BackgroundTransparency = 1, Text = "No hay Top Eggs guardados", TextColor3 = MUTED, TextSize = 11, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = histScroll }); return end
    
    local sorted = {}
    for _, entry in ipairs(savedTopEggs) do table.insert(sorted, entry) end
    table.sort(sorted, function(a, b) return a.value > b.value end)
    
    for index, entry in ipairs(sorted) do
        local row = create("Frame", { Size = UDim2.new(1,-4,0,44), BackgroundColor3 = CARD2, BackgroundTransparency = 0.1, BorderSizePixel = 0, LayoutOrder = index, ZIndex = 3, Parent = histScroll })
        addCorner(row, 8); addStroke(row, 1, false)
        create("TextLabel", { Position = UDim2.new(0,10,0,2), Size = UDim2.new(1,-160,0,22), BackgroundTransparency = 1, Text = entry.name .. "  [" .. formatValue(entry.value) .. "]", TextColor3 = WHITE, TextSize = 12, Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4, Parent = row })
        create("TextLabel", { Position = UDim2.new(0,10,0,23), Size = UDim2.new(1,-160,0,16), BackgroundTransparency = 1, Text = subText(entry), TextColor3 = GRAY, TextSize = 9, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4, Parent = row })
        
        local bl = create("TextButton", { AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.new(0,66,0,26), BackgroundColor3 = CARD, Text = "BORRAR", TextColor3 = WHITE, TextSize = 8, Font = FONT_BOLD, AutoButtonColor = true, ZIndex = 5, Parent = row })
        addCorner(bl, 6)
        bl.MouseButton1Click:Connect(function() 
            for i, v in ipairs(savedTopEggs) do
                if v.jobId == entry.jobId and v.name == entry.name then
                    table.remove(savedTopEggs, i)
                    break
                end
            end
            saveTopEggs()
            renderHistory() 
        end)
    end
end

local function renderBlacklist()
    clearContainerRows(blacklistScroll)
    local names = {}
    for name in pairs(blacklist) do table.insert(names, name) end
    table.sort(names)
    if #names == 0 then create("TextLabel", { Size = UDim2.new(1,-8,0,34), BackgroundTransparency = 1, Text = "Blacklist is empty", TextColor3 = MUTED, TextSize = 11, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = blacklistScroll }); return end
    for index, name in ipairs(names) do
        local currentName = name
        local row = create("Frame", { Size = UDim2.new(1,-4,0,40), BackgroundColor3 = CARD2, BackgroundTransparency = 0.1, BorderSizePixel = 0, LayoutOrder = index, ZIndex = 3, Parent = blacklistScroll })
        addCorner(row, 8); addStroke(row, 1, false)
        create("TextLabel", { Position = UDim2.new(0,10,0,0), Size = UDim2.new(1,-92,1,0), BackgroundTransparency = 1, Text = currentName, TextColor3 = WHITE, TextSize = 11, Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4, Parent = row })
        local remove = create("TextButton", { AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-6,0.5,0), Size = UDim2.new(0,74,0,26), BackgroundColor3 = CARD, Text = "REMOVE", TextColor3 = WHITE, TextSize = 9, Font = FONT_BOLD, AutoButtonColor = true, ZIndex = 5, Parent = row })
        addCorner(remove, 6)
        remove.MouseButton1Click:Connect(function()
            blacklist[currentName] = nil
            saveBlacklist()
            render()
        end)
    end
end

function render()
    local scroll = feedScroll.CanvasPosition
    local currentTime = os.time()
    local existingKeys = {}
    local currentList = {}

    for k, e in pairs(localLogCache) do
        local ageSeconds = currentTime - math.floor(e.ts / 1000)
        if ageSeconds >= MAX_LOG_AGE_S then
            localLogCache[k] = nil
        end
    end

    for k, e in pairs(localLogCache) do
        local val = tonumber(e.value)
        if val and val >= POST_MIN_VALUE and val <= POST_MAX_VALUE and not hidden[k] and not isBlacklisted(e) then
            table.insert(currentList, e)
            existingKeys[k] = true
        end
    end

    table.sort(currentList, function(a, b) return (a.ts or 0) > (b.ts or 0) end)

    for i, e in ipairs(currentList) do
        local k = keyOf(e)
        if not activeRows[k] then
            activeRows[k] = createRow(e, i)
        else
            activeRows[k].LayoutOrder = i
        end
    end

    for k, row in pairs(activeRows) do
        if not existingKeys[k] then
            activeRows[k] = nil
            task.spawn(function()
                for b = 1, 3 do
                    if not row or not row.Parent then break end
                    row.GroupTransparency = 0.8
                    task.wait(0.15)
                    if not row or not row.Parent then break end
                    row.GroupTransparency = 0
                    task.wait(0.15)
                end
                if row and row.Parent then
                    tween(row, { GroupTransparency = 1 }, 0.3)
                    task.wait(0.35)
                    if row and row.Parent then row:Destroy() end
                end
            end)
        end
    end

    detectedLabel.Text = #currentList .. " detected"
    feedScroll.CanvasPosition = scroll
    renderHistory(); renderBlacklist()
end

clearBtn.MouseButton1Click:Connect(function() for k in pairs(localLogCache) do hidden[k] = true end render() end)

joinServer = function(jobId)
    jobId = tostring(jobId or "")
    if jobId == "" or jobId == "nil" or jobId == tostring(game.JobId) then return end
    local placeId = game.PlaceId
    StatusText.Text = "Joining..."
    local ok = pcall(function() TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer) end)
    if not ok then
        local fn = (syn and syn.request) or http_request or request
        if fn then pcall(function() fn({ Url = "https://gamejoin.roblox.com/v1/join-game-instance", Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode({ placeId = placeId, gameId = jobId }) }) end) end
    end
end

TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if teleportResult == Enum.TeleportResult.GameFull or teleportResult == Enum.TeleportResult.GameNotFound then
        for k, e in pairs(localLogCache) do
            if e.jobId == lastAutoJoinJob then
                hidden[k] = true
            end
        end
        render()
    end
end)

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

local function scanPets()
    local found, seen, n = {}, {}, 0
    for _, d in ipairs(workspace:GetDescendants()) do
        n += 1
        if n % 3000 == 0 then task.wait() end
        if d:IsA("TextLabel") and not d:IsDescendantOf(LocalPlayer.PlayerGui) and not d:IsDescendantOf(game:GetService("CoreGui")) then
            local value = parseValue(d.Text)
            if value and value >= POST_MIN_VALUE and value <= POST_MAX_VALUE then
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

task.spawn(function()
    while true do
        task.wait(SCAN_INTERVAL)
        local found = scanPets()
        for _, pet in ipairs(found) do
            local body = HttpService:JSONEncode({
                petName = pet.name,
                value = pet.value,
                jobId = game.JobId,
                iconId = pet.icon or "",
                timestamp = os.time() * 1000
            })
            httpPost(API_POST_URL, body)
            task.wait(0.5)
        end
    end
end)

local function fetchPets()
    local currentTime = os.time()
    local bodyLovable = httpGet(API_GET_URL)
    if bodyLovable then
        local ok, decoded = pcall(function() return HttpService:JSONDecode(bodyLovable) end)
        if ok and type(decoded) == "table" then
            for _, item in ipairs(decoded) do
                if type(item) == "table" then
                    local pName = item.petName or item.name
                    local pValue = item.value or item.income
                    local tsMs = tonumber(item.timestamp) or (currentTime * 1000)
                    if tsMs < 10000000000 then tsMs = tsMs * 1000 end
                    local jobId = tostring(item.jobId or "")
                    
                    if jobId ~= tostring(game.JobId) then
                        local dedupeKey = jobId .. "|" .. tostring(pName)
                        local ageSeconds = currentTime - math.floor(tsMs / 1000)
                        
                        if ageSeconds < 0 then ageSeconds = 0; tsMs = currentTime * 1000 end
                        
                        if ageSeconds <= MAX_LOG_AGE_S then
                            if pName and tonumber(pValue) and tonumber(pValue) >= POST_MIN_VALUE and tonumber(pValue) <= POST_MAX_VALUE then
                                if not localLogCache[dedupeKey] then
                                    localLogCache[dedupeKey] = {
                                        name = tostring(pName), value = tonumber(pValue), jobId = jobId, 
                                        iconId = item.iconId and tostring(item.iconId) or nil,
                                        key = dedupeKey, 
                                        ts = tsMs,
                                        rarity = getRarity(tostring(pName)) or DEFAULT_RARITY, 
                                        rarityColor = getRarityColor(tostring(pName))
                                    }
                                else
                                    localLogCache[dedupeKey].ts = tsMs 
                                end
                                
                                local entry = localLogCache[dedupeKey]
                                if entry.value >= SAVE_EGG_VALUE then
                                    local alreadySaved = false
                                    for _, s in ipairs(savedTopEggs) do
                                        if s.jobId == jobId and s.name == entry.name then alreadySaved = true break end
                                    end
                                    if not alreadySaved then
                                        table.insert(savedTopEggs, entry)
                                        saveTopEggs()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return true
end

task.spawn(function()
    while true do
        task.wait(15)
        local ok, body = pcall(function() return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100") end)
        if ok and body then
            local ok2, decoded = pcall(function() return HttpService:JSONDecode(body) end)
            if ok2 and type(decoded) == "table" and decoded.data then
                local validServers = {}
                for _, srv in ipairs(decoded.data) do
                    if srv.playing < srv.maxPlayers then validServers[srv.id] = true end
                end
                local removedAny = false
                for k, e in pairs(localLogCache) do
                    if not validServers[e.jobId] and not hidden[k] then
                         hidden[k] = true
                         removedAny = true
                    end
                end
                if removedAny then render() end
            end
        end
    end
end)

refreshNowBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        if fetchPets() then StatusText.Text = "Connected"; StatusDot.BackgroundColor3 = Color3.fromRGB(120, 220, 120); render(); refreshNowBtn.Text = "UPDATED"
        else refreshNowBtn.Text = "FAILED" end
        task.wait(2); if refreshNowBtn.Parent then refreshNowBtn.Text = "REFRESH FEED" end
    end)
end)

RunService.Heartbeat:Connect(function()
    for _, row in pairs(activeRows) do
        local info = rowDataMap[row]
        if row.Parent and info and info.subLabel and info.data then
            local newTxt = subText(info.data)
            if info.subLabel.Text ~= newTxt then
                info.subLabel.Text = newTxt
            end
        end
    end
end)

local isAutoProcessing = false
task.spawn(function()
    while true do
        task.wait(2)
        if not isAutoProcessing then
            if autoJoinState and Config.enableAutoJoinBtn then
                for k, e in pairs(localLogCache) do
                    local jid = tostring(e.jobId)
                    local val = tonumber(e.value)
                    if val and val >= POST_MIN_VALUE and val <= POST_MAX_VALUE and not hidden[k] and not isBlacklisted(e) and jid ~= tostring(game.JobId) and jid ~= lastAutoJoinJob then
                        lastAutoJoinJob = jid
                        isAutoProcessing = true
                        joinServer(jid)
                        task.wait(5)
                        isAutoProcessing = false
                        break
                    end
                end
            end

            if autoForceState and Config.enableAutoForceBtn then
                for k, e in pairs(localLogCache) do
                    local jid = tostring(e.jobId)
                    local val = tonumber(e.value)
                    if val and val >= FORCE_TARGET_VALUE and not hidden[k] and not isBlacklisted(e) and jid ~= tostring(game.JobId) then
                        isAutoProcessing = true
                        local start = os.clock()
                        while os.clock() - start < FORCE_DURATION do
                            if jid == game.JobId then break end
                            joinServer(jid)
                            task.wait(FORCE_INTERVAL)
                        end
                        isAutoProcessing = false
                        break
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        if fetchPets() then
            if StatusText and StatusText.Parent then StatusText.Text = "Connected"; StatusDot.BackgroundColor3 = Color3.fromRGB(120, 220, 120) end
            render()
        else
            if StatusText and StatusText.Parent then StatusText.Text = "Disconnected"; StatusDot.BackgroundColor3 = Color3.fromRGB(220, 80, 80) end
        end
        task.wait(REFRESH_INTERVAL)
    end
end)

ajSwitch.SetState(false)
afSwitch.SetState(false)

switchTab("Logs")
Main.BackgroundTransparency = 1; MainScale.Scale = 0
tween(Main, { BackgroundTransparency = 0.55 }, 0.3); tween(MainScale, { Scale = scaleFactor }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
print("[RENHUB] Script cargado con exito. API de Producción activa.")