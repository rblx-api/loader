-- ============================================================
-- VYNX DUELS CON MENÚ SUREHUB
-- CÓDIGO COMPLETO
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer

do
    local g = (getgenv and getgenv()) or _G
    if g.__VYNX_UNLOAD then
        pcall(g.__VYNX_UNLOAD)
    end
    local function wipeGuis(parent)
        if not parent then return end
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("ScreenGui") then
                local n = child.Name
                if n:find("Vynx") or n:find("Movee") or n:find("Cherry") or n:find("Steal") or n:find("Shadow") then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
    pcall(function() wipeGuis(player:FindFirstChild("PlayerGui")) end)
    pcall(function() if gethui then wipeGuis(gethui()) end end)
    pcall(function() wipeGuis(game:GetService("CoreGui")) end)
end

local M = {}
M._allConns = {}
local function trackConn(conn)
    if conn then table.insert(M._allConns, conn) end
    return conn
end
M.trackConn = trackConn
M.MENU_CORNER_R = 16
M.DEFAULT_BG_ID = 78248012786524
M.DEFAULT_MOB_BTN_BG_ID = 92132591931954

M.introSoundEnabled = true
M.introGUIEnabled = true

M.INTRO_MUSIC_URL = "https://files.catbox.moe/qhpfe5.mp3"
M.INTRO_MUSIC_FILE = "VynxIntro_Music.mp3"
introSoundInstance = nil
if isfile and isfile("CherryConfig.json") then
    local ok, data = pcall(function() return HS:JSONDecode(readfile("CherryConfig.json")) end)
    if ok and type(data) == "table" then
        if data.introSoundEnabled ~= nil then M.introSoundEnabled = data.introSoundEnabled end
        if data.introGUIEnabled ~= nil then M.introGUIEnabled = data.introGUIEnabled end
        if type(data.Theme) == "string" then M._savedTheme = data.Theme end
        if type(data.colorScheme) == "string" then M._savedTheme = data.colorScheme end
    end
end

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
M.animPack = "Adidas Sports"
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
    if M.skinKeepOnRespawn then
        task.defer(function()
            M.applyAllCustomAccessories(char)
            if M.applyEnabledPresets then M.applyEnabledPresets(char) end
            M.applyCustomClothing(char)
        end)
    end
end

M.customAccessoryIds = M.customAccessoryIds or {} 
M.skinKeepOnRespawn = true

M.ACCESSORY_PRESETS = {
    { id = 9605378039,       name = "Acc 1" },
    { id = 87719366970131,   name = "Acc 2" },
    { id = 116598301380135,  name = "Acc 3" },
    { id = 82936472639935,   name = "Acc 4" },
    { id = 132323301214731,  name = "Acc 5" },
    { id = 108363680224601,  name = "Acc 6" },
    { id = 12796496795,      name = "Acc 7" },
}
M.presetAccessoryOn = M.presetAccessoryOn or {} 

function M.setPresetAccessory(id, on)
    id = tonumber(id)
    if not id then return end
    M.presetAccessoryOn = M.presetAccessoryOn or {}
    M.presetAccessoryOn[tostring(id)] = on and true or false
    if on then
        M.addCustomAccessoryId(id)
    else
        M.removeCustomAccessoryId(id)
    end
end

function M.applyEnabledPresets(char)
    char = char or player.Character
    if not char then return end
    M.presetAccessoryOn = M.presetAccessoryOn or {}
    for _, p in ipairs(M.ACCESSORY_PRESETS or {}) do
        if M.presetAccessoryOn[tostring(p.id)] then
            pcall(function() M.applyAccessoryId(p.id, char) end)
            task.wait(0.04)
        end
    end
end
M.customShirtId = nil   
M.customPantsId = nil   
M.bodySkinPreset = "None" 
M.bodySkinCustomRGB = {163, 162, 165}

M.BODY_SKIN_PRESETS = {
    ["None"] = nil,
    ["White"] = Color3.fromRGB(242, 243, 243),
    ["Black"] = Color3.fromRGB(27, 42, 53),
    ["Tan"] = Color3.fromRGB(204, 142, 105),
    ["Gray"] = Color3.fromRGB(163, 162, 165),
    ["Red"] = Color3.fromRGB(196, 40, 28),
    ["Blue"] = Color3.fromRGB(13, 105, 172),
    ["Custom"] = "custom",
}

local BODY_PART_NAMES = {
    "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg",
    "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand",
    "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg",
    "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot",
}

function M.clearVynxAccessories(char)
    char = char or player.Character
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if (child:IsA("Accessory") or child:IsA("Hat")) and child:GetAttribute("VynxSkin") then
            pcall(function() child:Destroy() end)
        end
    end
end

function M.applyAccessoryId(id, char)
    id = tonumber(id)
    if not id or id <= 0 then return false, "Invalid ID" end
    char = char or player.Character
    if not char then return false, "No character" end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false, "No humanoid" end

    for _, child in ipairs(char:GetChildren()) do
        if (child:IsA("Accessory") or child:IsA("Hat")) and child:GetAttribute("VynxSkin") == id then
            return true, "Already applied"
        end
    end

    local ok, err = pcall(function()
        local InsertService = game:GetService("InsertService")
        local model = InsertService:LoadAsset(id)
        if not model then error("LoadAsset failed") end
        local acc = model:FindFirstChildOfClass("Accessory")
            or model:FindFirstChildOfClass("Hat")
            or model:FindFirstChildWhichIsA("Accessory", true)
            or model:FindFirstChildWhichIsA("Hat", true)
        if not acc then
            for _, c in ipairs(model:GetChildren()) do
                if c:IsA("Accessory") or c:IsA("Hat") then acc = c; break end
                if c:IsA("Model") then
                    acc = c:FindFirstChildOfClass("Accessory") or c:FindFirstChildOfClass("Hat")
                    if acc then break end
                end
            end
        end
        if not acc then
            model:Destroy()
            error("No Accessory found in asset " .. tostring(id))
        end
        acc.Name = "VynxAcc_" .. tostring(id)
        acc:SetAttribute("VynxSkin", id)
        local handle = acc:FindFirstChild("Handle")
        if handle and handle:IsA("BasePart") then
            handle.CanCollide = false
        end
        hum:AddAccessory(acc)
        pcall(function() model:Destroy() end)
    end)

    if not ok then
        local ok2 = pcall(function()
            local desc = Instance.new("HumanoidDescription")
            error(tostring(err))
        end)
        return false, tostring(err)
    end
    return true, "OK"
end

function M.applyAllCustomAccessories(char)
    char = char or player.Character
    if not char then return end
    if not M.customAccessoryIds or #M.customAccessoryIds == 0 then return end
    for _, id in ipairs(M.customAccessoryIds) do
        pcall(function() M.applyAccessoryId(id, char) end)
        task.wait(0.05)
    end
end

function M.addCustomAccessoryId(id)
    id = tonumber(id)
    if not id or id <= 0 then return false end
    M.customAccessoryIds = M.customAccessoryIds or {}
    for _, existing in ipairs(M.customAccessoryIds) do
        if existing == id then
            M.applyAccessoryId(id)
            return true
        end
    end
    table.insert(M.customAccessoryIds, id)
    M.applyAccessoryId(id)
    return true
end

function M.removeCustomAccessoryId(id)
    id = tonumber(id)
    if not id then return end
    local newList = {}
    for _, existing in ipairs(M.customAccessoryIds or {}) do
        if existing ~= id then table.insert(newList, existing) end
    end
    M.customAccessoryIds = newList
    local char = player.Character
    if char then
        for _, child in ipairs(char:GetChildren()) do
            if (child:IsA("Accessory") or child:IsA("Hat")) and child:GetAttribute("VynxSkin") == id then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

function M.clearAllCustomAccessories()
    M.customAccessoryIds = {}
    M.clearVynxAccessories(player.Character)
end

function M.applyCustomClothing(char)
    char = char or player.Character
    if not char then return end
    if M.customShirtId then
        local shirt = char:FindFirstChildOfClass("Shirt")
        if not shirt then
            shirt = Instance.new("Shirt")
            shirt.Name = "VynxShirt"
            shirt:SetAttribute("VynxSkin", true)
            shirt.Parent = char
        end
        pcall(function()
            shirt.ShirtTemplate = "rbxassetid://" .. tostring(M.customShirtId)
        end)
    end
    if M.customPantsId then
        local pants = char:FindFirstChildOfClass("Pants")
        if not pants then
            pants = Instance.new("Pants")
            pants.Name = "VynxPants"
            pants:SetAttribute("VynxSkin", true)
            pants.Parent = char
        end
        pcall(function()
            pants.PantsTemplate = "rbxassetid://" .. tostring(M.customPantsId)
        end)
    end
end

function M.clearCustomClothing(char)
    char = char or player.Character
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if (child:IsA("Shirt") or child:IsA("Pants")) and child:GetAttribute("VynxSkin") then
            pcall(function() child:Destroy() end)
        end
    end
    M.customShirtId = nil
    M.customPantsId = nil
end

function M.applyBodySkin(char)
    return
end

function M.setBodySkinPreset(name)
    M.bodySkinPreset = "None"
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.15)
    M.applyCharterToChar(char)
end)

do
    local _charterAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        if not (M.headlessEnabled or M.korbloxEnabled) then return end
        _charterAcc = _charterAcc + dt
        if _charterAcc < 0.5 then return end
        _charterAcc = 0
        local char = player.Character
        if char then M.applyCharterToChar(char) end
    end)
end

M.NS = 60
M.CS = 30
M.LAGGER_SPEED = 15
M.LAGGER_CARRY_SPEED = 24.5
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
M.speedBoosterEnabled = true
M.speedBoosterPath = "Normal" 
M.speedBoosterPanelOpen = true
M.speedBoosterPos = nil
M.speedBoosterGui = nil
M.speedBoosterMain = nil
M.speedUIMode = "Original" 

M.antiRagdollEnabled = false
M.antiRagdollMode = "Splatter"
M.ragdollTPBaseEnabled = false
M.ragdollTPBaseRange = 50
M.ragdollTPBaseCooldown = 1.5
M._ragdollTPLast = 0
M._ragdollTPConn = nil
M._ragdollTPCharConn = nil
M.infJumpEnabled = false
M.infJumpMode = "hold"
M.medusaCounterEnabled = false
M.batCounterEnabled = false
M.unwalkEnabled = false
M.medusaResetEnabled = false
M.medusaResetDelay = 0.45
M._medusaResetPending = false
M.medusaDebounce = false
M.medusaLastUsed = 0
M.dropActive = false
M.autoLeftEnabled = false
M.autoRightEnabled = false
M.autoPlayEnabled = false 
M.autoPlayLockedDir = nil 
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
M.mobileButtonShape = "Normal" 
M.mobBtnRefs = {}
M.mobGuiRef = nil
M.fovValue = 80
M.fovOptions = {80,120,180}
M.fovIndex = 1
M.laggerModePillRef = nil
M.carryModePillRef = nil
M.autoSwitchSpeedEnabled = false
M._autoSwitchWasSteal = false
M.autoTurnOffSpeedEnabled = false
M.autoSwitchLaggerSpeedEnabled = false
M.autoCarryEnemyBaseEnabled = false
M.autoCarryEnemyBaseRange = 35
M._autoCarryEnemyBaseConn = nil
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
M.antiDieEnabled = true 
M.antiDieConn = nil
M._antiDieCharConn = nil
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
M.holdInfJumpConn = nil
M.DROP_ASCEND_DURATION = 0.2
M.DROP_ASCEND_SPEED = 150
M.autoResetOnDeath = false
M.bypassAimbotEnabled = false
M.AUTO_BAT_V2_SPEED = 60
M.AUTO_BAT_V2_DIST = 1.0
M.AUTO_BAT_V2_HEIGHT = 1.5
M.AUTO_BAT_V2_V_OFF = 0.0
M.AUTO_BAT_V2_HIT_DIST = 4.5
M.AUTO_BAT_V2_SWING_CD = 0.08
M._batV2HitCooldown = false
M.bodyLockEnabled = false 
M.bodyLockRadius = 20
M.bodyLockConn = nil
M.hardHitEnabled = false
M.hardHitRadius = 10
M._hardHitRing = nil
M._hardHitConn = nil
M.ultraModeEnabled = false
M.antiDesyncPanelOpen = false
M.antiDesyncShield = false
M.antiDesyncVelocity = false
M.antiDesyncUiLocked = false
M.antiDesyncMinimized = false
M.antiDesyncGui = nil
M.antiDesyncMain = nil
M.antiDesyncPill = nil
M.antiDesyncConn = nil
M.musicPanelOpen = false
M.musicGui = nil
M.musicMain = nil
M.musicPill = nil
M.musicSound = nil
M.musicLastTrackId = nil
M.musicVolume = 0.8
M.musicWasPlaying = false
M.musicPanelPos = nil 
M.menuPos = nil
M.pingPanelPos = nil
M.vynxLaggerPanelPos = nil

M.pingPanelOpen = false
M.pingGui = nil
M.pingMain = nil
M.pingSettings = nil
M.pingActive = false
M.pingPower = 100000
M.pingInterval = 0.125
M.pingKeybindKb = "F"
M.pingKeybindGp = "ButtonR2"
M.pingAutoBrainrot = true

M.vynxLaggerPanelOpen = false
M.vynxLaggerGui = nil
M.vynxLaggerMain = nil
M.vynxLaggerSettings = nil
M.vynxLaggerActive = false
M.vynxLaggerLevel = "Mid" 
M.vynxLaggerKeybindKb = "V"
M.vynxLaggerKeybindGp = "None"
M.vynxLaggerLoopRunning = false
M.vynxLaggerRemote = nil
M.vynxLaggerListening = nil
M.VYNX_LAGGER_LEVELS = {
    Low  = { mode = "bless", poder = 25,  wait = 0.20 },
    Mid  = { mode = "bless", poder = 32,  wait = 0.18 },
    High = { mode = "bless", poder = 70,  wait = 0.16 },
}
M.pingRemote = nil
M.pingBrainrotMode = false
M.pingLastBrainrot = false
M.pingManualOverride = false
M.pingListening = nil
M.pingLoopRunning = false
M.musicTracks = {
    { name = "Billy Jean", id = 116197983114890 },
    { name = "Misery", id = 72740886806799 },
    { name = "Pretty hoe", id = 72892187453679 },
    { name = "Juice world", id = 116675448257664 },
    { name = "NBA yb", id = 6610531667026 },
    { name = "King von", id = 92784642779370 },
    { name = "Heather", id = 114031354430003 },
    { name = "Kodak", id = 7705363631070423 },
    { name = "Sosa", id = 128193661245797 },
    { name = "Yb Nevada", id = 92826410241810 },
    { name = "Kempachi", id = 97754558403570 },
    { name = "Booyah", id = 74411243854757 },
    { name = "Minds", id = 32789008740748 },
    { name = "Earrings", id = 94574184618707 },
    { name = "Queen st", id = 121093914989022 },
    { name = "Hex", id = 93460325674434 },
    { name = "I love", id = 121800400764624 },
    { name = "To late", id = 91309633236834 },
    { name = "Headclock", id = 121327265405582 },
    { name = "Jane", id = 120534517493665 },
    { name = "Hot,cold", id = 101255099020837 },
    { name = "Legacy", id = 107145145396784 },
    { name = "Think abt u", id = 74567741664348 },
    { name = "To the o", id = 86370168350239 },
    { name = "Want u", id = 138067913536122 },
    { name = "Uzi vert", id = 85184181353881 },
    { name = "Anime thighs", id = 115111509672428 },
    { name = "Eve Where I go", id = 87341155169406 },
    { name = "Baby chief", id = 129270149145441 },
}
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

M.stealMode = "Normal"
M.stealBarSize = 520
M.Steal = {
    AutoStealEnabled = false,
    StealRadius = 62,
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
    return M.autoRadiusEnabled and M.getAutoRadius() or M.Steal.StealRadius
end
M.Semi = {
    enabled = false,
    holdMin = 1.3,
    holdMax = 2.6,
    entryDelay = 0.3,
    cooldown = 0.05,
    primeRange = 80,
    radius = 8, 
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
M.playerESPEnabled = false
M.espList = {}
M.pingPopupActive = false
M.pingPopupGui = nil
M.pingCycleTimer = nil
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

M.KB = {
    DropBrainrot={kb=nil,gp=nil},
    AutoLeft={kb=nil,gp=nil},
    AutoRight={kb=nil,gp=nil},
    AutoBat={kb=nil,gp=nil},
    TPFloor={kb=nil,gp=nil},
    GuiHide={kb=nil,gp=nil},
    SpeedToggle={kb=nil,gp=nil},
    LaggerToggle={kb=nil,gp=nil},
    LaggerCarry={kb=nil,gp=nil},
    BypassAimbot={kb=nil,gp=nil},
    BodyLock={kb=nil,gp=nil},
    InstaReset={kb=nil,gp=nil},
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
M.setBodyLockVisual = nil
M.setHardHitVisual = nil
M.setUltraModeVisual = nil
M._autoSwitchWasSteal = false

M.MOB_POS_FILE = "moveeduels_btnpos.json"
M._btnPosCache = nil
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
M.menuOpen = true
M.speedESPEnabled = false

M.statusGui = nil
M.statusFill = nil
M.statusPctLbl = nil
M.statusRadiusLbl = nil
M.statusDot = nil
M.statusMain = nil
M.statusFpsLbl = nil

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
        if _acc < 0.15 then return end
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

M.avatarESPEnabled = true
M.avatarESPList = {}
M.AVATAR_ESP_SIZE = 56
M.AVATAR_ESP_OFFSET = Vector3.new(0, 3.4, 0)

function M.getPlayerAvatarThumb(userId)
    local ok, content = pcall(function()
        return Players:GetUserThumbnailAsync(
            userId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
    end)
    if ok and content then return content end
    return "rbxasset://textures/ui/GuiImagePlaceholder.png"
end

function M.addAvatarESP(plr)
    if not plr or plr == player then return end
    if M.avatarESPList[plr] then
        local data = M.avatarESPList[plr]
        local char = plr.Character
        local head = char and char:FindFirstChild("Head")
        if data.bb and head and data.bb.Adornee ~= head then
            data.bb.Adornee = head
            data.bb.Parent = head
        end
        return
    end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local old = head:FindFirstChild("VynxAvatarCircleESP")
    if old then pcall(function() old:Destroy() end) end

    local size = tonumber(M.AVATAR_ESP_SIZE) or 56
    local bb = Instance.new("BillboardGui")
    bb.Name = "VynxAvatarCircleESP"
    bb.Size = UDim2.fromOffset(size, size)
    bb.StudsOffset = M.AVATAR_ESP_OFFSET or Vector3.new(0, 3.4, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 250
    bb.Adornee = head
    bb.Parent = head

    local ring = Instance.new("Frame")
    ring.Name = "Ring"
    ring.Size = UDim2.fromScale(1, 1)
    ring.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    ring.BackgroundTransparency = 0.15
    ring.BorderSizePixel = 0
    ring.Parent = bb
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke")
    stroke.Color = (M.Theme and M.Theme.Accent) or M.UI_ACCENT or Color3.fromRGB(180, 80, 255)
    stroke.Thickness = 2.2
    stroke.Transparency = 0.15
    stroke.Parent = ring

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.AnchorPoint = Vector2.new(0.5, 0.5)
    avatar.Position = UDim2.fromScale(0.5, 0.5)
    avatar.Size = UDim2.fromScale(0.82, 0.82)
    avatar.BackgroundTransparency = 1
    avatar.BorderSizePixel = 0
    avatar.ScaleType = Enum.ScaleType.Crop
    avatar.Image = M.getPlayerAvatarThumb(plr.UserId)
    avatar.Parent = ring
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

    local nameTag = Instance.new("TextLabel")
    nameTag.Name = "NameTag"
    nameTag.AnchorPoint = Vector2.new(0.5, 0)
    nameTag.Position = UDim2.new(0.5, 0, 1, 2)
    nameTag.Size = UDim2.new(0, 90, 0, 14)
    nameTag.BackgroundTransparency = 1
    nameTag.Text = plr.DisplayName or plr.Name
    nameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameTag.TextStrokeTransparency = 0.4
    nameTag.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameTag.Font = Enum.Font.GothamBold
    nameTag.TextSize = 11
    nameTag.TextScaled = false
    nameTag.Parent = bb

    local charConn
    charConn = plr.CharacterAdded:Connect(function(newChar)
        task.wait(0.35)
        if not M.avatarESPEnabled then return end
        M.removeAvatarESP(plr)
        M.addAvatarESP(plr)
    end)

    M.avatarESPList[plr] = {bb = bb, ring = ring, avatar = avatar, stroke = stroke, conn = charConn}
end

function M.removeAvatarESP(plr)
    local data = M.avatarESPList and M.avatarESPList[plr]
    if not data then return end
    if data.conn then pcall(function() data.conn:Disconnect() end) end
    if data.bb then pcall(function() data.bb:Destroy() end) end
    M.avatarESPList[plr] = nil
end

function M.clearAvatarESP()
    for plr, _ in pairs(M.avatarESPList or {}) do
        M.removeAvatarESP(plr)
    end
end

function M.refreshAllAvatarESP()
    if not M.avatarESPEnabled then
        M.clearAvatarESP()
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            pcall(function() M.addAvatarESP(plr) end)
        end
    end
end

function M.toggleAvatarESP(on)
    M.avatarESPEnabled = on and true or false
    if M.avatarESPEnabled then
        M.refreshAllAvatarESP()
        if not M._avatarESPPlayerAdded then
            M._avatarESPPlayerAdded = Players.PlayerAdded:Connect(function(p)
                if p == player or not M.avatarESPEnabled then return end
                p.CharacterAdded:Connect(function()
                    task.wait(0.4)
                    if M.avatarESPEnabled then M.addAvatarESP(p) end
                end)
                if p.Character then
                    task.defer(function()
                        task.wait(0.3)
                        if M.avatarESPEnabled then M.addAvatarESP(p) end
                    end)
                end
            end)
            M.trackConn(M._avatarESPPlayerAdded)
        end
        if not M._avatarESPPlayerRemoving then
            M._avatarESPPlayerRemoving = Players.PlayerRemoving:Connect(function(p)
                M.removeAvatarESP(p)
            end)
            M.trackConn(M._avatarESPPlayerRemoving)
        end
    else
        M.clearAvatarESP()
    end
end

M.vynxDetectEnabled = false
M.vynxDetectList = {}
function M.tagLocalAsVynx(...) end
function M.isPlayerUsingVynx(...) return false end
function M.removeVynxDetect(...) end
function M.clearVynxDetect() end
function M.addVynxDetect(...) end
function M.refreshVynxDetectLabels() end
function M.toggleVynxDetect(on)
    M.vynxDetectEnabled = false
    M.clearVynxDetect()
end

M.headIndicator = nil

function M.setupHeadIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    if head:FindFirstChild("MoveeHeadIndicator") then head.MoveeHeadIndicator:Destroy() end
    local bb=Instance.new("BillboardGui",head)
    bb.Name="MoveeHeadIndicator"
    bb.Size=UDim2.new(0,280,0,88)
    bb.StudsOffset=Vector3.new(0,3.5,0)
    bb.AlwaysOnTop=true
    bb.Parent=head

    local accent = (M.Theme and M.Theme.Accent) or CHERRY_ACCENT or Color3.fromRGB(255,255,255)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local STROKE = Color3.fromRGB(0, 0, 0)

    local function styleThick(lbl, col)
        lbl.TextColor3 = col
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextScaled = true
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = STROKE
        local ts = Instance.new("UITextSizeConstraint")
        ts.MinTextSize = 12
        ts.MaxTextSize = 28
        ts.Parent = lbl
    end

    local ragdollLbl=Instance.new("TextLabel",bb)
    ragdollLbl.Name="RagdollTimer"
    ragdollLbl.Size=UDim2.new(1,0,0.32,0)
    ragdollLbl.Position=UDim2.new(0,0,0,0)
    ragdollLbl.BackgroundTransparency=1
    ragdollLbl.Text=""
    styleThick(ragdollLbl, accent)

    local discordLbl=Instance.new("TextLabel",bb)
    discordLbl.Name="Discord"
    discordLbl.Size=UDim2.new(1,0,0.34,0)
    discordLbl.Position=UDim2.new(0,0,0.30,0)
    discordLbl.BackgroundTransparency=1
    discordLbl.Text="discord.gg/vynxduels"
    styleThick(discordLbl, accent)

    local speedLbl=Instance.new("TextLabel",bb)
    speedLbl.Name="Speed"
    speedLbl.Size=UDim2.new(0.38,0,0.34,0)
    speedLbl.Position=UDim2.new(0.02,0,0.64,0)
    speedLbl.BackgroundTransparency=1
    speedLbl.Text="0.0"
    speedLbl.TextXAlignment=Enum.TextXAlignment.Right
    styleThick(speedLbl, WHITE)

    local modeLbl=Instance.new("TextLabel",bb)
    modeLbl.Name="Mode"
    modeLbl.Size=UDim2.new(0.56,0,0.34,0)
    modeLbl.Position=UDim2.new(0.42,0,0.64,0)
    modeLbl.BackgroundTransparency=1
    modeLbl.Text="NORMAL MODE"
    modeLbl.TextXAlignment=Enum.TextXAlignment.Left
    styleThick(modeLbl, WHITE)

    M.headIndicator = {bb=bb, discord=discordLbl, speed=speedLbl, mode=modeLbl, ragdollTimer=ragdollLbl, divider=nil}
    M.updateHeadTheme()
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.updateHeadTheme()
    if not M.headIndicator then return end
    local name = (M.Theme and M.Theme.Name) or (CherryConfig and CherryConfig.Theme) or M.colorScheme or M._savedTheme or "White"
    local accent = (M.Theme and M.Theme.Accent) or M.UI_ACCENT or UI_ACCENT or Color3.fromRGB(255,255,255)
    if name == "White" or name == "Default" then
        accent = Color3.fromRGB(255, 255, 255)
    elseif CHERRY_THEMES and CHERRY_THEMES[name] and CHERRY_THEMES[name].Accent then
        accent = CHERRY_THEMES[name].Accent
    end
    local STROKE = Color3.fromRGB(0, 0, 0)
    local function paint(lbl, col)
        if not lbl then return end
        lbl.TextColor3 = col
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = STROKE
    end
    paint(M.headIndicator.discord, accent)
    paint(M.headIndicator.ragdollTimer, accent)
    paint(M.headIndicator.speed, Color3.fromRGB(255, 255, 255))
    paint(M.headIndicator.mode, Color3.fromRGB(255, 255, 255))
    if M.headIndicator.divider then
        pcall(function() M.headIndicator.divider:Destroy() end)
        M.headIndicator.divider = nil
    end
end

local speedUpdateConn = nil
function M.startHeadSpeedUpdates()
    if speedUpdateConn then return end
    local _acc = 0
    speedUpdateConn = RunService.Heartbeat:Connect(function(dt)
        _acc = _acc + dt
        if _acc < 0.12 then return end
        _acc = 0
        if not (M.headIndicator and M.headIndicator.speed) then return end
        local displaySpeed
        if M.autoLeftEnabled or M.autoRightEnabled then
            displaySpeed = M.NS
        else
            displaySpeed = M.getActiveMoveSpeed()
        end
        M.headIndicator.speed.Text = string.format("%.1f", displaySpeed)
        if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
    end)
end

function M.stopHeadSpeedUpdates()
    if speedUpdateConn then
        speedUpdateConn:Disconnect()
        speedUpdateConn = nil
    end
end

function M.buildStatusUI()
    if M.statusGui then
        pcall(function() M.statusGui:Destroy() end)
        M.statusGui = nil
    end

    local accent = (M.Theme and M.Theme.Accent) or M.UI_ACCENT or UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(165, 75, 255)
    local barW = math.clamp(tonumber(M.stealBarSize) or 520, 380, 1000)

    local gui = Instance.new("ScreenGui")
    gui.Name = "StealProgressWindow"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 50

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
        if v ~= gui and v:IsA("ScreenGui") and (
            v.Name == gui.Name or v.Name == "VynxStatusUI" or v.Name == "K7_StatusUI"
            or v.Name == "VynxDuelsV21" or v.Name == "StealProgressWindow"
        ) then
            pcall(function() v:Destroy() end)
        end
    end

    local holder = Instance.new("Frame")
    holder.Name = "StealBarHolder"
    holder.Size = UDim2.new(0, barW, 0, 92)
    holder.Position = UDim2.new(0.5, -math.floor(barW / 2), 1, -110)
    holder.BackgroundTransparency = 1
    holder.Active = true
    holder.Parent = gui

    local main = Instance.new("Frame")
    main.Name = "StealBar"
    main.Size = UDim2.new(1, 0, 1, 0)
    main.Position = UDim2.new(0, 0, 0, 0)
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    main.BackgroundTransparency = 0.08
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Parent = holder
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

    local bgGrad = Instance.new("UIGradient")
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 29)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(11, 11, 15)),
    })
    bgGrad.Parent = main

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Name = "MainStroke"
    mainStroke.Color = accent
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.6
    mainStroke.Parent = main

    do
        local id = tonumber(M.customBgId) or tonumber(M.DEFAULT_BG_ID)
        if id and id > 0 then
            local bg = Instance.new("ImageLabel")
            bg.Name = "CustomBgImage"
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.BackgroundTransparency = 1
            bg.Image = "rbxassetid://" .. tostring(id)
            bg.ScaleType = Enum.ScaleType.Crop
            bg.ImageTransparency = tonumber(M.customBgOpacity) or 0.5
            bg.ZIndex = 0
            bg.Parent = main
            Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 16)
        end
    end

    local topGlow = Instance.new("Frame")
    topGlow.Name = "TopGlow"
    topGlow.Size = UDim2.new(1, -40, 0, 1)
    topGlow.Position = UDim2.new(0, 20, 0, 0)
    topGlow.BackgroundColor3 = accent
    topGlow.BackgroundTransparency = 0.55
    topGlow.BorderSizePixel = 0
    topGlow.ZIndex = 7
    topGlow.Parent = main
    local topGlowGrad = Instance.new("UIGradient")
    topGlowGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.45),
        NumberSequenceKeypoint.new(1, 1),
    })
    topGlowGrad.Parent = topGlow

    local dotRing = Instance.new("Frame")
    dotRing.Size = UDim2.fromOffset(30, 30)
    dotRing.Position = UDim2.fromOffset(14, 18)
    dotRing.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    dotRing.BorderSizePixel = 0
    dotRing.ZIndex = 6
    dotRing.Parent = main
    Instance.new("UICorner", dotRing).CornerRadius = UDim.new(1, 0)
    local ringStroke = Instance.new("UIStroke")
    ringStroke.Color = Color3.fromRGB(160, 160, 175)
    ringStroke.Thickness = 1
    ringStroke.Transparency = 0.5
    ringStroke.Parent = dotRing
    local dot = Instance.new("Frame")
    dot.Name = "StatusDot"
    dot.Size = UDim2.fromOffset(10, 10)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.fromScale(0.5, 0.5)
    dot.BackgroundColor3 = Color3.fromRGB(150, 150, 162)
    dot.BorderSizePixel = 0
    dot.ZIndex = 7
    dot.Parent = dotRing
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local dotScale = Instance.new("UIScale")
    dotScale.Parent = dot
    local dotThread = nil
    local function startDotPulse()
        if dotThread then return end
        dotThread = task.spawn(function()
            while dotThread ~= nil and main.Parent do
                pcall(function()
                    local up = TweenService:Create(dotScale, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Scale = 1.22})
                    up:Play()
                    up.Completed:Wait()
                    local dn = TweenService:Create(dotScale, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Scale = 1})
                    dn:Play()
                    dn.Completed:Wait()
                end)
            end
            if not main.Parent then dotThread = nil end
        end)
    end
    startDotPulse()

    local pctLbl = Instance.new("TextLabel")
    pctLbl.Name = "PctLabel"
    pctLbl.BackgroundTransparency = 1
    pctLbl.Position = UDim2.fromOffset(54, 20)
    pctLbl.Size = UDim2.fromOffset(140, 30)
    pctLbl.Font = Enum.Font.GothamBlack
    pctLbl.TextSize = 26
    pctLbl.TextColor3 = Color3.fromRGB(235, 235, 240)
    pctLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    pctLbl.TextStrokeTransparency = 0.35
    pctLbl.TextXAlignment = Enum.TextXAlignment.Left
    pctLbl.Text = "0%"
    pctLbl.ZIndex = 8
    pctLbl.Parent = main
    M.statusBarPctLbl = pctLbl

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Name = "StatusSub"
    statusLbl.BackgroundTransparency = 1
    statusLbl.Position = UDim2.fromOffset(54, 48)
    statusLbl.Size = UDim2.fromOffset(160, 14)
    statusLbl.Font = Enum.Font.GothamMedium
    statusLbl.TextSize = 11
    statusLbl.TextColor3 = Color3.fromRGB(150, 150, 162)
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.Text = "IDLE"
    statusLbl.ZIndex = 8
    statusLbl.Parent = main
    M.statusSubLbl = statusLbl

    local brandPill = Instance.new("Frame")
    brandPill.Name = "BrandPill"
    brandPill.Size = UDim2.fromOffset(88, 18)
    brandPill.AnchorPoint = Vector2.new(1, 0)
    brandPill.Position = UDim2.new(1, -14, 0, 8)
    brandPill.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
    brandPill.BackgroundTransparency = 0.5
    brandPill.BorderSizePixel = 0
    brandPill.ZIndex = 7
    brandPill.Parent = main
    Instance.new("UICorner", brandPill).CornerRadius = UDim.new(1, 0)
    local brandLbl = Instance.new("TextLabel")
    brandLbl.Name = "BrandLabel"
    brandLbl.BackgroundTransparency = 1
    brandLbl.Size = UDim2.new(1, 0, 1, 0)
    brandLbl.Font = Enum.Font.GothamMedium
    brandLbl.TextSize = 8.5
    brandLbl.TextColor3 = Color3.fromRGB(150, 150, 162)
    brandLbl.TextXAlignment = Enum.TextXAlignment.Center
    brandLbl.Text = "VYNX DUELS"
    brandLbl.ZIndex = 8
    brandLbl.Parent = brandPill

    local modeLbl = Instance.new("TextLabel")
    modeLbl.Name = "ModeLabel"
    modeLbl.BackgroundTransparency = 1
    modeLbl.AnchorPoint = Vector2.new(1, 0)
    modeLbl.Position = UDim2.new(1, -14, 0, 32)
    modeLbl.Size = UDim2.fromOffset(120, 12)
    modeLbl.Font = Enum.Font.GothamMedium
    modeLbl.TextSize = 10
    modeLbl.TextColor3 = Color3.fromRGB(105, 105, 118)
    modeLbl.TextXAlignment = Enum.TextXAlignment.Right
    local modeText = tostring(M.stealMode or "Normal")
    if modeText == "V1" then modeText = "Normal" end
    modeLbl.Text = string.upper(modeText)
    modeLbl.ZIndex = 8
    modeLbl.Parent = main
    M.statusModeLbl = modeLbl

    local infoLbl = Instance.new("TextLabel")
    infoLbl.Name = "InfoLabel"
    infoLbl.BackgroundTransparency = 1
    infoLbl.AnchorPoint = Vector2.new(1, 0)
    infoLbl.Position = UDim2.new(1, -14, 0, 50)
    infoLbl.Size = UDim2.fromOffset(160, 12)
    infoLbl.Font = Enum.Font.GothamMedium
    infoLbl.TextSize = 10
    infoLbl.TextColor3 = Color3.fromRGB(105, 105, 118)
    infoLbl.TextXAlignment = Enum.TextXAlignment.Right
    infoLbl.Text = "FPS 0 · PING 0ms"
    infoLbl.ZIndex = 8
    infoLbl.Parent = main
    M.statusFpsLbl = infoLbl
    M.statusPingLbl = infoLbl

    local radiusLabel = Instance.new("TextLabel")
    radiusLabel.Visible = false
    radiusLabel.Text = "Radius: 62"
    radiusLabel.Parent = main
    M.statusRadiusLbl = radiusLabel

    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Position = UDim2.new(0, 18, 1, -22)
    track.Size = UDim2.new(1, -36, 0, 14)
    track.BackgroundColor3 = Color3.fromRGB(4, 4, 7)
    track.BackgroundTransparency = 0.35
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.ZIndex = 7
    track.Parent = main
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local trackStroke = Instance.new("UIStroke")
    trackStroke.Color = Color3.fromRGB(255, 255, 255)
    trackStroke.Thickness = 0.8
    trackStroke.Transparency = 0.85
    trackStroke.Parent = track

    local fillGlow = Instance.new("Frame")
    fillGlow.Name = "FillGlow"
    fillGlow.Size = UDim2.fromScale(0, 1)
    fillGlow.BackgroundColor3 = accent
    fillGlow.BackgroundTransparency = 0.8
    fillGlow.BorderSizePixel = 0
    fillGlow.ZIndex = 6
    fillGlow.Parent = track
    Instance.new("UICorner", fillGlow).CornerRadius = UDim.new(1, 0)

    local progressFill = Instance.new("Frame")
    progressFill.Name = "Fill"
    progressFill.Size = UDim2.fromScale(0, 1)
    progressFill.BackgroundColor3 = accent
    progressFill.BorderSizePixel = 0
    progressFill.ClipsDescendants = true
    progressFill.ZIndex = 7
    progressFill.Parent = track
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient")
    fillGrad.Rotation = 0
    fillGrad.Parent = progressFill
    M.statusFill = progressFill

    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.fromOffset(16, 16)
    knob.AnchorPoint = Vector2.new(1, 0.5)
    knob.Position = UDim2.fromScale(1, 0.5)
    knob.BackgroundColor3 = Color3.fromRGB(160, 160, 175)
    knob.BorderSizePixel = 0
    knob.ZIndex = 8
    knob.Parent = progressFill
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local sheen = Instance.new("Frame")
    sheen.Name = "Sheen"
    sheen.Size = UDim2.fromOffset(40, 8)
    sheen.Position = UDim2.fromScale(-0.4, 0)
    sheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sheen.BackgroundTransparency = 0.6
    sheen.BorderSizePixel = 0
    sheen.ZIndex = 8
    sheen.Parent = progressFill
    local sheenGrad = Instance.new("UIGradient")
    sheenGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.7),
        NumberSequenceKeypoint.new(1, 1),
    })
    sheenGrad.Parent = sheen
    local shimmerThread = nil
    local function startShimmer()
        if shimmerThread then return end
        shimmerThread = task.spawn(function()
            while shimmerThread ~= nil and main.Parent and sheen.Parent do
                pcall(function()
                    local fw = TweenService:Create(sheen, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.fromScale(1.4, 0)})
                    fw:Play()
                    fw.Completed:Wait()
                end)
                if shimmerThread == nil or not main.Parent or not sheen.Parent then break end
                pcall(function()
                    local bk = TweenService:Create(sheen, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.fromScale(-0.4, 0)})
                    bk:Play()
                    bk.Completed:Wait()
                end)
            end
            if not main.Parent or not sheen.Parent then shimmerThread = nil end
        end)
    end
    local function stopShimmer()
        if shimmerThread then
            task.cancel(shimmerThread)
            shimmerThread = nil
        end
    end
    startShimmer()

    do
        local frameCount, timeAccum = 0, 0
        local fpsConn
        fpsConn = RunService.RenderStepped:Connect(function(delta)
            if not gui.Parent then
                if fpsConn then fpsConn:Disconnect() end
                return
            end
            frameCount = frameCount + 1
            timeAccum = timeAccum + delta
            if timeAccum >= 0.5 then
                local fps = math.floor(frameCount / timeAccum + 0.5)
                frameCount, timeAccum = 0, 0
                local ping = 0
                pcall(function()
                    ping = math.floor(player:GetNetworkPing() * 1000 + 0.5)
                end)
                if infoLbl and infoLbl.Parent then
                    infoLbl.Text = ("FPS %d · PING %dms"):format(fps, ping)
                end
            end
        end)
    end

    do
        local dragging, dragStart, startPos
        local function beginDrag(input)
            if M.uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = holder.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end
        holder.InputBegan:Connect(beginDrag)
        main.InputBegan:Connect(beginDrag)
        UIS.InputChanged:Connect(function(input)
            if M.uiLocked then dragging = false return end
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - dragStart
                holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    M.statusGui = gui
    M.statusMain = main
    M.statusDot = dot
    M.statusHolder = holder
    M.statusPctLbl = pctLbl

    M.updateRadiusMarker = function()
        if M.statusRadiusLbl then
            local r = 62
            pcall(function()
                r = (M.getActiveStealRadius and M.getActiveStealRadius()) or (M.Steal and M.Steal.StealRadius) or 62
            end)
            M.statusRadiusLbl.Text = string.format("Radius: %.2g", r)
        end
        if M.statusModeLbl then
            local mt = tostring(M.stealMode or "Normal")
            if mt == "V1" then mt = "Normal" end
            M.statusModeLbl.Text = string.upper(mt)
        end
    end
    M.updateRadiusMarker()

    if M.applyStealBarTheme then
        pcall(function() M.applyStealBarTheme(accent) end)
    end
end

function M.updateStealProgress(progress, label)
    progress = math.clamp(progress or 0, 0, 1)
    local pct = math.floor(progress * 100 + 0.5)
    local accent = (M.Theme and M.Theme.Accent) or M.UI_ACCENT or UI_ACCENT or Color3.fromRGB(165, 75, 255)
    if M.statusFill then
        M.statusFill.Size = UDim2.new(progress, 0, 1, 0)
        M.statusFill.BackgroundColor3 = accent
        local g = M.statusFill:FindFirstChildOfClass("UIGradient")
        if g then
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, accent),
                ColorSequenceKeypoint.new(1, accent:Lerp(Color3.fromRGB(255, 255, 255), 0.35)),
            })
        end
    end
    if M.statusBarPctLbl then
        M.statusBarPctLbl.Text = pct .. "%"
    end
    if M.statusSubLbl then
        if type(label) == "string" and label ~= "" then
            M.statusSubLbl.Text = string.upper(label)
        elseif progress > 0 then
            M.statusSubLbl.Text = "HOLDING"
        else
            local ready = M.Steal and M.Steal.AutoStealEnabled
            M.statusSubLbl.Text = ready and "READY" or "OFF"
        end
    elseif M.statusPctLbl then
        if type(label) == "string" and label ~= "" then
            M.statusPctLbl.Text = string.upper(label)
        elseif progress > 0 then
            M.statusPctLbl.Text = "HOLDING " .. pct .. "%"
        else
            local ready = M.Steal and M.Steal.AutoStealEnabled
            M.statusPctLbl.Text = ready and "READY" or "OFF"
        end
    end
    if M.statusModeLbl then
        local modeText = tostring(M.stealMode or "Normal")
        if modeText == "V1" then modeText = "Normal" end
        M.statusModeLbl.Text = string.upper(modeText)
    end
end

function M.updateStatusRadius()
    if M.statusRadiusLbl then
        local r = 62
        pcall(function()
            r = (M.getActiveStealRadius and M.getActiveStealRadius()) or (M.Steal and M.Steal.StealRadius) or 62
        end)
        M.statusRadiusLbl.Text = string.format("Radius: %.2g", r)
    end
    if M.updateRadiusMarker then
        M.updateRadiusMarker()
    end
end

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
        local pauseFraction = 0.75
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
            local char = player.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
            local closeRange = math.min(M.getActiveStealRadius(), 9)
            return root and targetPart and targetPart.Parent and (root.Position - targetPart.Position).Magnitude <= closeRange
        end
        local function canStillGrab()
            if not prompt or not prompt.Parent or not targetPart or not targetPart.Parent then return false end
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
                elapsed = V2.pauseStarted - V2.stealStartTime - (V2.pausedDuration or 0)
            end
            barSet(math.clamp(elapsed / duration, 0, 1))
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
            while A.enabled and (M.stealMode == "Semi" or M.stealMode == "V2") and tick() - startTime < (A.holdMin or 1.3) do
                local elapsed = tick() - startTime
                A.state.phase = "holding"
                barSet(elapsed / (A.holdMax or 2.6), "HOLDING " .. tostring(A.state.label))
                task.wait()
            end
            A.state.phase = "waitingRange"
            local alreadyInRange = distToAnimal(animalData) <= (tonumber(A.radius) or 10)
            local fired = false
            while A.enabled and (M.stealMode == "Semi" or M.stealMode == "V2") and prompt.Parent do
                local elapsed = tick() - startTime
                if elapsed > (A.holdMax or 2.6) then break end
                barSet(elapsed / (A.holdMax or 2.6), "MOVE CLOSER  " .. tostring(A.state.label))
                if distToAnimal(animalData) <= (tonumber(A.radius) or 10) then
                    if not alreadyInRange then task.wait(A.entryDelay or 0.3) end
                    if A.enabled and (M.stealMode == "Semi" or M.stealMode == "V2") then
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
            if M.stealMode ~= "Semi" and M.stealMode ~= "V2" then M.stopSemiSteal(); return end
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
                M.V3.progress = math.clamp(M.V3.progress + (dt / holdT), 0, 1)
                M.updateStealProgress(M.V3.progress)
                M.isStealing = M.V3.progress > 0
                return
            end

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
    if mode == "Semi" then
        M.startSemiSteal()
    elseif mode == "V2" then
        M.startV2Steal()
    elseif mode == "V3" then
        M.startV3Steal()
    else
        M.startNormalSteal()
    end
end

function M.stopAutoSteal()
    if M.statusGui then M.statusGui.Enabled = true end
    M.stopNormalSteal()
    M.stopSemiSteal()
    M.stopV2Steal()
    M.stopV3Steal()
    M.isStealing = false
    M.updateStealProgress(0)
end

function M.setStealRadius(radius)
    M.Steal.StealRadius = radius
    M.updateStatusRadius()
end

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
            if M.medusaCounterEnabled then
                M.useMedusaCounter()
            end
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

M.aimbotSpeed = 57
M.laggerAimbotSpeed = 45
M._aimbotSwingCooldown = false
M.aimbotHitRange = M.aimbotHitRange or 9.5
M.aimbotLockRange = M.aimbotLockRange or 220
M.aimbotSwingCD = M.aimbotSwingCD or 0.12
M.aimbotHeightOffset = M.aimbotHeightOffset or 1.6
M.aimbotStickyTime = M.aimbotStickyTime or 0.55
M.aimbotRotationEnabled = true 
M.aimbotCameraRotation = false 
M.aimbotRotationSpeed = M.aimbotRotationSpeed or 0.65
M.aimbotCameraSpeed = M.aimbotCameraSpeed or 0.55

function M.findBatForAimbot()
    local char = player.Character
    if not char then return nil end
    local bp = player:FindFirstChild("Backpack")
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

function M.getAutoBatTarget()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    if now - (M._aimbotLastScan or 0) <= 0.1 and M._aimbotTarget and M._aimbotTarget.Parent then
        local hum = M._aimbotTarget.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            return M._aimbotTarget
        end
    end
    M._aimbotLastScan = now
    M._aimbotTarget = M.getClosestTargetAimbot()
    return M._aimbotTarget
end

function M.getNormalAimbotSpeed()
    if M.laggerEnabled then
        return tonumber(M.laggerAimbotSpeed) or tonumber(M.aimbotSpeed) or 57
    end
    return tonumber(M.aimbotSpeed) or 57
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

    M.autoBatEnabled = true
    M.autoSwingEnabled = true 
    M._aimbotTarget = nil
    M._aimbotLastScan = 0
    M._aimbotTargetLockUntil = 0
    M._aimbotSwingCooldown = false
    M._aimbotLastSwing = 0
    M.autoBatEquippedThisRun = false

    local hum0 = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

    M.aimbotConn = RunService.Heartbeat:Connect(function()
        if not M.autoBatEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = M.findBatForAimbot()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target = M.getAutoBatTarget()
        if not target then
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            M._aimbotLookPos = nil
            return
        end
        
        if M.aimbotRotationEnabled ~= false then
            hum.AutoRotate = false
        else
            hum.AutoRotate = true
        end

        local targetVel = target.AssemblyLinearVelocity or Vector3.zero
        local myPos = root.Position
        local targetPos = target.Position
        
        local torso = target.Parent and (target.Parent:FindFirstChild("UpperTorso") or target.Parent:FindFirstChild("Torso"))
        if torso then
            targetPos = torso.Position
        end

        local speed3 = targetVel.Magnitude
        
        local predictTime = math.clamp(0.10 + speed3 / 180, 0.08, 0.22)
        local predictedPos = targetPos + targetVel * predictTime + target.CFrame.LookVector * math.min(speed3 * 0.02, 0.35)

        local direction = predictedPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        local distFlat = flatDir.Magnitude
        if distFlat > 0.01 then
            flatDir = flatDir.Unit
        else
            flatDir = Vector3.new(0, 0, 1)
        end

        local chaseSpeed = M.getNormalAimbotSpeed()
        local hitRange = tonumber(M.aimbotHitRange) or 9.5
        
        if distFlat < hitRange * 0.9 then
            chaseSpeed = math.max(chaseSpeed * 0.85, chaseSpeed * 0.75)
        end

        local desiredHeight = targetPos.Y + 2.2
        local yVel = (desiredHeight - myPos.Y) * 16 + targetVel.Y * 0.55
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 8)
        end
        yVel = math.clamp(yVel, -55, 85)
        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.75)

        local toPredict = predictedPos - myPos

        M._aimbotLookPos = predictedPos
        M._aimbotLookFlat = flatDir
        M._aimbotDistFlat = distFlat
        M._aimbotHitRangeNow = hitRange

        if M.aimbotRotationEnabled ~= false and toPredict.Magnitude > 0.08 then
            local lookAt = Vector3.new(predictedPos.X, myPos.Y, predictedPos.Z)
            local goalCF = CFrame.lookAt(myPos, lookAt)
            local alpha = distFlat < hitRange and 0.85 or math.clamp(tonumber(M.aimbotRotationSpeed) or 0.5, 0.05, 1)
            root.CFrame = CFrame.new(root.Position) * (root.CFrame:Lerp(goalCF, alpha) - root.CFrame.Position)
            root.AssemblyAngularVelocity = Vector3.zero
        elseif M.aimbotRotationEnabled == false then
            local cam = workspace.CurrentCamera
            if cam then
                local lv = cam.CFrame.LookVector
                local lookFlat = Vector3.new(lv.X, 0, lv.Z)
                if lookFlat.Magnitude > 0.05 then
                    lookFlat = lookFlat.Unit
                    local goalCF = CFrame.lookAt(myPos, myPos + lookFlat)
                    root.CFrame = CFrame.new(root.Position) * (goalCF - goalCF.Position)
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            end
        elseif toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, Vector3.new(predictedPos.X, myPos.Y, predictedPos.Z))
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
        end

        do
            local now = tick()
            local cd = tonumber(M.aimbotSwingCD) or 0.12
            local dist3 = (targetPos - myPos).Magnitude
            local faceVec = root.CFrame.LookVector
            if M.aimbotRotationEnabled == false then
                local cam = workspace.CurrentCamera
                if cam then
                    local lv = cam.CFrame.LookVector
                    faceVec = Vector3.new(lv.X, 0, lv.Z)
                    if faceVec.Magnitude > 0.01 then faceVec = faceVec.Unit end
                end
            end
            local facing = faceVec:Dot(flatDir)
            local inRange = dist3 <= (hitRange + 1.5)
            local aimed = facing > (M.aimbotRotationEnabled == false and 0.35 or 0.55)
            if inRange and aimed and (now - (M._aimbotLastSwing or 0) >= cd) then
                M._aimbotLastSwing = now
                local bat = char:FindFirstChildOfClass("Tool") or M.findBatForAimbot()
                if bat and bat:IsA("Tool") then
                    if bat.Parent ~= char then
                        pcall(function() hum:EquipTool(bat) end)
                    end
                    pcall(function() bat:Activate() end)
                end
            elseif not inRange and (now - (M._aimbotLastSwing or 0) >= cd * 2.5) then
                local bat = M.findBatForAimbot()
                if bat and bat.Parent ~= char then
                    pcall(function() hum:EquipTool(bat) end)
                end
            end
        end
    end)

    pcall(function() RunService:UnbindFromRenderStep("VynxAimbotRotCam") end)
    RunService:BindToRenderStep("VynxAimbotRotCam", Enum.RenderPriority.Camera.Value + 1, function()
        if not M.autoBatEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local myPos = root.Position
        local lookPos = M._aimbotLookPos

        if M.aimbotRotationEnabled ~= false then
            if not lookPos then return end
            local flat = Vector3.new(lookPos.X - myPos.X, 0, lookPos.Z - myPos.Z)
            if flat.Magnitude < 0.05 then return end
            hum.AutoRotate = false
            local goalCF = CFrame.lookAt(myPos, myPos + flat.Unit)
            local distFlat = M._aimbotDistFlat or flat.Magnitude
            local hitRange = M._aimbotHitRangeNow or (tonumber(M.aimbotHitRange) or 9.5)
            local alpha = distFlat < hitRange and 1 or math.clamp(tonumber(M.aimbotRotationSpeed) or 0.55, 0.08, 1)
            local goalOnlyRot = CFrame.new(root.Position) * (goalCF - goalCF.Position)
            if alpha >= 0.99 then
                root.CFrame = goalOnlyRot
            else
                root.CFrame = root.CFrame:Lerp(goalOnlyRot, alpha)
            end
            root.AssemblyAngularVelocity = Vector3.zero
        else
            hum.AutoRotate = true
            local cam = workspace.CurrentCamera
            if cam then
                local lv = cam.CFrame.LookVector
                local lookFlat = Vector3.new(lv.X, 0, lv.Z)
                if lookFlat.Magnitude > 0.05 then
                    lookFlat = lookFlat.Unit
                    local goalCF = CFrame.lookAt(myPos, myPos + lookFlat)
                    root.CFrame = CFrame.new(root.Position) * (goalCF - goalCF.Position)
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end

        if false and lookPos then 
            local cam = workspace.CurrentCamera
            if cam then
                local camGoal = lookPos + Vector3.new(0, tonumber(M.aimbotHeightOffset) or 1.6, 0)
                local camCF = CFrame.lookAt(cam.CFrame.Position, camGoal)
                local distFlat = M._aimbotDistFlat or 99
                local hitRange = M._aimbotHitRangeNow or (tonumber(M.aimbotHitRange) or 9.5)
                local camAlpha = distFlat < hitRange and 0.75 or math.clamp(tonumber(M.aimbotCameraSpeed) or 0.45, 0.08, 1)
                cam.CFrame = cam.CFrame:Lerp(camCF, camAlpha)
            end
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
    pcall(function() RunService:UnbindFromRenderStep("VynxAimbotRotCam") end)
    M._aimbotLookPos = nil
    M._aimbotTarget = nil
    M._aimbotSwingCooldown = false
    M._aimbotLastSwing = 0
    M._aimbotTargetLockUntil = 0
    M.autoBatEnabled = false
    M.autoBatEquippedThisRun = false

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

M._bypassTarget = nil
M._bypassHRP = nil
M._bypassHum = nil
M.tpBatRange = M.tpBatRange or 1e9 
M.tpBatClose = M.tpBatClose or 5 
M.tpBatOffset = M.tpBatOffset or 0
M.tpBatSureHitEnabled = true
M._tpBatLastSwing = 0
M._bypassSwingCooldown = false
M._sureHitCD = false
M._bypassRenderConn = nil 

function M._bypassFindBat()
    local char = player.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool and tool:IsA("Tool") then return tool end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then
            return t
        end
    end
    local bp = player:FindFirstChild("Backpack") or player:FindFirstChildOfClass("Backpack")
    if bp then
        tool = bp:FindFirstChild("Bat")
        if tool and tool:IsA("Tool") then
            tool.Parent = char
            return tool
        end
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then
                t.Parent = char
                return t
            end
        end
    end
    return nil
end

function M._bypassTryHitBat()
    if M._sureHitCD then return end
    M._sureHitCD = true
    pcall(function()
        local bat = M._bypassFindBat()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function() M._sureHitCD = false end)
end

function M._bypassGetClosest()
    local root = M._bypassHRP or (player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
    if not root then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and (not hum or hum.Health > 0) then
                local dist = (root.Position - tRoot.Position).Magnitude
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
        hum.MaxHealth = math.max(hum.MaxHealth or 100, 100)
        hum.Health = hum.MaxHealth
        hum.BreakJointsOnDeath = false
        hum.RequiresNeck = false
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

function M._adClearConns()
    for _, key in ipairs({"_antiDieConn", "antiDieConn", "_antiDieCharConn", "_antiDieHealthConn", "_antiDieDiedConn", "_antiDieRenderConn"}) do
        local c = M[key]
        if c then pcall(function() c:Disconnect() end); M[key] = nil end
    end
end

function M._adProtectCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.MaxHealth = math.max(hum.MaxHealth, 100)
        hum.Health = hum.MaxHealth
        hum.BreakJointsOnDeath = false
    end)
    if M._antiDieHealthConn then pcall(function() M._antiDieHealthConn:Disconnect() end) end
    M._antiDieHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not M.antiDieEnabled then return end
        if hum.Health < (hum.MaxHealth or 100) or hum.Health <= 0 then
            pcall(function()
                hum.Health = hum.MaxHealth or 100
                hum.PlatformStand = false
            end)
        end
    end)
    if M._antiDieDiedConn then pcall(function() M._antiDieDiedConn:Disconnect() end) end
    M._antiDieDiedConn = hum.Died:Connect(function()
        if not M.antiDieEnabled then return end
        pcall(function()
            hum.Health = hum.MaxHealth or 100
            hum.PlatformStand = false
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            task.defer(function()
                pcall(function()
                    hum.Health = hum.MaxHealth or 100
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end)
        end)
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
        local hum = c:FindFirstChildOfClass("Humanoid") or c:WaitForChild("Humanoid", 3)
        if hum then
            pcall(function()
                hum.BreakJointsOnDeath = false
                hum.Died:Connect(function()
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
    M._adClearConns()
    if M._antiDieRenderConn then
        pcall(function() M._antiDieRenderConn:Disconnect() end)
        M._antiDieRenderConn = nil
    end
end

M.antiFlingEnabled = true 
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
        if M.dropActive then return end 
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
    
    M._bypassGodConn = RunService.Heartbeat:Connect(function()
        if not M.bypassAimbotEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        pcall(function()
            hum.BreakJointsOnDeath = false
            if hum.MaxHealth < 100 then hum.MaxHealth = 100 end
            if hum.Health < hum.MaxHealth or hum.Health <= 0 then
                hum.Health = hum.MaxHealth
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
    M.antiDieEnabled = true
    pcall(function()
        if not M.antiDieConn then M.startAntiDie() end
    end)
    M._bypassTarget = nil
    M._bypassSwingCooldown = false
    M._tpBatLastSwing = 0
    M._sureHitCD = false

    local char0 = player.Character
    if char0 then
        M._bypassHRP = char0:FindFirstChild("HumanoidRootPart")
        M._bypassHum = char0:FindFirstChildOfClass("Humanoid")
        if M._bypassHum then
            M.bypassPrevAutoRotate = M._bypassHum.AutoRotate
            M._bypassHum.AutoRotate = false
        end
    end

    M.bypassAimbotConn = RunService.Heartbeat:Connect(function()
        if not M.bypassAimbotEnabled then return end
        local char = player.Character
        if not char then return end
        M._bypassHum = char:FindFirstChildOfClass("Humanoid")
        M._bypassHRP = char:FindFirstChild("HumanoidRootPart")
        if not M._bypassHum or not M._bypassHRP then return end

        local target, dist = M._bypassGetClosest()
        if not target then return end
        M._bypassTarget = target

        if sethiddenproperty then
            pcall(function()
                sethiddenproperty(M._bypassHRP, "PhysicsRepRootPart", target)
            end)
        end

        local targetPos = target.Position + Vector3.new(0, 0.9, 0)
        if (M._bypassHRP.Position - targetPos).Magnitude > 8 then
            M._bypassHRP.CFrame = CFrame.new(targetPos)
        end

        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
        end
        M._bypassTryHitBat()
    end)

    M._bypassRenderConn = nil

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
    pcall(function() RunService:UnbindFromRenderStep("VynxBypassRotCam") end)
    M._bypassLookPos = nil

    M.bypassAimbotEnabled = false
    M.disableBypassGodmode()
    M._bypassTarget = nil
    M._bypassSwingCooldown = false
    M.bypassHitCD = false
    M._sureHitCD = false
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

function M.getClosestTargetBody() return nil end
function M._bodyLockTick() end
function M.startBodyLock() M.bodyLockEnabled = false end
function M.stopBodyLock() M.bodyLockEnabled = false; if M.bodyLockConn then pcall(function() M.bodyLockConn:Disconnect() end); M.bodyLockConn = nil end end
function M._suppressBodyLock() end
function M._unsuppressBodyLock() end
function M.toggleBodyLock() M.bodyLockEnabled = false; return false end

function M.showHardHitRing()
    local char = player.Character
    if not char then return end
    local hrp2 = char:FindFirstChild("HumanoidRootPart")
    if not hrp2 then return end
    if M._hardHitRing and M._hardHitRing.Parent then return end
    local cyl = Instance.new("CylinderHandleAdornment")
    cyl.Name = "VynxHardHitRing"
    cyl.Adornee = hrp2
    cyl.Color3 = (UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(235, 235, 235))
    cyl.AlwaysOnTop = true
    cyl.Transparency = 0.15
    cyl.Radius = tonumber(M.hardHitRadius) or 10
    cyl.InnerRadius = math.max((tonumber(M.hardHitRadius) or 10) - 0.3, 0.1)
    cyl.Height = 0.15
    cyl.CFrame = CFrame.new(0, -3, 0)
    cyl.Parent = hrp2
    M._hardHitRing = cyl
end

function M.hideHardHitRing()
    if M._hardHitRing then
        pcall(function() M._hardHitRing:Destroy() end)
        M._hardHitRing = nil
    end
end

function M.startHardHit()
    if M._hardHitConn then return end
    M.hardHitEnabled = true
    M.showHardHitRing()
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
            M._hardHitRing.InnerRadius = math.max(r - 0.3, 0.1)
            local accent = UI_ACCENT or CHERRY_ACCENT
            if accent then M._hardHitRing.Color3 = accent end
        end
    end)
end

function M.stopHardHit()
    M.hardHitEnabled = false
    if M._hardHitConn then
        pcall(function() M._hardHitConn:Disconnect() end)
        M._hardHitConn = nil
    end
    M.hideHardHitRing()
end

function M.applyUltraDerender(obj)
    if not obj then return end
    if M._isUnderPlots and M._isUnderPlots(obj) then return end
    pcall(function()
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("Accessory") or obj:IsA("Hat") then
            local char = obj:FindFirstAncestorOfClass("Model")
            if char and Players:GetPlayerFromCharacter(char) then
                obj:Destroy()
            end
        end
    end)
end

function M.enableUltraMode()
    M.ultraModeEnabled = true
    local L = Lighting
    M.defLightBrightness = M.defLightBrightness or L.Brightness
    M.defLightClock = M.defLightClock or L.ClockTime
    M.defLightAmbient = M.defLightAmbient or L.OutdoorAmbient
    L.GlobalShadows = false
    L.FogEnd = 1e10
    L.Brightness = 1
    L.EnvironmentDiffuseScale = 0
    L.EnvironmentSpecularScale = 0
    for _, e in pairs(L:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end
    for _, obj in pairs(workspace:GetDescendants()) do
        M.applyUltraDerender(obj)
    end
    if M._ultraDescConn then pcall(function() M._ultraDescConn:Disconnect() end) end
    M._ultraDescConn = workspace.DescendantAdded:Connect(function(obj)
        if not M.ultraModeEnabled then return end
        M.applyUltraDerender(obj)
    end)
    pcall(function()
        if setfpscap then setfpscap(999999999) end
    end)
end

function M.disableUltraMode()
    M.ultraModeEnabled = false
    if M._ultraDescConn then
        pcall(function() M._ultraDescConn:Disconnect() end)
        M._ultraDescConn = nil
    end
end

function M.doAutoTPDown(force)
    local char=player.Character;if not char then return end;local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    if not force then if hum2.FloorMaterial~=Enum.Material.Air then return end;if not(hrp.Position.Y>=M.autoTPHeight) then return end end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0);hrp.Velocity=Vector3.zero
end

function M.startAutoTP()
    if M.autoTPConn then task.cancel(M.autoTPConn);M.autoTPConn=nil end
    M.autoTPConn=task.spawn(function() while M.autoTPEnabled do task.wait(0.1);pcall(function() M.doAutoTPDown(false) end) end end)
end

function M.stopAutoTP() M.autoTPEnabled=false;if M.autoTPConn then task.cancel(M.autoTPConn);M.autoTPConn=nil end end

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
        if not isSummer then continue end
        
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

function M.applyAntiLagDerender(obj)
    if not obj then return end
    if M._isUnderPlots(obj) then return end
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            local char = obj:FindFirstAncestorOfClass("Model")
            if char and Players:GetPlayerFromCharacter(char) then
                obj:Destroy()
            end
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.CastShadow = false
            if obj.Reflectance and obj.Reflectance > 0 then
                obj.Reflectance = 0
            end
        end
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

M.antiRagdollNoSplatterCooldown = 0

M.nukeOptEnabled = false
M._NukeOn = false
M._NukeConns = {}
M._NukeThreads = {}

function M.enableNukeOptimizer()
    if M._NukeOn then return end
    M._NukeOn = true
    M.nukeOptEnabled = true
    local LightingSvc = game:GetService("Lighting")
    local MaterialService = game:GetService("MaterialService")
    local XMin, XMax = -560, -240
    local ClothingClasses = {"Shirt","Pants","ShirtGraphic","Accessory","Hat","HairAccessory","FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory","BackAccessory","WaistAccessory"}
    local BASE_NAMES = {"baseplate","spawnlocation","spawn location","spawn"}
    local function IsUnderPlots(obj)
        if not obj then return false end
        if M._isUnderPlots and M._isUnderPlots(obj) then return true end
        local p = obj
        while p and p ~= game do
            if p.Name == "Plots" or p.Name == "AnimalPodiums" or p.Name == "PlotSign" then
                return true
            end
            local nl = tostring(p.Name):lower()
            if nl:find("plot", 1, true) or nl:find("base", 1, true) and p:IsA("Model") then
                local q = p.Parent
                while q and q ~= game do
                    if q.Name == "Plots" then return true end
                    q = q.Parent
                end
            end
            p = p.Parent
        end
        return false
    end
    local function SafeDestroy(obj)
        if not obj or obj.Name == "Overhead" then return end
        if IsUnderPlots(obj) then return end
        if obj:IsA("Beam") or obj:IsA("Laser") then return end
        pcall(function() obj:Destroy() end)
    end
    local function IsClothing(obj)
        for _, c in ipairs(ClothingClasses) do if obj:IsA(c) then return true end end
        return false
    end
    local function IsCharacterPart(obj)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
        end
        return false
    end
    local function IsOutOfRange(obj)
        if IsUnderPlots(obj) then return false end
        if obj:IsA("BasePart") then
            local x = obj.Position.X
            return x < XMin or x > XMax
        end
        return false
    end
    local function IsBase(obj)
        if IsUnderPlots(obj) then return false end
        if not obj:IsA("BasePart") then return false end
        local nl = obj.Name:lower()
        for _, n in ipairs(BASE_NAMES) do
            if nl:find(n, 1, true) then return true end
        end
        return false
    end
    local function IsInBase(obj)
        if IsUnderPlots(obj) then return true end 
        local p = obj.Parent
        while p and p ~= workspace do
            if IsBase(p) then return true end
            p = p.Parent
        end
        return false
    end
    local function MakeTransparent(obj)
        if IsUnderPlots(obj) then return end
        pcall(function()
            if IsBase(obj) and not IsCharacterPart(obj) then
                obj.Transparency = 1
                obj.CastShadow = false
            end
        end)
    end
    local function StripObject(obj)
        pcall(function()
            if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SpecialMesh") then
                SafeDestroy(obj)
            elseif obj:IsA("Beam") then
                return
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                pcall(function() obj.Enabled = false end)
                SafeDestroy(obj)
            elseif obj:IsA("SurfaceAppearance") then
                SafeDestroy(obj)
            elseif obj:IsA("BasePart") then
                obj.CastShadow = false
                obj.Material = Enum.Material.Plastic
                pcall(function() obj.MaterialVariant = "" end)
                obj.Reflectance = 0
            end
        end)
    end
    local function CleanObject(obj)
        pcall(function()
            if obj:IsA("SurfaceAppearance") then
                SafeDestroy(obj)
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then
                    SafeDestroy(obj)
                end
            elseif obj:IsA("SpecialMesh") then
                SafeDestroy(obj)
            end
        end)
    end
    local function ApplyGreySky()
        pcall(function()
            for _, obj in ipairs(LightingSvc:GetChildren()) do
                if obj:IsA("Sky") then obj:Destroy() end
            end
            local sky = Instance.new("Sky")
            sky.SkyboxBk = ""; sky.SkyboxDn = ""; sky.SkyboxFt = ""
            sky.SkyboxLf = ""; sky.SkyboxRt = ""; sky.SkyboxUp = ""
            sky.CelestialBodiesShown = false
            sky.Name = "_VynxNukeSky"
            sky.Parent = LightingSvc
        end)
    end
    local function OptimizeLighting()
        LightingSvc.GlobalShadows = false
        LightingSvc.FogEnd = 9e9
        LightingSvc.FogStart = 9e9
        LightingSvc.EnvironmentDiffuseScale = 0
        LightingSvc.EnvironmentSpecularScale = 0
        LightingSvc.Brightness = 1.5
        LightingSvc.Ambient = Color3.fromRGB(60, 60, 60)
        for _, v in ipairs(LightingSvc:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect")
                or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect")
                or v:IsA("Atmosphere") or v:IsA("Clouds") then
                v:Destroy()
            end
        end
        ApplyGreySky()
    end
    local function ApplyTerrain()
        pcall(function()
            local t = workspace:FindFirstChildOfClass("Terrain")
            if t then
                t.Decoration = false
                pcall(function() t.WaterWaveSize = 0 end)
                pcall(function() t.WaterWaveSpeed = 0 end)
                pcall(function() t.WaterReflectance = 0 end)
                pcall(function() t.WaterTransparency = 1 end)
            end
        end)
    end
    local function OptimizeCharacter(char)
        if not char then return end
        task.spawn(function()
            task.wait(0.3)
            if not M._NukeOn then return end
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
    table.insert(M._NukeThreads, task.spawn(function()
        if not game:IsLoaded() then game.Loaded:Wait() end
        OptimizeLighting()
        ApplyTerrain()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if not M._NukeOn then return end
            if IsUnderPlots(obj) then
            elseif IsBase(obj) then
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
        for _, obj in ipairs(workspace:GetDescendants()) do
            if not IsUnderPlots(obj) then
                MakeTransparent(obj)
            end
        end
    end))
    table.insert(M._NukeConns, workspace.DescendantAdded:Connect(function(obj)
        if not M._NukeOn then return end
        task.defer(function()
            if not M._NukeOn then return end
            if IsUnderPlots(obj) then return end
            if IsBase(obj) then MakeTransparent(obj); return end
            if IsClothing(obj) then SafeDestroy(obj)
            elseif IsInBase(obj) then
            elseif IsCharacterPart(obj) then
            elseif IsOutOfRange(obj) then SafeDestroy(obj)
            else CleanObject(obj); StripObject(obj) end
        end)
    end))
    table.insert(M._NukeConns, LightingSvc.DescendantAdded:Connect(function(obj)
        if not M._NukeOn then return end
        if obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then
            SafeDestroy(obj)
        end
    end))
    table.insert(M._NukeConns, MaterialService.DescendantAdded:Connect(function(obj)
        if not M._NukeOn then return end
        SafeDestroy(obj)
    end))
    for _, plr in ipairs(Players:GetPlayers()) do
        OptimizeCharacter(plr.Character)
        table.insert(M._NukeConns, plr.CharacterAdded:Connect(OptimizeCharacter))
    end
    table.insert(M._NukeConns, Players.PlayerAdded:Connect(function(plr)
        table.insert(M._NukeConns, plr.CharacterAdded:Connect(OptimizeCharacter))
    end))
    table.insert(M._NukeThreads, task.spawn(function()
        while M._NukeOn do
            task.wait(15)
            pcall(function() collectgarbage("collect") end)
        end
    end))
end

function M.disableNukeOptimizer()
    M._NukeOn = false
    M.nukeOptEnabled = false
    for _, c in ipairs(M._NukeConns) do pcall(function() c:Disconnect() end) end
    M._NukeConns = {}
    M._NukeThreads = {}
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

function M.getMyBaseCFrame()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        if not plot:IsA("Model") then continue end
        local sign = plot:FindFirstChild("PlotSign")
        local yb = sign and sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") and yb.Enabled == true then
            local spawn = plot:FindFirstChild("Spawn", true)
            if spawn and spawn:IsA("BasePart") then
                return spawn.CFrame + Vector3.new(0, 3, 0)
            end
            local ok, pivot = pcall(function() return plot:GetPivot() end)
            if ok and pivot then
                return pivot + Vector3.new(0, 5, 0)
            end
            if sign:IsA("BasePart") then
                return sign.CFrame + Vector3.new(0, 5, 0)
            end
            local pp = sign:FindFirstChildWhichIsA("BasePart", true)
            if pp then
                return pp.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
    return nil
end

function M.isEnemyBatNearby(range)
    range = tonumber(range) or M.ragdollTPBaseRange or 50
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local myPos = hrp.Position
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - myPos).Magnitude
                if dist <= range then
                    local tool = plr.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local n = tool.Name:lower()
                        if n:find("bat") or n:find("slap") then
                            return true
                        end
                    end
                    return true
                end
            end
        end
    end
    return false
end

function M.tpToMyBaseFromRagdoll()
    local cf = M.getMyBaseCFrame()
    if not cf then return false end
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp then return false end
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = cf
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if hum and hum.Health > 0 then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            task.defer(function()
                if hum and hum.Parent then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
    end)
    return true
end

function M.tryRagdollTPBase()
    if not M.ragdollTPBaseEnabled then return end
    local now = tick()
    if now - (M._ragdollTPLast or 0) < (tonumber(M.ragdollTPBaseCooldown) or 1.5) then return end
    if not M.isEnemyBatNearby(M.ragdollTPBaseRange) then return end
    M._ragdollTPLast = now
    task.defer(function()
        task.wait(0.05)
        if not M.ragdollTPBaseEnabled then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local st = hum:GetState()
        local stillRag = hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
        if stillRag or true then
            M.tpToMyBaseFromRagdoll()
        end
    end)
end

function M._hookRagdollTPOnChar(char)
    if M._ragdollTPCharConn then
        pcall(function() M._ragdollTPCharConn:Disconnect() end)
        M._ragdollTPCharConn = nil
    end
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if not hum then return end
    M._ragdollTPCharConn = hum.StateChanged:Connect(function(_, new)
        if not M.ragdollTPBaseEnabled then return end
        if new == Enum.HumanoidStateType.Physics
            or new == Enum.HumanoidStateType.Ragdoll
            or new == Enum.HumanoidStateType.FallingDown then
            M.tryRagdollTPBase()
        end
    end)
    
    hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if not M.ragdollTPBaseEnabled then return end
        if hum.PlatformStand then
            M.tryRagdollTPBase()
        end
    end)
end

function M.startRagdollTPBase()
    M.ragdollTPBaseEnabled = true
    if player.Character then
        M._hookRagdollTPOnChar(player.Character)
    end
    if not M._ragdollTPAddedConn then
        M._ragdollTPAddedConn = player.CharacterAdded:Connect(function(char)
            task.wait(0.2)
            if M.ragdollTPBaseEnabled then
                M._hookRagdollTPOnChar(char)
            end
        end)
    end
end

function M.stopRagdollTPBase()
    M.ragdollTPBaseEnabled = false
    if M._ragdollTPCharConn then
        pcall(function() M._ragdollTPCharConn:Disconnect() end)
        M._ragdollTPCharConn = nil
    end
end

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
    M.startHoldInfJump()
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
        if not M.infJumpEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        
        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or M.jumpHeld or (hum.Jump == true)
        local vel = root.AssemblyLinearVelocity
        if isJumpHeld and vel.Y < 35 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, 55, vel.Z)
        end
        
        vel = root.AssemblyLinearVelocity
        if vel.Y < -120 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, -55, vel.Z)
        end
    end)
end

function M.stopHoldInfJump()
    if M.holdInfJumpConn then
        M.holdInfJumpConn:Disconnect()
        M.holdInfJumpConn = nil
    end
end

function M.forceRestoreWalkAnims(char)
    M.unwalkEnabled = false
    char = char or player.Character
    if not char then return end
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
                pcall(function() t:Stop(0) end)
            end
            hum.PlatformStand = false
            hum.Sit = false
            if (hum.WalkSpeed or 0) < 1 then hum.WalkSpeed = 16 end
        end
    end)
    
    if M.animPackEnabled and M.animPack and M.PACKS and M.PACKS[M.animPack] then
        pcall(function() M.applyAnimPack(M.animPack) end)
        return
    end
    
    if not char:FindFirstChild("Animate") then
        if M.restoreOriginalAnimate then
            pcall(function() M.restoreOriginalAnimate(char) end)
        end
    end
    if not char:FindFirstChild("Animate") then
        pcall(function()
            local sp = game:GetService("StarterPlayer")
            local scs = sp:FindFirstChild("StarterCharacterScripts")
            local tmpl = scs and scs:FindFirstChild("Animate")
            if tmpl then
                local clone = tmpl:Clone()
                clone.Parent = char
            end
        end)
    end
    if M.resetAnimations and not (M.animPackEnabled and M.animPack) then
    end
end

function M.startUnwalk() M.unwalkEnabled = false return end
function M.stopUnwalk() M.unwalkEnabled = false end

function M.ensureNotUnwalkStuck() end

function M.cursedInstaReset()
    return
end

function M.hasBrainrotInHand()
    local char = player.Character
    if not char then return false end
    
    local ok, val = pcall(function() return player:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and val2 == true then return true end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local name = item.Name:lower()
            if name:find("brainrot", 1, true)
                or name:find("skibidi", 1, true)
                or name:find("toilet", 1, true)
                or name:find("steal", 1, true)
                or name:find("animal", 1, true)
                or name:find("pet", 1, true)
            then
                if not (name:find("slap", 1, true) or name:find("bat", 1, true)) then
                    return true
                end
            end
        end
    end
    return false
end

function M.forceLaggerCarryWhileHolding()
    return M.hasBrainrotInHand()
end

function M.refreshSpeedCustomKeybindLabels()
    local custom = (M.speedUIMode or "Original") == "Customizer"
    local refs = M.keybindLabelRefs
    if not refs then return end
    local map = {
        [M.KB.SpeedToggle] = custom and "Carry Mode [Speed Custom]" or "Carry Mode",
        [M.KB.LaggerToggle] = custom and "Lagger Mode [Speed Custom]" or "Lagger Mode",
        [M.KB.LaggerCarry] = custom and "Lagger Carry [Speed Custom]" or "Lagger Carry [2x Lagger Mode]",
    }
    for entry, text in pairs(map) do
        local l = refs[entry]
        if l and l.Parent then l.Text = text end
    end
end

function M.toggleCarryMode()
    M.carrySpeedActive = not M.carrySpeedActive
    if M.carrySpeedActive then
        M.laggerCarryActive = false
        M.laggerModeEnabled = false
        M.speedBoosterPath = "Normal"
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.speedBoosterSyncPath then pcall(function() M.speedBoosterSyncPath("Normal") end) end
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.speedBoosterRefresh then pcall(M.speedBoosterRefresh) end
    saveCherryConfig()
end

function M.toggleLaggerMode()
    M.laggerModeEnabled = not M.laggerModeEnabled
    if M.laggerModeEnabled then
        M.speedBoosterPath = "Lagger"
        M.carrySpeedActive = false
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    else
        M.speedBoosterPath = "Normal"
        M.laggerCarryActive = false
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.laggerModeBtn then
        M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
    end
    if M.speedBoosterSyncPath then pcall(function() M.speedBoosterSyncPath(M.speedBoosterPath) end) end
    if M.speedBoosterRefresh then pcall(M.speedBoosterRefresh) end
    saveCherryConfig()
end

function M.cycleLaggerModeBind()
    if not M.laggerModeEnabled and not M.laggerCarryActive then
        M.laggerModeEnabled = true
        M.laggerCarryActive = false
        M.carrySpeedActive = false
        M.speedBoosterPath = "Lagger"
    elseif M.laggerModeEnabled and not M.laggerCarryActive then
        M.laggerCarryActive = true
        M.laggerModeEnabled = true
        M.carrySpeedActive = false
        M.speedBoosterPath = "Lagger"
    else
        M.laggerCarryActive = false
        M.laggerModeEnabled = true
        M.carrySpeedActive = false
        M.speedBoosterPath = "Lagger"
    end
    if M.mobBtnRefs.carrySpeed then pcall(function() M.mobBtnRefs.carrySpeed(false) end) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.mobBtnRefs.lagger then pcall(function() M.mobBtnRefs.lagger(M.laggerModeEnabled) end) end
    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
    if M.mobBtnRefs.laggerCarry then pcall(function() M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end) end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
    if M.speedBoosterSyncPath then pcall(function() M.speedBoosterSyncPath(M.speedBoosterPath) end) end
    if M.refreshSpeedModeLabel then pcall(M.refreshSpeedModeLabel) end
    if M.speedBoosterRefresh then pcall(M.speedBoosterRefresh) end
    pcall(saveCherryConfig)
end

function M._syncSpeedModeVisuals()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
    saveCherryConfig()
end

function M.toggleLaggerCarry()
    M.laggerCarryActive = not M.laggerCarryActive
    if M.laggerCarryActive then
        M.carrySpeedActive = false
        M.speedBoosterPath = "Lagger"
        M.laggerModeEnabled = true
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(true) end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag On" end
        if M.speedBoosterSyncPath then pcall(function() M.speedBoosterSyncPath("Lagger") end) end
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    if M.speedBoosterRefresh then pcall(M.speedBoosterRefresh) end
    saveCherryConfig()
end

function M.safeMoveDirection(hrp, hum, dir, spd, dt)
    if not hrp or not dir then return end
    local flat = Vector3.new(dir.X, 0, dir.Z)
    if flat.Magnitude < 0.01 then
        if hum then pcall(function() hum:Move(Vector3.zero, false) end) end
        return
    end
    flat = flat.Unit
    spd = tonumber(spd) or M.NS or 60
    
    local cap = tonumber(M.antiFlingMaxSpeed) or 120
    if spd > cap then spd = cap end
    dt = dt or (1/60)
    
    if M.applySpeedMethod then
        pcall(function() M.applySpeedMethod(hrp, hum, flat, spd, dt) end)
        if hum then pcall(function() hum:Move(flat, false) end) end
        return
    end
    
    local mass = hrp.AssemblyMass or 1
    local current = hrp.AssemblyLinearVelocity
    local desired = Vector3.new(flat.X * spd, current.Y, flat.Z * spd)
    local delta = desired - current
    pcall(function()
        hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass)
    end)
    if hum then pcall(function() hum:Move(flat, false) end) end
end

function M.safeStopMove(hrp, hum)
    if hum then pcall(function() hum:Move(Vector3.zero, false) end) end
    if not hrp then return end
    
    pcall(function()
        local mass = hrp.AssemblyMass or 1
        local current = hrp.AssemblyLinearVelocity
        local delta = Vector3.new(-current.X, 0, -current.Z)
        hrp:ApplyImpulse(delta * mass * 0.85)
    end)
end

function M.stopAutoLeft()
    M.autoLeftEnabled = false
    if M.alConn then M.alConn:Disconnect(); M.alConn = nil end
    M.alPhase = 1
    local char = player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        M.safeStopMove(root, h)
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
        local root = char:FindFirstChild("HumanoidRootPart")
        M.safeStopMove(root, h)
    end
    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
end

function M.startAutoLeft()
    if M.alConn then M.alConn:Disconnect() end
    M.alPhase = 1
    M.autoLeftEnabled = true
    M.alConn = RunService.Heartbeat:Connect(function(dt)
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
                M.safeMoveDirection(hrp, hum, mv, spd, dt)
                return
            end
            local d = M.AP_L1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            M.safeMoveDirection(hrp, hum, mv, spd, dt)
        elseif M.alPhase == 2 then
            local tgt = Vector3.new(M.AP_L2.X, hrp.Position.Y, M.AP_L2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                M.safeStopMove(hrp, hum)
                M.autoLeftEnabled = false
                if M.alConn then M.alConn:Disconnect(); M.alConn = nil end
                M.alPhase = 1
                if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                
                if M.autoPlayEnabled and M.autoPlayLockedDir then
                    task.defer(function()
                        if M.autoPlayEnabled and M.autoPlayLockedDir then
                            M._runLockedAutoPlayPath()
                        end
                    end)
                end
                return
            end
            local d = M.AP_L2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            M.safeMoveDirection(hrp, hum, mv, spd, dt)
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
    M.arConn = RunService.Heartbeat:Connect(function(dt)
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
                M.safeMoveDirection(hrp, hum, mv, spd, dt)
                return
            end
            local d = M.AP_R1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            M.safeMoveDirection(hrp, hum, mv, spd, dt)
        elseif M.arPhase == 2 then
            local tgt = Vector3.new(M.AP_R2.X, hrp.Position.Y, M.AP_R2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                M.safeStopMove(hrp, hum)
                M.autoRightEnabled = false
                if M.arConn then M.arConn:Disconnect(); M.arConn = nil end
                M.arPhase = 1
                if M.autoRightSetVisual then M.autoRightSetVisual(false) end
                if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                
                if M.autoPlayEnabled and M.autoPlayLockedDir then
                    task.defer(function()
                        if M.autoPlayEnabled and M.autoPlayLockedDir then
                            M._runLockedAutoPlayPath()
                        end
                    end)
                end
                return
            end
            local d = M.AP_R2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            M.safeMoveDirection(hrp, hum, mv, spd, dt)
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

function M.getPlayerSide()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return "left" end
    local midZ = ((M.AP_L1 and M.AP_L1.Z or 93) + (M.AP_R1 and M.AP_R1.Z or 25)) * 0.5
    if hrp.Position.Z >= midZ then
        return "left"
    end
    return "right"
end

function M.setAutoPlayVisual(on)
    on = on and true or false
    M.autoPlayEnabled = on
    if M.autoPlaySetVisual then pcall(function() M.autoPlaySetVisual(on) end) end
    if M.mobBtnRefs and M.mobBtnRefs.autoPlay then pcall(function() M.mobBtnRefs.autoPlay(on) end) end
    if not on then
        if M.autoLeftSetVisual then pcall(function() M.autoLeftSetVisual(false) end) end
        if M.autoRightSetVisual then pcall(function() M.autoRightSetVisual(false) end) end
        if M.mobBtnRefs and M.mobBtnRefs.autoLeft then pcall(function() M.mobBtnRefs.autoLeft(false) end) end
        if M.mobBtnRefs and M.mobBtnRefs.autoRight then pcall(function() M.mobBtnRefs.autoRight(false) end) end
    end
end

function M._runLockedAutoPlayPath()
    local dir = M.autoPlayLockedDir
    if not dir then return end
    if dir == "right" then
        M.autoLeftEnabled = false
        M.autoRightEnabled = true
        M.startAutoRight()
    else
        M.autoRightEnabled = false
        M.autoLeftEnabled = true
        M.startAutoLeft()
    end
end

function M.stopAutoPlay()
    M.autoPlayEnabled = false
    M.autoPlayLockedDir = nil
    pcall(function() M.stopAutoLeft() end)
    pcall(function() M.stopAutoRight() end)
    M.setAutoPlayVisual(false)
end

function M.startAutoPlay()
    if M.safeModeTryStart and not M.safeModeTryStart() then return end
    if M.autoBatEnabled then
        pcall(function() M.stopBatAimbot() end)
        if M.autoBatSetVisual then M.autoBatSetVisual(false) end
        if M.mobBtnRefs and M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
    end
    pcall(function() M.stopAutoLeft() end)
    pcall(function() M.stopAutoRight() end)

    local side = M.getPlayerSide()
    if side == "left" then
        M.autoPlayLockedDir = "right" 
    else
        M.autoPlayLockedDir = "left"  
    end

    M.autoPlayEnabled = true
    M.setAutoPlayVisual(true)
    M._runLockedAutoPlayPath()
end

function M.toggleAutoPlay()
    if M.autoPlayEnabled or M.autoLeftEnabled or M.autoRightEnabled then
        M.stopAutoPlay()
    else
        M.startAutoPlay()
    end
    return M.autoPlayEnabled
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

function M.mirrorTPApplyOnce()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return false end
    local _, yaw = root.CFrame:ToEulerAnglesYXZ()
    local y = M.MIRROR_TP_DOWN_Y or -7.00
    root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
    return true
end

function M.mirrorTPTeleportDown()
    if not M.mirrorTPAimbotActive() then return end
    local now = tick()
    if now - (M.mirrorTPLastTeleport or 0) < 0.25 then return end
    M.mirrorTPLastTeleport = now
    if not M.mirrorTPApplyOnce() then return end
    
    task.delay(0.06, function()
        if not M.mirrorTPAimbotActive() then return end
        if not M.mirrorTPDownEnabled then return end
        M.mirrorTPApplyOnce()
    end)
end

if not M._mirrorTPStarted then
    M._mirrorTPStarted = true
    local _mAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        if not M.mirrorTPDownEnabled or not M.mirrorTPAimbotActive() then
            if next(M.mirrorTPPreviousY) then
                table.clear(M.mirrorTPPreviousY)
            end
            return
        end
        _mAcc = _mAcc + (dt or 0.016)
        if _mAcc < 0.08 then return end
        _mAcc = 0
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
            if ok and pivot then
                pos = pivot
            else
                local sign = plot:FindFirstChild("PlotSign")
                if sign and sign:IsA("BasePart") then
                    pos = sign.Position
                elseif sign then
                    local pp = sign:FindFirstChildWhichIsA("BasePart", true)
                    if pp then pos = pp.Position end
                end
            end
            if pos then
                local flat = Vector3.new(myPos.X - pos.X, 0, myPos.Z - pos.Z)
                if flat.Magnitude <= range then
                    return true
                end
            end
        end
    end
    return false
end

function M.enableCarryModeOnly()
    if M.carrySpeedActive then return end 
    M.carrySpeedActive = true
    if M.carryModeBtn then
        M.carryModeBtn.Text = "Carry On"
    end
    if M.mobBtnRefs.carrySpeed then
        pcall(function() M.mobBtnRefs.carrySpeed(true) end)
    end
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
        if M.isNearEnemyBase(M.autoCarryEnemyBaseRange) then
            M.enableCarryModeOnly()
        end
    end)
end

function M.stopAutoCarryEnemyBase()
    if M._autoCarryEnemyBaseConn then
        pcall(function() M._autoCarryEnemyBaseConn:Disconnect() end)
        M._autoCarryEnemyBaseConn = nil
    end
end

function M.setAutoCarryEnemyBase(on)
    M.autoCarryEnemyBaseEnabled = on and true or false
    if M.autoCarryEnemyBaseEnabled then
        M.startAutoCarryEnemyBase()
    else
        M.stopAutoCarryEnemyBase()
    end
end

function M.isStealState()
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
    local uiMode = M.speedUIMode or "Original"
    local isSteal = false
    pcall(function() isSteal = M.isStealState and M.isStealState() == true end)
    local holding = false
    pcall(function()
        if M.hasBrainrotInHand and M.hasBrainrotInHand() then holding = true end
    end)

    local ns = tonumber(M.NS) or 60
    local cs = tonumber(M.CS) or 30
    local ls = tonumber(M.LAGGER_SPEED) or 15
    local lcs = tonumber(M.LAGGER_CARRY_SPEED) or 24.5

    if uiMode == "Original" then
        if M.autoSwitchSpeedEnabled then
            if M.laggerCarryActive then return lcs end
            if M.laggerModeEnabled then
                return (isSteal or holding) and lcs or ls
            end
            if M.carrySpeedActive or isSteal or holding then return cs end
            return ns
        end
        if M.laggerCarryActive then return lcs end
        if M.laggerModeEnabled then return ls end
        if M.carrySpeedActive then return cs end
        return ns
    end

    if M.speedBoosterEnabled == false then
        return 16
    end
    
    if M.laggerCarryActive then return lcs end
    if M.carrySpeedActive then return cs end
    local useLagger = (tostring(M.speedBoosterPath) == "Lagger") or (M.laggerModeEnabled == true)
    if useLagger then
        if holding then return lcs end
        return ls
    end
    if holding then return cs end
    return ns
end

function M.getAutoPathSpeed()
    if M.laggerModeEnabled or M.laggerCarryActive then return M.LAGGER_SPEED
    else return M.NS end
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
        if not M.autoSwitchSpeedEnabled and not M.autoTurnOffSpeedEnabled and not M.autoSwitchLaggerSpeedEnabled then
            M.stopWalkSpeedAutoSwitch()
            return
        end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local ws = hum.WalkSpeed or 16
        local thr = tonumber(M.AUTO_SWITCH_THRESHOLD) or 25

        if M.autoTurnOffSpeedEnabled and ws > thr and M.carrySpeedActive and not M.autoSwitchSpeedEnabled then
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
    if M.autoSwitchSpeedEnabled or M.autoSwitchLaggerSpeedEnabled then
        if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
    end
end

function M.isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end

function M.runDrop()
    if M.dropActive then return end
    pcall(function() if M.stopAutoTPForAction then M.stopAutoTPForAction() end end)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    M._lastDropTime = M._lastDropTime or 0
    if tick() - M._lastDropTime < 0.15 then return end
    M._lastDropTime = tick()

    M.dropActive = true
    local startTime = tick()
    local duration = tonumber(M.DROP_ASCEND_DURATION) or 0.2
    local ascend = tonumber(M.DROP_ASCEND_SPEED) or 150
    local dropConn
    dropConn = RunService.Heartbeat:Connect(function()
        local currentChar = player.Character
        local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        if not currentChar or not currentRoot then
            if dropConn then pcall(function() dropConn:Disconnect() end) end
            M.dropActive = false
            return
        end
        if tick() - startTime >= duration then
            if dropConn then pcall(function() dropConn:Disconnect() end) end
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {currentChar}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
            if rayResult then
                local hum = currentChar:FindFirstChildOfClass("Humanoid")
                local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
                currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
            end
            pcall(function()
                currentRoot.AssemblyLinearVelocity = Vector3.zero
                currentRoot.AssemblyAngularVelocity = Vector3.zero
                currentRoot.Velocity = Vector3.zero
            end)
            M.dropActive = false
            return
        end
        
        local v = currentRoot.AssemblyLinearVelocity
        currentRoot.AssemblyLinearVelocity = Vector3.new(v.X, ascend, v.Z)
        pcall(function() currentRoot.Velocity = Vector3.new(v.X, ascend, v.Z) end)
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
    M.autoResetOnDeath = false
    if M._deathResetConn then pcall(function() M._deathResetConn:Disconnect() end); M._deathResetConn = nil end
    if M._deathResetCharAdded then pcall(function() M._deathResetCharAdded:Disconnect() end); M._deathResetCharAdded = nil end
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
    local data = nil
    if isfile and isfile(M.MOB_POS_FILE) then
        local ok, d = pcall(function() return HS:JSONDecode(readfile(M.MOB_POS_FILE)) end)
        if ok and type(d)=="table" then data = d end
    end
    if (not data or next(data) == nil) and type(M._btnPosCache) == "table" then
        data = M._btnPosCache
    end
    return data or {}
end

function M.saveBtnPositions()
    if not M.mobGuiRef then return end
    local out = {}
    for _,child in ipairs(M.mobGuiRef:GetChildren()) do
        if child:IsA("Frame") and child:GetAttribute("BtnKey") then
            local key = child:GetAttribute("BtnKey")
            out[key] = {x=child.Position.X.Offset, y=child.Position.Y.Offset}
        end
    end
    M._btnPosCache = out
    pcall(function()
        if writefile then writefile(M.MOB_POS_FILE, HS:JSONEncode(out)) end
    end)
    
    pcall(function()
        if type(saveCherryConfig) == "function" then saveCherryConfig() end
    end)
end

function M.resetMobilePositions()
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
    
    pcall(function()
        if not M.mobGuiRef then return end
        local out = {}
        for _, child in ipairs(M.mobGuiRef:GetChildren()) do
            if child:IsA("Frame") and child:GetAttribute("BtnKey") then
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

function M.buildMobileButtons()
    M.destroyMobileButtons()
    if not M.mobileButtonsEnabled then return end

    local savedPositions = M._forceDefaultMobPos and {} or M.loadBtnPositions()
    
    if (not savedPositions or next(savedPositions) == nil) and type(M._btnPosCache) == "table" then
        savedPositions = M._btnPosCache
    end
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)

    local shape = tostring(M.mobileButtonShape or "Normal")
    if shape ~= "Circle" then shape = "Normal" end
    M.circleButtonsEnabled = (shape == "Circle") 

    local side = math.max(48, math.floor((tonumber(M.mobileButtonsSize) or 64) * (M.uiScale or 0.8) * 0.72))
    local BTN_H, BTN_W = side, side
    local CORNER_R = 16
    local CUBE_STYLE = false
    if shape == "Circle" then
        CORNER_R = math.floor(side / 2)
    end

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "MoveeMobileButtons"
    mobGui.ResetOnSpawn = false
    mobGui.DisplayOrder = 15
    mobGui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if not pcall(function() mobGui.Parent = game:GetService("CoreGui") end) then
        mobGui.Parent = player:WaitForChild("PlayerGui")
    end
    M.mobGuiRef = mobGui

    local C_BORDER = Color3.fromRGB(55, 55, 55)
    local C_TEXT = Color3.fromRGB(255, 255, 255)
    local C_TEXT_SUB = Color3.fromRGB(170, 170, 170)
    local C_BTN_ON_TEXT = Color3.fromRGB(10, 10, 10)
    local accent = (M.Theme and M.Theme.Accent) or UI_ACCENT or M.UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(165, 75, 255)
    local isWhiteTheme = true 
    local BTN_OFF = Color3.fromRGB(25, 25, 25)
    local BTN_ON = Color3.fromRGB(255, 255, 255)
    local TXT_OFF = C_TEXT_SUB
    local TXT_ON = C_BTN_ON_TEXT
    local STROKE_OFF, STROKE_ON, STROKE_THICK = C_BORDER, C_TEXT, 1
    local IMG_TINT_OFF, IMG_TINT_ON = accent, accent

    local btnDefs = {
        {"drop", "DROP\nBRAINROT", false},
        {"autoLeft", "AUTO\nLEFT", true},
        {"autoRight", "AUTO\nRIGHT", true},
        {"autoBat", "AUTO\nBAT", true},
        {"tpDown", "TP\nDOWN", false},
        {"carrySpeed", "CARRY\nSPEED", true},
        {"lagger", "LAGGER\nMODE", true},
        {"laggerCarry", "LAGGER\nCARRY", true},
        {"bypass", "BAT\nTP", true},
    }
    
    if (M.speedUIMode or "Original") ~= "Original" then
        local filtered = {}
        for _, def in ipairs(btnDefs) do
            local k = def[1]
            if k ~= "carrySpeed" and k ~= "lagger" and k ~= "laggerCarry" then
                table.insert(filtered, def)
            end
        end
        btnDefs = filtered
    end

    local cols = 2
    local gap = 8
    local padding = 6
    local pairW = cols * BTN_W + (cols - 1) * gap
    local startX = vp.X - pairW - padding
    local startY = 18
    
    local dropH = math.floor(BTN_H * 0.92)
    local dropW = pairW
    local topBlockH = dropH + gap + BTN_H 
    local restIndex = 0

    for i, def in ipairs(btnDefs) do
        local key = def[1]
        local label = def[2]
        local isToggle = def[3]

        local thisW, thisH = BTN_W, BTN_H
        local defaultX, defaultY
        if key == "drop" then
            thisW, thisH = dropW, dropH
            defaultX = startX
            defaultY = startY
        elseif key == "autoLeft" then
            defaultX = startX
            defaultY = startY + dropH + gap
        elseif key == "autoRight" then
            defaultX = startX + BTN_W + gap
            defaultY = startY + dropH + gap
        else
            if key == "bypass" then
                thisW = math.floor(BTN_W * 1.85)
                thisH = math.floor(BTN_H * 0.92)
            end
            local row = math.floor(restIndex / cols)
            local col = restIndex % cols
            defaultX = startX + col * (BTN_W + gap)
            defaultY = startY + topBlockH + gap + row * (BTN_H + gap)
            restIndex = restIndex + 1
        end

        local saved = (not M._forceDefaultMobPos) and savedPositions[key] or nil
        local posX = (saved and type(saved.x) == "number") and saved.x or defaultX
        local posY = (saved and type(saved.y) == "number") and saved.y or defaultY
        local container = Instance.new("Frame")
        container.Name = "Btn_" .. key
        container.Size = UDim2.new(0, thisW, 0, thisH)
        container.Position = UDim2.new(0, posX, 0, posY)
        container:SetAttribute("DefaultX", defaultX)
        container:SetAttribute("DefaultY", defaultY)
        container:SetAttribute("BtnKey", key)
        container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        container.BorderSizePixel = 0
        container.Active = true
        container.ZIndex = 50
        container.Parent = mobGui
        local contCorner = Instance.new("UICorner", container)
        contCorner.CornerRadius = (shape == "Circle") and UDim.new(1, 0) or UDim.new(0, CORNER_R)
        local contStroke = Instance.new("UIStroke", container)
        contStroke.Name = "ContStroke"
        contStroke.Color = C_BORDER
        contStroke.Thickness = 1.5
        contStroke.Transparency = 0.3
        local contGrad = Instance.new("UIGradient", container)
        contGrad.Color = ColorSequence.new(Color3.fromRGB(20, 20, 20), Color3.fromRGB(50, 50, 50))
        contGrad.Rotation = 90

        local btn = Instance.new("TextButton")
        btn.Name = "Inner"
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 52
        btn:SetAttribute("BtnKey", key)
        btn.Parent = container
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = (shape == "Circle") and UDim.new(1, 0) or UDim.new(0, CORNER_R)
        local btnGrad = Instance.new("UIGradient", btn)
        btnGrad.Name = "BtnGrad"
        btnGrad.Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(15, 15, 15))
        btnGrad.Rotation = 90
        local bgImg = nil
        do
            local mobBgId = tonumber(M.mobBtnBgId) or 0
            if mobBgId and mobBgId > 0 then
                bgImg = Instance.new("ImageLabel")
                bgImg.Name = "BtnBgImage"
                bgImg.BackgroundTransparency = 1
                bgImg.Image = "rbxassetid://" .. tostring(mobBgId)
                bgImg.ScaleType = Enum.ScaleType.Crop
                bgImg.Size = UDim2.fromScale(1, 1)
                bgImg.ZIndex = 53
                bgImg.ImageTransparency = 0.15
                bgImg.Parent = btn
                local bgc = Instance.new("UICorner", bgImg)
                bgc.CornerRadius = (shape == "Circle") and UDim.new(1, 0) or UDim.new(0, CORNER_R)
                btn.BackgroundTransparency = 0.55
            end
        end
        local stroke = Instance.new("UIStroke", btn)
        stroke.Name = "BtnStroke"
        stroke.Color = C_BORDER
        stroke.Thickness = 1
        stroke.Transparency = 0.5
        local lbl = Instance.new("TextLabel", btn)
        lbl.Name = "Lbl"
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = C_TEXT_SUB
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = 10
        lbl.TextWrapped = true
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.ZIndex = 56

        local isOn = false
        local function updateStyle(state)
            local hasImg = bgImg ~= nil
            if isOn then
                btnGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(160, 160, 160))
                lbl.TextColor3 = C_BTN_ON_TEXT
                stroke.Color = C_TEXT
                stroke.Thickness = 2
                stroke.Transparency = 0
                contStroke.Color = C_TEXT
                contStroke.Transparency = 0
                if hasImg then
                    bgImg.ImageTransparency = 0.35
                    btn.BackgroundTransparency = 0.25
                end
            else
                if state == "hover" then
                    btnGrad.Color = ColorSequence.new(Color3.fromRGB(65, 65, 65), Color3.fromRGB(35, 35, 35))
                    lbl.TextColor3 = C_TEXT
                    stroke.Color = C_BORDER
                    stroke.Thickness = 1
                    stroke.Transparency = 0.2
                    contStroke.Color = C_BORDER
                    contStroke.Transparency = 0.1
                    if hasImg then bgImg.ImageTransparency = 0.08 end
                elseif state == "press" then
                    btnGrad.Color = ColorSequence.new(Color3.fromRGB(85, 85, 85), Color3.fromRGB(50, 50, 50))
                    lbl.TextColor3 = C_TEXT
                    stroke.Color = C_BORDER
                    stroke.Thickness = 1
                    stroke.Transparency = 0
                    contStroke.Color = C_BORDER
                    contStroke.Transparency = 0
                    if hasImg then bgImg.ImageTransparency = 0.2 end
                else
                    btnGrad.Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(15, 15, 15))
                    lbl.TextColor3 = C_TEXT_SUB
                    stroke.Color = C_BORDER
                    stroke.Thickness = 1
                    stroke.Transparency = 0.5
                    contStroke.Color = C_BORDER
                    contStroke.Transparency = 0.3
                    if hasImg then
                        bgImg.ImageTransparency = 0.15
                        btn.BackgroundTransparency = 0.55
                    end
                end
            end
        end
        local function setOn(v)
            isOn = v and true or false
            updateStyle("idle")
        end

        M.mobBtnRefs[key] = setOn

        btn.MouseButton1Down:Connect(function() updateStyle("press") end)
        btn.MouseButton1Up:Connect(function() updateStyle("hover") end)
        btn.MouseEnter:Connect(function() updateStyle("hover") end)
        btn.MouseLeave:Connect(function() updateStyle("idle") end)

        local dragging = false
        local dragStart = nil
        local startPos = nil
        local moved = false
        local clickBlocked = false
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                clickBlocked = false
                moved = false
                if not M.uiLocked then
                    dragging = true
                    dragStart = input.Position
                    startPos = container.Position
                end
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if M.uiLocked or not dragging or not dragStart then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                if not moved and (math.abs(delta.X) + math.abs(delta.Y)) > 8 then
                    moved = true
                    clickBlocked = true
                end
                if moved then
                    container.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging and moved then
                    pcall(function() M.saveBtnPositions() end)
                end
                dragging = false
                dragStart = nil
                startPos = nil
            end
        end)

        btn.Activated:Connect(function()
            if clickBlocked then clickBlocked = false; return end
            if key == "drop" then
                M.runDrop()
            elseif key == "tpDown" then
                M.runTPFloor()
            elseif key == "autoLeft" then
                if M.autoBatEnabled then
                    M.stopBatAimbot()
                    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
                    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
                end
                if M.autoPlayEnabled then M.stopAutoPlay() end
                if M.autoRightEnabled then
                    M.stopAutoRight()
                    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
                    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                end
                if M.autoLeftEnabled then
                    M.stopAutoLeft()
                else
                    M.startAutoLeft()
                end
                setOn(M.autoLeftEnabled)
                if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
                saveCherryConfig()
            elseif key == "autoRight" then
                if M.autoBatEnabled then
                    M.stopBatAimbot()
                    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
                    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
                end
                if M.autoPlayEnabled then M.stopAutoPlay() end
                if M.autoLeftEnabled then
                    M.stopAutoLeft()
                    if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                end
                if M.autoRightEnabled then
                    M.stopAutoRight()
                else
                    M.startAutoRight()
                end
                setOn(M.autoRightEnabled)
                if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
                saveCherryConfig()
            elseif key == "autoBat" then
                if M.autoPlayEnabled or M.autoLeftEnabled or M.autoRightEnabled then
                    if M.autoPlayEnabled then M.stopAutoPlay() end
                    if M.autoLeftEnabled then M.stopAutoLeft() end
                    if M.autoRightEnabled then M.stopAutoRight() end
                    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                end
                if not M.autoBatEnabled then
                    M.queueAutoBatStart()
                else
                    M.stopBatAimbot()
                end
                setOn(M.autoBatEnabled)
                if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled) end
                saveCherryConfig()
            elseif key == "lagger" then
                M.toggleLaggerMode()
                setOn(M.laggerModeEnabled)
                if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
                if M.laggerModeBtn then
                    M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
                end
                saveCherryConfig()
            elseif key == "carrySpeed" then
                M.toggleCarryMode()
                setOn(M.carrySpeedActive)
                if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
                if M.carryModeBtn then
                    M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
                end
                saveCherryConfig()
            elseif key == "bypass" then
                M.toggleBypassAimbot()
                setOn(M.bypassAimbotEnabled)
                if M.setBypassVisual then M.setBypassVisual(M.bypassAimbotEnabled) end
                saveCherryConfig()
            elseif key == "laggerCarry" then
                M.toggleLaggerCarry()
                setOn(M.laggerCarryActive)
                saveCherryConfig()
            end
        end)
    end

    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
end

-- ============================================================
-- MENÚ PRINCIPAL CON ESTILO SUREHUB
-- ============================================================

function M.buildGui()
    applyAccentFromTheme()
    M.clearPersistentConns()

    for _,n in ipairs({"MoveeDuels","Cherry_Menu","K7HubGUI","VantaHubUI","VynxxHubUI","VynxHubUI","AceDuelsAdaptReconstruct"}) do
        local cg=game:GetService("CoreGui")
        local old=cg:FindFirstChild(n)
        if old then old:Destroy() end
        local pg=player:FindFirstChild("PlayerGui")
        if pg then
            local o=pg:FindFirstChild(n)
            if o then o:Destroy() end
        end
    end

    M.buildStatusUI()

    local SILVER = Color3.fromRGB(180, 180, 190)
    local SILVER_DARK = Color3.fromRGB(100, 100, 110)
    local BLACK = Color3.fromRGB(0,0,0)
    local ROW_BG = Color3.fromRGB(10,10,10)
    local ROW_BORDER = Color3.fromRGB(50,50,50)
    local WHITE = Color3.fromRGB(255,255,255)
    local INP = Color3.fromRGB(15,15,15)
    local OFF = Color3.fromRGB(25,25,30)
    local DARK_BLUE = Color3.fromRGB(0, 20, 80)
    local CORNER = 40
    local GUI_W, GUI_H = 420, 500

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxHubUI"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
    end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
        gui.Parent = player:WaitForChild("PlayerGui")
    end

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0, 20, 0, 2)
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, CORNER)

    local mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = 1

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Size = UDim2.new(1,0,1,0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://124833425021074"
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, CORNER)

    local darkOverlay = Instance.new("Frame", main)
    darkOverlay.Size = UDim2.new(1,0,1,0)
    darkOverlay.BackgroundColor3 = BLACK
    darkOverlay.BackgroundTransparency = 0.7
    darkOverlay.BorderSizePixel = 0
    darkOverlay.ZIndex = 1
    Instance.new("UICorner", darkOverlay).CornerRadius = UDim.new(0, CORNER)

    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Color3.fromRGB(0, 150, 255)
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0.3
    mainStroke.ZIndex = 2

    local titleBar = Instance.new("Frame", main)
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundTransparency = 1
    titleBar.ZIndex = 10

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "VYNX DUELS"
    titleLabel.TextColor3 = WHITE
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local titleGrad = Instance.new("UIGradient", titleLabel)
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 60, 120)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 200, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 60, 120))
    })
    titleGrad.Rotation = 45

    task.spawn(function()
        local t = 0
        while titleGrad and titleGrad.Parent do
            t = t + 0.02
            titleGrad.Offset = Vector2.new(math.sin(t * 0.5) * 0.5, 0)
            task.wait(0.03)
        end
    end)

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -15)
    closeBtn.BackgroundColor3 = BLACK
    closeBtn.BackgroundTransparency = 0
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "-"
    closeBtn.TextColor3 = WHITE
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 24
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

    local miniBtn = Instance.new("TextButton", gui)
    miniBtn.Size = UDim2.new(0, 118, 0, 30)
    miniBtn.Position = UDim2.new(0, 16, 0, 58)
    miniBtn.BackgroundColor3 = DARK_BLUE
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = "VYNX"
    miniBtn.TextColor3 = WHITE
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.TextSize = 12
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 8)

    local showGui = function()
        main.Visible = true
        mainUIScale.Scale = 0
        local tween = TweenService:Create(mainUIScale, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1})
        tween:Play()
        miniBtn.Visible = false
    end

    local hideGui = function()
        local tween = TweenService:Create(mainUIScale, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0})
        tween:Play()
        tween.Completed:Connect(function()
            main.Visible = false
            miniBtn.Visible = true
            mainUIScale.Scale = 1
        end)
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(1, -20, 0, 36)
    tabBar.Position = UDim2.new(0, 10, 0, 40)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 10

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local contentArea = Instance.new("Frame", main)
    contentArea.Size = UDim2.new(1, -16, 1, -(40 + 36 + 12))
    contentArea.Position = UDim2.new(0, 8, 0, 40 + 36 + 6)
    contentArea.BackgroundColor3 = BLACK
    contentArea.BackgroundTransparency = 0.4
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    contentArea.ZIndex = 2
    Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 30)

    local contentSt = Instance.new("UIStroke", contentArea)
    contentSt.Color = Color3.fromRGB(0, 150, 255)
    contentSt.Thickness = 1
    contentSt.Transparency = 0.18

    local pageHolder = Instance.new("Frame", contentArea)
    pageHolder.Size = UDim2.new(1, -10, 1, -18)
    pageHolder.Position = UDim2.new(0, 5, 0, 9)
    pageHolder.BackgroundTransparency = 1

    local function buildPage()
        local p = Instance.new("ScrollingFrame", pageHolder)
        p.Size = UDim2.new(1, -2, 1, 0)
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.ClipsDescendants = true
        p.ScrollBarThickness = 8
        p.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
        p.ScrollBarImageTransparency = 0
        p.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        p.CanvasSize = UDim2.new(0, 0, 0, 0)
        p.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local ll = Instance.new("UIListLayout", p)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0, 7)
        local pd = Instance.new("UIPadding", p)
        pd.PaddingLeft = UDim.new(0, 8)
        pd.PaddingRight = UDim.new(0, 8)
        pd.PaddingTop = UDim.new(0, 8)
        pd.PaddingBottom = UDim.new(0, 30)
        return p
    end

    local speedPage = buildPage()
    local otherPage = buildPage()
    otherPage.Visible = false
    local configPage = buildPage()
    configPage.Visible = false
    local keybindsPage = buildPage()
    keybindsPage.Visible = false

    local function makeTopTab(label, idx, page)
        local b = Instance.new("TextButton", tabBar)
        b.Size = UDim2.new(0, 82, 0, 28)
        b.BackgroundColor3 = DARK_BLUE
        b.BackgroundTransparency = 0
        b.BorderSizePixel = 0
        b.Text = label
        b.TextColor3 = WHITE
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.AutoButtonColor = false
        b.LayoutOrder = idx
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
        local s = Instance.new("UIStroke", b)
        s.Color = Color3.fromRGB(120,120,120)
        s.Thickness = 1
        s.Transparency = 0.4
        return b
    end

    local btnSpeed   = makeTopTab("SPEED",  1, speedPage)
    local btnOther   = makeTopTab("OTHER",  2, otherPage)
    local btnConfig  = makeTopTab("CONFIG", 3, configPage)
    local btnKeybinds = makeTopTab("KEYBINDS", 4, keybindsPage)

    local allTabs = {
        {btn=btnSpeed,   page=speedPage},
        {btn=btnOther,   page=otherPage},
        {btn=btnConfig,  page=configPage},
        {btn=btnKeybinds, page=keybindsPage},
    }

    local activePage = speedPage
    local function setActivePage(p)
        activePage = p
        for _, t in ipairs(allTabs) do
            t.page.Visible = (t.page == p)
            local isActive = (t.page == p)
            TweenService:Create(t.btn, TweenInfo.new(0.22), {
                BackgroundColor3 = isActive and WHITE or DARK_BLUE,
                BackgroundTransparency = 0,
                TextColor3 = isActive and Color3.fromRGB(0,0,0) or WHITE,
            }):Play()
            local st = t.btn:FindFirstChildWhichIsA("UIStroke")
            if st then
                TweenService:Create(st, TweenInfo.new(0.22), {
                    Color = isActive and Color3.fromRGB(180,180,180) or Color3.fromRGB(120,120,120),
                    Transparency = isActive and 0.2 or 0.4,
                }):Play()
            end
        end
    end

    btnSpeed.BackgroundColor3 = WHITE
    btnSpeed.BackgroundTransparency = 0
    btnSpeed.TextColor3 = Color3.fromRGB(0,0,0)
    local stSpeed = btnSpeed:FindFirstChildWhichIsA("UIStroke")
    if stSpeed then
        stSpeed.Color = Color3.fromRGB(180,180,180)
        stSpeed.Transparency = 0.2
    end

    btnSpeed.MouseButton1Click:Connect(function() setActivePage(speedPage) end)
    btnOther.MouseButton1Click:Connect(function() setActivePage(otherPage) end)
    btnConfig.MouseButton1Click:Connect(function() setActivePage(configPage) end)
    btnKeybinds.MouseButton1Click:Connect(function() setActivePage(keybindsPage) end)

    setActivePage(speedPage)

    local pageCounters = {}
    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -16, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = Color3.fromRGB(180, 180, 190)
        l.Font = Enum.Font.GothamBlack
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextStrokeColor3 = Color3.fromRGB(60,60,60)
        l.TextStrokeTransparency = 0.3
        l.ZIndex = 8
        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(1, -24, 0, 1.5)
        line.Position = UDim2.new(0, 12, 1, -4)
        line.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        line.BackgroundTransparency = 0.6
        line.BorderSizePixel = 0
        line.ZIndex = 8
        return f
    end

    local function mkRow(page, h)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, h or 38)
        f.BackgroundColor3 = ROW_BG
        f.BackgroundTransparency = 0.7
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local rowStroke = Instance.new("UIStroke", f)
        rowStroke.Color = ROW_BORDER
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.5
        f.MouseEnter:Connect(function()
            TweenService:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28,28,28)}):Play()
        end)
        f.MouseLeave:Connect(function()
            TweenService:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = ROW_BG}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.55, 0, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = WHITE
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.5
        l.ZIndex = 8
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Size = UDim2.new(0, 44, 0, 22)
        pill.Position = UDim2.new(1, -(offset or 52), 0.5, -11)
        pill.BackgroundColor3 = OFF
        pill.BorderSizePixel = 0
        pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke", pill)
        stroke.Color = ROW_BORDER
        stroke.Thickness = 1.2
        stroke.Transparency = 0.6
        local dot = Instance.new("Frame", pill)
        dot.Size = UDim2.new(0, 16, 0, 16)
        dot.Position = UDim2.new(0, 3, 0.5, -8)
        dot.BackgroundColor3 = Color3.fromRGB(60,60,60)
        dot.BorderSizePixel = 0
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        return pill, dot
    end

    local function animPill(pill, dot, on)
        if on then
            TweenService:Create(pill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
            TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                Position = UDim2.new(1, -19, 0.5, -8),
                BackgroundColor3 = WHITE
            }):Play()
        else
            TweenService:Create(pill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = OFF}):Play()
            TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                Position = UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(60,60,60)
            }):Play()
        end
        local stroke = pill:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.2), {
                Color = on and Color3.fromRGB(0, 150, 255) or ROW_BORDER,
                Transparency = on and 0 or 0.6
            }):Play()
        end
    end

    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 38)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 52)
        local on = false
        local function sv(s)
            on = s
            animPill(pill, dot, s)
        end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            on = not on
            sv(on)
            pcall(cb, on)
        end)
        return sv
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = INP
        tb.BackgroundTransparency = 0.7
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = WHITE
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = ROW_BORDER
        bs.Thickness = 1.2
        bs.Transparency = 0.25
        tb.Focused:Connect(function()
            TweenService:Create(bs, TweenInfo.new(0.12), {Color = Color3.fromRGB(0, 150, 255), Transparency = 0}):Play()
        end)
        tb.FocusLost:Connect(function()
            TweenService:Create(bs, TweenInfo.new(0.12), {Color = ROW_BORDER, Transparency = 0.25}):Play()
            if cb then
                local n = tonumber(tb.Text)
                if n then cb(n) else tb.Text = tostring(default) end
            end
        end)
        return tb
    end

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 85, 0, 26)
        btn.Position = UDim2.new(1, -93, 0.5, -13)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        local function getLabel()
            return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None"
        end
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.ZIndex = 5
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = ROW_BORDER
        bs.Thickness = 1
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then
                li = false; M._anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end
                btn.Text = pv; btn.TextColor3 = WHITE
                return
            end
            pv = btn.Text; li = true; M._anyKeyListening = true
            listenStart = tick()
            btn.Text = "..."; btn.TextColor3 = WHITE
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then
                    li = false; M._anyKeyListening = false
                    if lc then lc:Disconnect(); lc = nil end
                    btn.Text = pv; btn.TextColor3 = WHITE
                    return
                end
                local isGp = inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
                if isGp and tick()-listenStart < 0.15 then return end
                if not inp.KeyCode or inp.KeyCode == Enum.KeyCode.Unknown then return end
                if inp.UserInputType ~= Enum.UserInputType.Keyboard and not isGp then return end
                btn.Text = inp.KeyCode.Name
                pv = inp.KeyCode.Name
                btn.TextColor3 = WHITE
                li = false; M._anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end
                if isGp then
                    kbEntry.gp = inp.KeyCode
                    kbEntry.kb = nil
                else
                    kbEntry.kb = inp.KeyCode
                    kbEntry.gp = nil
                end
            end)
        end)
        return btn
    end

    local function addKeybindRow(page, labelText, kbEntry)
        local row = mkRow(page, 36)
        mkLabel(row, labelText)
        mkKeyButton(row, kbEntry)
    end

    mkSect(speedPage, "| Speed")

    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Normal Speed")
        M.normalBox = mkBox(row, M.NS, 50, 56, function(v)
            if v > 0 and v <= 500 then M.NS = v end
        end)
    end

    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Carry Speed")
        M.carryBox = mkBox(row, M.CS, 50, 56, function(v)
            if v > 0 and v <= 500 then M.CS = v end
        end)
    end

    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Lagger Speed")
        M.laggerBox = mkBox(row, M.LAGGER_SPEED, 50, 56, function(v)
            if v > 0 and v <= 500 then M.LAGGER_SPEED = v end
        end)
    end

    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Lagger Carry")
        M.lagger2Box = mkBox(row, M.LAGGER_CARRY_SPEED, 50, 56, function(v)
            if v > 0 and v <= 500 then M.LAGGER_CARRY_SPEED = v end
        end)
    end

    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Bat Aimbot Speed")
        M.batSpeedBox = mkBox(row, M.aimbotSpeed or 57, 50, 56, function(v)
            if v > 0 and v <= 200 then M.aimbotSpeed = v end
        end)
    end

    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Current Mode")
        M.modeValLbl = Instance.new("TextLabel", row)
        M.modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        M.modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        M.modeValLbl.BackgroundTransparency = 1
        M.modeValLbl.Text = "Normal"
        M.modeValLbl.TextColor3 = WHITE
        M.modeValLbl.Font = Enum.Font.GothamBlack
        M.modeValLbl.TextSize = 11
        M.modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
        M.modeValLbl.ZIndex = 8
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function()
            M.toggleCarryMode()
        end)
    end

    mkSect(speedPage, "| Auto Movement")

    M.autoLeftSetVisual = mkToggle(speedPage, "Auto Left", function(on)
        M.autoLeftEnabled = on
        if on then M.startAutoLeft() else M.stopAutoLeft() end
    end)

    M.autoRightSetVisual = mkToggle(speedPage, "Auto Right", function(on)
        M.autoRightEnabled = on
        if on then M.startAutoRight() else M.stopAutoRight() end
    end)

    mkSect(speedPage, "| Drop")

    M.dropBrainrotSetVisual = mkToggle(speedPage, "Drop Brainrot", function(on)
        if on then M.runDrop() end
    end)

    mkSect(speedPage, "| Steal")

    M.setInstaGrab = mkToggle(speedPage, "Auto Steal", function(on)
        M.Steal.AutoStealEnabled = on
        if on then M.startAutoSteal() else M.stopAutoSteal() end
    end)

    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Steal Radius")
        M.radInput = mkBox(row, M.Steal.StealRadius or 62, 50, 56, function(v)
            if v > 0 and v <= 300 then M.Steal.StealRadius = v end
        end)
    end

    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Steal Duration")
        M.durationBox = mkBox(row, M.Steal.StealDuration or 1.4, 50, 56, function(v)
            if v > 0 and v <= 10 then M.Steal.StealDuration = v end
        end)
    end

    setActivePage(otherPage)
    mkSect(otherPage, "| Combat")

    M.autoBatSetVisual = mkToggle(otherPage, "Bat Aimbot", function(on)
        if on then M.queueAutoBatStart() else M.stopBatAimbot() end
    end)

    M.setBatCounterVisual = mkToggle(otherPage, "Bat Counter", function(on)
        M.batCounterEnabled = on
        if on then M.startBatCounter() else M.stopBatCounter() end
    end)

    M.setMedusaVisual = mkToggle(otherPage, "Medusa Counter", function(on)
        M.medusaCounterEnabled = on
        if on then M.setupMedusa(player.Character) else M.stopMedusaCounter() end
    end)

    M.setAntiRagVisual = mkToggle(otherPage, "Anti Ragdoll", function(on)
        M.antiRagdollEnabled = on
        if on then M.startAntiRagdoll() else M.stopAntiRagdoll() end
    end)

    M.setBypassVisual = mkToggle(otherPage, "Bat TP", function(on)
        M.bypassAimbotEnabled = on
        if on then M.startBypassAimbot() else M.stopBypassAimbot() end
    end)

    mkSect(otherPage, "| Survival")

    M.setAntiDieVisual = mkToggle(otherPage, "Anti Die", function(on)
        M.antiDieEnabled = on
        if on then M.startAntiDie() else M.stopAntiDie() end
    end)

    M.setAntiFlingVisual = mkToggle(otherPage, "Anti Fling", function(on)
        M.antiFlingEnabled = on
        if on then M.startAntiFling() else M.stopAntiFling() end
    end)

    mkSect(otherPage, "| Movement")

    M.setUnwalkVisual = mkToggle(otherPage, "Unwalk", function(on)
        M.unwalkEnabled = on
        if on then M.startUnwalk() else M.stopUnwalk() end
    end)

    M.setAutoTPVisual = mkToggle(otherPage, "Auto TP Down", function(on)
        M.autoTPEnabled = on
        if on then M.startAutoTP() else M.stopAutoTP() end
    end)

    M.setInfJumpVisual = mkToggle(otherPage, "Infinite Jump", function(on)
        M.infJumpEnabled = on
        if on then M.startHoldInfJump() else M.stopHoldInfJump() end
    end)

    mkSect(otherPage, "| Visuals")

    M.setAntiLagVisual = mkToggle(otherPage, "Anti Lag", function(on)
        M.antiLagEnabled = on
        if on then M.enableAntiLag() else M.disableAntiLag() end
    end)

    M.setStretchRezVisual = mkToggle(otherPage, "Stretch Rez", function(on)
        M.stretchRezEnabled = on
        if on then M.enableStretchRez() else M.disableStretchRez() end
    end)

    setActivePage(configPage)
    mkSect(configPage, "| Interface")

    M.setLockVisual = mkToggle(configPage, "Lock UI", function(on)
        M.uiLocked = on
    end)

    do
        local row = mkRow(configPage, 38)
        mkLabel(row, "UI Scale")
        M.uiScaleBox = mkBox(row, M.uiScale * 100, 50, 56, function(v)
            local n = math.clamp(math.floor(v+0.5), 50, 150)
            M.uiScale = n / 100
            if M.uiScaleRef then M.uiScaleRef.Scale = M.uiScale end
        end)
    end

    mkSect(configPage, "| Config")

    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(1, -12, 0.8, 0)
        saveBtn.Position = UDim2.new(0, 6, 0.1, 0)
        saveBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
        saveBtn.BackgroundTransparency = 0.5
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = WHITE
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 13
        saveBtn.TextStrokeColor3 = Color3.fromRGB(60,60,60)
        saveBtn.TextStrokeTransparency = 0
        saveBtn.AutoButtonColor = false
        saveBtn.ZIndex = 8
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)
        local saveStroke = Instance.new("UIStroke", saveBtn)
        saveStroke.Color = ROW_BORDER
        saveStroke.Thickness = 1.2
        saveStroke.Transparency = 0.5
        saveBtn.MouseButton1Click:Connect(function()
            local ok = M.saveConfig()
            saveBtn.Text = ok and "SAVED ✓" or "ERROR"
            task.delay(1.2, function()
                if saveBtn and saveBtn.Parent then
                    saveBtn.Text = "SAVE CONFIG"
                end
            end)
        end)
    end

    setActivePage(keybindsPage)
    mkSect(keybindsPage, "Keybinds")

    addKeybindRow(keybindsPage, "Carry Mode", M.KB.SpeedToggle)
    addKeybindRow(keybindsPage, "Lagger Mode", M.KB.LaggerToggle)
    addKeybindRow(keybindsPage, "Auto Left", M.KB.AutoLeft)
    addKeybindRow(keybindsPage, "Auto Right", M.KB.AutoRight)
    addKeybindRow(keybindsPage, "Auto Bat", M.KB.AutoBat)
    addKeybindRow(keybindsPage, "TP Down", M.KB.TPFloor)
    addKeybindRow(keybindsPage, "Drop Brainrot", M.KB.DropBrainrot)
    addKeybindRow(keybindsPage, "Hide GUI", M.KB.GuiHide)

    local spacer = Instance.new("Frame", keybindsPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keybindsPage)
    spacer.ZIndex = 7

    M.pbFrame = Instance.new("Frame", gui)
    M.pbFrame.Size = UDim2.new(0, 280, 0, 34)
    M.pbFrame.Position = UDim2.new(0.5, -140, 1, -50)
    M.pbFrame.BackgroundColor3 = BLACK
    M.pbFrame.BackgroundTransparency = 0.15
    M.pbFrame.BorderSizePixel = 0
    M.pbFrame.Active = true
    M.pbFrame.ClipsDescendants = true
    M.pbFrame.Visible = M.Steal.AutoStealEnabled
    M.pbFrame.ZIndex = 10
    M.pbScale = Instance.new("UIScale", M.pbFrame)
    M.pbScale.Scale = M.uiScale

    if M.savedProgressBarPos then
        M.pbFrame.Position = UDim2.new(
            M.savedProgressBarPos.XScale or 0.5,
            M.savedProgressBarPos.XOffset or -140,
            M.savedProgressBarPos.YScale or 1,
            M.savedProgressBarPos.YOffset or -50
        )
    end

    Instance.new("UICorner", M.pbFrame).CornerRadius = UDim.new(1, 0)
    local pbSt = Instance.new("UIStroke", M.pbFrame)
    pbSt.Color = Color3.fromRGB(0, 150, 255)
    pbSt.Thickness = 2
    pbSt.Transparency = 0.15

    local fillRegion = Instance.new("Frame", M.pbFrame)
    fillRegion.Size = UDim2.new(0, 170, 1, -8)
    fillRegion.Position = UDim2.new(0, 4, 0, 4)
    fillRegion.BackgroundColor3 = Color3.fromRGB(20,20,25)
    fillRegion.BackgroundTransparency = 0.4
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    fillRegion.ZIndex = 11
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(1, 0)

    M.statusFill = Instance.new("Frame", fillRegion)
    M.statusFill.Size = UDim2.new(0, 0, 1, 0)
    M.statusFill.Position = UDim2.new(0, 0, 0, 0)
    M.statusFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    M.statusFill.BorderSizePixel = 0
    M.statusFill.ZIndex = 12
    Instance.new("UICorner", M.statusFill).CornerRadius = UDim.new(1, 0)

    M.statusPctLbl = Instance.new("TextLabel", fillRegion)
    M.statusPctLbl.Size = UDim2.new(0, 44, 1, 0)
    M.statusPctLbl.Position = UDim2.new(1, -52, 0, 0)
    M.statusPctLbl.BackgroundTransparency = 1
    M.statusPctLbl.Text = "0%"
    M.statusPctLbl.TextColor3 = WHITE
    M.statusPctLbl.Font = Enum.Font.GothamBold
    M.statusPctLbl.TextSize = 10
    M.statusPctLbl.TextXAlignment = Enum.TextXAlignment.Right
    M.statusPctLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    M.statusPctLbl.TextStrokeTransparency = 0.2
    M.statusPctLbl.ZIndex = 14

    M.statusRadLbl = Instance.new("TextLabel", M.pbFrame)
    M.statusRadLbl.Size = UDim2.new(0, 92, 1, 0)
    M.statusRadLbl.Position = UDim2.new(0, 184, 0, 0)
    M.statusRadLbl.BackgroundTransparency = 1
    M.statusRadLbl.Text = "--FPS · --ms"
    M.statusRadLbl.TextColor3 = Color3.fromRGB(200,200,200)
    M.statusRadLbl.Font = Enum.Font.GothamBold
    M.statusRadLbl.TextSize = 9
    M.statusRadLbl.TextXAlignment = Enum.TextXAlignment.Center
    M.statusRadLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    M.statusRadLbl.TextStrokeTransparency = 0.2
    M.statusRadLbl.ZIndex = 14

    function drag(f)
        local dn, ds, sp, di = false
        f.InputBegan:Connect(function(i)
            if M.uiLocked then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dn = true; ds = i.Position; sp = f.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dn = false end
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
                if M.uiLocked then dn = false; return end
                local nX = sp.X.Offset + (i.Position.X - ds.X)
                local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
                f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
            end
        end)
    end

    drag(M.pbFrame)

    task.spawn(function()
        local lastPct = 0
        while task.wait() do
            local targetPct = 0
            if M.isStealing then
                local elapsed = tick() - M.stealStartTime
                local duration = M.Steal.StealDuration
                targetPct = math.clamp(elapsed / duration, 0, 1)
            end
            lastPct = lastPct + (targetPct - lastPct) * math.min(0.18 * 0.35 * 60, 1)
            local f = math.clamp(lastPct, 0, 1)
            if M.statusFill then
                M.statusFill.Size = UDim2.new(f, 0, 1, 0)
            end
            if M.statusPctLbl then
                M.statusPctLbl.Text = math.floor(f * 100) .. "%"
            end
        end
    end)

    task.spawn(function()
        local lastFrame = tick()
        local fpsSamples = {}
        local fpsAvg = 60
        RunService.RenderStepped:Connect(function()
            local now = tick()
            local dt = now - lastFrame
            lastFrame = now
            if dt > 0 then
                table.insert(fpsSamples, 1 / dt)
                if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
                local sum = 0
                for _, v in ipairs(fpsSamples) do sum = sum + v end
                fpsAvg = sum / #fpsSamples
            end
        end)
        while true do
            local ping = 0
            pcall(function() ping = player:GetNetworkPing() * 1000 end)
            if M.statusRadLbl then
                M.statusRadLbl.Text = string.format("%dFPS · %dms", math.floor(fpsAvg + 0.5), math.floor(ping + 0.5))
            end
            task.wait(0.5)
        end
    end)

    drag(main)
    showGui()

    M.updateStatusRadius()
    M.startHeadSpeedUpdates()
end

-- Configuración y carga del archivo de configuración
local CHERRY_CONFIG_NAME = "CherryConfig.json"
local CherryConfig = { Theme="Red" }
local CHERRY_THEMES = {
    White    = { Accent=Color3.fromRGB(255,255,255), AccentDim=Color3.fromRGB(180,180,190), Bg=Color3.fromRGB(0,0,0),     Row=Color3.fromRGB(8,8,12) },
    Purple   = { Accent=Color3.fromRGB(165,75,255),  AccentDim=Color3.fromRGB(120,50,200),  Bg=Color3.fromRGB(8,4,14),    Row=Color3.fromRGB(16,10,24) },
    Red      = { Accent=Color3.fromRGB(225,45,55),   AccentDim=Color3.fromRGB(160,30,40),   Bg=Color3.fromRGB(8,2,4),     Row=Color3.fromRGB(20,8,11) },
    Green    = { Accent=Color3.fromRGB(46,200,120),  AccentDim=Color3.fromRGB(30,140,80),   Bg=Color3.fromRGB(4,12,8),    Row=Color3.fromRGB(10,22,14) },
    Default  = { Accent=Color3.fromRGB(255,255,255), AccentDim=Color3.fromRGB(180,180,190), Bg=Color3.fromRGB(0,0,0),     Row=Color3.fromRGB(8,8,12) },
    Blue     = { Accent=Color3.fromRGB(58,128,245),  AccentDim=Color3.fromRGB(40,90,180),   Bg=Color3.fromRGB(4,8,16),    Row=Color3.fromRGB(10,16,28) },
    Pink     = { Accent=Color3.fromRGB(255,105,180), AccentDim=Color3.fromRGB(200,80,140),  Bg=Color3.fromRGB(14,6,12),   Row=Color3.fromRGB(24,12,20) },
    Yellow   = { Accent=Color3.fromRGB(255,214,0),   AccentDim=Color3.fromRGB(200,170,0),   Bg=Color3.fromRGB(12,12,4),   Row=Color3.fromRGB(20,18,8) },
    Grey     = { Accent=Color3.fromRGB(180,180,185), AccentDim=Color3.fromRGB(120,120,125), Bg=Color3.fromRGB(10,10,12),  Row=Color3.fromRGB(18,18,20) },
    Forest   = { Accent=Color3.fromRGB(46,200,120),  AccentDim=Color3.fromRGB(30,140,80),   Bg=Color3.fromRGB(4,12,8),    Row=Color3.fromRGB(10,22,14) },
    Cyan     = { Accent=Color3.fromRGB(0,220,255),   AccentDim=Color3.fromRGB(0,160,190),   Bg=Color3.fromRGB(4,12,16),   Row=Color3.fromRGB(8,20,26) },
    Orange   = { Accent=Color3.fromRGB(255,140,40),  AccentDim=Color3.fromRGB(200,100,30),  Bg=Color3.fromRGB(14,8,4),    Row=Color3.fromRGB(24,14,8) },
}
M.COMBAT_COLOR_THEMES = {"Red", "White", "Purple", "Green"}
if M._savedTheme and CHERRY_THEMES[M._savedTheme] then
    CherryConfig.Theme = M._savedTheme
end
M.colorScheme = CherryConfig.Theme
M.DEFAULT_BG_ID = 78248012786524
M.DEFAULT_MOB_BTN_BG_ID = 92132591931954
M.customBgId = 78248012786524
M.customBgOpacity = 0.35
M.mobBtnBgId = 92132591931954
M.BG_IMAGE_IDS = {
    78248012786524, 
    79737099962715,
    71211662493854,
    15556272558,
    1471587689,
    14349182390,
    108236541541009,
    86526406500677,
    125028284461731,
    138241571198031,
}
M.MOB_BTN_IMAGE_IDS = {
    92132591931954, 
    15101684346,
    39396,
    109592813321691,
    83661129801187,
    94353803110527,
    109100201685955,
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
        if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then themeName = d.colorScheme end
        
        if themeName == "Default" then themeName = "Red"
        elseif themeName == "Forest" then themeName = "Green" end
        if themeName and CHERRY_THEMES[themeName] then
            CherryConfig.Theme = themeName
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
        if type(d.grabRadius)=="number" then M.Steal.StealRadius=d.grabRadius end
        if type(d.stealDuration)=="number" then M.Steal.StealDuration=d.stealDuration end
        if type(d.stealStopTime)=="number" then M.Steal.StopTime=d.stealStopTime end
        if type(d.stealMode)=="string" then
            if d.stealMode == "Semi" or d.stealMode == "Normal" or d.stealMode == "V1" or d.stealMode == "V2" or d.stealMode == "V3" then
                M.stealMode=d.stealMode
            end
        end
        if type(d.autoTPHeight)=="number" then M.autoTPHeight=d.autoTPHeight end
        if type(d.fovValue)=="number" then M.fovValue=d.fovValue end
        if type(d.uiScale)=="number" then M.uiScale=d.uiScale end
        M.infJumpMode="hold" 
        if type(d.mobileButtonsSize)=="number" then M.mobileButtonsSize=d.mobileButtonsSize end
        if type(d.skyTheme)=="string" then M.currentSkyTheme=d.skyTheme end
        if type(d.stealBarSize)=="number" then M.stealBarSize=d.stealBarSize end
        
        if M.stealBarSize == 480 or M.stealBarSize == 520 then M.stealBarSize = 360 end
        if d.carrySpeedActive~=nil then M.carrySpeedActive=d.carrySpeedActive end
        if d.laggerModeEnabled~=nil then M.laggerModeEnabled=d.laggerModeEnabled end
        if d.speedBoosterEnabled~=nil then M.speedBoosterEnabled=d.speedBoosterEnabled==true end
        if type(d.speedBoosterPath)=="string" and (d.speedBoosterPath=="Normal" or d.speedBoosterPath=="Lagger") then M.speedBoosterPath=d.speedBoosterPath end
        if d.speedBoosterPanelOpen~=nil then M.speedBoosterPanelOpen=d.speedBoosterPanelOpen~=false end
        if type(d.speedBoosterPos)=="table" then M.speedBoosterPos=d.speedBoosterPos end
        if type(d.speedUIMode)=="string" and (d.speedUIMode=="Customizer" or d.speedUIMode=="Original") then M.speedUIMode=d.speedUIMode end
        if (M.speedUIMode or "Original") ~= "Original" then
            M.autoSwitchSpeedEnabled=false; M.autoTurnOffSpeedEnabled=false; M.autoSwitchLaggerSpeedEnabled=false
        end
        if d.autoSwing~=nil then M.autoSwingEnabled=d.autoSwing==true end
        if type(d.aimbotSpeed)=="number" then M.aimbotSpeed=d.aimbotSpeed end
        if d.introSoundEnabled~=nil then M.introSoundEnabled=d.introSoundEnabled==true end
        if d.introGUIEnabled~=nil then M.introGUIEnabled=d.introGUIEnabled==true end
        if d.ragdollGui~=nil then M.ragdollGuiEnabled=d.ragdollGui==true end
        if type(d.mobileButtonShape)=="string" and (d.mobileButtonShape=="Normal" or d.mobileButtonShape=="Circle") then
            M.mobileButtonShape = (d.mobileButtonShape == "Cube") and "Normal" or d.mobileButtonShape
            M.circleButtonsEnabled = (M.mobileButtonShape == "Circle")
        elseif d.circleButtonsEnabled~=nil then
            M.circleButtonsEnabled = d.circleButtonsEnabled==true
            M.mobileButtonShape = M.circleButtonsEnabled and "Circle" or "Normal"
        end
        if d.perButtonDrag~=nil then M.perButtonDragEnabled=d.perButtonDrag==true end
        if d.mobileButtonsEnabled~=nil then M.mobileButtonsEnabled=d.mobileButtonsEnabled end
        M.medusaResetEnabled = false 
        if type(d.medusaResetDelay)=="number" then M.medusaResetDelay=d.medusaResetDelay end
        if d.autoMoveSwing~=nil then M.autoMoveSwingEnabled=d.autoMoveSwing==true end
        if d.autoSwitchSpeed~=nil then M.autoSwitchSpeedEnabled=d.autoSwitchSpeed==true end
        if d.autoCarryEnemyBase~=nil then M.autoCarryEnemyBaseEnabled=d.autoCarryEnemyBase==true end
        if type(d.autoCarryEnemyBaseRange)=="number" then M.autoCarryEnemyBaseRange=d.autoCarryEnemyBaseRange end
        if d.autoTurnOffSpeed~=nil then M.autoTurnOffSpeedEnabled=d.autoTurnOffSpeed==true end
        if d.autoSwitchLaggerSpeed~=nil then M.autoSwitchLaggerSpeedEnabled=d.autoSwitchLaggerSpeed==true end
        if type(d.customFont)=="string" then M.customFontSelected=d.customFont end
        if d.showPlayerSpeeds~=nil then M.showPlayerSpeeds=d.showPlayerSpeeds==true end
        if d.removeAcc~=nil then M.removeAccEnabled=d.removeAcc end
        if d.playerESPEnabled~=nil then M.playerESPEnabled=d.playerESPEnabled end
        if d.antiRagdoll~=nil then M.antiRagdollEnabled=d.antiRagdoll end
        if type(d.antiRagdollMode)=="string" and (d.antiRagdollMode=="Splatter" or d.antiRagdollMode=="No Splatter") then M.antiRagdollMode=d.antiRagdollMode end
        if d.ragdollTPBase~=nil then M.ragdollTPBaseEnabled=d.ragdollTPBase==true end
        if type(d.ragdollTPBaseRange)=="number" then M.ragdollTPBaseRange=d.ragdollTPBaseRange end
        if d.autoStealEnabled~=nil then M.Steal.AutoStealEnabled=d.autoStealEnabled end
        if d.autoRadiusEnabled~=nil then M.autoRadiusEnabled=d.autoRadiusEnabled==true end

        if d.infiniteJump~=nil then M.infJumpEnabled=d.infiniteJump end
        if d.medusaCounter~=nil then M.medusaCounterEnabled=d.medusaCounter end
        if d.batCounter~=nil then M.batCounterEnabled=d.batCounter end
        M.unwalkEnabled=false; M.medusaResetEnabled=false; M.autoResetOnDeath=false 
        if d.antiLag~=nil then M.antiLagEnabled=d.antiLag end
        if d.nukeOptEnabled~=nil then M.nukeOptEnabled=d.nukeOptEnabled==true end
        if d.antiSummerBase~=nil then M.antiSummerBaseEnabled=d.antiSummerBase end
        if d.uiLocked~=nil then M.uiLocked=d.uiLocked==true end
        if d.stretchRez~=nil then M.stretchRezEnabled=d.stretchRez end
        if d.autoTPEnabled~=nil then M.autoTPEnabled=d.autoTPEnabled end
        if d.antiKick~=nil then M.antiKickEnabled=d.antiKick end
        if d.antiDie~=nil then M.antiDieEnabled = (d.antiDie ~= false) else M.antiDieEnabled = true end
        if d.antiFling~=nil then M.antiFlingEnabled=d.antiFling~=false end
        if d.safeMode~=nil then M.safeModeEnabled=d.safeMode end
        if d.mirrorTPDown ~= nil then M.mirrorTPDownEnabled = d.mirrorTPDown == true else M.mirrorTPDownEnabled = false end
        
        M.customBgId = M.DEFAULT_BG_ID or 78248012786524
        
        do
            local oldDefault = 127281366474870
            local forced = M.DEFAULT_BG_ID or 78248012786524
            local loaded = nil
            if type(d.customBgId)=="number" then loaded = d.customBgId
            elseif type(d.customBgId)=="string" and tonumber(d.customBgId) then loaded = tonumber(d.customBgId) end
            if loaded and loaded ~= oldDefault and loaded ~= forced then
                M.customBgId = loaded
            else
                M.customBgId = forced
            end
        end
        if type(d.customBgOpacity)=="number" then M.customBgOpacity=math.clamp(d.customBgOpacity,0,1) end
        if type(d.mobBtnBgId)=="number" then
            M.mobBtnBgId = d.mobBtnBgId
        elseif type(d.mobBtnBgId)=="string" and tonumber(d.mobBtnBgId) then
            M.mobBtnBgId = tonumber(d.mobBtnBgId)
        else
            M.mobBtnBgId = M.DEFAULT_MOB_BTN_BG_ID or 92132591931954
        end
        if d.autoBat~=nil then M.autoBatEnabled=d.autoBat end
        M.aimbotRotationEnabled = true 
        if d.aimbotCameraRotation~=nil then M.aimbotCameraRotation=d.aimbotCameraRotation~=false end
        if d.semiHoldMin then M.Semi.holdMin=d.semiHoldMin end
        if d.semiHoldMax then M.Semi.holdMax=d.semiHoldMax end
        if d.semiEntryDelay then M.Semi.entryDelay=d.semiEntryDelay end
        if d.semiPrimeRange then M.Semi.primeRange=d.semiPrimeRange end
        if type(d.semiRadius)=="number" then M.Semi.radius=math.min(d.semiRadius, 10) end
        if d.lineESPEnabled~=nil then M.lineESPEnabled=d.lineESPEnabled end
        if d.menuOpen~=nil then M.menuOpen=d.menuOpen~=false end
        
        do
            local tn = nil
            if type(d.Theme)=="string" and CHERRY_THEMES[d.Theme] then tn = d.Theme end
            if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then tn = d.colorScheme end
            if tn == "Default" then tn = "Red" elseif tn == "Forest" then tn = "Green" end
            if tn and CHERRY_THEMES[tn] then
                M._savedTheme = tn
                M.colorScheme = tn
                CherryConfig.Theme = tn
            end
        end
        if d.speedESPEnabled~=nil then M.speedESPEnabled=d.speedESPEnabled end
        M.autoResetOnDeath = false 
        if type(d.animPack)=="string" then M.animPack=d.animPack end
        if d.headlessEnabled~=nil then M.headlessEnabled=d.headlessEnabled end
        if d.korbloxEnabled~=nil then M.korbloxEnabled=d.korbloxEnabled end
        if type(d.customAccessoryIds)=="table" then
            M.customAccessoryIds = {}
            for _, id in ipairs(d.customAccessoryIds) do
                local n = tonumber(id)
                if n and n > 0 then table.insert(M.customAccessoryIds, n) end
            end
        end
        if type(d.presetAccessoryOn)=="table" then
            M.presetAccessoryOn = {}
            for k, v in pairs(d.presetAccessoryOn) do
                M.presetAccessoryOn[tostring(k)] = v and true or false
            end
        end
        if d.skinKeepOnRespawn~=nil then M.skinKeepOnRespawn = d.skinKeepOnRespawn ~= false end
        if type(d.customShirtId)=="number" then M.customShirtId = d.customShirtId
        elseif d.customShirtId == false or d.customShirtId == nil then M.customShirtId = nil end
        if type(d.customPantsId)=="number" then M.customPantsId = d.customPantsId
        elseif d.customPantsId == false or d.customPantsId == nil then M.customPantsId = nil end
        if type(d.bodySkinPreset)=="string" then M.bodySkinPreset = d.bodySkinPreset end
        if type(d.bodySkinCustomRGB)=="table" then
            M.bodySkinCustomRGB = {
                tonumber(d.bodySkinCustomRGB[1]) or 163,
                tonumber(d.bodySkinCustomRGB[2]) or 162,
                tonumber(d.bodySkinCustomRGB[3]) or 165,
            }
        end
        if d.bypassAimbotEnabled~=nil then M.bypassAimbotEnabled=d.bypassAimbotEnabled end
        M.tpBatSureHitEnabled = true 
        if d.bodyLockEnabled~=nil then M.bodyLockEnabled=d.bodyLockEnabled end
        if type(d.bodyLockRadius)=="number" then M.bodyLockRadius=d.bodyLockRadius end
        if d.hardHitEnabled~=nil then M.hardHitEnabled=d.hardHitEnabled end
        if type(d.hardHitRadius)=="number" then M.hardHitRadius=d.hardHitRadius end
        if d.ultraModeEnabled~=nil then M.ultraModeEnabled=d.ultraModeEnabled end
        M.antiDesyncPanelOpen = false 
        if d.musicPanelOpen~=nil then M.musicPanelOpen=d.musicPanelOpen==true end
        if d.pingPanelOpen~=nil then M.pingPanelOpen=d.pingPanelOpen==true end
        if type(d.pingPower)=="number" then M.pingPower=d.pingPower end
        if type(d.pingInterval)=="number" then M.pingInterval=d.pingInterval end
        if type(d.vynxLaggerLevel)=="string" and (d.vynxLaggerLevel=="Low" or d.vynxLaggerLevel=="Mid" or d.vynxLaggerLevel=="High") then
            M.vynxLaggerLevel = d.vynxLaggerLevel
        end
        if d.vynxLaggerPanelOpen~=nil then M.vynxLaggerPanelOpen=d.vynxLaggerPanelOpen==true end
        if type(d.vynxLaggerKeybindKb)=="string" then M.vynxLaggerKeybindKb=d.vynxLaggerKeybindKb end
        if type(d.pingKeybindKb)=="string" then M.pingKeybindKb=d.pingKeybindKb end
        if type(d.pingKeybindGp)=="string" then M.pingKeybindGp=d.pingKeybindGp end
        if d.pingAutoBrainrot~=nil then M.pingAutoBrainrot=d.pingAutoBrainrot~=false end
        if d.musicLastTrackId~=nil then M.musicLastTrackId=d.musicLastTrackId end
        if type(d.musicVolume)=="number" then M.musicVolume=math.clamp(d.musicVolume,0,1) end
        if d.musicWasPlaying~=nil then M.musicWasPlaying=d.musicWasPlaying==true end
        if type(d.musicPanelPos)=="table" then M.musicPanelPos=d.musicPanelPos end
        if type(d.menuPos)=="table" then M.menuPos=d.menuPos end
        if type(d.btnPos)=="table" then M._btnPosCache=d.btnPos end
        if type(d.pingPanelPos)=="table" then M.pingPanelPos=d.pingPanelPos end
        if type(d.vynxLaggerPanelPos)=="table" then M.vynxLaggerPanelPos=d.vynxLaggerPanelPos end
        if d.antiDesyncShield~=nil then M.antiDesyncShield=d.antiDesyncShield==true end
        if d.antiDesyncVelocity~=nil then M.antiDesyncVelocity=d.antiDesyncVelocity==true end
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
        if d.laggerCarryKey then lk(M.KB.LaggerCarry,d.laggerCarryKey) end
        if d.tpFloorKey then lk(M.KB.TPFloor,d.tpFloorKey) end
        if d.guiHideKey then lk(M.KB.GuiHide,d.guiHideKey) end
        if d.speedToggleKey then lk(M.KB.SpeedToggle,d.speedToggleKey) end
        if d.bypassAimbotKey then lk(M.KB.BypassAimbot,d.bypassAimbotKey) end
        if d.bodyLockKey then lk(M.KB.BodyLock,d.bodyLockKey) end
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
        Theme=(M._savedTheme or M.colorScheme or CherryConfig.Theme or "White"), colorScheme=(M.colorScheme or M._savedTheme or CherryConfig.Theme or "White"), menuOpen=M.menuOpen~=false,
        normalSpeed=M.NS, carrySpeed=M.CS, laggerSpeed=M.LAGGER_SPEED,
        laggerCarrySpeed=M.LAGGER_CARRY_SPEED, speedMethod=M.speedMethod, grabRadius=M.Steal.StealRadius,
        stealDuration=M.Steal.StealDuration, stealStopTime=M.Steal.StopTime, stealMode=M.stealMode,
        autoTPHeight=M.autoTPHeight, fovValue=M.fovValue, uiScale=M.uiScale,
        infJumpMode=M.infJumpMode,
        mobileButtonsSize=M.mobileButtonsSize, skyTheme=M.currentSkyTheme,
        customBgId=tonumber(M.customBgId) or 0, customBgOpacity=tonumber(M.customBgOpacity) or 0.35,
        mobBtnBgId=tonumber(M.mobBtnBgId) or 0,
        stealBarSize=M.stealBarSize,
        carrySpeedActive=((M.speedUIMode or "Original")=="Original") and (M.carrySpeedActive==true) or false, laggerModeEnabled=((M.speedUIMode or "Original")=="Original") and (M.laggerModeEnabled==true) or false, speedBoosterEnabled=M.speedBoosterEnabled~=false, speedBoosterPath=M.speedBoosterPath or "Normal", speedBoosterPanelOpen=M.speedBoosterPanelOpen~=false, speedUIMode=M.speedUIMode or "Original", speedBoosterPos=M.speedBoosterPos,
        autoSwing=M.autoSwingEnabled, aimbotSpeed=M.aimbotSpeed, introSoundEnabled=M.introSoundEnabled,
        introGUIEnabled=M.introGUIEnabled,
        ragdollGui=M.ragdollGuiEnabled, circleButtonsEnabled=M.circleButtonsEnabled, mobileButtonShape=M.mobileButtonShape or "Normal",
        perButtonDrag=M.perButtonDragEnabled, mobileButtonsEnabled=M.mobileButtonsEnabled,
        medusaReset=false, medusaResetDelay=M.medusaResetDelay, autoMoveSwing=M.autoMoveSwingEnabled,
        autoSwitchSpeed=M.autoSwitchSpeedEnabled, autoTurnOffSpeed=M.autoTurnOffSpeedEnabled, autoSwitchLaggerSpeed=M.autoSwitchLaggerSpeedEnabled, autoCarryEnemyBase=M.autoCarryEnemyBaseEnabled, autoCarryEnemyBaseRange=M.autoCarryEnemyBaseRange, customFont=M.customFontSelected, showPlayerSpeeds=M.showPlayerSpeeds,
        removeAcc=M.removeAccEnabled,
        playerESPEnabled=M.playerESPEnabled,
        autoStealEnabled=M.Steal.AutoStealEnabled,
        autoRadiusEnabled=M.autoRadiusEnabled,
        antiRagdoll=M.antiRagdollEnabled, antiRagdollMode=M.antiRagdollMode, ragdollTPBase=M.ragdollTPBaseEnabled==true, ragdollTPBaseRange=tonumber(M.ragdollTPBaseRange) or 50, infiniteJump=M.infJumpEnabled,
        medusaCounter=M.medusaCounterEnabled, batCounter=M.batCounterEnabled,
        unwalkEnabled=M.unwalkEnabled, antiLag=M.antiLagEnabled, nukeOptEnabled=M.nukeOptEnabled==true, antiSummerBase=M.antiSummerBaseEnabled, uiLocked=M.uiLocked,
        stretchRez=M.stretchRezEnabled, autoTPEnabled=M.autoTPEnabled,
        antiKick=M.antiKickEnabled, antiDie=M.antiDieEnabled==true, antiFling=M.antiFlingEnabled~=false, safeMode=M.safeModeEnabled, mirrorTPDown=M.mirrorTPDownEnabled, autoBat=M.autoBatEnabled, aimbotRotationEnabled=M.aimbotRotationEnabled~=false, aimbotCameraRotation=M.aimbotCameraRotation~=false, tpBatSureHit=M.tpBatSureHitEnabled==true,
        bodyLockEnabled=M.bodyLockEnabled, bodyLockRadius=M.bodyLockRadius,
        hardHitEnabled=M.hardHitEnabled, hardHitRadius=M.hardHitRadius, ultraModeEnabled=M.ultraModeEnabled, antiDesyncPanelOpen=M.antiDesyncPanelOpen, antiDesyncShield=M.antiDesyncShield, antiDesyncVelocity=M.antiDesyncVelocity, musicPanelOpen=M.musicPanelOpen,
        pingPanelOpen=M.pingPanelOpen==true,
        pingPower=tonumber(M.pingPower) or 100000,
        pingInterval=tonumber(M.pingInterval) or 0.125,
        vynxLaggerPanelOpen=M.vynxLaggerPanelOpen==true,
        vynxLaggerLevel=M.vynxLaggerLevel or "Mid",
        vynxLaggerKeybindKb=M.vynxLaggerKeybindKb or "V",
        pingKeybindKb=M.pingKeybindKb or "F",
        pingKeybindGp=M.pingKeybindGp or "ButtonR2",
        pingAutoBrainrot=M.pingAutoBrainrot~=false,
        musicLastTrackId=M.musicLastTrackId, musicVolume=tonumber(M.musicVolume) or 0.8, musicWasPlaying=M.musicWasPlaying==true, musicPanelPos=M.musicPanelPos, menuPos=M.menuPos, pingPanelPos=M.pingPanelPos, vynxLaggerPanelPos=M.vynxLaggerPanelPos, btnPos=M._btnPosCache,
        semiHoldMin=M.Semi.holdMin, semiHoldMax=M.Semi.holdMax,
        semiEntryDelay=M.Semi.entryDelay,
        semiPrimeRange=M.Semi.primeRange,
        semiRadius=math.min(M.Semi.radius, 10),
        lineESPEnabled=M.lineESPEnabled,
        speedESPEnabled=M.speedESPEnabled,
        autoResetOnDeath=false,
        animPack=M.animPack,
        headlessEnabled=M.headlessEnabled,
        korbloxEnabled=M.korbloxEnabled,
        customAccessoryIds=M.customAccessoryIds or {},
        presetAccessoryOn=M.presetAccessoryOn or {},
        skinKeepOnRespawn=M.skinKeepOnRespawn ~= false,
        customShirtId=M.customShirtId,
        customPantsId=M.customPantsId,
        bodySkinPreset=M.bodySkinPreset or "None",
        bodySkinCustomRGB=M.bodySkinCustomRGB or {163,162,165},
        bypassAimbotEnabled=M.bypassAimbotEnabled,
        animPackEnabled=M.animPackEnabled,
        dropBrainrotKey=ks(M.KB.DropBrainrot), autoLeftKey=ks(M.KB.AutoLeft),
        autoRightKey=ks(M.KB.AutoRight), autoBatKey=ks(M.KB.AutoBat),
        bodyLockKey=ks(M.KB.BodyLock),
        laggerToggleKey=ks(M.KB.LaggerToggle), laggerCarryKey=ks(M.KB.LaggerCarry), tpFloorKey=ks(M.KB.TPFloor),
        guiHideKey=ks(M.KB.GuiHide),
        speedToggleKey=ks(M.KB.SpeedToggle), bypassAimbotKey=ks(M.KB.BypassAimbot),
    }
    pcall(function() writefile(CHERRY_CONFIG_NAME, HS:JSONEncode(cfg)) end)
end

M.saveConfig = saveCherryConfig

-- Exportar Vynx API para integración
_G.VynxLoaded = true
_G.VynxAPI = M

-- Carga de configuración y ejecución
repeat task.wait() until game:IsLoaded()
task.wait(0.5)
loadCherryConfig()

do
    local forced = M.DEFAULT_BG_ID or 78248012786524
    local oldDefault = 127281366474870
    local cur = tonumber(M.customBgId)
    if not cur or cur == oldDefault or cur == 0 then
        M.customBgId = forced
    end
end

if M.speedUIMode ~= "Customizer" then
    M.speedUIMode = "Original"
end

if M.speedUIMode == "Customizer" then
    M.speedBoosterEnabled = true
    M.carrySpeedActive = false
    M.laggerCarryActive = false
    M.laggerModeEnabled = false
    M.speedBoosterPath = "Normal"
else
    M.speedBoosterEnabled = false
end

M.introGUIEnabled = true
M.introSoundEnabled = true
do
    local okIntro, errIntro = pcall(function()
        M.playIntro()
    end)
    if not okIntro then
        warn("[VYNX] playIntro error: ", errIntro)
        print("[VYNX] playIntro error: ", errIntro)
    end
end
M.bodyLockEnabled = false
pcall(function() M.stopBodyLock() end)

do
    local tn = M._savedTheme or M.colorScheme or CherryConfig.Theme
    if tn == "Default" then tn = "Red" elseif tn == "Forest" then tn = "Green" end
    if tn and CHERRY_THEMES[tn] then
        CherryConfig.Theme = tn
        M.colorScheme = tn
        M._savedTheme = tn
    end
end
applyAccentFromTheme()

do
    local a = M.UI_ACCENT or (M.Theme and M.Theme.Accent)
    if a then
        UI_ACCENT = a
        CHERRY_ACCENT = a
        UI_ACCENT_DIM = M.UI_ACCENT_DIM or a
        UI_TEXT_SECTION = a
    end
    if M.UI_BG_DARK then UI_BG_DARK = M.UI_BG_DARK end
    if M.UI_ROW_BG then UI_ROW_BG = M.UI_ROW_BG end
    if M.UI_BTN_BG then UI_BTN_BG = M.UI_BTN_BG end
    if M.UI_TOGGLE_OFF then UI_TOGGLE_OFF = M.UI_TOGGLE_OFF end
    if M.UI_GRAD_TOP then UI_GRAD_TOP = M.UI_GRAD_TOP end
    if M.UI_GRAD_BOT then UI_GRAD_BOT = M.UI_GRAD_BOT end
end
pcall(saveCherryConfig)

M.antiDieEnabled = true
pcall(function() M.startAntiDie() end)
M.antiFlingEnabled = true
pcall(function() if M.startAntiFling then M.startAntiFling() end end)

M.menuOpen = true
local okGui, errGui = pcall(function()
    M.buildGui()
end)
if not okGui then
    warn("[VYNX] buildGui error: ", errGui)
    print("[VYNX] buildGui error: ", errGui)
end

pcall(function()
    if M.mainFrame then
        M.mainFrame.Visible = true
        M.menuOpen = true
    end
end)
pcall(function()
    if M.mobileButtonsEnabled then
        M.buildMobileButtons()
    end
end)
pcall(function()
    if M.applyStealBarTheme then M.applyStealBarTheme(UI_ACCENT) end
    if M.updateHeadTheme then M.updateHeadTheme() end
    if M.mainFrame then M.recolorBlacksToTheme(M.mainFrame) end
    if M.statusGui and M.applyStealBarTheme then M.applyStealBarTheme(UI_ACCENT) end
end)
if M.mobileButtonsEnabled then pcall(function() M.buildMobileButtons() end) end

pcall(function()
    if M._autoSaveConn then M._autoSaveConn:Disconnect() end
    M._autoSaveConn = RunService.Heartbeat:Connect(function()
        local now = tick()
        if not M._lastAutoSaveAt then M._lastAutoSaveAt = now end
        if now - M._lastAutoSaveAt < 8 then return end
        M._lastAutoSaveAt = now
        pcall(function()
            if M.mobGuiRef then M.saveBtnPositions() end
        end)
        pcall(saveCherryConfig)
    end)
end)
if M.antiRagdollEnabled then M.startAntiRagdoll() end
if M.ragdollTPBaseEnabled then M.startRagdollTPBase() end
if M.infJumpEnabled then
    M.infJumpMode = "hold"
    M.startHoldInfJump()
end
if M.medusaCounterEnabled then M.setupMedusa(player.Character) end
if M.batCounterEnabled then M.startBatCounter() end
M.unwalkEnabled = false
pcall(function() M.forceRestoreWalkAnims(player.Character) end)
if M.autoTPEnabled then M.startAutoTP() end
if M.autoBatEnabled then M.queueAutoBatStart() end
if M.autoLeftEnabled then M.startAutoLeft() end
if M.autoRightEnabled then M.startAutoRight() end
if M.Steal.AutoStealEnabled then M.startAutoSteal() end
if M.bypassAimbotEnabled then M.startBypassAimbot() end
M.bodyLockEnabled = false
pcall(function() M.stopBodyLock() end)
if M.hardHitEnabled then M.startHardHit() end
if M.ultraModeEnabled then M.enableUltraMode() end
pcall(function()
    M.antiDesyncPanelOpen = false
    if M.antiDesyncGui then pcall(function() M.antiDesyncGui:Destroy() end) end
    M.antiDesyncGui, M.antiDesyncMain = nil, nil
end)
pcall(function() M.musicPanelOpen = false end)
pcall(function()
    local wantPing = M.pingPanelOpen == true
    M.buildPingLaggerUI()
    if wantPing then
        M.setPingPanelOpen(true)
    else
        if M.pingMain then M.pingMain.Visible = false end
        if M.setPingPanelVisual then pcall(function() M.setPingPanelVisual(false) end) end
    end
end)
pcall(function()
    local wantLag = M.vynxLaggerPanelOpen == true
    M.buildVynxLaggerUI()
    if wantLag then
        M.setVynxLaggerPanelOpen(true)
    else
        if M.vynxLaggerMain then M.vynxLaggerMain.Visible = false end
        if M.setVynxLaggerPanelVisual then pcall(function() M.setVynxLaggerPanelVisual(false) end) end
    end
end)

task.defer(function()
    task.wait(0.35)
    pcall(function()
        if M.pingPanelOpen then
            if not M.pingGui or not M.pingGui.Parent then M.buildPingLaggerUI() end
            if M.pingMain then M.pingMain.Visible = true end
            if M.setPingPanelVisual then M.setPingPanelVisual(true) end
        end
        if M.vynxLaggerPanelOpen then
            if not M.vynxLaggerGui or not M.vynxLaggerGui.Parent then M.buildVynxLaggerUI() end
            if M.vynxLaggerMain then M.vynxLaggerMain.Visible = true end
            if M.setVynxLaggerPanelVisual then M.setVynxLaggerPanelVisual(true) end
        end
    end)
end)
if M.antiKickEnabled then M.enableAntiKick() end
M.antiDieEnabled = true; pcall(M.startAntiDie)
M.antiFlingEnabled = true; pcall(function() M.startAntiFling() end)
if M.antiLagEnabled then M.enableAntiLag() end
if M.nukeOptEnabled then pcall(M.enableNukeOptimizer) end
if M.antiSummerBaseEnabled then M.enableAntiSummerBase() end
if M.stretchRezEnabled then M.enableStretchRez() end
if M.removeAccEnabled then M.startRemoveAcc() end
if M.autoResetOnDeath then setupDeathReset() end

M.unwalkEnabled = false
if M.animPackEnabled and M.animPack and M.PACKS[M.animPack] then
    task.wait(0.5)
    M.applyAnimPack(M.animPack)
else
    local char = player.Character
    if char then
        pcall(function() M.forceRestoreWalkAnims(char) end)
    end
end
pcall(function() M.forceRestoreWalkAnims(player.Character) end)

if M.headlessEnabled or M.korbloxEnabled then
    task.wait(0.3)
    M.applyCharterToChar(player.Character)
end
task.defer(function()
    local char = player.Character
    if not char then return end
    if M.customAccessoryIds and #M.customAccessoryIds > 0 then
        M.applyAllCustomAccessories(char)
    end
    if M.customShirtId or M.customPantsId then
        M.applyCustomClothing(char)
    end
end)

M.CandyApplyCustomSky(M.currentSkyTheme)
if M.showPlayerSpeeds then M.togglePlayerSpeeds(true) end
if M.playerESPEnabled then M.toggleESP(true) end
pcall(function() M.toggleAvatarESP(M.avatarESPEnabled ~= false) end)

M.updateStatusRadius()
M.startHeadSpeedUpdates()

if player.Character then
    M.setupHeadIndicator(player.Character)
    M.setupRagdollTriggers()
end
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    M.setupHeadIndicator(char)
    M.setupRagdollTriggers()
    if M.medusaCounterEnabled then M.setupMedusa(char) end
    if M.batCounterEnabled then M.startBatCounter() end
    M.unwalkEnabled = false
    pcall(function() M.forceRestoreWalkAnims(char) end)
    if M.autoResetOnDeath then setupDeathReset() end
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
    M.bodyLockEnabled = false
    pcall(function() M.stopBodyLock() end)
    if M.hardHitEnabled then
        task.wait(0.2)
        M.hideHardHitRing()
        M.showHardHitRing()
        if not M._hardHitConn then M.startHardHit() end
    end
end)

do
    local _ncAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        _ncAcc = _ncAcc + dt
        if _ncAcc < 0.4 then return end
        _ncAcc = 0
        local myChar = player.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if myRoot and hrp and (myRoot.Position - hrp.Position).Magnitude > 45 then
                else
                    if hrp then hrp.CanCollide = false end
                    local head = p.Character:FindFirstChild("Head")
                    if head then head.CanCollide = false end
                end
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
M.applySpeedMethod = applySpeedMethod
M.destroySpeedObjects = destroySpeedObjects

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
            if typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then
                M.cursedResetRemote=self
                local args = {...}
                for i = 1, select("#", ...) do
                    local a = args[i]
                    if a == M.CURSED_RESET_GUID or a == "balloon" or (type(a)=="string" and a:find("f888ee6e", 1, true)) then
                        return
                    end
                end
            end
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
    while task.wait(12) do pcall(saveCherryConfig) end
end)

M.applyFOV()
task.spawn(function()
    while true do
        task.wait(8)
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
            task.wait(10)
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
    if not (M.headIndicator and M.headIndicator.mode) then return end
    local text = "NORMAL MODE"
    if M.laggerCarryActive then
        text = "LAGGER CARRY"
    elseif M.laggerModeEnabled then
        text = "LAGGER MODE"
    elseif M.carrySpeedActive then
        text = "CARRY MODE"
    end
    M.headIndicator.mode.Text = text
    M.headIndicator.mode.TextColor3 = Color3.fromRGB(255, 255, 255)
    if M.headIndicator.speed then
        M.headIndicator.speed.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

pcall(function()
    M.refreshWalkSpeedAutoSwitch()
    if M.autoCarryEnemyBaseEnabled then
        M.startAutoCarryEnemyBase()
    end
    if M.customFontSelected and M.customFontSelected ~= "None" then
        task.spawn(function()
            task.wait(0.4)
            pcall(function() M.applyCustomFont(M.customFontSelected) end)
        end)
    end
end)

if not M._voidSafetyStarted then
    M._voidSafetyStarted = true
    local _vsAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        _vsAcc = _vsAcc + (dt or 0.016)
        if _vsAcc < 0.08 then return end
        _vsAcc = 0
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if hum.Health <= 0 then return end
        
        if hrp.Position.Y < -60 then
            pcall(function()
                local ySafe = 25
                hrp.CFrame = CFrame.new(hrp.Position.X, ySafe, hrp.Position.Z) * (hrp.CFrame - hrp.CFrame.Position)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            return
        end
        
        if M.dropActive then return end
        local v = hrp.AssemblyLinearVelocity
        local mag = v.Magnitude
        local cfgMax = math.max(tonumber(M.NS) or 60, tonumber(M.CS) or 30, tonumber(M.LAGGER_CARRY_SPEED) or 25) * 3
        local hardCap = math.max(500, cfgMax)
        if mag > hardCap then
            pcall(function()
                hrp.AssemblyLinearVelocity = v.Unit * math.min(mag, hardCap)
            end)
        elseif v.Y < -250 then
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.new(v.X, -80, v.Z)
            end)
        end
        
        local p = hrp.Position
        if p ~= p or math.abs(p.X) > 1e5 or math.abs(p.Z) > 1e5 then
            pcall(function()
                hrp.CFrame = CFrame.new(0, 30, 0)
                hrp.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end)
end

do
    local g = (getgenv and getgenv()) or _G
    g.__VYNX_UNLOAD = function()
        pcall(function()
            if M._allConns then
                for _, c in ipairs(M._allConns) do pcall(function() c:Disconnect() end) end
                M._allConns = {}
            end
        end)
        pcall(function()
            local pg = player:FindFirstChild("PlayerGui")
            if pg then
                for _, c in ipairs(pg:GetChildren()) do
                    if c:IsA("ScreenGui") and (c.Name:find("Vynx") or c.Name:find("Movee") or c.Name:find("Cherry") or c.Name:find("Steal")) then
                        pcall(function() c:Destroy() end)
                    end
                end
            end
        end)
    end
end
M.autoResetOnDeath = false
M.medusaResetEnabled = false
pcall(setupDeathReset)
pcall(function() M.startAntiDie() end)
M.unwalkEnabled = false
pcall(function() if M.forceRestoreWalkAnims then M.forceRestoreWalkAnims(player.Character) end end)
print("VYNX 2.1 loaded successfully!")
return M