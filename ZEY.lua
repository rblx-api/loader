--[[LFWM1_XFYgxFhwlXshNr89c7mk9e7UnYTV0AVw]]
do
  local lfwm_7e97626092df4313 = "LFWM1_XFYgxFhwlXshNr89c7mk9e7UnYTV0AVw"
  if false then error(lfwm_7e97626092df4313) end
end

-- [[ ZeyHubb ]] - Menu ribassato, barra furto bianca, pulsanti mobili trascinabili singolarmente
-- No background image, infinite jump (BodyVelocity anti-kick), smooth page scrolling

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Master table
local M = {}

-- ------------------------------------------------------------
-- EARLY CONFIG LOAD
-- ------------------------------------------------------------
M.introSoundEnabled = true
M.introSongChoice = 3
M.introGUIEnabled = true

-- Speed defaults must exist before CherryConfig is read.
-- Otherwise math.clamp(... or M.NS) can receive nil and abort the whole config load.
M.NS = 60
M.CS = 30
M.LAGGER_SPEED = 40
M.LAGGER_CARRY_SPEED = 25

-- Fixed intro track (Shadow.VS / ZEYHUBB 2.1 style) — not changeable
M.INTRO_MUSIC_URL = "https://files.catbox.moe/qhpfe5.mp3"
M.INTRO_MUSIC_FILE = "ZeyHubbIntro_Music.mp3"
introSoundInstance = nil
if isfile and isfile("CherryConfig.json") then
    local ok, data = pcall(function() return HS:JSONDecode(readfile("CherryConfig.json")) end)
    if ok and type(data) == "table" then
        if data.introSoundEnabled ~= nil then M.introSoundEnabled = data.introSoundEnabled end
        if data.introSongChoice then M.introSongChoice = data.introSongChoice end
        if data.introGUIEnabled ~= nil then M.introGUIEnabled = data.introGUIEnabled end
        if data.normalSpeed ~= nil then M.NS = math.clamp(tonumber(data.normalSpeed) or M.NS, 1, 500) end
        if data.carrySpeed ~= nil then M.CS = math.clamp(tonumber(data.carrySpeed) or M.CS, 1, 500) end
        if data.laggerSpeed ~= nil then M.LAGGER_SPEED = math.clamp(tonumber(data.laggerSpeed) or M.LAGGER_SPEED, 1, 500) end
        if data.laggerCarrySpeed ~= nil then M.LAGGER_CARRY_SPEED = math.clamp(tonumber(data.laggerCarrySpeed) or M.LAGGER_CARRY_SPEED, 1, 500) end
        if data.laggerCarryActive ~= nil then M.laggerCarryActive = data.laggerCarryActive == true end
        if type(data.Theme) == "string" then M._savedTheme = data.Theme end
        if type(data.colorScheme) == "string" then M._savedTheme = data.colorScheme end
    end
end

-- ============================================================
-- INTRO (red + black contours)
-- ============================================================
function M.playIntro()
    if M.introGUIEnabled == false and M.introSoundEnabled == false then
        return
    end

    -- ============================================================
    -- ZEYHUBB DUELS INTRO (Shadow.VS-style) — fixed song, ~4 seconds
    -- ============================================================
    local TweenService = game:GetService("TweenService")
    local SoundService = game:GetService("SoundService")
    local player = Players.LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    local MUSIC_URL = M.INTRO_MUSIC_URL or "https://files.catbox.moe/qhpfe5.mp3"
    local MUSIC_FILE = M.INTRO_MUSIC_FILE or "ZeyHubbIntro_Music.mp3"
    local MUSIC_VOLUME = 0.75
    local BPM = 100
    local BEAT = 60 / BPM

    local DEFAULT_BG = tonumber(M.customBgId) or tonumber(M.DEFAULT_BG_ID) or 78248012786524
    local IMAGE_ID = "rbxassetid://" .. tostring(DEFAULT_BG)

    for _, name in ipairs({"ShadowVSIntro", "ZeyHubbDuelsIntro", "ZeyHubbIntro"}) do
        pcall(function()
            local old = PlayerGui:FindFirstChild(name)
            if old then old:Destroy() end
        end)
        pcall(function()
            if gethui then
                local h = gethui()
                local old = h and h:FindFirstChild(name)
                if old then old:Destroy() end
            end
        end)
        pcall(function()
            local cg = game:GetService("CoreGui")
            local old = cg:FindFirstChild(name)
            if old then old:Destroy() end
        end)
    end

    local function loadFixedIntroMusic()
        local asset
        pcall(function()
            if isfile and isfile(MUSIC_FILE) and getcustomasset then
                asset = getcustomasset(MUSIC_FILE)
            end
        end)
        if not asset then
            local ok, data = pcall(function()
                return game:HttpGet(MUSIC_URL)
            end)
            if ok and data and #data > 1000 then
                pcall(function()
                    if writefile then writefile(MUSIC_FILE, data) end
                end)
                pcall(function()
                    if getcustomasset then asset = getcustomasset(MUSIC_FILE) end
                end)
            end
        end
        return asset
    end

    local function playFixedSong()
        if M.introSoundEnabled == false then return nil end
        if introSoundInstance then
            pcall(function() introSoundInstance:Stop() end)
            pcall(function() introSoundInstance:Destroy() end)
            introSoundInstance = nil
        end
        local asset = loadFixedIntroMusic()
        if not asset then return nil end
        local snd = Instance.new("Sound")
        snd.Name = "ZeyHubbIntroMusic"
        snd.SoundId = asset
        snd.Volume = MUSIC_VOLUME
        snd.Looped = false
        snd.Parent = SoundService
        pcall(function() snd:Play() end)
        introSoundInstance = snd
        return snd
    end

    if M.introGUIEnabled == false then
        playFixedSong()
        return
    end

    local introActive = true
    local introFinished = false
    local introSound = nil

    local gui = Instance.new("ScreenGui")
    gui.Name = "ZeyHubbDuelsIntro"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local parented = false
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
    end)
    if gethui then
        parented = pcall(function() gui.Parent = gethui() end)
    end
    if not parented then
        parented = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    end
    if not parented or not gui.Parent then
        gui.Parent = PlayerGui
    end

    local background = Instance.new("Frame")
    background.Size = UDim2.fromScale(1, 1)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BorderSizePixel = 0
    background.ClipsDescendants = true
    background.Parent = gui

    local image = Instance.new("ImageLabel")
    image.AnchorPoint = Vector2.new(0.5, 0.5)
    image.Position = UDim2.fromScale(0.5, 0.5)
    image.Size = UDim2.fromScale(1.06, 1.06)
    image.BackgroundTransparency = 1
    image.Image = IMAGE_ID
    image.ImageTransparency = 1
    image.ScaleType = Enum.ScaleType.Crop
    image.ZIndex = 1
    image.Parent = background

    local dark = Instance.new("Frame")
    dark.Size = UDim2.fromScale(1, 1)
    dark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dark.BackgroundTransparency = 0.25
    dark.BorderSizePixel = 0
    dark.ZIndex = 2
    dark.Parent = background

    local skip = Instance.new("TextButton")
    skip.AnchorPoint = Vector2.new(1, 0)
    skip.Position = UDim2.new(1, -14, 0, 14)
    skip.Size = UDim2.fromOffset(105, 36)
    skip.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    skip.BackgroundTransparency = 0.15
    skip.BorderSizePixel = 0
    skip.Text = "SKIP INTRO"
    skip.TextColor3 = Color3.fromRGB(255, 255, 255)
    skip.TextSize = 12
    skip.Font = Enum.Font.GothamBold
    skip.AutoButtonColor = false
    skip.ZIndex = 500
    skip.Parent = gui
    Instance.new("UICorner", skip).CornerRadius = UDim.new(0, 7)
    do
        local skipStroke = Instance.new("UIStroke")
        skipStroke.Color = Color3.fromRGB(255, 255, 255)
        skipStroke.Transparency = 0.75
        skipStroke.Thickness = 1
        skipStroke.Parent = skip
    end

    local flash = Instance.new("Frame")
    flash.Size = UDim2.fromScale(1, 1)
    flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flash.BackgroundTransparency = 1
    flash.BorderSizePixel = 0
    flash.ZIndex = 400
    flash.Parent = gui

    local introTitle = Instance.new("TextLabel")
    introTitle.AnchorPoint = Vector2.new(0.5, 0.5)
    introTitle.Position = UDim2.fromScale(0.5, 0.5)
    introTitle.Size = UDim2.fromScale(1.0, 0.20)
    introTitle.BackgroundTransparency = 1
    introTitle.Text = "ZeyHubb.vs"
    introTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    introTitle.TextTransparency = 1
    introTitle.TextScaled = true
    introTitle.Font = Enum.Font.GothamBlack
    introTitle.ZIndex = 20
    introTitle.Parent = background
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = Color3.fromRGB(0, 0, 0)
    titleStroke.Thickness = 3
    titleStroke.Transparency = 1
    titleStroke.Parent = introTitle

    local introSubtitle = Instance.new("TextLabel")
    introSubtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    introSubtitle.Position = UDim2.fromScale(0.5, 0.59)
    introSubtitle.Size = UDim2.fromScale(0.7, 0.05)
    introSubtitle.BackgroundTransparency = 1
    introSubtitle.Text = "FH2ONTOP"
    introSubtitle.TextColor3 = Color3.fromRGB(205, 205, 205)
    introSubtitle.TextTransparency = 1
    introSubtitle.TextScaled = true
    introSubtitle.Font = Enum.Font.GothamBold
    introSubtitle.ZIndex = 20
    introSubtitle.Parent = background

    task.spawn(function()
        introSound = playFixedSong()
    end)

    local function finishIntro()
        if introFinished then return end
        introFinished = true
        introActive = false
        if introSound then
            pcall(function()
                TweenService:Create(introSound, TweenInfo.new(0.25), {Volume = 0}):Play()
            end)
            task.delay(0.3, function()
                pcall(function()
                    introSound:Stop()
                    introSound:Destroy()
                end)
                if introSoundInstance == introSound then introSoundInstance = nil end
            end)
        end
        pcall(function() gui:Destroy() end)
    end

    skip.MouseButton1Click:Connect(finishIntro)
    skip.MouseEnter:Connect(function()
        TweenService:Create(skip, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(70, 32, 36)
        }):Play()
    end)
    skip.MouseLeave:Connect(function()
        TweenService:Create(skip, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        }):Play()
    end)

    -- Compressed ~4 second intro
    task.spawn(function()
        TweenService:Create(image, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ImageTransparency = 0
        }):Play()
        TweenService:Create(image, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(1.12, 1.12)
        }):Play()

        task.spawn(function()
            while introActive and gui.Parent do
                flash.BackgroundTransparency = 0.85
                TweenService:Create(flash, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                }):Play()
                task.wait(BEAT)
            end
        end)

        task.wait(0.25)
        if not introActive then return end

        TweenService:Create(introTitle, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(0.9, 0.16),
            TextTransparency = 0
        }):Play()
        TweenService:Create(titleStroke, TweenInfo.new(0.25), {Transparency = 0}):Play()
        TweenService:Create(introSubtitle, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play()

        -- short shake
        for i = 1, 8 do
            if not introActive then return end
            introTitle.Position = UDim2.fromScale(
                0.5 + math.random(-6, 6) / 1000,
                0.5 + math.random(-6, 6) / 1000
            )
            task.wait(0.02)
        end
        introTitle.Position = UDim2.fromScale(0.5, 0.5)

        task.wait(2.4)
        if not introActive then return end

        -- quick final flashes
        for i = 1, 4 do
            if not introActive then return end
            flash.BackgroundTransparency = 0.2
            task.wait(0.03)
            flash.BackgroundTransparency = 1
            task.wait(0.04)
        end

        TweenService:Create(introTitle, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            TextTransparency = 1
        }):Play()
        TweenService:Create(introSubtitle, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            TextTransparency = 1
        }):Play()
        TweenService:Create(titleStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(image, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            ImageTransparency = 1
        }):Play()
        TweenService:Create(dark, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        if introSound and introSound.Parent then
            TweenService:Create(introSound, TweenInfo.new(0.35), {Volume = 0}):Play()
        end

        local finalFade = Instance.new("Frame")
        finalFade.Size = UDim2.fromScale(1, 1)
        finalFade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        finalFade.BackgroundTransparency = 1
        finalFade.BorderSizePixel = 0
        finalFade.ZIndex = 1000
        finalFade.Parent = gui
        TweenService:Create(finalFade, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            BackgroundTransparency = 0
        }):Play()

        task.wait(0.4)
        finishIntro()
    end)
end

pcall(M.playIntro)

-- ============================================================
-- SKY THEME (unchanged)
-- ============================================================
M.CANDY_SKY_TAG = "MoveeSkyTheme"
M.currentSkyTheme = "Night"
M.CANDY_SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
M.SkyOrder = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

local function candyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
function M.CandyApplyCustomSky(mode)
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(M.CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(M.CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=M.CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(40, 40, 40);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end
    if preset.sky then
        local skyInst=Instance.new("Sky");skyInst:SetAttribute(M.CANDY_SKY_TAG,true)
        if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
        skyInst.Parent=Lighting
    end
    if preset.atm then
        local atm=Instance.new("Atmosphere");atm:SetAttribute(M.CANDY_SKY_TAG,true)
        atm.Density=preset.atm.dens or 0.3;atm.Color=candyColor(preset.atm.color);atm.Decay=candyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
    end
    if preset.clouds and terrain then
        local clouds=Instance.new("Clouds");clouds:SetAttribute(M.CANDY_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=candyColor(preset.clouds.color);clouds.Parent=terrain
    end
end

-- ============================================================
-- ANIMATION PACKS (unchanged)
-- ============================================================
M.PACKS = {
    ["Adidas Sports"] = {
        WalkAnim = 18537392113,
        RunAnim  = 18537384940,
        JumpAnim = 18537380791,
        FallAnim = 18537367238,
        SwimIdle = 18537387180,
        Swim     = 18537389531,
        Animation1 = 18537376492,
        Animation2 = 18537371272,
        ClimbAnim = 18537363391,
    },
    ["Adidas Community"] = {
        WalkAnim = 122150855457006,
        RunAnim  = 82598234841035,
        JumpAnim = 75290611992385,
        FallAnim = 98600215928904,
        SwimIdle = 109346520324160,
        Swim     = 133308483266208,
        Animation1 = 122257458498464,
        Animation2 = 102357151005774,
        ClimbAnim = 88763136693023,
    },
    ["Adidas Aura"] = {
        WalkAnim = 83842218823011,
        RunAnim  = 118320322718866,
        JumpAnim = 109996626521204,
        FallAnim = 95603166884636,
        SwimIdle = 94922130551805,
        Swim     = 134530128383903,
        Animation1 = 110211186840347,
        Animation2 = 114191137265065,
        ClimbAnim = 97824616490448,
    },
    ["Wicked Popular"] = {
        WalkAnim = 92072849924640,
        RunAnim = 72301599441680,
        JumpAnim = 104325245285198,
        FallAnim = 121152442762481,
        Animation1 = 118832222982049,
        ClimbAnim = 131326830509784,
        SwimIdle = 113199415118199,
        Swim = 99384245425157,
        Animation2 = 76049494037641,
    },
    Elder = {
        WalkAnim = 10921111375,
        RunAnim  = 10921104374,
        JumpAnim = 10921107367,
        FallAnim = 10921105765,
        SwimIdle = 10921110146,
        Swim     = 10921108971,
        ClimbAnim = 10921100400,
        Animation1 = 10921101664,
        Animation2 = 10921102574,
    },
    Zombie = {
        WalkAnim = 10921355261,
        RunAnim  = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim     = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
    },
    Mage = {
        WalkAnim = 10921152678,
        RunAnim  = 10921148209,
        JumpAnim = 10921149743,
        FallAnim = 10921148939,
        SwimIdle = 10921151661,
        Swim     = 10921150788,
        ClimbAnim = 10921143404,
        Animation1 = 10921144709,
        Animation2 = 10921145797,
    },
    ["Catwalk Glam"] = {
        WalkAnim = 109168724482748,
        RunAnim  = 81024476153754,
        JumpAnim = 116936326516985,
        FallAnim = 92294537340807,
        SwimIdle = 98854111361360,
        Swim     = 134591743181628,
        ClimbAnim = 119377220967554,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
    },
    Astronaut = {
        WalkAnim = 10921046031,
        RunAnim  = 10921039308,
        JumpAnim = 10921042494,
        FallAnim = 10921040576,
        SwimIdle = 10921045006,
        Swim     = 10921044000,
        ClimbAnim = 10921032124,
        Animation1 = 10921034824,
        Animation2 = 10921036806,
    },
    ['Wicked "Dancing Through Life"'] = {
        WalkAnim = 73718308412641,
        RunAnim  = 135515454877967,
        JumpAnim = 78508480717326,
        FallAnim = 78147885297412,
        SwimIdle = 129183123083281,
        Swim     = 110657013921774,
        ClimbAnim = 129447497744818,
        Animation1 = 92849173543269,
        Animation2 = 132238900951109,
    },
    Werewolf = {
        WalkAnim = 10921342074,
        RunAnim  = 10921336997,
        JumpAnim = nil,
        FallAnim = 10921337907,
        SwimIdle = 10921341319,
        Swim     = 10921340419,
        ClimbAnim = 10921329322,
        Animation1 = 10921330408,
        Animation2 = 10921333667,
    },
    Superhero = {
        WalkAnim = 10921298616,
        RunAnim  = 10921291831,
        JumpAnim = 10921294559,
        FallAnim = 10921293373,
        SwimIdle = 10921297391,
        Swim     = 10921295495,
        ClimbAnim = 10921286911,
        Animation1 = 10921288909,
        Animation2 = 10921290167,
    },
    Toy = {
        WalkAnim = 10921312010,
        RunAnim  = 10921306285,
        JumpAnim = 10921308158,
        FallAnim = 10921307241,
        SwimIdle = 10921310341,
        Swim     = 10921309319,
        ClimbAnim = 10921300839,
        Animation1 = 10921301576,
        Animation2 = nil,
    },
    ["No Boundaries"] = {
        WalkAnim = 18747074203,
        RunAnim  = 18747070484,
        JumpAnim = 18747069148,
        FallAnim = 18747062535,
        SwimIdle = 18747071682,
        Swim     = 18747073181,
        ClimbAnim = 18747060903,
        Animation1 = 18747067405,
        Animation2 = 18747063918,
    },
    NFL = {
        WalkAnim = 110358958299415,
        RunAnim  = 117333533048078,
        JumpAnim = 119846112151352,
        FallAnim = 129773241321032,
        SwimIdle = 79090109939093,
        Swim     = 132697394189921,
        ClimbAnim = 134630013742019,
        Animation1 = 92080889861410,
        Animation2 = 74451233229259,
    },
    ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim  = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim     = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
        Animation2 = nil,
    },
    Vampire = {
        WalkAnim = 10921326949,
        RunAnim  = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim     = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
        Animation2 = nil,
    },
    Ninja = {
        Run=656118852, Walk=656121766, Jump=656117878, Fall=656115606,
        Swim=656119721, SwimIdle=656121397, Climb=656114359,
        Idle={656117400,656118341,886742569}
    },
    Robot = {
        Run=616091570, Walk=616095330, Jump=616090535, Fall=616087089,
        Swim=616092998, SwimIdle=616094091, Climb=616086039,
        Idle={616088211,616089559,885531463}
    },
    Levitation = {
        Run=616010382, Walk=616013216, Jump=616008936, Fall=616005863,
        Swim=616011509, SwimIdle=616012453, Climb=616003713,
        Idle={616006778,616008087,886862142}
    },
    Stylish = {
        Run=616140816, Walk=616146177, Jump=616139451, Fall=616134815,
        Swim=616143378, SwimIdle=616144772, Climb=616133594,
        Idle={616136790,616138447,886888594}
    },
    Bubbly = {
        Run=910025107, Walk=910034870, Jump=910016857, Fall=910001910,
        Swim=910028158, SwimIdle=910030921, Climb=909997997,
        Idle={910004836,910009958,1018536639}
    },
    Cartoon = {
        Run=742638842, Walk=742640026, Jump=742637942, Fall=742637151,
        Swim=742639220, SwimIdle=742639812, Climb=742636889,
        Idle={742637544,742638445,885477856}
    },
}
M.animPack = "Bubbly" -- girl-style default for ZEYHUBB users
M.animPackEnabled = true
M.savedAnimate = nil
M.zeyhubbBlackSkinEnabled = true -- black body skin for ZEYHUBB users

-- ============================================================
-- CHARTER FEATURES (Headless & Korblox)
-- ============================================================
M.headlessEnabled = false
M.korbloxEnabled = true -- ON by default, toggle off in Utility

local HEADLESS_MESH_ID = "rbxassetid://1095708"
local KORBLOX_MESH_ID = "rbxassetid://101851696"
local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
local DARK_GREY_COLOR = Color3.fromRGB(64, 64, 64)

local function removeFace(head)
    local face = head:FindFirstChild("face")
    if face then face:Destroy() end
end

function M.applyHeadlessToChar(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        removeFace(head)

        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.MeshId == HEADLESS_MESH_ID then
                child:Destroy()
            end
        end

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Name = "HeadlessMesh"
        mesh.Parent = head

        head:GetPropertyChangedSignal("Transparency"):Connect(function()
            if head.Transparency ~= 1 then
                head.Transparency = 1
            end
        end)
        head.ChildAdded:Connect(function(child)
            if child.Name == "face" and child:IsA("Decal") then
                child:Destroy()
            end
        end)
    else
        head.Transparency = 0
        head.CanCollide = true
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
                child:Destroy()
            end
        end
        removeFace(head)
    end
end

function M.applyKorbloxToChar(char, enabled)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if enabled then
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then
                        child:Destroy()
                    end
                end
                rightLeg.Color = DARK_GREY_COLOR
                rightLeg:GetPropertyChangedSignal("Color"):Connect(function()
                    if rightLeg.Color ~= DARK_GREY_COLOR then
                        rightLeg.Color = DARK_GREY_COLOR
                    end
                end)
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = rightLeg
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 1
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 1 end
                if rightFoot then rightFoot.Transparency = 1 end

                local oldKorblox = char:FindFirstChild("KorbloxLeg")
                if oldKorblox then oldKorblox:Destroy() end

                local korbloxLeg = Instance.new("Part")
                korbloxLeg.Name = "KorbloxLeg"
                korbloxLeg.Size = Vector3.new(1, 2, 1)
                korbloxLeg.Anchored = false
                korbloxLeg.CanCollide = false
                korbloxLeg.Color = DARK_GREY_COLOR
                korbloxLeg.Parent = char

                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = korbloxLeg

                local weld = Instance.new("Weld")
                weld.Part0 = rightUpperLeg
                weld.Part1 = korbloxLeg
                weld.C0 = CFrame.new(0, -0.8, 0)
                weld.Name = "KorbloxWeld"
                weld.Parent = korbloxLeg
            end
        end
    else
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then
                        child:Destroy()
                    end
                end
                rightLeg.Color = Color3.fromRGB(255, 255, 255)
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 0
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 0 end
                if rightFoot then rightFoot.Transparency = 0 end
                local korbloxLeg = char:FindFirstChild("KorbloxLeg")
                if korbloxLeg then korbloxLeg:Destroy() end
            end
        end
    end
end

function M.applyCharterToChar(char)
    if not char then return end
    M.applyHeadlessToChar(char, M.headlessEnabled)
    M.applyKorbloxToChar(char, M.korbloxEnabled)
    if M.zeyhubbBlackSkinEnabled then
        M.applyZeyHubbBlackSkin(char)
    end
end

-- Full black body + no accessories/clothes + ZEYHUBB torso chip (visible all sides)
function M.stripZeyHubbClothing(char)
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Accessory") or c:IsA("Hat") or c:IsA("Shirt") or c:IsA("Pants")
            or c:IsA("ShirtGraphic") or c:IsA("Clothing")
            or c.ClassName == "LayeredClothing" then
            if not c:GetAttribute("ZeyHubbChip") then
                pcall(function() c:Destroy() end)
            end
        end
    end
    -- layered clothing under humanoid
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            for _, a in ipairs(hum:GetAccessories()) do
                if not a:GetAttribute("ZeyHubbChip") then pcall(function() a:Destroy() end) end
            end
        end)
        for _, d in ipairs(hum:GetDescendants()) do
            if d:IsA("Accessory") or d.ClassName == "LayeredClothing" then
                if not d:GetAttribute("ZeyHubbChip") then pcall(function() d:Destroy() end) end
            end
        end
    end
    -- clear description clothing slots if possible
    pcall(function()
        if not hum then return end
        local desc = hum:GetAppliedDescription()
        if not desc then return end
        desc.Shirt = 0
        desc.Pants = 0
        desc.GraphicTShirt = 0
        for _, slot in ipairs({
            "HatAccessory","HairAccessory","FaceAccessory","NeckAccessory",
            "ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory"
        }) do
            pcall(function() desc[slot] = "" end)
        end
        -- keep body black via body colors after apply
        pcall(function() hum:ApplyDescription(desc) end)
    end)
end

function M.attachZeyHubbTorsoChip(char)
    -- Removed: no red torso chip.
end

function M.applyZeyHubbBlackSkin(char)
    char = char or player.Character
    if not char then return end
    if not M.zeyhubbBlackSkinEnabled then return end

    M.stripZeyHubbClothing(char)

    local black = Color3.fromRGB(15, 15, 17)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
            pcall(function()
                p.Color = black
                p.Material = Enum.Material.SmoothPlastic
                if p:IsA("MeshPart") then
                    p.TextureID = ""
                end
            end)
        elseif p:IsA("SpecialMesh") then
            pcall(function()
                p.TextureId = ""
            end)
        elseif p:IsA("Decal") or p:IsA("Texture") then
            -- keep face-less pure black look
            if p.Name == "face" or p.Name == "Face" then
                pcall(function() p:Destroy() end)
            end
        end
    end
    local bc = char:FindFirstChildOfClass("BodyColors")
    if bc then
        pcall(function()
            bc.HeadColor3 = black
            bc.LeftArmColor3 = black
            bc.RightArmColor3 = black
            bc.LeftLegColor3 = black
            bc.RightLegColor3 = black
            bc.TorsoColor3 = black
        end)
    end

    M.attachZeyHubbTorsoChip(char)

    -- keep stripping clothes that get re-added
    if M._zeyhubbBlackChildConn then
        pcall(function() M._zeyhubbBlackChildConn:Disconnect() end)
        M._zeyhubbBlackChildConn = nil
    end
    M._zeyhubbBlackChildConn = char.ChildAdded:Connect(function(c)
        if not M.zeyhubbBlackSkinEnabled then return end
        if c:GetAttribute("ZeyHubbChip") then return end
        if c:IsA("Accessory") or c:IsA("Hat") or c:IsA("Shirt") or c:IsA("Pants")
            or c:IsA("ShirtGraphic") or c:IsA("Clothing") then
            task.defer(function() pcall(function() c:Destroy() end) end)
        end
    end)
end

-- VYNC SKIN toggle — asset 116358759349760
M.VYNC_SKIN_ID = 116358759349760
M.vyncSkinEnabled = false

local function vyncStrip(char)
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Accessory") or c:IsA("Hat") then pcall(function() c:Destroy() end) end
    end
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then for _, a in ipairs(hum:GetAccessories()) do pcall(function() a:Destroy() end) end end
    end)
end

local function vyncFindAcc(obj)
    if not obj then return nil end
    if obj:IsA("Accessory") or obj:IsA("Hat") then return obj end
    local a = obj:FindFirstChildOfClass("Accessory") or obj:FindFirstChildOfClass("Hat")
    if a then return a end
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("Accessory") or d:IsA("Hat") then return d end
    end
    return nil
end
local function vyncLoad(id)
    id = tonumber(id) or 0
    if id <= 0 then return nil end
    local url = "rbxassetid://" .. tostring(id)
    local bag = {}
    pcall(function()
        if typeof(getobjects) == "function" then
            local t = getobjects(url)
            if type(t) == "table" then for _, o in ipairs(t) do table.insert(bag, o) end end
        elseif game.GetObjects then
            local t = game:GetObjects(url)
            if type(t) == "table" then for _, o in ipairs(t) do table.insert(bag, o) end end
        end
    end)
    pcall(function()
        local m = game:GetService("InsertService"):LoadAsset(id)
        if m then table.insert(bag, m) end
    end)
    pcall(function()
        local IS = game:GetService("InsertService")
        if IS.LoadLocalAsset then
            local o = IS:LoadLocalAsset(url)
            if o then table.insert(bag, o) end
        end
    end)
    for _, o in ipairs(bag) do
        local acc = vyncFindAcc(o)
        if acc then
            local cl = acc:Clone()
            cl:SetAttribute("ZeyHubbSkin", true)
            cl.Name = "ZeyHubbSkin"
            for _, x in ipairs(bag) do pcall(function() x:Destroy() end) end
            return cl
        end
    end
    for _, x in ipairs(bag) do pcall(function() x:Destroy() end) end
    return nil
end

function M.applyVyncSkin(char)
    if not M.vyncSkinEnabled then return end
    char = char or player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 6)
    if not hum then return end
    vyncStrip(char)
    for _, c in ipairs(char:GetChildren()) do
        if (c:IsA("Accessory") or c:IsA("Hat")) and c:GetAttribute("ZeyHubbSkin") then return end
    end
    local id = tonumber(M.VYNC_SKIN_ID) or 116358759349760
    local acc = vyncLoad(id)
    if acc then
        pcall(function() hum:AddAccessory(acc) end)
        if not acc.Parent then acc.Parent = char end
        return
    end
    pcall(function()
        local desc = hum:GetAppliedDescription()
        if not desc then return end
        local idStr = tostring(id)
        for _, slot in ipairs({"HatAccessory","HairAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory"}) do
            pcall(function() desc[slot] = "" end)
        end
        for _, slot in ipairs({"HatAccessory","HairAccessory","BackAccessory","FrontAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","WaistAccessory"}) do
            pcall(function() desc[slot] = idStr end)
        end
        pcall(function() hum:ApplyDescription(desc) end)
        task.wait(0.12)
        local kept = false
        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("Accessory") or c:IsA("Hat") then
                if not kept then
                    kept = true
                    c:SetAttribute("ZeyHubbSkin", true)
                    c.Name = "ZeyHubbSkin"
                else
                    pcall(function() c:Destroy() end)
                end
            end
        end
        if not kept then
            local a2 = vyncLoad(id)
            if a2 then
                pcall(function() hum:AddAccessory(a2) end)
                if not a2.Parent then a2.Parent = char end
            end
        end
    end)
end

function M.clearVyncSkin(char)
    char = char or player.Character
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do
        if (c:IsA("Accessory") or c:IsA("Hat")) and (c:GetAttribute("ZeyHubbSkin") or c.Name == "ZeyHubbSkin") then
            pcall(function() c:Destroy() end)
        end
    end
end

function M.setVyncSkin(on)
    M.vyncSkinEnabled = on == true
    if M.vyncSkinEnabled then
        M.applyVyncSkin(player.Character)
        task.delay(0.8, function() if M.vyncSkinEnabled then M.applyVyncSkin(player.Character) end end)
    else
        M.clearVyncSkin(player.Character)
    end
    if M.setVyncSkinVisual then pcall(function() M.setVyncSkinVisual(M.vyncSkinEnabled) end) end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.startVyncSkinWatch()
    if M._vyncCharConn then pcall(function() M._vyncCharConn:Disconnect() end); M._vyncCharConn = nil end
    M._vyncCharConn = player.CharacterAdded:Connect(function(char)
        if not M.vyncSkinEnabled then return end
        task.wait(0.45)
        M.applyVyncSkin(char)
        task.delay(1.2, function() if M.vyncSkinEnabled and player.Character == char then M.applyVyncSkin(char) end end)
        task.delay(2.5, function() if M.vyncSkinEnabled and player.Character == char then M.applyVyncSkin(char) end end)
    end)
    if M.vyncSkinEnabled and player.Character then
        task.defer(function() M.applyVyncSkin(player.Character) end)
    end
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.35)
    if M.headlessEnabled or M.korbloxEnabled then
        M.applyCharterToChar(char)
    end
end)

task.spawn(function()
    task.wait(0.2)
    pcall(M.startVyncSkinWatch)
end)

-- ============================================================
-- STATE
-- ============================================================
M.NS = M.NS or 60
M.CS = M.CS or 30
M.LAGGER_SPEED = M.LAGGER_SPEED or 40
M.LAGGER_CARRY_SPEED = M.LAGGER_CARRY_SPEED or 25
M.speedMethod = "Velocity"
M.speedMethodList = {
    "Velocity", "AssemblyLinearVelocity", "Velocity Lerp", "AssemblyLinearVelocity Lerp",
    "CFrame", "CFrame Lerp", "Hyper CFrame", "Anchored CFrame", "PivotTo", "Model PivotTo", "Tween CFrame",
    "WalkSpeed", "Humanoid Move", "Humanoid MoveTo",
    "BodyVelocity", "BodyPosition", "BodyForce", "BodyThrust",
    "LinearVelocity", "VectorForce", "AlignPosition",
    "ApplyImpulse", "RocketPropulsion",
}
M.hyperMult = 4
M._lastSpeedMethod = nil
M._speedHRP = nil
M._anchoredBySpeed = nil
M._bodyVel = nil
M._bodyPosition = nil
M._bodyForce = nil
M._bodyThrust = nil
M._linearVel = nil
M._vectorForce = nil
M._alignPos = nil
M._rocket = nil
M._rocketTarget = nil
M._attLinVel = nil
M._attVecForce = nil
M._attAlign = nil
M._speedTween = nil
M.carrySpeedActive = false
M.laggerModeEnabled = false
M.laggerCarryActive = M.laggerCarryActive == true

M.antiRagdollEnabled = false
M.hardHitEnabled = false
M.hardHitRadius = 10
M.antiRagdollMode = "Splatter"
M.infJumpEnabled = false
M.infJumpMode = "manual"
M.medusaCounterEnabled = false
M.batCounterEnabled = false
M.unwalkEnabled = false
M.medusaResetEnabled = false -- completely removed
M.medusaDebounce = false
M.medusaLastUsed = 0
M.dropActive = false
M.autoLeftEnabled = false
M.autoRightEnabled = false
M.autoBatEnabled = false
M.autoSwingEnabled = true
M.autoMoveSwingEnabled = false
M.autoMoveSwingInterval = 0.3
M._alSwingDebounce = false
M._arSwingDebounce = false
M.antiLagEnabled = false
M.antiSummerBaseEnabled = false
M.antiSummerBaseConn = nil
M._antiSummerCleaned = {}

M.removeAccessoriesEnabled = false
M.antiLagDescConn = nil
M.stretchRezEnabled = false
M.stretchRezConn = nil
M.unwalkSavedAnimate = nil
M._anyKeyListening = false
M.autoTPEnabled = false
M.autoTPHeight = 20
M.autoTPConn = nil
M.cursedResetRemote = nil
M.CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
M.guiTransparencyEnabled = false
M.mobileButtonsEnabled = true
M.mobileButtonsLocked = false
M.mobileButtonsSize = 100
M.circleButtonsEnabled = false
M.mobBtnRefs = {}
M.mobGuiRef = nil
M.fovValue = 80
M.fovOptions = {80,120,180}
M.fovIndex = 1
M.laggerModePillRef = nil
M.carryModePillRef = nil
M.autoSwitchSpeedEnabled = false
M.autoTurnOffSpeedEnabled = false
M.autoSwitchLaggerSpeedEnabled = false
M.autoCarryEnemyBaseEnabled = false
M.autoCarryEnemyBaseRange = 35
M._autoCarryEnemyBaseConn = nil
M.setAutoCarryEnemyBaseVisual = nil
M.AUTO_SWITCH_THRESHOLD = 25
M._autoSwitchSpeedConn = nil
M.customFontSelected = "None"
M.mobBtnTransparencyEnabled = false
M.perButtonDragEnabled = true
M.antiKickEnabled = false
M.brainrotDetected = false
M.safeModeEnabled = false
M.activeBatBillboard = nil
M.activeMedusaBillboard = nil
M.ragdollGuiEnabled = true
M.persistentRagdollGui = nil
M.uiLocked = false
M.holdInfJumpConn = nil
M.DROP_ASCEND_DURATION = 0.2
M.DROP_ASCEND_SPEED = 150
M.autoResetOnDeath = false -- completely removed
M.bypassAimbotEnabled = false
M.bypassAimbotConn = nil
M._bypassGodConn = nil
M._bypassGodHealthConn = nil
M._bypassGodDiedConn = nil
M._bypassGodCharConn = nil
M.bypassPrevAutoRotate = nil
M.bypassHitCD = false
M.bypassSwingCD = 0.35
M.bypassHitDist = 8
M._bypassTarget = nil

M.stealMode = "V2"
M.stealBarSize = 460
-- Persistent Auto Steal bar position (center-based so resizing keeps the same place).
M._stealBarPos = nil
M.Steal = {
    AutoStealEnabled = false,
    StealRadius = 60,
    StealDuration = 1.4,
    StopTime = 0.35,
}
M.V3 = {
    enabled = false,
    conn = nil,
    progress = 0,
    lastInRange = 0,
    currentUid = nil,
    holding = false,
    holdPrompt = nil,
    cooldownUntil = 0,
}
M.autoRadiusEnabled = false
function M.getAutoRadius()
    local radius = math.clamp((tonumber(M.NS) or 60) + 1, 1, 500)
    return math.floor(radius * 10 + 0.5) / 10
end
function M.getActiveStealRadius()
    if M.stealMode == "Semi" then
        return math.min(tonumber(M.Semi.radius) or 10, 10)
    end
    -- V2 uses main steal radius
    return M.autoRadiusEnabled and M.getAutoRadius() or M.Steal.StealRadius
end
M.Semi = {
    enabled = false,
    holdMin = 1.3,
    holdMax = 2.6,
    entryDelay = 0.3,
    cooldown = 0.05,
    primeRange = 80,
    radius = 10, -- STEAL_RANGE from auto-grabber
    conn = nil,
    scanThread = nil,
    plotSync = {caches = {}, connections = {}},
    animals = {},
    promptCache = {},
    internalCache = {},
    state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
    plots = nil,
    syncReady = false,
}
M.isStealing = false
M.stealStartTime = 0
M.stealConn = nil
M.progressConn = nil
M.animalCache = {}
M.promptCache = {}
M.stealCache = {}
M.playerESPEnabled = true -- circular enemy avatars on by default
M.espList = {}
M.pingPopupActive = false
M.pingPopupGui = nil
M.pingCycleTimer = nil
M.pingPanelPos = nil
M.pingPanelOpen = false
M.pingGui = nil
M.pingMain = nil
M.pingSettings = nil
M.pingActive = false
M.pingPower = 100000
M.pingInterval = 0.125
M.pingKeybindKb = "T"
M.pingKeybindGp = "ButtonR2"
M.pingAutoBrainrot = true
M.pingRemote = nil
M.pingBrainrotMode = false
M.pingLastBrainrot = false
M.pingManualOverride = false
M.pingListening = nil
M.pingLoopRunning = false
M.setPingPanelVisual = nil

-- ZeyHubb Bypass panel state
M.bypassPanelOpen = false
M.bypassPanelGui = nil
M.bypassPanelMain = nil
M.bypassPanelMini = nil
M.bypassActive = false
M.bypassAutoBrainrot = false
M._bypassSpamRunning = false
M.bypassBillboardOn = false
M.bypassKeybind = "V"
M.bypassPower = 97000
M._bypassSpamRunning = false
M._bypassSpamThread = nil
M._bypassBomb = nil
M._bypassBillboard = nil
M.setBypassPanelVisual = nil

M.Conns = {autoSteal=nil, antiRag=nil, batCounter=nil, anchor={}}
M._persistentConns = {}
M.alConn = nil
M.arConn = nil
M.alPhase = 1
M.arPhase = 1
M.aimbotConn = nil
M.lastMoveDir = Vector3.new(0,0,0)
M.batCounterDebounce = false
M.speedLabel = nil

-- Keybinds
M.KB = {
    DropBrainrot={kb=nil,gp=nil},
    AutoLeft={kb=nil,gp=nil},
    AutoRight={kb=nil,gp=nil},
    AutoBat={kb=nil,gp=nil},
    TPFloor={kb=nil,gp=nil},
    InstaReset={kb=nil,gp=nil},
    GuiHide={kb=nil,gp=nil},
    SpeedToggle={kb=nil,gp=nil},
    LaggerToggle={kb=nil,gp=nil},
    BypassAimbot={kb=nil,gp=nil},
    PingLagger={kb=Enum.KeyCode.T,gp=nil},
    AntiDie={kb=nil,gp=nil},
}
M.AP_L1 = Vector3.new(-476.47,-6.28,92.73)
M.AP_L2 = Vector3.new(-483.12,-4.95,94.81)
M.AP_R1 = Vector3.new(-476.16,-6.52,25.62)
M.AP_R2 = Vector3.new(-483.06,-5.03,25.48)
M.MEDUSA_COOLDOWN = 25
M.BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
M.fovConn = nil
M.defLightBrightness = nil
M.defLightClock = nil
M.defLightAmbient = nil
M.mainFrame = nil
M.normalBox = nil
M.carryBox = nil
M.laggerBox = nil
M.radInput = nil
M.autoTPHeightBox = nil
M.durationBox = nil
M.modeValLbl = nil
M.setInstaGrab = nil
M.setInfJumpVisual = nil
M.setAntiRagVisual = nil
M.setMedusaVisual = nil
M.setUnwalkVisual = nil
M.setAntiLagVisual = nil
M.setAutoSwingVisual = nil
M.setTranspVisual = nil
M.setLockVisual = nil
M.setMobVisual = nil
M.setCircleBtnsVisual = nil
M.setMedusaResetVisual = nil
M.antiKickSetVisual = nil
M.autoLeftSetVisual = nil
M.autoRightSetVisual = nil
M.autoBatSetVisual = nil
M.setAutoTPVisual = nil
M.setStretchRezVisual = nil
M.setAutoResetOnDeath = nil
M.setBypassVisual = nil
M._autoSwitchWasSteal = false

M.MOB_POS_FILE = "moveeduels_btnpos.json"
function M.themeDarkFromAccent(accent, amount)
    amount = math.clamp(tonumber(amount) or 0.12, 0, 1)
    if typeof(accent) ~= "Color3" then accent = Color3.fromRGB(220, 40, 40) end
    return Color3.new(
        math.clamp(accent.R * amount, 0, 1),
        math.clamp(accent.G * amount, 0, 1),
        math.clamp(accent.B * amount, 0, 1)
    )
end
M.MOVE_KEYS = {
    [Enum.KeyCode.W]=true,
    [Enum.KeyCode.A]=true,
    [Enum.KeyCode.S]=true,
    [Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,
    [Enum.KeyCode.Left]=true,
    [Enum.KeyCode.Down]=true,
    [Enum.KeyCode.Right]=true
}

M.showPlayerSpeeds = false
M.playerSpeedGuis = {}
M.playerSpeedUpdateConn = nil
M.removeAccEnabled = false
M.removeAccConn = nil
M.removedAccessories = {}
M.uiScale = 0.95
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    M.uiScale = 0.85
end
M.uiScaleSliderRef = nil
M.uiScaleLabelRef = nil
M.uiScaleBoxRef = nil
M.lineESPEnabled = false
M.highlightESPEnabled = false
M.hitboxESPEnabled = false
M.menuOpen = true
M.speedESPEnabled = false

M.statusGui = nil
M.statusFill = nil
M.statusPctLbl = nil
M.statusRadiusLbl = nil
M.statusDot = nil
M.statusMain = nil
M.statusFpsLbl = nil

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
function M.addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(100,100,100)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(100,100,100))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end

function M.applyFOV()
    if M.fovConn then M.fovConn:Disconnect() end
    M.fovConn=RunService.RenderStepped:Connect(function() local cam=workspace.CurrentCamera;if cam then cam.FieldOfView=M.fovValue end end)
end

-- ============================================================
-- RAGDOLL TIMER
-- ============================================================
M.ragdollTimerThread = nil
M.ragdollTimerRemaining = 0
M.isRagdollActive = false

function M.updateRagdollTimer(duration)
    if M.ragdollTimerThread then
        task.cancel(M.ragdollTimerThread)
        M.ragdollTimerThread = nil
    end
    if duration <= 0 then
        M.isRagdollActive = false
        if M.headIndicator and M.headIndicator.ragdollTimer then
            M.headIndicator.ragdollTimer.Text = ""
        end
        return
    end
    M.isRagdollActive = true
    local startTime = tick()
    M.ragdollTimerRemaining = duration
    M.ragdollTimerThread = task.spawn(function()
        while M.isRagdollActive and M.ragdollTimerRemaining > 0 do
            local elapsed = tick() - startTime
            local remaining = math.max(0, duration - elapsed)
            M.ragdollTimerRemaining = remaining
            if M.headIndicator and M.headIndicator.ragdollTimer then
                M.headIndicator.ragdollTimer.Text = string.format("%.1fs", remaining)
            end
            if remaining <= 0 then
                M.isRagdollActive = false
                if M.headIndicator and M.headIndicator.ragdollTimer then
                    M.headIndicator.ragdollTimer.Text = ""
                end
                break
            end
            task.wait(0.05)
        end
        M.ragdollTimerThread = nil
    end)
end

function M.onHumanoidStateChanged(old,new)
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand then
        M.updateRagdollTimer(2.6)
    end
end

function M.onMedusaStateChanged()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand then
        M.updateRagdollTimer(4.5)
    end
end

function M.setupRagdollTriggers()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.StateChanged:Connect(M.onHumanoidStateChanged)
        hum:GetPropertyChangedSignal("PlatformStand"):Connect(M.onMedusaStateChanged)
    end
end

-- ============================================================
-- ANIMATION FUNCTIONS (unchanged)
-- ============================================================
function M.waitForAnimate(char)
    for _ = 1, 40 do
        local a = char:FindFirstChild("Animate")
        if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then
            return a
        end
        task.wait(0.1)
    end
    return nil
end

function M.setAnim(animObj, id)
    if animObj and id then
        animObj.AnimationId = "rbxassetid://" .. tostring(id)
    end
end

function M.stopAllTracks(hum)
    if not hum then return end
    for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() t:Stop(0) end)
    end
end

function M.ensureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then
        a = Instance.new("Animation")
        a.Name = name
        a.Parent = folder
    end
    return a
end

function M.ensureIdleSlots(idleFolder, n)
    if not idleFolder then return end
    n = n or 2
    for i=1,n do
        M.ensureAnim(idleFolder, "Animation" .. i)
    end
end

function M.pick(pack, ...)
    for i = 1, select("#", ...) do
        local k = select(i, ...)
        local v = pack[k]
        if v ~= nil then return v end
    end
    return nil
end

function M.saveOriginalAnimate(char)
    if not char then return end
    if M.savedAnimate then return end
    local animate = char:FindFirstChild("Animate")
    if animate then
        M.savedAnimate = animate:Clone()
    end
end

function M.restoreOriginalAnimate(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        M.stopAllTracks(hum)
    end
    local currentAnimate = char:FindFirstChild("Animate")
    if currentAnimate then
        currentAnimate:Destroy()
    end
    if M.savedAnimate then
        local newAnimate = M.savedAnimate:Clone()
        newAnimate.Parent = char
        newAnimate.Disabled = true
        task.wait(0.06)
        newAnimate.Disabled = false
    end
end

function M.resetAnimations(char)
    if not char then return end
    M.restoreOriginalAnimate(char)
end

local applyingAnim = false
function M.applyAnimPack(packName)
    if not M.animPackEnabled then
        local char = player.Character
        if char then
            M.resetAnimations(char)
        end
        return false
    end
    if applyingAnim then return false end
    applyingAnim = true

    local pack = M.PACKS[packName]
    if not pack then
        applyingAnim = false
        return false
    end

    local char = player.Character or player.CharacterAdded:Wait()
    M.saveOriginalAnimate(char)

    local animate = M.waitForAnimate(char)
    if not animate then
        applyingAnim = false
        return false
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    M.stopAllTracks(hum)

    local runObj   = M.ensureAnim(animate:FindFirstChild("run"),   "RunAnim")
    local walkObj  = M.ensureAnim(animate:FindFirstChild("walk"),  "WalkAnim")
    local jumpObj  = M.ensureAnim(animate:FindFirstChild("jump"),  "JumpAnim")
    local fallObj  = M.ensureAnim(animate:FindFirstChild("fall"),  "FallAnim")
    local climbObj = M.ensureAnim(animate:FindFirstChild("climb"), "ClimbAnim")
    local swimObj  = M.ensureAnim(animate:FindFirstChild("swim"),     "Swim")
    local swimIdleObj = M.ensureAnim(animate:FindFirstChild("swimidle"), "SwimIdle")
    local idleFolder = animate:FindFirstChild("idle")

    M.setAnim(walkObj,  M.pick(pack, "WalkAnim", "Walk"))
    M.setAnim(runObj,   M.pick(pack, "RunAnim", "Run"))
    M.setAnim(jumpObj,  M.pick(pack, "JumpAnim", "Jump"))
    M.setAnim(fallObj,  M.pick(pack, "FallAnim", "Fall"))
    M.setAnim(climbObj, M.pick(pack, "ClimbAnim", "Climb"))
    M.setAnim(swimObj,      M.pick(pack, "Swim"))
    M.setAnim(swimIdleObj,  M.pick(pack, "SwimIdle") or M.pick(pack, "Swim"))

    if idleFolder then
        local a1 = M.pick(pack, "Animation1")
        local a2 = M.pick(pack, "Animation2")
        if a1 or a2 then
            M.ensureIdleSlots(idleFolder, 2)
            local id1 = a1 or a2
            local id2 = a2 or a1 or id1
            M.setAnim(idleFolder:FindFirstChild("Animation1"), id1)
            M.setAnim(idleFolder:FindFirstChild("Animation2"), id2)
        elseif pack.Idle and #pack.Idle > 0 then
            M.ensureIdleSlots(idleFolder, math.max(2, #pack.Idle))
            M.setAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
            M.setAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
            for i = 3, #pack.Idle do
                local a = idleFolder:FindFirstChild("Animation" .. i)
                if a then M.setAnim(a, pack.Idle[i]) end
            end
        end
    end

    animate.Disabled = true
    task.wait(0.06)
    animate.Disabled = false

    if hum then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Landed)
            task.wait(0.03)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    M.animPack = packName
    applyingAnim = false
    return true
end

-- ============================================================
-- PLAYER SPEED DISPLAY
-- ============================================================
function M.createPlayerSpeedGui(plr)
    if plr == player then return end
    if M.playerSpeedGuis[plr] then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("MoveePlayerSpeedBB")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "MoveePlayerSpeedBB"
    bb.Size = UDim2.new(0, 80, 0, 24)
    bb.StudsOffset = Vector3.new(0, 2.2, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = head
    bb.Parent = head
    local label = Instance.new("TextLabel", bb)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = "0"
    label.TextColor3 = CHERRY_ACCENT or Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    M.addShimmerToLabel(label, CHERRY_ACCENT or Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))
    local conn
    conn = char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            M.removePlayerSpeedGui(plr)
            if conn then conn:Disconnect() end
        end
    end)
    M.playerSpeedGuis[plr] = {gui = bb, label = label, conn = conn}
end

function M.removePlayerSpeedGui(plr)
    local data = M.playerSpeedGuis[plr]
    if data then
        if data.conn then data.conn:Disconnect() end
        if data.gui then data.gui:Destroy() end
        M.playerSpeedGuis[plr] = nil
    end
end

function M.updatePlayerSpeed(plr)
    if not M.showPlayerSpeeds then return end
    local data = M.playerSpeedGuis[plr]
    if not data then return end
    local char = plr.Character
    if not char then M.removePlayerSpeedGui(plr); return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local speed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
    data.label.Text = string.format("%.1f", speed)
end

function M.updateAllPlayerSpeeds()
    for plr, _ in pairs(M.playerSpeedGuis) do M.updatePlayerSpeed(plr) end
end

function M.startPlayerSpeedUpdates()
    if M.playerSpeedUpdateConn then return end
    M.playerSpeedUpdateConn = RunService.Heartbeat:Connect(function() M.updateAllPlayerSpeeds() end)
end

function M.stopPlayerSpeedUpdates()
    if M.playerSpeedUpdateConn then M.playerSpeedUpdateConn:Disconnect(); M.playerSpeedUpdateConn = nil end
end

function M.togglePlayerSpeeds(on)
    M.showPlayerSpeeds = on
    if on then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then M.createPlayerSpeedGui(plr) end
        end
        M.startPlayerSpeedUpdates()
    else
        for plr, _ in pairs(M.playerSpeedGuis) do M.removePlayerSpeedGui(plr) end
        M.stopPlayerSpeedUpdates()
    end
end

-- ============================================================
-- PLAYER ESP
-- ============================================================
function M.addESP(plr)
    if plr == player then return end
    if M.espList[plr] then M.removeESP(plr) end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    -- Large circular avatar billboard above enemy
    local avatarBB = Instance.new("BillboardGui")
    avatarBB.Name = "ZeyHubbEnemyAvatar"
    avatarBB.Size = UDim2.new(0, 90, 0, 90)
    avatarBB.StudsOffset = Vector3.new(0, 3.6, 0)
    avatarBB.AlwaysOnTop = true
    avatarBB.MaxDistance = 500
    avatarBB.Adornee = head
    avatarBB.Parent = head

    local ring = Instance.new("Frame")
    ring.Size = UDim2.new(1, 0, 1, 0)
    ring.BackgroundColor3 = Color3.fromRGB(210, 18, 18)
    ring.BorderSizePixel = 0
    ring.Parent = avatarBB
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
    do
        local st = Instance.new("UIStroke")
        st.Color = Color3.fromRGB(255, 255, 255)
        st.Thickness = 2
        st.Transparency = 0.15
        st.Parent = ring
    end

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, -8, 1, -8)
    img.Position = UDim2.new(0, 4, 0, 4)
    img.BackgroundTransparency = 1
    img.ScaleType = Enum.ScaleType.Crop
    img.Parent = ring
    Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)
    pcall(function()
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        end)
        if ok and content then
            img.Image = content
        else
            img.Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png", plr.UserId)
        end
    end)

    local nameBB = Instance.new("BillboardGui")
    nameBB.Size = UDim2.new(0, 140, 0, 22)
    nameBB.StudsOffset = Vector3.new(0, 5.4, 0)
    nameBB.AlwaysOnTop = true
    nameBB.Adornee = head
    nameBB.Parent = head
    local nameLbl = Instance.new("TextLabel", nameBB)
    nameLbl.Size = UDim2.new(1,0,1,0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = plr.DisplayName or plr.Name
    nameLbl.TextColor3 = Color3.fromRGB(255,255,255)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextScaled = true
    nameLbl.TextStrokeTransparency = 0
    nameLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)

    local highlight = Instance.new("Highlight")
    highlight.Adornee = char
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(220, 40, 40)
    highlight.FillColor = Color3.fromRGB(220, 40, 40)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char

    M.espList[plr] = {nameBB = nameBB, avatarBB = avatarBB, highlight = highlight}
end

function M.removeESP(plr)
    local data = M.espList[plr]
    if data then
        if data.nameBB then pcall(function() data.nameBB:Destroy() end) end
        if data.avatarBB then pcall(function() data.avatarBB:Destroy() end) end
        if data.highlight then pcall(function() data.highlight:Destroy() end) end
        M.espList[plr] = nil
    end
end

function M.clearESP()
    for plr, _ in pairs(M.espList) do M.removeESP(plr) end
end

function M.toggleESP(on)
    M.playerESPEnabled = on
    if on then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then M.addESP(plr) end
        end
        if not M._espPlayerAdded then
            M._espPlayerAdded = Players.PlayerAdded:Connect(function(p)
                if p ~= player and M.playerESPEnabled then
                    p.CharacterAdded:Connect(function()
                        task.wait(0.5)
                        M.addESP(p)
                    end)
                    if p.Character then task.wait(0.5); M.addESP(p) end
                end
            end)
            M.trackConn(M._espPlayerAdded)
        end
        if not M._espPlayerRemoved then
            M._espPlayerRemoved = Players.PlayerRemoving:Connect(function(p)
                M.removeESP(p)
            end)
            M.trackConn(M._espPlayerRemoved)
        end
    else
        M.clearESP()
        if M._espPlayerAdded then M._espPlayerAdded:Disconnect(); M._espPlayerAdded = nil end
        if M._espPlayerRemoved then M._espPlayerRemoved:Disconnect(); M._espPlayerRemoved = nil end
    end
end

-- ============================================================
-- OVER-HEAD INDICATOR
-- ============================================================
M.headIndicator = nil

function M.setupHeadIndicator(char)
    if not char then return end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 8)
    if not head then return end
    local old = head:FindFirstChild("MoveeHeadIndicator")
    if old then old:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = "MoveeHeadIndicator"
    bb.Size = UDim2.new(0, 180, 0, 58)
    bb.StudsOffset = Vector3.new(0, 3.8, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 200
    bb.LightInfluence = 0
    bb.ResetOnSpawn = false
    bb.Adornee = head
    bb.Parent = head

    local red = Color3.fromRGB(220, 40, 40)
    local black = Color3.fromRGB(0, 0, 0)

    local discordLbl = Instance.new("TextLabel")
    discordLbl.Name = "DiscordTag"
    discordLbl.Size = UDim2.new(1, 0, 0, 15)
    discordLbl.Position = UDim2.new(0, 0, 0, 0)
    discordLbl.BackgroundTransparency = 1
    discordLbl.Text = "FH2ONTOP"
    discordLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordLbl.Font = Enum.Font.GothamBold
    discordLbl.TextSize = 11
    discordLbl.TextScaled = false
    discordLbl.TextStrokeTransparency = 0
    discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    discordLbl.Parent = bb
    do
        local g = Instance.new("UIGradient")
        g.Name = "FH2ONTOPShimmer"
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(120, 120, 120)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(120, 120, 120)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        })
        g.Rotation = 0
        g.Parent = discordLbl
        task.spawn(function()
            local offset = -1
            while g and g.Parent do
                offset = offset + 0.025
                if offset > 1 then offset = -1 end
                pcall(function() g.Offset = Vector2.new(offset, 0) end)
                task.wait(0.035)
            end
        end)
    end

    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(0, 100, 0, 1)
    divider.Position = UDim2.new(0.5, -50, 0, 16)
    divider.BackgroundColor3 = red
    divider.BorderSizePixel = 0
    divider.Parent = bb
    Instance.new("UICorner", divider).CornerRadius = UDim.new(1, 0)

    local ragdollLbl = Instance.new("TextLabel")
    ragdollLbl.Name = "RagdollTimer"
    ragdollLbl.Size = UDim2.new(1, 0, 0, 12)
    ragdollLbl.Position = UDim2.new(0, 0, 0, 18)
    ragdollLbl.BackgroundTransparency = 1
    ragdollLbl.Text = ""
    ragdollLbl.TextColor3 = red
    ragdollLbl.Font = Enum.Font.GothamBold
    ragdollLbl.TextSize = 9
    ragdollLbl.TextScaled = false
    ragdollLbl.TextStrokeTransparency = 0
    ragdollLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    ragdollLbl.Parent = bb

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Name = "Speed"
    speedLbl.Size = UDim2.new(1, 0, 0, 25)
    speedLbl.Position = UDim2.new(0, 0, 0, 31)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "0.0"
    speedLbl.TextColor3 = Color3.fromRGB(0, 0, 0)
    speedLbl.Font = Enum.Font.GothamBlack
    speedLbl.TextSize = 18
    speedLbl.TextScaled = false
    speedLbl.TextStrokeTransparency = 1
    speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLbl.Parent = bb

    M.headIndicator = {bb = bb, discord = discordLbl, speed = speedLbl, ragdollTimer = ragdollLbl, divider = divider}
    pcall(M.updateHeadTheme)
end

function M.updateHeadTheme()
    if not M.headIndicator then return end
    local red = Color3.fromRGB(220, 40, 40)
    local black = Color3.fromRGB(0, 0, 0)
    if M.headIndicator.discord then
        M.headIndicator.discord.TextColor3 = Color3.fromRGB(255, 255, 255)
        local g = M.headIndicator.discord:FindFirstChild("HalfBlackRed")
        if not g then
            g = Instance.new("UIGradient")
            g.Name = "HalfBlackRed"
            g.Parent = M.headIndicator.discord
        end
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, black),
            ColorSequenceKeypoint.new(0.5, black),
            ColorSequenceKeypoint.new(0.5, red),
            ColorSequenceKeypoint.new(1, red),
        })
        g.Rotation = 0
    end
    if M.headIndicator.speed then
        M.headIndicator.speed.TextColor3 = Color3.fromRGB(0, 0, 0)
        M.headIndicator.speed.TextStrokeTransparency = 1
        M.headIndicator.speed.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    end
    if M.headIndicator.ragdollTimer then
        M.headIndicator.ragdollTimer.TextColor3 = red
    end
    if M.headIndicator.divider then
        M.headIndicator.divider.BackgroundColor3 = red
    end
end

local speedUpdateConn = nil
function M.startHeadSpeedUpdates()
    if speedUpdateConn then return end
    local _headAcc = 0
    speedUpdateConn = RunService.Heartbeat:Connect(function(dt)
        _headAcc = _headAcc + (dt or 0.016)
        if _headAcc < 0.12 then return end
        _headAcc = 0
        local char = player.Character
        if char and M.headIndicator and M.headIndicator.speed then
            local displaySpeed
            if M.autoLeftEnabled or M.autoRightEnabled then
                displaySpeed = M.NS
            else
                displaySpeed = M.getActiveMoveSpeed()
            end
            if type(displaySpeed) ~= "number" then displaySpeed = 0 end
            M.headIndicator.speed.Text = string.format("%.1f", displaySpeed)
            if M.headIndicator.discord and M.headIndicator.discord.Text == "" then
                M.headIndicator.discord.Text = "FH2ONTOP"
            end
        end
    end)
end

function M.stopHeadSpeedUpdates()
    if speedUpdateConn then
        speedUpdateConn:Disconnect()
        speedUpdateConn = nil
    end
end

-- ============================================================
-- ZeyHubb STATUS UI (Steal Bar)
-- ============================================================

-- Steal bar green splash background (from reference HUD)
local function _zeyhubbB64decode(data)
    local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = data:gsub("[^"..b.."=]", "")
    return (data:gsub(".", function(x)
        if x == "=" then return "" end
        local r, f = "", (b:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2^i - f % 2^(i - 1) > 0 and "1" or "0") end
        return r
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if #x ~= 8 then return "" end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i, i) == "1" and 2^(8 - i) or 0) end
        return string.char(c)
    end))
end

-- ============================================================
-- ZEYHUBB EYE IMAGE (local asset used for the main UI, buttons,
-- and Auto Steal bar). The image is embedded so no Roblox asset
-- upload is required.
-- ============================================================
local ZEYHUBB_UI_IMAGE_FILE = "ZeyHubb_Eye_UI.jpg"
local ZEYHUBB_UI_IMAGE_B64 = [[/9j/4QAiRXhpZgAATU0AKgAAAAgAAQESAAMAAAABAAEAAAAAAAD/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+/+ICKElDQ19QUk9GSUxFAAEBAAACGGFwcGwEAAAAbW50clJHQiBYWVogB+YAAQABAAAAAAAAYWNzcEFQUEwAAAAAQVBQTAAAAAAAAAAAAAAAAAAAAAAAAPbWAAEAAAAA0y1hcHBsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKZGVzYwAAAPwAAAAwY3BydAAAASwAAABQd3RwdAAAAXwAAAAUclhZWgAAAZAAAAAUZ1hZWgAAAaQAAAAUYlhZWgAAAbgAAAAUclRSQwAAAcwAAAAgY2hhZAAAAewAAAAsYlRSQwAAAcwAAAAgZ1RSQwAAAcwAAAAgbWx1YwAAAAAAAAABAAAADGVuVVMAAAAUAAAAHABEAGkAcwBwAGwAYQB5ACAAUAAzbWx1YwAAAAAAAAABAAAADGVuVVMAAAA0AAAAHABDAG8AcAB5AHIAaQBnAGgAdAAgAEEAcABwAGwAZQAgAEkAbgBjAC4ALAAgADIAMAAyADJYWVogAAAAAAAA9tUAAQAAAADTLFhZWiAAAAAAAACD3wAAPb////+7WFlaIAAAAAAAAEq/AACxNwAACrlYWVogAAAAAAAAKDgAABELAADIuXBhcmEAAAAAAAMAAAACZmYAAPKnAAANWQAAE9AAAApbc2YzMgAAAAAAAQxCAAAF3v//8yYAAAeTAAD9kP//+6L///2jAAAD3AAAwG7/wAARCASwBLADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9sAQwADAwMDAwMEAwMEBgQEBAYIBgYGBggKCAgICAgKDQoKCgoKCg0NDQ0NDQ0NDw8PDw8PEhISEhIUFBQUFBQUFBQU/9sAQwEDAwMFBQUJBQUJFQ4MDhUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUV/90ABABL/9oADAMBAAIRAxEAPwD87rHT5rybYn/Aq9w8L+AdVS8stS0eRluoJlff9K67w78JbzRtS/0xlnil/uLX0x4b0X7GipDAq/8AxNf2vnHEeFwFD9zrfe5+FZtxTLE1VQwbunu7aHVaTcXl3psD36+XcbfmWm311DbQ73b5qg1DVIdPh/h3V4n4m8YIiM7yV/L2b5q8RUcaS37H1OR5G4wUqj0NXxN4qSBG86Taq18hfEDUNN1fW/7SsP8AWyrtnf8Av7fut+VX/FXjB9TdoU+7XmkjbK9rIcqnQl7Sb1fQ+oxWIXw01oh1G7bVPzKimuvKSvpqsb/DqccaEmSXFxWJNJ5tIzPL9+lrtwuC2bPTpUFD1G06nrHUvl7K93D4XXljuynMRd7/ACVctbV5XVNu6p7Ozmu5lhhX5mr3jwj4HbfH+78+eSvvcrySnSgq9bY8LN86p4OF5vV9DA8M+BYdQh8m8VvNl+5/s1+iHwV0nW9I8JW2m63t/wBG+SHjB8v+HctYfw7+GMOjwx3+pRr9q/hX+5/9lXvdnZ+QvyV8FxrxNTxX+z0loup8JQxWIxNXmqPTdIvxrWnGv3ajhhrRWGvyerVPfhTHrVhVoVasqtcE6h1xiCrUtCrT9tc0jYfSLS7aKgkKsUxY6kWpNRdtPWkWpKxkXEdUirsqGpFasiiSimbqPMoLH0zdTGam7qIljmbfTGpu6mVfsyJD91FItSKtO5kR7TUdS3VxZ6ZD9p1K5S0g/vzNtX/gO77305ryzxB8ZPD2lebDpUDXs/8AecNHF/8AFt+S/WnSvOXLBXZ1UMHUnsrHqHkyfx1xOtfELwr4efyXu/tt1/zwtv3h/wCBN91fzNfLXij4saxrm6G81Tbb/wDPvD8qf98r97/x6uQ0NvEnii8bTfBOkPqF1/HcufLtbf8A67Tf+y/er6PC8OV5R9piPdiurJxGY4fCy5L3n2R9Gap8UNbuYWvLm7t/D+kW33/mXft/6aTSfKv/AAGvmPxl8Jf+FyeJLLxV8MdJTTbiB/Pm1uaL7LYXcitu3f3pm3/8tFi/76r6Z8J/AXTYJoNY8f3f/CUapF86JMm2yt/+uNt91v8AffdX0DHbxxJsSo+v0MI/9lV/Nnm1cfXr2exl+E7fW7PQdPtvEMlvPq8Vui3b2wZYXm2/M0atyq5rqqqxrVqvmqk+ZuRVKHLHlBadRRUHShtFOoqRkVFPoqjYKZT6KAGUyn0ygAooptWZykFFOooJG0UU6gCFmqOpWplNANplS7TUVaAFFPpjLVgFMoooAbRRRVgQtUTVI1JVEkDU/aaWigoTaakplFAEtFNVqdQAU1mp1RUAFMoairiA2mUbqYzVqAjNSUUVYBTGopm6gkKfTKN1OwD6KZRVE3H0m402igmUh240bjS1IsLvWbnFER1IKbWgtm/95V/4EtQTfYLb57y7hjX/AGmrKeLpx+JnQsLOeyK1Kqu/8NY15428Gafu36gs7L/Cn+cVyl98XtHtv+PO2X/ed6y+v83wptmqyqp1R6T5M1SLZ3L/AMNfNmsftIaPY7vO1u0sv9lNrN/7Ma8c179q6zR/Js57vUP9xfLH/fTV6ODwGPxD5aVNv5Gn9mwj8Uj78a1ZE+eVIv8AedRWVcat4e0//j81KH/gPNfmpeftEeJNX3fYNGf/AHppW3VHpupfGnxpNs03T7ja39xGx/301e/R4Kx9m67UF56GVXFYLD9bvsfoRffE7wLY/cnedv8AZj/9mauK1L45WFt/yDbJN3/TaX/2Va+eNN+B/wAV9V2/2rqltpu7++/mv/3zH/jXo+k/s06P5m/xJrt/qX+xDtgT/wBmal/YeW0P4tVyfZbHH/rHP/l1DTzKPib40a3rNt9mm1m2023k/ghCrv8A9nd8zV5DceCf+E4/5BWl3d8y/wDLaFGER/3mb5a+y9D+Gvgbwvt/sfQrSOVf+W7r503/AH1JuNdn89ehgM/hgv8Ac4W82eJi41cW1KpK3ofJ/gf4J+J9Dma58+30v/efzX/75X5fl/3q+jPD+l6xpULJquttq393dBHCE/3dvLV0dMVa8zMs2r4yfPXd/kXhcHCjtq/MsUUyn15J3xiMam0rNUbNVRKCo2pd1NqwGUyntTK1JlIbVepGao6uJiMoopjVqSFNahmqFpKqMSiOWkoaomkraJlIKYzbKrtJUTTbf71bezMrl3dTZGqGPzpf9SrN/uqx/wDrVba1eD57yRIP991H/jvWuWtjKVL42kbU8PUq+7BMptUflu1UtQ8WeEtK/wCPzUk3f7Az/wChV5b4i/aK8AaAjJ56bv8Abf5v++f/AK1eRX4lpR0pq7PUw/DOIq6y0XmewSWron77b/vM1U5vscSfPdr/AOgj/vpq+JvFH7Xlt8yaDZTXbf3v9Sn/AI9uf+VeAeIP2gPiLrm7ybuHS1b/AJ9kzJ/wKSTc38q5frWZ4n+FHlXdnsUOHKMP4krvsfqHdeIPD1jD51zOir/fY/J/303FeWa9+0L8NPD3mf8AE0S5lX+CD97/AOg8frX5dalrWvav++1XUrm9/wCu0rN/6FWSsddWF4axVX3q9S56McJQjH3FY+0/F37U1hqPmw6JpFw27cu+Z1j/APHV3V8jtqUlzeS3k33pWLN+NZix1KsL19xleVQw8DH2dNX8y75lHnVXWN6ctu9ezCkY2j3CSTfQsdXY4UWrCx11ESr2+Eprb1Zjjq2q1KtTKRyTr8xCq1JRtp22oMrjadTaKCT/0PT1hT7j/NWXrWvWemQ7Eb5ttYmueIE09GhT71fPfi7xgke7e3zc19lisyr42ahB6HweUcPU8J79RWRt+KPHHlbv3tfPGueJJtQeT5qw9W1i5vpmfd8tc60mxK+myvJoUFd6tnqVcTKXux2HTTVTkuKozXW+qjSO9fSLDsulhf5idrp/+WdQbt/36SnKtenQwp1aIFWpvLqeOOn7v7levhcLOrLkgrmcpkUdbOn6Xc6hMsMK/wD1qsaPotzqc3k2y/73+zX0n4D8B3N3NBZ6bBub5dzf/FV+g4XLKGDp+1r9O58znefQwsPd1b6GP4J8A/aXtraztmkuZMfNX3N4F+HNn4cto5rhVlvf733tn+7Wx4H8B2HhizX5VkvWX53/APZVr0+G3r8p4q4wlipOlSdor8T4qjhamIn7fEO7ey7FeG3rVjhqaO3q0sdfm1Wvc+loULCxx1aWOiNamVa4J1DtjEFjqxtpsdT7TXPKRpYNpp+2nqtS1jKRoV1WpttSbTS1FwGbadtNSUUrgIq0+iisWXEKbTqi3VcYjuPoplFOwuawUU5V31ZjtXeplKKF7X+Uqbaljt6y9a8SeHvC6f8AE1u91x/DbW/7yb/vlfur7nFeKeKPjR5FtLN9rt9A02P7z7189v8Atp91f+A/NWMaznLkpq7PWw+U163vPRd2e36prWiaDtTUrlVnb7kCfvJj/wBs15/Hge9eU+Jvi1/Z1tI8Pk6XAv8Ay2meNpf++m/dL/49Xxx4k+Ok0/mWfgm08zzfv393u+fP8Sq3zyf8D+WvNY7PxJ4vvIvt7XOqXX8Cf6w/7qr/AA19zk/AGNxCVfE+5DzOHH5zgMvur88j1jxZ8aJtQuf+Jb52pT/897h2/wDHWb5/++dlcfoej+NvHF59ms4p7n/pjb/LGmf77dv+Bsa94+H/AOza0/kal42/cRfe+xW7/O3/AF2mX7v+6lfXej6HpWh2cVho9pDaQQfdSNNq/wD2X1617OIzfL8r/d4CKlJbt7HyuKzLG4/ryx7I+cPCP7OtnF5dz4tn8/8A6c7c4i/3Wk+83/AcV9LaTo+m6HYQabpVpDaWsC/JDCiqg/4CuK1FWpFWvhswzevi53qyv5dDowWWQpbfeM21JGtSU+vJkeqoAtPooqDojEdT6ZuNG41JdgoptFUJhRRTKCR9MoooKuG2jbRRQFxlItLRVkj6Y1PplABRRSM1AEbUyntTKqMQCm0UVYBTKfUe41YDaKRmqPdVgPplMo3GqARqSimbqLEj6ZRuoqrFBRTNxpu6nYCXdT91QeZTGkp2Am3Gms1V91G6q9mA9mpm402k3GtIxM7i0Uyn7aYe1I9xpu6pvJf+7U8en3Mv/LNvyxUurCPxMqN3oldlLdTWovLjStP/AOQlqlpbf70q5/75WsCbxt4Mtv8AmIPd/wDXCNsf99NgVzSx9NdTqpYCrLodDtNOWN3rzjUvi1oNpCzw2iqq/wAc8ir/APY/rXlesftKaDY7v9NtI/8Arhum/wDQeP1qKWKqVfgg2b/2XP7bsfUa2c392la3hi+/PGv418Bax+1R5v8AyD1uLn/ac+WP++a8u1b9ozXrnd/pPkf7Cbq7ll2Pn9mw44Kkt5H6f3GraJZ/Pc3qL+Ncnf8AxO8Gadu/f+Y3++tflXffFrXtR/idv9564vUvG2t3H/L8sFelh+EsfXfKdK+qw+FH6l6p8ftBs/8Aj28iNf70z15TrX7UVsn/AB7y/af+uH3K/OKa8ubz55p5r2Wtaz0PxJqCf6HB5a19jhfC6c7e1nY56uZUqXvWS83ofWusftJa3c7v9J+zRV5dqXx8mf8A5+b1vrhK5jw/8G9e17bviuJ/+uYr6C8K/sw6rKi/aLaGyX+/Odz16kuDMlwf+9T/ABPGrcYU9qer7LY+dLj4tePNQ+TSoPs27+LHmNVOHRfiF4nf/iZahct5n8Gf/ZVr9EPD/wCzv4P0fa9/I97L/wABVK9g0vwr4e0VFTTdPhi2+yk/99VX+sGUYP8A3Wld92eZWzvG1/hVl3e5+cXhf9m3xPqu2aGxdVb/AJbXHyr/AI19C+G/2U9Ki2zeIb3zf+mNuNv/AI91r66P+x8tO3GvDx/HGOq+7C0F5HP9Uqz96pNt/cecaD8Ifh74a2/YNGhaVf47j96f/Hs16GqpAnkwqqr/AHV4FOor5Wviq1XWq235s2jgIR6Bup9MornOhQJt1MpNxo3R0DsNopvmUjNVFD6Ki3VGzUWHcGak3UxmqPzK2jEi5JuoZqg8yms1VYVybcaYzVFupjNV2AfTaZVfdWkYkD2kqFpKazVFJIkH/H0yxL/tcU3VhD42VClOXwokambTVG41iwtk3/NL+Kx/+hf4VymsfETStHtmury7ttLt1/jndVX/AL6l+9/wFa4KubUo6R1fkejSyarPpY7xbeZv93+83A/76bio5FsIo2ea7T/gHP8A490r5B8VftReDLHzPsE9zrs//TGLCf8Afyb/ANlSvnfxJ+0h4s1X/kG2kGmwf7W6Z/8Ax7/4muf2+Prfwo2XdnpwyenH43c/RjUvG3hvTd37xJNv+2p/rj9a8q1z9obwxo/3J7fcv90LI/8An8a/N7UvEHiTxC/2rUr24n/33+Qf8Brn7q8hi/5b+e351f8AZVSVvbzv5I7aVGlH3aaPtvxN+11cp+50rfJ/46v/AI7XgPiD9oTxhrG7ydsG7+9zXhMk3m/8sqhr0KHD2HfS/qd8JWOo1Dxt4q1Xd9p1Sba38KHb/wCg1zLb5X3yNub/AGuaXy6Xy6+gwuTU6XwRSHKr/M7kdPqVYanW3r2IYP8AmOd1YorKu+rS29Tx29W1jrrjQictWv8AyleO3q0sdSbamrQ451ZSGKtS7aKfQYSkG2n0UUECrS02iggdRTaKBWHUU3dTqn2gz//R+d9U+Kmm61YNNCu29/uV4rqGrXN5M00zbt1c/u2PvT5abJNX7Thcqp0PgR8xXrVKtlJ6E801Y1xNvptxNvqvXtUMN9o0oUeX3htOp/l0/bXqQpcp0+0I1WrEcdKtWNu9K7aVLmajHqYTqDFauk0PQbrU5vkXbF/E1WtF8NzXe2ab/VV7/wCCdDheaPevlWu4V+g5b7DBw55LU+Sz3PoYaD9nqzq/h38M7nV5o4bODyLKLG+bbxX2p4X8I6V4cs1hsIvm/if+JzVfwnDZ22mxQ2CrHEq/5Zq7iGOvx/ibiOvjKjTdkuh8jl+F9rL2tR3b/As28NascdRQx1oRx76/P69U+ooUrCKtWFWnqtS7TXHKZ2RiMjWp41ojqdVrGbNRVWp1WmKtTquyueUix1FPoWoLjEKKdTagdh1FNopWGOo3Gm7qKZPNYKNtSLHvqysOz5/++v8AZrKc7dTPV7K7Knk76tQ2bvXCaz8RNK0/dbaDbf25er/zxdVtYm/6aXP3f+Ax7mr5v+JnxqsNMhkh8Z+Ik/7A+k7v++W2/vG/4Gy/SsIVZ1aip0k232PYw+TzlHnqOyPpjXPiJ4S8PPJbef8A2pfx/wDLtabZNn+9J9xfxNeJeMPjFrH2OWa5voPDOl/9df3j/wDbb/4ivh7XPjpr2q/6H4P0+HSLVvuTMFkm/wC+f9Wv61xsOi6lr159v1q7m1C4b+O4fdX6DlPhpi8V7+KlyozxWfYPAR9xXaPXPEXxq8/zbPwfafbZZP8Al/uVaOH/AHtv35K86/svWNev1vNeubjV7qT/AFK4+RP9mOFfu17v8P8A4C694l8u88r+zdO/5+ZU+/8A9c4/4v0r7N8G/C3wr4M2vYW32m/27Wu5/mk/4D2X/gNfUfXcnyP3MNHnn1Z8Xj+IcdmfuQ92J8p+A/2eda1ry7/xD/xJrBv4Nv8ApL/8B/h/zxX2J4V8B+GfCFt9m0eyWNv47hvmmf8A3m612irTq+DznibF4+X712XRLQMJk8IavV92MWNKmVaZUkVfNM9qFKKHKuynUUUjewU+mUUGkYj6fTKKgY+iimUFXH0yijdQSFFI1NoAfRTKfVgMop2003caACims1R7jRYCam7qj3GlosA7cabUW6jdV2AdTaZ5lRtJWkYgSUm41AzVGzVfIBK0lNao91M3VdgJabuqHdTfMqoxJJ9xpu6ot1RtJV8gE26iq+40bjVWJuTK1O3VW+//AA1L5clKQvaCM1MqVYXf+Gp/svlfPcMsC/3nZVX/AL6aodaEfiZpCMpbIp02s+88UeFdO+S51RJG/uwfvD/8T+tcvffFLwrbf8e0Fxc/7xVf/Qc1yTzWjDS+p6FLKsRLZfedxTljdvuV4dq3xwSzT9zBaWS/35mz/wChN/SvIta/aSs4NyP4gVv9m2X/AOJ4pQxtSr/Dgzolk01/Ekj7T+zzJ99dtZd1qWlWP/H/AKhbW3+/Kv8A6CvP6V+dGsftFPc/6lru5X/aKrXm2ofG7WJf+POyhi/25C0h/wDZRXo4fLcfX+GNvUy+qYWHxyP07uPiF4Nsd2+5mvf+uEfH/fTbRXMX3xosLNG/s3S0j/27uRj/AOOr8tflnqHxK8bX3/MSaBf7sKqv/oNcndalqup/8f8AezT/AO87H/0I168eD8VU/iTt6FfWsJS+CNz9Jte/aOmg3JNr9pZf7FttD/8Aju5q8Z1r9oTTZ/v6hqOof99f+1K+M1t0/g+9T9u3+KvSwvA9L7crmc866QVj6D1D48P/AMw3S/8AwJkz+kdcXqXxg8bah8n2tbRf+mCKv/j33q8wa4SL/lon8qkjk8//AI9raWf/AID8n/fTV9HhODaf2IHFVzCvLyReuta1i+dnvLma5l/vO7Mf/HqyZPtku7e1dDb6Lrdz/DDZf+PPXofhn4L694lb/RtLv9U/29rLD/303FfXUshp4aHPVaivM8urmtOHxyu/LU8KZtnyeZub/Y+ataz0HW77/jz01/8AtrxX3d4X/Zd1KLy5L6S00n/YQedJ/wB9fdr3jQfgb4A0hP8AT459UlX/AJ7PtT/vla4q/EeU4XZub8jinnNWX8Cn82flza/D3W7x1S5k/wC2NurM3/jte1eFf2Z/E+r+XN/ZbxxSf8trs+X/AOO9a/Six0Pw9pSKmm6fBbKv3dkaj/x7rWxJM9ePiPEWp8OFpKPmzG+MrfFKy7I+SvC/7Lum2KK+sX3zf3LZP/Zmr2jSfhb4J0ZV8nTVklX+Ob5mr0dld/4qjZa+UxfEONxP8So/RFQyqnvPV+epVt7e2s02WcCQL/sLirHmP/foorx5a/EdsMOo7IKFoopl2JVp9VtxpazsUWKY3yUzcaY0lFiyRmqPcajaSo2krSMSCVmpdxqq0lR7jWnISXN1N8yqTNR89V7Mgs+ZTGmpnlzf3KkWzuX/AIW/Ks5Vacd3Yv2U38KuQeduqPzKdcLZ23/H5qFtbf78qg/988msO48VeDLP93NqTy/9cIs/+hYrCrmmHj1+46oZXiJfDE191O+evO9S+MngPRf+Wbs3/TzcRQr/AN8/erxzXP2qtNtnZLCWytl/6YhpX/76+f8A9lqY5lzfw4NnTHJan23Y+rvs82ze67V/vN8oqjNcW0H+uk+X+9/D/wB9NgV+fOtftSX88zfZ7a4u/wDaZ/L/APi3/wDQa8y1T9obxtcu0lnstP8AdG4/99Nz/Kt4YfG1No2T7nVDK6S+N3Z+n02uaVF9+fb/AMBaT/0Hiuf1D4ieFdKh/fXP3f7/AO7/AM/nX5S3nxS+JGq/8fOv3K/7jtH/AOg1x95dalqf/H/ez3Lf7crN/wChV0/2Bjanxzt6HVDD4WHS7P0b8TftJeFbHdDbXsMX+4/mf+Ox72/8eFeFa5+1A++VNKtJr3/a+W2T/wBnk/lXyetqip/8TT1jtoP7q/jn/wCt+tL/AFcwsf4s7s644z+SJ6lrHxw+Iur7vs9ymjRN/wA+y/vP+/0m568xuPt+pTNfaxevdyt/y2uHaR/++mqpNqlsn/Tdv/Hf8/nWPNeXlz/F/n/2Wu2jCnD3MPAr95P4tDd8uztP300+3/d5eq0mtJF/x4W3/A5uawlhqdYa9Gllder8eg+SEfMJrq5uf9dIzf8AoP8A3zUCx1e8tE/hpVWvToZVCI/aldYauLbpR5dXVWuz2UIfAjmq1StS+XvqVlp611mXtCPy9lSKtSbafQYSmNVasLDSR1YrKoYTYxY6k8unU6s+fzMZSI/Lp22nUVPtfMm43bRto3UbqvnkANTV+ekb56YrbKvn08yyRvkpKi8zfRWftfMdiXbTtxqLdTd1YOqFj//S/OlpEqhJNUHmSVJHbvX9FKhy/Gz52NJR3Y9YfNqRbfbViNdvyVJVxlYzlVZSkXZTKsTLvqJo67KT0RUZDK1NPmhiuY/tP+q3fNWZGtWPLr0MPfmXJuKrZprufRej6Wn2aOZNrRMu5fpXe6beJZp5afe47bs/7q14l4B168lT+wf9Z/zxdv4P972r33RdN8hI/vT3Tf7P/jq19HHCVEueo7XPxPiWi8PUcKjv28z65+HazT6DbXM33pP4erD/AHtteq28b15t8OdD1XSNK/4mvytP86Q94x/tN6tXqMdfiOcVU68uV3V9z6TI4P2Eeda9i9CtWYqrq1WFr5+ofR0ywtSVEtSrXNI3LEdSqtNWpVrnkVGI5amqKnbqzZTJdxo3Got1G6psaE26mUzdRRYzuPopyrVmG1eWoc4oe+kVdldVqzHD/wCO/e/2a43XPHmj6MzWemr/AGzqS/wW5xGn/XSb/wCJr5b+Jnx20rSN0PiHVP7Quv8AoE6b/q0/66f/AGZ/CvOnjeZ8lJXb7HrYXI6klzVHZH1Lq3jzR9O3W2lL/a11/sNtgT/fm/8AiN1fL/xK+PXh7TvMtvEOqf2lP/0CLDiD/tp/e/7aH/gFfFfjD44eM/FXm2FvL/Y2l/8APvaFlf8A4FJ1/wDQa800/R7nUX+SN5G/2v8A4qvt8h8PcXjbVMU7Lt3OqtmODwEPc1a6s9k8VfHjxn4q8yz01v7C0v8A597L5X2f3Wk/+J215vp+i3Orzed5e7/ab+Ku38P+A03L9pXzGb+Bf8819gfDv9n+/u/Lv/EC/wBm2Xy7Yf8Alu4/9prX61QwWVZBS55WT/Fn5tmvFNXF1HCjq/uSPnTwX8L9S165ittNtPPuG/JP95v4a+4Ph78C9B8NeRf63s1K/X2/cxt/sr/Ea9k0XQdH8PWa2Gj2iW1uv90fMf8AaZurVsV+d59xxisbenS92HZbs5cFkcpP2mId327C/wC591adtop1fCH08KNvhH0UyjcaVjp5Ap2403dRSLjEmWnU1alqCxlFO3R0bo6AG1NUe6OofMoAnpm6o/MpN1FgJd1LuWq26jdRYCzuWk8yq+6jdVcgE26jdUO6jdTsWS7jTWqDzKj8ynyEFjcabuqv5lMZqvkAseZTGkqvuo3Gr5AJvOpm6q/mUzzK09mTctM1R7qrtJUe7fVKBNyzupjNUVP8uSny2F7QPMqNmqRbd3/hZqWSFIP+PmRLb/rq6r/6FSlVhHdmkbv4UQbqbVC617w9Y/6698z/AK4ozVhXXxC8PQf8e1s8/wDvvtX/AMdrkeZUY9bnXSyvES6WXmdY1Ksbv9xa8f1j42W2mRtsW0tv9/8A+yavJda/ae02L/Xa6v8AuWw3f+i6I42pP3acGzp/sSa+OSPsGa1eBN9yyQf77qv/AKFWJceIPD1ju87UFkb+7D81fnlr37TFtL/yDba5vZf79w/lr/7Ma8h1j45eNtT3fZvs2nr/ALEfmP8A99Sf4V6WHynH1/hjZeY/quEh8crs/Ue8+KXh62T/AEa2aT/eK/8AstcLqXx602x3fNZwN/cd8tX5X33i7xVqf/H/AKpPPu/vP/8AE1z0klzL99mavaocG1pfxJ/cEMXh4/DE/R3XP2oEi3JDrcMH+zbr/wDE14nrn7QX2x9/m3OoN/tcL/49XyXHapv8ytCOPb9xa9OhwVhV8Wo6vEEo/wANJHr198ZvFU//AB5xQ2i/9/H/APHq4zUPHHirU/8Aj51af/gLsv8A6DXMtUTNClezhchwtL4IHkVc3xFX4mPuLi8ufnmkaRv7zHNV9z/xrS+Yn8DVBJeQp99q9ullz/5dxMPaTkT7f4qftjrJ+1PO+yFWatO10XWNQm8mGBlr2aGQ15e9ayFOKjrN29RPOi/v1UmukR1RN0jf7PzV694f+CfiHXPuWlzet/0xTan/AH1X0N4T/Zf15/nvPs2jRf8Af2T/AL5X/GtMRDA4XXEVVfseZLNaH/LtOT8tj4stdP1i5/1MHkf9dzt/8drfsfAusarN5P767b+5bI3/ALLuNfpjo/wB8B6Ui/b431mVf+fj5U/75WvWdL0XR9Dh8nR7KCyX+7bxrH/6DXgYjjPBUv8AdqTb7vYzWNxU/gikvxPzl8K/s1+M9TRZk0T7Cv8Az2v3WP8A8d+Z6+gvDv7LNhBtfxJrbyf9MbBPLX/v5Jz+lfVfmSU3c9fO43jbMKvuQkoryD6u561G2ziPD/wx+HvhhF/srQoGuF/5b3a+fJ/31JXd+Z+7VEXav91ei0zaaWvlK9epVlz1JNvuzopYeEeg1md6VVqVVpfuVidIxVo8yn1FVFhuplFFBAU/dUNFWAUbqetu7fcVqmWxm/55t/Ks51YR+JlxhJ/CrlTdUbSVfks/s6b7meG0X+9PIsYrBvPEHg/Tv+PzW7eT/ZgSSX/x4cVzf2hQj1OmGAry+BXLvmVHu31xt58TPCsG5LC0u7tv7zssQ/75+c1xGqfGq207d5zWGlxf9N5F3f8Ajzf0ojmSl8CbOmOT1finoe3LG7fc+anfY5v4/l/3jt/9Cr421j9p7wzFuh/t2a7/ANiyjkZf/Hdi15lrH7UUb/8AIN0u5uf+u8qr/wDF10xjjZ/BSt6m8crpr45H6FzSWFt/x831tB/vyrWTdeJvB9j882qef/s28bN/4822vzG1D9ojxZef8e2m2dt/vNJL/wCzLXCap8VPH+pyN/xNPs27/n2jjj/8e61pHJsynu0kdEcLhI/FqfqfdfFDw9Fu+wWM0+3+O4dVH/fK7v515vrn7Qmj6Vu87VNNsv8AcZZX/wC+f3hr8xLzWNY1L/kJalc3f/XaRmrLWNIv4a7YcJVJfxKt/JF89GHwRPvTWP2tIU+SwudRvf8Ac/cx/wDj3+FeZ6p+1V4kudyQ2LfN/wA9p2b/AMd6V8rsv9xaasf9+vTpcKYSO6v6l/X39nQ9d1D45eNtR/49vJtl/wB1jXH6h408Yan8lxqk23+6jeWv/jtckskKVMrV20snw9L4IoyrYqrIkmkml/1zNK395uajWOhW3P8AIu6p5JPI/wBcyx/jWspwh7sdDk98TyaasKJ/DWdJqkMX+p/f/wDjq1Tk1C8n+423/crGFWb+BHRHC1Jb6I6CaSGKs6S+h/jb/gKVkLZzS1YW3hi+/uatfqtWfu3sjaGHpx63YTapNKnkwr5a/nVJo5JP9czNWksafwR7af5da0crox+PU3+sW+FFKG3h/jo8urnlpS7a9elBR+BWRl7YrLDT/LSrO2m+XVmftfMj20nl1Z8l6btoFzjFWrCslMp9TKPMZS1Ciin7aokKcq0m16nWolIzlII1qWmU+ueUjMKlqvT6xlIzsS7jTd1R7jULNUxkNQJ91Rbqh3UbjV8/mbezJt1Maq0kmz79VJLtP4GouawoNmjuNJ5lY/2r3pjXTvRI3+qs2vMpn2hP71YfmPSban2c38KNfqse5//T/ONo4YvuLVf7R71G11VWv6Dw8G/jPn4Uv5jSWbfVjdWVHVmKvRjh/MidIuUbaasmynTN8i12YfCyk1FdTH7Q2OTynrUsbG81e5W2s4/vVBpumvfXKwp/FX054F8DvfPHYaVB5kstfoGFyilhKftsRoeJnecwwcO7exT8C+C3WaCz02Brm6nx91fmavuzwP8ADuz8PQx3mpbbnUf/AByL/d/2qteB/AOm+ELZflWS/kUedN/7KvtXo9flXFHFc8ZN06OkPzPg6GEniKvtsRq3suxJDHWhGtVoY60reF3r88qzPqcOiSNanVaoa1q2j+GraO51qfyvtPyW1uiNJPcP/chiXlv85rzrXrqbWNKu7/xbqH/CN+H4E33Folx5L+X/ANPt0v8A6JhP/A3rjUnP4Voekqdvi0PXlWpq8u8I+JPE/i6/g1KzsU0jwlB9x7+OQXupfL+7khh/5d4P9qb94/oteo1zyunyyKLC0q1ArVNWUomiJaGplG41IpD6KTaatW9nNL/DWU6qirt2H8XuxWpWX56uQ27vXNa9408MeGP9GvLn7Xer/wAulsvmSf8AAtv3a8D8cfHK5s7OR7m7h8O2H9xH3Tv/AMC/+IrzZ5knpTV2z08LlNaes9F5n0brniLR/DKf6ZP5t1/Dbpy7f7390V8z/Er43abpNm3/AAkOpJY2s/8AqdOtj++l/wB/u3/jq18a+Mvj9qV27W3hW2+zRS/fu5/mm/3lX/4qvny6uJtVvJby8u3u7qT77u+5v/Hq+mybgnHZl79X3Yfiz0fa4TA/Arvv2PbfGnx08VeJYZdN0T/iTaX/AHE/1zp/tN/DXjX2d53+8zS/41p2ekzXO2vZfA/w9v8AXLmOz020e7nl/ujP/wCqv2jI+DMFlkPatJJbtnxmecVze7v2SPP9F8J+e8T3K7v9mvpP4f8Awh17xU6/YLT7NZfx3MwxEv8Au/3jX0r4B/Z90rSkiv8Axbtu51+ZbZG/cp/vN/FX0bHDDZwrbW0axxRLtVVXaAB/CqrXhZ/4iwhehl6+bPkVgMRjZc9Z2XY828D/AAp8N+CUWaGL7bf/APPzMPu/7q9Fr0tmpaZX5NisVUxFR1Ksm2+rPqcLgKdCCUFoFOWm0+sT0owQ6mtRSbTUGthaKKKBhTqbRQBYo3VDT6zsAUm402iqjEA3UU2mNJVWAlptQ7qN1VYCak3GotxprNTsBJ5lHmVXZqj3VfswLPmUnmVUaSo/Op+yAuNJUfmVW8yo9xrX2QpSLPmVE0lR/PUi2szfw1Okd3YjmuMaSmbqttapb/PcyJAv952Vf/QqwL7xZ4T0r/Xaks/+zErN/wCPVjPH0o9TrpYWrL4Fe5qVJtevNdQ+LmiQI32C0+7/AB3D8f8AjteOeIP2ltBsfMSbUoWZf+WNt83/AKL/AMazjjXV+BNs7Fk0/tux9ZfZ/wC+y/nUM11o9j/x/wCoQQf8Dy3/AHytfnbrX7VFs3yWC3Mv+78v/j1eP6x+0V4qvv8Ajw09I/8AbmdpDXXQy3Mq8vdhZG/1DCw+Od2fqleePvB9j9yea5/3Qq/+hVx2ofGywtkb7Bpq/wC/NJu2/wDfO2vyhvvil4+1Xd52oeR/sxIsdcpdalrGof8AIS1K4n/3pGP/AI7Xpw4SxUv4srD+tYSltHU/SXxF+0lDA7edrsFp/wBMbbb/AO0/mrxjWP2lLBJG+x21zqEv99ysQ/8AHvnr42WH/a3VN5depQ4Nw/8Ay8dzkq53L7CSPb9W/aA8YXj/APEtgtrRf9rdL/6FXn2ofErxzq//AB86zcxr/dQ+Uv8A3ytcd5dKy19FheH8JS+CKOSrmtWW7EuLqa8ffcSTSN/tszf+hUxY6fupm6vUjhaUfgRxyrzl1H7aNtM3VG0ldETK0iRqbuqrJdQ/xyVT85/+WKtJXrYPLatX4EdMKD9Da3Gl+0Rp/FUVrout3P3I9u78Wr13wb8CfHniWaOa20maSJv+W1x+7j/8ervnk3sV7TFTUUu5y1qtCHxu77I8ja6eX/j2XzH/ADqZdP165/5dttffXhv9lGG2jjm8Qaskf96G0jz/AORG/wAK9w0P4L+ANBRdmm/2hKv8d2/mf+O9K8urxNlWG/h3m/wOL6/U/wCXcPmz8vtD+GOva8+y2jubn/ZgjZq968O/sn+KrvbNf2y6fF/08v8AN/3ytfopY2dnpieTYW0Nsv8AdhRVH/jtXWZ3rxMX4hYr4cNBRX3sj/aqvxyt5LQ+WvDP7L/hvTPKfVbtrvb/AAKqxpXtml/DXwNpG37NpMG5f4nG7/0Ku4or5DG59jcT/EqMz/sqlvPV+YL5Nunkwqsa/wB1AoH/AHytI0jvTaZXkWOxUIR2Vh60+oaNtWWTUUzbUyxu33PmrJzsOwyirf2O5/55N/wL5ahkawtvnvL6GD/gWW/8drGeJpx+JnVTwdSWyZF5lL89ZF14w8K2P/Lea5/3EUf+PNXNX3xW0S0/1NlCv+1cy/8AxNczzKn9lXZ2QyavLod3tkqeOzml+5Ezf8BrwPUv2jNHsd3/ABNNNttv8MK+Y9eU65+1hZ/MkOoXlz/1yTy1/wDHqmOKxFXSnTbOiOUcvxzsfbcmmzRR+ZNtj/33Vf8A0KsubUNBsf8Aj/1S2X/cbzD/AOO1+amrftNareO39m6e3/bxL/8AE159ffGzxzff8t4bb/dTd/6FXdSyrMqnSxX1XCR+OVz9Sbrx94Ptv+Pb7TfN/shY/wD0KuR1b40aPpib3trSyX+9dy//ABW2vywvvGnirU932nW7v5v4Uk8sf+O1zjN5j77ydpG/vOd3/oVepQ4SxEveq1fkifrGHpfw4n6Ma1+1NokG7Zq3m/7FhFx/31/9evIdY/aq1C43R6bZT/700u3P/fP+NfIjLRXo0uEsL9u7M/7Un0SPa9U/aC8W6h/qdPtIP97zJD/49XCXnxQ8c3f39QWD/cRf/Zq42o2WvWoZDhaXwQHLNasupoX3iLxDqfyX+r3cv+z5jbf++VrDa3T7+5mZvvbualZtlReZXoww9KPwIw9rN9Q2rRtWo2kqBm+StuTzHHmZZbZUfmVS3U/dUSia+yJaZuoqOSSGL/XS7a5514xjzFRhzEm6nMs392s1tShi/wCPaPd/vVXkvL+5+TzG2/3V4FcksROXwI7IYV/a0RoMsMX+ulXd/wB9VWbUIf8Anh5n+82P/QapfY3/AI6kWGFKr6pVq/G9Do5IRCS+vJfk3eV/ucf+PVXWF3er3/Aaeq12Uctpx+IPa/yoSOzhT7/zVZXYn3PlpNtNVa6fZRRySnzfEywq0jLSbTTafsjMdtNLtqRalVawMnMqtHUm3/Zq1to21pGYvalTaaeq1Oy0lV7QOcGqptqxRURnygiKinUVp7UY2pVqLdTt1ZzqhImoqHdT1mSL79c06vzIsS0baryahbJ9xvm/2aoyaq/8C1jzvsarD1JdDZqNmrAbULn/AHahaa5l+/I1TyTkbRwT+0zdaT+/VFrxE/iqj9nmlpVt66IYeZvGhBbse189RNcTP/FVlbdKkWFK6Y4X+Zl88F0M/wCd6etu71sRwpTmjrWNKHw2uyHijJW1elW1rT3bKqSSb67KWFlLZC9rNj/sqf3qr7Y0q7b6ff3PyQxvL/uq1dfZ/D3XrlPOmg+zRf7f/wATXt4XKqkvmc1fH0qX8SaR/9T8zadtqZY6Ntf0zSpHi+0JI1q3HHSQx0+T5P4q7KFBzkoLc5Jzv7pJMrxbansbGa8mWFP4ql0vT7nUZlhTc1fRngn4d/bpoEhX/eZq/RMqwFLB0vbYh7HgZtnNPBw956sT4c/DW81W5jhsI/NZvvv/AHa+/fBfg3TfCVh5Nmu6eVR50zfeb/Zqr4L0Gw8O6UsNrGu7+N+5NdpHI8v3P/Ha/JuK+KKuPqOC0gvxPiaFKdeft67u3suxcWr8cLy0un2NzeP5NtA07fxf3F/3m/hrO1jxpoPhp2s7b/if6t/z6W/y20X/AF2mr8xxmaU6fW7Pq8BlFSrLRWXc621s/wBy1zMyxW8a7nmdlWNB/eZm+7XnOpfE77Y/9m/DS2TUv4H1q5/5B8X/AFx+6903+7tT/brwH4mfFSz+0+T481L7bcf8u+gWH/HtH/10h/i/3pjt9q8x0/xd8QviDf8A9ieGFfSbe5/5Y2x/fP8A9tv+Wcf+4BXt5RwvisZT+s1/dh56I9PGzw+Ahvdnv194q0TwrrH+kz3Pivx1q/8Ay7p++vZP+me3/V2sH/fKf71d94b+G+pazc23if4oyw32owfvrPSIfm03T/7v/XxP/wBNn/7Zipvhb8J9H+H1n5yL5mrX3z3d31eR/wDebnbXsHmV5mPqwj+7w+y6nm0sR7X3xfuf7VFNqWvKN46DtxpVpi1YWF6znKxQL89W44XaqmoXWm6BbfbNbuUtIv4d333/AN1f4q8Q8XfGB0tp00qX+yLBf+Xlyv2h/wD43XjYrNIRfJDVns4XKKtfXZdz2bWvEmg+GE/4ms+662/LbQ/NJ/wJf4a+fPH3xomSzl+2XaaFpf8Ac34kf/ek6/8AfNfKXjD44W0Xn2vhv/SZW3f6XNyP8Wr5t1jWtS1y8+2alcvcy/7b/d/3V/hr0Mq4ZxuZTUqitE9SdXCYLSOsj2/xZ8dpv39n4PtvI/6ebgfO3+6v/wAVXz5fX2sa1eNqWpXL3c7feeU5/wD2amW3/v1qWdjNeP5MK1+4cPcEYfDWtG77s+ax+fTn703ojChs7l/+BV2uj+GZpfndfSvXPAPwj1vxVeLbaVbeay43zNxFH/vNX3x8P/gn4b8GJHeXirqmqL/y2dF8tG/6ZrX0Oc8VYHKYci96fZfqfHTzCrim4YdadWfNfwx/Z71XXkg1LXlbS7L/AGlxNIn+wrfd/wB6vtzwz4R0HwhYfYNEtEtl/ibq7/7zdWroGamq1fhue8R4vMp/vXZdEtkduAyeEH7Ser7ljcabtpNxpu6vnbHuKAUVGzUlWb8hLRUVFOxZLRUVFKwEtFRUUWAlp241BRRYCxRUNNosBO1M3Gotxpm40WFKRJupjUzdUO41pGBPOWNxpu6qzSVHud6vkI9qi7ujpu6o1hmf+GopptPs/wDj8vreD/elX/0FaynVpx+JnRThUn8CHNJUDNWLeeMvCVn/AMv3n/7MK/8AszVyGqfF7w3pyb/LWP8A6+JdtZxxsPso7IZZiJdNz0ld71Otu7/P/D/ebgD/AIFXyvrn7Tnhux3fZtQsLbb/AHWVj/7NXhfiL9qizvPuT3eof7ibU/8AHtv8q0569XSnBs6oZNJfxZWR+hl1rnh7TP8Aj81BGb+7D+8b/wAdrm7z4keHrb/jztnn/wB87f8Ax1a/LfVv2gPFV9/yB7aG0X+9Nulf/CvNNY8feNtc/wCQlq87L/dR/LH/AHytdFHhjMMT8b5V+Jr/ALFS6XZ+o/iL9orQdB/4+LvTrT/Z3qz/APfNeHeIv2vLD/V2d9dz/wDXunlr/wCy1+e3zyvvmpPJr6LC8C0I/wAaTbM/7UUfgij6Z1z9pzW9Qmb7HYzSf7U8tef6h8YvHOof8t0sv9xMn/vqSvK446sV7+H4VwVL7N/XUxq51V+FOyNXUNY17WP+Qrqlxd/9dpWZf++ayttPp1exSwlOGiR40685fEyHyacsNT0bq6DPnkRquypKKftrOUzO5DTtxpW2JVSS4hiT52ralBz+FGkY83wot0ysr7dNL8ltHu3e1dDp/hXxJqf+pg8tf9v/AOJr2KOSVpdLFVVCkr1GkvMzpJoYqrNqEL/Ike7/AHa9i8M/BfW9cm/49rm9/wBxPkr6E8K/st6k7q2pS2+lxf8AfyT/AMdqquFwOF/3mqk10W55cs8wqfLG8n5bHxHb2epXP+ptNvm/3/8A4mu30H4Y63rn+pguLuT/AJ4wo3/stfpd4f8AgH4A0FVe8g/tadf+fn7n/fK16pa6fpWmw/ZtKtIbSJf4YUVf/Qa8evxngqGmFpNvu9jmnmWKq/AuVfifnP4d/Zj8VXk0T3ltBpcX/Tfl/wDvmvoDQ/2Z/CVjtfUp59Ql/wCAxJ/47X1BSbdleLjeOMfX68q7LQy9lVq/xJNnGaJ4B8H+HkX+ytJt45V/j2bn/wC+mrto5EX5E+Wmr/u1LXyGIxE6r5qjbfmzejhacfgQ+nKtTQ2/mVYa1SL/AF0iR/7zqtcM60I7s9SnTf2Vcpr8lHz0TahoNmn77UIf++s1hzeOPB9t/wAvvmf7u2uWWYUo/DqdsMBUl0Nny3f+GnrC/wDdrzzUPjF4Y07+5t/23Va8x1j9prQbPd9mu7dW/wBhGkqPrs3tBs645XL7crH0wtjM/wDeokjsLP57y7hj/wBln+b/AL5r4H1z9qK5ufkh+0T/APkMV5fqXx88T3f/AB5wJH/vlmrqp4LH1fgjZPuP6rh4fE7n6azeIvDFt9+73f7orGuviN4Vs/8Alk8v+++K/K2++K3jm5/5iDRq39z5a4261rXtQffeahO3+9K1ehQ4Uxc/jnb0K+tYWPwo/U3VPjtoOnfcW0j/AN9lNeVa5+1FYQbkh1Bf92BK/PdleX78jN+NN8uGu+lwVH7cmyf7Z5fgifV2uftQXk+77HHcyf777a8v1D47eLb77myL/vpq8hmVP42qo0iRfxLXt4Xg3Dx+xf1FLOq8ztb74ieNtQ/5i00f+4fL/wDQa5K6mv7x99/cvct/tuzf+hVltqEO/wC6zf7tMa+3/cjavpcLwpPalAwnOvL4mXPuUbao+dct/qYGq1DY63c/6m0b/vhq92lwjiu1jnnH7U5JepNtNL8iVoQ+E/FU/wBy2ersfw58YT/8uzVvHhdr42kcksVh4/HUS+Zz/mQ1HNdQ/wB6vUtL+BPjPU/+WD/k1ddb/s26x/y/z+V/wPc3/fK1wYrBYLDy/e1Vcz/tTCX+K78j56+3W39+qzXyV9PL8A9Btv8Aj81L9KZceAfA2kJ/rd23+KbgV4885yyHuwnd+Rp9fh9iDfyPmLzt1G5/469n1TVvAelbvJlt5G/uwx+Z/wCPV4xfal/aN5JeP/y0/hxjYn8K0v7UoVYe4jswk51b80Gku4SNVZmqSOZKga6tk/irzpYyETupwl2uPoqlJrCL/qYqpNdXlz/sr/scVh9anOXuROqOFn10RqyTQxf65qptqiL/AKmLd/vVXXT3/jarMdrCv8Nb/V6svi0NbUoeZTa4vJ/4v++eKRbP++1a3l07y6PqsPUPrHZWKK26J/DSNHWjto21tD3TH2xneXT/AC6utHSba39qHtSp5dG2rtG00e1I9qVdtS7al20/bSlW8iJTK+2rCrT9tOrOdXmM3MZtNLRuo3Vn7SIBRTlpGZKwlViSKtFRNIi1A19ClZ+1/lRpyN/Ci1TNtUJNUT+COqzalcv/AHV/Cq55/ZR0xws/Q19pqo0yJ/FWX/pMn8TNSrZzVvTpVX0Nvq6XxMuNfQ/7TVWkvN/3Fpn2f2o8mt6eCn9p2NI8iG+dM1M2u/8AtVY8up44a6fqUY76j54oqLbu1SfZfarnl1Iq1fsYdjGVcpLb1YW3qztqRVpGMq7K6x0m2rW2jbREjnI41oZak205VoM7karW9pfhHxDr77LCPcq/lVWxms7aZZryLzNv8P8Ae/3q9JtfiZ5CeTZ2nlKv/Aa4cVj69KX7qF/MU5VLe47PzNTRfgXeXO19SvvIX/d/xr2TSfhD4J01F85lu5f9pv8A4mvFW+Kzp/ywb86X/hb39y0b/vqvNq5vmsvgVkeDisnxGJ/i1Wl5H1jpPh/w9p6bLO2t1b/vmt37LD/Atv8Akpr43/4XJfp/y6f+P0v/AAui/wD+fT9a454rNZf8OcVLg3CJ3k233Z//1fzXqXaaiqf56/qGlBykkj55i/On8Vb2l6Pc6m9Q6Tpb3ky71+WvZtJ0+GBF+WvqcLGFD3up8/m+brDrlhqzU8J+FYbTa+3733q+m/CcdnZwxv8Ad/SvCbObyk+f/gNekeE9J1LxDcq9zI0FlH99mO3iuPOsy5qb9pKyR+Uy9ri8ReSu+h9LaHqn9qzLbWatPL/dRa72+vPDfhKHzvEFz5t7/wA+Fsfnf/eryH/hJv7FsPsHhXZbQL/rb91/9Br5i8efHTR9Amns/D3/ABO9X/jmdsxJ/wACr8Bx+Nq4+v8AV8Am79j9gyHh72UFUxR9SeMPipN/Zsk2sXsPhnw/F/y7IcPJ/vSL/wCgrXxn4m+OWseI5v8AhHvh3F/YWnf8/f8Ay3k/3f8Ann/6FXhGoap4n8f6r9s1i5a5b+FPuwx/7q9Fr6P+FfwrudXuYLOGP/rtN/dr9W4a8N8PltL69mru90uw+IOI6eFp+zpb7JFD4b/CO/8AFuq/uV/27m5mO7b/ALTN/E1fo14L8C6D4J01bPSoF8xtvnzt/rHI/vNV3wv4X03wvpUem2ECxqv3m/idv4mb+9XQM1fL8TcUVMxn7KnpBbI+Mw+EqVX7Wu7v8izupy1XjqdVd6+NlE9qC5Yk/wB+rEce+pLezeX+GuT8TfEbQfCXmWdt/wATTVl/5YQn93F/12k/h/3a8zF4+nSV5M9TB4KpiZ8kEdzHawxI1zcssFvF8zu52on+8zV5l4m+LWm6Yklt4YVbmX/n8f8A1af7q/xV8wfEj42Qxv8A8VJqH2mdf9Vptt9xP+2f/sz18geLvih4h8SySw+Z9ksv+eUJ/wDQm/irmwGW4zMprkVl3Z9H9UoYL3qru+x9E/ED43QwXk/7/wDtbVP7+/5E/wCBf/E18teIvF2veKJv9PuWZf8AnivES/8AAa5lW8379PjZEr9Pybg2lQtpd9zxMbnNSrotF2F2mnf63bsXc1W9L0m/1ybZbRfL/E/Zf96vf/h78J9S1W/Wz0S0+23v8czfcj/3m/hFfp+HwNLC0/a1nZLufI5hmlOh7sneT2SPLtD8L3955f2xdqy/99V9lfDP9ne51CGDUteVtNsP7n/LeQf+y19AfD34N+HvByLf3+3UtW/57OP3cZ/6Zq3/AKFXsfnV+f8AEPiFOrehgFZdX1Z5UMFVxL567suyMvR9F0rw9YRabo9olpaxfdVF/wDHm7sa1KZT6/LZycm5Ser6n1GHw6glCKskOoptN8ykdagSUzcabuplFjaMR+6jdTKN0dUUO3Gl3UzdRuNKwD6fUe40bjTFckoqHzKiaSlYVy1uNG41V8ynrHNL/DS5bfEw9oS+ZTN1XI9Pudm99q/7zYrKvNW8Pad/x+apCrL/AAo24/8AjtclXGUo/Ezalh6svhjcmamfO9cZqHxQ8H6du2b7vb/ugV5Vrn7THhjSt37y0tP+BLK9FLGc/u04ts6/7Kqfb0Po1bWZ/wCFqhuJtNsU3397DBt/hZ/n/wC+Vr4H8UftZQz7ks57m7/3U8tK8F1z9ojxDqDslhaJbf75aT/4mvRw+W4+v8ELLzNI5fSh705XP081D4ieFbP9zCz3Mv8As/KP/Hq4PWPjNp+nJ889pp6/7ci5/wDHv8K/LbUviB4q1f8A4+dQmVf7qfux/wB8rXHTXEz/ADvKzN/vV69DhHEVf4lSxUcXhaXwwuz9CfEX7S2gwbv+JpcXbf3YEYr/AN9NtFeH69+0peT/APIN09m/2riX/wBlWvl1pN9G2vdwnBmFpe9PV+Yp5rU+xoj0nWvjF4/1rciah/Z6/wB22RY//Hq88ury/vn36hPNcy/xM7sx/wDHqhajzK+hpZVQpL3IpHHPGVJdRY44/wC7Vn7lVd1L5m+r+r2OKd31HtsqOhqZXVDSIRiG6n7qjVak20uaJYbqdRtNO3GmQO+em/PUH2yCk8zf/qVaRv8AdzXfh8BUq/DErkfYuL9yk+0Qf3qtWPhvXtc2w2ds3zV6h4f/AGe/GGqvH9ptnjVv73y/+hV6v9iql7+Jkl6nFXx+FpX55pPseN/2lCn8O6pYf7S1B9lnaM3+7X3T4X/ZLtvlm1WXd/uf/ZV9EeH/AIL+A/DCL/xL1kuP+m3P/jteZis8yjC/D778jyqvEEP+Yem2+72Py60n4b+M9a+RLR/m9q928L/sr+IdT8ua/j2r/v4r9EbWx0ex/wCQbZbm/wCuW1a0Wj1WVP8AljaRf7bqK8LFeInKuTDQUfN6sy9vmGI68qfY+X/Df7MOlaVt+0bI/wBa9k0n4Y+DNF+d7ZLtv9vn/wAdrq5JtNg/4/8AW7Zf905rJm8SeDbH/mIPc/7if/FV8ljeL8RiP4lV+i0ChwzzT56icn3Z0kM1taIsNhGlsv8AdQKKc11/fWvNbr4peGLb/U2M0n+/IsY/8drhtU/aI0HT/wDU/wBnWjf9/wB6+f8ArvM/3cW2fQUsklBe9ZI+iY4Zp/8AUxt+VX/7Lm/1k37v/fZRXw3rn7UXm7vs2qXcn+zbReUP/Za8uvPj9eXO547S4n/6+JW/9BWuhYfHVfhp2XmdMcBRj8crn6XTf2bbJvudStov+2i1z114u8H2MbfadS8/b/zxT/2Zq/Mm4+M3iG5T5IIbT/dG7/0KuRvPH3i2+/5iE38q6I5Fj5fG7GsfqkOlz9Orz4veE7T/AI9rR5/998f+g1w2qftEWdnu8uW0tP8AvktX5tTapqt4/wDpl9PJ/vPVXbN/ervpcGTm/fm2af2pSj8MD7a1b9py2fcn2u5n/wCuPyivN9S/aIv55P8AQ7Zv+20n/wATXzGyw/xtSSTQxf6mN2/4DX0GF4ChL7LZn/as/sKx7BqHxi8W3T/J5a/8A/8Aiq5e48ceJL7/AI+b2b/gHy1xMcepS/6m2dv+A1r2/h/xDd/6mJV/4DX02H4HSj8KRw180n/y8ml8yK6vLm5+/K7f7x3VmtJDF99q76x+FPi3U/8AlnNL/uRtXX2f7O/iS8mXzrS4/wCBcV6dLh/C0NKlRI8qrnWF+3O/oeGNdWaffkqJtQh/g3SV9daX+y3qX/LaCGP/AH3r0TT/ANmOzi8r7Tdwx/8AXFKJV8oofHVv6GDzql9iDZ+fy3l5L/x72lXI9N8Q3P3LRlr9MtN/Z/8ACtj/AK5pp/8Avla7C1+GvgnT/uab5n++2a5qnFGWUv4cG/wJ/tSvL+HSXzZ+WMfg/wAVXP3I/wBK2bX4T+Obz/l2b5vav1Ph0Hw9bf8AHtpsEX/AFq8trZxfctk/Jaw/14px/h0V8zL+0Mb5L5H5taf+z74nvP8AXLPJ/wABxXcab+y7qs//AB8r/wB9PX3p5ifwRqtV9s1z/qWdv9lF3VwVvEHER+FKKJjHG1f+Xj+R8n2P7MMNt8lzqFtH/wB9Ma6+x/Z58E23/H/O9z/3ytfQv9l3+z995MH/AF2bJ/75WsLUtS8M6GjPquoLJt/vOqp/47XzOM8Q8VLaq36HVQ4exVXWba9Tzm1+FPgPTvkttNWT/fLM3/fNdXb+A9H+X7Np/kf70ar/AOhc155r37SHgDQ/9Gs50bb/AAW3zf8AoNfP3i79qjW779z4YsfIX+/cN/7KtcH9vZnidrrzbPRjwjh/iqO7Ptn/AIRvwxYx+df/AGaP/gOF/wC+q5fVviF8NPCv8MLNF/c/+yr81NW+J3xC199+oazMq/3UO2uNmmvLuTfc3M0/++7NUzwGOrfxKtl5HbSyLL6T+G7PvDxR+1FoifudNiT/ANC/z/3xXhfiD9o7Vbz/AI9rbd/vO23/AL5/+tXztJ5NV/Mhiq6WQ0o/HdvzPWhCnH4Ine6x8VPHOq/8vzWy/wDTH5a4O8vr+7/4/wC5muW/23ZqrSakn8C7qp7bmf8Ah216eFw9OHwROuEP5lYsNJCsNV2vn/gqxHYx/wDLb5qnW1SL7lerDCzl8egc9OPmZjNc3P8AnFWI9P8A+ezVoMtPrqhgILzZMsRL7OhHDbwxfw7v97mrTM71GtTVvyKOysck6l/i1IfLptWKZtoIuMoqamUmFwpy05VSj+OsJSRIm2jbUtG2uSVVdzO5Fto8upvu0vmJWX1jsHvEG2l2vTJL6zi++25v9n5qz21b+5F/31T9rLsdMKE5dDS3U3zKw2vJn/2abtvJf71X7OZssJ/MzYkuo4v9Y1V21CH/AHqofYZv46njsf79bRwr9DX2VOPxO41tQf8AgWoWuLmetWOxhX+HdVtYUT7i1rHCxJ+sUo7I59bW5l/hqZdPetzbT619kl0MpYyf2dDGXT6sra7f4a0N1PrT5GLxE2UvLkpm2tCjyUo57fEZ+1Mzy46Ty60/IT1pjR7K0jXL9sUPLp6x1Y21Iq03MJVSv5dKsfz1Y8ulWOsfake1I/Ljp+2ntsT+KmeZ/trSjQnL4SPeYbaiZab9qRP9qo/O/ef/AFq9ChlteX2WXGEibbUirVb7RJ/zzpfOf/lnFXZ/YWJ/kL5C5Q2x6pedN/zyqeP7S/8AywZq0jw1ivisZyjbqTLDDUnlpUP2fUpfuWz/APfDUf2TrD/8u1x/3w1dC4SxUvInmXWSXzJsRU7yZP71Sw+GfEk/+p0+4b/tm1Wf+EO8Vf8APjP/AN80f6oVV9pGMsRSX20f/9b83Y4a1dPtfPfZVJZk/u1u6fceU9f1DhcRyz2PkcXOag7LU73SbNIIV+Wust2rlbG6SWu00exudTmWGzX/AHvRF/vNXZiMWop1JuyPzvGQlOfLbVnS6HY/a7yLev8AwFf4q9S1jxBpvhDTfO1u527fuWiV5tqXjDRPAVg1tpu271Rv+W39yvmHxB4k1LxHeSXN/O8m7+8a/P8A6vi89r+yo6QW77n22Q5LTwdqtVXm+nY7bxx8Wte8XvJZ20n2LS/7ifxVw2h6LNqdysKL8v8AeqfQdBm1Ob7v7qvrf4Y/DG51y5itrODaq43v/An+9X7ZlGSYDh/C89ltq3uzk4j4o9l7i1k9kuhm/DP4Y3Oq3kFnZwf777flH+01foL4T8K6b4T01bOz+9/G/wDE7UeG/DeleEtNWzsF+b+N2+85rZkmr8c4o4oq5pU5Y6QWy7nxuAwU3U+sYh3l+Rf8zfQq1TjkeX7lb1vZ/ZLNtV1WePT7CBdzz3DbR/49Xw2KrQoJubsfV4WhOq1CmrkcNu71b1LUtE8MWf2zXp1g3fchXmR/91a8m8UfGC2sRJb+EINv/URuR/6Ljavh/wCIHxyTzp/7Nn/tfUZfv3O/KL/wL+L/AIDXzn12vi5qnho3Z9hhOH4QSniXZdj6t+Inxwjgs5/Ou00LS1/6afvpP9lm/wDZVr4W8WfGq/1PzbDwrH/Ztrz/AKT/AMtn/wB1f4f/AEKvHdY1LUvEN59v1u7e5l/h/uJ/ur/CKz2b+D+Fa+9yXgWGlXFu77disVnSgvZ4ZWXcmkunndnm/eyy/eZjkt/vN/FSVAzIifO1OtbW/wBVm+x2cDNu/wA7mr9Wy3JtowVkfNz1vOb06tjftCRV6B4Z8F3+q7bzVV+zQf8Aj7/4V3vgX4XzXN5bW1tbf2pqM/8AcT7n/wAT/vNX6CfDv4L6V4ahi1LxJsvdR+8sP3oYP93+83+1XXm+eYLKKXvazey6ny2MzWdZulg16tnivwz+Bd5rKQXl/G2l6Mvttkl/3V/h/wB6vsTRdD0fwxYLpuiWyW1uv93qf9pm/irVkuN3yfw1BX4pm+fYnMZ81d2XRLZG+X5NCh771fVsnVt9SrVZadurwpRPajSsW6fVZWpVkrOx0EtRNTZGqPcauMRofuo3VFuoqrBckZqj3UUqq70bFe0E3U7casR2NzL9xW/KobqbStM/5CWoQQf7O/cf++VrCriqcfidjWlSqVfgi2N3Ghd71y198RPCtj/x5q963+1+7X/GvK/FH7QGn6UjedfWml/7pUv/AI1y/X+Z2gm2zthk1WXxux9DrZ3L/wAO1f73Ss64vtHsf+P7UoI/9lX3P/3ytfnz4s/agsJdyWdzd6o3+95af+Pf4V4brXxy8Van/wAeaw2i/wDApH/8e4/SvQoZXj6+0bLzNvqWEpfxJXfkfqVqHxQ8JaZu+zeddt/e/wBWleTeJP2krDTNyfbbLT/9lPml/wDZjX5jal4u8T6x/wAf+pSyr/d3so/75Wue2/3/AJq9ehwbOX8ed/QX1/D0v4cPvPs7xJ+09Z3jyfZ2vdQb/ado0/8AHq8S1r46eKtT3JCyWi/7PzN/49Xj+3+5tqDy697BcJYKl9m/rqYzzqpLyRvah4s17Vf+P++ll3f3nbH/AHzWA0m+my/fpqtX0VLBU6XwKxwSqzl71w+59zmhf9ql3UNXZGPkZBupu6mU+tLAN8ym+ZS0ymWPp9Q7aetRIJBtoqWo2XfQA3caVqnhs7mf/UxM1btv4Nv7z/Xfu666WCnL3uhlVxVKl/EZzSyIn32qNrqP7kO6T/dr17RfhDqWo/Pb2M0/+2/Cf+PV7DofwZ0qCHfrGqWll/sIvmP/AIVrKWAw/v4ip8kcjzSnf93Ft/cfJMdnqtz/AKmB/wDgVdVpPw78Vavt8mP7391GNfc2j6X8JfC6b5tPfVp1/jnf5P8AvnpXTSfHTQdBh8nS7Sw0+Jf9mP8A9BWvHxHHGFpaYWi5PuxzeOmvcSXqfNvg/wDZV8T6x881lN/23/dpX1B4f/Zb8PaNDG+vXcMH+7tWvL9e/akufm2ag7f9eybVryTUP2itbuXb7PA/zfxO9eJiuKs6xX8Jci8jn/sX2uuLqt+S2P0A0Xwz4A8IfJpVtAzL/wAtNq/+hNWnceLtBs/+W9uv+78zf+PV+XN98YPG2o/cn8hf9ndXLXXizxPff67Upfm/unFeFPKMfip3qz+Z10Muy+h0ufqLqHxa8N2yf8fP/kTbXmepftEeFdPkb7NPDuX/AIF/6DX52SfaZ/8Aj5neT/eNQLZ100uEv55nb/aVKPwRSPtTVv2oofm+y3Mzf9cY68z1T9oy/vP9TaXE7f8ATaTC/wDjtfP/AJKLRtr1KHDOEh0uY/2zM9F1D41eObn/AI91t7Zf++q5W88ceNtR/wBdqjr/ALm2OsdVpjSItevQyahH4IfgZ/2pVfwhcTX95/x83M0/++7Go44dlRzalYJ/FSR3k1z/AMedpPP/AMA+WvYoZTUkv3cTnl7WWr09Sztpf+BKtJHp+vXM3/Ht5X/Aq9C8N/Bfxb4nkV7bT5/Kb+NlZU/76r0f9X+Rc+IkorzZyTrU4fHL7tTzGaSFP4vM/wB2iOa8l3JbWLN/tV9yeE/2UfIj87W7lF/2V5/9Cr3jQ/gP4J0j/j5tvtbf7Z/9lWvPq59lGF0u5tdjl/tBylalTbXd6I/Laz8O+IdQf5LbyK9J0H4F+ONc2+Tp93Kv97ZtT/vpq/UWx8J+GNK/48NLggb+8sa1s7n2bE+7XmVvECMf91pJebL/ANtn8VkvI/P/AEf9lnxC/wDx+fZ4P991/wDZa9T0X9l/TbRf+JrqSbv+mMf/ALM1fVW2R6PL/wBqvExXHGZVftpeiMP7LlP+JJs8h034H+ALHb51tNd/777R/wB8rXZ2PgvwfpX/ACDdEtI2/vbM/wDoVdPSNXhV8zxVX+JUb+ZdLKKEel395XVURNiKqr/dUYWhvT/0EVPUPzv9yuO52fV4fDBELSOn8O2o9z/3tlaMOn3kv/LJlX+83FVLpbDTvnv76GP/AGd2TWc8XTju7HTSy+pL4EU6ib/d3Vy+qfELwZpW7960+3++VjSvDfE37T2j6Y7Q2NzBH/s2371/++qhZhzaU4tnfHIq3/Lx2R9O/Y7n78222i/vTNtrLutU8Pad/wAfN7u/2U21+e3iL9pDxDqbt/Zsb/79y/8A7KteQat4+8Ya1/x+ak6r/dh/dr/47W39n5hX291M6oYDCUvjd2fpPrnxi+Hug/Pc+Tu/6bSf+y14r4i/a6sIt0Og2z3f/kJP/Hq+DWaZn3zN5jf7XNC/J/drvpcH0/ixE3J/gbfWIR/hqx7j4k/aG+IviF28m7/s+Jv4YfmP/fTV43qmra3q8zTarfT3f/XZ2aqsjfJvqo11Cqfvm217GHy3D0P4cbWMPb1Zh5KPS+XWXcatCn+p3SVX+0ahc/6lfLWu9SfRHRHC1XH3tjTkuoYP4qz7jUv7jfNSx6aj/PcytJWrHDZxf6mDbWn1ebL/AHUPNmFGt5P9yPy/9pqnXSf47mTd/u1sfeqSt44KH2nciWNf2dCnHa20H3Iv60tWKbXR7q8jDnb3dyuy0xvkq1tNG00/aj9oUtu6jaat+XSMtL6wPnIFWpaa1G3+PdR7X7QwqGOTfU336a0lnB9+VfzrGeNS6XZUfTUdUO6oW1S2/us1UW1D+5H/AN9VlHGSfQ3hhp9jV3PTvufO9Zkf2+f7ny/pUn9l3Mv+uk/rSlGpPoVKlGPxsuf2hbL99v8Avnmq0msf88Y/++6f/ZcKfxNVq3s7ZP4d1L+zu7J5qMdbXMZrq/uf/saT7Lcy/f8A/Hq6by0/uU1oa6qWEhEPrvZGCum/35KsLp8Kf7Vank0/y66OSP2TN4yfcrLDCn3IlqTy6m20/bRGJze1Knl09Y6seXT/AC6ftImXtSD7tLtqfyaPLo9pEOcrUKtWfLpfLqZTQvaEXk0vl1Ptp201jz+ZHtCDy6dtNTf+PUjbETe7baOa4uci21XaN6n86F/4l/76qrJeJ9xF3V6NHLa8norm0Iz7D/LT+Onbd/3KvaP4V8W+JZvJ0TS7u73f88Y2K/8AfVe4+Gf2WfiFrG19VaDRoG/5+H8x/wDvla7qmAo0LvE1UvIVWvTh8clc+dJLjb8n/oNQq1zK2yFf6mv0X8O/sm+A9KVZtbu7nWZ/7ufJh/75X5v/AB6vadD+Hfgnw9t/srRLS22/xLGpP/fTc1wPPsvpfw4uVvkjnlmcPsRv5n5baD8K/H/iX/kG6JdyI38bo0af99NxXr+k/sr+Nrnb/atzbaf/ALOfNf8A8dr9G/L/AINtOWGuSfGdX/l1FI56uPry2dj4hsf2UbNf+PzVpp/9yNY/8a6O1/Zj8PQff86T/ff/AOJr7AWGn/Z65pca4/8AnscVWlVn8U2fLdv+zr4bi/5dv/Ha2IfgL4bT/l0X/vha+j/JpPJrlnxfjZfbZz/2WpfHJs8Bj+BvhiL/AJdEb/gK1eh+DPhuL7loi/hXuSx0bTWMuJsd/wA/GH9l0nvf7zx+H4U6DF/y7LWlH8O9Ei+5aLXqO2jbXI8/xct5sf8AYeH/AJTz1fA+l/c8haX/AIQPR/8Anh+leiLDT/LrH+2a38zJ/sDDfyH/1/zpW1etO3XZS7alVa/oj2sj4irV5jr9J2N9+RYIl+8zVv6h4y+x2f2DQf3a/wAb93rzb5/79PaRIPv/AHaHl88ZJQm9O3c4qVLlnzR3ZmahdPPNv3MzN96ruh6DdatN8i/ul+9WlpOg/wBr3O9Pu19a/C34UvrE0X7vyrWL771+uYSlhspwXtKmnkcWcZ9HDr2cNZsPhX8K7nXHi/d+RZR/fm/z/FX3Pouj6b4c02PTdNj8uJf++mP95qg0vT7DQbCOwsI/LijX/vqpWm837n8VfiPEfEFXMqjnN2itkfLYLCTc3UnrJ/gaDXFaNjptzfPshjZmb+H/AOK/u04afaaHZ/2x4qu1022/ut/rn/2VWvIPH3xj8qwnh02f/hGdBi/1tw77bmX/AOJ/9Cr82zDPYUv3dHVn3+WcO1K9nU0R6prni7w54K/0X/kM6wv/ACwQ/uYv+ujV8k/Fj42WdnN9p8Vah/aV/wDfg0u2+5H/AMB/h/33r5y8ZfHC81HzNN8Gf8S+y/jvH/10n/XNW+7XgDLveSaaVp5Z/nd3O4u395mb71deU8K18fL2uK0XY+l+t0MEuSite53Pi74meJPGLslzJ9ksG/5dIfuf9tG6tXEKzulM20zzNn7vdX6xluUUsNDkoxPAxWKqV5e8y3uqrNMi1Wjkubt/sdnG0ksrfw17L4N+HPmXNt9sja7v5P8AUwIN3z/3dv8AFX2mDyq372q7JHmY3GUsJDmqvXourOK8M+CdS1547i//ANGsv1f/AHVr7I+F/wAFb/XoY/scH9m6R/HeOPv/AO7/AM9P/Qa9p+H/AMC4bdINY8bRr/sad/8AHz/F/u19IbkVIoYVWOKJdqoi4UD+6qrXx3EPHnLejgPmz5if1jHvnr+7BbJHP+GfB+g+DLP7Holttb+OZuZXb/aaukaTfTKK/Jqs5zm5zd2+rPbwuFhSXJFaD1qVar07caix2E26jdUStUtSaXHK1PpFjd6njtXespOK6hzlejbVW+1TRNM/4/71F2/wL8z/APfK1wGqfFTSrT5NLtvP2/x3B+Vf+ArXJVx9KPU9Chl1er8Ksu56bHbvL8iLu/3aLj7Bpyf8TW9t7T/fdd3/AHzXyN4o/aEs7PdDqWtpF/0wtG3f+Ow/+zGvn3xJ+0V/0AbJ5P8Abu3/APZV/wAaypRx2J0w8LLuzu/s2hS/iz17I/Ri+8deD9KT/Xvd/wC4m0N/wJq82174+abpSfJ9m01f71w/z/8Aj1fmHrXxe8bavu36hJArfwwKsX/oPNed3l5c6g++83yM33mc7mr6DB8FYqrZ4ifyRf1rD0v4cfmz7/8AFX7U1h83/Eymvf8Ar33bP/ZRXg2tftHa3ebv7HsfL/27h93/AI6tfOKx/wAFSYir6bC8H4Sl8au/Myq5xP7GiO31j4jeMNc+S81SZYm/ghPlp/47XFyTTO/mP+8/3qbujqLca+gw+X0aXwRR5s8TUluw/wBuplkqvup1eh7OJhKPMTbqXzKrVLuqPZxF7Mlpu6k3GoqzjAiMRrUyntTK2ibIfRRQrVYgplPo20FkNG2n7afQBDtqZaKdtoIlINtPXelPVal20GXtDqfDuqWdnbSJeS+X8/y7U3fKa7SPxxo9t9y2mnb6bRXkq1L9+uWrSnJ/Fp2OCeFpubnJXbPWJvi5rezybO28uL/adv8A0Fa5u6+IXi25/wCXlIP9xP8A4quTjjqTy65o5dQXTU29tb3exPcaxrd3/wAfN9NJu/26oSW/m/fZmqzt+Sha6oYeH2URKuyGO1qzHbotKrU1rhF/iro9g38KM5Smyx5aUMtV/O3p8is3+7TobPVbn5IY2r0cPkeIn71rIz5es2P8yo/MjrtNF+F/jbWX2WGm3Nzu/uRs1euaH+yv48vv31/Atov/AE8SKp/75Wrr4PD4f/eKqXlfUw+uUFfW/ofNUk1EcN/P8kNtM34YX/x6vv7w/wDsmpBtfWNUhg/64o0j/wDfTV7Hpf7P/wAPdMRftMFxqTf9NpNq/wDfMe2vNq8RZPh+rm/IUMVUl/Dhp3Z+V8PhXXrz+Lyv9nq9eg+H/gX4t17b/wASm9u/9rYwT/vrpX6paP4P8K6An/En0a0ttv8AEsal/wDvpua6Pdtrz6/iHCPu4Sil5tm/Li59beiPz70X9lHXn2/aYLTTf+u7+Yf++Vr2bQf2X/Den7X1vVLi9/2IEWFP++vmNfTcklRV8/i+NcyxH27LskZ/2XzfxG36s4PSfhf4D0Db/ZujQKy/xzL5r/8AfTV26w20HyQr/QVLRXzdbFVqvvVJNvzOylgKdPaIbqZT6ZWR1BTNpqXaasrY3L/w/L+VZyqRhu7F+ylLZXM+k2yf3Kvyf2bp3z392i7f4VP/ALNXGa98WPBPhqFppruCP/fdc/8Aj1cdXMl8MFd+R10sqqS3Wh1C2ry/cXd/u1P/AGf5Sb7nbAv+0fm/75r5P8UfteeHrT9zpTfaW/uwx181+LP2nPGes/JpsfkRf7bf+yrW2HoY/ESShCy7s6v7Po0vjld9j9H9S8TeHtK++3n/APjteUeJPj54b8PI3+k2loy/7pf/AL561+aerePPG2uR7LzV5o1b+GH93/6DXJR28KfO+6eX+83Ne/h+Eqk/erz+SNPrtCl8CufZPir9qy8uZvJ037Rdxf3v9X/483+FeGa18ZvG2s/6mSPT1+rSGvLtyS/w7dtR7q9jD8NYWl0vbqzGWa1fs6EmoXmpanN52q6lc3f+y78f981Qjt0R99TfO/8AqV82q9xdJAn76VIv+Bc/98rXqe3p0vdjY5v3tXqWGZKbteufm1xE3JDFu/2vu1nfar+7+Tc1T7eUvdidUMvf2tEdPNfWcX+uk/75rEm1ZP8AljF/31Udvo8z/wCuby//AB6teHT7OD/ln5n+01bwovua8tCn1uzHWbUrz/U/+O1Muivv/wBJl/qa6NW/4DTWXfVwpQMfr8vsKyM6GxtoPuL/AN9VNtq0sdJJsreM0tInP7eT+JkCrTvLqSNaVqU6/KRcTbRTN1G6s/rH8zARlpq/PRNIkX+uZY/96qsmrWcX3G3fhWTxSa0VzWnSnL4UXfLpGWsVtak/giqu15f3P3P/AB1ax/ey+FaHRHBT+0bzf71U5r62T/lp/wB881k/2feS/fX/AL6arcej/wB+X/vmun6nV6m3sKcfjYkmpJ/ArNVNry5b/V/L/wCPVux6XZxff+b/AHqtx28KfcXZWkcOL61Tj8Kuct5N/P8A3v5VKumzV0vkpTvLStIUoR6ESzB/ZVjCXTYf9qtCO1hT7i1b8r/Zqwseyur00OeripPqV9tPVasbaNtBye1KrR07y9lWNtDLQHOQ0MtTbaKgi5Xop22jbVl3G07bQtWNtRUJlIhVakpvyU7dWQBRUO6q0l1Cn8VdFLB1JfCi4wk/hL9SL89YsMepX03k20Dyf7KrmvR9F+E/xI1x1+x6TPFu/jdfLH/j1elHIZ25qjSXmwrxpw+KSTOLZtlVmvP9qvqHQf2T/E+o7Ztb1K30/wD8ivXvnhX9mf4e6CizalbPrd0v/Py+I/8Av2tc2Iq5bh1rPmfZHJ9fodNWfnVY2+sX02zTbR7lv9lGavR9B+BvxO8VP8mlvbRN/Hct5SD/AL6r9NtL8K6Do/8AyDdNt7Tb/wA8Y1Wt3y9v3K5J8V06f+70kn3Zz/2jV+wkvzPivw3+yDbJ5c3irXf+2Ngn/tRv/ia988P/AAP+GnhxF+x6MlzKv/La7/fv/wCPcV65t/v09Y6+fxWf4uv8c36LY56s6tX45XKlvDDbR+TZxpBEv3VRVVf++Vq3S+XU22vDczJUEQ+XUix1Ltp+2s5TOqMSDy6kWOn0q0rnRGIm2k2mn0NQb+ziNopf4KjoFaIU7aabVilcLRE2mjaakoqLlxGUU+mbaYSif//Q+B9tPVaPMpk1x5Sb6/oejh6k2oxW5+e6snkZIk31Hp9q+r3Pk7flqlbx3Or3Pkw19OfCn4X3mr3kEPl/779hX6nlWVUMuw/1nFO1tUefmuYwwVN6+89kdF8LfhvNrVzEkMe2CLG9/SvujS9PsNAsI9Ns18uKNf4f4m/vVnaLo+m+GrCPTbCL7v3m7s1bitZxRtf6xJ9mtV/vdT/urX43xdxV9am6lR2gtkfM5RllXE1PaSV5P8C1Y6bc6rNsh+7/AHvuhf8AgVR654y8PeCUaHR9mpayv/LZvmjiryvxp8YEgs2sNH/4ltgvy9fnk/3mr4a8ffGC8vvM03QW8v8A6eP/AImvyF4rFZpUVOirI/WMBk1PCw56u57P8TvjlbWN5JNeXP8AbOs/3N/yR/8AxIr428ReLte8X3n2zW7lpP7kHSOP/dWud3TTzSTTfMzfeZuSamjWv1Lh/g/D4P356y7lYvNJyXJDRFiH5/v05lp9VLq48pK+2pUeafLBbnz+snp1JJm8hN71No+g6l4lvFht4vl/imb7if71bfhfwbf+JZo7q83R2X/of+7X2t8L/g/NrnlQ20X2LSIPv3GPv/8AXP8Avf71fR/uMuoOrinY8bNc7WFl7Kguaf5Hnfw1+Ds2pXK6bolt59x/y3u3+5H/ALzf+yV98+Cfhz4b8C23+hx/adRb/XXbhd/+6v8AdWui0fR9K8NWEelaJbLbWsX937zn+8zfxVekm31+RcQcUYjMXybQ6LueRhcFNz9rXd5d+xLJNv8A4qFqvT1r5jkPdgWqfUEfz1oQ2c0v3F/wWuarNR96TsdENdlcp09V31lat4q8J+Ht0epah9pnX70Ft8x/4E38NeTeIvj1YaVC32NbbTYv+e1w/mf+PdK8upmyvyU1d+R7eHyOrJc81ZeZ73HbPs3/AMK/xNwKyr7xJ4b02P8A0m9Tcv8ACnzf+PV+f3iz9pyzd2RLm51eX/Y/dx/+Pf4V4Zrnxw8W6vu+x+Tpq/7H7x/++mrrw+WZhifejGyZ3fUMJS/iSu10R+mGufGrQdKhaa3jSJV/5bXDqK+cfGX7U1h81tbXz3f+xbfc/wC+vlFfBd9qmsarJ51/czXbf3nfdWd8/wDd219HguCPtYiV/IJZrSpe7Rgl5s961r4+eIb52/s22jtv9p280/8AxFeX6x408T65/wAhXUp51/ub8J/3ytcrRur63CZDhaG0f1PLxGaVau7LHmb/AOJqjZqj3UzdXreyiedy3GbaPMqLdRWprYkZqZ5lVmplBp7It7qRmqrRQXyFjcaetQrU1BDH0UyhqBEtDU2pdtQQRUbal20eXREVyKipPLpyx1YyOn7afto20GdyPaaNpqTbTqCvaDVWnbaftp/l0GMpDVWpPLqTctJ50K/8tNtawoVJS5Yoj3uweXU6x1D9oTzFSzVpd1bdn4f165+5B97+HrXsUMixElzyVl5mNeaiuabS9TOX5KSSZNn3q9i8O/A3xz4ldfs2mzt/teVtX/vpq918O/se38u2bW9QhtP9n/WmuLF/UMK/9pqq66Lc8/8AtCk9rt+SPiiP7TL/AMe0TS/rWvb6H4hvv9Tbba/UTw7+zj4A0aFftMU2oSr/AHztH/fK16bp/wAP/Bmlbfsek267f7yZ/wDQq8OvxnltL+FBu33C58VP4IJLuz8sdF+EPi3XNv2ayuLn/rjG3/oVe1+H/wBlPxbfbf7VW202L/p4fc//AHytfopGsKJshVVX+6q4pvmV4dfxCxX/ADDwUfzNo5XVl/En8kfLmg/ss+FdM2/2pqFxe7fvLEixJXsej/C/4e6Bt+waFbNKv8cy+a27+981d63z0lfN4viDG4r+LVb8tkbwyihzXktfvIFjSL5IYliX+6q4H/fK0/56WivIOv6rCOysRtSbadRQOw2inUVVy4xIWWm+XHV6O3eX7i7qlkhhs086/nS2X/ab5qxq4qEN3Y6qWCnP4EZ3k05bfdXP6t8QvBujbt8/2mWP+Fa8J8WftRaPpXmQ2DJB/sY8yT/vla4v7Sc3y0ots9OOTSUeeckkfTzaa8SedcbYIv7znb/6FXN6l4o8MaV/x83PmMv8KMo/9C/wr87PFX7S3iHVtyabbN3+e5dlX/vlef1rwzVvHnjPWt39pa3NHE3/ACxtv3Cf8C28t/wI16VHKMyxPTlXmR/sdL4ndn6W+Jv2hvCXh75PPt7aX/afdL/3z9//AMdr5y8UftbXNx5iaPbTT/7T/uk/75+/Xxb5ab96NuamstfR4XhGl/y+d2YzzbpTVkem+JPjd8QvELtsvfsSt/z7/e/77avNJrrVdTm86/u5p2/vO7NUPyUjTeRX09HAYehH3Ekck8ZUl1JW2f3dtO+So/O83+Fm/CopP3Xzv+4WtZ4qnBbnPGlN+pK1MXfL9xd36CsibXLCD/Ur57VjXWtalefc/dr/ALP/AMVXHPH1JaU0elQyub+PQ6i6mS0/4+ZVirCm1qFf+PaPzP8AaaseOxuZ/v1tQ6bZxff+ZqVPCV5fxXY6vZUKXmzNbUNSu/kT5f8Ac+WmLpcz/PN/i1b+6H7iUq11QwtKHmH1v+RWKVvptt/H83+9V5f3X3F2/wC7Tt1O3Gn7flOOdWcviH7qlWqW6n+ZWc65hKBdorPkvraD77VSm1qH/ljGzfpWft2y6eDqS+FHQVCsLv8Aw1zLatfz/wCp+X/dXdTvsuq3n393/Ajtp06FSfw6HRHAcvxux0DTWdv/AMfE6r/OqMmrWEX+pjeRv73Sqsegv/HOv/Afmq+uh2y/fZpP0rrhl8vtyL/cQ6mPNqk0v3F2/rS+Xqtz/f8A5V0sNvbQf6mBFq7XXHB0/UzeOhH4InJrody3+uk/rWlDoNn/AMtmdv0rXqVa39jCOyOarmFV9TO/s22if5IF/nVhYaubaTaaq8jlliJv4mZ8kNCx1obTTWWi5Ptin5dHl1c20UE+1Kfl07y6u0m01Eg9qR7aZtq7tprLREx9qVtppdtWttG2gfOVdtMare2oWWrKjMiambasbaY1BdyKm1JtNR0Gg7aafT6K55SM7kfl1taP4X17X/8AkD2j3K7tu5V+TP8AvVRtfsyzK95F56r/AMsui/8AAq9Q034nXOjJFDpWnpBBH/B2rz8Viq8Jfu4XOqlCMl7z1NbSf2cfE+q+VNqV3BaRf7J8xq9k8P8A7Nvg/THWbWGbUP8AZZ9o/wC+VrxuT45eIf8Arn+LLRH8cte/u/8Aj7VzTzTOJL3NEKrhVPeq7dlofbOh+E/Cui7YdK0uCDb/AM8UX/x5mrtI2/gSP5f99a/Pb/he2vJ/yy/8earEfx81tf8AllXj1cPmdT3p6mUMkwS66n6HrsX+H/x5TVhVSvzwX9oDVf7v/jzVOv7Q2tp/ywb/AL7rH6jj+xv/AGbh/wCY/Q3y/wDapfLP94V+fy/tGaqn/Ls3/fdWY/2kr9f+XFv+/lZPCZgv+XZX1DD/AM59+LHUiw18Dr+0xf8A/QPb/v5VqP8Aacv9n/IN/wDIjVlLD4//AJ9i+oYf+c+8fJ2Uqr/tV8Jr+09ef9An/wAit/8AE1aj/akvP+gT/wCR2/8Aiaj2ON/59j+pYb+Y+41X/aWn7U/56LXxCv7VF5/0Cf8AyLS/8NVXj/8AML/8i0exxv8Az7KjgKX8x9ubYf8AnqtLth/57R/99V8Rf8NRXn/QL/8AIpp//DT03/LTRv8AyL/9jUeyx38hvHAU/wCY+2v3P8cq/wDfVLiP+8v518T/APDTj/8AQI/8i/8A2FKv7Tn/AFDW/wC/v/2NP6vjv+fdzaOApv7R9qtHTPLr41X9qSBP+Yb/AORf/sasx/tUW3/QP/8AIv8A9jR7LG/apMX9lQfwzPsTyalWOvkWH9qKw/j0/wD8ibqm/wCGrNEg/wBdAsf60/ZY1/8ALp3H/ZK/mPrdYXpfJevkf/hrjwz/AHv/ACG1OX9rrwr/AHv/ABxqf1bHf8+mXHKPM+tvLpPLr5Xj/ay8JS/8vcMf+8jf/E0v/DWHgz/oIW7f9s2rKVLGL4qTXyLjkz/mR//R+A7iSq9vDdarcrbWys1Z8clzc7Yfvf8AoVfQ3w58E3E7x20Mf+lT43V/aWT5TDDw9tW0SPznNcdDAUXUnv0N74Z/DebUbyC2hXd/eavv/wAP6LpvhjTY9NsF3St99l++xrl/Bvhm28PWH2ewZGn/AOXibsn/AAKsvxJ8RLDRvPttEbz7r+O5b/2Svxzjvj361V9lTd0tkj5HJMkxeZV/rFXRefY77WNesPDyM9/Isl7/AAwL/wCO76+Y/iF8Vtm65v7n12J2X/ZVa8t8afFLy3nSGfz7pv4t1fOGqaxc6rctc3jeazf+O1+c4XIsRj589fRH65S9hgIclPc3fFHjbUvEszfvPKtf7n/xVcLNNUd1MsX3KxPMfzq/SMrwFOguSgrWOHmqV/emzooZKvR/JWXbrVuP7TdzLbWy7t1fe5XlVTE20POqw37ISa+d/wDRoV3V6B4R8C/bHW81X/vz/wDFV2Pgf4bzTzQfuPtd7P8AcXGdtffPw5+DOm+HPI1XxCq3N+uNkP8ABF/verV7uaZrgsmpd59F1PkMfnrqt4fB79WcN8L/AIKvcwwax4kj+yad/wAsbb7ry/7391a+p4/s1pDFZ2cSQW8C7URF2hR/u0k11v8AkqvX4fmuaYjH1fa4h+i6IxwWAhQ831fcseZUtVoq07OzmuX/AM4rxqs1GPM3ZHs0oXfuoqr89a1rYzS/f+VV/ib5VrmNc8beGPDG5Ny6her/AAL9xf8AeavmP4hfHZIkZNS1DyIv4LS3brXz2Kzecpezw8btn0mDyKcleq7I+oNa8eeGPD26GGX+0rpf4E+4v+81fMfxG/aCjg3W2pal9m/6cLP/ANm/+yr498WfFzW9c82101v7Ptf9j75/4FXkXmTT/PMzSt/tfNXr5XwfXxP7zGysux6E8bh8L7mHV33PX/FHxq17VfMttEX+z4v7/wDrJP8ABa8evLy/1ObztSuXuZf7zszN/wCPVH5eynNX6RgMmw+GX7uK9TyMRmNSr8buRqsaVJuplMr1Ix5Ti3Jt1R+ZUdRyNsrQqMCZmpu6qm6jdQa+yLG6k3Gq+403dQXyFiq7VHueo6ImigTU6mrTqsAqaOmVLGtBmx9Po205VrEwG06pFjqfbQZymRbadU22jbQZ3GqtSeXT1Wn1JjKRDtNN21Y8vfUnyV00qE5aRVx+0Knl09Yd1SL5jvshgkn/AN1a1YfDuvX3+ptvL/U17VDIa0veei8yZ1lD4mkvMxZFhiqvJNbL/FXuHhv9nPx54l8qRLadYm/idNo/76avovwr+x68W19e1CFf9lE83/x5q5sZXy3B/wAeqrrojklmtD7Dcn5I+Bf30v8Ax52jyf8AAa3bHwr4k1WaJPI8jd7f+yrX6s6D+zr4A0bbvtmu2X+J2/8AZVr1bSfBPhXQNv8AZWl21s399Yl3/wDfVeDX48y+l/BpOT89hwxWKq/BBJd3uflJof7PvjbXH/c6Rdyf9NnTyovzavoLwn+yHc+Sr+JNQt7b/ZQea/8Au+lffjLSba8HFeI2On7tBKC8lqOWCqz/AIk/kj5v0P8AZh+HWmTRTXi3GpNH/wA9X2p/3yte46b4X8MaRDHDpWkWlt5X3dsS5/76rf20KtfIY/OsXiv49Rv5mtPK6fa78xu5/uIu2j71SbaK8o7YYdR+FEPl05V2VJTas1jAKRlpaYzUEjKbTttG007lkVOVd9XobF5/uLVe+1Dw9oqedquoQx/7GeawnjIR0vqdVLCVavwIj8urUOn3M/3F/wC+vlrxHxR+0d4G8NbobPa0q/xP/wDE181+Lv2utYvvMttH37f9hfKX/vr/AOtWdJ1675aUG/M7/wCyvZWdeSR9+X02i6Qm/WNQSD/ZU8/9815trnxs+HugozpL5+3+J22rX5d+IPix4w8QzSO928Cyf3Cxb/vpq88kuLm5k86/ne5l/vTO0n/oVe5Q4ZxVRXqyt5GE8VhKHwrmZ+gnir9rqzijkh0f/wAlhu/8e/8Ar18zeIP2gPHGvO32VliVv4rht3/jq14ruqL5P7le9g+FMNS96orvzOarn9VxtBWNvUNe17Vd39pahNPu/gT92n/fK1jfIn3F21G0lM+d6+hoYOjS+CKR41WtUqO9RkjNTd1Q+YiffaopPO/3V/z/AHaJ4ynGXLJhSoOWyH/fqo29v9T8zVTutU0q2T/WefL/AHaw7jxJeS/Jar5f864quYOWlNXZ69DLaj6WR0Mn2aD/AI/5/K/2VrPuPEFnB/x5wK3+09c39nvLr55v/Hqv2elp/wAtvmrohg6k/fn+J6Kw9KC95jJNav7h/wBzuX/doXT9Svv+Plv++zWvHCkH3F21YjrWVKnS82ZzxnL8CM5dHtovvy+bVn7KifcXbVll+eo2krL6/wDynL7acutxvl7Kaq76bJeW0X35KoSa1Cn+pj/9lrKeKqz+FGkKFSXQ0/LpfLSsNby/uf8AUx/puqwul6xc/f8AlX/abFT7CvLrYt4fl+OSRPNJbRf8tKpyakif6lWq9D4d/wCe0/8A3x/9lWtDpNnB/wAsvM/3+a7IYT+Z3CWIoQ63ORWa/uf9Su7/AHRuq2uk6rcff3L/ALxrtV+T5E+WpK2p4VddTmnmn8kUjkofDL/8tp1/4DWjHotnB99fMb/arco210xhHscs8yqS6lKONIv9TGq/7tO2mre2jbXQcvtiptNN8urjLSbaIi9oV9tG2pdtO2mtR843bRtqWipM7iKtLtp6rT6gzuMVaGWnrTqCLlfbRtq3tpm2gfORbaftp200VYrhTalplTGQiKipdppu2qLGUNT6ZQAymNUu001lqirleolWp2aoN1Pkl2N0S7amqHdTvOrD6vLsIm2mjbTPOGz+Go/O+T7y1ccLN9CLSHSLSMtRrcJ/Gy1BJfQxf7X+7XfSy6r0izWNKb6Fny99Hk1Q/tSH+7JS/bN33IHFdccjxXSJr7CqaPl1LVWOS8dPktJt3+41SR2PiGf/AFdi/wD3w1aUuHMVL4iJUv5mvvJfIT1pdsdX7fwj42uf9Tpsrf8AAGrp7f4S/EW7VXh0S5+b/pm1aTyHk/iVEvmc86tKPxTRxaqlSKtem2v7P/xOn/5hsy7v720V1Vn+zT8S5f8AXQJH/vSiuWeDwkPjrowqYij0lc8MX5Kjr6ftf2XfHUrr51zaQL/e37v/AEGurt/2Tbz/AJfNdiX/AHI2Ncbq5bS+KqnfsYfWl2vc+MF+/TfMSJ99feln+yXoif8AHxrtyzf7EC/+zNW1D+yr4DT/AI+b68n/AO/a/wDstZ/2zlEerZp9a8nY/OiS6h31BJff8Cr9PrP9mf4Swf67T7i7/wCu07f+y7a7LT/g38K9K/49vC+nM396aNpj/wCRKynxTlUfgpN2OqOMXZn5ILJeP/y6NUq2uq3PyJaP/wCPV+xkPgvwZB/x7aJp0f8Au28dasej6PB/qbKCL/djUVP+u2Fj8FD7xrFVfsxsfjja+DfFt8my20udv92JjW7b/Bn4hXn+p0S7/wC/Egr9g44bZPuKq/pU25P8msP+IiTX8Okka+1xHdI/Ji1/Zx+JVz/zC5ov95cV0Fr+yn8RZ/8AllBB/vuq1+ou402sZ+ImM+xFL5C58T/P+B+cVr+x74s/5fNQsl/4G3+Fbkf7Ht//AMtNUT/vlq/QPaaburl/1/zLuvuIl7d/bPhGH9j+H/l51T9K6C3/AGSdBgT/AI+2l/3xX2dUq1z1eNsyl9szlQqS+Kb+8//S+Xfh74LjvLaDVbaTz5ZP7v8ABX3F4L+Htt4c03+2/EE66bAv/fTVdm8K/Df4fak3iTwrH+9ufvWaf8e2/wDvov8ACa8F+JHxWed2e8n8z+5bofkSv17i3xHxGZTWCwCsnu+x+OYPIKuZ4p4jFXUFsnoegeNviVC1s1nprf2fpMf/AH3J/vV8jeKvH1zfbrawk8u3/vd2ri9c8UalrM3nXMv+6q/dFcwzf368vLOHKdD36mrPu511Sj7OlsiSSR5fn3Vn3E3lfcplxcbErF8x5Xr6/D4edX3eiMqFDm96QSSO71pW9nuTf/FSW9j/AB12un6Hc3m3yfu197k+Q89tAxuOhSW9kZNna3Ny8cNtH/vV9IfDf4U6rrl4sdtH5n97d0T/AIFXXfCv4Q3OuTRu6+RZLjfNj/PzV9z6Houm+F7BbDSoFgVf4v4m/wB5q6eIOKqWW03hsLrN7vsfnePzWpjW6dLSK3fcy/BPgXR/Blmvkqs9+y/vp2Xn/dX+7XZyTb6p+dU0a+b/AMC/8e/3V/ir8SxWInVm6tV3b6s3wWHhBKEESrViOF5X2IrMzfwqvNTXC2ei2f2/XrlNPg/uNzPJ/urXi/jb43W2j20kOiN/Y1l/z8zf69//AImvmcZnkU+Skrs+qwGQ1atm9EexatrHh7wnDv1u5Vrr+G0Rt0rf71fP/jz43JBbS+ddppGnf8+6f616+NvFXxuv7yaSHQf/AALuPmf/AHlWvCtQvr/VblrzUrl7mVv4nO6urBcM4vG+9iZWXY+hpywuEVoK77nuHiz40Xmp7rPw6v2SL/ns33z/AMB/hrxC6uJrmZri4laSVv4mbJqlH8lKzV+h5XkNDCW9nHXueXisfUqy956D91P3VRZqPOr3zj9kXPMpu41W8x6XzKBezJt1NaofMo8ygv2YSNUTNvp7fPTGoNEMptFG6nY0GbqKKZVGo+jbT6dtoIG1KtFSKtBlKQm2rEa06OPfViONKDmnVGqtO21Jt/uVOsf99qjluc8pkSrU3l0/akSfPItG7zfktlaRvpurspZXUnbkVzO5E0dSbUSunsfBusant2R7d35/9816boP7PPjPVZl/0G48pv7y+Wv/AI9Xpf2RTopPETUV5s4Z5ph4+65a9lqeDyTQxVct9P1W8dfJtn+b2r7/APC/7I9t5MF14hvfI/2IBuf/AL6avfPC/wAD/AHhr/U6b9tl/v3J8z/x3pXiYjijJ8LfkvNrsrIw+v1JL93Dfqz8xvDfwt8WeIZvJs7S4n3f3I2P/j1fRPh39knxDcpFNqvk2n/XZ8v/AN8rX6GW9rZ2cPk2cCQRL/CgVV/8dqz89fK4zxExD93DQUF97I+p4ir8creSPmDw3+y/4V0p1m1W7e72/wAEKeUn/Am617ZovgHwb4e2/wBlaNbQMv8AHs3P/wB9NXa+XUnl18hj+IMbiv4tRvy6HXQyalHW135lVV/uVLtNP20V41z1aWFhH4FYZtNG00u6jdVG1hlFPooNBm2nbTS0UAFMqTbvp628zfwtUc8URv8ACQUzaa149Nf+P5f+BVh614q8K+F0/wCJleozf3VK/wDj392uSePpx92932R2UMBVqy9xEvku1XF02bZvm22y/wB6Y4r5q8WftSeG9F8yHTZbdf8Arivmyf8AjtfLfiz9pzxPrnmpYRN/vztt/wDHVrWksbXt7KFk+rOyWX0KGuInr2R+j2qeKPBugp/xNdSX5f4VrxXxJ+1B8N/D3mJYfv7hf+Bf+OrX5na14o8Q687PquoSSbv4E+WP/vla5raiV72F4Qq1dcRP5I5p5xhIfw4XPsLxZ+2F4h1jdbaDY+Qv9+Zto/75WvmLXviB4z8QzNNqWqTbZP4E/dj/AMdrlmZKi/4FX02D4dwlDaN33ZxVc+rz0hovIcvzfO/3qcdlQtNVdpq9pQUdlY8eUpzlzNk7NGlRSSVXaSo/nl+SGJmqva230NoUC1uprTf8BqrcXVtbf8fk6x/7Ktl6xrrxBbRf8g2D/gb1yfWJv4FdnXQy6cuh0f75P4f+++KguNQsLT/j5uf+AL/8StcVNfarqcn3n/3YflWpbfRf+fqXy/1NctXD1p/xJWR6kcBSpazepozeJET/AI8Lb/gTVnyf23qcf75m8r/vkVsW8NhZ/wCpj3N/fekmutn/AC38v9K0pQwsPM0Vf/n3H5szY/Dr/wDLZttaUdrYW6bE+ZvzrMbVoU/6b1Wk1h3/ANTAsVdf11r+HG3mV7CrP42brL/s/wDfRp6wwxf66VV/8drmVm1K5/1O/wD4AKmj0W/l/wBd8v8AvndWUo4qvu7FfV4R+NmrJqlhB/F5n+7VWTXf+eMH/fVTR+H4U/10u7/d+WtCGxs4vuRr/OtqWVfzs55VcPH4Vcw47jWL7/Ux/wDjv/szVYXw/fzv/pkir/wLP/oNdHufZSeY/rXTHBUonP8AX5/YSRjr4ftoP9dK0n/jtXls7OD/AFMC/wA//QqmZqdW3JFGE8RUl8crhupVZ6SnqtXKRzMVd9WqgWp6zMahPtNNp2402tIHOC0+hVp201sBFRUu2jbQFxtG2iigBm2jbT6KADbTNtFPoAFp1C0+rIGVNTKlWokZykNopZG8qommh/4FXZQwlSr70VuVGLfQkp22Oqq+dK6pDGzVsW/hnxJd/wDHnp9zJ/uxsa7P7HrPrYc7R+OVjO3R0xlrsofhj8Qrz/j30K5X/eRhXT6b+z78VNT/ANdpvkL/ALTqKf8AZtOHvVKqRP1il/OtDyPc9G7+/X0hY/sr+MJX/wBPu4Lb/tr/APErXbWf7Ktts/0/XV/4CGNc7q4CG9a/oYvMqOyZ8ZeclQ/aki/1zV982f7LvgyL/j51a7k/3FVf/Qq6C1/Z1+Glr/rvtNz/AL7r/wCyrURzfKovdteSH/aMP5WfnV53yfudzVA39pP/AKmBmr9SbH4O/Dex/wBToUM//XYs1dLa+B/CVn/x5+H7GLb/ABeQv/s1RLibAR/h0n8wjj5/EoX9T8lIdF8SXz/6Npszf7qMa3bX4Z/Eu+/489CvJP8Adiav1uhsba2+S2tki/3EUf8AoNWdsiVzPjOEfgor5u5r/aeI6QR+V9n8C/i7ef8AMCng/wCu21a6ux/Zn+KNz/rvItv9+Va/SylXfXNPjit9iCRX13ES7L0Pz1h/ZH8YT/8AHzq1pF/303/oNbtr+x3ef8vniKD/AIBE1fd9Orn/ANeMw6SS9Cva4j+Y+OLX9kPRYv8Aj51vzf8Atn/9lXTWP7KvgmD/AF13cy/98gV9P0Vy1eLsyn/y9f3HPKFR/HNs8Msf2b/hpbfO9k8//XST/wCJrsLP4P8Aw3s/9ToUP/AyzV6RHvqXd/tV5VfPMZP46rFHBQfx3fqzkIfh/wCDIP8AU6JaL/2zWt+30XR7P/jzsreD/cjUVoNRXBPF1ZfFJv1Omlg6EfhREqov3I1/JalptFZHTTw9P+UXan92n/JUe6mbqDTkhHoS7qeslV91LuepsQXKNxqDc9KrPU2CxNRRRUlRG1JtNR06gq4UUbjTd1Bd4hRSbjS0D90KdTaKCh1TVXp1AvdR/9Pw/wAVfHaz8T2zXlhGy3Uv/LHG0J/u189X2pXN9NJNN95qx12RPvSpfv1+yYTJcPhP4a3PmMVjJ1fTsTrVa4uESqtxceVWTJI8716uHws60/d2MaGFvrLYfNN5tWLW337d9Qww16Z4f8LvqKR/L96v0/IOHlpKeiDMMfTw1Pmk7If4d0X7Y6p/DX118K/hDNqPl3+qr5Fkv5v/ALtdB8J/g/CltFqutxfuPvInTf8A73+zX0+sltbIsNsqqq/LtVfSvL4k4rhS5sLgPmz8txeMqY2b6Q/Ms2sNho9mtnZxrHBEu1VWka4837jfKv3qjsbO81d/9Di8xf4nbiFP95v4qh1bxV4Y8HJ/rE1bUYv+/EX/ANevw/MM7oYZu7vI97LMkq17RhGyOnsdLf7N/aWpSJp9gv3pp+P++Vb71ch4i+KmieHodnhtV83+K/ufv/8AAV/hr5b+JHx6825l867+13X/AD7o3Cf/ABNfKHiLxxrfiOZvtkjRwf8APBG+T/gX96vm4YPHZtP+WB95h8LhMBD3tZHvPxA+OzzzXP2CdtSv2/5bu2U/76/ir5n1bWtV1y5+2ardvcy/+Oj/AHV7VmyMj1Ezf3K/Qsm4aw+Dhtd9WzgxWaVK/kuwNUMtEjVCsn9+vpuaxxRiJTGan3DJFt85lXd931qKtaFVS1ib27oKZRTK6zUsUVFT91WYjqa1FG2gCNmpv36ftpFWn7pY3bRtNTUm00guVaNtWfJp/k7aov2hArVMtL5eypV2VcaTlsrmcpjVj30/y9r7Kljmh/1KNuaugsfDuq3yf6NbN81erQyOrNc+yOWviFS1m7LzMVV2JRvf+5Xs3hn4G+NvEr/6NYzMv97Yyj/vpq+h/C/7IusS+XNrdzDaL/30f++azrSwGE/3iqr9up41XOaCfLT95+R8QQ2d5Lt8mBpd1d5ovw117X9qRx3HzfwQpuav0x8N/s7+A9B2vcxtqEq/3+E/75WvadN0XR9GhWHTbGG2Vf7iKK+axfHuBof7pSu+72OL6xjav8OPKu/U/OTwr+ynr195U15ZfZl/6eX2/wDjtfR3hn9l/wAM6VGr6xc/af8AYhTy1/76bmvqBm30bTXyOP47zLEe5zcq7Ir+yJ1f482/yOO0PwP4S8Nf8gfSYIJP+em3c/8A301dZtNSqtSqtfIV8VOrLnqNt92ejQwFOCtFWRAq1KsdTLHTttc8pnfCkQrHUirTqfUXOmMLDKKfTKZYVEzVLUTURAiop3l76etvI/8ADuq7xQEVFaDWqWaedeSpaL/ec7a5TVPHHhvTd32b/S/L+87v5UY/4E1crxkOblWrO2hl9WfTTzOgjheX7lTyW6Wyb7ydLZf+mzKP/Ha+VvGH7UHh7TfNtrPVFkl/546cnmf99SdP/Hq+Z/E37SXiTVZG/sq08jd/y2uX8x/++V4rqpYTG1/4cbLuzf6rhaXvVp6roj9IdQ8aeGNH3fvGuWX8BXh3i79qDwxoCTww3tvJOv3YYP3r/wDjv3a/NnWvGHifxD/yFdUnni/54q3lx/8AfK8VyLQpXt4XgydX3sRP5I5p55h6X8CN/Nn1J42/as8Yaz/o2gx/ZI2/5bXDtI3/AH7X5K+d9W8WeJPELs+t6lNd7v4Wb5P++VrE27ars1fXYDh/CYZe5HXuzzaudV6vWy8i2smyjzKoNNUf2ivV9nHseVySlvqaHmVE01Z7Tf7VRfaP9msJ1eXrYuOHLjSVHuqncXSQJvmZVrBuNehi/wBT8zVw1cfp7mp6FHAVJbI6JpKz5r6zi/10+3/ZXlq5G41S8uf9mqy2/wDz2bbWcKlWZ7NLKlH3ps6ObXraL/j2g81v7zn/ANlqhNrWsXnyeayr/chG3/0Gs7/Rk/2qn/tB/wDliu2tvYfNnbGhCPwRuPh0u5k/2f8Aeq6tjZwf66XdVXy9Suf7+38qni0d/wCOVV/WuqFCp6Izqz/nl9xdbUrCD7n/AI7VKbWN/wDqYtv41cj0WH+ORm/StKHT7OD7kCt/vc0fUodzkdehHzZy6tqVz/qdzf7i1bj8P38vzzfu/wDe5rrfO2/w0jXFX9XXYxnmU/sRsYy+H7aL78rN+lXYbOzg+5Av/oVStJSbq6Ixsc8sRUl8TJPMm/v0i0ypas5xu3/ap1N3U6i5IbqfTKfQBFQtDUxaoCWnq1RbqduoILFPVqip1ZGUixup9RU6rjIxlEf5lHmVE1FdFwsSM2+l3VFRuqgJd1FRUVF4gS0bqZRtp+0iAU+oqdVASK1O3Uyn7aXtIkkkVW7eGaeZYYV3MzbVX1LVSX5Km3eV8+5l/wB35a56lXflZnKJ9JeHfg/4euba2uPE+pNBLJj/AEeELlf73zf7Ne06X8NfgtoyK/lw3sv/AE8818D/ANoal/z9y/8AfTU6TVtVf/l9m/77avDnDMn/AMv7LstDo9hQfxpn6UW958MdI/487K0g/wByCNa1o/HXgOD/AJeVX/dbH/oNflx9svP47l2/4G1Qfa7n/no35tXJUyfF1fjqsI4TCfyfez9UV+IHgb+C5X/gR/8Aiql/4WB4M/g1CFf+B1+VTXlzUX2i5/56Sf8AfTVP+r1f/n6bwoYX/n2j9VpPiJ4M+4+pW/8A38qFviF4G/5/oP8Av5X5ZfbLn/no350zzpn+/K351X+rVX/n6dEfq8f+XaP1RX4jeD0+5qEH/fa1OvxK8K/wahbf9/Fr8oJGmfrO/wCdIvnJ/wAtW/76qf8AVet/z9OiNfD/AMiP1hX4leGP+ghbf9/FqdfiZ4V/6CEH/fxa/JZmm/56NTf3n95qz/1Wrf8AP019thf5T9c1+JXhL/oJQf8Afa0v/CzPBn8epW3/AH9WvyLaR/8AaqLdN/eojwtX/wCfpXtsN/Ifrz/wszwH/wAtNWtv+/i0q/EjwH/0F7b/AL+LX5A7n/vUn+k/89av/VSv/wA/SufDfyH7D/8ACw/BP/QXtv8Av7HUy/EDwT/0F4G/7ax1+OyyTf8APRqd5k3/AD0esHwpX/5+i9th/wCQ/Yn/AITzwf8A9BCFv+2q09fG3hVvuXsLf9tVr8dVuJk/5bvU8d5eP/y3f86zlwtW/wCfoe2w38h+xC+LvD0v3LlP++1NWI/E2gv/AMvK1+Oy6hqUX3Lub/vtqsLrGsJ/zEJv++2qP9XMUvhqle1wj3ifsL/wkGhf8/a0n9u6F/z+LX4//wBva3/0EZ/++jTP7e1j/oJXP/fxqX9hYv8A5+GkfqX8p+wy6to/T7StO/tLSn/5ea/Hj/hJtd/6CVz/AN/WqZfFXiBP+YlP/wB/GrT+wMb/AM/Eaf7H5n7DrfWH/PytO+2WH/PSvx1bxd4h/wCglc/9/GpV8WeIf+glP/38aoeR45fbRdsC+h+xP2yw/wCelNW6sP8AnrX49/8ACXeIf+gjP/38aiPxhr3/AEErj/v41YyyfG/zoPZYL+Vn7E/arD/nvVhbqz/561+N8ni7xD/0Frn/AL+tTV8deLYvuaze/wDf9qUcmxv86H7HA+Z+y/nW395mpvmJ/tV+Oa/Ebx0n3NdvF/7byVZ/4Wd47/6GC/8A+/8AJ/8AF0f2Njv5hShgz9hd0f8AtUeZD/e/lX49f8LQ+IX/AEMF/wD9/wCT/wCKpV+KnxF/6GK//wC/8lP+x8d/MifZ4HzP2Fzbf89adus/+ey1+Pv/AAtr4kJ9zxFe/wDf1qd/wuL4lp/zH5/5/wDoVT/YeZfZkg9lgn3P1+3WP/PylHnWH/P3D+dfj63xq+Jy/wDMZZv96JT/AEp6/HL4kJ/zEEb/ALZLU/2Nma6JmkcJg+7R+v8A5lh/z92//fdO3Wf/AD9wf99ivyD/AOF7fEX/AJ+bZv8AegWrUf7QXxFi/is//Adan+yM17I2+pYL+Y/XLbD/AM9Vb/d5/wDQaNyJ/wAs3/74avyZX9pL4kJ9xrRf+2FM/wCGjPil/wA/dt/34qf7KzPqkTLA4T+Y/9T87m+Sq011sqpcXD/cqt96v6EpYWdWy7nzVLD/AGpDmbzauR2/8dNhhr0Xwz4PudXmi+X901fp3DvDiUPaVXZIwx+Y08PBym7JFXwz4ZfVZovlr70+E/wjjihj1XWI/wDR1+5D/fq38K/hDbWMMWpalH/uJ/er6UvLqw022/0mVbKDb/wN/wDdWvkuNuPKdKDwmFdkt2fnF6+c1fdT5Ft5labzn22dnH5sv3VRP8/LVLUJvD/hpPO8T3K3d1/z4QN8n/bRq858UfFiHTbae20dv7Ptf43/AI3/AOBV8d+MPi1NdzNbaP8AN/emfn/vmvwyePxWMfJh1Zdz7nB5HSwqVSs9ex9I/Eb48SRW0lt56abZfwWlt/H/AN89a+QPE3xI1jXP3Nmz2Nr/AORW/wDia8/uLia8ma5vJGnlb+JmzUO6vZwHC1Ol79bVnRiM3n8FNWQ2Nfvb/wDeqFmo3VFX11P3dtEeZv70mIzUtSKu/wC5t/2m/hrKvNWtrb5Lb95P/e7Vx1c115aauzuoYVz8i7IqRJ50zeWtY11rn/LGwXb/ALb8t/wH+7WLJcXN4/75t1X7fS3f/XfL/wCzV0UcJUq2lVenY9OFCFL4jOVZp3/vVvWquieW7bqn+z+UmxFqRY3r6ClThA56+K5vQKZVjy6btq7nFGQyn07bT1jencm4yin7aKokZRT6k8unYLkW01KsdPj8nfsrRj0u/uf9Su3/AD/dr18JlFfEPRWXcynVjH4nZGX8i/xUrSQv9z5v92vVPDfwZ8SeJ3X7HaXE+7+LZtSvqPwT+yr5G3+3p1i/3PmeunFUsvwUebE1VddFueViM7oR0p3k+yPhix0e/wBTfyYY9v8AtMGFel+E/gr4s8R3ipbafNer9MR/99NX6XeHfgv4A8POs0Omrdyr/FP83/jtetW8NtbIsNtGscS/dVFwq18zi/EShQXJgqV33ZzxxeLq9OVP7z4r8M/siw74rzXruGy/vW8C+Zj/AIFX0p4Z+EPgbwxHH5Nj9rnX+Of5v/Ha9IVnpw31+f5lxTmGL/i1HbstEL+y6ctal2/Mlj8mBNkMaxr/ALK4qfzHeoFWplWvmGd0MPCK9xWHbaeq0v8Av1Mse/7n+NYymaqBHTtpq2tjct9yBv8A0H/0Kq15daPpX/IU1K2tP9jfl/8AvnrWXt4nfSwVWXSyDaamWuNvviJ4Ss/+PNXvW/4DEn/j3P6VxeqfGb7N/wAu1pZf9dn3H/x7b/Kuulgq9X4IMmrGnS+Oa/M9porx/wAC/FSHxVrEmg3Mc8jNult71IG+zt/0zZlXC167WNbDzpT5JrUmlWpyV4O6H0yn0sa1jc1uR0/bVz7OkSedMywRL/E5wtcrqnjTw3pW7959plX/AIClctXFRidtDAVquy07m8sLt8lWmtYbZd95OkC/7bba+V/F37UXhvRfNs7e7haf/njafvH/APHf8a+V/F37SHirWZmTTY/s0X/TY7v/ACGvH/fRat8Ph8XiP4cbLuzq+q4eh/Hnr2R+kupeNvCui7vme5dfwrwbxl+09oOkJJDYXsMcv9yBPNm/8d/+xr84de8Z+KvEabNY1SeeL+4r+XF/37j21z0ap/dr3MNwfVlb6w/kjlnnmHpL90te59KeKP2kPEmsNImmwbd3/LW7bc3/AH7Vv/Zq8L1jxN4h16Rv7b1Ke7/6Y5xCP92Nfkrntvzf7NDV9pl+R4fD/BFHg4vOq9XroS+ZsqJpKi3VC0let7OJ5UY3J/MqOSRKqM1QySUnM3hQHSTVTa4p/wB9KpTXFhbf8fM615eKzelSvrdnsYXATlsiTzN9VmuEi++1Yd14kh/5dl3VzlxqFzeff+WvFnntSq7U0e7QyjT32dRda1bRfc+aseTXLyX7jeX/ALtZK2+6p44f79VS55/xJHfTwtKHS4xmml++26nbTWisNnViNrCL+KvTpVqFP1E6v8qMpY5n+4tXYtNuZfv/AC1px3lmn/LSj7ZZ/wDPX/x6uj6/T9TCdWr9lWGR6TbL99t1X447aL7ke2qv26z/AOei1P8A2pZ/89Fqf7UjH4Y3OKcasviuy1uWnKyf3lqh/a2m/wDPNqn/ALY0f/nnVSzT+aLMvqcuxfVv9qpN1Z/9t6P/AM8TUbeINNT/AJdmrH+14/yMUcvm/I1KY1Z3/CSWf/PozfjTW8RWf/Pl/wCRKcc2/uMP7Oql5qTcayv7etv+faT/AL7o/ty2/wCeL/pXXHMP7rL/ALOqmxup9Yn9uW3/ADxf9Kn/ALetv+eD1E8bP+Vmby6ZqUVmf23Z/wDPI/lT/wC2bP8A55f+OtR9fl/KzP6lV7GnRWS2qWzf7P8AwBqd/bFsn+1/wFqcsw8h/UJmi1FZDa1a/wDPJqauvW3/ADwal/aP91nVDK5vqbirTqxl8RWf/PBqf/wkmm/88Wriq55y/ZZf9jzfU2afurEbxJYf882/75pP+EisP7n6Vz/2/wD3WZ/2NI3t3+1UiyVzH/CRWf8Azxpv/CSQ/wDPOtv7Wc/snNPKJnV+ZR5lcj/wkn/TOm/2/wD7NbRx77GP9k1ex2G6jdXIf8JF/s0v/CQ/9Mq2/tH+6L+y63Y6vzKN1cn/AMJB/sUq68ifw0/7SfYP7Mn2Ou3Um+P+9XK/8JIn/POpP+Eks/8An0ao/tOf8pp/ZNU6bzEqTctcr/wkln/z6NUX/CSf9MKn+1J9g/siqdZ5lOWSuP8A+En/AOmFTL4mT/nlSlmz/lJ/siZ1nmUrNv8A4q5P/hJk/wCeVI3iSH/nnWX9r900T/Y9U6lm2fxULJXJ/wDCQw/886d/wkaf3av+1Y9hyyup2Ow3R03dXIf8JMn/ADyo/wCEmT/nlU/2t5E/2RV7HX7aZurmf+Es/wCmFL/wlkP/ADwp/wBqPsaRyiqb7MlLurA/4Sy2/wCeFO/4Syz/AOfbdVf21NfZuX/ZNQ3PMShZN9YP/CWWf/PpTW8VWb/8u22sv7c/miP+yKp0O6hq5hvFEP8Azzpv/CTQ/wDPOn/bPkw/siqdNujqP5KwP+Eks/8AnnR/wkln/wA86uOeeQ/7Lq9ja+Sk3LWF/wAJJZ/882o/4SSz/wCebUSztGn9mVTeVqXdWCviKz/55fpT/wDhIrD/AJ51n/bSI/s2p2NmlVqxv+EgsP7rUL4isP8Anm1H9srsH9m1Oxu+ZRurHXxFYf3ak/4SDTv8qaz/ALZ5fshHKarNNmqDd/tVS/t7Sf8AIaj+3dH/AOef86P7dX8rNFlNUs7v9oUm/wD2qqf2xpH+c1H/AGlp3/PT+ddCzyHZmn9mVS5upm6q39oad/z0o/tDTv8AnpVf2xB9Bf2dVXQseYlKsiVSa8sH/wCWtSR3lgv/AC3Wonm8LbC+pz7F/dRVb7bY/wDPVad9ss3/AOWi1hHNkvs6E/Upk+6rFUfMtf8Anqv/AH1T/Mi/vf8Aj1P+2KfoJ5bV7Fn5Kj3VF5kP/PSj9z/z1H/fVEc6p9w/s+fYl3Go2ak2Q/8APVf++qTy0f8AirdZxS7k/Up9iORd9M8untGn/PWmNCn/AD1reOcU+5fsJoZtop3kwf8APdajaNE/5aLWn9pw7j9lIk+SmeXJ/s1H/wACqPb/ALdaRx8O4/ZM/9X8zo1q/DDSx2/z16X4N8JzareQb1/i9K/tHIcjhGHtarslrc+UzDMIUKbnN2SJvCfgubU7mLzlr9APhP8AC21sYY9Sv4NsS/d3rhag8C/D3RPCFhFqvif/AF//ACxtu5/3qq+PPi0kUMsPm/ZLWL7tunFfl3H3iS6t8BluqWjaPkMLklfNKir4rSHRdz2DxF8QNH0FGs9HXz7hf42+4n+7Xyh44+LiRPL50/2u6/uZ6f8AxNeJ+KPiRqWq7raw3QW/97u1eZSSeb87tuavzHK+F6tf95imfZyxVDCx9lhla3U39e8Sar4hm338n7r+FF+4tYNN3Ubq/QsPh6dCHJBbHg1as5vmk9QaoakZqTb5qM+5ViX7ztwtKdfl96RMIkTVDNJDBH5143l/7Hd6p3msQwf8eH7z/p4f/wBlWubX7ZqMzfenl/vVye/V+F2R7GHwX2puyRcvNYmuU8n/AFEX93/4qobXTbm8/wCma1s2eipB89z+8b9K2dtd+FwkKRVbHxp6UzPtbGG2+4vzf3qtSLUzU3bXonmSquT5pO5Dto21Y203bVxkT7QZtpm2pdppaom4zbT6WT91SedCn/Aq7cPhKtVpQV7j97sM21FJIiJXX6f4R1jVUiuYV8iKT+9/8TXtHg34D6lrO14bJ7n/AKbT/KlfQLKKdKHPiZqKXc87EZ5h6Xut3fZbnzTaw3N98kNszfpXZ6H4F17VbnybaCadm/5Y26M1foH4P/Zp0ex/0nxI3n/9MLb5Yv8AgTda+gtH8P6D4eh+zaPp8Nov/TFNrf8AAm/irx8Vxll+EvDCQ533exh/aGIq/DGy89z4X8F/sy+J77bNrHk6TB/trum/75WvqDwv8D/A3hza7239oTr/AMtrnkf9+69h3SU7y6+KzTi/H4zSU7LstjH+z1PWo7sis7Wzs4VhtoljVf4VGB/3ytaSt/c+Wqi/JV2GGaf7i7q+Rqy3cmd1HDwjpBC1NHV9dNaBN95Ilsv96ZlX/wBCrJvPE3g3SP8Aj51JbmX+5b/NXnVcbTXW56MMFVl8KsXlWrcNq8v3FZq8t1b45eEtIT5LaGP+695Osef+A/erxTxF+1lDFuh0pvM/69o2Uf8AfyX/AAqaUcRXdqUG/M2/s3l/iSSPsz7D5CeZcypAv95zisG+8WeD9K3edqCzt/dh5/8AHq/N/XP2jPEmpu2yKb5v78v/AMTXld98RvG2rzbHvvsyt/cT/wBmr6HAcGZliulkayq4Kh8crn6c6l8bPDemIz21jD5S/wAcz14h4g/bC0qzdrfSpUuZ/wDnjabW/wDHq+NbH4e+IfE95F9pkudWln/5Ybmk/wDHa+pvA/7J/npHc+JNmnxf88YeZv8Avrote7LgrL8B+8zKtfyW7POnxdS+DDQu/wAjhtW/aU+IviOb7LD9piWT7ltaDa//AH0vzNXoPhHwL8ZvF8P2l4E8N2sn/La/Lec//bH7/wD31X1p4T+GfgzwZCqaJpsMcv8Az3b95M3/AG0bmu48z+4teVjeJcLS/d5fSUV3e7OKU8ViP48reSPBdF+AthbfP4k8Qalrcv8AcR/s0P8A3zH8/wD49Xo+m+AfBmjf8g7RLSNv77R+Y/8A3026u6FvNL/DWXfapomlf8f98rMv8EPzN/47XyWLzqpL3qs2d2Dyi+0bj1j2fIi7V/2f/iavQ2c3+6v95uK8c8TfHLw34atpX/0ey2/xXL/f/wB3b979a+SvGX7VWpam8sOm75/9v5oof/Huf/Ha4qHt8T/Bi35ntQy2nS1qux+g99rXh7Sv+Py98xv7iV5J4u+P3hPwqjf6TbWjf7brJN/3xX5leIviZ428Ru32nVpLSJv+WNszR/8AfTffP51wTQ+Y+9281m/iavp8FwfVq61p2XYied4Wh/CV35n1142/ai1LVZpYdHje5X/ntP8AKv8A37X/AOxr5z17xp4n8Q7v7S1KaSJv+WCt5cf/AHyvWuV27Epm6vq8HkGHobK789TxsXxBiK+l7LsiTd/sUjVB5lRtJXp8kUeFyyZYaoGbZUXmUm7dRz8pUYEjSVHu3U/y/kqJl2ffkWP9a4cRnGHpfGzuoYKpPZCNUW15fuK0n+7WNeeJNKtP+ntv++v/AK1cxeeKtSvPkt/3cX5148+IZy/gR+Z7uHyKW8nodxcSQxJ++lSL/gWf/Hulc1ceJrCD/Ur57VybQ3lz89zIzf71L9lRK4/39f8AiPRnsUMHSpebLF5rV/ff9M1/OsfyXb79anl0m2uilgKcfM6/b9tDM+z0eXWn5dO8muqnShHaJP1gy/Lko8uStpbGZ/4atR6TNWnsoPoTLFQj1Ob8h/Wl+zvXXrpdWF09K2+r0v5TllmiOOWzm/u1OumzPXY/Y0qRbeto0KPYxnmvY5RdFm/vLViPQXf/AJaV10dvV2O1raPJ2OOebVTj/wCw4f45Kn/saw/vSV1MlulK0cNS59kX9an/ADHNLodh/t/99U/+xLD0lrezFTt0NZ88+xnLEVP5jA/sXTP+m350n9i6b/02roGmtl+/Uf2iF/uLWsfa9hfWJ/zGGuj2H+3/AMCanf2NYf3f/H62GmT+7UbSIn8NV+/I+tz7mf8A2XYf88/1py6fD/d/WrH2yplmf/nnR7HEdivay+2yFdPh/wCedSfYYP8AnmtP+0S/886b9of/AJ51McJiexPMu4n2GGmfY4f7tP8AtD/882o+0P8A88/0q/qmI7Bp3KrafbP99dtNbRbOrv2p/wDnnTGupv7tH1fF9DWFa3UzZNDsP9uoG0Oz/vPWrJeOv/LKo1vt3/LOq+qYr7Suae2qdGY/9hWf956a2gp/BK3/AAJa6BrpKb50NxWfsKvWOhX1if8AMctJodzF/tVmSWcyf8smrv8A7P7UeTU867XN4Y2fXU84aF6Npr0T7PD/ALNNbT7Z/wCFf++an912N/7R/unn6tR5n+zXcNo9m/8ADVCbRbb+D+dR7OkX9dh10OU3UVvtob/wSVWbR7mr+pfyM29vT7mZ5dHl1bmsbmD79Vdr0pZfXLjPsw8uplhqPzJKFm2Vx1cPUj8SJ94c0NJ5aVL5yPUm2OuaU3HfQjmf2it5NH2f2qwsdP8AL31l9cDn8yi1v33VH5daDW6NT10/f/FXTSxUC/a+ZlbaNtbP9mp/eqRbGuiM4SE8REwqNtdAumpU39ne1X+7I+tROdWOT+7S+S9dOtj2qT7FWfumf1s5VbV6Rrd/7tdZ9jo+x1UZRJ+uS7HJLbu38NO+xvXWLapS/ZUp80ewfXn2OQ+yyU3ya6/7OlN+xx1P7sccbLscl9nejyv9muo+xp/dpPLqowpdh/XTmPs/+zTvsvtXS+TSeTV+yh/KV9aZzn2Wl+y+1b/k0eXU+yh2I+tyMP7E9Itm9byx1J5dLTsL65IwvsT/AN6m/Ynrf8ujy6kn67M5/wCwPT/7Pf8Av1v+XTGjoD65Mw/sf+1TPsb1veXTfLp+72NPrM+5g/YHpv2J63/Lo8ulyx7D+sTMD7E9J9jet/y6PLo5Y9g+sTOd+yyUv2N63vLpdtT7Kn/KH1uRg/Y/9mj7HW95dRtHWns6P8qD63IwvsvtR5Mno1bfl1C0dHsKPY0+tGV5T/7VHlvWi0dCx0/qtL+Ur2xm+XJTdr1qNHULLS+r0u1io1Sjum/vtTt0399qubTS7aj6rEr2h//W+SPC+ipqrxzQru82vq/wrY6D4Ctvtnl/adU/8ci/+yrA8UWfgnwY7X+gxQ6RZf7Um7d/u/3a+cvEHxAvNV3W+lboLf8Av/xv/wDE1+0ZzxJjc1gsNhU4U+r7n5nSyd+19vidlsj2fxx8WP30iJL9pvW/75SvnXVNYv8AWJvtN5J5n/oK1lbpKSuXLcgpYbpdno4rGzq6bLsSbv79MZqSk3bK9uUuU4hd1IvzvshXc391amkW2tk+0alJ9mi/hTrI/wDwGua1DxBNKn2WzX7JB/s/ff8A3mrz3ip1XyUld9zvw+AlP3paI1bzULDT/wDXL9tuv7mfkT/eauXvNSv9QmXe3+5CnCL/ALq023s7m5/2VrobW1htk+T7397+KumhgPt1N/yPS56dBWWrM630WaX57z5a3I4UiTZCu1al+9S7a7oQ5Tyq2JnP4n8hq07bT9tPrU47jNtP20qrStRGJnciamVYqa10m81Pclmy+b/d3c16GFpc01G+/UvnW8nZGbJcQxffq3a29zqH/HtA0n+191a9I8P/AAxmuHjmm2yS/wDTY/IK9p0vwn4J0HbNr2ofa5f+fa3+X/0Hn9Vr08ViMFhLXbk+yOb62p6YdXfd7Hgek+AbzV5lhmkbzJf+WNumXf8ArX054H/Zzv5ds2pWMWhQf897vmd/92P7/wD6DWVN+0N4M8K232PwlpaRT/8ATumN/wDwJf8A4pq8+1T4yfEvxa/k+ZNp9lJ/BDu3/wDfVYf2pmuK9zC0lTXd7meIwU+S+Jnp2R9q6b4d+Dnw3Tff3aapfr/wI/8Aftf/AGal1b48aVF/o2iW0Fl/wHzJP++V+7XzJ4P+EvxC8Y/6TDbPbWUn/Le7fyk/8e+9X0bofwV8B+FYVm8Va3/al1/zxtNqw/8AfVfHZnQwdKfPmFdzn2RwYX2svcwFJerONvviJrer/wDHnc3Msv8ADuO0f8BjWvb/AId614q1Wzaz8VaTcrcR7fJvEi+Sf/eX+Fqqt44+Hvg6H/iT6fp2n7f49itJ/wB9NXmPiL9prTYvNRNQ8z/Ztt3/ALLXgYrMoYiHssHQsuje56uHyLFxnz4qsvRbH1S1i8Hz3Oy0X+9cusf/AI71rBvPEnhXTP8Aj61L7S3923TaP++mr8/9c/aC1W+3f2baNu/vzv8A+yr/AI15Rq3jzxlrn/H5qTwL/cg/df8AoPP61z4XIcbX+N2R6cq2Eodbs/R3Wvjd4V0NP9XAv/XzLz/3zXjWvftUPsZNNnbb/dtI9o/76r4fWFn/AHkzNI395uT/AN9VcWPZXtQ4Pp/8vZXZwVOI+X+HE9o1748eKtTdvsy/8Cmdm/8AQa80vPGnjDU932nUGjVv4Yf3f/16xlkSlWG5n/49o926vpst4ZofZh82ebiM9r1fidkVmWZ33vLuZu7fMT/wJqmhsXlk2QruavXvA/wR8c+L/KmhsfKtW/5bTfu4/wDvpvvf8Br7B8F/s0+HtF8q58Qz/wBoT/8APFP3cf8A8U1eji80y/LtKkk2ui3PFq4utVly09fPofEPhv4a+IfEtysNnaTXMv8AchXOP95v4a+ufBP7MttAkdz4mn8v/p3g/wDZpK+sdL0vR9IhWw0e0htlX+CFNv8A6DW99jk2edMy20X952r4LOfETETvTw/uL8TvwfD1fEWlUd/Locp4d8J+H/Ctn9j0TT4bRf8AZHzN/vM3LV0qrNK+xK57VvGXhXQ0+ef7dL/dTpXzx42/ag0TSvMs7e7WN/8An2tvmm/4Ft+7/wCO1+dTxtSvNtJybPtMJw97KH7xpI+pbhtN0z59SuVg3fw7uf8AvmvN/E3xe8N+HLZpv3McS/8ALa5kVf8AP51+d3iz9ojxbrLypokf9mxN/G/72Zv/AGVf/Hq8JvrrUtZvPt+sX013L/fldm/9C+7Xv4DhTFYn3sQ+VduprPH4LDfArtH2740/astpfMttHnn1D/rivlxf99N/g1fOOufGjxzrkjeTcrpsX/THmX/v43/soFeYbY6jOyvrMFwpg6HS77s8bEcR4ifuw0QTSTT3TXU0jTzyfeld2kdv+BNzULR0eZTd1e/ChCHw6HkVcRUn8bHfcpqyVHLTFk/54xtJ/wAB/wDZq2niIRj7zJp0pS+FErSVG0m+pFXZ++m2RL/tNWVdeINHtvv3Pmf7Kf8A2NeBis6hF+4rno4fKpz6WLjMn96l8t5f9TE38lrj5vHEMX/HnZf8Cf8A+xrnLzxJqt8/+s8tf7qcV5/9r16vwKx7FLIZ9XoelSTW1t/x8XKr/spWLceKNKg/1PzV5q3nS/fZqkW3SuaeHr1fjZ61LLaVI6O88WXNx/x7L/31/wDE1g3E1/qD77mRm/l/3zT1VE/hqyqv/u1Uctpx82dXOofAilHZ1OsaJ9ytCOxd/wC81aUOkv8A7tdvIctXGpfEzC+d6lW3dq6y30lP4/mrTj0/Z9xdtaHHPH/yI4yHS5pf4a0F0f8AvtXVra1cW3hrOdX5nNLEVZHLR6XCn+1VyPT0/girofJhi/u0NNZp/FTjKo/hRz87+0zHW1f+7SNavWi2oWf3EV5G/wBkMalWPWLz5LOyf+tehh8txE+lvUylaPxMxmt9v8NLtWvRNH+D/wAV/Eu19N0afym/jdPLT/vqSvT9L/ZL+It9/wAhW+tLRf8Af3f+grXdUy+lS/i1Un66kWvrF6HzX+5SkWSHfX21pP7G9tvX+2Nf8z/c/wDsq3/GHwn+Gnwi0GC/h0//AISvxXqT/ZND024/eJcXTfxNH/FFF9964Z4zBUpKEJ8z7I1pYWcmuRO3dnw3pOn3mr3MltYRNLKu35U5OD8q/drrY/h34zl+RNPuWb/rk1foj8F/hTbfDzRJ5r/Zd69rL/adRudir+8b+CNeyL/DXpusX0ctzaaDbf6+7+d9vVLaH5pG/wCBcJ+NYT4opYeXKoJ+Z3f2FVn70XZfefltH8C/iXc/6nQp/wDgS4/9CrUtf2cfihc/8w/y/wDfdRX6hsrv/s7qFjrCXGf8sEjWGRVPtTPzjs/2WfHk/wDx+SWkH+9Ln/0Guks/2R9b/wCXnVraP/d8xq+/VWl8uuWpxtiPsRS+Rt/YP98+LrP9k3Tdn+n6383+xE3/ALM1bEP7KfhJPv6pNJ/wCvrlod1TQ6fveuCfGGL72K/1apv7TPluz/Zd8E7/AL00v/Aqn0n4A/CjVZtShsNmoNo1z9jv/JlY/Z59u7y5P9quu+MPxdm8HS2XgH4dR/2z8RvEb+RYWyfN9j8z/l6m/wB3+BW+p4X5vQ/hr8ObP4UeCo/DX2x9R1G7nkv9VvHOftF7N/rG+n92sP8AWjG97D/1aoR91t39Tyhf2e/hpB/zD2/7+NV+P4H/AA0i/wCYbu/FjXtkkdQeXSlxNi/5glw3h3ujydfg/wDDpf8AmEp+TVYX4T+AF+5pKf8AfNenrHT9pqf9ZcX3J/1YwnY8w/4Vb4J/g0aH/vipP+FS+D5f+YTB/wB8V6rHG/8AdrzHxh8SPs2sf8K9+Htomu+L5/8Aj5f/AJc9Jjb/AJb3si/xL/BD940Q4hxknaMmT/qthPisZdx8G/Acv39PhX/drAm+BPgNv+XSvctJ02bT9NsrC8vptSntoUR7u42iWd1+9I237u6otQvIbZ1tbZfNnk+6v/xVehDiHFx+0edPhzC83u6Hg/8Awz/4Dn/5Zbf+ArUbfs4+Bn/i2/8AAFr6Djs/k+f71WY7HvV/604v+c0p8NUPM+Ypv2XfCtx/y/f+Q65TxN+zf4D8GaDfeJ9e1B49L09POm9T/dRf9pj8q19tx2cMELXN5IsEECl3dztRAPvMzN92vze+PHxUm+J+q/YNKn+zeCNCm/cfw/bZ4/vTt/sr/B+fWu3AZ7jcVUVPmuur7IjFZFRoQ57tfPc+X76NP3l/t+zRSP8AuYPvfe/1ar/eavfPBv7Lfj/xLYRarrezQoJ/nSCZWaf5v7y/wmvXP2Wfgmniq/j+Lvi20/4k1k//ABT1o/8Ay3kX716y/wCz/B/tf7tfel0yb/kp4viX2NZwoK/mdUMBP2e9n+R+aupfsi69Em+wvvMl/wBp1j/9Crhbz9mH4i23/LCaT/vlq/VCSOoPLpx41q/agmYf2bV6VD8jrz4F/EWx/wBdp8//AH7aufm+GvjCD/lyZv8AgDV+yO2SpI7FJ/vxo3/AFrojxXSl/EpIX9n4v+ZW9D8Uv+EF8c+d/wAgt5Pwqnq2l6l4em+walpvlX+xJngb78aSfd3L/Dur9ZfiN4ws9B1Sy+HHgbSLbW/iNrv/AB7Wb/6iwh/ivb3+7FH97Z95/wD0K54f+BPgDQdK8nXraHxJrNz+/wBR1S8H767upPmmf/ZXP3F/hWnDi3Cyn/Ddutjf2NeMP3lvJI/G2S+/v2zrVX7RZ/xx/wDjtfsbffAf4V3z7/7GRf8Acdq47UP2Yfh1ff8AHtaeR+Nez/rHlr7r1Mfb1P8An39x+USw6VL/ALNP/sWzn/1M9fonq37GuiS/8g27aOvMtU/Y/wDFVt/x4XKSf8DxW/1jBV/gqr5j+vzXxJo+L5PDt5/yxZZazptJv4PvwNX0xq37OvxI0j/l2n/4B+8/9BriLjwL4z0z/XRt/wACWrnk7muanJNeRvHOIR+OVvVHif76M/3aPOmr0i80nWIv+PzT/MrGmt7b/l60to/++hXBVyKf8p2Uswpy95NP0OPa4dqlW92VtSabYP8AckaD/eqq2i3P/LFkn/3TXFPI6nY6o4ikyKG+rUhuN9Yc2n3kH+ugZarbpov4q8+tldWF9CuSEtmdxHsqVa5KPWJovvruqzHrSV5Xt6sXaaJ+oX6nQNTNtUo9Uhlq5HN8lUse+qsZvBOIqrU6/PVbzKkVq6fa3965yThJFhl2VHTWZ3qOrjV7sixNTqr7ql3GrERUUUVvzjsV2ptWKKv2oyCNak20+il7UBm2jbUtC0e0Ah8ujy6ttUFKMiSvTqt/J/cqu1CmERlPWpFWopPkqebm90okqCRaXdRQoAQ7TTdtTUVqWQ7abU+003y6DnGbaNpp+2n+XQWV9tQtHWhtNRstWVEo+XTGWr7R1G0dOMjaMijtqPy6veXTdprQ19oUvLo21d20baLh7Q//1/gtZLnbHDNO86xfcV3Ztn+7uqwq0m2n7q/c9Psn51VnKYU3y99C/fqGa4trb/Xf98L99v8A4ms51eXrqEKUpS5YlqO1d/4tv9524Uf7zVk3mvQ2f+jab+8l/wCfn/42tY+oahNffJM22Jf+WKdP/sjTbfT5p0/ffLF+tP6rOr8b07Hs0cLClrUd2UvMubyb7zSs1atvpu355v3jf+O1pQ2sMX3F21cr1KWHhT2Mq2N+zDYgVqn201Y6n21ueXKQKtP206is+QwuFFPopxiIZQ1PpjVrCABQs00H762by5V+6392ikat/ZfzK4/xNm88XeJHs1htrloP9pOCaq6L4V17Xv8ATLm5aOBv4mbP/jtZ6/JWtperX+lXP2m2b/ehdd0Tf7ytXdhcV7CD5IjlKcKbhSsn3tc9e8I/DXR/O/56f9N3HyV79pPiD4XfDyFfJgtrm/j/AOXidt3/AHytfI2peNPFWsp5NzqDRxf3LceUn/jtYKw7/nf94395ua8bMPruM92pOy7I440KcJ89Vub89j6v8TftKXOp/ubDz5//AB2Na8Y1b4jeMNY/5e/syt/c/wDimriI4UqauLD5Dh6XT7y6ub1fhhohtw15ePvvJ3nb/bO6o1h21Nu20V7cKSitEeVKvOXxMcq1Iq1HHIjvsq9Z2tzfTeTbQNP/ALv/AMVXoYfBzn8KMJ6XctENqaxhv759kK7Yv+e3RP8Avqvc/APwR8SeLZlf7IywN/y8PxGP/iq+3vBvwT8MeE0gmuIF1C/X+OYZ/wC+Y68zM85wOXXVR80uyPPp1Z1bqjG679EfFHgP9n/xP4v23M0H2a1/5+bgMqf8Bj6tX2T4J+A/gzwn5Vzc239qXsf/AC2uR8i/7sf3Fr3eGzeCHe+22iX+J+P/AB2uG8RfFDwH4XT/AEm7XULqL+HPH+H86/Mc647xWKvTp6R7I+owHClWolUrv79jtLW38xNlnB+6X7u3hP8Avqo76TTdKXztYvVXb/yxhb5v++v/ANmvjbxx+1tDskttE+X/AGLb5j/wJv4a+VvEXxi8ZeJXbZP/AGfFJ/d+aX/vrotfMUMtx2L+CNl3Z9LDCYHCLmqO7P0b8WfHrwr4Stvklgsv+uvMj/7qr979a+RPGX7UWq6y8sOg21xJ/wBN7s+Wn/AY+v8AKvlORXeb7TcyNJK33ndmZ2/4E1R7ttfWZdwRTj7+Id2ceK4o+xh1Y6TXPGXizxC7f2rqk7RN/wAsYT5Uf/jvLfnXJrCkX8K/980/dTGkr7PC4ClQj+7SPna+Nq1vjdx52VC1RySURxzS/Oi7l/vdFrStioUvem7EUsPOWyuOabyqqtcVZk+wW3z39yv+6tc9deMNHtP+PCDzG/vNXi4jiSmvdpq/me1hclnPdG2sc0vzov8ASiSa2s0/0y5Vf93ivNrzxlrd2/7mXyv9ysCZby5ffcyNL+NePPMMRWfke3SyKlD42ek3XjDR7P8A49l+0tXL3XjbVZ/kh/drWDDa/wDPSpvs6L9ysvq/M/fZ6FKhQpfCitcXl/ff66RmqBbV/wDlpWntoau2FCEdkbe2/lRSWFKfterKwu33K0LfS7yX+HbXXCkRPEJbsxavW9jNP/DXT2+kwxfw7q047d6r3Tz6uYf8+0c7Bo//AD2rXh0tP4FrbjjRP4amXYlYzr/yo5JTqT3ZRjs9lXI7fbVjzI/7u6qzahYRf8t/+ALyaUIVar9xXMuQtrDTm2J99q0dD8M+M/FU32fw3pE0u7+PDba+gPCv7KPjLV/Lm8SXP2Rf7kNd39m+z1xElFfic1XGQWkXd9kfMs19Cn3Pmp9rb+IdXm8nRNPnud39xK/R7wz+y/4A8NfvtSg+2yr/AM/L7v8Ax2vbLHSfDGlIsOlaevy/3I/L/wDHq5audZbhfg95o2oYfFVf4cLLzPza8M/s6/FDxL++vLb+zYm/iuX8v/x3rXvHh39kHSoP33iHVmn/AN1cCvsVftT/AOpVYF/2Tuaj7Pv++27/AHua8HFccP8A5dWXoenQ4Zrz/iu3kjxvR/gL8K9FT/kH/wBoS/7Zb/2WvR9N8P8AhvRk/wCJPo1pabf4kiXd/wB9Vv8A2f8A3amW3T/nqtfOYrijEVv4k2e1R4apUvs3ffcqfO9LtqaRrOD/AF1yi/8AAlrj9e+IXgnw1C02papCu1fuqys//AVryKuaTn1PWpZO+iLHirxJongnR7nxDr07RwW2PlQbpJZG+WOGNf4mkP3Vrz/wP4N1vUden+J3xCj8vxBqEPkWGndU0my/54L/ANNW+9M397ivL/DfxY+HXi3xDJ4z+KOofYf+Efu3/sDSfLZo4E/5/Zv+ek7f+Q+1e2aP8evgv4h1K00TTfEG6/vpkt4Ee3l+d2+72r3cL+4g3ytt7uxNfC1L8miSPSWbyEZ9395t3/s1Y2g2M073PiG5X97qG3yV2/NHbL/q1+rffauf8dfEjwN4avF8ParfefLw92lsPN/dL/yzbb/e/wDQa5S8/aa+G9t/yyuZP9nZiuevin9mLZtSy2clf9T2jyH9aX7PXzjeftYeFYv+PPRp5f8AvmuI1D9rx/8Alw0Jf+B//tVyRliKvwQZ0QyufdfefYv2fb/DSeW9fn3q37WXjyf/AI8NPggX/c/+yp3gP9rLxZL4kg03xJoz6tFc5RILCNRP5n8P3mx/vV7GF4czKrHmjT0FXw9KldTmr9j77uryw0qzn1XVLlLKwtE33FxMdsUaD+Jmavnnxh8YtS1LR9Uv9B+0eG/CWlo813rUybb27jX/AJZ2MLf6nzfurNJ8/PCVLe+FfEPxD8zUviVqH9n+HoJvPt9Jt32wx+X/ABXE3/LTb/3zXzz8Svi1ofiPxto2g2Glpe/D/wAKSRXP2b7v9p3kP3fP/wCmWf4f4q9ShlUaVrrml2WyseL7Wcv4bsu59Dfs0/Cm88PWF38ZvGcHmeK/GX76zhm3SPZ6fJ/q0/3pFx9EwvrX0fJvl+/u/Jq+EtW/au8eX02+G2hg/wBz+D/dri7z9pb4oz/cufL/AOALXifUsyrzf7s9OlgsPvUqan6Mtbu1Na32fxL+dfmLeftBfFeX/mKf98otc3cfGL4uX33NWdd396uuhwtmdX4Vb1NKv1KlH3qn3H6sNJZp/wAt0/76pkmpaJp0LXl/e28EEXzO7vhRj/ar8pY9a+IWoI02peILnyv7sLtF/wCPLRcL4qu7b+zdNlnb7X/fladzu/3t22vWwvA+Nk1GpNJHBPN8BH4btn2Zq3xY/wCFn+J7vwD8PfEUXhnQbK236p4gbas0n/TCw8z/ANHflXtXhfw74J+Hvh6LSvDEH+it++ebd5s107fenmm6yM396viLwP8As363qfl3niS5+0/7E373Z/31Xt/i74reD/hdYRaJ/ak/iLWbaHyIbC2VW8rb93dN/CFrXM8rpYO1OlPmfWxhDETxcvcjZHu0l9quofJpVo23++/FaGl+G5rF2ubqXdPL99nb/wBB21+d15+0F8VPO32cltaf7G5mrlLz47fGa+fyf7U8rd/dWuCOQ5lX+BLU6/q+Dh8cz9Wf3cH37mBf941wPiz41fCjwFDv17xFb3N7/BYWX+k3Tv8A3fLj/wDZttflJfeOPij4xv4/D0Or3d7Pdvshgtmbe9fcPwP/AGf9H8CQr4k8VbNS8UXP8b/vI7T/AK5/7X95/wAq7P8AU3EYWCq4+dr7JbsyrY3CRVsOrt9WcL8Uvit8QviFpf77S38KeEpH+Syf/j9vN3+pWf8A+IX5e7V5h8O/hrN8YPHlt4Ds98fh/Qo45/EN2ny/uP4YI/8AamP+P8Na/wAZvid/wluveT4Q/wBL03Sbn7Fpv/T3qE37nzv91fup/s7z/FX358G/h/4c+EngCDwxFqlpceIL3/TNXu/NX/SL2T/WfN/dX7iVpnGcUsDh44eiuW+55lLAVcRPnnrbbsejeTZ6ZZwaVpsCW1lZQpbwQwrtSOKNdqqi/wCzWdJUk1xYI+/7dD/32tUJNW0eBPMe+T/vpa+K/tGH2Wd39k1exP5dHl1xerfE74e6Cnna34isdPX/AKbyqrf989a5uT44aDqNnv8ABmn3Ot7vuTeW0ULf7S7vnb8q9PBUa2Ia5ItruYV8L7JXmeuLav8A8tK+e/il8crrRdSg+GPwftv+Ek+I2qfuUSL95Dp3/Taf+Dcv3tv3V6yeh8q+LniT4kT+GLu81jUk0aW9/wBGs7TzFiT978v/AI6PmZq7H4S658C/gJ4f+z6PqEWu+KLyP/iaatsbfK/92Nm+7Ev93v1NepmWDWEpqdTVvZLYzwUvbSah07nsfwj+Eth8I9Eu/tt3/bvjTxF/pOt6tJ80sszfN5aM3zeUp/76+99PRZoX2b3+Zq+Z9e/a00Gz3f2bp6Sy/wC396vBNa/bI8W6xef2P4M0T7bfz/JDsVpWb/gK8tXg0pYqf8KHq3oet/ZkP4laSSR+hP2f5/n+WvM/Gnxi+F/gDzP+Ek8RWi3sX/Lpbv58/wD35h3f+PYr598O/Bv9pP4qf6f8VPFtz4L0G5/5htg/l3L/APAY/wDV/wDbRm+lfQngf9m/4OfD51udN0JNS1GP/l91L/SZt/8AeXd8i/8AARSpZfHmf1iV32Rz18fSj7tGPzOh+GPiLXvHukS+LNS0l9C0G9/5Bdtc/wDH7On/AD8Sj7sat/Atd1Mtackm/wCSqjR1tSo8vwaHF7Xm+Ix2j2VQurGzuvkvLSGf/fjVq6No6o3Con32relXqRlo7EPD05fGjzbUPh/4J1H/AI/NEtv95E2/+g153rXwP+Ht8jbNP8v/AHTiveZJIX+RPmpF0maf59qxxf3mr2sPnGJj9t/eedPI8LvFanxRrX7MOg3zt9gleP8Au/xVwOrfso3XhzR7vxPr2t22l6ZZJvd33b/+Aqv3mb+7X2j4g+Jngnwh5kdn/wATm/g/ghP7lG/2pK+M/id4+8SfEG5/tLxDc+Rp1j/qLb7sEH+1t9f9qvpsHn2N01suraM/qEI/A2vmfO3g/wAG+LfHWvT6J4ZsZp/It5Lubft/d20X8TN/n5qh1r4e69p7t9s01/8Af2MtfpV+yb4Sh0f4bX3ju8tvKuvGs/8Aoiv/AAabb/LD/wB/G3P+Ve5XWk2Ev34Eb/gNVh/ED94/aQTXQ0xGX1IWdN+qPwruvDbxfwsv/AawZtLuYv4a/bnXPhf4J19P9P0a2Zv76p5b/wDfS15Hrn7Lvg/U/wDkG3c9k3911WVa9SHEeU4rSrHlfc5vbYul8Suj8kvs8yVItxeRfxV+heufsg6wif8AEqnttQ/4H5T/APj1eMa5+zL480zc/wDZNz/wHbL/AOg1p/Y+W4n+DVXzNIZ5D/l5Fo+Y49Umi++u6tKHWEf7/wAtddq3w117SpGS8tmiZf7wZf8A0KuKuNBvIP8AXR1hW4Mr/wDLp3XkdlLMcPV+Fo1I7xHk3+bVj7QjVyDWs0VJ5lzFXz2KybFUPji9PI09hCXws7DzI6l3GuTj1J/41rUh1K2l/wBn/erzZ1pw+NMX1PsX/nqSolkR/uNUtaQx0JdTOeHnHoM3UbqiO+o1kevQhqtzLkLm6jdVdWqWgkfT1qHdT1aggsUm00tFQSPpNsdLUDSVYElM2o9R+ZR5lBRJ5cdLtWmeZR5lL3gBlSmKtP3bqcNlXH4QDy0/uU7y6kp1Y+8SN8ujy6sUzbTAr+XUTVZZqrSVvAoZUEtSbqbW5ZDTakZabWoDaKdTljqCz//Q+D91P+//ALv8TelVLi4htvvyLu/u1z1xqDXP7lPli/u/5+9X7TQ9pX+FWXc+HpYKcvQ2LzWkg+Sw+b/ps3/sq1z8a3N47bPm3fe//aq9b6W7/wCu+X/ZrdhhSJNiV69LC06Xm+51zxFOkrQ1Zm2enpbfO/zS1pKtSrHUm2tvaHmVa0pP3nqReXTttPo3VNznuFS02lWtImbJKKNtS1ZmNplS0VUYgN20ypdtRNW0PiAZRT6K6CxlPWmVMq1LAsxyVfWSsxaurR7pw1UaEc1TbqoRVsWun3l5/wAe0TT124XLqlWfuo4ato6t2RnyTIn36uWtnf3zqltG0m7+7/7NXs3gv4N+IfFEyw2dk0/zfO2z5E/3mr7b8E/s76J4chW88TTwt/sdE/7661nmmbZbli/fSvLstWcVKtVxEvZ4ODk+/Q+JvA/wR8SeKpotlp5n6In+8zV92fDv9nnQfDyQXOtxLfXS/wDLHH7sf/FV3t9448H+ELb7HpUafuP4f9Wi18vfED9qSGLz7OzufP8A+ne02/8AjzdP1r8vzfjnH5j+6wseWPl1Pp8FwftVzCe3Toj7NvtY8MeHYfJmuUj8v+C32/L/AEWvFPGn7RHhvw1C32bybb/amfc5/wB1a/PbxB8XPGfiPcltJ/ZsH+x80v8A31/D/wABrzfyXldpryRp5W+87nJ/76avIwfCVer7+Il8j2Kub4LCrkoRuz6L8dftJeJPErtDpW//AH3LRp/wGOvAtS1rW9cffqt28+7+HdtT/vnvVdVSKo5Gr7XAcPYXC/DG77s+fxee1q/kiOOFIk+7UnmVDSbX/u7q9WrOnSXvux5XJKcvMGkqPdUrQpF880ix/wCz/FWLdeKNHsf9TiSX868HFcR0IaQV2ethcoqz6aGzHa3Mv3Iv+BNwP++mqKb7HZ/PeXar/spya811Lxlqt8+y1Zttc832+8f99O1eRPNMXV8kz6KhkcIa1Hc9EvPF2lWf/HnB5jf3nrk7zxRqt9/9jWWtiv8Avf71W1j2Vy/V3PWbPRgqVL4EUG+2XP8ArpanWzh/j+arW2jdXRDCw+yhSxDfwkawov3FqSk8yo2bfW8aHkZ6sX7tRSNVmGzmnf5K6Kz0WP8A5bfNXVGhb3hSqxj5s5yG1mn/AIa1LfSf7/zf7tdZHZwxfw1YWGtYzj2OSdecutkY8NikX/LLbWgtvVzy6ftqJ1ZSObkj11K+2o9yRbnf5aueXXe+DfhXN49hkuU1e2tlgm8l4G/1397ft/u017PWVV2S3ZtCMuZJK7Z5JNqCfwfvf9mtbQfD/i3xbcrbaDo09yzf3EZq+rdL+GvwZ8AbbzxPd/2zdf3fNWOP/vla6qP9pTQfDls2m+DNGhtoF3f6lAP/AB6uGvxTgqGmGpOb79D1IZPWq9ku7POfB/7IfxI1ry7nxD/xKLVv4JpFjavp3wv+zH8LvCvlzar/AMTS9X/gKV88ap+0t42ufnt4Fg3fxM+f/Qa8z1b41fEu7+5rP2bd/wA8UUV50s7zvGe7SSgvLc6Y5HhI61p83ktEfqJayeHtGtlttKsrbTYI/auc1T4jeFdK/wCQl4gtoP8AZ8xf/QVr8qJNc8beI3/0/W7uVW+9+8aoLrT7C2++z3M/95nauP8A1WxVb/eKjuerhauAofBA/RfVP2hvhLpH/MSadv8ApjGzVwmofteeDIP+QVpdzc/7TfLXwXJDbfwR/wBajWx8/wCSFdtejR4Eof8ALyTO2eewivcjqfWmoftfa3fP5Og6Isf93cd1cjfftFfFq5/1NzaWX+5Fu/8AQq8ltbeHSIfkVfN/iqlcXCSv92u+lwrgIdDgnn1f0O1vPjN8Vrl/n8ROv+5tX/0GueuPiF8SLn/Xa/dt/wBtWrKj/wB2tyz03/ltN8q12/2Tgo/YMJZ5iv5ijHdeJ9T+fUtWvZ1/66tisPVNQhs9yeY27+9/FWjrniSz0z/Q7b9/PL/dro/Afwj1LxY//CSeMJ/7G0Ff9n99L/sxrXv4DK6FKHtakUkttNWcVfNKsvd5rs4bwf8ADvxb8UdY+waDB/qv+Pid/wDUwJ/ekavpa30Xwl8LoY7Pwr/xMvEP/LbWHT/V/wDXtH/D/v1pat4ss9M02Pwr4MtF0nRoPvKn+sn/ANqZv4q82urxYkaaZq48ViqlfyXRdzGEuXzZlao2xJ3mbdPc/e/iPzfeauOkt4at3mofaZmd6x7i+hT79VhMFNvlJq499yXy4ZfvrtqncSQxfcb5qhtbfWNZuVs9KtJp7iT7qoMn/wAdr6T8B/s46lc+VrHjaf7FB/z6L/rH/wDia+hhgqWGSniHby6s82WZVJe5B3bPBvC/g3xV4/1L+ytEgdYv+W1xt/dx/wC0zV99/Dn4P+EvhlYS6lN+/vYofOvNRudvyIv3vmb7tZWsfELwl8NNN/sTwlp/n3q/dtoBuf8A4FXjni7T/jZ8Xf8ARrm0/sTw/Ls323mbXn/3v9n/AGa4sfWxGLtThaEPPdm9CdKl71d3fYyPjF8bJvG00nh7w3P5HhePPz/8/v8Avf7P+zXz7DJs/wBlf71e7Wf7M/irYv722gi/32Nbdv8Asy6lF/x+apbxr/sKzVthcvwWHhye1TOPFZxVm/di0uiPnOTVIYk2bqbD9svpNlnG87f3URj/AOg19b6b+z74b091mv2fUP8AebaP++VrrPsel6BD9j0TTYbb/dX/ANmrWdXCUv4er+4mFWrV6WR8s6b8OfEl4nnX8f2KL/ptW3a+FfKf7NYWz6hIv3vl+WvXte1rStM/0nxJfeWv8MKf/E1x9n4o8T+Kn+weCdLexsv+flx/nbXP9aqT+zp3HKHJLlctewsfhX7Cnna9cw2n/TFPmk/75r1HwXpthBDPqvlQ6Xo1l89zqN62OleZ6xdeCfhpDFqXjPUn8Ra83/LnbN8n/Amr518afEnxb8RrmOHUt1tocH/Htptt8sKf7396vP8AqGKxn8HbuephY06X8TY+g/iF+0Fea48/hv4Xb7LSPuTatN8sk/8Aur/yzWvn1by2tt37z7XO33pv/sqwo7fUrn/RrOB9v8KJXqPhf4L+MPEO3zrb+z4G/juPl/8AHa9DCcJU8N72Il82Tis+v7lLRHBTah/tfNXUeGfBvjnx7crYeHrTbB/y2u5htjT/AIF/FX1N4T/Z58K6N5V5r0n9ry/L8rcQr/wH+KvV9W8YeEvBNhsuLmDT4o/4Pu/98qtFfMqFL3MKuZ+hxQnWq+9UdkYHwv8AhDoPw0tvOtv+Jhrk6fv7xx/30sf91a8S+NnxwfVUu/Afgm7/AHEv7nUdRh/j/vQQt/6E1cf8SPjx4n8Ywz+GPBNpc2mnXP8Ar7lP9fOn93/ZWvHtP8G+Ob5PJs9Gudv/AFzasMPkOLxM/bYnT1Z3fW6NLrdiWNx/ZSR/Zv3bW2fJb/nn/e21VuvE2sIn7nUn/wCAu1em6L8AfHmsf8firZL/ANNj/wCyivW9F/Zh0qDa+t6k8/8Asp8orsr5XlsZXxVm0OhxBXj7mHdkfHc3irxNPN/o19cT/wDA2r0jwv8ACv4u+OJFea5u9Psv+e1zIy/98r1r7s0H4c+APCSb7PTYPPi/5bY5/wB7c1c34u+N3hLwmjWth/xMtRX7kMP3E/3mrysRjcthphKCv3ep6X1/H4hazsjlPCf7OPgPwlCuveLJ/wC0p1/5b37/ALv/AIDH/wDtVa8TfGjQfD0Mmm+CbbdKv/LzMny/8BX+KvnbxN8SPEnjO6+06rd7V/gt04jj/wB1a5Bv+e3/ALNXn8lWr/E0XZGfuQ833JPEniDVfEepNqWt3L6hP/flb7n+7/drm4ftOr3n9laDbXGoXUv/ACxtkaQ/99V9I/DP4b/CXU7CDxD8VPFv7qT7mj2Xyv8A9t5Pvf8AAa+yfC/jz9n/AMBab5PgfTbaD/bSP5/+BSN87Vy4/PKdD3IU22vuOehldeXvx0ufIXw7/Yz8c+L/AC9S8f3P/CN6T/z6J814/wDvf3a/Qn4e/CPwB8LrD7N4J0SGCf8Aju/vXMn+9K3NeZat+0x4fi+5bPP/ALnKV4142/as1uC2kTTYEsfN+5XymI/tDHz+CyfRaI6/qfJ/GkfcN9qFnBNFbTXK+fL9xOrVWavzX+HPx0fT/EN3r2vfadZvbn/ltuby4v8AZr698J/Gqz8T+UnkTTyyY/1MDKgY/wC10rKvlOLwv8SN13RpGFCa/dvU9mprfJ8715146+LXw9+G0P8AxWGswWl6ybks0ZWuH/4DXgH/AA2B8Mbn7/2vbv8A+ee5z/tbVpUMBiq/8CDYRhGPxs+r7i8ml+SzXd/tUQ6TNK++8l3V82Q/tHXOuf6L4A8F6xq/mf8ALaaL7Lb/APfxq0JPDvxU8f8A/I8eIv8AhHdLk/5heifK8n/Xa5+9/wB813f2PXpW9taP5nPLFU72i7s73xR8XPB/hW8bQdHV/E3iX/oG6b+9kT/rtJ9yIf71cNeaT8RfHCfbPG2oJoWk/wDQLs3/AIP+m838VbF9qHwx+BWiN/o0On/9MIfmurh/9purf8Cr4v8AiR8dvFvj3z7DTf8AiSaN/c3bpJP95q9LL8v5/wCGvmyJVf5/uNz4meMPCWkTf2Po8sK2Fp/H/wA9ZK4v4V+B/En7R3iqPR7aOTTfA2kTJNrd/wDd3x/e8hW/vyf3f4f9YayvhH+zl4q+N/iH5J/sXhqzk/4mGqPz/wBsoVb70v8A46vf0r9dPDXhbwx8PvDNr4O8G2CWWk6f/B/E7/xySP8AxM38TVwcQ5lTh/s9J3fV9jrw+H+3JFi5jsreztbDTIFttOsIkhtIEG1FhjXYqhe20VkstX7iR5Xqv5dfKRjyo33Kfk03ya147ersenvL/DU867leyMFYd1SNb+V/e/4FXOfEL4i6F8P5bTQrW1k8ReLtW/d6XoFgR9quN3/LST/n3g/vyv8AhWr4c0fxLaaOLnxvfx3viC9/f3aW3/Hna+kFov3vKj/vN80jZY1UMR7/ACpmc6Hu+8jO1TR9H1WNodS0+C7Vv+eyK1eVat8B/hprG7/iUNaM3/PvIy/+O17p9nSofJr3sLmuJofw5tHl18roT+Janxjr37Ivhu73PpWpPbf7M8at/wCPLtrxDxF+yT4qsfMfTdmoL/07n5v++ZK/ThoarNDX1eC4/wAwpe7Uaa7M55ZPb4JtH4x658FfE+j7vtls8H/XaNlrza+8J6xp/wDx8WMy/hX7tXVrDOnk3MaTq38LruH/AI9Xn+rfDfwTqu77Zo0Ks38UP7uvXhxfg6/+8UrPujm5MwodVJfifiL9nmi+5Vhb66i4dd1fqt4g/Zl8B6vu+zM9l/wFW/8AHq8T8Rfse3ibpvD2rpJ/12Wk8JlWK+Gdm+5tDOpx/iwaPiSHVIX+STcv+9VpZof726vT/E3wD8c+HPM87T/tO3+KDc1eR3Wh6lp7/vo5rb/eRlrOrwbiFrh5KS8jspY/D1vhlqX93m1JXP8AnXkX+1Usepf31rya+ExFF2qRasaew5vhN2m1VW8hlqfdWEKhjOi4/EidZKm3GqqrUu2tLxOaRLuNRNRuoqwCijdRuoAikZ9u9Pmqg1xc/wDPKu08P6ho+mXP2nVbFL3p8j19R+F/FXw3voV/4kFh2/5Zqtefis5WEfv07ruj0aGAqVYc1NXfY+J1uJv+edP+1T/88q/ULR7z4b3P7m2sbS0l/utGuz/vqu0/sfTfL+TS4PKb+Ly15rpw/FuAlvH9Dnr4PF0vipH5HreTf88GqX+0HT/lg1frH/Y+iP8A67SLb/v0tRt4b8MS/wDMGtG/7ZLXof29l8vsM5Ze1/kPyk/tJP8Ang1J/aj/APPCv1U/4RDwr/0BLT/v0lP/AOEF8I/9AS0/79Cr/tbLv5WZ/vv5T8oW1Kb/AJ4VG19/0zav1f8A+EB8Ev8A8wS0/wC/S0q/DnwN/wBAK0/79LWkc3y/sxc1X+Q/J77Yf+ebUfbD/wA82r9aY/hv4D/6AFn/AN+lob4W/D1/+ZdsP+/VP+2cu7MuPt/5D8lPtQ/55NT/ALV/0zav1hb4T/Dt/v8Ahuw/791C3wh+GL/8yvZf98NT/tvL+zNL1f5D8pPtEP8Adan/AG6H+6a/VT/hS/wuf/mV7P8AJv8AGmN8C/hT/wBCpafnJ/8AF0/7Zy7+Vl8k3vE//9H86v7PvJ/+PmPb/t/Ka2LPTYbb5/vN/erTor+goy5VyHwdXGzl7uyIdtPp+2mstRz+ZxXHqtK1Iu+jdvrnnV3JI2pm6nybFTfM21f7zVz11qif6mH/AL7ooYjm91anZQw859DoVkR/k3Lu/u1YWuOtdPuZX86FmX/a6V11us3l/vm8xv72MV30xYujCG0rlinbTRtNSVqeXKQyjbT9tFdAhjVE1StTNprWECokVFP20VqWNVatbajVanj8yX/Uruaqhh5TkZTYm3bU8K+bMttbRvPK390bsf71dx4f8C6rrk0SeQ3zfdTua+rfA/wV8PeHkW/8YXP2bb/y5w8yP/vt/DXp1quBy6n7TFy16JatnnfX+ebp0VzP8jwjwH8K/EPiq8jtrDT3u2b/AGeE/wB5v4a+2vB/wH8JeDNuq+OL2Gef/nwgb92P97u1cv4i+PXh7wdYf2J4Wgh0uKP/AJY23zSf8CavlvxR8ZvE+vvJ5Mn2RZf4s7n/AO+q/O8y4lzPMr08MuSH4tHp4fJcLS/e42V326I+9vEnx28H+DLP7NpcdvaRR/c42/8AfKrXyb4w/aa1vWpp00qPd/tzMyr/AN89a+XZGmvJmubydp5f7ztk075Erz8JwjRi+eu+Z+Z14jiHk/d4eNkjb1rxJ4g8Ru39sXrsrf8ALFPlT/vlawI4UWpd1RM1fUUMPTpfCkj56ti6tX43cl3baGkqFVd/uVDcXVtbf66Ra5cXmlClvLXsdGGyutV+FadyeTelSR2sz/8ATJf7z1xl940trbd9g+auRvvEWt6n/Eyr+VfN4rOcVV92irJ9T6TBcPwSvVfyPTbzVtH07/XT+Yy/w/8A1q47UvH00v7mwi2rXHf2fNK/mXEn9atx2cMX3Frzfqs5+/Vd2exTo4el8CIri+1XUf8Aj4lbbUEenpWo0dOVa66VGnBaIbxX8uhXW3Ral21LTao5ueTGbadtNPooAi21Gy1Y+Sp7exmuf92uvD0Jye2gc9tZaFOOF7h/kXdXQWuhp9+5/wC+a2LOxS3h+781aEcX9+urljHzMXXb8kQ29usSbE+WrCx1Iq1Mq1zzZzkKx0/y6sbaNtJAV9tS7adtNWI1ro9kTcr7TVjS77WNGuZbnR9Sn0+WdPJdoeMp/dapPJpfL2UvZaNWumaUqnK7leSP7Q7TXP7+Vv45DuehY0/g+WrNTLavXRhcv93TQ6ZY+p3uUWX5PnaprGxmvJvnX5asx2rytsqzeahDp0P2aH5Zf4q744KUfdSMvrH2pMuXU0NjD9mh+9XPMvn/AH/4qpRzTSvv3V0NrCmz5/mavUpZXUtsZ/XF3K0On760vJS2Tft/StGGOFPvtTriaHZ8nzf8Boll9Tormn12Cj7zOUuGed/nqGOPe+z71b1j4X8QazN/ods7f7WK7u1+EvieL/lmq+b95mauqlk3/PySRxzzqM/gjc8+j+zWib3b/gPWo1tfFXiWb7Holo/kN9524r37w/8AB+wsZvtOtyfaZf7vavQW0u2tIfJs41gX+FU+Wrf1WhL3dbEwxFSrpax4r4T+Ffhvwh/xO/E7JqF+vzKnUBq1PEHii51f5P8AVwRfKkK/Kq1tatpdzK7ffauFvreHT0aa/ZYNv944rycRilXndu/Zdj16VKptb5mXNcfJvritQ1B7ub7NCryf7q1k6t4qvNc1KPQfCUH224uX2Iyc7j/s19n+E/h7o/hi2jeaDz79sb2b5tr7fm210/V4wgp1FvsjlxdedK0IrVnyvpfgHxbrU3k22mzRq38c37tV/wCBV7Z4b/Z7035ZvE9957f88Yfu/wDfVfQcLbE2fdq19+uSrnPL7kNPM4fqtSq+abK2g6P4e8MW32Pw9p8Nt/edV+dv95qo+JtJ1jxVts01mTS7L/lt9nT95J/s7v4a242T+CrCs9eX9a9/nvr3Z2RoJKy2MTwn4H8K+Dk/4lVo1zdN9+5uT5kjH/gXSu6+1P8A7tYqtVjzP7m6uevW5/fm7+bNoUuX4STVNWex02eb5pPKT7q1TtdSfUNNtrmZf9am5auNHDPCyP8A8tV+7UawwqnyJ8q1y80EveZtGM5OyVzJ1JrmWHZbfLL/ALK15hfeE/GGtOyWDf2bE3/L3cPyv+6td7rnjDwr4aTztY1eC2/2PNVX/wDHq8S8QftLeALH5LOefUJf9hfN/wDHm+WnQzFwf7iPM+nU7XllWqve0X3G3p/wj8H6VN9s1vUJ/EV/9PkrpNYh1S7037BomzRLD+N8bf8Ax6vmPUP2kPHPiW5/s3wToC/vPufJ50n/AHyvFIvwt+MfxBmjm8c629tB/wA+2/7v/bKPalenyZhiLe3fKjmlh8Lh+t2dhpPgP4dXOtto/wDbaazq3zyfZkdf+BV6bZ/C3wfB/rrZv9raag8C/CHwx4C/0mwtvtOo/wDPzN8z/wDAf7or0BdS0r7YumvfW/237v2feu//AL5rpq5xOl7kJ/M4P7Np1deV/Mj03QfDekf8g3TUj2/xbV3f99V0P2ryqj8mSL/Zp8cO/wDeOy151XNPa6zlf5m8MGo7Rscxrn/CQ6n/AKHpVyumxfxTf6yX/gP92uXsfhT4Y+0/b/EP2jW7r+9cy5H/AHzXq26H+OVF/wB6q8l5o8H/AB830Mf/AANaIZxCEeWDsP6lUk9roq2On6JpSeTpul21sq/d2Iq1r/bHVPkVYlrAm8QeFYPv6zbr/wBtVFc1qHjDwfKjQza3A3+z56/+y1P9pKfxO50xyqb1sbureONK0r/j4u13f3E+Y15lrHxcmTd/Ztozf7T/AMVc3rGqeBov9M/te2jX+95q15Xr3xI8H6d+50rdqV038EPzf+PV6lH2cvs3RrHBcvkxni7x14817dbeY1tb/wBxK4Gz8O+IZf30NjNOzf7DV9SfCP4a+IdVvJPG3j/T00+12f8AEu03+P5v+Wk6/wDoNfRMdrDE/wDq0jX/AGUWvWpZnQpe7CCPKxtepflg9EfntZ+AfHmpv/o2lv8A98Y/9CrsbP8AZ78c6x8+pXK2m7+DfX3Qs0MX3F3f8BxStfTfwLto/wBYpx/hwSIhCfL77PlOx/Zv8N6Cn2zxPrM1zt/5d9/lpXPeLPEHgnQ4f7L03+H/AJY2b+Zn/er6J8QeB/8AhKLlptb1KWOy/wCfa3O3d/wKreh+CfBOgbU0rRIfNX/ls6eZL/301Z/2vze/X1f4I0/edJHxdZ2/j/xHN/xSvh97K3l/5e7tf/iq9V8O/AnSrT/ia+PNU/tCf/ptJtjSvqqSx81Nifu/xxWc3g3QZ386/svtf+1MzMP++awnncPsKw6tKtL0PC5vGXw98Mf8S3wrpv8Abd7/AAQabB5v/j3Sqdn/AMNFeMf3PhvTYPA+nSf8vMzL5/8A8Uv/AAFVr6g0+z0rTE2abpsNov8A0xjVa3lmuZfubfz+auCtmPkvVioRmfMHh/8AZP8ADbXP9q+P9bvPEmoyf6752jR/95m3St/31XvOg/C34e+GEX+yvD9lbN/f2eY//fTV1cl1DbQtNfzpbQL953fC14h40/aM8H+GPMs/Dcf9s3/99f8AVr/wL+KvLq4vF1fcptvyWx0fV+f42fRW7TdKs2ubnZaWsX3pJnWMCvmf4iftLabpSS6T8PY/7QvWz/xMZv8AUx/9c1/ir5W8XfErxb49ffr2oMsH/PsjbYx/wGuN/cxfxbq6sJkNWXv1/uMvrVOl7lNlvVNS1XxDqEmq69dvqE8vzM7nLVGrJK/zr8q/w1U86FP4qhbUE/ytfQ/UKkvcjEw+sKXvSZ9I+H/2ivFXhXTbbR7C2gttLtPkhtIIvLT/AGmZurbq9N0n9siFv3Osaetsvy/Jv+X/AL6r4ba+eX5EjeRv7qirVn8OfHPir/kFaFPt/vuu1P8Avpq+ar+GNCrN1K75fM+tw/FcIpQkkz9E/wDhsD4YwQ/6ZE27/YdWrndU/bg+GNin/Et0m+vZf+Ar/wCPNXzD4V/ZH8W6m6zeJ9Qg0mD/AGP30v8A8TX1Z4L/AGd/hp4M/wBPh0/+0Li2+f7ZqPzbMfx/N+7j214uK4NyrC/FVcn5HT/bnN8EEc9Z/tUfELxV++8GfDWaK1/5+dRuGjj/APQK0dM+MX7Q3xD1uf4d+DbHStL1n/l/1JImlttFt3/56SSfeuW/gTH4f3ekt21j4t6l/wAI98M5Psfh+B9mpeKtn7v/AGodNX/ltL/00/1cdfTPhLwZ4e+Heip4V8IWX2WyG6SV8+ZNcTN96eWY8ySt/EzV89jvqFKHssPHXq30J+sVZfHouiOY+HHwk8MfCy3u72CebW/FGrHOq6/qB8y8vH/3m3bIv9hfx3V3lxJ5u6ppG2ffqvXk0IcpjOZS21H5dXPLpvl12xkSZ7R1C0NajR1H5dVKRBjyW9UJLWum+z7qzNdv9B8J6RP4g8U6lb6Pplp/rbi7fy0X/Z/2mb+6vzVnGcV8THY5+Szqr9l2Vzei+LPE/wAQf9M8GaM+heGm/wCY3rkTLPdf9eNh9/b/ANNpiq+iNXoDWflfxNK38Tv95j/7LW1KbfwvQyq0k/i1Ockjjf767v8AerldY8D+D9cj/wCJro1tc7vvb0U16R9l9qY1rXq0Mwr0vhk0/I8+rldKXS7Pk3xB+y78PdZ8x7DztLlb/ngcqP8AgLV4R4m/Y/8AENnD53h7UrfUP9iZfKev0jazqm1q6f6uvoMLxljYe5N8y7Mw/s+cfgk1+J+LviL4T+NvDD/8TXRrm2/29m5P++lrhGW+tn/fR1+60kKS/JNGrL/dYZry7xJ8Ffhp4q3PqWiQxzt/y2tv3Lj/AL5r0v7cy3EfxqXK+6LhXxcdJq6Px+jvk/j+WteOZHTfX254q/Y9tpfMm8Ja6v8A173cf/tRf/ia+bPFH7P/AMS/DW6SbQrme1X/AJeLP/SE/wDHfmWuv+xMLilzYWsm+z3LjjKfwzVmedeXTKzprfVbFvJm+Vl/hdcGoVvnT/XLtrzsXkeNw38SN133R0OFOSvBl+ZtlReZS7klrR0+x892mf5beP5navPjL3Tn5f5ty3p9ijo15f8Ay2sf5t/u1HfalNPths1+yQR/d2H5v+BNUeqah9pZUT93BH9xKqKtP2a+2aQquPw6HSaT408SaHt/etcwL/C55/76r2zwj8eLmzmijmuXsv8AfXclfOy/JUfl768bH8PYXE9LPuj3cFxBVh7lTVdmfpV4f+LGiavDF/aWyPd/y82nMf8AwJf4a9Qs2s9Th87SrmG+i/vQvn/vpa/JGxutS0x9+m3z23+63y/8CX+KvVPDfxW1jR5v9MVl2/8ALzZv5b/98/xV8tV4exeG/gO6XQ9KVXBYn4tGz9JPJqXy68D8F/HBNaT/AEmRNXiX/tndJ/vR/wAVe56Trmj65D52lXKy/wCw3Eg/4C1cNLM7S5Kqszlr5JOOsNU+pe8uneTV3y9lPVa9GliE/hZ48ocvutalVYan8mrax05a6IyGVfJqTyauKtLtNbQZVimtvUnk1c20basZ/9L4S20+o9xpa/fJSPzcloao1b+D71Vby8W2+T7zVwVaq5rR3NIYectkXdu9N+7bEv3mbpWNcawkH/HmvmN/fYf+grWRcahNdvsf5v7q9q1LHR3b99N+7X/x6t4YOb/ifcepGhCguaZkedeX038UjV0VjocKP5158zf3f4VrZht4bZdkK1Z216EKShsrHnYjMnL3aeiIPL2/cpVWptpptdJ5nOFO20/bT1oiZkNFPamVsA1qZUjUi1tze6WQ09akZaRVqoyC50Gl+H31P/j2+b/ZVq9p8K+A7a0j+2arImnxL/E/zFv92vniGa/tLmKa2l2tE25a6S68VeJL5PLubltv93+GuzEZlXjBQpaeZlLBQq/xpadl1PpS8+KXhjwnC1n4etPPuv8An4br/wAB/u141r3xK8Va5uR7l4IG/gQ4rz/d8++ZtzVLXzP9n0+fnq6t9WbPGxpQ9nQVkSbXnfzpm+ZqtKvyVR8ynq0z/crSrioQjq7I82UKlV92y3Td2yov9Um+5l8ta5zUPF1hZ/JZr5kv96vAxGfU72hqz1MPkNefx6I6fyf+WkzeRF/easa88QaPY/c/fyr+Vea3niDWNTm+eRqzvsszv++avOqzr1/jdl2PpsLldKhbm3OpvvGU1z8lutc9J9vvPnuZKfHCkTrsWtGub6lTj5nZVxFvdgjPhsYUq5t2VJRW5wzquXxMZtp6rT6dtoMZSG7aTaafTW+eiwhlM20fcpPMp2kaklR7XlfYlPht3neu3sdJhij+dfmr0KGHStKpsKc+XTdmTp+j/wAc1dHDZpFWisO2jbsro9v/ACaI493zS1K/l09Y61bWS2+5eR7ov9n761tw+GbbUf8AkG3yNK3zbJjtqoYfn6ilVt8Whyfl07y6uahpesaM/k3+nzQf3XYfI3/Aqy1vtn8Ndn9i1bc0FdGH1yGxfWGj7K0v3PvUR30NP+1bPnh+9WmHy+fPqhfWF3IJtL1JH+eB1/CktWms5v3y+av92u98M/Ei/wBD3Q3NjDexN/47/wACr1zw/wCIvh746ufsGsaJ/Z963t8h/wCBLX0f1enCHvx08jzpRqSbs9z5+jhe5m2WEf8AwGqN1Hc2L+TeQPBL/dcYr7jsfhz4b06b/Rrbb/wL5a6K68N6DqEK22q6bb3axfd85N1cGIrYTojajQxEI8smfn1bqknzv8tb63Vt5OxK+zZvh74M2bP7Gt1X/dasz/hW/g1H3ppsK/8AfVVDH4a2xp7Gv3Pjm4vLmeP7Npse1v4n21o6H8N/E+tPvhtH2/334/8AQq+zbXw34e0//j30+CP/AIAtbats+58v+7Wn9rQpfw4/eV9TnP43ofNGn/A2/wDl+33cMH+yi7mrv9L+Ffh7TP8AXK92395//iVr1ik8vfXHXz2rL4nob0svgvhPJ9W+FdhqF/8AabefyIuPkVP7ta2m/Dnw9pn+ug+0t/tV6hb2dFxNZ2KNJcypEq/eZuK4KvEU0uTm0O2lk6k9rmNDZw2abLa2WNfpR9z/AJZVwfiT41fD3Qf3L6pDcy/3Lf8Aen/x2vAPEX7Tzvu/sHS/915z/wCyrXnxr4iu/cTZ6lLL4Q8j6umVPvv8tcD4o+IXhLwrCz6lfQeav8Gcu3/AVr4g8RfFbx54l/12pPbRN/yxtv3Y/wDHa842vK/nTM0jN/E3zGvRpZHVq/xJWXY3/dQ6XZ9KeKv2iL/U91r4Y03y/wDptcf+yrXAaTY3/j28+0eNvEyafZf3P4/+AxrxXl0cnlfcpZJq9illFOh/C0fcxq15y9D7k8H33wZ8BQ/8Se+g+2/x3MxzJXV3Hxs+HsXzvrKN/wAAY/8AoNfnO0m+oNrv/DXPXyudX+JNmcaEN5I/RNfj98NF+/qTt/uxNUv/AA0V8MV/5ebhv+2dfnctrM/8NS/YZqxfDVJ/bZv7Skuh+hf/AA018Oov4blv+ALVVv2qPAafc0+8k/79rXwKuk3L1Zj8P3L1n/qzR/nH9fw8eh9xzftXeD/+WOk3f/fcdZsn7Wmjxf8AHtoUrf70q18ex+EdSl/5Zt/3zVlfBOsP/wAsG/75p/6uYb7dQf8Aa+F+ykfSmqftda35LQ6JoFtH/tzs0n/jteN+IPjd8TvE6tDc6+9lB/zxtD5C/wDfS1yn/CCa3/zwan/8K/1j/nlXZSyTL4dbkzzmH2Hb0ONuLh7n99cSzT3H9+Z93/oVTaXNYQX8D6lB59krfvkU7d//AAKux/4QHVP7rUn/AArvWK9ilOhD+G0jmlmFKW8j2fSfjp4N8IW32bwl4Z8j/b+6z/7zferG1b9pbxbd/Jptslkv13V5ZJ8P9YSPf8tZjeEdYT/llXF/Z+Hq/HK4U8ZQj1NvUvit451X/j81ab/dU7R/47XGf21qv2n7Yly6z7t+/Lb9397dWk3hfWP+fZqqSeH9Vi+/bP8AlWv9lYX7CR2Qx66SO8X43fE5LZbb+3ZmVf4mCs3/AH01Ztx8WviFc/67Xbn/AICcVxTabeRffgb/AL5qs0Lp/DSjkmH/AJUaLF+dzp5vHnjC5/12t3f/AH9as+48ReIZ/wDXapct/wBtGrF8uireU0o/DBFfW59y1JfXkv8ArrmZv952NNhjmuZo7eHdJLL91fvFmNVd1Sw3E0EyzQttlX+Kr5IQ+GCFKvPufQmk/s2+LbuFbnW54dJi/wBr94//AHzX0l8Nfhn4G8AeVf2sH9qa4v8Ay/3O0+X/ANcV+5H/AOhV8DSeMvFUv/MWuf8Av41V/wDhJvEn/QXuf+/jV4uKpV6vY4vYVJfHLQ/W/wDtLzfnubvb/wADWo1vLNP+XlP+BSLX5JN4m8Qv/wAxK4/77NQf21rD/wDMQn/7+NXk/wBkYiXU6YYWhHzP14XVtK/j1CH/AL7WnNrmjp/zEIP97zFr8fW1C/f79zN/321N+1XP/Pd/++zVR4fr/wA5p7Ol2P13uPFXhiD57jWbaP8A3pFrlNU+Nnwr0X/j51+GT/Zt90jf98rX5Ws2/wC/81d38NdF8N654z02w8W3f2TSWf8Af9t+P+We7+HdSrZHOlBzqT08gjSp/DFan2rcftNeG765/s3wN4b1LxNqMv8Aq08po/8A7L/x2vYPB+oeNr62k1Lx5BaaN5v/AB7abZlpXjX+9PN/E3+7W94f0Hwn4c037N4M0+2tLL+9Ai/P/vN1atBo3/jWvGofV5e+pHn4itUj7nLaxj6p4mms0/0DTbvUpf4VhXan/AmavPr7UvjZqv8AyB9NstGX+9cyea//AI7XrkdXVk2V6VKvSj0T9Tz+ab6ny1qXwj+J3iF/O8Q+JHu/9jcyoP8AgK1nw/s536/8v1fXnnUedXq0eIKlL4EkctXAc3xNs+Vof2d7n+O9Rf8AgFaUP7Oem/8AL5qjf8Bjr6WaaovMkq3n+Jl1/A5f7Npnhtn+z34Pg/4+bu5n/wC+VrsLH4M/De0/5hv2lv8AptIzf+O129xN5ELTbXbb/Ci/M1ec6p8SL/T932bRLtv9phio+tYuv8E2y4YejH41+p6FY+DfCWlf8eeiWkf+7Gu6umhkhtk3+WsUS/7vy18rat8XvGf/AC56att/tON1eTa54i8W69uTVdSm8pv4Ebatc88mxtX42enSr4Sl8KPrLxh8evBPhPzYbaf/AISDUV/5d7b7if70n3a+SvG3xU8c/Eh2ttYn+yaH/wBAu23LC/8A107y/wDAq5P+zYYv4asK0MH92j+yIUviV2dCxv8AI9D0rwj8VPFvhx7a2trtv7OtvlS26Rgf7K/w19TaP+1BoljpTJc2k13qLfdTpHn/AHv7tfn9eeItBs/9dcqv6/8AoNc/J4uS5fZomnz3v+4jV4+K4SWJ1Ss+57NDNHa0ldH66+AfGEPiOH+2Ne1CD7bP9y0hf5Ih/wCzNXrKqk/zwsrLX4hafN8Y9y3OiabcWi/l/wChV754H8dftIaRcx/bIvMtf+mzLXyWP4Nx+GvOnJNdj2vrWBrrezP05aPZUe2vLvAPjjxPrKbNYtIYFj/4+J5pFWNP9ql8U/Hj4a+Gma3t7v8Ati6H3vszL5a/9tDXk0vb35KkbNdjGrh4fYldHqKx76h1TUNH0Gwk1jxDqVtpdhB8z3N3KsMYX/ekr5cs/it8YPizfyaV8K9LsPDdhH/r9a1JfOSL/dX+Jv8AZxXU6P8Asx+E7y+i8R/FrXdR+Jutx/P/AMTKX/QI/wDrnar8u3/eqa8re7J2fY5+S25Yh+PEnjW4n0j4C+GZ/Gl1H8kur3m+w0O1/wB+aT95N/uRr81b2hfB23k1uDxt8VtX/wCE68VQf8e3nx+XpOn/APXlY/cXb/z2fc9ezwww2NnHYabBDZWUC7IYIEWONB/dVV4Wq7M9YewFzkN1J5r/AD1ltDWjTWWu6E1EzM3y6Ty6uMtR+XWvOY2KflpVSSGtfyd9Zetalo/hqwbVfEOpW2l2S/8ALe7kWJP+A7upo9qKxSa1/wBmqEkNaFjqiarCt5Z20y2EiB4Z7hPJ80N91kjb95tb/aC0kzJV0+ZjMdo6rtV1mR6Rbd5f4aqUiJQT6HD+IvBPg/xcnk+JNGttQ/2njXeP92ReVr5+8Sfsf+EtTf7T4YvZ9Nb/AJ4TfvY/++vvV9jWukzTuqIv3q8x1bxpqviHUrnwZ8H/ACNQ1G0fydW8Rz/vdK0j+8vpd3P92FOB/FXq4PibF4P+HN27dDCeAhL4NH3Pz+8Vfs43/h7W4PDdnP8A2p4gvk86306w/wBd5P8Az3n7Qwf7b/Qbq8Z8UeD/ABb4HvG0fW45rZvzjf8A3ZP4q/Yfwv4L0fwPZ3cNg097qOqP5+qateN5t5f3H/PSeT/0BF+RO1GreH9L1y2az1iyhvYG/gmRWX/x7+KvpMr4th7TmxlJO/Yw+r1IfA7+p+J63SrtS5g2/wC31qWOSF5m2S7lr9IPGH7Kvg/XN03huT+xJf7n+sh/xWvlPxp+zb458Mf6Sll9rg/5+Lb94v8A3z96vovqGX4//dKnK30ZzvHqPu1VbzPFd1OqndafqumP5M38P96q8d5+8/fK0deTjMhxeG+OOnfobwlCXvQehqbqVW31Asm+plWvEvb4jeMR9v50T+dbyNBLH8yupwy16Ro/xQ17TPL/ALS3X3lf8t0Plzr/AMC/irzdakVq87H5dQxH8RHqYTOKtD3YPQ+3vBf7QXn+VbTXK3f+zcDy5l/xr6O0Xx14b1dF/efZpW/vtuSvyaVa6fRfFniHRn/0a73Rf3JuR/31XxeK4cq0Pfw707HuQzDD4j3ays+5+uix/JvRtyt91l5U/wDAqcsdfAfgv49XmmPHC929k39y4bdA9fWPh34uaDrCRf2qv2KVvuzJ81u//wATXnRzOpQlyYiNmZ18l056Ero9QVadRbtDcw/abaVZ4m+66HcP/Ham217VLFQmlKDumeLODi+VrVENPo20V1e1Mz//0/gfdTZJPITzpm/4CtZN1rX/ACzs1/4FWdDHeX03ybm/Wv3L6vVq/E7JnyNLB2XNPRGxcaxM8OyFdsX61Shsbm++d/lWti10nyv9d8zf+O1srHXo4XCwpfCte5z1cfGHux+8oWOnw233F+b+9Wuq0irU22ulnjV67lK8ncRVqSmU+kcw+haVaXbVGQUU+igCKipaiq4yAZRT6dVlEVPop1YuYBtNReZUu2aX5EWp103/AJ+ZPKrgxWa06CvOR1YfB1KuyIN1TtG/+7Va81TS9M/5aeZXGX3iyaf5Lb7tfK4jiCdV2pK57GHyLrUfyO3k1Kwsfndtzf7Vc3qXjbZ8lstcPcXTz/fqpDbvLXH9TqYmfPXl8j28PhaVJe6i7dapquqv++lZv9lfu0sdin33rRht/s6VNtrvhh4U/gWiJq4r+XRFONdn3KtU7bTWpykcUp8wU6m0VBBLUq1V3VIrVJEolmmU2mURJsMmZ98UO5YvNb77/cXP96reteG/EnhqbydVtHj81dyP96KRP70ci8NVCZd9egeEfiZqvhyz/sHW7b/hIPDn/PpN9+3/ANqBm+7/ALv3a9/L61OMOSpG67nXG/J7i17dzy/7Q/8AHVu1865fyUWvpaHSfh74xh+06PGn73/lj/q5k/3qyZPhvZ2z79Nk8v8A3lr3/qGFl8DOGrmiV4uDTOD0uxS2h/2v4q3Vq/N4X1i0/wBqqH2PVU/5Z/pXHPJJy+DY85Y+H23Zkyx1IsdMX7Yv/LCjzLz/AJ4fpWP9jVuxccwpdx/l0qrs+eq7XF//AM+1Iv8Aasv3IP0rro5HiO1i/r1Lvc9H8N/EDXvD23ZL9usv4rK7Cywuv/Avu17hodx8F/iMn+k6avh3Wf8Anhu2xyf9c2r5Sh0PxDd/6mBv+Ahq7fSfg74n1WSOab9x/d9a9L+xasPf9py/M5a+Kw9X3eW7PoqT4S/DqKbZN8v+zvxV+P4L+BtnneRMy/8AXRqyvCvwhmtIY316+lnnX/po3T+626vbrG1h0+2+xw/d/wBqvNxeYVYfBUbZFDKoT96Ssjzq1+FfgeD/AJhvmf77sa6ux8O6JpSKlhp9vHt/uov/AKFXRHZULNXlVcyqS+Ntno4fK4UvehuR0xqN1R/erjlO/kdvsyCTZVZqs+Xuf5K5vxB4o8PeGoWudY1CG08r5m3uoNYPFwg+XdnZQwc6vwo2PLemqv8AlvlH/j1fKPi79p7TYnaHwlp7Xcv/AD2f92n+NfPviD4xeOfEu77fqT2kX/PG0by63pUMbif4UbLuzujgKUf4j17I/RHWvGXg/wANQ+drer21tt/h8xc/989a8P8AEH7Tnhix8xPDdi+oS/3m/dp/49XwlJcebN53zSS/3nbNWLexv7n/AFMDf+g162F4Ve+JncKlelS+BW82e/8AiD9o7x/qu5NN8nS1/wCmI+f/AL6avHNW8TeKvEb79e1K5u/9+Vsf980618L3n+smk2/+PVvL4bh/5bS/9916McFhKHwL5nkV8+gvdvf0PPvJ2VLHZu1ej/2bo8H/AC0WX9aX7ZYRf6mD+laf2rSXwnnSzaX2Ezh49Nv2+5G1XIdDvJf9Z8tdLJq03/LGNV/Wqcl9eP8AxVh/a8fsox+u1X0SKa+G/wC/LU8eg2cX+ul/8eqKRnf+Jqg8t6weaT+EXPUe8rGnHp+gxf65m/4DU3meG4vuRzN/3zWL5NHk1l7ecuo/8TZsf2hpv8Fpu/3n/wDiaVda8r/U2MC/8Az/AOhVkLb0/wAmp+ZHuGz/AMJNf/wKi/7sS07/AISbVf4GX/vhayfLo8usvYRJvHsabeJte/5+W/8AHaj/AOEg1t/+Xlqp7aftqvZQ7B7TyLX9va9/z9vUTa94h/5/XqvtprLvo+r0uxUa5N/b2vfx30350f27rf8Az9yf99VX8mhY6r6pSNPbllfEHiFP+Xl6n/4SfxD/AM/LVW20eXS+roj6x5En/CSa3/z3/wDHVqT/AISTWP8AnrVXy/8AYpPLq/ZRJ9tHsX18Sar/AHv0pf8AhIJv+W0cMn/AFrO8uo2h300X7SJsf21pr/67T7dv0qj52gz/APLt5dU/s/8AsU77H/sV0wxDj1Dmj3ZM1n4el/haOov+Ef0GX/U323/fFRNZ1F9lkq/rlTuaQqv7M2Pbwj5qf6PcpL/wKsubwnqsX8NaixzJVqO6v4v4mp/XZ+pt9bqx+F3ORk0HVYPvwVnta3KffiZa9E/4SC8/iVZP95akXxBbf8trFWraOPnH41c6oY+p9pHl22n16p9q8J3P/H5p7q3+zUbaL4PvP+Pa7a2/360jmcPtKx0LMF9pWPLKduNelt4HsJ/+PPVFb/vmqc3gK/8A+XedJ/8Ax2tvr9J6X3NY4yn3KWh/ETxn4cdX0fWbiDb/AA78p/3y1ew6H+09480zb9vWC+Vf9jbmvCrrwzrFn/rrRv8AgPNY8lvNF99WWvPxHDmExHv217o9ehms+915n3ho/wC1doN0iprGkvB/eeGT/wBlavVdH+OXwx1rb/xOfs0rfw3CMv8A49X5a7aK8efCM4/wp2NZ4ihP44fcfsfp/iDQdVTfpupW9yv+xIrVtLs/gZa/GC31K/s232d3NA3+w7L/AOg13Gm/Fr4i6V/x5+Irv/gb+Z/6FXL/AGDjYbSTOaWHw8uh+srfI9P3bq/M+z/aS+J1n9+7t7n/AH4lret/2pvHkX+utLOT/gDCp+oYyPxRuzjnlVJ/DI/RVaZJHbS/66Jf+BV8FWv7WniRP+PnQraT/clZa6K1/a6T/l80KaL/AK4urf8AoVV7DFx/5ds5Z5RvaVz66uvCeian/roNv+7Xl+vfBX+0939m6g0H+8v/AMTXnFr+1t4bT/XaffL/ANs1P/s9b0f7W3gaX78d5B/27/8A2ddGHzTH0n7kWcs8hhLVszJv2c9elk/5GKGBf9xi1TR/sw6V/rte8SXd3/sQqsX+NOk/as8Kyf6Nomhalql7Lt2J5arv/wB35mr33SZtevNHg1LxJp66Nf3Pz/Y/N8148/dWRl/ir0nnmNl/F0/Uyll/sPgZ4ta/Bj4daH89vo32uVf47t2k/wDHW+Wrlxrnh7w9D5KQW2nqv8Kqq/8AoNewSfN99flrkNY8F6DrG77TB8zVpSxUKvuV5MjWNna9u55NdfFrwfZ/8t3k2/3IqwLz49WESf8AEtsnl/32xW9rXwR02fd/Zsn/AAFhXnl18Edbg+592tf7BwVX7X3noUs65PiiZmrfFrxJ4hhaz8/7Nat/yxT5Q3+9/erlvtlzL87turcm+Gut2f34/wD2Ws//AIR/Urb/AF1YvhqEf4Z1f2z5aGppPi7xJobq+lXrwbfmVd3H/fNewaL+01450dFS/VLlV/u/LXiC6DePTm8O37/Jt/76r5/G8JYWv8as+6PQw/EdSOkdV2Z9h6L+2NpXyw63YvB/tL81e+eF/jt4A8VRr9jvk83+4xwf++a/LT/hFXR/32ykk0+w0r999uhgZf8AbrysR4ff9A82vU9H/WHCT+OGvkftBZ3lhqP76znWT/drU+y76/H7wf8AEj4tS3P2DwTpupa7/wBcIpW6f7VfTnh21/bI8Sov2/WbLwPZf9NUjubr/v38/wD6EtfP4rhfFYb+NNafeN4rCyjeGlz7iurW2tIWvLyRLaCL5nlmdY0Uf7TNxXhOtftBfDHTr+XR/Ddzd+ONZX/lw8OW7X//AH1Mv7pf+/lcVb/s76brVzFffE7X9Y8f36/9BS4ZbNf9y1j+SvdNJ8N6bodmum6Jp8Gm2UX3YLaJYY+P9la56WF/5+M4ataH2Fc8l/tb49+Nf+PO0034XaR/z2uNurax/wABj/49od3+1mtvw/8AC3wxoepL4hv/ALT4m8Rr/wAxjW5fttyn8X7jd+6t/wDtjGtepLYvV6PT9/8A9lWn7qBzc85GDM00v95qhXT5p/v10V8thpFnLqWsXcGn2UXzPPcyLDCn+9JJxXks3xy8JXk0mn/DXS9S+I2o/wDUCg/0NH/6bX82y3j/ADasp4pdNSowkenW+h/7O6uQ8ZfELwJ8OZYLHXruS7127/49NC02JrvU7j+6sdtHyu7+8+1a5g+Hfjx8Qo/+Kq8QWnwz0SX/AJh3hz/S9VdP7k2pS/u4m/64R133gr4Z+B/h0s58K6WsF7d/8feo3Dtc39wT95prqXdK3+7932riderP4dDaMUvM83PhX4l/FmP/AIr7f4C8HS/8y/ptx/xM71P+n++j/wBTH/ehh/4Ea9bstG0jw3pFvoXhywg07TLL5IrS2Ty44x/8U1dHJJvqhJHWmHw4zmprWqklrXUNbpVSS3r0TOxzLW9Iq7K3mtaja1p3JcE91c818SfDfwT4vjb+3tGtp5ZP49m2X/vpa+ZfF37Iem3PmXHhLVNv/Tpdr/7UX/Cvttrd6rNHsr6HLuKsbg/4c3bs9jzauVU3dw0Z+PPjD4G/EDwm7fbNLmjgX+Nf3kf/AH0vFeWXFvrGnfJcxV+6jL8mzbuVv4W+7XmPir4P+AfF6N/aWkpHO3/La2VY3/8AHeGr6KlxTgsV/vlKzfVGXs8VS+HVH47w6hH9z7rf7Vaccm+vtHxt+yTMkLP4PuUvf+mNx+7k/wC+ujV8p+KPhn4z8GTeTqWn3Np/12T5P+AtXV/YNDFe/gaqlfo9y45lB+5NcrMmNasrXPxtf2nyXMDtt/izkVow3kM/yI21v7rfer57G5NiqLtUjZHbGcH8LL+2tfSde1jQX/4lty0C/wDPH70bf8BasxW/ytSV4NbBQq+5VjdHTh8ZOk/cZ9AeFfjZc6e6+dv01v70BZoT/vL1Wvqzwz8YrDUIY/7S8ueJv+W9u/8A6EtfmmrVdtb68sX+02E7wS/7DY/76/vV8viuFPf58NK3ke7SzeFX3MQvmfr/AKfqWlaum/TblZ/9noy/7y1YaN0r82PCvxcv9M2pf79y/wDLaDrX1j4N+NVhqNn52valZRWv/PzM6xSf8C3da8v2+Iw8uSvH5o1q5XSq+9Rlp2P/1Pz+h0G2gfe8nm/7PStmONE+58v+7Vry6kWOv6J90/Na+MnPd3I1WpVWpFWn7ao4JTGU+nbacq0Gdxu2nbTUm2nbaz5yLjaNtO21LtNHOZ3IttNqxtqFqqMwjIbTWWnU7aavnGV6Gp7LJ/BUm2GBN9zXn4/MoYdc838jvwuDnVkowVyNbeaf5IV3VY+zx23zzSL/AJ/2q5fVPFkMHyW3zf7NcPea9f3e5N21W/hWvkcRm+Kr3VNWXc+rwuSQhaVTVnompeLLOx/c233v9muI1DxVf333G8qua20Vy08FF61NWezCCh7sFoPaR5f9c26pV+So1bZViGOR3r0qVKK+BGc5E8MPm1swx7arR/JVqOrlCx5ded/Qn276SRaPMqFpqI0py9DjjGQU2Rtqb6c0nyVDJJ8laUoe9sbxiQfaEpY7yGksbq2tbnfeW322D+JMtH/3yy16Xpvhv4deJYf+Jbrb6NqLf8u1+mU/7/V9LSymhVho9TetyR+Nadzz+Nkepdtd7qHwX8YWaedZrDqFv/fhkrjbrwz4ksf+Pqxm+X/Yz/6DUz4XqS1paow9rSl8MlqQ075KymkvIPkePb/vLij7RP8A3aj/AFVxPYn6v5ltqmtYfNas3fJ/crr/AA/a/af+Wdd1DIasb3joicR7kDqrGx/cq/3WX7u3g111nrGqwR7EuWk/3/m/9CrMt7O52/dq6tu61UsFLojy41dPe1Oih8QXOz98qt/wGrS69H/GtcZJdJF/eZqqfarl/uRV00spxcttER9aw/VHora1pv8Ay2gT8qG1TQdvz7Vrh7fQfEmq/wDHnZSyf7sbV1+k/Bfxnqfz3MH2Rf8Abbb/AOO13U8BOl/FqWOSdbCdIluPVNETbsVK6jTdQtpX2W1ojfrXQ6L8BbCz2vqt75u3+Fa9a03wr4e0pNlnbfd/ioljYQ6tmHJz/BGyOV8P2N5Ptfy9v4V6zZ2/2eNf71QQ+TF/Cq1cVnf7ke6vnMfmSl8Tse5gMHLsWNz1IrVVkmhgTfc3MMC/7RUVxmsfE7wHoaN9v1mH5f4U5rw542D0Wr8j2o4CpLpoeh06O3eX7is1fLOuftTeEtP3Jo9lNqH6CvIPEH7VHjbUtyaJbJp8X/fRopYLG1/4cLLuzpWChD438j74upIbFGe4kSD/AH2xXinjD49fD3wluh+1/wBr3v8Azxs33bW/3q+EdY8ZeP8Axn/yEtUublW/gyyp/wCO1W0/wPft894u1a9OlkLj72Kn8kZVcXh6S0WqPXPGH7TnjPxDDLpug2kOjWrfxL+8n/76rwW6XxDrlz9p1KWe9lb+KUs1d/Hpej6V/FDu/wC+jTpNatk/1Ntu/wB75V/8drtofV8P/Cj82eVPPJy92C0OQh8K6rc7fl8v8K17fwSifPeT/wBKnm1rUpfuSeR/uLt/8erMbzpf9dK0n+82a6P7Uq20OaWLqS6nSLZ6DYpsTyd3/fVNbVraL/j2Vpf+A7RXOxw7PnqauKeIm+p51WClLmepoSatcv8A6nbB/u//AGVVJJJp/nmZpH/2mzUW2pdprBhFQj8KGbTTGjqztp+2kTzlVY6PLq5tp+2oI9qUvLpNpq2y0eXQHtSrtp22rnk0eXT9oR7Uq+XS7at+XTtpqfb/AMoe1KXl0vl1c8n/AGqesdXefRXJ9qUPLo8utBo9lQ+Yn8dXGNXsOM5FXy6dtqT7VbJ99l/PbVWTVLBP+Wtacs+xrGE5fCrk22l8uq66nZv9z/0Fqsxzeb/qYJ5P92Nm/pT9nPsOVKoug7y6XbVlbfUpfuaXdt/u2sv/AMTT103W2/5g1/8A+A8v/wATW0aM31I9jV7FLy6PLrQ/snXv+gNqP/gLN/8AE1A1nrcX39Gv1/7dZv8A4mn9Wn/TKjQqvoVPJpPLp7SXMX+usbmP/fikX/0Km/bIf7rL/vfLR9TqC9nVXQPLoVXp/nwf5NI1xCv322/rWboVOxHvjdtG2nLcW3/PSneZD/z0/wCA0uSfawuWXYb5dR+XVlWSpfLR/uVnKXL8QryXQyvs/wDsUjW/+zWr5dHk1z/WB/WPMw2t0/u1C1mj/wANbbW9M8h/WqjXN44rzMJrXZ9z5anW61K1/wBTcv8AnWq0L1E0NTOqawxfzIl8RavF99vMqX/hIklT/TNPST/gNV2hqP7P7U4V3H4dDo+sQ7Fn7R4Suf8Aj5sWg/3ahk0Pw3c/8ed35X/XbiqslmlUWta9HD5lV7nVDEX6tF648Fzf8u13FJWJdeGdVtv+WDN/uc03bcp/Ey1oW+tarZ/cnavSjj5/b1OyNWa63OYktbmL78bL/wABqGvQF8VO/wDx+W0M/wCGKkbUPDd5/wAfNp5VX/aUOxt9an1iecVLXeN4f0S+/wCPC5aP/e5rPuPBuqx/8e+25X/ZNbUsdTl1szWOKpy3M/wzp+m6rrFtZ6re/wBm2Tf66fbu/wCAr/tNX2h4X0H9nvZFDbfZrmf/AKe/mr4euNNvLP8A4+IHj/4DVZVdPuNtrHFYLEVffoTsbctOXx6ryP1b0PTfBljt/wCEbWxg/wCuCxr/AOg11flu/wDFu/4FX5H2eva3p3/HvezR/wDAjXoek/HD4haLtSHUPPVf+e3zV4GKy3H/AG9R/UKH2GfpavnJ9+pd1fCem/tTeJIP+QlpsM/+423/ANCruLH9qrRH2/b9JuV/3NrV50414/HAx/s5/YkfV0i/3Kps1fP1v+054Dn/ANdFdwf9s8/+g1pL+0F8MZY/M/tKaL/ZaCSp+uVY/FFj/s2fdHquqWvn2zIleJa5od5ZzfafL/dfxVqN+0B8Lv8AoITN/wBsGrLvP2gvhXKmyaW7n/3bdv8A2avUwuecj5ZJ6hPK6nkc6sjtu/duq/3ttdt4F8E6x8QdVXStNkW0gX5rm7m/1cSf+zbq8y1b42fDSd98EF9t/upEo3f99PXQ+GZviR8RtBnv/DdsnhLwzH/qLt491zdzL/zz/wBn+833ayxeOhVkqdDST2fY3pYX2UG6jVj7N0v9l/4e223+2NdvdUl/31gj/wDHa9H0f4L/AAd0Pa9h4d06eVf47lPPf/vqTdX5SeIr740eHpvJm8RX/lf31dq5pfG3jx/+PzxBf/8Af2SvGxfCmfP/AJeXT7G9LEZb3sz9wYYdKsYfJs/s1tF/chCxp/3ytQTX2jwfPc3ttF/vSqtfiO2ra3c/8fOs3cn/AG1k/wDiqo+Sk7/vp5pf96RjXztbhjMI/FY6qdfBPqz9pb74gfDrSvn1jxXpNpt/v3cVebX37Tnwa+1f2V4Yu9Q8aan/AM+mgWE127/8C+WP/wAer8sbex02L5/s0Lf7yKf/AEKvfvA/7QXjDwFZwaVpUVn/AGdH/wAsPs6xf+PQ7a8nFZLjY/5I7aEMLP4Gfaq/ED4za0//ABS3wl/suD/n58UalDaf+S9qJpatN4V+Nmvf8jD8Q7Pw7F/HB4Z0xRJ/4FXzTP8A+Q1rkfA/7TXh7xHth1Vltrr/AJ4zfKf+At0avoTS9a0fXE36bcq3+x/HXj08fDn9nW0fmTisvrx99LTujzLT/gX8OoLyLVfEVteeNNUi/wCXvxLdSans/wB2GX/R4/8AgMVeuQrDbWq29tGltBF9yGFFjRP91V4WrHl1Ey16EOU8oTzKjp2002ugA2mm06karNiJqryLVzbULLTjICrtqNlq00dN8l3pykRKJQaNKqNbu/8ADXQfY/Kha5mZY4ol3O7naqD+8zN92vFNQ+O/hi71Cfw98LtLvPiVr0H300VV/s+B/wDp41GT9zGv+7urCeIS6lRiehSWtVWh21W8L6H8Qr66/trx/qltbf8APLQtHX/Q4P8ArvdSfvbiUf8AAY/auk1+98P+FtLk1bxNqNpo9jDw897KsMf+7ub7zVl7e694k51rd6r3Gm2t9D9jvIEuY5fvJMisP++Wrk9N8ZeIfHr/APFutEe20H/oY9ciktoJE/6cbP5Zbj/fbZHXpMNn9mhVHne5l/jlfaC5/wBlV4WtsPWmneDtYVSCa5ZI8T174C/DTXEb/iUrp87f8trQ+V/470r5t8Yfsm3MEkt54euf7Xi/54v+6nX+jV9+tHUe2vrsv4txuH+1ddnszyMRlMJfBo31R+LuufD3xN4VuZUmtpoP9idWrj5L57Z9lwrq38Vft/qWh6VrUP2fVbSG7Vv76K1eC+Kv2Y/A2ufPYR/2fK38K8pX1cOIMqxv+8Q5H3Wxzf7VQ+LVfifmZb3lnP8A8tKvLIn8Fe7+Nv2WfEmgebc6bF9tt1/59vmP/fNeDXnhnxPoe7zrbzV/u/x/981VfhiFWn7TBVFJduptQzSnz2m7PzHtWXcWMM/+uXdUUerJv2XO6Jv7rLhqvLcRy/6tlr5etltfDz5akbM9f299Yvc//9X4rVak2min1/Qp+QXGbaftp9FWK4baVVqSioM7jKfRRUiCpdtNp1YuX8pEgqPa9TxxzSvshVpP92p5vsdinnXk6r/s152KzeFDrd9j0cLl9Sr8C07lPyadJHDAm+5k21y2peMkT9zpsf8AwKuKutQ1XU/+PmX/AID2rxauZ4iv8OiPpMJk9OHvVHdnZah4utrbdDZ/+O1x15q15fP97atU1hhi+/8AM1V5G/uVz+wje8tX5nuQ092C0K/8dLtNO27Pnpn3q3lI0EplStVy3t/43opUpTFKfKuYjt7ff871qLDtqRVqavSjGx5lWvKQxakVtlLTd1HJzHPuMkk/2a6HQfB//CVfudE1S2+3/wDPpdv5Ej/7rN8jf99Vg1XkhSV69PAYpUL3jdPubx20dmbmteCvFvhib/icaXc2m3++jbP++q5hpH/u16f4f+Knjnw5bfYPtf8AbOlx/wDLpqKeen/Ad3zr/wABavTtH8YfBzxc/k+LdJ/4Rm6b/lsqebbP/wBtI/3kf/fNezGeBq/GrP8AAiVWtH7N13R8rszvR871982f7MPg/wAUWy6p4V1T7bYN/wAtrOdZ0/8AHfu07/hkGz/6Clz/AN8K1bQhl/8Az9H/AGkvtRaPijRfFnifw4+/R9Smg/2c7k/75avYNH+N3yeT4k09pW/57W23/wBFtX0Ta/sg6I/+u1S7/wC+FroLf9j3wl/y21C7b/vmqeKwVL4KzXojmq16VX4oX+R4fp/xA8Aan/x83Nt/2+xMK7fT9N+Huuuv2NtHk8z+46/+g16av7IvgNfv/aW/4HVC4/Y/8DN/qbm/g/3ZFP8A6EtTDPacf+Xz+45/3f8AI0Zsfw18Mfx2Vp/3xU7eEfBlinyQJF/u8V1Om/sx6PY+V5PiLWtsX8P2raP++VrvLH4M+E9O2/b2udQ2/d+0Ss3/AO1Ws+IaX2qjfkkclTC/yL7z53utJsJX8vTY0b+da+m/C3W9Y2v9k+zQN/E/FfUtn4f0TTE2WGnwQf7qLu/76rSZZkT5K4avEz/5dRt5s5/7NnKXvP7jwaz+BfhiD59SZ52/iXOBXT2fgfwlpG37HpMHy/xONzf+PV6HJG/96sm6mtoP9dOi/jXj1uIaj+ObfkjroZDfpb1M7/VfJDAsH+6uKYzPL9+SuZ1r4heDdDTff6pD/u+ateG69+014etnZNHtmu9v5VyQxtWr8MGz0qeTQtqz6U2/3F8yqt9fWemJ9p1K7htlX+8a+B/E37QXjPV0lSwb+z4m+7trxS+8SeIdV3PqWqT3O7+87V30MrxeI+N2R3UMLSpeZ+hfiD49fD3Q/wBzbXP226/2eleAeJP2mPEF8/k6JEttF/ezXy0rf99Vp2Oi6lqL/wCjQNtr1qHDOGpe9Wd2dE8Vy7aJHVap8QPFurzM9/qT/wC7muVk87UJv455W/Gu9tfCdhp6Lc63d/8AAFrQ/trSrH9zoljs/wBt66oYjD0P4UF6nlYjNJvz/I5TT/Bt5P8A8fP7hf7z8Vv2+j+HtN/4+Z3uW/2VqCbVLy5/10rNVOuGvm9eXXQ8WeKqyvzvQ318QJZ/JpVpDB/tMNzVlXWpX99/x83Lt/s7uP8AvmqtN215/O5PmnqYkbLS7al20VYe0G0badtp+2pkRcZtNCx1Msb1NHC9Z8/mTz8pCsdS+TVxbd/7tWVh/wCBVlG7Oedczfs9S+TU811YW3+unVfxq9pNnrGvPs8N6Nf6u3/TtayMv/fVazpTtfZeZVqko81tDOW3qT7PXseh/s9/HjxG/wDo3hRdLgb/AJbalPHD/wCO/f8A/Ha9Y0v9iX4i323/AISHxjp2m/7FhFJM3/fTeXXJPH4eH8Sok+25ssHUesmkj5H+y76jm+zW3/LdF/4Gtfofov7C/gm3+fxJ4k1bWf8AZV1tk/8AHdxr2TR/2Wfgbou3yfCVtdyr/HeGS5J/7+EivNq8R4SGzbOmGW+bfyPx9/tKz3+XC3nt/dhXLf8AjtdTpfg/x5rn/IB8Ia1qH910spQn/fWMV+2uk+B/CWgoqaJoWnaft/59rWKL/wBBWun8lK8+fFsI/wAOn950wy+HY/GGx/Z5+PGq7fJ8IPabv4rm4ij/APZq7bT/ANjf42aht+33ej6av+1K0rD/AL5Sv1p2p/dqbaa458XVvsRSOiGCt2PzP0/9hXxJP/yG/HEMH+zbWjN/49I6132n/sM+DF2/2r4m1i7/AL2zyoV/k1fedJtNcs+Kcc/tm31XzPj+z/Yn+DMH/HzFqV7/ANdrtl/9F7a6+z/ZP+Btmn/IsrP/ANdbiZv/AGevpKiuGeeY2XxVGX9Xj9rU8Utf2d/gzZ7fJ8G6a23/AJ7Reaf++mzXSWfwl+G9j/x5+FNJg/3bSL/4mvR6K5Z5hX+1NsUsJTfS5x8PgXwlbf8AHto1nB/uW8a/+grV1fDelRfctkX/AIAtdFtNG01H1yp/MzP6hS/lsYq6PYJ/yzX8qk/s22/uVr7aPLqfrMu4vqEOxk/2fbf3aT+y7P8A551r+XSbTU+3n/MV9TXYwZPD+j3H+utEb/gFZ8ngfwrP/rtItJP96KNv6V1200tV9cq/zMPqVP7UTz2b4W+AJ/8AXeHbBv8At3j/APiaxpvgb8K7j/XeFNObd/0wX/2WvW6dW0czxEfhm18xf2fR/kPn66/Zl+C13u3+F7Zd39xpF/8AQWrkL79j34OXP+p024tP+uNxIP8A0ImvrCiumlnmNhtUZf1Cn9nQ+GNS/Yj8Dy/8g3W9UtP+BrKP++WFec6p+w7rEX/IE8Xo3+zc2m3/AMeVq/SvbRXfDivGr7d/VGH9nfys/I7Uv2P/AIu6fu+wT6dqX+7I0TN/30tcFqXwD+N+lbvO8JXNzt/it3WX/wBBNftb5aU1oU/u12Q4wq/agmT/AGb5o/BLUtD8VaHu/t7w/qWm+X97zrWRV/7621gx6tZs+zd+9r+gKbT7aVNkkasv91lytcJrXwp+HviHd/avhnS7vd/E1rHv/wC+lrvjxbh5fxKVvQwnlvkfiM0ibPkVqPJ3/wCzX6q+IP2R/hLrG57Oyu9Gb/pwuGUf98tvFeJ65+xDMm7/AIRvxbcf7KX8W7/x6P8A+Jr1cPnWX1ftNPzOGeDmuh8JNb037P7V9Fa9+yz8YNAhlms7G01lY/8An0nw/wD3zJtrw/WND8SeHv3PiHRNR0v/AGp7eQJ/31XoctOetKSa9Tn9lM55oarNDV6O4hlj/cy7qT5HqvYVF0LjKaMJoartCldA0P8As1RaGtY1TthX76GC0af3agaNK2JLeqbQ1udsK/mU1/dfc+Wp49Sv4P8AUztTWjqPbUSguqudEZ/M6C38UXn+pvI1nWtD7R4Vvv8Aj+svKb+9DxXIqtLItL34y912B+Wh0M3hXRLz/kD6lt/2Lhdv/j1Yt14R1iD/AFMf2lf70PNU13p9ytK31C/tvuTtXfDOqtL49TT2s49Tl7i1ubZ9lzE0bf7Q21Xr0eHxFM/7nUraG9X/AGx83/fVVJNP0HUd3kt9il/u/wANelh86pS/iaM1jj7fGjgaK6668J3kXz286XK/7P3q564sby2/10Dr+Fdsa9KXvQZ1UsVCXwsz6eqyS/InzM1FSwzTQTRzQs0cse1kZflYMPu1M6W9tzc+yfhP+zXZ+TZeKvipcwxeZ89toCN+/k/6+/8Anmv+x971219UXl88u22RVgtoF8mG3QKscaL91UVfuha/Mrw/8TvFug3/ANs+3PqH+xcNu/8AHq+ofCf7RWian5Fhr0H2SX7u+vzmv9dw1V1K8L+a6G9bALE/BLVdO59AyabYXP8Ax8Rq3+8M1w2ufC3RNV3Pbr5DN/d6V3ej6lpWuQ/aNHu0u1/2D92t37P/AMBr0sFxAtOSXyPnMVldSk7TR8l6t8FdVg/4850b/vquZX4S+LYv4Uk/3TX2y1vuqnJp8b/xV9BDOFL40mzGNCf2GfFVx8PfFtv/AMum7/x6uYvND1ux/wCPmydf+Astfbl9oeq799het/uMq/8AoVc3cQeJLH/j80/7av8Asrmt4VqUuiCM5w6nw3dTXMD/ACM0G2vTvBvxy8SeEHgT7d9ttY/4JXb/AMdave/+KS1L9zqujQxt/tx7a2bP4D/Cvxb+++zeR/17z+XXkZrg8sxELYqnt1R9Bl+b4qk+aD36HqXw5/as8MeIfIsL+5SOf/njcvtf/gElfVWk+ItH1xFe2kaPd/C4x/49XwTdfsQ+Fbz99Ya/d23/AH7lqG3/AGT/ABV4VfztH+JF/p/lf3P/AInftr86xHDWA/5g8S15M9yrmUKvvVIWfdH6MSWrp/tVTaOvlLwbJ4/8EpsudU1LxI3/AD8Mkn/ovDJXpc3xm1K0h/feFNW1af8AuW1hLH/483FeZLKsVSlaVmvI5J1aXxQZ7BtNO8uvAf8AhdXxIvv+QP8ABrVpf+vu7itf/QqG8VftIar/AMe3hDwv4Z/29R1G4vX/AO/dsiD/AMerL2FTqrfMiM4vrc+gfJpk0KQQtc3LLBFF8zO7KqL/ALzN92vndvDPxv1p/wDiofijDo0H/PDw5pcMP/kxdNM/6VH/AMKJ8B3bxzeMJ9Y8cXS/N53iDULi9T/wH3JD/wCQ6XsKge0idhrXxw+FOh3P9m/8JDFrep/9A7REbVLpj/d8u18zH/AitYjePPiv4l/5EnwSnhm1l/5iXi6Xy3/4BptmXl/77lWrV14i+Gnw2tv7N+26L4Wg/wCfSDybb/vm3h+dvyqC38caxrn/ACI3hDVtZ/6fL9P7HsP+/wBeL5rf9s4Wq54f+dk+1/lKf/Cm4fE7x3fxa8Taj49l++unP/oGjxv/ALNjbcSf9tHavRtc8VfD34TaDB/b2oad4U0uL/j2skRYvM/2YLaJd8jf7iVzMPgn4o6//wAjV4xg8N2sv/Lh4Vg/ff8AAtRvVeT/AL4hSup8LfDDwB4Lun1PRNEh/td/9Zql4WvdQkb+813c75f1rz/8BocEPHfxX+IP7n4Y+Fv+EV0f/oY/FMTRO3+3aaUv72T/AGWmKpWpoPwP8OafqkHinxtqF38QPFUP3NS1pvMjt3/6dLL/AI94R/d4J969nabfVSRqiGHKIriaSX77bqyJavtUDLXo8lvhJKDLUXl1cZaTbTJsVPLpnl1e21Ht2URkKxSaFK4/XvAPhjxGjf2rYozN/Go2v/31XdeXTGhrtw+Lq0mp05NNdjkxGCpzTVRHyT4q/Zf0HU45H0f/AFv92ZP/AGavl7xN+zP48tLnydH0a4Zv+mLLJHX6p+S9aVvDefwfyr6mhxni4fxLS9TyP7F9lNSpSa8uh//W+MttPoor+g4n4+Mp9MorUCRWpd1RUi/N9yoFYm3GhadHDM77EXc1XZI7a0h86/nWD/Zzy1eXj80p0Pid32OzD4CpW+BEUcLyvs+8391au3FvYaZD52sTrGv8KqfmriNS8dfY0+zaPBt3fxYripJtS1WbfcyM3+01fK18bisTL93ou59TgsopULSq6vsd7qHjxfL8nSl2r/exXA3lxqWqvvmarMNnDB9/5qn+9U0qFOh7277s7J4rX3FoZkdqkVMuJPKqe6mSCsj99cyVftub3uhpCHNrMGZ5XpzfIlTfLBHVNvnq4z961rs2jr6IT/WUm6pGk/gjpY1rvw+DnVlsWSw2/wB162FqnH89XPMhT+KvS+r8vu2OCu2yRWp1N276dU8hyBupfvUm6pY6mwBtoWn7d1MZdlXYmUxJag3VOyv/AHaZ5db06V+ly4zJdNvtY0a5+2aDqFzpFx/z2tJZIX/76jr2/wAO/tQfHXw1thh8Tf2tbr/BqUEVz/48w8z/AMerw/dDF99qqTTbfuNurT+yvb/EjrpV5+p9z6H+3d4hg+Txb4L07UP+m1hPJav/AN8yeYK9Y0n9tj4P33yaxo2r6Nu/i2RXKf8AkN93/jtflwy+b9yOus0P4e+MPEb+TomjXd3u/uxNj/vqt/8AUXnhz83L67HV9fpR+NI/VqH9pT4A3yb4fFcMf+zPBNE3/jyVFdftBfBlU/c+KLKT/dZq+MfDP7IvjPUfKm8QzwaXE38H+tl/wWvfPDP7KfgnR5IptVibUvK/57dG/wCA1x/2NgqH8Srf0POr53TXwQv8juW+Png/U/8ARvDM82qT/wDTtFI3/stdT4f1DxJqXmXOqr9mtW+4jriStzS/Cfh7QLZbbR9NtrSJf+eMar/6DV+Rf7lKdXD25aMfm9zz5YipVfNJWXREvmbK5vxNb6xqGmzw6De/2fe7f3LsNyZ/2lrb2v8Ax1TvNQs7FN9zKq15tXEU4PXU7KGHqS+DQ+S9W8K/tP3k32b+2bRYv+nbav8A7LXL337P/wAWtTT7T4q8cQW3+/PM3/jq17h4u+PHg/wukkKXKtP/AHEfL18f+Nvj94h8T+Zb2C/ZrX+83369bD42vV/gUl6nb9XqL+JI53xx8L9N8HW3nXPiaHV7r/njbx//ABVeP7nT/dq7eapeXz/vp2k/2mrO+d6+0y3D1I0/3u7EOkk31a0/TbzU5vs1nH5jV0Gj+Fbm+/fXn7iCuwk1Cw0iH7Ho8f3f4m/z81GIxcYK0Nzgq4+Efchqypa+GdK0KHztYk8yX+7Us3iSbY0OmxrBF/e/irn5GmvpvOuZWkb/AGqtrGi14OIqOfxs8qvVv8buyBvOnffM26pFjqbbTlWuU5JVRm00+n+XT/LkrIj2gypVWneXVhY6gwnUKu2jy60Ft99WGt4YE86Zlji/vMacat/dSuR7UzfJf+7VyG1+Te61qaDpfiHxbef2b4J0m51m6/6YRsUH+0zfwrX1d4H/AGL/ABnr/l3nxF1tNEtW+/Z2H72dv9lpPuL/AOPVliq9KhD/AGiaX5s66WFlPfQ+Nrq802z/AHc0n73+51f/AL5Wux8M/D34neMXX/hFfCV5cxS/8vM6eTD/AN9SYFfrD4F/Z3+FHw+2vonh+Ge9/wCfu8/0mf8A76k+7/wHFe2R2sNvtSGNVVf4a+YxHFdGGlGF/NnfSy3yv6n5a+Hf2M/ipqflTeIdb03Qom/ggRruZf8A0FP/AB6vatH/AGH/AASnz+JNd1TWW/uq620X/fMeT/49X3Ptp1eFX4mxcvtW9Dsjg16eh4d4T/Z7+Evgza+j+GbTz1/5a3CefJ/31Lur2C3sbOzTybaBY1X+FAoX/vla0dpo2mvGr42rV+OTZvHCwXTUh2x0tS7TRtrnuX7IioqXbRtouEaQ2ipNppdtTcv2RFRtqXbRtouV7EZRtp9FARgM207aaWn0GvsyPaaXbT6Km44wDbRtp1FTc09nEZtNLtp1PouX7Mi207aafT6VxxpRIPLo8up6KLlezj2IPLpNtWKKLi9lEr7aTaasbTTdtO5EqBDtNM2mrO2mbaLkyoEW2ipdtG01VyfZFfbRtqxtNN207k+yIdtG2pttG2i4vZFPyE9aqXWl2F4jJcwJOrfwuMj/AL5atbaaa1XGq1s7Gc8PH7SueDeKv2d/hL4t3Tal4btFnb/l4tl8iTP+9Ftr5q8VfsR237x/BuvzW39y3v0WVP8Ad8xfnr9C9ppm017eD4hxeH+CenZ6nFVwUHtofi/4o/Z5+MHhLzXudE/tK1j/AOW2nS+d/wCQ/wDWfpXjc1rcwTNbXMDwTr96F0ZX/wC+Wr9+2t0b+GuL8TfDnwb4vtvs3iTRLTUl/vTRKXH+63Va+mw/GUH/AB4fNHmVcBUPwsaHd/8AE1Xkta/T7xh+xj4J1PzLnwre3eiXTfdVz9ph/wC+W+bb/wACr5R8Yfsv/Ffwn5k0MEOu2sf8dh9//vy3NfV4PNcFibeynZvozl5Zx30PmJreofsvtXTXVnc6ZN9m1K0msp/7lwjRn/x6oJFSu6tSnB7XXcf1iSOYkhqv5ddJJa1RkhrPn8jqpYq5m7TRVpo6j8uSuaUeY6PaEO01G0dXPLqJlrMFMjjvL+2+5L92taHxFM6bLyNZ1rEkV6aq1L095bnRJQfQ3JLHQdTf5JPsktZN54T1KBPOh2zxf3kqHy6uWuoXlj/x7SMv/oP/AHzXbQzepHcqFWcfgd/U5WSF4n2TLtqOu8/tC2vPk1W2WT/bX5WqtN4ds7lN+m3P/AG617tDH0au+h108avt6MzdD8Va94cuftOlXrwN/vV9ReA/2kP9VYeLYm/6+If/AGZa+TLzS7+x/wCPmBlX+9/DVGuDG5Dh8RF8is+6PZoZholPVdj9bNB8SaV4ntvtOj6hDd/xbUPz/wDAlrc8t/46/I/SfEWsaHcreaVfTW0q/wASPivovwf+05r2meVb+J7b+1IP7/3ZP/sq+UrZVjMN05kXVwuHq+9Sdn2Z90bamj3pXlfhf42fDrxV5cMN99knZfuTfKa9dtfJvIfOsJVnib+7zWEM1gpclRWZ5eIyypH3rXXkVbizsNQTy7yBJ1/2q5e68C2yO1zoN3Npc/8AeQ7l/wC+WrufJ/5Z07y9lenSxi+y9DjjBo8q2/G+0ufJs/EmnfZf772u0/8AA69T0/SfjBcwr/xUWnT/APTFFVaGt93+1WFdeGfNfztNvprKf/Zdttc+Kw8KvvxSTOiFf7LZ0lxJ8eNH/wCPPw3Bqn/XG8ij/wDQqyF8ZftM7/Jtvhvaf79xqUP/ALLWbZ+PPid4Sf8Aff8AEwtV/i3eZ/461eseH/j1pV9tttYtvs0v+z/8TXgYrD4mH/LtS80dtOlzfBI5G1m/aovv+Yb4V0v/AK7T3E3/AKDWxD4R/aBvv+Qr4t8OWX/Xtps03/oyZa95s9a03VU86zuVk3f7XNaG014H1+f8qXyNPq9vjPCf+FY+Obn/AJCvxIvf+4bYWdr/AOPSecakj+Bvg+f/AJGHUNd8Sf8AYR1W5MZ/7YwtFF/47XtLVHUfWpy6/oHsIHJeHfAvgnwh/wAix4d07SZf+e0FvGszf703+sb866ppt9Maoqy5fmWSeZTt1Q7jRuq7Fk1MoplMCuy1C1WahatQINtG2paRqkCOk2mn7asR2vm1EpWAz2Wp4bN5a5jx38R/h18LLD7R4y1uGynl/wBTZp++vLjd93yrZf3jZP8AwH3ryKG5+Onxr/48YJvg/wCCJ/8Al4l+bxDew/8ATNOltu/76/365p42MdI6sv2V/i0R3njr4qeD/At/H4bT7T4k8W3v/HpoGkJ9pvT/ALUi9IV9321x8vwz+LnxRh+0fFDxVJ4J0mb7nhzwvL++X+79r1H/AJat/sovl16x4C+Gfgb4WabJYeENN8mef/j8vrhvOvbp/wCJppm+Zv8Ad4X2rsWuHasoUqs/jJ9yJ//X+MqfRTq/oCeh+PjaX56N2/5Eqz5Lwf8AHy23/Z71x4jH06S5pux0YfC1KslCCu2VlheX+GtL7HDbJ51y21f9r5a5XUPGlhY/udNi8+f+92X/AIFXCXV9qurvvuZN36D/AL5r5nEZlisR/BVl37n1OHyaFKKdV69jvNS8cWdjuh0eJW/2+v8A+1XA3FxquqzfabiRv+BUsNikT73+artTQwMY7u7e7O6WJjDSmrIgjtYVT+81TLvqSp/L/v1der7KJy+9OXcr7TWbcXX9yk1DUP8AljD92qdrbvK+965lScouc9jthQUVzSIljmnerMmyD5KluLhLb5IfvVnrG8r/AD1VL7kb7/FohGV3+eomarM0nlJsSn2cPmvveu3C0+tiue0eaRq6La6PPN/xOJJ7aD+/bxrKf++WZa9Fj8C+B77/AI8PHFpBcf3L+CWD/wAe+7XAxw1YaGvoqWazj7vKtDzKs3KejsehN8CfHksP2zRPseuwf39Ou4pa5e8+HfjzTP8Aj50S5X/gG7/0GsW1mudOm+06bczafL/ftpGib/vpa9U0H44fEvw99/UodbgX/ljqkXm/+Rvll/8AHq64ZvT/AOXkL+hL9r0afroeUSaHr1p/rtNuYv8AejkFZ7W9/wD88HX/AIA1fcHhf9rDwwv7nxn4QuYP+m2nSxzJ/wB+Zdn/AKFX0F4d+PX7Ouv+XD/bttpcv9zVLSS2/wDImxo//HqwxGfYSH/Lpi/2j+Vfefk8trqT/wDLBv8Avhq1rfR/E8v/AB7abcyf7sEhr9wtBk8E68i/8Irqmiatu/587i2m/wDHVausXR5rX/l28v8A4BivOnxRhPs0wl7f+Q/C218B/Ei+/wCPPw3qkn+5aS//ABNdLY/BP4wX3/Ht4X1L/gcXl/8AoVftc1rN/tUz7BN/co/1rp/YpL7zKXt/5bH4/Wf7MvxvvP8AmBNB/wBdp4l/9mrprP8AY7+LVzt+2f2daf79x5jf98xqa/Vn7DNS+W6fw1P+t1WPwRSJj9YfkfnPov7EOpM6/wBveJEj/wBm2iz/AOPNXr+i/sd/C7T/APkKz3eqS/8ATSXy0/75jr64bf8A3qxr7VtN01Ge/uUg2/3q4/8AWPG1fchK3kka/UKu9Rnmuk/A34UaHt+x+H7bcv8AfXzP/Qq9KtbGz06HybC2SCL+6iKteW6t8YNKim+weHo/7Qum+6qbjWh4fm+IuqzLeX/2bTbL+46MztSxFLFyhz4iTt0uzlhQoRl3fc9Gkb/gNVJP++qNQ1Cx0qHztSuUi/2m+WvDvFnxy0TSnaz0qCbVL3+CG0TzXP8A3zXNhcPUqtKCudEnCMd7I9ikrkte8TaJ4etmvNVvbe0gX+J3Uf8AoVfNl1r37RXj3/RtE0lPDdlL/wAvFy373/e/yKo/8Mn6xrU39pfEXxi9z/f7/wDfO6vU/s9Q/wB4qKK/EuniqStyq7M/xt+1RoNj5ln4YgfVJf8Ant92P/vr+KvkzxN8UvHni2RnvNSmtrVv+WNuWVP++q+r9e0H4FfCiHZZ6b/beqR/8tr/AGy/+Q/u18h+PPEVt4j1hr+ztIbRf4Ut0WNMf7q19JkuCwXP7kG/N9Ts+uTl7trI4ZvMd97tub+91okaod1bmj6Dea1Nsh/1X99ulfWVZRgvJE1aiiuebskZtrZzXk3kwrXo2k+GbbSk+36w3+6lbyrpXh6Hybb/AEm6b7zelc/dTTXc3nXLbq8DEZpKV4w2PncVj6lVuC0X5kt9qk1z+5h/d29ZHl1Y8unbdteZc5FyxVkRrHsqVVqdakVaRlKZAq1Kq1Mq1YjjrGbMZ1SFVqby6tR29Xlt/K/13y/7VY/FLlick65mLHvq+trsSuu8M+F/E/jO/wD7N8E6NPq91/fRNsKf9dJG+Vfzr7Q+G/7GtnF9m1j4o3v9oXX3/wCzbBmjtk/2ZpOsn/jtcuNx+Hw0P30rPst2dOHwlWvflVj4m8I+EfE/j3Uv7K8GaTcalKv37jZtt4/96VuK+2fhz+xvpVr5epfE69/tmX+HTrfctsn+833m/wDHa+2NF8P6P4es49N0Syh0+2g+WOG3RY0X/gK1tV8dj+K6s17PDrlXfqe9hcq5dZHNeH/C/h/wrp8WleHtNg0uzi+7DbRrGv8A4796ujp200/bXydSq5SvN6nqwo/ZSGUVLtNP2ms7msaRFRtqXaadtNK5rGgR7adtNPoqLm3shm00bTT6KLj9mM2mm1LTKszsNop1NoGFFFFBIyiiiqMQp9Mp9SUgp1G00UGwUUUVAD6KZup9BYUUyigsmopitT6CojqKKKgsbTqKKCoxCiiigYU3bTqKCbDNpo2mn0UD5CLbTtpp9FBHIQ7TTasU2quZukVtpptWNtJtNVc55UCDbRtqXbRtNVcn2RXZaiaFH/hq3tpGWnGZlKkee+Jvh34P8X2zQ69o1te7v+e0SsV/3W/hr5G8efsY6DeeZc+CdQm0uf8A59n/AHsDf+zLX3xtNV2r3Mvz3FYb+HLTsefWy+G8VZs/EDx18GfiF4Amb+29GuJLL/n7tlaWH/x37teXeX/sV/QFcWMNymyZVb/eFfO/xA/Zl+G/jrdefYv7G1Fv+Xmw/d5/3o/uNX2OD4xp1bfWY2fdHk1cLOPofj/JDUbQ19U/ET9lX4i+DvMvNB2eJNOX/n2/d3Cf70Tdf+A181XGn3lnN9jv43tp1+VkmXa+7/dr6uhGniKXNh2mjDnt1Mfy6gaGtdY6a0Nc84Sg+WQ417GG0NReXW60NVpIaR0QxBl7ajkWtBo6gaOsJQOhVSj5dN2v/A21qt7aZtqJRN4zL1rrVyv7m/X7TF/49VhtJ0fWPntpFtpfy/8AHaxNtRyR+U+9PlatKWIqUn7jNoy7PUi1LQb/AEz78fmxf305FYtdvp+vXkHyXLblqa40fStZ3TWEq2l1/c/5Zt/8TXuYXOV8FVW8zrhiOk/vOAVtn3K7bQfiN428NTRvpWs3Mflfw+axFcpfafeafN5N5F5TVRrtxWDoYiHvq6Z6dDFTjrBn2D4b/a216zRYfE+mw6pF/fT93L/31Xuvh39pL4Y65/x86g2kS/3LxGG3/dkXg1+Zley/C3wX4A8YTfZvFWv3Omzt91IEX/2avjMfwth6X7yE3Fdjv+u+192cU2fpZpPjDwfrif8AEt1+wuf9yeM10v8AoD/8t1b/AHW3V8uTfsl/CuCGO8sNd1a9VveEf+PKlekeDfhf4e8HfPZ3OpXP/X3dNKB/wHpXBSw8+XmpVLrzPKxEqUW1NWZ7H5MLVgah4R0TVfnmgVZf76/eouri5iRns/8AW/w7q8/m+J1/odz5Osaf8v8AeXdXrUMPiLXp6tHnx9lJ2va5t/8ACM+LdDfzvD2oeeq/wTMyt/30tdRpPxQ8T6K/2bXrab/e6/8Aj1UtD+I3hjWY/wBzdqrN/A3DV1iyaVdx/PtZa87FVKc3yYiOp2wp1IfA7o77RfiFpusJ/rY9391m5rq11KGWvni68I6DfPvSWaBv7yPtaq0PhPxJp/8AyBPFc0f+xcp5teXXyah/y7dvIuGKn9pH0l9spv2ivBob74qWn/LSw1D/AIA0ZarC+MviRbf67wzDL/uT4/8AQq5P7Hl0aNPrcex7d51SLJXjcfxE8Sf8vnhSdf8AcljNX1+Iyf8AL1o1/H/uhW/9BrJ5VV7F/Wo9z1yivHJPiFpv/LHS9Rk/4DtFczqHxE8Wz/JoOlw2n+3ds0v/AI6tOGUVZdBfWoH0Sy1Dt3fxV8yNrnxRn+ebVktv9mKJR/6FWBqUniTyftOt+L9Rtrf/AK7rax/99fLW8cmn1kifrUex9gxw/wDfNYWqeKvBmhwtc634i03T4ovvNc3cMf8A6E1fAUnhH/hP/wDRvCVjr/jbzf8Al7murj+z0/7erho4v++N1dL4T/YXsLy8/tX4na3/ANwvRflT/da6kGW/4Ai1hXy+hSTdSrr2W5pCtOXSyPY/EX7XXwT0acab4fu7zxnq3/LCz0S1km3P/CqyNsT/AL53Vmx3v7UPxd/dWdla/Bjw7P8A8vNz/petun+zH8vl/wDfMf1r33wT8N/h78N7b7N4H8O2ejf35okzcyf79xJulb/vquz+0V83Klz+h1njnw7+AXw++HNyfEPkT+I/FT/PLr+st9qvS/8Aej38Rf8AAfm969mmuHf+KqjSO9RM1bUsPykAzb6hakZqSuyMST//0Pi+tKOz3/PM3kKvzfN97/x6s3UPEWlaVHshi/e/7Lqz/wDfX8NcDeeJNS1N/Jt28tf9mv1bEZniKmlNW8z43C5NTVpzd7He6l4osNNT/iW/63/ns/X/AICted3l9f6ru86R1gb725vmf/eqnHa7H3zN5sv97rVmuGnl/vc83dnqe3jD3KSsitHbwpVtW2U2ms1er/dOV+98RY3bqNtOWpm/dR73rhq1uUI0Bu5IvnesO+1B5/kT/VU24uJp32J92rMNj/frNR19pP5HdHkpR9Sva2Pn/fq3cXiWaeTD96nXV4linkw/erHhhe5mo/i+/PYr4vensJHG87/PVuZkgj2VZm2WcP8AvVlxxvczVpSjzeiF8XvS0SH28PnvvFbkMe2mwwon8NXo69X4UcGIxHN6AtOapqGo9qcPOVKKfRtrcq5B5dPaGH+7UlWNtTLlZ0QqmZ9jhT99Cvl/3dnB/wC+q7fR/iZ8TvDX/IveNNd09f7iX02z/vlm21ze2nfudnz1l9SpS+ydEcRPuez6f+1B+0PZp/yPFzOq/wDPzBbTf+PNHXQR/tdftAxff1mwn/37G3/9lr5qmuIYvufNVf7Q7/w16OH4PVf4I2N/rtU+npP2zvjkifPLpf8A4Br/APFVnyftefHK5/5fbCP/AHbSOuC8D/Bfxz49df7H0ub7K3/Ld12x19ufDv8AY/8AD2keXf8AjOf+0p1/5dl4j/4F/er0MRw/lGX/AO9yu+y3M5559iCu/I+adN+Kn7RvxDm+waPqFzP5v/PnaxxD/v5t4r6C8C/s1+J9QePWPiV4gu55W/5dvPaR/wDgTV9j6XoeieHrZbDRLG3srdV+5CiqP/HamuLhIk+evMr8S8sPZZfTUF33bOOrCpX/AIr07GBoPhPw34VtlttE0+G22/x9Xb/eZq1JtQhT5N3zVzV5rE07/ZrarNnD5Sec/wAzV4kqEviqu7Yo2j7kEN1bR7PWYdmpWyT2/wDdcZrLsdB0rTf+QbaQQf3vJRVrU1jUtN0eza/1vUEtoI/4WdRXyb8QP2otH0/zNN8Hx/aZf+e38FKhVrz/AHdBX/I1llvtffqOyR9L654q03w9Zy3OoTpAsa/7K18SfFL9pB7l5LDww27+9N/8TXzl4q+IXifxjeedrF87f7G7CL/wGuKkZHSvo8Bwu+dSxLu+3Q2jOFJclNadxdU1i/1W5a5v5WlZqx6kb569I8K+C/7Rh/tjWG+zadH+Hmf7K19zVnSw1PXS2xFWvClG8jmtD8N3Opv5z/u4IvvtXcyXyWNt9g0392v8X+1U+pagj/6HYL5FlH8q/wC1/vVh18ziMe6vofOYjFTqz5nt2I1+elp+2rarXGcc52KlSxr8lXFhqdYazlM551ymsdTxx1djt6uw2tI5p4iJnx2++tOOzRPnf7q/erW03Tb/AFXUoNE0TT5tS1S7+WG3t03H/eb+6K+1/hn+yLc3McWpfFS783+7pdp8qD/rtKv3v+A/nXLjcXSwsOetK1+nVhQw9Ws/cWh8beFfCvifxrf/ANm+D9Jm1aX+8ifuY/8AaeT7q19pfDn9jmzgmi1X4nal/aUv/QNtGZbf/gU335P+A4r7W0Hw3onhjTYtK0Gyh0+yj+7Dboqj/wAdrbr4bH8UVJ3hh1yrv1Z9ThMmhS+PVmLofh/RPDVhFpWg6fBptlB8scVuixov/fNbm403aaeq18rOd/ek7tntUo292KsFP205VqZVrOUjqhS5iDy6ftNTbafWVzaNAh2ml206ii5ryBRRRQMKKKKAG0xqfTKswlIZTadTaswCmVJ5dJ8iffrCriqcfidi44ectkFO2mvLPGnxu+Ffw+Rv+Eq8UWOnyr/yx8zzJuP+mMe5/wBK+XPFn/BQT4S6UGTwxpuqeIpf4W8tbSH/AL6l+f8A8crnjjeZ8tNNnZHLZr4nY+9fLpdtfj54o/4KGfErUNyeFfD2m6NF/enMl3J/7TT/AMdrxPVv2wP2h9Xf/kb3sv8AZtLeGL/2St4UsXU+GFrm0MFTj8bP3r8y2T+Jap3GrabbfPcTpAv95yqj/wAer+ebUvj18bNY+S/8ea1J/wBc7p4v/Re2vOtS8Qa9rPz6xq17qH/XzcSS/wDoTVrDIsbP4pWN+XDx6H9IC/ELwG832f8A4STS/NX+D7ZDv/75310Nrqmm33z2dylyv96F1k/9Br+Yfy0rS03VtV0ib7Ro+oXOnyr/AB20skTf99LW0uHsZ9iZl+67H9OW6H++tSeXX862k/H742aGu3TfH+tqv/Ta7ab/ANG769M0X9tT9obRf9d4hg1b/r9tIW/8ejCGsZZbj6W8boPYUpfC7H7veXJRtkr8l/Cf/BRfxTaBYPG/hK01D/ptp07Wz/8AfuXzB+tfS3hT9vD4GeIfKi1i61Hw3O3/AD/2u6P/AL7t/M/pXHOtUh8cWrE/VI9GfZ1FcR4Z+J/w+8ZwrN4W8TaXq+7+G2uo5H/79/fH/fNdwskL/wAVVHG0n1sYSwc0OpNxp3l0m2tozT2dzJ02ugU+mUVoO5LRRRUGgUU+igoKKfRUmvIMplTUm00EuBFRT6KozsMooooEFN21LRQFiLbRTqKA9mM2momWrFM2mquYTpEFM21Y20zbVXOedIqstRtHVzbTNtaRkcs6BnyQ768y8ZfCHwP44hZNe0mGeVv+WyrtkX/aVl5r1hlpNprrw+MqUpKdOTTXY4K+DhLSaPy/+J37I+vaL5+q+Bp/7UiXP+iXPyzD/dbo1fH+oaTrGi3jWGsWM2n3q/ehuE2n/wAer9+mjX+Nd1ec+NvhX4N8e2bW3iHTYbn+5NjEkf8AuNX3WWcZ/wDLvFxuu63PMq4GcV7mq/E/ENo/+BVF5dfXXxM/Zb8Q+FXudS8PbtS0tfmTYP3iD/aWvlqazmtpGhmXay19lSp060Pa4eV15bnkRrK7hs+xhtDVOSOt1o6qyQ1xSkb0q5iNHUci1qyQ1WaOo5b+8dsKpl7aiZa1GjqFlrM6o1TKaGkXfF9z5atNRtrOUf5jq9qaUOsb4fs2pKtzF/tdVqndeG0uUa40eTzF/ud6p+XTo5rm2f8ActtrrwmNnS92+hrCdvgZzs0LxPsmXa1FvNNbTR3MLeVLH8ytXoP2iw1mH7NqUax3H8Mq1yGraPNpj/3o2+61fR0MVTxC5Jb9j0MPiveXRo+sPhD8entng0fXpdv/AKLf/wCJr7X03UrDV7b7ZYSqy/3f4lr8Y1r2n4d/GbXvB1zBDcSvd2S+/wA6f7tfJZpklfCP2uE1XVdj2KsKWNVqukuj7n6gtHWLqmj6bqsPk38CyK396uF8D/Fzw34xtl/0lI5/y/76WvUvv/w7v1FceEzpXXRroeBi8nqUpOLV0eGa18H9Kd/tmmyTW0v8Ox8Vb0Hw7/Z8y22q+Ir+y/8AIg/76r2VV/uVFNYpP/rlVq9yvVhiIWq6+fU5aHPS+B28i1Y+E/EPk79E1u2u1/ha43Z/8dqjdab8ZtPf/kCabq//AF73TRN/5ErJm03VdO/feGJ0sp/4mZWYNW3Y/GDxJ4VT/iqrLz4l+/cQ/wCrr56vha9L+FZrsz04/vetmYDax8XbZ/33w7uP+2N3FJV9fGXjO1/4/wDwTq0X+5F53/oNeweE/jh8PfFvyWepJHOv3km/dmvWLe6s7xN9nOki/wCwVNeBXzKrS+OlY6Pqs/5j5Q/4TjVf4/B2u7v9mwko/tzxnc/8efgDW5/96OGH/wBGyLX1gy1A0dZPOO0UX9V/mZ8peT8Yrz/jz+HyR/8AX/q1tF/47H5hrcs/Avxdu/8Aj/k8NaJ/ufbNQP8A7QSvotvkqJmqZ5rVl2XoR7KJ4Za/B3xDc/8AIe+IOo7f+eOkWttp6f8AfTefL/4/XRaX8GfhvpVz9vm0ZdZv1/5e9Ykk1Cb/AID9oZgv/AQten7qTdvrmniKkviZpGC7Eq/Iioiqqr8qqvChf9lf4aVm31FT65rG4UxqGqKrjEB1MamM1RtWkYgOqKimbq1A/9H83o9PSL/lqzVfWNP7tO20+v1uXL9k+TqV5S3ZWam1M1MoHEYtNZadup3yQJvm/wC+axnV5feOqlS5hzSJAm96xpLqa8+T+GmTTTXMlX7Ozeo9krc8/kdHwLl6j7W3dKmvLpLNPJT5pabdXyW37mH/AFtZMMM082//AL6rGV56vRGcaX25kUMLzvWzuhto6csaQfcrIupvNf5K0+LQd/ay8iORnuZq1LePyqr2/wC6+/Vr7VHXuYXAT5NhV5N6R2NJaetZ/wBsh/2qZ9u/2a0+oVZR2PP9hPsbC0+stdQT+7Uv9oQ/3WqP7Lr/AMrI+rT7F9VSpMRVltqT/wDPLbVrT7PXtVfydKsZ71v7sETSn/x2uylkWIl70tPU0jS/m0LDR/J/q6rtMkX3/wDx2vWdB/Z/+MfiXb5fh27tov795/oyf+RK968L/sX37us3jPXbe0i/542A82T/AL6biuyll+Coe/iqq9FuZ88IaXufEUkzv/qd1dV4b+HfjnxjMsPh7RrzUN38aRt5X/fxvlr9TfC/7P8A8JfCvlzWeiLqF1F/y8Xb+c+f91vl/SvZbdUtoVhto0tol+6iIqr/AN8rTq8TYTDrlw1K77spTqS+BH50+Ef2K/Geo+VN4t1K00aD+4n7+b/x35P/AB6vrTwP+zT8KfBnl3P9n/2vfx/8vN+3mf8AfMf3Fr2jzJnrPvtWsNMVpry7SLb/AHjXz2Mz7H4r3OayfRIX1Wfx1XodDbrZ2MP2azgWCJfuqgUAf8BWmSTO9cRpPixNcv8A7NpWn3E9uv3p2G1P/Hq2tc1zTfD1nJearcpAsS7m3NjbXh/VKiqcjWr6dTpo06XLzQ2RfuLpLdGd2rgLzWLnWZms9Hj3Kv35v4B/jXn1n44vPiDqUttokX/Erg/5bPu+erfizQ/ivNZx2fgPWdO02L+PzoMv/wB9V7cctdBqNRpPz6HP9ahV+B6d0d5I2ieF7Nr/AFi9htv701w6r/6FXzn4+/aw8N6R5mm+BoH1u/8A+e23EI/4F/FWP/wzHrGvXP8AbHxW8dz6l/sQ/wD2X3f++awfE2rfB/4V2Elh4M0C21DUf+fm7/ff+hV2Qw+FlPlnJzflojq+Bc0F8z5b8beOPG3ji8+0+JL59sn/AC7dIkrhljSJdla/iDXLzWtQnv7xtzT/AN1VVf8AgKrXPNJ8lfdYXDwpQ5Kat5HLKdWr8buRzSIlVWkd6SRvMevUPCfguHyf7b8Q/urKL5o4e8ldM6tKlDnmaVasKUOae5B4T8Iwyw/29r37jToPzkb+4tbeta1Nqu2GFfIso/lhhXoFpdW1abVZl/5Z2sHywwrxhay1WvlMViJ1588/kfMYjFSnO8iFY6PLq5Uiw1xHD7UrrDVhY6lVatrHUSOadUhjhq3HD89Xbez3pXQ+HfDuseKNVj0Hwxp76pqMv8EP3UX+8zfwrSUd3fRbs4+dylyw1ZhLapEnnTfKq1738LfgH4w+JflX7xtoXh9sf6bcp+8lT/p3jb73+83y19SfCf8AZf0Tw15GveOdms6uuHWBubWA/wC7/wAtNv8AtV9dRxpEioi7VWvk814mUL08Nq+59DlmRyl79bbseb/Dv4U+D/hppv2Pw3Yqsrf667l/eXMp/wBqT/2X7ten0ypdpr4StWnVnzVHds+xo0FH3ILQZtNLtqRVp+01hc6fYkG2pFWpNtO21MpGsKAbTT1p9FZnXCFhlFPo21NzT2YymVNTKozlEZRRRVGYbjUVFFWA+mU/bWD4i8UeHvCemz6x4h1CDTbKBdzz3LrGi/8AAmrmq4qEFzSY6WHnLobu01z3iDxR4e8K2Emq+IdSttLso/vT3MixIP8AgTV+dXxg/wCCgFha+fo/wl0/7dPyn9qXi4hX/ahi6t/wKvzh8a/EPxr8RNT/ALW8Y61c6tP/ANNn/dx/9c4/uLUYfB4rGP3FZdzujQp0vj1Z+pnxO/b98D+Hnn034e6bN4ovF/5e3/0ey/4D/wAtJP8Avla+BPiN+1N8ZfiR5ltqWutpenN/y56X/oyf8CYfvG/76r52p9fSYXhuhH49WTLFfy6AzPKzTTNukb+Jvm3f8CplFP219DQwiWkEckpDKKl207y69Gngp9ibkFPqby6Ro61/sucfeD2hFTKsbaZtqXg2FxtFOo21n9Wl3Aipm2rFNrnnhb/Eh3BfMidZoW8vb/EvFeseGvjx8ZvCAX+wfHGqwRf88prhp4f+/c29a8o8uneW9cdXIqdX4oGsa7j1Pu/wf/wUC+K+jeXD4t0nTfEkC/xorWU//fUf7v8A8h19mfD39uH4M+M/Ks9bu5vCV/J/Bqg/c/8AAbmP5P8AvvbX4h03bXiYjheH/LhtM2+sfzo/px0vXNH1yzjv9HvYbu1l+5NbyLJG+fRlyK2dtfzT+EPiB448AXv2/wAG6/e6NJ/07yssb/70f3G/4EK+3Phz/wAFBPGWjeVYfEjRItbtv+fyw221z/wKP/VN/wCO14WIwGNw/wAUbruV7ClP4XZn6/UV4b8Nv2hfhZ8VIYx4Z12CS9/isp/3N0v/AGxblv8AgO6vcl2P9yuWlioTvHZroYzw84+g+n0UV0CjEKdRRUGwUUUUAFN206igVhm00bTT6KsXsxm00tOooD2ZFRtqTFJQTyDKZtqbbRtouR7Ih202rG2kZaLkypFfaaiZat1Gy1UZGE6RW20zbVimVtc4p0ivtNN21Ypm2nc5ZUilJGj/AH1rwD4lfs++DPH8Ms3kf2XqP/PzbDGf95ejV9E7TUTLXo4LMa2Hmp0nZnn4zAwqx95ao/Hj4jfAPx54AeWb7F/amlr/AMvNtub/AL6XqteGND/fXa38SsPu1+9N3p9tco0NzGsit/er5c+KH7MPhjxf5mpaD/xKNR+98n+qdv8AaWvvcBxRQxHuYlWfdbHztbB1KXS6Pyxkj/v1UaGvW/Hnwv8AFXw8ufsevae+3+C5T5o3H+9XmLMj/wCpr6J4f3VOGqfVbGMK9/h2Mlo6gaOtxo0qrJDXGdEMQYLR1H5daUkdQNHQd8KpntTKuNHUDLsoOhTKzL8/yVchuP8Aljc/vIm/SoqfVwm4u63RvzmTqWjvbJ9ph/eW/wD6DWLXbWdx9mk/56q33lqvq2kwzp9s03/gS19Hgs05/clp5npUMRc5/T9Uv9KuVudNneCVf4lr6p+H/wC0xf6Z5Gm+J4vMg/57fMf/AB2vkpl2UVWP4ew+L1as+6PXpY2rHTddj9dfDPxC8G+LbaJ9N1CFZW/h3rXfeS/+y1fiva315YzedZzvbSr/ABIWU/8Ajte/eBf2ivGfhfbb6lL/AGlZf3X+/wD99V8viOHMZhvepS5kjV0sPX8mfpf5NJ5KP/DXlPgH43eD/HFsv737Je/xI5r2TbvTzk/eK38S/drzaWNd+WSs+x5+IwE6W60fU4PXPh74S17/AI/9Lh81fmWeEeTMn+0ske1q5qH4f+KtBm87wf4xu4P+nfUUWdB/uzLtl/8AQq9Zaiuz2t48r1Ryx/unLWfxA+NPh5NmpaNba/Ev8VtOv/oLbZP/AEKunsf2jNKtv+Rt8O6ton+39naeP/yHU26SmMySpsmXd/vc151XK8PU3j92hv8AWKi6ne6H8YPhd4l2ppviSwaVv+WLyeTJ/wB+5trV6FD9jvE32c6zr/sFW/8AQa+UtY8A+CfEP/IY0S0u/wDfjXd/31XFyfA3wnbfvvDF9qXh2X+FrO6kUCuOfD1H/l3Nr1R0Rxv88bn3C1m/96ovs7rXxla+EfitpX/IH+KeqL/sXaRzp/49XQWOqftA2P8ArvFei6kv/T3ZbW/8h1zTyCrH4Jpmn1yn2Pq3bRXh+k+MviFF/wAh7+xZ/wDr2WaOuvXx1/fsWZv9h/8A4quCeV1ou1vuJ9rDud61R1wMnjp/+WOkzSf9tFWuW1T4jeMItqaJ4LW93fxT6lDAif8AkNzTjltf+WxftYdz2RlpvlvXzxN42+OVz/x7aR4X0v8A673d5dn/AL5jjirPkvPjTd/8f/jTTdN/7BekK3/kS6lk/lW6yqs/+HI+sRR9KbahaN/7rf8AfLV8yTaP4knh/wCJx421/UP9yeOyT/vm2SNv1rJbwjpv/LzbT3v/AF8z3Ez/APfTSV0wyaf2pE/Wo9j/0vz1o207bR5dfqcqvmfHQ1Idppvl/wDfVTtHTJGS2Tzn+9XNVxSitzvw9Ln+HoVbiRLSHe/zS/3aw2k+0v8AO33qW4me7m/vVsWum7EV3+Zq6KUVFKdV6s9CUuVckR9naolOvrxLRNifeqxcTQ20P+1XPNvvrnZWMOavU8jGNLl95u7IoYZrmb/0KukWHyofkWi1tfKTy46bfXX2aHZ/E1PEVdVThqzkqSlWfu7Iz9QmSJPJT71VrWz3/vv++ajtYftM3z/d/iro9v8ABXo4Sh7L49WVUq+yjyLc2NFvPDEf/IyaI97F/wA9raXy5F/4D91q7qzs/gvqH/L7Pp//AF9pMv8A48u8V5ivyVBIu+vfw+bV6Xa3mjj9lGfVr0PfLXwL8H5/+Zps/wDwL2/+hVuWfw3+C2/5/E1o3/cQiWvluS1R/wCKo/sf+Wrp/tzEd0H1eP8AOz718P8AwR+Cep/6meG9/wBzU1P/AKDXq+m/s2/CL7/9gfaf9+8lk/8AQXr8rFs0d9j1734P/Z58beLbBdS0G+iitZP78u3/AL621GIljZU/ac9kOr7OPxSZ+iun/CH4Y6N/x5+FNFj8v/ntHHL/AOPSbq7nT2s7b/RtK/s6JYv4LYxDH/AY6/PK3/Zz8JaN8/xC+INtaf34bd42f/0Nq6Cz/wCGV/A/762iv/EF7H/G7t/9itfM4vFUl/EqXZP1KM9rs/QBdQSX5Eu1kb+6nzFf++a047ff8+1/95/lFfnvrH7WU1tbfY/BmiQ6fF/A+Oa8A8VfHD4neJfNS812eCL+5E/l/wDoNfPQhjcVPlw0bLuetQwlCK/ePU/XHVPFXg3w7D53iHXbOyiX7371VrxnxF+1l8E9BhZNNubjWZ/+naJm/wDHmr8l7ia5vn/0y5muf992NeqfDP4V6x491KK3to/s1l/HPtr7rKvDjES/2jMKtoLU6MVmOFw8fcV/U+kdS/as+JHjjUP7H+Hvh2Gy89/kd1+0yf8AfP3Fr3TwL8HfFWr+X4k+KmsvPKv77yUfaP8A7Gu18C+Cfh18H9E+0/J9tVPnnbbXy98bv2ovtzz6D4Snf+479v8AvquLG59D2v1LJaXk3bU46GWvF2qYvSK1SPffiN+0F4J+Glg2laJsnni/gTmvjG18SePPjv4qjhvJPK07f/x7p9z/AIF/erwLT7PVfFWsRJ897e3L/Wv1L+Cvwz0rwToMU3kf6bPhpnbr/u19rhcnhw9hPreJfNVlst7HJm+NhVthsKrI7/wr4XsPCuj21hbRL+6Ubv7zVuXGoQ2MMtzeN9mt4v738VUvEXiSw0Czk1LVZ1gijVm+b7vH96vzk+L3x61Xxfcz6P4ZneOy/wCeyfx/7lfn+Fw+KzOu401e+77Hfhcthh6alN27I7341fHx9Rml0Hw3J5dv83zrXyLdXE1zN5007SN/tUsmi6xFZ/2xeabdx2X/AD8vG3l7m/2qoy1+gYDK6WDhyQ1fVnn4vEOcvLsQSNveqFx/CiVYuJPlXZ/FXZeD/C/9qzfaLz93ZQfO7tXqxjywc5swnXVGHPI1PBfhVP8AkN6r8sEX61u61qj6rNsT93ax/cRflWrOraslz/odmvl2sHyqq9/96sJVr5nEV5VZ8x8liMVOrNzmMjWp/LpY1qZVrikcUpkHl1ZWOnrHVmOPf9yspGE6pXWGtq1s/K2zTL/wH/4qpo9NmW5is/K826nxshT5n5+6rKv96vuD4L/sv+f5Hif4lxbvuvBo/wDD/stP/wDEfnXFmGNp4Wnz1X6LqzXC0KmIq8lNHhvwt+Bfi34qXMd/82jeFF/5fXT55x/Etuv8X+/92v0q8C/Dnwl8PNHXR/DFkttF955m+aaV/wC9JJ1Y12Vvaw2cMdtbRLBFGoREQKqoo+6qqvC1ar81zTOquK8l2Pu8BldOh0u+4Um00+n7a8S568KXMMVamVadTlrOUjphSsG00/aaWnVnc61AZtNLtp1FIqw2nUUUFhRRRQA2mU+mNTRlIKZRRVc1jGMbjdtNaRIk+dttcR47+IfhL4baFP4h8W6lDp9lBn5nPzO/9xF6sxr8fPj3+2J4x+J7z6B4Qkm8O+Gfu/IcXV1/10kX7q/7C1xRnUxFT2dFfM7oUFFc89j7o+OP7ZfgX4Zfa9B8Mf8AFTeJY8p5ML/6NA//AE2lH/oC1+S3xI+L/wAQfi3qP9o+NtVlu9v+otU/d20H/XOJflry+n19Xl/D8KX7yrq/yM6uI+zDYZRT6Xy6+nhS6QRykdPVak8upFr1MPlsm/f0M5TGLHUu01bWP5KrNX0tXK44emptamPPzDabRRXF7UodSS0LSyLWji3TcivtEVFSMuynqtZLByc+TqTcgoqVVqdv3SVcMvlODnJ6IrnKdMoorxjQKnjmmi+dG21BT60oT/ldiJRO002+8N6mn2PxDB9ml/hu4P8A2eP+KqGteF7zSv8ASYZEvbL+C5t+U/8Asa5qrkN5c26MkMjeU33lzw3/AAGu+NenV9zEL0aOf6vOM+enLR7ooU2rvmI38Ndf4T8M6b4q1KPR31SHSJ593kzXf/Htv/hVmX7u7+9XHVybnv7N3RtPERhG89EcRBPNazR3FtK8M0fzI6NtcN/sstfbXwb/AG2/H/gia30rx3v8UaInyea3/H7F/wBtP+Wn/A+fevmDxx8MfGHw9vPs3ifS3to5P9Rcp+8tpf8ArnMvyNXA18XmHD9Kv8as+jR2YXG6c0HdM/o5+Gvxi8B/FbSl1Pwfq0V3/wA9ofuzRH+7JG3zLXq9fzGeGfFHiHwZrEGveFdSn0vUbf7lxbvtb/7Kv1c/Z8/bZ0fxV9m8J/FHZpOvcJDf/dtbr/f/AOeTf+O18di8HXwf8TWPfsd3uVfg0fY/RmiqsE8dxGssR3I33Wq1ShNSScdmc/LYKKKKoAooooAKKKKACiiigAooooAKKKKACiiigBtQtUzUyric80QstRVYpm01qck4EFFOo2mrMZQG0ypabRcwcCsy1Ftq3TK0jI450jmta0HTdesJdN1W0S7tZ12ujorBs1+f/wAWP2T7m0ml1jwB+8g5ZrNzyv8A1z/vV+kTLVaSHfXuZTnlfBv3XdPddGeTi8r5veg7M/Bm+0u80q8ksNSga2uI22sjjac1Va3r9fPil8DfDHxGs5HmiW01Rf8AU3aD5s/7X95a/Nj4gfCPxV8Pr+SG/gaWD+B1/jH+y1fpGW4qhmP8B2l1TPn53pPkqqzez6HjklvVaS3roGj89N6L/Sqslu/92plCcW4T0fY6ff8Akc60dVJI63JoapNHVQR0Uq5meXUfl1oNHUW2j2Z0qqVNu2pbe6e2m3/w/wAS0rVD5daQgvtHRCpb3upa1rRba4h/tKw/1TfeX0NcLtr0DT777G+x/mgk+V1rN8QaP9jm+1Qtuil+avpMnx+vsqnyPVoYi5iWem3+sXMWn6PaT3t1L92GFGkc/wDAVrb1rwX4t8OR/wDFQ6Jf6b/18wSRj/vpql8G65eeHtbtr+zba0f/AAGv1E8E+Jv+Ej8MW329vte5f+Ww3f8AoVRjc8q4DFqnKN4PY9OtQ/2f2sNWt0fk5Y31/plz9psJ3glX+JG219ZfDP8AaWudD8qw8Tr5kX9//wBmZa+l9a+Evw015pH1LQrTzZP44B5L/wDfUe2vH9c/ZV8K3m5/D+s3en/7FxtnT/2U1lmH9n5j/EvB90cWD4g5Pcmrrsz6b8K+OvCXjizWbRNShll/iTeua6+S1eL+H/vmvzc1D9m/4l+GpvtnhjUoLll/59pWhk/75aug0X42fGz4af6N4z025vbBf+e0X/s33a+Rr5PjaX+7tTXrqejDEYKt8Ls+x9+baZXjPhH9o74aeL/KS5vv7JvW/guf3fP9a9ot7iw1CFZrO7hu1k+ZWhdTXHSxsoz5KqaZlWwvL7y1RE1N3banZdlR16HtInJySZH501Hmb6xdS0Wa+RvJ1C5tG/vQy7cV4vrXwr+IW9ptE+IesQf7Dssn/oO2uuhRp1ftJMn3o7rQ+iobeaX7i1qR6Xc/88vl+lfEDeFfipBeeT4n+IOurZf9OjeW7f7rV7R4R8B/CK+hj/t6TX9buv7+qancyJ/3yrotcmY4SrRV73XlqddCEKuz1PbLyTTdO/4/762tv+u0scf/AKFXOXXjbwZbf8x20lb+5A/2h/8AvmHfXX6H8N/hRZ7ZtH8N6Tu/vNEsr/8AfUm5q9Ft47azRYbCBLZV/hhRV/8AQa+ceYeRrPCPufPbeNEvP+QJ4b8R67/16aZMqf8Af658lP8Ax6ovJ+NOsP8A8STwTY6NB/z31/Uo/wD0nslkf/x6vpHdM/8AFu/3qdtesZ5lU8kR9XXqeEWfwp+Iup/8jV4/h03/AKd/DmnrD/5M3vnyf+OVtW/wF+Gn/MYg1HX5f+e2qaleTn/vnzEjX/vivXdr0u01xe3qfzfobH//0/gLyaeq07caGkSKFpn+6tfbzxDPmaWH973SKZobaHznrj7q6e5k/wBmlvr6a7m/6ZfwrVuxs9/369HC4Xk/e1/kj03aEFCKLml2exPOf71X7y+hsU/vStS3V1DY22yuQ+a8mpwpSxU3Oei6ChHlvKW49pJryat+zs0Tb8v+81SafZpF/tNW8uzZW+Mx8aEeSCM+WVXyRUuPJsYd71xs0j3k1WtSvHuZmT+H+GprO38r560y3CuK9pPdjqyjD4TQtbdIE2Vb20LTq7OeR4vLzNykRbab5b1PT6ftWabFRoaPJqw1DVMqrFMh8hPWp4ZryCGRIZ3VZP4Udhu/4CtM+/Qsmyp56kk4X0MoyGNC8v8Ay0ameTsqK41D+CqHnXL17GW8P16/vW0Oz331si1cTbP4qrxxzXL7PvV1vhfwD4h8T3McNnaP5Tfem7CvdbXSfAHwt/5CVzDrOvfwQY+RP96v0HLcvpYK19ZPZIxq4jlT5NWcz4B+Dupami6xrezT9OX+KfivqLwzrGlaLD/ZvhiL7T5X3pvux/8AfVeQ2tn4z+Js32zUrt9P0Oy/ufu4q6Fo9Y1W5/4Qn4b23mfwXOo/8so/+BVw5/mFfEfuqjsuqR5WH/e1FUnq+hwHxo8af2vMvhvSr6e91GfHnJbO2xP9n5fvNUngX9nXzbBdb8cXf2KL/n2T/W/8CrsLq3+G/wAEf3MP/FSeNLn/AMhbv/Qa9g+GvhXxt49uYPEni2f+z7D78MP3f/Qq5cPSo4DCe0pLlXdrVnbmGNqymoQ/4Y6X4c/CXwlo3l3mlWXl/wC067pDXf8AxA+IHhX4ZaO1/r1z5f8AzxhTl5H/ALqr/FXKfFD40eHvhppraV4bjXVNcb/Upn5F/wB6vnnwj8EfGHxU1j/hPPi5ezR2sn+ptv49n93b/wAs46+dnSqYx/WcfJqHS+7NcPUoYVd5Hml1efFH9pPxJ9g0q2e20ZX+5/yxjT/ps38TV9Q+F/gX8N/g7pv9veJ/+Kg1uL/lk/8AqEf/AHe9e26Xa6V4V0pdK8MWKabYQf3Fxux/6FXwr+0B8XH+3yeHtHufMlX77fwr/wDZVhVzWvip/UsCuSHW27O/Dw9t+9rbdEcD8bvitqvjPVWsPP8A9Cg/5d4R5cKY/uqteC+dvj2VHJdb0Z5vmZv71a/hvRbzWb9YYY//AK1fc4XBQw9Hk7HLiJpXnPZGv4X8LvrU2+b5Yovnd26ItdrqGoQ+THpem/u7CD83b+81T300NtbLo+m/6qP/AFzr/wAtHrF8uvKr4x1X5I+PxGLdWd5PTohI46njjpY1q2sdcNWW5506pGq1Mq09Y61tP025vplS2j3dfZQq/eZm/hVa5pnM5lO1tXndUT5q7Dw34Z1jxDrFt4e8MWzalqk/9z7kf95mb+FV/vV0XgnwH4g8f6x/wjHgxfl4+2aj0ijT/e9P/Qq/T34W/CXwx8LdEXTdIg8y5kx9ru3/ANZO/wD8T/s14Gb5zDBLvPoux6mXZRPFeS6s4v4O/AHw98PYV1TUtmpa9L8z3DfciJ+8sQ/9mr6Jb5KWivy7GYypiKnPVd2ff4PB06EOSmrefcaq1KsdPValrklI7qVAZtNFP20+s7nYoDKfRRQWoDqKKKg1CiiigAooooAKKKbQAUyn1DJIkSb3pTmormkRGMmPr5k+Pf7Sfg/4LaV5M0i6l4hn/wCPbTon+f8A3pf+ea14D+0j+2jY+FTd+DvhfKmoa388NzfdYbb+H5P7zV+Tusa1qviHVLnW9eu5tQ1G7ffNcSnc7tV4LAVMY+0O51e5S+Lfsd38Uvi942+L+v8A9t+L9Q8xV/49rRPltrdP7sa/1+9XmFMqzDbzXMywwxtJLL+Nfd4DL4UvcpI4atW+siGu18D/AA78Z/EPVf7H8H6NPqlz/F5Q+SP/AGpJPuKP96vsH4Kfsb3niGz/AOEz+LVz/wAI74cgTz/s+/yp5Ix/FIzf6lKtfFr9p7w94a07/hWv7OdrFoGgwfuZ9Wto/LmuP+uH8W3/AKaN8/pXRGXPU9lTV2t+yPPliuZfulfz6HF+IPgv8N/gVYW1z8VNQfxX4mufmh0TTX8m1T/rvc/f/wC+dtfOHjLxVH4q1L7RZ6Np2hWcXyW9pp0Xlxon+0335G/2mroNU8QXPifwwsN/J9pvbL+N23Ptry+vuP7K+qQXW63ODAc87yq7pkVKtSKu+pWt3WtsPgKk/wB5FXR6MpIesm+opI6mhh3vV64s7m2/10TL/vV9RHLamJpc01exh7VRdr7mLtptWpFqvXzOMwXspcvU3jK4+NakmX7tPhjqTdv+SvYw+AX1fkm7N7Gcp6lTb5r0q/JJVhfkoaPe9KOWuymnd9Q9p9xXX79FxVrydr1DMvz1GKwE40HCas2EZ6lVVpWj+SpW/dPUzLvjryqWVqUJR6roaOpsZtFP20m018x7KR0DafRtp9bwg+pALWxpPy3kD/7VZC1bhWvpMopc01oc9ZXTj3P1z/Zzs7bxt4JvvCvjCOHVNJ/5Y29yN1eX/F79h1JfP1j4XT+W3/QNuX4/7Yzf/FVx/wAE9Q8T6DoMGvWdzt8v+Hrvr7b+Gfxs0fx5De2H/Htq+l/Jc2zds/dZf726vn+I8oxGFrOtS1i912Z+VZbm3sqs6VN2cXr2Z+HOveGdb8MalPpWvWM1le2zfvIZU2msLaa/e74ifC/4e/Fewa28Saekk+35LtPlnj/3ZK/KT44fs4+KvhJcyalD/wATTw5K/wC5v0X7n91Z1/h/9Br5yUadVba9Uz7/ACriOnXn7Oej/M9T/Zs/a91r4b3EHhLx/O+peF5Pkjn/ANZPZf7v96P/AGfyr9ldF1zSvEelWmt6JdxX1heoJYLiI7kdD3U1/MLX1n+zR+03rXwW1eLRNale/wDBt6/+kW33mtmP/LeD/wBmTvXw2ZZX9W/eUvh6rsfbU6vtfi3/ADP3hornfDviPR/FWj2mvaDexX2nXyK8E8Tbg4NdFXBCaklKLvcxcZKXLIKKKKskKKKKACiiigAooooAKKKKACiiigAptOoqxSiQ7TTam20zbRcwnAh2mlp22iqOdwIqZU1RstXEysR0ypaiZauJy1aYyiiiqOaURtc7rnh7SvENnJYaraJdwS/wuu6ujam7TWtKq4NTi7NHNXw8JpwmtD86fjB+y/eWPn694G33NquXey/jT/d/vV8Y3ENzp8zWepRNB/DtZfSv3eaPfXzn8Xv2f/D3xEtp9Ss4l0/XPLO2ZeEl/urIv/s1fo2V8WwxEFh8w+UuqPnauXzw/vUtUuh+TM0P+z8tUGjr0PxZ4J8T+ANVl0HxJaPbSxfcbqkif3lb+KuOaL+Ovo54eUNYu6ezWzOTnv8ABqYckdVJI63JI6pSR0RNaVcxWpu6tBo6hkj+SqjE7lVM/bWzYt9stm025+Zv+WP/AMTWZtpys6eXMnysvzV0QVpJ9UdtKryvyZg3UP2SZv8AZr66+APjyN0/sS8/4BXz7r2i3msW0GpaVbPc+Z99YQxZT/uiuV0HWL/w1qsd5DuXy/vpXt5hlX9o4Tnp6yR9LgMRBXjPZn64rHvRXSom315t8JfH1n4v0eNPMVpV/OvWZo/7i/LXxeCxnM3Sno1ujxMywE6FTa6ezKazf36hmtba5TZcxrPF/dapGV0Rtn3q4K48ZQ6Vf/2bqq/Zmb7jN9xv+BV61KhUnf2erRwxlDaRj+JPgr8PfEO6a50aGKdv44N0TN/3zU/g/wCF/g/wT8+jwXHm/wB6a4kkx/urnbXd2+oJcpvSre3fHR7Xn0nqd3v/AGXozxT4heH/ABbOjX/h7WbuNo/+XdZG2/8AAa+bbP4yfELw5f8A2PVb64/d/wB/tX3xJsf5HWvEviV8K7PxLbSXNgqxXX/oVfS5ZiMJVh9XxMVbo+xhCrOlPnjqjj9L+OHi2eFZo722uV/3K7Wz+NHiT5fOjhb/AHa+HNa0HW/Cd/JbTK8flt/wGnWPirUotuxt1eVm/Bk8P+8ou6PcpY+E0uqP0It/ixc3Kf6Vp6yL/dqCbxVol3/rrK5sf9q2l/8AZa+NNP8AiJqtn/Du/wBnFejaP8brODb9ssvMr5f97Q+JGygpfAz3SbxRNp0n2nw9qVzL/sTxNv8A++lpbf8Aac8ceHv3Oq+CdS1CD+/CN2f++apeG/j94Bfb9v0vy/wWvc9B+M3wl1HakOoJp7f9NomVf++q58RmWE5eSrSu+5r9VxHNzXujiLP9tbwNB/yMnhvW9L/3oFZR/wCPV6RpP7WHwE1VP+RpWy/2bu3mi/8AZK7e11Twfrif6Ne6dqUbf9NI2/8AHWptx8P/AABqv/H54Z0m73f3rSFv/Za+drwwsv4aaNLz+0iKH4+fAqf/AJn/AEP/AIFdKv8A6FVlfjh8EP8AooOgf+BsVY//AApv4S7/APkS9H/8BIv/AImrkfwr+F0H+p8IaL/4BW5/9krn+rQ7sz9v/dP/1PgL7lc9qV88/wC5T/VLRdaslzDstvl3feotYf8AlpX32DpbTl0PFjzR6EdrZ/J5z1oRt5VG2sm6uvn8lPu12c86nu9wju9CK6mkuZv/AEGtWxs1RP8Aaqtb2tbEa7K6qtTkp2iQ58/ulmNf7lZepah5X7lKsXVx9mh3/wAVcz890/8AvVyYfC+1nzS2OtStAsWsfnvvet2s6OPbVxa9/seXX99l1alqutTVzkhRuopm6spSM2Po3VVmuEiqq2of88Yq7MLl9ar8CD2TZekk8j56yprrf9yrFrY6lrFytvbQPcyt/Ai5r1Wx+H9n4ehXUvGeoQaf/wBMN+6T/vla+swWT08P7+Idm+hekfN9jzXSfD+pavNstoGevcdH8D+HvCVn/bfjC5+zf3EmZd5/3Y+rVz918TPs3/Et8B6b9m/6e5k8yd/91f4a9G+Hv7NPxO+J95/bfiCC5tLKf/l5v9yu/wD31Xt1cfy0+eo1CHd7sip/0869EclffETWNcm/4R/4e2M0EUnyb9v75/8AgK/dr334U/sw6leTL4k+IXy/x/Zv42r2aHTfgt+zxpv76e2vdci/21kl/wDrVh6T8ZPE/j/7TqVtGml+H7T/AF03+x/d3V85jOI6kqL+oRstnJ7v0MfY+1moVNPI7bxN4b0pNN8m5nt9E0G0Rvvuu/Yv3tqr/wCzV8e+MPjVc33/ABQfwX0/+zdO+59rRf39x/tL/d/3qw/iZ8QNb+LOvReFfCXnS6cr7Pk/5b/98/8ALJa+rvgn8BdN8E2cWsa9Gtzqkv8A3zFU5fgvqVD65mW72j1Z14uvToWo4ZXffscX8F/2d/sM0Xirx5/pd199Ld/m/wC+t33q+t9StUvLNrCH9xFt2/JxitKZkiT+7XO/2pbXM0ltZybmgxvZfmCf71fP47NK+Pqe2qdNl0SOOhS5Pj1b3Z51pfwr8MaVqv8AbdzAuoXq/MrzfNsP97a1d7NNNcuqbm/9lqaSTf8AIn/Aq5H4heMtN+HPhW71u/8A9eqful/vE/dWuLH42enNq3ojqy/AQq1NtEeOfHz4sQ+B9H/sfTZ92qXf93+Af3q/OS8me7eS/vG824l+9u61q+KvEmpeL9bu9b1KTc07syr/AHB/drmfnlev0PhrIfqtPnn8b1bO7FTTnyw2ResbG51i/js7aPc0jbVVa97+y2fhPR/7Hs/3l/P/AMfMy/8AoNU/Dehp4S0f+0rn/kKagv7le8Ubfx/8CqhI3nvvf+Ks8zxvtZ8kXovxPhs1zL2r9nDZFP79P21YVaXy6888P2gRrVlVojjrTtbXzf8AdWuec4nJOY+xs/P3PN8sUX3mr2H4a/C3xP8AFe//ALK0f/iV+H4Mfb79k+//ALK/3j/s/wDfVanwh+Et/wDFHVfk3W3hyydftNxt27z/AHY/7zV+oPh/w3o/hfS7bR9EtltLS2XaqL/6EzfxZr5fPc9WFj7On8f5HvZJlc8T78lZL8TI8D+A/Dfw+0GDQfDdottbxfebq8j/AMTSN/EzV2tFO2mvzCrVnOTnN3bP0GlSUUoQVkhtSqtKq1Iq1lKR0wpC0+inVjc7lAKKKKRqFFFFABRRRQAUUUUAFFFFABTadVeaTyk3vUznyJvsLlvIr3V1DaQyXE8ipFEpdmY4VQvXc1fkv+1P+15d63dXfw++GV75OnR74L/VIm/1/wDsQMv3V/2qtftjftQz6pcXXws8A3v+hR7odXvYf+Wj/wAUEbf3f7/5V+a/3a3yjKZ4t+1raR6LudFSr7LSO/5DqKTaa67wj4b/AOEj1u2sJp/slvJ9+Zv7i/e/3q/RcBgnVtRpr5Hk4jEQpQdSo9EVPDfhfW/FWqxaVolo9zPL/Cn+eK/Rn4X+Cfgh8BNNj8TfELWbTVvFGzzktIf33kP/AHY1/vf71fJvjDxlZ+Eof+EP+Hq/2fYbf9Lu/wDl5upP9qT+7/s14g1xNL9+Td+NfY/2DDl9ndrvY+cn7bGLmvaHRdz6h/aA/aW8W/Ft/wCxLP8A4knhSP7lnC/Nx/tTt/F/u/dr5OqaRt9Mp0Mvp0PcpLT8z2aMOWHKWLeZ4PuVEy03dsq4ux6+iwdFYmHs76oJae93Ke3ZWvY32z9zcx+fF/49/wABardjoOq6r8mm2M13/wBcUZv/AEGup8K/DnW/EOsRab9meD/nszrjZ/er0MFgK+Hqc9N6dTz8bmWHpQbqtJLfUwrXQ7zWLxbbRLaa7Zv7qbq9b/4Vv4t0rQftGq2nn/8ATH70iV9UeGfC+leEtKj03R4Nrfxzfxuf7zNW9Hp81y/z7q9f+2OSftIqy6rufhmb+KUpVOSjH3E93uz87NY0mHyWuYf3TL/A1cV5Nfr1D+zT8PfF9tBeTLOs/wDy2+znbnNej+B/gl8PdMubnR9B0vTbmK2/0e/3+XPMuf4JP7rflXw+fcZ4Gc+e2qP0XJuKalelH2dNtv8AA/Fuxh0+fTZ98vl3St8v+0tZ1vazS+a6L/qq+3PEXwF8E+Ef2m4PhT4gtrj/AIR3xvbeZot3DK0UllNPv2f7Mm2WMptP8LCvcvGn7Ndt4K0GDw98PfC8+szt81xqVzIrSP8A8Brny/jjBYicadrNdXsfS5pjJ4Sn7Tlbv07H5UtX078DfgreeOPN1W+tpPsv8HFe0/DX9jPVdR1v+2PH3+jWCvv+xxf6yT/ZZv4Vr9HvDfgXStDsILDSrZLaCBQqoi4+UfKtY5vxjSwk37F3fR9EeFm+Pr46l9XwV03u+x+XGtfDX4dWKXOlX/8Ao11/f/jSvlPxp4X/AOEY1X7H9pS9t2+aGaP0/wBr3r98rj4R+B7y8k1K80S0nupPvu8atuqeb4d+C0Tb/wAI/p3y/d/0WJv/AGWvOn4lU5fYbb3ucuQ5VmeAvPET5k90z+dVl30irX6b/tBfsh213/xU/wAK7L7NP/y86WnEb5/5aQ7vulf7teG2f7JviSzto7zWNQtvN/itk3b1/wBndX1eV57gsXapezejPbxfE2Dw8OatKz7dT44+z+1NaGvpnxV+zn4/0y2/tLTdLmvYF/13kruK/wDxVcFovwf+IupvPeQ+F9Rlgsfnm/cNH/wH5vvV6tehgJfA1a+52YPPsPXp+1hNWPIWj2VX2mt++t5ormeG5i8iVWO9GXbsP93bWPItedm+VcvvxWh7FCrzfMgrXsY0uX8ndtrNWnwtsf5K58ol9XqLs+hdWPMvd0Z714F+Jz+ErO502/Vp4v8Alj3qP4f/ABcv/CvxOj8c3nzQXb+Tfwr/ABwSfe/75rxXdvpyx76+sxuChiKbhbc+fpZJhYznUtrLRs/dzT7yz1OzttW0q5W5tbtEmhlRvldG+ZWrxn43fGjwf4AsIPDfifTf7f8A7ZhffafL8lv93dJu/wDQa8m/Zl1rXvD3hj+x/E8vlWd3Mv8AZvnf8s1/iX/ZVqX9qzS/Aes+G49Vm1m0/wCEgsf9SkL7pJP9natfk/8AY/s8WqVRXXRrqfm+EnS+v+xvdJ2uj4i8eeAba2tpfGfgnde+FJ5v+B2jt/yxm/8AZWrx7bur03wX441XwZeT+T/pOnagn2e8s5uYbiE/wstUvFnh2ztv+J94c/f6He/6n+/A/wDzwm/2l/8AHq6MzyPecF6o/X8JiJ0rU6jv2fc9y/Zj/aW1j4Ma0mia3LLd+Db5/wDSIerW7n/lvF/7Mv8AFX7ieH9e0rxLpFnreiXcd7YXsSy280R3I6N0NfzF7TX2j+yh+05efCjV4/Bni2fz/BuoSfX7BI3/AC2X/pn/AH1/GvxrOMong5+1o/D1R9PSq+1jyvdfifuDRVC1ure8to7y1kWeCdQ8bocqyNyrCr9cEGpRUomAUUUVYBRRRQAUUUUAFFFFABRRRQAUUUUAFFFFADaZUtRVcTOcRlNp1NqjmlEj2mo6sVDVxOWcSJqZU1MrRHFOIyiiimZjaZT6KszlE4Dxx8PfDHj/AEuTSvElkl3F82xuksbf3lbqtfl98VPgb4k+F15Lef8AIS0Fv9TPs+5/syL/AA1+v7Vk6lpNhrFtLYalbJcwTrtdHXcCD/s19JknENTB+5PWD3R5OLy+UnzUtH+Z+FM0aSJvT+L+H+7VBrfZ9+vs/wCN37ONz4Vmk8SeCVaTTv8Altbfe8r/AOtXyQ0KO8nnbo5V+8jfKymv02Eqdemq2Hd4v70z59e9Nw2fVHNSQ1WaGt6SP+CqskdaRNI17e6Y/k0zya0WjqLy60jE2jXO7+FPia/0HXlh+75n3G/uuK+q/FHwz8E/FnSv7SmtP7L1n/n7tto3t/00X+Kvh6zke0vLa8T/AJYOGr7z+GuofbtK/wCA7/8AvqvIxFarhMXGrSdk+x9XhZwxGFfRrZnyVceA/id8HdY/tjSo/wC0LJX+Z7b94j7f70fVa+tfh78bPD3jazjs79m0/VP40ddu6u5um37oX+ZdtfO3xI0fTbT/AImVnGttP/EyBQf++q+jr5fDNGtLVOjXU87+250rQrq6PqGT/Y2tXJ+LPDth4h01rO5i/wBx+4/4FXg/gP4vfZvL03WNzRcJvavoWG8ttSh86wl8yJq8qHtcJV5KmjXUeLwlOrDnpu6PlC41jxV8OdS+zfaftdrv+6/93/er3nwz4+sNZRfm8uX+7WJ8RPC8OuabJ+7/ANKi+ZWr5FtdQ1jw9qvk7m8hW27Wr7z+xaeZUPrFHSa3Xc5MvzDlvQqfI/RPzkl+ekk/2K+W9B+L02lIv9pf6Ta/+gV7fofjLQfEcKzWd2u5v4GOGr46rQqUP4sbHr8vN8DujJ8ZeCdN8T2cnnRbZ9rbHr4k8VfD/XtB1VvJ0+aX+75K7t3/AHzX6HyNvqJrO2n/ANdXv5Xn/soOnJXT6djl+ruM+eG738z4H0H4a/F3xV/yL3g7UZ938bhYU/76l2CovEHwh+LvhpPO17wTqMEX9+GPz0/76h31+lGh3z6VNs89ttexafqj3Kf6z73vXxWPzKrSq81k4voevS96O2p+H8epWds/k39s8Eq+2MVr2uuWCf6mfb/47X7Q6t4P8K+Ik/4qHRLDUlb/AJ+II5T/AN9NXkutfsr/AAQ1z5/7A/s1v71hPNCv/fP3a4Kub4Kr/Eg16bHTQr1aW2iPzWtdcufvwzt/wE11mm/ELxJpjr9n1K4j/wC2rV9Yap+wz4Gufn0HxNqWm/7/AJc6/wDslcDqH7DPi2D59E8cWlz/ALN3byR/+gtJWEK+X97BPH1H8Tscnp/x48ZW23/iZTSf7x3V1Fv+0h4qT/XSq3/Aa4y+/ZF+OWn/AD2cml6ov/TG68o/+RUWudm/Zv8A2hLX/mVPM/3Ly2b/ANnrp9lgpfaRz/WJdz//1fznt7FIvuVf27KnrP1C48pNkf3mr7zn52eT7Dl96TuU766/5Y1DZ2/8b1HZx+a/7z7tbW016kIcphOVvdCKrkfyxs/92q8ce96zNWvP+XaH/tpWFf35qEd2aYelvIzry4+2XPmfw/w1oW8Plx1Qs4f462Fr3IU/ZR5exliqn2R61LSLS1nKVzlCmSVHNJ5VUpLr+581dlDCzk1yocYXLckzpD92o4bfUrx/Jtonl/2UFR295eJMv2f5pf7u3P8A47X0B4P8F/tA+KPK/wCES8M6jHFJ/wAt0tfsyf8Af2bbX0uHpYWhT56rV/Mqcai2Sfqeb6X8MfE98n2m8g/s21/573h8pP8Ax6tr+zfhv4Z/5CWpP4muv+eFh+7h/wC/3/7Ve2ah+zj4ntP9M+M3xI0TwzH/AM8bu9+13X/fpaprq37Kvw5/5Btlq3xN1SL+O5/0Kw/+L/8AHayrcW4SPuU3d9khxw9WXxHnOm694/8AFX/Ek+GPhv8As2CX5NmlwM03/bS5b5v/AEGvU9L/AGT9bsYf7e+MHivTvBdrJ8/+lz+bdPXO+IP2rviLc2f9leBrbTfAul/88dJg/ef9/pOf++dtfPmsa1quvXMmpeIdQudSupf+W1xI0j/99NXhf2vmGJn/ALLDlv1e500qFOPxu3ofaVr8Wv2bfgzD5Pw68Nz+NNei/wCYjqP7uPf/AJ/2a8g8fftVfGbx/wD6N/aX/CO6d/z6ab+6/wC+pPvtXzxZ2dzfXPk2cHmSy/3RmvqDwb8F7PRbOLxV8Qp/Li/5Y2Cf6yT/AHq+jwXClCn/ALRmM3OfYzxGPp0f4en5nL/Dv4X/APCReb4t8bXzwaRB8801w3zy/wDAmrt9c1jxD8RpoPAfgPT/AOz/AAvF8n7n/lp/vV1ljovi34l6rFZ/2f8A2focH+oh2/JHH/7Ma+wfCfgvw38PtH+6kXlffmb7zf3mr0syx9DCWna8ukV+p8pDF1a9R8n3nEfCH4N6b4Cs/tM0Sy38n3m/u163rnijSvDkOy5l82dvuQJ80r/7q1wGqePrzV5vsHhtfKi/5+W/9lqfQdFs7a5+2P8A6Xet96Z/mb/gP92vi8b7fE1HiMU9X0PRoctL3Iu76sjjh8T+Ln87VWbRtO/54If38i/7Tfw1r3DWejWa6bYRLGq/m3+01auoXiW0LPurktNhm8Q3/wD0yX5nf0FRD4PaT0iuh0cl3ybtmzp8kMFtPrGpSeXa22fvfxP/AHf+A1+a/wAdPipc/EnxPJDZyf8AEo0928n0dv79e9/tNfFhLG2/4V14Yk27v9e6H/P3q+FpIfI+SvU4ayj6xVeMqr0R7D/cQUE9XuU5a9T+HfheG5eTxDqv/HhZf+Pv/CtcV4f0G58Q6lFbW38X3m/uj+Jm/wB2vc9WuLa2s7bw9pXy2dp97/bf+Jmr7DNcbyQVOO738j5fN8f7KHInqzKvr6bVbyS8m/5af+Or/dqr5dCrVlVr5yMD4icxu2nbam21YtbWa7mW2hXczVi+pjzkum6fNqF4ttCu773+7x/Ezfw7a9g+Hfw5vPiTr0eg6J/yCLbZ9vvNv/fWz/2T86yPB/g/VfGesR+BvCX7xp/+Qpef3I/4lX/Y/wDQq/Uv4c/D/R/h94ettE0qNflX98/8Uj/xM1fMZ3m0MJDTWb2XY93KsqnipLoluzZ8K+GdH8HaPaaDolsttZ2i7VVf/HmZv4maulopy1+UTqOTc5O7Z+jUKSilCC0QqrUu2hVp+2sJSO6EBNpqSnUUjpjCwUUUVBoFFFFABRRRQAUUUUAFFFFABRRRQBGzbK+Bf2xv2i/+FfaJ/wAIP4Su/wDio9WT52Q/PaQn/lp/vN/B+dfRPx2+LmkfCDwJe+I75t92V8mztv45Z2+6q/8As1fgF4n8Tav4x17UPFXiC5a51HUpmmmb6/8AxNPLcE8bV5fsLc6Ob2UObr0Ofbf8zu3zNTaFr67/AGXf2fbn4o68viHxDBt8L6XN8/8A09TL/wAsl/2f79fosaUIrskeLi8ZClB1Jf8ADnMfDH9nHx/440G58bW2ifbdL0/96lpv8qe/2/ejt/8AP+7zXAXnix9T8bSarc6amkeX/oyWcKeUlokX7tY9v+z/ABbq/oF0exs9KtoLCxgjgtbZAiIgwqIq7VWvw1/ai8SeFfFnxu8Sax4Mg22fmLbT3CfcurqFfLmnTb/Cx/76+9Xdw/nM/rSUI+6jxsLP61CXtN3+R4fqVx9pv55v+ejtVGofnpPMevupZgpTbaaR6cKXKkok6x73rbt9JeeHzvl/rXe/DL4MeP8A4trf/wDCD21teyaZ5fnwzXUUEn737u1ZP4avW/hnVdD8c/8ACGeJtNm0+/tH8me2m+/v/wBlv4lb+Fq9zIcbl9WrKlNpvezODMMQ6VNzXTVnAXXhu8i0/wC3+V+6i+97VueD9B03U9015P8Ad/gr7d8M+D9E1D/im0tPP89D50O3cWT+Jv8AgNek/Df9jOz0jVbvVdb1Dz7CWbfbWiJ/yz/uyM1XnPEWAwdb2k9PJdT4TLeKKmZUqlOnFprZ90eH/A24+za9/Y9rp+6yucwf6vdsz/F+Fevw+Ff7K1i7sIY/Mvdx7ffr7Z8P/D/w34ah8nRNPt7Rf4tiYJ/3mrb/ALBsHm857ZN397Zz/wB9V+Z4nxAU6sp046M+azXgLEYybnKVr7+Z8paT8Ode1FFf7N5e7+9XsPh34Rpb7ZtSl+7/AAJXtlvapF9xa0Iq+SzLjDFV7qLsvI+kyHwqwFCSnVXM132Pkbwd8aZrb4+at8CNa8KxaVPbpLcafqME5ZLq1VfNh3RMvBZP7rffU1xvgmYfDD9srxj4NbeNN+J2mxa3Z/8AX1DvaT/24/QU39pVR4E+OnwT+LkEX/MRk0C+f/pjc/LH/wB8rNNXo37Qvw28X+IdZ+H3xE+HcCTeJPBWrplPlXzbG62rN949F/u/3WavjpVeY/XcPhadKPJTVkuxxH7ZOhHSrfwH8brH/j5+H+u2stz/ANec80ef++ZUX/vo19sxNDcQq6bZIpBlWX7pDV5l8bPB/wDwnnwk8ZeE0XdLqGl3H2f/AK7xjzYf/IqLXLfsweKZPF3wK8E6pNN59zBp62M7Hr5lm32dt3+18lQbHuK2MO7fVxV2VJRTlNy3ZjSw8IX5Fa4VXmj81asUVRrOClHlfU5q6sd9eHeKPA+paj4ktvsa/wChXP8Arm/hTH/xVfSTLvqH7LHXq4DNqmHleO58Jn3BFHHpRnsnc4/SfD8NjbR2yL/qlraXTU/u1trHtqWuOrjZybcnue1g+HaFKCglY+Gv2lv2W7D4iaVJ4n8GWiWniu03PtT92l4g/gf/AKaf3Wr8eLqxubO8nsLyB7a6tnKTQuu10dfvKyt021/TZX53/to/Cf4enw/D47trT7J40vNRt7CwitE/5ClzcNxDNH/Fx828c9q+84X44nhf9nxWsendHZ/Z/sv4e3Y/K3R9B1LXNSi02wgaSeX/AGfuf7Tf7Ndvqnwn17T5vJtv9L/3a/TLwL+y/Z+AvCtsl5P5/iW5TfqN395fPb/lmv8A0yj+7/tda5rUPhX4ntr9baG0+0/afvzZ+Wv1HKuJcvxF27Ltc/KuIeLcdhMS6dKn7i692fmnN4N1u2h3zQf1r2f4a/D+w05P+Em8Wr5cUH+ohf8Ajr9BZvhb4P8ACuj/ANq+If3k8Xzfj/dWvmjxFo9/4hmnvPKaC1/5Ypt+VRXs4DiChjLwpaJbs+ezPjLFV6f1eouRPdrex8+ePviZresXn2DSv3EEH+r2e1eIalfX9zNvvJHaX/ar23XLGw0a5kT5WZa8X1y4hubxpofu17eIw/7v3NLH33DMaCpqNCFkuvVmC1dV4V8Qf2Rc/Zr+L7Xpl38lzB6p/eX/AGlrkmqeFd9fKQhKdblvqfYVqSnBxaujpfG3hF/DN5HNayfa9J1D97ZXP9+M/wB7/bX+KuCZa968LzQ6/wCH7nwrqv8Aqvv2zt/yzf8A2a8Z1TT7nSryezuF2yxtXzPFHDXsvft7r/AxyrMXJyoyfvL8Ufpp+w9+0V5gg+DvjC6zKv8AyBJ5W6/9On/xv8q/UhW31/L1Z6jeaPf22q6bO1teWkolhlT5WR4/usv0r98P2afjfZ/GjwDBqM0qR+INOxbapAv/AD2/hlUf3ZK/Asfhfqdbk6M+s/iw5+q3Ppmiiimc4UUUUAFFFFABRRRQAUUUUAFFFFABRRRQAU2nUUARUyrFM2mrjIylEipjLU22jbTuYukU2qOrbLULLW0ZHDVpEVMqambaq5yuAyjbT6fRcXIQ0U+mUyLFO4hSdGR1VlZfm3V8W/HD9m+HVobnxJ4Mj8u/+89sv8f/AFz/APia+3qrtXtZRnFfBVOek9HuujPKzDLadZX2a2Z+E95p95Y3kthqUH2aeD78Pzf99Luqo0NfqF8bvgXpXjawn1jSo0tNZg+ZZlXG/b/C1fm1eaPqWkXM9hrEDQXUDlGVvav2HLcfQx9P2tLR9V2Pia3PSm1PRr8Tmfs9QSW9dBNDVNo69SNAIYgw5Levr34Izb9KVP7tfKskdfUfwJhf7BJ/vGvGzql+7UvM+nySu+Zroz3iSH99Xz/8aJEg0pnr6Gm++1fNPx0k/wBA8n+9mvpOFo82NgjizLdebR80aHdJd2c9q7fMr11uk/EjW/Bl/wDxNa/xLXnnhOP/AEz/AHq7DWrW2fzfOX+GvTx+EpYjFzpyV0erVxX1a3Lsz648M/Ebw94xs43hnWOeT7yV5Z8UvAP2v/icaev3fvV82afNc6K/2ywkaL/dr3bwr8Wv3P2PXv38X3a8bAVMRlOI54O8P0LxFCniffWjWzPBmuptKufs11/qm/vU/wAu5tn+36Xcuq/7Ne5+NPBela9YNrHh6RZ/N/gX7wr5xkbWNBuWhud21a+7r1aWKp+1pa33Rjh3P4NmvxPYfDvxq8T6DMsOqr/aFr/tcH/vqvoXwv8AFTwl4n2ol8tldf8APG4+Xn/ZbvXxJDqFtd/w7aZJpvlfPCzLu/i3V8fiMnp7w0Z3QxT2mtj9Llb/AIErflWDqkPi2zf7f4b1B/3f/LuxylfDXh3x5428OTL9m1BpLdf+WM3zI1e8eH/j4ieVDr1i0H+3b8j/AL5rwKtGpQdpq6OnlhL4XqfQ3hv42arY3P2DxVp+3/p4h/8Aia+jdD8TaP4hhWbSrtJ/9leo/wB5a+RLXxl4A8WJ/wAf0Mcv+38pqWTSb/TP9P8ADGoeXt/uN/8AE14mNyrC4n3qfuvt0N6WKqQ/iao+2aduNfKuh/GjXtK223iS0+1r/fX5Xr3Hw/8AELwx4j2w2tz5E7fdhm+U/wD2VfM4zJ8RQ96UdO6N414T2Z3iyVJ57+lQbd/3Pu0NHXj8sQ5D/9b897i4SBN9YKrNczM7/wAX3qg+0fbn+7+9roIbeOJNlfomHocp4uIny+oRwoifdq5HGmymKtTr8iVpVq+ZywiV7iaOzhab+L7q1x/7yeb/AHq1NUuvNfYn3VqC1t/469DLcLvUlud8p8sC9HH5SfJUtM3U1W+evTlE8zcsbqN1R7o6duWot5BI6HQ7XwfLc/8AFYXOqRwf9Q6KGRv/ACI1e16X4o/ZR8ObZv8AhCfEPiu6/wColeR2sP8A3zDXzmrf7VVmWH+7Wtf2lWHs7tLy6mtL5n1fJ+1VbaB/yS74a+GvCX9y4+z/AG25/wC+m2V5H4u/aA+MfjN/+Jx4y1L7LJ/ywtpPssP/AH7t9leS7o0p/wBoSuP+xqf21f1Z18/kM3PO7TTMzN/eZmZv++qF+/UbSb/9mr+n6Xf6hN5NnA8jf7C19TlmROrPlpoxq1N5zdiszJ/Atdl4X8E634ouY4baJvK/v17J8P8A4A6xrU0d5r2zTbL/AKbN87f8B6192+DfhjYeHrBbfRNP8uL+K5ueP++Vr38fmGW5ND35c0+y2R5Tr1sR7mGXzZ4X4B+FOm+DbOO8miSW/wD+er9q9g0/wjDrNys15F9t/u71xGn+7SeLviV8Gfhz5v8Awk+uw6pqMf8Ay52m25n/APHflWvkn4hftWeKvF+7RPAOm/8ACN6dJ8m//WXT/wDxNfFf6wYvMqvLh479eyOihkUKUHOu7vqfXXjb4seBvhNZ/YJrlLnVP4La327/APgW37teO6T4u8T/ABLuf7V1uT7Npyt8kKfcx/DXzZ4L+Ht5qtz/AMJD4qkfb9//AEh/3j/726vrHw75P2NUsF22sX3Nv8VfZUsip4Slzz96fV9jx8bjLzVOlojo1vPs3lW1mqx7vlr1TR7f7HYedM3+9XAeGdJ+13n2yb7q1t+ItaeV10fTfvfd+XtXhY/95NUofNmuHp8sedlW+vrnXr/7HYbvvbai+JHjDTfhX4Ju3+X7VKn/AAKRz92uz0OxttB02W8ufvKhZ3r80/jt8QJvHvjCezhk/wCJdprlF9N/8VeNSpfX8UsND4Fv5nv4Wl7KHtJ79Dyi81K81rULvXtSl8y4u3L1kfvp5tn96rE0nyf7td/8PdBhnmbxDfr/AKLp/wA3+/L/AArX6j7mGpemiPPxWM5IOrM7bQ9LXwroPzr/AMTHUE+f/pnH/CtVKlvrya+uWmm+bdSKtfJ/FNynuz86xWIlVm5z6iqtWFWhVq4sNYzPNnUI44fPdUT+Kuv03Q9YvtStvCvhmD7TrmpfI3+wG/2v4f8Aaqpbt/Y9st5DF59/ct5Non3vnP8AFtr9D/2efg//AMIPo/8AwkOvR7vEOqLum39YIz83l/7396vCzbNIYSn7SW/Rd2enleCniZpLqehfCH4V6P8AC7w3Bptttnv51D3l33kl2/N/wFf4a9door8arV51qjnJ3bP1LD0IUoKEFoFSRrSqtWFrnmz0aFAFp9FFZHfGPKFFFFAwooooAKKKKACiiigAooooAKKKKAG1malqNtpdnNf3kixW8CF3dj8qqOc1oM2yvzA/bf8Aj7NaQf8ACqfCtz+/vU/4mUqfwwt/yz/7af8AoNYTlOU1SprVm1JLWUtkfHX7THxmufjJ8Qrm8s52/wCEe0vMGnJn5CB96Xb6yV86t89LV6zs7m8mW2t42kll/hUZr9OyjJ/YwVGGvd9zgxFbectifR9LudX1Kx0qzXdPezJAn+/I21a/oL+G/gvSvh94M0nwrpUaxxafAiM39+Tb+8ZvdjX5N/s7/CnVZfiXpN/rcHkf2a/2nyG/1m+P/V/L/vV+yMbbI1ro4jwk8Py09r6tH57nGc069Xkpyul27ng37RXijxNpHgaTQfBkT/2v4izZfaVVv9Etiv72ZmX7rY+Vf96vy0vPgXr0Ftvtrm3nl/ufMP1r9qtct4b6wntpl3Ky18OeOrWPQ79tn3d3yrX03AXsrSp8vvdz4bNuKcdg5xjh7W80fnTrHhPW9BfZqVo8f+1/D/31WB5NfoDfWthrlg1tqUSSxNXjC/D2zttQbyYlaJm+Wv1XD4KnL40e1lXiFCrTf1iNmu2zOa+Eusa98NPEGl+PvCtz/p9i+y/07/n6s5P9ZH+X/j3Ir9WPi18HdB+Ndh4e8VaJqC6Xr2lvFc2GpJF5nmW0nztBJ/eXH3f7rV8NeC/hff6nqttDbR/xj/gNfqD4T0tND0HT9EhZ2itIQi7zubA/2q/GuPcJSwmKjVw8rT62PQyvij67VlS3Xc8s8b/AqHVPDlpdeAZv7D8Y+HZftmk6h/02Vfmgn/vRTD5Xrpvg38XbT4jWmoaJrVl/YHjXw2/2bXdFm4eKRePOi/56QSfwN/8AWz7Xa/IleF/Fr4Pt4svrHxv4Ivv+Eb+IWgA/2fqijKTp/wA+l4v/AC0gk/8AHf0P5LisVUqz5pyufo2V4OlSpKFNJHv3lpTPLrw34PfGOL4jRXeg+ILE+HPHGgnytZ0SfiSNx/y3h/56QSdm/wDrFvY7rUIYPvttrKEG/dibYurRprnnojQ2mm+YkX365G+8YaPp6b7y+hj/AN51rCtfFln4jtpJtNZvKXK78beld0MtqtXa0Pm8XxXhKXu05JvojhP2n/A03xH+CviHTtIXzdX0sLq+n7Buf7TZHzNq/wC00e5P+BV614C1y88T+CfDviTU7ZrS61bS7S9mgcbTHJPCsjL+BrE+HmpfabO7tn+X7JdzwfN7NuVvxzXqNceKoeyk4dj3snzRYzDqrHS41vu18hfs73kPhXx18V/g6YHhfRfEEuuWfy/J9h1ZUljX/gJr6/r498c2/wDwrj9p3wZ8RzNHDo/j6wl8KXxl+UR3Uf8ApNqRx/y1ZFj/AOA1znqH2FRRRQAUUUUAFFFQtJVkuaXxE1FVhODU6tuFKUSYVYy+FimvjPwYF+PPxsvfiVcfvvBPw2ll0vw7/wA87rU/+Xq9/wBpY/up/wABPrXdftGeLNbsPDmnfD/wU4Xxh8Qrs6Np3rBC65vLv/dgi6t2zXr3gLwfongDwjo/g7QYBBYaNbLbxer/AN6Rv9qRvnb3apNDq5reGX761Qk0uH+6tbNFaQquPws4sRgKVX3prU4nUvC+m6l/x+WiT7fu7xmsG88M6U9s1m9knlN8u3Yu2vTpPkSuX1LVNNg+SadIv95lFerg8XV0jFvQ+Nz3I8FCDnKyb7n5N/tNfAfVfDVzL4t8PK9zpM7fvoV3ExV8PMtf0Qahb2Gq2cltcqlzBOvzK3KsDX5GftGfCWw8AeJ/tmlR7dO1De+z+5/s1+68H8SzxX+y191s+54uSZtChNYae3RnyMy12HgWzSfxJY/aV3Qb/mrEks3T59vy10ml2viG5sJE0e0bylb55E+9/wB9V99SyHlmqknoj63H1uag4xdr6XfQ+kNe0fRNKs2ubOBI2/2a+e/F1qmqp9vtv9bB/wCPLXri6freoeG4Ptjf6Vs+bd96vA9S87Sb+SHzPmWvWxmCpVMPKFV3R8LwtQcakvfvJP70cSy17n+zr8XLn4M/EfT9e3f8Se+22mpRetvI33v96P71eL3UnmvVGRd9fzRxNkkJ80IO9tmfr+Fr8rUrep/UFY3ltqNtBeWcizwXCJMjryHRuVYVo18C/sJ/F/8A4TPwBJ4B1ifdrPhDCQ/3pbCT/V/9+z8n/fNffVfmML7S3R1Tjr7uzCiiirICiiigAooooAKKKKACiiigAooooAKKKKACiiigApu2nUUANqCRas1C1VGRhOmVdtFStUFbRPPnTGUU+mVZjKI+mUU+qM5RIaiap9pqPbVI5ZwKMy702V+bP7Smhw6d4zjuYV2/a4d//fLba/S1lr4I/aptf+Jrpd1/sSL/AOPbq+74ErcuNUOjR8VxRStCM+p8ayR1SkjStny6rNDX7PGgfJ0qpjSR19TfA2P/AIk87/7VfM0kdfVXwTj2aDJ/vV4mfQ/dr1Pr+Hqvvv0PV5vv18r/AByuN/7n619TyN88j18cfGy63Xkmz+Ff/Zq93gylzY1eSHj9ZxXmeLeE4X+2LWr4smeLdVXwb+9mjd/4Xo8cTfPJXo4SV8ZUlI9DF/xYQ7mDY3iNbbJlouI0/wCWNc/btstqsLdPXLX6o6ZQkn7p1Gl+KNS0WZXtp/u/w/w102pa1oniqH/T41tL3+8v3HrySa43yeZUf2j/AGq5o3pNcjOiWH57S6lm80l7OZnRty/w1Ja3kyfI/wA1JHqEzw+Tu+WoN22t6uMjV8mae+1yy3L7XG6pIW3p/tVSVUerMa7P92vMq1LmXsrGhHv/AIK7PR/GHiDRpFez1CaPb/tZX/vlq42Ft33G2/71WFb+/KtebVpeQ7+Z7lZ/GbUpY/J1vTYLv/bT929WZvH2j3P+pke0/Bl/8eWvChsoZk/vVUZ29CT6y8N/GTXtFSNLDWW8pf4JHWVP++Wr1/Tf2oHih/4nGjJPL/ftpPL/APHW3V+dyyQ/89FWrS30yfcvdtediMqwtf446msMVOJ//9f89o7G2ifekW1qs7TU1MWv0PnkfP7+Y5aoapceRDWkp2J/u1xuoXX265+T7q/KtY4Xmq1OXp1O6EOVeZW273rTW4TZs/u1vaLfW2kOv2zRLDVv9m787/0KKRK9Bj8cfD3/AJfPhlZ/9u97cL/6EzV93S9nyKEWefXq83S9jyBpkqNpoa9bbxJ8JZ/9d4Hubb/rjfSf+zNUDap8H3/5l2/g/wC27N/7NXZDBwl9tGHt7fZbPIvOqTzq9VW6+Ff/AD6TRf77TH/0Fq0lvvhXF9xbf/v3cSf+hV1/VKUfikiPr3/TtnjHnv6VchjvLx9ltA87f3URm/8AQa9jXxV8Pbb/AI94P++bTFWZPiV4bgT/AEO0u5/+ALEP51UnhI/FK/oZfW68tqTXqeXQ+CfFV3+++wvGv96bbF/6FXTab8K9Vu5lS6uUj/64/vXrYb4pf8+GiQ/9vMrN/wCOrWfJ8UvGezZb3cOmq3/PnEsX/j3365quaYKl8CbZj/t8+qivvZ7RovwF0Gxtor/xBJcQL/fu3WCP/wAe212C+NPgh8PofJs5f7Sni/5Y6cm7/wAidK+LtQ1PUtVm87Vb65vW/vTyNJ/6FVJmT+CvGrZtjavuQlyrsjpjg4b1byf4H11rH7Wmq2ybPAfhm002X/n5v28+b/vnpXgfjD4yfFTxsnk+JvFF3Ja/8+0B8iH/AL5j2ivP44bm5fZbKzM1dPY+Dbm5/eXkm3/ZrmwmUUuf2lTX1PQ+tcnkcxpOl/brnya+l/COg+FdAto7y4j8yf73z1x2m6HbaZt+zxqta2qTeRbb5q+yw+K2o4fS/Y8bF1XVfO9l07m3qHiK/wDE+qxabYfurVcbVXivqXwjosyWcVm/92vmv4U6C+p6l9s2/uo/4q+tf7QTTLbZD97+Fa+izn91Tjh6e/U8XCw5qjnLRG1q2qQ6HZx6bYfvJ2+X5aueG9H8j/TLn5p5Pmb/AGaxdF0d55vt9580rfd/2K9AaaHT7aW5mbbFErN+VfneZYhUIPld3182fS4WlKrNJHhf7QnxC/4RDwlLptg22/1D5FX61+bC/uE3u25pfmavSfjB44m8a+MLubdutbR2hh+itXlkzbnr6zg/J50KHNU3lqz0MbPmkqa2RfsbebV7yCwt1+aV9q/8Cr3m8WHSNNg0Gz+7B99v77/xNXNfD3RfsNhP4nufdIN3r/erS3Pcvvf+Kt82rc0+SOyPg8+xnNP2cdkNhjrRWGmww1oLHXknx9eqRxw1q2tv/G/3VqOOH59lelfD3wPefEHxPaeHrb91Bw97Mq/6uFfvN9WrGvXjCDnN2S1Zx805zUIbs9o/Zz+Ff/CT63/wsLXoP9A09v8AiWwv/HIv/LT6L/6FX6CR/J8lY2h6PYaBptppWmwLbWtoiwwov8KrW5X4nnWaTxld1Nl0XZH7Bk+AWGpKPXqOp61FVha8aR7tKJItTU2nVkenCIUUUVBoFFFFABRRRQAUUUUAFFFFABRRRQAUUU1m2ipk7LmA8v8Aiv490v4b+B9W8Vaq22DT4S3u7/dVF/2mr+d3xN4j1Lxbr2peJtYk8y/1Sd53/wCBN0H0r7v/AG9Pi5/b3ia0+GOj3P8AoWkbZtS2t1uD/q42/wB1fm/4FX56r87173CWVznJ4me70XkaYqfKlT+8fDH5j/71fUHgXw/beANH/wCEw1iL/T5f9RG4+5/tVzn7Pfguz8VeOYJtV2LYaf8A6Q+//wAdr688afC28+Ietx6bon7vS4m/1235Ni/7VfuOQ+xw/wDF00vdn4zxnxLTjiI5e3ZPdrex2X7LemzeIf7Q8c3/APrZ32JX2z9yuD+H/g+w8D+GLHQbBf3VsnzN03n+Jq7eaTbCz1+a59mH1vFup02XoeFhYwinNKy3t5GdfTIiNvZV/wB418jfFy3sPEvl2Hh6X7Teq3zurfIv/Aq8o+I3xO8War4h1C2ed49OgmdUiX7mytTwTr0Oq39ppVn/AK+f5enrX6Tk3CtXAU1jJy1tey6HyGfYuvKCqUVddD0Dwb8DXvraP+0tQdf9mFa9htfgH4Vi2/6+T/eK/wCFeseG9Ds9Ds4PtM/ovzlV+ZvlVfm7tXosdnHX5/m/GeLlWfJNpeR9jknBn1mkqlbVvc818O+B9K8PJs0+Db/tN1rvre12Vp+Tsp6rXxmKzGpXbnN3bPvst4epYVKEVZIkj+Si4m8iFn/uqW/Km1FNslhaF/mVl2t/wKvP5feR9RKdqbitz4B8c6Tr3xN8TR+PPB88Hhvx3oHz6Jcw/J9qhX/l0u/+eqyf+O7v7lcBr3x48YeOv9dBJoWuaJ/o2raO/wAvlXP/AD2VW+Zo2/4Ft/Vvur/hVvg+C5ivLbT1jlgfem12+R/7y8/LXzZ+0x+z/rHiKaP4qfDVf+Kw02HZe2i/8xK2C7f+/qj/AL7HHVRX2+X5hg6GKjUhHTqmfnFLLcdi8LPDY+V9bpngMPxMmimg/tvddxMy+e8P3/8Aa+X+Kvvv4d/8Ixqug21/4YvUvbJv4oTn5/4ldf4Wr8l7PVLPVbaT79tLB8lzBcLtmgl/iVlavu79lH4f3iW0vj+6vrm2iu99tbWkL7YJYV/5bSL/ABHP3a+w4u9lLCKvTlZdF3PmMk4eo0sVyuFn1PsjT9LtdPed7Zdvnv5z/wC0zLt/pXTwt8lVljrk/GHjbQfAlgupa9K8cUjhF2RtI7E/7KivxyfNVfds/Y8JGGEhzbI76uO8V+CfC3jm0t9P8WaVBq1raXEd3FFOuVWeP7rCuktZvPhWZPusu6rtcco2PepT5kn3Gqu0U6iikaBRTd1V2uEp8smROrCPxOwXEnlJXKX2teR/tVq303yNXk/iTVrbTLO5v7yVYILZHd2b+FVXc1e5leC9q0rH51xXndSgv3bsbepeOtK0jyn1KdYFlbau7uf7q10Om+K7C8s2vPPWKCNWd2dtoVFXczFv4RX5w2/iq/8AGPiG+8Sapujg+aGyt/4Y4v8A4pq9RhuLXXtB1Dw3rF29tpOpQNBdvC/lv5B+8qt/Du+7X3eN4K5cPz9T8woeIWIweMVOt8PW3Q774K3bfGD4l+Ifjzexv/YVlu8P+EElGP8ARYz/AKbe/wDbaT5Q3+8tfWsl9sevLvh7dWFt4Y0/StH0/wDsvTtPhS3tLb+5DH8q10l9eeR/tMzbVX1J+6tfnv1DknyzP1yfFUK9JVaGz2O1t7pJauVydr/o0K+c25v4mrQh1JN+zdXLVw+/LqezhM5hyqNV2bH655z6bOls22Xadp96+EdehvHvJ/7Slee6idtzO27/ANCr71um3w18ofFazsLPUoHhZfPu925P4uP4q+14IrqNV05K9z8c8ZcLOcIYiEtFuu55Xo+ua9pFyv8AZt2/3vuM2U/75rzj9pzxNYeIfDejWH/L/wCd++44+7Xo6xpF9z71eU/FLwi+uWcdzbL+9g+9X7Dl+Ew8sbCrJWa6n5LwnnLhjoKpK0f1PijxBNCnlW0P8NbPgvxdDocNzbXP3Z6xPFS2FjN9jtrn7XPF994eU/3d1cuscn92v0j67CrU9nTd7bn9RrBU8RhVCpsz6WvvFlhB4Yn1tJ182X9zCm7nf/e2/wCzXzDeTTXM0kz/AMXzNVlt71E0NefmeCr1YPk2Hk2UUsBfk3ZjNUdaEkNVGWvyjMMqnSfvo+mhO56p8EfiXd/CL4laL4zi/wCPKJ/IvoV/5aWsnyyr/wCzfhX9EGm6ha6tYW2o2Eqz2t3Es0Uq9HSRdysK/mHkj3V+0P7CnxR/4TL4Xf8ACG6lP5uqeEn+z/P3s5P9T/3zylfjfE2X/VsRzdGexQnzQ80fdtFFFeAQFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUzaafTaCJFZqgqaWoGroicVX4hu6iimVqcg+n0xafUgFMp9MpowqFeSviL9qy3/5A03/XRa+32r4w/asX/QNG/wCu0v8A6DX2HBkrZhDzPjOK4/7PzHxB5dVpF2Vp1VkWv6Ajb7R+bwmYs1fVnwbh8rw3v/vM1fLMkf8AHX1n8L4/I8NwJ/sbq8TiD+HGKPt+HPjb8jt7iTZDJ/umviT4xXX+mT7/APZWvs3ULhIklr4G+MGpefqrQp/z2r3OD4cs5T8jrnD2uIhH5lHwOu9v9la5zxpdb7zyf9o12vhOFLbTZ7x/7teTa9dfadSlf+7W2Xw+OoexCHPiF5Irxt8mz+7TGkqt51V2mrza87yZ6UaFyw0lQbqpNcf36jWbdXBOvHaT1OqOHNhWqVZPn2Vmq1XoW2Vye3+ZlKNjWt13vXoXg/wD4j8cX66boXkQbm2+fd7vLz/dVY+TXncLfx1+gn7PPhn7P9immX5oMzv/AL7V8XxXn08PBU6Ts3+B6WW4CFW9SeyK+kfsR2tzbRzeJvH9wJ/+eenWUcaL/wACkkzXUw/sT/Dv+Pxf4jb/AHXt1/8AadfVPnPU6768CliMVye/UZGn2VY+WP8Ahin4a/8AQ0eJP/Ai2/8AjFTr+xX8Lv4/EHiNv+3uH/2WCvqiNd9WVpSxVb+dkfI+WY/2MfhL/HqniGT/ALfF/wDZYasf8MZ/B/8A5/Nd/wDA3/7VX1GtSqtZ/XK/87LP/9D4C21YjWqnmUTXHkQs7/w19xX5rcq0bPGoQ69jL1q+2f6Mn8X8qz9Ptf8Als//AAGqfz3Nz/vVur/q69zC4f2UF36hiqv2Sf5KGWo1qxXTE872ZXaPfUf2b/aq5Ta09q0VHQqtb1G1vV6ij2pcZyKXlvTttWNtRstZj5rkdM+/TGk3/wC1XS6X4bubzbNcfuov/HjXVCh9qRnUny76HOx2807+TbK0jf7NddpvhF3+e/bb/sL1/wC+q66z0+2sU2WsW3+bf71acVdPNZHFPFN+7HQj0/SbazTZDGqrW7GqJVNW2U+a6+yws/8AFXLD2lWahDVvYn3YrmmW7ia2tk3zVl6XoupeMdSWztlbyv8Aa7f7VLoOi6r4z1WKwsI2kZvyVa+pYdJ0f4faP/Ztsytesv76b/ar7vAYFZbaUneo9l2OJ1Z4htLRdxNB03TfDVhFptt/yw++/wDeNdt4ds/7Tm/tK5X5V/1P/wAVXkWi3E3iPVfs0Lf6OrfN719L2NqlnbRp/dXbSzec6a/eO8nuXh+T7GyLsPyvsrwv9ozx0/hXwS2m2cm291Rvs6f7IK/M35V7jD8773b5V+b/AL5r81v2gPGH/CVePJLeGT/RdL/0dP8AfP3q+TwGD+tZhGnLVLVn0uC9ym59TxePZs+etLw/pM2uaxBYQ/8ALRv/AB3+Ksu42fcSvbvBOmpo2jy6rMv7+7+SH/d/ir9Wx+I+r03Pq9EeLj8X7Cm5y3ZvatNDEkGlWf8AqLZaoQx0zbvfe/3qtwrXxH5n5viq/N7xYjjq9HHUUK1pqtB4leqPhjd3VIV3St8qr3Lf3a/TH4H/AA3/AOEE8Nq94v8AxN9SxNdt/c/ux/8AAa+a/wBnX4Zvr2vf8Jhqsf8AoWlt+4Vv+Wk/97/tn/6FX6Cxx+VX55xhm22Fpvbf1PsuFso5n9YmtOhKtP20KtSqtfnMpH6VCFwVanVaaq1NWMpHo0qQLTqKKzOwKKKKACiiigAooooAKKKKACiiigAooooAK8t+LfxA074aeANd8YX8m3+zbYyRL/fmb5YlX/eavUGr8p/+CgnxK+13eh/CnTZfu/8AE01H/wBBt1/9Cb8qiNCdepGhBXbdjalyq8pbI/N7WNWv9e1W917VZPOv9Snkubh/7zyNuaqUa7vkT+Kmt8716B8O9F/tLWo7mb/j3sv9Ib/a2/dWv3XJ8o+HD0/Q8HH41Uqbqz6H1n4L+H8Ph7wlZfZpduqf8fFx83r/AA/8Br6B0vx1f+HrCP8AeL+7VflYV8bWvj6bRdY+03kjeV/d/wDsa908B2N/8Q75b+b/AEbS4/u/7dfo2Z5VClS/2nWCP5g4gy3G+1+tYiWl739T7P8ABPjb/hJbDzpo2glX+Fu6/wB5ao/FjxhDofh9rO2k/wBN1L5IdvYfxNWXCthosKzJ8sVon/jtfCXxA+O39q+Kr79358UH7m3+itX59knDKxuM56atBa2O7La+LxlJ0KSu1u+yO5WNG+e5g+b/AGhXunwd8E2cV/8A8JJ9m8qf7sP/AMVXL/CvWNH+Jvhhbm4svszWj7N3yrX1b4b0u2trZUhXbFF936V38VZ9OFOWHtZ7P0PIy3BYiWKdKorWequa/ibwfoPjvwxqHhLxHE0+naomyba7K4w26NlZfusr4Za+fdG+JPjb9nzUrbwT8apptd8ETusGkeM8f6r+7b6ivzfN/wBNP/Q/4fqaP5KbqWn6Vrmm3Oj63Yw6hp16nlT21yiyRyIf4WVutfiGKpc3vH9AZFmXslyPZnUWV/Z6nZwahpsyXdrcoJYZoXDxyI3IZWHBzVraa+MP+EF8f/s9Tya38IPtHivwNJN5t94QuZPMubX+9NpUrc/9se/+1/D9IfDn4neDfijon9ueD9SW7ihby7mBh5dzayd4p4T80bD/APVXn+9H4j7D3KqvBne1Vuri2s4WubyVIIl+87sqqP4fmZuK0tprxz44R+f8MfEVt97z7fZ/30y1th4e1modzzsyrfVqMqstbanqNYGuX32Gzkm27tq14z8GfH2t6zYLo+vW0zfZsw22pbP3dwIvlZW/2l/vfx17deRpcpsf5lb71ejPCuhV5J9D5apmUMbhXOg7N/gfNvxC+A/hL4v2cmrPF/YniPyf3GrWw2yf7Kzr0mX/AHq91+Hvhmbwh4P0Tw3NOlzPptpHBNMieWkjqvzMq/w7q6Wzt1t02Iu1a1FWpxWNnP3OnY7cqwUowi6juy0tcR468FW3jjR4tKuLuWy8u5guRLCFLZgkEm35v71dytLuNeVGbjJSTsz6t0KcoOFRaMIY/KWrFQrJS+ZHWLO2lKCioolpu6meZHXj3xf8T3Oi+F20/SpfJ1fXZ49Ls2Tqkly21pP+2ce5/wAK2oUJ1JqEFds5sfj6eGpOpN6I9NvLxErHjutz1534k8RW2h6PLfzS7YLSH+LlsKvy/e7tXnXwV8ReKvF95r/iHWJ9ul/aEtrC2UfJH5a7pGz/ABfer6KlkzVB1Xsj8tr8VfWcVyQR9EXUm9K+YPjFN/af2Tw3/wAsrtt9yq/xRx/Nt/4Ea+lZpE2V8za5fWd3451L/lp9hSO2X/f+83/oVezwzS/f81ttT4vxAzFww6lB6s8G/se50jz5pottvz3xspfALXni/Uvtn+q0G2f/AEbd/wAvEi/emb/ZX+Gt/wAfRv4xvF8MWMj/AGD5f7RuE+XeP+eK/wDs1S6xrFh4J0q20qwg8y9n2QWVsn8b/dX5a/U8RjZVaXvqzZ+YU6/NTVO3NVnt5I+otB1zTbFFtvPT/gTfNXdaXH/ad59seP8AcW3+p3fxufvMtePeA/Bb21taXPiGf7XqPk75/wDnmHb723/dr1Hxd420H4feGLnxDrcvlWtsu1EXl5ZG+7DGv8TN/DX5DnCp+05aer7n63wTSrxp/wC0NJLZI5b4jeItVTUtP8PaC3lz3PzzTf3E/h/76rwfx5pusf2lp/gnwrrt/c+OvEX8aS/Jptl/y2vbjb91F/g/vv0qSzj+OXxGuf7V22Hw+sLn/ltMn2vU/LP92P8A1a/8Cr27wn4T8H/CTQdSv45ZpLif/SdS1S/k869u5F/iml/i/wBlF+X0rSdX6vTjTp79fM6aGChXxcsZipXSeiWySL+ueILP4SfD3TdN+03fiLVIIY7Cz8+TzLq+uf8Aab/x52/hWvCrPwv4nvEude16f+0NZ1D553X7if3YYV/55rW9p+j634z8QyeNvFS/ZOsOm2f/AD6W3+1/01k+8/5Vy3xa+Mln4C8jwx4etv7b8W6h/wAemmw/wf8ATS5/uj/0L6c135X/ALH/AI3ueDxDiKufVfqtPSC6mB4q1TR/Amm/2x4quVtrf7qQ/enlf+5HH1Y15NHoPxC+Nr/Zrlv+EO8Nfww/8vl0n/TT+7/u1e0vwTqUt/8A8Jt4/u/7Z8Vz/wAbc21on8KQx/7P96vXPBOpPLr0dtcybmb7u3/ar7P2GIq0nXqO1lsj46lisFlc+TAJTmt5PZeh8+X3w18N+BGaFNP8uWP/AJb3H71z/wB9V4d44a21Pb5MaqsX3dvy1+mHxI8Fw+KtEb5dt1Ev3u9fnx4q8H6loc0m+PzNu6v0ngfOaNen2ktLH1vDmczliP8Aaqjc1td7o+f5o7aL7m7d/tCs9mrf1Zfn37awGWv1iUnyH7ZQnzQUiFl31lzLW0q1Suo6+J4mybno89tT0KFXUy6+mf2SfiV/wrT4y6T9ok26T4k26Xd/9tW/dN/wGSvmtlqLzHi2zQttli+ZW/u46V+B8U5Oq+FlTa1WqPYwtflmux/UIrU+vDP2fPiIvxN+EfhnxV5nmXklsLa9/wBm6t/3cufr96vc6/D6TutdGehKNmwooorQgKKKKACiiigAooooAKKKKACiiigAooooAKKKKACmtTqbQJlWWoWqaWoGropnBUG0yn0ytTkHrT6YtPoAKjapKjakjGqRNXxh+1dJ/oejf9dn/wDQa+z2r4l/asbe+gQ/3nk/9Br63g//AH+HzPjeKdcPy+Z8a1C1abW/9xaz5l2V++0tYn5rKk4y95Gd5e/9z/E1fXvhOFLTRLaH+7CtfKej2r3eqwIf7y19YWqvFZxJ/dXbXk5p701E+6yGHJTc3uzL8RXXkWc7/wCya/P7x5dfbNe2J8zb6+zvH2qfZtKn/wBxq+HrGN9c8YQL/wBNv0Wvq8ppSpYOdQ7cthzYh1OiR6TqEn9keG1h/wCeiLXhEknnzSzV6j481REmazT+FdleTr9z/ermq3p4dd2e5lcN6kuokkmxKq7jRI1Qs3yV4fOlfm6HtQgVJPnqWNdlVmuNlRNcTS1+f183oUqje78jv9lJryNhW/2lX/gVXo7iH/nun51i2cdhu/0+Odl/6Y7f/Zq6W3uvCUH/AEEoP+/bUpZ/VlL4UkP6nCW7O68B6S+r69bQvHut4/37fRW+Vf8AgRr9V/hno/8AZmj79v8Arcf98ivhP4F/8KpmupftPiT7Jfz7NiX0kcH/AKM2q3/fVfplZw2EUMH9lTrPa7fldNrBv+BLxX5visf9czN8+y27HrYqhChhEqb33LarVuNaFWrEce2vpJTPmSVVqysdNjq1XHNgM2mjaafRU3LP/9H8/o1SsPWLj5/s392tK6vIUtme3rAhhe8m8x/+BV99gIc9T2k1oebLlhDfYmsYX2b3/irS21KtMr35SPJ9rzTHLUlQ0+gB9FMooActK1Qq1Vbib+5TjDnkWSXF15X3Pmp1vY3mq7UhrT0Xw3Ndus1z+6i/Vq9LsbGG2TyYV2rXb7lJd2Y1cQo6Q1ZgaT4bttORXm/eT/8Ajq11EdI3ySU6KonX69zh+KXNLVkm2nquyk3Gs661SGx/1zfM33V/irTD4OpX0gtyOaJrSSJAnnTNtWovDeg69461uPTdHgaTc34KP77V1/w/+DvjD4l3P2+8/wCJXof3/tE3y79v9yvqH+0PB/ww0r+xPBi/v/8Al4u2++f+BV79DEUMqTt71R7Loh+wnX02XcoWum6D8JNB/s2w2z6zOn+kz/3f92vmzxV4qudVv/sds25m++3XrVbx946uZ5mhtpd089dL8GfAc2p3n9sar8y/f+b1r6fh7CckJZjjNeq9TLMuWNNUqZ7x8M/DP9j6VHeXi/vWUfe/u16u02+ufur6GB1sIf8Ax3tWpb/wp977tfM4+tOvN1anUzwceW0ImL4816Hwx4M1TVXl2/udqf71fk1dXU19eT303zS3Lu7f7zNur7U/am8WfZrax8H20nzL89x+NfEq16fBWC5pyxD67eiPra3u04w+86Xwror6vqscO391H87/AOyq17VdTb9sKfLFH8qJ/dWs7wjpP9i+G/tD/Ldalhv+2f8ADV/y69POMR7WpZbI/Lc7zL2tVpPRaDI1q9HHUccNaMMdeEfL16pNDHXT6Pot5rWq2mj2cXmT3LiFP95qgsbXYjXL/wANfVH7N/gn7Zf3PjC8X5bTNvabv+eh/wBY/wDwGuXMsbDDUJVX029WY4fDzr1IwW7/ACPrDwP4ZtvCXh7T9Es/u2iBWb+87feZv9413SrVWFau1+C4qs5zc5PVn7bl+HVKmoxVkh6rUtNWnVxyPZhEetS02nVJ30woooqCgooooAKKKKACiiigAooooAKKKKACiiigDK1O8hsbOS5mby44lLs3oF+9X87Pxe8cTfEb4l+JPGfmeZBe3ciWn/XtF+7h/wDHK/aH9q3xk3gj4LeJtStpPKup7f7Bbf8AXS7/AHPH0UtX4JrH5SKlfXcC4D2uLliJK6jt6seKny0lDqxu019O+C/Dsmh+Cf7Vdf3t7lv+Afw18+aLp/8Aaeq2Vgn/AC8zIn5tX31r2qeGLbQbTSrPZ5FtEIvy+Wv37h/CulVUrXv+B+Sce5rKlCnh4q/M9bdj5c8B+GZvHHi3/TP+PWBvOmb/AGf7v/Aq+3bGaHTL/T9K0pvL8tfup/cFeT+EdJsNAs5Lizj8trv98/8A7LSfDXWpvEfxO1n955lrpttsT0+98zV62fT9rec9lsj8s4qrVM09pVhpTpLReZ9N+KtQf/hD9Sm3fNFbv93/AGVr4Z8G+H/DDw/b7mSC5vd2/wCd/uf7y19v6lqD6fpu/wCxNqHzN/o8Kqzv/uq33q8Ms/g3/wALB8Sf2r4gsofDOnSf8u6bRM/+9t4WvAyHNIYOE+fRPW54vCWb044ecKs+RPqt2dH8Ndch0jxIv9mweZps/wAk3kpujT/a+WvXte1j9oTwxr0/iTwTaad448KSYf8AsX/j2vYP73kSfxH/AL6/3K3bH4E2fh7Svs3w08Tal4Un/wB5b22k/wCu0Nwvzf8AAStYEPiT4u/DC5/4rPw7/wAJBof8ereHo2keP/amsvv/APfNfmvEOaUsfUc4aevU+7ybATw2I9vStNPdPc9M+GPx98A/Eu5/sGGWfQPFEX+v0LVE+zXiP/Ese/Ak/wCA/N7V7m0eyvAdZ8JfCD9o3w3BqVx5Oqbf9Rqlg/k39rJ/10/1isv9yRfwrg47v4/fAnm4Mnxg8EW3/LZP3evWcP6/aNq/73/AK/Pp+1h8R+n0sPh8Svddn2Z7j4k8ZNoMzbImnVf+A/8Aj1fP3iv4fDxrqv8AwtP4Kan/AMIf8RrT/j5/gttQ/wCmd2v3G3f39rbv4vUeq6D45+GXx202T/hE9W8y8/5b2c37m9t9v/PW3bn5f9ncvvW54P8ABt/4eubma8kWXdhEZPuso/2a96P1Kvhe0vzPz2dbOcuzLRXgyr8JvjL4k8T3p8G/Evwjf+FfGNpEXf8AdNJp92sf3pLW6XdH/wAA3fRmqx8dvtOuaDpvg/TZdt14i1GC2/3I4/3szf8AAUWvSt3lJXmevaxoNn450T+3rn7JL9nkXTnmO2GSeVtsiq33fN2fdX8q8rB4Xknzdj6jOM+niKXs2rX3Oy0vSbPQ9KttKsIljgtoVhRfYVr2N98/kzN81VJplda5e4vHifen8NejDDure+7Pk6+aQwck1sj1uFqS61Kw0+2kvL+5htreL5nmmdY0Vf8AaZsBa8evPHVzp1mzwwefKq/Km7bvP93d/DWfo/xG8PeNvtPhvUo0gv8Ayf8ASdNu9rO0bfxL/DJE396uOrk9Ve+1ofR5fx1hKt6dJ3kuh71DeQzos0Miyqy7lZTkFf7ytQ01fGGqeEfGHwmvJPEPwlvn1DQfv3fhe7fdH/tNYydY2/2PutX0n4Z8RQ+J9Esdas2/dXsCTL/s7l+ZW91rnq5byxU07o92HEkKvu31Ozkutqferyu6+JU15f3Om+G7H+0GtJnt55nfyoY3X7y9y1d4yu6V5n/xTfhWbUPt+pWmny3d3Ldv9ruIoSxl/i/eMta4OhT1c0eJnGPxsko4d27vcp+LviB428P2a6lZ2NtPBF/x8qzNnb/s7a5PUPEn/CW+J9I1V/8AjwsoN0MLr8/2mX+L/gKfzra1Lxx8NJ7aWwm8beHl3f39Qtv/AIuvPdN/4R53+zaD4t0TV/7kNpeW7SH/AIDvr6rLYYTe1n39T804h/tvk5LOUN35GF8aPFX26Gy8K2HzeY6PP7/881r6F8A6CvhLwrp+iJ/rYE3TN/ekb5mr598E+C9S1rx5c63rdpPFa6a/nI8ybfNm/h27vvba9R+JXjz/AIQfR/8ARovteqXuYbO3/vyf3m/uqv8AFXbmdKM+TBYfW2r82wyqtUh+9qLVi/Fb4qW3gmwXTdN23Ovagu22t/vbM/L50n+yv/j1eD6Xa3NtYbJp2kurndNczt995JPmZq4rS9H1KfUpfE/ie7+23922+Z2/v/wqv91F/hrrbjWIYPKhRWubi5bZBbw8ySN/dWvq8tyaGDpd292fI8V5pPG1VQoapGmrQ6ZCqQxtJI3ypCn33ap/A/w/1W68Yf8ACYeMNnm23/Htb/eSAf416T4b8OppVsupaltlv5E3O38Mf+yvtVTXPEkMCeTbN+9n+RfV29FrgxWNde8Ibdz57B4qeDv1b372PT5vFmg6Daz6lqt3DbQW23d/Ed38KKq8szfwrXmzWepeNfENt4w8T23kWtl/yBdNm/5d8/8ALedf+e8n/kNeOtUdB8F+Xfx+IfEk/wBpv4/+PS3/AOWNpn+6v8Tn+9+VeitcJ/vV8v8AU4RqOS1Ps5cQTeHVKMrX3t5mzp91Nv8A9mnalIl8i21wqyLEwfa3K5X7v5VlSalDZ2zzTNtWJfmb7tcR/wAJd9uuf+JbZXd7F/ftk3Iv+8zcUvqfM3O2hy1s49lT9nFttlP4meKPFWmaPLYeA9LbUtcuf3Nv91YLX/ptIzf3f4VrxX4d/C//AIRP7TrGvXP9reKNU+e8v3+b738Ks3b/ANCr6Wjt5ruH99G0G7+F/vf+O1i3mlzQP/qvl/h716mC9lF+Z89m3EuNWCeGpK0W9Wupwlxpvno0Ncfp8ieHPE9jcX7eVFu+9/vV67/Zsz/crx7x9rmj+S2m7fMvf739yvsMtqvESdBK6ej8j57IpV5VlCzaf4H0fdatbfYJLmGdJIl/iU18o+JvCuvePdYneFktrWvO4da1JP3KTv5X1ap4fEF//wA/LrF/vV9DlXC9XASc6Ulfo+x+gxwGKhV9rTaTW3keX/FT4a6l4M23P/Hyrfxr/DmvAZmR/wCHbX6JeAdLh8VXl3DrH+nWv/PF/m+9/erwb46fBH/hDJpde0H5tL/5bQ/888/0r7LJ+L1Gp9SxTvPv0Z+n8JcWw9osFi37/R9GfMFV5vnqamba+wxcva0+Tc/VUU2j31mSLsevQfC/h+517WLazRf3W8b2/up/FWt8WvDaaHryzWy7be7hV/y+Vq/LOKMsXJz7NdCKea044pYa+rVz7a/4J2+Pkjm8UfDS8k+9s1ay/wDRVx/7Tr9U1r+e39mnxj/wgfxy8Iaw/wC7tbu7/s+5/wCud5+6/my1/QfF9yv5IzbCfV8bKn31R9j8UEyWiiiuUkKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiimtQBXkqs1WpaqN9+uimcFWIlFFFanLKNgp9FFSSFMp9MoMWQtXwz+1NJv17w7D/wBMZX/8e219ySV8BftIXn2n4i6fZ/8APpYJ/wCRGZq+y4NX+2xl2ufHcS/w1HzPAmjrnL6Ou1kjTZXP30fyV+14eqfOVcKqumxc8B2fn6qr/wB35q+iriTyof8Adryf4c6fv3Xn96vTNQ+RGrmq+/V9D3cPD2VHlPnj4wax9m01krwr4e2PkJfeIZv+WXyJ/wCzV1nxq1B57+DTUb/aqnqUP/COeA7Gw/5b3e5v++q+9lS/2enRj13OrALlpX6yZ4/rV099fyP/AHmrJk+X5K210u/+zS6l9mdo1/j6YrBmuN/8NeLm+IVWo1T2Wh9Hh9lCGqRQkqvcN8myrDVTb55K+NzWfLScOrPUpBHCn92p6ZT64sLhKUILlRUpDlrq/Degza9qUFmn+qZ13fSubtY98y19pfs8/Dv+0dYiubmP91FiX/gNfNcW51LBUOSD956I9LK8LGrNzmrpbnv3wn/Z1+GOlWEGseIfDttrN7doH236+ZGn+7C3y19PaXpulaNZxaboOn2+l2EH+ptrSNYYUz83yqvC1Hbw7NqJ91a14Y6+NwGA5Pfnv1ZxYzFe1m+i6IsxrVxVpkcdW1WuybOGMQVasbaFp9c8pDGU/bSqtLtqLgf/0vzWuLqHf/oa7a0LVdkf+9WFDHJv+7XSR1+qxw8aSPCxsvxJaFooqzyR9FFItQdUNhagmk2oz0+T56q/Z5ryZURflrswlCVWS5S9PtaWKy+dc/IldxofhlIv9JvF3N/CtSaXpMNpt3/erpd1erXhGPuwOSriOb3YaIsKtTVVaaOOs661iztv9dJt/wBmsI0Jy6HL1tuzb8yqN1eQ2yb5pVj/AN6um8I/DX4o/EPbN4b0j7Jpjf8AMRv/ANzb/wDAd33v+Aq1e76P8I/hL8PP+Jl481T/AITLXov+Xf7tqn/bL/4v8q0jShB932RVkvievY+f/B/hHx58S7n7N4M01vsv8d/cfu4I/wDgVfSeh/Bv4afDJ11Lxzqn/CTa9/z7oP3Kf8Bqv4o+NV/c239laJGmjadH8qQ2wVeP+A/+y14XeeILmd2d23bveu3mrv4PdXZbsw5+b3dkfQPir4tXOoW39m6Uq6fYRfKsEHyrXgXiLxZNsb5vmrCmvn2b3auW8ubWLyNPmb5vu17nDXDixNW9RaLVs0q4/lXLHSx0HhHwzeeM9eihhX5pW+96V9xr9g8HaPbaPpv7y427Pxrhvh/4dtvAeg/bLmLbqV3/AOO/3Urq9Pt3nm+33/8Ar5Pu/wCwK9rO8b9Yn7OnpCOy7s8uOvvS3f4GtoNm6f6TefNPL96uk1bWtN8JaDfeJ9UZY4LSF2+b+I7flpuj27zzL/nivif9pT4pf8JHqv8AwhOiSf8AEr0tv9J/6aTL/D/urXxteE8XXWHp/PyPpMvoWXtGtEeAeMPFF54z8SXuvX7f8fLnb7J/DUXhnS/7Y1u2s/8Allu3P/uCufr2j4e6X9j02fVXX97c/u1/3B/8VX6cqCwlD2dPSyOTPcf7ChKp1ei9Tubxt77E+WKL5UX0UfdqnGtT/eqxHHXyXJI/IZTtEI460oY6bDHWxax7EasuT3jzqtXzsbOm6ff6zeWOj2C+ZPczIiL/ALZav088F+G7bwr4f0/RLb7tpCFZv77/AMTf8CNfKn7N/gv7dqVz4tvI/wB1Zf6Pbf8AXQ/eb/gNfbarX5dxtmnPV+rQekd/U+74Py2fK8RPd7ehLFVtagWrC1+dTP0/DolWpVpi1JWEj1aUR1FFFQbhRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRTWpSlygfll/wAFCPFT3N54Q8Bwyf8APfVLlM8fu/3cO5f+/lfmg3zyV9a/thax/wAJD8ePFHzfL4dtrLTYf+/fmyf+PO1fKqx1/Qvh3kP/AAnqdtZO7fkeXja95+h6B8M/Dd5r+vf6Gu77FD53/sq16pq2i+JLS/trCGNZLi7m/wBTv/hrpf2fdH+zeG9X1vy/3t3NsT/cjX/Guh8J+drnjPVNSeTzINP220O7+9/FX6TlmNnQhPsj8Q4h4gn9drOycaaW/c1rHwb4h1i2a21W7h0uCRP+XctJJ/301eg+CfBPhvwZDJDo8DebP/rrh3zI+3/arQWr/kzSwyQwz+RKyna+M7W/vV83j686vxs/E8yz7FYiEqHNywe6Wx0v262tk86aVYlX+821azF1qG+m/wBHl/cL/Hn5d1ea+F4003XpNH8Yfv7+dmeC5uNxinT+6qtwrL6V7YtvYOnkvGnkfxJhcV8/iLQltc+fzLAU8HUUXd31T6WO/wDDepTaZYKj3P8Aq/vK53bRUtr8cPB8F/LZ6lO8Hlf8t/Lby/8AvqvFdUh8VeFYf7Y8K23/AAkWnQf67Sd+26j/AOvWZt3/AH7b8KzbP4nfAfxs39leJrv/AIRTWf44NWgaykT/ALbf6r/x6vi8VDCc7+sXV+qP13helj5Uo1MM+ZLtv8z6a/4RXwB4sm/4SPw9OsF7P/zEdIuPJlf/AK6eT8rf8DDUTaX8QtD/AOQPq6a7B/zw1IeVJ/wC4hX/ANDjavFofhPcwJ/b3w38RW8i/wDPa0lX5/8AtpD8jV1Gl+NPiv4dfyfEOhNrNr/z2t9vmf8Ajv3q86eAXx0JqS7PRn039pe/+/g4PutjjPHHw18DfEbWI7i8gu/h98RP+XTUrTbbTSSf9dI28q6/76WWn6D8TPjN8KJv7H+NGiS+KdB3+TD4o0WLz3T/AK/beP5v+B7V/wCB19E2ereEvG2m/ZtStk/f/ftL+Pa//fLVxmqfDf4i6HN9v+FfjHy4v+gP4hja9s/+A3P/AB8w/wDfTV4OI5O1mfZZZiqlWHLzKUendHcR6hpXjPRI7/QdX8yyuV/c3dhKK56+8L2es6PP4e8VbNfsJ/v/AGmNVf8A8d/i/wBpdteRXXxE8eeB3l/4TP4VXem/afnmv9AddQs5P+mknlr5kf8AwOrK/FrVdThjudO8M3ccUn8d3JFD/wCO9a9jAYOdb4NT43P5Twc+eqred9GZt9o/xX+FP+k+D538e+F4v+YXfyf8TO0T/phc/wDLVf8AZb5qs+H/AI1eFfGb/Y4ZX03WY/8AXabqK/ZrpH/u+S3+s/4DXWaf8QIbl1hvImtP99ty/wDfS1leMPBvg/xtD/xNdPt7mX+G42/vE/3Zl+fNevSwE6M/3iPlcZxDhMbScKl791uQXDfaJmd9zbmrlPGXw/vPEthaX+lXL6f4h0v9/p13D8ssUi/+yt/EtYsOn+JPCE0cNhqH9qWUX/LHUf3rov8Aszf6z8816Ja+Nns/31/ptxt/6dP33/jv36+gxVKfstro/OctofVMWqtCpd307/MsfCv4iX/i3z/CPi22/sjxlpcP+l2nRLiP7v2i3/vRt/45WT8R/wBo7wH8FIZfCvh2y/4SLxNvld9NtJNsNp5nzf6RN83l/wC4vzf7teB/Hz9obRbHy/D3ga2T/hKNP3q+tPH+90vzPlkjgb73n4+V/wC5/v8A3fgn7dNsnTzG/wBJ3ec7HLybvmbc3+1XDlHB9fMv7sO/c/qThzKOW2LqRs2tux718QP2mPjN448+G88Tf2NYS7v9A0P/AEVF/wB6Zf3sn/fRr50uv9MuWvLxnuZ5PvyzO0ju395mapKZX6zlfBWAwkPchfzZ9tz/ACIfJhpGjSp6ZXszyuha3IrBzy7nfeEfip8SPAk0X/CK+JL+xij/AOXfzPNtv+/Mu6P9K+k/Dv7Smj+Mb+2/4WjZJpOo7Ftv7XtEaSDZ/wBNrbrH/tNHn/dr4uptfJY/hmhz+1pe7LozzcyyXC42m6deG/XqfrTJ4J1LU7O0vNKu7a+sL1d9tdwSrJBKP7ysv3q0bXS/Dfw5hk17W7nzLr+O4m+X/gEfpX53/B346eJ/hJf/AGVP+Jp4auZh9r0t+n+1JA3/ACzl/n3r770nwb8PfHttafEW21CfxNZah/qHvJN3kf3oPJ+5G0f93FfDY3G4mFT6vidPTqfhPE3BX9l3qxbdLyWpzOrfFzxD4xuv7K+HWiTXv/T7cL5drF/wL+KvQPAvgW/0yb/hIfFt3/amsyfx/wDLOP8A2YV/hrJ1L4ieGNDuV0Hw3A+t38f3dO0mP7TJ/wAC8v5I/wDgWK1dLs/jFrz/AGm5isPClk3+rWf/AImF0v8AwFdsS1w4jGQjDlhofNLAVa9P93S5IdW92dLrFxc3L2m/93ZfaE3t92NR/eaStuO+fUYdnhu2/tD+Hz2Pl2qf8C/5af8AAM1paP8ADuzTyrnxDc3Ou3S/xX7KU/4DCv7tfyr0RoYYIdm1VVfwWvFr5jso9C8v4WnC86j3PNY/B9tK63PiGdtXuF/5Yv8ALbJ/uw9P++91blxdW1nD/BGsS/dX5VWua8beNLPQ0+zWf+k38n3YE+b/AIE393bXh8nxC037Z/xNdZW7vW/5crZWuZE/3Y4s134XBTnD2lR2RnjJ1I3p4Wnd+R7fN4osIvuRPO3+wlRR+MtK/wCXyC4tl/vPE2z/AL6WuL0W8+IWuP5nhv4b332f+G51qeHS4/8Av388v/kOvSNP+GPxC1r/AJHPxJp2lWX8dnolr8//AIGXW5v++YVrixWOwtLS9z0ct4FzjELnqJJPZMRr7Qb62/4+4Ggn/wCmqivA/Hnh/wAN6c/2zz4Vgb+LzVavqnT/AIN/CvQ/9MfQrSedfvXd/wDv5P8AeZpa53xV4i+Buh232bWNQ8PRxf8APBzbt/5DXmqyjib6vW5qadj38V4eVaUVPnV1vbc/PHVtU8K6c/2n+1ofK/uL+83f981b8N+C/iR8RnX/AIQzRn0/RpPv61qkXkw/9sI25k/WvqTwf8P/AIe+KvGH/CYeH/DsS6XHjyZXt/LheUf8842WvrT7KjJ93+Hb+FfXZ3x7VUFTo6XWr6o9bJsPS5HOMW2tNdj5r8C/DHR/h3o/2Oznmvb25/e3N/cf62WT/d/hX+6tU/H1rpup6Jd6bfxbvNhdPz+WvftS03+KvGPFmk+bMszyosUfzMrN/EK8LJ8b7Wopyevc/P8AiujVpVPbdb3v6Hyp4V/Zv8Hz2Hk63Pctfz/d2PhR/dXbXyz8SvBf/CC+LbnQfP8ANij+ZW/2Gr9AtQ8VQ6Lu+wbZL3btT2r4H+JkesXfiSfVdVn8+e7f+Juf/wBVfuPB88XPFOVSV4W0T7n2Ph1n2PxmIlLFT0a0TO78F6toljo8dnbN/pX/AC2rl/i1qVhqem2nkybpY2/nXlEdxNYvvT5WrPupnn3b23V9LnOCp8ktbtn6TheHIQxixXNdowGmmtpIry3bbJA4dG/ulfmWv6VPh/4kh8X+CvDvieFtyaxptref9/owx/Wv5qpl+Sv3S/Yn8Rf8JD+z34bheTzJdGkutOf28qUtGv8A37da/jnjjC8mLUu5+l4WXuH1xRRRXx5qFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABTadRQBDLVRqty1Vat4HNVG0ynNTa0OKY+iiigwkFMp9MoMZFSX7lfm18XL7+0/i7rv8S2nlQf9+46/SO4+7X5X319/bPjDxJrH/P3eTuv08z5a/Q+AqF686nZHxfEM/fjArTR1zeoLv3V0txv2NXPxw/bNStLBPvTv/wCOj71frsYac3Y8qk/e5T2fwbZ/ZNHV/wC9VjXLpLawnmdvuruat2G3Szs47ZPuqqrXjPxY157HR2s4W/e3Pyf/ABVc+VUJV66j3Z7OK92CR83WOnzeNvHnz/NB5x/74Wuh8QRv4t8Z/ZkX/iXab+5/4GtbOi26eDPCupeJLj/X3a+TbfjWz4D0H+xvDc+var/y13z/AD19Nn2P/eL2fTRHVQq+5zdEeV/ErUE0yG28PWf/ACwX999TXhbNXUeLtUfU9Yu7l2/1j1yy1zV8PClahH1bPewFLlpp9WRS1UWpZG3vSqtfF4v9/VfLsj1I6RE3f3Nzf7orW0/R9V1F/wDRrZf9+d1jH/j1UI2dPuNUq+dJ/easJ5fVnvOy8he08ju/Cfg+41rWo7D+24bS6b/n2iab/wAe+VB+dfqb8H/Adt4J8NrD581zPc/M8053O3+FfLn7NPw11WSaXW7i0n+b/pk2K+/7fT5rZFhdWXbX49mFKFfH73Udrnu1a/sKHJHd7mjCtasK1XhjrTjjr2ZzPnSeKrKrSRrVlVrimyhFWptpop9YXAi20balpm2i5J//0/ztVadRRX6wfJD6KZup+6jkkYj6haT+58tQyXG35P4ql03T5r6ZvO+7XpYXK3P3pbG3wwc5uyQW9vNeTfJ93+KuzsbFIE/u1YtbOG2j8mOtGxj0qW52a212tn/F9j8vzP8AgPmcLX0dLDwXuQVkeRVx6qvsjIvNUhs6do6+JPFV59g8K6Nd6pdN/BbRNJ/31t+7XuvhvWv2e/DW25/4QDVvE1+v8eqXsfl/9+4/k/8AHa7nUv2nPEMFn/ZXgnQtJ8IWH/TpArS/+yr/AOO1yTxvI+SlSu+72OyE6Vt7nIeH/wBln4hajCupeP8AV7TwpYf3N6y3P/fK/Iv/AH3Xp2l+HfgP8Mn+0aVpv/CUazB/y96ifOG/+8sf+rX/AL5r511jx94k16b7TrGqXN3L/wBNnyP++f4a5aTULyX/AJa0/qtev/EfyWiOatmPL8B9LeMPjNr2ubrb7T9mg+75NudorxO81iad/wDerklmmf77UvnPXbTy9Q+E5PrhrNM70z5Iv9mqsbfJvf7tU5rj7S+yvQwGV1K8+WC06inWjbmINQvJp38m2+7Xvfwp8ErBH/wk+sR7YIP9Vv8A4z/e/wCA1zfw/wDAr6rN/aWq/uNOg+Z3b+Lb/CtdT4w8ZPqdzB4Y8PfLB8sPy19zL3af1PDdd32R58sRzR5ui/E9T/tb+2bzzv8Al1gb5a6WxbzZvkrkNLsU0zTbaz/i2qv+81el6e2m+EvD134t1tljgtELfP8A7NfGZnVhSh7vol3OzLYTqz/M4D43fEJPhz4P/s2zk/4n2sq0Kf8ATNf4n/Cvzcbe7s7tuZvmZm/izXaePvGV/wCP/E934hv/APlp8sCf884x91a42vquGeH/AKvT9pL4nqz66Ure4tkX9H02bVb+2s4fvSOF/wB3/ar6Qa3hs4YrO3XbFAqqv4V5/wDDHSf+PnWJl+7+5h+v8VekTR73rpzKn7/LHY/MOKcy9riFQT0RBCtaccdR28NasNvXizw58RiK463t97/ItbVrp9zPeW1hbLunuXVFX+87NtWnafb/ADq9e3/A/wAN/wBveM/7VmX9xpfz/wDAz92vCzfERw1KVV7JfiThaH1ipGC3bPsvwL4btvCvhjT9Htl/49oRub++5+Zm/wCBGu1Wo1XYlSLX84Ymu6s3OTu2fveEw6pRjCK0ROtTrUC1YWuSR7NElWpaiWn1gz04DqKKKRoFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFIaWsTXtQGlaLqOq/8+VtPcf9+42aqjG7QH8/PxQ1abxP8QvGevf9BTW7+5j/AOuSzNHH/wCO156tu+zfXomk6K89hbTTfM1zD5zf9tf3lWZvD/8Ao33fvfLX9ycOYSlh8BSp+SPz3FZ3T9q1fqfRPhFk8PfCjT9nyyyW7zf9/G+Wun+HOh/2d4bWZ/8AW3LPM3/Amqrp/g+bxDo9jon2nyIlhiT/AL5/hr27Rfh3eW1hBZpqHmRRKFXivh8xzKjRThzWu7s/njNa08RCqqLu5Su/Q4SGR2m/3a3F/dR+c7eWsfzMzdlFb194ZudG3PNt8r+93qh/Yb3O2a/Vvsq/N5H/AD0Yf3v9mvJnj6clzQeh8PiMPNVOWomrbkuk29t4ltvOubbz7fd8m4dcfdZa67+w0g/49/8Ax5q0dFuLO5/0azg2+V/drs10m/lh/wBGtk83+Fp32j/gW3mvl8bmXLPyOuhkk8VD3L26LseeQ2d5A6v5bfLWjqWieD/FUX2PxVo2nat/1/wLJt/3Wb5lrr7fwPrF8/8AxMvEH2Rf7lpAq/8AkSTdW43wf8JX0Oya7vpJ2/5btdN5n+H6V4GMzihL3Zr7j7nhrhHMqFqmHdvXRnzf/wAMx+CYLz+1fh7ruteAtU/gfTbtpLb/AL5k+b/gPmVbms/2sfAqf6HfaL8T9Oi/57J9iv8A/wBkX/x5q+mNB+Ht5ocMtt/bs2pR/wAH2uNS6f7O5cVPqGh+J7a3kfTVtr64Vfkhd2hU/wDAvm218zP2H/LuVj9Zof2hGn/tUOf8z40vv2jH85fDfxF8D6p4Zv7tkTybyPzYW/65ybV/lXoDeKvjl4Yhjh8E+HdO8QWH9y5u5FmT/Z+Z61tY8WfFTTH/AOKq+FWpT2Eb/wCv0ue31Yf73krsl/8AHat+H/id4M1y6+wW2of2fqP/AEDtRiksLn/v3cbN1etQqwnS9noz5vNKNfCYpYylSaSWqvdD9J/agtrG5+wfFfwhrXgmf/n5eBr2y/7/AFurf+g07XPEXhjXrn+2PCt7PrcV3/y7WyMqf9/mT5a3tU8SeJ9O+TR/C93q/wDtQz28af8AkR1ry3VPEHxdvv8Ajz8BTWn+3cXULbP+/b1rluC9lUvex53EGbzzPCqPIlbqJqWh/EjU/wB94f03SdNi/u373FzJ/wCQ9gWuQj0/9pDw75tw/h/SfEVl/wA8rC48m42f9M/NrZ0nR/jo83/IS/suKT/n5SK5RP8AgPWvRdPuvi1o3/H/AP2b4ii/6dvMtJ//AB7clexi/a/DCd/meBgIYWhT/eU4y+Wp5jpPxI0TXr/+xNbgn8N+I/8AoHavH9mkd/8ApmzfI351zfx4+KH/AAqvw9Bpugyp/wAJHraf6I38dpb/AMVz/vfww/n/AA16v8SPsHi/w39m8Q+HZv8At5gVng/2o5l3bf8Aer8qvHHiy/8AGfirUtev5fP81/Jg/wCmdtF8sMa/7qV62VYWrjOWnPbrbsfQcH8LZfi8a8ZTi0obp66nJfP/ABtu3fM27ncx+9TabTq/asJCFKChBWSP3UmopqrXY6Toymzl1S//AHFlA4i3t/FIfuxqv/LR/wDZrrxmNp4ak6tV2S3bMpyt01Zy32ObZv21C0bpX2b4b/Zc+N3irRTrVl4Zs9CtQnnQ2mtXDR3t3n/Zj/1P+7Jtrxzxj8OvE3gq+/sfx3oFz4XvLv8A49vtLLJZz/7Ed1D+6r4vCcf5biKvs4ys/Mlwrx96cdPI8PqKtG+s5rSaWGaJomjZlZW6rj+9Wc1fQ4pr1TNoSuMr274K/FC2+H2tT6P4qgfUvBGv7YNWs97cf3Z49u1t0f8AFt++nFeI02vkM5y2GLpuE9+j7F1aEKsHGaumfvBoej+FdK0qD/hGbG0ttOnhSaH7IixxyRyfMr/L97dTdW8beEvDCf8AE+1mz0//AGbiVQ//AHz9+vzb+Eeta94z8GSeG9S8Ta1BYaFth+zW1x5UXkSf6pflG/5fmr0TRfgLDqN59v0S7g82L+K8SSb/AL6/vV8FDh73L15WR+D5rDCYPFyo4iq00/vPqH/hfWm6tN9m8E6JqPiL/p58v7Nbf9/Juf8Ax2qeoap8Rdfj/wBM1a38P2v9zTomlm/4FNL93/vmuBj+DPxFl+Sbx+lp/wBMbCBYquw/s/8AiG8/c69491S7sv8Aniknl1zfVcFS+1c87ER9r/DqpLy3OauNB+Hun3kk3iHWfP8AM/1013dszyf7y7v6V7D4P+LXwZ8PQ/YPBmn3uqXX/UF0u4n3/wDAljUf+PVp+Efgn8MfDP8AqfDtvdz/APPe9T7S/wD5E3V7PazW1in2azgWCJfuqgVB/wB8rXl5tjPb+5DZHpZLSpYV885uTffockvjb4na5/yLHgL+zfM/5efEN7Hbf+S9v50v/oNRXHg34weIU/4n3j+30L/ph4esVX/yYumkf/x1a7dtSuf4G+WqzalNv/1n61839SmfVf6zUvNnmtx+zT8PdVmW58VahrfimVf+gpqc0n/jsewV3Gi/C34aeGP+Rd8L6XZMv8aWsZk/7+N89ZXjbXvGVj4bu5vAGm22qa58qwpdyeXCu77ztyu7b9RXzDeeCf2sfFnl3WvfE+y8Nr/z7aTH/q/+/aJn/v41KVKp6ndQzLD14XnNRXnqfZ8k2+6itreP9x/Ey/8Asq10SskSfO23/e4r4F/4Zr8SX3/I4fFzxLq3/XGRo0/8ekkqnefsq+ANn+k+JPEM/wD12u1/+Irf6lXq25UeY82yzC3nOrdeR9gePPFkOg2H7n9/PP8ALGqqx/8AQa+XtY1TVbnzLy8k8tfvOznaqVxmk/CeHwc7P4b8UaxbK334WuN0T/7y7cVz/jzwb4k1/TZU03W3/wCuLvw//wATX6jwplnsoL2qs3uz8pzjG4LNMavZ1vcffoZE3iCzn1L/AIlv+kr91pv4W/3a8J+KWg6xBc/23ct5kE//AI5UH/Ff+FX+zTQfd9t3/j1ZPiTxp4h1Ww/s3Uo1ii/3PSv3jAZbONp0nddWfqOQZFPC4pVMO047N9bHmjVE1TNUkdncz/cX/IoxeHcrxSufqHN8jClr9SP+Cb/iEyaH468JvJ/x63dpfxp/18RvHJ/6KWvy4k/ir7d/4J8ax9h+NGsaPj5dU0Sb/vuCaOQf1r+V/Eehop22dj3sFL7J+0tFFFfl51BRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUU1qYzVZEpCNVVqlZqrs1awRzVXcWmUzdRWljjqE1FR7jS0zKQ+o2qSoWpIzZxvjjVv7D8Ja3rH/AD42c8y/7yxnbX5ieHYXTTfO/ik/ir7k/aQ1z+zPh7c2EP8Ar9ZuI7Nf9zd5kn/jq18c29v9ms4rZP8AllX7BwFheXDynbdn57ncubELsihcVP4D0/8AtDxJe6l/yysl+zp9fvM1UdUuPsdnc3P/ADyRmr0f4d6X/ZnhW2eb/W3f792/66fNX32LfJS9dDPAQ5qnodHqFwkULV8865Z/8JD4k86b/UWnyr9T96vY/El8kFtJXyd4s+IX9mJLbaav+lT7vm9M162Q4Xlg6m3mdc4urVVNbnRa43/CX+KtL8GaVH9pitNu7b/f/wDsa7/41Xdt4Y0e08K2bf6qH99/n611P7MfgF9K0S78f69H/pt9v8nzuyf3v+BV8yfGbxU+ueIb65/57v8Auf8AcHyrXlZbiIY7HuUPgh17s9avS5eXD9XueDzb5d03+1VNvkSrszf8saz5m/2ttb4/FcsJV56X0R9PRKirM7/JVxbWb/nqv/j1XtPs/wC0HW2sIri9nb/ljaRNK9eoaV8D/iprP/Hn4ZuYIm/ju5Ybb/0Yc18XhauC+KU22+iOic36Hk6283/Pdf8Aviu/8F+F/EPiPWLbTdH1S2tpZf4vL+4i/wAX3K9b0/8AZZ8YS/8AIw67pGif9tWuX/8AHdqf+PV9R/C34B+FfBjxal/b9z4gvf43WRYoOP4PJXd8v/Aq83PcVS9g4YVS5ns2FCrT5+ao9FudP4L+Cnjj+x7f+2vjh4qH/Ttpcv2WNP8AZ+ZpP5V7d4f8J/2H/rvFviXxBt/h1a/W5T/vlYY6s28mxFjT5VX7q/dC/wC7W3brvr4mhlkaXx79zOrj+b0NSFa1Yqz4VrTjWnVObnJVWrNNjWpa4pSL5w20+ilWsrhziUyp/LSjbHSuSf/U/OzcafuNRUxvkr9ljhb9D5KxOy1TkZ6Vrj+CtvTdLff503/fNezgMrnL5BOapRvMg0/RXnfe7fLXZwwpAuxPl20+NUT7ny0vl17nsIx9xHzeKxc6z1ehPRUK0+o+rnASfdqNvnop9VDD8vvBfzDdRTNtKq11xiA6pI1pyx05o3+4ldmFwUq8+RaE+0K8kzt8iV3fhfwv9sdbm8/1S/erN0fR4UdZrmup1bxJbadYLYWC7p5P7vy19nhcP7JezpLV9Tkq4j2rcIPbc2PFnjCO0tv7E0dfurt+T+9XUfDvwemh6bJ4q8SfLdSfPCjfwVnfDvwPDs/4S3xJ/qovmhiYff8A9quuury88S6kv/LDTo2+WHucV5eLqw1w9DRLd9yef7CVzuPC9j/bN42q3X7u1/gWvnz9o74mf2vNH4D0uX/RbHb9p2/dyPux16R8SviRbeB/Df2PTWVtUu12QJ/c/wCmjf7tfCM001zNJc3MrSTzsXd25ZmP3mrLIsheLr/WKq0WyPs8thyUkVdpqWOF5XWFPmZsKv8AwKlaPZXaeA9N+3a9BI6/urb99/3z92v0mdBQg59EdGLxSpU3UeyVz27Q9NTStHtrCP70afP/AL5+Zqtxx1Oy1LDHXy1WHNd9z8Lr4hzm6k3dvUkjhrVjjqvHHWtaw75lrxsRoePXncvRx+VZt8v3q+2v2ffDf9leD4tSuV2z6k5n/wC2f3Vr5E0/T/7Z1vTdBh3ebdzpD/3197/vmv0k0Wxh0/Tbaztl2xW0KIi/7Krtr8d8Qsy5aSw8d3qz7vgjAc+IdTdLY3KKKK/HT9hQ9asVXWrFZSPRw8Ry1MtQrU1ZSO6I6iiioNQooooAKKKKACiiigAooooAKKKKACiiigArzb4wagNL+FHjjUP+fbQtQf8AK2evSa8k+N+n6rq3wl8Z6RolhLqWo6lpF1aQW0GPMkedPL2r+da0P4ivtcmezPyn0XwzN/ZtlD5TfuraPt6R1ux+FbqfyLX7M372ZEX/AHmbatfS+j+DvHxtobOy+HOrQbET97qN3ptrHwu3/lnPO/8A45XTQ/BT4u3c9tceb4a0b7NPHMn7y7v/APVtu2suy3X9a/oWp4j0IQ5L7bH4LX4UzKrVcrbu5X0P4b63p0kb3M9vEu1fu/NXokOlvYw/6TOvy11MPw08bXO3+2fHrp/saXpttbf+PXH2lqs/8KW0q7/5DfiLxDq0f/PGfUGhj/75tVhr8xxfFXt3ebv6HfgvDidK/Joefw6fNqFz9oufmiX/AFP+7/eaujh0Ozf/AF0aNur0zT/hx4M0pNlnpMK/75aQ/wDfUjMa6BfD+jxfctEX/dFcM+If5E0j0aXh1P7bTPL7PS7a2/49oEj/AN1a1/Jf/ervxpFmn3I6d/ZNn/drz55upHdDgmcFyppHn32f/ZpPLuU+5Ltr0H+yrX/Jo/smz/uUv7Sh2OiPCNXvY4qO+vIvvyVcXVn/ALy11TaTZt/yzWuO17wHHqv/AB56tf6X/wBejx/ykR6mOKpSfvKxpWyTHUoN03fyOIb4pQ2PiGTw9qVi/byprf8Aeq/975eq7a8++N1n/wALD0GPQdK03Tp5ZH/4/tSj3fZU/wCnbb8+9q7+HwD/AMI8k9zc6ld6zdSfenu/L34/uqsaqtcFdalo8ly1mmoQeev3k3qH/wC+Wr6PBYPD1ZqcOh+RZ3xHmuBvQxHXbyPF9J+Ffi3Q7OOHRPibqmmy/wBzy1mtv+Axyv8ALW1Nb/HLQbOWa28TaJ4iWD/n7t5LaV/+BR7lrurqz3/P9p/rWdHpf2t1Tz9u3+GvpvqEZe/zH5zPjPF83JUgnfucT/wl3x+2fufC+kyS/wDX/wD/AGNXbXWv2ip3/wCQF4cj/wB68l/9lWvT1vLaxRUknX5flqwviDTYNvnX0Me77qs6q1clXDnoYXiOhtOkk/meefELXPGekfB/xbqviSOwtr2PSZ0/0B5GTfL+6/5aY/v1+PsX3K/WL9prxFYS/A3xNDYXcM8s/wBkh+R1b5Dcpur8oK+w4Ip/vZ6bH7z4fKH1KVSHV/cFOptFfqEJH3JZhXe+z+9X6O/sc/Dyz8T+MNS8Zatb+dpngbyrDSYpm3Rx6lMvmXk3l/314+f6f3ePzmtZEimid/4a/Rn9h34mado2u+Ifh7rVyltL4luY9U0nzPl8+fb5dzDu/vbVTav+zX5z4q+1lgo8mqT1NMJ/G97tofqE3+srn/E/hfw/4y0S78P+JLCLU9MvUMcsE65Vv/iW9G6itzduqrqGoWelWdzf386W1raRPNNK7bUjjjXczM3+yK/nQ9KNV38j8D/jFon/AAifjbX/AAJ5/wBtj8NXr2ltdyr/AKTLbbfOj85l/wBY0anZu/yPEmr1v4m+Krbx74z8TeM7eNre11/Vri8tt/3/ALN/q493+1ha8mav6o4YpVI5bT9rvY8v7TsRU2nU2uqaND6S/Zdt7rVfiLP4bSfyINSsJd/y5/1H7xa/Q/UvCPjBLOLTfDes2miQfxzpA0szf99V+eP7Jdwlt8bNP3/xWd6v/kGv1bmmhl+4y/nX5dnOIqe3lT6I/CfEihShmEK/Wy+Z4/Z/CO8lh/4mvjbW72X/AGJfJT/gK1pr8F9Bd1+0azrVyv8AckvZAp/75r1+12Ve3R14FXFTPncLNy9+/wBx5BN8F/BMqfuVu7K6/huYbu481f8Aa3M+KztJ8D/Gnw5f/wDEk8bWGt6X/wA+2uQSean/AG2i+Zq9s/1tZmrNr0VhL/wj32b7f/yx+27vJ/4F5fzVyVby6no4fFcnxq9+4mn6H4qvIZP+EgvrS23fd/s0SZH/AAKbP/oNYVx8O9edv9G8Zakv4Rn/AArmbH4wTabf/wBiePtJn8O3v8Fz80thP/1zm/h/4FXc3HjKGJd6fvejKy8hg391v4qVKhXfwmWZYvAYdc9VWv17mLD4V8baenl/23DqC/3rmJg//jtX/wCzdSi/1zJ/urS2PxAs57z7Hcr5Erfc3/df/daum/tSwn2/MvzV3f7RS92aPC5MDiFz0J/ezAZZkT7y1yOvfuofnb71egXHkun3q4/WI7bY3nfd/hruwFX31ofOZ5RnGm43PEdculgj3yL8teM6542+xuyWcHmt/tdFr6A1LR7PU/kf7teE+NvDOm6Zu+zS/vf7tfreQTw85qM1dnNwpPCzmoVFd9uh4ZrnijXtQmZ7mf8A8drzrXNSmuE2TKrf7WK7nVLeZN37qvM9Wjm3/Otfs2AoQSXIrJH9JZJSp6ciSSMFqTc/96nMtR1GI+4+xRiy/fr6N/Y91j+xv2j/AAgP4NQ+1Wb/APbW2k/9mr50m/1zV6n+z/efYfj38PLn/qO2Uf8A39k8v+tfyd4hUP3E/Jn0WE+JH9FVOptOr8VhK8UdoUUUVYBRRRQAUUUUAFFFFABRRRQAUUUUAFFFNoAYzVE1Oam1ojKoQs1RNUktR1vE4arIqKdRWpzSmNpy02pNpqJGdxaikqWs+6mRUaqhG5hXlaJ8XftIas2p+MPDPhW2b5bJJL+5/wCBfKteNXHyVuatq3/CVfELxX4k+9FHc/Yrf/rnB8tYd/s+av6G4ewXsMNCl1tr6n5tiKvPUlPucjq1u+q3NppUPzfabhN30r6Cuv8AQ7OC2+75aBf++a808A6b/aPiG71Wb/UafD8npvNd7q10j+Y/92vQx8+aqqXb8z0sL+6pufVniHxQ16HStNk3tXgPwj8B6h8VvH8cO3/QrZ1nuW/2B/D/AMCp/wAXtam1XxAulW37zy8LsTnc7fdWv0a+Avw3sPhl4Gg+2R7dUu08+7f/AKaMv3f+A1pxnm/9nYCGFp/HP8D6PI8LClB4mfUzvjN4gs/A/gNtKs/9G8+HyU2/7vzV+S+qalNfX8l4/wA3zV9e/tPePH1DW202H/VR/Kvzf99V8dSeSsP96uvh7BfU8vjTtrLVmGVOVWpLETW+i9CjI38dbXhOz0SfVftmvf8AHlB8zJ61ztw3yVVjWvJztRrzWGkrpbn08Y+47Ox9OL8dv+Ectv7N8E6Xb2UH+4sf/jq1wmqfGTxzrk377W/sSy/88f3S/wCNeVVc02zS+v7az8hZPPcJ+dbTo/VKDlh4pWXU54YOF9dT3PwP4N/4TbUv+Jr8QdL8r/njNqHlu/8A3+2V+nXgv4f/ANh+HrRNHlgu7KOEfPbMskf/AAFo9wxXyl8Pf2Y/g/4j8PQXXifT9WtL2f8A543G3/44v6V3MP7Jmg+HJX1H4U/EXxF4Tv8A/rosif8AAvJ8hmr8Ux+ZY+vU9p9yWx6M54f2fsrbbs+p4dPmi++tbFvC618v2uvfta/D5v8Aie6bpfxY0T+/bMtrqGz/AL5T5v8AtnJXs3gr4u+HvGF0mm3mh674T1b7n2TWdPmhR5F+8sdyoaJvzWuOOaVL8lRWOX6rCS5oO56hDHV9VoWOrca0p1TjBVqZVoVasbTXM5lkXl0+nbaNtZ3Abto207bRRcm5/9X84fORKhabzfuVDXTaXpuz/SZvvfwrX9S4PKFufNVZwpRvIk0fSU+W5uf+ArXUKqJTY1+Sp1r1PYcvuxPlMViHVm3Jj6RqkoqPq5xES0/a9OWn1f1cUpENWKRVqVVrT6kZSkJtqXbUka1cjh31tSy73jmnVsRRw7/uVsWdjsffNU1vb7KydY1z7Dtt7P8Af3Un8K/N/wB9V9Jl+XfynHH2lefLTNHVtWh06H+9K33U/irv/hz8PbnU/wDipvEy+RZL80KP8vmf/WqX4f8Awn8jy/GfjyX5fvwWzfx10nibxdc3032Cz/0a3X5VRaxxWN9rfDYN37v9DbEezwtPTV9Wb/iLxRDK66bZ/NH91UT+6v8As1xGteMLDwlZ/ab/AP4+pP8AUwL/AB//ABIro9J02/g0SWbw3pbat4gufub+ETd/E1X/AAP+zjNfar/wk/xgvvtMv3/7OR+v/XST+7/srXgVcfg8JBxqPRdOrZ3ZXSVb95NnxjrF1r3iqa58SXkE88S/8tliYwx/3V3dFrna+rf2gPigmq/8W98KxwaX4c0vC+RbJ5fm+X/u/wAK18pba/T+Ga9WvhFOtDkvsutj62hV5oaaIWRt9e5/DXTfI02e/dfmuW2/8AWvH7WzSeZbbb+9avpjTbNNMsbazT/lmg/+yrTO6sY01Tjuz5Hi7H8uHVFbv8izViNahq3CtfK1D8rnIuxrXUaTa73Z65+3j312FiqWds1zN/yzQt/3zXzuYztEywlLnqeR678DfD/9r+ML7W5l3QaQnlR/9dG+9X23H8leFfAPQ30rwNbXMy/v9SZ7t/8Ato3y17xX818V4/6zjJdlovkftnC2C9hhU7avUdU1Q1NXyzPsKYv8dWFqBasVkz0sOOWlpFpazOxEtFIKWoNAooooAKKKKACiiigAooooAKKKKACiiigApMUtFADdtOoooAKKKKACiiigAooooAKKKTNAC1nXFwkVMvL6GJPvVyN9qDy/cruwuFlP0PmM6zynhoOMXqS6leI9eV+IPDOg+IUaHWtLtr3/AH0Usv8Aut1Wu0a4T7jtWHcato8Fytn9rRrqX7kCHzJW/wCArlq+lwsPZH4xnGKli536nhuqfAnwTeP5ltc6ppH+zaXkij/vlt1bmh/CXw3pSf6Td6lq3937XdSEL/wFdtexW+l31z+8eD7NF/02+/8A98r92rd5DpukWct5f3KQQQLueaZ1jjRR/eZvlWu6WYeepxf2RiJ0/wB4tF3OQh0ews/ktrSGP/gC/wDoTVma14f0rWbbZcxpuX7j7F3Ka5XUvjR4YvpmsPA1td+NL/7v/Epj3Ww/66Xkm23X/vpqx20P4l+Lf33iHV4fCWnf8+miv5t1/wBtL2Zfl/7YrW9HET+O+qPJxmS04JxqWivPc8m+PWi21p8MfElhcXcEcrW8ctunyq8vlSI3yr1r8yq/YLxJoPwu0DQdS8PzXdtp9/4gtpbT7TcyNPeTvcx7dzSSb5ZK/IO4tZrG5ns7n5ZYHeF1/uurbWr9H4RxnPVlz7s/SPDalToYWdCm3ZO6b6kNFFFfpUYn6MS1u6fqnlQrbzSvH5TiaB0O2SKRfuyRsvKstc/T6vEYeniIOnVV0+hMo3+R9k+Ef2wPjZ4YtPsLazpviaCOP9y+twP9pX/tpbtG0n1fdXL/ABC/aO+KHxN0qfQvFuu21po1z/r7PRYvs32j/ZmkbfIV/wBnvXy9upNxr5T/AFByqM/acnyKvPuaWral/ad5JN5SQbm+VE4QL/Cv/AaxmqWoq96doK0dghCwyiiivNqGx7R8D/Dt5rXiTUJrOXyGsrN9r/7cnyrXt8PiD43+B9VWazifV7df4GXzUqD9neHRND8H3ut3+oQx3+rXez7P3WGFflb/AIE7GvoyGSa5TfGvmL/eXmvCwtW0H7SCab6n88cb8UToZrNSpKcEra90cda/tDfF2KFXufhz5u3+JJGFeg+G/wBpSHXEkT/hFNR+223/AB8QIY/Nj/4C23cKrr9sT7m5v+A1F/YttqN59sTZHfr8m9PlfZ/db2rxKuTYSV/dt+h8f/rnh7P9yovo1r953H/C+tHim/0zw7rttF/FN9jWWNP95o5GrvfDfxG8H+L/ANzoOrQXM6rua3+aOdP96KTDrXhi2d5bSeTcx/L/AH1bOayta8F6briLdQs2n6pbf6i9gPlzRt/vL97/AHa8vFcP0v8Al2wocW4eclCrGyfVPQ+nNYm0+5tmtryKG5gb7yTBWRv95WrzeTT9Ns/3OmxfZIl+6iH5P+Ar/DXmei+Ntb0y5j8M+OWTz5/kttR/1cd1/sN/dlr0j/0Gs8LgPYHxnF2KruahJXi9U1szI1DT/tKfI373+H/ZP96qVvqV/aTLbar+4n/gm/gf/gX8LV6DY+C7/VXW5TUHtP8Armisv/j1beofC2/1XTfsb668f+35EZpV84pQfJNnbk/CmMxNJPl06PseQX3xO1Xwg/8AxO/Bet6lYL/y+aWkdzF/3zlWFee6x+1F8LtR/wBFvLTWNLl/vXNn93/vmTdXtMnwr+JWkJ5Ph7UNOuf+u7zRf+O/Otc9efD/AOJGyX+2PDthrf8AsfuZf/HZa8/93Or7SnVS8mfpmHy+EcLGli8M3bRtaNnHaH408G+KtsPh/wARQXc8v/LDe0c//fmTaaydU8E219Mz3M7f8Crm9c8C+AL68+zeIfCDaBqP96DdZS/7y7fkb/vmu70PR7zSrP7B/a13q0Ef+p+38zIn93zF+9/wKvtMrxWJp+9da9UfHZvh8Fgf3mCm4vqmee6l8O/+faVf+BCuBvvDOq6Buuf7NtL6L6c19EXVveJu/d15/wCJLz7JYXPnfLuUr81fb5bmtebVO90dWRZ9ipTUJO6Z8beMNettZvP9G0+Gx8r+4mGb/eriK72Tw2l289z9r/jbtmsubwu8W7/S0+X/AGWr9KnhfdUYdD+k8Fi8PCCpp2sefXH+uauw+Fdx9j+LXgW5/wCeev6b/wClMdcdL99q7P4W2rXfxa8BWyf8tdf03/0pjr+YOPfew9X1PtMJ8aP6S6dTFp9fhUPgR3/aCiiirEFFFFABRRRQAUUUUAFFFFABRRRQAU2nUxmoAiam06m1ojKRCy1FU7VBW8TgqjKKKbVHGKtSUyn0SM7g1eXfFTxJ/wAIl4G1vXt21ra2fyf+ujfLH+tenNXx5+0trX9o33hnwHDJ/wAfsx1G9/64w/LH+ZzXt5Bg/rGLhT6X19EeXnGI5aTlHc8I8P2cmmeHrbzv9bP+9l/35PmasjVptkLV1d5J8mxPur936Vj6Lpf/AAkfiG2s/vQR/vp/9yP/AOKNf0PQqeypOpLZHwdKHM1CJ6R4R0v+w/DEXnL/AKVd/vn/AOBfdWuE8fa1Doej3N/M23y0LV7NqH9z+Fa+NPi1car4z8W6b8N/Da+fe3twm/2/+xWvMyecJ1XXqvRatn0c8H7Waoou/sv/AA1m+IXjm58fa9Bu0zRpt8PHySXP8P8A37r748da1baNol3eO2yKCFmq/wCBfBdh8N/Aul+FbP8A1ttCvnOv8ch+81fKX7S3jT7Dpv8AYltL+9n+Z/pXyVCvPPc29t06Lskd/EGI5IRwtL0Pgfx1rU2ua9d3kzbtztXGSNV6aTzfnf7zVl3DbK/bcfKFKlzdj18FQ5IKEehRkbzHq0sdMjX/AMeq5Da+f+7jk8uvhcBha0m6s1ds9KpOK62sVGV/4K6jwbrWm6Hrdtea3aPPBE/8HUf8Brb8K/DvxJ4qv/sei3cH+07p93P4c19PQ/sL/FG7s/Oh8UaF5sq/cdJo/wDx7ya+NzviClrRndPZ9h0qi0nfQ+wPhj4m8D+NdEtP+EM1uy1JoLdFmtkfbcx7V/ihk2yfpXp66bcxffVq/Ntf2Iv2gPD08Wr6LqmifbLX54XsdQkhm/4CzQx/zr2fRfin+1T8JEjsvit8Op/GmmQ/L/aNn+8udn/Xa182Nv8AgafjX5j/AGjUw/uU9V0NcRgqFX372Z9o2qyJXS291comzzG2/wB3PFfOfg39rP4B+LnWz1LUp/B2o/8APHV4vJx/22XfF/31ivpTS5NJ1mzXUvD2oW2rWTfduLSVZk/76jraeY0qvxI4PqE6Xwj46uKtKsOyrCx1hOoQItSU5VqxtNYykBXoqby6Taam5BCy0lT7TRtNFwP/1vz9sdFmim33P3V/u87q6RVpafX9k0ocseU/M8Rip1XzTHLUy1DUytRKJwSJaftqNWqTdWBkFG6myNUdbwiBMtWFqotSK2yuiMSJRLkfyVpx3CRVzs15DAm+Zq6fwj4L8SfEO8W20qB4LX+OfFdytCDqVHZLqTLC3XPN2XcpR6hqur3i6XoNs9zeyfL8lfS3gP4P6b4Ftf8AhJ/GbLPqP3khf/lm1dDpen+BvglpX8F3rP8AG33n/wDsa8K8XfErVfEd5J50vyt91K836xisx/d4f3afV9WR7ZKLhSWn5nZ+NPiA+pzMlu3yr8qbfu1zngnw/eeI9YjT5v8Abb+4K8+tbGa+mVE+bzK+xvhv4V/sPTVmdf39yvzewr0c2rUcrwXJS0b0R4tfmqzUL3b38kepaPYw6RZx2Gmwbfl+Z9vpXj/xu+ID+EPD0qW8/wDp93+5h/H+OvUtc1qw8O6Jd6xfz+Ra2ib2Zmx/wH/gVfEug+F/En7RXjye/m8yy8P2Mn764/55w/3F/vStX57kOEpzqPGYt2hHVvuz6/BYdciWyR494f8ABfifxq93f6bbNLBbbnubt/lhj/3mauZuNPa0vGh3LPt/iXvX3n8dNY8PeAvAEHgnwrB9itY9sXyfxv8A7X96vgf7Y+z/AGq/ZeFM5xGY3qW5YbJdbeZ6kJzlfl22O78E6b9p15Zn/wCWfz17dJ9+vPvh/Y+Vpst5/FO3/jor0Cnm1XmrvstD8t4lxXtcU430Wg6Na0o1qnDWlGteFXkfIV5GtYx7nrpr6H7TZwabD/rdQuYoF/4E3zVi6b9//er0nwXp/wDa/wASPC+m/wANt5t+/wD2y+Vf1r4rPMV7OnKpLoj2Mpoc65Y7s+6vD9jDp2lWlhD/AKq2hSFf91V210FVrePbGtWa/mGvU55tn7thaXJTUAqVaip61izugPqz/BVarC1nI9Cgxy0+mU9ayO2EiQUtNp1QbhRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRTWoAdRWbPqMNv99q5u61x5fkhrqpYWc+h4uPz7D4fd69jpbjUIbb77VzV5rTv9ysGa+8379VV3z/ALuNfmr2aOAhH3pnwOP4prYhuFLRFqa88/8AirmteuteSzVPCumpq+oyOE2zT+RDAh+9JI21vu/3VG6umt9B3vvuZ28r+4vArB8VfEbwr4FeDR387UtZuf8Aj20jS4vtN/L/ALXkr91f9t9qe9azrwj7sDzcLlk8Q3OvojBs/hbrGtP9p8eeJLm9Vv8AmHad/oVr/utt/eyf99Co9c8ffCn4RTReG9PVG1uf7mi6Lb/bdSn/AO2MXP8AwKbbWLNofxg+JH/Iz6t/wrnw5L/zC9Fk87Vp0/6eNR/1dv8A7sC7v+mldp4V8F+A/hpZyWfg/SbfS/P/ANfcL+8uZ2/vT3Em6WT/AIE1cnPWq/5H0Co4LAQ57JPucK198fvHfz21pp3wu0aT+O826prDp/1x/wCPWH/gZaqbfAvwfLcrf+MLnUvHGoxfP52u3TXMOf8AZs12W6/9+69euNc3/cavHPGnxY03Q7//AIR7SrafxB4ln/1Ol2nLrn+KeT7kK/7TV6OFy+Z8tmHEv1i9PDaeaOpvJNH8PWDTTeRp9hZJ/swwxov/AI4teJyeMPFXxPvJdK+He/TdD/5a65cRfPJ/15Qyf+jnrds/hfr3jG5i1v4taglzFE/m22iWny2Fv/v97h/9pq2fG3xG8H/DKG20H57nVrv5bTR9OTzr+fd9392v+rX/AGnr2PrFOEfM+LpZfOdS1Nc8n16IpaX4F8B+Akn1K52XN/5O651TUX82b/eaWT/V/pXxJ+0p8L/9V8YPCsHmeHtZ2fa/kaN45m+7Pt/55S/3v73+9X1lpPg/xb4nuY/EnxU2WlvHJ51h4at5PNggcfdkvZP+XiX/AGfuLXrt19g1OzudK1SNLuyvYXhnt5huSSORdrKy/wC1Xp5fjasJ+1p/8ORgs/8A7IxydWfM3o0nokfhrRXvXx0+DM3ww1j7Zo7Nc+HNQdvsz9ZIH/54Seu3+Fq8Fr9pyrM4YmmpLR9Ufv8AgsbSxVJV6Lunswooor1vaHQFFFFOUgGUypqZXHVRYV0vhHwnqvjbXrbQdKj/AHsv+uftHEPvu3+7UXhXwvr3jPXrTw34btGvb+9b5EXog/iZm/hVf4q/Q34d/DnSvhnbT+G0/e6zLtmu7l02/aP7vkf9Ml//AF18dmWbwlN4ek7vqz5HjLiiGU4R1LXm9keX+IvBs3hiztNNeL/Qo4UhR19v73vVXQfGnifwdN/xJ7nzLX+KCb5kYf8AstfTepabbarZy2d4vmRSrt+avHdU+EdzF++0S53f9MZv/ZWr6DAZvh6tL2OKSt6H895RxXh8VDkxrV332Z3nhn45eFbzbbeIYv7Lvf8AaX93/wABatTxRpf25F8T+Cb5PNj+8iOrb/8Avmvmu40f+xb9bPxbp80EDfx7Mj/vpa9V8P8Awx0efbeaDq93p8U/8dtL8lePj8twuHn7WhPR9DXH5bgMO1VptxT+aZ7P8KfHmg+KoZLC/wBq6jbf6+3cL/nbXtM3hvwxebX+yJ/stH8v/oNfE2ofsy+JILz/AISfwB40eDWY/n/0kY5/66R7v/Qa9B8L/HbWPA9/B4M+P2l/8I3qMn/HtrSJ5mm3f+1+7/1f/Afl/vbK/Nc7rU41eehJn1mC4Zw9WnfBNTXbqj6D1r4a+FfENhJp+pW3mQSe/Of7yt/C1eZWfwd8c6K/2DR/FcGpaR/B/aUTfaYE/h2zRf6zb+Fe727Jd20V5Z3KTwTqrwvC6yRyI38Ssv3qrXH2nZ/o87R/73NeZSxtf7MzCvRoUqbo1aenbzPnK4+FPx78Jal9s+GnibTbuyn/ANdbak8v+s/2flNazeKv2pND8uPWPAul63F/z20m9Uf+Oy17H/aHiSB/kuYG/wB9P/iao3njjxPpT/6ZoTXcH/Pa0k3f+OtzUTo1Zdmeph+JsHCn7KcLW6nP2OufFHxtpUr6PbXPg3VtP+/baxZ5t7j/AHZv/ia85uvjZ8afCL+T4z+HNz5Uf/L3ZrJLD/31Hvr2iH4qQy/f02/j/wBlrdqtN8VrZI/+Qfc/8DTbTpYev/z6THHiTLYX5p2Pny++PXw78e2f9j+NtIn0/wD54z43eW/+995a8t8Vatc6HbSTaD4k3QL/AKlvLWTcle1ePP7B8a/vtS0BYrj+GdP9Z/wLb96vjf4jabqmg2ciW26ey/h/vpX7BwZlFKdoaq+6ex8/h8VhM2xcYU3ez6rRnPX3xs+IUTtbf2lDP/teQq15rqmveJPEs3/Ey1J5P+B/J/3ytc3NcTXL/vvmpqyPb/w1+7YfJsHh1enBJ9z9owWSYbDe9Sgk+6R0VrqCafD9m8zzPm3VUvNc82GRE/iWuZ8yo7iTZC1RisyhChKp2TPThl8Ofmlq2Y7N89er/AGze++PHw5hT/oO2U3/AH6m8z/2WvJ6+jf2Q9M/tf8AaM8HJ/z5NdXbf9sbaRq/kzjet/sU292z6vB/Gj99aKZQtfjUI+4jolL3iWiiig1CiiigAooooAKKKKACiiigAooooAa1Mp9QM1XEylIRqZT6ZWpzykRtUdSNUdWc0wqKpaZVRORhT6ZRQZlW6mSJGf8Au1+depax/wAJj451/wAZ/wCstZZvsFh/17W3y7v+BNX1Z8dPFU3hzwTPbaa23VNZddOtP72+b5WZf92Pc1fLdrp8OlabBptv/qoF/wC+v9qv0/gfAcqeIktXoj4zPsVzVFTjstTHvm2JXf8Aw90X+ztKl1V1/e6k25f+uY+7XCx6e+s6xbaIn/Ldvnb+7Gv3mr6AuI4baGJEXbFEu1V9Atfa5tjOWCoxer1ZhldDepLoed+NNattA0e7v5m2+WjN/wACqP8AZr+Es1p5/wAXfGFp/wATnWfnsoX/AOWEDfxf7zf+g1e8O+EU+J/irZfru0HRnE12v8Mrq25Y6+r7pkVPJh+VV+VVXivj88zf2VL6nSer3PoMBCzdWXyOS1y8hghnvJmVYo1Lbv8Adr8hPjN4sm8R+JLmbd96Y7f9wfdr9Cf2hPFyeHvCslnC3729yv8Auov3q/KTUrj7dftcvX6B4c5Ry0niJLfRHkUZfWMa6ktl+ZztwvlO1ZLfvXq/fTb3qCOH5N9fWZl+/qKlHZbn2tP3Y3e7LC2r/LW5o+k3OpXkFnbR+bLOyqq/WqMPnPGuyvt79nP4OzXjx+IdVXbLd/6nd/yzh/vf8Cr5vibNv7Owr11eiRnSi5z97ZbnsvwH+E8Oh2EGpXkf3fu/7b19bLI9Q2tnDZwx2dsqxxRrtVfpV1Ya/CY9Zy1b3OTEVeafuaLoh6zTf3qu28jp/eqFYaurHWVWUewqRyfiP4bfDrxqn/FX+F9N1j/ppc26mT/gMy/vP1rz3Tf2Yvg1oOotq/hXT9U8NXjf8tNJ1e+tf/QZK93jWrSrXm1aEGejSrzj1EjXYipuZtqhdznc7bV2/M38VWVWolWrS1EtDGUgVakoorMkKRlpaY1ADaKKKsD/1/iKmVFuo3V/aB+XWLG6jdVdWp+6gOQl3VIrVW3U7caBezLW403dVfzKRmpxiR7MueZspbeG5vplhs42lllbaqquS1T2emzTp50zLBB/ff8A9lX+Ku50/wAZW3hKFk8PWkP23/n9dPMk/wCAbvu10SlyJyirsxc7S5YK7PQ/CfwPs9Otv+En+KmqJpNh99bTd++k/wCA1ueJPjpo+mWH/CPfDfT/AOz7Jfk8/wDjP+0q/wANfOGteINV8Q3LXGsXL3c7fxTPurOhjT+7XHSyieJmp4qXN2S2Q6sOb4zobjUtS1WZrm8keWWX7zO2TVm1sXf56Zpti89eteC/Cdz4h1KO3hX91953/uivr54inhaTnPRI8LF4jllyQWp2nwr8E/aZl1KZf3UX3a9v1DxJpumahaaDZ/6Tfzt/qV/5Zp/Ez/3a5vxN4ktvCWmweGPDa+bqNz8iqnUH+9V/wb4T/sO2a/1L9/q1780zt82P9mvyTNcU8VN4mvonsu5NCnyvlW/VlrxJ4D0rxx9k/wCEkknltbRt/wBkSTy4nP8A00VfvV1EK6V4e0pdK0e2SysoF+VIVVR+lPaTYled+Ltc+zWE77vuqa8fD0JV3GnfTt0Pfpbanx/8ePFH9ueKv7NhbdFZf+h14hGvnv8AJ/Ew+WtPVr7+1b/UNSf/AJbzfLWh4L0/+0Neg3ruWD983/Aa/o3KsPDB4VW6I9uc1RoOb6I950uzTTrCC2/55RitBahZqtx18xOpe8pbs/EcRUlJuct2W4a046oRrWxZr8/3a8nFVTzJQ9pPlN/S4f4/vV7z8B9N+3eOdf1T/oF2Fpaf8Dn/AHrV45p67/kRfvbV/Ovpj9m+z/4pvW9b/wCgtrd2yf8AXO2/0df/AECvyjjjGuOFfnofe8OYC1SMex9LKtPptOr8NP1iIU+mUVBvAmqWq9SK1Zs66RPUq1XWpVrOR2wkTU6mrTqyOtBRRRQMKKKKACiiigAooooAKKKKACiiigAooooAbTqyNS1TTdGs5dQ1W7hsbOD5nuLh1ijTty7YFeRXn7QXw43SQ+H76fxNLH/0B4GuYf8AwK+W2/8AI1bUMPUqPkirsxr4mFKDnUdkj3Kq81xDF99q+dPB/wAeH8T+Kv8AhHrzQH0aCe3ea0ne6juHkeP7yyLDlI+OnzNVfxF4s1LSvEkj3ly09nL/AKmFea9uhw9iHUdOorO17HxWccdYTDUvaU3dbX7Hut14is4v9T8zVxmpa9c3PyeZ5a/7Nefya9c322a2tplVv7y7atxtqTpvmj+9XqUMnhS+Pc/Ocx4yr4vSDaXka7Xib98krtUv2zzU/c/erB3yf3KkWZ67vq58nDMPed9TprOFG+e5krUvNa0rSLZprmVYlX8Wb/ZVV5Zq4qSSbZ97bVJm/jm/eMv97ms5YL2vxM7aXEPsFaEdX1ZdupvGfi3dDDO3hLSP+eqbZNSlX/Z3borf/wAef/drb8O+HfDHgyGRNEtEglufmubhy0tzcP8A3p5pP3kjf7zVirrEyfJ8tVpr55U3zfL/ABfex8o/3qx/sv5HZ/rX7nmdVfa8+z5PlribjVN7/e+akmV5aZHaonzvXq4fC0qSPh8xzjF4qfLfQq31nc6rZtZpdy2Sy/fa3O2XH8SrJ/DurOs4fAHwy0q51u8+yaFYRf8AHzc3J2/P/tSN88jN/wACZq8Y8YfHZ/7e/wCEG+EGjP428VfcdLf95ZWvr5k38W3/AHlT/pp/DW14P/Zl1LxLqUHjP9oTVv8AhK9Wi+eDRUf/AIllp/s7Vx5n+6u1PXfXm43Md4U9WfccPcH10lVxkuWO9urK0PxE+JfxwufsHwXsX8M+F/uXPizVIvnf/rwt/wC9/tf+i69J8M/DnwH8HbOe/sFe71m7/wCPvVr9/Pv7p/4v3jfdz/dWvX9W1jTfDWlbEiitorRFSGFEVUQL91UVfu14ZcR6x4nuW1K//cWX8O7pj/Zqspyv2v7yrsZ8YcVQwtH6tgla+5YuPEF5qrs6L5EC/wAq5rWvE0Oi2ctzfz/uolP6VJcXUKP5Nn92vD/FF9ban4503wxeSbooFN7Kn9//AJ4r/wB9c1+l4LAU30sj8QyzB1MxxLlVbaSu7djoNJ0v/hI5pfEPiq282K5Xbb2k3zJHC3+y3G6T+KvDviV+zf8AvJ9b+G7fu/vvpc7/ADj+95Ejfe/3W5r7C03R5rn/AF37uJabrFv/AGdbL/tNtX/gVVVr/vP3bs12Pocn48x2XYj2mH+B6W6WPyP1LSdV0O5+x63Y3Gnz/wByeJom/wB75u1Z+6v3At/Duj6voK23irT7bWYpPm2XkSzJ83/XSvlfQ/gL8KPiR4/8aTW2jTaX4e0KaLTYUsp2iR7yNd1w38Xt8tc1LjCvRbhON0up/Q+Sce0MZS9pVg4tK7sfnTuNN3V+ml5+x38L4PNmS71bbGu7Z9oU/wDtOuU039nP4V/adk1teXe3+F7th/6Ci169HiydRNxhe3mGN8Scpw38Ru77H57M1ez/AA3+Bfj/AOJc0VzZ2n9kaQ33tSvFaOP/ALYr96T/AID+dfZ3ir4Y+DPAHhuLUvB/hSynurS4S4m+0J9pcwx/6z5pd5r2HR/E32uwtryH9/ZTqjf7qf7NeRmGa4vFU/c0XkfL5t4s04UlUwlNtNtXfRk/wn+E/hL4UaJ9g8Pweff3O37XqMw/0mf/AOJRf7i12+taLZ+I4fJvNysvzJMn343/ALyN2q3HH9ptt9tLtbbuR1+783/stQW95Nv+zXEfkTr/AA9j/tLXxsIcvwbo/PswzieLl7TEat9TyBvtmlaxFoPiD93Pc/8AHhc/8sbv/Z/6Zyr/AHP4u3pWnqmg+Kltt+jwWzf7DOwr07XNB0rxRpUulaxF5kUn8XR0f+F1b+FhXk1r4k1XwZqsHhLxhL5nn/8AIO1L+C6H92b+7Ov/AI9XqUMyqS93qeHiMhpP99TV7br0F0fwrreuQyQ+J1toIJfvQqnmN/uszVDefs72G/7f4M12/wDDt1/sv5sH/fr/AOvXoMmqTeS15YRfaWVd2zdjf/s1veCfG2leIU8mHdbXsbFLi2m/1iOPvVnj8bio+8n8j0eF8VT53CGif3Hzqtr8cvAGpQf2xbW3iLRvO+e507/XIn99oa9P1LUvDfiHTZdB8Z6bDqWl3P8ABcR7v/Hf4W/3a+hbixhuUrzzXPCtnP8A66L/AIEtcGHzKlX0rr5ns8QZbicPNYjBpRtvbqfNNr8PfiF8Lv8Aid/ArVv7b8P/AOum8L6pL5if7X2Wb+Fv++f+BV6x4B+NXg/x/ef8I3eQXPhvxXB/x8aJqi+VPv8A+mLN/rf/AEL/AGaq3Wi6loM32nTZ/wDgS/8Asy1h+KtF8GfEiwjsPHOn+Xe23/Hpqlv+6uYv9qGReV/9BqMRk3L+8w7uuxtgOOKGK/2fM42fdbnvU1r/ALNVGV6+brPxd8UfhEnk+LVm+IngiP8A1Ot2i/8AEztIf+niL/lqq/3v/H+1fQXhnxN4Y8baOviHwlq0Gr2HHzW5+4x/hkj+/G3+y1cdPEW92aszqxvD87e1w8lKD6okZa5TxF+6s/8Aer0T7L/s1DeaHbX0OyaPzFr0cPjYQmpPY+UxuTVatOUYbngDNvdq8f8AiZ9jtLaK5m2/e/ir6P1jwi9pMz20/wArfwv/APY18wfGDwX4tnhkeGDz7KP+581fpfD2OpSrxlzWR4PDOXypY+MK8uVLc4VdF0p9t5DbQ7pF+9sWvnfxxa6lZ6xIl5F5cX/LLYPk2f7NfQOg3Xn6bAjq8bQfKyuMc1R8aLolzok8Oqsu6LPk+of/AGa/UsPiKiny73P2rIczqYbGck05J6d7Hyq1U7pvkWrbVQuPvVw59iP9nlHq9D9mpR1RXr7f/wCCfei/2j8aNW1v+HSNEl/77uJo41/TdXw81fqV/wAE4tA/4k/jzxZJH/x+3tppyN/1wjeWT/0atfzf4hVbUo00evhN3I/TBqVaRqFr8yM7+8WKdVen1J0wqEtFNp1QbhRRRQAUUUUAFFFFABTGoZqiqoxIkI1R05qbWqMKgUxqc1R1SMJSCmUUVock5BTKKKDAKrTSfJUkjV518QvF1t4Q8Mahrc3zfZImZU/vu3yqi/7xrpwuHnVqKEFds4MVilSg5N2Pm/4ha5/wlXxIkhT5rDwonkJ6G9nXdI3/AGzj+SuQ1SZLaGR3/hWrGg6beWmlLNftuv7vfd3b/wB+aZt0n/xNcbr0c3iXXtN8GWbMralJunZf4LaP5pG/4F92v3TKsLChTUOkVqz88nOVWpzbtnoXwp0v/Q7nxbeR/NqXyQf7MC/d/wC+vvVr+NNYmghWwsP3l/eutvAn9+ST5VrvJI4dK01baHbHFAiqv+yqrWH8JdBfxb4hufH1/wD8eGn77fTV/heT/lpN/wCyrXg4vH258XP5I+lw+H2px+Z7N4H8Lw+DvDFppu7zLrbvuZu8kzfeZq17xtiM9atw1eM/GTxknhDwfd3MMm26ucw2/wDvMvzN/wABr4jBUKmKxChu5M7cyxCpU35HwL+0Z42/4SHxDd21tJut4P8AR4fw+83/AAKvlHUG+zWapXX6peTa5qs947fKtebaxdefeMifdX5Vr+oqXJgMJGnHorL1OfIsK7KMt92Zq/vXrWjXZ9ym2tvsX566TQ9Lh1e/gs5r6DT4t3zz3DrFFGn8TMzVwUasKUHVqPzbPoatW75YnqfwX+Ht5448Qxvcx+ZZWzr/AMDP92v1w8L+Hbbw9psVnDt3bRvZf/QV/wB2vEfgLovwr8Oab/oHi/Qr292f6mDULWR4/wDf+f7zfxV9RR2fmp50P7yJl+V15Df8CWv52z3PPr+LdWb0WiXY6sV7sFCHzKCx1cWPfVlbfZT1jrypVUzzfZjI1qwq0balWuaUrmyH7alWm0LWZoWFp1V6lVqylECajdUW6jdSsA5mptRtJULSVcYgPam7jUW6m1VgP//Q+F6Kip+6v7E5z80HbqiaTZTN1NrWFQqMSZZKmVXf7lZ7SbfuU3zHat4leyNtbdP+W1yq/wC78xqVby1g/wCPaLc399+axaVWRK1iQ6H8xpzXE0/zzNupkbbKrL+9+5V6G1f+Ot6a5vdsZT5YrsSRx7637PT9iNc3P7uBfm3f7NU/Ms7GH7TctXoPw9+GviT4o38F1Mv2HQYv4v79ehOvSwtJ1arsl1OKUJz8l37jfBuj6x421WOw0S0byF/j7f71fUOtalonwm0GPR9NX+0PEF792P8Ajz/e/wB2rHiDxF4b+EelW3g/wZaf2h4gu/kSFPm/4FJVjwL8O7nT5pPFvjCT+0vEF38/qkGf4Vr88zfPfrdqlVWgtl1ZxywqvzRVmM8A+Dbmx3eKvE/7/Wb75vm/5ZA/w16O0m9971HcSf6TsmlXzfvbP7tMm+5XzdavOrPnn1/BEKly/CYmrX3lJsr5k+Mnib7Do8lnDL+/ufk/4CfvV7H4k1ZLR5PObasa/NXxJ4ivr/x74n8mz/1EWVT2T+Jq/Q+F8qu1Va0Wp6uDpc09dEtzg1/48P8AgdepfDmz2Qz3/wDz0+Rf90V5dMvlbrP/AJ5ua948L2v2PR7RP7y7/wDvqv0/MPdoepPEuI5MM13/ACOmWr0NU41q9CtfJ1PhPyaqaUNdRYx7K5m1X98tdlZx/dr5/HzNcupXnc6CzbyP3z/w/N/3z81fXP7Pun/YfhL4Z3r81zbG7b3a5kaXd/49Xxtq1x9m0fUHT7y20/8A315dffvw5sf7M8E+HbD7v2bTbRPyhWvxrj+f7uEfP8j9I4ch+9fkd1RRRX5MfeBRRRQXEfT6ZT6k66ZItTVCtP3Gs2dkCaparrU1ZyOqEh1FFFQaBRRRQAUUUUAFFFFABRTd1G6gVx1FQs1M8ynYXtIlmot1QNJUe6rjAwnVOT+IvhK08e+A/EPg27UeXrdjPadM7JJF/dt/wF9rfhX5i+H/ABprGp+G7GHUmaC9sU+wXcD7V8u6sv3Mi7f4eVr9bI231+THx+8OzfD746a3bQ/uNG8bRrrdp/c+1f6u6Vf9pn+f/gVfe+HtelHHqlV+1ovU+P44y14vAXpvWOolv4qudK17T9V81ma0mR/97+8v/AhX0b42uodTtbTVbb7si7lZW9fmr4W1TUvKjr6J+FvjKHxV4M/s2Zv3+mu8P+1s+9G1fuHEeR8nJiYK9tH6H89Z1l9SlgXU3S3Pe/CfiT+04Ykdv3q/e+tes2sm+GvlK1Z9PvN9t8vzV7p4f8XWE6LbPIkc+37jHa//AAFf4q/M87yvl9+mro87h7O9fZzevQ6m+j+felY/mfPWhcXCS/8AxVYc0yLXj4eHQ7syxEFPnTNPzt9YrapbSzNbJOrSxfeX0rzLxZ8QH+0/8Ix4S/03Vp/kfbzHb/3mZv8A2Wr1joqeGNBl2N5+qTqWaa5P/LZv4mr0o4SUUrqzeyPn8fipqKk3a/5HY+IPFXhjwZpX9veJ9STT7KP+KZvvn+7Gv3mb/ZWvI9PbxD8ZNSttb1iC48N/DmxmFzBZzfu7zV3j/wBW9wv/ACzt89F/i/kzwz4B0q51uPxD4tnfxTrn8FxfqrQW/wD1wt/9XHXqfjr4keD/AIb6VBN4kn8+/uf+PTTbdPPvLp/4Vhh/9mb5a8jH0p0tajsj7XIsVh6v7rBLnn3tsaura4ltZ3eq+ZDp+naejS3N5efuoI0H8VfO1vH8Qv2l7n+zfDE8/hT4ZRv5N3q+zy7rVNv/ACzt4/8Ann+n97/nnXceH/hb42+NOpW3ir40wf2F4XtH87TfCMTf63+7NqLfxN/sf+gd/sGztbPT7aKzsIEtrWBFRIkCqiIv3VVV+7trxcRmE5+5DRfiz7zJeHMPgZ+1qe9P70jj/AXw48FfC/Qv7C8G6XDp8Hy+dN96e4cfxTy9ZG/yKt+IPEltpHkW3+vv7v5ba0h+aSUj+6v+z/E38NY/jDx5Dot/aeFdBg/tvxbqil7TTUP+rhX711dN/wAsYF/v/wAXSPcaueGfCf8AYfn6xrdz/aniDUP+Pm9ZNu3+7DBH/wAsol/u/iea4qR6mZe0q9bX6nKXWh3n/Ie8SfvJV+fyesdv/u/3v96vMfEnjD+0f+JbpsibW+8y19I6hNDsZH+b+9Xyh4w0Gz8PaxJqVtsgsp1kmb+EReX8zbmb7q195w7VhOf73pt2PxPibK+Sf7h3vv3Zi69r2m+E9En1jVZNsVt/D/G7t91V/vM1bnwt+F9zYvc/EXx5B/xUut/Ott/z4Qbf3cH+/j71cB8I9Fm+L/i2P4ha9A6+CvDM/wDxJbZ/+Xy9X/l6b/Zi7f7X/A6+iPGWvbJvsdm3+/XRiMfUxVf2dJ6Lr3N6+X08iwDhPWrNa+XkYF5ceRMyQ/3vlrDkjubnWNLtrlflkuC/4Rr/AI12Wk+D7m8hg1K/uWi3fvti+n8NU9FhTU/E99fw/NBpu23t/wDf+9I1dX12HK1B7bs/PMPklWDVSorX2XqdJ4gvo9N0S5mf935ELt9MLXE/AXRX0z4dW1/N/wAfWu3Nxq031uZPl/8AHAKtfFq8+w+BdZdG/ezwfZ4V/vNL+7r1bwrpKaV4Y0nSoV/48rSKD/v3HtrwcVPlprzP0nKqU3RnCLtd/kVZt/zf7VeR6ppM2+e/01dyxMdyr/6DXttxa7K5vQ4dj3v+1O6104DG+yi5rU+XzfAOrWjTfU80XULbU9Nktrn5ty7drf8Ajy1j/DVbbSPtPhKb/VWzs9tu/wCeMnzf+O9K3tc0uGxv50h+63zbf7u6uca32TQXMMnlzwN8jev95W/3q+n9lCrSfI7X1PlaGLlQlKhPbt5nrdq02i3i23/LhP8Ac/6Zuf4fo1dTJDDeff8A+A+qtXmlvq013bfY5v4l/irqNJ1KbyY4blt0q/LXzOKwc9+p72VZlTl7j26X6FfWPGXhvwxqul6P4h1L+z7rW2KWbTIyxvIv8PmfcVm/h3Vd8VeE9H8X6PPpWsQebF/3y8bj7rK38LKaoeNvDvhLx74b1Dw34t2fYrn/AJbb1V4HH3ZoWb7rLXlvwa8fX+keJ7n4HfELUobrW9NRP7D1L+DVLLb+7/7aqn5/8B58Srip0am1j9Py/J6eJw6nh378d15FnwvJqujTT6DrE/2m6sW2+f8AxvCf9S23/aFdfovhWH/hOoPENtB5ayW7eeyn+P8Ahb/gVY3xi8O6xoN/aeP9Eg8/7F+5u4V/jt//ALGu18G+KNK1zSra/sJ1ZZ/z/wB1q+irYj2tD2lPW6sz4GeUzweN9rLRN6rzPXo1mi/2lqZo0uUqjZ6gkqrV5l/5bQ/e/wDQq+LndS7M/XcLVp1Ye67p9DzrVoXtpmhdfvfd/wBpa801TT4X/wBT97+7t4r6E1TT01Wz/uy/3v7rV5D+5uZp7aZfLurRvJnhb76n+H/vr+Gvp8nzD70fkfG2Q1aNTnjqujPKG1DWNDm320jRf7LfMK8u1Lw7D/bf/CYeANS/4QfxX9957b/jzuv9me3+4yt/u/hX082l2dyjW0y+arfjXkPjTw3pukQtNbXu7d/yxbrX1tKGExsvZVVq+qPL4ezjF4OadOTT27pmx4N/aQttP1KDwr8bNP8A+ES1aX5LbVodx0m8/wCmiyf8s/8Ax5fXbX1isdtd2cdxZzpcwTrvhmhdWR0b7rKy8NXwN4f8ZeG/sE/hX4haNBrvh+7/AOfgbmi/2l/u7f8AZw1dZ4T+HviTwd/xOP2dfHEOoaDI++fw1rkjSW3/AGxmX95H+S/Vq+Hz7IcVgK2z5OjP3fBYvBYyh+8ioT/Bnv8ArGm3kVzJNu3L/d/u15zcb/mR69jt7q/1DTbabVbL+z72RA09tvWURv8AxKsnRq8D+JnjTw/4A23+tyf8fL/JDCu6Rv8AgNe9klWdWSpxjd9D8L4iyGtVxCWETk29EtbnL+LPCtnfabczW3+jXW1v3yDla+WpPh/Zzu39q3Mt7L/v42/8BWvWfGH7Q3hKKwaHw2s2oT3KfemXy0TNcP4P8ZaJ4qvFhm/0S9/uv0f/AHWr9kyGljqGHlUqRaR9hw5l+dYDCOpUi0vxRp6P8MfBkFn9pvNNWf8A33avjXxBNZ3Gt6hNYReRatcP5KJ90Ju+VVr7V+K3i628M+Gbmzs50+1Xy/Z4dv8ADn7zf8BFfDG01w4mc6/xddT9V8OpYurSni8U27uyv2RVkk8hPO/u1+537FnhX/hGP2fPDbyx+Xca21xq0nv58m2Nv+/SR1+KmgeGb7xdr2ieE9K+a/12+itIf+2jbd3/AI9+lf0gaDpNn4e0HT9BsF22ul20VpAv/TOCMRp+i1/PvH+NVXGqlHofsOFjywcu5q0UUV8Wcg6im06oNYyH7qN1MptKxtGRLRTNxo3GixftCXcaNxqLcaNxosHtCXcabupm40bjRYPaA1No3UynGJnKYUUUVZmRtSUUVZgxlMp9Mpo4pSCiioWatDnlIr3Umyvj74sa8/ifxtZeD4fmsNIxf3nvJ/yxj/4D96vonx54ms/DHh6+1i8basCM3+8f4VX3avkPw2t4lnc63qv/ACEdZma7nbv833V/4CK+84Sy/V4iSvbb1Pic+xvNNUk/U09cvIdMs2mmk2qqfe/u4qH4H+Hbm8ttQ8f6x/rdZ/489/3ks4/lj/7+ferhtWs7rx54n03wNZt+6vX86/df+WdlC37z/v59xfqa+nPEmoaV4S0HyYVWCK2hCQovy7dq7VWvr8zxDpUlhoby1fkgynC71ZbLY888ZXF/4l1Wy8DaC3+m6u+x3X/llD/y0dv90V9TaTpNh4c0ex0TTY/LtbGERJ/wH+Jv96vHfgr4Vmghn+IWtr/xMdZ/49kb/lha/wAP/ApK9rmm31+f5zi/a1FQhtH8WfTUKXJBze7Kk0nlfPX5l/tJfEJ9e16TSrCX/R7T/R4f/Zmr7U+NHjqHwV4Pu7nzdt7cqbeD/eb7zf8AAa/IzWNWa8v7nUpv4c1+j+HGR3bxtRaLRHzmM5q9dU90t/U5zXL5LGz+xw/62WuHt4/NffT766mvrlppP4qs2sP8G35mr7vFYr29R9kfZ4fD+ypcvXqbFjZ3mo3MVhYRNPJIwRUTksT91Vr9BPhH+yz4JuYba58fWP8AaksHz3ab5Fj86T7sEe1h8sX8b/xt7Vxv7OPwlfzo/Emqx/6U3+p4/wBQjfx/7zV+gdnDDY2q21su1Yq/I+KM+ljan1eg/cW7XU6X/s8Ltav8DyS7/ZP/AGc9Sh8r/hDfsn+3bXl0j/8Aj0r1z8f7IXhnRsXHw38f+LPB04+dfs955kP/AHyvlN/49X0ZH8laMcj18NVy2Bz08fP1PHPCPgf9onwreRW198TNI8ZaR/1F9Mmjutn+zLbvuz/vO1fQzVkRyVaVq5oYXk6mlXEe16FlqetV91O3VVjMsbqm3VX3U7camwEu40u6q+6nbqmxZLuNN8yot1M3VViCVmqPzKjaSovMpxiWS7qiZqjZqTdV+zJsf//R+DaZUfnUu41/Xp+eWDdRuqLd89MkbZW1Mv2Y6RqarVDG0lw+yGNmrct9FeXa9y3lf7NehThLlNKsoQ+NlD7/ANzitS302aX/AF37pf8Ax6r/AJmm6anP3qwbzXHl/wBS1d2HwsmckZVKvuwVl3Og/wBGtvkT/vqqt5fQxfxeZL/Dt+9UGj+Hdb16Zf8AlhA3/LaX5R/9lX1T8OfhT4Y0XytS1X/iYXv3t7/cT/dWtsZioYSHNJXfbucNarQpTtJ3fZHJfCv4I3/i2aDxD4w/caYvzJB08yvefFHxCfSpoPh78MbGO+1yf5NkI/dW6f3mqvr3jDVdcuf+EJ8DRbZ5fkmuP+WcCf3t1emfD/wPongKwkh02P7Xq13/AMfN2/33r85zrMJz/e4rfpHoiIYj2r/qyKHw9+Ftn4O3a3r0/wDbPivUP+Pm7m+bZ/sx/wB1ar/EL4jf8I5eQeFfDcf9r+K9Q+5bdUg3fxSf3apfFD4qHwh/xSvhv/iaeL9S+5D977Lu+67+/wDdSpfhz4DtvAVhL4t8Wz/afEeqfPPNLy48z/arwowf+9YnW+y7jxHub7/kbHhXwnN4asJLnWLttS17Uv315cv/AHv+ea/3VWtLUrpLOzlmf+Fa1vOe7/fP/FXiXxY8RJY20GiWzf6Rettb/YjX7zVvluHqYmuobt7nNG3xdDwH4neKJpbOeFG2/afm61zXwz01INN1DUpv+eL1yfjKZ7zUo7b/AG9n/stevtYpovgCTZ8rMn8q/dMVSWHwMaUN5HbCdoRj3d/kfN0Mf2nUvJ/56XH/AKE1fR1vb+RCqf3V214d4Rs/tmvR/wB2Pc9e8rXdnM/dhT7I+d4uxHvxp/Mmjq9DVKKtGGvm6ux+fV2a1jHvmrsrX5K5bT4/nrtLOOvmcxlqezlsPcv3KWtL59n9j/5+3SD/AL+tt/8AZq/S/T7eO2tooU/5ZqF/L5a/O2ztftfifw3pv3ludWslb6LMrN/6DX6Ow1+JeIFf97Tp+Vz7/haHvzmS0UUV+bH2wU+mU+g1Cn0yn0G8CRaWkWlrI7oEq0/dTFp9Zs3Q9adTadSNwoooqACim0UClIKTcabTKuxn7QNxprNRTKqMTFzH0yimNVmUpDWplFFamMxY22PXyH+2p4Dm8S/ClfGGlR7tR8D3f9pL/tWrfu7pfy2yf8Br64qK/tLLU7C402/iWe1uongnibo0ci7GVvZhWmHrzoVY1YPVO46U0/cnsz8BptSe5s/tiN+6lTcv41tfDPxp/wAId4tje6bbZX22Gb0Xd/F/wGsn4m+CdR+FnjzxB8Orvf8AZ9PuWezdv+WtlN80Lf7XH/j2a83kkkfb/s1/cuRzp5zlkavSS18mfF4vIYSpzw9RaS0P0/kZLiFbmFvll+ZWrk/GHh2PxPo/mWc722o2X7y0ubdsOko/2lr5z8C/ELUtQ0T/AIRu5uf3tt9xv4tn/wBjXvHgXWJk3W9425a/P8yyCph0+fW3Tufzhj+HsVk1d1YvWL080etfDPXPEOoeG7L/AISGf7TexfJNNs2lmVtvze9V/E1jqUtzK9zfP5G4/KvA/wDHab4ds9STVJ/sHzWVy27/AHH/AIqxPjFqV/o9zY2e3yop0++v8VfIYXCp4tUodeh41quMrucOuvkjU8G3XhXSppLaHZBdS/x9SWro/EEMOpW2y5bz/wCJdv8A47XzHDcbtsyM26vXND1y8e2+zTf6TO33PX/9VevmOSeyn7W5hm+W1aVqkJXfW+53Pw71zTZ9Vk0fzP8ATfubOte3aH8MfB+keIbnxnDpq3PiG7+9qNyWmmRR8qrDu4jX/cxXmnw18J23h57nW7xfN1S9b55v7q/3F/u19G6f+/h37a/KuI6t6nu7H6lwLh6cL+yerHRq6V4v8YPizN4H/s3wh4Ssf7d8d+KP3Gk6X/c/6err+7FH/wCPfTcRv/GH4o6P8I/CTa3eR/b9ZvZPsmkaYn+uvLyT7qqq/NtX+P8AxZa5j4J/CzVvDH9ofE34lXP9pfEXxR+8vJf4LGD/AJZ2Nt/dWP8Aj2/T+Hn46rXv7sN2fsmAy/kTq1dvzOp+Fnwyj+HWl3l5rV+2ueL9dkFzrurzffup/wCGNf7sEX3USuu1jUHT5ErckuPNkrLvoYXTe6rXdhYcvxny+eYqpXg+R2OBuJLmf7m7/ar5J+L02q/Ebxzo3wH8MS/v9Q2XviO7T/l1svlbb+Xzf9+xX2J4y8QeHvAXg/WfGGtskFrpFs9x83/LR/8AlnCv+1I+ErzH9mf4Z3/hfw3fePvGHzeMvHs39pajv+/BDJ80MH+z97e35fwV3YrMtPZwVr7nncOcPeym8bVd2tl5nof/AAjcPh7wxaeHvDEH2S10+BLa2h/uRx/1rjrHwXquo6lB9pVVi375v4twr3i4sfkZ6raXH5U3+01deHzWdKnL2Z8/mXCsMVjVPENtGL4k028fR57bTdqz+SVTttNcjpOjw+GtHjs93+qXc7f7TfMzV7FeR76828cabN/wjGqTW0nkMsLvu9lXc3/fVYYDF3tTm7Js14jyPlbr0leyPnfVLr/hM/GGl6In7yy/tFPl/wCmcTeYzf8AjtfXa2+2HZXyt8FdN/trxP8A2xCv+i6XafO/rc3P8P8AwFK+vfLr0eI8RD2qp09kjPhHLJ+wbmtWclfQ1xen3VnBeXNn5q/aN7zeXn59jN97bXmv7QnxhvPA+paJ4B8K23n+LfFez7NNMm6C0hkk8rz2X+Jt33V/P0ODazWHgW21b7ZezXMtt/x83Ny26e4fb95m/wBr/wAdq8ooPEJqJ5fFOAlg5wqTV3J2S6nQeNND1V/P17R5/tcX3riBuDtH/PNv9mus8A6Ho9zpUGsfLdy3P8bfwf7O2sP4f6h/a/hLTdV+aT7cnnNu56tXdeG9Ds9Fmb7AzxRT/eh3ZTf/AHlX+GvRxmIqRoule1j5TL8PD60ueGvXyZleLLP+w4f7Strbz4P41Qcp/tVwd14quYNB1C/0exSS9gt3mhhf5Vd1X5dzV77qUaS20sM3zKy7a8Cj03+x/E/2N/mguf8AZz977tPKsQqsGqmrRz59lscPio1ILRtadD53+HPxg1LxPD/bevW0Fz9ku9lxbbP/AGWvsH4hfCbwl8b/AAfp95pU/wDZOt6ev2vRNXtv3b2033l+7/yzyPmX8R81fI114NTwF8ZtQ0RIvL0bxsj3em/3PtUXzTQf733tv4V9a/CXVJrGGfQd3ywfvof91vvf980cQ4enisKqtPdbo/TsvzKhleZ/u4WhUV0Ynwo+Jutavf3fwj+L9kml+PtGT/thq1r/AM/Nv/C3+2v4/wB5V53Wvhvc+Dtbk1Lwld/ZtLvX/fWn3ox/u16n8YfhdY/E7R7a8s7n+yPFuhv9r0TVoeJreZf4W/vQyfxr+NeQeEfipeeL9H1TQfENj/ZHjfQP3Oqad0+f/nvD/sSf+O/lXzuQ16kavJ0PQ49wsK+CliMOtUtV2O90nXr+J44bn5v9qvUtL1rzdsM33q+XfDOuTfb/ALBqrbmky0L/APoS16/a3XlOtt95fvK1fUZrlq+G2p+GZNnlfLqvLUlo9j2j7m10/wCBVxPjTwX/AG9/xONBnXT/ABBaJ+5m6xyp/wA8Lhf4kb/x3t7uh8RJbWyvcttWqVx8RNKsU87a86r97yRlgP8Adr5SOArxnemrtH69/rLl9Wn7OvJWfRnhd54w+zWd9pupQNpuvaf8tzYTfwf3Whb/AJaRN/C9fPepaheaneNc3k7Nur7U8aeDfDHxn8N22veHrlF1O2Vvsd+n30/vQTf7P95Wr5buPhL8SLaGW5vNLjjaLd8iSqxfb/Eq1+p8GZ1hOR+3aU/M8CvwzSwU3Vpap9ex5jN5MqbHWp/CdrrH/CSW3/CPXtxYy7vvw/5+asq+aaxuZLO8geCWL7yP8pra8O/EKw8IJPcpaefet91mPC1+p4zDzq4d+yjzN7I6PZV1TfsFdvbsfcMfiCbTdBlvNYk8+W2T5327fu1+UHxW8Yal428YXupXk/mRbilumfkSJfuqtdT4++OHjbxP5um/a/s1h93ZDxn/AIFXhyxvK/8AerTgfgmeAnLEYhLney7I+74M4Zr4O+IxTTbWi3sR1LDM8D70Zl/3eKJIZIPkeom+RK/TuX2fvS6H6FpL0ZFqV9c3k3+kyNJ/vHNZm2pGamed9mhluf8Avn/f/h/75r8bzvHwjz4ib0X4HoUaVkoJWPuf9hL4dJ4k+LOpePZv3uneDbbyrZv795dq0Yb/AL9+a3/AhX7By18x/si/DR/hr8GNFhvYPJ1XXD/at9677j/VK3+7FtzX001fyBjcV9YxEq0urPYr+7BRJKKKKxOYdRRRUFhTadTaDRBRRRVjCiiigAooplABRRRQSFManbjUdWYykFFFMagxnIRqjp1RNVROKUh9U5pNm56lavJfi144j8GeGJ5ofm1G7/0e0T+JpW/i/wCA124LCzrVIwgrtnl5hilSpubeh4N8XPEH/CY+KovDFn82naM6vd+kk38K/wDAa47XtWTTLCSZ22+Wv8lqppNr/ZlnvuW8y6uWM07/AN52rItdLufHfirT9B/5coH8+8bs0cbfLH/wKv3fBYKnhaSX2YrV9z4ClSnXqc73Z7J8F/Df9i6Dd+OdbXyr/XcTf9crWP8A1Mf/ALO3+9VDT7eb4u+PPJ2/8U5o2Jrn0k/ux/8AAv8A0GtH4neIpoltPA/h75r292J8n8CfdVf+BV7Z4F8J2fgTwxBo8O1p2/fXL/8APSZvvNXwGPx7jev9qW3kfd4XCrSHRb+Z2U0iKiww7VVflVV42r/dqo0yIm+oZGrxD46fESHwJ4PuXhn2399/o9t/s5+8/wDwGvDy3ATxNWNCmrtsrH4jlTe58gftLfESHXvEklhZy7rLT826emf+WjV8Ta5q3m/6HDV3xJ4gub68nmeTdurk7W1mvJq/f8yr0sqwkcFTeqWr7CyfK+T97U3eo2FvK+evXPhjefD2x1uC88f6l9mtY/4IbWS5f/yH92um+FPwjufGepQPNbboP4IW/j/2m/2Vr9Wfh/4F8N+AtHj03R7GGJvvTzbF3yv/AHmr8kzbibnhLD4fruz6r2VrTnp5HkPhT9on9mnTrH+ytN8W/Yv+v2yuof8Ax7y69Q0X4r/CXxC8UOj+OtCuZJP4PtsUT/8AfubY1ei3Vj4e1VNmq6Np2of9fNrDL/6MSvOtV+AHwF8Qc6j4A0iPdn/j0ia0bn/r3MfzV8ND29L3YGOI9lVnzTZ6pZ2qXdst5ZyJdwN8yywusiY/3l4qz9l2V8sXH7HvgTT5nv8A4Y+KfEvgK/8A+odeNND/AMCVtkn/AJFrV0nS/wBrXwJc+TNqmgfFPRv+nt/7M1PZ/wBdNoT/AL7Z6n67U+2jKOAp/YZ9JRrVqud8O+ILnXrR5tS8O6l4XvYMebaakkXf+KGa3kkilX/gX4V0W410qrzrmRzyocj5ZD6KZuNG40WHYm3U7zKq7qN1LkHYs+ZSeZUO403dRyBYseZTKr7qN1FhWJdxqLdUTSVC0nyVUYFRiTtJSeZVPcabuq+Qqx//0vz63VYVqp/PVxa/sGUD4SaF+Sp18n771XaqbTJXZh6EWKMOY1f7Uhg+SFarTaxcy/cqC10u5vP+mS/7VdPb6fpVj++m/eMv9/8A+Jr36GFj9oirKlS6XZzlnpOpak//ALM1d9pui6bpX7652zy/7f8A7KtZ7a5Cqf6Gv/AulFneQ3M3+mT/AMX8PP8A47Xu4ehp5I83F1a9VPSy7Lc9B03WHuX2WcDS/wCyteu6La+NtchWw/5Bdh/EyffxVz4c+C5pbZb97JraJvu70wWr6Hh0ez0awbWNbnh0vS7Zd009wdoC/wDAq/P+JeIKEZezgk3+p81g8F7Wo5QjoY/g/wAM2fh6zW102La0n35m+/If9pq4H4nfGSHwvN/wivg/ZqXiif5GZPmjtN397+9L/s15X8TP2hJtX83wx8Nd9pZf6mbUtu2ST+95C/8ALNf9r71W/gf8N13f8JDqXzeR8++vEoZHJU3jsw0XRPds+mnCGGSju+iPQ/hf4Fs/AlhP488Wz/bdcvt9x50/zOj/APAv4mrV0W41X4ka22varI66NYv/AKND91ZHFcf4i165+IPiT/hGNHk26RZf6+b1xXvGh2MNjZwWFnH5cEC7VX6V5uPlOH72p8b28l2Pn6t69Xkb238y3fXkOnWctzM22KBN3+6BXwnr3iK58Q+JLvW3/wBQrH7P/soK9j+PHjhIIV8K6bL+/ufmn2/wIv8AD/wKvnKRvI01nr7ngnJeSn9ZqLWW3oduK0tCJjaDZvr/AItjX73zV9B/Eq3Sx8PQW6f3f/Zaw/g74X8r/icXMf8ArW+Wuh+MjeVpX+6vy/7xr2M1x6r5hCjT2R6MYc15x2Ssjwv4b2m77Xef8AX/ANCr1WuZ8H2f9n6JGn/LWT5/zrpq9DH1eaq5dEfneeYr2uKk+i0RJGtX4VqotaEK15VWXunzNWRv6atdxZrsSuQ0+P7tdpZr8lfIZlPU+jy34Te8I2/2n4neEof7t6834Rwu1ff0X3K+GvhrD5vxR0T/AKYRXb/+Qdv/ALNX3NH9yvw7juf+1rySP0LhX4JepJRT6K+EPshlPplFBQ+nLUVPWg3gWKKYtPrI7qew+paipy1EjdD6fTKKkofRTKKmxQNRRTGqiQptFFUc8gplFFWAUxqfTGoiYyIqKGorU5pyGNQrUjUlBzxnY+C/27/hf/bXhLT/AIqaVBu1Lwzi2vdn8dhK33m/65S/oxr8q6/o51bS9P8AEOl3ug6xAtzYalBJaXMLdHhlXay/8CFfz+/EjwLqXww8ea34E1Lc39k3LrbS4/19tJ80M3/Ao8V/QHgrxR7KrLLKr0eqN8VHnhz9jltPvptPvIry2ba0Tbq+pdB8ZWGp6bE9n8t1/Ev8Wa+TK39B1ibSL+O5hbbtav6NzDK4Yhea2Ph+Icjp42ne2q28z9EPhr42msblba/Vmik/Svb/ABh4R034jeHls/NWC6g+eC4/u/3t31r5u+GutaV4tktLPcsc/G9F/jX+8tfYumww20Kww/d21/M/Fv8AsuL54Llmj8HwsKlLFypuNkuh8kQ/CPxlY6l/Zv2aGS3/AOflX+Tb/OvVtNsfDfgmHZcSeff/APfT1qfGbxZqXhXQYIdKVllvXKeev8AH/wAVXzHoN5c/aft9zI08rN/FzXqYL63muH9rWlZLot3YjNcJOd530/M+qLPVvE+rzQQ+HtEbym/5eLh/k/3q9btb6H4b+EtU8U+P9ZXyLFXu7ufG2OJP4Y4V/i/ur/E7Vxnw51zz7OJNy/L8tdV4/wDhj4e+KsOgWfime5k0nR77+0ZNPR8QXkir+7S4/wBhf7tfk3EbnGbp2skff+GuEw/+8Tep458H/DWvfFnxf/w0X8SLT7JFs8rwho0vP2Ky/wCft/8ApvN/D+f/ADzx9Nahp95fXPnTS7beP7kS/wB71at5diIqJ8qr8qr02j/dp1fMUPdP1XMp/WPc6djnY4fK+SsPxdptzqug6hYWcjQXE8LKjq2GQ/wsprufJRq8o+Nfj22+F/w71HxNjztR+W00u3xl7i/n+W3jVV+9z83+6tdf1zlameE8kdeDpw6nzBJ/b3xp+Ltj8OtYkhufCvw7ePUtb8j/AFd5e/8ALtBJ/u/xD/fr7f8AtHvXinwK+E158MPh9bJrX7/xRrsz6prcv3mN1N82zd/0yHy/72a9RmvIY7qO1eRVuJNzIjHa7Kv3tq/xba2/i++cWZ8+Dth47JWv3O1s9k6VKunw+dvrG026/grpY23151dOMnqfTZVOlXppyV2QyWu+vP8A4geH9b1zwrqmj+HpYYL+9h8iOafd5aeY21mbbzwteoLUbLWVLESi/Q9TGZXTqwcZLRnnvgvwLpXgfw9aaDpS/LAvzzN9+SRvvSN7tXXrDWuse+pPs9TPFNyvJ6s0o5NCMUoKyPhL45aD/wAZMfBPVZv9RqC6hZ/jBH5n/tSvLf2lND1XQNSi1KH/AJBOpQPu/wBmZf8A61fS/wC0L5Vn8QvgZqX/AFN/2T/wKt2Wu0+NXw9/4Tb4da7pVnFu1FbaSa0/67RruVf+Bfdr6PhnPvqddT6dTweI+HPazhVgruP5HzP8AdaT/hANEtryXy4vI/c7/wDZavpjT2hl+eFt1fKP7Kf2Pxx8H/sF4v73Rr+e0/20+7Iv/odfQ3gexv8ASrm70q++byH3I/8AfQ19JmGKpV+apDR9j8Px+W1sJmco1Fo27Psei3kf+jNXBXmmw3F/BeTL80a16hNCksLVxV0qI7R15OArvW2jOviPBbOeqPKPjh4HufGfw9nudB/deI/Drpq2kun3/Og+ZlX/AK6J/SuP+CvxQ0Hxbolp4hf/AES9/wBTd+iTBf3n+6rfeWvo2zuvLfZXw9qGg6b8JPj9Jo95B5Hgr4lf8en/ADyt9Q//AHh/75kFdNGryTcJ7M7qWH/tDBezp/xYarzP0Ijkh1C23wy/eXcrLXxv8bvA+sX2sQePvBn+ieLdA+//ANPcP/PNv7w219A+EbG/8MTNps07XNhI37jd96L/AGGb+Ktrxporz2y63Yr+/tF+f/bT/wCxqcJKGGxFt09mOOYV54dYimvejuujR8P+HfF1h4xs/t9n/oWo2z/6TbNw9vMv+z/dr27Q9eju7bZc/u7qP73/AMUv+9XkXxK+F9zqt5/wsL4dSLbeI7b/AF9t8oS8T+JW/wBquf8AB/jZPEsMn7v+z9Xsv3N7ZvxJG6/L3+8tfpVL2WJhyPRo+E4h4apYrD/W8FrDquqZ9H3WuQxJsuZ/lrmJtc01fuSVw1xfebJsm+9/drMvP3sLfLt/2q78LksI25nufFYfI1pzNnaaP44ufAnif+29H3T6Xff8hGyXpJ/02j/uyr/49X1y1xYeI9KttV0qTzYp0WaF/wC8Gr88tBWZ7mfzpfNiX+9W/eftCP8ADd4rOwj/ALQg/jt842f7rdq83OeCZ4iovqSvPqfrOR4qu7ZbbnVt+x137QlvoOlaat5eKsWoy/KvG3Nfn74gmv7eb522rL81d/8AEj4sXnxP8TxalqTfZLC2/wBRb/5/vV5frmsf2nMuz7sfyrX7nwNktfAYWFPE6vd+R+kcOZFPCW51vdvyMH7/AN+tS3mtk+58u1fmrJoaTZX6FOcFByeh9m6XN7pJeTebMz1l3En8FJJJVLdX5rxDn17whszvoUbW8h9e7fs8/Ct/i38X9G8OXMf/ABKdJ/07V+/7mBv9X/20bZDXhW7yIZLzdt8j7nvJ/wDY1+0f7Ffwi/4Vx8LY/EmrQbde8Y+XfT/L88drt/0aL/vk+Yf96v5v8RM85aawlN6vf0PYwcPe55dD7J27E2fdqGnM1Nr8birRM69TmZNRTFp9WUOptFFBsOptMp240BcWiiigoKKKKAGUUUUEhSbjRuNR1ZjKQUUUUGbBqjalpjUROechtQNU9V2rWJxz0M2+vobS2kvJmWOKJSzM3G1RXwt4m8QP498VS69c/wDIO0/dDYJ/e/22/wB6vWvjZ4yeeZfBOmyf6z5r91/hT+GP/gVeETTJbQrDD/Cu3bX6fwjlXsrV5qze3kj4vNK/tW4dCvrWobE2fxNXpPgu1tvAnhK58T36/wCn6h9z+9/srXC+E9B/4SPW4/tP/HvB++m+i/w16F9lm+InieCwtvl0jT2+bb93Yv8A8VX0ufYyEV7C+i1Z6GUYB/H1ex0Xwh8IzX1/c+P9b+a6uc/Zt38OfvOtfQU0lVIY4dOto7a2VY4o1Cqq/wB0VWmmr8xxFV16nP8AcfTcipQ5CC8vEtoWmf7sSlv90LX5IftDfEybxf4nufJk/wBAgzDbJ/diVvvf8Cr7Y/aQ+JEPhPwlLYW0/wDp+pfJ7+T/ABV+Resalc6nft/FLI1fp/CUKWV4WWZYhavRI8jC4eWKxHkvzKn76+ufJh+avX/h74Nv/EepQaVZx/dx5zf+y1h+DfCN/qtzBYWED3N7d/JtUZxX6qfBf4L23gzRInubT/Sm+bc6V+b8SZ5Uxc3rv1PvaOHhSV5dNkdD8NfA9h4O0qOGGD9/sX5q9SVt9Trav9zbU/2V1/hrhwsYUoJHi4qc5T1Kq1YWk8nbU6rXTKRyWJI5nq2t09UttTLWM4p9C4k3mb6kVqrrT91ZWNOSTJ9xqPzKZupm6ixpYm8ynbqr0bqALG6m7qh8yk8yiwEvmUm6q7UzdVchBKzVCzUM1RM1VGJcYklMpm6m+ZVWKsf/0/z3VqkVXl+5TvMtv+edN+3fwItf2nHD+Z8VrLZF5bN3/wBc22rMbabafw7mrEkuH/vVXaZK9DD0Ioz+rzl8T0N+TUppf3afLWddN8/ztuapNN0nVdSmX7HA3+9X0h8P/gbbaj/xMvEk+21X38tK66+Kp4eHtKj0/M4sRi6GG0k9ey3PFfCfgnXvGdyttpsHlQfxTP8AcX/4qvuz4a/A/wAN+GIftFzB/aWo/wDPedfkT/dWue1b4rfCj4ZW39laJ/xOb2D/AJdrD/Vr/vS/dr5r8efGbx549WSz+0/2Xo3/AD6Wnyhl/wCmjfekr5LG43H5p+7opxh3elzj/f4l/vPdj0R9c+PP2hPA3gLzNN0T/ipNZi/5YwPizif/AKaS9/8AdSvinxx8SvGHxIv/ALZ4t1Bvsq/6iyt/3cCf7kf/ALM1ec/8e33F+9Xr/wANfhzqvjG/itraDzP7zfwIn95q+lyXhnBZbTeLr6tbtnpTnDDw0Xp3Zs/CP4b3/iO/WZ4v3Ve4fEnx1Z+HrNfh74Sk/wBK27Llk/g+WqHjz4gaP8K9HbwN4Jb7Tr0/yXNyn/LD/wCyrw7wfodz9s+2X7efe3b/AMXJy1Yeynmk/ruK0pr4V38zwMbL2VOVWq/eeyPpT4T6H9js22Lull++/wDFXqvi7xNYeCfDdzqVy371V+Vf7zfw0nhfT4fD2iL/AAtt3O1fHPxe8fP4x15tKs2/0Cx+X/ef+Jq+RwuCebY9/wAiepz5XhZxh7Spq3+BwM19f+IdYudVv23S3Lb/APvqtqHT7nVby202H+8N1Q6LZfIte5eA/Dvkf6ZMvzN+lfqWaY+GFpe5pbRIy5/a1+SGx6D4d0mHSLC2s0X7q1538XofPhiT+86L+Feww/w1wHjy1+0Q/wC6wr84yvEP62qk9z6HEQ9lh3bSyPK7OPyoYo6vqtRLHsSp1r7Wcrn45XlduXcnirQt1+eqMa1o26/PXJXOCodZYrs212Fn9yuUs1/jrq7OvjcwPqcH8KPQPhTHv+JdlJ/ds7r/ANkr7Zj+5XxV8J/+Si2n/XtcL/46K+1F+5X4dxt/vq9EfoXCf8J+pLRTKfXxJ9aMop9FBQyn0yn0GiHrUtRVItZs66UiSikWlpHTGQ7caN1NoqLGvOS7qYzU2ilYn2g7cabRRTM5SuFFFFAhlFFFWAVG1SVG1ETNkdFPplamFQZTalplEZHLUEWvgT9ur4Vf234Z0/4raRH/AKf4ZX7NqC/xPYSN8rf9sZG/Jq++qr31hYarYXelalAl3ZXsTwTwONySRyLtZCv+0K7Mtx9TCYiOIpOzTua4efSWzP5wfvUq1618bvhTefBv4hah4VffJpM/+l6Vcv8A8tbORvl+b+9H9xq8lr++eGc9pZpgoYqD33XY4KtJxk4nqfgvxJeaZc21/bXPlz2jf3sM+2v1P8A+KIfFvh6y1KFvmlRd/qH/AIt1fjJb3D20yzQ/w1+i37K/iT+1bO703d935/8Ad/2a/P8AxTyaE8L9ZhuuvkflnGeUclsTTXWz+Z9aa1ouleI9Nk0rWIlnt5fzRv7yt/er5C8UeB9Y8AX7TTK17pErfubhF+5n+GT+7X221vtSqV1a213bSWd5GskUq7WRl3Bs1+EZPndXBz9zVPdHyNfCcyem580+BfFCaZMv/PKWvq7Qdchu4VeGXcrV8keKvBtt4av5bzR7n9xLlvszfwf7tavg/wAWJ4eha51K5Zbdv0r384yqGPpfWKW/Y+ZyjNZ4DEOMHdX1XY+z45t9WlbfXyRp/wAdPt2txWFnaf6B/FcOcOf91e1fRGk65DeQq6Nu3V+e5hkNfDWdRWufrWX8V0qs/ZvR+Z3C18j6NIfj38ep9UH+k+BvhDN5Fn/zyvdek/1kv+0tuP8A2Vv4q7X4/eMvGGkeD4PDHw70+e78W+MZ/wCy7CSAf8egkX97cSN/yz2p0b/gX8NeofCX4d6X8KPAOj+B9Lbzf7Ni/wBJnxj7RcyfNNK3+836cV8rXvzctj9WyiMOT2l9zrvEmsab4c0TUNe1u5S007TYHubmZ/upHEu5mr5K+Ca6x8Q9S1b48eJN9t/bu+w0Cw/59NKik/8AQpnGWrh/2jfHV58XPiDpv7Ovg+SQWEVwLnxNcwf3I/m+z/8AAf4/9vatTePvilfyp/wpn4M2U0moweXps1xbR/ubBPu/e6LtSvZwOAnyKfc8DiPFU+dUUtXu+yPbPBfji58X+OfElnpWyTw54d8u089P+Wt63zS7W/6ZivbbXUE37N1eF6TpOm/BH4XR6bYf6XLaJud9vz3V5L95v+BGsr4W32q/2J52sTvc389w9xK7M3/LRtyqv93bXd9Q9qnPotj8/r57DAVY06bvfc+rIZN9SNXF2esfdrsLeRJ03183iMO6UveP1DKM5p4uHLTeqLcdWqrKtWBXDUPqsOfI/wC1m39l2Hwt8Tf9ATx9o0rf7jeYrV9aba+Sv2245l+AWqanD/rdL1LTLtP9krdIuf8Ax6vrOGTzYVf+8ob86DoPg/4F6Xb+DPjh8a/hlFH5cf2y112z/wCuF38zf98+aor6sm09Em87b833a8J1rHhz9svw9c52x+N/B11Yf789hN9o/wDRaivq2axR69DD4zlPj884e+sz9pA4i3bzdyf3a4TXpks7xkf/AHq9IbS5rbUvOh/1Uvyuvv8AwtXCePtLdPs2oJ92Nm3/APAvu/rX0GW1oOqlfRn5JxXlOI+ouUVqjio9chR/n+X5q5P4reA9K+L/AIDudB3LHq8H+k6bc/8APO5j/wBr+633WrubHw+l5++2/erttD8L21nMz+Xu3f3q9vH16CXmj4fg3C5nHFKpsl1PH/gv4o1Xxx4Mj/4SGCa08R6FM2l6vDOjKftMC/6z/a8xPmr3XTb5JXawuf8AW7f4v4hXT+SmysyTSYZbmO5+7LH91q+ani+ff5H63PKJwr+1pLR7roeDeLPA+saDqUmseG4/PspfvwINxT/dX+KvE/Enwjufib5vjPwP/wASDx1o38T/ACwaj/0zn/2v8n/Z+/8AyUdKzbqFIEZ7ZdrV6VLiGryKHVbM5KHDMcBXliKT913uujPy603WptZ+16JqtjNoXivT/wDj7025+V12/wAUO77ytWD/AMJJc21y1nefK27b81fVnxO174aa5qXk+JraH+1tN+S2uf8AVTp/uyda+LviEqa5rFtZ+G/Pvb2OZPnhT5Nv+0y1+7cI5p7eny4tW8z4mGCwlfFuNGLUHrd7I6/WtS/srwxfXkLbZ5F+WvkK61C5uXaa5laXd/er6z8baX/Zngae51X93O1vsRf9uvjRmr9J4fxdOlCU4atvc+34AoU5UJ1Iau9rk240bqrrXqPhnR7NrCK8mgWdpf743V7scfOXvH3eNxUMNT55q55x5lVJJK+gf+Ed0G+Ty5rRN395fl/9Bry3xxoej6G8SWFy0k8v3oW52f8AAq8fOc3nGk3fRHFleeUsTU9nFNNnASSU+3hmuZltrZfNlk+VVqruNdZ4e0e/1m5svDehWf27xF4hnjtLOP8AuJJ97/v50/3M1+I5znyoU3iJvY+shS5rRie9/swfBj/hcfxKtvtkHmeEPCfl3Oof3LiX/lnF/wBtmH/fta/c75ERUT+GvIPgZ8JdG+DHw+03wlpvlz3WPP1G7VcfabqQfvJP90fdT/YWvXGav58xWKniq0qtTdndX9yHINp1NoqDziWn1DT1aoN0PooooGMop9MoNhytT6iooAfTKKKACmbqGptWYykFFFFBl7QKKKKDOUhjUyiq7NVROecgkavOviN42tvBnh+fUvlkupP3NpDn/WSH7v8A3zXZ319bafbS3lzIsUUCl2Zv4VFfBfjbxhc+OPEEmq7v+JXbZhsIf9j+KRl/2q+jyPKvrFZXWi3PEx+M5Y8i3MaGS5d57+/k8y6u3M0z/wC2W3Vk3Uz3NzsSnTXX8FaOh2sbzfaZm+WP56/XaVqUOfseHQw/PNRj1OzhabRtBttH03/kI6z/ABeiV9DeB/DMPhjR47b/AJemUNM3vXB/D3wy8szeKtSX5pPktEb+BP7/APwKvYGkr8+zPF+1bhHbqfdUcPGlHlJJpHrmNe1yw0HTbvVdSlWC1tkLuzegrXmm/vtX5xftWfGT7Zcy+BtEn/cW3/H2+777/wDPP/gNdPD+TfWqvJN2gtW+yPKxs3Oap09W/wAD5t+NHxKufH/iq71X/lh9y3T0iFcZ4H8G634t1iPTdEtPtN/L/e/1cf8AtNVv4f8Aw98Q/EjXoLDTYGbzW+//AHK/Xn4S/Bfw98MtEj8mBZL1sb5m6187xdxbPMcV9VwmlOGiXkfeZblUMFh1Oau3sj508J/sd3ktstz4h8e6tp88n/LLSz5af99V6xZfssCwi/4knxk8c6dJ7XmU/wC+V2V9K7qVWdK8mlgPM4auK5pcx87yfB79o/Qzv8IfHibUPLT5INasPMQ/7zf6T/6DVjT9Y/bF8MXMcPiHwz4X+INj8u+XTrqOwuf/ACJ5Q/8AINfRP2iSpluH/vUfUPMz9v8AzGNoutT65Zma88P6p4dvIm2y22qRx7s/9M5YnkjlX/aWtmq7SfPSeZXoYWk4w1dzir8t9izT6gVqWtiIwJqN1R7jS0G3IO3Gm0UVBPswooplAezH0zdRTaCLDt1NpGaot1WA/dUTNUbSb6gZtlVGIEnmVHuqPzKj3Vsaxkf/1Pzi8ypY97vshXc3+zXULa6VF/yz3VZ/tCGCPZZxqv8Au1/bnOfFyxv8iMq18P3k/wA9432Zf9r/AOJrp7ez8Pacn/PzL+dYUl5NP9+mR1r9at0PPr+0n8bsuyO0j8aTWO5NKtF/35v/AImsvUPEHiHXPk1rUJ5Yl+7Dv2x/98rWXCyIjUvmferKpVlVexzUsPThJ8sde/UqrCkX+pj21DNebf3KfM1I1w7zeTD8zV2mi6DDA63l4u6X+FP/AIqvo8Jh4Q9+pqjoxGIhSjz1NX0Xc2/APw7m1yZb/VZPs1kv3mevZfGXxa0rwFoP/CJ/D3b9qn/4+Lv+OvFta8UPbQ/ZoZG3fdXb/DXBafptzqd5503+9WVfLfr9VTxD9xbLocGFnObeIr6Lob2i280t41/qXzXE7ltz/wC1X1F8I/Df9p37alc/6q0b5frXz9p+/Ub+DSrOPzW3KnT1r6s1jXLD4U+D4NKhZW1a5j+7/cbb/FXFxbip+zjhKXxS0S7I86f7+up1NEjH+N3xITSLBvDejt/pUq7W2/wrXyfpdr91H+Zm+ZqNQvrnVb6XULxvNuJ33MzV1ei2PyfaH/hruyTK6eAw/J16vuzbHYrlp+p3Ph/TfNeOvfNJtfsyV4V4R1q2ufEMGg2/7yf52mZekYX+9/vV9E2sez79fIcQ4h8/KxZHhWoc81Zsl8v565vxZH/o1dg0dcn4u+S2r53AP96j2cbpQcjxmb/2alVakaOnKtfoVz8Sqz3JYa1bdaqQrWlDXDXZ5deZ1Gnrs2111r/q65nTV+7XWW618jj5an1OA+BHcfC/5PiFpr/3oZ0/8h7q+01/1dfFnw//AHXjbSX/ALzuv/fUe2vs6L7lfiXG/wDval5I/SeFJfu5Ilp9Mp9fEn2IUUUUFEVOoooLH05aip9BrGRYp9QrT6ykdcZD6KKKDUKKKKACiiigAooooAZRRRQSFMan0UGbIqKdTasylEZRT6ZQc04jKKfTKo5/tHg/7RPwYs/jX4Ak0e32R+INL3Xek3P9yfb80TN/zym+634H+Gvw1uLW/wBPvLnTdVtntL+yme3uYJhteKSNtrKy/wB5TX9Ii1+fH7Y/7Osmu20/xc8D2nmatZp/xO7SH/l7tov+XhV/iliX7/8AeT3Xn9O8NeN/7GxXsqz/AHct/Jna4e3h5o/L2vbfgD8Rofh94/srnUpPL0u9/wBGuf7qbvuyf8BNeGrJHKm9Kjav6qzulSx+CcL3Ulo0eLiMHCvTlSmtGf0B2siXNss0LbllXcrdcqa4Pxx4s0rwlar9skX7Vd7lt0zguf8A7GviP9mv9pRNI+yeAPH935dh8sNhqL/8s/7sM7f3f7r19hfGL4Z2fxL8Medprbdc039/p02/Hz/3W2/wyV/KVTLPqWNVLF6Rvv5H5hmGS1KV6U3a/U+dfEnih3dpppN275mrym+17z33zfdryhta8Qz3lzpWsRSR3ti7JOn90j/ZrlNa8WTS7ra2/h+XdX9M5NwzBQUUeNlvBE4T5L3fVntf/CSWyv8AuW2ste1/D/4salZ3kFtNL5kTMF+avgC31a5gm3+YzV6f4b1jz9s0LfMrV355wbSq0HGor+Z6Ob8IxpU+aL1XU/Z7QdUS5to7mFtyyqG+Wuv8x54WTcy7lK7l+Uru/iX/AGlr85/h/wDGDW/D22G83XNgv3kbqP8Adavs3wX8RvDfi+HfpV8kkq/ft2O2RP8AeWv5J4m4UxGCqOTjdd0enw1nzjalUdmi34D+E/gr4b6fPZ+FdN8iS7dpbu7uHaa6upGbczTzN87c11lvoem2PmfYbSK0892d/JjVd7n7zNt+8zVoR3CPUnnV8f759pVqUqvvS1bMW80tLlNkyrKv+0M1zMmgpBu8lVX/AIDtr0JWR6imhRq6aGNnD3Tw8y4eoYiPPFanFWunuj13+kq8SbHrMWHY9b1m1Y4/ESmjt4ZyqGGqb6mtTqYtPrxT9QifOn7Vuny6n+z14+toV8x49N8//gNvLHMx/AJXovwo13/hJ/hl4Q8QJnGpaLZXHz/e3NCu7P41c+I2mDWfAHinSDD9o/tDSL238lRuMnm27psH+9Xm37MGnappHwG8E6Zq9tLZX9tYsskE6NHIn76RkVlbkfLUFnnf7TTWnhvxn8FfiRcj5NE8WLps7/3INTj2uzf7uyvsVa+f/wBo/wCFd/8AGP4W33g/RJorfWPtFveWM1w7JEk0L/xsoZh+7Zv4TXtNgt1babaQ3knn3EcUaTOv8TqvzH86sznPlJZvv1l6lp9tqNs0Nwu5WrQkkqu0ldlK6tJaM+Zxns5qUJq6Zz+n6LDYp5KfdrajhRKfuNOWuirVnL3pM8fC4KlSSVNaIkWOl8ujzESqtxfQwJvkbbWMYyfwno1Z0YR5psdItZ83yVw2pfFjwTp0zW15rMEUq/e+avL/ABh+0F4P0i2lewn/ALSl/wCmPT/vqvoMBkONrzUY039x8nmWfYXlfs3d9keia54R8Ja/c/adY0a0vZ/780as3/fTVi3mn+D/AA1YT3KafaWUEC722oq9K+HPE37XHiGfzLbRLFbb/aevmbx58ZvG3jNGs7/VH+xN96GE7Uf/AHq/TsBwBj9PbOyXQ+apZFisa/gUU92zZ+N3xKTxjr09npXy6dBM+3Z/H81eBeZSNVbca/TJYv6rBUodEfqWU5XSwdCNCktF+Jajk3SV9JeHbOz/ALNtvsbebFs+9XzCrV6P4N8bf8I958N5+8spFZv91/8AZ/3q2y3Ooq/tH8zz+IstqYih+61a6dz07xNr1t4X0/f969nz5K/+zfRa+bby8mvrmS5uG3Sy1d1zXLzXr+S/vP4vur/cX+Fax1j837n8P3v9kV8PxHxN7e+toL8T0MhyRYSn/fe7JrY2y/vrj/Vxf+P/AOz+NfrF+xR8AptKtv8Ahdfjm0/4n2rx/wDEmgk+X7LZyD/X7f4WlXiP+7H/AL1fN37JH7OB+Kuup448VWx/4QvQ5fkhf/mJXUf8P/XJf4/++PWv2fZki2onyqvy/LxX4JnOcTxtTk+yj6jSlG/UWSSoqKK8zlseRKpKch9FFOoNA209VpFqSoOgZupNxpWqKgCxRUO40/dSsAUU+imWMp9M3UxmoAbRRTKsxmFPplFUYSH0xmopjUGcpETNVeSTam+ntXhfxe+JCeE7BtN01vM1O7Xan/TPd/F/wGu/BYWdeooQWrPNx+KjSg3c8z+N3xC/tW8bwNo8/wAq/NfTL/c/55/8CrwptiIuz5VX+GqsKuqNNM3mzztumfu5qK6m8pK/WcqwkKUFCH/DnyfO2257simuPK3SO1eyfD3wrc65NH9pX/QuHm/3f4V/4FXj/hPQb/xjrypDHuson/4C5/8Asa+7tD0m20PTYrOFfu/fb+81ePn2b+8sPSfqz7TJsr9lTVWrv0Rp7Y4IVhRdqqu1fwqBlqVq47xl400fwTol3rGqzpBFbIW+Y4Zsf3a+coUpymoRWrO2vVSTd9jyr4/fFC2+HPhKd4ZF/tG93Q2yfX+L/gNfmL8P/h34k+MHidvJV/svnf6Rcf71ei30fjL9pf4hfaYYng0vf+5/6Zw//ZV+m3wx+GuifDnQbbTdNgXdGo+b+L/arh4o4inSpf2VgHq/iaPb4fyeFK+MxW72Q/4V/C3w98NNBjsNNtl+1bfnm/jdq9Fkk30vmVG1eJl+XwoQ5d/MvG4qdebmxtFKtTbTXsxkcQzy6XbUi1JVxkYyK3l1ItOptVcysFOoprUXCMR1G6q/mUeZVXNSxuo3VDuNN8ylKQFjdTWaoGk2VE0lK4FhmqPzKqtJUfmUwLEklRM1RbqjaSi5JKzVE0lRNJVdpKuMhSkPZqN1Vmanr/HXQRKR/9X4CpPkqbyacsNf2qfAe0iQLViNaVo6arP9xKIxJlK5OzbKbDDNdzeTbLu3VuWvh25n2zXn+jRVurdWGnp5Ngv+8/rXsYWkoRvLVnBVxqjpTV2QWej2el7Zpv3s/wD6DVXUNY8pNkP/AH1UV1cPP/FWfHbzXL7NtdkJzlp0OOlS5n7Sq7sq29rc301bd1N9htfsFh/x8N9+r8zJpFt5Kf69l/75qPwzpby3LalqH+qX5v8Ae/2a+hw/JSg5vpsu5dXFLkdSWy2Xc9Q8DtZ+ENP/AOEkvF8zVG3fZEbs/wDz0b/drg/E2vXOq38l5fyNPPO25t1S6pqjzu2z/d/3B/s1zcNm91cr8vy149DCc2IeIlu/wR52H1vOpp1Lmn2L3k2/burT8YeIE0O2j8PaVJ5l63/HzMv8H+wv+1S6trVt4Y01baw/e39yp+b/AJ5rXmmi2r6jqUCP+8aR/m/9mrWNKWJqdor8T1sFh1JPEVFotj6h+Bvhn+zbOfWLj/X3OPmb+7X0fGu999cP4T09LHTYE/2a72L+GvyrOa/PXcunQ1wFWc4uc+pY279tcd42X/QGruVX7tcH40b/AEPZ/exXBlv8dBm1Xlw05eR5Qq/JSrHVhVpyrX6B7Q/DJzHxrWpDHVONa0Yq4q7PNrzOs0+NPlrq7dUrmNP/AIa6i3r5LH9T67BT9xHZeE2htvE+kXL/ACqtyn/j3y19kR/cr4htWkjeN0+Vlbcre619T+CfFX9vWH77b9ttvlmX/wBBavyTjLBTk41o7bM/ROGcXCLdOW72PQaKKZX58fe3H0Uyn0AMptS0ygoKfTKfSZrGQ+pahWnrUM6oE1FMp9I3iFFFFBQUUUUAFMoooJkFFFFABRRRQYyI2pVooWrAbRRRQczGUU+mVRhIKerVDRUyjcqE5R2PyY/a0/Znm8BX938UPAFru8L3b79SsIv+YfNJ/wAt41/54N/5Db/Y6fCm5HTelf0mXNva6hbTWF7Elza3CNFLE4DJIjLhlYHj5q/Hj9qH9l+9+FV5c+O/A9u934MuZN09v96TTXf+H/rh/db+H7pr9f4A8RZYK2CxrvB6J9jrnQVX34b9j41r6i+EP7UXir4c6b/wjeq/8TbSI0P2Tf8A661/uru/ii/2f4e1fLW5JfnRt1Nav1/NsBhsdTU5pSW6fc8rEYOFeDhVV0fRnw9vLzxPqXiS/wBSk8y61TO9/wDpo3zV4rfQzQXk9rN/rYnf/wBCra8B+Mv+EVv/AN8vmWU+3zv74/2lrR8ZLp994kkvNHlWeC92TJsb1+9/u19xw5j4OvyQ0TW3ax87Sw9TD42fMrQa0ZyEMbzuqQruZq2rXWptD/c2y/vd3zNW0tj/AGBo8+q3P+vb5If9815s0zu+/wDvV9BmWd04/u9z0aPJir6XS/E958O+OEls5/tnyyr/AA+tYTeLNVttS/tjw9dvbXsHzb0dlrySObZUn2h/4K8KrDCVYOUuu6OClw5QhUc4Lfp0P0F+F/7YVzp/kaV8Qv8ASV/5+4V+dP8AeX+KvsH/AIXF4ZvLBb+w1JJ4JV+V4fmr8NFavU/h/wCOpvCt55Ny26wn/wBdH1/4EtfmmaeG+DxUnWw6t5dGeVneR14UXPBOzXToz9bdL+N3hu5vFtnldd3y7m27a9ns9YhvoVmhZWVq/NbR7rR9fhW/sJFk83+5/DXsnhvxprfh62jtoZPPi/uPX53nfA9OH+76Nbpn5fh+MsRg6ns8Rdrr3R9sLMj1Zt5q8C0f4sWE6LHqUTWUv+2cp/31XoNn4mtpXj2Mu2f7rZ+U1+c4rJq9K6nGx97lvGGFqNSi9T1OOarYmBrlre+Rv4qyPEHjLQfDFn9v17UINPtWZUV53VVZ2+6q/wB5q8D6lOU+VK7P0fD57TVPnk9D0DzEqFpK45fFGmvbfbPtKeRt3793y7fvbt1V9L8XaPr0P2rSrtLuL1Rvu/7y9RWn9n1Em+V2RNTibDytFSV2dm01Z9xcbKr/AGjd/FXm/j7xYmg6Ozo3+lT/ACQL/tf/AFq3wWAdWoqcFqzx85z6FCg6snojpofFGm3l5PYW1ykk9t99Fb7tRQ+KtHub9tKhu0a9j+9Du+cf8Br45uPG2m+EpmvL/Ukgurv3X5n/AN2uRsfFWpaVeQeJ/tO6WeUu8399C1fo1LgSck5Rfp5n5JQ48xdVKcoWTf3o/RWOTfU/mbK+MdQ/ao8MaMi+dPDJ/uPu/wDHVrwr4hftsax5Mlh4MsoYJ/8An5m/ebP91fWvKjwLmEvijZdz9Cy7NquJsqcHfz2Ptv4vfGzwr8JNE+363P5t7cq32S0T/WTuP/QV/wBqviH/AIacufH8LQ6rL/ZX3v3CPx/31/FXwv4m8WeIfGOqz634k1CbUL2f7zzPn/gP+zXPrcbK/SeHOF8DgvexGsu562P4aWMpONWTT8uh9a+ONes7ywl/0lP+At81eNN4s+x23k2zM1eZyXjy/fbdXYWelwy6fG83yyy/N/wGv1fKquHq3VPocuE4coYCkoTd0Y15qE139+stq0L5YbZ2RG83bXqHwr+F83ju/wDt+q7rbRIG+d/43/2FrLOsfToRte77Hv1cVRw1J1ZuyR43L9yqNfWvx+tfA/h7R9L0Hw9oFtZT8P8Aa03edsH3t3+9XyR5kdfnmPx8ZWnLTyOrKMesZSVWCsuhLVKSTfQ0m+mxq8r7Er43NM2ThZOy6vuezCl82TQxvK/l/wCV/wB6vof9n74Far8cfGEenWAltfC+leU+r6h/7Th/6ayfwD+H7xrnvgp8EvFPxq8Vf2DoX+jaXBsfUtSdP3MEf/szt/An8XU8V+7Xw/8AAHhj4YeFLDwd4TtPsthZf9/JZP4pZW/iZv4q/K82zh4qfs4bI7v4C557m7oXh/RfCWh2Hhrw/bpYaZpsSwW8CcBUX/PNadJ96lrzII8KvXdWfMPp9Mp9A0FOptOoNAp9MoqAuIzUlOptWaXCnU2nUD5x9FFFQOIym0bqZVhKQU+imUGEpBRRRVGUpBUEjVI1c14k16w8O6Vc6rqUvlwWy7mb/wBlX/eq6UHJpJXbOXFV1FOTZheOvGVh4M0SXUrlt0v3YoV6ySfwqtfCGrX15r+pSaxqsvmTyszey/7Na3i7xhf+ONYbVbz93ar8tpb/APPNP7zf7TVgf7lfomVYD2EPN7nyeKrurK76bFeX7lc41veeIdVi0Gw3fN/rn9E/+yrevGd4fs0K7pZPlX/P+zXv3wn+H8OmWy6leL+9b+995m/vVtmmb/V4clPd/ge5kWWe1l7eotF+J3fw/wDBtt4a0qD93tl2r+G2vQWp+2ua8VeLNE8GaPPr3iG7WysIPvOyM3J+6u1d33q+Wo/e2fT19ZC+Ite03wvpVzrGsTrBa2yszs1fnFr1x4w/aR8Z/ZrBXtvC9s/8vvSN/vVpeKPijoXxr8U/Yb/xnp3hfwtaSfuYrtmie4/2m/u/8Cr7e+GOl/DfSNHjsPCWs6PqX+3aXdvLv/75apzLNfqq9hh37z3fZHTl2Fhf29VadEN+Hvw/0HwHo8Gm6VbKu37z45J/3q9MaSnTWs393+lVYq+ewuFhA7cVjJ1ZD9xpd1RU5a7ziJlqfcagorWMiZFjdTfMqGmbq1gYyLe6jdVPcaNxrYkt7o6iaSq/mUbjSuUOZqj8yo2aomk+Si5VifzKZ5j1U8yjdTCxM01N8yqu40bjSuSWPMjqJmpm402lKQDvMqKimUL3vhM5ysOZqaq7643xl468MeBbD7Zr135Usv8AqbZF8yec/wB2ONfvV85a14q+IvxIuf7Khgn8P6Zc/c0u0/eahd/9dpF/1St/Ev613ShChD2tV2X5nLGrOvPkpK7W/ZHrnjL4xaRobz6V4Y8nXdXi+R+f9Ft/+uky/eb/AGE/ErXkmi6D8bPio89/4V8f3+hXUH/LV0a30p0/55wRqnzN/wB9f7Rr2v4d/s422nJHc+MI0jg42aXb/c/3Z5P4v937tfUdrZ2FjDHZ21tHHBEuxEVVwoX+FVrxq+ezq3p4aHzZv7CnSn+8d32P/9b4X8uo2X+4tdXa+H9/+uk8pf7zVckbSrH/AI9o/Mb+9X9u/VavNqflEsxhtBXZzVrpN5c/O/7hf9qt2NbDSv8AUr5kv97rVebUJpf9mqDb69Klg/Iwk51fidl2RYur65vH+dvl/hXtVX71KtWbe3muX2ItdVi9IrskQ29vNO+xK6SSGHSrb+9O36U/9zpUP96f+VZsMb302+Zq6ISscE6vtfe6fmRWemzarc75vu/eZvat7ULhPJWzs/lgj/U02a4Tyfs1t8sX8X+1We3+zVyr89jKU3NqUtlsiuq76vSXUdtbfJ95VrN/1FZGsTbLCT/arpm9vM66WH9pNR6HJX1099eSXM38TV6L8L9J/tPxAv8Adg/rXl/8de0fC/xVonh55P7Sl8qWdvvY/hX/AGq3xEnDCT9mrvZH0Waqaw7hTV+h9iWK+QipXQxt92uG0XxBo+rp52m3sNyv+w6n71dbbtX4rjKT5nzqzPIwley5OqN379cN42X/AENf9lq6u81Cz0bTbnUtSl8iC2Qu7f7q/wAP+1XyRD8QtY8e+J2vHk+xaXbbvItF/j/2pm/iatsjy+rVqOpFaLdjziF8JO76HoStS+XUfmbKkjbfX1jPw2RahWr8VUIavRtXNVOCqdTp8ldXatXAWcyK9dfZ3FfOY+kfQ5ZWukddF/DXR6Tq1/o95HqVj96P76fwyJ/ErVyFvJ/tVtwtXymNw6mnCa0Pq6U7NSi7M+tPDuvWHiHTYr/T2+VvlZe6P/ErV0VfJvh/XLzw1f8A2mz/ANU3+uh7OtfSui6xYa5Zx39hJuVvvL3Q/wASsv8ACa/JM4ymeFn3T2Z+k5RmqrwUXo0btFFFeEe4FFFFABRRRQaRkPp6tUNTVMjppTJaKYtPqDqjIfRRTKB3HbjTaKKCwooooAKKKKCJBUbVJUbURIEoooqybhTKfTKDEKKKfQYsjam05qbVGcgqOa3tryGSzvIkngnQo6OAyOjLhlZW+8rVJT6mUSoTsfkt+0t+x5f+EZrv4hfCS0kutCP+kXujplpLT+9Jbr95oP8AY+9H/ufd+AY5knTelf01rJX52ftM/sb23iMXfj34Q2yWutjdNfaUnyw3f8TNB/dlb+791/rX13DnGVfLPcnrB7rseryQr+TPynZquaXq1zpF5HeW21mi/hcZRv8AeWqt5Dc2N5PpupWz2V7bMUmglRldHX7ysrcrVRq/XIZ1GqlXw07p7WOarh94TR9reFV+Evxy0e28MX+qP4J8Vxf8e32h91lcSf7P+9/drw/4ofBvx58JL/7N4q03/QpP9RqNv+8tZf8Adk/h/wB1vmrxTdX0x8O/2ovG3hDTf+ES8VQW/jjwpP8AuZtN1b97+7/6ZzN0/wCBblrx/wDWDG4epz83MuzPOw+WfVtKO3bsfPvmUbq+gNe8J/C/4jXn274Oah/Y2o3P/Mua1KsXz/3LK5+43+yjtXhGpabqWjX8+m6xaTWV7bNtmgmRldG/2lavt8t4heIhzNWfY6I2l6oijkpzSVWWkmavqVm04UmzP2fvHZeGfFWpeHL+K8sJ2Xay703fI4/utX0xcfH7QbbTY5rPT2nv5U+47fJG3+9/FXx1btU7MiVt7Chi6Sr1T5nOOFMFj6ilXjdr8T0/xJ8VPFviN1+03PkRR/8ALGH5U/8Asq9Aj+N1/F4egtpp28222bNp5+Wvm7d/FVaST+CozJ4SFL4Ekti6/CmCqwjT5EktrH2Fpv7ZnxF0ew+wW1taXe35UmudzOP7v3fvba8G8afFbxz8RNSXVfFWrTX0sH+pT/Vxxf7sa/KteYbjSR3DpXw+CpYKjX9ryJN9T2cLk2HoR/do+vdD/aK8Q/8ACJR+FX8n92m3zm+9hVrktH+NHjCz/wBM0HUPsl7/AHE4rxebWLb+yoEhX/TfnV2x2auX8z+5X0WKr5fhvggmpatdzw6HCmEu58lm2fbOk/tlfFfSE8nVbay1L/rtG0T/APkOuP8AH37VHjbxjHEkNtbaX5efnh3SPz/d3fdr5Za6ml++zVB5lfO145VSn7XC0kn3PS/1cwsv4kE7dOhvX2sX+pXLXl/cvczyfxu7E/8Aj1Sf8JJrf2D+zf7Qn+xf88vMbZ/3zXN7qN1XPPpOPKez9Sp8qVlZbeRejuNn+9UO6qO6pPMrl/tv2qtLSxr7Ie0lQNJTWalWvn6+PnVnywZtGBr6XDbT3kf2yTyov4mr32TwbbanYRQ6Vc/w187xtX038F7HxZ4vf+xPDGn/ANoTx/xNxHEn96Rq++yPH0sLh3zu3VtnyHFFKvyKrQeq6Hkt14JvLbxBaaC88M8s/wAz7P4F/wBqv0Q8A+A/Elz4YstH03T/AOy7Bf8Al7m+Uv8A7sddZ4Z+Evw9+CdnP45+JeoWkmqS/PNcXLfJ/uwq33q+V/jh+2Ff+J/P8N/DSN9G0nlHvPu3Mv8A1z/55L/49/u1+eZlxX7Wq/Y7d2eLisFiM15YdEtezI/2iNW+GPhzS5/CWm/8T/xW3/Hxeu+5LT+9/wBtG/u/nXw3TpJHlf5/4qjr5bMM1+3Ub+fU/QMnymGEpKjTJa+ifgD+zv4v+OWr/wCjb9J8K2r/APEx1Z14/wCuUP8Az0l/8dXq3+16v+zd+x5rfxPNt4w8fC40jwecPbw/dudQ/wB3/nnEf7/8Xb1r9htB0PRfCei2vh/w7YRafplggigt4RtREFfA5hnFTF+5DRHtz5KHvSd2YPgDwD4U+GHhm18JeELP7HYWv4ySSN96WVv4mb+9XXt89G40Vxwpcp4eIxDqyCn0UVoZRiFPplFB0D6KKKkAopm6jdQAUUUUAP3UbqKKADdRRTKDWPwj6KKN1BkMpNxpWqNvkqjNklFRbqhmkSJGd/lVaLGM52XNIhvrqG0t5Lm5kWOKNSzM3CqB/er4Q+KHxCfx7qv2awZv7Bsm+RennyL/ABt/s1ufGL4mTeKLyTwxoM7f2RG225df+W+P4d392vG440iRUT7q19plWV+yXtJ7v8D5nFYr2s9NvzJqhkmSJKfWr4T8O3PirVV8ld1lA3z/AO0f/sa9jEYuFCm5S36FYDBPEVOTot2dx8MfBr6rc/2rfxt5X91q+p7eGGKFURdu35ayNH0+HSrOOzhX5VXbW1uNfFTquc3Oe7Pu4wjGKhDZEzUK3/j1JuNc14k8P6lr9g1to+v3nhu/+9De2Yilx/syRTK0cit/wH60oSXVj1+yWNW8D+Cdch2a94Z0vUom/wCfmyhk/wB77yV5Jrn7KX7PHiFvO/4Rf+xp/wC/pd1NB/47l4/0rDvG/a48B/vrODw/8U9Mi/55xf2dqX/fvKpn/d3VteCP2kfAHizVv+ET8TW174D8VD92+l66nk7pf7sMxwP++9leXV9kdEOcTwb8Bbn4ZalbTeD/AIkeIJNGj/12kap5d1bSp/d3Lt8v/gK17PV64hmif56ptV0KXL8yqtW+nYbRRRXWc5LRUa1JViYUxqN1IzVvAwFptMamVoSPpm401m2VXoKiSM1QNTGptBY6m7qZuopSkA+imU+o5yAplSKu+vIfHXxi8P8AhKaTRNKjfxB4j/58LP5vL/67yL8q/wDoVdeHwsqr2/4Bz18RFep6VqGpWGj20t/qtylpaxfM8zsqoij+8zfdr598RfHS51rz7D4Y2nn2sXyPrt4mLVP+uC/elauV0/wT4/8Ai3qsVz4t/wCJ35f3NLhfy9Ks/wDr5b/lpj+7X1v4N+DOg+FfIvNYb+1L+D/Ups8u1t/+uMVcWMzmlQfs8LHml36IqGAnJc+Kdk9l3PnPwD8E/EPie8/4STW7meKW5+/q1/8AvLqT/rhE3+qWvsDwv4P8N+DLP7Noloqyt/rrh/mmkb/akatyS43/AHKhrzPqlStP2uJd3+COarj+WHs6SsidpqTduqvTtxr0lSivhR5W5//X8m8TfAn4o+GraObVdQ0vUrif7kEBkiV/9mOWRFjZv9ltteJzN9kvJdN1i0m029i+9Dcp5Zr9nJFSeFobqNZIpflZHVWDD/aVq8p8ZfBvwf4vsPsdxYp/sQv9yP8A65sv7yP/AICf+A1/RGT+IGIw/u4hcy7nw88DhKvl5o/Lpo0ZPkZW/wB2oWhr3/xx+zbrfhLzLnw3dvPB/wA8LvcU/wCAXSrs/wC/m2vDr6HWPD1z/ZviTTZ9Luv7twm3d/ut0av0/LeK8Fi/glZ9jyMRlVWl8GqK0NvWxHcQ2ybLb738Tf8AxNZkc0Mv+pk3VJt/hr6K541RXfvaeQjfPUm7+Go6Vfv0yCbaabT6irP2vmZDJPnrj/EEnyKn+1XV1xniJvnWn7fl6ntZXD94jnKfuqLdSbjXbHGqK3Pq7F6O6mgk3ws0Tf3lOP8A0Gu70X4peMtB2/Y9SeSJf4Lj96n/AI9Xmm6nbjWFevTqrlmkyJ4eEviVz2Pxd8aPFXi/Sv7Hufs9pa8b/sysHkx/eZv4a4vw3q0OmXivN/316VyG405ZK0y2VDDwdOmrJ7mVXBQlB07aM+xNH1SHU7NZoW3f3q2Y22V8v+E/Fk2i3Ox2/cN+lfQen6tbahCs0Mm7dXFj8Byvmhsfi3EPD1TC1Hpp0Z00c1Wo5qw45tlTRzV5E6B8jPDnRLJXQ2N5XFRyVejuNlefiMLzGNKUqU+aJ6la3W+uit7qvLtN1B/71dRb333TXy+LwHvH2WDxXPBS7nfxzb66DQdevPD14t5ZtuVv9dC33HH+NcBb3lbEdxvSvm8XgFNOE1oz28PNwleDsz640HxBYeIbBbyzb/ZdG++h/ustb+418a6XrmpaHeLf6bJ5Uq/eX+CQf3WX+KvpDwj42sPEsOz/AI9r1fv27Nz/ALy+or8wzfIamFvOGsfyPvctzhVbRlo/zO9optOr5o94KKKNxoAKetMp9BpGQ+jdTKfUnXGY7caNxptFBpcVWp+41HRU2HclopNxo3GkXGQtFFFA5BSbTS0UEEVFK1JVmUgplPplBAUUUUGQUyn0yqM5RCiiigQVMsmyoaKmUbjhOUfeR86/HT9mTwL8bLNryaL+x/EsafuNUgT5z/szp/y1X9a/HP4sfBP4ifBjVfsHi/Tf9Cl/49tRg/eWs/8Auydm/wBlvmr+hVW2VT1bS9K8Q6bPo+t2UGpWFyuya2uY1kjcH+FlbiqwWKr4KfNh3p1XRns0sfCpHkq/efzM/wC5UdfrP8X/ANgbQdX8/WvhBe/2Fe8t/Zd27NZv/wBc5PvxfjuFfmj46+HXjj4b6p/ZHjjQ7nRrj+B3T93J/wBc5B8jf8Br7DCcV0MR7lT3ZdnszV4bS8HdHEK1dNN4s1i+s10/VZ/7QigXbD9p/eSR/wCzHJ99f92uXP8AsfNRX02Hx86VpU2crpJ7q9i59oShpN9UNxo3V6X+sdRrknqiPZRNSGTyqc0nmvWX5lHnV68OLEqap9ER7D7R1sc1nB5Ez/vP7yViXE3nzM/3apeZvpa9LMuKZ4yEYRSSIhh+X3iamUykZq8eri1b3tDSxZqszUxpKSuDFZkpWUNLFKA/dRuqHdT64XjdNyrDtxo3GoqKx+teY7D6TcabTawniH9kdh1TLTo1tl/1zbv9lf8A4qo2uP7ldFCoqXv1H8hblta9X+Gfxs8VfCOa+ufCsiebfQ+T/pCbk/3tv+zXi2402ni+IHOm6UUrPR3M6uChVVpq6Oz8ZePvGHj/AFL+1fFur3GqXX/TZ/uD+6q9Frj6Zur6T+Dv7LPxQ+Mjx39nZf2J4eb/AJil+pjjP/XGP78v4fL/ALVfFYzOaVDrfyO2hhfsxVkfPunaZf61eW2laPbS3t/dv5MFvAjSSyOf4UVfvGv1T/Zw/YitNG+yeNvjDAl7qXyS22ifehg/2rrtI3+x9z13V9S/Bb9nL4ffBKzT+w7b+0NelT9/q12qtO/95I/+eSf7K/8AAt1e+SSV8tiMRVxkvf0XYuriIUvg1YxtkSLDCqqq/dVeOlRU6n1rCCiuVLRHg1Zyqyu2Mp9FFMiMQooooKCiiigsKKKKAGUUUUGoUUUUAOVqfuNNooAfRUe40zzKVirklFR+ZTPMp2JHs1RM1NaSmrVxiYz0F3bK+R/jN8WnuHn8JeG5/wDYubhe5/uK1X/jd8Yv7O83wf4Yk3XUq7bu5T+AN/yzVv7396vk+33xfvJvmlavrMmyrltVqr0R8zj8XzNwg9Fuaka+VH97733qk3VS85P4609D0281y/itbZW8rd8z9/8Adr2sXioUIOc/+HMcJhZ15qEF/wAA6Lwv4bufEd4qbWW1X77f3q+qND0Gw0a2jtrOJY/wrO8M6DbaHYRwovzf+g11u418XXxU68+eenZH3eHw8KEORP1LK0VGrU/c/wDGrL+FZG5L5lP8yk8t2qFldKTKhI04bx0rE8V+G/B/jzTv7L8a6FZ65ar9xbyLzDH/ANc5P9ZH/wABNS0+uWcIyNIysZWj6LZ+HNKg0TR5LlrC0ytul3cSXTxJ/DGs0u6TYv8ADuLba0qKburalDljykTmOptG6itSAo3UVGzVZmxWpm41HueoauMjEnZqhZqj3Ubqv2hQ5qio3U2qjIsKhantTKJSAKfTKgmura2haaaVYoo13M7NhVA/iZm7VcKDnsYTrKMbzdi1XOeKPF3h7wZpv9q+JL1LKL+BW5llP92OPqzV4j4m+OE2pzT6P8NYIbv+CbXLvcthE/8A0x/5+GX/AL5pfBPwT8Q+Mb7/AISTWL25u55f+Yvqg+f/ALdLf/lmv/fNaYrFYfBQUqsrvoluzP2VSuvcVl3Zl6x4y8ZfEO5j03Tftfh3SLv7ltbD/ia3f/fP/Hurf5Nex+Af2fbPToYrnxD/AKFa/wDPhbfff/anm6tur2vwv4L8N+B7Zk0e23XUn+uu5vmmk/3mroZrh5a+frVcVj/4nuw6JdRqrTw/w6vu+gtqthpVsthpVslpaxfKqIFVf/Haikmd6jplelh8JTpLlgjy6tec3zTdx9JuNNpN0ddRgSbqKho3baAP/9D7Yp1RbqfX6LI+EJo5Nn/AvvVyviLwP4V8S20lnqWnwSLIu1kdFaP/AL5b7v8AwHbXSUm40o+67xeppTqzjLmg7HxZ44/Zbs0hkfwZPNpf8XzFp7X/AL5/1sf/AI9Xyt4i8G+OfA//ACHtNmntf+f20Xzrb/v4v3f+Bba/XrzpE+5Va40/StQ/d3MHlfwts43Z/vLX1WW8Z4/Be58Uez3NJUqVf+ItX1PxxjvIZ/8AZqXdX6EeOv2ZfCviXzLzR4obaeT+O0/0Wb/vn/VSfktfK3ij4C/ELwq8n2CD+14ov4NvlXG3/dbhv+AGvvMv8RcJX/dzXK30Z52I4cnbnou6PI91R+ZVW4a/trpra8tntriP5XSVGV1/3lanfer6qOPhJKUHdHhzwk6UuWS1I5JK4nXpN7118tc3qVr51KeNPSy20aibOS3UbqdNazRcVX3Gub+0j6xcr+F3Jt1FV2mRKZ9oSspZ3Qi7OVmX7J9i7uNG41VWZKk3R10QzWnL3oNMnk8ibzNldXoPia80Wb9y37r+Ja4+mbjXZSzt0vNdjDEYSlXg4VFoz6p0fxJYarDvhl+b+Jc8itpb6vke11S5s5vOSXa1en6T48tnRYdSVv8AfT/4mvTo5hhMT/Ddn2Z+c5rwbODc6Sun0PdodS+etiG8315fp+sWGof8edyrf+hf981vw3E0VRXpeVj4jGZTyO0lZo9Ft77yq6HT9Q82vLo77vW5a6g6fcryMVQi/U8+l7Sg12PX7e+2VtW99Xl9nqm/77V1VreV8zi8LbofTYOupx5os9AjuEarlq3kXS3Fs3lSxNuV1O0qy/3Wrj4bqtWG62V4GIob9j1qEz6a8H/ECHUdthrEqxXX8L/dR/8Ae9Gr1bca+Ho7jfXqvg/4kTaY8VhrDebZfdWZvvxf73qtfm+b8PWvUo/cfWYDNfsT+8+kKKzrW8hvIVmtmWRZF3Ky8giru418W6bXxaHuQqxZJTqip9I1jIdT6iVqdUG6mTUyin1J0XGUU5qbQUPoplFBftCXdTlao6KmxdyWmM1M3GlosRKQUUyiqICiiigAooplUZE1Q0UUAPooooIGUUU+gzsMooooEJ5mysrX/D/hzxdpc2i+JtMttWsbgbXguY1kRvwatRlplZ1cPCfxK5pSxlSlLRn53/FL/gn94a1Mz6r8JtW/sO5/6Bt8zTWp/wBlZv8AWx/8C31+c3xD+DvxM+F121t448PXOnx5+W6RPMtZP92aP93X9FPmbKbdQ2eoW0lnqUCXdrOu14pkWRHB/hZWyGqqVXEYf+FLTsz1KWYQn/EXzP5iqdX7efET9iX4LeOPMvNEtpvCWoyf8tNN/wBTn/at2+T/AL5218ReOP2CfjF4cmlm8Jz2Xi2y/wCmLfZbj/v3N8v/AHzIa9KhxNBaV1Znb7KMvgeh8PUyu18UfDn4heB32eLfDOpaPt/jubeRU/4DJ9xvzrifMSvbpZrQqrRkSoTXQWil3LSbq6vrEPssysP3SUbqh3Ubqv6zL+YLEu40bjUW6jdU/WvMLEu403dTN1G6o+teYWH7qN1M3UbjWcsX5lWDdRRujq1Z2d5qd0tvpttNdzt91IkaRz/wFa4542nHWciowcvhRBTN1fRngf8AZU+OfjzabDwtcaXat/y86t/oUf8A5E/eN/wFa+zfAX/BOzR7by7z4leKJb3P/LnpKeSn/AppdxP/AHyteXW4hhtT1Zt7D+dn5UK2/wC5X0l8Nf2UfjL8TJoJrfRH0TS5f+X/AFTMEWz/AGY/9bJ/wFa/ZjwR8BfhB8Oo4/8AhFfCdjbXEWP9Lmj8+53Dv502969YaZE+5Xj18fja/ux0REsRSh5s+P8A4Q/sU/Cv4cfZtV8SRf8ACXa9F8/nXif6LG//AEztvu/9/N1fYKtDAiwwrtVflVV6KKiaR3oqaWCgvelqzz6+YOW2iFaTfS0UV1nl7hT6KKC4xCiiipKCiiigsKKKKoAp9Mp9BqG2jbRRUgFMp9Mqi7BTKKiZqsgezVCzUxmpm41cYgP3GmNJUbNUbfIm92rSMTKc7Fmvl340fGpNISTwr4SnWS9nUpc3aHPkf7K/7Vc58Yvj1/x9+EvBk/73lLm8T/x5Y/8A4qvkdWb/AF0zfvf9qvp8rydRtVr79EfN4/MpTvCD06s14/8AntM25m/vHPX71WPMrHWbdW7o8elXN/aW2q6hDp8U77d0rfe/2a93EVeSDqTeiPOo0ueahDdm54f0O8168VEVvKr6k8K+GbPw9bKibWn2/ex92rGk+HdN0C2VLPbL8v3+u7/gVbqtXwmKxU8TPnnt0PvsLhYYaHJDfqzRjqwtZ8bUl9qVhpFm15qVykEUXzMznHSlCEn7sVccqqjuzcWvKdc+BfhvXrmS80fxX4q8KXsrf8w3Vrgw7v8ArjcFx/6DWv4X+IWleJbyezsI38qL5kmb+P8A4D/DXe+d/crGdWSvGLsd0YbOS3Pn24+HP7UPgn/TvAPxGs/H9pF/zC/EdusMz/7K3H97/tslW/C37R1nHrUfgr43eHbj4beKpv8AVfa/+Qbcf7cVz/D/AMCZk/6aV9C2986fxVW8R6P4V8b6RJ4e8Z6Tba3p0n/LC7j3KD/eRvvxt/tIRXnc8zUtTW7xPUTVy3hPwfZ+AtNbQdE1TUb3Q49v2O01GVbk2Sf88YZmXzWi/uq+dvauo3b66KVVtc1rETI2plDNsqPzK35zIkoqLzKN1P2gEu6q7Nvpm6mM1VGRlIfuNNambqY1VcgGptJuNNp3AN1JuNLUHmVrDyVw5rElIzbK5/xJ4q8PeENKk1jxJqEOn2Uf8cx5dv7ka9Wb/ZWvnbWvHnjnx/8A6B4VjufDOjXP/Lby/wDibXif9MI+lurf3m+eut+zpQdSq7JHPFzrO1JHrPjL4seG/B0n9mv/AMTTXG/1Wl2e1pz/ANdO0S/7T14nH4f+JHxk1j/irLTz7D+DQ7R2jsov+vubrM3+9+CV7X8M/gDbaRD9s1tfsXm/P5O/zLqX/rtM3NfS9ja2GkWa2GlWyWkEf8KDH/fX96vGq5piMR/u/urv3NOSlh9Z6v8AI8w8D/BnQfDXkXmvbNSv4PuQoNtrB/dWOH/Zr2Ca6+TYnyqv3VXjbVJrjfUNGDyqFL35avuzjxWYVavkhzNvpaZRXrnnhRRTWbZQWNlqOhqZTsZD/MpGbfTaNxpgf//R+0N1G6o9xpvmV+l2PieQm3U6oqfQHs5DqNppu6nUFRgJ9z7nNOm8m5Tyb+BbmL+64pKfWE4Ke6ubw93VPU878WfCnwT40hlhv7RfmXajNy6f7sn8NfJnjT9lnW9K3XPhi5+0xf3Hba3/AH1X3vUitsrOhKvh3z4ebXl0PSWN5laqk0fjZrHhnxDoc2zVbR7Zv9scNj/aWuUkh3v++r9m9a8M+HvEMLQ6lbKrN/Gv/s396vlbx9+zHYS+Zf6Jv/vb7Yf+hRNXvYfjavS93ErTuZyyvD1daWj7H59TQzfcRWrCuJLCJ/8ASZfm/Ovc/FHwz8VaGk/2ixaew/6Yqw/77WvL10nSv4LRVlX7ytu+X/vqvaocRyxCfsmr+ZhPBTw6vUTt5HGSXWj/AMCv/wB81D9qsP8Ania7GSGGD/Uqi/hVVv8AbkrO+K+1NfcTDGR7M5PzLL/ni9Qs1t/dati8ms4H/wBf5v61ltdW3+VqPrEPh9or+h6UPQq+dt+5S/an/uVK00NM82Gsva1IfBX07Gv/AG6R/aKFkp+6Gm5irDnqc3N7S7H8i/a6hNbPvRmXbXomk/EK/g2w3n+kr/e/jrypmhpnnba97AcZV8L7lWV12OHF5XSxCtNH1RovibR9T2+TP5cv/PF+Grt1kevimO+2V6HoPxG1XSv3Mzfa4P7k3/xVfXYXirBYnTmsz4HNuB38eHfyZ9RQ3myul0/WNvyPXjel+OvDeqov+l/Zp/7k3H/j1d3Z7J086GRZF/hZWU16s4xnC6d13R+eV8FXwk+acWmj1i11StqG+82vK7W4eLbvrpLe6evmcVh3F6qx7GFxUJJcr1PRY777vzVpx3iPXnsd5WpDeOleJXoHpQq2PX/DvjTVfDk3+jN5lr/Hbt0/4B/dr6E8M+NtH8Qw/wCjS+VP/FC/yuv/AMVXxvb31aEd1NBMtzbSNHKv3XRsGvl8xySFe72fc9ahipxtyPTsfdytvqSvnrwj8Uni22HiH5l+79pX+H/fWveLO+tr6Fbm2kWSKVdyspyrV8FjcvqUJcs1p3PoMLjI1V2ZoU+q+6lVq4LHdGZZ3Gn1XqXcazsdMKo+iiig3uMop9MoHGQ+imUUF3H0UUVJQUUUyqJCiiigAooooJYUbjRTasRLRTKfUEBT6ZRQAUU+igLDKZtNPooIlEh2mmNVmmVVyJRK+6n+c9O2momjo91ke8tnYbcMk8LQ3EaTxN8rI4Vg3/AW4rzTXvg38IvFX/Iw+CdHu2+7v+yxxvz/AHWj2sK9J8umtHWDy+lJ81te51UsfXjs9D5W1D9if9nXU3/c6Fd6f/17X0w/8dbfXnuqf8E8/hHdv/xKvEOt6f8A7LPbzr/49Gtfcnl07aar6jDuzqjm9TqfmxqX/BN+zHOlfEP/AIDc6b/7NHP/AErjrr/gnL4zX/jx8caTP/12guI//Qd9fqx+8/v0xvO/vUfVZ/YkP+139pH5E3H/AATv+MCf6nX/AA9J/wBtblf/AGhVVf8Agnn8af8AoM+Hv/Aq4/8Akev1/WR0/iqZZHo+qVf5jT+1v7p+Q0P/AATt+Lr/AOu8ReHov+2ty3/tCuhtf+CcPjP/AJf/ABtpMH/XK3uJf/Qtlfq7ukqJmf8AvU/q8v5w/tXysfnBpv8AwTd0hf8AkMfEGeU/9O1gsf6yTNXoej/8E+PgzYjGq6treqN/13hhT/yHH/WvtndN/epP3396sfqX99i/tWXY8B8P/sh/s6+HPnh8IQ6hL/f1GWa6/wDHZG2f+O17nofhvwl4Yh8nw3olhpEX920t44f/AEFavbZKkWOn/ZtPrqZf2lWZd+2VH5ztUO009VroVOEfhVjnlXct2HzvRtqbbRtqjAKKdT6CxlPop9QOMQplFFSMKKKKACimUVRYUUUUFj6KZTfMoKJaTcaiambjVWAmo3GodxqNpKdguSSSVUZqVpKrtJWsIClIlZqi3U2uO8WePPDHgewa/wDEN8lsvO1M7pH/ANlV/irppUJzkowV2znrYqnTTnN2R2LNsTe7ba+Kvjh8dodT+0+CfBkm6L7l3eo3/jsdea/Ej49eJPiC8+laDu0bQfr++nH+0y/+g14azQxfcr6jAZV7GXPV1ktl2Pl8Xj54j3Y6L8y/H8n8W5qZJfbP9qsC81KGxhaa5k2qv3t1eU6542vNVuf7H8NxM0svy7+//Aa9yXs8PB18U7I5MPg6+LmqWHV+77HZeKviFDpH+h2befef3F/gb/aro/g/8L/FnxL1iLXvE7Tf2av975V2/wB1VrqPg3+zPeahNB4k8bfLF9/yH/8AZq+8rOGz0yzi03SoFtoIPl+VelflWd8TVc2qfU8FH3Or7n6nl2SYfKaXtarvPz6FjS7OHSrCDSrb/VWyKi7jnpXJeKvi18PfAE0EPirVPIaRvuQp5si/7TKteTfF743aV4Ds5LDTZ1n1ZvxVP/r1+besa1rHjPWJ9S1Kd5JZ3+83NfdZfkOHwGFU8XL0XU+XhiquPrudNWj37n6m+Jv2mvhXpWlfb/D2rf2zPIvyQIrK/wDwLd92vj/UviR4/wDjJ4ngtvNeCwWb5LeH5a8HsdLh3xWaR+ZLJX6S/s9/CtPDWm/29qUe66uV+Td/BXy2c8V0aVP6rg46y0be6R9jlfD1OE/rWId7bI9q+H/g+HwlokEO1ftsiDzmX/0Gu9Wo6kWvDwsOWmgxFXmm59ySp1aoKVWrpOcs1EzUymtVRkZsKZupm6jcaq5Nh9MZqi3UbqZIUxqczVB5lWZSH1GzbKg3UbqAJGao6Tbvryjx18XPDfgyb+yoW/tfXJPuWNo6s/8AwLstenhctnVfZLdnDWxsIebfQ9OmuEgRnmby1X5m3f3RXgHib42fabmTQfh1Y/2/qMb7JrvftsLX/rpN/wAtNv8AcSuKt9B+JHxnv/J8Vedbad/0C7B2jtv+28vWVv71fVngn4N+G/CtnB9vjS5aL7sCriBP+A/xVy4jOadOToYKPNLq+iN4YB/xMY7Lol1PCPBvwd17xnqUfifxbqD6zf8A/P5dx7bW3/2bKHp/wL9a+tfD/hHQfCqf8S2DddS/665m+aR/+Bfw1uyTJsWGFfLiX5VVflCioNxrOlgOf367uzLF5pze5T0RO01Qt89Mp9ejCCWysePzXCmUUVQiVafVeiqKJPMqOio2alGJI9qjpm6mNIlXYhzJdxpa5LXPGnhvw9NFbalfbb2f/U20KNLO6/3lhXnb/tfdrRj1r7ZDv0q2+3XC7G8lZFjcI38TK33RVckox5mtGEdfh1P/0vrz7R71J5yVjeZspfOr9TsfH3ibXmU/zKx1mqws1RIuMjT3bqkjasxZqseZWUpGpf3U6qiyU9ZKgVi3Ruqv5lPVqzZSJfv1GsjxP8jVJuqFq5ZmkTC1jw/o+uQtDeQJG7fx4/8AQlr528afs86TqsMjw2iT/wB1s7f++ZOq19Q03dtrysRl+vtKcmmux7OFxc4x5Jq68z8qvFHwX17w88v2ZfPVf4LhPnH+63evHtQ0l4Ha2vLRoG/ut8tftjcWOlagnk6lB58X/j1eaeKPgP4e8Q20lz9khW1/vXP7vZ/tbv4a1oZvjcN/F95GtXCYWv70PdZ+PbabZxf8sKiaG2RPkjX8q+hPih4R+GPhi5/0DxfZyXS/8uySfatn/ArffXztNqGm+cyWzNcqv8SI3/s1fVYDNsJNc82k/M8Orha8Z21ZFlP7i0jMlV21Kz/54P8AlUf2zzf9TbP+VetDMMLL4X9xX1ep9pEjSPVRmerG+5/59mqq32n/AJ4NWn1yl/SN4IdtWo/LSoWkf/nnUfnf7NZfWMO+prGEi4scP92p1tbZ/wCGq8MlXo971pLLaUvet8zCcpLqQyWcP8FWrObW7H57O5lj/wBx2WuwsfAfiTU7P7TbW27+783WsW60vUtMfydSge0/3lxXLSrU8NO0J2ZHNzx2ujobH4meMNM+S5n89f8Apsm7/wAer1Tw38XNNu5Fh1X/AEaX84//ALGvAPORPk83dTW037T89ttWvrcLn1SNvbao8HG5BhK/2bPutD7v0/VLa7RdjL833WU7hW9HcV8KeHfHGt+FZvJf97B/zxmr6S8J/ETR9eRdkvkTr/y7u2P++f71ehVhSrrnoO67HxWMyjEYO8prmj0a/U9pjuK0o7r/AGq4uO6Tf8jbq0I7yvn8RSM6FVct4u6O0juq6/w34w1Xw9NvsJ9sTN80LfNG/wDwGvK4brfWrDcV52Iw6lFwmro64VeU+x/DPxM0fXPLtblvsV638L/cZv8AZavTFk31+fi3Fej+GfiVregbYXb7bZLj9zM3K/7rV8jjuH+tL7j1aWZOPxao+wtxp615/wCG/H2g+I0VLafy7r/n3m+V/wD7Ku6Vq+VrYecHaas0e1h8UpfC7ltWp9V1apd1csonowncfSbTS0UGwyn0yigsKfRRQO4Uyn0UBcNtO2mloqRCbTTGqSmVQEbUlOptWQOoWin1ABupNxpaKAGU+mUUEj6KZT6ACiiigBlFFFBNhtFOo2mrFYi21FVijbRcCvto21Lto207gQ7Y6Npp+2jbVANpNpqXaabtouAzaaNpp9FADaKdTtpoAFWnqtLRUAOoooqACiiigsKfTKfQAUUUygofTKKZuNBdh9G41FuoqrFj2am7pKj3Ubqdih+6iot1M3VdgH7qZupm6mM1VGIrjmaomkqFpKTdW3szNzH1BNJDZwy3FzKscEClnd2VVVV/iZmrxX4jfHjwf4A3WHmLqms/8+lu6/I3/TZv4a+G/HnxU8bfEab/AInd39m077yWdv8ALGv+9/eNezhcnqVIqVR2T6vqeNXzeCbhTV2vwPpH4nftQabpyT6J4AjXUr3lGvH/ANTH/ur/AMtK+O9Y1bXvEd/JqvifUn1CeX/nsc4/2dv8NYytDbJ93dWLq3iCw0xPOvJ1j/2ermvscvy9v3cLGy6t7s8Wt7017TVvZLob7Tbk+95e2uM17xxpukJsSTzJf9naa8t8ReOrzUN1tYfu4q6H4b/B3xN8Q7+P908Fh/HNXkZxxHgsrg1fml+p9NlXC9fFPnq6LsYdnH4t+JGqrpulRvLu/h/hX/er9C/g/wDAHw94Cs4tY8Qr9r1Hh/u9K7LwH8O/DHwy0qOGwtllvf4n6ndXb3En+jS6rrdykFrAu997bUr83/23PK6eI0hfRdz7Gri8PltP2eHWvVmhNqn2n7n7i1j/AOA7tv8Adr5X+Mn7QFnoEMmieG5PNuvuO+6vM/jR+0N9u83w94P/AHFr/Hcf3/8Adr47aSa+m+03Lebur9MoZdhcop/D7/RHxsqFfHz56ztDt3NDUL6/8Q37X95O0jSt/FW1Zx7dsMK1k28Pz/J96vp/4N/CG/8AE1/Bf38H7hfmr884lz6ct3dvY+6ybK1KHZI7b4C/CW51W/g17VYP3EX/AD0FfoXbww20MVtbLtWNdq/8Brn9D0mz0OzisLNfKiiWt5Wr5nAYKal7Sru/wOnH49S/d09kW1apd1Vlal8yvcPKLe6jdUW6nbjVxiQP3UbqZRVgFRM1G6omaqJF8yoGakZqj3VZjIf5lMZqZupJGhgRri5kWCCNdzPIVVFH+0zVvSoObstznnUjH4mLXOeKPGXhjwZZ/b/EOoJbL/CnWST/AHVWvF/Gnx2h86TQfh1H/al//wA/+3/Rov7zL/erkPBvwX8W+P8AVf7e8QtNdyzv893c7hGn+zHur0q88FgEpYh3fRLdnDGOIxEuWkrLq2Ra58VPHHxDuf7H8HxvoWly/Jv+9ez/AO7/AM8/881618Pf2cbaxRdS8Q/uPN++n3p5/wDrpL/dr3vwb8PfDHgS2/0CBZL3/lpO3JJrsJLh3ryMViMXmfxLkp9Et2dEZ0MH8Gs+7ILOz03SrZbPTbZLaCL7qotKzb6bTq9PCYGnh4KEUeXiMVOrLmm7tjaduptFdljnHUbqKKmwBuo3U3dQ1FhSkOoqHzKbuosRzkzNULNWVq2taVo1nJf6rdw2lrApZ5pnWNFC/wB5mrwXVPjZf+JfPtvhdpaXtlF/rtf1Jmg0qL/rn/Hcf8B2r710Rovl55aLvsEG6r5IK7Pbde8RaP4csJ9V1i+hsrW2+/NcOqov/AmrxrVPHniTxPa/8U3J/wAIv4f+RP7a1GPbeXG7/nwtfvfN/C8nzekdZnhPwDeeJb+DxDfzyeMr+L54dX1T9zplo/8A042X8X+/83/XSvoXSfCuiaNef2rc/wDE01n/AJ/bv5jH/swL9yJf93864quYwvyUdX36HZDL/Z61nr2PJPCvwxv5fPuP3+jWVz881zdt52q3n/TRt27yv+B7n9kr2LQ/D/h7w0kkeiWKQNP80033p5W/vTTN+8kb/erXmuHlf71Q1Xv1f4jMJ1f5Ef/Tr6P+1FZ6zc/av7A+zaT9zzvtG65/2m8vbsX/AL6r6E8O+KtB8VWf2/Qb1Llf4k6SJ/vL/DX4zW9xc2c2+zZ4Ja9D8O/EDVdFvFuYbl9PvY/+W0J21/S/9i4LFQ5Kb5J+b3PgsVha0J80NV26o/XNZHq0s1fJvw//AGiLa+hgs/Gcf2aVv+Xy3X903+9H/D/wGvpyxvrDU7Zb/TbmG7tZPmWaEqyN/wB818hmuT4jCO1VadGtmOhjISly3s10NtZqsrNWNuqws1fPvmPQhUNrzqlWSsVZqtLNUG8TVWSnq1Z6yVaVqylIqxZ3UVErU/dWE5GsYjmqKn7qKxkdMSC8m1W2s2fQbK2vdRb/AFK3k7QWyf7UzRq8jbf7qDc1eDeJv2fvEPxQu/tPxj+Jd9qln/rE0jQoFsNPi/3Vm8zd/vMm+voDdUUjPXBVwvO7zfyN6dRx+E8m0r9n74F+E4VTS/BdndyL/wAt9SZryT/yL8n/AI7U2rfDfwZqsPkvp8Vsv/TCOOJU/wB1Vr0aWqzR1y18toT+NHRSxlSOzsfHnjD9meGfz7jRJ/Mi/u/xr/8AFV8j+LvAut+Erlobn93B/fYMtfruy1x3ib4e6D4ztmttY3fN/H/drlpQxWC9/DO67Hof2jSr+5iF8z8Z5NS/6a1DNqif3q/Q3xJ+yH4Y/e3Om6h/wF1Zf/Hq+dvGHwF/4RWFpnuYJ9vvX0uH4oq1bR9i16nmVcvwsdqiPmyTUKp/aHlrq7y3sLF2hSNJNtZMl1D/AHfKr2eTET966SOf3F8KuUv30X3121djmTZ975qq+ZD/AMtpKr+cm/5K9bD5lCl7s3cUoc3Q9E8N+MtS0B/3M7eV/d3V9T+E/F3w98cW0Wm+M4Ibbd/y8btv/fVfEkfyPsvN0H4VpWsk1jMs0Lbq9ivhcBj4clVa91ujy6tGdKfPSlZ/mfdutfso6JqMP2/w3qn7iT7nzK1eG+JP2e/Hmg7prCD+0Il/59t29f8AgLVd+Gfx41jw1NHZ38/mWX93+7X3L4T+InhvxbZq9td/vf7uf/Za+JzHhTMMJ7+Cq3j2ep0UeJqamqePp2fdbM/LTVrHW7H9zrent8v+zh65v7P5Un2iwn+7/t8iv2H1jw3oniGH/iZW0N6rf9M1P/oVeJ+JP2b/AATq26502L+y5/78Hy/+O15eF4rxeD9zEQ2Poo4PC1/epS0Z8WeF/idqWmeXbar/AKTF/e/jr6P8O+KtK8Qw/wCgXKs393o3/fNcN4m/Zl8W2MLTWE8Grf8AkOb/AArwfUtB8Z+BLz/TLG7svL/iZGH/AI9X2uV+IGAxf7rGe6+jPl844D3q4bfrY+445K1IZK+WPB/xo/1Vn4iX/t4Tj/vpa+i7PVLbUIVurOdZYpV3KyndXvYjDpLmptNPZo/PMRhK2HnyVVb9TrY7ip1uK5tZqmjuK8oxjI6yG62P8jfd/i/iH+7Xqfhv4oa9o8awzS/2la/3Jm+f/gMleIR3FW1uq4cRhIVPdkjelJp+6z7f8M/EDQfEaKkM/kXX8VvN8r//AGVd9HJur87obzynWRPlZfmVt21lr2Twv8WtV0/bbaru1CBf4/8Alsv/AMVXy+PyH7VL7j2sLj5x+PbufWqtT9xrifD/AIu0fxDD52m3Kyf3k6OP95W5rro5N1fMVaLhLlmtT3sPilP4WWaZRuNG41idVwp9RbqN1BoS0VFuo8ygCWn1Arb6WlYB9FMopgFPplPoICiiigAooplABRRRQTaQUUUUBYKKKKACiiigAooooAKKKbuoFKIUUbqZVkhtpyrTaKAH0xqKKAGUUUVZY+imUUED91PqGipsWS7jS7qhoZqVgJt1G6od1G6iw7E3mUbqr7qN1VyF2LG6od1N3UUrFWHbqKi3UVdjQfuo3VAzUm6nYCdmpm41B5lM8yqjACdmpnmVD5lIzVfIZynb5CtJUMjV5z42+Kng3wFDv8Q6kkc7fctk/eTP/uxrzXxx42/ac8YeI/Ms/B8H9gWTZX7S22S5P9I69TC5VVq6xVl3Z4+KzWEdFq+x9meNPiV4S8BW32nxDqCQN/BAn7yeT/diXlq+J/iB+0d4w8Y7tN8MK3hvS23Lvz/pkq/7Tf8ALP8A4B+dfP8AdSTXdy1/qVzLe3srbnmmbc7t/tM1Mk/dfPN8te9h8vhC3Irvv2PJnVnLWq7LsC7E3feaVvvO3zFm/wBqoLi8htk33Eqqq/7Vcdr3jjTdM3Q237+X+6v3f+BNXiuseJdQ1eXLycf3Fr08RCjhv3mMl8jswWW1cRZQVl3PUPEHxEhtt0Olfe/v9a8mkm1XxDf/AMc8s/8AwKup8E/DXxP47v1h022dov45v4Er9Afhv8EfDfgCGO/uV+26j/ff7o/3a+A4h8QKlWH1XBqy7I/Qct4eoYRe0r6P8WeLfCP9m/zfI1vxmu2L+C39f96vtTT7ew0GzWw0e2WCKNdqqgpi+dcvsT5Vryn4jfF7wx8OYfJ8xdQ1n+GBDlI/+uleJkfClfH1f5m929kRm2fe57OKsuiW7PTtY8ReHvCGntr3iq9W0gX7i/xyMv8ACq1+evxk+PWt+Pbz+zdOb7JpEf8AqYIv4v8Af/vGvM/G3xC8T+P9Sa81W7eT+4n/ACzjH91a4+O3SKv0SrXw+U/usN70+r7HhUMBOf73EfJGc0k0Em+/gatGz2XcypCy7m/4DV+zuH+W28vz93y7Oua9t+H/AMBbzx5f/wCk79Nib72xf9XXwmZZ7KlN+3d2+p9VhMrdVcy0SPR/hD+zz4k1zUoptV02aLy9svzj5Nn+9X3/AKD4ZtvCtnHYWcax7fvf7Rr500X4eftGfBWP7R8JvEcPjjw/F/rdA1L5Zf8Atl5h/wDRMi/SvevCHxJ0f4j2E8o0650DxFpu2PVdEvEaO5tpG+6219vmQt/C9fN4XC/vPaVHe+x14rFvk5IaJHW1YWq241IteyeOWlajdUX36K2sBY3UeZUO403dVAW/MpjSVX3U7caAH7jTahaomkqoQc/diZVaqguaRIzVXaT/AParA8ReJNE8MWDalr2oQ6fB/Dv+87f3VVeW/wCA184+IviZ4w8a/wDEq8HwXGiadc/uftH3r+6/64R/8st3/fVetOhSw1P2mIdjyvrVSvLlpL1fY9f8cfFzw34J/wCJan/E01xvuadB8z/9tNv3a8bj0/4i/GLUvs2t+b9i/wCgXafu7aP/AK7yN96vSvh7+zX5SRal4k/4lP8AHsR/NvZf+uk3/LPdX1Xpem6V4asItN0S2W2gi+X1P/Amb71ef/bWIxP7vCx5V3K+q0qHv1Zcz7djy/wL8EfDfhW2gfWIobm4i/5d0T/R0P8A7NXsTXCInkw/LEv3VXiqDXDvTPMrpweTQpe+9W92zkxWYTq+7suyJmptR+ZTfMr14xPNH0/dUHmVHTsBa3Gm7qr0jU7Bcs7qPMqpuNN8yqsS5pdSyzbKg8zfVW4vIbOFpppFVV+Zua+UPid+1Z4V8K+Zo/hL/ioNW+5+4P7iP/tov3v91K7sFldXEvlpq/n0OCWKc5qFNXfkfVeqa1pWgWEt/rF7DZWsH35pnVQP++q+UvFX7T39p3k+ifC/S/7ZnX795P8Au7eP/ab2/wB6vmKPS/id8bdYW88Wz3Fzb/fh05P3aJ/wH+H/ANDr7R8A/AfR9Ghgm1tfM242WaJ5dun/AAH+L/gVcmY5lg8BP2NP95U/BM+iwvD85Q9piXZdurPHPDvw/wDEnxG1KLVfEk9x4tv4/wCC5/c6Jaf9s/8Al4/75r610P4Y6Pp3kXniaf8At26g2+TbbPLsIMf887ZePl/2t1dpb/ZrGFbazjWKKJdqqv8As0rSO9eN7LEYv38U/l0RvVx8KXuYeNkvvZoyXX8H3V/ur6VVZt9VqctejSw8IKyR405yn8WpNTlptFVKJmf/1Pzjk0nXoLCDWLnT7i2sLndsuHRtj7fvVXhm/wB1q/Wv4gfDGz8UTT6ron+iajc/8fEPW3uP96P/ANnTbJ676+BvHnwbu9MuZHsLb7Fdf8+3WN/+ubf5b2r7DK+PZ+09lj01LzMfqFLEQ5sPK/l1PG7fULm2/wCPOT/gFeqeB/ihrHhq8Waw1KWyl/uf8s3/AN7s1eMzR3mnXLW1/G0Eq/wtUjMktfrmV8UP2fJpKL6M8DG5ZCXuTVn36n6S+Df2jNK1PyrPxVbfZJW/5ebb5of+BL1X/gNfRlnfWep20d5ptzDdwSfdeF1YH/vmvxZsdQv7H/jzn/4BXqvg34teIfCV59p03UH09m++n3oJP95aWKyjBYz3sP7kuz2Z5H1WvQ+B3X4n6ubttSxyV81eC/2jtB1XyrbxVH/Zs7f8vKfNC/8AVa+irG8sNTtlvtNnS7t5PuvC24H/AIFXyOYZLisK/wB7HTv0ZpQzKEpcmz8zXjkq8slYqs6VbWSvBmepCRqrJUu41n7qfurlOqmXdxpPMqruNLurKRvEseZQzVX3U7dUSLH0baZupVm2fP8A3a55ykWYvjHxT4K+HGir4g8e6xBo9tP/AKhH3SXNx7Qwr+8b/wBBr5lb9pvxV4zuZNN+B3wx1TxD/cvrtH8sf8Bh+Vf+BTV9CN8OPh1fa9P4n17QIPEWs3L7/ters16U/urDHL+6iRf4URa9Bk1qZLZbO2VYLaP5UhhHlxov+yq8LXH7XEehrOhS+1qfHX/CE/tf+OP+Rj8SaT4Aspf+Xe02yTf+QfNf/wAjVzFx+xq+p/vvFXxIvtZn/wCuTf8AtWR6+05ryaX79VGkd6wnQr1fjn9xUJ0qXwo+Jrr9ivQdn+h63K3+/wDLXlHiz9lubw4m9Lmf/tsn7v8A76X/AOvX6W7TR5jbNj/vIm+VlbkEf3WVvvV5uIy2vD+FN/M9ChmUP+XkE0fixrHgufw5c/8AE1tNsX/PXfuib/gVZ8ckMSf6NAkH+13r9bPEnwn8Ma/Dc/2b/wASuef78PlrLay/9dIWr46+IX7Or6L/AKZbRPZf9cd0tk//AFzb5pI/91t1dmF4ijh/3eNjbz3uXPAQr64d/I+PryG2+/8AM1RQteWPz+U3lV1V7bXmkTS29vpks0sTf67ysRj/AL5/+KqvJ4e1rUH+069d/Zv9n73/AI6vAr6SlnlOLXsnfzPO+oVNYTRjK0N4/wC5by66PRde1vw1crNbTvFtrnLzS0ik/wBA3SVWjvryx/czfd/utX22C4hnFLn0PKxWCjK9N6rsfenwx/aQhudum+Kvl/6b/wDxS19e6TqlhrVst5ptzDPE38K1+LSyW0/7yz/dt/c/+Jr1fwL8XPEngmZfJuX8r+7nI/75r18VluHzGlzwtc8D6hUw0ufDvTsfrAyo/wAm2s688O6JqsPk39sk8Tfwuqla8f8Ah78cvDfjGGO2v50sr+T+8eH/AN1q9u/24fmVq/K844a9lJxqLQ97Ls8n317Hz54s/Zd8B+Id1zYQf2Xdf9OzY5/3a+cdY+D/AMVPhdcteaDJ/aGnfn/30tfozHNsq0t0+zY/7xf9qvKwtXG4D/dp6Poz26uLoYqHJiIJ36n5zeHfi1pt3N9g8SQf2Re/3n/1Jb/e/hr1yGZJUWaFlaKT7rK3Df8AAq9l8cfBPwH46hk86xSyv5P44k+Td/tLXx14o+HfxI+DE3naaz6hpEv8HzSw/wD2NfX5fxXTnaGJ0b6nyWYcJc954bp0PaFuNtWFuK8e8N/EjStZdbW//wCJbe/xQz/Lub/ZavSY7hHr62UNFODuujR8JiKU6E3CommdCtxVyG6rm45qtxzVz1CoTuddZ6pc2ky3NnI0Eq/xo2Gr2Tw38bNVsdsOvR/bYv76cSD+jV88RzbKsLcJXn4jC06vxq51Q93WLP0E8O+NNB8Tw79Ku1lb+JPuyJ/vK1dXur83be+ms5lubORoJYvuujbSv/fNe2+GfjlqWn7bbxJH/aEH/PwnEy/7y9Gr5nF5G1rTd12PYwuZfZqL5n1p5lLuNcroPirw94ltludHvYbn+8mdsif7yt8y10W6vDlSlH3WtT2oV09ncsbjRuNRUitU2NbkqtT9xqDdTlalY0LG40u6q+6nVNgLFFQ+ZS7qmw7EtFN3U7dHUlBRTdy07dHQAUUUbo6ACms1MZqZuq7EWHbjUm6q+6jdTsRYl3U9Wqvup26iwWJt1M3UzcabuosVGJLuopm6jdVE2H0UzdRuoCw+imbqduNBVhaGpNxpu6gkKN1NplBViXdTWamUU7ByBRRTKYWJqKZTKAjEfuopm6kZqLGlhaN1RbqN1XYCXcaNxqLdTKLFErNTPMqOmNJV2JJ9xpu6od2+mSSJF/Ftp2M51VH4iTdRXiXjj4/fD3wJ5tteah/aGoxf8ulp+9fP+0y/ItfIfjb9pbx54t8yz0FV8N6c38UJ3Tuv/XT+Hd/s162HyevP35Ky7s8fEZvTXwK7Pt/xx8WPBPgCH/ifagv2r+G0t/3k7/8AAV+7Xxb48/aU8ZeJvNs/Cq/2BYN/H965b/gX8NfOrSTTzNc3M7XMsnzM7tkt/vM1M87f99lWvfweX0aX8Ncz7vY8mvXqSX72Vl2Q6aaa5uZLm8ne7nb5mdzub/x6l+0f3/3S1xmseMNH0j9zDP8AaZf+mPP/AI9XkeueNNS1X+LyIv7qV6Nd06Xv4iWvY6cBltarbkVl3Z7Hq3jLR9G/1Mn2mevINe8balq7/wCs8uL+7XJL51zXt/w3+BPi3x1N5yQfZLL/AJ+Jh/6DXx2a8bU8NH9zp59Wfd5Rwhd88ld92eN2em6lrFyttZxtIzV9hfC39meadINb8Z/6NB/z7fxvX0n4F+Efg/4eQq8MC32o/L/pDjP/AHz/AHa9MkkmuZK/P+fF5rPmk2l+LPpMVi8Pl3u09X3eyMvS9N0fQLOPTdEtEtoIl27UVau3UltY2ralrE62lrGu7c//AMTXnHxA+L3g/wCG9rLDNOuoasy/JBD2b/aavgHx18WvGHxCvJPtl88Fl/DAn3K+3y/hKjhaXtsY+WPRdWfC18yxWMm/ZfNvZH0R8Wv2kPI8zw94Dbb95Hu+rv8A7v8Adr4qury51O5lmvJP3v8AHvPztVmGzSL5/vNVmS3s77/j5Xb/ALa9a7sVxDV9l7LDrkh9zZ2YTAU6XW8urMuNfK+41a1jp95qFyttZxefL/d/+K/u1a07RL6N/OFrNqOmQfPcPbL++SP/AD+Ffo78BvhR8KfF2gxeIfCesJrVrZfvLnTv9VfxzN/z99wv+58r+tfH4zN/c5MOrt9ex9Bh8IufnrPTt3PDfhD8CbnV5lvr9fLiX78+3gf7K192aLoum+HrNbDSoPKiX7zd2/3q2ZLdLbyra2jWOCJdqRouAAPu7aRY68bC5byz9pVd2b4rH8y5KeiRftbqaD7jVYupku5luZo1eeJNizYy4Q/w7qorVivV9mt7HmXHLRuptFaxiSS7qerVDRWgEzNTFambjRQTGRN5lLu31AteWeMvjB4b8MXLaJo8T+JPEf8A0DbP5vL/AOu0n3Y67sPltSrurLqzlr42Efdvd9j1G6vLaxha4v50to4l3MznaoX/AHmr578VfG5JfMsfAFj9tlXck2o3C7bSP/c/56VxkOi+PPizqX2bW5Hvv+oXYPtsrf8A6+Zv4q+o/CPwX8N+HEgudYjTUr2D5kh+b7NE3+yrfepSzWlSfssGuZrd9EcjoOVqmKdl0R83+EfhL4y+IOpL4k1ud5P+n+8H8H8S28P8NfYvg34f+GPAlt/xLYPPv2X57uX5pG/3W/hrp2m+6n3VX5dtQNJUwyudeftcS7v8Ec2IzH3PZ01ZF2a431SaTfUe6ivcpUIwVkrHkylcfRTKN1bDHbjTd1FMoAfRUTNSbjTsZOY5mqPduqOaSGBWmmZVVfmZm4Uf7zV8++PP2jvBnhX/AEbR/wDic3v+w2IE/wB6T+L/AIDXbgsur4h2opt/gjlr4uEeuvY+gpGSJPMmZVWvBviF+0N4G8D206faf7QvY/4IXXZu/wBpv/ia+HvFnxm+JXxbv/7H8Oedc+b/AMsbQNFAn+9/e/Wu9+GP7Meq+IbyLUvEkn9r3v8AwL7LB/vSfxf8AqMyx+X5arYifPPstkd2E4dxGLtUrvkh57s4fxN4++KPxuvJLa287S9B/wCeMO5d3/xVe8/Cf9lnykg1LW1+zRf7a/6S/wD8TX134R+FvhvwTDH+7S5vYvuvt4j/AOua/wANdrNfP9xPlr5Cvm+Z5p+7vyU+y00PpfrWEy6Hs8Ite71uYui+F/D3hWzWw0e2SPav+zV5pK47WvG2m6Vf/wBj26vqmst/y5WnzSpu/imb7kK/7Um2tux1zR9RvJdNhu4f7UtoUmubTfukiDf3q9HB5ZSwq0W/XueJXxtau3ObNKin0V6ZxhQtFFAEnmUvmVFRQB//1foOHXPD18//ABLdUtLmVfvLDPHI4/3lX7tWdS0vRPENm1nrcCXKy/Lv27v/ANdfkloPii88OP8A6Puj2/dmX7619S+A/wBoL7N5Vnrf+lxf3/8AloP/AIqv6Fzbw4oY+h+6anbp1R+Nz+v5dU9pQd0up6F48/Z1sdXhkezg+2wfN/10j/3W6/5+/XxR4q+C/ifw5Mz6V/pNv/c6P/8AZV+p3hvxho+vWy3+j3qT/wC63KN/td1ro9Qs9B15PJ1vT4Z/M/5bKOd3+f8A9dfiuL4czbK5v6rK67PSx9jlnHtDE/u8bGz7n4c3DXlpN9mv4HglX+F021NHMjp+++av1H8afs86PrkMk2lRpexc/wCjv99P93/P418aeMP2fdU0yZh4bkf/AK87v5d3/XOT+KurK/ECCqexxsXCSPsP7Pp14e0w0rpnh1vJeW//AB5z7v8AYr0Pwf8AFbxP4QuVfSrt7b/pnuyh/wCA15pcWt/oOoNYaxbPZTx/wTDbU6rDP881fruVcV8vuu04Po+p8/i8BB+7UR+l3w//AGhNH1y2gt/E+22nb/lun+rb/eX+GvoWG4truFbm1kWeJvuuhyG/4Etfila6heaVNvs5/lr3f4d/HDWPDVz+5ufKX/njNzC9dOOyLCY395hXyt9HseByYrCax96K+9H6fbnSn7q8T8H/ABw8K+JfKttS/wCJTet/fb9w/wDuyfw17Arb0V4W3K33W/vV+d4/KcRhZuNWNj18HmdKqtHZ9mX/ADNlHnVR3GneYleQeui551SrJVDzKdupSiaF1pKFkqoslP3VlKIFrcagpm6n1NiwpNppaKCA20zbT6dtrGUQK+2pFk+TyXXcrfeVulOoWsatGE48k1dFRm1K8XZnGat8P/Cur7n8j7JcN/GqKR/usrcMv+zXzJ8QP2bYf3upaV/on+3afNav/vQ/8sv8/er7P8up45Hi+433vvL614OIyWEdcO7P8D16GazXu1NUz8c/Eng3xD4VeT+1bTy4l/5bJ80f/Am/h/4Ftrjbi1huU/ffL/vcf+PV+ymueCfDfiGFkv4PIbaV3Q/Lw1fJvxC/ZasZPMvLPesX3t1tyn/Aov4ay/1hxGG93Ex+aN1gMPX9+k7PsfnRceTFN+5k83/P96pIbh0/1y16v4i8H3/hC8aw/s+H5f8Al73f+zN0rlbHT7vXblrTw/Zfa5V/11192OL1fc33f95q+tyrPakbVoS06JHHjMB7KXJMybPUprZ99tJ5dfU/wt/aM1Xwy8em+If9O07/AHvmSvmjUPDcNt/x53/9oSfxypxG3+7u+9XP7rmzb51r9EwHFmHr/uMfHRniYrJudc63XVbn7TeG/FWg+L7Bb/Qb5LuJv7rfMn+8v8NdOtfjb4P8fa94Rv47/Qb5raVf++D/ALy1+gXwv/aK8N+LPI0rxJ/xK9X/AL3/ACwkb/e/hrHN+DJezeIwD5odlujzo1p0Pdq7dz6bWnbkaFra5jWeJvvK6qwP/fVV1ZH+eFty/nUn3q/L8XhLXhNHuYXEN2nBngXxA/Zv8E+MfPv9EX+yL/5m+T/VOf8Ad/hr5evvDPxO+F159mvLb+29Lj/2vn/4C1fo992ory1sNTha21W2W5ib+FhmoweNxWD/AIMtOzO/FewxkPZ4lX8z4R8O+PPD2vyfZ/P/ALPvf4ra5/dv/wCPV23zpXa+PP2c/DfiNJLjR9vm/wByYt8n+5Iv3a+drjw78Ufhu/2aH/ic2Ef/AC5Xf+sT/rjJ/FX2WA4moV/cqaM+QxvB9rzwruux6qs1SLNXmui/ELRNam+xvu0u/X5Xtrn92+f+Bferulb938lfS8l1zRd0fH1aU6U+SorM11uKnWasFZqnWasvZkXNuG8ubaZbm2neCVfuujMr/wDfS1614d+N3i3StsOpbNXt/wDb/dzf99L96vD1uKnjmrlrYeE4++jelUa+Bn3L4Z+MXg/xDthe5/s26b/ljd/u/wDvhvutXqUcyS/PC27dX5mfJL8m3ctdbofjrxb4V2/2PqTNB/zwud0sX/xS18/iMmh9h28j2aWNqLzP0K3GkWSvm7wz+0BpU/8Ao3iq0k02X/ntD+9hb+q17npPiDRNeh+06PewXq/9MXVv++l/hryK2DnS+JHqUMbCXwvU6TcaXzKqK1G6uX2Z1xnct7qN1Vlkp3mUuQstbqKrq1SbjU2KJqKiVqfUgSM2+m02mM1FgH0m41FRVWAfTKi3UbqqxJLRUW6jdTsBLuNG41XoosUWNxo3VXoosSWN1PqvuqRWpWAnoplFSUPplFMagkKKj8ykq7AS7qRmqDdRuosBJuenbqZTKdgJPMo8yoaKqwEu6mbqbuo3UWAKKj3GmtVEOdh/mUnmb6qNJt+d2rz7xh8VvBPgSHzvEOrwWjfwoz7pT/uxr87V0U8POb5YK7OStj4R6nptZeoalYaZC1zfzpbRRfMzuVVV/wB5mr4i8XftaXl8klr8PdGf/r81H92v+8sK8t/wIrXzH4k8WeKvF83neMNZuNS/u2+7bAn+7CvFerQyeW9V2t0POr5hVl8Csfd/jT9qLwboPmWfhtX8RX/8P2fi2Vv9qb+L/gFfI/jT4yfEbx75kOpah/ZunN920sv3Sf8AAm++3515dGv9xViWsvUNc0SxXff3Pzfr/wB8172Dy9x/gQ17voeXL2k5Wm7+SNGOGGL+Hd/vVHcXFtAnnTSqsS15XqnxIjX5NKg3f7U3/wATXmmpa9qWpt/pk7NXRiJ4Wl72JnzPsephMmr1enKvxPX9W+IWm2e77Av2mX/xyvMtW8Zaxq3yTT+XB/cTgVynzvXa+Fvh34n8X3K2+iafLc7vb+tfHZrxlyQcIWjFH1mW8LwveEbvuzidzy16h4B+Evi3x7eLDpVk/lfxTfdRf+BV9kfDf9k/TdIhg1j4hT/9uyV9S2sdnpFmum+G9PSytYvlXamK/O55visfU9nh03fqfXewwuDXNXab7Hz34F/Zz8H+DEjv/EP/ABNNR/ufwJ/wGveoZneGKw02BYIF+6iCuP8AFHjTwZ4Lha/8W6unm/8APtbtukf/AIDXx/8AED9qTW9V8zTfBkH9jWH9/wD5bPX2uV8Ewj+8xL163PlcdxRXxP7vDR0/BH1z4w+I3gzwFDI+vagsl7t+S2h+Z2/3v7tfGXjz9pjXtc/0Dw9/xK4P1/76r51uLjVdXma8v5Xllk/jdt26rdnaWEitb31o/wD12i++K+snmWGwFLlwUVfq2eXSyt1ffxErvt0ILqPUru5+06q27zfm+Z87s1YhjT7iLUjafd6bNHb28n9qWs/8EXzOv/Af4a9V8E/CXxV4tmg8m2m8qf7iIuZn/wB7+6tfCZjn0P4leV5dj6ChltSXuxVl3PMbexubmb7PbRtJL/dX/wBmr3/4e/AnXvE80U15B+4/75jWvqfwH+z3oPhxIrjXv38q/wDLtCeP+2jf/E19EW8NtaQrbWcSwQR/dRVwor5uvVxWNfvaLselD2WG92Cu+5xHw5+Gvh7wKnyL9ruGX59yfIP91a57xh+z/YXmtf8ACwfg/q//AArzxpB+8323Fhd/7M0P8O7+LCsjd469gWrKzPF/FXXh8LCkvcOOviJ1XzTPOvB3jrxBrc0vhn4j+HpPC/jS0Te+xd1hfxr964tJuU/3o93y/wAu8qzcXHnpsf5l3bse/wDe9qrba6oGIUbttG6mbqYFjdQrVV3UbqqMrAXaN1VPMpk1xDBC00zLFFEu5mZsBVH8TN/CK7cPg515e6jlxGKhS+Jl3ca5vxR4y8N+CrH+0vEN8lsv8Cf8tJD/AHY1/irx3xB8YrnU3k034bwJe+V/rdaudy6fB/1x/wCfhv8Ax2l8B/BnXvE9/wD8JJr1zNe3E/8ArtW1Ebv/AAFhb/VpXTisVhMuajU1n0SOGEauJ1jourOR1jxp48+Jb/Y9O87wzod39yG0/e6nd/8AxuvYfAP7P9np9t/xOIP7Gs5fv2du/wDpM/8A183HX5v7te+eHfCfhvwdD/xKrZZbqX793NzM/wDwL+GtiSZ5a4v9tx/8V8sOyFPFUMN7lHV92RWNrpujWcem6PbJZWsf3UhXFP8AO3VFTa9/CYCnQioRVrHiV8ROrLmm7sk3Gm02jdXcYDqN1N3UynYCRqSoPMqPzKdifaFndspu7fVfd/G9eO+PPjd4J8CebDNd/bb+P/l2tirbf+ujN8kddWFwdSvNQpK78jmr4qEfVntdePePvjl4J8Cwz232n+0tUi/5drd14P8A00k6L+rV8HfEr9qLxP4l/wBB0qf7FZf88bY/+hSffb/x1a8a0Hwf428fzb5v9EsP4p34r28XgMvyqHtc1q2fSK3Z1YDJcbjPgVl3PTviN+0N4q8d3P2Pzf8ARf4LC0+7/wAC/vf8D/Ksrwb8H/EPi+8g/wCEn8/9/wD6nTbb5p5//sfyX3r6p+E37LkNsqahdR/YY/8An8uYt07/APXOFv8A0J/yr7K0Hw34Z8GWzQ6JbbZW/wBdcv8ANNK3+3J/FXwubcZY/NYfVsvj7Ol5bs+phgsDla5p+9P8jx74b/AnTfDmmx/2xBDZW/8A0Drb/wBrzf8ALT/dX5f96voOOa2s7ZbPTY1toIl2qqBRha4rxJ400Twzps+veIdQh02wtvvz3Mm1P91f7zf7K/NXzxrHxa8Z+Lbae88Kxf8ACG+F/wDoP60m25l/68rL/wBBZ93tHXDgOHqGH/eVPm2eNis0xGPn7i0/A958YfELw34RSP8Ati+8u4n/ANRaLukuro/3YLdf3kleTXniLxt4q/4//O8G6NP/AKm0hdZdYvP+BRbvJ/3Idz+si1D8P/hjqU839t28U1t9r/1+v63++1W6/wCuMMv+rX+752P+uVe+aT4f0Tw9uexjae9b793ct5tzJ/vSN2/2V2rXo/2hD4cMr+YqWVwpa13d9jz3w78Pby2s/J/5FfTpP+WNp/x/yf78v/LNm/4FJ/t16Np+l6Vodt9g0q2WCLd5n953c/xSSNyzN/eq3JI8v8VMralhftz1ZjOv9mGiH0+oafXRYyCn0yikQPoplMqwP//W/P2RaqKs0T77ZvKqddQs5/8AUzr/ACptf0LgsZOlJTpS1XVHxa54e7JHUeGfHmveFb9bm2neDb/dNfafw7/aK0rU0js/FS/ZN3/L2o/d/wDAl/hr4CkXelU1a5tn/ctti+9tzxX1f9qYfHw5cdHXut0eZjMjoYn39n3R+09nqEN9DHf2Fys8TfOjwtlW/wB1lq3qUem65D5Ot2SXP/Tbb8//AAL+9X5VeAfi54h8NXkX9n332Zf4rd/mhf8A3lavuHwT8dPDfiHy7PXv+JTft/fP7iT/AHZP4f8AgVfC8S+H1PEU3KynDut0fOwnj8qqXg3+hY8ZfBOw8R2bfY1TVLX/AJ9p/vx/7sn+sj/8eWvivxt8AdS0OaV/D0ky/wDThd/LJ/wFukgr9PIWhf8AfWzf7S7WqTUIbDWbb7Nrdol7F/f2KJE/+K/8davxmtwzmGWT58FO67M++yvjylibU8ZH5n4lXEd5pFz9j1W0a2lX+8uKjaSGev1M8bfAnR/EttK+mtDqkH/PF/8AXR/8C618SeNvgDrGhzSTaJu2r/y73HyuP+BV62T8e8k1TxqcWfWVcqp1Y+0w0rrseR2uqalov/HnP5kX9zrXtngX9oDxJ4VeOG3ud1r/AM+l3+9h/wCAt/DXz1eW+paPc/ZtVtntm/usKVWhnT7vy/7NfrOE4ihVhyTanHsz5rFZRD4pqz7rQ/Ufwf8AtBeD/EaRQ6x/xJLqT+J/mgf/AHZF+7XtkM1teJ9ps50niZfldGVkb/dZa/F61uNSsf8Ajzn3f9Ma9F8H/FrxD4Quv9GuZrb++m/dE3/AaznkOAxd5UJckuz2Z59sVQ+F8yX3n6vbqk8yvmHwT+0RpWubIdbX7NLx86co1fQun6lYalCs1nOk6y/dZGyK+NzLIa+Efvq67o1wue0Zy5Z6PszcVqfuNU/uUvmV4x7sZ38y6rU7dVFZKm8ygotU/dVfzKl3GucCaiod1P3UAFFG6is5RAsUq1CrVLWUogOak3fe/wBqlp9cleinFqS0ZcJ8vvRPB/iV8C9K8f8A+kwt5cv/AD7P8sb/AO0v91q+PfG3wX8T6DZtpulN9mtY93/Eun/d+Z/20/5af8D/ADr9NaS4WG+h+zalbQ3dv/dlXOP930rwaWAq4SftMJK3k9Uz3lmkKsOTEK/n1R+JdxZ3mmXP2PVbF7K4/wBtcbv93+9U8kcM/wC5fbKv96v1K8YfBPw34ltpUttnzf8ALC7+aP8A4C38P+fmr5H8Zfs463ozyf2Jvgl/54z/ALyF/wDrnIv/ANlXs/6yqXuY2FvNbGEct972mElfumfK1x4fhf8A49pNrVkL9v05/nX7tekapout+HJvs2vWj2k/95l+R/8AdkX5DWUzQy/J/wChV9BlWb18NPnwVTbzMK2Hb/jxsewfCv8AaM8Q+DvK03Uv+Jppf/PGb76f7rV+g3g/x94V8dWa3nh67WWXb89s3+sT/gNfkJdaTbS/c+Vv9mpdJ1bxJ4VvI7/TbmaBov44XYV9n/aWAzf3MbHkn3WzPFq5RUofvMO7rsftL89LXxn8M/2pobmGDTfHK+ZL9z7SnEn/AAJf4q+s9H8RaD4ltvtGiXyXP+zuw6/8Br5nNOFcVhrzSvHo11OWlmtO/JV0fmbH3aqX2n6bqtr9j1W2ju4G/hf/ANlb+Gp2V6N1fJ1cOpXhNHsUq8o2nBnhHjb4CaL4gtmNhIsvX/R7vqn/AFzuF/eLXzrqngP4l/D7/jzk+02v/PpqXzf9+bla/QHdSsyTwta3MSzxN95HXch/4C1Thfb4X+DJ+h0150q/uYiKa7n536b8RrPzvsHie0m0K9/gW4T92/8AuyV6EsiSos0LK0TfdZeQf+BV774y+DvhnxfYSWaf6N5n/LFvmT/gH92vkbXvgz8Rfh9czzeD7l57JfvW7fNH/wABzX1uF4xpS9zErlfc+cxvB/P7+Glp2PQlk2VMtxXidv8AE650x/s3jDTX0+X++g4r0bR/EWia9Dv0q+S5b+6pw/8A3y1fUQlCrDnpu67o+NxWX18O7VItNHWLNU63WysZt6U3zNlYTpSM6VWJuedUlvcXNm63NnO9tKvzb4XaNv8Ax2sNbj/aqTzq4/fidmn2lc9i0f40ePNF2pNdpqkC/wAF6Mt/38XmvZNB/aI8PXLrbeIbS40Zm/j/ANdD/wB9Lyv5V8erNTvMrknhaU/jj80dSqzj8DP0t0vxBomuQ/adH1C3vYv70Mit/wB9Kv3a2t39yvy2hke2m+1Wcj206tuV4XaMq3/Aa9O0f4zfEvRUVE1CHVIF/gv49x/7+LtNcE8p/wCfb+/Q7IY+a+NXPv1adXyxof7S1n8qeJ9CuLb/AKbWbrMn/fLbX/8AQq9a0X4vfDrXtqWeu20crf8ALG5f7NJ/3zLtrz6uAqw+JaHVTx8H1seprUtZsN1bSpvhZWX+8vzKf+BVZ3bv4q4XA64V0+pZ3UymtTKUYm1xzNUVFNrSMRDqKbRVFDqKbRQA6m0UUAFFMp9ADqfUO405WoAs0VErU+sgBqZQ1MpoAptJuNReZWliSak3GotxqNpKqxNyzuNM3GofnqSixM5xXUduNR7qoXV9Z2MLTXk6QRL953dVC/8AAm4ryTxJ8fPhd4a3Jc6/bXM6/wDLG03XL7v+2O6t6WFnL4Fc5KuOpx66ntH3qb+7X77V8PeJP2vk+aHwloE07f8APa/PlJ/37j3M35rXg/iL42fFrxajR3mvtptq3/LHTR9l4/66L+9/8er06eUVPtuyOOWZOXwL5n6UeKPiF4P8Fw+d4k1a20//AGZpVVz/ALsf32/KvmvxR+194etN0PhLRrnW2/hmm/0WD/x7dI3/AHzXw8tqm9ppv38rfedzudv+BNUNxcW0H8Verhcnpdrv7kcFfET+0/kexeKPjx8VPFu5P7ZTQrJv+WGmp5b7f9qZt0n8q8h+w2zTfan3XN1J9+aVmZ2/2mZq4/VPGGiWL/6xZP8Arj8xrh9Q+JF+/wDx4QeV/vfNXpVKFKh/Emkuy1ZvhcJXn8Efmz3CaaG2h3zTqq/XaBXD6t480fTk2W0n2mT/AGB/7NXhuoa5qWpvvvLl5ayN1eNX4iwuH0oRu+7PYocPuf8AHfyR3+rfEDVb75Lb/RIv9iuJkunnffMzNVvTdH1XWLlbbTbaW5lb+FE3V9T/AA7/AGR/HPi3bea3/wASmy/2v9ZXyOZcZVZe5N+iR9TgskUF7isu7PkhVeWvW/AvwT8c+O5o/wCytLm+zt/y2dGCV+jXg/8AZx+F3w+/0/Vdl7PB/wAtrtl2J/wJvkrO8cftLfDfwPD/AGb4YlS7lj/58P3i/wDfX3K8zC4DM8y+CPIl1Z0V8fhcL8HvvstjmPAP7I/hLw95V/42uf7Uuv8An2T5Ur6Ha48K+DdP8mwjtNIsoP4/lXb/AMCr86PEn7VXxC1h5IdE2aere3mSV4brXiLxf4qm87xDq805/wCm8jf+i69KlwvlmD/eY+rzyXToc313MMUuSmuVeR+h3jL9pL4b+HtyWdy/iK//AOnf/Vf9/Gr5T8aftOeOfEv+jaPs0S1/6dv9Z/38rw+10eOWT/UXN7/urtrvNH8E+ML5/J0rREtv9vZuf/x6u7/XDC4ePLhYJeYqXCz+Kq7+p5/Jb69rEzXl/wCdJ5n/AC2uC3/oTU5rXTbH/lp5jf8AfVfTPh/9nHxz4h/5Csk3lfkte+eFf2WdE0ryptS8nd/31Xz+K4sq1elzv/sqnHrofA+l6Hr2uP8A8SrSZpP9t12pXung/wDZ58VeIZI/7Sn/AHX/ADxtv/iq/QXSfAPhLRtvkwfaZV/v/c/75WuoWTankwqsES/woNo/8dryp/W8T/EfKu3U19th6XwK77niHg/9nvwl4ctl+0qsf99E+Z2/3mr2yxs9K0iz+waJaJZQf3U/i/3m/ipzb3oVarD5RSpS5933ZyV8fOel9Ow3bUy0yn16RzktPqGn7qkB9N/gpu403dQQFN3U1mqtJJW1KlKq+WCuRVrQhHmbsS7jSN8n32rk/Eni7w94SsG1LxDqENlF91N5+eR/7saryzV4fq3jjxb44b7Ho/neGdIn/wCW3l+Zqlx/1zX/AJZbv++q9OWDpYZe0xTsu3U4Y4yeI9yhG/meo+NPitonhJ102GCbW9cuf9TpdgvmTv8A73/PNf8Aerzu38M+PPifqX/FW/vYvv8A/CPWD/6NF/1+zf8ALT/gX5V6t8O/gb/ZX+nzed4dtb3/AI+fnaTUrv8A67TN93dX0bp9rpuh2a2GiWyWMC/3er/7TN/E1cP9r18X+5wceWPfuKdClQ1qu77Hn/hH4S6DoHkX+vbNQvYP9TAibbaDH91f4q9MuLx5fkRdqr91Vqg02+o2auzLchp4f3t292zysVmNSekdF2FZqj8ym7jTa+iseVck8ymt89NpjNVxiTcWimbqRmqrE3Hs1RbjTfn+/XDeMviN4P8AAVt53iTUkgn2/JaJ+8uZf+ucK8t/6DWtKjKbUIK7fYyq4qPzO3X568+8dfE7wb8Podmt6h/p7fcsIf3lzJ/2z/h/3n218d/Eb9qDxDfefZ6J/wAUvp3/AAGXU593/fSQ/wDAc/WvknWNS1W5828mk/suC5f79y/m3k/+1t+/X0H9kUMLD2uYT5Uui3Z0YTAVcS1GC+fQ+lfiZ+0x4h1zz7Cwn/sayk+5aWb+Zcyf9drj/wBlTH/Aq+TZm1jxHfrbQ/NLL92BOf8Ax6vS/APwb8SeOLmP7NbPZWs//LaX/Xy/7q1+lnwl/Zp8K+B7Zby/g3XTbfnf5pf++v4a+JzvxF5r4XJ4WXVrdn2OEybC4L95iJXfY+OvhT+y3quqzQXmsW373/nh/wA8/wDakb+Gv0R8E/CXw34JhiuJlS9v4PuOybUi/wCua9v9771dhfa94b8K2LfNDaQR/e7V8k/Er9rjw9o039m+G4H1u/l+SFLdv4/4f71eBlXCGLxk/rOKu/N7I4cfxlzv6vhFfyR9balqyQQyzTTrBbxruZmKhFH95m/hFfL2ufHL/hJb658P/B/T4/E1/bf8fOrTt5GjWH+3Pcf8tP8AdT86+abpviL8W9bgtfH8l3qH8cPhDQv3f+79vm+5br/103Sf3RX114V+Bfm6bbQ/ESW3j0u2+e28M6T+50yL/rv/AB3Tf7Uny+1enjcyoYS1Kj7030WyMMLkk5fvcY/keV+GvCOqeMdcj14Sf8LK12D/AJjV+vk+HtK/vfY7f/lt/wAA/OvpTw38O9B8PXi63r07+KPEa/8AL5d7dkH/AF7xf6qFf90bvWu8+0Q2lstnYRpaWsS7EhhCqFVf4dq1n7t1cNLLa+J97FP5HRiMxhS9yireZauLyaX77f8AfNVGbfS0V9HTw8KStBWPCnVlOXM3dirS03dTq0JG1LTKbQBYqNmpaKCQoqLdRQB//9f81bjTXg/1K7l/Wo7e+mg/2l/u10W16hm0+Gf76/8AfNfrVKtUpfI+ejjFL3Zq4trfQz/xbf8AZar8kaSp/s1y9xps0X3P3n+797/vmm2+qXMHyfe/3q9HD5opS13Ingr+/TZtzW+9NlWbHWL/AEzyk/4+YF/5Yv8A+yt/DUMN9Dc/cb5v7rVM0NfRYTM50JqdN2OSf8lRaHvngP44a94c8uHTZ/Pg/wCfC5+7/wBs2/hr7L8F/GTwx4v8q2mb+zb/AP59rjv/ALsnRv8APFflx9hSVP7tXrPWtS0jbvbzLdf++v8AvqvW+sYLH/x1yz7rqfN43IadX+Do+x+yP+3bt838v++ar3X2DU/3Ot2gk/6bKi7v+Bf3q+Dfhv8AHrVdKhW2vJ/7Qsov4Jv9cn+61fYfhP4geFfGNsv9m3aef/zwfiRf+A/xV8XxHwPCVN+2hzQ6NHj4XNMbltS12rfccH42+Cuj+I7Zv7Njhu4uf3M3+dy18ReMvgXrGh3Mv9jxPBL/AM+k/X/tnJ/FX6nQ2/zb4W2t/eVqg1K1sdTh+x69p6XsX97o3/Af9qvxjEcM5hllX2mAlePZ9D9Py3jWhiYKGJXzPxQuo7/SrlrPVbR7adf7ysDV2H7Ncw/P+8r9QfF3wJ0HxHbN/ZP2e7/6dr/hx/1zmr498Zfs66lpVzJ/ZXnabP8A8+979x/+uc38VerguOp0v3eNg4vue/LLKWJXNhZ38up4NH9s07/SdNlr0jwf8XvEnhi5X7NcvbdN3/PN/wDeVq831TSfEPhy5+x69aTWn4fI3/Av4qp+dC/3/wB5u/8AHa/Ucm4l54aNTXZnzWYZOnpWjr36n6T+C/2gPD2sQwQ+JF+xSt/y3T5ov+BdxXvlveWd9CtxYXKXMEv3XRlYf+O1+L1vJeWL+dYSf8Br0nwn8XvFXhOZXs7l4P1if/gNehiOHsFjffw8uSXbozyqVDFYb4HzLt1P1c3U5ZK+YfBf7SGj6rDHD4gg8iVv+W0H3P8AvmvoHR/EGia5bfadKvYblW/uncf++a+RzDhrG4a8pxuu6OzD5vTk+Sej7M31arayVQ+5UytXy57Cn1LytTt1U1apFZKAuWqKi3U/dQK5LT1aq+6lVqiUS7lvcaVWqpuqRZNlYygTGRPRUHmUeY9ZuBsS/dp7Tb4WhmVZ4m+8jhSP++WqPdRXNOkpJqa0NaU2pe69Tjte+H/hXxCkv7r7N5i7XXb5kT/8Bb/7Kvmbxh+zLZ/vZtKg+xf7dp+9hP8A2yb7v/jtfZHlx09WdfuNXiVcoUZ+0w7cWerSzKduSoro/JvxF8MfFXhp/wDj2/tCD+F7fdn/AL9tzXn7ff2XK7dv8LV+y99pularH5Oq2ST7v4sbX/76WvG/Fn7P/g/xKjPbbIJf4d/Vf91lo/tPF4b+KuZd0dsY4ev8Ds+x+XN1pcM/zw/u2/2a2NH8YeMPCsyvYXrt5Xv/AOzV9GeMv2Z/GGhu02j/APEwt/7vf/gLfxV8+aloOq6PctZ6laPaSr/DMmK+vyfjPl/hzt5HPj+HoV4fvEmj6R8E/tYXltts/Ftt5/8An+9X1R4Z+KngbxYi/wBm6lCs8v8Ayxc7Wr8oprG2n/13y/7VRLDqWlf6TYXf/fJr7GljMvx/+8q0u6Pj8Rw5Ww9/q0ml2eqP2i2u/wA6fdpvz1+WfgP9oDxn4QmiT7d9rtf+eNx8y19oeCf2kvAfiryrbVZP7EvW/v8AMP8A31/DXPmHCM4w9phJKcfxRhTxtSGmIVvNbHvyybKk8xJU2TL5i/7VVre6s9RhW5sJ0uYm+68Lqwb/AIEtT+XXxlfC/Yqx+89Ghi+sGcJ4m+GPhjxajfaYkiZv7yLivmbxV+yzf2zyX/hX5dv/AD6S8/8AfLV9qbdtTLJ/tV5tLCzoPmw02vyPW/tTnVqqTR+aMy/FfwZN9mv7T+24IP76NHOKtaf8VPD12/2bUt+m3X3WS5TA/wC+q/R66t9N1FPJ1W0hu1/2xz/31XkPiz4D+APE8MmyJrKWT+LZ5n/oVenS4oxdD+NG67nm4jh/BYj3oe6/wPn6G+s7xN9rIk6/3kbd/wCg1Y8yua8Qfsx+OfDtzPeeDL3zLVfufZ5WVv8AgUbV53ca18S/Bz+T4n0b7bF/fxtf/vpeP0r6HC8TYPEe5ez8zxMVwliqXv03zI9t86p1mrynSfih4Zvv3N+02ly/9PEfyf8AfS16FY31hqCedYXcFyv+w6tXrRhzrmg7ryPFq0KlKVpppmx5lSrJVP56Ws5UJroY+1iXt1QyRwy/JNEkn+8Fam06stejsa+6y/p+paxozq+g6vf6R/16Tsqf9+2+Su/0v43fFTSHXzruw123X+G9g8mX/v8AW/8A8RXl7VH5lROPP8diocnofTuk/tSeV8niTwpe2396azljuU/75bY9eiab+0d8MdQ2+dqj6e3928t5Yf8Ax7bivh77R71G0iP/AArXL9Uoy6WN/bz6SP0j034jeCdX/wCPDXbCf/duI/8A0Fq6uHUrOf8A1M6Sf7rqf/Qa/KdobN/+WCbv72FFTRzTQf8AHtczQf7rstT/AGXS72K+v1V0P1d8zfUlflvZ+MPGGnf8eGu3kH+7KwrrbX4zfEux+5rbyf8AXURyf+hLWMsp/kki45lP7UT9G6Zur4Jtf2iviFB/x8/ZLn/eiUf+g100f7TWvf8ALbS7Zv8AdZqz/smp9lof9qr7SsfZu6jdXx5/w0xqX8elwfm1OX9py8/6A361rHJK7+FfiH9s0ex9iUV8i/8ADTM3/QGT/vtqk/4aVuP+gND/AN9tU/2Hie34l/2vTPrak3GvkNv2mLxP+YND/wB9tVeT9p6/T/V6FC3/AG0al/Y9ft+ISziPY+xFkp3mV8Wt+1Fqv/Qupu/66t/hWVcftReKv+WPh+2/4FO3/wATQ8mq+Rl/bUPsps+6d1Rs1fnpeftOfEWX/j20+wg/3vMb/wBmri9Q+P3xmvv9TqkFov8A0xgX/wBmrWGST6yQ/wC0Ksvgifp0zVVur6ztk33NykS/7TqP/Qq/JrUPiB8UdV3fb/Fd/wDN/CkrRj/x2uHvPtl9/wAhXVrmf/rtKzf+hV0xyan9up9xP1vEdrH6x6t8Vvh1o27+0vEVhBt/h89S3/fK15brH7U3wo0zd9mvbnUpf+na3bH/AH1JtFfm0um6b/B+8b/gTVMtukX/ACz2110srofYTbOKriK1uacrI+ytY/bG3/J4b8Ns3+3dy7f/AB2P/GvJdc/aQ+MGubks72HRov8Ap0iVW/76bdXh7SQwff8A8Kw7rxholj8j3aN/1x+b/wBBr044BUve5EvU46V6r91uT8tjrtW1DxJ4jm87xPrN3qjf9PErN/470qrDYpB9zav6V5fefFBE/wCPCy/77f8A9lWuPvvH2vX3/Lz5H+4P/ZutctXGUKX8SfyR7VLKK8vhjZeZ71cX1hZ/PNKkS/7TbR/49XJX3j7RLb7n71l/uc14NcXlzcvvuZGk/wB47qrqu+vKxHFWHpfwo3fdnr0eGpP+I7+SPTdS+I15P/x5weX/ALUnzf8AjtcRqGualqf/AB+XLyV0Xhn4Z+PPGMvk+G/D9/qH+1DC2z/vr7tfQ3hv9jP4kan5b+Ibmy8PxN/z1k86T/vmLj/x6vmMdxm+sreSPocJw4ofBG3mz5A3Gr1ppt/qE621nA88sn8Ea7n/AO+RX6eeE/2Q/hrou2bxDd3Ouy/9+IT/AMBX5v8Ax6vonw74V8GeDIfJ8MaNaab/ALUMS7/++urV8vVzivV/hr5s9b6pQpfxJfcfl94N/ZV+LXi3yrmbTf7Espf+XjUT5X/kP79fU3hP9jvwNoflTeKtWn1uf+5bp5UP/wAU1fXEl9NL/FULNvrD2FWr/Fl8kX9chS/hRt5vU8v1bxR8E/2ftNtofsXk392n+iW1tbtNPPt/8c/76NfO/iT9pz4xeOJpNN+G/hR9Pg/gmeJrmb+XlL/49X2NqGk6bqsK2upWkN3FG+9FmRWVHX+Jd1aNvH9nTyYdsSr/AAoNo+X/AGVrrwteph/93SXn1MKvsq/v1235dD82L74R/tG/EF/tPiq+m+b/AJ/Lr/2mvFTWv7H/AIwn/wCPzVoI/wDgDNX6UU1o6uvi8zr/AMSt8kRF4el8FM/M7Wv2W/ip4TT+0tBtrTxRax/ft9i+Z/37b/2Vq9j+Bfgr4CfFT/iQzef4Z8bwZ8/Rrz/lpt+99laTlv8Acb94v05r7UhuHgf5K8w+KvwS8J/FqFdVtpP+Eb8Y2uHs9ZtvlffH/q/P8vBZfR/9Ynb+7WP1f/n5r5lfXZ/Ydh8Pwb8DeFbr7N/ZbSMv/PZv/ia66xtdKsfksLKGDb93aihq81+GHxa13UNb/wCFG/HeP+zfH1j8mkapJ/qNUT/ln833Wkb+B1/1n/XT73rl5ZzWMzQzLt2/LXTSwlGGyscs8XVl8criNcO38VQtJvpNtO2muiMeU5ZTuC0tFSKtae0CxPRRRUSkMdtoooqSwqNmp26qrNvoIJPMpPOpFj3/AOzXkfjL4taD4evP7E0T/ioNc/59LaRf3f8AtTyfdjWvUoYCck6k9Et2zgrY1K0IK76JHpt9qVtp1tJdXkqwRRruZnKqB/vM1eAeIvjFf6u8ulfDq0S52/f1S5DLbR/9c1/5a1SsfA/jb4qXkc3iG5+2wf8APjabo7KD/rpL/wAtGr6d8J/CXw34ahje/iXULqLbtTG2CL/dX+KsHnn/AC7wUbvuZ/2dye/in8j598D/AAf1vxVef29rck17et/zEb37if7MEf8AD/wGvqrw34N0Hwkn/EtgWe9/iu5huf8A+xrp2m+TYnyqv8K8VAzVeHySdWftMS7swr5lyrkpaIlkmd/vtub+9UPmb6jpjNsr6elh4QSjBWSPDlOT96TJ9xpu41X3Gjca6OQwlIm3UVX8ymNNT9mZymT7jUHmVHu31iat4g0fw9Ztf63dw2Vqv8cxxu/2V/vGtqdBydktX0OWpiIxXNJ2Ntd71h+IvFnh7whYf2l4k1CGyg/h3t87/wCysa8sa+TviF+1VYWfn6b4Nj2yr/y+Xa/+i4//AIv8q+MtY8ceKvHGpSXm64u5/wCO4uX3Iqf738NfVYXhnlh7XHS5Irp1ZdKFWr/DWnc+rfiZ+1Nf3KT2Hg//AIklh/z/AM/zXT/9c16R/wDjz/7tfKTalrfiGa71iGT7Fa/8vOrai+53/wC+slj/AN9VzkaWz6jBBYQS+Ktek+4kG5oE/wDHfmr6Y8C/s1694quYL74lXf8Aq/uaXbNt8r/rs33Y/wD0KvAznjjCYKHsMujbpfds+kwuRwh79Z/eeFaDptzrl/8AZvh1ptxq9/8A8vOtX4+VP9td3Ef/AAL8q+1fhD+yuny694nb+0tSn+d7u7RvLT/rjE33v95vl9q+h9H8O/Df4XaVFeX/ANjtIrT7n3Y4Y/8AdX+Jv97c1fPvxK/bIs7bzNN8EweZ/wBPdwv/AKDH/wDFV8nguFc2z2fvppfgPFcS8n7rCq77o+u/+KD+GGlNc3M8Fl/euJz+9k/z/dWvlf4kftdabbJPD4Vg8z/p5ueF/wCAx/8AxX5V8I698SvGfj3Vf9Zc6zqNz/B97/8AZFevfDP9nPVfEOqwf8JJA+rX/wB/+y7d9sMX+1dS9I1/8ePYV9Di4ZFwzDkq/vKvSK2TObCZFjcf7+IlaPVnDXnij4o/Ge8l/wBOePTv+W1zM3l2yf8AxX/Aa+sPhH+y79m8jUtS87Tf79/N8t/P/wBcV/5d1/8AH6+o/Bvwt8PeCba0muY7e71G0/1Pkpttrf8A64r/AOzt81d1dXzz/wAVfJ4rNMzzn+O+SHRLoe/7TCZbDkwsVfqyh4Z8PeGPAmm/2b4Y0+Gyi+87KvMj/wATM3VmarU108r1TZqbXo4DJ6WG+Ba9z53FY2pVl77H7t1O3U2ivSOQkXfUlFMoAloWm0itUAPoprNSbjQAtMooqwGUUbjUXmUAf//Q/P5lpNtStIlRNX7Hycy8j4b3hlVLixtrn7/3v71W9v8AHSNXPVwf8pvCq4y0djn7jSbmD99D+8iX+71ptvqlzB8j/vf96ukjuHi/3ar3FnZ3f8O1v7y1zQxdWg/f2PSjiIT92oia11S1ufk/1TVLIu//AGq5e4025g+5+/X/AGf/AImpLPVHg/137xa9jD42FT3ovUwqYD7dN3Nlrf51dP3bL/Etbmm+LNS0p1+9+6b/AF8PyvWXDdQ3n3GqSaPclfRZbm9fDWjB3XbocNVKXuVVdH118O/2iNStdttrf/E0gX+P7twn/wAV/wACr6+8N+NPDfi22+06VdpP/ei6SJ/vLX45NG8D+dbt5f8Au12vhnx1rHh66W53Orf89oW+avUrYTAY/wDuT/BnzmN4fnG9TDP5H6/yWf8Ac/75pd3n2zWGpQJd2rfehuF3D/x6vkPwH+0RNsgh17/Trf8A57Q7VkT/AHl/ir6s0PxR4e8T2a3OlXaXK/3V+Vl/3l/hr4LP+EZwVsRC8Xs1qjhwWaVaEuSTaaOD8TfCPw94htp003ZH5v8Ay4Xn7yFv91uq18WfED9nW80ibfYRTaRP/wA8X/eW0n/XOWv0kkh2Unmb0a2mVbmBvvwzDcP++Wr8wxnC9fDT9rgZteXQ/Q8Bxh7ns8UuZfififrWg+IfDM3k6xaPbf3Zcfuz/wACrOhuEl/cvJ5m6v118TfCfw34jRv7N/0GWX/lhP8AvrZ/++uVr4s+IX7O95o8zTWFs+kS/wDfVrJ/uyVrg+M6mFn7DHq3mfS/VKGLhzYWWvZnzEtvNA++zkrsPD/jrXvC9z9pSeaCX/YOKwdW0XxD4auWh1u0eD/b/gqqtx5/39slfqGUcWzkv3U1JPdHgZhlWnJiI3TPtfwL+0p/q7bxUvnxf890/wBZ/wACX+KvqvQfEmieJbb7Zol8lyv91W+dP95eor8eWhh/10Mnlf7NdP4f8Zal4auYpra7mjlX+NGwVr1a+X4HMv7k/wADyI4Wthf4Tuux+vP3af5lfHHgH9pZ51Ww8SRrd/8ATb5Y5P8A7Kvp3w/4w8M+Kv8AkD6gnmt/ywf5ZP8Avmvj8z4ZxeFb0uu6NqGb0+bkq6PzOu3bqlWSqbK8VL5lfMyhJHrwmmrp3RfWSpN1Z6yVJ5lBRcp+6qitUitvqAJ6ctQ7jUm6sWVGRLQrUyisKhtck8ypKioX5K5pRKjIlptCtTqzlE2jIkW4kT5Pvf73zVzeueFfDfiGHydV0+Gfd/C6K1b1O215uMyulV+JWfdHbSxlSl8D0Pk/xh+zLomo+ZN4eb7JL821G+ZP/rV8ra18AfHMCXN5fxfZNLif9y+Meft/5af7K/3d1fq4q1K1w/3Jl81fu7W5X/vlq4Pqdeh/Cn8mepHNeZctWN0fidfeFdS0j9zeWnmRL/EgrnZtPTf/AKHJX7G+JPhj4G8UI3naeunzt/Hb9P8AgS9K8Q1b9kmz1P59KnST8NrV62A4jxuH6fM6KsMFXXY+E/CvxE8c+Arn7To+pTRf7Cvujb/eWvqjwT+1xDJ/o/jbT/L/AOnm0/8AZo68Y8RfD7+zvFk/g3wJ/wAVLrdt/wAff2b95a2u373myfc+X/7H2ryzVPAfiTSrmWbxJbTxy/39v7v/AL66V9th+P6dT93jYJvo+p8zi+FKdef+z/efrd4b8beFfGNmtz4f1S3u938Cv86/8BrpGWvxosbrWNAuftOlTvbNF/cdlNfQng/9qLxhoflWevRLqkEf8U3En/fxa9urkOExdP2mCqJt9D57FZfjcE2pxuu5+ilPZtleEeE/2hvAfiXyvtM/9mzt/BN9z/vpa9rt9QsNRhW5sblJ4m+66HcP/Ha+XxeTV6H8SP8AkZUM0g5ct7Psy3Gz/wDfNQ3VnpWpps1Kyhuf94LmpNu6pq8HEYOnJWqI9rD42pF+4zynxF8D/h14hST/AEJbSeT+Jdv/AKDXz9r37H8P7250HVHg/u7E3f8Ajq19s7TQskyfxVw/ValL/d5tHqRzDmXLUSaPzpuPgj8Y/CUP/Et1m7u/91GaP/gSybqvaVp/xo87/iY6Rp97F/vSWr/y61+hn2q5/wCejUSXEzffauyhjcwh/wAvLmFfC4Sr9k+Kpo5rZ9lzBNB/voy1GsyOm/du/wB35q+ybrT7O+TZeWySf7y8/wDfVclqHw18N6hu2R+U3+f4utet/b1SPxxPI/sGnL4WfLjSb6rNJXumqfBmb79hd/7qzfNz/vL83/oVeD+LvJ8E38Gm+Krm30+6uU3wqz8SIG27lb6/3q9XAZ5Qr6Xs+zPKxWR16Sc4aoVpKj86se31SzvP+PaeGf8A3JVb/wBBqVptn3/lr2vZnhzUo+RotNULTVnfaE/vUnnU/ZeQvaGj51H2isrzKXzKn2XkZyka3nbqf51Y32j3pPOejk8hmz51MaasfzJKPMkq4xHGRr/aKlWaslWq7FSnE1hIu+Y707dVBdQsEfyftdu0n9xH81/++Yd5rZt9N1jUP+QboWrXv+0llJGn/fVx5deRiMyoUtHL7tT1KGAxFT4I/oUmaq0tdta+AfHl5/qfDNxF/wBfN1bxf+g761Ifg/8AEK5/5YadZf3fOuGlx/37C1xf25hu7O+GR4r7SseS3Czf7K1l3S/J88+2vSfjB8I/ibZ+JNN0f4X2z32ky6dE93eypCuy83P5yeY3Ts22vM/+GY/jlqv77WNUhg/2fPZv/HVGKf8Arbl9KP7y9+x0Q4SxlV+67I56+1LR7b/XXaf8CasK48WeG4P+XuFf9z5v/Qa9W0/9jHXp/n1vX/L/ANyPd/6E1dhZ/sY+Ff8Al88SXv8AwGKNax/4iPhf+XNK/mzs/wBRZv8AjVLHyze/E+zgP+gQPcf7/wAtcnqXxE16+/49tlp/uD/2Zq++rP8AZB+GMH/HzfX1z/20Vf8A2Wu1sf2afgzp3/MGe7/67zyNXm1/ELG1f4cWl5HoYfhHBUviab+8/J661DUr5/8ASZ3l/wB5s1c03w34h1f/AJBWl3d7/wBcIpJP/Qa/Y3Sfhb8MdBfztN8L2Kyr/E0St/6FXoEM1tbJss7aGBf9hFWvn62eY2v9n72etHBYSltK/ofkRof7Ofxa13/U6BJaRN/HdlYv/HW+b9K9j0P9i/xVdf8AIw63bWX+xbo0p/8AZRX6Kfanf/OKiaR3/irk5MbV+OSRt7WhHZHyvoP7Hfw90/b/AGxd3OpN/v8Al/8Ajsde7eHfhL8MfC//ACDfDdh5v994lkP/AH01detTUv7K/wCfkm/yCWZuOkEkXftCQL5NtEsES/dVBtVf+A1XaZ2oo8vfXZQwVOHwo86ripy+J3Ifn/v0u2rG2nLHXV7I57ldVp+2rfl1Iq0ezIK/l1P5dSeXRWqgBF5dNZanqFqv2YrkdPjkeL7lFMo9mScz8Tfhp4Z+MHhtdE1v/QtTsv3ularF/r7Of+H/AHomP30/Ffnrn/h54u8V6hFd/Dr4qwfZvHfhqP5bw/c1fT/9XHeQt/y0Kn7/APvbuudvo6tspLiT7T5DzKskttv8l2Clo93yttbqu6p5AKH3aGbfU60xl+erjEmIxV31ZooqSh1Nopm6pkA+ombZUbNvqhqGsabots1/qtyltbxfedzhRXXhcFUrPlgjCvioUleTNfaa43xd488MeCof+J3d7Z5PlhtoR5k0h/2Y1ryPxB8YNY1x5NN+Htt5cX/QUn+7/wBs1q/8P/gbqWq3P9vax5jSz/67Ur/mR/73kq1ds8Vg8B/E96fRI4fYV8Tbkdo9WzldU8TeP/iNc/2VbxTeG9Guf+Xa0/e6lOn/AE0k6Rbv7q17d4C+A9noNmv9qxQ2Vq3/AC6Q/NLL/wBd5v4q9q0Hw3oPhK2+zaPbKrfxzN99/wDa3VpyTO/8VcvsMXmX+8aR6JFfW6WE0o6vq2FvDZ6ZbLYWECW0Ef3UQbV/8dp7SO9QU7ca+kw+Cp0kowVjw69dzd5u7CmtUfmUxpPkrsscspCs1RSNRuqLdWkYmUpDqj8yo6iuJra0ha5vJVgiX5md2wo/4E1bxjt5nJOuoxbb0RLu3VDeXltp1nLf386W1rF953baFrwbxx+0F4b8Owzpo+3UJ1z++6Q//ZV8IeOPjl4k8Z3jfvHn2/6v5sQx/wC6tfQ4Xh6pKKniHyRffdnBSrVMQ3DDxul16I+yPiJ+0to+hpLZ+GP3n/T26/L/ANs4/wCL/gW2vhXxd8TvE/jPUmm+13OoNJ/G/wD7L/d/4DivP7iRHf7TqVy97/sLXW+H/Bvi3xj/AMg22/s/Sf8An4/1cf8A31/FW2L4lwmW/u8FC77tan0eX5DBfvKsr+b2RybLpUH/AB/zvql7/wA+kXEa/wC83/xNez+D/hL45+Ifl/2rv0TQeP8ARrdPv/7sf/sz1614L+GPgbwZCt/quy9uov8AlvP0T/dWrfi79ojTdFhbTfDESeav/Lf/AOJX+KvjfqWZZzPmq6R7HoV+IaFD91hI88u/RHrnh/wv4D+D+ied/o2iRf8ALa5d911P/vS9W/3I68t8YftQJoaS2HgmySP/AKebkfP/AMBh/wDi6+SPEXj7XvFV41zNczXc/wDz1f8Ag/3f7tczp+m3Or3kVnbQPq9/N9yC33H/ANB+9Xr0styfJoe2xHvT7GOFyrF4+d67v5HReKviF4n8bXkt/quoT3P+3M/yJ/n/AGa0vh/8JfFXxDm86H/QtI3/AD3jrj/vmvpj4S/suzarcwar44j8/wAr/mHJ+7hi/wCu7f8Asi1+gmh+E9E8NQwJDAjS23+p+RVji/2Y4+3/AKFXy2acbZrmX7rB+5DbTTQ+k+q4TAe5u10PBvhb+znonhWzjfyP7Nt/+ft/+P2f+9t/55f8C+b0C19MafDo/h6w/srw9aJY2v8AFs6uf4mZurM395qjkupJfv1V3V5mW8OUqX7yp70urZ5ONzipV02S6IsNcO1V6ZT6+nhBR2Vjw5Sv8QU+mU+iQgooooAd5lKrb6ZTKgm5YoqFad5lAiSo/MqOjdQA/wAymtJvqPdRup2Ggopu6jdWljQ//9HB8Xfs6+EtI03+zdE0+bT4v+glu825/wC2jN8jK3/AU9CtfNPij4S+MPD0P2y2tv7XsF/5eLJWP/fUP3/++Ny+9frr5k3+9XLal4N0HU3lmhi/s26l/wCXi02rn/rpCwaNvy3e9epSwuZYD3qMuddmeZ/aWEr+7UVn3PxnXZLRtr9IfHXwJ03WfNuNV0b+0P8AqKaP+4vP+21q27zf+Al/pXyn4m+COt6ckl/4YuU8TWEH3/s+6K8i/wBma2b5t3+z972r3sJxhScuTELlf4HLVyeb9+i7o8Fkt3pFXZWhJHNFM0Myssq/KysuGXb/AHlb7tQ/JX1HPCrFcruePU54PlmrNFZWqldWdtc/w7Zf79a3l1G0dc8sHaRVLFSRx81vc2L/APs6/drQt9a/guf++q2GX/vms2bS7aX57ZvLb9K2jWq0vQ9ONWlV+NamlHNbXSfuWpslr/tVzMlneWb79v8A3xV231iZP9d81evhcepddTGphGvepvQ1VWa2fzraRopfyrrtB8eaxod/Hfw3s1tcRfxQt/6FXLRzQ3KfuW3UeR8lfVZbxDVw3xarqnszhr0YT9yqj71+H/7SSXKR2fi2Lzen+lwr83/A1/ir6n0vWtK8Q2a3+j3KXcDfxIc7f/iTX4swtc2j+dbSNFXqXg34qa34auY7mzu2tLiL/viT/erpxGT4DH+9hnySfR7M+ZxuSVYe/Qd126n6wN8lSecjwtDMq3MDfeSbmvnTwL+0NoOuJFZ+JP8AiX3X/Px1hf8A3v7te/29xp+owxXNtIs8UvzI6tlT/wACWvzvP+EuW9LGU7J9e5OCzeph3vZrocB4i+E/hvxGkiabtiaT/l0nXMP/AAH+7XxR8SP2eZtDvJZrNX0n/fXdav8A7slfo40f+elSNcTeS1tcql3ayLtZLhd24f8AAq/LcVwpi8HPny+VvI/QMt4whNcmJV0fidrmh654cm8vWLTyP+m0fzRv/wACqtDcJL/yzr9cPEnwl8J+IoZ/7H/4ls8v/LtMiyWcn+zt/h/4DXyB48/ZpfTGaazifRJ/97zrOT/db+H/ADxW2C44q4Z+xzKFn3R7kcLRxa58JL5M+VZLVH+eP5a2dP8AFWt6M/7mVvl96XWvC/jDwr/yFbB2tV/5bxfMn/AvSsu3mtp0+8tfo2V8TaL2M7p9Dw8dgH8GIjdLyPp/wP8AtMa3pXlW/iFV1Ky/2v8AXJ/wKvr3wn8RvCXjG2WbR75fPZRut3+WVf8AgP8AFX5T/Y7OX/e/vLTrW41XSpvOs5N3lf3WxX0P/CZj/wCKuSffozx/7O9l/u7t5dD9jt2/7lHm/Psr86/BP7RXjDQ2isbxv7Ssl/gu/v8A/AZOtfW/hH41eCfFXlw/af7NvW/5Y3PAz/sydK8PMOEa9KDqUvej3Qf2k6T5aqseyK1SrJVP5H2unzK33WXlalVq+NnT5fdtY9KlioSjzJ3LG6pvMqorU/dXJI3hMuK1Luqms1P8yuaUTojIt7jS7qqrJU+6sWbEu6nK1R0Vma0y1TlqqrVYVqzlHmNSWm0UVhKJZPbw73rxnxfr3jX4saxe/Cn4U3f9ieHtPk+yeKvFfo//AC0sLL/npL/z02/7uUT7/rsi+bbSW3mtH56lN8J2ypu+VmVu3+9Ummx2Gi6TaaDolpDpunaenk29tANqIn+LfxN95u9Zcl5Bcp+D/Avgf4YeGR4T8Faettanb9puX2tc3kn/AD0mfv8A+gr2qhqHhHwxq/m/bNPjbzPvf3W/3lreZt9MrGvl9Or8a17nTSxlSHwOx89eJP2bfBOseZNpW7TZ2/ufc/75r5+8Sfsu+J7PzHsFW7i/vJz/AOO1+glKrOn3K5fqFSlrSk0z0qWeT+0ro/IrWPhD4t0N2d7R4Nv+yy1n6T4q+IXgmb/Q57n/ALZu2K/YWaTz02TRrLu/vDP/AKFXK6h4P8Man/x+aTbN/tLGoP8A47Xu4DirN8N7nMmuzOfF0Mvxcf3sLPuj4W8J/tXa3Y7YfElp9pi/vYw//fS19Q+D/j58N/FvlwpqH2K6b+C54Gf96o/EXwB8B6yn/IPgj/2tm3/x5a8Q1r9kPTZ/32iag9o393fla9mPF+Hr/wC90beaPAnwrTi74SrbyZ9sR+TOnnQsskTfMrKVIb/dprLsr4Cs/hL8Y/h9N9p0XWb3yoPufZpfNRv96Nq7Oz+PnxU8PfufEmhQapFH/sNazf8AxNPly/Eq9CpZrozCeDxtGXvxun1R9j7TS7a+XrP9q7ww/wDyG9Cv9Nb/AGFW4T/x2upsf2lvhdfbf+Jslt/18I0dOOTTl8EkzCeNqQ+ODR7utLXF6b8UPAGror2fiLTpN38P2iMN/wB8tXRw+IvD1z/qdQgb/dkVqj+xq9ublvYmGaU5S3saqyOn8VeYfEL4R+DPibc21/4ktnkvbSH7PDMkjL+73btrKv3ua9Ka4tvvpKu2m7kf7jV42Ky2ctGmj1cLmSjLmgz5KvP2Q/Abn/QL27tP+uUp/wDZq5+6/ZTvLb/kCeNtStv+u37xf++VK19p+XJVGSP5/n3Vw/UMXS/h1Wd/9p0J/HBHwxdfs9/Fe0P/ABLvGNtd/wDXeDa3/s1YFx8I/j7Z/wDLTTb3/gcf/s22vvyS3T/aqv8AZ/8AerX6xmEPtsj/AGKW9NH58t4N+P1t/rvDNpd/7kkf/wAcqq2j/GW2/wBd4Hdv9yVT/wCzV+hzR/3leo/s6f3W/wC+d1a/2vmfe5l9Ry2X2bH53STeP7P/AI//AALqkf8AufN/7LWXceKtUtt3neF9aj/3oK/TCO1T+6v5VJJpNnL/AK6BG/X/ANCrphnmZ9kZf2Rlvofl2vi7Xrl9ln4X1KRm+797/wBB2VuQx/Fq+/48/AV7/wAD3f8AxK1+ldrpdhb/AL6G2i/3lRef+BVsrdbfuKv/AHzisv7ezPyNoZPlvY/NaPwL+0Pef8e/hBLb/rq65H/kSvafhT+zZ4j1DWv+Eq+NdxDPZaf/AMemkJLvjkk/vTqvy+Wv93+P/dr7EW4mf+KjzHeuarjcbX/jy07I2jh8FS1pR18ynDpulWP7nTbaG0i/uQRrEP8Avlas7U/u09VqTy46yVBClXmEbU/zKVVSn7TWljEj851qvJM7VYZarstLkj2NozcepBI0z1BVtlpm2o9nHsX7Uq7ai8t6tbaTaacY8pMpFby3qVVqXy6ftosRchp6rUnl1Iq0w5xm2nqtSKtSKtVYmUiNVqxGuyn7TT1WrjEkTy6k20UVp7MAoplG41XswH0NUfmVFuNXYglao6TcaRmoJEam0UygB9MoooAbtop1V2as+coezbKTzKjqNpNlEIOctFcU6qiuZuyJN1R7jXE+LPHmg+Ek2XkrS38v+psofmmk/wCA/wAP/Aq8G1C+8efFm8l0Sb7RY6d/Hpemn/0quP8A2WvTlQpUFz4iVvLqeb7apXfJRWnc9G8WfGTSrGaXR/B8H/CSavF9/wAk/wCiwf8AXSb/ANlWuC0HwH4z+Jeqfb/EM/8AaH+x80dhB/ur/FXufgf4F6Po1tF/b0cPy/ds7dcRr/vN/FXu1uttaQrbWca20EX3URcAVwzzHGYz93hVyw79WDpYfD+/N3l+RxnhH4Z+G/CqRvcx/wBoXsf8Tr+7H+6tehzXW+s/dRur1ctyGlh+l2+rPOxWPqT66diRpN9R0U2vfjGx5dx2403dTKi3VcSZSLG6oGkqNpKRV37v7q1rY551UuobjUMkkMCNNcSrHEv3mY4A2/7TV5j4w+L3hjwwkkNnIupXq/wo37tD/tN/FXwx8SPj5qWvTND9p+0/9O1v8sKf71fSYDh6rXjz1XyQ7vdniTx868/Z4dXa+5H2j4w+O3hXw1DLDpX/ABNL1f4s4hX/AIF/FXxJ4++PWseJZpYftP2n/phD8sCV4BqGsarrj+dqVztX/nknCf8AAv71Z/3PufL/ALNetDEYXB/7rG779TtoZHze9iHd9lsi1qV9eanN52pT+Z/sL8qrVXzI4k2J8tRN89Kq15WKxE8R79SVz6CMVGKUdF2R1fg+68JW2qt/wlEE32fjydv3Ff8Ai8xa9J1r4rWFj/o2g/v4v4Pm2oleCzRo7qlV/sc11N9mhpYf2EV+8W3VlVMFCvL372fTobWueNNb1x/9Mn/df88eiCuW/wCu372Vvup/E1dr4b8F634nufsegwfa/K/19z/y7xf8C/ir9Afg3+zHoOi+Rrd5/wATa9/5+bhP3Mf+6v8AF/wH86+Pz3j2C/2fCK78j6bB5TChBOaSR8k/Dn4B+LfGyRX+q/8AEk0b/d/eyf7qfxV+hXw1+Bvh7whZx+TY/Yvx3XMv/XST+Ef7Ne0Wem6Vo3/HnH5lwq7fOb7y/wC6v8NSSTPL/FXyeFyavi5+2xr+Rhj875Yeyw+nn3LiyW1pCttZxrBbr91UGBUTNvqrS7pK+uoYeEFaCtY+VlOTJaduqFd9SVuIdTlqNakWgoWn0yn1MiQooooAKZTtxqKixA+k3Gm0U7AN3Um40tMosA7caiZqKbWkYlxHbjTWaiirsUf/0vsjbSeWlLRX6KfnhG1c/rnh3R9cdbm8g8u/i+VLy3doblF/67L95f8AZbcvtXSVDJXJisvo11apHQ2pYirSd4OzR80+OvhDba5Hv8Q6N/wkUH8F/pqLa6rB/wBs/uTL/uf9+q+Q/EXwD16zhn1XwNdp4osIvvwp+6v4P9ma2b+L/vlv9iv1N+dH+SsLWPDej60/2y8jaDUV+5fWz+VcoP7vmL95f9iTcntXz39lYvA+/gpadmfQ0s6p1/cxUfmfjVJHeW00lneRNBPB8rwujRyIf7rq33aj+9X6U+PvhTYa5D/xUmlprMEH/MRs0aO8i/34Y/n/AO/O5P8AplXyB4m+B+saZHJqvg+5/wCEi0v/AMmU/pJ/46/+xXdl/GUOdUsUuWX4BiMl5oe0w8rrseHMtQ+Xsq1MrxTNDMrLLE21lZdpVv8AaVvu0m3dX2/Opx5oO6Z42sd9GV1as640+Gf7nytWjtp201zzw7jLmWhpTxDicpNZ3Nm+/wD8eWrlrqzxfJcrurd21m3Gmwzv8n7tv9mnDFThL3j0Y16dWPLMuxyWt4m9GqFresKazubP5/1Wrdrq0yf6797Xt4XHQl8LM54N/FTd0bVrcX9i3+jN/wAB/h/+xr1vwb8XvEPhqZfsF21t/fgm5hevLLea2uU/ctVO6tfN+Svqsv4mmo+yrpSj2Z5GKwdOv7lVa9z9L/Afx88MeIkis9b/AOJbe/3937lm/wB7+H/gVe9r+9RZkZWVvusvRh/er8VbXVL/AEx/9Gk3Kte7+Afjp4h8KzRw2dz59l/z6XPKf8B/u/8AAaeL4cwuM/eYCVm+jPncVkdal71PVH6ZbalWabyfJmVZ4G+8jjcP++WryLwL8bvB/jNFtnuV03UW/wCWNwfkdv8AZkr2FvuV+c5vkLjN0sXTs/PqPBY6pTe9mjitW8A+HtXRvs3+hTt/Ay7oef8AZ6rXyf8AET9m+HfJf/ZPsP8A0+WHzQf8CX+H/wAdr7c2/PUkNxNH/FX51iuDFSn7TCycX+B9zgOLavwVVdH48+JPAvjLwr++vLb7bYL/AMvNuu75f9pf4a5eG8S4T+61fsRq3gvw9rKb7WJdNum/54p+5f8A3o//AImvlH4lfs82E+6/+yf2XL/z+Wn7y3f/AK6L/D/nmuH/AFjxWAnyY2N13R7sKOFxXvUpWfY+KGjtp/3Lr81O+1XlimxJPPi/Vf8AgVdB4o+HPjDwdumv7b7TZf8AP7b/ALxP/rVytnceenz/AMNfo2UcR3Sq4Wpddjz8RguX3Kquj2LwL8cvE3g7y4Uu3ktf+eE/zJX2B4T/AGgPCuvoqaxH/Zs/95f3kf8AiK/OjyYZU+emww3lj/pOmz/8Bavrp5tgMfpjIWl3R4U8r+3h3Z9uh+xNjqFhqFt9ssLlLuBvuvEVYf8AfS1L51flp4P+Kmt+GrxZIbuax/3eY3/3lr658I/tAaPqPkWfiSL7M3/PzD80T/7W3+GvEx/B0+R1MK+dduqMlmVSg+XEL5rY+llkqZWrH0++s9TtVvLCdLmBv40fcKvbq+Dr0pwlyyVmexh8XTqq8HcuK1WlbfWYrVYrjlE7YMv7jS7qpbqlWSspHUi2tS7ttVFapt1ZGhYVqduqLdQtTKPMO5YoqLdTqUY2C4+hWo3UzdVy+EY+iiiucsdRtpu6nbqmwDdtRtClTUUWArNDuqKSztpfkmgSRf8Aa+atHy6Yy7K5quFpy+JanRDETj8LOR1Dwb4Y1BPLudGtJN396Nf/AGWvLNW/Z5+F2q/8wC2gb+9G8g/9BavftpptZ/UF0djp/tKt30PkXVv2SfBN3t/s1fsn/bSTmuEuP2P7qKbzLDX/ACF/2dzf+PV950UQpYqk+elVasX9dhL44J/I+JpPgf8AGDw9prf8I94/u28hPkgfdj/x7dXMf2b+1hp3/HvqjXP4Qn/0KvvzcaTcf9n8q9H+181/5+p+pzTpYF/8uz4ZtfEX7V1j/wAfEVpc/wC/FD/7Ltrcj+In7RUX/Hz4Z06f8GH/AKCa+yc/7C/lR/wEfktV/auZeX3GLweC/lPkOP4sfGmD/j88D2kv/bWRauL8ZPiF/wAtvASf8Bu//sK+q2VH/hX8qj+zw/3Vb8Fo/tTF/asZ/UcD2f3ny0fjJ48/6Ell/wC3hf8A4mq//C2viR/yx8E/99XG2vq37Hbf881/75FO+y23/PJP/Haj67iOyNo4TBdmfIzfE745T7vsHguwg/3/ADZ//QZUrOubX9oz4gXmnaJe3iaBp19Okd9c2EH2TybZv9Y3mtJI+cf3a+zPs8P/ADyX8qaq7Kz9tip9bIfssNH4EC2tnY21tYabH5FlZQx28Kbs7UiXavzfxUm2n0/bV+zOcaq1JQtPqbACtUtRVJ5lFgJttFFFFgGstQNHU7fJUW6iwENN21LT6LAVNtFS7aKLARbaNtS0UWAbtqXbT6KqMQGbaetFFachBPRuqCnVUY8oEu6imM2+m1QrkjNUX3qWm7qBjqi3U+oaAH0Uym7qBWHUVC0lRs3+1QMl3bqj8yotxpu6sZSuKUuUnaSovMqFpNke99q/71eNeKPi1YWly2j+FY/7Z1Rfv7f9RB/10kr06GW+57Sq7I8+vmPv+zpq7PVdW1rTdDs2v9YuUsoF/imbbu/2V/vV4drnxI17Xv8AQ/B9t9itZf8Al8lTdNLu/wCeEP8A8VVfQfh74y8f6kupeIbv+0P+m83y21v/ALNtD/F/vV9PeF/AOg+E0320f2m9/inl++P9z+7XHVzWdX91gl8w+q06X7zEO76I8O8D/A2aWb+2PE8jwef9/wCbddS/78jfdr6X03SdK0G2Wz0e2S2iX+6v3v8Aeb+KrjSUV24DIf8Al5Wd35nDis1nLSOi7IVm30lMor6OFJRXKlY8mU+YfSM1Norci4m40bjUDSUzzKcYESnYk8yqzNvrn9c8TaJ4ctmvNYu0gX+795z/ALq18j/Ej9pr7H5th4bj8jduX1lf/wCJr3stySviPeirLq2eNiMyvP2dJXfZH1R4m8ceHvCULPqtzul/ht4fmf8A4F/dr40+Jn7Rk2o7tNsJdsf/ADwtj/6E1fL+veNPEPiWaV7+5e283+Dd9+uSjhhg3fN87V79KGDwXwe/NdXsiIZTOr72LfyWxt614m1vxDN/pM/l27f8sU/9mb+KsZW8r+FaGaoK4cVjZ4n3qjufQUKEIQUIJJLog3U1qZT91chqFMp6rv8AndliiX7zvwq16Z4J+GuveLn86Hfpelt/y/TJtkdP+mSt91f9tq8HNc8oYKDdR69j0MLgKlWdoI87htXuZvsEMb3N7L9y3t13Sf8A2NfSfwx/Z2v/ABL9nu/FvmwWVx88Om2f+uuP9qST+7/45719LfC74C6bpVnHc/Zv7Ptf+fu4j3XM/wDuLJz/AMDf5f7qV9O2q2ekQ/ZtNi8tW273b5pJcf8APRm+9X5zWx+PzX+H7sfzPcnVw+CXeRxfhn4a+G/DWmxWc2m20FvFjybO3/1a4/57Sf8ALX/0Gu+kvHfaifuol+VVXhVX+6u2qPmb6dX1GV5LSw0NterPmsXmVSv8b0H7qFahaFWvZPO3HrTlXfTVqdVqSoxFp1ItSVRQyiiigB9FRU7dQA+jdTKKViQooprUyBNxo3Gm0UAFMp+6oquMSx1NpGaoK1An3GjcagooKP/T+v1kpfOry+x+Mnw91CZbb+0mg3fdaaJo0/766V6TDJbXkK3NnOlzbyfdeF1ZG/4Etfq9XBVKNvaxa9T8ujjacvgkT+ZTKibelM3VnycxpTr3LFMZabup1ZyhYv2kSKT5K5PWvBuiazM1/wCX/Z+ot/y92m2ORv8Arov+rl/7aBq7GmMtedj8toYiHJVVzrw+KqUHz03ZnzD46+D9nrkP/FSaX/a/9zVNLTy7qP8A66Q/f/7481f+mdfJPiD4H+INP8y58H6lB4i06L+BPluo/wDeXo3/AI63+xX6pfcrB1bw3oOuP51/af6V/wA/duzQ3P8A3+j5b/gW6vmf7KxuB/3Kd12Z9FDPaVf3MTH5o/Ga4jezmltr+2mtp4vvwyo0br/vK1Sr89fpp4w+D8OuQ+TNbW3iSCL/AJ+9sF6n/XOZdsbH/v3Xyh4k+AM32mSHwfdzR3sX/MJ1Zfs9z/2zb/lp/wCg+9elhOLeWXs8ZHlffoazymFWHNhpX8j52aHdTPLq9q1jqvh6/bTdesriyuov4Jk2/wDAl/vf71QNIkv3K+vjXp1YKcHdPqjxK9CpSdpqxEy1QuNLhn/6ZtWky76h27a4Z4V/FB2aChiJR6nLzWt5Yvv/APH1q7DrU3/Lyu7/AGq3t29NlZl5o6S/PZ/u/wDZ/hrahj3D+L956katOrpNaliFra7+5Uc2n1z0kNzZv86tHWnZ6w8XyXC+Z/OvosPmF/gZnPCzj71N6GnDcalp/wBz5lWvePh78evFXhd47P7T/aVl/wA+lz/B/ut1WvCluoZ/9S1Vri1319hheI3OHscUlOPnujza+FpVfdqKz7n6oeCfjZ4P8VeVbTT/ANl3sn/LG5ZVyf8AZk6GvY2XzfuV+LFrrGpaft85vPiX/P3q+ivh/wDHzW9A8izhn+22X/Ppdndt/wCubfw/54rkxXDOHxXvYJ69mfM4rK8Rh/fpu6P0Zp8czp8m75fu7W/irzfwj8WPCvi3yIfP+w3sn/LvOV/8dbvXpnko/wByvz/Msk5JOniIWfZkYPMpT2eqOP1TwPoeteZ9gb+y72X/AGN1s/8AvQ/w/wDAa+SviZ+zrbb5bz+z/wCxp2/5fLQ7rWT/AL54/wDQa+3vL2VYhurmD5EZtv8AEvUN/vK1fnON4MhCr7XBycH26H2+X8UTjDkqq6Pxy174f+MvDE3z239pWv8Aft9zf+O/erjl1KFn2f6v/er9ltY8F+Fdc/11p/Z8/wDftNqr/wACj6f+g188ePP2b7PUklvPsUOof9Pdh8tz/vPH/wDtVyf29jcA+TGQuu6Po6P1LG60pWfZnwBu387d1Ecd5bfPYXPl7v4O1eieJvgr4t8Obr/QW/tey/8AIn/fNeWLdJG7JcxvBOv30YYxX2mT8Swq/vMLUszkxWXzpaTV0d3oPj7xJ4auYriGe4tmX+OF/lb/AHq+ofBP7Sn2maOz162+1r/z8Q/K/wDwJfu/yr42jm3r/s09Y4Ufzof3Ev8AscV9l/b1LEQ9nj6Sl5rdHz2Kyqn8dLR+R+sXh/xd4b8Sp/xJ9QSSX+KFvlkX/gLV0/zpX5L6f4k1LTP9J/1/lfxwt5cor6E8D/tFalbbbbVf+JpB/wBPHyzj/gX8VeRX4Uo4hOeAnfyehy/W8Vh/4sbruj7l8yp1krzTQfil4M8QpHsufsM7fw3Pyj/vrpXfqyOivDIsit/ErZr43GZViMNLlnFo9bCZ3Qq+7F6mirVKslZ3mVLurypRPbjLmNDzKm3Vm+ZUiyVmM0KN1U1mqZWoLLKtsp6tvqHcaN1A4yJqKh3GjdQMsU+qi1J5lZ8gE9O3VBTqzLJaKbRuqWA6oqfuopAMpjVNTfkoAhop9FWBHtNNp9MoICiiigsKFoorePwkBTaKKZYUUU6gA3UbqKKACn0yigCanM2+oqN1BA+jdTKZuNAD6NtM3UbqCwoo3GigA3U+mbjQtBA+n7qKKCx1FNooAKKKKDITaaWmUUAPplM3UbjQA+oqZ5lQ7jQUO8yo2ambqiZqj2gErNUbNUdYXiDxRoPhWza/1u7SBV+6n/LV/wDdWt8PhJ1WoRV2YVcRCF5N2Oh+euJ8XfELw34M/wBDvJf7Q1eT/U6baL5tzL/wH/ln/vNXiOsfFLxn4zf7N4Vj/wCEf0aT5PtbjzLqT/rn/d3f7NehfD34G3P/ACGNV36bFc/8fEzu3226/wB7d/q69DF4jBZbNRm+afRI4YxqYj3tl3Z5/dL8Qviff/YL/fptlJ/zB9OfdJs/6e7j/wBlWvobwb8HdH0C2g/tWCDzY/8Al2tv9Sjf7Tf8tK9S0vSdL0O2Wz0qBbaJf7n3m/3qvbq4vqGIx8/aYrRdEuhE8fTw8OXDr1fceuyJFhhVY4lXaqrwq0yimV9NhcFSpLlgjw6tVzlzSdx9G6mbqb5lddjEk3Gm1C0lM8yiMOYLknmUjNvrMvtS0/TLZry/uUtoov4nOK+fPHn7Q2j6DDJ/Y+xm5/fTdP8AgK16uCyiviX+7V136I8bF5tTpSUIay6JHvuqa1pujwtc6lcrbKv96vl74jftGabo3mW2jyf9tv4/+ArXyB42+NHifxVcy+TK/wA38bf+yrXkn76V/OvG8+Vvm+bmvqqOAwmE96p78u3RGMMqxOKtPFvlXZbs9C8TfEjxD4quZLnz3Xd/GzZf/wCxrg41+dneXzJW/wCBGhmqPbsrmxeZ1cR8bslslsj6DD4WnRhyQVkTNTWpm6kaSvLLsN3UnmUzzKk2/J5037tfu/U/3V/vVjiMRCmuab0OmnSctIojlrT0rSdR1e9+wadB9ruv7inakf8AtzM3+r/zivSPBvwl17xG8c2pebpenSfJ/wBPUv8AsrHyV3f3cNJ7V9+/D34F6P4a02P7fbf2TZfe+zQ/8fk//Xabkx/7qN5nrIvSvz/MeLpTbo4JXffse/QyuFJKWIdkuh80fDX4ATXd9bTX0X9u38L/ALyFP3VlZf8AXSSThW/Bpv8Apmtfcnh3wPonhrbc3GzUL9fn6fuI3/6Zxt1/35Nzf7tdJG1naWcem6VbJZWUHypBEiqi/wDAVqLdurkwHD3PP2+L1ZxY7Ofs0tEuxZmunn+/VbbQtFfYQgkrR0R8/wC0v8WpIq76mWoo6lpjH0itS0ypGiVacrVHT6DQsUVGrUeZQQSbqN1MoqogO3GjcaY1LWliR9FG6jdSJuFFM3UUWKCmUUVYBVdm309mqFmqgFpNxpm402gofTN1N3UbqAP/1PhvT/GGt6V8k0X2mL/P8VeveDfi42mTLJpuqXGmz/3P+Wf/AHz0asXWPgP450XTft/2221S6/jtoEYf+ROn8q8XuLPypmttSga0ni++jptkFf0XlvHuExkOS6a7M+OzPhGnL35qz7o/Tfwv+0BZypHb+Jrbcv8Az92n/s0P/wATXuuk+INB8Q2f2/R72G7g/wBg8p/vL/DX4w6bqGsaZ/yDb7d/sf8A2NeiaH8RprG8jublrjSb2L/l5gLba66uR4DF+/h5cj7PY+VnleKw/wAD5l+J+tdJuNfGPhH9oLW4EVNY+z63Zf8APa32xTr/AOyN/wCO19FeF/iV4S8W/ubDUEgvW/5dp/3cu7/db71fO5hw/isNdzV13WxyQx/vWmrM9H3Glqr89JurwvZI7qWMT6lumUzdT6xlA64MiaOsvVtJ03XLZbPW7SG+gX7qzL9w/wB5G6r/AMBrZpjVzYjBU6q5akdDppV50nzwdmjx7xR8N/7Qs/sbxw+KNM/58NS2rcxf9e91/F/222t/01r5I8Vfs7+ZNd/8IBe/6VbfPLot/wDurqL/AL67f7X3fSRq/RJvkrM1bSdH1y2W21i0Wfyv9TMu5Zov9qOaPbJH/wABNfKYjh7EYX95gJ27p9T6TC8QQq+5jFdd+x+OOqabrGg37abr1pNp91F95Jk2t/ve4qt51s/8W6v1F8WfDW51Wwltrm0t/GWl/wDPvd7YdTi/643HyxSt/wB+396+NPE37P8A++ubzwDcvc+Vn7RpOo/uLy3/AO+tv/j236tXTg+LVSnyY+PK+/RnY8lhXhz4Z3XbqeE7Vpvl1PcWOpaZeS6bqVs9pdQffSZGV1/4C1Mb/Yavq4zp1Vz02mvI+ar0p0p8k1ZopSR/3/mrOk0uG5/1P7hq3Gquy/x1jOh/I9V1N6GMnHqcnNa3No//ALOvSrtvq2z5Jl/4Etb8nz1mXGiwy/PZ/u2/T/7GumlmE6VufU9ONanV92Y+OOG5/wBTLu3VBJa+VWNJHc2L/vlaNq0rfVP4Lla+nweawkuaL+4U8POPw6o3tL17UtOf+KX/AIF84r6Y8A/tCeJNA8u2muf7UsI/+Xe5++n+6eq18wwxwy/8e0nmLTZLP+P5lZa+no5/TnH2WMSnDz3R4eLwFGrLaz7o/Wfwf8WvB/jOFfs1ytpe/wDPtNw3/AW/ir0eRU++lfi1Y69f6dMvnM/y/wB3ivq34f8A7Rmq6RDFZ6k39r2XHyP/AK5P91q5sfwjQxC9pl8r+T3R4eIwmIw/mu5931LDI8b70ba1cX4V+InhPxnCv9m3yx3TL/x6XHyy/wDAf73/AAGu18mvz/H4CUL06qs+qZnh8UpfC9TN1jQfD3iTc+q23kXrLt+123yyf8C/vf8AAq+ffH37Pdnq8LTeQms/9Pdovl3Mf+9Gv/su76V9IbakjmeD50ba395a/Pcx4Nw8p89C8X3R9hgOJcRQ916rsz8o/FHwd8VeHt1zojf23YL7fvF/4D/F/nivLY9S+9Z3ETQXCt9x127a/ZXWNH0HxH/yEo2tLr/n7tPll/7aL0kH+9XgXxE+AcOtWctzNpsGs/3LuwXy7pP95a82Ga43LfcxK5o9GfTUvquPXPTdn2PzyqOaNLj5HrsfFHwx8Q+GppP7N33MUX/LGZcTR/7y155HqHlSeTfx+Q38W6vsstz2hiLTpOzOTEZXXpayWhvWesaxpn/Htc+ZF/cfmvXvB/xw1XQ5lh8+aD/Yf5o/++a8WVUn/wBS1RNDs/2q+2wnEE+XkqrmXZnzuMyrD1/iVn3R+jXhv45aDqiRJqX7uVsfND8w/wC+a9jtdU03UIVmsLtJ1b+KM5r8g7WS5sZvtNnO0Fei+Hfihr2gXizeY8DL/GlYVsoy3GfB7j/A8+FLHYP+FLnXZ7n6irJU8clfL3g/9oTTdQ/c63F/28Qf+zLX0Bo/iLQdfTfo+oQ3P+wrfP8A9818Pm3D2IwevLdd0e1gs8pz9ypo+zOoVqkWSqHzpS+ZXzh78J3941FkqTzKzlan+ZQUaO6iqXmUvmUFxkWd1PVqreZSq1A7llWqTdVZWqRWqJRGWVapN1Vd1FZSLLTUVCslLuqAJaKi3VIrUALRRuqv5lAD6jajzHqPdQAvz05Wpm6jdVgS7qKh3Gm7qLgTM1N3fJUe6inGQBRuoo3VcpAO+ek3PSU2n7QB+56b5lJTKPaASeZVndVWnbqPaAPaSmbqioWj2gFhaRv9mm0Ue0AXc9G56Zup1HtAF3PT1ao6bR7QC1up9Vlal8yj2hBYoqvupNxqwLO6o2aofMkqPcaALO//AGqN/wDtVUaSomkoAtM1I0lU/MpPMSpuBNupu6mbqft2pvdttVClObtFGdXEQpq8nZEfmVHJNCiSTOyqsa7mboFUf7VeaeLPip4V8NXP9mw79d1yT/U6bYbWmf8A326RL/tNXmUml+Ofifcxf2xs8r+DQtN+a2j/AOv65/i/3a7a9KhhlevKz7HnQq1cTrSVl3Z1XiL4sfbPP034er/ak8efO1F/3dnB/ut/y1rmfC/wn17x3ef23rEs+pSy/fvLz5bb/tjH8u6voDwr8J9H0DyLjXtmoXsWPJtkG22i/wC2f8W2vV2m/d+T92JV+6vSuH63jcV7mGXJHq+rFP2VDWo7vscl4V8B+G/CW2a2jW9v1+X7S6Lx/u/3a7Ca43/f/wA/8Bqp5lOr3MryKlh/f3fd7nm4rMKlX07Dt1LuemU7dXunmkqtUe56TdUTSU4xAkao91RyN/wHb/F/drx3xx8aPCvhKGdLaf8AtS9X/ljCfkX/AHpP/ia9TBZbVxM1Ckm2+xwYrHql/W57HJcJEnmTMqqv3mZsD/vqvDPG3x88K+GPPtrBvtd0ufn/AOWf/Af71fF/j74+ax4nf/R5/l/54RfKif8AAa8Kvr681ib7TqUvn/7NfWQyDC4Jc+Md32Rxww+KxHx+4vxZ7F46+N3iHxLcyf6T5/8A47Gn+7XiN0019N9pv5Gnl/2qX5KTdWOLzmpV92n7seiR62EwVPD/AMNWb3fVkPyJTtsdG002vK9qdoNSM1SVEtZ+1iEQ3U6OPzfuL8v8Va9jpN1fXP2G2tpr29/59ofvj/akZvliX/aavoLwP8C7zU7mL7fB/a919/7Hb/8AHtb/AO1O0m1f+BTf8BjevlM14roYa8Iay6JHrYXK5z996LuzxDwr4J1/xTPjSLTzoP8An5kVvJ+X/nmv35f+A/nX2D8K/gDH+71Wb95/1EZ//aH/ANp/GWvorwv8NdH8PQ/8TLZqF1/zx2/6Mm37vytzLt/29qekdehtNv8A/Qa+Wlhcbmfv4l2XbY66uZUsL7lBXfcp6Loeg+GEX+zYPMvNmz7XN802P7q/881/2U/HdV2SZ5fvtUO6lVa+owGWUsNDlpo+exWNnVd27llfuULQv3KFrvOQetS1EtS1AAtP3LUNMZq0sRcn8ynbqqVE0mz79VGhcft+U0t1SrXjvib4mW1neN4e8Kxprevfxw78W1n/ANNLuZfuj/YT94/apvBviLWLa/8A7E1XVJ/Ft7dv9on+xWm3+zd3/LNtrYWL+7vfzKjGRWHSlN2udNCM6seaK0PXaZT6ZUEjtxqbdVeiqRNyfdHS1Xp6tWxNx1FO3GofMegzJNxo3God2ym0rGlyZmqPcabTd1MoKZRTKAG7qjZqZ5lRM1WA7zKPMqFmpNxoIP/V+kdW8H6Pqf775ra6X7lxAfLcf98/eX/ZavC/HHwl03VYW/4STT/tcH/QUtIsTRf9do//AIn5a+qNtRNHXp1uGqa97DycX5Hg4fPqkfdqao/Kvxh8D9e8PI2q6P8A8TbS/vpPbc/J/tKtePzfaU/cv+/X+7tr9gNS8F2000l9ok/9l38v3tqK0Ejf9NIen/Al2tXz344+E/h7VfN/4SDT/wDhG9R/g1S2/eWEv+9/zzP+/t+ta4PibG5dPkxSbXRo9KeHoYr36Ds+x8D2tvtf/iVXL2kv+9/6EtdBDr1/Z/8AIVtvM8r/AJbwf+hMtdh44+FfifwTum1K08+y/gu7dWMf+z/u15gtxcxfck/4C9frmQ8a1JQ5qMro+cx+Vr4Ksf8AM+mvBPxu8Sad5SWepf2lar/ywuyzf+Pf6xa+lfDPxw8Max5dtqu7S71v+enMLf7si1+ZLfY5X3/NBcfwsnH/AI9Wta69qunffb7dF/3zJ/31X1E6+X43+LHkl3R8tiOHpx1oS+TP2Et7qG5hWa2lWSJvuspyD/wJauV+X3g/4oTaO/8AxL9SuNNl/wCeMv8Aqm/9kr6g8N/HjZDGnibT/wB02P8AS7Q7kP8AteX/APE15OM4XqL38PJTXlued9Yq4efJVjb9T6c8yneZXK6H4o0HxLD52j6hDd/xMqH51/3lbkV0FfNTw7i+Was0ehSxqkuZMsbt1FQK1Sbq55QNYTi+obttY+saLo/iFF/ti28yeD/UXKM0VzAf+mMy/Ov/AKDWxTGrzsZl9HEJwqK6PQw+LqUJqcHZo8X8WfDH+2bCOw1Kxt/FdlF9zeFtdSiT/YZdkcn/AAAxN/vV8l+JPgLc2z3M3g+7+1+R9+wv1aG5i/4E23/x8L9a/Rqqeoabpurwqmq2yz+X9x13LJH/ANc5l+da+Or8PV8L+8wEmvI+opZ/Ct+7xSv5n496pp9/od5/Zut2M+m3X/PGdNpP+433W/4DUVfqL4g+G6anbSW2228QWEv/AC5XiRrN/wABk/1Tfkjf7dfLnij9n/TftHk+Fb2fQL//AKBuor5if8B/5af98F1qsPxfOn7mMg0+/Q2nklKuufDy+R8rNC9R+X/wGus8S+FfFXhGTHiPS5LaD/n8t/31q3/bRfu/8CrmFkR03/eVv4l+YV9hhcbQxUE6bTPCxGFq0HyzViKRfNRkmXzFrGuNFhl/49m8hv7vUVvVC0dXUwvK+am7Mqjj5x92+hxki3ljJ/zz/wB2tS11z+C5XdW62z+Nd1ZVxottL/x7/u2/StPr84fGeh7enV+NWLsbW18n7lqrNbzWz+dbM0TL/EtYE1reWL/Puj/2v/sqvQ6xN/y2/e17uAzS9pxdrdiZYVx+B3XY6zS/GGq6c/8AFuj+668MK+nvh/8AtLaxYpFbeIf+JlAu37z4mX/db+L/AIFXyUs0N5/qajaz+fejba+3pZ1SxEPZ4xKS6PqjxcVlVCrurPuj9fPCfxI8K+M4d+j3qNP/ABQP8sg/4C1drX4vabrF/pFzHeWcjr5X904avq34d/tJa3Y7bbxCv9qWX+9tmC/738X/AAKvLxvCNPEQc8BO/k9zxMRhMRhvejqj7saOpI2eB96My/7prlPCvjrwx4zhWbR75Gn+81s/yzL/AMB/irrmWvzvG4BxvTrR17MWFxvN7ydmZeueH/D3ieH/AIndpun+6tynEif98181ePv2b4dVRrnTY01KD++m1blP++fvf+O19T0xf3T70Zlb618DjeDYc/tMNLlf4H2WX8UV6C5J6o/J3xB8GfEmhvJJpu+fy/4MNG//AHy1eZNNeWc32W/geCf/AGlxX7XX1roesp5OvWKXP911+WQf8Crw3xt8BbDxDD/xJ1h1SLn/AEaZVjuE/wB2SvP/ALSzDLv94jePdH0lDG4TGr3NG+h+aO7/AHab/v1654s+Ceq6ReS/2P8Au7iL/lwu/lm/4C3SvHLqO80y5+x6rbPaXS/wTBhX1+WcQYXFRXJLXscmIy+rSvpddyT7H5TedbTtH/u11Gh+PtY0Cb+KT/bT5XrmWZ5aYzPX1mCzfEUtL3XZnk1sPQxEHCrG59e+Df2iLmLyobyf7av/AE8f6xf+BV9KeHfiN4Y8S7UhuVtrr/njMyr/AN8t/FX5RzWsMvz/AOqb/ZrWsde1jStrpP56rXZVwuW4/wDirkl3R5UcqrYb38LO67M/YJaXzK/PPwP8fvEmlf6G8/nxf8+9z83/AHzX1B4Z+O3g/WXW21X/AIlF038T/NC//Av4a+cx/BGKpe/RtNd1ud1LO3F8laNme3eZUiyVRjkhnhW4tpFnil+ZXQ7g3+6Vp6tXyNei4StNWZ7lLEQmk4PRmgslSbqoK1SedWEom5oK1P3VSWSpfMoLjIsrJUm6qW6nbjWdh3LfmU7cap7qduo9nEdy3S7nqsslL5lZuBZa3U1mqv5n+3S7v9qpAmqKovMemtJvqAJ6Kr1LQA+ioabQBY3UVX3UbqsCxRVemUAW6ZUVFAEtFV6N1AFiiq+6jdQBYoqvRQBY3UVXpVk2UAWqKg8yl3UATUbqr+ZHUbNQBc3U7dHWfupvmVUYkF1pKZ5lU/OqLzq2AuNJSeZVFpKhaSgUpcpcaaoWmqqzO9ZupatpWjwteardw20S/eZ3Va7MPl9arNRpxd2c9fGU6S5ps2vOpfM+Rpn/AHSr95m4Wvmbxl+054S0NJLbw9B/aV1/ff5Y/wD7KvlfXPip8UfibctZ2c8/2f8AuW/ypX0c+HKWBh7fMpqK7dWcFLFV8U+TDxvfqz7V8dftEeBvBW6ztp/7Zv1/gt2+RG/2mr58m+JnxU+Ld59mh36NpEn3IbRGE0n+7W78Kf2U9V1iSDW/FX7i3+/+9T/0Ff4q+9/DPg/wx4MhWHRLRftG0K07L8//AAH+7XzOL4p+s/uMqhZLdvqd8sqoYX38Y+Z9ux4j8N/gSmj6bv17/iXxT/fRObqf/rtN/DX0Lpun6bodhFpuiWiafZR/wIPvf7TN/eq3JI8v32qDdWmX5Db36+r7s8nH5vOr7kdEuiF/3KXdRRX1ChFbaHiD6Kg8yjzKsNi1TKr+ZXN+IPF2ieGofO1i5WJv4U6u3/Aa6aGEnUmlBXfY4sVmVOgnKb0Oprzzxl8SvD3hCFkmnW5vf+eCN/6F/dr5l+I37SU3zWGgy/ZIJM7tp/eP/wAC/hr5E1rxVqWtXMk3nvF5v948mvsMLw5Tw8FUx7t2S3Z5nt8Riv4Ssn1Z778RP2gNb1nz7CG58iJv+Xe2+X/vqvmfUNS1XVZPOuZPIi/u1S8v/vr+9S101+IJxh7LDRUI9luerhMvp0Ph1fdkEapF8m2neZRuplfPznze9I9DcKKKKzuA+ilVd9bGk6LfavefY9Ng+2zr/wABjj/67Sdv9379edj8yp4am51HojowuFqV58kVcxlX5Gmm2xxL952+6ter+Dfhrqus/wCn3/maNpP/AD1kXbdSf7it/qVbscNIf4RXuXwz+A9zc3MV9cRf2lewf8ttvl2tp/30rBW/76m/3a+xtD8I6P4aeO8/5CGqRf8ALy6/JFn73kR/w/77bpPevz/FZzi8wn7LCq0erPoFQoYNc9V3fY8m+HfwVsNF037Nc2n9jWH+u2f8v91/10+95P8AvNuk/wCuVe52tvZ6VZrpulWyWlrH82xB3b7zs38TN/eb5qJJneo91exleQU8P5vueLj83qV/JdiWn1DU1fQbHjDFqWiigCwtPWmLRuoDmsS0xqZuNR+Z/f8Al2/3q1jQMZ1orUduoavIfF3xq8GeF/MRLn+0rpf4LZlZV/3pPuLXxv8AEL9pDxDq/mWOmz/ZIJf+WNo2P++pPvNX1WA4axFWHtJ+7Bbt7HHDETrz5KSuz7X8bfFzwl4MhlW5uVu79f8AlhbnJ/4E38NfNP8Awsjxl8T7yf7NqCeG/D8eftN3/cT/AGG/iavGPCfgPXvFTwax4t862sJ/9VaJu+03H/s3zV94+B/hLZ21tbX/AIntIfKg/wCPTS9v7uL+606/xN/s18nnPFOEwt8Lla559ZPZH1mF4bdJKrjXZdEc/wDDvwT59h9j8MwTeH/CX35r+f8A5CWpO3/LSP8A55K3/PZvm9K+g9L03StB02PR9HtktLKD7qJ7/eZv7xarW7YnyVFuNeHg8PUn+8xDuyMVi/8An2rIfT1plOWvZPLFop9MpIAooplbAPpGao6TcaAF3UUVDQBNTKiameZVlku6qzNSVHuNACNTN1MkaqsjVYE0jVG01V91N3LVAf/W+zaNtMqXca/RZRPgLkDR1DJH/BMqsrfKy/eDBv8AZq9TGWsqmHhNOM1dGsJ296O551feDdiN/wAI3KkEUm7fpt3ukspP91esP/APl/2K+XfHXwb0HULnybO0/wCEW1mfP+jTfNaz/wDXCZfkb9G/6Z19vMtV7yzs9Ts5LDUrZLu1n+V4ZgrK3/AWr5DFcPTw8/a4KTT7Hu4fNub3MQrrufjt4o8F634VvGs9VsXtm/vY3RPt/utXKfcr9ade+Hsn2NrbTY4db0uX/mF6k27/AL8XHzOv/A9y18qeLvgXpWqzT/8ACHyPp+qfffQ9S/dzf9sJvuSr+NevlvGzpT9jj42ffudlbLIVI8+Hd12Pju4/9CqxY3mpaV/x53c0X+x95D/vLW5rnhvVdAvJbDVbSa0ni/gddtYEkez79fqGAzvmgp0n80fPV8POPuTWnZnd6X8QHs5lubnzrS9i/wCW9t8v/jv8NfSXg/4/a3AkX9pNDrtl/fh4uU/o3/Aq+K2h/wCA0RxvBN51nK8E6/xq2K+o/tmliYcmKSfn1R4uIyahL4NH+B+r/hn4neEvE+1LO+WC9/59Lj91N/3y33v+A13qzI/3K/I2z8XX9t/x/wAH2vb/AMt0+V69t8G/GzW9P8qGz1f7av8Az7X/AP7K33/51yVeHqFf38JP5M8SrgsVQ1tdLrufoZ9yhWrwfw78dvDep7bfXo/7GuP9v95D/wB/F/8AZq9ms7q21O2W5s50nib5lZHUr/31Xy+Ny2rQfLVTQ4ZjtzKzNSiqu10pfMrxZ0rHqUqykSbnSo7xbPU7b7HqttDewf3JhnDf3l/u/wDAaPMpK4cVgqdVWmtDuoYidKXNB2ZwmqeA3l/5AN95kX/PjqjNLH/2zuF3Sr/20Ei18tePPgXok9z/AKHbTeDdXl/2N1hcf7v/ACyb/gBV/wDpnX3BSyeTPC1neQJcwS/K8MyLIj/7yt96vj8Rw17L38LJp9uh9HheI/sYhXR+RniDwt4k8GyeX4g0/wD0f/n8g/eQN/vd4/8AgVYG5JfnT5lb+JfmFfqjqnw9s57aX/hHpUj/AOodd7mgb/rm3+si/wDHk/2K+WPFnwD02W5/4k+/wzq0/wDy7TfNBP8A7ir8rf70P/fFVhOJauGn7PGR+Z218qw+JXtMNL5Hyn5dReXXU694X8SeDptniTT3tom/5e0/eQH/AIF/DWM2x6+yoYqjiEnB3R85iMPVpPlkjPXf9x13Vl3Gk2cvzw/uG/76X/vmtxlqv5fz1f1RRbnT0ZdDGzj1OPmtbm0++v8AwNasW+pTRff/AHtdOzfP8lZ91ptrP8/+rl/2eh/4DXoUMwqQ92a0PQji4VPdmrCw3UNylLIv8cPy/wC7XP3Fnc2fz/8Aj61Yt9Sdf9d81e1g8drz03ZoJ4P7UHdHbaP4ov8ARni+Z/l+66cbK+o/BP7Q2saf5VtqTf2tZ/7Tfvh/wL/4qvj63mtrmpPngffCzQS/3lr6f+3I4hcmNgpLv1R4GLyqnVltZ9z9cPCvxG8K+M0X+yrtftX8VtL8sq/7q/xCu1kWvxysfE2q6ZNHdeZ80f8Ay2ir6h8BftGarAkVvr3/ABMIF/5a/wDLYf8AAv4q8zEcH08QvaYB3XZ6NHk16GIw0b2uu6PudakjkeJ96fLXF+F/HnhvxbCv9lXySS7dzQtxKv8AwGuzr4TG5bUpTdOrG1ujIw+OjV2dmGqQ6V4hh+y+IbFNQVfuu3yzJ/uyLyteG+LvgTomv2zJZt/akH/Pvf8Ayzx/7sy/e/8AHa9vp9fG5hwrha8nOC5X3Wh9TgOIMVh7JO67M/LTxd8EdY0O5/4lXnWkv/PhqP7qX/tnN9ySvHby3v8ASpvJ1i2mtJf9tev+7X7XXi2Gr232DW7GDULX+5MisK8n8SfA/wAP6zbTpo8/+v8A+XC//ew/8Bk++K8KGNzXLfcqLnh362PraGPwWN+L3ZP7j8qlkSSpo46+ivHn7PNzo00vkxvoU7fc81vNs5f+ucy/d/zxXz1rGg+JPCtz9n1uymg/6a/ejb/davpsv4mwmKXJez7MzxGUVI+9DVeRG1vDL99akjaa0+eGTzf7qtVeO4SdKuRtXv0cwr4eSnSkebOPMnGors7Hwz8WvFvhW5V7C9eCL/nlnMRr618H/tGaJqaRw+JI/skv/PaHmP8A75/hr4WkXf8Afjqv9n8r54ZWi/2a9irnGFxvuYyHzR588tt79J2Z+uOk65pWuW32zR7uG7i/2Hz/AN9L/DWruevyd0HxhrHh68W8s557SWP/AJbW719ReE/2nJk8q28VWi3cX/Pzb/LJ/wACX7jV5eK4XhVjz4OV12YUswrUPdqq67o+wlapVkrivDvjzwl4tTfompJO3/PFv3cg/wCAtXUV8piMvq0pctRWZ6NHNKc+poedR51UN2z79P8AMrglGx3wqqXwmj51HmVn+ZHT/MqTc0Van7jWaslSeZUhcvbjS7qoeZR5lTKPMUXt3+1S7qpeZTfMrKxZpbqN1ZvmU9ZKiwFzdRuqp5kdR+ZVAXN1N8yq/mUbqALW6n7qpK1O8ygC3uoqt5lOWSgCSimtJUO6gCbdTqpffqXzKAJt1Oqq0lR+ZQBa8yk8yqbNUfmUAX/Moaas3zqa01UBe86mtNVDzqjaSqhEzuX/ADqb51UlaiSSGBPOmkWKNf4nO0f99NXfSwVWb5YK5z18ZTp3lNllpKb5kleX+IPjF4D8OI32nVIZ51/5Y27bjXz34m/akufmh8N6ev8Avuc19JheEcVO0qi5UeXVzjm0pRbf4H2jJMsCbppViVf4mO2vM/FHxk8DeF932m9W5lX+CHmvz28QfFDxz4l3fbL6Xy2/gT5RXBzed/rr+f8AXL17Ucqy/Bx58RO/kZQwmNxTtey8tz6q8aftQaxffufDMH9nr/f+89fN2teMvE/i+8/0+5mvriStvwL8LfFXxDv1s9B092ib/ltX6M/C39lfwr4Jtlv/ABbL9tv/APngn8P/AAKvnM08ReT/AGXKKev5Hu0MgoYe1TEPX8T46+Fv7OOveMbyC51tX8pv+WCf+zNX6JeB/g74P8BQq/2SC7vYvZfJT+7/AL1elxtZ6dbfYNKgWytV/gT5f+BM38VVWbfXylDh3EYqp9YzKbk306IxxefWXs8KrLv3L0l48v8A8SvAFQ7qqq1Or7LD4SnSShBWR8tOcpSvJ3ZY3Gm7lplM3V1xic9ybdTN1Qs1Z99fW2n2zXl/OlpAv3nc7Vralh5SlyxOfEYuFNXm7WNHdWfqWqabots15qtyltAv99vvf7q/xV86ePv2jNH0DdbeHv8ASW/5+Zun/AVr4x8ZfF7xJ4qumm895N38U33f+ArX1eF4clFKeJfKu3VnlfWq+K93DrTu9j66+IH7R1hp6T2eg/uP+nl/vv8A7q/w18YeJPiJr3iOaR3nfym/idss1cLN/pM32m5Zp5W+9upu3+4u2u/+1IYe9PCxt3fVnZhclpQ9+o+Z93siZf4nf5manVHFS14VWq5Sbb1Z6YUNRUbNWJRHTN1PpF/56f3audRJOUnZI2Jf4N9Hk77mCFFaWWX7kMK7pH/3VWuv8M+A9Y8TzR3MK/YrL/nu6/O//XGP/wBmr7C+GfwRhs/9Js7T7NF/HqVz/H/e+bq3/bP8TX59mnGEIz9lhVzS28ke9hMm09pVdkfPXg34S6lrk0E2tq9pby/8udtzPI/91pF7/wCwnze9fb3gn4O6J4cto/t9olt5X3La3/8AZpF+7/tKh3eslelaHoeieGIfJ02Ldcfda4bbvx/dTb91f9lfxq7JN5tceA4er4j9/jXfy6Iwx+cql+6w+nn3Lf2pI4Y7azVbaCNdqIiKqJ/uqv3aqbqiWivsaWHhSXLBWR8xOrKTvJ3Jd1G2mLT1atAiWFqWq9P3VEih9FR7jS7f3bTP+7iX7zNwK0hCTMKuIUPiY/zKT7iNNM3lKq7mZjgLXlnij4weGPDSSw2f/E0vV/uN+7H+81fH/wARPjxqWseZDcX21f8An2t+E/8Asq+sy3hqvXtOp7q7v9DxnjZ158lFXZ9aeLvjN4Y8OeZDpsn9qXS/88f9Wh/2pK+OfiB8dtV1n9zcah+4/wCfS2+VP+Bf3v8AgVeDap4q1XXJNnmfZLWt7wT8O9S8W3P7n/RLBf8AW383/stXmvEeVZHT5oLmmurPpMq4RqYhqpiXp2Rz/neIfGOpfY9KgdvP/hr6p+FfwH8i8WaaD+1NW/vv/qbf/e/u17j8L/g3Z2dn/wAS2D7FYf8ALa+f/j4uP+uf90V9LafY6bo1mtho8C20C/3ert/eZq/Fs24qzXiOXLUk4w7Lqfff7LgIctFWZznhfwPo/hj/AEyb/iYav/Fcuv3P9mFf4a6xpN9QSSb3pa97K8op4WHLBHyWNx9StNzm7hRtop9eujzSRaWo1an7jTAbRRRQAU3dQ1JuNaIBaZSbjUTNTAfuNV2ajdTd1WAM1M3U2Rqj8ygsXzNlRedULSU1quwDmaqzNSM2yoJJKogRmpm7bUTSVB5lWRc//9f7K3Ubqr02v072Z+fl3dRuqvG38FS1lKIDtu+o5Fp1PpFlbaayNW0nTdatvs2q2y3Kr8yt0dD/AHlZeQy/3l+atxlqPbXBiMFRqpwqRuma0q8oS5oPU8K8ZfD3+07P7Nf2n/CU6d/cmKxalB/1xmbakv8AwPa/u1fH3iz4I3m+5v8AwHO+pRW3/Hxp1wPKv7f/AK6QtzX6Y+XXOa14X0TXvLe8ttt1B/x73tu3lXMX/XORf/2favmPqGLwE+fBS07M+lw+cQqrkxKv5n443Frc2kzQ3MbRtG21ldWUgj+Ha1Qba/Svxp8K7HWU/wCKn099Xij/AOYvp0Sx38X/AF3t4/8AW4/vR7v+udfIvjL4G+IdMs/7b8Kzp4i0P/n4s/ml/wC2kfqv8VfRZbxbCU/Z4pckvwJxmTc656LujwyoJrWGX/eqfb5T7P7vy/jTq+7oYp6Om9D5ycJ0pFqx1bUtO/c+f9pg/uTf/FdVrvfC/wASLzSLzztK1K40iX+5v/dv/wCyf99V5x5e+opreF/vrX0uCz+tD3KnvJ9HsclbC0qvxrXuj7u8K/tDXieXbeJLT7XF/wA9rfbG/wD3z0avofQfG3hLxUn/ABJ9ST7Q3/LB28uRf+AtX5D2t5eWPz2c7x/7PVP++WrutN+IE1nt/tK227f47f8A+JrbEYLLcX8HuPy1R41XKMRS96i7rt1P1iaHbUdfE/hH46a3pUMf+nJq9r/z73J3Ov8AwL7619AeHfjZ4P1nbDqTf2NO38NxzHn/AGZV/wDZttfOY/hrFUlzwXMu6OVZhy+7VTTPW6NtMjktrmFZraVZYm+6yNlW/wCBLRXy06Ul8SsdlLFQls7ke16ZMsN3bNZ6lbR3cEv3kmXd/wChVapjLvrir4KnVTU46M9OjXlC0oOzOO1DwPDqEMqabIk8X8dpqPzD/dWb5v8Ax/dXyn4y+AujxXP/ABLfO8LX8/3La42/Ypf+ufb/AL9t+FfbC/J/FUjTR3MLWd/Et3ay/K8Ljch/3lavmK3DVWh+8wcreR9Nhc+5lyYmN13Pya8ReD/EPhJ9mt2TQf8ATdP3kD/7si/+zVzFfqbrXw9s76OT+wZ/I3f8uF3ultnX+7/fX/x5favlzxt8C7OKZpvKk8JXsn/bfTJX/wCun/LL/wAd+lLC8VVKE/Z42NvPodNXK6Vdc+Gl8j5R8uo9tdj4k8D+J/CT/wDE+09oIP8An7h/e2zf8CX7v/A9tcvth/3t33Wr7PB42hiUnGV7ng18LUpStJWK23y/9rd/wKsu60eGX57P9236f/Y1stHTdtbVcHaXNTlZm+Hx7j5o42a1vLF/4l/2lq3Dqz/8vHzV0cn3NjruVqyLjR4X/wBS3lfyrSlj6kfdqr5nfGvTq/FoWVmhuU/ctTVh8p/kZo2/2awJrG8tvn2/981NDqk0X3/3lfRYDMOX4JWsRLCfyPQ67TfEGqaZcx3NtO8csf8AGjYr6x8B/tEarZwxw6wy6vbr/wABuE/4F/8AFV8b291Z3Pyfd3fw0+S3e0fzoflr6z+2oYmHs8UlJdH1PDx+VU6j7NbM/XDwn8RvCXi5F+wXax3Tf8u1x8sn/Af71dz5dfjtpfjK8051Sb/vv+MV9Q+A/j1remQxJcz/ANr2C/wTt++T/davIxnCVKveeCnd9nueFWpYjC/Erruj7norh/CvxE8K+L0X+zbvy7pv+XaX5ZP+A/3q7Rmr4PF4KrQm6dVWa7l0MfCXwsstcJPDJZ38SXdrJ8rQzIrIV/3Wry7xF8I9B1i2n/sGdLLz/v2V4nn2b/7u7mOvRKdXxmacOYfEXnaz7o+jwGc1aD9yWnY/PDx5+z3/AGdNL5Mb6BL/ALf72wl/3Jl/1f8AwKvnTWtF8SeErn7Hrdi8H9x+scq/3kkX5Wr9nFuE2NbXMazwS/K6Ou4MP91q818RfB3w9r1s0Ogypp/mbv8AiXXaedZyZ/2f+Wf/AAGvmefMMs+K84fij67D5vhMX/HVmflDDfLKn+1U+6vpPx1+zbc6RN5z20+jf9PNtuvbL/x395H/AMCrwbWvBPjDw0n2m5tvtth/z92zebH/AOO/dr3cBxRhMRZXs+zNK+UT+Ki7ryMWofsqfwfu6dDdQyp96rXl76+npYqUPepv5o8SV1eMlYijvtVsfnt5fu/3DivUfDfx+8eeHdsM2oPcwL/BcjzP/Qq8vqKSOH+Ovdw/EL5OSrFSXmc8sFTn8UT7I8O/tQJc7f7Y0hZP+veXa3/fLV7LpPxm8Aaqn769fTZW/guYv/Zl3V+Yv2OH7+7bViObUoPntrv5f9rmrn/Zlf44280Yf2VUj/An8mfrpY32laqm/StStr3/AK4yq3/jtXWV0+/X5O2vizWLH59v/Akfa1eh6T8ePGelbUtr65Zf7tx+8Qf99bq5J8OYSr/Bq29SlicdT+OF0fo6snz0/wAyvjPSf2nLhP8AkMW1tP8A7u6M16Pp/wC0R4SuU/fW00f+66tXl1eD8UtYNNeRp/b3L/Eg0fRHnUzzK8u0/wCMHgPUP+Yl9m/6+EZf/Hl3V2Nn4i8Pan/x4ataXP8AuSru/wC+a82rw/i4fFGxvRz/AA8utjofMo8yq23f9z5v/Hv/AEGjbJ/tV5VXC1I+7KJ6FLMqUvhkW/Mo8yqDM9M8x65PZSOxVV3NLzKPMrN8yjzKjkkHtYml5lHmVm+ZR5j0eykP2kTW8yjzqyfMo8yjkkV7SJredTPtHvWZ5lI0lHJIPaRNP7VTftHvWXupd0lHspB7SJp/aPenedWeqzf3akWOb+61OOHm+hEq6XxMstcVH51U5l8hN80ixf752/8AoVYF14o8MWf/AB+azaR/9tVP/oNd9HKMRV+CLOarmFKPxyOo86m+dXkmrfF7wHpn/MQ8/wD3P/sq8+1L9pLwrbf8edo87f7Tqte5Q4PxsrOSsn3PMnn1Pm5aabPpqkb5Pnf5V/vN8tfCPiD9pjxVcv8A8SeBLJf9gZP/AH01eUal8TPFuuSb9S1C5n3f35Wx/wB816S4UpUta9VLyQLH4iXwQ+8/RrVvHXg/Rvkv9Wt1lX+BG8w/+O15nrX7QXg/Tf8Ajwtp71l/iYrEtfBk2oarc/8ALfav+zVHyd3+ukaT/errjTyrD7Lma7mUsLi6vvTlZdkfUWvftPa9c+bDoltBaf8AkQ/+PV4R4g8deNvFTb9S1KZl/wB9sf8AfNc2q2yfcWomm2U58S1fgw8VFehVLLacJXmrvzKrWu757mekWOwi+ej555ltYVaeWT5VVPm+Zq+ofhX+y74k8W+XfeJI/Ig/55ZUf99NXyWdcYewXLKd5vZbn0GFwHP701ZI+dtD0XxD4qufsfh60dv9vbmvuL4V/sgwokGvfEKfav3/ACP79fVHg34c+D/h7bRw6bbQz3Uf/LXYuxP93+9XYXF9NK+923V8nSy3G5lP2mIbjHt1Zti85p4dcuH37jNJ03Q/DFgum+G7SG0gjXbuUDeama43ffaqDSb6buNfc4DK6WDgoUlY+NxWKqV3z1JallpKcrVAtFeiccY8pdWjdVZW2U5W3fP/AA04QkzKrVjH4mPZv9qo5JEgha5uWWCCL7zucAf8CavM/FnxY8MeEklhj/4mF6v8Cf6vP+01fFHxC+N2t+IbpoftbMv8FtD/AKtP+A19VlvDVWrapVfJDu+p4s809q3Twyu+/RH1l4y+OmiaCk8Oj7bu4XP71/8AV/8AAf71fE/jz4veIfE9yz/a5Jf0RP8AdWvLL7Ur/U233kn/AAGs/wC7Xvf2hhcF7mDjr3e5eHyn3/aYh3fbohtxNc3L75m8yo9tO3VFXgYjG1Kr55PU9+P8uw+pVqKmNXHcmxOzU3dUVPpSCwNTVWn7U2edM22P+83+fmr0fwr8Ode8Q+XcvG+m2De3+kyf3VVf4d3/AH3Xh5rn1DBw1d32PVweW1a+y0XU4PTdPvNVvPsFhA9zP/cT+H/aZv4a+jvh38DZtTvI3v4P7Svfv+V/y7Qf727/ANDf8BX0T4B+COlaHZxvqUf9nxcfuU/4+Jf+ujfw/wDode8W7WemWf2DSoEtLVf4IRhf95v71fB18Rj83f8AJB9O56Xt8Ng/g1Zx3h34e6JoKLNqW3UL3+5/y7J/wFv9Z/wL8q7WS6aV/wDx3/ZVf7qr0qm0m+o91fW5Vw/QwkPdWvc+dx+aVK/Wxb3Ubqr0vmV70pHlE9PqGjdurGRZYWiolap/4N9KNKUhTrKO+geZUleceJvid4S8KoyTT/bb1f8AljAynH+83Ra+Q/iB+0JqWp7ra2n+xWv/ADxhb73+81fUZXwvVr+/LRd2eZPMpVXyYeN2fYPir4peFfCUMnnTrd3K/wDLFD0b/aavi74hftAarrzyQ/afIsv+fa3b/wBCr5z1jxJrGuTNc7mji/3q5tV83/ar6nlwGWw5oLmfd7I78Hw5OrJPEu77LodFq3izVdXeXyf3EH9xaydPsbm+uVhto2u7qX+HG6uu8G/D3W/Ftzsto/Ki/wCe3RVr7y+F/wAE9K0qGKaGD/fu3G5z/u1+OcV+JFSvU+r4PV9z9OyzJ6GFp+0qJJdEfPfw5+At/q9zBc+IYPN+7stk/wDZq+9fCvwx0fQIYJtVVJZYP9TbQ/8AHvHj/wBCrrNNsbPRYfs1hHt/vN3f/eq80jvXw+H4aqYqp7XGSv5HFmXEP2KSsi3Jeb/3P3VX7qr0X/gNVvMqOivvsNh4UkowWx8hVrucuab1H1KtRVKrb66DIetOptFABRSbjTaAH0yms2ym+ZQBJTGprNTKuMrAL5lR01mpjNT3AfUbNspjNUcjU5RGhJJKg3UkjVA0lXTKHs1QS0jNVaRq1IHM1VZmpsjf7VVZJK0jEzlIczVX8yoWmqHzKuxFz//Q+vafuqtuNP3Gv1A/PCaimLT6n2gEitsp3mVDTqiUftATeZT2belVqfWcomiCo2Wn7jTd1YyiaKZWkWuR1Twjpup3LalYSvo2qS/8vlptXzP+u8bfu5l/3x9DXZMtVmjrzsblVPELlqK51YfG1KT54PU+V/iJ8J7PWPNm8VaN5n/Ua0VG/wDI9ty//oz6rXyf4m+DviHSof7V0eeHxBpH/PzZfvNv+9Gu7/x3d77a/VNt/wDerhNW8F6bfTT31hK+kajL9+5tNq+b/wBd4W/dS/8AAhu968OGHx+Xf7rK67M9+lmuHxHuYmNm+p+R7b4vv1J5m+vuPx98K7C+SSbxVpqWUv8A0HNNT9z/AL1xD8zx/wDA8r/00r5c8XfCvxV4ST7ZHB/aWl/8/tt8ybP7zKu7aP8Aa+ZPevo8o4zoV2qeIXJPszlxuQ8q9pSd0eetULQ76Fapt1fdwqpx5oO9zwWnH3djNa32uro23b+Bres/FWq2PyXP+lxf7X3/APvqqdM216eDzSpQacGD5Kq5akbo9c8G/FbUvDX/ACL2pPZbvvWz/NGf+2bfI1fUnhX9oywufLh8Vaf5X/TxafN/31G3NfnhJZo/36sW99qunf8AHvOzL/cfmvoHj8DjP97p691ueXishpz96k7M/YXRfEHh7xPbfadE1CG5X+JVPzp/vK3K1oSQvE9flFoPjibTpopvPlsrqP8A5bI7f+hLX0r4V/aM1Wx8uz16L+14P+ey/LN/319xq8zEcI8/vYCamu3VHmzhXoStUV13R9keZso/1lcP4d+JHgzxVGv2DUFjnb/lhP8Au5P/AB771dp/uNXyOKy+pSk4TTT7MqGMg+pMsez+KrP2iTyWSZUnVvvK65Df7yt96qCyVI0leTiMvp1Y2qJNHo0sY4+9B2OWvPBulSo39if8Svd96DZ5tq3/AGx/5Z/9s9v0r538cfBHQZ/Mubmy/wCEZuv+f+z/AHunyf723hfyjr6tqxHM6f7rfK3uv92vlMVwuoT9phG4v8D3sLxBO3JXV1+J+XXib4Y+KvC/+kTW326w/wCfu0/ex7f7zd1/zzXnbLvr9Ybzwjptz++02T+yLj+7Cu62k/3of4f95NtfPPjj4N6Pc/6Tf2n/AAj963/MRs182wl/67fd8v8A4Ht/32rmjxBi8F7mMjdd0epHBYTF+/h3Z9mfEG2opFr0fxZ8OfFnhB/O1Ky82yb/AJfYP3sB/wCBfw/8Crz1o3X79fZYDH0sVDng0zyMVgqlCfLNEK76pzabbXP/AEyb/ZrQplbVaH2oOzRFDESizlLjS7mD+HzF/wBmo7fULmD+Ld/stXX7qp3Gn2dz/Dtb+8vy1cMwqUv4mvmetDEQn7sytDqVtP8Af/dtTmtXR/tMLbf92sq40W5i/wBT+8X9aqQ3VzbfxV7OAzmHN7krMPqfWmz0TS/FWpaZt8797t/B1r6b8D/HjxDaJHDNcprdkv8AyxuPlnT/AIF1/wDQq+NIdWR/9cu2r3/Ta2b/AL5r6n+2/rFPkxEVNfifO4zJoT961n3R+qvhn4reD/EXlw/afsV1/wA8Z+P++W6NXpXyfwV+Pln4q1i0/wBd+/g/8f8A++q9l8J/HTWPDyR/Y7t5bX/n2uTu/wC+a558K0MX/ucrN9GeJPL8Xh/h1R+jrUz7lePeC/jZ4Y8SwxQ3Mn2K9b+Cb7h/3Wr1xZklTejbv1r4nMsjxWGm4VY2IoZgpaPRro9DQhvpovuNXHa14B8Ja+7XKQf2RqMv/LxZ7V3f9dIW/dt+VdMtDV8dj8hoYj442fc93BZrVw81OlKzPjr4lfs92f7y8mtPI/6i2mj5P+3i3/h/zzXyv4k+HPjDwxD9phX+2dO/5+bTc3/fS9Vr9cobqaD7n3f4vSuR1jwH4Y1x2ubNn0K//wCnb/Uu3+1H/wDE18hXwWZZbP8A2f34dj7fD59hsV7mJVn37n5Bw3iTv87VbaZK+y/iR+z1dfv9RvNN8/8A6ftJG5/+2if/AFvxr5Y1T4c+JNP3TWH/ABObVf8Anj8s6/8AbLv/AMB3V6uA4rw9dqFf3WujOirlL5eak7o5anVltceQ7QvG8bL8rK/Vatqyf/tV9XBqUFODujypwcPdkrFmio1ajzKzlEqNeXwi+Wj/AMNRfZUd/kbbViitaWIqQ+Bhzd1cjVb+D/U3zVOuoa9F/wAt6buWl3GvToZ9io9TKdClL4krm5Y+OPGFj/x73s8f+5K1ddZ/Hjx5Y/J/al38v952b/0KvM/ufw0fI9d/+ss/+XkU/kc/9l4eX2bHvdn+0542g/4+WS5/34l/9l2119n+1Rc+T/p2nwM3+yrD+tfKnlo9M8mP+6tR/a+Fl8dJXI/san9lteh9d/8ADUlt/Hpv/j7U1v2orP8A6Bq/99NXyN9nj/urTvJhT+Ffyp/2hhP+fSF/Y8P5n959gR/tPW0v/MPT82q0v7TFn/0D4f8Avpq+N9kf92m+Wn9yj+0MF/z6RH9jP7M3959lf8NM2H/QPi/77pkn7UFh/wBA2H/vtq+OPJT+6tSbI/7tTLH4L/nyiv7Gf87Prpv2pLP/AKBa/nSf8NSW38Gl/q1fInlx0bY6n+0sJ/z5Q/7H/vs+s5P2oN/3NLh/4FurPm/aa1X/AJdrKFfwb/4qvlvan92pBsrL+1qEdqSD+xv7zfzPftQ/aS8c3KeXbSJaL/sR81xl98avH8+7/iZXPzf3ZWX/ANBrzQ7Ki3VvS4jlGP7uCRp/Y9L7eps3HjLxVfTedcTzSf78jN/6FWfNrWvS/wDLXy6pM1N3UqvE2Kl1t6HTHL6HYiaGa5+e5ldmp8Nr5dP8ySl3GvFr5hXq355HXGFlayJPLp26iq7V5sfe3D2vMWPOpvnVTkmRK67wf4F8VeOLn7N4esWaL+Od1xCP+Bd65cfiqGFg51XZI6KVCdX3YrU5aSb+4vzV6v8AD/4K+M/iHeRw2Fo8Fu3332/5219f/DX9l3QdASDVfGEvnz/f2/xt/ur/AArX1PbyWGm2a6bo9sllax/wQhV3f7zfxV8h/aGMzH3MJHlh3fU6auKw+E96bvLt2PH/AIb/ALPvgb4cwrc3i/2pqy/8tv4EavbZtQ/c+Sm2KKL7qLwo/wCA1jNcbno3V9TlHC9DCfvH70+rZ8njs4rYj4np2RZ87dR5lVqfur6mMeU8qMuYl8ypVqstMkk2fxU40nP3YoU60YLmmy/uqRfnrltY8QaV4etvt+sXyQL95VZuW/4DXyv8RP2iofJlsNBl8pf/AB969/L8gq4jXZLdvZHiV86u+SjG7PpnxJ8QvDfhWGT7ZP8Aabj/AJ4o3/oTV8cfED9oLUtT3WMM/wBmg/54Qfxf7396vnjXPFmt65M32yRoPM/uGuZ2wxf738TN1r6WhVwOA/hR55d3sgo5TUq+/i5Xv0R0GreItY1z/XSNHb/733qw/LSJNlJ5lRbq8XG5jVxM+eo7nu0KEKS5IKy7IdTaKK4ywooornlIBjUyp9qfx09Y3eZYUVpZZPuoq5dv+A1jVxtOCc5uy8zppQnN8kVdlVt6fcrc0PRdY1+b7HpVt9rl/jb/AJYx/wC1I1ek+C/g/qviW5j+37oIv+eKfxf7LMv/ALLX3N4V+GeieGrOCF4Fg2/8sUCr/wB9f3f/AB6vhMx4oqYl+ywEbvqz3Y5ZCjBTxD+R87/Dn4D+VeR3l+v9oXsf/Lw/ywxf7v8Azz/9Dr660Hw7pXhqFfsq+fe/d85v4Fb7yx/3f/Qq0o5EghW2to1giX+BOFpvmVtlXDXL+9xLvM8zH59Of7unokWGkd6bUNP3V9ZCkoJRSsfPc9yWm1HuNLWgx+6jdUPmVWmuoYvndtu2uiGFnLZHNXxdOkm5yLm6p41d/wDdrx/xR8XPCvhyFvJuftt0vZP9Wv8AvNXyp4y+P2q6v5lt9p2wf88IeB/9lX02A4Uq1YKdV8q7s4IY2pXdqEW/PofZviT4peFfDUbbJ/7SvV/gg+4v+9JXyl46+P2pamklt9r+yWv/AD7W3G//AHm++1fM+peMNV1WZv3n2aKufVUi3O7ebK1exCrgsB/Cjzy7vY76GQznrin8kdRqXiTUtZ8zyW8iCuSZYYH+T943+1TJLiaX7ld54J+GviTxpNvs1+zWH8d3N8qcf3f71fI8Q8W/V4+1xE/RH2WV5R9imrI4i3tZr6ZYbC0eeeX7qJX0d8P/AIE3N28F/wCJ/m/uWict/wAC219EfC34Jw2lss2lW23/AJ76lcp9/wD65/3v/Qa+n9N8P6V4eh2aevmS/wAU7/f/APsa/FcVnePzmp7OldR6s+kq/V8D717s868J/DOz0xI5r+DyFXbstl+X/vrbXrK/J8ifKv8As1H5m+pK+oyjh2lhIaavq31PkcxzWpiX5BRRT6988gYq0U+igAWn0m40bjV2IFVtlKzb6j3UbqAH7vkplFMp2AfSbjS0yiwBQ1FRbqose1V/MpGaoWagIjt1Rs1MZqiaSqAGaqu6nNJUDNWsAGSSVVkb/apzSfeqk033q2MpSCSSqskm+opGqnJNR8UjFzHSSVB51Upris5ryFP4q7aVCUtkctXEQj8TP//R+mLfXLCeb7NDco0m3fs3ru2/3tta6slfjl4X8WQ2032z+0LnT9c/5Y3/AJjf+PN/D/6DX194F/aC1Wx8uz8bW32mL/oI2yf+PSRL97/gFf0ZX4RnOn7XCPmS3XVH5XiI1cM7T1t+J9qrJ/BUu6uU0PxJoniWzjv9EvYbuBv4kO7/APZrfWTZXxdbDuD5GrPqjShjYS6l/dT6r7qlrlqHXGVx+6nVFTtxrE1jIWmbqKZRYVx2401qbUbNSlALjWqLbT91MqbEkTV5vqXgOzV5bzwxP/ZF1L872+PMspf9+H5fLb/ppDtb/er0tqpt8n3K8bMMjw+MX7xa9zvwuZVcO+aDt5Hxf8QPg/omoTedqVl/wi2qT/cu4fmsriT/AK6fJH/wF/Kk/wB+vmDxV8PfFXgx2/ti0/0X/n7h3GL/AIF3j/3Xr9Y7hUnhaGZVlilXa6Ou5HX+6yt94V5vqngWSL/kVZ4V/wCobf7pLN/7yRt/rId3+zuj/wCmdeFShmGVfwXzw7Poe5DM8Li/crKzfU/K9ZE/56VYjr6u8YfBXw3q95JDYRv4J8R/8+dz81hdf9e8i/I3/bM7v+mdfOPibwb4t8E3LWviTT3hiX/l5T95A3/bRfu/8C219plfF2HxPubPszlxeT1IR54arujEqLbSxskv3Kk219NCrzHg7Fdo6dGs1n89nI0H/s3/AAGpqa1deHxE6U1KL1RrGb+HoOt9cv4JlaaPd5X8Sf8AxNe4eDfjd4w0p/3Oofa7WL/l3uf3n/oXzrXhPl1DNbpLs/2a+wjxbOcPZ4uCmvPdHPiMJQq7qz7n6L+GfjxoOqov9sWz6fL/ABN/rI//AIta9s0/UtN1e2W8025S5ib+4VNfklZ69qWlfcn8+L+7Nz/491rutB+JH2O5Wa2u5tLuv9/5P++l/wDZqx/srAY3/d3yPs9jwp5biqXvU9V+J+oDK/8AdpN1fJnhf4/apBGqa3GmqRf89k2xv/478rV9B+H/AB94T8S7fsd8sE7f8sZ/lf8A+vXgZjw1isL70o3XdbHN/aVvdmrM7Td/cp0c2z/OQ3/Aaj8v/aqP7tfL4jBppqa3PRw+Kjo4M5288G2H7yfw9P8A2JcS/wDLHZ5tlL/stbt93d/sba+ffG3wX8N3PmXOpWX/AAiV1/BqNn++0qT/AHl/5Y/8C219TVPb3TwfxfL93b6r/davjMVwzyz9phZcr/Bn1mE4jnGPs665l+R+XPi74X+MPB376/tPtunN9y/tP3sDf8C/h/4FXnUipX6zXnhPSp/MudEl/sSeT7yQrus3/wB62+6v/bPbXzX4++DOlT+ZNqWm/wBiS/8AQS0395Yf9to/+WX/AAIL/v1MM8xWEny42OndHoxweHxfvYeVn2Z8TbaT7tegeLvhn4q8IJ9smtv7Q01vuXdmfNj2f3m/u1wH3/8AZr6/BY/D4iHNBp3PMxGDq0H76sRtI9V5lhn+S4X/AIF/FVto6psu+rq4ClPyLoYuceuhkXGi3MX+p/er/wCPVRWS5tX/ALtdT5j0jeTOmyZVb/eojWq0utzrhjOb40YsOpJ/y2WtH9zP8/3qqzaXC/zw/L/49WdJa3lt8/8A6DXrYTPP59GU6EJbOzOlh1C5sWXyf4a948C/HTxD4e2232n7TAv/AC7XPT/gLfw18zR6g6f675quLNbT/cba1fb4PPVVgqde0l2Z5WNyenVX7xarqfqH4X+N3hXxEkaTS/2fO38Er5Gf9lq9ihmhuUWa2ZZFb7rLX422OoalpM32qH5v5V7r4J+OWq6C6w+fti/uS/NHWOYcL4TErnwrs+zPlcVlWKw+tL3l+KP0jqKvC/Cvxy0HWkVL9lglb+Jele02uoWeoQrc2c6Tq38SHNfA4/h/EYaXvrTuYUM1pyfJPRrozUt7q5g/1LVzeveFfCXifc2q6Wkd03/L3bfuZt3/AAHhq2m3pUe6vi8wyOhiLqrC7PewuZVaVp0pWPmvxx+z6mp/vv3evxf89k/c38f9JP8AgP8A3xXyP4k+EfiTTPMm0Rv7Sgg+/Ds8u5j/ANllr9SvMeL7lZeqaXomuJ/xOLTdL/BOn7uZP92Rea+WrZBjcH7+Cl8mfZYTiinXXJilfzPx4kk+zTNbXkb208XyskysrD/eWnLJC/3Gr9HPGHwJh16GSaGC213/AH/3F8n+633G/wDHa+RvEnwR17SrmdNK/ceV/wAul5+7f/vr/wCK/Onh+LYRn7PFpxf4Hrf2bCqufDu6PIt1FF9Z6lpFz9j1i0fT5f8AbX5f+A/3qZH+9T/WK3+7X11DEU6q54Sujxq9KdJ++h9CtTttFaGYU2nU2gIyHUbqbRQXzS7jt1IzU3caWiIc0u4UUUU5SNIVA3UeZTttN21l7VG46ijdRurnvIBtOpm405aLkylyjWqKpmpm2uqHwk+1Qxam201VqSsp83MHtUNqGnsyJ9+o13zzfY7eOSedvupCNxapnWVKDnUdkhxi5tRgSt/rKm03SdY165+x6Jafadzff/5Zp/wKva/h38BfEPi28X7fE8v/AE52/wDyz/67yN+7jH+8a+8fCPwx8K+BLZf3cN7fx/3P9RF/s7m5k/ILXyFXO6uIm6WCjd9+iO/2FLDrnxD+R8u/DH9l25vvK1Xxh+8X+FH/ANX/AN87vmr7X0Pw/onhW2WHTYEVlXau1V+T/dVeFq5JfSP/ALP+yvyhf+A1U8/569LAcI80/b42XNLt0R8/j+Ifa3hS0RoyXU0v36rs1Rbt1Pr7eFKEI8qVj5uc+Ydup241D92ms1awjzGbnb4mWPMqXzNlUmkigTzppFiX+83y14742+Nmg+F0kSw23M6/xv8Ac/4DXs4LJauJnyxV/wAjy8VnEKT5Iu7eyR7JeahbadD9pv51tov7zfLXzn8RPj5pujJJbaC3mT/d87/4la+W/Gnxm8SeJ5pIUn+Vv4v7v+7Xk7NJK/nTM0jfxbua+h+q4XBW5/el26Iwp5PiMS1UxTsuy3Z2XiTx1r3iqbzrm5f5v71cfGvlbn+8395uWp241Furlxeb1avuyenbofSUaFOlDkpxsh+7+OkZt9MWkavHlI1Gs1Juop9K5Yyk3Gm09agsfUn8G/7qxfeduFWr2n6feahdfY7OBruf+4vRP+ujfw1794H+DN/qF5BNfwf2hdf3OkEH/fXH/A3r4/OOJqOHfJT1l2R7GX5POr79R2S6njHh/wAH634ikj+zR/ZrX/nu6/O//XOP/wBmavrX4c/AtIo1vPK+zQSf668ufmeT/d/vV7n4d8B6J4eTfMqXt1/tL+74/wBlvvf8C/Ku0muJpfvtur5+llWMzKfPinZdEdmIzihhFyYZXfcqabpuleHofs2jq27b81w/Mj//ABNT7jTaK+zwWV0sNDkhE+QxWPqV5c83djtxpaio3V6BxEu6m+ZJTKp6lqGm6RbfbNVuUtIv7zt97/dX+KuuhhZzaUVds5quIVJc0noXo6ivL62sYWubydLaBfvO5VVr538XftAabp+6z8PRbZf+fm56f8Bjr5V8VfF7WNZmk3zvdy/7TfJ/wCvscHwtOMFUxUlBdnucsJYjE6UFp3ex9m+KvjZ4b0VPL03/AImEv9//AFcX+LV8ueLPjlf6n5kL3Pmf9MIflQf5/wCBV89XV9eX3/H5K3+50qvH+6+5Xof2phcL/ukbvuz08PwvT+PEO77dDU1LVNS1WbzrmXb5nvWZHHs+5Tqkj/e7f9r5f7xf/ZVf4q+czTOakvfry/4B9RRocto01p2RBJ89X9J0m81m5js7OOae6b7kKLuY/wC1/s1674R+EOt655dzqn/Ertf7n/Lfn+92i/8AHmr7e+H/AMG7PRrCCb7N/ZcH+u+ePNzL/wABk/u/9Nv+/dflWZ8e3k8Pgo8z79j3aOVxhDmxDsj5p+H/AMAPPkgm8Twfabqf99Bpdv8A+1P/ALLatfb3hv4e2elQwf22tvJ5GNmnW4xbRY/vf89K7CxtbDSofJ02Ly93333bpJG/vNI3LU+SR3/irxcLw9VxU/a493fbscmP4g/5d0VZGjcag8vyfwr91ccLWdTKfX2+Hw8KUFCCtY+Uq1ZzfNN3HLU1QKtT1uSOp9Mp9QAUUUVcQCmUM1NqyB1FNooAdRTaN1BY7dRuqGRqTzKAFkb/AGqgahvnqJm/gqgCRqrM1OZqgarANxqGRqjaSq7NQWSNJVZpNlQtJVWSatIxMnOJIzVUkbZSSTVl3V1W8KTZz1ZxXvDri4RKw5r5Ko6pq1tY2rTXMixKv96vnDxl8VNm6w02T738dfX5Rw5PE+9ayXU+cxGPqTn7Oirv8j1jxR4803Rv3O5Wl/u18xeJvidrFnrDXlnc/wCv+9A3zR/98/w15nrniq5uXb9/ulb+KuIkuHlfe7V9U8RhMug6dNXfVn0GWcOSl+8xLv5dD//S/M3bXRaT4g1XSv8AUyeZB/c6r/8AY1n/ANi69/z5NSf2L4hT/mHzf98tX7JgONaGGqKcKlmclXKalWPJON0e5+DfHl/Y3K6l4evvsV//AMtof4H/AOA/xLX2T8P/AI+aPrk0ej+JP+JXqny9/wDR5P8AdZvu1+Y0ek68j+dDY3Hy/wBxGrW+2eIbZ/OvLa43f39lfcQ4qyfNvcxjUZ9Gj5TGcH1budNf8A/bGFt6b0b5Wq8slflF4R+OXxK8NQrZ2E/2u1/543Cbv++a9htf2oviFEn+k+F0n/7Zy/8AsrV85jchUX+7qqSfVM8v+ysdSspQv6H395lL5lfCkP7VXi3/AJbeDv8Ax2atGH9qbxC//Mmv/wCRa855NPuvvLdDFR+KDPtrdTPMSvjVf2ntbf8A5kmdv+Byf/E1pW/7Tl4P9d4Jvf8Avpv/AI3S/sap5Mz/AH8d4P7j62ZtlRV8r/8ADTyfx+DdS/z/AMAp/wDw09pv/Qpax+SmolktbsvvCMqj+yz6lplfL/8Aw1N4b/5beG9Wi/7ZL/8AFUf8NUeDP+W2kaxH/wBsF/8Ai6z/ALGq9vxNP3n8r+4+nmqm1fNv/DV3w9T79pqUf/bBf/i6P+GsPhv/AM8r3/viP/45TjkeI7EylPs/uPo5lqq0NfPv/DVnw4/uXf8A3xH/APF0xv2pPhv/ANPf/fpf/i60/sDEP7JhOU/5We76hp+n6rbSWGq2kN7ay/fhmRWRv+AtXmureAb+C2lh0Sf+0LLZs/s7UX3fJ/dhufmk2/7E29f92uS/4ae+G8v/AD9/9+l/+LqWP9pb4b/897n/AL9f/ZV4+P4ElX+zZ90duCzbF4b4LtdmfPvjD4Q232n/AIltpN4d1H/n0dP3b/7Uar8jD/rif+AV4Rqml6xoNz9j1W28j+638En+638Vffl5+0B8MdQs5NP1L/SYJf4JoN3+WrxfxN8VPhFJ59tqumy6pp0v+x+8j/7+bS3+9973rxsLlWZZbPpKHZvVH0H9qYXGx9+DjPuj5bb+/wD3qGrb8Wap8N/tn2nwZc3f2Vv+WFzF9z/dauR/trTf+ev/AI5X1kcbSspNo86WCqc3Kk2kaNC1kf21Yf8APX/x00n9tWP+RVxxtF9V95f1Or2ZqSR7qoSWaVF/bNn/AHv0o/taz/56V10MbCPwsccPWj0ZNbyX9j89vO0f+z/9jXX2Pji8tkWG5i/4Gtcb/aVj/wA9aibULD/notfR4LiGdLTmuu3QzxGAVX+JC59SeD/jdrGmfuYdQ+1wf88Z2z/3z3WvpTwz8cPDesbYdYX+zZ2/j+9F/wB9L92vy9a4sP722tSz8TXmnOvk3fn16jq5bjP4tot9UeDW4W+1QbT7M/Y+1uLbUYVubCdLmJv4kKsv/fS1P5b1+Vug/GDWNDm87TZ3tP8AcevpDwX+1cny2fiqx8z/AKeIfvf8CWvLxfCNRwc8NJTXZPU4/qmNpfxI3S6o+vqPtDxf6v8A4FXF6T8UvAfiOHztN1e33f3HdY2X/vqtlda0qX54bmFv92Ra+QrZXU1hONvJijjlHrZozbzwjpU7/adEk/sS4/6YIptpD/00t/uf98bW96+f/HXwb0S8/wBJ1XT/AOxLr/oJab+8tZP+ui/8s/8AgX/fyvpBtUsP+e6f99rUbeJLCD788Mv+z5i18jjeDJ8/tMN7svzPo8BxhyLkr6r7z80/Fnw38T+F3Z/K/tCy/wCe9t83yf3tv/7Veexru/8Asq/U+6sfh/qv/HtKmmyyff2FWhZv+uX8P/AdteMeJvgz4V1eaR/kn83/AJbWf7t/++W27vzascPj8ywv7vE0tO6PYhistxP8Kdn2PhT/AHKZXrHxA+Gb+B/Im+0vPFd7vJ/cbX+X+9tZq8ya3/zivrqFqsFNbPucco8pRZqPv1NtqBoXpTwsH5GkZlVrOGf+GsqaxmirYkjuV+5Qq3j1HsJ0tndHbSq+ZjQ3lzbfcatCPULaX/j5j2/7S1JND5v+ujrLks9n3K7sJmtWkbWhL1N+3mmtn86wud1ereD/AIsa94euv+Pt4/8A0GvAlZ4v4qurfM//AB8/vK+vwnEba5aqumebj8mpYhcs1fz6n6MeE/2htNvNqa3B/wADhP8A6EtfQOk+JNB8RwrNpV9DLu/h3fP/AN81+PNvN5Hz2dz/AMBrt9B8bTaY/wA8k0Ev99DXbWyPAYyHPTdn+B8pV4eq4f3sO7rsz9YmjqLbXxb4L+PWq2e1Lm9XUoP7s/3/APvqvprw78VvB/iP9z9rW0nb+CVv/Zq+VzLhLFUFzwjdd0edLGuD5KqaZ2+3yvnTctF59j1WH7HrdsmoRfw71yU/3W6rVry1b54Z0ZW+7yv/ALLVeSN0r4HH5NQrpxrwvc9jC5hOFp0nZnk3i74Q6Vr2nyW2iTpc7v8Alw1H7n/AZtvy/wDAh+NfFfjL4J3+hXn7mKfRLqX/AJYXfzQv/wBc7j+Jf++q/SCZahmb7TbNZ38UOoWsv3oblfMRv++q+NxHCNfDe/gJNeTPrMHxh/y7xMbrufkTf6breg/8huxkjj/hm2/I3/AqrxzJL9xt1fpxrnwl8N6vDJ/wj0/9ly/8+0y+bbv/ALOG5X86+YPHHwFvNK/0ybS5tG/6ebf5rV//AInd/wABrjhxBiMPPlxsGvPofQQw+Fxa58LNPyPmmmVp6t4b1vQ3/wBPg8+L/ntB83/fS9VrFhkSX+KvqsLj6Vdc8JXR51fB1KXxonoo3UV2mAbqN1G2igA3UqtSUVLAloam+ZSbjXNySNPa+YtFOo21Ava+Y2inUUBz8w2lZaXdTWkhT+KtYyfyF+YbttV5rhIv+Bfd/vf981r6PoeseJZvJ0e2Zov4pmHyLX2P8Nf2Z3iS21jXpPsX8f2mZPMmf/rjC3/oTfk1eNj+I4U5ezpLmn2R6MMttD2lZ2R8w+E/hn4n8XTwfuHsoJ/9X+78y5m/65x/+zfdr7h+H/7POg+FYY7zXv3Ev/Pvbyfv5P8ArvcL93/dj/77r3HSdP0Hw1bfZtBtPIZv9dcTfNcS/wC9J/lfalkuHlk31x4fh7FY/wDeYx2XZHlY/iFUlyYZW8y3DJbadZrpWlW0On2UX3YIUVU/8d+81VWkd6i8ylVt9fb4PLaWHgoU1sfJ1cROq+ab1JVpy1FTlbZXfIzLStS+ZVfdurk/Enj7w34Yhk+2XPnzx/wL/wCzV14PLK2Inywjds4cVmVOkt9X0O03fJvf5V/vNwK8r8XfFrw34VRvJnW7ul/2vkB/9mr5d+IHx81XV/Ms9H/dwf3Ur52uLq81N2mv52k3fw19rh8mwuDh7XEyu+yMoYTFYtc1T3F+LPcfGHxo1jX3l+zSf7v9xK8Mvrq81O5a8v52nb/x1aI1SKo5K5cZn1Sp+7p6R7I9jAYClhr+zVn36siqXdUVP3V4M2egOptG6jdWXtCAo+/TKfUe0LBqYtKq7639D8P6lrlz5OlQfafK/wBc/wDywiz/AHmX73+4tedj8zpYSHPVZ0YXCzqy5IK7Zlrb7P3zt5cW77394/3VX+I16F4Z+H+pa1N515/xLbJv/AmT/wCNf+hV7l8Pfgz/AKV9pm/0u6j/ANdeXHywxf7K/wB3/d+/X07oPhvRPDHz2Ef2m/8A+fuZen/XOP8Ah/3vvV+f181xuaPlwytHa59F7HC4Jc9V3fY848C/CG20qwj+2Qf2ba/88dn76T/9r+8/5V7Nbx21jD9jsI1gg/ur/F/tMzfeaoZJnf53+ZvvfnSV9Jk3DVLCecurZ8zmGeVMR5LsW91M3VF5lN8yvpbHi85PupnmVWaTfWZqmsabodt9s1u7Sxi/h3dX/wB1f4q6qGFqVWlGOrOSvjaUFubm6qWoatpWjW32nWLtLRf7rN8x/wB1a+cvGH7QFnYpLD4bVY/+m9x80n/AF6LXyl4o+JF/rly03nzTyt/eavsMJwnyL2mNlyrt1ZjS+sYmypKy7s+uvGXx+sNP8y28Pfu/+m833/8AgK/w18o+KPihqWvXLTTSPey/9NmbivLGaa5/fXMm7/Zpm5IvuLXZVzvD4X93gofN7ntYXIaUHz1HzP8AAkurq51B995K0n+zUX3fufLQ0yVAsjyyfItfOV8XOredV39T6RQ05UrJE7f36Yu962NE0XVdfvf7P0i2a8n/AOWn8KR/7U0rfJGK+j/BfwN8y/gh1uJ9X1L/AJ8IY2aJP+2P35P9+bZH/vV8LnHF1DB3jF3fRI9PCZXOr72y7s8R8I+Bte8XTf8AEui8u1/5+7hW8n/tmvWVv92vsb4a/BO2judmj2P9oX/+ru9Ru/8Alh/wL7kP/XOPdJX0F4b+Ethp1tFN4kl8v/pztJF/75kmj27V/wCmcO3/AK6NXp7XSQWsdhYQJaWUC7YYYFVURf8AZVa+Df1/N53r6Q7HVXzDD4P3Ker7mTovhXQfCvlXP/IS1T/n5dNqRf8AXCL+H/e+Z6vzTPO+92qOivsMryelhYcsI/M+RxuYVK799jaVaWn168pHnBT1oqWmAKtO20LT6CxlP3UyiiMQH7qKZuptWAbqKjZtlMb56CCShvkqKmbqAJvMpjNUDNTdxqiyVmqLzKh8yo2aixBPu31AzVC0lRs1VYCVpKqM1NZqqNJ96qsEZfzEkklU5JKikkqnNNWkYinUJZJtlZ0l1Veaauf1DUobGFrm5kWOJf4m+7Xp4fBubUUrs8rEY2EU3JmjcX3/AAGvMPFnxC07RoZU3efP/cry3x58XIYHks9HZtv3Gf1r5r1jxZc3f+99c1+l5XwzSw1NYjGOy6I5qGDxGMa0tHv3PQPGHxCv9T3edP8Auv8AnjmvGr7Uprx/7tUZJJp3+ekVa8nO+LtHSwuiPtMvyunhYcsVqV2plWmWm7a/PZ42UviPWUz/0/W/+EB8K/8AQJt/++BTG+Hvg9/+YRbf98V6btNG2vblwTguz+8+S/tvFfzHlrfC/wADS/8AMJg/8epF+EfgCT7+lq3/AANv/Qd1eq7Y6kVYaj/UjCdGyo59iv5jyb/hTfw3/wCgJDTo/hD8Oov+YN/3yzCvW/IT1pfLjrpjwvSj9pm/+sWL7nlX/CqPh7/0C3/7+yUf8Kj8A/8AQNf/AL+yV6rtWnbY6r/Vul3ZP+sWL7nlX/CpfA//AD5Tf9/5Ka3wn8GJ9yO9X/dupRXrO2Ok2p/dqv8AV5fZk0THiHEdzyX/AIVT4V/576sv+7eyU/8A4VX4e/6CWtR/7t61eo01lpf6uf32a/6xV/I8sb4V6J/0HddX/t7/APsKoSfB/wAN3H+u13XW/wC33/7CvYNq1H5cdL+wH/O/vH/rDW/lR4jJ8B/A0/8Arr7Vp/8Afu93/oSVB/wzn8Lpf9dBdyf7zx//ABuvdfJShoU/2qr+xaq/5ev7xf29Psjwn/hmv4Sv/wAw12/4Ev8A7LVdv2Y/hL/0DX/77avemhSo/Ljqv7JxH/P1iefT/lR4L/wzH8Iv+fF/+/jf/FVDJ+zX8L0+4txF/uyN/wCzV78y1BJDS/sWrL/l9In/AFgn/KmeDf8ADOvw3T7l3eR/7u0/+hJTf+FA+D/mhh13UlVva3+7/wB+69wa3V6h+zpXNU4Wc/jqtmn+sdRfDBfceDt+zb4Dl/4+dUv2/wCA2/8A8Yqu37L/AMMX/wCYhd/98R//ABFe+tDUfk1l/qj/AH2a/wCteIWyX3Hz+37L/wANP+fl2/34v/iaqN+y78Pf+en/AI5J/wDF19GeXHTvLSs/9Uf77+8j/W3Edl9x80N+yr4G/gk/9C/+KqJv2U/Bn9/9Wr6g2rTdsf8AtUf6o/8ATx/eOPFdf7SR8vf8Mq+D/wDnvR/wyt4S/wCfmvp/yY/9ql8lP7zVH+qNb/n6zT/Wmr/Kj5c/4ZV8MfwXf/jq1G37Kegv/wAvbf8Afta+pPsv+9TVt9n8TU/9VKn/AD9Yf62Vf5UfLjfsn6D/ANBBF/7Zr/8AFUxf2U9Kt5P3N7ZXP+xN50X/AI8u6vqbyaXya78Pk2Kw/wAFZowqcU1JbwR83L+zrbRf8wnRf/A+5X/2jUbfs+/88dLso/8Ac1Nv/Zolr6X8s/7X/fVPxJ6/+PV7EMRmH/P5v1OKea0p700fMDfAO8/6B/8A5Ul/9mqD/hQd/wD9A+Zf929hb+tfVO6b+9S7pq1+uZn/AM/DH63hv5D5Nm+Aeq/8+13/AOBELf8AtSs2T4D63/zwu/8AvuH/AOPV9h5lpqyOlc2InmdWP8Q3pYzCw972aufBWqfs2+KrubzrP7Sv+xvX/wCPVzs37Mfj5P4Z/wDvtf8A45X6NfaHT+Km/armvm55Tmv2Kp7UOKKHwukmfm437NPj/wDu3f8A3x/9sqJv2b/Gyff+1/8Afv8A+zr9JWvLxPuN+rU37dqH/PT9Wp/Us4/5+of+s2E/59H5sN+zn45/u3n/AH6/+yqv/wAM8+PP+ed3/wB8MK/Spry//wCen6tTPtV//eo+q5x/z9RP+seE/wCfZ+aDfs9+P/8AnhNVOb4A/EKL/mHzPX6atNN/Htajzpv7sf5VlPB51/OmbR4lwn/Ps/LpvgT8Qv8AoEzNUE3wN+ISJ/yBpv8Avqv1Q+2TJ/DD/wB8LQ147/8ALOH/AL4WuP2OdfzI2/1pwf8Az7PyX/4U/wCPIv8AmFzUv/CqfHn/AECJ/wBK/Wdbyb+7D/3wtM+1O/34IG/7ZrXVhf7bpfbX3mf+sWC/kZ+TTfDnxmn/ADDZlqaHwj42tn/cxvH/AMCxX6xrcf8ATtD/AN+1p7NC337SGT/eRf8A2avfwvEPEOG+CQqmb5bV0nTPzn8L+IPjBoM0X2O+3Rf88ZpP/iq9rt/it8Uf+XnRrSf/AHLha+pmt9Hf7+k2jf8AbJaoyeH/AArP/rvD9l/37r3P9cM1n/vFOL8zxMVl+VVfegrHzovxS8f/APLbw3u/7brT/wDha3i3+Pws/wD3/r35vCfg9/8AmBW3/j1Q/wDCF+Ev+gJbr/us3/xVZf6xYmX/AC6Rw/2PgO7Pn64+KGvSo3/FMzRbv+mtXYfjl4ttrb7H/YU/kfc2f6z/ANCWvcf+EJ8Kr/zD9rf7Mkg/rTJvBPht/wDllOv+7PJ/jWdfPKk/cnRT9TD/AFfwPPzwm0z5O17xNDrVy1zD4Zn0n/r327P+/ePL/SvM/Enh2wewl1u80Lb5f/LaGRoJP+BQqhzX3ZN4B8Ny/wAV/wD+BTf+zUL4F0T7iXupRf8Abxn/ANlr4LMKNWU+fD0uX0PrstxdCkuWpO6Xc/JeG4m86VHX/wCKq19sH91q/U3/AIVT4P8Ammdp2ZvmZm8snP8A3zWVN8F/Bsv8U3/jorP+2swh/wAum7Hb7XLZdT8xPtw/uNT1vEev0qb4F+DG/wCWsy/ipqs3wF8Hv/y3m/4EkJ/9krGXEmL+1SZfJgP5j84ftCf3qXzU/vV+iMn7O/hWX7lz/wCQIapyfs1+G3/5fk/4Fbr/AOy0v9aa/Wkzb2OB/nPz8+0Q/wB6n+dD/wA9V/Ovuyb9mfR/4L22/wC/eP8A0Gsyb9mO2/gaz/8AHqr/AFtn9qm0RLC4L7NSx8T/AGiD+8tL9qh/56rX2FN+y+/960/77asiT9mOb/nraf8AfVa0uJlKXvU39xhPC4T/AJ+pHyn5yP8AxU1rhF++1ei/Eb4Zp4R8i2s2+1yyf88irIv+9zWp8O/2f/FXjG5jmvIPItf97B/+xrrq8R4elDnqaPourKhld1zwenc8wsbK+1q5+x6VbPdy/wB7pGn+81fRXw9/Z5v/ABPc/wCmR/2ldfx7P3dnae80zf59q+svB/wX8K+EraP7eyXvlf8ALtbbo4/+Bt/F/wAB/OvUZL5/s0VhCqQWUf8Aq7aFFjiT/gK1xUsLmWZf3Ifizkq5phcL8C5n3Of8L+BfCvgezghtoLfUr2D/AGP9Fif/AGVZcyN/tv8AhXRXl9NeOzzNuZm/ztqizUlfZZXw/Qwmy16vufIY3M6tefvv5A1FFFfQxkeZy3H0VHujqheapZ6ZC1zeTrGq100MLUqtKCuzixWPpUE3N7Gou+sbXPE2j+HIWfUp1WX+5/FXzz4++O1tY+ZZ6VPt/h/vNXyrrnjLXtemZ7mR9sn+1X2eF4epYdKpjXbyW5xUfrWMT5Fyp9X1Pon4hfH652SWeiNt/h+T71fMmpa5rGtO1zfzt+896xlh+f5/4qc0lGKzv3PZYVcq8t2e3gsqpUPhV31b3EVdlJuptMr5uc7/ABHpku6omko3VFWRcYjt1FR/PUm6spsuwUbqNxpyxu9YgLuqeG3e5dU/vf8AAt3+6v8AEa3vDvhfVPEc2zTYNy/892/1a/8AxVfWvgH4M2Fp5d5c/vP+nmUff/3V9P8APzV8pmfFEIT9jhFzT8uh61DL7JVKrsvzPFfCfwnvNV8u51X/AEayk/5Yp/r5/wDZ+X7v+6v4mvsTwv8ADWz0Ozg/tKNLG1i+5YW23Lf9dGX7uf8AZ/77rstNh03Q0/4lsW6fbtad/v4/ur/dX/dqRrh5Jvnb733q8DCcL4jGVfa49/IyxWewoQ9nh9L9S3537lbaGNYLeL7kMK7URf8AZVaiqHzI6b51fo2HwsKUFCmrJHylWs5y5pvUl3UvmVV81P71UNS1TStDtWvNYu0tl52r1d/91a9Ohg6lWShBXZ59XGwpLVmxud6xta17StATfqt9Dbf7Gd0n/fNfNfjL47Tb57PRG/s+Jf4v+Wjf/E18x65421XUpmkhZ5Gb7zsf/Zq+ww/DVLDxVTGzS8t2Z0KNfFfBGyfVn1f4u+P39neZbeHoFi+9+/uOX/4CvavlTxB8Qte1y8lmmu3u2b+J2+7XETedct515Ju/2aayp5exK6K/EWHw8OTAQtfdvc9/AZHRoe9PVhJI87+dc/vGb/vmofk/557ac1Mr5Stip1G5zep74/dUO2pGj+Te/wAsX96vUPCPwx1vXv8ASbmN9IsPv+fcL++2f7EfSNf+mkm1a+czPP8AD4ODnUevY7sJgJ1Xojy+30+5ubqOzs4nubqf7kMI8yVz/sqte6eD/grquoeReeJP9Es5/khtLZvNnuJP+eaeXuaRv9mHd7la+pPhn8F/3PnaPp6afYTp++1a7/e+bu/u7tkl1/45b/79fTGj6DoPhLc+lQfadRkTyZtRuf3k7p/dVukcf/TOPCV+c4rO8bmk+SkrQ7nrTq0MH8erPLvBfwds9GsLT7ZH/wAI7YQf8ultt+1/9tJeUhZv4vL3Sf8ATXtXsGmx6Vods1noNkmn27fe2J/rD/fZurf7zVDJI8r73+ZqK9XL+GqdL356nzOPzipV9B8jPL89PqNakVa+qikvh0PDHULRtqamAUxaftooAWKpqgqTcaCx9G6mbjTd1AErVF5lR+ZSbquJBL5lRs1NZqYzVQEm6mNUW6jdQArNTWamM1RNJQWSs1ReZUDNUfmVYE+6qstR+ZVdpKDNk7NUTSVXaSq7TVZnKRJJNVCaaoppqy5rr/araMLmEqpakuKy5rqsrVNUhsYWubmdYIl+87fdWvnHxp8VvN82z0eX5f8AntX1mScN1MW1K1l1bPLr42cn7Okrv8j17xV4+03Q4WTzPPn/ALifN/31Xyl46+Il/q7sl5P+6/hRGxXn+ueKnudyQyeZ/t1wkkk0/wA7/NX2lWvg8qh+71mup6eVcPO6q4h3fYtXWoTXL1Aseyl8tF27KfX5rm3EFXGTvNn2Oi0hohGao6dTa+buCGUzdSSN5VVmuv8AZrOUuU3pwkz/1Pqiiiiv0s/Ogp60ypFagCaim0zzKBykS0VF5lRs1ArlndUfmUymbqom4+imUzdQUTUVHuNN3UckieeKH0rNUe6ovOpeyYvaxJWqKmM1N3VcaTF7VDmqNmprNUbLvrRUjP2kRlMajbTNr/3afsh+1G0jLUnlyU3y3olAz+sIhplS/Z6TyaPZE+3I6fTfLo8uSj2DJ+twXUdup241Ft/2qX5E/iX86v6tPsR9eh3J6ZVb7RZ/89x+YpPtln/z8p/32tH1Kp2Zn/aVLuWGoWoftFm//Lyn/fa0rXFmn/LdP++1rN4Op/Kxf2nS7lqn1m/brP8A5+U/77FL9u0//n6h/wC+1qY4Ko+j+4P7UpLqXdxpjSJ/eqn9u03/AJ+Yv++1prXmm/8APyn/AH2tP6hU7MP7Vp/zFrzqRpKp/arD/nun/fa0xrrTf+e6/wDfa1t9Tqdn9wv7Vo9y3upm6qv2zTP+fhPzFRfatP8A+e6/nVfUKnZkf2pR/mL9L8lZf27TU+T7Si/8DWkbVNNT/l9i/wC+1qJZfUfR/cH9pUu5qNTKyv7Y0r/n9h/76pG1TTX/AOXuL/vtaX9l1uzI/tSh/MaJ2UyqK6lpv/P3D/32tSfb9N/5+U/Naj+z6v8AKx/2xR/mLVFVvt9h/wA/KfmtJ/aWm/x3MP8A32tR/Z9X+Vh/a1L+Yu7qfu/2qzf7U0r/AJ/E/wC+hTv7S0r+C5T81q/7MrdhrN6T+0au7/ap241mLeaa/wDy0X/vpad9u07/AJ6/qKP7Nq9mdazWj3NKnVnreWD/APLX9VqRbiwf/luv5rU/2bW7FrNaPcuU2o/tFn/z3Sl+0Wf/AD3T81pf2dV7M1/tCl3H7qKjaa2/56L+dQtN/wACp/UJ/wArQv7Ro/zCUymnfQtKWCt0Kji4S6hSeWlKd9N+el9WRUcREd5cdG2iisPqcOxp7aIqrT9u/wDi/So6ctKWApPoQ8T5iNb991M+zR/89WqO6vraxhlubyVIII13O7lQFX/gVeG+Ivi5c6hNJpfgODz5f4r24X92n+6v8X/Aq3hlNJQdSpourZySxE5vkpq7PSvFXijw94Qs/tWsXbK0v3IE+aST/dWvBbrxh4q+Ic32Dw9bT2Vk3/PHmV/95v8A4mul8K/BfWPE15/bfi27eTz/APltM3/oKtX0npOj6J4Xs1ttEtFWVV2tM3U15+Izeh/CwEbvv0R61DJlC1TEy17Hi/g/4K6Vpnl3/iZvtcq/OsP+1/eavZla2s4fs1hAkEX91P8A2ai4meX79U9u2vJw/DNL2v1mtrNnVis3nKn7KGiXQJG302nbaK+h5uX3Txwp61G1Mb5VZ3baq/eZvuit6cHL3UtTOc1FOT2RPVeSaGJPOmkWOJfvOzYWvLvFnxY8PeHd0MLLcyr/AN818j+OvjF4h8Q3LWttOywf7PSvrMt4Znb2mKfKvxZ5cMVVxL5MOrru9j6h8ZfGbw94e3W2lN9puv73Za+T/FHxS8Q+IXlhSVlVv4q83ka5nffcybqjZq7ZZlTw3uYZW8zrwuQ04z9pP3n57Ij+z7233LebL/tU/dRupleBXxE6k3Oo7s9/X7Q1mpm6klqPdWBcYis1JupjVFQaxiWN1MaoqlrGbCxLUW2k3In+zXa+E/A+veJ386GNrSy/5+X4/wC+a8rMMwp4WDdR/Lqzpw+FlN+6c5a2ryusKRvJPL92FBl2/wDsa958F/Be/wBVkW48Sf6NB/z6Juy3+9/nbXqnhXwT4b8E2f2qbZFL/HcS/wCt/wDrf8C/KqWrfF62if8As3wrbeZL/HcP3/q1fO4fK8yzZ3m+Sn+LROIzXC4XSgueffsewaXofhXwrYb7j7PHFB/uiP8A+yqXRfGVn4h1K7s7BW8q2hV/O6B9zbflWvn+10PxD4luVutYneTd/n5Y/wCGvdPC/hV9GfztqqzLtbuzD/er6LD5fluXQ9nS1b69T56c8biZ+0qPQ7dak8yo1jd/krM1bXvDfh6Fptb1JIP9hfmdv+ArXs4PCVK7UacW7nm18VCHXU1/MrL1LWLDSLb7TqtylpF/tNz/AMBWvn7xh+0JDZpLbeG7Tyv+m022R/8AvnotfLXiD4ga34hmaS8ne5lb+LOa+8wXCqpQ9rjJKK/EmhhcRiPhVl3PqnxZ8eLO2RrbQY/L/wCm79f+ArXzP4m+JWq6vMz+e88sn8bNXm7RzT/PcyUvl7Pkp4rPsPhvcwS+b3PbwnD2HpS556smk33Mn2q5k8xm/wC+ab5myo6bXyOIxE6r5pu57vL9yJPMpajWPf8AP/d/i6Ktdr4b8B694m8qa2/0ayl+5d3KSCOT/ZgVV82Zv9wbfU14WYZph8Guao7HTQwc6r5YK5xbNtTe/wAq/wB5uleieF/hj4k8TPBN5H9m2Uvz+fcp87x/3o7f5Sy/7cm1Pevoz4f/AAP037Z/o1s+s6pbTbPOfb5cG3+9N89vb/7iebJX1xovw/0HTIf+J9s1SX/n22f6Gm37v7ttzTMv9+bPsFr85xvFWKxs/Z4VWXc9f2GHwqvVevY+X/h38DbD93eaVbf2zP8A9BS5/wCPZP8Adm6f8AtlZv8AppX1PoPw/wDDfh7yLnUtms38fzpvi22sT/8ATO3+bc3/AE0m3PXXTXjy/J91V+VVXgKv91f7tU92+jL+F/f9pindnlY7iCcvcpaI0Li8mufndvvVRanU2vtaOHVJcsNEfOVaspbu45af5dIq/wAdSVsTEKlplPqAH06in1YBUTU1mp1ADKKZRTjEB9FRbqN1VYB1N3UyjdVAKzVE0lJ5lQyNQA/zKRpKj3VXkaguOpK0lRM1QtNVfzKqMRS0J2kqBpKiZqi8zZWhEZDmkqu0lI0lZ8k1QKcyw022qEl1VK4uq5fVNcttOtpLm4kWKKP+KvYwWXzqtKK1Z42Kx8IXOhmuq868XePtK8OI2/8Afz/88Urw/wAbfGZ/3tnon7v/AKa/x1846t4ov752d5fvV+k5bwrSw6VfGuy7EYXL8Vi3fZfmekeMPiRqWtXPnTTt5H/PDp8teNX2qTXbt/dZvu1nSTTS01fkrkzni68PZYfRdkfb4DKqeGWi1Jo4v79WPkqFWor8vxWJnVl7zOtktMopJG2VwXEI1V2k2UNNVVm31z1cRGPqdMKRHJJJLTlt6sRx1aWOvGxWPn0PQpQ8j//V+qKKKZur9LPzwfRTKbUAWNtU7i+sLN1S8u7e2Zl3Ks0qxsV/vbWNVda1DWNM02S50HTY9Uv/ALsMM08cEa/L96Rm+9t/u/xV8xa58NdY8W6lPr3irwvBe6td4+0OmqKvT5flVfur/srWdPNMLGo4V5WR008vnVXNA+nm1jSk/wCYhbf9/wCOqsniTQYvv6laL/21jr5T/wCFK/8AUmQf+DeSoJPgrM3/ADK9jF/2/wAtdn9sZYvtti/sat/Mj6lbxf4VT/mM2X/f+P8Axqs3jbwkn/MbsP8AwIj/APiq+VZPgfcv/wAyzpv/AIGzf/FVWb4Gzf8AQs6d/wCBs1XHOsq7s3jw9Ve80fVMnxG8DRfe1+w/7/rVST4qfD1Pv+IrP/v6tfKTfAn+54bsP/A2aqM37P8Ac/8AQJtIv+3qWtv7dyf7Umb/AOq9V/8ALxH1VN8avhpB/wAx+2/PdWZN8fPhjF/zGUk/3RXy3J+zzfy/8w+Bf9y6aqX/AAzbqr/8s/K/7a5rf/WHJPtcxr/qlV+1WSPqGb9oj4bxfcvml/3VX/2as9v2jvAH/PV2/wC+f/iq+bP+GatS9Zv++xTf+Ga7/wD6bf8AfdP/AFqyKP2ZEf6mz/5/I+jG/aS8Df8ALFXb/ga1mXX7TXhVP9Tbf+PrXz3J+zjqX/Teqf8Awzrqv96f/vinDi7JP5GL/U1/arnttx+1JpX/AC7WMP8AwJmNYs37Ujf8sYLb/vhj/wCzV5HJ+z3rEX/PX/viqUnwB15P7v8AwPiuyHG+S/8APp/Mf+pNP/n7f5nq7ftSal/07f8Afus+T9qDxD/z3h/79LXlzfAnXv8Anvb/APf2q0nwL8Sf89IP++66Icf5H/z6Qf6lUv8An5f5nq3/AA094n/5+0/78JUX/DTXid/+Yht/7ZrXlX/Cj/En/PSH/vql/wCFK+J0/wCeP/fVD4/yXpSRyz4SpL7R6PN+0p4tf/mJP/36j/8Aiay5v2ivGEv/ADFJ/wAlWuI/4VH4ki/5403/AIVj4ki/ufpVf69Zf9ikjnfDWHhudNJ8dvEM/wDrr65b/gdVv+Fyaq//AC83P/fxq5Wb4e68n39lY194P1Wxha5mi+WL7zV3UeMqU9IRSv5HLV4awe9jvJPi9rX96aX/AHnaqzfFLVf8u1ebx2+yl8mvS/1hn2SOT+w8F/Ieh/8ACztY/wAmo2+Jmsf3f1rhPLo21f8ArHV8g/sfCfyI7f8A4WVrH/PL/wAeo/4WRrH+TXD+XSqtTLiOp5Ff2RhP5Ed2vxG1il/4WNqqffirhttL5dYf6w1PJEf2RhP5Ed3/AMLIv/8AnnS/8LG1L/nlXBeXRtpf6w1O5P8AZOE/kO7/AOFial/d/Wk/4WJqv+TXEbadT/1iq+vyF/Y+E/kR2zfELUv9r/vqq7fELUv8s1cjTfLp/wCsVUccrwi+ydS3xE1j/O6mN8QtV/u1zPl03y6X+sVXubf2dhf5EdT/AMLE1j/nlSf8LC1j+7XL+XSeXS/1iqdyf7Nwv8iOvj+IGsf7tT/8J5rH/PSuK8uneXHRLiGp3B5ZhP5Edp/wnmsf5NL/AMLBvv7v61xm2jbWf+s1byM/7Kwv8iO3/wCFhX//ADz/AFpf+Fial/d/WuG8umeXVx4jq+Qv7Iwn8p33/CxtS/55/rR/wsjUv7rfnXC7aKP9Yq3kL+x8J/Idw3xI1L/a/wC+6F+JGpf7X/fVcRtWl2x1p/rRV7If9kYT+Q7xfiRqX+1/31Un/CyNS/2vzrz/AOSm0f6yVeyJ/sbDfyHoy/ErUl/idfxqaP4parF/y3n/AO+2rzGmeXWseKJ/big/sbCfynsMPxg1WD/l7uV/4G1akPxs1VP+YlN/wItXhf3qia3V6y/1hpfbppi/sHCdmvmfQ0fx41L/AKCj1r2vx0v/APoIbv8Ae218tSWcNJ9lRK2/tzCf8+19wS4cwr2bR9j2fx4vP45LZvw/+JrpLf44Wb7ftMCN/uNXwk0ez591IzXkCb0k+99z/a/4DWU8flvLz1UkiYcLuT/dTaZ+hMfxo8PP99WX/e21FqXxq02LbbaPYvql/J9y3i/9Cfb/AA18heC/hX4z8Z3MT3iywWsv8HzeZJ/wGvvLwT8G9K8NWEH9pfu2/wCfe36n/rpJ/n618JmnF+Wc/s8vpOcur6I9xcHzoWniatl27nk1j4V8bfE2/wDtXiGX/R/+faLi2i/3m/iavobw34B8PeFUV/LS5ul/urhEP+ytderJbW32O0iW2t1+6iDFVtxr5WtQxWN9/FS06JbI6/b0qHu4ePz7ks1w8tU6laoZa9WjRVNcsFZHm1arn70mVZF+em06omrflucspDGprNWBr3ijRPDUPnaxcqv92Hdl2/4DXyf48+OV5fTS2Gm/uLX+BE++f95q+iy3IZ1bSqaLuzy6+PqTfJh1d/kfSXiL4leGPDSN50v2m6X+FTx/31Xyh44+NGt69M0NnL5cH91OBXjV9ql/qc2+8lZqza9v67hcJeOHV33Z0YfKXL38RK77dC1eXVzqE3nXEjM1Utpp7NTa8TEY+pWnebPchGySSskM3UUUVxSkWFRNRTKRUYjKbTqiag2iI1RrRRT+yzUdRRTa4wPYvBfhnw9/ZVtr2pL/AGhdM8m2F/8AVx+W235lX71dXq3xKs9DTybaPdP/ALHy7P8Avn7v/Aa8Kt/EWq2Omrommx/NO77doy75/uV658Ofgz4h8S3kc2sRP83/ACx/5af8C/u1zYrEZVlsfrFd803+Yv7LxWKbjUdoLZdzFs5PGHj2/i375Lf/AJ4/N8n/AAGvqPwL8H/7PtludS/0b+/u27/++v4a9R0HwroPgyzihhgh8/8A2WXG7/ab/wCJqn4g8baJo8LXmq333fuKv/sq1hgsRmWd/wAOLhD8zgx+aYDAWp07Sn2Rv2tvpOmJ5OlW3+87d/8AGuc1rxhomhpv1K5Xcv8AB/8AErXzR4w/aA+0+fZ6Iv2aL/nt/G3/AMTXzzqni7Vdadv3rSN/edq/SMv4PwWAhz4t6/ieJOlmGPfv+6mfTHjD46TfNb6P/okH9/8Ajb/4mvm7WPF2pavMz7nl3fxNXKMs0r77mRpP95qezV2VeJfYLkwaSXfqz1sFkVDD2la77sa2+f57mX/gNR01mqPca+axGMrV5udV3Z7kYk1Npq7532J/D95v7tdh4f8AA+veIf31nbeVZf8AP5cfLB/2z/jlP+5Xg5lm+HwkOarJeh14fCVKsrRV2cksby/c+6v3mbgL/wACrp9B8F+IfEbxfYLb9w3/AC8Tfu4/+Afxy/8AAK+lvBPwR/0zybOx/tnUYPv3E6L/AKP/ANst3lQ/9ttz+lfVmg/CfR9L/wBI165+1z/8+8Dsqf8AbSb5ZG/4BtWvzrH8Y4rFXhgo2Xc92OAoUFevLXsfJvgn4D+bdRp5f9t3sf3/AN2vkwf9s/8AVx/9tju9q+svD/wr0fSP32tt9rl2f6iF2Cf7kk3+sk/3V2p/vV6THNDbWy2emwJaWsX3YYVVUH/AVqtJveuTAcNTqz9pim2/wPLx+ffZpaIsLJDBbRWdnEltawLtSGFFjRF/uqq/dplRU+vtsPgaNBKMEfKTqucuZvUdT6ZTtprsIJKWP79M+9U9AD1p1NoqCyWnLTaKCB+6mbqfUO6rAfUTUM1MoAKKjZqTzK1AlplN3UzdQBIzbKg3U5vnqNqCQZqjZqhkao91BRJ5lV2kqNpKhkkqy46DmkqHzKgkkqo0lOMTOrIsNJUMk1VWm21nzXVaQhJy2OV1bF6S62ViXF9XPa14ksNKh865nVVr578ZfFJ50lhs5Ps1v+Rb/gVfaZLwpUxHvzVl3Z4OIzKpOfs8OrnqPiz4iaVoKMnmrPP/AHP7v+9XyN4y+IF/rNzL50n+C1yeueKHuXbyfm/2q5D55/nevrquaYLK4OFFXl3Poco4e5f3uI1ZNNdPO9Val2momWvgczz2ripvne59fCy92JEzU/dTttFfNSmaXG7qkWm1GzbKwkLcn3bartJvqJd8tWo7evGxuNUZbm0KBCse+rUdvViGHZVzaa+er4q8jr9mU1WnbaueXS+XWXtSz//W+o91JuNYM2vaPb/67ULZf951rHm8eeFYH/eavbf99Z/9Br9hhldaW0Wfk/8AalJfEztN1J5n+zXnknxO8Ewff1RG/wB1WasS4+NHgmD/AJbzSf8AAK6KeSYiW0H9xm83pfZZ6vItVPJf/lnK1eL3Hx+8Kp8iK/8AwLaKxbj9oTQU+5B/31Itbrg2pLV0tWR/a3a5761nN/epF0/+/JXzPeftIWEX3LaD/vtjXOXX7TH9yOD/AMeraHAlSX2EEcxqv4Itn199iT+9R/Z6f3q+KLj9py8/g8lf+AViTftGaxP/AMvP6VpHw/XxTSRf1vF/Zgz7waxtv71R/YYf88V+fU3x617+C5m/OsK6+PHiR/uTz/8AfbUf6i4fq0ONfMJ7RaP0j+z2EX37lF/3qja+0GD/AF19B/31X5e3Hxg8SXPz+Y//AH01Y8nxM8Qy/wB+tI8GYCPxTRr7HM5dEj9UpvE3huD/AJiEFUpPHXhWL798n86/K6Tx54hl/wCWjrVSTxZ4hn/5bv8AnWn+quVL4ncX9n5k95JH6nzfFDwlB9ydW/Csq4+MnhWD/K1+X39veIZf+W8y/wDAqa19rDv+8nen/YeTw6E/2PjZb1T9J7j48eG4v+WG7/e21hTfH7w383/EvSX/AHttfndJJfS/fkf86h8u8/57PS/s/Kf5RwyKv9qqz79m/aK0RP8AmF235LWBeftEWD/c0+0/79V8RrC+P4vzpn2d/wDarn+q5Z9mCOn+w5/aqs+srz48Qy/8ukP/AH7WufuPjMkv/Lsv5LXzgsKJ/ep//fVQ44T7EV9xP9h0/wCZv5nt918Vd/8Ay7Vmt8SPN/5dv1ryZWT+7T9//TOsvb0fh5V9w/7Fo9n956RJ48m/5ZwfrXOal4k1LU08maRvI/ufw1zasn+7Vjcn96uaviKXZXN6WChS+BCbqKPk/v0ff+5XL9cOj2T7Efz0u2nqr0n7z+5TljILqi/YT/lG0+jy3anfZ5qz/tCl9pr7zT6rU/lY2nLUi2s392p47O5f/lkzVi80o90T9TqfysqU+tSPSb/7/wBmdv8AgLVP/YupSv8A8eU35NXNUznDr7SNoZbVl8KMemV0H/COar/z4zf98ml/4RXWm+5ZP+TVj/rHhY/FNG8MhxL+GJze2n7q6tfAvieX/l2b/vhquR/DnxO334P/AB1qipxVgv57mv8Aq7iexxdQs1eiL8MfEn+7+FL/AMKz1hPvyf8AjlcL4uwf8w/7AxHY863UbjXpUfwt1V/+Wr/9+qvR/B/VZf8Ant/37pf63YR6c1/QcsiqrdpHkfmU7dXqd98LbbSrOe/1LWfs3kLu2tExLN/Cv/Aq8p+5X0OExUasOZJ2fc8mrSUZOMXf0Jabuo3Uba3lKxgO3UbqbRT9oA6m0U7b8lHtQG06iopJPK++y/8AoNL6wOMHL4R9FRxrNPGzwxNJFEu53VW2Iv8AeZulNqqOIhVvyO9jadJx+JWuTU6q+6jzK0kY2H0yim05zii4xGUrL/wH/aaptNt7/WZvs+j2zTtu2+c3+rX/AOKr6e+G/wCzvquqzLf6xH5+3+O4/d20X9K+TznjKhhv3dDWfZH0WAyWc/fqaLzPnrQfCOt+IZo/scG2L+/KPkP+6v8AFX2B8O/2d/I+za3rC+X/AHLm5X73/XGP/P1r6S8O+D/DHhBF+x2yahfr/wAvEqfuk/64x/8AxVb1xdPO7TTMzM38TNXy/wBSx+be/jXyw6JdTqxGPw+E9zDq77lTT9N0rQ4fJ0qDyv4Wb+N//ias7pHqPdUfmbK+wwmXUqEFCnGyR8piMXOrPnqPUJajoaTfTa7LHJcTcagkqrfahZ6ZC1zqU6W0S/xO2K+evGnx0sLHz4dE+bbn983/ALKte7luQ18RrFWXd7HmYrMlB8lNXfZHuusapYaHatc6lOsC/wC11r5t8dfHxLNJYfD37v8A2+sr/wDxNfN/ij4ga94lmZ3nb5v4q4aP7/nTfvZf9qvpIUsFgv7819yLoZfWq+9iHZdkdfq3izVdem+03kjfN/ebLfNXMyRpv31F/epa8bHZlVxE/eei6LoepSw8KWkFZBUVFFeXI3GUU9qZtrP2pYbqiqWmbaOcobTKe1MqvaFkTVDU7LTdpo9pE0jIgoqXbRto9pE0GV0Hh/w7qXiG88nR4PM/6bP/AKuP/wCKauv8H/DO51yzXWNY3wWX+v8As0H/AB8Twr/H6Rr8v+83avZbfVPCXhCz87Utn3P3Gk2zbv8AwKb/ANk/9Cr5nGfW8ZV+rYJX6N9jqjiKWHjzVNX0Rt/C34Owxf8AE4um8uD/AJb6i+3f/uq3T/gMe6vVvEXxK8PeFbP+ytE2W0H8ez78v+93b/gXy18q+LvjNrHiFPJ8/wCyWq/KsMPFeLX2oX94/wDrH+b3r6fIPD3L8BP6xmE+efRPofO4+rjsw/dyfJDstz6F8VfGi5/epYfuP1P/ANjXz1q3iTVdembzpZJd3941meSj/PMzSN/tU/dGlfX4jijl9zCqxWWZHhcJ/DV33YxbXZt85vMb+GnyNUbSU37/APFtr5irXnVneo7ns6/aEZqZ9+nsv/TRV/3q7PQ/APiHXPL8u0+zW8n/AC8XKsu7/rnD/rW/8drx8wzrD4Nc1VpeXU78LgKlV+4ji/Jd/wCH5V+838IrpfDngfXvET40608+Bv8Al5m/dW3/AH8/i/4Bur6Y8GfA22uJN/2Z9dn/AOmyL5cT/wC7/wAe8X/A97e1fUOg/DGwsUX+3rvz/wDp2tHZU/4HM3zt/upsWvzzG8Z4nFXp4KO/U9eODpYb3qsrvsfKfgv4IQ/a4xNbf23qMf8ABs/cRf8AbJuP+BTn8K+sdB+GNhaIs3iGfz/+na2dl/76m+V2/wB2PategW/2axtls9NtktoF/gRFVf8Ax2mszvWeC4XniJ+1xjbf4Hn4viD7FJWJYWhs7OOwsIEtLWL7kMKLGif7qrSbnlpv36mWvuaWCpwSUFofNTxE5ttu4bdtDU6n7a3MCLbTqfto20BYKfSqtP8Au0Fi0UUyoAfup9Q0/dQQP3UzzKZupPkqwJfMpN1QM1N8ygCaiofMpu7dVgO3Gm0bqbU3AdRUTNTN1UA/zNlQNIlNaSq7NVASM1VWkqOSSqcklXYrYkaSq7SVWaSqklxtrSMCJTsW5pqz5LpKpXF1vridc8XaVoab7yX5v7v8TV6uCyuriHyQjqeRisfCPXU664vki+d5Nqr96vFPF3xUsNOhn+xsrN91X/8Aia8h8cfFKa+eXyW8qL+BM1896prFzqL/ADtX6Xgciw+AgqmK1fbsThMsr42XNU0j+LPQPEHxEvNXdnmZ2/u15ndahc3z/vmqg2+l215Gc8Vzqrkp6Lsj7bBZZQw0fcVh0f36m21FGtS1+f18RzPc65hTac1Rbq5riiMptDNVeSSspOK+I2jAc01Ise+khheV62Y4a8HMs0t7kDqhAghhRavbaWOPbU+2vlqtS+p0/wCEjVakVaVVqVVrGUi4xG7TRtNTbTTtpqbjP//X/P8Abxlrz/8AL3JULeKtef8A5eXr7RX9l+2/5/U/74apV/Zds/49QVf+ANX6l/xFrE/8+mcn9g4D+ZHxC2vaxP8AfnmqL7Zqsv8Ay3m/76avu5f2XdET/Xag/wDwFKuQ/sz+G0+/fXP/AHwtZy8VsXLakx/2Rgo/bR8Bbb9/+ezUv2e5f+/X6IQ/s3+D0/5e7lv+ArVxf2efBv8Az0uf/Ha5aviVmEvggyvqWCX2z851sbl/4ZKnXT5vueW9fpFD8AfA6ff+0f8Ajta8PwT8Bxf8uztXDPj3M5fYZj7DBr7dz8x10W5/55tVqPRZov4Wr9RI/hL4Di/5h9SL8L/A3/QLT/gS1zT4zzeX/Lsh/Ues7n5e/wBlXP8Acao10m8/2vyr9Tl+HPgxf+YXb/8Afur0fgfwlF/zC7b/AL9LXN/rLnEvsE+0wC+0flYuj3j/AMLf981Ouh6r/wA8v/Ha/VyPwv4Yi+5pNt/36Wri6ToMX3NItv8Av0tY/wBsZz/IifrGA7n5OL4d1t/uWzN+FW4/CfiZ/uWM3/fFfrEtvpSfc022/wC/S1OrWafcsYV/4BR9fzr+VB9ZwPmflHH4D8Zz/c025b/djatSH4T+PJ/uaNet/wBsmr9S1kh/59k/74o3r/z7J/3zS+u512RH1rB+Z+ZcPwN+Is/3NCvP+/dakf7PvxOf/mAXf/jtfpB5n+x/OneY/o3/AH0a5f8AhZ/mH9fwcfs3Pzqj/Zx+Jbf8wS5/8drRj/Zp+Jbff01ov96SOv0F+0XP95vzNJ9ouP71T7DNZf8ALwI5rhP+fZ8Ex/sw+P2+/Gkf/bRa0If2WfGH/LaeFf1r7k864/v0vnXP9+tI5dj/ALVUP7ZpfZpnxdD+y3ryff1KBP8AtmxrQj/Zb1L+PWbf/v01fYLSTP8AxNRuk/2qP7IxX2qrI/tyH/PtHyQv7Lf/AD21tP8AgNu1W4f2WdN/5bayv/frFfVf7z+81N+f+/V/2BX/AOfrF/bv8sEfMq/sw6J/HqSt+H/2NX4f2bfD8H/L3C3/AAGvony99M8v/arL/VefWq7GcuIJ9Ir7jwqP9n/wrB9+SFvwarsfwR8Kxf8APH/v3n+deyeXS+TV/wCqVP7cmzKXEFf7NkeRr8H/AAwn8Sf8BiWp/wDhVPhhP+Wv/kNa9V2mo2X/AGVrX/VCh5k/6xYjueZL8MfDaf8ALd/+/S1bj+Hvh6L/AJbzN/wBa9BZf9laZt/2VrX/AFQw3ZnPPiDEdzko/Bugxf32/wCArU6+G/Dyf8uO7/e210kn+6tRfJ/cq/8AVLB/ymE86xEt3YxV0nR4vuWif98rUv2OwX7lon/fC1qbTSeXW0eFMJ2sYf2zVX22ZTWth/z7Iv4VV+x2f/Psn5VrXFxZ2ab7yVYv9415H4s+NHhXw9uhtp/tc/8A46te5guAIV5e5H59DjnxRU1hdt9kehf2bZ/f+zJ/3xmqt1qnhjSE33TWy/7Py18b+Jvj5rd95kNjvjX/AGOK8c1LxV4k1j/j5uWjib3r6ijwLllD/eGm+yMPrGZYjryp99z7j8QfG7QdKTZYQWn/AAFd1eKa58eNWvv3MMrfyH/jtfNax/e3szbv7x3VIq138mX4dWw1JerRh/Y3N/HqOT9Tq9c8Tarrn/H5J+6rm6fu3/JSqtePXr88vePQpUoUockFZCbaKkZdnzv8q/3m+Uf+PVcs9PvL7/jwtprn/aVNqf8Afxtory8Rj6VL3qjR20MHUq/DEz6F3/3a7nT/AIf+Ibv/AF0SWn/kV/8A2VK9a0H4D3N3Cs14s1zE3/Pb92n/AHy2yvncVxXh4e7TTk/LY9qlw9U+Oo0kfNism/yd26X+4vzN/wB8rXSWPhXxDqf/AB7aa8a/37k+Uv8A3z8z19n6L8G9N09P+WNl/swxqzf99fIK7+18F+H7H78bXbf3pX/9lXaK8mefY6v/AAoWOj6lgKWsnex8S6f8J7yd1/tK73bv+WNnH/7M2416tofwXtoni8nRv3rf8trz5j/49ub9K+o4/Jto/JsIFgX/AGAq/wDoNeJ/Fr4uWfgC2/s3Tdtz4gu0+Tv9nU/dkb/2Va7Mt4ZxuO9/EzduyPNxnENONqGChq+vY8l+N19pXg7w9bfD3Tbn7bq+pTR3OqbP9TbwQ/8AHvbov95n+dvwr5mVqS8uLzULme/1Cdp57l2d3fksT95mak3V9zhMvpYWHs6RzVZzq253d9WS7qPMjql9stk++3zf3erV6N4N+FPirxtfx+TbTW1rL/s5mf8A+JrzM3z/AAuAT9q7Pou5thcrq1X7q07nDW7Pd3P2Ozja5um+7En/ALM38Ir3n4f/AAJ8Q+L5v9Pj3RR/fT/V20X+838VfVngP4A+G/B1tFNry+X/ANOdu3+kyf8AXaX/AJZivZJJoYIY7CxgS0soP9TbQjaif/FN/tV8FPFY3OJ9YQ/Fnvf7LgoX3mcB4V+GPhXwhCvkxpezx/xbdsf/AAFe/wD47XfzXjvtT+GP7i9ET/dVeFqlu30tfR5bkWHw3wx17vc+axmZV6/xPTsS+Y7UM2+olpWavcR409B1M3Um13+4tcP4o+IXhvwxC0c063N1/dRuFP8AtNXrYPLqldqMFds8/FZhTpW5nr2O0mmhtoWmvJEgiX+JmxXkHi74yaJoELJo/wDps/8AfZsRr/8AFV81eOPjJf65ctDDO0/+xD8qJXi91eX+oTM9/P8AL/dX7v8A9lX1EctwmAV675p9lsckKGJxOs/cj+LO98afEjW/FVy3nTtP/wCOolebNvn+eZt3/oNS7qbury8fnuIqrk2XRI9jD4WFJclNf5kEtQNUzVC3yV5fOdaCikZtn8Vbmn+FfEmqbXtrJvK/vv8Au1/8erhxWaUKC5qkkjsoYWpPZXMTbRtrttU8D3mi6bJf3+oWysv3Yo/mc1xNYYTHwxMOem7oyqwlF8st0NainUVtIgbtplP3Uygsiop1Nqig20zbT91G6rK94h203bUu6o5auJSOgj8Xarp2lLp9nO8f97a7Vzf2i5nfe8u6mUK1fR0M09hT5KCSvu+5vGEFfTVjvLSl3UxafXj15uUm5sOX5iMv8dR/J/e+arsNrNczLZwxvLdS/wCrt4kaSVv+ArXp+h/CnWLn/Stek/si3/2PLkn/AOBN/qov/Hmr5rMeJMLhL8717I9XCZbUq9LLueSeT93+Hd93+83+6vVq9F0H4X+JNaff9m/s+D/p5T95/wB+e3/bQrX1X4J+C/2MfaNK01LL/qKaj5nmSf8AXNf9bJ+UaV7xpfg3w9o+2aZf7UvVx89xt8tMf3bdf3a/7zbn96+KxXEeNxvuYdcqfU9X2GEwvv1Xd9j5z8C/A+ztvLv7a2+0z/8AP7c/+02Zcf8AflW+tfQWl+CdE0xP9J/02dvv9of+BL1k/wCBlvpXYtNNL89M21rgOEo/xMVJyfmeLi+Iak/dp6InjuNiLCirHFF8qKq7Qv8Auqv3acrUyOOpvu19bQwlKl8CPElNy95u7FqRfnpFWrCrXSjnsC05VoVam20wGKtPp3l0+gsZtNPoplQA+mUUUEBRTWbZULNvqrAWN1RM1RUzdTAloqJqKADdUtV91FAD6N1M3VGzUATM1N3VD5myo2arAmZqrM1R7v8Aaqs0laRiJljzKqSSVA01V5JqqxEX7xM01UJJqrzXFZFxdbErelSlL4SK2IUE5Nly4vKx7q+hiRnmbbtrzrxJ4603Rfvy+Y391a+cfF3xSvLl2h81lib+BTX32VcKTqwVSq7LzPB+uV8TPkw6+Z7L42+K1hpkLQ6b+8k/vtwq18qeIvGl/qszTPOzbq5PUtamvn31lbd1fR4jOcFllP2eGV33PqctyGNK06urZPI009R+TS7pNlC76/MsyzuriZuUmfRbeQN89LRRXhSncAoptQtJWdw5bkzNVFpKGmqPy656uL5DopUh1Tw2u+r8drVyOPZXzuIzSUr2O2FIjjh2JU6rT6dtrxZTcviNPeG1JtNLtqXbWUpFxiNVasbaYq1LWMp2LjENpo8up1Wl2/36zlI3jGMfiP/Q+m/Jpv2dKtUV+i/V12Pz+5X+zpR9nSrFFL2MOwXK/wBno8mrFFP2UewrlfyaPJSrFFVyLsSQeWlJ5af3KsUzbRYXyK3l07y6n20UxkHl0eXU9MoiA3atR+XUlO2mnYCLy6ZtqxTWWkBDtNFO2mm0FhRT6ZtqfZxFHQbRtqTaaWlYvnGbaKfRtoJ9oQbXpKsVE1Ae0GUyn0VcYmcpXGU2paip2JlIazJUdDK9L5b1r7MxlNLqQtRT5tkCNNNL5ar/ABN8orz3XviZ4V0NG33aTyr/AAo1ehhMsr19IJs82vmtGHu7s7pl3pVSa8sLNN95OkCr/eNfK3iT9oib5odK2wf7i5P/AH1XgmsfETxDqs3nJct/OvoaXD1Ol/vMrPstzn9vi6/8KNl3Z9x618WPB+i7v3/nsv4V4P4o/aQuf9Tokar/AJ/vV8uXVxeag++8naSofs8KV3QrYLDfw4XfdnTSyq9vrE7+S2Ot1zx54n17/j5vZvm964hrd5333Mn3a0Fhmf7kW6o5Gh3eS8i+b/cT96//AHytcWN4hnblm7LyPbweH5NKUbL0IVXY/wB5dv8As1JIqb66TSfBfirWdv8AZWjXH+/d/ul/75X567XTfg/eXNysOq62nm/8+2lxtNN/475n9K+Ix/FeAoN887vyPZpZRXqe9bQ8k27fv/L+lSWtvNfPs022mvW/6d0aTb/vN0Wvsjw3+znYJ/pP9hTT/wDTxrU6x/8AkP8AeP8A+Q1r2Wx+Fej6dt+2XO3/AKY2ESxhf+2kvmP/AOg181X4zq1/90pNruzs/silT/izt5HwJp/w98YX377+z1tIv7877v0j3V6PofwRubz57+7uLn/YsEX/ANCXzD/6DX3Hb+G/Ddp88Ol28kv/AD2nHnyf99y7q2P9j7q/3V4H/fK8VwT/ALXxX8SXIvIf1rBUPgjd+Z8z6D8C7OxdZodNS0/6bXjeZJ/7Vf8A9Br0yx+GOjwf8f0jXLf7A8of99Nuf/0GvTabV0eF4fHVbb8zCrn1X4Y2S8jJsdJ03Sk2abaJbf7W3L/9/G3PU0lWqikWvosPllOnpBHi4jFzn7zepU21Dt3fJVrbu+SvFvjF8XNN+G9h/Zthsu/EN2n7mH7ywIf+W0n/ALKv8Ve5l+W+1qqEEcE5TnaEN2V/i58VtN+HmmtYWDLc69cr+5h+8sH/AE0k/wDZVr8+Zrq81e/n1jWJ2ubq5cu7vyzMajutSv8AXLy51jWLl7med98zue5pum2Opa/efY9EtGuf9v8AgSvXzTN8PgKbpt27nuZZlE4+5FXb3Y6ab/aVf+BVt6D4T8SeJ3/4lsHl2v8AFcv0/wCA+tfSPwx/ZxfUHg1XXv8ASf8Aps/+oT/dX/lpX2VofhXw34YSL7BaJJLH/wAtmVf/AB1ei1+UYvibF4uXs8DGyfVn0UcFQwq58Q9ex8x/DP8AZvs9P8rVdb/df7cy/vn/AN1f4a+rdLjsPD1t9j0GBbRdu1pV/wBY/wDvNT7i6ef+KqVdGWcNJT9rifen3Z42ZZ5Or7kNF2Rea4d/nqOodxp+419fyWSjFbHz/tR9Ppi/PVHXNY0Tw1bfbNevUtF+8qf8tH/3VrWjh6s5qEFdmNbFQpK7djRX5/uVheJPE2g+E7P7Trdz5e77kK/NI/8AwGvnXxp+0VsSS28KwLaf9N3+aX/Ba+WNY8Rax4huZbi8uX+b+Jzlmr6zC5HSoe/jHZdlq2cHtKlfZWXdnvXjz4/X955thon+iQN/323+81fOOpalrGuP515Pt/4FzTY4YYv97+93prVpXz7/AJd4dcq8t2dGFwlOl76V33ZDDbw2af6N/F96nUM1RSN5X3/l3fd9T/ur/FXh1Z7zk/mzvjTnOXdjqGrrNJ8F+JNY+e2tPs0H/Pa73R/98x/fb/x2vVPDPwXh1D/XfadZl/7923/jvH/fUlfF5lxfhaTcIPma6I97C5DVl79TReZ8/wBvbzX032azglvZf7lunmH/AIF/drutJ+G+sXO37f8A6F/sJ++m/wC+v9WtfYmh/Cu2sYfJuZ4NNi/542iLI/8A7Ki/rWnq2qeD/Alt/o0CNdL/ABzt5sn+96LXnYWGb5s+WjHkXc58wzfLMtWr55dEu5414b+Dttbf6Z9i8vb9+7u2+X/x773/AAEVneLvE3hXw5/oemyPqF1/HNnyo/8AgP8AF+tcx8QPjFquq7rZJPKt/wCGGPivnqa6vNTmaa5kr7HAcBYTBfvsY+ea77HjQzLHZh78/ch2W7Oh1rxBeaq7fdji3fdWsLdUSxoiU6vTxEoS+BWS2OmEFBWitA3U/dTKK4eQoKNtPp1RYCLbUbLU9Mq4xCJFRtp1NplDKZT6VlfZv+7/ALTfKv8A31Tm7buxtGMmQ/8AAaFheV9iV1mj+Ede1fb9mtv3Uv8Ay2uP3Mb5/u7vnk/4AGr2nwr8F5tQf54LjUp/+eX+rhT/AGWj6/8Af6RfpXyuP4wwuHk4Qd32R7WFyipL3p6I8A0fQ9V1mb7NYWj3cq/88Rwn+9J9xfzr2Lw78Jf9XNrc+7/p2tP3f/fVy3/tMV9X6D8JbCzhi/tWeOOKL7ltbIrY/wDaS/k1eoWOm6PpT77C0RZf+ezbpJv+/jf+y4r5TEY/M8y+D3Is9L2uEwnvXuzwvwn8JXs4dlnYwaFZN999jNJJ/wBsd29v+2zfhXs2l+HdB0F/Otrb7Te/8/Nztkk/4D/BH/2zC1syb3o8uOvVy7hejT9+pq+7PGxmfVqvuw0XkLJcTTv+8bdQq1MsdTLHX09LDwj8KseBOo31I41p/l1J5dS7a6JGZEq1Ltp6rUtQa0xFWpKKkjWrDmuCx1ItPoqAGU+iigBm2hqKjZqqMSBajZtlIzVXZqqwCs1Jupm6m7qokdupu6mbqYzVAD91G6ovMqLzJKsCdmpPMqDzKazVNiiwzVGzb6qtJUTSVRJZ8yommqnJNVOS4qoxNS5JcVWkmrNkuKozX2yuinCTOerVil7xqSXSVm3F8qVkTX3yM9eaeKPiFo/h6Fv3i3N7/wA8E/8AZmr6LLchqYmajBXPGr5h9iGrZ6JqGuWdjD9puZPLiWvnfxp8UpnW5Szl8iD9TXjfir4malrjs8zeX/0xX7teTXmpXN199q/RMNlWCymHPVd59ux2YPIsRiGpYh2XY6bWvFVzdtL833vxri5JnnkqH71SqtfIZ3xTVxDaWi6JH22HwlKhDlirAsf9+rlV6lr4WvXlPWTKnqFFFFYEBRTGaq0lx/crOUuUuMJMe0iJVf71Cx+bWhDa142PzKMfh3O6lQKa29asMKLUix1YVa+cr4qc+p2QhEFWpNtOWpNtctyxm2n7adT6LgM21NtoWpaylIaEVam8uhauW9vNO6oi/erhr17e89jvw+FcyKOF5X2Qru3V2kPgdLq2j33Lxz/nW74f8P8Al/P5e6Vq918P+F/s3+lXMf71l2/7tfIY3PKk58tHRI96GEp0ofvNz//R+qdq03y0qJm307zK/Sz8/H+WlL5cdM+0UfaKAJdsdG2Oq7NvoVtlAE+1aiajzN9JQQOptFFTYAopm6iqAKKKKBXGUUUVQwoo3U2pkA6k8tKWiokA1lplWKr0Fj6ZRSNQBJQ1Mp9BAUyhafQBWam1Iy1HuqyRNu+neW+zf91V/ibgD/gVcL8RPGSeB/DcusPs++sK793Vv4tq/wB2vhDxF8bte8R3jWcNzc3cXPfy0/75r6PKch+sw9pOSS8+pyV51m3GlG7W76I+8dc+Ing/w9u+2alDJIv8Fu3mf+g14n4m/aQhtt0OiWO3+6znd/47Xx5capqty+y5k8v/AGaoSND9/wC81exVjgcI+SEeZ93scX1CpP3qktOyPR/FXxa8YeJf+Pmd1i/hX7oX/gNeYzR3N2/nXl27f7NHmO9RS1jUzitL3E7Lsj08Ph6dL4Fa/UP9Gj+4u5qPtXyfwr/vcUyOa2lm2TSMsX+wOa+5PA/7NNneaVZa9/ZcEsF3Ck8Nxc3X2jfuX/nnGPlr47iHiD6lBcyu3sj2cFgIVW+d2Xc+J7O3uNQfZYRPdt/0wTd/49Xd2Pw18W3m15oIdLt2/wCW1y24/wDfP3P1r9BLH4Z+HtO/czT/AHf4LYLCP/i/1rqLXQfD1i6vZ6ajS/8APaYea/8A31Jur4CefZnivgXKj1f9gw/95nxB4f8AgHNfbftMt3rv/XP91b/99fu0/Vq938O/Am203b/yDtCi/wCmUf2qb/vptkf6NXvsjTS/f21F/t1MOHqlf361Ru+5z1eIX/y6ikcpa/DvwTbf8f8AFd63/wBfkreT/wB+Y9sf6V1tv5Onw/ZtNtILKBfupDGoH/jtN3Gl3V72F4ewlLpd+ep5tXOcRV+OQSNNL99qi21L9+mV7UMPCOkVZHDKb+07hto20Ubquxncay1DtqxuNRSVQ2V6Ro6krmfiF4k/4QzwPrfipI1ll0+2Lwo/3WkZtq7vxat6UeeaQRhzHnvxe+K1h8NNK2W2y51y7X/RoP7n/TST/dr82Ly61jxNqs+pXPnalf3Ls83+9/tN/DUl94iufGPiT+0vEl3Ncz3s3z9y/wDdVf8A0Gv0T+Hv7P8AYeHrCC/16BI59i/6N8smz+n/AKFXBxNxl9Qtg8vjeb3Z9TlGW0aV51nZnyp4L+BPiHxbNBc6wvlwf8+6L/6FX2z4J+FPhjwhbR77ZZ5Y/m2f8s93+1/er0S3t4bSHybaJY1/2ajkaviMPw/UxVT2uMnzeRvis+5fcoqxfkunfam1VVfuqo2hf+ArVKSo/Mpu419thcJTpR5aasj5mvVlO8pvUKbTqK64nCNqG6vrDTIWvNSuUtoF/jdsVakXZC0n+yf/AB2vzt8UfFLVfGOvalYWe/yrbzXTe+35IvWvocny2niG3VlZfmcleNdvlpLVat9j6U8afHi2tI5LPwr+7/vXc33v+ArXyV4i8Yar4huZLma5edpfvO7ZrmW33O2a/k3N/c7CjbXp4jOaGH/dYKNl3e4vqXK/aVHd/giJVR/nfc0v95qctDUxpIYoWmmbb5XzM1eBVruV5zZ1/EPap7W1ub6b7NZwPcy/3Ik3f99N91a9d+C/w7tvif8Aa7z/AFv9nzIj23mrFw33Wbu26vsLSfhnpXh5Psf2aG2ii+bZCOuf7zV+fZ1xTUpVHh8PG779j6PAZXT5PaV3t0PirQfhLr2puv29v7Pib+CH95M3/Av/AIkV9CeFfg7YaRtmhtEtJ/8An5uf3s7f7q//AF1r3eO3trH/AI9olX/a6s3+8zfeqCSvGhk+Kxvv4mo/RHbVz6FCPJQgkY+n+GfD2n/O8H22df45uVz/ALK/cX8q07rWPLhb/llEv8Xy4Wo2avhb4xfE7W/+Eh1TwzZy+RZWMph+X+P/AHq/UeEuCsFzbbbtnx2ZY/HY+fs6b9fJHsvxA+OFhpHmWGg/v5/4n/u18m614u1jXLlrmadm3f3q5Ro7md/tNzL975qbDqEP2lbb/a+9X3WPzSlg6fssOvVl4DIaVDW3NLq2X/Jmlb5624fDt/PbNc20D7V2/O3A5bbX0d4L+Fum31hFf/6/5N+5qufEa1h8OeDLu5hX/VzW6/8AkTdX5PDNcXj8UqMd2fUulTpU+e132PmnxJ4dm8OXlpDNOkks9v5rqn8Hzbf+BVh1s+INafxDf/bHi8rbCiKu7d0rDWvoaGHqUqahUevU8ab5vetYfRRRSMQp1NoqgCmbalp9ArlfbVyx02/vrn7NZxPPP/cRGZ/++V+7W34M07SNf8WWGg6jJ/x9ShIk3eX5sjfdXd/Dur7w0n4K/wBjJB9vgtrS3+/5MPzdf7y/cP8AwLdXx+e8Qzw1RUKMby/I+iwGApzpurVdkunc+MtL+G+pXn77Um+xW/8AwGU/99bvKX82r3Twr8F9/l3Ntp/+5d3u7/x3zOf+/cK/79fTWn+HdE0p/OtrbdcL913/AHjj/dZvu/8AAa2NzvXx/wBTxuPn/tE7LsjWeb0qH+7x17s4vR/hzomnp51/J9tuP+BRp/wL/lpJ/wADk/Cu5jWG3hW2to1giX7qKNqL/wABWmLUq19JgOHqFD17ngYrNatV++7jNu+pVWiKpK+lhShH4UcsZ83xBUix0KtTqtUFxnl1Y20+m7d9ACKtWKKKACihaetABTlWoqsUBcfuo3VDRRYB+6imbabVgOam0UxqAIpKhan1FQSMamVNUNABuNQs1Ok+5UNACNTd1FMagA3VGzfeqSqzffqgImkqo01PkasyZqsgfJcVQkuKgmaqcjPW8YDuNuLh65TWvEFnpVs015OsS/7TfMf91aueJlv/AOxLt9NZIrpULJv3bfl/3a+F9c8ePqu77Zv89f8AP3q+54cyulVjzVXZfmeXVw9fETcKe3V9j1Xxl8VrmdGtrCT7NB/4+/8AwKvnnVPEFzdzM/mt81Y95fTXL73rM3V9DmfEcMPD2WEVvM+oyvI6WHXNa77kzSO9MplPWvzTF5lUqtybPc2H7adT6ZXkuYh9WKiqWuSUjBkbNUTTbabcfdrN8yq5onTSpXiStI71Pbw76jX+GtWGvCx+MdmdcID4bdEq4q1GtS181K8viZ1IfUtRLU61IxVWpNpptPqAFVak8ukWrNBYzaalVaVVqVdm9d/3d3zf7tc1We514eEXJak9nZvcv5cfzV674d8M/d+XdLVvw34ZhnSN7b7v95uK9s0fR4bZK/Pc2zL2svZxdkfRynChpuyDQfDsNtGs03+truI4dlRwx7K06+jyjLIQprS7Z83jcZOc3rof/9k=]]
M.ZEYHUBB_LOCAL_IMAGE_ASSET = nil

local function _zeyhubbLoadEyeImage()
    local loader = nil
    if type(getcustomasset) == "function" then
        loader = getcustomasset
    elseif type(getsynasset) == "function" then
        loader = getsynasset
    end
    if not loader or type(writefile) ~= "function" then
        return nil
    end

    local ok, asset = pcall(function()
        if type(isfile) ~= "function" or not isfile(ZEYHUBB_UI_IMAGE_FILE) then
            writefile(ZEYHUBB_UI_IMAGE_FILE, _zeyhubbB64decode(ZEYHUBB_UI_IMAGE_B64))
        end
        return loader(ZEYHUBB_UI_IMAGE_FILE)
    end)
    if ok and asset then
        return asset
    end
    return nil
end

M.ZEYHUBB_LOCAL_IMAGE_ASSET = _zeyhubbLoadEyeImage()

local ZEYHUBB_STEAL_SPLASH_B64 = "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"
local ZEYHUBB_STEAL_SPLASH_FILE = "zeyhubb_steal_splash.png"
local function _zeyhubbEnsureStealSplash()
    local ok, asset = pcall(function()
        if not isfile or not writefile or not getcustomasset then return nil end
        if not isfile(ZEYHUBB_STEAL_SPLASH_FILE) then
            writefile(ZEYHUBB_STEAL_SPLASH_FILE, _zeyhubbB64decode(ZEYHUBB_STEAL_SPLASH_B64))
        end
        return getcustomasset(ZEYHUBB_STEAL_SPLASH_FILE)
    end)
    if ok and asset and asset ~= "" then return asset end
    return nil
end

function M.buildStatusUI()
    if M.statusGui then
        pcall(function() M.statusGui:Destroy() end)
        M.statusGui = nil
    end
    if M._stealBarStatsConn then
        pcall(function() M._stealBarStatsConn:Disconnect() end)
        M._stealBarStatsConn = nil
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "StealProgressWindow"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 5

    do
        local ok = false
        if gethui then
            ok = pcall(function() gui.Parent = gethui() end)
        elseif syn and syn.protect_gui then
            ok = pcall(function()
                syn.protect_gui(gui)
                gui.Parent = game:GetService("CoreGui")
            end)
        end
        if not ok then
            gui.Parent = player:WaitForChild("PlayerGui")
        end
    end

    for _, v in ipairs(gui.Parent:GetChildren()) do
        if v ~= gui and v:IsA("ScreenGui") and (v.Name == gui.Name or v.Name == "ZeyHubbStatusUI" or v.Name == "K7_StatusUI") then
            pcall(function() v:Destroy() end)
        end
    end

    -- 7UP-style bottom auto-grab bar: outer black (+ optional bg image), inner red fill
    local barW = math.clamp(tonumber(M.stealBarSize) or 460, 280, 720)
    local barH = 34

    local holder = Instance.new("Frame")
    holder.Name = "StealBarHolder"
    holder.AnchorPoint = Vector2.new(0.5, 0.5)
    holder.Size = UDim2.new(0, barW, 0, barH)

    if type(M._stealBarPos) == "table" then
        holder.Position = UDim2.new(
            M._stealBarPos.xScale or 0.5, M._stealBarPos.xOffset or 0,
            M._stealBarPos.yScale or 1, M._stealBarPos.yOffset or -58
        )
    else
        holder.Position = UDim2.new(0.5, 0, 1, -58)
    end

    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.ClipsDescendants = false
    holder.Active = false
    holder.Parent = gui

    -- OUTER shell (black)
    local frame = Instance.new("Frame")
    frame.Name = "StealBar"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.72
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.ClipsDescendants = true
    frame.ZIndex = 2
    frame.Parent = holder
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
    do
        local st = Instance.new("UIStroke")
        st.Name = "BarContour"
        st.Color = Color3.fromRGB(40, 40, 40)
        st.Thickness = 1.2
        st.Transparency = 0.25
        st.Parent = frame
    end

    -- Optional background image on OUTER shell only
    do
        local bgId = tonumber(M.customBgId) or 0
        local barImageAsset = M.ZEYHUBB_LOCAL_IMAGE_ASSET
        if barImageAsset or bgId > 0 then
            local bg = Instance.new("ImageLabel")
            bg.Name = "BarBgImage"
            bg.BackgroundTransparency = 1
            bg.Image = barImageAsset or ("rbxassetid://" .. tostring(bgId))
            bg.ImageTransparency = math.clamp(tonumber(M.customBgOpacity) or 0.02, 0, 0.25)
            -- Keep the same image visible when the Auto Steal bar is enlarged.
            bg.ScaleType = Enum.ScaleType.Fit
            bg.Size = UDim2.fromScale(1, 1)
            bg.ZIndex = 3
            bg.Parent = frame
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
            M.statusBgImg = bg
        else
            M.statusBgImg = nil
        end
    end

    -- CENTER progress track (black outside of fill)
    local track = Instance.new("Frame")
    track.Name = "StealTrack"
    track.Size = UDim2.new(1, -130, 1, -10)
    track.Position = UDim2.new(0, 4, 0, 5)
    track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    track.BackgroundTransparency = 0.55
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.ZIndex = 4
    track.Parent = frame
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    -- Eye image inside the progress track too, so the picture stays clearly visible
    -- across the whole Auto Steal bar while the red progress fill grows over it.
    do
        local trackEyeAsset = M.ZEYHUBB_LOCAL_IMAGE_ASSET
        if trackEyeAsset then
            local trackEye = Instance.new("ImageLabel")
            trackEye.Name = "TrackEyeImage"
            trackEye.BackgroundTransparency = 1
            trackEye.Image = trackEyeAsset
            trackEye.ImageColor3 = Color3.fromRGB(255, 255, 255)
            trackEye.ImageTransparency = 0.02
            trackEye.ScaleType = Enum.ScaleType.Crop
            trackEye.Size = UDim2.fromScale(1, 1)
            trackEye.Position = UDim2.fromScale(0, 0)
            trackEye.ZIndex = 5
            trackEye.Active = false
            trackEye.Parent = track
            Instance.new("UICorner", trackEye).CornerRadius = UDim.new(1, 0)
        end
    end
    M._stealBadgeMaxW = math.max(40, barW - 150)

    -- Auto Steal bar drag
    do
        local dragBar, dragStart, barStart

        local function beginDrag(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragBar = true
                dragStart = input.Position
                barStart = holder.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragBar = false

                        -- Persist the exact position so rebuilding/resizing
                        -- the bar never sends it back to the default location.
                        M._stealBarPos = {
                            xScale = holder.Position.X.Scale,
                            xOffset = holder.Position.X.Offset,
                            yScale = holder.Position.Y.Scale,
                            yOffset = holder.Position.Y.Offset
                        }
                        pcall(saveCherryConfig)
                    end
                end)
            end
        end

        -- Track is the reliable visible drag surface.
        track.Active = true
        track.InputBegan:Connect(beginDrag)
        frame.InputBegan:Connect(beginDrag)

        local function handleMove(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                if dragBar then
                    local delta = input.Position - dragStart
                    holder.Position = UDim2.new(
                        barStart.X.Scale, barStart.X.Offset + delta.X,
                        barStart.Y.Scale, barStart.Y.Offset + delta.Y
                    )
                end
            end
        end

        track.InputChanged:Connect(handleMove)
        frame.InputChanged:Connect(handleMove)
    end


    -- RED fill inside track
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
    fill.BorderSizePixel = 0
    fill.ZIndex = 6
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    do
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 40, 40)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(200, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 0, 0)),
        })
        g.Parent = fill
    end

    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(1, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 8
    knob.Visible = false
    knob.Parent = fill
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    M.statusKnob = knob

    local shine = Instance.new("Frame")
    shine.Name = "Shine"
    shine.Size = UDim2.new(0.28, 0, 1, 0)
    shine.Position = UDim2.new(-0.4, 0, 0, 0)
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 1
    shine.BorderSizePixel = 0
    shine.ZIndex = 7
    shine.Parent = fill
    Instance.new("UICorner", shine).CornerRadius = UDim.new(1, 0)
    M.statusFill = fill
    M.statusShine = shine
    M._stealShineTween = nil
    M._stealShineActive = false

    local stealLbl = Instance.new("TextLabel")
    stealLbl.Name = "StealLabel"
    stealLbl.Size = UDim2.new(1, -12, 1, 0)
    stealLbl.Position = UDim2.new(0, 8, 0, 0)
    stealLbl.BackgroundTransparency = 1
    stealLbl.Text = "BRAINROT  0%"
    stealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    stealLbl.Font = Enum.Font.GothamBold
    stealLbl.TextSize = 11
    stealLbl.TextXAlignment = Enum.TextXAlignment.Left
    stealLbl.ZIndex = 9
    stealLbl.Parent = track
    M.statusStealLbl = stealLbl
    M.statusBarPctLbl = stealLbl
    M.statusPctLbl = stealLbl

    -- RIGHT side: FPS only. The old NORMAL mode pill is intentionally removed.
    local rightSide = Instance.new("Frame")
    rightSide.Name = "RightSide"
    rightSide.Size = UDim2.new(0, 62, 1, -8)
    rightSide.Position = UDim2.new(1, -66, 0, 4)
    rightSide.BackgroundTransparency = 1
    rightSide.ZIndex = 4
    rightSide.Parent = frame

    M.statusModePill = nil
    M.statusModeLbl = nil

    local statsPill = Instance.new("Frame")
    statsPill.Size = UDim2.new(0, 60, 1, 0)
    statsPill.Position = UDim2.new(0, 0, 0, 0)
    statsPill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    statsPill.BackgroundTransparency = 0.2
    statsPill.BorderSizePixel = 0
    statsPill.ZIndex = 5
    statsPill.Parent = rightSide
    Instance.new("UICorner", statsPill).CornerRadius = UDim.new(1, 0)
    local statsLbl = Instance.new("TextLabel")
    statsLbl.Size = UDim2.new(1, -4, 1, 0)
    statsLbl.Position = UDim2.new(0, 2, 0, 0)
    statsLbl.BackgroundTransparency = 1
    statsLbl.Text = "-- FPS\n--ms"
    statsLbl.TextColor3 = Color3.fromRGB(210, 210, 215)
    statsLbl.Font = Enum.Font.GothamBold
    statsLbl.TextSize = 8
    statsLbl.TextYAlignment = Enum.TextYAlignment.Center
    statsLbl.ZIndex = 6
    statsLbl.Parent = statsPill
    M.statusFpsLbl = statsLbl

    M.statusEqIcon = nil
    M.statusRadiusLbl = nil
    M.statusDot = nil
    M.statusRadiusMarker = nil
    M.statusRadiusMarkerLbl = nil
    M.updateRadiusMarker = function() end
    M.statusGui = gui
    M.statusMain = frame
    M.statusHolder = holder

    function M.updateStatusModeBadge() end

    do
        local last = tick()
        local frames = 0
        local fps = 60
        M._stealBarStatsConn = RunService.RenderStepped:Connect(function()
            frames = frames + 1
            local now = tick()
            if now - last >= 0.4 then
                fps = math.floor(frames / (now - last) + 0.5)
                frames = 0
                last = now
                if M.statusFpsLbl and M.statusFpsLbl.Parent then
                    local ping = 0
                    pcall(function()
                        ping = math.floor(player:GetNetworkPing() * 1000 + 0.5)
                    end)
                    M.statusFpsLbl.Text = string.format("%d FPS\n%dms", fps, ping)
                end
            end
        end)
    end
end


function M.updateStealProgress(progress, label)
    progress = math.clamp(progress or 0, 0, 1)
    local pct = math.floor(progress * 100 + 0.5)
    if M.statusFill then
        M.statusFill.Size = UDim2.new(progress, 0, 1, 0)
        -- Stage colors: 0–50% white → 50–75% yellow/orange → 75%+ red
        local col
        if progress < 0.5 then
            col = Color3.fromRGB(255, 255, 255)
        elseif progress < 0.75 then
            local t = (progress - 0.5) / 0.25
            col = Color3.fromRGB(255, 230, 40):Lerp(Color3.fromRGB(255, 120, 15), t)
        else
            local t = math.clamp((progress - 0.75) / 0.25, 0, 1)
            col = Color3.fromRGB(230, 40, 40):Lerp(Color3.fromRGB(200, 0, 0), t)
        end
        M.statusFill.BackgroundColor3 = col
        local grad = M.statusFill:FindFirstChildOfClass("UIGradient")
        if grad then
            if progress < 0.5 then
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 230, 235)),
                })
            elseif progress < 0.75 then
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 80)),
                    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 170, 30)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 10)),
                })
            else
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
                    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(210, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 0, 0)),
                })
            end
        end
    end
    if M.statusKnob then
        M.statusKnob.Visible = progress > 0.02
    end
    local text
    if type(label) == "string" and label ~= "" and not tostring(label):match("^%d") then
        text = string.format("%s  %d%%", string.upper(label), pct)
    else
        text = string.format("BRAINROT  %d%%", pct)
    end
    if M.statusBarPctLbl then M.statusBarPctLbl.Text = text end
    if M.statusPctLbl and M.statusPctLbl ~= M.statusBarPctLbl then
        M.statusPctLbl.Text = text
    end
    if M.statusStealLbl and M.statusStealLbl ~= M.statusBarPctLbl then
        M.statusStealLbl.Text = text
    end
    if progress > 0.02 and progress < 1 then
        if not M._stealShineActive and M.statusShine then
            M._stealShineActive = true
            M.statusShine.BackgroundTransparency = 0.55
            local function loopShine()
                if not M._stealShineActive or not M.statusShine or not M.statusShine.Parent then
                    M._stealShineActive = false
                    return
                end
                M.statusShine.Position = UDim2.new(-0.45, 0, 0, 0)
                local tw = TweenService:Create(M.statusShine, TweenInfo.new(0.85, Enum.EasingStyle.Linear), {
                    Position = UDim2.new(1.1, 0, 0, 0)
                })
                M._stealShineTween = tw
                tw:Play()
                tw.Completed:Connect(function()
                    if M._stealShineActive then
                        task.delay(0.15, loopShine)
                    end
                end)
            end
            loopShine()
        end
    else
        M._stealShineActive = false
        if M._stealShineTween then pcall(function() M._stealShineTween:Cancel() end) end
        if M.statusShine then
            M.statusShine.BackgroundTransparency = 1
            M.statusShine.Position = UDim2.new(-0.4, 0, 0, 0)
        end
        if progress <= 0 and M.statusKnob then
            M.statusKnob.Visible = false
        end
    end
end


function M.updateStatusRadius()
    if M.statusRadiusLbl then
        M.statusRadiusLbl.Text = "Radius: " .. tostring(M.getActiveStealRadius())
    end
    if M.headerRadiusLbl then
        M.headerRadiusLbl.Text = tostring(M.getActiveStealRadius())
    end
    if M.updateRadiusMarker then
        M.updateRadiusMarker()
    end
end

-- ============================================================
-- AUTO STEAL (unchanged)
-- ============================================================
if not fireproximityprompt then
    fireproximityprompt = (getgenv and getgenv().fireproximityprompt)
        or (genv and genv().fireproximityprompt)
        or function(prompt)
            pcall(function()
                prompt:InputHoldBegin()
                task.wait(0.05)
                prompt:InputHoldEnd()
            end)
        end
end

local function isMyPlot(plotName)
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

local function scanPlotNormal(plot)
    if not plot or not plot:IsA("Model") then return end
    if isMyPlot(plot.Name) then return end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return end
    for _, pod in ipairs(podiums:GetChildren()) do
        if pod:IsA("Model") and pod:FindFirstChild("Base") then
            local uid = plot.Name .. "_" .. pod.Name
            for _, ex in ipairs(M.animalCache) do if ex.uid == uid then return end end
            table.insert(M.animalCache, {
                name = pod.Name,
                plot = plot.Name,
                slot = pod.Name,
                worldPosition = pod:GetPivot().Position,
                uid = uid,
            })
        end
    end
end

local function findPromptNormal(ad)
    if not ad then return nil end
    local cp = M.promptCache[ad.uid]
    if cp and cp.Parent then return cp end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local plot = plots:FindFirstChild(ad.plot)
    if not plot then return nil end
    local pods = plot:FindFirstChild("AnimalPodiums")
    if not pods then return nil end
    local pod = pods:FindFirstChild(ad.slot)
    if not pod then return nil end
    local base = pod:FindFirstChild("Base")
    if not base then return nil end
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    local att = spawn:FindFirstChild("PromptAttachment")
    local prompt = nil
    if att then
        for _, p in ipairs(att:GetChildren()) do
            if p:IsA("ProximityPrompt") then prompt = p; break end
        end
    end
    if not prompt then
        for _, obj in ipairs(spawn:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then prompt = obj; break end
        end
    end
    if prompt then M.promptCache[ad.uid] = prompt end
    return prompt
end

local function nearestAnimalNormal()
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestD = nil, math.huge
    for _, ad in ipairs(M.animalCache) do
        if not isMyPlot(ad.plot) and ad.worldPosition then
            local d = (hrp.Position - ad.worldPosition).Magnitude
            if d < bestD then bestD = d; best = ad end
        end
    end
    return best, bestD
end

local function buildCallbacks(prompt)
    if M.stealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(c1) == "table" then
        for _, conn in ipairs(c1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    local ok2, c2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(c2) == "table" then
        for _, conn in ipairs(c2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then
        M.stealCache[prompt] = data
    end
end

local function execStealNormal(prompt, animalName)
    local data = M.stealCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    M.isStealing = true
    M.stealStartTime = tick()
    M.updateStealProgress(0.1)

    if M.progressConn then M.progressConn:Disconnect() end
    M.progressConn = RunService.Heartbeat:Connect(function()
        if not M.isStealing then
            M.progressConn:Disconnect()
            M.progressConn = nil
            return
        end
        local prog = math.clamp((tick() - M.stealStartTime) / M.Steal.StealDuration, 0, 1)
        M.updateStealProgress(prog)
    end)

    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        local elapsed = 0
        while elapsed < M.Steal.StealDuration do elapsed = elapsed + task.wait() end
        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
        task.wait(0.01)
        if M.progressConn then M.progressConn:Disconnect(); M.progressConn = nil end
        M.isStealing = false
        M.updateStealProgress(0)
        data.ready = true
    end)
    return true
end

function M.startNormalSteal()
    if M.stealConn then return end
    M.stealConn = RunService.Heartbeat:Connect(function()
        if not M.Steal.AutoStealEnabled or (M.stealMode ~= "Normal" and M.stealMode ~= "V1") or M.isStealing then return end
        local target, dist = nearestAnimalNormal()
        if not target then return end
        if dist > M.getActiveStealRadius() then return end
        local prompt = M.promptCache[target.uid]
        if not prompt or not prompt.Parent then
            prompt = findPromptNormal(target)
        end
        if prompt then
            buildCallbacks(prompt)
            execStealNormal(prompt, target.name)
        end
    end)
end

function M.stopNormalSteal()
    if M.stealConn then
        M.stealConn:Disconnect()
        M.stealConn = nil
    end
    M.isStealing = false
    if M.progressConn then M.progressConn:Disconnect(); M.progressConn = nil end
    M.updateStealProgress(0)
end

-- ============================================================
-- V2 AUTO-STEAL (from ZEYHUBB — pause at 75%, finish when close)
-- ============================================================
do
    local V2 = M.V2 or {}
    M.V2 = V2
    V2.enabled = false
    V2.isStealing = false
    V2.data = V2.data or {}
    V2.conn = nil
    V2.progressConn = nil
    V2.stealStartTime = 0
    V2.paused = false
    V2.pauseStarted = nil
    V2.pausedDuration = 0
    local function barSet(p, label)
        local progress = math.clamp(tonumber(p) or 0, 0, 1)
        local pct = math.floor(progress * 100 + 0.5)
        local text = nil
        if type(label) == "string" and label ~= "" then
            text = string.upper(label)
            if progress > 0 then text = text .. "  " .. tostring(pct) .. "%" end
        end
        M.updateStealProgress(progress, text)
    end
    local function barReset()
        M.updateStealProgress(0)
    end
    local function execStealV2(prompt)
        if V2.isStealing then return end
        if not prompt then return end
        buildCallbacks(prompt)
        local data = M.stealCache[prompt]
        if not data or not data.ready then return end
        data.ready = false
        V2.isStealing = true
        M.isStealing = true
        V2.stealStartTime = tick()
        V2.paused = false
        V2.pauseStarted = nil
        V2.pausedDuration = 0
        local duration = math.max(tonumber(M.Steal.StealDuration) or 1.4, 0.05)
        local pauseFraction = 0.75 -- always pause / hold bar at 75%
        local finishFraction = 1 - pauseFraction
        local targetPart = prompt:FindFirstAncestorWhichIsA("BasePart")
        local restarting = false
        local function modeStillActive()
            return V2.enabled and M.stealMode == "V2" and V2.isStealing
        end
        local function isTargetInCurrentRadius()
            local char = player.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
            local radius = M.getActiveStealRadius()
            return root and targetPart and targetPart.Parent and (root.Position - targetPart.Position).Magnitude <= radius
        end
        local function isCloseEnoughToGrab()
            -- While auto left/right pathing, don't require tight range — steal must continue
            if M.autoLeftEnabled or M.autoRightEnabled then
                return isTargetInCurrentRadius()
            end
            local char = player.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
            local closeRange = math.min(M.getActiveStealRadius(), 12)
            return root and targetPart and targetPart.Parent and (root.Position - targetPart.Position).Magnitude <= closeRange
        end
        local function canStillGrab()
            if not prompt or not prompt.Parent or not targetPart or not targetPart.Parent then return false end
            -- Keep grab alive during auto left/right even if prompt briefly disables
            if M.autoLeftEnabled or M.autoRightEnabled then
                return isTargetInCurrentRadius() or true
            end
            if not prompt.Enabled then return false end
            if not tostring(prompt.ActionText):lower():find("steal", 1, true) then return false end
            return isTargetInCurrentRadius()
        end
        local function restartFromZero()
            if restarting then return end
            restarting = true
            V2.paused = false
            V2.pauseStarted = nil
            V2.pausedDuration = 0
            if V2.progressConn then V2.progressConn:Disconnect(); V2.progressConn = nil end
            barReset()
            data.ready = true
            V2.isStealing = false
            M.isStealing = false
        end
        if V2.progressConn then V2.progressConn:Disconnect() end
        V2.progressConn = RunService.Heartbeat:Connect(function()
            if not V2.isStealing then
                if V2.progressConn then V2.progressConn:Disconnect(); V2.progressConn = nil end
                return
            end
            if not modeStillActive() or not canStillGrab() then
                restartFromZero()
                return
            end
            local elapsed = tick() - V2.stealStartTime - (V2.pausedDuration or 0)
            if V2.paused and V2.pauseStarted then
                -- freeze bar exactly at 75% while waiting to finish
                barSet(pauseFraction, "BRAINROT")
            else
                -- never show past 75% until finish phase resumes
                local p = math.clamp(elapsed / duration, 0, 1)
                if p > pauseFraction then p = pauseFraction end
                barSet(p)
            end
        end)
        task.spawn(function()
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
            if #data.holdCallbacks == 0 and #data.triggerCallbacks == 0 and fireproximityprompt then
                pcall(function()
                    fireproximityprompt(prompt, duration)
                end)
            end
            local holdStart = tick()
            while tick() - holdStart < duration * pauseFraction do
                if not modeStillActive() or not canStillGrab() then
                    restartFromZero()
                    return
                end
                task.wait()
            end
            V2.paused = true
            V2.pauseStarted = tick()
            barSet(pauseFraction, "BRAINROT") -- hard stop display at 75%
            local wasAbleToGrab = false
            local waitStart = tick()
            while modeStillActive() do
                if not canStillGrab() then
                    restartFromZero()
                    return
                end
                if isCloseEnoughToGrab() then
                    wasAbleToGrab = true
                    break
                end
                if tick() - waitStart >= 0.95 then
                    wasAbleToGrab = true
                    break
                end
                task.wait()
            end
            if not modeStillActive() or not canStillGrab() then
                restartFromZero()
                return
            end
            if wasAbleToGrab then
                V2.pausedDuration = (V2.pausedDuration or 0) + (tick() - V2.pauseStarted)
                V2.paused = false
                V2.pauseStarted = nil
                local finishStart = tick()
                while tick() - finishStart < duration * finishFraction do
                    if not modeStillActive() or not canStillGrab() then
                        restartFromZero()
                        return
                    end
                    task.wait()
                end
                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
                if V2.progressConn then V2.progressConn:Disconnect(); V2.progressConn = nil end
                barSet(1, "SUCCESS")
                task.wait(0.05)
                barReset()
                data.ready = true
                V2.isStealing = false
                M.isStealing = false
            else
                restartFromZero()
            end
        end)
    end
    function M.startV2Steal()
        V2.enabled = true
        V2.isStealing = false
        if V2.conn then V2.conn:Disconnect(); V2.conn = nil end
        V2.conn = RunService.Heartbeat:Connect(function()
            if not V2.enabled then return end
            if not M.Steal.AutoStealEnabled then return end
            if M.stealMode ~= "V2" then M.stopV2Steal(); return end
            if V2.isStealing then return end
            local target, dist = nearestAnimalNormal()
            if not target then return end
            if dist > M.getActiveStealRadius() then return end
            local prompt = M.promptCache[target.uid]
            if not prompt or not prompt.Parent then
                prompt = findPromptNormal(target)
            end
            if prompt then
                execStealV2(prompt)
            end
        end)
    end
    function M.stopV2Steal()
        V2.enabled = false
        V2.isStealing = false
        V2.paused = false
        V2.pauseStarted = nil
        V2.pausedDuration = 0
        if V2.conn then V2.conn:Disconnect(); V2.conn = nil end
        if V2.progressConn then V2.progressConn:Disconnect(); V2.progressConn = nil end
        M.isStealing = false
        barReset()
    end
end

-- ============================================================
-- SEMI AUTO-STEAL (unchanged)
-- ============================================================
do
    local A = M.Semi
    if A.conn then pcall(function() A.conn:Disconnect() end); A.conn = nil end
    A.enabled = false
    A.holdMin = tonumber(A.holdMin) or 1.3
    A.holdMax = tonumber(A.holdMax) or 2.6
    A.entryDelay = tonumber(A.entryDelay) or 0.3
    A.cooldown = tonumber(A.cooldown) or 0.05
    A.primeRange = tonumber(A.primeRange) or 80
    A.radius = math.min(tonumber(A.radius) or 10, 10)
    A.plotSync = A.plotSync or {caches = {}, connections = {}}
    A.animals = A.animals or {}
    A.promptCache = A.promptCache or {}
    A.internalCache = A.internalCache or {}
    A.state = A.state or {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0}

    local function barSet(p, label)
        local progress = math.clamp(tonumber(p) or 0, 0, 1)
        local pct = math.floor(progress * 100 + 0.5)
        local text = nil
        if type(label) == "string" and label ~= "" then
            text = string.upper(label)
            if progress > 0 then
                text = text .. "  " .. tostring(pct) .. "%"
            end
        end
        M.updateStealProgress(progress, text)
    end
    local function barReset()
        M.updateStealProgress(0)
    end
    local function rootPart()
        local char = player.Character
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

    function M.initSemiSync()
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
        return owner == player.DisplayName or owner == player.Name
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

    function M.scanAllPlotsSemi()
        if not M.initSemiSync() then return 0 end
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
    local function buildCallbacks(prompt)
        if A.internalCache[prompt] then return end
        local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
        local okHold, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if okHold and type(holds) == "table" then
            for _, conn in ipairs(holds) do
                if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
            end
        end
        local okTrigger, triggers = pcall(getconnections, prompt.Triggered)
        if okTrigger and type(triggers) == "table" then
            for _, conn in ipairs(triggers) do
                if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
            end
        end
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then A.internalCache[prompt] = data end
    end
    local function executeSemi(prompt, animalData)
        if not prompt or not prompt.Parent or not animalData then return false end
        buildCallbacks(prompt)
        local data = A.internalCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        A.state.active = true
        A.state.startTime = tick()
        A.state.phase = "holding"
        A.state.label = animalData.name or "Animal"
        M.isStealing = true
        M.stealStartTime = A.state.startTime
        task.spawn(function()
            local startTime = A.state.startTime
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
            while A.enabled and M.stealMode == "Semi" and tick() - startTime < (A.holdMin or 1.3) do
                local elapsed = tick() - startTime
                A.state.phase = "holding"
                barSet(elapsed / (A.holdMax or 2.6), "HOLDING " .. tostring(A.state.label))
                task.wait()
            end
            A.state.phase = "waitingRange"
            local alreadyInRange = distToAnimal(animalData) <= (tonumber(A.radius) or 10)
            local fired = false
            while A.enabled and M.stealMode == "Semi" and prompt.Parent do
                local elapsed = tick() - startTime
                if elapsed > (A.holdMax or 2.6) then break end
                barSet(elapsed / (A.holdMax or 2.6), "MOVE CLOSER  " .. tostring(A.state.label))
                if distToAnimal(animalData) <= (tonumber(A.radius) or 10) then
                    if not alreadyInRange then task.wait(A.entryDelay or 0.3) end
                    if A.enabled and M.stealMode == "Semi" then
                        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
                        pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
                        fired = true
                    end
                    break
                end
                task.wait()
            end
            A.state.lastResult = fired and ("Stole " .. tostring(A.state.label)) or ("Missed window: " .. tostring(A.state.label))
            A.state.active = false
            A.state.phase = "idle"
            A.state.lastResultTime = tick()
            if fired then
                barSet(1, "STOLE " .. tostring(A.state.label))
            else
                barSet(0, A.state.lastResult)
            end
            task.wait(A.cooldown or 0.05)
            data.ready = true
            M.isStealing = false
            barReset()
        end)
        return true
    end

    function M.stopSemiSteal()
        A.enabled = false
        if A.conn then A.conn:Disconnect(); A.conn = nil end
        A.state.active = false
        A.state.phase = "idle"
        M.isStealing = false
        barReset()
    end

    function M.startSemiSteal()
        A.radius = math.min(tonumber(A.radius) or 10, 10)
        A.enabled = true
        M.initSemiSync()
        pcall(M.scanAllPlotsSemi)
        if A.conn then A.conn:Disconnect(); A.conn = nil end
        A.conn = RunService.Heartbeat:Connect(function()
            if not A.enabled then return end
            if not M.Steal.AutoStealEnabled then return end
            if M.stealMode ~= "Semi" then M.stopSemiSteal(); return end
            if A.state.active then return end
            local target = pickClosest()
            if not target then return end
            local prompt = findPromptForAnimal(target)
            if prompt then executeSemi(prompt, target) end
        end)
    end
end

local function v3ReleasePrompt(prompt)
    if not prompt then return end
    pcall(function()
        if prompt.InputHoldEnd then prompt:InputHoldEnd() end
    end)
end

local function v3HoldPrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    -- Native hold (works without getconnections)
    local ok = pcall(function()
        if prompt.InputHoldBegin then
            prompt:InputHoldBegin()
        end
    end)
    if not ok then
        pcall(function()
            if fireproximityprompt then
                fireproximityprompt(prompt)
            end
        end)
    end
    -- Also fire hooked hold callbacks if available
    buildCallbacks(prompt)
    local data = M.stealCache[prompt]
    if data then
        for _, fn in ipairs(data.holdCallbacks) do
            task.spawn(function() pcall(fn) end)
        end
    end
    return true
end

local function v3TriggerPrompt(prompt)
    if not prompt then return end
    buildCallbacks(prompt)
    local data = M.stealCache[prompt]
    if data then
        for _, fn in ipairs(data.triggerCallbacks) do
            task.spawn(function() pcall(fn) end)
        end
    end
    pcall(function()
        if prompt.InputHoldEnd then prompt:InputHoldEnd() end
    end)
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt)
        end
    end)
end

local function v3LiveDist(ad, hrp)
    if not ad or not hrp then return math.huge end
    -- Prefer live podium position so cache doesn't go stale
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(ad.plot)
    local pods = plot and plot:FindFirstChild("AnimalPodiums")
    local pod = pods and pods:FindFirstChild(ad.slot)
    if pod then
        local ok, pos = pcall(function() return pod:GetPivot().Position end)
        if ok and pos then
            ad.worldPosition = pos
            return (hrp.Position - pos).Magnitude
        end
    end
    if ad.worldPosition then
        return (hrp.Position - ad.worldPosition).Magnitude
    end
    return math.huge
end

function M.startV3Steal()
    if M.V3.conn then return end
    M.V3.enabled = true
    M.V3.progress = 0
    M.V3.currentUid = nil
    M.V3.lastInRange = 0
    M.V3.holding = false
    M.V3.holdPrompt = nil
    M.V3.cooldownUntil = 0
    M.V3.lastHoldPulse = 0

    M.V3.conn = RunService.Heartbeat:Connect(function(dt)
        if not M.Steal.AutoStealEnabled or M.stealMode ~= "V3" or not M.V3.enabled then
            if M.V3.holdPrompt then v3ReleasePrompt(M.V3.holdPrompt) end
            if M.V3.progress > 0 or M.V3.holding or M.isStealing then
                M.V3.progress = 0
                M.V3.currentUid = nil
                M.V3.holding = false
                M.V3.holdPrompt = nil
                M.isStealing = false
                M.updateStealProgress(0)
            end
            return
        end

        local stopT = math.max(tonumber(M.Steal.StopTime) or 0.35, 0.05)
        local holdT = math.max(tonumber(M.Steal.StealDuration) or 1.4, 0.05)

        if tick() < (M.V3.cooldownUntil or 0) then
            M.updateStealProgress(0)
            return
        end

        local char = player.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
        if not hrp then return end

        local target = nearestAnimalNormal()
        local dist = target and v3LiveDist(target, hrp) or math.huge
        local radius = M.getActiveStealRadius()
        local inRange = target ~= nil and dist <= radius

        if inRange then
            M.V3.lastInRange = tick()

            if M.V3.currentUid ~= target.uid then
                -- switched pet: release old hold, keep some progress only if same fill preferred restart
                if M.V3.holdPrompt then v3ReleasePrompt(M.V3.holdPrompt) end
                M.V3.currentUid = target.uid
                M.V3.progress = 0
                M.V3.holding = false
                M.V3.holdPrompt = nil
            end

            local prompt = M.promptCache[target.uid]
            if not prompt or not prompt.Parent then
                prompt = findPromptNormal(target)
            end
            if not prompt then
                -- still show proximity progress so bar matches video feel
                M.V3.progress = math.clamp(M.V3.progress + (dt / holdT), 0, 1)
                M.updateStealProgress(M.V3.progress)
                M.isStealing = M.V3.progress > 0
                return
            end

            -- Keep hold alive: pulse InputHoldBegin ~10x/sec while in range
            M.V3.holdPrompt = prompt
            M.isStealing = true
            local now = tick()
            if (not M.V3.holding) or (now - (M.V3.lastHoldPulse or 0) > 0.1) then
                M.V3.holding = true
                M.V3.lastHoldPulse = now
                v3HoldPrompt(prompt)
            end

            M.V3.progress = math.clamp(M.V3.progress + (dt / holdT), 0, 1)
            M.updateStealProgress(M.V3.progress)

            if M.V3.progress >= 1 then
                v3TriggerPrompt(prompt)
                M.V3.progress = 0
                M.V3.currentUid = nil
                M.V3.holding = false
                M.V3.holdPrompt = nil
                M.isStealing = false
                M.updateStealProgress(0)
                M.V3.cooldownUntil = tick() + math.max(stopT, 0.25)
            end
        else
            -- Out of range: release hold, decay progress over Stop Time (video-style drop)
            if M.V3.holding or M.V3.holdPrompt then
                v3ReleasePrompt(M.V3.holdPrompt)
                M.V3.holding = false
                M.V3.holdPrompt = nil
            end

            if M.V3.progress > 0 then
                local decay = dt / stopT
                M.V3.progress = math.max(0, M.V3.progress - decay)
                M.updateStealProgress(M.V3.progress)
                if M.V3.progress <= 0 then
                    M.V3.currentUid = nil
                    M.isStealing = false
                    M.updateStealProgress(0)
                else
                    M.isStealing = true
                end
            else
                M.isStealing = false
            end
        end
    end)
end

function M.stopV3Steal()
    M.V3.enabled = false
    if M.V3.holdPrompt then
        v3ReleasePrompt(M.V3.holdPrompt)
    end
    if M.V3.conn then
        pcall(function() M.V3.conn:Disconnect() end)
        M.V3.conn = nil
    end
    M.V3.progress = 0
    M.V3.currentUid = nil
    M.V3.holding = false
    M.V3.holdPrompt = nil
    M.V3.cooldownUntil = 0
    M.V3.lastInRange = 0
    M.V3.lastHoldPulse = 0
    M.isStealing = false
    M.updateStealProgress(0)
end

function M.startAutoSteal()
    if M.statusGui then M.statusGui.Enabled = true end
    local mode = M.stealMode
    if mode == "Normal" then
        M.startNormalSteal()
    elseif mode == "Semi" then
        M.startSemiSteal()
    else
        -- V2 (default)
        M.stealMode = "V2"
        M.startV2Steal()
    end
end

function M.stopAutoSteal()
    if M.statusGui then M.statusGui.Enabled = true end
    M.stopNormalSteal()
    M.stopSemiSteal()
    if M.stopV2Steal then M.stopV2Steal() end
    if M.stopV3Steal then M.stopV3Steal() end
    M.isStealing = false
    M.updateStealProgress(0)
end

function M.setStealRadius(radius)
    M.Steal.StealRadius = radius
    M.updateStatusRadius()
end

-- ============================================================
-- OTHER CORE FUNCTIONS (unchanged - abbreviate per spazio)
-- ============================================================
function M.findBat()
    local char=player.Character;if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=player:FindFirstChild("Backpack");if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end

function M.findMedusa()
    local c=player.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=player:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end

function M.useMedusaCounter()
    if M.medusaDebounce then return end;if M.MEDUSA_COOLDOWN>(tick()-M.medusaLastUsed) then return end
    local c=player.Character;if not c then return end;M.medusaDebounce=true
    local med=M.findMedusa();if not med then M.medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);M.medusaLastUsed=tick();M.medusaDebounce=false
end

function M.onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if not part.Anchored then return end
        if M._isInstaResetting then return end
        -- Medusa Reset / insta-reset removed — only counter remains
        if M.medusaCounterEnabled and part.Transparency == 1 then
            pcall(function() M.useMedusaCounter() end)
        end
    end)
end

function M.setupMedusa(char)
    for _,c in pairs(M.Conns.anchor) do pcall(function() c:Disconnect() end) end;M.Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(M.Conns.anchor,M.onAnchorChanged(part)) end end
    table.insert(M.Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(M.Conns.anchor,M.onAnchorChanged(part)) end end))
end

function M.stopMedusaCounter() for _,c in pairs(M.Conns.anchor) do pcall(function() c:Disconnect() end) end;M.Conns.anchor={} end

function M.findBatForCounter()
    local c=player.Character;if not c then return nil end;local bp=player:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(M.BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end

function M.swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end

function M.startBatCounter()
    if M.Conns.batCounter then return end
    M.Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not M.batCounterEnabled or M.batCounterDebounce then return end
        local char=player.Character;if not char then return end;local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            M.batCounterDebounce=true;task.spawn(function() local bat=M.findBatForCounter();if bat then M.swingBatForCounter(bat,char) end;task.wait(0.5);M.batCounterDebounce=false end)
        end
    end)
end

function M.stopBatCounter() if M.Conns.batCounter then M.Conns.batCounter:Disconnect();M.Conns.batCounter=nil end;M.batCounterDebounce=false end

-- ============================================================
-- NORMAL AIMBOT (ZeyHubb logic)
-- ============================================================
M.aimbotSpeed = M.aimbotSpeed or 58
M.laggerAimbotSpeed = M.laggerAimbotSpeed or 40
M._aimbotSwingCooldown = false


M.aimbotSpeed = M.aimbotSpeed or 57
M.laggerAimbotSpeed = M.laggerAimbotSpeed or 40
M.aimbotHitRange = M.aimbotHitRange or 9.5
M.aimbotSwingCD = M.aimbotSwingCD or 0.12
M.aimbotRotationSpeed = M.aimbotRotationSpeed or 0.55
M.aimbotRotationEnabled = true
M.aimbotHeightOffset = M.aimbotHeightOffset or 1.6

function M.findBatForAimbot()
    local char = player.Character
    if not char then return nil end
    local bp = player:FindFirstChild("Backpack")
    -- Prefer exact names from slap list first
    if M.BAT_COUNTER_SLAP_LIST then
        for _, name in ipairs(M.BAT_COUNTER_SLAP_LIST) do
            local t = char:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
            if t and t:IsA("Tool") then return t end
        end
    end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("bat") or n:find("slap") then return tool end
        end
    end
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("bat") or n:find("slap") then return tool end
            end
        end
    end
    return nil
end

function M.getClosestTargetAimbot()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
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

-- Sticky target: hold same enemy ~1.25s
M.AIMBOT_STICKY_TIME = M.AIMBOT_STICKY_TIME or 1.25
M.AIMBOT_STICKY_MAX_DIST = M.AIMBOT_STICKY_MAX_DIST or 85
M._aimbotStickyUntil = 0
M._aimbotStickyTarget = nil

function M.getAutoBatTarget()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    local function stillValid(tRoot)
        if not tRoot or not tRoot.Parent then return false end
        local hum = tRoot.Parent:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        if (tRoot.Position - root.Position).Magnitude > (M.AIMBOT_STICKY_MAX_DIST or 85) then return false end
        return true
    end
    local sticky = M._aimbotStickyTarget
    if sticky and now < (M._aimbotStickyUntil or 0) and stillValid(sticky) then
        M._aimbotTarget = sticky
        return sticky
    end
    if now - (M._aimbotLastScan or 0) <= 0.08 and M._aimbotTarget and stillValid(M._aimbotTarget) then
        return M._aimbotTarget
    end
    M._aimbotLastScan = now
    local closest = M.getClosestTargetAimbot and M.getClosestTargetAimbot() or nil
    M._aimbotTarget = closest
    M._aimbotStickyTarget = closest
    M._aimbotStickyUntil = now + (tonumber(M.AIMBOT_STICKY_TIME) or 1.25)
    return closest
end

function M.getNormalAimbotSpeed()
    -- ZeyHubb/S2hub: Lagger modes use lagger aimbot speed, else normal aimbot speed
    if M.laggerModeEnabled or M.laggerCarryActive then
        return tonumber(M.laggerAimbotSpeed) or 40
    end
    return tonumber(M.aimbotSpeed) or 58
end

function M._aimbotSwingBat(char, bat)
    if not bat or not bat.Parent then return end
    if bat.Parent ~= char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:EquipTool(bat) end) end
        return
    end
    pcall(function() bat:Activate() end)
end

function M.startBatAimbot()
    if not M.safeModeTryStart() then return end
    if M.aimbotConn then
        pcall(function() M.aimbotConn:Disconnect() end)
        M.aimbotConn = nil
    end
    pcall(function() RunService:UnbindFromRenderStep("ZeyHubbAimbotRotCam") end)

    if M.autoLeftEnabled then
        M.autoLeftEnabled = false
        if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
        M.stopAutoLeft()
    end
    if M.autoRightEnabled then
        M.autoRightEnabled = false
        if M.autoRightSetVisual then M.autoRightSetVisual(false) end
        M.stopAutoRight()
    end

    M._autoTPWasEnabledForBat = false
    if M.autoTPEnabled then
        M._autoTPWasEnabledForBat = true
        M.stopAutoTP()
        if M.setAutoTPVisual then M.setAutoTPVisual(false) end
    end
    pcall(function()
        if M.stopAutoTPForAction then M.stopAutoTPForAction() end
    end)

    M.autoBatEnabled = true
    M.autoSwingEnabled = true
    M.autoBatEquippedThisRun = false
    pcall(function() M.syncCombatAntiDie() end)
    M._aimbotTarget = nil
    M._aimbotLastScan = 0

    -- SCYTHE VS aimbot: Heartbeat + prediction + angular velocity + sticky
    M.aimbotConn = RunService.Heartbeat:Connect(function()
        if not M.autoBatEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = M.findBatForAimbot and M.findBatForAimbot() or nil
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target = (M.getAutoBatTarget and M.getAutoBatTarget()) or (M.getClosestTargetAimbot and M.getClosestTargetAimbot())
        if not target then
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            return
        end
        M._aimbotTarget = target
        hum.AutoRotate = false

        local targetVel = target.AssemblyLinearVelocity or Vector3.zero
        local myPos = root.Position
        local targetPos = target.Position
        -- Prediction always on
        local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0.01 then flatDir = flatDir.Unit else flatDir = Vector3.new(0, 0, 1) end

        local chaseSpeed = M.getNormalAimbotSpeed and M.getNormalAimbotSpeed() or (tonumber(M.aimbotSpeed) or 58)
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
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

        if M.autoSwingEnabled ~= false then
            local bat = char:FindFirstChild("Bat") or (M.findBatForAimbot and M.findBatForAimbot())
            if bat and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
        end
    end)

    if M.autoBatSetVisual then M.autoBatSetVisual(true) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(true) end
end

function M.stopBatAimbot()
    if M.aimbotConn then
        pcall(function() M.aimbotConn:Disconnect() end)
        M.aimbotConn = nil
    end
    pcall(function() RunService:UnbindFromRenderStep("ZeyHubbAimbotRotCam") end)
    do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if root then
            pcall(function()
                root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
                root.AssemblyAngularVelocity = Vector3.zero
            end)
        end
        if hum then pcall(function() hum.AutoRotate = true end) end
    end
    M._aimbotStickyTarget = nil
    M._aimbotLookPos = nil
    M._aimbotTarget = nil
    M._aimbotSwingCooldown = false
    M._aimbotLastSwing = 0
    M._aimbotTargetLockUntil = 0
    M.autoBatEnabled = false
    M.autoBatEquippedThisRun = false
    pcall(function() M.syncCombatAntiDie() end)

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    local hum2 = char and char:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end

    if M._autoTPWasEnabledForBat then
        M._autoTPWasEnabledForBat = false
        M.autoTPEnabled = true
        if M.setAutoTPVisual then M.setAutoTPVisual(true) end
        M.startAutoTP()
    end

    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
end

function M.queueAutoBatStart()
    if not M.safeModeTryStart() then return end
    if M.antiKickEnabled and M.brainrotDetected then return end
    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
    M.startBatAimbot()
end

function M.swingCurrentBatAimbot(char)
    if not M.autoSwingEnabled then return end
    local bat = M.findBatForAimbot()
    if bat then
        M._aimbotSwingBat(char or player.Character, bat)
    end
end

-- ============================================================
-- BAT TP (Green Duels V2 style – hard CFrame TP + camera + dual swing loops)
-- ============================================================
M._bypassTarget = nil
M._bypassHRP = nil
M._bypassHum = nil
M.tpBatRange = M.tpBatRange or 1e9 -- unlimited: always nearest enemy
M.tpBatClose = M.tpBatClose or 5 -- Green Duels threshold
M.tpBatOffset = M.tpBatOffset or 0
M.tpBatHitMode = M.tpBatHitMode or "Sure" -- "Sure" | "Normal"
M.tpBatSureHitEnabled = true
M._tpBatLastSwing = 0
M._bypassSwingCooldown = false
M._sureHitCD = false
M._normalHitCD = false
M._bypassRenderConn = nil -- Green-style RenderStepped twin

-- Find / equip any bat tool (exact or name contains "bat")
function M._bypassFindBat()
    local char = player.Character
    if not char then return nil end
    local function isBat(t)
        if not t or not t:IsA("Tool") then return false end
        local n = string.lower(t.Name)
        return n == "bat" or n:find("bat", 1, true) ~= nil
    end
    for _, t in ipairs(char:GetChildren()) do
        if isBat(t) then return t end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if isBat(t) then
                pcall(function() t.Parent = char end)
                return t
            end
        end
    end
    return nil
end

-- Sure Hit — auto-swing multi-fire
function M._bypassTryHitBat()
    if M.tpBatAutoSwing == false and M.autoSwingEnabled == false then return end
    if M._sureHitCD then return end
    M._sureHitCD = true
    pcall(function()
        local bat = M._bypassFindBat()
        if bat then
            for _ = 1, 3 do
                pcall(function() bat:Activate() end)
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then pcall(function() ev:FireServer() end) end
            end
            local rf = bat:FindFirstChildWhichIsA("RemoteFunction")
            if rf then pcall(function() rf:InvokeServer() end) end
        end
    end)
    task.delay(0.045, function() M._sureHitCD = false end)
end

-- Normal Hit — auto-swing multi-fire
function M._bypassTryHitBatNormal()
    if M.tpBatAutoSwing == false and M.autoSwingEnabled == false then return end
    if M._normalHitCD then return end
    M._normalHitCD = true
    pcall(function()
        local bat = M._bypassFindBat()
        if bat then
            for _ = 1, 3 do
                pcall(function() bat:Activate() end)
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then pcall(function() ev:FireServer() end) end
            end
            local rf = bat:FindFirstChildWhichIsA("RemoteFunction")
            if rf then pcall(function() rf:InvokeServer() end) end
        end
    end)
    task.delay(0.045, function() M._normalHitCD = false end)
end

-- Prefer enemy in camera view / where you aim (shiftlock look), then nearest
function M._bypassGetClosest()
    local root = M._bypassHRP or (player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
    if not root then return nil, math.huge end
    local cam = workspace.CurrentCamera
    local closest, bestScore = nil, math.huge
    local bestDist = math.huge
    local camPos = cam and cam.CFrame.Position or root.Position
    local look = cam and cam.CFrame.LookVector or root.CFrame.LookVector
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local cx, cy = vp.X * 0.5, vp.Y * 0.5
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and tHum and tHum.Health > 0 then
                local dist = (root.Position - tRoot.Position).Magnitude
                local score = dist
                if cam then
                    local screen, onScreen = cam:WorldToViewportPoint(tRoot.Position)
                    if onScreen and screen.Z > 0 then
                        local sd = (Vector2.new(screen.X, screen.Y) - Vector2.new(cx, cy)).Magnitude
                        -- Prefer who you are looking at (center of screen)
                        score = sd * 0.85 + dist * 0.25
                    else
                        local toT = (tRoot.Position - camPos)
                        if toT.Magnitude > 0.1 then
                            local dot = look:Dot(toT.Unit)
                            if dot > 0.15 then
                                score = dist * (1.6 - math.clamp(dot, 0, 1))
                            else
                                score = dist * 3.5 -- behind camera = low priority
                            end
                        end
                    end
                end
                if score < bestScore then
                    bestScore = score
                    bestDist = dist
                    closest = plr
                end
            end
        end
    end
    return closest, bestDist
end

-- Flat look from camera (shiftlock-aware) for placement
function M._bypassCamLookFlat()
    local cam = workspace.CurrentCamera
    local root = M._bypassHRP
    local look
    if cam then
        look = cam.CFrame.LookVector
    elseif root then
        look = root.CFrame.LookVector
    else
        look = Vector3.new(0, 0, -1)
    end
    look = Vector3.new(look.X, 0, look.Z)
    if look.Magnitude < 0.05 then
        look = Vector3.new(0, 0, -1)
    else
        look = look.Unit
    end
    return look
end

-- Smooth body face + place near target along camera direction (does NOT lock camera)
function M._bypassSmoothToTarget(tr)
    local hrp = M._bypassHRP
    if not hrp or not tr then return end
    local look = M._bypassCamLookFlat()
    local tVel = tr.AssemblyLinearVelocity or Vector3.zero
    -- light prediction
    local pred = tr.Position + Vector3.new(tVel.X, 0, tVel.Z) * 0.08
    -- stand slightly in front of target relative to where YOU are looking
    local standDist = 2.0
    local standPos = pred - look * standDist + Vector3.new(0, 0.55, 0)
    local faceAt = Vector3.new(pred.X, standPos.Y, pred.Z)
    local goal = CFrame.lookAt(standPos, faceAt)
    -- smooth lerp (more success, less jitter)
    local alpha = 0.62
    hrp.CFrame = hrp.CFrame:Lerp(goal, alpha)
    -- kill sideways drift
    local v = hrp.AssemblyLinearVelocity
    hrp.AssemblyLinearVelocity = Vector3.new(v.X * 0.35, v.Y, v.Z * 0.35)
end


-- ============================================================
-- ANTI-BYPASS GODMODE (immune while bypass aimbot is on)
-- ============================================================
function M._bypassClearGodConns()
    for _, key in ipairs({"_bypassGodConn", "_bypassGodHealthConn", "_bypassGodDiedConn", "_bypassGodCharConn", "_bypassGodStateConn"}) do
        local c = M[key]
        if c then pcall(function() c:Disconnect() end); M[key] = nil end
    end
end

function M._bypassProtectCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum.BreakJointsOnDeath = false
        hum.RequiresNeck = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum.PlatformStand = false
        hum.Sit = false
    end)
    if M._bypassGodHealthConn then pcall(function() M._bypassGodHealthConn:Disconnect() end) end
    M._bypassGodHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not M.bypassAimbotEnabled then return end
        pcall(function()
            if hum.Health < (hum.MaxHealth or 100) or hum.Health <= 0 then
                hum.Health = hum.MaxHealth or 100
                hum.PlatformStand = false
                hum.Sit = false
            end
        end)
    end)
    if M._bypassGodDiedConn then pcall(function() M._bypassGodDiedConn:Disconnect() end) end
    M._bypassGodDiedConn = hum.Died:Connect(function()
        if not M.bypassAimbotEnabled then return end
        -- NO insta reset — only try to stay alive client-side
        pcall(function()
            hum.BreakJointsOnDeath = false
            hum.Health = hum.MaxHealth or 100
            hum.PlatformStand = false
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.Running)
            task.defer(function()
                if not M.bypassAimbotEnabled then return end
                pcall(function()
                    hum.Health = hum.MaxHealth or 100
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end)
        end)
    end)
    pcall(function()
        if M._bypassGodStateConn then pcall(function() M._bypassGodStateConn:Disconnect() end) end
        M._bypassGodStateConn = hum.StateChanged:Connect(function(_, new)
            if not M.bypassAimbotEnabled then return end
            if new == Enum.HumanoidStateType.Dead
                or new == Enum.HumanoidStateType.Ragdoll
                or new == Enum.HumanoidStateType.FallingDown
                or new == Enum.HumanoidStateType.Physics then
                pcall(function()
                    hum.Health = hum.MaxHealth or 100
                    hum.PlatformStand = false
                    hum.Sit = false
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end)
    end)
end

-- ============================================================
-- ANTI DIE
-- ============================================================
function M._adClearConns()
    for _, key in ipairs({"_antiDieConn", "antiDieConn", "_antiDieCharConn", "_antiDieHealthConn", "_antiDieDiedConn", "_antiDieRenderConn", "_antiDieStateConn"}) do
        local c = M[key]
        if c then pcall(function() c:Disconnect() end); M[key] = nil end
    end
end

function M._adProtectCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum.BreakJointsOnDeath = false
        hum.RequiresNeck = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)
    if M._antiDieHealthConn then pcall(function() M._antiDieHealthConn:Disconnect() end) end
    M._antiDieHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not M.antiDieEnabled then return end
        pcall(function()
            if hum.Health < hum.MaxHealth or hum.Health <= 0 then
                hum.Health = math.huge
                hum.MaxHealth = math.huge
                hum.PlatformStand = false
                hum.Sit = false
            end
        end)
    end)
    if M._antiDieDiedConn then pcall(function() M._antiDieDiedConn:Disconnect() end) end
    M._antiDieDiedConn = hum.Died:Connect(function()
        if not M.antiDieEnabled then return end
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum.BreakJointsOnDeath = false
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum.PlatformStand = false
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.Running)
            task.defer(function()
                if not M.antiDieEnabled then return end
                pcall(function()
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end)
        end)
    end)
    if M._antiDieStateConn then pcall(function() M._antiDieStateConn:Disconnect() end) end
    M._antiDieStateConn = hum.StateChanged:Connect(function(_, new)
        if not M.antiDieEnabled then return end
        if new == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum.Health = math.huge
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
    end)
end

function M.startAntiDie()
    M._adClearConns()
    M.antiDieEnabled = true
    local function forceAlive(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        pcall(function()
            hum.BreakJointsOnDeath = false
            hum.RequiresNeck = false
            if hum.MaxHealth < 100 then hum.MaxHealth = 100 end
            if hum.Health < hum.MaxHealth or hum.Health <= 0 then
                hum.Health = hum.MaxHealth
            end
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Dead
                or st == Enum.HumanoidStateType.FallingDown
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.Physics
                or hum.Health <= 0 then
                hum.Health = hum.MaxHealth
                hum.PlatformStand = false
                hum.Sit = false
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
            -- never call any reset remote from anti-die
            if hrp and not M.dropActive and not M.bypassAimbotEnabled then
                local v = hrp.AssemblyLinearVelocity
                local maxMove = math.max(tonumber(M.NS) or 60, tonumber(M.CS) or 30, tonumber(M.LAGGER_CARRY_SPEED) or 25, 80) * 2.5
                if v ~= v then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                elseif v.Magnitude > math.max(maxMove, 500) then
                    hrp.AssemblyLinearVelocity = v.Unit * math.min(v.Magnitude, maxMove)
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end)
    end
    if player.Character then
        M._adProtectCharacter(player.Character)
        forceAlive(player.Character)
    end
    M._antiDieCharConn = player.CharacterAdded:Connect(function(c)
        if not M.antiDieEnabled then return end
        task.wait(0.05)
        M._adProtectCharacter(c)
        forceAlive(c)
        -- Explicitly: do NOT call cursedInstaReset on new character / death
        local hum = c:FindFirstChildOfClass("Humanoid") or c:WaitForChild("Humanoid", 3)
        if hum then
            pcall(function()
                hum.BreakJointsOnDeath = false
                hum.Died:Connect(function()
                    -- stay alive attempt only — no reset
                    pcall(function()
                        hum.Health = hum.MaxHealth or 100
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end)
                end)
            end)
        end
    end)
    M.antiDieConn = RunService.Heartbeat:Connect(function()
        if not M.antiDieEnabled then return end
        forceAlive(player.Character)
    end)
    if M._antiDieRenderConn then pcall(function() M._antiDieRenderConn:Disconnect() end) end
    M._antiDieRenderConn = RunService.RenderStepped:Connect(function()
        if not M.antiDieEnabled then return end
        forceAlive(player.Character)
    end)
end

function M.stopAntiDie()
    M.antiDieEnabled = false
M.antiDieManualEnabled = false
    M._adClearConns()
    if M._antiDieRenderConn then
        pcall(function() M._antiDieRenderConn:Disconnect() end)
        M._antiDieRenderConn = nil
    end
end

-- ============================================================
-- ANTI FLING / GLITCH DIE (global — not only aimbot)
-- Caps insane physics that often cause random death
-- ============================================================
M.antiFlingEnabled = true -- always default ON (stops fling deaths)
M.antiFlingMaxSpeed = M.antiFlingMaxSpeed or 120
M.antiFlingMaxY = M.antiFlingMaxY or 70
M.antiFlingMaxAng = M.antiFlingMaxAng or 25
M._antiFlingConn = nil

function M.startAntiFling()
    if M._antiFlingConn then
        pcall(function() M._antiFlingConn:Disconnect() end)
        M._antiFlingConn = nil
    end
    M.antiFlingEnabled = true
    M._antiFlingConn = RunService.Heartbeat:Connect(function()
        if not M.antiFlingEnabled then return end
        if M.bypassAimbotEnabled or M.dropActive then return end
        if M.dropActive then return end -- let drop fling work
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root then return end

        local cfgMax = math.max(tonumber(M.NS) or 60, tonumber(M.CS) or 30, tonumber(M.LAGGER_CARRY_SPEED) or 25)
        local maxSpd = math.max(tonumber(M.antiFlingMaxSpeed) or 140, cfgMax * 2.2, 200)
        local maxY = math.max(tonumber(M.antiFlingMaxY) or 90, 120)
        local maxAng = tonumber(M.antiFlingMaxAng) or 40

        pcall(function()
            local v = root.AssemblyLinearVelocity
            local bad = false
            if v.Magnitude > maxSpd or math.abs(v.Y) > maxY then
                root.AssemblyLinearVelocity = Vector3.new(
                    math.clamp(v.X, -maxSpd, maxSpd),
                    math.clamp(v.Y, -maxY, maxY),
                    math.clamp(v.Z, -maxSpd, maxSpd)
                )
                bad = true
            end
            local ang = root.AssemblyAngularVelocity
            if ang.Magnitude > maxAng then
                root.AssemblyAngularVelocity = Vector3.zero
                bad = true
            end
            -- Nan / inf guards (rare but lethal)
            if v ~= v or ang ~= ang then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                bad = true
            end
            if hum then
                if bad then
                    hum.PlatformStand = false
                    hum.Sit = false
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                end
                local st = hum:GetState()
                if st == Enum.HumanoidStateType.Flying
                    or st == Enum.HumanoidStateType.Ragdoll
                    or st == Enum.HumanoidStateType.FallingDown
                    or st == Enum.HumanoidStateType.Physics then
                    if bad or v.Magnitude > maxSpd * 0.7 then
                        pcall(function()
                            hum:ChangeState(Enum.HumanoidStateType.Running)
                            hum.PlatformStand = false
                            hum.Sit = false
                        end)
                    end
                end
            end
        end)
    end)
end

function M.stopAntiFling()
    M.antiFlingEnabled = false
    if M._antiFlingConn then
        pcall(function() M._antiFlingConn:Disconnect() end)
        M._antiFlingConn = nil
    end
end



-- Keep Anti Die active while TP Bat (bypass) OR Auto Bat aimbot is on
function M.syncCombatAntiDie()
    local need = (M.antiDieManualEnabled == true)
        or (M.bypassAimbotEnabled == true)
        or (M.autoBatEnabled == true)
    if need then
        M.antiDieEnabled = true
        if not M.antiDieConn then
            pcall(function() M.startAntiDie() end)
        end
        -- refresh protection on current char
        pcall(function()
            if player.Character then M._adProtectCharacter(player.Character) end
        end)
    else
        -- only stop when neither combat aim mode is active
        pcall(function() M.stopAntiDie() end)
    end
end

function M.enableBypassGodmode()
    M.antiDieEnabled = true
    pcall(function() if not M.antiDieConn then M.startAntiDie() end end)
    M._bypassClearGodConns()
    local char = player.Character
    if char then M._bypassProtectCharacter(char) end
    M._bypassGodCharConn = player.CharacterAdded:Connect(function(c)
        if not M.bypassAimbotEnabled then return end
        task.wait(0.05)
        M._bypassProtectCharacter(c)
    end)
    -- ANTI-DIE while TP lock ON: every Heartbeat (no throttle) so you cannot die
    M._bypassGodConn = RunService.Heartbeat:Connect(function()
        if not M.bypassAimbotEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        pcall(function()
            hum.BreakJointsOnDeath = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum.MaxHealth = math.huge
            if hum.Health < hum.MaxHealth or hum.Health <= 0 then
                hum.Health = math.huge
            end
            hum.PlatformStand = false
            hum.Sit = false
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Dead
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown
                or st == Enum.HumanoidStateType.Physics then
                hum.Health = hum.MaxHealth
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            -- void / fling safety while locked
            if root then
                local p = root.Position
                if p.Y < -40 or p ~= p or math.abs(p.X) > 1e5 or math.abs(p.Z) > 1e5 then
                    root.CFrame = CFrame.new(p.X, 30, p.Z)
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    hum.Health = hum.MaxHealth
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end)
    end)
end

function M.disableBypassGodmode()
    M._bypassClearGodConns()
end

function M.startBypassAimbot()
    if not M.safeModeTryStart() then return end
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end
    if M._bypassRenderConn then
        pcall(function() M._bypassRenderConn:Disconnect() end)
        M._bypassRenderConn = nil
    end

    -- Mutual exclusive: TP Bat / Bypass OFFS ping lagger
    pcall(function()
        if M.pingActive and M.setPingActive then M.setPingActive(false, true) end
        M.pingActive = false
        M.pingLoopRunning = false
    end)
    -- Force auto-swing ON for TP Bat
    M.autoSwingEnabled = true
    M.tpBatAutoSwing = true

    -- Stop left/right & pause auto TP
    if M.autoLeftEnabled then
        M.autoLeftEnabled = false
        if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
        M.stopAutoLeft()
    end
    if M.autoRightEnabled then
        M.autoRightEnabled = false
        if M.autoRightSetVisual then M.autoRightSetVisual(false) end
        M.stopAutoRight()
    end

    M._autoTPWasEnabledForBypass = false
    if M.autoTPEnabled then
        M._autoTPWasEnabledForBypass = true
        M.stopAutoTP()
        if M.setAutoTPVisual then M.setAutoTPVisual(false) end
    end

    M.bypassAimbotEnabled = true
    M.enableBypassGodmode()
    -- force global anti-die ON while TP lock / aimbot is active
    M.antiDieEnabled = true
    pcall(function()
        if not M.antiDieConn then M.startAntiDie() end
    end)
    pcall(function() M.syncCombatAntiDie() end)
    M._bypassTarget = nil
    M._bypassSwingCooldown = false
    M._tpBatLastSwing = 0
    M._sureHitCD = false
    M._normalHitCD = false

    local char0 = player.Character
    if char0 then
        M._bypassHRP = char0:FindFirstChild("HumanoidRootPart")
        M._bypassHum = char0:FindFirstChildOfClass("Humanoid")
        if M._bypassHum then
            M.bypassPrevAutoRotate = M._bypassHum.AutoRotate
            M._bypassHum.AutoRotate = false
        end
    end

    local hitMode = (M.tpBatHitMode == "Normal") and "Normal" or "Sure"

    if hitMode == "Sure" then
        -- SURE HIT — camera/shiftlock aware (does NOT hard-lock camera)
        M.bypassAimbotConn = RunService.Heartbeat:Connect(function()
            if not M.bypassAimbotEnabled then return end
            local char = player.Character
            if not char then return end
            M._bypassHum = char:FindFirstChildOfClass("Humanoid")
            M._bypassHRP = char:FindFirstChild("HumanoidRootPart")
            if not M._bypassHum or not M._bypassHRP then return end

            local target = select(1, M._bypassGetClosest())
            if not (target and target.Character) then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end
            M._bypassTarget = tr

            if sethiddenproperty then
                pcall(function()
                    sethiddenproperty(M._bypassHRP, "PhysicsRepRootPart", tr)
                end)
            end

            -- Smooth place relative to YOUR look direction (shiftlock rotate works)
            M._bypassSmoothToTarget(tr)
            M._bypassTryHitBat()
        end)
        -- RenderStepped twin for smoother body follow + hit rate
        M._bypassRenderConn = RunService.RenderStepped:Connect(function()
            if not M.bypassAimbotEnabled then return end
            if not M._bypassHRP then return end
            local target = select(1, M._bypassGetClosest())
            if not (target and target.Character) then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end
            M._bypassSmoothToTarget(tr)
            M._bypassTryHitBat()
        end)
    else
        -- NORMAL HIT — same camera-aware placement
        M.bypassAimbotConn = RunService.Heartbeat:Connect(function()
            if not M.bypassAimbotEnabled then return end
            local char = player.Character
            if not char then return end
            M._bypassHum = char:FindFirstChildOfClass("Humanoid")
            M._bypassHRP = char:FindFirstChild("HumanoidRootPart")
            if not M._bypassHum or not M._bypassHRP then return end

            local target = select(1, M._bypassGetClosest())
            if not (target and target.Character) then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end
            M._bypassTarget = tr

            if sethiddenproperty then
                pcall(function()
                    sethiddenproperty(M._bypassHRP, "PhysicsRepRootPart", tr)
                end)
            end

            M._bypassSmoothToTarget(tr)
            M._bypassTryHitBatNormal()
        end)

        M._bypassRenderConn = RunService.RenderStepped:Connect(function()
            if not M.bypassAimbotEnabled then return end
            if not M._bypassHRP then return end
            local target = select(1, M._bypassGetClosest())
            if not (target and target.Character) then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end
            M._bypassSmoothToTarget(tr)
            M._bypassTryHitBatNormal()
        end)
    end

    if M.setBypassVisual then M.setBypassVisual(true) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(true) end
end

function M.stopBypassAimbot()
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end
    if M._bypassRenderConn then
        pcall(function() M._bypassRenderConn:Disconnect() end)
        M._bypassRenderConn = nil
    end
    pcall(function() RunService:UnbindFromRenderStep("ZeyHubbBypassRotCam") end)
    M._bypassLookPos = nil

    M.bypassAimbotEnabled = false
    M.disableBypassGodmode()
    pcall(function() M.syncCombatAntiDie() end)
    M._bypassTarget = nil
    M._bypassSwingCooldown = false
    M.bypassHitCD = false
    M._sureHitCD = false
    M._normalHitCD = false
    M._bypassHRP = nil
    M._bypassHum = nil

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (M.bypassPrevAutoRotate == nil) and true or M.bypassPrevAutoRotate
    end

    if M._autoTPWasEnabledForBypass then
        M._autoTPWasEnabledForBypass = false
        M.autoTPEnabled = true
        if M.setAutoTPVisual then M.setAutoTPVisual(true) end
        M.startAutoTP()
    end

    if M.setBypassVisual then M.setBypassVisual(false) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(false) end
end

function M.toggleBypassAimbot()
    M.bypassAimbotEnabled = not M.bypassAimbotEnabled
    if M.bypassAimbotEnabled then
        M.startBypassAimbot()
    else
        M.stopBypassAimbot()
    end
    if M.setBypassVisual then
        M.setBypassVisual(M.bypassAimbotEnabled)
    end
    if M.mobBtnRefs.bypass then
        M.mobBtnRefs.bypass(M.bypassAimbotEnabled)
    end
    saveCherryConfig()
    return M.bypassAimbotEnabled
end

-- ============================================================
-- REST OF CORE FUNCTIONS
-- ============================================================
function M.doAutoTPDown(force)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if not hum2 then return end
    -- auto-TP loop only checks height/air; manual TP Down (force) always works — no cooldown
    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= (tonumber(M.autoTPHeight) or 20)) then return end
    end
    local yaw = select(2, hrp.CFrame:ToEulerAnglesYXZ())
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    pcall(function() hrp.Velocity = Vector3.zero end)
    pcall(function() hrp.RotVelocity = Vector3.zero end)
end

function M.startAutoTP()
    if M.autoTPConn then task.cancel(M.autoTPConn);M.autoTPConn=nil end
    M.autoTPConn=task.spawn(function() while M.autoTPEnabled do task.wait(0.1);pcall(function() M.doAutoTPDown(false) end) end end)
end

function M.stopAutoTP() M.autoTPEnabled=false;if M.autoTPConn then task.cancel(M.autoTPConn);M.autoTPConn=nil end end

function M.runTPFloor()
    -- instant TP down, no cooldown / no debounce
    pcall(function() M.doAutoTPDown(true) end)
end

function M.enableStretchRez()
    M.stretchRezEnabled = true

    -- Stop the normal FOV loop while Wide View is active, otherwise it
    -- immediately overwrites the Wide View camera setting.
    if M.fovConn then
        pcall(function() M.fovConn:Disconnect() end)
        M.fovConn = nil
    end

    local cam = workspace.CurrentCamera
    if cam then
        pcall(function()
            cam.FieldOfView = math.clamp(tonumber(M.wideViewFOV) or 100, 70, 120)
        end)
    end
    -- Keep the FH2ONTOP / speed overhead display at its normal size.
    if M.headIndicator and M.headIndicator.bb then
        pcall(function()
            M.headIndicator.bb.Size = UDim2.new(0, 180, 0, 58)
        end)
    end
    if M.headIndicator and M.headIndicator.discord then
        pcall(function()
            M.headIndicator.discord.TextSize = 11
            M.headIndicator.discord.TextScaled = false
        end)
    end
    if M.headIndicator and M.headIndicator.speed then
        pcall(function()
            M.headIndicator.speed.TextSize = 18
            M.headIndicator.speed.TextScaled = false
        end)
    end
    -- Wide View: visual stretch only.
    -- Do not multiply Camera.CFrame or force a large FOV: that can make
    -- world-space interaction/steal prompts appear abnormally large.
    pcall(function()
        RunService:UnbindFromRenderStep("Movee_Stretch")
        RunService:BindToRenderStep("Movee_Stretch", Enum.RenderPriority.Last.Value - 1, function()
            local cam = workspace.CurrentCamera
            if not cam then return end
            cam.FieldOfView = math.clamp(tonumber(M.wideViewFOV) or 100, 70, 120)
        end)
    end)
end

function M.disableStretchRez()
    M.stretchRezEnabled = false
    if M.stretchRezConn then pcall(function() M.stretchRezConn:Disconnect() end); M.stretchRezConn = nil end
    pcall(function() RunService:UnbindFromRenderStep("Movee_Stretch") end)

    -- Give the normal FOV controller back its ownership.
    if not M.fovConn then
        pcall(function() M.applyFOV() end)
    end

    if not M._fovLockedByUser and workspace.CurrentCamera then
        pcall(function()
            workspace.CurrentCamera.FieldOfView = tonumber(M.fovValue) or 80
        end)
    end
    -- Restore the normal FH2ONTOP / speed display size after Wide View.
    if M.headIndicator and M.headIndicator.bb then
        pcall(function()
            M.headIndicator.bb.Size = UDim2.new(0, 180, 0, 58)
        end)
    end
    if M.headIndicator and M.headIndicator.discord then
        pcall(function()
            M.headIndicator.discord.TextSize = 11
            M.headIndicator.discord.TextScaled = false
        end)
    end
    if M.headIndicator and M.headIndicator.speed then
        pcall(function()
            M.headIndicator.speed.TextSize = 18
            M.headIndicator.speed.TextScaled = false
        end)
    end
end

M.wideViewFOV = 100

--------------------------------------------------------------------------------
-- ANTI SUMMER BASE (ONLY remove blocking Anchor parts — never wipe bases)
--------------------------------------------------------------------------------
function M.isSummerBaseName(name)
    if not name then return false end
    local n = tostring(name):lower()
    -- strict: only explicit summer base names (not beach/palm/prop — those kill enemy bases)
    return n == "summerbase"
        or n == "summer_base"
        or n:find("summerbase", 1, true) ~= nil
        or n:find("summer_base", 1, true) ~= nil
end

function M.isAnchorName(name)
    if not name then return false end
    local n = tostring(name):lower()
    return n == "anchor" or n == "anchors"
end

function M.stripBlockingAnchor(obj)
    if not obj or not obj.Parent then return end
    local key = tostring(obj:GetFullName())
    if M._antiSummerCleaned[key] then return end
    M._antiSummerCleaned[key] = true
    pcall(function()
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.CanCollide = false
            obj.CanQuery = false
            obj.CanTouch = false
            obj.Transparency = 1
        end
        obj:Destroy()
    end)
end

function M.cleanSummerBaseAnchors()
    if not M.antiSummerBaseEnabled then return end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end

    -- Only scan Plots (not whole workspace — was causing lag + wiping bases)
    for _, plot in ipairs(plots:GetChildren()) do
        local isSummer = M.isSummerBaseName(plot.Name)
        if not isSummer then
            for _, d in ipairs(plot:GetDescendants()) do
                if M.isSummerBaseName(d.Name) then
                    isSummer = true
                    break
                end
            end
        end
        if not isSummer then continue end
        -- ONLY strip objects literally named Anchor / Anchors
        for _, d in ipairs(plot:GetDescendants()) do
            if M.isAnchorName(d.Name) then
                M.stripBlockingAnchor(d)
            end
        end
    end
end


-- ============================================================
-- HARD HIT (range ring like VOID.CC)
-- ============================================================
M._hardHitRing = nil
M._hardHitConn = nil

function M.hideHardHitRing()
    if M._hardHitRing then
        pcall(function() M._hardHitRing:Destroy() end)
        M._hardHitRing = nil
    end
end

function M.showHardHitRing()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if M._hardHitRing and M._hardHitRing.Parent then return end
    local cyl = Instance.new("CylinderHandleAdornment")
    cyl.Name = "ZeyHubbHardHitRing"
    cyl.Adornee = hrp
    cyl.Color3 = Color3.fromRGB(0, 0, 0)
    cyl.AlwaysOnTop = true
    cyl.ZIndex = 5
    cyl.Transparency = 0.1
    local r = tonumber(M.hardHitRadius) or 10
    cyl.Radius = r
    cyl.InnerRadius = math.max(0.1, r - 0.35)
    cyl.Height = 0.15
    cyl.CFrame = CFrame.new(0, -3, 0)
    cyl.Parent = hrp
    M._hardHitRing = cyl
end

function M.startHardHit()
    M.hardHitEnabled = true
    if M._hardHitConn then return end
    M._hardHitConn = RunService.Heartbeat:Connect(function()
        if not M.hardHitEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if not M._hardHitRing or not M._hardHitRing.Parent then
            M.showHardHitRing()
        end
        if M._hardHitRing then
            local r = tonumber(M.hardHitRadius) or 10
            M._hardHitRing.Radius = r
            M._hardHitRing.InnerRadius = math.max(0.1, r - 0.35)
            if M._hardHitRing.Adornee ~= root then
                M._hardHitRing.Adornee = root
                M._hardHitRing.Parent = root
            end
        end
    end)
    M.showHardHitRing()
end

function M.stopHardHit()
    M.hardHitEnabled = false
    if M._hardHitConn then
        pcall(function() M._hardHitConn:Disconnect() end)
        M._hardHitConn = nil
    end
    M.hideHardHitRing()
end

function M.enableAntiSummerBase()
    M.antiSummerBaseEnabled = true
    M._antiSummerCleaned = {}
    M.cleanSummerBaseAnchors()
    if M.antiSummerBaseConn then
        pcall(function() M.antiSummerBaseConn:Disconnect() end)
        M.antiSummerBaseConn = nil
    end
    M.antiSummerBaseConn = workspace.DescendantAdded:Connect(function(obj)
        if not M.antiSummerBaseEnabled then return end
        if not M.isAnchorName(obj.Name) then return end
        task.defer(function()
            if not M.antiSummerBaseEnabled or not obj.Parent then return end
            -- only if under Plots and near a summer-named container
            local p = obj
            local underPlots, nearSummer = false, false
            while p and p ~= workspace do
                if p.Name == "Plots" or (p.Parent and p.Parent.Name == "Plots") then underPlots = true end
                if M.isSummerBaseName(p.Name) then nearSummer = true end
                p = p.Parent
            end
            if underPlots and nearSummer then
                M.stripBlockingAnchor(obj)
            end
        end)
    end)
    task.spawn(function()
        while M.antiSummerBaseEnabled do
            M.cleanSummerBaseAnchors()
            task.wait(5) -- slower scan = less lag
        end
    end)
end

function M.disableAntiSummerBase()
    M.antiSummerBaseEnabled = false
    if M.antiSummerBaseConn then
        pcall(function() M.antiSummerBaseConn:Disconnect() end)
        M.antiSummerBaseConn = nil
    end
end

function M._isUnderPlots(obj)
    local p = obj
    while p and p ~= workspace do
        if p.Name == "Plots" then return true end
        p = p.Parent
    end
    return false
end

function M.applyAntiLagDerender(obj)
    if not obj then return end
    -- NEVER touch enemy/player bases (Plots) — was making them transparent
    if M._isUnderPlots(obj) then return end
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            -- only strip accessories on characters, not map models
            local char = obj:FindFirstAncestorOfClass("Model")
            if char and Players:GetPlayerFromCharacter(char) then
                obj:Destroy()
            end
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
            -- light optim only — do NOT force Transparency / wipe textures
            obj.CastShadow = false
            if obj.Reflectance and obj.Reflectance > 0 then
                obj.Reflectance = 0
            end
        end
        -- Decals/Textures on map intentionally left alone so bases stay visible
    end)
end

function M.enableAntiLag()
    M.removeAccessoriesEnabled = true
    M.antiLagEnabled = true
    M.defLightBrightness = M.defLightBrightness or Lighting.Brightness
    M.defLightClock = M.defLightClock or Lighting.ClockTime
    M.defLightAmbient = M.defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end
    -- Only process characters + effects, skip Plots entirely
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            for _, obj in ipairs(plr.Character:GetDescendants()) do
                M.applyAntiLagDerender(obj)
            end
        end
    end
    if M.antiLagDescConn then M.antiLagDescConn:Disconnect() end
    M.antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if not M.antiLagEnabled then return end
        if M._isUnderPlots(obj) then return end
        M.applyAntiLagDerender(obj)
    end)
end

function M.disableAntiLag()
    M.removeAccessoriesEnabled=false;M.antiLagEnabled=false;if M.antiLagDescConn then M.antiLagDescConn:Disconnect();M.antiLagDescConn=nil end
    pcall(function() if M.defLightBrightness then Lighting.Brightness=M.defLightBrightness end;if M.defLightClock then Lighting.ClockTime=M.defLightClock end;if M.defLightAmbient then Lighting.OutdoorAmbient=M.defLightAmbient end;Lighting.ExposureCompensation=0 end)
end

-- ============================================================
-- ANTI-RAGDOLL
-- ============================================================
M.antiRagdollNoSplatterCooldown = 0

function M.forceNoSplatterReset()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
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

        local PM = player.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local CM = require(PM:FindFirstChild("ControlModule"))
            if CM then CM:Enable() end
        end

        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

function M.startAntiRagdoll()
    if M.Conns.antiRag then return end
    M.Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not M.antiRagdollEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 then return end

        local state = hum:GetState()
        local ragdolled = (state == Enum.HumanoidStateType.Physics or
                          state == Enum.HumanoidStateType.Ragdoll or
                          state == Enum.HumanoidStateType.FallingDown)

        if M.antiRagdollMode == "No Splatter" then
            if ragdolled then
                local now = tick()
                if now - (M.antiRagdollNoSplatterCooldown or 0) > 0.15 then
                    M.antiRagdollNoSplatterCooldown = now
                    M.forceNoSplatterReset()
                end
            end
            return
        end

        if not root then return end
        local endTime = player:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            ragdolled = true
        end
        if ragdolled then
            pcall(function()
                player:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
            end)
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or
                   (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    d:Destroy()
                end
            end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then
                    obj.Enabled = true
                end
            end
            if hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

function M.stopAntiRagdoll()
    if M.Conns.antiRag then
        M.Conns.antiRag:Disconnect()
        M.Conns.antiRag = nil
    end
end

-- ============================================================
-- INFINITE JUMP (BodyVelocity, anti-TPBack / anti-kick safe)
-- ============================================================
M.jumpHeld = false
M.infJumpThread = nil
M._infJumpBoosting = false
M._infJumpLastBoost = 0
M.INF_JUMP_BOOST_FORCE = 25
M.INF_JUMP_BOOST_FRAMES = 2
M.INF_JUMP_BOOST_COOLDOWN = 0.12

local function M_applyInfJumpBoost(root)
    if not root or M._infJumpBoosting then return end
    local now = tick()
    if now - M._infJumpLastBoost < M.INF_JUMP_BOOST_COOLDOWN then return end
    M._infJumpLastBoost = now
    M._infJumpBoosting = true

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.P = 1250
    bv.Velocity = Vector3.new(root.Velocity.X, M.INF_JUMP_BOOST_FORCE, root.Velocity.Z)
    bv.Parent = root

    local frameCount = 0
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if frameCount < M.INF_JUMP_BOOST_FRAMES then
            frameCount = frameCount + 1
            if bv and bv.Parent then
                bv.Velocity = bv.Velocity + Vector3.new(0, 0.01, 0)
            end
        else
            if bv then pcall(function() bv:Destroy() end) end
            if conn then conn:Disconnect() end
            M._infJumpBoosting = false
        end
    end)
end

task.spawn(function()
    local pg = player:WaitForChild("PlayerGui", 10)
    if pg then
        local function hookJumpButton(btn)
            if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("InfJumpHooked") then
                btn:SetAttribute("InfJumpHooked", true)
                btn.MouseButton1Down:Connect(function()
                    if M.infJumpEnabled then
                        M.jumpHeld = true
                    end
                end)
                btn.MouseButton1Up:Connect(function() M.jumpHeld = false end)
                btn.MouseLeave:Connect(function() M.jumpHeld = false end)
            end
        end
        for _, d in ipairs(pg:GetDescendants()) do hookJumpButton(d) end
        pg.DescendantAdded:Connect(hookJumpButton)
    end
end)

UIS.JumpRequest:Connect(function()
    if M.infJumpEnabled and M.infJumpMode == "manual" then
        M.jumpHeld = true
        task.delay(0.08, function() M.jumpHeld = false end)
    end
end)

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if M.infJumpEnabled
        and inp.UserInputType == Enum.UserInputType.Keyboard
        and inp.KeyCode == Enum.KeyCode.Space then
        M.jumpHeld = true
    end
end)

UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        M.jumpHeld = false
    end
end)

function M.startManualInfJumpLoop()
    if M.infJumpThread then M.infJumpThread:Disconnect() end
    M.infJumpThread = RunService.Heartbeat:Connect(function()
        if not M.infJumpEnabled or M.infJumpMode ~= "manual" then return end
        if not M.jumpHeld then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        M_applyInfJumpBoost(root)
    end)
end

function M.stopManualInfJumpLoop()
    if M.infJumpThread then
        M.infJumpThread:Disconnect()
        M.infJumpThread = nil
    end
    M.jumpHeld = false
    M._infJumpBoosting = false
end

function M.startHoldInfJump()
    if M.holdInfJumpConn then M.holdInfJumpConn:Disconnect() end
    M.holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not M.infJumpEnabled or M.infJumpMode ~= "hold" then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        -- Hold logic from original ZeyHubb: continuous Velocity boost while Space/Jump held
        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or M.jumpHeld or (hum.Jump == true)
        local vel = root.AssemblyLinearVelocity
        if isJumpHeld and vel.Y < 35 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, 55, vel.Z)
        end
        -- Cap fall speed
        vel = root.AssemblyLinearVelocity
        if vel.Y < -120 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, -120, vel.Z)
        end
    end)
end

function M.stopHoldInfJump()
    if M.holdInfJumpConn then
        M.holdInfJumpConn:Disconnect()
        M.holdInfJumpConn = nil
    end
end

-- ============================================================
function M.startUnwalk()
    local c=player.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then M.unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end

function M.stopUnwalk() local c=player.Character;if c and M.unwalkSavedAnimate then M.unwalkSavedAnimate:Clone().Parent=c;M.unwalkSavedAnimate=nil end end

-- Bugra-style instant reset: lock cam + TP far away to force respawn
M._instaResetTP = CFrame.new(2000.5, 9911.9, 4000.2)
M._isInstaResetting = false

function M.cursedInstaReset()
    -- removed
    return
end

function M.hasBrainrotInHand()
    local char = player.Character
    if not char then return false end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local name = item.Name:lower()
            if name:find("brainrot", 1, true) or name:find("skibidi", 1, true) or name:find("toilet", 1, true) then
                return true
            end
        end
    end
    return false
end

function M.forceLaggerCarryWhileHolding()
    -- Disabled: normal mode keeps manual carry; lagger/bypass auto-switch via getActiveMoveSpeed
    return false
end

function M.toggleCarryMode()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveCherryConfig()
        return
    end
    M.carrySpeedActive = not M.carrySpeedActive
    -- mutual exclusive: carry mode OFFS lagger carry (and vice versa handled in toggleLaggerCarry)
    if M.carrySpeedActive then
        M.laggerCarryActive = false
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    saveCherryConfig()
end

function M.cycleLaggerModeBind()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveCherryConfig()
        return
    end
    if not M.laggerCarryActive and not M.laggerModeEnabled then
        M.laggerCarryActive = true
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
    elseif M.laggerCarryActive then
        M.laggerCarryActive = false
        M.laggerModeEnabled = true
    else
        M.laggerModeEnabled = false
        M.laggerCarryActive = true
        M.carrySpeedActive = false
    end

    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
    saveCherryConfig()
end
M.toggleLaggerCarryMode = M.toggleLaggerCarry

function M.stopAutoLeft()
    M.autoLeftEnabled = false
    if M.alConn then M.alConn:Disconnect(); M.alConn = nil end
    M.alPhase = 1
    local char = player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h:Move(Vector3.zero, false) end
    end
    if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
end

function M.stopAutoRight()
    M.autoRightEnabled = false
    if M.arConn then M.arConn:Disconnect(); M.arConn = nil end
    M.arPhase = 1
    local char = player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h:Move(Vector3.zero, false) end
    end
    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
end

-- Original fixed-path Auto Left / Right (as before)
function M.startAutoLeft()
    if M.alConn then M.alConn:Disconnect() end
    M.alPhase = 1
    M.autoLeftEnabled = true
    M.alConn = RunService.Heartbeat:Connect(function()
        if not M.autoLeftEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local spd = (M.getAutoPathSpeed and M.getAutoPathSpeed()) or (M.NS or 60)
        if M.alPhase == 1 then
            local tgt = Vector3.new(M.AP_L1.X, hrp.Position.Y, M.AP_L1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                M.alPhase = 2
                local d = M.AP_L2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z)
                if mv.Magnitude > 0.01 then mv = mv.Unit end
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = M.AP_L1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif M.alPhase == 2 then
            local tgt = Vector3.new(M.AP_L2.X, hrp.Position.Y, M.AP_L2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                M.autoLeftEnabled = false
                if M.alConn then M.alConn:Disconnect(); M.alConn = nil end
                M.alPhase = 1
                if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                return
            end
            local d = M.AP_L2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
        if M.autoMoveSwingEnabled and not M._alSwingDebounce then
            M._alSwingDebounce = true
            local bat = M.findBat and M.findBat() or (M.findBatForAimbot and M.findBatForAimbot())
            if bat then
                if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(M.autoMoveSwingInterval or 0.3, function() M._alSwingDebounce = false end)
        end
    end)
end

function M.startAutoRight()
    if M.arConn then M.arConn:Disconnect() end
    M.arPhase = 1
    M.autoRightEnabled = true
    M.arConn = RunService.Heartbeat:Connect(function()
        if not M.autoRightEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local spd = (M.getAutoPathSpeed and M.getAutoPathSpeed()) or (M.NS or 60)
        if M.arPhase == 1 then
            local tgt = Vector3.new(M.AP_R1.X, hrp.Position.Y, M.AP_R1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                M.arPhase = 2
                local d = M.AP_R2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z)
                if mv.Magnitude > 0.01 then mv = mv.Unit end
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = M.AP_R1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif M.arPhase == 2 then
            local tgt = Vector3.new(M.AP_R2.X, hrp.Position.Y, M.AP_R2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                M.autoRightEnabled = false
                if M.arConn then M.arConn:Disconnect(); M.arConn = nil end
                M.arPhase = 1
                if M.autoRightSetVisual then M.autoRightSetVisual(false) end
                if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                return
            end
            local d = M.AP_R2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
        if M.autoMoveSwingEnabled and not M._arSwingDebounce then
            M._arSwingDebounce = true
            local bat = M.findBat and M.findBat() or (M.findBatForAimbot and M.findBatForAimbot())
            if bat then
                if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(M.autoMoveSwingInterval or 0.3, function() M._arSwingDebounce = false end)
        end
    end)
end

function M.enableAntiKick()
    M.antiKickEnabled = true
    task.spawn(function()
        while M.antiKickEnabled do
            task.wait(0.5)
            local char = player.Character
            if char then
                local found = false
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        local n = tool.Name:lower()
                        if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
                            found = true
                            break
                        end
                    end
                end
                M.brainrotDetected = found
                if found then
                    if M.autoBatEnabled then M.stopBatAimbot() end
                    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
                    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
                end
            end
        end
    end)
end

function M.disableAntiKick()
    M.antiKickEnabled = false
    M.brainrotDetected = false
end

--------------------------------------------------------------------------------
-- SAFE MODE (locks combat during duel countdown / while holding brainrot)
--------------------------------------------------------------------------------
function M.safeModeGetCountdownLabel()
    local ok, label = pcall(function()
        local pg = player:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local top = pg:FindFirstChild("DuelsMachineTopFrame")
        if not top then return nil end
        local inner = top:FindFirstChild("DuelsMachineTopFrame")
        if not inner then return nil end
        local timer = inner:FindFirstChild("Timer")
        if not timer then return nil end
        return timer:FindFirstChild("Label")
    end)
    return (ok and label) or nil
end

function M.safeModeCountdownNumber(text)
    local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if t == "GO" or t == "START" or t == "READY" then return true end
    local n = tonumber(t)
    return n ~= nil and n >= 0 and n <= 10
end

function M.safeModeInDuelCountdown()
    local label = M.safeModeGetCountdownLabel()
    return label and M.safeModeCountdownNumber(label.Text) or false
end

M.SAFE_MODE_BLOCKED_TOOLS = {
    bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true,
    medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true,
}

function M.safeModeIsCarryableTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    for word in pairs(M.SAFE_MODE_BLOCKED_TOOLS) do
        if name:find(word, 1, true) then return false end
    end
    return true
end

function M.safeModeHoldingBrainrot()
    local ok, val = pcall(function() return player:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return player:GetAttribute("AntiKick") end)
    if ok2 and val2 == true then return true end
    local char = player.Character
    if not char then return false end
    local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok3 and val3 == true then return true end
    if M.brainrotDetected then return true end
    if M.hasBrainrotInHand and M.hasBrainrotInHand() then return true end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
                return true
            end
        end
    end
    return false
end

function M.safeModeIsLocked()
    if not M.safeModeEnabled then return false end
    return M.safeModeInDuelCountdown() or M.safeModeHoldingBrainrot()
end

function M.safeModeForceStop(reason)
    local stopped = false
    if M.autoBatEnabled then
        M.stopBatAimbot()
        stopped = true
    end
    if M.bypassAimbotEnabled then
        M.stopBypassAimbot()
        stopped = true
    end
    if M.autoLeftEnabled then
        M.autoLeftEnabled = false
        if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
        M.stopAutoLeft()
        stopped = true
    end
    if M.autoRightEnabled then
        M.autoRightEnabled = false
        if M.autoRightSetVisual then M.autoRightSetVisual(false) end
        M.stopAutoRight()
        stopped = true
    end
    if stopped then
        -- optional toast; silent if no notifier
        pcall(function()
            if type(showActionNotification) == "function" then
                showActionNotification(reason or "SAFE MODE LOCK")
            end
        end)
    end
end

function M.safeModeTryStart()
    if M.safeModeIsLocked() then
        M.safeModeForceStop("SAFE MODE LOCK")
        return false
    end
    return true
end

function M.enableSafeMode()
    M.safeModeEnabled = true
end

function M.disableSafeMode()
    M.safeModeEnabled = false
end

if not M._safeModeMonitorStarted then
    M._safeModeMonitorStarted = true
    RunService.Heartbeat:Connect(function()
        if M.safeModeEnabled and M.safeModeIsLocked() then
            M.safeModeForceStop("SAFE MODE LOCK")
        end
    end)
end


function M.isStealState()
    -- Match auto-switch carry script: WalkSpeed drops while carrying / stealing
    local char = player.Character
    if not char then return false end
    if M.hasBrainrotInHand() then return true end
    local h = char:FindFirstChildOfClass("Humanoid")
    if h and h.WalkSpeed < 25 then return true end
    local ok, val = pcall(function() return player:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and val2 == true then return true end
    return false
end

function M.getActiveMoveSpeed()
    if M.laggerCarryActive then
        return tonumber(M.LAGGER_CARRY_SPEED) or 25
    end
    if M.laggerModeEnabled then
        return tonumber(M.LAGGER_SPEED) or 40
    end
    if M.carrySpeedActive then
        return tonumber(M.CS) or 30
    end
    return tonumber(M.NS) or 60
end

function M.getAutoPathSpeed()
    return tonumber(M.NS) or 60
end

function M.setModeNormalFlags()
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.setModeCarryFlags()
    M.carrySpeedActive = true
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(true) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.setModeLaggerCarryFlags()
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = true
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.stopWalkSpeedAutoSwitch()
    if M._autoSwitchSpeedConn then
        pcall(function() M._autoSwitchSpeedConn:Disconnect() end)
        M._autoSwitchSpeedConn = nil
    end
end

function M.startWalkSpeedAutoSwitch()
    if M._autoSwitchSpeedConn then return end
    M._autoSwitchSpeedConn = RunService.Heartbeat:Connect(function()
        if not M.autoSwitchSpeedEnabled then
            M.stopWalkSpeedAutoSwitch()
            return
        end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local ws = hum.WalkSpeed or 16
        local thr = tonumber(M.AUTO_SWITCH_THRESHOLD) or 25

        -- Auto Carry Speed only
        if M.autoSwitchSpeedEnabled and ws <= thr and not M.carrySpeedActive and not M.laggerCarryActive then
            M.setModeCarryFlags()
        end
    end)
end


function M.isNearEnemyBase(range)
    range = tonumber(range) or M.autoCarryEnemyBaseRange or 35
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local myPos = hrp.Position
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyPlot(plot.Name) then
            local pos
            local ok, pivot = pcall(function() return plot:GetPivot().Position end)
            if ok and pivot then pos = pivot
            else
                local sign = plot:FindFirstChild("PlotSign")
                if sign and sign:IsA("BasePart") then pos = sign.Position
                elseif sign then
                    local pp = sign:FindFirstChildWhichIsA("BasePart", true)
                    if pp then pos = pp.Position end
                end
            end
            if pos then
                local flat = Vector3.new(myPos.X - pos.X, 0, myPos.Z - pos.Z)
                if flat.Magnitude <= range then return true end
            end
        end
    end
    return false
end
function M.enableCarryModeOnly()
    if M.carrySpeedActive then return end
    M.carrySpeedActive = true
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
    if M.mobBtnRefs.carrySpeed then pcall(function() M.mobBtnRefs.carrySpeed(true) end) end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end
function M.startAutoCarryEnemyBase()
    if M._autoCarryEnemyBaseConn then return end
    local acc = 0
    M._autoCarryEnemyBaseConn = RunService.Heartbeat:Connect(function(dt)
        if not M.autoCarryEnemyBaseEnabled then return end
        acc = acc + (dt or 0.016)
        if acc < 0.2 then return end
        acc = 0
        if M.carrySpeedActive then return end
        if M.isNearEnemyBase(M.autoCarryEnemyBaseRange) then M.enableCarryModeOnly() end
    end)
end
function M.stopAutoCarryEnemyBase()
    if M._autoCarryEnemyBaseConn then pcall(function() M._autoCarryEnemyBaseConn:Disconnect() end); M._autoCarryEnemyBaseConn = nil end
end
function M.setAutoCarryEnemyBase(on)
    M.autoCarryEnemyBaseEnabled = on and true or false
    if M.autoCarryEnemyBaseEnabled then M.startAutoCarryEnemyBase() else M.stopAutoCarryEnemyBase() end
    if M.setAutoCarryEnemyBaseVisual then pcall(function() M.setAutoCarryEnemyBaseVisual(M.autoCarryEnemyBaseEnabled) end) end
end
function M.refreshWalkSpeedAutoSwitch()
    if M.autoSwitchSpeedEnabled then
        M.startWalkSpeedAutoSwitch()
    else
        M.stopWalkSpeedAutoSwitch()
    end
end

function M.updateAutoSwitchSpeed()
    -- Steal-based auto carry (existing)
    if M.autoSwitchSpeedEnabled then
        local isSteal = M.isStealState()
        if isSteal ~= M._autoSwitchWasSteal then
            M._autoSwitchWasSteal = isSteal
            local inLagger = M.laggerModeEnabled or M.laggerCarryActive
            if isSteal then
                if inLagger then
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
                else
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(true) end
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
                end
            else
                if inLagger then
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
                    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
                    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
                else
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
                    if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
                end
            end
            if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
        end
    end
end

function M.isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end

-- Drop Brainrot (Xray.Vs style — ascend then snap to ground)
M.lastDropTime = M.lastDropTime or 0
M.dropConnections = M.dropConnections or {}

function M.stopDropBrainrot()
    M.dropActive = false
    if M._dropConn then
        pcall(function() M._dropConn:Disconnect() end)
        M._dropConn = nil
    end
    for _, t in ipairs(M.dropConnections or {}) do
        if type(t) == "thread" then
            pcall(task.cancel, t)
        elseif typeof(t) == "RBXScriptConnection" then
            pcall(function() t:Disconnect() end)
        end
    end
    M.dropConnections = {}
    local c = player.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

function M.runDrop()
    if M.dropActive then return end
    -- anti accidental: short global debounce
    local now = tick()
    if M._lastDropInvoke and (now - M._lastDropInvoke) < 0.12 then return end
    M._lastDropInvoke = now
    if M.bypassAimbotEnabled then return end
    pcall(function() M.stopAutoTPForAction() end)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    M.dropActive = true
    local startTime = tick()
    local dropConn
    dropConn = RunService.Heartbeat:Connect(function()
        local currentChar = player.Character
        local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        if not currentChar or not currentRoot then
            if dropConn then pcall(function() dropConn:Disconnect() end) end
            M.dropActive = false
            return
        end
        if tick() - startTime >= (tonumber(M.DROP_ASCEND_DURATION) or 0.2) then
            if dropConn then pcall(function() dropConn:Disconnect() end) end
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {currentChar}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
            if rayResult then
                local hum = currentChar:FindFirstChildOfClass("Humanoid")
                local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
                currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
                    * CFrame.Angles(0, select(2, currentRoot.CFrame:ToEulerAnglesYXZ()), 0)
                currentRoot.AssemblyLinearVelocity = Vector3.zero
                currentRoot.AssemblyAngularVelocity = Vector3.zero
            end
            M.dropActive = false
            return
        end
        -- Xray.Vs: push upward during ascend window
        local v = currentRoot.AssemblyLinearVelocity
        local up = tonumber(M.DROP_ASCEND_SPEED) or 150
        pcall(function()
            currentRoot.AssemblyLinearVelocity = Vector3.new(v.X, up, v.Z)
            currentRoot.Velocity = Vector3.new(v.X, up, v.Z)
        end)
    end)
    task.delay(1.0, function()
        if M.dropActive then
            M.dropActive = false
            if dropConn then pcall(function() dropConn:Disconnect() end) end
        end
    end)
end

M.runDropBrainrot = M.runDrop

function M.executeDropWithToggle(setVisual)
    if M.dropActive then return end
    task.spawn(function()
        local resumeSteal = M.Steal.AutoStealEnabled == true
        if setVisual then pcall(setVisual, true) end
        if resumeSteal then
            pcall(M.stopAutoSteal)
            task.wait(0.05)
        end
        M.runDrop()
        while M.dropActive do task.wait() end
        task.wait(0.08)
        if resumeSteal and M.Steal.AutoStealEnabled then
            task.defer(function() pcall(M.startAutoSteal) end)
        end
        if setVisual then pcall(setVisual, false) end
    end)
end

function M.stopAutoTPForAction()
    if M.autoTPEnabled then
        M.stopAutoTP()
        pcall(function() if M.setAutoTPVisual then M.setAutoTPVisual(false) end end)
        pcall(function() if M.saveConfig then M.saveConfig() end end)
    end
end


local function setupDeathReset()
    -- Insta reset on death completely removed
    if M._deathResetConn then
        pcall(function() M._deathResetConn:Disconnect() end)
        M._deathResetConn = nil
    end
    M.autoResetOnDeath = false
end

function M.startRemoveAcc()
    if M.removeAccEnabled then return end
    M.removeAccEnabled = true
    local function removeAccDo()
        if not M.removeAccEnabled then return end
        local char = player.Character
        if not char then return end
        for _,obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") then
                if not M.removedAccessories[obj] then
                    M.removedAccessories[obj] = true
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
    removeAccDo()
    M.removeAccConn = player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if M.removeAccEnabled then removeAccDo() end
    end)
end

function M.stopRemoveAcc()
    M.removeAccEnabled = false
    if M.removeAccConn then
        M.removeAccConn:Disconnect()
        M.removeAccConn = nil
    end
    M.removedAccessories = {}
end

-- ============================================================
-- MOBILE BUTTONS (trascinabili singolarmente)
-- ============================================================
function M.destroyMobileButtons()
    if M.mobGuiRef then
        pcall(function() M.mobGuiRef:Destroy() end)
        M.mobGuiRef = nil
    end
    for _,n in ipairs({"MoveeMobileButtons"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(n); if old then old:Destroy() end
        local pgui = player:FindFirstChild("PlayerGui"); if pgui then local o = pgui:FindFirstChild(n); if o then o:Destroy() end end
    end
    M.mobBtnRefs = {}
    M.mobBtnFrames = {}
end

function M.loadBtnPositions()
    local out = {}
    -- Primary: dedicated positions file
    if isfile and isfile(M.MOB_POS_FILE) then
        local ok, data = pcall(function() return HS:JSONDecode(readfile(M.MOB_POS_FILE)) end)
        if ok and type(data) == "table" then
            for k, v in pairs(data) do
                if type(v) == "table" then
                    out[k] = v
                end
            end
        end
    end
    -- Backup: CherryConfig.btnPos
    if M._btnPosCache and type(M._btnPosCache) == "table" then
        for k, v in pairs(M._btnPosCache) do
            if not out[k] and type(v) == "table" and type(v.x) == "number" and type(v.y) == "number" then
                out[k] = {x = v.x, y = v.y}
            end
        end
    end
    return out
end

function M.saveBtnPositions()
    if not M.mobGuiRef or not M.mobGuiRef.Parent then return end
    local out = {}
    -- Prefer explicit frame map (Green Duels stack)
    if M.mobBtnFrames then
        for key, child in pairs(M.mobBtnFrames) do
            if child and child.Parent then
                out[key] = {
                    x = child.AbsolutePosition.X,
                    y = child.AbsolutePosition.Y,
                    sx = child.Position.X.Scale,
                    sy = child.Position.Y.Scale,
                    ox = child.Position.X.Offset,
                    oy = child.Position.Y.Offset,
                }
            end
        end
    end
    for _, child in ipairs(M.mobGuiRef:GetChildren()) do
        local key = child:GetAttribute("BtnKey")
        if key and not out[key] then
            out[key] = {
                x = child.AbsolutePosition.X,
                y = child.AbsolutePosition.Y,
                sx = child.Position.X.Scale,
                sy = child.Position.Y.Scale,
                ox = child.Position.X.Offset,
                oy = child.Position.Y.Offset,
            }
        end
    end
    M._btnPosCache = out
    if writefile then
        pcall(function() writefile(M.MOB_POS_FILE, HS:JSONEncode(out)) end)
    end
    -- Also persist via main config when available
    pcall(function()
        if saveCherryConfig then saveCherryConfig() end
    end)
end

function M.resetMobilePositions()
    -- Clear saved positions (os.remove often missing in executors)
    pcall(function()
        if type(delfile) == "function" then
            delfile(M.MOB_POS_FILE)
        elseif type(writefile) == "function" then
            writefile(M.MOB_POS_FILE, "{}")
        end
    end)
    pcall(function()
        if isfile and isfile(M.MOB_POS_FILE) and type(writefile) == "function" then
            writefile(M.MOB_POS_FILE, "{}")
        end
    end)
    M._forceDefaultMobPos = true
    M.buildMobileButtons()
    M._forceDefaultMobPos = false
    -- Snap any leftover to defaults again after build
    pcall(function()
        if not M.mobGuiRef then return end
        local out = {}
        for _, child in ipairs(M.mobGuiRef:GetDescendants()) do
            if child:IsA("TextButton") and child:GetAttribute("BtnKey") then
                local key = child:GetAttribute("BtnKey")
                local dx = child:GetAttribute("DefaultX")
                local dy = child:GetAttribute("DefaultY")
                if typeof(dx) == "number" and typeof(dy) == "number" then
                    child.Position = UDim2.new(0, dx, 0, dy)
                    out[key] = {x = dx, y = dy}
                end
            end
        end
        if writefile then
            writefile(M.MOB_POS_FILE, HS:JSONEncode(out))
        end
    end)
end


-- Apply chosen UI colour + bg image tint to live mobile buttons
function M.refreshMobileButtonTheme()
    if not M.mobGuiRef or not M.mobGuiRef.Parent then return end
    local accent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(220, 40, 40)
    local dim = UI_ACCENT_DIM or accent:Lerp(Color3.new(0,0,0), 0.4)
    local offTop = M.themeDarkFromAccent(accent, 0.28)
    local offBot = M.themeDarkFromAccent(accent, 0.10)
    for _, child in ipairs(M.mobGuiRef:GetDescendants()) do
        if child:IsA("ImageLabel") and child.Name == "BtnBgImage" then
            child.ImageColor3 = Color3.fromRGB(255, 255, 255) -- no red tint on bg image
            child.ImageTransparency = 0
        end
        if child:IsA("UIStroke") and (child.Name == "BtnStroke" or child.Parent and child.Parent:IsA("TextButton")) then
            local btn = child.Parent
            local on = btn and btn:GetAttribute("MB_On") == true
            if on then
                child.Color = accent
                child.Transparency = 0
                child.Thickness = 2
            else
                -- OFF: no outline at all.
                child.Color = accent
                child.Transparency = 1
                child.Thickness = 2
            end
        end
        if child:IsA("UIGradient") and child.Name == "BtnGrad" then
            local btn = child.Parent
            local on = btn and btn:GetAttribute("MB_On") == true
            if on then
                child.Color = ColorSequence.new(accent:Lerp(Color3.new(1,1,1), 0.35), accent)
            else
                child.Color = ColorSequence.new(offTop, offBot)
            end
        end
        if child:IsA("UIGradient") and child.Parent and child.Parent.Name:find("MobCont_", 1, true) then
            child.Color = ColorSequence.new(offTop, offBot)
        end
        if child:IsA("UIStroke") and child.Parent and child.Parent.Name:find("MobCont_", 1, true) then
            child.Color = dim
        end
    end
    -- Re-apply setOn visuals for each known ref
    for key, setOn in pairs(M.mobBtnRefs or {}) do
        if type(setOn) == "function" then
            -- preserve current on state via attribute if possible
            pcall(function()
                local cont = M.mobGuiRef:FindFirstChild("MobCont_" .. key)
                local btn = cont and cont:FindFirstChild("Btn_" .. key)
                if btn then
                    setOn(btn:GetAttribute("MB_On") == true)
                end
            end)
        end
    end
end

function M.buildMobileButtons()
    M.destroyMobileButtons()
    if not M.mobileButtonsEnabled then return end

    local LAYOUT_VER = 2
    if M._mobLayoutVer ~= LAYOUT_VER then
        M._mobLayoutVer = LAYOUT_VER
        M._forceDefaultMobPos = true
        pcall(function()
            if type(writefile) == "function" then writefile(M.MOB_POS_FILE, "{}") end
        end)
    end

    local savedPositions = M._forceDefaultMobPos and {} or (M.loadBtnPositions and M.loadBtnPositions() or {})

    -- 2-column grid:
    -- Auto left | Auto right
    -- TP bat    | Bat aimbot
    -- Drop      | TP down
    -- Lagger    | Carry
    local BTN_W, BTN_H, BTN_GAP, COLS = 58, 58, 8, 2
    local scale = math.max(0.7, math.min(1.4, (tonumber(M.mobileButtonsSize) or 100) / 100))
    BTN_W = math.floor(58 * scale)
    BTN_H = math.floor(58 * scale)
    BTN_GAP = math.floor(8 * scale)

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "MoveeMobileButtons"
    mobGui.ResetOnSpawn = false
    mobGui.DisplayOrder = 100
    mobGui.IgnoreGuiInset = true
    mobGui.Enabled = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if not pcall(function() mobGui.Parent = game:GetService("CoreGui") end) then
        mobGui.Parent = player:WaitForChild("PlayerGui")
    end
    M.mobGuiRef = mobGui
    M.mobBtnRefs = M.mobBtnRefs or {}
    M.mobBtnFrames = {}

    -- ZeyHubb colours: off = black/white, on = red/white
    local accent = UI_ACCENT or Color3.fromRGB(220, 40, 40)
    local C = {
        stackBg = Color3.fromRGB(0, 0, 0),
        stackBrd = Color3.fromRGB(40, 40, 40),
        stackTxt = Color3.fromRGB(255, 255, 255),
        stackActBg = accent,
        stackActBrd = accent,
        stackActTxt = Color3.fromRGB(255, 255, 255),
    }

    -- User layout (2 columns)
    local stackDefs = {
        {key = "autoLeft",    label = "AUTO\nLEFT",     toggle = true},
        {key = "autoRight",   label = "AUTO\nRIGHT",    toggle = true},
        {key = "bypass",      label = "TP\nBAT",        toggle = true},
        {key = "autoBat",     label = "BAT\nAIMBOT",    toggle = true},
        {key = "drop",        label = "DROP",           toggle = false},
        {key = "tpDown",      label = "TP\nDOWN",       toggle = false},
        {key = "lagger",      label = "LAGGER",         toggle = true},
        {key = "carrySpeed",  label = "CARRY",          toggle = true},
    }

    local function getDefaultStackPos(i)
        local col = (i - 1) % COLS
        local row = math.floor((i - 1) / COLS)
        local totalRows = math.ceil(#stackDefs / COLS)
        return UDim2.new(
            1, -(COLS * (BTN_W + BTN_GAP) - BTN_GAP + 14) + col * (BTN_W + BTN_GAP),
            0.5, -(totalRows * (BTN_H + BTN_GAP) - BTN_GAP) / 2 + row * (BTN_H + BTN_GAP)
        )
    end

    for i, def in ipairs(stackDefs) do
        local key = def.key
        local btnFrame = Instance.new("TextButton")
        btnFrame.Name = "StackBtn_" .. key
        btnFrame.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        local saved = savedPositions and savedPositions[key]
        if saved and type(saved.sx) == "number" then
            btnFrame.Position = UDim2.new(saved.sx, saved.ox or 0, saved.sy or 0, saved.oy or 0)
        elseif saved and type(saved.x) == "number" and type(saved.y) == "number" then
            btnFrame.Position = UDim2.new(0, saved.x, 0, saved.y)
        else
            btnFrame.Position = getDefaultStackPos(i)
        end
        btnFrame.BackgroundColor3 = C.stackBg
        btnFrame.BorderSizePixel = 0
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Name = "ZeyHubbFrameOutline"
    frameStroke.Color = Color3.fromRGB(220, 40, 40)
    frameStroke.Thickness = 1.6
    frameStroke.Transparency = 0.18
    frameStroke.Parent = Frame
    local frameInner = Instance.new("UIStroke")
    frameInner.Name = "ZeyHubbFrameInner"
    frameInner.Color = Color3.fromRGB(255, 255, 255)
    frameInner.Thickness = 1
    frameInner.Transparency = 0.92
    frameInner.Parent = Frame
    local topAccent = Instance.new("Frame")
    topAccent.Name = "ZeyHubbTopAccent"
    topAccent.AnchorPoint = Vector2.new(0.5, 0)
    topAccent.Position = UDim2.new(0.5, 0, 0, 1)
    topAccent.Size = UDim2.new(0.72, 0, 0, 2)
    topAccent.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
    topAccent.BorderSizePixel = 0
    topAccent.ZIndex = 50
    topAccent.Parent = Frame
    Instance.new("UICorner", topAccent).CornerRadius = UDim.new(1, 0)
        btnFrame.AutoButtonColor = false
        btnFrame.Text = def.label
        btnFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnFrame.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        btnFrame.TextStrokeTransparency = 0.05
        btnFrame.TextScaled = false
        btnFrame.TextSize = math.max(10, math.floor(12 * scale))
        btnFrame.Font = Enum.Font.GothamBold
        btnFrame.TextWrapped = true
        btnFrame.LineHeight = 1.2
        btnFrame.ZIndex = 15
        btnFrame:SetAttribute("BtnKey", key)
        btnFrame.Parent = mobGui
        local btnCorner = Instance.new("UICorner", btnFrame)
        btnCorner.CornerRadius = M.circleButtonsEnabled and UDim.new(1, 0) or UDim.new(0, 12)
        local bStroke = Instance.new("UIStroke")
        bStroke.Name = "BtnStroke"
        bStroke.Color = Color3.fromRGB(220, 40, 40)
        bStroke.Thickness = 2.5
        bStroke.Transparency = 1 -- OFF by default
        bStroke.Parent = btnFrame

        local function updateMobileButtonOutline()
            local active = false
            if key == "autoLeft" then active = M.autoLeftEnabled
            elseif key == "autoRight" then active = M.autoRightEnabled
            elseif key == "bypass" then active = M.bypassAimbotEnabled
            elseif key == "autoBat" then active = M.autoBatEnabled
            elseif key == "lagger" then active = M.laggerModeEnabled
            elseif key == "carrySpeed" then active = M.carrySpeedActive
            end
            bStroke.Color = Color3.fromRGB(220, 40, 40)
            bStroke.Thickness = 2.5
            bStroke.Transparency = active and 0 or 1
            btnFrame:SetAttribute("MB_On", active == true)
        end

        -- Register a live visual callback. Other parts of the script use
        -- mobBtnRefs to update these buttons, so the red outline must be
        -- refreshed here too (not only after a direct tap).
        M.mobBtnRefs[key] = function(on)
            local active = on == true
            bStroke.Color = Color3.fromRGB(220, 40, 40)
            bStroke.Thickness = 3
            bStroke.Transparency = active and 0 or 1
            btnFrame:SetAttribute("MB_On", active)
        end

        -- Custom mobile button background image
        local mobBgId = tonumber(M.mobBtnBgId) or 0
        local mobImageAsset = M.ZEYHUBB_LOCAL_IMAGE_ASSET
        if mobImageAsset or mobBgId > 0 then
            local bgImg = Instance.new("ImageLabel")
            bgImg.Name = "BtnBgImage"
            bgImg.BackgroundTransparency = 1
            bgImg.Image = mobImageAsset or ("rbxassetid://" .. tostring(mobBgId))
            bgImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
            bgImg.ImageTransparency = 0.22
            -- Keep the eye visible while leaving enough contrast for the button labels.
            bgImg.ScaleType = Enum.ScaleType.Fit
            bgImg.Size = UDim2.fromScale(1, 1)
            bgImg.ZIndex = 14
            bgImg.Active = false
            bgImg.Parent = btnFrame
            local bgCorner = Instance.new("UICorner", bgImg)
            bgCorner.CornerRadius = M.circleButtonsEnabled and UDim.new(1, 0) or UDim.new(0, 12)
            btnFrame.BackgroundTransparency = 1
        end
        -- Mobile button action dispatcher
        local function fireAction()
            if key == "autoLeft" then
                M.autoLeftEnabled = not M.autoLeftEnabled
                if M.autoLeftEnabled then
                    if M.autoRightEnabled then M.stopAutoRight() end
                    M.startAutoLeft()
                else
                    M.stopAutoLeft()
                end

            elseif key == "autoRight" then
                M.autoRightEnabled = not M.autoRightEnabled
                if M.autoRightEnabled then
                    if M.autoLeftEnabled then M.stopAutoLeft() end
                    M.startAutoRight()
                else
                    M.stopAutoRight()
                end

            elseif key == "bypass" then
                -- TP BAT remains available, but the Speed Bypass spam is not.
                M.toggleBypassAimbot()

            elseif key == "autoBat" then
                M.autoBatEnabled = not M.autoBatEnabled
                if M.autoBatEnabled then
                    if M.autoLeftEnabled then M.stopAutoLeft() end
                    if M.autoRightEnabled then M.stopAutoRight() end
                    M.startBatAimbot()
                else
                    M.stopBatAimbot()
                end

            elseif key == "drop" then
                M.executeDropWithToggle()

            elseif key == "tpDown" then
                M.doAutoTPDown(true)

            elseif key == "lagger" then
                M.cycleLaggerModeBind()

            elseif key == "carrySpeed" then
                M.toggleCarryMode()
            end
            -- Update the OUTLINE of these mobile buttons after every tap.
            updateMobileButtonOutline()
        end

        -- Set initial state for this button.
        updateMobileButtonOutline()

        -- Green Duels drag + tap logic
        local dragStartPos, startPos = nil, nil
        local isDragging, movedEnough, wasPressed = false, false, false
        local pressTime = 0

        btnFrame.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            wasPressed = true
            pressTime = tick()
            dragStartPos = input.Position
            startPos = btnFrame.Position
            isDragging = true
            movedEnough = false
        end)
        btnFrame.InputChanged:Connect(function(input)
            if not isDragging or M.mobileButtonsLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStartPos
                if delta.Magnitude > 8 then movedEnough = true end
                if movedEnough then
                    btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end
        end)
        btnFrame.InputEnded:Connect(function(input)
            if not isDragging then return end
            isDragging = false
            if movedEnough then
                if M.saveBtnPositions then pcall(M.saveBtnPositions) end
            elseif wasPressed and not movedEnough then
                -- no time-window cooldown — any short tap fires
                fireAction()
            end
            wasPressed = false
        end)
        btnFrame.MouseButton1Click:Connect(function()
            -- backup click path (no time-window / no cooldown)
            if movedEnough then return end
            if wasPressed then return end -- InputEnded already fired
            fireAction()
        end)
    end

    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
end



-- ============================================================
-- CONFIG SAVE/LOAD
-- ============================================================
local CHERRY_CONFIG_NAME = "CherryConfig.json"
local CherryConfig = { Theme="Red" }
local CHERRY_THEMES = {
    Default  = { Accent=Color3.fromRGB(220,40,40), AccentDim=Color3.fromRGB(160,25,25), Bg=Color3.fromRGB(0,0,0), Row=Color3.fromRGB(14,10,10) },
    Red      = { Accent=Color3.fromRGB(220,25,25), AccentDim=Color3.fromRGB(160,20,20), Bg=Color3.fromRGB(0,0,0), Row=Color3.fromRGB(14,10,10) },
    Purple   = { Accent=Color3.fromRGB(150,40,255), AccentDim=Color3.fromRGB(100,20,180), Bg=Color3.fromRGB(0,0,0), Row=Color3.fromRGB(12,8,16) },
    Blue     = { Accent=Color3.fromRGB(90,160,255),  AccentDim=Color3.fromRGB(60,120,200),  Bg=Color3.fromRGB(6,10,18),   Row=Color3.fromRGB(12,18,30) },
    Yellow   = { Accent=Color3.fromRGB(255,214,0),   AccentDim=Color3.fromRGB(200,170,0),   Bg=Color3.fromRGB(12,12,4),   Row=Color3.fromRGB(20,18,8) },
    Grey     = { Accent=Color3.fromRGB(255, 255, 255), AccentDim=Color3.fromRGB(140,140,150), Bg=Color3.fromRGB(10,10,12),  Row=Color3.fromRGB(18,18,22) },
    Forest   = { Accent=Color3.fromRGB(46,200,120),  AccentDim=Color3.fromRGB(30,140,80),   Bg=Color3.fromRGB(4,12,8),    Row=Color3.fromRGB(10,22,14) },
    Cyan     = { Accent=Color3.fromRGB(0,220,255),   AccentDim=Color3.fromRGB(0,160,190),   Bg=Color3.fromRGB(4,12,16),   Row=Color3.fromRGB(8,20,26) },
    Orange   = { Accent=Color3.fromRGB(255,160,60),  AccentDim=Color3.fromRGB(200,120,40),  Bg=Color3.fromRGB(14,10,6),   Row=Color3.fromRGB(24,16,10) },
}
if M._savedTheme and CHERRY_THEMES[M._savedTheme] then
    CherryConfig.Theme = M._savedTheme
end
M.colorScheme = CherryConfig.Theme
M.bgImageColor = Color3.fromRGB(255, 255, 255) -- no color tint on background image
M.customBgId = 0
M.customBgOpacity = 0.02
M.mobBtnBgId = 0
M.BG_IMAGE_IDS = {
    126860692354524,
    88369503310562,
    80708025126373,
    102253425322931,
    71300527482258,
    98541566010518,
    140420978895712,
    123407376197646,
    90758919051283,
}
M.MOB_BTN_IMAGE_IDS = {
    126860692354524,
    88369503310562,
    80708025126373,
    102253425322931,
    94353803110527,
    109100201685955,
    140420978895712,
    123407376197646,
    90758919051283,
}


local function loadCherryConfig()
    if type(readfile)~="function" or type(isfile)~="function" then return end
    local ok,d = pcall(function()
        if not isfile(CHERRY_CONFIG_NAME) then return nil end
        return HS:JSONDecode(readfile(CHERRY_CONFIG_NAME))
    end)
    if ok and type(d)=="table" then
        local themeName = nil
        if type(d.Theme)=="string" and CHERRY_THEMES[d.Theme] then themeName = d.Theme end
        if themeName == "Pink" then themeName = "Red" end
        if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then themeName = d.colorScheme end
        if themeName then
            CherryConfig.Theme = themeName
            M.colorScheme = themeName
            M._savedTheme = themeName
        end
        if type(d.normalSpeed)=="number" then M.NS=d.normalSpeed end
        if type(d.carrySpeed)=="number" then M.CS=d.carrySpeed end
        if type(d.speedMethod)=="string" then
            for _,sm in ipairs(M.speedMethodList) do if sm==d.speedMethod then M.speedMethod=sm; break end end
        end
        if type(d.grabRadius)=="number" then M.Steal.StealRadius=d.grabRadius end
        if type(d.stealDuration)=="number" then M.Steal.StealDuration=d.stealDuration end
        if type(d.stealStopTime)=="number" then M.Steal.StopTime=d.stealStopTime end
        if type(d.stealMode)=="string" then
            if d.stealMode == "Normal" or d.stealMode == "Semi" or d.stealMode == "V2" then
                M.stealMode=d.stealMode
            end
        end
        if type(d.autoTPHeight)=="number" then M.autoTPHeight=d.autoTPHeight end
        if type(d.fovValue)=="number" then M.fovValue=d.fovValue end
        if type(d.uiScale)=="number" then M.uiScale=d.uiScale end
        if type(d.infJumpMode)=="string" then M.infJumpMode=d.infJumpMode end
        if type(d.mobileButtonsSize)=="number" then M.mobileButtonsSize=d.mobileButtonsSize end
        if type(d.skyTheme)=="string" then M.currentSkyTheme=d.skyTheme end
        if type(d.stealBarSize)=="number" then M.stealBarSize=d.stealBarSize end
        if type(d.stealBarPos)=="table" then
            local p = d.stealBarPos
            if type(p.xScale)=="number" and type(p.xOffset)=="number"
                and type(p.yScale)=="number" and type(p.yOffset)=="number" then
                M._stealBarPos = {
                    xScale = p.xScale, xOffset = p.xOffset,
                    yScale = p.yScale, yOffset = p.yOffset
                }
            end
        end
        if d.carrySpeedActive~=nil then M.carrySpeedActive=d.carrySpeedActive end
        if d.laggerModeEnabled~=nil then M.laggerModeEnabled=d.laggerModeEnabled end
        if d.autoSwing~=nil then M.autoSwingEnabled=d.autoSwing==true end
        if d.introSoundEnabled~=nil then M.introSoundEnabled=d.introSoundEnabled==true end
        if d.introSongChoice then M.introSongChoice=d.introSongChoice end
        if d.introGUIEnabled~=nil then M.introGUIEnabled=d.introGUIEnabled==true end
        if d.ragdollGui~=nil then M.ragdollGuiEnabled=d.ragdollGui==true end
        if d.circleButtonsEnabled~=nil then M.circleButtonsEnabled=d.circleButtonsEnabled==true end
        if d.perButtonDrag~=nil then M.perButtonDragEnabled=d.perButtonDrag==true end
        if d.mobileButtonsEnabled~=nil then M.mobileButtonsEnabled=d.mobileButtonsEnabled end
        M.medusaResetEnabled = false -- feature removed
        if d.autoMoveSwing~=nil then M.autoMoveSwingEnabled=d.autoMoveSwing==true end
        if d.autoSwitchSpeed~=nil then M.autoSwitchSpeedEnabled=d.autoSwitchSpeed==true end
        if d.autoCarryEnemyBase~=nil then M.autoCarryEnemyBaseEnabled=d.autoCarryEnemyBase==true end
        if type(d.autoCarryEnemyBaseRange)=="number" then M.autoCarryEnemyBaseRange=d.autoCarryEnemyBaseRange end
        if d.pingPanelOpen~=nil then M.pingPanelOpen=d.pingPanelOpen==true end
        if type(d.killLaggerNivel)=="string" then M.killLaggerNivel=d.killLaggerNivel end
        if d.killLaggerOpen~=nil then M.killLaggerOpen=d.killLaggerOpen==true end
        if type(d.killLaggerKey)=="string" then M.killLaggerKey=d.killLaggerKey end
        if d.killLaggerLocked~=nil then M.killLaggerLocked=d.killLaggerLocked==true end
        if type(d.pingPower)=="number" then M.pingPower=d.pingPower end
        if type(d.pingInterval)=="number" then M.pingInterval=d.pingInterval end
        if type(d.pingKeybindKb)=="string" then M.pingKeybindKb=d.pingKeybindKb end
        if type(d.pingKeybindGp)=="string" then M.pingKeybindGp=d.pingKeybindGp end
        if d.pingAutoBrainrot~=nil then M.pingAutoBrainrot=d.pingAutoBrainrot==true end
        if type(d.pingBackground)=="number" then M.pingBackground=d.pingBackground end
        if d.pingLocked~=nil then M.pingLocked=d.pingLocked==true end
        if d.pingMinimized~=nil then M.pingMinimized=d.pingMinimized==true end
        if d.bypassPanelOpen~=nil then M.bypassPanelOpen=d.bypassPanelOpen==true end
        if d.bypassAutoBrainrot~=nil then M.bypassAutoBrainrot=d.bypassAutoBrainrot==true end
        if d.bypassBillboardOn~=nil then M.bypassBillboardOn=d.bypassBillboardOn~=false end
        if type(d.bypassKeybind)=="string" then M.bypassKeybind=d.bypassKeybind end
        if type(d.bypassPower)=="number" then M.bypassPower=d.bypassPower end
        if d.mobileButtonsLocked~=nil then M.mobileButtonsLocked=d.mobileButtonsLocked==true end
        if type(d.mobLayoutVer)=="number" then M._mobLayoutVer=d.mobLayoutVer end
        M.autoTurnOffSpeedEnabled=false
        M.autoSwitchLaggerSpeedEnabled=false
        if d.showPlayerSpeeds~=nil then M.showPlayerSpeeds=d.showPlayerSpeeds==true end
        if d.removeAcc~=nil then M.removeAccEnabled=d.removeAcc end
        if d.playerESPEnabled~=nil then M.playerESPEnabled=d.playerESPEnabled end
        if d.antiRagdoll~=nil then M.antiRagdollEnabled=d.antiRagdoll end
        if d.hardHitEnabled~=nil then M.hardHitEnabled=d.hardHitEnabled==true end
        if type(d.hardHitRadius)=="number" then M.hardHitRadius=d.hardHitRadius end
        if type(d.antiRagdollMode)=="string" and (d.antiRagdollMode=="Splatter" or d.antiRagdollMode=="No Splatter") then M.antiRagdollMode=d.antiRagdollMode end
        if d.autoStealEnabled~=nil then M.Steal.AutoStealEnabled=d.autoStealEnabled end
        if d.autoRadiusEnabled~=nil then M.autoRadiusEnabled=d.autoRadiusEnabled==true end

        if d.infiniteJump~=nil then M.infJumpEnabled=d.infiniteJump end
        if d.medusaCounter~=nil then M.medusaCounterEnabled=d.medusaCounter end
        if d.batCounter~=nil then M.batCounterEnabled=d.batCounter end
        if d.unwalkEnabled~=nil then M.unwalkEnabled=d.unwalkEnabled end
        if d.antiLag~=nil then M.antiLagEnabled=d.antiLag end
        if d.antiSummerBase~=nil then M.antiSummerBaseEnabled=d.antiSummerBase end
        M.uiLocked = false
        if d.stretchRez~=nil then M.stretchRezEnabled=d.stretchRez end
        if d.autoTPEnabled~=nil then M.autoTPEnabled=d.autoTPEnabled end
        if d.antiKick~=nil then M.antiKickEnabled=d.antiKick end
        if d.antiDieEnabled~=nil then
            M.antiDieManualEnabled = d.antiDieEnabled == true
            M.antiDieEnabled = M.antiDieManualEnabled
        end
        if d.safeMode~=nil then M.safeModeEnabled=d.safeMode end
        if d.vyncSkin~=nil then M.vyncSkinEnabled=d.vyncSkin==true end
        if type(d.customBgId)=="number" then M.customBgId=d.customBgId end
        if type(d.customBgOpacity)=="number" then M.customBgOpacity=math.clamp(d.customBgOpacity,0,1) end
        if type(d.mobBtnBgId)=="number" then M.mobBtnBgId=d.mobBtnBgId end
        if type(d.btnPos)=="table" then M._btnPosCache=d.btnPos end
        if d.autoBat~=nil then M.autoBatEnabled=d.autoBat end
        if d.semiHoldMin then M.Semi.holdMin=d.semiHoldMin end
        if d.semiHoldMax then M.Semi.holdMax=d.semiHoldMax end
        if d.semiEntryDelay then M.Semi.entryDelay=d.semiEntryDelay end
        if d.semiPrimeRange then M.Semi.primeRange=d.semiPrimeRange end
        if type(d.semiRadius)=="number" then M.Semi.radius=math.min(d.semiRadius, 10) end
        if d.lineESPEnabled~=nil then M.lineESPEnabled=d.lineESPEnabled end
        if d.highlightESPEnabled~=nil then M.highlightESPEnabled=d.highlightESPEnabled==true end
        if d.hitboxESPEnabled~=nil then M.hitboxESPEnabled=d.hitboxESPEnabled==true end
        if d.menuOpen~=nil then M.menuOpen=d.menuOpen~=false end
        -- theme already applied above; keep M._savedTheme in sync
        if type(d.Theme)=="string" and CHERRY_THEMES[d.Theme] then M._savedTheme=d.Theme; M.colorScheme=d.Theme end
        if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then M._savedTheme=d.colorScheme; M.colorScheme=d.colorScheme end
        if d.speedESPEnabled~=nil then M.speedESPEnabled=d.speedESPEnabled end
        M.autoResetOnDeath = false -- feature removed
        if type(d.animPack)=="string" then M.animPack=d.animPack end
        if type(M.animPack) ~= "string" or not M.PACKS[M.animPack] then M.animPack = "Bubbly" end
        if d.headlessEnabled~=nil then M.headlessEnabled=d.headlessEnabled end
        if d.korbloxEnabled~=nil then M.korbloxEnabled=d.korbloxEnabled end
        if d.zeyhubbBlackSkinEnabled~=nil then M.zeyhubbBlackSkinEnabled=d.zeyhubbBlackSkinEnabled==true end
        if d.bypassAimbotEnabled~=nil then M.bypassAimbotEnabled=d.bypassAimbotEnabled end
        if type(d.tpBatHitMode)=="string" then
            local m = tostring(d.tpBatHitMode):lower()
            if m == "normal" or m == "normal hit" then
                M.tpBatHitMode = "Normal"
            else
                M.tpBatHitMode = "Sure"
            end
        end
        if d.animPackEnabled~=nil then M.animPackEnabled=d.animPackEnabled end
        local function lk(e,d2)
            if type(d2)~="table" then return end
            if d2.kb and Enum.KeyCode[d2.kb] then e.kb=Enum.KeyCode[d2.kb] else e.kb=nil end
            if d2.gp and Enum.KeyCode[d2.gp] then e.gp=Enum.KeyCode[d2.gp] else e.gp=nil end
        end
        if d.dropBrainrotKey then lk(M.KB.DropBrainrot,d.dropBrainrotKey) end
        if d.autoLeftKey then lk(M.KB.AutoLeft,d.autoLeftKey) end
        if d.autoRightKey then lk(M.KB.AutoRight,d.autoRightKey) end
        if d.autoBatKey then lk(M.KB.AutoBat,d.autoBatKey) end
        if d.laggerToggleKey then lk(M.KB.LaggerToggle,d.laggerToggleKey) end
        if d.tpFloorKey then lk(M.KB.TPFloor,d.tpFloorKey) end
        if M.KB.InstaReset then M.KB.InstaReset.kb=nil; M.KB.InstaReset.gp=nil else M.KB.InstaReset={kb=nil,gp=nil} end -- removed
        if d.guiHideKey then lk(M.KB.GuiHide,d.guiHideKey) end
        if d.speedToggleKey then lk(M.KB.SpeedToggle,d.speedToggleKey) end
        if d.bypassAimbotKey then lk(M.KB.BypassAimbot,d.bypassAimbotKey) end
        if d.pingLaggerKey then lk(M.KB.PingLagger,d.pingLaggerKey) end
        if d.antiDieKey then lk(M.KB.AntiDie,d.antiDieKey) end
        if M.KB.PingLagger and M.KB.PingLagger.kb then M.pingKeybindKb = M.KB.PingLagger.kb.Name end
        if M.KB.PingLagger and M.KB.PingLagger.gp then M.pingKeybindGp = M.KB.PingLagger.gp.Name end
        -- Dedupe shared keys after load (each keycode only on one bind)
        do
            local seenKb, seenGp = {}, {}
            local order = {
                M.KB.BypassAimbot, M.KB.AutoBat, M.KB.DropBrainrot, M.KB.SpeedToggle,
                M.KB.LaggerToggle, M.KB.AutoLeft, M.KB.AutoRight, M.KB.TPFloor,
                M.KB.PingLagger, M.KB.AntiDie, M.KB.GuiHide, M.KB.InstaReset,
            }
            for _, e in ipairs(order) do
                if type(e) == "table" then
                    if e.kb then
                        if seenKb[e.kb] then e.kb = nil else seenKb[e.kb] = true end
                    end
                    if e.gp then
                        if seenGp[e.gp] then e.gp = nil else seenGp[e.gp] = true end
                    end
                end
            end
        end
    end
end

local function saveCherryConfig()
    if type(writefile)~="function" then return end
    local function ks(e)
        if type(e) ~= "table" then return {kb=nil,gp=nil} end
        return {
            kb = (e.kb and e.kb.Name) or nil,
            gp = (e.gp and e.gp.Name) or nil,
        }
    end
    local cfg = {
        Theme=CherryConfig.Theme, colorScheme=M.colorScheme or CherryConfig.Theme, menuOpen=M.menuOpen~=false,
        normalSpeed=M.NS, carrySpeed=M.CS, laggerSpeed=M.LAGGER_SPEED, laggerCarrySpeed=M.LAGGER_CARRY_SPEED, speedMethod=M.speedMethod, grabRadius=M.Steal.StealRadius,
        stealDuration=M.Steal.StealDuration, stealStopTime=M.Steal.StopTime, stealMode=M.stealMode,
        autoTPHeight=M.autoTPHeight, fovValue=M.fovValue, uiScale=M.uiScale,
        infJumpMode=M.infJumpMode,
        mobileButtonsSize=M.mobileButtonsSize, skyTheme=M.currentSkyTheme,
        customBgId=tonumber(M.customBgId) or 0, customBgOpacity=tonumber(M.customBgOpacity) or 0.35,
        mobBtnBgId=tonumber(M.mobBtnBgId) or 0, btnPos=M._btnPosCache,
        stealBarSize=M.stealBarSize,
        stealBarPos=M._stealBarPos,
        carrySpeedActive=M.carrySpeedActive, laggerModeEnabled=M.laggerModeEnabled, laggerCarryActive=M.laggerCarryActive,
        autoSwing=M.autoSwingEnabled, introSoundEnabled=M.introSoundEnabled,
        introSongChoice=M.introSongChoice,
        introGUIEnabled=M.introGUIEnabled,
        ragdollGui=M.ragdollGuiEnabled, circleButtonsEnabled=M.circleButtonsEnabled,
        perButtonDrag=M.perButtonDragEnabled, mobileButtonsEnabled=M.mobileButtonsEnabled,
        medusaReset=M.medusaResetEnabled, autoMoveSwing=M.autoMoveSwingEnabled,
        autoSwitchSpeed=M.autoSwitchSpeedEnabled, autoTurnOffSpeed=M.autoTurnOffSpeedEnabled, autoSwitchLaggerSpeed=M.autoSwitchLaggerSpeedEnabled, autoCarryEnemyBase=M.autoCarryEnemyBaseEnabled, autoCarryEnemyBaseRange=M.autoCarryEnemyBaseRange, pingPanelOpen=M.pingPanelOpen==true, killLaggerNivel=M.killLaggerNivel or "low", killLaggerOpen=M.killLaggerOpen~=false, killLaggerKey=M.killLaggerKey or "E", killLaggerLocked=M.killLaggerLocked==true, pingPower=M.pingPower, pingInterval=M.pingInterval, pingKeybindKb=(M.KB.PingLagger and M.KB.PingLagger.kb and M.KB.PingLagger.kb.Name) or M.pingKeybindKb, pingKeybindGp=(M.KB.PingLagger and M.KB.PingLagger.gp and M.KB.PingLagger.gp.Name) or M.pingKeybindGp, pingAutoBrainrot=M.pingAutoBrainrot==true, pingBackground=M.pingBackground or 0, pingLocked=M.pingLocked==true, pingMinimized=M.pingMinimized==true, bypassPanelOpen=M.bypassPanelOpen==true, bypassAutoBrainrot=M.bypassAutoBrainrot==true, bypassBillboardOn=M.bypassBillboardOn~=false, bypassKeybind=M.bypassKeybind, bypassPower=M.bypassPower, mobileButtonsLocked=M.mobileButtonsLocked==true, mobLayoutVer=M._mobLayoutVer or 2, showPlayerSpeeds=M.showPlayerSpeeds,
        removeAcc=M.removeAccEnabled,
        playerESPEnabled=M.playerESPEnabled,
        autoStealEnabled=M.Steal.AutoStealEnabled,
        autoRadiusEnabled=M.autoRadiusEnabled,
        antiRagdoll=M.antiRagdollEnabled, hardHitEnabled=M.hardHitEnabled, hardHitRadius=M.hardHitRadius, antiRagdollMode=M.antiRagdollMode, infiniteJump=M.infJumpEnabled,
        medusaCounter=M.medusaCounterEnabled, batCounter=M.batCounterEnabled,
        unwalkEnabled=M.unwalkEnabled, antiLag=M.antiLagEnabled, antiSummerBase=M.antiSummerBaseEnabled, uiLocked=M.uiLocked,
        stretchRez=M.stretchRezEnabled, autoTPEnabled=M.autoTPEnabled,
        antiKick=M.antiKickEnabled, antiDieEnabled=M.antiDieManualEnabled==true, safeMode=M.safeModeEnabled, autoBat=M.autoBatEnabled, vyncSkin=M.vyncSkinEnabled==true,
        semiHoldMin=M.Semi.holdMin, semiHoldMax=M.Semi.holdMax,
        semiEntryDelay=M.Semi.entryDelay,
        semiPrimeRange=M.Semi.primeRange,
        semiRadius=math.min(M.Semi.radius, 10),
        lineESPEnabled=M.lineESPEnabled, highlightESPEnabled=M.highlightESPEnabled,
        hitboxESPEnabled=M.hitboxESPEnabled, speedESPEnabled=M.speedESPEnabled,
        autoResetOnDeath=M.autoResetOnDeath,
        animPack=M.animPack,
        headlessEnabled=M.headlessEnabled,
        korbloxEnabled=M.korbloxEnabled,
        zeyhubbBlackSkinEnabled=M.zeyhubbBlackSkinEnabled~=false,
        bypassAimbotEnabled=M.bypassAimbotEnabled,
        tpBatHitMode=M.tpBatHitMode or "Sure",
        animPackEnabled=M.animPackEnabled,
        dropBrainrotKey=ks(M.KB.DropBrainrot), autoLeftKey=ks(M.KB.AutoLeft),
        autoRightKey=ks(M.KB.AutoRight), autoBatKey=ks(M.KB.AutoBat),
        laggerToggleKey=ks(M.KB.LaggerToggle), tpFloorKey=ks(M.KB.TPFloor),
        instaResetKey=ks(M.KB.InstaReset), guiHideKey=ks(M.KB.GuiHide),
        speedToggleKey=ks(M.KB.SpeedToggle), bypassAimbotKey=ks(M.KB.BypassAimbot),
        pingLaggerKey=ks(M.KB.PingLagger), antiDieKey=ks(M.KB.AntiDie),
    }
    pcall(function() writefile(CHERRY_CONFIG_NAME, HS:JSONEncode(cfg)) end)
end

M.saveConfig = saveCherryConfig

-- ============================================================
-- CHERRY ESP
-- ============================================================
local RunService2 = game:GetService("RunService")
local cherryESPState = { LineESP=(M.lineESPEnabled==true), SpeedESP=(M.speedESPEnabled==true), HighlightESP=(M.highlightESPEnabled==true), HitboxESP=(M.hitboxESPEnabled==true) }
local cherryESPObjects = {}

-- One shared line layer for all players (lighter than one ScreenGui per player).
local cherryLineGui = Instance.new("ScreenGui")
cherryLineGui.Name = "ZeyHubbLineESP"
cherryLineGui.ResetOnSpawn = false
cherryLineGui.IgnoreGuiInset = true
cherryLineGui.DisplayOrder = 999
pcall(function() cherryLineGui.Parent = game:GetService("CoreGui") end)
if not cherryLineGui.Parent then cherryLineGui.Parent = player:WaitForChild("PlayerGui") end

local DrawingAvailable = false
pcall(function() DrawingAvailable = Drawing and type(Drawing.new)=="function" end)

local function cherryRemoveESP(p)
    local r = cherryESPObjects[p]
    if not r then return end
    for _,o in pairs(r) do pcall(function()
        if typeof(o)=="Instance" then o:Destroy()
        elseif o.Remove then o:Remove() end
    end) end
    cherryESPObjects[p]=nil
end

local function cherryGetSpeed(root)
    local v
    pcall(function() v=root.AssemblyLinearVelocity end)
    if not v then pcall(function() v=root.Velocity end) end
    if not v then return 0 end
    return Vector3.new(v.X,0,v.Z).Magnitude
end

local function cherryCreateESP(p)
    if cherryESPObjects[p] then return cherryESPObjects[p] end
    local r={}
    local hl=Instance.new("Highlight")
    hl.Name="ZeyHubbHighlightESP"
    hl.FillTransparency=0.78
    hl.OutlineTransparency=0
    hl.FillColor=Color3.fromRGB(255, 45, 55)
    hl.OutlineColor=Color3.fromRGB(255, 255, 255)
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled=false
    hl.Parent=workspace
    r.Highlight=hl

    -- Visual hitbox only: does not modify gameplay collision.
    local hitbox = Instance.new("BoxHandleAdornment")
    hitbox.Name = "ZeyHubbHitboxESP"
    hitbox.Adornee = nil
    hitbox.AlwaysOnTop = true
    hitbox.ZIndex = 5
    hitbox.Size = Vector3.new(5.0, 7.0, 4.0)
    hitbox.Color3 = Color3.fromRGB(40, 140, 255)
    hitbox.Transparency = 0.45
    hitbox.Visible = false
    hitbox.Parent = workspace
    r.Hitbox = hitbox

    local bb=Instance.new("BillboardGui")
    bb.Size=UDim2.fromOffset(150,32); bb.StudsOffset=Vector3.new(0,3.25,0)
    bb.AlwaysOnTop=true; bb.Enabled=false; bb.ResetOnSpawn=false
    bb.Parent=player:WaitForChild("PlayerGui")
    local sl=Instance.new("TextLabel",bb)
    sl.Size=UDim2.fromScale(1,1); sl.BackgroundTransparency=1; sl.Text="0.0 spd"
    sl.TextColor3=Color3.fromRGB(40, 140, 255); sl.TextStrokeColor3=Color3.new(0,0,0); sl.TextStrokeTransparency=0
    sl.Font=Enum.Font.GothamBlack; sl.TextSize=18
    sl.TextXAlignment=Enum.TextXAlignment.Center; sl.TextYAlignment=Enum.TextYAlignment.Center
    r.Billboard=bb; r.SpeedText=sl
    -- Reuse the shared line layer instead of creating a ScreenGui for every player.
    local ln = Instance.new("Frame")
    ln.Name = "Line"
    ln.AnchorPoint = Vector2.new(0.5, 0.5)
    ln.BackgroundColor3 = Color3.fromRGB(255, 45, 55)
    ln.BackgroundTransparency = 0.05
    ln.BorderSizePixel = 0
    ln.Size = UDim2.fromOffset(0, 2)
    ln.Visible = false
    ln.ZIndex = 999
    ln.Parent = cherryLineGui
    r.Line = ln
    cherryESPObjects[p]=r
    return r
end

Players.PlayerRemoving:Connect(function(p) cherryRemoveESP(p) end)

-- Build dark UI colours from a chosen accent (every "black" becomes that colour family)
local function themeDarkFromAccent(accent, amount)
    return M.themeDarkFromAccent(accent, amount)
end

local function isNearBlack(c, threshold)
    if typeof(c) ~= "Color3" then return false end
    threshold = threshold or 0.14
    return c.R <= threshold and c.G <= threshold and c.B <= threshold
end

local function applyAccentFromTheme()
    local name = "White"
    if not CHERRY_THEMES[name] then
        CHERRY_THEMES[name] = {
            Accent=Color3.fromRGB(255,255,255),
            AccentDim=Color3.fromRGB(210,210,210),
            Bg=Color3.fromRGB(255,255,255),
            Row=Color3.fromRGB(245,245,245)
        }
    end
    CherryConfig.Theme = name
    M.colorScheme = name
    M._savedTheme = name
    local accent = Color3.fromRGB(255,255,255)
    UI_ACCENT = accent
    UI_ACCENT_DIM = Color3.fromRGB(210,210,210)
    UI_BG_DARK = Color3.fromRGB(255,255,255)
    UI_ROW_BG = Color3.fromRGB(245,245,245)
    UI_BTN_BG = Color3.fromRGB(235,235,235)
    UI_TOGGLE_OFF = Color3.fromRGB(205,205,205)
    UI_TEXT_PRIMARY = Color3.fromRGB(0,0,0)
    UI_TEXT_WHITE = Color3.fromRGB(0,0,0)
    UI_TEXT_DIM = Color3.fromRGB(90,90,90)
    UI_TEXT_SECTION = Color3.fromRGB(0,0,0)
    UI_CARD_STROKE = Color3.fromRGB(215,215,215)
end

local CHERRY_ACCENT = CHERRY_THEMES[CherryConfig.Theme].Accent

local _espAccumulator = 0
RunService2.Heartbeat:Connect(function(dt)
    -- ESP is intentionally throttled to keep FPS stable while remaining smooth.
    if type(dt) ~= "number" then dt = 0.05 end
    _espAccumulator = _espAccumulator + dt
    if _espAccumulator < 0.05 then return end -- about 20 updates/sec
    _espAccumulator = 0
    -- only when ESP features on
    if not (cherryESPState.LineESP or cherryESPState.SpeedESP or cherryESPState.HighlightESP or cherryESPState.HitboxESP) then
        -- hide any existing
        for p,r in pairs(cherryESPObjects) do
            if r.Line then r.Line.Visible=false end
            if r.Highlight then r.Highlight.Enabled=false end
            if r.Hitbox then r.Hitbox.Visible=false; r.Hitbox.Adornee=nil end
            if r.Billboard then r.Billboard.Enabled=false end
        end
        return
    end
    local cam=workspace.CurrentCamera; if not cam then return end
    local lc=player.Character
    local lr=lc and lc:FindFirstChild("HumanoidRootPart")
    local lineStart=Vector2.new(cam.ViewportSize.X*0.5, cam.ViewportSize.Y*0.82)
    if lr then
        local rp,rv=cam:WorldToViewportPoint(lr.Position)
        if rv and rp.Z>0 then lineStart=Vector2.new(rp.X,rp.Y) end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p==player then continue end
        local r=cherryCreateESP(p)
        local ch=p.Character
        local hum=ch and ch:FindFirstChildOfClass("Humanoid")
        local root=ch and ch:FindFirstChild("HumanoidRootPart")
        local head=ch and ch:FindFirstChild("Head")
        local alive=ch and hum and root and hum.Health>0
        if not alive then
            if r.Line then r.Line.Visible=false end
            r.Highlight.Enabled=false; r.Billboard.Enabled=false
            if r.Hitbox then r.Hitbox.Visible=false; r.Hitbox.Adornee=nil end
            r.Highlight.Adornee=nil; r.Billboard.Adornee=nil
            continue
        end
        local liveAccent = Color3.fromRGB(255, 45, 55)
        -- Highlight ESP is now independent from Line ESP.
        local showHL = cherryESPState.HighlightESP == true
        r.Highlight.Adornee = ch
        r.Highlight.Enabled = showHL
        r.Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        r.Highlight.FillColor = liveAccent
        r.Highlight.FillTransparency = 0.72
        r.Highlight.OutlineTransparency = 0
        if r.Hitbox then
            r.Hitbox.Adornee = root
            r.Hitbox.Color3 = Color3.fromRGB(40, 140, 255)
            r.Hitbox.Visible = cherryESPState.HitboxESP == true
        end
        if r.Line then
            local tp,tv=cam:WorldToViewportPoint(root.Position)
            if cherryESPState.LineESP and tv and tp.Z>0 then
                local target = Vector2.new(tp.X, tp.Y)
                local delta = target - lineStart
                local length = delta.Magnitude
                if length > 1 then
                    r.Line.Position = UDim2.fromOffset((lineStart.X + target.X) * 0.5, (lineStart.Y + target.Y) * 0.5)
                    r.Line.Size = UDim2.fromOffset(length, 1)
                    r.Line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
                    r.Line.BackgroundColor3 = Color3.fromRGB(40, 140, 255)
                    r.Line.Visible = true
                else
                    r.Line.Visible = false
                end
            else
                r.Line.Visible=false
            end
        end
        if cherryESPState.SpeedESP and head then
            r.Billboard.Adornee=head; r.Billboard.Enabled=true
            r.SpeedText.Text=string.format("%.1f spd",cherryGetSpeed(root))
            r.SpeedText.TextColor3=Color3.fromRGB(40, 140, 255)
        else r.Billboard.Enabled=false; r.Billboard.Adornee=nil end
    end
end)

function M.trackConn(conn) table.insert(M._persistentConns,conn); return conn end
function M.clearPersistentConns()
    for _,c in ipairs(M._persistentConns) do pcall(function() c:Disconnect() end) end
    M._persistentConns={}
end

function M.makeNumberCallback(tbl,key,min,max)
    return function(v)
        if min and v<min then return end
        if max and v>max then return end
        tbl[key]=v
        if key=="mobileButtonsSize" and M.mobileButtonsEnabled then M.buildMobileButtons() end
        if key=="stealBarSize" then M.buildStatusUI() end
        saveCherryConfig()
    end
end

-- ============================================================
-- ZeyHubb DUELS UI (ORIZZONTALE TABS + MENU PIÙ BASSO)
-- ============================================================

local UI_ACCENT       = Color3.fromRGB(255, 255, 255)
local UI_ACCENT_DIM   = Color3.fromRGB(210, 210, 210)
local UI_BG_DARK      = Color3.fromRGB(255, 255, 255)
local UI_ROW_BG       = Color3.fromRGB(245, 245, 245)
local UI_CARD_STROKE  = Color3.fromRGB(215, 215, 215)
local UI_TEXT_WHITE   = Color3.fromRGB(0, 0, 0)
local UI_TEXT_PRIMARY = Color3.fromRGB(0, 0, 0)
local UI_TEXT_DIM     = Color3.fromRGB(90, 90, 90)
local UI_TEXT_SECTION = Color3.fromRGB(0, 0, 0)
local UI_BTN_BG       = Color3.fromRGB(235, 235, 235)
local UI_TOGGLE_OFF   = Color3.fromRGB(0, 0, 0)
local UI_TOGGLE_KNOB  = Color3.fromRGB(255, 255, 255)
local UI_KNOB_ON      = Color3.fromRGB(255, 255, 255)
local UI_GRAD_TOP     = Color3.fromRGB(20, 20, 22)
local UI_GRAD_BOT     = Color3.fromRGB(0, 0, 0)


-- Apply saved colour scheme before any UI is built
pcall(applyAccentFromTheme)

local UI_TWEEN_FAST = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local UI_TWEEN_MED  = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- UI STYLE HELPERS
local function uiCardStyle(f)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,14); c.Parent = f
    local s = Instance.new("UIStroke"); s.Thickness = 1; s.Color = UI_ACCENT or Color3.fromRGB(255,255,255); s.Transparency = 0.72; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = f
    local g = Instance.new("UIGradient"); g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, (UI_ROW_BG or Color3.fromRGB(22,12,24)):Lerp(Color3.fromRGB(30,18,36), 0.5)),
        ColorSequenceKeypoint.new(1, UI_BG_DARK or Color3.fromRGB(12,6,14))
    }); g.Rotation = 90; g.Parent = f
end

local function uiSmallBtn(p)
    local b = Instance.new("TextButton")
    b.Position = p.Pos or UDim2.new(0,0,0,0); b.Size = p.Size or UDim2.new(0,40,0,23)
    b.BackgroundColor3 = p.Bg or UI_BTN_BG; b.BorderSizePixel = 0
    b.Text = p.Text or ""; b.TextColor3 = p.Col or UI_TEXT_DIM; b.TextSize = p.TS or 11
    b.Font = Enum.Font.GothamBold; b.AutoButtonColor = false; b.ZIndex = p.Z or 1; b.Parent = p.Parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,p.CR or 6); c.Parent = b
    return b
end

local function uiAccentBar(parent, on)
    local b = Instance.new("Frame")
    b.Position = UDim2.new(0,0,0.5,-11); b.Size = UDim2.new(0,3,0,22)
    b.BackgroundColor3 = on and UI_ACCENT or UI_TEXT_WHITE
    b.BackgroundTransparency = on and 0 or 1; b.BorderSizePixel = 0; b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,2); c.Parent = b
    return b
end

local function uiAutoCanvas(scroll)
    local lay = scroll:FindFirstChildOfClass("UIListLayout"); if not lay then return end
    local pad = scroll:FindFirstChildOfClass("UIPadding")
    local function upd()
        local padBottom = (pad and pad.PaddingBottom.Offset or 0)
        local padTop = (pad and pad.PaddingTop.Offset or 0)
        local h = lay.AbsoluteContentSize.Y + padBottom + padTop + 24
        scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(h, 1))
    end
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(upd)
    task.defer(upd)
    task.delay(0.15, upd)
    task.delay(0.5, upd)
end

local function uiSectionHeader(parent, text)
    local r = Instance.new("Frame"); r.Size = UDim2.new(1,0,0,28); r.BackgroundTransparency = 1; r.Parent = parent
    local b = Instance.new("Frame"); b.Position = UDim2.new(0,2,0.5,-8); b.Size = UDim2.new(0,4,0,16)
    b.BackgroundColor3 = UI_ACCENT; b.BorderSizePixel = 0; b.Parent = r
    Instance.new("UICorner",b).CornerRadius = UDim.new(1,0)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,14,0,0); l.Size = UDim2.new(1,-14,1,0)
    l.BackgroundTransparency = 1; l.Text = string.upper(tostring(text or "")); l.TextColor3 = UI_ACCENT; l.TextSize = 12
    l.Font = Enum.Font.GothamBlack; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r
    return r
end

local function uiInputRow(parent, label, def, hidden)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,44)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0
    if hidden then r.Visible = false end; r.Parent = parent; uiCardStyle(r)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,13,0,0); l.Size = UDim2.new(1,-84,1,0)
    l.BackgroundTransparency = 1; l.Text = label; l.TextColor3 = UI_TEXT_PRIMARY; l.TextSize = 13
    l.Font = Enum.Font.GothamMedium; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r
    local bx = Instance.new("TextBox")
    bx.Position = UDim2.new(1,-82,0.5,-14)
    bx.Size = UDim2.new(0,70,0,29)
    bx.BackgroundColor3 = UI_BTN_BG
    bx.BackgroundTransparency = 0
    bx.BorderSizePixel = 0
    bx.Text = tostring(def)
    bx.TextColor3 = Color3.fromRGB(255, 45, 45)
    bx.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    bx.TextStrokeTransparency = 0.15
    bx.TextSize = 15
    bx.Font = Enum.Font.GothamBlack
    bx.TextXAlignment = Enum.TextXAlignment.Center
    bx.ClearTextOnFocus = false
    bx.Parent = r
    local speedStroke = Instance.new("UIStroke")
    speedStroke.Color = Color3.fromRGB(255, 45, 45)
    speedStroke.Transparency = 0.15
    speedStroke.Thickness = 1
    speedStroke.Parent = bx
    Instance.new("UICorner",bx).CornerRadius = UDim.new(0,7)
    return r, bx
end

local function uiToggleRow(parent, label, on, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,46)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)

    -- Full red outline around the whole toggle row while enabled.
    local rowStroke = r:FindFirstChildOfClass("UIStroke")
    if not rowStroke then
        rowStroke = Instance.new("UIStroke")
        rowStroke.Parent = r
    end
    rowStroke.Name = "ActiveRedOutline"
    rowStroke.Color = Color3.fromRGB(255, 45, 45)
    rowStroke.Thickness = on and 2.5 or 1
    rowStroke.Transparency = on and 0 or 0.72
    rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local bar = uiAccentBar(r, on)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,14,0,0); l.Size = UDim2.new(1,-74,1,0)
    l.BackgroundTransparency = 1; l.Text = label; l.TextColor3 = UI_TEXT_PRIMARY; l.TextSize = 14
    l.Font = Enum.Font.GothamMedium; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r

    local tb = Instance.new("TextButton"); tb.Position = UDim2.new(1,-54,0.5,-11); tb.Size = UDim2.new(0,44,0,22)
    tb.BackgroundColor3 = on and UI_ACCENT or UI_TOGGLE_OFF; tb.BorderSizePixel = 0; tb.Text = ""; tb.AutoButtonColor = false; tb.Parent = r
    Instance.new("UICorner",tb).CornerRadius = UDim.new(0,11)

    -- Red outline while the toggle is ON; disappears when OFF.
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Name = "ActiveRedOutline"
    toggleStroke.Color = Color3.fromRGB(220, 40, 40)
    toggleStroke.Thickness = 2
    toggleStroke.Transparency = on and 0 or 1
    toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    toggleStroke.Parent = tb

    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,16,0,16); knob.BorderSizePixel = 0
    knob.Position = on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = on and UI_KNOB_ON or UI_TOGGLE_KNOB; knob.Parent = tb
    Instance.new("UICorner",knob)

    local state = on
    local function set(v)
        state = v
        TweenService:Create(tb, UI_TWEEN_FAST, {BackgroundColor3 = v and UI_ACCENT or UI_TOGGLE_OFF}):Play()
        TweenService:Create(knob, UI_TWEEN_FAST, {Position = v and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8), BackgroundColor3 = v and UI_KNOB_ON or UI_TOGGLE_KNOB}):Play()
        TweenService:Create(toggleStroke, UI_TWEEN_FAST, {Transparency = v and 0 or 1}):Play()

        -- The visible red border is around the ENTIRE button/row, not just the switch.
        TweenService:Create(rowStroke, UI_TWEEN_FAST, {
            Transparency = v and 0 or 0.72,
            Thickness = v and 2.5 or 1
        }):Play()

        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = v and 0 or 1}):Play()
        bar.BackgroundColor3 = UI_ACCENT
    end
    tb.MouseButton1Click:Connect(function()
        set(not state)
        if callback then callback(state) end
        saveCherryConfig()
    end)
    return r, set
end

local function uiActionRow(parent, label, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,42)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1
    btn.Text = label; btn.TextColor3 = UI_TEXT_PRIMARY; btn.TextSize = 14; btn.Font = Enum.Font.GothamBold; btn.Parent = r
    local bar = uiAccentBar(r, false)

    btn.MouseButton1Click:Connect(function()
        bar.BackgroundColor3 = UI_ACCENT
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = 0}):Play()
        task.delay(0.3, function() TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = 1}):Play() end)
        if callback then callback() end
    end)
    return r, btn
end

local function uiNumberRow(parent, label, value, minV, maxV, callback)
    local r, bx = uiInputRow(parent, label, value)
    bx.FocusLost:Connect(function()
        local n = tonumber(bx.Text)
        if n and n >= minV and n <= maxV then
            bx.Text = tostring(n)
            if callback then callback(n) end
            saveCherryConfig()
        else
            bx.Text = tostring(value)
        end
    end)
    return r, bx
end

local function uiChoiceRow(parent, label, options, defaultIndex, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,44)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
    local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.43,0,0,44); l.BackgroundTransparency=1
    l.Text=label; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
    local la = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-174,0,8), Size=UDim2.new(0,29,0,27), Text="<", Col=UI_TEXT_PRIMARY, TS=13, CR=7})
    local vl = Instance.new("TextLabel"); vl.Position=UDim2.new(1,-141,0,8); vl.Size=UDim2.new(0,102,0,27)
    vl.BackgroundColor3=UI_BTN_BG; vl.BorderSizePixel=0; vl.Text=options[defaultIndex or 1]; vl.TextColor3=UI_TEXT_PRIMARY; vl.TextSize=10; vl.Font=Enum.Font.GothamBold; vl.Parent=r
    Instance.new("UICorner",vl).CornerRadius=UDim.new(0,7)
    local ra = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-35,0,8), Size=UDim2.new(0,29,0,27), Text=">", Col=UI_TEXT_PRIMARY, TS=13, CR=7})
    local idx = defaultIndex or 1
    local function upd()
        vl.Text = options[idx]
        if callback then callback(options[idx]) end
        saveCherryConfig()
    end
    la.MouseButton1Click:Connect(function() idx=idx-1; if idx<1 then idx=#options end; upd() end)
    ra.MouseButton1Click:Connect(function() idx=idx+1; if idx>#options then idx=1 end; upd() end)
    local function setVal(v)
        for i,o in ipairs(options) do if o==v then idx=i; vl.Text=o; break end end
    end
    return r, setVal
end

local ARROW_GLOW_TRANSPARENCY = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.82, 0),
    NumberSequenceKeypoint.new(0.28, 0.06, 0),
    NumberSequenceKeypoint.new(0.52, 0.22, 0),
    NumberSequenceKeypoint.new(1, 0.82, 0),
})

local function styleArrowButton(arrow)
    -- AdaptHub-style glowing outline for ARROWS ONLY
    local border = Instance.new("UIStroke")
    border.Name = "AnimatedArrowBorder"
    border.Color = Color3.fromRGB(255, 255, 255)
    border.Thickness = 1.8
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Transparency = 0.05
    border.Parent = arrow
    local bg = Instance.new("UIGradient")
    bg.Rotation = 135
    bg.Transparency = ARROW_GLOW_TRANSPARENCY
    bg.Parent = border

    local glow = Instance.new("UIStroke")
    glow.Name = "AnimatedArrowGlow"
    glow.Color = Color3.fromRGB(255, 255, 255)
    glow.Thickness = 3.6
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Transparency = 0.58
    glow.Parent = arrow
    local gg = Instance.new("UIGradient")
    gg.Name = "GlowGradient"
    gg.Rotation = 180
    gg.Transparency = ARROW_GLOW_TRANSPARENCY
    gg.Parent = glow
end

local function styleOptionChip(btn, active)
    -- Black text + white outline so V1/V2/V3 stay readable
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundColor3 = active and UI_ACCENT or Color3.fromRGB(220, 220, 225)
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = btn
    end
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = active and 2 or 1.4
    stroke.Transparency = 0
    local ts = btn:FindFirstChildOfClass("UIStroke")
    -- text outline via second stroke on a label is hard; use TextStroke
    btn.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextStrokeTransparency = 0
end

local function uiExpandToggleRow(parent, label, on, options, defaultIndex, onToggle, onOption)
    -- Everything stacks UNDER the main row when the arrow is opened
    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 46)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.ClipsDescendants = false
    container.Parent = parent

    local col = Instance.new("UIListLayout")
    col.FillDirection = Enum.FillDirection.Vertical
    col.SortOrder = Enum.SortOrder.LayoutOrder
    col.Padding = UDim.new(0, 6)
    col.Parent = container

    -- MAIN ROW (toggle + arrow)
    local r = Instance.new("Frame")
    r.LayoutOrder = 1
    r.ClipsDescendants = true
    r.Size = UDim2.new(1, 0, 0, 46)
    r.BackgroundColor3 = UI_ROW_BG
    r.BackgroundTransparency = 0.1
    r.BorderSizePixel = 0
    r.Parent = container
    uiCardStyle(r)

    local bar = uiAccentBar(r, on)
    local l = Instance.new("TextLabel")
    l.Position = UDim2.new(0, 14, 0, 0)
    l.Size = UDim2.new(1, -110, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = UI_TEXT_PRIMARY
    l.TextSize = 14
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = r

    local expanded = false
    local arrow = Instance.new("TextButton")
    arrow.Name = "ArrowButton"
    arrow.Position = UDim2.new(1, -100, 0.5, -13)
    arrow.Size = UDim2.new(0, 36, 0, 26)
    arrow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    arrow.BackgroundTransparency = 0.1
    arrow.BorderSizePixel = 0
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    arrow.TextSize = 14
    arrow.Font = Enum.Font.GothamBlack
    arrow.AutoButtonColor = false
    arrow.Parent = r
    Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 7)
    styleArrowButton(arrow)

    local tb = Instance.new("TextButton")
    tb.Position = UDim2.new(1, -54, 0.5, -11)
    tb.Size = UDim2.new(0, 44, 0, 22)
    tb.BackgroundColor3 = on and UI_ACCENT or UI_TOGGLE_OFF
    tb.BorderSizePixel = 0
    tb.Text = ""
    tb.AutoButtonColor = false
    tb.Parent = r
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 11)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.BorderSizePixel = 0
    knob.Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = on and UI_KNOB_ON or UI_TOGGLE_KNOB
    knob.Parent = tb
    Instance.new("UICorner", knob)

    -- OPTIONS ROW (under main row when expanded)
    -- Scrollable when many options (e.g. animation packs)
    local useScroll = #options > 4
    local optFrame = Instance.new("Frame")
    optFrame.LayoutOrder = 2
    optFrame.Size = UDim2.new(1, 0, 0, useScroll and 140 or 40)
    optFrame.BackgroundColor3 = UI_ROW_BG
    optFrame.BackgroundTransparency = 0.12
    optFrame.BorderSizePixel = 0
    optFrame.Visible = false
    optFrame.ClipsDescendants = true
    optFrame.Parent = container
    uiCardStyle(optFrame)

    local optPad = Instance.new("UIPadding")
    optPad.PaddingLeft = UDim.new(0, 8)
    optPad.PaddingRight = UDim.new(0, 8)
    optPad.PaddingTop = UDim.new(0, 6)
    optPad.PaddingBottom = UDim.new(0, 6)
    optPad.Parent = optFrame

    local optParent = optFrame
    if useScroll then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Name = "OptionsScroll"
        scroll.Size = UDim2.new(1, -4, 1, -4)
        scroll.Position = UDim2.new(0, 2, 0, 2)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 5
        scroll.ScrollBarImageColor3 = UI_ACCENT
        scroll.ScrollingDirection = Enum.ScrollingDirection.Y
        scroll.ElasticBehavior = Enum.ElasticBehavior.Always
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Parent = optFrame
        local sPad = Instance.new("UIPadding")
        sPad.PaddingLeft = UDim.new(0, 6)
        sPad.PaddingRight = UDim.new(0, 8)
        sPad.PaddingTop = UDim.new(0, 4)
        sPad.PaddingBottom = UDim.new(0, 8)
        sPad.Parent = scroll
        local sLay = Instance.new("UIListLayout")
        sLay.FillDirection = Enum.FillDirection.Vertical
        sLay.Padding = UDim.new(0, 5)
        sLay.SortOrder = Enum.SortOrder.LayoutOrder
        sLay.Parent = scroll
        optParent = scroll
    else
        local optLayout = Instance.new("UIListLayout")
        optLayout.FillDirection = Enum.FillDirection.Horizontal
        optLayout.Padding = UDim.new(0, 6)
        optLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        optLayout.SortOrder = Enum.SortOrder.LayoutOrder
        optLayout.Parent = optFrame
    end

    -- MODE SETTINGS (under options when a mode is selected + expanded)
    local settingsHost = Instance.new("Frame")
    settingsHost.Name = "ModeSettings"
    settingsHost.LayoutOrder = 3
    settingsHost.Size = UDim2.new(1, 0, 0, 0)
    settingsHost.AutomaticSize = Enum.AutomaticSize.Y
    settingsHost.BackgroundTransparency = 1
    settingsHost.Visible = false
    settingsHost.Parent = container

    local settingsLayout = Instance.new("UIListLayout")
    settingsLayout.Padding = UDim.new(0, 6)
    settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    settingsLayout.Parent = settingsHost

    local idx = defaultIndex or 1
    local optionBtns = {}
    local state = on
    local modeSettings = {}

    local function refreshOptionVisuals()
        for i, b in ipairs(optionBtns) do
            styleOptionChip(b, i == idx)
        end
    end

    local function refreshModeSettings()
        local any = false
        for lab, fr in pairs(modeSettings) do
            local show = expanded and (lab == options[idx])
            fr.Visible = show
            if show then any = true end
        end
        settingsHost.Visible = any
        -- container height follows AutomaticSize + list layout
    end

    for i, opt in ipairs(options) do
        local b = Instance.new("TextButton")
        b.LayoutOrder = i
        if useScroll then
            b.Size = UDim2.new(1, -4, 0, 30)
        else
            b.Size = UDim2.new(0, math.max(56, #tostring(opt) * 9 + 18), 0, 28)
        end
        b.BorderSizePixel = 0
        b.Text = tostring(opt)
        b.TextSize = useScroll and 12 or 12
        b.Font = Enum.Font.GothamBlack
        b.TextXAlignment = useScroll and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
        b.AutoButtonColor = false
        b.Parent = optParent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        if useScroll then
            local p = Instance.new("UIPadding")
            p.PaddingLeft = UDim.new(0, 10)
            p.Parent = b
        end
        styleOptionChip(b, i == idx)
        b.MouseButton1Click:Connect(function()
            idx = i
            refreshOptionVisuals()
            refreshModeSettings()
            if onOption then onOption(options[idx]) end
            saveCherryConfig()
        end)
        optionBtns[i] = b
    end

    local function setExpanded(v)
        expanded = v
        optFrame.Visible = v
        arrow.Text = v and "▲" or "▼"
        refreshModeSettings()
    end

    arrow.MouseButton1Click:Connect(function()
        setExpanded(not expanded)
    end)

    local function set(v)
        state = v
        TweenService:Create(tb, UI_TWEEN_FAST, {BackgroundColor3 = v and UI_ACCENT or UI_TOGGLE_OFF}):Play()
        TweenService:Create(knob, UI_TWEEN_FAST, {
            Position = v and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = v and UI_KNOB_ON or UI_TOGGLE_KNOB
        }):Play()
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = v and 0 or 1}):Play()
        bar.BackgroundColor3 = UI_ACCENT
    end

    tb.MouseButton1Click:Connect(function()
        set(not state)
        if onToggle then onToggle(state) end
        saveCherryConfig()
    end)

    local function setOption(v)
        for i, o in ipairs(options) do
            if o == v then
                idx = i
                refreshOptionVisuals()
                refreshModeSettings()
                break
            end
        end
    end

    local function registerModeSettings(optionLabel, frame)
        frame.Parent = settingsHost
        frame.Visible = false
        frame.Size = UDim2.new(1, 0, 0, 0)
        frame.AutomaticSize = Enum.AutomaticSize.Y
        modeSettings[optionLabel] = frame
        task.defer(refreshModeSettings)
    end

    return container, set, setOption, registerModeSettings, function() return options[idx] end
end

local function uiMakePage(parent, name, order, vis)
    local p = Instance.new("ScrollingFrame"); p.Name=name; p.Visible=vis~=false; p.LayoutOrder=order
    p.Size=UDim2.new(1,0,1,0); p.BackgroundTransparency=1; p.BorderSizePixel=0
    p.ScrollBarThickness=8
    p.ScrollBarImageColor3=UI_ACCENT
    p.ScrollBarImageTransparency=0.15
    p.ScrollingEnabled=true
    p.ScrollingDirection=Enum.ScrollingDirection.Y
    p.ElasticBehavior=Enum.ElasticBehavior.Always
    p.AutomaticCanvasSize=Enum.AutomaticSize.Y
    p.CanvasSize=UDim2.new(0,0,0,0)
    p.Parent=parent
    local l = Instance.new("UIListLayout"); l.Padding=UDim.new(0,7); l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=p
    local pd = Instance.new("UIPadding")
    pd.PaddingTop=UDim.new(0,4)
    pd.PaddingBottom=UDim.new(0,40)
    pd.PaddingRight=UDim.new(0,6)
    pd.PaddingLeft=UDim.new(0,2)
    pd.Parent=p
    uiAutoCanvas(p)
    return p
end

local function uiMakeTab(parent, name, text, pos, active)
    local b = Instance.new("TextButton"); b.Name=name; b.ZIndex=9
    if pos then b.Position=pos end
    b.Size = UDim2.new(0, 96, 0, 38)
    b.BackgroundColor3 = active and UI_ACCENT or Color3.fromRGB(0, 0, 0)
    b.BackgroundTransparency = active and 0.05 or 0.35
    b.BorderSizePixel=0
    b.Text=text
    b.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(90, 90, 90)
    b.TextStrokeTransparency = 1
    b.TextTransparency=0
    b.TextSize=12; b.Font=Enum.Font.GothamBlack; b.AutoButtonColor=false; b.Parent=parent
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    local stroke = Instance.new("UIStroke"); stroke.Name="TabStroke"
    stroke.Color = UI_ACCENT or Color3.fromRGB(255,255,255)
    stroke.Thickness = active and 1.5 or 1
    stroke.Transparency = active and 0.15 or 0.75
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = b
    b:SetAttribute("IsActiveTab", active and true or false)
    b.MouseEnter:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, UI_TWEEN_FAST, {
                BackgroundColor3 = UI_ACCENT,
                BackgroundTransparency = 0.55,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            local st = b:FindFirstChild("TabStroke")
            if st then st.Transparency = 0.35; st.Thickness = 1.2 end
        end
    end)
    b.MouseLeave:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, UI_TWEEN_FAST, {
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.35,
                TextColor3 = Color3.fromRGB(90, 90, 90)
            }):Play()
            local st = b:FindFirstChild("TabStroke")
            if st then st.Transparency = 0.75; st.Thickness = 1 end
        end
    end)
    return b
end

-- MAIN BUILD
function M.applyCustomBackground(frame)
    if not frame then return end
    local id = tonumber(M.customBgId) or 0
    local forcedAsset = M.ZEYHUBB_LOCAL_IMAGE_ASSET
    local tint = Color3.fromRGB(255, 255, 255) -- never tint background red
    local opacity = math.clamp(tonumber(M.customBgOpacity) or 0.02, 0, 0.25)
    local function placeBg(target, cornerR)
        if not target then return end
        local existing = target:FindFirstChild("CustomBgImage")
        if existing then existing:Destroy() end
        local oldTint = target:FindFirstChild("CustomBgPinkTint")
        if oldTint then oldTint:Destroy() end
        if not forcedAsset and id <= 0 then return end
        local img = Instance.new("ImageLabel")
        img.Name = "CustomBgImage"
        img.BackgroundTransparency = 1
        img.Image = forcedAsset or ("rbxassetid://" .. tostring(id))
        img.ImageColor3 = tint
        img.ScaleType = Enum.ScaleType.Fit
        img.Size = UDim2.fromScale(1, 1)
        img.ZIndex = 0
        img.ImageTransparency = math.min(opacity, 0.02)
        img.Parent = target
        Instance.new("UICorner", img).CornerRadius = UDim.new(0, cornerR or 14)
    end
    placeBg(frame, 18)
    if M.leftImagePanel and M.leftImagePanel.Parent then placeBg(M.leftImagePanel, 16) end
    pcall(function() if M.refreshMobileButtonTheme then M.refreshMobileButtonTheme() end end)
end

function M.openImagePicker(kind)
    -- kind = "bg" | "mob"
    local isBg = kind == "bg"
    local ids = isBg and M.BG_IMAGE_IDS or M.MOB_BTN_IMAGE_IDS
    local title = isBg and "CUSTOM BG" or "BUTTON BG"
    local currentId = isBg and (tonumber(M.customBgId) or 0) or (tonumber(M.mobBtnBgId) or 0)
    local opacity = math.clamp(tonumber(M.customBgOpacity) or 0.35, 0, 1)

    local old = player.PlayerGui:FindFirstChild("ZeyHubbImagePicker")
    if old then old:Destroy() end
    local cg = game:GetService("CoreGui"):FindFirstChild("ZeyHubbImagePicker")
    if cg then cg:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ZeyHubbImagePicker"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 120
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

    -- dim backdrop (tap to close)
    local dim = Instance.new("TextButton")
    dim.Size = UDim2.fromScale(1, 1)
    dim.BackgroundColor3 = Color3.new(0, 0, 0)
    dim.BackgroundTransparency = 0.45
    dim.Text = ""
    dim.AutoButtonColor = false
    dim.ZIndex = 1
    dim.Parent = gui
    dim.MouseButton1Click:Connect(function() gui:Destroy() end)

    local panel = Instance.new("Frame")
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.Size = UDim2.new(0, 220, 0, isBg and 280 or 230)
    panel.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    panel.BorderSizePixel = 0
    panel.ZIndex = 2
    panel.ClipsDescendants = true
    panel.Parent = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
    local pst = Instance.new("UIStroke", panel)
    pst.Color = Color3.fromRGB(50, 50, 60)
    pst.Thickness = 1

    local hdr = Instance.new("TextLabel")
    hdr.Size = UDim2.new(1, -40, 0, 28)
    hdr.Position = UDim2.new(0, 12, 0, 6)
    hdr.BackgroundTransparency = 1
    hdr.Text = title
    hdr.TextColor3 = Color3.fromRGB(230, 230, 235)
    hdr.Font = Enum.Font.GothamBold
    hdr.TextSize = 12
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    hdr.ZIndex = 3
    hdr.Parent = panel

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 24, 0, 24)
    close.Position = UDim2.new(1, -30, 0, 6)
    close.BackgroundTransparency = 1
    close.Text = "×"
    close.TextColor3 = Color3.fromRGB(30, 30, 30)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.ZIndex = 3
    close.Parent = panel
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    local preview = Instance.new("ImageLabel")
    preview.Name = "Preview"
    preview.Size = UDim2.new(1, -24, 0, 100)
    preview.Position = UDim2.new(0, 12, 0, 34)
    preview.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    preview.BorderSizePixel = 0
    preview.ScaleType = Enum.ScaleType.Crop
    preview.Image = currentId > 0 and ("rbxassetid://" .. currentId) or ""
    preview.ImageTransparency = isBg and opacity or 0
    preview.ZIndex = 3
    preview.Parent = panel
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 10)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -24, 0, 56)
    scroll.Position = UDim2.new(0, 12, 0, 142)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = UI_ACCENT or Color3.fromRGB(40, 40, 40)
    scroll.ScrollingDirection = Enum.ScrollingDirection.X
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    scroll.ZIndex = 3
    scroll.Parent = panel

    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.Padding = UDim.new(0, 8)
    lay.VerticalAlignment = Enum.VerticalAlignment.Center
    lay.Parent = scroll

    local selectedId = currentId

    local function selectId(id)
        selectedId = id
        preview.Image = id > 0 and ("rbxassetid://" .. id) or ""
        if isBg then
            M.customBgId = id
            if M.mainFrame then M.applyCustomBackground(M.mainFrame) end
        else
            M.mobBtnBgId = id
            if M.mobileButtonsEnabled then M.buildMobileButtons() end
        end
        saveCherryConfig()
    end

    -- None option
    local none = Instance.new("TextButton")
    none.Size = UDim2.new(0, 48, 0, 48)
    none.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    none.Text = "OFF"
    none.TextColor3 = Color3.fromRGB(255, 255, 255)
    none.Font = Enum.Font.GothamBold
    none.TextSize = 10
    none.ZIndex = 4
    none.Parent = scroll
    Instance.new("UICorner", none).CornerRadius = UDim.new(0, 8)
    none.MouseButton1Click:Connect(function() selectId(0) end)

    for _, id in ipairs(ids) do
        local thumb = Instance.new("ImageButton")
        thumb.Size = UDim2.new(0, 48, 0, 48)
        thumb.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        thumb.Image = "rbxassetid://" .. tostring(id)
        thumb.ScaleType = Enum.ScaleType.Crop
        thumb.ZIndex = 4
        thumb.Parent = scroll
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", thumb)
        st.Color = Color3.fromRGB(255, 255, 255)
        st.Transparency = (id == currentId) and 0.2 or 0.7
        st.Thickness = 1
        thumb.MouseButton1Click:Connect(function()
            selectId(id)
            for _, ch in ipairs(scroll:GetChildren()) do
                if ch:IsA("ImageButton") then
                    local s = ch:FindFirstChildOfClass("UIStroke")
                    if s then s.Transparency = 0.7 end
                end
            end
            st.Transparency = 0.2
        end)
    end

    if isBg then
        local opLbl = Instance.new("TextLabel")
        opLbl.Size = UDim2.new(0.5, -12, 0, 18)
        opLbl.Position = UDim2.new(0, 12, 0, 208)
        opLbl.BackgroundTransparency = 1
        opLbl.Text = "OPACITY"
        opLbl.TextColor3 = Color3.fromRGB(80, 80, 80)
        opLbl.Font = Enum.Font.GothamBold
        opLbl.TextSize = 10
        opLbl.TextXAlignment = Enum.TextXAlignment.Left
        opLbl.ZIndex = 3
        opLbl.Parent = panel

        local opVal = Instance.new("TextLabel")
        opVal.Size = UDim2.new(0.5, -12, 0, 18)
        opVal.Position = UDim2.new(0.5, 0, 0, 208)
        opVal.BackgroundTransparency = 1
        opVal.Text = tostring(math.floor((1 - opacity) * 100)) .. "%"
        opVal.TextColor3 = Color3.fromRGB(255, 255, 255)
        opVal.Font = Enum.Font.GothamBold
        opVal.TextSize = 10
        opVal.TextXAlignment = Enum.TextXAlignment.Right
        opVal.ZIndex = 3
        opVal.Parent = panel

        -- simple slider track
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -24, 0, 8)
        track.Position = UDim2.new(0, 12, 0, 232)
        track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        track.BorderSizePixel = 0
        track.ZIndex = 3
        track.Parent = panel
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(1 - opacity, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
        fill.BorderSizePixel = 0
        fill.ZIndex = 4
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(1 - opacity, 0, 0.5, 0)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.ZIndex = 5
        knob.Parent = track
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local dragging = false
        local function setFromX(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            -- rel 1 = fully opaque image (low ImageTransparency)
            local imageTransparency = 1 - rel
            opacity = imageTransparency
            M.customBgOpacity = opacity
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            preview.ImageTransparency = opacity
            opVal.Text = tostring(math.floor(rel * 100)) .. "%"
            if M.mainFrame then M.applyCustomBackground(M.mainFrame) end
            saveCherryConfig()
        end
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromX(i.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                setFromX(i.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end
end


-- ZEYHUBB BYPASS PANEL (open/close from Utility)
-- ============================================================
local BYPASS_DEPTH = 296
local BYPASS_SPAM_DELAY = 0.12

local function _zeyhubbBuildBomb(power)
    local maintable = {}
    local spammedtable = {}
    table.insert(spammedtable, {})
    local z = spammedtable[1]
    for i = 1, BYPASS_DEPTH do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
    end
    local maxRep = math.floor((tonumber(power) or 97000) / (BYPASS_DEPTH + 2))
    for i = 1, maxRep do
        table.insert(maintable, spammedtable)
    end
    return maintable
end

function M.stopZeyHubbBypassSpam()
    M._bypassSpamRunning = false
    if M._bypassSpamThread then
        pcall(function() task.cancel(M._bypassSpamThread) end)
        M._bypassSpamThread = nil
    end
    M._bypassBomb = nil
end

function M.startZeyHubbBypassSpam(power)
    -- Speed Bypass disabled.
    M.stopZeyHubbBypassSpam()
    M.bypassActive = false
end

function M.hasBrainrotTool()
    local char = player.Character
    if not char then return false end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local name = string.lower(item.Name)
            if string.find(name, "brainrot", 1, true)
                or string.find(name, "skibidi", 1, true)
                or string.find(name, "toilet", 1, true) then
                return true
            end
        end
    end
    return false
end

function M.destroyBypassBillboard()
    if M._bypassBillboard then
        pcall(function() M._bypassBillboard:Destroy() end)
        M._bypassBillboard = nil
    end
end

function M.createBypassBillboard()
    -- Head label for ZeyHubb Bypass removed
    M.destroyBypassBillboard()
end

function M.setZeyHubbBypassActive(state)
    -- DISABLED: Speed Bypass is completely removed from execution.
    M.bypassActive = false
    M.stopZeyHubbBypassSpam()
    if M._bypassRefreshVisual then pcall(M._bypassRefreshVisual) end
end

function M.buildZeyHubbBypassUI()
    -- Bypass panel intentionally disabled.
    if M.bypassPanelGui then
        pcall(function() M.bypassPanelGui:Destroy() end)
        M.bypassPanelGui = nil
    end
    M.bypassPanelMain = nil
    M.bypassPanelMini = nil
end

function M.setBypassPanelOpen(on)
    M.bypassPanelOpen = on and true or false
    if M.bypassPanelOpen and (not M.bypassPanelGui or not M.bypassPanelGui.Parent) then
-- Bypass panel disabled
    end
    if M.bypassPanelMain then
        M.bypassPanelMain.Visible = M.bypassPanelOpen
    end
    if M.bypassPanelMini then
        -- only show mini if user collapsed; default open shows main
        if not M.bypassPanelOpen then
            M.bypassPanelMini.Visible = false
        end
    end
    if not M.bypassPanelOpen then
        -- keep spam if active? turn off when panel closed for safety
        -- user may want it running in background — leave active state
    end
    if M.setBypassPanelVisual then
        pcall(function() M.setBypassPanelVisual(M.bypassPanelOpen) end)
    end
    pcall(saveCherryConfig)
end


function M.buildGui()
    M.uiLocked = false
    applyAccentFromTheme()
    M.clearPersistentConns()

    for _,n in ipairs({"MoveeDuels","Cherry_Menu","K7HubGUI","VantaHubUI","ZeyHubbHubUI","ZeyHubbHubUI","AceDuelsAdaptReconstruct"}) do
        local cg=game:GetService("CoreGui")
        local old=cg:FindFirstChild(n); if old then old:Destroy() end
        local pg=player:FindFirstChild("PlayerGui")
        if pg then local o=pg:FindFirstChild(n); if o then o:Destroy() end end
    end

    M.buildStatusUI()

    local gui = Instance.new("ScreenGui")
    gui.Name = "ZeyHubbHubUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")

    -- Ace-style shell (ZeyHubb colours + features)
    local MAIN_W, MAIN_H = 480, 640
    local HEADER_H, TABS_H = 48, 36
    local SIDE_W = 78

    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.ClipsDescendants = true
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
    -- Coach-style shell: deep dark + white outline
    Frame.BackgroundColor3 = Color3.fromRGB(8, 6, 12)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Parent = gui
    M.mainFrame = Frame

    local UIScale = Instance.new("UIScale")
    UIScale.Name = "BDUIScale"
    UIScale.Scale = M.uiScale or 0.85
    UIScale.Parent = Frame
    M.uiScaleRef = UIScale

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)
    do
        local stroke = Instance.new("UIStroke")
        stroke.Name = "MainStroke"
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.15
        stroke.Parent = Frame
    end
    -- dark overlay like Coach (bg image still applied under)
    do
        local ov = Instance.new("Frame")
        ov.Name = "CoachOverlay"
        ov.Size = UDim2.new(1, 0, 1, 0)
        ov.BackgroundColor3 = Color3.fromRGB(5, 3, 10)
        ov.BackgroundTransparency = 0.82
        ov.BorderSizePixel = 0
        ov.ZIndex = 1
        ov.Parent = Frame
        Instance.new("UICorner", ov).CornerRadius = UDim.new(0, 14)
    end

    local LeftPanel = Instance.new("Frame")
    LeftPanel.Name = "LeftImagePanel"
    LeftPanel.Size = UDim2.new(1, 0, 1, 0)
    LeftPanel.BackgroundTransparency = 1
    LeftPanel.BorderSizePixel = 0
    LeftPanel.ClipsDescendants = true
    LeftPanel.ZIndex = 1
    LeftPanel.Parent = Frame
    M.leftImagePanel = LeftPanel
    M.applyCustomBackground(Frame)

    local ContentRoot = Instance.new("Frame")
    ContentRoot.Name = "ContentRoot"
    ContentRoot.Size = UDim2.new(1, 0, 1, 0)
    ContentRoot.BackgroundTransparency = 1
    ContentRoot.BorderSizePixel = 0
    ContentRoot.ZIndex = 2
    ContentRoot.Parent = Frame
    M.contentRoot = ContentRoot

    local Header = Instance.new("Frame")
    Header.Name = "HeaderPanel"
    Header.Size = UDim2.new(1, -SIDE_W, 0, HEADER_H)
    Header.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    Header.BorderSizePixel = 0
    Header.Active = true
    Header.Active = true
    Header.ZIndex = 5
    Header.Parent = ContentRoot
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)
    local HeaderFill = Instance.new("Frame")
    HeaderFill.Size = UDim2.new(1, 0, 0, 14)
    HeaderFill.Position = UDim2.new(0, 0, 1, -14)
    HeaderFill.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    HeaderFill.BorderSizePixel = 0
    HeaderFill.ZIndex = 4
    HeaderFill.Parent = Header

    local logoBadge = Instance.new("Frame")
    logoBadge.Size = UDim2.new(0, 28, 0, 28)
    logoBadge.Position = UDim2.new(0, 14, 0.5, -14)
    logoBadge.BackgroundColor3 = UI_ACCENT or Color3.fromRGB(220, 40, 40)
    logoBadge.BorderSizePixel = 0
    logoBadge.ZIndex = 6
    logoBadge.Parent = Header
    Instance.new("UICorner", logoBadge).CornerRadius = UDim.new(0, 8)
    local logoTxt = Instance.new("TextLabel")
    logoTxt.Size = UDim2.new(1, 0, 1, 0)
    logoTxt.BackgroundTransparency = 1
    logoTxt.Text = "V"
    logoTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoTxt.Font = Enum.Font.GothamBlack
    logoTxt.TextSize = 14
    logoTxt.ZIndex = 7
    logoTxt.Parent = logoBadge

    local titleLbl = Instance.new("TextLabel")
    titleLbl.ZIndex = 6
    titleLbl.Position = UDim2.new(0, 50, 0, 6)
    titleLbl.Size = UDim2.new(0, 160, 0, 22)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "ZeyHubb.vs"
    titleLbl.TextColor3 = Color3.fromRGB(240, 240, 248)
    titleLbl.TextSize = 18
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = Header

    local statsLbl = Instance.new("TextLabel")
    statsLbl.ZIndex = 6
    statsLbl.Position = UDim2.new(0, 50, 0, 28)
    statsLbl.Size = UDim2.new(0, 180, 0, 14)
    statsLbl.BackgroundTransparency = 1
    statsLbl.Text = "FPS: --  Ping: --ms"
    statsLbl.TextColor3 = Color3.fromRGB(140, 140, 165)
    statsLbl.TextSize = 10
    statsLbl.Font = Enum.Font.Gotham
    statsLbl.TextXAlignment = Enum.TextXAlignment.Left
    statsLbl.Parent = Header
    M.headerStatsLbl = statsLbl

    local radVal = Instance.new("TextLabel")
    radVal.Visible = false
    radVal.Parent = Header
    M.headerRadiusLbl = radVal

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 28, 0, 24)
    MinBtn.Position = UDim2.new(1, -40, 0.5, -12)
    MinBtn.BackgroundColor3 = Color3.fromRGB(30, 22, 28)
    MinBtn.BorderSizePixel = 0
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Color3.fromRGB(240, 240, 248)
    MinBtn.TextSize = 16
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.AutoButtonColor = false
    MinBtn.ZIndex = 7
    MinBtn.Parent = Header
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)
    MinBtn.MouseButton1Down:Connect(function()
        TweenService:Create(MinBtn, UI_TWEEN_FAST, {BackgroundColor3 = UI_ACCENT}):Play()
    end)
    MinBtn.MouseButton1Up:Connect(function()
        TweenService:Create(MinBtn, UI_TWEEN_FAST, {BackgroundColor3 = Color3.fromRGB(30, 22, 28)}):Play()
    end)

    local lockButton = Instance.new("TextButton")
    lockButton.Size = UDim2.new(0, 0, 0, 0)
    lockButton.Visible = false
    lockButton.Parent = Header
    local locked = false
    lockButton.Activated:Connect(function()
        locked = not locked
        M.uiLocked = false
        saveCherryConfig()
    end)

    -- Right sidecar tabs + left content pages
    local SideBar = Instance.new("Frame")
    SideBar.Name = "RightSideBar"
    SideBar.Size = UDim2.new(0, SIDE_W, 1, 0)
    SideBar.Position = UDim2.new(1, -SIDE_W, 0, 0)
    SideBar.BackgroundColor3 = Color3.fromRGB(15, 8, 20)
    SideBar.BackgroundTransparency = 0.1
    SideBar.BorderSizePixel = 0
    SideBar.ZIndex = 6
    SideBar.Parent = ContentRoot
    Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 12)
    do
        local ss = Instance.new("UIStroke")
        ss.Color = Color3.fromRGB(255, 255, 255)
        ss.Thickness = 1
        ss.Transparency = 0.35
        ss.Parent = SideBar
    end
    local sideFill = Instance.new("Frame")
    sideFill.Size = UDim2.new(0, 16, 1, 0)
    sideFill.Position = UDim2.new(0, 0, 0, 0)
    sideFill.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    sideFill.BackgroundTransparency = 0.15
    sideFill.BorderSizePixel = 0
    sideFill.ZIndex = 5
    sideFill.Parent = SideBar

    local tabList = Instance.new("Frame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, -8, 1, -110)
    tabList.Position = UDim2.new(0, 4, 0, 8)
    tabList.BackgroundTransparency = 1
    tabList.ZIndex = 7
    tabList.Parent = SideBar
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Parent = tabList

    -- Bottom of sidebar: ZEYHUBB 3 + avatar circle
    local sideBottom = Instance.new("Frame")
    sideBottom.Name = "SideBottom"
    sideBottom.Size = UDim2.new(1, -8, 0, 96)
    sideBottom.Position = UDim2.new(0, 4, 1, -100)
    sideBottom.BackgroundTransparency = 1
    sideBottom.ZIndex = 7
    sideBottom.Parent = SideBar

    local avatarCircle = Instance.new("Frame")
    avatarCircle.Name = "AvatarCircle"
    avatarCircle.Size = UDim2.new(0, 52, 0, 52)
    avatarCircle.Position = UDim2.new(0.5, -26, 0, 4)
    -- solid red circle with ZEYHUBB (no player avatar)
    avatarCircle.BackgroundColor3 = Color3.fromRGB(210, 18, 18)
    avatarCircle.BorderSizePixel = 0
    avatarCircle.ZIndex = 8
    avatarCircle.Parent = sideBottom
    Instance.new("UICorner", avatarCircle).CornerRadius = UDim.new(1, 0)
    local avStroke = Instance.new("UIStroke", avatarCircle)
    avStroke.Color = Color3.fromRGB(255, 255, 255)
    avStroke.Thickness = 1.5
    avStroke.Transparency = 0.25

    local avatarLbl = Instance.new("TextLabel")
    avatarLbl.Name = "AvatarZeyHubb"
    avatarLbl.Size = UDim2.new(1, 0, 1, 0)
    avatarLbl.BackgroundTransparency = 1
    avatarLbl.Text = ""
    avatarLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    avatarLbl.Font = Enum.Font.GothamBlack
    avatarLbl.TextSize = 12
    avatarLbl.ZIndex = 9
    avatarLbl.Parent = avatarCircle

    local sideTitle = Instance.new("TextLabel")
    sideTitle.Name = "SideTitle"
    sideTitle.Size = UDim2.new(1, 0, 0, 20)
    sideTitle.Position = UDim2.new(0, 0, 0, 60)
    sideTitle.BackgroundTransparency = 1
    sideTitle.Text = "ZeyHubb.vs"
    sideTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sideTitle.Font = Enum.Font.GothamBlack
    sideTitle.TextSize = 12
    sideTitle.TextXAlignment = Enum.TextXAlignment.Center
    sideTitle.ZIndex = 8
    sideTitle.Parent = sideBottom

    -- Content area (left of sidecar)
    local masterScroll = Instance.new("ScrollingFrame")
    masterScroll.Name = "AllPage"
    masterScroll.BackgroundTransparency = 1
    masterScroll.BorderSizePixel = 0
    masterScroll.Position = UDim2.new(0, 8, 0, HEADER_H + 6)
    masterScroll.Size = UDim2.new(1, -(SIDE_W + 14), 1, -(HEADER_H + 14))
    masterScroll.ScrollBarThickness = 3
    masterScroll.ScrollBarImageColor3 = UI_ACCENT or Color3.fromRGB(220, 40, 40)
    masterScroll.ScrollBarImageTransparency = 0.4
    masterScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    masterScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    masterScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    masterScroll.ElasticBehavior = Enum.ElasticBehavior.Always
    masterScroll.ZIndex = 3
    masterScroll.Parent = ContentRoot
    local masterLayout = Instance.new("UIListLayout")
    masterLayout.Padding = UDim.new(0, 6)
    masterLayout.SortOrder = Enum.SortOrder.LayoutOrder
    masterLayout.Parent = masterScroll
    local masterPad = Instance.new("UIPadding")
    masterPad.PaddingTop = UDim.new(0, 4)
    masterPad.PaddingBottom = UDim.new(0, 24)
    masterPad.PaddingLeft = UDim.new(0, 2)
    masterPad.PaddingRight = UDim.new(0, 4)
    masterPad.Parent = masterScroll

    local layoutOrder = 0
    local function addSectionDivider(title)
        -- no dividers with tab system (kept as no-op for compatibility)
        return
    end

    local function makeAllPage(name)
        layoutOrder = layoutOrder + 1
        local p = Instance.new("Frame")
        p.Name = name
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.Size = UDim2.new(1, 0, 0, 0)
        p.AutomaticSize = Enum.AutomaticSize.Y
        p.LayoutOrder = layoutOrder
        p.ZIndex = 3
        p.Visible = false
        p.Parent = masterScroll
        local l = Instance.new("UIListLayout")
        l.Padding = UDim.new(0, 7)
        l.SortOrder = Enum.SortOrder.LayoutOrder
        l.Parent = p
        local pd = Instance.new("UIPadding")
        pd.PaddingTop = UDim.new(0, 2)
        pd.PaddingBottom = UDim.new(0, 8)
        pd.Parent = p
        return p
    end

    addSectionDivider("MOVEMENT")
    local PM = makeAllPage("Page_SPEED")
    addSectionDivider("STUFF")
    local PMech = makeAllPage("Page_MECHANICS")
    addSectionDivider("VISUALS")
    local PVis = makeAllPage("Page_VISUALS")
    addSectionDivider("CONFIG")
    local PUtil = makeAllPage("Page_UTILITY")
    addSectionDivider("KEYS")
    local PKB = makeAllPage("Page_KEYBINDS")

    local Pages = {SPEED=PM, MECHANICS=PMech, VISUALS=PVis, UTILITY=PUtil, KEYBINDS=PKB}
    local tabOrder = {"SPEED", "MECHANICS", "VISUALS", "UTILITY", "KEYBINDS"}
    local tabLabels = {
        SPEED = "SPEED",
        MECHANICS = "MECH",
        VISUALS = "VISUAL",
        UTILITY = "UTIL",
        KEYBINDS = "KEYS",
    }
    local tabButtons = {}
    local currentTab = "SPEED"

    local function selectTab(name)
        currentTab = name
        for k, page in pairs(Pages) do
            page.Visible = (k == name)
        end
        for k, btn in pairs(tabButtons) do
            local on = (k == name)
            btn.BackgroundColor3 = on and (UI_ACCENT or Color3.fromRGB(220, 40, 40)) or Color3.fromRGB(28, 28, 34)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            local st = btn:FindFirstChildOfClass("UIStroke")
            if st then st.Transparency = on and 0.2 or 0.6 end
        end
        masterScroll.CanvasPosition = Vector2.new(0, 0)
    end
    M.selectTab = selectTab

    for i, name in ipairs(tabOrder) do
        local btn = Instance.new("TextButton")
        btn.Name = "Tab_" .. name
        btn.Size = UDim2.new(1, -4, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        btn.BorderSizePixel = 0
        btn.Text = tabLabels[name] or name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.AutoButtonColor = false
        btn.ZIndex = 8
        btn.LayoutOrder = i
        btn.Parent = tabList
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", btn)
        st.Color = UI_ACCENT or Color3.fromRGB(220, 40, 40)
        st.Thickness = 1
        st.Transparency = 0.6
        btn.MouseButton1Click:Connect(function() selectTab(name) end)
        tabButtons[name] = btn
    end
    selectTab("SPEED")
    M.allPageScroll = masterScroll


    -- close / minimize
    local function closeUI()
        local tween = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, MAIN_W, 0, 0),
            Position = Frame.Position + UDim2.new(0, 0, 0, MAIN_H/2),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function()
            Frame.Visible = false
            Frame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
            Frame.AnchorPoint = Vector2.new(0, 0.5)
            Frame.Position = UDim2.new(0, 2, 0.5, 0)
            Frame.BackgroundTransparency = 0
        end)
    end
    -- Coach-style open bar (pill) — ZEYHUBB branding
    local MinPill = Instance.new("Frame")
    MinPill.Name = "MiniFrame"
    MinPill.Visible = false
    MinPill.Active = true
    MinPill.ZIndex = 40
    -- Small UI opener: fixed to the top-left.
    MinPill.AnchorPoint = Vector2.new(0, 0)
    MinPill.Position = UDim2.new(0, 5, 0, 5)
    MinPill.Size = UDim2.new(0, 104, 0, 24)
    MinPill.BackgroundColor3 = Color3.fromRGB(10, 8, 14)
    MinPill.BackgroundTransparency = 0
    MinPill.BorderSizePixel = 0
    MinPill.Parent = gui
    Instance.new("UICorner", MinPill).CornerRadius = UDim.new(1, 0)
    do
        local pst = Instance.new("UIStroke")
        pst.Color = Color3.fromRGB(255, 255, 255)
        pst.Thickness = 1.2
        pst.Transparency = 0.2
        pst.Parent = MinPill
    end
    -- Eye image on the UI opener too
    do
        local bgId = tonumber(M.customBgId) or 0
        local eyeAsset = M.ZEYHUBB_LOCAL_IMAGE_ASSET
        if eyeAsset or bgId > 0 then
            local bg = Instance.new("ImageLabel")
            bg.Name = "OpenerEyeImage"
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.BackgroundTransparency = 1
            bg.Image = eyeAsset or ("rbxassetid://" .. tostring(bgId))
            bg.ImageTransparency = 0
            bg.ScaleType = Enum.ScaleType.Crop
            bg.ZIndex = 40
            bg.Active = false
            bg.Parent = MinPill
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
        end
    end
    local tMain = Instance.new("TextLabel")
    tMain.Size = UDim2.new(1, -10, 1, 0)
    tMain.Position = UDim2.new(0, 10, 0, 0)
    tMain.BackgroundTransparency = 1
    tMain.Text = "ZeyHubb.vs"
    tMain.TextColor3 = Color3.fromRGB(255, 255, 255)
    tMain.Font = Enum.Font.GothamBold
    tMain.TextSize = 10
    tMain.TextXAlignment = Enum.TextXAlignment.Left
    tMain.ZIndex = 42
    tMain.Parent = MinPill
    -- keep refs nil-safe for old code
    local badge, titleCol, tSub, openChip = nil, nil, nil, nil

    -- Full-size hit button
    local b = Instance.new("TextButton")
    b.Name = "MiniButton"
    b.ZIndex = 45
    b.Size = UDim2.new(1, 0, 1, 0)
    b.BackgroundTransparency = 1
    b.Text = ""
    b.AutoButtonColor = false
    b.Parent = MinPill
    local function animateOpen()
        MinPill.Visible = false
        Frame.AnchorPoint = Vector2.new(0, 0.5)
        Frame.Position = UDim2.new(0, -18, 0.5, 0)
        Frame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
        Frame.BackgroundTransparency = 1
        Frame.Visible = true

        local tween = TweenService:Create(Frame, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 2, 0.5, 0),
            BackgroundTransparency = 0
        })
        tween:Play()
        M.menuOpen = true
        pcall(saveCherryConfig)
    end

    b.MouseButton1Click:Connect(animateOpen)

    local function minimize()
        local tween = TweenService:Create(Frame, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(0, -18, 0.5, 0),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function()
            if not Frame or not Frame.Parent then return end
            Frame.Visible = false
            Frame.BackgroundTransparency = 0
            Frame.Position = UDim2.new(0, 2, 0.5, 0)
            MinPill.Visible = true
        end)
        M.menuOpen = false
        pcall(saveCherryConfig)
    end
    MinBtn.MouseButton1Click:Connect(minimize)

    -- DRAGGING
    do
        local function makeDrag(obj, target)
            local drag,dStart,sPos
            obj.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    drag=true; dStart=i.Position; sPos=target.Position
                    i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end)
                end
            end)
            obj.InputChanged:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
                    if drag then
                        local d=i.Position-dStart
                        target.Position=UDim2.new(sPos.X.Scale,sPos.X.Offset+d.X,sPos.Y.Scale,sPos.Y.Offset+d.Y)
                    end
                end
            end)
            UIS.InputChanged:Connect(function(i)
            end)
        end
        makeDrag(Header, Frame)
        makeDrag(MinPill, MinPill)
    end

    -- KEYBIND CAPTURE
    M._anyKeyListening = false
    -- ============================================================
    -- KEYBINDS (stable id map — no shared refs / no stacked connections)
    -- ============================================================
    local activeKBId = nil
    local listeningTimeout = nil
    M.keybindButtons = {}  -- id -> { btn, entry }

    if M._keybindCaptureConn then
        pcall(function() M._keybindCaptureConn:Disconnect() end)
        M._keybindCaptureConn = nil
    end
    M._anyKeyListening = false

    local function formatKeybindText(entry)
        if not entry then return "..." end
        local parts = {}
        if entry.kb then table.insert(parts, entry.kb.Name) end
        if entry.gp then table.insert(parts, entry.gp.Name) end
        if #parts == 0 then return "..." end
        return table.concat(parts, " / ")
    end

    local function refreshKeybindButton(id)
        local info = M.keybindButtons[id]
        if not info or not info.btn then return end
        info.btn.Text = formatKeybindText(info.entry)
        info.btn.TextColor3 = UI_TEXT_DIM
    end

    local function resetKeybindCapture()
        if activeKBId then
            refreshKeybindButton(activeKBId)
            activeKBId = nil
        end
        M._anyKeyListening = false
        if listeningTimeout then
            pcall(function() task.cancel(listeningTimeout) end)
            listeningTimeout = nil
        end
    end

    local function isGamepadInputType(uit)
        return uit == Enum.UserInputType.Gamepad1
            or uit == Enum.UserInputType.Gamepad2
            or uit == Enum.UserInputType.Gamepad3
            or uit == Enum.UserInputType.Gamepad4
            or uit == Enum.UserInputType.Gamepad5
            or uit == Enum.UserInputType.Gamepad6
            or uit == Enum.UserInputType.Gamepad7
            or uit == Enum.UserInputType.Gamepad8
    end

    -- Clear this key from every OTHER keybind so one key = one action
    local function clearKeyFromOthers(exceptId, kind, keycode)
        if not keycode then return end
        for id, info in pairs(M.keybindButtons) do
            if id ~= exceptId and info and info.entry then
                if kind == "kb" and info.entry.kb == keycode then
                    info.entry.kb = nil
                    refreshKeybindButton(id)
                elseif kind == "gp" and info.entry.gp == keycode then
                    info.entry.gp = nil
                    refreshKeybindButton(id)
                end
            end
        end
        -- also scrub KB table entries that might not be in the UI map yet
        for name, entry in pairs(M.KB) do
            if type(entry) == "table" then
                local mapped = false
                for id, info in pairs(M.keybindButtons) do
                    if info.entry == entry then mapped = true break end
                end
                if not mapped then
                    if kind == "kb" and entry.kb == keycode then entry.kb = nil end
                    if kind == "gp" and entry.gp == keycode then entry.gp = nil end
                end
            end
        end
    end

    local function uiKeybindRow(parent, label, kbEntry, bindId)
        bindId = bindId or label
        local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,44)
        r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.42,0,0,44); l.BackgroundTransparency=1
        l.Text=label; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local btn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-150,0.5,-12), Size=UDim2.new(0,140,0,25),
            Text=formatKeybindText(kbEntry),
            Col=UI_TEXT_DIM, TS=10, CR=6})
        M.keybindButtons[bindId] = { btn = btn, entry = kbEntry }

        btn.MouseButton1Click:Connect(function()
            if activeKBId and activeKBId ~= bindId then resetKeybindCapture() end
            activeKBId = bindId
            btn.Text = "Press key / button..."
            btn.TextColor3 = Color3.fromRGB(150,150,150)
            M._anyKeyListening = true
            if listeningTimeout then pcall(function() task.cancel(listeningTimeout) end) end
            listeningTimeout = task.delay(8, resetKeybindCapture)
        end)
        return r
    end

    local function kbMatch(entry, keycode)
        if not entry or not keycode or keycode == Enum.KeyCode.Unknown then return false end
        if entry.kb and entry.kb == keycode then return true end
        if entry.gp and entry.gp == keycode then return true end
        return false
    end

    M._keybindCaptureConn = UIS.InputBegan:Connect(function(input, gameProcessed)
        -- Capture rebind
        if M._anyKeyListening then
            if activeKBId then
                local kc = input.KeyCode
                if kc == Enum.KeyCode.Escape then
                    resetKeybindCapture()
                    pcall(saveCherryConfig)
                    return
                end
                local info = M.keybindButtons[activeKBId]
                if not info or not info.entry then
                    resetKeybindCapture()
                    return
                end
                local uit = input.UserInputType
                if uit == Enum.UserInputType.Keyboard and kc ~= Enum.KeyCode.Unknown then
                    clearKeyFromOthers(activeKBId, "kb", kc)
                    info.entry.kb = kc
                    refreshKeybindButton(activeKBId)
                    activeKBId = nil
                    M._anyKeyListening = false
                    if listeningTimeout then pcall(function() task.cancel(listeningTimeout) end); listeningTimeout = nil end
                    pcall(saveCherryConfig)
                elseif isGamepadInputType(uit) and kc ~= Enum.KeyCode.Unknown then
                    clearKeyFromOthers(activeKBId, "gp", kc)
                    info.entry.gp = kc
                    refreshKeybindButton(activeKBId)
                    activeKBId = nil
                    M._anyKeyListening = false
                    if listeningTimeout then pcall(function() task.cancel(listeningTimeout) end); listeningTimeout = nil end
                    pcall(saveCherryConfig)
                end
            end
            return
        end

        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard and not isGamepadInputType(input.UserInputType) then return end
        local kc = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end

        -- One key → one action (elseif chain)
        if kbMatch(M.KB.LaggerToggle, kc) then
            local now = tick()
            if not M._lastLaggerBindPress or now - M._lastLaggerBindPress > 0.15 then
                M._lastLaggerBindPress = now
                M.cycleLaggerModeBind()
            end
        elseif kbMatch(M.KB.SpeedToggle, kc) then
            M.toggleCarryMode()
            saveCherryConfig()
        elseif kbMatch(M.KB.DropBrainrot, kc) then
            if M.KB.DropBrainrot and (M.KB.DropBrainrot.kb or M.KB.DropBrainrot.gp) then
                M.executeDropWithToggle()
            end
        elseif kbMatch(M.KB.TPFloor, kc) then
            M.runTPFloor() -- no cooldown
        elseif kbMatch(M.KB.PingLagger, kc) then
            if M.pingPanelOpen then
                if M.setPingActive then
                    M.setPingActive(not M.pingActive, true)
                else
                    M.pingActive = not M.pingActive
                end
            end
            if M.KB.PingLagger and M.KB.PingLagger.kb then M.pingKeybindKb = M.KB.PingLagger.kb.Name end
            if M.KB.PingLagger and M.KB.PingLagger.gp then M.pingKeybindGp = M.KB.PingLagger.gp.Name end
        elseif kbMatch(M.KB.AutoLeft, kc) then
            M.autoLeftEnabled = not M.autoLeftEnabled
            if M.autoLeftEnabled then
                if M.autoRightEnabled then M.autoRightEnabled = false; M.stopAutoRight() end
                if M.autoBatEnabled then M.stopBatAimbot() end
                M.startAutoLeft()
            else
                M.stopAutoLeft()
            end
            if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
            if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
            saveCherryConfig()
        elseif kbMatch(M.KB.AutoRight, kc) then
            M.autoRightEnabled = not M.autoRightEnabled
            if M.autoRightEnabled then
                if M.autoLeftEnabled then M.autoLeftEnabled = false; M.stopAutoLeft() end
                if M.autoBatEnabled then M.stopBatAimbot() end
                M.startAutoRight()
            else
                M.stopAutoRight()
            end
            if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
            if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
            saveCherryConfig()
        elseif kbMatch(M.KB.AutoBat, kc) then
            if not M.autoBatEnabled then
                if M.autoLeftEnabled then M.autoLeftEnabled = false; M.stopAutoLeft() end
                if M.autoRightEnabled then M.autoRightEnabled = false; M.stopAutoRight() end
                M.queueAutoBatStart()
            else
                M.stopBatAimbot()
            end
            if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled) end
            if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
            saveCherryConfig()
        elseif kbMatch(M.KB.BypassAimbot, kc) then
            M.toggleBypassAimbot()
            if M.setBypassVisual then M.setBypassVisual(M.bypassAimbotEnabled) end
            if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
            saveCherryConfig()
        elseif kbMatch(M.KB.AntiDie, kc) then
            M.antiDieManualEnabled = not M.antiDieManualEnabled
            if M.antiDieManualEnabled then
                M.antiDieEnabled = true
                pcall(function() M.startAntiDie() end)
            else
                pcall(function() M.syncCombatAntiDie() end)
            end
            if M.setAntiDieVisual then
                pcall(M.setAntiDieVisual, M.antiDieManualEnabled)
            end
            pcall(saveCherryConfig)
        elseif kbMatch(M.KB.GuiHide, kc) then
            if Frame then
                Frame.Visible = not Frame.Visible
                MinPill.Visible = not Frame.Visible
                M.menuOpen = Frame.Visible == true
                pcall(saveCherryConfig)
            end
        end
    end)

    -- ============================================================
    -- PAGINE
    -- ============================================================

    -- PAGE: SPEED
    uiSectionHeader(PM, "SPEEDS")
    -- Normal: manual carry (you choose Carry On when grabbing)
    local _, nsBox = uiNumberRow(PM, "Normal Speed", M.NS, 1, 500, function(v) M.NS = v; saveCherryConfig() end)
    local _, csBox = uiNumberRow(PM, "Normal Carry (STE)", M.CS, 1, 500, function(v) M.CS = v; saveCherryConfig() end)
    local _, lagBox = uiNumberRow(PM, "Lagger Speed", M.LAGGER_SPEED, 1, 500, function(v) M.LAGGER_SPEED = v; saveCherryConfig() end)
    local _, lagCarryBox = uiNumberRow(PM, "Lagger Carry Speed", M.LAGGER_CARRY_SPEED, 1, 500, function(v) M.LAGGER_CARRY_SPEED = v; saveCherryConfig() end)
    M.normalBox = nsBox; M.carryBox = csBox; M.laggerSpeedBox = lagBox; M.laggerCarrySpeedBox = lagCarryBox

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PM; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Carry Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local carryBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
            Text=M.carrySpeedActive and "Carry On" or "Carry Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
        carryBtn.MouseButton1Click:Connect(function()
            M.carrySpeedActive = not M.carrySpeedActive
            carryBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
            M.refreshSpeedModeLabel()
            if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
            if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
            if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
            if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
            saveCherryConfig()
        end)
        M.carryModeBtn = carryBtn
    end

    local _, setAutoCarry = uiToggleRow(PM, "Auto Switch Carry", M.autoSwitchSpeedEnabled, function(on)
        M.autoSwitchSpeedEnabled = on
        M._autoSwitchWasSteal = nil
        if not on then
            if M.carryModeBtn then
                M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
            end
            if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
        end
        M.refreshWalkSpeedAutoSwitch()
        saveCherryConfig()
    end)
    M.setAutoCarryVisual = setAutoCarry
    local _, setAutoCarryBase = uiToggleRow(PM, "Auto Carry on Enemy Base", M.autoCarryEnemyBaseEnabled, function(on)
        M.setAutoCarryEnemyBase(on); saveCherryConfig()
    end)
    M.setAutoCarryEnemyBaseVisual = setAutoCarryBase
    local _, acbRangeBox = uiNumberRow(PM, "Enemy Base Range", M.autoCarryEnemyBaseRange or 35, 5, 150, function(v)
        M.autoCarryEnemyBaseRange = v; saveCherryConfig()
    end)
    M.autoCarryEnemyBaseRangeBox = acbRangeBox
    -- PAGE: MECHANICS (contenuto completo con scroll funzionante)
    uiSectionHeader(PMech, "STUFF")
    local _, setHardHit = uiToggleRow(PMech, "Hard Hit", M.hardHitEnabled, function(on)
        if on then M.startHardHit() else M.stopHardHit() end
        saveCherryConfig()
    end)
    M.setHardHitVisual = setHardHit
    uiNumberRow(PMech, "Hard Hit Range", M.hardHitRadius or 10, 1, 100, function(v)
        M.hardHitRadius = v
        if M._hardHitRing then
            M._hardHitRing.Radius = v
            M._hardHitRing.InnerRadius = math.max(0.1, v - 0.35)
        end
        saveCherryConfig()
    end)
    local _, setBatAimbot = uiToggleRow(PMech, "Bat Aimbot", M.autoBatEnabled, function(on)
        if on then M.queueAutoBatStart() else M.stopBatAimbot() end
    end)
    M.autoBatSetVisual = setBatAimbot

    local _, setBatCounter = uiToggleRow(PMech, "Bat Counter", M.batCounterEnabled, function(on)
        M.batCounterEnabled = on
        if on then M.startBatCounter() else M.stopBatCounter() end
    end)
    M.setBatCounterVisual = setBatCounter

    local tpBatModeIdx = (M.tpBatHitMode == "Normal") and 2 or 1
    local _, setBypassVis, setTpBatModeUI = uiExpandToggleRow(
        PMech,
        "TP Bat",
        M.bypassAimbotEnabled,
        {"Sure Hit", "Normal Hit"},
        tpBatModeIdx,
        function(on)
            M.bypassAimbotEnabled = on
            if on then M.startBypassAimbot() else M.stopBypassAimbot() end
            if M.setBypassVisual then M.setBypassVisual(on) end
            if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(on) end
            saveCherryConfig()
        end,
        function(newMode)
            local wasOn = M.bypassAimbotEnabled
            if newMode == "Normal Hit" or newMode == "Normal" then
                M.tpBatHitMode = "Normal"
            else
                M.tpBatHitMode = "Sure"
            end
            if wasOn then
                M.stopBypassAimbot()
                task.wait()
                M.startBypassAimbot()
            end
            pcall(saveCherryConfig)
            if M.setTpBatModeUI then
                pcall(M.setTpBatModeUI, M.tpBatHitMode == "Normal" and "Normal Hit" or "Sure Hit")
            end
        end
    )
    M.setBypassVisual = setBypassVis
    M.setTpBatModeUI = setTpBatModeUI

    local _, setAntiRag = uiToggleRow(PMech, "Anti Ragdoll", M.antiRagdollEnabled, function(on)
        M.antiRagdollEnabled = on
        if on then M.startAntiRagdoll() else M.stopAntiRagdoll() end
    end)
    M.setAntiRagVisual = setAntiRag

    local _, setAntiRagModeUI = uiChoiceRow(PMech, "Anti Ragdoll Mode", {"Splatter","No Splatter"},
        M.antiRagdollMode == "No Splatter" and 2 or 1,
        function(newMode)
            M.antiRagdollMode = (newMode == "No Splatter") and "No Splatter" or "Splatter"
            if M.antiRagdollEnabled then M.stopAntiRagdoll(); M.startAntiRagdoll() end
        end
    )
    M.setAntiRagModeUI = setAntiRagModeUI

    local _, setMedusa = uiToggleRow(PMech, "Medusa Counter", M.medusaCounterEnabled, function(on)
        M.medusaCounterEnabled = on
        if on then
            M.setupMedusa(player.Character)
        else
            M.stopMedusaCounter()
        end
        saveCherryConfig()
    end)
    M.setMedusaVisual = setMedusa

    local _, setAutoSwing = uiToggleRow(PMech, "Auto Swing", M.autoSwingEnabled, function(on)
        M.autoSwingEnabled = on
    end)
    M.setAutoSwingVisual = setAutoSwing


    uiSectionHeader(PMech, "STEAL")
    local stealModeLabels = {"Normal", "Semi", "Normal V2"}
    local function stealLabelToMode(lab)
        if lab == "Normal" then return "Normal" end
        if lab == "Semi" then return "Semi" end
        return "V2"
    end
    local function stealModeToLabel(mode)
        if mode == "Normal" then return "Normal" end
        if mode == "Semi" then return "Semi" end
        return "Normal V2"
    end
    local stealDefaultIdx = 1
    do
        local lab = stealModeToLabel(M.stealMode)
        for i, v in ipairs(stealModeLabels) do if v == lab then stealDefaultIdx = i break end end
    end

    local _, setAutoSteal, setStealModeUI, regStealSettings = uiExpandToggleRow(
        PMech,
        "Auto Steal",
        M.Steal.AutoStealEnabled,
        stealModeLabels,
        stealDefaultIdx,
        function(on)
            M.Steal.AutoStealEnabled = on
            if on then M.startAutoSteal() else M.stopAutoSteal() end
        end,
        function(newLabel)
            local oldMode = M.stealMode
            local newMode = stealLabelToMode(newLabel)
            if oldMode ~= newMode then
                local wasEnabled = M.Steal.AutoStealEnabled
                if wasEnabled then M.stopAutoSteal() end
                M.stealMode = newMode
                if M.updateStatusModeBadge then pcall(M.updateStatusModeBadge) end
                M.updateStatusRadius()
                if wasEnabled then
                    task.defer(function()
                        if M.Steal.AutoStealEnabled then M.startAutoSteal() end
                    end)
                end
            else
                M.stealMode = newMode
                if M.updateStatusModeBadge then pcall(M.updateStatusModeBadge) end
                M.updateStatusRadius()
            end
            saveCherryConfig()
        end
    )
    M.setInstaGrab = setAutoSteal
    M.setStealModeUI = setStealModeUI

    -- V2 settings
    local v2Box = Instance.new("Frame"); v2Box.BackgroundTransparency=1; v2Box.Size=UDim2.new(1,0,0,0); v2Box.AutomaticSize=Enum.AutomaticSize.Y
    local v2Lay = Instance.new("UIListLayout"); v2Lay.Padding=UDim.new(0,6); v2Lay.Parent=v2Box
    local _, srBox = uiNumberRow(v2Box, "Grab Radius", M.Steal.StealRadius, 0.5, 300, function(v)
        M.Steal.StealRadius = v; M.setStealRadius(v); M.updateStatusRadius()
    end)
    M.radInput = srBox
    local _, sdBox = uiNumberRow(v2Box, "Hold Duration", M.Steal.StealDuration, 0.1, 10, function(v)
        M.Steal.StealDuration = v
    end)
    M.durationBox = sdBox
    local _, setAutoRadius = uiToggleRow(v2Box, "Auto Radius", M.autoRadiusEnabled, function(on)
        M.autoRadiusEnabled = on; M.updateStatusRadius()
    end)
    M.setAutoRadiusVisual = setAutoRadius
    regStealSettings("V2", v2Box)

    -- Semi settings
    local semiBox = Instance.new("Frame"); semiBox.BackgroundTransparency=1; semiBox.Size=UDim2.new(1,0,0,0); semiBox.AutomaticSize=Enum.AutomaticSize.Y
    local semiLay = Instance.new("UIListLayout"); semiLay.Padding=UDim.new(0,6); semiLay.Parent=semiBox
    local _, semiRadBox = uiNumberRow(semiBox, "Semi Radius (max 10)", math.min(M.Semi.radius,10), 0.5, 10, function(v)
        M.Semi.radius = math.min(v,10)
        if semiRadBox then semiRadBox.Text = tostring(M.Semi.radius) end
    end)
    M.semiRadInput = semiRadBox
    local _, semiHoldMin = uiNumberRow(semiBox, "Hold Min", M.Semi.holdMin or 1.3, 0.1, 5, function(v) M.Semi.holdMin = v end)
    local _, semiHoldMax = uiNumberRow(semiBox, "Hold Max", M.Semi.holdMax or 2.6, 0.1, 8, function(v) M.Semi.holdMax = v end)
    regStealSettings("Semi", semiBox)


    local _, sbBox = uiNumberRow(PMech, "Steal Bar Size", M.stealBarSize, 100, 800, function(v)
        M.stealBarSize = v; M.buildStatusUI()
    end)

    uiSectionHeader(PMech, "MOTION")
    local jumpDefaultIdx = (M.infJumpMode == "hold") and 2 or 1
    local _, setInfJump, setJumpModeUI = uiExpandToggleRow(
        PMech,
        "Infinite Jump",
        M.infJumpEnabled,
        {"Manual", "Hold"},
        jumpDefaultIdx,
        function(on)
            M.infJumpEnabled = on
            if on and M.infJumpMode == "manual" then M.startManualInfJumpLoop()
            elseif on and M.infJumpMode == "hold" then M.startHoldInfJump()
            else M.stopManualInfJumpLoop(); M.stopHoldInfJump() end
        end,
        function(newMode)
            local wasOn = M.infJumpEnabled
            M.infJumpMode = (newMode == "Hold") and "hold" or "manual"
            if wasOn then
                M.stopManualInfJumpLoop(); M.stopHoldInfJump()
                if M.infJumpMode == "manual" then M.startManualInfJumpLoop()
                else M.startHoldInfJump() end
            end
        end
    )
    M.setInfJumpVisual = setInfJump
    M.setJumpModeUI = setJumpModeUI


    local _, setAL = uiToggleRow(PMech, "Auto Left", M.autoLeftEnabled, function(on)
        if on then
            if M.autoRightEnabled then M.autoRightEnabled=false; M.stopAutoRight(); if M.autoRightSetVisual then M.autoRightSetVisual(false) end end
            if M.autoBatEnabled then M.stopBatAimbot(); if M.autoBatSetVisual then M.autoBatSetVisual(false) end end
            M.autoLeftEnabled=true; M.startAutoLeft()
        else M.autoLeftEnabled=false; M.stopAutoLeft() end
        if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(on) end
    end)
    M.autoLeftSetVisual = setAL

    local _, setAR = uiToggleRow(PMech, "Auto Right", M.autoRightEnabled, function(on)
        if on then
            if M.autoLeftEnabled then M.autoLeftEnabled=false; M.stopAutoLeft(); if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end end
            if M.autoBatEnabled then M.stopBatAimbot(); if M.autoBatSetVisual then M.autoBatSetVisual(false) end end
            M.autoRightEnabled=true; M.startAutoRight()
        else M.autoRightEnabled=false; M.stopAutoRight() end
        if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(on) end
    end)
    M.autoRightSetVisual = setAR

    local _, setATP = uiToggleRow(PMech, "Auto TP Down", M.autoTPEnabled, function(on)
        M.autoTPEnabled = on
        if on then M.startAutoTP() else M.stopAutoTP() end
    end)
    M.setAutoTPVisual = setATP

    local _, tpHBox = uiNumberRow(PMech, "TP Height", M.autoTPHeight, 1, 100, function(v) M.autoTPHeight = v end)
    M.autoTPHeightBox = tpHBox

    -- PAGE: VISUALS
    uiSectionHeader(PVis, "SKY & VISION")
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PVis; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.55,0,1,0)
        l.BackgroundTransparency=1; l.Text="Sky Theme"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local skyLbl = Instance.new("TextLabel"); skyLbl.Position=UDim2.new(0.55,0,0,0); skyLbl.Size=UDim2.new(0.45,-10,1,0)
        skyLbl.BackgroundTransparency=1; skyLbl.Text=M.currentSkyTheme; skyLbl.TextColor3=UI_ACCENT; skyLbl.Font=Enum.Font.GothamBold; skyLbl.TextSize=12; skyLbl.TextXAlignment=Enum.TextXAlignment.Right; skyLbl.Parent=r
        local skyIdx = 1
        for i,t in ipairs(M.SkyOrder) do if t == M.currentSkyTheme then skyIdx = i; break end end
        local btn = Instance.new("TextButton",r); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
        btn.Activated:Connect(function()
            skyIdx = skyIdx % #M.SkyOrder + 1
            local t = M.SkyOrder[skyIdx]
            skyLbl.Text = t; M.currentSkyTheme = t; M.CandyApplyCustomSky(t); saveCherryConfig()
        end)
    end
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PVis; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.55,0,1,0)
        l.BackgroundTransparency=1; l.Text="FOV"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local fovLbl = Instance.new("TextLabel"); fovLbl.Position=UDim2.new(0.55,0,0,0); fovLbl.Size=UDim2.new(0.45,-10,1,0)
        fovLbl.BackgroundTransparency=1; fovLbl.Text=tostring(M.fovValue); fovLbl.TextColor3=UI_ACCENT; fovLbl.Font=Enum.Font.GothamBold; fovLbl.TextSize=12; fovLbl.TextXAlignment=Enum.TextXAlignment.Right; fovLbl.Parent=r
        local fovIdx = 1
        local btn = Instance.new("TextButton",r); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
        btn.Activated:Connect(function()
            fovIdx = fovIdx % #M.fovOptions + 1
            M.fovValue = M.fovOptions[fovIdx]; fovLbl.Text = tostring(M.fovValue); M.applyFOV(); saveCherryConfig()
        end)
    end

    uiSectionHeader(PVis, "Customize ESP")
    local _, setHighlightESP = uiToggleRow(PVis, "Aura (Highlight)", M.highlightESPEnabled, function(on)
        M.highlightESPEnabled = on
        cherryESPState.HighlightESP = on
        saveCherryConfig()
    end)
    local _, setLineESP = uiToggleRow(PVis, "Line ESP", M.lineESPEnabled, function(on)
        M.lineESPEnabled = on
        cherryESPState.LineESP = on
        saveCherryConfig()
    end)
    local _, setHitboxESP = uiToggleRow(PVis, "Hitbox", M.hitboxESPEnabled, function(on)
        M.hitboxESPEnabled = on
        cherryESPState.HitboxESP = on
        saveCherryConfig()
    end)
    local _, setSpeedESP = uiToggleRow(PVis, "Speed ESP", M.speedESPEnabled, function(on)
        M.speedESPEnabled = on
        cherryESPState.SpeedESP = on
        saveCherryConfig()
    end)

    -- PAGE: UTILITY
    uiSectionHeader(PUtil, "ANTI DIE")
    local _, setAntiDie = uiToggleRow(PUtil, "Anti Die", M.antiDieManualEnabled == true, function(on)
        M.antiDieManualEnabled = on == true
        if M.antiDieManualEnabled then
            M.antiDieEnabled = true
            pcall(function() M.startAntiDie() end)
        else
            pcall(function() M.syncCombatAntiDie() end)
        end
        saveCherryConfig()
    end)
    M.setAntiDieVisual = setAntiDie
    uiKeybindRow(PUtil, "Anti Die Key", M.KB.AntiDie, "AntiDie")

    uiSectionHeader(PUtil, "MISC")
    local _, setUnwalk = uiToggleRow(PUtil, "Unwalk", M.unwalkEnabled, function(on)
        M.unwalkEnabled = on
        if on then M.startUnwalk() else M.stopUnwalk() end
    end)
    M.setUnwalkVisual = setUnwalk

    local _, setAntiLag = uiToggleRow(PUtil, "Performance Mode", M.antiLagEnabled, function(on)
        M.antiLagEnabled = on
        if on then M.enableAntiLag() else M.disableAntiLag() end
        saveCherryConfig()
    end)
    M.setAntiLagVisual = setAntiLag

    local _, setAntiSummer = uiToggleRow(PUtil, "Anti Summer Base", M.antiSummerBaseEnabled, function(on)
        M.antiSummerBaseEnabled = on
        if on then M.enableAntiSummerBase() else M.disableAntiSummerBase() end
        saveCherryConfig()
    end)
    M.setAntiSummerVisual = setAntiSummer

    local _, setStretch = uiToggleRow(PUtil, "Wide View", M.stretchRezEnabled, function(on)
        M.stretchRezEnabled = on
        if on then M.enableStretchRez() else M.disableStretchRez() end
        saveCherryConfig()
    end)
    M.setStretchRezVisual = setStretch

    local _, setRemoveAcc = uiToggleRow(PUtil, "Remove Accessories", M.removeAccEnabled, function(on)
        M.removeAccEnabled = on
        if on then M.startRemoveAcc() else M.stopRemoveAcc() end
    end)

    local _, setAntiKick = uiToggleRow(PUtil, "Anti-Kick", M.antiKickEnabled, function(on)
        M.antiKickEnabled = on
        if on then M.enableAntiKick() else M.disableAntiKick() end
        saveCherryConfig()
    end)
    M.antiKickSetVisual = setAntiKick

    local _, setSafeMode = uiToggleRow(PUtil, "Safe Mode", M.safeModeEnabled, function(on)
        M.safeModeEnabled = on
        if on then M.enableSafeMode() else M.disableSafeMode() end
        saveCherryConfig()
    end)
    M.setSafeModeVisual = setSafeMode

    local _, setIntro = uiToggleRow(PUtil, "Intro Song", M.introSoundEnabled, function(on)
        M.introSoundEnabled = on
        if not on and introSoundInstance and introSoundInstance.IsPlaying then
            pcall(function() introSoundInstance:Stop() end)
        end
    end)

    local _, setIntroSongUI = uiChoiceRow(PUtil, "Intro Song Choice", {"Song 1","Song 2","Song 3"},
        M.introSongChoice or 3,
        function(v)
            local map = {["Song 1"]=1, ["Song 2"]=2, ["Song 3"]=3}
            M.introSongChoice = map[v] or 3
        end
    )

    local _, setIntroGUI = uiToggleRow(PUtil, "Intro GUI", M.introGUIEnabled, function(on)
        M.introGUIEnabled = on
    end)

    local _, setMobBtns = uiToggleRow(PUtil, "Mobile Buttons", M.mobileButtonsEnabled, function(on)
        M.mobileButtonsEnabled = on
        if on then M.buildMobileButtons() else M.destroyMobileButtons() end
        saveCherryConfig()
    end)

    local _, setCircleBtns = uiToggleRow(PUtil, "Circle Buttons", M.circleButtonsEnabled, function(on)
        M.circleButtonsEnabled = on
        if M.mobileButtonsEnabled then M.buildMobileButtons() end
        saveCherryConfig()
    end)
    M.setCircleBtnsVisual = setCircleBtns

    local _, setLockMob = uiToggleRow(PUtil, "Lock Mobile Buttons", M.mobileButtonsLocked == true, function(on)
        M.mobileButtonsLocked = on and true or false
        saveCherryConfig()
    end)
    M.setLockMobVisual = setLockMob

    local _, btnSzBox = uiNumberRow(PUtil, "Button Size", M.mobileButtonsSize, 40, 150, function(v)
        M.mobileButtonsSize = v
        if M.mobileButtonsEnabled then M.buildMobileButtons() end
    end)

    local _, menuScaleBox = uiNumberRow(PUtil, "Menu Scale", M.uiScale, 0.5, 2.0, function(v)
        M.uiScale = v
        if M.uiScaleRef then M.uiScaleRef.Scale = v end
        saveCherryConfig()
    end)

    uiActionRow(PUtil, "Reset Mobile Positions", function() M.resetMobilePositions() end)

    uiSectionHeader(PUtil, "CHARTER")
    local function setAnimToggle(packName, on)
        if on then
            M.animPackEnabled = true
            M.animPack = packName
            M.applyAnimPack(packName)
            if packName == "Vampire" and M.setAmazonAnimVisual then M.setAmazonAnimVisual(false) end
            if packName == "Amazon Unboxed" and M.setVampireAnimVisual then M.setVampireAnimVisual(false) end
        else
            if M.animPack == packName then
                M.animPackEnabled = false
                local char = player.Character
                if char then M.resetAnimations(char) end
            end
        end
        saveCherryConfig()
    end

    local _, setVampireAnim = uiToggleRow(PUtil, "Vampire Animation",
        M.animPackEnabled and M.animPack == "Vampire",
        function(on) setAnimToggle("Vampire", on) end)
    M.setVampireAnimVisual = setVampireAnim

    local _, setAmazonAnim = uiToggleRow(PUtil, "Amazon Unboxed Animation",
        M.animPackEnabled and M.animPack == "Amazon Unboxed",
        function(on) setAnimToggle("Amazon Unboxed", on) end)
    M.setAmazonAnimVisual = setAmazonAnim

    local _, setVyncSkin = uiToggleRow(PUtil, "Vync Skin", M.vyncSkinEnabled == true, function(on)
        M.setVyncSkin(on)
    end)
    M.setVyncSkinVisual = setVyncSkin

    local _, setHeadless = uiToggleRow(PUtil, "Headless", M.headlessEnabled, function(on)
        M.headlessEnabled = on
        M.applyHeadlessToChar(player.Character, on)
        saveCherryConfig()
    end)
    local _, setKorblox = uiToggleRow(PUtil, "Korblox", M.korbloxEnabled, function(on)
        M.korbloxEnabled = on
        M.applyKorbloxToChar(player.Character, on)
        saveCherryConfig()
    end)
    local _, setBlackSkin = uiToggleRow(PUtil, "ZEYHUBB Black Skin", M.zeyhubbBlackSkinEnabled ~= false, function(on)
        M.zeyhubbBlackSkinEnabled = on
        if on and player.Character then M.applyZeyHubbBlackSkin(player.Character) end
        saveCherryConfig()
    end)
    local _, setGirlAnim = uiToggleRow(PUtil, "Girl Animation (Bubbly)", M.animPackEnabled and M.animPack == "Bubbly", function(on)
        if on then
            M.animPackEnabled = true
            M.animPack = "Bubbly"
            M.applyAnimPack("Bubbly")
            if M.setVampireAnimVisual then M.setVampireAnimVisual(false) end
            if M.setAmazonAnimVisual then M.setAmazonAnimVisual(false) end
        else
            if M.animPack == "Bubbly" then
                M.animPackEnabled = false
                if player.Character then M.resetAnimations(player.Character) end
            end
        end
        saveCherryConfig()
    end)

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PUtil; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Save Config"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local sBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-80,0.5,-13), Size=UDim2.new(0,68,0,26),
            Text="SAVE", Col=Color3.fromRGB(40, 40, 40), TS=12, CR=6, SC=Color3.fromRGB(0, 0, 0), STr=0.2})
        sBtn.Activated:Connect(function()
            saveCherryConfig()
            sBtn.Text = "OK"
            task.delay(0.8, function() if sBtn and sBtn.Parent then sBtn.Text = "SAVE" end end)
        end)
    end
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PUtil; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Reset All Settings"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local rBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-80,0.5,-13), Size=UDim2.new(0,68,0,26),
            Text="RESET", Col=Color3.fromRGB(40, 40, 40), TS=12, CR=6, SC=Color3.fromRGB(0, 0, 0), STr=0.2})
        rBtn.Activated:Connect(function() M.resetAllSettings() end)
    end

    -- Restore saved manual Anti Die after all controls/functions exist.
    if M.antiDieManualEnabled then
        task.defer(function()
            if M.antiDieManualEnabled then
                M.antiDieEnabled = true
                pcall(function() M.startAntiDie() end)
                if M.setAntiDieVisual then pcall(M.setAntiDieVisual, true) end
            end
        end)
    end

    -- PAGE: KEYBINDS
    uiSectionHeader(PKB, "KEYBINDS")
    uiKeybindRow(PKB, "Hide GUI", M.KB.GuiHide, "GuiHide")
    uiKeybindRow(PKB, "Carry Mode", M.KB.SpeedToggle, "SpeedToggle")
    uiKeybindRow(PKB, "Bat Aimbot", M.KB.AutoBat, "AutoBat")
    uiKeybindRow(PKB, "TP Bat", M.KB.BypassAimbot, "BypassAimbot")
    uiKeybindRow(PKB, "Auto Left", M.KB.AutoLeft, "AutoLeft")
    uiKeybindRow(PKB, "Auto Right", M.KB.AutoRight, "AutoRight")
    uiKeybindRow(PKB, "Drop Brainrot", M.KB.DropBrainrot, "DropBrainrot")
    uiKeybindRow(PKB, "TP Down", M.KB.TPFloor, "TPFloor")
    uiKeybindRow(PKB, "Insta Reset", M.KB.InstaReset, "InstaReset")
    uiKeybindRow(PKB, "Anti Die", M.KB.AntiDie, "AntiDie")


    -- Restore menu open/closed from config
    do
        local open = M.menuOpen ~= false
        Frame.Visible = open
        MinPill.Visible = not open
        M.menuOpen = open
        if open then
            Frame.AnchorPoint = Vector2.new(0, 0.5)
            Frame.Position = UDim2.new(0, 2, 0.5, 0)
        end
    end

    -- APPLY INITIAL STATES
    M.applyStealBarTheme(CHERRY_ACCENT)
    M.updateHeadTheme()
    M.applyFOV()

    -- FPS / Ping header updater
    task.spawn(function()
        local last = tick()
        local frames = 0
        local fps = 60
        RunService.RenderStepped:Connect(function()
            frames = frames + 1
            local now = tick()
            if now - last >= 0.5 then
                fps = math.floor(frames / (now - last) + 0.5)
                frames = 0
                last = now
                if M.headerStatsLbl then
                    local ping = 0
                    pcall(function()
                        ping = math.floor(player:GetNetworkPing() * 1000 + 0.5)
                    end)
                    M.headerStatsLbl.Text = string.format("FPS: %d  Ping: %dms", fps, ping)
                end
                if M.headerRadiusLbl and M.getActiveStealRadius then
                    M.headerRadiusLbl.Text = tostring(M.getActiveStealRadius())
                end
            end
        end)
    end)

    M.autoTPHeightBox = tpHBox
    M.radInput = srBox
    M.durationBox = sdBox
    M.btnSzBox = btnSzBox
    M.sbBox = sbBox

    if M.setAntiRagVisual then M.setAntiRagVisual(M.antiRagdollEnabled) end
        if M.setSafeModeVisual then M.setSafeModeVisual(M.safeModeEnabled) end
    if M.setAutoCarryVisual then M.setAutoCarryVisual(M.autoSwitchSpeedEnabled) end
if M.setCircleBtnsVisual then M.setCircleBtnsVisual(M.circleButtonsEnabled) end
    if M.safeModeEnabled then M.enableSafeMode() end
    if M.antiKickEnabled then M.enableAntiKick() end

    if M.setAntiRagModeUI then M.setAntiRagModeUI(M.antiRagdollMode == "No Splatter" and "No Splatter" or "Splatter") end
    if M.setInfJumpVisual then M.setInfJumpVisual(M.infJumpEnabled) end
    if M.setMedusaVisual then M.setMedusaVisual(M.medusaCounterEnabled) end
    if M.setMedusaResetVisual then M.setMedusaResetVisual(M.medusaResetEnabled) end
    if M.setBatCounterVisual then M.setBatCounterVisual(M.batCounterEnabled) end
    if M.setUnwalkVisual then M.setUnwalkVisual(M.unwalkEnabled) end
    if M.setAntiLagVisual then M.setAntiLagVisual(M.antiLagEnabled) end
    if M.setAntiSummerVisual then M.setAntiSummerVisual(M.antiSummerBaseEnabled) end
    if M.setStretchRezVisual then M.setStretchRezVisual(M.stretchRezEnabled) end
    if M.setAutoTPVisual then M.setAutoTPVisual(M.autoTPEnabled) end
    if M.antiKickSetVisual then M.antiKickSetVisual(M.antiKickEnabled) end
    if M.setInstaGrab then M.setInstaGrab(M.Steal.AutoStealEnabled) end
    if M.setAutoRadiusVisual then M.setAutoRadiusVisual(M.autoRadiusEnabled) end
    if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled) end
    if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
    if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
    if M.setAutoSwingVisual then M.setAutoSwingVisual(M.autoSwingEnabled) end
    if M.setBypassVisual then M.setBypassVisual(M.bypassAimbotEnabled) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
    if M.setAutoResetOnDeath then M.setAutoResetOnDeath(M.autoResetOnDeath) end
    if M.headlessEnabled then M.applyHeadlessToChar(player.Character, true) end
    if M.korbloxEnabled then M.applyKorbloxToChar(player.Character, true) end
    if M.setStealModeUI then
        local lab = (M.stealMode == "Normal") and "Normal" or ((M.stealMode == "Semi") and "Semi" or "Normal V2")
        M.setStealModeUI(lab)
    end
    if M.setJumpModeUI then M.setJumpModeUI(M.infJumpMode == "hold" and "Hold" or "Manual") end
    if M.setTpBatModeUI then M.setTpBatModeUI(M.tpBatHitMode == "Normal" and "Normal Hit" or "Sure Hit") end
    if M.setVampireAnimVisual then M.setVampireAnimVisual(M.animPackEnabled and M.animPack == "Vampire") end
    if M.setAmazonAnimVisual then M.setAmazonAnimVisual(M.animPackEnabled and M.animPack == "Amazon Unboxed") end
    if M.animPackEnabled then
        task.wait(0.5); M.applyAnimPack(M.animPack)
    else
        local char = player.Character; if char then M.resetAnimations(char) end
    end

    cherryESPState.LineESP = M.lineESPEnabled
    cherryESPState.SpeedESP = M.speedESPEnabled
    cherryESPState.HighlightESP = M.highlightESPEnabled == true
    cherryESPState.HitboxESP = M.hitboxESPEnabled == true

    M.updateStatusRadius()
    M.startHeadSpeedUpdates()
end

function M.applyStealBarTheme(accentColor)
    local red = Color3.fromRGB(220, 0, 0)
    if M.statusFill then
        M.statusFill.BackgroundColor3 = red
        local grad = M.statusFill:FindFirstChild("FillColorGrad")
        if grad and grad:IsA("UIGradient") then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 20)),
                ColorSequenceKeypoint.new(0.5, red),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 0, 0)),
            })
        end
    end
    if M.statusMain then
        M.statusMain.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        M.statusMain.BackgroundTransparency = 0.08
    end
    if M.statusBgImg then
        M.statusBgImg.Visible = true
    end
end


function M.resetAllSettings()
    M.NS = 60
    M.CS = 30
    M.speedMethod = "Velocity"
    M.hyperMult = 4
    M._lastSpeedMethod = nil
    M._anchoredBySpeed = nil
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    M.antiRagdollEnabled = false
M.hardHitEnabled = false
M.hardHitRadius = 10
    M.antiRagdollMode = "Splatter"
    M.infJumpEnabled = false
    M.infJumpMode = "manual"
    M.medusaCounterEnabled = false
    M.batCounterEnabled = false
    M.unwalkEnabled = false
    M.medusaResetEnabled = false
    M.medusaDebounce = false
    M.medusaLastUsed = 0
    M.autoLeftEnabled = false
    M.autoRightEnabled = false
    M.autoBatEnabled = false
    M.autoSwingEnabled = true
    M.autoMoveSwingEnabled = false
    M.antiLagEnabled = false
    M.removeAccessoriesEnabled = false
    M.stretchRezEnabled = false
    M.autoTPEnabled = false
    M.autoTPHeight = 20
    M.guiTransparencyEnabled = false
    M.mobileButtonsEnabled = true
    M.mobileButtonsSize = 100
    M.circleButtonsEnabled = false
    M.fovValue = 80
    M.fovIndex = 1
    M.autoSwitchSpeedEnabled = false
    M.antiKickEnabled = false
    M.brainrotDetected = false
    M.ragdollGuiEnabled = true
    M.introSoundEnabled = true
    M.introSongChoice = 3
    M.introGUIEnabled = true
    M.Steal.AutoStealEnabled = false
    M.autoRadiusEnabled = false
    M.Steal.StealRadius = 60
    M.Steal.StealDuration = 1.4
    M.Steal.StopTime = 0.35
    M.stealMode = "V2"
    M.Semi.holdMin = 1.3
    M.Semi.holdMax = 2.6
    M.Semi.entryDelay = 0.3
    M.Semi.radius = 10
    M.Semi.primeRange = 80
    M.removeAccEnabled = false
    M.playerESPEnabled = false
    M.showPlayerSpeeds = false
    M.uiScale = 0.95
    M.perButtonDragEnabled = true
    M.stealBarSize = 460
    M._stealBarPos = nil
    M.lineESPEnabled = false
    M.speedESPEnabled = false
    M.autoResetOnDeath = false
    M.animPack = "Vampire"
    M.headlessEnabled = false
    M.korbloxEnabled = false
    M.bypassAimbotEnabled = false
    M.animPackEnabled = false

    M.stopAutoSteal()
    M.stopBatAimbot()
    M.stopAutoLeft()
    M.stopAutoRight()
    M.stopAntiRagdoll()
    M.stopHoldInfJump()
    M.stopManualInfJumpLoop()
    M.stopMedusaCounter()
    M.stopBatCounter()
    M.stopUnwalk()
    M.disableAntiLag()
    M.disableStretchRez()
    M.stopAutoTP()
    M.disableAntiKick()
    M.stopBypassAimbot()
    M.stopRemoveAcc()
    M.toggleESP(false)
    M.togglePlayerSpeeds(false)
    M.autoResetOnDeath = false
    setupDeathReset()

    saveCherryConfig()
    M.buildGui()
end

-- ============================================================
-- INITIALIZATION
-- ============================================================
repeat task.wait() until game:IsLoaded()
task.wait(0.5)
loadCherryConfig()
if M._savedTheme and CHERRY_THEMES[M._savedTheme] then
    CherryConfig.Theme = M._savedTheme
    M.colorScheme = M._savedTheme
elseif M.colorScheme and CHERRY_THEMES[M.colorScheme] then
    CherryConfig.Theme = M.colorScheme
    M._savedTheme = M.colorScheme
end
applyAccentFromTheme()
pcall(saveCherryConfig)
M.buildGui() -- applies M.menuOpen (closed stays closed)
pcall(function()
    if M.applyStealBarTheme then M.applyStealBarTheme(UI_ACCENT) end
    if M.updateHeadTheme then M.updateHeadTheme() end
    if M.mainFrame then M.recolorBlacksToTheme(M.mainFrame) end
    -- keep auto steal pure black
end)
if M.mobileButtonsEnabled then M.buildMobileButtons() end
if M.antiRagdollEnabled then M.startAntiRagdoll() end
    if M.hardHitEnabled then M.startHardHit() end
    if M.setHardHitVisual then M.setHardHitVisual(M.hardHitEnabled) end
if M.infJumpEnabled then
    if M.infJumpMode=="manual" then M.startManualInfJumpLoop()
    elseif M.infJumpMode=="hold" then M.startHoldInfJump() end
end
if M.medusaCounterEnabled then M.setupMedusa(player.Character) end
if M.batCounterEnabled then M.startBatCounter() end
if M.unwalkEnabled then M.startUnwalk() end
if M.autoTPEnabled then M.startAutoTP() end
if M.autoBatEnabled then M.queueAutoBatStart() end
if M.autoLeftEnabled then M.startAutoLeft() end
if M.autoRightEnabled then M.startAutoRight() end
if M.Steal.AutoStealEnabled then M.startAutoSteal() end
if M.bypassAimbotEnabled then M.startBypassAimbot() end
if M.antiKickEnabled then M.enableAntiKick() end
if M.antiLagEnabled then M.enableAntiLag() end
if M.antiSummerBaseEnabled then M.enableAntiSummerBase() end
if M.stretchRezEnabled then M.enableStretchRez() end
if M.removeAccEnabled then M.startRemoveAcc() end
-- autoResetOnDeath removed

if M.playerESPEnabled and M.toggleESP then
    task.defer(function() pcall(function() M.toggleESP(true) end) end)
end
if M.animPackEnabled and M.animPack and M.PACKS[M.animPack] then
    task.wait(0.5)
    M.applyAnimPack(M.animPack)
else
    local char = player.Character
    if char then
        M.resetAnimations(char)
    end
end

if M.headlessEnabled or M.korbloxEnabled then
    task.wait(0.3)
    M.applyCharterToChar(player.Character)
end

M.CandyApplyCustomSky(M.currentSkyTheme)
if M.showPlayerSpeeds then M.togglePlayerSpeeds(true) end
if M.playerESPEnabled then M.toggleESP(true) end

M.updateStatusRadius()
M.startHeadSpeedUpdates()

if player.Character then
    M.setupHeadIndicator(player.Character)
    M.setupRagdollTriggers()
end
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    M.setupHeadIndicator(char)
    if M.hardHitEnabled then task.defer(function() M.hideHardHitRing(); M.showHardHitRing() end) end
    M.setupRagdollTriggers()
    if M.medusaCounterEnabled then M.setupMedusa(char) end
    if M.batCounterEnabled then M.startBatCounter() end
    if M.unwalkEnabled then task.wait(0.5); M.startUnwalk() end
    -- autoResetOnDeath removed
    if M.animPackEnabled and M.animPack and M.PACKS[M.animPack] then
        task.wait(0.2)
        M.applyAnimPack(M.animPack)
    else
        M.resetAnimations(char)
    end
    if M.headlessEnabled or M.korbloxEnabled then
        task.wait(0.2)
        M.applyCharterToChar(char)
    end
    if M.bypassAimbotEnabled then
        task.wait(0.2)
        M.startBypassAimbot()
    end
end)

-- Lightweight no-collide (no GetDescendants every frame — avoids lag/ping spikes)
do
    local _ncAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        _ncAcc = _ncAcc + dt
        if _ncAcc < 0.35 then return end
        _ncAcc = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CanCollide = false end
                local head = p.Character:FindFirstChild("Head")
                if head then head.CanCollide = false end
            end
        end
    end)
end

local function destroySpeedObjects()
    if M._anchoredBySpeed then pcall(function() M._anchoredBySpeed.Anchored = false end); M._anchoredBySpeed = nil end
    if M._bodyVel then pcall(function() M._bodyVel:Destroy() end); M._bodyVel = nil end
    if M._bodyPosition then pcall(function() M._bodyPosition:Destroy() end); M._bodyPosition = nil end
    if M._bodyForce then pcall(function() M._bodyForce:Destroy() end); M._bodyForce = nil end
    if M._bodyThrust then pcall(function() M._bodyThrust:Destroy() end); M._bodyThrust = nil end
    if M._linearVel then pcall(function() M._linearVel:Destroy() end); M._linearVel = nil end
    if M._vectorForce then pcall(function() M._vectorForce:Destroy() end); M._vectorForce = nil end
    if M._alignPos then pcall(function() M._alignPos:Destroy() end); M._alignPos = nil end
    if M._rocket then pcall(function() M._rocket:Destroy() end); M._rocket = nil end
    if M._rocketTarget then pcall(function() M._rocketTarget:Destroy() end); M._rocketTarget = nil end
    if M._attLinVel then pcall(function() M._attLinVel:Destroy() end); M._attLinVel = nil end
    if M._attVecForce then pcall(function() M._attVecForce:Destroy() end); M._attVecForce = nil end
    if M._attAlign then pcall(function() M._attAlign:Destroy() end); M._attAlign = nil end
    if M._speedTween then pcall(function() M._speedTween:Cancel() end); M._speedTween = nil end
end

local function ensureSpeedAttachment(hrp, key, name)
    local att = M[key]
    if not att or att.Parent ~= hrp then
        if att then pcall(function() att:Destroy() end) end
        att = Instance.new("Attachment")
        att.Name = name or "MoveeSpeedAtt"
        att.Parent = hrp
        M[key] = att
    end
    return att
end

local function applySpeedMethod(hrp, hum, dir, spd, dt)
    local step = dt or 1/60
    local m = M.speedMethod
    if M._lastSpeedMethod ~= m then
        destroySpeedObjects()
        if m ~= "WalkSpeed" and hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
        M._lastSpeedMethod = m
    end
    local char = hrp.Parent
    local targetPos = hrp.Position + (dir * spd * step)

    local function massImpulse(direction, targetSpeed)
        local mass = hrp.AssemblyMass or 1
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(direction.X * targetSpeed, current.Y, direction.Z * targetSpeed)
        local delta = desired - current
        pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end)
    end

    if m == "Velocity" then
        massImpulse(dir, spd)
    elseif m == "AssemblyLinearVelocity" then
        massImpulse(dir, spd)
    elseif m == "Velocity Lerp" then
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd)
        local blended = current:Lerp(desired, 0.6)
        local mass = hrp.AssemblyMass or 1
        pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end)
    elseif m == "AssemblyLinearVelocity Lerp" then
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd)
        local blended = current:Lerp(desired, 0.6)
        local mass = hrp.AssemblyMass or 1
        pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end)
    elseif m == "CFrame" then
        hrp.CFrame = hrp.CFrame + (dir * spd * step)
    elseif m == "CFrame Lerp" then
        hrp.CFrame = hrp.CFrame:Lerp(hrp.CFrame + (dir * spd * step), 0.5)
    elseif m == "Hyper CFrame" then
        hrp.CFrame = hrp.CFrame + (dir * spd * (M.hyperMult or 4) * step)
    elseif m == "Anchored CFrame" then
        if not hrp.Anchored then
            hrp.Anchored = true
            M._anchoredBySpeed = hrp
        end
        hrp.CFrame = hrp.CFrame + (dir * spd * step)
    elseif m == "PivotTo" then
        hrp:PivotTo(hrp.CFrame + (dir * spd * step))
    elseif m == "Model PivotTo" then
        if char and char:IsA("Model") then
            char:PivotTo(char:GetPivot() + (dir * spd * step))
        else
            hrp:PivotTo(hrp.CFrame + (dir * spd * step))
        end
    elseif m == "Tween CFrame" then
        if M._speedTween then pcall(function() M._speedTween:Cancel() end) end
        M._speedTween = TweenService:Create(hrp, TweenInfo.new(step, Enum.EasingStyle.Linear), {CFrame = hrp.CFrame + (dir * spd * step)})
        M._speedTween:Play()
    elseif m == "WalkSpeed" then
        hum.WalkSpeed = spd
    elseif m == "Humanoid Move" then
        hum.WalkSpeed = spd
        hum:Move(dir)
    elseif m == "Humanoid MoveTo" then
        hum:MoveTo(targetPos, hrp)
    elseif m == "BodyVelocity" then
        if not M._bodyVel or M._bodyVel.Parent ~= hrp then
            if M._bodyVel then pcall(function() M._bodyVel:Destroy() end) end
            M._bodyVel = Instance.new("BodyVelocity")
            M._bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            M._bodyVel.Parent = hrp
        end
        M._bodyVel.Velocity = Vector3.new(dir.X*spd, M._bodyVel.Velocity.Y, dir.Z*spd)
    elseif m == "BodyPosition" then
        if not M._bodyPosition or M._bodyPosition.Parent ~= hrp then
            if M._bodyPosition then pcall(function() M._bodyPosition:Destroy() end) end
            M._bodyPosition = Instance.new("BodyPosition")
            M._bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            M._bodyPosition.P = 500
            M._bodyPosition.D = 50
            M._bodyPosition.Parent = hrp
        end
        M._bodyPosition.Position = targetPos
    elseif m == "BodyForce" then
        if not M._bodyForce or M._bodyForce.Parent ~= hrp then
            if M._bodyForce then pcall(function() M._bodyForce:Destroy() end) end
            M._bodyForce = Instance.new("BodyForce")
            M._bodyForce.Parent = hrp
        end
        M._bodyForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
    elseif m == "BodyThrust" then
        if not M._bodyThrust or M._bodyThrust.Parent ~= hrp then
            if M._bodyThrust then pcall(function() M._bodyThrust:Destroy() end) end
            M._bodyThrust = Instance.new("BodyThrust")
            M._bodyThrust.Force = Vector3.new(math.huge, math.huge, math.huge)
            M._bodyThrust.Parent = hrp
        end
        M._bodyThrust.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
    elseif m == "LinearVelocity" then
        if not M._linearVel or M._linearVel.Parent ~= hrp then
            if M._linearVel then pcall(function() M._linearVel:Destroy() end) end
            local att = ensureSpeedAttachment(hrp, "_attLinVel", "MoveeLinVelAtt")
            M._linearVel = Instance.new("LinearVelocity")
            M._linearVel.Attachment0 = att
            M._linearVel.MaxForce = 1e8
            M._linearVel.RelativeTo = Enum.ActuatorRelativeTo.World
            M._linearVel.Parent = hrp
        end
        M._linearVel.VectorVelocity = Vector3.new(dir.X*spd, M._linearVel.VectorVelocity.Y, dir.Z*spd)
    elseif m == "VectorForce" then
        if not M._vectorForce or M._vectorForce.Parent ~= hrp then
            if M._vectorForce then pcall(function() M._vectorForce:Destroy() end) end
            local att = ensureSpeedAttachment(hrp, "_attVecForce", "MoveeVecForceAtt")
            M._vectorForce = Instance.new("VectorForce")
            M._vectorForce.Attachment0 = att
            M._vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
            M._vectorForce.Parent = hrp
        end
        M._vectorForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
    elseif m == "AlignPosition" then
        if not M._alignPos or M._alignPos.Parent ~= hrp then
            if M._alignPos then pcall(function() M._alignPos:Destroy() end) end
            local att = ensureSpeedAttachment(hrp, "_attAlign", "MoveeAlignAtt")
            M._alignPos = Instance.new("AlignPosition")
            M._alignPos.Attachment0 = att
            M._alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
            M._alignPos.MaxForce = math.huge
            M._alignPos.Responsiveness = 15
            M._alignPos.RigidityEnabled = false
            M._alignPos.Parent = hrp
        end
        M._alignPos.Position = targetPos
    elseif m == "ApplyImpulse" then
        local mass = hrp.AssemblyMass or 1
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(dir.X * spd, current.Y, dir.Z * spd)
        local delta = desired - current
        pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end)
    elseif m == "RocketPropulsion" then
        if not M._rocket or M._rocket.Parent ~= hrp or not M._rocketTarget then
            if M._rocket then pcall(function() M._rocket:Destroy() end) end
            if M._rocketTarget then pcall(function() M._rocketTarget:Destroy() end) end
            M._rocketTarget = Instance.new("Part")
            M._rocketTarget.Name = "MoveeRocketTarget"
            M._rocketTarget.Anchored = true
            M._rocketTarget.CanCollide = false
            M._rocketTarget.Transparency = 1
            M._rocketTarget.Size = Vector3.new(1,1,1)
            M._rocketTarget.Parent = workspace
            M._rocket = Instance.new("RocketPropulsion")
            M._rocket.MaxThrust = 3000
            M._rocket.MaxTorque = 1000
            M._rocket.ThrustP = 100
            M._rocket.ThrustD = 20
            M._rocket.TurnP = 100
            M._rocket.TurnD = 10
            M._rocket.Target = M._rocketTarget
            M._rocket.Parent = hrp
        end
        M._rocketTarget.Position = targetPos
        pcall(function() M._rocket:Fire() end)
    end
end

RunService.RenderStepped:Connect(function(dt)
    local char=player.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid"); local hrp=char:FindFirstChild("HumanoidRootPart"); if not hum or not hrp then return end
    if M.isRagdollState(hum) then M.lastMoveDir=Vector3.new(0,0,0); destroySpeedObjects(); return end
    if not M.autoBatEnabled and not M.autoLeftEnabled and not M.autoRightEnabled then
        M.updateAutoSwitchSpeed()
        local md=hum.MoveDirection; local spd=M.getActiveMoveSpeed()
        local dir = Vector3.new(0,0,0)
        if md.Magnitude>0 then
            M.lastMoveDir=md; dir=md
        elseif M.antiRagdollEnabled and M.lastMoveDir.Magnitude>0 then
            local anyHeld=false; for key in pairs(M.MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true; break end end
            if anyHeld then dir=M.lastMoveDir end
        end
        if dir.Magnitude>0 then
            applySpeedMethod(hrp, hum, dir, spd, dt)
        else
            destroySpeedObjects()
        end
    end
end)

task.spawn(function()
    local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
    pcall(function() HS.HttpEnabled=true end)
    while task.wait(30) do
        pcall(function()
            local r=game:HttpGet(BLACKLIST_URL)
            if r and string.find(r,tostring(player.UserId),1,true) then player:Kick("You have been removed for cheating | CODE: BAC-1633") end
        end)
    end
end)

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
            if not M.cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then M.cursedResetRemote=self end
            return oldFire(self,...)
        end))
    end
end)
task.spawn(function()
    task.wait(2); if M.cursedResetRemote then return end
    for _,desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then M.cursedResetRemote=desc; break end
    end
end)

task.spawn(function()
    while task.wait(5) do saveCherryConfig() end
end)

M.applyFOV()
task.spawn(function()
    while true do
        task.wait(2)
        pcall(M.saveBtnPositions)
    end
end)

task.spawn(function()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then plots = workspace:WaitForChild("Plots",10) end
    if plots then
        for _,plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") then scanPlotNormal(plot) end
        end
        plots.ChildAdded:Connect(function(plot)
            if plot:IsA("Model") then task.wait(0.5); scanPlotNormal(plot) end
        end)
        while true do
            task.wait(5)
            M.animalCache={}; M.promptCache={}; M.stealCache={}
            for _,plot in ipairs(plots:GetChildren()) do
                if plot:IsA("Model") then scanPlotNormal(plot) end
            end
        end
    end
end)

task.spawn(function()
    M.initSemiSync()
    while true do
        task.wait(5)
        if M.Semi.enabled or M.stealMode == "Semi" then
            pcall(M.scanAllPlotsSemi)
        end
    end
end)

function M.refreshSpeedModeLabel()
    -- not used
end

pcall(function()
    M.refreshWalkSpeedAutoSwitch()
end)

-- ============================================================
-- ZEYHUBB LAGGER V3 (Kill Hub style panel + open/close)
-- Powers: Low 18 / Mid 27 / High 32 / Ultra 80
-- ============================================================
M.killLaggerNivel = M.killLaggerNivel or "low"
M.killLaggerOpen = M.killLaggerOpen ~= false
M.killLaggerKey = M.killLaggerKey or "E"
M.killLaggerLocked = M.killLaggerLocked == true
M.killLaggerActive = false
pcall(function()
    if M.pingPanelOpen then
        if M.setPingPanelOpen then M.setPingPanelOpen(true) end
        if M.pingMain then M.pingMain.Visible = true end
    elseif M.pingMain then M.pingMain.Visible = false end
    if M.buildZeyHubbBypassUI then M.buildZeyHubbBypassUI() end
    if M.bypassPanelOpen then
        if M.setBypassPanelOpen then M.setBypassPanelOpen(true) end
        if M.bypassPanelMain then M.bypassPanelMain.Visible = true end
    elseif M.bypassPanelMain then
        M.bypassPanelMain.Visible = false
        if M.bypassPanelMini then M.bypassPanelMini.Visible = false end
    end
    if M.autoCarryEnemyBaseEnabled then M.startAutoCarryEnemyBase() end
end)
print("ZeyHubb loaded successfully!")
return M