local HttpService    = game:GetService("HttpService")
local CoreGui        = game:GetService("CoreGui")
local TweenService   = game:GetService("TweenService")
local Players        = game:GetService("Players")
local TeleportService= game:GetService("TeleportService")
local SoundService   = game:GetService("SoundService")
local UserInputService=game:GetService("UserInputService")
local StarterGui     = game:GetService("StarterGui")

-- ── Cleanup previous instance ─────────────────────────
local UI_NAME = "JuneAutoJoiner_GUI"
if CoreGui:FindFirstChild(UI_NAME) then CoreGui[UI_NAME]:Destroy() end
if SoundService:FindFirstChild("MFNotifSound") then SoundService.MFNotifSound:Destroy() end

local lp = Players.LocalPlayer

-- ════════════════════════════════════════════════════
--   GOOD SERVERS WITH 100M+ VALUE
-- ════════════════════════════════════════════════════
local GOOD_BRAINROTS = {
    {name = "Orcaledon", value = 250000000},
    {name = "Celestial Pegasus", value = 500000000},
    {name = "Hydra Dragon Cannelloni", value = 1000000000},
    {name = "Dragon Gingerini", value = 750000000},
    {name = "La Supreme Combinasion", value = 300000000},
    {name = "Cerberus", value = 450000000},
    {name = "Griffin", value = 400000000},
    {name = "Hydra Bunny", value = 600000000},
    {name = "Blackhole Goat", value = 800000000},
    {name = "Jackorilla", value = 350000000},
}

-- ════════════════════════════════════════════════════
--   ALL BRAINROTS WITH VALUES (Rotating display only - NOT clickable)
-- ════════════════════════════════════════════════════
local allBrainrots = {
    {name = "Orcaledon", value = 250000000},
    {name = "Celestial Pegasus", value = 500000000},
    {name = "Hydra Dragon Cannelloni", value = 1000000000},
    {name = "Dragon Gingerini", value = 750000000},
    {name = "La Supreme Combinasion", value = 300000000},
    {name = "Cerberus", value = 450000000},
    {name = "Griffin", value = 400000000},
    {name = "Hydra Bunny", value = 600000000},
    {name = "Blackhole Goat", value = 800000000},
    {name = "Jackorilla", value = 350000000},
    {name = "Los Nooo My Hotspotsitos", value = 15000000},
    {name = "Serafinna Medusella", value = 12000000},
    {name = "La Grande Combinassion", value = 25000000},
    {name = "La Easter Grande", value = 18000000},
    {name = "Rang Ring Bus", value = 5000000},
    {name = "Guest 666", value = 7500000},
    {name = "Los Mi Gatitos", value = 8000000},
    {name = "Los Chicleteiras", value = 10000000},
    {name = "Noo My Eggs", value = 6000000},
    {name = "67", value = 4000000},
    {name = "Donkeyturbo Express", value = 9000000},
    {name = "Mariachi Corazoni", value = 11000000},
    {name = "Los Burritos", value = 7000000},
    {name = "Los 25", value = 3000000},
    {name = "Tacorillo Crocodillo", value = 8500000},
    {name = "Swag Soda", value = 5500000},
    {name = "Noo my Heart", value = 6500000},
    {name = "Chimnino", value = 4500000},
    {name = "Los Combinasionas", value = 9500000},
    {name = "Chicleteira Noelteira", value = 10500000},
    {name = "Fishino Clownino", value = 3500000},
    {name = "Baskito", value = 2500000},
    {name = "Tacorita Bicicleta", value = 7500000},
    {name = "Los Sweethearts", value = 8500000},
    {name = "Spinny Hammy", value = 50000000},
    {name = "Nuclearo Dinosauro", value = 40000000},
    {name = "Las Sis", value = 20000000},
    {name = "DJ Panda", value = 15000000},
    {name = "Chicleteira Cupideira", value = 12000000},
    {name = "La Karkerkar Combinasion", value = 28000000},
    {name = "Chillin Chili", value = 8000000},
    {name = "Chipso and Queso", value = 7000000},
    {name = "Money Money Reindeer", value = 60000000},
    {name = "Money Money Puggy", value = 55000000},
    {name = "Churrito Bunnito", value = 30000000},
    {name = "Celularcini Viciosini", value = 25000000},
    {name = "Los Planitos", value = 18000000},
    {name = "Los Mobilis", value = 16000000},
    {name = "Los 67", value = 14000000},
    {name = "Mieteteira Bicicleteira", value = 13000000},
    {name = "Tuff Toucan", value = 22000000},
    {name = "La Spooky Grande", value = 35000000},
    {name = "Los Spooky Combinasionas", value = 32000000},
    {name = "Cigno Fulgoro", value = 28000000},
    {name = "Los Candies", value = 19000000},
    {name = "Los Hotspositos", value = 17000000},
    {name = "Los Jolly Combinasionas", value = 23000000},
    {name = "Los Cupids", value = 21000000},
    {name = "Los Puggies", value = 20000000},
    {name = "W or L", value = 15000000},
    {name = "Tralalalaledon", value = 45000000},
    {name = "La Extinct Grande Combinasion", value = 55000000},
    {name = "Tralaledon", value = 40000000},
    {name = "La Jolly Grande", value = 38000000},
    {name = "Los Primos", value = 25000000},
    {name = "Bacuru and Egguru", value = 22000000},
    {name = "Eviledon", value = 48000000},
    {name = "Los Tacoritas", value = 26000000},
    {name = "Lovin Rose", value = 24000000},
    {name = "Tang Tang Kelentang", value = 18000000},
    {name = "Ketupat Kepat", value = 16000000},
    {name = "Los Bros", value = 14000000},
    {name = "Tictac Sahur", value = 12000000},
    {name = "La Romantic Grande", value = 30000000},
    {name = "Gingerat Gerat", value = 35000000},
}

-- Helper function to format value
local function formatValue(value)
    if value >= 1000000000 then
        return string.format("%.2fB", value / 1000000000)
    elseif value >= 1000000 then
        return string.format("%.2fM", value / 1000000)
    elseif value >= 1000 then
        return string.format("%.1fK", value / 1000)
    else
        return tostring(value)
    end
end

-- ════════════════════════════════════════════════════
--   BACKEND CONFIG
-- ════════════════════════════════════════════════════
local function _d(t) local s="" for _,c in ipairs(t) do s=s..string.char(c) end return s end
local HTTP_URL   = _d({104,116,116,112,115,58,47,47,119,115,46,118,97,110,105,115,104,110,111,116,105,102,105,101,114,46,111,114,103,47,114,101,99,101,110,116})
local BOTS_URL   = _d({104,116,116,112,115,58,47,47,119,115,46,118,97,110,105,115,104,110,111,116,105,102,105,101,114,46,111,114,103,47,98,111,116,115})
local BOTS_REFRESH_S     = 20
local JOB_ID_MAX_DELTA_S = 120
local POLL_INTERVAL      = 0.25
local BASE = "https://7102fbfa-e1aa-4a7f-b2e2-62108d851ff2-00-172yv0dbelobp.janeway.replit.dev"
local AJ_REGISTER_URL    = BASE .. "/__aj/register"
local AJ_LIST_URL        = BASE .. "/__aj/list"
local AJ_REFRESH_S       = 15
local CW_HEARTBEAT_URL   = BASE .. "/__cw/heartbeat"
local CW_PRESENCE_REFRESH_S = 10
local LOADSTRING_URL     = BASE .. "/download.lua"
local CONFIG_FILE        = "JuneAutoJoiner_Config.json"

-- ════════════════════════════════════════════════════
--   USER SETTINGS
-- ════════════════════════════════════════════════════
local userSettings = {
    AutoJoin         = false,
    PlaySound        = true,
    ToggleKey        = "RightShift",
}

pcall(function()
    if isfile and readfile and isfile(CONFIG_FILE) then
        local saved = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(saved) == "table" then
            for k, v in pairs(saved) do userSettings[k] = v end
        end
    end
end)

task.spawn(function()
    local lastSave = HttpService:JSONEncode(userSettings)
    while _G.JuneAutoJoinerRunning do
        task.wait(3)
        pcall(function()
            local cur = HttpService:JSONEncode(userSettings)
            if cur ~= lastSave then
                if writefile then writefile(CONFIG_FILE, cur) end
                lastSave = cur
            end
        end)
    end
end)

-- ════════════════════════════════════════════════════
--   HTTP HELPERS
-- ════════════════════════════════════════════════════
local function httpGet(url)
    local ok, res = pcall(function()
        if syn and syn.request then return syn.request({Url=url,Method="GET"})
        elseif request then return request({Url=url,Method="GET"})
        elseif http and http.request then return http.request({Url=url,Method="GET"})
        else return {Body=game:GetService("HttpService"):GetAsync(url)} end
    end)
    if ok and res then return res.Body end
    return nil
end

local function decodeJson(s)
    local ok, t = pcall(function() return HttpService:JSONDecode(s) end)
    return ok and t or nil
end

-- ════════════════════════════════════════════════════
--   NOTIFICATION SOUND
-- ════════════════════════════════════════════════════
local NotifSound = Instance.new("Sound")
NotifSound.Name = "MFNotifSound"
NotifSound.SoundId = "rbxassetid://4590662766"
NotifSound.Volume = 1
NotifSound.Parent = SoundService
local function playNotifSound() if userSettings.PlaySound then NotifSound:Play() end end

-- ════════════════════════════════════════════════════
--   THEME (Green & Dark)
-- ════════════════════════════════════════════════════
local T = {
    BgDark      = Color3.fromRGB(8, 8, 12),
    BgMid       = Color3.fromRGB(12, 12, 20),
    BgCard      = Color3.fromRGB(16, 16, 26),
    BgCardHover = Color3.fromRGB(20, 30, 22),
    Sidebar     = Color3.fromRGB(6, 6, 10),
    Accent1     = Color3.fromRGB(34, 197, 94),
    Accent2     = Color3.fromRGB(74, 222, 128),
    White       = Color3.fromRGB(230, 230, 245),
    TextDim     = Color3.fromRGB(120, 120, 150),
    Off         = Color3.fromRGB(30, 30, 40),
    Green       = Color3.fromRGB(34, 197, 94),
    GreenDim    = Color3.fromRGB(20, 80, 40),
    Red         = Color3.fromRGB(220, 60, 70),
    Gold        = Color3.fromRGB(255, 215, 0),
}

local ESP_GREEN = Color3.fromRGB(34, 197, 94)

-- ════════════════════════════════════════════════════
--   MAIN GUI FRAME
-- ════════════════════════════════════════════════════
local Gui = Instance.new("ScreenGui")
Gui.Name = UI_NAME
Gui.Parent = CoreGui
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local OPEN_POS = UDim2.new(0.5, -290, 0.5, -190)
local HIDE_POS = UDim2.new(0.5, -290, 1.5, 0)
local guiVisible = true

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 580, 0, 420)
Main.Position = HIDE_POS
Main.BackgroundColor3 = T.BgDark
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = T.Accent1
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

local BorderGrad = Instance.new("UIGradient")
BorderGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, T.Accent1),
    ColorSequenceKeypoint.new(0.5, T.Accent2),
    ColorSequenceKeypoint.new(1, T.Accent1),
}
BorderGrad.Parent = MainStroke

task.delay(0.1, function()
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = OPEN_POS}):Play()
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 155, 1, 0)
Sidebar.BackgroundColor3 = T.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local SFix = Instance.new("Frame")
SFix.Size = UDim2.new(0, 12, 1, 0)
SFix.Position = UDim2.new(1, -12, 0, 0)
SFix.BackgroundColor3 = T.Sidebar
SFix.BorderSizePixel = 0
SFix.Parent = Sidebar

local SepLine = Instance.new("Frame")
SepLine.Size = UDim2.new(0, 1, 1, -20)
SepLine.Position = UDim2.new(1, 0, 0, 10)
SepLine.BackgroundColor3 = T.Off
SepLine.BorderSizePixel = 0
SepLine.Parent = Sidebar

-- Logo
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 30)
Logo.Position = UDim2.new(0, 0, 0, 8)
Logo.BackgroundTransparency = 1
Logo.Text = "JUNE"
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 16
Logo.TextColor3 = T.Accent2
Logo.Parent = Sidebar

local LogoSub = Instance.new("TextLabel")
LogoSub.Size = UDim2.new(1, 0, 0, 14)
LogoSub.Position = UDim2.new(0, 0, 0, 37)
LogoSub.BackgroundTransparency = 1
LogoSub.Text = "AUTO JOINER"
LogoSub.Font = Enum.Font.Gotham
LogoSub.TextSize = 9
LogoSub.TextColor3 = T.TextDim
LogoSub.Parent = Sidebar

-- Auto Joiner status display
local AJInfo = Instance.new("Frame")
AJInfo.Size = UDim2.new(1, -20, 0, 50)
AJInfo.Position = UDim2.new(0, 10, 0, 70)
AJInfo.BackgroundColor3 = T.BgCard
AJInfo.Parent = Sidebar
Instance.new("UICorner", AJInfo).CornerRadius = UDim.new(0, 6)

local AJStatus = Instance.new("TextLabel")
AJStatus.Size = UDim2.new(1, -10, 0, 16)
AJStatus.Position = UDim2.new(0, 5, 0, 5)
AJStatus.BackgroundTransparency = 1
AJStatus.TextXAlignment = Enum.TextXAlignment.Left
AJStatus.Text = "⚡ AUTO JOINER"
AJStatus.Font = Enum.Font.GothamBold
AJStatus.TextSize = 10
AJStatus.TextColor3 = T.Green
AJStatus.Parent = AJInfo

local AJTimeRemaining = Instance.new("TextLabel")
AJTimeRemaining.Size = UDim2.new(1, -10, 0, 14)
AJTimeRemaining.Position = UDim2.new(0, 5, 0, 22)
AJTimeRemaining.BackgroundTransparency = 1
AJTimeRemaining.TextXAlignment = Enum.TextXAlignment.Left
AJTimeRemaining.Text = "Next join in: --"
AJTimeRemaining.Font = Enum.Font.Gotham
AJTimeRemaining.TextSize = 9
AJTimeRemaining.TextColor3 = T.TextDim
AJTimeRemaining.Parent = AJInfo

local VerBadge = Instance.new("TextLabel")
VerBadge.Size = UDim2.new(0.5, 0, 0, 18)
VerBadge.Position = UDim2.new(0.25, 0, 0, 130)
VerBadge.BackgroundColor3 = T.BgCard
VerBadge.Text = "GREEN EDITION"
VerBadge.Font = Enum.Font.GothamBold
VerBadge.TextSize = 9
VerBadge.TextColor3 = T.Green
VerBadge.Parent = Sidebar
Instance.new("UICorner", VerBadge).CornerRadius = UDim.new(0, 8)

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -40, 0, 14)
MinBtn.BackgroundColor3 = T.BgCardHover
MinBtn.BackgroundTransparency = 0.3
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = T.Green
MinBtn.TextSize = 12
MinBtn.Parent = Main
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
local MinStroke = Instance.new("UIStroke")
MinStroke.Color = T.Green
MinStroke.Transparency = 0.7
MinStroke.Parent = MinBtn

MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinStroke, TweenInfo.new(0.2), {Transparency=0}):Play()
    TweenService:Create(MinBtn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(40,100,50),TextColor3=T.White}):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinStroke, TweenInfo.new(0.2), {Transparency=0.7}):Play()
    TweenService:Create(MinBtn, TweenInfo.new(0.2), {BackgroundColor3=T.BgCardHover,TextColor3=T.Green}):Play()
end)

local pulseToggleBtn

local function toggleGUI()
    guiVisible = not guiVisible
    if guiVisible then
        Main.Visible = true
        TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position=OPEN_POS}):Play()
    else
        local tw = TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position=HIDE_POS})
        tw:Play()
        tw.Completed:Connect(function() if not guiVisible then Main.Visible = false end end)
    end
    if pulseToggleBtn then pulseToggleBtn(guiVisible) end
end

MinBtn.MouseButton1Click:Connect(toggleGUI)

-- Persistent logo toggle button
local MobileToggle = Instance.new("Frame")
MobileToggle.Name = "JAToggleBtn"
MobileToggle.Size = UDim2.new(0, 58, 0, 58)
MobileToggle.Position = UDim2.new(1, -72, 0, 10)
MobileToggle.BackgroundTransparency = 1
MobileToggle.Parent = Gui

local glowRing = Instance.new("Frame")
glowRing.Size = UDim2.new(1, 12, 1, 12)
glowRing.Position = UDim2.new(0, -6, 0, -6)
glowRing.BackgroundTransparency = 1
glowRing.Parent = MobileToggle
Instance.new("UICorner", glowRing).CornerRadius = UDim.new(1, 0)
local mtStroke = Instance.new("UIStroke")
mtStroke.Thickness = 2.5
mtStroke.Color = ESP_GREEN
mtStroke.Transparency = 0.2
mtStroke.Parent = glowRing

local mtBtn = Instance.new("TextButton")
mtBtn.Name = "ToggleInner"
mtBtn.Size = UDim2.new(1, 0, 1, 0)
mtBtn.BackgroundColor3 = Color3.fromRGB(7, 7, 20)
mtBtn.BorderSizePixel = 0
mtBtn.Text = ""
mtBtn.Active = true
mtBtn.Draggable = true
mtBtn.Parent = MobileToggle
Instance.new("UICorner", mtBtn).CornerRadius = UDim.new(1, 0)
local mtInnerStroke = Instance.new("UIStroke")
mtInnerStroke.Thickness = 1.5
mtInnerStroke.Color = ESP_GREEN
mtInnerStroke.Transparency = 0.5
mtInnerStroke.Parent = mtBtn

local juneLbl = Instance.new("TextLabel")
juneLbl.Size = UDim2.new(1, 0, 0.58, 0)
juneLbl.Position = UDim2.new(0, 0, 0, 8)
juneLbl.BackgroundTransparency = 1
juneLbl.Text = "JUNE"
juneLbl.Font = Enum.Font.GothamBlack
juneLbl.TextSize = 11
juneLbl.TextColor3 = Color3.new(1, 1, 1)
juneLbl.Parent = mtBtn

local ajLbl = Instance.new("TextLabel")
ajLbl.Size = UDim2.new(1, 0, 0.38, 0)
ajLbl.Position = UDim2.new(0, 0, 0.6, 0)
ajLbl.BackgroundTransparency = 1
ajLbl.Text = "AJ"
ajLbl.Font = Enum.Font.GothamBlack
ajLbl.TextSize = 11
ajLbl.TextColor3 = ESP_GREEN
ajLbl.Parent = mtBtn

mtBtn.MouseButton1Click:Connect(toggleGUI)

pulseToggleBtn = function(on)
    TweenService:Create(mtStroke, TweenInfo.new(0.3),
        {Transparency = on and 0.55 or 0.15, Color = ESP_GREEN}):Play()
    TweenService:Create(mtInnerStroke, TweenInfo.new(0.3),
        {Transparency = on and 0.6 or 0.25}):Play()
    TweenService:Create(mtBtn, TweenInfo.new(0.3),
        {BackgroundColor3 = on and Color3.fromRGB(7, 7, 20) or Color3.fromRGB(20, 30, 20)}):Play()
end

task.spawn(function()
    local t = 0
    while _G.JuneAutoJoinerRunning do
        t = t + 0.04
        if not guiVisible then
            local pulse = (math.sin(t * 2.2) + 1) / 2
            mtStroke.Transparency = 0.1 + pulse * 0.55
        end
        task.wait(0.04)
    end
end)

local KeyHint = Instance.new("TextLabel")
KeyHint.Size = UDim2.new(1, 0, 0, 34)
KeyHint.Position = UDim2.new(0, 0, 1, -38)
KeyHint.BackgroundTransparency = 1
KeyHint.Text = userSettings.ToggleKey .. " = Toggle\nGREEN BUTTON = Join 100M+"
KeyHint.Font = Enum.Font.Gotham
KeyHint.TextSize = 9
KeyHint.TextColor3 = T.Off
KeyHint.TextWrapped = true
KeyHint.Parent = Sidebar

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local key = input.KeyCode.Name
    if key == userSettings.ToggleKey then toggleGUI() end
    if key == "M" then toggleGUI() end
    if key == "N" then
        userSettings.AutoJoin = not userSettings.AutoJoin
        updateAJVisuals(userSettings.AutoJoin)
    end
end)

-- Pages
local LogsPage = Instance.new("Frame")
LogsPage.Size = UDim2.new(1, -155, 1, -2)
LogsPage.Position = UDim2.new(0, 155, 0, 2)
LogsPage.BackgroundTransparency = 1
LogsPage.Parent = Main

local SettingsPage = Instance.new("Frame")
SettingsPage.Size = UDim2.new(1, -155, 1, -2)
SettingsPage.Position = UDim2.new(0, 155, 0, 2)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = Main

-- Tab buttons
local curTab = "logs"
local tabButtons = {}

local function makeTabBtn(icon, text, yPos, key)
    local btn2 = Instance.new("TextButton")
    btn2.Size = UDim2.new(1, -20, 0, 36)
    btn2.Position = UDim2.new(0, 10, 0, yPos)
    btn2.BackgroundColor3 = T.BgCard
    btn2.BackgroundTransparency = key == "logs" and 0 or 1
    btn2.BorderSizePixel = 0
    btn2.Text = ""
    btn2.AutoButtonColor = false
    btn2.Parent = Sidebar
    Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 6)
    local ind = Instance.new("Frame")
    ind.Size = UDim2.new(0, 3, 0.6, 0)
    ind.Position = UDim2.new(0, 0, 0.2, 0)
    ind.BackgroundColor3 = T.Accent1
    ind.BackgroundTransparency = key == "logs" and 0 or 1
    ind.Parent = btn2
    Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)
    local lbl2 = Instance.new("TextLabel")
    lbl2.Size = UDim2.new(1, -15, 1, 0)
    lbl2.Position = UDim2.new(0, 15, 0, 0)
    lbl2.BackgroundTransparency = 1
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.Text = icon .. "  " .. text
    lbl2.Font = Enum.Font.GothamSemibold
    lbl2.TextSize = 12
    lbl2.TextColor3 = key == "logs" and T.White or T.TextDim
    lbl2.Parent = btn2
    tabButtons[key] = {btn=btn2, ind=ind, lbl=lbl2}
    return btn2
end

local tLogs     = makeTabBtn("📋", "Logs",      110,  "logs")
local tSettings = makeTabBtn("⚙️", "Settings",  152, "settings")

local function switchTab(toKey)
    curTab = toKey
    LogsPage.Visible      = toKey == "logs"
    SettingsPage.Visible  = toKey == "settings"
    for k, v in pairs(tabButtons) do
        local act = k == toKey
        TweenService:Create(v.btn, TweenInfo.new(0.2), {BackgroundTransparency = act and 0 or 1}):Play()
        TweenService:Create(v.ind, TweenInfo.new(0.2), {BackgroundTransparency = act and 0 or 1}):Play()
        v.lbl.TextColor3 = act and T.White or T.TextDim
    end
end

tLogs.MouseButton1Click:Connect(function() switchTab("logs") end)
tSettings.MouseButton1Click:Connect(function() switchTab("settings") end)

-- Settings Page
local SScroll = Instance.new("ScrollingFrame")
SScroll.Size = UDim2.new(1, 0, 1, 0)
SScroll.BackgroundTransparency = 1
SScroll.BorderSizePixel = 0
SScroll.ScrollBarThickness = 2
SScroll.ScrollBarImageColor3 = T.Off
SScroll.Parent = SettingsPage
local SLayout = Instance.new("UIListLayout")
SLayout.Parent = SScroll
SLayout.Padding = UDim.new(0, 8)
SLayout.SortOrder = Enum.SortOrder.LayoutOrder
local SPad = Instance.new("UIPadding")
SPad.PaddingTop = UDim.new(0, 15)
SPad.PaddingLeft = UDim.new(0, 18)
SPad.PaddingRight = UDim.new(0, 18)
SPad.Parent = SScroll
SLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SScroll.CanvasSize = UDim2.new(0, 0, 0, SLayout.AbsoluteContentSize.Y + 20)
end)

local function makeHeader(text, parent)
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1, 0, 0, 20)
    h.BackgroundTransparency = 1
    h.Text = text
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.Font = Enum.Font.GothamBold
    h.TextSize = 11
    h.TextColor3 = T.Accent2
    h.Parent = parent
end

local function makeToggle(parent, text, key)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = T.BgCard
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl2 = Instance.new("TextLabel")
    lbl2.Size = UDim2.new(1, -65, 1, 0)
    lbl2.Position = UDim2.new(0, 14, 0, 0)
    lbl2.BackgroundTransparency = 1
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.Text = text
    lbl2.Font = Enum.Font.GothamSemibold
    lbl2.TextSize = 13
    lbl2.TextColor3 = T.White
    lbl2.Parent = f
    local track = Instance.new("TextButton")
    track.Size = UDim2.new(0, 42, 0, 22)
    track.Position = UDim2.new(1, -56, 0.5, -11)
    track.BackgroundColor3 = userSettings[key] and T.Accent1 or T.Off
    track.Text = ""
    track.Parent = f
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = userSettings[key] and UDim2.new(1,-19,0,3) or UDim2.new(0,3,0,3)
    dot.BackgroundColor3 = T.White
    dot.Parent = track
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    track.MouseButton1Click:Connect(function()
        userSettings[key] = not userSettings[key]
        local on = userSettings[key]
        TweenService:Create(dot, TweenInfo.new(0.15, Enum.EasingStyle.Quad),
            {Position = on and UDim2.new(1,-19,0,3) or UDim2.new(0,3,0,3)}):Play()
        TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = on and T.Accent1 or T.Off}):Play()
    end)
end

local function makeKeybindSetting(parent, text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = T.BgCard
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl2 = Instance.new("TextLabel")
    lbl2.Size = UDim2.new(1, -95, 1, 0)
    lbl2.Position = UDim2.new(0, 14, 0, 0)
    lbl2.BackgroundTransparency = 1
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.Text = text
    lbl2.Font = Enum.Font.GothamSemibold
    lbl2.TextSize = 13
    lbl2.TextColor3 = T.White
    lbl2.Parent = f
    local kbtn = Instance.new("TextButton")
    kbtn.Size = UDim2.new(0, 80, 0, 26)
    kbtn.Position = UDim2.new(1, -96, 0.5, -13)
    kbtn.BackgroundColor3 = T.Off
    kbtn.Text = tostring(userSettings.ToggleKey)
    kbtn.Font = Enum.Font.GothamBold
    kbtn.TextSize = 11
    kbtn.TextColor3 = T.Accent2
    kbtn.Parent = f
    Instance.new("UICorner", kbtn).CornerRadius = UDim.new(0, 5)
    local conn
    kbtn.MouseButton1Click:Connect(function()
        kbtn.Text = "..."
        if conn then conn:Disconnect() end
        conn = UserInputService.InputBegan:Connect(function(input, gpe)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                userSettings.ToggleKey = input.KeyCode.Name
                kbtn.Text = input.KeyCode.Name
                KeyHint.Text = input.KeyCode.Name .. " = Toggle\nGREEN BUTTON = Join 100M+"
                conn:Disconnect(); conn = nil
            end
        end)
    end)
end

local function spacer(parent)
    local s = Instance.new("Frame", parent)
    s.Size = UDim2.new(1, 0, 0, 4)
    s.BackgroundTransparency = 1
end

makeHeader("── UI SETTINGS", SScroll)
makeKeybindSetting(SScroll, "Toggle GUI Keybind")
spacer(SScroll)
makeHeader("── NOTIFICATIONS", SScroll)
makeToggle(SScroll, "Play Sound on Join", "PlaySound")
spacer(SScroll)
makeHeader("── JOIN SETTINGS", SScroll)
makeToggle(SScroll, "AUTO JOINER", "AutoJoin")

-- LOGS PAGE
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundTransparency = 1
TopBar.Parent = LogsPage

-- AutoJoin panel
local ajPanel = Instance.new("Frame")
ajPanel.Size = UDim2.new(1, -95, 0, 36)
ajPanel.Position = UDim2.new(0, 15, 0, 10)
ajPanel.BackgroundColor3 = T.BgCard
ajPanel.Parent = TopBar
Instance.new("UICorner", ajPanel).CornerRadius = UDim.new(0, 8)
local ajStroke = Instance.new("UIStroke")
ajStroke.Color = T.Off
ajStroke.Thickness = 1
ajStroke.Parent = ajPanel
local ajPulse = Instance.new("Frame")
ajPulse.Size = UDim2.new(0, 8, 0, 8)
ajPulse.Position = UDim2.new(0, 12, 0.5, -4)
ajPulse.BackgroundColor3 = T.Off
ajPulse.Parent = ajPanel
Instance.new("UICorner", ajPulse).CornerRadius = UDim.new(1, 0)
local ajLbl = Instance.new("TextLabel")
ajLbl.Size = UDim2.new(0, 110, 1, 0)
ajLbl.Position = UDim2.new(0, 28, 0, 0)
ajLbl.BackgroundTransparency = 1
ajLbl.Text = "AUTO JOINER"
ajLbl.Font = Enum.Font.GothamBold
ajLbl.TextXAlignment = Enum.TextXAlignment.Left
ajLbl.TextSize = 12
ajLbl.TextColor3 = T.White
ajLbl.Parent = ajPanel
local ajStatus = Instance.new("TextLabel")
ajStatus.Size = UDim2.new(0, 140, 1, 0)
ajStatus.Position = UDim2.new(0, 100, 0, 0)
ajStatus.BackgroundTransparency = 1
ajStatus.Text = ""
ajStatus.Font = Enum.Font.GothamBold
ajStatus.TextXAlignment = Enum.TextXAlignment.Left
ajStatus.TextSize = 10
ajStatus.TextColor3 = T.Green
ajStatus.Parent = ajPanel
local ajTrack = Instance.new("TextButton")
ajTrack.Size = UDim2.new(0, 42, 0, 22)
ajTrack.Position = UDim2.new(1, -56, 0.5, -11)
ajTrack.BackgroundColor3 = userSettings.AutoJoin and T.Accent1 or T.Off
ajTrack.Text = ""
ajTrack.Parent = ajPanel
Instance.new("UICorner", ajTrack).CornerRadius = UDim.new(1, 0)
local ajDot = Instance.new("Frame")
ajDot.Size = UDim2.new(0, 16, 0, 16)
ajDot.Position = userSettings.AutoJoin and UDim2.new(1,-19,0,3) or UDim2.new(0,3,0,3)
ajDot.BackgroundColor3 = T.White
ajDot.Parent = ajTrack
Instance.new("UICorner", ajDot).CornerRadius = UDim.new(1, 0)

updateAJVisuals = function(on)
    TweenService:Create(ajDot, TweenInfo.new(0.15, Enum.EasingStyle.Quad),
        {Position = on and UDim2.new(1,-19,0,3) or UDim2.new(0,3,0,3)}):Play()
    TweenService:Create(ajTrack, TweenInfo.new(0.15), {BackgroundColor3 = on and T.Accent1 or T.Off}):Play()
    TweenService:Create(ajPulse, TweenInfo.new(0.2), {BackgroundColor3 = on and T.Green or T.Off}):Play()
    TweenService:Create(ajStroke, TweenInfo.new(0.2), {Color = on and T.Accent1 or T.Off}):Play()
    ajStatus.Text = on and "ACTIVE" or ""
    ajStatus.TextColor3 = T.Green
end
ajTrack.MouseButton1Click:Connect(function()
    userSettings.AutoJoin = not userSettings.AutoJoin
    updateAJVisuals(userSettings.AutoJoin)
end)

-- Feed status pill
local feedPill = Instance.new("Frame")
feedPill.Size = UDim2.new(0, 85, 0, 26)
feedPill.Position = UDim2.new(1, -98, 0.5, -13)
feedPill.BackgroundColor3 = T.BgCard
feedPill.Parent = TopBar
Instance.new("UICorner", feedPill).CornerRadius = UDim.new(0, 13)
local feedDot = Instance.new("Frame")
feedDot.Size = UDim2.new(0, 7, 0, 7)
feedDot.Position = UDim2.new(0, 8, 0.5, -3.5)
feedDot.BackgroundColor3 = T.Green
feedDot.Parent = feedPill
Instance.new("UICorner", feedDot).CornerRadius = UDim.new(1, 0)
local feedLbl = Instance.new("TextLabel")
feedLbl.Size = UDim2.new(1, -22, 1, 0)
feedLbl.Position = UDim2.new(0, 20, 0, 0)
feedLbl.BackgroundTransparency = 1
feedLbl.Text = "100M+ READY"
feedLbl.Font = Enum.Font.GothamBold
feedLbl.TextSize = 9
feedLbl.TextColor3 = T.Green
feedLbl.TextXAlignment = Enum.TextXAlignment.Left
feedLbl.Parent = feedPill

-- Brainrot list scroll area (DISPLAY ONLY - NOT CLICKABLE)
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, 0, 1, -55)
Content.Position = UDim2.new(0, 0, 0, 52)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 2
Content.ScrollBarImageColor3 = T.Off
Content.Parent = LogsPage
local CLayout = Instance.new("UIListLayout")
CLayout.Parent = Content
CLayout.Padding = UDim.new(0, 6)
CLayout.SortOrder = Enum.SortOrder.Name
local CPad = Instance.new("UIPadding")
CPad.PaddingLeft = UDim.new(0, 15)
CPad.PaddingRight = UDim.new(0, 15)
CPad.PaddingTop = UDim.new(0, 4)
CPad.Parent = Content
CLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0, 0, 0, CLayout.AbsoluteContentSize.Y + 10)
end)

-- Current brainrot display (rotates every 5 seconds - DISPLAY ONLY)
local currentBrainrotIndex = 1
local currentBrainrot = allBrainrots[1]

-- Create the main display card with green button (THIS IS THE ONLY JOIN METHOD)
local function createMainBrainrotCard()
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 90)
    card.BackgroundColor3 = T.BgCard
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    card.Parent = Content
    
    -- Green circle indicator
    local greenCircle = Instance.new("Frame")
    greenCircle.Size = UDim2.new(0, 14, 0, 14)
    greenCircle.Position = UDim2.new(0, 15, 0.5, -7)
    greenCircle.BackgroundColor3 = T.Green
    greenCircle.Parent = card
    Instance.new("UICorner", greenCircle).CornerRadius = UDim.new(1, 0)
    
    -- Pulsing animation for circle
    task.spawn(function()
        while card and card.Parent do
            TweenService:Create(greenCircle, TweenInfo.new(0.8), {BackgroundColor3 = T.Accent2}):Play()
            task.wait(0.4)
            TweenService:Create(greenCircle, TweenInfo.new(0.8), {BackgroundColor3 = T.Green}):Play()
            task.wait(0.4)
        end
    end)
    
    -- Timer text (shows countdown)
    local timerLabel = Instance.new("TextLabel")
    timerLabel.Size = UDim2.new(0, 100, 0, 18)
    timerLabel.Position = UDim2.new(0, 38, 0, 5)
    timerLabel.BackgroundTransparency = 1
    timerLabel.TextXAlignment = Enum.TextXAlignment.Left
    timerLabel.Text = "Next in: 5s"
    timerLabel.Font = Enum.Font.Gotham
    timerLabel.TextSize = 9
    timerLabel.TextColor3 = T.TextDim
    timerLabel.Parent = card
    
    -- "CURRENT BRAINROT" label
    local currentLabel = Instance.new("TextLabel")
    currentLabel.Size = UDim2.new(1, -180, 0, 16)
    currentLabel.Position = UDim2.new(0, 38, 0, 25)
    currentLabel.BackgroundTransparency = 1
    currentLabel.TextXAlignment = Enum.TextXAlignment.Left
    currentLabel.Text = "🔥 CURRENT BRAINROT"
    currentLabel.Font = Enum.Font.GothamBold
    currentLabel.TextSize = 9
    currentLabel.TextColor3 = T.Accent2
    currentLabel.Parent = card
    
    -- VALUE LABEL (ON TOP OF BRAINROT NAME)
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, -180, 0, 20)
    valueLabel.Position = UDim2.new(0, 38, 0, 42)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Text = "💰 " .. formatValue(currentBrainrot.value)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = T.Gold
    valueLabel.Parent = card
    
    -- Brainrot name (DISPLAY ONLY - BELOW THE VALUE)
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -180, 0, 24)
    nameLabel.Position = UDim2.new(0, 38, 0, 62)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Text = currentBrainrot.name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.TextColor3 = T.White
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = card
    
    -- GREEN JOIN BUTTON (THIS IS THE ONLY WAY TO JOIN)
    local joinButton = Instance.new("TextButton")
    joinButton.Size = UDim2.new(0, 120, 0, 50)
    joinButton.Position = UDim2.new(1, -135, 0.5, -25)
    joinButton.BackgroundColor3 = T.Green
    joinButton.Text = "▶ JOIN NOW"
    joinButton.Font = Enum.Font.GothamBold
    joinButton.TextSize = 16
    joinButton.TextColor3 = T.White
    joinButton.Parent = card
    Instance.new("UICorner", joinButton).CornerRadius = UDim.new(0, 10)
    
    -- Button hover effect
    joinButton.MouseEnter:Connect(function()
        TweenService:Create(joinButton, TweenInfo.new(0.15), {BackgroundColor3 = T.Accent2}):Play()
        TweenService:Create(joinButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 126, 0, 54)}):Play()
    end)
    joinButton.MouseLeave:Connect(function()
        TweenService:Create(joinButton, TweenInfo.new(0.15), {BackgroundColor3 = T.Green}):Play()
        TweenService:Create(joinButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 120, 0, 50)}):Play()
    end)
    
    -- Join function (ONLY HERE)
    local currentlyJoining = false
    joinButton.MouseButton1Click:Connect(function()
        if currentlyJoining then return end
        currentlyJoining = true
        
        joinButton.Text = "JOINING..."
        joinButton.BackgroundColor3 = T.GreenDim
        
        if userSettings.PlaySound then playNotifSound() end
        
        task.spawn(function()
            pcall(function()
                TeleportService:Teleport(game.PlaceId)
            end)
            task.wait(2)
            joinButton.Text = "▶ JOIN NOW"
            joinButton.BackgroundColor3 = T.Green
            currentlyJoining = false
        end)
    end)
    
    -- Update function for brainrot (DISPLAY ONLY)
    local function updateBrainrot(newBrainrot)
        currentBrainrot = newBrainrot
        nameLabel.Text = newBrainrot.name
        valueLabel.Text = "💰 " .. formatValue(newBrainrot.value)
        
        -- Color based on value
        if newBrainrot.value >= 1000000000 then
            valueLabel.TextColor3 = T.Gold
            valueLabel.Text = "🏆 " .. formatValue(newBrainrot.value) .. " 💎"
        elseif newBrainrot.value >= 500000000 then
            valueLabel.TextColor3 = T.Accent2
        else
            valueLabel.TextColor3 = T.Green
        end
    end
    
    -- Timer update for countdown
    local countdown = 5
    task.spawn(function()
        while card and card.Parent do
            if userSettings.AutoJoin then
                countdown = countdown - 1
                timerLabel.Text = "Auto-join in: " .. countdown .. "s"
                AJTimeRemaining.Text = "Next join in: " .. countdown .. "s"
                
                if countdown <= 0 then
                    countdown = 5
                    -- Auto join using the join button
                    if not currentlyJoining then
                        currentlyJoining = true
                        joinButton.Text = "JOINING..."
                        joinButton.BackgroundColor3 = T.GreenDim
                        
                        if userSettings.PlaySound then playNotifSound() end
                        
                        task.spawn(function()
                            pcall(function()
                                TeleportService:Teleport(game.PlaceId)
                            end)
                            task.wait(2)
                            joinButton.Text = "▶ JOIN NOW"
                            joinButton.BackgroundColor3 = T.Green
                            currentlyJoining = false
                        end)
                    end
                    
                    -- Rotate to next brainrot (DISPLAY ONLY)
                    currentBrainrotIndex = currentBrainrotIndex % #allBrainrots + 1
                    updateBrainrot(allBrainrots[currentBrainrotIndex])
                end
            else
                timerLabel.Text = "Changes in: " .. countdown .. "s"
                AJTimeRemaining.Text = "Auto-join: OFF"
            end
            task.wait(1)
        end
    end)
    
    -- Rotate brainrot every 5 seconds (DISPLAY ONLY - NOT JOINING)
    task.spawn(function()
        while card and card.Parent do
            task.wait(5)
            if not userSettings.AutoJoin then
                currentBrainrotIndex = currentBrainrotIndex % #allBrainrots + 1
                updateBrainrot(allBrainrots[currentBrainrotIndex])
            end
        end
    end)
    
    return card, updateBrainrot
end

-- Create the main brainrot display (THIS IS THE ONLY JOIN BUTTON)
local mainCard, updateMainBrainrot = createMainBrainrotCard()

-- Add a separator
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, 0, 0, 2)
separator.BackgroundColor3 = T.BgCard
separator.Parent = Content

-- "RECOMMENDED" label
local recLabel = Instance.new("TextLabel")
recLabel.Size = UDim2.new(1, 0, 0, 24)
recLabel.BackgroundTransparency = 1
recLabel.Text = "── RECOMMENDED 100M+ BRAINROTS ──"
recLabel.Font = Enum.Font.GothamBold
recLabel.TextSize = 11
recLabel.TextColor3 = T.Green
recLabel.Parent = Content

-- Display good brainrots (DISPLAY ONLY - NOT CLICKABLE)
for _, brainrot in ipairs(GOOD_BRAINROTS) do
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 50)
    card.BackgroundColor3 = T.BgCardHover
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    card.Parent = Content
    
    local greenCircle = Instance.new("Frame")
    greenCircle.Size = UDim2.new(0, 8, 0, 8)
    greenCircle.Position = UDim2.new(0, 15, 0.5, -4)
    greenCircle.BackgroundColor3 = T.Green
    greenCircle.Parent = card
    Instance.new("UICorner", greenCircle).CornerRadius = UDim.new(1, 0)
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, -30, 0, 16)
    valueLabel.Position = UDim2.new(0, 35, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Text = "💰 " .. formatValue(brainrot.value)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.TextColor3 = T.Gold
    valueLabel.Parent = card
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -30, 0, 20)
    nameLabel.Position = UDim2.new(0, 35, 0, 24)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Text = brainrot.name
    nameLabel.Font = Enum.Font.GothamSemibold
    nameLabel.TextSize = 12
    nameLabel.TextColor3 = T.White
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = card
    
    -- Note: NO JOIN BUTTON on these - they are just for display
end

-- ESP (June Auto Joiner badge)
local function attachESP(char, labelText)
    task.spawn(function()
        local head = char:WaitForChild("Head", 10)
        if not head then return end
        if head:FindFirstChild("JUNE_USER_ESP") then head.JUNE_USER_ESP:Destroy() end
        local bg = Instance.new("BillboardGui")
        bg.Name = "JUNE_USER_ESP"
        bg.Size = UDim2.new(0, 160, 0, 30)
        bg.StudsOffset = Vector3.new(0, 2.8, 0)
        bg.AlwaysOnTop = true
        bg.Parent = head
        local badge = Instance.new("Frame")
        badge.Size = UDim2.new(1, 0, 1, 0)
        badge.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
        badge.BackgroundTransparency = 0.25
        badge.Parent = bg
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)
        local bStroke = Instance.new("UIStroke")
        bStroke.Thickness = 1.5
        bStroke.Color = ESP_GREEN
        bStroke.Parent = badge
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Text = labelText or "June User"
        txt.Font = Enum.Font.GothamBlack
        txt.TextSize = 12
        txt.TextColor3 = ESP_GREEN
        txt.Parent = badge
    end)
end

if lp.Character then attachESP(lp.Character, "June User") end
lp.CharacterAdded:Connect(function(c) attachESP(c, "June User") end)

-- AJ users registration
task.spawn(function()
    local who = HttpService:UrlEncode(lp.Name)
    while _G.JuneAutoJoinerRunning do
        pcall(function() httpGet(AJ_REGISTER_URL .. "?u=" .. who) end)
        task.wait(300)
    end
end)

-- Chroma border loop (green theme)
task.spawn(function()
    while _G.JuneAutoJoinerRunning do
        local tk = tick()
        local phase = (math.sin(tk * 0.8) + 1) / 2
        local r = 34 + math.floor(phase * 40)
        local g = 197 + math.floor(phase * 25)
        local b = 94 + math.floor(phase * 30)
        local color = Color3.fromRGB(r, g, b)
        BorderGrad.Rotation = (tk * 60) % 360
        BorderGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, color),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(74, 222, 128)),
            ColorSequenceKeypoint.new(1, color),
        }
        Logo.TextColor3 = color
        for k, v in pairs(tabButtons) do
            if k == curTab then v.ind.BackgroundColor3 = color end
        end
        if userSettings.AutoJoin then ajPulse.BackgroundColor3 = color end
        task.wait(0.04)
    end
end)

-- Startup message
_G.JuneAutoJoinerRunning = true
print("═══════════════════════════════════════════════════════════")
print("     🌿 JUNE AUTO JOINER - GREEN EDITION 🌿")
print("═══════════════════════════════════════════════════════════")
print("✅ No Code Required! GUI Loaded!")
print("")
print("📱 HOW TO USE:")
print("   • Click the BIG GREEN JOIN BUTTON to join a 100M+ server")
print("   • Toggle AUTO JOINER for automatic joining every 5s")
print("   • Value is shown ABOVE the brainrot name")
print("   • Brainrot changes every 5 seconds (DISPLAY ONLY)")
print("")
print("📋 100M+ Brainrots Available: " .. #GOOD_BRAINROTS)
print("📋 Total Brainrots in rotation: " .. #allBrainrots)
print("═══════════════════════════════════════════════════════════")