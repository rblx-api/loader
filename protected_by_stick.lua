-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"22suhail2"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

print("Poison Hub loaded")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")

local LP = Players.LocalPlayer

-- ============================================================
-- PURE BLACK & SMOOTH GREEN COLORS
-- ============================================================
local BLACK = Color3.fromRGB(0, 0, 0)
local WHITE = Color3.fromRGB(0, 180, 0)
local GREEN = Color3.fromRGB(0, 255, 0)
local RED = Color3.fromRGB(255, 0, 0)

-- ============================================================
-- SKY THEME - Full 24 Preset System
-- ============================================================
local currentSkyTheme = "Night"
local candyOriginalLighting = nil
local CANDY_SKY_TAG = "PoisonSkyTheme"

local CANDY_SKY_PRESETS = {
    ["Off"] = {kind = "off"},
    ["Night"] = {
        clock = 22, brightness = 2,
        ambient = {110,100,130}, outAmb = {120,110,140},
        sky = {stars = 4000, moon = 18, sun = 0, moonTex = true},
        atm = {dens = 0.45, color = {120,60,180}, decay = {60,20,100}, glare = 0.5, haze = 1.2},
    },
    ["Aurora"] = {
        clock = 14, brightness = 3,
        ambient = {150,120,150}, outAmb = {160,130,160},
        atm = {dens = 0.55, color = {255,80,200}, decay = {255,20,150}, glare = 2.5, haze = 3},
        clouds = {cover = 0.7, dens = 0.7, color = {255,240,250}},
    },
    ["Sunset"] = {
        clock = 17.2, brightness = 2.5,
        ambient = {170,120,100}, outAmb = {180,130,110},
        sky = {stars = 0, sun = 25, moon = 0},
        atm = {dens = 0.5, color = {255,130,60}, decay = {255,80,30}, glare = 2, haze = 2.5},
        clouds = {cover = 0.55, dens = 0.55, color = {255,200,140}},
    },
    ["Galaxy"] = {
        clock = 0, brightness = 1.5,
        ambient = {70,60,100}, outAmb = {80,70,110},
        sky = {stars = 10000, moon = 30, sun = 0},
        atm = {dens = 0.15, color = {40,20,80}, decay = {20,10,50}, glare = 0.3, haze = 0.5},
    },
    ["Cyber"] = {
        clock = 21, brightness = 2.2,
        ambient = {90,130,170}, outAmb = {100,140,180},
        sky = {stars = 2000, moon = 12},
        atm = {dens = 0.4, color = {0,200,255}, decay = {150,0,255}, glare = 2, haze = 2},
        clouds = {cover = 0.4, dens = 0.6, color = {100,200,255}},
    },
    ["Sakura"] = {
        clock = 11, brightness = 3.5,
        ambient = {170,150,160}, outAmb = {180,160,170},
        sky = {sun = 8},
        atm = {dens = 0.3, color = {255,200,220}, decay = {255,170,200}, glare = 1, haze = 1.5},
        clouds = {cover = 0.6, dens = 0.4, color = {255,250,252}},
    },
    ["Pink Night"] = {
        clock = 23, brightness = 2.2,
        ambient = {120,60,110}, outAmb = {140,70,120},
        sky = {stars = 5000, moon = 22, sun = 0, moonTex = true},
        atm = {dens = 0.5, color = {255,80,180}, decay = {140,30,100}, glare = 0.7, haze = 1.4},
        clouds = {cover = 0.3, dens = 0.5, color = {180,90,150}},
    },
    ["Blood Moon"] = {
        clock = 22.5, brightness = 1.6,
        ambient = {130,40,40}, outAmb = {150,50,50},
        sky = {stars = 1500, moon = 28, sun = 0, moonTex = true},
        atm = {dens = 0.6, color = {220,30,30}, decay = {120,10,10}, glare = 1.4, haze = 2},
        clouds = {cover = 0.5, dens = 0.7, color = {120,30,30}},
    },
    ["Emerald Dawn"] = {
        clock = 6.5, brightness = 2.8,
        ambient = {130,170,140}, outAmb = {140,180,150},
        sky = {sun = 18, moon = 0, stars = 0},
        atm = {dens = 0.4, color = {80,200,140}, decay = {40,150,90}, glare = 1.8, haze = 2.2},
        clouds = {cover = 0.5, dens = 0.5, color = {200,255,220}},
    },
    ["Volcanic"] = {
        clock = 19, brightness = 2,
        ambient = {180,80,40}, outAmb = {200,90,50},
        sky = {stars = 200, sun = 12, moon = 0},
        atm = {dens = 0.75, color = {255,60,0}, decay = {180,20,0}, glare = 3, haze = 3.5},
        clouds = {cover = 0.8, dens = 0.9, color = {120,40,20}},
    },
    ["Arctic"] = {
        clock = 9, brightness = 3.2,
        ambient = {200,220,235}, outAmb = {210,230,245},
        sky = {sun = 10, stars = 0, moon = 0},
        atm = {dens = 0.3, color = {180,220,255}, decay = {140,200,240}, glare = 1.5, haze = 1.8},
        clouds = {cover = 0.7, dens = 0.6, color = {250,253,255}},
    },
    ["Midnight Ocean"] = {
        clock = 1.5, brightness = 1.7,
        ambient = {60,90,130}, outAmb = {70,100,140},
        sky = {stars = 6000, moon = 24, sun = 0, moonTex = true},
        atm = {dens = 0.5, color = {20,60,140}, decay = {10,30,90}, glare = 0.6, haze = 1.5},
    },
    ["Vaporwave"] = {
        clock = 19.5, brightness = 2.4,
        ambient = {180,120,200}, outAmb = {190,130,210},
        sky = {stars = 1000, moon = 14},
        atm = {dens = 0.45, color = {255,100,220}, decay = {120,60,255}, glare = 2.2, haze = 2.4},
        clouds = {cover = 0.5, dens = 0.55, color = {200,150,255}},
    },
    ["Toxic"] = {
        clock = 13, brightness = 2.5,
        ambient = {140,180,80}, outAmb = {150,190,90},
        atm = {dens = 0.55, color = {100,220,40}, decay = {60,150,20}, glare = 1.8, haze = 2.6},
        clouds = {cover = 0.65, dens = 0.7, color = {180,255,120}},
    },
    ["Solar Eclipse"] = {
        clock = 12, brightness = 0.9,
        ambient = {50,40,60}, outAmb = {60,50,70},
        sky = {stars = 3500, sun = 22, moon = 0},
        atm = {dens = 0.5, color = {255,140,40}, decay = {30,20,40}, glare = 2.8, haze = 1.8},
    },
    ["Hellscape"] = {
        clock = 18, brightness = 1.8,
        ambient = {200,60,30}, outAmb = {220,70,40},
        sky = {stars = 100, sun = 30, moon = 0},
        atm = {dens = 0.85, color = {255,30,0}, decay = {120,0,0}, glare = 3.5, haze = 4},
        clouds = {cover = 0.95, dens = 0.95, color = {80,20,10}},
    },
    ["Heaven"] = {
        clock = 12, brightness = 4,
        ambient = {240,235,210}, outAmb = {250,245,220},
        sky = {sun = 16, moon = 0, stars = 0},
        atm = {dens = 0.25, color = {255,250,220}, decay = {255,240,200}, glare = 3, haze = 1.5},
        clouds = {cover = 0.85, dens = 0.5, color = {255,255,255}},
    },
    ["Storm"] = {
        clock = 15, brightness = 1.4,
        ambient = {90,90,110}, outAmb = {100,100,120},
        sky = {stars = 0, sun = 6, moon = 0},
        atm = {dens = 0.65, color = {80,90,120}, decay = {40,50,80}, glare = 0.5, haze = 3},
        clouds = {cover = 0.95, dens = 0.95, color = {60,65,80}},
    },
    ["Sunrise"] = {
        clock = 6.2, brightness = 2.8,
        ambient = {220,180,130}, outAmb = {230,190,140},
        sky = {sun = 22, stars = 0, moon = 0},
        atm = {dens = 0.45, color = {255,180,100}, decay = {255,140,80}, glare = 2.4, haze = 2.2},
        clouds = {cover = 0.4, dens = 0.4, color = {255,220,180}},
    },
    ["Deep Space"] = {
        clock = 0, brightness = 1,
        ambient = {30,25,50}, outAmb = {40,35,60},
        sky = {stars = 15000, moon = 0, sun = 0},
        atm = {dens = 0.08, color = {15,5,40}, decay = {5,0,20}, glare = 0.2, haze = 0.3},
    },
    ["Lavender Dream"] = {
        clock = 18.5, brightness = 2.6,
        ambient = {180,160,220}, outAmb = {190,170,230},
        sky = {stars = 800, moon = 16, sun = 0},
        atm = {dens = 0.4, color = {200,160,255}, decay = {160,120,220}, glare = 1.4, haze = 1.8},
        clouds = {cover = 0.55, dens = 0.5, color = {220,200,255}},
    },
    ["Inferno"] = {
        clock = 17.5, brightness = 2.2,
        ambient = {220,100,40}, outAmb = {235,110,50},
        sky = {sun = 26, moon = 0, stars = 0},
        atm = {dens = 0.6, color = {255,90,20}, decay = {200,40,0}, glare = 3, haze = 3.2},
        clouds = {cover = 0.7, dens = 0.7, color = {200,80,40}},
    },
    ["Mint Sky"] = {
        clock = 10, brightness = 3.2,
        ambient = {180,230,210}, outAmb = {190,240,220},
        sky = {sun = 10},
        atm = {dens = 0.32, color = {150,255,210}, decay = {100,220,180}, glare = 1.6, haze = 1.6},
        clouds = {cover = 0.55, dens = 0.45, color = {240,255,250}},
    },
}

local CandySkyOrder = {
    {"Off", "Off"},
    {"Night", "Night"},
    {"Aurora", "Aurora"},
    {"Sunset", "Sunset"},
    {"Galaxy", "Galaxy"},
    {"Cyber", "Cyber"},
    {"Sakura", "Sakura"},
    {"Pink Night", "Pink Night"},
    {"Blood Moon", "Blood Moon"},
    {"Emerald Dawn", "Emerald Dawn"},
    {"Volcanic", "Volcanic"},
    {"Arctic", "Arctic"},
    {"Midnight Ocean", "Midnight Ocean"},
    {"Vaporwave", "Vaporwave"},
    {"Toxic", "Toxic"},
    {"Solar Eclipse", "Solar Eclipse"},
    {"Hellscape", "Hellscape"},
    {"Heaven", "Heaven"},
    {"Storm", "Storm"},
    {"Sunrise", "Sunrise"},
    {"Deep Space", "Deep Space"},
    {"Lavender Dream", "Lavender Dream"},
    {"Inferno", "Inferno"},
    {"Mint Sky", "Mint Sky"}
}

local function candyColor(rgb)
    return Color3.fromRGB(rgb[1], rgb[2], rgb[3])
end

local function candySaveOriginalLighting()
    if candyOriginalLighting then return end
    candyOriginalLighting = {
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        FogColor = Lighting.FogColor,
        ColorShift_Top = Lighting.ColorShift_Top,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        GeographicLatitude = Lighting.GeographicLatitude,
        GlobalShadows = Lighting.GlobalShadows,
        LightingChildren = {},
        TerrainChildren = {}
    }
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child:IsA("Atmosphere") then 
            table.insert(candyOriginalLighting.LightingChildren, child:Clone()) 
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:IsA("Clouds") then 
                table.insert(candyOriginalLighting.TerrainChildren, child:Clone()) 
            end
        end
    end
end

local function candyClearSky(removeAll)
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute(CANDY_SKY_TAG) or (removeAll and (child:IsA("Sky") or child:IsA("Atmosphere"))) then 
            pcall(function() child:Destroy() end) 
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute(CANDY_SKY_TAG) or (removeAll and child:IsA("Clouds")) then 
                pcall(function() child:Destroy() end) 
            end
        end
    end
end

local function candyInstance(className, parent, props)
    local inst = Instance.new(className)
    inst:SetAttribute(CANDY_SKY_TAG, true)
    for k, v in pairs(props or {}) do pcall(function() inst[k] = v end) end
    inst.Parent = parent
    return inst
end

function CandyApplyCustomSky(mode)
    candySaveOriginalLighting()
    candyClearSky(true)
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    local preset = CANDY_SKY_PRESETS[mode]
    
    if not preset or preset.kind == "off" then
        if candyOriginalLighting then
            for k, v in pairs(candyOriginalLighting) do
                if k ~= "LightingChildren" and k ~= "TerrainChildren" then 
                    pcall(function() Lighting[k] = v end) 
                end
            end
            for _, child in ipairs(candyOriginalLighting.LightingChildren or {}) do 
                child:Clone().Parent = Lighting 
            end
            local offTerrain = workspace:FindFirstChildOfClass("Terrain")
            if offTerrain then
                for _, child in ipairs(candyOriginalLighting.TerrainChildren or {}) do 
                    child:Clone().Parent = offTerrain 
                end
            end
        end
        currentSkyTheme = "Off"
        return
    end

    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200, 200, 200)
    Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = candyColor(preset.ambient) end

    if preset.sky then
        local skyProps = {}
        if preset.sky.stars then skyProps.StarCount = preset.sky.stars end
        if preset.sky.moon then skyProps.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyProps.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyProps.MoonTextureId = "rbxasset://sky/moon.jpg" end
        candyInstance("Sky", Lighting, skyProps)
    end

    if preset.atm then
        candyInstance("Atmosphere", Lighting, {
            Density = preset.atm.dens or 0.3,
            Color = candyColor(preset.atm.color),
            Decay = candyColor(preset.atm.decay),
            Glare = preset.atm.glare or 1,
            Haze = preset.atm.haze or 1
        })
    end

    if preset.clouds and terrain then
        candyInstance("Clouds", terrain, {
            Cover = preset.clouds.cover or 0.5,
            Density = preset.clouds.dens or 0.5,
            Color = candyColor(preset.clouds.color)
        })
    end

    currentSkyTheme = mode
end

-- ============================================================
-- POISON BACKGROUND – white text, reduced visibility
-- ============================================================
local function createPoisonBackground()
    local bgGui = Instance.new("ScreenGui")
    bgGui.Name = "PoisonBg"
    bgGui.ResetOnSpawn = false
    bgGui.IgnoreGuiInset = true
    bgGui.DisplayOrder = 0
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(bgGui) end
    end)
    if not pcall(function() bgGui.Parent = game:GetService("CoreGui") end) then
        bgGui.Parent = LP:WaitForChild("PlayerGui")
    end

    local words = {"POISON", "POISON", "POISON", "POISON", "POISON", "POISON", "POISON", "POISON"}
    
    for i = 1, 8 do
        task.spawn(function()
            local label = Instance.new("TextLabel", bgGui)
            label.Text = words[math.random(1, #words)]
            label.TextColor3 = WHITE
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextTransparency = 1
            local size = math.random(12, 28)
            label.TextSize = size
            label.Size = UDim2.new(0, size * #label.Text * 0.6, 0, size * 1.2)
            label.Position = UDim2.new(math.random() * 0.9, 0, math.random() * 0.9, 0)
            label.ZIndex = 1
            label.TextStrokeTransparency = 0.5
            label.TextStrokeColor3 = BLACK
            
            task.wait(math.random(2, 5))
            TweenService:Create(label, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {TextTransparency = 0.8}):Play()
            local xDir = math.random() > 0.5 and 1 or -1
            local yDir = math.random() > 0.5 and 1 or -1
            TweenService:Create(label, TweenInfo.new(8 + math.random()*4, Enum.EasingStyle.Linear), {
                Position = UDim2.new(math.clamp(label.Position.X.Scale + (xDir * 0.15), 0, 0.9), 0, 
                                     math.clamp(label.Position.Y.Scale + (yDir * 0.15), 0, 0.9), 0)
            }):Play()
            task.wait(8 + math.random()*4)
            TweenService:Create(label, TweenInfo.new(2, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
            task.wait(2)
            label:Destroy()
        end)
    end
    
    task.spawn(function()
        while bgGui and bgGui.Parent do
            task.wait(math.random(4, 8))
            local label = Instance.new("TextLabel", bgGui)
            label.Text = words[math.random(1, #words)]
            label.TextColor3 = WHITE
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextTransparency = 1
            local size = math.random(12, 28)
            label.TextSize = size
            label.Size = UDim2.new(0, size * #label.Text * 0.6, 0, size * 1.2)
            label.Position = UDim2.new(math.random() * 0.9, 0, math.random() * 0.9, 0)
            label.ZIndex = 1
            label.TextStrokeTransparency = 0.5
            label.TextStrokeColor3 = BLACK
            
            TweenService:Create(label, TweenInfo.new(1.0, Enum.EasingStyle.Quad), {TextTransparency = 0.8}):Play()
            local xDir = math.random() > 0.5 and 1 or -1
            local yDir = math.random() > 0.5 and 1 or -1
            TweenService:Create(label, TweenInfo.new(8 + math.random()*4, Enum.EasingStyle.Linear), {
                Position = UDim2.new(math.clamp(label.Position.X.Scale + (xDir * 0.15), 0, 0.9), 0, 
                                     math.clamp(label.Position.Y.Scale + (yDir * 0.15), 0, 0.9), 0)
            }):Play()
            task.wait(8 + math.random()*4)
            TweenService:Create(label, TweenInfo.new(2, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
            task.wait(2)
            label:Destroy()
        end
    end)
end

createPoisonBackground()

-- ============================================================
-- POISON DUELS INTRO (6 seconds, SKIP at TOP RIGHT in SQUARE)
-- ============================================================
local function playIntro()
    local _TS = TweenService
    local _PG = LP:WaitForChild("PlayerGui")
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "PoisonHubIntro"
    introGui.ResetOnSpawn = false
    introGui.IgnoreGuiInset = true
    introGui.DisplayOrder = 999
    introGui.Parent = _PG

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.new(0,0,0)
    bg.BackgroundTransparency = 0.15
    bg.BorderSizePixel = 0
    bg.Parent = introGui

    local blur = Instance.new("BlurEffect")
    blur.Size = 12
    blur.Parent = game:GetService("Lighting")

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0,400,0,350)
    container.Position = UDim2.new(0.5,-200,0.5,-175)
    container.BackgroundTransparency = 1
    container.Parent = bg

    -- SKIP BUTTON - TOP RIGHT (SQUARE)
    local skipBtn = Instance.new("TextButton", container)
    skipBtn.Size = UDim2.new(0, 60, 0, 60)
    skipBtn.Position = UDim2.new(1, -70, 0, 10)
    skipBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    skipBtn.BackgroundTransparency = 0.1
    skipBtn.BorderSizePixel = 2
    skipBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
    skipBtn.Text = "SKIP\nINTRO"
    skipBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    skipBtn.Font = Enum.Font.GothamBold
    skipBtn.TextSize = 10
    skipBtn.ZIndex = 10
    skipBtn.TextWrapped = true
    skipBtn.TextScaled = false
    Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 6)

    -- Glow behind skip button
    local skipGlow = Instance.new("Frame", container)
    skipGlow.Size = UDim2.new(0, 66, 0, 66)
    skipGlow.Position = UDim2.new(1, -73, 0, 7)
    skipGlow.BackgroundTransparency = 0.8
    skipGlow.BorderSizePixel = 0
    skipGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    skipGlow.ZIndex = 9
    Instance.new("UICorner", skipGlow).CornerRadius = UDim.new(0, 8)

    -- Logo/Icon
    local LOGO_ID = "rbxassetid://130968185699787"
    task.spawn(function() pcall(function() ContentProvider:PreloadAsync({LOGO_ID}) end) end)

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0,120,0,120)
    logo.Position = UDim2.new(0.5,-60,0,20)
    logo.BackgroundTransparency = 1
    logo.Image = LOGO_ID
    logo.ImageColor3 = Color3.fromRGB(0,255,0)
    logo.ImageTransparency = 1
    logo.ScaleType = Enum.ScaleType.Fit
    logo.Parent = container

    -- Main Title: POISON DUELS
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,50)
    title.Position = UDim2.new(0,0,0,155)
    title.BackgroundTransparency = 1
    title.Text = "POISON DUELS"
    title.TextColor3 = Color3.fromRGB(0,255,0)
    title.TextTransparency = 1
    title.TextScaled = true
    title.Font = Enum.Font.GothamBlack
    title.TextStrokeTransparency = 0.2
    title.TextStrokeColor3 = Color3.new(0,0,0)
    title.Parent = container

    -- Subtitle: POISON ON TOP in black with green outline
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0.8,0,0,30)
    sub.Position = UDim2.new(0.1,0,0,215)
    sub.BackgroundTransparency = 1
    sub.Text = "POISON ON TOP"
    sub.TextColor3 = Color3.fromRGB(0,0,0)
    sub.TextTransparency = 1
    sub.TextScaled = true
    sub.Font = Enum.Font.GothamBold
    sub.Parent = container

    -- Green outline/shadow for POISON ON TOP
    local subOutline = Instance.new("TextLabel")
    subOutline.Size = UDim2.new(0.8,0,0,30)
    subOutline.Position = UDim2.new(0.1,0,0,215)
    subOutline.BackgroundTransparency = 1
    subOutline.Text = "POISON ON TOP"
    subOutline.TextColor3 = Color3.fromRGB(0,255,0)
    subOutline.TextTransparency = 1
    subOutline.TextScaled = true
    subOutline.Font = Enum.Font.GothamBold
    subOutline.TextStrokeTransparency = 0.3
    subOutline.TextStrokeColor3 = Color3.new(0,0,0)
    subOutline.Parent = container

    -- Random POISON text floating around
    local poisonWords = {"POISON", "POISON", "POISON", "POISON", "POISON"}
    for i = 1, 5 do
        task.spawn(function()
            local pLabel = Instance.new("TextLabel", container)
            pLabel.Text = poisonWords[math.random(1, #poisonWords)]
            pLabel.TextColor3 = Color3.fromRGB(0,255,0)
            pLabel.BackgroundTransparency = 1
            pLabel.Font = Enum.Font.GothamBold
            pLabel.TextTransparency = 1
            local size = math.random(14, 24)
            pLabel.TextSize = size
            pLabel.Size = UDim2.new(0, size * #pLabel.Text * 0.6, 0, size * 1.2)
            pLabel.Position = UDim2.new(math.random() * 0.8 + 0.1, 0, math.random() * 0.7 + 0.15, 0)
            pLabel.ZIndex = 1
            pLabel.TextStrokeTransparency = 0.5
            pLabel.TextStrokeColor3 = Color3.new(0,0,0)
            
            task.wait(math.random(1, 3))
            _TS:Create(pLabel, TweenInfo.new(1.0, Enum.EasingStyle.Quad), {TextTransparency = 0.6}):Play()
            local xDir = math.random() > 0.5 and 1 or -1
            local yDir = math.random() > 0.5 and 1 or -1
            _TS:Create(pLabel, TweenInfo.new(6 + math.random()*3, Enum.EasingStyle.Linear), {
                Position = UDim2.new(math.clamp(pLabel.Position.X.Scale + (xDir * 0.15), 0.05, 0.95), 0, 
                                     math.clamp(pLabel.Position.Y.Scale + (yDir * 0.15), 0.05, 0.95), 0)
            }):Play()
            task.wait(6 + math.random()*3)
            _TS:Create(pLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
            task.wait(1.5)
            pLabel:Destroy()
        end)
    end

    -- Loading Bar (6 seconds)
    local loadingBg = Instance.new("Frame")
    loadingBg.Size = UDim2.new(0.6,0,0,4)
    loadingBg.Position = UDim2.new(0.2,0,0,265)
    loadingBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
    loadingBg.BackgroundTransparency = 0.5
    loadingBg.BorderSizePixel = 0
    loadingBg.Parent = container
    Instance.new("UICorner", loadingBg).CornerRadius = UDim.new(0,2)

    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0,0,1,0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
    loadingBar.BackgroundTransparency = 0.3
    loadingBar.BorderSizePixel = 0
    loadingBar.Parent = loadingBg
    Instance.new("UICorner", loadingBar).CornerRadius = UDim.new(0,2)

    -- Intro animations
    _TS:Create(bg, TweenInfo.new(0.7), {BackgroundTransparency = 0.15}):Play()
    _TS:Create(logo, TweenInfo.new(0.7), {ImageTransparency = 0}):Play()
    _TS:Create(title, TweenInfo.new(0.7), {TextTransparency = 0}):Play()
    _TS:Create(sub, TweenInfo.new(0.7), {TextTransparency = 0}):Play()
    _TS:Create(subOutline, TweenInfo.new(0.7), {TextTransparency = 0.1}):Play()
    _TS:Create(skipBtn, TweenInfo.new(0.7), {BackgroundTransparency = 0.1}):Play()
    _TS:Create(skipGlow, TweenInfo.new(0.7), {BackgroundTransparency = 0.5}):Play()
    _TS:Create(loadingBar, TweenInfo.new(6, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)}):Play()

    local introComplete = false

    -- Skip button functionality
    skipBtn.MouseButton1Click:Connect(function()
        if introComplete then return end
        introComplete = true
        _TS:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        _TS:Create(logo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
        _TS:Create(title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        _TS:Create(sub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        _TS:Create(subOutline, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        _TS:Create(loadingBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        _TS:Create(skipBtn, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        _TS:Create(skipGlow, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        task.wait(0.6)
        introGui:Destroy()
        blur:Destroy()
    end)

    -- Auto complete after 6 seconds
    task.wait(6)
    if not introComplete then
        introComplete = true
        _TS:Create(bg, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
        _TS:Create(logo, TweenInfo.new(0.8), {ImageTransparency = 1}):Play()
        _TS:Create(title, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
        _TS:Create(sub, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
        _TS:Create(subOutline, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
        _TS:Create(loadingBg, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
        _TS:Create(skipBtn, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
        _TS:Create(skipGlow, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
        task.wait(1)
        introGui:Destroy()
        blur:Destroy()
    end
end

-- Play the intro
playIntro()

-- ============================================================
-- STATE
-- ============================================================
local NS, CS = 60, 30
local LAGGER_SPEED = 15
local LAGGER_CARRY_SPEED = 24.5
local carrySpeedActive = false
local laggerModeEnabled = false

local antiRagdollEnabled, infJumpEnabled = false, false
local medusaCounterEnabled, batCounterEnabled, unwalkEnabled = false, false, false
local medusaResetEnabled = false
local medusaDebounce, medusaLastUsed, dropActive = false, 0, false
local autoLeftEnabled, autoRightEnabled = false, false
local autoLeftSetVisual, autoRightSetVisual = nil, nil
local speedLabel = nil
local speedModeLabel = nil
local batV1Enabled = false
local autoSwingEnabled = true
local batV1SetVisual = nil
local setBatCounterVisual = nil
local startBatCounter, stopBatCounter
local antiLagEnabled, removeAccessoriesEnabled, antiLagDescConn = false, false, nil
local stretchRezEnabled, stretchRezConn, setStretchRezVisual = false, nil, nil
local unwalkSavedAnimate, _anyKeyListening = false, nil
local autoTPEnabled, autoTPHeight, autoTPConn, setAutoTPVisual = false, 20, nil, nil
local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local mobileButtonsEnabled, mobileButtonsLocked = true, false
local mobileButtonsSize = 80
local mobBtnRefs = {}
local mobGuiRef = nil
local fovValue = 80
local laggerModePillRef = nil
local carryModePillRef = nil
local autoSwitchSpeedEnabled = false
local perButtonDragEnabled = false
local antiKickEnabled = false
local antiKickSetVisual = nil
local ragdollGuiEnabled = true
local uiLocked = false
local infJumpMode = "manual"
local holdInfJumpConn = nil
local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150

-- ============================================================
-- BAT V1 CONSTANTS (Vynx Hub Version - Renamed to Bat V1)
-- ============================================================
local batV1Conn = nil
local batV1HitCD = false
local BAT_V1_SWING_CD = 0.35
local BAT_V1_HIT_DIST = 8
local BAT_V1_CHASE_SPEED = 58
local BAT_V1_VERTICAL_SPEED = 20
local BAT_V1_HEIGHT_OFFSET = 3.7
local BAT_V1_TURN_SPEED = 44
local BAT_V1_LERP_FACTOR = 0.8
local batV1PrevAutoRotate = nil

local BAT_V1_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

local MOB_POS_FILE = "poisonhub_btnpos.json"
local function loadBtnPositions()
    if not(isfile and isfile(MOB_POS_FILE)) then return {} end
    local ok, data = pcall(function() return HS:JSONDecode(readfile(MOB_POS_FILE)) end)
    if ok and type(data) == "table" then return data end
    return {}
end
local function saveBtnPositions()
    if not writefile then return end
    if not mobGuiRef then return end
    local out = {}
    for _, child in ipairs(mobGuiRef:GetDescendants()) do
        if child:IsA("Frame") and child:GetAttribute("BtnKey") then
            local key = child:GetAttribute("BtnKey")
            out[key] = {xs = child.Position.X.Scale, xo = child.Position.X.Offset, ys = child.Position.Y.Scale, yo = child.Position.Y.Offset}
        end
    end
    pcall(function() writefile(MOB_POS_FILE, HS:JSONEncode(out)) end)
end
task.spawn(function() while true do task.wait(3); pcall(saveBtnPositions) end end)

local refreshSpeedModeLabel, saveConfig
local startUnwalk, stopUnwalk, setupMedusa, stopMedusaCounter
local startAntiRagdoll, stopAntiRagdoll, startAutoLeft, stopAutoLeft, startAutoRight, stopAutoRight
local startAutoTP, stopAutoTP, enableAntiLag, disableAntiLag, enableStretchRez, disableStretchRez
local startBatV1, stopBatV1, toggleBatV1, runDrop, runTPFloor, cursedInstaReset
local startAutoSteal, stopAutoSteal, enableAntiKick, disableAntiKick, toggleCarryMode, toggleLaggerMode

local Conns = {autoSteal = nil, antiRag = nil, batCounter = nil, anchor = {}}

local fovConn = nil
local function applyFOV()
    if fovConn then fovConn:Disconnect() end
    fovConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = fovValue end
    end)
end
applyFOV()

-- ============================================================
-- RAGDOLL TIMER
-- ============================================================
local function createRagdollBillboard(duration)
    if not ragdollGuiEnabled then return nil end
    local char = LP.Character
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    if not head then return nil end
    
    local oldBB = head:FindFirstChild("RagdollTimerBB")
    if oldBB then oldBB:Destroy() end
    
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "RagdollTimerBB"
    bb.Size = UDim2.new(0, 80, 0, 40)
    bb.StudsOffset = Vector3.new(0, 6.5, 0)
    bb.AlwaysOnTop = true
    bb.Enabled = true
    
    local bg = Instance.new("Frame", bb)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = BLACK
    bg.BackgroundTransparency = 0.4
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 12)
    
    local stroke = Instance.new("UIStroke", bg)
    stroke.Color = WHITE
    stroke.Thickness = 2
    stroke.Transparency = 0.2
    
    local timerLbl = Instance.new("TextLabel", bb)
    timerLbl.Size = UDim2.new(1, 0, 1, 0)
    timerLbl.Position = UDim2.new(0, 0, 0, 0)
    timerLbl.BackgroundTransparency = 1
    timerLbl.Text = string.format("%.1f", duration)
    timerLbl.TextColor3 = WHITE
    timerLbl.Font = Enum.Font.GothamBlack
    timerLbl.TextSize = 28
    timerLbl.TextStrokeTransparency = 0
    timerLbl.TextStrokeColor3 = BLACK
    timerLbl.TextXAlignment = Enum.TextXAlignment.Center
    timerLbl.TextYAlignment = Enum.TextYAlignment.Center
    
    local startTime = tick()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local remaining = math.max(0, duration - (tick() - startTime))
        if remaining <= 0 then
            conn:Disconnect()
            pcall(function() bb:Destroy() end)
        elseif timerLbl and timerLbl.Parent then
            timerLbl.Text = string.format("%.1f", remaining)
        end
    end)
    
    return bb
end

local activeRagdollBB = nil
local activeMedusaBB = nil

local function onHumanoidStateChanged(old, new)
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local isRag = (new == Enum.HumanoidStateType.Physics or new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand and not activeRagdollBB then
        activeRagdollBB = createRagdollBillboard(2.0)
        task.delay(2.0, function()
            if activeRagdollBB then pcall(function() activeRagdollBB:Destroy() end); activeRagdollBB = nil end
        end)
    end
end

local function onMedusaStateChanged()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand and not activeMedusaBB then
        activeMedusaBB = createRagdollBillboard(4.5)
        task.delay(4.5, function()
            if activeMedusaBB then pcall(function() activeMedusaBB:Destroy() end); activeMedusaBB = nil end
        end)
    end
end

local function setupRagdollTriggers()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.StateChanged:Connect(onHumanoidStateChanged)
        hum:GetPropertyChangedSignal("PlatformStand"):Connect(onMedusaStateChanged)
    end
end

-- ============================================================
-- SPEED INDICATOR
-- ============================================================
local function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    if head:FindFirstChild("SpeedBB") then head.SpeedBB:Destroy() end
    
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "SpeedBB"
    bb.Size = UDim2.new(0, 120, 0, 40)
    bb.StudsOffset = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop = true
    
    local bg = Instance.new("Frame", bb)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = BLACK
    bg.BackgroundTransparency = 0.3
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 16)
    
    local stroke = Instance.new("UIStroke", bg)
    stroke.Color = WHITE
    stroke.Thickness = 1.5
    stroke.Transparency = 0.5
    
    local discordLabel = Instance.new("TextLabel", bg)
    discordLabel.Size = UDim2.new(1, 0, 0.3, 0)
    discordLabel.Position = UDim2.new(0, 0, 0, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "discord.gg/VvNcvgwmXh"
    discordLabel.TextColor3 = WHITE
    discordLabel.Font = Enum.Font.GothamBold
    discordLabel.TextScaled = true
    discordLabel.TextStrokeTransparency = 0
    discordLabel.TextSize = 7
    discordLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    speedLabel = Instance.new("TextLabel", bg)
    speedLabel.Size = UDim2.new(0.45, 0, 0.45, 0)
    speedLabel.Position = UDim2.new(0, 6, 0.3, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "0"
    speedLabel.TextColor3 = WHITE
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextSize = 14
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    speedModeLabel = Instance.new("TextLabel", bg)
    speedModeLabel.Size = UDim2.new(0.45, 0, 0.45, 0)
    speedModeLabel.Position = UDim2.new(0.52, 0, 0.3, 0)
    speedModeLabel.BackgroundTransparency = 1
    speedModeLabel.Text = "Normal"
    speedModeLabel.TextColor3 = WHITE
    speedModeLabel.Font = Enum.Font.GothamBold
    speedModeLabel.TextScaled = true
    speedModeLabel.TextStrokeTransparency = 0
    speedModeLabel.TextSize = 10
    speedModeLabel.TextXAlignment = Enum.TextXAlignment.Left
end

-- ============================================================
-- SPEED SYSTEM
-- ============================================================
local function getActiveMoveSpeed()
    if laggerModeEnabled and carrySpeedActive then return LAGGER_CARRY_SPEED
    elseif laggerModeEnabled then return LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end

local function getAutoPathSpeed()
    if laggerModeEnabled then return LAGGER_SPEED
    else return NS end
end

local _autoSwitchWasSteal = false
local function updateAutoSwitchSpeed()
    if not autoSwitchSpeedEnabled then return end
    local char = LP.Character
    if not char then return end
    local h = char:FindFirstChildOfClass("Humanoid")
    if not h then return end
    local isStealSpeed = h.WalkSpeed < 25
    if isStealSpeed == _autoSwitchWasSteal then return end
    _autoSwitchWasSteal = isStealSpeed
    if isStealSpeed then
        carrySpeedActive = true
    else
        carrySpeedActive = false
    end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
end
task.spawn(function() while true do task.wait(0.1); updateAutoSwitchSpeed() end end)

local function manualJumpBoost(boost)
    if not infJumpEnabled or infJumpMode ~= "manual" then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity = Vector3.new(root.Velocity.X, boost, root.Velocity.Z) end
end

local function startHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect() end
    holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not infJumpEnabled or infJumpMode ~= "hold" then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
        if isJumpHeld and root.Velocity.Y < 35 then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
        if root.Velocity.Y < -120 then
            root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
        end
    end)
end

local function stopHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect(); holdInfJumpConn = nil end
end

UIS.JumpRequest:Connect(function() manualJumpBoost(50) end)
UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
        task.delay(0.12, function()
            if UIS:IsKeyDown(Enum.KeyCode.Space) then manualJumpBoost(50) end
        end)
    end
end)
RunService.Heartbeat:Connect(function()
    if UIS:IsKeyDown(Enum.KeyCode.Space) then manualJumpBoost(50) end
end)

-- ============================================================
-- CURSED RESET
-- ============================================================
pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
            if not cursedResetRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3) == "RE/" then cursedResetRemote = self end
            return oldFire(self, ...)
        end))
    end
end)
task.spawn(function()
    task.wait(2)
    if cursedResetRemote then return end
    for _, desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then cursedResetRemote = desc; break end
    end
end)
cursedInstaReset = function()
    if not cursedResetRemote then
        for _, desc in ipairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then cursedResetRemote = desc; break end
        end
    end
    if not cursedResetRemote then return end
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health <= 0 then pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end); return end
    local resetDetected = false
    local conns = {}
    if humanoid then table.insert(conns, humanoid.Died:Connect(function() resetDetected = true end)) end
    if character then table.insert(conns, character.AncestryChanged:Connect(function(_, parent) if not parent then resetDetected = true end end)) end
    task.spawn(function()
        for _ = 1, 50 do if resetDetected then break end; pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end); task.wait() end
        for _, conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
    end)
end

-- ============================================================
-- KEYBINDS
-- ============================================================
local KB = {
    DropBrainrot = {kb = nil, gp = nil},
    AutoLeft = {kb = nil, gp = nil},
    AutoRight = {kb = nil, gp = nil},
    BatV1 = {kb = nil, gp = nil},
    TPFloor = {kb = nil, gp = nil},
    InstaReset = {kb = nil, gp = nil},
    GuiHide = {kb = nil, gp = nil},
    SpeedToggle = {kb = nil, gp = nil},
    LaggerToggle = {kb = nil, gp = nil},
}

local AP_L1, AP_L2 = Vector3.new(-476.47, -6.28, 92.73), Vector3.new(-483.12, -4.95, 94.81)
local AP_R1, AP_R2 = Vector3.new(-476.16, -6.52, 25.62), Vector3.new(-483.06, -5.03, 25.48)

-- ============================================================
-- STEAL SYSTEM
-- ============================================================
local Steal = {
    AutoStealEnabled = false,
    StealRadius = 60,
    StealDuration = 1.4,
    Data = {}
}
local isStealing, stealStartTime = false, nil
local MEDUSA_COOLDOWN = 25
local batCounterDebounce = false
local scanningActive = false
local scanningConn = nil

local function isMyPlotByName(plotName)
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

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
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
    task.spawn(function()
        for _, fn in ipairs(data.hold) do task.spawn(fn) end
        task.wait(Steal.StealDuration)
        for _, fn in ipairs(data.trigger) do task.spawn(fn) end
        data.ready = true
        isStealing = false
        stealStartTime = nil
    end)
end

local function startScanning()
    if scanningActive then return end
    scanningActive = true
    if scanningConn then scanningConn:Disconnect() end
    scanningConn = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then stopScanning(); return end
        local p = findNearestPrompt()
        if p then stopScanning(); return end
    end)
end

local function stopScanning()
    scanningActive = false
    if scanningConn then scanningConn:Disconnect(); scanningConn = nil end
end

startAutoSteal = function()
    if Conns.autoSteal then return end
    Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled then
            if scanningActive then stopScanning() end
            return
        end
        if isStealing then return end
        local p = findNearestPrompt()
        if p then
            if scanningActive then stopScanning() end
            executeSteal(p)
        else
            if not scanningActive then startScanning() end
        end
    end)
end

stopAutoSteal = function()
    if Conns.autoSteal then Conns.autoSteal:Disconnect(); Conns.autoSteal = nil end
    if scanningActive then stopScanning() end
    isStealing = false
    stealStartTime = nil
end

-- ============================================================
-- MOVEMENT SYSTEM
-- ============================================================
RunService.Stepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

local function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

RunService.RenderStepped:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if isRagdollState(hum) then return end
    
    if not batV1Enabled and not autoLeftEnabled and not autoRightEnabled then
        local md = hum.MoveDirection
        local spd = getActiveMoveSpeed()
        if md.Magnitude > 0 then
            hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
        end
    end
    
    if speedLabel then
        speedLabel.Text = string.format("%.1f", Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude)
    end
    if speedModeLabel then
        if laggerModeEnabled and carrySpeedActive then
            speedModeLabel.Text = "Lagger Carry"
        elseif laggerModeEnabled then
            speedModeLabel.Text = "Lagger"
        elseif carrySpeedActive then
            speedModeLabel.Text = "Carry"
        else
            speedModeLabel.Text = "Normal"
        end
    end
end)

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupSpeedIndicator(char)
    setupRagdollTriggers()
    if medusaCounterEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5); startUnwalk() end
end)
if LP.Character then 
    setupSpeedIndicator(LP.Character)
    setupRagdollTriggers()
end

-- ============================================================
-- AUTO LEFT / RIGHT
-- ============================================================
local alConn, arConn = nil, nil
local alPhase, arPhase = 1, 1

stopAutoLeft = function()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h:Move(Vector3.zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end

stopAutoRight = function()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h:Move(Vector3.zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end

startAutoLeft = function()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero, false); return end
        local spd = getAutoPathSpeed()
        if alPhase == 1 then
            local tgt = Vector3.new(AP_L1.X, hrp.Position.Y, AP_L1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP_L2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                hrp.Velocity = Vector3.new(mv.X * spd, hrp.Velocity.Y, mv.Z * spd)
                return
            end
            local d = AP_L1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            hrp.Velocity = Vector3.new(mv.X * spd, hrp.Velocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = Vector3.new(AP_L2.X, hrp.Position.Y, AP_L2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.Velocity = Vector3.zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                return
            end
            local d = AP_L2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            hrp.Velocity = Vector3.new(mv.X * spd, hrp.Velocity.Y, mv.Z * spd)
        end
    end)
end

startAutoRight = function()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero, false); return end
        local spd = getAutoPathSpeed()
        if arPhase == 1 then
            local tgt = Vector3.new(AP_R1.X, hrp.Position.Y, AP_R1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP_R2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                hrp.Velocity = Vector3.new(mv.X * spd, hrp.Velocity.Y, mv.Z * spd)
                return
            end
            local d = AP_R1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            hrp.Velocity = Vector3.new(mv.X * spd, hrp.Velocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = Vector3.new(AP_R2.X, hrp.Position.Y, AP_R2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.Velocity = Vector3.zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                return
            end
            local d = AP_R2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            hrp.Velocity = Vector3.new(mv.X * spd, hrp.Velocity.Y, mv.Z * spd)
        end
    end)
end

-- ============================================================
-- DROP & TP
-- ============================================================
runDrop = function()
    if dropActive then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    dropActive = true
    local t0 = tick()
    local dc
    dc = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then dc:Disconnect(); dropActive = false; return end
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
                r.AssemblyLinearVelocity = Vector3.zero
            end
            dropActive = false
            return
        end
        r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)
    end)
end

local function doAutoTPDown(force)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if not hum2 then return end
    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not(hrp.Position.Y >= autoTPHeight) then return end
    end
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
    hrp.Velocity = Vector3.zero
end

startAutoTP = function()
    if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
    autoTPConn = task.spawn(function()
        while autoTPEnabled do
            task.wait(0.1)
            pcall(function() doAutoTPDown(false) end)
        end
    end)
end

stopAutoTP = function()
    autoTPEnabled = false
    if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
end

runTPFloor = function()
    pcall(function() doAutoTPDown(true) end)
end

-- ============================================================
-- ANTI RAGDOLL (Vynx Hub Version)
-- ============================================================
startAntiRagdoll = function()
    if Conns.antiRag then return end
    Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not (hum and root) then return end
        local s = hum:GetState()
        local ragdolled = (s == Enum.HumanoidStateType.Physics or s == Enum.HumanoidStateType.Ragdoll or s == Enum.HumanoidStateType.FallingDown)
        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then ragdolled = true end
        if ragdolled then
            pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then d:Destroy() end
            end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then obj.Enabled = true end
            end
            if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

stopAntiRagdoll = function()
    if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag = nil end
end

-- ============================================================
-- UNWALK
-- ============================================================
startUnwalk = function()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end

stopUnwalk = function()
    local c = LP.Character
    if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent = c; unwalkSavedAnimate = nil end
end

-- ============================================================
-- ANTI MEDUSA
-- ============================================================
local function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

local function useMedusaCounter()
    if medusaDebounce then return end
    if MEDUSA_COOLDOWN > (tick() - medusaLastUsed) then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
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
            if medusaResetEnabled then
                cursedInstaReset()
            elseif medusaCounterEnabled then
                useMedusaCounter()
            end
        end
    end)
end

setupMedusa = function(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
    end))
end

stopMedusaCounter = function()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

-- ============================================================
-- BAT COUNTER
-- ============================================================
local BAT_COUNTER_SLAP_LIST = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}

local function findBatForCounter()
    local c = LP.Character
    if not c then return nil end
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
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

startBatCounter = function()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled or batCounterDebounce then return end
        local char = LP.Character
        if not char then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if not hum2 then return end
        local st = hum2:GetState()
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
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

stopBatCounter = function()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter = nil end
    batCounterDebounce = false
end

-- ============================================================
-- FIND BAT FUNCTION
-- ============================================================
local function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end

local function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

-- ============================================================
-- GET CLOSEST TARGET FOR BAT V1
-- ============================================================
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

-- ============================================================
-- BAT V1 (Vynx Hub Version - Renamed to Bat V1)
-- ============================================================
local function _v1FindBat()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs(BAT_V1_SLAP_LIST) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(BAT_V1_SLAP_LIST) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
    end
    return nil
end

local function _v1TrySwing()
    if batV1HitCD then return end
    batV1HitCD = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local bat = _v1FindBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
        end
    end)
    task.delay(BAT_V1_SWING_CD, function() batV1HitCD = false end)
end

local function startBatV1()
    if batV1Conn then batV1Conn:Disconnect() end
    if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
    if autoRightEnabled then autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
    
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if batV1PrevAutoRotate == nil then batV1PrevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end

    batV1Conn = RunService.RenderStepped:Connect(function()
        if not batV1Enabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = _v1FindBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target, targetDist = getClosestTarget()
        if not target then return end

        local myPos = root.Position
        local targetPos = target.Position

        -- No prediction: aim directly at the target's current position
        local direction = targetPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.zero end

        local desiredHeight = targetPos.Y + BAT_V1_HEIGHT_OFFSET
        local yVel = (desiredHeight - myPos.Y) * BAT_V1_VERTICAL_SPEED
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * BAT_V1_CHASE_SPEED, yVel, flatDir.Z * BAT_V1_CHASE_SPEED)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, BAT_V1_LERP_FACTOR)

        -- Turn towards the current target position
        local toTarget = targetPos - myPos
        if toTarget.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, targetPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                Vector3.new(rx * BAT_V1_TURN_SPEED, ry * BAT_V1_TURN_SPEED, rz * BAT_V1_TURN_SPEED)
            )
        end

        if targetDist <= BAT_V1_HIT_DIST then _v1TrySwing() end
    end)
end

local function stopBatV1()
    if batV1Conn then batV1Conn:Disconnect(); batV1Conn = nil end
    batV1HitCD = false
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (batV1PrevAutoRotate == nil) and true or batV1PrevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    batV1PrevAutoRotate = nil
end

toggleBatV1 = function()
    batV1Enabled = not batV1Enabled
    if batV1Enabled then
        if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
        if autoRightEnabled then autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
        startBatV1()
        if batV1SetVisual then batV1SetVisual(true) end
        if mobBtnRefs.batV1 then mobBtnRefs.batV1(true) end
    else
        stopBatV1()
        if batV1SetVisual then batV1SetVisual(false) end
        if mobBtnRefs.batV1 then mobBtnRefs.batV1(false) end
    end
    return batV1Enabled
end

-- ============================================================
-- ANTI LAG / STRETCH REZ
-- ============================================================
local defLightBrightness, defLightClock, defLightAmbient

local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false end
    end)
end

enableAntiLag = function()
    removeAccessoriesEnabled = true
    antiLagEnabled = true
    defLightBrightness = defLightBrightness or Lighting.Brightness
    defLightClock = defLightClock or Lighting.ClockTime
    defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = false end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled then applyAntiLagDerender(obj) end
    end)
end

disableAntiLag = function()
    removeAccessoriesEnabled = false
    antiLagEnabled = false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
    pcall(function()
        if defLightBrightness then Lighting.Brightness = defLightBrightness end
        if defLightClock then Lighting.ClockTime = defLightClock end
        if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end
        Lighting.ExposureCompensation = 0
    end)
end

local STRETCH_NAME = "Poison_Stretch"
enableStretchRez = function()
    stretchRezEnabled = true
    if stretchRezConn then stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    pcall(function()
        RunService:BindToRenderStep(STRETCH_NAME, Enum.RenderPriority.Last.Value - 1, function()
            local cam = workspace.CurrentCamera
            if cam then cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.8, 0, 0, 0, 1) end
        end)
    end)
end

disableStretchRez = function()
    stretchRezEnabled = false
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
end

-- ============================================================
-- ANTI KICK
-- ============================================================
enableAntiKick = function()
    antiKickEnabled = true
end

disableAntiKick = function()
    antiKickEnabled = false
end

-- ============================================================
-- SAVE CONFIG
-- ============================================================
saveConfig = function()
    local function ks(e)
        if e.kb then return {kb = e.kb.Name, gp = e.gp and e.gp.Name}
        elseif e.gp then return {gp = e.gp.Name}
        else return {kb = nil, gp = nil} end
    end
    local cfg = {
        normalSpeed = NS, carrySpeed = CS,
        laggerSpeed = LAGGER_SPEED, laggerCarrySpeed = LAGGER_CARRY_SPEED,
        carrySpeedActive = carrySpeedActive, laggerModeEnabled = laggerModeEnabled,
        dropBrainrotKey = ks(KB.DropBrainrot), autoLeftKey = ks(KB.AutoLeft),
        autoRightKey = ks(KB.AutoRight), batV1Key = ks(KB.BatV1),
        tpFloorKey = ks(KB.TPFloor), instaResetKey = ks(KB.InstaReset),
        guiHideKey = ks(KB.GuiHide), speedToggleKey = ks(KB.SpeedToggle),
        laggerToggleKey = ks(KB.LaggerToggle),
        grabRadius = Steal.StealRadius, stealDuration = Steal.StealDuration,
        antiRagdoll = antiRagdollEnabled, autoStealEnabled = Steal.AutoStealEnabled,
        infiniteJump = infJumpEnabled, infJumpMode = infJumpMode,
        medusaCounter = medusaCounterEnabled, batCounter = batCounterEnabled,
        batV1Enabled = batV1Enabled, autoSwing = autoSwingEnabled,
        unwalkEnabled = unwalkEnabled, antiLag = antiLagEnabled,
        stretchRez = stretchRezEnabled, autoTPEnabled = autoTPEnabled,
        autoTPHeight = autoTPHeight,
        mobileButtonsEnabled = mobileButtonsEnabled, mobileButtonsLocked = mobileButtonsLocked,
        mobileButtonsSize = mobileButtonsSize,
        autoSwitchSpeed = autoSwitchSpeedEnabled, antiKick = antiKickEnabled,
        fovValue = fovValue, perButtonDrag = perButtonDragEnabled,
        skyTheme = currentSkyTheme, medusaReset = medusaResetEnabled,
        ragdollGui = ragdollGuiEnabled, introSoundEnabled = false,
        uiLocked = uiLocked,
    }
    if writefile then pcall(function() writefile("poisonhub.json", HS:JSONEncode(cfg)) end) end
end
task.spawn(function() while task.wait(5) do saveConfig() end end)

-- ============================================================
-- TOGGLE FUNCTIONS
-- ============================================================
refreshSpeedModeLabel = function()
    if modeValLbl then
        if laggerModeEnabled and carrySpeedActive then modeValLbl.Text = "Lagger Carry"
        elseif laggerModeEnabled then modeValLbl.Text = "Lagger"
        elseif carrySpeedActive then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill = laggerModePillRef.pill
        local dot = laggerModePillRef.dot
        local on = laggerModeEnabled
        TweenService:Create(pill, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {BackgroundColor3 = on and WHITE or BLACK}):Play()
        TweenService:Create(dot, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5),
            BackgroundColor3 = on and BLACK or WHITE
        }):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill = carryModePillRef.pill
        local dot = carryModePillRef.dot
        local on = carrySpeedActive
        TweenService:Create(pill, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {BackgroundColor3 = on and WHITE or BLACK}):Play()
        TweenService:Create(dot, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5),
            BackgroundColor3 = on and BLACK or WHITE
        }):Play()
    end
end

-- Lagger Keybind: Lagger Speed → Lagger Carry → Lagger Speed → Lagger Carry (repeating, never turns off)
toggleLaggerMode = function()
    if not laggerModeEnabled and not carrySpeedActive then
        laggerModeEnabled = true
        carrySpeedActive = false
    elseif laggerModeEnabled and not carrySpeedActive then
        carrySpeedActive = true
    elseif laggerModeEnabled and carrySpeedActive then
        carrySpeedActive = false
    end
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
end

toggleCarryMode = function()
    if autoSwitchSpeedEnabled then return end
    laggerModeEnabled = false
    carrySpeedActive = not carrySpeedActive
    refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    saveConfig()
end

-- ============================================================
-- STEAL BAR (FIXED DRAGGING - SAME AS UI PANEL)
-- ============================================================
local function createStealBar()
    for _, n in ipairs({"PoisonStealBar"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(n)
        if old then old:Destroy() end
        local pgui = LP:FindFirstChild("PlayerGui")
        if pgui then
            local o = pgui:FindFirstChild(n)
            if o then o:Destroy() end
        end
    end
    
    local SB_W, SB_H = 280, 28
    
    local stealGui = Instance.new("ScreenGui")
    stealGui.Name = "PoisonStealBar"
    stealGui.ResetOnSpawn = false
    stealGui.IgnoreGuiInset = true
    stealGui.DisplayOrder = 8
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(stealGui) end
    end)
    if not pcall(function() stealGui.Parent = game:GetService("CoreGui") end) then
        stealGui.Parent = LP:WaitForChild("PlayerGui")
    end
    
    local outerFrame = Instance.new("Frame", stealGui)
    outerFrame.Size = UDim2.new(0, SB_W, 0, SB_H)
    outerFrame.Position = UDim2.new(0.5, -SB_W/2, 1, -46)
    outerFrame.BackgroundColor3 = BLACK
    outerFrame.BorderSizePixel = 0
    outerFrame.ZIndex = 18
    outerFrame.ClipsDescendants = true
    Instance.new("UICorner", outerFrame).CornerRadius = UDim.new(1, 0)
    
    local outerStroke = Instance.new("UIStroke", outerFrame)
    outerStroke.Color = WHITE
    outerStroke.Thickness = 1
    outerStroke.Transparency = 0.2
    
    local barFrame = Instance.new("Frame", outerFrame)
    barFrame.Size = UDim2.new(0.46, -8, 1, -8)
    barFrame.Position = UDim2.new(0, 4, 0, 4)
    barFrame.BackgroundColor3 = BLACK
    barFrame.BorderSizePixel = 0
    barFrame.ZIndex = 19
    barFrame.ClipsDescendants = true
    Instance.new("UICorner", barFrame).CornerRadius = UDim.new(1, 0)
    
    local fillLine = Instance.new("Frame", barFrame)
    fillLine.Size = UDim2.new(0, 0, 1, 0)
    fillLine.BackgroundColor3 = WHITE
    fillLine.BorderSizePixel = 0
    fillLine.ZIndex = 20
    Instance.new("UICorner", fillLine).CornerRadius = UDim.new(1, 0)
    
    local stealLabel = Instance.new("TextLabel", barFrame)
    stealLabel.Size = UDim2.new(0, 42, 1, 0)
    stealLabel.Position = UDim2.new(0, 6, 0, 0)
    stealLabel.BackgroundTransparency = 1
    stealLabel.Text = "STEAL"
    stealLabel.TextColor3 = WHITE
    stealLabel.Font = Enum.Font.GothamBlack
    stealLabel.TextSize = 9
    stealLabel.TextXAlignment = Enum.TextXAlignment.Left
    stealLabel.ZIndex = 25
    
    local pctLabel = Instance.new("TextLabel", barFrame)
    pctLabel.Size = UDim2.new(0, 35, 1, 0)
    pctLabel.Position = UDim2.new(1, -38, 0, 0)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Text = "0%"
    pctLabel.TextColor3 = WHITE
    pctLabel.Font = Enum.Font.GothamBlack
    pctLabel.TextSize = 8
    pctLabel.TextXAlignment = Enum.TextXAlignment.Right
    pctLabel.ZIndex = 25
    
    local sepLine = Instance.new("Frame", outerFrame)
    sepLine.Size = UDim2.new(0, 1, 0, SB_H * 0.65)
    sepLine.Position = UDim2.new(0.49, 0, 0.5, -(SB_H * 0.65)/2)
    sepLine.BackgroundColor3 = WHITE
    sepLine.BackgroundTransparency = 0.5
    sepLine.BorderSizePixel = 0
    sepLine.ZIndex = 22
    
    local fpsLabel = Instance.new("TextLabel", outerFrame)
    fpsLabel.Size = UDim2.new(0, 50, 1, -8)
    fpsLabel.Position = UDim2.new(0.52, 0, 0, 4)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: 0"
    fpsLabel.TextColor3 = WHITE
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.TextSize = 7
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.ZIndex = 23
    
    local pingLabel = Instance.new("TextLabel", outerFrame)
    pingLabel.Size = UDim2.new(0, 55, 1, -8)
    pingLabel.Position = UDim2.new(0.72, 0, 0, 4)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "PING: 0ms"
    pingLabel.TextColor3 = WHITE
    pingLabel.Font = Enum.Font.GothamBold
    pingLabel.TextSize = 7
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left
    pingLabel.ZIndex = 23
    
    local dotContainer = Instance.new("Frame", outerFrame)
    dotContainer.Size = UDim2.new(0, 16, 0, 16)
    dotContainer.Position = UDim2.new(1, -20, 0.5, -8)
    dotContainer.BackgroundTransparency = 1
    dotContainer.ZIndex = 24
    
    local ring = Instance.new("Frame", dotContainer)
    ring.Size = UDim2.new(1, 0, 1, 0)
    ring.BackgroundTransparency = 0.9    ring.BorderSizePixel = 2
    ring.BorderColor3 = WHITE
    ring.ZIndex = 25
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame", dotContainer)
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(0.5, -5, 0.5, -5)
    dot.BackgroundColor3 = WHITE
    dot.BorderSizePixel = 0
    dot.ZIndex = 26
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    task.spawn(function()
        local frames = 0
        local t0 = tick()
        while fpsLabel and fpsLabel.Parent do
            frames = frames + 1
            local now = tick()
            if now - t0 >= 0.5 then
                local fps = math.floor(frames / (now - t0) + 0.5)
                fpsLabel.Text = "FPS: " .. tostring(fps)
                frames = 0
                t0 = now
            end
            task.wait()
        end
    end)
    
    task.spawn(function()
        while pingLabel and pingLabel.Parent do
            pcall(function()
                local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
                pingLabel.Text = "PING: " .. tostring(ping) .. "ms"
            end)
            task.wait(0.5)
        end
    end)
    
    task.spawn(function()
        while fillLine and fillLine.Parent do
            local now = tick()
            local hasTarget = false
            if Steal.AutoStealEnabled then
                if not isStealing then
                    local p = findNearestPrompt()
                    if p then hasTarget = true end
                end
            end
            
            if hasTarget or isStealing then
                dot.BackgroundColor3 = GREEN
                ring.BorderColor3 = GREEN
                ring.BackgroundTransparency = 0.5
            else
                dot.BackgroundColor3 = RED
                ring.BorderColor3 = RED
                ring.BackgroundTransparency = 0.5
            end
            
            if isStealing and stealStartTime then
                local pct = math.clamp((now - stealStartTime) / Steal.StealDuration, 0, 1)
                fillLine.Size = UDim2.new(pct, 0, 1, 0)
                pctLabel.Text = math.floor(pct * 100) .. "%"
                fillLine.BackgroundColor3 = (pct >= 0.7) and GREEN or WHITE
            else
                fillLine.Size = UDim2.new(0, 0, 1, 0)
                pctLabel.Text = "0%"
                fillLine.BackgroundColor3 = WHITE
            end
            task.wait(0.016)
        end
    end)
    
    -- ============================================================
    -- STEAL BAR DRAGGING (SAME LOGIC AS UI PANEL)
    -- ============================================================
    local isDraggingStealBar = false
    local dragStartSteal = nil
    local startPosSteal = nil
    
    outerFrame.InputBegan:Connect(function(input)
        if uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingStealBar = true
            dragStartSteal = input.Position
            startPosSteal = outerFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.InputState.End then
                    isDraggingStealBar = false
                end
            end)
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if isDraggingStealBar and not uiLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartSteal
            outerFrame.Position = UDim2.new(
                startPosSteal.X.Scale, 
                startPosSteal.X.Offset + delta.X, 
                startPosSteal.Y.Scale, 
                startPosSteal.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============================================================
-- MOBILE BUTTONS (Updated with Bat V1)
-- ============================================================
local function destroyMobileButtons()
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end); mobGuiRef = nil end
    for _, n in ipairs({"PoisonMobileButtons"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(n)
        if old then old:Destroy() end
        local pgui = LP:FindFirstChild("PlayerGui")
        if pgui then
            local o = pgui:FindFirstChild(n)
            if o then o:Destroy() end
        end
    end
    mobBtnRefs = {}
end

local function buildMobileButtons()
    destroyMobileButtons()
    if not mobileButtonsEnabled then return end
    local savedPositions = loadBtnPositions()
    
    local BTN_SIZE = math.floor(mobileButtonsSize * 0.6)
    local BTN_GAP = 10
    local CORNER_R = 20
    local fontSize = math.max(9, math.floor(mobileButtonsSize * 0.13))
    
    local buttons = {
        {key = "autoLeft",   label = "AUTO\nLEFT",    toggle = true,  exclusive = true},
        {key = "autoRight",  label = "AUTO\nRIGHT",   toggle = true,  exclusive = true},
        {key = "batV1",      label = "BAT\nV1",       toggle = true,  exclusive = true},
        {key = "drop",       label = "DROP",          toggle = false, exclusive = false},
        {key = "carrySpeed", label = "CARRY",         toggle = true,  exclusive = false},
        {key = "lagger",     label = "LAGGER",        toggle = true,  exclusive = false},
        {key = "tpDown",     label = "TP\nDOWN",      toggle = false, exclusive = false},
        {key = "instaReset", label = "RESET",         toggle = false, exclusive = false},
    }
    
    local COLS = 3
    local totalW = (COLS * (BTN_SIZE + BTN_GAP)) - BTN_GAP
    local totalH = (math.ceil(#buttons / COLS) * (BTN_SIZE + BTN_GAP)) - BTN_GAP
    
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
    local defX = vp.X - totalW - 12
    local defY = math.max(12, vp.Y / 2 - totalH / 2)
    
    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "PoisonMobileButtons"
    mobGui.ResetOnSpawn = false
    mobGui.DisplayOrder = 15
    mobGui.IgnoreGuiInset = true
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(mobGui) end
    end)
    if not pcall(function() mobGui.Parent = game:GetService("CoreGui") end) then
        mobGui.Parent = LP:WaitForChild("PlayerGui")
    end
    mobGuiRef = mobGui
    
    for i, def in ipairs(buttons) do
        local col = (i - 1) % COLS
        local rowN = math.floor((i - 1) / COLS)
        local localX = col * (BTN_SIZE + BTN_GAP)
        local localY = rowN * (BTN_SIZE + BTN_GAP)
        
        local sp = savedPositions[def.key]
        local initXO = sp and sp.xo or (defX + localX)
        local initYO = sp and sp.yo or (defY + localY)
        
        local frame = Instance.new("Frame", mobGui)
        frame.Name = "MobBtn_" .. def.key
        frame.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
        frame.Position = UDim2.new(0, initXO, 0, initYO)
        frame.BackgroundColor3 = BLACK
        frame.BackgroundTransparency = 0
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.ZIndex = 102
        frame:SetAttribute("BtnKey", def.key)
        frame.ClipsDescendants = true
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, CORNER_R)
        
        local shadow = Instance.new("Frame", frame)
        shadow.Size = UDim2.new(1, 0, 1, 0)
        shadow.BackgroundColor3 = BLACK
        shadow.BackgroundTransparency = 0.3
        shadow.BorderSizePixel = 0
        shadow.ZIndex = 103
        Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, CORNER_R)
        
        local fstroke = Instance.new("UIStroke", frame)
        fstroke.Color = WHITE
        fstroke.Thickness = 2
        fstroke.Transparency = 0.2
        fstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        local highlight = Instance.new("Frame", frame)
        highlight.Size = UDim2.new(1, 0, 1, 0)
        highlight.BackgroundColor3 = WHITE
        highlight.BackgroundTransparency = 1
        highlight.BorderSizePixel = 0
        highlight.ZIndex = 104
        Instance.new("UICorner", highlight).CornerRadius = UDim.new(0, CORNER_R)
        
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = def.label
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = fontSize
        btn.LineHeight = 1.2
        btn.TextWrapped = true
        btn.AutoButtonColor = false
        btn.ZIndex = 105
        
        local isOn = false
        
        local function setOn(v)
            isOn = v
            frame:SetAttribute("BtnIsOn", v)
            if v then
                TweenService:Create(highlight, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
                TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = BLACK}):Play()
                TweenService:Create(fstroke, TweenInfo.new(0.15), {Transparency = 0, Thickness = 3}):Play()
                TweenService:Create(shadow, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
            else
                TweenService:Create(highlight, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
                TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = WHITE}):Play()
                TweenService:Create(fstroke, TweenInfo.new(0.15), {Transparency = 0.2, Thickness = 2}):Play()
                TweenService:Create(shadow, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
            end
        end
        
        mobBtnRefs[def.key] = setOn
        
        local function flash()
            TweenService:Create(frame, TweenInfo.new(0.06), {BackgroundColor3 = WHITE}):Play()
            task.delay(0.18, function()
                if not isOn then
                    TweenService:Create(frame, TweenInfo.new(0.1), {BackgroundColor3 = BLACK}):Play()
                end
            end)
        end
        
        local dragStart2, dragStartPos2, dragMoved, dragDown = nil, nil, false, false
        if perButtonDragEnabled then
            btn.InputBegan:Connect(function(input)
                if uiLocked then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragMoved = false
                    dragDown = true
                    dragStart2 = input.Position
                    dragStartPos2 = frame.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.InputState.End then
                            dragDown = false
                            if dragMoved then pcall(saveBtnPositions) end
                        end
                    end)
                end
            end)
            btn.InputChanged:Connect(function(input)
                if dragDown and not uiLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart2
                    if delta.Magnitude > 4 then dragMoved = true end
                    if dragMoved then
                        frame.Position = UDim2.new(dragStartPos2.X.Scale, dragStartPos2.X.Offset + delta.X, dragStartPos2.Y.Scale, dragStartPos2.Y.Offset + delta.Y)
                    end
                end
            end)
        end
        
        btn.Activated:Connect(function()
            if dragMoved then return end
            
            if def.key == "tpDown" then runTPFloor(); flash(); return end
            if def.key == "drop" then runDrop(); flash(); return end
            if def.key == "instaReset" then cursedInstaReset(); flash(); return end
            
            if def.exclusive then
                local alreadyOn = (def.key == "autoLeft" and autoLeftEnabled) or
                                  (def.key == "autoRight" and autoRightEnabled) or
                                  (def.key == "batV1" and batV1Enabled)
                if alreadyOn then
                    if def.key == "autoLeft" then
                        autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; setOn(false)
                    elseif def.key == "autoRight" then
                        autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; setOn(false)
                    elseif def.key == "batV1" then
                        toggleBatV1(); setOn(false)
                    end
                    return
                end
                if autoLeftEnabled and def.key ~= "autoLeft" then
                    autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end
                    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                end
                if autoRightEnabled and def.key ~= "autoRight" then
                    autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end
                    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                end
                if batV1Enabled and def.key ~= "batV1" then
                    toggleBatV1(); if batV1SetVisual then batV1SetVisual(false) end
                    if mobBtnRefs.batV1 then mobBtnRefs.batV1(false) end
                end
                if def.key == "autoLeft" then
                    autoLeftEnabled = true; startAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(true) end; setOn(true)
                elseif def.key == "autoRight" then
                    autoRightEnabled = true; startAutoRight(); if autoRightSetVisual then autoRightSetVisual(true) end; setOn(true)
                elseif def.key == "batV1" then
                    toggleBatV1(); if batV1SetVisual then batV1SetVisual(true) end; setOn(true)
                end
                return
            end
            
            if def.key == "carrySpeed" then
                if autoSwitchSpeedEnabled then return end
                toggleCarryMode()
                setOn(carrySpeedActive)
                if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
                saveConfig()
                return
            end
            
            if def.key == "lagger" then
                if not laggerModeEnabled and not carrySpeedActive then
                    laggerModeEnabled = true
                    carrySpeedActive = false
                elseif laggerModeEnabled and not carrySpeedActive then
                    carrySpeedActive = true
                elseif laggerModeEnabled and carrySpeedActive then
                    laggerModeEnabled = false
                    carrySpeedActive = false
                end
                refreshSpeedModeLabel()
                setOn(laggerModeEnabled)
                if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
                saveConfig()
                return
            end
        end)
    end
    
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    if mobBtnRefs.batV1 then mobBtnRefs.batV1(batV1Enabled) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
end

-- ============================================================
-- MAIN GUI (FIXED DRAGGING AND HIDE/SHOW)
-- ============================================================
local modeValLbl = nil
local normalBox, carryBox, laggerBox, laggerCarryBox, radInput, autoTPHeightBox = nil, nil, nil, nil, nil, nil
local setAntiRagVisual, setBatCounterVisual, setMedusaVisual, setMedusaResetVisual = nil, nil, nil, nil
local setUnwalkVisual, setAutoSwingVisual = nil, nil
local setInstaGrab = nil
local setInfJumpVisual = nil
local setLockVisual, setMobVisual = nil, nil
local setAntiLagVisual = nil
local mainFrame = nil
local miniBtn = nil

local function buildGui()
    createStealBar()
    
    for _, n in ipairs({"PoisonHub"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(n)
        if old then old:Destroy() end
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then
            local o = pg:FindFirstChild(n)
            if o then o:Destroy() end
        end
    end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "PoisonHub"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
    end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end
    
    local W, H = 320, 400
    
    -- MAIN FRAME
    mainFrame = Instance.new("Frame", gui)
    mainFrame.Name = "Main"
    mainFrame.Size = UDim2.new(0, W, 0, H)
    mainFrame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
    mainFrame.BackgroundColor3 = BLACK
    mainFrame.BackgroundTransparency = 1
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.ZIndex = 5
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)
    
    local bgImage = Instance.new("ImageLabel", mainFrame)
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://130968185699787"
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    local bgCorner = Instance.new("UICorner", bgImage)
    bgCorner.CornerRadius = UDim.new(0, 16)
    
    local mfStroke = Instance.new("UIStroke", mainFrame)
    mfStroke.Color = WHITE
    mfStroke.Thickness = 2
    mfStroke.Transparency = 0.6
    mfStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local outlineAnimConn = nil
    local phase = 0
    local flashCount = 0
    local moveCount = 0
    local flash2Count = 0
    local t = 0
    
    outlineAnimConn = RunService.Heartbeat:Connect(function(dt)
        t = t + dt
        if phase == 0 then
            local speed = 6
            local val = 0.4 + 0.5 * (0.5 + 0.5 * math.sin(t * speed * 2 * math.pi))
            mfStroke.Transparency = 1 - val
            flashCount = flashCount + dt * speed
            if flashCount >= 5 then
                phase = 1
                flashCount = 0
                moveCount = 0
                t = 0
            end
        elseif phase == 1 then
            local speed = 1.5
            local phaseShift = t * speed
            local val = 0.4 + 0.5 * (0.5 + 0.5 * math.sin(phaseShift * 2 * math.pi))
            mfStroke.Transparency = 1 - val
            moveCount = moveCount + dt * speed
            if moveCount >= 5 then
                phase = 2
                moveCount = 0
                flash2Count = 0
                t = 0
            end
        elseif phase == 2 then
            local speed = 6
            local val = 0.4 + 0.5 * (0.5 + 0.5 * math.sin(t * speed * 2 * math.pi))
            mfStroke.Transparency = 1 - val
            flash2Count = flash2Count + dt * speed
            if flash2Count >= 5 then
                phase = 0
                flash2Count = 0
                flashCount = 0
                t = 0
            end
        end
    end)
    
    mainFrame.AncestryChanged:Connect(function()
        if not mainFrame.Parent then
            if outlineAnimConn then outlineAnimConn:Disconnect(); outlineAnimConn = nil end
        end
    end)
    
    -- ============================================================
    -- UI PANEL DRAGGING (FIXED FOR PC)
    -- ============================================================
    local isDraggingUI = false
    local dragStartUI = nil
    local startPosUI = nil
    
    local function startDrag(input)
        if uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingUI = true
            dragStartUI = input.Position
            startPosUI = mainFrame.Position
        end
    end
    
    local function updateDrag(input)
        if isDraggingUI and not uiLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartUI
            mainFrame.Position = UDim2.new(
                startPosUI.X.Scale, 
                startPosUI.X.Offset + delta.X, 
                startPosUI.Y.Scale, 
                startPosUI.Y.Offset + delta.Y
            )
        end
    end
    
    local function endDrag()
        isDraggingUI = false
    end
    
    -- Header (drag handle)
    local headerH = 34
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, headerH)
    header.BackgroundColor3 = BLACK
    header.BackgroundTransparency = 0.5
    header.BorderSizePixel = 0
    header.ZIndex = 6
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)
    
    header.InputBegan:Connect(startDrag)
    header.InputChanged:Connect(updateDrag)
    header.InputEnded:Connect(endDrag)
    
    local titleLbl = Instance.new("TextLabel", header)
    titleLbl.Size = UDim2.new(1, -70, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "POISON HUB"
    titleLbl.TextColor3 = WHITE
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 8
    
    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -26, 0.5, -11)
    closeBtn.BackgroundColor3 = WHITE
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "−"
    closeBtn.TextColor3 = BLACK
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 16
    closeBtn.ZIndex = 10
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    
    -- MINI BUTTON (Shows when UI is hidden)
    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Size = UDim2.new(0, 100, 0, 28)
    miniBtn.Position = UDim2.new(0, 12, 0, 12)
    miniBtn.BackgroundColor3 = BLACK
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = "POISON HUB"
    miniBtn.TextColor3 = WHITE
    miniBtn.Font = Enum.Font.GothamBlack
    miniBtn.TextSize = 9
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 10)
    local miniStroke = Instance.new("UIStroke", miniBtn)
    miniStroke.Color = WHITE
    miniStroke.Thickness = 1.5
    miniStroke.Transparency = 0.3
    
    -- Mini button dragging
    local isDraggingMini = false
    local dragStartMini = nil
    local startPosMini = nil
    
    miniBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingMini = true
            dragStartMini = input.Position
            startPosMini = miniBtn.Position
        end
    end)
    
    miniBtn.InputChanged:Connect(function(input)
        if isDraggingMini and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartMini
            miniBtn.Position = UDim2.new(
                startPosMini.X.Scale, 
                startPosMini.X.Offset + delta.X, 
                startPosMini.Y.Scale, 
                startPosMini.Y.Offset + delta.Y
            )
        end
    end)
    
    miniBtn.InputEnded:Connect(function()
        isDraggingMini = false
    end)
    
    -- ============================================================
    -- HIDE/SHOW FUNCTIONALITY (FIXED)
    -- ============================================================
    local isHidden = false
    
    closeBtn.MouseButton1Click:Connect(function()
        isHidden = true
        mainFrame.Visible = false
        miniBtn.Visible = true
    end)
    
    miniBtn.MouseButton1Click:Connect(function()
        isHidden = false
        miniBtn.Visible = false
        mainFrame.Visible = true
    end)
    
    -- ============================================================
    -- TAB BAR
    -- ============================================================
    local tabBarH = 24
    local tabBar = Instance.new("Frame", mainFrame)
    tabBar.Size = UDim2.new(1, 0, 0, tabBarH)
    tabBar.Position = UDim2.new(0, 0, 0, headerH)
    tabBar.BackgroundColor3 = BLACK
    tabBar.BackgroundTransparency = 0.5
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 7
    tabBar.ClipsDescendants = true

    local function createTabButton(text, xPos, width)
        width = width or 0.22
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(width, 0, 1, 0)
        btn.Position = UDim2.new(xPos, 0, 0, 0)
        btn.BackgroundColor3 = BLACK
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.AutoButtonColor = false
        btn.ZIndex = 8

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = WHITE
        stroke.Thickness = 2
        stroke.Transparency = 0.3
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        btn.MouseEnter:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.05}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.3}):Play()
        end)

        return btn
    end

    local gap = 0.04
    local w = 0.22
    local tabBtnSpeed   = createTabButton("SPEED", 0, w)
    local tabBtnMain    = createTabButton("MAIN", w + gap, w)
    local tabBtnMisc    = createTabButton("MISC", 2*(w + gap), w)
    local tabBtnSettings= createTabButton("SETTINGS", 3*(w + gap), w)
    
    -- ============================================================
    -- SCROLLING FRAME
    -- ============================================================
    local bodyY = headerH + tabBarH + 2
    local bodyH = H - bodyY - 2
    
    local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
    scrollFrame.Size = UDim2.new(1, -4, 0, bodyH)
    scrollFrame.Position = UDim2.new(0, 2, 0, bodyY)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = WHITE
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame.ZIndex = 3
    scrollFrame.ClipsDescendants = true
    
    local speedFrame = Instance.new("Frame", scrollFrame)
    speedFrame.Size = UDim2.new(1, 0, 0, 0)
    speedFrame.BackgroundTransparency = 1
    speedFrame.AutomaticSize = Enum.AutomaticSize.Y
    speedFrame.Visible = true
    speedFrame.ZIndex = 4
    
    local mainFrame2 = Instance.new("Frame", scrollFrame)
    mainFrame2.Size = UDim2.new(1, 0, 0, 0)
    mainFrame2.BackgroundTransparency = 1
    mainFrame2.AutomaticSize = Enum.AutomaticSize.Y
    mainFrame2.Visible = false
    mainFrame2.ZIndex = 4
    
    local miscFrame = Instance.new("Frame", scrollFrame)
    miscFrame.Size = UDim2.new(1, 0, 0, 0)
    miscFrame.BackgroundTransparency = 1
    miscFrame.AutomaticSize = Enum.AutomaticSize.Y
    miscFrame.Visible = false
    miscFrame.ZIndex = 4

    local settingsFrame = Instance.new("Frame", scrollFrame)
    settingsFrame.Size = UDim2.new(1, 0, 0, 0)
    settingsFrame.BackgroundTransparency = 1
    settingsFrame.AutomaticSize = Enum.AutomaticSize.Y
    settingsFrame.Visible = false
    settingsFrame.ZIndex = 4
    
    -- ============================================================
    -- ROW HELPERS
    -- ============================================================
    local function mkSectionLbl(parent, txt)
        local spacer = Instance.new("Frame", parent)
        spacer.Size = UDim2.new(1, 0, 0, 3)
        spacer.BackgroundTransparency = 1
        spacer.LayoutOrder = #parent:GetChildren()
        
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1, 0, 0, 14)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #parent:GetChildren()
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(1, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = WHITE
        l.Font = Enum.Font.GothamBold
        l.TextSize = 7
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.ZIndex = 9
        
        local div = Instance.new("Frame", parent)
        div.Size = UDim2.new(1, 0, 0, 1)
        div.BackgroundColor3 = WHITE
        div.BackgroundTransparency = 0.3
        div.BorderSizePixel = 0
        div.LayoutOrder = #parent:GetChildren()
        local sp2 = Instance.new("Frame", parent)
        sp2.Size = UDim2.new(1, 0, 0, 1)
        sp2.BackgroundTransparency = 1
        sp2.LayoutOrder = #parent:GetChildren()
    end
    
    local ROW_HEIGHT = 38
    
    local function mkRow(parent, h)
        local f = Instance.new("Frame", parent)
        f.Size = UDim2.new(1, 0, 0, h or ROW_HEIGHT)
        f.BackgroundColor3 = BLACK
        f.BackgroundTransparency = 0.2
        f.BorderSizePixel = 0
        f.ZIndex = 8
        f.LayoutOrder = #parent:GetChildren()
        
        local stroke = Instance.new("UIStroke", f)
        stroke.Color = WHITE
        stroke.Thickness = 1
        stroke.Transparency = 0.3
        
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        
        f.MouseEnter:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.1}):Play()
        end)
        f.MouseLeave:Connect(function()
            TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.3}):Play()
        end)
        
        local spacer = Instance.new("Frame", parent)
        spacer.Size = UDim2.new(1, 0, 0, 1)
        spacer.BackgroundTransparency = 1
        spacer.LayoutOrder = #parent:GetChildren() + 1
        return f
    end
    
    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.6, 0, 1, 0)
        l.Position = UDim2.new(0, 6, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = WHITE
        l.Font = Enum.Font.GothamBold
        l.TextSize = 8
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.ZIndex = 9
        return l
    end
    
    local function mkPill(row)
        local pill = Instance.new("Frame", row)
        pill.Size = UDim2.new(0, 28, 0, 15)
        pill.Position = UDim2.new(1, -36, 0.5, -7.5)
        pill.BackgroundColor3 = BLACK
        pill.BackgroundTransparency = 0.2
        pill.BorderSizePixel = 0
        pill.ZIndex = 9
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        
        local pStroke = Instance.new("UIStroke", pill)
        pStroke.Color = WHITE
        pStroke.Thickness = 1
        pStroke.Transparency = 0.3
        
        local dot = Instance.new("Frame", pill)
        dot.Size = UDim2.new(0, 9, 0, 9)
        dot.Position = UDim2.new(0, 3, 0.5, -4.5)
        dot.BackgroundColor3 = WHITE
        dot.BorderSizePixel = 0
        dot.ZIndex = 10
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        return pill, dot
    end
    
    local function animPill(pill, dot, on)
        TweenService:Create(pill, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = on and WHITE or BLACK}):Play()
        TweenService:Create(dot, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(1, -12, 0.5, -4.5) or UDim2.new(0, 3, 0.5, -4.5),
            BackgroundColor3 = on and BLACK or WHITE
        }):Play()
    end
    
    local function mkToggle(parent, txt, cb)
        local row = mkRow(parent, ROW_HEIGHT)
        mkLabel(row, txt)
        local pill, dot = mkPill(row)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = 11
        clk.Activated:Connect(function()
            on = not on
            sv(on)
            cb(on)
        end)
        return sv
    end
    
    local function mkBoxRow(parent, txt, default, cb)
        local row = mkRow(parent, ROW_HEIGHT)
        mkLabel(row, txt)
        local tb = Instance.new("TextBox", row)
        tb.Size = UDim2.new(0, 44, 0, 20)
        tb.Position = UDim2.new(1, -50, 0.5, -10)
        tb.BackgroundColor3 = BLACK
        tb.BackgroundTransparency = 0.2
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = WHITE
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 8
        tb.ClearTextOnFocus = false
        tb.ZIndex = 9
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
        
        local tbStroke = Instance.new("UIStroke", tb)
        tbStroke.Color = WHITE
        tbStroke.Thickness = 1
        tbStroke.Transparency = 0.3
        
        tb.FocusLost:Connect(function()
            if cb then
                local n = tonumber(tb.Text)
                if n then cb(n) else tb.Text = tostring(default) end
            end
        end)
        return tb
    end
    
    local GAMEPAD_KEYS = {[Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true, [Enum.KeyCode.ButtonX] = true,
        [Enum.KeyCode.ButtonY] = true, [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
        [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true, [Enum.KeyCode.ButtonL3] = true,
        [Enum.KeyCode.ButtonR3] = true, [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
        [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true, [Enum.KeyCode.DPadLeft] = true,
        [Enum.KeyCode.DPadRight] = true}
    
    local function isGamepadInput(inp)
        return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
    end
    
    local function isBindableInput(inp)
        if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
        if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
        return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
    end
    
    local function kbMatch(entry, kc)
        return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
    end
    
    -- ============================================================
    -- UPDATED mkKBButton WITH X BUTTON TO CLEAR KEYBIND
    -- ============================================================
    local function mkKBButton(row, kbEntry, cb)
        local function getLabel()
            if kbEntry.kb then return kbEntry.kb.Name
            elseif kbEntry.gp then return kbEntry.gp.Name
            else return "Press" end
        end
        
        -- Container frame for the button + X button
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 62, 0, 20)
        container.Position = UDim2.new(1, -68, 0.5, -10)
        container.BackgroundTransparency = 1
        container.ZIndex = 9
        
        local btn = Instance.new("TextButton", container)
        btn.Size = UDim2.new(0, 44, 0, 20)
        btn.Position = UDim2.new(0, 0, 0, 0)
        btn.BackgroundColor3 = BLACK
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 7
        btn.AutoButtonColor = false
        btn.ZIndex = 9
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = WHITE
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.3
        
        -- X button to clear keybind
        local clearBtn = Instance.new("TextButton", container)
        clearBtn.Size = UDim2.new(0, 16, 0, 16)
        clearBtn.Position = UDim2.new(1, -18, 0.5, -8)
        clearBtn.BackgroundColor3 = BLACK
        clearBtn.BackgroundTransparency = 0.2
        clearBtn.BorderSizePixel = 0
        clearBtn.Text = "X"
        clearBtn.TextColor3 = Color3.fromRGB(0, 255, 1)
        clearBtn.Font = Enum.Font.GothamBlack
        clearBtn.TextSize = 10
        clearBtn.AutoButtonColor = false
        clearBtn.ZIndex = 10
        Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 4)
        
        local clearStroke = Instance.new("UIStroke", clearBtn)
        clearStroke.Color = Color3.fromRGB(255, 100, 100)
        clearStroke.Thickness = 1
        clearStroke.Transparency = 0.3
        
        clearBtn.MouseEnter:Connect(function()
            TweenService:Create(clearStroke, TweenInfo.new(0.12), {Transparency = 0.05}):Play()
            TweenService:Create(clearBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
        end)
        clearBtn.MouseLeave:Connect(function()
            TweenService:Create(clearStroke, TweenInfo.new(0.12), {Transparency = 0.3}):Play()
            TweenService:Create(clearBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.2}):Play()
        end)
        
        -- Clear keybind
        clearBtn.Activated:Connect(function()
            if _anyKeyListening then return end
            kbEntry.kb = nil
            kbEntry.gp = nil
            btn.Text = "Press"
            if cb then cb(nil, false) end
        end)
        
        local li = false
        local lc
        local pv = btn.Text
        local ls = 0
        
        btn.Activated:Connect(function()
            if li then
                li = false
                _anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end
                btn.Text = pv
                btn.TextColor3 = WHITE
                return
            end
            pv = btn.Text
            li = true
            _anyKeyListening = true
            ls = tick()
            btn.Text = "..."
            btn.TextColor3 = WHITE
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then
                    li = false
                    _anyKeyListening = false
                    if lc then lc:Disconnect(); lc = nil end
                    btn.Text = pv
                    btn.TextColor3 = WHITE
                    return
                end
                local isGp = isGamepadInput(inp)
                if isGp and not(tick() - ls >= 0.15) then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name
                pv = inp.KeyCode.Name
                li = false
                _anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end
                btn.TextColor3 = WHITE
                if isGp then
                    kbEntry.gp = inp.KeyCode
                    kbEntry.kb = nil
                else
                    kbEntry.kb = inp.KeyCode
                    kbEntry.gp = nil
                end
                if cb then cb(inp.KeyCode, isGp) end
            end)
        end)
        return btn
    end
    
    local function mkToggleKB(parent, txt, kbEntry, onToggle, onKB)
        local row = mkRow(parent, ROW_HEIGHT)
        mkLabel(row, txt)
        mkKBButton(row, kbEntry, function(k, isGp)
            if onKB then onKB(k, isGp) end
        end)
        local kbb = row:FindFirstChildOfClass("TextButton")
        if kbb then
            kbb.Position = UDim2.new(1, -98, 0.5, -10)
            kbb.Size = UDim2.new(0, 44, 0, 20)
        end
        local pill2, dot2 = mkPill(row)
        local on = false
        local function sv(s) on = s; animPill(pill2, dot2, s) end
        local clk = Instance.new("TextButton", pill2)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = 11
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            on = not on
            sv(on)
            if onToggle then onToggle(on) end
        end)
        return sv
    end
    
    local function mkKBRow(parent, txt, kbEntry, onKB)
        local row = mkRow(parent, ROW_HEIGHT)
        mkLabel(row, txt)
        mkKBButton(row, kbEntry, function(k, isGp)
            if onKB then onKB(k, isGp) end
        end)
        return row
    end
    
    local function mkActionRow(parent, txt, onActivate)
        local row = mkRow(parent, ROW_HEIGHT)
        mkLabel(row, txt)
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 44, 0, 22)
        btn.Position = UDim2.new(1, -50, 0.5, -11)
        btn.BackgroundColor3 = WHITE
        btn.BorderSizePixel = 0
        btn.Text = "▶"
        btn.TextColor3 = BLACK
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 9
        btn.AutoButtonColor = false
        btn.ZIndex = 9
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        btn.Activated:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.06), {BackgroundColor3 = BLACK}):Play()
            task.delay(0.12, function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = WHITE}):Play()
            end)
            if onActivate then onActivate() end
        end)
        return row, btn
    end
    
    -- ============================================================
    -- BUILD SPEED TAB
    -- ============================================================
    local function buildSpeedTab(parent)
        mkSectionLbl(parent, "Speed")
        normalBox = mkBoxRow(parent, "Normal Speed", NS, function(v) if v > 0 and v <= 500 then NS = v end; saveConfig() end)
        carryBox = mkBoxRow(parent, "Carry Speed", CS, function(v) if v > 0 and v <= 500 then CS = v end; saveConfig() end)
        
        mkSectionLbl(parent, "Lagger Speed")
        laggerBox = mkBoxRow(parent, "Lagger Speed", LAGGER_SPEED, function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v end; saveConfig() end)
        laggerCarryBox = mkBoxRow(parent, "Lagger Carry", LAGGER_CARRY_SPEED, function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v end; saveConfig() end)
        
        mkSectionLbl(parent, "Modes")
        do
            local row = mkRow(parent, ROW_HEIGHT)
            mkLabel(row, "Carry Mode")
            mkKBButton(row, KB.SpeedToggle, function() saveConfig() end)
            local kbb = row:FindFirstChildOfClass("TextButton")
            if kbb then kbb.Position = UDim2.new(1, -98, 0.5, -10) end
            local pill, dot = mkPill(row)
            carryModePillRef = {pill = pill, dot = dot}
            animPill(pill, dot, carrySpeedActive)
            modeValLbl = Instance.new("TextLabel", row)
            modeValLbl.Size = UDim2.new(0, 50, 0, 12)
            modeValLbl.Position = UDim2.new(0.42, 0, 0.5, -6)
            modeValLbl.BackgroundTransparency = 1
            modeValLbl.Text = ""
            modeValLbl.TextColor3 = WHITE
            modeValLbl.Font = Enum.Font.GothamBold
            modeValLbl.TextSize = 6
            modeValLbl.ZIndex = 9
            local clk = Instance.new("TextButton", pill)
            clk.Size = UDim2.new(1, 0, 1, 0)
            clk.BackgroundTransparency = 1
            clk.Text = ""
            clk.ZIndex = 11
            clk.Activated:Connect(function()
                if autoSwitchSpeedEnabled then return end
                toggleCarryMode()
                saveConfig()
            end)
            local function updateCarryButton()
                if autoSwitchSpeedEnabled then
                    pill.BackgroundColor3 = BLACK
                    dot.BackgroundColor3 = WHITE
                    clk.Active = false
                    clk.Visible = false
                else
                    clk.Active = true
                    clk.Visible = true
                    animPill(pill, dot, carrySpeedActive)
                end
            end
            task.spawn(function()
                while row and row.Parent do
                    updateCarryButton()
                    task.wait(0.5)
                end
            end)
        end
        
        do
            local row = mkRow(parent, ROW_HEIGHT)
            mkLabel(row, "Lagger Mode")
            mkKBButton(row, KB.LaggerToggle, function() saveConfig() end)
            local kbb = row:FindFirstChildOfClass("TextButton")
            if kbb then kbb.Position = UDim2.new(1, -98, 0.5, -10) end
            local pill, dot = mkPill(row)
            laggerModePillRef = {pill = pill, dot = dot}
            animPill(pill, dot, laggerModeEnabled)
            local clk = Instance.new("TextButton", pill)
            clk.Size = UDim2.new(1, 0, 1, 0)
            clk.BackgroundTransparency = 1
            clk.Text = ""
            clk.ZIndex = 11
            clk.Activated:Connect(function()
                toggleLaggerMode()
                saveConfig()
            end)
        end
        
        mkToggle(parent, "Auto Carry Mode", function(on)
            autoSwitchSpeedEnabled = on
            saveConfig()
        end)
    end
    
    -- ============================================================
    -- BUILD MAIN TAB
    -- ============================================================
    local function buildMainTab(parent)
        mkSectionLbl(parent, "Pathing")
        autoRightSetVisual = mkToggleKB(parent, "AUTO RIGHT", KB.AutoRight, function(on)
            if _anyKeyListening then return end
            if on then
                if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if batV1Enabled then toggleBatV1(); if batV1SetVisual then batV1SetVisual(false) end; if mobBtnRefs.batV1 then mobBtnRefs.batV1(false) end end
                autoRightEnabled = true; startAutoRight(); if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
            else
                autoRightEnabled = false; stopAutoRight(); if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
            end
            saveConfig()
        end, function() saveConfig() end)
        
        autoLeftSetVisual = mkToggleKB(parent, "AUTO LEFT", KB.AutoLeft, function(on)
            if _anyKeyListening then return end
            if on then
                if autoRightEnabled then autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if batV1Enabled then toggleBatV1(); if batV1SetVisual then batV1SetVisual(false) end; if mobBtnRefs.batV1 then mobBtnRefs.batV1(false) end end
                autoLeftEnabled = true; startAutoLeft(); if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
            else
                autoLeftEnabled = false; stopAutoLeft(); if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
            end
            saveConfig()
        end, function() saveConfig() end)
        
        batV1SetVisual = mkToggleKB(parent, "BAT V1", KB.BatV1, function(on)
            if _anyKeyListening then return end
            if on then
                if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled then autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                toggleBatV1(); if mobBtnRefs.batV1 then mobBtnRefs.batV1(true) end
            else
                if batV1Enabled then toggleBatV1(); if mobBtnRefs.batV1 then mobBtnRefs.batV1(false) end end
            end
            saveConfig()
        end, function() saveConfig() end)
        
        mkActionRow(parent, "Drop", function() runDrop() end)
        
        mkSectionLbl(parent, "Protection")
        setAntiRagVisual = mkToggle(parent, "Anti-Ragdoll", function(on)
            antiRagdollEnabled = on
            if on then startAntiRagdoll() else stopAntiRagdoll() end
        end)
        setBatCounterVisual = mkToggle(parent, "Bat Counter", function(on)
            batCounterEnabled = on
            if on then startBatCounter() else stopBatCounter() end
            saveConfig()
        end)
        setMedusaVisual = mkToggle(parent, "Anti Medusa", function(on)
            medusaCounterEnabled = on
            if on then setupMedusa(LP.Character) else stopMedusaCounter() end
            saveConfig()
        end)
        setMedusaResetVisual = mkToggle(parent, "Medusa Reset", function(on)
            medusaResetEnabled = on
            saveConfig()
        end)
        setUnwalkVisual = mkToggle(parent, "Unwalk", function(on)
            unwalkEnabled = on
            if on then startUnwalk() else stopUnwalk() end
        end)
        setAutoSwingVisual = mkToggle(parent, "Auto Swing", function(on)
            autoSwingEnabled = on
            saveConfig()
        end)
        if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
        
        mkSectionLbl(parent, "Steal")
        radInput = mkBoxRow(parent, "Steal Radius", Steal.StealRadius, function(v)
            if v >= 0.5 and v <= 300 then Steal.StealRadius = v end
            saveConfig()
        end)
        mkBoxRow(parent, "Steal Duration", Steal.StealDuration, function(v)
            if v >= 0.1 and v <= 10 then Steal.StealDuration = v end
            saveConfig()
        end)
        do
            local row = mkRow(parent, ROW_HEIGHT)
            mkLabel(row, "Steal")
            local pill, dot = mkPill(row)
            local on = false
            local function sv(s) on = s; animPill(pill, dot, s) end
            setInstaGrab = sv
            local clk = Instance.new("TextButton", pill)
            clk.Size = UDim2.new(1, 0, 1, 0)
            clk.BackgroundTransparency = 1
            clk.Text = ""
            clk.ZIndex = 11
            clk.Activated:Connect(function()
                on = not on
                sv(on)
                Steal.AutoStealEnabled = on
                if on then
                    if not pcall(startAutoSteal) then
                        Steal.AutoStealEnabled = false
                        sv(false)
                    end
                else
                    stopAutoSteal()
                end
                saveConfig()
            end)
        end
        
        mkSectionLbl(parent, "Movement")
        setAutoTPVisual = mkToggle(parent, "Auto TP", function(on)
            autoTPEnabled = on
            if on then startAutoTP() else stopAutoTP() end
            saveConfig()
        end)
        autoTPHeightBox = mkBoxRow(parent, "TP Height", autoTPHeight, function(v)
            if v >= 0 and v <= 500 then autoTPHeight = v end
            saveConfig()
        end)
        mkActionRow(parent, "TP Down", function() runTPFloor() end)
        
        setInfJumpVisual = mkToggle(parent, "Infinite Jump", function(on)
            infJumpEnabled = on
            if infJumpEnabled then
                if infJumpMode == "hold" then startHoldInfJump() end
            else
                stopHoldInfJump()
            end
            saveConfig()
        end)
        
        do
            local row = mkRow(parent, ROW_HEIGHT)
            mkLabel(row, "Jump Mode")
            local manualBtn = Instance.new("TextButton", row)
            manualBtn.Size = UDim2.new(0, 40, 0, 18)
            manualBtn.Position = UDim2.new(1, -92, 0.5, -9)
            manualBtn.BackgroundColor3 = (infJumpMode == "manual") and WHITE or BLACK
            manualBtn.BorderSizePixel = 0
            manualBtn.Text = "Manual"
            manualBtn.TextColor3 = (infJumpMode == "manual") and BLACK or WHITE
            manualBtn.Font = Enum.Font.GothamBold
            manualBtn.TextSize = 6
            manualBtn.AutoButtonColor = false
            manualBtn.ZIndex = 12
            Instance.new("UICorner", manualBtn).CornerRadius = UDim.new(0, 5)
            local holdBtn = Instance.new("TextButton", row)
            holdBtn.Size = UDim2.new(0, 36, 0, 18)
            holdBtn.Position = UDim2.new(1, -46, 0.5, -9)
            holdBtn.BackgroundColor3 = (infJumpMode == "hold") and WHITE or BLACK
            holdBtn.BorderSizePixel = 0
            holdBtn.Text = "Hold"
            holdBtn.TextColor3 = (infJumpMode == "hold") and BLACK or WHITE
            holdBtn.Font = Enum.Font.GothamBold
            holdBtn.TextSize = 6
            holdBtn.AutoButtonColor = false
            holdBtn.ZIndex = 12
            Instance.new("UICorner", holdBtn).CornerRadius = UDim.new(0, 5)
            manualBtn.Activated:Connect(function()
                infJumpMode = "manual"
                manualBtn.BackgroundColor3 = WHITE
                manualBtn.TextColor3 = BLACK
                holdBtn.BackgroundColor3 = BLACK
                holdBtn.TextColor3 = WHITE
                stopHoldInfJump()
                saveConfig()
            end)
            holdBtn.Activated:Connect(function()
                infJumpMode = "hold"
                holdBtn.BackgroundColor3 = WHITE
                holdBtn.TextColor3 = BLACK
                manualBtn.BackgroundColor3 = BLACK
                manualBtn.TextColor3 = WHITE
                if infJumpEnabled then startHoldInfJump() end
                saveConfig()
            end)
        end
        
        mkActionRow(parent, "Reset", function() cursedInstaReset() end)
    end
    
    -- ============================================================
    -- BUILD MISC TAB
    -- ============================================================
    local function buildMiscTab(parent)
        mkToggle(parent, "Ragdoll Timer", function(on)
            ragdollGuiEnabled = on
            saveConfig()
        end)(ragdollGuiEnabled)

        mkSectionLbl(parent, "Optimizer")
        setAntiLagVisual = mkToggle(parent, "Anti Lag", function(on)
            if on then enableAntiLag() else disableAntiLag() end
            saveConfig()
        end)
        setStretchRezVisual = mkToggle(parent, "Stretch Rez", function(on)
            if on then enableStretchRez() else disableStretchRez() end
            saveConfig()
        end)
        
        -- SKY THEME - Full 24 Preset System UI
        do
            local row = mkRow(parent, ROW_HEIGHT)
            mkLabel(row, "Sky Theme")
            
            local skyIndex = 1
            for i, entry in ipairs(CandySkyOrder) do
                if entry[2] == currentSkyTheme then skyIndex = i; break end
            end
            
            local skyVal = Instance.new("TextLabel", row)
            skyVal.Size = UDim2.new(0, 100, 0, 20)
            skyVal.Position = UDim2.new(0, 70, 0.5, -10)
            skyVal.BackgroundTransparency = 1
            skyVal.Text = CandySkyOrder[skyIndex][2]
            skyVal.TextColor3 = WHITE
            skyVal.Font = Enum.Font.GothamBold
            skyVal.TextSize = 9
            skyVal.TextXAlignment = Enum.TextXAlignment.Left
            skyVal.ZIndex = 9
            
            local cycleBtn = Instance.new("TextButton", row)
            cycleBtn.Size = UDim2.new(0, 40, 0, 20)
            cycleBtn.Position = UDim2.new(1, -44, 0.5, -10)
            cycleBtn.BackgroundColor3 = BLACK
            cycleBtn.BackgroundTransparency = 0.2
            cycleBtn.BorderSizePixel = 0
            cycleBtn.Text = "Next"
            cycleBtn.TextColor3 = WHITE
            cycleBtn.Font = Enum.Font.GothamBold
            cycleBtn.TextSize = 7
            cycleBtn.AutoButtonColor = false
            cycleBtn.ZIndex = 10
            Instance.new("UICorner", cycleBtn).CornerRadius = UDim.new(0, 5)
            
            local currentIdx = skyIndex
            
            cycleBtn.Activated:Connect(function()
                if _anyKeyListening then return end
                currentIdx = currentIdx % #CandySkyOrder + 1
                local newTheme = CandySkyOrder[currentIdx][2]
                skyVal.Text = newTheme
                currentSkyTheme = newTheme
                CandyApplyCustomSky(newTheme)
                saveConfig()
            end)
        end
        
        do
            local row = mkRow(parent, ROW_HEIGHT)
            mkLabel(row, "FOV")
            local fovBtn = Instance.new("TextButton", row)
            fovBtn.Size = UDim2.new(0, 44, 0, 20)
            fovBtn.Position = UDim2.new(1, -50, 0.5, -10)
            fovBtn.BackgroundColor3 = BLACK
            fovBtn.BackgroundTransparency = 0.2
            fovBtn.BorderSizePixel = 0
            fovBtn.Text = tostring(fovValue)
            fovBtn.TextColor3 = WHITE
            fovBtn.Font = Enum.Font.GothamBold
            fovBtn.TextSize = 8
            fovBtn.ZIndex = 11
            Instance.new("UICorner", fovBtn).CornerRadius = UDim.new(0, 6)
            local fovStroke = Instance.new("UIStroke", fovBtn)
            fovStroke.Color = WHITE
            fovStroke.Thickness = 1
            fovStroke.Transparency = 0.3
            
            fovBtn.Activated:Connect(function()
                local options = {70, 80, 90, 120, 180}
                local idx = 1
                for i, v in ipairs(options) do if v == fovValue then idx = i end end
                idx = idx % #options + 1
                fovValue = options[idx]
                fovBtn.Text = tostring(fovValue)
                applyFOV()
                saveConfig()
            end)
        end
        
        do
            local row = mkRow(parent, ROW_HEIGHT)
            mkLabel(row, "Reset Settings")
            local resetBtn = Instance.new("TextButton", row)
            resetBtn.Size = UDim2.new(0, 44, 0, 20)
            resetBtn.Position = UDim2.new(1, -50, 0.5, -10)
            resetBtn.BackgroundColor3 = WHITE
            resetBtn.BorderSizePixel = 0
            resetBtn.Text = "RESET"
            resetBtn.TextColor3 = BLACK
            resetBtn.Font = Enum.Font.GothamBold
            resetBtn.TextSize = 6
            resetBtn.ZIndex = 9
            Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)
            resetBtn.Activated:Connect(function()
                NS = 60; CS = 30; LAGGER_SPEED = 15; LAGGER_CARRY_SPEED = 24.5
                carrySpeedActive = false; laggerModeEnabled = false
                autoSwitchSpeedEnabled = false; antiRagdollEnabled = false; infJumpEnabled = false
                infJumpMode = "manual"; medusaCounterEnabled = false; batCounterEnabled = false
                unwalkEnabled = false; medusaResetEnabled = false; autoLeftEnabled = false
                autoRightEnabled = false; batV1Enabled = false
                autoSwingEnabled = true
                autoTPEnabled = false; autoTPHeight = 20; antiLagEnabled = false
                stretchRezEnabled = false; Steal.AutoStealEnabled = false
                Steal.StealRadius = 60; Steal.StealDuration = 1.4
                mobileButtonsEnabled = true
                mobileButtonsSize = 80
                antiKickEnabled = false; uiLocked = false; fovValue = 80
                perButtonDragEnabled = false; ragdollGuiEnabled = true
                currentSkyTheme = "Off"
                CandyApplyCustomSky("Off")
                KB.DropBrainrot = {kb = nil, gp = nil}
                KB.AutoLeft = {kb = nil, gp = nil}
                KB.AutoRight = {kb = nil, gp = nil}
                KB.BatV1 = {kb = nil, gp = nil}
                KB.TPFloor = {kb = nil, gp = nil}
                KB.InstaReset = {kb = nil, gp = nil}
                KB.GuiHide = {kb = nil, gp = nil}
                KB.SpeedToggle = {kb = nil, gp = nil}
                KB.LaggerToggle = {kb = nil, gp = nil}
                refreshSpeedModeLabel()
                if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
                if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                if mobBtnRefs.batV1 then mobBtnRefs.batV1(false) end
                stopBatV1(); stopAutoSteal(); stopAutoLeft(); stopAutoRight()
                stopAntiRagdoll(); stopAutoTP(); stopHoldInfJump()
                if stretchRezEnabled then disableStretchRez() end
                if antiLagEnabled then disableAntiLag() end
                for _, btn in ipairs(parent:GetDescendants()) do
                    if btn:IsA("TextButton") and btn.Text == "Next" then
                        local lbl = btn.Parent:FindFirstChildOfClass("TextLabel")
                        if lbl then lbl.Text = "Off" end
                    end
                end
                saveConfig()
            end)
        end
    end

    -- ============================================================
    -- BUILD SETTINGS TAB
    -- ============================================================
    local function buildSettingsTab(parent)
        mkSectionLbl(parent, "Interface")
        setLockVisual = mkToggle(parent, "Lock UI", function(on)
            uiLocked = on
            saveConfig()
        end)
        if _savedCfg and _savedCfg.uiLocked ~= nil then
            uiLocked = _savedCfg.uiLocked == true
            if setLockVisual then setLockVisual(uiLocked) end
        end

        setMobVisual = mkToggle(parent, "Mobile Buttons", function(on)
            mobileButtonsEnabled = on
            if on then buildMobileButtons() else destroyMobileButtons() end
            saveConfig()
        end)
        if mobileButtonsEnabled then setMobVisual(true) end

        do
            local row = mkRow(parent, ROW_HEIGHT)
            mkLabel(row, "Button Size")
            local sizeBox = Instance.new("TextBox", row)
            sizeBox.Size = UDim2.new(0, 44, 0, 20)
            sizeBox.Position = UDim2.new(1, -50, 0.5, -10)
            sizeBox.BackgroundColor3 = BLACK
            sizeBox.BackgroundTransparency = 0.2
            sizeBox.BorderSizePixel = 0
            sizeBox.Text = tostring(mobileButtonsSize)
            sizeBox.TextColor3 = WHITE
            sizeBox.Font = Enum.Font.GothamBold
            sizeBox.TextSize = 8
            sizeBox.ClearTextOnFocus = false
            sizeBox.ZIndex = 9
            Instance.new("UICorner", sizeBox).CornerRadius = UDim.new(0, 6)
            local boxStroke = Instance.new("UIStroke", sizeBox)
            boxStroke.Color = WHITE
            boxStroke.Thickness = 1
            boxStroke.Transparency = 0.3
            sizeBox.FocusLost:Connect(function()
                local n = tonumber(sizeBox.Text)
                if n and n >= 40 and n <= 150 then
                    mobileButtonsSize = n
                    if mobileButtonsEnabled then buildMobileButtons() end
                    saveConfig()
                else
                    sizeBox.Text = tostring(mobileButtonsSize)
                end
            end)
        end

        do
            local row = mkRow(parent, ROW_HEIGHT)
            mkLabel(row, "Reset Button Pos")
            local resetPosBtn = Instance.new("TextButton", row)
            resetPosBtn.Size = UDim2.new(0, 44, 0, 20)
            resetPosBtn.Position = UDim2.new(1, -50, 0.5, -10)
            resetPosBtn.BackgroundColor3 = BLACK
            resetPosBtn.BackgroundTransparency = 0.2
            resetPosBtn.BorderSizePixel = 0
            resetPosBtn.Text = "Reset"
            resetPosBtn.TextColor3 = WHITE
            resetPosBtn.Font = Enum.Font.GothamBold
            resetPosBtn.TextSize = 6
            resetPosBtn.ZIndex = 9
            Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", resetPosBtn)
            stroke.Color = WHITE
            stroke.Thickness = 1
            stroke.Transparency = 0.3
            resetPosBtn.Activated:Connect(function()
                pcall(function()
                    if writefile then writefile(MOB_POS_FILE, "{}") end
                end)
                if mobileButtonsEnabled then buildMobileButtons() end
            end)
        end

        mkToggle(parent, "Buttons Draggable", function(on)
            perButtonDragEnabled = on
            if mobileButtonsEnabled then buildMobileButtons() end
            saveConfig()
        end)

        mkSectionLbl(parent, "Keybinds")
        mkKBRow(parent, "Speed Toggle", KB.SpeedToggle, function() saveConfig() end)
        mkKBRow(parent, "Lagger Toggle", KB.LaggerToggle, function() saveConfig() end)
        mkKBRow(parent, "Hide UI", KB.GuiHide, function() saveConfig() end)
        mkKBRow(parent, "Auto Right", KB.AutoRight, function() saveConfig() end)
        mkKBRow(parent, "Auto Left", KB.AutoLeft, function() saveConfig() end)
        mkKBRow(parent, "Bat V1", KB.BatV1, function() saveConfig() end)
        mkKBRow(parent, "Drop", KB.DropBrainrot, function() saveConfig() end)
        mkKBRow(parent, "TP Down", KB.TPFloor, function() saveConfig() end)
        mkKBRow(parent, "Reset", KB.InstaReset, function() saveConfig() end)
    end

    -- ============================================================
    -- BUILD ALL TABS
    -- ============================================================
    buildSpeedTab(speedFrame)
    buildMainTab(mainFrame2)
    buildMiscTab(miscFrame)
    buildSettingsTab(settingsFrame)

    for _, frame in ipairs({speedFrame, mainFrame2, miscFrame, settingsFrame}) do
        local layout = Instance.new("UIListLayout", frame)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 2)
        local pad = Instance.new("UIPadding", frame)
        pad.PaddingLeft = UDim.new(0, 4)
        pad.PaddingRight = UDim.new(0, 4)
        pad.PaddingTop = UDim.new(0, 3)
        pad.PaddingBottom = UDim.new(0, 3)
    end

    -- ============================================================
    -- TAB SWITCHING
    -- ============================================================
    local function setTab(tabName)
        speedFrame.Visible = (tabName == "Speed")
        mainFrame2.Visible = (tabName == "Main")
        miscFrame.Visible = (tabName == "Misc")
        settingsFrame.Visible = (tabName == "Settings")

        local function setButton(btn, active)
            btn.BackgroundColor3 = active and WHITE or BLACK
            btn.BackgroundTransparency = active and 0 or 0.5
            btn.TextColor3 = active and BLACK or WHITE
        end
        setButton(tabBtnSpeed, tabName == "Speed")
        setButton(tabBtnMain, tabName == "Main")
        setButton(tabBtnMisc, tabName == "Misc")
        setButton(tabBtnSettings, tabName == "Settings")
    end

    tabBtnSpeed.Activated:Connect(function() setTab("Speed") end)
    tabBtnMain.Activated:Connect(function() setTab("Main") end)
    tabBtnMisc.Activated:Connect(function() setTab("Misc") end)
    tabBtnSettings.Activated:Connect(function() setTab("Settings") end)

    setTab("Speed")

    -- ============================================================
    -- KEYBIND INPUT HANDLER
    -- ============================================================
    UIS.InputBegan:Connect(function(input, gpe)
        if _anyKeyListening then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if gpe or UIS:GetFocusedTextBox() then return end
        elseif not isGamepadInput(input) then return end
        if not isBindableInput(input) then return end
        local kc = input.KeyCode
        if kbMatch(KB.LaggerToggle, kc) then
            toggleLaggerMode()
            saveConfig()
        elseif kbMatch(KB.SpeedToggle, kc) then
            if autoSwitchSpeedEnabled then return end
            toggleCarryMode()
            saveConfig()
        elseif kbMatch(KB.DropBrainrot, kc) then runDrop()
        elseif kbMatch(KB.TPFloor, kc) then runTPFloor()
        elseif kbMatch(KB.InstaReset, kc) then cursedInstaReset()
        elseif kbMatch(KB.AutoRight, kc) then
            autoRightEnabled = not autoRightEnabled
            if autoRightEnabled then
                if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if batV1Enabled then toggleBatV1(); if batV1SetVisual then batV1SetVisual(false) end; if mobBtnRefs.batV1 then mobBtnRefs.batV1(false) end end
                startAutoRight()
                if autoRightSetVisual then autoRightSetVisual(true) end
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
            else
                stopAutoRight()
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
            end
        elseif kbMatch(KB.AutoLeft, kc) then
            autoLeftEnabled = not autoLeftEnabled
            if autoLeftEnabled then
                if autoRightEnabled then autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if batV1Enabled then toggleBatV1(); if batV1SetVisual then batV1SetVisual(false) end; if mobBtnRefs.batV1 then mobBtnRefs.batV1(false) end end
                startAutoLeft()
                if autoLeftSetVisual then autoLeftSetVisual(true) end
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
            else
                stopAutoLeft()
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
            end
        elseif kbMatch(KB.BatV1, kc) then
            if not batV1Enabled then
                if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled then autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                toggleBatV1()
                if batV1SetVisual then batV1SetVisual(true) end
                if mobBtnRefs.batV1 then mobBtnRefs.batV1(true) end
            else
                toggleBatV1()
                if batV1SetVisual then batV1SetVisual(false) end
                if mobBtnRefs.batV1 then mobBtnRefs.batV1(false) end
            end
        elseif kbMatch(KB.GuiHide, kc) then
            if not isHidden then
                isHidden = true
                mainFrame.Visible = false
                miniBtn.Visible = true
            else
                isHidden = false
                miniBtn.Visible = false
                mainFrame.Visible = true
            end
        end
    end)
end

-- ============================================================
-- LOAD CONFIG
-- ============================================================
local _savedCfg = nil

local function loadConfigKeys()
    if not(isfile and isfile("poisonhub.json")) then return end
    local ok, cfg = pcall(function() return HS:JSONDecode(readfile("poisonhub.json")) end)
    if not ok or not cfg then return end
    _savedCfg = cfg
    local function lk(e, d)
        if type(d) ~= "table" then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] else e.kb = nil end
        if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] else e.gp = nil end
    end
    lk(KB.DropBrainrot, cfg.dropBrainrotKey)
    lk(KB.AutoLeft, cfg.autoLeftKey)
    lk(KB.AutoRight, cfg.autoRightKey)
    lk(KB.BatV1, cfg.batV1Key)
    lk(KB.TPFloor, cfg.tpFloorKey)
    lk(KB.InstaReset, cfg.instaResetKey)
    lk(KB.GuiHide, cfg.guiHideKey)
    lk(KB.SpeedToggle, cfg.speedToggleKey)
    lk(KB.LaggerToggle, cfg.laggerToggleKey)
    if cfg.normalSpeed then NS = cfg.normalSpeed end
    if cfg.carrySpeed then CS = cfg.carrySpeed end
    if cfg.laggerSpeed then LAGGER_SPEED = cfg.laggerSpeed end
    if cfg.laggerCarrySpeed then LAGGER_CARRY_SPEED = cfg.laggerCarrySpeed end
    if cfg.grabRadius then Steal.StealRadius = cfg.grabRadius end
    if cfg.stealDuration then Steal.StealDuration = cfg.stealDuration end
    if cfg.autoTPHeight then autoTPHeight = cfg.autoTPHeight end
    if cfg.autoSwing ~= nil then autoSwingEnabled = cfg.autoSwing == true end
    if cfg.mobileButtonsEnabled ~= nil then mobileButtonsEnabled = cfg.mobileButtonsEnabled end
    if cfg.mobileButtonsSize ~= nil then mobileButtonsSize = cfg.mobileButtonsSize end
    if cfg.autoSwitchSpeed ~= nil then autoSwitchSpeedEnabled = cfg.autoSwitchSpeed == true end
    if cfg.antiKick ~= nil then antiKickEnabled = cfg.antiKick == true end
    if cfg.carrySpeedActive ~= nil then carrySpeedActive = cfg.carrySpeedActive end
    if cfg.laggerModeEnabled ~= nil then laggerModeEnabled = cfg.laggerModeEnabled end
    if cfg.infJumpMode then infJumpMode = cfg.infJumpMode end
    if cfg.fovValue then fovValue = cfg.fovValue end
    if cfg.perButtonDrag ~= nil then perButtonDragEnabled = cfg.perButtonDrag == true end
    if cfg.skyTheme then 
        currentSkyTheme = cfg.skyTheme
        CandyApplyCustomSky(currentSkyTheme)
    end
    if cfg.medusaReset ~= nil then medusaResetEnabled = cfg.medusaReset == true end
    if cfg.ragdollGui ~= nil then ragdollGuiEnabled = cfg.ragdollGui == true end
    if cfg.uiLocked ~= nil then uiLocked = cfg.uiLocked == true end
    if cfg.batV1Enabled ~= nil then 
        batV1Enabled = cfg.batV1Enabled == true
    end
end

local function loadConfigState()
    local cfg = _savedCfg
    if not cfg then return end
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if laggerCarryBox then laggerCarryBox.Text = tostring(LAGGER_CARRY_SPEED) end
    if radInput then radInput.Text = tostring(Steal.StealRadius) end
    if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
    task.spawn(function()
        task.wait(0.15)
        if cfg.antiRagdoll then
            antiRagdollEnabled = true
            if setAntiRagVisual then setAntiRagVisual(true) end
            startAntiRagdoll()
        end
        if cfg.autoStealEnabled then
            Steal.AutoStealEnabled = true
            if setInstaGrab then setInstaGrab(true) end
            pcall(startAutoSteal)
        end
        if cfg.infiniteJump then
            infJumpEnabled = true
            if setInfJumpVisual then setInfJumpVisual(true) end
            if infJumpMode == "hold" then startHoldInfJump() end
        end
        if cfg.medusaCounter then
            medusaCounterEnabled = true
            if setMedusaVisual then setMedusaVisual(true) end
            setupMedusa(LP.Character)
        end
        if cfg.medusaReset then
            medusaResetEnabled = true
            if setMedusaResetVisual then setMedusaResetVisual(true) end
        end
        if cfg.batCounter then
            batCounterEnabled = true
            if setBatCounterVisual then setBatCounterVisual(true) end
            startBatCounter()
        end
        refreshSpeedModeLabel()
        if cfg.autoTPEnabled then
            autoTPEnabled = true
            if setAutoTPVisual then setAutoTPVisual(true) end
            startAutoTP()
        end
        if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
        if cfg.batV1Enabled then
            batV1Enabled = true
            if batV1SetVisual then batV1SetVisual(true) end
            if mobBtnRefs.batV1 then mobBtnRefs.batV1(true) end
            startBatV1()
        end
        if cfg.unwalkEnabled then
            unwalkEnabled = true
            if setUnwalkVisual then setUnwalkVisual(true) end
            task.spawn(function() task.wait(0.5); startUnwalk() end)
        end
        if cfg.antiLag then
            enableAntiLag()
            if setAntiLagVisual then setAntiLagVisual(true) end
        end
        if cfg.stretchRez then
            enableStretchRez()
            if setStretchRezVisual then setStretchRezVisual(true) end
        end
        if cfg.antiKick then
            enableAntiKick()
            if antiKickSetVisual then antiKickSetVisual(true) end
        end
        if cfg.uiLocked ~= nil and setLockVisual then setLockVisual(cfg.uiLocked) end
    end)
end

loadConfigKeys()
buildGui()
if mobileButtonsEnabled then buildMobileButtons() end
loadConfigState()
if currentSkyTheme and currentSkyTheme ~= "Off" then
    CandyApplyCustomSky(currentSkyTheme)
end

print("Poison Hub loaded successfully with Bat V1!")