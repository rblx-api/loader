-- ⏱ KEY CON EXPIRACIÓN
local keyExpiry = 1792211325106
local now = os.time() * 1000
if now > keyExpiry then
  pcall(function()
    game:GetService("Players").LocalPlayer:Kick("KEY EXPIRADA")
  end)
  return
end

-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"wasonoa89000"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

(function()
local Players = game:GetService('Players'); local player = Players.LocalPlayer; local TweenService = game:GetService('TweenService'); local Lighting = game:GetService('Lighting');
local M = {}
-- Pon aquí el ID de Roblox de la versión exacta de “Ebrio de amor” que quieras usar.
M.INTRO_MUSIC_ID = "rbxassetid://1234567890"
M.INTRO_MUSIC_TITLE = "Martillazo en el ano"
_G.PrimeHubFeKlan = M
local function playCinematicIntro()
    _G.PrimeHubIntroFinished = false
    _G.PrimeHubForceMobileVisible = false
    _G.PrimeHubIntroActive = true
    _G.PrimeHubIntroDoneCallbacks = _G.PrimeHubIntroDoneCallbacks or {}

    local function finishIntro()
        if _G.PrimeHubIntroFinished then return end
        _G.PrimeHubIntroActive = false
        _G.PrimeHubIntroFinished = true
        _G.PrimeHubForceMobileVisible = true
        for _, fn in ipairs(_G.PrimeHubIntroDoneCallbacks or {}) do
            pcall(fn)
        end
        _G.PrimeHubIntroDoneCallbacks = {}
        pcall(function()
            game:GetService("StarterGui"):SetCore("TopbarEnabled", true)
        end)
    end

    local ok, err = pcall(function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local contentProvider = game:GetService("ContentProvider")
        local tweenService = game:GetService("TweenService")
        local soundService = game:GetService("SoundService")
        local starterGui = game:GetService("StarterGui")

        pcall(function() starterGui:SetCore("TopbarEnabled", false) end)

        local Images = {
            "rbxassetid://119431736728412",
            "rbxassetid://138617155406381",
            "rbxassetid://122004562009487",
            "rbxassetid://111666139602475",
            "rbxassetid://82853558221358",
            "rbxassetid://99317983935093",
            "rbxassetid://74191985576113",
            "rbxassetid://121669722747151",
            "rbxassetid://124065695091762",
            "rbxassetid://79760018472683",
            "rbxassetid://98676924517887",
            "rbxassetid://71644601072524",
            "rbxassetid://80090330579005",
            "rbxassetid://91256497568305",
            "rbxassetid://85473959437570",
            "rbxassetid://132626038420199",
            "rbxassetid://73726424486031",
            "rbxassetid://79785986694281",
            "rbxassetid://135839421830406",
            "rbxassetid://118406628258941",
            "rbxassetid://119813036601783",
            "rbxassetid://130178636755957",
            "rbxassetid://113191099517012",
            "rbxassetid://75464387496017",
            "rbxassetid://140097745510703",
            "rbxassetid://71495063226448",
            "rbxassetid://108194418196219",
            "rbxassetid://90241015183433",
            "rbxassetid://95507869630985",
            "rbxassetid://83143023812890",
            "rbxassetid://73599285484967",
            "rbxassetid://87503691927922",
            "rbxassetid://128451182143008",
            "rbxassetid://91604141302936",
            "rbxassetid://129446753297102",
            "rbxassetid://118409437980786",
            "rbxassetid://103979654042976",
            "rbxassetid://105810228012424",
            "rbxassetid://72498915673766",
            "rbxassetid://94429962876409",
            "rbxassetid://85231140206082",
            "rbxassetid://136744481873464",
            "rbxassetid://98988596558468",
            "rbxassetid://131511384454581",
            "rbxassetid://133000486425571",
            "rbxassetid://75573133305762",
            "rbxassetid://96089546593534",
            "rbxassetid://125239586151231",
            "rbxassetid://83918101020965",
            "rbxassetid://92521133651284"
        }

        local FPS = 30
        local FRAME_DELAY = 1 / FPS
        local skipped = false
        local total = #Images

        -- Preload images (non-blocking if it fails)
        pcall(function()
            contentProvider:PreloadAsync(Images)
        end)

        local pg = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
        if not pg then
            finishIntro()
            return
        end

        local old = pg:FindFirstChild("PRIMEHUBHubIntro")
        if old then old:Destroy() end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "PRIMEHUBHubIntro"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.DisplayOrder = 1000
        screenGui.Parent = pg

        -- Sound (starts at second 5)
        local introSound = Instance.new("Sound")
        introSound.Name = "PRIMEHUBIntroSound"
        introSound.SoundId = tostring(M.INTRO_MUSIC_ID or "rbxassetid://1234567890")
        introSound.Volume = 1.2
        introSound.Looped = false
        introSound.Parent = screenGui
        introSound.TimePosition = 5
        pcall(function() introSound:Play() end)

        local frame = Instance.new("Frame")
        frame.Size = UDim2.fromScale(1, 1)
        frame.BackgroundColor3 = Color3.fromRGB(10, 5, 16)
        frame.BorderSizePixel = 0
        frame.Parent = screenGui

        local layer1 = Instance.new("ImageLabel")
        layer1.Size = UDim2.fromScale(1, 1)
        layer1.BackgroundTransparency = 1
        layer1.ScaleType = Enum.ScaleType.Fit
        layer1.ZIndex = 2
        layer1.Parent = frame

        local layer2 = Instance.new("ImageLabel")
        layer2.Size = UDim2.fromScale(1, 1)
        layer2.BackgroundTransparency = 1
        layer2.ScaleType = Enum.ScaleType.Fit
        layer2.ZIndex = 1
        layer2.Parent = frame

        -- TAP SKIP INTRO hint
        local skipHint = Instance.new("TextLabel")
        skipHint.Size = UDim2.new(1, 0, 0, 28)
        skipHint.Position = UDim2.new(0, 0, 0.9, 0)
        skipHint.BackgroundTransparency = 1
        skipHint.Text = "🎃  EDICIÓN ESPECIAL  •  TOCA PARA SALTAR  🎃"
        skipHint.Font = Enum.Font.Gotham
        skipHint.TextSize = 15
        skipHint.TextColor3 = Color3.fromRGB(140, 140, 140)
        skipHint.TextTransparency = 0.2
        skipHint.TextStrokeTransparency = 0.6
        skipHint.ZIndex = 15
        skipHint.Parent = frame

        -- Full-screen skip button
        local skipButton = Instance.new("TextButton")
        skipButton.Size = UDim2.fromScale(1, 1)
        skipButton.BackgroundTransparency = 1
        skipButton.Text = ""
        skipButton.ZIndex = 50
        skipButton.Parent = frame

        local function cleanupAndFinish()
            if skipped then return end
            skipped = true
            pcall(function()
                if introSound then
                    introSound:Stop()
                end
            end)
            pcall(function()
                if screenGui and screenGui.Parent then
                    screenGui:Destroy()
                end
            end)
            pcall(function() starterGui:SetCore("TopbarEnabled", true) end)
            finishIntro()
        end

        skipButton.MouseButton1Click:Connect(cleanupAndFinish)
        skipButton.Activated:Connect(cleanupAndFinish)

        -- ========== ANIMACIÓN EN BUCLE ==========
        -- El título queda visible desde el inicio sobre la animación.
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(0.9, 0, 0, 120)
        title.Position = UDim2.new(0.5, 0, 0.5, 0)
        title.AnchorPoint = Vector2.new(0.5, 0.5)
        title.BackgroundTransparency = 1
        title.Text = "EDICIÓN ESPECIAL"
        title.Font = Enum.Font.LuckiestGuy
        title.TextSize = 72
        title.TextXAlignment = Enum.TextXAlignment.Center
        title.TextYAlignment = Enum.TextYAlignment.Center
        title.TextColor3 = Color3.fromRGB(255, 145, 35)
        title.TextStrokeTransparency = 0.05
        title.TextStrokeColor3 = Color3.fromRGB(76, 12, 100)
        title.ZIndex = 10
        title.Parent = frame

        local subtitle = Instance.new("TextLabel")
        subtitle.Size = UDim2.new(0.9, 0, 0, 36)
        subtitle.Position = UDim2.new(0.5, 0, 0.61, 0)
        subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
        subtitle.BackgroundTransparency = 1
        subtitle.Text = "prime hub"
        subtitle.Font = Enum.Font.GothamMedium
        subtitle.TextSize = 20
        subtitle.TextXAlignment = Enum.TextXAlignment.Center
        subtitle.TextYAlignment = Enum.TextYAlignment.Center
        subtitle.TextColor3 = Color3.fromRGB(255, 170, 220)
        subtitle.TextStrokeTransparency = 0.3
        subtitle.TextStrokeColor3 = Color3.fromRGB(100, 0, 60)
        subtitle.ZIndex = 10
        subtitle.Parent = frame

        local letterLayer = Instance.new("Frame")
        letterLayer.Name = "PrimeHubLetterBackground"
        letterLayer.Size = UDim2.new(0.92, 0, 0, 54)
        letterLayer.Position = UDim2.new(0.5, 0, 0.75, 0)
        letterLayer.AnchorPoint = Vector2.new(0.5, 0.5)
        letterLayer.BackgroundTransparency = 1
        letterLayer.ZIndex = 12
        letterLayer.Parent = frame
        local letterList = {}
        for index = 1, #"prime hub" do
            local ch = string.sub("prime hub", index, index)
            local letter = Instance.new("TextLabel")
            letter.Name = "Letter_" .. tostring(index)
            letter.Size = UDim2.new(1 / 9, 0, 1, 0)
            letter.Position = UDim2.new((index - 1) / 9, 0, 0, 0)
            letter.BackgroundTransparency = 1
            letter.Text = ch == " " and "·" or string.upper(ch)
            letter.TextColor3 = Color3.fromRGB(255, 150, 35)
            letter.TextStrokeColor3 = Color3.fromRGB(62, 8, 85)
            letter.TextStrokeTransparency = 0.05
            letter.Font = Enum.Font.GothamBlack
            letter.TextSize = 25
            letter.TextTransparency = 1
            letter.ZIndex = 13
            letter.Parent = letterLayer
            table.insert(letterList, letter)
        end
        task.spawn(function()
            for _, letter in ipairs(letterList) do
                if skipped then return end
                letter.TextTransparency = 0
                task.wait(0.12)
            end
        end)

        layer1.Image = Images[1]
        layer2.Image = Images[1]
        local currentIdx = 1
        local useLayer1AsFront = true

        -- La animación continúa hasta que el usuario toca la pantalla.
        while not skipped do
            local nextIdx = currentIdx + 1
            if nextIdx > total then
                nextIdx = 1
            end

            local behind = useLayer1AsFront and layer2 or layer1
            local front = useLayer1AsFront and layer1 or layer2
            behind.Image = Images[nextIdx]

            -- No cambiar de capa hasta que la imagen esté cargada.
            local loadStart = os.clock()
            while not behind.IsLoaded and os.clock() - loadStart < 5 and not skipped do
                task.wait()
            end

            if skipped then return end
            if behind.IsLoaded then
                behind.ZIndex = 2
                front.ZIndex = 1
                useLayer1AsFront = not useLayer1AsFront
                currentIdx = nextIdx
            else
                behind.Image = front.Image
            end

            task.wait(FRAME_DELAY)
        end

    end)

    if not ok then
        warn("[Prime Hub Intro] " .. tostring(err))
        finishIntro()
    end
end
_G.PrimeHubIntroActive = false; _G.PrimeHubIntroFinished = true

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local PRIMEHUB_MOBILE = UIS.TouchEnabled == true
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer

function M.sendSpamChatMessage()
    local message = "prime hub new generation"
    local sent = false
    pcall(function()
        local textChatService = game:GetService("TextChatService")
        local channels = textChatService:FindFirstChild("TextChannels")
        local general = channels and channels:FindFirstChild("RBXGeneral")
        if general then
            general:SendAsync(message)
            sent = true
        end
    end)
    if not sent then
        pcall(function()
            local events = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            local sayMessage = events and events:FindFirstChild("SayMessageRequest")
            if sayMessage then
                sayMessage:FireServer(message, "All")
                sent = true
            end
        end)
    end
    if not sent and M.notify then
        pcall(function() M.notify("Chat is unavailable") end)
    end
end
local task_wait, task_spawn, task_delay = task.wait, task.spawn, task.delay
local math_floor, math_abs, math_rad = math.floor, math.abs, math.rad
local Vector3_new, CFrame_new, Color3_fromRGB = Vector3.new, CFrame.new, Color3.fromRGB
local Instance_new = Instance.new
M.introSoundEnabled = false
M.introSongChoice = 3
M.introGUIEnabled = false
if isfile and isfile("primehub_fe_klan_config.json") then
    local ok, data = pcall(function() return HS:JSONDecode(readfile("primehub_fe_klan_config.json")) end)
    if ok and type(data) == "table" then
        if data.introSoundEnabled ~= nil then M.introSoundEnabled = data.introSoundEnabled end
        if data.introSongChoice then M.introSongChoice = data.introSongChoice end
        if data.introGUIEnabled ~= nil then M.introGUIEnabled = data.introGUIEnabled end
        if type(data.Theme) == "string" then M._savedTheme = data.Theme end
        if type(data.colorScheme) == "string" then M._savedTheme = data.colorScheme end
    end
end
M.CANDY_SKY_TAG = "MoveeSkyTheme"
M.currentSkyTheme = "Night"
M.skyThemesEnabled = true
M._skyOriginalLighting = nil
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
    if not M._skyOriginalLighting then
        M._skyOriginalLighting = {
            ClockTime = Lighting.ClockTime, Brightness = Lighting.Brightness,
            OutdoorAmbient = Lighting.OutdoorAmbient, Ambient = Lighting.Ambient,
            FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd, FogColor = Lighting.FogColor,
            ColorShift_Top = Lighting.ColorShift_Top, ColorShift_Bottom = Lighting.ColorShift_Bottom,
            GlobalShadows = Lighting.GlobalShadows,
        }
    end
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(M.CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(M.CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=M.CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then
        local original = M._skyOriginalLighting
        if original then
            Lighting.ClockTime = original.ClockTime
            Lighting.Brightness = original.Brightness
            Lighting.OutdoorAmbient = original.OutdoorAmbient
            Lighting.Ambient = original.Ambient
            Lighting.FogStart = original.FogStart
            Lighting.FogEnd = original.FogEnd
            Lighting.FogColor = original.FogColor
            Lighting.ColorShift_Top = original.ColorShift_Top
            Lighting.ColorShift_Bottom = original.ColorShift_Bottom
            Lighting.GlobalShadows = original.GlobalShadows
        end
        return
    end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
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
M.animPack = "Mage"
M.animPackEnabled = true
M.savedAnimate = nil
M.headlessEnabled = false
M.korbloxEnabled = false
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
                rightLeg.Color = Color3.fromRGB(255, 235, 248)
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
end
player.CharacterAdded:Connect(function(char)
    task.wait(0.15)
    M.applyCharterToChar(char)
    task.defer(function()
        if M.normalizeCameraState then pcall(M.normalizeCameraState) end
    end)
    task.delay(0.45, function()
        if player.Character == char and M.normalizeCameraState then pcall(M.normalizeCameraState) end
    end)
end)
M.NS = 59
M.CS = 29
M.LAGGER_SPEED = 30
M.LAGGER_CARRY_SPEED = 15
M.speedProfile = M.speedProfile or "Normal"
M.NormalSpeedNorm = M.NormalSpeedNorm or 59
M.NormalSpeedSteal = M.NormalSpeedSteal or 29
M.LaggerSpeedNorm = M.LaggerSpeedNorm or 30
M.LaggerSpeedSteal = M.LaggerSpeedSteal or 15
M.CustomSpeedNorm = M.CustomSpeedNorm or 66
M.CustomSpeedSteal = M.CustomSpeedSteal or 34
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
M.laggerCarryActive = false
M.antiRagdollEnabled = false
M.antiRagdollMode = "V1"
M.infJumpEnabled = false
M.infJumpMode = "hold"
M.medusaCounterEnabled = false
M.batCounterEnabled = false
M.unwalkEnabled = false
M.medusaDebounce = false
M.medusaLastUsed = 0
M.dropActive = false
M.dropMode = "Fling"
M.DROP_ASCEND_DURATION = 0.22
M.DROP_ASCEND_SPEED = 160
M._dropConn = nil
M._dropFlingThread = nil
M._lastDropTime = 0
M.autoLeftEnabled = false
M.autoRightEnabled = false
M.autoBatEnabled = false
M.autoSwingEnabled = true
M.autoMoveSwingEnabled = false
M.autoMoveSwingInterval = 0.3
M._alSwingDebounce = false
M._arSwingDebounce = false
M.antiLagEnabled = false
M.nukeOptimiserEnabled = false
M.antiVoidEnabled = false
M.bodyLockEnabled = false
M.bodyLockRadius = 60
M.antiLagV2Enabled = false
M.antiSummerBaseEnabled = false
M.antiSummerBaseConn = nil
M._antiSummerCleaned = {}
M.removeAccessoriesEnabled = false
M.antiLagDescConn = nil
M.antiLagV2DescConn = nil
M.stretchRezEnabled = false
M.stretchRezConn = nil
M.unwalkSavedAnimate = nil
M._unwalkOffLock = true
M.pcKeyStatusEnabled = false
M.pcKeyPanelScale = 1
M.pcKeyPanelScaleRef = nil
M.pcKeyPanelPosition = nil
M._anyKeyListening = false
M.autoTPHeight = 20
M.autoTPConn = nil
M.guiTransparencyEnabled = false
M.mobileButtonsEnabled = true
M.mobileButtonsLocked = false
M.mobileButtonsSize = 100
M.mobBtnRefs = {}
M.mobGuiRef = nil
M.fovValue = 80
M.fovEnabled = true
M.fovOriginalValue = nil
M.fovOptions = {"Desactivado", 80, 90, 120}
M.fovIndex = 2
M.laggerModePillRef = nil
M.carryModePillRef = nil
M.autoSwitchSpeedEnabled = false
M.autoTurnOffSpeedEnabled = false
M.autoSwitchLaggerSpeedEnabled = false
M.AUTO_SWITCH_THRESHOLD = 25
M._autoSwitchSpeedConn = nil
M.customFontSelected = "None"
M._fontOrig = {}
M._fontConn = nil
M._fontMy = nil
M.FONT_NAMES = {"None", "Coding Font", "Summer", "Beachy", "Scary", "Bangers"}
M.mobBtnTransparencyEnabled = false
M.perButtonDragEnabled = true
M.antiKickEnabled = false
M.brainrotDetected = false
M.safeModeEnabled = false
M.mirrorTPDownEnabled = false
M.mirrorTPPreviousY = {}
M.mirrorTPLastTeleport = 0
M.MIRROR_TP_DROP_THRESHOLD = 3
M.MIRROR_TP_DOWN_Y = -7.00
M.activeBatBillboard = nil
M.activeMedusaBillboard = nil
M.ragdollGuiEnabled = true
M.persistentRagdollGui = nil
M.uiLocked = false
M.uiTransparencyEnabled = true
M.mobButtonsTransparencyEnabled = true
M.holdInfJumpConn = nil
M.DROP_ASCEND_DURATION = 0.2
M.DROP_ASCEND_SPEED = 150
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

M._savedButtonPositions = {}


M.autoRadiusEnabled = false
function M.getAutoRadius()
    local radius = math.clamp((tonumber(M.NS) or 60) + 1, 1, 500)
    return math.floor(radius * 10 + 0.5) / 10
end

M.playerESPEnabled = false
M.espList = {}
M.pingPopupActive = false
M.pingPopupGui = nil
M.pingCycleTimer = nil
M.Conns = {antiRag=nil, batCounter=nil, anchor={}}
M._persistentConns = {}
M.alConn = nil
M.arConn = nil
M.alPhase = 1
M.arPhase = 1
M.aimbotConn = nil
M.lastMoveDir = Vector3.new(0,0,0)
M.batCounterDebounce = false
M.speedLabel = nil
M.KB = {
    DropBrainrot={kb=nil,gp=nil},
    AutoLeft={kb=nil,gp=nil},
    AutoRight={kb=nil,gp=nil},
    AutoBat={kb=nil,gp=nil},
    TPFloor={kb=nil,gp=nil},
    GuiHide={kb=nil,gp=nil},
    LaggerToggle={kb=nil,gp=nil},
    LaggerCarry={kb=nil,gp=nil},
    BypassAimbot={kb=nil,gp=nil},
    InstaReset={kb=nil,gp=nil},
    BatTP={kb=Enum.KeyCode.E,gp=nil},
    BatV2={kb=Enum.KeyCode.N,gp=nil},
    SpeedNormal={kb=Enum.KeyCode.G,gp=nil},
    SpeedLagger={kb=Enum.KeyCode.R,gp=nil},
    SpeedCustom={kb=Enum.KeyCode.Three,gp=nil},
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
M.MOB_POS_FILE = "primehub_fe_klan_btnpos.json"
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
M.uiScale = 0.8
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    M.uiScale = 0.7
end
M.uiScaleSliderRef = nil
M.uiScaleLabelRef = nil
M.uiScaleBoxRef = nil
M.lineESPEnabled = false
M.menuOpen = false
M.speedESPEnabled = false
function M.addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(100,100,100)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(100,100,100))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end
function M.applyFOV()
    if M.fovConn then M.fovConn:Disconnect(); M.fovConn = nil end
    local cam = workspace.CurrentCamera
    if cam and M.fovOriginalValue == nil then M.fovOriginalValue = cam.FieldOfView end
    if M.fovEnabled ~= true then
        if cam and M.fovOriginalValue then cam.FieldOfView = M.fovOriginalValue end
        return
    end
    M.fovConn = RunService.RenderStepped:Connect(function()
        local currentCam = workspace.CurrentCamera
        if currentCam then currentCam.FieldOfView = tonumber(M.fovValue) or 80 end
    end)
end
M.ragdollTimerThread = nil
M.ragdollTimerRemaining = 0
M.isRagdollActive = false

-- Anti-Sammy style recovery timer billboard
M.ragdollGuiEnabled = M.ragdollGuiEnabled ~= false
M._activeBatBillboard = nil
M._activeMedusaBillboard = nil

function M.createRagdollBillboard(duration, labelText, color)
    if not M.ragdollGuiEnabled then return nil end
    local guiName = "PrimeHubRecovery_" .. tostring(labelText)
    for _, oldName in ipairs({guiName}) do
        pcall(function()
            local old = game:GetService("CoreGui"):FindFirstChild(oldName)
            if old then old:Destroy() end
        end)
        pcall(function()
            local pgui = player:FindFirstChild("PlayerGui")
            local old = pgui and pgui:FindFirstChild(oldName)
            if old then old:Destroy() end
        end)
    end

    -- Black theme, white text
    local BLACK = Color3.fromRGB(10, 10, 12)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local GRAY = Color3.fromRGB(180, 180, 185)
    local BAR_BG = Color3.fromRGB(40, 40, 45)

    local sg = Instance.new("ScreenGui")
    sg.Name = guiName
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 40
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(sg) end
    end)
    local okParent = pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not okParent then
        pcall(function() sg.Parent = player:FindFirstChild("PlayerGui") end)
    end

    local card = Instance.new("Frame", sg)
    card.Name = "RecoveryTimer"
    card.AnchorPoint = Vector2.new(0.5, 0)
    card.Position = UDim2.new(0.5, 0, 0, 58)
    card.Size = UDim2.fromOffset(196, 48)
    card.BackgroundColor3 = BLACK
    card.BackgroundTransparency = 0.08
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 11)
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = WHITE
    cardStroke.Thickness = 1.2
    cardStroke.Transparency = 0.35

    local accentBar = Instance.new("Frame", card)
    accentBar.Position = UDim2.fromOffset(0, 7)
    accentBar.Size = UDim2.fromOffset(3, 34)
    accentBar.BackgroundColor3 = WHITE
    accentBar.BorderSizePixel = 0
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

    local titleLbl = Instance.new("TextLabel", card)
    titleLbl.Position = UDim2.fromOffset(14, 6)
    titleLbl.Size = UDim2.new(1, -70, 0, 18)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = labelText or "RAGDOLL"
    titleLbl.TextColor3 = WHITE
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local subLbl = Instance.new("TextLabel", card)
    subLbl.Position = UDim2.fromOffset(14, 24)
    subLbl.Size = UDim2.new(1, -70, 0, 16)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "Recovering..."
    subLbl.TextColor3 = GRAY
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 11
    subLbl.TextXAlignment = Enum.TextXAlignment.Left

    local timerLbl = Instance.new("TextLabel", card)
    timerLbl.AnchorPoint = Vector2.new(1, 0)
    timerLbl.Position = UDim2.new(1, -10, 0, 7)
    timerLbl.Size = UDim2.fromOffset(48, 18)
    timerLbl.BackgroundTransparency = 1
    timerLbl.Text = string.format("%.1fs", duration)
    timerLbl.TextColor3 = WHITE
    timerLbl.Font = Enum.Font.GothamBold
    timerLbl.TextSize = 12
    timerLbl.TextXAlignment = Enum.TextXAlignment.Right

    local fillBg = Instance.new("Frame", card)
    fillBg.Position = UDim2.new(0, 14, 1, -8)
    fillBg.Size = UDim2.new(1, -28, 0, 3)
    fillBg.BackgroundColor3 = BAR_BG
    fillBg.BorderSizePixel = 0
    Instance.new("UICorner", fillBg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", fillBg)
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = WHITE
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local startTime = tick()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local remaining = duration - (tick() - startTime)
        if remaining <= 0 then
            if conn then conn:Disconnect() end
            pcall(function() sg:Destroy() end)
            return
        end
        if timerLbl and timerLbl.Parent then
            timerLbl.Text = string.format("%.1fs", remaining)
            fill.Size = UDim2.new(remaining / duration, 0, 1, 0)
            if remaining < 1 then
                cardStroke.Transparency = 0.15
                timerLbl.TextColor3 = WHITE
            end
        end
    end)
    return sg
end

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
        if M.createRagdollBillboard and not M._activeBatBillboard then
            M._activeBatBillboard = M.createRagdollBillboard(2.6, "RAGDOLL", Color3.fromRGB(255,255,255))
            task.delay(2.98, function()
                if M._activeBatBillboard then pcall(function() M._activeBatBillboard:Destroy() end); M._activeBatBillboard = nil end
            end)
        end
    end
end
function M.onMedusaStateChanged()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand then
        M.updateRagdollTimer(4.5)
        if M.createRagdollBillboard and not M._activeMedusaBillboard then
            M._activeMedusaBillboard = M.createRagdollBillboard(4.5, "STONE", Color3.fromRGB(255,255,255))
            task.delay(4.88, function()
                if M._activeMedusaBillboard then pcall(function() M._activeMedusaBillboard:Destroy() end); M._activeMedusaBillboard = nil end
            end)
        end
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
    local template = M.savedAnimate
    if not template then
        pcall(function()
            local starter = game:GetService("StarterPlayer"):FindFirstChild("StarterCharacterScripts")
            local defaultAnimate = starter and starter:FindFirstChild("Animate")
            if defaultAnimate then template = defaultAnimate end
        end)
    end
    if not template then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then M.stopAllTracks(hum) end
    local currentAnimate = char:FindFirstChild("Animate")
    if currentAnimate then currentAnimate:Destroy() end
    local newAnimate = template:Clone()
    newAnimate.Parent = char
    newAnimate.Disabled = true
    task.wait(0.06)
    if newAnimate.Parent then newAnimate.Disabled = false end
end
function M.resetAnimations(char)
    if not char then return end
    if M.unwalkEnabled == true and M._unwalkOffLock ~= true then
        M.startUnwalk()
        return
    end
    M.restoreOriginalAnimate(char)
end
local applyingAnim = false
function M.applyAnimPack(packName)
    if M.unwalkEnabled == true and M._unwalkOffLock ~= true then return false end
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
            task.wait(0.06)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    M.animPack = packName
    applyingAnim = false
    return true
end
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
    local _acc = 0
    M.playerSpeedUpdateConn = RunService.Heartbeat:Connect(function(dt)
        _acc = _acc + (dt or 0.016)
        if _acc < 0.12 then return end
        _acc = 0
        M.updateAllPlayerSpeeds()
    end)
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
function M.addESP(plr)
    if plr == player then return end
    if M.espList[plr] then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local nameBB = Instance.new("BillboardGui")
    nameBB.Size = UDim2.new(0, 120, 0, 30)
    nameBB.StudsOffset = Vector3.new(0, 2.8, 0)
    nameBB.AlwaysOnTop = true
    nameBB.Adornee = head
    nameBB.Parent = head
    local nameLbl = Instance.new("TextLabel", nameBB)
    nameLbl.Size = UDim2.new(1,0,1,0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = plr.Name
    nameLbl.TextColor3 = Color3.fromRGB(255,255,255)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextScaled = true
    nameLbl.TextStrokeTransparency = 0
    nameLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = char
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0.3
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    M.espList[plr] = {nameBB = nameBB, highlight = highlight}
end
function M.removeESP(plr)
    local data = M.espList[plr]
    if data then
        if data.nameBB then data.nameBB:Destroy() end
        if data.highlight then data.highlight:Destroy() end
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
M.headIndicator = nil
function M.setupHeadIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    if head:FindFirstChild("MoveeHeadIndicator") then head.MoveeHeadIndicator:Destroy() end
    local bb=Instance.new("BillboardGui",head)
    bb.Name="MoveeHeadIndicator"
    bb.Size=UDim2.new(0,150,0,50)
    bb.StudsOffset=Vector3.new(0,2.2,0)
    bb.AlwaysOnTop=true
    bb.Parent=head
    local accent = M.currentAccent or Color3.fromRGB(58, 128, 245)
    local PrimeHubLbl=Instance.new("TextLabel",bb)
    PrimeHubLbl.Name="PrimeHub"
    PrimeHubLbl.Size=UDim2.new(1,0,0.4,0)
    PrimeHubLbl.Position=UDim2.new(0,0,0.1,0)
    PrimeHubLbl.BackgroundTransparency=1
    PrimeHubLbl.Text="prime hub"
    PrimeHubLbl.TextColor3=accent
    PrimeHubLbl.Font=Enum.Font.LuckiestGuy
    PrimeHubLbl.TextSize=11; PrimeHubLbl.TextScaled=false
    PrimeHubLbl.TextStrokeTransparency=0
    PrimeHubLbl.TextStrokeColor3 = Color3.new(0,0,0)
    local speedLbl=Instance.new("TextLabel",bb)
    speedLbl.Name="Speed"
    speedLbl.Size=UDim2.new(1,0,0.4,0)
    speedLbl.Position=UDim2.new(0,0,0.5,0)
    speedLbl.BackgroundTransparency=1
    speedLbl.Text="0.0"
    speedLbl.TextColor3=Color3.new(1,1,1)
    speedLbl.Font=Enum.Font.LuckiestGuy
    speedLbl.TextSize=16; speedLbl.TextScaled=false
    speedLbl.TextStrokeTransparency=0
    speedLbl.TextStrokeColor3 = Color3.new(0,0,0)
    M.headIndicator = {bb=bb, PrimeHub=PrimeHubLbl, speed=speedLbl}
end
function M.updateHeadTheme()
    if not M.headIndicator then return end
    local accent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255,255,255)
    if M.headIndicator.PrimeHub then
        M.headIndicator.PrimeHub.TextColor3 = accent
    end
    if M.headIndicator.speed then
        M.headIndicator.speed.TextColor3 = accent
    end
    if M.headIndicator.ragdollTimer then
        M.headIndicator.ragdollTimer.TextColor3 = accent
    end
    if M.headIndicator.divider then
        M.headIndicator.divider.BackgroundColor3 = accent
    end
end
local speedUpdateConn = nil
function M.startHeadSpeedUpdates()
    if speedUpdateConn then return end
    speedUpdateConn = task.spawn(function()
        while true do
            task.wait(0.25)
            local char = player.Character
            if char and M.headIndicator and M.headIndicator.speed then
                local displaySpeed
                if M.autoLeftEnabled or M.autoRightEnabled then
                    displaySpeed = (M.getAutoPathSpeed and M.getAutoPathSpeed()) or M.NS
                else
                    displaySpeed = M.getActiveMoveSpeed()
                end
                M.headIndicator.speed.Text = string.format("%.1f", displaySpeed)
            end
        end
    end)
end
function M.stopHeadSpeedUpdates()
    if speedUpdateConn then
        pcall(task.cancel, speedUpdateConn)
        speedUpdateConn = nil
    end
end
M.autoGrabV1Enabled = false
M.autoGrabMode = "V1"
M.autoGrabV1Busy = false
M.autoGrabV1Progress = 0
M.autoGrabV1Ready = false
M.autoGrabV1Conn = nil
M.autoGrabV1Gui = nil
M.autoGrabV1Fill = nil
M.autoGrabV1Label = nil
M.NORMAL_STEAL_PERCENT = M.NORMAL_STEAL_PERCENT or {["75"]=0.75,["80"]=0.80,["86"]=0.86,["90"]=0.90}
M.normalStealVersion = M.normalStealVersion or "86"
local ZenXSteal = {AutoStealEnabled=false, StealRadius=62, StealDuration=1.3, GrabMode="V1", Mode="half", HalfFireRange=10, HalfHoldMin=1.3, HalfHoldMax=2.6, HalfEntryDelay=0.3, Data={}}
local zenXStealing = false
local zenXStealStartTime = nil
local zenXStealPaused = false
local zenXLastPrompt = nil
local zenXNextPromptTime = 0
local function zenXOwnPlot(name)
    local plots=workspace:FindFirstChild("Plots"); local plot=plots and plots:FindFirstChild(name); local sign=plot and plot:FindFirstChild("PlotSign"); local base=sign and sign:FindFirstChild("YourBase")
    return base and base:IsA("BillboardGui") and base.Enabled==true
end
local function zenXPromptDistance(prompt)
    local char=player.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root or not prompt then return math.huge end
    local parent=prompt.Parent; if parent and parent:IsA("Attachment") then parent=parent.Parent end
    if parent and parent:IsA("BasePart") then return (parent.Position-root.Position).Magnitude end
    local ok,pos=pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
    return ok and pos and (pos-root.Position).Magnitude or math.huge
end
local function zenXFindNearestPrompt()
    local char=player.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); local plots=workspace:FindFirstChild("Plots"); if not root or not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not zenXOwnPlot(plot.Name) then
            local pods=plot:FindFirstChild("AnimalPodiums")
            if pods then for _,pod in ipairs(pods:GetChildren()) do
                local base=pod:FindFirstChild("Base"); local sp=base and base:FindFirstChild("Spawn")
                if sp and sp:IsA("BasePart") then
                    local d=(sp.Position-root.Position).Magnitude
                    if d<=ZenXSteal.StealRadius and d<dist then
                        local found
                        local att=sp:FindFirstChild("PromptAttachment")
                        if att then for _,pr in ipairs(att:GetChildren()) do if pr:IsA("ProximityPrompt") and pr.Enabled and tostring(pr.ActionText):lower():find("steal") then found=pr; break end end end
                        if not found then for _,pr in ipairs(pod:GetDescendants()) do if pr:IsA("ProximityPrompt") and pr.Enabled and (tostring(pr.ActionText).." "..tostring(pr.ObjectText)):lower():find("steal") then found=pr; break end end end
                        if found then nearest,dist=found,d end
                    end
                end
            end end
        end
    end
    return nearest
end
local function zenXUpdateBar()
    -- exported below as M.zenXUpdateBar
    local pct=math.clamp(tonumber(M.autoGrabV1Progress) or 0,0,1)
    local preset = tostring(M.normalStealVersion or "86")
    local pingMs = 0
    pcall(function()
        pingMs = math.floor((player:GetNetworkPing() or 0) * 1000 + 0.5)
    end)
    M._lastPingMs = pingMs

    if M.autoGrabV1Fill then
        M.autoGrabV1Fill.Size = UDim2.new(pct, 0, 1, -4)
        M.autoGrabV1Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
    if M.autoGrabV1Label then
        M.autoGrabV1Label.RichText = true
        if M.autoGrabV1Ready then
            M.autoGrabV1Label.Text = string.format("<font color=\"#000000\">READY</font>  %s%%", preset)
        else
            M.autoGrabV1Label.Text = string.format("%d%% / %s%%", math.floor(pct * 100 + 0.5), preset)
        end
        M.autoGrabV1Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        M.autoGrabV1Label.TextSize = 13
    end
    if M.stealBarPingLbl then
        M.stealBarPingLbl.Text = tostring(pingMs) .. " ms"
        -- subtle color by ping (like Anti-Sammy severity, but small)
        if pingMs > 150 then
            M.stealBarPingLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
        elseif pingMs > 100 then
            M.stealBarPingLbl.TextColor3 = Color3.fromRGB(255, 205, 110)
        else
            M.stealBarPingLbl.TextColor3 = Color3.fromRGB(115, 235, 175)
        end
    end
    if M.autoGrabDesign2Fill then
        M.autoGrabDesign2Fill.Size = UDim2.new(pct, 0, 1, 0)
        M.autoGrabDesign2Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        if M.autoGrabDesign2Percent then
            M.autoGrabDesign2Percent.Text = string.format("%d%%", math.floor(pct * 100 + 0.5))
            M.autoGrabDesign2Percent.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        if M.autoGrabDesign2Status then
            M.autoGrabDesign2Status.RichText = true
            M.autoGrabDesign2Status.Text = M.autoGrabV1Ready and string.format("<font color=\"#000000\">READY</font> %s%%", preset) or ("STEAL " .. preset .. "%")
        end
    end
    if M.autoGrabDesign2Ping then
        M.autoGrabDesign2Ping.Text = tostring(pingMs) .. " ms"
        if pingMs > 150 then
            M.autoGrabDesign2Ping.TextColor3 = Color3.fromRGB(255, 120, 120)
        elseif pingMs > 100 then
            M.autoGrabDesign2Ping.TextColor3 = Color3.fromRGB(255, 200, 120)
        else
            M.autoGrabDesign2Ping.TextColor3 = Color3.fromRGB(180, 180, 185)
        end
    end
end
M.zenXUpdateBar = zenXUpdateBar

-- El borde de Auto Steal sigue únicamente el acento activo del tema del menú.
function M.updateStealBarTheme()
    local accent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255, 255, 255)
    if M._stealBarStroke and M._stealBarStroke.Parent then
        M._stealBarStroke.Color = accent
    end
end

-- Keep steal-bar ping fresh (Anti-Sammy: LocalPlayer:GetNetworkPing()*1000)
task.spawn(function()
    while true do
        task.wait(0.5)
        if M.stealBarPingLbl or M.autoGrabDesign2Ping then
            local pingMs = 0
            pcall(function()
                pingMs = math.floor((player:GetNetworkPing() or 0) * 1000 + 0.5)
            end)
            M._lastPingMs = pingMs
            if M.stealBarPingLbl and M.stealBarPingLbl.Parent then
                M.stealBarPingLbl.Text = tostring(pingMs) .. " ms"
                if pingMs > 150 then
                    M.stealBarPingLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
                elseif pingMs > 100 then
                    M.stealBarPingLbl.TextColor3 = Color3.fromRGB(255, 205, 110)
                else
                    M.stealBarPingLbl.TextColor3 = Color3.fromRGB(115, 235, 175)
                end
            end
            if M.autoGrabDesign2Ping and M.autoGrabDesign2Ping.Parent then
                M.autoGrabDesign2Ping.Text = tostring(pingMs) .. " ms"
            end
        end
    end
end)

function M.ensureAutoGrabV1Gui()
    if M.autoGrabV1Gui and M.autoGrabV1Gui.Parent then return end
    local pg=player:WaitForChild("PlayerGui")
    for _,name in ipairs({"MoveeStealBar"}) do
        local a=game:GetService("CoreGui"):FindFirstChild(name); if a then a:Destroy() end
        local b=pg:FindFirstChild(name); if b then b:Destroy() end
    end
    local WHITE=Color3.fromRGB(255,255,255)
    local gui=Instance.new("ScreenGui"); gui.Name="MoveeStealBar"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.DisplayOrder=200
    if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=pg end
    gui.Enabled = not _G.PrimeHubIntroActive

    M.stealBarWidth = math.clamp(tonumber(M.stealBarWidth) or 360, 260, 560)
    -- V2 uses the same configurable width as V1.
    local barWidth = M.stealBarWidth
    local barHeight = 40

    local frame=Instance.new("Frame",gui); frame.Name="StealProgressGui"; frame.Size=UDim2.new(0,barWidth,0,barHeight); frame.Position=UDim2.new(0.5,-barWidth/2,0.06,0); frame.BackgroundColor3=Color3.fromRGB(14,16,24); frame.BackgroundTransparency=0.02; frame.BorderSizePixel=0; frame.ZIndex=20; frame.ClipsDescendants=true
    local frameCorner=Instance.new("UICorner",frame); frameCorner.CornerRadius=UDim.new(0,12)
    -- Borde limpio y sutil para separar la barra del fondo.
    local stroke=Instance.new("UIStroke",frame); stroke.Name="StealBarStroke"; stroke.Color=UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255,255,255); stroke.Thickness=1.25; stroke.Transparency=0.18
    local frameGradient=Instance.new("UIGradient",frame); frameGradient.Color=ColorSequence.new(Color3.fromRGB(28,22,42),Color3.fromRGB(12,18,30)); frameGradient.Rotation=90
    local fill=Instance.new("Frame",frame); fill.Name="ProgressFill"; fill.Position=UDim2.new(0,2,0,2); fill.Size=UDim2.new(0,0,1,-4); fill.BackgroundColor3=Color3.fromRGB(255,255,255); fill.BorderSizePixel=0; fill.ZIndex=21; Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local gradient=Instance.new("UIGradient",fill)
    -- White fill with subtle moving plomo shimmer (solo el relleno, no el borde)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(190, 192, 200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 154, 165)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(190, 192, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    })
    gradient.Rotation = 0
    gradient.Offset = Vector2.new(-1, 0)
    task.spawn(function()
        while frame and frame.Parent do
            local t = tick() * 6
            if gradient and gradient.Parent then
                local off = ((t * 0.32) % 2) - 1
                gradient.Offset = Vector2.new(off, 0)
            end
            task.wait(0.06)
        end
    end)
    local section=Instance.new("Frame",frame); section.Size=UDim2.new(0,barWidth-24,1,-4); section.Position=UDim2.new(0,12,0,2); section.BackgroundTransparency=1; section.ZIndex=25
    local hubLabel=Instance.new("TextLabel",section); hubLabel.Size=UDim2.new(0,92,1,0); hubLabel.Position=UDim2.new(0,0,0,0); hubLabel.BackgroundTransparency=1; hubLabel.Text="AUTO STEAL"; hubLabel.TextColor3=Color3.fromRGB(255,225,250); hubLabel.Font=Enum.Font.GothamBold; hubLabel.TextSize=11; hubLabel.TextXAlignment=Enum.TextXAlignment.Left; hubLabel.TextYAlignment=Enum.TextYAlignment.Center; hubLabel.ZIndex=26
    local pct=Instance.new("TextLabel",section); pct.Size=UDim2.new(0,92,1,0); pct.Position=UDim2.new(0,98,0,0); pct.BackgroundTransparency=1; pct.Text="0%"; pct.TextColor3=Color3.fromRGB(255,255,255); pct.Font=Enum.Font.GothamBlack; pct.TextSize=14; pct.TextXAlignment=Enum.TextXAlignment.Left; pct.TextYAlignment=Enum.TextYAlignment.Center; pct.ZIndex=26

    -- V2: wide card design.
    local design2=Instance.new("Frame",frame); design2.Name="AutoGrabDesign2"; design2.Size=UDim2.fromScale(1,1); design2.BackgroundColor3=Color3.fromRGB(22,31,45); design2.BackgroundTransparency=0.04; design2.BorderSizePixel=0; design2.ZIndex=30; design2.Visible=M.autoGrabMode=="V2"
    local d2Corner=Instance.new("UICorner",design2); d2Corner.CornerRadius=UDim.new(0,8)
    local d2Gradient=Instance.new("UIGradient",design2); d2Gradient.Color=ColorSequence.new(Color3.fromRGB(46,35,65),Color3.fromRGB(23,20,34)); d2Gradient.Rotation=8
    local d2Scale=Instance.new("UIScale",design2); d2Scale.Scale=math.clamp(barWidth/320,0.6,1)
    local d2Divider=Instance.new("Frame",design2); d2Divider.Position=UDim2.new(0,100,0,0); d2Divider.Size=UDim2.new(0,1,1,0); d2Divider.BackgroundColor3=Color3.fromRGB(110,135,165); d2Divider.BackgroundTransparency=0.45; d2Divider.BorderSizePixel=0; d2Divider.ZIndex=31
    local d2Status=Instance.new("TextLabel",design2); d2Status.Name="Status"; d2Status.Position=UDim2.new(0,12,0,2); d2Status.Size=UDim2.new(0,78,0,14); d2Status.BackgroundTransparency=1; d2Status.Text="STEAL"; d2Status.TextColor3=Color3.fromRGB(205,220,235); d2Status.Font=Enum.Font.GothamBold; d2Status.TextSize=10; d2Status.TextXAlignment=Enum.TextXAlignment.Left; d2Status.ZIndex=32
    local d2Percent=Instance.new("TextLabel",design2); d2Percent.Name="Percent"; d2Percent.Position=UDim2.new(0,12,0,16); d2Percent.Size=UDim2.new(0,78,0,14); d2Percent.BackgroundTransparency=1; d2Percent.Text="0%"; d2Percent.TextColor3=Color3.fromRGB(240,248,255); d2Percent.Font=Enum.Font.GothamBlack; d2Percent.TextSize=14; d2Percent.TextXAlignment=Enum.TextXAlignment.Left; d2Percent.ZIndex=32
    local d2Track=Instance.new("Frame",design2); d2Track.Position=UDim2.new(0,120,0,6); d2Track.Size=UDim2.new(0,170,0,18); d2Track.BackgroundColor3=Color3.fromRGB(28,28,32); d2Track.BackgroundTransparency=0.1; d2Track.BorderSizePixel=0; d2Track.ZIndex=31; Instance.new("UICorner",d2Track).CornerRadius=UDim.new(1,0)
    local d2Fill=Instance.new("Frame",d2Track); d2Fill.Name="ProgressFill"; d2Fill.Size=UDim2.new(0,0,1,0); d2Fill.BackgroundColor3=Color3.fromRGB(255,255,255); d2Fill.BorderSizePixel=0; d2Fill.ZIndex=32; Instance.new("UICorner",d2Fill).CornerRadius=UDim.new(1,0)
    local d2FillGradient=Instance.new("UIGradient",d2Fill)
    d2FillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(175, 178, 188)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 134, 145)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(175, 178, 188)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    })
    d2FillGradient.Offset = Vector2.new(-1, 0)
    -- solo shimmer en el fill blanco (sin movimiento en borde)
    task.spawn(function()
        while d2Track and d2Track.Parent do
            local t = tick() * 6
            if d2FillGradient and d2FillGradient.Parent then
                local off = ((t * 0.32) % 2) - 1
                d2FillGradient.Offset = Vector2.new(off, 0)
            end
            task.wait(0.06)
        end
    end)
    M.autoGrabDesign2Fill=d2Fill; M.autoGrabDesign2Percent=d2Percent; M.autoGrabDesign2Status=d2Status

    -- no +/- or lock on bar; lock uses menu M.uiLocked; size in menu
    function M.resizeStealBar(delta)
        barWidth = math.clamp((M.stealBarWidth or barWidth) + (delta or 0), 260, 560)
        M.stealBarWidth = barWidth
        if frame and frame.Parent then
            local cx = frame.Position.X.Offset + frame.Size.X.Offset / 2
            frame.Size = UDim2.new(0, barWidth, 0, 40)
            frame.Position = UDim2.new(frame.Position.X.Scale, cx - barWidth / 2, frame.Position.Y.Scale, frame.Position.Y.Offset)
            if d2Scale then d2Scale.Scale=math.clamp(barWidth/320,0.6,1) end
        end
        if M.saveConfig then pcall(M.saveConfig) end
    end

    local dragging=false; local dragStart; local frameStart
    frame.InputBegan:Connect(function(input)
        if M.uiLocked then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; frameStart=frame.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if M.uiLocked or not dragging then return end
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            local delta=input.Position-dragStart
            frame.Position=UDim2.new(frameStart.X.Scale,frameStart.X.Offset+delta.X,frameStart.Y.Scale,frameStart.Y.Offset+delta.Y)
        end
    end)

    
    -- Ping next to % (small, readable) — GetNetworkPing()*1000
    local pingLbl = Instance.new("TextLabel", section)
    pingLbl.Name = "PingLbl"
    pingLbl.Position = UDim2.new(0, 198, 0, 0)
    pingLbl.Size = UDim2.new(0, 72, 1, 0)
    pingLbl.BackgroundTransparency = 1
    pingLbl.Text = "-- ms"
    pingLbl.TextColor3 = Color3.fromRGB(115, 235, 175)
    pingLbl.Font = Enum.Font.GothamMedium
    pingLbl.TextSize = 11
    pingLbl.TextXAlignment = Enum.TextXAlignment.Left
    pingLbl.TextYAlignment = Enum.TextYAlignment.Center
    pingLbl.ZIndex = 27
    M.stealBarPingLbl = pingLbl
    -- design2: ping beside percent
    if design2 and d2Percent then
        local d2ping = Instance.new("TextLabel", design2)
        d2ping.Name = "PingLbl"
        d2ping.Position = UDim2.new(0, 55, 0, 16)
        d2ping.Size = UDim2.new(0, 50, 0, 14)
        d2ping.BackgroundTransparency = 1
        d2ping.Text = "-- ms"
        d2ping.TextColor3 = Color3.fromRGB(115, 235, 175)
        d2ping.Font = Enum.Font.GothamMedium
        d2ping.TextSize = 11
        d2ping.TextXAlignment = Enum.TextXAlignment.Left
        d2ping.ZIndex = 35
        M.autoGrabDesign2Ping = d2ping
        d2Percent.TextColor3 = Color3.fromRGB(255, 255, 255)
        d2Percent.TextSize = 14
        d2Status.TextColor3 = Color3.fromRGB(240, 240, 245)
    end

    M.autoGrabV1Gui,M.autoGrabV1Fill,M.autoGrabV1Label=gui,fill,pct
    M._stealBarFrame = frame
    M._stealBarStroke = stroke
    M.autoGrabDesign2 = design2
    M.updateStealBarTheme()
    if M.autoGrabMode == "V2" then section.Visible=false; fill.Visible=false else design2.Visible=false end
    zenXUpdateBar()
end
local function zenXExecuteSteal(prompt)
    if zenXStealing then return end
    if not ZenXSteal.Data[prompt] then
        ZenXSteal.Data[prompt] = {hold={}, trigger={}, ready=true}
        if getconnections then
            pcall(function()
                for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(ZenXSteal.Data[prompt].hold, c.Function) end
                end
                for _,c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(ZenXSteal.Data[prompt].trigger, c.Function) end
                end
            end)
        end
    end
    local data = ZenXSteal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    zenXStealing = true
    zenXStealPaused = false
    zenXStealStartTime = tick()
    M.autoGrabV1Ready = false
    M.autoGrabV1Progress = 0
    if M.zenXUpdateBar then M.zenXUpdateBar() else zenXUpdateBar() end

    -- Anti-Sammy safe steal: hold to preset %, wait until close, finish
    local spawnPosition = nil
    do
        local parent = prompt.Parent
        if parent and parent.Name == "PromptAttachment" then parent = parent.Parent end
        if parent and parent.Name == "Spawn" and parent:IsA("BasePart") then
            spawnPosition = parent.Position
        elseif parent and parent:IsA("BasePart") then
            spawnPosition = parent.Position
        end
    end

    local duration = math.max(tonumber(ZenXSteal.StealDuration) or 1.3, 0.05)
    local presetKey = tostring(M.normalStealVersion or "86")
    local percents = M.NORMAL_STEAL_PERCENT or {["75"]=0.75,["80"]=0.80,["86"]=0.86,["90"]=0.90}
    local stopRatio = percents[presetKey] or 0.86
    local stopPoint = duration * stopRatio

    task.spawn(function()
        for _,fn in ipairs(data.hold) do task.spawn(fn) end

        -- Phase 1: hold until preset %
        local started = tick()
        while zenXStealing and M.autoGrabV1Enabled and prompt.Parent do
            local elapsed = tick() - started
            M.autoGrabV1Progress = math.clamp(elapsed / duration, 0, stopRatio)
            pcall(function() getgenv()._AS_StealProgress = M.autoGrabV1Progress end)
            if M.zenXUpdateBar then M.zenXUpdateBar() else zenXUpdateBar() end
            if elapsed >= stopPoint then break end
            task.wait()
        end

        M.autoGrabV1Progress = stopRatio
        pcall(function() getgenv()._AS_StealProgress = stopRatio end)
        zenXStealPaused = true
        if M.zenXUpdateBar then M.zenXUpdateBar() else zenXUpdateBar() end

        -- Phase 2: wait until close to target (safe)
        local function isClose()
            if not spawnPosition then return true end
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            return root and (spawnPosition - root.Position).Magnitude <= (ZenXSteal.HalfFireRange or 9)
        end

        local closeEnough = isClose()
        local waitDeadline = tick() + 2
        while zenXStealing and M.autoGrabV1Enabled and prompt.Parent and not closeEnough and tick() < waitDeadline do
            closeEnough = isClose()
            task.wait()
        end

        -- Phase 3: finish remaining % and trigger
        if closeEnough and zenXStealing and M.autoGrabV1Enabled and prompt.Parent then
            zenXStealPaused = false
            local remaining = math.max(duration - stopPoint, 0.01)
            local finishStarted = tick()
            while zenXStealing and M.autoGrabV1Enabled and prompt.Parent do
                local finishAlpha = math.clamp((tick() - finishStarted) / remaining, 0, 1)
                M.autoGrabV1Progress = stopRatio + finishAlpha * (1 - stopRatio)
                pcall(function() getgenv()._AS_StealProgress = M.autoGrabV1Progress end)
                if M.zenXUpdateBar then M.zenXUpdateBar() else zenXUpdateBar() end
                if finishAlpha >= 1 then break end
                task.wait()
            end
            if zenXStealing and M.autoGrabV1Enabled and prompt.Parent then
                for _,fn in ipairs(data.trigger) do task.spawn(fn) end
            end
        end

        task.wait(0.05)
        data.ready = true
        zenXStealing = false
        zenXStealPaused = false
        zenXStealStartTime = nil
        zenXLastPrompt = prompt
        zenXNextPromptTime = tick() + 0.5
        M.autoGrabV1Progress = 0
        M.autoGrabV1Ready = M.autoGrabV1Enabled
        pcall(function() getgenv()._AS_StealProgress = 0 end)
        if M.zenXUpdateBar then M.zenXUpdateBar() else zenXUpdateBar() end
    end)
end

function M.startAutoGrabV1()
    M.autoGrabV1Enabled = true
    ZenXSteal.AutoStealEnabled = true
    if _G.PrimeHubIntroActive then
        _G.PrimeHubIntroDoneCallbacks = _G.PrimeHubIntroDoneCallbacks or {}
        table.insert(_G.PrimeHubIntroDoneCallbacks, function()
            if M.autoGrabV1Enabled then
                pcall(function()
                    M.ensureAutoGrabV1Gui()
                    if M.autoGrabV1Gui then M.autoGrabV1Gui.Enabled = true end
                    M.autoGrabV1Ready = true
                    zenXUpdateBar()
                    if not M.autoGrabV1Conn then
                        M.autoGrabV1Conn = RunService.Heartbeat:Connect(function()
                            if not M.autoGrabV1Enabled or zenXStealing then return end
                            local p = zenXFindNearestPrompt()
                            if p then
                                M.autoGrabV1Ready = false
                                zenXExecuteSteal(p)
                            else
                                M.autoGrabV1Ready = true
                                M.autoGrabV1Progress = 0
                                zenXUpdateBar()
                            end
                        end)
                    end
                end)
            end
        end)
        return
    end
    M.ensureAutoGrabV1Gui()
    if M.autoGrabV1Gui then M.autoGrabV1Gui.Enabled = true end
    M.autoGrabV1Ready = true
    zenXUpdateBar()
    if M.autoGrabV1Conn then return end
    M.autoGrabV1Conn = RunService.Heartbeat:Connect(function()
        if not M.autoGrabV1Enabled or zenXStealing then return end
        local p = zenXFindNearestPrompt()
        if p then
            M.autoGrabV1Ready = false
            zenXExecuteSteal(p)
        else
            M.autoGrabV1Ready = true
            M.autoGrabV1Progress = 0
            zenXUpdateBar()
        end
    end)
end
function M.stopAutoGrabV1()
    M.autoGrabV1Enabled=false; ZenXSteal.AutoStealEnabled=false; M.autoGrabV1Busy=false; M.autoGrabV1Ready=false; M.autoGrabV1Progress=0
    if M.autoGrabV1Conn then M.autoGrabV1Conn:Disconnect(); M.autoGrabV1Conn=nil end
    zenXUpdateBar()
end
task.defer(function()
    while _G.PrimeHubIntroActive do task.wait(0.1) end
    task.wait(0.05)
    if M.autoGrabV1Enabled ~= false then
        pcall(M.startAutoGrabV1)
    end
end)
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
        if part.Anchored and part.Transparency==1 then
            if M.medusaCounterEnabled then M.useMedusaCounter() end
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

-- ==================== BAT COUNTER V2 (CLEAN) ====================
M.batCounterV2Enabled = M.batCounterV2Enabled == true
M._batCounterV2Conn = nil
M._batCounterV2Debounce = false
M._batCounterV2HitCD = false
M.BAT_COUNTER_V2_SWING_CD = 0.08

local function _bc2HasAnimal(plr)
    if not plr or not plr.Character then return false end
    for _, child in ipairs(plr.Character:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if child:FindFirstChild("Handle") or n:find("animal") or n:find("pet") or n:find("brainrot") then
                return true
            end
        end
    end
    return false
end

local function _bc2GetAttacker()
    local myChar = player.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and _bc2HasAnimal(plr) then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - myRoot.Position).Magnitude
                if dist < 12 and dist < minDist then
                    minDist = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

local function _bc2GetBat()
    local char = player.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if n:find("bat") or n:find("slap") or n:find("sword") or n:find("knife") then return child end
        end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then
                local n = child.Name:lower()
                if n:find("bat") or n:find("slap") or n:find("sword") or n:find("knife") then return child end
            end
        end
    end
    return nil
end

local function _bc2TryHit()
    if M._batCounterV2HitCD then return end
    M._batCounterV2HitCD = true
    pcall(function()
        local bat = _bc2GetBat()
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if bat and hum and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
        if bat then
            pcall(function() bat:Activate() end)
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
        end
    end)
    task.delay(M.BAT_COUNTER_V2_SWING_CD or 0.08, function() M._batCounterV2HitCD = false end)
end

function M.startBatCounterV2()
    if M._batCounterV2Conn then return end
    M.batCounterV2Enabled = true
    M._batCounterV2Conn = RunService.Heartbeat:Connect(function()
        if not M.batCounterV2Enabled or M._batCounterV2Debounce then return end
        local attacker = _bc2GetAttacker()
        if not attacker then return end
        local aChar = attacker.Character
        local aHum = aChar and aChar:FindFirstChildOfClass("Humanoid")
        if aHum then
            local st = aHum:GetState()
            if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
                return
            end
        end
        M._batCounterV2Debounce = true
        local myChar = player.Character
        local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local attRoot = aChar and aChar:FindFirstChild("HumanoidRootPart")
        if hrp and attRoot then
            local targetPos = attRoot.Position + Vector3.new(0, 0.9, 0)
            if (hrp.Position - targetPos).Magnitude > 8 then
                pcall(function() hrp.CFrame = CFrame.new(targetPos) end)
            end
            if sethiddenproperty then
                pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", attRoot) end)
            end
            _bc2TryHit()
            task.delay(0.05, _bc2TryHit)
            task.delay(0.1, _bc2TryHit)
        end
        task.delay(0.35, function() M._batCounterV2Debounce = false end)
    end)
end

function M.stopBatCounterV2()
    M.batCounterV2Enabled = false
    if M._batCounterV2Conn then
        M._batCounterV2Conn:Disconnect()
        M._batCounterV2Conn = nil
    end
    M._batCounterV2Debounce = false
    M._batCounterV2HitCD = false
end

M.aimbotSpeed = M.aimbotSpeed or 58
M.laggerAimbotSpeed = M.laggerAimbotSpeed or 40
M._aimbotSwingCooldown = false
function M.findBatForAimbot()
    local char = player.Character
    if not char then return nil end
    local SlapList = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
    for _, name in ipairs(SlapList) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then
            return t
        end
    end
    local bp = player:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(SlapList) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then return t end
        end
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then
                return t
            end
        end
    end
    return nil
end
function M.getClosestTargetAimbot()
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                if not (M._isProtectedBatTarget and M._isProtectedBatTarget(plr.Character)) then
                    local dist = (tRoot.Position - root.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = tRoot
                    end
                end
            end
        end
    end
    return closest
end
function M._isProtectedBatTarget(character)
    return character and (character:FindFirstChild("Anti-Bat") or character:FindFirstChild("AntiBat") or character:FindFirstChild("Shield")) ~= nil
end
function M._swingBatTool(char)
    pcall(function()
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool then
            local n = currentTool.Name:lower()
            if not (n:find("bat") or n:find("slap")) then
                return
            end
        end
        local bat = M.findBatForAimbot()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
end
function M.startBatAimbot()
    if M.aimbotConn then
        pcall(function() M.aimbotConn:Disconnect() end)
        M.aimbotConn = nil
    end
    if M.safeModeTryStart and not M.safeModeTryStart() then return end
    M.autoBatEnabled = true
    local oldAimbotSwingCooldown = false
    local hum0 = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

    -- 7UP Aimbot Old behavior
    M.aimbotConn = RunService.RenderStepped:Connect(function()
        if not M.autoBatEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local bat = char:FindFirstChildOfClass("Tool") or M.findBatForAimbot()
        if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
        local target = M.getClosestTargetAimbot()
        if not target then return end
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        if direction.Magnitude < 0.01 then return end
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude < 0.01 then return end
        flatDir = flatDir.Unit
        local chaseSpeed = math.clamp(tonumber(M.aimbotSpeed) or 60, 1, 500)
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed), 0.8)
        local predictTime = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(rx, -2.5, 2.5) * 42, math.clamp(ry, -2.5, 2.5) * 42, math.clamp(rz, -2.5, 2.5) * 42))
        end
        if M.autoSwingEnabled and bat and not oldAimbotSwingCooldown then
            oldAimbotSwingCooldown = true
            pcall(function() bat:Activate() end)
            task.delay(0.08, function() oldAimbotSwingCooldown = false end)
        end
    end)
    if M.autoBatSetVisual then M.autoBatSetVisual(true) end
    if M.mobBtnRefs and M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(true) end
end
function M.stopBatAimbot()
    if M.aimbotConn then
        pcall(function() M.aimbotConn:Disconnect() end)
        M.aimbotConn = nil
    end
    M.autoBatEnabled = false
    M._aimbotSwingCooldown = false
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (M._aimbotPrevAutoRotate == nil) and true or M._aimbotPrevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end
    M._aimbotPrevAutoRotate = nil
    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
    if M.mobBtnRefs and M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
end
function M.queueAutoBatStart()
    if M.safeModeTryStart and not M.safeModeTryStart() then return end
    if M.antiKickEnabled and M.brainrotDetected then return end
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
    M.startBatAimbot()
end
function M.swingCurrentBatAimbot(char)
    if not M.autoSwingEnabled then return end
    local bat = M.findBatForAimbot()
    if bat and bat.Parent == char then
        pcall(function() bat:Activate() end)
    end
end
M._bypassTarget = nil
M._bypassHRP = nil
M._bypassHum = nil
M.tpBatRange = M.tpBatRange or 1e9
M.tpBatClose = M.tpBatClose or 6
M.tpBatOffset = M.tpBatOffset or 2.4
M._tpBatLastSwing = 0
M._bypassSwingCooldown = false
function M._bypassFindBat()
    local char = player.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end
    local bp = player:FindFirstChild("Backpack") or player:FindFirstChildOfClass("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
    end
    return nil
end
function M._bypassGetClosest()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 and not M._isProtectedBatTarget(plr.Character) then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest, minDist
end
function M._bypassClearGodConns()
    for _, key in ipairs({"_bypassGodConn", "_bypassGodHealthConn", "_bypassGodDiedConn", "_bypassGodCharConn"}) do
        local c = M[key]
        if c then pcall(function() c:Disconnect() end); M[key] = nil end
    end
end
function M._bypassProtectCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.MaxHealth = math.max(hum.MaxHealth, 100)
        if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end)
    if M._bypassGodHealthConn then pcall(function() M._bypassGodHealthConn:Disconnect() end) end
    M._bypassGodHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not M.bypassAimbotEnabled then return end
        if hum.Health < hum.MaxHealth then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
    end)
    if M._bypassGodDiedConn then pcall(function() M._bypassGodDiedConn:Disconnect() end) end
    M._bypassGodDiedConn = hum.Died:Connect(function()
        if not M.bypassAimbotEnabled then return end
        pcall(function()
            hum.Health = hum.MaxHealth
            hum:ChangeState(Enum.HumanoidStateType.Running)
            hum.PlatformStand = false
        end)
    end)
end
function M.enableBypassGodmode()
    M._bypassClearGodConns()
    local char = player.Character
    if char then M._bypassProtectCharacter(char) end
    M._bypassGodCharConn = player.CharacterAdded:Connect(function(c)
        if not M.bypassAimbotEnabled then return end
        task.wait(0.15)
        M._bypassProtectCharacter(c)
    end)
    M._bypassGodConn = RunService.Heartbeat:Connect(function()
        if not M.bypassAimbotEnabled then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        pcall(function()
            if hum.Health < (hum.MaxHealth or 100) then
                hum.Health = hum.MaxHealth or 100
            end
            if hum:GetState() == Enum.HumanoidStateType.Dead then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end)
end
function M.disableBypassGodmode()
    M._bypassClearGodConns()
end

-- ==================== ANTI DESYNC (from Void TP Bat) ====================
function M.closestRoot()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local best, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum and hum.Health > 0 then
                local d = (tr.Position - root.Position).Magnitude
                if d < dist then dist = d; best = tr end
            end
        end
    end
    return best, dist
end

function M.tpHit()
    if M._tpHitCD then return end
    M._tpHitCD = true
    pcall(function()
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local bat = char:FindFirstChildOfClass("Tool")
        if not bat then
            local bp = player:FindFirstChildOfClass("Backpack")
            if bp then
                for _, t in ipairs(bp:GetChildren()) do
                    if t:IsA("Tool") then
                        local n = t.Name:lower()
                        if n:find("bat") or n:find("slap") then bat = t; break end
                    end
                end
            end
        end
        if not bat then return end
        if bat.Parent ~= char and hum then pcall(function() hum:EquipTool(bat) end) end
        for _ = 1, 3 do
            pcall(function() bat:Activate() end)
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer(0) end) end
            for _, d in ipairs(bat:GetDescendants()) do
                if d:IsA("RemoteEvent") then pcall(function() d:FireServer(0) end) end
            end
        end
    end)
    task.delay(0.08, function() M._tpHitCD = false end)
end

local function _forceAimbotOffForTP()
    M.autoBatEnabled = false
    if M.aimbotConn then pcall(function() M.aimbotConn:Disconnect() end); M.aimbotConn = nil end
    if M.stopBatAimbot then pcall(M.stopBatAimbot) end
    pcall(function()
        if M.autoBatSetVisual then M.autoBatSetVisual(false) end
        if M.mobBtnRefs and M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
    end)
end

-- ===== TP BAT (Anti-Sammy style) =====
M._adaptTpBatCooldown = false
M._adaptTpBatCharacter = nil
M._adaptTpBatHumanoid = nil
M._adaptTpBatRoot = nil
M._blessTpBatConn = nil
M.tpBatVersion = M.tpBatVersion or "V1"  -- V1 = distance>8, V2 = distance>3

function M._antiSammyGetBat()
    local char = player.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        tool = bp:FindFirstChild("Bat")
        if tool then
            tool.Parent = char
            return tool
        end
    end
    if M._bypassFindBat then
        return M._bypassFindBat()
    end
    return nil
end

function M._adaptTpBatTryHit()
    if M._adaptTpBatCooldown then return end
    M._adaptTpBatCooldown = true
    pcall(function()
        local bat = M._antiSammyGetBat()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then
                pcall(function() ev:FireServer() end)
            end
        end
    end)
    task.delay(0.08, function() M._adaptTpBatCooldown = false end)
end

function M.restoreCharacterMovement(char)
    char = char or player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
        end)
    end
    if hum then
        pcall(function()
            hum.PlatformStand = false
            hum.Sit = false
            hum.AutoRotate = true
            if hum.WalkSpeed <= 0 then hum.WalkSpeed = 16 end
            if hum.UseJumpPower and hum.JumpPower <= 0 then hum.JumpPower = 50 end
            if not hum.UseJumpPower and hum.JumpHeight <= 0 then hum.JumpHeight = 7.2 end
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
        task.defer(function()
            if hum.Parent and hum.Health > 0 then
                pcall(function()
                    hum.PlatformStand = false
                    hum.Sit = false
                    hum.AutoRotate = true
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end)
    end
end

function M.startBypassAimbot()
    if M.safeModeTryStart and not M.safeModeTryStart() then return end
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end
    if M._blessTpBatConn then
        pcall(function() M._blessTpBatConn:Disconnect() end)
        M._blessTpBatConn = nil
    end
    if M._tpShieldConn then pcall(function() M._tpShieldConn:Disconnect() end); M._tpShieldConn = nil end
    if M._tpAntiDieConn then pcall(function() M._tpAntiDieConn:Disconnect() end); M._tpAntiDieConn = nil end
    if M._tpCharConn then pcall(function() M._tpCharConn:Disconnect() end); M._tpCharConn = nil end

    if _forceAimbotOffForTP then pcall(_forceAimbotOffForTP) end

    if M.batV2Enabled and M.stopBatV2 then
        pcall(function()
            M.stopBatV2()
            M.batV2Enabled = false
            if M.mobBtnRefs and M.mobBtnRefs.batV2 then M.mobBtnRefs.batV2(false) end
            if M.setBatV2Visual then M.setBatV2Visual(false) end
        end)
    end

    M.bypassAimbotEnabled = true
    M._adaptTpBatCooldown = false

    -- Anti-Sammy TP Bat Heartbeat (threshold follows live M.tpBatVersion)
    M.bypassAimbotConn = RunService.Heartbeat:Connect(function()
        if not M.bypassAimbotEnabled then return end
        local distThreshold = (tostring(M.tpBatVersion) == "V2") and 3 or 8
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local target, dist = nil, math.huge
        if M._bypassGetClosest then
            target, dist = M._bypassGetClosest()
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local tr = p.Character:FindFirstChild("HumanoidRootPart")
                    if tr then
                        local d = (root.Position - tr.Position).Magnitude
                        if d < dist then
                            dist = d
                            target = tr
                        end
                    end
                end
            end
        end

        if not target or not target.Parent then return end

        if sethiddenproperty then
            pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", target) end)
        end

        local targetPos = target.Position + Vector3.new(0, 0.9, 0)
        if (root.Position - targetPos).Magnitude > distThreshold then
            root.CFrame = CFrame.new(targetPos)
        end

        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
        end

        M._adaptTpBatTryHit()
    end)

    if M.setBypassVisual then M.setBypassVisual(true) end
    if M.mobBtnRefs and M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(true) end
    if M.mobBtnRefs and M.mobBtnRefs.tpBat then M.mobBtnRefs.tpBat(true) end
end

function M.stopBypassAimbot()
    M.bypassAimbotEnabled = false
    M._adaptTpBatCooldown = false
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end
    if M._blessTpBatConn then
        pcall(function() M._blessTpBatConn:Disconnect() end)
        M._blessTpBatConn = nil
    end
    if M._tpShieldConn then pcall(function() M._tpShieldConn:Disconnect() end); M._tpShieldConn = nil end
    if M._tpAntiDieConn then pcall(function() M._tpAntiDieConn:Disconnect() end); M._tpAntiDieConn = nil end
    if M._tpCharConn then pcall(function() M._tpCharConn:Disconnect() end); M._tpCharConn = nil end
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam and cam.CameraType == Enum.CameraType.Scriptable then
            cam.CameraType = Enum.CameraType.Custom
        end
    end)
    if M.restoreCharacterMovement then
        pcall(function() M.restoreCharacterMovement(player.Character) end)
    end
    -- reset PhysicsRepRootPart
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and sethiddenproperty then
        pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)
    end
    M._adaptTpBatCharacter = nil
    M._adaptTpBatHumanoid = nil
    M._adaptTpBatRoot = nil
    if M.setBypassVisual then M.setBypassVisual(false) end
    if M.mobBtnRefs and M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(false) end
    if M.mobBtnRefs and M.mobBtnRefs.tpBat then M.mobBtnRefs.tpBat(false) end
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
    if M.mobBtnRefs and M.mobBtnRefs.bypass then
        M.mobBtnRefs.bypass(M.bypassAimbotEnabled)
    end
    if M.mobBtnRefs and M.mobBtnRefs.tpBat then
        M.mobBtnRefs.tpBat(M.bypassAimbotEnabled)
    end
    if savePrimeHubFeKlanConfig then
        pcall(savePrimeHubFeKlanConfig)
    elseif M.saveConfig then
        pcall(M.saveConfig)
    end
    return M.bypassAimbotEnabled
end


function M.doAutoTPDown(force)
    local char=player.Character;if not char then return end;local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0);hrp.Velocity=Vector3.zero
end
function M.runTPFloor() pcall(function() M.doAutoTPDown(true) end) end
function M.enableStretchRez()
    M.stretchRezEnabled=true;if M.stretchRezConn then M.stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep("Movee_Stretch") end)
    pcall(function() RunService:BindToRenderStep("Movee_Stretch",Enum.RenderPriority.Last.Value-1,function() local cam=workspace.CurrentCamera;if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,0.8,0,0,0,1) end end) end)
end
function M.disableStretchRez() M.stretchRezEnabled=false;pcall(function() RunService:UnbindFromRenderStep("Movee_Stretch") end) end
function M.isSummerBaseName(name)
    if not name then return false end
    local n = tostring(name):lower()
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
        if not isSummer then     end
        for _, d in ipairs(plot:GetDescendants()) do
            if M.isAnchorName(d.Name) then
                M.stripBlockingAnchor(d)
            end
        end
    end
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
            task.wait(5)
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
function M._disableCartonPostEffect(obj)
    if not obj then return end
    if obj:IsA("PostEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect") or obj:IsA("ColorCorrectionEffect")
        or obj:IsA("BloomEffect") or obj:IsA("DepthOfFieldEffect") then
        obj.Enabled = false
    end
end
function M._refreshCartonTerrain()
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if not terrain then return end
    pcall(function()
        terrain.Decoration = false
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(35, 190, 45))
        terrain:SetMaterialColor(Enum.Material.Ground, Color3.fromRGB(35, 190, 45))
        terrain:SetMaterialColor(Enum.Material.Slate, Color3.fromRGB(35, 190, 45))
    end)
end
-- Anti-Lag 7UP implementation
M._newAntiLagConn = nil
M.antiLagEnabled = false

function M._applyAntiLagObj(obj)
    pcall(function()
        if not obj or not obj.Parent then return end
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        end
    end)
end

function M.enableAntiLag()
    M.antiLagEnabled = true
    M._antiLagState = M._antiLagState or {}
    local S = M._antiLagState
    S.active = true
    S.defBrightness = S.defBrightness or Lighting.Brightness
    S.defFog = S.defFog or Lighting.FogEnd
    S.defDiffuse = S.defDiffuse or Lighting.EnvironmentDiffuseScale
    S.defSpecular = S.defSpecular or Lighting.EnvironmentSpecularScale
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    end)
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        M._applyAntiLagObj(obj)
    end
    if S.conn then pcall(function() S.conn:Disconnect() end) end
    S.conn = workspace.DescendantAdded:Connect(function(obj)
        if S.active then M._applyAntiLagObj(obj) end
    end)
    M._newAntiLagConn = S.conn
end

function M.disableAntiLag()
    M.antiLagEnabled = false
    local S = M._antiLagState or {}
    S.active = false
    if S.conn then pcall(function() S.conn:Disconnect() end); S.conn = nil end
    M._newAntiLagConn = nil
    pcall(function()
        Lighting.GlobalShadows = true
        if S.defBrightness then Lighting.Brightness = S.defBrightness end
        if S.defFog then Lighting.FogEnd = S.defFog end
        if S.defDiffuse then Lighting.EnvironmentDiffuseScale = S.defDiffuse end
        if S.defSpecular then Lighting.EnvironmentSpecularScale = S.defSpecular end
        for _, e in pairs(Lighting:GetChildren()) do
            pcall(function()
                if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                    or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                    e.Enabled = true
                end
            end)
        end
    end)
end

function M.enableNukeOptimizer()
    M.nukeOptimiserEnabled = true
    pcall(function() M.enableAntiLag() end)
    pcall(function() if M.CandyApplyCustomSky then M.CandyApplyCustomSky("Off") end end)
    if M._nukeConns then
        for _, c in ipairs(M._nukeConns) do pcall(function() c:Disconnect() end) end
    end
    M._nukeConns = {}
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            M._applyAntiLagObj(obj)
        end
    end)
    table.insert(M._nukeConns, workspace.DescendantAdded:Connect(function(o)
        if M.nukeOptimiserEnabled then M._applyAntiLagObj(o) end
    end))
    task.spawn(function()
        while M.nukeOptimiserEnabled do
            pcall(function()
                if type(setfpscap) == "function" then setfpscap(240) end
            end)
            task.wait(3)
        end
    end)
    if M.notify then pcall(function() M.notify("Nuke Optimizer ON") end) end
end

function M.disableNukeOptimizer()
    M.nukeOptimiserEnabled = false
    if M._nukeConns then
        for _, c in ipairs(M._nukeConns) do pcall(function() c:Disconnect() end) end
        M._nukeConns = {}
    end
end

function M.antiVoidSaveSafe()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    if hum.FloorMaterial ~= Enum.Material.Air then
        M._antiVoidSafeCFrame = root.CFrame
    end
end

function M.stopAntiVoid()
    M.antiVoidEnabled = false
    if M._antiVoidConn then
        pcall(function() M._antiVoidConn:Disconnect() end)
        M._antiVoidConn = nil
    end
end

function M.startAntiVoid()
    M.stopAntiVoid()
    M.antiVoidEnabled = true
    M.antiVoidSaveSafe()
    local _avSkip = 0
    M._antiVoidConn = RunService.Heartbeat:Connect(function()
        if not M.antiVoidEnabled then return end
        _avSkip = _avSkip + 1
        if _avSkip < 2 then return end
        _avSkip = 0
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        local voidY = workspace.FallenPartsDestroyHeight + 30
        if hum.FloorMaterial ~= Enum.Material.Air and root.Position.Y > voidY + 12 then
            M._antiVoidSafeCFrame = root.CFrame
        elseif root.Position.Y <= voidY and M._antiVoidSafeCFrame then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = M._antiVoidSafeCFrame + Vector3.new(0, 4, 0)
            hum.PlatformStand = false
            hum.Sit = false
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end)
end

function M.setAntiVoid(on)
    if on then M.startAntiVoid() else M.stopAntiVoid() end
end

M.bodyLockRadius = tonumber(M.bodyLockRadius) or 60
function M.getNearestBodyLockTarget()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tr = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum and hum.Health > 0 then
                local d = (tr.Position - root.Position).Magnitude
                if d <= (M.bodyLockRadius or 60) and d < shortest then
                    shortest = d
                    nearest = plr
                end
            end
        end
    end
    return nearest
end

function M.startBodyLock()
    if M._bodyLockConn then return end
    M.bodyLockEnabled = true
    M._bodyLockConn = RunService.Heartbeat:Connect(function()
        if not M.bodyLockEnabled then return end
        local character = player.Character
        local myRoot = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not myRoot or not humanoid or humanoid.Health <= 0 then return end
        local target = M.getNearestBodyLockTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            local myPos = myRoot.Position
            local offset = Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos
            if offset.Magnitude > 0.1 then
                humanoid.AutoRotate = false
                local lookDir = offset.Unit
                local currentDir = myRoot.CFrame.LookVector
                local cross = currentDir:Cross(lookDir)
                local currentVel = myRoot.AssemblyAngularVelocity
                myRoot.AssemblyAngularVelocity = Vector3.new(currentVel.X, cross.Y * 40, currentVel.Z)
            end
        else
            humanoid.AutoRotate = true
        end
    end)
end

function M.stopBodyLock()
    M.bodyLockEnabled = false
    if M._bodyLockConn then
        pcall(function() M._bodyLockConn:Disconnect() end)
        M._bodyLockConn = nil
    end
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end

function M.setBodyLock(on)
    if on then M.startBodyLock() else M.stopBodyLock() end
end


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
M.instaResetBusy = false
-- Insta Reset (Ice Hub style): huge upward AssemblyLinearVelocity
function M.doInstaReset()
    if M.instaResetBusy then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    M.instaResetBusy = true
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.new(
            hrp.AssemblyLinearVelocity.X,
            10000000,
            hrp.AssemblyLinearVelocity.Z
        )
    end)
    -- short debounce so mobile/keybind spam doesn't stack
    task.delay(0.35, function()
        M.instaResetBusy = false
    end)
end
-- ==================== ANTI RAGDOLL CLEAN V1 / V2 ====================
local AR_BOOST_SPEED = 400
local AR_DEFAULT_SPEED = 16
local _arV1 = {
    active = false,
    isBoosting = false,
    cached = nil,
    conns = {},
}
local _arV2 = {
    enabled = false,
    conn = nil,
    resetCooldown = 0,
}

local function _arV1Disconnect()
    for _, c in ipairs(_arV1.conns) do pcall(function() c:Disconnect() end) end
    _arV1.conns = {}
end

local function _arV1Cache()
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    _arV1.cached = { character = char, humanoid = hum, root = root }
    return true
end

local function _arV1IsRagdolled()
    if not _arV1.cached or not _arV1.cached.humanoid then return false end
    local st = _arV1.cached.humanoid:GetState()
    return st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

local function _arV1ForceExit()
    if not _arV1.cached or not _arV1.cached.humanoid or not _arV1.cached.root then return end
    local hum, root, char = _arV1.cached.humanoid, _arV1.cached.root, _arV1.cached.character
    pcall(function()
        player:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
            pcall(function() d:Destroy() end)
        end
    end
    if not _arV1.isBoosting then
        _arV1.isBoosting = true
        hum.WalkSpeed = AR_BOOST_SPEED
    end
    if hum.Health > 0 then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    root.Anchored = false
end

local function _arV1Loop()
    while _arV1.active do
        task.wait()
        if _arV1IsRagdolled() then
            _arV1ForceExit()
        elseif _arV1.isBoosting and not _arV1IsRagdolled() then
            _arV1.isBoosting = false
            if _arV1.cached and _arV1.cached.humanoid then
                _arV1.cached.humanoid.WalkSpeed = AR_DEFAULT_SPEED
            end
        end
    end
end

local function _arV1Start()
    if _arV1.active then return end
    _arV1Disconnect()
    if not _arV1Cache() then return end
    _arV1.active = true
    _arV1.isBoosting = false
    local camConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if cam and _arV1.cached and _arV1.cached.humanoid then
            cam.CameraSubject = _arV1.cached.humanoid
        end
    end)
    table.insert(_arV1.conns, camConn)
    local respawnConn = player.CharacterAdded:Connect(function()
        _arV1.isBoosting = false
        task.wait(0.5)
        _arV1Cache()
    end)
    table.insert(_arV1.conns, respawnConn)
    task.spawn(_arV1Loop)
end

local function _arV1Stop()
    _arV1.active = false
    if _arV1.isBoosting and _arV1.cached and _arV1.cached.humanoid then
        _arV1.cached.humanoid.WalkSpeed = AR_DEFAULT_SPEED
    end
    _arV1.isBoosting = false
    _arV1Disconnect()
    _arV1.cached = nil
end

local function _arV2Start()
    if _arV2.conn then return end
    _arV2.enabled = true
    _arV2.conn = RunService.Heartbeat:Connect(function()
        if not _arV2.enabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
        local state = hum:GetState()
        local now = tick()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown then
            if now - _arV2.resetCooldown > 0.15 then
                _arV2.resetCooldown = now
                pcall(function()
                    if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
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
                    local PM = player:FindFirstChild("PlayerScripts") and player.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = require(PM:FindFirstChild("ControlModule"))
                        if CM then CM:Enable() end
                    end
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
        end
    end)
end

local function _arV2Stop()
    _arV2.enabled = false
    if _arV2.conn then
        _arV2.conn:Disconnect()
        _arV2.conn = nil
    end
    _arV2.resetCooldown = 0
end

-- Modes: "V1" | "V2" (CLEAN). Legacy "Splatter"/"No Splatter" map to V1/V2.
function M.setAntiRagdollMode(mode)
    mode = tostring(mode or "V1")
    if mode == "Splatter" then mode = "V1" end
    if mode == "No Splatter" then mode = "V2" end
    if mode ~= "V1" and mode ~= "V2" then mode = "V1" end
    _arV1Stop()
    _arV2Stop()
    M.antiRagdollMode = mode
    if M.antiRagdollEnabled then
        if mode == "V1" then _arV1Start() else _arV2Start() end
    end
end

function M.startAntiRagdoll()
    M.antiRagdollEnabled = true
    local mode = M.antiRagdollMode or "V1"
    if mode == "Splatter" then mode = "V1" end
    if mode == "No Splatter" then mode = "V2" end
    M.antiRagdollMode = mode
    _arV1Stop()
    _arV2Stop()
    if mode == "V1" then _arV1Start() else _arV2Start() end
end

function M.stopAntiRagdoll()
    M.antiRagdollEnabled = false
    _arV1Stop()
    _arV2Stop()
end

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
        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
        if isJumpHeld and root.AssemblyLinearVelocity.Y < 35 then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 55, root.AssemblyLinearVelocity.Z)
        end
        if root.AssemblyLinearVelocity.Y < -120 then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -120, root.AssemblyLinearVelocity.Z)
        end
    end)
end
function M.stopHoldInfJump()
    if M.holdInfJumpConn then
        M.holdInfJumpConn:Disconnect()
        M.holdInfJumpConn = nil
    end
end
function M.startUnwalk()
    if M.unwalkEnabled ~= true or M._unwalkOffLock == true or M.animPackEnabled ~= true then return end
    M._unwalkOffLock = false
    local c=player.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate")
    if anim then
        if not M.unwalkSavedAnimate then M.unwalkSavedAnimate=anim:Clone() end
        anim:Destroy()
    end
end
function M.stopUnwalk()
    M.unwalkEnabled = false
    M._unwalkOffLock = true
    local c = player.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
    end
    local currentAnimate = c:FindFirstChild("Animate")
    if currentAnimate then currentAnimate:Destroy() end
    local saved = M.unwalkSavedAnimate or M.savedAnimate
    if saved then
        local restoredAnimate = saved:Clone()
        restoredAnimate.Disabled = true
        restoredAnimate.Parent = c
        task.wait(0.06)
        if restoredAnimate.Parent then restoredAnimate.Disabled = false end
    end
    M.unwalkSavedAnimate = nil
    if c and not c:FindFirstChild("Animate") then M.restoreOriginalAnimate(c) end
end
function M.hasBrainrotInHand()
    local char = player.Character
    if not char then return false end
    local ok, val = pcall(function() return player:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and val2 == true then return true end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
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
    if not M.hasBrainrotInHand() then
        M._manualCarryOffLock = false
        return false
    end
    if M._manualCarryOffLock then return false end
    M.manualCarryActive = true
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = true
    return true
end
function M.toggleCarryMode()
    if M.manualCarryActive or M.carrySpeedActive or M.laggerCarryActive then
        M._manualSpeedModeLock = false
        M.manualCarryActive = false
        M._manualCarryOffLock = true
        M.carrySpeedActive = false
        M.laggerCarryActive = false
        M.laggerModeEnabled = false
        M.setModeNormalFlags()
        M.refreshWalkSpeedAutoSwitch()
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
        savePrimeHubFeKlanConfig()
        return
    end
    M._manualCarryOffLock = false
    M._manualSpeedModeLock = true
    M.carrySpeedActive = not M.carrySpeedActive
    M.manualCarryActive = M.carrySpeedActive == true
    if M.carrySpeedActive then
        M.laggerCarryActive = false
        M.laggerModeEnabled = false
        M.syncProfileToNSCS()
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    savePrimeHubFeKlanConfig()
end
function M.toggleLaggerMode()
    M._manualSpeedModeLock = not M.laggerModeEnabled
    M.laggerModeEnabled = not M.laggerModeEnabled
    if M.laggerModeEnabled then
        -- Lag Mode: usa M.LAGGER_SPEED (campo Lagger Normal Speed)
        M.laggerCarryActive = false
        M.carrySpeedActive = false
        M.manualCarryActive = false
        M._manualCarryOffLock = false
    else
        M.manualCarryActive = false
        -- al apagar, walk vuelve al NS del perfil elegido
        M.syncProfileToNSCS()
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.laggerModeBtn then
        M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    if M.laggerNormalStatusLabel then
        M.laggerNormalStatusLabel.Text = M.laggerModeEnabled and "ON" or "OFF"
        M.laggerNormalStatusLabel.TextColor3 = M.laggerModeEnabled and Color3.fromRGB(255, 135, 215) or Color3.fromRGB(255, 235, 248)
    end
    if M.laggerCarryStatusLabel then
        M.laggerCarryStatusLabel.Text = M.laggerCarryActive and "ON" or "OFF"
        M.laggerCarryStatusLabel.TextColor3 = M.laggerCarryActive and Color3.fromRGB(255, 135, 215) or Color3.fromRGB(255, 235, 248)
    end
    savePrimeHubFeKlanConfig()
end
function M.cycleLaggerModeBind()
    M._manualSpeedModeLock = true
    if not M.laggerCarryActive and not M.laggerModeEnabled then
        M.laggerCarryActive = true
        M.manualCarryActive = true
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
    elseif M.laggerCarryActive then
        M.laggerCarryActive = false
        M.manualCarryActive = false
        M.laggerModeEnabled = true
    else
        M.laggerModeEnabled = false
        M.laggerCarryActive = true
        M.manualCarryActive = true
        M.carrySpeedActive = false
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
    savePrimeHubFeKlanConfig()
end
function M.toggleLaggerCarry()
    M._manualSpeedModeLock = not M.laggerCarryActive
    M.laggerCarryActive = not M.laggerCarryActive
    if M.laggerCarryActive then
        -- Lag Carry: usa M.LAGGER_CARRY_SPEED (campo Lagger Carry Speed)
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
        M.manualCarryActive = false
    else
        M.manualCarryActive = false
        M.syncProfileToNSCS()
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.laggerCarryStatusLabel then
        M.laggerCarryStatusLabel.Text = M.laggerCarryActive and "ON" or "OFF"
        M.laggerCarryStatusLabel.TextColor3 = M.laggerCarryActive and Color3.fromRGB(255, 135, 215) or Color3.fromRGB(255, 235, 248)
    end
    if M.laggerNormalStatusLabel then
        M.laggerNormalStatusLabel.Text = M.laggerModeEnabled and "ON" or "OFF"
        M.laggerNormalStatusLabel.TextColor3 = M.laggerModeEnabled and Color3.fromRGB(255, 135, 215) or Color3.fromRGB(255, 235, 248)
    end
    savePrimeHubFeKlanConfig()
end
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
                if M._speedLVSet then
                    M._speedLVSet(hrp, mv.X * spd, mv.Z * spd)
                else
                    if M._speedLVSet then
                        M._speedLVSet(hrp, mv.X * spd, mv.Z * spd)
                    else
                        hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
                    end
                end
                return
            end
            local d = M.AP_L1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            if M._speedLVSet then
                M._speedLVSet(hrp, mv.X * spd, mv.Z * spd)
            else
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
            end
        elseif M.alPhase == 2 then
            local tgt = Vector3.new(M.AP_L2.X, hrp.Position.Y, M.AP_L2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                if M._speedLVClear then M._speedLVClear(hrp) end
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
            if M._speedLVSet then
                M._speedLVSet(hrp, mv.X * spd, mv.Z * spd)
            else
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
            end
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
                if M._speedLVSet then
                    M._speedLVSet(hrp, mv.X * spd, mv.Z * spd)
                else
                    if M._speedLVSet then
                        M._speedLVSet(hrp, mv.X * spd, mv.Z * spd)
                    else
                        hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
                    end
                end
                return
            end
            local d = M.AP_R1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            if M._speedLVSet then
                M._speedLVSet(hrp, mv.X * spd, mv.Z * spd)
            else
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
            end
        elseif M.arPhase == 2 then
            local tgt = Vector3.new(M.AP_R2.X, hrp.Position.Y, M.AP_R2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                if M._speedLVClear then M._speedLVClear(hrp) end
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
            if M._speedLVSet then
                M._speedLVSet(hrp, mv.X * spd, mv.Z * spd)
            else
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
            end
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
function M.mirrorTPAimbotActive()
    return M.autoBatEnabled == true or M.bypassAimbotEnabled == true
end
function M.mirrorTPTeleportDown()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end
    local now = tick()
    if now - (M.mirrorTPLastTeleport or 0) < 0.08 then return end
    M.mirrorTPLastTeleport = now
    local _, yaw = root.CFrame:ToEulerAnglesYXZ()
    local y = (M.MIRROR_TP_DOWN_Y or -7) + (math.random() * 0.6 - 0.3)
    root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
    root.AssemblyLinearVelocity = Vector3.new((math.random()-0.5)*0.4, 0, (math.random()-0.5)*0.4)
end
if not M._mirrorTPStarted then
    M._mirrorTPStarted = true
    RunService.Heartbeat:Connect(function()
        if not M.mirrorTPDownEnabled or not M.mirrorTPAimbotActive() then
            if next(M.mirrorTPPreviousY) then
                table.clear(M.mirrorTPPreviousY)
            end
            return
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local currentY = root.Position.Y
                    local previousY = M.mirrorTPPreviousY[plr.UserId]
                    if previousY and previousY - currentY >= (M.MIRROR_TP_DROP_THRESHOLD or 3) then
                        pcall(M.mirrorTPTeleportDown)
                        table.clear(M.mirrorTPPreviousY)
                        return
                    end
                    M.mirrorTPPreviousY[plr.UserId] = currentY
                end
            end
        end
    end)
end
function M.setMirrorTPDown(enabled)
    M.mirrorTPDownEnabled = enabled == true
    if not M.mirrorTPDownEnabled then
        table.clear(M.mirrorTPPreviousY)
    end
    if M.setMirrorTPVisual then M.setMirrorTPVisual(M.mirrorTPDownEnabled) end
end
function M.isStealState()
    return M.hasBrainrotInHand() == true
end
-- Perfil (Normal/Lagger/Custom): solo alimenta NS/CS para walk + Carry Speed
-- Lag Mode / Lag Carry: independientes (siempre LaggerSpeedNorm / LaggerSpeedSteal)
function M.getProfileNorm(profile)
    local p = profile or M.speedProfile or "Normal"
    if p == "Lagger" then
        return tonumber(M.LaggerSpeedNorm) or 30
    elseif p == "Custom" then
        return tonumber(M.CustomSpeedNorm) or 66
    end
    return tonumber(M.NormalSpeedNorm) or 59
end

function M.getProfileSteal(profile)
    local p = profile or M.speedProfile or "Normal"
    if p == "Lagger" then
        return tonumber(M.LaggerSpeedSteal) or 15
    elseif p == "Custom" then
        return tonumber(M.CustomSpeedSteal) or 34
    end
    return tonumber(M.NormalSpeedSteal) or 29
end

function M.syncProfileToNSCS()
    local p = M.speedProfile or "Normal"
    M.NS = M.getProfileNorm(p)
    M.CS = M.getProfileSteal(p)
end

function M.getActiveMoveSpeed()
    -- PRIORIDAD:
    -- LAG CARRY  -> SOLO M.LAGGER_CARRY_SPEED  (Controls: "Lagger Carry Speed")
    -- LAG MODE   -> SOLO M.LAGGER_SPEED        (Controls: "Lagger Normal Speed")
    -- Carry btn  -> CS del perfil elegido
    -- Walk       -> NS del perfil elegido
    -- Nunca mezclar con LaggerSpeedNorm / LaggerSpeedSteal del card de perfiles
    if M.laggerCarryActive == true then
        local v = tonumber(M.LAGGER_CARRY_SPEED)
        if v and v > 0 then return v end
        return 15
    end
    if M.laggerModeEnabled == true then
        local v = tonumber(M.LAGGER_SPEED)
        if v and v > 0 then return v end
        return 30
    end
    if M.carrySpeedActive == true or M.manualCarryActive == true then
        local v = tonumber(M.CS) or (M.getProfileSteal and M.getProfileSteal(M.speedProfile))
        if v and v > 0 then return v end
        return 29
    end
    if M.autoSwitchSpeedEnabled and M.isStealState and M.isStealState() then
        local v = tonumber(M.CS) or (M.getProfileSteal and M.getProfileSteal(M.speedProfile))
        if v and v > 0 then return v end
        return 29
    end
    local v = tonumber(M.NS) or (M.getProfileNorm and M.getProfileNorm(M.speedProfile))
    if v and v > 0 then return v end
    return 59
end

function M.getAutoPathSpeed()
    if M.laggerCarryActive == true then
        local v = tonumber(M.LAGGER_CARRY_SPEED)
        if v and v > 0 then return v end
        return 15
    end
    if M.laggerModeEnabled == true then
        local v = tonumber(M.LAGGER_SPEED)
        if v and v > 0 then return v end
        return 30
    end
    local v = tonumber(M.NS) or (M.getProfileNorm and M.getProfileNorm(M.speedProfile))
    if v and v > 0 then return v end
    return 59
end

function M.setModeNormalFlags()
    M.carrySpeedActive = false
    M.manualCarryActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    -- no forzar profile; solo apaga toggles y resincroniza NS/CS del perfil actual
    if not M.speedProfile then M.speedProfile = "Normal" end
    M.syncProfileToNSCS()
    if M.mobBtnRefs and M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
    if M.mobBtnRefs and M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs and M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
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
    local _autoCarryAcc = 0
    M._autoSwitchSpeedConn = RunService.Heartbeat:Connect(function(dt)
        if not M.autoSwitchSpeedEnabled and not M.autoTurnOffSpeedEnabled and not M.autoSwitchLaggerSpeedEnabled then
            M.stopWalkSpeedAutoSwitch()
            return
        end
        if M._manualSpeedModeLock then return end
        _autoCarryAcc = _autoCarryAcc + (dt or 0.016)
        if _autoCarryAcc < 0.06 then return end
        _autoCarryAcc = 0
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local ws = hum.WalkSpeed or 16
        local thr = tonumber(M.AUTO_SWITCH_THRESHOLD) or 25
        if M.autoSwitchSpeedEnabled and not M.manualCarryActive and not M._manualCarryOffLock then
            if M.isStealState() then
                if M.autoCarryMode == "Lagger" then
                    if not M.laggerCarryActive then M.setModeLaggerCarryFlags() end
                elseif M.autoCarryMode == "Carry" then
                    if not M.carrySpeedActive then M.setModeCarryFlags() end
                else
                    if M.carrySpeedActive or M.laggerCarryActive then M.setModeNormalFlags() end
                end
            else
                if M.carrySpeedActive or M.laggerCarryActive then M.setModeNormalFlags() end
            end
        end
        if not M.autoSwitchSpeedEnabled and M.autoSwitchLaggerSpeedEnabled and ws <= thr and not M.laggerCarryActive and not M.laggerModeEnabled then
            M.setModeLaggerCarryFlags()
        elseif not M.autoSwitchSpeedEnabled and M.autoSwitchLaggerSpeedEnabled and ws > thr and (M.laggerCarryActive or M.laggerModeEnabled) then
            M.setModeNormalFlags()
        end
    end)
end
function M.refreshWalkSpeedAutoSwitch()
    if M.autoSwitchSpeedEnabled or M.autoTurnOffSpeedEnabled or M.autoSwitchLaggerSpeedEnabled then
        M.startWalkSpeedAutoSwitch()
    else
        M.stopWalkSpeedAutoSwitch()
    end
end
function M.updateAutoSwitchSpeed()
    if M._manualSpeedModeLock then return end
    if not M.autoSwitchSpeedEnabled or M.manualCarryActive or M._manualCarryOffLock then return end
    local holding = M.isStealState()
    if holding then
        if M.autoCarryMode == "Lagger" then
            if not M.laggerCarryActive then M.setModeLaggerCarryFlags() end
        elseif M.autoCarryMode == "Carry" then
            if not M.carrySpeedActive then M.setModeCarryFlags() end
        else
            if M.carrySpeedActive or M.laggerCarryActive then M.setModeNormalFlags() end
        end
    elseif not M.manualCarryActive and (M.carrySpeedActive or M.laggerCarryActive) then
        M.setModeNormalFlags()
    end
    if M._autoSwitchWasSteal ~= holding and M._applySpeedNow then pcall(M._applySpeedNow) end
    M._autoSwitchWasSteal = holding
end
function M.isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end
function M.notify(text)
    task.spawn(function()
        local gui = M.mainGui or (player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("PrimeHubUI"))
        if not gui then return end
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 220, 0, 35)
        label.Position = UDim2.new(0.5, -110, 0.85, 0)
        label.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        label.BackgroundTransparency = 0.1
        label.TextColor3 = Color3.fromRGB(255, 235, 248)
        label.Text = text
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.Parent = gui
        label.ZIndex = 1000
        local corner = Instance.new("UICorner", label)
        corner.CornerRadius = UDim.new(0, 10)
        local stroke = Instance.new("UIStroke", label)
        stroke.Color = Color3.fromRGB(100, 100, 100)
        stroke.Thickness = 1.5
        task.wait(2.5)
        local t = game:GetService("TweenService"):Create(label, TweenInfo.new(0.6), {TextTransparency = 1, BackgroundTransparency = 1})
        t:Play()
        t.Completed:Connect(function() label:Destroy() end)
    end)
end
function M.dropBrainrotInHand()
    local char = player.Character
    local dropped = false
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then
                local name = item.Name:lower()
                if name:find("brainrot", 1, true) or name:find("skibidi", 1, true) or name:find("toilet", 1, true) then
                    item.Parent = workspace
                    dropped = true
                end
            end
        end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") then
                local name = item.Name:lower()
                if name:find("brainrot", 1, true) or name:find("skibidi", 1, true) or name:find("toilet", 1, true) then
                    item.Parent = workspace
                    dropped = true
                end
            end
        end
    end
    return dropped
end

function M.stopDrop()
    M.dropActive = false
    if M._dropConn then
        pcall(function() M._dropConn:Disconnect() end)
        M._dropConn = nil
    end
    if M._dropFlingThread then
        pcall(task.cancel, M._dropFlingThread)
        M._dropFlingThread = nil
    end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end

function M.runDrop()
    if M.dropBrainrotInHand() then return end
    if M.dropActive then return end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local mode = tostring(M.dropMode or "Fling")
    if mode == "Fling" then
        local velocity = root.AssemblyLinearVelocity
        local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
        local cooldown = horizontalSpeed > 5 and 0.6 or 0.25
        if tick() - (M._lastDropTime or 0) < cooldown then return end
        M._lastDropTime = tick()
        M.dropActive = true
        local flingThread
        local function finish()
            if M._dropFlingThread == flingThread then M._dropFlingThread = nil end
            M.dropActive = false
            local currentChar = player.Character
            local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
            local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
            if currentRoot then
                currentRoot.AssemblyLinearVelocity = Vector3.zero
                currentRoot.AssemblyAngularVelocity = Vector3.zero
                if currentRoot.Position.Y < -100 then
                    currentRoot.CFrame = CFrame.new(currentRoot.Position.X, 5, currentRoot.Position.Z)
                end
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {currentChar}
                params.FilterType = Enum.RaycastFilterType.Exclude
                local hit = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), params)
                if hit then
                    local offset = (currentHum and currentHum.HipHeight or 2) + currentRoot.Size.Y / 2
                    currentRoot.CFrame = CFrame.new(currentRoot.Position.X, hit.Position.Y + offset, currentRoot.Position.Z)
                end
                if currentHum and currentHum.Health > 0 then
                    currentHum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end
        flingThread = task.spawn(function()
            local started = tick()
            while M.dropActive and tick() - started < 0.25 do
                RunService.Heartbeat:Wait()
                local currentChar = player.Character
                local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                if not currentRoot then break end
                local currentVelocity = currentRoot.AssemblyLinearVelocity
                local flatVelocity = Vector3.new(0, currentVelocity.Y, 0)
                currentRoot.AssemblyLinearVelocity = flatVelocity * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if currentRoot.Parent then currentRoot.AssemblyLinearVelocity = flatVelocity end
                RunService.Stepped:Wait()
                if currentRoot.Parent then currentRoot.AssemblyLinearVelocity = flatVelocity + Vector3.new(0, 0.1, 0) end
            end
            finish()
        end)
        M._dropFlingThread = flingThread
        task.delay(0.35, function()
            if M.dropActive then finish() end
        end)
        return
    end

    -- Jump Drop: ascenso corto y regreso al suelo mediante raycast.
    M.dropActive = true
    local started = tick()
    if M._dropConn then pcall(function() M._dropConn:Disconnect() end) end
    M._dropConn = RunService.Heartbeat:Connect(function()
        local currentChar = player.Character
        local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        if not currentRoot or not M.dropActive then
            M.stopDrop()
            return
        end
        if tick() - started >= (M.DROP_ASCEND_DURATION or 0.22) then
            pcall(function()
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {currentChar}
                params.FilterType = Enum.RaycastFilterType.Exclude
                local hit = workspace:Raycast(currentRoot.Position, Vector3.new(0, -3000, 0), params)
                if hit then
                    local currentHum = currentChar:FindFirstChildOfClass("Humanoid")
                    local offset = (currentHum and currentHum.HipHeight or 2) + currentRoot.Size.Y / 2
                    currentRoot.CFrame = CFrame.new(currentRoot.Position.X, hit.Position.Y + offset, currentRoot.Position.Z)
                    currentRoot.AssemblyLinearVelocity = Vector3.zero
                    currentRoot.AssemblyAngularVelocity = Vector3.zero
                    if currentHum and currentHum.Health > 0 then currentHum:ChangeState(Enum.HumanoidStateType.Running) end
                end
            end)
            M.stopDrop()
            return
        end
        local currentVelocity = currentRoot.AssemblyLinearVelocity
        currentRoot.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, M.DROP_ASCEND_SPEED or 160, currentVelocity.Z)
    end)
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
end
function M.loadBtnPositions()
    local positions = {}
    for k, pos in pairs(M._savedButtonPositions or {}) do
        if type(pos) == "table" and type(pos.x) == "number" and type(pos.y) == "number" then
            positions[k] = {x = pos.x, y = pos.y}
        end
    end
    pcall(function()
        if type(isfile) == "function" and type(readfile) == "function" and M.MOB_POS_FILE and isfile(M.MOB_POS_FILE) then
            local decoded = HS:JSONDecode(readfile(M.MOB_POS_FILE))
            if type(decoded) == "table" then
                for key, pos in pairs(decoded) do
                    if type(pos) == "table" and type(pos.x) == "number" and type(pos.y) == "number" then
                        positions[key] = {x = pos.x, y = pos.y}
                    end
                end
            end
        end
    end)
    -- from main config mobileButtonPositions
    pcall(function()
        if type(M._cfgBtnPos) == "table" then
            for key, pos in pairs(M._cfgBtnPos) do
                if type(pos) == "table" and type(pos.x) == "number" then
                    positions[key] = {x = pos.x, y = pos.y}
                end
            end
        end
    end)
    M._savedButtonPositions = positions
    return positions
end

function M.saveBtnPositions()
    local out = {}
    -- merge previous
    for k, pos in pairs(M._savedButtonPositions or {}) do
        if type(pos) == "table" and type(pos.x) == "number" and type(pos.y) == "number" then
            out[k] = {x = pos.x, y = pos.y}
        end
    end
    -- live holders
    if M.mobGuiRef then
        for _, child in ipairs(M.mobGuiRef:GetChildren()) do
            local key = child:GetAttribute("BtnKey")
            if (not key) and type(child.Name) == "string" and child.Name:sub(1, 10) == "BtnHolder_" then
                key = child.Name:sub(11)
            elseif (not key) and type(child.Name) == "string" and child.Name:sub(1, 4) == "Btn_" then
                key = child.Name:sub(5)
            end
            if key then
                out[key] = {x = child.Position.X.Offset, y = child.Position.Y.Offset}
            end
        end
    end
    M._savedButtonPositions = out
    pcall(function()
        if type(writefile) == "function" and HS then
            writefile(M.MOB_POS_FILE or "primehub_fe_klan_btnpos.json", HS:JSONEncode(out))
        end
    end)
    if M.saveConfig then pcall(M.saveConfig) end
    return out
end
function M.resetMobilePositions()
    -- limpia posiciones guardadas (memoria + disco)
    M._savedButtonPositions = {}
    pcall(function()
        if type(delfile) == "function" then
            pcall(function() delfile(M.MOB_POS_FILE) end)
        end
        if type(writefile) == "function" then
            writefile(M.MOB_POS_FILE, "{}")
            writefile("primehub_fe_klan_btnpos.json", "{}")
        end
    end)
    -- reconstruye botones en posiciones por defecto
    local wasEnabled = M.mobileButtonsEnabled ~= false
    M.mobileButtonsEnabled = true
    M._forceDefaultMobPos = true
    pcall(function()
        if M.destroyMobileButtons then M.destroyMobileButtons() end
    end)
    pcall(function()
        M.buildMobileButtons()
    end)
    M._forceDefaultMobPos = false
    -- guardar defaults actuales como nuevas posiciones base
    pcall(function()
        local out = {}
        if M.mobGuiRef then
            for _, child in ipairs(M.mobGuiRef:GetChildren()) do
                local key = child:GetAttribute("BtnKey")
                if (not key) and type(child.Name) == "string" and child.Name:sub(1, 10) == "BtnHolder_" then
                    key = child.Name:sub(11)
                end
                if key then
                    out[key] = {x = child.Position.X.Offset, y = child.Position.Y.Offset}
                end
            end
        end
        M._savedButtonPositions = out
        if type(writefile) == "function" and HS then
            writefile(M.MOB_POS_FILE, HS:JSONEncode(out))
        end
    end)
    if M.saveConfig then pcall(M.saveConfig) end
    if M.notify then
        pcall(function() M.notify("Mobile buttons: position reset") end)
    end
    M.mobileButtonsEnabled = wasEnabled
end

function M.buildMobileButtons()
    local activeTheme = (M.colorScheme == "Blue") and "Blue" or "Pink"
    M.colorScheme = activeTheme
    -- cargar posiciones guardadas antes de destruir (si no forzamos default)
    if not M._forceDefaultMobPos then
        pcall(function()
            if M.saveBtnPositions and M.mobGuiRef then M.saveBtnPositions() end
        end)
        pcall(function()
            if M.loadBtnPositions then M.loadBtnPositions() end
        end)
    end
    M.destroyMobileButtons()
    if not M.mobileButtonsEnabled then return end
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
    local gui = Instance.new("ScreenGui")
    gui.Name = "MoveeMobileButtons"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 15
    M.mobileButtonsGui = gui
    M.mobGuiRef = gui
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then gui.Parent = player:WaitForChild("PlayerGui") end
    gui.Enabled = not (M.hideMobileButtons == true)

    local function getMobAccent()
        local a = M.currentAccent
        if typeof(a) == "Color3" then return a end
        local n = M.adaptThemeName
        if M.ADAPT_THEME_COLORS and n and M.ADAPT_THEME_COLORS[n] then
            return M.ADAPT_THEME_COLORS[n]
        end
        return Color3.fromRGB(58, 128, 245)
    end
    local function lighten(c, f)
        f = f or 1.3
        return Color3.new(math.min(1, c.R * f), math.min(1, c.G * f), math.min(1, c.B * f))
    end
    local function darken(c, f)
        f = f or 0.25
        return Color3.new(c.R * f, c.G * f, c.B * f)
    end
    local pink = getMobAccent()
    local pinkLight = lighten(pink, 1.35)
    local black = darken(pink, 0.15)
    local white = Color3.fromRGB(255, 255, 255)
    local size = math.max(58, math.floor((M.mobileButtonsSize or 100) * (M.uiScale or 0.8) * 0.62))
    local gap, cols, pad = 8, 2, 8
    local startX = vp.X - (cols * size + gap) - pad
    local defs = {
        {"autoLeft", "AUTO\nLEFT", true}, {"autoRight", "AUTO\nRIGHT", true},
        {"batAimbot", "BAT\nAIMBOT", true}, {"tpBat", "TP\nBAT", true},
        {"batV2", "BAT\nV2", true},
        {"carrySpeed", "CARRY\nSPEED", true},
        {"drop", "DROP\nBR", false}, {"tpDown", "TP\nDOWN", false},
        {"lagger", "LAG\nMODE", true}, {"laggerCarry", "LAG\nCARRY", true},
        {"instaReset", "INSTA\nRESET", false},
    }
    M.mobBtnRefs = {}
    local function makeMobileButtonMovable(holder, clickBtn)
        -- mueve el HOLDER; el TextButton solo captura el input
        local dragging = false
        local dragInput = nil
        local dragStart = nil
        local startPos = nil

        local function savePos()
            local key = holder:GetAttribute("BtnKey")
                or (clickBtn and clickBtn:GetAttribute("BtnKey"))
            if not key then return end
            M._savedButtonPositions = M._savedButtonPositions or {}
            M._savedButtonPositions[key] = {
                x = holder.Position.X.Offset,
                y = holder.Position.Y.Offset,
            }
            pcall(function()
                if type(writefile) == "function" and HS then
                    writefile(M.MOB_POS_FILE or "primehub_fe_klan_btnpos.json", HS:JSONEncode(M._savedButtonPositions))
                end
            end)
            if M.saveBtnPositions then pcall(M.saveBtnPositions) end
        end

        local function beginDrag(input)
            if M.uiLocked then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = holder.Position
        end

        local function endDrag(input)
            if not dragging then return end
            if input and dragInput and input ~= dragInput then return end
            dragging = false
            dragInput = nil
            savePos()
        end

        -- Input en el boton (captura real del touch/click)
        if clickBtn then
            clickBtn.InputBegan:Connect(function(input)
                beginDrag(input)
            end)
        end
        holder.InputBegan:Connect(function(input)
            beginDrag(input)
        end)

        -- movimiento global (mouse + touch)
        UIS.InputChanged:Connect(function(input)
            if not dragging or M.uiLocked then return end
            if dragInput and input ~= dragInput then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            if not dragStart or not startPos then return end
            local delta = input.Position - dragStart
            holder.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end)

        UIS.InputEnded:Connect(function(input)
            endDrag(input)
        end)
    end

    for i, def in ipairs(defs) do
        local key, label, isToggle = def[1], def[2], def[3]
        local row, col = math.floor((i - 1) / cols), (i - 1) % cols
        local defX = startX + col * (size + gap)
        local defY = 50 + row * (size + gap)
        local savedPos = (not M._forceDefaultMobPos) and M._savedButtonPositions and M._savedButtonPositions[key]
        local posX = (type(savedPos) == "table" and type(savedPos.x) == "number") and savedPos.x or defX
        local posY = (type(savedPos) == "table" and type(savedPos.y) == "number") and savedPos.y or defY

        -- Holder: el gradient NO puede ir en el TextButton (tiñe el texto)
        local holder = Instance.new("Frame")
        holder.Name = "BtnHolder_" .. key
        holder.Size = UDim2.fromOffset(size, size)
        holder.Position = UDim2.fromOffset(posX, posY)
        holder.BackgroundTransparency = 1
        holder.BorderSizePixel = 0
        holder.ZIndex = 100
        holder:SetAttribute("BtnKey", key)
        holder:SetAttribute("DefaultX", defX)
        holder:SetAttribute("DefaultY", defY)
        holder.Active = true
        holder.Parent = gui

        local bg = Instance.new("Frame")
        bg.Name = "Bg"
        bg.Size = UDim2.fromScale(1, 1)
        bg.BackgroundColor3 = pink
        bg.BackgroundTransparency = 0
        bg.BorderSizePixel = 0
        bg.ZIndex = 100
        bg.Parent = holder
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 14)
        corner.Parent = bg
        local gradient = Instance.new("UIGradient")
        gradient.Name = "ButtonBlackBottomFade"
        gradient.Rotation = 90
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, pinkLight),
            ColorSequenceKeypoint.new(0.5, pink),
            ColorSequenceKeypoint.new(1, black),
        })
        gradient.Parent = bg
        local stroke = Instance.new("UIStroke")
        stroke.Name = "BtnStroke"
        stroke.Color = Color3.fromRGB(160, 164, 175)
        stroke.Thickness = 2
        stroke.Transparency = 0.25
        stroke.Parent = bg
        M._mobBtnStrokes = M._mobBtnStrokes or {}
        table.insert(M._mobBtnStrokes, stroke)
        -- mark so global menu plomo anim does NOT fight press flash
        stroke:SetAttribute("MobBtn", true)
        stroke:SetAttribute("BtnActive", false)

        local btn = Instance.new("TextButton")
        btn.Name = "Btn_" .. key
        btn.Size = UDim2.fromScale(1, 1)
        btn.Position = UDim2.fromScale(0, 0)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Text = label
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextTransparency = 0
        btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        btn.TextStrokeTransparency = 0.15
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 13
        btn.TextWrapped = true
        btn.ZIndex = 102
        btn:SetAttribute("BtnKey", key)
        btn.Parent = holder

        local pumpkin = Instance.new("TextLabel")
        pumpkin.Name = "PumpkinButtonDecoration"
        pumpkin.Size = UDim2.new(0, math.max(18, math.floor(size * 0.28)), 0, math.max(18, math.floor(size * 0.28)))
        pumpkin.Position = UDim2.new(1, -math.max(22, math.floor(size * 0.30)), 0, 2)
        pumpkin.BackgroundTransparency = 1
        pumpkin.Text = "🎃"
        pumpkin.TextColor3 = Color3.fromRGB(255, 154, 32)
        pumpkin.TextStrokeColor3 = Color3.fromRGB(65, 8, 82)
        pumpkin.TextStrokeTransparency = 0.05
        pumpkin.TextScaled = true
        pumpkin.Font = Enum.Font.GothamBlack
        pumpkin.ZIndex = 103
        pumpkin.Parent = holder

        makeMobileButtonMovable(holder, btn)

        local on = false
        local function paint(active)
            on = active == true
            local accent = getMobAccent()
            local accentL = lighten(accent, 1.35)
            local accentD = darken(accent, 0.18)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextTransparency = 0
            btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            btn.TextStrokeTransparency = 0.15
            bg.BackgroundColor3 = accent
            bg.BackgroundTransparency = 0
            stroke:SetAttribute("BtnActive", on)
            if on then
                -- Active: bright plomo/white edge, very visible
                stroke.Color = Color3.fromRGB(230, 232, 240)
                stroke.Thickness = 3.4
                stroke.Transparency = 0
                gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, accentL),
                    ColorSequenceKeypoint.new(0.45, accent),
                    ColorSequenceKeypoint.new(1, accent),
                })
            else
                stroke.Color = Color3.fromRGB(140, 144, 155)
                stroke.Thickness = 1.6
                stroke.Transparency = 0.35
                gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, accentL),
                    ColorSequenceKeypoint.new(0.55, accent),
                    ColorSequenceKeypoint.new(1, accentD),
                })
            end
            btn:SetAttribute("Active", on)
        end

        M.mobBtnRefs[key] = paint
        -- Strong plomo flash when pressed (very noticeable)
        local function plomoPressFlash()
            if not stroke or not stroke.Parent then return end
            stroke:SetAttribute("PressFlash", true)
            pcall(function()
                stroke.Color = Color3.fromRGB(255, 255, 255)
                stroke.Thickness = 4.5
                stroke.Transparency = 0
            end)
            -- quick white -> bright plomo pulse
            task.spawn(function()
                for i = 1, 8 do
                    if not stroke or not stroke.Parent then break end
                    local a = i / 8
                    stroke.Color = Color3.fromRGB(255, 255, 255):Lerp(Color3.fromRGB(170, 175, 190), a)
                    stroke.Thickness = 4.5 - a * 1.2
                    task.wait(0.06)
                end
                stroke:SetAttribute("PressFlash", false)
                -- restore via paint state
                if stroke:GetAttribute("BtnActive") then
                    stroke.Color = Color3.fromRGB(230, 232, 240)
                    stroke.Thickness = 3.4
                    stroke.Transparency = 0
                else
                    stroke.Color = Color3.fromRGB(140, 144, 155)
                    stroke.Thickness = 1.6
                    stroke.Transparency = 0.35
                end
            end)
        end
        btn.MouseButton1Down:Connect(plomoPressFlash)
        btn.TouchTap:Connect(function() end) -- keep touch path; flash also on click

        paint(false)
        btn.Activated:Connect(function()
            if isToggle then
                if key == "autoLeft" then
                    if M.autoRightEnabled then M.autoRightEnabled = false; M.stopAutoRight() end
                    M.autoLeftEnabled = not M.autoLeftEnabled
                    if M.autoLeftEnabled then M.startAutoLeft() else M.stopAutoLeft() end
                    paint(M.autoLeftEnabled)
                elseif key == "autoRight" then
                    if M.autoLeftEnabled then M.autoLeftEnabled = false; M.stopAutoLeft() end
                    M.autoRightEnabled = not M.autoRightEnabled
                    if M.autoRightEnabled then M.startAutoRight() else M.stopAutoRight() end
                    paint(M.autoRightEnabled)
                elseif key == "batAimbot" then
                    M.batAimbotEnabled = not M.batAimbotEnabled
                    if M.batAimbotEnabled then M.startBatAimbot() else M.stopBatAimbot() end
                    paint(M.batAimbotEnabled)
                elseif key == "tpBat" then
                    M.toggleBypassAimbot()
                    paint(M.bypassAimbotEnabled)
                elseif key == "batV2" then
                    M.toggleBatV2()
                    paint(M.batV2Enabled == true)
                elseif key == "carrySpeed" then
                    M.toggleCarryMode(); paint(M.carrySpeedActive)
                elseif key == "lagger" then
                    M.toggleLaggerMode(); paint(M.laggerModeEnabled)
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
                elseif key == "laggerCarry" then
                    M.toggleLaggerCarry(); paint(M.laggerCarryActive)
                end
            elseif key == "drop" then
                M.runDrop(); paint(false)
            elseif key == "tpDown" then
                M.runTPFloor(); paint(false)
            elseif key == "instaReset" then
                M.doInstaReset(); paint(false)
            end
            if M.saveConfig then pcall(M.saveConfig) end
        end)
    end
end
local PRIMEHUB_FE_KLAN_CONFIG_NAME = "primehub_fe_klan_config.json"
local PrimeHubFeKlanConfig = { Theme="Purple" }
local CHERRY_THEMES = {
    Purple   = { Accent=Color3.fromRGB(207,159,255), AccentDim=Color3.fromRGB(160,120,210), Bg=Color3.fromRGB(8,4,14), Row=Color3.fromRGB(16,10,24) },
    Blue     = { Accent=Color3.fromRGB(58,128,245), AccentDim=Color3.fromRGB(40,90,180), Bg=Color3.fromRGB(4,8,16), Row=Color3.fromRGB(10,16,28) },
}
if M._savedTheme and CHERRY_THEMES[M._savedTheme] then
    PrimeHubFeKlanConfig.Theme = M._savedTheme
end
M.colorScheme = "Purple"
    PrimeHubFeKlanConfig.Theme = "Purple"
M.toggleLayoutPos = M.toggleLayoutPos or "Low" -- Low | High
M.customBgId = "131828154911144"
M.customBgOpacity = 0
M.mobBtnBgId = 0

-- Decal IDs need rbxthumb for reliable ImageLabel/ImageButton load
function M.bgImageUri(id)
    local n = tonumber(id) or 0
    if n <= 0 then return "" end
    return "rbxassetid://" .. tostring(n)
end
function M.bgImageUriThumb(id)
    local n = tonumber(id) or 0
    if n <= 0 then return "" end
    -- varios tamaños: algunos assets solo cargan en thumb
    return string.format("rbxthumb://type=Asset&id=%d&w=768&h=432", n)
end
function M.bgImageUriThumbAlt(id)
    local n = tonumber(id) or 0
    if n <= 0 then return "" end
    return string.format("rbxthumb://type=Asset&id=%d&w=420&h=420", n)
end
M.MENU_BG_IDS = {
    "101866560269754", -- fondo azul restaurado del panel Keybinds
    "107416548769490", -- fondo morado
    "104853451207790", -- fondo rosa
    "128737402834585", -- fondo verde
}
M.BG_IMAGE_IDS = M.MENU_BG_IDS
M.menuBgIndex = tonumber(M.menuBgIndex) or 1
M.MOB_BTN_IMAGE_IDS = {
    131828154911144,
    85741797518102,
    83079735691327,
    132200926526645,
    87158109204937,
}
local function loadPrimeHubFeKlanConfig()
    M.editMobileButtons = false
    -- defaults suaves (no forzar OFF de utility al cargar)
    if M.antiLagEnabled == nil then M.antiLagEnabled = false end
    if M.antiLagV2Enabled == nil then M.antiLagV2Enabled = false end
    if M.graphicsBajosEnabled == nil then M.graphicsBajosEnabled = false end
    if M.antiDieEnabled == nil then M.antiDieEnabled = false end
    if M.nukeOptimiserEnabled == nil then M.nukeOptimiserEnabled = false end
    if M.antiVoidEnabled == nil then M.antiVoidEnabled = false end
    if M.bodyLockEnabled == nil then M.bodyLockEnabled = false end
    if M.pcKeyStatusEnabled == nil then M.pcKeyStatusEnabled = false end
    if type(readfile)~="function" or type(isfile)~="function" then return end
    local ok,d = pcall(function()
        if not isfile(PRIMEHUB_FE_KLAN_CONFIG_NAME) then return nil end
        return HS:JSONDecode(readfile(PRIMEHUB_FE_KLAN_CONFIG_NAME))
    end)
    if ok and type(d)=="table" then
        local themeName = nil
        if type(d.Theme)=="string" and CHERRY_THEMES[d.Theme] then themeName = d.Theme end
        if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then themeName = d.colorScheme end
        if themeName then
            PrimeHubFeKlanConfig.Theme = themeName
            M.colorScheme = themeName
            M._savedTheme = themeName
        end
        if type(d.normalSpeed)=="number" then M.NS=d.normalSpeed end
        if type(d.carrySpeed)=="number" then M.CS=d.carrySpeed end
        if type(d.laggerSpeed)=="number" then M.LAGGER_SPEED=d.laggerSpeed end
        if type(d.laggerCarrySpeed)=="number" then M.LAGGER_CARRY_SPEED=d.laggerCarrySpeed end
        if type(d.speedMethod)=="string" then
            for _,sm in ipairs(M.speedMethodList) do if sm==d.speedMethod then M.speedMethod=sm; break end end
        end
        
        if type(d.autoTPHeight)=="number" then M.autoTPHeight=d.autoTPHeight end
        if type(d.fovValue)=="number" then M.fovValue=d.fovValue end
        if d.fovEnabled~=nil then M.fovEnabled=d.fovEnabled==true end
        if d.pcKeyStatusEnabled~=nil then M.pcKeyStatusEnabled=d.pcKeyStatusEnabled==true end
        if type(d.pcKeyPanelScale)=="number" then M.pcKeyPanelScale=math.clamp(d.pcKeyPanelScale, 0.65, 1.5) end
        if type(d.pcKeyPanelPosition)=="table" and type(d.pcKeyPanelPosition.x)=="number" and type(d.pcKeyPanelPosition.y)=="number" then M.pcKeyPanelPosition=d.pcKeyPanelPosition end
        if type(d.uiScale)=="number" then M.uiScale=d.uiScale end
        M.infJumpMode = "hold"
        if type(d.mobileButtonsSize)=="number" then M.mobileButtonsSize=d.mobileButtonsSize end
        if type(d.skyTheme)=="string" then M.currentSkyTheme=d.skyTheme end
        if d.skyThemesEnabled~=nil then M.skyThemesEnabled=d.skyThemesEnabled==true end
        if d.carrySpeedActive~=nil then M.carrySpeedActive=d.carrySpeedActive==true end
        if d.manualCarryActive~=nil then M.manualCarryActive=d.manualCarryActive==true end
        if d.laggerCarryActive~=nil then M.laggerCarryActive=d.laggerCarryActive==true end
        if d.laggerModeEnabled~=nil then M.laggerModeEnabled=d.laggerModeEnabled==true end
        if type(d.autoCarryMode)=="string" and (d.autoCarryMode=="Lagger" or d.autoCarryMode=="Carry" or d.autoCarryMode=="Normal") then M.autoCarryMode=d.autoCarryMode end
        if d.autoSwing~=nil then M.autoSwingEnabled=d.autoSwing==true end
        if d.introSoundEnabled~=nil then M.introSoundEnabled=d.introSoundEnabled==true end
        if d.introSongChoice then M.introSongChoice=d.introSongChoice end
        if d.introGUIEnabled~=nil then M.introGUIEnabled=d.introGUIEnabled==true end
        if d.ragdollGui~=nil then M.ragdollGuiEnabled=d.ragdollGui==true end
        if d.perButtonDrag~=nil then M.perButtonDragEnabled=d.perButtonDrag==true end
        if d.mobileButtonsEnabled~=nil then M.mobileButtonsEnabled=d.mobileButtonsEnabled==true end
        if d.autoMoveSwing~=nil then M.autoMoveSwingEnabled=d.autoMoveSwing==true end
        if d.autoSwitchSpeed~=nil then M.autoSwitchSpeedEnabled=d.autoSwitchSpeed==true end
        if d.autoTurnOffSpeed~=nil then M.autoTurnOffSpeedEnabled=d.autoTurnOffSpeed==true end
        if d.autoSwitchLaggerSpeed~=nil then M.autoSwitchLaggerSpeedEnabled=d.autoSwitchLaggerSpeed==true end
        if d.autoLeftEnabled~=nil then M.autoLeftEnabled=d.autoLeftEnabled==true end
        if d.autoRightEnabled~=nil then M.autoRightEnabled=d.autoRightEnabled==true end
        if d.mobileButtonsLocked~=nil then M.mobileButtonsLocked=d.mobileButtonsLocked==true end
        if type(d.cameraSensitivity)=="number" then M.cameraSensitivity=math.clamp(d.cameraSensitivity, 0.35, 1.0) end
        if type(d.customFont)=="string" then M.customFontSelected=d.customFont end
        if d.showPlayerSpeeds~=nil then M.showPlayerSpeeds=d.showPlayerSpeeds==true end
        if d.removeAcc~=nil then M.removeAccEnabled=d.removeAcc end
        if d.playerESPEnabled~=nil then M.playerESPEnabled=d.playerESPEnabled end
        if d.antiRagdoll~=nil then M.antiRagdollEnabled=d.antiRagdoll end
        if type(d.antiRagdollMode)=="string" then local m=d.antiRagdollMode; if m=="Splatter" then m="V1" elseif m=="No Splatter" then m="V2" end; if m=="V1" or m=="V2" then M.antiRagdollMode=m end end
        
        if d.autoRadiusEnabled~=nil then M.autoRadiusEnabled=d.autoRadiusEnabled==true end
        if type(d.speedProfile)=="string" then M.speedProfile = d.speedProfile end
        if type(d.normalSpeedNorm)=="number" then M.NormalSpeedNorm = d.normalSpeedNorm end
        if type(d.normalSpeedSteal)=="number" then M.NormalSpeedSteal = d.normalSpeedSteal end
        if type(d.laggerSpeedNorm)=="number" then M.LaggerSpeedNorm = d.laggerSpeedNorm end
        if type(d.laggerSpeedSteal)=="number" then M.LaggerSpeedSteal = d.laggerSpeedSteal end
        if type(d.customSpeedNorm)=="number" then M.CustomSpeedNorm = d.customSpeedNorm end
        if type(d.customSpeedSteal)=="number" then M.CustomSpeedSteal = d.customSpeedSteal end
        -- Finalize: reafirmar velocidades guardadas (prioridad absoluta)
        if type(d.laggerSpeed) == "number" then M.LAGGER_SPEED = d.laggerSpeed end
        if type(d.laggerCarrySpeed) == "number" then M.LAGGER_CARRY_SPEED = d.laggerCarrySpeed end
        if type(d.normalSpeedNorm) == "number" then M.NormalSpeedNorm = d.normalSpeedNorm end
        if type(d.normalSpeedSteal) == "number" then M.NormalSpeedSteal = d.normalSpeedSteal end
        if type(d.laggerSpeedNorm) == "number" then M.LaggerSpeedNorm = d.laggerSpeedNorm end
        if type(d.laggerSpeedSteal) == "number" then M.LaggerSpeedSteal = d.laggerSpeedSteal end
        if type(d.customSpeedNorm) == "number" then M.CustomSpeedNorm = d.customSpeedNorm end
        if type(d.customSpeedSteal) == "number" then M.CustomSpeedSteal = d.customSpeedSteal end
        if type(d.speedProfile) == "string" then M.speedProfile = d.speedProfile end
        if M.syncProfileToNSCS then
            pcall(M.syncProfileToNSCS)
        else
            local p = M.speedProfile or "Normal"
            if p == "Custom" then
                M.NS = tonumber(M.CustomSpeedNorm) or M.NS
                M.CS = tonumber(M.CustomSpeedSteal) or M.CS
            elseif p == "Lagger" then
                M.NS = tonumber(M.LaggerSpeedNorm) or M.NS
                M.CS = tonumber(M.LaggerSpeedSteal) or M.CS
            else
                M.NS = tonumber(M.NormalSpeedNorm) or M.NS
                M.CS = tonumber(M.NormalSpeedSteal) or M.CS
            end
        end
        -- Lag independiente siempre desde campos dedicados
        if type(d.laggerSpeed) == "number" then M.LAGGER_SPEED = d.laggerSpeed end
        if type(d.laggerCarrySpeed) == "number" then M.LAGGER_CARRY_SPEED = d.laggerCarrySpeed end

        if type(d.mobileButtonPositions)=="table" then
            local validPositions = {}
            for key, pos in pairs(d.mobileButtonPositions) do
                if type(key) == "string" and type(pos) == "table" and type(pos.x) == "number" and type(pos.y) == "number" then
                    validPositions[key] = {x = pos.x, y = pos.y}
                end
            end
            M._savedButtonPositions = validPositions
        end
        if d.infiniteJump~=nil then M.infJumpEnabled=d.infiniteJump end
        if d.medusaCounter~=nil then M.medusaCounterEnabled=d.medusaCounter end
        if d.batCounter~=nil then M.batCounterEnabled=d.batCounter end
        M.unwalkEnabled = false
        M._unwalkOffLock = true
        if d.antiLag~=nil then M.antiLagEnabled=d.antiLag end
        if d.nukeOptimiserEnabled~=nil then M.nukeOptimiserEnabled=d.nukeOptimiserEnabled end
        if d.adaptThemeName then M.adaptThemeName = tostring(d.adaptThemeName) end
        if type(d.menuBgIndex) == "number" then M.menuBgIndex = d.menuBgIndex end
        if type(d.toggleLayoutPos) == "string" and (d.toggleLayoutPos == "Low" or d.toggleLayoutPos == "High") then M.toggleLayoutPos = d.toggleLayoutPos end
        if d.playerBgSaved ~= nil then M._playerBgSaved = d.playerBgSaved == true end
        if d.adaptThemeName then M.adaptThemeName = tostring(d.adaptThemeName):upper() end
        if M.adaptThemeName and M.ADAPT_THEME_COLORS and M.ADAPT_THEME_COLORS[M.adaptThemeName] then
            M.currentAccent = M.ADAPT_THEME_COLORS[M.adaptThemeName]
        end
        if d.customBgId then M.customBgId = tostring(d.customBgId) end
        if d.antiVoidEnabled~=nil then M.antiVoidEnabled=d.antiVoidEnabled end
        if d.bodyLockEnabled~=nil then M.bodyLockEnabled=d.bodyLockEnabled end
        if d.bodyLockRadius~=nil then M.bodyLockRadius=tonumber(d.bodyLockRadius) or 60 end
        if d.antiLagV2~=nil then M.antiLagV2Enabled=d.antiLagV2==true end
        if d.graphicsBajosEnabled~=nil then M.graphicsBajosEnabled=d.graphicsBajosEnabled==true end
        if d.antiDieEnabled~=nil then M.antiDieEnabled=d.antiDieEnabled==true end
        if type(d.currentAccessoryPack)=="string" then M.currentAccessoryPack=d.currentAccessoryPack end
        if d.antiSummerBase~=nil then M.antiSummerBaseEnabled=d.antiSummerBase end
        if d.uiLocked~=nil then M.uiLocked=d.uiLocked==true end
        if d.uiTransparencyEnabled~=nil then M.uiTransparencyEnabled=d.uiTransparencyEnabled end
        if d.mobButtonsTransparencyEnabled~=nil then M.mobButtonsTransparencyEnabled=d.mobButtonsTransparencyEnabled end
        if d.stretchRez~=nil then M.stretchRezEnabled=d.stretchRez end
        if d.antiKick~=nil then M.antiKickEnabled=d.antiKick end
        if d.safeMode~=nil then M.safeModeEnabled=d.safeMode end
        if d.mirrorTPDown~=nil then M.mirrorTPDownEnabled=d.mirrorTPDown end
        if type(d.customBgId)=="number" then M.customBgId=d.customBgId end
        if type(d.customBgOpacity)=="number" then M.customBgOpacity=math.clamp(d.customBgOpacity,0,1) end
        if d.skinLegHidden~=nil then M.skinLegHidden=d.skinLegHidden==true end
        if d.hideMobileButtons~=nil then M.hideMobileButtons=d.hideMobileButtons==true end
        if type(d.mobBtnBgId)=="number" then M.mobBtnBgId=d.mobBtnBgId end
        if d.autoBat~=nil then M.autoBatEnabled=d.autoBat==true end
        if d.batAimbotEnabled~=nil then M.batAimbotEnabled=d.batAimbotEnabled==true; if d.batAimbotEnabled then M.autoBatEnabled=true end end
        if d.batCounter~=nil then M.batCounterEnabled=d.batCounter==true end
        if d.batCounterV2~=nil then M.batCounterV2Enabled=d.batCounterV2==true end
        if d.bypassAimbotEnabled~=nil then M.bypassAimbotEnabled=d.bypassAimbotEnabled==true end
        if d.zenonetopAimOn~=nil then M._zenonetopAimOn=d.zenonetopAimOn==true end
        if d.autoDestroyTurretEnabled~=nil then M.autoDestroyTurretEnabled=d.autoDestroyTurretEnabled==true end
        if d.antiRagdoll~=nil then M.antiRagdollEnabled=d.antiRagdoll==true end
        if d.medusaCounter~=nil then M.medusaCounterEnabled=d.medusaCounter==true end
        if d.autoSwing~=nil then M.autoSwingEnabled=d.autoSwing==true end
        if d.autoSwingEnabled~=nil then M.autoSwingEnabled=d.autoSwingEnabled==true end
        if d.antiVoidEnabled~=nil then M.antiVoidEnabled=d.antiVoidEnabled==true end
        if d.bodyLockEnabled~=nil then M.bodyLockEnabled=d.bodyLockEnabled==true end
        if type(d.bodyLockRadius)=="number" then M.bodyLockRadius=d.bodyLockRadius end
        if d.autoGrabV1Enabled~=nil then M.autoGrabV1Enabled=d.autoGrabV1Enabled==true end
        if type(d.antiRagdollMode)=="string" then local m=d.antiRagdollMode; if m=="Splatter" then m="V1" elseif m=="No Splatter" then m="V2" end; if m=="V1" or m=="V2" then M.antiRagdollMode=m end end
        if d.stealBarWidth~=nil then M.stealBarWidth=math.clamp(tonumber(d.stealBarWidth) or 360, 260, 560) end
        if d.autoGrabV1Enabled~=nil then M.autoGrabV1Enabled=d.autoGrabV1Enabled==true end
        if d.stealBarWidth~=nil then M.stealBarWidth=math.clamp(tonumber(d.stealBarWidth) or 360,260,560) end
        do
            local mode = d.autoGrabMode or d.AutoGrabMode or d.stealMode or d.grabMode
            if type(mode) == "string" then
                mode = string.upper(mode)
                if mode:find("2") then mode = "V2" elseif mode:find("1") then mode = "V1" end
            end
            if mode == "V1" or mode == "V2" then
                M.autoGrabMode = mode
                if type(d.normalStealVersion) == "string" then M.normalStealVersion = d.normalStealVersion end
                if d.tpBatVersion == "V1" or d.tpBatVersion == "V2" then M.tpBatVersion = d.tpBatVersion end
                if d.batV2Enabled ~= nil then M.batV2Enabled = d.batV2Enabled == true end
                if d.autoBatV2SwingEnabled ~= nil then M.autoBatV2SwingEnabled = d.autoBatV2SwingEnabled ~= false end
                if type(d.batV2Speed) == "number" then M.AUTO_BAT_V2_SPEED = d.batV2Speed end
                if type(d.batV2Dist) == "number" then M.AUTO_BAT_V2_DIST = d.batV2Dist end
                if type(d.batV2Height) == "number" then M.AUTO_BAT_V2_HEIGHT = d.batV2Height end
                if type(d.batV2HitDist) == "number" then M.AUTO_BAT_V2_HIT_DIST = d.batV2HitDist end
                if type(d.batV2SwingCd) == "number" then M.AUTO_BAT_V2_SWING_CD = d.batV2SwingCd end
                pcall(function()
                    if ZenXSteal then ZenXSteal.GrabMode = mode end
                end)
            end
        end
        pcall(function()
            if getgenv and getgenv()._PrimeHubAutoGrabMode then
                local g = tostring(getgenv()._PrimeHubAutoGrabMode)
                if g == "V1" or g == "V2" then
                    M.autoGrabMode = g
                    if ZenXSteal then ZenXSteal.GrabMode = g end
                end
            end
        end)
        if d.lineESPEnabled~=nil then M.lineESPEnabled=d.lineESPEnabled end
        if d.menuOpen~=nil then M.menuOpen=d.menuOpen~=false end
        if type(d.dropMode) == "string" and (d.dropMode == "Fling" or d.dropMode == "Jump Drop") then
            M.dropMode = d.dropMode
        end
        if type(d.Theme)=="string" and CHERRY_THEMES[d.Theme] then M._savedTheme=d.Theme; M.colorScheme=d.Theme end
        if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then M._savedTheme=d.colorScheme; M.colorScheme=d.colorScheme end
        if type(d.skyTheme)=="string" and M.CANDY_SKY_PRESETS and M.CANDY_SKY_PRESETS[d.skyTheme] then M.currentSkyTheme=d.skyTheme end
        if d.speedESPEnabled~=nil then M.speedESPEnabled=d.speedESPEnabled end
        if type(d.animPack)=="string" then M.animPack=d.animPack end
        if type(d.batSkinName)=="string" then M.batSkinName=d.batSkinName end
        if type(d.characterSkinName)=="string" then M.characterSkinName=d.characterSkinName end
        if d.headlessEnabled~=nil then M.headlessEnabled=d.headlessEnabled end
        if d.korbloxEnabled~=nil then M.korbloxEnabled=d.korbloxEnabled end
        if d.bypassAimbotEnabled~=nil then M.bypassAimbotEnabled=d.bypassAimbotEnabled==true end
        if d.animPackEnabled~=nil then M.animPackEnabled=d.animPackEnabled end
        if d.primeHubSkinEnabled~=nil then M.primeHubSkinEnabled=d.primeHubSkinEnabled==true end
        if d.primeHubKawatanEnabled~=nil then M.primeHubKawatanEnabled=d.primeHubKawatanEnabled==true end
        if d.primeHubHeadHidden~=nil then M.primeHubHeadHidden=d.primeHubHeadHidden==true end
        if d.primeHubFireEnabled~=nil then M.primeHubFireEnabled=d.primeHubFireEnabled==true end
        if d.primeHubHaloEnabled~=nil then M.primeHubHaloEnabled=d.primeHubHaloEnabled==true end
        if type(d.primeHubFireColorName)=="string" then M.primeHubFireColorName=d.primeHubFireColorName end
        if type(d.primeHubMusicSelection)=="string" then M.primeHubMusicSelection=d.primeHubMusicSelection end
        -- Utility / performance persistence
        if d.antiLag ~= nil then M.antiLagEnabled = d.antiLag == true end
        if d.antiLagV2 ~= nil then M.antiLagV2Enabled = d.antiLagV2 == true end
        if d.nukeOptimiserEnabled ~= nil then M.nukeOptimiserEnabled = d.nukeOptimiserEnabled == true end
        if d.antiVoidEnabled ~= nil then M.antiVoidEnabled = d.antiVoidEnabled == true end
        if d.bodyLockEnabled ~= nil then M.bodyLockEnabled = d.bodyLockEnabled == true end
        if type(d.bodyLockRadius) == "number" then M.bodyLockRadius = d.bodyLockRadius end
        if d.antiKick ~= nil then M.antiKickEnabled = d.antiKick == true end
        if d.safeMode ~= nil then M.safeModeEnabled = d.safeMode == true end
        if d.stretchRez ~= nil then M.stretchRezEnabled = d.stretchRez == true end
        if d.antiSummerBase ~= nil then M.antiSummerBaseEnabled = d.antiSummerBase == true end
        if d.removeAcc ~= nil then M.removeAccEnabled = d.removeAcc == true end
        if d.graphicsBajosEnabled ~= nil then M.graphicsBajosEnabled = d.graphicsBajosEnabled == true end
        if d.antiDieEnabled ~= nil then M.antiDieEnabled = d.antiDieEnabled == true end
        if d.hideMobileButtons ~= nil then M.hideMobileButtons = d.hideMobileButtons == true end
        if d.mobileButtonsEnabled ~= nil then M.mobileButtonsEnabled = d.mobileButtonsEnabled == true end
        if d.uiLocked ~= nil then M.uiLocked = d.uiLocked == true end
        if d.adaptThemeName then M.adaptThemeName = tostring(d.adaptThemeName) end
        if type(d.customBgId) == "string" or type(d.customBgId) == "number" then M.customBgId = tostring(d.customBgId) end
        
        local function lk(e,d2)
            if type(d2)~="table" then return end
            if d2.kb and Enum.KeyCode[d2.kb] then e.kb=Enum.KeyCode[d2.kb] end
            if d2.gp and Enum.KeyCode[d2.gp] then e.gp=Enum.KeyCode[d2.gp] end
        end
        if d.dropBrainrotKey then lk(M.KB.DropBrainrot,d.dropBrainrotKey) end
        if d.autoLeftKey then lk(M.KB.AutoLeft,d.autoLeftKey) end
        if d.autoRightKey then lk(M.KB.AutoRight,d.autoRightKey) end
        if d.autoBatKey then lk(M.KB.AutoBat,d.autoBatKey) end
        if d.laggerToggleKey then lk(M.KB.LaggerToggle,d.laggerToggleKey) end
        if d.laggerCarryKey then lk(M.KB.LaggerCarry,d.laggerCarryKey) end
        if d.tpFloorKey then lk(M.KB.TPFloor,d.tpFloorKey) end
        if d.guiHideKey then lk(M.KB.GuiHide,d.guiHideKey) end
        if d.instaResetKey then lk(M.KB.InstaReset,d.instaResetKey) end
                if d.bypassAimbotKey then lk(M.KB.BypassAimbot,d.bypassAimbotKey) end
        if d.batTPKey then lk(M.KB.BatTP,d.batTPKey) end
        if d.batV2Key and M.KB.BatV2 then lk(M.KB.BatV2,d.batV2Key) end
        if d.speedNormalKey then lk(M.KB.SpeedNormal, d.speedNormalKey) end
        if d.speedLaggerKey then lk(M.KB.SpeedLagger, d.speedLaggerKey) end
        if d.speedCustomKey then lk(M.KB.SpeedCustom, d.speedCustomKey) end
    end
end
local _saveDebounce, _savePending = false, false
local _saveDebounce = false
local _savePending = false
function savePrimeHubFeKlanConfig()
    -- debounce: evita spam de writefile (más fluido)
    if _saveDebounce then
        _savePending = true
        pcall(function()
            if getgenv then getgenv()._PrimeHubAutoGrabMode = tostring(M.autoGrabMode or "V1") end
        end)
        return true
    end
    _saveDebounce = true
    _savePending = false
    task.delay(0.45, function()
        _saveDebounce = false
        if _savePending then
            _savePending = false
            pcall(savePrimeHubFeKlanConfig)
        end
    end)

    local function ks(e)
        if type(e) ~= "table" then return {kb = nil, gp = nil} end
        return {
            kb = (e.kb and e.kb.Name) or nil,
            gp = (e.gp and e.gp.Name) or nil,
        }
    end
    local btnPos = {}
    for key, pos in pairs(M._savedButtonPositions or {}) do
        if type(pos) == "table" and type(pos.x) == "number" and type(pos.y) == "number" then
            btnPos[key] = {x = pos.x, y = pos.y}
        end
    end
    if M.mobGuiRef then
        for _, child in ipairs(M.mobGuiRef:GetChildren()) do
            local key = child:GetAttribute("BtnKey")
            if (not key) and type(child.Name) == "string" and child.Name:sub(1, 10) == "BtnHolder_" then
                key = child.Name:sub(11)
            end
            if key then
                btnPos[key] = {x = child.Position.X.Offset, y = child.Position.Y.Offset}
            end
        end
        M._savedButtonPositions = btnPos
    end

    local cfg = {
        Theme = (PrimeHubFeKlanConfig and PrimeHubFeKlanConfig.Theme) or M.colorScheme,
        toggleLayoutPos = M.toggleLayoutPos or "Low",
        colorScheme = M.colorScheme,
        normalSpeed = tonumber(M.NS) or 60,
        carrySpeed = tonumber(M.CS) or 30,
        laggerSpeed = tonumber(M.LAGGER_SPEED) or 15,
        laggerCarrySpeed = tonumber(M.LAGGER_CARRY_SPEED) or 24.5,
        speedProfile = M.speedProfile or "Normal",
        normalSpeedNorm = tonumber(M.NormalSpeedNorm) or 59,
        normalSpeedSteal = tonumber(M.NormalSpeedSteal) or 29,
        laggerSpeedNorm = tonumber(M.LaggerSpeedNorm) or 30,
        laggerSpeedSteal = tonumber(M.LaggerSpeedSteal) or 15,
        customSpeedNorm = tonumber(M.CustomSpeedNorm) or 66,
        customSpeedSteal = tonumber(M.CustomSpeedSteal) or 34,
        speedMethod = M.speedMethod,
        carrySpeedActive = M.carrySpeedActive == true,
        manualCarryActive = M.manualCarryActive == true,
        laggerCarryActive = M.laggerCarryActive == true,
        laggerModeEnabled = M.laggerModeEnabled == true,
        autoLeftEnabled = M.autoLeftEnabled == true,
        autoRightEnabled = M.autoRightEnabled == true,
        autoBat = M.autoBatEnabled == true,
        batAimbotEnabled = (M.batAimbotEnabled == true) or (M.autoBatEnabled == true),
        batCounter = M.batCounterEnabled == true,
        batCounterV2 = M.batCounterV2Enabled == true,
        bypassAimbotEnabled = M.bypassAimbotEnabled == true,
        zenonetopAimOn = M._zenonetopAimOn ~= false,
        autoDestroyTurretEnabled = M.autoDestroyTurretEnabled == true,
        antiRagdoll = M.antiRagdollEnabled == true,
        antiRagdollMode = M.antiRagdollMode or "V1",
        medusaCounter = M.medusaCounterEnabled == true,
        autoSwing = M.autoSwingEnabled == true,
        autoSwingEnabled = M.autoSwingEnabled == true,
        autoGrabV1Enabled = M.autoGrabV1Enabled == true,
        autoGrabMode = tostring(M.autoGrabMode or "V1"),
        normalStealVersion = tostring(M.normalStealVersion or "86"),
        tpBatVersion = tostring(M.tpBatVersion or "V1"),
        batV2Enabled = M.batV2Enabled == true,
        autoBatV2SwingEnabled = M.autoBatV2SwingEnabled ~= false,
        batV2Speed = M.AUTO_BAT_V2_SPEED,
        batV2Dist = M.AUTO_BAT_V2_DIST,
        batV2Height = M.AUTO_BAT_V2_HEIGHT,
        batV2HitDist = M.AUTO_BAT_V2_HIT_DIST,
        batV2SwingCd = M.AUTO_BAT_V2_SWING_CD,
        autoStealEnabled = M.Steal and M.Steal.AutoStealEnabled == true,
        dropMode = tostring(M.dropMode or "Fling"),
        stealBarWidth = tonumber(M.stealBarWidth) or 360,
        antiVoidEnabled = M.antiVoidEnabled == true,
        bodyLockEnabled = M.bodyLockEnabled == true,
        bodyLockRadius = tonumber(M.bodyLockRadius) or 60,
        batAimbotEnabled = M.batAimbotEnabled == true,
        tpBatEnabled = M.tpBatEnabled == true,
        bypassAimbotEnabled = M.bypassAimbotEnabled == true,
        antiRagdoll = M.antiRagdollEnabled == true,
        infiniteJump = M.infJumpEnabled == true,
        medusaCounter = M.medusaCounterEnabled == true,
        batCounter = M.batCounterEnabled == true,
        autoSwing = M.autoSwingEnabled == true,
        autoSwingEnabled = M.autoSwingEnabled == true,
        antiRagdollMode = M.antiRagdollMode or "V1",
        autoGrabV1Enabled = M.autoGrabV1Enabled == true,
        autoGrabMode = tostring(M.autoGrabMode or "V1"),
        stealBarWidth = tonumber(M.stealBarWidth) or 360,
        antiLag = M.antiLagEnabled == true,
        graphicsBajosEnabled = M.graphicsBajosEnabled == true,
        antiDieEnabled = M.antiDieEnabled == true,
        currentAccessoryPack = tostring(M.currentAccessoryPack or "Off"),
        pcKeyStatusEnabled = M.pcKeyStatusEnabled == true,
        antiLagV2 = M.antiLagV2Enabled == true,
        nukeOptimiserEnabled = M.nukeOptimiserEnabled == true,
        adaptThemeName = M.adaptThemeName,
        menuBgIndex = tonumber(M.menuBgIndex) or 1,
        customBgId = tostring(M.customBgId or ""),
        batSkinName = tostring(M.batSkinName or "Off"),
        characterSkinName = tostring(M.characterSkinName or "Off"),
        antiVoidEnabled = M.antiVoidEnabled == true,
        bodyLockEnabled = M.bodyLockEnabled == true,
        bodyLockRadius = tonumber(M.bodyLockRadius) or 60,
        antiKick = M.antiKickEnabled == true,
        safeMode = M.safeModeEnabled == true,
        stretchRez = M.stretchRezEnabled == true,
        antiSummerBase = M.antiSummerBaseEnabled == true,
        removeAcc = M.removeAccEnabled == true,
        lineESPEnabled = M.lineESPEnabled == true,
        speedESPEnabled = M.speedESPEnabled == true,
        showPlayerSpeeds = M.showPlayerSpeeds == true,
        playerESPEnabled = M.playerESPEnabled == true,
        uiScale = M.uiScale,
        uiLocked = M.uiLocked == true,
        hideMobileButtons = M.hideMobileButtons == true,
        mobileButtonsEnabled = M.mobileButtonsEnabled ~= false,
        mobileButtonPositions = btnPos,
        animPack = M.animPack,
        animPackEnabled = M.animPackEnabled == true,
        headlessEnabled = M.headlessEnabled == true,
        primeHubHeadHidden = M.primeHubHeadHidden ~= false,
        skyTheme = M.currentSkyTheme,
        skyThemesEnabled = M.skyThemesEnabled == true,
        customBgId = tonumber(M.customBgId) or 0,
        fovValue = M.fovValue,
        dropBrainrotKey = ks(M.KB and M.KB.DropBrainrot),
        autoLeftKey = ks(M.KB and M.KB.AutoLeft),
        autoRightKey = ks(M.KB and M.KB.AutoRight),
        autoBatKey = ks(M.KB and M.KB.AutoBat),
        laggerToggleKey = ks(M.KB and M.KB.LaggerToggle),
        laggerCarryKey = ks(M.KB and M.KB.LaggerCarry),
        tpFloorKey = ks(M.KB and M.KB.TPFloor),
        guiHideKey = ks(M.KB and M.KB.GuiHide),
        instaResetKey = ks(M.KB and M.KB.InstaReset),
        bypassAimbotKey = ks(M.KB and M.KB.BypassAimbot),
        batTPKey = ks(M.KB and M.KB.BatTP),
        batV2Key = ks(M.KB and M.KB.BatV2),
        speedNormalKey = ks(M.KB and M.KB.SpeedNormal),
        speedLaggerKey = ks(M.KB and M.KB.SpeedLagger),
        speedCustomKey = ks(M.KB and M.KB.SpeedCustom),
    }

    local keybinds = {
        dropBrainrotKey = cfg.dropBrainrotKey,
        autoLeftKey = cfg.autoLeftKey,
        autoRightKey = cfg.autoRightKey,
        autoBatKey = cfg.autoBatKey,
        laggerToggleKey = cfg.laggerToggleKey,
        laggerCarryKey = cfg.laggerCarryKey,
        tpFloorKey = cfg.tpFloorKey,
        guiHideKey = cfg.guiHideKey,
        instaResetKey = cfg.instaResetKey,
        bypassAimbotKey = cfg.bypassAimbotKey,
        batTPKey = cfg.batTPKey,
        speedNormalKey = cfg.speedNormalKey,
        speedLaggerKey = cfg.speedLaggerKey,
        speedCustomKey = cfg.speedCustomKey,
    }

    pcall(function()
        if getgenv then
            getgenv()._PrimeHubFeKlanSavedCfg = cfg
            getgenv()._PrimeHubFeKlanKeybinds = keybinds
        end
    end)

    local name = PRIMEHUB_FE_KLAN_CONFIG_NAME or "primehub_fe_klan_config.json"
    local kbName = "primehub_fe_klan_keybinds.json"
    local ok1, json1 = pcall(function() return HS:JSONEncode(cfg) end)
    local ok2, json2 = pcall(function() return HS:JSONEncode(keybinds) end)
    if ok1 and type(json1) == "string" and type(writefile) == "function" then
        pcall(function() writefile(name, json1) end)
        pcall(function() writefile("primehub_fe_klan_config.json", json1) end)
    end
    if ok2 and type(json2) == "string" and type(writefile) == "function" then
        pcall(function() writefile(kbName, json2) end)
    end
    return true
end

M.saveConfig = savePrimeHubFeKlanConfig
M.loadConfig = loadPrimeHubFeKlanConfig
M.primeHubSkinEnabled = false
M.primeHubKawatanEnabled = false
M.primeHubHeadHidden = M.primeHubHeadHidden ~= false
M.primeHubFireEnabled = M.primeHubFireEnabled ~= false
M.primeHubHaloEnabled = M.primeHubHaloEnabled ~= false
M.primeHubFireColorName = M.primeHubFireColorName or "Blue"
M.skinLegHidden = M.skinLegHidden ~= false
M.hideMobileButtons = M.hideMobileButtons == true
_G.PrimeHubForceMobileVisible = not M.hideMobileButtons
M.primeHubMusicSelection = M.primeHubMusicSelection or "Off"
M._primeHubSkinOriginal = M._primeHubSkinOriginal or {}
M._primeHubSkinCharacterConn = M._primeHubSkinCharacterConn or nil
M._primeHubMusicSound = M._primeHubMusicSound or nil
M.ROT_X_MUSIC = {
    ["Steve Lacy"] = {assetId = 139557371055334, volume = 0.75},
    ["Teeth XXXTENTACION"] = {assetId = 111018848542448, volume = 0.75},
    ["Tokio Drift"] = {assetId = 125968616299811, volume = 0.75},
    ["the dream tree"] = {assetId = 102616343336371, volume = 0.75},
    ["alors on danse larp version"] = {assetId = 74034501108599, volume = 0.75},
    ["Prime Hub 1"] = {assetId = 131155338276252, volume = 0.75, startPosition = 8},
    ["Prime Hub 2"] = {assetId = 77097411209853, volume = 0.75},
    ["Prime Hub 3"] = {assetId = 139982007364841, volume = 0.75},
    ["Prime Hub 4"] = {assetId = 109159861086023, volume = 0.75},
    ["Prime Hub 5"] = {assetId = 109548574272322, volume = 0.75},
    ["Prime Hub 6"] = {assetId = 74181901266359, volume = 0.75},
    ["Prime Hub 7"] = {assetId = 103659269007598, volume = 0.75},
    ["Prime Hub 8"] = {assetId = 120167544632035, volume = 0.75},
    ["Prime Hub 9"] = {assetId = 132525879805359, volume = 0.75},
    ["Prime Hub 10"] = {assetId = 74181901266359, volume = 0.75},
}
M.ROT_X_MUSIC_ORDER = {
    "Steve Lacy",
    "Teeth XXXTENTACION",
    "Tokio Drift",
    "the dream tree",
    "alors on danse larp version",
    "Prime Hub 1", "Prime Hub 2", "Prime Hub 3", "Prime Hub 4", "Prime Hub 5",
    "Prime Hub 6", "Prime Hub 7", "Prime Hub 8", "Prime Hub 9", "Prime Hub 10",
}
M.ROT_X_MUSIC_START = M.ROT_X_MUSIC_START or {}
for _, name in ipairs(M.ROT_X_MUSIC_ORDER or {}) do
    M.ROT_X_MUSIC_START[name] = tonumber(M.ROT_X_MUSIC_START[name]) or 0
end
for i = 1, 10 do
    local k = "Prime Hub " .. i
    M.ROT_X_MUSIC_START[k] = tonumber(M.ROT_X_MUSIC_START[k]) or 0
end
function M.setPrimeHubMusicStart(name, seconds)
    local value = math.max(0, tonumber(seconds) or 0)
    M.ROT_X_MUSIC_START[name] = value
    if M.primeHubMusicSelection == name and M._primeHubMusicSound then
        pcall(function() M._primeHubMusicSound.TimePosition = value end)
    end
    savePrimeHubFeKlanConfig()
end
local function primeHubSkinColor()
    return M.primeHubKawatanEnabled and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(245, 245, 255)
end
local PRIMEHUB_FIRE_COLORS = {
    Blue = {Color3.fromRGB(55, 155, 255), Color3.fromRGB(15, 55, 255)},
    Red = {M.currentAccent or Color3.fromRGB(58, 128, 245), Color3.fromRGB(120, 0, 0)},
    Green = {Color3.fromRGB(80, 255, 120), Color3.fromRGB(0, 90, 35)},
    Purple = {Color3.fromRGB(220, 90, 255), Color3.fromRGB(70, 0, 120)},
    White = {Color3.fromRGB(255, 235, 248), Color3.fromRGB(150, 150, 255)},
    Yellow = {Color3.fromRGB(255, 170, 225), Color3.fromRGB(255, 120, 195)},
    Black = {Color3.fromRGB(20, 20, 20), Color3.fromRGB(255, 195, 30)},
}
local PRIMEHUB_FIRE_COLOR_NAMES = {"Blue", "Red", "Green", "Purple", "White", "Yellow", "Black"}
local function primeHubFireColors()
    local pair = PRIMEHUB_FIRE_COLORS[M.primeHubFireColorName or "Blue"] or PRIMEHUB_FIRE_COLORS.Blue
    return pair[1], pair[2]
end
function M._rememberPrimeHubSkin(obj, data)
    if obj and M._primeHubSkinOriginal[obj] == nil then
        M._primeHubSkinOriginal[obj] = data
    end
end
function M._restorePrimeHubSkin()
    for obj, data in pairs(M._primeHubSkinOriginal) do
        if obj and obj.Parent and type(data) == "table" then
            pcall(function()
                if data.kind == "part" and obj:IsA("BasePart") then
                    obj.Color = data.color
                    obj.Material = data.material
                    obj.Transparency = data.transparency
                    obj.LocalTransparencyModifier = data.localTransparency
                    obj.Reflectance = data.reflectance
                elseif data.kind == "shirt" and obj:IsA("Shirt") then
                    obj.ShirtTemplate = data.template
                elseif data.kind == "pants" and obj:IsA("Pants") then
                    obj.PantsTemplate = data.template
                elseif data.kind == "graphic" and obj:IsA("ShirtGraphic") then
                    obj.Graphic = data.graphic
                elseif data.kind == "decal" and (obj:IsA("Decal") or obj:IsA("Texture")) then
                    obj.Transparency = data.transparency
                elseif data.kind == "bodycolors" and obj:IsA("BodyColors") then
                    obj.HeadColor3 = data.head
                    obj.LeftArmColor3 = data.leftArm
                    obj.RightArmColor3 = data.rightArm
                    obj.LeftLegColor3 = data.leftLeg
                    obj.RightLegColor3 = data.rightLeg
                    obj.TorsoColor3 = data.torso
                end
            end)
        end
    end
    local char = player.Character
    if char then
        local fire = char:FindFirstChild("PrimeHubSkinHeadFire", true)
        if fire then pcall(function() fire:Destroy() end) end
        local aura = char:FindFirstChild("PrimeHubSkinFloatingAura", true)
        if aura then pcall(function() aura:Destroy() end) end
        local crown = char:FindFirstChild("PrimeHubSkinFloatingCrown", true)
        if crown then pcall(function() crown:Destroy() end) end
        local dragon = char:FindFirstChild("PrimeHubSkinDragon", true)
        if dragon then pcall(function() dragon:Destroy() end) end
    end
    M._primeHubSkinOriginal = {}
end
function M._enforcePrimeHubSkinIntegrity(char)
    if not M.primeHubSkinEnabled or not char or not char.Parent then return end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Motor6D") then
            obj.Enabled = true
        elseif obj:IsA("BasePart") then
            local n = obj.Name:lower()
            local compact = n:gsub("[%s_%-]", "")
            if n == "left leg" or compact == "leftleg" or compact == "leftupperleg" or compact == "leftlowerleg" or compact == "leftfoot" then
                local hidden = M.skinLegHidden ~= false
                obj.Transparency = hidden and 1 or 0
                obj.LocalTransparencyModifier = hidden and 1 or 0
            elseif n == "right leg" or compact == "rightleg" or compact == "rightupperleg" or compact == "rightlowerleg" or compact == "rightfoot" then
                obj.Transparency = 0
                obj.LocalTransparencyModifier = 0
            end
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end
end
function M._applyPrimeHubSkin(char)
    if not M.primeHubSkinEnabled or not char or not char.Parent then return end
    local skinColor = primeHubSkinColor()
        local hideNames = {
        head = M.primeHubHeadHidden ~= false,
    }
    for _, joint in ipairs(char:GetDescendants()) do
        if joint:IsA("Motor6D") then
            joint.Enabled = true
        end
    end
    local bodyColors = char:FindFirstChildOfClass("BodyColors")
    if bodyColors then
        M._rememberPrimeHubSkin(bodyColors, {
            kind = "bodycolors", head = bodyColors.HeadColor3, leftArm = bodyColors.LeftArmColor3,
            rightArm = bodyColors.RightArmColor3, leftLeg = bodyColors.LeftLegColor3,
            rightLeg = bodyColors.RightLegColor3, torso = bodyColors.TorsoColor3,
        })
        bodyColors.HeadColor3 = skinColor
        bodyColors.LeftArmColor3 = skinColor
        bodyColors.RightArmColor3 = skinColor
        bodyColors.LeftLegColor3 = skinColor
        bodyColors.RightLegColor3 = skinColor
        bodyColors.TorsoColor3 = skinColor
    end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            M._rememberPrimeHubSkin(obj, {
                kind = "part", color = obj.Color, material = obj.Material,
                transparency = obj.Transparency, localTransparency = obj.LocalTransparencyModifier,
                reflectance = obj.Reflectance,
            })
            local inAccessory = obj:FindFirstAncestorOfClass("Accessory") ~= nil
            if inAccessory then
                obj.LocalTransparencyModifier = 1
            else
                obj.Color = skinColor
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                local lowerPartName = obj.Name:lower()
                local compactPartName = lowerPartName:gsub("[%s_%-]", "")
                if hideNames[lowerPartName] or hideNames[compactPartName] then
                    obj.LocalTransparencyModifier = 1
                end
            end
        elseif obj:IsA("Shirt") then
            M._rememberPrimeHubSkin(obj, {kind = "shirt", template = obj.ShirtTemplate})
            obj.ShirtTemplate = ""
        elseif obj:IsA("Pants") then
            M._rememberPrimeHubSkin(obj, {kind = "pants", template = obj.PantsTemplate})
            obj.PantsTemplate = ""
        elseif obj:IsA("ShirtGraphic") then
            M._rememberPrimeHubSkin(obj, {kind = "graphic", graphic = obj.Graphic})
            obj.Graphic = ""
        elseif (obj:IsA("Decal") or obj:IsA("Texture")) and obj.Name:lower() == "face" then
            M._rememberPrimeHubSkin(obj, {kind = "decal", transparency = obj.Transparency})
            obj.Transparency = 1
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        local aura = head:FindFirstChild("PrimeHubSkinFloatingAura")
        if not aura then
            aura = Instance.new("Model")
            aura.Name = "PrimeHubSkinFloatingAura"
            aura.Parent = head
        end
        for _, oldPart in ipairs(aura:GetChildren()) do
            if oldPart.Name == "HaloCircle" or oldPart.Name == "HaloSegment" or oldPart.Name == "HaloRay" then pcall(function() oldPart:Destroy() end) end
        end
        local xRadius = 1.04
        local zRadius = 1.02
        local segments = 48
        for i = 1, segments do
            local angle = (i / segments) * math.pi * 2
            local line = Instance.new("Part")
            line.Name = "HaloCircle"
            local tangentLength = (2 * math.pi * xRadius / segments) * 1.16
            line.Size = Vector3.new(tangentLength, 0.105, 0.105)
            line.Color = (i % 6 == 0) and Color3.fromRGB(255, 200, 240) or Color3.fromRGB(255, 130, 205)
            line.Material = Enum.Material.Neon
            line.Transparency = M.primeHubHaloEnabled == false and 1 or 0.01
            line.Reflectance = 0
            line.CanCollide = false
            line.CanTouch = false
            line.CanQuery = false
            line.Massless = true
            line.CastShadow = false
            line.CFrame = head.CFrame * CFrame.new(math.cos(angle) * xRadius, 0.90, math.sin(angle) * zRadius) * CFrame.Angles(0, -math.atan2(math.cos(angle) * zRadius, math.sin(angle) * xRadius), 0)
            line.Parent = aura
            local weld = Instance.new("WeldConstraint")
            weld.Name = "HaloWeld"
            weld.Part0 = head
            weld.Part1 = line
            weld.Parent = line
        end
        for _, segment in ipairs(aura:GetChildren()) do
            if segment:IsA("BasePart") then
                segment.Color = Color3.fromRGB(255, 135, 215)
                segment.Material = Enum.Material.Neon
                segment.Transparency = 0.01
                segment.Reflectance = 0
            end
        end
        local rayCount = 24
        for i = 1, rayCount do
            local rayAngle = (i / rayCount) * math.pi * 2
            local ray = Instance.new("Part")
            ray.Name = "HaloRay"
            ray.Size = Vector3.new(0.055, 0.34 + (i % 4) * 0.07, 0.055)
            ray.Color = (i % 4 == 0) and Color3.fromRGB(255, 200, 240) or Color3.fromRGB(255, 145, 215)
            ray.Material = Enum.Material.Neon
            ray.Transparency = M.primeHubHaloEnabled == false and 1 or 0.04
            ray.CanCollide = false
            ray.CanTouch = false
            ray.CanQuery = false
            ray.Massless = true
            ray.CastShadow = false
            ray.CFrame = head.CFrame * CFrame.new(math.cos(rayAngle) * 1.28, 0.90, math.sin(rayAngle) * 1.26) * CFrame.Angles(0, -rayAngle, 0)
            ray.Parent = aura
            local rayWeld = Instance.new("WeldConstraint")
            rayWeld.Name = "HaloRayWeld"
            rayWeld.Part0 = head
            rayWeld.Part1 = ray
            rayWeld.Parent = ray
        end
        local glow = head:FindFirstChild("HaloGlow")
        if not glow then
            glow = Instance.new("PointLight")
            glow.Name = "HaloGlow"
            glow.Parent = head
        end
        glow.Enabled = false
        glow.Color = Color3.fromRGB(255, 145, 215)
        glow.Brightness = 0
        glow.Range = 0
        glow.Shadows = false
        local haloHighlight = aura:FindFirstChild("HaloHighlight")
        if not haloHighlight then
            haloHighlight = Instance.new("Highlight")
            haloHighlight.Name = "HaloHighlight"
            haloHighlight.Adornee = aura
            haloHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            haloHighlight.FillColor = Color3.fromRGB(255, 145, 215)
            haloHighlight.FillTransparency = 0.08
            haloHighlight.OutlineColor = Color3.fromRGB(255, 205, 240)
            haloHighlight.OutlineTransparency = 0.02
            haloHighlight.Parent = aura
        end
        haloHighlight.Enabled = M.primeHubHaloEnabled ~= false
        haloHighlight.FillColor = Color3.fromRGB(255, 145, 215)
        haloHighlight.FillTransparency = 0.08
        haloHighlight.OutlineColor = Color3.fromRGB(255, 205, 240)
        haloHighlight.OutlineTransparency = 0.02
        if M.primeHubHaloEnabled == false then
            pcall(function() aura:Destroy() end)
            pcall(function() glow:Destroy() end)
        end
        local fire = head:FindFirstChild("PrimeHubSkinHeadFire")
        if not fire then
            fire = Instance.new("Fire")
            fire.Name = "PrimeHubSkinHeadFire"
            fire.Parent = head
        end
        local primary, secondary = primeHubFireColors()
                fire.Color = primary
        fire.SecondaryColor = secondary
        fire.Heat = 13
        fire.Size = 9
        fire.Enabled = M.primeHubFireEnabled ~= false
    end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if torso then
        local dragon = torso:FindFirstChild("PrimeHubSkinDragon")
        if dragon then pcall(function() dragon:Destroy() end) end
    end
    M._enforcePrimeHubSkinIntegrity(char)
end
function M.setPrimeHubSkinMode(mode, silent)
    -- skin negra / Kawatan desactivada; solo Hide Head
    M._restorePrimeHubSkin()
    M.primeHubSkinEnabled = false
    M.primeHubKawatanEnabled = false
    local enabled = false
    if false then
        M.headlessEnabled = false
        M.korbloxEnabled = false
        M.applyHeadlessToChar(player.Character, false)
        M.applyKorbloxToChar(player.Character, false)
        M._applyPrimeHubSkin(player.Character)
        if not M._primeHubSkinCharacterConn then
            M._primeHubSkinCharacterConn = player.CharacterAdded:Connect(function(char)
                task.wait(0.35)
                if M.primeHubSkinEnabled then M._applyPrimeHubSkin(char) end
            end)
        end
    elseif M._primeHubSkinCharacterConn then
        pcall(function() M._primeHubSkinCharacterConn:Disconnect() end)
        M._primeHubSkinCharacterConn = nil
    end
    if not silent then savePrimeHubFeKlanConfig() end
end


-- ==================== BAT V2 (from CLEAN) ====================
M.batV2Enabled = M.batV2Enabled == true
M.autoBatV2SwingEnabled = true
M._batV2Conn = nil
M._batV2HitCD = false
M.AUTO_BAT_V2_SPEED = 60
M.AUTO_BAT_V2_DIST = 1.0
M.AUTO_BAT_V2_HEIGHT = 1.5
M.AUTO_BAT_V2_V_OFF = 0.0
M.AUTO_BAT_V2_HIT_DIST = 4.5
M.AUTO_BAT_V2_SWING_CD = 0.08

local function _batV2FindTool()
    local c = player.Character
    if c then
        for _, v in ipairs(c:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end
    local bp = player:FindFirstChildOfClass("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end
    return nil
end

local function _batV2ClosestPlayer()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, math.huge end
    local hpos = hrp.Position
    local closest, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local c = p.Character
            if c then
                local tr = c:FindFirstChild("HumanoidRootPart")
                local ph = c:FindFirstChildOfClass("Humanoid")
                if tr and ph and ph.Health > 0 then
                    local d = (hpos - tr.Position).Magnitude
                    if d < bestDist then bestDist = d; closest = p end
                end
            end
        end
    end
    return closest, bestDist
end

local function _batV2TryHit()
    if M._batV2HitCD or not M.autoBatV2SwingEnabled then return end
    M._batV2HitCD = true
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local tool = _batV2FindTool()
        if tool then
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
    task.delay(M.AUTO_BAT_V2_SWING_CD, function()
        M._batV2HitCD = false
    end)
end

function M.startBatV2()
    if M._batV2Conn then return end
    M._batV2Conn = RunService.Heartbeat:Connect(function()
        if not M.batV2Enabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local target = select(1, _batV2ClosestPlayer())
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetVel = targetRoot.AssemblyLinearVelocity or targetRoot.Velocity
                local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector
                local offset = moveDir * M.AUTO_BAT_V2_DIST + Vector3.new(0, M.AUTO_BAT_V2_HEIGHT + M.AUTO_BAT_V2_V_OFF, 0)
                local desiredPos = targetRoot.Position + offset
                local toTarget = desiredPos - root.Position
                if toTarget.Magnitude > 0.5 then
                    local moveVec = toTarget.Unit * M.AUTO_BAT_V2_SPEED
                    root.AssemblyLinearVelocity = Vector3.new(moveVec.X, moveVec.Y, moveVec.Z)
                else
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                    if root.AssemblyLinearVelocity.Magnitude < 1 then
                        root.AssemblyLinearVelocity = Vector3.zero
                    end
                end
                local distToTarget = (root.Position - targetRoot.Position).Magnitude
                if distToTarget <= M.AUTO_BAT_V2_HIT_DIST then
                    _batV2TryHit()
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

function M.stopBatV2()
    if M._batV2Conn then
        M._batV2Conn:Disconnect()
        M._batV2Conn = nil
    end
    local c = player.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
    end
    M._batV2HitCD = false
end

function M.enableBatV2()
    if M.batV2Enabled then return end
    -- mutual exclusion with other bat modes
    if M.autoBatEnabled or M.batAimbotEnabled then
        M.autoBatEnabled = false
        M.batAimbotEnabled = false
        if M.stopBatAimbot then pcall(M.stopBatAimbot) end
    end
    if M.bypassAimbotEnabled then
        M.bypassAimbotEnabled = false
        if M.stopBypassAimbot then pcall(M.stopBypassAimbot) end
        if M.mobBtnRefs and M.mobBtnRefs.tpBat then pcall(M.mobBtnRefs.tpBat, false) end
    end
    if M.autoLeftEnabled then
        M.autoLeftEnabled = false
        if M.stopAutoLeft then pcall(M.stopAutoLeft) end
        if M.mobBtnRefs and M.mobBtnRefs.autoLeft then pcall(M.mobBtnRefs.autoLeft, false) end
    end
    if M.autoRightEnabled then
        M.autoRightEnabled = false
        if M.stopAutoRight then pcall(M.stopAutoRight) end
        if M.mobBtnRefs and M.mobBtnRefs.autoRight then pcall(M.mobBtnRefs.autoRight, false) end
    end
    M.batV2Enabled = true
    M.startBatV2()
    if M.setBatV2Visual then pcall(M.setBatV2Visual, true) end
    if M.mobBtnRefs and M.mobBtnRefs.batV2 then pcall(M.mobBtnRefs.batV2, true) end
end

function M.disableBatV2()
    if not M.batV2Enabled then return end
    M.batV2Enabled = false
    M.stopBatV2()
    if M.setBatV2Visual then pcall(M.setBatV2Visual, false) end
    if M.mobBtnRefs and M.mobBtnRefs.batV2 then pcall(M.mobBtnRefs.batV2, false) end
end

function M.toggleBatV2()
    if M.batV2Enabled then M.disableBatV2() else M.enableBatV2() end
end

-- ==================== PACK ACCESSORY (VisDuels Bleed packs) ====================
M.ACCESSORY_PACK_ORDER = {
    {"Off", "Off"},
    {"Bleed 1", "Bleed 1"},
    {"Bleed 2", "Bleed 2"},
    {"Bleed 3", "Bleed 3"},
    {"Outfit 3", "Outfit 3"},
    {"Homero Chino", "Homero Chino"},
}
M.currentAccessoryPack = M.currentAccessoryPack or "Off"
M._accOriginalOutfit = M._accOriginalOutfit or {shirt = nil, pants = nil}
M._accOriginalAccessories = M._accOriginalAccessories or {}
M.accSelectorLabel = nil

local BLEED_PACKS = {
    ["Bleed 1"] = {
        accessory = 306969564,
        offset = Vector3.new(0, 0.3, 0),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=10632503795",
        pants = "http://www.roblox.com/asset/?id=123161592384863",
        korblox = "right",
    },
    ["Bleed 2"] = {
        accessory = 1744060292,
        offset = Vector3.new(0, 1.4, -0.2),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11526718530",
        pants = "http://www.roblox.com/asset/?id=93710523210027",
        korblox = "right",
    },
    ["Bleed 3"] = {
        accessory = 112564966849233,
        offset = Vector3.new(0, 0.6, 0),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11849088376",
        pants = "http://www.roblox.com/asset/?id=16534673928",
        korblox = "right",
    },
    -- From CLEAN hub
    ["Outfit 3"] = {
        accessory = 8349240186,
        offset = Vector3.new(0, 0.9, 0),
        shirt = "http://www.roblox.com/asset/?id=11926549070",
        pants = "http://www.roblox.com/asset/?id=13189494471",
        headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747",
        headTexture = nil,
        korblox = "none",
        headlessKorblox = true,
    },
}

-- Homero Chino (CLEAN) config + helpers
local HOMERO_TAG = "LocalOutfit_"
local HOMERO_CFG = {
    body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
    aplicarCuerpo = true,
    items = {
        { id = 103227869700418, offset = CFrame.new(0,0,0) },
        { id = 84952305140948,   offset = CFrame.new(0,0,0) },
        { id = 122465238537030,  offset = CFrame.new(0,0,0) },
    },
    shirt = nil,
    pants = "rbxassetid://78591690208112",
    skinColor = Color3.fromRGB(234,184,146),
    headColor = Color3.fromRGB(0,0,0),
}

local function _homeroLoadObjects(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return { res } end
    return nil
end

local function _homeroCollectParts(objs)
    local out = {}
    for _, o in ipairs(objs) do
        if o:IsA("BasePart") then out[#out+1] = o end
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then out[#out+1] = d end
        end
    end
    return out
end

local function _homeroFindAtt(char, name)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("Attachment") and p.Name == name and p.Parent and p.Parent:IsA("BasePart") then
            return p
        end
    end
end

local function _homeroApplyBody(char)
    for _, id in ipairs(HOMERO_CFG.body) do
        local objs = _homeroLoadObjects(id)
        if objs then
            for _, mp in ipairs(_homeroCollectParts(objs)) do
                local orig = char:FindFirstChild(mp.Name)
                if orig and orig:IsA("BasePart") then
                    local c = mp:Clone()
                    c.Name = HOMERO_TAG .. "body_" .. mp.Name
                    c.CanCollide = false
                    c.Anchored = false
                    c.Massless = true
                    c.Size = orig.Size
                    c.CFrame = orig.CFrame
                    c.Parent = char
                    local w = Instance.new("WeldConstraint")
                    w.Part0 = orig
                    w.Part1 = c
                    w.Parent = c
                    orig.Transparency = 1
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
end

local function _homeroAttachItem(char, entry)
    local objs = _homeroLoadObjects(entry.id)
    if not objs then return false end
    local handle
    for _, p in ipairs(_homeroCollectParts(objs)) do
        if p.Name == "Handle" then handle = p; break end
        if not handle then handle = p end
    end
    if not handle then
        for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        return false
    end
    local H = handle:Clone()
    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
    H.Name = HOMERO_TAG .. "item_" .. tostring(entry.id)
    H.CanCollide = false
    H.Anchored = false
    H.Massless = true
    local wrap = H:FindFirstChildWhichIsA("WrapLayer")
    local target, c0, c1
    if wrap then
        target = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        c0 = entry.offset or CFrame.new()
        c1 = CFrame.new()
    else
        local hAtt = H:FindFirstChildOfClass("Attachment")
        local bAtt = hAtt and _homeroFindAtt(char, hAtt.Name)
        if bAtt then
            target = bAtt.Parent
            c0 = bAtt.CFrame * (entry.offset or CFrame.new())
            c1 = hAtt.CFrame
        else
            target = char:FindFirstChild("Head")
            c0 = entry.offset or CFrame.new(0, 1.4, 0)
            c1 = CFrame.new()
        end
    end
    if not target then H:Destroy(); return false end
    H.CFrame = target.CFrame * c0 * c1:Inverse()
    H.Parent = char
    local w = Instance.new("Weld")
    w.Part0 = target
    w.Part1 = H
    w.C0 = c0
    w.C1 = c1
    w.Parent = H
    return true
end

function M.applyHomeroOutfit(char)
    char = char or player.Character
    if not char then return end
    char:WaitForChild("Humanoid", 10)
    char:WaitForChild("Head", 10)
    task.wait(0.35)
    for _, d in ipairs(char:GetChildren()) do
        if type(d.Name) == "string" and d.Name:sub(1, #HOMERO_TAG) == HOMERO_TAG then
            pcall(function() d:Destroy() end)
        end
    end
    if HOMERO_CFG.skinColor then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        bc.HeadColor3 = HOMERO_CFG.headColor or HOMERO_CFG.skinColor
        bc.TorsoColor3 = HOMERO_CFG.skinColor
        bc.LeftArmColor3, bc.RightArmColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.LeftLegColor3, bc.RightLegColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.Parent = char
    end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 1 end
        end
    end
    if HOMERO_CFG.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = HOMERO_CFG.shirt
        s.Parent = char
    end
    if HOMERO_CFG.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = HOMERO_CFG.pants
        p.Parent = char
    end
    if HOMERO_CFG.aplicarCuerpo then pcall(_homeroApplyBody, char) end
    for _, e in ipairs(HOMERO_CFG.items) do
        pcall(_homeroAttachItem, char, e)
    end
end


local function _accSaveOriginalOutfit(char)
    if not char then return end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    M._accOriginalOutfit.shirt = shirt and shirt.ShirtTemplate or nil
    M._accOriginalOutfit.pants = pants and pants.PantsTemplate or nil
end

local function _accRestoreOriginalOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then obj:Destroy() end
    end
    if M._accOriginalOutfit.shirt then
        local s = Instance.new("Shirt"); s.ShirtTemplate = M._accOriginalOutfit.shirt; s.Parent = char
    end
    if M._accOriginalOutfit.pants then
        local p = Instance.new("Pants"); p.PantsTemplate = M._accOriginalOutfit.pants; p.Parent = char
    end
    M._accOriginalOutfit.shirt = nil
    M._accOriginalOutfit.pants = nil
end

local function _accClearOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then obj:Destroy() end
    end
end

local function _accSaveOriginalAccessories(char)
    M._accOriginalAccessories = {}
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then
            table.insert(M._accOriginalAccessories, child:Clone())
        end
    end
end

local function _accRestoreOriginalAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" or child.Name:find("Korblox_") then
            child:Destroy()
        end
    end
    for _, clone in ipairs(M._accOriginalAccessories) do
        if clone then
            local newAcc = clone:Clone()
            newAcc.Parent = char
        end
    end
    M._accOriginalAccessories = {}
end

local function _accClearAllAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then
            child:Destroy()
        end
        if child.Name:find("Korblox_") or child.Name:find("Headless_") then
            child:Destroy()
        end
    end
    for _, partName in ipairs({"Head", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then part.Transparency = 0 end
    end
end

local function _accApplyBleedOutfit(packName)
    local config = BLEED_PACKS[packName]
    if not config then return false end
    local char = player.Character
    if not char then return false end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
    if not head then return false end

    if config.headlessKorblox then
        pcall(function()
            head.Transparency = 1
            head.CanCollide = false
            head.LocalTransparencyModifier = 1
            local face = head:FindFirstChild("face")
            if face then face.Transparency = 1 end
        end)
    end

    if config.headMesh then
        for _, d in ipairs(char:GetChildren()) do
            if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
                pcall(function() d:Destroy() end)
            end
        end
        local done = false
        if head:IsA("MeshPart") then
            done = pcall(function()
                head.MeshId = config.headMesh
                if config.headTexture then head.TextureID = config.headTexture end
            end)
        end
        if not done then
            local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
            sm.Parent = head
            sm.MeshType = Enum.MeshType.FileMesh
            sm.MeshId = config.headMesh
            sm.TextureId = config.headTexture or ""
        end
    end

    if config.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = config.shirt; s.Parent = char
    end
    if config.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = config.pants; p.Parent = char
    end

    if config.accessory and head then
        local old = char:FindFirstChild("AuFfitAccessory")
        if old then old:Destroy() end
        local objs = nil
        local ok, res = pcall(function()
            if type(game.GetObjects) == "function" then
                return game:GetObjects("rbxassetid://" .. tostring(config.accessory))
            end
        end)
        if ok and type(res) == "table" and #res > 0 then
            objs = res
        else
            ok, res = pcall(function()
                return game:GetService("InsertService"):LoadAsset(config.accessory)
            end)
            if ok and res then objs = {res} end
        end
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = CFrame.new(config.offset or Vector3.zero)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end

    if config.korblox and config.korblox ~= "none" then
        local function attachKorblox(side)
            local ids = { left = 139607673, right = 139607718 }
            local targets = { left = "LeftUpperLeg", right = "RightUpperLeg" }
            local hides = {
                left = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
                right = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
            }
            local targetPart = char:FindFirstChild(targets[side])
            if not targetPart then return false end
            for _, partName in ipairs(hides[side]) do
                local limb = char:FindFirstChild(partName)
                if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
            end
            local success, objects = pcall(function()
                if type(game.GetObjects) == "function" then
                    return game:GetObjects("rbxassetid://" .. ids[side])
                end
            end)
            if not success or not objects or #objects == 0 then
                success, objects = pcall(function()
                    local m = game:GetService("InsertService"):LoadAsset(ids[side])
                    return m and {m} or nil
                end)
            end
            if not success or not objects or #objects == 0 then return false end
            local assetModel = objects[1]
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if not mainMesh then pcall(function() assetModel:Destroy() end); return false end
            mainMesh.CanCollide = false
            mainMesh.Massless = true
            mainMesh.CFrame = targetPart.CFrame
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = targetPart
            weld.Part1 = mainMesh
            weld.Parent = mainMesh
            assetModel.Name = "Korblox_" .. side
            assetModel.Parent = char
            return true
        end
        if config.korblox == "left" then attachKorblox("left")
        elseif config.korblox == "right" then attachKorblox("right") end
    end
    return true
end

function M.applyAccessoryPack(packName)
    packName = tostring(packName or "Off")
    M.currentAccessoryPack = packName
    local char = player.Character
    if not char then return end
    if packName == "Off" then
        _accClearAllAccessories(char)
        for _, d in ipairs(char:GetChildren()) do
            if type(d.Name) == "string" and d.Name:sub(1, #HOMERO_TAG) == HOMERO_TAG then
                pcall(function() d:Destroy() end)
            end
        end
        _accRestoreOriginalOutfit(char)
        _accRestoreOriginalAccessories(char)
        return
    end
    if not M._accOriginalOutfit.shirt and not M._accOriginalOutfit.pants then
        _accSaveOriginalOutfit(char)
    end
    if #(M._accOriginalAccessories or {}) == 0 then
        _accSaveOriginalAccessories(char)
    end
    _accClearOutfit(char)
    _accClearAllAccessories(char)
    for _, d in ipairs(char:GetChildren()) do
        if type(d.Name) == "string" and d.Name:sub(1, #HOMERO_TAG) == HOMERO_TAG then
            pcall(function() d:Destroy() end)
        end
    end
    if packName == "Homero Chino" then
        task.spawn(function()
            pcall(M.applyHomeroOutfit, char)
        end)
        return
    end
    _accApplyBleedOutfit(packName)
end

function M.setAccessoryPackByOffset(dir)
    local order = M.ACCESSORY_PACK_ORDER
    local idx = 1
    for i, entry in ipairs(order) do
        if entry[2] == M.currentAccessoryPack then idx = i; break end
    end
    local newIdx = idx + (tonumber(dir) or 0)
    if newIdx < 1 then newIdx = #order end
    if newIdx > #order then newIdx = 1 end
    local packName = order[newIdx][2]
    M.applyAccessoryPack(packName)
    if M.accSelectorLabel then M.accSelectorLabel.Text = packName end
    if M.saveConfig then pcall(M.saveConfig) end
end

-- Persistencia robusta del Pack Accessory: reaplica al iniciar y después de cada respawn.
function M.restoreSavedAccessoryPack(char)
    local packName = tostring(M.currentAccessoryPack or "Off")
    if packName == "" or packName == "nil" then packName = "Off" end
    if packName == "Off" then
        if M.accSelectorLabel and M.accSelectorLabel.Parent then M.accSelectorLabel.Text = "Off" end
        return false
    end
    if not M.ACCESSORY_PACK_ORDER then
        if M.accSelectorLabel and M.accSelectorLabel.Parent then M.accSelectorLabel.Text = "Off" end
        return false
    end
    local target = char or player.Character
    if not target or not target.Parent then return false end
    local humanoid = target:FindFirstChildOfClass("Humanoid") or target:WaitForChild("Humanoid", 4)
    local head = target:FindFirstChild("Head") or target:WaitForChild("Head", 4)
    if not humanoid or not head then return false end
    local ok = pcall(function() M.applyAccessoryPack(packName) end)
    if M.accSelectorLabel and M.accSelectorLabel.Parent then M.accSelectorLabel.Text = packName end
    return ok
end
local function queueSavedAccessoryPack(char)
    local delays = {0.15, 0.6, 1.25, 2.2}
    for _, delayTime in ipairs(delays) do
        task.delay(delayTime, function()
            if player.Character == char and M.currentAccessoryPack and M.currentAccessoryPack ~= "Off" then
                pcall(function() M.restoreSavedAccessoryPack(char) end)
            end
        end)
    end
end
player.CharacterAdded:Connect(function(char)
    queueSavedAccessoryPack(char)
end)
if player.Character then
    queueSavedAccessoryPack(player.Character)
end


function M.setPrimeHubSkinEnabled(on)
    M.setPrimeHubSkinMode(on and "PrimeHub" or "Off")
end
function M.setPrimeHubKawatanEnabled(on)
    M.setPrimeHubSkinMode(on and "Kawatan" or "Off")
end
    do
        local _skinAcc = 0
        local _skinParts = {}
        local _skinChar = nil
        RunService.RenderStepped:Connect(function()
        if not M.primeHubSkinEnabled then return end
        local char = player.Character
        if not char or not char.Parent then return end
        _skinAcc = _skinAcc + 0.016
        if _skinAcc < (PRIMEHUB_MOBILE and 0.14 or 0.07) then return end
        _skinAcc = 0
        M._enforcePrimeHubSkinIntegrity(char)
        local head = char:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            local headTarget = M.primeHubHeadHidden == false and 0 or 1
            if head.Transparency ~= headTarget then head.Transparency = headTarget end
            if head.LocalTransparencyModifier ~= headTarget then head.LocalTransparencyModifier = headTarget end
            local fire = head:FindFirstChild("PrimeHubSkinHeadFire")
            if not fire then
                fire = Instance.new("Fire")
                fire.Name = "PrimeHubSkinHeadFire"
                fire.Parent = head
            end
            local primary, secondary = primeHubFireColors()
            fire.Color = primary
            fire.SecondaryColor = secondary
            fire.Heat = 13
            fire.Size = 9
            fire.Enabled = M.primeHubFireEnabled ~= false
            local aura = char:FindFirstChild("PrimeHubSkinFloatingAura", true)
            if M.primeHubHaloEnabled == false then
                if aura then pcall(function() aura:Destroy() end) end
                local glow = head:FindFirstChild("HaloGlow")
                if glow then pcall(function() glow:Destroy() end) end
            elseif not aura or not aura:FindFirstChild("HaloCircle") or not aura:FindFirstChild("HaloRay") then
                pcall(function() M._applyPrimeHubSkin(char) end)
            end
        end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                local compact = n:gsub("[%s_%-]", "")
                if n == "left leg" or compact == "leftleg" or compact == "leftupperleg" or compact == "leftlowerleg" or compact == "leftfoot" then
                    local hidden = M.skinLegHidden ~= false
                    local target = hidden and 1 or 0
                    if obj.Transparency ~= target then obj.Transparency = target end
                    if obj.LocalTransparencyModifier ~= target then obj.LocalTransparencyModifier = target end
                elseif n == "right leg" or compact == "rightleg" or compact == "rightupperleg" or compact == "rightlowerleg" or compact == "rightfoot" then
                    if obj.Transparency ~= 0 then obj.Transparency = 0 end
                    if obj.LocalTransparencyModifier ~= 0 then obj.LocalTransparencyModifier = 0 end
                elseif obj:FindFirstAncestorOfClass("Accessory") then
                    if obj.LocalTransparencyModifier ~= 1 then obj.LocalTransparencyModifier = 1 end
                end
            end
        end
    end)
    end
function M.setPrimeHubMusic(name, silent)
    local selected = M.ROT_X_MUSIC[name] and name or "Off"
    if M._primeHubMusicSound then
        pcall(function() M._primeHubMusicSound:Stop() end)
        pcall(function() M._primeHubMusicSound:Destroy() end)
        M._primeHubMusicSound = nil
    end
    M.primeHubMusicSelection = selected
    if selected ~= "Off" then
        local entry = M.ROT_X_MUSIC[selected]
        local sound = Instance.new("Sound")
        sound.Name = "PrimeHubMusic"
        sound.SoundId = "rbxassetid://" .. tostring(entry.assetId)
        sound.Volume = entry.volume or 0.75
        sound.Looped = false
        sound.Parent = game:GetService("SoundService")
        M._primeHubMusicSound = sound
        sound.Ended:Connect(function()
            if M._primeHubMusicSound ~= sound or M.primeHubMusicSelection ~= selected then return end
            local order = M.getPrimeHubMusicOrder and M.getPrimeHubMusicOrder() or {}
            local idx = 1
            for i, name in ipairs(order) do
                if name == selected then idx = i; break end
            end
            local nextName = order[idx + 1] or order[1]
            if nextName then M.setPrimeHubMusic(nextName) else M.setPrimeHubMusic("Off") end
        end)
        local startAt = math.max(0, tonumber(M.ROT_X_MUSIC_START[selected]) or 0)
        pcall(function() sound.TimePosition = startAt end)
        sound.Loaded:Connect(function()
            if M._primeHubMusicSound == sound and sound.Parent then
                pcall(function() sound.TimePosition = startAt end)
                pcall(function() sound:Play() end)
            end
        end)
        task.spawn(function()
            pcall(function()
                if not sound.IsLoaded then sound.Loaded:Wait() end
                if M._primeHubMusicSound == sound and sound.Parent then sound:Play() end
            end)
        end)
        pcall(function() sound:Play() end)
    end
    if not silent then savePrimeHubFeKlanConfig() end
end

-- Graphics Bajos: modo de rendimiento integrado.
M.graphicsBajosEnabled = false
M._graphicsBajosConn = nil
local function applyGraphicsBajosObject(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.CastShadow = false
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.BackSurface = Enum.SurfaceType.SmoothNoOutlines
            obj.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
            obj.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
            obj.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
            obj.RightSurface = Enum.SurfaceType.SmoothNoOutlines
            obj.TopSurface = Enum.SurfaceType.SmoothNoOutlines
        elseif obj:IsA("PostEffect") then
            obj.Enabled = false
        elseif obj:IsA("ForceField") then
            obj:Destroy()
        end
    end)
end

-- ===== PRIMEHUB MUSIC PLAYER GUI (Utility OPEN) =====
M._musicPlayerGui = M._musicPlayerGui or nil
M._musicPlayerConn = M._musicPlayerConn or nil
M._musicPaused = M._musicPaused or false

function M.getPrimeHubMusicOrder()
    local list = {}
    if type(M.ROT_X_MUSIC_ORDER) == "table" then
        for _, name in ipairs(M.ROT_X_MUSIC_ORDER) do
            if M.ROT_X_MUSIC and M.ROT_X_MUSIC[name] then
                table.insert(list, name)
            end
        end
    end
    if #list == 0 then
        for n = 1, 10 do
            local name = "PrimeHub " .. n
            if M.ROT_X_MUSIC and M.ROT_X_MUSIC[name] then
                table.insert(list, name)
            end
        end
    end
    return list
end

function M.closePrimeHubMusicPlayer()
    if M._musicPlayerConn then
        pcall(function() M._musicPlayerConn:Disconnect() end)
        M._musicPlayerConn = nil
    end
    if M._musicSeekConns then
        for _, c in ipairs(M._musicSeekConns) do
            pcall(function() c:Disconnect() end)
        end
        M._musicSeekConns = nil
    end
    if M._musicPlayerGui then
        pcall(function() M._musicPlayerGui:Destroy() end)
        M._musicPlayerGui = nil
    end
end

function M.openPrimeHubMusicPlayer()
    M.closePrimeHubMusicPlayer()
    local pg = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 3)
    if not pg then return end

    local WHITE = Color3.fromRGB(255, 255, 255)
    local WHITE_DIM = Color3.fromRGB(200, 200, 210)
    local BG = Color3.fromRGB(10, 10, 14)
    local BTN = Color3.fromRGB(28, 28, 36)

    local sg = Instance.new("ScreenGui")
    sg.Name = "PrimeHubMusicPlayer"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 120
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = pg
    M._musicPlayerGui = sg

    local panel = Instance.new("Frame", sg)
    panel.Name = "PlayerPanel"
    panel.Size = UDim2.new(0, 320, 0, 168)
    panel.Position = UDim2.new(0.5, -160, 1, -200)
    panel.AnchorPoint = Vector2.new(0, 0)
    panel.BackgroundColor3 = BG
    panel.BackgroundTransparency = 0.08
    panel.BorderSizePixel = 0
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 18)
    local pStroke = Instance.new("UIStroke", panel)
    pStroke.Color = WHITE
    pStroke.Thickness = 1.2
    pStroke.Transparency = 0.45

    local title = Instance.new("TextLabel", panel)
    title.Name = "Title"
    title.Size = UDim2.new(1, -56, 0, 24)
    title.Position = UDim2.new(0, 16, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = "Prime Hub Music"
    title.TextColor3 = WHITE
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTruncate = Enum.TextTruncate.AtEnd

    local sub = Instance.new("TextLabel", panel)
    sub.Name = "Sub"
    sub.Size = UDim2.new(1, -56, 0, 16)
    sub.Position = UDim2.new(0, 16, 0, 36)
    sub.BackgroundTransparency = 1
    sub.Text = "prime hub music"
    sub.TextColor3 = WHITE_DIM
    sub.TextSize = 12
    sub.Font = Enum.Font.Gotham
    sub.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", panel)
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -36, 0, 10)
    closeBtn.BackgroundColor3 = BTN
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = WHITE
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
    closeBtn.MouseButton1Click:Connect(function()
        M.closePrimeHubMusicPlayer()
    end)

    local waveBars = {}
    local function makeWave(parent, x)
        local w = Instance.new("Frame", parent)
        w.Size = UDim2.new(0, 48, 0, 32)
        w.Position = UDim2.new(0, x, 0, 68)
        w.BackgroundTransparency = 1
        for i = 1, 4 do
            local bar = Instance.new("Frame", w)
            bar.Size = UDim2.new(0, 5, 0, 10)
            bar.Position = UDim2.new(0, (i - 1) * 11, 1, 0)
            bar.AnchorPoint = Vector2.new(0, 1)
            bar.BackgroundColor3 = WHITE
            bar.BackgroundTransparency = 0.15
            bar.BorderSizePixel = 0
            Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)
            table.insert(waveBars, {bar = bar, phase = i * 0.7 + x * 0.01, side = x})
        end
        return w
    end
    makeWave(panel, 12)
    makeWave(panel, 260)

    -- Borde vivo blanco / plomo
    local borderPulse = 0
    local PLOMO = Color3.fromRGB(120, 120, 130)

    local prevBtn = Instance.new("TextButton", panel)
    prevBtn.Size = UDim2.new(0, 36, 0, 36)
    prevBtn.Position = UDim2.new(0.5, -70, 0, 68)
    prevBtn.BackgroundColor3 = BTN
    prevBtn.BorderSizePixel = 0
    prevBtn.Text = "<<"
    prevBtn.TextColor3 = WHITE
    prevBtn.TextSize = 12
    prevBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", prevBtn).CornerRadius = UDim.new(1, 0)

    local playBtn = Instance.new("TextButton", panel)
    playBtn.Size = UDim2.new(0, 48, 0, 48)
    playBtn.Position = UDim2.new(0.5, -24, 0, 62)
    playBtn.BackgroundColor3 = WHITE
    playBtn.BorderSizePixel = 0
    playBtn.Text = "II"
    playBtn.TextColor3 = Color3.fromRGB(10, 10, 14)
    playBtn.TextSize = 16
    playBtn.Font = Enum.Font.GothamBlack
    Instance.new("UICorner", playBtn).CornerRadius = UDim.new(1, 0)

    local nextBtn = Instance.new("TextButton", panel)
    nextBtn.Size = UDim2.new(0, 36, 0, 36)
    nextBtn.Position = UDim2.new(0.5, 34, 0, 68)
    nextBtn.BackgroundColor3 = BTN
    nextBtn.BorderSizePixel = 0
    nextBtn.Text = ">>"
    nextBtn.TextColor3 = WHITE
    nextBtn.TextSize = 12
    nextBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", nextBtn).CornerRadius = UDim.new(1, 0)

    local elapsedLbl = Instance.new("TextLabel", panel)
    elapsedLbl.Size = UDim2.new(0, 40, 0, 14)
    elapsedLbl.Position = UDim2.new(0, 14, 1, -28)
    elapsedLbl.BackgroundTransparency = 1
    elapsedLbl.Text = "0:00"
    elapsedLbl.TextColor3 = WHITE_DIM
    elapsedLbl.TextSize = 11
    elapsedLbl.Font = Enum.Font.Code
    elapsedLbl.TextXAlignment = Enum.TextXAlignment.Left

    local durLbl = Instance.new("TextLabel", panel)
    durLbl.Size = UDim2.new(0, 40, 0, 14)
    durLbl.Position = UDim2.new(1, -54, 1, -28)
    durLbl.BackgroundTransparency = 1
    durLbl.Text = "0:00"
    durLbl.TextColor3 = WHITE_DIM
    durLbl.TextSize = 11
    durLbl.Font = Enum.Font.Code
    durLbl.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", panel)
    track.Size = UDim2.new(1, -108, 0, 4)
    track.Position = UDim2.new(0, 54, 1, -24)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = WHITE
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = WHITE
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function fmt(t)
        t = math.max(0, math.floor(tonumber(t) or 0))
        return string.format("%d:%02d", math.floor(t / 60), t % 60)
    end

    local function currentIndex()
        local sel = M.primeHubMusicSelection or "Off"
        local order = M.getPrimeHubMusicOrder()
        for i, name in ipairs(order) do
            if name == sel then return i end
        end
        return 1
    end

    local function refreshTitle()
        local sel = M.primeHubMusicSelection
        if not sel or sel == "Off" then
            title.Text = "Prime Hub Music"
            sub.Text = "prime hub music"
            playBtn.Text = ">"
        else
            title.Text = tostring(sel)
            sub.Text = "prime hub • now playing"
            local snd = M._primeHubMusicSound
            if snd and snd.IsPlaying and not M._musicPaused then
                playBtn.Text = "II"
            else
                playBtn.Text = ">"
            end
        end
    end

    local function playIndex(n)
        local list = M.getPrimeHubMusicOrder()
        if #list == 0 then return end
        if n < 1 then n = #list end
        if n > #list then n = 1 end
        M._musicPaused = false
        M.setPrimeHubMusic(list[n])
        refreshTitle()
    end

    prevBtn.MouseButton1Click:Connect(function()
        playIndex(currentIndex() - 1)
    end)
    nextBtn.MouseButton1Click:Connect(function()
        playIndex(currentIndex() + 1)
    end)
    playBtn.MouseButton1Click:Connect(function()
        local snd = M._primeHubMusicSound
        local sel = M.primeHubMusicSelection
        if not sel or sel == "Off" or not snd then
            playIndex(1)
            return
        end
        if snd.IsPlaying and not M._musicPaused then
            pcall(function() snd:Pause() end)
            M._musicPaused = true
            playBtn.Text = ">"
        else
            pcall(function() snd:Resume() end)
            if not snd.IsPlaying then pcall(function() snd:Play() end) end
            M._musicPaused = false
            playBtn.Text = "II"
        end
        refreshTitle()
    end)

    -- seek drag
    local dragging = false
    local function seekTo(x)
        local snd = M._primeHubMusicSound
        if not snd then return end
        local w = math.max(1, track.AbsoluteSize.X)
        local a = math.clamp((x - track.AbsolutePosition.X) / w, 0, 1)
        local len = (snd.TimeLength and snd.TimeLength > 0) and snd.TimeLength or 1
        pcall(function() snd.TimePosition = a * len end)
        fill.Size = UDim2.new(a, 0, 1, 0)
        knob.Position = UDim2.new(a, 0, 0.5, 0)
    end
    local seekConns = {}
    table.insert(seekConns, track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            seekTo(input.Position.X)
        end
    end))
    table.insert(seekConns, UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            seekTo(input.Position.X)
        end
    end))
    table.insert(seekConns, UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    M._musicSeekConns = seekConns

    -- auto start first track if none
    if not M.primeHubMusicSelection or M.primeHubMusicSelection == "Off" then
        playIndex(1)
    else
        refreshTitle()
        local snd = M._primeHubMusicSound
        if snd and not snd.IsPlaying then
            pcall(function() snd:Play() end)
        end
    end

    -- Heartbeat ligero: throttle ~15 FPS visual (no cada frame)
    local _mpAcc = 0
    local _lastTitle = ""
    local _sin = math.sin
    local _abs = math.abs
    M._musicPlayerConn = RunService.Heartbeat:Connect(function(dt)
        if not M._musicPlayerGui then return end
        _mpAcc = _mpAcc + (dt or 0.016)
        if _mpAcc < 0.066 then return end -- ~15 updates/s
        _mpAcc = 0

        local snd = M._primeHubMusicSound
        local pos, len = 0, 0
        local playing = false
        if snd then
            pos = snd.TimePosition or 0
            len = snd.TimeLength or 0
            playing = snd.IsPlaying and not M._musicPaused
        end
        elapsedLbl.Text = fmt(pos)
        if len > 0 then durLbl.Text = fmt(len) end
        if len > 0 and not dragging then
            local a = pos / len
            if a < 0 then a = 0 elseif a > 1 then a = 1 end
            fill.Size = UDim2.new(a, 0, 1, 0)
            knob.Position = UDim2.new(a, 0, 0.5, 0)
        end
        local t = os.clock()
        local nBars = #waveBars
        for i = 1, nBars do
            local info = waveBars[i]
            local bar = info.bar
            if bar then
                local h
                if playing then
                    h = 8 + _abs(_sin(t * 6 + info.phase)) * 24
                else
                    h = 7 + _abs(_sin(t + info.phase)) * 3
                end
                bar.Size = UDim2.new(0, 5, 0, h)
            end
        end
        borderPulse = borderPulse + 0.08
        local lerp = (_sin(borderPulse) + 1) * 0.5
        pStroke.Color = WHITE:Lerp(PLOMO, lerp)
        pStroke.Transparency = 0.28 + lerp * 0.22
        local sel = M.primeHubMusicSelection or "Off"
        local want = (sel == "Off") and ">" or (playing and "II" or ">")
        if playBtn.Text ~= want then playBtn.Text = want end
        if sel ~= _lastTitle then
            _lastTitle = sel
            if sel == "Off" then
                title.Text = "Prime Hub Music"
                sub.Text = "prime hub music"
            else
                title.Text = tostring(sel)
                sub.Text = "prime hub • now playing"
            end
        end
    end)
end


function M.enableGraphicsBajos()
    M.graphicsBajosEnabled = true
    local terrain = workspace:FindFirstChildWhichIsA("Terrain")
    if terrain then
        terrain.WaterWaveSize = 0; terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0; terrain.WaterTransparency = 1
    end
    Lighting.Brightness = 2; Lighting.GlobalShadows = false
    Lighting.FogEnd = 9000000000; Lighting.FogStart = 9000000000
    for _, obj in ipairs(game:GetDescendants()) do applyGraphicsBajosObject(obj) end
    if M._graphicsBajosConn then M._graphicsBajosConn:Disconnect() end
    M._graphicsBajosConn = workspace.DescendantAdded:Connect(function(obj)
        if M.graphicsBajosEnabled then applyGraphicsBajosObject(obj) end
    end)
end
function M.disableGraphicsBajos()
    M.graphicsBajosEnabled = false
    if M._graphicsBajosConn then M._graphicsBajosConn:Disconnect(); M._graphicsBajosConn = nil end
end


-- ============================================================
-- AUTO STEAL (Anti-Sammy style) with presets 75 / 80 / 86 / 90
-- ============================================================
M.Steal = M.Steal or { AutoStealEnabled = false, StealRadius = 61, StealDuration = 1.3, Data = {} }
M.normalStealVersion = M.normalStealVersion or "86"
M.NORMAL_STEAL_PERCENT = {
    ["75"] = 0.75,
    ["80"] = 0.80,
    ["86"] = 0.86,
    ["90"] = 0.90,
}
M._asIsStealing = false
M._asStealProgress = 0
M._asStealPaused = false
M._asAutoStealConn = nil

local function AS_isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

function M.AS_findNearestPrompt()
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if not AS_isMyPlotByName(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local sp = base and base:FindFirstChild("Spawn")
                    if sp then
                        local d = (sp.Position - root.Position).Magnitude
                        if d <= (M.Steal.StealRadius or 61) and d < dist then
                            local att = sp:FindFirstChild("PromptAttachment")
                            if att then
                                for _, prompt in ipairs(att:GetChildren()) do
                                    if prompt:IsA("ProximityPrompt") and tostring(prompt.ActionText or ""):find("Steal") then
                                        nearest, dist = prompt, d
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nearest
end

function M.AS_getPromptSpawnPosition(prompt)
    if not prompt then return nil end
    local parent = prompt.Parent
    if parent and parent.Name == "PromptAttachment" then parent = parent.Parent end
    if parent and parent.Name == "Spawn" and parent:IsA("BasePart") then return parent.Position end
    return nil
end

function M.AS_isStealTargetClose(spawnPosition)
    if not spawnPosition then return false end
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    return root ~= nil and (spawnPosition - root.Position).Magnitude <= 9
end

function M.AS_executeSteal(prompt)
    if M._asIsStealing then return end
    if not M.Steal.Data[prompt] then
        M.Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        if getconnections then
            pcall(function()
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(M.Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(M.Steal.Data[prompt].trigger, c.Function) end
                end
            end)
        end
    end
    local data = M.Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    M._asIsStealing = true
    local spawnPosition = M.AS_getPromptSpawnPosition(prompt)
    local duration = math.max(tonumber(M.Steal.StealDuration) or 1.3, 0.05)
    local stopRatio = M.NORMAL_STEAL_PERCENT[tostring(M.normalStealVersion)] or M.NORMAL_STEAL_PERCENT["86"]
    local stopPoint = duration * stopRatio
    M._asStealProgress = 0
    M._asStealPaused = false
    pcall(function() getgenv()._AS_StealProgress = 0 end)

    task.spawn(function()
        for _, fn in ipairs(data.hold) do task.spawn(fn) end
        local started = tick()
        while M._asIsStealing and M.Steal.AutoStealEnabled and prompt.Parent do
            local elapsed = tick() - started
            M._asStealProgress = math.clamp(elapsed / duration, 0, stopRatio)
            pcall(function() getgenv()._AS_StealProgress = M._asStealProgress end)
            if M.autoGrabV1Progress ~= nil then M.autoGrabV1Progress = M._asStealProgress end
            if type(zenXUpdateBar) == "function" then pcall(zenXUpdateBar) elseif M.zenXUpdateBar then pcall(M.zenXUpdateBar) end
            if elapsed >= stopPoint then break end
            task.wait()
        end
        M._asStealProgress = stopRatio
        pcall(function() getgenv()._AS_StealProgress = stopRatio end)
        M._asStealPaused = true
        local closeEnough = M.AS_isStealTargetClose(spawnPosition)
        local waitDeadline = tick() + 2
        while M._asIsStealing and M.Steal.AutoStealEnabled and prompt.Parent and not closeEnough and tick() < waitDeadline do
            closeEnough = M.AS_isStealTargetClose(spawnPosition)
            task.wait()
        end
        if closeEnough and M._asIsStealing and M.Steal.AutoStealEnabled and prompt.Parent then
            M._asStealPaused = false
            local remaining = math.max(duration - stopPoint, 0.01)
            local finishStarted = tick()
            while M._asIsStealing and M.Steal.AutoStealEnabled and prompt.Parent do
                local finishAlpha = math.clamp((tick() - finishStarted) / remaining, 0, 1)
                M._asStealProgress = stopRatio + finishAlpha * (1 - stopRatio)
                pcall(function() getgenv()._AS_StealProgress = M._asStealProgress end)
                if M.autoGrabV1Progress ~= nil then M.autoGrabV1Progress = M._asStealProgress end
                if finishAlpha >= 1 then break end
                task.wait()
            end
            if M._asIsStealing and M.Steal.AutoStealEnabled and prompt.Parent then
                for _, fn in ipairs(data.trigger) do task.spawn(fn) end
            end
        end
        task.wait(0.06)
        data.ready = true
        M._asIsStealing = false
        M._asStealProgress = 0
        M._asStealPaused = false
        pcall(function() getgenv()._AS_StealProgress = 0 end)
        if M.autoGrabV1Progress ~= nil then M.autoGrabV1Progress = 0 end
    end)
end

function M.startAntiSammyAutoSteal()
    M.Steal = M.Steal or { AutoStealEnabled = false, StealRadius = 61, StealDuration = 1.3, Data = {} }
    M.Steal.AutoStealEnabled = true
    M.autoGrabV1Enabled = true
    ZenXSteal.AutoStealEnabled = true
    -- sync radius
    if M.Steal.StealRadius then ZenXSteal.StealRadius = M.Steal.StealRadius end
    if M.startAutoGrabV1 then
        M.startAutoGrabV1()
    end
end

function M.stopAntiSammyAutoSteal()
    M.Steal = M.Steal or {}
    M.Steal.AutoStealEnabled = false
    M.autoGrabV1Enabled = false
    ZenXSteal.AutoStealEnabled = false
    M._asIsStealing = false
    if M.stopAutoGrabV1 then
        M.stopAutoGrabV1()
    end
    if M._asAutoStealConn then
        pcall(function() M._asAutoStealConn:Disconnect() end)
        M._asAutoStealConn = nil
    end
end

function M.setStealPreset(value)
    value = tostring(value)
    if M.NORMAL_STEAL_PERCENT[value] then
        M.normalStealVersion = value
    end
end


-- ============================================================
-- ANTI DIE & FLING (from Anti-Sammy)
-- ============================================================
M.antiDieEnabled = false
M.antiDieFlingEnabled = false
M._antiDieConns = {}

local AntiDie = {
    enabled = false,
    loop = nil,
    healthConn = nil,
    charConn = nil,
    lastHealTime = 0,
    invincibleUntil = 0,
    config = {
        healthThreshold = 50,
        invincibilityFrames = 0.75,
        ragdollProtection = true,
        autoRevive = true,
    },
}

local AntiFlingShield = {
    enabled = false,
    loop = nil,
    velocityThreshold = 80,
}

AntiDie.superHeal = function(hum)
    if not hum or not hum.Parent then return end
    local maxHealth = hum.MaxHealth or 100
    if maxHealth <= 0 then maxHealth = 100 end
    pcall(function()
        hum.Health = maxHealth
        if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end
    end)
    AntiDie.invincibleUntil = tick() + AntiDie.config.invincibilityFrames
    AntiDie.lastHealTime = tick()
    pcall(function()
        local char = hum.Parent
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local name = child.Name:lower()
                if name:find("health") or name:find("hp") or name:find("life") then
                    child.Value = maxHealth
                end
            elseif child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end)
end

AntiDie.autoRevive = function()
    if not AntiDie.config.autoRevive then return end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health > 0 then return end
    AntiDie.superHeal(hum)
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end)
    if root then
        pcall(function()
            root.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
            root.AssemblyLinearVelocity = Vector3.zero
        end)
    end
end

AntiDie.preventDamage = function(root, hum)
    if not hum then return end
    if hum.Health < (hum.MaxHealth or 100) then AntiDie.superHeal(hum) end
    if tick() < AntiDie.invincibleUntil and hum.Health < (hum.MaxHealth or 100) then
        hum.Health = hum.MaxHealth or 100
    end
    if AntiDie.config.ragdollProtection then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            AntiDie.superHeal(hum)
            if root then
                pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
            end
        end
    end
    if hum.Health <= 0 then
        AntiDie.superHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then
            pcall(function()
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
                root.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end
end

AntiDie.attachHealth = function(char)
    if AntiDie.healthConn then
        AntiDie.healthConn:Disconnect()
        AntiDie.healthConn = nil
    end
    local hum = char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3))
    if not hum then return end
    AntiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not AntiDie.enabled then return end
        if hum.Health < (hum.MaxHealth or 100) then AntiDie.superHeal(hum) end
        if hum.Health <= 0 then AntiDie.autoRevive() end
    end)
    if hum.Health < (hum.MaxHealth or 100) then AntiDie.superHeal(hum) end
end

AntiDie.start = function()
    AntiDie.enabled = true
    if AntiDie.loop then AntiDie.loop:Disconnect() end
    AntiDie.loop = RunService.Heartbeat:Connect(function()
        if not AntiDie.enabled then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        if hum.Health <= 0 then
            AntiDie.autoRevive()
        elseif hum.Health <= AntiDie.config.healthThreshold or hum.Health < (hum.MaxHealth or 100) then
            AntiDie.superHeal(hum)
        end
        AntiDie.preventDamage(root, hum)
    end)
    if player.Character then AntiDie.attachHealth(player.Character) end
    if AntiDie.charConn then AntiDie.charConn:Disconnect() end
    AntiDie.charConn = player.CharacterAdded:Connect(function(char)
        if not AntiDie.enabled then return end
        task.wait(0.05)
        AntiDie.attachHealth(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then AntiDie.superHeal(hum) end
    end)
end

AntiDie.stop = function()
    AntiDie.enabled = false
    for _, connectionName in ipairs({"loop", "healthConn", "charConn"}) do
        local connection = AntiDie[connectionName]
        if connection then
            connection:Disconnect()
            AntiDie[connectionName] = nil
        end
    end
end

AntiFlingShield.stabilizeRoot = function(root)
    if not root or not root.Parent then return end
    local velocity
    local ok = pcall(function() velocity = root.AssemblyLinearVelocity end)
    if not ok or typeof(velocity) ~= "Vector3" then
        ok, velocity = pcall(function() return root.Velocity end)
        if not ok or typeof(velocity) ~= "Vector3" then return end
    end
    if velocity.Magnitude <= AntiFlingShield.velocityThreshold then return end
    local stabilized = Vector3.new(0, velocity.Y, 0)
    pcall(function() root.AssemblyLinearVelocity = stabilized end)
    pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
    pcall(function() root.Velocity = stabilized end)
    pcall(function() root.RotVelocity = Vector3.zero end)
end

AntiFlingShield.start = function()
    AntiFlingShield.enabled = true
    if AntiFlingShield.loop then AntiFlingShield.loop:Disconnect() end
    AntiFlingShield.loop = RunService.Heartbeat:Connect(function()
        if not AntiFlingShield.enabled then return end
        local char = player.Character
        AntiFlingShield.stabilizeRoot(char and char:FindFirstChild("HumanoidRootPart"))
    end)
end

AntiFlingShield.stop = function()
    AntiFlingShield.enabled = false
    if AntiFlingShield.loop then
        AntiFlingShield.loop:Disconnect()
        AntiFlingShield.loop = nil
    end
end

function M.enableAntiDie()
    M.antiDieEnabled = true
    M.antiDieFlingEnabled = true
    AntiDie.start()
    AntiFlingShield.start()
end

function M.disableAntiDie()
    M.antiDieEnabled = false
    M.antiDieFlingEnabled = false
    AntiDie.stop()
    AntiFlingShield.stop()
end

function M.enableAntiDieFling()
    M.enableAntiDie()
end

function M.disableAntiDieFling()
    M.disableAntiDie()
end


-- Graphics Bajos: modo de rendimiento integrado.
M.graphicsBajosEnabled = false
M._graphicsBajosConn = nil
local function applyGraphicsBajosObject(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.CastShadow = false
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.BackSurface = Enum.SurfaceType.SmoothNoOutlines
            obj.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
            obj.FrontSurface = Enum.SurfaceType.SmoothNoOutlines
            obj.LeftSurface = Enum.SurfaceType.SmoothNoOutlines
            obj.RightSurface = Enum.SurfaceType.SmoothNoOutlines
            obj.TopSurface = Enum.SurfaceType.SmoothNoOutlines
        elseif obj:IsA("PostEffect") then
            obj.Enabled = false
        elseif obj:IsA("ForceField") then
            obj:Destroy()
        end
    end)
end
function M.enableGraphicsBajos()
    M.graphicsBajosEnabled = true
    local terrain = workspace:FindFirstChildWhichIsA("Terrain")
    if terrain then
        terrain.WaterWaveSize = 0; terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0; terrain.WaterTransparency = 1
    end
    Lighting.Brightness = 2; Lighting.GlobalShadows = false
    Lighting.FogEnd = 9000000000; Lighting.FogStart = 9000000000
    for _, obj in ipairs(game:GetDescendants()) do applyGraphicsBajosObject(obj) end
    if M._graphicsBajosConn then M._graphicsBajosConn:Disconnect() end
    M._graphicsBajosConn = workspace.DescendantAdded:Connect(function(obj)
        if M.graphicsBajosEnabled then applyGraphicsBajosObject(obj) end
    end)
end
function M.disableGraphicsBajos()
    M.graphicsBajosEnabled = false
    if M._graphicsBajosConn then M._graphicsBajosConn:Disconnect(); M._graphicsBajosConn = nil end
end


local RunService2 = game:GetService("RunService")
local cherryESPState = { LineESP=false, SpeedESP=false }
local cherryESPObjects = {}
M.applyLoadedConfig = function()
    if M.stopCameraSmoothing then pcall(M.stopCameraSmoothing) end
    if M.normalizeCameraState then pcall(M.normalizeCameraState) end
    cherryESPState.LineESP = M.lineESPEnabled == true
    cherryESPState.SpeedESP = M.speedESPEnabled == true
    if M.playerESPEnabled then M.toggleESP(true) else M.toggleESP(false) end
    if M.showPlayerSpeeds then M.togglePlayerSpeeds(true) else M.togglePlayerSpeeds(false) end
    if M.autoSwitchSpeedEnabled then
        M.refreshWalkSpeedAutoSwitch()
        pcall(M.updateAutoSwitchSpeed)
    else
        M.stopWalkSpeedAutoSwitch()
    end
    M.stopManualInfJumpLoop(); M.stopHoldInfJump()
    M.infJumpMode = "hold"
    if M.infJumpEnabled then M.startHoldInfJump() end
    if M.autoLeftEnabled then pcall(M.startAutoLeft) else pcall(M.stopAutoLeft) end
    if M.autoRightEnabled then pcall(M.startAutoRight) else pcall(M.stopAutoRight) end
        if M.primeHubSkinEnabled and M.setPrimeHubSkinMode then
        pcall(M.setPrimeHubSkinMode, M.primeHubKawatanEnabled and "Kawatan" or "PrimeHub", true)
    end
    if M.primeHubMusicSelection and M.primeHubMusicSelection ~= "Off" and M.setPrimeHubMusic then
        pcall(M.setPrimeHubMusic, M.primeHubMusicSelection, true)
    end
    if M.buildMobileButtons and M.mobileButtonsEnabled then pcall(M.buildMobileButtons) end
    if M.applyFOV then pcall(M.applyFOV) end
    if M.applyCameraSensitivity then pcall(M.applyCameraSensitivity) end
    task.defer(function()
        task.wait(0.05)
        if M.normalizeCameraState then pcall(M.normalizeCameraState) end
        if M.startCameraSmoothing then pcall(M.startCameraSmoothing) end
    end)
    if M.CandyApplyCustomSky then pcall(M.CandyApplyCustomSky, M.currentSkyTheme) end
    if M.saveConfig then pcall(M.saveConfig) end
end
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
    hl.FillTransparency=1; hl.OutlineTransparency=0
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled=false; hl.Parent=workspace
    r.Highlight=hl
    local box=Instance.new("BoxHandleAdornment")
    box.Name="LineESPBox"
    box.Size=Vector3.new(3.2, 5.8, 2.2)
    box.Color3=M.currentAccent or Color3.fromRGB(58, 128, 245)
    box.Transparency=0.25
    box.AlwaysOnTop=true
    box.ZIndex=5
    box.Visible=false
    box.Parent=workspace
    r.Box=box
    local bb=Instance.new("BillboardGui")
    bb.Size=UDim2.fromOffset(150,32); bb.StudsOffset=Vector3.new(0,3.25,0)
    bb.AlwaysOnTop=true; bb.Enabled=false; bb.ResetOnSpawn=false
    bb.Parent=player:WaitForChild("PlayerGui")
    local sl=Instance.new("TextLabel",bb)
    sl.Size=UDim2.fromScale(1,1); sl.BackgroundTransparency=1; sl.Text="0.0 spd"
    sl.TextStrokeColor3=Color3.new(0,0,0); sl.TextStrokeTransparency=0
    sl.Font=Enum.Font.GothamBlack; sl.TextSize=18
    sl.TextXAlignment=Enum.TextXAlignment.Center; sl.TextYAlignment=Enum.TextYAlignment.Center
    r.Billboard=bb; r.SpeedText=sl
    if DrawingAvailable then
        local ln=Drawing.new("Line")
        ln.Visible=false; ln.Thickness=2.75; ln.Transparency=1
        r.Line=ln
    end
    cherryESPObjects[p]=r
    return r
end
Players.PlayerRemoving:Connect(function(p) cherryRemoveESP(p) end)
local function themeDarkFromAccent(accent, amount)
    amount = math.clamp(tonumber(amount) or 0.12, 0, 1)
    return Color3.new(
        math.clamp(accent.R * amount, 0, 1),
        math.clamp(accent.G * amount, 0, 1),
        math.clamp(accent.B * amount, 0, 1)
    )
end
local function isNearBlack(c, threshold)
    if typeof(c) ~= "Color3" then return false end
    threshold = threshold or 0.14
    return c.R <= threshold and c.G <= threshold and c.B <= threshold
end
M.THEME_BG_IDS = {}
function M.applyMenuBackground(index)
    local list = M.MENU_BG_IDS or M.BG_IMAGE_IDS or {}
    local n = #list
    if n < 1 then return end
    index = tonumber(index) or M.menuBgIndex or 1
    if index < 1 then index = n end
    if index > n then index = 1 end
    M.menuBgIndex = index
    local id = tostring(list[index])
    M.customBgId = id
    if M.bgImageRef and M.bgImageRef.Parent then
        -- thumb es el más fiable en ImageLabel de GUI
        local uri = string.format("rbxthumb://type=Asset&id=%s&w=768&h=432", id)
        M.bgImageRef.Image = uri
        M.bgImageRef.ImageTransparency = 1
        M.bgImageRef.ScaleType = Enum.ScaleType.Crop
        M.bgImageRef.Visible = true
        M.bgImageRef.ZIndex = 0
    end
    if M.menuBgLabel and M.menuBgLabel.Parent then
        M.menuBgLabel.Text = "image " .. tostring(index)
    end
end
function M.applyThemeBackground(themeName)
    M.applyMenuBackground(M.menuBgIndex or 1)
end

function M.savePlayerBackground()
    M._playerBgSaved = true
    M.menuBgIndex = tonumber(M.menuBgIndex) or 1
    M.customBgId = tostring((M.MENU_BG_IDS or {})[M.menuBgIndex] or M.customBgId or "")
    M.adaptThemeName = tostring(M.adaptThemeName or "BLUE")
    if M.ADAPT_THEME_COLORS and M.ADAPT_THEME_COLORS[M.adaptThemeName] then
        M.currentAccent = M.ADAPT_THEME_COLORS[M.adaptThemeName]
    end
    pcall(function() if savePrimeHubFeKlanConfig then savePrimeHubFeKlanConfig() end end)
    if M.notify then pcall(function() M.notify("Background + color guardados") end) end
end

function M.cycleMenuBackground(dir)
    local list = M.MENU_BG_IDS or M.BG_IMAGE_IDS or {}
    local n = #list
    if n < 1 then return end
    local idx = (tonumber(M.menuBgIndex) or 1) + (tonumber(dir) or 1)
    if idx < 1 then idx = n end
    if idx > n then idx = 1 end
    M.applyMenuBackground(idx)
end
M.ADAPT_THEME_COLORS = {
    PURPLE = Color3.fromRGB(160, 40, 255),
    BLUE   = Color3.fromRGB(0, 140, 255),
    PINK   = Color3.fromRGB(255, 80, 190),
    GREEN  = Color3.fromRGB(0, 200, 110),
}
M.ADAPT_THEME_ORDER = {"PURPLE","BLUE","PINK","GREEN"}
M.adaptThemeName = M.adaptThemeName or "BLUE"
M.menuBgIndex = (M.adaptThemeName == "PURPLE" and 2) or (M.adaptThemeName == "PINK" and 3) or (M.adaptThemeName == "GREEN" and 4) or 1
M.currentAccent = M.currentAccent or Color3.fromRGB(255, 120, 180)

function M.applyAdaptThemeColor(name)
    name = tostring(name or M.adaptThemeName or "BLUE"):upper()
    local tint = M.ADAPT_THEME_COLORS and M.ADAPT_THEME_COLORS[name]
    if not tint then
        name = "BLUE"
        tint = (M.ADAPT_THEME_COLORS and M.ADAPT_THEME_COLORS.BLUE) or Color3.fromRGB(58, 128, 245)
    end
    M.adaptThemeName = name
    M.currentAccent = tint

    -- Fondos oscuros derivados del color (negro/gris = casi black)
    local isDark = (name == "GREY" or name == "WHITE")
    local bgDark = Color3.fromRGB(0, 0, 0)
    local rowDark = Color3.fromRGB(10, 10, 12)
    if name == "GREY" then
        bgDark = Color3.fromRGB(12, 12, 14)
        rowDark = Color3.fromRGB(22, 22, 26)
        tint = Color3.fromRGB(120, 120, 128) -- gris visible, no negro puro
        M.currentAccent = tint
    elseif name == "WHITE" then
        tint = Color3.fromRGB(230, 230, 235)
        M.currentAccent = tint
    end

    local cherryMap = {
        PURPLE = "Purple", BLUE = "Blue", RED = "Red", PINK = "Pink",
        YELLOW = "Yellow", GREY = "Default", WHITE = "Default", FOREST = "Default",
    }
    local cherryName = cherryMap[name] or "Blue"
    CHERRY_THEMES = CHERRY_THEMES or {}
    if not CHERRY_THEMES[cherryName] then
        CHERRY_THEMES[cherryName] = { Accent = tint, AccentDim = tint, Bg = bgDark, Row = rowDark }
    end
    CHERRY_THEMES[cherryName].Accent = tint
    CHERRY_THEMES[cherryName].AccentDim = Color3.new(tint.R * 0.7, tint.G * 0.7, tint.B * 0.7)
    CHERRY_THEMES[cherryName].Bg = bgDark
    CHERRY_THEMES[cherryName].Row = rowDark
    M.colorScheme = cherryName
    M._savedTheme = cherryName
    if PrimeHubFeKlanConfig then PrimeHubFeKlanConfig.Theme = cherryName end
    pcall(function() applyAccentFromTheme() end)

    local function isPinkish(c)
        if typeof(c) ~= "Color3" then return false end
        -- detectar rosa/magenta hardcodeado
        local r, g, b = c.R * 255, c.G * 255, c.B * 255
        if r > 180 and b > 120 and g < 180 then return true end
        if r > 200 and g > 80 and g < 160 and b > 150 then return true end
        return false
    end

    local function paintAll(root)
        if not root then return end
        for _, obj in ipairs(root:GetDescendants()) do
            pcall(function()
                if obj:IsA("UIStroke") then
                    if isPinkish(obj.Color) or true then
                        obj.Color = tint
                    end
                elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    if isPinkish(obj.TextColor3) or isPinkish(obj.BackgroundColor3) then
                        if isPinkish(obj.TextColor3) then obj.TextColor3 = tint end
                        if isPinkish(obj.BackgroundColor3) then obj.BackgroundColor3 = tint end
                    end
                    local tn = string.lower(tostring(obj.Name or ""))
                    local tx = string.lower(tostring(obj.Text or ""))
                    if string.find(tn, "title") or string.find(tn, "header") or string.find(tn, "primehub")
                        or string.find(tx, "primehub") or string.find(tn, "tab") then
                        if obj:IsA("TextLabel") or (obj:IsA("TextButton") and obj.BackgroundTransparency > 0.5) then
                            obj.TextColor3 = tint
                        else
                            obj.BackgroundColor3 = tint
                            obj.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                    end
                    -- tabs Main/Speed etc
                    if string.find(tn, "tab") or string.find(tx, "main") or string.find(tx, "speed")
                        or string.find(tx, "combat") or string.find(tx, "utility") then
                        if obj.BackgroundTransparency < 0.5 then
                            obj.BackgroundColor3 = tint
                            obj.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                    end
                elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                    if isPinkish(obj.BackgroundColor3) then
                        obj.BackgroundColor3 = tint
                    end
                elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                    if isPinkish(obj.ImageColor3) then
                        obj.ImageColor3 = tint
                    end
                end
            end)
        end
    end

    pcall(function() paintAll(M.mainGui) end)
    pcall(function() paintAll(M.mainFrame) end)
    pcall(function() paintAll(M.statusGui) end)
    pcall(function() paintAll(M.pcKeyStatusGui) end)

    -- Botones móviles: fondo del color + texto blanco
    pcall(function()
        local gui = M.mobGuiRef or M.mobileButtonsGui
        if not gui then return end
        for _, holder in ipairs(gui:GetChildren()) do
            for _, d in ipairs(holder:GetDescendants()) do
                pcall(function()
                    if d:IsA("UIStroke") then
                        d.Color = Color3.fromRGB(255, 255, 255)
                    elseif d:IsA("TextLabel") or d:IsA("TextButton") then
                        d.TextColor3 = Color3.fromRGB(255, 255, 255)
                        if d:IsA("TextButton") and d.BackgroundTransparency < 1 then
                            d.BackgroundColor3 = tint
                        end
                    elseif d:IsA("Frame") or d:IsA("ImageLabel") then
                        local n = string.lower(tostring(d.Name or ""))
                        if string.find(n, "bg") or string.find(n, "none") or string.find(n, "glow") or d.BackgroundTransparency < 0.5 then
                            if d:IsA("ImageLabel") then
                                d.ImageColor3 = tint
                            else
                                d.BackgroundColor3 = tint
                            end
                        end
                    end
                    if d:IsA("UIGradient") then
                        d.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, tint),
                            ColorSequenceKeypoint.new(1, Color3.new(tint.R * 0.5, tint.G * 0.5, tint.B * 0.5)),
                        })
                    end
                end)
            end
        end
    end)

    -- refrescar paint de cada botón móvil con el acento actual
    pcall(function()
        if M.mobBtnRefs then
            for key, paintFn in pairs(M.mobBtnRefs) do
                if type(paintFn) == "function" then
                    local active = false
                    pcall(function()
                        -- conservar estado on/off si el botón lo tiene
                    end)
                    paintFn(false)
                end
            end
            -- reaplicar estados activos
            if M.autoLeftEnabled and M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(true) end
            if M.autoRightEnabled and M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(true) end
            if M.batAimbotEnabled and M.mobBtnRefs.batAimbot then M.mobBtnRefs.batAimbot(true) end
            if M.bypassAimbotEnabled and M.mobBtnRefs.tpBat then M.mobBtnRefs.tpBat(true) end
            if M.carrySpeedActive and M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(true) end
            if M.laggerModeEnabled and M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(true) end
            if M.laggerCarryActive and M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        end
    end)

    pcall(function() if savePrimeHubFeKlanConfig then savePrimeHubFeKlanConfig() end end)
    if M.notify then pcall(function() M.notify("Color: " .. name) end) end
end


function applyAccentFromTheme()
    local name = PrimeHubFeKlanConfig.Theme or M.colorScheme or M._savedTheme or "Default"
    if not CHERRY_THEMES[name] then name = "Default" end
    PrimeHubFeKlanConfig.Theme = name
    M.colorScheme = name
    M._savedTheme = name
    M.applyThemeBackground(name)
    local t = CHERRY_THEMES[name]
    local accent = t.Accent
    local dim = t.AccentDim or accent:Lerp(Color3.new(0,0,0), 0.35)
    local bg  = themeDarkFromAccent(accent, 0.10)
    local row = themeDarkFromAccent(accent, 0.18)
    local btn = themeDarkFromAccent(accent, 0.22)
    local tog = themeDarkFromAccent(accent, 0.28)
    local gradTop = themeDarkFromAccent(accent, 0.26)
    local gradBot = themeDarkFromAccent(accent, 0.08)
    CHERRY_ACCENT = accent
    UI_ACCENT = accent
    UI_ACCENT_DIM = dim
    UI_BG_DARK = bg
    UI_ROW_BG = row
    UI_BTN_BG = btn
    UI_TOGGLE_OFF = tog
    UI_TOGGLE_KNOB = Color3.fromRGB(245, 185, 225)
    UI_KNOB_ON = Color3.fromRGB(255, 235, 248)
    UI_TEXT_PRIMARY = Color3.fromRGB(255, 235, 248)
    UI_TEXT_WHITE = Color3.fromRGB(255, 235, 248)
    UI_TEXT_DIM = dim:Lerp(Color3.fromRGB(200,200,210), 0.4)
    UI_TEXT_SECTION = accent
    UI_CARD_STROKE = dim
    UI_GRAD_TOP = gradTop
    UI_GRAD_BOT = gradBot
    M.Theme = {
        Name = name,
        Accent = accent,
        AccentDim = dim,
        Bg = bg,
        Row = row,
    }
    if M.updateStealBarTheme then
        M.updateStealBarTheme()
    end
    if M.antiLagEnabled and M.enableAntiLag then
        task.defer(function()
            if M.antiLagEnabled then pcall(M.enableAntiLag) end
        if M.nukeOptimiserEnabled then pcall(M.enableNukeOptimizer) end
        if M.antiVoidEnabled then pcall(M.startAntiVoid) end
        if M.bodyLockEnabled then pcall(M.startBodyLock) end
        end)
    end
end
function M.recolorPinkToTheme(root)
    if not root then return end
    local blueMode = (M.colorScheme == "Blue")
    local pink = {
        ["255,92,180"] = Color3.fromRGB(58,128,245), ["255,105,180"] = Color3.fromRGB(58,128,245),
        ["255,140,210"] = Color3.fromRGB(40,90,180), ["255,180,225"] = Color3.fromRGB(40,90,180),
        ["150,20,95"] = Color3.fromRGB(40,90,180), ["120,20,80"] = Color3.fromRGB(40,90,180),
        ["255,235,248"] = Color3.fromRGB(220,235,255), ["255,210,210"] = Color3.fromRGB(205,225,255),
        ["255,175,175"] = Color3.fromRGB(175,215,255),
    }
    local blue = {
        ["58,128,245"] = Color3.fromRGB(255,105,180), ["40,90,180"] = Color3.fromRGB(200,80,140),
        ["220,235,255"] = Color3.fromRGB(255,235,248), ["205,225,255"] = Color3.fromRGB(255,210,210),
        ["175,215,255"] = Color3.fromRGB(255,175,175),
    }
    local function isESPObject(obj)
        local p = obj
        while p and p ~= root do
            if string.find(string.upper(p.Name or ""), "ESP", 1, true) then return true end
            p = p.Parent
        end
        return string.find(string.upper(obj.Name or ""), "ESP", 1, true) ~= nil
    end
    local function convert(obj, property)
        local ok, c = pcall(function() return obj[property] end)
        if not ok or typeof(c) ~= "Color3" then return end
        local r,g,b = math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5)
        local key = string.format("%d,%d,%d", r,g,b)
        local mapped = blueMode and pink[key] or blue[key]
        if mapped then pcall(function() obj[property] = mapped end) end
    end
    local function recolor(obj)
        if isESPObject(obj) then return end
        if obj:IsA("GuiObject") then convert(obj, "BackgroundColor3") end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then convert(obj, "TextColor3") end
        if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then convert(obj, "ImageColor3") end
        if obj:IsA("UIStroke") then convert(obj, "Color") end
    end
    recolor(root)
    for _, d in ipairs(root:GetDescendants()) do recolor(d) end
end
function M.recolorBlacksToTheme(root)
    if not root then return end
    local bg = UI_BG_DARK or themeDarkFromAccent(UI_ACCENT or Color3.new(1,1,1), 0.10)
    local row = UI_ROW_BG or themeDarkFromAccent(UI_ACCENT or Color3.new(1,1,1), 0.18)
    local btn = UI_BTN_BG or themeDarkFromAccent(UI_ACCENT or Color3.new(1,1,1), 0.22)
    local accent = UI_ACCENT or Color3.new(1,1,1)
    local dim = UI_ACCENT_DIM or accent
    local function recolor(obj)
        if obj:IsA("GuiObject") then
            local ok, col = pcall(function() return obj.BackgroundColor3 end)
            if ok and isNearBlack(col) then
                if obj:IsA("Frame") and (obj.Name == "Main" or obj.Name == "MainFrame" or obj.Size.X.Scale >= 0.9) then
                    obj.BackgroundColor3 = bg
                elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    obj.BackgroundColor3 = btn
                else
                    obj.BackgroundColor3 = row
                end
            end
        end
        if obj:IsA("UIStroke") then
            local ok, col = pcall(function() return obj.Color end)
            if ok and isNearBlack(col, 0.25) then
                obj.Color = dim
            end
        end
        if obj:IsA("UIGradient") then
            pcall(function()
                obj.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, UI_GRAD_TOP or gradTop or row),
                    ColorSequenceKeypoint.new(1, UI_GRAD_BOT or bg),
                })
            end)
        end
    end
    recolor(root)
    for _, d in ipairs(root:GetDescendants()) do
        recolor(d)
    end
end
local CHERRY_ACCENT = CHERRY_THEMES[PrimeHubFeKlanConfig.Theme].Accent
do
local _espAcc = 0
RunService2.RenderStepped:Connect(function(dt)
    if not (cherryESPState and (cherryESPState.LineESP or cherryESPState.SpeedESP)) then
        return
    end
    _espAcc = _espAcc + (dt or 0.016)
    if _espAcc < (PRIMEHUB_MOBILE and 0.12 or 0.05) then return end
    _espAcc = 0
    local cam=workspace.CurrentCamera; if not cam then return end
    local lc=player.Character
    local lr=lc and lc:FindFirstChild("HumanoidRootPart")
    -- La línea sale del pecho del personaje local.
    local lineStart=Vector2.new(cam.ViewportSize.X*0.5, cam.ViewportSize.Y*0.96)
    if lr then
        local chest = lc:FindFirstChild("UpperTorso") or lc:FindFirstChild("Torso") or lr
        local cp, cv = cam:WorldToViewportPoint(chest.Position)
        if cv and cp.Z > 0 then lineStart=Vector2.new(cp.X, cp.Y + 28) end
    end
    local liveAccent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255,255,255)
    for _,p in ipairs(M.getPlayersCached and M.getPlayersCached() or Players:GetPlayers()) do
        if p ~= player then
            local r=cherryCreateESP(p)
            local ch=p.Character
            local hum=ch and ch:FindFirstChildOfClass("Humanoid")
            local root=ch and ch:FindFirstChild("HumanoidRootPart")
            local head=ch and ch:FindFirstChild("Head")
            local alive=ch and hum and root and hum.Health>0
            if not alive then
                if r.Line then r.Line.Visible=false end
                if r.Box then r.Box.Visible=false; r.Box.Adornee=nil end
                r.Highlight.Enabled=false; r.Billboard.Enabled=false
                r.Highlight.Adornee=nil; r.Billboard.Adornee=nil
            else
                r.Highlight.Adornee=ch; r.Highlight.Enabled=cherryESPState.LineESP
                if r.Box then
                    local ext = Vector3.new(3.2, 5.8, 2.2)
                    pcall(function()
                        local measured = ch:GetExtentsSize()
                        ext = Vector3.new(math.clamp(measured.X * 1.12, 2.4, 8), math.clamp(measured.Y * 1.08, 4, 10), math.clamp(measured.Z * 1.12, 1.6, 6))
                    end)
                    r.Box.Size=ext
                    r.Box.Adornee=root
                    r.Box.Visible=cherryESPState.LineESP
                end
                r.Highlight.OutlineColor=liveAccent
                r.Highlight.FillColor=liveAccent
                r.Highlight.FillTransparency=0.85
                if r.Line then
                    local tp,tv=cam:WorldToViewportPoint(root.Position)
                    if cherryESPState.LineESP and tv and tp.Z>0 then
                        r.Line.From=lineStart; r.Line.To=Vector2.new(tp.X,tp.Y)
                        r.Line.Color=_aceEspColor(); r.Line.Thickness=1; r.Line.Visible=true
                    else r.Line.Visible=false end
                end
                if cherryESPState.SpeedESP and head then
                    r.Billboard.Adornee=head; r.Billboard.Enabled=true
                    r.SpeedText.Text=string.format("%.1f spd",cherryGetSpeed(root))
                    r.SpeedText.TextColor3=liveAccent
                else r.Billboard.Enabled=false; r.Billboard.Adornee=nil end
            end
        end
    end
end)
end
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
        savePrimeHubFeKlanConfig()
    end
end

local function accentNow()
    return M.currentAccent or Color3.fromRGB(58, 128, 245)
end
local C = {
    -- CLEAN HUB palette
    bg=Color3.fromRGB(0,0,0), bgDark=Color3.fromRGB(10,10,10), row=Color3.fromRGB(10,10,10),
    input=Color3.fromRGB(15,15,15), text=Color3.fromRGB(255,255,255), textDim=Color3.fromRGB(180,180,190),
    textMuted=Color3.fromRGB(100,100,110), white=Color3.fromRGB(255,255,255),
    divider=Color3.fromRGB(50,50,50), accent=Color3.fromRGB(180,180,190)
}
setmetatable(C, {__index = function(_, k)
    if k == "accent" or k == "divider" then return accentNow() end
    return nil
end})
local function guiCorner(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 10);c.Parent=p;return c end
local function guiSharpCorner(p) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,0);c.Parent=p;return c end
-- Live plomo (lead gray) animated borders
M._plomoStrokes = M._plomoStrokes or {}
M._plomoAnimRunning = false
local PLOMO_A = Color3.fromRGB(70, 72, 78)
local PLOMO_B = Color3.fromRGB(140, 144, 155)
local PLOMO_C = Color3.fromRGB(95, 98, 108)

local function guiStroke(p, col, t)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.fromRGB(50, 50, 50)
    s.Thickness = t or 1
    s.Transparency = 0.45
    s.Parent = p
    table.insert(M._plomoStrokes, s)
    return s
end

function M.startPlomoBorderAnim()
    if M._plomoAnimRunning then return end
    M._plomoAnimRunning = true
    task.spawn(function()
        while M._plomoAnimRunning do
            local t = tick()
            -- smooth wave between gray tones
            local wave = (math.sin(t * 5.5) + 1) * 0.5  -- fast live plomo
            local wave2 = (math.sin(t * 5.5 + 1.2) + 1) * 0.5
            local col = PLOMO_A:Lerp(PLOMO_B, wave):Lerp(PLOMO_C, wave2 * 0.35)
            local trans = 0.12 + wave * 0.28  -- visible pulse
            -- clean dead refs
            local alive = {}
            for _, s in ipairs(M._plomoStrokes or {}) do
                if s and s.Parent then
                    local curT = 0.25
                    pcall(function() curT = s.Transparency end)
                    local isMob = false
                    local flashing = false
                    pcall(function()
                        isMob = s:GetAttribute("MobBtn") == true
                        flashing = s:GetAttribute("PressFlash") == true
                    end)
                    -- don't override mobile btn strokes (they have their own active/press logic)
                    if (not isMob) and (not flashing) and curT < 0.92 then
                        pcall(function()
                            s.Color = col
                            s.Transparency = trans
                        end)
                    end
                    table.insert(alive, s)
                end
            end
            M._plomoStrokes = alive
            -- Active mobile buttons: strong live plomo pulse so ON state is obvious
            for _, s in ipairs(M._mobBtnStrokes or {}) do
                if s and s.Parent then
                    local active, flashing = false, false
                    pcall(function()
                        active = s:GetAttribute("BtnActive") == true
                        flashing = s:GetAttribute("PressFlash") == true
                    end)
                    if active and not flashing then
                        local t2 = tick() * 8
                        local w = (math.sin(t2) + 1) * 0.5
                        pcall(function()
                            s.Color = Color3.fromRGB(200, 204, 215):Lerp(Color3.fromRGB(255, 255, 255), w)
                            s.Thickness = 3.2 + w * 1.4
                            s.Transparency = 0.02 + w * 0.12
                        end)
                    end
                end
            end
            task.wait(0.06)
        end
    end)
end

function M.stopPlomoBorderAnim()
    M._plomoAnimRunning = false
end

local function tw(obj,props,ti) TweenService:Create(obj,ti or TweenInfo.new(0.12),props):Play() end
local function makeDraggable_cyber(dragTarget, moveTarget)
    moveTarget = moveTarget or dragTarget
    local dragging, dragInput, dragStart, startPos = false
    dragTarget.InputBegan:Connect(function(input)
        if M.uiLocked then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=moveTarget.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    dragTarget.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input==dragInput and dragging then
            local delta=input.Position-dragStart
            moveTarget.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end
local function uiSectionHeader(parent, text)
    local wrap=Instance.new("Frame",parent)
    wrap.Size=UDim2.new(1,0,0,32)
    wrap.BackgroundTransparency=1
    wrap.BorderSizePixel=0
    local L=Instance.new("TextLabel",wrap)
    L.Size=UDim2.new(1,-20,0,18)
    L.Position=UDim2.new(0,10,0,8)
    L.BackgroundTransparency=1
    L.Text=text:upper()
    L.TextColor3=M.currentAccent or Color3.fromRGB(180,180,190)
    L.TextSize=12
    L.Font=Enum.Font.GothamBlack
    L.TextXAlignment=Enum.TextXAlignment.Left
    L.TextStrokeColor3=Color3.fromRGB(0,0,0)
    L.TextStrokeTransparency=0.4
    local line=Instance.new("Frame",wrap)
    line.Size=UDim2.new(1,-20,0,1)
    line.Position=UDim2.new(0,10,1,-2)
    line.BackgroundColor3=M.currentAccent or Color3.fromRGB(180,180,190)
    line.BackgroundTransparency=0.5
    line.BorderSizePixel=0
    return L
end
local function uiInputRow(parent, label, value, callback)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,-8,0,42); Row.BackgroundColor3=Color3.fromRGB(8,10,12)
    Row.BackgroundTransparency=0.12; Row.BorderSizePixel=0; guiCorner(Row,12); local rowStroke=guiStroke(Row,Color3.fromRGB(255,255,255),1); rowStroke.Transparency=0.78
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(1,-80,1,0); Lb.Position=UDim2.new(0,14,0,0)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(255,255,255); Lb.TextSize=13; Lb.Font=Enum.Font.GothamBlack; Lb.TextXAlignment=Enum.TextXAlignment.Left
    Lb.TextTruncate=Enum.TextTruncate.AtEnd
    Lb.TextStrokeColor3=Color3.fromRGB(0,0,0); Lb.TextStrokeTransparency=0.25
    local BC=Instance.new("Frame",Row); BC.ZIndex=6; BC.Position=UDim2.new(1,-68,0.5,-12); BC.Size=UDim2.new(0,56,0,24)
    BC.BackgroundColor3=Color3.fromRGB(15,15,15); BC.BackgroundTransparency=0.7; BC.BorderSizePixel=0; guiCorner(BC,6); guiStroke(BC, Color3.fromRGB(50,50,50),1)
    local Box=Instance.new("TextBox",BC); Box.ZIndex=7; Box.Size=UDim2.new(1,0,1,0); Box.BackgroundTransparency=1
    Box.Text=tostring(value); Box.TextColor3=C.text; Box.TextSize=11; Box.Font=Enum.Font.GothamBold; Box.ClearTextOnFocus=false
    Box.FocusLost:Connect(function() local n=tonumber(Box.Text); if n then callback(n) else Box.Text=tostring(value) end end)
    return Row,Box
end
local function uiNumberRow(parent, label, value, min, max, callback)
    return uiInputRow(parent, label, value, function(v)
        if min and v < min then v = min end
        if max and v > max then v = max end
        callback(v)
    end)
end
local function uiToggleRow(parent, label, enabled, callback)
    -- Toggles de alto contraste (legibles sobre fondos)
    local Row=Instance.new("Frame",parent)
    Row.Size=UDim2.new(1,-8,0,42)
    Row.BackgroundColor3=Color3.fromRGB(8, 10, 12)
    Row.BackgroundTransparency=0.12
    Row.BorderSizePixel=0
    guiCorner(Row, 12)
    local rowStroke=guiStroke(Row, Color3.fromRGB(255,255,255), 1)
    rowStroke.Transparency=0.78
    local Lb=Instance.new("TextLabel",Row)
    Lb.Size=UDim2.new(1,-72,1,0)
    Lb.Position=UDim2.new(0,14,0,0)
    Lb.BackgroundTransparency=1
    Lb.Text=label
    Lb.TextColor3=Color3.fromRGB(255,255,255)
    Lb.TextSize=13
    Lb.Font=Enum.Font.GothamBlack
    Lb.TextXAlignment=Enum.TextXAlignment.Left
    Lb.TextTruncate=Enum.TextTruncate.AtEnd
    Lb.TextStrokeColor3=Color3.fromRGB(0,0,0)
    Lb.TextStrokeTransparency=0.25
    local Track=Instance.new("Frame",Row)
    Track.Name="Track"
    Track.Size=UDim2.new(0,44,0,24)
    Track.AnchorPoint=Vector2.new(1,0.5)
    Track.Position=UDim2.new(1,-12,0.5,0)
    Track.BackgroundColor3=Color3.fromRGB(45,48,55)
    Track.BackgroundTransparency=0
    Track.BorderSizePixel=0
    guiCorner(Track, 12)
    local trackStroke=Instance.new("UIStroke",Track)
    trackStroke.Name="PillStroke"
    trackStroke.Color=Color3.fromRGB(120,125,135)
    trackStroke.Thickness=1.2
    trackStroke.Transparency=0.25
    local Knob=Instance.new("Frame",Track)
    Knob.Name="Knob"
    Knob.Size=UDim2.new(0,18,0,18)
    Knob.Position=enabled and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    Knob.BackgroundColor3=Color3.fromRGB(245,245,250)
    Knob.BorderSizePixel=0
    guiCorner(Knob, 9)
    local kStroke=Instance.new("UIStroke",Knob)
    kStroke.Color=Color3.fromRGB(0,0,0)
    kStroke.Thickness=1
    kStroke.Transparency=0.55
    local Shine=Instance.new("Frame",Knob)
    Shine.Size=UDim2.new(1,-6,0,5)
    Shine.Position=UDim2.new(0,3,0,2)
    Shine.BackgroundColor3=Color3.fromRGB(255,255,255)
    Shine.BackgroundTransparency=0.55
    Shine.BorderSizePixel=0
    guiCorner(Shine, 4)
    local st=enabled==true
    local function setV(on)
        st=on
        local theme = M.currentAccent or Color3.fromRGB(0, 200, 110)
        local info = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(Knob, info, {Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play()
        TweenService:Create(Track, info, {
            BackgroundColor3 = on and theme or Color3.fromRGB(45,48,55),
            BackgroundTransparency = 0,
        }):Play()
        TweenService:Create(trackStroke, info, {
            Color = on and theme or Color3.fromRGB(120,125,135),
            Transparency = on and 0.1 or 0.25,
        }):Play()
    end
    setV(st)
    local Btn=Instance.new("TextButton",Row)
    Btn.Size=UDim2.new(1,0,1,0)
    Btn.BackgroundTransparency=1
    Btn.Text=""
    Btn.ZIndex=10
    Btn.MouseButton1Click:Connect(function()
        st=not st
        setV(st)
        if callback then callback(st) end
        savePrimeHubFeKlanConfig()
    end)
    Row.MouseEnter:Connect(function()
        TweenService:Create(Row, TweenInfo.new(0.12), {
            BackgroundColor3=Color3.fromRGB(18,22,26),
            BackgroundTransparency=0.05,
        }):Play()
    end)
    Row.MouseLeave:Connect(function()
        TweenService:Create(Row, TweenInfo.new(0.12), {
            BackgroundColor3=Color3.fromRGB(8,10,12),
            BackgroundTransparency=0.12,
        }):Play()
    end)
    return Row,setV
end

-- Expandable toggle like Anti-Sammy: main row + arrow + V1/V2 panel
local function uiExpandableVersionToggle(parent, label, enabled, versions, initialVersion, onToggle, onVersion)
    versions = versions or {"V1", "V2"}
    local selected = tostring(initialVersion or versions[1])
    local open = false
    local st = enabled == true

    local wrap = Instance.new("Frame", parent)
    wrap.Size = UDim2.new(1, 0, 0, 44)
    wrap.BackgroundTransparency = 1
    wrap.BorderSizePixel = 0
    wrap.ClipsDescendants = false

    local Row = Instance.new("Frame", wrap)
    Row.Size = UDim2.new(1, 0, 0, 44)
    Row.BackgroundColor3 = C.row
    Row.BackgroundTransparency = 0.28
    Row.BorderSizePixel = 0
    guiCorner(Row, 10)
    local rowStroke = guiStroke(Row, C.divider, 1)
    rowStroke.Transparency = 0.48

    local Lb = Instance.new("TextLabel", Row)
    Lb.Size = UDim2.new(1, -100, 1, 0)
    Lb.Position = UDim2.new(0, 12, 0, 0)
    Lb.BackgroundTransparency = 1
    Lb.Text = label
    Lb.TextColor3 = C.text
    Lb.TextSize = 13
    Lb.Font = Enum.Font.GothamMedium
    Lb.TextXAlignment = Enum.TextXAlignment.Left

    -- Arrow button (opens V1/V2)
    local Arrow = Instance.new("TextButton", Row)
    Arrow.Size = UDim2.fromOffset(28, 24)
    Arrow.Position = UDim2.new(1, -86, 0.5, -12)
    Arrow.BackgroundColor3 = C.bgDark
    Arrow.BackgroundTransparency = 0.2
    Arrow.BorderSizePixel = 0
    Arrow.Text = "▼"
    Arrow.TextColor3 = C.text
    Arrow.Font = Enum.Font.GothamBold
    Arrow.TextSize = 11
    Arrow.ZIndex = 5
    Arrow.AutoButtonColor = false
    guiCorner(Arrow, 7)
    guiStroke(Arrow, C.divider, 1)

    -- Toggle track
    local Track = Instance.new("Frame", Row)
    Track.Size = UDim2.new(0, 40, 0, 20)
    Track.Position = UDim2.new(1, -52, 0.5, -10)
    Track.BackgroundColor3 = C.bgDark
    Track.BackgroundTransparency = 0.18
    Track.BorderSizePixel = 0
    Track.ZIndex = 4
    guiCorner(Track, 10)
    guiStroke(Track, UI_ACCENT or C.divider, 1.35)

    local Knob = Instance.new("Frame", Track)
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = st and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = C.text
    Knob.BackgroundTransparency = st and 0 or 0.25
    Knob.BorderSizePixel = 0
    guiCorner(Knob, 8)

    local function setToggleVisual(on)
        st = on
        pcall(function()
            tw(Knob, {Position = on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
            tw(Knob, {BackgroundTransparency = on and 0.1 or 0.6})
        end)
    end

    local ToggleHit = Instance.new("TextButton", Track)
    ToggleHit.Size = UDim2.fromScale(1, 1)
    ToggleHit.BackgroundTransparency = 1
    ToggleHit.Text = ""
    ToggleHit.ZIndex = 6
    ToggleHit.MouseButton1Click:Connect(function()
        st = not st
        setToggleVisual(st)
        if onToggle then onToggle(st, selected) end
        savePrimeHubFeKlanConfig()
    end)

    -- Dropdown panel with V1 / V2
    local Drop = Instance.new("Frame", wrap)
    Drop.Name = "VersionDrop"
    Drop.Size = UDim2.new(1, 0, 0, 0)
    Drop.Position = UDim2.new(0, 0, 0, 46)
    Drop.BackgroundTransparency = 1
    Drop.BorderSizePixel = 0
    Drop.ClipsDescendants = true
    Drop.ZIndex = 8

    local Panel = Instance.new("Frame", Drop)
    Panel.Size = UDim2.new(1, 0, 0, 40)
    Panel.BackgroundColor3 = C.row
    Panel.BackgroundTransparency = 0.2
    Panel.BorderSizePixel = 0
    guiCorner(Panel, 10)
    local panelStroke = guiStroke(Panel, C.divider, 1)
    panelStroke.Transparency = 0.4

    local versionBtns = {}
    local function refreshVersions()
        for ver, btn in pairs(versionBtns) do
            local active = ver == selected
            btn.BackgroundTransparency = active and 0.15 or 0.55
            btn.TextColor3 = active and (UI_ACCENT or Color3.fromRGB(255, 120, 160)) or C.text
            local s = btn:FindFirstChildOfClass("UIStroke")
            if s then
                s.Transparency = active and 0.05 or 0.45
                s.Color = active and (UI_ACCENT or Color3.fromRGB(255, 120, 160)) or (C.divider or Color3.fromRGB(80, 80, 90))
                s.Thickness = active and 1.6 or 1
            end
        end
    end

    local count = #versions
    for i, ver in ipairs(versions) do
        local b = Instance.new("TextButton", Panel)
        b.Size = UDim2.new(1 / count, -8, 1, -8)
        b.Position = UDim2.new((i - 1) / count, 4, 0, 4)
        b.BackgroundColor3 = C.bgDark
        b.BackgroundTransparency = 0.55
        b.BorderSizePixel = 0
        b.Text = ver
        b.TextColor3 = C.text
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.AutoButtonColor = false
        b.ZIndex = 10
        guiCorner(b, 8)
        local bs = guiStroke(b, C.divider, 1)
        bs.Transparency = 0.45
        versionBtns[ver] = b
        b.MouseButton1Click:Connect(function()
            selected = ver
            refreshVersions()
            if onVersion then onVersion(selected, st) end
            savePrimeHubFeKlanConfig()
        end)
    end
    refreshVersions()

    local function setOpen(v)
        open = v
        Arrow.Text = open and "▲" or "▼"
        local targetH = open and 44 or 0
        wrap.Size = UDim2.new(1, 0, 0, 44 + (open and 48 or 0))
        Drop.Size = UDim2.new(1, 0, 0, open and 44 or 0)
        pcall(function()
            if TweenService then
                TweenService:Create(Drop, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, open and 44 or 0)}):Play()
            end
        end)
    end

    Arrow.MouseButton1Click:Connect(function()
        setOpen(not open)
    end)

    return wrap, setToggleVisual, function(ver)
        selected = tostring(ver)
        refreshVersions()
    end
end

local function uiActionRow(parent, label, callback)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,-8,0,42); Row.BackgroundColor3=Color3.fromRGB(8,10,12)
    Row.BackgroundTransparency=0.12; Row.BorderSizePixel=0; guiCorner(Row,12); local rowStroke=guiStroke(Row,Color3.fromRGB(255,255,255),1); rowStroke.Transparency=0.78
    local AB=Instance.new("TextButton",Row); AB.Size=UDim2.new(1,0,1,0); AB.BackgroundTransparency=1
    AB.Text=label; AB.TextColor3=Color3.fromRGB(255,255,255); AB.TextSize=13; AB.Font=Enum.Font.GothamBlack; AB.Parent=Row
    AB.MouseButton1Click:Connect(function() if callback then callback() end end)
    return Row,AB
end
local function uiChoiceRow(parent, label, options, defaultIndex, callback)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,-8,0,40); Row.BackgroundColor3=Color3.fromRGB(12,12,14)
    Row.BackgroundTransparency=0.35; Row.BorderSizePixel=0; guiCorner(Row,12); local rowStroke=guiStroke(Row,Color3.fromRGB(55,55,60),1); rowStroke.Transparency=0.4
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(1,-120,1,0); Lb.Position=UDim2.new(0,14,0,0)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(245,245,248); Lb.TextSize=12; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    Lb.TextTruncate=Enum.TextTruncate.AtEnd
    local CB=Instance.new("TextButton",Row); CB.Size=UDim2.new(0,100,0,26); CB.Position=UDim2.new(1,-112,0.5,-13)
    CB.BackgroundColor3=Color3.fromRGB(18,18,22); CB.BackgroundTransparency=0.2; CB.BorderSizePixel=0; CB.Text=tostring(options[defaultIndex or 1])
    CB.TextColor3=Color3.fromRGB(245,245,248); CB.TextSize=11; CB.Font=Enum.Font.GothamBold; guiCorner(CB,8); guiStroke(CB,Color3.fromRGB(55,55,60),1)
    local idx = defaultIndex or 1
    CB.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        CB.Text = tostring(options[idx])
        if callback then callback(options[idx]) end
        savePrimeHubFeKlanConfig()
    end)
    local function setVal(v) for i,o in ipairs(options) do if tostring(o)==tostring(v) then idx=i; CB.Text=tostring(o); break end end end
    return Row, setVal
end
local function uiKeybindRow(parent, label, kbEntry, stateGetter)
    local Row=Instance.new("Frame",parent); Row.Size=UDim2.new(1,-8,0,40); Row.BackgroundColor3=Color3.fromRGB(12,12,14)
    Row.BackgroundTransparency=0.35; Row.BorderSizePixel=0; guiCorner(Row,12); local rowStroke=guiStroke(Row,Color3.fromRGB(55,55,60),1); rowStroke.Transparency=0.4
    local Lb=Instance.new("TextLabel",Row); Lb.Size=UDim2.new(0.43,0,1,0); Lb.Position=UDim2.new(0,14,0,0)
    Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=Color3.fromRGB(245,245,248); Lb.TextSize=12; Lb.Font=Enum.Font.GothamBold; Lb.TextXAlignment=Enum.TextXAlignment.Left
    local KB=Instance.new("TextButton",Row); KB.Size=UDim2.new(0,58,0,24); KB.Position=UDim2.new(1,-174,0.5,-12)
    KB.BackgroundColor3=C.bgDark; KB.BackgroundTransparency=0.3; KB.BorderSizePixel=0
    local Status=Instance.new("TextLabel",Row); Status.Size=UDim2.new(0,82,0,24); Status.Position=UDim2.new(1,-112,0.5,-12)
    Status.BackgroundTransparency=1; Status.TextSize=10; Status.Font=Enum.Font.GothamBold; Status.TextXAlignment=Enum.TextXAlignment.Center
    local function updateText()
        if type(kbEntry) == "table" and kbEntry.kb then
            KB.Text = tostring(kbEntry.kb.Name)
        else
            KB.Text = "None"
        end
    end
    local function updateStatus()
        local enabled = stateGetter and stateGetter() == true
        Status.Text = enabled and "ACTIVADO" or "APAGADO"
        Status.TextColor3 = enabled and Color3.fromRGB(110, 255, 170) or Color3.fromRGB(190, 165, 185)
    end
    local ClearBtn=Instance.new("TextButton",Row); ClearBtn.Size=UDim2.new(0,24,0,24); ClearBtn.Position=UDim2.new(1,-26,0.5,-12)
    ClearBtn.BackgroundColor3=C.bgDark; ClearBtn.BackgroundTransparency=0.3; ClearBtn.BorderSizePixel=0
    ClearBtn.Text="X"; ClearBtn.TextColor3=Color3.fromRGB(255, 120, 200); ClearBtn.TextSize=11; ClearBtn.Font=Enum.Font.GothamBold
    guiCorner(ClearBtn,6); guiStroke(ClearBtn,C.divider,1)
    ClearBtn.MouseButton1Click:Connect(function()
        if type(kbEntry) == "table" then kbEntry.kb = nil end
        updateText()
        if M.saveConfig then M.saveConfig() end
        if M.notify then M.notify(label .. " cleared") end
    end)
    updateText(); updateStatus()
    KB.TextColor3=C.text; KB.TextSize=10; KB.Font=Enum.Font.GothamBold; guiCorner(KB,6); guiStroke(KB,C.divider,1)
    KB.MouseButton1Click:Connect(function()
        KB.Text = "..."
        local conn
        conn = UIS.InputBegan:Connect(function(inp, gpe)
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                if inp.KeyCode == Enum.KeyCode.Escape then
                    if type(kbEntry) == "table" then kbEntry.kb = nil end
                else
                    if type(kbEntry) == "table" then kbEntry.kb = inp.KeyCode end
                end
                updateText()
                if M.saveConfig then M.saveConfig() end
                conn:Disconnect()
            end
        end)
    end)
    task.spawn(function()
        while Row.Parent do
            updateStatus()
            task.wait(0.2)
        end
    end)
    return Row
end
function M.buildPCKeyStatusPanel()
    if M.pcKeyStatusGui then pcall(function() M.pcKeyStatusGui:Destroy() end) end
    local pg = player:FindFirstChildOfClass("PlayerGui")
    if not pg then return end
    local gui = Instance.new("ScreenGui")
    gui.Name = "PrimeHubPCKeyStatus"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 998
    gui.IgnoreGuiInset = true
    gui.Parent = pg
    M.pcKeyStatusGui = gui

    local panel = Instance.new("Frame")
    panel.Name = "PCKeyStatusPanel"
    panel.Size = UDim2.fromOffset(280, 437)
    local savedPanelPos = M.pcKeyPanelPosition
    if type(savedPanelPos) == "table" and type(savedPanelPos.x) == "number" and type(savedPanelPos.y) == "number" then
        panel.Position = UDim2.new(savedPanelPos.x, savedPanelPos.ox or 0, savedPanelPos.y, savedPanelPos.oy or 0)
    else
        panel.Position = UDim2.new(1, -298, 0, 86)
    end
    panel.BackgroundColor3 = Color3.fromRGB(10, 22, 45)
    panel.BackgroundTransparency = 1
    panel.BorderSizePixel = 0
    panel.Parent = gui
    guiCorner(panel, 36)
    guiStroke(panel, Color3.fromRGB(55, 150, 255), 1.4)
    local panelImage = Instance.new("ImageLabel")
    panelImage.Name = "HalloweenBackgroundImage"
    panelImage.Size = UDim2.new(1, 0, 1, 0)
    panelImage.Position = UDim2.fromOffset(0, 0)
    panelImage.BackgroundTransparency = 1
    panelImage.Image = "rbxassetid://131828154911144"
    panelImage.ImageTransparency = 0
    panelImage.ScaleType = Enum.ScaleType.Crop
    panelImage.ZIndex = 0
    panelImage.Parent = panel
    guiCorner(panelImage, 36)
    local panelShade = Instance.new("Frame")
    panelShade.Size = UDim2.new(1, 0, 1, 0)
    panelShade.BackgroundColor3 = Color3.fromRGB(3, 15, 34)
    panelShade.BackgroundTransparency = 0.42
    panelShade.BorderSizePixel = 0
    panelShade.ZIndex = 1
    panelShade.Parent = panel
    guiCorner(panelShade, 36)
    local panelScale = Instance.new("UIScale")
    panelScale.Scale = math.clamp(tonumber(M.pcKeyPanelScale) or 1, 0.65, 1.5)
    panelScale.Parent = panel
    M.pcKeyPanelScaleRef = panelScale

    local title = Instance.new("TextButton")
    title.Size = UDim2.new(1, -20, 0, 36)
    title.Position = UDim2.fromOffset(10, 0)
    title.BackgroundTransparency = 1
    title.Text = "prime hub"
    title.TextColor3 = Color3.fromRGB(235, 247, 255)
    title.TextStrokeColor3 = Color3.fromRGB(55, 150, 255)
    title.TextStrokeTransparency = 0.25
    title.TextSize = 21
    title.Font = Enum.Font.Fantasy
    title.AutoButtonColor = false
    title.Active = true
    title.ZIndex = 10
    title.Parent = panel
    local dripData = {{x = 0.31, y = 31, s = 8}, {x = 0.50, y = 33, s = 5}, {x = 0.67, y = 31, s = 7}}
    for _, d in ipairs(dripData) do
        local drip = Instance.new("Frame")
        drip.Size = UDim2.fromOffset(d.s, d.s + 5)
        drip.Position = UDim2.new(d.x, 0, 0, d.y)
        drip.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
        drip.BorderSizePixel = 0
        drip.ZIndex = 9
        drip.Parent = panel
        guiCorner(drip, d.s)
    end

    local dragging = false
    local dragStart = nil
    local panelStart = nil
    local dragInput = nil
    local function updatePanelPosition(input)
        if not dragging or not dragStart or not panelStart then return end
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(panelStart.X.Scale, panelStart.X.Offset + delta.X, panelStart.Y.Scale, panelStart.Y.Offset + delta.Y)
    end
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            panelStart = panel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput then updatePanelPosition(input) end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            local p = panel.Position
            M.pcKeyPanelPosition = {x = p.X.Scale, y = p.Y.Scale, ox = p.X.Offset, oy = p.Y.Offset}
            pcall(savePrimeHubFeKlanConfig)
        end
    end)

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -18, 0, 1)
    line.Position = UDim2.fromOffset(9, 35)
    line.BackgroundColor3 = Color3.fromRGB(55, 150, 255)
    line.BorderSizePixel = 0
    line.Parent = panel

    local list = Instance.new("ScrollingFrame")
    list.Name = "PCKeyRows"
    list.Position = UDim2.fromOffset(9, 41)
    list.Size = UDim2.new(1, -18, 1, -48)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 0
    list.ScrollingEnabled = false
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.Parent = panel

    local entries = {
        {"TP Bat", "BatTP", function() return M.bypassAimbotEnabled == true end},
        {"Bat Aimbot", "AutoBat", function() return M.autoBatEnabled == true end},
        {"Drop Brainrot", "DropBrainrot", function() return M.dropActive == true end},
        {"Auto Left", "AutoLeft", function() return M.autoLeftEnabled == true end},
        {"Auto Right", "AutoRight", function() return M.autoRightEnabled == true end},
        {"Insta Reset", "InstaReset", function() return M.instaResetBusy == true end},
        {"Hide GUI", "GuiHide", function() return false end},
        {"Carry Speed", "SpeedNormal", function() return M.manualCarryActive == true or M.carrySpeedActive == true end},
        {"Lagger Carry", "LaggerCarry", function() return M.laggerCarryActive == true end},
        {"Lagger Speed", "SpeedLagger", function() return M.speedProfile == "Lagger" and M.carrySpeedActive == true end},
        {"Lagger Mode", "LaggerToggle", function() return M.laggerModeEnabled == true end},
        {"Custom Speed", "SpeedCustom", function() return M.speedProfile == "Custom" and M.carrySpeedActive == true end},
    }
    local rows = {}
    for i, item in ipairs(entries) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -4, 0, 28)
        row.Position = UDim2.fromOffset(2, 2 + (i - 1) * 31)
        row.BackgroundTransparency = 1
                row.Visible = false
        row.Parent = list
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.52, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = item[1]
        label.TextColor3 = Color3.fromRGB(255, 235, 248)
        label.TextSize = 11
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row

        local key = Instance.new("TextLabel")
        key.Size = UDim2.new(0, 42, 1, 0)
        key.Position = UDim2.new(0.52, 0, 0, 0)
        key.BackgroundTransparency = 1
        key.TextColor3 = Color3.fromRGB(220, 205, 220)
        key.TextSize = 10
        key.Font = Enum.Font.GothamBold
        key.TextXAlignment = Enum.TextXAlignment.Center
        key.Parent = row

        local status = Instance.new("TextLabel")
        status.Size = UDim2.new(0, 82, 1, 0)
        status.Position = UDim2.new(1, -82, 0, 0)
        status.BackgroundTransparency = 1
        status.TextSize = 10
        status.Font = Enum.Font.GothamBold
        status.TextXAlignment = Enum.TextXAlignment.Right
        status.Parent = row
        rows[i] = {row = row, key = key, status = status, item = item}
    end

    task.spawn(function()
        while gui.Parent do
            local visibleCount = 0
            for _, r in ipairs(rows) do
                local entry = M.KB and M.KB[r.item[2]]
                local hasKey = entry and entry.kb ~= nil
                r.row.Visible = hasKey == true
                if hasKey then
                    visibleCount = visibleCount + 1
                    r.row.Position = UDim2.fromOffset(2, 2 + (visibleCount - 1) * 31)
                    r.key.Text = "[" .. tostring(entry.kb.Name) .. "]"
                    local active = r.item[3]() == true
                    r.status.Text = active and "ACTIVADO" or "APAGADO"
                    r.status.TextColor3 = active and Color3.fromRGB(110, 255, 170) or Color3.fromRGB(190, 165, 185)
                end
            end
            panel.Size = UDim2.fromOffset(280, math.clamp(57 + visibleCount * 31, 100, 437))
            task.wait(0.2)
        end
    end)
end

function M.applyToggleLayoutPos()
    -- Fixed: tabs under title (High). Kept for compatibility.
end

function M.buildGui()
    applyAccentFromTheme()
    M.clearPersistentConns()
    for _,n in ipairs({"MoveeDuels","Cherry_Menu","K7HubGUI","VantaHubUI","VynxxHubUI","VynxHubUI","PrimeHubUI","prime hub","CLEAN HUB","BLACK HUB","BloodHounds","AceDuelsAdaptReconstruct","RXZHub"}) do
        local cg=game:GetService("CoreGui")
        local old=cg:FindFirstChild(n); if old then old:Destroy() end
        local pg=player:FindFirstChild("PlayerGui")
        if pg then local o=pg:FindFirstChild(n); if o then o:Destroy() end end
    end
    local PlayerGui = player:WaitForChild("PlayerGui")
    local GuiHub = Instance.new("ScreenGui")
    GuiHub.Name = "PrimeHubUI"
    GuiHub.ResetOnSpawn = false
    GuiHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GuiHub.DisplayOrder = 999
    GuiHub.Parent = PlayerGui
    if _G.PrimeHubIntroActive then
        GuiHub.Enabled = false
        _G.PrimeHubIntroDoneCallbacks = _G.PrimeHubIntroDoneCallbacks or {}
        table.insert(_G.PrimeHubIntroDoneCallbacks, function()
            if GuiHub and GuiHub.Parent then GuiHub.Enabled = true end
        end)
    else
        GuiHub.Enabled = true
    end
    M.mainGui = GuiHub
    local Outer = Instance.new("Frame")
    Outer.Name = "Outer"
    Outer.Size = UDim2.new(0, 330, 0, 480)
    Outer.Position = UDim2.new(0, 20, 0, 2)
    Outer.BackgroundTransparency = 1
    Outer.BorderSizePixel = 0
    Outer.ClipsDescendants = true
    Outer.Parent = GuiHub
    M.mainFrame = Outer
    local OuterScale = Instance.new("UIScale")
    OuterScale.Scale = M.uiScale or 0.8
    OuterScale.Parent = Outer
    M.uiScaleRef = OuterScale
    local Inner = Instance.new("Frame")
    Inner.Name = "Inner"
    Inner.ClipsDescendants = true
    Inner.Size = UDim2.new(1, 0, 1, 0)
    Inner.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Inner.BackgroundTransparency = 1
    Inner.BorderSizePixel = 0
    Inner.Parent = Outer
    guiCorner(Inner, 18)
    guiStroke(Inner, Color3.fromRGB(50,50,50), 1)
    if M.startPlomoBorderAnim then M.startPlomoBorderAnim() end
    local BgCont = Instance.new("Frame")
    BgCont.Name = "BackgroundContainer"
    BgCont.Size = UDim2.new(1, 0, 1, 0)
    BgCont.BackgroundTransparency = 1
    BgCont.ZIndex = 0
    BgCont.Parent = Inner
    local BgGrad = Instance.new("Frame")
    BgGrad.Name = "BgGrad"
    BgGrad.Size = UDim2.new(1, 0, 1, 0)
    BgGrad.BackgroundColor3 = C.bgDark
    BgGrad.BorderSizePixel = 0
    BgGrad.ZIndex = 0
    BgGrad.Parent = BgCont
    guiCorner(BgGrad, 18)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(4,4,4)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(7,7,7)), ColorSequenceKeypoint.new(1, Color3.fromRGB(4,4,4))})
    grad.Rotation = 135
    grad.Parent = BgGrad
    local initialBgId = tostring(M.customBgId or "131828154911144")
    if initialBgId == "0" then initialBgId = "131828154911144" end
    local BgImg = Instance.new("ImageLabel")
    BgImg.Name = "BackgroundImage"
    BgImg.Size = UDim2.new(1, 0, 1, 0)
    BgImg.BackgroundTransparency = 1
    do
        local _id = (M.MENU_BG_IDS and M.MENU_BG_IDS[M.menuBgIndex or 1]) or M.customBgId or "139563268403340"
        BgImg.Image = string.format("rbxthumb://type=Asset&id=%s&w=768&h=432", tostring(_id))
        BgImg.Visible = true
    end
    BgImg.ScaleType = Enum.ScaleType.Crop
    BgImg.ImageTransparency = 0
    BgImg.ZIndex = 0
    BgImg.Parent = BgCont
    guiCorner(BgImg, 18)
    BgImg.ImageTransparency = 1
    local pumpkinBackdrop = Instance.new("TextLabel")
    pumpkinBackdrop.Name = "HalloweenPumpkinBackdrop"
    pumpkinBackdrop.Size = UDim2.new(1.35, 0, 1.35, 0)
    pumpkinBackdrop.Position = UDim2.new(0.5, 0, 0.56, 0)
    pumpkinBackdrop.AnchorPoint = Vector2.new(0.5, 0.5)
    pumpkinBackdrop.BackgroundTransparency = 1
    pumpkinBackdrop.Text = "🎃"
    pumpkinBackdrop.TextColor3 = Color3.fromRGB(255, 116, 22)
    pumpkinBackdrop.TextTransparency = 0.18
    pumpkinBackdrop.TextStrokeColor3 = Color3.fromRGB(74, 8, 92)
    pumpkinBackdrop.TextStrokeTransparency = 0.1
    pumpkinBackdrop.Font = Enum.Font.GothamBlack
    pumpkinBackdrop.TextScaled = true
    pumpkinBackdrop.ZIndex = 1
    pumpkinBackdrop.Parent = BgCont
    local pumpkinGlow = Instance.new("Frame")
    pumpkinGlow.Name = "HalloweenPumpkinShade"
    pumpkinGlow.Size = UDim2.fromScale(1, 1)
    pumpkinGlow.BackgroundColor3 = Color3.fromRGB(18, 5, 25)
    pumpkinGlow.BackgroundTransparency = 0.38
    pumpkinGlow.BorderSizePixel = 0
    pumpkinGlow.ZIndex = 0
    pumpkinGlow.Parent = BgCont
    guiCorner(pumpkinGlow, 18)
    M.bgImageRef = BgImg
    task.defer(function()
        if M.applyMenuBackground then M.applyMenuBackground(M.menuBgIndex or 1) end
    end)
    local HF = Instance.new("Frame")
    HF.Name = "HeaderFrame"
    HF.Size = UDim2.new(1, 0, 0, 70)
    HF.BackgroundTransparency = 1
    HF.BorderSizePixel = 0
    HF.Parent = Inner
    HF.ZIndex = 2
    makeDraggable_cyber(HF, Outer)
    -- Título texto estilo grafiti PRIMEHUB (bordes + hover + izquierda)
    local TL = Instance.new("TextLabel")
    TL.Name = "PrimeHubTitleLogo"
    TL.Position = UDim2.new(0, 8, 0, 0)
    TL.Size = UDim2.new(0, 200, 0, 66)
    TL.BackgroundTransparency = 1
    TL.BorderSizePixel = 0
    TL.Text = "prime hub"
    TL.Font = Enum.Font.LuckiestGuy
    TL.TextSize = 60
    TL.TextXAlignment = Enum.TextXAlignment.Left
    TL.TextYAlignment = Enum.TextYAlignment.Center
    TL.TextColor3 = M.currentAccent or Color3.fromRGB(255, 255, 255)
    TL.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TL.TextStrokeTransparency = 0
    TL.ZIndex = 30
    TL.Parent = HF
    -- Capas de borde (outline grueso)
    local function makeOutline(ox, oy, z)
        local o = Instance.new("TextLabel")
        o.Name = "PrimeHubTitleOutline"
        o.Position = UDim2.new(0, 8 + ox, 0, oy)
        o.Size = UDim2.new(0, 200, 0, 66)
        o.BackgroundTransparency = 1
        o.Text = "prime hub"
        o.Font = Enum.Font.LuckiestGuy
        o.TextSize = 60
        o.TextXAlignment = Enum.TextXAlignment.Left
        o.TextYAlignment = Enum.TextYAlignment.Center
        o.TextColor3 = Color3.fromRGB(0, 0, 0)
        o.TextStrokeTransparency = 1
        o.TextTransparency = 0.05
        o.ZIndex = z
        o.Parent = HF
        return o
    end
    local outlines = {
        makeOutline(-2, -2, 28), makeOutline(2, -2, 28),
        makeOutline(-2, 2, 28), makeOutline(2, 2, 28),
        makeOutline(-3, 0, 28), makeOutline(3, 0, 28),
        makeOutline(0, -3, 28), makeOutline(0, 3, 28),
    }
    -- Hover suave sobre el título
    local hit = Instance.new("TextButton")
    hit.Name = "PrimeHubTitleHit"
    hit.Position = UDim2.new(0, 4, 0, 0)
    hit.Size = UDim2.new(0, 210, 0, 66)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.ZIndex = 31
    hit.Parent = HF
    local hoverTween = nil
    local function tweenTitle(props, t)
        if hoverTween then pcall(function() hoverTween:Cancel() end) end
        hoverTween = TweenService:Create(TL, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
        hoverTween:Play()
    end
    hit.MouseEnter:Connect(function()
        local c = M.currentAccent or Color3.fromRGB(255, 255, 255)
        local bright = Color3.new(
            math.min(1, c.R * 1.25 + 0.08),
            math.min(1, c.G * 1.25 + 0.08),
            math.min(1, c.B * 1.25 + 0.08)
        )
        tweenTitle({TextColor3 = bright, TextSize = 64}, 0.16)
        for _, o in ipairs(outlines) do
            TweenService:Create(o, TweenInfo.new(0.16), {TextSize = 64}):Play()
        end
    end)
    hit.MouseLeave:Connect(function()
        local c = M.currentAccent or Color3.fromRGB(255, 255, 255)
        tweenTitle({TextColor3 = c, TextSize = 60}, 0.2)
        for _, o in ipairs(outlines) do
            TweenService:Create(o, TweenInfo.new(0.2), {TextSize = 60}):Play()
        end
    end)
    M._titleLogoLabel = TL
    M._titleLogoOutlines = outlines
    local function refreshTitleColor()
        local c = M.currentAccent or Color3.fromRGB(255, 255, 255)
        if M._titleLogoLabel and M._titleLogoLabel.Parent then
            M._titleLogoLabel.TextColor3 = c
        end
    end
    M.refreshTitleColor = refreshTitleColor
    task.defer(refreshTitleColor)
    local ML = Instance.new("TextLabel")
    ML.Position = UDim2.new(0, 14, 0, 32)
    ML.Size = UDim2.new(0, 200, 0, 14)
    ML.BackgroundTransparency = 1
    ML.Text = ""
    ML.TextColor3 = C.textDim
    ML.TextSize = 10
    ML.Font = Enum.Font.GothamBold
    ML.TextXAlignment = Enum.TextXAlignment.Left
    ML.Parent = HF
    ML.ZIndex = 3
    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0, 55, 0, 28)
    LockBtn.Position = UDim2.new(1, -98, 0, 8)
    LockBtn.BackgroundColor3 = C.bgDark
    LockBtn.BorderSizePixel = 0
    LockBtn.Text = M.uiLocked and "Lock" or "Unlock"
    LockBtn.TextColor3 = C.text
    LockBtn.Font = Enum.Font.GothamBold
    LockBtn.TextSize = 10
    LockBtn.ZIndex = 5
    LockBtn.Parent = HF
    guiCorner(LockBtn, 8)
    guiStroke(LockBtn, C.divider, 1)
    LockBtn.MouseButton1Click:Connect(function()
        M.uiLocked = not M.uiLocked
        LockBtn.Text = M.uiLocked and "Lock" or "Unlock"
        if M.saveConfig then M.saveConfig() end
        if M.notify then M.notify("UI " .. (M.uiLocked and "Locked" or "Unlocked")) end
    end)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -38, 0, 8)
    CloseBtn.BackgroundColor3 = C.bgDark
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "-"
    CloseBtn.TextColor3 = C.text
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 22
    CloseBtn.ZIndex = 5
    CloseBtn.Parent = HF
    guiCorner(CloseBtn, 8)
    guiStroke(CloseBtn, C.divider, 1)
    local MiniBtn = Instance.new("TextButton")
    local mobileEntry = UIS.TouchEnabled and not UIS.KeyboardEnabled
    -- ADAPT-style pill: black capsule + bold white "prime hub"
    MiniBtn.Size = mobileEntry and UDim2.new(0, 88, 0, 30) or UDim2.new(0, 92, 0, 28)
    MiniBtn.Position = mobileEntry and UDim2.new(0, 14, 0, 60) or Outer.Position
    MiniBtn.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    MiniBtn.BackgroundTransparency = 0.05
    MiniBtn.BorderSizePixel = 0
    MiniBtn.Text = "prime hub"
    MiniBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
    MiniBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    MiniBtn.TextStrokeTransparency = 0.55
    MiniBtn.Font = Enum.Font.GothamBlack
    MiniBtn.TextSize = mobileEntry and 13 or 12
    MiniBtn.Active = true
    MiniBtn.AutoButtonColor = false
    MiniBtn.ZIndex = 1000
    MiniBtn.Visible = true
    MiniBtn.Parent = GuiHub
    guiCorner(MiniBtn, 999)
    local miniStroke = guiStroke(MiniBtn, Color3.fromRGB(40, 40, 45), 1)
    if miniStroke then miniStroke.Transparency = 0.35 end
    makeDraggable_cyber(MiniBtn, MiniBtn)
    MiniBtn.MouseEnter:Connect(function()
        TweenService:Create(MiniBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(22, 22, 26)}):Play()
    end)
    MiniBtn.MouseLeave:Connect(function()
        TweenService:Create(MiniBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(8, 8, 10)}):Play()
    end)
    local openingGui = false
    local function playSmallBubbleOpen()
        local bubbleLayer = Instance.new("Frame")
        bubbleLayer.Name = "PrimeHubOpenBubbles"
        bubbleLayer.BackgroundTransparency = 1
        bubbleLayer.Size = UDim2.fromScale(1, 1)
        bubbleLayer.ZIndex = 40
        bubbleLayer.Parent = Outer
        local points = {
            {0.28, 0.32, 3}, {0.48, 0.24, 4}, {0.68, 0.36, 3},
            {0.36, 0.58, 4}, {0.62, 0.62, 3}, {0.50, 0.46, 5}
        }
        for _, point in ipairs(points) do
            local b = Instance.new("Frame")
            b.AnchorPoint = Vector2.new(0.5, 0.5)
            b.Position = UDim2.fromScale(point[1], point[2])
            b.Size = UDim2.fromOffset(point[3], point[3])
            b.BackgroundColor3 = M.currentAccent or Color3.fromRGB(58, 128, 245)
            b.BackgroundTransparency = 0.08
            b.BorderSizePixel = 0
            b.ZIndex = 41
            b.Parent = bubbleLayer
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = b
            local st = Instance.new("UIStroke")
            st.Color = Color3.fromRGB(255, 190, 230)
            st.Thickness = 1
            st.Parent = b
            TweenService:Create(b, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(point[3] + 9, point[3] + 9),
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(st, TweenInfo.new(0.32), {Transparency = 1}):Play()
        end
        task.delay(0.38, function()
            if bubbleLayer and bubbleLayer.Parent then bubbleLayer:Destroy() end
        end)
    end
    local function showGui()
        if openingGui then return end
        openingGui = true
        local targetScale = M.uiScale or 0.8
        OuterScale.Scale = targetScale * 0.70
        local targetPosition = Outer.Position
        Outer.Position = UDim2.new(0, -math.max(Outer.AbsoluteSize.X, 380) - 18, targetPosition.Y.Scale, targetPosition.Y.Offset)
        Outer.Visible = true
        MiniBtn.Visible = false
        playSmallBubbleOpen()
        M.menuOpen = true
        local openTween = TweenService:Create(Outer, TweenInfo.new(0.52, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = targetPosition})
        local scaleTween = TweenService:Create(OuterScale, TweenInfo.new(0.44, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = targetScale})
        openTween:Play()
        scaleTween:Play()
        openTween.Completed:Wait()
        openingGui = false
        pcall(savePrimeHubFeKlanConfig)
    end
    local function hideGui()
        if openingGui then return end
        openingGui = true
        local currentScale = OuterScale.Scale
        local restingPosition = Outer.Position
        local wallPosition = UDim2.new(0, -math.max(Outer.AbsoluteSize.X, 380) - 18, restingPosition.Y.Scale, restingPosition.Y.Offset)
        local closeTween = TweenService:Create(Outer, TweenInfo.new(0.36, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = wallPosition})
        local scaleTween = TweenService:Create(OuterScale, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = (M.uiScale or 0.8) * 0.70})
        closeTween:Play()
        scaleTween:Play()
        closeTween.Completed:Wait()
        Outer.Visible = false
        MiniBtn.Visible = true
        Outer.Position = restingPosition
        OuterScale.Scale = currentScale
        M.menuOpen = false
        openingGui = false
        pcall(savePrimeHubFeKlanConfig)
    end
    M._showGuiWithBubble = showGui
    M._hideGuiWithBubble = hideGui
    CloseBtn.MouseButton1Click:Connect(hideGui)
    MiniBtn.MouseButton1Click:Connect(showGui)
    local function applyResponsiveLayout()
        local camera=workspace.CurrentCamera
        if not camera or not camera.ViewportSize then return end
        local viewport=camera.ViewportSize; local vw,vh=viewport.X,viewport.Y
        local mobile=UIS.TouchEnabled and not UIS.KeyboardEnabled
        local margin=mobile and 8 or 12
        local availableW=math.max(1,vw-(margin*2))
        local availableH=math.max(1,vh-(margin*2))
        local fitScale=math.min(availableW/320,availableH/480)
        local minScale=mobile and 0.38 or 0.55
        local responsiveScale=math.clamp(fitScale,minScale,1)
        OuterScale.Scale=math.clamp(math.min(tonumber(M.uiScale) or 0.8,responsiveScale),minScale,1)
        local scaledW=320*OuterScale.Scale; local scaledH=480*OuterScale.Scale
        local px=margin; local py=math.max(margin,(vh-scaledH)/2)
        Outer.Position=UDim2.new(0,px,0,py-15)
        if mobileEntry and MiniBtn and MiniBtn.Parent then
            local bx=math.clamp(14,8,math.max(8,vw-100-8)); local by=math.clamp(60,8,math.max(8,vh-32-8))
            MiniBtn.Position=UDim2.new(0,bx,0,by)
        elseif MiniBtn and MiniBtn.Parent and not M.menuOpen then
            MiniBtn.Position=Outer.Position
        end
    end
    applyResponsiveLayout()
    local cameraForResize=workspace.CurrentCamera
    if cameraForResize then cameraForResize:GetPropertyChangedSignal("ViewportSize"):Connect(applyResponsiveLayout) end
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        local newCamera=workspace.CurrentCamera
        if newCamera then newCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyResponsiveLayout); task.defer(applyResponsiveLayout) end
    end)
    local LeftPanel = Instance.new("Frame")
    LeftPanel.Name = "LeftPanel"
    LeftPanel.Size = UDim2.new(0, 100, 1, -118)
    LeftPanel.Position = UDim2.new(0, 0, 0, 63)
    LeftPanel.BackgroundColor3 = C.bgDark
    LeftPanel.BackgroundTransparency = 0.5
    LeftPanel.BorderSizePixel = 0
    LeftPanel.Parent = Inner
    guiCorner(LeftPanel, 12)
    LeftPanel.ZIndex = 2
    local CatList = Instance.new("ScrollingFrame")
    CatList.Name = "CategoryList"
    CatList.Size = UDim2.new(1, 0, 1, 0)
    CatList.BackgroundTransparency = 1
    CatList.BorderSizePixel = 0
    CatList.ScrollBarThickness = 0
    CatList.CanvasSize = UDim2.new(0, 0, 0, 0)
    CatList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    CatList.Active = true
    CatList.Parent = LeftPanel
    local CatLay = Instance.new("UIListLayout")
    CatLay.SortOrder = Enum.SortOrder.LayoutOrder; CatLay.Padding = UDim.new(0, 8); CatLay.Parent = CatList
    CatLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() CatList.CanvasSize = UDim2.new(0, 0, 0, CatLay.AbsoluteContentSize.Y + 25) end)
    local CF = Instance.new("Frame")
    CF.Name = "ContentContainer"
    CF.Size = UDim2.new(1, -110, 1, -118)
    CF.Position = UDim2.new(0, 105, 0, 63)
    CF.BackgroundTransparency = 1
    CF.BorderSizePixel = 0
    CF.Parent = Inner
    local Categories = {"Speed", "Mechanics", "Visuals", "Animations", "Utility", "Keybinds"}
    local CategoryRefs = {contents={}, btnsSide={}, active="Visuals"}
    for _, name in pairs(Categories) do
        local page = Instance.new("ScrollingFrame")
        page.Name = "Page_" .. name
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = C.divider
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ScrollingEnabled = true
        page.Visible = (name == "Visuals")
        page.Parent = CF
        CategoryRefs.contents[name] = page
        local lay = Instance.new("UIListLayout")
        lay.SortOrder = Enum.SortOrder.LayoutOrder; lay.Padding = UDim.new(0, 6); lay.Parent = page
        lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8); pad.PaddingTop = UDim.new(0, 4); pad.PaddingBottom = UDim.new(0, 16); pad.Parent = page
    end
    for i, name in ipairs(Categories) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32); btn.BackgroundColor3 = C.bgDark; btn.BackgroundTransparency = 0.3
        btn.Text = name; btn.TextColor3 = (name == "Speed") and C.text or C.textMuted
        btn.Visible = name ~= "Speed" and name ~= "Mechanics"
        btn.TextSize = 10; btn.Font = Enum.Font.GothamBold; btn.BorderSizePixel = 0; btn.LayoutOrder = i; btn.Parent = CatList; guiCorner(btn, 6)
        local ind = Instance.new("Frame"); ind.Name = "indicator"; ind.Size = UDim2.new(0, 2, 0, 16); ind.Position = UDim2.new(1,-2,0.5,-8)
        ind.BackgroundColor3 = C.text; ind.BackgroundTransparency = (name == "Speed") and 0.3 or 1; ind.Parent = btn
        CategoryRefs.btnsSide[name] = btn
        btn.MouseButton1Click:Connect(function()
            pcall(plomoPressFlash)
            for _, f in pairs(CategoryRefs.contents) do f.Visible = false end
            CategoryRefs.contents[name].Visible = true
            CategoryRefs.active = name
            for n, b in pairs(CategoryRefs.btnsSide) do
                local ac = (n == name)
                b.TextColor3 = ac and C.text or C.textMuted; b.BackgroundTransparency = ac and 0.2 or 0.3
                local i2 = b:FindFirstChild("indicator"); if i2 then i2.BackgroundTransparency = ac and 0.3 or 1 end
            end
        end)
    end
    local PM = CategoryRefs.contents["Speed"]
    uiSectionHeader(PM, "THREE SPEEDS SYSTEM (Touch to Select)")
    local function uiSpeedCard(parent, title, keyEntry, profileName, getNorm, getSteal, setNorm, setSteal)
        local Row = Instance.new("Frame", parent)
        Row.Size = UDim2.new(1, 0, 0, 75)
        Row.BackgroundColor3 = C.row
        Row.BackgroundTransparency = 1
        Row.BorderSizePixel = 0
        guiCorner(Row, 10)
        local rowStroke=guiStroke(Row, C.divider, 1); rowStroke.Transparency=1
        local ClickBtn = Instance.new("TextButton", Row)
        ClickBtn.Size = UDim2.new(0.7, 0, 1, 0)
        ClickBtn.BackgroundTransparency = 1
        ClickBtn.Text = ""
        ClickBtn.ZIndex = 2
        local Lb = Instance.new("TextLabel", Row)
        Lb.Size = UDim2.new(0.6, 0, 0, 30)
        Lb.Position = UDim2.new(0, 12, 0, 6)
        Lb.BackgroundTransparency = 1
        Lb.Text = title
        Lb.TextColor3 = C.text
        Lb.TextSize = 13
        Lb.Font = Enum.Font.GothamBold
        Lb.TextXAlignment = Enum.TextXAlignment.Left
        local KeyBtn = Instance.new("TextButton", Row)
        KeyBtn.Size = UDim2.new(0, 70, 0, 22)
        KeyBtn.Position = UDim2.new(1, -80, 0, 8)
        KeyBtn.BackgroundColor3 = C.bgDark
        KeyBtn.BackgroundTransparency = 0.2
        KeyBtn.TextSize = 10
        KeyBtn.Font = Enum.Font.GothamBold
        KeyBtn.TextColor3 = C.text
        KeyBtn.ZIndex = 5
        guiCorner(KeyBtn, 6)
        guiStroke(KeyBtn, C.divider, 1)
        local function updateKeyText()
            if type(keyEntry) == "table" and keyEntry.kb then
                KeyBtn.Text = tostring(keyEntry.kb.Name)
            else
                KeyBtn.Text = "None"
            end
        end
        updateKeyText()
        KeyBtn.MouseButton1Click:Connect(function()
            KeyBtn.Text = "..."
            local conn
            conn = UIS.InputBegan:Connect(function(inp, gpe)
                if inp.UserInputType == Enum.UserInputType.Keyboard then
                    if inp.KeyCode == Enum.KeyCode.Escape then
                        if type(keyEntry) == "table" then keyEntry.kb = nil end
                    else
                        if type(keyEntry) == "table" then keyEntry.kb = inp.KeyCode end
                    end
                    updateKeyText()
                    if M.saveConfig then M.saveConfig() end
                    conn:Disconnect()
                end
            end)
        end)
        ClickBtn.MouseButton1Click:Connect(function()
            if M.speedProfile == profileName then
                M.carrySpeedActive = not M.carrySpeedActive
            else
                local wasCarry = M.carrySpeedActive == true or M.manualCarryActive == true or M.laggerCarryActive == true
                M.speedProfile = profileName
                -- Elegir perfil solo cambia Normal Speed (NS) y Carry Speed (CS)
                M.NS = getNorm()
                M.CS = getSteal()
                -- Lag Mode / Lag Carry NO se tocan (independientes)
                M.carrySpeedActive = wasCarry
                M.manualCarryActive = wasCarry
                if M._applySpeedNow then pcall(M._applySpeedNow) end
            end
            M.manualCarryActive = M.carrySpeedActive == true
            if M.saveConfig then M.saveConfig() end
            M.notify(profileName .. ": " .. (M.carrySpeedActive and M.CS or M.NS))
        end)
        local NormBox = Instance.new("TextBox", Row)
        NormBox.Size = UDim2.new(0, 80, 0, 24)
        NormBox.Position = UDim2.new(0, 12, 0, 42)
        NormBox.BackgroundColor3 = C.input
        NormBox.BackgroundTransparency = 0.2
        NormBox.Text = tostring(getNorm())
        NormBox.TextColor3 = C.text
        NormBox.TextSize = 11
        NormBox.Font = Enum.Font.GothamMedium
        NormBox.ZIndex = 3
        guiCorner(NormBox, 6)
        guiStroke(NormBox, C.divider, 1)
        NormBox.FocusLost:Connect(function(enter)
            local n = tonumber(NormBox.Text)
            if n then
                setNorm(n)
                if profileName == "Lagger" then
                    M.LaggerSpeedNorm = n
                    -- NO tocar M.LAGGER_SPEED (eso es solo Controls > Lagger Normal Speed)
                elseif profileName == "Normal" then
                    M.NormalSpeedNorm = n
                elseif profileName == "Custom" then
                    M.CustomSpeedNorm = n
                end
                -- Si este perfil es el seleccionado, actualiza NS (walk / auto path)
                if M.speedProfile == profileName then
                    M.NS = n
                end
                pcall(savePrimeHubFeKlanConfig)
            else
                NormBox.Text = tostring(getNorm())
            end
        end)
        local StealBox = Instance.new("TextBox", Row)
        StealBox.Size = UDim2.new(0, 80, 0, 24)
        StealBox.Position = UDim2.new(0, 105, 0, 42)
        StealBox.BackgroundColor3 = C.input
        StealBox.BackgroundTransparency = 0.2
        StealBox.Text = tostring(getSteal())
        StealBox.TextColor3 = C.text
        StealBox.TextSize = 11
        StealBox.Font = Enum.Font.GothamMedium
        StealBox.ZIndex = 3
        guiCorner(StealBox, 6)
        guiStroke(StealBox, C.divider, 1)
        StealBox.FocusLost:Connect(function(enter)
            local n = tonumber(StealBox.Text)
            if n then
                setSteal(n)
                if profileName == "Lagger" then
                    M.LaggerSpeedSteal = n
                    -- NO tocar M.LAGGER_CARRY_SPEED (eso es solo Controls > Lagger Carry Speed)
                elseif profileName == "Normal" then
                    M.NormalSpeedSteal = n
                elseif profileName == "Custom" then
                    M.CustomSpeedSteal = n
                end
                -- Si este perfil es el seleccionado, actualiza CS (Carry Speed)
                if M.speedProfile == profileName then
                    M.CS = n
                end
                pcall(savePrimeHubFeKlanConfig)
            else
                StealBox.Text = tostring(getSteal())
            end
        end)
        return Row
    end
    uiSpeedCard(PM, "Normal Speed (Default)", M.KB.SpeedNormal, "Normal", function() return M.NormalSpeedNorm end, function() return M.NormalSpeedSteal end, function(v) M.NormalSpeedNorm = v end, function(v) M.NormalSpeedSteal = v end)
    uiSpeedCard(PM, "Lagger Speed (Against lagger)", M.KB.SpeedLagger, "Lagger", function() return M.LaggerSpeedNorm end, function() return M.LaggerSpeedSteal end, function(v) M.LaggerSpeedNorm = v end, function(v) M.LaggerSpeedSteal = v end)
    uiSpeedCard(PM, "Custom Speed (Three)", M.KB.SpeedCustom, "Custom", function() return M.CustomSpeedNorm end, function() return M.CustomSpeedSteal end, function(v) M.CustomSpeedNorm = v end, function(v) M.CustomSpeedSteal = v end)
    local function uiLaggerCarryCard(parent)
        local Row = Instance.new("Frame", parent)
        Row.Size = UDim2.new(1, 0, 0, 75)
        Row.BackgroundColor3 = C.row
        Row.BackgroundTransparency = 1
        Row.BorderSizePixel = 0
        guiCorner(Row, 10)
        local rowStroke=guiStroke(Row, C.divider, 1); rowStroke.Transparency=1
        local ClickBtn = Instance.new("TextButton", Row)
        ClickBtn.Size = UDim2.new(0.7, 0, 1, 0)
        ClickBtn.BackgroundTransparency = 1
        ClickBtn.Text = ""
        ClickBtn.ZIndex = 2
        local Lb = Instance.new("TextLabel", Row)
        Lb.Size = UDim2.new(0.6, 0, 0, 30)
        Lb.Position = UDim2.new(0, 12, 0, 6)
        Lb.BackgroundTransparency = 1
        Lb.Text = "Lagger Carry Mode"
        Lb.TextColor3 = C.text
        Lb.TextSize = 13
        Lb.Font = Enum.Font.GothamBold
        Lb.TextXAlignment = Enum.TextXAlignment.Left
        local StatusLb = Instance.new("TextLabel", Row)
        StatusLb.Size = UDim2.new(0, 70, 0, 22)
        StatusLb.Position = UDim2.new(1, -80, 0, 8)
        StatusLb.BackgroundColor3 = C.bgDark
        StatusLb.BackgroundTransparency = 0.2
        StatusLb.Text = M.laggerCarryActive and "ON" or "OFF"
        StatusLb.TextSize = 10
        StatusLb.Font = Enum.Font.GothamBold
        StatusLb.TextColor3 = M.laggerCarryActive and Color3.fromRGB(255, 135, 215) or C.text
        guiCorner(StatusLb, 6)
        guiStroke(StatusLb, C.divider, 1)
        M.laggerCarryStatusLabel = StatusLb
        ClickBtn.MouseButton1Click:Connect(function()
            if M.toggleLaggerCarry then
                M.toggleLaggerCarry()
            else
                M.laggerCarryActive = not M.laggerCarryActive
            end
            if M.saveConfig then M.saveConfig() end
            M.notify("Lagger Carry: " .. (M.laggerCarryActive and "ON" or "OFF"))
        end)
        local SpdBox = Instance.new("TextBox", Row)
        SpdBox.Size = UDim2.new(0, 120, 0, 24)
        SpdBox.Position = UDim2.new(0, 12, 0, 42)
        SpdBox.BackgroundColor3 = C.input
        SpdBox.BackgroundTransparency = 0.2
        SpdBox.Text = tostring(M.LAGGER_CARRY_SPEED or 20)
        SpdBox.TextColor3 = C.text
        SpdBox.TextSize = 11
        SpdBox.Font = Enum.Font.GothamMedium
        SpdBox.ZIndex = 3
        guiCorner(SpdBox, 6)
        guiStroke(SpdBox, C.divider, 1)
        SpdBox.FocusLost:Connect(function(enter)
            local n = tonumber(SpdBox.Text)
            if n then
                M.LAGGER_CARRY_SPEED = n
                pcall(savePrimeHubFeKlanConfig)
            else
                SpdBox.Text = tostring(M.LAGGER_CARRY_SPEED or 20)
            end
        end)
        return Row
    end
    uiLaggerCarryCard(PM)
    uiSectionHeader(PM, "CONTROLS")
    uiToggleRow(PM, "Lagger Normal", M.laggerModeEnabled, function(on)
        if on ~= M.laggerModeEnabled then
            if M.toggleLaggerMode then
                M.toggleLaggerMode()
            else
                M.laggerModeEnabled = on
                if on then M.laggerCarryActive = false; M.carrySpeedActive = false end
            end
        end
        if M.laggerCarryStatusLabel then
            M.laggerCarryStatusLabel.Text = M.laggerCarryActive and "ON" or "OFF"
            M.laggerCarryStatusLabel.TextColor3 = M.laggerCarryActive and Color3.fromRGB(255, 135, 215) or Color3.fromRGB(255, 235, 248)
        end
        savePrimeHubFeKlanConfig()
    end)
    uiNumberRow(PM, "Lagger Normal Speed", M.LAGGER_SPEED or 15, 1, 200, function(v)
        M.LAGGER_SPEED = tonumber(v) or 15
        -- solo Lag Mode; no tocar perfil ni LAGGER_CARRY_SPEED
        if M.laggerModeEnabled and M._applySpeedNow then pcall(M._applySpeedNow) end
        pcall(savePrimeHubFeKlanConfig)
    end)
    uiNumberRow(PM, "Lagger Carry Speed", M.LAGGER_CARRY_SPEED or 24.5, 1, 200, function(v)
        M.LAGGER_CARRY_SPEED = tonumber(v) or 24.5
        -- solo Lag Carry; no tocar perfil ni LAGGER_SPEED
        if M.laggerCarryActive and M._applySpeedNow then pcall(M._applySpeedNow) end
        pcall(savePrimeHubFeKlanConfig)
    end)
    uiActionRow(PM, M.manualCarryActive and "Carry Mode: ON" or "Carry Mode: OFF", function()
        M.manualCarryActive = not M.manualCarryActive
        if M.manualCarryActive then
            M.autoCarryMode = "Carry"
            M.setModeCarryFlags()
            if M._applySpeedNow then pcall(M._applySpeedNow) end
        elseif M.autoSwitchSpeedEnabled then
            M.updateAutoSwitchSpeed()
        else
            M.setModeNormalFlags()
        end
        M.refreshWalkSpeedAutoSwitch()
        M.refreshSpeedModeLabel()
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PM, "Auto Carry Speed", M.autoSwitchSpeedEnabled, function(on)
        M.autoSwitchSpeedEnabled = on
        if not on then M.setModeNormalFlags() end
        M.refreshWalkSpeedAutoSwitch()
    end)
    uiChoiceRow(PM, "Auto Carry Mode", {"Lagger", "Carry", "Normal"}, M.autoCarryMode == "Lagger" and 1 or (M.autoCarryMode == "Carry" and 2 or 3), function(v) M.autoCarryMode = v end)
    local PMech = CategoryRefs.contents["Mechanics"]
    uiSectionHeader(PMech, "COMBAT")
    uiToggleRow(PMech, "Aimbot All Gears", M._zenonetopAimOn == true, function(on)
        M._zenonetopAimOn = on == true
        savePrimeHubFeKlanConfig()
    end)
    -- Auto Destroy Turret optimizado: sin escanear todo Workspace en bucle.
    M.autoDestroyTurretEnabled = M.autoDestroyTurretEnabled == true
    M._turretDestroyPending = {}
    function M._isTurretObject(obj)
        if not obj then return false end
        local n = obj.Name:lower()
        return n:find("turret") ~= nil or n:find("sentry") ~= nil
    end
    function M._destroyTurretIfNearby(obj)
        if not M.autoDestroyTurretEnabled or not obj or not obj.Parent then return end
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local bat = M.findBatForAimbot and M.findBatForAimbot() or nil
        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
        if not root or not hum or not bat or not part then return end
        if (part.Position - root.Position).Magnitude > 250 then return end
        if M._turretDestroyPending[obj] then return end
        M._turretDestroyPending[obj] = true
        task.spawn(function()
            for _ = 1, 6 do
                if not M.autoDestroyTurretEnabled or not obj.Parent then break end
                local currentChar = player.Character
                local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                local currentBat = M.findBatForAimbot and M.findBatForAimbot() or nil
                local currentPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                if not currentRoot or not currentBat or not currentPart then break end
                if (currentPart.Position - currentRoot.Position).Magnitude > 250 then break end
                pcall(function() currentBat:Activate() end)
                task.wait(0.12)
            end
            M._turretDestroyPending[obj] = nil
        end)
    end
    function M.startAutoDestroyTurret()
        if M.autoDestroyTurretConn then return end
        M.autoDestroyTurretEnabled = true
        M.autoDestroyTurretConn = workspace.DescendantAdded:Connect(function(obj)
            if M._isTurretObject(obj) then
                task.defer(M._destroyTurretIfNearby, obj)
            end
        end)
    end
    function M.stopAutoDestroyTurret()
        M.autoDestroyTurretEnabled = false
        if M.autoDestroyTurretConn then
            pcall(function() M.autoDestroyTurretConn:Disconnect() end)
            M.autoDestroyTurretConn = nil
        end
        M._turretDestroyPending = {}
    end
    uiToggleRow(PMech, "Auto Destroy Turret", M.autoDestroyTurretEnabled == true, function(on)
        if on then M.startAutoDestroyTurret() else M.stopAutoDestroyTurret() end
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PMech, "Anti Void", M.antiVoidEnabled == true, function(on)
        M.antiVoidEnabled = on == true
        M.setAntiVoid(on == true)
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PMech, "Body Lock", M.bodyLockEnabled == true, function(on)
        M.bodyLockEnabled = on == true
        M.setBodyLock(on == true)
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PMech, "bypass aimbot", M.autoBatEnabled == true, function(on)
        M.autoBatEnabled = on == true
        M.batAimbotEnabled = on == true
        if on then M.queueAutoBatStart() else M.stopBatAimbot() end
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PMech, "Bat Counter", M.batCounterEnabled == true, function(on)
        M.batCounterEnabled = on == true
        if on then M.startBatCounter() else M.stopBatCounter() end
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PMech, "Bat Counter V2", M.batCounterV2Enabled == true, function(on)
        if on then M.startBatCounterV2() else M.stopBatCounterV2() end
        savePrimeHubFeKlanConfig()
    end)
    uiExpandableVersionToggle(PMech, "TP Bat", M.bypassAimbotEnabled == true, {"V1", "V2"}, M.tpBatVersion or "V1",
        function(on, version)
            M.tpBatVersion = tostring(version or M.tpBatVersion or "V1")
            M.bypassAimbotEnabled = on == true
            if on then
                if M.batV2Enabled then M.disableBatV2() end
                M.startBypassAimbot()
            else
                M.stopBypassAimbot()
            end
            savePrimeHubFeKlanConfig()
        end,
        function(version, isOn)
            M.tpBatVersion = tostring(version or "V1")
            if M.notify then pcall(function() M.notify("TP Bat: " .. M.tpBatVersion) end) end
            -- If TP Bat is running, restart so the new distance threshold applies
            if isOn or M.bypassAimbotEnabled then
                M.stopBypassAimbot()
                M.bypassAimbotEnabled = true
                M.startBypassAimbot()
            end
            savePrimeHubFeKlanConfig()
        end
    )
    do
        local _, setBatV2Vis = uiToggleRow(PMech, "Bat V2", M.batV2Enabled == true, function(on)
            if on then M.enableBatV2() else M.disableBatV2() end
            savePrimeHubFeKlanConfig()
        end)
        M.setBatV2Visual = setBatV2Vis
        uiToggleRow(PMech, "Bat V2 Auto Swing", M.autoBatV2SwingEnabled ~= false, function(on)
            M.autoBatV2SwingEnabled = on == true
            savePrimeHubFeKlanConfig()
        end)
        if uiNumberRow then
            uiNumberRow(PMech, "Bat V2 Speed", M.AUTO_BAT_V2_SPEED or 60, 10, 200, function(v)
                M.AUTO_BAT_V2_SPEED = tonumber(v) or 60
                savePrimeHubFeKlanConfig()
            end)
        end
    end
    uiExpandableVersionToggle(PMech, "Anti Ragdoll", M.antiRagdollEnabled == true, {"V1", "V2"}, (M.antiRagdollMode == "V2" or M.antiRagdollMode == "No Splatter") and "V2" or "V1",
        function(on, version)
            M.antiRagdollMode = tostring(version or M.antiRagdollMode or "V1")
            if on then
                M.startAntiRagdoll()
            else
                M.stopAntiRagdoll()
            end
            savePrimeHubFeKlanConfig()
        end,
        function(version, isOn)
            M.antiRagdollMode = tostring(version or "V1")
            if M.notify then pcall(function() M.notify("Anti Ragdoll: " .. M.antiRagdollMode) end) end
            if isOn or M.antiRagdollEnabled then
                M.startAntiRagdoll()
            end
            savePrimeHubFeKlanConfig()
        end
    )
    uiToggleRow(PMech, "Medusa Counter", M.medusaCounterEnabled == true, function(on)
        M.medusaCounterEnabled = on == true
        if on then M.setupMedusa(player.Character) else M.stopMedusaCounter() end
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PMech, "Auto Swing", M.autoSwingEnabled == true, function(on)
        M.autoSwingEnabled = on == true
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PMech, "Anti Die & Fling", M.antiDieEnabled == true, function(on)
        if on then M.enableAntiDie() else M.disableAntiDie() end
        savePrimeHubFeKlanConfig()
    end)
    uiChoiceRow(PMech, "Drop Type", {"Fling", "Jump Drop"}, M.dropMode == "Jump Drop" and 2 or 1, function(v)
        local selected = tostring(v)
        if selected == "1" then selected = "Fling" elseif selected == "2" then selected = "Jump Drop" end
        M.dropMode = (selected == "Jump Drop") and "Jump Drop" or "Fling"
        if M.dropActive then M.stopDrop() end
        if M.notify then pcall(function() M.notify("Drop Type: " .. M.dropMode) end) end
        savePrimeHubFeKlanConfig()
    end)
    uiSectionHeader(PMech, "AUTO STEAL")
    uiToggleRow(PMech, "Auto Steal", (M.Steal and M.Steal.AutoStealEnabled == true) or (M.autoGrabV1Enabled == true), function(on)
        if on then
            if M.startAntiSammyAutoSteal then M.startAntiSammyAutoSteal()
            elseif M.startAutoGrabV1 then M.startAutoGrabV1() end
        else
            if M.stopAntiSammyAutoSteal then M.stopAntiSammyAutoSteal()
            elseif M.stopAutoGrabV1 then M.stopAutoGrabV1() end
        end
        savePrimeHubFeKlanConfig()
    end)
    uiChoiceRow(PMech, "Steal Preset", {"75", "80", "86", "90"}, ({["75"]=1,["80"]=2,["86"]=3,["90"]=4})[tostring(M.normalStealVersion or "86")] or 3, function(v)
        local val = tostring(v)
        if val == "1" then val = "75"
        elseif val == "2" then val = "80"
        elseif val == "3" then val = "86"
        elseif val == "4" then val = "90"
        end
        if M.setStealPreset then M.setStealPreset(val) else M.normalStealVersion = val end
        if M.notify then pcall(function() M.notify("Steal Preset: " .. tostring(M.normalStealVersion)) end) end
        savePrimeHubFeKlanConfig()
    end)
    uiActionRow(PMech, "Steal Bar Size −", function()
        if M.resizeStealBar then M.resizeStealBar(-20) else M.stealBarWidth = math.max(260, (M.stealBarWidth or 360) - 20) end
        if not (M.autoGrabV1Gui and M.autoGrabV1Gui.Parent) then if M.ensureAutoGrabV1Gui then M.ensureAutoGrabV1Gui() end end
        savePrimeHubFeKlanConfig()
    end)
    uiActionRow(PMech, "Steal Bar Size +", function()
        if M.resizeStealBar then M.resizeStealBar(20) else M.stealBarWidth = math.min(560, (M.stealBarWidth or 360) + 20) end
        if not (M.autoGrabV1Gui and M.autoGrabV1Gui.Parent) then if M.ensureAutoGrabV1Gui then M.ensureAutoGrabV1Gui() end end
        savePrimeHubFeKlanConfig()
    end)
    uiNumberRow(PMech, "Steal Bar Width", M.stealBarWidth or 360, 260, 560, function(v)
        M.stealBarWidth = math.clamp(tonumber(v) or 360, 260, 560)
        if M.resizeStealBar then M.resizeStealBar(0) end
        savePrimeHubFeKlanConfig()
    end)
    uiNumberRow(PMech, "Steal Radius", (M.Steal and M.Steal.StealRadius) or 61, 10, 120, function(v)
        if not M.Steal then M.Steal = { AutoStealEnabled = false, StealDuration = 1.3, Data = {} } end
        M.Steal.StealRadius = math.clamp(tonumber(v) or 61, 10, 120)
        if ZenXSteal then ZenXSteal.StealRadius = M.Steal.StealRadius end
        savePrimeHubFeKlanConfig()
    end)
    uiSectionHeader(PMech, "MOTION")
    uiToggleRow(PMech, "Lagger Normal", M.laggerModeEnabled, function(on)
        if on ~= M.laggerModeEnabled then
            if M.toggleLaggerMode then M.toggleLaggerMode() else
                M.laggerModeEnabled = on
                if on then M.laggerCarryActive = false; M.carrySpeedActive = false end
            end
        end
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PMech, "Infinite Jump", M.infJumpEnabled, function(on)
        M.infJumpEnabled = on == true
        M.stopManualInfJumpLoop(); M.stopHoldInfJump()
        M.infJumpMode = "hold"
        if M.infJumpEnabled then M.startHoldInfJump() end
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PMech, "Mirror TP Down", M.mirrorTPDownEnabled, function(on) M.setMirrorTPDown(on); savePrimeHubFeKlanConfig() end)
    uiToggleRow(PMech, "Auto Left", M.autoLeftEnabled, function(on)
        if on then if M.autoRightEnabled then M.autoRightEnabled=false; M.stopAutoRight() end; M.autoLeftEnabled=true; M.startAutoLeft() else M.autoLeftEnabled=false; M.stopAutoLeft() end
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PMech, "Auto Right", M.autoRightEnabled, function(on)
        if on then if M.autoLeftEnabled then M.autoLeftEnabled=false; M.stopAutoLeft() end; M.autoRightEnabled=true; M.startAutoRight() else M.autoRightEnabled=false; M.stopAutoRight() end
        savePrimeHubFeKlanConfig()
    end)
    uiActionRow(PMech, "TP Down", function() M.runTPFloor()     end)
    if ZenXSteal then
        uiNumberRow(PMech, "Grab Range", ZenXSteal.StealRadius or 62, 1, 100, function(v)
            ZenXSteal.StealRadius = math.clamp(tonumber(v) or 62, 1, 100)
            savePrimeHubFeKlanConfig()
        end)
    end
    -- Tool Aimbot original de ZENONETOP, conectado al uso real de cada gear.
    M._zenonetopAimOn = M._zenonetopAimOn ~= false
    M._zenonetopAimTools = { ["Web Slinger"] = true, ["Paintball Gun"] = true, ["Laser Cape"] = true }
    M._zenonetopMouse = nil
    function M._zenonetopGetMouse()
        if M._zenonetopMouse then return M._zenonetopMouse end
        pcall(function()
            local packages = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
            if packages then
                local module = packages:FindFirstChild("PlayerMouse") or packages:WaitForChild("PlayerMouse", 5)
                if module then M._zenonetopMouse = require(module) end
            end
        end)
        return M._zenonetopMouse
    end
    function M._zenonetopBestEnemy()
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        if not root or not cam then return nil end
        local best, score = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if targetRoot and hum and hum.Health > 0 then
                    local distance = (targetRoot.Position - root.Position).Magnitude
                    local toTarget = targetRoot.Position - cam.CFrame.Position
                    if distance <= 100 and toTarget.Magnitude > 0.01 then
                        local angle = math.deg(math.acos(math.clamp(cam.CFrame.LookVector:Dot(toTarget.Unit), -1, 1)))
                        local currentScore = distance + (angle > 200 and 1000 or 0)
                        if currentScore < score then score, best = currentScore, targetRoot end
                    end
                end
            end
        end
        return best
    end
    function M._zenonetopOverrideMouse()
        if not M._zenonetopAimOn then return end
        local char = player.Character
        local equipped = char and char:FindFirstChildOfClass("Tool")
        if not equipped or not M._zenonetopAimTools[equipped.Name] then return end
        local mouse = M._zenonetopGetMouse()
        local target = M._zenonetopBestEnemy()
        if not mouse or not target or not target.Parent then return end
        pcall(function()
            local velocity = target.AssemblyLinearVelocity or Vector3.zero
            mouse.Hit = CFrame.new(target.Position + velocity * 0.1)
            mouse.Target = target
        end)
    end
    M._zenonetopHooked = M._zenonetopHooked or {}
    function M._zenonetopHookTool(tool)
        if not tool or not M._zenonetopAimTools[tool.Name] or M._zenonetopHooked[tool] then return end
        M._zenonetopHooked[tool] = true
        tool.Activated:Connect(function() M._zenonetopOverrideMouse() end)
        tool.Equipped:Connect(function()
            task.wait(0.05)
            M._zenonetopOverrideMouse()
        end)
    end
    function M._zenonetopWatchTools(container)
        if not container then return end
        for _, tool in ipairs(container:GetChildren()) do M._zenonetopHookTool(tool) end
        container.ChildAdded:Connect(function(tool)
            task.wait(0.05)
            M._zenonetopHookTool(tool)
        end)
    end
    M._zenonetopWatchTools(player:FindFirstChildOfClass("Backpack"))
    if player.Character then M._zenonetopWatchTools(player.Character) end
    player.CharacterAdded:Connect(function(char)
        task.wait(0.2)
        M._zenonetopWatchTools(char)
        M._zenonetopWatchTools(player:FindFirstChildOfClass("Backpack"))
    end)
    M._zenonetopAimConn = RunService.RenderStepped:Connect(function()
        if M._zenonetopAimOn and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            M._zenonetopOverrideMouse()
        end
    end)
    M._zenonetopTouchConn = UIS.InputBegan:Connect(function(input, processed)
        if not processed and input.UserInputType == Enum.UserInputType.Touch then M._zenonetopOverrideMouse() end
    end)

    local PVis = CategoryRefs.contents["Visuals"]
    uiSectionHeader(PVis, "COLOR")
    do
        local colorBtn = Instance.new("TextButton")
        colorBtn.Name = "ToggleBluePurple"
        colorBtn.Size = UDim2.new(1, -16, 0, 32)
        colorBtn.Position = UDim2.fromOffset(8, 0)
        colorBtn.BorderSizePixel = 0
        colorBtn.Font = Enum.Font.GothamBold
        colorBtn.TextSize = 13
        colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        colorBtn.AutoButtonColor = true
        colorBtn.Parent = PVis
        Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 8)
        local colorStroke = Instance.new("UIStroke", colorBtn)
        colorStroke.Thickness = 1.2
        local function refreshColorButton()
            local current = M.adaptThemeName
            if not M.ADAPT_THEME_COLORS[current] then current = "BLUE" end
            local tint = M.ADAPT_THEME_COLORS[current]
            local labels = {PURPLE = "Morado", BLUE = "Azul", PINK = "Rosa", GREEN = "Verde"}
            colorBtn.BackgroundColor3 = tint
            colorStroke.Color = tint
            colorBtn.Text = "Color: " .. labels[current] .. "  •  Tocar para cambiar"
        end
        local function toggleColor()
            local order = {"PURPLE", "BLUE", "PINK", "GREEN"}
            local currentIndex = 1
            for i, name in ipairs(order) do
                if M.adaptThemeName == name then currentIndex = i; break end
            end
            local nextColor = order[(currentIndex % #order) + 1]
            M.adaptThemeName = nextColor
            M.currentAccent = M.ADAPT_THEME_COLORS[nextColor]
            M.menuBgIndex = (nextColor == "PURPLE" and 2) or (nextColor == "PINK" and 3) or (nextColor == "GREEN" and 4) or 1
            if M.applyAdaptThemeColor then M.applyAdaptThemeColor(nextColor) end
            if M.applyMenuBackground then M.applyMenuBackground(M.menuBgIndex) end
            if M.refreshTitleColor then pcall(M.refreshTitleColor) end
            refreshColorButton()
            savePrimeHubFeKlanConfig()
        end
        colorBtn.Activated:Connect(toggleColor)
        refreshColorButton()
    end
        -- El fondo se selecciona automáticamente según el color activo:
    -- azul = imagen 1, morado = imagen 2.
    M.menuBgIndex = (M.adaptThemeName == "PURPLE" and 2) or (M.adaptThemeName == "PINK" and 3) or (M.adaptThemeName == "GREEN" and 4) or 1
    task.defer(function()
        if M.applyMenuBackground then M.applyMenuBackground(M.menuBgIndex) end
    end)
    uiSectionHeader(PVis, "SKY & VISION")
    if M.SkyOrder and M.CandyApplyCustomSky then
        uiToggleRow(PVis, "Sky Themes", M.skyThemesEnabled == true, function(on)
            M.skyThemesEnabled = on == true
            if M.skyThemesEnabled then M.CandyApplyCustomSky(M.currentSkyTheme) else M.CandyApplyCustomSky("Off") end
            savePrimeHubFeKlanConfig()
        end)
        local savedSkyIndex = table.find(M.SkyOrder, M.currentSkyTheme) or 1
        uiChoiceRow(PVis, "Sky Preset", M.SkyOrder, savedSkyIndex, function(v)
            M.currentSkyTheme = v
            if M.skyThemesEnabled == true then M.CandyApplyCustomSky(v) end
            savePrimeHubFeKlanConfig()
        end)
    end
    uiSectionHeader(PVis, "CAMERA")
    if M.applyFOV then
        local fovChoices = {"Desactivado", 80, 90, 120}
        local selectedFov = 1
        if M.fovEnabled == true then selectedFov = table.find(fovChoices, tonumber(M.fovValue) or 80) or 2 end
        uiChoiceRow(PVis, "Camera FOV", fovChoices, selectedFov, function(v)
            if v == "Desactivado" then
                M.fovEnabled = false
            else
                M.fovEnabled = true
                M.fovValue = tonumber(v) or 80
            end
            M.applyFOV()
            savePrimeHubFeKlanConfig()
        end)
    end
    uiSectionHeader(PVis, "ESP")
    uiToggleRow(PVis, "Player ESP", M.playerESPEnabled, function(on) M.playerESPEnabled = on == true; M.toggleESP(M.playerESPEnabled); savePrimeHubFeKlanConfig() end)
    uiToggleRow(PVis, "Line ESP", M.lineESPEnabled, function(on) if M.setAdaptLineESP then M.setAdaptLineESP(on == true) else M.lineESPEnabled = on == true end; savePrimeHubFeKlanConfig() end)

    -- Black Skin: personaje negro, cabeza oculta y accesorios superiores retirados.
    M.blackSkinEnabled = false
    M._blackSkinOriginals = {}
    M._blackSkinHeadState = {}
    M._blackSkinRemovedAccessories = {}
    local function clearBlackSkinEffects(char)
        if not char then return end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj.Name == "PrimeHubSkinHeadFire" or obj.Name == "PrimeHubSkinFloatingAura" or obj.Name == "PrimeHubSkinFloatingCrown" or obj.Name == "PrimeHubSkinDragon" or obj.Name == "HaloGlow" then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                pcall(function() obj.Enabled = false end)
            end
        end
    end
    local function removeBlackSkinAccessories(char)
        if not char then return end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Accessory") then
                pcall(function() obj:Destroy() end)
            end
        end
    end
    function M.enableBlackSkin()
        -- eliminada: solo Hide Head
        M.blackSkinEnabled = false
    end
    function M.disableBlackSkin()
        M.blackSkinEnabled = false
        for obj, original in pairs(M._blackSkinOriginals or {}) do
            if obj and obj.Parent then
                pcall(function()
                    if typeof(original) == "Color3" then obj.Color = original
                    elseif obj:IsA("BodyColors") then
                        obj.HeadColor3=original.HeadColor3; obj.LeftArmColor3=original.LeftArmColor3; obj.RightArmColor3=original.RightArmColor3; obj.LeftLegColor3=original.LeftLegColor3; obj.RightLegColor3=original.RightLegColor3; obj.TorsoColor3=original.TorsoColor3
                    end
                end)
            end
        end
        for head, state in pairs(M._blackSkinHeadState or {}) do
            if head and head.Parent then head.Transparency=state.Transparency; head.LocalTransparencyModifier=state.LocalTransparencyModifier end
        end
        M._blackSkinOriginals = {}; M._blackSkinHeadState = {}
    end
    player.CharacterAdded:Connect(function(char)
        if false and M.blackSkinEnabled then task.wait(0.2); M.enableBlackSkin() end
    end)
    task.defer(function() end)

    -- Prime Hub skin center: cosmetic-only local presets for the character and bat.
    M.batSkinName = M.batSkinName or "Off"
    M.characterSkinName = M.characterSkinName or "Off"
    M._primeBatSkinOriginals = M._primeBatSkinOriginals or {}
    M._primeCharacterOriginals = M._primeCharacterOriginals or {}
    function M.applyPrimeBatSkin(name)
        name = tostring(name or "Off")
        M.batSkinName = name
        local colors = {
            Pumpkin = {Color3.fromRGB(255, 126, 20), Color3.fromRGB(92, 14, 120)},
            Shadow = {Color3.fromRGB(24, 18, 35), Color3.fromRGB(145, 55, 255)},
            Candy = {Color3.fromRGB(255, 75, 180), Color3.fromRGB(60, 220, 255)},
        }
        local pair = colors[name]
        local char = player.Character
        local bp = player:FindFirstChildOfClass("Backpack")
        local containers = {char, bp}
        for _, container in ipairs(containers) do
            if container then
                for _, tool in ipairs(container:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                        for _, obj in ipairs(tool:GetDescendants()) do
                            if obj:IsA("BasePart") then
                                if not M._primeBatSkinOriginals[obj] then M._primeBatSkinOriginals[obj] = {Color=obj.Color, Material=obj.Material} end
                                if pair then
                                    obj.Color = pair[1]
                                    obj.Material = Enum.Material.Neon
                                else
                                    local original = M._primeBatSkinOriginals[obj]
                                    obj.Color, obj.Material = original.Color, original.Material
                                end
                            end
                        end
                    end
                end
            end
        end
        if M.saveConfig then pcall(M.saveConfig) end
    end
    function M.applyPrimeCharacterSkin(name)
        name = tostring(name or "Off")
        M.characterSkinName = name
        local char = player.Character
        local body = char and char:FindFirstChildOfClass("BodyColors")
        local head = char and char:FindFirstChild("Head")
        if body then
            if not M._primeCharacterOriginals[body] then
                M._primeCharacterOriginals[body] = {
                    HeadColor3=body.HeadColor3, TorsoColor3=body.TorsoColor3,
                    LeftArmColor3=body.LeftArmColor3, RightArmColor3=body.RightArmColor3,
                    LeftLegColor3=body.LeftLegColor3, RightLegColor3=body.RightLegColor3,
                }
            end
            local palette = {
                Halloween = Color3.fromRGB(255, 125, 25),
                Shadow = Color3.fromRGB(42, 24, 58),
            }
            local c = palette[name]
            local original = M._primeCharacterOriginals[body]
            if c then
                body.HeadColor3, body.TorsoColor3 = c, c
                body.LeftArmColor3, body.RightArmColor3 = c, c
                body.LeftLegColor3, body.RightLegColor3 = c, c
            elseif original then
                body.HeadColor3, body.TorsoColor3 = original.HeadColor3, original.TorsoColor3
                body.LeftArmColor3, body.RightArmColor3 = original.LeftArmColor3, original.RightArmColor3
                body.LeftLegColor3, body.RightLegColor3 = original.LeftLegColor3, original.RightLegColor3
            end
        end
        if head then
            local fire = head:FindFirstChild("PrimeHalloweenFlame")
            if name == "Halloween" then
                fire = fire or Instance.new("Fire")
                fire.Name = "PrimeHalloweenFlame"
                fire.Color = Color3.fromRGB(255, 115, 20)
                fire.SecondaryColor = Color3.fromRGB(150, 45, 255)
                fire.Heat, fire.Size, fire.Enabled = 6, 5, true
                fire.Parent = head
            elseif fire then fire:Destroy() end
        end
        if name == "Headless" then M.applyHeadlessToChar(char, true) else M.applyHeadlessToChar(char, false) end
        if name == "Korblox" then M.applyKorbloxToChar(char, true) else M.applyKorbloxToChar(char, false) end
        if M.saveConfig then pcall(M.saveConfig) end
    end

    local PAnim = CategoryRefs.contents["Animations"]
    uiSectionHeader(PAnim, "SKINS")
    uiChoiceRow(PAnim, "Bat Skin", {"Off", "Pumpkin", "Shadow", "Candy"}, table.find({"Off", "Pumpkin", "Shadow", "Candy"}, M.batSkinName) or 1, function(v)
        M.applyPrimeBatSkin(v)
    end)
    uiChoiceRow(PAnim, "Character Skin", {"Off", "Halloween", "Shadow", "Headless", "Korblox"}, table.find({"Off", "Halloween", "Shadow", "Headless", "Korblox"}, M.characterSkinName) or 1, function(v)
        M.applyPrimeCharacterSkin(v)
    end)
    uiToggleRow(PAnim, "Hide Head", M.primeHubHeadHidden ~= false, function(on)
        M.primeHubHeadHidden = on == true
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        if head then
            head.Transparency = M.primeHubHeadHidden and 1 or 0
            head.LocalTransparencyModifier = M.primeHubHeadHidden and 1 or 0
        end
        savePrimeHubFeKlanConfig()
    end)
    uiSectionHeader(PAnim, "ANIMATIONS")
    uiToggleRow(PAnim, "Animations Enabled", M.animPackEnabled == true, function(on)
        M.animPackEnabled = on == true
        if M.animPackEnabled then
            M.applyAnimPack(M.animPack or "None")
        else
            M.unwalkEnabled = false
            M._unwalkOffLock = true
            M.stopUnwalk()
            M.resetAnimations(player.Character)
        end
        savePrimeHubFeKlanConfig()
    end)
    if M.applyAnimPack then
        uiChoiceRow(PAnim, "Animation Pack", {"None", "Adidas Sports", "Adidas Community", "Adidas Aura", "Wicked Popular", "Elder", "Zombie", "Mage", "Catwalk Glam", "Astronaut", "Werewolf", "Superhero", "Toy", "No Boundaries", "NFL", "Amazon Unboxed", "Vampire", "Ninja", "Robot", "Levitation", "Stylish", "Bubbly", "Unwalk"}, table.find({"None", "Adidas Sports", "Adidas Community", "Adidas Aura", "Wicked Popular", "Elder", "Zombie", "Mage", "Catwalk Glam", "Astronaut", "Werewolf", "Superhero", "Toy", "No Boundaries", "NFL", "Amazon Unboxed", "Vampire", "Ninja", "Robot", "Levitation", "Stylish", "Bubbly", "Unwalk"}, M.animPack or "Mage") or 8, function(v)
            M.animPack = v
            if v == "Unwalk" then
                M.animPackEnabled = true
                M.unwalkEnabled = true
                M._unwalkOffLock = false
                M.startUnwalk()
            else
                M.unwalkEnabled = false
                M._unwalkOffLock = true
                M.stopUnwalk()
                if M.animPackEnabled then M.applyAnimPack(v) end
            end
            savePrimeHubFeKlanConfig()
        end)
    end

    local PUtil = CategoryRefs.contents["Utility"]
            uiSectionHeader(PUtil, "INTERFACE EDIT")
    uiActionRow(PUtil, "Reset Position (Mobile Buttons)", function()
        M.resetMobilePositions()
        savePrimeHubFeKlanConfig()
    end)
    uiSectionHeader(PUtil, "BACKGROUNDS & EFFECTS")
    uiToggleRow(PUtil, "Button Opacity (Transparent)", M.mobButtonsTransparencyEnabled, function(on)
        M.mobButtonsTransparencyEnabled = on == true
        local alpha = M.mobButtonsTransparencyEnabled and 0.55 or 0
        local gui = M.mobileButtonsGui
        if gui then
            for _, item in ipairs(gui:GetDescendants()) do
                if item:IsA("TextButton") then
                    item.BackgroundTransparency = (tonumber(M.mobBtnBgId) or 0) > 0 and 1 or alpha
                elseif item:IsA("ImageLabel") and item.Name == "BtnBgImage" then
                    item.ImageTransparency = alpha
                end
            end
        end
        if M.mobileButtonsEnabled then M.buildMobileButtons() end
        savePrimeHubFeKlanConfig()
    end)
    uiNumberRow(PUtil, "Menu Scale", M.uiScale, 0.5, 2.0, function(v) M.uiScale = v; if M.uiScaleRef then M.uiScaleRef.Scale = v end; savePrimeHubFeKlanConfig() end)
    uiToggleRow(PUtil, "Hide Mobile Buttons", M.hideMobileButtons == true, function(on)
        M.hideMobileButtons = on == true
        _G.PrimeHubForceMobileVisible = not M.hideMobileButtons
        if M.mobileButtonsGui then M.mobileButtonsGui.Enabled = not M.hideMobileButtons end
        savePrimeHubFeKlanConfig()
    end)
    uiSectionHeader(PUtil, "PERFORMANCE")
    uiToggleRow(PUtil, "Anti-Lag", M.antiLagEnabled == true, function(on)
        M.antiLagEnabled = on == true
        if on then M.enableAntiLag() else M.disableAntiLag() end
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PUtil, "Nuke Optimizer", M.nukeOptimiserEnabled == true, function(on)
        if on then M.enableNukeOptimizer() else M.disableNukeOptimizer() end
        savePrimeHubFeKlanConfig()
    end)
    uiToggleRow(PUtil, "Graphics Bajos", M.graphicsBajosEnabled == true, function(on)
        if on then M.enableGraphicsBajos() else M.disableGraphicsBajos() end
        savePrimeHubFeKlanConfig()
    end)
    uiSectionHeader(PUtil, "PROTECTION")
    uiToggleRow(PUtil, "Anti Summer Base", M.antiSummerBaseEnabled, function(on) M.antiSummerBaseEnabled = on; if on then M.enableAntiSummerBase() else M.disableAntiSummerBase() end; savePrimeHubFeKlanConfig() end)
    uiToggleRow(PUtil, "Stretch Rez", M.stretchRezEnabled, function(on) M.stretchRezEnabled = on; if on then M.enableStretchRez() else M.disableStretchRez() end; savePrimeHubFeKlanConfig() end)
    uiToggleRow(PUtil, "Remove Accessories", M.removeAccEnabled, function(on) M.removeAccEnabled = on; if on then M.startRemoveAcc() else M.stopRemoveAcc() end; savePrimeHubFeKlanConfig() end)

    do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -8, 0, 36)
        row.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        row.BackgroundTransparency = 0.15
        row.BorderSizePixel = 0
        row.Parent = PUtil
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
        local pad = Instance.new("UIPadding", row)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 8)
        local nameLbl = Instance.new("TextLabel", row)
        nameLbl.Size = UDim2.new(0.42, 0, 1, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = "Pack Accessory"
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 12
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 32, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        leftBtn.Font = Enum.Font.GothamBlack
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        M.accSelectorLabel = Instance.new("TextLabel", container)
        M.accSelectorLabel.Size = UDim2.new(0, 84, 0, 26)
        M.accSelectorLabel.Position = UDim2.new(0.5, -42, 0.5, -13)
        M.accSelectorLabel.BackgroundTransparency = 1
        M.accSelectorLabel.Text = tostring(M.currentAccessoryPack or "Off")
        M.accSelectorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        M.accSelectorLabel.Font = Enum.Font.GothamBlack
        M.accSelectorLabel.TextSize = 12
        M.accSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 32, 0, 26)
        rightBtn.Position = UDim2.new(1, -32, 0.5, -13)
        rightBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        rightBtn.Font = Enum.Font.GothamBlack
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        leftBtn.MouseButton1Click:Connect(function()
            if M.setAccessoryPackByOffset then M.setAccessoryPackByOffset(-1) end
        end)
        rightBtn.MouseButton1Click:Connect(function()
            if M.setAccessoryPackByOffset then M.setAccessoryPackByOffset(1) end
        end)
    end

    uiToggleRow(PUtil, "Anti-Kick", M.antiKickEnabled, function(on) M.antiKickEnabled = on; if on then M.enableAntiKick() else M.disableAntiKick() end; savePrimeHubFeKlanConfig() end)
    uiToggleRow(PUtil, "Safe Mode", M.safeModeEnabled, function(on) M.safeModeEnabled = on; if on then M.enableSafeMode() else M.disableSafeMode() end; savePrimeHubFeKlanConfig() end)
    uiSectionHeader(PUtil, "MUSIC")
    -- Row estilo foto: Songs + OPEN
    do
        local songRow = Instance.new("Frame", PUtil)
        songRow.Size = UDim2.new(1, 0, 0, 44)
        songRow.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        songRow.BackgroundTransparency = 0.15
        songRow.BorderSizePixel = 0
        guiCorner(songRow, 14)
        local songStroke = guiStroke(songRow, Color3.fromRGB(220, 220, 230), 1)
        songStroke.Transparency = 0.35
        local songLbl = Instance.new("TextLabel", songRow)
        songLbl.Size = UDim2.new(1, -100, 1, 0)
        songLbl.Position = UDim2.new(0, 16, 0, 0)
        songLbl.BackgroundTransparency = 1
        songLbl.Text = "Songs"
        songLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        songLbl.TextSize = 15
        songLbl.Font = Enum.Font.GothamBold
        songLbl.TextXAlignment = Enum.TextXAlignment.Left
        local openBtn = Instance.new("TextButton", songRow)
        openBtn.Size = UDim2.new(0, 78, 0, 28)
        openBtn.Position = UDim2.new(1, -90, 0.5, -14)
        openBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        openBtn.BorderSizePixel = 0
        openBtn.AutoButtonColor = false
        openBtn.Text = "OPEN"
        openBtn.TextColor3 = Color3.fromRGB(15, 15, 18)
        openBtn.TextSize = 12
        openBtn.Font = Enum.Font.GothamBlack
        guiCorner(openBtn, 14)
        openBtn.MouseButton1Click:Connect(function()
            if M.openPrimeHubMusicPlayer then
                M.openPrimeHubMusicPlayer()
            end
        end)
    end

uiSectionHeader(PUtil, "MOBILE")
    uiToggleRow(PUtil, "Mobile Buttons", M.mobileButtonsEnabled, function(on) M.mobileButtonsEnabled = on == true; if on then M.buildMobileButtons() else M.destroyMobileButtons() end; savePrimeHubFeKlanConfig() end)
    uiNumberRow(PUtil, "Button Size", M.mobileButtonsSize, 40, 150, function(v) M.mobileButtonsSize = math.clamp(tonumber(v) or 100, 40, 150); if M.mobileButtonsEnabled then M.buildMobileButtons() end; savePrimeHubFeKlanConfig() end)
    uiSectionHeader(PUtil, "ACTIONS")
    uiActionRow(PUtil, "Save Config", function() if M.saveConfig then M.saveConfig() end; M.notify("Configuration saved") end)
    uiActionRow(PUtil, "Reset All Settings", function() M.resetAllSettings() end)
    local function uiStringInputRow(parent, label, value, callback)
        local Row=Instance_new("Frame",parent); Row.Size=UDim2.new(1,0,0,40); Row.BackgroundColor3=C.row
        Row.BackgroundTransparency=0.28; Row.BorderSizePixel=0; guiCorner(Row,10); local rowStroke=guiStroke(Row,C.divider,1); rowStroke.Transparency=0.48
        local Lb=Instance_new("TextLabel",Row); Lb.Size=UDim2.new(0.4,0,1,0); Lb.Position=UDim2.new(0,12,0,0)
        Lb.BackgroundTransparency=1; Lb.Text=label; Lb.TextColor3=C.text; Lb.TextSize=12; Lb.Font=Enum.Font.GothamMedium; Lb.TextXAlignment=Enum.TextXAlignment.Left
        local BC=Instance_new("Frame",Row); BC.ZIndex=6; BC.Position=UDim2.new(1,-128,0.5,-12); BC.Size=UDim2.new(0,116,0,24)
        BC.BackgroundColor3=C.input; BC.BackgroundTransparency=0.5; BC.BorderSizePixel=0; guiCorner(BC,6); guiStroke(BC,C.divider,1)
        local Box=Instance_new("TextBox",BC); Box.ZIndex=7; Box.Size=UDim2.new(1,0,1,0); Box.BackgroundTransparency=1
        Box.Text=tostring(value); Box.TextColor3=C.text; Box.TextSize=10; Box.Font=Enum.Font.GothamBold; Box.ClearTextOnFocus=true
        Box.FocusLost:Connect(function() callback(Box.Text) end)
        return Row,Box
    end
    local PKB = CategoryRefs.contents["Keybinds"]
    uiSectionHeader(PKB, "PC KEYS")
    uiToggleRow(PKB, "Show PC Key Panel", M.pcKeyStatusEnabled == true, function(on)
        M.pcKeyStatusEnabled = on == true
        if M.pcKeyStatusEnabled then
            M.buildPCKeyStatusPanel()
        elseif M.pcKeyStatusGui then
            M.pcKeyStatusGui:Destroy()
            M.pcKeyStatusGui = nil
        end
        savePrimeHubFeKlanConfig()
    end)
    uiActionRow(PKB, "Panel Smaller", function()
        M.pcKeyPanelScale = math.clamp((tonumber(M.pcKeyPanelScale) or 1) - 0.1, 0.65, 1.5)
        if M.pcKeyPanelScaleRef then M.pcKeyPanelScaleRef.Scale = M.pcKeyPanelScale end
        savePrimeHubFeKlanConfig()
    end)
    uiActionRow(PKB, "Panel Bigger", function()
        M.pcKeyPanelScale = math.clamp((tonumber(M.pcKeyPanelScale) or 1) + 0.1, 0.65, 1.5)
        if M.pcKeyPanelScaleRef then M.pcKeyPanelScaleRef.Scale = M.pcKeyPanelScale end
        savePrimeHubFeKlanConfig()
    end)
    uiKeybindRow(PKB, "Carry Speed", M.KB.SpeedNormal, function() return M.manualCarryActive == true or M.carrySpeedActive == true end)
    uiKeybindRow(PKB, "Bat Aimbot", M.KB.AutoBat, function() return M.autoBatEnabled == true end)
    uiKeybindRow(PKB, "Bat TP", M.KB.BatTP, function() return M.bypassAimbotEnabled == true end)
    uiKeybindRow(PKB, "Bat V2", M.KB.BatV2, function() return M.batV2Enabled == true end)
    uiKeybindRow(PKB, "Drop Brainrot", M.KB.DropBrainrot, function() return M.dropActive == true end)
    uiSectionHeader(PKB, "OTHER KEYBINDS")
    uiKeybindRow(PKB, "Hide GUI", M.KB.GuiHide)
    uiKeybindRow(PKB, "Insta Reset", M.KB.InstaReset)
    uiKeybindRow(PKB, "Lagger Carry", M.KB.LaggerCarry)
    uiKeybindRow(PKB, "Lagger Speed", M.KB.SpeedLagger)
    uiKeybindRow(PKB, "Custom Speed", M.KB.SpeedCustom)
    uiKeybindRow(PKB, "Lagger Mode", M.KB.LaggerToggle)
    uiKeybindRow(PKB, "TP Down", M.KB.TPFloor)
    uiKeybindRow(PKB, "Auto Left", M.KB.AutoLeft)
    uiKeybindRow(PKB, "Auto Right", M.KB.AutoRight)
    -- PrimeHub Melo layout: todas las secciones de XD Nuevo permanecen separadas arriba.
    LeftPanel.Visible = false
    -- Content starts under title + tabs
    CF.Position = UDim2.new(0, 0, 0, 108)
    CF.Size = UDim2.new(1, 0, 1, -112)
    CF.ZIndex = 6
    M._contentFrameRef = CF
    local TopTabs = Instance.new("ScrollingFrame")
    TopTabs.Name = "TopSections"
    -- CLEAN-style bottom tab bar
    -- Tabs debajo del título (High)
    TopTabs.Position = UDim2.new(0, 6, 0, 68)
    TopTabs.Size = UDim2.new(1, -12, 0, 36)
    TopTabs.BackgroundTransparency = 1
    TopTabs.BorderSizePixel = 0
    TopTabs.ScrollBarThickness = 0
    TopTabs.CanvasSize = UDim2.new(0, 0, 0, 0)
    TopTabs.AutomaticCanvasSize = Enum.AutomaticSize.X
    TopTabs.ScrollingDirection = Enum.ScrollingDirection.X
    TopTabs.Active = true
    TopTabs.ZIndex = 50
    TopTabs.Parent = Inner
    local TopLayout = Instance.new("UIListLayout", TopTabs)
    TopLayout.FillDirection = Enum.FillDirection.Horizontal
    TopLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TopLayout.Padding = UDim.new(0, 6)
    TopLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TopTabs.CanvasPosition = Vector2.zero
    local tabTargets = {Main = "Visuals", Speed = "Speed", Combat = "Mechanics", Animations = "Animations", Utility = "Utility", Keybinds = "Keybinds"}
    local tabRefs = {}
    local tabNames = {"Main", "Speed", "Combat", "Animations", "Utility", "Keybinds"}
    local function selectTopSection(name)
        local target = tabTargets[name] or "Visuals"
        for pageName, page in pairs(CategoryRefs.contents) do page.Visible = (pageName == target) end
        CategoryRefs.active = target
        for tabName, tab in pairs(tabRefs) do
            local active = tabName == name
            local SILVER = Color3.fromRGB(180, 180, 190)
            local SILVER_DARK = Color3.fromRGB(100, 100, 110)
            tab.BackgroundColor3 = active and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(0, 0, 0)
            tab.BackgroundTransparency = active and 0.35 or 0.55
            tab.TextColor3 = active and (M.currentAccent or SILVER) or SILVER_DARK
            local stroke = tab:FindFirstChild("TabStroke")
            if stroke then
                stroke.Color = active and (M.currentAccent or SILVER) or Color3.fromRGB(50, 50, 50)
                stroke.Thickness = 1
                stroke.Transparency = active and 0.3 or 0.55
            end
        end
    end
    for i, name in ipairs(tabNames) do
        local tab = Instance.new("TextButton")
        tab.Name = "Top_" .. name
        tab.Size = UDim2.fromOffset(78, 32)
        tab.BackgroundColor3 = name == "Main" and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(0, 0, 0)
        tab.BackgroundTransparency = name == "Main" and 0.35 or 0.55
        tab.BorderSizePixel = 0
        tab.Text = name
        tab.TextColor3 = name == "Main" and Color3.fromRGB(180, 180, 190) or Color3.fromRGB(100, 100, 110)
        tab.TextSize = 11
        tab.Font = Enum.Font.GothamBold
        tab.LayoutOrder = i
        tab.ZIndex = 51
        tab.Parent = TopTabs
        guiCorner(tab, 10)
        local stroke = guiStroke(tab, M.currentAccent or Color3.fromRGB(58, 128, 245), 1.8)
        stroke.Name = "TabStroke"
        tabRefs[name] = tab
        tab.MouseButton1Click:Connect(function() selectTopSection(name) end)
    end
    selectTopSection("Main")
    local footer = Instance.new("Frame")
    footer.Name = "PrimeHubFooter"
    footer.Size = UDim2.new(1, -24, 0, 0)
    footer.Position = UDim2.new(0, 12, 1, -52)
    footer.Visible = false
    footer.BackgroundColor3 = C.bgDark
    footer.BackgroundTransparency = 0.08
    footer.BorderSizePixel = 0
    footer.ZIndex = 30
    footer.Parent = Inner
    guiCorner(footer, 14)
    guiStroke(footer, C.divider, 1)
    local footerLine = Instance.new("Frame")
    footerLine.Size = UDim2.new(0.72, 0, 0, 1)
    footerLine.Position = UDim2.new(0.14, 0, 0, 6)
    footerLine.BackgroundColor3 = M.currentAccent or Color3.fromRGB(58, 128, 245)
    footerLine.BorderSizePixel = 0
    footerLine.ZIndex = 31
    footerLine.Parent = footer
    if M.recolorPinkToTheme then
        M.recolorPinkToTheme(Inner)
    end
    local footerText = Instance.new("TextLabel")
    footerText.Name = "PrimeHubTitle"
    footerText.Size = UDim2.new(1, -16, 1, -8)
    footerText.Position = UDim2.new(0, 8, 0, 4)
    footerText.BackgroundTransparency = 1
    footerText.Text = "prime hub"
    footerText.TextColor3 = M.currentAccent or Color3.fromRGB(58, 128, 245)
    footerText.TextStrokeColor3 = Color3.fromRGB(120, 20, 80)
    footerText.TextStrokeTransparency = 0.15
    footerText.Font = Enum.Font.Code
    footerText.TextSize = 19
    footerText.TextXAlignment = Enum.TextXAlignment.Center
    footerText.TextYAlignment = Enum.TextYAlignment.Center
    footerText.ZIndex = 32
    footerText.Parent = footer
    Outer.Visible = false
    MiniBtn.Visible = true
    M.menuOpen = false
    if M.pcKeyStatusEnabled == true then pcall(M.buildPCKeyStatusPanel) else pcall(function() if M.pcKeyStatusGui then M.pcKeyStatusGui:Destroy(); M.pcKeyStatusGui = nil end end) end
end

M.speedProfile = M.speedProfile or "Normal"
M.NormalSpeedNorm = M.NormalSpeedNorm or 59
M.NormalSpeedSteal = M.NormalSpeedSteal or 29
M.LaggerSpeedNorm = M.LaggerSpeedNorm or 30
M.LaggerSpeedSteal = M.LaggerSpeedSteal or 15
M.CustomSpeedNorm = M.CustomSpeedNorm or 66
M.CustomSpeedSteal = M.CustomSpeedSteal or 34
function M.resetAllSettings()
    M.speedProfile = "Normal"
    M.NormalSpeedNorm = 59
    M.NormalSpeedSteal = 29
    M.LaggerSpeedNorm = 30
    M.LaggerSpeedSteal = 15
    M.CustomSpeedNorm = 66
    M.CustomSpeedSteal = 34
    M.NS = 59
    M.CS = 29
    M.LAGGER_SPEED = 30
    M.LAGGER_CARRY_SPEED = 15
    M.speedMethod = "Velocity"
    M.hyperMult = 4
    M._lastSpeedMethod = nil
    M._anchoredBySpeed = nil
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    M.antiRagdollEnabled = false
    M.antiRagdollMode = "V1"
    M.infJumpEnabled = false
    M.infJumpMode = "hold"
    M.medusaCounterEnabled = false
    M.batCounterEnabled = false
    M.unwalkEnabled = false
        M.medusaDebounce = false
    M.medusaLastUsed = 0
    M.autoLeftEnabled = false
    M.autoRightEnabled = false
    M.autoBatEnabled = false
    M.autoSwingEnabled = true
    M.autoMoveSwingEnabled = false
    M.antiLagEnabled = false
    M.antiLagV2Enabled = false
    M.removeAccessoriesEnabled = false
    M.stretchRezEnabled = false
        M.autoTPHeight = 20
    M.guiTransparencyEnabled = false
    M.mobileButtonsEnabled = true
    M.mobileButtonsSize = 100
    M.fovValue = 80
    M.fovIndex = 1
    M.autoSwitchSpeedEnabled = false
    M.antiKickEnabled = false
    M.brainrotDetected = false
    M.ragdollGuiEnabled = true
    M.introSoundEnabled = false
    M.introSongChoice = 3
    M.introGUIEnabled = false
    M.autoRadiusEnabled = false
    M.removeAccEnabled = false
    M.playerESPEnabled = false
    M.showPlayerSpeeds = false
    M.uiScale = 0.8
    M.perButtonDragEnabled = true
    M.lineESPEnabled = false
    M.speedESPEnabled = false
    M.animPack = "Mage"
    M.headlessEnabled = false
    M.korbloxEnabled = false
    M.primeHubSkinEnabled = false
    M.primeHubKawatanEnabled = false
    M.primeHubMusicSelection = "Off"
    if M.setPrimeHubSkinMode then M.setPrimeHubSkinMode("Off", true) end
    if M.setPrimeHubMusic then M.setPrimeHubMusic("Off", true) end
    M.bypassAimbotEnabled = false
    M.animPackEnabled = true
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
    M.disableAntiLagV2()
    M.disableStretchRez()
    M.disableAntiKick()
    M.stopBypassAimbot()
    M.stopRemoveAcc()
    M.toggleESP(false)
    M.togglePlayerSpeeds(false)
    savePrimeHubFeKlanConfig()
    M.buildGui()
end
repeat task.wait() until game:IsLoaded()
task.wait(0.15)
loadPrimeHubFeKlanConfig()
pcall(function()
    local mode = M.autoGrabMode
    if getgenv and getgenv()._PrimeHubAutoGrabMode then
        local g = tostring(getgenv()._PrimeHubAutoGrabMode)
        if g == "V1" or g == "V2" then mode = g end
    end
    if mode ~= "V1" and mode ~= "V2" then mode = "V1" end
    M.autoGrabMode = mode
    if ZenXSteal then ZenXSteal.GrabMode = mode end
end)
M.loadBtnPositions()
-- Reactivar automáticamente los interruptores que quedaron encendidos.
task.defer(function()
    if M._zenonetopAimOn == nil then M._zenonetopAimOn = true end
    if M.autoDestroyTurretEnabled then M.startAutoDestroyTurret() end
end)
if M.graphicsBajosEnabled then pcall(M.enableGraphicsBajos) end
if M.antiDieEnabled then pcall(M.enableAntiDie) end
if M.startPlomoBorderAnim then pcall(M.startPlomoBorderAnim) end
if not M.KB.BatTP.kb then
    M.KB.BatTP.kb = M.KB.BypassAimbot.kb or Enum.KeyCode.E
end
M.KB.BypassAimbot.kb = nil
M.speedESPEnabled = false
cherryESPState.SpeedESP = false
M.primeHubSkinEnabled = false; M.primeHubKawatanEnabled = false
if M._savedTheme and CHERRY_THEMES[M._savedTheme] then
    PrimeHubFeKlanConfig.Theme = M._savedTheme
    M.colorScheme = M._savedTheme
elseif M.colorScheme and CHERRY_THEMES[M.colorScheme] then
    PrimeHubFeKlanConfig.Theme = M.colorScheme
    M._savedTheme = M.colorScheme
end
applyAccentFromTheme()
-- Intro: ocultar GUI hasta Skip o fin
_G.PrimeHubIntroActive = true
_G.PrimeHubIntroFinished = false
_G.PrimeHubForceMobileVisible = false
_G.PrimeHubIntroDoneCallbacks = {}
pcall(savePrimeHubFeKlanConfig)
M.unwalkEnabled = false
M._unwalkOffLock = true
if player.Character then
    pcall(M.stopUnwalk)
    pcall(M.restoreOriginalAnimate, player.Character)
end
M.buildGui()
-- Reaplicar el pack guardado después de crear el selector y de que el personaje esté listo.
task.defer(function()
    if player.Character and M.currentAccessoryPack and M.currentAccessoryPack ~= "Off" then
        pcall(function() M.restoreSavedAccessoryPack(player.Character) end)
    end
end)
pcall(function()
    if M.applyMenuBackground then M.applyMenuBackground(M.menuBgIndex or 1) end
    if M.adaptThemeName and M.applyAdaptThemeColor then
        M.applyAdaptThemeColor(M.adaptThemeName)
    end
end)
M.applyThemeBackground(M.colorScheme)
-- CLEAN shell: keep native colors
task.spawn(function()
    pcall(playCinematicIntro)
end)
cherryESPState.LineESP = M.lineESPEnabled == true
cherryESPState.SpeedESP = M.speedESPEnabled == true
if M.autoSwitchSpeedEnabled then M.refreshWalkSpeedAutoSwitch() end
task.defer(function()
    task.wait(0.05)
    pcall(function()
        
        if M.updateHeadTheme then M.updateHeadTheme() end
        if M.mainFrame then
            M.recolorBlacksToTheme(M.mainFrame)
            if M.recolorPinkToTheme then M.recolorPinkToTheme(M.mainFrame) end
        end
        if M.statusGui then M.recolorBlacksToTheme(M.statusGui) end
    end)
    -- During intro: no mobile buttons. Build only after intro ends.
    if _G.PrimeHubIntroActive then
        pcall(M.destroyMobileButtons)
    elseif M.mobileButtonsEnabled then
        M.buildMobileButtons()
        if M.applyMobileButtonsVisibility then M.applyMobileButtonsVisibility() end
    else
        M.destroyMobileButtons()
    end
    task.spawn(function()
        while _G.PrimeHubIntroActive do task.wait(0.1) end
        task.wait(0.05)
        if M.mainGui and M.mainGui.Parent then M.mainGui.Enabled = true end
        if M.mobileButtonsEnabled then
            if not (M.mobileButtonsGui and M.mobileButtonsGui.Parent) then
                pcall(M.buildMobileButtons)
            end
            local visible = not (M.hideMobileButtons == true)
            if M.mobileButtonsGui and M.mobileButtonsGui.Parent then M.mobileButtonsGui.Enabled = visible end
            if M.mobGuiRef and M.mobGuiRef.Parent then M.mobGuiRef.Enabled = visible end
        end
        if M.autoGrabV1Enabled ~= false then
            pcall(function()
                if not (M.autoGrabV1Gui and M.autoGrabV1Gui.Parent) then
                    M.ensureAutoGrabV1Gui()
                end
                if M.autoGrabV1Gui then M.autoGrabV1Gui.Enabled = true end
                if not M.autoGrabV1Conn then M.startAutoGrabV1() end
            end)
        end
    end)
    task.wait(0.05)
    if M.antiRagdollEnabled then M.startAntiRagdoll() end
    M.infJumpMode = "hold"
    if M.infJumpEnabled then M.startHoldInfJump() end
    if M.medusaCounterEnabled then M.setupMedusa(player.Character) end
    if M.batCounterEnabled then M.startBatCounter() end
    M.unwalkEnabled = false
    M._unwalkOffLock = true
    task.wait(0.05)
    if M.autoBatEnabled then M.queueAutoBatStart() end
    if M.autoLeftEnabled then M.startAutoLeft() end
    if M.autoRightEnabled then M.startAutoRight() end
    
    if M.bypassAimbotEnabled then M.startBypassAimbot() end
    if M.antiVoidEnabled then pcall(function() M.startAntiVoid() end) end
    if M.bodyLockEnabled then pcall(function() M.startBodyLock() end) end
    if M.autoGrabV1Enabled then pcall(function() M.startAutoGrabV1() end) end
    if M.antiKickEnabled then M.enableAntiKick() end
    if M.antiSummerBaseEnabled then M.enableAntiSummerBase() end
    if M.stretchRezEnabled then M.enableStretchRez() end
    if M.removeAccEnabled then M.startRemoveAcc() end
    task.wait(0.08)
    if M.animPackEnabled and M.animPack and M.PACKS[M.animPack] then
        M.applyAnimPack(M.animPack)
    elseif player.Character then
        M.resetAnimations(player.Character)
    end
    if M.headlessEnabled or M.korbloxEnabled then M.applyCharterToChar(player.Character) end
    if M.primeHubMusicSelection and M.primeHubMusicSelection ~= "Off" then M.setPrimeHubMusic(M.primeHubMusicSelection, true) end
    if M.skyThemesEnabled == true then M.CandyApplyCustomSky(M.currentSkyTheme) else M.CandyApplyCustomSky("Off") end
    if M.showPlayerSpeeds then M.togglePlayerSpeeds(true) end
    if M.playerESPEnabled then M.toggleESP(true) end
    if M.updateStatusRadius then M.updateStatusRadius() end
    M.startHeadSpeedUpdates()
    -- Final pass: reaplicar performance + Combat guardados
    task.defer(function()
        if M.antiLagEnabled then pcall(M.enableAntiLag) end
        if M.nukeOptimiserEnabled and M.enableNukeOptimizer then pcall(M.enableNukeOptimizer) end
        if M.graphicsBajosEnabled then pcall(M.enableGraphicsBajos) end
        if M.antiDieEnabled then pcall(M.enableAntiDie) end
        M.unwalkEnabled = false
        M._unwalkOffLock = true
        if M.antiSummerBaseEnabled then pcall(M.enableAntiSummerBase) end
        if M.stretchRezEnabled then pcall(M.enableStretchRez) end
        if M.antiKickEnabled then pcall(M.enableAntiKick) end
        if M.removeAccEnabled then pcall(M.startRemoveAcc) end
        -- Combat
        if M.antiVoidEnabled and M.startAntiVoid then pcall(M.startAntiVoid) end
        if M.bodyLockEnabled and M.startBodyLock then pcall(M.startBodyLock) end
        if M.antiRagdollEnabled and M.startAntiRagdoll then pcall(M.startAntiRagdoll) end
        if M.batCounterEnabled and M.startBatCounter then pcall(M.startBatCounter) end
        if M.medusaCounterEnabled and M.setupMedusa then pcall(function() M.setupMedusa(player.Character) end) end
        if M.autoBatEnabled and M.queueAutoBatStart then pcall(M.queueAutoBatStart) end
        if M.bypassAimbotEnabled and M.startBypassAimbot then pcall(M.startBypassAimbot) end
        if M.autoGrabV1Enabled ~= false and M.startAutoGrabV1 then pcall(M.startAutoGrabV1) end
    end)
    if player.Character then
        M.setupHeadIndicator(player.Character)
        M.setupRagdollTriggers()
    end
end)
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if M.primeHubHeadHidden then
        local hiddenHead = char:FindFirstChild("Head") or char:WaitForChild("Head", 3)
        if hiddenHead and hiddenHead:IsA("BasePart") then
            hiddenHead.Transparency = 1
            hiddenHead.LocalTransparencyModifier = 1
            task.delay(0.35, function()
                if M.primeHubHeadHidden and hiddenHead.Parent then
                    hiddenHead.Transparency = 1
                    hiddenHead.LocalTransparencyModifier = 1
                end
            end)
        end
    end
    if M.normalizeCameraState then pcall(M.normalizeCameraState) end
    task.defer(function()
        if player.Character == char and M.normalizeCameraState then pcall(M.normalizeCameraState) end
    end)
    M.setupHeadIndicator(char)
    M.setupRagdollTriggers()
    if M.medusaCounterEnabled then M.setupMedusa(char) end
    if M.batCounterEnabled then M.startBatCounter() end
    M.unwalkEnabled = false
    M._unwalkOffLock = true
    M.stopUnwalk()
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
    if M.bodyLockEnabled then
        task.wait(0.3)
        pcall(function() M.stopBodyLock(); M.startBodyLock() end)
    end
    if M.antiVoidEnabled then
        pcall(function() M.startAntiVoid() end)
    end
end)
do
    local _ncAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        _ncAcc = _ncAcc + dt
        if _ncAcc < 2.0 then return end
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

-- ==================== VOID SPEED ENGINE (Anti Drop — no spoof) ====================
-- Normal/Lagger: root.Velocity | Carry: CFrame step | Anti Fling
local FLING_THRESHOLD = 80
local function _voidApplyVelocitySpeed(speed)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    if M.antiDieEnabled and root.AssemblyLinearVelocity.Magnitude > FLING_THRESHOLD then
        root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end

    if hum.Health <= 0 then return end

    if M.autoBatEnabled or M.autoLeftEnabled or M.autoRightEnabled or M.bypassAimbotEnabled then
        return
    end

    if M.isRagdollState and M.isRagdollState(hum) then
        M.lastMoveDir = Vector3.zero
        return
    end

    local dir = hum.MoveDirection
    if dir.Magnitude <= 0.05 then
        if M.antiRagdollEnabled and M.lastMoveDir and M.lastMoveDir.Magnitude > 0.05 and M.MOVE_KEYS then
            local anyHeld = false
            for key in pairs(M.MOVE_KEYS) do
                if UIS:IsKeyDown(key) then anyHeld = true; break end
            end
            if anyHeld then dir = M.lastMoveDir else return end
        else
            return
        end
    end

    M.lastMoveDir = dir
    local u = dir.Unit
    local s = tonumber(speed)
    if not s or s <= 0 then
        s = (M.getActiveMoveSpeed and M.getActiveMoveSpeed()) or 16
    end
    s = tonumber(s) or 16
    -- Mismo método exacto que Lagger Carry: solo root.Velocity
    root.Velocity = Vector3.new(u.X * s, root.Velocity.Y, u.Z * s)
end

local function destroySpeedObjects()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local lv = hrp:FindFirstChild("_RHSpeedLV")
        if lv then pcall(function() lv:Destroy() end) end
    end
end
M.destroySpeedObjects = destroySpeedObjects

-- helpers para auto left/right y paths (usa Velocity, misma lógica Void)
M._getOrMakeLV = function() return nil end
M._speedLVSet = function(hrp, x, z)
    if not hrp then return end
    local y = 0
    pcall(function() y = hrp.Velocity.Y end)
    pcall(function()
        hrp.Velocity = Vector3.new(x, y, z)
    end)
end
M._speedLVClear = function(hrp)
    if not hrp then return end
    pcall(function()
        local y = hrp.Velocity.Y
        hrp.Velocity = Vector3.new(0, y, 0)
    end)
    local lv = hrp:FindFirstChild("_RHSpeedLV")
    if lv then pcall(function() lv:Destroy() end) end
end

local _voidSpeedConn = nil
pcall(function()
    local _mobileSpeedModeAcc = 0
    local function tickSpeed()
        _mobileSpeedModeAcc = _mobileSpeedModeAcc + 0.016
        if not PRIMEHUB_MOBILE or _mobileSpeedModeAcc >= 0.15 then
            _mobileSpeedModeAcc = 0
            if M.updateAutoSwitchSpeed then pcall(M.updateAutoSwitchSpeed) end
        end
        _voidApplyVelocitySpeed(M.getActiveMoveSpeed and M.getActiveMoveSpeed() or 16)
    end
    if RunService.PreSimulation then
        _voidSpeedConn = RunService.PreSimulation:Connect(tickSpeed)
    else
        _voidSpeedConn = RunService.Heartbeat:Connect(tickSpeed)
    end
end)


task.spawn(function()
    while task.wait(45) do pcall(savePrimeHubFeKlanConfig) end
end)
M.applyFOV()
task.spawn(function()
    while true do
        task.wait(10)
        pcall(M.saveBtnPositions)
    end
end)
function M.refreshSpeedModeLabel()
end
pcall(function()
    M.refreshWalkSpeedAutoSwitch()
    if M.customFontSelected and M.customFontSelected ~= "None" then
        task.spawn(function()
            task.wait(0.4)
            pcall(function() M.applyCustomFont(M.customFontSelected) end)
        end)
    end
end)
print("prime hub loaded!")
local kbDebounce = {}
UIS.InputBegan:Connect(function(inp, gpe)
    if UIS:GetFocusedTextBox() then return end
    if inp.UserInputType == Enum.UserInputType.Keyboard then
        local key = inp.KeyCode
        for name, entry in pairs(M.KB) do
            if type(entry) == "table" and entry.kb == key then
                if kbDebounce[name] and tick() - kbDebounce[name] < 0.2 then break end
                kbDebounce[name] = tick()
                if name == "DropBrainrot" then
                    M.runDrop()
                elseif name == "AutoBat" then
                    M.dropBrainrotInHand()
                    if M.autoBatEnabled then M.stopBatAimbot() else M.queueAutoBatStart() end
                elseif name == "BatV2" then
                    M.dropBrainrotInHand()
                    if M.toggleBatV2 then M.toggleBatV2() end
                elseif name == "BatTP" then
                    M.dropBrainrotInHand()
                    if M.bypassAimbotEnabled then M.stopBypassAimbot() else M.startBypassAimbot() end
                    if M.mobBtnRefs and M.mobBtnRefs.tpBat then M.mobBtnRefs.tpBat(M.bypassAimbotEnabled) end
                                elseif name == "GuiHide" then
                    if M.menuOpen then
                        if M._hideGuiWithBubble then M._hideGuiWithBubble() end
                    else
                        if M._showGuiWithBubble then M._showGuiWithBubble() end
                    end
                elseif name == "InstaReset" then
                    M.doInstaReset()
                elseif name == "LaggerToggle" then
                    M.toggleLaggerMode()
                elseif name == "LaggerCarry" then
                    M.toggleLaggerCarry()
                elseif name == "SpeedNormal" then
                    M._manualSpeedModeLock = true
                    if M.speedProfile == "Normal" then
                        M.carrySpeedActive = not M.carrySpeedActive
                    else
                        local wasCarry = M.carrySpeedActive == true or M.manualCarryActive == true or M.laggerCarryActive == true
                        M.speedProfile = "Normal"
                        M.NS = M.NormalSpeedNorm
                        M.CS = M.NormalSpeedSteal
                        M.carrySpeedActive = wasCarry
                        M.laggerModeEnabled = false
                        M.laggerCarryActive = false
                        M.manualCarryActive = wasCarry
                        if M._applySpeedNow then pcall(M._applySpeedNow) end
                    end
                    M.manualCarryActive = M.carrySpeedActive == true
                    if M.saveConfig then M.saveConfig() end
                    M.notify("Normal: " .. (M.carrySpeedActive and M.CS or M.NS))
                elseif name == "SpeedLagger" then
                    M._manualSpeedModeLock = true
                    if M.speedProfile == "Lagger" then
                        M.carrySpeedActive = not M.carrySpeedActive
                    else
                        local wasCarry = M.carrySpeedActive == true or M.manualCarryActive == true or M.laggerCarryActive == true
                        M.speedProfile = "Lagger"
                        M.NS = M.LaggerSpeedNorm
                        M.CS = M.LaggerSpeedSteal
                        M.carrySpeedActive = wasCarry
                        M.laggerModeEnabled = false
                        M.laggerCarryActive = false
                        M.manualCarryActive = wasCarry
                        if M._applySpeedNow then pcall(M._applySpeedNow) end
                    end
                    M.manualCarryActive = M.carrySpeedActive == true
                    if M.saveConfig then M.saveConfig() end
                    M.notify("Lagger: " .. (M.carrySpeedActive and M.CS or M.NS))
                elseif name == "SpeedCustom" then
                    M._manualSpeedModeLock = true
                    if M.speedProfile == "Custom" then
                        M.carrySpeedActive = not M.carrySpeedActive
                    else
                        local wasCarry = M.carrySpeedActive == true or M.manualCarryActive == true or M.laggerCarryActive == true
                        M.speedProfile = "Custom"
                        M.NS = M.CustomSpeedNorm
                        M.CS = M.CustomSpeedSteal
                        M.carrySpeedActive = wasCarry
                        M.laggerModeEnabled = false
                        M.laggerCarryActive = false
                        M.manualCarryActive = wasCarry
                        if M._applySpeedNow then pcall(M._applySpeedNow) end
                    end
                    M.manualCarryActive = M.carrySpeedActive == true
                    if M.saveConfig then M.saveConfig() end
                    M.notify("Custom: " .. (M.carrySpeedActive and M.CS or M.NS))
                elseif name == "TPFloor" then
                    M.runTPFloor()
                elseif name == "AutoLeft" then
                    if M.autoLeftEnabled then M.stopAutoLeft(); M.autoLeftEnabled=false else M.startAutoLeft(); M.autoLeftEnabled=true end
                elseif name == "AutoRight" then
                    if M.autoRightEnabled then M.stopAutoRight(); M.autoRightEnabled=false else M.startAutoRight(); M.autoRightEnabled=true end
                end
                if M.saveConfig then M.saveConfig() end
                break
            end
        end
    end
end)

-- ===== Adapt_fixed integration: ESP Player / ESP Line / Nuke Optimizer =====
V = M
LP = LP or player
THEME_ACCENT = M.currentAccent or Color3.fromRGB(58,128,245)
THEME_ACCENT = THEME_ACCENT or Color3.fromRGB(230, 230, 230)
THEME_ACCENT_DIM = THEME_ACCENT_DIM or Color3.fromRGB(145, 145, 145)
PlayerESP = PlayerESP or {enabled=false, playerData={}, conns={}, discordText="discord.gg/gr7eqCS2a"}
BoxedESPOptions = BoxedESPOptions or {box=false, tracer=false}
BoxedESPData = BoxedESPData or {}
BoxedESPConn = BoxedESPConn or nil
stretchRezConn = stretchRezConn or nil
antiLagDescConn = antiLagDescConn or nil
noCamCollisionConn = noCamCollisionConn or nil
noCamCollisionParts = noCamCollisionParts or {}
_aceNukeConns = _aceNukeConns or {}
_aceNukeOn = _aceNukeOn or false
_aceCustomFontOrig = _aceCustomFontOrig or {}
_aceCustomFontConn = _aceCustomFontConn or nil
_aceCustomFont = _aceCustomFont or nil
function startPlayerESP()
if PlayerESP.enabled then return end
PlayerESP.enabled = true
function cleanup(plr)
local d=PlayerESP.playerData[plr]; if not d then return end
pcall(function() if d.highlight then d.highlight:Destroy() end end)
pcall(function() if d.billboard then d.billboard:Destroy() end end)
if d.conns then for _,c in ipairs(d.conns) do pcall(function() c:Disconnect() end) end end
PlayerESP.playerData[plr]=nil
end
function setup(plr,char)
if not PlayerESP.enabled or plr==LP then return end
cleanup(plr)
local hrp=char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",5))
local head=char and (char:FindFirstChild("Head") or char:WaitForChild("Head",5))
if not hrp or not head then return end
local hl=Instance.new("Highlight")
hl.Name="AdaptDuelsESP"; hl.Adornee=char; hl.FillColor=(_G.AdaptThemeColors and _G.AdaptThemeColors[_G.AdaptThemeName]) or THEME_ACCENT; hl.FillTransparency=0.72
hl.OutlineColor=(_G.AdaptThemeColors and _G.AdaptThemeColors[_G.AdaptThemeName]) or THEME_ACCENT; hl.OutlineTransparency=0; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=char
local bb=Instance.new("BillboardGui")
bb.Name="AdaptDuelsESPTag"; bb.Adornee=head; bb.Size=UDim2.new(0,170,0,42); bb.StudsOffset=Vector3.new(0,2.8,0); bb.AlwaysOnTop=true; bb.LightInfluence=0; bb.Parent=head
local box=Instance.new("Frame",bb); box.Size=UDim2.new(1,0,1,0); box.BackgroundTransparency=1; box.BorderSizePixel=0
Instance.new("UICorner",box).CornerRadius=UDim.new(0,9)
local n=Instance.new("TextLabel",box); n.Size=UDim2.new(1,-8,0,19); n.Position=UDim2.new(0,4,0,1); n.BackgroundTransparency=1; n.TextColor3=Color3.fromRGB(255,255,255); n.TextStrokeColor3=Color3.fromRGB(0,0,0); n.Font=Enum.Font.GothamBlack; n.TextSize=13; n.TextStrokeTransparency=0.08
local sub=Instance.new("TextLabel",box); sub.Size=UDim2.new(1,-8,0,17); sub.Position=UDim2.new(0,4,0,19); sub.BackgroundTransparency=1; sub.TextColor3=Color3.fromRGB(255,255,255); sub.TextStrokeColor3=Color3.fromRGB(0,0,0); sub.Font=Enum.Font.GothamBlack; sub.TextSize=11; sub.TextStrokeTransparency=0.08
local conn=RunService.Heartbeat:Connect(function()
if not PlayerESP.enabled or not hrp.Parent then return end
local v=hrp.AssemblyLinearVelocity or hrp.Velocity
n.Text=string.format("Speed: %.1f", Vector3.new(v.X,0,v.Z).Magnitude); sub.Text=plr.Name
end)
PlayerESP.playerData[plr]={highlight=hl,billboard=bb,conns={conn}}
end
for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP then if plr.Character then setup(plr,plr.Character) end; table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup,plr,c) end)) end end
table.insert(PlayerESP.conns, Players.PlayerAdded:Connect(function(plr) if plr~=LP then table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup,plr,c) end)) end end))
table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(cleanup))
end
function stopPlayerESP()
PlayerESP.enabled=false
for _,c in ipairs(PlayerESP.conns or {}) do pcall(function() c:Disconnect() end) end
PlayerESP.conns={}
for plr,d in pairs(PlayerESP.playerData or {}) do pcall(function() if d.highlight then d.highlight:Destroy() end end); pcall(function() if d.billboard then d.billboard:Destroy() end end) end
PlayerESP.playerData={}
end
function _aceEspColor()
    local colors = M.ADAPT_THEME_COLORS or {
        PURPLE = Color3.fromRGB(160,40,255),
        BLUE = Color3.fromRGB(0,140,255),
        PINK = Color3.fromRGB(255,80,190),
        GREEN = Color3.fromRGB(0,200,110),
    }
    local themeName = tostring(M.adaptThemeName or "BLUE"):upper()
    local active = colors[themeName] or M.currentAccent or THEME_ACCENT
    return active or Color3.fromRGB(0,140,255)
end
function _safeDrawing(kind, props)
if not Drawing or not Drawing.new then return nil end
local ok, obj = pcall(function() return Drawing.new(kind) end)
if not ok or not obj then return nil end
for k,v in pairs(props or {}) do pcall(function() obj[k]=v end) end
return obj
end
function _cleanupBoxedESPPlayer(player)
local data = BoxedESPData[player]
if not data then return end
for _,obj in pairs(data) do
pcall(function()
obj.Visible = false
if obj.Remove then obj:Remove() end
end)
end
BoxedESPData[player] = nil
end
function _cleanupBoxedESP()
for player,_ in pairs(BoxedESPData) do _cleanupBoxedESPPlayer(player) end
end
function _updateBoxedESP()
local cam = workspace.CurrentCamera
if not cam then return end
local anyOn = BoxedESPOptions.box or BoxedESPOptions.tracer
if not anyOn then
_cleanupBoxedESP()
return
end
for _,player in ipairs(Players:GetPlayers()) do
if player == LP then continue end
local char = player.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local head = char and char:FindFirstChild("Head")
if not root or not head then
_cleanupBoxedESPPlayer(player)
continue
end
local rootPos,onScreen = cam:WorldToViewportPoint(root.Position)
local headPos = cam:WorldToViewportPoint(head.Position + Vector3.new(0,0.55,0))
local data = BoxedESPData[player]
if not data then
data = {
box = _safeDrawing("Square",{Thickness=2,Filled=false,Transparency=1,Color=_aceEspColor()}),
tracer = _safeDrawing("Line",{Thickness=2,Transparency=1,Color=_aceEspColor()}),
}
BoxedESPData[player] = data
end
local color = _aceEspColor()
local height = math.abs(headPos.Y - rootPos.Y) * 2.15
if height < 20 or height ~= height then height = 65 end
local width = height / 2.15
local view = cam.ViewportSize
local centerX, centerY = view.X/2, view.Y/2
local targetX, targetY = rootPos.X, rootPos.Y + height/2
local targetVisible = onScreen and rootPos.Z > 0
if not targetVisible then
local dx = rootPos.X - centerX
local dy = rootPos.Y - centerY
if rootPos.Z <= 0 then
dx = -dx
dy = -dy
end
if math.abs(dx) < 1 and math.abs(dy) < 1 then
local rel = cam.CFrame:PointToObjectSpace(root.Position)
dx = rel.X
dy = -rel.Y
if rootPos.Z <= 0 then
dx = -dx
dy = -dy
end
end
local edgePad = 10
local scaleX = (dx ~= 0) and ((view.X/2 - edgePad) / math.abs(dx)) or math.huge
local scaleY = (dy ~= 0) and ((view.Y/2 - edgePad) / math.abs(dy)) or math.huge
local scale = math.min(scaleX, scaleY)
if scale == math.huge or scale ~= scale then scale = 1 end
targetX = math.clamp(centerX + dx * scale, edgePad, view.X - edgePad)
targetY = math.clamp(centerY + dy * scale, edgePad, view.Y - edgePad)
end
if data.box then
data.box.Color = color
data.box.Size = Vector2.new(width,height)
data.box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
data.box.Visible = false
end
if data.tracer then
data.tracer.Color = _aceEspColor()
local localChar = LP.Character
local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
local localHead = localChar and localChar:FindFirstChild("Head")
local fromX, fromY
if localRoot then
local localScreen = cam:WorldToViewportPoint(localRoot.Position)
fromX = localScreen.X
fromY = localScreen.Y + 15
end
if not fromX or not fromY then
fromX = cam.ViewportSize.X/2
fromY = cam.ViewportSize.Y - 88
end
data.tracer.From = Vector2.new(fromX, fromY)
data.tracer.To = Vector2.new(targetX, targetY)
data.tracer.Visible = BoxedESPOptions.tracer == true
end
end
end
function refreshBoxedESP()
local anyOn = BoxedESPOptions.box or BoxedESPOptions.tracer
if anyOn and not BoxedESPConn then
BoxedESPConn = RunService.RenderStepped:Connect(_updateBoxedESP)
elseif (not anyOn) and BoxedESPConn then
BoxedESPConn:Disconnect()
BoxedESPConn = nil
_cleanupBoxedESP()
end
end
Players.PlayerRemoving:Connect(_cleanupBoxedESPPlayer)
_nukeOptimizerOn = false
_nukeOptimizerConns = {}
_nukeOptimizerThreads = {}
function enableNukeOptimizer()
if _nukeOptimizerOn then return end
_nukeOptimizerOn = true
nukeOptimiserEnabled = true
V.nukeOptEnabled = true
local MaterialService = game:GetService("MaterialService")
local XMin, XMax = -560, -240
local ClothingClasses = {"Shirt","Pants","ShirtGraphic","Accessory","Hat","HairAccessory","FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory","BackAccessory","WaistAccessory"}
local BASE_NAMES = {"baseplate","spawnlocation","spawn location","spawn"}
function SafeDestroy(obj)
if obj and obj.Name == "Overhead" then return end
pcall(function() obj:Destroy() end)
end
function IsClothing(obj)
for _, className in ipairs(ClothingClasses) do
if obj:IsA(className) then return true end
end
return false
end
function IsCharacterPart(obj)
for _, plr in ipairs(Players:GetPlayers()) do
if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
end
return false
end
function IsOutOfRange(obj)
if obj:IsA("BasePart") then
local x = obj.Position.X
return x < XMin or x > XMax
end
return false
end
function IsBase(obj)
if not obj:IsA("BasePart") then return false end
local nl = obj.Name:lower()
for _, n in ipairs(BASE_NAMES) do
if nl:find(n, 1, true) then return true end
end
return false
end
function IsInBase(obj)
local p = obj.Parent
while p and p ~= workspace do
if IsBase(p) then return true end
p = p.Parent
end
return false
end
function MakeTransparent(obj)
pcall(function()
if IsBase(obj) and not IsCharacterPart(obj) then
obj.Transparency = 1
obj.CastShadow = false
end
end)
end
function StripObject(obj)
pcall(function()
if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SpecialMesh") then
SafeDestroy(obj)
elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
pcall(function() obj.Enabled = false end)
SafeDestroy(obj)
elseif obj:IsA("SurfaceAppearance") then
SafeDestroy(obj)
elseif obj:IsA("BasePart") then
obj.CastShadow = false
obj.Material = Enum.Material.Plastic
obj.MaterialVariant = ""
obj.Reflectance = 0
end
end)
end
function CleanObject(obj)
pcall(function()
if obj:IsA("SurfaceAppearance") then
SafeDestroy(obj)
elseif obj:IsA("Decal") or obj:IsA("Texture") then
if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then SafeDestroy(obj) end
elseif obj:IsA("SpecialMesh") then
obj.TextureId = ""
elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
SafeDestroy(obj)
elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
SafeDestroy(obj)
elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
SafeDestroy(obj)
elseif obj:IsA("Animation") or obj:IsA("AnimationController") then
SafeDestroy(obj)
elseif obj:IsA("BasePart") then
obj.CastShadow = false
obj.Material = Enum.Material.Plastic
obj.MaterialVariant = ""
obj.Reflectance = 0
end
end)
end
function ApplyGreySky()
pcall(function()
for _, obj in ipairs(Lighting:GetChildren()) do
if obj:IsA("Sky") then obj:Destroy() end
end
local sky = Instance.new("Sky")
sky.SkyboxBk = ""; sky.SkyboxDn = ""; sky.SkyboxFt = ""
sky.SkyboxLf = ""; sky.SkyboxRt = ""; sky.SkyboxUp = ""
sky.CelestialBodiesShown = false
sky.Name = "_AdaptDuelsNukeSky"
sky.Parent = Lighting
end)
end
function OptimizeLighting()
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.FogStart = 9e9
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
Lighting.Brightness = 1.5
Lighting.Ambient = Color3.fromRGB(60,60,60)
for _, v in ipairs(Lighting:GetChildren()) do
if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") or v:IsA("Clouds") then
v:Destroy()
end
end
ApplyGreySky()
end)
end
function ApplyTerrain()
pcall(function()
local terrain = workspace:FindFirstChildOfClass("Terrain")
if terrain then
terrain.Decoration = false
terrain.WaterWaveSize = 0
terrain.WaterWaveSpeed = 0
terrain.WaterReflectance = 0
terrain.WaterTransparency = 1
end
end)
end
function OptimizeCharacter(char)
if not char then return end
task.spawn(function()
task.wait(0.3)
if not _nukeOptimizerOn then return end
for _, obj in ipairs(char:GetDescendants()) do
if IsClothing(obj) then SafeDestroy(obj) else CleanObject(obj) end
end
end)
end
pcall(function()
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
end)
pcall(function() if setfpscap then setfpscap(999) end end)
table.insert(_nukeOptimizerThreads, task.spawn(function()
if not game:IsLoaded() then game.Loaded:Wait() end
OptimizeLighting()
ApplyTerrain()
for _, obj in ipairs(workspace:GetDescendants()) do
if not _nukeOptimizerOn then return end
if IsBase(obj) then
MakeTransparent(obj)
elseif IsClothing(obj) then
SafeDestroy(obj)
elseif IsInBase(obj) then
elseif IsCharacterPart(obj) then
elseif IsOutOfRange(obj) then
SafeDestroy(obj)
else
CleanObject(obj)
StripObject(obj)
end
end
for _, obj in ipairs(workspace:GetDescendants()) do MakeTransparent(obj) end
end))
table.insert(_nukeOptimizerConns, workspace.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
task.defer(function()
if not _nukeOptimizerOn then return end
if IsBase(obj) then MakeTransparent(obj); return end
if IsClothing(obj) then
SafeDestroy(obj)
elseif IsInBase(obj) then
elseif IsCharacterPart(obj) then
elseif IsOutOfRange(obj) then
SafeDestroy(obj)
else
CleanObject(obj)
StripObject(obj)
end
end)
end))
table.insert(_nukeOptimizerConns, Lighting.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
if obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then SafeDestroy(obj) end
end))
table.insert(_nukeOptimizerConns, MaterialService.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
SafeDestroy(obj)
end))
for _, plr in ipairs(Players:GetPlayers()) do
OptimizeCharacter(plr.Character)
table.insert(_nukeOptimizerConns, plr.CharacterAdded:Connect(OptimizeCharacter))
end
table.insert(_nukeOptimizerConns, Players.PlayerAdded:Connect(function(plr)
table.insert(_nukeOptimizerConns, plr.CharacterAdded:Connect(OptimizeCharacter))
end))
table.insert(_nukeOptimizerThreads, task.spawn(function()
while _nukeOptimizerOn do
task.wait(15)
pcall(function() collectgarbage("collect") end)
end
end))
end
function disableNukeOptimizer()
_nukeOptimizerOn = false
nukeOptimiserEnabled = false
V.nukeOptEnabled = false
for _, c in ipairs(_nukeOptimizerConns) do pcall(function() c:Disconnect() end) end
_nukeOptimizerConns = {}
_nukeOptimizerThreads = {}
end

local _adaptStartPlayerESP = startPlayerESP
local _adaptStopPlayerESP = stopPlayerESP
M.toggleESP = function(on)
    M.playerESPEnabled = on == true
    THEME_ACCENT = M.currentAccent or THEME_ACCENT or Color3.fromRGB(58,128,245)
    if on then
        _adaptStartPlayerESP()
    else
        _adaptStopPlayerESP()
    end
end
M.enableNukeOptimizer = function()
    nukeOptimiserEnabled = true
    enableNukeOptimizer()
    M.nukeOptimiserEnabled = true
end
M.disableNukeOptimizer = function()
    disableNukeOptimizer()
    M.nukeOptimiserEnabled = false
end
if BoxedESPOptions then
    BoxedESPOptions.tracer = M.lineESPEnabled == true
    if refreshBoxedESP then refreshBoxedESP() end
end


-- ===== ESP Line Adapt recreada: implementación visible independiente =====
local AdaptVisibleLineESP = {enabled=false, lines={}, conn=nil}
local function adaptVisibleLineColor()
    local colors = M.ADAPT_THEME_COLORS or {
        PURPLE=Color3.fromRGB(160,40,255), BLUE=Color3.fromRGB(0,140,255),
        PINK=Color3.fromRGB(255,80,190), GREEN=Color3.fromRGB(0,200,110),
    }
    return colors[tostring(M.adaptThemeName or "BLUE"):upper()] or M.currentAccent or Color3.fromRGB(0,140,255)
end
local function adaptClearVisibleLines()
    for plr,line in pairs(AdaptVisibleLineESP.lines) do
        pcall(function() line.Visible=false; line:Remove() end)
        AdaptVisibleLineESP.lines[plr]=nil
    end
end
local function adaptUpdateVisibleLines()
    if not AdaptVisibleLineESP.enabled then return end
    local cam=workspace.CurrentCamera
    if not cam or not Drawing or not Drawing.new then return end
    local view=cam.ViewportSize
    local from=Vector2.new(view.X*0.5, view.Y-55)
    local color=adaptVisibleLineColor()
    local alive={}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char=plr.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            local head=char and char:FindFirstChild("Head")
            if root and head then
                local pos,onScreen=cam:WorldToViewportPoint(head.Position)
                local line=AdaptVisibleLineESP.lines[plr]
                if not line then
                    local ok,obj=pcall(function() return Drawing.new("Line") end)
                    if ok and obj then
                        line=obj; line.Thickness=2.5; line.Transparency=1; AdaptVisibleLineESP.lines[plr]=line
                    end
                end
                if line then
                    alive[plr]=true
                    line.Color=color
                    line.From=from
                    line.To=Vector2.new(pos.X,pos.Y)
                    line.Visible=onScreen and pos.Z>0
                end
            end
        end
    end
    for plr,line in pairs(AdaptVisibleLineESP.lines) do
        if not alive[plr] then pcall(function() line.Visible=false end) end
    end
end
function M.setAdaptLineESP(on)
    AdaptVisibleLineESP.enabled=on==true
    M.lineESPEnabled=AdaptVisibleLineESP.enabled
    if BoxedESPOptions then BoxedESPOptions.tracer=false end
    if cherryESPState then cherryESPState.LineESP=false end
    if AdaptVisibleLineESP.conn then AdaptVisibleLineESP.conn:Disconnect(); AdaptVisibleLineESP.conn=nil end
    adaptClearVisibleLines()
    if AdaptVisibleLineESP.enabled then
        if Drawing and Drawing.new then
            AdaptVisibleLineESP.conn=RunService.RenderStepped:Connect(adaptUpdateVisibleLines)
        elseif M.notify then pcall(function() M.notify("Drawing no está disponible para ESP Line") end) end
    end
end
M.setAdaptLineESP(M.lineESPEnabled==true)

M.saveConfig = savePrimeHubFeKlanConfig
M.loadConfig = loadPrimeHubFeKlanConfig

end)()