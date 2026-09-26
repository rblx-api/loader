if _G.VeneyorkRunning then return end
_G.VeneyorkRunning = true
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera
NS = 60
CS = 29
LAGGER_SPEED_1 = 20
LAGGER_SPEED_2 = 10
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BYPASS_AIMBOT_SPEED = 60
MOBILE_PANEL_WIDTH = 128
MOBILE_PANEL_HEIGHT = 294
CONFIG_FILE = "Veneyork.json"
BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false
speedMode = false
antiRagdollEnabled = false
antiDieEnabled = false
antiDropEnabled = false
antiFlingShieldEnabled = false
jumpEnabled = false
laggerToggled = false
laggerLevel = 1
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
medusaAutoResetEnabled = false
uiLocked = true
editModeEnabled = false
uiScaleValue = 80
buttonScaleValue = 1.0
buttonsSizeValue = 50  -- imagen: Buttons Size 50 (0 min - 100 max)
buttonsShape = "Circle"  -- imagen: Buttons Shape = Circle
mobileButtonsByName = {}
BUTTON_SHAPE_ORDER = {"Circle", "Normal", "Square", "Rectangle"}
espEnabled = false
fovSelectorVisible = false
bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
bodyLockSetVisual = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false
savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
instaResetFloatingPos = nil
tpBatFloatingPos = nil
batV2FloatingPos = nil
neonWeatherEnabled = false

-- Menu background images (from Adapt)
MENU_BG_IDS = {
    "107328909628204",
    "102877336629662",
    "114138477258742",
}
MENU_THEME_COLORS = {
    PURPLE = Color3.fromRGB(207, 159, 255),
    BLUE   = Color3.fromRGB(58, 128, 245),
    RED    = Color3.fromRGB(232, 52, 68),
    PINK   = Color3.fromRGB(255, 105, 180),
    YELLOW = Color3.fromRGB(255, 214, 0),
    GREY   = Color3.fromRGB(90, 90, 90),
    WHITE  = Color3.fromRGB(255, 255, 255),
    FOREST = Color3.fromRGB(46, 139, 87),
}
currentMenuBackground = 0
currentMenuTheme = "WHITE"
menuBgImage = nil
stealBarBgImage = nil
-- Imágenes para botones móviles (mismas del menú + se eligen manualmente)
BUTTON_IMG_IDS = {
    "119466264281320",
    "108199149509537",
    "121087678749100",
    "98596557474777",
    "124833425021074",
    "93357962442247",
    "137732510773181",
}
currentButtonImage = 0  -- 0 = NONE


_originalLighting = nil
setNeonWeatherVisual = nil
currentAnimPack = "Vampire"
originalTryardAnims = nil
tryardHeartbeatConn = nil
animSelectorLabel = nil


-- Music Pack (imagen: Migizin)
currentMusicPack = "Migizin"
musicSelectorLabel = nil
local MUSIC_PACKS = {
    ["Tryhard"] = {id = "rbxassetid://137188221417776", vol = 0.7},
    ["Tryhard 2"] = {id = "rbxassetid://77142753938657", vol = 0.7},
    ["Tryhard Def"] = {id = "rbxassetid://75196377290071", vol = 0.7},
    ["XD"] = {id = "rbxassetid://90813223538688", vol = 0.7},
    ["67"] = {id = "rbxassetid://98859392001383", vol = 0.7},
    ["3AM"] = {id = "rbxassetid://73755162651548", vol = 0.7},
    ["Beretta"] = {id = "rbxassetid://94281718874647", vol = 0.7},
    ["Brasil"] = {id = "rbxassetid://91225667489242", vol = 0.7},
    ["Brasil 2"] = {id = "rbxassetid://135750430892149", vol = 0.7},
    ["Migizin"] = {id = "rbxassetid://91630262633548", vol = 0.7},
}
local MUSIC_PACK_ORDER = {
    {"Off", "Off"},
    {"Tryhard", "Tryhard"},
    {"Tryhard 2", "Tryhard 2"},
    {"Tryhard Def", "Tryhard Def"},
    {"XD", "XD"},
    {"67", "67"},
    {"3AM", "3AM"},
    {"Beretta", "Beretta"},
    {"Brasil", "Brasil"},
    {"Brasil 2", "Brasil 2"},
    {"Migizin", "Migizin"},
}
local _musicSound = nil
local function stopMusicPack()
    if _musicSound then
        pcall(function() _musicSound:Stop(); _musicSound:Destroy() end)
        _musicSound = nil
    end
end
local function playMusicPack(name)
    stopMusicPack()
    currentMusicPack = name or "Off"
    if musicSelectorLabel then musicSelectorLabel.Text = currentMusicPack end
    if not name or name == "Off" then return end
    local pack = MUSIC_PACKS[name]
    if not pack then return end
    pcall(function()
        local s = Instance.new("Sound")
        s.Name = "VeneyorkMusic_" .. tostring(name):gsub("%s", "_")
        s.SoundId = pack.id
        s.Volume = pack.vol or 0.7
        s.Looped = true
        s.Parent = game:GetService("SoundService")
        s:Play()
        _musicSound = s
    end)
end

autoBatV2Enabled = false
autoBatV2SwingEnabled = true
autoBatV2HitCooldown = false
AUTO_BAT_V2_SPEED = 60
AUTO_BAT_V2_DIST = 1.0
AUTO_BAT_V2_HEIGHT = 1.5
AUTO_BAT_V2_V_OFF = 0.0
AUTO_BAT_V2_HIT_DIST = 4.5
AUTO_BAT_V2_SWING_CD = 0.08
_batV2Conn = nil
local speedLinearVelocity = nil
local speedAttachment = nil
local speedConnection = nil
local currentSpeedValue = NS
local speedEnabled = false
local lastPosition = nil
local lastTime = nil
local lagbackCooldown = 0
local ownershipTimer = 0
local CoreGui = game:GetService("CoreGui")
InfJumpState = InfJumpState or { enabled = true, mode = "hold" }
local _lastInfJump = 0
local _gamepadBtnHeld = false
local _activeTouches = {}
local _lastTouchStart = nil
local _holdTouch = nil


local RESET_MAX_DURATION = 0.05
local resetCooldown     = false
local resetThread       = nil
local currentCharacter  = nil
local resetSuccessful   = false
local stopResetSequence = false

local function ResetPlayer()
    if resetCooldown then return end
    resetCooldown = true
    resetSuccessful = false
    stopResetSequence = false 

    local character = LP.Character
    if not character then
        resetCooldown = false
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        resetCooldown = false
        return
    end

    currentCharacter = character
    local isRespawning = false

    resetThread = task.spawn(function()
        local attempts = 0
        local maxAttempts = 40
        local originalHipHeight = humanoid.HipHeight

        while character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning and not stopResetSequence do
            if LP.Character ~= character then
                isRespawning = true
                break
            end

            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true

                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = false
                end

                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end)

            if not character or not character.Parent or not humanoid or humanoid.Health <= 0 or LP.Character ~= character then
                resetSuccessful = true
                break
            end

            attempts = attempts + 1
            if attempts >= maxAttempts then
                break
            end

            task.wait(RESET_MAX_DURATION)
        end

        if not resetSuccessful then
            if character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
                pcall(function()
                    humanoid.Health = 0
                end)
                task.wait(0.1)
                if not character.Parent or humanoid.Health <= 0 then
                    resetSuccessful = true
                end
            end
        end

        if not resetSuccessful and character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = true
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end

        resetCooldown = false
        resetThread = nil
        currentCharacter = nil
        stopResetSequence = false
    end)
end

local function StopResetSequence()
    stopResetSequence = true
    if resetThread then
        task.cancel(resetThread)
        resetThread = nil
    end
    resetCooldown = false
    currentCharacter = nil

    local character = LP.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function()
                humanoid.HipHeight = 2
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = true
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end
    end
end

local function MonitorResetSuccess()
    task.spawn(function()
        while true do
            task.wait(0.2)
            local char = LP.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then
                    resetSuccessful = true
                    if resetThread then
                        task.cancel(resetThread)
                        resetThread = nil
                    end
                    resetCooldown = false
                end
                if currentCharacter and char ~= currentCharacter then
                    resetSuccessful = true
                    if resetThread then
                        task.cancel(resetThread)
                        resetThread = nil
                    end
                    resetCooldown = false
                    currentCharacter = nil
                end
                if hum and hum:FindFirstChild("Animator") then
                    local animator = hum.Animator
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        if track.Animation and track.Animation.Name and string.find(track.Animation.Name:lower(), "death") then
                            resetSuccessful = true
                            break
                        end
                    end
                end
            else
                if currentCharacter then
                    resetSuccessful = true
                    if resetThread then
                        task.cancel(resetThread)
                        resetThread = nil
                    end
                    resetCooldown = false
                    currentCharacter = nil
                end
            end
        end
    end)
end

MonitorResetSuccess()


function instaReset()
    ResetPlayer()
end

function instareset(resetType)
    ResetPlayer()
end

_G.StopResetSequence = StopResetSequence


currentSkyTheme = "Off"
CANDY_SKY_TAG = "VeneyorkSky"
candyOriginalLighting = nil
skySelectorLabel = nil

local CANDY_SKY_PRESETS = {
    ["Off"] = { kind = "off" },
    ["Night"] = { clock = 22, brightness = 2, ambient = {110,100,130}, outAmb = {120,110,140}, sky = {stars = 4000, moon = 18, sun = 0, moonTex = true}, atm = {dens = 0.45, color = {120,60,180}, decay = {60,20,100}, glare = 0.5, haze = 1.2} },
    ["Aurora"] = { clock = 14, brightness = 3, ambient = {150,120,150}, outAmb = {160,130,150}, atm = {dens = 0.55, color = {255,80,200}, decay = {255,20,150}, glare = 2.5, haze = 3}, clouds = {cover = 0.7, dens = 0.7, color = {255,240,250}} },
    ["Sunset"] = { clock = 17.2, brightness = 2.5, ambient = {170,120,100}, outAmb = {180,130,110}, sky = {stars = 0, sun = 25, moon = 0}, atm = {dens = 0.5, color = {255,130,60}, decay = {255,80,30}, glare = 2, haze = 2.5}, clouds = {cover = 0.55, dens = 0.55, color = {255,200,140}} },
    ["Galaxy"] = { clock = 0, brightness = 1.5, ambient = {70,60,100}, outAmb = {80,70,110}, sky = {stars = 10000, moon = 30, sun = 0}, atm = {dens = 0.15, color = {40,20,80}, decay = {20,10,50}, glare = 0.3, haze = 0.5} },
    ["Cyber"] = { clock = 21, brightness = 2.2, ambient = {90,130,170}, outAmb = {100,140,180}, sky = {stars = 2000, moon = 12}, atm = {dens = 0.4, color = {0,200,255}, decay = {150,0,255}, glare = 2, haze = 2}, clouds = {cover = 0.4, dens = 0.6, color = {100,200,255}} },
    ["Sakura"] = { clock = 11, brightness = 3.5, ambient = {170,150,160}, outAmb = {180,160,170}, sky = {sun = 8}, atm = {dens = 0.3, color = {255,200,220}, decay = {255,170,200}, glare = 1, haze = 1.5}, clouds = {cover = 0.6, dens = 0.4, color = {255,250,252}} },
    ["Pink Night"] = { clock = 23, brightness = 2.2, ambient = {120,60,110}, outAmb = {140,70,120}, sky = {stars = 5000, moon = 22, sun = 0, moonTex = true}, atm = {dens = 0.5, color = {255,80,180}, decay = {140,30,100}, glare = 0.7, haze = 1.4}, clouds = {cover = 0.3, dens = 0.5, color = {180,90,150}} },
    ["Blood Moon"] = { clock = 22.5, brightness = 1.6, ambient = {130,40,40}, outAmb = {150,50,50}, sky = {stars = 1500, moon = 28, sun = 0, moonTex = true}, atm = {dens = 0.6, color = {220,30,30}, decay = {120,10,10}, glare = 1.4, haze = 2}, clouds = {cover = 0.5, dens = 0.7, color = {120,30,30}} },
    ["Emerald Dawn"] = { clock = 6.5, brightness = 2.8, ambient = {130,170,140}, outAmb = {140,180,150}, sky = {sun = 18, moon = 0, stars = 0}, atm = {dens = 0.4, color = {80,200,140}, decay = {40,150,90}, glare = 1.8, haze = 2.2}, clouds = {cover = 0.5, dens = 0.5, color = {200,255,220}} },
    ["Volcanic"] = { clock = 19, brightness = 2, ambient = {180,80,40}, outAmb = {200,90,50}, sky = {stars = 200, sun = 12, moon = 0}, atm = {dens = 0.75, color = {255,60,0}, decay = {180,20,0}, glare = 3, haze = 3.5}, clouds = {cover = 0.8, dens = 0.9, color = {120,40,20}} },
    ["Arctic"] = { clock = 9, brightness = 3.2, ambient = {200,220,235}, outAmb = {210,230,245}, sky = {sun = 10, stars = 0, moon = 0}, atm = {dens = 0.3, color = {180,220,255}, decay = {140,200,240}, glare = 1.5, haze = 1.8}, clouds = {cover = 0.7, dens = 0.6, color = {250,253,255}} },
    ["Midnight Ocean"] = { clock = 1.5, brightness = 1.7, ambient = {60,90,130}, outAmb = {70,100,140}, sky = {stars = 6000, moon = 24, sun = 0, moonTex = true}, atm = {dens = 0.5, color = {20,60,140}, decay = {10,30,90}, glare = 0.6, haze = 1.5} },
    ["Vaporwave"] = { clock = 19.5, brightness = 2.4, ambient = {180,120,200}, outAmb = {190,130,210}, sky = {stars = 1000, moon = 14}, atm = {dens = 0.45, color = {255,100,220}, decay = {120,60,255}, glare = 2.2, haze = 2.4}, clouds = {cover = 0.5, dens = 0.55, color = {200,150,255}} },
    ["Toxic"] = { clock = 13, brightness = 2.5, ambient = {140,180,80}, outAmb = {150,190,90}, atm = {dens = 0.55, color = {100,220,40}, decay = {60,150,20}, glare = 1.8, haze = 2.6}, clouds = {cover = 0.65, dens = 0.7, color = {180,255,120}} },
    ["Solar Eclipse"] = { clock = 12, brightness = 0.9, ambient = {50,40,60}, outAmb = {60,50,70}, sky = {stars = 3500, sun = 22, moon = 0}, atm = {dens = 0.5, color = {255,140,40}, decay = {30,20,40}, glare = 2.8, haze = 1.8} },
    ["Hellscape"] = { clock = 18, brightness = 1.8, ambient = {200,60,30}, outAmb = {220,70,40}, sky = {stars = 100, sun = 30, moon = 0}, atm = {dens = 0.85, color = {255,30,0}, decay = {120,0,0}, glare = 3.5, haze = 4}, clouds = {cover = 0.95, dens = 0.95, color = {80,20,10}} },
    ["Heaven"] = { clock = 12, brightness = 4, ambient = {240,235,210}, outAmb = {250,245,220}, sky = {sun = 16, moon = 0, stars = 0}, atm = {dens = 0.25, color = {255,250,220}, decay = {255,240,200}, glare = 3, haze = 1.5}, clouds = {cover = 0.85, dens = 0.5, color = {255,255,255}} },
    ["Storm"] = { clock = 15, brightness = 1.4, ambient = {90,90,110}, outAmb = {100,100,120}, sky = {stars = 0, sun = 6, moon = 0}, atm = {dens = 0.65, color = {80,90,120}, decay = {40,50,80}, glare = 0.5, haze = 3}, clouds = {cover = 0.95, dens = 0.95, color = {60,65,80}} },
    ["Sunrise"] = { clock = 6.2, brightness = 2.8, ambient = {220,180,130}, outAmb = {230,190,140}, sky = {sun = 22, stars = 0, moon = 0}, atm = {dens = 0.45, color = {255,180,100}, decay = {255,140,80}, glare = 2.4, haze = 2.2}, clouds = {cover = 0.4, dens = 0.4, color = {255,220,180}} },
    ["Deep Space"] = { clock = 0, brightness = 1, ambient = {30,25,50}, outAmb = {40,35,60}, sky = {stars = 15000, moon = 0, sun = 0}, atm = {dens = 0.08, color = {15,5,40}, decay = {5,0,20}, glare = 0.2, haze = 0.3} },
    ["Lavender Dream"] = { clock = 18.5, brightness = 2.6, ambient = {180,160,220}, outAmb = {190,170,230}, sky = {stars = 800, moon = 16, sun = 0}, atm = {dens = 0.4, color = {200,160,255}, decay = {160,120,220}, glare = 1.4, haze = 1.8}, clouds = {cover = 0.55, dens = 0.5, color = {220,200,255}} },
    ["Inferno"] = { clock = 17.5, brightness = 2.2, ambient = {220,100,40}, outAmb = {235,110,50}, sky = {sun = 26, moon = 0, stars = 0}, atm = {dens = 0.6, color = {255,90,20}, decay = {200,40,0}, glare = 3, haze = 3.2}, clouds = {cover = 0.7, dens = 0.7, color = {200,80,40}} },
    ["Mint Sky"] = { clock = 10, brightness = 3.2, ambient = {180,230,210}, outAmb = {190,240,220}, sky = {sun = 10}, atm = {dens = 0.32, color = {150,255,210}, decay = {100,220,180}, glare = 1.6, haze = 1.6}, clouds = {cover = 0.55, dens = 0.45, color = {240,255,250}} },
}

local CANDY_SKY_ORDER = {
    {"Off","Off"}, {"Night","Night"}, {"Aurora","Aurora"}, {"Sunset","Sunset"},
    {"Galaxy","Galaxy"}, {"Cyber","Cyber"}, {"Sakura","Sakura"},
    {"Pink Night","Pink Night"}, {"Blood Moon","Blood Moon"},
    {"Emerald Dawn","Emerald Dawn"}, {"Volcanic","Volcanic"},
    {"Arctic","Arctic"}, {"Midnight Ocean","Midnight Ocean"},
    {"Vaporwave","Vaporwave"}, {"Toxic","Toxic"},
    {"Solar Eclipse","Solar Eclipse"}, {"Hellscape","Hellscape"},
    {"Heaven","Heaven"}, {"Storm","Storm"}, {"Sunrise","Sunrise"},
    {"Deep Space","Deep Space"}, {"Lavender Dream","Lavender Dream"},
    {"Inferno","Inferno"}, {"Mint Sky","Mint Sky"}
}

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

local function candyColor(rgb)
    return Color3.fromRGB(rgb[1], rgb[2], rgb[3])
end

local function CandyApplyCustomSky(mode)
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
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
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

local function setSkyTheme(theme)
    currentSkyTheme = theme
    CandyApplyCustomSky(theme)
    if skySelectorLabel then skySelectorLabel.Text = theme end
end


-- Skin Pack (imagen: Headless)
local SKIN_PACK_ORDER = {
    {"Off", "Off"},
    {"Korblox", "Korblox"},
    {"Headless", "Headless"},
    {"Both", "Both"}
}
ACCESSORY_PACK_ORDER = SKIN_PACK_ORDER  -- alias para compat UI skin
currentAccessoryPack = "Headless"  -- Skin Pack default (imagen)
accSelectorLabel = nil

-- Pack Accessory Bleed (imagen: Pack Accessory = Off)
local BLEED_PACK_ORDER = {
    {"Off", "Off"},
    {"Bleed 1", "Bleed 1"},
    {"Bleed 2", "Bleed 2"},
    {"Bleed 3", "Bleed 3"},
}
currentBleedPack = "Off"
bleedSelectorLabel = nil
local BLEED_PACKS = {
    ["Bleed 1"] = {
        accessory = 306969564,
        offset = Vector3.new(0, 0.3, 0),
        shirt = "http://www.roblox.com/asset/?id=10632503795",
        pants = "http://www.roblox.com/asset/?id=123161592384863",
    },
    ["Bleed 2"] = {
        accessory = 1744060292,
        offset = Vector3.new(0, 1.4, -0.2),
        shirt = "http://www.roblox.com/asset/?id=11526718530",
        pants = "http://www.roblox.com/asset/?id=93710523210027",
    },
    ["Bleed 3"] = {
        accessory = 112564966849233,
        offset = Vector3.new(0, 0.6, 0),
        shirt = "http://www.roblox.com/asset/?id=11849088376",
        pants = "http://www.roblox.com/asset/?id=16534673928",
    },
}

local function applyBleedPack(packName)
    currentBleedPack = packName or "Off"
    local char = LP.Character
    if not char then return end
    -- limpia bleed anterior
    for _, c in ipairs(char:GetChildren()) do
        if c.Name == "NightBleedAccessory" or c.Name:find("Bleed_") then
            pcall(function() c:Destroy() end)
        end
    end
    if packName == "Off" or not BLEED_PACKS[packName] then
        if bleedSelectorLabel then bleedSelectorLabel.Text = "Off" end
        return
    end
    local cfg = BLEED_PACKS[packName]
    pcall(function()
        local shirt = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt", char)
        local pants = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants", char)
        if cfg.shirt then shirt.ShirtTemplate = cfg.shirt end
        if cfg.pants then pants.PantsTemplate = cfg.pants end
    end)
    pcall(function()
        local m = nil
        local ok1, objs = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(cfg.accessory))
        end)
        if ok1 and objs and objs[1] then
            m = objs[1]
        end
        if not m then
            local ok2, model = pcall(function()
                return game:GetService("InsertService"):LoadAsset(tonumber(cfg.accessory))
            end)
            if ok2 and model then
                m = model:GetChildren()[1] or model
            end
        end
        if not m then return end
        m.Name = "NightBleedAccessory"
        local head = char:FindFirstChild("Head")
        local part = m:IsA("BasePart") and m or m:FindFirstChildWhichIsA("BasePart", true)
        if part and head then
            part.CanCollide = false
            part.CFrame = head.CFrame + (cfg.offset or Vector3.zero)
            local w = Instance.new("WeldConstraint")
            w.Part0 = head
            w.Part1 = part
            w.Parent = part
            m.Parent = char
        elseif m:IsA("Accessory") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function() hum:AddAccessory(m) end)
            else
                m.Parent = char
            end
        else
            m.Parent = char
        end
    end)
    if bleedSelectorLabel then bleedSelectorLabel.Text = packName end
end


local function clearAccessories()
    local char = LP.Character
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:find("Korblox_") or child.Name:find("Headless_") then
            pcall(function() child:Destroy() end)
        end
    end
    local partsToHide = {"Head", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
    for _, partName in ipairs(partsToHide) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
end

local function attachKorbloxLeg(legName, config)
    local char = LP.Character
    if not char then return false, "No character" end

    local targetPart = char:FindFirstChild(config.targetBodyPart)
    if not targetPart then return false, "Target part missing" end

    local oldAsset = char:FindFirstChild("Korblox_" .. legName:gsub("%s+", ""))
    if oldAsset then oldAsset:Destroy() end

    for _, partName in ipairs(config.partsToHide) do
        local limb = char:FindFirstChild(partName)
        if limb and limb:IsA("BasePart") then
            limb.Transparency = 1
        end
    end

    local success, objects = pcall(function()
        return game:GetObjects(config.id)
    end)
    if not success or not objects or #objects == 0 then
        return false, "Asset fetch failed"
    end

    local assetModel = objects[1]
    assetModel.Name = "Korblox_" .. legName:gsub("%s+", "")

    local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
    if not mainMesh then
        return false, "No MeshPart in asset"
    end

    mainMesh.Size = mainMesh.Size * config.scale
    mainMesh.CanCollide = false
    mainMesh.CFrame = targetPart.CFrame * config.offset

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = targetPart
    weld.Part1 = mainMesh
    weld.Parent = mainMesh

    assetModel.Parent = char
    return true
end

local function attachHeadless()
    local char = LP.Character
    if not char then return false, "No character" end

    local targetPart = char:FindFirstChild("Head")
    if not targetPart then return false, "Head missing" end

    local oldAsset = char:FindFirstChild("Headless_Headless")
    if oldAsset then oldAsset:Destroy() end

    targetPart.Transparency = 1

    local success, objects = pcall(function()
        return game:GetObjects("rbxassetid://134082579")
    end)
    if not success or not objects or #objects == 0 then
        return false, "Asset fetch failed"
    end

    local assetModel = objects[1]
    assetModel.Name = "Headless_Headless"

    local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
    if not mainMesh then
        return false, "No MeshPart in asset"
    end

    mainMesh.Size = mainMesh.Size * Vector3.new(1,1,1)
    mainMesh.CanCollide = false
    mainMesh.CFrame = targetPart.CFrame

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = targetPart
    weld.Part1 = mainMesh
    weld.Parent = mainMesh

    assetModel.Parent = char
    return true
end

local function applyAccessoryPack(packName)
    clearAccessories()
    if packName == "Off" then return end

    local rightLegConfig = {
        id = "rbxassetid://139607718",
        targetBodyPart = "RightUpperLeg",
        partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
        scale = Vector3.new(1,1,1),
        offset = CFrame.new(0,0,0)
    }

    if packName == "Korblox" or packName == "Both" then
        attachKorbloxLeg("Right Leg", rightLegConfig)
    end

    if packName == "Headless" or packName == "Both" then
        attachHeadless()
    end
end


function applyButtonScale(val)
    buttonScaleValue = math.clamp(val, 0.50, 1.50)
    local scale = buttonScaleValue
    if MobilePanel then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        if container then
            local sc = container:FindFirstChild("ButtonScale") or Instance.new("UIScale")
            sc.Name = "ButtonScale"
            sc.Scale = scale
            sc.Parent = container
        end
    end
    if instaResetFloatingButton then
        local frame = instaResetFloatingButton:FindFirstChild("Frame")
        if frame then
            local sc = frame:FindFirstChild("ButtonScale") or Instance.new("UIScale")
            sc.Name = "ButtonScale"
            sc.Scale = scale
            sc.Parent = frame
        end
    end
    if tpBatFloatingButton then
        local frame = tpBatFloatingButton:FindFirstChild("Frame")
        if frame then
            local sc = frame:FindFirstChild("ButtonScale") or Instance.new("UIScale")
            sc.Name = "ButtonScale"
            sc.Scale = scale
            sc.Parent = frame
        end
    end
    if batV2FloatingButton then
        local frame = batV2FloatingButton:FindFirstChild("Frame")
        if frame then
            local sc = frame:FindFirstChild("ButtonScale") or Instance.new("UIScale")
            sc.Name = "ButtonScale"
            sc.Scale = scale
            sc.Parent = frame
        end
    end
end


local function applyImpulse(root, hum, yVel)
    local attachment = root:FindFirstChild("InfJumpAttachment") or Instance.new("Attachment")
    attachment.Name = "InfJumpAttachment"
    attachment.Parent = root
    local currentX = root.AssemblyLinearVelocity.X
    local currentZ = root.AssemblyLinearVelocity.Z
    local targetY = yVel or 50
    local lv = Instance.new("LinearVelocity")
    lv.Name = "InfJumpVelocity"
    lv.MaxForce = 999999
    lv.VectorVelocity = Vector3.new(currentX, targetY, currentZ)
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.Attachment0 = attachment
    lv.Parent = root
    task.delay(0.08, function()
        if lv then lv:Destroy() end
        if attachment then attachment:Destroy() end
    end)
end
local function _doInfJump()
    local now = os.clock()
    if now - _lastInfJump < 0.1 then return end
    _lastInfJump = now
    local c = LP.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then return end
    local root = c:FindFirstChild("HumanoidRootPart"); if not root then return end
    hum.Jump = true
    applyImpulse(root, hum)
end
UIS.JumpRequest:Connect(function()
    if not InfJumpState.enabled then return end
    if InfJumpState.mode == "hold" then
        if _holdTouch == nil and _lastTouchStart ~= nil and _activeTouches[_lastTouchStart] then
            _holdTouch = _lastTouchStart
        end
        return
    end
    _doInfJump()
end)
local function isGamepad(input)
    local uit = input.UserInputType
    return uit == Enum.UserInputType.Gamepad1 or uit == Enum.UserInputType.Gamepad2 or uit == Enum.UserInputType.Gamepad3 or uit == Enum.UserInputType.Gamepad4 or uit == Enum.UserInputType.Gamepad5 or uit == Enum.UserInputType.Gamepad6 or uit == Enum.UserInputType.Gamepad7 or uit == Enum.UserInputType.Gamepad8
end
UIS.InputBegan:Connect(function(inp)
    if inp.KeyCode ~= Enum.KeyCode.ButtonA or not isGamepad(inp) then return end
    _gamepadBtnHeld = true
    if InfJumpState.enabled and InfJumpState.mode == "manual" then
        _doInfJump()
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.KeyCode ~= Enum.KeyCode.ButtonA or not isGamepad(inp) then return end
    _gamepadBtnHeld = false
end)
UIS.TouchStarted:Connect(function(touch)
    if not InfJumpState.enabled or InfJumpState.mode ~= "hold" then return end
    _activeTouches[touch] = true
    _lastTouchStart = touch
end)
UIS.TouchEnded:Connect(function(touch)
    _activeTouches[touch] = nil
    if _lastTouchStart == touch then _lastTouchStart = nil end
    if _holdTouch == touch then _holdTouch = nil end
end)
RunService.Heartbeat:Connect(function()
    if not InfJumpState.enabled or InfJumpState.mode ~= "hold" then return end
    local c = LP.Character; if not c then return end
    local root = c:FindFirstChild("HumanoidRootPart"); if not root then return end
    local hum = c:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then return end
    local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or _gamepadBtnHeld or (_holdTouch ~= nil)
    if jumpHeld and root.AssemblyLinearVelocity.Y < 30 then
        hum.Jump = true
        applyImpulse(root, hum, 52)
    end
    if root.AssemblyLinearVelocity.Y < -120 then
        applyImpulse(root, hum, -120)
    end
end)

local function getCharParts()
    local char = LP.Character
    if not char then return nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return nil, nil end
    return hum, root
end
local function claimOwnership(root)
    pcall(function()
        root:SetNetworkOwner(LP)
    end)
end

function cleanupSpeedPhysics()
    if speedLinearVelocity then
        speedLinearVelocity:Destroy()
        speedLinearVelocity = nil
    end
    if speedAttachment then
        speedAttachment:Destroy()
        speedAttachment = nil
    end
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    lastPosition = nil
    lastTime = nil
    speedEnabled = false
end

function applySpeedWithLinearVelocity(spd)
    cleanupSpeedPhysics()
    if spd <= 0 then return end
    local hum, root = getCharParts()
    if not hum or not root then return end
    claimOwnership(root)
    speedAttachment = Instance.new("Attachment")
    speedAttachment.Name = "SpeedAttachment"
    speedAttachment.Parent = root
    speedLinearVelocity = Instance.new("LinearVelocity")
    speedLinearVelocity.Name = "SpeedLinearVelocity"
    speedLinearVelocity.Attachment0 = speedAttachment
    speedLinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    speedLinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    speedLinearVelocity.PrimaryTangentAxis = Vector3.new(1, 0, 0)
    speedLinearVelocity.SecondaryTangentAxis = Vector3.new(0, 0, 1)
    speedLinearVelocity.MaxForce = 100000
    speedLinearVelocity.PlaneVelocity = Vector2.zero
    speedLinearVelocity.Enabled = false
    speedLinearVelocity.Parent = root
    lastPosition = root.Position
    lastTime = tick()
    speedEnabled = true
    currentSpeedValue = spd
    local ownershipTimer = 0
    local lagbackCooldown = 0
    speedConnection = RunService.Heartbeat:Connect(function(dt)
        if not speedEnabled then return end
        local hum2, root2 = getCharParts()
        if not hum2 or not root2 or not speedLinearVelocity then
            cleanupSpeedPhysics()
            return
        end
        ownershipTimer = ownershipTimer + dt
        if ownershipTimer >= 1.5 then
            claimOwnership(root2)
            ownershipTimer = 0
        end
        local dir = hum2.MoveDirection
        if dir.Magnitude < 0.1 then
            speedLinearVelocity.Enabled = false
            lastPosition = root2.Position
            lastTime = tick()
            return
        end
        speedLinearVelocity.Enabled = true
        speedLinearVelocity.PlaneVelocity = Vector2.new(dir.X * spd, dir.Z * spd)
        lagbackCooldown = lagbackCooldown - dt
        local now = tick()
        local elapsed = now - lastTime
        if elapsed > 0.1 and lastPosition then
            local expectedDist = spd * elapsed
            local actualDist = (root2.Position - lastPosition).Magnitude
            if actualDist < expectedDist * 0.3 and lagbackCooldown <= 0 then
                speedLinearVelocity.PlaneVelocity = Vector2.new(dir.X * spd * 1.2, dir.Z * spd * 1.2)
                lagbackCooldown = 0.3
            end
        end
        lastPosition = root2.Position
        lastTime = now
    end)
end

-- Animation packs (CK4C4 + Coca-Cola packs)
local ANIM_PACKS = {
    -- Packs de Night Hub (imagen Anim Pack)
    Elder = {
        idle1 = "rbxassetid://10921101664", idle2 = "rbxassetid://10921102574",
        walk = "rbxassetid://10921111375", run = "rbxassetid://10921104374",
        jump = "rbxassetid://10921107367", fall = "rbxassetid://10921105765",
        climb = "rbxassetid://10921100400",
        swim = "rbxassetid://10921108971", swimidle = "rbxassetid://10921110146",
    },
    Zombie = {
        idle1 = "rbxassetid://10921344533", idle2 = "rbxassetid://10921345304",
        walk = "rbxassetid://10921355261", run = "rbxassetid://616163682",
        jump = "rbxassetid://10921351278", fall = "rbxassetid://10921350320",
        climb = "rbxassetid://10921343576",
        swim = "rbxassetid://10921352344", swimidle = "rbxassetid://10921353442",
    },
    Mage = {
        idle1 = "rbxassetid://10921144709", idle2 = "rbxassetid://10921145797",
        walk = "rbxassetid://10921152678", run = "rbxassetid://10921148209",
        jump = "rbxassetid://10921149743", fall = "rbxassetid://10921148939",
        climb = "rbxassetid://10921143404",
        swim = "rbxassetid://10921150788", swimidle = "rbxassetid://10921151661",
    },
    Astronaut = {
        idle1 = "rbxassetid://10921034824", idle2 = "rbxassetid://10921036806",
        walk = "rbxassetid://10921046031", run = "rbxassetid://10921039308",
        jump = "rbxassetid://10921042494", fall = "rbxassetid://10921040576",
        climb = "rbxassetid://10921032124",
        swim = "rbxassetid://10921044000", swimidle = "rbxassetid://10921045006",
    },
    Werewolf = {
        idle1 = "rbxassetid://10921330408", idle2 = "rbxassetid://10921333667",
        walk = "rbxassetid://10921342074", run = "rbxassetid://10921336997",
        jump = "rbxassetid://10921330408", fall = "rbxassetid://10921337907",
        climb = "rbxassetid://10921329322",
        swim = "rbxassetid://10921340419", swimidle = "rbxassetid://10921341319",
    },
    Toy = {
        idle1 = "rbxassetid://10921301576", idle2 = "rbxassetid://10921301576",
        walk = "rbxassetid://10921312010", run = "rbxassetid://10921306285",
        jump = "rbxassetid://10921308158", fall = "rbxassetid://10921307241",
        climb = "rbxassetid://10921300839",
        swim = "rbxassetid://10921309319", swimidle = "rbxassetid://10921310341",
    },
    Vampire = {
        -- Imagen: Anim Pack = Vampire (Night)
        idle1 = "rbxassetid://10921315373", idle2 = "rbxassetid://10921315373",
        walk = "rbxassetid://10921326949", run = "rbxassetid://10921320299",
        jump = "rbxassetid://10921322186", fall = "rbxassetid://10921321317",
        climb = "rbxassetid://10921314188",
        swim = "rbxassetid://10921324408", swimidle = "rbxassetid://10921325443",
    },
    Ninja = {
        idle1 = "rbxassetid://656117400", idle2 = "rbxassetid://656118341",
        walk = "rbxassetid://656121766", run = "rbxassetid://656118852",
        jump = "rbxassetid://656117878", fall = "rbxassetid://656115606",
        climb = "rbxassetid://656114359",
        swim = "rbxassetid://656119721", swimidle = "rbxassetid://656121397",
    },
    Robot = {
        idle1 = "rbxassetid://616088211", idle2 = "rbxassetid://616089559",
        walk = "rbxassetid://616095330", run = "rbxassetid://616091570",
        jump = "rbxassetid://616090535", fall = "rbxassetid://616087089",
        climb = "rbxassetid://616086039",
        swim = "rbxassetid://616092998", swimidle = "rbxassetid://616094091",
    },
    Levitation = {
        idle1 = "rbxassetid://616006778", idle2 = "rbxassetid://616008087",
        walk = "rbxassetid://616013216", run = "rbxassetid://616010382",
        jump = "rbxassetid://616008936", fall = "rbxassetid://616005863",
        climb = "rbxassetid://616003713",
        swim = "rbxassetid://616011509", swimidle = "rbxassetid://616012453",
    },
    Stylish = {
        idle1 = "rbxassetid://616136790", idle2 = "rbxassetid://616138447",
        walk = "rbxassetid://616146177", run = "rbxassetid://616140816",
        jump = "rbxassetid://616139451", fall = "rbxassetid://616134815",
        climb = "rbxassetid://616133594",
        swim = "rbxassetid://616143377", swimidle = "rbxassetid://616144772",
    },
    Bubbly = {
        idle1 = "rbxassetid://910004836", idle2 = "rbxassetid://910009958",
        walk = "rbxassetid://910034870", run = "rbxassetid://910025107",
        jump = "rbxassetid://910016857", fall = "rbxassetid://910001910",
        climb = "rbxassetid://909997997",
        swim = "rbxassetid://910028158", swimidle = "rbxassetid://910030921",
    },
    Cartoon = {
        idle1 = "rbxassetid://742637544", idle2 = "rbxassetid://742638445",
        walk = "rbxassetid://742640026", run = "rbxassetid://742638842",
        jump = "rbxassetid://742637942", fall = "rbxassetid://742637151",
        climb = "rbxassetid://742636889",
        swim = "rbxassetid://742639220", swimidle = "rbxassetid://742639812",
    },
    ["Catwalk Glam"] = {
        idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563",
        walk = "rbxassetid://109168724482748", run = "rbxassetid://81024476153754",
        jump = "rbxassetid://116936326516985", fall = "rbxassetid://92294537340807",
        climb = "rbxassetid://119377220967554",
        swim = "rbxassetid://134591743181628", swimidle = "rbxassetid://98854111361360",
    },
}
local ANIM_PACK_ORDER = {
    {"Off", "Off"},
    {"Vampire", "Vampire"},
    {"Elder", "Elder"},
    {"Zombie", "Zombie"},
    {"Mage", "Mage"},
    {"Astronaut", "Astronaut"},
    {"Werewolf", "Werewolf"},
    {"Toy", "Toy"},
    {"Ninja", "Ninja"},
    {"Robot", "Robot"},
    {"Levitation", "Levitation"},
    {"Stylish", "Stylish"},
    {"Bubbly", "Bubbly"},
    {"Cartoon", "Cartoon"},
    {"Catwalk Glam", "Catwalk Glam"},
}

local function isPackAnim(id)
    for _, pack in pairs(ANIM_PACKS) do
        for _, v in pairs(pack) do
            if v == id then return true end
        end
    end
    return false
end

local function saveOriginalAnims(char)
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids = {
        idle1 = g(animate.idle and animate.idle.Animation1),
        idle2 = g(animate.idle and animate.idle.Animation2),
        walk = g(animate.walk and animate.walk.WalkAnim),
        run = g(animate.run and animate.run.RunAnim),
        jump = g(animate.jump and animate.jump.JumpAnim),
        fall = g(animate.fall and animate.fall.FallAnim),
        climb = g(animate.climb and animate.climb.ClimbAnim),
        swim = g(animate.swim and animate.swim.Swim),
        swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
    }
    if not isPackAnim(ids.walk) then originalTryardAnims = ids end
end

local function _ensureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then
        a = Instance.new("Animation")
        a.Name = name
        a.Parent = folder
    end
    return a
end

local function _setAnimId(obj, id)
    if not obj or not id then return end
    local sid = tostring(id)
    if not sid:find("rbxassetid://") then
        sid = "rbxassetid://" .. sid:gsub("%D", "")
    end
    pcall(function() obj.AnimationId = sid end)
end

-- Aplicación estilo Night: set IDs + reiniciar Animate (más fiel a Night Hub)
local function applyAnimPack(packName)
    currentAnimPack = packName
    if animSelectorLabel then animSelectorLabel.Text = packName end
    if tryardHeartbeatConn then
        pcall(function() tryardHeartbeatConn:Disconnect() end)
        tryardHeartbeatConn = nil
    end

    local function applyOnce(char)
        if not char then return end
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local hum = char:FindFirstChildOfClass("Humanoid")

        if packName == "Off" then
            if originalTryardAnims then
                _setAnimId(_ensureAnim(animate:FindFirstChild("idle"), "Animation1"), originalTryardAnims.idle1)
                _setAnimId(_ensureAnim(animate:FindFirstChild("idle"), "Animation2"), originalTryardAnims.idle2)
                _setAnimId(_ensureAnim(animate:FindFirstChild("walk"), "WalkAnim"), originalTryardAnims.walk)
                _setAnimId(_ensureAnim(animate:FindFirstChild("run"), "RunAnim"), originalTryardAnims.run)
                _setAnimId(_ensureAnim(animate:FindFirstChild("jump"), "JumpAnim"), originalTryardAnims.jump)
                _setAnimId(_ensureAnim(animate:FindFirstChild("fall"), "FallAnim"), originalTryardAnims.fall)
                _setAnimId(_ensureAnim(animate:FindFirstChild("climb"), "ClimbAnim"), originalTryardAnims.climb)
                _setAnimId(_ensureAnim(animate:FindFirstChild("swim"), "Swim"), originalTryardAnims.swim)
                _setAnimId(_ensureAnim(animate:FindFirstChild("swimidle"), "SwimIdle"), originalTryardAnims.swimidle)
            end
        else
            local pack = ANIM_PACKS[packName]
            if not pack then return end
            if hum then
                for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
                    pcall(function() t:Stop(0) end)
                end
            end
            _setAnimId(_ensureAnim(animate:FindFirstChild("idle"), "Animation1"), pack.idle1)
            _setAnimId(_ensureAnim(animate:FindFirstChild("idle"), "Animation2"), pack.idle2)
            _setAnimId(_ensureAnim(animate:FindFirstChild("walk"), "WalkAnim"), pack.walk)
            _setAnimId(_ensureAnim(animate:FindFirstChild("run"), "RunAnim"), pack.run)
            _setAnimId(_ensureAnim(animate:FindFirstChild("jump"), "JumpAnim"), pack.jump)
            _setAnimId(_ensureAnim(animate:FindFirstChild("fall"), "FallAnim"), pack.fall)
            _setAnimId(_ensureAnim(animate:FindFirstChild("climb"), "ClimbAnim"), pack.climb)
            _setAnimId(_ensureAnim(animate:FindFirstChild("swim"), "Swim"), pack.swim)
            _setAnimId(_ensureAnim(animate:FindFirstChild("swimidle"), "SwimIdle"), pack.swimidle)
        end

        -- Reinicio Animate como Night (clave para que se vea igual)
        pcall(function()
            animate.Disabled = true
            task.wait(0.08)
            animate.Disabled = false
        end)
        if hum then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.Landed)
                task.wait(0.04)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
    end

    local char = LP.Character
    if char then
        task.spawn(function() applyOnce(char) end)
    end

    -- Mantener IDs por si el juego los resetea (sin parar tracks ajenos)
    if packName ~= "Off" and ANIM_PACKS[packName] then
        local pack = ANIM_PACKS[packName]
        tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
            local c = LP.Character
            if not c then return end
            local animate = c:FindFirstChild("Animate")
            if not animate then return end
            _setAnimId(animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation1"), pack.idle1)
            _setAnimId(animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation2"), pack.idle2)
            _setAnimId(animate:FindFirstChild("walk") and animate.walk:FindFirstChild("WalkAnim"), pack.walk)
            _setAnimId(animate:FindFirstChild("run") and animate.run:FindFirstChild("RunAnim"), pack.run)
            _setAnimId(animate:FindFirstChild("jump") and animate.jump:FindFirstChild("JumpAnim"), pack.jump)
            _setAnimId(animate:FindFirstChild("fall") and animate.fall:FindFirstChild("FallAnim"), pack.fall)
            _setAnimId(animate:FindFirstChild("climb") and animate.climb:FindFirstChild("ClimbAnim"), pack.climb)
            _setAnimId(animate:FindFirstChild("swim") and animate.swim:FindFirstChild("Swim"), pack.swim)
            _setAnimId(animate:FindFirstChild("swimidle") and animate.swimidle:FindFirstChild("SwimIdle"), pack.swimidle)
        end)
    end
end

local function startAnimPack(packName)
    local char = LP.Character
    if char then
        saveOriginalAnims(char)
        applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                track:Stop(0)
            end
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    else
        applyAnimPack(packName)
    end
    currentAnimPack = packName
end

local function stopAnimPack()
    currentAnimPack = "Off"
    if animSelectorLabel then animSelectorLabel.Text = "Off" end
    applyAnimPack("Off")
end

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X, gp = nil},
    AutoLeft = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight = {kb = Enum.KeyCode.C, gp = nil},
    AutoBat = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor = {kb = Enum.KeyCode.F, gp = nil},
    GuiHide = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle = {kb = Enum.KeyCode.Q, gp = nil},
    LaggerMode = {kb = Enum.KeyCode.R, gp = nil},
    InstaReset = {kb = Enum.KeyCode.G, gp = nil},
    TPLock = {kb = Enum.KeyCode.B, gp = nil},
    BatV2 = {kb = Enum.KeyCode.N, gp = nil},  
}

KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoLeft = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp},
    AutoRight = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp},
    AutoBat = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp},
    TPFloor = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp},
    GuiHide = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp},
    CarryToggle = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp},
    LaggerMode = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp},
    InstaReset = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
    TPLock = {kb = DEFAULT_KB.TPLock.kb, gp = DEFAULT_KB.TPLock.gp},
    BatV2 = {kb = DEFAULT_KB.BatV2.kb, gp = DEFAULT_KB.BatV2.gp},  
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false


-- ============================================================
-- ============================================================
-- AUTO STEAL = Original CK4C4 Auto Steal (restored)
-- ============================================================

CONFIG = {
    AUTO_STEAL_ENABLED = false,
    HOLD_MIN = 1.3,
    HOLD_MAX = 2.6,
    ENTRY_DELAY = 0.3,
    COOLDOWN = 0.05,
    STEAL_RANGE = 8,
    PRIME_RANGE = 80,
}

StealState = {
    active = false,
    startTime = 0,
    phase = "idle",
    label = "",
    lastResult = "",
    lastResultTime = 0,
    totalSteals = 0,
    failedSteals = 0,
}

savedStealRadius = CONFIG.STEAL_RANGE
savedStealDuration = CONFIG.HOLD_MAX

local getconnections = getconnections or (getgenv and getgenv().getconnections) or get_signal_cons or (syn and syn.get_signal_cons)

local plots = workspace:WaitForChild("Plots")
local AnimalsData = {}
local syncRemotes = nil
local plotAnimalSync = { caches = {}, connections = {} }
local allAnimalsCache = {}
local PromptMemoryCache = {}
local InternalStealCache = {}
local stealConnection = nil

local function splitSyncPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for part in string.gmatch(tostring(path), "[^%.]+") do
        table.insert(out, tonumber(part) or part)
    end
    return out
end

local function resolveSyncPath(path, root)
    local current = root
    local parent = nil
    local key = nil
    for _, part in ipairs(splitSyncPath(path)) do
        parent = current
        key = part
        current = current and current[part] or nil
    end
    return current, parent, key
end

local function applyPlotSyncDiff(channelName, packet)
    local cache = plotAnimalSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local current, parent, key = resolveSyncPath(path, cache)
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

local function attachPlotChannel(remote)
    if plotAnimalSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
        local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
        if ok and typeof(data) == "table" then
            plotAnimalSync.caches[channelName] = data
        else
            plotAnimalSync.caches[channelName] = {}
        end
    elseif plotAnimalSync.caches[channelName] == nil then
        plotAnimalSync.caches[channelName] = {}
    end
    plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do
            applyPlotSyncDiff(channelName, packet)
        end
    end)
end

local function detachPlotChannel(channelName)
    for remote, conn in pairs(plotAnimalSync.connections) do
        if tostring(remote.Name) == tostring(channelName) then
            conn:Disconnect()
            plotAnimalSync.connections[remote] = nil
            plotAnimalSync.caches[tostring(channelName)] = nil
            break
        end
    end
end

local function getPlotChannelData(plotName)
    return plotAnimalSync.caches[plotName]
end

local function getPlotOwner(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then return false end
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    return getPlotOwner(plot) == LP.DisplayName
end

local function findProximityPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached = PromptMemoryCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    local base = podium:FindFirstChild("Base")
    if not base then return nil end
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    local attach = spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then
            PromptMemoryCache[animalData.uid] = p
            return p
        end
    end
    return nil
end

local function getAnimalPosition(animalData)
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    return podium:GetPivot().Position
end

local function distToAnimal(animalData)
    local character = LP.Character
    if not character then return math.huge end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return math.huge end
    local pos = getAnimalPosition(animalData)
    if not pos then return math.huge end
    return (hrp.Position - pos).Magnitude
end

local function pickClosest()
    local character = LP.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(allAnimalsCache) do
        if isMyBaseAnimal(animalData) then continue end
        local pos = getAnimalPosition(animalData)
        if not pos then continue end
        local dist = (hrp.Position - pos).Magnitude
        if dist > CONFIG.PRIME_RANGE then continue end
        if dist < bestDist then
            bestDist = dist
            best = animalData
        end
    end
    return best
end

local function scanAllPlots()
    local newCache = {}
    for _, plot in ipairs(plots:GetChildren()) do
        local cache = getPlotChannelData(plot.Name)
        if not cache then continue end
        local animalList = cache.AnimalList
        if typeof(animalList) ~= "table" then continue end
        for slot, animalData in pairs(animalList) do
            if type(animalData) == "table" then
                local animalName = animalData.Index
                local animalInfo = AnimalsData[animalName]
                if not animalInfo then continue end
                table.insert(newCache, {
                    name = animalInfo.DisplayName or animalName,
                    plot = plot.Name,
                    slot = tostring(slot),
                    uid = plot.Name .. "_" .. tostring(slot),
                })
            end
        end
    end
    allAnimalsCache = newCache
    return #allAnimalsCache
end

local function buildStealCallbacks(prompt)
    if InternalStealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1) == "table" then
        for _, conn in ipairs(conns1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(conns2) == "table" then
        for _, conn in ipairs(conns2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then
        InternalStealCache[prompt] = data
    end
end

local function executeStealAsync(prompt, animalData)
    local data = InternalStealCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    local label = animalData.name or "Animal"
    StealState.active = true
    StealState.startTime = tick()
    StealState.phase = "holding"
    StealState.label = label
    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do
            task.spawn(fn)
        end
        task.wait(CONFIG.HOLD_MIN)
        StealState.phase = "waitingRange"
        local alreadyInRange = distToAnimal(animalData) <= CONFIG.STEAL_RANGE
        local fired = false
        while true do
            local elapsed = tick() - StealState.startTime
            if elapsed > CONFIG.HOLD_MAX then break end
            if not prompt.Parent then break end
            if distToAnimal(animalData) <= CONFIG.STEAL_RANGE then
                if not alreadyInRange then
                    task.wait(CONFIG.ENTRY_DELAY)
                end
                for _, fn in ipairs(data.triggerCallbacks) do
                    task.spawn(fn)
                end
                fired = true
                break
            end
            task.wait()
        end
        if fired then
            StealState.totalSteals = StealState.totalSteals + 1
            StealState.lastResult = "Stole " .. label
        else
            StealState.failedSteals = StealState.failedSteals + 1
            StealState.lastResult = "Missed window: " .. label
        end
        StealState.active = false
        StealState.phase = "idle"
        StealState.lastResultTime = tick()
        task.wait(CONFIG.COOLDOWN)
        data.ready = true
    end)
    return true
end


-- ============================================================
-- PROTECCIÓN: no soltar brainrot / tool en mano (duelos)
-- ============================================================
local function isBatLikeTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = tool.Name:lower()
    return n:find("bat") or n:find("slap") or n:find("sword") or n:find("weapon")
end

local function getHeldTool()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Tool")
end

-- true si llevas algo que NO es arma (brainrot / pet / animal en mano)
local function isHoldingCarryItem()
    local tool = getHeldTool()
    if not tool then return false end
    if isBatLikeTool(tool) then return false end
    return true
end

local function attemptSteal(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    if isHoldingCarryItem() then return false end
    buildStealCallbacks(prompt)
    if not InternalStealCache[prompt] then return false end
    return executeStealAsync(prompt, animalData)
end


function startAutoSteal()
    if stealConnection then return end
    stealConnection = RunService.Heartbeat:Connect(function()
        if not CONFIG.AUTO_STEAL_ENABLED then return end
        if StealState.active then return end
        -- Si ya llevas brainrot/tool en mano, NO iniciar otro steal (evita que se suelte)
        if isHoldingCarryItem() then return end
        local target = pickClosest()
        if not target then return end
        local prompt = PromptMemoryCache[target.uid]
        if not prompt or not prompt.Parent then
            prompt = findProximityPromptForAnimal(target)
        end
        if prompt then
            attemptSteal(prompt, target)
        end
    end)
end

function stopAutoSteal()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    StealState.active = false
    StealState.phase = "idle"
end

do
    local Packages = ReplicatedStorage:WaitForChild("Packages")
    local Datas = ReplicatedStorage:WaitForChild("Datas")
    AnimalsData = require(Datas:WaitForChild("Animals"))
    local folder = Packages:WaitForChild("Synchronizer")
    syncRemotes = {
        channelFolder = folder:WaitForChild("Channel"),
        routeRemote = folder:WaitForChild("CommunicationRoute"),
        requestData = folder:FindFirstChild("RequestData"),
    }
    for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then
            attachPlotChannel(child)
        end
    end
    syncRemotes.channelFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then
            attachPlotChannel(child)
        end
    end)
    syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
        for _, action in ipairs(actions) do
            local kind, channelName = action[1], tostring(action[2])
            if not plots:FindFirstChild(channelName) then continue end
            if kind == "ListenerAdded" then
                local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
                if remote and remote:IsA("RemoteEvent") then
                    attachPlotChannel(remote)
                end
            elseif kind == "ListenerRemoved" then
                detachPlotChannel(channelName)
            end
        end
    end)
    scanAllPlots()
end

task.spawn(function()
    while task.wait(5) do
        scanAllPlots()
    end
end)

function toggleAutoSteal()
    if CONFIG.AUTO_STEAL_ENABLED then
        CONFIG.AUTO_STEAL_ENABLED = false
        stopAutoSteal()
        if setInstaGrab then pcall(setInstaGrab, false) end
    else
        CONFIG.AUTO_STEAL_ENABLED = true
        startAutoSteal()
        if setInstaGrab then pcall(setInstaGrab, true) end
    end
end


medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = Vector3.new(0,0,0)
origFOV = 70
GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
autoResetStates = {
    BALLOON = false,
    JAIL = false,
    TINY = false,
    RAGDOLL = false,
    ROCKET = false
}
_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil
tpLockEnabled = false
tpLockSetVisual = nil
tpLockConn = nil
tpLockPrevAutoRotate = nil
tpLockHitCD = false
TP_LOCK_SWING_CD = 0.08
tpBatFloatingButton = nil
batV2FloatingButton = nil
enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
stretchConn = nil
stretchFovConn = nil
antiLagDescConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
progressRadLbl = nil
pbFrame = nil
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil
modeSelectBtn, dropModeBtnRef = nil, nil
setJumpToggleState = nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual, setMedusaAutoResetVisual = nil, nil, nil, nil, nil, nil
setAntiRagVisual, setJumpVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil, nil
setEditModeVisual = nil
setESPVIsual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil, nil, nil, nil, nil, nil, nil, nil
autoBatV2SetVisual = nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
instaResetFloatingButton = nil
showGui = nil
hideGui = nil
mainUIScale = nil
animSelectorLabel = nil
pbScale = nil
fovToggleBtn = nil
fovContainer = nil
GAMEPAD_KEYS = {
    [Enum.KeyCode.ButtonA] = true,
    [Enum.KeyCode.ButtonB] = true,
    [Enum.KeyCode.ButtonX] = true,
    [Enum.KeyCode.ButtonY] = true,
    [Enum.KeyCode.ButtonL1] = true,
    [Enum.KeyCode.ButtonR1] = true,
    [Enum.KeyCode.ButtonL2] = true,
    [Enum.KeyCode.ButtonR2] = true,
    [Enum.KeyCode.ButtonL3] = true,
    [Enum.KeyCode.ButtonR3] = true,
    [Enum.KeyCode.ButtonStart] = true,
    [Enum.KeyCode.ButtonSelect] = true,
    [Enum.KeyCode.DPadUp] = true,
    [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true,
    [Enum.KeyCode.DPadRight] = true,
}
MOVE_KEYS = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true,
    [Enum.KeyCode.Right] = true,
}
BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}
AP = {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    L_FACE = Vector3.new(-482.25, -4.96, 92.09),
    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.06, -5.03, 25.48),
    R_FACE = Vector3.new(-482.06, -6.93, 35.47),
}

function isGamepadInput(inp)
    return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end

function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end

function kbMatch(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

local function doTpDownOriginal()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.CFrame = CFrame.new(
            root.Position.X, -7, root.Position.Z
        ) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
        root.Velocity = Vector3.zero
    end)
end
doTpDown = doTpDownOriginal

local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdoll()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
        local state = hum:GetState()
        local now = tick()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") then obj.Enabled = true end
                        if obj:IsA("Constraint") then obj.Enabled = true end
                    end
                    workspace.CurrentCamera.CameraSubject = hum
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = require(PM:FindFirstChild("ControlModule"))
                        if CM then
                            CM:Enable()
                        end
                    end
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
        end
    end)
end

local function stopAntiRagdoll()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end
    AntiRagdollV2.ResetCooldown = 0
end

local function setAntiRag(on)
    antiRagdollEnabled = on
    if on then startAntiRagdoll() else stopAntiRagdoll() end
    if setAntiRagVisual then setAntiRagVisual(on) end
end

do
    local _ragCountdownRunning = false
    local function _getRagBillboard()
        local char = LP.Character
        if not char then return nil, nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil, nil end
        local pGui = LP.PlayerGui
        local existing = pGui:FindFirstChild("RagCountdownBillboard")
        if existing then existing:Destroy() end
        local bb = Instance.new("BillboardGui")
        bb.Name = "RagCountdownBillboard"
        bb.Size = UDim2.new(0, 84, 0, 42)
        bb.StudsOffset = Vector3.new(0, 4.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = head
        bb.Parent = pGui
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Fantasy
        lbl.TextScaled = true
        lbl.TextColor3 = Color3.fromRGB(180, 180, 190)
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextStrokeTransparency = 0
        lbl.Text = ""
        lbl.Parent = bb
        return bb, lbl
    end

    local function _ragPunch(lbl, text)
        if not (lbl and lbl.Parent) then return end
        lbl.Text = text
    end

    local function _startRagCountdown()
        if _ragCountdownRunning then return end
        _ragCountdownRunning = true
        task.spawn(function()
            local bb, lbl = _getRagBillboard()
            if not bb then _ragCountdownRunning = false; return end
            local timeLeft = 2.5
            local step = 0.1
            while timeLeft > 0 and bb.Parent do
                _ragPunch(lbl, string.format("%.1f", timeLeft))
                task.wait(step)
                timeLeft = timeLeft - step
            end
            if bb and bb.Parent then
                _ragPunch(lbl, "READY!")
                task.wait(0.5)
                if bb and bb.Parent then
                    bb:Destroy()
                end
            end
            _ragCountdownRunning = false
        end)
    end

    local _wasRagdolled = false
    RunService.Heartbeat:Connect(function()
        local char = LP.Character
        if not char then _wasRagdolled = false; return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then _wasRagdolled = false; return end
        local st = hum:GetState()
        local inRag = st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
        if inRag and not _wasRagdolled then
            _wasRagdolled = true
            _startRagCountdown()
        elseif not inRag then
            _wasRagdolled = false
        end
    end)
end

local function setupChar(char)
    if antiRagdollEnabled then
        task.wait(0.5)
        startAntiRagdoll()
    end
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then
    task.spawn(function() setupChar(LP.Character) end)
end

local espHighlightCache = {}
local espBillboardCache = {}
local espTracerCache = {}
local espConn = nil
local _espLastRun = 0
profileImageCache = {}

local function clearESP()
    for plr in pairs(espHighlightCache) do
        pcall(function() espHighlightCache[plr]:Destroy() end)
    end
    for plr in pairs(espBillboardCache) do
        pcall(function() espBillboardCache[plr]:Destroy() end)
    end
    for plr in pairs(espTracerCache) do
        for _, ln in ipairs(espTracerCache[plr]) do
            pcall(function() ln.Visible = false; ln:Remove() end)
        end
    end
    espHighlightCache = {}
    espBillboardCache = {}
    espTracerCache = {}
end

local function makeESPTracers()
    if not (Drawing and type(Drawing.new) == "function") then return nil end
    local WHITE = Color3.fromRGB(255, 255, 255)
    local outer = Drawing.new("Line")
    outer.Color = WHITE
    outer.Thickness = 2.2
    outer.Transparency = 0.90
    outer.Visible = false
    local mid = Drawing.new("Line")
    mid.Color = WHITE
    mid.Thickness = 1.2
    mid.Transparency = 0.74
    mid.Visible = false
    local core = Drawing.new("Line")
    core.Color = WHITE
    core.Thickness = 0.6
    core.Transparency = 0.10
    core.Visible = false
    return {outer, mid, core}
end

local function updateESP()
    local now = tick()
    if now - _espLastRun < 0.03 then return end
    _espLastRun = now
    if not espEnabled then clearESP(); return end
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myPos = myRoot.Position
    local myScreenPos, myOnScreen = camera:WorldToViewportPoint(myPos)
    local myVec = Vector2.new(myScreenPos.X, myScreenPos.Y)
    local currentPlayers = Players:GetPlayers()
    local plrSet = {}
    for _, p in ipairs(currentPlayers) do plrSet[p] = true end
    for plr in pairs(espHighlightCache) do
        if not plrSet[plr] then
            pcall(function() espHighlightCache[plr]:Destroy() end)
            espHighlightCache[plr] = nil
        end
    end
    for plr in pairs(espBillboardCache) do
        if not plrSet[plr] then
            pcall(function() espBillboardCache[plr]:Destroy() end)
            espBillboardCache[plr] = nil
        end
    end
    for plr in pairs(espTracerCache) do
        if not plrSet[plr] then
            for _, ln in ipairs(espTracerCache[plr]) do
                pcall(function() ln.Visible = false; ln:Remove() end)
            end
            espTracerCache[plr] = nil
        end
    end
    for _, plr in ipairs(currentPlayers) do
        if plr == LP then continue end
        local char = plr.Character
        if not char then
            if espHighlightCache[plr] then
                pcall(function() espHighlightCache[plr]:Destroy() end)
                espHighlightCache[plr] = nil
            end
            if espBillboardCache[plr] then
                pcall(function() espBillboardCache[plr]:Destroy() end)
                espBillboardCache[plr] = nil
            end
            if espTracerCache[plr] then
                for _, ln in ipairs(espTracerCache[plr]) do
                    pcall(function() ln.Visible = false end)
                end
            end
            continue
        end
        local tRoot = char:FindFirstChild("HumanoidRootPart")
        local tHead = char:FindFirstChild("Head")
        local tHum = char:FindFirstChildOfClass("Humanoid")
        local alive = tRoot and tHead and tHum and tHum.Health > 0
        if alive then
            local hl = espHighlightCache[plr]
            if not hl or not hl.Parent or hl.Parent ~= char then
                if hl then pcall(function() hl:Destroy() end) end
                hl = Instance.new("Highlight")
                hl.Name = "VeneyorkESP"
                hl.FillColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.72
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineTransparency = 0.05
                hl.Adornee = char
                hl.Parent = char
                espHighlightCache[plr] = hl
            end
            local bb = espBillboardCache[plr]
            if not bb or not bb.Parent then
                if bb then pcall(function() bb:Destroy() end) end
                bb = Instance.new("BillboardGui")
                bb.Name = "ProfilePic"
                bb.Size = UDim2.new(0, 56, 0, 56)
                bb.StudsOffset = Vector3.new(0, 3.8, 0)
                bb.Adornee = tHead
                bb.AlwaysOnTop = true
                bb.Parent = tHead
                local img = Instance.new("ImageLabel", bb)
                img.Size = UDim2.new(1, -6, 1, -6)
                img.Position = UDim2.new(0, 3, 0, 3)
                img.BackgroundTransparency = 1
                img.Image = "rbxassetid://0"
                img.ScaleType = Enum.ScaleType.Fit
                local circle = Instance.new("UICorner", img)
                circle.CornerRadius = UDim.new(1, 0)
                local stroke = Instance.new("UIStroke", img)
                stroke.Color = Color3.fromRGB(255, 255, 255)
                stroke.Thickness = 1.5
                espBillboardCache[plr] = bb
                task.spawn(function()
                    local userId = plr.UserId
                    local url = profileImageCache[userId]
                    if not url then
                        local success, u = pcall(function() return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
                        if success and u and u ~= "" then
                            url = u
                            profileImageCache[userId] = url
                        else
                            url = "rbxassetid://0"
                        end
                    end
                    if img then img.Image = url end
                end)
            else
                if bb.Adornee ~= tHead then bb.Adornee = tHead end
                bb.Enabled = true
            end
            local lines = espTracerCache[plr]
            if not lines then
                lines = makeESPTracers()
                espTracerCache[plr] = lines or {}
            end
            if lines and #lines > 0 then
                local destPos = tRoot.Position
                local pos, onScreen = camera:WorldToViewportPoint(destPos)
                if onScreen and pos.Z > 0 and myOnScreen then
                    local tVec = Vector2.new(pos.X, pos.Y)
                    for _, ln in ipairs(lines) do
                        ln.From = myVec
                        ln.To = tVec
                        ln.Visible = true
                    end
                else
                    for _, ln in ipairs(lines) do
                        ln.Visible = false
                    end
                end
            end
        else
            if espHighlightCache[plr] then
                pcall(function() espHighlightCache[plr]:Destroy() end)
                espHighlightCache[plr] = nil
            end
            if espBillboardCache[plr] then
                pcall(function() espBillboardCache[plr]:Destroy() end)
                espBillboardCache[plr] = nil
            end
            if espTracerCache[plr] then
                for _, ln in ipairs(espTracerCache[plr]) do
                    pcall(function() ln.Visible = false end)
                end
            end
        end
    end
end

local function startESPLoop()
    if espConn then espConn:Disconnect() end
    espConn = RunService.RenderStepped:Connect(updateESP)
end

local function stopESPLoop()
    if espConn then espConn:Disconnect(); espConn = nil end
    clearESP()
end

function toggleESP(on)
    espEnabled = on
    if on then startESPLoop() else stopESPLoop() end
    if setESPVIsual then setESPVIsual(on) end
end

function updateEnemySpeedLabels()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local velocity = hrp.AssemblyLinearVelocity
                local speed = (Vector3.new(velocity.X, 0, velocity.Z).Magnitude)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = Vector3.new(0, 5.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        local textLabel = Instance.new("TextLabel", bb)
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = string.format("%.1f", speed)
                        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        textLabel.Font = Enum.Font.Fantasy
                        textLabel.TextScaled = true
                        textLabel.TextStrokeTransparency = 0
                        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        label = textLabel
                        enemySpeedLabels[player] = label
                    end
                elseif label and label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then
                        label.Parent.Parent = head
                    end
                end
                if label then
                    label.Text = string.format("%.1f", speed)
                end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then
                    label.Parent.Parent = nil
                end
                enemySpeedLabels[player] = nil
            end
        end
    end
    for player, label in pairs(enemySpeedLabels) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            if label and label.Parent and label.Parent.Parent then
                label.Parent.Parent = nil
            end
            enemySpeedLabels[player] = nil
        end
    end
end

function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(function()
        updateEnemySpeedLabels()
    end)
end

function stopEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
end

local function getClosestTargetBody()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

local function _bodyLockTick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local target = getClosestTargetBody()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = math.clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = math.clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = Vector3.new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    _bodyLockConn = RunService.RenderStepped:Connect(function()
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() _bodyLockConn = nil end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function _suppressBodyLock()
    _blSuppressCount = _blSuppressCount + 1
    if _blSuppressCount == 1 and bodyLockEnabled then
        _blWasEnabled = true
        stopBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(false) end
        if _blRestoreTimer then task.cancel(_blRestoreTimer) _blRestoreTimer = nil end
        _blSmoothRestore = false
    end
end

function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then _blSuppressCount = _blSuppressCount - 1 end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        local function restore()
            if bodyLockEnabled then
                _blSmoothRestore = true
                startBodyLock()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                task.delay(0.5, function() _blSmoothRestore = false end)
            end
            _blRestoreTimer = nil
        end
        if delayed then
            _blRestoreTimer = task.delay(1, restore)
        else
            restore()
        end
    end
end

function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() t:Stop() end)
        end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        unwalkSavedAnimate = anim:Clone()
        anim:Destroy()
    end
end

function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then
                starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then
                unwalkSavedAnimate:Clone().Parent = c
            end
        end
    end
    unwalkSavedAnimate = nil
end

function refreshSpeedModeLabel()
    if modeValLbl then
        if laggerToggled then
            modeValLbl.Text = laggerLevel == 1 and "Lagger Spd 1" or "Lagger Spd 2"
        elseif speedMode then
            modeValLbl.Text = "Carry Mode"
        else
            modeValLbl.Text = "Normal"
        end
    end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel == 1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel == 2) end
end

function toggleCarryMode()
    if laggerToggled then
        laggerToggled = false
        laggerLevel = 1
        speedMode = true
    else
        speedMode = not speedMode
        if speedMode then
            laggerToggled = false
            laggerLevel = 1
        end
    end
    resetMovementState()
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false
        if mobSetCarry then mobSetCarry(false) end
    end
    if not laggerToggled then
        laggerToggled = true
        laggerLevel = 1
    else
        laggerLevel = (laggerLevel == 1) and 2 or 1
    end
    resetMovementState()
end

task.spawn(function()
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            obj.OnClientEvent:Connect(function(...)
                for _, arg in ipairs({...}) do
                    if type(arg) == "string" then
                        local msg = arg:lower()
                        if msg:find("jump higher") and autoResetStates.BALLOON then instareset("balloon")
                        elseif msg:find("jail") and autoResetStates.JAIL then instareset("jail")
                        elseif msg:find("tiny") and autoResetStates.TINY then instareset("tiny")
                        elseif msg:find("ragdoll") and autoResetStates.RAGDOLL then instareset("ragdoll")
                        elseif msg:find("rocket") and autoResetStates.ROCKET then instareset("rocket")
                        end
                    end
                end
            end)
        end
    end
end)

function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    _unsuppressBodyLock(true)
end

function startAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local tgt = Vector3.new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = Vector3.new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)
                local facePos = Vector3.new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    _unsuppressBodyLock(true)
end

function startAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local tgt = Vector3.new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = Vector3.new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)
                local facePos = Vector3.new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

function trySwing()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
end

function stopAimbotAdapt()
    if _aimbotConn then
        pcall(function() _aimbotConn:Disconnect() end)
        _aimbotConn = nil
    end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end
    _prevAutoRotate = nil
    lastMoveDir = Vector3.zero
    _unsuppressBodyLock(true)
end

function startAimbotAdapt()
    if _aimbotConn then return end
    _suppressBodyLock()
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then
                pcall(function() hum:EquipTool(bat) end)
            end
        end
        local target = getClosestTarget()
        if not target then return end
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then
            flatDir = flatDir.Unit
        else
            flatDir = Vector3.new(0,0,0)
        end
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * BAT_AIMBOT_SPEED, yVel, flatDir.Z * BAT_AIMBOT_SPEED)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
        end
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then
            trySwing()
        end
    end)
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

function enableAutoBat()
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end
    if tpLockEnabled then toggleAntiDesyncAimbot() end
    if autoBatV2Enabled then disableBatV2() end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

local function findAnyToolV2()
    local c = LP.Character
    if c then
        for _, v in ipairs(c:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end
    return nil
end

local function getClosestPlayerV2()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, math.huge end
    local closest, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local ph = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and ph and ph.Health > 0 then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < bestDist then
                    bestDist = d; closest = p
                end
            end
        end
    end
    return closest, bestDist
end

local function tryHitBatV2()
    if autoBatV2HitCooldown or not autoBatV2SwingEnabled then return end
    -- No tocar brainrot en mano
    if isHoldingCarryItem and isHoldingCarryItem() then return end
    autoBatV2HitCooldown = true
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local tool = findAnyToolV2()
        -- Solo armas/bat; nunca activar el brainrot
        if tool and isBatLikeTool(tool) then
            if tool.Parent ~= char and hum then
                pcall(function() hum:EquipTool(tool) end)
            end
            local remote = tool:FindFirstChildOfClass("RemoteEvent")
            if remote then
                pcall(function() remote:FireServer() end)
            else
                pcall(function() tool:Activate() end)
            end
        end
    end
    task.delay(AUTO_BAT_V2_SWING_CD, function()
        autoBatV2HitCooldown = false
    end)
end

local function startBatV2Aimbot()
    if _batV2Conn then return end
    _batV2Conn = RunService.Heartbeat:Connect(function()
        if not autoBatV2Enabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local target, dist = getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetVel = targetRoot.AssemblyLinearVelocity or targetRoot.Velocity
                local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector
                local offset = moveDir * AUTO_BAT_V2_DIST + Vector3.new(0, AUTO_BAT_V2_HEIGHT + AUTO_BAT_V2_V_OFF, 0)
                local desiredPos = targetRoot.Position + offset
                local toTarget = desiredPos - root.Position
                if toTarget.Magnitude > 0.5 then
                    local moveVec = toTarget.Unit * AUTO_BAT_V2_SPEED
                    root.AssemblyLinearVelocity = Vector3.new(moveVec.X, moveVec.Y, moveVec.Z)
                else
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                    if root.AssemblyLinearVelocity.Magnitude < 1 then
                        root.AssemblyLinearVelocity = Vector3.zero
                    end
                end
                local distToTarget = (root.Position - targetRoot.Position).Magnitude
                if distToTarget <= AUTO_BAT_V2_HIT_DIST then
                    tryHitBatV2()
                end
            end
        else
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
            if root.AssemblyLinearVelocity.Magnitude < 1 then
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end

local function stopBatV2Aimbot()
    if _batV2Conn then
        _batV2Conn:Disconnect()
        _batV2Conn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
    end
    autoBatV2HitCooldown = false
end

function enableBatV2()
    if autoBatV2Enabled then return end
    if autoBatEnabled then disableAutoBat() end
    if tpLockEnabled then toggleAntiDesyncAimbot() end
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    autoBatV2Enabled = true
    startBatV2Aimbot()
    if autoBatV2SetVisual then autoBatV2SetVisual(true) end
    if batV2FloatingButton then
        local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
        if btnFrame then
            btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            local label = btnFrame:FindFirstChild("TextLabel")
            if label then
                label.TextColor3 = Color3.fromRGB(0,0,0)
            end
        end
    end
end

function disableBatV2()
    if not autoBatV2Enabled then return end
    autoBatV2Enabled = false
    stopBatV2Aimbot()
    if autoBatV2SetVisual then autoBatV2SetVisual(false) end
    if batV2FloatingButton then
        local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
        if btnFrame then
            btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
            local label = btnFrame:FindFirstChild("TextLabel")
            if label then
                label.TextColor3 = Color3.fromRGB(255,255,255)
            end
        end
    end
end

function toggleBatV2()
    if autoBatV2Enabled then disableBatV2() else enableBatV2() end
end

_G.AceAntiDesync = _G.AceAntiDesync or {
    conn = nil,
    hittingCooldown = false,
    h = nil,
    hrp = nil
}
_G.AceAntiDesyncAimbotOn = false
antiDesyncAutoSwingEnabled = true

local function getBatAntiDesync()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = char:FindFirstChild(name)
        if tool and tool:IsA("Tool") then
            return tool
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            local tool = bp:FindFirstChild(name)
            if tool and tool:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(tool) end) end
                return tool
            end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    return nil
end

local function trySwingAntiDesync()
    if _G.AceAntiDesync.hittingCooldown then return end
    _G.AceAntiDesync.hittingCooldown = true
    pcall(function()
        local bat = getBatAntiDesync()
        if bat then
            if bat.Parent ~= LP.Character then
                local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
        end
    end)
    task.delay(0.08, function()
        if _G.AceAntiDesync then _G.AceAntiDesync.hittingCooldown = false end
    end)
end

local function getClosestPlayerAntiDesync()
    local hrp = _G.AceAntiDesync and _G.AceAntiDesync.hrp
    if not hrp then return nil, math.huge end
    local closest, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local ph = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and ph and ph.Health > 0 then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < bestDist then
                    bestDist = d; closest = p
                end
            end
        end
    end
    return closest, bestDist
end

local function setupCharAntiDesync(char)
    task.wait(0.1)
    if not _G.AceAntiDesync then return end
    _G.AceAntiDesync.h = char and char:FindFirstChildOfClass("Humanoid") or nil
    _G.AceAntiDesync.hrp = char and char:FindFirstChild("HumanoidRootPart") or nil
end

function startAntiDesyncAimbot()
    if _G.AceSafeModeTryStart and not _G.AceSafeModeTryStart() then return false end
    if _G.AceStopAutoTPForAction then _G.AceStopAutoTPForAction() end
    if autoBatEnabled then disableAutoBat() end
    if autoBatV2Enabled then disableBatV2() end
    if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled = false; stopAutoRight() end
    _G.AceAntiDesyncAimbotOn = true
    if _G.AceAntiDesync.conn then
        _G.AceAntiDesync.conn:Disconnect()
        _G.AceAntiDesync.conn = nil
    end
    if LP.Character then pcall(function() setupCharAntiDesync(LP.Character) end) end
    _G.AceAntiDesync.conn = RunService.Heartbeat:Connect(function()
        if not (_G.AceAntiDesyncAimbotOn and _G.AceAntiDesync.h and _G.AceAntiDesync.hrp) then return end
        local target = getClosestPlayerAntiDesync()
        if target and target.Character then
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                if sethiddenproperty then
                    pcall(function() sethiddenproperty(_G.AceAntiDesync.hrp, "PhysicsRepRootPart", tr) end)
                end
                local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                if (_G.AceAntiDesync.hrp.Position - targetPos).Magnitude > 8 then
                    _G.AceAntiDesync.hrp.CFrame = CFrame.new(targetPos)
                end
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
                end
                if antiDesyncAutoSwingEnabled then
                    trySwingAntiDesync()
                end
            end
        end
    end)
    if tpLockSetVisual then tpLockSetVisual(true) end
    if tpBatFloatingButton then
        local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
        if btnFrame then
            btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            local label = btnFrame:FindFirstChild("TextLabel")
            if label then
                label.TextColor3 = Color3.fromRGB(0,0,0)
            end
        end
    end
    saveAllSettings()
    return true
end

function stopAntiDesyncAimbot()
    _G.AceAntiDesyncAimbotOn = false
    if _G.AceAntiDesync and _G.AceAntiDesync.conn then
        _G.AceAntiDesync.conn:Disconnect()
        _G.AceAntiDesync.conn = nil
    end
    if _G.AceAntiDesync then _G.AceAntiDesync.hittingCooldown = false end
    if sethiddenproperty and _G.AceAntiDesync and _G.AceAntiDesync.hrp then
        pcall(function() sethiddenproperty(_G.AceAntiDesync.hrp, "PhysicsRepRootPart", nil) end)
    end
    local cam = workspace.CurrentCamera
    if cam and LP.Character then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            cam.CFrame = CFrame.new(cam.CFrame.Position, hrp.Position)
        end
    end
    if tpLockSetVisual then tpLockSetVisual(false) end
    if tpBatFloatingButton then
        local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
        if btnFrame then
            btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
            local label = btnFrame:FindFirstChild("TextLabel")
            if label then
                label.TextColor3 = Color3.fromRGB(255,255,255)
            end
        end
    end
    saveAllSettings()
end

function toggleAntiDesyncAimbot()
    if _G.AceAntiDesyncAimbotOn then stopAntiDesyncAimbot() else startAntiDesyncAimbot() end
end

tpLockEnabled = _G.AceAntiDesyncAimbotOn
tpLockConn = _G.AceAntiDesync.conn
toggleTPLock = toggleAntiDesyncAimbot
startTPLock = startAntiDesyncAimbot
stopTPLock = stopAntiDesyncAimbot

LP.CharacterAdded:Connect(function(char)
    pcall(function() setupCharAntiDesync(char) end)
    if _G.AceAntiDesyncAimbotOn then
        task.wait(0.5)
        if not _G.AceAntiDesync.conn then
            startAntiDesyncAimbot()
        end
    end
end)

if LP.Character then
    task.spawn(function()
        pcall(function() setupCharAntiDesync(LP.Character) end)
    end)
end

_G.AceAntiDesyncStart = startAntiDesyncAimbot
_G.AceAntiDesyncStop = stopAntiDesyncAimbot
_G.AceAntiDesyncToggle = toggleAntiDesyncAimbot

function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
            return ch
        end
    end
    return nil
end

function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

function findBatForCounter()
    local char = LP.Character
    if not char then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
                return child
            end
        end
    end
    return nil
end

function swingBatForCounter(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.1)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.1)
        pcall(function() bat:Activate() end)
    end
end

function stopBatCounter()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            _suppressBodyLock()
            task.spawn(function()
                task.wait(0.15)
                local bat = findBatForCounter()
                if bat then
                    swingBatForCounter(bat, character)
                end
                task.wait(0.3)
                batCounterDebounce = false
                _unsuppressBodyLock(true)
            end)
        end
    end)
end

function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then
                return t
            end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then
                    return t
                end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if medusaDebounce then return end
    if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
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

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then
            useMedusaCounter()
        end
    end)
end

function setupMedusa(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char or not medusaCounterEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end))
end

function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

function onMedusaResetAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaAutoResetEnabled and part.Anchored and part.Transparency == 1 then
            instaReset()
        end
    end)
end

function setupMedusaAutoReset(char)
    for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
    medusaResetConns = {}
    if not char or not medusaAutoResetEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(medusaResetConns, onMedusaResetAnchorChanged(part))
        end
    end
    table.insert(medusaResetConns, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(medusaResetConns, onMedusaResetAnchorChanged(part))
        end
    end))
end

function stopMedusaAutoReset()
    for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
    medusaResetConns = {}
end

function setMedusaCounterState(state)
    medusaCounterEnabled = state
    if state then
        if medusaAutoResetEnabled then
            medusaAutoResetEnabled = false
            if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
            stopMedusaAutoReset()
        end
        if LP.Character then setupMedusa(LP.Character) else stopMedusaCounter() end
    else
        stopMedusaCounter()
    end
    if setMedusaVisual then setMedusaVisual(state) end
end

function setMedusaAutoResetState(state)
    medusaAutoResetEnabled = state
    if state then
        if medusaCounterEnabled then
            medusaCounterEnabled = false
            if setMedusaVisual then setMedusaVisual(false) end
            stopMedusaCounter()
        end
        if LP.Character then setupMedusaAutoReset(LP.Character) else stopMedusaAutoReset() end
    else
        stopMedusaAutoReset()
    end
    if setMedusaAutoResetVisual then setMedusaAutoResetVisual(state) end
end

local DROP_ASCEND_DURATION = 0.22
local DROP_ASCEND_SPEED = 160
local _dropConn = nil

function stopDropBrainrot()
    dropActive = false
    if _dropConn then _dropConn:Disconnect() _dropConn = nil end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = Vector3.zero end
    end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
    if mobSetDropBR then mobSetDropBR(false) end
end

function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    if dropMode == 1 then
        local speedH = 0
        if root then
            local vel = root.AssemblyLinearVelocity
            speedH = Vector3.new(vel.X, 0, vel.Z).Magnitude
        end
        local cooldown = (speedH > 5) and 0.6 or 0.25
        if tick() - lastDropTime < cooldown then return end
        lastDropTime = tick()
        dropActive = true
        if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
        if mobSetDropBR then mobSetDropBR(true) end
        local wasAutoBat = false
        if autoBatEnabled then
            wasAutoBat = true
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        local function finishDrop(threadRef)
            if threadRef and dropConnections then
                for i = #dropConnections, 1, -1 do
                    if dropConnections[i] == threadRef then
                        table.remove(dropConnections, i)
                        break
                    end
                end
            end
            dropActive = false
            local c = LP.Character
            if c then
                local r = c:FindFirstChild("HumanoidRootPart")
                local h = c:FindFirstChildOfClass("Humanoid")
                if r then
                    r.AssemblyLinearVelocity = Vector3.zero
                    r.AssemblyAngularVelocity = Vector3.zero
                    if r.Position.Y < -100 then
                        r.CFrame = CFrame.new(r.Position.X, 5, r.Position.Z)
                    end
                    local rp = RaycastParams.new()
                    rp.FilterDescendantsInstances = {c}
                    rp.FilterType = Enum.RaycastFilterType.Exclude
                    local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)
                    if rr then
                        local off = (h and h.HipHeight or 2) + (r.Size.Y / 2)
                        r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    end
                    if h and h.Health > 0 then
                        h:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end
            if wasAutoBat then
                enableAutoBat()
                if autoBatSetVisual then autoBatSetVisual(true) end
                if mobSetAutoBat then mobSetAutoBat(true) end
            end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
        end
        local flingThread = nil
        flingThread = task.spawn(function()
            local startTime = tick()
            while dropActive and (tick() - startTime) < 0.25 do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if not r then break end
                local vel = r.AssemblyLinearVelocity
                vel = Vector3.new(0, vel.Y, 0)
                r.AssemblyLinearVelocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then
                    r.AssemblyLinearVelocity = vel
                end
                RunService.Stepped:Wait()
                if r and r.Parent then
                    r.AssemblyLinearVelocity = vel + Vector3.new(0, 0.1, 0)
                end
            end
            finishDrop(flingThread)
        end)
        table.insert(dropConnections, flingThread)
        task.delay(0.35, function()
            if dropActive then finishDrop(flingThread) end
        end)
        return
    end
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end
    local t0 = tick()
    if _dropConn then _dropConn:Disconnect() end
    _dropConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if not dropActive then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            pcall(function()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
                if rr then
                    local hum2 = c:FindFirstChildOfClass("Humanoid")
                    local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                    r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    r.AssemblyLinearVelocity = Vector3.zero
                    r.AssemblyAngularVelocity = Vector3.zero
                end
                if hum2 and hum2.Health > 0 then
                    hum2:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        local lv = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = Vector3.new(lv.X, DROP_ASCEND_SPEED, lv.Z)
    end)
end

function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then setVisual(false) end
    end)
end

function applyAntiLagDerender(obj)
    pcall(function()
        -- NUNCA tocar el personaje local (animaciones / packs / bleed)
        local char = LP.Character
        if char and obj:IsDescendantOf(char) then
            return
        end
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            -- solo otros jugadores / NPCs, no el local
            for _, t in ipairs(obj:GetPlayingAnimationTracks()) do
                pcall(function() t:Stop(0) end)
            end
        end
    end)
end

function enableAntiLag()
    removeAccessoriesEnabled = true
    antiLagEnabled = true
    if defLightBrightness == nil then
        defLightBrightness = Lighting.Brightness
        defLightClock = Lighting.ClockTime
        defLightAmbient = Lighting.OutdoorAmbient
        defGlobalShadows = Lighting.GlobalShadows
        defFogEnd = Lighting.FogEnd
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        applyAntiLagDerender(obj)
    end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled then
            applyAntiLagDerender(obj)
        end
    end)
    -- Re-aplicar anim pack para que no se pierda con Anti Lag
    if currentAnimPack and currentAnimPack ~= "Off" then
        task.defer(function()
            pcall(function() startAnimPack(currentAnimPack) end)
        end)
    end
end

function disableAntiLag()
    removeAccessoriesEnabled = false
    antiLagEnabled = false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
    if defLightBrightness ~= nil then Lighting.Brightness = defLightBrightness end
    if defLightClock ~= nil then Lighting.ClockTime = defLightClock end
    if defLightAmbient ~= nil then Lighting.OutdoorAmbient = defLightAmbient end
    if defGlobalShadows ~= nil then Lighting.GlobalShadows = defGlobalShadows end
    if defFogEnd ~= nil then Lighting.FogEnd = defFogEnd end
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = true
            end
        end)
    end
end

function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = val end) end
end

function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    applyStretchFOV(stretchFOV)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect()
            stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then
            c.CFrame = c.CFrame * CFrame.new(0,0,0,1,0,0,0,0.7,0,0,0,1)
        end
    end)
    if stretchFovConn then stretchFovConn:Disconnect() end
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if stretchEnabled then
            applyStretchFOV(stretchFOV)
        else
            stretchFovConn:Disconnect(); stretchFovConn = nil
        end
    end)
end

function disableStretch()
    stretchEnabled = false
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = origFOV or 70 end) end
end

local function saveLightingState()
    if _originalLighting then return end
    _originalLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor,
        Ambient = Lighting.Ambient,
        ColorCorrection = nil,
        Bloom = nil,
    }
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("ColorCorrectionEffect") then
            _originalLighting.ColorCorrection = {
                Enabled = e.Enabled,
                Brightness = e.Brightness,
                Contrast = e.Contrast,
                Saturation = e.Saturation,
                TintColor = e.TintColor,
            }
        elseif e:IsA("BloomEffect") then
            _originalLighting.Bloom = {
                Enabled = e.Enabled,
                Intensity = e.Intensity,
                Size = e.Size,
                Threshold = e.Threshold,
            }
        end
    end
end

local function restoreLightingState()
    if not _originalLighting then return end
    local old = _originalLighting
    Lighting.Brightness = old.Brightness
    Lighting.ClockTime = old.ClockTime
    Lighting.OutdoorAmbient = old.OutdoorAmbient
    Lighting.GlobalShadows = old.GlobalShadows
    Lighting.FogEnd = old.FogEnd
    Lighting.FogStart = old.FogStart
    Lighting.FogColor = old.FogColor
    Lighting.Ambient = old.Ambient
    if old.ColorCorrection then
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then
            cc.Enabled = old.ColorCorrection.Enabled
            cc.Brightness = old.ColorCorrection.Brightness
            cc.Contrast = old.ColorCorrection.Contrast
            cc.Saturation = old.ColorCorrection.Saturation
            cc.TintColor = old.ColorCorrection.TintColor
        end
    end
    if old.Bloom then
        local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom then
            bloom.Enabled = old.Bloom.Enabled
            bloom.Intensity = old.Bloom.Intensity
            bloom.Size = old.Bloom.Size
            bloom.Threshold = old.Bloom.Threshold
        end
    end
    _originalLighting = nil
end

local function applyNeonWeather()
    if not neonWeatherEnabled then restoreLightingState() return end
    if not _originalLighting then saveLightingState() end
    Lighting.Brightness = 3.5
    Lighting.ClockTime = 20
    Lighting.OutdoorAmbient = Color3.fromRGB(20, 40, 80)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 300
    Lighting.FogStart = 0
    Lighting.FogColor = Color3.fromRGB(0, 80, 200)
    Lighting.Ambient = Color3.fromRGB(30, 60, 120)
    local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if not cc then
        cc = Instance.new("ColorCorrectionEffect")
        cc.Parent = Lighting
    end
    cc.Enabled = true
    cc.Brightness = 0.2
    cc.Contrast = 0.15
    cc.Saturation = 0.15
    cc.TintColor = Color3.fromRGB(180, 180, 190)
    local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
    if not bloom then
        bloom = Instance.new("BloomEffect")
        bloom.Parent = Lighting
    end
    bloom.Enabled = true
    bloom.Intensity = 0.6
    bloom.Size = 25
    bloom.Threshold = 0.8
end

function toggleNeonWeather(state)
    if state == nil then neonWeatherEnabled = not neonWeatherEnabled else neonWeatherEnabled = state end
    applyNeonWeather()
    if setNeonWeatherVisual then setNeonWeatherVisual(neonWeatherEnabled) end
end

local function drag(f)
    local dn, ds, sp, di = false
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dn = true; ds = i.Position; sp = f.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.InputUserState.End then dn = false end
            end)
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            di = i
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            if uiLocked then dn = false; return end
            if _isDraggingButton then return end
            local nX = sp.X.Offset + (i.Position.X - ds.X)
            local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
            f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
        end
    end)
end

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    steppedConn = RunService.Stepped:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
    movementLoop = RunService.RenderStepped:Connect(function()
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if not autoBatEnabled and not tpLockEnabled and not autoLeftEnabled and not autoRightEnabled and not autoBatV2Enabled then
            local spd
            if laggerToggled then
                spd = (laggerLevel == 2) and LAGGER_SPEED_2 or LAGGER_SPEED_1
            else
                spd = speedMode and CS or NS
            end
            if speedEnabled and currentSpeedValue ~= spd then
                cleanupSpeedPhysics()
            end
            if not speedEnabled and spd > 0 then
                applySpeedWithLinearVelocity(spd)
            end
        else
            if speedEnabled then cleanupSpeedPhysics() end
        end
    end)
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if uiLocked and editModeEnabled then
        editModeEnabled = false
        if setEditModeVisual then setEditModeVisual(false) end
    end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

function toggleEditMode(state)
    if state == nil then state = not editModeEnabled end
    if state and uiLocked then state = false end
    editModeEnabled = state
    if setEditModeVisual then setEditModeVisual(editModeEnabled) end
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if tpLockEnabled then toggleAntiDesyncAimbot() end
    if autoBatV2Enabled then
        disableBatV2()
        if autoBatV2SetVisual then autoBatV2SetVisual(false) end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then
                    label.TextColor3 = Color3.fromRGB(255,255,255)
                end
            end
        end
    end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    stopAntiRagdoll()
    stopBatCounter()
    stopMedusaCounter()
    stopMedusaAutoReset()
    stopAutoSteal()
    disableAutoBat()
    if tpLockEnabled then stopAntiDesyncAimbot() end
    if autoBatV2Enabled then disableBatV2() end
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if espEnabled then toggleESP(false) end
    if dropActive then stopDropBrainrot() end
    if bodyLockEnabled then stopBodyLock() end
    cleanupSpeedPhysics()
    _blSuppressCount = 0
    _blWasEnabled = false
    if _blRestoreTimer then task.cancel(_blRestoreTimer) _blRestoreTimer = nil end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    dropActive = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
end

function buildConfigTable()
    local config = {
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED_1,
        laggerSpeed2 = LAGGER_SPEED_2,
        stealRadius = CONFIG.STEAL_RANGE,
        stealDuration = CONFIG.HOLD_MAX,
        antiRagdoll = antiRagdollEnabled,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        antiDie = antiDieEnabled,
        antiDrop = antiDropEnabled,
        antiFlingShield = antiFlingShieldEnabled,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
        laggerToggled = laggerToggled,
        laggerLevel = laggerLevel,
        carryMode = speedMode,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        dropMode = dropMode,
        medusaAutoReset = medusaAutoResetEnabled,
        stretchEnabled = stretchEnabled,
        stretchFOV = stretchFOV,
        uiScale = uiScaleValue,
        buttonScale = buttonScaleValue,
        buttonsSize = buttonsSizeValue,
        buttonsShape = buttonsShape,
        animPack = currentAnimPack,
        espEnabled = espEnabled,
        antiLag = antiLagEnabled,
        tpLockEnabled = _G.AceAntiDesyncAimbotOn,
        neonWeather = neonWeatherEnabled,
        menuBackground = currentMenuBackground,
        menuTheme = currentMenuTheme,
        autoBatV2Enabled = autoBatV2Enabled,
        mobileButtonPositions = savedButtonPositions,
        skyTheme = currentSkyTheme,
        accessoryPack = currentAccessoryPack,
        bleedPack = currentBleedPack,
        musicPack = currentMusicPack,
        buttonImage = currentButtonImage,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        tpLockKey = {kb = KB.TPLock.kb and KB.TPLock.kb.Name, gp = KB.TPLock.gp and KB.TPLock.gp.Name},
        batV2Key = {kb = KB.BatV2.kb and KB.BatV2.kb.Name, gp = KB.BatV2.gp and KB.BatV2.gp.Name},  
        instaResetFloatingPos = instaResetFloatingPos,
        tpBatFloatingPos = tpBatFloatingPos,
        batV2FloatingPos = batV2FloatingPos,
        bodyLockEnabled = bodyLockEnabled,
        bodyLockRange = bodyLockRange,
        autoResetStates = autoResetStates,
        progressBarPos = savedProgressBarPos,
        lockUI = uiLocked,
        editMode = editModeEnabled,
        infJumpEnabled = InfJumpState.enabled,
    }
    if pbFrame then
        config.progressBarPos = {
            XScale = pbFrame.Position.X.Scale,
            XOffset = pbFrame.Position.X.Offset,
            YScale = pbFrame.Position.Y.Scale,
            YOffset = pbFrame.Position.Y.Offset
        }
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        config.mobilePanelPos = {
            XScale = container.Position.X.Scale,
            XOffset = container.Position.X.Offset,
            YScale = container.Position.Y.Scale,
            YOffset = container.Position.Y.Offset
        }
    end
    return config
end

function saveAllSettings()
    if _isResetting then return true end
    local config = buildConfigTable()
    local json = HS:JSONEncode(config)
    if json == _lastSavedJSON then return true end
    local success, err = pcall(function() writefile(CONFIG_FILE, json) end)
    if success then _lastSavedJSON = json end
    return success
end

function loadAllSettings()
    if not isfile or not isfile(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
    if not success or not data then return false end
    _isLoading = true
    NS = data.normalSpeed or NS
    CS = data.carrySpeed or CS
    LAGGER_SPEED_1 = data.laggerSpeed1 or LAGGER_SPEED_1
    LAGGER_SPEED_2 = data.laggerSpeed2 or LAGGER_SPEED_2
    CONFIG.STEAL_RANGE = 8  -- FORZADO desde extracto Night (imagen Radius 8)
    CONFIG.HOLD_MAX = data.stealDuration or CONFIG.HOLD_MAX
    uiLocked = data.lockUI or true
    editModeEnabled = data.editMode or false
    antiRagdollEnabled = data.antiRagdoll or false
    CONFIG.AUTO_STEAL_ENABLED = data.autoSteal or false
    antiDieEnabled = data.antiDie or false
    antiDropEnabled = data.antiDrop or false
    antiFlingShieldEnabled = data.antiFlingShield or false
    medusaCounterEnabled = data.medusaCounter or false
    batCounterEnabled = data.batCounter or false
    unwalkEnabled = data.unwalk or false
    antiLagEnabled = data.antiLag or false
    laggerToggled = data.laggerToggled or false
    speedMode = data.carryMode or false
    laggerLevel = data.laggerLevel or 1
    medusaAutoResetEnabled = data.medusaAutoReset or false
    if medusaAutoResetEnabled and medusaCounterEnabled then medusaCounterEnabled = false end
    uiScaleValue = 80  -- FORZADO desde extracto Night (imagen UI Scale 80)
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = uiScaleValue / 100 end
    buttonScaleValue = data.buttonScale or 1.0
    buttonsSizeValue = (type(data.buttonsSize) == "number" and data.buttonsSize) or 50
    buttonsShape = (type(data.buttonsShape) == "string" and data.buttonsShape) or "Circle"
    currentButtonImage = 0
    applyButtonScale(buttonScaleValue)
    applyMobileButtonsSize(buttonsSizeValue)
    applyMobileButtonsShape(buttonsShape)
    espEnabled = data.espEnabled or false
    if espEnabled then toggleESP(true) else toggleESP(false) end
    autoBatV2Enabled = data.autoBatV2Enabled or false
    if autoBatV2Enabled then
        task.defer(function()
            enableBatV2()
            if autoBatV2SetVisual then autoBatV2SetVisual(true) end
        end)
    else
        if autoBatV2SetVisual then autoBatV2SetVisual(false) end
    end
    local antiDesyncState = data.tpLockEnabled or false
    if antiDesyncState then
        task.defer(function()
            startAntiDesyncAimbot()
            if tpLockSetVisual then tpLockSetVisual(true) end
        end)
    else
        if tpLockSetVisual then tpLockSetVisual(false) end
    end
    neonWeatherEnabled = data.neonWeather or false
    -- Fondo menú / steal desde config
    currentMenuBackground = (type(data.menuBackground) == "number" and data.menuBackground) or 0
    currentButtonImage = 0
    if applyMenuBackground then pcall(applyMenuBackground, currentMenuBackground) end
    if applyMenuTheme then pcall(applyMenuTheme, currentMenuTheme or "WHITE") end
    pcall(function() applyButtonImages(0) end)
    if neonWeatherEnabled then
        task.defer(function() toggleNeonWeather(true) end)
    else
        toggleNeonWeather(false)
    end
    -- Anim Pack persistente desde config
    currentAnimPack = (type(data.animPack) == "string" and data.animPack) or currentAnimPack or "Off"
    if currentAnimPack and currentAnimPack ~= "Off" then
        pcall(function() startAnimPack(currentAnimPack) end)
    end
    if animSelectorLabel then animSelectorLabel.Text = currentAnimPack or "Off" end
    if data.skyTheme then
        setSkyTheme(data.skyTheme)
    else
        setSkyTheme("Off")
    end
    -- Skin Pack: guardado o Headless por defecto
    currentAccessoryPack = (type(data.accessoryPack) == "string" and data.accessoryPack) or "Headless"
    task.defer(function()
        applyAccessoryPack(currentAccessoryPack)
        if accSelectorLabel then accSelectorLabel.Text = currentAccessoryPack end
    end)
    -- Pack Accessory (Bleed): PERSISTENTE al reentrar
    currentBleedPack = (type(data.bleedPack) == "string" and data.bleedPack) or "Off"
    task.defer(function()
        task.wait(0.6)
        applyBleedPack(currentBleedPack)
        if bleedSelectorLabel then bleedSelectorLabel.Text = currentBleedPack end
    end)
    -- Music Pack persistente
    currentMusicPack = (type(data.musicPack) == "string" and data.musicPack) or currentMusicPack or "Migizin"
    task.defer(function()
        if playMusicPack then playMusicPack(currentMusicPack) end
        if musicSelectorLabel then musicSelectorLabel.Text = currentMusicPack end
    end)
    local function lk(e, d)
        if not d then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end
        if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end
    end
    lk(KB.DropBrainrot, data.dropBrainrotKey)
    lk(KB.AutoLeft, data.autoLeftKey)
    lk(KB.AutoRight, data.autoRightKey)
    lk(KB.AutoBat, data.autoBatKey)
    lk(KB.TPFloor, data.tpFloorKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.InstaReset, data.instaResetKey)
    lk(KB.TPLock, data.tpLockKey)
    lk(KB.BatV2, data.batV2Key)   
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.instaResetFloatingPos then instaResetFloatingPos = data.instaResetFloatingPos end
    if data.tpBatFloatingPos then tpBatFloatingPos = data.tpBatFloatingPos end
    if data.batV2FloatingPos then batV2FloatingPos = data.batV2FloatingPos end
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    if data.bodyLockEnabled ~= nil then
        bodyLockEnabled = data.bodyLockEnabled
        if bodyLockEnabled then
            task.defer(function()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                startBodyLock()
            end)
        end
    end
    if data.bodyLockRange then
        bodyLockRange = data.bodyLockRange
        if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    end
    if data.autoResetStates then
        for k, v in pairs(data.autoResetStates) do
            if autoResetStates[k] ~= nil then autoResetStates[k] = v end
        end
    end
    dropMode = data.dropMode or 1
    stretchEnabled = data.stretchEnabled or false
    stretchFOV = data.stretchFOV or 120
    BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED
    if data.infJumpEnabled ~= nil then InfJumpState.enabled = data.infJumpEnabled end
    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    refreshSpeedModeLabel()
    _lastSavedJSON = HS:JSONEncode(buildConfigTable())
    _isLoading = false
    return true
end

function forceResetUI()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_SPEED_2) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if _G.uiScaleValueLabel then _G.uiScaleValueLabel.Text = string.format("%.2f", uiScaleValue / 100) end
    if _G.buttonScaleValueLabel then _G.buttonScaleValueLabel.Text = string.format("%.2f", buttonScaleValue) end
    applyButtonScale(buttonScaleValue)
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
    safeSet(setMedusaVisual, false)
    safeSet(setMedusaAutoResetVisual, false)
    safeSet(setAntiRagVisual, false)
    safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false)
    safeSet(setLockUIVisual, false)
    safeSet(setEditModeVisual, false)
    safeSet(setInstaGrab, false)
    safeSet(setAntiDieVisual, false)
    safeSet(setAntiDropVisual, false)
    pcall(stopAntiDrop)
    safeSet(setAntiFlingVisual, false)
    pcall(stopAntiDie)
    pcall(stopAntiFlingShield)
    safeSet(tpLockSetVisual, false)
    safeSet(setESPVIsual, false)
    safeSet(bodyLockSetVisual, false)
    safeSet(setNeonWeatherVisual, false)
    safeSet(autoBatV2SetVisual, false)
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    safeSet(mobSetAutoBat, false)
    safeSet(mobSetAutoLeft, false)
    safeSet(mobSetAutoRight, false)
    safeSet(mobSetDropBR, false)
    safeSet(mobSetTpDown, false)
    safeSet(mobSetCarry, false)
    safeSet(mobSetLagger1, false)
    safeSet(mobSetLagger2, false)
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    disableAntiLag()
    toggleNeonWeather(false)
    disableBatV2()
    setSkyTheme("Off")
    currentAccessoryPack = "Headless"
    applyAccessoryPack("Headless")
    if accSelectorLabel then accSelectorLabel.Text = "Headless" end
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
end

function resetFloatingPositions()
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        container.Position = UDim2.new(1, -(MOBILE_PANEL_WIDTH + 10), 0, 0)
        savedButtonPositions = {}
        if container:FindFirstChild("ButtonsContainer") then
            for _, btn in ipairs(container.ButtonsContainer:GetChildren()) do
                if btn:IsA("TextButton") and btn.Name then
                    local defX, defY = getDefaultButtonPosition(btn.Name)
                    btn.Position = UDim2.new(0, defX, 0, defY)
                end
            end
        end
    end
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        local btnFrame = instaResetFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(0.5, -120, 0, 10)
        instaResetFloatingPos = nil
    end
    if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
        local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(0.5, 20, 0, 10)
        tpBatFloatingPos = nil
    end
    if batV2FloatingButton and batV2FloatingButton:FindFirstChild("Frame") then
        local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(0.5, -50, 0, 10)
        batV2FloatingPos = nil
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -140, 1, -50)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
    instaResetFloatingPos = nil
    tpBatFloatingPos = nil
    batV2FloatingPos = nil
end

function resetToFactoryDefaults()
    _isResetting = true
    stopAllBackgroundTasks()
    stopAutoSteal()
    stopBatCounter()
    stopMedusaCounter()
    stopMedusaAutoReset()
    stopAntiRagdoll()
    stopUnwalk()
    disableAutoBat()
    if tpLockEnabled then stopAntiDesyncAimbot() end
    disableBatV2()
    stopBodyLock()
    if espEnabled then toggleESP(false) end
    if stretchEnabled then disableStretch() end
    if antiLagEnabled then disableAntiLag() end
    if dropActive then stopDropBrainrot() end
    toggleNeonWeather(false)
    NS = 60
    CS = 29
    LAGGER_SPEED_1 = 20
    LAGGER_SPEED_2 = 10
    CONFIG.STEAL_RANGE = 8
    CONFIG.HOLD_MAX = 2.6
    speedMode = false
    laggerToggled = false
    laggerLevel = 1
    antiRagdollEnabled = false
    medusaCounterEnabled = false
    batCounterEnabled = false
    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    unwalkEnabled = false
    antiLagEnabled = false
    uiLocked = true
    editModeEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    BAT_AIMBOT_SPEED = 58
    _G.AceAntiDesyncAimbotOn = false
    dropMode = 1
    medusaAutoResetEnabled = false
    stretchEnabled = false
    stretchFOV = 120
    uiScaleValue = 80
    if mainUIScale then mainUIScale.Scale = 0.8 end
    if pbScale then pbScale.Scale = 0.8 end
    buttonScaleValue = 1.0
    applyButtonScale(1.0)
    espEnabled = false
    bodyLockEnabled = false
    bodyLockRange = 20
    autoBatV2Enabled = false
    for k in pairs(autoResetStates) do autoResetStates[k] = false end
    currentAnimPack = "Vampire"
    startAnimPack("Vampire")
    currentSkyTheme = "Off"
    setSkyTheme("Off")
    currentAccessoryPack = "Headless"
    applyAccessoryPack("Headless")
    if accSelectorLabel then accSelectorLabel.Text = "Headless" end
    savedStealRadius = CONFIG.STEAL_RANGE
    savedStealDuration = CONFIG.HOLD_MAX
    for key, val in pairs(DEFAULT_KB) do
        if KB[key] then
            KB[key].kb = val.kb
            KB[key].gp = val.gp
        end
    end
    if isfile and isfile(CONFIG_FILE) then pcall(delfile, CONFIG_FILE) end
    resetFloatingPositions()
    forceResetUI()
    updateProgressBarVisibility()
    refreshSpeedModeLabel()
    _lastSavedJSON = nil
    saveAllSettings()
    _isResetting = false
end

function updateProgressBarVisibility()
    if pbFrame then
        pbFrame.Visible = (CONFIG.AUTO_STEAL_ENABLED == true)
    end
end

function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80,80,80)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80,80,80))
    })
    grad.Rotation = 45
    grad.Offset = Vector2.new(0,0)
    task.spawn(function()
        local t = 0
        while grad and grad.Parent do
            t = t + 0.02
            grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
            task.wait(0.04)
        end
    end)
    return grad
end

function getDefaultButtonPosition(btnName)
    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local orderMap = {
        DropBR = 0,
        AutoLeft = 1,
        AutoBat = 2,
        AutoRight = 3,
        TpDown = 4,
        Carry = 5,
        Lagger1 = 6,
        Lagger2 = 7
    }
    local order = orderMap[btnName] or 0
    local row = math.floor(order / 2)
    local col = order % 2
    return col * (BTN_W + GAP), row * (BTN_H + GAP + 10)
end

local AntiDieModule = {
    enabled = false,
    conns = {},
    charConn = nil,
}
local setAntiDieVisual = nil

local function _irishClearAntiDie()
    for _, c in ipairs(AntiDieModule.conns) do
        pcall(function() c:Disconnect() end)
    end
    AntiDieModule.conns = {}
    local char = LP.Character
    if char then
        local hl = char:FindFirstChild("IrishAntiDieEffect")
        if hl then pcall(function() hl:Destroy() end) end
    end
end

local function _irishEnableAntiDieOnChar(char)
    if not AntiDieModule.enabled or not char then return end
    _irishClearAntiDie()
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
    if not hum then return end
    pcall(function()
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum.BreakJointsOnDeath = false
    end)
    pcall(function()
        local hl = Instance.new("Highlight")
        hl.Name = "IrishAntiDieEffect"
        hl.FillColor = Color3.fromRGB(85, 255, 145)
        hl.OutlineColor = Color3.fromRGB(85, 255, 145)
        hl.FillTransparency = 0.75
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
    end)
    table.insert(AntiDieModule.conns, RunService.RenderStepped:Connect(function()
        if not AntiDieModule.enabled then return end
        local c = LP.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if h and h.Health < h.MaxHealth then
            pcall(function() h.Health = h.MaxHealth end)
        end
    end))
end

function startAntiDie()
    AntiDieModule.enabled = true
    antiDieEnabled = true
    if AntiDieModule.charConn then
        pcall(function() AntiDieModule.charConn:Disconnect() end)
        AntiDieModule.charConn = nil
    end
    AntiDieModule.charConn = LP.CharacterAdded:Connect(function(char)
        if AntiDieModule.enabled then
            task.wait(0.5)
            _irishEnableAntiDieOnChar(char)
        end
    end)
    if LP.Character then
        _irishEnableAntiDieOnChar(LP.Character)
    end
end

function stopAntiDie()
    AntiDieModule.enabled = false
    antiDieEnabled = false
    if AntiDieModule.charConn then
        pcall(function() AntiDieModule.charConn:Disconnect() end)
        AntiDieModule.charConn = nil
    end
    _irishClearAntiDie()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            hum.MaxHealth = 100
            if hum.Health > 100 then hum.Health = 100 end
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum.BreakJointsOnDeath = true
        end)
    end
end

-- Anti-Fling Shield (Irish: collision groups + velocity clamp)
local AntiFlingShield = {
    enabled = false,
    conns = {},
    originalProps = {},
    velocityThreshold = 100,
}
local setAntiFlingVisual = nil
local IRISH_PLAYER_GROUP = "VeneyorkNoPlayerCollide"

pcall(function()
    local PhysicsService = game:GetService("PhysicsService")
    if not PhysicsService:IsCollisionGroupRegistered(IRISH_PLAYER_GROUP) then
        PhysicsService:RegisterCollisionGroup(IRISH_PLAYER_GROUP)
    end
    PhysicsService:CollisionGroupSetCollidable(IRISH_PLAYER_GROUP, IRISH_PLAYER_GROUP, false)
end)

local function _irishSetCharGroup(char, groupName)
    if not char then return end
    local PhysicsService = game:GetService("PhysicsService")
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() PhysicsService:SetPartCollisionGroup(part, groupName) end)
        end
    end
end

local function _irishClearAntiFling()
    for _, c in ipairs(AntiFlingShield.conns) do
        pcall(function() c:Disconnect() end)
    end
    AntiFlingShield.conns = {}
end

function startAntiFlingShield()
    AntiFlingShield.enabled = true
    antiFlingShieldEnabled = true
    _irishClearAntiFling()
    local char = LP.Character
    if char then
        _irishSetCharGroup(char, IRISH_PLAYER_GROUP)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            AntiFlingShield.originalProps[hrp] = hrp.CustomPhysicalProperties
            pcall(function()
                hrp.CustomPhysicalProperties = PhysicalProperties.new(
                    (hrp.CustomPhysicalProperties and hrp.CustomPhysicalProperties.Density) or 0.7,
                    0, 0.3, 0, 0
                )
            end)
        end
    end
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= LP and other.Character then
            _irishSetCharGroup(other.Character, IRISH_PLAYER_GROUP)
        end
        if other ~= LP then
            table.insert(AntiFlingShield.conns, other.CharacterAdded:Connect(function(c)
                task.wait(0.5)
                if AntiFlingShield.enabled then
                    _irishSetCharGroup(c, IRISH_PLAYER_GROUP)
                end
            end))
        end
    end
    table.insert(AntiFlingShield.conns, Players.PlayerAdded:Connect(function(p)
        table.insert(AntiFlingShield.conns, p.CharacterAdded:Connect(function(c)
            task.wait(0.5)
            if AntiFlingShield.enabled then
                _irishSetCharGroup(c, IRISH_PLAYER_GROUP)
            end
        end))
    end))
    table.insert(AntiFlingShield.conns, LP.CharacterAdded:Connect(function(c)
        if not AntiFlingShield.enabled then return end
        task.wait(0.5)
        _irishSetCharGroup(c, IRISH_PLAYER_GROUP)
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            AntiFlingShield.originalProps[hrp] = hrp.CustomPhysicalProperties
            pcall(function()
                hrp.CustomPhysicalProperties = PhysicalProperties.new(
                    (hrp.CustomPhysicalProperties and hrp.CustomPhysicalProperties.Density) or 0.7,
                    0, 0.3, 0, 0
                )
            end)
        end
    end))
    table.insert(AntiFlingShield.conns, RunService.RenderStepped:Connect(function()
        if not AntiFlingShield.enabled then return end
        local c = LP.Character
        local h = c and c:FindFirstChild("HumanoidRootPart")
        if h and h:IsA("BasePart") then
            local vel = h.AssemblyLinearVelocity
            local xzSpeed = Vector2.new(vel.X, vel.Z).Magnitude
            if xzSpeed > AntiFlingShield.velocityThreshold then
                h.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
            end
            if h.AssemblyAngularVelocity.Magnitude > 1 then
                h.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end))
end

function stopAntiFlingShield()
    AntiFlingShield.enabled = false
    antiFlingShieldEnabled = false
    _irishClearAntiFling()
    local char = LP.Character
    if char then
        _irishSetCharGroup(char, "Default")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and AntiFlingShield.originalProps[hrp] then
            pcall(function() hrp.CustomPhysicalProperties = AntiFlingShield.originalProps[hrp] end)
            AntiFlingShield.originalProps[hrp] = nil
        end
    end
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= LP and other.Character then
            _irishSetCharGroup(other.Character, "Default")
        end
    end
end


-- ============================================================
-- CK4C4 INTRO (frame animation + music)
-- ============================================================
local function runVeneyorkIntro()
    local contentProvider = game:GetService("ContentProvider")
    local Images = {
        "rbxassetid://96533744445232",
        "rbxassetid://118993542874276",
        "rbxassetid://99866892158060",
        "rbxassetid://84540124030580",
        "rbxassetid://132934292097292",
        "rbxassetid://104010736352149",
        "rbxassetid://94361033271077",
        "rbxassetid://72190372137981",
        "rbxassetid://103523696318850",
        "rbxassetid://101803539971689",
        "rbxassetid://107529606059299",
        "rbxassetid://130784948902307",
        "rbxassetid://114784420279972",
        "rbxassetid://105123015099972",
        "rbxassetid://131596264264581",
        "rbxassetid://117641319299892",
        "rbxassetid://77534392596501",
        "rbxassetid://137414609886581",
        "rbxassetid://83131507934505",
        "rbxassetid://120539267437814",
        "rbxassetid://75439074806720",
        "rbxassetid://115488810796302",
        "rbxassetid://112728809681073",
        "rbxassetid://134318680085983",
        "rbxassetid://123066810237014",
        "rbxassetid://102121135737318",
        "rbxassetid://139699026047974",
        "rbxassetid://74182313853112",
        "rbxassetid://121416642632033",
        "rbxassetid://134801197105164",
        "rbxassetid://93349115381247",
        "rbxassetid://128713300077569",
        "rbxassetid://105980529035481",
        "rbxassetid://120098855834318",
        "rbxassetid://78738310303690",
        "rbxassetid://120357336501453",
        "rbxassetid://118779397888922",
        "rbxassetid://132769993677180",
        "rbxassetid://104815503921105",
        "rbxassetid://77088103549177",
        "rbxassetid://72670821879917",
        "rbxassetid://70849955940425",
        "rbxassetid://108744596090889",
        "rbxassetid://76080560700977",
        "rbxassetid://78134833803844",
        "rbxassetid://88784536566963",
        "rbxassetid://98157171075972",
        "rbxassetid://110334342917414",
        "rbxassetid://97359534131775",
        "rbxassetid://72958519562189",
        "rbxassetid://92480523122234",
        "rbxassetid://117453595633818",
    }
    local FPS = 30
    local LOOP = true
    local skipRequested = false

    pcall(function()
        contentProvider:PreloadAsync(Images)
    end)
    task.wait(0.15)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VeneyorkIntro"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 9999
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(screenGui) end
    end)
    if not pcall(function() screenGui.Parent = game:GetService("CoreGui") end) then
        screenGui.Parent = LP:WaitForChild("PlayerGui")
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local layer1 = Instance.new("ImageLabel")
    layer1.Size = UDim2.new(1, 0, 1, 0)
    layer1.BackgroundTransparency = 1
    layer1.ScaleType = Enum.ScaleType.Crop
    layer1.ZIndex = 2
    layer1.Parent = frame

    local layer2 = Instance.new("ImageLabel")
    layer2.Size = UDim2.new(1, 0, 1, 0)
    layer2.BackgroundTransparency = 1
    layer2.ScaleType = Enum.ScaleType.Crop
    layer2.ZIndex = 1
    layer2.Parent = frame

    layer1.Image = Images[1]
    layer2.Image = Images[1]

    local titleText = Instance.new("TextLabel", screenGui)
    titleText.Size = UDim2.new(0, 400, 0, 50)
    titleText.Position = UDim2.new(0.5, -200, 0.42, -40)
    titleText.BackgroundTransparency = 1
    titleText.Text = "ELITE HUB"
    titleText.TextColor3 = Color3.new(1, 1, 1)
    titleText.TextSize = 48
    titleText.Font = Enum.Font.Fantasy
    titleText.TextTransparency = 0.1
    titleText.TextStrokeColor3 = Color3.new(0, 0, 0)
    titleText.TextStrokeTransparency = 0.4
    titleText.ZIndex = 100

    local continueText = Instance.new("TextLabel", screenGui)
    continueText.Size = UDim2.new(0, 300, 0, 40)
    continueText.Position = UDim2.new(0.5, -150, 0.55, 0)
    continueText.BackgroundTransparency = 1
    continueText.Text = "TAP TO CONTINUE"
    continueText.TextColor3 = Color3.new(1, 1, 1)
    continueText.TextSize = 22
    continueText.Font = Enum.Font.Fantasy
    continueText.TextTransparency = 0.35
    continueText.TextStrokeColor3 = Color3.new(0, 0, 0)
    continueText.TextStrokeTransparency = 0.5
    continueText.ZIndex = 100

    local sound = nil
    pcall(function()
        local url = "https://files.catbox.moe/iyw1cb.mp3"
        local fileName = "Veneyork_IntroSong.mp3"
        if writefile and (not isfile or not isfile(fileName)) then
            local data = game:HttpGet(url)
            if data then writefile(fileName, data) end
        end
        if getcustomasset and isfile and isfile(fileName) then
            sound = Instance.new("Sound")
            sound.SoundId = getcustomasset(fileName)
            sound.Volume = 1
            sound.Parent = workspace
            sound:Play()
        end
    end)

    local function skipVideo()
        if skipRequested then return end
        skipRequested = true
        if sound then
            pcall(function() sound:Stop() end)
            pcall(function() sound:Destroy() end)
        end
        task.delay(0.5, function()
            pcall(function() if screenGui then screenGui:Destroy() end end)
        end)
    end

    local clickBtn = Instance.new("TextButton", screenGui)
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 200
    clickBtn.MouseButton1Click:Connect(skipVideo)

    UIS.InputBegan:Connect(function(input)
        if skipRequested then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            skipVideo()
        end
    end)

    task.delay(9, function()
        if not skipRequested then skipVideo() end
    end)

    task.spawn(function()
        local currentIdx = 1
        local total = #Images
        local delay = 1 / FPS
        while LOOP or currentIdx < total do
            if skipRequested then break end
            local nextIdx = currentIdx + 1
            if nextIdx > total then
                if not LOOP then break end
                nextIdx = 1
            end
            local behind, front
            if layer1.ZIndex == 1 then
                behind = layer1
                front = layer2
            else
                behind = layer2
                front = layer1
            end
            behind.Image = Images[nextIdx]
            task.wait(0.01)
            behind.ZIndex = 2
            front.ZIndex = 1
            currentIdx = nextIdx
            local startTime = tick()
            while tick() - startTime < delay do
                if skipRequested then break end
                task.wait(0.05)
            end
        end
        if not skipRequested then
            if sound then
                pcall(function() sound:Stop() end)
                pcall(function() sound:Destroy() end)
            end
            task.wait(0.4)
            pcall(function() if screenGui then screenGui:Destroy() end end)
        end
    end)
end


function buildGui()
    local WHITE = Color3.fromRGB(255, 255, 255)
    local SILVER = Color3.fromRGB(180, 180, 190)
    local SILVER_DARK = Color3.fromRGB(100, 100, 110)
    local BG = Color3.fromRGB(0,0,0)
    local BG2 = Color3.fromRGB(10,10,10)
    local ROW_BG = Color3.fromRGB(10,10,10)
    local ROW_BORDER = Color3.fromRGB(50,50,50)
    local GRAY = Color3.fromRGB(60,60,60)
    local INP = Color3.fromRGB(15,15,15)
    local OFF = Color3.fromRGB(25,25,30)
    local TAB_ACTIVE = WHITE
    local TAB_INACT = SILVER_DARK
    local SECT_LBL = WHITE
    local HOV = Color3.fromRGB(25,25,25)
    local ON_COLOR = WHITE
    local STROKE_COLOR = Color3.fromRGB(50,50,50)
    local GUI_W, GUI_H = 300, 470

    local old = game:GetService("CoreGui"):FindFirstChild("Veneyork")
    if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        local o = pg:FindFirstChild("Veneyork"); if o then o:Destroy() end
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "Veneyork"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
    end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0, 20, 0, 2)
    main.BackgroundColor3 = BG
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)
    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    menuBgImage = Instance.new("ImageLabel")
    menuBgImage.Name = "CustomBackground"
    menuBgImage.BackgroundTransparency = 1
    menuBgImage.ImageTransparency = 0.08
    menuBgImage.ScaleType = Enum.ScaleType.Crop
    menuBgImage.Size = UDim2.new(1, 0, 1, 0)
    menuBgImage.Position = UDim2.new(0, 0, 0, 0)
    menuBgImage.Visible = false
    menuBgImage.ZIndex = 1
    menuBgImage.Parent = main
    Instance.new("UICorner", menuBgImage).CornerRadius = UDim.new(0, 18)

    function applyMenuBackground(index)
        currentMenuBackground = tonumber(index) or 0
        local tint = MENU_THEME_COLORS[currentMenuTheme] or MENU_THEME_COLORS.WHITE
        if currentMenuBackground <= 0 or not MENU_BG_IDS[currentMenuBackground] then
            currentMenuBackground = 0
            if menuBgImage then
                menuBgImage.Visible = false
            end
            if stealBarBgImage then
                stealBarBgImage.Visible = false
            end
            if main then main.BackgroundTransparency = 0 end
            if pbFrame then
                pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                pbFrame.BackgroundTransparency = 0
            end
            return "None"
        end
        local asset = "rbxassetid://" .. tostring(MENU_BG_IDS[currentMenuBackground])
        if menuBgImage then
            menuBgImage.Image = asset
            menuBgImage.ImageColor3 = tint
            menuBgImage.Visible = true
        end
        if stealBarBgImage then
            stealBarBgImage.Image = asset
            stealBarBgImage.ImageColor3 = tint
            stealBarBgImage.Visible = true
        end
        if main then main.BackgroundTransparency = 0.15 end
        if pbFrame then
            pbFrame.BackgroundTransparency = 0.35
        end
        return "Image " .. tostring(currentMenuBackground)
    end

    function applyMenuTheme(name)
        if MENU_THEME_COLORS[name] then
            currentMenuTheme = name
        end
        local tint = MENU_THEME_COLORS[currentMenuTheme] or MENU_THEME_COLORS.WHITE
        if menuBgImage and menuBgImage.Visible then
            menuBgImage.ImageColor3 = tint
        end
        if stealBarBgImage and stealBarBgImage.Visible then
            stealBarBgImage.ImageColor3 = tint
        end
    end


    local topBar = Instance.new("Frame", main)
    topBar.Size = UDim2.new(1, 0, 0, 78)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundTransparency = 1
    topBar.ZIndex = 30

    local profileImage = nil

    -- Título centrado estilo Zurich + subtítulo 12:12 + línea divisoria
    local titleLabel = Instance.new("TextLabel", topBar)
    titleLabel.Size = UDim2.new(1, -100, 0, 28)
    titleLabel.Position = UDim2.new(0, 50, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "ELITE HUB"
    titleLabel.TextColor3 = WHITE
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 24
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    titleLabel.TextStrokeTransparency = 0.2
    titleLabel.ZIndex = 30
    local grad = Instance.new("UIGradient", titleLabel)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WHITE),
        ColorSequenceKeypoint.new(0.45, WHITE),
        ColorSequenceKeypoint.new(0.55, SILVER),
        ColorSequenceKeypoint.new(1, SILVER)
    })
    grad.Rotation = 0

    local titleUnderline = Instance.new("Frame", topBar)
    titleUnderline.Name = "TitleUnderline"
    titleUnderline.Size = UDim2.new(0, 56, 0, 2)
    titleUnderline.Position = UDim2.new(0.5, -28, 0, 38)
    titleUnderline.BackgroundColor3 = WHITE
    titleUnderline.BorderSizePixel = 0
    titleUnderline.ZIndex = 31
    Instance.new("UICorner", titleUnderline).CornerRadius = UDim.new(1, 0)

    local subtitleLabel = Instance.new("TextLabel", topBar)
    subtitleLabel.Name = "Subtitle1212"
    subtitleLabel.Size = UDim2.new(1, -100, 0, 16)
    subtitleLabel.Position = UDim2.new(0, 50, 0, 42)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = "12:12"
    subtitleLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextSize = 12
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    subtitleLabel.TextYAlignment = Enum.TextYAlignment.Center
    subtitleLabel.ZIndex = 30

    -- Línea que divide el título de las opciones
    local headerDivider = Instance.new("Frame", topBar)
    headerDivider.Name = "HeaderDivider"
    headerDivider.Size = UDim2.new(1, -32, 0, 1)
    headerDivider.Position = UDim2.new(0, 16, 1, -1)
    headerDivider.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
    headerDivider.BackgroundTransparency = 0.25
    headerDivider.BorderSizePixel = 0
    headerDivider.ZIndex = 31

    local closeBtn = Instance.new("TextButton", topBar)
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0, 14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "−"
    closeBtn.TextColor3 = WHITE
    closeBtn.Font = Enum.Font.Fantasy
    closeBtn.TextSize = 26
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = SILVER_DARK}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = Color3.fromRGB(30,30,35)}):Play()
    end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Size = UDim2.new(0, 118, 0, 30)
    miniBtn.Position = UDim2.new(0, 16, 0, 58)
    miniBtn.BackgroundColor3 = BG2
    miniBtn.BackgroundTransparency = 0
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = "ELITE HUB"
    miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    miniBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.TextStrokeTransparency = 0
    miniBtn.Font = Enum.Font.GothamBlack
    miniBtn.TextSize = 14
    miniBtn.ZIndex = 30
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 8)
    -- sin shimmer para que se lea con imagen de fondo


    
    local animating = false
    showGui = function()
        if main.Visible then return end
        if animating then return end
        animating = true
        main.Visible = true
        main.Size = UDim2.new(0, 0, 0, 0)
        main.Position = UDim2.new(0.5, 0, 0.5, 0)
        TS:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, GUI_W, 0, GUI_H),
            Position = UDim2.new(0, 20, 0, 2)
        }):Play()
        miniBtn.Visible = false
        task.delay(0.4, function() animating = false end)
    end

    hideGui = function()
        if not main.Visible then return end
        if animating then return end
        animating = true
        TS:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.delay(0.28, function()
            main.Visible = false
            main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
            main.Position = UDim2.new(0, 20, 0, 2)
            miniBtn.Visible = true
            animating = false
        end)
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    
    -- Tabs horizontales deslizables (estilo Zurich, abajo)
    local TAB_H = 36
    local HEADER_H = 86
    local TAB_BTN_W = 72
    local tabBar = Instance.new("ScrollingFrame", main)
    tabBar.Name = "BottomTabs"
    tabBar.Size = UDim2.new(1, -16, 0, TAB_H)
    tabBar.Position = UDim2.new(0, 8, 1, -TAB_H - 8)
    tabBar.BackgroundTransparency = 1
    tabBar.BorderSizePixel = 0
    tabBar.ScrollBarThickness = 0
    tabBar.ScrollingDirection = Enum.ScrollingDirection.X
    tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabBar.ZIndex = 10
    tabBar.ClipsDescendants = true
    local tabList = Instance.new("UIListLayout", tabBar)
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 4)
    tabList.VerticalAlignment = Enum.VerticalAlignment.Center
    local tabPad = Instance.new("UIPadding", tabBar)
    tabPad.PaddingLeft = UDim.new(0, 2)
    tabPad.PaddingRight = UDim.new(0, 8)

    local tabContent = Instance.new("Frame", main)
    tabContent.Size = UDim2.new(1, -16, 1, -(HEADER_H + TAB_H + 20))
    tabContent.Position = UDim2.new(0, 8, 0, HEADER_H)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabs = {"Moment", "Combat", "Main", "Animation", "Settings", "Keybinds"}
    local tabButtons = {}
    local tabUnderlines = {}
    local contentPages = {}
    local nTabs = #tabs

    local function setTabActive(activeBtn)
        for _, b in ipairs(tabButtons) do
            b.TextColor3 = Color3.fromRGB(140, 140, 155)
            local u = tabUnderlines[b]
            if u then
                u.BackgroundTransparency = 1
                u.Size = UDim2.new(0, 0, 0, 2)
            end
        end
        activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        local au = tabUnderlines[activeBtn]
        if au then
            au.BackgroundTransparency = 0
            au.Size = UDim2.new(0.55, 0, 0, 2)
            au.Position = UDim2.new(0.225, 0, 1, -2)
        end
        -- Auto-scroll para centrar la pestaña activa
        pcall(function()
            local x = activeBtn.AbsolutePosition.X - tabBar.AbsolutePosition.X + tabBar.CanvasPosition.X
            local target = math.max(0, x - tabBar.AbsoluteSize.X * 0.35)
            TS:Create(tabBar, TweenInfo.new(0.2), {CanvasPosition = Vector2.new(target, 0)}):Play()
        end)
    end

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Name = "Tab_" .. name
        btn.Size = UDim2.new(0, TAB_BTN_W, 1, -4)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(140, 140, 155)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.TextWrapped = false
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.TextScaled = false
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.ZIndex = 11

        local underline = Instance.new("Frame", btn)
        underline.Name = "TabUnderline"
        underline.Size = UDim2.new(0, 0, 0, 2)
        underline.Position = UDim2.new(0.5, 0, 1, -2)
        underline.AnchorPoint = Vector2.new(0, 0)
        underline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        underline.BackgroundTransparency = 1
        underline.BorderSizePixel = 0
        underline.ZIndex = 12
        Instance.new("UICorner", underline).CornerRadius = UDim.new(1, 0)
        tabUnderlines[btn] = underline

        local page = Instance.new("ScrollingFrame", tabContent)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(0, 0, 0, 0)
        page.BackgroundColor3 = Color3.fromRGB(5,5,5)
        page.BackgroundTransparency = 0.92
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = Color3.fromRGB(30,30,35)
        page.ScrollBarImageTransparency = 0.3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.None
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        Instance.new("UICorner", page).CornerRadius = UDim.new(0, 16)
        page.Visible = (i == 1)

        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 7)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 80)

        local function updateCanvas()
            local contentSize = layout.AbsoluteContentSize
            local padBottom = padding.PaddingBottom.Offset
            local padTop = padding.PaddingTop.Offset
            local extra = 60
            page.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + padTop + padBottom + extra)
        end
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        task.spawn(updateCanvas)
        contentPages[name] = page

        btn.MouseButton1Click:Connect(function()
            for _, pg in pairs(contentPages) do pg.Visible = false end
            page.Visible = true
            setTabActive(btn)
            task.wait(0.05)
            updateCanvas()
        end)
        table.insert(tabButtons, btn)
    end
    if tabButtons[1] then
        setTabActive(tabButtons[1])
    end

    local pageCounters = {}
    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 22)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -20, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = Color3.fromRGB(120, 130, 155)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextStrokeTransparency = 1
        l.ZIndex = 8
        return f
    end

    local function mkRow(page, h)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -8, 0, h or 42)
        f.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
        f.BackgroundTransparency = 0.58
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        f.ClipsDescendants = true
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
        -- Sin stroke: se ve el fondo (estilo Zurich)
        local accent = Instance.new("Frame", f)
        accent.Name = "ZurichAccent"
        accent.Size = UDim2.new(0, 3, 0.58, 0)
        accent.Position = UDim2.new(0, 8, 0.21, 0)
        accent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        accent.BackgroundTransparency = 0.15
        accent.BorderSizePixel = 0
        accent.ZIndex = 8
        Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
        f.MouseEnter:Connect(function()
            TS:Create(f, TweenInfo.new(0.12), {BackgroundTransparency = 0.4}):Play()
        end)
        f.MouseLeave:Connect(function()
            TS:Create(f, TweenInfo.new(0.12), {BackgroundTransparency = 0.58}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.55, 0, 1, 0)
        l.Position = UDim2.new(0, 18, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(235, 240, 255)
        l.Font = Enum.Font.GothamMedium
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeTransparency = 1
        l.ZIndex = 8
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Size = UDim2.new(0, 46, 0, 24)
        pill.Position = UDim2.new(1, -(offset or 56), 0.5, -12)
        pill.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
        pill.BorderSizePixel = 0
        pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke", pill)
        stroke.Color = Color3.fromRGB(50, 58, 80)
        stroke.Thickness = 1
        stroke.Transparency = 0.4
        local dot = Instance.new("Frame", pill)
        dot.Size = UDim2.new(0, 18, 0, 18)
        dot.Position = UDim2.new(0, 3, 0.5, -9)
        dot.BackgroundColor3 = Color3.fromRGB(200, 205, 220)
        dot.BorderSizePixel = 0
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        return pill, dot
    end

    local function animPill(pill, dot, on)
        TS:Create(pill, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            BackgroundColor3 = on and Color3.fromRGB(240, 245, 255) or Color3.fromRGB(28, 32, 48)
        }):Play()
        TS:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
            BackgroundColor3 = on and Color3.fromRGB(30, 40, 70) or Color3.fromRGB(200, 205, 220)
        }):Play()
        local stroke = pill:FindFirstChildOfClass("UIStroke")
        if stroke then
            TS:Create(stroke, TweenInfo.new(0.18), {
                Color = on and Color3.fromRGB(200, 210, 240) or Color3.fromRGB(50, 58, 80),
                Transparency = on and 0.1 or 0.4
            }):Play()
        end
    end

    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 38)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 52)
        local on = false
        local function sv(s)
            on = s; animPill(pill, dot, s)
        end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            if editModeEnabled and not uiLocked then
                pcall(cb, not on)
            else
                on = not on
                sv(on)
                pcall(cb, on)
            end
        end)
        return sv
    end

    local function mkSelector(parent, default, options, cb)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.Fantasy
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1
        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(0, 80, 0, 26)
        label.Position = UDim2.new(0.5, -40, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = default
        label.TextColor3 = WHITE
        label.Font = Enum.Font.Fantasy
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.Fantasy
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1
        local function updateLabel(newText)
            label.Text = newText
        end
        leftBtn.MouseButton1Click:Connect(function()
            if cb then cb(-1, updateLabel) end
        end)
        rightBtn.MouseButton1Click:Connect(function()
            if cb then cb(1, updateLabel) end
        end)
        return label
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
        tb.BackgroundTransparency = 0.1
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = Color3.fromRGB(235, 240, 255)
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 12
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 8)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = Color3.fromRGB(50, 58, 80)
        bs.Thickness = 1
        bs.Transparency = 0.3
        tb.Focused:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = WHITE, Transparency = 0}):Play()
        end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = ROW_BORDER, Transparency = 0.25}):Play()
            if cb then
                local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end
            end
        end)
        return tb
    end

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 80, 0, 24)
        btn.Position = UDim2.new(1, -88, 0.5, -12)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        local function getLabel()
            return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None"
        end
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.Fantasy
        btn.TextSize = 9
        btn.ZIndex = 8
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = ROW_BORDER
        bs.Thickness = 1
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return
            end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = tick(); btn.Text = "..."; btn.TextColor3 = WHITE
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then
                    li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return
                end
                local isGp = isGamepadInput(inp)
                if isGp and tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = WHITE
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end
                if isGp then
                    kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
                else
                    kbEntry.kb = inp.KeyCode; kbEntry.gp = nil
                end
            end)
        end)
        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry})
        return btn
    end

    local function addKeybindRow(page, labelText, kbEntry)
        local row = mkRow(page, 36)
        mkLabel(row, labelText)
        mkKeyButton(row, kbEntry)
    end

    
    
    
    local momentPage = contentPages["Moment"]

    mkSect(momentPage, "SPEED")
    do
        local row = mkRow(momentPage, 38); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 56, function(v) if v > 0 and v <= 500 then NS = v end; saveAllSettings() end)
    end
    do
        local row = mkRow(momentPage, 38); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v > 0 and v <= 500 then CS = v end; saveAllSettings() end)
    end
    do
        local row = mkRow(momentPage, 38); mkLabel(row, "Lagger 1 Speed"); laggerBox = mkBox(row, LAGGER_SPEED_1, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED_1 = v end; saveAllSettings() end)
    end
    do
        local row = mkRow(momentPage, 38); mkLabel(row, "Lagger 2 Speed"); lagger2Box = mkBox(row, LAGGER_SPEED_2, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED_2 = v end; saveAllSettings() end)
    end
    do
        local row = mkRow(momentPage, 38)
        mkLabel(row, "Current Mode")
        modeValLbl = Instance.new("TextLabel", row)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = WHITE
        modeValLbl.Font = Enum.Font.Fantasy
        modeValLbl.TextSize = 11
        modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
        modeValLbl.ZIndex = 8
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function()
            toggleCarryMode()
            saveAllSettings()
        end)
    end

    mkSect(momentPage, "INFINITY & MOVEMENT")
    infJumpSetVisual = mkToggle(momentPage, "Infinity Jump", function(on)
        InfJumpState.enabled = on
        saveAllSettings()
    end)
    autoLeftSetVisual = mkToggle(momentPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
        saveAllSettings()
    end)
    autoRightSetVisual = mkToggle(momentPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
        saveAllSettings()
    end)

    mkSect(momentPage, "DROP & TP")
    dropBrainrotSetVisual = mkToggle(momentPage, "Drop Brainrot", function(on)
        if on then executeDropWithToggle(function(v) dropBrainrotSetVisual(v) if mobSetDropBR then mobSetDropBR(v) end end) end
    end)
    setDropVisual = dropBrainrotSetVisual
    do
        local row = mkRow(momentPage, 38)
        mkLabel(row, "Drop Mode")
        dropModeBtnRef = mkSelector(row, dropMode == 1 and "Fling" or "Jump Drop", {"Fling", "Jump Drop"}, function(dir, update)
            if dropActive then stopDropBrainrot() end
            dropMode = dropMode == 1 and 2 or 1
            update(dropMode == 1 and "Fling" or "Jump Drop")
            saveAllSettings()
        end)
    end
    do
        local row = mkRow(momentPage, 38)
        mkLabel(row, "TP Down")
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(0.58, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function()
            doTpDown()
        end)
        local actLbl = Instance.new("TextLabel", row)
        actLbl.Size = UDim2.new(0, 70, 1, 0)
        actLbl.Position = UDim2.new(1, -78, 0, 0)
        actLbl.BackgroundTransparency = 1
        actLbl.Text = "ACTIVATE"
        actLbl.TextColor3 = WHITE
        actLbl.Font = Enum.Font.Fantasy
        actLbl.TextSize = 9
        actLbl.TextXAlignment = Enum.TextXAlignment.Right
        actLbl.ZIndex = 8
    end

    
    
    
    local combatPage = contentPages["Combat"]

    mkSect(combatPage, "AIMBOTS")
    autoBatSetVisual = mkToggle(combatPage, "Auto Bat", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
        saveAllSettings()
    end)
    tpLockSetVisual = mkToggle(combatPage, "Bypass Aimbot", function(on)
        if on then
            if not _G.AceAntiDesyncAimbotOn then startAntiDesyncAimbot() end
        else
            if _G.AceAntiDesyncAimbotOn then stopAntiDesyncAimbot() end
        end
        saveAllSettings()
    end)
    if tpLockSetVisual then tpLockSetVisual(_G.AceAntiDesyncAimbotOn) end
    
    autoBatV2SetVisual = mkToggle(combatPage, "Bat Bypass", function(on)
        if on then enableBatV2() else disableBatV2() end
        saveAllSettings()
    end)
    if autoBatV2SetVisual then autoBatV2SetVisual(autoBatV2Enabled) end

    mkSect(combatPage, "COUNTERS")
    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
        saveAllSettings()
    end)
    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
        setMedusaCounterState(on)
        saveAllSettings()
    end)
    setMedusaAutoResetVisual = mkToggle(combatPage, "Medusa Reset", function(on)
        setMedusaAutoResetState(on)
        saveAllSettings()
    end)

    mkSect(combatPage, "DEFENSE")
    setAntiDropVisual = mkToggle(combatPage, "Anti Drop", function(on)
        if on then startAntiDrop() else stopAntiDrop() end
        saveAllSettings()
    end)
    if setAntiDropVisual then setAntiDropVisual(antiDropEnabled) end
    setAntiRagVisual = mkToggle(combatPage, "Anti Ragdoll", function(on)
        setAntiRag(on)
        saveAllSettings()
    end)
    bodyLockSetVisual = mkToggle(combatPage, "Body Lock", function(on)
        bodyLockEnabled = on
        if on then
            if _blSuppressCount == 0 then startBodyLock() end
        else
            stopBodyLock()
        end
        saveAllSettings()
    end)
    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Body Lock Range")
        bodyLockRangeBox = mkBox(row, bodyLockRange, 50, 56, function(v)
            if v and v > 0 then
                bodyLockRange = math.clamp(math.floor(v), 5, 200)
                if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
                saveAllSettings()
            end
        end)
    end

    
    
    
    local mainPage = contentPages["Main"]
    local animationPage = contentPages["Animation"]
    local settingsPage = contentPages["Settings"]

    mkSect(mainPage, "AUTO STEAL")
    setInstaGrab = mkToggle(mainPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on
        if on then
            pcall(startAutoSteal)
        else
            stopAutoSteal()
        end
        updateProgressBarVisibility()
        saveAllSettings()
    end)
    do
        local row = mkRow(mainPage, 38)
        mkLabel(row, "Steal Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = math.floor(v+0.5)
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                if progressRadLbl then progressRadLbl.Text = "Radius: " .. tostring(CONFIG.STEAL_RANGE) end
                saveAllSettings()
            end
        end)
    end

    mkSect(settingsPage, "DEFENSE")
    do
        -- Anti Die row (custom so we can attach expand arrow)
        local antiDieRow = mkRow(settingsPage, 38)
        local antiDieLabel = mkLabel(antiDieRow, "Anti Die")
        antiDieLabel.Size = UDim2.new(1, -170, 1, -4)
        local antiDiePill, antiDieDot = mkPill(antiDieRow, 52)
        local antiDieOn = false
        setAntiDieVisual = function(s)
            antiDieOn = s
            animPill(antiDiePill, antiDieDot, s)
        end
        local antiDieClk = Instance.new("TextButton", antiDiePill)
        antiDieClk.Size = UDim2.new(1, 0, 1, 0)
        antiDieClk.BackgroundTransparency = 1
        antiDieClk.Text = ""
        antiDieClk.AutoButtonColor = false
        antiDieClk.ZIndex = 10
        antiDieClk.MouseButton1Click:Connect(function()
            antiDieOn = not antiDieOn
            setAntiDieVisual(antiDieOn)
            if antiDieOn then startAntiDie() else stopAntiDie() end
            saveAllSettings()
        end)

        -- Anti-Fling Shield sub-row (hidden until arrow expanded)
        local antiFlingRow = mkRow(settingsPage, 38)
        antiFlingRow.Name = "AntiFlingShieldRow"
        antiFlingRow.Visible = false
        mkLabel(antiFlingRow, "Anti-Fling Shield")
        local flingPill, flingDot = mkPill(antiFlingRow, 52)
        local flingOn = false
        setAntiFlingVisual = function(s)
            flingOn = s
            animPill(flingPill, flingDot, s)
        end
        local flingClk = Instance.new("TextButton", flingPill)
        flingClk.Size = UDim2.new(1, 0, 1, 0)
        flingClk.BackgroundTransparency = 1
        flingClk.Text = ""
        flingClk.AutoButtonColor = false
        flingClk.ZIndex = 10
        flingClk.MouseButton1Click:Connect(function()
            flingOn = not flingOn
            setAntiFlingVisual(flingOn)
            if flingOn then startAntiFlingShield() else stopAntiFlingShield() end
            saveAllSettings()
        end)

        -- Arrow like Coca-Cola
        local arrow = Instance.new("TextButton", antiDieRow)
        arrow.Name = "DefenseArrow"
        arrow.Size = UDim2.new(0, 26, 0, 26)
        arrow.Position = UDim2.new(1, -152, 0.5, -13)
        arrow.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
        arrow.BackgroundTransparency = 0.14
        arrow.BorderSizePixel = 0
        arrow.Text = ">"
        arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
        arrow.Font = Enum.Font.Fantasy
        arrow.TextSize = 16
        arrow.ZIndex = 20
        Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 13)
        local arrowOpen = false
        arrow.MouseButton1Click:Connect(function()
            arrowOpen = not arrowOpen
            antiFlingRow.Visible = arrowOpen
            arrow.Text = arrowOpen and "v" or ">"
            arrow.BackgroundColor3 = arrowOpen and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(12, 12, 12)
            arrow.TextColor3 = arrowOpen and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        end)

        if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end
        if setAntiFlingVisual then setAntiFlingVisual(antiFlingShieldEnabled) end
    end


    mkSect(mainPage, "SKY THEME")
    do
        local row = mkRow(mainPage, 38)
        mkLabel(row, "Sky Theme")
        local currentIndex = 1
        for i, entry in ipairs(CANDY_SKY_ORDER) do
            if entry[2] == currentSkyTheme then currentIndex = i; break end
        end
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 180, 1, 0)
        container.Position = UDim2.new(1, -188, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.Fantasy
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1
        skySelectorLabel = Instance.new("TextLabel", container)
        skySelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        skySelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = CANDY_SKY_ORDER[currentIndex][2]
        skySelectorLabel.TextColor3 = WHITE
        skySelectorLabel.Font = Enum.Font.Fantasy
        skySelectorLabel.TextSize = 12
        skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        skySelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.Fantasy
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1
        local function updateSkySelector(direction)
            local idx = 1
            for i, entry in ipairs(CANDY_SKY_ORDER) do
                if entry[2] == currentSkyTheme then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #CANDY_SKY_ORDER end
            if newIdx > #CANDY_SKY_ORDER then newIdx = 1 end
            setSkyTheme(CANDY_SKY_ORDER[newIdx][2])
            saveAllSettings()
        end
        leftBtn.MouseButton1Click:Connect(function() updateSkySelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateSkySelector(1) end)
    end

    
    mkSect(animationPage, "SKIN PACK")
    do
        local row = mkRow(animationPage, 38)
        mkLabel(row, "Skin Pack")
        local currentIndex = 1
        for i, entry in ipairs(ACCESSORY_PACK_ORDER) do
            if entry[2] == currentAccessoryPack then currentIndex = i; break end
        end
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 180, 1, 0)
        container.Position = UDim2.new(1, -188, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.Fantasy
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1
        accSelectorLabel = Instance.new("TextLabel", container)
        accSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        accSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        accSelectorLabel.BackgroundTransparency = 1
        accSelectorLabel.Text = ACCESSORY_PACK_ORDER[currentIndex][2]
        accSelectorLabel.TextColor3 = WHITE
        accSelectorLabel.Font = Enum.Font.Fantasy
        accSelectorLabel.TextSize = 12
        accSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        accSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.Fantasy
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1
        local function updateAccessorySelector(direction)
            local idx = 1
            for i, entry in ipairs(ACCESSORY_PACK_ORDER) do
                if entry[2] == currentAccessoryPack then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #ACCESSORY_PACK_ORDER end
            if newIdx > #ACCESSORY_PACK_ORDER then newIdx = 1 end
            currentAccessoryPack = ACCESSORY_PACK_ORDER[newIdx][2]
            accSelectorLabel.Text = currentAccessoryPack
            applyAccessoryPack(currentAccessoryPack)
            saveAllSettings()
        end
        leftBtn.MouseButton1Click:Connect(function() updateAccessorySelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateAccessorySelector(1) end)
    end

    
    mkSect(animationPage, "ANIM PACK")
    do
        local row = mkRow(animationPage, 38)
        mkLabel(row, "Anim Pack")
        local currentIndex = 1
        for i, entry in ipairs(ANIM_PACK_ORDER) do
            if entry[2] == currentAnimPack then currentIndex = i; break end
        end
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 180, 1, 0)
        container.Position = UDim2.new(1, -188, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.Fantasy
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1
        animSelectorLabel = Instance.new("TextLabel", container)
        animSelectorLabel.Size = UDim2.new(0, 100, 0, 26)
        animSelectorLabel.Position = UDim2.new(0.5, -50, 0.5, -13)
        animSelectorLabel.BackgroundTransparency = 1
        animSelectorLabel.Text = ANIM_PACK_ORDER[currentIndex][2]
        animSelectorLabel.TextColor3 = WHITE
        animSelectorLabel.Font = Enum.Font.Fantasy
        animSelectorLabel.TextSize = 12
        animSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        animSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.Fantasy
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1
        local function updateAnimSelector(direction)
            local idx = 1
            for i, entry in ipairs(ANIM_PACK_ORDER) do
                if entry[2] == currentAnimPack then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #ANIM_PACK_ORDER end
            if newIdx > #ANIM_PACK_ORDER then newIdx = 1 end
            local packName = ANIM_PACK_ORDER[newIdx][2]
            if packName == "Off" then
                stopAnimPack()
            else
                startAnimPack(packName)
            end
            saveAllSettings()
        end
        leftBtn.MouseButton1Click:Connect(function() updateAnimSelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateAnimSelector(1) end)
    end

    -- Pack Accessory (Bleed) - imagen
    mkSect(animationPage, "PACK ACCESSORY")
    do
        local row = mkRow(animationPage, 38)
        mkLabel(row, "Pack Accessory")
        local currentIndex = 1
        for i, entry in ipairs(BLEED_PACK_ORDER) do
            if entry[2] == currentBleedPack then currentIndex = i; break end
        end
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 180, 1, 0)
        container.Position = UDim2.new(1, -188, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.Fantasy
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        bleedSelectorLabel = Instance.new("TextLabel", container)
        bleedSelectorLabel.Size = UDim2.new(0, 100, 0, 26)
        bleedSelectorLabel.Position = UDim2.new(0.5, -50, 0.5, -13)
        bleedSelectorLabel.BackgroundTransparency = 1
        bleedSelectorLabel.Text = BLEED_PACK_ORDER[currentIndex][2]
        bleedSelectorLabel.TextColor3 = WHITE
        bleedSelectorLabel.Font = Enum.Font.Fantasy
        bleedSelectorLabel.TextSize = 12
        bleedSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        bleedSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.Fantasy
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateBleed(direction)
            local idx = 1
            for i, entry in ipairs(BLEED_PACK_ORDER) do
                if entry[2] == currentBleedPack then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #BLEED_PACK_ORDER end
            if newIdx > #BLEED_PACK_ORDER then newIdx = 1 end
            applyBleedPack(BLEED_PACK_ORDER[newIdx][2])
            saveAllSettings()
        end
        leftBtn.MouseButton1Click:Connect(function() updateBleed(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateBleed(1) end)
    end

    -- Music Pack (imagen: Migizin)
    mkSect(animationPage, "MUSIC")
    do
        local row = mkRow(animationPage, 38)
        mkLabel(row, "Music Pack")
        local currentIndex = 1
        for i, entry in ipairs(MUSIC_PACK_ORDER) do
            if entry[2] == currentMusicPack then currentIndex = i; break end
        end
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 180, 1, 0)
        container.Position = UDim2.new(1, -188, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.Fantasy
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        musicSelectorLabel = Instance.new("TextLabel", container)
        musicSelectorLabel.Size = UDim2.new(0, 100, 0, 26)
        musicSelectorLabel.Position = UDim2.new(0.5, -50, 0.5, -13)
        musicSelectorLabel.BackgroundTransparency = 1
        musicSelectorLabel.Text = MUSIC_PACK_ORDER[currentIndex][2]
        musicSelectorLabel.TextColor3 = WHITE
        musicSelectorLabel.Font = Enum.Font.Fantasy
        musicSelectorLabel.TextSize = 12
        musicSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        musicSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.Fantasy
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateMusic(direction)
            local idx = 1
            for i, entry in ipairs(MUSIC_PACK_ORDER) do
                if entry[2] == currentMusicPack then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #MUSIC_PACK_ORDER end
            if newIdx > #MUSIC_PACK_ORDER then newIdx = 1 end
            playMusicPack(MUSIC_PACK_ORDER[newIdx][2])
            saveAllSettings()
        end
        leftBtn.MouseButton1Click:Connect(function() updateMusic(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateMusic(1) end)
    end


    setESPVIsual = mkToggle(mainPage, "Player ESP", function(on)
        toggleESP(on)
        saveAllSettings()
    end)

    
    do
        local row = mkRow(mainPage, 38)
        mkLabel(row, "Stretch Rez")
        local stretchPill, stretchDot = mkPill(row, 52)
        local stretchOn = false
        local function setStretch(s)
            stretchOn = s
            animPill(stretchPill, stretchDot, s)
            if s then enableStretch() else disableStretch() end
            stretchEnabled = s
            saveAllSettings()
        end
        local stretchClk = Instance.new("TextButton", stretchPill)
        stretchClk.Size = UDim2.new(1,0,1,0)
        stretchClk.BackgroundTransparency = 1
        stretchClk.Text = ""
        stretchClk.AutoButtonColor = false
        stretchClk.ZIndex = 10
        stretchClk.MouseButton1Click:Connect(function()
            setStretch(not stretchOn)
        end)
        _G.stretchToggleSetter = setStretch
    end

    
    fovContainer = Instance.new("Frame", mainPage)
    fovContainer.Size = UDim2.new(1, -4, 0, 38)
    fovContainer.BackgroundColor3 = ROW_BG
    fovContainer.BackgroundTransparency = 0.7
    fovContainer.BorderSizePixel = 0
    fovContainer.LayoutOrder = getNextOrder(mainPage)
    fovContainer.ZIndex = 7
    fovContainer.Visible = true
    Instance.new("UICorner", fovContainer).CornerRadius = UDim.new(0, 10)
    local fovStroke = Instance.new("UIStroke", fovContainer)
    fovStroke.Color = ROW_BORDER
    fovStroke.Thickness = 1
    fovStroke.Transparency = 0.5
    local fovLabel = Instance.new("TextLabel", fovContainer)
    fovLabel.Size = UDim2.new(0.25, 0, 1, 0)
    fovLabel.Position = UDim2.new(0, 10, 0, 0)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = "FOV"
    fovLabel.TextColor3 = WHITE
    fovLabel.Font = Enum.Font.Fantasy
    fovLabel.TextSize = 11
    fovLabel.TextXAlignment = Enum.TextXAlignment.Left
    fovLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    fovLabel.TextStrokeTransparency = 0.5
    fovLabel.ZIndex = 8
    local fovBtnFrame = Instance.new("Frame", fovContainer)
    fovBtnFrame.Size = UDim2.new(0, 150, 1, 0)
    fovBtnFrame.Position = UDim2.new(1, -162, 0, 0)
    fovBtnFrame.BackgroundTransparency = 1
    fovBtnFrame.ZIndex = 8
    local function makeFOVBtn(val, x)
        local btn = Instance.new("TextButton", fovBtnFrame)
        btn.Size = UDim2.new(0, 42, 0, 26)
        btn.Position = UDim2.new(0, x, 0.5, -13)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.7
        btn.BorderSizePixel = 0
        btn.Text = tostring(val)
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.Fantasy
        btn.TextSize = 11
        btn.AutoButtonColor = false
        btn.ZIndex = 9
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = ROW_BORDER
        stroke.Thickness = 1
        if val == stretchFOV then
            btn.BackgroundColor3 = WHITE
            btn.TextColor3 = Color3.fromRGB(0,0,0)
        end
        btn.MouseButton1Click:Connect(function()
            stretchFOV = val
            if stretchEnabled then applyStretchFOV(val) end
            for _, b in ipairs(fovBtnFrame:GetChildren()) do
                if b:IsA("TextButton") then
                    local v = tonumber(b.Text)
                    if v == val then
                        b.BackgroundColor3 = WHITE
                        b.TextColor3 = Color3.fromRGB(0,0,0)
                    else
                        b.BackgroundColor3 = INP
                        b.TextColor3 = WHITE
                    end
                end
            end
            saveAllSettings()
        end)
        return btn
    end
    makeFOVBtn(90, 0)
    makeFOVBtn(120, 54)
    makeFOVBtn(180, 108)
    _G.fovButtons = fovBtnFrame:GetChildren()

    setAntiLagVisual = mkToggle(settingsPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
        saveAllSettings()
    end)

    mkSect(settingsPage, "INTERFACE")
    setEditModeVisual = mkToggle(settingsPage, "Edit Button", function(on)
        toggleEditMode(on)
        if on and uiLocked then
            editModeEnabled = false
            setEditModeVisual(false)
        end
        saveAllSettings()
    end)
    if setEditModeVisual then setEditModeVisual(editModeEnabled) end
    setLockUIVisual = mkToggle(settingsPage, "Lock UI", function(on)
        toggleLockUI(on)
        if on and editModeEnabled then
            editModeEnabled = false
            if setEditModeVisual then setEditModeVisual(false) end
        end
        saveAllSettings()
    end)

    
    -- Buttons Size (0-100) imagen
    do
        local row = mkRow(settingsPage, 38)
        mkLabel(row, "Buttons Size")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 150, 1, 0)
        container.Position = UDim2.new(1, -160, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 32, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.Fantasy
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local valueLabel = Instance.new("TextLabel", container)
        valueLabel.Size = UDim2.new(0, 70, 0, 26)
        valueLabel.Position = UDim2.new(0.5, -35, 0.5, -13)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(buttonsSizeValue)
        valueLabel.TextColor3 = WHITE
        valueLabel.Font = Enum.Font.Fantasy
        valueLabel.TextSize = 12
        valueLabel.TextXAlignment = Enum.TextXAlignment.Center
        valueLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 32, 0, 26)
        rightBtn.Position = UDim2.new(1, -32, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.Fantasy
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateSize(delta)
            local newVal = math.clamp(buttonsSizeValue + delta, 0, 100)
            if newVal ~= buttonsSizeValue then
                applyMobileButtonsSize(newVal)
                valueLabel.Text = tostring(buttonsSizeValue)
                saveAllSettings()
            end
        end
        leftBtn.MouseButton1Click:Connect(function() updateSize(-5) end)
        rightBtn.MouseButton1Click:Connect(function() updateSize(5) end)
        _G.buttonsSizeValueLabel = valueLabel
        _G.buttonScaleValueLabel = valueLabel
    end

    -- Buttons Shape (Circle / Normal / Square / Rectangle) imagen
    do
        local row = mkRow(settingsPage, 38)
        mkLabel(row, "Buttons Shape")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 150, 1, 0)
        container.Position = UDim2.new(1, -160, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 32, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 30)
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.Fantasy
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(1, 0)
        local valueLabel = Instance.new("TextLabel", container)
        valueLabel.Size = UDim2.new(0, 70, 0, 26)
        valueLabel.Position = UDim2.new(0.5, -35, 0.5, -13)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(buttonsShape)
        valueLabel.TextColor3 = WHITE
        valueLabel.Font = Enum.Font.Fantasy
        valueLabel.TextSize = 12
        valueLabel.TextXAlignment = Enum.TextXAlignment.Center
        valueLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 32, 0, 26)
        rightBtn.Position = UDim2.new(1, -32, 0.5, -13)
        rightBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 30)
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.Fantasy
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(1, 0)
        local function updateShape(direction)
            local idx = 1
            for i, s in ipairs(BUTTON_SHAPE_ORDER) do
                if s == buttonsShape then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #BUTTON_SHAPE_ORDER end
            if newIdx > #BUTTON_SHAPE_ORDER then newIdx = 1 end
            applyMobileButtonsShape(BUTTON_SHAPE_ORDER[newIdx])
            valueLabel.Text = buttonsShape
            saveAllSettings()
        end
        leftBtn.MouseButton1Click:Connect(function() updateShape(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateShape(1) end)

        _G.buttonsShapeLabel = valueLabel
    end

    do
        local row = mkRow(settingsPage, 38)
        mkLabel(row, "UI Scale")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 150, 1, 0)
        container.Position = UDim2.new(1, -160, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 32, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.Fantasy
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1
        local valueLabel = Instance.new("TextLabel", container)
        valueLabel.Size = UDim2.new(0, 70, 0, 26)
        valueLabel.Position = UDim2.new(0.5, -35, 0.5, -13)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = string.format("%.2f", uiScaleValue / 100)
        valueLabel.TextColor3 = WHITE
        valueLabel.Font = Enum.Font.Fantasy
        valueLabel.TextSize = 12
        valueLabel.TextXAlignment = Enum.TextXAlignment.Center
        valueLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 32, 0, 26)
        rightBtn.Position = UDim2.new(1, -32, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.Fantasy
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1
        local function updateUIScale(delta)
            local newVal = uiScaleValue + delta
            newVal = math.clamp(newVal, 50, 150)
            if newVal ~= uiScaleValue then
                uiScaleValue = newVal
                if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
                if pbScale then pbScale.Scale = uiScaleValue / 100 end
                valueLabel.Text = string.format("%.2f", uiScaleValue / 100)
                if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
                saveAllSettings()
            end
        end
        leftBtn.MouseButton1Click:Connect(function() updateUIScale(-5) end)
        rightBtn.MouseButton1Click:Connect(function() updateUIScale(5) end)
        _G.uiScaleValueLabel = valueLabel
    end

    -- FONDS: fondo del menú + barra steal
    mkSect(settingsPage, "FONDS")
    do
        local row = mkRow(settingsPage, 56)
        row.ClipsDescendants = false
        local scroll = Instance.new("ScrollingFrame", row)
        scroll.Name = "FondsScroll"
        scroll.Size = UDim2.new(1, -16, 1, -8)
        scroll.Position = UDim2.new(0, 8, 0, 4)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 0
        scroll.ScrollingDirection = Enum.ScrollingDirection.X
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.X
        scroll.ZIndex = 8
        local list = Instance.new("UIListLayout", scroll)
        list.FillDirection = Enum.FillDirection.Horizontal
        list.Padding = UDim.new(0, 6)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.VerticalAlignment = Enum.VerticalAlignment.Center
        local fondsButtons = {}
        local function updateFondsBtns()
            for idx, b in pairs(fondsButtons) do
                local on = (idx == currentMenuBackground)
                local st = b:FindFirstChildOfClass("UIStroke")
                if st then
                    st.Color = on and WHITE or Color3.fromRGB(60, 60, 70)
                    st.Transparency = on and 0 or 0.45
                    st.Thickness = on and 1.5 or 1
                end
                if b:IsA("ImageButton") then
                    b.ImageTransparency = on and 0 or 0.25
                end
            end
        end
        -- NONE
        do
            local b = Instance.new("ImageButton", scroll)
            b.Size = UDim2.new(0, 48, 0, 38)
            b.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
            b.BorderSizePixel = 0
            b.Image = ""
            b.AutoButtonColor = false
            b.LayoutOrder = 0
            b.ZIndex = 9
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
            local st = Instance.new("UIStroke", b)
            st.Color = Color3.fromRGB(60, 60, 70)
            st.Thickness = 1
            local lbl = Instance.new("TextLabel", b)
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "NONE"
            lbl.TextColor3 = WHITE
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 10
            lbl.ZIndex = 10
            b.MouseButton1Click:Connect(function()
                applyMenuBackground(0)
                updateFondsBtns()
                saveAllSettings()
            end)
            fondsButtons[0] = b
        end
        for i, id in ipairs(MENU_BG_IDS) do
            local b = Instance.new("ImageButton", scroll)
            b.Size = UDim2.new(0, 48, 0, 38)
            b.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
            b.BorderSizePixel = 0
            b.Image = "rbxassetid://" .. tostring(id)
            b.ScaleType = Enum.ScaleType.Crop
            b.AutoButtonColor = false
            b.LayoutOrder = i
            b.ZIndex = 9
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
            local st = Instance.new("UIStroke", b)
            st.Color = Color3.fromRGB(60, 60, 70)
            st.Thickness = 1
            local idx = i
            b.MouseButton1Click:Connect(function()
                applyMenuBackground(idx)
                updateFondsBtns()
                saveAllSettings()
            end)
            fondsButtons[i] = b
        end
        updateFondsBtns()
        task.defer(updateFondsBtns)
        _G.VeneyorkUpdateFondsButtons = updateFondsBtns
    end

    
    do
        local row = mkRow(mainPage, 38)
        mkLabel(row, "UI Scale (value)")
        uiScaleBox = mkBox(row, uiScaleValue, 50, 56, function(v)
            local n = math.clamp(math.floor(v+0.5), 50, 150)
            uiScaleValue = n
            if mainUIScale then mainUIScale.Scale = n/100 end
            if pbScale then pbScale.Scale = n/100 end
            if _G.uiScaleValueLabel then _G.uiScaleValueLabel.Text = string.format("%.2f", n/100) end
            saveAllSettings()
        end)
    end

    -- Save / Reset (Main)
    mkSect(mainPage, "CONFIG")
    do
        local row = mkRow(mainPage, 44)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(1, -20, 0.78, 0)
        saveBtn.Position = UDim2.new(0, 14, 0.11, 0)
        saveBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
        saveBtn.BackgroundTransparency = 0.25
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = WHITE
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 12
        saveBtn.AutoButtonColor = false
        saveBtn.ZIndex = 8
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 10)
        saveBtn.MouseButton1Click:Connect(function()
            local ok = saveAllSettings()
            saveBtn.Text = ok and "SAVED ✓" or "ERROR"
            task.delay(1.2, function()
                if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE CONFIG" end
            end)
        end)
    end
    do
        local row = mkRow(mainPage, 44)
        local resetPosBtn = Instance.new("TextButton", row)
        resetPosBtn.Size = UDim2.new(1, -20, 0.78, 0)
        resetPosBtn.Position = UDim2.new(0, 14, 0.11, 0)
        resetPosBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
        resetPosBtn.BackgroundTransparency = 0.25
        resetPosBtn.BorderSizePixel = 0
        resetPosBtn.Text = "RESET POSITIONS"
        resetPosBtn.TextColor3 = WHITE
        resetPosBtn.Font = Enum.Font.GothamBold
        resetPosBtn.TextSize = 12
        resetPosBtn.AutoButtonColor = false
        resetPosBtn.ZIndex = 8
        Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 10)
        local resetDebounce = false
        resetPosBtn.MouseButton1Click:Connect(function()
            if resetDebounce then return end
            resetDebounce = true
            pcall(resetFloatingPositions)
            resetPosBtn.Text = "RESET ✓"
            task.delay(1.2, function()
                if resetPosBtn and resetPosBtn.Parent then
                    resetPosBtn.Text = "RESET POSITIONS"
                    resetDebounce = false
                end
            end)
        end)
    end
    do
        local row = mkRow(mainPage, 44)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(1, -20, 0.78, 0)
        delBtn.Position = UDim2.new(0, 14, 0.11, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(70, 18, 22)
        delBtn.BackgroundTransparency = 0.2
        delBtn.BorderSizePixel = 0
        delBtn.Text = "DELETE SETTINGS"
        delBtn.TextColor3 = WHITE
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 12
        delBtn.AutoButtonColor = false
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 10)
        local deleteState = 0
        local originalDeleteText = "DELETE SETTINGS"
        local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then
                deleteState = 1
                delBtn.Text = "CONFIRM?"
                delBtn.BackgroundColor3 = Color3.fromRGB(140, 30, 30)
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(70, 18, 22)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local success = pcall(resetToFactoryDefaults)
                delBtn.Text = success and "DELETED ✓" or "ERROR"
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(70, 18, 22)
                        delDebounce = false
                    end
                end)
            end
        end)
    end

    local keyPage = contentPages["Keybinds"]
    mkSect(keyPage, "KEYBINDS")
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)
    addKeybindRow(keyPage, "Auto Bat", KB.AutoBat)
    addKeybindRow(keyPage, "Bypass Aimbot", KB.TPLock)
    
    addKeybindRow(keyPage, "Bat Bypass", KB.BatV2)   
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "Insta Reset", KB.InstaReset)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    local spacer = Instance.new("Frame", keyPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keyPage)
    spacer.ZIndex = 7

    
    
    
    -- ========== NIGHT #3.VS Auto Steal Bar (SCAN + Radius + MOVE + START/STOP) ==========
    pbFrame = Instance.new("Frame", gui)
    pbFrame.Name = "VeneyorkStealBar"
    pbFrame.Size = UDim2.new(0, 300, 0, 42)
    pbFrame.Position = UDim2.new(0.5, -150, 0, 80)
    pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pbFrame.BorderSizePixel = 0
    pbFrame.ClipsDescendants = true
    pbFrame.Active = true
    pbFrame.Visible = (CONFIG.AUTO_STEAL_ENABLED == true)
    pbFrame.ZIndex = 50
    pbScale = Instance.new("UIScale", pbFrame)
    pbScale.Scale = uiScaleValue / 100
    if savedProgressBarPos then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5,
            savedProgressBarPos.XOffset or -150,
            savedProgressBarPos.YScale or 0,
            savedProgressBarPos.YOffset or 80
        )
    end
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 12)
    local pbStroke = Instance.new("UIStroke", pbFrame)
    pbStroke.Color = Color3.fromRGB(220, 220, 230)
    pbStroke.Thickness = 1.4
    pbStroke.Transparency = 0.25

    -- Misma imagen de fondo del menú en la barra Steal
    stealBarBgImage = Instance.new("ImageLabel", pbFrame)
    stealBarBgImage.Name = "StealBarBackground"
    stealBarBgImage.BackgroundTransparency = 1
    stealBarBgImage.ImageTransparency = 0.25
    stealBarBgImage.ScaleType = Enum.ScaleType.Crop
    stealBarBgImage.Size = UDim2.new(1, 0, 1, 0)
    stealBarBgImage.Position = UDim2.new(0, 0, 0, 0)
    stealBarBgImage.ZIndex = 50
    stealBarBgImage.Visible = false
    Instance.new("UICorner", stealBarBgImage).CornerRadius = UDim.new(0, 12)
    -- Oscurecer un poco para que se lean SCAN / botones
    local stealDim = Instance.new("Frame", pbFrame)
    stealDim.Name = "StealBarDim"
    stealDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    stealDim.BackgroundTransparency = 0.45
    stealDim.BorderSizePixel = 0
    stealDim.Size = UDim2.new(1, 0, 1, 0)
    stealDim.ZIndex = 51
    Instance.new("UICorner", stealDim).CornerRadius = UDim.new(0, 12)
    -- Aplicar imagen actual del menú
    pcall(function()
        if currentMenuBackground and currentMenuBackground > 0 and MENU_BG_IDS[currentMenuBackground] then
            stealBarBgImage.Image = "rbxassetid://" .. tostring(MENU_BG_IDS[currentMenuBackground])
            stealBarBgImage.ImageColor3 = MENU_THEME_COLORS[currentMenuTheme] or Color3.fromRGB(255, 255, 255)
            stealBarBgImage.Visible = true
            pbFrame.BackgroundTransparency = 0.35
        end
    end)

    -- SCAN indicator (left red dot + label)
    local scanDot = Instance.new("Frame", pbFrame)
    scanDot.Size = UDim2.new(0, 10, 0, 10)
    scanDot.Position = UDim2.new(0, 10, 0, 8)
    scanDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    scanDot.BorderSizePixel = 0
    scanDot.ZIndex = 52
    Instance.new("UICorner", scanDot).CornerRadius = UDim.new(1, 0)

    progressPct = Instance.new("TextLabel", pbFrame)
    progressPct.Name = "StatusLabel"
    progressPct.Size = UDim2.new(0, 70, 0, 20)
    progressPct.Position = UDim2.new(0, 24, 0, 4)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "SCAN"
    progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressPct.Font = Enum.Font.GothamBlack
    progressPct.TextSize = 12
    progressPct.TextXAlignment = Enum.TextXAlignment.Left
    progressPct.ZIndex = 52

    -- Radius label
    progressRadLbl = Instance.new("TextLabel", pbFrame)
    progressRadLbl.Name = "RadiusLabel"
    progressRadLbl.Size = UDim2.new(0, 80, 0, 20)
    progressRadLbl.Position = UDim2.new(0, 100, 0, 4)
    progressRadLbl.BackgroundTransparency = 1
    progressRadLbl.Text = "Radius: " .. tostring(CONFIG.STEAL_RANGE)
    progressRadLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    progressRadLbl.Font = Enum.Font.GothamBold
    progressRadLbl.TextSize = 11
    progressRadLbl.TextXAlignment = Enum.TextXAlignment.Center
    progressRadLbl.ZIndex = 52

    -- MOVE (lock position) button
    local autoGrabLocked = false
    local lockBtn = Instance.new("TextButton", pbFrame)
    lockBtn.Name = "MoveLockBtn"
    lockBtn.Size = UDim2.new(0, 48, 0, 22)
    lockBtn.Position = UDim2.new(1, -108, 0, 4)
    lockBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    lockBtn.BorderSizePixel = 0
    lockBtn.Text = "MOVE"
    lockBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.TextSize = 10
    lockBtn.ZIndex = 55
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 8)
    local lockStroke = Instance.new("UIStroke", lockBtn)
    lockStroke.Color = Color3.fromRGB(80, 80, 90)
    lockStroke.Thickness = 1

    -- START / STOP toggle
    local toggleBtn = Instance.new("TextButton", pbFrame)
    toggleBtn.Name = "AutoGrabToggleBtn"
    toggleBtn.Size = UDim2.new(0, 48, 0, 22)
    toggleBtn.Position = UDim2.new(1, -54, 0, 4)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 10
    toggleBtn.ZIndex = 55
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)
    local btnStroke = Instance.new("UIStroke", toggleBtn)
    btnStroke.Thickness = 1.2

    local function updateButtonUI(enabled)
        if enabled then
            toggleBtn.Text = "STOP"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            btnStroke.Color = Color3.fromRGB(200, 200, 210)
            progressPct.Text = "SCAN"
            progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
            scanDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            toggleBtn.Text = "START"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
            toggleBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
            btnStroke.Color = Color3.fromRGB(70, 70, 80)
            progressPct.Text = "IDLE"
            progressPct.TextColor3 = Color3.fromRGB(180, 180, 190)
            scanDot.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
        end
    end

    toggleBtn.Activated:Connect(function()
        CONFIG.AUTO_STEAL_ENABLED = not CONFIG.AUTO_STEAL_ENABLED
        if CONFIG.AUTO_STEAL_ENABLED then
            pcall(startAutoSteal)
        else
            pcall(stopAutoSteal)
        end
        updateButtonUI(CONFIG.AUTO_STEAL_ENABLED)
        updateProgressBarVisibility()
        if setInstaGrab then pcall(setInstaGrab, CONFIG.AUTO_STEAL_ENABLED) end
        pcall(saveAllSettings)
    end)
    updateButtonUI(CONFIG.AUTO_STEAL_ENABLED)
    updateProgressBarVisibility()

    -- Progress track
    local pbg = Instance.new("Frame", pbFrame)
    pbg.Size = UDim2.new(1, -28, 0, 7)
    pbg.Position = UDim2.new(0, 14, 1, -12)
    pbg.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
    pbg.BorderSizePixel = 0
    pbg.ZIndex = 51
    Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 30)
    local pbgStroke = Instance.new("UIStroke", pbg)
    pbgStroke.Color = Color3.fromRGB(150, 150, 160)
    pbgStroke.Thickness = 1
    pbgStroke.Transparency = 0.45

    progressFill = Instance.new("Frame", pbg)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 52
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 30)

    -- Drag (only when MOVE / unlocked)
    local pbDragging, pbDragStart, pbStartPos = false, nil, nil
    lockBtn.Activated:Connect(function()
        autoGrabLocked = not autoGrabLocked
        if autoGrabLocked then
            lockBtn.Text = "LOCK"
            lockBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            lockBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            lockBtn.Text = "MOVE"
            lockBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
            lockBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
        end
    end)

    pbFrame.InputBegan:Connect(function(input)
        if autoGrabLocked then return end
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            pbDragging = true
            pbDragStart = input.Position
            pbStartPos = pbFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not pbDragging or autoGrabLocked then return end
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - pbDragStart
            pbFrame.Position = UDim2.new(
                pbStartPos.X.Scale, pbStartPos.X.Offset + delta.X,
                pbStartPos.Y.Scale, pbStartPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if pbDragging then
                pbDragging = false
                savedProgressBarPos = {
                    XScale = pbFrame.Position.X.Scale,
                    XOffset = pbFrame.Position.X.Offset,
                    YScale = pbFrame.Position.Y.Scale,
                    YOffset = pbFrame.Position.Y.Offset
                }
                pcall(saveAllSettings)
            end
        end
    end)

    -- Status / fill updater (Night style: SCAN / STEALING / SUCCESS / FAILED)
    local progressLastFill = 0
    RunService.RenderStepped:Connect(function(dt)
        if not progressFill or not progressFill.Parent then return end
        local targetPct, status, targetColor = 0, "IDLE", Color3.fromRGB(160, 160, 170)
        local recent = StealState.lastResultTime > 0 and (tick() - StealState.lastResultTime) < 1.4
        if StealState.active then
            targetPct = math.clamp((tick() - StealState.startTime) / (CONFIG.HOLD_MAX or 2.6), 0, 1)
            if StealState.phase == "waitingRange" then
                status = "RANGE"
                targetColor = Color3.fromRGB(230, 230, 240)
            else
                status = "STEALING"
                targetColor = Color3.fromRGB(255, 255, 255)
            end
        elseif recent then
            local success = StealState.phase == "success" or (StealState.lastResult and string.find(StealState.lastResult, "Stole"))
            targetPct = 1
            status = success and "SUCCESS" or "FAILED"
            targetColor = success and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)
        elseif CONFIG.AUTO_STEAL_ENABLED then
            local scan = math.sin(tick() * 2.2) * 0.5 + 0.5
            targetPct = scan * 0.75
            status = "SCAN"
            targetColor = Color3.fromRGB(255, 255, 255)
        end
        progressLastFill = progressLastFill + (targetPct - progressLastFill) * math.min((dt or 0.016) * 14, 1)
        progressFill.Size = UDim2.new(progressLastFill, 0, 1, 0)
        progressFill.BackgroundColor3 = progressFill.BackgroundColor3:Lerp(targetColor, math.min((dt or 0.016) * 8, 1))
        if progressPct then
            progressPct.Text = status
            progressPct.TextColor3 = targetColor
        end
        if progressRadLbl then
            progressRadLbl.Text = "Radius: " .. tostring(CONFIG.STEAL_RANGE)
            progressRadLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
        end
        if scanDot then
            scanDot.BackgroundColor3 = (status == "SCAN" or status == "STEALING") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 100)
        end
    end)


    drag(main)

    task.spawn(function()
        local userId = LP.UserId
        local url = profileImageCache[userId]
        if not url then
            local success, u = pcall(function() return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
            if success and u and u ~= "" then
                url = u
                profileImageCache[userId] = url
            else
                url = "rbxassetid://0"
            end
        end
        if profileImage then profileImage.Image = url end
    end)

    
    main.Visible = true
    miniBtn.Visible = false
end



-- Imagen de fondo en botones (Carry, DROP, etc.)
function applyButtonImages(index)
    currentButtonImage = tonumber(index) or 0
    local asset = nil
    if currentButtonImage > 0 and BUTTON_IMG_IDS[currentButtonImage] then
        asset = "rbxassetid://" .. tostring(BUTTON_IMG_IDS[currentButtonImage])
    end
    local function paint(btn, isMini)
        if not btn or not btn.Parent then return end
        local img = btn:FindFirstChild("ButtonBgImage")
        if not img then
            img = Instance.new("ImageLabel")
            img.Name = "ButtonBgImage"
            img.BackgroundTransparency = 1
            img.Size = UDim2.new(1, 0, 1, 0)
            img.Position = UDim2.new(0, 0, 0, 0)
            img.ScaleType = Enum.ScaleType.Crop
            img.ZIndex = (btn.ZIndex or 10)
            img.Parent = btn
            local c = Instance.new("UICorner")
            c.Name = "ButtonBgCorner"
            c.Parent = img
            local shapeCorner = btn:FindFirstChild("ButtonShapeCorner") or btn:FindFirstChildOfClass("UICorner")
            if shapeCorner then
                c.CornerRadius = shapeCorner.CornerRadius
            else
                c.CornerRadius = isMini and UDim.new(0, 8) or UDim.new(1, 0)
            end
        end
        local dim = btn:FindFirstChild("ButtonBgDim")
        if not dim then
            dim = Instance.new("Frame")
            dim.Name = "ButtonBgDim"
            dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            dim.BorderSizePixel = 0
            dim.Size = UDim2.new(1, 0, 1, 0)
            dim.ZIndex = (btn.ZIndex or 10) + 1
            dim.Parent = btn
            local dc = Instance.new("UICorner")
            dc.Parent = dim
            local shapeCorner = btn:FindFirstChild("ButtonShapeCorner") or btn:FindFirstChildOfClass("UICorner")
            if shapeCorner then
                dc.CornerRadius = shapeCorner.CornerRadius
            else
                dc.CornerRadius = isMini and UDim.new(0, 8) or UDim.new(1, 0)
            end
        end
        if asset then
            img.Image = asset
            -- Brillo normal (como antes)
            img.ImageTransparency = 0.15
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
            img.Visible = true
            dim.BackgroundTransparency = 0.75
            dim.Visible = true
            btn.BackgroundTransparency = 0.25
        else
            img.Image = ""
            img.Visible = false
            dim.Visible = false
            btn.BackgroundTransparency = 0
        end
        -- Texto bien legible encima (blanco + contorno)
        if btn:IsA("TextButton") and (btn.Text or "") ~= "" then
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            btn.TextStrokeTransparency = 0
            btn.TextTransparency = 0
            btn.Font = Enum.Font.GothamBlack
            -- subir ZIndex del texto sobre imagen/dim
            if isMini then
                btn.ZIndex = 30
                if img then img.ZIndex = 28 end
                if dim then dim.ZIndex = 29 end
            else
                btn.ZIndex = math.max(btn.ZIndex or 10, 12)
            end
        end
        local label = btn:FindFirstChildWhichIsA("TextLabel")
        if label then
            label.ZIndex = (btn.ZIndex or 10) + 5
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.TextStrokeTransparency = 0
            label.TextTransparency = 0
            label.Font = Enum.Font.GothamBold
        end
    end
    for _, btn in pairs(mobileButtonsByName or {}) do
        paint(btn, false)
    end
    for _, gui in ipairs({instaResetFloatingButton, tpBatFloatingButton, batV2FloatingButton}) do
        if gui then
            local frame = gui:FindFirstChild("Frame") or gui:FindFirstChildWhichIsA("TextButton", true)
            if frame then paint(frame, false) end
        end
    end
    -- Botón mini "ELITE HUB"
    if miniBtn then
        paint(miniBtn, true)
    end
end

-- Buttons Size / Shape (Night style - imagen)
function getMobileButtonPixels(value)
    value = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
    return math.floor(36 + (value * 0.48) + 0.5)
end

function normalizeMobileButtonsShape(shape)
    shape = tostring(shape or "Normal")
    if shape == "Circle" or shape == "Normal" or shape == "Square" or shape == "Rectangle" then
        return shape
    end
    return "Normal"
end

function applyShapeToMobileButton(button)
    if not button or not button.Parent then return end
    local pixels = getMobileButtonPixels(buttonsSizeValue)
    local textPixels = math.clamp(math.floor(8 + buttonsSizeValue * 0.07 + 0.5), 8, 15)
    local shape = normalizeMobileButtonsShape(buttonsShape)
    local width, height = pixels, pixels
    local radius = UDim.new(0, math.clamp(math.floor(pixels * 0.30 + 0.5), 8, math.floor(pixels / 2)))
    if shape == "Circle" then
        radius = UDim.new(1, 0)
    elseif shape == "Square" then
        radius = UDim.new(0, 0)
    elseif shape == "Rectangle" then
        width = math.floor(pixels * 1.55 + 0.5)
        height = math.max(28, math.floor(pixels * 0.75 + 0.5))
        radius = UDim.new(0, math.max(5, math.floor(height * 0.18 + 0.5)))
    end
    button.Size = UDim2.new(0, width, 0, height)
    -- text size on label child if present
    local label = button:FindFirstChildWhichIsA("TextLabel")
    if label then
        label.TextSize = textPixels
    else
        button.TextSize = textPixels
    end
    local corner = button:FindFirstChild("ButtonShapeCorner")
    if not corner or not corner:IsA("UICorner") then
        corner = button:FindFirstChildOfClass("UICorner")
    end
    if not corner then
        corner = Instance.new("UICorner")
        corner.Parent = button
    end
    corner.Name = "ButtonShapeCorner"
    corner.CornerRadius = radius
    local bg = button:FindFirstChild("ButtonBgImage")
    if bg then
        local bc = bg:FindFirstChildOfClass("UICorner")
        if not bc then bc = Instance.new("UICorner", bg) end
        bc.CornerRadius = radius
    end
end

function applyMobileButtonsSize(value)
    buttonsSizeValue = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
    -- sync approximate buttonScaleValue for legacy UIScale paths
    buttonScaleValue = math.clamp(0.5 + (buttonsSizeValue / 100) * 1.0, 0.50, 1.50)
    for _, mobileBtn in pairs(mobileButtonsByName) do
        applyShapeToMobileButton(mobileBtn)
    end
    -- floating specials
    for _, gui in ipairs({instaResetFloatingButton, tpBatFloatingButton, batV2FloatingButton}) do
        if gui then
            local frame = gui:FindFirstChild("Frame") or gui:FindFirstChildWhichIsA("TextButton", true)
            if frame then applyShapeToMobileButton(frame) end
        end
    end
    if _G.buttonsSizeValueLabel then
        _G.buttonsSizeValueLabel.Text = tostring(buttonsSizeValue)
    end
end

function applyMobileButtonsShape(shape)
    buttonsShape = normalizeMobileButtonsShape(shape)
    for _, mobileBtn in pairs(mobileButtonsByName) do
        applyShapeToMobileButton(mobileBtn)
    end
    for _, gui in ipairs({instaResetFloatingButton, tpBatFloatingButton, batV2FloatingButton}) do
        if gui then
            local frame = gui:FindFirstChild("Frame") or gui:FindFirstChildWhichIsA("TextButton", true)
            if frame then applyShapeToMobileButton(frame) end
        end
    end
    if _G.buttonsShapeLabel then
        _G.buttonsShapeLabel.Text = buttonsShape
    end
    return buttonsShape
end


function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "VeneyorkMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(panel) end
    end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end
    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local COLUMNS = 2
    local ROWS = 4
    local PANEL_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1)
    local PANEL_H = BTN_H * ROWS + (GAP + 10) * (ROWS - 1)
    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    
    container.Position = UDim2.new(1, -(MOBILE_PANEL_WIDTH + 10), 0, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Active = false
    container.Selectable = false
    container.ClipsDescendants = false
    local btnContainer = Instance.new("Frame", container)
    btnContainer.Name = "ButtonsContainer"
    btnContainer.Size = UDim2.new(1, 0, 1, 0)
    btnContainer.BackgroundTransparency = 1
    btnContainer.ClipsDescendants = false
    local WHITE = Color3.fromRGB(255,255,255)
    local INACTIVE_BG = Color3.fromRGB(10,10,10)
    local INACTIVE_TEXT = Color3.fromRGB(225,225,225)
    local STROKE_COLOR = Color3.fromRGB(70,70,70)
    local ACTIVE_BG = WHITE
    local ACTIVE_TEXT = Color3.fromRGB(0,0,0)
    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\n1", "LAGGER\n2"}
    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", btnContainer)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = INACTIVE_BG
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 10
        local savedPos = savedButtonPositions[name]
        if savedPos then
            btn.Position = UDim2.new(0, savedPos.X or 0, 0, savedPos.Y or 0)
        else
            local defX, defY = getDefaultButtonPosition(name)
            btn.Position = UDim2.new(0, defX, 0, defY)
        end
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = STROKE_COLOR
        stroke.Thickness = 1.2
        stroke.Transparency = 0.4
        stroke.Name = "NormalStroke"
        local bgImg = Instance.new("ImageLabel", btn)
        bgImg.Name = "ButtonBgImage"
        bgImg.BackgroundTransparency = 1
        bgImg.Size = UDim2.new(1, 0, 1, 0)
        bgImg.ScaleType = Enum.ScaleType.Crop
        bgImg.ZIndex = 10
        bgImg.ImageTransparency = 0.15
        bgImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
        bgImg.Visible = false
        Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 18)
        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextWrapped = true
        label.ZIndex = 13
        local active = false
        local function setActive(state)
            active = state
            if active then
                btn.BackgroundColor3 = ACTIVE_BG
                label.TextColor3 = Color3.fromRGB(0, 0, 0)
                label.TextStrokeTransparency = 0.5
                stroke.Color = WHITE
                stroke.Transparency = 0
            else
                btn.BackgroundColor3 = INACTIVE_BG
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                label.TextStrokeTransparency = 0
                stroke.Color = STROKE_COLOR
                stroke.Transparency = 0.4
            end
        end
        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local movedDistance = 0
        local function onInputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                hasMoved = false
                movedDistance = 0
                dragStart = input.Position
                startPos = btn.Position
                _isDraggingButton = true
            end
        end
        local function onInputChanged(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                if editModeEnabled and not uiLocked then
                    hasMoved = true
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end
        local function onInputEnded(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 3 then
                        if isToggle then
                            if editModeEnabled and not uiLocked then
                                if callback then callback(function() end) end
                            else
                                if callback then callback(setActive) end
                            end
                        else
                            if callback then callback(setActive, active) end
                        end
                    elseif editModeEnabled and not uiLocked and hasMoved then
                        savedButtonPositions[name] = { X = btn.Position.X.Offset, Y = btn.Position.Y.Offset }
                    end
                    dragging = false
                    hasMoved = false
                    dragStart = nil
                    startPos = nil
                    movedDistance = 0
                    _isDraggingButton = false
                end
            end
        end
        btn.InputBegan:Connect(onInputBegan)
        btn.InputChanged:Connect(onInputChanged)
        btn.InputEnded:Connect(onInputEnded)
        buttons[name] = {btn = btn, setActive = setActive, label = label}
        mobileButtonsByName[name] = btn
        applyShapeToMobileButton(btn)
        return setActive
    end

    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]
        local callback
        if name == "DropBR" then
            callback = function(setActive)
                if autoBatEnabled then return end
                setActive(true)
                executeDropWithToggle(function(v)
                    if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
                end)
                task.delay(0.3, function() setActive(false) end)
            end
        elseif name == "AutoLeft" then
            callback = function(setActive)
                autoLeftEnabled = not autoLeftEnabled
                setActive(autoLeftEnabled)
                if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
                saveAllSettings()
            end
        elseif name == "AutoBat" then
            callback = function(setActive)
                if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
                setActive(autoBatEnabled)
                saveAllSettings()
            end
        elseif name == "AutoRight" then
            callback = function(setActive)
                autoRightEnabled = not autoRightEnabled
                setActive(autoRightEnabled)
                if autoRightEnabled then startAutoRight() else stopAutoRight() end
                if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
                saveAllSettings()
            end
        elseif name == "TpDown" then
            callback = function(setActive)
                doTpDown()
                setActive(true)
                task.delay(0.2, function() setActive(false) end)
            end
        elseif name == "Carry" then
            callback = function(setActive)
                if not speedMode then
                    speedMode = true; laggerToggled = false; laggerLevel = 1; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    speedMode = false; setActive(false)
                end
                refreshSpeedModeLabel()
                saveAllSettings()
            end
        elseif name == "Lagger1" then
            callback = function(setActive)
                if speedMode then
                    speedMode = false; if mobSetCarry then mobSetCarry(false) end
                end
                if not laggerToggled or laggerLevel ~= 1 then
                    laggerToggled = true; laggerLevel = 1; setActive(true)
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    laggerToggled = false; laggerLevel = 1; setActive(false)
                end
                refreshSpeedModeLabel()
                saveAllSettings()
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                if speedMode then
                    speedMode = false; if mobSetCarry then mobSetCarry(false) end
                end
                if not laggerToggled or laggerLevel ~= 2 then
                    laggerToggled = true; laggerLevel = 2; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                else
                    laggerToggled = false; laggerLevel = 1; setActive(false)
                end
                refreshSpeedModeLabel()
                saveAllSettings()
            end
        end
        mobSetAutoBat = buttons.AutoBat and buttons.AutoBat.setActive
        mobSetAutoLeft = buttons.AutoLeft and buttons.AutoLeft.setActive
        mobSetAutoRight = buttons.AutoRight and buttons.AutoRight.setActive
        mobSetDropBR = buttons.DropBR and buttons.DropBR.setActive
        mobSetTpDown = buttons.TpDown and buttons.TpDown.setActive
        mobSetCarry = buttons.Carry and buttons.Carry.setActive
        mobSetLagger1 = buttons.Lagger1 and buttons.Lagger1.setActive
        mobSetLagger2 = buttons.Lagger2 and buttons.Lagger2.setActive
        local setActive = createButton(name, text, i-1, true, callback)
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
    end
    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled and laggerLevel == 1) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerToggled and laggerLevel == 2) end
    if savedMobilePanelPos then
        container.Position = UDim2.new(
            savedMobilePanelPos.XScale or 1,
            savedMobilePanelPos.XOffset or (-PANEL_W - 10),
            savedMobilePanelPos.YScale or 0,
            savedMobilePanelPos.YOffset or 0
        )
    end
    local draggingPanel = false
    local dragStartPos = nil
    local dragStartMousePos = nil
    local function startDragPanel(input)
        if uiLocked or _isDraggingButton or editModeEnabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingPanel = true
            dragStartPos = container.Position
            dragStartMousePos = input.Position
        end
    end
    local function onDragPanel(input)
        if not draggingPanel or uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragStartPos and dragStartMousePos then
                local delta = input.Position - dragStartMousePos
                local newX = dragStartPos.X.Offset + delta.X
                local newY = dragStartPos.Y.Offset + delta.Y
                container.Position = UDim2.new(dragStartPos.X.Scale, newX, dragStartPos.Y.Scale, newY)
            end
        end
    end
    local function endDragPanel()
        if draggingPanel then
            draggingPanel = false
            savedMobilePanelPos = {
                XScale = container.Position.X.Scale,
                XOffset = container.Position.X.Offset,
                YScale = container.Position.Y.Scale,
                YOffset = container.Position.Y.Offset
            }
        end
        dragStartPos = nil
        dragStartMousePos = nil
    end
    container.InputBegan:Connect(startDragPanel)
    container.InputEnded:Connect(endDragPanel)
    UIS.InputChanged:Connect(onDragPanel)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            endDragPanel()
        end
    end)
    return panel
end

function createInstaResetFloatingButton()
    local WHITE = Color3.fromRGB(255,255,255)
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 20
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(panel) end
    end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(instaResetFloatingPos.XScale or 0.5, instaResetFloatingPos.XOffset or -120, instaResetFloatingPos.YScale or 0, instaResetFloatingPos.YOffset or 10)
    else
        btnFrame.Position = UDim2.new(0.5, -120, 0, 10)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "RESET"
    label.TextColor3 = WHITE
    label.Font = Enum.Font.Fantasy
    label.TextSize = 12
    label.TextWrapped = true
    label.ZIndex = 21
    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = WHITE
            label.TextColor3 = Color3.fromRGB(0,0,0)
        else
            btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
            label.TextColor3 = WHITE
        end
    end
    local dragging = false; local hasMoved = false; local dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    setActive(true)
                    instaReset()
                    if setInstaResetVisual then setInstaResetVisual(true) end
                    task.delay(0.3, function()
                        if setInstaResetVisual then setInstaResetVisual(false) end; setActive(false)
                    end)
                elseif not uiLocked and hasMoved then
                    instaResetFloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                end
                dragging = false; hasMoved = false
            end
        end
    end)
    return panel
end

function createTpBatFloatingButton()
    local WHITE = Color3.fromRGB(255,255,255)
    local panel = Instance.new("ScreenGui")
    panel.Name = "TpBatButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 21
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(panel) end
    end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if tpBatFloatingPos then
        btnFrame.Position = UDim2.new(tpBatFloatingPos.XScale or 0.5, tpBatFloatingPos.XOffset or 20, tpBatFloatingPos.YScale or 0, tpBatFloatingPos.YOffset or 10)
    else
        btnFrame.Position = UDim2.new(0.5, 20, 0, 10)
    end
    btnFrame.BackgroundColor3 = _G.AceAntiDesyncAimbotOn and WHITE or Color3.fromRGB(0,0,0)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "TP\nBAT"
    label.TextColor3 = _G.AceAntiDesyncAimbotOn and Color3.fromRGB(0,0,0) or WHITE
    label.Font = Enum.Font.Fantasy
    label.TextSize = 10
    label.TextWrapped = true
    label.ZIndex = 21
    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = WHITE
            label.TextColor3 = Color3.fromRGB(0,0,0)
        else
            btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
            label.TextColor3 = WHITE
        end
    end
    local dragging = false; local hasMoved = false; local dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    toggleAntiDesyncAimbot()
                    setActive(_G.AceAntiDesyncAimbotOn)
                elseif not uiLocked and hasMoved then
                    tpBatFloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                end
                dragging = false; hasMoved = false
            end
        end
    end)
    tpBatFloatingButton = panel
    return panel
end

function createBatV2FloatingButton()
    local WHITE = Color3.fromRGB(255,255,255)
    local panel = Instance.new("ScreenGui")
    panel.Name = "BatV2Button"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 22
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(panel) end
    end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if batV2FloatingPos then
        btnFrame.Position = UDim2.new(batV2FloatingPos.XScale or 0.5, batV2FloatingPos.XOffset or -50, batV2FloatingPos.YScale or 0, batV2FloatingPos.YOffset or 10)
    else
        btnFrame.Position = UDim2.new(0.5, -50, 0, 10)
    end
    btnFrame.BackgroundColor3 = autoBatV2Enabled and WHITE or Color3.fromRGB(0,0,0)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "BAT\nBYPASS"  
    label.TextColor3 = autoBatV2Enabled and Color3.fromRGB(0,0,0) or WHITE
    label.Font = Enum.Font.Fantasy
    label.TextSize = 10   
    label.TextWrapped = true
    label.ZIndex = 21
    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = WHITE
            label.TextColor3 = Color3.fromRGB(0,0,0)
        else
            btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
            label.TextColor3 = WHITE
        end
    end
    local dragging = false; local hasMoved = false; local dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    setActive(not autoBatV2Enabled)
                    toggleBatV2()
                elseif not uiLocked and hasMoved then
                    batV2FloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                end
                dragging = false; hasMoved = false
            end
        end
    end)
    batV2FloatingButton = panel
    return panel
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_SPEED_2) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if _G.uiScaleValueLabel then _G.uiScaleValueLabel.Text = string.format("%.2f", uiScaleValue / 100) end
    if _G.buttonScaleValueLabel then _G.buttonScaleValueLabel.Text = string.format("%.2f", buttonScaleValue) end
    applyButtonScale(buttonScaleValue)
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    refreshSpeedModeLabel()
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5,
            savedProgressBarPos.XOffset or -140,
            savedProgressBarPos.YScale or 1,
            savedProgressBarPos.YOffset or -50
        )
    end
    if uiLocked and setLockUIVisual then setLockUIVisual(true) end
    if editModeEnabled and setEditModeVisual then setEditModeVisual(true) end
    if antiRagdollEnabled and setAntiRagVisual then setAntiRagVisual(true); startAntiRagdoll() end
    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end
    if antiDropEnabled then
        if setAntiDropVisual then setAntiDropVisual(true) end
        pcall(startAntiDrop)
    else
        if setAntiDropVisual then setAntiDropVisual(false) end
        pcall(stopAntiDrop)
    end
    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        pcall(startAntiDie)
    else
        if setAntiDieVisual then setAntiDieVisual(false) end
        pcall(stopAntiDie)
    end
    if antiFlingShieldEnabled then
        if setAntiFlingVisual then setAntiFlingVisual(true) end
        pcall(startAntiFlingShield)
    else
        if setAntiFlingVisual then setAntiFlingVisual(false) end
        pcall(stopAntiFlingShield)
    end
    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusa(LP.Character) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaAutoReset()
    elseif medusaAutoResetEnabled then
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(true) end
        if LP.Character then setupMedusaAutoReset(LP.Character) end
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    else
        if setMedusaVisual then setMedusaVisual(false) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaCounter()
        stopMedusaAutoReset()
    end
    if batCounterEnabled and setBatCounterVisual then setBatCounterVisual(true) startBatCounter() end
    if unwalkEnabled and setUnwalkVisual then setUnwalkVisual(true); task.spawn(function() task.wait(0.5); startUnwalk() end) end
    if antiLagEnabled then
        if setAntiLagVisual then setAntiLagVisual(true) end
        enableAntiLag()
    else
        if setAntiLagVisual then setAntiLagVisual(false) end
        disableAntiLag()
    end
    if espEnabled then
        toggleESP(true)
        if setESPVIsual then setESPVIsual(true) end
    else
        toggleESP(false)
        if setESPVIsual then setESPVIsual(false) end
    end
    if _G.AceAntiDesyncAimbotOn then
        if tpLockSetVisual then tpLockSetVisual(true) end
        if not _G.AceAntiDesync.conn then startAntiDesyncAimbot() end
        if tpBatFloatingButton then
            local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then label.TextColor3 = Color3.fromRGB(0,0,0) end
            end
        end
    else
        if tpLockSetVisual then tpLockSetVisual(false) end
        if tpBatFloatingButton then
            local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then label.TextColor3 = Color3.fromRGB(255,255,255) end
            end
        end
    end
    if autoBatV2Enabled then
        if autoBatV2SetVisual then autoBatV2SetVisual(true) end
        if not _batV2Conn then startBatV2Aimbot() end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then label.TextColor3 = Color3.fromRGB(0,0,0) end
            end
        end
    else
        if autoBatV2SetVisual then autoBatV2SetVisual(false) end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then label.TextColor3 = Color3.fromRGB(255,255,255) end
            end
        end
    end
    if neonWeatherEnabled then
        applyNeonWeather()
        if setNeonWeatherVisual then setNeonWeatherVisual(true) end
    else
        restoreLightingState()
        if setNeonWeatherVisual then setNeonWeatherVisual(false) end
    end
    if currentSkyTheme and currentSkyTheme ~= "Off" then
        setSkyTheme(currentSkyTheme)
    else
        setSkyTheme("Off")
    end
    if currentAccessoryPack and currentAccessoryPack ~= "Off" then
        task.wait(0.2)
        applyAccessoryPack(currentAccessoryPack)
        if accSelectorLabel then accSelectorLabel.Text = currentAccessoryPack end
    else
        clearAccessories()
        if accSelectorLabel then accSelectorLabel.Text = "Off" end
    end
    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end
    if _G.fovButtons then
        for _, btn in ipairs(_G.fovButtons) do
            if btn:IsA("TextButton") then
                local val = tonumber(btn.Text)
                if val == stretchFOV then
                    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
                    btn.TextColor3 = Color3.fromRGB(0,0,0)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(12,12,12)
                    btn.TextColor3 = Color3.fromRGB(255,255,255)
                end
            end
        end
    end
    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel == 1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel == 2) end
    if bodyLockEnabled and bodyLockSetVisual then
        if _blSuppressCount == 0 then
            bodyLockSetVisual(true)
            startBodyLock()
        else
            bodyLockSetVisual(false)
        end
    end
    updateProgressBarVisibility()
    startEnemySpeed()
    if fovContainer then fovContainer.Visible = true end
    toggleLockUI(uiLocked)
end

buildGui()
if loadAllSettings() then updateUIFromLoaded() end

-- ============================================================
-- FORZAR VALORES DEL EXTRACTO NIGHT (imagenes) al arrancar
-- Ignora Veneyork.json para estos ajustes
-- ============================================================
do
    CONFIG.STEAL_RANGE = 8
    savedStealRadius = 8
    uiScaleValue = 80
    if mainUIScale then mainUIScale.Scale = 0.8 end
    if pbScale then pbScale.Scale = 0.8 end
    if uiScaleBox then uiScaleBox.Text = "80" end
    if radInput then radInput.Text = "8" end
    if progressRadLbl then progressRadLbl.Text = "Radius: 8" end
    if _G.uiScaleValueLabel then _G.uiScaleValueLabel.Text = "0.80" end

    -- No forzar anim: respetar la guardada
    if currentAnimPack and currentAnimPack ~= "Off" then
        pcall(function() startAnimPack(currentAnimPack) end)
    end
    if animSelectorLabel then animSelectorLabel.Text = currentAnimPack or "Off" end

    currentAccessoryPack = "Headless"
    pcall(function() applyAccessoryPack("Headless") end)
    if accSelectorLabel then accSelectorLabel.Text = "Headless" end

    -- Botones sin imagen; fondo menú respeta selección Fonds
    currentButtonImage = 0
    if applyMenuBackground then pcall(applyMenuBackground, currentMenuBackground or 0) end
    if applyMenuTheme then pcall(applyMenuTheme, "WHITE") end
    pcall(function() applyButtonImages(0) end)

    antiDieEnabled = false
    if setAntiDieVisual then pcall(setAntiDieVisual, false) end
    pcall(function() if stopAntiDie then stopAntiDie() end end)

    -- Pack Accessory / Music: respetar lo guardado (no resetear)
    pcall(function()
        if currentBleedPack and currentBleedPack ~= "Off" then
            task.delay(0.8, function()
                applyBleedPack(currentBleedPack)
                if bleedSelectorLabel then bleedSelectorLabel.Text = currentBleedPack end
            end)
        end
    end)
    pcall(function()
        if currentMusicPack and playMusicPack then
            playMusicPack(currentMusicPack)
            if musicSelectorLabel then musicSelectorLabel.Text = currentMusicPack end
        end
    end)

    buttonsSizeValue = 50
    buttonsShape = "Circle"
    pcall(function()
        applyMobileButtonsSize(50)
        applyMobileButtonsShape("Circle")
    end)
    if _G.buttonsSizeValueLabel then _G.buttonsSizeValueLabel.Text = "50" end
    if _G.buttonsShapeLabel then _G.buttonsShapeLabel.Text = "Circle" end

    -- guardar ya con los valores de la imagen
    pcall(saveAllSettings)
end

-- ============================================================
-- Intro estilo Dice (dados + título) para Veneyork
-- ============================================================
local function runDiceStyleIntro()
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local player = LP
    local accent = WHITE or Color3.fromRGB(220, 220, 220)
    local accentDark = SILVER or Color3.fromRGB(150, 150, 150)

    -- Sonido de intro (opcional, silencioso si falla)
    task.spawn(function()
        local urlIntro = "https://files.catbox.moe/66xaq4.mp3"
        local numeFisier = "veneyork_intro.mp3"
        if isfile and writefile and getcustomasset then
            if not isfile(numeFisier) then
                local ok, data = pcall(function() return game:HttpGet(urlIntro) end)
                if ok and data then pcall(function() writefile(numeFisier, data) end) end
            end
            local snd = Instance.new("Sound")
            pcall(function()
                snd.SoundId = getcustomasset(numeFisier)
                snd.Volume = 2.5
                snd.Looped = false
                snd.Parent = game:GetService("CoreGui")
                snd:Play()
            end)
        end
    end)

    task.spawn(function()
        local introStarted = tick()
        task.wait(0.35)
        local introGui = Instance.new("ScreenGui")
        introGui.Name = "VeneyorkDiceIntro"
        introGui.ResetOnSpawn = false
        introGui.IgnoreGuiInset = true
        introGui.DisplayOrder = 9999
        introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(introGui) end end)
        if not pcall(function() introGui.Parent = game:GetService("CoreGui") end) then
            introGui.Parent = player:WaitForChild("PlayerGui")
        end
        local stage = Instance.new("Frame", introGui)
        stage.Size = UDim2.fromScale(1, 1)
        stage.BackgroundTransparency = 1
        stage.ClipsDescendants = true

        local function waitForIntroSecond(second)
            local remaining = second - (tick() - introStarted)
            if remaining > 0 then task.wait(remaining) end
        end

        local layouts = {
            [1] = {{.5, .5}},
            [2] = {{.28, .28}, {.72, .72}},
            [3] = {{.27, .27}, {.5, .5}, {.73, .73}},
            [4] = {{.28, .28}, {.72, .28}, {.28, .72}, {.72, .72}},
            [5] = {{.27, .27}, {.73, .27}, {.5, .5}, {.27, .73}, {.73, .73}},
            [6] = {{.28, .23}, {.72, .23}, {.28, .5}, {.72, .5}, {.28, .77}, {.72, .77}},
        }

        local function makeIntroDie(size, pos, value)
            local group = Instance.new("CanvasGroup", stage)
            group.AnchorPoint = Vector2.new(.5, .5)
            group.Position = pos
            group.Size = UDim2.fromOffset(size + 14, size + 16)
            group.BackgroundTransparency = 1
            group.ZIndex = 20
            group.ClipsDescendants = true
            local shadow = Instance.new("Frame", group)
            shadow.Size = UDim2.fromOffset(size, size)
            shadow.Position = UDim2.fromOffset(10, 11)
            shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            shadow.BackgroundTransparency = .48
            shadow.BorderSizePixel = 0
            Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, math.floor(size * .2))
            local depth = Instance.new("Frame", group)
            depth.Size = UDim2.fromOffset(size, size)
            depth.Position = UDim2.fromOffset(8, 8)
            depth.BackgroundColor3 = Color3.fromRGB(80, 83, 98)
            depth.BorderSizePixel = 0
            Instance.new("UICorner", depth).CornerRadius = UDim.new(0, math.floor(size * .2))
            local face = Instance.new("Frame", group)
            face.Size = UDim2.fromOffset(size, size)
            face.Position = UDim2.fromOffset(7, 5)
            face.BackgroundColor3 = Color3.fromRGB(225, 228, 238)
            face.BorderSizePixel = 0
            face.ZIndex = 22
            Instance.new("UICorner", face).CornerRadius = UDim.new(0, math.floor(size * .2))
            local stroke = Instance.new("UIStroke", face)
            stroke.Color = accentDark
            stroke.Thickness = 2
            local grad = Instance.new("UIGradient", face)
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(.55, Color3.fromRGB(211, 214, 225)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(126, 130, 147))
            })
            grad.Rotation = 35
            local rim = Instance.new("Frame", face)
            rim.Size = UDim2.new(1, -10, 1, -10)
            rim.Position = UDim2.fromOffset(5, 5)
            rim.BackgroundTransparency = 1
            rim.ZIndex = 23
            Instance.new("UICorner", rim).CornerRadius = UDim.new(0, math.floor(size * .15))
            local rimStroke = Instance.new("UIStroke", rim)
            rimStroke.Color = Color3.fromRGB(255, 255, 255)
            rimStroke.Transparency = .58
            rimStroke.Thickness = 1
            for _, point in ipairs(layouts[value]) do
                local pip = Instance.new("Frame", face)
                pip.AnchorPoint = Vector2.new(.5, .5)
                pip.Position = UDim2.fromScale(point[1], point[2])
                pip.Size = UDim2.fromOffset(math.max(7, math.floor(size * .13)), math.max(7, math.floor(size * .13)))
                pip.BackgroundColor3 = Color3.fromRGB(16, 17, 24)
                pip.BorderSizePixel = 0
                pip.ZIndex = 24
                Instance.new("UICorner", pip).CornerRadius = UDim.new(1, 0)
                local pipStroke = Instance.new("UIStroke", pip)
                pipStroke.Color = Color3.fromRGB(255, 255, 255)
                pipStroke.Transparency = .8
                pipStroke.Thickness = 1
            end
            local scale = Instance.new("UIScale", group)
            return group, scale, grad
        end

        local dice = {}
        local routes = {
            {44, UDim2.new(-.1, 0, .24, 0), UDim2.new(.27, 0, .33, 0), 1, 900, .00},
            {54, UDim2.new(-.12, 0, .65, 0), UDim2.new(.31, 0, .62, 0), 4, 1080, .08},
            {38, UDim2.new(.22, 0, -.12, 0), UDim2.new(.40, 0, .27, 0), 2, -900, .16},
            {46, UDim2.new(.38, 0, 1.12, 0), UDim2.new(.42, 0, .72, 0), 5, 1080, .12},
            {44, UDim2.new(1.1, 0, .25, 0), UDim2.new(.73, 0, .34, 0), 3, -900, .00},
            {54, UDim2.new(1.12, 0, .68, 0), UDim2.new(.69, 0, .63, 0), 6, -1080, .08},
            {38, UDim2.new(.78, 0, -.12, 0), UDim2.new(.60, 0, .27, 0), 4, 900, .16},
            {46, UDim2.new(.64, 0, 1.12, 0), UDim2.new(.58, 0, .72, 0), 2, -1080, .12},
        }
        for _, route in ipairs(routes) do
            local die, scale, grad = makeIntroDie(route[1], route[2], route[4])
            scale.Scale = .35
            die.GroupTransparency = .18
            table.insert(dice, {die, scale, grad, route[3], route[5], route[2]})
            task.delay(route[6], function()
                TweenService:Create(die, TweenInfo.new(.78, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = route[3], Rotation = route[5], GroupTransparency = 0}):Play()
                TweenService:Create(scale, TweenInfo.new(.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
                TweenService:Create(grad, TweenInfo.new(.78), {Rotation = route[5] > 0 and 395 or -325, Offset = Vector2.new(route[5] > 0 and .28 or -.28, 0)}):Play()
            end)
        end
        task.wait(.88)
        for i, item in ipairs(dice) do
            local drift = i % 2 == 0 and 32 or -32
            TweenService:Create(item[1], TweenInfo.new(.48, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = item[1].Rotation + drift}):Play()
        end
        waitForIntroSecond(4.4)
        for _, item in ipairs(dice) do
            local direction = item[5] > 0 and 1 or -1
            local retreat = item[4]:Lerp(item[6], .42)
            TweenService:Create(item[1], TweenInfo.new(.46, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Position = retreat, Rotation = item[1].Rotation + direction * 360}):Play()
            TweenService:Create(item[2], TweenInfo.new(.46, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Scale = .82}):Play()
            TweenService:Create(item[3], TweenInfo.new(.46), {Offset = Vector2.new(-direction * .2, 0), Rotation = direction * 210}):Play()
        end
        waitForIntroSecond(5.0)
        for _, item in ipairs(dice) do
            local direction = item[5] > 0 and 1 or -1
            TweenService:Create(item[1], TweenInfo.new(.58, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = item[4], Rotation = item[1].Rotation + direction * 720}):Play()
            TweenService:Create(item[2], TweenInfo.new(.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            TweenService:Create(item[3], TweenInfo.new(.58), {Offset = Vector2.new(direction * .3, 0), Rotation = direction * 395}):Play()
        end
        local center, centerScale, centerGrad = makeIntroDie(98, UDim2.new(.5, 0, 1.18, 0), 6)
        centerScale.Scale = .56
        center.GroupTransparency = .08
        center.ZIndex = 40
        TweenService:Create(center, TweenInfo.new(.82, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Position = UDim2.new(.5, 0, .5, 0), Rotation = 1440, GroupTransparency = 0}):Play()
        TweenService:Create(centerScale, TweenInfo.new(.66, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        TweenService:Create(centerGrad, TweenInfo.new(.82), {Rotation = 430, Offset = Vector2.new(.42, 0)}):Play()
        task.wait(.76)
        local impact = Instance.new("Frame", stage)
        impact.AnchorPoint = Vector2.new(.5, .5)
        impact.Position = UDim2.fromScale(.5, .5)
        impact.Size = UDim2.fromOffset(80, 80)
        impact.BackgroundTransparency = 1
        impact.ZIndex = 15
        Instance.new("UICorner", impact).CornerRadius = UDim.new(1, 0)
        local impactStroke = Instance.new("UIStroke", impact)
        impactStroke.Color = accent
        impactStroke.Thickness = 3
        impactStroke.Transparency = .05
        TweenService:Create(impact, TweenInfo.new(.52, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(310, 310)}):Play()
        TweenService:Create(impactStroke, TweenInfo.new(.52), {Transparency = 1, Thickness = 1}):Play()
        for i = 1, 12 do
            local spark = Instance.new("Frame", stage)
            spark.AnchorPoint = Vector2.new(.5, .5)
            spark.Position = UDim2.fromScale(.5, .5)
            spark.Size = UDim2.fromOffset(i % 3 == 0 and 6 or 3, i % 3 == 0 and 18 or 12)
            spark.BackgroundColor3 = i % 2 == 0 and accent or Color3.fromRGB(245, 247, 255)
            spark.BorderSizePixel = 0
            spark.ZIndex = 16
            spark.Rotation = i * 30
            Instance.new("UICorner", spark).CornerRadius = UDim.new(1, 0)
            local angle = math.rad(i * 30)
            local radius = 115 + (i % 3) * 18
            TweenService:Create(spark, TweenInfo.new(.48, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(.5, math.cos(angle) * radius, .5, math.sin(angle) * radius),
                BackgroundTransparency = 1,
                Rotation = i * 30 + 90
            }):Play()
        end
        TweenService:Create(centerScale, TweenInfo.new(.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = .88}):Play()
        task.wait(.12)
        TweenService:Create(centerScale, TweenInfo.new(.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        task.wait(.55)
        for _, item in ipairs(dice) do
            TweenService:Create(item[1], TweenInfo.new(.38, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = UDim2.fromScale(.5, .5),
                Rotation = item[1].Rotation + 180,
                GroupTransparency = 1
            }):Play()
            TweenService:Create(item[2], TweenInfo.new(.38), {Scale = .3}):Play()
        end
        TweenService:Create(center, TweenInfo.new(.34, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(.5, 0, .45, 0),
            Rotation = 1530,
            GroupTransparency = 1
        }):Play()
        TweenService:Create(centerScale, TweenInfo.new(.34), {Scale = .55}):Play()
        task.wait(.25)
        local title = Instance.new("TextLabel", stage)
        title.AnchorPoint = Vector2.new(.5, .5)
        title.Position = UDim2.new(.5, 0, .62, 0)
        title.Size = UDim2.new(0, 360, 0, 80)
        title.BackgroundTransparency = 1
        title.RichText = true
        title.Text = 'ELITE <font color="rgb(166,170,182)">HUB</font>'
        title.TextColor3 = Color3.fromRGB(245, 247, 255)
        title.TextSize = 46
        title.Font = Enum.Font.GothamBlack
        title.TextTransparency = 1
        title.TextStrokeColor3 = Color3.fromRGB(10, 10, 16)
        title.TextStrokeTransparency = 1
        title.ZIndex = 30
        TweenService:Create(title, TweenInfo.new(.52, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(.5, 0, .5, 0),
            TextTransparency = 0,
            TextStrokeTransparency = .3
        }):Play()
        local underline = Instance.new("Frame", stage)
        underline.AnchorPoint = Vector2.new(.5, .5)
        underline.Position = UDim2.new(.5, 0, .555, 0)
        underline.Size = UDim2.fromOffset(0, 2)
        underline.BackgroundColor3 = accent
        underline.BorderSizePixel = 0
        underline.ZIndex = 30
        Instance.new("UICorner", underline).CornerRadius = UDim.new(1, 0)
        TweenService:Create(underline, TweenInfo.new(.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(148, 2)}):Play()
        task.wait(1.25)
        TweenService:Create(title, TweenInfo.new(.38, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(.5, 0, .42, 0),
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }):Play()
        TweenService:Create(underline, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(0, 2),
            BackgroundTransparency = 1
        }):Play()
        task.wait(.4)
        pcall(function() introGui:Destroy() end)
    end)
end


task.spawn(function()
    pcall(runDiceStyleIntro)
end)
MobilePanel = createMobilePanel()
instaResetFloatingButton = createInstaResetFloatingButton()
tpBatFloatingButton = createTpBatFloatingButton()
batV2FloatingButton = createBatV2FloatingButton()
applyButtonScale(buttonScaleValue)
applyMobileButtonsSize(buttonsSizeValue)
applyMobileButtonsShape(buttonsShape)
pcall(function() applyButtonImages(0) end)

if LP.Character then
    task.wait(0.1)
    while not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChildOfClass("Humanoid") do
        task.wait()
    end
    setupMovementAndIndicators(LP.Character)
    if currentAnimPack ~= "Off" then startAnimPack(currentAnimPack) end
    if currentAccessoryPack and currentAccessoryPack ~= "Off" then
        task.wait(0.3)
        applyAccessoryPack(currentAccessoryPack)
    end
    if currentBleedPack and currentBleedPack ~= "Off" then
        task.delay(0.7, function() applyBleedPack(currentBleedPack) end)
    end
end

LP.CharacterAdded:Connect(function(char)
    local keepAutoSteal = CONFIG.AUTO_STEAL_ENABLED
    stopAutoSteal() -- no apaga CONFIG
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopMedusaCounter()
    stopUnwalk()
    stopDropBrainrot()
    stopMedusaAutoReset()
    if autoBatEnabled then disableAutoBat() end
    if _G.AceAntiDesyncAimbotOn then stopAntiDesyncAimbot() end
    if autoBatV2Enabled then disableBatV2() end
    if bodyLockEnabled then stopBodyLock() end
    cleanupSpeedPhysics()
    task.wait(0.1)
    while not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChildOfClass("Humanoid") do
        task.wait()
    end
    setupMovementAndIndicators(char)
    if keepAutoSteal or CONFIG.AUTO_STEAL_ENABLED then
        CONFIG.AUTO_STEAL_ENABLED = true
        pcall(startAutoSteal)
    end
    if _G.AceAntiDesyncAimbotOn then task.defer(function() startAntiDesyncAimbot() end) end
    if autoBatV2Enabled then task.defer(function() startBatV2Aimbot() end) end
    if antiRagdollEnabled then task.wait(0.5) startAntiRagdoll() end
    if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end
    if medusaCounterEnabled then
        setupMedusa(char)
        if setMedusaVisual then setMedusaVisual(true) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaAutoReset()
    elseif medusaAutoResetEnabled then
        setupMedusaAutoReset(char)
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(true) end
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    else
        stopMedusaCounter()
        stopMedusaAutoReset()
        if setMedusaVisual then setMedusaVisual(false) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
    end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then startUnwalk() end
    if currentAnimPack ~= "Off" then task.wait(0.5) startAnimPack(currentAnimPack) end
    if currentAccessoryPack and currentAccessoryPack ~= "Off" then
        task.wait(0.3)
        applyAccessoryPack(currentAccessoryPack)
    end
    -- Pack Accessory (Bleed) se reaplica al respawn / reentrar
    if currentBleedPack and currentBleedPack ~= "Off" then
        task.delay(0.9, function()
            if LP.Character then
                applyBleedPack(currentBleedPack)
            end
        end)
    end
    updateProgressBarVisibility()
    refreshSpeedModeLabel()
end)

local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3
UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then
        return
    end
    if not isBindableInput(input) then return end
    local kc = input.KeyCode
    if not kc then return end

    if kbMatch(KB.LaggerMode, kc) then
        if tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = tick()
            toggleLaggerCycle()
            saveAllSettings()
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode(); saveAllSettings(); return end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then doTpDown(); return end
    if kbMatch(KB.InstaReset, kc) then instaReset(); return end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        saveAllSettings()
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        saveAllSettings()
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        if not autoBatEnabled then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        saveAllSettings()
        return
    end
    if kbMatch(KB.TPLock, kc) then
        toggleAntiDesyncAimbot()
        if tpLockSetVisual then tpLockSetVisual(_G.AceAntiDesyncAimbotOn) end
        if tpBatFloatingButton then
            local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = _G.AceAntiDesyncAimbotOn and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0)
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then
                    label.TextColor3 = _G.AceAntiDesyncAimbotOn and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
                end
            end
        end
        saveAllSettings()
        return
    end
    if kbMatch(KB.BatV2, kc) then  
        toggleBatV2()
        if autoBatV2SetVisual then autoBatV2SetVisual(autoBatV2Enabled) end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = autoBatV2Enabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0)
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then
                    label.TextColor3 = autoBatV2Enabled and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
                end
            end
        end
        saveAllSettings()
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)

if _G.VeneyorkSpeedIndicator then return end
_G.VeneyorkSpeedIndicator = true

local speedHeadLabel = nil

local function setupSpeedIndicatorHead(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local oldBB = head:FindFirstChild("VeneyorkSpeedIndicator")
    if oldBB then oldBB:Destroy() end

    local bb = Instance.new("BillboardGui", head)
    bb.Name = "VeneyorkSpeedIndicator"
    bb.Size = UDim2.new(0, 200, 0, 70)
    bb.StudsOffset = Vector3.new(0, 2.0, 0)
    bb.AlwaysOnTop = true

    local mainFrame = Instance.new("Frame", bb)
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 1

    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 22)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "ELITE HUB"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.Fantasy
    titleLabel.TextScaled = true
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextStrokeTransparency = 0
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center

    local separator = Instance.new("Frame", mainFrame)
    separator.Size = UDim2.new(0.5, 0, 0, 2)
    separator.Position = UDim2.new(0.25, 0, 0, 24)
    separator.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    separator.BackgroundTransparency = 0.3
    separator.BorderSizePixel = 0
    local grad = Instance.new("UIGradient", separator)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 230)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 230, 230))
    })

    speedHeadLabel = Instance.new("TextLabel", mainFrame)
    speedHeadLabel.Size = UDim2.new(1, 0, 0, 22)
    speedHeadLabel.Position = UDim2.new(0, 0, 0, 30)
    speedHeadLabel.BackgroundTransparency = 1
    speedHeadLabel.Text = "Spd: 0.0"
    speedHeadLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedHeadLabel.Font = Enum.Font.Fantasy
    speedHeadLabel.TextScaled = true
    speedHeadLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedHeadLabel.TextStrokeTransparency = 0
    speedHeadLabel.TextXAlignment = Enum.TextXAlignment.Center
end

local function updateSpeedHead()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not speedHeadLabel then return end
    local v = hrp.AssemblyLinearVelocity
    local flatSpeed = math.sqrt(v.X * v.X + v.Z * v.Z)
    speedHeadLabel.Text = "Spd: " .. string.format("%.1f", flatSpeed)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    setupSpeedIndicatorHead(char)
end)

if LP.Character then
    task.wait(0.1)
    setupSpeedIndicatorHead(LP.Character)
end

RunService.RenderStepped:Connect(updateSpeedHead)nderStepped:Connect(updateSpeedHead)